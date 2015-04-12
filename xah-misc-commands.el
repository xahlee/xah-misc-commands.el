;;; xah-misc-commands.el --- xah's misc interactive commands that helps writing or coding. -*- coding: utf-8 -*-

;; Copyright © 2013 by Xah Lee

;; Author: Xah Lee ( http://xahlee.org/ )
;; Created: 2013-07-24
;; Keywords:

;; You can redistribute this program and/or modify it. Please give credit and link. Thanks.

;;; DESCRIPTION

;; misc intercative commands

;; donate $3 please. Paypal to xah@xahlee.org , thanks.

;;; INSTALL

;;; HISTORY

;; version 1.0, 2013-07-24 First version. Was from my emacs init.


;;; Code:

;; -*- coding: utf-8 -*-
;; some elisp string replacement functions

;; 2007-06
;;   Xah Lee
;; ∑ http://xahlee.org/

(require 'xfrp_find_replace_pairs)
(require 'xeu_elisp_util)

(defun xah-cycle-camel-style-case ()
  "Cyclically replace {camelStyle, camel_style} current word or text selection.
actually, currently just change from camel to underscore. no cycle
WARNING: this command is currently unstable."
  (interactive)
  ;; this function sets a property 「'state」. Possible values are 0 to length of char_array.
  (let (input_text
        replace_text char_array p1 p2 current_state next_state changeFrom
        changeTo startedWithRegion-p )

    (if (region-active-p)
        (progn
          (setq startedWithRegion-p t )
          (setq p1 (region-beginning))
          (setq p2 (region-end)))
      (let ((ξboundary (bounds-of-thing-at-point 'word)))
        (setq startedWithRegion-p nil )
        (setq p1 (car ξboundary))
        (setq p2 (cdr ξboundary))))

    (setq char_array [" " "_"])

    (setq current_state
          (if (get 'xah-cycle-camel-style-case 'state)
              (get 'xah-cycle-camel-style-case 'state)
            0))
    (setq next_state (% (+ current_state 1) (length char_array)))

    (setq changeFrom (elt char_array current_state ))
    (setq changeTo (elt char_array next_state ))

    (setq input_text (buffer-substring-no-properties p1 p2))

    (let ((case-fold-search nil))
      (cond
       ;; camel to underscore
       (
        (equal current_state 0)
        (setq replace_text (replace-regexp-in-string "\\([A-Z]\\)" "_\\1" input_text))
        (setq replace_text (downcase replace_text)))
       ((equal current_state 1)
        (setq replace_text (replace-regexp-in-string "_\\([a-z]\\)" "\\,(upcase \\1)" input_text))
        ;; (setq replace_text (downcase replace_text) )
        )))

    (save-restriction
      (narrow-to-region p1 p2)
      (delete-region (point-min) (point-max))
      (insert replace_text))

    (put 'xah-cycle-camel-style-case 'state next_state)
    ) )

;; (defun xah-convert-chinese-numeral (p1 p2 &optional φ-to-direction)
;;   "Replace punctuation from/to Chinese/English numeral.

;; When called interactively, do current text block (paragraph) or text selection. The conversion direction is automatically determined.

;; If `universal-argument' is called:
;;  no C-u → Automatic.
;;  C-u → to English
;;  C-u 1 → to English
;;  C-u 2 → to Chinese

;; When called in lisp code, p1 p2 are region begin/end positions. φ-to-direction must be any of the following values: 「\"chinese\"」, 「\"english\"」, 「\"auto\"」.

;; See also: `xah-remove-punctuation-trailing-redundant-space'."
;;   (interactive
;;    (let ( (ξboundary (get-selection-or-unit 'block)))
;;      (list (elt ξboundary 1) (elt ξboundary 2)
;;            (cond
;;             ((equal current-prefix-arg nil) "auto")
;;             ((equal current-prefix-arg '(4)) "english")
;;             ((equal current-prefix-arg 1) "english")
;;             ((equal current-prefix-arg 2) "chinese")
;;             (t "chinese")
;;             )
;;            ) ) )
;;   (let* (
;;         (ξinput-str (buffer-substring-no-properties p1 p2))
;; (chinese-numeral-simple "○一二三四五六七八九十")
;; (english-numeral "0123456789")

;;         (ξenglish-chinese-punctuation-map
;;          [
;;           [":</" "：</"]
;;           ]
;;          ))

;; ;; (let* (
;; ;;        (chinese-numeral-simple "○一二三四五六七八九十")
;; ;;        (english-numeral "0123456789")
;; ;;        (result (make-vector (length chinese-numeral-simple) nil))
;; ;;        )
;; ;;   (dotimes (ii (- (length chinese-numeral-simple) 1) )
;; ;;     (aset result ii
;; ;;           (vector
;; ;;            (char-to-string (elt chinese-numeral-simple ii ))
;; ;;            (char-to-string (elt english-numeral ii )) ))
;; ;;     )
;; ;;   result
;; ;;   )

;; ;; [["○" "0"] ["一" "1"] ["二" "2"] ["三" "3"] ["四" "4"] ["五" "5"] ["六" "6"] ["七" "7"] ["八" "8"] ["九" "9"] nil]

;;     (xah-replace-pairs-region p1 p2
;;                               (cond
;;                                ((string= φ-to-direction "chinese") ξenglish-chinese-punctuation-map)
;;                                ((string= φ-to-direction "english") (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξenglish-chinese-punctuation-map))
;;                                ((string= φ-to-direction "auto")
;;                                 (if (string-match ",\\|. " ξinput-str)
;;                                   ξenglish-chinese-punctuation-map
;;                                   (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξenglish-chinese-punctuation-map)
;;                                   ))

;;                                (t (user-error "Your 3rd argument 「%s」 isn't valid" φ-to-direction)) ) ) ) )

(defun xah-convert-english-chinese-punctuation (p1 p2 &optional φto-direction)
  "Convert punctuation from/to English/Chinese characters.

When called interactively, do current text block or selection. The conversion direction is automatically determined.

If `universal-argument' is called, ask user for change direction.

When called in lisp code, p1 p2 are region begin/end positions. φto-direction must be any of the following values: 「\"chinese\"」, 「\"english\"」, 「\"auto\"」.

See also: `xah-remove-punctuation-trailing-redundant-space'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
Version 2015-02-04
"
  (interactive
   (let ( (ξboundary (get-selection-or-unit 'block)))
     (list (elt ξboundary 1) (elt ξboundary 2)
           (if current-prefix-arg
               (ido-completing-read
                "Change to: "
                '( "english"  "chinese")
                "PREDICATE"
                "REQUIRE-MATCH")
             "auto"
             ))))
  (let (
        (ξinput-str (buffer-substring-no-properties p1 p2))
        (ξenglish-chinese-punctuation-map
         [
          [". " "。"]
          [".\n" "。\n"]
          [", " "，"]
          [",\n" "，\n"]
          [": " "："]
          ["; " "；"]
          ["? " "？"] ; no space after
          ["! " "！"]

          ;; for inside HTML
          [".</" "。</"]
          ["?</" "？</"]
          [":</" "：</"]
          ]
         ))

    (when (string= φto-direction "auto")
      (setq
       φto-direction
       (if
           (or (string-match "。" ξinput-str)
               (string-match "，" ξinput-str)
               (string-match "？" ξinput-str)
               (string-match "！" ξinput-str))
           "english"
         "chinese")))

    (xah-replace-pairs-region
     p1 p2
     (cond
      ((string= φto-direction "chinese") ξenglish-chinese-punctuation-map)
      ((string= φto-direction "english") (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξenglish-chinese-punctuation-map))
      (t (user-error "Your 3rd argument 「%s」 isn't valid" φto-direction))))))

(defun xah-convert-asian/ascii-space (p1 p2)
  "Change all space characters between Asian Ideographic one to ASCII one.
Works on current block or text selection.

When called in emacs lisp code, the p1 p2 are cursor positions for region.

See also `xah-convert-english-chinese-punctuation'
 `xah-remove-punctuation-trailing-redundant-space'
"
  (interactive
   (let ( (ξboundary (get-selection-or-unit 'block)))
     (list (elt ξboundary 1) (elt ξboundary 2))))
  (let ((ξ-space-char-map
         [
          ["　" " "]
          ]
         ))
    (replace-regexp-pairs-region p1 p2
                                 (if (string-match "　" (buffer-substring-no-properties p1 p2))
                                     ξ-space-char-map
                                   (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξ-space-char-map))
                                 "FIXEDCASE" "LITERAL")))

(defun xah-remove-punctuation-trailing-redundant-space (φp1 φp2)
  "Remove redundant whitespace after punctuation.
Works on current block or text selection.

When called in emacs lisp code, the φp1 φp2 are cursor positions for region.

See also `xah-convert-english-chinese-punctuation'.

URL `http://ergoemacs.org/emacs/elisp_convert_chinese_punctuation.html'
version 2015-02-04
"
  (interactive
   (let ((ξboundary (get-selection-or-unit 'block)))
     (list (elt ξboundary 1) (elt ξboundary 2))))
  (replace-regexp-pairs-region φp1 φp2
                               [
                                ;; clean up. Remove extra space.
                                [" +," ","]
                                [",  +" ", "]
                                ["?  +" "? "]
                                ["!  +" "! "]
                                ["\\.  +" ". "]

                                ;; fullwidth punctuations
                                ["， +" "，"]
                                ["。 +" "。"]
                                ["： +" "："]
                                ["？ +" "？"]
                                ["； +" "；"]
                                ["！ +" "！"]
                                ["、 +" "、"]
                                ]
                               "FIXEDCASE" "LITERAL"))

(defun xah-convert-fullwidth-chars (φp1 φp2 &optional φto-direction)
  "Convert ASCII chars to/from Unicode fullwidth version.

When called interactively, do text selection or text block (paragraph).

The conversion direction is determined like this: if the command has been repeated, then toggle. Else, always do to-Unicode direction.

If `universal-argument' is called:

 no C-u → Automatic.
 C-u → to ASCII
 C-u 1 → to ASCII
 C-u 2 → to Unicode

When called in lisp code, φp1 φp2 are region begin/end positions. φto-direction must be any of the following values: 「\"unicode\"」, 「\"ascii\"」, 「\"auto\"」.

See also: `xah-remove-punctuation-trailing-redundant-space'."
  (interactive
   (let ( (ξboundary (get-selection-or-unit 'block)))
     (list (elt ξboundary 1) (elt ξboundary 2)
           (cond
            ((equal current-prefix-arg nil) "auto")
            ((equal current-prefix-arg '(4)) "ascii")
            ((equal current-prefix-arg 1) "ascii")
            ((equal current-prefix-arg 2) "unicode")
            (t "unicode")))))
  (let* (
         (ξ-ascii-unicode-map
          [
           ["0" "０"] ["1" "１"] ["2" "２"] ["3" "３"] ["4" "４"] ["5" "５"] ["6" "６"] ["7" "７"] ["8" "８"] ["9" "９"]
           ["A" "Ａ"] ["B" "Ｂ"] ["C" "Ｃ"] ["D" "Ｄ"] ["E" "Ｅ"] ["F" "Ｆ"] ["G" "Ｇ"] ["H" "Ｈ"] ["I" "Ｉ"] ["J" "Ｊ"] ["K" "Ｋ"] ["L" "Ｌ"] ["M" "Ｍ"] ["N" "Ｎ"] ["O" "Ｏ"] ["P" "Ｐ"] ["Q" "Ｑ"] ["R" "Ｒ"] ["S" "Ｓ"] ["T" "Ｔ"] ["U" "Ｕ"] ["V" "Ｖ"] ["W" "Ｗ"] ["X" "Ｘ"] ["Y" "Ｙ"] ["Z" "Ｚ"]
           ["a" "ａ"] ["b" "ｂ"] ["c" "ｃ"] ["d" "ｄ"] ["e" "ｅ"] ["f" "ｆ"] ["g" "ｇ"] ["h" "ｈ"] ["i" "ｉ"] ["j" "ｊ"] ["k" "ｋ"] ["l" "ｌ"] ["m" "ｍ"] ["n" "ｎ"] ["o" "ｏ"] ["p" "ｐ"] ["q" "ｑ"] ["r" "ｒ"] ["s" "ｓ"] ["t" "ｔ"] ["u" "ｕ"] ["v" "ｖ"] ["w" "ｗ"] ["x" "ｘ"] ["y" "ｙ"] ["z" "ｚ"]
           ["," "，"] ["." "．"] [":" "："] [";" "；"] ["!" "！"] ["?" "？"] ["\"" "＂"] ["'" "＇"] ["`" "｀"] ["^" "＾"] ["~" "～"] ["¯" "￣"] ["_" "＿"]
           ["&" "＆"] ["@" "＠"] ["#" "＃"] ["%" "％"] ["+" "＋"] ["-" "－"] ["*" "＊"] ["=" "＝"] ["<" "＜"] [">" "＞"] ["(" "（"] [")" "）"] ["[" "［"] ["]" "］"] ["{" "｛"] ["}" "｝"] ["(" "｟"] [")" "｠"] ["|" "｜"] ["¦" "￤"] ["/" "／"] ["\\" "＼"] ["¬" "￢"] ["$" "＄"] ["£" "￡"] ["¢" "￠"] ["₩" "￦"] ["¥" "￥"]
           ]
          )
         (ξ-reverse-map (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξ-ascii-unicode-map))

         (cmdStates ["to-unicode" "to-ascii"])
         (stateBefore (if (get 'xah-convert-fullwidth-chars 'state) (get 'xah-convert-fullwidth-chars 'state) 0))
         (stateAfter (% (+ stateBefore (length cmdStates) 1) (length cmdStates))))

  ;"０\\|１\\|２\\|３\\|４\\|５\\|６\\|７\\|８\\|９\\|Ａ\\|Ｂ\\|Ｃ\\|Ｄ\\|Ｅ\\|Ｆ\\|Ｇ\\|Ｈ\\|Ｉ\\|Ｊ\\|Ｋ\\|Ｌ\\|Ｍ\\|Ｎ\\|Ｏ\\|Ｐ\\|Ｑ\\|Ｒ\\|Ｓ\\|Ｔ\\|Ｕ\\|Ｖ\\|Ｗ\\|Ｘ\\|Ｙ\\|Ｚ\\|ａ\\|ｂ\\|ｃ\\|ｄ\\|ｅ\\|ｆ\\|ｇ\\|ｈ\\|ｉ\\|ｊ\\|ｋ\\|ｌ\\|ｍ\\|ｎ\\|ｏ\\|ｐ\\|ｑ\\|ｒ\\|ｓ\\|ｔ\\|ｕ\\|ｖ\\|ｗ\\|ｘ\\|ｙ\\|ｚ"

  ;(message "before %s" stateBefore)
  ;(message "after %s" stateAfter)
  ;(message "φto-direction %s" φto-direction)
  ;(message "real-this-command  %s" this-command)
  ;(message "real-last-command %s" last-command)

    (let ((case-fold-search nil))
      (xah-replace-pairs-region
       φp1 φp2
       (cond
        ((string= φto-direction "unicode") ξ-ascii-unicode-map)
        ((string= φto-direction "ascii") ξ-reverse-map)
        ((string= φto-direction "auto")
         (if (equal this-command last-command)
             (if (eq stateBefore 0)
                 ξ-ascii-unicode-map
               ξ-reverse-map
               )
           ξ-ascii-unicode-map
           ))
        (t (user-error "Your 3rd argument 「%s」 isn't valid" φto-direction)))))
    (put 'xah-convert-fullwidth-chars 'state stateAfter)))

(defvar xah-bracketsList nil "a list of bracket pairs. ⁖ () {} [] “” ‘’ ‹› «» 「」 『』 ….")
(setq xah-bracketsList '( "()" "{}" "[]" "<>" "“”" "‘’" "‹›" "«»" "「」" "『』" "【】" "〖〗" "〈〉" "《》" "〔〕" "⦅⦆" "〚〛" "⦃⦄"
"〈〉" "⦑⦒" "⧼⧽"
"⟦⟧" "⟨⟩" "⟪⟫" "⟮⟯" "⟬⟭" "❛❜" "❝❞" "❨❩" "❪❫" "❴❵" "❬❭" "❮❯" "❰❱"
))

(defun xah-remove-quotes-or-brackets (φbracketType)
  "Remove quotes/brackets
Works on current block or text selection.
"
  (interactive
   (list (ido-completing-read "from:" xah-bracketsList) ) )
  (let* (
         (ξboundary (get-selection-or-unit 'block))
         (p1 (elt ξboundary 1))
         (p2 (elt ξboundary 2))
         )
    (replace-regexp-pairs-region p1 p2
                                 (vector
                                  (vector (substring φbracketType 0 1) "")
                                  (vector (substring φbracketType 1 2) "")
                                  )
                                 "FIXEDCASE" "LITERAL")
    ) )

(defun xah-change-bracket-pairs (φfromType φtoType)
  "Change bracket pairs from one type to another on text selection or text block.
For example, change all parenthesis () to square brackets [].

When called in lisp program, φfromType and φtoType is a string of a bracket pair. ⁖ \"()\", likewise for φtoType."
  (interactive
   (let ( )
     (list
      (ido-completing-read "Replace this:" xah-bracketsList )
      (ido-completing-read "To:" xah-bracketsList ) ) ) )
  (let* (
         (ξboundary (get-selection-or-unit 'block))
         (p1 (elt ξboundary 1))
         (p2 (elt ξboundary 2))
         (changePairs (vector
                 (vector (char-to-string (elt φfromType 0)) (char-to-string (elt φtoType 0)))
                 (vector (char-to-string (elt φfromType 1)) (char-to-string (elt φtoType 1)))
                 ))
         )
    (xah-replace-pairs-region p1 p2 changePairs) ) )

(defun xah-replace-slanted-apostrophe ()
  "Replace some single curly apostrophe to straight version,
in text selection or text block.
Example: 「it’s」 ⇒ 「it's」."
  (interactive "r")
(let (ξboundary p1 p2)
    (setq ξboundary (get-selection-or-unit 'block))
    (setq p1 (elt ξboundary 1) p2 (elt ξboundary 2)  )
    (xah-replace-pairs-region p1 p2 '(
["‘tis" "'tis"]
["’s" "'s"]
["’d" "'d"]
["n’t" "n't"]
["’ve" "'ve"]
["’ll" "'ll"]
["’m" "'m"]
["’re" "'re"]
["s’ " "s' "]))
    )
)

(defun xah-replace-straight-quotes (p1 p2)
  "Replace straight double quotes to curly ones, and others.
Works on current text selection, else the current text block between empty lines.

Examples of changes:
 「\"…\"」 ⇒ 「“…”」
 「...」 ⇒ 「…」
 「I’m」 => 「I'm」
 「--」 ⇒ 「—」
 「~=」 ⇒ 「≈」

 In lisp program, the arguments P1 and P2 are region boundaries."
;; some examples for debug
;; do "‘em all -- done..."
;; I’am not
;; said "can’t have it, can’t, just can’t"
;; ‘I’ve can’t’
  (interactive
   (let ( (ξboundary (get-selection-or-unit 'block)))
     (list (elt ξboundary 1) (elt ξboundary 2) ) ) )
  (save-excursion
    ;; Note: order is important since this is huristic.

    (save-restriction
      (narrow-to-region p1 p2)

      ;; dash and ellipsis etc
      (xah-replace-pairs-region (point-min) (point-max)
                            [
                             ["--" " — "]
                             ["—" " — "]
                             ["..." "…"]
                             [" :)" " ☺"]
                             [" :(" " ☹"]
                             [";)" "😉"]
                             ["e.g." "⁖"]
                             ["~=" "≈"]
                             ])

      (xah-replace-pairs-region (point-min) (point-max)
                            [
                             ["  —  " " — "] ; rid of extra space in em-dash
                             [" , " ", "]
                             ])

      ;; fix GNU style ASCII quotes
      (xah-replace-pairs-region (point-min) (point-max)
                            [
                             ["``" "“"]
                             ["''" "”"]
                             ])

      ;; "straight quote" ⇒ “double quotes”
      (xah-replace-pairs-region (point-min) (point-max)
                            [
                             ["\n\"" "\n“"]
                             [">\"" ">“"]
                             ["(\"" "(“"]
                             [" \"" " “"]

                             ["\" " "” "]
                             ["\"," "”,"]
                             ["\"." "”."]
                             ["\"?" "”?"]
                             ["\";" "”;"]
                             ["\":" "”:"]
                             ["\")" "”)"]
                             ["\"]" "”]"]
                             [".\"" ".”"]
                             [",\"" ",”"]
                             ["!\"" "!”"]
                             ["?\"" "?”"]
                             ["\"<" "”<"]
                             ;; ";
                             ["\"\n" "”\n"]
                             ])

      ;; fix straight double quotes by regex
      (replace-regexp-pairs-region (point-min) (point-max)
                                   [
                                    ["\\`\"" "“"]
                                    ])

      ;; fix single quotes to curly
      (xah-replace-pairs-region (point-min) (point-max)
                            [
                             [">\'" ">‘"]
                             [" \'" " ‘"]
                             ["\' " "’ "]
                             ["\'," "’,"]
                             [".\'" ".’"]
                             ["!\'" "!’"]
                             ["?\'" "?’"]
                             ["(\'" "(‘"]
                             ["\')" "’)"]
                             ["\']" "’]"]
                             ])

      ;; fix apostrophe
      (replace-regexp-pairs-region (point-min) (point-max)
                                   [
                                    ["\\bcan’t\\b" "can't"]
                                    ["\\bdon’t\\b" "don't"]
                                    ["\\bdoesn’t\\b" "doesn't"]
                                    ["\\bain’t\\b" "ain't"]
                                    ["\\bdidn’t\\b" "didn't"]
                                    ["\\baren’t\\b" "aren't"]
                                    ["\\bwasn’t\\b" "wasn't"]
                                    ["\\bweren’t\\b" "weren't"]
                                    ["\\bcouldn’t\\b" "couldn't"]
                                    ["\\bshouldn’t\\b" "shouldn't"]

                                    ["\\b’ve\\b" "'ve"]
                                    ["\\b’re\\b" "'re"]
                                    ["\\b‘em\\b" "'em"]
                                    ["\\b’ll\\b" "'ll"]
                                    ["\\b’m\\b" "'m"]
                                    ["\\b’d\\b" "'d"]
                                    ["\\b’s\\b" "'s"]
                                    ["s’ " "s' "]
                                    ["s’\n" "s'\n"]

                                    ["\"$" "”"]
                                    ])

      ;; fix back escaped quotes in code
      (xah-replace-pairs-region (point-min) (point-max)
                                   [
                                    ["\\”" "\\\""]
                                    ])

      ;; fix back. quotes in HTML code
      (replace-regexp-pairs-region (point-min) (point-max)
                                   [
                                    ["” \\([-a-z]+\\)="       "\" \\1="]   ; any 「” some-thing=」
                                    ["=\”" "=\""]
                                    ["/” " "/\" "]
                                    ["\"\\([0-9]+\\)” "     "\"\\1\" "]
                                    ]
                                   )

      (xah-remove-punctuation-trailing-redundant-space (point-min) (point-max) )

      ) ))

(defun xah-replace-profanity ()
  "Replace fuck shit scumbag … in current line or text selection.
"
  (interactive)
  (let* ((ξboundary (get-selection-or-unit 'line))
         (p1 (elt ξboundary 1))
         (p2 (elt ξboundary 2)))
    (xah-replace-pairs-region p1 p2 '(
                                  ["fuck" "f��k"]
                                  ["shit" "sh�t"]
                                  ["motherfucker" "momf��ker"]
                                  ))))

(defun xah-twitterfy (p1 p2 &optional φto-direction)
  "Shorten words for Twitter 140 char limit.

When called interactively, do current text block or selection. The conversion direction is automatically determined.

If `universal-argument' is called, ask for conversion direction.

When called in lisp code, p1 p2 are region begin/end positions. φto-direction must be any of the following values: 「\"auto\"」, 「\"twitterfy\"」, 「\"untwitterfy\"」.

URL `http://ergoemacs.org/emacs/elisp_twitterfy.html'
Version 2015-02-10"
  (interactive
   (let ((ξboundary (get-selection-or-unit 'block)))
     (list
      (elt ξboundary 1)
      (elt ξboundary 2)
      (if current-prefix-arg
          (ido-completing-read
           "direction: "
           '( "twitterfy"  "untwitterfy")
           "PREDICATE"
           "REQUIRE-MATCH")
        "auto"
        ))))
  (let (
        (ξinput-str (buffer-substring-no-properties p1 p2))
        (ξtwitterfy-map
         [
          [" are " " r "]
          [" are, " " r,"]
          [" you " " u "]
          [" you," " u,"]
          [" you." " u."]
          [" to " " 2 "]
          [" you." " u。"]
          [" your" " ur "]
          [" and " "＆"]
          ["because" "cuz"]
          [" at " " @ "]
          [" love " " ♥ "]
          [" one " " 1 "]
          [" two " " 2 "]
          [" three " " 3 "]
          [" four " " 4 "]
          [" zero " " 0 "]
          [", " "，"]
          ["..." "…"]
          [". " "。"]
          ["? " "？"]
          [": " "："]
          ["! " "！"]]
         ))

    (when (string= φto-direction "auto")
      (if
          (or
              (string-match "。" ξinput-str)
              (string-match "，" ξinput-str)
              (string-match "？" ξinput-str)
              (string-match "！" ξinput-str))
          (setq φto-direction "untwitterfy")
        (setq φto-direction "twitterfy")))
    (xah-replace-pairs-region
     p1 p2
     (cond
      ((string= φto-direction "twitterfy") ξtwitterfy-map)
      ((string= φto-direction "untwitterfy") (mapcar (lambda (ξpair) (vector (elt ξpair 1) (elt ξpair 0))) ξtwitterfy-map))
      (t (user-error "Your 3rd argument 「%s」 isn't valid" φto-direction))))))

(defun xah-remove-vowel-old (&optional ξstring ξfrom ξto)
  "Remove the following letters: {a e i o u}.

When called interactively, work on current text block or text selection. (a “text block” is text between empty lines)

When called in lisp code, if ξstring is non-nil, returns a changed string.  If ξstring nil, change the text in the region between positions ξfrom ξto."
  (interactive
   (if (region-active-p)
       (list nil (region-beginning) (region-end))
     (let ((ξboundary (bounds-of-thing-at-point 'paragraph)))
       (list nil (car ξboundary) (cdr ξboundary)))))

  (let (ξwork-on-string-p ξinput-str ξoutput-str)
    (setq ξwork-on-string-p (if ξstring t nil))
    (setq ξinput-str (if ξwork-on-string-p ξstring (buffer-substring-no-properties ξfrom ξto)))
    (setq ξoutput-str
          (let ((case-fold-search t))
            (replace-regexp-in-string "a\\|e\\|i\\|o\\|u\\|" "" ξinput-str)))

    (if ξwork-on-string-p
        ξoutput-str
      (save-excursion
        (delete-region ξfrom ξto)
        (goto-char ξfrom)
        (insert ξoutput-str)))))

(defun xah-remove-vowel (ξstring &optional ξfrom-to-pair)
  "Remove the following letters: {a e i o u}.

When called interactively, work on current text block or text selection. (a “text block” is text between empty lines)

When called in lisp code, if ξfrom-to-pair is non-nil, change the text
in the region between positions [from to]. ξfrom-to-pair should be a
list or vector pair.  Else, returns a changed string."
  (interactive
   (if (region-active-p)
       (list nil (vector (region-beginning) (region-end)))
     (let ((ξboundary (bounds-of-thing-at-point 'paragraph)))
       (list nil (vector (car ξboundary) (cdr ξboundary))))))

  (let (ξwork-on-string-p ξinput-str ξoutput-str ξfrom ξto )
    (when ξfrom-to-pair
      (setq ξfrom (elt ξfrom-to-pair 0))
      (setq ξto (elt ξfrom-to-pair 1)))

    (setq ξwork-on-string-p (if ξfrom-to-pair nil t))
    (setq ξinput-str (if ξwork-on-string-p ξstring (buffer-substring-no-properties ξfrom ξto)))
    (setq ξoutput-str
          (let ((case-fold-search t))
            (replace-regexp-in-string "a\\|e\\|i\\|o\\|u\\|" "" ξinput-str)))

    (if ξwork-on-string-p
        ξoutput-str
      (save-excursion
        (delete-region ξfrom ξto)
        (goto-char ξfrom)
        (insert ξoutput-str)))))



(defun xah-compact-region (p1 p2)
  "Replace any sequence of whitespace chars to a single space on region.
Whitespace here is considered any of {newline char, tab, space}."
  (interactive "r")
  (replace-regexp-pairs-region p1 p2
                               '( ["[\n\t]+" " "]
                                  ["  +" " "])
                               t))

(defun xah-format-c-lang-region (p1 p2)
  "Expand region of C style syntax languages so that it is nicely formated.
Experimental code.
WARNING: If region has comment or string, the code'd be fucked up."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region p1 p2)
      (replace-regexp-pairs-region p1 p2
                                   '(
                                     ["{" "{\n"]
                                     [";" ";\n"]
                                     ["}" "}\n"]
                                     [";[\t\n]*}" "; }"]
                                     )
                                   t)
      (indent-region p1 p2))))

(defun xah-clean-whitespace-and-save (p1 p2)
  "Delete trailing whitespace, and replace repeated blank lines into just 2.
This function works on whole buffer or text selection.

URL `http://ergoemacs.org/emacs/elisp_compact_empty_lines.html'
Version 2015-03-03"
  (interactive
   (if (region-active-p)
       (list (region-beginning) (region-end))
     (list 1 (point-max))))
  (save-excursion
    (save-restriction
      (narrow-to-region p1 p2)
      (progn
        (goto-char (point-min))
        (while (search-forward-regexp "[ \t]+\n" nil "noerror")
          (replace-match "\n")))
      (progn
        (goto-char (point-min))
        (while (search-forward-regexp "\n\n\n+" nil "noerror")
          (replace-match "\n\n")))))
  (when (buffer-file-name)
    (save-buffer)))

(provide 'xah-misc-commands)
