Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B9A183341
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgCLOge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727450AbgCLOge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 10:36:34 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CBBD20663;
        Thu, 12 Mar 2020 14:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584023793;
        bh=tA9u82x+mBuMvX0imflvPkNR7cfJJBjdnn1jG5Npcug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUGEe582YRpKTnG8i9OWpZeKCS0w2sKbrZrH+wNKDMwTbcv40YsTGVN7EDD9WAB+c
         WcnXpZKVBz1VdLv8TKiuRGPLpXFSTRSI8dDGMW/rOgcvdbghZ9dS1s5snK+RHSSuGV
         KW1ASOZmiwp/vVcu4bnb5sE34/Uflsq6JaJ9APSQ=
Date:   Thu, 12 Mar 2020 22:36:22 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1] ARM: dts: imx6q-marsboard: properly define rgmii PHY
Message-ID: <20200312143621.GD1249@dragon>
References: <20200306080353.9284-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306080353.9284-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 06, 2020 at 09:03:53AM +0100, Oleksij Rempel wrote:
> The Atheros AR8035 PHY can be autodetected but can't use interrupt
> support provided on this board. Define MDIO bus and the PHY node to make
> it work properly.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  arch/arm/boot/dts/imx6q-marsboard.dts | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/imx6q-marsboard.dts b/arch/arm/boot/dts/imx6q-marsboard.dts
> index 84b30bd6908f..019488aaa30b 100644
> --- a/arch/arm/boot/dts/imx6q-marsboard.dts
> +++ b/arch/arm/boot/dts/imx6q-marsboard.dts
> @@ -111,8 +111,23 @@ &fec {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&pinctrl_enet>;
>  	phy-mode = "rgmii-id";
> -	phy-reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
>  	status = "okay";
> +
> +	mdio {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		/* Atheros AR8035 PHY */
> +		rgmii_phy: ethernet-phy@4 {
> +			reg = <4>;
> +
> +			interrupts-extended = <&gpio1 28 IRQ_TYPE_LEVEL_LOW>;
> +

Drop these newlines.

Shawn

> +			reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <1000>;
> +		};
> +	};
>  };
>  
>  &hdmi {
> -- 
> 2.25.1
> 
