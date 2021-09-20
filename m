Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077D441122A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhITJxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:53:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10199 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbhITJwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 05:52:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632131483; x=1663667483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WyASN8zWFFVzSw2n0JZnDopMWHmS5GJeAcLhhkBwFpQ=;
  b=rjIbSkz5fiuq+oU1PLogZhX3a8d+PyWf+qCnURYFEa/eNRFNRRU3loF7
   8PzpUp69MgBtKN5IsWrw23V+Mwi8knr38jd8NrMkIQDmBWv6HsnRyXXKS
   wK0L9cg2wYq532D9z6Oo1yJEBdFk5RST8e6Eiy7H8ragNu8W5wtnp9Lw8
   /L0ilbf+DAtNhE3ueqm76zczaNtRJgPRnLPbESw0/Tof+5nrgTT0WjhQQ
   GTST3fI3EQ1Bdhhy+ChfP5mxukbau/BZpMmIGpzAlXSVrXaLDr1VUVNpp
   EBRWzWpQe336QnLKcGTRftqJocwFwvAk2ulnMGLldubux4WLylb8W+ztp
   A==;
IronPort-SDR: N9OEJF4x5St+N1hTxny3bnCV0MJxhdP0062Vkeae+tiWyCN5kNBfAJBRQgkG4KmDHpNGurAOpT
 2pTA1CSiFqGkcQwOxBrGZb7F56/6P+7XqVmN/SxGXNy4MBTWu2G18SRBuaOfrhLHgwxXHe14o+
 J3CT3EvQo/YZ87J3Em5N/JvskAWjK37uLYABSJN70gICQAKXyVDHZkQSyY2E25q7cG8X2sJsdw
 +yTS5kbpl39yKbhmHlJGG6vDbXXmjKtW/HTFzOSYJUpT8+cf/EExtM5/MWpR9HaYaoat/a3Uf6
 luZ383bQu45O/ktBRsKYURTM
X-IronPort-AV: E=Sophos;i="5.85,308,1624345200"; 
   d="scan'208";a="137192372"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Sep 2021 02:51:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 20 Sep 2021 02:51:22 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 20 Sep 2021 02:51:19 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <andrew@lunn.ch>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC PATCH net-next 03/12] phy: Add lan966x ethernet serdes PHY driver
Date:   Mon, 20 Sep 2021 11:52:09 +0200
Message-ID: <20210920095218.1108151-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Microchip lan966x ethernet serdes PHY driver for 1G interfaces
available in the lan966x SoC.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/phy/microchip/Kconfig               |   8 +
 drivers/phy/microchip/Makefile              |   1 +
 drivers/phy/microchip/lan966x_serdes.c      | 525 ++++++++++++++++++++
 drivers/phy/microchip/lan966x_serdes_regs.h | 482 ++++++++++++++++++
 include/dt-bindings/phy/lan966x_serdes.h    |  14 +
 5 files changed, 1030 insertions(+)
 create mode 100644 drivers/phy/microchip/lan966x_serdes.c
 create mode 100644 drivers/phy/microchip/lan966x_serdes_regs.h
 create mode 100644 include/dt-bindings/phy/lan966x_serdes.h

diff --git a/drivers/phy/microchip/Kconfig b/drivers/phy/microchip/Kconfig
index 3728a284bf64..38039ed0754c 100644
--- a/drivers/phy/microchip/Kconfig
+++ b/drivers/phy/microchip/Kconfig
@@ -11,3 +11,11 @@ config PHY_SPARX5_SERDES
 	depends on HAS_IOMEM
 	help
 	  Enable this for support of the 10G/25G SerDes on Microchip Sparx5.
+
+config PHY_LAN966X_SERDES
+	tristate "SerDes PHY driver for Microchip LAN966X"
+	select GENERIC_PHY
+	depends on OF
+	depends on MFD_SYSCON
+	help
+	  Enable this for supporting SerDes muxing with Microchip LAN966X
diff --git a/drivers/phy/microchip/Makefile b/drivers/phy/microchip/Makefile
index 7b98345712aa..fd73b87960a5 100644
--- a/drivers/phy/microchip/Makefile
+++ b/drivers/phy/microchip/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_PHY_SPARX5_SERDES) := sparx5_serdes.o
+obj-$(CONFIG_PHY_LAN966X_SERDES) := lan966x_serdes.o
diff --git a/drivers/phy/microchip/lan966x_serdes.c b/drivers/phy/microchip/lan966x_serdes.c
new file mode 100644
index 000000000000..80811af40dca
--- /dev/null
+++ b/drivers/phy/microchip/lan966x_serdes.c
@@ -0,0 +1,525 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+
+#include <linux/err.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <dt-bindings/phy/lan966x_serdes.h>
+#include "lan966x_serdes_regs.h"
+
+static const char *gcb_syscon = "microchip,lan966x-switch-syscon";
+
+#define lan_offset_(id, tinst, tcnt,			\
+		   gbase, ginst, gcnt, gwidth,		\
+		   raddr, rinst, rcnt, rwidth)		\
+	(gbase + ((ginst) * gwidth) + raddr + ((rinst) * rwidth))
+#define lan_offset(...) lan_offset_(__VA_ARGS__)
+
+#define lan_rmw(val, mask, reg, off)			\
+	regmap_update_bits(reg, lan_offset(off), mask, val)
+
+struct serdes_ctrl {
+	struct regmap		*regs;
+	struct device		*dev;
+	struct phy		*phys[SERDES_MAX];
+	int			ref125;
+};
+
+struct serdes_macro {
+	u8			idx;
+	int			port;
+	struct serdes_ctrl	*ctrl;
+};
+
+enum lan966x_sd6g40_mode {
+	LAN966X_SD6G40_MODE_QSGMII,
+	LAN966X_SD6G40_MODE_SGMII,
+};
+
+enum lan966x_sd6g40_ltx2rx {
+	LAN966X_SD6G40_TX2RX_LOOP_NONE,
+	LAN966X_SD6G40_LTX2RX
+};
+
+struct lan966x_sd6g40_setup_args {
+	enum lan966x_sd6g40_mode  mode;
+	enum lan966x_sd6g40_ltx2rx tx2rx_loop;
+	bool txinvert;
+	bool rxinvert;
+	bool refclk125M;
+	bool mute;
+};
+
+struct lan966x_sd6g40_mode_args {
+	enum lan966x_sd6g40_mode  mode;
+	u8 lane_10bit_sel;
+	u8 mpll_multiplier;
+	u8 ref_clkdiv2;
+	u8 tx_rate;
+	u8 rx_rate;
+};
+
+struct lan966x_sd6g40_setup {
+	u8 rx_term_en;
+	u8 lane_10bit_sel;
+	u8 tx_invert;
+	u8 rx_invert;
+	u8 mpll_multiplier;
+	u8 lane_loopbk_en;
+	u8 ref_clkdiv2;
+	u8 tx_rate;
+	u8 rx_rate;
+};
+
+static int lan966x_sd6g40_reg_cfg(struct serdes_macro *macro,
+				  struct lan966x_sd6g40_setup *res_struct,
+				  u32 idx)
+{
+	u32 value;
+
+	/* Note: SerDes HSIO is configured in 1G_LAN mode */
+	lan_rmw(HSIO_SD_CFG_LANE_10BIT_SEL(res_struct->lane_10bit_sel) |
+		HSIO_SD_CFG_RX_RATE(res_struct->rx_rate) |
+		HSIO_SD_CFG_TX_RATE(res_struct->tx_rate) |
+		HSIO_SD_CFG_TX_INVERT(res_struct->tx_invert) |
+		HSIO_SD_CFG_RX_INVERT(res_struct->rx_invert) |
+		HSIO_SD_CFG_LANE_LOOPBK_EN(res_struct->lane_loopbk_en) |
+		HSIO_SD_CFG_RX_RESET(0) |
+		HSIO_SD_CFG_TX_RESET(0),
+		HSIO_SD_CFG_LANE_10BIT_SEL_M |
+		HSIO_SD_CFG_RX_RATE_M |
+		HSIO_SD_CFG_TX_RATE_M |
+		HSIO_SD_CFG_TX_INVERT_M |
+		HSIO_SD_CFG_RX_INVERT_M |
+		HSIO_SD_CFG_LANE_LOOPBK_EN_M |
+		HSIO_SD_CFG_RX_RESET_M |
+		HSIO_SD_CFG_TX_RESET_M,
+		macro->ctrl->regs, HSIO_SD_CFG(idx));
+
+	lan_rmw(HSIO_MPLL_CFG_MPLL_MULTIPLIER(res_struct->mpll_multiplier) |
+		HSIO_MPLL_CFG_REF_CLKDIV2(res_struct->ref_clkdiv2),
+		HSIO_MPLL_CFG_MPLL_MULTIPLIER_M |
+		HSIO_MPLL_CFG_REF_CLKDIV2_M,
+		macro->ctrl->regs, HSIO_MPLL_CFG(idx));
+
+	lan_rmw(HSIO_SD_CFG_RX_TERM_EN(res_struct->rx_term_en),
+		HSIO_SD_CFG_RX_TERM_EN_M,
+		macro->ctrl->regs, HSIO_SD_CFG(idx));
+
+	lan_rmw(HSIO_MPLL_CFG_REF_SSP_EN(1),
+		HSIO_MPLL_CFG_REF_SSP_EN_M,
+		macro->ctrl->regs, HSIO_MPLL_CFG(idx));
+
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+
+	lan_rmw(HSIO_SD_CFG_PHY_RESET(0),
+		HSIO_SD_CFG_PHY_RESET_M,
+		macro->ctrl->regs, HSIO_SD_CFG(idx));
+
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+
+	lan_rmw(HSIO_MPLL_CFG_MPLL_EN(1),
+		HSIO_MPLL_CFG_MPLL_EN_M,
+		macro->ctrl->regs, HSIO_MPLL_CFG(idx));
+
+	usleep_range(7 * USEC_PER_MSEC, 8 * USEC_PER_MSEC);
+
+	regmap_read(macro->ctrl->regs, lan_offset(HSIO_SD_STAT(idx)), &value);
+	value = HSIO_SD_STAT_MPLL_STATE_X(value);
+	if (value != 0x1) {
+		pr_info("Unexpected sd_sd_stat[%u] mpll_state was 0x1 but is 0x%x\n",
+			idx, value);
+		return 1;
+	}
+
+	lan_rmw(HSIO_SD_CFG_TX_CM_EN(1),
+		HSIO_SD_CFG_TX_CM_EN_M,
+		macro->ctrl->regs, HSIO_SD_CFG(idx));
+
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+
+	regmap_read(macro->ctrl->regs, lan_offset(HSIO_SD_STAT(idx)), &value);
+	value = HSIO_SD_STAT_TX_CM_STATE_X(value);
+	if (value != 0x1) {
+		pr_info("Unexpected sd_sd_stat[%u] tx_cm_state was 0x1 but is 0x%x\n",
+			idx, value);
+		return 1;
+	}
+
+	lan_rmw(HSIO_SD_CFG_RX_PLL_EN(1) |
+		HSIO_SD_CFG_TX_EN(1),
+		HSIO_SD_CFG_RX_PLL_EN_M |
+		HSIO_SD_CFG_TX_EN_M,
+		macro->ctrl->regs, HSIO_SD_CFG(idx));
+
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+
+	/* Waiting for serdes 0 rx DPLL to lock...  */
+	regmap_read(macro->ctrl->regs, lan_offset(HSIO_SD_STAT(idx)), &value);
+	value = HSIO_SD_STAT_RX_PLL_STATE_X(value);
+	if (value != 0x1) {
+		pr_info("Unexpected sd_sd_stat[%u] rx_pll_state was 0x1 but is 0x%x\n",
+			idx, value);
+		return 1;
+	}
+
+	/* Waiting for serdes 0 tx operational...  */
+	regmap_read(macro->ctrl->regs, lan_offset(HSIO_SD_STAT(idx)), &value);
+	value = HSIO_SD_STAT_TX_STATE_X(value);
+	if (value != 0x1) {
+		pr_info("Unexpected sd_sd_stat[%u] tx_state was 0x1 but is 0x%x\n",
+			idx, value);
+		return 1;
+	}
+
+	lan_rmw(HSIO_SD_CFG_TX_DATA_EN(1) |
+		HSIO_SD_CFG_RX_DATA_EN(1),
+		HSIO_SD_CFG_TX_DATA_EN_M |
+		HSIO_SD_CFG_RX_DATA_EN_M,
+		macro->ctrl->regs, HSIO_SD_CFG(idx));
+
+	return 0;
+}
+
+static int lan966x_sd6g40_get_conf_from_mode(enum lan966x_sd6g40_mode f_mode,
+					     bool ref125M,
+					     struct lan966x_sd6g40_mode_args *ret_val)
+{
+	switch (f_mode) {
+	case LAN966X_SD6G40_MODE_QSGMII:
+		ret_val->lane_10bit_sel = 0;
+		if (ref125M) {
+			ret_val->mpll_multiplier = 40;
+			ret_val->ref_clkdiv2 = 0x1;
+			ret_val->tx_rate = 0x0;
+			ret_val->rx_rate = 0x0;
+		} else {
+			ret_val->mpll_multiplier = 100;
+			ret_val->ref_clkdiv2 = 0x0;
+			ret_val->tx_rate = 0x0;
+			ret_val->rx_rate = 0x0;
+		}
+		break;
+	case LAN966X_SD6G40_MODE_SGMII:
+		ret_val->lane_10bit_sel = 1;
+		if (ref125M) {
+			ret_val->mpll_multiplier = 40;
+			ret_val->ref_clkdiv2 = 0x1;
+			ret_val->tx_rate = 0x2;
+			ret_val->rx_rate = 0x2;
+		} else {
+			ret_val->mpll_multiplier = 100;
+			ret_val->ref_clkdiv2 = 0x0;
+			ret_val->tx_rate = 0x2;
+			ret_val->rx_rate = 0x2;
+		}
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int lan966x_calc_sd6g40_setup_lane(struct lan966x_sd6g40_setup_args config,
+					  struct lan966x_sd6g40_setup *ret_val)
+{
+	struct lan966x_sd6g40_mode_args sd6g40_mode;
+	struct lan966x_sd6g40_mode_args *mode_args = &sd6g40_mode;
+
+	if (lan966x_sd6g40_get_conf_from_mode(config.mode, config.refclk125M,
+					      mode_args))
+		return -1;
+
+	ret_val->lane_10bit_sel = mode_args->lane_10bit_sel;
+	ret_val->rx_rate = mode_args->rx_rate;
+	ret_val->tx_rate = mode_args->tx_rate;
+	ret_val->mpll_multiplier = mode_args->mpll_multiplier;
+	ret_val->ref_clkdiv2 = mode_args->ref_clkdiv2;
+	ret_val->rx_term_en = 0;
+
+	if (config.tx2rx_loop == LAN966X_SD6G40_LTX2RX)
+		ret_val->lane_loopbk_en = 1;
+	else
+		ret_val->lane_loopbk_en = 0;
+
+	if (config.txinvert)
+		ret_val->tx_invert = 1;
+	else
+		ret_val->tx_invert = 0;
+
+	if (config.rxinvert)
+		ret_val->rx_invert = 1;
+	else
+		ret_val->rx_invert = 0;
+
+	return 0;
+}
+
+static int lan966x_sd6g40_setup_lane(struct serdes_macro *macro,
+				     struct lan966x_sd6g40_setup_args config,
+				     u32 idx)
+{
+	struct lan966x_sd6g40_setup calc_results;
+	int ret;
+
+	memset(&calc_results, 0x0, sizeof(calc_results));
+
+	ret = lan966x_calc_sd6g40_setup_lane(config, &calc_results);
+	if (ret)
+		return ret;
+
+	return lan966x_sd6g40_reg_cfg(macro, &calc_results, idx);
+}
+
+static int lan966x_sd6g40_setup(struct serdes_macro *macro, u32 idx, int mode)
+{
+	struct lan966x_sd6g40_setup_args conf;
+
+	memset(&conf, 0x0, sizeof(conf));
+	conf.refclk125M = macro->ctrl->ref125;
+
+	if (mode == PHY_INTERFACE_MODE_QSGMII)
+		conf.mode = LAN966X_SD6G40_MODE_QSGMII;
+	else
+		conf.mode = LAN966X_SD6G40_MODE_SGMII;
+
+	return lan966x_sd6g40_setup_lane(macro, conf, idx);
+}
+
+struct serdes_mux {
+	u8			idx;
+	u8			port;
+	enum phy_mode		mode;
+	int			submode;
+	u32			mask;
+	u32			mux;
+};
+
+#define SERDES_MUX(_idx, _port, _mode, _submode, _mask, _mux) { \
+	.idx = _idx,						\
+	.port = _port,						\
+	.mode = _mode,						\
+	.submode = _submode,					\
+	.mask = _mask,						\
+	.mux = _mux,						\
+}
+
+#define SERDES_MUX_GMII(i, p, m, c) \
+	SERDES_MUX(i, p, PHY_MODE_ETHERNET, PHY_INTERFACE_MODE_GMII, m, c)
+#define SERDES_MUX_SGMII(i, p, m, c) \
+	SERDES_MUX(i, p, PHY_MODE_ETHERNET, PHY_INTERFACE_MODE_SGMII, m, c)
+#define SERDES_MUX_QSGMII(i, p, m, c) \
+	SERDES_MUX(i, p, PHY_MODE_ETHERNET, PHY_INTERFACE_MODE_QSGMII, m, c)
+#define SERDES_MUX_RGMII(i, p, m, c) \
+	SERDES_MUX(i, p, PHY_MODE_ETHERNET, PHY_INTERFACE_MODE_RGMII, m, c)
+
+static const struct serdes_mux lan966x_serdes_muxes[] = {
+	SERDES_MUX_QSGMII(SERDES6G(1), 0, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(0))),
+	SERDES_MUX_QSGMII(SERDES6G(1), 1, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(0))),
+	SERDES_MUX_QSGMII(SERDES6G(1), 2, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(0))),
+	SERDES_MUX_QSGMII(SERDES6G(1), 3, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(0))),
+
+	SERDES_MUX_QSGMII(SERDES6G(2), 4, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(1))),
+	SERDES_MUX_QSGMII(SERDES6G(2), 5, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(1))),
+	SERDES_MUX_QSGMII(SERDES6G(2), 6, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(1))),
+	SERDES_MUX_QSGMII(SERDES6G(2), 7, HSIO_HW_CFG_QSGMII_ENA_M,
+			  HSIO_HW_CFG_QSGMII_ENA(BIT(1))),
+
+	SERDES_MUX_GMII(CU(0), 0, HSIO_HW_CFG_GMII_ENA_M,
+			HSIO_HW_CFG_GMII_ENA(BIT(0))),
+	SERDES_MUX_GMII(CU(1), 1, HSIO_HW_CFG_GMII_ENA_M,
+			HSIO_HW_CFG_GMII_ENA(BIT(1))),
+
+	SERDES_MUX_SGMII(SERDES6G(0), 0, HSIO_HW_CFG_SD6G_0_CFG_M, 0),
+	SERDES_MUX_SGMII(SERDES6G(1), 1, HSIO_HW_CFG_SD6G_1_CFG_M, 0),
+	SERDES_MUX_SGMII(SERDES6G(0), 2, HSIO_HW_CFG_SD6G_0_CFG_M,
+			 HSIO_HW_CFG_SD6G_0_CFG(1)),
+	SERDES_MUX_SGMII(SERDES6G(1), 3, HSIO_HW_CFG_SD6G_1_CFG_M,
+			 HSIO_HW_CFG_SD6G_1_CFG(1)),
+
+	SERDES_MUX_RGMII(RG(0), 2, HSIO_HW_CFG_RGMII_0_CFG_M |
+			 HSIO_HW_CFG_RGMII_ENA_M,
+			 HSIO_HW_CFG_RGMII_0_CFG(BIT(0)) |
+			 HSIO_HW_CFG_RGMII_ENA(BIT(0))),
+	SERDES_MUX_RGMII(RG(1), 3, HSIO_HW_CFG_RGMII_1_CFG_M |
+			 HSIO_HW_CFG_RGMII_ENA_M,
+			 HSIO_HW_CFG_RGMII_1_CFG(BIT(0)) |
+			 HSIO_HW_CFG_RGMII_ENA(BIT(1))),
+	SERDES_MUX_RGMII(RG(0), 5, HSIO_HW_CFG_RGMII_0_CFG_M |
+			 HSIO_HW_CFG_RGMII_ENA_M,
+			 HSIO_HW_CFG_RGMII_0_CFG(BIT(0)) |
+			 HSIO_HW_CFG_RGMII_ENA(BIT(0))),
+	SERDES_MUX_RGMII(RG(1), 6, HSIO_HW_CFG_RGMII_1_CFG_M |
+			 HSIO_HW_CFG_RGMII_ENA_M,
+			 HSIO_HW_CFG_RGMII_1_CFG(BIT(0)) |
+			 HSIO_HW_CFG_RGMII_ENA(BIT(1))),
+};
+
+static int serdes_set_mode(struct phy *phy, enum phy_mode mode, int submode)
+{
+	struct serdes_macro *macro = phy_get_drvdata(phy);
+	unsigned int i;
+	int val;
+	int ret;
+
+	/* As of now only PHY_MODE_ETHERNET is supported */
+	if (mode != PHY_MODE_ETHERNET)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < ARRAY_SIZE(lan966x_serdes_muxes); i++) {
+		if (macro->idx != lan966x_serdes_muxes[i].idx ||
+		    mode != lan966x_serdes_muxes[i].mode ||
+		    submode != lan966x_serdes_muxes[i].submode ||
+		    macro->port != lan966x_serdes_muxes[i].port)
+			continue;
+
+		ret = regmap_read(macro->ctrl->regs, lan_offset(HSIO_HW_CFG),
+				  &val);
+		if (ret)
+			return ret;
+
+		ret = regmap_update_bits(macro->ctrl->regs,
+					 lan_offset(HSIO_HW_CFG),
+					 lan966x_serdes_muxes[i].mask,
+					 val | lan966x_serdes_muxes[i].mux);
+		if (ret)
+			return ret;
+
+		if (macro->idx < CU_MAX)
+			return 0;
+
+		if (macro->idx < SERDES6G_MAX)
+			return lan966x_sd6g40_setup(macro,
+						    macro->idx - (CU_MAX + 1),
+						    lan966x_serdes_muxes[i].submode);
+
+		if (macro->idx < RG_MAX)
+			return 0;
+
+		return -EOPNOTSUPP;
+	}
+
+	return -EINVAL;
+}
+
+static const struct phy_ops serdes_ops = {
+	.set_mode	= serdes_set_mode,
+	.owner		= THIS_MODULE,
+};
+
+static struct phy *serdes_simple_xlate(struct device *dev,
+				       struct of_phandle_args *args)
+{
+	struct serdes_ctrl *ctrl = dev_get_drvdata(dev);
+	unsigned int port, idx, i;
+
+	if (args->args_count != 2)
+		return ERR_PTR(-EINVAL);
+
+	port = args->args[0];
+	idx = args->args[1];
+
+	for (i = 0; i < SERDES_MAX; i++) {
+		struct serdes_macro *macro = phy_get_drvdata(ctrl->phys[i]);
+
+		if (idx != macro->idx)
+			continue;
+
+		macro->port = port;
+		return ctrl->phys[i];
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
+static int serdes_phy_create(struct serdes_ctrl *ctrl, u8 idx, struct phy **phy)
+{
+	struct serdes_macro *macro;
+
+	*phy = devm_phy_create(ctrl->dev, NULL, &serdes_ops);
+	if (IS_ERR(*phy))
+		return PTR_ERR(*phy);
+
+	macro = devm_kzalloc(ctrl->dev, sizeof(*macro), GFP_KERNEL);
+	if (!macro)
+		return -ENOMEM;
+
+	macro->idx = idx;
+	macro->ctrl = ctrl;
+	macro->port = -1;
+
+	phy_set_drvdata(*phy, macro);
+
+	return 0;
+}
+
+static int serdes_probe(struct platform_device *pdev)
+{
+	struct phy_provider *provider;
+	struct serdes_ctrl *ctrl;
+	struct regmap *gcb_ctrl;
+	unsigned int i;
+	u32 val;
+	int ret;
+
+	ctrl = devm_kzalloc(&pdev->dev, sizeof(*ctrl), GFP_KERNEL);
+	if (!ctrl)
+		return -ENOMEM;
+
+	ctrl->dev = &pdev->dev;
+	ctrl->regs = syscon_node_to_regmap(pdev->dev.parent->of_node);
+	if (IS_ERR(ctrl->regs))
+		return PTR_ERR(ctrl->regs);
+
+	gcb_ctrl = syscon_regmap_lookup_by_compatible(gcb_syscon);
+	if (IS_ERR(gcb_ctrl)) {
+		dev_err(&pdev->dev, "No gcb_syscon: %s\n", gcb_syscon);
+		return PTR_ERR(gcb_ctrl);
+	}
+
+	for (i = 0; i < SERDES_MAX; i++) {
+		ret = serdes_phy_create(ctrl, i, &ctrl->phys[i]);
+		if (ret)
+			return ret;
+	}
+
+	regmap_read(gcb_ctrl, 0x4, &val);
+	val &= GENMASK(2, 0);
+	ctrl->ref125 = (val == 1 || val == 2);
+
+	dev_set_drvdata(&pdev->dev, ctrl);
+
+	provider = devm_of_phy_provider_register(ctrl->dev,
+						 serdes_simple_xlate);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static const struct of_device_id serdes_ids[] = {
+	{ .compatible = "microchip,lan966x-serdes", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, serdes_ids);
+
+static struct platform_driver mscc_lan966x_serdes = {
+	.probe		= serdes_probe,
+	.driver		= {
+		.name	= "microchip,lan966x-serdes",
+		.of_match_table = of_match_ptr(serdes_ids),
+	},
+};
+
+module_platform_driver(mscc_lan966x_serdes);
diff --git a/drivers/phy/microchip/lan966x_serdes_regs.h b/drivers/phy/microchip/lan966x_serdes_regs.h
new file mode 100644
index 000000000000..c3d3d16c1e97
--- /dev/null
+++ b/drivers/phy/microchip/lan966x_serdes_regs.h
@@ -0,0 +1,482 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Microchip LAN966x Switch driver
+ *
+ * License: Dual MIT/GPL
+ * Copyright (c) 2020 Microchip Technology Inc.
+ */
+
+/* This file is autogenerated by cml-utils 2021-05-12 15:48:55 +0200.
+ * Commit ID: dbe188f718027a2c414b90d45f152b73468cbc5c (dirty)
+ */
+
+#ifndef _LAN966X_HSIO_REGS_H_
+#define _LAN966X_HSIO_REGS_H_
+
+#include <linux/bitops.h>
+
+#define LAN966X_BUILD_ID_REG GCB_BUILDID
+enum lan966x_target {
+	TARGET_HSIO = 32,
+	NUM_TARGETS = 66
+};
+
+#define __REG(...)    __VA_ARGS__
+
+/*      HSIO:SYNC_ETH_CFG:SYNC_ETH_CFG */
+#define HSIO_SYNC_ETH_CFG(r)      __REG(TARGET_HSIO,\
+					0, 1, 0, 0, 1, 8, 0, r, 2, 4)
+
+#define HSIO_SYNC_ETH_CFG_SEL_RECO_CLK_SRC(x)    (((x) << 4) & GENMASK(6, 4))
+#define HSIO_SYNC_ETH_CFG_SEL_RECO_CLK_SRC_M     GENMASK(6, 4)
+#define HSIO_SYNC_ETH_CFG_SEL_RECO_CLK_SRC_X(x)  (((x) & GENMASK(6, 4)) >> 4)
+
+#define HSIO_SYNC_ETH_CFG_SEL_RECO_CLK_DIV(x)    (((x) << 1) & GENMASK(3, 1))
+#define HSIO_SYNC_ETH_CFG_SEL_RECO_CLK_DIV_M     GENMASK(3, 1)
+#define HSIO_SYNC_ETH_CFG_SEL_RECO_CLK_DIV_X(x)  (((x) & GENMASK(3, 1)) >> 1)
+
+#define HSIO_SYNC_ETH_CFG_RECO_CLK_ENA(x)        ((x) & GENMASK(0, 0))
+#define HSIO_SYNC_ETH_CFG_RECO_CLK_ENA_M         GENMASK(0, 0)
+#define HSIO_SYNC_ETH_CFG_RECO_CLK_ENA_X(x)      ((x) & GENMASK(0, 0))
+
+/*      HSIO:SD:SD_CFG */
+#define HSIO_SD_CFG(g)            __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 0, 0, 1, 4)
+
+#define HSIO_SD_CFG_TEST_POWERDOWN(x)            (((x) << 28) & GENMASK(28, 28))
+#define HSIO_SD_CFG_TEST_POWERDOWN_M             GENMASK(28, 28)
+#define HSIO_SD_CFG_TEST_POWERDOWN_X(x)          (((x) & GENMASK(28, 28)) >> 28)
+
+#define HSIO_SD_CFG_PHY_RESET(x)                 (((x) << 27) & GENMASK(27, 27))
+#define HSIO_SD_CFG_PHY_RESET_M                  GENMASK(27, 27)
+#define HSIO_SD_CFG_PHY_RESET_X(x)               (((x) & GENMASK(27, 27)) >> 27)
+
+#define HSIO_SD_CFG_RX_LOS_FILT_CNT(x)           (((x) << 20) & GENMASK(26, 20))
+#define HSIO_SD_CFG_RX_LOS_FILT_CNT_M            GENMASK(26, 20)
+#define HSIO_SD_CFG_RX_LOS_FILT_CNT_X(x)         (((x) & GENMASK(26, 20)) >> 20)
+
+#define HSIO_SD_CFG_TX_VBOOST_EN(x)              (((x) << 19) & GENMASK(19, 19))
+#define HSIO_SD_CFG_TX_VBOOST_EN_M               GENMASK(19, 19)
+#define HSIO_SD_CFG_TX_VBOOST_EN_X(x)            (((x) & GENMASK(19, 19)) >> 19)
+
+#define HSIO_SD_CFG_TX_RESET(x)                  (((x) << 18) & GENMASK(18, 18))
+#define HSIO_SD_CFG_TX_RESET_M                   GENMASK(18, 18)
+#define HSIO_SD_CFG_TX_RESET_X(x)                (((x) & GENMASK(18, 18)) >> 18)
+
+#define HSIO_SD_CFG_TX_RATE(x)                   (((x) << 16) & GENMASK(17, 16))
+#define HSIO_SD_CFG_TX_RATE_M                    GENMASK(17, 16)
+#define HSIO_SD_CFG_TX_RATE_X(x)                 (((x) & GENMASK(17, 16)) >> 16)
+
+#define HSIO_SD_CFG_TX_INVERT(x)                 (((x) << 15) & GENMASK(15, 15))
+#define HSIO_SD_CFG_TX_INVERT_M                  GENMASK(15, 15)
+#define HSIO_SD_CFG_TX_INVERT_X(x)               (((x) & GENMASK(15, 15)) >> 15)
+
+#define HSIO_SD_CFG_TX_EN(x)                     (((x) << 14) & GENMASK(14, 14))
+#define HSIO_SD_CFG_TX_EN_M                      GENMASK(14, 14)
+#define HSIO_SD_CFG_TX_EN_X(x)                   (((x) & GENMASK(14, 14)) >> 14)
+
+#define HSIO_SD_CFG_TX_DETECT_RX_REQ(x)          (((x) << 13) & GENMASK(13, 13))
+#define HSIO_SD_CFG_TX_DETECT_RX_REQ_M           GENMASK(13, 13)
+#define HSIO_SD_CFG_TX_DETECT_RX_REQ_X(x)        (((x) & GENMASK(13, 13)) >> 13)
+
+#define HSIO_SD_CFG_TX_DATA_EN(x)                (((x) << 12) & GENMASK(12, 12))
+#define HSIO_SD_CFG_TX_DATA_EN_M                 GENMASK(12, 12)
+#define HSIO_SD_CFG_TX_DATA_EN_X(x)              (((x) & GENMASK(12, 12)) >> 12)
+
+#define HSIO_SD_CFG_TX_CM_EN(x)                  (((x) << 11) & GENMASK(11, 11))
+#define HSIO_SD_CFG_TX_CM_EN_M                   GENMASK(11, 11)
+#define HSIO_SD_CFG_TX_CM_EN_X(x)                (((x) & GENMASK(11, 11)) >> 11)
+
+#define HSIO_SD_CFG_LANE_10BIT_SEL(x)            (((x) << 10) & GENMASK(10, 10))
+#define HSIO_SD_CFG_LANE_10BIT_SEL_M             GENMASK(10, 10)
+#define HSIO_SD_CFG_LANE_10BIT_SEL_X(x)          (((x) & GENMASK(10, 10)) >> 10)
+
+#define HSIO_SD_CFG_RX_TERM_EN(x)                (((x) << 9) & GENMASK(9, 9))
+#define HSIO_SD_CFG_RX_TERM_EN_M                 GENMASK(9, 9)
+#define HSIO_SD_CFG_RX_TERM_EN_X(x)              (((x) & GENMASK(9, 9)) >> 9)
+
+#define HSIO_SD_CFG_RX_RESET(x)                  (((x) << 8) & GENMASK(8, 8))
+#define HSIO_SD_CFG_RX_RESET_M                   GENMASK(8, 8)
+#define HSIO_SD_CFG_RX_RESET_X(x)                (((x) & GENMASK(8, 8)) >> 8)
+
+#define HSIO_SD_CFG_RX_RATE(x)                   (((x) << 6) & GENMASK(7, 6))
+#define HSIO_SD_CFG_RX_RATE_M                    GENMASK(7, 6)
+#define HSIO_SD_CFG_RX_RATE_X(x)                 (((x) & GENMASK(7, 6)) >> 6)
+
+#define HSIO_SD_CFG_RX_PLL_EN(x)                 (((x) << 5) & GENMASK(5, 5))
+#define HSIO_SD_CFG_RX_PLL_EN_M                  GENMASK(5, 5)
+#define HSIO_SD_CFG_RX_PLL_EN_X(x)               (((x) & GENMASK(5, 5)) >> 5)
+
+#define HSIO_SD_CFG_RX_LOS_EN(x)                 (((x) << 4) & GENMASK(4, 4))
+#define HSIO_SD_CFG_RX_LOS_EN_M                  GENMASK(4, 4)
+#define HSIO_SD_CFG_RX_LOS_EN_X(x)               (((x) & GENMASK(4, 4)) >> 4)
+
+#define HSIO_SD_CFG_RX_INVERT(x)                 (((x) << 3) & GENMASK(3, 3))
+#define HSIO_SD_CFG_RX_INVERT_M                  GENMASK(3, 3)
+#define HSIO_SD_CFG_RX_INVERT_X(x)               (((x) & GENMASK(3, 3)) >> 3)
+
+#define HSIO_SD_CFG_RX_DATA_EN(x)                (((x) << 2) & GENMASK(2, 2))
+#define HSIO_SD_CFG_RX_DATA_EN_M                 GENMASK(2, 2)
+#define HSIO_SD_CFG_RX_DATA_EN_X(x)              (((x) & GENMASK(2, 2)) >> 2)
+
+#define HSIO_SD_CFG_RX_ALIGN_EN(x)               (((x) << 1) & GENMASK(1, 1))
+#define HSIO_SD_CFG_RX_ALIGN_EN_M                GENMASK(1, 1)
+#define HSIO_SD_CFG_RX_ALIGN_EN_X(x)             (((x) & GENMASK(1, 1)) >> 1)
+
+#define HSIO_SD_CFG_LANE_LOOPBK_EN(x)            ((x) & GENMASK(0, 0))
+#define HSIO_SD_CFG_LANE_LOOPBK_EN_M             GENMASK(0, 0)
+#define HSIO_SD_CFG_LANE_LOOPBK_EN_X(x)          ((x) & GENMASK(0, 0))
+
+/*      HSIO:SD:SD_CFG2 */
+#define HSIO_SD_CFG2(g)           __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 4, 0, 1, 4)
+
+#define HSIO_SD_CFG2_RX_EQ(x)                    (((x) << 25) & GENMASK(27, 25))
+#define HSIO_SD_CFG2_RX_EQ_M                     GENMASK(27, 25)
+#define HSIO_SD_CFG2_RX_EQ_X(x)                  (((x) & GENMASK(27, 25)) >> 25)
+
+#define HSIO_SD_CFG2_TX_TERM_OFFSET(x)           (((x) << 20) & GENMASK(24, 20))
+#define HSIO_SD_CFG2_TX_TERM_OFFSET_M            GENMASK(24, 20)
+#define HSIO_SD_CFG2_TX_TERM_OFFSET_X(x)         (((x) & GENMASK(24, 20)) >> 20)
+
+#define HSIO_SD_CFG2_TX_VBOOST_LVL(x)            (((x) << 17) & GENMASK(19, 17))
+#define HSIO_SD_CFG2_TX_VBOOST_LVL_M             GENMASK(19, 17)
+#define HSIO_SD_CFG2_TX_VBOOST_LVL_X(x)          (((x) & GENMASK(19, 17)) >> 17)
+
+#define HSIO_SD_CFG2_LOS_BIAS(x)                 (((x) << 14) & GENMASK(16, 14))
+#define HSIO_SD_CFG2_LOS_BIAS_M                  GENMASK(16, 14)
+#define HSIO_SD_CFG2_LOS_BIAS_X(x)               (((x) & GENMASK(16, 14)) >> 14)
+
+#define HSIO_SD_CFG2_TX_AMPLITUDE(x)             (((x) << 7) & GENMASK(13, 7))
+#define HSIO_SD_CFG2_TX_AMPLITUDE_M              GENMASK(13, 7)
+#define HSIO_SD_CFG2_TX_AMPLITUDE_X(x)           (((x) & GENMASK(13, 7)) >> 7)
+
+#define HSIO_SD_CFG2_TX_PREEMPH(x)               ((x) & GENMASK(6, 0))
+#define HSIO_SD_CFG2_TX_PREEMPH_M                GENMASK(6, 0)
+#define HSIO_SD_CFG2_TX_PREEMPH_X(x)             ((x) & GENMASK(6, 0))
+
+/*      HSIO:SD:MPLL_CFG */
+#define HSIO_MPLL_CFG(g)          __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 8, 0, 1, 4)
+
+#define HSIO_MPLL_CFG_REF_SSP_EN(x)              (((x) << 18) & GENMASK(18, 18))
+#define HSIO_MPLL_CFG_REF_SSP_EN_M               GENMASK(18, 18)
+#define HSIO_MPLL_CFG_REF_SSP_EN_X(x)            (((x) & GENMASK(18, 18)) >> 18)
+
+#define HSIO_MPLL_CFG_REF_CLKDIV2(x)             (((x) << 17) & GENMASK(17, 17))
+#define HSIO_MPLL_CFG_REF_CLKDIV2_M              GENMASK(17, 17)
+#define HSIO_MPLL_CFG_REF_CLKDIV2_X(x)           (((x) & GENMASK(17, 17)) >> 17)
+
+#define HSIO_MPLL_CFG_MPLL_EN(x)                 (((x) << 16) & GENMASK(16, 16))
+#define HSIO_MPLL_CFG_MPLL_EN_M                  GENMASK(16, 16)
+#define HSIO_MPLL_CFG_MPLL_EN_X(x)               (((x) & GENMASK(16, 16)) >> 16)
+
+#define HSIO_MPLL_CFG_SSC_REF_CLK_SEL(x)         (((x) << 7) & GENMASK(15, 7))
+#define HSIO_MPLL_CFG_SSC_REF_CLK_SEL_M          GENMASK(15, 7)
+#define HSIO_MPLL_CFG_SSC_REF_CLK_SEL_X(x)       (((x) & GENMASK(15, 7)) >> 7)
+
+#define HSIO_MPLL_CFG_MPLL_MULTIPLIER(x)         ((x) & GENMASK(6, 0))
+#define HSIO_MPLL_CFG_MPLL_MULTIPLIER_M          GENMASK(6, 0)
+#define HSIO_MPLL_CFG_MPLL_MULTIPLIER_X(x)       ((x) & GENMASK(6, 0))
+
+/*      HSIO:SD:SD_STAT */
+#define HSIO_SD_STAT(g)           __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 12, 0, 1, 4)
+
+#define HSIO_SD_STAT_MPLL_STATE(x)               (((x) << 6) & GENMASK(6, 6))
+#define HSIO_SD_STAT_MPLL_STATE_M                GENMASK(6, 6)
+#define HSIO_SD_STAT_MPLL_STATE_X(x)             (((x) & GENMASK(6, 6)) >> 6)
+
+#define HSIO_SD_STAT_TX_STATE(x)                 (((x) << 5) & GENMASK(5, 5))
+#define HSIO_SD_STAT_TX_STATE_M                  GENMASK(5, 5)
+#define HSIO_SD_STAT_TX_STATE_X(x)               (((x) & GENMASK(5, 5)) >> 5)
+
+#define HSIO_SD_STAT_TX_DETECT_RX_RESULT(x)      (((x) << 4) & GENMASK(4, 4))
+#define HSIO_SD_STAT_TX_DETECT_RX_RESULT_M       GENMASK(4, 4)
+#define HSIO_SD_STAT_TX_DETECT_RX_RESULT_X(x)    (((x) & GENMASK(4, 4)) >> 4)
+
+#define HSIO_SD_STAT_TX_DETECT_RX_ACK(x)         (((x) << 3) & GENMASK(3, 3))
+#define HSIO_SD_STAT_TX_DETECT_RX_ACK_M          GENMASK(3, 3)
+#define HSIO_SD_STAT_TX_DETECT_RX_ACK_X(x)       (((x) & GENMASK(3, 3)) >> 3)
+
+#define HSIO_SD_STAT_TX_CM_STATE(x)              (((x) << 2) & GENMASK(2, 2))
+#define HSIO_SD_STAT_TX_CM_STATE_M               GENMASK(2, 2)
+#define HSIO_SD_STAT_TX_CM_STATE_X(x)            (((x) & GENMASK(2, 2)) >> 2)
+
+#define HSIO_SD_STAT_RX_VALID(x)                 (((x) << 1) & GENMASK(1, 1))
+#define HSIO_SD_STAT_RX_VALID_M                  GENMASK(1, 1)
+#define HSIO_SD_STAT_RX_VALID_X(x)               (((x) & GENMASK(1, 1)) >> 1)
+
+#define HSIO_SD_STAT_RX_PLL_STATE(x)             ((x) & GENMASK(0, 0))
+#define HSIO_SD_STAT_RX_PLL_STATE_M              GENMASK(0, 0)
+#define HSIO_SD_STAT_RX_PLL_STATE_X(x)           ((x) & GENMASK(0, 0))
+
+/*      HSIO:SD:CR_ACCESS */
+#define HSIO_CR_ACCESS(g)         __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 16, 0, 1, 4)
+
+#define HSIO_CR_ACCESS_WRITE(x)                  (((x) << 19) & GENMASK(19, 19))
+#define HSIO_CR_ACCESS_WRITE_M                   GENMASK(19, 19)
+#define HSIO_CR_ACCESS_WRITE_X(x)                (((x) & GENMASK(19, 19)) >> 19)
+
+#define HSIO_CR_ACCESS_READ(x)                   (((x) << 18) & GENMASK(18, 18))
+#define HSIO_CR_ACCESS_READ_M                    GENMASK(18, 18)
+#define HSIO_CR_ACCESS_READ_X(x)                 (((x) & GENMASK(18, 18)) >> 18)
+
+#define HSIO_CR_ACCESS_CAP_DATA(x)               (((x) << 17) & GENMASK(17, 17))
+#define HSIO_CR_ACCESS_CAP_DATA_M                GENMASK(17, 17)
+#define HSIO_CR_ACCESS_CAP_DATA_X(x)             (((x) & GENMASK(17, 17)) >> 17)
+
+#define HSIO_CR_ACCESS_CAP_ADDR(x)               (((x) << 16) & GENMASK(16, 16))
+#define HSIO_CR_ACCESS_CAP_ADDR_M                GENMASK(16, 16)
+#define HSIO_CR_ACCESS_CAP_ADDR_X(x)             (((x) & GENMASK(16, 16)) >> 16)
+
+#define HSIO_CR_ACCESS_DATA_IN(x)                ((x) & GENMASK(15, 0))
+#define HSIO_CR_ACCESS_DATA_IN_M                 GENMASK(15, 0)
+#define HSIO_CR_ACCESS_DATA_IN_X(x)              ((x) & GENMASK(15, 0))
+
+/*      HSIO:SD:CR_OUTPUT */
+#define HSIO_CR_OUTPUT(g)         __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 20, 0, 1, 4)
+
+#define HSIO_CR_OUTPUT_ACK(x)                    (((x) << 16) & GENMASK(16, 16))
+#define HSIO_CR_OUTPUT_ACK_M                     GENMASK(16, 16)
+#define HSIO_CR_OUTPUT_ACK_X(x)                  (((x) & GENMASK(16, 16)) >> 16)
+
+#define HSIO_CR_OUTPUT_DATA_OUT(x)               ((x) & GENMASK(15, 0))
+#define HSIO_CR_OUTPUT_DATA_OUT_M                GENMASK(15, 0)
+#define HSIO_CR_OUTPUT_DATA_OUT_X(x)             ((x) & GENMASK(15, 0))
+
+/*      HSIO:SD:SYNC_ETH_SD_CFG */
+#define HSIO_SYNC_ETH_SD_CFG(g)   __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 24, 0, 1, 4)
+
+#define HSIO_SYNC_ETH_SD_CFG_SD_RECO_CLK_DIV(x)  (((x) << 4) & GENMASK(5, 4))
+#define HSIO_SYNC_ETH_SD_CFG_SD_RECO_CLK_DIV_M   GENMASK(5, 4)
+#define HSIO_SYNC_ETH_SD_CFG_SD_RECO_CLK_DIV_X(x) (((x) & GENMASK(5, 4)) >> 4)
+
+#define HSIO_SYNC_ETH_SD_CFG_SD_LINK_STAT_ENA(x) (((x) << 1) & GENMASK(1, 1))
+#define HSIO_SYNC_ETH_SD_CFG_SD_LINK_STAT_ENA_M  GENMASK(1, 1)
+#define HSIO_SYNC_ETH_SD_CFG_SD_LINK_STAT_ENA_X(x) (((x) & GENMASK(1, 1)) >> 1)
+
+#define HSIO_SYNC_ETH_SD_CFG_SD_AUTO_SQUELCH_ENA(x) ((x) & GENMASK(0, 0))
+#define HSIO_SYNC_ETH_SD_CFG_SD_AUTO_SQUELCH_ENA_M GENMASK(0, 0)
+#define HSIO_SYNC_ETH_SD_CFG_SD_AUTO_SQUELCH_ENA_X(x) ((x) & GENMASK(0, 0))
+
+/*      HSIO:SD:SIGDET_CFG */
+#define HSIO_SIGDET_CFG(g)        __REG(TARGET_HSIO,\
+					0, 1, 8, g, 3, 32, 28, 0, 1, 4)
+
+#define HSIO_SIGDET_CFG_SD_SEL(x)                (((x) << 2) & GENMASK(2, 2))
+#define HSIO_SIGDET_CFG_SD_SEL_M                 GENMASK(2, 2)
+#define HSIO_SIGDET_CFG_SD_SEL_X(x)              (((x) & GENMASK(2, 2)) >> 2)
+
+#define HSIO_SIGDET_CFG_SD_POL(x)                (((x) << 1) & GENMASK(1, 1))
+#define HSIO_SIGDET_CFG_SD_POL_M                 GENMASK(1, 1)
+#define HSIO_SIGDET_CFG_SD_POL_X(x)              (((x) & GENMASK(1, 1)) >> 1)
+
+#define HSIO_SIGDET_CFG_SD_ENA(x)                ((x) & GENMASK(0, 0))
+#define HSIO_SIGDET_CFG_SD_ENA_M                 GENMASK(0, 0)
+#define HSIO_SIGDET_CFG_SD_ENA_X(x)              ((x) & GENMASK(0, 0))
+
+/*      HSIO:HW_CFGSTAT:HW_CFG */
+#define HSIO_HW_CFG               __REG(TARGET_HSIO,\
+					0, 1, 104, 0, 1, 52, 0, 0, 1, 4)
+
+#define HSIO_HW_CFG_RGMII_1_CFG(x)               (((x) << 15) & GENMASK(15, 15))
+#define HSIO_HW_CFG_RGMII_1_CFG_M                GENMASK(15, 15)
+#define HSIO_HW_CFG_RGMII_1_CFG_X(x)             (((x) & GENMASK(15, 15)) >> 15)
+
+#define HSIO_HW_CFG_RGMII_0_CFG(x)               (((x) << 14) & GENMASK(14, 14))
+#define HSIO_HW_CFG_RGMII_0_CFG_M                GENMASK(14, 14)
+#define HSIO_HW_CFG_RGMII_0_CFG_X(x)             (((x) & GENMASK(14, 14)) >> 14)
+
+#define HSIO_HW_CFG_RGMII_ENA(x)                 (((x) << 12) & GENMASK(13, 12))
+#define HSIO_HW_CFG_RGMII_ENA_M                  GENMASK(13, 12)
+#define HSIO_HW_CFG_RGMII_ENA_X(x)               (((x) & GENMASK(13, 12)) >> 12)
+
+#define HSIO_HW_CFG_SD6G_0_CFG(x)                (((x) << 11) & GENMASK(11, 11))
+#define HSIO_HW_CFG_SD6G_0_CFG_M                 GENMASK(11, 11)
+#define HSIO_HW_CFG_SD6G_0_CFG_X(x)              (((x) & GENMASK(11, 11)) >> 11)
+
+#define HSIO_HW_CFG_SD6G_1_CFG(x)                (((x) << 10) & GENMASK(10, 10))
+#define HSIO_HW_CFG_SD6G_1_CFG_M                 GENMASK(10, 10)
+#define HSIO_HW_CFG_SD6G_1_CFG_X(x)              (((x) & GENMASK(10, 10)) >> 10)
+
+#define HSIO_HW_CFG_GMII_ENA(x)                  (((x) << 2) & GENMASK(9, 2))
+#define HSIO_HW_CFG_GMII_ENA_M                   GENMASK(9, 2)
+#define HSIO_HW_CFG_GMII_ENA_X(x)                (((x) & GENMASK(9, 2)) >> 2)
+
+#define HSIO_HW_CFG_QSGMII_ENA(x)                ((x) & GENMASK(1, 0))
+#define HSIO_HW_CFG_QSGMII_ENA_M                 GENMASK(1, 0)
+#define HSIO_HW_CFG_QSGMII_ENA_X(x)              ((x) & GENMASK(1, 0))
+
+/*      HSIO:HW_CFGSTAT:GPIO_PI_CFG */
+#define HSIO_GPIO_PI_CFG          __REG(TARGET_HSIO,\
+					0, 1, 104, 0, 1, 52, 4, 0, 1, 4)
+
+#define HSIO_GPIO_PI_CFG_PI_MUX_ENA(x)           ((x) & GENMASK(26, 0))
+#define HSIO_GPIO_PI_CFG_PI_MUX_ENA_M            GENMASK(26, 0)
+#define HSIO_GPIO_PI_CFG_PI_MUX_ENA_X(x)         ((x) & GENMASK(26, 0))
+
+/*      HSIO:HW_CFGSTAT:QSGMII_CFG */
+#define HSIO_QSGMII_CFG           __REG(TARGET_HSIO,\
+					0, 1, 104, 0, 1, 52, 8, 0, 1, 4)
+
+#define HSIO_QSGMII_CFG_SHYST_DIS(x)             (((x) << 4) & GENMASK(4, 4))
+#define HSIO_QSGMII_CFG_SHYST_DIS_M              GENMASK(4, 4)
+#define HSIO_QSGMII_CFG_SHYST_DIS_X(x)           (((x) & GENMASK(4, 4)) >> 4)
+
+#define HSIO_QSGMII_CFG_E_DET_ENA(x)             (((x) << 3) & GENMASK(3, 3))
+#define HSIO_QSGMII_CFG_E_DET_ENA_M              GENMASK(3, 3)
+#define HSIO_QSGMII_CFG_E_DET_ENA_X(x)           (((x) & GENMASK(3, 3)) >> 3)
+
+#define HSIO_QSGMII_CFG_USE_I1_ENA(x)            (((x) << 2) & GENMASK(2, 2))
+#define HSIO_QSGMII_CFG_USE_I1_ENA_M             GENMASK(2, 2)
+#define HSIO_QSGMII_CFG_USE_I1_ENA_X(x)          (((x) & GENMASK(2, 2)) >> 2)
+
+#define HSIO_QSGMII_CFG_FLIP_LANES(x)            ((x) & GENMASK(1, 0))
+#define HSIO_QSGMII_CFG_FLIP_LANES_M             GENMASK(1, 0)
+#define HSIO_QSGMII_CFG_FLIP_LANES_X(x)          ((x) & GENMASK(1, 0))
+
+/*      HSIO:HW_CFGSTAT:QSGMII_STAT */
+#define HSIO_QSGMII_STAT(r)       __REG(TARGET_HSIO,\
+					0, 1, 104, 0, 1, 52, 12, r, 2, 4)
+
+#define HSIO_QSGMII_STAT_DELAY_VAR_X200PS(x)     (((x) << 2) & GENMASK(7, 2))
+#define HSIO_QSGMII_STAT_DELAY_VAR_X200PS_M      GENMASK(7, 2)
+#define HSIO_QSGMII_STAT_DELAY_VAR_X200PS_X(x)   (((x) & GENMASK(7, 2)) >> 2)
+
+#define HSIO_QSGMII_STAT_SYNC(x)                 ((x) & GENMASK(1, 0))
+#define HSIO_QSGMII_STAT_SYNC_M                  GENMASK(1, 0)
+#define HSIO_QSGMII_STAT_SYNC_X(x)               ((x) & GENMASK(1, 0))
+
+/*      HSIO:HW_CFGSTAT:RGMII_CFG */
+#define HSIO_RGMII_CFG(r)         __REG(TARGET_HSIO,\
+					0, 1, 104, 0, 1, 52, 20, r, 2, 4)
+
+#define HSIO_RGMII_CFG_IB_RX_LINK_STATUS(x)      (((x) << 15) & GENMASK(15, 15))
+#define HSIO_RGMII_CFG_IB_RX_LINK_STATUS_M       GENMASK(15, 15)
+#define HSIO_RGMII_CFG_IB_RX_LINK_STATUS_X(x)    (((x) & GENMASK(15, 15)) >> 15)
+
+#define HSIO_RGMII_CFG_IB_RX_DUPLEX(x)           (((x) << 14) & GENMASK(14, 14))
+#define HSIO_RGMII_CFG_IB_RX_DUPLEX_M            GENMASK(14, 14)
+#define HSIO_RGMII_CFG_IB_RX_DUPLEX_X(x)         (((x) & GENMASK(14, 14)) >> 14)
+
+#define HSIO_RGMII_CFG_IB_RX_SPEED(x)            (((x) << 12) & GENMASK(13, 12))
+#define HSIO_RGMII_CFG_IB_RX_SPEED_M             GENMASK(13, 12)
+#define HSIO_RGMII_CFG_IB_RX_SPEED_X(x)          (((x) & GENMASK(13, 12)) >> 12)
+
+#define HSIO_RGMII_CFG_IB_TX_LINK_STATUS(x)      (((x) << 11) & GENMASK(11, 11))
+#define HSIO_RGMII_CFG_IB_TX_LINK_STATUS_M       GENMASK(11, 11)
+#define HSIO_RGMII_CFG_IB_TX_LINK_STATUS_X(x)    (((x) & GENMASK(11, 11)) >> 11)
+
+#define HSIO_RGMII_CFG_IB_TX_FDX(x)              (((x) << 10) & GENMASK(10, 10))
+#define HSIO_RGMII_CFG_IB_TX_FDX_M               GENMASK(10, 10)
+#define HSIO_RGMII_CFG_IB_TX_FDX_X(x)            (((x) & GENMASK(10, 10)) >> 10)
+
+#define HSIO_RGMII_CFG_IB_TX_MII_SPD(x)          (((x) << 9) & GENMASK(9, 9))
+#define HSIO_RGMII_CFG_IB_TX_MII_SPD_M           GENMASK(9, 9)
+#define HSIO_RGMII_CFG_IB_TX_MII_SPD_X(x)        (((x) & GENMASK(9, 9)) >> 9)
+
+#define HSIO_RGMII_CFG_IB_TX_SPD_1G(x)           (((x) << 8) & GENMASK(8, 8))
+#define HSIO_RGMII_CFG_IB_TX_SPD_1G_M            GENMASK(8, 8)
+#define HSIO_RGMII_CFG_IB_TX_SPD_1G_X(x)         (((x) & GENMASK(8, 8)) >> 8)
+
+#define HSIO_RGMII_CFG_IB_TX_ENA(x)              (((x) << 7) & GENMASK(7, 7))
+#define HSIO_RGMII_CFG_IB_TX_ENA_M               GENMASK(7, 7)
+#define HSIO_RGMII_CFG_IB_TX_ENA_X(x)            (((x) & GENMASK(7, 7)) >> 7)
+
+#define HSIO_RGMII_CFG_IB_RX_ENA(x)              (((x) << 6) & GENMASK(6, 6))
+#define HSIO_RGMII_CFG_IB_RX_ENA_M               GENMASK(6, 6)
+#define HSIO_RGMII_CFG_IB_RX_ENA_X(x)            (((x) & GENMASK(6, 6)) >> 6)
+
+#define HSIO_RGMII_CFG_IB_ENA(x)                 (((x) << 5) & GENMASK(5, 5))
+#define HSIO_RGMII_CFG_IB_ENA_M                  GENMASK(5, 5)
+#define HSIO_RGMII_CFG_IB_ENA_X(x)               (((x) & GENMASK(5, 5)) >> 5)
+
+#define HSIO_RGMII_CFG_TX_CLK_CFG(x)             (((x) << 2) & GENMASK(4, 2))
+#define HSIO_RGMII_CFG_TX_CLK_CFG_M              GENMASK(4, 2)
+#define HSIO_RGMII_CFG_TX_CLK_CFG_X(x)           (((x) & GENMASK(4, 2)) >> 2)
+
+#define HSIO_RGMII_CFG_RGMII_TX_RST(x)           (((x) << 1) & GENMASK(1, 1))
+#define HSIO_RGMII_CFG_RGMII_TX_RST_M            GENMASK(1, 1)
+#define HSIO_RGMII_CFG_RGMII_TX_RST_X(x)         (((x) & GENMASK(1, 1)) >> 1)
+
+#define HSIO_RGMII_CFG_RGMII_RX_RST(x)           ((x) & GENMASK(0, 0))
+#define HSIO_RGMII_CFG_RGMII_RX_RST_M            GENMASK(0, 0)
+#define HSIO_RGMII_CFG_RGMII_RX_RST_X(x)         ((x) & GENMASK(0, 0))
+
+/*      HSIO:HW_CFGSTAT:RMII_CFG */
+#define HSIO_RMII_CFG(r)          __REG(TARGET_HSIO,\
+					0, 1, 104, 0, 1, 52, 28, r, 2, 4)
+
+#define HSIO_RMII_CFG_REF_CLK_SEL(x)             (((x) << 6) & GENMASK(6, 6))
+#define HSIO_RMII_CFG_REF_CLK_SEL_M              GENMASK(6, 6)
+#define HSIO_RMII_CFG_REF_CLK_SEL_X(x)           (((x) & GENMASK(6, 6)) >> 6)
+
+#define HSIO_RMII_CFG_CFG_TX_EDGE(x)             (((x) << 5) & GENMASK(5, 5))
+#define HSIO_RMII_CFG_CFG_TX_EDGE_M              GENMASK(5, 5)
+#define HSIO_RMII_CFG_CFG_TX_EDGE_X(x)           (((x) & GENMASK(5, 5)) >> 5)
+
+#define HSIO_RMII_CFG_FDX_CFG(x)                 (((x) << 4) & GENMASK(4, 4))
+#define HSIO_RMII_CFG_FDX_CFG_M                  GENMASK(4, 4)
+#define HSIO_RMII_CFG_FDX_CFG_X(x)               (((x) & GENMASK(4, 4)) >> 4)
+
+#define HSIO_RMII_CFG_SPEED_CFG(x)               (((x) << 3) & GENMASK(3, 3))
+#define HSIO_RMII_CFG_SPEED_CFG_M                GENMASK(3, 3)
+#define HSIO_RMII_CFG_SPEED_CFG_X(x)             (((x) & GENMASK(3, 3)) >> 3)
+
+#define HSIO_RMII_CFG_RMII_TX_RST(x)             (((x) << 2) & GENMASK(2, 2))
+#define HSIO_RMII_CFG_RMII_TX_RST_M              GENMASK(2, 2)
+#define HSIO_RMII_CFG_RMII_TX_RST_X(x)           (((x) & GENMASK(2, 2)) >> 2)
+
+#define HSIO_RMII_CFG_RMII_RX_RST(x)             (((x) << 1) & GENMASK(1, 1))
+#define HSIO_RMII_CFG_RMII_RX_RST_M              GENMASK(1, 1)
+#define HSIO_RMII_CFG_RMII_RX_RST_X(x)           (((x) & GENMASK(1, 1)) >> 1)
+
+#define HSIO_RMII_CFG_RMII_ENA(x)                ((x) & GENMASK(0, 0))
+#define HSIO_RMII_CFG_RMII_ENA_M                 GENMASK(0, 0)
+#define HSIO_RMII_CFG_RMII_ENA_X(x)              ((x) & GENMASK(0, 0))
+
+/*      HSIO:HW_CFGSTAT:DLL_CFG */
+#define HSIO_DLL_CFG(r)           __REG(TARGET_HSIO,\
+					0, 1, 104, 0, 1, 52, 36, r, 4, 4)
+
+#define HSIO_DLL_CFG_DLL_CLK_ENA(x)              (((x) << 20) & GENMASK(20, 20))
+#define HSIO_DLL_CFG_DLL_CLK_ENA_M               GENMASK(20, 20)
+#define HSIO_DLL_CFG_DLL_CLK_ENA_X(x)            (((x) & GENMASK(20, 20)) >> 20)
+
+#define HSIO_DLL_CFG_BIST_PASS(x)                (((x) << 19) & GENMASK(19, 19))
+#define HSIO_DLL_CFG_BIST_PASS_M                 GENMASK(19, 19)
+#define HSIO_DLL_CFG_BIST_PASS_X(x)              (((x) & GENMASK(19, 19)) >> 19)
+
+#define HSIO_DLL_CFG_BIST_END(x)                 (((x) << 18) & GENMASK(18, 18))
+#define HSIO_DLL_CFG_BIST_END_M                  GENMASK(18, 18)
+#define HSIO_DLL_CFG_BIST_END_X(x)               (((x) & GENMASK(18, 18)) >> 18)
+
+#define HSIO_DLL_CFG_BIST_START(x)               (((x) << 17) & GENMASK(17, 17))
+#define HSIO_DLL_CFG_BIST_START_M                GENMASK(17, 17)
+#define HSIO_DLL_CFG_BIST_START_X(x)             (((x) & GENMASK(17, 17)) >> 17)
+
+#define HSIO_DLL_CFG_TAP_SEL(x)                  (((x) << 10) & GENMASK(16, 10))
+#define HSIO_DLL_CFG_TAP_SEL_M                   GENMASK(16, 10)
+#define HSIO_DLL_CFG_TAP_SEL_X(x)                (((x) & GENMASK(16, 10)) >> 10)
+
+#define HSIO_DLL_CFG_TAP_ADJ(x)                  (((x) << 3) & GENMASK(9, 3))
+#define HSIO_DLL_CFG_TAP_ADJ_M                   GENMASK(9, 3)
+#define HSIO_DLL_CFG_TAP_ADJ_X(x)                (((x) & GENMASK(9, 3)) >> 3)
+
+#define HSIO_DLL_CFG_DELAY_ENA(x)                (((x) << 2) & GENMASK(2, 2))
+#define HSIO_DLL_CFG_DELAY_ENA_M                 GENMASK(2, 2)
+#define HSIO_DLL_CFG_DELAY_ENA_X(x)              (((x) & GENMASK(2, 2)) >> 2)
+
+#define HSIO_DLL_CFG_DLL_ENA(x)                  (((x) << 1) & GENMASK(1, 1))
+#define HSIO_DLL_CFG_DLL_ENA_M                   GENMASK(1, 1)
+#define HSIO_DLL_CFG_DLL_ENA_X(x)                (((x) & GENMASK(1, 1)) >> 1)
+
+#define HSIO_DLL_CFG_DLL_RST(x)                  ((x) & GENMASK(0, 0))
+#define HSIO_DLL_CFG_DLL_RST_M                   GENMASK(0, 0)
+#define HSIO_DLL_CFG_DLL_RST_X(x)                ((x) & GENMASK(0, 0))
+
+#endif /* _LAN966X_HSIO_REGS_H_ */
diff --git a/include/dt-bindings/phy/lan966x_serdes.h b/include/dt-bindings/phy/lan966x_serdes.h
new file mode 100644
index 000000000000..0e2097b1bfcf
--- /dev/null
+++ b/include/dt-bindings/phy/lan966x_serdes.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+
+#ifndef __PHY_LAN966X_SERDES_H__
+#define __PHY_LAN966X_SERDES_H__
+
+#define CU(x)		(x)
+#define CU_MAX		CU(2)
+#define SERDES6G(x)	(CU_MAX + 1 + (x))
+#define SERDES6G_MAX	SERDES6G(3)
+#define RG(x)		(SERDES6G_MAX + 1 + (x))
+#define RG_MAX		RG(2)
+#define SERDES_MAX	(RG_MAX + 1)
+
+#endif
-- 
2.31.1

