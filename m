Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6AA21B94E
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 17:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgGJPUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbgGJPUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 11:20:16 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0522C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 08:20:15 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 2so2826265ybr.13
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 08:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGz8fwqi3iWK7OiEZGygZqp0dNUEBw6lIEZJdnz5zYk=;
        b=hvhiM1TRvvWuag1g1IiVFVDwV4ZAOVA8tlZM6LEBtbwEtKie5RvCmIb+OBfhFZywT3
         t+d1pQLlG4BnFdyCBcBU9os0H9LsVg8cMypSAoYx6oS2Jedyn+SyL7wTGcfq68gn/Po5
         OJ5DsiJ07rxM1KiqkpW7XGlFSFMdWwhOgPZfa7tj+7r/Ps8rp97UHOhGz8zxCVr/xDyP
         /WAxjlnyq5RZZknreRfdSfrFXCxXHcUQE8Bxzjb44Pj/gVsZTGkV3B5FfTJWbfkw3hn1
         kh3Q7Nn7h2iy74bZqzodagAFXj8tt9FFvatpkMLNzg79hRChX/YHjWR/nm1NsCrRYcI7
         Hk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGz8fwqi3iWK7OiEZGygZqp0dNUEBw6lIEZJdnz5zYk=;
        b=aYjut5dgyAgXLF8/ydQ86oceAZtG4YEgBJHWwsxCQl7w26rg0geiNEgTXgBXa2UsQj
         8hFcnLb85W1Ft8xlkhnD171Q/qOv63aRVoHS+wqCHKeJqJTopx2RGWKmOXs2wik5Qpm1
         H/b38hxjcEFsUJqGszjkoWJHA6WxQg09ZCy52YoWmuSmO7PcbL6yT6J6RYDT042B6Z25
         gFcXVZLCKUnBDnpUIbqIahUxO9XfVskpEwXQzsDdtj/CqquMvsbF6kwq1lA8CgeqC8SI
         JLzGUBF7xulg8BiMmbHmllU8/2W3lJk2eMAEk2mi61Zp2YfvLamkGszkau7+u8dTdxUt
         7RNA==
X-Gm-Message-State: AOAM530RiuD9jvcU38SWHEIjcl89yfP1rP/kvnQcJ5RfauKP1GNGrBoT
        6UCP4p0eSEEQR7LqGPr2Z8tkb7+h1rYVtcUwHS6iIg==
X-Google-Smtp-Source: ABdhPJzUBD6OYc3XJwUOPIDIJ58SiHzYGW+VgUxb1G8PwXOBug4QmjjCeEJTV+eTWWEf9hj+s4MyIPYonC6fskG13WY=
X-Received: by 2002:a25:ad66:: with SMTP id l38mr23952236ybe.274.1594394414497;
 Fri, 10 Jul 2020 08:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200710141053.65581-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200710141053.65581-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jul 2020 08:20:03 -0700
Message-ID: <CANn89iJsC73o9hJ_RUd9qfv50ebt2H5VZx0-xgrPXFAZVWeGgQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] inet: Remove an unnecessary argument of syn_ack_recalc().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        osa-contribution-log@amazon.com, Julian Anastasov <ja@ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 7:11 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> Commit 0c3d79bce48034018e840468ac5a642894a521a3 ("tcp: reduce SYN-ACK
> retrans for TCP_DEFER_ACCEPT") introduces syn_ack_recalc() which decides
> if a minisock is held and a SYN+ACK is retransmitted or not.
>
> If rskq_defer_accept is not zero in syn_ack_recalc(), max_retries always
> has the same value because max_retries is overwritten by rskq_defer_accept
> in reqsk_timer_handler().
>
> This commit adds three changes:
> - remove redundant non-zero check for rskq_defer_accept in
>    reqsk_timer_handler().
> - remove max_retries from the arguments of syn_ack_recalc() and use
>    rskq_defer_accept instead.
> - rename thresh to max_syn_ack_retries for readability.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> CC: Julian Anastasov <ja@ssi.bg>
> ---
>  net/ipv4/inet_connection_sock.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
>
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index afaf582a5aa9..21bc80a3c7cf 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -648,20 +648,23 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
>  EXPORT_SYMBOL_GPL(inet_csk_route_child_sock);
>
>  /* Decide when to expire the request and when to resend SYN-ACK */
> -static inline void syn_ack_recalc(struct request_sock *req, const int thresh,
> -                                 const int max_retries,
> +static inline void syn_ack_recalc(struct request_sock *req,

While we are at it, please remove the inline keyword.

> +                                 const int max_syn_ack_retries,
>                                   const u8 rskq_defer_accept,
>                                   int *expire, int *resend)
>  {
>         if (!rskq_defer_accept) {
> -               *expire = req->num_timeout >= thresh;
> +               *expire = req->num_timeout >= max_syn_ack_retries;
>                 *resend = 1;
>                 return;
>         }
> -       *expire = req->num_timeout >= thresh &&
> -                 (!inet_rsk(req)->acked || req->num_timeout >= max_retries);
> -       /*
> -        * Do not resend while waiting for data after ACK,
> +       /* If a bare ACK has already been dropped, the client is alive, so
> +        * do not free the request_sock to drop a bare ACK at most
> +        * rskq_defer_accept times and wait for data.
> +        */

I honestly do not believe this comment is needed.
The bare ack has not been 'dropped' since it had the effect of
validating the 3WHS.
I find it confusing, and not describing the order of the conditions
expressed in the C code.

> +       *expire = req->num_timeout >= max_syn_ack_retries &&
> +                 (!inet_rsk(req)->acked || req->num_timeout >= rskq_defer_accept);
> +       /* Do not resend while waiting for data after ACK,
>          * start to resend on end of deferring period to give
>          * last chance for data or ACK to create established socket.
>          */
> @@ -720,15 +723,12 @@ static void reqsk_timer_handler(struct timer_list *t)
>         struct net *net = sock_net(sk_listener);
>         struct inet_connection_sock *icsk = inet_csk(sk_listener);
>         struct request_sock_queue *queue = &icsk->icsk_accept_queue;
> -       int qlen, expire = 0, resend = 0;
> -       int max_retries, thresh;
> -       u8 defer_accept;
> +       int max_syn_ack_retries, qlen, expire = 0, resend = 0;
>
>         if (inet_sk_state_load(sk_listener) != TCP_LISTEN)
>                 goto drop;
>
> -       max_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
> -       thresh = max_retries;
> +       max_syn_ack_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
>         /* Normally all the openreqs are young and become mature
>          * (i.e. converted to established socket) for first timeout.
>          * If synack was not acknowledged for 1 second, it means
> @@ -750,17 +750,14 @@ static void reqsk_timer_handler(struct timer_list *t)
>         if ((qlen << 1) > max(8U, READ_ONCE(sk_listener->sk_max_ack_backlog))) {
>                 int young = reqsk_queue_len_young(queue) << 1;
>
> -               while (thresh > 2) {
> +               while (max_syn_ack_retries > 2) {
>                         if (qlen < young)
>                                 break;
> -                       thresh--;
> +                       max_syn_ack_retries--;
>                         young <<= 1;
>                 }
>         }
> -       defer_accept = READ_ONCE(queue->rskq_defer_accept);
> -       if (defer_accept)
> -               max_retries = defer_accept;
> -       syn_ack_recalc(req, thresh, max_retries, defer_accept,
> +       syn_ack_recalc(req, max_syn_ack_retries, READ_ONCE(queue->rskq_defer_accept),
>                        &expire, &resend);
>         req->rsk_ops->syn_ack_timeout(req);
>         if (!expire &&
> --
> 2.17.2 (Apple Git-113)
>
