Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819FB3BEC45
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhGGQdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGGQdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:33:12 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB18BC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 09:30:31 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r132so4070511yba.5
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 09:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e8mEPqUsEMREjLYbb8BWV005DUlTdPVMLhBR8qZBZbU=;
        b=mwKpdoO+6j+t7/42T+A4dKRVo9XAd0zrbPjH0qICDoehFeplBMc86VW3Sd0yGFMhRL
         ayQaSqQf0FSVqyjgGImgp422caDMqBUOTutmgexs0FriPEJ+8XJmtbj54gL4VIBNbbd6
         Zce8e+exOU/bkPLw48QgQefFpKXo/t3e/pFU8fqeq4WrKhWitzspQYcIoJPS18vI9bka
         1dLKjsy+QdjiArVzSTF9k6KvnXNluf/RhBfIQ3zYvIM49HSKwj4BWBSOaQjEiDieZ2oF
         vDPD2J75uaQKysCb+xVoo4mLBX1cKnBvrHoYa0IEkCggTA2Ud+dyKbxo1tZtVTDp4KDP
         6CUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e8mEPqUsEMREjLYbb8BWV005DUlTdPVMLhBR8qZBZbU=;
        b=HMriu8XfH76NWJJ0/c8ZKzE2zW1FdAGqsMWFDUgKBPQwh90GPd3q6SbO/dLoFCFXCC
         qQvMHjOnUl8ihyErL/Upq22DhHIJ9XX4gRoB+1NMM95MGsd8Xt+LnYhHNB614jAN6wla
         JeYem4uQqNPVIf+x9clJl+21oLUo0E/bhxki0AAiumUKfa9+jBAbv8F6eMWBL5dOHG8m
         L2dJwJ8L/xIOaGyLnjQHXcCz4RFUlZIzg/05KnVMTsV/RJS4UvCOGfBZd+m8qkw4/Hfv
         YIQ3vG2QI7dU8IvRIUBXZIpSHZOTBuDy71EMq8ZRK9hVFY82KYS9syRVQyRKp4qQgCCG
         bVbA==
X-Gm-Message-State: AOAM530FCMkeRTQppX+Q98HuJylqkyinTMrSZXVMhy4zjfqCDJVBX456
        t9oI/9LNNzBAtul1t+tmt+an587LZFN4SpYfVJ8eog==
X-Google-Smtp-Source: ABdhPJzWGaIYU++8QDGxLE63liZ/sN8WYpwiNh8kcBoIPdOCs6cakJXOVRKO6CLf7LCBo/KcuI9nShJxGcxTVPxD+DE=
X-Received: by 2002:a25:5844:: with SMTP id m65mr34558165ybb.52.1625675430684;
 Wed, 07 Jul 2021 09:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210707154630.583448-1-eric.dumazet@gmail.com>
In-Reply-To: <20210707154630.583448-1-eric.dumazet@gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 7 Jul 2021 09:30:18 -0700
Message-ID: <CANP3RGdrYJCfi0Lf=4+45b6bOaNAm8L8-bH5k-YY6yxFF_a6sA@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 8:46 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
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
> Cc: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  net/ipv6/tcp_ipv6.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 593c32fe57ed13a218492fd6056f2593e601ec79..bc334a6f24992c7b5b2c415ea=
b4b6cf51bf36cb4 100644
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
> +       if (tcp_mss_to_mtu(sk, mtu) >=3D tcp_sk(sk)->mss_cache)
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

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
