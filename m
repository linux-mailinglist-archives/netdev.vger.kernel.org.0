Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D87644387
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiLFMyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbiLFMyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:54:00 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58B562CC;
        Tue,  6 Dec 2022 04:53:55 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bj12so5865310ejb.13;
        Tue, 06 Dec 2022 04:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vtmK9mWiq87BtwWKXZvJqVPU4p1Dd/y6RGKbmSiy148=;
        b=HtxvEH5dKBCXLe4DbnWPWFk+DyJq5ujOjCHJosyNoP7VgEJtDsyKezoqupW6IQBpq3
         zvMBT7t71JQD8/5wbU725kdxpUmV/ugobB/ZHhrTodWhqiT/8MmV0khzm8/x27lEB1fm
         LI0bhU9llE1cXyYD1ZB8UgBKzKnS1eEjqGkYT67A8iPKRIq+KXxQ3JR/ZIef37SMt0+A
         /XOxkQM7Vakqui3a66qQfuOR4caXTnC6Uepod3UmL72QXBTmPTHWKNkVZY1CeCZ/m/9M
         ev+uKl+uWBLady3+HteAs7LBRq8FQVioAbPcwUAr2YLMmSPTSapKKX7kX9LfgxDNIh8n
         aFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vtmK9mWiq87BtwWKXZvJqVPU4p1Dd/y6RGKbmSiy148=;
        b=OrYnmaNkX97hVrT8BQxjYrH/m//QL6Qtr1RW47dGikfXITz16Vpfq9vHAMFChfQbBk
         Eo7ZZpeigg3uGJsGwSPaKNFnOJRYISUodBvd0+WDuonV6BOOduf1bKk1nEe5hoZrK7Sm
         HCJm4ETU+nnv40yihrr55Iac7PKU6kEO9eFxAXFDH+5vt0vAOKvkA7D8+4wCWsRgfNyh
         qYSGiTQ5aXqjO30Cpr+koUWNAUNBly2utkJGrZiIPoa+e6AASgERPTVNj2ujauI4JpIz
         V1C0T5yZ+wU3q1m2ADj0H1Yea3ndd0ObXv8Qy34o0EJyJSZl2K75+f92woiMeH0liFcd
         38cQ==
X-Gm-Message-State: ANoB5pmLVeDGT/X1Z6Vy0S6fHhHbx3CO/JNI74/yJ0HdWpZzslvQweCU
        jinqtMnWfzgDgI9VyyGmii4=
X-Google-Smtp-Source: AA0mqf7T5qbqjZjJ0XEPJN0VQd0dBwxxUDpb7vsrCpHVdMK6djrHmF5mpQ/q8gQU8j+14ftSTL/6yg==
X-Received: by 2002:a17:906:2cd3:b0:7bf:b675:ffdd with SMTP id r19-20020a1709062cd300b007bfb675ffddmr33108707ejr.610.1670331234207;
        Tue, 06 Dec 2022 04:53:54 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b0073dc5bb7c32sm7331993eja.64.2022.12.06.04.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 04:53:53 -0800 (PST)
Date:   Tue, 6 Dec 2022 13:54:04 +0100
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
Subject: [PATCH v4 net-next 5/5] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <1816cb14213fc2050b1a7e97a68be7186340d994.1670329232.git.piergiorgio.beruto@gmail.com>
References: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670329232.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/ncn26000.c | 193 +++++++++++++++++++++++++++++++++++++
 4 files changed, 208 insertions(+)
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
index 000000000000..9e02c5c55244
--- /dev/null
+++ b/drivers/net/phy/ncn26000.c
@@ -0,0 +1,193 @@
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
+// module parameter: if set, the link status is derived from the PLCA status
+// default: false
+static bool link_status_plca;
+module_param(link_status_plca, bool, 0644);
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
+	return phy_write_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_TOTMR,
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
+	// and the PLCA status in the BMSR_LSTATUS bit. Thus, report the link
+	// status by testing the appropriate BMSR bit according to the module's
+	// parameter configuration.
+	const int lstatus_flag = link_status_plca ?
+		BMSR_LSTATUS : NCN26000_BMSR_LINK_STATUS_BIT;
+
+	int ret;
+
+	ret = phy_read(phydev, MII_BMSR);
+	if (unlikely(ret < 0))
+		return ret;
+
+	// update link status
+	phydev->link = (ret & lstatus_flag) ? 1 : 0;
+
+	// handle more IRQs here
+
+	return 0;
+}
+
+static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
+{
+	const struct ncn26000_priv *const priv = phydev->priv;
+	int ret;
+
+	// clear the latched bits in MII_BMSR
+	phy_read(phydev, MII_BMSR);
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

