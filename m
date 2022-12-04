Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE3641E0A
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 17:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiLDQwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 11:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiLDQwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 11:52:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8604115712;
        Sun,  4 Dec 2022 08:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U6kiK3mUEewO2S+im7KGqzgwTAFOC0oFJgWDX4UeRwk=; b=1gxdgAsmdBUsfNhKxkqlRkRnhz
        qQwcneJvmY+unjIuaoaTpgg2hVUyclhwK4x/C97+O0VY/rKpG9JJgD8evM0NFKbcJyIsHjFF7HHwH
        2PQnV8Jpaw/8CEFORPcJ1/8el0WgIvE3q2MW4xPR2jDMERg3gY4gWFrZmaz8/RMgRXIzX7g5BbJM4
        q3h6TjvG85vz7ruyIpIS8HXgyQoY6La1skDK0F4vunSK2b+ACub+eAEOVvgGLT16SqafM6dpbWhwz
        VacMe+S/tDm7KsE5lD3K+rkuYf2Donln0MDMIjo6cQbZfoIUMvLFL222F3FUGOl9XLM65GsrVyHHq
        RaZE/89Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35562)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p1sDl-0005vN-Eo; Sun, 04 Dec 2022 16:52:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p1sDk-0006Qc-Bc; Sun, 04 Dec 2022 16:52:04 +0000
Date:   Sun, 4 Dec 2022 16:52:04 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Dec 04, 2022 at 03:31:33AM +0100, Piergiorgio Beruto wrote:
> diff --git a/drivers/net/phy/ncn26000.c b/drivers/net/phy/ncn26000.c
> new file mode 100644
> index 000000000000..65a34edc5b20
> --- /dev/null
> +++ b/drivers/net/phy/ncn26000.c
> @@ -0,0 +1,193 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/*
> + *  Driver for Analog Devices Industrial Ethernet T1L PHYs
> + *
> + * Copyright 2020 Analog Devices Inc.
> + */
> +#include <linux/kernel.h>
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/mii.h>
> +#include <linux/phy.h>
> +#include <linux/property.h>
> +
> +#define PHY_ID_NCN26000				0x180FF5A1
> +
> +#define NCN26000_REG_IRQ_CTL                    ((u16)16)
> +#define NCN26000_REG_IRQ_STATUS                 ((u16)17)
> +
> +#define NCN26000_IRQ_LINKST_BIT                 ((u16)1)
> +#define NCN26000_IRQ_PLCAST_BIT                 ((u16)(1 << 1))
> +#define NCN26000_IRQ_LJABBER_BIT                ((u16)(1 << 2))
> +#define NCN26000_IRQ_RJABBER_BIT                ((u16)(1 << 3))
> +#define NCN26000_IRQ_RJABBER_BIT                ((u16)(1 << 3))
> +#define NCN26000_IRQ_PLCAREC_BIT                ((u16)(1 << 4))
> +#define NCN26000_IRQ_PHYSCOL_BIT                ((u16)(1 << 5))

There isn't much point in having the casts to u16 here. Also,
BIT() is useful for identifying single bits.

> +static int ncn26000_enable(struct phy_device *phydev)
> +{

This is actually the config_aneg() implementation, it should be named
as such.

> +	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> +	phydev->mdix = ETH_TP_MDI;
> +	phydev->pause = 0;
> +	phydev->asym_pause = 0;
> +	phydev->speed = SPEED_10;
> +	phydev->duplex = DUPLEX_HALF;

Is this initialisation actually necessary?

> +
> +	// bring up the link (link_ctrl is mapped to BMCR_ANENABLE)
> +	// clear also ISOLATE mode and Collision Test
> +	return phy_write(phydev, MII_BMCR, BMCR_ANENABLE);

You always use AN even when ethtool turns off AN? If AN is mandatory,
it seems there should be some way that phylib can force that to be
the case.

> +}
> +
> +static int ncn26000_soft_reset(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
> +
> +	if (ret != 0)
> +		return ret;
> +
> +	return phy_read_poll_timeout(phydev,
> +				     MII_BMCR,
> +				     ret,
> +				     !(ret & BMCR_RESET),
> +				     500,
> +				     20000,
> +				     true);

Isn't this just genphy_reset() ?

> +}
> +
> +static int ncn26000_get_features(struct phy_device *phydev)
> +{
> +	linkmode_zero(phydev->supported);
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, phydev->supported);
> +
> +	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> +			 phydev->supported);
> +
> +	linkmode_copy(phydev->advertising, phydev->supported);
> +	return 0;
> +}
> +
> +static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
> +{
> +	const struct ncn26000_priv *const priv = phydev->priv;
> +	u16 events;
> +	int ret;
> +
> +	// read and aknowledge the IRQ status register
> +	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> +
> +	if (unlikely(ret < 0))
> +		return IRQ_NONE;
> +
> +	events = (u16)ret & priv->enabled_irqs;
> +	if (events == 0)
> +		return IRQ_NONE;
> +
> +	if (events & NCN26000_IRQ_LINKST_BIT) {
> +		ret = phy_read(phydev, MII_BMSR);
> +
> +		if (unlikely(ret < 0)) {
> +			phydev_err(phydev,
> +				   "error reading the status register (%d)\n",
> +				   ret);
> +
> +			return IRQ_NONE;
> +		}
> +
> +		phydev->link = ((u16)ret & BMSR_ANEGCOMPLETE) ? 1 : 0;

1. aneg_complete shouldn't be used to set phydev->link.
2. phydev->link should be updated in the read_status() function, which
the state machine will call. Setting it here without taking the lock
introduces races.

> +	}
> +
> +	// handle more IRQs here
> +
> +	phy_trigger_machine(phydev);
> +	return IRQ_HANDLED;
> +}
> +
> +static int ncn26000_config_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +	struct ncn26000_priv *priv = phydev->priv;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		// acknowledge IRQs
> +		ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> +		if (ret < 0)
> +			return ret;
> +
> +		// get link status notifications
> +		priv->enabled_irqs = NCN26000_IRQ_LINKST_BIT;
> +	} else {
> +		// disable all IRQs
> +		priv->enabled_irqs = 0;
> +	}
> +
> +	ret = phy_write(phydev, NCN26000_REG_IRQ_CTL, priv->enabled_irqs);
> +	if (ret != 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int ncn26000_probe(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct ncn26000_priv *priv;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	phydev->priv = priv;
> +
> +	return 0;
> +}
> +
> +static void ncn26000_remove(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	struct ncn26000_priv *priv = phydev->priv;
> +
> +	// free the private structure pointer
> +	devm_kfree(dev, priv);

No need to call devm_kfree() - the point of devm_*() is that resources
are automatically released.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
