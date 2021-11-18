Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB73455DF3
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhKRO2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233068AbhKRO2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 09:28:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F96C061574;
        Thu, 18 Nov 2021 06:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o18aeLHgEUqFCTxBTaej/2pDfYAv1egYjFj9ksLCZ/o=; b=jXmDZ/v/T3qzA7Uj4ysGz870a2
        2yr/MyL86QqqLUznBXDVMHMARF/2OD4/XDZ2VuubW6/MTELkmDzzBspEPzZocWZ+GoldP3jVGflng
        sCdmkdYjziCf83AjK67lsrJhg9t3eL812bz52yqXk/h8DCJn8lbiwPpqpjNMpsbOEy/fj7OZh8m33
        nYYIS7O+JF8ZMvFrksiO0HH7MmLHjmGStbSKFdYPxtosKJ7mBU5P2GhSuW/haUUpBLss/emHj24je
        UK6X/SSSx4AcrriOqCu1hLkM8Ag71AcbvZcuKBKOniv90Fcjj5rhq7vqw+Mw5AAp/amxeyzB9TRNc
        hZHCdfdA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55720)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mniMC-00031s-Ar; Thu, 18 Nov 2021 14:25:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mniMB-0003zX-3B; Thu, 18 Nov 2021 14:25:43 +0000
Date:   Thu, 18 Nov 2021 14:25:43 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <YZZiZ1urmmvp3MRi@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
 <YZYfxyGbWTiXuHwP@shell.armlinux.org.uk>
 <20211118144628.1925ae03@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118144628.1925ae03@thinkpad>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 02:46:28PM +0100, Marek Behún wrote:
> On Thu, 18 Nov 2021 09:41:27 +0000
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> 
> > On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Behún wrote:
> > > +static int mv3310_select_mactype(unsigned long *interfaces)
> > > +{
> > > +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > > +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> > > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> > > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;  
> > 
> > Hi,
> > 
> > There are differences in the MACTYPE register between the 88X3310
> > and 88X3340. For example, the 88X3340 has no support for XAUI.
> > This is documented in the data sheet, and in the definitions of
> > these values - note that MV_V2_3310_PORT_CTRL_MACTYPE_XAUI and
> > MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH are only applicable
> > to the 88X3310 (they don't use MV_V2_33X0_*).
> 
> Yes, but 88X3340 does not support XAUI, only RXAUI, it is defined in
> supported_interfaces. So PHY_INTERFACE_MODE_XAUI will never be set in
> interfaces, and thus this function can be used for both 88X3310 and
> 88X3340.

Okay, that's fine then. The only setting we will omit from this for
the 88X3340 then is MV_V2_3340_PORT_CTRL_MACTYPE_RXAUI_NO_SGMII_AN.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
