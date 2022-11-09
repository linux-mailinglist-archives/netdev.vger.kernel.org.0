Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B93062360C
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 22:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiKIVs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 16:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKIVs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 16:48:26 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2018D1169
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:48:25 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 129so234990ybb.12
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 13:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SgMPJhLjS9ZRJcp1zK8r1hthuF2mqZ5CGdOMUVjv9vc=;
        b=k7mmT3JXZDvE5fRiYKe0Cv0CHH4YQC6lleCmPlOrxBY+6wHcQCxp/7I71DPiPVSBcw
         AyZTqX+feKAilKgB6Thm1gogDVh8/MkLcVN8NeGdB+A3a12hDCYGsX+JSFe/CmpyDTQm
         hDEy5qfYkz3XbIZfL+s0kMjeKHoRlR7QI9wZDCnYLK96CnwizkGoVfZpR5atlrIjmGL4
         n8zIXUcf+CYiEKyJD84dR1FKH3ZOF7hOfCcCtoT1X002lppfICKNF5QkYWqRhQ7ZjvAp
         qQQc0LHk+gZnoCgCtx492mNKqfGOTb6P9u50ydas3v1u5MMb35QbmW+FoKTtMk1OjEA5
         xbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SgMPJhLjS9ZRJcp1zK8r1hthuF2mqZ5CGdOMUVjv9vc=;
        b=mbfLGgzoaE/5VXYeBf0msiLAseakgsMdBaLLm7PEH6Tv/0hRHPr/sna0V4GiQa79cb
         nVCn8MuCm+L+QZcWO2/403iXuo7f8JESRL3nEuWlY/hzqbpQV9AdzumV/fYiZ+C3WnJj
         +BlKe1adL0XHArMIxLUXPWmRJEqIg5vaWIb7lnUfCN+LXygTNfO7Ne4KCgXW9FGgCa4e
         fzZ4nq0b5ek/OV+Xpka6Uol2sCokIYJg1denIrscYKcfHx/0S7UxAl1MzTDrjUfLmZTV
         U1UE3s7evlMOvw3J5by0LNM5LRyvdXIfX2ObwlffA2lqyew9HMvHQvmCJ438+GxHi/f1
         8JmQ==
X-Gm-Message-State: ANoB5pkQ/EmzH880jUYY16HutOoFsHQmXlZnbYMh4t1XAwnHanlcnr4d
        NiREJtjVko7W2yyMplqahoxqqk6FihglC8iBZsBEaw==
X-Google-Smtp-Source: AA0mqf5geaav9i//SZ+GUlOQTO1v9lcHnNHRJ+yJc+kRlQJ5zp8s7HMox4R1Q0D+SKuEz1c2qywRppn2ULf/YTkNJ+A=
X-Received: by 2002:a25:aba9:0:b0:6dc:abe7:26bd with SMTP id
 v38-20020a25aba9000000b006dcabe726bdmr231332ybi.598.1668030503996; Wed, 09
 Nov 2022 13:48:23 -0800 (PST)
MIME-Version: 1.0
References: <20221109014018.312181-1-liuhangbin@gmail.com> <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
 <17540.1668026368@famine> <CANn89i+eZwb3+JO6oKavj5yTi74vaUY-=Pu4CaUbcq==ue9NCw@mail.gmail.com>
 <19557.1668029004@famine>
In-Reply-To: <19557.1668029004@famine>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Nov 2022 13:48:11 -0800
Message-ID: <CANn89iKW60QdMRbpyaYry4Vdfxm41ifh4qFt1azU5FCYkUJBiA@mail.gmail.com>
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 1:23 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Eric Dumazet <edumazet@google.com> wrote:
>
> >On Wed, Nov 9, 2022 at 12:39 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> >>
> >> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >> >
> >> >
> >> >On 11/8/22 17:40, Hangbin Liu wrote:
> >> >> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
> >> >> transport header to be set first. But there is no rule to ask driver set
> >> >> transport header before netif_receive_skb() and bond_handle_frame(). So
> >> >> we will not able to get correct icmp6hdr on some drivers.
> >> >>
> >> >> Fix this by checking the skb length manually and getting icmp6 header based
> >> >> on the IPv6 header offset.
> >> >>
> >> >> Reported-by: Liang Li <liali@redhat.com>
> >> >> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> >> >> Acked-by: Jonathan Toppins <jtoppins@redhat.com>
> >> >> Reviewed-by: David Ahern <dsahern@kernel.org>
> >> >> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >> >> ---
> >> >> v3: fix _hdr parameter warning reported by kernel test robot
> >> >> v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
> >> >> ---
> >> >>   drivers/net/bonding/bond_main.c | 9 +++++++--
> >> >>   1 file changed, 7 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >> >> index e84c49bf4d0c..2c6356232668 100644
> >> >> --- a/drivers/net/bonding/bond_main.c
> >> >> +++ b/drivers/net/bonding/bond_main.c
> >> >> @@ -3231,12 +3231,17 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
> >> >>                     struct slave *slave)
> >> >>   {
> >> >>      struct slave *curr_active_slave, *curr_arp_slave;
> >> >> -    struct icmp6hdr *hdr = icmp6_hdr(skb);
> >> >>      struct in6_addr *saddr, *daddr;
> >> >> +    const struct icmp6hdr *hdr;
> >> >> +    struct icmp6hdr _hdr;
> >> >>      if (skb->pkt_type == PACKET_OTHERHOST ||
> >> >>          skb->pkt_type == PACKET_LOOPBACK ||
> >> >> -        hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> >> >> +        ipv6_hdr(skb)->nexthdr != NEXTHDR_ICMP)
> >> >
> >> >
> >> >What makes sure IPv6 header is in skb->head (linear part of the skb) ?
> >>
> >>         Ah, missed that; skb_header_pointer() will take care of that
> >> (copying if necessary, not that it pulls the header), but it has to be
> >> called first.
> >>
> >>         This isn't a problem new to this patch, the original code
> >> doesn't pull or copy the header, either.
> >
> >Quite frankly I would simply use
> >
> >if (pskb_may_pull(skb, sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr))
> > instead of  skb_header_pointer()
> >because chances are high we will need the whole thing in skb->head later.
>
>         Well, it was set up this way with skb_header_pointer() instead
> of pskb_may_pull() by you in de063b7040dc ("bonding: remove packet
> cloning in recv_probe()") so the bonding rx_handler wouldn't change or
> clone the skb.  Now, I'm not sure if we should follow your advice to go
> against your advice.

Ah... I forgot about this, thanks for reminding me it ;)


>
>         Also, we'd have to un-const the skb parameter through the call
> chain from bond_handle_frame().
>
>         -J
>
> >>
> >>         The equivalent function for ARP, bond_arp_rcv(), more or less
> >> inlines skb_header_pointer(), so it doesn't have this issue.
> >>
> >>         -J
> >>
> >> >
> >> >> +            goto out;
> >> >> +
> >> >> +    hdr = skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr), &_hdr);
> >> >> +    if (!hdr || hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> >> >>              goto out;
> >> >>      saddr = &ipv6_hdr(skb)->saddr;
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
