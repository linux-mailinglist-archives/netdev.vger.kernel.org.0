Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B126FAC34
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 09:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKMIr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 03:47:27 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60771 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfKMIr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 03:47:27 -0500
X-Originating-IP: 92.137.17.54
Received: from localhost (alyon-657-1-975-54.w92-137.abo.wanadoo.fr [92.137.17.54])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 8AC5D1C0014;
        Wed, 13 Nov 2019 08:47:23 +0000 (UTC)
Date:   Wed, 13 Nov 2019 09:47:22 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 10/12] net: dsa: vitesse: move vsc73xx driver to
 a separate folder
Message-ID: <20191113084722.GI3572@piout.net>
References: <CA+h21hqYynoGwfd=g3rZFgYSKNxsv8PXstD+6btopykweEi1dw@mail.gmail.com>
 <20191112143346.3pzshxapotwdbzpg@lx-anielsen.microsemi.net>
 <20191112145054.GG10875@lunn.ch>
 <20191112145732.o7pkbitrvrr2bb7j@lx-anielsen.microsemi.net>
 <CA+h21hrc-vb412iK+hp20K6huFPBABx6xYQjgi7Ew7ET8ryK+g@mail.gmail.com>
 <20191112190957.nbfb6g2bxiipjnbi@lx-anielsen.microsemi.net>
 <CA+h21hqo9dWct-068pGv2YhzACp5ooaDKzeh92jHNTYyBvgmqw@mail.gmail.com>
 <20191112194814.gmenwbje3dg52s6l@lx-anielsen.microsemi.net>
 <CA+h21hrh4oYs3j3cOz4Afe2GSbU9ME+nzoRaZ4D22mu9_jkO=g@mail.gmail.com>
 <20191113073822.wlsgalzznlng2owt@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113073822.wlsgalzznlng2owt@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/11/2019 08:38:22+0100, Allan W. Nielsen wrote:
> > > > The way I see an Ocelot DSA driver, it would be done a la mv88e6xxx,
> > > > aka a single struct dsa_switch_ops registered for the entire family,
> > > > and function pointers where the implementation differs. You're not
> > > > proposing that here, but rather that each switch driver works in
> > > > parallel with each other, and they all call into the Ocelot core. That
> > > > would produce a lot more boilerplate, I think.
> > > > And if the DSA driver for Ocelot ends up supporting more than 1
> > > > device, its name should better not contain "vsc9959" since that's
> > > > rather specific.
> > > A vsc7511/12 will not share code with felix/vsc9959. I do not expect any other
> > > IP/chip will be register compatible with vsc9959.
> > I don't exactly understand this comment. Register-incompatible in a
> > logical sense, or in a layout sense? Judging from the attachment in
> > chapter 6 of the VSC7511 datasheet [1], at least the basic
> > functionality appears to be almost the same. And for the rest, there's
> > regmap magic.
> My point is that vsc7511 has more in commen with vsc7514 than it has with
> felix/vsc9959.
> 
> vsc7511 will use the same regmaps as those in vsc7514 (with different helper
> functions as it will be accessing the reguster via SPI).
> 

regmap will properly abstract the underlying bus, this was the whole
point of using it.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
