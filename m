Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20A146FA06
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 05:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbhLJEwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 23:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbhLJEwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 23:52:34 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9A6C0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 20:49:00 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z5so26665455edd.3
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 20:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v7lryePrDcBW8bGfJXYUzSqYfPJp8orMyh4Ppmw8niU=;
        b=O758yrgAh+YEDgsIo14qkk+/A438dCYomOvUQthIbr2HicRWLi0/RBxVTC7JlLIBYn
         0dDg5uLDu5yXN5eJI8ovIueQMZkSfuscn3KZKxR8tC2pEA+rG6AjP0d+ACegqp9C0HL2
         HsweZaSClNt+vAoaMGWbaBtZ8bC2rSgov+rPuqwHLvCsBI5X/y5qu6Uwq3JovTGYxu1B
         X8SQnLCLW3YZwKhglst6Hw0sV+fsMYA+1N9nokWx+cSFTS+L/ON+ytn96s00ZcPqqAYi
         HdC+W4dV8APBnfp6H5JwYDAbL6OMRfsUxu55W8ZXivQJcWPUImH2oclxeMoA+80TwYZj
         2Vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v7lryePrDcBW8bGfJXYUzSqYfPJp8orMyh4Ppmw8niU=;
        b=jPZz4y8PHpweXjC4p4pwtLKPTvAl4ExsaWY+5IPtmmtStdZHzSyuDfQOw1NcOgtEFJ
         rQbgDvjyOo+c++UrO2QQMfREExL4K2nroh2mq4KlegFdVM7p22oI9Q0bMl619Z2obV/k
         R8X1j4zfvEODWsc6KXM+EZ/u1eQVHeKcs0pxuEA9NBF2dmoAZtqOcu7Blb4dXFzCSh/g
         NsjgXPMfR1IN6c5CScz7X/CMBl5tfbNTWkVIUEIBc1CY1uyvurJVv5tcX4/z9K9Seorg
         31K6mzy6Mvs6r06i5b5tUsGDS2xeRBicVWcAMHuAmebpQjMYemXSShv/RWC8AmEKYNjQ
         4DGg==
X-Gm-Message-State: AOAM530JhicTI9dz5cQS34P977nGDW0eWKA6+V9p81RXifEA1NXHn+XW
        meNshMDHnL/JWyFNLyXWdk/kHg0vpXu2z9MKnhI=
X-Google-Smtp-Source: ABdhPJwI6NBQgaxZK4/wjOAxB7CUoFJo7WSxkYPRq+Yfi4+Lquxk2Z+d/c8kf2hgHR/C/zKkvALdwIzrykExxxHeEbk=
X-Received: by 2002:a17:906:c155:: with SMTP id dp21mr20988749ejc.450.1639111739023;
 Thu, 09 Dec 2021 20:48:59 -0800 (PST)
MIME-Version: 1.0
References: <54c2ae5d003f49f6a29eec6a67c72315@huawei.com> <35aa84e0d1fe4bd1ad1bf6fb61c83338@huawei.com>
 <396da6f61fa948ac854531e935921dfc@huawei.com>
In-Reply-To: <396da6f61fa948ac854531e935921dfc@huawei.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 10 Dec 2021 12:48:22 +0800
Message-ID: <CAMDZJNXGTGHPLw0Lkz4k5-f_j5Pi1s6A1wWuRUuOMZAnv2EnMg@mail.gmail.com>
Subject: Re: [ovs-discuss] [ovs-dev] [PATCH] datapath: fix crash when ipv6
 fragment pkt recalculate L4 checksum
To:     "zhounan (E)" <zhounan14@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "bugs@openvswitch.org" <bugs@openvswitch.org>,
        "pravin.ovn@gmail.com" <pravin.ovn@gmail.com>,
        Lichunhe <lichunhe@huawei.com>,
        "liucheng (J)" <liucheng11@huawei.com>,
        "Hejiajun (he jiajun, SOCF&uDF )" <hejiajun@huawei.com>,
        Greg Rose <gvrose8192@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 10:59 AM zhounan (E) via discuss
<ovs-discuss@openvswitch.org> wrote:
>
> From: Zhou Nan <zhounan14@huawei.com>
>
> When we set ipv6 addr, we need to recalculate checksum of L4 header.
> In our testcase, after send ipv6 fragment package, KASAN detect "use after free" when calling function update_ipv6_checksum, and crash occurred after a while.
> If ipv6 package is fragment, and it is not first seg, we should not recalculate checksum of L4 header since this kind of package has no
> L4 header.
> To prevent crash, we set "recalc_csum" "false" when calling function "set_ipv6_addr".
> We also find that function skb_ensure_writable (make sure L4 header is writable) is helpful before calling inet_proto_csum_replace16 to recalculate checksum.
>
> Fixes: ada5efce102d6191e5c66fc385ba52a2d340ef50
>        ("datapath: Fix IPv6 later frags parsing")
>
> Signed-off-by: Zhou Nan <zhounan14@huawei.com>
> ---
>  datapath/actions.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/datapath/actions.c b/datapath/actions.c index fbf4457..52cf03e 100644
> --- a/datapath/actions.c
> +++ b/datapath/actions.c
> @@ -456,12 +456,21 @@ static void update_ipv6_checksum(struct sk_buff *skb, u8 l4_proto,
>                                  __be32 addr[4], const __be32 new_addr[4])  {
>         int transport_len = skb->len - skb_transport_offset(skb);
> +       int err;
>
>         if (l4_proto == NEXTHDR_TCP) {
> +               err = skb_ensure_writable(skb, skb_transport_offset(skb) +
> +                               sizeof(struct tcphdr));
> +               if (unlikely(err))
> +                       return;
>                 if (likely(transport_len >= sizeof(struct tcphdr)))
>                         inet_proto_csum_replace16(&tcp_hdr(skb)->check, skb,
>                                                   addr, new_addr, true);
>         } else if (l4_proto == NEXTHDR_UDP) {
> +               err = skb_ensure_writable(skb, skb_transport_offset(skb) +
> +                               sizeof(struct udphdr));
> +               if (unlikely(err))
> +                       return;
>                 if (likely(transport_len >= sizeof(struct udphdr))) {
>                         struct udphdr *uh = udp_hdr(skb);
>
> @@ -473,6 +482,10 @@ static void update_ipv6_checksum(struct sk_buff *skb, u8 l4_proto,
>                         }
>                 }
>         } else if (l4_proto == NEXTHDR_ICMP) {
> +               err = skb_ensure_writable(skb, skb_transport_offset(skb) +
> +                               sizeof(struct icmp6hdr));
> +               if (unlikely(err))
> +                       return;
>                 if (likely(transport_len >= sizeof(struct icmp6hdr)))
>                         inet_proto_csum_replace16(&icmp6_hdr(skb)->icmp6_cksum,
>                                                   skb, addr, new_addr, true);
> @@ -589,12 +602,15 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
>         if (is_ipv6_mask_nonzero(mask->ipv6_src)) {
>                 __be32 *saddr = (__be32 *)&nh->saddr;
>                 __be32 masked[4];
> +               bool recalc_csum = true;
>
>                 mask_ipv6_addr(saddr, key->ipv6_src, mask->ipv6_src, masked);
>
>                 if (unlikely(memcmp(saddr, masked, sizeof(masked)))) {
> +                       if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
> +                               recalc_csum = false;
>                         set_ipv6_addr(skb, flow_key->ip.proto, saddr, masked,
> -                                     true);
> +                                     recalc_csum);
>                         memcpy(&flow_key->ipv6.addr.src, masked,
>                                sizeof(flow_key->ipv6.addr.src));
>                 }
> @@ -614,6 +630,8 @@ static int set_ipv6(struct sk_buff *skb, struct sw_flow_key *flow_key,
>                                                              NEXTHDR_ROUTING,
>                                                              NULL, &flags)
>                                                != NEXTHDR_ROUTING);
> +                       if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
> +                               recalc_csum = false;
>
>                         set_ipv6_addr(skb, flow_key->ip.proto, daddr, masked,
>                                       recalc_csum);
> --
> 2.27.0
>
> _______________________________________________
> discuss mailing list

As Gregory said, you should rebase your patch on linux upstream. and
patch is reviewd in netdev@vger.kernel.org mail list.
OvS kernel module in upstream is:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/openvswitch

When the patch is applied in linux upstream, you can backport it.
Please see the section "Changes to Linux kernel components"
https://docs.openvswitch.org/en/latest/internals/contributing/backporting-patches/

> discuss@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-discuss



-- 
Best regards, Tonghao
