Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04150455835
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245238AbhKRJof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243559AbhKRJo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:44:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDC8C061570;
        Thu, 18 Nov 2021 01:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vx1tmOBpNGxyiQOG/gu+V42HKo/aIEIIPzPSqS9KgVQ=; b=DUF+oIcHrMvcbZIBqexuI7T5GB
        qtiFwG0pu5YFkpI5/Wq6CYCwIr+MKQn+fNsg6Ez3cfVGUQsygVWBFjFjKKPoiruVqAaYBJK6jt8f6
        bFVuiBVunLaxeO4+Ym35DJYj9+R06Mk/5H2WeJPrOmRI0zjs8l67nadBkZvyvH9XXGV4Go95e3ahB
        733idm6SsyzA4iL5n0b6oMMmshnMKthILCHHLy1am4VdlEZLclhSDRBiOVRzckKmKvQKz4GhohbHU
        v3Hp0wuOxDNi/SqUwkSO3ZEC8+FhFrtD0KOwRtNBPsJjvLVsHLruqylmi7cwLpuNIEYTrp4D73x+D
        fqAC3G8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55706)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mndv5-0002lg-Ia; Thu, 18 Nov 2021 09:41:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mndv5-0003pO-4i; Thu, 18 Nov 2021 09:41:27 +0000
Date:   Thu, 18 Nov 2021 09:41:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <YZYfxyGbWTiXuHwP@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-9-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Behún wrote:
> +static int mv3310_select_mactype(unsigned long *interfaces)
> +{
> +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;

Hi,

There are differences in the MACTYPE register between the 88X3310
and 88X3340. For example, the 88X3340 has no support for XAUI.
This is documented in the data sheet, and in the definitions of
these values - note that MV_V2_3310_PORT_CTRL_MACTYPE_XAUI and
MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH are only applicable
to the 88X3310 (they don't use MV_V2_33X0_*).

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
