Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202734C47C7
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 15:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbiBYOic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 09:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239747AbiBYOib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 09:38:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A26186472
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 06:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+10PHnZwlMCuEjX0z4v6J0Xiy1/D1rYx69ZfCW/9l8s=; b=csDFu7dppUPi6U/PhtQ6ky6rnv
        73c2SYesp0KRiVOQsCRlRd8zsELXTgB+M/K62KsIhJwcp7vUcbD0z5N/FRixinrMgA/mxA75n0KIP
        9uO9JXhj5Ocq6hFuC5z+m39UXfnqm9rNnT+wSfIznAuvI7QFU/PPrfDbh4/0MjK3BCuRC++KxW5zu
        UCRFW0eprMZyY2JNN9tb7AM6Riuk/MxbSVyu/B6FnxwXei+/7/gmXpmGap69fwCApfOwaE+TuRFiP
        idpF6AkX9FGsj98tddPl9H/uezJwjTi6idAsUvFHPv8+yn/tB/QmTGv6k/g/Y6LcJumyO+sqRoOCo
        7h0sSHug==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57494)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNbjE-0005Xh-E6; Fri, 25 Feb 2022 14:37:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNbjC-00038x-Bk; Fri, 25 Feb 2022 14:37:50 +0000
Date:   Fri, 25 Feb 2022 14:37:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/4] net: dsa: ocelot: remove interface
 checks
Message-ID: <Yhjpvn1BIdtLOsMH@shell.armlinux.org.uk>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
 <E1nNbgn-00Akik-MJ@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNbgn-00Akik-MJ@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 02:35:21PM +0000, Russell King (Oracle) wrote:
> When the supported interfaces bitmap is populated, phylink will itself
> check that the interface mode is present in this bitmap. Drivers no
> longer need to perform this check themselves. Remove these checks.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Sorry, just realised I should've deleted "ocelot_port" here as well, for
some reason my build testing didn't find that. Please assume that I've
deleted it (I've updated the patch locally.) Thanks.

> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 6 ------
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 6 ------
>  2 files changed, 12 deletions(-)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index a1be0e91dde6..4c635c46705e 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -956,12 +956,6 @@ static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>  
> -	if (state->interface != PHY_INTERFACE_MODE_NA &&
> -	    state->interface != ocelot_port->phy_mode) {
> -		linkmode_zero(supported);
> -		return;
> -	}
> -
>  	phylink_set_port_modes(mask);
>  	phylink_set(mask, Autoneg);
>  	phylink_set(mask, Pause);
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
> index 2db51494b1a9..0ae8424c47e2 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -929,12 +929,6 @@ static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
>  	struct ocelot_port *ocelot_port = ocelot->ports[port];
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>  
> -	if (state->interface != PHY_INTERFACE_MODE_NA &&
> -	    state->interface != ocelot_port->phy_mode) {
> -		linkmode_zero(supported);
> -		return;
> -	}
> -
>  	phylink_set_port_modes(mask);
>  	phylink_set(mask, Autoneg);
>  	phylink_set(mask, Pause);
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
