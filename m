Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A965D3F48B0
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhHWKca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbhHWKcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 06:32:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A204C061575;
        Mon, 23 Aug 2021 03:31:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id cn28so25454947edb.6;
        Mon, 23 Aug 2021 03:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+zmOKLVe4p641MtwlvZ4lgNgbnXQJz9bSnVr4+6Miso=;
        b=SejR1MUfsQ1xBHooEOk9WaCSESHOjadmxZEemiaVpaRy7TXXDHKAu5dm89w7SNBtzS
         /E5djJZDGkYbC6KtVyHnVqIlYeTYpWooslRQTOgolefitvDRKlSjsBNm82AWljH492pj
         fa33pQMA4oh2vtwsXwlOuhvYPhgAzrpDVv3LghJK7QxHqpILGCXL1K5khWeT4NynAlde
         J4mIIWHbMsPRlDC0MqDeFbRcC71B2DXd9bvow7pc6FjM5s4o64I2mG8lx+Ogwz3w1KRa
         VqIWA4PlNtaWkGA5QjTTBmvQm7jiie3Ff6BMyjc0ktHyWoWylfDLAe9eYqOPQYp7c7f2
         PnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+zmOKLVe4p641MtwlvZ4lgNgbnXQJz9bSnVr4+6Miso=;
        b=DDR+L5GSN3N0abcGrrOJkfR8/6ZO42NC/bZjj3y6VCMAzZkU4fc3Aj5g8Dr7Sr34jV
         FH8R5/zYk4pK7woojPsKcwrkIErz6ZgVPVwY4skfbbPEHK1Dvo/y/Qu1ByrzMkGuZ4ZB
         76i+ZMauvi8Pl5cVa3FM7v2P9zYY/iKfz31Uc7NX6m7VwaVxCSeElOM48t6UQwNdfvZI
         fl/Ezt6Ee18QHY6fgwbuXohWrQMJ2SpS5FcnX473IcIdvl74pjMyOd2f3nfV76sdsFk6
         dERw22wI0xz68DfLUc5r5cYboo7SBLCR8CT0wlvdwXijp4J0EUupHQJBEawvY2c12Xp0
         EFgQ==
X-Gm-Message-State: AOAM530GBk6trECkLAli20pkOL9BtTeNMwwvCSdQQ2JGo0gF0T6sQTlO
        5jPTJYvoK0KvoNv6PmtVoZQ=
X-Google-Smtp-Source: ABdhPJw3VkZNQ6clkFng8umx1KNscQpsDoMn7ItKPicoFSyX2F0tUP9x+EBw4jstQ9Lu1HGx4bnDWQ==
X-Received: by 2002:a05:6402:546:: with SMTP id i6mr37306155edx.80.1629714700741;
        Mon, 23 Aug 2021 03:31:40 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id i6sm7095742ejr.68.2021.08.23.03.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:31:40 -0700 (PDT)
Date:   Mon, 23 Aug 2021 13:31:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Message-ID: <20210823103138.iwbtrksra2f6vl4d@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210822224805.p4ifpynog2jvx3il@skbuf>
 <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
 <20210823001953.rsss4fvnvkcqtebj@skbuf>
 <75d2820b-9429-5145-c02d-9c5ce8ceb78f@bang-olufsen.dk>
 <20210823021213.tqnnjdquxywhaprq@skbuf>
 <4928f92c-ed7d-9474-8b6b-21a4baa3a610@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4928f92c-ed7d-9474-8b6b-21a4baa3a610@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 10:06:39AM +0000, Alvin Šipraga wrote:
> I tested your patch with some small modifications to make it apply (I'm
> running 5.14-rc5 right now and it's not so trivial to bump right now -
> let me know if you think it's important).
>
> However I still observe the VLAN ops of my driver getting called (now
> with "tagged, no PVID", which is not what I thought was intended -
> previously it was "untagged, PVID"):
>
> [   45.727777] realtek-smi ethernet-switch swp2: configuring for phy/link mode
> [   45.730173] realtek-smi ethernet-switch: add VLAN 1 on port 2, tagged, no PVID
> [   45.733457] CPU: 1 PID: 595 Comm: systemd-network Tainted: G   O      5.14.0-rc5-20210811-1-rt6 #1
> [   45.733477] Hardware name: B&O (DT)
> [   45.733481] Call trace:
> [   45.733482]  dump_backtrace+0x0/0x1f8
> [   45.733500]  show_stack+0x1c/0x28
> [   45.733508]  dump_stack_lvl+0x64/0x7c
> [   45.733516]  dump_stack+0x14/0x2c
> [   45.733524]  rtl8365mb_set_vlan_4k+0x3c/0xa6c [realtek_smi]
> [   45.733547]  rtl8366_set_vlan+0xb8/0x1f8 [realtek_smi]
> [   45.733564]  rtl8366_vlan_add+0x174/0x228 [realtek_smi]
> [   45.733582]  dsa_switch_event+0x2c4/0xde8
> [   45.733591]  notifier_call_chain+0x80/0xd8
> [   45.733598]  raw_notifier_call_chain+0x1c/0x28
> [   45.733603]  dsa_tree_notify+0x18/0x38
> [   45.733612]  dsa_port_vlan_add+0x54/0x78
> [   45.733620]  dsa_slave_vlan_rx_add_vid+0x80/0x130
> [   45.733627]  vlan_add_rx_filter_info+0x5c/0x80
> [   45.733636]  vlan_vid_add+0xec/0x1c8

This is an unintended consequence for sure. The bridge is persistent and
finds a leak in our defense, see __vlan_vid_add:

	/* Try switchdev op first. In case it is not supported, fallback to
	 * 8021q add.
	 */
	err = br_switchdev_port_vlan_add(dev, v->vid, flags, extack);
	if (err == -EOPNOTSUPP)
		return vlan_vid_add(dev, br->vlan_proto, v->vid);

We return -EOPNOTSUPP to br_switchdev_port_vlan_add, then the bridge
tries with vlan_vid_add, which makes us think it's an 8021q upper, and
we say "oh, yes, but sure!"

Btw, the fact that DSA thinks it's an 8021q upper is also the reason why
your VLAN gets added with different flags, see dsa_slave_vlan_rx_add_vid:

	/* This API only allows programming tagged, non-PVID VIDs */

There is a larger problem at hand, which is that the logic behind
dsa_slave_vlan_rx_add_vid currently adds VLANs to hardware even for many
switch drivers that don't need that. It does not even give the switch
driver the opportunity to distinguish between a bridge VLAN and a VLAN
coming from a VLAN upper interface. I need to think about that too.

This should work if you replace all:

	case SWITCHDEV_OBJ_ID_PORT_VLAN:
		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
			return -EOPNOTSUPP;

with:

	case SWITCHDEV_OBJ_ID_PORT_VLAN:
		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
			return 0;

but I need a bit more time to think of any drawbacks of doing that.

> [   45.733643]  __vlan_add+0x748/0x8c8
> [   45.733650]  nbp_vlan_add+0xf4/0x170
> [   45.733656]  br_vlan_info.isra.0+0x6c/0x120
> [   45.733662]  br_process_vlan_info+0x244/0x368
> [   45.733669]  br_afspec+0x170/0x190
> [   45.733674]  br_setlink+0x174/0x218
> [   45.733679]  rtnl_bridge_setlink+0xbc/0x258
> [   45.733688]  rtnetlink_rcv_msg+0x11c/0x338
> ...
>
> I hope it's clear that even with software bridging, I still want to use
> VLAN to achieve the network topology I described in one of my previous
> replies. I think we are in agreement now that this should be handled
> entirely in software, with the switch being completely VLAN-unaware and
> not touching the VLAN tags. To that end I think I will strip all the
> VLAN ops from the v2 series to make this unambiguous. But regardless of
> that, shouldn't your patch ensure that no VLAN operations are offloaded
> to the switch hardware if .port_bridge_{join,leave} are not implemented?

See above for the 2 corner cases that exist. The only reason why
dsa_slave_vlan_rx_add_vid() exists is to work around some hardware
quirks where some switches cannot put their standalone ports in
VLAN-unaware mode. So to accept VLAN-tagged packets, DSA needs to trap
the vlan_vid_add() calls to perform VLAN RX filtering on these
standalone ports. You do not need this functionality at all, but we do
not distinguish between switches that need it and switches that don't,
hence the issues.

> > I can understand why a lot of things didn't make sense for you. I thought
> > we were on the same page about what is happening, but we weren't.
>
> Yeah, the fact that my VLAN ops were still getting called led me to
> believe that there was still utility in keeping them there. I was not
> aware of the details of the implementation, but your explanation is
> making things a lot clearer to me. I hope you can answer the above
> question which I think will clear up any other misunderstandings I might
> have here.

I fail to see any reason why any external factors would modify the state
of a standalone switch port.

> >> Perhaps I could rephrase my question as follows: If
> >> the switch driver behaves properly (i.e. does not strip or tag frames)
> >> despite the switch being VLAN-aware, is it a problem?
> >>
> >> (We can of course argue whether the switch is behaving correctly with my
> >> driver, but the question assumes that it is.)
> >>
> >> The VLAN code will be of use when implementing bridge offload, so I'm
> >> seeking some advice from you with regards to the process. I can remove
> >> all the VLAN stuff and resubmit the driver such that the switch behaves
> >> in a completely VLAN-unaware fashion, but that will require some
> >> backtracking and the work will have to be done again if any offloading
> >> is to be implemented. So if we can agree that it doesn't cause any harm,
> >> I would think that it's OK to keep it in.
> >
> > With DSA now doing the right thing with the patch I just sent, I hope it is
> > now clearer why having VLAN ops does not make sense if you don't offload
> > the bridge. They were not supposed to be called.
>
> Per the above, your explanation makes sense, except that my VLAN ops are
> still getting called. If I can understand why that's (not) supposed to
> happen, I think we'll be on the same page.

See above.

> >>> My best guess is: you have a problem with transmitting VLAN-tagged
> >>> packets on a port, even if that port doesn't offload the bridge
> >>> forwarding process. You keep transmitting the packet to the switch as
> >>> VLAN-tagged and the switch keeps stripping the tag. You need the VLAN
> >>> ops to configure the VLAN 2 as egress-tagged on the port, so the switch
> >>> will leave it alone.
> >>> It all has to do with the KEEP bit from the xmit DSA header. The switch
> >>> has VLAN ingress filtering disabled but is not VLAN-unaware. A standalone
> >>> port (one which does not offload a Linux bridge) is expected to be
> >>> completely VLAN-unaware and not inject or strip any VLAN header from any
> >>> packet, at least not in any user-visible manner. It should behave just
> >>> like any other network interface. Packet in, packet out, and the skb
> >>> that the network stack sees, after stripping the DSA tag, should look
> >>> like the packet that was on the wire (and similarly in the reverse direction).
> >>>
> >>
> >> I am actually enabling VLAN ingress filtering. And I don't have a
> >> problem transmitting VLAN 2-tagged packets on swp3 in my example.
> >> Whether or not the driver is following the best practices - I'm not
> >> sure. Following on from above: is the best practice to make the switch
> >> completely VLAN-unaware if I am submitting a driver which does not
> >> support any bridge offloading?
> >
> > VLAN unaware, no ingress filtering, no address learning, all ports
> > forward to the CPU port and only to the CPU port.
>
> Got it. I'll make sure this is the case in v2 unless I find the time to
> work on the offloading functionality in the interim. Thanks again.

Even if you find the time to work on bridge offloading, standalone ports
should still behave like that: no learning, VLAN-unaware, no ingress
filtering, forward only to the CPU, flood all packets. You may find that
the switchover from one state to the other is a bit tricky, but it needs
to be consistent.
