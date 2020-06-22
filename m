Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE832037A0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgFVNO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728188AbgFVNO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:14:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EE9C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 06:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rOX4rxmM//ckyJNaNDC3KwyJHuTQDzbILj8cu8iLcGo=; b=qjBVbKFbnr7fgPLKBT069yVQo
        lXzv4TOgShjAbZnancGHfbdwxb9oTBPI3dpYbPVo4VOzoy1CvdYX1GEwAaWjk1+hlHhMSWFaIsB3C
        3HkzU+6Sk6h+0GtRS75MBTuIahTdZGt/X6qlXkByCo2ANLsO0R9n4zziVeqZFV7qNppBo/ZwkfxvY
        C/FTBfXszTY9B9R1x246yl5LjMLSxNhQf7Bbq9fkqnpxq7PS8XRNIj1PGUcBIDSUP3pXlXM7k7aMV
        pinB6rEualEA/Uu8g0Q6R2Mpprixly35ELd9/I7D+Ux3owSAlgXxutTFendTKMxnGi+Y5tw8ErY0Q
        6Zod0c/hQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58960)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnMHB-0000Dv-E8; Mon, 22 Jun 2020 14:14:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnMH7-000051-08; Mon, 22 Jun 2020 14:14:13 +0100
Date:   Mon, 22 Jun 2020 14:14:12 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
Message-ID: <20200622131412.GF1551@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-6-ioana.ciornei@nxp.com>
 <20200622102213.GD1551@shell.armlinux.org.uk>
 <20200622111057.GM1605@shell.armlinux.org.uk>
 <20200622121609.GN1605@shell.armlinux.org.uk>
 <VI1PR0402MB3871B441D15250A8970DD5A4E0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3871B441D15250A8970DD5A4E0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 12:35:06PM +0000, Ioana Ciornei wrote:
> 
> > Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
> > 
> > On Mon, Jun 22, 2020 at 12:10:57PM +0100, Russell King - ARM Linux admin
> > wrote:
> > > On Mon, Jun 22, 2020 at 11:22:13AM +0100, Russell King - ARM Linux admin
> > wrote:
> > > > On Mon, Jun 22, 2020 at 01:54:47AM +0300, Ioana Ciornei wrote:
> > > > > In order to support split PCS using PHYLINK properly, we need to
> > > > > add a phylink_pcs_ops structure.
> > > > >
> > > > > Note that a DSA driver that wants to use these needs to implement
> > > > > all 4 of them: the DSA core checks the presence of these 4
> > > > > function pointers in dsa_switch_ops and only then does it add a
> > > > > PCS to PHYLINK. This is done in order to preserve compatibility
> > > > > with drivers that have not yet been converted, or don't need, a split PCS
> > setup.
> > > > >
> > > > > Also, when pcs_get_state() and pcs_an_restart() are present, their
> > > > > mac counterparts (mac_pcs_get_state(), mac_an_restart()) will no
> > > > > longer get called, as can be seen in phylink.c.
> > > >
> > > > I don't like this at all, it means we've got all this useless
> > > > layering, and that layering will force similar layering veneers into
> > > > other parts of the kernel (such as the DPAA2 MAC driver, when we
> > > > eventually come to re-use pcs-lynx there.)
> > > >
> 
> The veneers that you are talking about are one phylink_pcs_ops structure
> and 4 functions that call lynx_pcs_* subsequently. We have the same thing
> for the MAC operations.
> 
> Also, the "veneers" in DSA are just how it works, and I don't want to change
> its structure without a really good reason and without a green light from
> DSA maintainers.

Right, but we're talking about hardware that is common not only in DSA
but elsewhere - and we already deal with that outside of DSA with PHYs.
So, what I'm proposing is really nothing new for DSA.

> > > > I don't think we need that - I think we can get to a position where
> > > > pcs-lynx is called requesting that it bind to phylink as the PCS,
> > > > and it calls phylink_add_pcs() directly, which means we do not end
> > > > up with veneers in DSA nor in the DPAA2 MAC driver - they just need
> > > > to call the pcs-lynx initialisation function with the phylink
> > > > instance for it to attach to.
> 
> What I am most concerned about is that by passing the PCS ops directly to the
> PCS module we would lose any ability to apply SoC specific quirks at runtime
> such as errata workarounds.

Do you know what those errata would be?  I'm only aware of A-011118 in
the LX2160A which I don't believe will impact this code.  I don't have
visibility of Ocelot/Felix.

> On the other hand, I am not sure what is the concrete benefit of doing
> it your way. I understand that for a PHY device the MAC is not involved
> in the call path but in the case of the PCS the expectation is that it's
> tightly coupled in the silicon and not plug-and-play.

The advantage is less lines of code to maintain, and a more efficient
and understandable code structure.  I would much rather start off
simple and then augment rather than start off with unnecessary
complexity and then get stuck with it while not really needing it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
