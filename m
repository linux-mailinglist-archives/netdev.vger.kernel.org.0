Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC242CD3A5
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 11:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388939AbgLCKc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 05:32:28 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:61478 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388757AbgLCKc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 05:32:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606991544; x=1638527544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CWON52FSk/QskMbW7MVI2xmdzpVN5cCk7c1Pv2ByfbY=;
  b=YGIeu9LcWQsDGbmXh6zOXVKIVqW7fe5ebblQ9aAvjd7kB+hVAnQ0Q4NH
   x/goVfG8dWCHhXFDVuaS0C4lkD2a06GQCd4UhvKiSWIC0IJSKJFcpnlpx
   0E4JRlSAbdlWRLNiEqJdKHZB63c17p1cQdNXi+DKgGp8fIORJz/dwBdg4
   3E1s5DC+XYtIC5fXPOVFOdlcIuUahiMMmd/yPkFxbJ5LT/WOOJnJp3ebY
   VYYLdz267t2uJIRXLrSx7Vh00gvWs3mWf9Ruappgu0udwZCcnagqUMK2G
   E01/SrttluZzhXzffA9c/wh60SJ48312gzRrUl8YslyX80j0HRngfBCe7
   Q==;
IronPort-SDR: YXcAMWMckqumYPM/79brwriwoACvdyaXeq7n+8yZzkuLTaB69SNHFTPPCSaJ9W7jFI8TfPgAVu
 mQe93LHiQ6ZV0viIlxMQpVafr7EPG0290CyjBz75rSy5APARuu2t3cQNqXAB84MeOdKMvgrLpA
 G9eoZUWQDv8dk171X5MXmBsczP69G1SDPFZ0TaEd2yGoJwA6NvQZMxh+aZ7v6gcU38pCTdY52h
 uG0kR45rU3/JdLByXlu/GhcrxVlgg13dQKFt8uVu0TNG0YcmS1B4hLhcyBnvTP/38jWFXhS/M7
 GE0=
X-IronPort-AV: E=Sophos;i="5.78,389,1599548400"; 
   d="scan'208";a="100721577"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2020 03:30:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 03:30:38 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 3 Dec 2020 03:30:36 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Date:   Thu, 3 Dec 2020 11:30:14 +0100
Message-ID: <20201203103015.3735373-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203103015.3735373-1-steen.hegelund@microchip.com>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the Microchip Sparx5 ethernet serdes PHY driver for the 6G, 10G and 25G
interfaces available in the Sparx5 SoC.

Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/phy/Kconfig                        |    3 +-
 drivers/phy/Makefile                       |    1 +
 drivers/phy/microchip/Kconfig              |   12 +
 drivers/phy/microchip/Makefile             |    6 +
 drivers/phy/microchip/sparx5_serdes.c      | 2434 ++++++++++++++++++
 drivers/phy/microchip/sparx5_serdes.h      |  129 +
 drivers/phy/microchip/sparx5_serdes_regs.h | 2695 ++++++++++++++++++++
 7 files changed, 5279 insertions(+), 1 deletion(-)
 create mode 100644 drivers/phy/microchip/Kconfig
 create mode 100644 drivers/phy/microchip/Makefile
 create mode 100644 drivers/phy/microchip/sparx5_serdes.c
 create mode 100644 drivers/phy/microchip/sparx5_serdes.h
 create mode 100644 drivers/phy/microchip/sparx5_serdes_regs.h

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 01b53f86004c..f6a094c81e86 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -66,9 +66,11 @@ source "drivers/phy/broadcom/Kconfig"
 source "drivers/phy/cadence/Kconfig"
 source "drivers/phy/freescale/Kconfig"
 source "drivers/phy/hisilicon/Kconfig"
+source "drivers/phy/intel/Kconfig"
 source "drivers/phy/lantiq/Kconfig"
 source "drivers/phy/marvell/Kconfig"
 source "drivers/phy/mediatek/Kconfig"
+source "drivers/phy/microchip/Kconfig"
 source "drivers/phy/motorola/Kconfig"
 source "drivers/phy/mscc/Kconfig"
 source "drivers/phy/qualcomm/Kconfig"
@@ -80,7 +82,6 @@ source "drivers/phy/socionext/Kconfig"
 source "drivers/phy/st/Kconfig"
 source "drivers/phy/tegra/Kconfig"
 source "drivers/phy/ti/Kconfig"
-source "drivers/phy/intel/Kconfig"
 source "drivers/phy/xilinx/Kconfig"
 
 endmenu
diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 6eb2916773c5..7d39a11d0f75 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -19,6 +19,7 @@ obj-y					+= allwinner/	\
 					   lantiq/	\
 					   marvell/	\
 					   mediatek/	\
+					   microchip/	\
 					   motorola/	\
 					   mscc/	\
 					   qualcomm/	\
diff --git a/drivers/phy/microchip/Kconfig b/drivers/phy/microchip/Kconfig
new file mode 100644
index 000000000000..0b1a818e01b8
--- /dev/null
+++ b/drivers/phy/microchip/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Phy drivers for Microchip devices
+#
+
+config PHY_SPARX5_SERDES
+	tristate "Microchip Sparx5 SerDes PHY driver"
+	select GENERIC_PHY
+	depends on OF
+	depends on HAS_IOMEM
+	help
+	  Enable this for support of the 10G/25G SerDes on Microchip Sparx5.
diff --git a/drivers/phy/microchip/Makefile b/drivers/phy/microchip/Makefile
new file mode 100644
index 000000000000..7b98345712aa
--- /dev/null
+++ b/drivers/phy/microchip/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the Microchip phy drivers.
+#
+
+obj-$(CONFIG_PHY_SPARX5_SERDES) := sparx5_serdes.o
diff --git a/drivers/phy/microchip/sparx5_serdes.c b/drivers/phy/microchip/sparx5_serdes.c
new file mode 100644
index 000000000000..0b9549836f1b
--- /dev/null
+++ b/drivers/phy/microchip/sparx5_serdes.c
@@ -0,0 +1,2434 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Microchip Sparx5 Switch SerDes driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
+ *
+ * The Sparx5 Chip Register Model can be browsed at this location:
+ * https://github.com/microchip-ung/sparx-5_reginfo
+ */
+#include <linux/printk.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/phy.h>
+#include <linux/phy/phy.h>
+
+#include "sparx5_serdes.h"
+
+#define SPX5_CMU_MAX          14
+
+#define SPX5_SERDES_10G_START 13
+#define SPX5_SERDES_25G_START 25
+
+enum sparx5_10g28cmu_mode {
+	SPX5_SD10G28_CMU_MAIN = 0,
+	SPX5_SD10G28_CMU_AUX1 = 1,
+	SPX5_SD10G28_CMU_AUX2 = 3,
+	SPX5_SD10G28_CMU_NONE = 4,
+};
+
+enum sparx5_sd25g28_mode_preset_type {
+	SPX5_SD25G28_MODE_PRESET_25000,
+	SPX5_SD25G28_MODE_PRESET_10000,
+	SPX5_SD25G28_MODE_PRESET_5000,
+	SPX5_SD25G28_MODE_PRESET_SD_2G5,
+	SPX5_SD25G28_MODE_PRESET_1000BASEX,
+};
+
+enum sparx5_sd10g28_mode_preset_type {
+	SPX5_SD10G28_MODE_PRESET_10000,
+	SPX5_SD10G28_MODE_PRESET_SFI_5000_6G,
+	SPX5_SD10G28_MODE_PRESET_SFI_5000_10G,
+	SPX5_SD10G28_MODE_PRESET_QSGMII,
+	SPX5_SD10G28_MODE_PRESET_SD_2G5,
+	SPX5_SD10G28_MODE_PRESET_1000BASEX,
+};
+
+struct sparx5_serdes_io_resource {
+	enum sparx5_serdes_target id;
+	phys_addr_t offset;
+};
+
+struct sparx5_sd25g28_mode_preset {
+	u8   bitwidth;
+	u8   tx_pre_div;
+	u8   fifo_ck_div;
+	u8   pre_divsel;
+	u8   vco_div_mode;
+	u8   sel_div;
+	u8   ck_bitwidth;
+	u8   subrate;
+	u8   com_txcal_en;
+	u8   com_tx_reserve_msb;
+	u8   com_tx_reserve_lsb;
+	u8   cfg_itx_ipcml_base;
+	u8   tx_reserve_lsb;
+	u8   tx_reserve_msb;
+	u8   bw;
+	u8   rxterm;
+	u8   dfe_tap;
+	u8   dfe_enable;
+	bool txmargin;
+	u8   cfg_ctle_rstn;
+	u8   r_dfe_rstn;
+	u8   cfg_pi_bw_3_0;
+	u8   tx_tap_dly;
+	u8   tx_tap_adv;
+};
+
+struct sparx5_sd25g28_media_preset {
+	u8 cfg_eq_c_force_3_0;
+	u8 cfg_vga_ctrl_byp_4_0;
+	u8 cfg_eq_r_force_3_0;
+	u8 cfg_en_adv;
+	u8 cfg_en_main;
+	u8 cfg_en_dly;
+	u8 cfg_tap_adv_3_0;
+	u8 cfg_tap_main;
+	u8 cfg_tap_dly_4_0;
+	u8 cfg_alos_thr_2_0;
+};
+
+struct sparx5_sd25g28_args {
+	u8                   if_width;     /* UDL if-width: 10/16/20/32/64 */
+	bool                 skip_cmu_cfg; /* Enable/disable CMU cfg */
+	enum sparx5_10g28cmu_mode cmu_sel; /* Device/Mode serdes uses */
+	bool                 no_pwrcycle;  /* Omit initial power-cycle */
+	bool                 txinvert;     /* Enable inversion of output data */
+	bool                 rxinvert;     /* Enable inversion of input data */
+	u16                  txswing;      /* Set output level */
+	u8                   rate;         /* Rate of network interface */
+	u8                   pi_bw_gen1;
+	u8                   duty_cycle;   /* Set output level to  half/full */
+	bool                 mute;         /* Mute Output Buffer */
+	bool                 reg_rst;
+	u8                   com_pll_reserve;
+};
+
+struct sparx5_sd25g28_params {
+	u8 reg_rst;
+	u8 cfg_jc_byp;
+	u8 cfg_common_reserve_7_0;
+	u8 r_reg_manual;
+	u8 r_d_width_ctrl_from_hwt;
+	u8 r_d_width_ctrl_2_0;
+	u8 r_txfifo_ck_div_pmad_2_0;
+	u8 r_rxfifo_ck_div_pmad_2_0;
+	u8 cfg_pll_lol_set;
+	u8 cfg_vco_div_mode_1_0;
+	u8 cfg_pre_divsel_1_0;
+	u8 cfg_sel_div_3_0;
+	u8 cfg_vco_start_code_3_0;
+	u8 cfg_pma_tx_ck_bitwidth_2_0;
+	u8 cfg_tx_prediv_1_0;
+	u8 cfg_rxdiv_sel_2_0;
+	u8 cfg_tx_subrate_2_0;
+	u8 cfg_rx_subrate_2_0;
+	u8 r_multi_lane_mode;
+	u8 cfg_cdrck_en;
+	u8 cfg_dfeck_en;
+	u8 cfg_dfe_pd;
+	u8 cfg_dfedmx_pd;
+	u8 cfg_dfetap_en_5_1;
+	u8 cfg_dmux_pd;
+	u8 cfg_dmux_clk_pd;
+	u8 cfg_erramp_pd;
+	u8 cfg_pi_dfe_en;
+	u8 cfg_pi_en;
+	u8 cfg_pd_ctle;
+	u8 cfg_summer_en;
+	u8 cfg_pmad_ck_pd;
+	u8 cfg_pd_clk;
+	u8 cfg_pd_cml;
+	u8 cfg_pd_driver;
+	u8 cfg_rx_reg_pu;
+	u8 cfg_pd_rms_det;
+	u8 cfg_dcdr_pd;
+	u8 cfg_ecdr_pd;
+	u8 cfg_pd_sq;
+	u8 cfg_itx_ipdriver_base_2_0;
+	u8 cfg_tap_dly_4_0;
+	u8 cfg_tap_main;
+	u8 cfg_en_main;
+	u8 cfg_tap_adv_3_0;
+	u8 cfg_en_adv;
+	u8 cfg_en_dly;
+	u8 cfg_iscan_en;
+	u8 l1_pcs_en_fast_iscan;
+	u8 l0_cfg_bw_1_0;
+	u8 l0_cfg_txcal_en;
+	u8 cfg_en_dummy;
+	u8 cfg_pll_reserve_3_0;
+	u8 l0_cfg_tx_reserve_15_8;
+	u8 l0_cfg_tx_reserve_7_0;
+	u8 cfg_tx_reserve_15_8;
+	u8 cfg_tx_reserve_7_0;
+	u8 cfg_bw_1_0;
+	u8 cfg_txcal_man_en;
+	u8 cfg_phase_man_4_0;
+	u8 cfg_quad_man_1_0;
+	u8 cfg_txcal_shift_code_5_0;
+	u8 cfg_txcal_valid_sel_3_0;
+	u8 cfg_txcal_en;
+	u8 cfg_cdr_kf_2_0;
+	u8 cfg_cdr_m_7_0;
+	u8 cfg_pi_bw_3_0;
+	u8 cfg_pi_steps_1_0;
+	u8 cfg_dis_2ndorder;
+	u8 cfg_ctle_rstn;
+	u8 r_dfe_rstn;
+	u8 cfg_alos_thr_2_0;
+	u8 cfg_itx_ipcml_base_1_0;
+	u8 cfg_rx_reserve_7_0;
+	u8 cfg_rx_reserve_15_8;
+	u8 cfg_rxterm_2_0;
+	u8 cfg_fom_selm;
+	u8 cfg_rx_sp_ctle_1_0;
+	u8 cfg_isel_ctle_1_0;
+	u8 cfg_vga_ctrl_byp_4_0;
+	u8 cfg_vga_byp;
+	u8 cfg_agc_adpt_byp;
+	u8 cfg_eqr_byp;
+	u8 cfg_eqr_force_3_0;
+	u8 cfg_eqc_force_3_0;
+	u8 cfg_sum_setcm_en;
+	u8 cfg_init_pos_iscan_6_0;
+	u8 cfg_init_pos_ipi_6_0;
+	u8 cfg_dfedig_m_2_0;
+	u8 cfg_en_dfedig;
+	u8 cfg_pi_DFE_en;
+	u8 cfg_tx2rx_lp_en;
+	u8 cfg_txlb_en;
+	u8 cfg_rx2tx_lp_en;
+	u8 cfg_rxlb_en;
+	u8 r_tx_pol_inv;
+	u8 r_rx_pol_inv;
+};
+
+struct sparx5_sd10g28_media_preset {
+	u8 cfg_en_adv;
+	u8 cfg_en_main;
+	u8 cfg_en_dly;
+	u8 cfg_tap_adv_3_0;
+	u8 cfg_tap_main;
+	u8 cfg_tap_dly_4_0;
+	u8 cfg_vga_ctrl_3_0;
+	u8 cfg_vga_cp_2_0;
+	u8 cfg_eq_res_3_0;
+	u8 cfg_eq_r_byp;
+	u8 cfg_eq_c_force_3_0;
+	u8 cfg_alos_thr_3_0;
+};
+
+struct sparx5_sd10g28_mode_preset {
+	u8                   bwidth;       /* interface width: 10/16/20/32/64 */
+	enum sparx5_10g28cmu_mode cmu_sel; /* Device/Mode serdes uses */
+	u8                   rate;         /* Rate of network interface */
+	u8                   dfe_tap;
+	u8                   dfe_enable;
+	u8                   pi_bw_gen1;
+	u8                   duty_cycle;   /* Set output level to  half/full */
+};
+
+struct sparx5_sd10g28_args {
+	bool                 skip_cmu_cfg; /* Enable/disable CMU cfg */
+	bool                 no_pwrcycle;  /* Omit initial power-cycle */
+	bool                 txinvert;     /* Enable inversion of output data */
+	bool                 rxinvert;     /* Enable inversion of input data */
+	bool                 txmargin;     /* Set output level to  half/full */
+	u16                  txswing;      /* Set output level */
+	bool                 mute;         /* Mute Output Buffer */
+	bool                 is_6g;
+	bool                 reg_rst;
+};
+
+struct sparx5_sd10g28_params {
+	u8 cmu_sel;
+	u8 is_6g;
+	u8 skip_cmu_cfg;
+	u8 cfg_lane_reserve_7_0;
+	u8 cfg_ssc_rtl_clk_sel;
+	u8 cfg_lane_reserve_15_8;
+	u8 cfg_txrate_1_0;
+	u8 cfg_rxrate_1_0;
+	u8 r_d_width_ctrl_2_0;
+	u8 cfg_pma_tx_ck_bitwidth_2_0;
+	u8 cfg_rxdiv_sel_2_0;
+	u8 r_pcs2pma_phymode_4_0;
+	u8 cfg_lane_id_2_0;
+	u8 cfg_cdrck_en;
+	u8 cfg_dfeck_en;
+	u8 cfg_dfe_pd;
+	u8 cfg_dfetap_en_5_1;
+	u8 cfg_erramp_pd;
+	u8 cfg_pi_DFE_en;
+	u8 cfg_pi_en;
+	u8 cfg_pd_ctle;
+	u8 cfg_summer_en;
+	u8 cfg_pd_rx_cktree;
+	u8 cfg_pd_clk;
+	u8 cfg_pd_cml;
+	u8 cfg_pd_driver;
+	u8 cfg_rx_reg_pu;
+	u8 cfg_d_cdr_pd;
+	u8 cfg_pd_sq;
+	u8 cfg_rxdet_en;
+	u8 cfg_rxdet_str;
+	u8 r_multi_lane_mode;
+	u8 cfg_en_adv;
+	u8 cfg_en_main;
+	u8 cfg_en_dly;
+	u8 cfg_tap_adv_3_0;
+	u8 cfg_tap_main;
+	u8 cfg_tap_dly_4_0;
+	u8 cfg_vga_ctrl_3_0;
+	u8 cfg_vga_cp_2_0;
+	u8 cfg_eq_res_3_0;
+	u8 cfg_eq_r_byp;
+	u8 cfg_eq_c_force_3_0;
+	u8 cfg_en_dfedig;
+	u8 cfg_sum_setcm_en;
+	u8 cfg_en_preemph;
+	u8 cfg_itx_ippreemp_base_1_0;
+	u8 cfg_itx_ipdriver_base_2_0;
+	u8 cfg_ibias_tune_reserve_5_0;
+	u8 cfg_txswing_half;
+	u8 cfg_dis_2nd_order;
+	u8 cfg_rx_ssc_lh;
+	u8 cfg_pi_floop_steps_1_0;
+	u8 cfg_pi_ext_dac_23_16;
+	u8 cfg_pi_ext_dac_15_8;
+	u8 cfg_iscan_ext_dac_7_0;
+	u8 cfg_cdr_kf_gen1_2_0;
+	u8 cfg_cdr_kf_gen2_2_0;
+	u8 cfg_cdr_kf_gen3_2_0;
+	u8 cfg_cdr_kf_gen4_2_0;
+	u8 r_cdr_m_gen1_7_0;
+	u8 cfg_pi_bw_gen1_3_0;
+	u8 cfg_pi_bw_gen2;
+	u8 cfg_pi_bw_gen3;
+	u8 cfg_pi_bw_gen4;
+	u8 cfg_pi_ext_dac_7_0;
+	u8 cfg_pi_steps;
+	u8 cfg_mp_max_3_0;
+	u8 cfg_rstn_dfedig;
+	u8 cfg_alos_thr_3_0;
+	u8 cfg_predrv_slewrate_1_0;
+	u8 cfg_itx_ipcml_base_1_0;
+	u8 cfg_ip_pre_base_1_0;
+	u8 r_cdr_m_gen2_7_0;
+	u8 r_cdr_m_gen3_7_0;
+	u8 r_cdr_m_gen4_7_0;
+	u8 r_en_auto_cdr_rstn;
+	u8 cfg_oscal_afe;
+	u8 cfg_pd_osdac_afe;
+	u8 cfg_resetb_oscal_afe[2];
+	u8 cfg_center_spreading;
+	u8 cfg_m_cnt_maxval_4_0;
+	u8 cfg_ncnt_maxval_7_0;
+	u8 cfg_ncnt_maxval_10_8;
+	u8 cfg_ssc_en;
+	u8 cfg_tx2rx_lp_en;
+	u8 cfg_txlb_en;
+	u8 cfg_rx2tx_lp_en;
+	u8 cfg_rxlb_en;
+	u8 r_tx_pol_inv;
+	u8 r_rx_pol_inv;
+	u8 fx_100;
+};
+
+static struct sparx5_sd25g28_media_preset media_presets_25g[] = {
+	{ /* ETH_MEDIA_DEFAULT */
+		.cfg_en_adv               = 0,
+		.cfg_en_main              = 1,
+		.cfg_en_dly               = 0,
+		.cfg_tap_adv_3_0          = 0,
+		.cfg_tap_main             = 1,
+		.cfg_tap_dly_4_0          = 0,
+		.cfg_eq_c_force_3_0       = 0xf,
+		.cfg_vga_ctrl_byp_4_0     = 4,
+		.cfg_eq_r_force_3_0       = 12,
+		.cfg_alos_thr_2_0         = 7,
+	},
+	{ /* ETH_MEDIA_SR */
+		.cfg_en_adv               = 1,
+		.cfg_en_main              = 1,
+		.cfg_en_dly               = 1,
+		.cfg_tap_adv_3_0          = 0,
+		.cfg_tap_main             = 1,
+		.cfg_tap_dly_4_0          = 0x10,
+		.cfg_eq_c_force_3_0       = 0xf,
+		.cfg_vga_ctrl_byp_4_0     = 8,
+		.cfg_eq_r_force_3_0       = 4,
+		.cfg_alos_thr_2_0         = 0,
+	},
+	{ /* ETH_MEDIA_DAC */
+		.cfg_en_adv               = 0,
+		.cfg_en_main              = 1,
+		.cfg_en_dly               = 0,
+		.cfg_tap_adv_3_0          = 0,
+		.cfg_tap_main             = 1,
+		.cfg_tap_dly_4_0          = 0,
+		.cfg_eq_c_force_3_0       = 0xf,
+		.cfg_vga_ctrl_byp_4_0     = 8,
+		.cfg_eq_r_force_3_0       = 0xc,
+		.cfg_alos_thr_2_0         = 0,
+	},
+};
+
+static struct sparx5_sd25g28_mode_preset mode_presets_25g[] = {
+	{ /* SPX5_SD25G28_MODE_PRESET_25000 */
+		.bitwidth           = 40,
+		.tx_pre_div         = 0,
+		.fifo_ck_div        = 0,
+		.pre_divsel         = 1,
+		.vco_div_mode       = 0,
+		.sel_div            = 15,
+		.ck_bitwidth        = 3,
+		.subrate            = 0,
+		.com_txcal_en       = 0,
+		.com_tx_reserve_msb = (0x26 << 1),
+		.com_tx_reserve_lsb = 0xf0,
+		.cfg_itx_ipcml_base = 0,
+		.tx_reserve_msb     = 0xcc,
+		.tx_reserve_lsb     = 0xfe,
+		.bw                 = 3,
+		.rxterm             = 0,
+		.dfe_enable         = 1,
+		.dfe_tap            = 0x1f,
+		.txmargin           = 1,
+		.cfg_ctle_rstn      = 1,
+		.r_dfe_rstn         = 1,
+		.cfg_pi_bw_3_0      = 0,
+		.tx_tap_dly         = 8,
+		.tx_tap_adv         = 0xc,
+	},
+	{ /* SPX5_SD25G28_MODE_PRESET_10000 */
+		.bitwidth           = 64,
+		.tx_pre_div         = 0,
+		.fifo_ck_div        = 2,
+		.pre_divsel         = 0,
+		.vco_div_mode       = 1,
+		.sel_div            = 9,
+		.ck_bitwidth        = 0,
+		.subrate            = 0,
+		.com_txcal_en       = 1,
+		.com_tx_reserve_msb = (0x20 << 1),
+		.com_tx_reserve_lsb = 0x40,
+		.cfg_itx_ipcml_base = 0,
+		.tx_reserve_msb     = 0x4c,
+		.tx_reserve_lsb     = 0x44,
+		.bw                 = 3,
+		.cfg_pi_bw_3_0      = 0,
+		.rxterm             = 3,
+		.dfe_enable         = 1,
+		.dfe_tap            = 0x1f,
+		.txmargin           = 0,
+		.cfg_ctle_rstn      = 1,
+		.r_dfe_rstn         = 1,
+		.tx_tap_dly         = 0,
+		.tx_tap_adv         = 0,
+	},
+	{ /* SPX5_SD25G28_MODE_PRESET_5000 */
+		.bitwidth           = 64,
+		.tx_pre_div         = 0,
+		.fifo_ck_div        = 2,
+		.pre_divsel         = 0,
+		.vco_div_mode       = 2,
+		.sel_div            = 9,
+		.ck_bitwidth        = 0,
+		.subrate            = 0,
+		.com_txcal_en       = 1,
+		.com_tx_reserve_msb = (0x20 << 1),
+		.com_tx_reserve_lsb = 0,
+		.cfg_itx_ipcml_base = 0,
+		.tx_reserve_msb     = 0xe,
+		.tx_reserve_lsb     = 0x80,
+		.bw                 = 0,
+		.rxterm             = 0,
+		.cfg_pi_bw_3_0      = 6,
+		.dfe_enable         = 0,
+		.dfe_tap            = 0,
+		.tx_tap_dly         = 0,
+		.tx_tap_adv         = 0,
+	},
+	{ /* SPX5_SD25G28_MODE_PRESET_SD_2G5 */
+		.bitwidth           = 10,
+		.tx_pre_div         = 0,
+		.fifo_ck_div        = 0,
+		.pre_divsel         = 0,
+		.vco_div_mode       = 1,
+		.sel_div            = 6,
+		.ck_bitwidth        = 3,
+		.subrate            = 2,
+		.com_txcal_en       = 1,
+		.com_tx_reserve_msb = (0x26 << 1),
+		.com_tx_reserve_lsb = (0xf << 4),
+		.cfg_itx_ipcml_base = 2,
+		.tx_reserve_msb     = 0x8,
+		.tx_reserve_lsb     = 0x8a,
+		.bw                 = 0,
+		.cfg_pi_bw_3_0      = 0,
+		.rxterm             = (1 << 2),
+		.dfe_enable         = 0,
+		.dfe_tap            = 0,
+		.tx_tap_dly         = 0,
+		.tx_tap_adv         = 0,
+	},
+	{ /* SPX5_SD25G28_MODE_PRESET_1000BASEX */
+		.bitwidth           = 10,
+		.tx_pre_div         = 0,
+		.fifo_ck_div        = 1,
+		.pre_divsel         = 0,
+		.vco_div_mode       = 1,
+		.sel_div            = 8,
+		.ck_bitwidth        = 3,
+		.subrate            = 3,
+		.com_txcal_en       = 1,
+		.com_tx_reserve_msb = (0x26 << 1),
+		.com_tx_reserve_lsb = 0xf0,
+		.cfg_itx_ipcml_base = 0,
+		.tx_reserve_msb     = 0x8,
+		.tx_reserve_lsb     = 0xce,
+		.bw                 = 0,
+		.rxterm             = 0,
+		.cfg_pi_bw_3_0      = 0,
+		.dfe_enable         = 0,
+		.dfe_tap            = 0,
+		.tx_tap_dly         = 0,
+		.tx_tap_adv         = 0,
+	},
+};
+
+static struct sparx5_sd10g28_media_preset media_presets_10g[] = {
+	{ /* ETH_MEDIA_DEFAULT */
+		.cfg_en_adv               = 0,
+		.cfg_en_main              = 1,
+		.cfg_en_dly               = 0,
+		.cfg_tap_adv_3_0          = 0,
+		.cfg_tap_main             = 1,
+		.cfg_tap_dly_4_0          = 0,
+		.cfg_vga_ctrl_3_0         = 5,
+		.cfg_vga_cp_2_0           = 0,
+		.cfg_eq_res_3_0           = 0xa,
+		.cfg_eq_r_byp             = 1,
+		.cfg_eq_c_force_3_0       = 0x8,
+		.cfg_alos_thr_3_0         = 0x3,
+	},
+	{ /* ETH_MEDIA_SR */
+		.cfg_en_adv               = 1,
+		.cfg_en_main              = 1,
+		.cfg_en_dly               = 1,
+		.cfg_tap_adv_3_0          = 0,
+		.cfg_tap_main             = 1,
+		.cfg_tap_dly_4_0          = 0xc,
+		.cfg_vga_ctrl_3_0         = 0xa,
+		.cfg_vga_cp_2_0           = 0x4,
+		.cfg_eq_res_3_0           = 0xa,
+		.cfg_eq_r_byp             = 1,
+		.cfg_eq_c_force_3_0       = 0xF,
+		.cfg_alos_thr_3_0         = 0x3,
+	},
+	{ /* ETH_MEDIA_DAC */
+		.cfg_en_adv               = 1,
+		.cfg_en_main              = 1,
+		.cfg_en_dly               = 1,
+		.cfg_tap_adv_3_0          = 12,
+		.cfg_tap_main             = 1,
+		.cfg_tap_dly_4_0          = 8,
+		.cfg_vga_ctrl_3_0         = 0xa,
+		.cfg_vga_cp_2_0           = 4,
+		.cfg_eq_res_3_0           = 0xa,
+		.cfg_eq_r_byp             = 1,
+		.cfg_eq_c_force_3_0       = 0xf,
+		.cfg_alos_thr_3_0         = 0x0,
+	}
+};
+
+static struct sparx5_sd10g28_mode_preset mode_presets_10g[] = {
+	{ /* SPX5_SD10G28_MODE_PRESET_10000 */
+		.bwidth           = 64,
+		.cmu_sel          = SPX5_SD10G28_CMU_MAIN,
+		.rate             = 0x0,
+		.dfe_enable       = 1,
+		.dfe_tap          = 0x1f,
+		.pi_bw_gen1       = 0x0,
+		.duty_cycle       = 0x2,
+	},
+	{ /* SPX5_SD10G28_MODE_PRESET_SFI_5000_6G */
+		.bwidth           = 16,
+		.cmu_sel          = SPX5_SD10G28_CMU_MAIN,
+		.rate             = 0x1,
+		.dfe_enable       = 0,
+		.dfe_tap          = 0,
+		.pi_bw_gen1       = 0x5,
+		.duty_cycle       = 0x0,
+	},
+	{ /* SPX5_SD10G28_MODE_PRESET_SFI_5000_10G */
+		.bwidth           = 64,
+		.cmu_sel          = SPX5_SD10G28_CMU_MAIN,
+		.rate             = 0x1,
+		.dfe_enable       = 0,
+		.dfe_tap          = 0,
+		.pi_bw_gen1       = 0x5,
+		.duty_cycle       = 0x0,
+	},
+	{ /* SPX5_SD10G28_MODE_PRESET_QSGMII */
+		.bwidth           = 20,
+		.cmu_sel          = SPX5_SD10G28_CMU_AUX1,
+		.rate             = 0x1,
+		.dfe_enable       = 0,
+		.dfe_tap          = 0,
+		.pi_bw_gen1       = 0x5,
+		.duty_cycle       = 0x0,
+	},
+	{ /* SPX5_SD10G28_MODE_PRESET_SD_2G5 */
+		.bwidth           = 10,
+		.cmu_sel          = SPX5_SD10G28_CMU_AUX2,
+		.rate             = 0x2,
+		.dfe_enable       = 0,
+		.dfe_tap          = 0,
+		.pi_bw_gen1       = 0x7,
+		.duty_cycle       = 0x0,
+	},
+	{ /* SPX5_SD10G28_MODE_PRESET_1000BASEX */
+		.bwidth           = 10,
+		.cmu_sel          = SPX5_SD10G28_CMU_AUX1,
+		.rate             = 0x3,
+		.dfe_enable       = 0,
+		.dfe_tap          = 0,
+		.pi_bw_gen1       = 0x7,
+		.duty_cycle       = 0x0,
+	},
+};
+
+/* map from SD25G28 interface width to configuration value */
+static u8 sd25g28_get_iw_setting(const u8 interface_width)
+{
+	switch (interface_width) {
+	case 10: return 0;
+	case 16: return 1;
+	case 32: return 3;
+	case 40: return 4;
+	case 64: return 5;
+	default:
+		pr_err("%s: Illegal value %d for interface width\n",
+		       __func__, interface_width);
+	}
+	return 0;
+}
+
+/* map from SD10G28 interface width to configuration value */
+static u8 sd10g28_get_iw_setting(const u8 interface_width)
+{
+	switch (interface_width) {
+	case 10: return 0;
+	case 16: return 1;
+	case 20: return 2;
+	case 32: return 3;
+	case 40: return 4;
+	case 64: return 7;
+	default:
+		pr_err("%s: Illegal value %d for interface width\n", __func__,
+		       interface_width);
+		return 0;
+	}
+}
+
+static int sparx5_sd10g25_get_mode_preset(struct sparx5_serdes_macro *macro,
+					  struct sparx5_sd25g28_mode_preset *mode)
+{
+	switch (macro->serdesmode) {
+	case SPX5_SD_MODE_SFI:
+		if (macro->speed == SPEED_25000)
+			*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_25000];
+		else if (macro->speed == SPEED_10000)
+			*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_10000];
+		else if (macro->speed == SPEED_5000)
+			*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_5000];
+		break;
+	case SPX5_SD_MODE_2G5:
+		*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_SD_2G5];
+		break;
+	case SPX5_SD_MODE_1000BASEX:
+		*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_1000BASEX];
+		break;
+	case SPX5_SD_MODE_100FX:
+		 /* Not supported */
+		return -EINVAL;
+	default:
+		*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_25000];
+		break;
+	}
+	return 0;
+}
+
+static int sparx5_sd10g28_get_mode_preset(struct sparx5_serdes_macro *macro,
+					  struct sparx5_sd10g28_mode_preset *mode,
+					  struct sparx5_sd10g28_args *args)
+{
+	switch (macro->serdesmode) {
+	case SPX5_SD_MODE_SFI:
+		if (macro->speed == SPEED_10000) {
+			*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_10000];
+		} else if (macro->speed == SPEED_5000) {
+			if (args->is_6g)
+				*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_SFI_5000_6G];
+			else
+				*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_SFI_5000_10G];
+		} else {
+			pr_err("%s: Illegal speed: %02u, sidx: %02u, mode (%u)",
+			       __func__, macro->speed, macro->sidx,
+			       macro->serdesmode);
+			return -EINVAL;
+		}
+		break;
+	case SPX5_SD_MODE_QSGMII:
+		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_QSGMII];
+		break;
+	case SPX5_SD_MODE_2G5:
+		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_SD_2G5];
+		break;
+	case SPX5_SD_MODE_100FX:
+	case SPX5_SD_MODE_1000BASEX:
+		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_1000BASEX];
+		break;
+	default:
+		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_10000];
+		break;
+	}
+	return 0;
+}
+
+static void sparx5_sd25g28_get_params(struct sparx5_serdes_macro *macro,
+				     struct sparx5_sd25g28_media_preset *media,
+				     struct sparx5_sd25g28_mode_preset *mode,
+				     struct sparx5_sd25g28_args *args,
+				     struct sparx5_sd25g28_params *params)
+{
+	struct sparx5_sd25g28_params init = {
+		.r_d_width_ctrl_2_0         = sd25g28_get_iw_setting(mode->bitwidth),
+		.r_txfifo_ck_div_pmad_2_0   = mode->fifo_ck_div,
+		.r_rxfifo_ck_div_pmad_2_0   = mode->fifo_ck_div,
+		.cfg_vco_div_mode_1_0       = mode->vco_div_mode,
+		.cfg_pre_divsel_1_0         = mode->pre_divsel,
+		.cfg_sel_div_3_0            = mode->sel_div,
+		.cfg_vco_start_code_3_0     = 0,
+		.cfg_pma_tx_ck_bitwidth_2_0 = mode->ck_bitwidth,
+		.cfg_tx_prediv_1_0          = mode->tx_pre_div,
+		.cfg_rxdiv_sel_2_0          = mode->ck_bitwidth,
+		.cfg_tx_subrate_2_0         = mode->subrate,
+		.cfg_rx_subrate_2_0         = mode->subrate,
+		.r_multi_lane_mode          = 0,
+		.cfg_cdrck_en               = 1,
+		.cfg_dfeck_en               = mode->dfe_enable,
+		.cfg_dfe_pd                 = mode->dfe_enable == 1 ? 0 : 1,
+		.cfg_dfedmx_pd              = 1,
+		.cfg_dfetap_en_5_1          = mode->dfe_tap,
+		.cfg_dmux_pd                = 0,
+		.cfg_dmux_clk_pd            = 1,
+		.cfg_erramp_pd              = mode->dfe_enable == 1 ? 0 : 1,
+		.cfg_pi_DFE_en              = mode->dfe_enable,
+		.cfg_pi_en                  = 1,
+		.cfg_pd_ctle                = 0,
+		.cfg_summer_en              = 1,
+		.cfg_pmad_ck_pd             = 0,
+		.cfg_pd_clk                 = 0,
+		.cfg_pd_cml                 = 0,
+		.cfg_pd_driver              = 0,
+		.cfg_rx_reg_pu              = 1,
+		.cfg_pd_rms_det             = 1,
+		.cfg_dcdr_pd                = 0,
+		.cfg_ecdr_pd                = 1,
+		.cfg_pd_sq                  = 1,
+		.cfg_itx_ipdriver_base_2_0  = mode->txmargin,
+		.cfg_tap_dly_4_0            = media->cfg_tap_dly_4_0,
+		.cfg_tap_main               = media->cfg_tap_main,
+		.cfg_en_main                = media->cfg_en_main,
+		.cfg_tap_adv_3_0            = media->cfg_tap_adv_3_0,
+		.cfg_en_adv                 = media->cfg_en_adv,
+		.cfg_en_dly                 = media->cfg_en_dly,
+		.cfg_iscan_en               = 0,
+		.l1_pcs_en_fast_iscan       = 0,
+		.l0_cfg_bw_1_0              = 0,
+		.cfg_en_dummy               = 0,
+		.cfg_pll_reserve_3_0        = args->com_pll_reserve,
+		.l0_cfg_txcal_en            = mode->com_txcal_en,
+		.l0_cfg_tx_reserve_15_8     = mode->com_tx_reserve_msb,
+		.l0_cfg_tx_reserve_7_0      = mode->com_tx_reserve_lsb,
+		.cfg_tx_reserve_15_8        = mode->tx_reserve_msb,
+		.cfg_tx_reserve_7_0         = mode->tx_reserve_lsb,
+		.cfg_bw_1_0                 = mode->bw,
+		.cfg_txcal_man_en           = 1,
+		.cfg_phase_man_4_0          = 0,
+		.cfg_quad_man_1_0           = 0,
+		.cfg_txcal_shift_code_5_0   = 2,
+		.cfg_txcal_valid_sel_3_0    = 4,
+		.cfg_txcal_en               = 0,
+		.cfg_cdr_kf_2_0             = 1,
+		.cfg_cdr_m_7_0              = 6,
+		.cfg_pi_bw_3_0              = mode->cfg_pi_bw_3_0,
+		.cfg_pi_steps_1_0           = 0,
+		.cfg_dis_2ndorder           = 1,
+		.cfg_ctle_rstn              = mode->cfg_ctle_rstn,
+		.r_dfe_rstn                 = mode->r_dfe_rstn,
+		.cfg_alos_thr_2_0           = media->cfg_alos_thr_2_0,
+		.cfg_itx_ipcml_base_1_0     = mode->cfg_itx_ipcml_base,
+		.cfg_rx_reserve_7_0         = 0xbf,
+		.cfg_rx_reserve_15_8        = 0x61,
+		.cfg_rxterm_2_0             = mode->rxterm,
+		.cfg_fom_selm               = 0,
+		.cfg_rx_sp_ctle_1_0         = 0,
+		.cfg_isel_ctle_1_0          = 0,
+		.cfg_vga_ctrl_byp_4_0       = media->cfg_vga_ctrl_byp_4_0,
+		.cfg_vga_byp                = 1,
+		.cfg_agc_adpt_byp           = 1,
+		.cfg_eqr_byp                = 1,
+		.cfg_eqr_force_3_0          = media->cfg_eq_r_force_3_0,
+		.cfg_eqc_force_3_0          = media->cfg_eq_c_force_3_0,
+		.cfg_sum_setcm_en           = 1,
+		.cfg_pi_dfe_en              = 1,
+		.cfg_init_pos_iscan_6_0     = 6,
+		.cfg_init_pos_ipi_6_0       = 9,
+		.cfg_dfedig_m_2_0           = 6,
+		.cfg_en_dfedig              = mode->dfe_enable,
+		.r_d_width_ctrl_from_hwt    = 0,
+		.r_reg_manual               = 1,
+		.reg_rst                    = args->reg_rst,
+		.cfg_jc_byp                 = 1,
+		.cfg_common_reserve_7_0     = 1,
+		.cfg_pll_lol_set            = 1,
+		.cfg_tx2rx_lp_en            = 0,
+		.cfg_txlb_en                = 0,
+		.cfg_rx2tx_lp_en            = 0,
+		.cfg_rxlb_en                = 0,
+		.r_tx_pol_inv               = args->txinvert,
+		.r_rx_pol_inv               = args->rxinvert,
+	};
+
+	*params = init;
+}
+
+static void sparx5_sd10g28_get_params(struct sparx5_serdes_macro *macro,
+				     struct sparx5_sd10g28_media_preset *media,
+				     struct sparx5_sd10g28_mode_preset *mode,
+				     struct sparx5_sd10g28_args *args,
+				     struct sparx5_sd10g28_params *params)
+{
+	struct sparx5_sd10g28_params init = {
+		.skip_cmu_cfg                = args->skip_cmu_cfg,
+		.is_6g                       = args->is_6g,
+		.cmu_sel                     = mode->cmu_sel,
+		.cfg_lane_reserve_7_0        = (mode->cmu_sel % 2) << 6,
+		.cfg_ssc_rtl_clk_sel         = (mode->cmu_sel / 2),
+		.cfg_lane_reserve_15_8       = mode->duty_cycle,
+		.cfg_txrate_1_0              = mode->rate,
+		.cfg_rxrate_1_0              = mode->rate,
+		.fx_100                      = macro->serdesmode == SPX5_SD_MODE_100FX,
+		.r_d_width_ctrl_2_0          = sd10g28_get_iw_setting(mode->bwidth),
+		.cfg_pma_tx_ck_bitwidth_2_0  = sd10g28_get_iw_setting(mode->bwidth),
+		.cfg_rxdiv_sel_2_0           = sd10g28_get_iw_setting(mode->bwidth),
+		.r_pcs2pma_phymode_4_0       = 0,
+		.cfg_lane_id_2_0             = 0,
+		.cfg_cdrck_en                = 1,
+		.cfg_dfeck_en                = mode->dfe_enable,
+		.cfg_dfe_pd                  = (mode->dfe_enable == 1) ? 0 : 1,
+		.cfg_dfetap_en_5_1           = mode->dfe_tap,
+		.cfg_erramp_pd               = (mode->dfe_enable == 1) ? 0 : 1,
+		.cfg_pi_DFE_en               = mode->dfe_enable,
+		.cfg_pi_en                   = 1,
+		.cfg_pd_ctle                 = 0,
+		.cfg_summer_en               = 1,
+		.cfg_pd_rx_cktree            = 0,
+		.cfg_pd_clk                  = 0,
+		.cfg_pd_cml                  = 0,
+		.cfg_pd_driver               = 0,
+		.cfg_rx_reg_pu               = 1,
+		.cfg_d_cdr_pd                = 0,
+		.cfg_pd_sq                   = mode->dfe_enable,
+		.cfg_rxdet_en                = 0,
+		.cfg_rxdet_str               = 0,
+		.r_multi_lane_mode           = 0,
+		.cfg_en_adv                  = media->cfg_en_adv,
+		.cfg_en_main                 = 1,
+		.cfg_en_dly                  = media->cfg_en_dly,
+		.cfg_tap_adv_3_0             = media->cfg_tap_adv_3_0,
+		.cfg_tap_main                = media->cfg_tap_main,
+		.cfg_tap_dly_4_0             = media->cfg_tap_dly_4_0,
+		.cfg_vga_ctrl_3_0            = media->cfg_vga_ctrl_3_0,
+		.cfg_vga_cp_2_0              = media->cfg_vga_cp_2_0,
+		.cfg_eq_res_3_0              = media->cfg_eq_res_3_0,
+		.cfg_eq_r_byp                = media->cfg_eq_r_byp,
+		.cfg_eq_c_force_3_0          = media->cfg_eq_c_force_3_0,
+		.cfg_en_dfedig               = mode->dfe_enable,
+		.cfg_sum_setcm_en            = 1,
+		.cfg_en_preemph              = 0,
+		.cfg_itx_ippreemp_base_1_0   = 0,
+		.cfg_itx_ipdriver_base_2_0   = (args->txswing >> 6),
+		.cfg_ibias_tune_reserve_5_0  = (args->txswing & 63),
+		.cfg_txswing_half            = (args->txmargin),
+		.cfg_dis_2nd_order           = 0x1,
+		.cfg_rx_ssc_lh               = 0x0,
+		.cfg_pi_floop_steps_1_0      = 0x0,
+		.cfg_pi_ext_dac_23_16        = (1 << 5),
+		.cfg_pi_ext_dac_15_8         = (0 << 6),
+		.cfg_iscan_ext_dac_7_0       = (1 << 7) + 9,
+		.cfg_cdr_kf_gen1_2_0         = 1,
+		.cfg_cdr_kf_gen2_2_0         = 1,
+		.cfg_cdr_kf_gen3_2_0         = 1,
+		.cfg_cdr_kf_gen4_2_0         = 1,
+		.r_cdr_m_gen1_7_0            = 4,
+		.cfg_pi_bw_gen1_3_0          = mode->pi_bw_gen1,
+		.cfg_pi_bw_gen2              = mode->pi_bw_gen1,
+		.cfg_pi_bw_gen3              = mode->pi_bw_gen1,
+		.cfg_pi_bw_gen4              = mode->pi_bw_gen1,
+		.cfg_pi_ext_dac_7_0          = 3,
+		.cfg_pi_steps                = 0,
+		.cfg_mp_max_3_0              = 1,
+		.cfg_rstn_dfedig             = mode->dfe_enable,
+		.cfg_alos_thr_3_0            = media->cfg_alos_thr_3_0,
+		.cfg_predrv_slewrate_1_0     = 3,
+		.cfg_itx_ipcml_base_1_0      = 0,
+		.cfg_ip_pre_base_1_0         = 0,
+		.r_cdr_m_gen2_7_0            = 2,
+		.r_cdr_m_gen3_7_0            = 2,
+		.r_cdr_m_gen4_7_0            = 2,
+		.r_en_auto_cdr_rstn          = 0,
+		.cfg_oscal_afe               = 1,
+		.cfg_pd_osdac_afe            = 0,
+		.cfg_resetb_oscal_afe[0]     = 0,
+		.cfg_resetb_oscal_afe[1]     = 1,
+		.cfg_center_spreading        = 0,
+		.cfg_m_cnt_maxval_4_0        = 15,
+		.cfg_ncnt_maxval_7_0         = 32,
+		.cfg_ncnt_maxval_10_8        = 6,
+		.cfg_ssc_en                  = 1,
+		.cfg_tx2rx_lp_en             = 0,
+		.cfg_txlb_en                 = 0,
+		.cfg_rx2tx_lp_en             = 0,
+		.cfg_rxlb_en                 = 0,
+		.r_tx_pol_inv                = args->txinvert,
+		.r_rx_pol_inv                = args->rxinvert,
+	};
+
+	*params = init;
+}
+
+static int sparx5_sd25g28_apply_params(struct sparx5_serdes_macro *macro,
+				       struct sparx5_sd25g28_params *params)
+{
+	struct sparx5_serdes_private *priv = macro->priv;
+	int ret = 0;
+	u32 value;
+	u32 sd_index = macro->stpidx;
+
+	if (params->reg_rst == 1) {
+		sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST_SET(1),
+			 SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST,
+			 priv,
+			 SD_LANE_25G_SD_LANE_CFG(sd_index));
+
+		usleep_range(1000, 2000);
+
+		sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST_SET(0),
+			 SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST,
+			 priv,
+			 SD_LANE_25G_SD_LANE_CFG(sd_index));
+	}
+
+	sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(1),
+		 SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_25G_SD_LANE_CFG(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xFF),
+		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT_SET
+		 (params->r_d_width_ctrl_from_hwt) |
+		 SD25G_LANE_CMU_1A_R_REG_MANUAL_SET(params->r_reg_manual),
+		 SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT |
+		 SD25G_LANE_CMU_1A_R_REG_MANUAL,
+		 priv,
+		 SD25G_LANE_CMU_1A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0_SET
+		 (params->cfg_common_reserve_7_0),
+		 SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_CMU_31(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_09_CFG_EN_DUMMY_SET(params->cfg_en_dummy),
+		 SD25G_LANE_CMU_09_CFG_EN_DUMMY,
+		 priv,
+		 SD25G_LANE_CMU_09(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0_SET
+		 (params->cfg_pll_reserve_3_0),
+		 SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0,
+		 priv,
+		 SD25G_LANE_CMU_13(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN_SET(params->l0_cfg_txcal_en),
+		 SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN,
+		 priv,
+		 SD25G_LANE_CMU_40(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8_SET
+		 (params->l0_cfg_tx_reserve_15_8),
+		 SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8,
+		 priv,
+		 SD25G_LANE_CMU_46(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0_SET
+		 (params->l0_cfg_tx_reserve_7_0),
+		 SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_CMU_45(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(0),
+		 SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
+		 priv,
+		 SD25G_LANE_CMU_0B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(1),
+		 SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
+		 priv,
+		 SD25G_LANE_CMU_0B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_19_R_CK_RESETB_SET(0),
+		 SD25G_LANE_CMU_19_R_CK_RESETB,
+		 priv,
+		 SD25G_LANE_CMU_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_19_R_CK_RESETB_SET(1),
+		 SD25G_LANE_CMU_19_R_CK_RESETB,
+		 priv,
+		 SD25G_LANE_CMU_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_18_R_PLL_RSTN_SET(0),
+		 SD25G_LANE_CMU_18_R_PLL_RSTN,
+		 priv,
+		 SD25G_LANE_CMU_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_18_R_PLL_RSTN_SET(1),
+		 SD25G_LANE_CMU_18_R_PLL_RSTN,
+		 priv,
+		 SD25G_LANE_CMU_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0_SET(params->r_d_width_ctrl_2_0),
+		 SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0,
+		 priv,
+		 SD25G_LANE_CMU_1A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0_SET
+		 (params->r_txfifo_ck_div_pmad_2_0) |
+		 SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0_SET
+		 (params->r_rxfifo_ck_div_pmad_2_0),
+		 SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0 |
+		 SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0,
+		 priv,
+		 SD25G_LANE_CMU_30(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET_SET(params->cfg_pll_lol_set) |
+		 SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0_SET
+		 (params->cfg_vco_div_mode_1_0),
+		 SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET |
+		 SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0,
+		 priv,
+		 SD25G_LANE_CMU_0C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0_SET
+		 (params->cfg_pre_divsel_1_0),
+		 SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0,
+		 priv,
+		 SD25G_LANE_CMU_0D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0_SET(params->cfg_sel_div_3_0),
+		 SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0,
+		 priv,
+		 SD25G_LANE_CMU_0E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0x00),
+		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
+		 (params->cfg_pma_tx_ck_bitwidth_2_0),
+		 SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0,
+		 priv,
+		 SD25G_LANE_LANE_0C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0_SET
+		 (params->cfg_tx_prediv_1_0),
+		 SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0,
+		 priv,
+		 SD25G_LANE_LANE_01(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0_SET
+		 (params->cfg_rxdiv_sel_2_0),
+		 SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0_SET
+		 (params->cfg_tx_subrate_2_0),
+		 SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0,
+		 priv,
+		 SD25G_LANE_LANE_2C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0_SET
+		 (params->cfg_rx_subrate_2_0),
+		 SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0,
+		 priv,
+		 SD25G_LANE_LANE_28(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
+		 SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1_SET
+		 (params->cfg_dfetap_en_5_1),
+		 SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1,
+		 priv,
+		 SD25G_LANE_LANE_0F(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
+		 SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN_SET(params->cfg_pi_dfe_en),
+		 SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN,
+		 priv,
+		 SD25G_LANE_LANE_1D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_19_LN_CFG_ECDR_PD_SET(params->cfg_ecdr_pd),
+		 SD25G_LANE_LANE_19_LN_CFG_ECDR_PD,
+		 priv,
+		 SD25G_LANE_LANE_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0_SET
+		 (params->cfg_itx_ipdriver_base_2_0),
+		 SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0,
+		 priv,
+		 SD25G_LANE_LANE_01(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0_SET(params->cfg_tap_dly_4_0),
+		 SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0,
+		 priv,
+		 SD25G_LANE_LANE_03(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0_SET(params->cfg_tap_adv_3_0),
+		 SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0,
+		 priv,
+		 SD25G_LANE_LANE_06(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_07_LN_CFG_EN_ADV_SET(params->cfg_en_adv) |
+		 SD25G_LANE_LANE_07_LN_CFG_EN_DLY_SET(params->cfg_en_dly),
+		 SD25G_LANE_LANE_07_LN_CFG_EN_ADV |
+		 SD25G_LANE_LANE_07_LN_CFG_EN_DLY,
+		 priv,
+		 SD25G_LANE_LANE_07(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8_SET
+		 (params->cfg_tx_reserve_15_8),
+		 SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8,
+		 priv,
+		 SD25G_LANE_LANE_43(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0_SET
+		 (params->cfg_tx_reserve_7_0),
+		 SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_LANE_42(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_05_LN_CFG_BW_1_0_SET(params->cfg_bw_1_0),
+		 SD25G_LANE_LANE_05_LN_CFG_BW_1_0,
+		 priv,
+		 SD25G_LANE_LANE_05(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN_SET
+		 (params->cfg_txcal_man_en),
+		 SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN,
+		 priv,
+		 SD25G_LANE_LANE_0B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0_SET
+		 (params->cfg_txcal_shift_code_5_0),
+		 SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0,
+		 priv,
+		 SD25G_LANE_LANE_0A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0_SET
+		 (params->cfg_txcal_valid_sel_3_0),
+		 SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0,
+		 priv,
+		 SD25G_LANE_LANE_09(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0_SET(params->cfg_cdr_kf_2_0),
+		 SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0,
+		 priv,
+		 SD25G_LANE_LANE_1A(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0_SET(params->cfg_cdr_m_7_0),
+		 SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0,
+		 priv,
+		 SD25G_LANE_LANE_1B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0_SET(params->cfg_pi_bw_3_0),
+		 SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0,
+		 priv,
+		 SD25G_LANE_LANE_2B(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER_SET
+		 (params->cfg_dis_2ndorder),
+		 SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER,
+		 priv,
+		 SD25G_LANE_LANE_2C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN_SET(params->cfg_ctle_rstn),
+		 SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0_SET
+		 (params->cfg_itx_ipcml_base_1_0),
+		 SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0,
+		 priv,
+		 SD25G_LANE_LANE_00(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0_SET
+		 (params->cfg_rx_reserve_7_0),
+		 SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0,
+		 priv,
+		 SD25G_LANE_LANE_44(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8_SET
+		 (params->cfg_rx_reserve_15_8),
+		 SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8,
+		 priv,
+		 SD25G_LANE_LANE_45(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN_SET(params->cfg_dfeck_en) |
+		 SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0_SET(params->cfg_rxterm_2_0),
+		 SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN |
+		 SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0,
+		 priv,
+		 SD25G_LANE_LANE_0D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0_SET
+		 (params->cfg_vga_ctrl_byp_4_0),
+		 SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0,
+		 priv,
+		 SD25G_LANE_LANE_21(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0_SET
+		 (params->cfg_eqr_force_3_0),
+		 SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0,
+		 priv,
+		 SD25G_LANE_LANE_22(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0_SET
+		 (params->cfg_eqc_force_3_0) |
+		 SD25G_LANE_LANE_1C_LN_CFG_DFE_PD_SET(params->cfg_dfe_pd),
+		 SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0 |
+		 SD25G_LANE_LANE_1C_LN_CFG_DFE_PD,
+		 priv,
+		 SD25G_LANE_LANE_1C(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN_SET
+		 (params->cfg_sum_setcm_en),
+		 SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN,
+		 priv,
+		 SD25G_LANE_LANE_1E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0_SET
+		 (params->cfg_init_pos_iscan_6_0),
+		 SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0,
+		 priv,
+		 SD25G_LANE_LANE_25(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0_SET
+		 (params->cfg_init_pos_ipi_6_0),
+		 SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0,
+		 priv,
+		 SD25G_LANE_LANE_26(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
+		 SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
+		 priv,
+		 SD25G_LANE_LANE_18(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0_SET
+		 (params->cfg_dfedig_m_2_0),
+		 SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0,
+		 priv,
+		 SD25G_LANE_LANE_0E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG_SET(params->cfg_en_dfedig),
+		 SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG,
+		 priv,
+		 SD25G_LANE_LANE_0E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_40_LN_R_TX_POL_INV_SET(params->r_tx_pol_inv) |
+		 SD25G_LANE_LANE_40_LN_R_RX_POL_INV_SET(params->r_rx_pol_inv),
+		 SD25G_LANE_LANE_40_LN_R_TX_POL_INV |
+		 SD25G_LANE_LANE_40_LN_R_RX_POL_INV,
+		 priv,
+		 SD25G_LANE_LANE_40(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN_SET(params->cfg_rx2tx_lp_en) |
+		 SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN_SET(params->cfg_tx2rx_lp_en),
+		 SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN |
+		 SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN,
+		 priv,
+		 SD25G_LANE_LANE_04(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN_SET(params->cfg_rxlb_en),
+		 SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN,
+		 priv,
+		 SD25G_LANE_LANE_1E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_19_LN_CFG_TXLB_EN_SET(params->cfg_txlb_en),
+		 SD25G_LANE_LANE_19_LN_CFG_TXLB_EN,
+		 priv,
+		 SD25G_LANE_LANE_19(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(0),
+		 SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(1),
+		 SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(0),
+		 SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_25G_SD_LANE_CFG(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(0),
+		 SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
+		 priv,
+		 SD25G_LANE_LANE_1C(sd_index));
+
+	usleep_range(1000, 2000);
+
+	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(1),
+		 SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
+		 priv,
+		 SD25G_LANE_LANE_1C(sd_index));
+
+	usleep_range(10000, 20000);
+
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xff),
+		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
+
+	value = sdx5_rd(priv, SD25G_LANE_CMU_C0(sd_index));
+	value = SD25G_LANE_CMU_C0_PLL_LOL_UDL_GET(value);
+
+	if (value) {
+		pr_err("CMU_C0 pll_lol_udl: 0x%x\n", value);
+		ret = -EINVAL;
+	}
+
+	value = sdx5_rd(priv, SD_LANE_25G_SD_LANE_STAT(sd_index));
+	value = SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE_GET(value);
+
+	if (value != 0x1) {
+		pr_err("sd_lane_stat pma_rst_done: 0x%x\n", value);
+		ret = -EINVAL;
+	}
+
+	sdx5_rmw(SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS_SET(0x1),
+		 SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS,
+		 priv,
+		 SD25G_LANE_CMU_2A(sd_index));
+
+	sdx5_rmw(SD_LANE_25G_SD_SER_RST_SER_RST_SET(0x0),
+		 SD_LANE_25G_SD_SER_RST_SER_RST,
+		 priv,
+		 SD_LANE_25G_SD_SER_RST(sd_index));
+
+	sdx5_rmw(SD_LANE_25G_SD_DES_RST_DES_RST_SET(0x0),
+		 SD_LANE_25G_SD_DES_RST_DES_RST,
+		 priv,
+		 SD_LANE_25G_SD_DES_RST(sd_index));
+
+	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0),
+		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
+		 priv,
+		 SD25G_LANE_CMU_FF(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0_SET
+		 (params->cfg_alos_thr_2_0),
+		 SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0,
+		 priv,
+		 SD25G_LANE_LANE_2D(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ_SET(0),
+		 SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_PD_SQ_SET(0),
+		 SD25G_LANE_LANE_2E_LN_CFG_PD_SQ,
+		 priv,
+		 SD25G_LANE_LANE_2E(sd_index));
+
+	return ret;
+}
+
+static int sparx5_sd10g28_apply_params(struct sparx5_serdes_macro *macro,
+				       struct sparx5_sd10g28_params *params)
+{
+	struct sparx5_serdes_private *priv = macro->priv;
+	int ret = 0;
+	u32 value;
+	u32 sd_lane_tgt = macro->sidx;
+	void __iomem *sd_inst;
+	u32 sd_index = macro->stpidx;
+
+	if (params->is_6g)
+		sd_inst = sdx5_inst_get(priv, TARGET_SD6G_LANE, sd_index);
+	else
+		sd_inst = sdx5_inst_get(priv, TARGET_SD10G_LANE, sd_index);
+	/* Note: SerDes SD10G_LANE_1 is configured in 10G_LAN mode */
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(1),
+		 SD_LANE_SD_LANE_CFG_EXT_CFG_RST,
+		 macro->priv,
+		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
+
+	usleep_range(1000, 2000);
+
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(0),
+		 SD_LANE_SD_LANE_CFG_EXT_CFG_RST,
+		 priv,
+		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
+
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_MACRO_RST_SET(1),
+		 SD_LANE_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT_SET(0x0) |
+		      SD10G_LANE_LANE_93_R_REG_MANUAL_SET(0x1) |
+		      SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT_SET(0x1) |
+		      SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT_SET(0x1) |
+		      SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL_SET(0x0),
+		      SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT |
+		      SD10G_LANE_LANE_93_R_REG_MANUAL |
+		      SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT |
+		      SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT |
+		      SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL,
+		      sd_inst,
+		      SD10G_LANE_LANE_93(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_94_R_ISCAN_REG_SET(0x1) |
+		      SD10G_LANE_LANE_94_R_TXEQ_REG_SET(0x1) |
+		      SD10G_LANE_LANE_94_R_MISC_REG_SET(0x1) |
+		      SD10G_LANE_LANE_94_R_SWING_REG_SET(0x1),
+		      SD10G_LANE_LANE_94_R_ISCAN_REG |
+		      SD10G_LANE_LANE_94_R_TXEQ_REG |
+		      SD10G_LANE_LANE_94_R_MISC_REG |
+		      SD10G_LANE_LANE_94_R_SWING_REG,
+		      sd_inst,
+		      SD10G_LANE_LANE_94(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_9E_R_RXEQ_REG_SET(0x1),
+		      SD10G_LANE_LANE_9E_R_RXEQ_REG,
+		      sd_inst,
+		      SD10G_LANE_LANE_9E(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_A1_R_SSC_FROM_HWT_SET(0x0) |
+		      SD10G_LANE_LANE_A1_R_CDR_FROM_HWT_SET(0x0) |
+		      SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT_SET(0x1),
+		      SD10G_LANE_LANE_A1_R_SSC_FROM_HWT |
+		      SD10G_LANE_LANE_A1_R_CDR_FROM_HWT |
+		      SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT,
+		      sd_inst,
+		      SD10G_LANE_LANE_A1(sd_index));
+
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_RX_REF_SEL_SET(params->cmu_sel) |
+		 SD_LANE_SD_LANE_CFG_TX_REF_SEL_SET(params->cmu_sel),
+		 SD_LANE_SD_LANE_CFG_RX_REF_SEL |
+		 SD_LANE_SD_LANE_CFG_TX_REF_SEL,
+		 priv,
+		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0_SET
+		      (params->cfg_lane_reserve_7_0),
+		      SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_40(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL_SET
+		      (params->cfg_ssc_rtl_clk_sel),
+		      SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL,
+		      sd_inst,
+		      SD10G_LANE_LANE_50(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_35_CFG_TXRATE_1_0_SET
+		      (params->cfg_txrate_1_0) |
+		      SD10G_LANE_LANE_35_CFG_RXRATE_1_0_SET
+		      (params->cfg_rxrate_1_0),
+		      SD10G_LANE_LANE_35_CFG_TXRATE_1_0 |
+		      SD10G_LANE_LANE_35_CFG_RXRATE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_35(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0_SET
+		      (params->r_d_width_ctrl_2_0),
+		      SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_94(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
+		      (params->cfg_pma_tx_ck_bitwidth_2_0),
+		      SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_01(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0_SET
+		      (params->cfg_rxdiv_sel_2_0),
+		      SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_30(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0_SET
+		      (params->r_pcs2pma_phymode_4_0),
+		      SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_A2(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_13_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
+		      SD10G_LANE_LANE_13_CFG_CDRCK_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_13(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_23_CFG_DFECK_EN_SET
+		      (params->cfg_dfeck_en) |
+		      SD10G_LANE_LANE_23_CFG_DFE_PD_SET(params->cfg_dfe_pd) |
+		      SD10G_LANE_LANE_23_CFG_ERRAMP_PD_SET
+		      (params->cfg_erramp_pd),
+		      SD10G_LANE_LANE_23_CFG_DFECK_EN |
+		      SD10G_LANE_LANE_23_CFG_DFE_PD |
+		      SD10G_LANE_LANE_23_CFG_ERRAMP_PD,
+		      sd_inst,
+		      SD10G_LANE_LANE_23(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1_SET
+		      (params->cfg_dfetap_en_5_1),
+		      SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1,
+		      sd_inst,
+		      SD10G_LANE_LANE_22(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_DFE_EN_SET
+		      (params->cfg_pi_DFE_en),
+		      SD10G_LANE_LANE_1A_CFG_PI_DFE_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_1A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_02_CFG_EN_ADV_SET(params->cfg_en_adv) |
+		      SD10G_LANE_LANE_02_CFG_EN_MAIN_SET(params->cfg_en_main) |
+		      SD10G_LANE_LANE_02_CFG_EN_DLY_SET(params->cfg_en_dly) |
+		      SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0_SET
+		      (params->cfg_tap_adv_3_0),
+		      SD10G_LANE_LANE_02_CFG_EN_ADV |
+		      SD10G_LANE_LANE_02_CFG_EN_MAIN |
+		      SD10G_LANE_LANE_02_CFG_EN_DLY |
+		      SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_02(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_03_CFG_TAP_MAIN_SET(params->cfg_tap_main),
+		      SD10G_LANE_LANE_03_CFG_TAP_MAIN,
+		      sd_inst,
+		      SD10G_LANE_LANE_03(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0_SET
+		      (params->cfg_tap_dly_4_0),
+		      SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_04(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0_SET
+		      (params->cfg_vga_ctrl_3_0),
+		      SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_2F(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0_SET
+		      (params->cfg_vga_cp_2_0),
+		      SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_2F(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0_SET
+		      (params->cfg_eq_res_3_0),
+		      SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_0B(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0D_CFG_EQR_BYP_SET(params->cfg_eq_r_byp),
+		      SD10G_LANE_LANE_0D_CFG_EQR_BYP,
+		      sd_inst,
+		      SD10G_LANE_LANE_0D(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0_SET
+		      (params->cfg_eq_c_force_3_0) |
+		      SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN_SET
+		      (params->cfg_sum_setcm_en),
+		      SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0 |
+		      SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_0E(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_23_CFG_EN_DFEDIG_SET
+		      (params->cfg_en_dfedig),
+		      SD10G_LANE_LANE_23_CFG_EN_DFEDIG,
+		      sd_inst,
+		      SD10G_LANE_LANE_23(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_06_CFG_EN_PREEMPH_SET
+		      (params->cfg_en_preemph),
+		      SD10G_LANE_LANE_06_CFG_EN_PREEMPH,
+		      sd_inst,
+		      SD10G_LANE_LANE_06(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0_SET
+		      (params->cfg_itx_ippreemp_base_1_0) |
+		      SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0_SET
+		      (params->cfg_itx_ipdriver_base_2_0),
+		      SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0 |
+		      SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_33(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0_SET
+		      (params->cfg_ibias_tune_reserve_5_0),
+		      SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_52(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_37_CFG_TXSWING_HALF_SET
+		      (params->cfg_txswing_half),
+		      SD10G_LANE_LANE_37_CFG_TXSWING_HALF,
+		      sd_inst,
+		      SD10G_LANE_LANE_37(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER_SET
+		      (params->cfg_dis_2nd_order),
+		      SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER,
+		      sd_inst,
+		      SD10G_LANE_LANE_3C(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_39_CFG_RX_SSC_LH_SET
+		      (params->cfg_rx_ssc_lh),
+		      SD10G_LANE_LANE_39_CFG_RX_SSC_LH,
+		      sd_inst,
+		      SD10G_LANE_LANE_39(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0_SET
+		      (params->cfg_pi_floop_steps_1_0),
+		      SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_1A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16_SET
+		      (params->cfg_pi_ext_dac_23_16),
+		      SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16,
+		      sd_inst,
+		      SD10G_LANE_LANE_16(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8_SET
+		      (params->cfg_pi_ext_dac_15_8),
+		      SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8,
+		      sd_inst,
+		      SD10G_LANE_LANE_15(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0_SET
+		      (params->cfg_iscan_ext_dac_7_0),
+		      SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_26(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0_SET
+		      (params->cfg_cdr_kf_gen1_2_0),
+		      SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_42(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0_SET
+		      (params->r_cdr_m_gen1_7_0),
+		      SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_0F(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0_SET
+		      (params->cfg_pi_bw_gen1_3_0),
+		      SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_24(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0_SET
+		      (params->cfg_pi_ext_dac_7_0),
+		      SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_14(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_STEPS_SET(params->cfg_pi_steps),
+		      SD10G_LANE_LANE_1A_CFG_PI_STEPS,
+		      sd_inst,
+		      SD10G_LANE_LANE_1A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0_SET
+		      (params->cfg_mp_max_3_0),
+		      SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_3A(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG_SET
+		      (params->cfg_rstn_dfedig),
+		      SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG,
+		      sd_inst,
+		      SD10G_LANE_LANE_31(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0_SET
+		      (params->cfg_alos_thr_3_0),
+		      SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_48(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0_SET
+		      (params->cfg_predrv_slewrate_1_0),
+		      SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_36(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0_SET
+		      (params->cfg_itx_ipcml_base_1_0),
+		      SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_32(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0_SET
+		      (params->cfg_ip_pre_base_1_0),
+		      SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0,
+		      sd_inst,
+		      SD10G_LANE_LANE_37(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8_SET
+		      (params->cfg_lane_reserve_15_8),
+		      SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8,
+		      sd_inst,
+		      SD10G_LANE_LANE_41(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN_SET
+		      (params->r_en_auto_cdr_rstn),
+		      SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN,
+		      sd_inst,
+		      SD10G_LANE_LANE_9E(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0C_CFG_OSCAL_AFE_SET
+		      (params->cfg_oscal_afe) |
+		      SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE_SET
+		      (params->cfg_pd_osdac_afe),
+		      SD10G_LANE_LANE_0C_CFG_OSCAL_AFE |
+		      SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE,
+		      sd_inst,
+		      SD10G_LANE_LANE_0C(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
+		      (params->cfg_resetb_oscal_afe[0]),
+		      SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
+		      sd_inst,
+		      SD10G_LANE_LANE_0B(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
+		      (params->cfg_resetb_oscal_afe[1]),
+		      SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
+		      sd_inst,
+		      SD10G_LANE_LANE_0B(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_83_R_TX_POL_INV_SET
+		      (params->r_tx_pol_inv) |
+		      SD10G_LANE_LANE_83_R_RX_POL_INV_SET
+		      (params->r_rx_pol_inv),
+		      SD10G_LANE_LANE_83_R_TX_POL_INV |
+		      SD10G_LANE_LANE_83_R_RX_POL_INV,
+		      sd_inst,
+		      SD10G_LANE_LANE_83(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN_SET
+		      (params->cfg_rx2tx_lp_en) |
+		      SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN_SET
+		      (params->cfg_tx2rx_lp_en),
+		      SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN |
+		      SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_06(sd_index));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_0E_CFG_RXLB_EN_SET(params->cfg_rxlb_en) |
+		      SD10G_LANE_LANE_0E_CFG_TXLB_EN_SET(params->cfg_txlb_en),
+		      SD10G_LANE_LANE_0E_CFG_RXLB_EN |
+		      SD10G_LANE_LANE_0E_CFG_TXLB_EN,
+		      sd_inst,
+		      SD10G_LANE_LANE_0E(sd_index));
+
+	sdx5_rmw(SD_LANE_SD_LANE_CFG_MACRO_RST_SET(0),
+		 SD_LANE_SD_LANE_CFG_MACRO_RST,
+		 priv,
+		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
+
+	sdx5_inst_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
+		      SD10G_LANE_LANE_50_CFG_SSC_RESETB,
+		      sd_inst,
+		      SD10G_LANE_LANE_50(sd_index));
+
+	sdx5_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
+		 SD10G_LANE_LANE_50_CFG_SSC_RESETB,
+		 priv,
+		 SD10G_LANE_LANE_50(sd_index));
+
+	sdx5_rmw(SD_LANE_MISC_SD_125_RST_DIS_SET(params->fx_100),
+		 SD_LANE_MISC_SD_125_RST_DIS,
+		 priv,
+		 SD_LANE_MISC(sd_lane_tgt));
+
+	sdx5_rmw(SD_LANE_MISC_RX_ENA_SET(params->fx_100),
+		 SD_LANE_MISC_RX_ENA,
+		 priv,
+		 SD_LANE_MISC(sd_lane_tgt));
+
+	sdx5_rmw(SD_LANE_MISC_MUX_ENA_SET(params->fx_100),
+		 SD_LANE_MISC_MUX_ENA,
+		 priv,
+		 SD_LANE_MISC(sd_lane_tgt));
+
+	usleep_range(3000, 6000);
+
+	value = sdx5_rd(priv, SD_LANE_SD_LANE_STAT(sd_lane_tgt));
+	value = SD_LANE_SD_LANE_STAT_PMA_RST_DONE_GET(value);
+	if (value != 1) {
+		pr_err("sd_lane_stat pma_rst_done failed with 0x%x\n", value);
+		ret = -EINVAL;
+	}
+
+	sdx5_rmw(SD_LANE_SD_SER_RST_SER_RST_SET(0x0),
+		 SD_LANE_SD_SER_RST_SER_RST,
+		 priv,
+		 SD_LANE_SD_SER_RST(sd_lane_tgt));
+
+	sdx5_rmw(SD_LANE_SD_DES_RST_DES_RST_SET(0x0),
+		 SD_LANE_SD_DES_RST_DES_RST,
+		 priv,
+		 SD_LANE_SD_DES_RST(sd_lane_tgt));
+
+	return ret;
+}
+
+static int sparx5_sd25g28_config(struct sparx5_serdes_macro *macro, bool reset)
+{
+	struct sparx5_sd25g28_mode_preset mode;
+	struct sparx5_sd25g28_media_preset media = media_presets_25g[macro->media];
+	struct sparx5_sd25g28_args args = {
+		.rxinvert = 1,
+		.txinvert = 0,
+		.txswing = 240,
+		.com_pll_reserve = 0xf,
+		.reg_rst = reset,
+	};
+	struct sparx5_sd25g28_params params;
+	int err;
+
+	err = sparx5_sd10g25_get_mode_preset(macro, &mode);
+	if (err)
+		return err;
+	sparx5_sd25g28_get_params(macro, &media, &mode, &args, &params);
+	return sparx5_sd25g28_apply_params(macro, &params);
+}
+
+static int sparx5_sd10g28_config(struct sparx5_serdes_macro *macro, bool reset)
+{
+	struct sparx5_sd10g28_mode_preset mode;
+	struct sparx5_sd10g28_media_preset media = media_presets_10g[macro->media];
+	struct sparx5_sd10g28_args args = {
+		.is_6g = (macro->serdestype == SPX5_SDT_6G),
+		.txinvert = 0,
+		.rxinvert = 1,
+		.txswing = 240,
+		.reg_rst = reset,
+	};
+	struct sparx5_sd10g28_params params;
+	int err;
+
+	err = sparx5_sd10g28_get_mode_preset(macro, &mode, &args);
+	if (err)
+		return err;
+	sparx5_sd10g28_get_params(macro, &media, &mode, &args, &params);
+	return sparx5_sd10g28_apply_params(macro, &params);
+}
+
+/* Power down serdes TX driver */
+static int sparx5_serdes_power_save(struct sparx5_serdes_macro *macro, u32 pwdn)
+{
+	void __iomem *sd_inst;
+	struct sparx5_serdes_private *priv = macro->priv;
+
+	if (macro->serdestype == SPX5_SDT_6G)
+		sd_inst = sdx5_inst_get(priv, TARGET_SD6G_LANE, macro->stpidx);
+	else if (macro->serdestype == SPX5_SDT_10G)
+		sd_inst = sdx5_inst_get(priv, TARGET_SD10G_LANE, macro->stpidx);
+	else
+		sd_inst = sdx5_inst_get(priv, TARGET_SD25G_LANE, macro->stpidx);
+
+	if (macro->serdestype == SPX5_SDT_25G) {
+		sdx5_inst_rmw(SD25G_LANE_LANE_04_LN_CFG_PD_DRIVER_SET(pwdn),
+			      SD25G_LANE_LANE_04_LN_CFG_PD_DRIVER,
+			      sd_inst,
+			      SD25G_LANE_LANE_04(0));
+	} else {
+		/* 6G and 10G */
+		sdx5_inst_rmw(SD10G_LANE_LANE_06_CFG_PD_DRIVER_SET(pwdn),
+			      SD10G_LANE_LANE_06_CFG_PD_DRIVER,
+			      sd_inst,
+			      SD10G_LANE_LANE_06(0));
+	}
+	return 0;
+}
+
+static int sparx5_serdes_clock_config(struct sparx5_serdes_macro *macro)
+{
+	struct sparx5_serdes_private *priv = macro->priv;
+
+	if (macro->serdesmode == SPX5_SD_MODE_100FX) {
+		u32 freq = priv->coreclock == 250000000 ? 2 : priv->coreclock == 500000000 ? 1 : 0;
+
+		sdx5_rmw(SD_LANE_MISC_CORE_CLK_FREQ_SET(freq),
+			 SD_LANE_MISC_CORE_CLK_FREQ,
+			 priv,
+			 SD_LANE_MISC(macro->sidx));
+	}
+	return 0;
+}
+
+static int sparx5_cmu_cfg(struct sparx5_serdes_macro *macro, u32 cmu_idx)
+{
+	struct sparx5_serdes_private *priv = macro->priv;
+	int ret = 0, value;
+	void __iomem *cmu_tgt, *cmu_cfg_tgt;
+	u32 spd10g = 1;
+
+	cmu_tgt = sdx5_inst_get(priv, TARGET_SD_CMU, cmu_idx);
+	cmu_cfg_tgt = sdx5_inst_get(priv, TARGET_SD_CMU_CFG, cmu_idx);
+
+	if (cmu_idx == 1 || cmu_idx == 4 || cmu_idx == 7 ||
+	    cmu_idx == 10 || cmu_idx == 13) {
+		spd10g = 0;
+	}
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_SET(1),
+		      SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_SET(0),
+		      SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_CMU_RST_SET(1),
+		      SD_CMU_CFG_SD_CMU_CFG_CMU_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT_SET(0x1) |
+		      SD_CMU_CMU_45_R_EN_RATECHG_CTRL_SET(0x0),
+		      SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT |
+		      SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT |
+		      SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT |
+		      SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT |
+		      SD_CMU_CMU_45_R_EN_RATECHG_CTRL,
+		      cmu_tgt,
+		      SD_CMU_CMU_45(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0_SET(0),
+		      SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_47(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_1B_CFG_RESERVE_7_0_SET(0),
+		      SD_CMU_CMU_1B_CFG_RESERVE_7_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_1B(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_0D_CFG_JC_BYP_SET(0x1),
+		      SD_CMU_CMU_0D_CFG_JC_BYP,
+		      cmu_tgt,
+		      SD_CMU_CMU_0D(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_1F_CFG_VTUNE_SEL_SET(1),
+		      SD_CMU_CMU_1F_CFG_VTUNE_SEL,
+		      cmu_tgt,
+		      SD_CMU_CMU_1F(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0_SET(3),
+		      SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_00(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0_SET(3),
+		      SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0,
+		      cmu_tgt,
+		      SD_CMU_CMU_05(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_30_R_PLL_DLOL_EN_SET(1),
+		      SD_CMU_CMU_30_R_PLL_DLOL_EN,
+		      cmu_tgt,
+		      SD_CMU_CMU_30(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_09_CFG_SW_10G_SET(spd10g),
+		      SD_CMU_CMU_09_CFG_SW_10G,
+		      cmu_tgt,
+		      SD_CMU_CMU_09(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CFG_SD_CMU_CFG_CMU_RST_SET(0),
+		      SD_CMU_CFG_SD_CMU_CFG_CMU_RST,
+		      cmu_cfg_tgt,
+		      SD_CMU_CFG_SD_CMU_CFG(cmu_idx));
+
+	msleep(20);
+
+	sdx5_inst_rmw(SD_CMU_CMU_44_R_PLL_RSTN_SET(0),
+		      SD_CMU_CMU_44_R_PLL_RSTN,
+		      cmu_tgt,
+		      SD_CMU_CMU_44(cmu_idx));
+
+	sdx5_inst_rmw(SD_CMU_CMU_44_R_PLL_RSTN_SET(1),
+		      SD_CMU_CMU_44_R_PLL_RSTN,
+		      cmu_tgt,
+		      SD_CMU_CMU_44(cmu_idx));
+
+	msleep(20);
+
+	value = sdx5_rd(priv, SD_CMU_CMU_E0(cmu_idx));
+	value = SD_CMU_CMU_E0_PLL_LOL_UDL_GET(value);
+
+	if (value) {
+		ret = -EINVAL;
+		pr_err("CMU_E0 pll_lol_udl: 0x%x\n", value);
+	}
+	sdx5_inst_rmw(SD_CMU_CMU_0D_CFG_PMA_TX_CK_PD_SET(0),
+		      SD_CMU_CMU_0D_CFG_PMA_TX_CK_PD,
+		      cmu_tgt,
+		      SD_CMU_CMU_0D(cmu_idx));
+	return ret;
+}
+
+static int sparx5_serdes_get_serdesmode(phy_interface_t portmode,
+					struct phy_configure_opts_eth_serdes *conf)
+{
+	switch (portmode) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+		if (conf->speed == SPEED_2500)
+			return SPX5_SD_MODE_2G5;
+		if (conf->speed == SPEED_100)
+			return SPX5_SD_MODE_100FX;
+		return SPX5_SD_MODE_1000BASEX;
+	case PHY_INTERFACE_MODE_SGMII:
+		return SPX5_SD_MODE_1000BASEX;
+	case PHY_INTERFACE_MODE_QSGMII:
+		return SPX5_SD_MODE_QSGMII;
+	case PHY_INTERFACE_MODE_10GBASER:
+		return SPX5_SD_MODE_SFI;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int sparx5_serdes_config(struct phy *phy, union phy_configure_opts *opts)
+{
+	struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
+	int jdx, err;
+	int serdesmode;
+
+	serdesmode = sparx5_serdes_get_serdesmode(macro->portmode, &opts->eth_serdes);
+	if (serdesmode < 0) {
+		dev_err(&phy->dev, "SerDes %u, interface not supported: %s\n",
+			macro->sidx,
+			phy_modes(macro->portmode));
+		return serdesmode;
+	}
+	macro->serdesmode = serdesmode;
+	macro->speed = opts->eth_serdes.speed;
+	macro->media = opts->eth_serdes.media_type;
+
+	if (!macro->priv->cmu_enabled) {
+		for (jdx = 0; jdx < SPX5_CMU_MAX; jdx++) {
+			err = sparx5_cmu_cfg(macro, jdx);
+			if (err) {
+				dev_err(&phy->dev, "SerDes %u, CMU %u, error: %d\n",
+					macro->sidx, jdx, err);
+				goto leave;
+			}
+		}
+		macro->priv->cmu_enabled = true;
+	}
+
+	sparx5_serdes_clock_config(macro);
+
+	if (macro->serdestype == SPX5_SDT_25G)
+		err = sparx5_sd25g28_config(macro, false);
+	else
+		err = sparx5_sd10g28_config(macro, false);
+	if (err) {
+		dev_err(&phy->dev, "SerDes %u, config error: %d\n",
+			macro->sidx, err);
+	}
+leave:
+	return err;
+}
+
+static int sparx5_serdes_power_on(struct phy *phy)
+{
+	struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
+
+	return sparx5_serdes_power_save(macro, false);
+}
+
+static int sparx5_serdes_power_off(struct phy *phy)
+{
+	struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
+
+	return sparx5_serdes_power_save(macro, true);
+}
+
+static int sparx5_serdes_set_mode(struct phy *phy, enum phy_mode mode, int submode)
+{
+	struct sparx5_serdes_macro *macro;
+
+	if (mode != PHY_MODE_ETHERNET)
+		return -EINVAL;
+
+	switch (submode) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_10GBASER:
+		macro = phy_get_drvdata(phy);
+		macro->portmode = submode;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int sparx5_serdes_reset(struct phy *phy)
+{
+	struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
+	int err;
+
+	if (macro->serdestype == SPX5_SDT_25G)
+		err = sparx5_sd25g28_config(macro, true);
+	else
+		err = sparx5_sd10g28_config(macro, true);
+	if (err) {
+		dev_err(&phy->dev, "SerDes %u, reset error: %d\n",
+			macro->sidx, err);
+	}
+	return err;
+}
+
+static int sparx5_serdes_validate(struct phy *phy, enum phy_mode mode,
+					int submode,
+					union phy_configure_opts *opts)
+{
+	struct sparx5_serdes_macro *macro = phy_get_drvdata(phy);
+	struct sparx5_serdes_private *priv = macro->priv;
+	u32 value, analog_sd;
+
+	if (mode != PHY_MODE_ETHERNET)
+		return -EINVAL;
+
+	switch (submode) {
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_10GBASER:
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (macro->serdestype == SPX5_SDT_6G) {
+		value = sdx5_rd(priv, SD6G_LANE_LANE_DF(macro->stpidx));
+		analog_sd = SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
+	} else if (macro->serdestype == SPX5_SDT_10G) {
+		value = sdx5_rd(priv, SD10G_LANE_LANE_DF(macro->stpidx));
+		analog_sd = SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(value);
+	} else {
+		value = sdx5_rd(priv, SD25G_LANE_LANE_DE(macro->stpidx));
+		analog_sd = SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(value);
+	}
+	/* Link up is when analog_sd == 0 */
+	return analog_sd;
+}
+
+static const struct phy_ops sparx5_serdes_ops = {
+	.power_on	= sparx5_serdes_power_on,
+	.power_off	= sparx5_serdes_power_off,
+	.set_mode	= sparx5_serdes_set_mode,
+	.reset		= sparx5_serdes_reset,
+	.configure	= sparx5_serdes_config,
+	.validate	= sparx5_serdes_validate,
+	.owner		= THIS_MODULE,
+};
+
+static int sparx5_phy_create(struct sparx5_serdes_private *priv,
+			   int idx, struct phy **phy)
+{
+	struct sparx5_serdes_macro *macro;
+
+	*phy = devm_phy_create(priv->dev, NULL, &sparx5_serdes_ops);
+	if (IS_ERR(*phy))
+		return PTR_ERR(*phy);
+
+	macro = devm_kzalloc(priv->dev, sizeof(*macro), GFP_KERNEL);
+	if (!macro)
+		return -ENOMEM;
+
+	macro->sidx = idx;
+	macro->priv = priv;
+	macro->speed = SPEED_UNKNOWN;
+	if (idx < SPX5_SERDES_10G_START) {
+		macro->serdestype = SPX5_SDT_6G;
+		macro->stpidx = macro->sidx;
+	} else if (idx < SPX5_SERDES_25G_START) {
+		macro->serdestype = SPX5_SDT_10G;
+		macro->stpidx = macro->sidx - SPX5_SERDES_10G_START;
+	} else {
+		macro->serdestype = SPX5_SDT_25G;
+		macro->stpidx = macro->sidx - SPX5_SERDES_25G_START;
+	}
+
+	phy_set_drvdata(*phy, macro);
+
+	return 0;
+}
+
+static struct sparx5_serdes_io_resource sparx5_serdes_iomap[] =  {
+	{ TARGET_SD_CMU,          0x0 },      /* 0x610808000: sd_cmu_0 */
+	{ TARGET_SD_CMU + 1,      0x8000 },   /* 0x610810000: sd_cmu_1 */
+	{ TARGET_SD_CMU + 2,      0x10000 },  /* 0x610818000: sd_cmu_2 */
+	{ TARGET_SD_CMU + 3,      0x18000 },  /* 0x610820000: sd_cmu_3 */
+	{ TARGET_SD_CMU + 4,      0x20000 },  /* 0x610828000: sd_cmu_4 */
+	{ TARGET_SD_CMU + 5,      0x28000 },  /* 0x610830000: sd_cmu_5 */
+	{ TARGET_SD_CMU + 6,      0x30000 },  /* 0x610838000: sd_cmu_6 */
+	{ TARGET_SD_CMU + 7,      0x38000 },  /* 0x610840000: sd_cmu_7 */
+	{ TARGET_SD_CMU + 8,      0x40000 },  /* 0x610848000: sd_cmu_8 */
+	{ TARGET_SD_CMU_CFG,      0x48000 },  /* 0x610850000: sd_cmu_cfg_0 */
+	{ TARGET_SD_CMU_CFG + 1,  0x50000 },  /* 0x610858000: sd_cmu_cfg_1 */
+	{ TARGET_SD_CMU_CFG + 2,  0x58000 },  /* 0x610860000: sd_cmu_cfg_2 */
+	{ TARGET_SD_CMU_CFG + 3,  0x60000 },  /* 0x610868000: sd_cmu_cfg_3 */
+	{ TARGET_SD_CMU_CFG + 4,  0x68000 },  /* 0x610870000: sd_cmu_cfg_4 */
+	{ TARGET_SD_CMU_CFG + 5,  0x70000 },  /* 0x610878000: sd_cmu_cfg_5 */
+	{ TARGET_SD_CMU_CFG + 6,  0x78000 },  /* 0x610880000: sd_cmu_cfg_6 */
+	{ TARGET_SD_CMU_CFG + 7,  0x80000 },  /* 0x610888000: sd_cmu_cfg_7 */
+	{ TARGET_SD_CMU_CFG + 8,  0x88000 },  /* 0x610890000: sd_cmu_cfg_8 */
+	{ TARGET_SD6G_LANE,       0x90000 },  /* 0x610898000: sd6g_lane_0 */
+	{ TARGET_SD6G_LANE + 1,   0x98000 },  /* 0x6108a0000: sd6g_lane_1 */
+	{ TARGET_SD6G_LANE + 2,   0xa0000 },  /* 0x6108a8000: sd6g_lane_2 */
+	{ TARGET_SD6G_LANE + 3,   0xa8000 },  /* 0x6108b0000: sd6g_lane_3 */
+	{ TARGET_SD6G_LANE + 4,   0xb0000 },  /* 0x6108b8000: sd6g_lane_4 */
+	{ TARGET_SD6G_LANE + 5,   0xb8000 },  /* 0x6108c0000: sd6g_lane_5 */
+	{ TARGET_SD6G_LANE + 6,   0xc0000 },  /* 0x6108c8000: sd6g_lane_6 */
+	{ TARGET_SD6G_LANE + 7,   0xc8000 },  /* 0x6108d0000: sd6g_lane_7 */
+	{ TARGET_SD6G_LANE + 8,   0xd0000 },  /* 0x6108d8000: sd6g_lane_8 */
+	{ TARGET_SD6G_LANE + 9,   0xd8000 },  /* 0x6108e0000: sd6g_lane_9 */
+	{ TARGET_SD6G_LANE + 10,  0xe0000 },  /* 0x6108e8000: sd6g_lane_10 */
+	{ TARGET_SD6G_LANE + 11,  0xe8000 },  /* 0x6108f0000: sd6g_lane_11 */
+	{ TARGET_SD6G_LANE + 12,  0xf0000 },  /* 0x6108f8000: sd6g_lane_12 */
+	{ TARGET_SD10G_LANE,      0xf8000 },  /* 0x610900000: sd10g_lane_0 */
+	{ TARGET_SD10G_LANE + 1,  0x100000 }, /* 0x610908000: sd10g_lane_1 */
+	{ TARGET_SD10G_LANE + 2,  0x108000 }, /* 0x610910000: sd10g_lane_2 */
+	{ TARGET_SD10G_LANE + 3,  0x110000 }, /* 0x610918000: sd10g_lane_3 */
+	{ TARGET_SD_LANE,         0x1a0000 }, /* 0x6109a8000: sd_lane_0 */
+	{ TARGET_SD_LANE + 1,     0x1a8000 }, /* 0x6109b0000: sd_lane_1 */
+	{ TARGET_SD_LANE + 2,     0x1b0000 }, /* 0x6109b8000: sd_lane_2 */
+	{ TARGET_SD_LANE + 3,     0x1b8000 }, /* 0x6109c0000: sd_lane_3 */
+	{ TARGET_SD_LANE + 4,     0x1c0000 }, /* 0x6109c8000: sd_lane_4 */
+	{ TARGET_SD_LANE + 5,     0x1c8000 }, /* 0x6109d0000: sd_lane_5 */
+	{ TARGET_SD_LANE + 6,     0x1d0000 }, /* 0x6109d8000: sd_lane_6 */
+	{ TARGET_SD_LANE + 7,     0x1d8000 }, /* 0x6109e0000: sd_lane_7 */
+	{ TARGET_SD_LANE + 8,     0x1e0000 }, /* 0x6109e8000: sd_lane_8 */
+	{ TARGET_SD_LANE + 9,     0x1e8000 }, /* 0x6109f0000: sd_lane_9 */
+	{ TARGET_SD_LANE + 10,    0x1f0000 }, /* 0x6109f8000: sd_lane_10 */
+	{ TARGET_SD_LANE + 11,    0x1f8000 }, /* 0x610a00000: sd_lane_11 */
+	{ TARGET_SD_LANE + 12,    0x200000 }, /* 0x610a08000: sd_lane_12 */
+	{ TARGET_SD_LANE + 13,    0x208000 }, /* 0x610a10000: sd_lane_13 */
+	{ TARGET_SD_LANE + 14,    0x210000 }, /* 0x610a18000: sd_lane_14 */
+	{ TARGET_SD_LANE + 15,    0x218000 }, /* 0x610a20000: sd_lane_15 */
+	{ TARGET_SD_LANE + 16,    0x220000 }, /* 0x610a28000: sd_lane_16 */
+	{ TARGET_SD_CMU + 9,      0x400000 }, /* 0x610c08000: sd_cmu_9 */
+	{ TARGET_SD_CMU + 10,     0x408000 }, /* 0x610c10000: sd_cmu_10 */
+	{ TARGET_SD_CMU + 11,     0x410000 }, /* 0x610c18000: sd_cmu_11 */
+	{ TARGET_SD_CMU + 12,     0x418000 }, /* 0x610c20000: sd_cmu_12 */
+	{ TARGET_SD_CMU + 13,     0x420000 }, /* 0x610c28000: sd_cmu_13 */
+	{ TARGET_SD_CMU_CFG + 9,  0x428000 }, /* 0x610c30000: sd_cmu_cfg_9 */
+	{ TARGET_SD_CMU_CFG + 10, 0x430000 }, /* 0x610c38000: sd_cmu_cfg_10 */
+	{ TARGET_SD_CMU_CFG + 11, 0x438000 }, /* 0x610c40000: sd_cmu_cfg_11 */
+	{ TARGET_SD_CMU_CFG + 12, 0x440000 }, /* 0x610c48000: sd_cmu_cfg_12 */
+	{ TARGET_SD_CMU_CFG + 13, 0x448000 }, /* 0x610c50000: sd_cmu_cfg_13 */
+	{ TARGET_SD10G_LANE + 4,  0x450000 }, /* 0x610c58000: sd10g_lane_4 */
+	{ TARGET_SD10G_LANE + 5,  0x458000 }, /* 0x610c60000: sd10g_lane_5 */
+	{ TARGET_SD10G_LANE + 6,  0x460000 }, /* 0x610c68000: sd10g_lane_6 */
+	{ TARGET_SD10G_LANE + 7,  0x468000 }, /* 0x610c70000: sd10g_lane_7 */
+	{ TARGET_SD10G_LANE + 8,  0x470000 }, /* 0x610c78000: sd10g_lane_8 */
+	{ TARGET_SD10G_LANE + 9,  0x478000 }, /* 0x610c80000: sd10g_lane_9 */
+	{ TARGET_SD10G_LANE + 10, 0x480000 }, /* 0x610c88000: sd10g_lane_10 */
+	{ TARGET_SD10G_LANE + 11, 0x488000 }, /* 0x610c90000: sd10g_lane_11 */
+	{ TARGET_SD25G_LANE,      0x490000 }, /* 0x610c98000: sd25g_lane_0 */
+	{ TARGET_SD25G_LANE + 1,  0x498000 }, /* 0x610ca0000: sd25g_lane_1 */
+	{ TARGET_SD25G_LANE + 2,  0x4a0000 }, /* 0x610ca8000: sd25g_lane_2 */
+	{ TARGET_SD25G_LANE + 3,  0x4a8000 }, /* 0x610cb0000: sd25g_lane_3 */
+	{ TARGET_SD25G_LANE + 4,  0x4b0000 }, /* 0x610cb8000: sd25g_lane_4 */
+	{ TARGET_SD25G_LANE + 5,  0x4b8000 }, /* 0x610cc0000: sd25g_lane_5 */
+	{ TARGET_SD25G_LANE + 6,  0x4c0000 }, /* 0x610cc8000: sd25g_lane_6 */
+	{ TARGET_SD25G_LANE + 7,  0x4c8000 }, /* 0x610cd0000: sd25g_lane_7 */
+	{ TARGET_SD_LANE + 17,    0x550000 }, /* 0x610d58000: sd_lane_17 */
+	{ TARGET_SD_LANE + 18,    0x558000 }, /* 0x610d60000: sd_lane_18 */
+	{ TARGET_SD_LANE + 19,    0x560000 }, /* 0x610d68000: sd_lane_19 */
+	{ TARGET_SD_LANE + 20,    0x568000 }, /* 0x610d70000: sd_lane_20 */
+	{ TARGET_SD_LANE + 21,    0x570000 }, /* 0x610d78000: sd_lane_21 */
+	{ TARGET_SD_LANE + 22,    0x578000 }, /* 0x610d80000: sd_lane_22 */
+	{ TARGET_SD_LANE + 23,    0x580000 }, /* 0x610d88000: sd_lane_23 */
+	{ TARGET_SD_LANE + 24,    0x588000 }, /* 0x610d90000: sd_lane_24 */
+	{ TARGET_SD_LANE_25G,     0x590000 }, /* 0x610d98000: sd_lane_25g_25 */
+	{ TARGET_SD_LANE_25G + 1, 0x598000 }, /* 0x610da0000: sd_lane_25g_26 */
+	{ TARGET_SD_LANE_25G + 2, 0x5a0000 }, /* 0x610da8000: sd_lane_25g_27 */
+	{ TARGET_SD_LANE_25G + 3, 0x5a8000 }, /* 0x610db0000: sd_lane_25g_28 */
+	{ TARGET_SD_LANE_25G + 4, 0x5b0000 }, /* 0x610db8000: sd_lane_25g_29 */
+	{ TARGET_SD_LANE_25G + 5, 0x5b8000 }, /* 0x610dc0000: sd_lane_25g_30 */
+	{ TARGET_SD_LANE_25G + 6, 0x5c0000 }, /* 0x610dc8000: sd_lane_25g_31 */
+	{ TARGET_SD_LANE_25G + 7, 0x5c8000 }, /* 0x610dd0000: sd_lane_25g_32 */
+};
+
+/* Client lookup function, uses serdes index */
+static struct phy *sparx5_serdes_xlate(struct device *dev,
+				     struct of_phandle_args *args)
+{
+	struct sparx5_serdes_private *priv = dev_get_drvdata(dev);
+	int idx;
+	unsigned int sidx;
+
+	if (args->args_count != 1)
+		return ERR_PTR(-EINVAL);
+
+	sidx = args->args[0];
+
+	/* Check validity: ERR_PTR(-ENODEV) if not valid */
+	for (idx = 0; idx < SPX5_SERDES_MAX; idx++) {
+		struct sparx5_serdes_macro *macro =
+			phy_get_drvdata(priv->phys[idx]);
+
+		if (sidx != macro->sidx)
+			continue;
+
+		return priv->phys[idx];
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+static int sparx5_serdes_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct sparx5_serdes_private *priv;
+	struct phy_provider *provider;
+	struct resource *iores;
+	void __iomem *iomem;
+	unsigned long clock;
+	struct clk *clk;
+	int idx;
+	int err;
+
+	if (!np && !pdev->dev.platform_data)
+		return -ENODEV;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, priv);
+	priv->dev = &pdev->dev;
+
+	/* Get coreclock */
+	clk = devm_clk_get(priv->dev, NULL);
+	if (IS_ERR(clk)) {
+		dev_err(priv->dev, "Failed to get coreclock\n");
+		return PTR_ERR(clk);
+	}
+	clock = clk_get_rate(clk);
+	if (clock == 0) {
+		dev_err(priv->dev, "Invalid coreclock %lu\n", clock);
+		return -EINVAL;
+	}
+	priv->coreclock = clock;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	iomem = devm_ioremap(priv->dev, iores->start, iores->end - iores->start + 1);
+	if (IS_ERR(iomem)) {
+		dev_err(priv->dev, "Unable to get serdes registers: %s\n",
+			iores->name);
+		return PTR_ERR(iomem);
+	}
+	for (idx = 0; idx < ARRAY_SIZE(sparx5_serdes_iomap); idx++) {
+		struct sparx5_serdes_io_resource *iomap = &sparx5_serdes_iomap[idx];
+
+		priv->regs[iomap->id] = iomem + iomap->offset;
+	}
+	for (idx = 0; idx < SPX5_SERDES_MAX; idx++) {
+		err = sparx5_phy_create(priv, idx, &priv->phys[idx]);
+		if (err)
+			return err;
+	}
+
+	provider = devm_of_phy_provider_register(priv->dev, sparx5_serdes_xlate);
+
+	return PTR_ERR_OR_ZERO(provider);
+}
+
+static const struct of_device_id sparx5_serdes_match[] = {
+	{ .compatible = "microchip,sparx5-serdes" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sparx5_serdes_match);
+
+static struct platform_driver sparx5_serdes_driver = {
+	.probe = sparx5_serdes_probe,
+	.driver = {
+		.name = "sparx5-serdes",
+		.of_match_table = sparx5_serdes_match,
+	},
+};
+
+module_platform_driver(sparx5_serdes_driver);
+
+MODULE_DESCRIPTION("Microchip Sparx5 switch serdes driver");
+MODULE_AUTHOR("Steen Hegelund <steen.hegelund@microchip.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/phy/microchip/sparx5_serdes.h b/drivers/phy/microchip/sparx5_serdes.h
new file mode 100644
index 000000000000..28decc5fd731
--- /dev/null
+++ b/drivers/phy/microchip/sparx5_serdes.h
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: GPL-2.0+
+ * Microchip Sparx5 SerDes driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc.
+ */
+
+#ifndef _SPARX5_SERDES_H_
+#define _SPARX5_SERDES_H_
+
+#include "sparx5_serdes_regs.h"
+
+#define SPX5_SERDES_MAX       33
+
+enum sparx5_serdes_type {
+	SPX5_SDT_6G  = 6,
+	SPX5_SDT_10G = 10,
+	SPX5_SDT_25G = 25,
+};
+
+enum sparx5_serdes_mode {
+	SPX5_SD_MODE_2G5,
+	SPX5_SD_MODE_QSGMII,
+	SPX5_SD_MODE_100FX,
+	SPX5_SD_MODE_1000BASEX,
+	SPX5_SD_MODE_SFI,
+};
+
+struct sparx5_serdes_private {
+	struct device           *dev;
+	void __iomem            *regs[NUM_TARGETS];
+	struct phy              *phys[SPX5_SERDES_MAX];
+	bool                    cmu_enabled;
+	unsigned long           coreclock;
+};
+
+struct sparx5_serdes_macro {
+	struct sparx5_serdes_private *priv;
+	u32                          sidx;
+	u32                          stpidx;
+	enum sparx5_serdes_type      serdestype;
+	enum sparx5_serdes_mode      serdesmode;
+	phy_interface_t              portmode;
+	u32                          speed;
+	enum ethernet_media_type     media;
+};
+
+
+/* Read, Write and modify registers content.
+ * The register definition macros start at the id
+ */
+static inline void __iomem *sdx5_addr(void __iomem *base[],
+				      int id, int tinst, int tcnt,
+				      int gbase, int ginst,
+				      int gcnt, int gwidth,
+				      int raddr, int rinst,
+				      int rcnt, int rwidth)
+{
+#if defined(CONFIG_DEBUG_KERNEL)
+	WARN_ON((tinst) >= tcnt);
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+#endif
+	return base[id + (tinst)] +
+		gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+static inline void __iomem *sdx5_inst_addr(void __iomem *base,
+					   int gbase, int ginst,
+					   int gcnt, int gwidth,
+					   int raddr, int rinst,
+					   int rcnt, int rwidth)
+{
+#if defined(CONFIG_DEBUG_KERNEL)
+	WARN_ON((ginst) >= gcnt);
+	WARN_ON((rinst) >= rcnt);
+#endif
+	return base +
+		gbase + ((ginst) * gwidth) +
+		raddr + ((rinst) * rwidth);
+}
+
+static inline u32 sdx5_rd(struct sparx5_serdes_private *priv, int id,
+			  int tinst, int tcnt,
+			  int gbase, int ginst, int gcnt, int gwidth,
+			  int raddr, int rinst, int rcnt, int rwidth)
+{
+	return readl(sdx5_addr(priv->regs, id, tinst, tcnt, gbase, ginst,
+			       gcnt, gwidth, raddr, rinst, rcnt, rwidth));
+}
+
+static inline void sdx5_rmw(u32 val, u32 mask, struct sparx5_serdes_private *priv,
+			    int id, int tinst, int tcnt,
+			    int gbase, int ginst, int gcnt, int gwidth,
+			    int raddr, int rinst, int rcnt, int rwidth)
+{
+	u32 nval;
+	void __iomem *addr =
+		sdx5_addr(priv->regs, id, tinst, tcnt,
+			  gbase, ginst, gcnt, gwidth,
+			  raddr, rinst, rcnt, rwidth);
+	nval = readl(addr);
+	nval = (nval & ~mask) | (val & mask);
+	writel(nval, addr);
+}
+
+static inline void sdx5_inst_rmw(u32 val, u32 mask, void __iomem *iomem,
+				 int id, int tinst, int tcnt,
+				 int gbase, int ginst, int gcnt, int gwidth,
+				 int raddr, int rinst, int rcnt, int rwidth)
+{
+	u32 nval;
+	void __iomem *addr =
+		sdx5_inst_addr(iomem,
+			       gbase, ginst, gcnt, gwidth,
+			       raddr, rinst, rcnt, rwidth);
+	nval = readl(addr);
+	nval = (nval & ~mask) | (val & mask);
+	writel(nval, addr);
+}
+
+static inline void __iomem *sdx5_inst_get(struct sparx5_serdes_private *priv,
+					  int id, int tinst)
+{
+	return priv->regs[id + tinst];
+}
+
+
+#endif /* _SPARX5_SERDES_REGS_H_ */
diff --git a/drivers/phy/microchip/sparx5_serdes_regs.h b/drivers/phy/microchip/sparx5_serdes_regs.h
new file mode 100644
index 000000000000..b96386a4df5a
--- /dev/null
+++ b/drivers/phy/microchip/sparx5_serdes_regs.h
@@ -0,0 +1,2695 @@
+/* SPDX-License-Identifier: GPL-2.0+
+ * Microchip Sparx5 SerDes driver
+ *
+ * Copyright (c) 2020 Microchip Technology Inc.
+ */
+
+/* This file is autogenerated by cml-utils 2020-11-16 13:11:27 +0100.
+ * Commit ID: 13bdf073131d8bf40c54901df6988ae4e9c8f29f
+ */
+
+#ifndef _SPARX5_SERDES_REGS_H_
+#define _SPARX5_SERDES_REGS_H_
+
+#include <linux/bitfield.h>
+#include <linux/types.h>
+#include <linux/bug.h>
+
+enum sparx5_serdes_target {
+	TARGET_SD10G_LANE = 200,
+	TARGET_SD25G_LANE = 212,
+	TARGET_SD6G_LANE = 233,
+	TARGET_SD_CMU = 248,
+	TARGET_SD_CMU_CFG = 262,
+	TARGET_SD_LANE = 276,
+	TARGET_SD_LANE_25G = 301,
+	NUM_TARGETS = 332
+};
+
+#define __REG(...)    __VA_ARGS__
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_01 */
+#define SD10G_LANE_LANE_01(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 4, 0, 1, 4)
+
+#define SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0 GENMASK(2, 0)
+#define SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0, x)
+#define SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0, x)
+
+#define SD10G_LANE_LANE_01_CFG_RXDET_EN          BIT(4)
+#define SD10G_LANE_LANE_01_CFG_RXDET_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_01_CFG_RXDET_EN, x)
+#define SD10G_LANE_LANE_01_CFG_RXDET_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_01_CFG_RXDET_EN, x)
+
+#define SD10G_LANE_LANE_01_CFG_RXDET_STR         BIT(5)
+#define SD10G_LANE_LANE_01_CFG_RXDET_STR_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_01_CFG_RXDET_STR, x)
+#define SD10G_LANE_LANE_01_CFG_RXDET_STR_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_01_CFG_RXDET_STR, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_02 */
+#define SD10G_LANE_LANE_02(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 8, 0, 1, 4)
+
+#define SD10G_LANE_LANE_02_CFG_EN_ADV            BIT(0)
+#define SD10G_LANE_LANE_02_CFG_EN_ADV_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_02_CFG_EN_ADV, x)
+#define SD10G_LANE_LANE_02_CFG_EN_ADV_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_02_CFG_EN_ADV, x)
+
+#define SD10G_LANE_LANE_02_CFG_EN_MAIN           BIT(1)
+#define SD10G_LANE_LANE_02_CFG_EN_MAIN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_02_CFG_EN_MAIN, x)
+#define SD10G_LANE_LANE_02_CFG_EN_MAIN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_02_CFG_EN_MAIN, x)
+
+#define SD10G_LANE_LANE_02_CFG_EN_DLY            BIT(2)
+#define SD10G_LANE_LANE_02_CFG_EN_DLY_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_02_CFG_EN_DLY, x)
+#define SD10G_LANE_LANE_02_CFG_EN_DLY_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_02_CFG_EN_DLY, x)
+
+#define SD10G_LANE_LANE_02_CFG_EN_DLY2           BIT(3)
+#define SD10G_LANE_LANE_02_CFG_EN_DLY2_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_02_CFG_EN_DLY2, x)
+#define SD10G_LANE_LANE_02_CFG_EN_DLY2_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_02_CFG_EN_DLY2, x)
+
+#define SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0       GENMASK(7, 4)
+#define SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0, x)
+#define SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_03 */
+#define SD10G_LANE_LANE_03(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 12, 0, 1, 4)
+
+#define SD10G_LANE_LANE_03_CFG_TAP_MAIN          BIT(0)
+#define SD10G_LANE_LANE_03_CFG_TAP_MAIN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_03_CFG_TAP_MAIN, x)
+#define SD10G_LANE_LANE_03_CFG_TAP_MAIN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_03_CFG_TAP_MAIN, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_04 */
+#define SD10G_LANE_LANE_04(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 16, 0, 1, 4)
+
+#define SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0       GENMASK(4, 0)
+#define SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0, x)
+#define SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_06 */
+#define SD10G_LANE_LANE_06(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 24, 0, 1, 4)
+
+#define SD10G_LANE_LANE_06_CFG_PD_DRIVER         BIT(0)
+#define SD10G_LANE_LANE_06_CFG_PD_DRIVER_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_06_CFG_PD_DRIVER, x)
+#define SD10G_LANE_LANE_06_CFG_PD_DRIVER_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_06_CFG_PD_DRIVER, x)
+
+#define SD10G_LANE_LANE_06_CFG_PD_CLK            BIT(1)
+#define SD10G_LANE_LANE_06_CFG_PD_CLK_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_06_CFG_PD_CLK, x)
+#define SD10G_LANE_LANE_06_CFG_PD_CLK_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_06_CFG_PD_CLK, x)
+
+#define SD10G_LANE_LANE_06_CFG_PD_CML            BIT(2)
+#define SD10G_LANE_LANE_06_CFG_PD_CML_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_06_CFG_PD_CML, x)
+#define SD10G_LANE_LANE_06_CFG_PD_CML_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_06_CFG_PD_CML, x)
+
+#define SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN       BIT(3)
+#define SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN, x)
+#define SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN, x)
+
+#define SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN       BIT(4)
+#define SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN, x)
+#define SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN, x)
+
+#define SD10G_LANE_LANE_06_CFG_EN_PREEMPH        BIT(5)
+#define SD10G_LANE_LANE_06_CFG_EN_PREEMPH_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_06_CFG_EN_PREEMPH, x)
+#define SD10G_LANE_LANE_06_CFG_EN_PREEMPH_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_06_CFG_EN_PREEMPH, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_0B */
+#define SD10G_LANE_LANE_0B(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 44, 0, 1, 4)
+
+#define SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0        GENMASK(3, 0)
+#define SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0, x)
+#define SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0, x)
+
+#define SD10G_LANE_LANE_0B_CFG_PD_CTLE           BIT(4)
+#define SD10G_LANE_LANE_0B_CFG_PD_CTLE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0B_CFG_PD_CTLE, x)
+#define SD10G_LANE_LANE_0B_CFG_PD_CTLE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0B_CFG_PD_CTLE, x)
+
+#define SD10G_LANE_LANE_0B_CFG_CTLE_TP_EN        BIT(5)
+#define SD10G_LANE_LANE_0B_CFG_CTLE_TP_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0B_CFG_CTLE_TP_EN, x)
+#define SD10G_LANE_LANE_0B_CFG_CTLE_TP_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0B_CFG_CTLE_TP_EN, x)
+
+#define SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE  BIT(6)
+#define SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE, x)
+#define SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE, x)
+
+#define SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_SQ   BIT(7)
+#define SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_SQ_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_SQ, x)
+#define SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_SQ_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_SQ, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_0C */
+#define SD10G_LANE_LANE_0C(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 48, 0, 1, 4)
+
+#define SD10G_LANE_LANE_0C_CFG_OSCAL_AFE         BIT(0)
+#define SD10G_LANE_LANE_0C_CFG_OSCAL_AFE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_OSCAL_AFE, x)
+#define SD10G_LANE_LANE_0C_CFG_OSCAL_AFE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_OSCAL_AFE, x)
+
+#define SD10G_LANE_LANE_0C_CFG_OSCAL_SQ          BIT(1)
+#define SD10G_LANE_LANE_0C_CFG_OSCAL_SQ_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_OSCAL_SQ, x)
+#define SD10G_LANE_LANE_0C_CFG_OSCAL_SQ_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_OSCAL_SQ, x)
+
+#define SD10G_LANE_LANE_0C_CFG_OSDAC_2X_AFE      BIT(2)
+#define SD10G_LANE_LANE_0C_CFG_OSDAC_2X_AFE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_OSDAC_2X_AFE, x)
+#define SD10G_LANE_LANE_0C_CFG_OSDAC_2X_AFE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_OSDAC_2X_AFE, x)
+
+#define SD10G_LANE_LANE_0C_CFG_OSDAC_2X_SQ       BIT(3)
+#define SD10G_LANE_LANE_0C_CFG_OSDAC_2X_SQ_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_OSDAC_2X_SQ, x)
+#define SD10G_LANE_LANE_0C_CFG_OSDAC_2X_SQ_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_OSDAC_2X_SQ, x)
+
+#define SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE      BIT(4)
+#define SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE, x)
+#define SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE, x)
+
+#define SD10G_LANE_LANE_0C_CFG_PD_OSDAC_SQ       BIT(5)
+#define SD10G_LANE_LANE_0C_CFG_PD_OSDAC_SQ_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_PD_OSDAC_SQ, x)
+#define SD10G_LANE_LANE_0C_CFG_PD_OSDAC_SQ_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_PD_OSDAC_SQ, x)
+
+#define SD10G_LANE_LANE_0C_CFG_PD_RX_LS          BIT(6)
+#define SD10G_LANE_LANE_0C_CFG_PD_RX_LS_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_PD_RX_LS, x)
+#define SD10G_LANE_LANE_0C_CFG_PD_RX_LS_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_PD_RX_LS, x)
+
+#define SD10G_LANE_LANE_0C_CFG_RX_PCIE_GEN12     BIT(7)
+#define SD10G_LANE_LANE_0C_CFG_RX_PCIE_GEN12_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0C_CFG_RX_PCIE_GEN12, x)
+#define SD10G_LANE_LANE_0C_CFG_RX_PCIE_GEN12_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0C_CFG_RX_PCIE_GEN12, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_0D */
+#define SD10G_LANE_LANE_0D(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 52, 0, 1, 4)
+
+#define SD10G_LANE_LANE_0D_CFG_CTLE_M_THR_1_0    GENMASK(1, 0)
+#define SD10G_LANE_LANE_0D_CFG_CTLE_M_THR_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0D_CFG_CTLE_M_THR_1_0, x)
+#define SD10G_LANE_LANE_0D_CFG_CTLE_M_THR_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0D_CFG_CTLE_M_THR_1_0, x)
+
+#define SD10G_LANE_LANE_0D_CFG_EQR_BYP           BIT(4)
+#define SD10G_LANE_LANE_0D_CFG_EQR_BYP_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0D_CFG_EQR_BYP, x)
+#define SD10G_LANE_LANE_0D_CFG_EQR_BYP_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0D_CFG_EQR_BYP, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_0E */
+#define SD10G_LANE_LANE_0E(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 56, 0, 1, 4)
+
+#define SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0     GENMASK(3, 0)
+#define SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0, x)
+#define SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0, x)
+
+#define SD10G_LANE_LANE_0E_CFG_RXLB_EN           BIT(4)
+#define SD10G_LANE_LANE_0E_CFG_RXLB_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0E_CFG_RXLB_EN, x)
+#define SD10G_LANE_LANE_0E_CFG_RXLB_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0E_CFG_RXLB_EN, x)
+
+#define SD10G_LANE_LANE_0E_CFG_TXLB_EN           BIT(5)
+#define SD10G_LANE_LANE_0E_CFG_TXLB_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0E_CFG_TXLB_EN, x)
+#define SD10G_LANE_LANE_0E_CFG_TXLB_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0E_CFG_TXLB_EN, x)
+
+#define SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN      BIT(6)
+#define SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN, x)
+#define SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_0F */
+#define SD10G_LANE_LANE_0F(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 60, 0, 1, 4)
+
+#define SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0      GENMASK(7, 0)
+#define SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0, x)
+#define SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_13 */
+#define SD10G_LANE_LANE_13(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 76, 0, 1, 4)
+
+#define SD10G_LANE_LANE_13_CFG_DCDR_PD           BIT(0)
+#define SD10G_LANE_LANE_13_CFG_DCDR_PD_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_13_CFG_DCDR_PD, x)
+#define SD10G_LANE_LANE_13_CFG_DCDR_PD_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_13_CFG_DCDR_PD, x)
+
+#define SD10G_LANE_LANE_13_CFG_PHID_1T           BIT(1)
+#define SD10G_LANE_LANE_13_CFG_PHID_1T_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_13_CFG_PHID_1T, x)
+#define SD10G_LANE_LANE_13_CFG_PHID_1T_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_13_CFG_PHID_1T, x)
+
+#define SD10G_LANE_LANE_13_CFG_CDRCK_EN          BIT(2)
+#define SD10G_LANE_LANE_13_CFG_CDRCK_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_13_CFG_CDRCK_EN, x)
+#define SD10G_LANE_LANE_13_CFG_CDRCK_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_13_CFG_CDRCK_EN, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_14 */
+#define SD10G_LANE_LANE_14(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 80, 0, 1, 4)
+
+#define SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0    GENMASK(7, 0)
+#define SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0, x)
+#define SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_15 */
+#define SD10G_LANE_LANE_15(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 84, 0, 1, 4)
+
+#define SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8   GENMASK(7, 0)
+#define SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8, x)
+#define SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_16 */
+#define SD10G_LANE_LANE_16(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 88, 0, 1, 4)
+
+#define SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16  GENMASK(7, 0)
+#define SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16, x)
+#define SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_1A */
+#define SD10G_LANE_LANE_1A(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 104, 0, 1, 4)
+
+#define SD10G_LANE_LANE_1A_CFG_PI_R_SCAN_EN      BIT(0)
+#define SD10G_LANE_LANE_1A_CFG_PI_R_SCAN_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_1A_CFG_PI_R_SCAN_EN, x)
+#define SD10G_LANE_LANE_1A_CFG_PI_R_SCAN_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_1A_CFG_PI_R_SCAN_EN, x)
+
+#define SD10G_LANE_LANE_1A_CFG_PI_EN             BIT(1)
+#define SD10G_LANE_LANE_1A_CFG_PI_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_1A_CFG_PI_EN, x)
+#define SD10G_LANE_LANE_1A_CFG_PI_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_1A_CFG_PI_EN, x)
+
+#define SD10G_LANE_LANE_1A_CFG_PI_DFE_EN         BIT(2)
+#define SD10G_LANE_LANE_1A_CFG_PI_DFE_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_1A_CFG_PI_DFE_EN, x)
+#define SD10G_LANE_LANE_1A_CFG_PI_DFE_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_1A_CFG_PI_DFE_EN, x)
+
+#define SD10G_LANE_LANE_1A_CFG_PI_STEPS          BIT(3)
+#define SD10G_LANE_LANE_1A_CFG_PI_STEPS_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_1A_CFG_PI_STEPS, x)
+#define SD10G_LANE_LANE_1A_CFG_PI_STEPS_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_1A_CFG_PI_STEPS, x)
+
+#define SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0 GENMASK(5, 4)
+#define SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0, x)
+#define SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_22 */
+#define SD10G_LANE_LANE_22(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 136, 0, 1, 4)
+
+#define SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1     GENMASK(4, 0)
+#define SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1, x)
+#define SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_23 */
+#define SD10G_LANE_LANE_23(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 140, 0, 1, 4)
+
+#define SD10G_LANE_LANE_23_CFG_DFE_PD            BIT(0)
+#define SD10G_LANE_LANE_23_CFG_DFE_PD_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_23_CFG_DFE_PD, x)
+#define SD10G_LANE_LANE_23_CFG_DFE_PD_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_23_CFG_DFE_PD, x)
+
+#define SD10G_LANE_LANE_23_CFG_EN_DFEDIG         BIT(1)
+#define SD10G_LANE_LANE_23_CFG_EN_DFEDIG_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_23_CFG_EN_DFEDIG, x)
+#define SD10G_LANE_LANE_23_CFG_EN_DFEDIG_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_23_CFG_EN_DFEDIG, x)
+
+#define SD10G_LANE_LANE_23_CFG_DFECK_EN          BIT(2)
+#define SD10G_LANE_LANE_23_CFG_DFECK_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_23_CFG_DFECK_EN, x)
+#define SD10G_LANE_LANE_23_CFG_DFECK_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_23_CFG_DFECK_EN, x)
+
+#define SD10G_LANE_LANE_23_CFG_ERRAMP_PD         BIT(3)
+#define SD10G_LANE_LANE_23_CFG_ERRAMP_PD_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_23_CFG_ERRAMP_PD, x)
+#define SD10G_LANE_LANE_23_CFG_ERRAMP_PD_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_23_CFG_ERRAMP_PD, x)
+
+#define SD10G_LANE_LANE_23_CFG_DFEDIG_M_2_0      GENMASK(6, 4)
+#define SD10G_LANE_LANE_23_CFG_DFEDIG_M_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_23_CFG_DFEDIG_M_2_0, x)
+#define SD10G_LANE_LANE_23_CFG_DFEDIG_M_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_23_CFG_DFEDIG_M_2_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_24 */
+#define SD10G_LANE_LANE_24(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 144, 0, 1, 4)
+
+#define SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0    GENMASK(3, 0)
+#define SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0, x)
+#define SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0, x)
+
+#define SD10G_LANE_LANE_24_CFG_PI_BW_GEN2_3_0    GENMASK(7, 4)
+#define SD10G_LANE_LANE_24_CFG_PI_BW_GEN2_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_24_CFG_PI_BW_GEN2_3_0, x)
+#define SD10G_LANE_LANE_24_CFG_PI_BW_GEN2_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_24_CFG_PI_BW_GEN2_3_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_26 */
+#define SD10G_LANE_LANE_26(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 152, 0, 1, 4)
+
+#define SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0 GENMASK(7, 0)
+#define SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0, x)
+#define SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_2F */
+#define SD10G_LANE_LANE_2F(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 188, 0, 1, 4)
+
+#define SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0        GENMASK(2, 0)
+#define SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0, x)
+#define SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0, x)
+
+#define SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0      GENMASK(7, 4)
+#define SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0, x)
+#define SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_30 */
+#define SD10G_LANE_LANE_30(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 192, 0, 1, 4)
+
+#define SD10G_LANE_LANE_30_CFG_SUMMER_EN         BIT(0)
+#define SD10G_LANE_LANE_30_CFG_SUMMER_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_30_CFG_SUMMER_EN, x)
+#define SD10G_LANE_LANE_30_CFG_SUMMER_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_30_CFG_SUMMER_EN, x)
+
+#define SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0     GENMASK(6, 4)
+#define SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0, x)
+#define SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_31 */
+#define SD10G_LANE_LANE_31(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 196, 0, 1, 4)
+
+#define SD10G_LANE_LANE_31_CFG_PI_RSTN           BIT(0)
+#define SD10G_LANE_LANE_31_CFG_PI_RSTN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_31_CFG_PI_RSTN, x)
+#define SD10G_LANE_LANE_31_CFG_PI_RSTN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_31_CFG_PI_RSTN, x)
+
+#define SD10G_LANE_LANE_31_CFG_CDR_RSTN          BIT(1)
+#define SD10G_LANE_LANE_31_CFG_CDR_RSTN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_31_CFG_CDR_RSTN, x)
+#define SD10G_LANE_LANE_31_CFG_CDR_RSTN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_31_CFG_CDR_RSTN, x)
+
+#define SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG       BIT(2)
+#define SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG, x)
+#define SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG, x)
+
+#define SD10G_LANE_LANE_31_CFG_CTLE_RSTN         BIT(3)
+#define SD10G_LANE_LANE_31_CFG_CTLE_RSTN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_31_CFG_CTLE_RSTN, x)
+#define SD10G_LANE_LANE_31_CFG_CTLE_RSTN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_31_CFG_CTLE_RSTN, x)
+
+#define SD10G_LANE_LANE_31_CFG_RSTN_DIV5_8       BIT(4)
+#define SD10G_LANE_LANE_31_CFG_RSTN_DIV5_8_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_31_CFG_RSTN_DIV5_8, x)
+#define SD10G_LANE_LANE_31_CFG_RSTN_DIV5_8_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_31_CFG_RSTN_DIV5_8, x)
+
+#define SD10G_LANE_LANE_31_CFG_R50_EN            BIT(5)
+#define SD10G_LANE_LANE_31_CFG_R50_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_31_CFG_R50_EN, x)
+#define SD10G_LANE_LANE_31_CFG_R50_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_31_CFG_R50_EN, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_32 */
+#define SD10G_LANE_LANE_32(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 200, 0, 1, 4)
+
+#define SD10G_LANE_LANE_32_CFG_ITX_IPCLK_BASE_1_0 GENMASK(1, 0)
+#define SD10G_LANE_LANE_32_CFG_ITX_IPCLK_BASE_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_32_CFG_ITX_IPCLK_BASE_1_0, x)
+#define SD10G_LANE_LANE_32_CFG_ITX_IPCLK_BASE_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_32_CFG_ITX_IPCLK_BASE_1_0, x)
+
+#define SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0 GENMASK(5, 4)
+#define SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0, x)
+#define SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_33 */
+#define SD10G_LANE_LANE_33(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 204, 0, 1, 4)
+
+#define SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0 GENMASK(2, 0)
+#define SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0, x)
+#define SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0, x)
+
+#define SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0 GENMASK(5, 4)
+#define SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0, x)
+#define SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_35 */
+#define SD10G_LANE_LANE_35(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 212, 0, 1, 4)
+
+#define SD10G_LANE_LANE_35_CFG_TXRATE_1_0        GENMASK(1, 0)
+#define SD10G_LANE_LANE_35_CFG_TXRATE_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_35_CFG_TXRATE_1_0, x)
+#define SD10G_LANE_LANE_35_CFG_TXRATE_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_35_CFG_TXRATE_1_0, x)
+
+#define SD10G_LANE_LANE_35_CFG_RXRATE_1_0        GENMASK(5, 4)
+#define SD10G_LANE_LANE_35_CFG_RXRATE_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_35_CFG_RXRATE_1_0, x)
+#define SD10G_LANE_LANE_35_CFG_RXRATE_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_35_CFG_RXRATE_1_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_36 */
+#define SD10G_LANE_LANE_36(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 216, 0, 1, 4)
+
+#define SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0 GENMASK(1, 0)
+#define SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0, x)
+#define SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0, x)
+
+#define SD10G_LANE_LANE_36_CFG_EID_LP            BIT(4)
+#define SD10G_LANE_LANE_36_CFG_EID_LP_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_36_CFG_EID_LP, x)
+#define SD10G_LANE_LANE_36_CFG_EID_LP_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_36_CFG_EID_LP, x)
+
+#define SD10G_LANE_LANE_36_CFG_EN_PREDRV_EMPH    BIT(5)
+#define SD10G_LANE_LANE_36_CFG_EN_PREDRV_EMPH_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_36_CFG_EN_PREDRV_EMPH, x)
+#define SD10G_LANE_LANE_36_CFG_EN_PREDRV_EMPH_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_36_CFG_EN_PREDRV_EMPH, x)
+
+#define SD10G_LANE_LANE_36_CFG_PRBS_SEL          BIT(6)
+#define SD10G_LANE_LANE_36_CFG_PRBS_SEL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_36_CFG_PRBS_SEL, x)
+#define SD10G_LANE_LANE_36_CFG_PRBS_SEL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_36_CFG_PRBS_SEL, x)
+
+#define SD10G_LANE_LANE_36_CFG_PRBS_SETB         BIT(7)
+#define SD10G_LANE_LANE_36_CFG_PRBS_SETB_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_36_CFG_PRBS_SETB, x)
+#define SD10G_LANE_LANE_36_CFG_PRBS_SETB_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_36_CFG_PRBS_SETB, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_37 */
+#define SD10G_LANE_LANE_37(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 220, 0, 1, 4)
+
+#define SD10G_LANE_LANE_37_CFG_RXDET_COMP_PD     BIT(0)
+#define SD10G_LANE_LANE_37_CFG_RXDET_COMP_PD_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_37_CFG_RXDET_COMP_PD, x)
+#define SD10G_LANE_LANE_37_CFG_RXDET_COMP_PD_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_37_CFG_RXDET_COMP_PD, x)
+
+#define SD10G_LANE_LANE_37_CFG_PD_RX_CKTREE      BIT(1)
+#define SD10G_LANE_LANE_37_CFG_PD_RX_CKTREE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_37_CFG_PD_RX_CKTREE, x)
+#define SD10G_LANE_LANE_37_CFG_PD_RX_CKTREE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_37_CFG_PD_RX_CKTREE, x)
+
+#define SD10G_LANE_LANE_37_CFG_TXSWING_HALF      BIT(2)
+#define SD10G_LANE_LANE_37_CFG_TXSWING_HALF_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_37_CFG_TXSWING_HALF, x)
+#define SD10G_LANE_LANE_37_CFG_TXSWING_HALF_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_37_CFG_TXSWING_HALF, x)
+
+#define SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0   GENMASK(5, 4)
+#define SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0, x)
+#define SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_39 */
+#define SD10G_LANE_LANE_39(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 228, 0, 1, 4)
+
+#define SD10G_LANE_LANE_39_CFG_RXFILT_Y_2_0      GENMASK(2, 0)
+#define SD10G_LANE_LANE_39_CFG_RXFILT_Y_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_39_CFG_RXFILT_Y_2_0, x)
+#define SD10G_LANE_LANE_39_CFG_RXFILT_Y_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_39_CFG_RXFILT_Y_2_0, x)
+
+#define SD10G_LANE_LANE_39_CFG_RX_SSC_LH         BIT(4)
+#define SD10G_LANE_LANE_39_CFG_RX_SSC_LH_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_39_CFG_RX_SSC_LH, x)
+#define SD10G_LANE_LANE_39_CFG_RX_SSC_LH_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_39_CFG_RX_SSC_LH, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_3A */
+#define SD10G_LANE_LANE_3A(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 232, 0, 1, 4)
+
+#define SD10G_LANE_LANE_3A_CFG_MP_MIN_3_0        GENMASK(3, 0)
+#define SD10G_LANE_LANE_3A_CFG_MP_MIN_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_3A_CFG_MP_MIN_3_0, x)
+#define SD10G_LANE_LANE_3A_CFG_MP_MIN_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_3A_CFG_MP_MIN_3_0, x)
+
+#define SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0        GENMASK(7, 4)
+#define SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0, x)
+#define SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_3C */
+#define SD10G_LANE_LANE_3C(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 240, 0, 1, 4)
+
+#define SD10G_LANE_LANE_3C_CFG_DIS_ACC           BIT(0)
+#define SD10G_LANE_LANE_3C_CFG_DIS_ACC_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_3C_CFG_DIS_ACC, x)
+#define SD10G_LANE_LANE_3C_CFG_DIS_ACC_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_3C_CFG_DIS_ACC, x)
+
+#define SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER      BIT(1)
+#define SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER, x)
+#define SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_40 */
+#define SD10G_LANE_LANE_40(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 256, 0, 1, 4)
+
+#define SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0  GENMASK(7, 0)
+#define SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0, x)
+#define SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_41 */
+#define SD10G_LANE_LANE_41(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 260, 0, 1, 4)
+
+#define SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8 GENMASK(7, 0)
+#define SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8, x)
+#define SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_0:LANE_42 */
+#define SD10G_LANE_LANE_42(t)     __REG(TARGET_SD10G_LANE, t, 12, 0, 0, 1, 288, 264, 0, 1, 4)
+
+#define SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0   GENMASK(2, 0)
+#define SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0, x)
+#define SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0, x)
+
+#define SD10G_LANE_LANE_42_CFG_CDR_KF_GEN2_2_0   GENMASK(6, 4)
+#define SD10G_LANE_LANE_42_CFG_CDR_KF_GEN2_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_42_CFG_CDR_KF_GEN2_2_0, x)
+#define SD10G_LANE_LANE_42_CFG_CDR_KF_GEN2_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_42_CFG_CDR_KF_GEN2_2_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_1:LANE_48 */
+#define SD10G_LANE_LANE_48(t)     __REG(TARGET_SD10G_LANE, t, 12, 288, 0, 1, 40, 0, 0, 1, 4)
+
+#define SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0      GENMASK(3, 0)
+#define SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0, x)
+#define SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0, x)
+
+#define SD10G_LANE_LANE_48_CFG_AUX_RXCK_SEL      BIT(4)
+#define SD10G_LANE_LANE_48_CFG_AUX_RXCK_SEL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_48_CFG_AUX_RXCK_SEL, x)
+#define SD10G_LANE_LANE_48_CFG_AUX_RXCK_SEL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_48_CFG_AUX_RXCK_SEL, x)
+
+#define SD10G_LANE_LANE_48_CFG_CLK_ENQ           BIT(5)
+#define SD10G_LANE_LANE_48_CFG_CLK_ENQ_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_48_CFG_CLK_ENQ, x)
+#define SD10G_LANE_LANE_48_CFG_CLK_ENQ_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_48_CFG_CLK_ENQ, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_1:LANE_50 */
+#define SD10G_LANE_LANE_50(t)     __REG(TARGET_SD10G_LANE, t, 12, 288, 0, 1, 40, 32, 0, 1, 4)
+
+#define SD10G_LANE_LANE_50_CFG_SSC_PI_STEP_1_0   GENMASK(1, 0)
+#define SD10G_LANE_LANE_50_CFG_SSC_PI_STEP_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_50_CFG_SSC_PI_STEP_1_0, x)
+#define SD10G_LANE_LANE_50_CFG_SSC_PI_STEP_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_50_CFG_SSC_PI_STEP_1_0, x)
+
+#define SD10G_LANE_LANE_50_CFG_SSC_RESETB        BIT(4)
+#define SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_50_CFG_SSC_RESETB, x)
+#define SD10G_LANE_LANE_50_CFG_SSC_RESETB_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_50_CFG_SSC_RESETB, x)
+
+#define SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL   BIT(5)
+#define SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL, x)
+#define SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL, x)
+
+#define SD10G_LANE_LANE_50_CFG_AUX_TXCK_SEL      BIT(6)
+#define SD10G_LANE_LANE_50_CFG_AUX_TXCK_SEL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_50_CFG_AUX_TXCK_SEL, x)
+#define SD10G_LANE_LANE_50_CFG_AUX_TXCK_SEL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_50_CFG_AUX_TXCK_SEL, x)
+
+#define SD10G_LANE_LANE_50_CFG_JT_EN             BIT(7)
+#define SD10G_LANE_LANE_50_CFG_JT_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_50_CFG_JT_EN, x)
+#define SD10G_LANE_LANE_50_CFG_JT_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_50_CFG_JT_EN, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_2:LANE_52 */
+#define SD10G_LANE_LANE_52(t)     __REG(TARGET_SD10G_LANE, t, 12, 328, 0, 1, 24, 0, 0, 1, 4)
+
+#define SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0 GENMASK(5, 0)
+#define SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0, x)
+#define SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_4:LANE_83 */
+#define SD10G_LANE_LANE_83(t)     __REG(TARGET_SD10G_LANE, t, 12, 464, 0, 1, 112, 60, 0, 1, 4)
+
+#define SD10G_LANE_LANE_83_R_TX_BIT_REVERSE      BIT(0)
+#define SD10G_LANE_LANE_83_R_TX_BIT_REVERSE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_83_R_TX_BIT_REVERSE, x)
+#define SD10G_LANE_LANE_83_R_TX_BIT_REVERSE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_83_R_TX_BIT_REVERSE, x)
+
+#define SD10G_LANE_LANE_83_R_TX_POL_INV          BIT(1)
+#define SD10G_LANE_LANE_83_R_TX_POL_INV_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_83_R_TX_POL_INV, x)
+#define SD10G_LANE_LANE_83_R_TX_POL_INV_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_83_R_TX_POL_INV, x)
+
+#define SD10G_LANE_LANE_83_R_RX_BIT_REVERSE      BIT(2)
+#define SD10G_LANE_LANE_83_R_RX_BIT_REVERSE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_83_R_RX_BIT_REVERSE, x)
+#define SD10G_LANE_LANE_83_R_RX_BIT_REVERSE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_83_R_RX_BIT_REVERSE, x)
+
+#define SD10G_LANE_LANE_83_R_RX_POL_INV          BIT(3)
+#define SD10G_LANE_LANE_83_R_RX_POL_INV_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_83_R_RX_POL_INV, x)
+#define SD10G_LANE_LANE_83_R_RX_POL_INV_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_83_R_RX_POL_INV, x)
+
+#define SD10G_LANE_LANE_83_R_DFE_RSTN            BIT(4)
+#define SD10G_LANE_LANE_83_R_DFE_RSTN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_83_R_DFE_RSTN, x)
+#define SD10G_LANE_LANE_83_R_DFE_RSTN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_83_R_DFE_RSTN, x)
+
+#define SD10G_LANE_LANE_83_R_CDR_RSTN            BIT(5)
+#define SD10G_LANE_LANE_83_R_CDR_RSTN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_83_R_CDR_RSTN, x)
+#define SD10G_LANE_LANE_83_R_CDR_RSTN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_83_R_CDR_RSTN, x)
+
+#define SD10G_LANE_LANE_83_R_CTLE_RSTN           BIT(6)
+#define SD10G_LANE_LANE_83_R_CTLE_RSTN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_83_R_CTLE_RSTN, x)
+#define SD10G_LANE_LANE_83_R_CTLE_RSTN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_83_R_CTLE_RSTN, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_5:LANE_93 */
+#define SD10G_LANE_LANE_93(t)     __REG(TARGET_SD10G_LANE, t, 12, 576, 0, 1, 64, 12, 0, 1, 4)
+
+#define SD10G_LANE_LANE_93_R_RXEI_FIFO_RST_EN    BIT(0)
+#define SD10G_LANE_LANE_93_R_RXEI_FIFO_RST_EN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_RXEI_FIFO_RST_EN, x)
+#define SD10G_LANE_LANE_93_R_RXEI_FIFO_RST_EN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_RXEI_FIFO_RST_EN, x)
+
+#define SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT BIT(1)
+#define SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT, x)
+#define SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT, x)
+
+#define SD10G_LANE_LANE_93_R_DIS_RESTORE_DFE     BIT(2)
+#define SD10G_LANE_LANE_93_R_DIS_RESTORE_DFE_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_DIS_RESTORE_DFE, x)
+#define SD10G_LANE_LANE_93_R_DIS_RESTORE_DFE_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_DIS_RESTORE_DFE, x)
+
+#define SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL     BIT(3)
+#define SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL, x)
+#define SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL, x)
+
+#define SD10G_LANE_LANE_93_R_REG_MANUAL          BIT(4)
+#define SD10G_LANE_LANE_93_R_REG_MANUAL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_REG_MANUAL, x)
+#define SD10G_LANE_LANE_93_R_REG_MANUAL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_REG_MANUAL, x)
+
+#define SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT   BIT(5)
+#define SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT, x)
+#define SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT, x)
+
+#define SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT    BIT(6)
+#define SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT, x)
+#define SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT, x)
+
+#define SD10G_LANE_LANE_93_R_RX_PCIE_GEN12_FROM_HWT BIT(7)
+#define SD10G_LANE_LANE_93_R_RX_PCIE_GEN12_FROM_HWT_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_93_R_RX_PCIE_GEN12_FROM_HWT, x)
+#define SD10G_LANE_LANE_93_R_RX_PCIE_GEN12_FROM_HWT_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_93_R_RX_PCIE_GEN12_FROM_HWT, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_5:LANE_94 */
+#define SD10G_LANE_LANE_94(t)     __REG(TARGET_SD10G_LANE, t, 12, 576, 0, 1, 64, 16, 0, 1, 4)
+
+#define SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0      GENMASK(2, 0)
+#define SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0, x)
+#define SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0, x)
+
+#define SD10G_LANE_LANE_94_R_ISCAN_REG           BIT(4)
+#define SD10G_LANE_LANE_94_R_ISCAN_REG_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_94_R_ISCAN_REG, x)
+#define SD10G_LANE_LANE_94_R_ISCAN_REG_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_94_R_ISCAN_REG, x)
+
+#define SD10G_LANE_LANE_94_R_TXEQ_REG            BIT(5)
+#define SD10G_LANE_LANE_94_R_TXEQ_REG_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_94_R_TXEQ_REG, x)
+#define SD10G_LANE_LANE_94_R_TXEQ_REG_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_94_R_TXEQ_REG, x)
+
+#define SD10G_LANE_LANE_94_R_MISC_REG            BIT(6)
+#define SD10G_LANE_LANE_94_R_MISC_REG_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_94_R_MISC_REG, x)
+#define SD10G_LANE_LANE_94_R_MISC_REG_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_94_R_MISC_REG, x)
+
+#define SD10G_LANE_LANE_94_R_SWING_REG           BIT(7)
+#define SD10G_LANE_LANE_94_R_SWING_REG_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_94_R_SWING_REG, x)
+#define SD10G_LANE_LANE_94_R_SWING_REG_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_94_R_SWING_REG, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_5:LANE_9E */
+#define SD10G_LANE_LANE_9E(t)     __REG(TARGET_SD10G_LANE, t, 12, 576, 0, 1, 64, 56, 0, 1, 4)
+
+#define SD10G_LANE_LANE_9E_R_RXEQ_REG            BIT(0)
+#define SD10G_LANE_LANE_9E_R_RXEQ_REG_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_9E_R_RXEQ_REG, x)
+#define SD10G_LANE_LANE_9E_R_RXEQ_REG_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_9E_R_RXEQ_REG, x)
+
+#define SD10G_LANE_LANE_9E_R_AUTO_RST_TREE_PD_MAN BIT(1)
+#define SD10G_LANE_LANE_9E_R_AUTO_RST_TREE_PD_MAN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_9E_R_AUTO_RST_TREE_PD_MAN, x)
+#define SD10G_LANE_LANE_9E_R_AUTO_RST_TREE_PD_MAN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_9E_R_AUTO_RST_TREE_PD_MAN, x)
+
+#define SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN    BIT(2)
+#define SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN, x)
+#define SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_6:LANE_A1 */
+#define SD10G_LANE_LANE_A1(t)     __REG(TARGET_SD10G_LANE, t, 12, 640, 0, 1, 128, 4, 0, 1, 4)
+
+#define SD10G_LANE_LANE_A1_R_PMA_TXCK_DIV_SEL_1_0 GENMASK(1, 0)
+#define SD10G_LANE_LANE_A1_R_PMA_TXCK_DIV_SEL_1_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_A1_R_PMA_TXCK_DIV_SEL_1_0, x)
+#define SD10G_LANE_LANE_A1_R_PMA_TXCK_DIV_SEL_1_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_A1_R_PMA_TXCK_DIV_SEL_1_0, x)
+
+#define SD10G_LANE_LANE_A1_R_SSC_FROM_HWT        BIT(4)
+#define SD10G_LANE_LANE_A1_R_SSC_FROM_HWT_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_A1_R_SSC_FROM_HWT, x)
+#define SD10G_LANE_LANE_A1_R_SSC_FROM_HWT_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_A1_R_SSC_FROM_HWT, x)
+
+#define SD10G_LANE_LANE_A1_R_CDR_FROM_HWT        BIT(5)
+#define SD10G_LANE_LANE_A1_R_CDR_FROM_HWT_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_A1_R_CDR_FROM_HWT, x)
+#define SD10G_LANE_LANE_A1_R_CDR_FROM_HWT_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_A1_R_CDR_FROM_HWT, x)
+
+#define SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT BIT(6)
+#define SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT, x)
+#define SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT, x)
+
+#define SD10G_LANE_LANE_A1_R_PCLK_GATING         BIT(7)
+#define SD10G_LANE_LANE_A1_R_PCLK_GATING_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_A1_R_PCLK_GATING, x)
+#define SD10G_LANE_LANE_A1_R_PCLK_GATING_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_A1_R_PCLK_GATING, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_6:LANE_A2 */
+#define SD10G_LANE_LANE_A2(t)     __REG(TARGET_SD10G_LANE, t, 12, 640, 0, 1, 128, 8, 0, 1, 4)
+
+#define SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0 GENMASK(4, 0)
+#define SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0, x)
+#define SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_8:LANE_DF */
+#define SD10G_LANE_LANE_DF(t)     __REG(TARGET_SD10G_LANE, t, 12, 832, 0, 1, 84, 60, 0, 1, 4)
+
+#define SD10G_LANE_LANE_DF_LOL_UDL               BIT(0)
+#define SD10G_LANE_LANE_DF_LOL_UDL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_DF_LOL_UDL, x)
+#define SD10G_LANE_LANE_DF_LOL_UDL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_DF_LOL_UDL, x)
+
+#define SD10G_LANE_LANE_DF_LOL                   BIT(1)
+#define SD10G_LANE_LANE_DF_LOL_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_DF_LOL, x)
+#define SD10G_LANE_LANE_DF_LOL_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_DF_LOL, x)
+
+#define SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED BIT(2)
+#define SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED, x)
+#define SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED, x)
+
+#define SD10G_LANE_LANE_DF_SQUELCH               BIT(3)
+#define SD10G_LANE_LANE_DF_SQUELCH_SET(x)\
+	FIELD_PREP(SD10G_LANE_LANE_DF_SQUELCH, x)
+#define SD10G_LANE_LANE_DF_SQUELCH_GET(x)\
+	FIELD_GET(SD10G_LANE_LANE_DF_SQUELCH, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_09 */
+#define SD25G_LANE_CMU_09(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 36, 0, 1, 4)
+
+#define SD25G_LANE_CMU_09_CFG_REFCK_TERM_EN      BIT(0)
+#define SD25G_LANE_CMU_09_CFG_REFCK_TERM_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_09_CFG_REFCK_TERM_EN, x)
+#define SD25G_LANE_CMU_09_CFG_REFCK_TERM_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_09_CFG_REFCK_TERM_EN, x)
+
+#define SD25G_LANE_CMU_09_CFG_EN_DUMMY           BIT(1)
+#define SD25G_LANE_CMU_09_CFG_EN_DUMMY_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_09_CFG_EN_DUMMY, x)
+#define SD25G_LANE_CMU_09_CFG_EN_DUMMY_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_09_CFG_EN_DUMMY, x)
+
+#define SD25G_LANE_CMU_09_CFG_PLL_LOS_SET        BIT(2)
+#define SD25G_LANE_CMU_09_CFG_PLL_LOS_SET_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_09_CFG_PLL_LOS_SET, x)
+#define SD25G_LANE_CMU_09_CFG_PLL_LOS_SET_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_09_CFG_PLL_LOS_SET, x)
+
+#define SD25G_LANE_CMU_09_CFG_CTRL_LOGIC_PD      BIT(3)
+#define SD25G_LANE_CMU_09_CFG_CTRL_LOGIC_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_09_CFG_CTRL_LOGIC_PD, x)
+#define SD25G_LANE_CMU_09_CFG_CTRL_LOGIC_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_09_CFG_CTRL_LOGIC_PD, x)
+
+#define SD25G_LANE_CMU_09_CFG_PLL_TP_SEL_1_0     GENMASK(5, 4)
+#define SD25G_LANE_CMU_09_CFG_PLL_TP_SEL_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_09_CFG_PLL_TP_SEL_1_0, x)
+#define SD25G_LANE_CMU_09_CFG_PLL_TP_SEL_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_09_CFG_PLL_TP_SEL_1_0, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_0B */
+#define SD25G_LANE_CMU_0B(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 44, 0, 1, 4)
+
+#define SD25G_LANE_CMU_0B_CFG_FORCE_RX_FILT      BIT(0)
+#define SD25G_LANE_CMU_0B_CFG_FORCE_RX_FILT_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_FORCE_RX_FILT, x)
+#define SD25G_LANE_CMU_0B_CFG_FORCE_RX_FILT_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_FORCE_RX_FILT, x)
+
+#define SD25G_LANE_CMU_0B_CFG_DISLOL             BIT(1)
+#define SD25G_LANE_CMU_0B_CFG_DISLOL_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_DISLOL, x)
+#define SD25G_LANE_CMU_0B_CFG_DISLOL_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_DISLOL, x)
+
+#define SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN_EN BIT(2)
+#define SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN_EN, x)
+#define SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN_EN, x)
+
+#define SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN     BIT(3)
+#define SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN, x)
+#define SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN, x)
+
+#define SD25G_LANE_CMU_0B_CFG_VFILT2PAD          BIT(4)
+#define SD25G_LANE_CMU_0B_CFG_VFILT2PAD_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_VFILT2PAD, x)
+#define SD25G_LANE_CMU_0B_CFG_VFILT2PAD_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_VFILT2PAD, x)
+
+#define SD25G_LANE_CMU_0B_CFG_DISLOS             BIT(5)
+#define SD25G_LANE_CMU_0B_CFG_DISLOS_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_DISLOS, x)
+#define SD25G_LANE_CMU_0B_CFG_DISLOS_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_DISLOS, x)
+
+#define SD25G_LANE_CMU_0B_CFG_DCLOL              BIT(6)
+#define SD25G_LANE_CMU_0B_CFG_DCLOL_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_DCLOL, x)
+#define SD25G_LANE_CMU_0B_CFG_DCLOL_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_DCLOL, x)
+
+#define SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN    BIT(7)
+#define SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN, x)
+#define SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0B_CFG_RST_TREE_PD_MAN, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_0C */
+#define SD25G_LANE_CMU_0C(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 48, 0, 1, 4)
+
+#define SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET        BIT(0)
+#define SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET, x)
+#define SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET, x)
+
+#define SD25G_LANE_CMU_0C_CFG_EN_TX_CK_DN        BIT(1)
+#define SD25G_LANE_CMU_0C_CFG_EN_TX_CK_DN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0C_CFG_EN_TX_CK_DN, x)
+#define SD25G_LANE_CMU_0C_CFG_EN_TX_CK_DN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0C_CFG_EN_TX_CK_DN, x)
+
+#define SD25G_LANE_CMU_0C_CFG_VCO_PD             BIT(2)
+#define SD25G_LANE_CMU_0C_CFG_VCO_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0C_CFG_VCO_PD, x)
+#define SD25G_LANE_CMU_0C_CFG_VCO_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0C_CFG_VCO_PD, x)
+
+#define SD25G_LANE_CMU_0C_CFG_EN_TX_CK_UP        BIT(3)
+#define SD25G_LANE_CMU_0C_CFG_EN_TX_CK_UP_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0C_CFG_EN_TX_CK_UP, x)
+#define SD25G_LANE_CMU_0C_CFG_EN_TX_CK_UP_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0C_CFG_EN_TX_CK_UP, x)
+
+#define SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0   GENMASK(5, 4)
+#define SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0, x)
+#define SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_0D */
+#define SD25G_LANE_CMU_0D(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 52, 0, 1, 4)
+
+#define SD25G_LANE_CMU_0D_CFG_CK_TREE_PD         BIT(0)
+#define SD25G_LANE_CMU_0D_CFG_CK_TREE_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0D_CFG_CK_TREE_PD, x)
+#define SD25G_LANE_CMU_0D_CFG_CK_TREE_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0D_CFG_CK_TREE_PD, x)
+
+#define SD25G_LANE_CMU_0D_CFG_EN_RX_CK_DN        BIT(1)
+#define SD25G_LANE_CMU_0D_CFG_EN_RX_CK_DN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0D_CFG_EN_RX_CK_DN, x)
+#define SD25G_LANE_CMU_0D_CFG_EN_RX_CK_DN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0D_CFG_EN_RX_CK_DN, x)
+
+#define SD25G_LANE_CMU_0D_CFG_EN_RX_CK_UP        BIT(2)
+#define SD25G_LANE_CMU_0D_CFG_EN_RX_CK_UP_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0D_CFG_EN_RX_CK_UP, x)
+#define SD25G_LANE_CMU_0D_CFG_EN_RX_CK_UP_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0D_CFG_EN_RX_CK_UP, x)
+
+#define SD25G_LANE_CMU_0D_CFG_VCO_CAL_BYP        BIT(3)
+#define SD25G_LANE_CMU_0D_CFG_VCO_CAL_BYP_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0D_CFG_VCO_CAL_BYP, x)
+#define SD25G_LANE_CMU_0D_CFG_VCO_CAL_BYP_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0D_CFG_VCO_CAL_BYP, x)
+
+#define SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0     GENMASK(5, 4)
+#define SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0, x)
+#define SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_0E */
+#define SD25G_LANE_CMU_0E(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 56, 0, 1, 4)
+
+#define SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0        GENMASK(3, 0)
+#define SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0, x)
+#define SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0, x)
+
+#define SD25G_LANE_CMU_0E_CFG_PMAA_CENTR_CK_PD   BIT(4)
+#define SD25G_LANE_CMU_0E_CFG_PMAA_CENTR_CK_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_0E_CFG_PMAA_CENTR_CK_PD, x)
+#define SD25G_LANE_CMU_0E_CFG_PMAA_CENTR_CK_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_0E_CFG_PMAA_CENTR_CK_PD, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_13 */
+#define SD25G_LANE_CMU_13(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 76, 0, 1, 4)
+
+#define SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0    GENMASK(3, 0)
+#define SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0, x)
+#define SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0, x)
+
+#define SD25G_LANE_CMU_13_CFG_JT_EN              BIT(4)
+#define SD25G_LANE_CMU_13_CFG_JT_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_13_CFG_JT_EN, x)
+#define SD25G_LANE_CMU_13_CFG_JT_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_13_CFG_JT_EN, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_18 */
+#define SD25G_LANE_CMU_18(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 96, 0, 1, 4)
+
+#define SD25G_LANE_CMU_18_R_PLL_RSTN             BIT(0)
+#define SD25G_LANE_CMU_18_R_PLL_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_18_R_PLL_RSTN, x)
+#define SD25G_LANE_CMU_18_R_PLL_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_18_R_PLL_RSTN, x)
+
+#define SD25G_LANE_CMU_18_R_PLL_LOL_SET          BIT(1)
+#define SD25G_LANE_CMU_18_R_PLL_LOL_SET_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_18_R_PLL_LOL_SET, x)
+#define SD25G_LANE_CMU_18_R_PLL_LOL_SET_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_18_R_PLL_LOL_SET, x)
+
+#define SD25G_LANE_CMU_18_R_PLL_LOS_SET          BIT(2)
+#define SD25G_LANE_CMU_18_R_PLL_LOS_SET_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_18_R_PLL_LOS_SET, x)
+#define SD25G_LANE_CMU_18_R_PLL_LOS_SET_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_18_R_PLL_LOS_SET, x)
+
+#define SD25G_LANE_CMU_18_R_PLL_TP_SEL_1_0       GENMASK(5, 4)
+#define SD25G_LANE_CMU_18_R_PLL_TP_SEL_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_18_R_PLL_TP_SEL_1_0, x)
+#define SD25G_LANE_CMU_18_R_PLL_TP_SEL_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_18_R_PLL_TP_SEL_1_0, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_19 */
+#define SD25G_LANE_CMU_19(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 100, 0, 1, 4)
+
+#define SD25G_LANE_CMU_19_R_CK_RESETB            BIT(0)
+#define SD25G_LANE_CMU_19_R_CK_RESETB_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_19_R_CK_RESETB, x)
+#define SD25G_LANE_CMU_19_R_CK_RESETB_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_19_R_CK_RESETB, x)
+
+#define SD25G_LANE_CMU_19_R_PLL_DLOL_EN          BIT(1)
+#define SD25G_LANE_CMU_19_R_PLL_DLOL_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_19_R_PLL_DLOL_EN, x)
+#define SD25G_LANE_CMU_19_R_PLL_DLOL_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_19_R_PLL_DLOL_EN, x)
+
+/*      SD25G_TARGET:CMU_GRP_0:CMU_1A */
+#define SD25G_LANE_CMU_1A(t)      __REG(TARGET_SD25G_LANE, t, 8, 0, 0, 1, 132, 104, 0, 1, 4)
+
+#define SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0       GENMASK(2, 0)
+#define SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0, x)
+#define SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0, x)
+
+#define SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT  BIT(4)
+#define SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT, x)
+#define SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT, x)
+
+#define SD25G_LANE_CMU_1A_R_MASK_EI_SOURCE       BIT(5)
+#define SD25G_LANE_CMU_1A_R_MASK_EI_SOURCE_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_1A_R_MASK_EI_SOURCE, x)
+#define SD25G_LANE_CMU_1A_R_MASK_EI_SOURCE_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_1A_R_MASK_EI_SOURCE, x)
+
+#define SD25G_LANE_CMU_1A_R_REG_MANUAL           BIT(6)
+#define SD25G_LANE_CMU_1A_R_REG_MANUAL_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_1A_R_REG_MANUAL, x)
+#define SD25G_LANE_CMU_1A_R_REG_MANUAL_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_1A_R_REG_MANUAL, x)
+
+/*      SD25G_TARGET:CMU_GRP_1:CMU_2A */
+#define SD25G_LANE_CMU_2A(t)      __REG(TARGET_SD25G_LANE, t, 8, 132, 0, 1, 124, 36, 0, 1, 4)
+
+#define SD25G_LANE_CMU_2A_R_DBG_SEL_1_0          GENMASK(1, 0)
+#define SD25G_LANE_CMU_2A_R_DBG_SEL_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_2A_R_DBG_SEL_1_0, x)
+#define SD25G_LANE_CMU_2A_R_DBG_SEL_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_2A_R_DBG_SEL_1_0, x)
+
+#define SD25G_LANE_CMU_2A_R_DBG_LINK_LANE        BIT(4)
+#define SD25G_LANE_CMU_2A_R_DBG_LINK_LANE_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_2A_R_DBG_LINK_LANE, x)
+#define SD25G_LANE_CMU_2A_R_DBG_LINK_LANE_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_2A_R_DBG_LINK_LANE, x)
+
+#define SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS       BIT(5)
+#define SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS, x)
+#define SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS, x)
+
+/*      SD25G_TARGET:CMU_GRP_1:CMU_30 */
+#define SD25G_LANE_CMU_30(t)      __REG(TARGET_SD25G_LANE, t, 8, 132, 0, 1, 124, 60, 0, 1, 4)
+
+#define SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0 GENMASK(2, 0)
+#define SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0, x)
+#define SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0, x)
+
+#define SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0 GENMASK(6, 4)
+#define SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0, x)
+#define SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0, x)
+
+/*      SD25G_TARGET:CMU_GRP_1:CMU_31 */
+#define SD25G_LANE_CMU_31(t)      __REG(TARGET_SD25G_LANE, t, 8, 132, 0, 1, 124, 64, 0, 1, 4)
+
+#define SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0 GENMASK(7, 0)
+#define SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0, x)
+#define SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0, x)
+
+/*      SD25G_TARGET:CMU_GRP_2:CMU_40 */
+#define SD25G_LANE_CMU_40(t)      __REG(TARGET_SD25G_LANE, t, 8, 256, 0, 1, 512, 0, 0, 1, 4)
+
+#define SD25G_LANE_CMU_40_L0_CFG_CKSKEW_CTRL     BIT(0)
+#define SD25G_LANE_CMU_40_L0_CFG_CKSKEW_CTRL_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_40_L0_CFG_CKSKEW_CTRL, x)
+#define SD25G_LANE_CMU_40_L0_CFG_CKSKEW_CTRL_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_40_L0_CFG_CKSKEW_CTRL, x)
+
+#define SD25G_LANE_CMU_40_L0_CFG_ISCAN_HOLD      BIT(1)
+#define SD25G_LANE_CMU_40_L0_CFG_ISCAN_HOLD_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_40_L0_CFG_ISCAN_HOLD, x)
+#define SD25G_LANE_CMU_40_L0_CFG_ISCAN_HOLD_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_40_L0_CFG_ISCAN_HOLD, x)
+
+#define SD25G_LANE_CMU_40_L0_CFG_PD_CLK          BIT(2)
+#define SD25G_LANE_CMU_40_L0_CFG_PD_CLK_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_40_L0_CFG_PD_CLK, x)
+#define SD25G_LANE_CMU_40_L0_CFG_PD_CLK_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_40_L0_CFG_PD_CLK, x)
+
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN        BIT(3)
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN, x)
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN, x)
+
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_MAN_EN    BIT(4)
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_MAN_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_40_L0_CFG_TXCAL_MAN_EN, x)
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_MAN_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_40_L0_CFG_TXCAL_MAN_EN, x)
+
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_RST       BIT(5)
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_RST_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_40_L0_CFG_TXCAL_RST, x)
+#define SD25G_LANE_CMU_40_L0_CFG_TXCAL_RST_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_40_L0_CFG_TXCAL_RST, x)
+
+/*      SD25G_TARGET:CMU_GRP_2:CMU_45 */
+#define SD25G_LANE_CMU_45(t)      __REG(TARGET_SD25G_LANE, t, 8, 256, 0, 1, 512, 20, 0, 1, 4)
+
+#define SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0  GENMASK(7, 0)
+#define SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0, x)
+#define SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0, x)
+
+/*      SD25G_TARGET:CMU_GRP_2:CMU_46 */
+#define SD25G_LANE_CMU_46(t)      __REG(TARGET_SD25G_LANE, t, 8, 256, 0, 1, 512, 24, 0, 1, 4)
+
+#define SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8 GENMASK(7, 0)
+#define SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8, x)
+#define SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8, x)
+
+/*      SD25G_TARGET:CMU_GRP_3:CMU_C0 */
+#define SD25G_LANE_CMU_C0(t)      __REG(TARGET_SD25G_LANE, t, 8, 768, 0, 1, 252, 0, 0, 1, 4)
+
+#define SD25G_LANE_CMU_C0_READ_VCO_CTUNE_3_0     GENMASK(3, 0)
+#define SD25G_LANE_CMU_C0_READ_VCO_CTUNE_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_C0_READ_VCO_CTUNE_3_0, x)
+#define SD25G_LANE_CMU_C0_READ_VCO_CTUNE_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_C0_READ_VCO_CTUNE_3_0, x)
+
+#define SD25G_LANE_CMU_C0_PLL_LOL_UDL            BIT(4)
+#define SD25G_LANE_CMU_C0_PLL_LOL_UDL_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_C0_PLL_LOL_UDL, x)
+#define SD25G_LANE_CMU_C0_PLL_LOL_UDL_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_C0_PLL_LOL_UDL, x)
+
+/*      SD25G_TARGET:CMU_GRP_4:CMU_FF */
+#define SD25G_LANE_CMU_FF(t)      __REG(TARGET_SD25G_LANE, t, 8, 1020, 0, 1, 4, 0, 0, 1, 4)
+
+#define SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX   GENMASK(7, 0)
+#define SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(x)\
+	FIELD_PREP(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX, x)
+#define SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_GET(x)\
+	FIELD_GET(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_00 */
+#define SD25G_LANE_LANE_00(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 0, 0, 1, 4)
+
+#define SD25G_LANE_LANE_00_LN_CFG_ITX_VC_DRIVER_3_0 GENMASK(3, 0)
+#define SD25G_LANE_LANE_00_LN_CFG_ITX_VC_DRIVER_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_00_LN_CFG_ITX_VC_DRIVER_3_0, x)
+#define SD25G_LANE_LANE_00_LN_CFG_ITX_VC_DRIVER_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_00_LN_CFG_ITX_VC_DRIVER_3_0, x)
+
+#define SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0 GENMASK(5, 4)
+#define SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0, x)
+#define SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_01 */
+#define SD25G_LANE_LANE_01(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 4, 0, 1, 4)
+
+#define SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0 GENMASK(2, 0)
+#define SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0, x)
+#define SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0, x)
+
+#define SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0  GENMASK(5, 4)
+#define SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0, x)
+#define SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_03 */
+#define SD25G_LANE_LANE_03(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 12, 0, 1, 4)
+
+#define SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0    GENMASK(4, 0)
+#define SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0, x)
+#define SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_04 */
+#define SD25G_LANE_LANE_04(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 16, 0, 1, 4)
+
+#define SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN    BIT(0)
+#define SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN, x)
+#define SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN, x)
+
+#define SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN    BIT(1)
+#define SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN, x)
+#define SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN, x)
+
+#define SD25G_LANE_LANE_04_LN_CFG_PD_CML         BIT(2)
+#define SD25G_LANE_LANE_04_LN_CFG_PD_CML_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_04_LN_CFG_PD_CML, x)
+#define SD25G_LANE_LANE_04_LN_CFG_PD_CML_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_04_LN_CFG_PD_CML, x)
+
+#define SD25G_LANE_LANE_04_LN_CFG_PD_CLK         BIT(3)
+#define SD25G_LANE_LANE_04_LN_CFG_PD_CLK_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_04_LN_CFG_PD_CLK, x)
+#define SD25G_LANE_LANE_04_LN_CFG_PD_CLK_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_04_LN_CFG_PD_CLK, x)
+
+#define SD25G_LANE_LANE_04_LN_CFG_PD_DRIVER      BIT(4)
+#define SD25G_LANE_LANE_04_LN_CFG_PD_DRIVER_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_04_LN_CFG_PD_DRIVER, x)
+#define SD25G_LANE_LANE_04_LN_CFG_PD_DRIVER_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_04_LN_CFG_PD_DRIVER, x)
+
+#define SD25G_LANE_LANE_04_LN_CFG_TAP_MAIN       BIT(5)
+#define SD25G_LANE_LANE_04_LN_CFG_TAP_MAIN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_04_LN_CFG_TAP_MAIN, x)
+#define SD25G_LANE_LANE_04_LN_CFG_TAP_MAIN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_04_LN_CFG_TAP_MAIN, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_05 */
+#define SD25G_LANE_LANE_05(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 20, 0, 1, 4)
+
+#define SD25G_LANE_LANE_05_LN_CFG_TAP_DLY2_3_0   GENMASK(3, 0)
+#define SD25G_LANE_LANE_05_LN_CFG_TAP_DLY2_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_05_LN_CFG_TAP_DLY2_3_0, x)
+#define SD25G_LANE_LANE_05_LN_CFG_TAP_DLY2_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_05_LN_CFG_TAP_DLY2_3_0, x)
+
+#define SD25G_LANE_LANE_05_LN_CFG_BW_1_0         GENMASK(5, 4)
+#define SD25G_LANE_LANE_05_LN_CFG_BW_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_05_LN_CFG_BW_1_0, x)
+#define SD25G_LANE_LANE_05_LN_CFG_BW_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_05_LN_CFG_BW_1_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_06 */
+#define SD25G_LANE_LANE_06(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 24, 0, 1, 4)
+
+#define SD25G_LANE_LANE_06_LN_CFG_EN_MAIN        BIT(0)
+#define SD25G_LANE_LANE_06_LN_CFG_EN_MAIN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_06_LN_CFG_EN_MAIN, x)
+#define SD25G_LANE_LANE_06_LN_CFG_EN_MAIN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_06_LN_CFG_EN_MAIN, x)
+
+#define SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0    GENMASK(7, 4)
+#define SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0, x)
+#define SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_07 */
+#define SD25G_LANE_LANE_07(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 28, 0, 1, 4)
+
+#define SD25G_LANE_LANE_07_LN_CFG_EN_ADV         BIT(0)
+#define SD25G_LANE_LANE_07_LN_CFG_EN_ADV_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_07_LN_CFG_EN_ADV, x)
+#define SD25G_LANE_LANE_07_LN_CFG_EN_ADV_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_07_LN_CFG_EN_ADV, x)
+
+#define SD25G_LANE_LANE_07_LN_CFG_EN_DLY2        BIT(1)
+#define SD25G_LANE_LANE_07_LN_CFG_EN_DLY2_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_07_LN_CFG_EN_DLY2, x)
+#define SD25G_LANE_LANE_07_LN_CFG_EN_DLY2_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_07_LN_CFG_EN_DLY2, x)
+
+#define SD25G_LANE_LANE_07_LN_CFG_EN_DLY         BIT(2)
+#define SD25G_LANE_LANE_07_LN_CFG_EN_DLY_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_07_LN_CFG_EN_DLY, x)
+#define SD25G_LANE_LANE_07_LN_CFG_EN_DLY_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_07_LN_CFG_EN_DLY, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_09 */
+#define SD25G_LANE_LANE_09(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 36, 0, 1, 4)
+
+#define SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0 GENMASK(3, 0)
+#define SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0, x)
+#define SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_0A */
+#define SD25G_LANE_LANE_0A(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 40, 0, 1, 4)
+
+#define SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0 GENMASK(5, 0)
+#define SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0, x)
+#define SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_0B */
+#define SD25G_LANE_LANE_0B(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 44, 0, 1, 4)
+
+#define SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN   BIT(0)
+#define SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN, x)
+#define SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN, x)
+
+#define SD25G_LANE_LANE_0B_LN_CFG_TXCAL_RST      BIT(1)
+#define SD25G_LANE_LANE_0B_LN_CFG_TXCAL_RST_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0B_LN_CFG_TXCAL_RST, x)
+#define SD25G_LANE_LANE_0B_LN_CFG_TXCAL_RST_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0B_LN_CFG_TXCAL_RST, x)
+
+#define SD25G_LANE_LANE_0B_LN_CFG_QUAD_MAN_1_0   GENMASK(5, 4)
+#define SD25G_LANE_LANE_0B_LN_CFG_QUAD_MAN_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0B_LN_CFG_QUAD_MAN_1_0, x)
+#define SD25G_LANE_LANE_0B_LN_CFG_QUAD_MAN_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0B_LN_CFG_QUAD_MAN_1_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_0C */
+#define SD25G_LANE_LANE_0C(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 48, 0, 1, 4)
+
+#define SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0 GENMASK(2, 0)
+#define SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0, x)
+#define SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0, x)
+
+#define SD25G_LANE_LANE_0C_LN_CFG_TXCAL_EN       BIT(4)
+#define SD25G_LANE_LANE_0C_LN_CFG_TXCAL_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0C_LN_CFG_TXCAL_EN, x)
+#define SD25G_LANE_LANE_0C_LN_CFG_TXCAL_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0C_LN_CFG_TXCAL_EN, x)
+
+#define SD25G_LANE_LANE_0C_LN_CFG_RXTERM_PD      BIT(5)
+#define SD25G_LANE_LANE_0C_LN_CFG_RXTERM_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0C_LN_CFG_RXTERM_PD, x)
+#define SD25G_LANE_LANE_0C_LN_CFG_RXTERM_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0C_LN_CFG_RXTERM_PD, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_0D */
+#define SD25G_LANE_LANE_0D(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 52, 0, 1, 4)
+
+#define SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0     GENMASK(2, 0)
+#define SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0, x)
+#define SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0, x)
+
+#define SD25G_LANE_LANE_0D_LN_CFG_RSTN_DIV5_8    BIT(4)
+#define SD25G_LANE_LANE_0D_LN_CFG_RSTN_DIV5_8_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0D_LN_CFG_RSTN_DIV5_8, x)
+#define SD25G_LANE_LANE_0D_LN_CFG_RSTN_DIV5_8_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0D_LN_CFG_RSTN_DIV5_8, x)
+
+#define SD25G_LANE_LANE_0D_LN_CFG_SUMMER_EN      BIT(5)
+#define SD25G_LANE_LANE_0D_LN_CFG_SUMMER_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0D_LN_CFG_SUMMER_EN, x)
+#define SD25G_LANE_LANE_0D_LN_CFG_SUMMER_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0D_LN_CFG_SUMMER_EN, x)
+
+#define SD25G_LANE_LANE_0D_LN_CFG_DMUX_PD        BIT(6)
+#define SD25G_LANE_LANE_0D_LN_CFG_DMUX_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0D_LN_CFG_DMUX_PD, x)
+#define SD25G_LANE_LANE_0D_LN_CFG_DMUX_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0D_LN_CFG_DMUX_PD, x)
+
+#define SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN       BIT(7)
+#define SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN, x)
+#define SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_0E */
+#define SD25G_LANE_LANE_0E(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 56, 0, 1, 4)
+
+#define SD25G_LANE_LANE_0E_LN_CFG_ISCAN_EN       BIT(0)
+#define SD25G_LANE_LANE_0E_LN_CFG_ISCAN_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0E_LN_CFG_ISCAN_EN, x)
+#define SD25G_LANE_LANE_0E_LN_CFG_ISCAN_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0E_LN_CFG_ISCAN_EN, x)
+
+#define SD25G_LANE_LANE_0E_LN_CFG_DMUX_CLK_PD    BIT(1)
+#define SD25G_LANE_LANE_0E_LN_CFG_DMUX_CLK_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0E_LN_CFG_DMUX_CLK_PD, x)
+#define SD25G_LANE_LANE_0E_LN_CFG_DMUX_CLK_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0E_LN_CFG_DMUX_CLK_PD, x)
+
+#define SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG      BIT(2)
+#define SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG, x)
+#define SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG, x)
+
+#define SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0   GENMASK(6, 4)
+#define SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0, x)
+#define SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_0F */
+#define SD25G_LANE_LANE_0F(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 60, 0, 1, 4)
+
+#define SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1  GENMASK(4, 0)
+#define SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1, x)
+#define SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_18 */
+#define SD25G_LANE_LANE_18(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 96, 0, 1, 4)
+
+#define SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN       BIT(0)
+#define SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN, x)
+#define SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN, x)
+
+#define SD25G_LANE_LANE_18_LN_CFG_ADD_VOLT       BIT(1)
+#define SD25G_LANE_LANE_18_LN_CFG_ADD_VOLT_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_18_LN_CFG_ADD_VOLT, x)
+#define SD25G_LANE_LANE_18_LN_CFG_ADD_VOLT_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_18_LN_CFG_ADD_VOLT, x)
+
+#define SD25G_LANE_LANE_18_LN_CFG_MAN_VOLT_EN    BIT(2)
+#define SD25G_LANE_LANE_18_LN_CFG_MAN_VOLT_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_18_LN_CFG_MAN_VOLT_EN, x)
+#define SD25G_LANE_LANE_18_LN_CFG_MAN_VOLT_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_18_LN_CFG_MAN_VOLT_EN, x)
+
+#define SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD      BIT(3)
+#define SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD, x)
+#define SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD, x)
+
+#define SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0  GENMASK(6, 4)
+#define SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0, x)
+#define SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_19 */
+#define SD25G_LANE_LANE_19(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 100, 0, 1, 4)
+
+#define SD25G_LANE_LANE_19_LN_CFG_DCDR_PD        BIT(0)
+#define SD25G_LANE_LANE_19_LN_CFG_DCDR_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_DCDR_PD, x)
+#define SD25G_LANE_LANE_19_LN_CFG_DCDR_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_DCDR_PD, x)
+
+#define SD25G_LANE_LANE_19_LN_CFG_ECDR_PD        BIT(1)
+#define SD25G_LANE_LANE_19_LN_CFG_ECDR_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_ECDR_PD, x)
+#define SD25G_LANE_LANE_19_LN_CFG_ECDR_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_ECDR_PD, x)
+
+#define SD25G_LANE_LANE_19_LN_CFG_ISCAN_SEL      BIT(2)
+#define SD25G_LANE_LANE_19_LN_CFG_ISCAN_SEL_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_ISCAN_SEL, x)
+#define SD25G_LANE_LANE_19_LN_CFG_ISCAN_SEL_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_ISCAN_SEL, x)
+
+#define SD25G_LANE_LANE_19_LN_CFG_TXLB_EN        BIT(3)
+#define SD25G_LANE_LANE_19_LN_CFG_TXLB_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_TXLB_EN, x)
+#define SD25G_LANE_LANE_19_LN_CFG_TXLB_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_TXLB_EN, x)
+
+#define SD25G_LANE_LANE_19_LN_CFG_RX_REG_PU      BIT(4)
+#define SD25G_LANE_LANE_19_LN_CFG_RX_REG_PU_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_RX_REG_PU, x)
+#define SD25G_LANE_LANE_19_LN_CFG_RX_REG_PU_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_RX_REG_PU, x)
+
+#define SD25G_LANE_LANE_19_LN_CFG_RX_REG_BYP     BIT(5)
+#define SD25G_LANE_LANE_19_LN_CFG_RX_REG_BYP_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_RX_REG_BYP, x)
+#define SD25G_LANE_LANE_19_LN_CFG_RX_REG_BYP_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_RX_REG_BYP, x)
+
+#define SD25G_LANE_LANE_19_LN_CFG_PD_RMS_DET     BIT(6)
+#define SD25G_LANE_LANE_19_LN_CFG_PD_RMS_DET_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_PD_RMS_DET, x)
+#define SD25G_LANE_LANE_19_LN_CFG_PD_RMS_DET_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_PD_RMS_DET, x)
+
+#define SD25G_LANE_LANE_19_LN_CFG_PD_CTLE        BIT(7)
+#define SD25G_LANE_LANE_19_LN_CFG_PD_CTLE_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_19_LN_CFG_PD_CTLE, x)
+#define SD25G_LANE_LANE_19_LN_CFG_PD_CTLE_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_19_LN_CFG_PD_CTLE, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_1A */
+#define SD25G_LANE_LANE_1A(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 104, 0, 1, 4)
+
+#define SD25G_LANE_LANE_1A_LN_CFG_CTLE_TP_EN     BIT(0)
+#define SD25G_LANE_LANE_1A_LN_CFG_CTLE_TP_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1A_LN_CFG_CTLE_TP_EN, x)
+#define SD25G_LANE_LANE_1A_LN_CFG_CTLE_TP_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1A_LN_CFG_CTLE_TP_EN, x)
+
+#define SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0     GENMASK(6, 4)
+#define SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0, x)
+#define SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_1B */
+#define SD25G_LANE_LANE_1B(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 108, 0, 1, 4)
+
+#define SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0      GENMASK(7, 0)
+#define SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0, x)
+#define SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_1C */
+#define SD25G_LANE_LANE_1C(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 112, 0, 1, 4)
+
+#define SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN       BIT(0)
+#define SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN, x)
+#define SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN, x)
+
+#define SD25G_LANE_LANE_1C_LN_CFG_DFE_PD         BIT(1)
+#define SD25G_LANE_LANE_1C_LN_CFG_DFE_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1C_LN_CFG_DFE_PD, x)
+#define SD25G_LANE_LANE_1C_LN_CFG_DFE_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1C_LN_CFG_DFE_PD, x)
+
+#define SD25G_LANE_LANE_1C_LN_CFG_DFEDMX_PD      BIT(2)
+#define SD25G_LANE_LANE_1C_LN_CFG_DFEDMX_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1C_LN_CFG_DFEDMX_PD, x)
+#define SD25G_LANE_LANE_1C_LN_CFG_DFEDMX_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1C_LN_CFG_DFEDMX_PD, x)
+
+#define SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0  GENMASK(7, 4)
+#define SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0, x)
+#define SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_1D */
+#define SD25G_LANE_LANE_1D(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 116, 0, 1, 4)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_EXT_OVR  BIT(0)
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_EXT_OVR_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_ISCAN_EXT_OVR, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_EXT_OVR_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_ISCAN_EXT_OVR, x)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_HOLD     BIT(1)
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_HOLD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_ISCAN_HOLD, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_HOLD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_ISCAN_HOLD, x)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_RSTN     BIT(2)
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_ISCAN_RSTN, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_ISCAN_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_ISCAN_RSTN, x)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_AGC_ADPT_BYP   BIT(3)
+#define SD25G_LANE_LANE_1D_LN_CFG_AGC_ADPT_BYP_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_AGC_ADPT_BYP, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_AGC_ADPT_BYP_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_AGC_ADPT_BYP, x)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_PHID_1T        BIT(4)
+#define SD25G_LANE_LANE_1D_LN_CFG_PHID_1T_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_PHID_1T, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_PHID_1T_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_PHID_1T, x)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN      BIT(5)
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN, x)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_EXT_OVR     BIT(6)
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_EXT_OVR_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_PI_EXT_OVR, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_EXT_OVR_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_PI_EXT_OVR, x)
+
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_HOLD        BIT(7)
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_HOLD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1D_LN_CFG_PI_HOLD, x)
+#define SD25G_LANE_LANE_1D_LN_CFG_PI_HOLD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1D_LN_CFG_PI_HOLD, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_1E */
+#define SD25G_LANE_LANE_1E(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 120, 0, 1, 4)
+
+#define SD25G_LANE_LANE_1E_LN_CFG_PI_STEPS_1_0   GENMASK(1, 0)
+#define SD25G_LANE_LANE_1E_LN_CFG_PI_STEPS_1_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1E_LN_CFG_PI_STEPS_1_0, x)
+#define SD25G_LANE_LANE_1E_LN_CFG_PI_STEPS_1_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1E_LN_CFG_PI_STEPS_1_0, x)
+
+#define SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN        BIT(4)
+#define SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN, x)
+#define SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN, x)
+
+#define SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN   BIT(5)
+#define SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN, x)
+#define SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN, x)
+
+#define SD25G_LANE_LANE_1E_LN_CFG_R_OFFSET_DIR   BIT(6)
+#define SD25G_LANE_LANE_1E_LN_CFG_R_OFFSET_DIR_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1E_LN_CFG_R_OFFSET_DIR, x)
+#define SD25G_LANE_LANE_1E_LN_CFG_R_OFFSET_DIR_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1E_LN_CFG_R_OFFSET_DIR, x)
+
+#define SD25G_LANE_LANE_1E_LN_CFG_PMAD_CK_PD     BIT(7)
+#define SD25G_LANE_LANE_1E_LN_CFG_PMAD_CK_PD_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_1E_LN_CFG_PMAD_CK_PD, x)
+#define SD25G_LANE_LANE_1E_LN_CFG_PMAD_CK_PD_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_1E_LN_CFG_PMAD_CK_PD, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_21 */
+#define SD25G_LANE_LANE_21(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 132, 0, 1, 4)
+
+#define SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0 GENMASK(4, 0)
+#define SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0, x)
+#define SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_22 */
+#define SD25G_LANE_LANE_22(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 136, 0, 1, 4)
+
+#define SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0  GENMASK(3, 0)
+#define SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0, x)
+#define SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_25 */
+#define SD25G_LANE_LANE_25(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 148, 0, 1, 4)
+
+#define SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0 GENMASK(6, 0)
+#define SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0, x)
+#define SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_26 */
+#define SD25G_LANE_LANE_26(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 152, 0, 1, 4)
+
+#define SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0 GENMASK(6, 0)
+#define SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0, x)
+#define SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_28 */
+#define SD25G_LANE_LANE_28(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 160, 0, 1, 4)
+
+#define SD25G_LANE_LANE_28_LN_CFG_ISCAN_MODE_EN  BIT(0)
+#define SD25G_LANE_LANE_28_LN_CFG_ISCAN_MODE_EN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_28_LN_CFG_ISCAN_MODE_EN, x)
+#define SD25G_LANE_LANE_28_LN_CFG_ISCAN_MODE_EN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_28_LN_CFG_ISCAN_MODE_EN, x)
+
+#define SD25G_LANE_LANE_28_LN_CFG_RX_SSC_LH      BIT(1)
+#define SD25G_LANE_LANE_28_LN_CFG_RX_SSC_LH_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_28_LN_CFG_RX_SSC_LH, x)
+#define SD25G_LANE_LANE_28_LN_CFG_RX_SSC_LH_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_28_LN_CFG_RX_SSC_LH, x)
+
+#define SD25G_LANE_LANE_28_LN_CFG_FIGMERIT_SEL   BIT(2)
+#define SD25G_LANE_LANE_28_LN_CFG_FIGMERIT_SEL_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_28_LN_CFG_FIGMERIT_SEL, x)
+#define SD25G_LANE_LANE_28_LN_CFG_FIGMERIT_SEL_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_28_LN_CFG_FIGMERIT_SEL, x)
+
+#define SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0 GENMASK(6, 4)
+#define SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0, x)
+#define SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_2B */
+#define SD25G_LANE_LANE_2B(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 172, 0, 1, 4)
+
+#define SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0      GENMASK(3, 0)
+#define SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0, x)
+#define SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0, x)
+
+#define SD25G_LANE_LANE_2B_LN_CFG_RSTN_DMUX_SUBR BIT(4)
+#define SD25G_LANE_LANE_2B_LN_CFG_RSTN_DMUX_SUBR_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2B_LN_CFG_RSTN_DMUX_SUBR, x)
+#define SD25G_LANE_LANE_2B_LN_CFG_RSTN_DMUX_SUBR_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2B_LN_CFG_RSTN_DMUX_SUBR, x)
+
+#define SD25G_LANE_LANE_2B_LN_CFG_RSTN_TXDUPU    BIT(5)
+#define SD25G_LANE_LANE_2B_LN_CFG_RSTN_TXDUPU_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2B_LN_CFG_RSTN_TXDUPU, x)
+#define SD25G_LANE_LANE_2B_LN_CFG_RSTN_TXDUPU_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2B_LN_CFG_RSTN_TXDUPU, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_2C */
+#define SD25G_LANE_LANE_2C(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 176, 0, 1, 4)
+
+#define SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0 GENMASK(2, 0)
+#define SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0, x)
+#define SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0, x)
+
+#define SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER   BIT(4)
+#define SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER, x)
+#define SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_2D */
+#define SD25G_LANE_LANE_2D(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 180, 0, 1, 4)
+
+#define SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0   GENMASK(2, 0)
+#define SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0, x)
+#define SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0, x)
+
+#define SD25G_LANE_LANE_2D_LN_CFG_SAT_CNTSEL_2_0 GENMASK(6, 4)
+#define SD25G_LANE_LANE_2D_LN_CFG_SAT_CNTSEL_2_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2D_LN_CFG_SAT_CNTSEL_2_0, x)
+#define SD25G_LANE_LANE_2D_LN_CFG_SAT_CNTSEL_2_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2D_LN_CFG_SAT_CNTSEL_2_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_2E */
+#define SD25G_LANE_LANE_2E(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 184, 0, 1, 4)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_EN_FAST_ISCAN  BIT(0)
+#define SD25G_LANE_LANE_2E_LN_CFG_EN_FAST_ISCAN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_EN_FAST_ISCAN, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_EN_FAST_ISCAN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_EN_FAST_ISCAN, x)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ         BIT(1)
+#define SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ, x)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_PD_SQ          BIT(2)
+#define SD25G_LANE_LANE_2E_LN_CFG_PD_SQ_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_PD_SQ, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_PD_SQ_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_PD_SQ, x)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_DIS_ALOS       BIT(3)
+#define SD25G_LANE_LANE_2E_LN_CFG_DIS_ALOS_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_DIS_ALOS, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_DIS_ALOS_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_DIS_ALOS, x)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_RESETN_AGC     BIT(4)
+#define SD25G_LANE_LANE_2E_LN_CFG_RESETN_AGC_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_RESETN_AGC, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_RESETN_AGC_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_RESETN_AGC, x)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG    BIT(5)
+#define SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG, x)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_PI_RSTN        BIT(6)
+#define SD25G_LANE_LANE_2E_LN_CFG_PI_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_PI_RSTN, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_PI_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_PI_RSTN, x)
+
+#define SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN      BIT(7)
+#define SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN, x)
+#define SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_40 */
+#define SD25G_LANE_LANE_40(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 256, 0, 1, 4)
+
+#define SD25G_LANE_LANE_40_LN_R_TX_BIT_REVERSE   BIT(0)
+#define SD25G_LANE_LANE_40_LN_R_TX_BIT_REVERSE_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_40_LN_R_TX_BIT_REVERSE, x)
+#define SD25G_LANE_LANE_40_LN_R_TX_BIT_REVERSE_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_40_LN_R_TX_BIT_REVERSE, x)
+
+#define SD25G_LANE_LANE_40_LN_R_TX_POL_INV       BIT(1)
+#define SD25G_LANE_LANE_40_LN_R_TX_POL_INV_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_40_LN_R_TX_POL_INV, x)
+#define SD25G_LANE_LANE_40_LN_R_TX_POL_INV_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_40_LN_R_TX_POL_INV, x)
+
+#define SD25G_LANE_LANE_40_LN_R_RX_BIT_REVERSE   BIT(2)
+#define SD25G_LANE_LANE_40_LN_R_RX_BIT_REVERSE_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_40_LN_R_RX_BIT_REVERSE, x)
+#define SD25G_LANE_LANE_40_LN_R_RX_BIT_REVERSE_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_40_LN_R_RX_BIT_REVERSE, x)
+
+#define SD25G_LANE_LANE_40_LN_R_RX_POL_INV       BIT(3)
+#define SD25G_LANE_LANE_40_LN_R_RX_POL_INV_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_40_LN_R_RX_POL_INV, x)
+#define SD25G_LANE_LANE_40_LN_R_RX_POL_INV_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_40_LN_R_RX_POL_INV, x)
+
+#define SD25G_LANE_LANE_40_LN_R_CDR_RSTN         BIT(4)
+#define SD25G_LANE_LANE_40_LN_R_CDR_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_40_LN_R_CDR_RSTN, x)
+#define SD25G_LANE_LANE_40_LN_R_CDR_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_40_LN_R_CDR_RSTN, x)
+
+#define SD25G_LANE_LANE_40_LN_R_DFE_RSTN         BIT(5)
+#define SD25G_LANE_LANE_40_LN_R_DFE_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_40_LN_R_DFE_RSTN, x)
+#define SD25G_LANE_LANE_40_LN_R_DFE_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_40_LN_R_DFE_RSTN, x)
+
+#define SD25G_LANE_LANE_40_LN_R_CTLE_RSTN        BIT(6)
+#define SD25G_LANE_LANE_40_LN_R_CTLE_RSTN_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_40_LN_R_CTLE_RSTN, x)
+#define SD25G_LANE_LANE_40_LN_R_CTLE_RSTN_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_40_LN_R_CTLE_RSTN, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_42 */
+#define SD25G_LANE_LANE_42(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 264, 0, 1, 4)
+
+#define SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0 GENMASK(7, 0)
+#define SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0, x)
+#define SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_43 */
+#define SD25G_LANE_LANE_43(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 268, 0, 1, 4)
+
+#define SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8 GENMASK(7, 0)
+#define SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8, x)
+#define SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_44 */
+#define SD25G_LANE_LANE_44(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 272, 0, 1, 4)
+
+#define SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0 GENMASK(7, 0)
+#define SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0, x)
+#define SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0, x)
+
+/*      SD25G_TARGET:LANE_GRP_0:LANE_45 */
+#define SD25G_LANE_LANE_45(t)     __REG(TARGET_SD25G_LANE, t, 8, 1024, 0, 1, 768, 276, 0, 1, 4)
+
+#define SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8 GENMASK(7, 0)
+#define SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8, x)
+#define SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8, x)
+
+/*      SD25G_TARGET:LANE_GRP_1:LANE_DE */
+#define SD25G_LANE_LANE_DE(t)     __REG(TARGET_SD25G_LANE, t, 8, 1792, 0, 1, 128, 120, 0, 1, 4)
+
+#define SD25G_LANE_LANE_DE_LN_LOL_UDL            BIT(0)
+#define SD25G_LANE_LANE_DE_LN_LOL_UDL_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_DE_LN_LOL_UDL, x)
+#define SD25G_LANE_LANE_DE_LN_LOL_UDL_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_DE_LN_LOL_UDL, x)
+
+#define SD25G_LANE_LANE_DE_LN_LOL                BIT(1)
+#define SD25G_LANE_LANE_DE_LN_LOL_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_DE_LN_LOL, x)
+#define SD25G_LANE_LANE_DE_LN_LOL_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_DE_LN_LOL, x)
+
+#define SD25G_LANE_LANE_DE_LN_PMA2PCS_RXEI_FILTERED BIT(2)
+#define SD25G_LANE_LANE_DE_LN_PMA2PCS_RXEI_FILTERED_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_DE_LN_PMA2PCS_RXEI_FILTERED, x)
+#define SD25G_LANE_LANE_DE_LN_PMA2PCS_RXEI_FILTERED_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_DE_LN_PMA2PCS_RXEI_FILTERED, x)
+
+#define SD25G_LANE_LANE_DE_LN_PMA_RXEI           BIT(3)
+#define SD25G_LANE_LANE_DE_LN_PMA_RXEI_SET(x)\
+	FIELD_PREP(SD25G_LANE_LANE_DE_LN_PMA_RXEI, x)
+#define SD25G_LANE_LANE_DE_LN_PMA_RXEI_GET(x)\
+	FIELD_GET(SD25G_LANE_LANE_DE_LN_PMA_RXEI, x)
+
+/*      SD10G_LANE_TARGET:LANE_GRP_8:LANE_DF */
+#define SD6G_LANE_LANE_DF(t)      __REG(TARGET_SD6G_LANE, t, 13, 832, 0, 1, 84, 60, 0, 1, 4)
+
+#define SD6G_LANE_LANE_DF_LOL_UDL                BIT(0)
+#define SD6G_LANE_LANE_DF_LOL_UDL_SET(x)\
+	FIELD_PREP(SD6G_LANE_LANE_DF_LOL_UDL, x)
+#define SD6G_LANE_LANE_DF_LOL_UDL_GET(x)\
+	FIELD_GET(SD6G_LANE_LANE_DF_LOL_UDL, x)
+
+#define SD6G_LANE_LANE_DF_LOL                    BIT(1)
+#define SD6G_LANE_LANE_DF_LOL_SET(x)\
+	FIELD_PREP(SD6G_LANE_LANE_DF_LOL, x)
+#define SD6G_LANE_LANE_DF_LOL_GET(x)\
+	FIELD_GET(SD6G_LANE_LANE_DF_LOL, x)
+
+#define SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED  BIT(2)
+#define SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_SET(x)\
+	FIELD_PREP(SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED, x)
+#define SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED_GET(x)\
+	FIELD_GET(SD6G_LANE_LANE_DF_PMA2PCS_RXEI_FILTERED, x)
+
+#define SD6G_LANE_LANE_DF_SQUELCH                BIT(3)
+#define SD6G_LANE_LANE_DF_SQUELCH_SET(x)\
+	FIELD_PREP(SD6G_LANE_LANE_DF_SQUELCH, x)
+#define SD6G_LANE_LANE_DF_SQUELCH_GET(x)\
+	FIELD_GET(SD6G_LANE_LANE_DF_SQUELCH, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_0:CMU_00 */
+#define SD_CMU_CMU_00(t)          __REG(TARGET_SD_CMU, t, 14, 0, 0, 1, 20, 0, 0, 1, 4)
+
+#define SD_CMU_CMU_00_R_HWT_SIMULATION_MODE      BIT(0)
+#define SD_CMU_CMU_00_R_HWT_SIMULATION_MODE_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_00_R_HWT_SIMULATION_MODE, x)
+#define SD_CMU_CMU_00_R_HWT_SIMULATION_MODE_GET(x)\
+	FIELD_GET(SD_CMU_CMU_00_R_HWT_SIMULATION_MODE, x)
+
+#define SD_CMU_CMU_00_CFG_PLL_LOL_SET            BIT(1)
+#define SD_CMU_CMU_00_CFG_PLL_LOL_SET_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_00_CFG_PLL_LOL_SET, x)
+#define SD_CMU_CMU_00_CFG_PLL_LOL_SET_GET(x)\
+	FIELD_GET(SD_CMU_CMU_00_CFG_PLL_LOL_SET, x)
+
+#define SD_CMU_CMU_00_CFG_PLL_LOS_SET            BIT(2)
+#define SD_CMU_CMU_00_CFG_PLL_LOS_SET_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_00_CFG_PLL_LOS_SET, x)
+#define SD_CMU_CMU_00_CFG_PLL_LOS_SET_GET(x)\
+	FIELD_GET(SD_CMU_CMU_00_CFG_PLL_LOS_SET, x)
+
+#define SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0         GENMASK(5, 4)
+#define SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0, x)
+#define SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0_GET(x)\
+	FIELD_GET(SD_CMU_CMU_00_CFG_PLL_TP_SEL_1_0, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_1:CMU_05 */
+#define SD_CMU_CMU_05(t)          __REG(TARGET_SD_CMU, t, 14, 20, 0, 1, 72, 0, 0, 1, 4)
+
+#define SD_CMU_CMU_05_CFG_REFCK_TERM_EN          BIT(0)
+#define SD_CMU_CMU_05_CFG_REFCK_TERM_EN_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_05_CFG_REFCK_TERM_EN, x)
+#define SD_CMU_CMU_05_CFG_REFCK_TERM_EN_GET(x)\
+	FIELD_GET(SD_CMU_CMU_05_CFG_REFCK_TERM_EN, x)
+
+#define SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0        GENMASK(5, 4)
+#define SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0, x)
+#define SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0_GET(x)\
+	FIELD_GET(SD_CMU_CMU_05_CFG_BIAS_TP_SEL_1_0, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_1:CMU_09 */
+#define SD_CMU_CMU_09(t)          __REG(TARGET_SD_CMU, t, 14, 20, 0, 1, 72, 16, 0, 1, 4)
+
+#define SD_CMU_CMU_09_CFG_EN_TX_CK_UP            BIT(0)
+#define SD_CMU_CMU_09_CFG_EN_TX_CK_UP_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_09_CFG_EN_TX_CK_UP, x)
+#define SD_CMU_CMU_09_CFG_EN_TX_CK_UP_GET(x)\
+	FIELD_GET(SD_CMU_CMU_09_CFG_EN_TX_CK_UP, x)
+
+#define SD_CMU_CMU_09_CFG_EN_TX_CK_DN            BIT(1)
+#define SD_CMU_CMU_09_CFG_EN_TX_CK_DN_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_09_CFG_EN_TX_CK_DN, x)
+#define SD_CMU_CMU_09_CFG_EN_TX_CK_DN_GET(x)\
+	FIELD_GET(SD_CMU_CMU_09_CFG_EN_TX_CK_DN, x)
+
+#define SD_CMU_CMU_09_CFG_SW_8G                  BIT(4)
+#define SD_CMU_CMU_09_CFG_SW_8G_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_09_CFG_SW_8G, x)
+#define SD_CMU_CMU_09_CFG_SW_8G_GET(x)\
+	FIELD_GET(SD_CMU_CMU_09_CFG_SW_8G, x)
+
+#define SD_CMU_CMU_09_CFG_SW_10G                 BIT(5)
+#define SD_CMU_CMU_09_CFG_SW_10G_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_09_CFG_SW_10G, x)
+#define SD_CMU_CMU_09_CFG_SW_10G_GET(x)\
+	FIELD_GET(SD_CMU_CMU_09_CFG_SW_10G, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_1:CMU_0D */
+#define SD_CMU_CMU_0D(t)          __REG(TARGET_SD_CMU, t, 14, 20, 0, 1, 72, 32, 0, 1, 4)
+
+#define SD_CMU_CMU_0D_CFG_PD_DIV64               BIT(0)
+#define SD_CMU_CMU_0D_CFG_PD_DIV64_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_0D_CFG_PD_DIV64, x)
+#define SD_CMU_CMU_0D_CFG_PD_DIV64_GET(x)\
+	FIELD_GET(SD_CMU_CMU_0D_CFG_PD_DIV64, x)
+
+#define SD_CMU_CMU_0D_CFG_PD_DIV66               BIT(1)
+#define SD_CMU_CMU_0D_CFG_PD_DIV66_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_0D_CFG_PD_DIV66, x)
+#define SD_CMU_CMU_0D_CFG_PD_DIV66_GET(x)\
+	FIELD_GET(SD_CMU_CMU_0D_CFG_PD_DIV66, x)
+
+#define SD_CMU_CMU_0D_CFG_PMA_TX_CK_PD           BIT(2)
+#define SD_CMU_CMU_0D_CFG_PMA_TX_CK_PD_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_0D_CFG_PMA_TX_CK_PD, x)
+#define SD_CMU_CMU_0D_CFG_PMA_TX_CK_PD_GET(x)\
+	FIELD_GET(SD_CMU_CMU_0D_CFG_PMA_TX_CK_PD, x)
+
+#define SD_CMU_CMU_0D_CFG_JC_BYP                 BIT(3)
+#define SD_CMU_CMU_0D_CFG_JC_BYP_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_0D_CFG_JC_BYP, x)
+#define SD_CMU_CMU_0D_CFG_JC_BYP_GET(x)\
+	FIELD_GET(SD_CMU_CMU_0D_CFG_JC_BYP, x)
+
+#define SD_CMU_CMU_0D_CFG_REFCK_PD               BIT(4)
+#define SD_CMU_CMU_0D_CFG_REFCK_PD_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_0D_CFG_REFCK_PD, x)
+#define SD_CMU_CMU_0D_CFG_REFCK_PD_GET(x)\
+	FIELD_GET(SD_CMU_CMU_0D_CFG_REFCK_PD, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_3:CMU_1B */
+#define SD_CMU_CMU_1B(t)          __REG(TARGET_SD_CMU, t, 14, 104, 0, 1, 20, 4, 0, 1, 4)
+
+#define SD_CMU_CMU_1B_CFG_RESERVE_7_0            GENMASK(7, 0)
+#define SD_CMU_CMU_1B_CFG_RESERVE_7_0_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_1B_CFG_RESERVE_7_0, x)
+#define SD_CMU_CMU_1B_CFG_RESERVE_7_0_GET(x)\
+	FIELD_GET(SD_CMU_CMU_1B_CFG_RESERVE_7_0, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_4:CMU_1F */
+#define SD_CMU_CMU_1F(t)          __REG(TARGET_SD_CMU, t, 14, 124, 0, 1, 68, 0, 0, 1, 4)
+
+#define SD_CMU_CMU_1F_CFG_BIAS_DN_EN             BIT(0)
+#define SD_CMU_CMU_1F_CFG_BIAS_DN_EN_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_1F_CFG_BIAS_DN_EN, x)
+#define SD_CMU_CMU_1F_CFG_BIAS_DN_EN_GET(x)\
+	FIELD_GET(SD_CMU_CMU_1F_CFG_BIAS_DN_EN, x)
+
+#define SD_CMU_CMU_1F_CFG_BIAS_UP_EN             BIT(1)
+#define SD_CMU_CMU_1F_CFG_BIAS_UP_EN_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_1F_CFG_BIAS_UP_EN, x)
+#define SD_CMU_CMU_1F_CFG_BIAS_UP_EN_GET(x)\
+	FIELD_GET(SD_CMU_CMU_1F_CFG_BIAS_UP_EN, x)
+
+#define SD_CMU_CMU_1F_CFG_IC2IP_N                BIT(2)
+#define SD_CMU_CMU_1F_CFG_IC2IP_N_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_1F_CFG_IC2IP_N, x)
+#define SD_CMU_CMU_1F_CFG_IC2IP_N_GET(x)\
+	FIELD_GET(SD_CMU_CMU_1F_CFG_IC2IP_N, x)
+
+#define SD_CMU_CMU_1F_CFG_VTUNE_SEL              BIT(3)
+#define SD_CMU_CMU_1F_CFG_VTUNE_SEL_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_1F_CFG_VTUNE_SEL, x)
+#define SD_CMU_CMU_1F_CFG_VTUNE_SEL_GET(x)\
+	FIELD_GET(SD_CMU_CMU_1F_CFG_VTUNE_SEL, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_5:CMU_30 */
+#define SD_CMU_CMU_30(t)          __REG(TARGET_SD_CMU, t, 14, 192, 0, 1, 72, 0, 0, 1, 4)
+
+#define SD_CMU_CMU_30_R_PLL_DLOL_EN              BIT(0)
+#define SD_CMU_CMU_30_R_PLL_DLOL_EN_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_30_R_PLL_DLOL_EN, x)
+#define SD_CMU_CMU_30_R_PLL_DLOL_EN_GET(x)\
+	FIELD_GET(SD_CMU_CMU_30_R_PLL_DLOL_EN, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_6:CMU_44 */
+#define SD_CMU_CMU_44(t)          __REG(TARGET_SD_CMU, t, 14, 264, 0, 1, 632, 8, 0, 1, 4)
+
+#define SD_CMU_CMU_44_R_PLL_RSTN                 BIT(0)
+#define SD_CMU_CMU_44_R_PLL_RSTN_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_44_R_PLL_RSTN, x)
+#define SD_CMU_CMU_44_R_PLL_RSTN_GET(x)\
+	FIELD_GET(SD_CMU_CMU_44_R_PLL_RSTN, x)
+
+#define SD_CMU_CMU_44_R_CK_RESETB                BIT(1)
+#define SD_CMU_CMU_44_R_CK_RESETB_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_44_R_CK_RESETB, x)
+#define SD_CMU_CMU_44_R_CK_RESETB_GET(x)\
+	FIELD_GET(SD_CMU_CMU_44_R_CK_RESETB, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_6:CMU_45 */
+#define SD_CMU_CMU_45(t)          __REG(TARGET_SD_CMU, t, 14, 264, 0, 1, 632, 12, 0, 1, 4)
+
+#define SD_CMU_CMU_45_R_EN_RATECHG_CTRL          BIT(0)
+#define SD_CMU_CMU_45_R_EN_RATECHG_CTRL_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_R_EN_RATECHG_CTRL, x)
+#define SD_CMU_CMU_45_R_EN_RATECHG_CTRL_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_R_EN_RATECHG_CTRL, x)
+
+#define SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT      BIT(1)
+#define SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT, x)
+#define SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_R_DWIDTHCTRL_FROM_HWT, x)
+
+#define SD_CMU_CMU_45_RESERVED                   BIT(2)
+#define SD_CMU_CMU_45_RESERVED_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_RESERVED, x)
+#define SD_CMU_CMU_45_RESERVED_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_RESERVED, x)
+
+#define SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT    BIT(3)
+#define SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT, x)
+#define SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_R_REFCK_SSC_EN_FROM_HWT, x)
+
+#define SD_CMU_CMU_45_RESERVED_2                 BIT(4)
+#define SD_CMU_CMU_45_RESERVED_2_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_RESERVED_2, x)
+#define SD_CMU_CMU_45_RESERVED_2_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_RESERVED_2, x)
+
+#define SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT     BIT(5)
+#define SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT, x)
+#define SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_R_LINK_BUF_EN_FROM_HWT, x)
+
+#define SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT         BIT(6)
+#define SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT, x)
+#define SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_R_BIAS_EN_FROM_HWT, x)
+
+#define SD_CMU_CMU_45_R_AUTO_RST_TREE_PD_MAN     BIT(7)
+#define SD_CMU_CMU_45_R_AUTO_RST_TREE_PD_MAN_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_45_R_AUTO_RST_TREE_PD_MAN, x)
+#define SD_CMU_CMU_45_R_AUTO_RST_TREE_PD_MAN_GET(x)\
+	FIELD_GET(SD_CMU_CMU_45_R_AUTO_RST_TREE_PD_MAN, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_6:CMU_47 */
+#define SD_CMU_CMU_47(t)          __REG(TARGET_SD_CMU, t, 14, 264, 0, 1, 632, 20, 0, 1, 4)
+
+#define SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0      GENMASK(4, 0)
+#define SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0, x)
+#define SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0_GET(x)\
+	FIELD_GET(SD_CMU_CMU_47_R_PCS2PMA_PHYMODE_4_0, x)
+
+/*      SD10G_CMU_TARGET:CMU_GRP_7:CMU_E0 */
+#define SD_CMU_CMU_E0(t)          __REG(TARGET_SD_CMU, t, 14, 896, 0, 1, 8, 0, 0, 1, 4)
+
+#define SD_CMU_CMU_E0_READ_VCO_CTUNE_3_0         GENMASK(3, 0)
+#define SD_CMU_CMU_E0_READ_VCO_CTUNE_3_0_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_E0_READ_VCO_CTUNE_3_0, x)
+#define SD_CMU_CMU_E0_READ_VCO_CTUNE_3_0_GET(x)\
+	FIELD_GET(SD_CMU_CMU_E0_READ_VCO_CTUNE_3_0, x)
+
+#define SD_CMU_CMU_E0_PLL_LOL_UDL                BIT(4)
+#define SD_CMU_CMU_E0_PLL_LOL_UDL_SET(x)\
+	FIELD_PREP(SD_CMU_CMU_E0_PLL_LOL_UDL, x)
+#define SD_CMU_CMU_E0_PLL_LOL_UDL_GET(x)\
+	FIELD_GET(SD_CMU_CMU_E0_PLL_LOL_UDL, x)
+
+/*      SD_CMU_TARGET:SD_CMU_CFG:SD_CMU_CFG */
+#define SD_CMU_CFG_SD_CMU_CFG(t)  __REG(TARGET_SD_CMU_CFG, t, 14, 0, 0, 1, 8, 0, 0, 1, 4)
+
+#define SD_CMU_CFG_SD_CMU_CFG_CMU_RST            BIT(0)
+#define SD_CMU_CFG_SD_CMU_CFG_CMU_RST_SET(x)\
+	FIELD_PREP(SD_CMU_CFG_SD_CMU_CFG_CMU_RST, x)
+#define SD_CMU_CFG_SD_CMU_CFG_CMU_RST_GET(x)\
+	FIELD_GET(SD_CMU_CFG_SD_CMU_CFG_CMU_RST, x)
+
+#define SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST        BIT(1)
+#define SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_SET(x)\
+	FIELD_PREP(SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST, x)
+#define SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST_GET(x)\
+	FIELD_GET(SD_CMU_CFG_SD_CMU_CFG_EXT_CFG_RST, x)
+
+/*      SD_LANE_TARGET:SD_RESET:SD_SER_RST */
+#define SD_LANE_SD_SER_RST(t)     __REG(TARGET_SD_LANE, t, 25, 0, 0, 1, 8, 0, 0, 1, 4)
+
+#define SD_LANE_SD_SER_RST_SER_RST               BIT(0)
+#define SD_LANE_SD_SER_RST_SER_RST_SET(x)\
+	FIELD_PREP(SD_LANE_SD_SER_RST_SER_RST, x)
+#define SD_LANE_SD_SER_RST_SER_RST_GET(x)\
+	FIELD_GET(SD_LANE_SD_SER_RST_SER_RST, x)
+
+/*      SD_LANE_TARGET:SD_RESET:SD_DES_RST */
+#define SD_LANE_SD_DES_RST(t)     __REG(TARGET_SD_LANE, t, 25, 0, 0, 1, 8, 4, 0, 1, 4)
+
+#define SD_LANE_SD_DES_RST_DES_RST               BIT(0)
+#define SD_LANE_SD_DES_RST_DES_RST_SET(x)\
+	FIELD_PREP(SD_LANE_SD_DES_RST_DES_RST, x)
+#define SD_LANE_SD_DES_RST_DES_RST_GET(x)\
+	FIELD_GET(SD_LANE_SD_DES_RST_DES_RST, x)
+
+/*      SD_LANE_TARGET:SD_LANE_CFG_STAT:SD_LANE_CFG */
+#define SD_LANE_SD_LANE_CFG(t)    __REG(TARGET_SD_LANE, t, 25, 8, 0, 1, 8, 0, 0, 1, 4)
+
+#define SD_LANE_SD_LANE_CFG_MACRO_RST            BIT(0)
+#define SD_LANE_SD_LANE_CFG_MACRO_RST_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_CFG_MACRO_RST, x)
+#define SD_LANE_SD_LANE_CFG_MACRO_RST_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_CFG_MACRO_RST, x)
+
+#define SD_LANE_SD_LANE_CFG_EXT_CFG_RST          BIT(1)
+#define SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_CFG_EXT_CFG_RST, x)
+#define SD_LANE_SD_LANE_CFG_EXT_CFG_RST_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_CFG_EXT_CFG_RST, x)
+
+#define SD_LANE_SD_LANE_CFG_TX_REF_SEL           GENMASK(5, 4)
+#define SD_LANE_SD_LANE_CFG_TX_REF_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_CFG_TX_REF_SEL, x)
+#define SD_LANE_SD_LANE_CFG_TX_REF_SEL_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_CFG_TX_REF_SEL, x)
+
+#define SD_LANE_SD_LANE_CFG_RX_REF_SEL           GENMASK(7, 6)
+#define SD_LANE_SD_LANE_CFG_RX_REF_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_CFG_RX_REF_SEL, x)
+#define SD_LANE_SD_LANE_CFG_RX_REF_SEL_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_CFG_RX_REF_SEL, x)
+
+#define SD_LANE_SD_LANE_CFG_LANE_RST             BIT(8)
+#define SD_LANE_SD_LANE_CFG_LANE_RST_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_CFG_LANE_RST, x)
+#define SD_LANE_SD_LANE_CFG_LANE_RST_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_CFG_LANE_RST, x)
+
+#define SD_LANE_SD_LANE_CFG_LANE_TX_RST          BIT(9)
+#define SD_LANE_SD_LANE_CFG_LANE_TX_RST_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_CFG_LANE_TX_RST, x)
+#define SD_LANE_SD_LANE_CFG_LANE_TX_RST_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_CFG_LANE_TX_RST, x)
+
+#define SD_LANE_SD_LANE_CFG_LANE_RX_RST          BIT(10)
+#define SD_LANE_SD_LANE_CFG_LANE_RX_RST_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_CFG_LANE_RX_RST, x)
+#define SD_LANE_SD_LANE_CFG_LANE_RX_RST_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_CFG_LANE_RX_RST, x)
+
+/*      SD_LANE_TARGET:SD_LANE_CFG_STAT:SD_LANE_STAT */
+#define SD_LANE_SD_LANE_STAT(t)   __REG(TARGET_SD_LANE, t, 25, 8, 0, 1, 8, 4, 0, 1, 4)
+
+#define SD_LANE_SD_LANE_STAT_PMA_RST_DONE        BIT(0)
+#define SD_LANE_SD_LANE_STAT_PMA_RST_DONE_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_STAT_PMA_RST_DONE, x)
+#define SD_LANE_SD_LANE_STAT_PMA_RST_DONE_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_STAT_PMA_RST_DONE, x)
+
+#define SD_LANE_SD_LANE_STAT_DFE_RST_DONE        BIT(1)
+#define SD_LANE_SD_LANE_STAT_DFE_RST_DONE_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_STAT_DFE_RST_DONE, x)
+#define SD_LANE_SD_LANE_STAT_DFE_RST_DONE_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_STAT_DFE_RST_DONE, x)
+
+#define SD_LANE_SD_LANE_STAT_DBG_OBS             GENMASK(31, 16)
+#define SD_LANE_SD_LANE_STAT_DBG_OBS_SET(x)\
+	FIELD_PREP(SD_LANE_SD_LANE_STAT_DBG_OBS, x)
+#define SD_LANE_SD_LANE_STAT_DBG_OBS_GET(x)\
+	FIELD_GET(SD_LANE_SD_LANE_STAT_DBG_OBS, x)
+
+/*      SD_LANE_TARGET:CFG_STAT_FX100:MISC */
+#define SD_LANE_MISC(t)           __REG(TARGET_SD_LANE, t, 25, 56, 0, 1, 56, 0, 0, 1, 4)
+
+#define SD_LANE_MISC_SD_125_RST_DIS              BIT(0)
+#define SD_LANE_MISC_SD_125_RST_DIS_SET(x)\
+	FIELD_PREP(SD_LANE_MISC_SD_125_RST_DIS, x)
+#define SD_LANE_MISC_SD_125_RST_DIS_GET(x)\
+	FIELD_GET(SD_LANE_MISC_SD_125_RST_DIS, x)
+
+#define SD_LANE_MISC_RX_ENA                      BIT(1)
+#define SD_LANE_MISC_RX_ENA_SET(x)\
+	FIELD_PREP(SD_LANE_MISC_RX_ENA, x)
+#define SD_LANE_MISC_RX_ENA_GET(x)\
+	FIELD_GET(SD_LANE_MISC_RX_ENA, x)
+
+#define SD_LANE_MISC_MUX_ENA                     BIT(2)
+#define SD_LANE_MISC_MUX_ENA_SET(x)\
+	FIELD_PREP(SD_LANE_MISC_MUX_ENA, x)
+#define SD_LANE_MISC_MUX_ENA_GET(x)\
+	FIELD_GET(SD_LANE_MISC_MUX_ENA, x)
+
+#define SD_LANE_MISC_CORE_CLK_FREQ               GENMASK(5, 4)
+#define SD_LANE_MISC_CORE_CLK_FREQ_SET(x)\
+	FIELD_PREP(SD_LANE_MISC_CORE_CLK_FREQ, x)
+#define SD_LANE_MISC_CORE_CLK_FREQ_GET(x)\
+	FIELD_GET(SD_LANE_MISC_CORE_CLK_FREQ, x)
+
+/*      SD_LANE_TARGET:CFG_STAT_FX100:M_STAT_MISC */
+#define SD_LANE_M_STAT_MISC(t)    __REG(TARGET_SD_LANE, t, 25, 56, 0, 1, 56, 36, 0, 1, 4)
+
+#define SD_LANE_M_STAT_MISC_M_RIS_EDGE_PTR_ADJ_SUM GENMASK(21, 0)
+#define SD_LANE_M_STAT_MISC_M_RIS_EDGE_PTR_ADJ_SUM_SET(x)\
+	FIELD_PREP(SD_LANE_M_STAT_MISC_M_RIS_EDGE_PTR_ADJ_SUM, x)
+#define SD_LANE_M_STAT_MISC_M_RIS_EDGE_PTR_ADJ_SUM_GET(x)\
+	FIELD_GET(SD_LANE_M_STAT_MISC_M_RIS_EDGE_PTR_ADJ_SUM, x)
+
+#define SD_LANE_M_STAT_MISC_M_LOCK_CNT           GENMASK(31, 24)
+#define SD_LANE_M_STAT_MISC_M_LOCK_CNT_SET(x)\
+	FIELD_PREP(SD_LANE_M_STAT_MISC_M_LOCK_CNT, x)
+#define SD_LANE_M_STAT_MISC_M_LOCK_CNT_GET(x)\
+	FIELD_GET(SD_LANE_M_STAT_MISC_M_LOCK_CNT, x)
+
+/*      SD25G_CFG_TARGET:SD_RESET:SD_SER_RST */
+#define SD_LANE_25G_SD_SER_RST(t) __REG(TARGET_SD_LANE_25G, t, 8, 0, 0, 1, 8, 0, 0, 1, 4)
+
+#define SD_LANE_25G_SD_SER_RST_SER_RST           BIT(0)
+#define SD_LANE_25G_SD_SER_RST_SER_RST_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_SER_RST_SER_RST, x)
+#define SD_LANE_25G_SD_SER_RST_SER_RST_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_SER_RST_SER_RST, x)
+
+/*      SD25G_CFG_TARGET:SD_RESET:SD_DES_RST */
+#define SD_LANE_25G_SD_DES_RST(t) __REG(TARGET_SD_LANE_25G, t, 8, 0, 0, 1, 8, 4, 0, 1, 4)
+
+#define SD_LANE_25G_SD_DES_RST_DES_RST           BIT(0)
+#define SD_LANE_25G_SD_DES_RST_DES_RST_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_DES_RST_DES_RST, x)
+#define SD_LANE_25G_SD_DES_RST_DES_RST_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_DES_RST_DES_RST, x)
+
+/*      SD25G_CFG_TARGET:SD_LANE_CFG_STAT:SD_LANE_CFG */
+#define SD_LANE_25G_SD_LANE_CFG(t) __REG(TARGET_SD_LANE_25G, t, 8, 8, 0, 1, 12, 0, 0, 1, 4)
+
+#define SD_LANE_25G_SD_LANE_CFG_MACRO_RST        BIT(0)
+#define SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_MACRO_RST, x)
+#define SD_LANE_25G_SD_LANE_CFG_MACRO_RST_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_MACRO_RST, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST      BIT(1)
+#define SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST, x)
+#define SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_HWT_MULTI_LANE_MODE BIT(4)
+#define SD_LANE_25G_SD_LANE_CFG_HWT_MULTI_LANE_MODE_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_HWT_MULTI_LANE_MODE, x)
+#define SD_LANE_25G_SD_LANE_CFG_HWT_MULTI_LANE_MODE_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_HWT_MULTI_LANE_MODE, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_PHYMODE  GENMASK(7, 5)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_PHYMODE_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_PHYMODE, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_PHYMODE_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_PHYMODE, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_LANE_RST         BIT(8)
+#define SD_LANE_25G_SD_LANE_CFG_LANE_RST_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_LANE_RST, x)
+#define SD_LANE_25G_SD_LANE_CFG_LANE_RST_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_LANE_RST, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_ADV       BIT(9)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_ADV_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_EN_ADV, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_ADV_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_EN_ADV, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_MAIN      BIT(10)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_MAIN_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_EN_MAIN, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_MAIN_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_EN_MAIN, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_DLY       BIT(11)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_DLY_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_EN_DLY, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_DLY_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_EN_DLY, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_ADV      GENMASK(15, 12)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_ADV_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_TAP_ADV, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_ADV_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_TAP_ADV, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_MAIN     BIT(16)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_MAIN_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_TAP_MAIN, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_MAIN_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_TAP_MAIN, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_DLY      GENMASK(21, 17)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_DLY_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_TAP_DLY, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_TAP_DLY_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_TAP_DLY, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_ISCAN_EN     BIT(22)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_ISCAN_EN_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_ISCAN_EN, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_ISCAN_EN_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_ISCAN_EN, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_FAST_ISCAN BIT(23)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_FAST_ISCAN_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS_EN_FAST_ISCAN, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS_EN_FAST_ISCAN_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS_EN_FAST_ISCAN, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXSWING  BIT(24)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXSWING_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXSWING, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXSWING_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXSWING, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXEI     BIT(25)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXEI_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXEI, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXEI_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXEI, x)
+
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXMARGIN GENMASK(28, 26)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXMARGIN_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXMARGIN, x)
+#define SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXMARGIN_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG_PCS2PMA_TXMARGIN, x)
+
+/*      SD25G_CFG_TARGET:SD_LANE_CFG_STAT:SD_LANE_CFG2 */
+#define SD_LANE_25G_SD_LANE_CFG2(t) __REG(TARGET_SD_LANE_25G, t, 8, 8, 0, 1, 12, 4, 0, 1, 4)
+
+#define SD_LANE_25G_SD_LANE_CFG2_DATA_WIDTH_SEL  GENMASK(2, 0)
+#define SD_LANE_25G_SD_LANE_CFG2_DATA_WIDTH_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_DATA_WIDTH_SEL, x)
+#define SD_LANE_25G_SD_LANE_CFG2_DATA_WIDTH_SEL_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_DATA_WIDTH_SEL, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_PMA_TXCK_SEL    GENMASK(5, 3)
+#define SD_LANE_25G_SD_LANE_CFG2_PMA_TXCK_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_PMA_TXCK_SEL, x)
+#define SD_LANE_25G_SD_LANE_CFG2_PMA_TXCK_SEL_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_PMA_TXCK_SEL, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_PMA_RXDIV_SEL   GENMASK(8, 6)
+#define SD_LANE_25G_SD_LANE_CFG2_PMA_RXDIV_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_PMA_RXDIV_SEL, x)
+#define SD_LANE_25G_SD_LANE_CFG2_PMA_RXDIV_SEL_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_PMA_RXDIV_SEL, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_PCS2PMA_TX_SPEED GENMASK(10, 9)
+#define SD_LANE_25G_SD_LANE_CFG2_PCS2PMA_TX_SPEED_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_PCS2PMA_TX_SPEED, x)
+#define SD_LANE_25G_SD_LANE_CFG2_PCS2PMA_TX_SPEED_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_PCS2PMA_TX_SPEED, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_TXFIFO_CK_DIV   GENMASK(13, 11)
+#define SD_LANE_25G_SD_LANE_CFG2_TXFIFO_CK_DIV_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_TXFIFO_CK_DIV, x)
+#define SD_LANE_25G_SD_LANE_CFG2_TXFIFO_CK_DIV_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_TXFIFO_CK_DIV, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_RXFIFO_CK_DIV   GENMASK(16, 14)
+#define SD_LANE_25G_SD_LANE_CFG2_RXFIFO_CK_DIV_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_RXFIFO_CK_DIV, x)
+#define SD_LANE_25G_SD_LANE_CFG2_RXFIFO_CK_DIV_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_RXFIFO_CK_DIV, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_VCO_DIV_SEL GENMASK(19, 17)
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_VCO_DIV_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_HWT_VCO_DIV_SEL, x)
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_VCO_DIV_SEL_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_HWT_VCO_DIV_SEL, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_CFG_SEL_DIV GENMASK(23, 20)
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_CFG_SEL_DIV_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_HWT_CFG_SEL_DIV, x)
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_CFG_SEL_DIV_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_HWT_CFG_SEL_DIV, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_PRE_DIVSEL  GENMASK(25, 24)
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_PRE_DIVSEL_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_HWT_PRE_DIVSEL, x)
+#define SD_LANE_25G_SD_LANE_CFG2_HWT_PRE_DIVSEL_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_HWT_PRE_DIVSEL, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_TXRATE_SEL      GENMASK(28, 26)
+#define SD_LANE_25G_SD_LANE_CFG2_TXRATE_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_TXRATE_SEL, x)
+#define SD_LANE_25G_SD_LANE_CFG2_TXRATE_SEL_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_TXRATE_SEL, x)
+
+#define SD_LANE_25G_SD_LANE_CFG2_RXRATE_SEL      GENMASK(31, 29)
+#define SD_LANE_25G_SD_LANE_CFG2_RXRATE_SEL_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_CFG2_RXRATE_SEL, x)
+#define SD_LANE_25G_SD_LANE_CFG2_RXRATE_SEL_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_CFG2_RXRATE_SEL, x)
+
+/*      SD25G_CFG_TARGET:SD_LANE_CFG_STAT:SD_LANE_STAT */
+#define SD_LANE_25G_SD_LANE_STAT(t) __REG(TARGET_SD_LANE_25G, t, 8, 8, 0, 1, 12, 8, 0, 1, 4)
+
+#define SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE    BIT(0)
+#define SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE, x)
+#define SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE, x)
+
+#define SD_LANE_25G_SD_LANE_STAT_LANE_RST_DONE   BIT(1)
+#define SD_LANE_25G_SD_LANE_STAT_LANE_RST_DONE_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_STAT_LANE_RST_DONE, x)
+#define SD_LANE_25G_SD_LANE_STAT_LANE_RST_DONE_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_STAT_LANE_RST_DONE, x)
+
+#define SD_LANE_25G_SD_LANE_STAT_DBG_OBS         GENMASK(31, 16)
+#define SD_LANE_25G_SD_LANE_STAT_DBG_OBS_SET(x)\
+	FIELD_PREP(SD_LANE_25G_SD_LANE_STAT_DBG_OBS, x)
+#define SD_LANE_25G_SD_LANE_STAT_DBG_OBS_GET(x)\
+	FIELD_GET(SD_LANE_25G_SD_LANE_STAT_DBG_OBS, x)
+
+#endif /* _SPARX5_SERDES_REGS_H_ */
-- 
2.29.2

