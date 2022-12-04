Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE646641EF4
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiLDSkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiLDSkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:40:16 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7801613E04;
        Sun,  4 Dec 2022 10:40:15 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id a16so12977721edb.9;
        Sun, 04 Dec 2022 10:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=06uzwItCKtLQhJwsAfieSH/ejbn0aRznZcwD5Bpm90c=;
        b=CIwhYJMTdg9v6i4Xa1XBgRknR11vg+gYAuG/y5e2AiQiAZfdCMtrOyDD1NmVs6K9hH
         UIkHnY32pb1hF1kuZYffWwPyPvfuEGul2EJU/VRIMqb5qEmSf3XdzVqAASyV8OkUQMIj
         tibTwZopWNPffbVqKtCCw4DrnPkVs6q8HaYCjtE5u6nUJFiSgh8Nn2RKjxPsVeMrbnm0
         483KJSfLLp8YmZa2netolE+laDeY2Z2M7t6Jz5zUKEQ3TpYRgL+hcc6RQHkxlL6E0/vN
         E4EEtqRMouen3BOz3xsJXshOPhTakKz6P+Kw2RauOg5nh+DABK0ipJYLuX9yaRrBGqLz
         LhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06uzwItCKtLQhJwsAfieSH/ejbn0aRznZcwD5Bpm90c=;
        b=wZgy1VxIqiIgnO/SHTHRNF5qmtU/pOYIx7aY0sBrljksMCae2564f3whopgRLXSeow
         +8Uo6yIaulmaq7nCgw1FeHQxalfjqCwr6OXNuUvy4OVDYK7bOUtBg+HTFKG9wSZcByw+
         AHMXbmFercMG6ZIY6WMkD7cZM3q/E4ELtIENB8m7dhuab+59aBmwGyTgqzvJ00gNDrbw
         voDj7sSaWdG2mZd88mYfEAn20BG+GUe+8fQ9v5PuIiSINSbAOMKxhXpMolNFTJld3CxT
         UxKLZJ8LLpRzCyGeZR7xmlfQMhVukjBFdNJqIP0nIFxdvVlypsKAIwpxdgHBu6P0b/T7
         7pIg==
X-Gm-Message-State: ANoB5pnPyLfZh7PJpYpsBr2VctkfPbZ4uhd4XBGPJJ8BH1xwRe+5GF8H
        GfCoolNJe5JXA1GmBCgVZ0E=
X-Google-Smtp-Source: AA0mqf6HwRb4GREYbKyfjN7Mm2DiZ7lWHyUdc011s09zwYnov0wwzndT2ZDlm6sZemUgNMKpbc6NdQ==
X-Received: by 2002:a05:6402:28c4:b0:469:ee21:16d4 with SMTP id ef4-20020a05640228c400b00469ee2116d4mr33487226edb.315.1670179213991;
        Sun, 04 Dec 2022 10:40:13 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b007ad9c826d75sm5334184ejf.61.2022.12.04.10.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 10:40:13 -0800 (PST)
Date:   Sun, 4 Dec 2022 19:40:22 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y4zplu5hdrh8CvZ5@gvm01>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 04, 2022 at 04:52:04PM +0000, Russell King (Oracle) wrote:
> Hi,
> 
> On Sun, Dec 04, 2022 at 03:31:33AM +0100, Piergiorgio Beruto wrote:
> > diff --git a/drivers/net/phy/ncn26000.c b/drivers/net/phy/ncn26000.c
> > new file mode 100644
> > index 000000000000..65a34edc5b20
> > --- /dev/null
> > +++ b/drivers/net/phy/ncn26000.c
> > @@ -0,0 +1,193 @@
> > +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> > +/*
> > + *  Driver for Analog Devices Industrial Ethernet T1L PHYs
> > + *
> > + * Copyright 2020 Analog Devices Inc.
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/bitfield.h>
> > +#include <linux/delay.h>
> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/mii.h>
> > +#include <linux/phy.h>
> > +#include <linux/property.h>
> > +
> > +#define PHY_ID_NCN26000				0x180FF5A1
> > +
> > +#define NCN26000_REG_IRQ_CTL                    ((u16)16)
> > +#define NCN26000_REG_IRQ_STATUS                 ((u16)17)
> > +
> > +#define NCN26000_IRQ_LINKST_BIT                 ((u16)1)
> > +#define NCN26000_IRQ_PLCAST_BIT                 ((u16)(1 << 1))
> > +#define NCN26000_IRQ_LJABBER_BIT                ((u16)(1 << 2))
> > +#define NCN26000_IRQ_RJABBER_BIT                ((u16)(1 << 3))
> > +#define NCN26000_IRQ_RJABBER_BIT                ((u16)(1 << 3))
> > +#define NCN26000_IRQ_PLCAREC_BIT                ((u16)(1 << 4))
> > +#define NCN26000_IRQ_PHYSCOL_BIT                ((u16)(1 << 5))
> 
> There isn't much point in having the casts to u16 here. Also,
> BIT() is useful for identifying single bits.
Ok, I'll fix, thanks.

> > +static int ncn26000_enable(struct phy_device *phydev)
> > +{
> 
> This is actually the config_aneg() implementation, it should be named
> as such.
I can certainly rename it, however I did this for a reason. The NCN26000
only supports P2MP mode. Therefore, it does not support AN (this is
clearly indicated in the IEEE specifications as well).

However, it is my understanding that the config_aneg() callback is
invoked also for PHYs that do not support AN, and this is actually the
only way to set a link_control bit to have the PHY enable the PMA/PCS
functions. So I thought to call this function "enable" to make it clear
we're not really implementing autoneg, but link_control.

But as I said, I am not strongly biased towards this name, I just wanted
to let you know the rationale behind my choice.

Please let me know if you wish to reconsider or you still prefer to
rename it.

> > +	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> > +	phydev->mdix = ETH_TP_MDI;
> > +	phydev->pause = 0;
> > +	phydev->asym_pause = 0;
> > +	phydev->speed = SPEED_10;
> > +	phydev->duplex = DUPLEX_HALF;
> 
> Is this initialisation actually necessary?
To be honest, I am not sure. Reading the code for genphy_c45_read_pma()
and genphy_c45_read_status() I can see those variables are set. In my
case, the driver is -not- invoking those functions, therefore I thought
this initialization should be needed. If not, I can certainly remove it.
Advices?
 
> > +
> > +	// bring up the link (link_ctrl is mapped to BMCR_ANENABLE)
> > +	// clear also ISOLATE mode and Collision Test
> > +	return phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
> 
> You always use AN even when ethtool turns off AN? If AN is mandatory,
> it seems there should be some way that phylib can force that to be
> the case.
I need to explain this better. The NCN26000, as I said earlier, does
-not- support AN. However, it re-uses the AN bit to implement the
link_control function (described in the IEEE specifications). Therefore,
setting AN on this PHY actually means bringing up the link.

I don't know if it could be better to add a define (specific for this
PHY) for the link_control bit and set it == BMCR_ANENABLE? Would that be
more clear for the reader?

> > +}
> > +
> > +static int ncn26000_soft_reset(struct phy_device *phydev)
> > +{
> > +	int ret;
> > +
> > +	ret = phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
> > +
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	return phy_read_poll_timeout(phydev,
> > +				     MII_BMCR,
> > +				     ret,
> > +				     !(ret & BMCR_RESET),
> > +				     500,
> > +				     20000,
> > +				     true);
> 
> Isn't this just genphy_reset() ?
Right, this was a leftover. I substituted with genphy_soft_reset() and
indeed it works just fine. Thanks for noticing.

> > +}
> > +
> > +static int ncn26000_get_features(struct phy_device *phydev)
> > +{
> > +	linkmode_zero(phydev->supported);
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, phydev->supported);
> > +
> > +	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> > +			 phydev->supported);
> > +
> > +	linkmode_copy(phydev->advertising, phydev->supported);
> > +	return 0;
> > +}
> > +
> > +static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
> > +{
> > +	const struct ncn26000_priv *const priv = phydev->priv;
> > +	u16 events;
> > +	int ret;
> > +
> > +	// read and aknowledge the IRQ status register
> > +	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> > +
> > +	if (unlikely(ret < 0))
> > +		return IRQ_NONE;
> > +
> > +	events = (u16)ret & priv->enabled_irqs;
> > +	if (events == 0)
> > +		return IRQ_NONE;
> > +
> > +	if (events & NCN26000_IRQ_LINKST_BIT) {
> > +		ret = phy_read(phydev, MII_BMSR);
> > +
> > +		if (unlikely(ret < 0)) {
> > +			phydev_err(phydev,
> > +				   "error reading the status register (%d)\n",
> > +				   ret);
> > +
> > +			return IRQ_NONE;
> > +		}
> > +
> > +		phydev->link = ((u16)ret & BMSR_ANEGCOMPLETE) ? 1 : 0;
> 
> 1. aneg_complete shouldn't be used to set phydev->link.
> 2. phydev->link should be updated in the read_status() function, which
> the state machine will call. Setting it here without taking the lock
> introduces races.
Same as before. AN complete is used as an extended link status
indication for this PHY, considering the PLCA status as well. It is not
the result of AN (which is not supported).

> > +	}
> > +
> > +	// handle more IRQs here
> > +
> > +	phy_trigger_machine(phydev);
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +static int ncn26000_config_intr(struct phy_device *phydev)
> > +{
> > +	int ret;
> > +	struct ncn26000_priv *priv = phydev->priv;
> > +
> > +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> > +		// acknowledge IRQs
> > +		ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		// get link status notifications
> > +		priv->enabled_irqs = NCN26000_IRQ_LINKST_BIT;
> > +	} else {
> > +		// disable all IRQs
> > +		priv->enabled_irqs = 0;
> > +	}
> > +
> > +	ret = phy_write(phydev, NCN26000_REG_IRQ_CTL, priv->enabled_irqs);
> > +	if (ret != 0)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> > +static int ncn26000_probe(struct phy_device *phydev)
> > +{
> > +	struct device *dev = &phydev->mdio.dev;
> > +	struct ncn26000_priv *priv;
> > +
> > +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	phydev->priv = priv;
> > +
> > +	return 0;
> > +}
> > +
> > +static void ncn26000_remove(struct phy_device *phydev)
> > +{
> > +	struct device *dev = &phydev->mdio.dev;
> > +	struct ncn26000_priv *priv = phydev->priv;
> > +
> > +	// free the private structure pointer
> > +	devm_kfree(dev, priv);
> 
> No need to call devm_kfree() - the point of devm_*() is that resources
> are automatically released.
> 
> Thanks.
Got it, Thanks!

