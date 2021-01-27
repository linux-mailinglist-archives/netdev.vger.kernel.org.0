Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6829D30675B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhA0W5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 17:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhA0W4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 17:56:15 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4209CC0617AB
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 14:48:52 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so4939023ejf.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 14:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sOWrYdcHQqhmHTK9fs2GTQ+WR1UpvPfBFNucPJ79CrI=;
        b=Dlr+BvsIVObLTX2AjZgzVB8PoK1L4OYbkfH8+VD3C5mITvytTOH7tNZJSh0ZZvP9xP
         cnjTqW6n7YtAWQAGkMCBPLXhR/Km83gOmoCzeEaAijosQF0PgDgtCHQf5sqUxgg0TQ6T
         zRadX2mtvTFx204G5qhR1yVmJStv5PjLTBEA8CemhsD8JL3H3sMg3bjVBWPXW/alQG2g
         RDAHtvLr5suOfiLa7HAuvKTgnBZnWLesIce/LDOnUnzkoUpfx32muZTqtYUXNFmjFImn
         biCJzcJPZbcgYHB5DmPnnmkkIkqCKt9n6STssVprwuXqAFWbvLQNUrJIZvKufIKQngtL
         anZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sOWrYdcHQqhmHTK9fs2GTQ+WR1UpvPfBFNucPJ79CrI=;
        b=n22YupSzTrBtuReZAsw6nRJf28mT1gS06Nnw5ctFKVE63cai8CSx3WvYcIXBMdqklM
         slhGyyRarIfKQCZmO67Xpo+SaGRASZi3lzs5OhJ9aT11XP5INKHzJmdfBrWHm/6j6vJK
         KBEfvOBEunP8aWZWBtDTbzrv9Xi0f9KTPoHl8jtcRZs4zTALzbSaN5oU8AmuhwcQ7ykN
         IMr8gp1aH/1tlDSGa5yApA2TA+7xTpMAN4wJR9wvvMfQ98sJ9muZGKu5O3zCDasqqDpq
         aEsbvD189RViSP3B6aBSxK1YYi9lMdbgtVfwzecPCeVck7JE1Nx88vujo6p+EPDizGU8
         kVUw==
X-Gm-Message-State: AOAM533dRvfsn9cai7+68e0hUZekCrhz4W3PveMOUG8zp6IulOedOs5m
        JHs5fJeWX4IhXuDkM4UTcTxTK1VxPnmWRbaTMx4=
X-Google-Smtp-Source: ABdhPJyNyerWYIGO5sY9o4bEF+l4mplvB9gTvjzQFZKNQhgQNX6SWn3w1Z/pfPZp+/kj5UQgTprJS5G5dZDYKqC2daQ=
X-Received: by 2002:a17:906:494c:: with SMTP id f12mr8682325ejt.56.1611787730878;
 Wed, 27 Jan 2021 14:48:50 -0800 (PST)
MIME-Version: 1.0
References: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
 <CAF=yD-Jw6MqY+hnzFH75E4+3z5jo8dnO5G+KXpTd_vetZ6Gxwg@mail.gmail.com>
 <3afea922-776b-baf3-634c-9a1e84e8c4c2@gmail.com> <CAF=yD-LBAVbVuaJZgpgyU16Wd1ppKquRjvfX=HbDTJABBzeo9A@mail.gmail.com>
 <5229d00c-1b12-38fb-3f2b-e21f005281ec@gmail.com> <CAF=yD-J-XVLpntG=pGxuNUjs898+669v72Mh0PkJ9u34T6paQA@mail.gmail.com>
 <32d17a7c-f0be-5691-8e3f-715f7aab4992@gmail.com>
In-Reply-To: <32d17a7c-f0be-5691-8e3f-715f7aab4992@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 17:48:14 -0500
Message-ID: <CAF=yD-KJbhF7ZtCcaAQQCpnXxKUPrzbO+8+7g=CEh-2n45s3Yw@mail.gmail.com>
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 4:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 27.01.2021 21:35, Willem de Bruijn wrote:
> > On Wed, Jan 27, 2021 at 3:32 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 27.01.2021 20:54, Willem de Bruijn wrote:
> >>> On Wed, Jan 27, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>
> >>>> On 27.01.2021 19:07, Willem de Bruijn wrote:
> >>>>> On Tue, Jan 26, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>>>
> >>>>>> It was reported that on RTL8125 network breaks under heavy UDP load,
> >>>>>> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
> >>>>>> and provided me with a test version of the r8125 driver including a
> >>>>>> workaround. Tests confirmed that the workaround fixes the issue.
> >>>>>> I modified the original version of the workaround to meet mainline
> >>>>>> code style.
> >>>>>>
> >>>>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
> >>>>>>
> >>>>>> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> >>>>>> Tested-by: xplo <xplo.bn@gmail.com>
> >>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >>>>>> ---
> >>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
> >>>>>>  1 file changed, 58 insertions(+), 6 deletions(-)
> >>>>>>
> >>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>> index fb67d8f79..90052033b 100644
> >>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >>>>>> @@ -28,6 +28,7 @@
> >>>>>>  #include <linux/bitfield.h>
> >>>>>>  #include <linux/prefetch.h>
> >>>>>>  #include <linux/ipv6.h>
> >>>>>> +#include <linux/ptp_classify.h>
> >>>>>>  #include <asm/unaligned.h>
> >>>>>>  #include <net/ip6_checksum.h>
> >>>>>>
> >>>>>> @@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
> >>>>>>         return -EIO;
> >>>>>>  }
> >>>>>>
> >>>>>> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
> >>>>>> +static bool rtl_skb_is_udp(struct sk_buff *skb)
> >>>>>>  {
> >>>>>> +       switch (vlan_get_protocol(skb)) {
> >>>>>> +       case htons(ETH_P_IP):
> >>>>>> +               return ip_hdr(skb)->protocol == IPPROTO_UDP;
> >>>>>> +       case htons(ETH_P_IPV6):
> >>>>>> +               return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
> >>>>
> >>>> The workaround was provided by Realtek, I just modified it to match
> >>>> mainline code style. For your reference I add the original version below.
> >>>> I don't know where the magic numbers come from, Realtek releases
> >>>> neither data sheets nor errata information.
> >>>
> >>> Okay. I don't know what is customary for this process.
> >>>
> >>> But I would address the possible out of bounds read by trusting ip
> >>> header integrity in rtl_skb_is_udp.
> >>>
> >> I don't know tun/virtio et al good enough to judge which header elements
> >> may be trustworthy and which may be not. What should be checked where?
> >
> > It requires treating the transmit path similar to the receive path:
> > assume malicious or otherwise faulty packets. So do not trust that a
> > protocol of ETH_P_IPV6 implies a packet with 40B of space to hold a
> > full ipv6 header. That is the extent of it, really.
> >
> OK, so what can I do? Check for
> skb_tail_pointer(skb) - skb_network_header(skb) >= sizeof(struct ipv6hdr) ?

It is quite rare for device drivers to access protocol header fields
(and a grep points to lots of receive side operations), so I don't
have a good driver example.

But qdisc_pkt_len_init in net/core/dev.c shows a good approach for
this robust access in the transmit path: using skb_header_pointer.

> On a side note: Why is IP6_HLEN defined in ptp_classify.h and not in any
> IPv6 header file? Does no IPv6 code need such a constant?

It is customary to use sizeof(struct ipv6hdr)
