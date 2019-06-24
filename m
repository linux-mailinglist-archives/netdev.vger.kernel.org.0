Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416A3508C0
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfFXKWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:22:38 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:60204 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbfFXKWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gYSAqVGmd9+5jafkLGxsrXZP9qRiAS9DRLx55zB7uGk=; b=CDushfXBP9FCxeXoORC2CJQrL
        Zi0OQBvrjQcvo6ZczE3VLjM/kjszpaM6mZPqclTWPFD0DGU59LvGEqwWsTg6TtZ4+FWBVoKANuaD2
        B0PnNEDeu0PLDY1UREPLTzbal0gBLAXd9yHvTKAOckmZ77qaUWdPCbUaGuA4I5Bc+zuyl+yAm2jFv
        LgUNMDmwxZ8mYwvDViXCm5QMstlvjTzZasEBdm9jY+v0/Ar78QhcL2DkduXVKuMuXQ4Bl1t+jlw6X
        v4EpIPMsfxhtAzSHMihYKV07kHF5hHjVVS57uxL62datkuhkP5je588PFW6lWuy0OEInXQRAkE7ST
        10+luZAXA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:59024)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfM7H-0007L2-Tn; Mon, 24 Jun 2019 11:22:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfM7E-00060V-UJ; Mon, 24 Jun 2019 11:22:25 +0100
Date:   Mon, 24 Jun 2019 11:22:24 +0100
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
Message-ID: <20190624102224.6gudxxdaz43wrlcc@shell.armlinux.org.uk>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281781-13479-1-git-send-email-pthombar@cadence.com>
 <20190623101224.nzwodgfo6vvv65cx@shell.armlinux.org.uk>
 <CO2PR07MB246931C79F736F39D0523D3BC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
 <20190624093533.4vhvjmqqrucq2ixf@shell.armlinux.org.uk>
 <CO2PR07MB24699250A3773DE76B6D2E9EC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB24699250A3773DE76B6D2E9EC1E00@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 10:14:41AM +0000, Parshuram Raju Thombare wrote:
> >> >I still don't think this makes much sense, splitting the interface
> >> > configuration between here and below.
> >> Do you mean splitting mac_config in two *_configure functions ?
> >> This was done as per Andrew's suggestion to make code mode readable
> >> and easy to manage by splitting MAC configuration for different interfaces.
> >No, I mean here you disable SGMII if we're switching away from SGMII
> >mode.... (note, this means there is more to come for this sentence)
> Sorry, I misunderstood your original question. I think disabling old interface
> and enabling new one can be done in single place. I will do this change.
> 
> >> >This will only be executed when we are not using inband mode, which
> >> >basically means it's not possible to switch to SGMII in-band mode.
> >> SGMII is used in default PHY mode. And above code is to program MAC to
> >> select PCS and SGMII interface.
> >... and here you enable it for SGMII mode, but only for non-inband
> >modes.
> >
> >Why not:
> >	if (change_interface)  {
> >		if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> >			// Enable SGMII mode and PCS
> >			gem_writel(bp, NCFGR, ncfgr | GEM_BIT(SGMIIEN) |
> >				   GEM_BIT(PCSSEL));
> >		} else {
> >			// Disable SGMII mode and PCS
> >			gem_writel(bp, NCFGR, ncfgr & ~(GEM_BIT(SGMIIEN)
> >				   GEM_BIT(PCSSEL)));
> >			// Reset PCS
> >			gem_writel(bp, PCS_CTRL, gem_readl(bp, PCS_CTRL)
> >				   GEM_BIT(PCS_CTRL_RST));
> >		}
> >	}
> >	if (!phylink_autoneg_inband(mode) &&
> >	    (bp->speed != state->speed || bp->duplex != state->duplex)) {
> >?
> Ok
> 
> >> >> +
> >> >> +		if (!interface_supported) {
> >> >> +			netdev_err(dev, "Phy mode %s not supported",
> >> >> +				   phy_modes(phy_mode));
> >> >> +			goto err_out_free_netdev;
> >> >> +		}
> >> >> +
> >> >>  		bp->phy_interface = phy_mode;
> >> >> +	} else {
> >> >> +		bp->phy_interface = phy_mode;
> >> >> +	}
> >> >If bp->phy_interface is PHY_INTERFACE_MODE_SGMII here, and
> >> > mac_config()
> >> >is called with state->interface = PHY_INTERFACE_MODE_SGMII, then
> >> >mac_config() won't configure the MAC for the interface type - is that
> >> >intentional?
> >> In mac_config configure MAC for non in-band mode, there is also check for
> >> speed, duplex
> >> changes. bp->speed and bp->duplex are initialized to SPEED_UNKNOWN
> >> and DUPLEX_UNKNOWN
> >> values so it is expected that for non in band mode state contains valid speed
> >> and duplex mode
> >> which are different from *_UNKNOWN values.
> 
> >Sorry, this reply doesn't answer my question.  I'm not asking about
> >bp->speed and bp->duplex.  I'm asking:
> >1) why you are initialising bp->phy_interface here
> >2) you to consider the impact that has on the mac_config() implementation
> >  you are proposing
> > because I think it's buggy.
> bp->phy_interface is to store phy mode value from device tree. This is used later 
> to know what phy interface user has selected for PHY-MAC. Same is used
> to configure MAC correctly and based on your suggestion code is
> added to handle PHY dynamically changing phy interface, in which 
> case bp->phy_interface is also updated. Though it may not be what user want, 
> if phy interface is totally decided by PHY and is anyway going to be different from what user
> has selected in DT, initializing it here doesn't make sense.
> But in case of PHY not changing phy_interface dynamically bp->phy_interface need to be
> initialized with value from DT.

When phylink_start() is called, you will receive a mac_config() call to
configure the MAC for the initial operating settings, which will include
the current PHY interface mode.  This will initially be whatever
interface mode was passed in to phylink_create().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
