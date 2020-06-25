Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F9D209881
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 04:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389392AbgFYCcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 22:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389263AbgFYCcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 22:32:25 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9074C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 19:32:23 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so2967197edm.10
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 19:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fHwVLsLINc2tcK2Rh2vnr+1TNhurGp8FOMWk5gH3IGY=;
        b=qWaXT7B4PDf/f3zMmTsdXvBeL71dRmz5R8/ZtLYV+DX3Ohu8/CpavQP3oU1a5H6bwi
         WhWVbTSo6aO2pXIDsnCmADMkMNKMqjm/7Ip3MEYmm+VGxjbEpRnMKgOy0ncG+ji6geMa
         YVT/S9ccxMji7op0q3TqR582HjlTD0DaSrmZL/v2tUBvZuBYIhIiPbDEAd0ODCMnftuY
         1TQ6uHLqC2e/7CRP26V6m/tSXTkjdPMP5VTvRVyybzyATPhBdVYgIWDgRIE2ZkL1N5HR
         ARd+J6iXDKVy60FZnpYbZWGiQiQlb0yFok07kXEfpJyqsy/WEJHsGQcdSFxxCakONuY5
         Uuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fHwVLsLINc2tcK2Rh2vnr+1TNhurGp8FOMWk5gH3IGY=;
        b=VB6uLwQ/oZv6Q7K+ZbQJEiJZIjXa0YCf4i7LGjpnzoC5097jYqIeKIJTGKEknvMXaO
         GaaRfBkIK9IrlPKSsStodAerhtEFANIGnXSImWqcL1TiK0NzLvJsNo40lFr+Os5lNhCI
         AYds36rlaXfpXk5zFGE10EjNAOs/9P9J42hu1IAU6WeqevCh3mhg4J3ZFPoKAB0u7ykE
         VPO1f4yz33BTEpHycgOp3IktVSZQnDyl0rzqqSE7OIqz8mJauxn/yHREHym99+kkGznm
         q71CkU0l9kOZDovQiWIBlpxKG7X1zVEl+cuSf2lLE0w09dUjX7TxKnLixzNc3zFHq7JF
         wuMg==
X-Gm-Message-State: AOAM533B3/3yMCipJR2ZgyOV+fxOqZmUYbQ6xeaFBR++FsLLabcM5MHC
        6OGMKWUoFDfQuQaLy8iAT/vg5R1q2t7sk1OXf7sI7g==
X-Google-Smtp-Source: ABdhPJwGqFEl8Skj51wZEkXj4HyWej9CG6IcFy1kZMYaGFJRbx98HXx1d8iziob0WUJQ1zdAhLSYP+9H19UydFiIXd8=
X-Received: by 2002:a50:934e:: with SMTP id n14mr29910128eda.88.1593052342242;
 Wed, 24 Jun 2020 19:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be> <20200624192310.16923-3-justin.iurman@uliege.be>
In-Reply-To: <20200624192310.16923-3-justin.iurman@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Wed, 24 Jun 2020 19:32:11 -0700
Message-ID: <CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] ipv6: IOAM tunnel decapsulation
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 12:33 PM Justin Iurman <justin.iurman@uliege.be> wrote:
>
> Implement the IOAM egress behavior.
>
> According to RFC 8200:
> "Extension headers (except for the Hop-by-Hop Options header) are not
>  processed, inserted, or deleted by any node along a packet's delivery
>  path, until the packet reaches the node (or each of the set of nodes,
>  in the case of multicast) identified in the Destination Address field
>  of the IPv6 header."
>
> Therefore, an ingress node (an IOAM domain border) must encapsulate an
> incoming IPv6 packet with another similar IPv6 header that will contain
> IOAM data while it traverses the domain. When leaving, the egress node,
> another IOAM domain border which is also the tunnel destination, must
> decapsulate the packet.

This is just IP in IP encapsulation that happens to be terminated at
an egress node of the IOAM domain. The fact that it's IOAM isn't
germaine, this IP in IP is done in a variety of ways. We should be
using the normal protocol handler for NEXTHDR_IPV6  instead of special
case code.

>
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  include/linux/ipv6.h |  1 +
>  net/ipv6/ip6_input.c | 22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> index 2cb445a8fc9e..5312a718bc7a 100644
> --- a/include/linux/ipv6.h
> +++ b/include/linux/ipv6.h
> @@ -138,6 +138,7 @@ struct inet6_skb_parm {
>  #define IP6SKB_HOPBYHOP        32
>  #define IP6SKB_L3SLAVE         64
>  #define IP6SKB_JUMBOGRAM      128
> +#define IP6SKB_IOAM           256
>  };
>
>  #if defined(CONFIG_NET_L3_MASTER_DEV)
> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> index e96304d8a4a7..8cf75cc5e806 100644
> --- a/net/ipv6/ip6_input.c
> +++ b/net/ipv6/ip6_input.c
> @@ -361,9 +361,11 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *));
>  void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
>                               bool have_final)
>  {
> +       struct inet6_skb_parm *opt = IP6CB(skb);
>         const struct inet6_protocol *ipprot;
>         struct inet6_dev *idev;
>         unsigned int nhoff;
> +       u8 hop_limit;
>         bool raw;
>
>         /*
> @@ -450,6 +452,25 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
>         } else {
>                 if (!raw) {
>                         if (xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
> +                               /* IOAM Tunnel Decapsulation
> +                                * Packet is going to re-enter the stack
> +                                */
> +                               if (nexthdr == NEXTHDR_IPV6 &&
> +                                   (opt->flags & IP6SKB_IOAM)) {
> +                                       hop_limit = ipv6_hdr(skb)->hop_limit;
> +
> +                                       skb_reset_network_header(skb);
> +                                       skb_reset_transport_header(skb);
> +                                       skb->encapsulation = 0;
> +
> +                                       ipv6_hdr(skb)->hop_limit = hop_limit;
> +                                       __skb_tunnel_rx(skb, skb->dev,
> +                                                       dev_net(skb->dev));
> +
> +                                       netif_rx(skb);
> +                                       goto out;
> +                               }
> +
>                                 __IP6_INC_STATS(net, idev,
>                                                 IPSTATS_MIB_INUNKNOWNPROTOS);
>                                 icmpv6_send(skb, ICMPV6_PARAMPROB,
> @@ -461,6 +482,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
>                         consume_skb(skb);
>                 }
>         }
> +out:
>         return;
>
>  discard:
> --
> 2.17.1
>
