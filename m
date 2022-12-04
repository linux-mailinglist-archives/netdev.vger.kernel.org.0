Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18448641A6B
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 03:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiLDCb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 21:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLDCb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 21:31:28 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6092C1B7B4;
        Sat,  3 Dec 2022 18:31:27 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id i15so3133527edf.2;
        Sat, 03 Dec 2022 18:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XRpjnxOmUehSwUz0e+C6V4VnXFPwsypRa5UOF2nX7kw=;
        b=qMkgZU+yfsNHJYiCKQDJx+qVzNDZD2GufN5ICFQ08aIsaRnvb0m5hZ6xI/FVFz/6rD
         /gbivopZLQ2qwi92vlWonSppbDOPnvmHhsOK+BbBxYpumeOBvN5DxihtlDqpHxgWZx4P
         4xeEp776WcxfiIr/9jcFVj6CwGdN1taCdtETnj240zFfsZDzFJDtyRJ5Xu6HLgylTNJw
         DezQY2A+Yn1DEwXxK5oE+Ef4DG3VBlXzA16ZDAWnZDW+DDTRUI5QWgZy9ugS/1TM5gBt
         PwPZmGykA/nHt0ryaRXOTPbwYNyv0uQrTRGhAFkkh/KFalQwJ5/uT6hiCQCltesJ9EmS
         IFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRpjnxOmUehSwUz0e+C6V4VnXFPwsypRa5UOF2nX7kw=;
        b=lOoD1h5YikpRsCsRq6etNxxRMJ6OIERnozOfh4zCebTJx3PoiQ6IMjydzKXcu66l8x
         Q0NPIzC5TUQCMCoASk9wsI/UlbuIsI8SPFjLhscl/0+qCtVJY77ppAHGbrPySQWVKPEV
         mbEwYXgFglCnFkhBOQ8oOUXuMKRtLl6sXl/5DGOwBT7BcsPCecAQG+6hyeeQCckqdiJr
         VyxFELvE+95t/Svzuy9iItUgse3kXHH66waGFP8c/Y63bq7sWpDADPoh8n/nNW8hO7oi
         ylA5mIPQvoisnBosgzIQb06ugAkunr25/qpAGQmVuFfagp/UOtzQBsBI2eq4A3suFD5F
         5UEw==
X-Gm-Message-State: ANoB5pkvazRhibrkZy4qJS+sBiATkovdXEgY7M04MSEXaW9pnzR9xYlF
        Suf4fOzqjzom9K4SkNf24mxPLUeEDcjg1m5i
X-Google-Smtp-Source: AA0mqf61VyrYwBDn6H9QEjS8UbI0nYV8jcXYrHfZgcffPWi6OFvVhq2dPWxlEsKm81QkPhJgvFasiA==
X-Received: by 2002:a05:6402:3212:b0:46c:76da:b58b with SMTP id g18-20020a056402321200b0046c76dab58bmr2892233eda.116.1670121085878;
        Sat, 03 Dec 2022 18:31:25 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id vw22-20020a170907059600b0073dd8e5a39fsm950199ejb.156.2022.12.03.18.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 18:31:25 -0800 (PST)
Date:   Sun, 4 Dec 2022 03:31:33 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the onsemi NCN26000 10BASE-T1S industrial Ethernet PHY.
The driver supports Point-to-Multipoint operation without
auto-negotiation and with link control handling. The PLCA RS support
will be included on a separate patch.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 MAINTAINERS                |   7 ++
 drivers/net/phy/Kconfig    |   7 ++
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/ncn26000.c | 193 +++++++++++++++++++++++++++++++++++++
 4 files changed, 208 insertions(+)
 create mode 100644 drivers/net/phy/ncn26000.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7952243e4b43..f07527baf321 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15357,6 +15357,13 @@ L:	linux-mips@vger.kernel.org
 S:	Maintained
 F:	arch/mips/boot/dts/ralink/omega2p.dts
 
+ONSEMI ETHERNET PHY DRIVERS
+M:	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+W:	http://www.onsemi.com
+F:	drivers/net/phy/ncn*
+
 OP-TEE DRIVER
 M:	Jens Wiklander <jens.wiklander@linaro.org>
 L:	op-tee@lists.trustedfirmware.org
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index af00cf44cd97..7c466830c611 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -267,6 +267,13 @@ config NATIONAL_PHY
 	help
 	  Currently supports the DP83865 PHY.
 
+config NCN26000_PHY
+	tristate "onsemi 10BASE-T1S Ethernet PHY"
+	help
+	  Adds support for the onsemi 10BASE-T1S Ethernet PHY.
+	  Currently supports the NCN26000 10BASE-T1S Industrial PHY
+	  with MII interface.
+
 config NXP_C45_TJA11XX_PHY
 	tristate "NXP C45 TJA11XX PHYs"
 	depends on PTP_1588_CLOCK_OPTIONAL
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index f7138d3c896b..b5138066ba04 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_MICROCHIP_T1_PHY)	+= microchip_t1.o
 obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
 obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
+obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
 obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
diff --git a/drivers/net/phy/ncn26000.c b/drivers/net/phy/ncn26000.c
new file mode 100644
index 000000000000..65a34edc5b20
--- /dev/null
+++ b/drivers/net/phy/ncn26000.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/*
+ *  Driver for Analog Devices Industrial Ethernet T1L PHYs
+ *
+ * Copyright 2020 Analog Devices Inc.
+ */
+#include <linux/kernel.h>
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+#include <linux/property.h>
+
+#define PHY_ID_NCN26000				0x180FF5A1
+
+#define NCN26000_REG_IRQ_CTL                    ((u16)16)
+#define NCN26000_REG_IRQ_STATUS                 ((u16)17)
+
+#define NCN26000_IRQ_LINKST_BIT                 ((u16)1)
+#define NCN26000_IRQ_PLCAST_BIT                 ((u16)(1 << 1))
+#define NCN26000_IRQ_LJABBER_BIT                ((u16)(1 << 2))
+#define NCN26000_IRQ_RJABBER_BIT                ((u16)(1 << 3))
+#define NCN26000_IRQ_RJABBER_BIT                ((u16)(1 << 3))
+#define NCN26000_IRQ_PLCAREC_BIT                ((u16)(1 << 4))
+#define NCN26000_IRQ_PHYSCOL_BIT                ((u16)(1 << 5))
+
+struct ncn26000_priv {
+	u16 enabled_irqs;
+};
+
+static int ncn26000_config_init(struct phy_device *phydev)
+{
+	// TODO: add vendor-specific tuning (ENI, CMC, ...)
+	return 0;
+}
+
+static int ncn26000_enable(struct phy_device *phydev)
+{
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	phydev->mdix = ETH_TP_MDI;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+	phydev->speed = SPEED_10;
+	phydev->duplex = DUPLEX_HALF;
+
+	// bring up the link (link_ctrl is mapped to BMCR_ANENABLE)
+	// clear also ISOLATE mode and Collision Test
+	return phy_write(phydev, MII_BMCR, BMCR_ANENABLE);
+}
+
+static int ncn26000_soft_reset(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_set_bits(phydev, MII_BMCR, BMCR_RESET);
+
+	if (ret != 0)
+		return ret;
+
+	return phy_read_poll_timeout(phydev,
+				     MII_BMCR,
+				     ret,
+				     !(ret & BMCR_RESET),
+				     500,
+				     20000,
+				     true);
+}
+
+static int ncn26000_get_features(struct phy_device *phydev)
+{
+	linkmode_zero(phydev->supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, phydev->supported);
+
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
+			 phydev->supported);
+
+	linkmode_copy(phydev->advertising, phydev->supported);
+	return 0;
+}
+
+static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
+{
+	const struct ncn26000_priv *const priv = phydev->priv;
+	u16 events;
+	int ret;
+
+	// read and aknowledge the IRQ status register
+	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
+
+	if (unlikely(ret < 0))
+		return IRQ_NONE;
+
+	events = (u16)ret & priv->enabled_irqs;
+	if (events == 0)
+		return IRQ_NONE;
+
+	if (events & NCN26000_IRQ_LINKST_BIT) {
+		ret = phy_read(phydev, MII_BMSR);
+
+		if (unlikely(ret < 0)) {
+			phydev_err(phydev,
+				   "error reading the status register (%d)\n",
+				   ret);
+
+			return IRQ_NONE;
+		}
+
+		phydev->link = ((u16)ret & BMSR_ANEGCOMPLETE) ? 1 : 0;
+	}
+
+	// handle more IRQs here
+
+	phy_trigger_machine(phydev);
+	return IRQ_HANDLED;
+}
+
+static int ncn26000_config_intr(struct phy_device *phydev)
+{
+	int ret;
+	struct ncn26000_priv *priv = phydev->priv;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		// acknowledge IRQs
+		ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
+		if (ret < 0)
+			return ret;
+
+		// get link status notifications
+		priv->enabled_irqs = NCN26000_IRQ_LINKST_BIT;
+	} else {
+		// disable all IRQs
+		priv->enabled_irqs = 0;
+	}
+
+	ret = phy_write(phydev, NCN26000_REG_IRQ_CTL, priv->enabled_irqs);
+	if (ret != 0)
+		return ret;
+
+	return 0;
+}
+
+static int ncn26000_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct ncn26000_priv *priv;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
+static void ncn26000_remove(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct ncn26000_priv *priv = phydev->priv;
+
+	// free the private structure pointer
+	devm_kfree(dev, priv);
+}
+
+static struct phy_driver ncn26000_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_NCN26000),
+		.name			= "NCN26000",
+		.probe                  = ncn26000_probe,
+		.remove                 = ncn26000_remove,
+		.get_features		= ncn26000_get_features,
+		.config_init            = ncn26000_config_init,
+		.soft_reset             = ncn26000_soft_reset,
+		.config_intr            = ncn26000_config_intr,
+		.config_aneg		= ncn26000_enable,
+		.handle_interrupt       = ncn26000_handle_interrupt,
+	},
+};
+
+module_phy_driver(ncn26000_driver);
+
+static struct mdio_device_id __maybe_unused ncn26000_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_NCN26000) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, ncn26000_tbl);
+MODULE_AUTHOR("Piergiorgio Beruto");
+MODULE_DESCRIPTION("onsemi 10BASE-T1S PHY driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.35.1

