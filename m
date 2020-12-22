Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32D32E103B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 23:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgLVW2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 17:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728408AbgLVW2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 17:28:08 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D24C0611CE
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:26:51 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id qw4so20250376ejb.12
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 14:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yul4iWdlmOk+Q5LRqiSaRQ0ORH0O37VYBFuSOLUHpg0=;
        b=bwQKxvdpO7GP07Q/xQLUMIfez5ykpIK7uM8jlRfVXubLkKudoZUhiCyATbu8R8zibZ
         znrR7OnBwHVo56Z51vkNLpPH9JtX5q/Hf0gNx5zr86Bu2eTD+iBOUu5NRVKfYAyCyNB0
         ZEnRttBLxOa+xPvYICU9NvhxMtkZag8hmPoRjegjhYiaUvryVNSSaMcicHNrp4GbwXII
         R5HolJ103yKURVFmhG8oa5yy17cHysg12FXHQYmWs/4b9baTTv27lYDFkg4TUjRotmxK
         c4IW6mW4t3egkDiM4gYpy/js3ufbNrWXUykHDsRiK3Pr7Q+EUEmzMu7dOHwp9p620G2u
         UKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yul4iWdlmOk+Q5LRqiSaRQ0ORH0O37VYBFuSOLUHpg0=;
        b=SoJ4o5w9CInRVb4ULCtIpTphzH8g//yjwDHuIKui/pjaOBMYsuczYvKcuXSaMmA7ZZ
         u/mS0/TuJGx5blM/y4emmjN39NSbDNoefQgqPRRBDNBI2fULB4c+lCkjtVQGE00egu0Q
         fjlJRdYJZxXOARjJ7J2+htpv8pxrRtiZOqbSathhVNupqg7hzFpTuer/NfjDewK69WEO
         YlEIDzzOw4ZwxDDGP/Xb3MyoIaqq1hufmqMKXCddbJHNcvd++vabOeRHIzF/GP4dHzYB
         oMrUFuOhMUHUKLLmMaD/kKu4Gjo965z0A9pLDYuYLKPIje1EaNPMQ7Gd4REQJa5VKm6c
         +Utg==
X-Gm-Message-State: AOAM530hadkAZEleSbyCFzHz6OB3Vbj/CFQ2EnUdY2Gt8hDUAIuuk02S
        5uF7peKyZh6j4k9wA64/sOADOw==
X-Google-Smtp-Source: ABdhPJwjX+rw3fKroM69lqAIcwPeFrfvsqUAfJPICGyVNucZknuFfL520heC7sJCZmD2xBJ/cFAfHg==
X-Received: by 2002:a17:906:d101:: with SMTP id b1mr2271636ejz.80.1608676009930;
        Tue, 22 Dec 2020 14:26:49 -0800 (PST)
Received: from localhost.localdomain (dh207-99-167.xnet.hr. [88.207.99.167])
        by smtp.googlemail.com with ESMTPSA id c23sm30515385eds.88.2020.12.22.14.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 14:26:49 -0800 (PST)
From:   Robert Marko <robert.marko@sartura.hr>
To:     agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk
Cc:     Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: [PATCH 3/4] net: phy: Add Qualcomm QCA807x driver
Date:   Tue, 22 Dec 2020 23:26:36 +0100
Message-Id: <20201222222637.3204929-4-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201222222637.3204929-1-robert.marko@sartura.hr>
References: <20201222222637.3204929-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds driver for the Qualcomm QCA8072 and QCA8075 PHY-s.

They are 2 or 5 port IEEE 802.3 clause 22 compliant
10BASE-Te, 100BASE-TX and 1000BASE-T PHY-s.

They feature 2 SerDes, one for PSGMII or QSGMII connection with MAC,
while second one is SGMII for connection to MAC or fiber.

Both models have a combo port that supports 1000BASE-X and 100BASE-FX
fiber.

Each PHY inside of QCA807x series has 2 digitally controlled output only
pins that natively drive LED-s.
But some vendors used these to driver generic LED-s controlled by
user space, so lets enable registering each PHY as GPIO controller and
add driver for it.

This also adds the ability to specify DT properties so that 1000 Base-T
LED will also be lit up for 100 and 10 Base connections.

This is usually done by U-boot, but boards running mainline U-boot are
not configuring this yet.

These PHY-s are commonly used in Qualcomm IPQ40xx, IPQ60xx and IPQ807x
boards.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Cc: Luka Perkov <luka.perkov@sartura.hr>
---
 drivers/net/phy/Kconfig   |  10 +
 drivers/net/phy/Makefile  |   1 +
 drivers/net/phy/qca807x.c | 811 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 822 insertions(+)
 create mode 100644 drivers/net/phy/qca807x.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 92164e7b7f60..1aaeca3f133c 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -264,6 +264,16 @@ config QSEMI_PHY
 	help
 	  Currently supports the qs6612
 
+config QCA807X_PHY
+	tristate "Qualcomm QCA807X PHYs"
+	depends on OF_MDIO
+	help
+	  Adds support for the Qualcomm QCA807x PHYs.
+	  These are 802.3 Clause 22 compliant PHYs supporting gigabit
+	  ethernet as well as 100Base-FX and 1000Base-X fibre.
+
+	  Currently supports the QCA8072 and QCA8075 models.
+
 config REALTEK_PHY
 	tristate "Realtek PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index ca0a313423b9..5f463ce0f711 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
 obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
+obj-$(CONFIG_QCA807X_PHY)		+= qca807x.o
 obj-$(CONFIG_REALTEK_PHY)	+= realtek.o
 obj-$(CONFIG_RENESAS_PHY)	+= uPD60620.o
 obj-$(CONFIG_ROCKCHIP_PHY)	+= rockchip.o
diff --git a/drivers/net/phy/qca807x.c b/drivers/net/phy/qca807x.c
new file mode 100644
index 000000000000..db082d2aa560
--- /dev/null
+++ b/drivers/net/phy/qca807x.c
@@ -0,0 +1,811 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020 Sartura Ltd.
+ *
+ * Author: Robert Marko <robert.marko@sartura.hr>
+ *
+ * Qualcomm QCA8072 and QCA8075 PHY driver
+ */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/phy.h>
+#include <linux/bitfield.h>
+#include <linux/ethtool_netlink.h>
+#include <linux/gpio.h>
+#include <linux/sfp.h>
+
+#include <dt-bindings/net/qcom-qca807x.h>
+
+#define PHY_ID_QCA8072		0x004dd0b2
+#define PHY_ID_QCA8075		0x004dd0b1
+#define PHY_ID_QCA807X_PSGMII	0x06820805
+
+/* Downshift */
+#define QCA807X_SMARTSPEED_EN			BIT(5)
+#define QCA807X_SMARTSPEED_RETRY_LIMIT_MASK	GENMASK(4, 2)
+#define QCA807X_SMARTSPEED_RETRY_LIMIT_DEFAULT	5
+#define QCA807X_SMARTSPEED_RETRY_LIMIT_MIN	2
+#define QCA807X_SMARTSPEED_RETRY_LIMIT_MAX	9
+
+/* Cable diagnostic test (CDT) */
+#define QCA807X_CDT						0x16
+#define QCA807X_CDT_ENABLE					BIT(15)
+#define QCA807X_CDT_ENABLE_INTER_PAIR_SHORT			BIT(13)
+#define QCA807X_CDT_STATUS					BIT(11)
+#define QCA807X_CDT_MMD3_STATUS					0x8064
+#define QCA807X_CDT_MDI0_STATUS_MASK				GENMASK(15, 12)
+#define QCA807X_CDT_MDI1_STATUS_MASK				GENMASK(11, 8)
+#define QCA807X_CDT_MDI2_STATUS_MASK				GENMASK(7, 4)
+#define QCA807X_CDT_MDI3_STATUS_MASK				GENMASK(3, 0)
+#define QCA807X_CDT_RESULTS_INVALID				0x0
+#define QCA807X_CDT_RESULTS_OK					0x1
+#define QCA807X_CDT_RESULTS_OPEN				0x2
+#define QCA807X_CDT_RESULTS_SAME_SHORT				0x3
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OK	0x4
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OK	0x8
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OK	0xc
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OPEN	0x6
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OPEN	0xa
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OPEN	0xe
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_SHORT	0x7
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_SHORT	0xb
+#define QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_SHORT	0xf
+#define QCA807X_CDT_RESULTS_BUSY				0x9
+#define QCA807X_CDT_MMD3_MDI0_LENGTH				0x8065
+#define QCA807X_CDT_MMD3_MDI1_LENGTH				0x8066
+#define QCA807X_CDT_MMD3_MDI2_LENGTH				0x8067
+#define QCA807X_CDT_MMD3_MDI3_LENGTH				0x8068
+#define QCA807X_CDT_SAME_SHORT_LENGTH_MASK			GENMASK(15, 8)
+#define QCA807X_CDT_CROSS_SHORT_LENGTH_MASK			GENMASK(7, 0)
+
+#define QCA807X_CHIP_CONFIGURATION				0x1f
+#define QCA807X_BT_BX_REG_SEL					BIT(15)
+#define QCA807X_CHIP_CONFIGURATION_MODE_CFG_MASK		GENMASK(3, 0)
+#define QCA807X_CHIP_CONFIGURATION_MODE_QSGMII_SGMII		4
+#define QCA807X_CHIP_CONFIGURATION_MODE_PSGMII_FIBER		3
+#define QCA807X_CHIP_CONFIGURATION_MODE_PSGMII_ALL_COPPER	0
+
+#define QCA807X_MEDIA_SELECT_STATUS				0x1a
+#define QCA807X_MEDIA_DETECTED_COPPER				BIT(5)
+#define QCA807X_MEDIA_DETECTED_1000_BASE_X			BIT(4)
+#define QCA807X_MEDIA_DETECTED_100_BASE_FX			BIT(3)
+
+#define QCA807X_MMD7_FIBER_MODE_AUTO_DETECTION			0x807e
+#define QCA807X_MMD7_FIBER_MODE_AUTO_DETECTION_EN		BIT(0)
+
+#define QCA807X_MMD7_1000BASE_T_POWER_SAVE_PER_CABLE_LENGTH	0x801a
+#define QCA807X_CONTROL_DAC_MASK				GENMASK(2, 0)
+
+#define QCA807X_MMD7_LED_100N_1				0x8074
+#define QCA807X_MMD7_LED_100N_2				0x8075
+#define QCA807X_MMD7_LED_1000N_1			0x8076
+#define QCA807X_MMD7_LED_1000N_2			0x8077
+#define QCA807X_LED_TXACT_BLK_EN_2			BIT(10)
+#define QCA807X_LED_RXACT_BLK_EN_2			BIT(9)
+#define QCA807X_LED_GT_ON_EN_2				BIT(6)
+#define QCA807X_LED_HT_ON_EN_2				BIT(5)
+#define QCA807X_LED_BT_ON_EN_2				BIT(4)
+#define QCA807X_GPIO_FORCE_EN				BIT(15)
+#define QCA807X_GPIO_FORCE_MODE_MASK			GENMASK(14, 13)
+
+#define QCA807X_INTR_ENABLE				0x12
+#define QCA807X_INTR_STATUS				0x13
+#define QCA807X_INTR_ENABLE_AUTONEG_ERR			BIT(15)
+#define QCA807X_INTR_ENABLE_SPEED_CHANGED		BIT(14)
+#define QCA807X_INTR_ENABLE_DUPLEX_CHANGED		BIT(13)
+#define QCA807X_INTR_ENABLE_LINK_FAIL			BIT(11)
+#define QCA807X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
+
+#define QCA807X_FUNCTION_CONTROL			0x10
+#define QCA807X_FC_MDI_CROSSOVER_MODE_MASK		GENMASK(6, 5)
+#define QCA807X_FC_MDI_CROSSOVER_AUTO			3
+#define QCA807X_FC_MDI_CROSSOVER_MANUAL_MDIX		1
+#define QCA807X_FC_MDI_CROSSOVER_MANUAL_MDI		0
+
+#define QCA807X_PHY_SPECIFIC_STATUS			0x11
+#define QCA807X_SS_SPEED_AND_DUPLEX_RESOLVED		BIT(11)
+#define QCA807X_SS_SPEED_MASK				GENMASK(15, 14)
+#define QCA807X_SS_SPEED_1000				2
+#define QCA807X_SS_SPEED_100				1
+#define QCA807X_SS_SPEED_10				0
+#define QCA807X_SS_DUPLEX				BIT(13)
+#define QCA807X_SS_MDIX					BIT(6)
+
+/* PSGMII PHY specific */
+#define PSGMII_QSGMII_DRIVE_CONTROL_1			0xb
+#define PSGMII_QSGMII_TX_DRIVER_MASK			GENMASK(7, 4)
+#define PSGMII_MODE_CTRL				0x6d
+#define PSGMII_MODE_CTRL_AZ_WORKAROUND_MASK		GENMASK(3, 0)
+#define PSGMII_MMD3_SERDES_CONTROL			0x805a
+
+struct qca807x_gpio_priv {
+	struct phy_device *phy;
+};
+
+static int qca807x_get_downshift(struct phy_device *phydev, u8 *data)
+{
+	int val, cnt, enable;
+
+	val = phy_read(phydev, MII_NWAYTEST);
+	if (val < 0)
+		return val;
+
+	enable = FIELD_GET(QCA807X_SMARTSPEED_EN, val);
+	cnt = FIELD_GET(QCA807X_SMARTSPEED_RETRY_LIMIT_MASK, val) + 2;
+
+	*data = enable ? cnt : DOWNSHIFT_DEV_DISABLE;
+
+	return 0;
+}
+
+static int qca807x_set_downshift(struct phy_device *phydev, u8 cnt)
+{
+	int ret, val;
+
+	if (cnt > QCA807X_SMARTSPEED_RETRY_LIMIT_MAX ||
+	    (cnt < QCA807X_SMARTSPEED_RETRY_LIMIT_MIN && cnt != DOWNSHIFT_DEV_DISABLE))
+		return -EINVAL;
+
+	if (!cnt) {
+		ret = phy_clear_bits(phydev, MII_NWAYTEST, QCA807X_SMARTSPEED_EN);
+	} else {
+		val = QCA807X_SMARTSPEED_EN;
+		val |= FIELD_PREP(QCA807X_SMARTSPEED_RETRY_LIMIT_MASK, cnt - 2);
+
+		phy_modify(phydev, MII_NWAYTEST,
+			   QCA807X_SMARTSPEED_EN |
+			   QCA807X_SMARTSPEED_RETRY_LIMIT_MASK,
+			   val);
+	}
+
+	ret = genphy_soft_reset(phydev);
+
+	return ret;
+}
+
+static int qca807x_get_tunable(struct phy_device *phydev,
+			       struct ethtool_tunable *tuna, void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return qca807x_get_downshift(phydev, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int qca807x_set_tunable(struct phy_device *phydev,
+			       struct ethtool_tunable *tuna, const void *data)
+{
+	switch (tuna->id) {
+	case ETHTOOL_PHY_DOWNSHIFT:
+		return qca807x_set_downshift(phydev, *(const u8 *)data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static bool qca807x_distance_valid(int result)
+{
+	switch (result) {
+	case QCA807X_CDT_RESULTS_OPEN:
+	case QCA807X_CDT_RESULTS_SAME_SHORT:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OK:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OK:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OK:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OPEN:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OPEN:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OPEN:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_SHORT:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_SHORT:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_SHORT:
+		return true;
+	}
+	return false;
+}
+
+static int qca807x_report_length(struct phy_device *phydev,
+				 int pair, int result)
+{
+	int length;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, QCA807X_CDT_MMD3_MDI0_LENGTH + pair);
+	if (ret < 0)
+		return ret;
+
+	switch (result) {
+	case ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT:
+		length = (FIELD_GET(QCA807X_CDT_SAME_SHORT_LENGTH_MASK, ret) * 800) / 10;
+		break;
+	case ETHTOOL_A_CABLE_RESULT_CODE_OPEN:
+	case ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT:
+		length = (FIELD_GET(QCA807X_CDT_CROSS_SHORT_LENGTH_MASK, ret) * 800) / 10;
+		break;
+	}
+
+	ethnl_cable_test_fault_length(phydev, pair, length);
+
+	return 0;
+}
+
+static int qca807x_cable_test_report_trans(int result)
+{
+	switch (result) {
+	case QCA807X_CDT_RESULTS_OK:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
+	case QCA807X_CDT_RESULTS_OPEN:
+		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
+	case QCA807X_CDT_RESULTS_SAME_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OK:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OK:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OK:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_OPEN:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_OPEN:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_OPEN:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI1_SAME_SHORT:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI2_SAME_SHORT:
+	case QCA807X_CDT_RESULTS_CROSS_SHORT_WITH_MDI3_SAME_SHORT:
+		return ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT;
+	default:
+		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
+	}
+}
+
+static int qca807x_cable_test_report(struct phy_device *phydev)
+{
+	int pair0, pair1, pair2, pair3;
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PCS, QCA807X_CDT_MMD3_STATUS);
+	if (ret < 0)
+		return ret;
+
+	pair0 = FIELD_GET(QCA807X_CDT_MDI0_STATUS_MASK, ret);
+	pair1 = FIELD_GET(QCA807X_CDT_MDI1_STATUS_MASK, ret);
+	pair2 = FIELD_GET(QCA807X_CDT_MDI2_STATUS_MASK, ret);
+	pair3 = FIELD_GET(QCA807X_CDT_MDI3_STATUS_MASK, ret);
+
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
+				qca807x_cable_test_report_trans(pair0));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_B,
+				qca807x_cable_test_report_trans(pair1));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_C,
+				qca807x_cable_test_report_trans(pair2));
+	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_D,
+				qca807x_cable_test_report_trans(pair3));
+
+	if (qca807x_distance_valid(pair0))
+		qca807x_report_length(phydev, 0, qca807x_cable_test_report_trans(pair0));
+	if (qca807x_distance_valid(pair1))
+		qca807x_report_length(phydev, 1, qca807x_cable_test_report_trans(pair1));
+	if (qca807x_distance_valid(pair2))
+		qca807x_report_length(phydev, 2, qca807x_cable_test_report_trans(pair2));
+	if (qca807x_distance_valid(pair3))
+		qca807x_report_length(phydev, 3, qca807x_cable_test_report_trans(pair3));
+
+	return 0;
+}
+
+static int qca807x_cable_test_get_status(struct phy_device *phydev,
+					 bool *finished)
+{
+	int val;
+
+	*finished = false;
+
+	val = phy_read(phydev, QCA807X_CDT);
+	if (!((val & QCA807X_CDT_ENABLE) && (val & QCA807X_CDT_STATUS))) {
+		*finished = true;
+
+		return qca807x_cable_test_report(phydev);
+	}
+
+	return 0;
+}
+
+static int qca807x_cable_test_start(struct phy_device *phydev)
+{
+	int val, ret;
+
+	val = phy_read(phydev, QCA807X_CDT);
+	/* Enable inter-pair short check as well */
+	val &= ~QCA807X_CDT_ENABLE_INTER_PAIR_SHORT;
+	val |= QCA807X_CDT_ENABLE;
+	ret = phy_write(phydev, QCA807X_CDT, val);
+
+	return ret;
+}
+
+#ifdef CONFIG_GPIOLIB
+static int qca807x_gpio_get_direction(struct gpio_chip *gc, unsigned int offset)
+{
+	return GPIO_LINE_DIRECTION_OUT;
+}
+
+static int qca807x_gpio_get_reg(unsigned int offset)
+{
+	return QCA807X_MMD7_LED_100N_2 + (offset % 2) * 2;
+}
+
+static int qca807x_gpio_get(struct gpio_chip *gc, unsigned int offset)
+{
+	struct qca807x_gpio_priv *priv = gpiochip_get_data(gc);
+	int val;
+
+	val = phy_read_mmd(priv->phy, MDIO_MMD_AN, qca807x_gpio_get_reg(offset));
+
+	return FIELD_GET(QCA807X_GPIO_FORCE_MODE_MASK, val);
+}
+
+static void qca807x_gpio_set(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	struct qca807x_gpio_priv *priv = gpiochip_get_data(gc);
+	int val;
+
+	val = phy_read_mmd(priv->phy, MDIO_MMD_AN, qca807x_gpio_get_reg(offset));
+	val &= ~QCA807X_GPIO_FORCE_MODE_MASK;
+	val |= FIELD_PREP(QCA807X_GPIO_FORCE_MODE_MASK, value);
+
+	phy_write_mmd(priv->phy, MDIO_MMD_AN, qca807x_gpio_get_reg(offset), val);
+}
+
+static int qca807x_gpio_dir_out(struct gpio_chip *gc, unsigned int offset, int value)
+{
+	qca807x_gpio_set(gc, offset, value);
+
+	return 0;
+}
+
+static int qca807x_gpio(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct qca807x_gpio_priv *priv;
+	struct gpio_chip *gc;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->phy = phydev;
+
+	gc = devm_kzalloc(dev, sizeof(*gc), GFP_KERNEL);
+	if (!gc)
+		return -ENOMEM;
+
+	gc->label = dev_name(dev);
+	gc->base = -1;
+	gc->ngpio = 2;
+	gc->parent = dev;
+	gc->owner = THIS_MODULE;
+	gc->can_sleep = true;
+	gc->get_direction = qca807x_gpio_get_direction;
+	gc->direction_output = qca807x_gpio_dir_out;
+	gc->get = qca807x_gpio_get;
+	gc->set = qca807x_gpio_set;
+
+	return devm_gpiochip_add_data(dev, gc, priv);
+}
+#endif
+
+static int qca807x_read_copper_status(struct phy_device *phydev, bool combo_port)
+{
+	int ss, err, page, old_link = phydev->link;
+
+	/* Only combo port has dual pages */
+	if (combo_port) {
+		/* Check whether copper page is set and set if needed */
+		page = phy_read(phydev, QCA807X_CHIP_CONFIGURATION);
+		if (!(page & QCA807X_BT_BX_REG_SEL)) {
+			page |= QCA807X_BT_BX_REG_SEL;
+			phy_write(phydev, QCA807X_CHIP_CONFIGURATION, page);
+		}
+	}
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	err = genphy_read_lpa(phydev);
+	if (err < 0)
+		return err;
+
+	/* Read the QCA807x PHY-Specific Status register copper page,
+	 * which indicates the speed and duplex that the PHY is actually
+	 * using, irrespective of whether we are in autoneg mode or not.
+	 */
+	ss = phy_read(phydev, QCA807X_PHY_SPECIFIC_STATUS);
+	if (ss < 0)
+		return ss;
+
+	if (ss & QCA807X_SS_SPEED_AND_DUPLEX_RESOLVED) {
+		int sfc;
+
+		sfc = phy_read(phydev, QCA807X_FUNCTION_CONTROL);
+		if (sfc < 0)
+			return sfc;
+
+		switch (FIELD_GET(QCA807X_SS_SPEED_MASK, ss)) {
+		case QCA807X_SS_SPEED_10:
+			phydev->speed = SPEED_10;
+			break;
+		case QCA807X_SS_SPEED_100:
+			phydev->speed = SPEED_100;
+			break;
+		case QCA807X_SS_SPEED_1000:
+			phydev->speed = SPEED_1000;
+			break;
+		}
+		if (ss & QCA807X_SS_DUPLEX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+
+		if (ss & QCA807X_SS_MDIX)
+			phydev->mdix = ETH_TP_MDI_X;
+		else
+			phydev->mdix = ETH_TP_MDI;
+
+		switch (FIELD_GET(QCA807X_FC_MDI_CROSSOVER_MODE_MASK, sfc)) {
+		case QCA807X_FC_MDI_CROSSOVER_MANUAL_MDI:
+			phydev->mdix_ctrl = ETH_TP_MDI;
+			break;
+		case QCA807X_FC_MDI_CROSSOVER_MANUAL_MDIX:
+			phydev->mdix_ctrl = ETH_TP_MDI_X;
+			break;
+		case QCA807X_FC_MDI_CROSSOVER_AUTO:
+			phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
+			break;
+		}
+	}
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete)
+		phy_resolve_aneg_pause(phydev);
+
+	return 0;
+}
+
+static int qca807x_read_fiber_status(struct phy_device *phydev, bool combo_port)
+{
+	int ss, err, page, lpa, old_link = phydev->link;
+
+	/* Check whether fiber page is set and set if needed */
+	page = phy_read(phydev, QCA807X_CHIP_CONFIGURATION);
+	if (page & QCA807X_BT_BX_REG_SEL) {
+		page &= ~QCA807X_BT_BX_REG_SEL;
+		phy_write(phydev, QCA807X_CHIP_CONFIGURATION, page);
+	}
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
+		lpa = phy_read(phydev, MII_LPA);
+		if (lpa < 0)
+			return lpa;
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				 phydev->lp_advertising, lpa & LPA_LPACK);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				 phydev->lp_advertising, lpa & LPA_1000XFULL);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				 phydev->lp_advertising, lpa & LPA_1000XPAUSE);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				 phydev->lp_advertising,
+				 lpa & LPA_1000XPAUSE_ASYM);
+
+		phy_resolve_aneg_linkmode(phydev);
+	}
+
+	/* Read the QCA807x PHY-Specific Status register fiber page,
+	 * which indicates the speed and duplex that the PHY is actually
+	 * using, irrespective of whether we are in autoneg mode or not.
+	 */
+	ss = phy_read(phydev, QCA807X_PHY_SPECIFIC_STATUS);
+	if (ss < 0)
+		return ss;
+
+	if (ss & QCA807X_SS_SPEED_AND_DUPLEX_RESOLVED) {
+		switch (FIELD_GET(QCA807X_SS_SPEED_MASK, ss)) {
+		case QCA807X_SS_SPEED_100:
+			phydev->speed = SPEED_100;
+			break;
+		case QCA807X_SS_SPEED_1000:
+			phydev->speed = SPEED_1000;
+			break;
+		}
+
+		if (ss & QCA807X_SS_DUPLEX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+	}
+
+	return 0;
+}
+
+static int qca807x_read_status(struct phy_device *phydev)
+{
+	int val;
+
+	/* Check for Combo port */
+	if (phy_read(phydev, QCA807X_CHIP_CONFIGURATION)) {
+		/* Check for fiber mode first */
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported)) {
+			/* Check for actual detected media */
+			val = phy_read(phydev, QCA807X_MEDIA_SELECT_STATUS);
+			if (val & QCA807X_MEDIA_DETECTED_COPPER) {
+				qca807x_read_copper_status(phydev, true);
+			} else if ((val & QCA807X_MEDIA_DETECTED_1000_BASE_X) ||
+				   (val & QCA807X_MEDIA_DETECTED_100_BASE_FX)) {
+				qca807x_read_fiber_status(phydev, true);
+			}
+		} else {
+			qca807x_read_copper_status(phydev, true);
+		}
+	} else {
+		qca807x_read_copper_status(phydev, false);
+	}
+
+	return 0;
+}
+
+static int qca807x_config_intr(struct phy_device *phydev)
+{
+	int ret, val;
+
+	val = phy_read(phydev, QCA807X_INTR_ENABLE);
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
+		/* Check for combo port as it has fewer interrupts */
+		if (phy_read(phydev, QCA807X_CHIP_CONFIGURATION)) {
+			val |= QCA807X_INTR_ENABLE_SPEED_CHANGED;
+			val |= QCA807X_INTR_ENABLE_LINK_FAIL;
+			val |= QCA807X_INTR_ENABLE_LINK_SUCCESS;
+		} else {
+			val |= QCA807X_INTR_ENABLE_AUTONEG_ERR;
+			val |= QCA807X_INTR_ENABLE_SPEED_CHANGED;
+			val |= QCA807X_INTR_ENABLE_DUPLEX_CHANGED;
+			val |= QCA807X_INTR_ENABLE_LINK_FAIL;
+			val |= QCA807X_INTR_ENABLE_LINK_SUCCESS;
+		}
+		ret = phy_write(phydev, QCA807X_INTR_ENABLE, val);
+	} else {
+		ret = phy_write(phydev, QCA807X_INTR_ENABLE, 0);
+	}
+
+	return ret;
+}
+
+static int qca807x_ack_intr(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = phy_read(phydev, QCA807X_INTR_STATUS);
+
+	return (ret < 0) ? ret : 0;
+}
+
+static int qca807x_led_config(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	bool led_config = false;
+	int val;
+
+	val = phy_read_mmd(phydev, MDIO_MMD_AN, QCA807X_MMD7_LED_1000N_1);
+	if (val < 0)
+		return val;
+
+	if (of_property_read_bool(node, "qcom,single-led-1000")) {
+		val |= QCA807X_LED_TXACT_BLK_EN_2;
+		val |= QCA807X_LED_RXACT_BLK_EN_2;
+		val |= QCA807X_LED_GT_ON_EN_2;
+
+		led_config = true;
+	}
+
+	if (of_property_read_bool(node, "qcom,single-led-100")) {
+		val |= QCA807X_LED_HT_ON_EN_2;
+
+		led_config = true;
+	}
+
+	if (of_property_read_bool(node, "qcom,single-led-10")) {
+		val |= QCA807X_LED_BT_ON_EN_2;
+
+		led_config = true;
+	}
+
+	if (led_config)
+		return phy_write_mmd(phydev, MDIO_MMD_AN, QCA807X_MMD7_LED_1000N_1, val);
+	else
+		return 0;
+}
+
+static const struct sfp_upstream_ops qca807x_sfp_ops = {
+	.attach = phy_sfp_attach,
+	.detach = phy_sfp_detach,
+};
+
+static int qca807x_config(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	int control_dac, ret = 0;
+	u32 of_control_dac;
+
+	/* Check for Combo port */
+	if (phy_read(phydev, QCA807X_CHIP_CONFIGURATION)) {
+		int fiber_mode_autodect;
+		int psgmii_serdes;
+		int chip_config;
+
+		if (of_property_read_bool(node, "qcom,fiber-enable")) {
+			/* Enable fiber mode autodection (1000Base-X or 100Base-FX) */
+			fiber_mode_autodect = phy_read_mmd(phydev, MDIO_MMD_AN,
+							   QCA807X_MMD7_FIBER_MODE_AUTO_DETECTION);
+			fiber_mode_autodect |= QCA807X_MMD7_FIBER_MODE_AUTO_DETECTION_EN;
+			phy_write_mmd(phydev, MDIO_MMD_AN, QCA807X_MMD7_FIBER_MODE_AUTO_DETECTION,
+				      fiber_mode_autodect);
+
+			/* Enable 4 copper + combo port mode */
+			chip_config = phy_read(phydev, QCA807X_CHIP_CONFIGURATION);
+			chip_config &= ~QCA807X_CHIP_CONFIGURATION_MODE_CFG_MASK;
+			chip_config |= FIELD_PREP(QCA807X_CHIP_CONFIGURATION_MODE_CFG_MASK,
+						  QCA807X_CHIP_CONFIGURATION_MODE_PSGMII_FIBER);
+			phy_write(phydev, QCA807X_CHIP_CONFIGURATION, chip_config);
+
+			linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->supported);
+			linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, phydev->advertising);
+		}
+
+		/* Prevent PSGMII going into hibernation via PSGMII self test */
+		psgmii_serdes = phy_read_mmd(phydev, MDIO_MMD_PCS, PSGMII_MMD3_SERDES_CONTROL);
+		psgmii_serdes &= ~BIT(1);
+		ret = phy_write_mmd(phydev, MDIO_MMD_PCS,
+				    PSGMII_MMD3_SERDES_CONTROL,
+				    psgmii_serdes);
+	}
+
+	if (!of_property_read_u32(node, "qcom,control-dac", &of_control_dac)) {
+		control_dac = phy_read_mmd(phydev, MDIO_MMD_AN,
+					   QCA807X_MMD7_1000BASE_T_POWER_SAVE_PER_CABLE_LENGTH);
+		control_dac &= ~QCA807X_CONTROL_DAC_MASK;
+		control_dac |= FIELD_PREP(QCA807X_CONTROL_DAC_MASK, of_control_dac);
+		ret = phy_write_mmd(phydev, MDIO_MMD_AN,
+				    QCA807X_MMD7_1000BASE_T_POWER_SAVE_PER_CABLE_LENGTH,
+				    control_dac);
+	}
+
+	/* Optionally configure LED-s */
+	if (IS_ENABLED(CONFIG_GPIOLIB)) {
+		/* Check whether PHY-s pins are used as GPIO-s */
+		if (!of_property_read_bool(node, "gpio-controller"))
+			ret = qca807x_led_config(phydev);
+	} else {
+		ret = qca807x_led_config(phydev);
+	}
+
+	return ret;
+}
+
+static int qca807x_probe(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	int ret = 0;
+
+	if (IS_ENABLED(CONFIG_GPIOLIB)) {
+		/* Do not register a GPIO controller unless flagged for it */
+		if (of_property_read_bool(node, "gpio-controller"))
+			ret = qca807x_gpio(phydev);
+	}
+
+	/* Attach SFP bus on combo port*/
+	if (of_property_read_bool(node, "qcom,fiber-enable")) {
+		if (phy_read(phydev, QCA807X_CHIP_CONFIGURATION))
+			ret = phy_sfp_probe(phydev, &qca807x_sfp_ops);
+	}
+
+	return ret;
+}
+
+static int qca807x_psgmii_config(struct phy_device *phydev)
+{
+	struct device_node *node = phydev->mdio.dev.of_node;
+	int psgmii_az, tx_amp, ret = 0;
+	u32 tx_driver_strength;
+
+	/* Workaround to enable AZ transmitting ability */
+	if (of_property_read_bool(node, "qcom,psgmii-az")) {
+		psgmii_az = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, PSGMII_MODE_CTRL);
+		psgmii_az &= ~PSGMII_MODE_CTRL_AZ_WORKAROUND_MASK;
+		psgmii_az |= FIELD_PREP(PSGMII_MODE_CTRL_AZ_WORKAROUND_MASK, 0xc);
+		ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, PSGMII_MODE_CTRL, psgmii_az);
+		psgmii_az = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, PSGMII_MODE_CTRL);
+	}
+
+	/* PSGMII/QSGMII TX amp set to DT defined value instead of default 600mV */
+	if (!of_property_read_u32(node, "qcom,tx-driver-strength", &tx_driver_strength)) {
+		tx_amp = phy_read(phydev, PSGMII_QSGMII_DRIVE_CONTROL_1);
+		tx_amp &= ~PSGMII_QSGMII_TX_DRIVER_MASK;
+		tx_amp |= FIELD_PREP(PSGMII_QSGMII_TX_DRIVER_MASK, tx_driver_strength);
+		ret = phy_write(phydev, PSGMII_QSGMII_DRIVE_CONTROL_1, tx_amp);
+	}
+
+	return ret;
+}
+
+static struct phy_driver qca807x_drivers[] = {
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_QCA8072),
+		.name           = "Qualcomm QCA8072",
+		.flags		= PHY_POLL_CABLE_TEST,
+		/* PHY_GBIT_FEATURES */
+		.probe		= qca807x_probe,
+		.config_init	= qca807x_config,
+		.read_status	= qca807x_read_status,
+		.config_intr	= qca807x_config_intr,
+		.ack_interrupt	= qca807x_ack_intr,
+		.soft_reset	= genphy_soft_reset,
+		.get_tunable	= qca807x_get_tunable,
+		.set_tunable	= qca807x_set_tunable,
+		.cable_test_start	= qca807x_cable_test_start,
+		.cable_test_get_status	= qca807x_cable_test_get_status,
+	},
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_QCA8075),
+		.name           = "Qualcomm QCA8075",
+		.flags		= PHY_POLL_CABLE_TEST,
+		/* PHY_GBIT_FEATURES */
+		.probe		= qca807x_probe,
+		.config_init	= qca807x_config,
+		.read_status	= qca807x_read_status,
+		.config_intr	= qca807x_config_intr,
+		.ack_interrupt	= qca807x_ack_intr,
+		.soft_reset	= genphy_soft_reset,
+		.get_tunable	= qca807x_get_tunable,
+		.set_tunable	= qca807x_set_tunable,
+		.cable_test_start	= qca807x_cable_test_start,
+		.cable_test_get_status	= qca807x_cable_test_get_status,
+	},
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_QCA807X_PSGMII),
+		.name           = "Qualcomm QCA807x PSGMII",
+		.probe		= qca807x_psgmii_config,
+	},
+};
+module_phy_driver(qca807x_drivers);
+
+static struct mdio_device_id __maybe_unused qca807x_tbl[] = {
+	{ PHY_ID_MATCH_EXACT(PHY_ID_QCA8072) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_QCA8075) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_QCA807X_PSGMII) },
+	{ }
+};
+
+MODULE_AUTHOR("Robert Marko");
+MODULE_DESCRIPTION("Qualcomm QCA807x PHY driver");
+MODULE_DEVICE_TABLE(mdio, qca807x_tbl);
+MODULE_LICENSE("GPL");
-- 
2.29.2

