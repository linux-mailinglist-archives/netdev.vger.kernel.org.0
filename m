Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1647527EA30
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 15:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgI3Npq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 09:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgI3Npq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 09:45:46 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FC8C061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 06:45:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k15so1861979wrn.10
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 06:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LFqInGP6NlUpP9NhL3ekTpM1ECHy1d1pOPmdvfsdRlw=;
        b=pp34Vj+e1kY4N+bniwBqFSyIpNnJHiJNsyIz5666scgKL19xccz4RUWVD+NX94s576
         nZkPdcAW/i3nJbMtVw8ph+/aVvOPjwN13/yfiIF2THN6VjEhYqXQtgqMe8kdJxfQ/mGN
         8dGlMrNY1TcLpU+Q0P+YV0zsgXcId5G97BRycv2LZDDZmo0faBegACDMl3QPqMcitnz5
         2ygoHnLvU76qkFPWg72cqZ08JZZB4OQKID54HhIMKq7kahZrYVleFenvZ+5Yylz2DLpz
         +Q7SuJTYVaaqM/pKIi8TByQ/A+v7YEutHC53D7RYC7FCdMPay3A7woWlKh7K5fMkLFo6
         gaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LFqInGP6NlUpP9NhL3ekTpM1ECHy1d1pOPmdvfsdRlw=;
        b=FSq6uctjvNedtffQZkXpgoAiGZv9IIORfOGqm+CgMumTfYNUldlBLMULLTt7MQwIey
         A4oLgO5HKr9qKMVda1EDh+HHGGgTxJ5dxdP63YzymjxYUsbI3JRceUe/TCuasohkiBEv
         bj962J2f0+r5rU8MIf0sNIHkPLX5CpjI1Jl6J1GuBUQY9NU8gNQcsSbiWLGel/FAWJyD
         /0vY2vtjRWfupwIptuEtdZ1vIsd2rL/qzYWBwfRiqyWjsGJdXzRwz9Cue6z8gozwTtfH
         JI474gFb4bA65QzwaPN1/lVUyS916nyH4Ap1VsrecPPkWB5oFd3BudqqKn7AUNVcutGu
         N7XA==
X-Gm-Message-State: AOAM533ZnX67QOXccYImJfAwd/kKZr37YXmWQOwijxoLbcGUsDv10CQ9
        Z4RitzZtFW0I1n2Kro7p/QfRo0+pYPRO939QzCB/YQ==
X-Google-Smtp-Source: ABdhPJzqFaTDEMNatEDpGSnNzOgy5KJqWrrH3no3wKL92SnTve2aMG1tiI5JDcUpk7AmolrWRARq3F30Q/9eZlN6GMg=
X-Received: by 2002:a05:6000:85:: with SMTP id m5mr3234455wrx.160.1601473544243;
 Wed, 30 Sep 2020 06:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200930125457.1579469-1-eric.dumazet@gmail.com> <20200930125457.1579469-2-eric.dumazet@gmail.com>
In-Reply-To: <20200930125457.1579469-2-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Wed, 30 Sep 2020 09:45:07 -0400
Message-ID: <CACSApvYnw_9Bj8SowATJYJ_R2-W5od7f8VAFjEh0cM2BCrBB5A@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] inet: remove icsk_ack.blocked
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 8:55 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> TCP has been using it to work around the possibility of tcp_delack_timer()
> finding the socket owned by user.
>
> After commit 6f458dfb4092 ("tcp: improve latencies of timer triggered events")
> we added TCP_DELACK_TIMER_DEFERRED atomic bit for more immediate recovery,
> so we can get rid of icsk_ack.blocked
>
> This frees space that following patch will reuse.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  include/net/inet_connection_sock.h | 4 ++--
>  net/dccp/timer.c                   | 1 -
>  net/ipv4/inet_connection_sock.c    | 2 +-
>  net/ipv4/tcp.c                     | 6 ++----
>  net/ipv4/tcp_output.c              | 7 ++-----
>  net/ipv4/tcp_timer.c               | 1 -
>  6 files changed, 7 insertions(+), 14 deletions(-)
>
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index dc763ca9413cc9c6279a59f9d1776cf2dbb1e853..79875f976190750819948425e63dd0309c699050 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -110,7 +110,7 @@ struct inet_connection_sock {
>                 __u8              pending;       /* ACK is pending                         */
>                 __u8              quick;         /* Scheduled number of quick acks         */
>                 __u8              pingpong;      /* The session is interactive             */
> -               __u8              blocked;       /* Delayed ACK was blocked by socket lock */
> +               /* one byte hole. */
>                 __u32             ato;           /* Predicted tick of soft clock           */
>                 unsigned long     timeout;       /* Currently scheduled timeout            */
>                 __u32             lrcvtime;      /* timestamp of last received data packet */
> @@ -198,7 +198,7 @@ static inline void inet_csk_clear_xmit_timer(struct sock *sk, const int what)
>                 sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
>  #endif
>         } else if (what == ICSK_TIME_DACK) {
> -               icsk->icsk_ack.blocked = icsk->icsk_ack.pending = 0;
> +               icsk->icsk_ack.pending = 0;
>  #ifdef INET_CSK_CLEAR_TIMERS
>                 sk_stop_timer(sk, &icsk->icsk_delack_timer);
>  #endif
> diff --git a/net/dccp/timer.c b/net/dccp/timer.c
> index 927c796d76825439a35c4deb3fb2e45e4313f9b3..a934d293237366aeca87bd3c32241880639291c5 100644
> --- a/net/dccp/timer.c
> +++ b/net/dccp/timer.c
> @@ -176,7 +176,6 @@ static void dccp_delack_timer(struct timer_list *t)
>         bh_lock_sock(sk);
>         if (sock_owned_by_user(sk)) {
>                 /* Try again later. */
> -               icsk->icsk_ack.blocked = 1;
>                 __NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOCKED);
>                 sk_reset_timer(sk, &icsk->icsk_delack_timer,
>                                jiffies + TCP_DELACK_MIN);
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index b457dd2d6c75b2f63bc7849474ac909adb14d603..4148f5f78f313cde1e0596b9eb3696df16e3f990 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -564,7 +564,7 @@ void inet_csk_clear_xmit_timers(struct sock *sk)
>  {
>         struct inet_connection_sock *icsk = inet_csk(sk);
>
> -       icsk->icsk_pending = icsk->icsk_ack.pending = icsk->icsk_ack.blocked = 0;
> +       icsk->icsk_pending = icsk->icsk_ack.pending = 0;
>
>         sk_stop_timer(sk, &icsk->icsk_retransmit_timer);
>         sk_stop_timer(sk, &icsk->icsk_delack_timer);
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 2a8bfa89a5159837e3687e4e0f8cddba7fe54899..ed2805564424a90f003eed867bbed7f5ac4ae833 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1538,10 +1538,8 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
>
>         if (inet_csk_ack_scheduled(sk)) {
>                 const struct inet_connection_sock *icsk = inet_csk(sk);
> -                  /* Delayed ACKs frequently hit locked sockets during bulk
> -                   * receive. */
> -               if (icsk->icsk_ack.blocked ||
> -                   /* Once-per-two-segments ACK was not sent by tcp_input.c */
> +
> +               if (/* Once-per-two-segments ACK was not sent by tcp_input.c */
>                     tp->rcv_nxt - tp->rcv_wup > icsk->icsk_ack.rcv_mss ||
>                     /*
>                      * If this read emptied read buffer, we send ACK, if
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 386978dcd318d84af486d0d1a5bb1786f4a493cf..6bd4e383030ea20441332a30e98fbda8cd90f84a 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3911,11 +3911,8 @@ void tcp_send_delayed_ack(struct sock *sk)
>
>         /* Use new timeout only if there wasn't a older one earlier. */
>         if (icsk->icsk_ack.pending & ICSK_ACK_TIMER) {
> -               /* If delack timer was blocked or is about to expire,
> -                * send ACK now.
> -                */
> -               if (icsk->icsk_ack.blocked ||
> -                   time_before_eq(icsk->icsk_ack.timeout, jiffies + (ato >> 2))) {
> +               /* If delack timer is about to expire, send ACK now. */
> +               if (time_before_eq(icsk->icsk_ack.timeout, jiffies + (ato >> 2))) {
>                         tcp_send_ack(sk);
>                         return;
>                 }
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 0c08c420fbc21a98dedf72148ea2a6f85bf3ff7a..6c62b9ea1320d9bbd26ed86b9f41de02fee6c491 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -331,7 +331,6 @@ static void tcp_delack_timer(struct timer_list *t)
>         if (!sock_owned_by_user(sk)) {
>                 tcp_delack_timer_handler(sk);
>         } else {
> -               icsk->icsk_ack.blocked = 1;
>                 __NET_INC_STATS(sock_net(sk), LINUX_MIB_DELAYEDACKLOCKED);
>                 /* deleguate our work to tcp_release_cb() */
>                 if (!test_and_set_bit(TCP_DELACK_TIMER_DEFERRED, &sk->sk_tsq_flags))
> --
> 2.28.0.806.g8561365e88-goog
>
