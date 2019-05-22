Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3D27140
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbfEVU7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:59:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbfEVU7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 16:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RK7BKuNuoUu12dYwR+LCR1MVVz/2S9o4Rt7rUWybqf8=; b=yx5WWbMsXgABiQ93gNWHSUnLT7
        DyKeIngnIYN1A1UQCQRvV99PIAYpsQjpYvdyC3/6sWA3gOZ/XkdomnvRqplictFyt3AZor1bsYhoc
        Andgst9OS8008DdYaQwb30b/5CmsatFz4IjJfXVWUaeEBmWKrquP645Z+LfdEy7Y2kUY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTYK3-0004ZD-5G; Wed, 22 May 2019 22:58:51 +0200
Date:   Wed, 22 May 2019 22:58:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: phy: aquantia: add USXGMII support
Message-ID: <20190522205851.GA15257@lunn.ch>
References: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
 <2c68bdb1-9b53-ce0b-74d3-c7ea2d9e7ac0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c68bdb1-9b53-ce0b-74d3-c7ea2d9e7ac0@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 09:58:32PM +0200, Heiner Kallweit wrote:
> So far we didn't support mode USXGMII, and in order to not break the
> two Freescale boards mode XGMII was accepted for the AQR107 family
> even though it doesn't support XGMII. Add USXGMII support to the
> Aquantia PHY driver and change the phy connection type for the two
> boards.
> 
> As an additional note: Even though the handle is named aqr106
> there seem to be LS1046A boards with an AQR107.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts | 2 +-
>  arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 2 +-
>  drivers/net/phy/aquantia_main.c                   | 6 +++++-
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
> index 4223a2352..c2ce1a611 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
> @@ -139,7 +139,7 @@
>  
>  	ethernet@f0000 { /* 10GEC1 */
>  		phy-handle = <&aqr105_phy>;
> -		phy-connection-type = "xgmii";
> +		phy-connection-type = "usxgmii";
>  	};
>  
>  	mdio@fc000 {
> diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> index 6a6514d0e..f927a8a25 100644
> --- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> +++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
> @@ -147,7 +147,7 @@
>  
>  	ethernet@f0000 { /* 10GEC1 */
>  		phy-handle = <&aqr106_phy>;
> -		phy-connection-type = "xgmii";
> +		phy-connection-type = "usxgmii";
>  	};
>  
>  	ethernet@f2000 { /* 10GEC2 */
> diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_main.c
> index 0fedd28fd..3f24c42a8 100644
> @@ -487,7 +491,7 @@ static int aqr107_config_init(struct phy_device *phydev)
>  	/* Check that the PHY interface type is compatible */
>  	if (phydev->interface != PHY_INTERFACE_MODE_SGMII &&
>  	    phydev->interface != PHY_INTERFACE_MODE_2500BASEX &&
> -	    phydev->interface != PHY_INTERFACE_MODE_XGMII &&
> +	    phydev->interface != PHY_INTERFACE_MODE_USXGMII &&
>  	    phydev->interface != PHY_INTERFACE_MODE_10GKR)
>  		return -ENODEV;

Hi Heiner

Just to reiterate Florian's point. We need to be careful with device
tree blobs. We should try not to break them, at least not for a few
cycles.

I would much prefer to see a

WARN_ON(phydev->interface == PHY_INTERFACE_MODE_XGMII,
        "Your devicetree is out of date, please update it");

and accept XGMII for this cycle. These are development boards, so in
theory users are developers, so should know how to update the DT.

    Andrew
