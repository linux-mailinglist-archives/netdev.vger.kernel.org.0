Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E739017DB11
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgCIIgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:36:50 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42464 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbgCIIgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:36:46 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 093CDC04C8;
        Mon,  9 Mar 2020 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583743004; bh=wCkpwUsr1txZbaQbk2Lpghyt55FHFR6JaG80XnkhLo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=aHgt1gtIXNTWO9e9vJZgJ7AOCAIJbkIrKK2sNxsCd8BZhJ56uWxEN4g/mVYAS11CV
         zYqr5JWpVxcrfjHaf0Ao8jVVfKbFOgaoUMx+jZvZUIbOmH7azzydM2C4XkunHMlX+c
         wESDHI1RiFlck6aY0gp9Ane6CLeG2EK0KiU95qD+V0iDui4MK74xreGPRWqtFovAc0
         CoRTUvTvCrGze0JXgrzwddUDZEi/rJIlEYhXSryJ7mg+3QroqHdxGP+XVUekAK55iA
         IvzRh2rG5/mLmZuPWUEXvVFlkHuR8jyrF6js4NNo21duHEesQtZJ5U8UASRro5LiQL
         MK8E1IclFmVBg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7AF2DA0079;
        Mon,  9 Mar 2020 08:36:41 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: phy: Add Synopsys DesignWare XPCS MDIO module
Date:   Mon,  9 Mar 2020 09:36:26 +0100
Message-Id: <7d9880643585e4347027538df2a722dde54156cf.1583742616.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synopsys DesignWare XPCS is an MMD that can manage link status,
auto-negotiation, link training, ...

In this commit we add basic support for XPCS using USXGMII interface and
Clause 73 Auto-negotiation.

This is highly tied with PHYLINK and can't be used without it. A given
ethernet driver can use the provided callbacks to add the support for
XPCS.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 MAINTAINERS                 |   7 +
 drivers/net/phy/Kconfig     |   6 +
 drivers/net/phy/Makefile    |   1 +
 drivers/net/phy/mdio-xpcs.c | 612 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio-xpcs.h   |  41 +++
 5 files changed, 667 insertions(+)
 create mode 100644 drivers/net/phy/mdio-xpcs.c
 create mode 100644 include/linux/mdio-xpcs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ec6a539fa42..47f594df18cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16111,6 +16111,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/synopsys/
 
+SYNOPSYS DESIGNWARE ETHERNET XPCS DRIVER
+M:	Jose Abreu <Jose.Abreu@synopsys.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	drivers/net/phy/mdio-xpcs.c
+F:	include/linux/mdio-xpcs.h
+
 SYNOPSYS DESIGNWARE I2C DRIVER
 M:	Jarkko Nikula <jarkko.nikula@linux.intel.com>
 R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index d6f197e06134..cc7f1df855da 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -214,6 +214,12 @@ config MDIO_XGENE
 	  This module provides a driver for the MDIO busses found in the
 	  APM X-Gene SoC's.
 
+config MDIO_XPCS
+	tristate "Synopsys DesignWare XPCS controller"
+	help
+	  This module provides helper functions for Synopsys DesignWare XPCS
+	  controllers.
+
 endif
 endif
 
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index d9b3c0fec8e3..26f8039f300f 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
 obj-$(CONFIG_MDIO_SUN4I)	+= mdio-sun4i.o
 obj-$(CONFIG_MDIO_THUNDER)	+= mdio-thunder.o
 obj-$(CONFIG_MDIO_XGENE)	+= mdio-xgene.o
+obj-$(CONFIG_MDIO_XPCS)		+= mdio-xpcs.o
 
 obj-$(CONFIG_NETWORK_PHY_TIMESTAMPING) += mii_timestamper.o
 
diff --git a/drivers/net/phy/mdio-xpcs.c b/drivers/net/phy/mdio-xpcs.c
new file mode 100644
index 000000000000..973f588146f7
--- /dev/null
+++ b/drivers/net/phy/mdio-xpcs.c
@@ -0,0 +1,612 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Synopsys, Inc. and/or its affiliates.
+ * Synopsys DesignWare XPCS helpers
+ *
+ * Author: Jose Abreu <Jose.Abreu@synopsys.com>
+ */
+
+#include <linux/delay.h>
+#include <linux/mdio.h>
+#include <linux/mdio-xpcs.h>
+#include <linux/phylink.h>
+#include <linux/workqueue.h>
+
+#define SYNOPSYS_XPCS_USXGMII_ID	0x7996ced0
+#define SYNOPSYS_XPCS_10GKR_ID		0x7996ced0
+#define SYNOPSYS_XPCS_MASK		0xffffffff
+
+/* Vendor regs access */
+#define DW_VENDOR			BIT(15)
+
+/* VR_XS_PCS */
+#define DW_USXGMII_RST			BIT(10)
+#define DW_USXGMII_EN			BIT(9)
+#define DW_VR_XS_PCS_DIG_STS		0x0010
+#define DW_RXFIFO_ERR			GENMASK(6, 5)
+
+/* SR_MII */
+#define DW_USXGMII_FULL			BIT(8)
+#define DW_USXGMII_SS_MASK		(BIT(13) | BIT(6) | BIT(5))
+#define DW_USXGMII_10000		(BIT(13) | BIT(6))
+#define DW_USXGMII_5000			(BIT(13) | BIT(5))
+#define DW_USXGMII_2500			(BIT(5))
+#define DW_USXGMII_1000			(BIT(6))
+#define DW_USXGMII_100			(BIT(13))
+#define DW_USXGMII_10			(0)
+
+/* SR_AN */
+#define DW_SR_AN_ADV1			0x10
+#define DW_SR_AN_ADV2			0x11
+#define DW_SR_AN_ADV3			0x12
+#define DW_SR_AN_LP_ABL1		0x13
+#define DW_SR_AN_LP_ABL2		0x14
+#define DW_SR_AN_LP_ABL3		0x15
+
+/* Clause 73 Defines */
+/* AN_LP_ABL1 */
+#define DW_C73_PAUSE			BIT(10)
+#define DW_C73_ASYM_PAUSE		BIT(11)
+#define DW_C73_AN_ADV_SF		0x1
+/* AN_LP_ABL2 */
+#define DW_C73_1000KX			BIT(5)
+#define DW_C73_10000KX4			BIT(6)
+#define DW_C73_10000KR			BIT(7)
+/* AN_LP_ABL3 */
+#define DW_C73_2500KX			BIT(0)
+#define DW_C73_5000KR			BIT(1)
+
+static const int xpcs_usxgmii_features[] = {
+	ETHTOOL_LINK_MODE_Pause_BIT,
+	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+	ETHTOOL_LINK_MODE_Autoneg_BIT,
+	ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT,
+	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
+	__ETHTOOL_LINK_MODE_MASK_NBITS,
+};
+
+static const int xpcs_10gkr_features[] = {
+	ETHTOOL_LINK_MODE_Pause_BIT,
+	ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+	ETHTOOL_LINK_MODE_10000baseKR_Full_BIT,
+	__ETHTOOL_LINK_MODE_MASK_NBITS,
+};
+
+static const phy_interface_t xpcs_usxgmii_interfaces[] = {
+	PHY_INTERFACE_MODE_USXGMII,
+	PHY_INTERFACE_MODE_MAX,
+};
+
+static const phy_interface_t xpcs_10gkr_interfaces[] = {
+	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_MAX,
+};
+
+static struct xpcs_id {
+	u32 id;
+	u32 mask;
+	const int *supported;
+	const phy_interface_t *interface;
+} xpcs_id_list[] = {
+	{
+		.id = SYNOPSYS_XPCS_USXGMII_ID,
+		.mask = SYNOPSYS_XPCS_MASK,
+		.supported = xpcs_usxgmii_features,
+		.interface = xpcs_usxgmii_interfaces,
+	}, {
+		.id = SYNOPSYS_XPCS_10GKR_ID,
+		.mask = SYNOPSYS_XPCS_MASK,
+		.supported = xpcs_10gkr_features,
+		.interface = xpcs_10gkr_interfaces,
+	},
+};
+
+static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
+{
+	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
+
+	return mdiobus_read(xpcs->bus, xpcs->addr, reg_addr);
+}
+
+static int xpcs_write(struct mdio_xpcs_args *xpcs, int dev, u32 reg, u16 val)
+{
+	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
+
+	return mdiobus_write(xpcs->bus, xpcs->addr, reg_addr, val);
+}
+
+static int xpcs_read_vendor(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
+{
+	return xpcs_read(xpcs, dev, DW_VENDOR | reg);
+}
+
+static int xpcs_write_vendor(struct mdio_xpcs_args *xpcs, int dev, int reg,
+			     u16 val)
+{
+	return xpcs_write(xpcs, dev, DW_VENDOR | reg, val);
+}
+
+static int xpcs_read_vpcs(struct mdio_xpcs_args *xpcs, int reg)
+{
+	return xpcs_read_vendor(xpcs, MDIO_MMD_PCS, reg);
+}
+
+static int xpcs_write_vpcs(struct mdio_xpcs_args *xpcs, int reg, u16 val)
+{
+	return xpcs_write_vendor(xpcs, MDIO_MMD_PCS, reg, val);
+}
+
+static int xpcs_poll_reset(struct mdio_xpcs_args *xpcs, int dev)
+{
+	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
+	unsigned int retries = 12;
+	int ret;
+
+	do {
+		msleep(50);
+		ret = xpcs_read(xpcs, dev, MDIO_CTRL1);
+		if (ret < 0)
+			return ret;
+	} while (ret & MDIO_CTRL1_RESET && --retries);
+
+	return (ret & MDIO_CTRL1_RESET) ? -ETIMEDOUT : 0;
+}
+
+static int xpcs_soft_reset(struct mdio_xpcs_args *xpcs, int dev)
+{
+	int ret;
+
+	ret = xpcs_write(xpcs, dev, MDIO_CTRL1, MDIO_CTRL1_RESET);
+	if (ret < 0)
+		return ret;
+
+	return xpcs_poll_reset(xpcs, dev);
+}
+
+#define xpcs_warn(__xpcs, __state, __args...) \
+({ \
+	if ((__state)->link) \
+		dev_warn(&(__xpcs)->bus->dev, ##__args); \
+})
+
+static int xpcs_read_fault(struct mdio_xpcs_args *xpcs,
+			   struct phylink_link_state *state)
+{
+	int ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_STAT1_FAULT) {
+		xpcs_warn(xpcs, state, "Link fault condition detected!\n");
+		return -EFAULT;
+	}
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT2);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_STAT2_RXFAULT)
+		xpcs_warn(xpcs, state, "Receiver fault detected!\n");
+	if (ret & MDIO_STAT2_TXFAULT)
+		xpcs_warn(xpcs, state, "Transmitter fault detected!\n");
+
+	ret = xpcs_read_vendor(xpcs, MDIO_MMD_PCS, DW_VR_XS_PCS_DIG_STS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & DW_RXFIFO_ERR) {
+		xpcs_warn(xpcs, state, "FIFO fault condition detected!\n");
+		return -EFAULT;
+	}
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_PCS_10GBRT_STAT1);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & MDIO_PCS_10GBRT_STAT1_BLKLK))
+		xpcs_warn(xpcs, state, "Link is not locked!\n");
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_PCS_10GBRT_STAT2);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_PCS_10GBRT_STAT2_ERR)
+		xpcs_warn(xpcs, state, "Link has errors!\n");
+
+	return 0;
+}
+
+static int xpcs_read_link(struct mdio_xpcs_args *xpcs, bool an)
+{
+	bool link = true;
+	int ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & MDIO_STAT1_LSTATUS))
+		link = false;
+
+	if (an) {
+		ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
+		if (ret < 0)
+			return ret;
+
+		if (!(ret & MDIO_STAT1_LSTATUS))
+			link = false;
+	}
+
+	return link;
+}
+
+static int xpcs_get_max_usxgmii_speed(const unsigned long *supported)
+{
+	int max = SPEED_UNKNOWN;
+
+	if (phylink_test(supported, 1000baseKX_Full))
+		max = SPEED_1000;
+	if (phylink_test(supported, 2500baseX_Full))
+		max = SPEED_2500;
+	if (phylink_test(supported, 10000baseKX4_Full))
+		max = SPEED_10000;
+	if (phylink_test(supported, 10000baseKR_Full))
+		max = SPEED_10000;
+
+	return max;
+}
+
+static int xpcs_config_usxgmii(struct mdio_xpcs_args *xpcs, int speed)
+{
+	int ret, speed_sel;
+
+	switch (speed) {
+	case SPEED_10:
+		speed_sel = DW_USXGMII_10;
+		break;
+	case SPEED_100:
+		speed_sel = DW_USXGMII_100;
+		break;
+	case SPEED_1000:
+		speed_sel = DW_USXGMII_1000;
+		break;
+	case SPEED_2500:
+		speed_sel = DW_USXGMII_2500;
+		break;
+	case SPEED_5000:
+		speed_sel = DW_USXGMII_5000;
+		break;
+	case SPEED_10000:
+		speed_sel = DW_USXGMII_10000;
+		break;
+	default:
+		/* Nothing to do here */
+		return -EINVAL;
+	}
+
+	ret = xpcs_read_vpcs(xpcs, MDIO_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_EN);
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	ret &= ~DW_USXGMII_SS_MASK;
+	ret |= speed_sel | DW_USXGMII_FULL;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, ret);
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_read_vpcs(xpcs, MDIO_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	return xpcs_write_vpcs(xpcs, MDIO_CTRL1, ret | DW_USXGMII_RST);
+}
+
+static int xpcs_config_aneg_c73(struct mdio_xpcs_args *xpcs)
+{
+	int ret, adv;
+
+	/* By default, in USXGMII mode XPCS operates at 10G baud and
+	 * replicates data to achieve lower speeds. Hereby, in this
+	 * default configuration we need to advertise all supported
+	 * modes and not only the ones we want to use.
+	 */
+
+	/* SR_AN_ADV3 */
+	adv = 0;
+	if (phylink_test(xpcs->supported, 2500baseX_Full))
+		adv |= DW_C73_2500KX;
+
+	/* TODO: 5000baseKR */
+
+	ret = xpcs_write(xpcs, MDIO_MMD_AN, DW_SR_AN_ADV3, adv);
+	if (ret < 0)
+		return ret;
+
+	/* SR_AN_ADV2 */
+	adv = 0;
+	if (phylink_test(xpcs->supported, 1000baseKX_Full))
+		adv |= DW_C73_1000KX;
+	if (phylink_test(xpcs->supported, 10000baseKX4_Full))
+		adv |= DW_C73_10000KX4;
+	if (phylink_test(xpcs->supported, 10000baseKR_Full))
+		adv |= DW_C73_10000KR;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_AN, DW_SR_AN_ADV2, adv);
+	if (ret < 0)
+		return ret;
+
+	/* SR_AN_ADV1 */
+	adv = DW_C73_AN_ADV_SF;
+	if (phylink_test(xpcs->supported, Pause))
+		adv |= DW_C73_PAUSE;
+	if (phylink_test(xpcs->supported, Asym_Pause))
+		adv |= DW_C73_ASYM_PAUSE;
+
+	return xpcs_write(xpcs, MDIO_MMD_AN, DW_SR_AN_ADV1, adv);
+}
+
+static int xpcs_config_aneg(struct mdio_xpcs_args *xpcs)
+{
+	int ret;
+
+	ret = xpcs_config_aneg_c73(xpcs);
+	if (ret < 0)
+		return ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	ret |= MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART;
+
+	return xpcs_write(xpcs, MDIO_MMD_AN, MDIO_CTRL1, ret);
+}
+
+static int xpcs_aneg_done(struct mdio_xpcs_args *xpcs,
+			  struct phylink_link_state *state)
+{
+	int ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & MDIO_AN_STAT1_COMPLETE) {
+		ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
+		if (ret < 0)
+			return ret;
+
+		/* Check if Aneg outcome is valid */
+		if (!(ret & DW_C73_AN_ADV_SF))
+			return 0;
+
+		return 1;
+	}
+
+	return 0;
+}
+
+static int xpcs_read_lpa(struct mdio_xpcs_args *xpcs,
+			 struct phylink_link_state *state)
+{
+	int ret;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
+	if (ret < 0)
+		return ret;
+
+	if (!(ret & MDIO_AN_STAT1_LPABLE)) {
+		phylink_clear(state->lp_advertising, Autoneg);
+		return 0;
+	}
+
+	phylink_set(state->lp_advertising, Autoneg);
+
+	/* Clause 73 outcome */
+	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL3);
+	if (ret < 0)
+		return ret;
+
+	if (ret & DW_C73_2500KX)
+		phylink_set(state->lp_advertising, 2500baseX_Full);
+
+	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL2);
+	if (ret < 0)
+		return ret;
+
+	if (ret & DW_C73_1000KX)
+		phylink_set(state->lp_advertising, 1000baseKX_Full);
+	if (ret & DW_C73_10000KX4)
+		phylink_set(state->lp_advertising, 10000baseKX4_Full);
+	if (ret & DW_C73_10000KR)
+		phylink_set(state->lp_advertising, 10000baseKR_Full);
+
+	ret = xpcs_read(xpcs, MDIO_MMD_AN, DW_SR_AN_LP_ABL1);
+	if (ret < 0)
+		return ret;
+
+	if (ret & DW_C73_PAUSE)
+		phylink_set(state->lp_advertising, Pause);
+	if (ret & DW_C73_ASYM_PAUSE)
+		phylink_set(state->lp_advertising, Asym_Pause);
+
+	linkmode_and(state->lp_advertising, state->lp_advertising,
+		     state->advertising);
+	return 0;
+}
+
+static void xpcs_resolve_lpa(struct mdio_xpcs_args *xpcs,
+			     struct phylink_link_state *state)
+{
+	int max_speed = xpcs_get_max_usxgmii_speed(state->lp_advertising);
+
+	state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
+	state->speed = max_speed;
+	state->duplex = DUPLEX_FULL;
+}
+
+static void xpcs_resolve_pma(struct mdio_xpcs_args *xpcs,
+			     struct phylink_link_state *state)
+{
+	state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
+	state->duplex = DUPLEX_FULL;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_10GKR:
+		state->speed = SPEED_10000;
+		break;
+	default:
+		state->speed = SPEED_UNKNOWN;
+		break;
+	}
+}
+
+static int xpcs_validate(struct mdio_xpcs_args *xpcs,
+			 unsigned long *supported,
+			 struct phylink_link_state *state)
+{
+	linkmode_and(supported, supported, xpcs->supported);
+	linkmode_and(state->advertising, state->advertising, xpcs->supported);
+	return 0;
+}
+
+static int xpcs_config(struct mdio_xpcs_args *xpcs,
+		       const struct phylink_link_state *state)
+{
+	int ret;
+
+	if (state->an_enabled) {
+		ret = xpcs_config_aneg(xpcs);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int xpcs_get_state(struct mdio_xpcs_args *xpcs,
+			  struct phylink_link_state *state)
+{
+	int ret;
+
+	/* Link needs to be read first ... */
+	state->link = xpcs_read_link(xpcs, state->an_enabled) > 0 ? 1 : 0;
+
+	/* ... and then we check the faults. */
+	ret = xpcs_read_fault(xpcs, state);
+	if (ret) {
+		ret = xpcs_soft_reset(xpcs, MDIO_MMD_PCS);
+		if (ret)
+			return ret;
+
+		state->link = 0;
+
+		return xpcs_config(xpcs, state);
+	}
+
+	if (state->link && state->an_enabled && xpcs_aneg_done(xpcs, state)) {
+		state->an_complete = true;
+		xpcs_read_lpa(xpcs, state);
+		xpcs_resolve_lpa(xpcs, state);
+	} else if (state->link) {
+		xpcs_resolve_pma(xpcs, state);
+	}
+
+	return 0;
+}
+
+static int xpcs_link_up(struct mdio_xpcs_args *xpcs, int speed,
+			phy_interface_t interface)
+{
+	if (interface == PHY_INTERFACE_MODE_USXGMII)
+		return xpcs_config_usxgmii(xpcs, speed);
+
+	return 0;
+}
+
+static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
+{
+	int ret;
+	u32 id;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MII_PHYSID1);
+	if (ret < 0)
+		return 0xffffffff;
+
+	id = ret << 16;
+
+	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MII_PHYSID2);
+	if (ret < 0)
+		return 0xffffffff;
+
+	return id | ret;
+}
+
+static bool xpcs_check_features(struct mdio_xpcs_args *xpcs,
+				struct xpcs_id *match,
+				phy_interface_t interface)
+{
+	int i;
+
+	for (i = 0; match->interface[i] != PHY_INTERFACE_MODE_MAX; i++) {
+		if (match->interface[i] == interface)
+			break;
+	}
+
+	if (match->interface[i] == PHY_INTERFACE_MODE_MAX)
+		return false;
+
+	for (i = 0; match->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
+		set_bit(match->supported[i], xpcs->supported);
+
+	return true;
+}
+
+static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
+{
+	u32 xpcs_id = xpcs_get_id(xpcs);
+	struct xpcs_id *match = NULL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
+		struct xpcs_id *entry = &xpcs_id_list[i];
+
+		if ((xpcs_id & entry->mask) == entry->id) {
+			match = entry;
+
+			if (xpcs_check_features(xpcs, match, interface))
+				return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+
+static struct mdio_xpcs_ops xpcs_ops = {
+	.validate = xpcs_validate,
+	.config = xpcs_config,
+	.get_state = xpcs_get_state,
+	.link_up = xpcs_link_up,
+	.probe = xpcs_probe,
+};
+
+struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
+{
+	return &xpcs_ops;
+}
+EXPORT_SYMBOL_GPL(mdio_xpcs_get_ops);
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mdio-xpcs.h b/include/linux/mdio-xpcs.h
new file mode 100644
index 000000000000..9a841aa5982d
--- /dev/null
+++ b/include/linux/mdio-xpcs.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2020 Synopsys, Inc. and/or its affiliates.
+ * Synopsys DesignWare XPCS helpers
+ */
+
+#ifndef __LINUX_MDIO_XPCS_H
+#define __LINUX_MDIO_XPCS_H
+
+#include <linux/phy.h>
+#include <linux/phylink.h>
+
+struct mdio_xpcs_args {
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
+	struct mii_bus *bus;
+	int addr;
+};
+
+struct mdio_xpcs_ops {
+	int (*validate)(struct mdio_xpcs_args *xpcs,
+			unsigned long *supported,
+			struct phylink_link_state *state);
+	int (*config)(struct mdio_xpcs_args *xpcs,
+		      const struct phylink_link_state *state);
+	int (*get_state)(struct mdio_xpcs_args *xpcs,
+			 struct phylink_link_state *state);
+	int (*link_up)(struct mdio_xpcs_args *xpcs, int speed,
+		       phy_interface_t interface);
+	int (*probe)(struct mdio_xpcs_args *xpcs, phy_interface_t interface);
+};
+
+#if IS_ENABLED(CONFIG_MDIO_XPCS)
+struct mdio_xpcs_ops *mdio_xpcs_get_ops(void);
+#else
+static inline struct mdio_xpcs_ops *mdio_xpcs_get_ops(void)
+{
+	return NULL;
+}
+#endif
+
+#endif /* __LINUX_MDIO_XPCS_H */
-- 
2.7.4

