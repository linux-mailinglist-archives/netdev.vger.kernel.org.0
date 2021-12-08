Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F16146DB1B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238913AbhLHSee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235154AbhLHSed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:34:33 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CFDC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 10:31:01 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id d10so8091335ybe.3
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 10:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+zK0aufWTqPh7Kw2UxAKwzmu2XOa9NYmr2CTxqiBJmM=;
        b=E4EQ4xYbz9d/L/WHOEJJ9iXBkkBX4OB/uBb0HMVnhh09ZvUP7wgTWfBJsrvh4PSKlt
         f0WZmslQKpCzB0Di0wn+JvP0wGIlPfzBNIqNazCVpKaw8+VZGkXN8dhBKqx27oyF+tT/
         lQay9tMARsEFCCUCYyfdzxIhok5l5umRfUHv9ilGccsNhzw9wST/qw8T/3+GMYCTRR0+
         A4olKXIEHY9EoOu0fYth4kRxR8uEpEi9ZqoQDRHtW+gM1hr7qGcD3Wjod8v0ifzwdzYp
         iRLOFnAN9i67uH3vQT08TWUy2xZ64g69hXH4afHrwt+TpmZ2C7OKDmmxNJoNUigUWd7C
         X3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+zK0aufWTqPh7Kw2UxAKwzmu2XOa9NYmr2CTxqiBJmM=;
        b=vNbD2wwF2Nl7dNrglzRzss9IBLVMvNTmCRgj7LyWuqCvMEMRWvd6cyFqWKZ0ZBFfpI
         YtaYJm8jFeB2iy444dzfSp4n1alwmTKzlsQkEw+HCqJHrxNDaHrtQGfDYLWCPZ9Lf1Qw
         QaR7JWtLinG2CkXtD5T7Kr31SIi3EC+57UcX6SbA7cMehQ3jbCXeBuokzfFkcw4S/K4r
         pulNv9Ogd9nACJB53Kl2nBqmSqnCCFhogPT6TlEVop0nPSgqbKZfB9QSogDEI8giSCkp
         2c8sReoHKqmTXvrhSV2TXMuMZdNrBJewYd2VLseUL+NqJ+lI7IurUUaS9ct0YRqzX2hy
         iV7g==
X-Gm-Message-State: AOAM532FeljDFenBRxxy473lYlqQ2Llf6kwb5BhBxQyier9Ugo0Z79um
        7xil4byayOtIhmuFho9e/mZx3W3kzfaEFyT1sXzILw==
X-Google-Smtp-Source: ABdhPJzisbqEdTjwoPfEsTiW3HC6i8m8Eug4Q+6PPIgbDtq4tc5uKfJ32DfKT3NUG0gRwFxelnkLqAedjW8RA382k4A=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr499447ybt.156.1638988260081;
 Wed, 08 Dec 2021 10:31:00 -0800 (PST)
MIME-Version: 1.0
References: <20211208051633.49122-1-kuniyu@amazon.co.jp>
In-Reply-To: <20211208051633.49122-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Dec 2021 10:30:49 -0800
Message-ID: <CANn89iL+YWbQDCTQU-D1nU4EePv07EyHvMPjFPkpH1ELyzg5MA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Remove sock_owned_by_user() test in tcp_child_process().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 9:16 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> While creating a child socket, before v2.3.41, we used to call
> bh_lock_sock() later than now; it was called just before
> tcp_rcv_state_process().  The full socket was put into an accept queue
> and exposed to other CPUs before bh_lock_sock() so that process context
> might have acquired the lock by then.  Thus, we had to check if any
> process context was accessing the socket before tcp_rcv_state_process().
>
> We can see this code in tcp_v4_do_rcv() of v2.3.14. [0]
>
>         if (sk->state == TCP_LISTEN) {
>                 struct sock *nsk;
>
>                 nsk = tcp_v4_hnd_req(sk, skb);
>                 ...
>                 if (nsk != sk) {
>                         bh_lock_sock(nsk);
>                         if (nsk->lock.users != 0) {
>                                 ...
>                                 sk_add_backlog(nsk, skb);
>                                 bh_unlock_sock(nsk);
>                                 return 0;
>                         }
>                         ...
>                 }
>         }
>
>         if (tcp_rcv_state_process(sk, skb, skb->h.th, skb->len))
>                 goto reset;
>
> However, in 2.3.15, this lock.users test was replaced with BUG_TRAP() by
> mistake. [1]
>
>                 if (nsk != sk) {
>                         ...
>                         BUG_TRAP(nsk->lock.users == 0);
>                         ...
>                         ret = tcp_rcv_state_process(nsk, skb, skb->h.th, skb->len);
>                         ...
>                         bh_unlock_sock(nsk);
>                         ...
>                         return 0;
>                 }
>
> Fortunately, the test was back in 2.3.41. [2]  Then, related code was
> packed into tcp_child_process() with comments, which remains until now.
>
> What is interesting in v2.3.41 is that the bh_lock_sock() was moved to
> tcp_create_openreq_child() and placed just after sock_lock_init().
> Thus, the lock is never acquired until tcp_rcv_state_process() by process
> contexts.  The bh_lock_sock() is now in sk_clone_lock() and the rule does
> not change.
>
> As of now, alas, it is not possible to reach the commented path by the
> change.  Let's remove the remnant of the old days.
>
> [0]: https://cdn.kernel.org/pub/linux/kernel/v2.3/linux-2.3.14.tar.gz
> [1]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.15.gz
> [2]: https://cdn.kernel.org/pub/linux/kernel/v2.3/patch-2.3.41.gz
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

I do not think this patch qualifies as a stable candidate.

At best this is a cleanup.

At worst this could add a bug.

I would advise adding a WARN_ON_ONCE() there for at least one release
so that syzbot can validate for you if this is dead code or not.

TCP_SYN_RECV is not TCP_NEW_SYN_RECV

Thanks.

> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  net/ipv4/tcp_minisocks.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 7c2d3ac2363a..b4a1f8728093 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -833,18 +833,12 @@ int tcp_child_process(struct sock *parent, struct sock *child,
>         sk_mark_napi_id_set(child, skb);
>
>         tcp_segs_in(tcp_sk(child), skb);
> -       if (!sock_owned_by_user(child)) {
> -               ret = tcp_rcv_state_process(child, skb);
> -               /* Wakeup parent, send SIGIO */
> -               if (state == TCP_SYN_RECV && child->sk_state != state)
> -                       parent->sk_data_ready(parent);
> -       } else {
> -               /* Alas, it is possible again, because we do lookup
> -                * in main socket hash table and lock on listening
> -                * socket does not protect us more.
> -                */
> -               __sk_add_backlog(child, skb);
> -       }
> +
> +       ret = tcp_rcv_state_process(child, skb);
> +
> +       /* Wakeup parent, send SIGIO */
> +       if (state == TCP_SYN_RECV && child->sk_state != state)
> +               parent->sk_data_ready(parent);
>
>         bh_unlock_sock(child);
>         sock_put(child);
> --
> 2.30.2
>
