Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F8064911D
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 23:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLJWrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 17:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLJWrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 17:47:18 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D8F1580B;
        Sat, 10 Dec 2022 14:47:15 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id x22so19465459ejs.11;
        Sat, 10 Dec 2022 14:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nEDUeWremjVyMSiDImz6Mbb6zvZ4X4BIwuz9Aa8ukio=;
        b=DJWGXpMTaHctgCPxwdyW78rrGboqnHtI2NL4q4AJ5gRbzR2lR5nHWywDE8tjhiVlyZ
         HofxeBjxpM5tj46nn/JmnS6CUQBnwzxrYsBWdv1FqmbNt3feU1c2Kfa5C3akv/KpzF1P
         bDjDP2KwbWKnSizHNf9JIzM0XECu3wK+IbX/6ign9ygJOXXeQ2TQ5wlt8vJ63KOLz5wT
         MwOZP9HoXM7ba72qXnuBMi6JuBQRhLayqdGagPlpQRZG71K/9hN4kJdjxAhCsIbYmZBK
         6lTdcFqZm99xgwg947ZSYOpk5inVsQhStMr3lbncODtII0SKqA04QBS3i6Sowzm/2X8b
         dfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEDUeWremjVyMSiDImz6Mbb6zvZ4X4BIwuz9Aa8ukio=;
        b=i1hJvQ79U9g27+3kukCEKNxiAj5pqTlH/CHm9TilhvdZDmcR0Y51/2hTprFop6JRhO
         IqMjs8tGxGy7plP0x/1O14vxvwGM5cFxErue9BHmFfJ4+1hRRe5icmgtw2AMQIkyVTOk
         i6PVdfcwUTwWK2obaTNrg+MR2zR07GRtRGzT3Ag2rNe6DQGEbJFMCgk/s2uw7zY9EbD9
         KHrfvGS/dqsBrQEhGbFPxf1edt0DsEJ348/LuvUjpzku4snJcE76bqZhsLoR9HLbphA+
         7vLNaodCIV2PjmurazKCiw8hHZpdHzrgFSyUXgSKmSi3iIYsWMPOiyA5VusT4KggG4Ig
         uy3g==
X-Gm-Message-State: ANoB5plBDgaPpWnVHQwjqEGbR5icbphN5TZCB9HQWheUTUNncvXTbfjc
        PzJQNYQY/a6r+6ahAtsaU6Q=
X-Google-Smtp-Source: AA0mqf7nWAwdmO2CsPk04o06CG3KOIsII+GvwAP5NRmAhPiIs8TpLOuEh9jI95b71GJfDLp/kyxZ8A==
X-Received: by 2002:a17:906:a0d0:b0:7af:a2c:3eca with SMTP id bh16-20020a170906a0d000b007af0a2c3ecamr9653596ejb.4.1670712433955;
        Sat, 10 Dec 2022 14:47:13 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id e9-20020a170906080900b007bfacaea851sm1431004ejd.88.2022.12.10.14.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Dec 2022 14:47:13 -0800 (PST)
Date:   Sat, 10 Dec 2022 23:47:12 +0100
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
Subject: [PATCH v6 net-next 5/5] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <26f78ad5bb5e40859cebb9b303777f942c446a8f.1670712151.git.piergiorgio.beruto@gmail.com>
References: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670712151.git.piergiorgio.beruto@gmail.com>
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

