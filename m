Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F2556BD61
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238095AbiGHPZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 11:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238669AbiGHPZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 11:25:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205EC606AB
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 08:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wq0NAkd8wYLgPrcVZQ4B+mA85a1Aciftk8zEWMpxvIE=; b=vYp6Wr/FBQNvkWpnTWSQrm0eHm
        sh4C9d29OdqU9b2cirBGMMLlGotcNgn8Y1uuNmgXu8UnQmyQmuZUfHd0NtnTbXDuASj/gm8V7O8QJ
        ONtUz0DdApvahtQsDg5XcIJYpxTNN/wopAJ7FI/Nwn0KAig+R6WrNRQ3+ddh43sGlL70U/sVT//fA
        RfB9vmvnh+kPRHMLMolb79ANjUKaASuIGM2qBGBChbx4fK+ZOWBXIMz20KE5zSU1X2zs0Jbn2g2Xb
        XbZEjB+sZMBzh2cJcrd7ckXQYc29HnxXdhFqVk6mTOThqvbuBbdtltmVg3blxFKvUCgHlMaF+lAZC
        kHiLBy1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33254)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o9pqu-0005D7-O1; Fri, 08 Jul 2022 16:25:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o9pqp-0006JM-29; Fri, 08 Jul 2022 16:25:03 +0100
Date:   Fri, 8 Jul 2022 16:25:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <YshMT3KP/B6BiEIg@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <YsW3KSeeQBiWQOz/@shell.armlinux.org.uk>
 <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
 <20220707152727.foxrd4gvqg3zb6il@skbuf>
 <YscAPP7mF3KEE1/p@shell.armlinux.org.uk>
 <20220707163831.cjj54a6ys5bceb22@skbuf>
 <YscUwrPnBZ3dzpQ/@shell.armlinux.org.uk>
 <20220707193753.2j67ni3or3bfkt6k@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707193753.2j67ni3or3bfkt6k@skbuf>
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

On Thu, Jul 07, 2022 at 10:37:53PM +0300, Vladimir Oltean wrote:
> +static int dsa_port_fixup_broken_dt(struct dsa_port *dp)

As I mentioned, I doubt that Andrew considers this "broken DT" as he's
been promoting this as a standard DSA feature.

> +{
> +	struct property_entry fixed_link_props[] = {
> +		PROPERTY_ENTRY_BOOL("full-duplex"),
> +		PROPERTY_ENTRY_U32("speed", 1000), /* TODO determine actual speed */
> +		{},
> +	};
> +	struct property_entry port_props[3] = {};
> +	struct fwnode_handle *fixed_link_fwnode;
> +	struct fwnode_handle *new_port_fwnode;
> +	struct device_node *dn = dp->dn;
> +	phy_interface_t mode;
> +	int err;
> +
> +	if (of_parse_phandle(dn, "phy-handle", 0) ||
> +	    of_phy_is_fixed_link(dn))
> +		/* Nothing broken, nothing to fix.
> +		 * TODO: As discussed with Russell, maybe phylink could provide
> +		 * a more comprehensive helper to determine what constitutes a
> +		 * valid fwnode binding than this guerilla kludge.
> +		 */
> +		return 0;

I think this is sufficient. Yes, phylink accepts "phy" and "phy-device"
because it has to for compatibility with other drivers, but the binding
document for DSA quite clearly states that "phy-handle" is what DSA
accepts, so DT in the kernel will be validated against the yaml file
and enforce correctness here.

We do need to check for "sfp" being present as well.

> +
> +	err = of_get_phy_mode(dn, &mode);
> +	if (err)
> +		/* TODO this may be missing too, ask the driver for the
> +		 * max-speed interface mode for this port
> +		 */
> +		mode = PHY_INTERFACE_MODE_NA;

I think it would be easier to omit the phy-mode property in the swnode
if it isn't present in DT, because then we can handle that in
dsa_port_phylink_create() as I've done in my patch series via the
ds->ops->phylink_get_caps() method.

> +
> +	port_props[0] = PROPERTY_ENTRY_U32("reg", dp->index);

You said in one of your other replies that this node we're constructing
is only for phylink, do we need the "reg" property? phylink doesn't care
about it.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
