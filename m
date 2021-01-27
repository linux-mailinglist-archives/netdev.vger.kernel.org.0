Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACED306540
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhA0UgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhA0UgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:36:22 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CEFC061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:35:41 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id dj23so4034900edb.13
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J7Fi3ditqA0dOrsLD3+H/Nqu+5kVnVx+XrFXDXSyoSE=;
        b=rJ37sfXkHR7PfcOt/RJcO9lHhm8HIeb0KJtlhbiMWJTk8VRZSxOJubHkUOgy7RWgeU
         59IE53frDgZ++z0iUPX1Eum0kfVzjLsI+i9burB0le2cUVFsGUv/OCL1p+Zt99z91hD7
         8n80G1PJ4zxdH6wY3fRq9TeE1NqJOCAiCvAlgshQzSpOQ6CxiRJvJ51IgPROEuBD8eV+
         z+clxGHSHClFdFBtfTpLrUNsBnkjGxtWX9A39/ak5w+H+veyNljxvnKehoQEquhTXBeo
         fT7ycjKHcne8OWsugqxVwnSeuhQMZ2Wkxum38L237Cjj9Ijx4BExL8DAz9fXkf1VoIm9
         zy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J7Fi3ditqA0dOrsLD3+H/Nqu+5kVnVx+XrFXDXSyoSE=;
        b=rr6vpsWum5q3jsKyr7Cp1EdINDnV5ftp/sB+GqupTzs0khbiyCefFhMMmGEC3Z8hSg
         v/ETGDadgGrLz/DfzQGoOHGrpG9GjyJzmIzcN8uDUgDblaYqZxo1+LxXdrKMQ40KW/DP
         fU2dcn24cXR9debv5zauJpxxR24avGicEeuuywS/6Yaxug830s1tgmh4yIJEgfgZ0tIW
         1716H6Z4BSs0BsEOWAqp32bqUUI5q4aA8KeBPS7YyCaNhL46DbUUVlhh/FxIE0Rzjr1x
         31mkINSvW+4jEx9TfiBszPOgRraYavJK8MItVyQCcXutd6Lh6A7fXIm8hkXNlsCnt5Tn
         bNTw==
X-Gm-Message-State: AOAM532FhrbylCiV/JyS66ENhAvMPRPkvXhNZ9jCNKkzNsJV1wNSy4Cd
        SN2n9hKgiYrE7m/3kIcBG4Ld+hivYemMhVWUFCg=
X-Google-Smtp-Source: ABdhPJwexZuQq1NVUdAg+Gje0BLmzkl1r2OpAHC3gLjMCDGJNsMziOBZ5SMRRSJieq0t/hgLYHTWtwftlkumeFYRT7A=
X-Received: by 2002:a05:6402:149a:: with SMTP id e26mr11057621edv.254.1611779740073;
 Wed, 27 Jan 2021 12:35:40 -0800 (PST)
MIME-Version: 1.0
References: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
 <CAF=yD-Jw6MqY+hnzFH75E4+3z5jo8dnO5G+KXpTd_vetZ6Gxwg@mail.gmail.com>
 <3afea922-776b-baf3-634c-9a1e84e8c4c2@gmail.com> <CAF=yD-LBAVbVuaJZgpgyU16Wd1ppKquRjvfX=HbDTJABBzeo9A@mail.gmail.com>
 <5229d00c-1b12-38fb-3f2b-e21f005281ec@gmail.com>
In-Reply-To: <5229d00c-1b12-38fb-3f2b-e21f005281ec@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 15:35:03 -0500
Message-ID: <CAF=yD-J-XVLpntG=pGxuNUjs898+669v72Mh0PkJ9u34T6paQA@mail.gmail.com>
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xplo.bn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 3:32 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 27.01.2021 20:54, Willem de Bruijn wrote:
> > On Wed, Jan 27, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 27.01.2021 19:07, Willem de Bruijn wrote:
> >>> On Tue, Jan 26, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>>>
> >>>> It was reported that on RTL8125 network breaks under heavy UDP load,
> >>>> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
> >>>> and provided me with a test version of the r8125 driver including a
> >>>> workaround. Tests confirmed that the workaround fixes the issue.
> >>>> I modified the original version of the workaround to meet mainline
> >>>> code style.
> >>>>
> >>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
> >>>>
> >>>> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> >>>> Tested-by: xplo <xplo.bn@gmail.com>
> >>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >>>> ---
> >>>>  drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
> >>>>  1 file changed, 58 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> >>>> index fb67d8f79..90052033b 100644
> >>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
> >>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> >>>> @@ -28,6 +28,7 @@
> >>>>  #include <linux/bitfield.h>
> >>>>  #include <linux/prefetch.h>
> >>>>  #include <linux/ipv6.h>
> >>>> +#include <linux/ptp_classify.h>
> >>>>  #include <asm/unaligned.h>
> >>>>  #include <net/ip6_checksum.h>
> >>>>
> >>>> @@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
> >>>>         return -EIO;
> >>>>  }
> >>>>
> >>>> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
> >>>> +static bool rtl_skb_is_udp(struct sk_buff *skb)
> >>>>  {
> >>>> +       switch (vlan_get_protocol(skb)) {
> >>>> +       case htons(ETH_P_IP):
> >>>> +               return ip_hdr(skb)->protocol == IPPROTO_UDP;
> >>>> +       case htons(ETH_P_IPV6):
> >>>> +               return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
> >>
> >> The workaround was provided by Realtek, I just modified it to match
> >> mainline code style. For your reference I add the original version below.
> >> I don't know where the magic numbers come from, Realtek releases
> >> neither data sheets nor errata information.
> >
> > Okay. I don't know what is customary for this process.
> >
> > But I would address the possible out of bounds read by trusting ip
> > header integrity in rtl_skb_is_udp.
> >
> I don't know tun/virtio et al good enough to judge which header elements
> may be trustworthy and which may be not. What should be checked where?

It requires treating the transmit path similar to the receive path:
assume malicious or otherwise faulty packets. So do not trust that a
protocol of ETH_P_IPV6 implies a packet with 40B of space to hold a
full ipv6 header. That is the extent of it, really.
