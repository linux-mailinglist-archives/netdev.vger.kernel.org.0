Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2854C2051B1
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 14:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgFWMDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 08:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732463AbgFWMDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 08:03:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749CCC061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 05:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=N+jPkGdRSIhLCRlSN/30ajaOVyouqVc7y5ysot+vl74=; b=X04X1DG0NqqME/pfMkbVeSC1K
        R4sMa18GOb1sbTH6ruoOiqhOX9/twaMC/miZgOW6tngh9XmNOo9lWjRfylM8q6YWd5cAfT2tCh2jt
        64Gm/c6GIkbQfSGCUeqM1PN+B0VALbpH/VsHS23TbaZUZW4LOglK+6d92trBBt6yQoU2+HS3ee9g3
        pIKG+Qd5atz9xSX+K9WvbyN4+1Nz/Rl3NxGvpy86fpUar6deNYiPYiPtqviHJyWKJR5TkeBcJYQ2L
        mLaAgtNz/U6kWz4ljhnyg1gcahtvfzVN9b6RhB0X1wAabcuzijZzChVBb9HG4Ms+G2mg88hwxQawl
        uhSj+fXbg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59018)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnhdo-0001jv-M5; Tue, 23 Jun 2020 13:03:04 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnhdm-000100-2J; Tue, 23 Jun 2020 13:03:02 +0100
Date:   Tue, 23 Jun 2020 13:03:02 +0100
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
Subject: Re: [PATCH net-next v3 4/9] net: phy: add Lynx PCS module
Message-ID: <20200623120301.GU1551@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-5-ioana.ciornei@nxp.com>
 <20200622101200.GC1551@shell.armlinux.org.uk>
 <VI1PR0402MB387117BC6F2B53E521F6D7EBE0940@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB387117BC6F2B53E521F6D7EBE0940@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:49:28AM +0000, Ioana Ciornei wrote:
> > This should be added to phylink_mii_c45_pcs_get_state().  There is nothing that
> > is Lynx PCS specific here.
> 
> The USXGMII standard only describes the auto-negotiation word, not the MMD
> where this can be found (MMD_VEND2 in this case).
> I would not add a generic phylink herper that reads the MMD and also
> decodes it.
> Maybe a helper that just decodes the USXGMII word read from the
> Lynx module - phylink_decode_usxgmii_word(state, lpa) ?

Yes, you're right - as they come from the vendor 2 MMD, there's no
standard.  So yes, just a helper to decode the USXGMII word please.

> > > +static void lynx_pcs_get_state_2500basex(struct mdio_device *pcs,
> > > +					 struct phylink_link_state *state) {
> > > +	struct mii_bus *bus = pcs->bus;
> > > +	int addr = pcs->addr;
> > > +	int bmsr, lpa;
> > > +
> > > +	bmsr = mdiobus_read(bus, addr, MII_BMSR);
> > > +	lpa = mdiobus_read(bus, addr, MII_LPA);
> > > +	if (bmsr < 0 || lpa < 0) {
> > > +		state->link = false;
> > > +		return;
> > > +	}
> > > +
> > > +	state->link = !!(bmsr & BMSR_LSTATUS);
> > > +	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
> > > +	if (!state->link)
> > > +		return;
> > > +
> > > +	state->speed = SPEED_2500;
> > > +	state->pause |= MLO_PAUSE_TX | MLO_PAUSE_RX;
> > 
> > How do you know the other side is using pause frames, or is capable of dealing
> > with them?
> 
> Isn't this done by also looking into the PHY's pause frame bits and
> enabling pause frames in the MAC only when both the PCS and the PHY
> have flow enabled?

You are assuming that there is a PHY to read that information from.

There may not be a PHY - I have 2500base-X fibre links here, there is
no PHY to read that from, there is only the PCS - but this runs with
the configuration word present, so is not supported by this code (at
least at the moment.)

If there is a PHY, these bits will not be used anyway, so there's no
point setting them.

> Yep, will remove. I've gone through the documentation and the register
> should be initialized to 0x0001 when in SGMII mode
> (as done by phylink_mii_c22_pcs_config()).

Yep, that was actually written referring to the LX2160A documentation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
