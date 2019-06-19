Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E52CB4B89C
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 14:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732062AbfFSMcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 08:32:22 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34760 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731836AbfFSMcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 08:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LjvptBJSgppkW9dCrF/wZfRlhQzkUo1rCIsKsLaP/3w=; b=TSsG1yj2JyC3lmEhxKXm8tcSn
        KPdOkm5XZq0I9cnfi2jDGluxP2QI9NqA9OLWxqbjl7dmbTTzsfDrVn1Wn5zmi5sSSVCkH9oCRU8S3
        7syAvWaalVUQNimV37V/XjBHZw+6jm4Wxr2lVMcIok79yyu72xWjpNZnTtfYT3fSCKY5AIN1A+laS
        9lbJw+ufs904nI97nhVjGhOC5Oq8c5Mleot7UvmOup/lbsrDSbdrVzOtJlAXcIBZdUdj8V0t0EMRd
        gn9jCbI+fcQowBpLx6FVWT9PDVCFQcdwmmqkrgMDU/BOh6AbrSpn2+sl8rjq6XdwisVRCkkPGQTY8
        TxvmTwhpA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59820)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hdZl4-0000Jz-KG; Wed, 19 Jun 2019 13:32:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hdZl0-0001TG-M3; Wed, 19 Jun 2019 13:32:06 +0100
Date:   Wed, 19 Jun 2019 13:32:06 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>
Subject: Re: [PATCH v2 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190619123206.zvc7gzt4ewxby2y2@shell.armlinux.org.uk>
References: <1560933600-27626-1-git-send-email-pthombar@cadence.com>
 <1560933646-29852-1-git-send-email-pthombar@cadence.com>
 <20190619093146.yajbeht7mizm4hmr@shell.armlinux.org.uk>
 <CO2PR07MB24695C706292A16D71322DB5C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB24695C706292A16D71322DB5C1E50@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 11:23:01AM +0000, Parshuram Raju Thombare wrote:
> >From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> >
> >On Wed, Jun 19, 2019 at 09:40:46AM +0100, Parshuram Thombare wrote:
> >
> >> This patch add support for SGMII interface) and
> >
> >> 2.5Gbps MAC in Cadence ethernet controller driver.
> 
> >>  	switch (state->interface) {
> >
> >> +	case PHY_INTERFACE_MODE_SGMII:
> >
> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> >
> >> +			phylink_set(mask, 2500baseT_Full);
> >
> >
> >
> >This doesn't look correct to me.  SGMII as defined by Cisco only
> >supports 1G, 100M and 10M speeds, not 2.5G.
> 
> Cadence MAC support 2.5G SGMII by using higher clock frequency.

Ok, so why not set 2.5GBASE-X too?  Does the MAC handle auto-detecting
the SGMII/BASE-X speed itself or does it need to be programmed?  If it
needs to be programmed, you need additional handling in the validate
callback to deal with that.

> >> +	case PHY_INTERFACE_MODE_2500BASEX:
> >
> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> >
> >> +			phylink_set(mask, 2500baseX_Full);
> >
> >> +	/* fallthrough */
> >
> >> +	case PHY_INTERFACE_MODE_1000BASEX:
> >
> >> +		if (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)
> >
> >> +			phylink_set(mask, 1000baseX_Full);
> >
> >> +		break;
> >
> >
> >
> >Please see how other drivers which use phylink deal with the validate()
> >format, and please read the phylink documentation:
> >
> > * Note that the PHY may be able to transform from one connection
> > * technology to another, so, eg, don't clear 1000BaseX just
> > * because the MAC is unable to BaseX mode. This is more about
> > * clearing unsupported speeds and duplex settings.
> >
> 
> There are some configs used in this driver which limits MAC speed.
> Above checks just to make sure this use case does not break.

That's not what I'm saying.

By way of example, you're offering 1000BASE-T just because the MAC
connection supports it.  However, the MAC doesn't _actually_ support
1000BASE-T, it supports a connection to a PHY that _happens_ to
convert the MAC connection to 1000BASE-T.  It could equally well
convert the MAC connection to 1000BASE-X.

So, only setting 1000BASE-X when you have a PHY connection using
1000BASE-X is fundamentally incorrect.

For example, you could have a MAC <-> PHY link using standard 1.25Gbps
SGMII, and the PHY offers 1000BASE-T _and_ 1000BASE-X connections on
a first-link-up basis.  An example of a PHY that does this are the
Marvell 1G PHYs (eg, 88E151x).

This point is detailed in the PHYLINK documentation, which I quoted
above.

> >> @@ -506,18 +563,26 @@ static void gem_mac_config(struct phylink_config
> >*pl_config, unsigned int mode,
> >>  		switch (state->speed) {
> >> +		case SPEED_2500:
> >> +			gem_writel(bp, NCFGR, GEM_BIT(GBE) |
> >> +				   gem_readl(bp, NCFGR));
> >>  		}
> >> -		macb_or_gem_writel(bp, NCFGR, reg);
> >>
> >>  		bp->speed = state->speed;
> >>  		bp->duplex = state->duplex;
> >
> >
> >
> >This is not going to work for 802.3z nor SGMII properly when in-band
> >negotiation is used.  We don't know ahead of time what the speed and
> >duplex will be.  Please see existing drivers for examples showing
> >how mac_config() should be implemented (there's good reason why its
> >laid out as it is in those drivers.)
> >
> Ok, Here I will configure MAC only for FIXED and PHY mode.

As you are not the only one who has made this error, I'm considering
splitting mac_config() into mac_config_fixed() and mac_config_inband()
so that it's clearer what is required.  Maybe even taking separate
structures so that it's impossible to access members that should not
be used.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
