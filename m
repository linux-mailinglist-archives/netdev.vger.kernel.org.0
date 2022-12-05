Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD44642126
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 02:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiLEBnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 20:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiLEBnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 20:43:10 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EDDA455;
        Sun,  4 Dec 2022 17:43:08 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bj12so24335014ejb.13;
        Sun, 04 Dec 2022 17:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VdNgiOPWvnG2hbLFvANntarHoVah9v850z1bcPtw1Kw=;
        b=U51DP4IPqzXO0ueegm0rqm4vPOSq1A4tfdRmJMHZsJLSkZDBSuEAFm5A5+t0tcWhPz
         XePOgItMPDFwaQyEUpBEHTOZ66MBAr8xhrD4JYdwoCABmds7JwvwiRq3FmCGZow19rPT
         o7IMG18AdFT9/EEyhE66L7XELEVdQKHVfByRtf9vHAredcKljlV7ODKC7mf9pKeS/a0E
         WZME7RMLN8GwcmJCs1AqNY3pJHrcd/EP6ggHyz2kpgo+HlzGVrgNijjmQ7cp4exas9OO
         7O6qMF3za2Pdus8ZzLLD//2hChYLvSTT7Rm8vYgnv0LvsGr/hi+GZjpaGetr1JYESM/l
         651A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VdNgiOPWvnG2hbLFvANntarHoVah9v850z1bcPtw1Kw=;
        b=UuYqTxL7yhC+0/HP11JQY4pXY8SelLaW4XbW3T70SdtxoKU9DRfluXzXaleFjl4Iu8
         NIRXoxp+0beZ8rRLe+IuJ7/9DNxW6moHQ73aQJd5hg1Vf47cIq3CjfHZOrIS2kg5iWPR
         wCuGTuuOSZpymY8byrJcLLkIE9jqk1yUVe6nE+MdvLpO7oPVE3l2Et04ya0q406Z9Sqm
         SuDNKlruoBPm0ZVG286GS/gC5QJpaat3CjsnPmvmAtkVcn/7WbUxvS9L+5qUqLJwUWq9
         XK3i1gFZ8RobArzPjGuYJBw+3XmuAVdFG6WLU/3xQHZ+FR7/MoAyF+6bMx4yNaQ+fCtG
         vPPg==
X-Gm-Message-State: ANoB5plK1ajb2+Efv/V7Q7UA82e3x3Ck/cNb+Qpvw01EpLBJoixWl1j9
        Jknse4lBOUtQ0mKLY8wjLLE=
X-Google-Smtp-Source: AA0mqf4Kh78HzlFwUCNPy6OsQno4Ym7t0nnd2fVyr9iQe+aZjHtYpgy30qgR4aTdN/YefEaokwrpFw==
X-Received: by 2002:a17:907:a072:b0:7c0:ff74:facc with SMTP id ia18-20020a170907a07200b007c0ff74faccmr53873ejc.515.1670204586761;
        Sun, 04 Dec 2022 17:43:06 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id jt1-20020a170906dfc100b0077205dd15basm16501ejc.66.2022.12.04.17.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 17:43:06 -0800 (PST)
Date:   Mon, 5 Dec 2022 02:43:15 +0100
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
Subject: [PATCH v2 net-next 4/4] drivers/net/phy: add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <fb10b2a22255d493c6e3abc330b6e3f5f28c495e.1670204277.git.piergiorgio.beruto@gmail.com>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
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
 MAINTAINERS                          |   8 ++
 drivers/net/phy/Kconfig              |   7 +
 drivers/net/phy/Makefile             |   1 +
 drivers/net/phy/mdio-open-alliance.h |  44 +++++++
 drivers/net/phy/ncn26000.c           | 187 +++++++++++++++++++++++++++
 drivers/net/phy/phy-c45.c            | 180 ++++++++++++++++++++++++++
 include/linux/phy.h                  |   6 +
 7 files changed, 433 insertions(+)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7952243e4b43..09f0bfa3ae64 100644
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
@@ -16400,6 +16407,7 @@ PLCA RECONCILIATION SUBLAYER (IEEE802.3 Clause 148)
 M:	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/phy/mdio-open-alliance.h
 F:	net/ethtool/plca.c
 
 PLDMFW LIBRARY
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
diff --git a/drivers/net/phy/mdio-open-alliance.h b/drivers/net/phy/mdio-open-alliance.h
new file mode 100644
index 000000000000..565f4162611d
--- /dev/null
+++ b/drivers/net/phy/mdio-open-alliance.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * mdio-open-alliance.h - definition of OPEN Alliance SIG standard registers
+ */
+
+#ifndef __MDIO_OPEN_ALLIANCE__
+#define __MDIO_OPEN_ALLIANCE__
+
+#include <linux/mdio.h>
+
+/* MDIO Manageable Devices (MMDs). */
+#define MDIO_MMD_OATC14		MDIO_MMD_VEND2
+
+/* Open Alliance TC14 (10BASE-T1S) registers */
+#define MDIO_OATC14_PLCA_IDVER	0xca00  /* PLCA ID and version */
+#define MDIO_OATC14_PLCA_CTRL0	0xca01	/* PLCA Control register 0 */
+#define MDIO_OATC14_PLCA_CTRL1	0xca02	/* PLCA Control register 1 */
+#define MDIO_OATC14_PLCA_STATUS	0xca03	/* PLCA Status register */
+#define MDIO_OATC14_PLCA_TOTMR	0xca04	/* PLCA TO Timer register */
+#define MDIO_OATC14_PLCA_BURST	0xca05	/* PLCA BURST mode register */
+
+/* Open Alliance TC14 PLCA IDVER register */
+#define MDIO_OATC14_PLCA_IDM	0xff00	/* PLCA MAP ID */
+#define MDIO_OATC14_PLCA_VER	0x00ff	/* PLCA MAP version */
+
+/* Open Alliance TC14 PLCA CTRL0 register */
+#define MDIO_OATC14_PLCA_EN	0x8000  /* PLCA enable */
+#define MDIO_OATC14_PLCA_RST	0x4000  /* PLCA reset */
+
+/* Open Alliance TC14 PLCA CTRL1 register */
+#define MDIO_OATC14_PLCA_NCNT	0xff00	/* PLCA node count */
+#define MDIO_OATC14_PLCA_ID	0x00ff	/* PLCA local node ID */
+
+/* Open Alliance TC14 PLCA STATUS register */
+#define MDIO_OATC14_PLCA_PST	0x8000	/* PLCA status indication */
+
+/* Open Alliance TC14 PLCA TOTMR register */
+#define MDIO_OATC14_PLCA_TOT	0x00ff
+
+/* Open Alliance TC14 PLCA BURST register */
+#define MDIO_OATC14_PLCA_MAXBC	0xff00
+#define MDIO_OATC14_PLCA_BTMR	0x00ff
+
+#endif /* __MDIO_OPEN_ALLIANCE__ */
diff --git a/drivers/net/phy/ncn26000.c b/drivers/net/phy/ncn26000.c
new file mode 100644
index 000000000000..49d4fee20cbc
--- /dev/null
+++ b/drivers/net/phy/ncn26000.c
@@ -0,0 +1,187 @@
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
+MODULE_DEVICE_TABLE(mdio, ncn26000_tbl);
+MODULE_AUTHOR("Piergiorgio Beruto");
+MODULE_DESCRIPTION("onsemi 10BASE-T1S PHY driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index a87a4b3ffce4..dace5d3b29ad 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -8,6 +8,8 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 
+#include "mdio-open-alliance.h"
+
 /**
  * genphy_c45_baset1_able - checks if the PMA has BASE-T1 extended abilities
  * @phydev: target phy_device struct
@@ -931,6 +933,184 @@ int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_fast_retrain);
 
+/**
+ * genphy_c45_plca_get_cfg - get PLCA configuration from standard registers
+ * @phydev: target phy_device struct
+ * @plca_cfg: output structure to store the PLCA configuration
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to retrieve
+ *   the current PLCA configuration from the standard registers in MMD 31.
+ */
+int genphy_c45_plca_get_cfg(struct phy_device *phydev,
+			    struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_IDVER);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->version = ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_CTRL0);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->enabled = !!(ret & MDIO_OATC14_PLCA_EN);
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->node_cnt = (ret & MDIO_OATC14_PLCA_NCNT) >> 8;
+	plca_cfg->node_id = (ret & MDIO_OATC14_PLCA_ID);
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_TOTMR);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->to_tmr = ret & MDIO_OATC14_PLCA_TOT;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_BURST);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->burst_cnt = (ret & MDIO_OATC14_PLCA_MAXBC) >> 8;
+	plca_cfg->burst_tmr = (ret & MDIO_OATC14_PLCA_BTMR);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_get_cfg);
+
+/**
+ * genphy_c45_plca_set_cfg - set PLCA configuration using standard registers
+ * @phydev: target phy_device struct
+ * @plca_cfg: structure containing the PLCA configuration. Fields set to -1 are
+ * not to be changed.
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to modify
+ *   the PLCA configuration using the standard registers in MMD 31.
+ */
+int genphy_c45_plca_set_cfg(struct phy_device *phydev,
+			    const struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+	u16 val;
+
+	// PLCA IDVER is read-only
+	if (plca_cfg->version >= 0)
+		return -EINVAL;
+
+	// first of all, disable PLCA if required
+	if (plca_cfg->enabled == 0) {
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_OATC14,
+					 MDIO_OATC14_PLCA_CTRL0,
+					 MDIO_OATC14_PLCA_EN);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->node_cnt >= 0 || plca_cfg->node_id >= 0) {
+		if (plca_cfg->node_cnt < 0 || plca_cfg->node_id < 0) {
+			ret = phy_read_mmd(phydev, MDIO_MMD_OATC14,
+					   MDIO_OATC14_PLCA_CTRL1);
+
+			if (ret < 0)
+				return ret;
+
+			val = ret;
+		}
+
+		if (plca_cfg->node_cnt >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_NCNT) |
+			      (plca_cfg->node_cnt << 8);
+
+		if (plca_cfg->node_id >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_ID) |
+			      (plca_cfg->node_id);
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_OATC14,
+				    MDIO_OATC14_PLCA_CTRL1, val);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->to_tmr >= 0) {
+		ret = phy_write_mmd(phydev, MDIO_MMD_OATC14,
+				    MDIO_OATC14_PLCA_TOTMR,
+				    plca_cfg->to_tmr);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->burst_cnt >= 0 || plca_cfg->burst_tmr >= 0) {
+		if (plca_cfg->burst_cnt < 0 || plca_cfg->burst_tmr < 0) {
+			ret = phy_read_mmd(phydev, MDIO_MMD_OATC14,
+					   MDIO_OATC14_PLCA_BURST);
+
+			if (ret < 0)
+				return ret;
+
+			val = ret;
+		}
+
+		if (plca_cfg->burst_cnt >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_MAXBC) |
+			      (plca_cfg->burst_cnt << 8);
+
+		if (plca_cfg->burst_tmr >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_BTMR) |
+			      (plca_cfg->burst_tmr);
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_OATC14,
+				    MDIO_OATC14_PLCA_BURST, val);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	// if we need to enable PLCA, do it at the end
+	if (plca_cfg->enabled > 0) {
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_OATC14,
+				       MDIO_OATC14_PLCA_CTRL0,
+				       MDIO_OATC14_PLCA_EN);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_set_cfg);
+
+/**
+ * genphy_c45_plca_get_status - get PLCA status from standard registers
+ * @phydev: target phy_device struct
+ * @plca_st: output structure to store the PLCA status
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to retrieve
+ *   the current PLCA status information from the standard registers in MMD 31.
+ */
+int genphy_c45_plca_get_status(struct phy_device *phydev,
+			       struct phy_plca_status *plca_st)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_OATC14, MDIO_OATC14_PLCA_STATUS);
+	if (ret < 0)
+		return ret;
+
+	plca_st->pst = !!(ret & MDIO_OATC14_PLCA_PST);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_get_status);
+
 struct phy_driver genphy_c45_driver = {
 	.phy_id         = 0xffffffff,
 	.phy_id_mask    = 0xffffffff,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 49d0488bf480..4548c8e8f6a9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1745,6 +1745,12 @@ int genphy_c45_loopback(struct phy_device *phydev, bool enable);
 int genphy_c45_pma_resume(struct phy_device *phydev);
 int genphy_c45_pma_suspend(struct phy_device *phydev);
 int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable);
+int genphy_c45_plca_get_cfg(struct phy_device *phydev,
+			    struct phy_plca_cfg *plca_cfg);
+int genphy_c45_plca_set_cfg(struct phy_device *phydev,
+			    const struct phy_plca_cfg *plca_cfg);
+int genphy_c45_plca_get_status(struct phy_device *phydev,
+			       struct phy_plca_status *plca_st);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
-- 
2.35.1

