Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2293D52D5FA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbiESO0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbiESO0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:26:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1752737002;
        Thu, 19 May 2022 07:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7GgMfKIL4eOaBr7+tGiHzVQvi5p6f4TXu98a+NEhGJg=; b=igfou1cBpIpplBzY2402a/7/Xt
        NBVixRZoc1H2RE5pJVf4KzDFqCZmF6r1nSopIp4EhEkGv6COSrRcw6V7wKGLxpjFYBpNQK6p4jkbg
        EvueVA4ktbf5M2JjD4RYfv9LQlrnNmml+tReRL7DRy2rP8JTyFTEu3Nx5r3kMKVZ8hsitK/Ch2nnt
        TTnW9HKKFlM6Zz3h2k5eDsu1usfTZfdc8EJUVWk8zWNNC1+dcFu5EA6+7DjcZzadioCmwfUtQ2rcj
        mp3y8yHS1gG2Y2hGVP9r1HdwvletPAdJ+xxya+OgZZYWBxN3E0C3++rLDR3UEyjLzNs1F5Zf4I8j1
        aJYAz0ew==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60774)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nrh6e-0003yl-Um; Thu, 19 May 2022 15:26:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nrh6d-0006dU-DN; Thu, 19 May 2022 15:26:23 +0100
Date:   Thu, 19 May 2022 15:26:23 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 3/6] net: lan966x: Add QUSGMII support for
 lan966x
Message-ID: <YoZTj69Une9aKd2C@shell.armlinux.org.uk>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
 <20220519135647.465653-4-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519135647.465653-4-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 19, 2022 at 03:56:44PM +0200, Maxime Chevallier wrote:
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> index e6642083ab9e..304c784f48f6 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> @@ -452,4 +452,10 @@ static inline void lan_rmw(u32 val, u32 mask, struct lan966x *lan966x,
>  			      gcnt, gwidth, raddr, rinst, rcnt, rwidth));
>  }
>  
> +static inline bool lan966x_is_qsgmii(phy_interface_t mode)
> +{
> +	return (mode == PHY_INTERFACE_MODE_QSGMII) ||
> +	       (mode == PHY_INTERFACE_MODE_QUSGMII);
> +}

Maybe linux/phy.h should provide a helper, something like:

	phy_interface_serdes_lanes()

that returns how many serdes lanes the interface mode uses?

> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
> index 38a7e95d69b4..96708352f53e 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
> @@ -28,11 +28,18 @@ static int lan966x_phylink_mac_prepare(struct phylink_config *config,
>  				       phy_interface_t iface)
>  {
>  	struct lan966x_port *port = netdev_priv(to_net_dev(config->dev));
> +	phy_interface_t serdes_mode = iface;
>  	int err;
>  
>  	if (port->serdes) {
> +		/* As far as the SerDes is concerned, QUSGMII is the same as
> +		 * QSGMII.
> +		 */
> +		if (lan966x_is_qsgmii(iface))
> +			serdes_mode = PHY_INTERFACE_MODE_QSGMII;
> +
>  		err = phy_set_mode_ext(port->serdes, PHY_MODE_ETHERNET,
> -				       iface);
> +				       serdes_mode);

I don't think that the ethernet MAC driver should be changing the
interface mode before passing it down to the generic PHY layer -
phy_set_mode_ext() is defined to take the phy interface mode, and any
aliasing of modes should really be up to the generic PHY driver not
the ethernet MAC driver.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
