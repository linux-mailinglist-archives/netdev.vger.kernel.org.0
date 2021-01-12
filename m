Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE92F3F78
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394761AbhALWtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbhALWtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 17:49:20 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05264C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:48:40 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id g10so1853751wmh.2
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 14:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ArlcvqJC9q51hscbwB0x0D1UTjuMUpHLsr6hfqKDboU=;
        b=Z+UVCsDEuZ+jOvAGZqP7xaXkuN3UW1kYQK/efl9+WKHVo5u+O5SwRfH9Gsl0sizrYu
         PWd1gJIoe+vCvbB8U2ExGkGY14jFqmrYonaEsAABcHzAF7RvqVXwIIsMU8HCsfCiUcAR
         jIA8E6eIoa7S+WSV/y3R3DB3b+kd271uJz+/uQWxIhENojaxqCrWLwd9Ydu/bYIdDYRe
         Lqk9g0KZysiZrjQc99BSYfvFWea4LcZGJQ0oj1euEnZxafWG7VOV4PQIP0EdkiOJu1C+
         rlCGXPpqFwNAp45H833PPgC6zYSs97/jdS6WV7CH59XPci3wFJacCMv1/vXLXQUyC+/v
         /Nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ArlcvqJC9q51hscbwB0x0D1UTjuMUpHLsr6hfqKDboU=;
        b=Rc9eR4sJenD2GIUKgmKtXk4+XoH1PJXHQ1dk59cwWLNmw/YYqTF0knKpGV1z5ZoeuL
         8mpaEAmKEAHztTdi3b4baj8OQkQ8iw2xmLNQk87xazcdvgF5LCAWlHpt8iO4bw84op4M
         U7n45RsYayxG53AK6Xb1YiJk1POoOfHFCaTrBWl7Xkl2McQPbb/gbKr0L+SHfnbNozx2
         csf6KSwg70pSCQJJwVvfLzMk4BV5DiLc0XxN1P6fGrCW/2jpcAaisUbHrggjvcMVjhSN
         VdZ9T+krU+gXKlIJQkp08ZUH350wO88GpI7XkHObn0OC3af0cGBUncCtwZ8sRy7YaIZJ
         1j0A==
X-Gm-Message-State: AOAM530sEB8aQgVW3x+yXWLDIv6i3OG99aWvtLAPOItSUni4mnr/LPrz
        iw0p4HXGLcpBGns0cZz3/uD3SanDbpUOs/9oNZGRHA==
X-Google-Smtp-Source: ABdhPJwew+56qPJeIfkyBnlXq2O9bDLp34KDvagCCtYIVTv+EkeaGP52WgQjDqtOJ//+AAhFTUAj/0b/MVRTcygrODc=
X-Received: by 2002:a1c:4907:: with SMTP id w7mr967923wma.118.1610491718575;
 Tue, 12 Jan 2021 14:48:38 -0800 (PST)
MIME-Version: 1.0
References: <20210112192544.GA12209@localhost.localdomain>
In-Reply-To: <20210112192544.GA12209@localhost.localdomain>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Tue, 12 Jan 2021 14:48:01 -0800
Message-ID: <CAK6E8=fq6Jec94FDmDHGWhsmjtZQmt3AwQB0-tLcpJpvJ=oLgg@mail.gmail.com>
Subject: Re: [PATCH] tcp: keepalive fixes
To:     Enke Chen <enkechen2020@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 2:31 PM Enke Chen <enkechen2020@gmail.com> wrote:
>
> From: Enke Chen <enchen@paloaltonetworks.com>
>
> In this patch two issues with TCP keepalives are fixed:
>
> 1) TCP keepalive does not timeout when there are data waiting to be
>    delivered and then the connection got broken. The TCP keepalive
>    timeout is not evaluated in that condition.
hi enke
Do you have an example to demonstrate this issue -- in theory when
there is data inflight, an RTO timer should be pending (which
considers user-timeout setting). based on the user-timeout description
(man tcp), the user timeout should abort the socket per the specified
time after data commences. some data would help to understand the
issue.

>
>    The fix is to remove the code that prevents TCP keepalive from
>    being evaluated for timeout.
>
> 2) With the fix for #1, TCP keepalive can erroneously timeout after
>    the 0-window probe kicks in. The 0-window probe counter is wrongly
>    applied to TCP keepalives.
>
>    The fix is to use the elapsed time instead of the 0-window probe
>    counter in evaluating TCP keepalive timeout.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Enke Chen <enchen@paloaltonetworks.com>
> ---
>  net/ipv4/tcp_timer.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 6c62b9ea1320..40953aa40d53 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -696,12 +696,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
>             ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_SYN_SENT)))
>                 goto out;
>
> -       elapsed = keepalive_time_when(tp);
> -
> -       /* It is alive without keepalive 8) */
> -       if (tp->packets_out || !tcp_write_queue_empty(sk))
> -               goto resched;
> -
>         elapsed = keepalive_time_elapsed(tp);
>
>         if (elapsed >= keepalive_time_when(tp)) {
> @@ -709,16 +703,15 @@ static void tcp_keepalive_timer (struct timer_list *t)
>                  * to determine when to timeout instead.
>                  */
>                 if ((icsk->icsk_user_timeout != 0 &&
> -                   elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout) &&
> -                   icsk->icsk_probes_out > 0) ||
> +                    elapsed >= msecs_to_jiffies(icsk->icsk_user_timeout)) ||
>                     (icsk->icsk_user_timeout == 0 &&
> -                   icsk->icsk_probes_out >= keepalive_probes(tp))) {
> +                    (elapsed >= keepalive_time_when(tp) +
> +                     keepalive_intvl_when(tp) * keepalive_probes(tp)))) {
>                         tcp_send_active_reset(sk, GFP_ATOMIC);
>                         tcp_write_err(sk);
>                         goto out;
>                 }
>                 if (tcp_write_wakeup(sk, LINUX_MIB_TCPKEEPALIVE) <= 0) {
> -                       icsk->icsk_probes_out++;
>                         elapsed = keepalive_intvl_when(tp);
>                 } else {
>                         /* If keepalive was lost due to local congestion,
> @@ -732,8 +725,6 @@ static void tcp_keepalive_timer (struct timer_list *t)
>         }
>
>         sk_mem_reclaim(sk);
> -
> -resched:
>         inet_csk_reset_keepalive_timer (sk, elapsed);
>         goto out;
>
> --
> 2.29.2
>
