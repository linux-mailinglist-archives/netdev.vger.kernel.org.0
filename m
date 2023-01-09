Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6EC661B50
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 01:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbjAIALb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 19:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbjAIALQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 19:11:16 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7261210B7A;
        Sun,  8 Jan 2023 16:11:14 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h16so6610389wrz.12;
        Sun, 08 Jan 2023 16:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hMUGyFQoTr7dtUhf+JsgZCYMuleueVcI0KxfuREld58=;
        b=jMSTvhBGVnuNRaEwu/OvNbOHmIB21pMDgGT7a1lGjRXpTJLV2qWwM6enmnq1LfG6Hl
         g1d2jo4Q+nxzKI01UI+anv7caSJNVSaQv65027sVOJpDxQECy7QOeBk7D2P5zyNXp57v
         cTwRjdZ+SIxUeK16U1lHMpQw2sXo9CoXIUVOKN7747JeQx8cJ2DEbIzLLrCCL0HVk1yf
         ZCVnwKXGxzzmp+rpAVB3x/21am/6Tv4oGzts9Ytjoa6zihm8F35CwWklx+FehtQ7Xuzn
         J9ST06L8d5FMe0R09SQavrZuMPrOIyVVMH0cie6mPnu+vS5pxi8LyVxgEeeNlkuvV6Ls
         gtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMUGyFQoTr7dtUhf+JsgZCYMuleueVcI0KxfuREld58=;
        b=RWdcIq4NEJYjNPB5dZA2mOFjtTI3CFeHrOFGBgSYvyfzkFl8Nzrj5ukMY5vqvoCeVI
         yIErrEKDsKnwMZJ1Lm0BJA5MjX/DGAEfZBt7mCjkDIPISh3phNj6FBVZnvijFZFWso0J
         WOoQhXIV53BjgSQd322Zb9pt0moMC+QKREF+1iPSKRaUw+es1iKid9z4IomlVa6OOAb4
         7u0O0DqDq89VIAoStw4EGke2n4vyce0Vs3EFsRoghmlsoeftj4cPHZ3+N4T1AGX6RIj3
         hijmi0f7zo5+3mgsLWGbPGi5O1h8PQ7rHuhQeHap60ocQSZI2r0ZiVXuAOvostMvmO8R
         GQUg==
X-Gm-Message-State: AFqh2kqZGS3dtX3TNXHGCg9MpAg/HSrzO1yGkYJZOlFrQrTN8YKYAQs4
        Tmfy6PiDqF+l3PlNXlt39Jg=
X-Google-Smtp-Source: AMrXdXt+12wKZxIKYqgLQaTBixESwklm8ujS4SqnIOncqSMmc4ufyjA2P4XXxtM04zaNnjLmjOJrEg==
X-Received: by 2002:a05:6000:90a:b0:2a2:e87a:b4e1 with SMTP id bz10-20020a056000090a00b002a2e87ab4e1mr11770111wrb.36.1673223072871;
        Sun, 08 Jan 2023 16:11:12 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id w10-20020a5d608a000000b0027cfd9463d7sm7077244wrt.110.2023.01.08.16.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 16:11:12 -0800 (PST)
Date:   Mon, 9 Jan 2023 01:11:11 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v3 net-next 5/5] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <d726fc691ede5c4b62a71093d4496a467ccc9a01.1673222807.git.piergiorgio.beruto@gmail.com>
References: <cover.1673222807.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1673222807.git.piergiorgio.beruto@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 MAINTAINERS                |   7 ++
 drivers/net/phy/Kconfig    |   7 ++
 drivers/net/phy/Makefile   |   1 +
 drivers/net/phy/ncn26000.c | 171 +++++++++++++++++++++++++++++++++++++
 4 files changed, 186 insertions(+)
 create mode 100644 drivers/net/phy/ncn26000.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4356382ad57c..c1dadb34009d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15581,6 +15581,13 @@ L:	linux-mips@vger.kernel.org
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
index 1327290decab..7eee2beb3475 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -277,6 +277,13 @@ config NXP_TJA11XX_PHY
 	help
 	  Currently supports the NXP TJA1100 and TJA1101 PHY.
 
+config NCN26000_PHY
+	tristate "onsemi 10BASE-T1S Ethernet PHY"
+	help
+	  Adds support for the onsemi 10BASE-T1S Ethernet PHY.
+	  Currently supports the NCN26000 10BASE-T1S Industrial PHY
+	  with MII interface.
+
 config AT803X_PHY
 	tristate "Qualcomm Atheros AR803X PHYs and QCA833x PHYs"
 	depends on REGULATOR
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
index 000000000000..5680584f659e
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
+	/* Note: the NCN26000 supports only P2MP link mode. Therefore, AN is not
+	 * supported. However, this function is invoked by phylib to enable the
+	 * PHY, regardless of the AN support.
+	 */
+	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+	phydev->mdix = ETH_TP_MDI;
+
+	// bring up the link
+	return phy_write(phydev, MII_BMCR, NCN26000_BCMR_LINK_CTRL_BIT);
+}
+
+static int ncn26000_read_status(struct phy_device *phydev)
+{
+	/* The NCN26000 reports NCN26000_LINK_STATUS_BIT if the link status of
+	 * the PHY is up. It further reports the logical AND of the link status
+	 * and the PLCA status in the BMSR_LSTATUS bit.
+	 */
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
+	if (ret < 0)
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
+	if (ret < 0 || (ret & NCN26000_REG_IRQ_STATUS) == 0)
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

