Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5EF1206A6
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 14:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfLPNJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 08:09:29 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39344 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfLPNJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 08:09:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CfyoaQveQuKz3lIciCR6AFFu66FHd5f6ltQUk7hTEXQ=; b=W4xq/rtlHZtDvWWVO3NJoxg5X
        Fx2A0IB0zLTpnT3Sq36iN1rVXTytS7ydAvhNCmB1OTgG9fPfwRKI1LE7oJdaEuzB93/xFxXVxV01d
        ZNhXhFCiTdn92FWCFTZLprEAePG27+DVv/bmUeqKR5AHCkiTXA5YL0IHkuN3/iFKvY1zAZ0d5w9yR
        5cV9vmSDdPqFaCp2UGJpLgB0wMRyRzhqhPxfD3Wvqy06+0SmYPg3DOYPstiG+mYgezoqVBfvS3m/m
        LOzw7eV/wbhdjWfxfkiUf0ff3eAeDQof58CUm5p4kaAcma4O/t8yYRjb++4k24umRKOCk4e31Y9nW
        WhiwUY1DA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53776)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1igq7e-0007aU-Id; Mon, 16 Dec 2019 13:09:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1igq7Y-0002QR-H8; Mon, 16 Dec 2019 13:09:08 +0000
Date:   Mon, 16 Dec 2019 13:09:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Milind Parab <mparab@cadence.com>
Cc:     "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>
Subject: Re: [PATCH v2 3/3] net: macb: add support for high speed interface
Message-ID: <20191216130908.GI25745@shell.armlinux.org.uk>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
 <1576230177-11404-1-git-send-email-mparab@cadence.com>
 <20191215151249.GA25745@shell.armlinux.org.uk>
 <20191215152000.GW1344@shell.armlinux.org.uk>
 <BY5PR07MB65143D385836FF49966F5F6AD3510@BY5PR07MB6514.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR07MB65143D385836FF49966F5F6AD3510@BY5PR07MB6514.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 12:49:59PM +0000, Milind Parab wrote:
> >> > +	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
> >>
> >> Why bp->phy_interface and not state->interface?
> 
> okay, this needs to change to state->interface
> 
> >>
> >> If you don't support selecting between USXGMII and other modes at
> >> runtime, should macb_validate() be allowing ethtool link modes for
> >> it when it's different from the configured setting?
> 
> We have separate SGMII and USXGMII PCS, which are enabled and programmed 
> by MAC driver. Also, there are separate low speed (up to 1G) and high 
> speed MAC which can be programmed though MAC driver. 
> As long as, PHY (PMA, external to Cadence MAC controller) can handle 
> this change, GEM can work with interface changes at a runtime.
> 
> >>
> >> > +		if (gem_mac_usx_configure(bp, state) < 0) {
> >> > +			spin_unlock_irqrestore(&bp->lock, flags);
> >> > +			phylink_mac_change(bp->phylink, false);
> >>
> >> I guess this is the reason you're waiting for the USXGMII block
> >> to lock - do you not have any way to raise an interrupt when
> >> something changes with the USXGMII (or for that matter SGMII)
> >> blocks?  Without that, you're fixed to a single speed.
> 
> Yes, we need to wait (poll) until USXGMII block lock is set.
> Interrupt for USXGMII block lock set event is not supported.

You should poll for that status. We already have some polling support
in phylink (in the case of a fixed link using the callback, or a GPIO
that has no interrupt support) so it probably makes sense to extend
that functionality for MACs that do not provide status interrupts.

> >BTW, if you don't have an macb_mac_pcs_get_state() implementation,
> >and from what you described last time around, I don't see how SGMII
> >nor this new addition of USXGMII can work for you. Both these
> >protocols use in-band control words, which should be read and
> >interpreted in macb_mac_pcs_get_state().
> >
> >What I think you're trying to do is to use your PCS PHY as a normal
> >PHY, or maybe you're ignoring the PCS PHY completely and relying on
> >an external PHY (and hence always using MLO_AN_PHY or MLO_AN_FIXED
> >mode.)
> 
> We are limiting our functionality to 10G fixed link using PCS and SFP+
> Though the Cadence MAC is a full functional ethernet MAC controller, 
> we are not sure what PHY or PCS be used in the end system.
> Hence we are using PCS PHY as a normal PHY and not dependent on 
> macb_mac_pcs_get_state().

If you use the PCS PHY as a normal PHY, then this knocks out the
idea below of using phylib to access the external PHY - it is not
possible to stack two phylib controlled PHYs sanely on one network
device.

> Also it should be noted that we are 
> not doing any change in SGMII. Status available in PCS is 
> just a "status transferred" from PHY. So in case of SGMII, whether 
> we read from PCS or from PHY, it is the same information.

So how do you plan to deal with a PHY that you can't read the
status from? This is where the SGMII in-band is required.  Such
SFP modules do exist.

> Below are listed all the possible use cases of Cadence GEM 10G controller
> 
> Basic MII MAC/PHY interconnect using MDIO for link status xfer.
>  +-------------+                                    +--------+
>  |             |                                    |        |
>  | GEM MAC/DMA | <------ GMII/RGMII/RMII/MII -----> |  PHY   |
>  |             |                                    |        |
>  +-------------+                                    +--------+
>        ^                                                 ^
>        |_____________________ MDIO ______________________|
> 
> No PHY. No status xfer required. GEM PCS responsible for auto-negotiation
> across link. Driver must interrogate PCS registers within GEM.
>  +-------------+                                    +--------+
>  |             |       |        |                   |        |
>  | GEM MAC/DMA | <---> | SerDes | <- 1000BASE-X ->  |  SFP   |
>  |    PCS      |       | (PMA)  |                   |        |
>  +-------------+                                    +--------+      

This setup requires macb_mac_pcs_get_state() to be implemented to
interrogate the PCS at the MAC.  Note that some SFPs require SGMII,
and others can also operate at 2500baseX.

> SGMII MAC/PHY interconnect using MDIO for link status xfer.
>  +-------------+                                    +--------+
>  |             |       |        |                   |        |
>  | GEM MAC/DMA | <---> | SerDes | <--- SGMII --->   |  PHY   |
>  |  SGMII PCS  |       | (PMA)  |                   |        |
>  +-------------+                                    +--------+
>        ^                                                 ^
>        |_____________________ MDIO ______________________|
> 
> SGMII MAC/PHY interconnect using inline status xfer. Multi-rate.
> Driver must interrogate PCS registers within GEM.
>  +-------------+                                    +--------+
>  |             |       |        |                   |        |
>  | GEM MAC/DMA | <---> | SerDes | <--- SGMII --->   |  PHY   |
>  |  SGMII PCS  |       | (PMA)  |                   |        |
>  +-------------+                                    +--------+

This setup requires macb_mac_pcs_get_state() to be implemented to
interogate the SGMII PCS at the MAC.

> Up to 2.5G. MAC/PHY interconnect. Rate determined by 2.5GBASE-T PHY capability.
>  +--------------+                                  +-----------+
>  |              |       |        |                 |           |
>  | GEM MAC/DMA  | <---> | SerDes | <-2500BASE-X->  |2.5GBASE-T |
>  |2.5GBASE-X PCS|       | (PMA)  |                 |   PHY     |
>  +--------------+                                  +-----------+

This is fixed at 2.5G speeds.

> No ability for host to interrogate Optical.
>  +--------------+                                  +-----------+
>  |              |       |        |                 |  SFP+     |
>  | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | Optical   |
>  |   USX PCS|   |       | (PMA)  |                 | Module    |
>  +--------------+                                  +-----------+
> 
> Additional 3rd party I2C IP required (not part of GEM) for module
> interrogation (MDIO to I2C handled by SW
>  +--------------+                                  +-----------+
>  |              |       |        |                 |  SFP+     |
>  | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | Optical   |
>  |   USX PCS|   |       | (PMA)  |                 | Module    |
>  +--------------+                                  +-----------+
>                                                          ^
>         +--------+                                       |
>         | I2C    |                                       |
>         | Master | <-------------------------------------|
>         +--------+

The kernel supports this through the sfp and phylink support. SFI is
more commonly known as 10GBASE-R. Note that this is *not* USXGMII.
Link status needs to come from the MAC side, so macb_mac_pcs_get_state()
is required.

> Rate determined by 10GBASE-T PHY capability through auto-negotiation. 
> I2C IP required
>  +--------------+                                  +-----------+
>  |              |       |        |                 |  SFP+ to  |
>  | GEM MAC/DMA  | <---> | SerDes | <---- SFI-----> | 10GBASE-T |
>  |   USX PCS|   |       | (PMA)  |                 |           |
>  +--------------+                                  +-----------+
>                                                          ^
>         +--------+                                       |
>         | I2C    |                                       |
>         | Master | <-------------------------------------|
>         +--------+

The 10G copper module I have uses 10GBASE-R, 5000BASE-X, 2500BASE-X,
and SGMII (without in-band status), dynamically switching between
these depending on the results of the copper side negotiation.

> USXGMII PHY. Uses MDIO or equivalent for status xfer
>  +-------------+                                    +--------+
>  |             |       |        |                   |        |
>  | GEM MAC/DMA | <---> | SerDes | <--- USXGMII ---> |  PHY   |
>  |  USX PCS    |       | (PMA)  |                   |        |
>  +-------------+                                    +--------+
>        ^                                                 ^
>        |_____________________ MDIO ______________________|

Overall, please implement phylink properly for your MAC, rather than
the current half-hearted approach that *will* break in various
circumstances.

I think part of the problem here is that you have a different view how
phylink should be used to cover all these cases from my view. I'm not
prepared to guarantee that the phylink code will work with your view
into the future. I would much prefer there to be consistency in the
way phylink is used between implementations so we don't end up with
major maintanence problems into the future, so having consistency is
important.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
