Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49451A7F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 20:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732850AbfFXS0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 14:26:20 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39951 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfFXS0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 14:26:20 -0400
X-Originating-IP: 90.65.161.137
Received: from localhost (lfbn-1-1545-137.w90-65.abo.wanadoo.fr [90.65.161.137])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 4A0E5E0008;
        Mon, 24 Jun 2019 18:26:15 +0000 (UTC)
Date:   Mon, 24 Jun 2019 20:26:14 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
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
Message-ID: <20190624182614.GC5690@piout.net>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net>
 <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624162431.GX31306@lunn.ch>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/06/2019 18:24:31+0200, Andrew Lunn wrote:
> On Mon, Jun 24, 2019 at 05:23:45PM +0200, Allan W. Nielsen wrote:
> > Hi Andrew,
> > 
> > The 06/24/2019 16:26, Andrew Lunn wrote:
> > > > > Yeah, there are 2 ethernet controller ports (managed by the enetc driver) 
> > > > > connected inside the SoC via SGMII links to 2 of the switch ports, one of
> > > > > these switch ports can be configured as CPU port (with follow-up patches).
> > > > > 
> > > > > This configuration may look prettier on DSA, but the main restriction here
> > > > > is that the entire functionality is provided by the ocelot driver which is a
> > > > > switchdev driver.  I don't think it would be a good idea to copy-paste code
> > > > > from ocelot to a separate dsa driver.
> > > > > 
> > > > 
> > > > We should probably make the ocelot driver a DSA driver then...
> > > An important part of DSA is being able to direct frames out specific
> > > ports when they ingress via the CPU port. Does the silicon support
> > > this? At the moment, i think it is using polled IO.
> > 
> > That is supported, it requires a bit of initial configuration of the Chip, but
> > nothing big (I believe this configuration is part of Claudiu's change-set).
> > 
> > But how do you envision this done?
> > 
> > - Let the existing SwitchDev driver and the DSA driver use a set of common
> >   functions.
> > - Convert the existing Ocelot driver from SwitchDev to DSA
> > - Fork (copy) the existing driver of Ocelot, and modify it as needed for the
> >   Felix driver
> > 
> > My guess is the first one, but I would like to understand what you have in mind.
> 
> I don't know the various architectures the switch is used in. But it
> does seem like a core library, and then a switchdev wrapper for Ocelot
> and a DSA wrapper for Felix would make sense.

Ocelot could also be used in a DSA setting where one port can be
connected to an external MAC and be used to inject/extract frames
to/from any other ports. In that case, the IFH would serve as the DSA
tag.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
