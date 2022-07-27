Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3145827F9
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbiG0Nsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiG0Nsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:48:51 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95F91FCF4;
        Wed, 27 Jul 2022 06:48:48 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B95BBC0013;
        Wed, 27 Jul 2022 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1658929727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hVTCF8pQk67tXawi7VWdLqy2Z4rkLKGc7Ao9b+EOr0=;
        b=d8plXn8Ftzl5po6NJ3IGIJUV7xErvumcSjVeOS3Zu0NgUS/wjL8mQ+fM0X2DGY+QzoJOEN
        lv9pANU3CvU1GI5dXfrzjrEtL7GpnmszrbB5fGyoSDkhPCsJdRmnYintMHB6nCG3iU2HQ9
        O4EkMCzTmtd4iRvkR4gM7Uu5PXXE/SgH0ve2+2gC27N09wC+eKrjRQmE1sKqRREflLDSRJ
        WXvGUCERW1007plKridZaigY8Qlst9WHcOPvQXylNA515DJOlOsqDMt3lq7HrvKt2EY3oj
        55fw4GW0syiPsW9DRSreAvuWJSIMVbWgTmiRXrpQ0/EASkWIaAZVq5sM2GqZyw==
Date:   Wed, 27 Jul 2022 15:48:44 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <20220727154844.3eb3c3d6@pc-10.home>
In-Reply-To: <YoZTj69Une9aKd2C@shell.armlinux.org.uk>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
        <20220519135647.465653-4-maxime.chevallier@bootlin.com>
        <YoZTj69Une9aKd2C@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Thu, 19 May 2022 15:26:23 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> Hi,
> 
> On Thu, May 19, 2022 at 03:56:44PM +0200, Maxime Chevallier wrote:
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h index
> > e6642083ab9e..304c784f48f6 100644 ---
> > a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h +++
> > b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h @@ -452,4
> > +452,10 @@ static inline void lan_rmw(u32 val, u32 mask, struct
> > lan966x *lan966x, gcnt, gwidth, raddr, rinst, rcnt, rwidth)); }
> >  
> > +static inline bool lan966x_is_qsgmii(phy_interface_t mode)
> > +{
> > +	return (mode == PHY_INTERFACE_MODE_QSGMII) ||
> > +	       (mode == PHY_INTERFACE_MODE_QUSGMII);
> > +}  
>
> Maybe linux/phy.h should provide a helper, something like:
> 
> 	phy_interface_serdes_lanes()
> 
> that returns how many serdes lanes the interface mode uses?

Sorry about the delayed answer, I was resuming the work on this, and
realised that although a helper would be indeed great, especially for
generic PHY drivers, it won't help much in this case since
QSGMII/QUSGMII both use 1 serdes lane, as SGMII and such. If I'm not
mistaken, QSGMII is SGMII clocked at 5Gbps with a specific preamble
allowing to identify the src/dst port.

We could however imagine a helper identifying the number of links, or
lanes (or another terminology) that is carried by a given mode. I know
that besides QSGMII for 4 ports, there exists PSGMII for 5 ports, and
OSGMII for 8 ports, so this would definitely prove useful in the
future.

Sorry if this ends-up being a misunderstanding on the terminology,
we're probably already talking about the same thing, but I think that
"serdes lane" would better describe the number of physical differential
pairs that creates the link (like, 1 for SGMII, 2 for RXAUI, 4 for XAUI
and so on).

maybe something like

	phy_interface_lines() or
	phy_interface_num_ports() or simply
	phy_interface_lanes()

> > diff --git
> > a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
> > b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c index
> > 38a7e95d69b4..96708352f53e 100644 ---
> > a/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c +++
> > b/drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c @@
> > -28,11 +28,18 @@ static int lan966x_phylink_mac_prepare(struct
> > phylink_config *config, phy_interface_t iface) { struct
> > lan966x_port *port = netdev_priv(to_net_dev(config->dev));
> > +	phy_interface_t serdes_mode = iface;
> >  	int err;
> >  
> >  	if (port->serdes) {
> > +		/* As far as the SerDes is concerned, QUSGMII is
> > the same as
> > +		 * QSGMII.
> > +		 */
> > +		if (lan966x_is_qsgmii(iface))
> > +			serdes_mode = PHY_INTERFACE_MODE_QSGMII;
> > +
> >  		err = phy_set_mode_ext(port->serdes,
> > PHY_MODE_ETHERNET,
> > -				       iface);
> > +				       serdes_mode);  
> 
> I don't think that the ethernet MAC driver should be changing the
> interface mode before passing it down to the generic PHY layer -
> phy_set_mode_ext() is defined to take the phy interface mode, and any
> aliasing of modes should really be up to the generic PHY driver not
> the ethernet MAC driver.

Indeed, I'll split the series so that we first add support for the new
mode, and then send separate series for the generic PHY driver on one
side, and inband extensions on the other one.

Thanks,

Maxime

> Thanks.
> 

