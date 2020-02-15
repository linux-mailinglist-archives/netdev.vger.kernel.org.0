Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CF715FF21
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgBOQIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:08:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbgBOQIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Feb 2020 11:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/MAL/dS9+xaImPqMBu7AglUJ2inc+yODBpvhLTi/OhU=; b=m2YCxJblWgvBUHgjEiI109YDcF
        dhnr9hZ2ojkZyF0wmbpsAD3oW1RP2dSDKreR5bioSR+sDiWn/zoQ52SclqLQE07hx6MX/jyRm46b4
        AbVTeiCNcjC7LxUcU7btf4A9e2RbC8BxfGJcOOFEpEjzE77YAq3ieKd+yUmvvj0+5BAo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j2zzE-0004ju-B4; Sat, 15 Feb 2020 17:08:08 +0100
Date:   Sat, 15 Feb 2020 17:08:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Have
 bcm54xx_adjust_rxrefclk() check for flags
Message-ID: <20200215160808.GA8924@lunn.ch>
References: <20200214233853.27217-1-f.fainelli@gmail.com>
 <20200214233853.27217-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214233853.27217-3-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 03:38:52PM -0800, Florian Fainelli wrote:
> bcm54xx_adjust_rxrefclk() already checks for the flags and will
> correctly reacting to the 3 different flags it check, allow it to be
> unconditionally called.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/phy/broadcom.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index 4ad2128cc454..b4eae84a9195 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -273,10 +273,7 @@ static int bcm54xx_config_init(struct phy_device *phydev)
>  	    (phydev->dev_flags & PHY_BRCM_CLEAR_RGMII_MODE))
>  		bcm_phy_write_shadow(phydev, BCM54XX_SHD_RGMII_MODE, 0);
>  
> -	if ((phydev->dev_flags & PHY_BRCM_RX_REFCLK_UNUSED) ||
> -	    (phydev->dev_flags & PHY_BRCM_DIS_TXCRXC_NOENRGY) ||
> -	    (phydev->dev_flags & PHY_BRCM_AUTO_PWRDWN_ENABLE))
> -		bcm54xx_adjust_rxrefclk(phydev);
> +	bcm54xx_adjust_rxrefclk(phydev);

Hi Florian

PHY_BRCM_RX_REFCLK_UNUSED is not unconditionally checked in
bcm54xx_adjust_rxrefclk(), where as here it is. I assume this is O.K?
The same is tree for PHY_BRCM_AUTO_PWRDWN_ENABLE.  Maybe worth a
comment in the commit message if you need to respin.

      Andrew
