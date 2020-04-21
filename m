Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DF71B227F
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 11:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgDUJR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 05:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726052AbgDUJR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 05:17:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7992EC061A0F
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 02:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0QSXCYaBSPvWwC6qSZ4b9BllMlsQ9PTrh4879WBGzN0=; b=GzcvAZ+yRAIGcJYBdDcP3sTyw
        QSeQxD58KKp0Rv96Ho43jA2t2IH0VNxSLXMRljM58m2SwLkpHY1funsT+cHIMh+loX6FfKdH8ozHK
        Iz+JG3llLFcRQforGzjCHkNKhpu4yMZL7wPcVmZEbZfliGTYC6pJ/Dx9Pvx2pI7VeDtNxvH2ahL0Q
        O7UVV4Q6fngYvW9ZLma3orbBESDKN8QjT+r7vHKxVFepQQPjTn0VY9f7qpXijE5GOV4noljjYYl8+
        sKL8KknhdHzAUK9eOmqultEA93BL4RKbSzzytCto71gUJiqrdZbUKxBJQXhFvFnTLrSn0Ep3/Mw4V
        EHdvs8yLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53182)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jQp1t-0000Wp-Vn; Tue, 21 Apr 2020 10:17:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jQp1s-0006uk-Uo; Tue, 21 Apr 2020 10:17:20 +0100
Date:   Tue, 21 Apr 2020 10:17:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: marvell10g: limit soft reset to 88x3310
Message-ID: <20200421091720.GB25745@shell.armlinux.org.uk>
References: <616c799433477943d782bda9d8a825d56fc70c9d.1587459886.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <616c799433477943d782bda9d8a825d56fc70c9d.1587459886.git.baruch@tkos.co.il>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 12:04:46PM +0300, Baruch Siach wrote:
> The MV_V2_PORT_CTRL_SWRST bit in MV_V2_PORT_CTRL is reserved on 88E2110.
> Setting SWRST on 88E2110 breaks packets transfer after interface down/up
> cycle.
> 
> Fixes: 8f48c2ac85ed ("net: marvell10g: soft-reset the PHY when coming out of low power")
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Okay, the presence of 88E2110 combined with 88X3310 support is going to
be a constant source of pain in terms of maintanence, since I know
nothing about this PHY, nor do I have any way to test my changes there.

I think we need to think about how to deal with that - do we split the
code, so that 88X3310 can be maintained separately from 88E2110 (even
though most of the code may be the same), or can someone send me a board
that has the 88E2110 on (I can't purchase as I have no funds to do so.)

So, I guess splitting the code is likely to be the only solution.

> ---
>  drivers/net/phy/marvell10g.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index d3cb88651ad2..601686f64341 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -263,7 +263,8 @@ static int mv3310_power_up(struct phy_device *phydev)
>  	ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
>  				 MV_V2_PORT_CTRL_PWRDOWN);
>  
> -	if (priv->firmware_ver < 0x00030000)
> +	if (phydev->drv->phy_id != MARVELL_PHY_ID_88X3310 ||
> +	    priv->firmware_ver < 0x00030000)
>  		return ret;
>  
>  	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
> -- 
> 2.26.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
