Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CB664F68B
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiLQAuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLQAtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:49:20 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030F661D4F;
        Fri, 16 Dec 2022 16:49:19 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bj12so9775308ejb.13;
        Fri, 16 Dec 2022 16:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LFywln9d0ZE5Lc4OuwpqIG/XKhL14HRi3xGiDG13yq8=;
        b=DHpL0tCY51YT+a3jsNPsCZvyKtvdc3SWPxV/dfZbkPK/LG5wt31viE/X+QE0Ii8SS0
         bpQJtMhJ8iHFVuOMEXLaM/SkGER8AmXhKM/hC1KibV2uTCMQkD6aj0oNw2oj86Oq3ncX
         K+Tu+gRgsVkR90STqbbfMzAEr1dCeBWA7B2W30i/12Z3hdQFwbPO1v5NgYctHZBacsxQ
         K6r1cvjtAUc09BRUmlEVGqFy9Ud2fEUYtcc/DAZfHMTWZY1XmvgOHC7OssxHItmaQNNq
         lNTpalo8XGRBf3pJfzH5lEROXjT0AnqEU52UpNgg6VtfzxApuQxk837+j5mWNEi7v6+v
         LQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFywln9d0ZE5Lc4OuwpqIG/XKhL14HRi3xGiDG13yq8=;
        b=W5W5i5ybMs8zjGlaB9XohZYlLmd4tauBQBW0vvo6jVdgr2Jq8Df8bh1m0H7WAx3tSO
         rnY14bhAhTT00vtt+6sFsl6DUkG/ABi+8SautZzr75qDJjA8QHQlEGiZsfTuIc22gOe7
         2s/4j180kAQMUDIV1vksFIKCpMBA4h9bC+hwINwmi0pxv7VSI7K+MsmuugCzXX/z1uUO
         OxWH9WzA6RytuU24tovS4NyyNL6avEuqaY9iRgIH/X5ttG29uIAKmxOT2Gz9YTBpMN5R
         MG17vQitc5hxH35Gq6Aks+HRv1szkusxa6PvbOvCfRihDZPJ5ZAGLRWGzaxKFA2I61el
         BPUg==
X-Gm-Message-State: ANoB5pmnUGq0KLjwkSqqkQDWhi8wNUN94cmPhwWzBqedKpDoqszWV2YO
        23llDFdxSkun+iqQ9Z9WvXY=
X-Google-Smtp-Source: AA0mqf4F8ognJiS+TrgUUkq5LfgFwhmMXAWRQAGC4Ye4kZTLwH54NbVmRkYhQeKERhI+wigdXPFmPA==
X-Received: by 2002:a17:906:6711:b0:7ad:c5b7:1c79 with SMTP id a17-20020a170906671100b007adc5b71c79mr25651323ejp.45.1671238157527;
        Fri, 16 Dec 2022 16:49:17 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id ku10-20020a170907788a00b007c0d4d3a0c1sm1392543ejc.32.2022.12.16.16.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 16:49:17 -0800 (PST)
Date:   Sat, 17 Dec 2022 01:49:15 +0100
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
Subject: [PATCH v7 net-next 5/5] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <5518b1e55dcda92079095ae30f98a7161d8d4cdc.1671234284.git.piergiorgio.beruto@gmail.com>
References: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1671234284.git.piergiorgio.beruto@gmail.com>
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
 drivers/net/phy/ncn26000.c | 171 +++++++++++++++++++++++++++++++++++++
 4 files changed, 186 insertions(+)
 create mode 100644 drivers/net/phy/ncn26000.c

diff --git a/MAINTAINERS b/MAINTAINERS
index b688aeae98b2..b4e9e2e93d1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15483,6 +15483,13 @@ L:	linux-mips@vger.kernel.org
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
index 1327290decab..08706efa4b43 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -264,6 +264,13 @@ config NATIONAL_PHY
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
index 000000000000..78712d0e2b7e
--- /dev/null
+++ b/drivers/net/phy/ncn26000.c
@@ -0,0 +1,171 @@
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
+#define NCN26000_IRQ_RESET_BIT		BIT(15)
+
+#define TO_TMR_DEFAULT			32
+
+// driver callbacks --------------------------------------------------------- //
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
+	int ret;
+
+	// read and aknowledge the IRQ status register
+	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
+
+	// check only link status changes
+	if (unlikely(ret < 0) || (ret & NCN26000_REG_IRQ_STATUS) == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+	return IRQ_HANDLED;
+}
+
+static int ncn26000_config_intr(struct phy_device *phydev)
+{
+	int ret;
+	u16 irqe;
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		// acknowledge IRQs
+		ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
+		if (ret < 0)
+			return ret;
+
+		// get link status notifications
+		irqe = NCN26000_IRQ_LINKST_BIT;
+	} else {
+		// disable all IRQs
+		irqe = 0;
+	}
+
+	ret = phy_write(phydev, NCN26000_REG_IRQ_CTL, irqe);
+	if (ret != 0)
+		return ret;
+
+	return 0;
+}
+
+static struct phy_driver ncn26000_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_NCN26000),
+		.name			= "NCN26000",
+		.features		= PHY_BASIC_T1S_P2MP_FEATURES,
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
2.37.4

