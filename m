Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087392CF62E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387603AbgLDV3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387552AbgLDV3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 16:29:33 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15F2C061A4F
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 13:28:52 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id x26so4088247vsq.1
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 13:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=69QduSGKkmK3S33PWxCrlgyCS/xRcCGtlar3bFhP0OA=;
        b=kVUkG5lfbkJ/E/oWPpTq/kBw0J6ayDJZYbH1xHWU1Wq9cFMWGQYJpy0fUvh6qiU6Uz
         2YZY+78nNKXAR2oHlhx0j91I0f5xYit7Gs6rfbYLcD98+QWqasDgSdUEvA93KUFV+Wh1
         v2fKQakrGrrNCLjken7setay+qr9Joy69B+qi1BesqFyg5Xswf49zf0B2ZeATtgWoD7w
         nkh/NrM/IlFS0hwewFY1TSrjrMGjCObNNuKKa3wyaMx+MPP0RnmYuNlOT0qewKOh+6wI
         DkhUHDwp9SuqRGSCM1xgNcT4tNMzRYMmzPiCuUVjdgyJIx1TqZsX8TktGpdGPtJw7NKu
         74jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=69QduSGKkmK3S33PWxCrlgyCS/xRcCGtlar3bFhP0OA=;
        b=Wq4qGRWARgor2Y+C70zKJo54+MYBhNlDGPGM/vDA0Wg2tF+hE0Fclv/jgQFueNYyzl
         2VpKdQsga+hZXigMjVICvEYkZE3gR56pGQRZq1WRnPoudXA2oGplqI6JFplmpxAapUwP
         RaLuxeDkTkz1HAJDfVidVK4CzgZdsb8sBo3JeCGDRi9AlqPVmz5gL9wAWdzNXcRxXmNU
         /5PdbCaSaDL0m2v7n/4kIqgpGxUYFyWeY5mQNcv176MdTc6bGvKVtrLMsfcjWhCp5aMQ
         kpaBHp4D7Lf1tk9IIApAGiEcSwpqrW6Ae4vFWmnBMepUh7RG8hSJn9SmYzCflqkF1Fx5
         3pkA==
X-Gm-Message-State: AOAM530kCu155IkelueNSwsJwuFaPauAMKM3iCZ0C8TxInKAQyZkow7t
        zDqJ/rXnp7gN0goXz3ZR/bPQOjVKrrhxPKXYWUApdg==
X-Google-Smtp-Source: ABdhPJxViztqWxn2pmE4i2+mdpvFzqyAPltkMjhCeT624GE/7Nl2CxPAMVxzLnGuJ/i/fzjvd0Nx8y8llCHBn1qWjcU=
X-Received: by 2002:a67:cd9a:: with SMTP id r26mr6191702vsl.52.1607117331636;
 Fri, 04 Dec 2020 13:28:51 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com>
In-Reply-To: <20201204180622.14285-1-abuehaze@amazon.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 4 Dec 2020 16:28:35 -0500
Message-ID: <CADVnQymC1fLFhb=0_rXNSp2NsNncMMRv77aY=5pYxgmicwowgA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc:     Netdev <netdev@vger.kernel.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>, astroh@amazon.com,
        benh@amazon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 1:08 PM Hazem Mohamed Abuelfotoh
<abuehaze@amazon.com> wrote:
>
>     Previously receiver buffer auto-tuning starts after receiving
>     one advertised window amount of data.After the initial
>     receiver buffer was raised by
>     commit a337531b942b ("tcp: up initial rmem to 128KB
>     and SYN rwin to around 64KB"),the receiver buffer may
>     take too long for TCP autotuning to start raising
>     the receiver buffer size.
>     commit 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
>     tried to decrease the threshold at which TCP auto-tuning starts
>     but it's doesn't work well in some environments
>     where the receiver has large MTU (9001) configured
>     specially within environments where RTT is high.
>     To address this issue this patch is relying on RCV_MSS
>     so auto-tuning can start early regardless
>     the receiver configured MTU.
>
>     Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin to around 64KB")
>     Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning sooner")
>
> Signed-off-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
> ---
>  net/ipv4/tcp_input.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 389d1b340248..f0ffac9e937b 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -504,13 +504,14 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
>  static void tcp_init_buffer_space(struct sock *sk)
>  {
>         int tcp_app_win = sock_net(sk)->ipv4.sysctl_tcp_app_win;
> +       struct inet_connection_sock *icsk = inet_csk(sk);
>         struct tcp_sock *tp = tcp_sk(sk);
>         int maxwin;
>
>         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
>                 tcp_sndbuf_expand(sk);
>
> -       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);
> +       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * icsk->icsk_ack.rcv_mss);

Thanks for the detailed report and the proposed fix.

AFAICT the core of the bug is related to this part of your follow-up email:

> 10)It looks like when the issue happen we have a  kind of deadlock here
> so advertised receive window has to exceed rcvq_space for the tcp auto
> tuning to kickoff at the same time with the initial default  configuration the
> receive window is not going to exceed rcvq_space

The existing code is:

> -       tp->rcvq_space.space = min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * tp->advmss);

(1) With a typical case where both sides have an advmss based on an
MTU of 1500 bytes, the governing limit here is around 10*1460 or so,
or around 15Kbytes. With a tp->rcvq_space.space of that size, it is
common for the data sender to send that amount of data in one round
trip, which will trigger the receive buffer autotuning code in
tcp_rcv_space_adjust(), so autotuning works well.

(2) With a case where the sender has a 1500B NIC and the receiver has
an advmss based on an MTU of 9KB, then the  expression becomes
governed by the receive window of 64KBytes:

  tp->rcvq_space.space
    ~=  min(rcv_wnd, 10*9KBytes)
    ~= min(64KByte,90KByte) = 65536 bytes

But because tp->rcvq_space.space is set to the rcv_wnd, and
the sender is not allowed to send more than the receive
window, this check in tcp_rcv_space_adjust() will always fail,
and the receiver will take the new_measure path:

        /* Number of bytes copied to user in last RTT */
        copied = tp->copied_seq - tp->rcvq_space.seq;
        if (copied <= tp->rcvq_space.space)
                goto new_measure;

This seems to be why receive buffer autotuning is never triggered.

Furthermore, if we try to fix it with:

-        if (copied <= tp->rcvq_space.space)
+        if (copied < tp->rcvq_space.space)

The buggy behavior will still remain, because 65536 is not a multiple
of the MSS, so the number of bytes copied to the user in the last RTT
will never, in practice, exactly match the tp->rcvq_space.space.

AFAICT the proposed patch fixes this bug by setting the
tp->rcvq_space.space to 10*536 = 5360. This is a number of bytes that
*can* actually be delivered in a round trip in a mixed 1500B/9KB
scenario, so this allows receive window auto-tuning to actually be
triggered.

It seems like a reasonable approach to fix this issue, but I agree
with Eric that it would be good to improve the commit message a bit.

Also, since this is a bug fix, it seems it should be directed to the
"net" branch rather than the "net-next" branch.

Also, FWIW, I think the "for high latency connections" can be dropped
from the commit summary/first-line, since the bug can be hit at any
RTT, and is simply easier to notice at high RTTs. You might consider
something like:

  tcp: fix receive buffer autotuning to trigger for any valid advertised MSS

best,
neal
