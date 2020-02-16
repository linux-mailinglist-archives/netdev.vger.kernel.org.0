Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7FEE160580
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 19:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgBPS1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 13:27:07 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41049 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgBPS1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 13:27:07 -0500
Received: by mail-yw1-f67.google.com with SMTP id l22so6864998ywc.8
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 10:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LdhhhlKf6qlExxq6+nzU1vyPVWA5yzvakH2dgHIPxzA=;
        b=MlcMcpyEg3ihOL2bYOYZKkALdF4S6ssLrjGIIkzoBlu66PtLJmkEKqmn6VKCCRh17K
         zkRn+yxW0iO2tre7H1jSI7JeVbEH6NCIs8VTIXWh2fOBqAF6oIMYxlim+50I6EL4erEk
         bp3J9jZDYpcr9IX6QFOaDFfZvsVAAjG8Aphg+Mqu9t3OeGOe7ydZh73IQFIAYw7eFHXb
         s2TjSg8h+JUcVhCMIZmJTKvDs7JqxD+D3DtzJ51g1nYrCaKV8Vt6Mj1UKIXULYMkQ+CK
         y6vtJigfIJYmV464wgbRtbxYKw2cwfVfwNQrjpVCA9foQIFGplh1YEIksvFAgLTRp0//
         NRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LdhhhlKf6qlExxq6+nzU1vyPVWA5yzvakH2dgHIPxzA=;
        b=c6514FvQ9Fh85Y+Hm1NLWVk4x+kXsx6eWmKhz2591YPfs4cfYqv24eG/8TjemdSWkw
         CquViUfdKjAQfmCahJJC/HGbsFeckaIGDvBmldLtMzSI0gDEXmTW08L6JmQG3PNPgICs
         pic26EUuMB9GgmS8Jqj9CgV/7zLVBYN5bVOYxCgY/Jjoduudl8GYGct6vbuzic8lnlLm
         Vo6jMPE+tngHzeqMHH8raHQGz51bP8V9ZRLav8bGJ9Y4URm4YxGqXHOqe5pHNzaQ0e8R
         0RMc4xNPJzrxllyirLnv8XPnAZStSP0J1Qgy3tDW9Ix+F4Jkq5mHPR7Z35HRdtEfffMJ
         KwNA==
X-Gm-Message-State: APjAAAX54ZH6IYI3JQoFcqZxhjlOGN30r9K78FhHVBX8AZKmIiS92rcA
        mTO7a2tpBewAdwB2HpUoaPvWMHwV
X-Google-Smtp-Source: APXvYqwO7kIGNua5DgAKljfWmfCf1kiu3DaAroY2Gid8o5Mlft5aKXgeHPqqlWt3B41EMc5aMMLAcQ==
X-Received: by 2002:a81:8497:: with SMTP id u145mr10453559ywf.254.1581877625281;
        Sun, 16 Feb 2020 10:27:05 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id 141sm5530141yws.54.2020.02.16.10.27.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 10:27:04 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id k69so7598788ybk.4
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 10:27:03 -0800 (PST)
X-Received: by 2002:a25:7c5:: with SMTP id 188mr11494181ybh.178.1581877623443;
 Sun, 16 Feb 2020 10:27:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581745878.git.martin.varghese@nokia.com> <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
In-Reply-To: <c2c5eb533306bccd487c28fb1538554441ad867a.1581745879.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 16 Feb 2020 12:26:18 -0600
X-Gmail-Original-Message-ID: <CA+FuTSfdBm4z4dTT3dHB=Fe7GTwrjJkHRw-5W3cSHbAWa1T_eQ@mail.gmail.com>
Message-ID: <CA+FuTSfdBm4z4dTT3dHB=Fe7GTwrjJkHRw-5W3cSHbAWa1T_eQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 12:20 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> The Bareudp tunnel module provides a generic L3 encapsulation
> tunnelling module for tunnelling different protocols like MPLS,
> IP,NSH etc inside a UDP tunnel.
>
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>

> +struct net_device *bareudp_dev_create(struct net *net, const char *name,
> +                                     u8 name_assign_type,
> +                                     struct bareudp_conf *conf)
> +{
> +       struct nlattr *tb[IFLA_MAX + 1];
> +       struct net_device *dev;
> +       LIST_HEAD(list_kill);
> +       int err;
> +
> +       memset(tb, 0, sizeof(tb));
> +       dev = rtnl_create_link(net, name, name_assign_type,
> +                              &bareudp_link_ops, tb, NULL);
> +       if (IS_ERR(dev))
> +               return dev;
> +
> +       err = bareudp_configure(net, dev, conf);
> +       if (err) {
> +               free_netdev(dev);
> +               return ERR_PTR(err);
> +       }
> +       err = dev_set_mtu(dev, IP_MAX_MTU);

does this not exceed dev->max_mtu?

> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index cec1a54..1bf8065 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1027,6 +1027,12 @@ struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, st
>  struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
>                                          const struct in6_addr *final_dst,
>                                          bool connected);
> +struct dst_entry *ip6_dst_lookup_tunnel(struct sk_buff *skb,
> +                                       struct net_device *dev,
> +                                       struct net *net, struct socket *sock,
> +                                       struct in6_addr *saddr,
> +                                       const struct ip_tunnel_info *info,
> +                                       u8 protocol, bool use_cache);
>  struct dst_entry *ip6_blackhole_route(struct net *net,
>                                       struct dst_entry *orig_dst);
>
> diff --git a/include/net/route.h b/include/net/route.h
> index a9c60fc..81750ae 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -128,6 +128,12 @@ static inline struct rtable *__ip_route_output_key(struct net *net,
>
>  struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
>                                     const struct sock *sk);
> +struct rtable *ip_route_output_tunnel(struct sk_buff *skb,
> +                                     struct net_device *dev,
> +                                     struct net *net, __be32 *saddr,
> +                                     const struct ip_tunnel_info *info,
> +                                     u8 protocol, bool use_cache);
> +
>  struct dst_entry *ipv4_blackhole_route(struct net *net,
>                                        struct dst_entry *dst_orig);
>

Ah, I now see where the difference between net/ipv4/route.c and
net/ipv6/ip6_output.c come from. It follows from existing locations of
 ip6_sk_dst_lookup_flow and ip_route_output_flow.

Looking for the ipv6 analog of ip_route_output_flow, I see that, e.g.,
ipvlan uses ip6_route_output from net/ipv6/route.c without a NULL sk.
But ping calls ip6_sk_dst_lookup_flow.

It might be a better fit behind ip6_route_output_flags, but it's
probably moot, really.
