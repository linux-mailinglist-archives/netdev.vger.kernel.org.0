Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076E33BF5DE
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhGHG7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 02:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbhGHG7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 02:59:14 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C30C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 23:56:33 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id e9so1539522vsk.13
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 23:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KpTOobZhEvkRiEkqUvwYcUmD0PwB1jpkFmeCSrxIhf8=;
        b=iXj9DhwrvcPKZAUnTi0nzGhNAHWLAWvIfqAzkimjVgmYQpihE6cFKc3klnDEnf2Kb2
         cNZrLVwEIk+TVyEyIruj60n6pF5Yu9bF8SEoBu8Peb9NuCGFROu7l8M/2GVBP8R7bkqb
         QPZfEjnBKkj7t2mj6MKpjXoG2gZT5I18TH2aNyqr1x4A5bi2a2nhZvWcdGYC53l+5YlZ
         keElyL6E8o4OPa85UjQ4hW/1b7NV0tX59NKnB5XULT8uY20UUPl9kOcLRgzON4smNEQ8
         cV4uD54hKHet0zjOZSYB4PfyWxqaT+y9y6Qll+fBuRvs6V1mPAf+moEastMZnvPaNuCZ
         VXbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KpTOobZhEvkRiEkqUvwYcUmD0PwB1jpkFmeCSrxIhf8=;
        b=fMOWbflRqubaO+dgf7cXZwz6PXg6tt965qWbIRZbzUNxqgTINBDKiUCsHbcy8u5k7a
         aiYUxeZXSEFLpw+p+eJ6r9O5J9FX0rNsqmwiD7N1yX5SQVSCUgIq9Aq5NFFTiDbWRyZX
         RnRmmPpfttTKX8CgW7l4/ox0lmLqvF1hh+4JE/GF6yFFRNZuvsDmBcn0FwxxI3X+B4Al
         3/4Xpl9Rbs/1XCWF2WpIi3sr9Adv/LJgzzdFzWerkeVGsnkv5rJ8cq1Cws0OmpWVwz3Y
         PInEUIiTE4e7rdE3+HMgPLYO9//c8V21fj+pDvyAOqG1r4+sOv59965/fCo7RafTi5bu
         ihdQ==
X-Gm-Message-State: AOAM533zMMJNFkjHtfF/cC9SPA+rmV/67VmMni4znlagW6wlCz+6mjRs
        mLiUKTvPK673BlKFgMqggGKOr6FCRRss5t4kYRrocw==
X-Google-Smtp-Source: ABdhPJxHLXELahLQgPT/b2Cg6SkBOvSAroa4a4VEuLfqe/VQ/xSDvy+lYhoq/n27DNB9OXBFpERFzj0qsJUgFUqTEgM=
X-Received: by 2002:a67:b606:: with SMTP id d6mr25732601vsm.55.1625727392234;
 Wed, 07 Jul 2021 23:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210708065001.1150422-1-eric.dumazet@gmail.com>
In-Reply-To: <20210708065001.1150422-1-eric.dumazet@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 7 Jul 2021 23:56:20 -0700
Message-ID: <CANP3RGczchzUK=ZxyPXS8t0NmuBdJB8ajfQ72MnSQwKRBZKh4w@mail.gmail.com>
Subject: Re: [PATCH v2 net] ipv6: tcp: drop silly ICMPv6 packet too big messages
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 11:50 PM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>
> From: Eric Dumazet <edumazet@google.com>
>
> While TCP stack scales reasonably well, there is still one part that
> can be used to DDOS it.
>
> IPv6 Packet too big messages have to lookup/insert a new route,
> and if abused by attackers, can easily put hosts under high stress,
> with many cpus contending on a spinlock while one is stuck in fib6_run_gc=
()
>
> ip6_protocol_deliver_rcu()
>  icmpv6_rcv()
>   icmpv6_notify()
>    tcp_v6_err()
>     tcp_v6_mtu_reduced()
>      inet6_csk_update_pmtu()
>       ip6_rt_update_pmtu()
>        __ip6_rt_update_pmtu()
>         ip6_rt_cache_alloc()
>          ip6_dst_alloc()
>           dst_alloc()
>            ip6_dst_gc()
>             fib6_run_gc()
>              spin_lock_bh() ...
>
> Some of our servers have been hit by malicious ICMPv6 packets
> trying to _increase_ the MTU/MSS of TCP flows.
>
> We believe these ICMPv6 packets are a result of a bug in one ISP stack,
> since they were blindly sent back for _every_ (small) packet sent to them=
.
>
> These packets are for one TCP flow:
> 09:24:36.266491 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, lengt=
h 1240
> 09:24:36.266509 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, lengt=
h 1240
> 09:24:36.316688 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, lengt=
h 1240
> 09:24:36.316704 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, lengt=
h 1240
> 09:24:36.608151 IP6 Addr1 > Victim ICMP6, packet too big, mtu 1460, lengt=
h 1240
>
> TCP stack can filter some silly requests :
>
> 1) MTU below IPV6_MIN_MTU can be filtered early in tcp_v6_err()
> 2) tcp_v6_mtu_reduced() can drop requests trying to increase current MSS.
>
> This tests happen before the IPv6 routing stack is entered, thus
> removing the potential contention and route exhaustion.
>
> Note that IPv6 stack was performing these checks, but too late
> (ie : after the route has been added, and after the potential
> garbage collect war)
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
> Cc: Martin KaFai Lau <kafai@fb.com>
> ---
> v2: fix typo caught by Martin, thanks !
>
>  net/ipv6/tcp_ipv6.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 593c32fe57ed13a218492fd6056f2593e601ec79..323989927a0a6a2274bcbc1cd=
0ac72e9d49b24ad 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -348,11 +348,20 @@ static int tcp_v6_connect(struct sock *sk, struct s=
ockaddr *uaddr,
>  static void tcp_v6_mtu_reduced(struct sock *sk)
>  {
>         struct dst_entry *dst;
> +       u32 mtu;
>
>         if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
>                 return;
>
> -       dst =3D inet6_csk_update_pmtu(sk, READ_ONCE(tcp_sk(sk)->mtu_info)=
);
> +       mtu =3D READ_ONCE(tcp_sk(sk)->mtu_info);
> +
> +       /* Drop requests trying to increase our current mss.
> +        * Check done in __ip6_rt_update_pmtu() is too late.
> +        */
> +       if (tcp_mtu_to_mss(sk, mtu) >=3D tcp_sk(sk)->mss_cache)
> +               return;
> +
> +       dst =3D inet6_csk_update_pmtu(sk, mtu);
>         if (!dst)
>                 return;
>
> @@ -433,6 +442,8 @@ static int tcp_v6_err(struct sk_buff *skb, struct ine=
t6_skb_parm *opt,
>         }
>
>         if (type =3D=3D ICMPV6_PKT_TOOBIG) {
> +               u32 mtu =3D ntohl(info);
> +
>                 /* We are not interested in TCP_LISTEN and open_requests
>                  * (SYN-ACKs send out by Linux are always <576bytes so
>                  * they should go through unfragmented).
> @@ -443,7 +454,11 @@ static int tcp_v6_err(struct sk_buff *skb, struct in=
et6_skb_parm *opt,
>                 if (!ip6_sk_accept_pmtu(sk))
>                         goto out;
>
> -               WRITE_ONCE(tp->mtu_info, ntohl(info));
> +               if (mtu < IPV6_MIN_MTU)
> +                       goto out;
> +
> +               WRITE_ONCE(tp->mtu_info, mtu);
> +
>                 if (!sock_owned_by_user(sk))
>                         tcp_v6_mtu_reduced(sk);
>                 else if (!test_and_set_bit(TCP_MTU_REDUCED_DEFERRED,
> --
> 2.32.0.93.g670b81a890-goog

(this looks fine)

btw. is there a need/desire for a similar change for ipv4?
