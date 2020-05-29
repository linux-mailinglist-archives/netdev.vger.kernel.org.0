Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068691E84A8
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgE2RUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:20:46 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:49875 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgE2RUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:20:45 -0400
X-Originating-IP: 86.202.110.81
Received: from localhost (lfbn-lyo-1-15-81.w86-202.abo.wanadoo.fr [86.202.110.81])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 6F481FF809;
        Fri, 29 May 2020 17:20:41 +0000 (UTC)
Date:   Fri, 29 May 2020 19:20:41 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: Re: [PATCH net-next 11/11] net: dsa: ocelot: introduce driver for
 Seville VSC9953 switch
Message-ID: <20200529172041.GG3972@piout.net>
References: <20200527234113.2491988-1-olteanv@gmail.com>
 <20200527234113.2491988-12-olteanv@gmail.com>
 <20200528215618.GA853774@lunn.ch>
 <CA+h21hoVQPVJiYDQV7j+d7Vt8o5rK+Z8APO2Hp85Dt8cOU7e4w@mail.gmail.com>
 <20200529081441.GW3972@piout.net>
 <CA+h21hpqf720YO84QJ6vBbF7chZkgnv_ow2-mRmP9OaOC_Ho1g@mail.gmail.com>
 <20200529090312.GA3972@piout.net>
 <CA+h21hqQmGTrhybFAvqN2A14ZU5KRvS8h2cgGYh185HevtfwWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqQmGTrhybFAvqN2A14ZU5KRvS8h2cgGYh185HevtfwWA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/05/2020 18:42:47+0300, Vladimir Oltean wrote:
> On Fri, 29 May 2020 at 12:03, Alexandre Belloni
> <alexandre.belloni@bootlin.com> wrote:
> >
> > On 29/05/2020 11:30:43+0300, Vladimir Oltean wrote:
> > > > As ocelot can be used in a DSA configuration (even if it is not
> > > > implemented yet), I don't think this would be correct. From my point of
> > > > view, felix and seville are part of the ocelot family.
> > > >
> > >
> > > In this case, there would be a third driver in
> > > drivers/net/dsa/ocelot/ocelot_vsc7511.c which uses the intermediate
> > > felix_switch_ops from felix.c to access the ocelot core
> > > implementation. Unless you have better naming suggestions?
> > >
> >
> > I don't. Maybe felix.c should have been ocelot.c from the beginning but
> > honestly, it doesn't matter that much.
> >
> 
> Technically Seville is not part of the Ocelot family but part of
> Serval, but then again, it's just a marketing name, so it doesn't
> really mean anything..

When I submitted ocelot, I was thinking we would have different drivers
for jaguar, luton, ocelot, serval and serval-t. IIRC, ocelot is a subset
of serval or at least, it is similar enough to share the same driver.

> I am a bit reluctant to rename the DSA driver ops to "ocelot", since
> it would be even more confusing for everyone to have a function
> ocelot_dsa_set_ageing_time that calls ocelot_set_ageing_time. At least
> this way, there's going to be some learning curve figuring out that
> felix is an umbrella term for DSA ops, but there will be more naming
> predictability. (at least that's how I see it)
> 

I'm fine with the current naming, I was certainly not suggesting to
change it.

> > BTW, maybe we should merge the VITESSE FELIX ETHERNET SWITCH DRIVER and
> > MICROSEMI ETHERNET SWITCH DRIVER entries in MAINTAINERS. You do much
> > more work in drivers/net/ethernet/mscc/ than I currently do.
> >
> 
> How would you see the merged MAINTAINERS entry? Something like this?
> 
> MICROSEMI ETHERNET SWITCH DRIVER
> M:    Alexandre Belloni <alexandre.belloni@bootlin.com>
> M:    Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
> M:    Vladimir Oltean <vladimir.oltean@nxp.com>

You should probably be in the top position.

> M:    Claudiu Manoil <claudiu.manoil@nxp.com>
> L:    netdev@vger.kernel.org
> S:    Maintained

I guess this could stay Supported unless you are not paid to work on
that.

> F:    include/soc/mscc/ocelot*
> F:    drivers/net/ethernet/mscc/
> F:    drivers/net/dsa/ocelot/*
> F:    net/dsa/tag_ocelot.c
> 
> Any takers from Microchip, or is the internal mailing list enough?

It seems ok for now, we can always add/replace people later on.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
