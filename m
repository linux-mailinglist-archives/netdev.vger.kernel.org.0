Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAE2644FF8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiLGAC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiLGACi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:02:38 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272D41002;
        Tue,  6 Dec 2022 16:02:36 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id d14so17720623edj.11;
        Tue, 06 Dec 2022 16:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lvL4OnvqYUv2eqU5ocEYZJSQSg7YdqtmTMbAFmsQl9o=;
        b=kN3lr6Fteki7u6iUPGObjTZpQ3C2E2mWd3YuHKYW9XG+Y5iHo2BQFupY7FfECHfrxq
         OKbTVUyJZ4bpeuFzYrv+X1SapApgjGdHu8lY6q3O9lcwgI7ap/j3KxNnSCiEKSU9WOeL
         iXaJkcmhGjketsyFGyh+q+JeKLyPXcyza1OYkAsfFSyitUqlkI8wnfXctIvXiVs5HMLi
         pzbeIlTRX1lQ9mfMolQs/+MA8lqiXhM8rUVnOxp+kBx8sRmMPAdykeTgpCzOTDDUjzXa
         vVMESsSpyYMXN7E2oTxwDh2SxV6lNLAdZK6J73zeOXRTB2zAqrBxF4fJ4b4RjYGb49LO
         Gdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvL4OnvqYUv2eqU5ocEYZJSQSg7YdqtmTMbAFmsQl9o=;
        b=bwMHXqGp84/bxA6cMr7vYFiNtYxaYv+6FepK0S3Mj780h78XncmXwOgBnB6C+NYUIS
         Z9abZVc/vm149Ln1YlJAMfk8yTa1gNtqo2+gh4k6HXb0TNgRaFwiooyeCavEVVwf7uUM
         oIE022uzTBvxhHKjTX1vYgzUYMGDtGJMjkm/CBl1DVQKOWfnTs9G9yIndNV/ZdrvaYnZ
         1Awfi3t7bQp4iDF0gyD2MFfeBr1RluiAcn5NBM5nluA3PKjYUEDHj79gxl5lH3intBwG
         g2/PvXqXBPDTxlVJ1NmZZZcWQ5bG7o6mhShlPR3QRM8JYoDumEPYUyqrJQqD6KuLXY8Y
         64BQ==
X-Gm-Message-State: ANoB5pmlS8mSfTRvMyT/2FjZeO5A9X8rg5tq8YLNasH9V3d/85ZUPQIn
        RiwprNHdBd/fpL3exRTjfqo=
X-Google-Smtp-Source: AA0mqf7gaFH0KIS1QRPsRDIvUoXgAu7GI+wvd0KasDAQOV+4nUOD8OmmDXJoo9nsI6aIy/oy2QL8aw==
X-Received: by 2002:a05:6402:2b91:b0:457:23cb:20ab with SMTP id fj17-20020a0564022b9100b0045723cb20abmr14333643edb.254.1670371354583;
        Tue, 06 Dec 2022 16:02:34 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id v18-20020a170906293200b0077b2b0563f4sm8015733ejd.173.2022.12.06.16.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 16:02:34 -0800 (PST)
Date:   Wed, 7 Dec 2022 01:02:45 +0100
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
Subject: [PATCH v5 net-next 5/5] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <d979c74880805525d6117e0e5ece8df9e8fdd2c1.1670371013.git.piergiorgio.beruto@gmail.com>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the onsemi NCN26000 10BASE-T1S industrial
Ethernet PHY. The driver supports Point-to-Multipoint operation without
auto-negotiation and with link control handling. The PHY also features
PLCA for improving performance in P2MP mode.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 MAINTAINERS                |   7 ++
 drivers/net/phy/Kconfig    |   7 ++
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/ncn26000.c | 201 +++++++++++++++++++++++++++++++++++++
 4 files changed, 216 insertions(+)
 create mode 100644 drivers/net/phy/ncn26000.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ed626cbdf5af..09f0bfa3ae64 100644
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
index 000000000000..d3c0a7420ea8
--- /dev/null
+++ b/drivers/net/phy/ncn26000.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/*
+ *  Driver for the onsemi 10BASE-T1S NCN26000 PHYs family.
+ *
+ * Copyright 2022 onsemi
+ */
+#include <linux/kernel.h>
+#include <linux/bitfield.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+
+#include "mdio-open-alliance.h"
+
+#define PHY_ID_NCN26000			0x180FF5A1
+
+#define NCN26000_REG_IRQ_CTL            16
+#define NCN26000_REG_IRQ_STATUS         17
+
+// the NCN26000 maps link_ctrl to BMCR_ANENABLE
+#define NCN26000_BCMR_LINK_CTRL_BIT	BMCR_ANENABLE
+
+// the NCN26000 maps link_status to BMSR_ANEGCOMPLETE
+#define NCN26000_BMSR_LINK_STATUS_BIT	BMSR_ANEGCOMPLETE
+
+#define NCN26000_IRQ_LINKST_BIT		BIT(0)
+#define NCN26000_IRQ_PLCAST_BIT		BIT(1)
+#define NCN26000_IRQ_LJABBER_BIT	BIT(2)
+#define NCN26000_IRQ_RJABBER_BIT	BIT(3)
+#define NCN26000_IRQ_PLCAREC_BIT	BIT(4)
+#define NCN26000_IRQ_PHYSCOL_BIT	BIT(5)
+
+#define TO_TMR_DEFAULT			32
+
+struct ncn26000_priv {
+	u16 enabled_irqs;
+};
+
+// driver callbacks
+
+static int ncn26000_config_init(struct phy_device *phydev)
+{
+	/* HW bug workaround: the default value of the PLCA TO_TIMER should be
+	 * 32, where the current version of NCN26000 reports 24. This will be
+	 * fixed in future PHY versions. For the time being, we force the
+	 * correct default here.
+	 */
+	return phy_write_mmd(phydev, MDIO_MMD_VEND2, MDIO_OATC14_PLCA_TOTMR,
+			     TO_TMR_DEFAULT);
+}
+
+static int ncn26000_config_aneg(struct phy_device *phydev)
+{
+	// Note: the NCN26000 supports only P2MP link mode. Therefore, AN is not
+	// supported. However, this function is invoked by phylib to enable the
+	// PHY, regardless of the AN support.
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	phydev->mdix = ETH_TP_MDI;
+
+	// bring up the link
+	return phy_write(phydev, MII_BMCR, NCN26000_BCMR_LINK_CTRL_BIT);
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
+static int ncn26000_read_status(struct phy_device *phydev)
+{
+	// The NCN26000 reports NCN26000_LINK_STATUS_BIT if the link status of
+	// the PHY is up. It further reports the logical AND of the link status
+	// and the PLCA status in the BMSR_LSTATUS bit.
+	int ret;
+
+	/* The link state is latched low so that momentary link
+	 * drops can be detected. Do not double-read the status
+	 * in polling mode to detect such short link drops except
+	 * the link was already down.
+	 */
+	if (!phy_polling_mode(phydev) || !phydev->link) {
+		ret = phy_read(phydev, MII_BMSR);
+		if (ret < 0)
+			return ret;
+		else if (ret & NCN26000_BMSR_LINK_STATUS_BIT)
+			goto upd_link;
+	}
+
+	ret = phy_read(phydev, MII_BMSR);
+	if (unlikely(ret < 0))
+		return ret;
+
+upd_link:
+	// update link status
+	if (ret & NCN26000_BMSR_LINK_STATUS_BIT) {
+		phydev->link = 1;
+		phydev->pause = 0;
+		phydev->duplex = DUPLEX_HALF;
+		phydev->speed = SPEED_10;
+	} else {
+		phydev->link = 0;
+		phydev->duplex = DUPLEX_UNKNOWN;
+		phydev->speed = SPEED_UNKNOWN;
+	}
+
+	return 0;
+}
+
+static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
+{
+	const struct ncn26000_priv *const priv = phydev->priv;
+	int ret;
+
+	// read and aknowledge the IRQ status register
+	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
+
+	if (unlikely(ret < 0) || (ret & priv->enabled_irqs) == 0)
+		return IRQ_NONE;
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
+static struct phy_driver ncn26000_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_NCN26000),
+		.name			= "NCN26000",
+		.probe                  = ncn26000_probe,
+		.get_features		= ncn26000_get_features,
+		.config_init            = ncn26000_config_init,
+		.config_intr            = ncn26000_config_intr,
+		.config_aneg		= ncn26000_config_aneg,
+		.read_status		= ncn26000_read_status,
+		.handle_interrupt       = ncn26000_handle_interrupt,
+		.get_plca_cfg		= genphy_c45_plca_get_cfg,
+		.set_plca_cfg		= genphy_c45_plca_set_cfg,
+		.get_plca_status	= genphy_c45_plca_get_status,
+		.soft_reset             = genphy_soft_reset,
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
+
+MODULE_AUTHOR("Piergiorgio Beruto");
+MODULE_DESCRIPTION("onsemi 10BASE-T1S PHY driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.35.1

