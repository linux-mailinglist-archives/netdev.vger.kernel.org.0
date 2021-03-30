Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5CB34ECC4
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhC3Pkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbhC3PkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 11:40:18 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9109DC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:40:18 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g38so17832266ybi.12
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 08:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F+/OGFhf+Y2RXZe7d2pKrFM6QiwQk1Kt9GR+Xe7FaSQ=;
        b=sAbjRyH+aVoV5oysS8RRzcnCkC5d/5j/fdTYSthfkgoxssql0KzYyf2q0o9xGHn7sU
         YnPkgWrwHEnmRKAgRxoGp1RHNOiBfUCrsqUJns1X2prNZ+O7t0CK/lRZK26jimNwEe6A
         QK1lKgPXmaGqPSQAC94a0waXmoiaJnqsD0qxD0/y+jk371gbj4rKR/DPBbvoWABilpBO
         8GKq8al2HP78aX7cVIEEQlrIXW4VWd9ivriASBDgp2BM3pcXy6id8m412tmPO3KPNk+q
         BC3kBMAeITh4699AEABPpXHkBWLZTXHEBUZEd6ty/NXVtIDPSYOphewfQQTO3MhvprI5
         LX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F+/OGFhf+Y2RXZe7d2pKrFM6QiwQk1Kt9GR+Xe7FaSQ=;
        b=e5kHpctljTgX8HhtSYTAJY++xjeVtqJjmQxJ7NGEckAGporX4CpYA/DO2Tgw1704T/
         dmIybb/rtPLbs5IDpjoLGQhmEDjxo5hOuJeaw/fzCZpuxA258cRDvzel37kIwqVr37Ub
         rJIe4ZhcYyhSoes/A8vAjLH0WFPUDSKwBu9rgZxwdvUDkJ9tu1jSRHvKleTx3Hn3VAkh
         a8MRR1kPVgYTlwmy520+qUkLLWB5omESbVPGx+loWn5kkBcK091MoYpwM10/KKa8F+6O
         dtC0aGCh+yNhg3QHC2LF1k1h/g+NEtdWzpekbXqpMak1xhFcx5ignxfU7vJ3LmRKEbyW
         5dUw==
X-Gm-Message-State: AOAM5320Jh47JMtxopzw1qVzR89xiSW/N3mpXwq+XNIOupGHGYTDZolH
        3LlL3Zn+alcirTE9f6kLgvLQTWabwpCmH88Z+eR0LybiyGe80Q==
X-Google-Smtp-Source: ABdhPJyxVg2CT9j1p5mqBR1QpfBandED3Nd4co8Wj3axgltCuVHZOJzIaq4Xz/ZUjWPW2gukw7EbepEaVjzronQDhqM=
X-Received: by 2002:a25:b906:: with SMTP id x6mr44200213ybj.504.1617118817605;
 Tue, 30 Mar 2021 08:40:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210330153106.31614-1-ap420073@gmail.com>
In-Reply-To: <20210330153106.31614-1-ap420073@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 17:40:06 +0200
Message-ID: <CANn89iJ1G8vU-Jw6gaTsZHamQv1ncLmoJ1FOop25OzrYmjh4kA@mail.gmail.com>
Subject: Re: [PATCH net-next] mld: add missing rtnl_lock() in do_ipv6_getsockopt()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 5:31 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> ip6_mc_msfget() should be called under RTNL because it accesses RTNL
> protected data. but the caller doesn't acquire rtnl_lock().
> So, data couldn't be protected.
> Therefore, it adds rtnl_lock() in do_ipv6_getsockopt(),
> which is the caller of ip6_mc_msfget().
>
> Splat looks like:
> =============================
> WARNING: suspicious RCU usage
> 5.12.0-rc4+ #480 Tainted: G        W
> -----------------------------
> include/net/addrconf.h:314 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by sockopt_msfilte/4955:
>  #0: ffff88800aa21370 (sk_lock-AF_INET6){+.+.}-{0:0}, at: \
>         ipv6_get_msfilter+0xaf/0x190
>
> stack backtrace:
> Call Trace:
>  dump_stack+0xa4/0xe5
>  ip6_mc_find_dev_rtnl+0x117/0x150
>  ip6_mc_msfget+0x17d/0x700
>  ? lock_acquire+0x191/0x720
>  ? ipv6_sock_mc_join_ssm+0x10/0x10
>  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
>  ? mark_held_locks+0xb7/0x120
>  ? lockdep_hardirqs_on_prepare+0x27c/0x3e0
>  ? __local_bh_enable_ip+0xa5/0xf0
>  ? lock_sock_nested+0x82/0xf0
>  ipv6_get_msfilter+0xc3/0x190
>  ? compat_ipv6_get_msfilter+0x300/0x300
>  ? lock_downgrade+0x690/0x690
>  do_ipv6_getsockopt.isra.6.constprop.13+0x1706/0x29f0
>  ? do_ipv6_mcast_group_source+0x150/0x150
>  ? __wake_up_common+0x620/0x620
>  ? mutex_trylock+0x23f/0x2a0
> [ ... ]
>
> Fixes: 88e2ca308094 ("mld: convert ifmcaddr6 to RCU")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>
> commit 88e2ca308094 ("mld: convert ifmcaddr6 to RCU") is not yet merged
> to "net" branch. So, target branch is "net-next"
>
>  net/ipv6/ipv6_sockglue.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index a6804a7e34c1..55dc35e09c68 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -1137,9 +1137,12 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
>                 val = sk->sk_family;
>                 break;
>         case MCAST_MSFILTER:
> +               rtnl_lock();
>                 if (in_compat_syscall())
> -                       return compat_ipv6_get_msfilter(sk, optval, optlen);
> -               return ipv6_get_msfilter(sk, optval, optlen, len);
> +                       val = compat_ipv6_get_msfilter(sk, optval, optlen);
> +               val = ipv6_get_msfilter(sk, optval, optlen, len);
> +               rtnl_unlock();
> +               return val;


This seems a serious regression compared to old code (in net tree)

Have you added RTNL requirement in all this code ?

We would like to use RTNL only if strictly needed.
