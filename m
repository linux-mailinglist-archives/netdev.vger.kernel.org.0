Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804CF518E9
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfFXQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:45:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34308 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729602AbfFXQp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:45:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so7851504pfc.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NVRIPZBx+6fXy5Np5gmQljVUPQ1UM5jRovrKQDH0h+Y=;
        b=bIn416Rg3dnAnva0k8zrp3hTgc9yvcXWDVAx4rM42QEuD7xSHMrnp5Tw3koYG3beK2
         uq80NsUdcN7avJJs5Y307jflgSl39qh1Un/pMU8rHRpKfcNoXnJQYsis1Ap44rEDUcZN
         lyf/ZxkwD/Uvnaq4ruMOeRTuE87KkrdNk3wdOB7F6IqlNUtaPG6r4A6t3eHwLuNIo5Lj
         9FxZbVec3h2zGhUIRiCB3LqfmdEViSiYLYdPhiImLxuUaKmoGqRiYOd0lPVNcqz87IN/
         nxD5v8KOIUQyxlt/3RXh8ewZq69Cw5gYCsfQcZXGPJgG/u6Y5nRTWMi829yM0SAVkdO8
         iyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NVRIPZBx+6fXy5Np5gmQljVUPQ1UM5jRovrKQDH0h+Y=;
        b=p/AkiRvnq4W887D53yQ7L+vvzZ1ubAppCwRkEGA2KJs0oNBtp7oqW/riyHS5cuwrP4
         pfwnFh6zrjcuH7X7N9Cp49Pjyrgztu426CeSg8poL9sdPMXuVHbdkemSp2kMaLDhmO9H
         60S1L7w2RBcqzcKyUbiG5chssJi3RPpF0UVbvTUlmn6IQNQta2CVJY31zsZVDWpzTFj+
         rWfw3yb3Rc9SVarQv9+q50CWW6f1/wXo4rUbOYwLUuMFcpCYMt6SGXXMV1zd9aVuBNMC
         o6bdMryATqCbtCTEeA/Qy/XJWz6d1TDVdt3Q/yXK5pBbrByMEdZojER9LB54X9NtUym7
         Owvg==
X-Gm-Message-State: APjAAAXQIvN1QhuQ/KyQCzanTL9KUxrIAnIuyTjBCsABeDxxqYRcxWxR
        NOQs4wIgHclJC7bsnxf11/Tf0FxQLYxr6bvk7124Ug==
X-Google-Smtp-Source: APXvYqzUhVOfhmj28MZwsZJnNvngZmvxpzfsGWxJ+Kc0/IG6NUaJfR5TkaQDn9Fzmn1ql6tts9ZXwxr/ajlH2CFW8zU=
X-Received: by 2002:a63:78ca:: with SMTP id t193mr2771485pgc.10.1561394725982;
 Mon, 24 Jun 2019 09:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190622.170816.1879839685931480272.davem@davemloft.net>
 <20190624140109.14775-1-nicolas.dichtel@6wind.com> <20190624140109.14775-2-nicolas.dichtel@6wind.com>
In-Reply-To: <20190624140109.14775-2-nicolas.dichtel@6wind.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 24 Jun 2019 09:45:14 -0700
Message-ID: <CAKwvOdk9yxnO_2yDwuG8ECw2o8kP=w8pvdbCqDuwO4_03rj5gw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] ipv6: constify rt6_nexthop()
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 7:01 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> There is no functional change in this patch, it only prepares the next one.
>
> rt6_nexthop() will be used by ip6_dst_lookup_neigh(), which uses const
> variables.
>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Also, I think this fixes an issues reported by 0day:
https://groups.google.com/forum/#!searchin/clang-built-linux/const%7Csort:date/clang-built-linux/umkS84jS9m8/GAVVEgNYBgAJ

Reported-by: kbuild test robot <lkp@intel.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/vrf.c                | 2 +-
>  include/net/ip6_route.h          | 4 ++--
>  net/bluetooth/6lowpan.c          | 4 ++--
>  net/ipv6/ip6_output.c            | 2 +-
>  net/netfilter/nf_flow_table_ip.c | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
> index 11b9525dff27..311b0cc6eb98 100644
> --- a/drivers/net/vrf.c
> +++ b/drivers/net/vrf.c
> @@ -350,8 +350,8 @@ static int vrf_finish_output6(struct net *net, struct sock *sk,
>  {
>         struct dst_entry *dst = skb_dst(skb);
>         struct net_device *dev = dst->dev;
> +       const struct in6_addr *nexthop;
>         struct neighbour *neigh;
> -       struct in6_addr *nexthop;
>         int ret;
>
>         nf_reset(skb);
> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 4790beaa86e0..ee7405e759ba 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -262,8 +262,8 @@ static inline bool ip6_sk_ignore_df(const struct sock *sk)
>                inet6_sk(sk)->pmtudisc == IPV6_PMTUDISC_OMIT;
>  }
>
> -static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt,
> -                                          struct in6_addr *daddr)
> +static inline const struct in6_addr *rt6_nexthop(const struct rt6_info *rt,
> +                                                const struct in6_addr *daddr)
>  {
>         if (rt->rt6i_flags & RTF_GATEWAY)
>                 return &rt->rt6i_gateway;
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index 19d27bee285e..1555b0c6f7ec 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -160,10 +160,10 @@ static inline struct lowpan_peer *peer_lookup_dst(struct lowpan_btle_dev *dev,
>                                                   struct in6_addr *daddr,
>                                                   struct sk_buff *skb)
>  {
> -       struct lowpan_peer *peer;
> -       struct in6_addr *nexthop;
>         struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
>         int count = atomic_read(&dev->peer_count);
> +       const struct in6_addr *nexthop;
> +       struct lowpan_peer *peer;

I see the added const, but I'm not sure why the declarations were
reordered?  Here and below. Doesn't matter for code review (doesn't
necessitate a v2).

>
>         BT_DBG("peers %d addr %pI6c rt %p", count, daddr, rt);
>
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 834475717110..21efcd02f337 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -59,8 +59,8 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
>  {
>         struct dst_entry *dst = skb_dst(skb);
>         struct net_device *dev = dst->dev;
> +       const struct in6_addr *nexthop;
>         struct neighbour *neigh;
> -       struct in6_addr *nexthop;
>         int ret;
>
>         if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 241317473114..cdfc33517e85 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -439,9 +439,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>         struct nf_flowtable *flow_table = priv;
>         struct flow_offload_tuple tuple = {};
>         enum flow_offload_tuple_dir dir;
> +       const struct in6_addr *nexthop;
>         struct flow_offload *flow;
>         struct net_device *outdev;
> -       struct in6_addr *nexthop;
>         struct ipv6hdr *ip6h;
>         struct rt6_info *rt;
>
> --
> 2.21.0
>


-- 
Thanks,
~Nick Desaulniers
