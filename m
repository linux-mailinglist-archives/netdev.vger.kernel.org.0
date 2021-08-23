Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F0A3F435A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 04:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbhHWCNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 22:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbhHWCM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 22:12:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8258C061575;
        Sun, 22 Aug 2021 19:12:16 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b7so23848652edu.3;
        Sun, 22 Aug 2021 19:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=0h3XCbRKBIzU8x5V3P81nVICWznGgvidv4tikLcQT7A=;
        b=TpZo0fBmDR8L+TM6pb6mV/FmwdinoGL4sxc6e1twjPSbO3yF2o40bRFD23Qk6JIoE6
         +hNKmob3Y4/W44RetPBqsUQDDK8btswIssIakBTYFeS7ZEk+0nh+qlEAOa1wA9IQ7oQ2
         4EtKx7H68Z0KzfpbLByijJyZ4V0sS41ZC0CbusfFYsaz8pat9qrFl4HKBg8bcF3+ZVqM
         mJDFqgqgNHqZ/9thrj8P3kIoW+Rzc96U1I2HzvqMx8uzFzzWkn3vOgBur0sY6zvoXarJ
         JusAvkGoKOMcURpokz+D/hg1ol0nQJhCfaknbe04SEaX4SzFdSNmWnvxNL/457Kvf1Ox
         rGow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=0h3XCbRKBIzU8x5V3P81nVICWznGgvidv4tikLcQT7A=;
        b=gNRS/8RjARPdY+Z+iUEvNHZiSfvc0X1MGgB7TVaMKuZqHciYSbQYJphemv9ST/fgrA
         3TPwWfYtGXKhp59zjXtLb2Lmf411dlM7FHFj+yTNlIxcn9reAeNmyiHx+NdF88QbLaLl
         R4uc8QgYw4bK8Ah9hvHEeGBLD5uZS07KR3og/Fk1RyE2gMreEnZWjK7OW+yEj21R0oFs
         drA5TLb/CYqy7cABh4dMoGbl/JKAORZnhDYZs7XRYS0qmKX/PVd6eWhuAQWGRvRIpi5k
         m2pnEAx/PF0f1KpoPZo2UP5ih1o111b/MF+Lxwox6+PFp1Sg1+e3uz8XaWXXEnFmDvZF
         cwWQ==
X-Gm-Message-State: AOAM5319EUYMeZ7XaZu7uSSZU6ffj5JglW9+1iqh8cpfimYhErbgjZ1K
        3tdOtX5GRce1NXr6RpgHyRA=
X-Google-Smtp-Source: ABdhPJyLdY/T1KSQ9tQfvlrRl6ODTwjYtJeU4H+Yl+E3Dbp33YqGSTZ3FwY3OSdWQLH8dBJ9GimSSw==
X-Received: by 2002:a50:99d9:: with SMTP id n25mr35298353edb.310.1629684735264;
        Sun, 22 Aug 2021 19:12:15 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id c21sm6457710ejz.69.2021.08.22.19.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 19:12:15 -0700 (PDT)
Date:   Mon, 23 Aug 2021 05:12:13 +0300
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
Message-ID: <20210823021213.tqnnjdquxywhaprq@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk>
 <20210822224805.p4ifpynog2jvx3il@skbuf>
 <dd2947d5-977d-b150-848e-fb9a20c16668@bang-olufsen.dk>
 <20210823001953.rsss4fvnvkcqtebj@skbuf>
 <75d2820b-9429-5145-c02d-9c5ce8ceb78f@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75d2820b-9429-5145-c02d-9c5ce8ceb78f@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 01:22:53AM +0000, Alvin Šipraga wrote:
> On 8/23/21 2:19 AM, Vladimir Oltean wrote:
> > On Sun, Aug 22, 2021 at 11:56:04PM +0000, Alvin Šipraga wrote:
> >>> I'm not going to lie, the realtek_smi_ops VLAN methods seem highly
> >>> cryptic to me. Why do you do the same thing from .enable_vlan4k as from
> >>> .enable_vlan? What are these supposed to do in the first place?
> >>> Or to quote from rtl8366_vlan_add: "what's with this 4k business?"
> >>
> >> I think realtek-smi was written with rtl8366rb.c in mind, which appears
> >> to have different control registers for VLAN and VLAN4k modes, whatever
> >> that's supposed to mean. Since the RTL8365MB doesn't distinguish between
> >> the two, I just route one to the other. The approach is one of caution,
> >> since I don't want to break the other driver (I don't have hardware to
> >> test for regressions). Maybe Linus can chime in?
> >
> > You don't _have_ to use the rtl8366 ops for VLAN, especially if they
> > don't make sense, do you?
>
> I was mainly referring to the enablement of VLAN versus VLAN4k when I
> said it didn't make sense. The add/del ops seemed to fit well though, so
> I sought to reuse code where I could. But they make use of
> .enable_{vlan,vlan4k}, hence the weird stub you see.
>
> >
> >>> Also, stupid question: what do you need the VLAN ops for if you haven't
> >>> implemented .port_bridge_join and .port_bridge_leave? How have you
> >>> tested them?
> >>
> >> I have to admit that I am also in some doubt about that. To illustrate,
> >> this is a typical configuration I have been testing:
> >>
> >>                                 br0
> >>                                  +
> >>                                  |
> >>                 +----------+-----+-----+----------+
> >>                 |          |           |          |
> >> (DHCP)          +          +           +          +      (static IP)
> >>    wan0      brwan0       swp2        swp3     brpriv0      priv0
> >>     |           + 1 P u    + 1 P u     + 1 P u    +           +
> >>     |           |          |           | 2        | 2 P u     |
> >>     |           |          |           |          |           |
> >>     +-----------+          +           +          +-----------+
> >>                           LAN         PRIV
> >>
> >>            n P u
> >>            ^ ^ ^
> >>            | | |
> >>            | | `--- Egress Untagged
> >>            | `----- Port VLAN ID (PVID)
> >>            `------- VLAN ID n
> >
> > What are priv0 and wan0? Are they local interfaces of your board, put in
> > loopback with switch ports? Are they external devices?
>
> Sorry, I should have clarified. They are veth interface pairs, with one
> end added to the bridge, and the other end used as a standalone "VLAN
> unaware" interface to perform specific functions. wan0 is used as a
> typical Ethernet interface for contacting the Internet and other devices
> on the LAN. priv0 is an interface used to communicate with a private
> device PRIV over VLAN2.

Ok, understood.

> > What does DHCP mean? Is there a server there, or does it mean that the
> > wan0 interface gets IP over DHCP? Where is the DHCP server? Why is "DHCP"
> > relevant?
>
> It was meant to indicate that it is getting an IP address over DHCP over
> the LAN.

Ok, so not relevant.

> >> In this configuration, priv0 is used to communicate directly with the
> >> PRIV device over VLAN2. PRIV can also access the wider LAN by
> >> transmitting untagged frames. My understanding was that the VLAN
> >> configuration is necessary for e.g. packets to be untagged properly on
> >> swp2 egress.
> >
> > swp2 egresses packets only in VLAN 1. In your example, how would any
> > packet become tagged in VLAN 1? VLAN 1 is a pvid on all ports which are
> > members of it.
>
> I thought that frames forwarded by the bridge from brwan0 to swp2 would
> be tagged VLAN 1, and that the switch port should untag it. Is that not
> the case?

Your hardware switch does not know about the existence of brwan0. It
just sees what packets the tagger is sending to it. And in your example,
no one will be sending packets to the switch that the switch must untag.
Packets in VLAN 1 are sent as untagged by the bridge, as a tcpdump on
swp2 will show.

> >> But are you suggesting that this is being done in software
> >> already? I.e. we are sending untagged frames from CPU->switch without
> >> any VLAN tag?
> >
> > With the exception of ports with the TX_FWD_OFFLOAD feature where the
> > VLAN is always left in the packet, the bridge will pop the VLAN ID on
> > transmission if that VLAN is configured as egress-untagged in the
> > software VLAN database corresponding to the destination bridge port.
> > See br_handle_vlan:
> >
> > 	/* If the skb will be sent using forwarding offload, the assumption is
> > 	 * that the switchdev will inject the packet into hardware together
> > 	 * with the bridge VLAN, so that it can be forwarded according to that
> > 	 * VLAN. The switchdev should deal with popping the VLAN header in
> > 	 * hardware on each egress port as appropriate. So only strip the VLAN
> > 	 * header if forwarding offload is not being used.
> > 	 */
> > 	if (v->flags & BRIDGE_VLAN_INFO_UNTAGGED &&
> > 	    !br_switchdev_frame_uses_tx_fwd_offload(skb))
> > 		__vlan_hwaccel_clear_tag(skb);
>
> Right, so that answers my question immediately above: of course it's not
> the case - the bridge will pop the tag before sending it to swp2.
>
> >
> >>
> >> In case you think the VLAN ops are unnecessary given that
> >> .port_bridge_{join,leave} aren't implemented, do you think they should
> >> be removed in their entirety from the current patch?
> >
> > I don't think it's a matter of whether _I_ think that they are
> > unnecessary. Are they necessary? Are these code paths really exercised?
> > What happens if you delete them? These are unanswered questions.
>
> The code paths are exercised, insofar as they are called when I
> configure my bridge.

See? That's exactly where the problem is: "they are called". Let me
explain why they shouldn't.

When a port joins a bridge, dsa_slave_changeupper() will call
dsa_port_bridge_join(). This will dive a bit into DSA internals but will
finally return -EOPNOTSUPP because ds->ops->port_bridge_join is NULL.
This triggers the error path of dsa_broadcast(DSA_NOTIFIER_BRIDGE_JOIN)
which sets back dp->bridge_dev to NULL. The port should behave as
standalone.

Now I just went through the whole code path and this does not happen for
plain bridging: in lack of a ds->ops->port_bridge_join method, DSA is
still happy to return zero, although I don't understand why - I recall
writing a patch specifically for that. Anyway. I just rewrote it and
posted it to the list.

I can understand why a lot of things didn't make sense for you. I thought
we were on the same page about what is happening, but we weren't.

> Perhaps I could rephrase my question as follows: If
> the switch driver behaves properly (i.e. does not strip or tag frames)
> despite the switch being VLAN-aware, is it a problem?
>
> (We can of course argue whether the switch is behaving correctly with my
> driver, but the question assumes that it is.)
>
> The VLAN code will be of use when implementing bridge offload, so I'm
> seeking some advice from you with regards to the process. I can remove
> all the VLAN stuff and resubmit the driver such that the switch behaves
> in a completely VLAN-unaware fashion, but that will require some
> backtracking and the work will have to be done again if any offloading
> is to be implemented. So if we can agree that it doesn't cause any harm,
> I would think that it's OK to keep it in.

With DSA now doing the right thing with the patch I just sent, I hope it is
now clearer why having VLAN ops does not make sense if you don't offload
the bridge. They were not supposed to be called.

> > My best guess is: you have a problem with transmitting VLAN-tagged
> > packets on a port, even if that port doesn't offload the bridge
> > forwarding process. You keep transmitting the packet to the switch as
> > VLAN-tagged and the switch keeps stripping the tag. You need the VLAN
> > ops to configure the VLAN 2 as egress-tagged on the port, so the switch
> > will leave it alone.
> > It all has to do with the KEEP bit from the xmit DSA header. The switch
> > has VLAN ingress filtering disabled but is not VLAN-unaware. A standalone
> > port (one which does not offload a Linux bridge) is expected to be
> > completely VLAN-unaware and not inject or strip any VLAN header from any
> > packet, at least not in any user-visible manner. It should behave just
> > like any other network interface. Packet in, packet out, and the skb
> > that the network stack sees, after stripping the DSA tag, should look
> > like the packet that was on the wire (and similarly in the reverse direction).
> >
>
> I am actually enabling VLAN ingress filtering. And I don't have a
> problem transmitting VLAN 2-tagged packets on swp3 in my example.
> Whether or not the driver is following the best practices - I'm not
> sure. Following on from above: is the best practice to make the switch
> completely VLAN-unaware if I am submitting a driver which does not
> support any bridge offloading?

VLAN unaware, no ingress filtering, no address learning, all ports
forward to the CPU port and only to the CPU port.
