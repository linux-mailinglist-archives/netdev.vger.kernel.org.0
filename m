Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8299F443ED6
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 10:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhKCJE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 05:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbhKCJEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 05:04:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3D5C061714
        for <netdev@vger.kernel.org>; Wed,  3 Nov 2021 02:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JztgPq5o90byWCXP7gYIHF1PitbiH86DG04Jnh/bxNY=; b=xm8FlpfTykLY6bdFyhLV8SpNuS
        DewEDZ083Sgb0zPFx2Nl34a/HjrGQxYnWSQezCyCTMx66iEy0XfWyHPmU2DbvfhaO2KPwjQw2tOwY
        QCnWZybRAWrD8aP9Y+XbDD+9/AH4F704nDZDMxczmiom4KMb52AZyISSQcCVGSDn+zawh0tKupn0G
        qmWkiLIFVX5ERlKK12AARIzGsVaBfM4kW40BEosz0qKVLv+wsR4DsUnaimTiKHcvyE0u3I0CdfYm0
        eXfhPBNmx32+qM6aOiKdHTUcW+2mz8wFT8lOpPtIU3BxYvwD2gixeMR+0KmSNPQeqyLdrDtW+GxWB
        LlkJLFAg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55456)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1miC9w-0004nT-A9; Wed, 03 Nov 2021 09:02:16 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1miC9u-0006G4-VY; Wed, 03 Nov 2021 09:02:14 +0000
Date:   Wed, 3 Nov 2021 09:02:14 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Simek <michals@xilinx.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: mdio: separate gpio-reset property per child phy usecase
Message-ID: <YYJQFt0mDpcOcxGd@shell.armlinux.org.uk>
References: <SA1PR02MB85605C26380A9D8F4D1FB2AAC7859@SA1PR02MB8560.namprd02.prod.outlook.com>
 <64248ee1-55dd-b1bd-6c4e-0a272d230e8e@gmail.com>
 <SA1PR02MB8560936DB193279B2F2C5721C78C9@SA1PR02MB8560.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR02MB8560936DB193279B2F2C5721C78C9@SA1PR02MB8560.namprd02.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 08:50:30AM +0000, Radhey Shyam Pandey wrote:
> > -----Original Message-----
> > From: Florian Fainelli <f.fainelli@gmail.com>
> > Sent: Wednesday, October 27, 2021 10:48 PM
> > To: Radhey Shyam Pandey <radheys@xilinx.com>; netdev@vger.kernel.org;
> > Andrew Lunn <andrew@lunn.ch>; Heiner Kallweit <hkallweit1@gmail.com>;
> > Russell King <linux@armlinux.org.uk>
> > Cc: Michal Simek <michals@xilinx.com>; Harini Katakam <harinik@xilinx.com>
> > Subject: Re: mdio: separate gpio-reset property per child phy usecase
> > 
> > +PHY library maintainers,
> > 
> > On 10/27/21 5:58 AM, Radhey Shyam Pandey wrote:
> > > Hi all,
> > >
> > > In a xilinx internal board we have shared GEM MDIO configuration with
> > > TI DP83867 phy and for proper phy detection both PHYs need prior
> > > separate GPIO-reset.
> > >
> > > Description:
> > > There are two GEM ethernet IPs instances GEM0 and GEM1. GEM0 and GEM1
> > > used shared MDIO driven by GEM1.
> > >
> > > TI PHYs need prior reset (RESET_B) for PHY detection at defined address.
> > > However with current framework limitation " one reset line per PHY
> > > present on the MDIO bus" the other PHY get detected at incorrect
> > > address and later having child PHY node reset property will also not help.
> > >
> > > In order to fix this one possible solution is to allow reset-gpios
> > > property to have PHY reset GPIO tuple for each phy. If this approach
> > > looks fine we can make changes and send out a RFC.
> > 
> > I don't think your proposed solution would work because there is no way to
> > disambiguate which 'reset-gpios' property applies to which PHY, unless you use
> > a 'reset-gpio-names' property which encodes the phy address in there. But
> > even doing so, if the 'reset-gpios' property is placed within the MDIO controller
> > node then it applies within its scope which is the MDIO controller. The other
> > reason why it is wrong is because the MDIO bus itself may need multiple resets
> > to be toggled to be put in a functional state. This is probably uncommon for
> > MDIO, but it is not for other types of peripherals with complex asynchronous
> > reset circuits (the things you love to hate).
> > 
> > The MDIO bus layer supports something like this which is much more accurate
> > in describing the reset GPIOs pertaining to each PHY device:
> > 
> > 	mdio {
> > 		..
> > 		phy0: ethernet-phy@0 {
> > 			reg = <0>;
> > 			reset-gpios = <&slg7xl45106 5 GPIO_ACTIVE_HIGH>;
> > 		};
> > 		phy1: ethernet-phy@8 {
> > 			reg = <8>;
> > 			reset-gpios = <&slg7xl45106 6 GPIO_ACTIVE_HIGH>;
> > 		};
> > 	};
> > 
> > The code that will parse that property is in drivers/net/phy/mdio_bus.c under
> > mdiobus_register_gpiod()/mdiobus_register_reset() and then
> > mdio_device_reset() called by phy_device_reset() will pulse the per-PHY device
> > reset line/GPIO.
> > 
> > Are you saying that you tried that and this did not work somehow? Can you
> > describe in more details how the timing of the reset pulsing affects the way
> > each TI PHY is going to gets its MDIO address assigned?
> 
> Yes, having reset-gpios in PHY node is not working.  Just to highlight - We are
> using external strap configuration for PHY Address configuration. The strap
> pin configuration is set by sw stack at a later stage. PHY address on 
> power on is configured based on sampled values at strap pins which is not
> PHY address mentioned in DT. (It could be any PHY Address depending on
> strap pins default input). For PHY detect to happen at proper PHY Address
> we have call PHY reset (RESET_B) after strap pins are configured otherwise 
> probe (of_mdiobus_phy_device_register) fails and we see below error:
> 
> mdio_bus ff0c0000.ethernet-ffffffff: MDIO device at address 8 is missing.

This is a well-known problem with placing resets in the PHY node. In
this case, you must add a compatible property as well that matches
"ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}" so that phylib knows the
contents of the ID registers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
