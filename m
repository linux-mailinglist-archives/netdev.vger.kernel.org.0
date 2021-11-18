Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB5B455C99
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhKRNZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbhKRNZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 08:25:23 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651B1C061570;
        Thu, 18 Nov 2021 05:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P6fgBQxcPE/vbwzAayGW8ixGK4Inob6EQIzVZCrQsJQ=; b=fEM5f5Ha4WFP2EEwSLweJcGLGI
        ddS4rk5cB9+QGDj3qoHLk/mByzIgCmJR7wymOzNyY5d8lB+Vw4jgXDtXpAiB3JZN4vk8oG6IctW+1
        LqCB0rWArpzNBPR/BRokpeXkPHSBtix+OlcOD/gP0haG1ahGC9m9MYmpe0LxN86m98fJGeSVnTt/d
        rSn3dEofdq7LMqN2FKNGmFgjxE+6p/MJwjWyqJBgomm/JMb1SZzL3AUaQOyJCG5VE+QrkblEThYHa
        V0nt/n1mKVMHU3EM6x5iI2Zodvd9ACA/+I2xFL0lEQrcz9AEWP/5sq0HZEAjWURO480kjn5jPuUA7
        iOxhs7qw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55716)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnhMp-0002xN-JW; Thu, 18 Nov 2021 13:22:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnhMo-0003xE-2v; Thu, 18 Nov 2021 13:22:18 +0000
Date:   Thu, 18 Nov 2021 13:22:18 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <YZZTinTgX3SPWIZM@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
 <20211118120334.jjujutp5cnjgwjq2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211118120334.jjujutp5cnjgwjq2@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 02:03:34PM +0200, Vladimir Oltean wrote:
> On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Behún wrote:
> > +static int mv3310_select_mactype(unsigned long *interfaces)
> > +{
> > +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> > +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> > +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> > +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> > +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> > +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> > +	else
> > +		return -1;
> > +}
> > +
> 
> I would like to understand this heuristic better. Both its purpose and
> its implementation.
> 
> It says:
> (a) If the intersection between interface modes supported by the MAC and
>     the PHY contains USXGMII, then use USXGMII as a MACTYPE
> (b) Otherwise, if the intersection contains both 10GBaseR and SGMII, then
>     use 10GBaseR as MACTYPE
> (...)
> (c) Otherwise, if the intersection contains just 10GBaseR (no SGMII), then
>     use 10GBaseR with rate matching as MACTYPE
> (...)
> (d) Otherwise, if the intersection contains just SGMII (no 10GBaseR), then
>     use 10GBaseR as MACTYPE (no rate matching).

What is likely confusing you is a misinterpretation of the constant.
MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER actually means the PHY will
choose between 10GBASE-R, 5GBASE-R, 2500BASE-X, and SGMII depending
on the speed negotiated by the media. In this setting, the PHY
dictates which interface mode will be used.

I could have named "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER" as
"MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_ON".
Similar with "MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_NO_SGMII_AN", which
would be
"MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_5GBASER_2500BASEX_SGMII_AUTONEG_OFF".
And "MV_V2_3310_PORT_CTRL_MACTYPE_XAUI" would be
"MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_5GBASER_2500BASEX_SGMII_AUTONEG_ON".

Clearly using such long identifiers would have been rediculous,
especially the second one at 74 characters.

> First of all, what is MACTYPE exactly? And what is the purpose of
> changing it? What would happen if this configuration remained fixed, as
> it were?

The PHY defines the MAC interface mode depending on the MACTYPE
setting selected and the results of the media side negotiation.

I think the above answers your remaining questions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
