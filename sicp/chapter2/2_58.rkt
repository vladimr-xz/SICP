#lang sicp

(#%require rackunit)

(define (deriv exp var)
        (cond ((number? exp) 0)
                ((variable? exp)
                    (if (same-variable? exp var) 1 0))
                ((sum? exp)
                        (make-sum (deriv (addend exp) var)
                                    (deriv (augend exp) var)))
                ((product? exp)
                        (make-sum
                                (make-product (multiplier exp)
                                            (deriv (multiplicand exp) var))
                                (make-product (deriv (multiplier exp) var)
                                            (multiplicand exp))))
                (else
                    (error "неизвестный тип выражения -- DERIV" exp))))

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
        (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
            ((=number? a2 0) a1)
            ((and (number? a1) (number? a2)) (+ a1 a2))
            (else (list a1 '+ a2))))

(define (=number? exp num)
        (and (number? exp) (= exp num)))

(define (make-product m1 m2)
        (cond ((or (=number? m1 0) (=number? m2 0)) 0)
                ((=number? m1 1) m2)
                ((=number? m2 1) m1)
                ((and (number? m1) (number? m2)) (* m1 m2))
                (else (list m1 '* m2))))

(define (sum? x)
        (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))

(define (augend s) (caddr s))

(define (product? x)
        (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier p) (car p))

(define (multiplicand p) (caddr p))

(check-equal? (deriv '(x * 2) 'x) 2)
(check-equal? (deriv '(x * y) 'x) 'y)
(check-equal? (deriv '(2 * x + y) 'x) 2)
(check-equal? (deriv '((2 * x) + (3 * x) + 1) 'x) 5)
(check-equal? '(this is list) '(this is list))
