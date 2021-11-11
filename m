Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF47F44D469
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 10:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhKKJyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 04:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhKKJym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 04:54:42 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6569C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 01:51:53 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so7275585otg.4
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 01:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=krjHmZ3Dw2WTF4k+Byn44pC5MSd5GJTXjQ+BQM/xy4g=;
        b=JSFD2F8W1IREu+5qjrlSHU99pUMSiD5AD7iPoQhriZDqp+HY98jFJAM+I0KUB0NrQu
         I3WfGS+NdjyCA8ZjXQHzTVFEAM3WXKH8chU6s2qXkvojTxtshVBf/qe1EC0NFgTZAJzA
         krSszWi5INV5SyMPnQ0fXWpsGt1r7+OT1869cp9yo2fU8MO6CJGAY8RA3GFbcvJhDHwW
         u65x8XVJBbr/M1NWj7adczup/TQPoKHsG1J3QiXyKVme0TU/cMT7qks3W+nZCAHhyGEV
         DxQRivGjvQYg6llw59+6HuIbkF5TVARuxbwL/1yyIWYCzzAgBTaraFGOXApNMSyYaKp2
         afeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=krjHmZ3Dw2WTF4k+Byn44pC5MSd5GJTXjQ+BQM/xy4g=;
        b=OKCzSP2KzCzW9TuzAx7WCfZwvAl9JZ0t7yCSHuHrUKNqGBHt4zOB5hmf3JWYkrFu4z
         iGQ1A3liVoX83lPG/AuigcOxshHjJkYmj5dS3K9ZVoKf5etth2/aauuKZpYUhQFLTv5/
         fSg34L/1IwKqvox4v4PGibXZYopLnHbeC2EU20J8YvBVVje1/6c3zvOY0///2ItPQOJz
         8SoL0KGsiBUkQZmW0Pfy/w538bMaX1GcyALZX9nJE9izBxwxk86evaW09y2f3qGh7oGy
         w+EWufirpm2EDCQX6YPxwdOJCOiN/JZzojMi31OMHSwDEJW4s3OR0thfoddiP8I9LwU6
         J5ww==
X-Gm-Message-State: AOAM531KD51u3dl3IF/TskMeLoMKu6CEsqOQT+3XfutA4BGQnLHNLEDQ
        n5bBvDSPOsCzyCqrzblTWDBbAIJ0AdjO8RO2xN3fwA==
X-Google-Smtp-Source: ABdhPJzvhOh9Tsh8IuynZRDgZBSpRFmdZur4oMk8rMYoPBEQ/vu2f2E6VsmCNOzxAPZmVnw6YqnG2+qcr8dBvUFqoKw=
X-Received: by 2002:a9d:662:: with SMTP id 89mr4811351otn.157.1636624312815;
 Thu, 11 Nov 2021 01:51:52 -0800 (PST)
MIME-Version: 1.0
References: <20211111003519.1050494-1-tadeusz.struk@linaro.org>
In-Reply-To: <20211111003519.1050494-1-tadeusz.struk@linaro.org>
From:   Marco Elver <elver@google.com>
Date:   Thu, 11 Nov 2021 10:51:41 +0100
Message-ID: <CANpmjNNcVFmnBV-1Daauqk5ww8YRUVRtVs_SXVAPWG5CrFBVPg@mail.gmail.com>
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 at 01:36, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
> Kernel throws a runtime object-size-mismatch error in skbuff queue
> helpers like in [1]. This happens every time there is a pattern
> like the below:
>
> int skbuf_xmit(struct sk_buff *skb)
> {
>         struct sk_buff_head list;
>
>         __skb_queue_head_init(&list);
>         __skb_queue_tail(&list, skb); <-- offending call
>
>         return do_xmit(net, &list);
> }
>
> and the kernel is build with clang and -fsanitize=undefined flag set.
> The reason is that the functions __skb_queue_[tail|head]() access the
> struct sk_buff_head object via a pointer to struct sk_buff, which is
> much bigger in size than the sk_buff_head. This could cause undefined
> behavior and clang is complaining:
>
> UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2023:28
> member access within address ffffc90000cb71c0 with insufficient space
> for an object of type 'struct sk_buff'

The config includes CONFIG_UBSAN_OBJECT_SIZE, right? Normally that's
disabled by default, probably why nobody has noticed these much.

> Suppress the error with __attribute__((no_sanitize("undefined")))
> in the skb helpers.

Isn't there a better way, because doing this might also suppress other
issues wholesale. __no_sanitize_undefined should be the last resort.

> [1] https://syzkaller.appspot.com/bug?id=5d9f0bca58cea80f272b73500df67dcd9e35c886
>
> Cc: "Nathan Chancellor" <nathan@kernel.org>
> Cc: "Nick Desaulniers" <ndesaulniers@google.com>
> Cc: "Jakub Kicinski" <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "Jonathan Lemon" <jonathan.lemon@gmail.com>
> Cc: "Alexander Lobakin" <alobakin@pm.me>
> Cc: "Willem de Bruijn" <willemb@google.com>
> Cc: "Paolo Abeni" <pabeni@redhat.com>
> Cc: "Cong Wang" <cong.wang@bytedance.com>
> Cc: "Kevin Hao" <haokexin@gmail.com>
> Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
> Cc: "Marco Elver" <elver@google.com>
> Cc: <netdev@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: <llvm@lists.linux.dev>
>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> ---
>  include/linux/skbuff.h | 49 ++++++++++++++++++++++++------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 0bd6520329f6..8ec46e3a503d 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1933,9 +1933,10 @@ static inline void skb_queue_head_init_class(struct sk_buff_head *list,
>   *     The "__skb_xxxx()" functions are the non-atomic ones that
>   *     can only be called with interrupts disabled.
>   */
> -static inline void __skb_insert(struct sk_buff *newsk,
> -                               struct sk_buff *prev, struct sk_buff *next,
> -                               struct sk_buff_head *list)
> +static inline void __no_sanitize_undefined
> +__skb_insert(struct sk_buff *newsk,
> +            struct sk_buff *prev, struct sk_buff *next,
> +            struct sk_buff_head *list)
>  {
>         /* See skb_queue_empty_lockless() and skb_peek_tail()
>          * for the opposite READ_ONCE()
> @@ -1966,8 +1967,9 @@ static inline void __skb_queue_splice(const struct sk_buff_head *list,
>   *     @list: the new list to add
>   *     @head: the place to add it in the first list
>   */
> -static inline void skb_queue_splice(const struct sk_buff_head *list,
> -                                   struct sk_buff_head *head)
> +static inline void __no_sanitize_undefined
> +skb_queue_splice(const struct sk_buff_head *list,
> +                struct sk_buff_head *head)
>  {
>         if (!skb_queue_empty(list)) {
>                 __skb_queue_splice(list, (struct sk_buff *) head, head->next);
> @@ -1982,8 +1984,9 @@ static inline void skb_queue_splice(const struct sk_buff_head *list,
>   *
>   *     The list at @list is reinitialised
>   */
> -static inline void skb_queue_splice_init(struct sk_buff_head *list,
> -                                        struct sk_buff_head *head)
> +static inline void __no_sanitize_undefined
> +skb_queue_splice_init(struct sk_buff_head *list,
> +                     struct sk_buff_head *head)
>  {
>         if (!skb_queue_empty(list)) {
>                 __skb_queue_splice(list, (struct sk_buff *) head, head->next);
> @@ -1997,8 +2000,9 @@ static inline void skb_queue_splice_init(struct sk_buff_head *list,
>   *     @list: the new list to add
>   *     @head: the place to add it in the first list
>   */
> -static inline void skb_queue_splice_tail(const struct sk_buff_head *list,
> -                                        struct sk_buff_head *head)
> +static inline void __no_sanitize_undefined
> +skb_queue_splice_tail(const struct sk_buff_head *list,
> +                     struct sk_buff_head *head)
>  {
>         if (!skb_queue_empty(list)) {
>                 __skb_queue_splice(list, head->prev, (struct sk_buff *) head);
> @@ -2014,8 +2018,9 @@ static inline void skb_queue_splice_tail(const struct sk_buff_head *list,
>   *     Each of the lists is a queue.
>   *     The list at @list is reinitialised
>   */
> -static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
> -                                             struct sk_buff_head *head)
> +static inline void __no_sanitize_undefined
> +skb_queue_splice_tail_init(struct sk_buff_head *list,
> +                          struct sk_buff_head *head)
>  {
>         if (!skb_queue_empty(list)) {
>                 __skb_queue_splice(list, head->prev, (struct sk_buff *) head);
> @@ -2035,9 +2040,10 @@ static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
>   *
>   *     A buffer cannot be placed on two lists at the same time.
>   */
> -static inline void __skb_queue_after(struct sk_buff_head *list,
> -                                    struct sk_buff *prev,
> -                                    struct sk_buff *newsk)
> +static inline void __no_sanitize_undefined
> +__skb_queue_after(struct sk_buff_head *list,
> +                 struct sk_buff *prev,
> +                 struct sk_buff *newsk)
>  {
>         __skb_insert(newsk, prev, prev->next, list);
>  }
> @@ -2045,9 +2051,10 @@ static inline void __skb_queue_after(struct sk_buff_head *list,
>  void skb_append(struct sk_buff *old, struct sk_buff *newsk,
>                 struct sk_buff_head *list);
>
> -static inline void __skb_queue_before(struct sk_buff_head *list,
> -                                     struct sk_buff *next,
> -                                     struct sk_buff *newsk)
> +static inline void __no_sanitize_undefined
> +__skb_queue_before(struct sk_buff_head *list,
> +                  struct sk_buff *next,
> +                  struct sk_buff *newsk)
>  {
>         __skb_insert(newsk, next->prev, next, list);
>  }
> @@ -2062,8 +2069,8 @@ static inline void __skb_queue_before(struct sk_buff_head *list,
>   *
>   *     A buffer cannot be placed on two lists at the same time.
>   */
> -static inline void __skb_queue_head(struct sk_buff_head *list,
> -                                   struct sk_buff *newsk)
> +static inline void __no_sanitize_undefined
> +__skb_queue_head(struct sk_buff_head *list, struct sk_buff *newsk)
>  {
>         __skb_queue_after(list, (struct sk_buff *)list, newsk);
>  }
> @@ -2079,8 +2086,8 @@ void skb_queue_head(struct sk_buff_head *list, struct sk_buff *newsk);
>   *
>   *     A buffer cannot be placed on two lists at the same time.
>   */
> -static inline void __skb_queue_tail(struct sk_buff_head *list,
> -                                  struct sk_buff *newsk)
> +static inline void __no_sanitize_undefined
> +__skb_queue_tail(struct sk_buff_head *list, struct sk_buff *newsk)
>  {
>         __skb_queue_before(list, (struct sk_buff *)list, newsk);
>  }
> --
> 2.33.1
>
