Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBB5505DE
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbfFXJfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:35:47 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59532 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXJfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fpSnBqoHS/t62dCCVv8D8GC3CBsy2WoT0KVySSUKubY=; b=pW3cVJiySxMHsU+7BMFaWEHQK
        HbqwMFG3+ym2ihWOPMMX41uyGqKy8lLpy0noNuGBUnfS1ALlxJPM4qOCxxZ55K1rq9KAGONS83wj3
        odrcIXuZoMmCcqeom2R4aObpSClDaCwd9265RzW5f0i+rDleWU8vWMH862RVXW6hV/Ex0K83tlE7W
        hDrFwXXN7g82bE/h/hkU+xviPB2n4hFrxjpIvt7I78bMjEBsS9/QKUlrZCxQx2uWRUtomiz8i4g7P
        +wg6VN4XRS5wABDcvnwgntDJBLaDnvsHTaTYmVL++WubZPw8evJMAROTVQeHvzYC3Zr/ZE8IMRSEo
        7N/tBJvcQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:59020)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfLNx-000764-QF; Mon, 24 Jun 2019 10:35:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfLNt-0005x0-9S; Mon, 24 Jun 2019 10:35:33 +0100
Date:   Mon, 24 Jun 2019 10:35:33 +0100
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
Subject: Re: [PATCH v4 2/5] net: macb: add support for sgmii MAC-PHY interface
Message-ID: <20190624093533.4vhvjmqqrucq2ixf@shell.armlinux.org.uk>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281781-13479-1-git-send-email-pthombar@cadence.com>
 <20190623101224.nzwodgfo6vvv65cx@shell.armlinux.org.uk>
 <CO2PR07MB246931C79F736F39D0523D3BC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB246931C79F736F39D0523D3BC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 06:35:44AM +0000, Parshuram Raju Thombare wrote:
> 
> >> +	if (change_interface) {
> >> +		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
> >> +			gem_writel(bp, NCFGR, ~GEM_BIT(SGMIIEN) &
> >> +				   ~GEM_BIT(PCSSEL) &
> >> +				   gem_readl(bp, NCFGR));
> >> +			gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
> >> +				   gem_readl(bp, NCR));
> >> +			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
> >> +				   GEM_BIT(PCS_CTRL_RST));
> >> +		}
> >I still don't think this makes much sense, splitting the interface
> >configuration between here and below.
> Do you mean splitting mac_config in two *_configure functions ?
> This was done as per Andrew's suggestion to make code mode readable
> and easy to manage by splitting MAC configuration for different interfaces.

No, I mean here you disable SGMII if we're switching away from SGMII
mode.... (note, this means there is more to come for this sentence)

> 
> >> +		bp->phy_interface = state->interface;
> >> +	}
> >> +
> >>  	if (!phylink_autoneg_inband(mode) &&
> >>  	    (bp->speed != state->speed ||
> >> -	     bp->duplex != state->duplex)) {
> >> +	     bp->duplex != state->duplex ||
> >> +	     change_interface)) {
> >>  		u32 reg;
> >>
> >>  		reg = macb_readl(bp, NCFGR);
> >>  		reg &= ~(MACB_BIT(SPD) | MACB_BIT(FD));
> >>  		if (macb_is_gem(bp))
> >>  			reg &= ~GEM_BIT(GBE);
> >> +		macb_or_gem_writel(bp, NCFGR, reg);
> >> +
> >> +		if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII)
> >> +			gem_writel(bp, NCFGR, GEM_BIT(SGMIIEN) |
> >> +				   GEM_BIT(PCSSEL) |
> >> +				   gem_readl(bp, NCFGR));
> >This will only be executed when we are not using inband mode, which
> >basically means it's not possible to switch to SGMII in-band mode.
> SGMII is used in default PHY mode. And above code is to program MAC to 
> select PCS and SGMII interface.

... and here you enable it for SGMII mode, but only for non-inband
modes.

For inband modes, you do not have any code that enables SGMII mode.
Since the only inband mode you support is SGMII, this is not very
good behaviour.

Why not:

	if (change_interface) {
		u32 ncfgr;

		bp->phy_interface = state->interface;

		// We don't support 2.5G modes
		gem_writel(bp, NCR, ~GEM_BIT(TWO_PT_FIVE_GIG) &
			   gem_readl(bp, NCR));

		ncfgr = gem_readl(bp, NCFGR);
		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
			// Enable SGMII mode and PCS
			gem_writel(bp, NCFGR, ncfgr | GEM_BIT(SGMIIEN) |
				   GEM_BIT(PCSSEL));
		} else {
			// Disable SGMII mode and PCS
			gem_writel(bp, NCFGR, ncfgr & ~(GEM_BIT(SGMIIEN) |
				   GEM_BIT(PCSSEL)));

			// Reset PCS
			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL) |
				   GEM_BIT(PCS_CTRL_RST));
		}
	}

	if (!phylink_autoneg_inband(mode) &&
	    (bp->speed != state->speed || bp->duplex != state->duplex)) {

?

> 
> >> +
> >> +		if (!interface_supported) {
> >> +			netdev_err(dev, "Phy mode %s not supported",
> >> +				   phy_modes(phy_mode));
> >> +			goto err_out_free_netdev;
> >> +		}
> >> +
> >>  		bp->phy_interface = phy_mode;
> >> +	} else {
> >> +		bp->phy_interface = phy_mode;
> >> +	}
> >If bp->phy_interface is PHY_INTERFACE_MODE_SGMII here, and mac_config()
> >is called with state->interface = PHY_INTERFACE_MODE_SGMII, then
> >mac_config() won't configure the MAC for the interface type - is that
> >intentional?
> 
> In mac_config configure MAC for non in-band mode, there is also check for speed, duplex
> changes. bp->speed and bp->duplex are initialized to SPEED_UNKNOWN and DUPLEX_UNKNOWN
> values so it is expected that for non in band mode state contains valid speed and duplex mode
> which are different from *_UNKNOWN values.

Sorry, this reply doesn't answer my question.  I'm not asking about
bp->speed and bp->duplex.  I'm asking:

1) why you are initialising bp->phy_interface here
2) you to consider the impact that has on the mac_config() implementation
   you are proposing

because I think it's buggy.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
