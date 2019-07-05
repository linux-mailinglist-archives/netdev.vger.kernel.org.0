Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8D607A2
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbfGEOQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 10:16:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56064 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfGEOQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 10:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GURrO8zgnCuCWI7WBuIEssCv1NdAAbLTM7NAgckfxS8=; b=regnXF4lkzwCetZZfcSAd4XQeG
        9D8cSvAplxUVBOHQi04vypGLshUFcPOgOsXOPGJrAQ5N023ounVLA+9yIcqhN3vIRtMw6KTWr6aPT
        fsG1rayVXOsgSI41FX05TnDZWudG/33PrwsD6XWlG8AqUmzc0VdF0ENyAJn8mHQjIG+w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjP0F-0001PA-P4; Fri, 05 Jul 2019 16:15:55 +0200
Date:   Fri, 5 Jul 2019 16:15:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
Message-ID: <20190705141555.GB4428@lunn.ch>
References: <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net>
 <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch>
 <20190624182614.GC5690@piout.net>
 <CA+h21hqGtA5ou7a3wjSuHxa_4fXk4GZohTAxnUdfLZjV3nq5Eg@mail.gmail.com>
 <20190705044945.GA30115@lunn.ch>
 <CA+h21hqU1H1PefBWKjnsmkMsLhx0p0HJTsp-UYrSgmVnsfqULA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqU1H1PefBWKjnsmkMsLhx0p0HJTsp-UYrSgmVnsfqULA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Let me see if I get your point.
> The D is optional, and the S is optional. So what's left? :)

A collection of interfaces.

switchdev and by extension DSA is all about using hardware as an
accelerator. Linux can do switching in software. It can do routing in
software, it can do bonding in software, etc. switchdev gives you an
API to offload this to hardware. And if the hardware or the driver
does not support it, linux will just keep on doing it in software.

Once you get the idea it is just an accelerator, the rest falls into
place. Why there are no new configuration tools, why we expect network
daemons to just work, why users don't need to learn anything new. It
is all just linux networking as normal.

> Also, there's a big difference between "the hardware can't do it" and
> "the driver doesn't implement it". If I follow your argument, would
> you write a DSA driver for a device that doesn't do L2 switching?

Sure i would. Such a device is a port multiplexor. The user sees the
user ports as linux interfaces. They can use those interfaces just
like any other linux interfaces. Configure them using iproute2, add
them to bridges, run bonding, etc. All just linux as normal.

> Along that same line, what benefit does the DSA model bring to a
> switch that can't do cascading, compared to switchdev? I'm asking this
> as a user, not as a developer.

DSA builds on top of switchdev. switchdev gives you an API to offload
things which are happening in software to the hardware. It is the glue
which allows you to configure the accelerator.

There is also a common pattern for some switches. They connect a
switch port MAC to a host port MAC, so that frames can be passed from
the CPU to the switch. This pattern is common enough that
infrastructure has been put in place to support this model. That
infrastructure is DSA.

But that is mostly about details for the driver writer. From the users
perspective, you have a bunch of interfaces which you just use as
normal, and some stuff can get accelerated by the hardware. We don't
want the user to have to known about, or do anything, with the host
port or the switch port it is connected to. DSA very nearly takes care
of everything to do with those two. The only thing you need to do is
configure the master interface up. Then things just work as a bunch of
Linux interfaces.

Now think about a pure switchdev switch, with a port connected to the
host. The model breaks down. How do you use that link to the switch?
It is just a plane link. You would not have tagging in operation. So
you cannot send frames out specific ports. In order to do that, you
need to add vlans, and configure the switch to map vlans to ports,
etc. You also then have two linux interfaces representing one
port. The pure switchdev interface, and the VLAN interface. That is
going to confuse the user. You SNMP agent is not just going to
work. You get the statistics from the pure switchdev interface, but
the IP configuration from the vlan interface? How do you bridge two
ports together? You need to put the same VLAN on two interfaces. Where
as the DSA model you just use linux as normal and create a bridge, add
the two interfaces, and then the stack transparently offloads it to
the accelerator. How does STP work?

Using DSA without using the D means switch ports just work as linux
interfaces.

> 
> > > So my conclusion is that DSA for Felix/Ocelot doesn't make a lot of
> > > sense if the whole purpose is to hide the CPU-facing netdev.
> >
> > You actually convinced me the exact opposite. You described the
> > headers which are needed to implement DSA. The switch sounds like it
> > can do what DSA requires. So DSA is the correct model.
> >
> >      Andrew
> 
> Somebody actually asked, with the intention of building a board, if
> it's possible to cascade the LS1028A embedded switch (Felix) with
> discrete SJA1105 devices - Felix being at the top of the switch tree.

Florian has done something very similar. He used a Broadcom SoC with
an in built SF2 switch, and an external B53 roboswitch connected to
one of the SF2 ports. But in that setup, the master interface for the
b53 is a slave port of the SF2. Configure everything in device tree,
bring up the SoC master interface, then the SF2 port acting as a
master interface for the B53, and everything just worked. You have a
bunch of Linux interfaces you can just use as normal.

This is not using D in DSA. It is two instances of DSA. But because
the model is that you get normal linux interfaces, it just works. I
don't see why you cannot do the same with a LS1028A and a SJA1105.

    Andrew
