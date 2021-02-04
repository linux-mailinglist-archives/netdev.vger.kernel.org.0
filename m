Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520CF30EDE8
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 09:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhBDIB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 03:01:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhBDIBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 03:01:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 954EF64E31;
        Thu,  4 Feb 2021 08:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612425672;
        bh=bAHhsWOLloDm3RM7gKEHrZNvgoUoy42s+XJ0OLK/K9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LnOV9cG2939JHlj2lee419b39yGddtFYGjZ3O+/YaFkmT+/CThsASkDagbuOJm/Tu
         viW575hc1OfnVHFyWmA2PIUoIeeALEyTvcElylH97x3SnQPJkFzNU6m9BRF8hr6Yx9
         ctn6laPkqGiT0ufxkqqhBxzrFsHLkPYIuu2WDrzGFzoi16/gnGM+617ijQsYNEGwlj
         80glC6XJJXRR7TVHDXMTQ/mshCWv9a2OSTf+y1BoRtIlfKQfK9mJVdLK48mpYhqVFt
         O2pPUsU/B03CyGCOvr2VIg/H1earJvPPkumDO2svRRRv3AJpAmlfTQiJPfK2auORXJ
         2CL1sU7CtQOXA==
Date:   Thu, 4 Feb 2021 13:31:07 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v13 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20210204080107.GJ3079@vkoul-mobl.Dlink>
References: <20210129130748.373831-1-steen.hegelund@microchip.com>
 <20210129130748.373831-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129130748.373831-4-steen.hegelund@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29-01-21, 14:07, Steen Hegelund wrote:
> Add the Microchip Sparx5 ethernet serdes PHY driver for the 6G, 10G and 25G
> interfaces available in the Sparx5 SoC.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> ---
>  drivers/phy/Kconfig                        |    1 +
>  drivers/phy/Makefile                       |    1 +
>  drivers/phy/microchip/Kconfig              |   12 +
>  drivers/phy/microchip/Makefile             |    6 +
>  drivers/phy/microchip/sparx5_serdes.c      | 2471 ++++++++++++++++++
>  drivers/phy/microchip/sparx5_serdes.h      |  125 +
>  drivers/phy/microchip/sparx5_serdes_regs.h | 2695 ++++++++++++++++++++
>  7 files changed, 5311 insertions(+)
>  create mode 100644 drivers/phy/microchip/Kconfig
>  create mode 100644 drivers/phy/microchip/Makefile
>  create mode 100644 drivers/phy/microchip/sparx5_serdes.c
>  create mode 100644 drivers/phy/microchip/sparx5_serdes.h
>  create mode 100644 drivers/phy/microchip/sparx5_serdes_regs.h
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 00dabe5fab8a..df35c752f3aa 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -70,6 +70,7 @@ source "drivers/phy/ingenic/Kconfig"
>  source "drivers/phy/lantiq/Kconfig"
>  source "drivers/phy/marvell/Kconfig"
>  source "drivers/phy/mediatek/Kconfig"
> +source "drivers/phy/microchip/Kconfig"
>  source "drivers/phy/motorola/Kconfig"
>  source "drivers/phy/mscc/Kconfig"
>  source "drivers/phy/qualcomm/Kconfig"
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 32261e164abd..adac1b1a39d1 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -20,6 +20,7 @@ obj-y					+= allwinner/	\
>  					   lantiq/	\
>  					   marvell/	\
>  					   mediatek/	\
> +					   microchip/	\
>  					   motorola/	\
>  					   mscc/	\
>  					   qualcomm/	\
> diff --git a/drivers/phy/microchip/Kconfig b/drivers/phy/microchip/Kconfig
> new file mode 100644
> index 000000000000..0b1a818e01b8
> --- /dev/null
> +++ b/drivers/phy/microchip/Kconfig
> @@ -0,0 +1,12 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Phy drivers for Microchip devices
> +#
> +
> +config PHY_SPARX5_SERDES
> +	tristate "Microchip Sparx5 SerDes PHY driver"
> +	select GENERIC_PHY
> +	depends on OF
> +	depends on HAS_IOMEM
> +	help
> +	  Enable this for support of the 10G/25G SerDes on Microchip Sparx5.
> diff --git a/drivers/phy/microchip/Makefile b/drivers/phy/microchip/Makefile
> new file mode 100644
> index 000000000000..7b98345712aa
> --- /dev/null
> +++ b/drivers/phy/microchip/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Makefile for the Microchip phy drivers.
> +#
> +
> +obj-$(CONFIG_PHY_SPARX5_SERDES) := sparx5_serdes.o
> diff --git a/drivers/phy/microchip/sparx5_serdes.c b/drivers/phy/microchip/sparx5_serdes.c
> new file mode 100644
> index 000000000000..74816a038130
> --- /dev/null
> +++ b/drivers/phy/microchip/sparx5_serdes.c
> @@ -0,0 +1,2471 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* Microchip Sparx5 Switch SerDes driver
> + *
> + * Copyright (c) 2020 Microchip Technology Inc. and its subsidiaries.
> + *
> + * The Sparx5 Chip Register Model can be browsed at this location:
> + * https://github.com/microchip-ung/sparx-5_reginfo
> + */
> +#include <linux/printk.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/netdevice.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/io.h>
> +#include <linux/clk.h>
> +#include <linux/phy.h>
> +#include <linux/phy/phy.h>
> +
> +#include "sparx5_serdes.h"
> +
> +#define SPX5_CMU_MAX          14
> +
> +#define SPX5_SERDES_10G_START 13
> +#define SPX5_SERDES_25G_START 25
> +
> +enum sparx5_10g28cmu_mode {
> +	SPX5_SD10G28_CMU_MAIN = 0,
> +	SPX5_SD10G28_CMU_AUX1 = 1,
> +	SPX5_SD10G28_CMU_AUX2 = 3,
> +	SPX5_SD10G28_CMU_NONE = 4,
> +};
> +
> +enum sparx5_sd25g28_mode_preset_type {
> +	SPX5_SD25G28_MODE_PRESET_25000,
> +	SPX5_SD25G28_MODE_PRESET_10000,
> +	SPX5_SD25G28_MODE_PRESET_5000,
> +	SPX5_SD25G28_MODE_PRESET_SD_2G5,
> +	SPX5_SD25G28_MODE_PRESET_1000BASEX,
> +};
> +
> +enum sparx5_sd10g28_mode_preset_type {
> +	SPX5_SD10G28_MODE_PRESET_10000,
> +	SPX5_SD10G28_MODE_PRESET_SFI_5000_6G,
> +	SPX5_SD10G28_MODE_PRESET_SFI_5000_10G,
> +	SPX5_SD10G28_MODE_PRESET_QSGMII,
> +	SPX5_SD10G28_MODE_PRESET_SD_2G5,
> +	SPX5_SD10G28_MODE_PRESET_1000BASEX,
> +};
> +
> +struct sparx5_serdes_io_resource {
> +	enum sparx5_serdes_target id;
> +	phys_addr_t offset;
> +};
> +
> +struct sparx5_sd25g28_mode_preset {
> +	u8 bitwidth;
> +	u8 tx_pre_div;
> +	u8 fifo_ck_div;
> +	u8 pre_divsel;
> +	u8 vco_div_mode;
> +	u8 sel_div;
> +	u8 ck_bitwidth;
> +	u8 subrate;
> +	u8 com_txcal_en;
> +	u8 com_tx_reserve_msb;
> +	u8 com_tx_reserve_lsb;
> +	u8 cfg_itx_ipcml_base;
> +	u8 tx_reserve_lsb;
> +	u8 tx_reserve_msb;
> +	u8 bw;
> +	u8 rxterm;
> +	u8 dfe_tap;
> +	u8 dfe_enable;
> +	bool txmargin;
> +	u8 cfg_ctle_rstn;
> +	u8 r_dfe_rstn;
> +	u8 cfg_pi_bw_3_0;
> +	u8 tx_tap_dly;
> +	u8 tx_tap_adv;
> +};
> +
> +struct sparx5_sd25g28_media_preset {
> +	u8 cfg_eq_c_force_3_0;
> +	u8 cfg_vga_ctrl_byp_4_0;
> +	u8 cfg_eq_r_force_3_0;
> +	u8 cfg_en_adv;
> +	u8 cfg_en_main;
> +	u8 cfg_en_dly;
> +	u8 cfg_tap_adv_3_0;
> +	u8 cfg_tap_main;
> +	u8 cfg_tap_dly_4_0;
> +	u8 cfg_alos_thr_2_0;
> +};
> +
> +struct sparx5_sd25g28_args {
> +	u8 if_width; /* UDL if-width: 10/16/20/32/64 */
> +	bool skip_cmu_cfg:1; /* Enable/disable CMU cfg */
> +	enum sparx5_10g28cmu_mode cmu_sel; /* Device/Mode serdes uses */
> +	bool no_pwrcycle:1; /* Omit initial power-cycle */
> +	bool txinvert:1; /* Enable inversion of output data */
> +	bool rxinvert:1; /* Enable inversion of input data */
> +	u16 txswing; /* Set output level */
> +	u8 rate; /* Rate of network interface */
> +	u8 pi_bw_gen1;
> +	u8 duty_cycle; /* Set output level to  half/full */
> +	bool mute:1; /* Mute Output Buffer */
> +	bool reg_rst:1;
> +	u8 com_pll_reserve;
> +};
> +
> +struct sparx5_sd25g28_params {
> +	u8 reg_rst;
> +	u8 cfg_jc_byp;
> +	u8 cfg_common_reserve_7_0;
> +	u8 r_reg_manual;
> +	u8 r_d_width_ctrl_from_hwt;
> +	u8 r_d_width_ctrl_2_0;
> +	u8 r_txfifo_ck_div_pmad_2_0;
> +	u8 r_rxfifo_ck_div_pmad_2_0;
> +	u8 cfg_pll_lol_set;
> +	u8 cfg_vco_div_mode_1_0;
> +	u8 cfg_pre_divsel_1_0;
> +	u8 cfg_sel_div_3_0;
> +	u8 cfg_vco_start_code_3_0;
> +	u8 cfg_pma_tx_ck_bitwidth_2_0;
> +	u8 cfg_tx_prediv_1_0;
> +	u8 cfg_rxdiv_sel_2_0;
> +	u8 cfg_tx_subrate_2_0;
> +	u8 cfg_rx_subrate_2_0;
> +	u8 r_multi_lane_mode;
> +	u8 cfg_cdrck_en;
> +	u8 cfg_dfeck_en;
> +	u8 cfg_dfe_pd;
> +	u8 cfg_dfedmx_pd;
> +	u8 cfg_dfetap_en_5_1;
> +	u8 cfg_dmux_pd;
> +	u8 cfg_dmux_clk_pd;
> +	u8 cfg_erramp_pd;
> +	u8 cfg_pi_dfe_en;
> +	u8 cfg_pi_en;
> +	u8 cfg_pd_ctle;
> +	u8 cfg_summer_en;
> +	u8 cfg_pmad_ck_pd;
> +	u8 cfg_pd_clk;
> +	u8 cfg_pd_cml;
> +	u8 cfg_pd_driver;
> +	u8 cfg_rx_reg_pu;
> +	u8 cfg_pd_rms_det;
> +	u8 cfg_dcdr_pd;
> +	u8 cfg_ecdr_pd;
> +	u8 cfg_pd_sq;
> +	u8 cfg_itx_ipdriver_base_2_0;
> +	u8 cfg_tap_dly_4_0;
> +	u8 cfg_tap_main;
> +	u8 cfg_en_main;
> +	u8 cfg_tap_adv_3_0;
> +	u8 cfg_en_adv;
> +	u8 cfg_en_dly;
> +	u8 cfg_iscan_en;
> +	u8 l1_pcs_en_fast_iscan;
> +	u8 l0_cfg_bw_1_0;
> +	u8 l0_cfg_txcal_en;
> +	u8 cfg_en_dummy;
> +	u8 cfg_pll_reserve_3_0;
> +	u8 l0_cfg_tx_reserve_15_8;
> +	u8 l0_cfg_tx_reserve_7_0;
> +	u8 cfg_tx_reserve_15_8;
> +	u8 cfg_tx_reserve_7_0;
> +	u8 cfg_bw_1_0;
> +	u8 cfg_txcal_man_en;
> +	u8 cfg_phase_man_4_0;
> +	u8 cfg_quad_man_1_0;
> +	u8 cfg_txcal_shift_code_5_0;
> +	u8 cfg_txcal_valid_sel_3_0;
> +	u8 cfg_txcal_en;
> +	u8 cfg_cdr_kf_2_0;
> +	u8 cfg_cdr_m_7_0;
> +	u8 cfg_pi_bw_3_0;
> +	u8 cfg_pi_steps_1_0;
> +	u8 cfg_dis_2ndorder;
> +	u8 cfg_ctle_rstn;
> +	u8 r_dfe_rstn;
> +	u8 cfg_alos_thr_2_0;
> +	u8 cfg_itx_ipcml_base_1_0;
> +	u8 cfg_rx_reserve_7_0;
> +	u8 cfg_rx_reserve_15_8;
> +	u8 cfg_rxterm_2_0;
> +	u8 cfg_fom_selm;
> +	u8 cfg_rx_sp_ctle_1_0;
> +	u8 cfg_isel_ctle_1_0;
> +	u8 cfg_vga_ctrl_byp_4_0;
> +	u8 cfg_vga_byp;
> +	u8 cfg_agc_adpt_byp;
> +	u8 cfg_eqr_byp;
> +	u8 cfg_eqr_force_3_0;
> +	u8 cfg_eqc_force_3_0;
> +	u8 cfg_sum_setcm_en;
> +	u8 cfg_init_pos_iscan_6_0;
> +	u8 cfg_init_pos_ipi_6_0;
> +	u8 cfg_dfedig_m_2_0;
> +	u8 cfg_en_dfedig;
> +	u8 cfg_pi_DFE_en;
> +	u8 cfg_tx2rx_lp_en;
> +	u8 cfg_txlb_en;
> +	u8 cfg_rx2tx_lp_en;
> +	u8 cfg_rxlb_en;
> +	u8 r_tx_pol_inv;
> +	u8 r_rx_pol_inv;
> +};
> +
> +struct sparx5_sd10g28_media_preset {
> +	u8 cfg_en_adv;
> +	u8 cfg_en_main;
> +	u8 cfg_en_dly;
> +	u8 cfg_tap_adv_3_0;
> +	u8 cfg_tap_main;
> +	u8 cfg_tap_dly_4_0;
> +	u8 cfg_vga_ctrl_3_0;
> +	u8 cfg_vga_cp_2_0;
> +	u8 cfg_eq_res_3_0;
> +	u8 cfg_eq_r_byp;
> +	u8 cfg_eq_c_force_3_0;
> +	u8 cfg_alos_thr_3_0;
> +};
> +
> +struct sparx5_sd10g28_mode_preset {
> +	u8 bwidth; /* interface width: 10/16/20/32/64 */
> +	enum sparx5_10g28cmu_mode cmu_sel; /* Device/Mode serdes uses */
> +	u8 rate; /* Rate of network interface */
> +	u8 dfe_tap;
> +	u8 dfe_enable;
> +	u8 pi_bw_gen1;
> +	u8 duty_cycle; /* Set output level to  half/full */
> +};
> +
> +struct sparx5_sd10g28_args {
> +	bool skip_cmu_cfg:1; /* Enable/disable CMU cfg */
> +	bool no_pwrcycle:1; /* Omit initial power-cycle */
> +	bool txinvert:1; /* Enable inversion of output data */
> +	bool rxinvert:1; /* Enable inversion of input data */
> +	bool txmargin:1; /* Set output level to  half/full */
> +	u16 txswing; /* Set output level */
> +	bool mute:1; /* Mute Output Buffer */
> +	bool is_6g:1;
> +	bool reg_rst:1;
> +};
> +
> +struct sparx5_sd10g28_params {
> +	u8 cmu_sel;
> +	u8 is_6g;
> +	u8 skip_cmu_cfg;
> +	u8 cfg_lane_reserve_7_0;
> +	u8 cfg_ssc_rtl_clk_sel;
> +	u8 cfg_lane_reserve_15_8;
> +	u8 cfg_txrate_1_0;
> +	u8 cfg_rxrate_1_0;
> +	u8 r_d_width_ctrl_2_0;
> +	u8 cfg_pma_tx_ck_bitwidth_2_0;
> +	u8 cfg_rxdiv_sel_2_0;
> +	u8 r_pcs2pma_phymode_4_0;
> +	u8 cfg_lane_id_2_0;
> +	u8 cfg_cdrck_en;
> +	u8 cfg_dfeck_en;
> +	u8 cfg_dfe_pd;
> +	u8 cfg_dfetap_en_5_1;
> +	u8 cfg_erramp_pd;
> +	u8 cfg_pi_DFE_en;
> +	u8 cfg_pi_en;
> +	u8 cfg_pd_ctle;
> +	u8 cfg_summer_en;
> +	u8 cfg_pd_rx_cktree;
> +	u8 cfg_pd_clk;
> +	u8 cfg_pd_cml;
> +	u8 cfg_pd_driver;
> +	u8 cfg_rx_reg_pu;
> +	u8 cfg_d_cdr_pd;
> +	u8 cfg_pd_sq;
> +	u8 cfg_rxdet_en;
> +	u8 cfg_rxdet_str;
> +	u8 r_multi_lane_mode;
> +	u8 cfg_en_adv;
> +	u8 cfg_en_main;
> +	u8 cfg_en_dly;
> +	u8 cfg_tap_adv_3_0;
> +	u8 cfg_tap_main;
> +	u8 cfg_tap_dly_4_0;
> +	u8 cfg_vga_ctrl_3_0;
> +	u8 cfg_vga_cp_2_0;
> +	u8 cfg_eq_res_3_0;
> +	u8 cfg_eq_r_byp;
> +	u8 cfg_eq_c_force_3_0;
> +	u8 cfg_en_dfedig;
> +	u8 cfg_sum_setcm_en;
> +	u8 cfg_en_preemph;
> +	u8 cfg_itx_ippreemp_base_1_0;
> +	u8 cfg_itx_ipdriver_base_2_0;
> +	u8 cfg_ibias_tune_reserve_5_0;
> +	u8 cfg_txswing_half;
> +	u8 cfg_dis_2nd_order;
> +	u8 cfg_rx_ssc_lh;
> +	u8 cfg_pi_floop_steps_1_0;
> +	u8 cfg_pi_ext_dac_23_16;
> +	u8 cfg_pi_ext_dac_15_8;
> +	u8 cfg_iscan_ext_dac_7_0;
> +	u8 cfg_cdr_kf_gen1_2_0;
> +	u8 cfg_cdr_kf_gen2_2_0;
> +	u8 cfg_cdr_kf_gen3_2_0;
> +	u8 cfg_cdr_kf_gen4_2_0;
> +	u8 r_cdr_m_gen1_7_0;
> +	u8 cfg_pi_bw_gen1_3_0;
> +	u8 cfg_pi_bw_gen2;
> +	u8 cfg_pi_bw_gen3;
> +	u8 cfg_pi_bw_gen4;
> +	u8 cfg_pi_ext_dac_7_0;
> +	u8 cfg_pi_steps;
> +	u8 cfg_mp_max_3_0;
> +	u8 cfg_rstn_dfedig;
> +	u8 cfg_alos_thr_3_0;
> +	u8 cfg_predrv_slewrate_1_0;
> +	u8 cfg_itx_ipcml_base_1_0;
> +	u8 cfg_ip_pre_base_1_0;
> +	u8 r_cdr_m_gen2_7_0;
> +	u8 r_cdr_m_gen3_7_0;
> +	u8 r_cdr_m_gen4_7_0;
> +	u8 r_en_auto_cdr_rstn;
> +	u8 cfg_oscal_afe;
> +	u8 cfg_pd_osdac_afe;
> +	u8 cfg_resetb_oscal_afe[2];
> +	u8 cfg_center_spreading;
> +	u8 cfg_m_cnt_maxval_4_0;
> +	u8 cfg_ncnt_maxval_7_0;
> +	u8 cfg_ncnt_maxval_10_8;
> +	u8 cfg_ssc_en;
> +	u8 cfg_tx2rx_lp_en;
> +	u8 cfg_txlb_en;
> +	u8 cfg_rx2tx_lp_en;
> +	u8 cfg_rxlb_en;
> +	u8 r_tx_pol_inv;
> +	u8 r_rx_pol_inv;
> +	u8 fx_100;
> +};
> +
> +static struct sparx5_sd25g28_media_preset media_presets_25g[] = {
> +	{ /* ETH_MEDIA_DEFAULT */
> +		.cfg_en_adv               = 0,
> +		.cfg_en_main              = 1,
> +		.cfg_en_dly               = 0,
> +		.cfg_tap_adv_3_0          = 0,
> +		.cfg_tap_main             = 1,
> +		.cfg_tap_dly_4_0          = 0,
> +		.cfg_eq_c_force_3_0       = 0xf,
> +		.cfg_vga_ctrl_byp_4_0     = 4,
> +		.cfg_eq_r_force_3_0       = 12,
> +		.cfg_alos_thr_2_0         = 7,
> +	},
> +	{ /* ETH_MEDIA_SR */
> +		.cfg_en_adv               = 1,
> +		.cfg_en_main              = 1,
> +		.cfg_en_dly               = 1,
> +		.cfg_tap_adv_3_0          = 0,
> +		.cfg_tap_main             = 1,
> +		.cfg_tap_dly_4_0          = 0x10,
> +		.cfg_eq_c_force_3_0       = 0xf,
> +		.cfg_vga_ctrl_byp_4_0     = 8,
> +		.cfg_eq_r_force_3_0       = 4,
> +		.cfg_alos_thr_2_0         = 0,
> +	},
> +	{ /* ETH_MEDIA_DAC */
> +		.cfg_en_adv               = 0,
> +		.cfg_en_main              = 1,
> +		.cfg_en_dly               = 0,
> +		.cfg_tap_adv_3_0          = 0,
> +		.cfg_tap_main             = 1,
> +		.cfg_tap_dly_4_0          = 0,
> +		.cfg_eq_c_force_3_0       = 0xf,
> +		.cfg_vga_ctrl_byp_4_0     = 8,
> +		.cfg_eq_r_force_3_0       = 0xc,
> +		.cfg_alos_thr_2_0         = 0,
> +	},
> +};
> +
> +static struct sparx5_sd25g28_mode_preset mode_presets_25g[] = {
> +	{ /* SPX5_SD25G28_MODE_PRESET_25000 */
> +		.bitwidth           = 40,
> +		.tx_pre_div         = 0,
> +		.fifo_ck_div        = 0,
> +		.pre_divsel         = 1,
> +		.vco_div_mode       = 0,
> +		.sel_div            = 15,
> +		.ck_bitwidth        = 3,
> +		.subrate            = 0,
> +		.com_txcal_en       = 0,
> +		.com_tx_reserve_msb = (0x26 << 1),
> +		.com_tx_reserve_lsb = 0xf0,
> +		.cfg_itx_ipcml_base = 0,
> +		.tx_reserve_msb     = 0xcc,
> +		.tx_reserve_lsb     = 0xfe,
> +		.bw                 = 3,
> +		.rxterm             = 0,
> +		.dfe_enable         = 1,
> +		.dfe_tap            = 0x1f,
> +		.txmargin           = 1,
> +		.cfg_ctle_rstn      = 1,
> +		.r_dfe_rstn         = 1,
> +		.cfg_pi_bw_3_0      = 0,
> +		.tx_tap_dly         = 8,
> +		.tx_tap_adv         = 0xc,
> +	},
> +	{ /* SPX5_SD25G28_MODE_PRESET_10000 */
> +		.bitwidth           = 64,
> +		.tx_pre_div         = 0,
> +		.fifo_ck_div        = 2,
> +		.pre_divsel         = 0,
> +		.vco_div_mode       = 1,
> +		.sel_div            = 9,
> +		.ck_bitwidth        = 0,
> +		.subrate            = 0,
> +		.com_txcal_en       = 1,
> +		.com_tx_reserve_msb = (0x20 << 1),
> +		.com_tx_reserve_lsb = 0x40,
> +		.cfg_itx_ipcml_base = 0,
> +		.tx_reserve_msb     = 0x4c,
> +		.tx_reserve_lsb     = 0x44,
> +		.bw                 = 3,
> +		.cfg_pi_bw_3_0      = 0,
> +		.rxterm             = 3,
> +		.dfe_enable         = 1,
> +		.dfe_tap            = 0x1f,
> +		.txmargin           = 0,
> +		.cfg_ctle_rstn      = 1,
> +		.r_dfe_rstn         = 1,
> +		.tx_tap_dly         = 0,
> +		.tx_tap_adv         = 0,
> +	},
> +	{ /* SPX5_SD25G28_MODE_PRESET_5000 */
> +		.bitwidth           = 64,
> +		.tx_pre_div         = 0,
> +		.fifo_ck_div        = 2,
> +		.pre_divsel         = 0,
> +		.vco_div_mode       = 2,
> +		.sel_div            = 9,
> +		.ck_bitwidth        = 0,
> +		.subrate            = 0,
> +		.com_txcal_en       = 1,
> +		.com_tx_reserve_msb = (0x20 << 1),
> +		.com_tx_reserve_lsb = 0,
> +		.cfg_itx_ipcml_base = 0,
> +		.tx_reserve_msb     = 0xe,
> +		.tx_reserve_lsb     = 0x80,
> +		.bw                 = 0,
> +		.rxterm             = 0,
> +		.cfg_pi_bw_3_0      = 6,
> +		.dfe_enable         = 0,
> +		.dfe_tap            = 0,
> +		.tx_tap_dly         = 0,
> +		.tx_tap_adv         = 0,
> +	},
> +	{ /* SPX5_SD25G28_MODE_PRESET_SD_2G5 */
> +		.bitwidth           = 10,
> +		.tx_pre_div         = 0,
> +		.fifo_ck_div        = 0,
> +		.pre_divsel         = 0,
> +		.vco_div_mode       = 1,
> +		.sel_div            = 6,
> +		.ck_bitwidth        = 3,
> +		.subrate            = 2,
> +		.com_txcal_en       = 1,
> +		.com_tx_reserve_msb = (0x26 << 1),
> +		.com_tx_reserve_lsb = (0xf << 4),
> +		.cfg_itx_ipcml_base = 2,
> +		.tx_reserve_msb     = 0x8,
> +		.tx_reserve_lsb     = 0x8a,
> +		.bw                 = 0,
> +		.cfg_pi_bw_3_0      = 0,
> +		.rxterm             = (1 << 2),
> +		.dfe_enable         = 0,
> +		.dfe_tap            = 0,
> +		.tx_tap_dly         = 0,
> +		.tx_tap_adv         = 0,
> +	},
> +	{ /* SPX5_SD25G28_MODE_PRESET_1000BASEX */
> +		.bitwidth           = 10,
> +		.tx_pre_div         = 0,
> +		.fifo_ck_div        = 1,
> +		.pre_divsel         = 0,
> +		.vco_div_mode       = 1,
> +		.sel_div            = 8,
> +		.ck_bitwidth        = 3,
> +		.subrate            = 3,
> +		.com_txcal_en       = 1,
> +		.com_tx_reserve_msb = (0x26 << 1),
> +		.com_tx_reserve_lsb = 0xf0,
> +		.cfg_itx_ipcml_base = 0,
> +		.tx_reserve_msb     = 0x8,
> +		.tx_reserve_lsb     = 0xce,
> +		.bw                 = 0,
> +		.rxterm             = 0,
> +		.cfg_pi_bw_3_0      = 0,
> +		.dfe_enable         = 0,
> +		.dfe_tap            = 0,
> +		.tx_tap_dly         = 0,
> +		.tx_tap_adv         = 0,
> +	},
> +};
> +
> +static struct sparx5_sd10g28_media_preset media_presets_10g[] = {
> +	{ /* ETH_MEDIA_DEFAULT */
> +		.cfg_en_adv               = 0,
> +		.cfg_en_main              = 1,
> +		.cfg_en_dly               = 0,
> +		.cfg_tap_adv_3_0          = 0,
> +		.cfg_tap_main             = 1,
> +		.cfg_tap_dly_4_0          = 0,
> +		.cfg_vga_ctrl_3_0         = 5,
> +		.cfg_vga_cp_2_0           = 0,
> +		.cfg_eq_res_3_0           = 0xa,
> +		.cfg_eq_r_byp             = 1,
> +		.cfg_eq_c_force_3_0       = 0x8,
> +		.cfg_alos_thr_3_0         = 0x3,
> +	},
> +	{ /* ETH_MEDIA_SR */
> +		.cfg_en_adv               = 1,
> +		.cfg_en_main              = 1,
> +		.cfg_en_dly               = 1,
> +		.cfg_tap_adv_3_0          = 0,
> +		.cfg_tap_main             = 1,
> +		.cfg_tap_dly_4_0          = 0xc,
> +		.cfg_vga_ctrl_3_0         = 0xa,
> +		.cfg_vga_cp_2_0           = 0x4,
> +		.cfg_eq_res_3_0           = 0xa,
> +		.cfg_eq_r_byp             = 1,
> +		.cfg_eq_c_force_3_0       = 0xF,
> +		.cfg_alos_thr_3_0         = 0x3,
> +	},
> +	{ /* ETH_MEDIA_DAC */
> +		.cfg_en_adv               = 1,
> +		.cfg_en_main              = 1,
> +		.cfg_en_dly               = 1,
> +		.cfg_tap_adv_3_0          = 12,
> +		.cfg_tap_main             = 1,
> +		.cfg_tap_dly_4_0          = 8,
> +		.cfg_vga_ctrl_3_0         = 0xa,
> +		.cfg_vga_cp_2_0           = 4,
> +		.cfg_eq_res_3_0           = 0xa,
> +		.cfg_eq_r_byp             = 1,
> +		.cfg_eq_c_force_3_0       = 0xf,
> +		.cfg_alos_thr_3_0         = 0x0,
> +	}
> +};
> +
> +static struct sparx5_sd10g28_mode_preset mode_presets_10g[] = {
> +	{ /* SPX5_SD10G28_MODE_PRESET_10000 */
> +		.bwidth           = 64,
> +		.cmu_sel          = SPX5_SD10G28_CMU_MAIN,
> +		.rate             = 0x0,
> +		.dfe_enable       = 1,
> +		.dfe_tap          = 0x1f,
> +		.pi_bw_gen1       = 0x0,
> +		.duty_cycle       = 0x2,
> +	},
> +	{ /* SPX5_SD10G28_MODE_PRESET_SFI_5000_6G */
> +		.bwidth           = 16,
> +		.cmu_sel          = SPX5_SD10G28_CMU_MAIN,
> +		.rate             = 0x1,
> +		.dfe_enable       = 0,
> +		.dfe_tap          = 0,
> +		.pi_bw_gen1       = 0x5,
> +		.duty_cycle       = 0x0,
> +	},
> +	{ /* SPX5_SD10G28_MODE_PRESET_SFI_5000_10G */
> +		.bwidth           = 64,
> +		.cmu_sel          = SPX5_SD10G28_CMU_MAIN,
> +		.rate             = 0x1,
> +		.dfe_enable       = 0,
> +		.dfe_tap          = 0,
> +		.pi_bw_gen1       = 0x5,
> +		.duty_cycle       = 0x0,
> +	},
> +	{ /* SPX5_SD10G28_MODE_PRESET_QSGMII */
> +		.bwidth           = 20,
> +		.cmu_sel          = SPX5_SD10G28_CMU_AUX1,
> +		.rate             = 0x1,
> +		.dfe_enable       = 0,
> +		.dfe_tap          = 0,
> +		.pi_bw_gen1       = 0x5,
> +		.duty_cycle       = 0x0,
> +	},
> +	{ /* SPX5_SD10G28_MODE_PRESET_SD_2G5 */
> +		.bwidth           = 10,
> +		.cmu_sel          = SPX5_SD10G28_CMU_AUX2,
> +		.rate             = 0x2,
> +		.dfe_enable       = 0,
> +		.dfe_tap          = 0,
> +		.pi_bw_gen1       = 0x7,
> +		.duty_cycle       = 0x0,
> +	},
> +	{ /* SPX5_SD10G28_MODE_PRESET_1000BASEX */
> +		.bwidth           = 10,
> +		.cmu_sel          = SPX5_SD10G28_CMU_AUX1,
> +		.rate             = 0x3,
> +		.dfe_enable       = 0,
> +		.dfe_tap          = 0,
> +		.pi_bw_gen1       = 0x7,
> +		.duty_cycle       = 0x0,
> +	},
> +};
> +
> +/* map from SD25G28 interface width to configuration value */
> +static u8 sd25g28_get_iw_setting(struct device *dev, const u8 interface_width)
> +{
> +	switch (interface_width) {
> +	case 10: return 0;
> +	case 16: return 1;
> +	case 32: return 3;
> +	case 40: return 4;
> +	case 64: return 5;
> +	default:
> +		dev_err(dev, "%s: Illegal value %d for interface width\n",
> +		       __func__, interface_width);
> +	}
> +	return 0;
> +}
> +
> +/* map from SD10G28 interface width to configuration value */
> +static u8 sd10g28_get_iw_setting(struct device *dev, const u8 interface_width)
> +{
> +	switch (interface_width) {
> +	case 10: return 0;
> +	case 16: return 1;
> +	case 20: return 2;
> +	case 32: return 3;
> +	case 40: return 4;
> +	case 64: return 7;
> +	default:
> +		dev_err(dev, "%s: Illegal value %d for interface width\n", __func__,
> +		       interface_width);
> +		return 0;
> +	}
> +}
> +
> +static int sparx5_sd10g25_get_mode_preset(struct sparx5_serdes_macro *macro,
> +					  struct sparx5_sd25g28_mode_preset *mode)
> +{
> +	switch (macro->serdesmode) {
> +	case SPX5_SD_MODE_SFI:
> +		if (macro->speed == SPEED_25000)
> +			*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_25000];
> +		else if (macro->speed == SPEED_10000)
> +			*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_10000];
> +		else if (macro->speed == SPEED_5000)
> +			*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_5000];
> +		break;
> +	case SPX5_SD_MODE_2G5:
> +		*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_SD_2G5];
> +		break;
> +	case SPX5_SD_MODE_1000BASEX:
> +		*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_1000BASEX];
> +		break;
> +	case SPX5_SD_MODE_100FX:
> +		 /* Not supported */
> +		return -EINVAL;
> +	default:
> +		*mode = mode_presets_25g[SPX5_SD25G28_MODE_PRESET_25000];
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int sparx5_sd10g28_get_mode_preset(struct sparx5_serdes_macro *macro,
> +					  struct sparx5_sd10g28_mode_preset *mode,
> +					  struct sparx5_sd10g28_args *args)
> +{
> +	switch (macro->serdesmode) {
> +	case SPX5_SD_MODE_SFI:
> +		if (macro->speed == SPEED_10000) {
> +			*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_10000];
> +		} else if (macro->speed == SPEED_5000) {
> +			if (args->is_6g)
> +				*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_SFI_5000_6G];
> +			else
> +				*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_SFI_5000_10G];
> +		} else {
> +			dev_err(macro->priv->dev, "%s: Illegal speed: %02u, sidx: %02u, mode (%u)",
> +			       __func__, macro->speed, macro->sidx,
> +			       macro->serdesmode);
> +			return -EINVAL;
> +		}
> +		break;
> +	case SPX5_SD_MODE_QSGMII:
> +		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_QSGMII];
> +		break;
> +	case SPX5_SD_MODE_2G5:
> +		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_SD_2G5];
> +		break;
> +	case SPX5_SD_MODE_100FX:
> +	case SPX5_SD_MODE_1000BASEX:
> +		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_1000BASEX];
> +		break;
> +	default:
> +		*mode = mode_presets_10g[SPX5_SD10G28_MODE_PRESET_10000];
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static void sparx5_sd25g28_get_params(struct sparx5_serdes_macro *macro,
> +				      struct sparx5_sd25g28_media_preset *media,
> +				      struct sparx5_sd25g28_mode_preset *mode,
> +				      struct sparx5_sd25g28_args *args,
> +				      struct sparx5_sd25g28_params *params)
> +{
> +	u8 iw = sd25g28_get_iw_setting(macro->priv->dev, mode->bitwidth);
> +	struct sparx5_sd25g28_params init = {
> +		.r_d_width_ctrl_2_0         = iw,
> +		.r_txfifo_ck_div_pmad_2_0   = mode->fifo_ck_div,
> +		.r_rxfifo_ck_div_pmad_2_0   = mode->fifo_ck_div,
> +		.cfg_vco_div_mode_1_0       = mode->vco_div_mode,
> +		.cfg_pre_divsel_1_0         = mode->pre_divsel,
> +		.cfg_sel_div_3_0            = mode->sel_div,
> +		.cfg_vco_start_code_3_0     = 0,
> +		.cfg_pma_tx_ck_bitwidth_2_0 = mode->ck_bitwidth,
> +		.cfg_tx_prediv_1_0          = mode->tx_pre_div,
> +		.cfg_rxdiv_sel_2_0          = mode->ck_bitwidth,
> +		.cfg_tx_subrate_2_0         = mode->subrate,
> +		.cfg_rx_subrate_2_0         = mode->subrate,
> +		.r_multi_lane_mode          = 0,
> +		.cfg_cdrck_en               = 1,
> +		.cfg_dfeck_en               = mode->dfe_enable,
> +		.cfg_dfe_pd                 = mode->dfe_enable == 1 ? 0 : 1,
> +		.cfg_dfedmx_pd              = 1,
> +		.cfg_dfetap_en_5_1          = mode->dfe_tap,
> +		.cfg_dmux_pd                = 0,
> +		.cfg_dmux_clk_pd            = 1,
> +		.cfg_erramp_pd              = mode->dfe_enable == 1 ? 0 : 1,
> +		.cfg_pi_DFE_en              = mode->dfe_enable,
> +		.cfg_pi_en                  = 1,
> +		.cfg_pd_ctle                = 0,
> +		.cfg_summer_en              = 1,
> +		.cfg_pmad_ck_pd             = 0,
> +		.cfg_pd_clk                 = 0,
> +		.cfg_pd_cml                 = 0,
> +		.cfg_pd_driver              = 0,
> +		.cfg_rx_reg_pu              = 1,
> +		.cfg_pd_rms_det             = 1,
> +		.cfg_dcdr_pd                = 0,
> +		.cfg_ecdr_pd                = 1,
> +		.cfg_pd_sq                  = 1,
> +		.cfg_itx_ipdriver_base_2_0  = mode->txmargin,
> +		.cfg_tap_dly_4_0            = media->cfg_tap_dly_4_0,
> +		.cfg_tap_main               = media->cfg_tap_main,
> +		.cfg_en_main                = media->cfg_en_main,
> +		.cfg_tap_adv_3_0            = media->cfg_tap_adv_3_0,
> +		.cfg_en_adv                 = media->cfg_en_adv,
> +		.cfg_en_dly                 = media->cfg_en_dly,
> +		.cfg_iscan_en               = 0,
> +		.l1_pcs_en_fast_iscan       = 0,
> +		.l0_cfg_bw_1_0              = 0,
> +		.cfg_en_dummy               = 0,
> +		.cfg_pll_reserve_3_0        = args->com_pll_reserve,
> +		.l0_cfg_txcal_en            = mode->com_txcal_en,
> +		.l0_cfg_tx_reserve_15_8     = mode->com_tx_reserve_msb,
> +		.l0_cfg_tx_reserve_7_0      = mode->com_tx_reserve_lsb,
> +		.cfg_tx_reserve_15_8        = mode->tx_reserve_msb,
> +		.cfg_tx_reserve_7_0         = mode->tx_reserve_lsb,
> +		.cfg_bw_1_0                 = mode->bw,
> +		.cfg_txcal_man_en           = 1,
> +		.cfg_phase_man_4_0          = 0,
> +		.cfg_quad_man_1_0           = 0,
> +		.cfg_txcal_shift_code_5_0   = 2,
> +		.cfg_txcal_valid_sel_3_0    = 4,
> +		.cfg_txcal_en               = 0,
> +		.cfg_cdr_kf_2_0             = 1,
> +		.cfg_cdr_m_7_0              = 6,
> +		.cfg_pi_bw_3_0              = mode->cfg_pi_bw_3_0,
> +		.cfg_pi_steps_1_0           = 0,
> +		.cfg_dis_2ndorder           = 1,
> +		.cfg_ctle_rstn              = mode->cfg_ctle_rstn,
> +		.r_dfe_rstn                 = mode->r_dfe_rstn,
> +		.cfg_alos_thr_2_0           = media->cfg_alos_thr_2_0,
> +		.cfg_itx_ipcml_base_1_0     = mode->cfg_itx_ipcml_base,
> +		.cfg_rx_reserve_7_0         = 0xbf,
> +		.cfg_rx_reserve_15_8        = 0x61,
> +		.cfg_rxterm_2_0             = mode->rxterm,
> +		.cfg_fom_selm               = 0,
> +		.cfg_rx_sp_ctle_1_0         = 0,
> +		.cfg_isel_ctle_1_0          = 0,
> +		.cfg_vga_ctrl_byp_4_0       = media->cfg_vga_ctrl_byp_4_0,
> +		.cfg_vga_byp                = 1,
> +		.cfg_agc_adpt_byp           = 1,
> +		.cfg_eqr_byp                = 1,
> +		.cfg_eqr_force_3_0          = media->cfg_eq_r_force_3_0,
> +		.cfg_eqc_force_3_0          = media->cfg_eq_c_force_3_0,
> +		.cfg_sum_setcm_en           = 1,
> +		.cfg_pi_dfe_en              = 1,
> +		.cfg_init_pos_iscan_6_0     = 6,
> +		.cfg_init_pos_ipi_6_0       = 9,
> +		.cfg_dfedig_m_2_0           = 6,
> +		.cfg_en_dfedig              = mode->dfe_enable,
> +		.r_d_width_ctrl_from_hwt    = 0,
> +		.r_reg_manual               = 1,
> +		.reg_rst                    = args->reg_rst,
> +		.cfg_jc_byp                 = 1,
> +		.cfg_common_reserve_7_0     = 1,
> +		.cfg_pll_lol_set            = 1,
> +		.cfg_tx2rx_lp_en            = 0,
> +		.cfg_txlb_en                = 0,
> +		.cfg_rx2tx_lp_en            = 0,
> +		.cfg_rxlb_en                = 0,
> +		.r_tx_pol_inv               = args->txinvert,
> +		.r_rx_pol_inv               = args->rxinvert,
> +	};
> +
> +	*params = init;
> +}
> +
> +static void sparx5_sd10g28_get_params(struct sparx5_serdes_macro *macro,
> +				      struct sparx5_sd10g28_media_preset *media,
> +				      struct sparx5_sd10g28_mode_preset *mode,
> +				      struct sparx5_sd10g28_args *args,
> +				      struct sparx5_sd10g28_params *params)
> +{
> +	u8 iw = sd10g28_get_iw_setting(macro->priv->dev, mode->bwidth);
> +	struct sparx5_sd10g28_params init = {
> +		.skip_cmu_cfg                = args->skip_cmu_cfg,
> +		.is_6g                       = args->is_6g,
> +		.cmu_sel                     = mode->cmu_sel,
> +		.cfg_lane_reserve_7_0        = (mode->cmu_sel % 2) << 6,
> +		.cfg_ssc_rtl_clk_sel         = (mode->cmu_sel / 2),
> +		.cfg_lane_reserve_15_8       = mode->duty_cycle,
> +		.cfg_txrate_1_0              = mode->rate,
> +		.cfg_rxrate_1_0              = mode->rate,
> +		.fx_100                      = macro->serdesmode == SPX5_SD_MODE_100FX,
> +		.r_d_width_ctrl_2_0          = iw,
> +		.cfg_pma_tx_ck_bitwidth_2_0  = iw,
> +		.cfg_rxdiv_sel_2_0           = iw,
> +		.r_pcs2pma_phymode_4_0       = 0,
> +		.cfg_lane_id_2_0             = 0,
> +		.cfg_cdrck_en                = 1,
> +		.cfg_dfeck_en                = mode->dfe_enable,
> +		.cfg_dfe_pd                  = (mode->dfe_enable == 1) ? 0 : 1,
> +		.cfg_dfetap_en_5_1           = mode->dfe_tap,
> +		.cfg_erramp_pd               = (mode->dfe_enable == 1) ? 0 : 1,
> +		.cfg_pi_DFE_en               = mode->dfe_enable,
> +		.cfg_pi_en                   = 1,
> +		.cfg_pd_ctle                 = 0,
> +		.cfg_summer_en               = 1,
> +		.cfg_pd_rx_cktree            = 0,
> +		.cfg_pd_clk                  = 0,
> +		.cfg_pd_cml                  = 0,
> +		.cfg_pd_driver               = 0,
> +		.cfg_rx_reg_pu               = 1,
> +		.cfg_d_cdr_pd                = 0,
> +		.cfg_pd_sq                   = mode->dfe_enable,
> +		.cfg_rxdet_en                = 0,
> +		.cfg_rxdet_str               = 0,
> +		.r_multi_lane_mode           = 0,
> +		.cfg_en_adv                  = media->cfg_en_adv,
> +		.cfg_en_main                 = 1,
> +		.cfg_en_dly                  = media->cfg_en_dly,
> +		.cfg_tap_adv_3_0             = media->cfg_tap_adv_3_0,
> +		.cfg_tap_main                = media->cfg_tap_main,
> +		.cfg_tap_dly_4_0             = media->cfg_tap_dly_4_0,
> +		.cfg_vga_ctrl_3_0            = media->cfg_vga_ctrl_3_0,
> +		.cfg_vga_cp_2_0              = media->cfg_vga_cp_2_0,
> +		.cfg_eq_res_3_0              = media->cfg_eq_res_3_0,
> +		.cfg_eq_r_byp                = media->cfg_eq_r_byp,
> +		.cfg_eq_c_force_3_0          = media->cfg_eq_c_force_3_0,
> +		.cfg_en_dfedig               = mode->dfe_enable,
> +		.cfg_sum_setcm_en            = 1,
> +		.cfg_en_preemph              = 0,
> +		.cfg_itx_ippreemp_base_1_0   = 0,
> +		.cfg_itx_ipdriver_base_2_0   = (args->txswing >> 6),
> +		.cfg_ibias_tune_reserve_5_0  = (args->txswing & 63),
> +		.cfg_txswing_half            = (args->txmargin),
> +		.cfg_dis_2nd_order           = 0x1,
> +		.cfg_rx_ssc_lh               = 0x0,
> +		.cfg_pi_floop_steps_1_0      = 0x0,
> +		.cfg_pi_ext_dac_23_16        = (1 << 5),
> +		.cfg_pi_ext_dac_15_8         = (0 << 6),
> +		.cfg_iscan_ext_dac_7_0       = (1 << 7) + 9,
> +		.cfg_cdr_kf_gen1_2_0         = 1,
> +		.cfg_cdr_kf_gen2_2_0         = 1,
> +		.cfg_cdr_kf_gen3_2_0         = 1,
> +		.cfg_cdr_kf_gen4_2_0         = 1,
> +		.r_cdr_m_gen1_7_0            = 4,
> +		.cfg_pi_bw_gen1_3_0          = mode->pi_bw_gen1,
> +		.cfg_pi_bw_gen2              = mode->pi_bw_gen1,
> +		.cfg_pi_bw_gen3              = mode->pi_bw_gen1,
> +		.cfg_pi_bw_gen4              = mode->pi_bw_gen1,
> +		.cfg_pi_ext_dac_7_0          = 3,
> +		.cfg_pi_steps                = 0,
> +		.cfg_mp_max_3_0              = 1,
> +		.cfg_rstn_dfedig             = mode->dfe_enable,
> +		.cfg_alos_thr_3_0            = media->cfg_alos_thr_3_0,
> +		.cfg_predrv_slewrate_1_0     = 3,
> +		.cfg_itx_ipcml_base_1_0      = 0,
> +		.cfg_ip_pre_base_1_0         = 0,
> +		.r_cdr_m_gen2_7_0            = 2,
> +		.r_cdr_m_gen3_7_0            = 2,
> +		.r_cdr_m_gen4_7_0            = 2,
> +		.r_en_auto_cdr_rstn          = 0,
> +		.cfg_oscal_afe               = 1,
> +		.cfg_pd_osdac_afe            = 0,
> +		.cfg_resetb_oscal_afe[0]     = 0,
> +		.cfg_resetb_oscal_afe[1]     = 1,
> +		.cfg_center_spreading        = 0,
> +		.cfg_m_cnt_maxval_4_0        = 15,
> +		.cfg_ncnt_maxval_7_0         = 32,
> +		.cfg_ncnt_maxval_10_8        = 6,
> +		.cfg_ssc_en                  = 1,
> +		.cfg_tx2rx_lp_en             = 0,
> +		.cfg_txlb_en                 = 0,
> +		.cfg_rx2tx_lp_en             = 0,
> +		.cfg_rxlb_en                 = 0,
> +		.r_tx_pol_inv                = args->txinvert,
> +		.r_rx_pol_inv                = args->rxinvert,
> +	};
> +
> +	*params = init;
> +}
> +
> +static int sparx5_sd25g28_apply_params(struct sparx5_serdes_macro *macro,
> +				       struct sparx5_sd25g28_params *params)
> +{
> +	struct sparx5_serdes_private *priv = macro->priv;
> +	int ret = 0;
> +	u32 value;
> +	u32 sd_index = macro->stpidx;
> +
> +	if (params->reg_rst == 1) {
> +		sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST_SET(1),
> +			 SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST,
> +			 priv,
> +			 SD_LANE_25G_SD_LANE_CFG(sd_index));
> +
> +		usleep_range(1000, 2000);
> +
> +		sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST_SET(0),
> +			 SD_LANE_25G_SD_LANE_CFG_EXT_CFG_RST,
> +			 priv,
> +			 SD_LANE_25G_SD_LANE_CFG(sd_index));
> +	}
> +
> +	sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(1),
> +		 SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
> +		 priv,
> +		 SD_LANE_25G_SD_LANE_CFG(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xFF),
> +		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
> +		 priv,
> +		 SD25G_LANE_CMU_FF(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT_SET
> +		 (params->r_d_width_ctrl_from_hwt) |
> +		 SD25G_LANE_CMU_1A_R_REG_MANUAL_SET(params->r_reg_manual),
> +		 SD25G_LANE_CMU_1A_R_DWIDTHCTRL_FROM_HWT |
> +		 SD25G_LANE_CMU_1A_R_REG_MANUAL,
> +		 priv,
> +		 SD25G_LANE_CMU_1A(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0_SET
> +		 (params->cfg_common_reserve_7_0),
> +		 SD25G_LANE_CMU_31_CFG_COMMON_RESERVE_7_0,
> +		 priv,
> +		 SD25G_LANE_CMU_31(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_09_CFG_EN_DUMMY_SET(params->cfg_en_dummy),
> +		 SD25G_LANE_CMU_09_CFG_EN_DUMMY,
> +		 priv,
> +		 SD25G_LANE_CMU_09(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0_SET
> +		 (params->cfg_pll_reserve_3_0),
> +		 SD25G_LANE_CMU_13_CFG_PLL_RESERVE_3_0,
> +		 priv,
> +		 SD25G_LANE_CMU_13(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN_SET(params->l0_cfg_txcal_en),
> +		 SD25G_LANE_CMU_40_L0_CFG_TXCAL_EN,
> +		 priv,
> +		 SD25G_LANE_CMU_40(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8_SET
> +		 (params->l0_cfg_tx_reserve_15_8),
> +		 SD25G_LANE_CMU_46_L0_CFG_TX_RESERVE_15_8,
> +		 priv,
> +		 SD25G_LANE_CMU_46(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0_SET
> +		 (params->l0_cfg_tx_reserve_7_0),
> +		 SD25G_LANE_CMU_45_L0_CFG_TX_RESERVE_7_0,
> +		 priv,
> +		 SD25G_LANE_CMU_45(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(0),
> +		 SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
> +		 priv,
> +		 SD25G_LANE_CMU_0B(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN_SET(1),
> +		 SD25G_LANE_CMU_0B_CFG_VCO_CAL_RESETN,
> +		 priv,
> +		 SD25G_LANE_CMU_0B(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_19_R_CK_RESETB_SET(0),
> +		 SD25G_LANE_CMU_19_R_CK_RESETB,
> +		 priv,
> +		 SD25G_LANE_CMU_19(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_19_R_CK_RESETB_SET(1),
> +		 SD25G_LANE_CMU_19_R_CK_RESETB,
> +		 priv,
> +		 SD25G_LANE_CMU_19(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_18_R_PLL_RSTN_SET(0),
> +		 SD25G_LANE_CMU_18_R_PLL_RSTN,
> +		 priv,
> +		 SD25G_LANE_CMU_18(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_18_R_PLL_RSTN_SET(1),
> +		 SD25G_LANE_CMU_18_R_PLL_RSTN,
> +		 priv,
> +		 SD25G_LANE_CMU_18(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0_SET(params->r_d_width_ctrl_2_0),
> +		 SD25G_LANE_CMU_1A_R_DWIDTHCTRL_2_0,
> +		 priv,
> +		 SD25G_LANE_CMU_1A(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0_SET
> +		 (params->r_txfifo_ck_div_pmad_2_0) |
> +		 SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0_SET
> +		 (params->r_rxfifo_ck_div_pmad_2_0),
> +		 SD25G_LANE_CMU_30_R_TXFIFO_CK_DIV_PMAD_2_0 |
> +		 SD25G_LANE_CMU_30_R_RXFIFO_CK_DIV_PMAD_2_0,
> +		 priv,
> +		 SD25G_LANE_CMU_30(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET_SET(params->cfg_pll_lol_set) |
> +		 SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0_SET
> +		 (params->cfg_vco_div_mode_1_0),
> +		 SD25G_LANE_CMU_0C_CFG_PLL_LOL_SET |
> +		 SD25G_LANE_CMU_0C_CFG_VCO_DIV_MODE_1_0,
> +		 priv,
> +		 SD25G_LANE_CMU_0C(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0_SET
> +		 (params->cfg_pre_divsel_1_0),
> +		 SD25G_LANE_CMU_0D_CFG_PRE_DIVSEL_1_0,
> +		 priv,
> +		 SD25G_LANE_CMU_0D(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0_SET(params->cfg_sel_div_3_0),
> +		 SD25G_LANE_CMU_0E_CFG_SEL_DIV_3_0,
> +		 priv,
> +		 SD25G_LANE_CMU_0E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0x00),
> +		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
> +		 priv,
> +		 SD25G_LANE_CMU_FF(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
> +		 (params->cfg_pma_tx_ck_bitwidth_2_0),
> +		 SD25G_LANE_LANE_0C_LN_CFG_PMA_TX_CK_BITWIDTH_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_0C(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0_SET
> +		 (params->cfg_tx_prediv_1_0),
> +		 SD25G_LANE_LANE_01_LN_CFG_TX_PREDIV_1_0,
> +		 priv,
> +		 SD25G_LANE_LANE_01(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0_SET
> +		 (params->cfg_rxdiv_sel_2_0),
> +		 SD25G_LANE_LANE_18_LN_CFG_RXDIV_SEL_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_18(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0_SET
> +		 (params->cfg_tx_subrate_2_0),
> +		 SD25G_LANE_LANE_2C_LN_CFG_TX_SUBRATE_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_2C(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0_SET
> +		 (params->cfg_rx_subrate_2_0),
> +		 SD25G_LANE_LANE_28_LN_CFG_RX_SUBRATE_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_28(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
> +		 SD25G_LANE_LANE_18_LN_CFG_CDRCK_EN,
> +		 priv,
> +		 SD25G_LANE_LANE_18(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1_SET
> +		 (params->cfg_dfetap_en_5_1),
> +		 SD25G_LANE_LANE_0F_LN_CFG_DFETAP_EN_5_1,
> +		 priv,
> +		 SD25G_LANE_LANE_0F(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
> +		 SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
> +		 priv,
> +		 SD25G_LANE_LANE_18(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN_SET(params->cfg_pi_dfe_en),
> +		 SD25G_LANE_LANE_1D_LN_CFG_PI_DFE_EN,
> +		 priv,
> +		 SD25G_LANE_LANE_1D(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_19_LN_CFG_ECDR_PD_SET(params->cfg_ecdr_pd),
> +		 SD25G_LANE_LANE_19_LN_CFG_ECDR_PD,
> +		 priv,
> +		 SD25G_LANE_LANE_19(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0_SET
> +		 (params->cfg_itx_ipdriver_base_2_0),
> +		 SD25G_LANE_LANE_01_LN_CFG_ITX_IPDRIVER_BASE_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_01(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0_SET(params->cfg_tap_dly_4_0),
> +		 SD25G_LANE_LANE_03_LN_CFG_TAP_DLY_4_0,
> +		 priv,
> +		 SD25G_LANE_LANE_03(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0_SET(params->cfg_tap_adv_3_0),
> +		 SD25G_LANE_LANE_06_LN_CFG_TAP_ADV_3_0,
> +		 priv,
> +		 SD25G_LANE_LANE_06(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_07_LN_CFG_EN_ADV_SET(params->cfg_en_adv) |
> +		 SD25G_LANE_LANE_07_LN_CFG_EN_DLY_SET(params->cfg_en_dly),
> +		 SD25G_LANE_LANE_07_LN_CFG_EN_ADV |
> +		 SD25G_LANE_LANE_07_LN_CFG_EN_DLY,
> +		 priv,
> +		 SD25G_LANE_LANE_07(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8_SET
> +		 (params->cfg_tx_reserve_15_8),
> +		 SD25G_LANE_LANE_43_LN_CFG_TX_RESERVE_15_8,
> +		 priv,
> +		 SD25G_LANE_LANE_43(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0_SET
> +		 (params->cfg_tx_reserve_7_0),
> +		 SD25G_LANE_LANE_42_LN_CFG_TX_RESERVE_7_0,
> +		 priv,
> +		 SD25G_LANE_LANE_42(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_05_LN_CFG_BW_1_0_SET(params->cfg_bw_1_0),
> +		 SD25G_LANE_LANE_05_LN_CFG_BW_1_0,
> +		 priv,
> +		 SD25G_LANE_LANE_05(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN_SET
> +		 (params->cfg_txcal_man_en),
> +		 SD25G_LANE_LANE_0B_LN_CFG_TXCAL_MAN_EN,
> +		 priv,
> +		 SD25G_LANE_LANE_0B(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0_SET
> +		 (params->cfg_txcal_shift_code_5_0),
> +		 SD25G_LANE_LANE_0A_LN_CFG_TXCAL_SHIFT_CODE_5_0,
> +		 priv,
> +		 SD25G_LANE_LANE_0A(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0_SET
> +		 (params->cfg_txcal_valid_sel_3_0),
> +		 SD25G_LANE_LANE_09_LN_CFG_TXCAL_VALID_SEL_3_0,
> +		 priv,
> +		 SD25G_LANE_LANE_09(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0_SET(params->cfg_cdr_kf_2_0),
> +		 SD25G_LANE_LANE_1A_LN_CFG_CDR_KF_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_1A(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0_SET(params->cfg_cdr_m_7_0),
> +		 SD25G_LANE_LANE_1B_LN_CFG_CDR_M_7_0,
> +		 priv,
> +		 SD25G_LANE_LANE_1B(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0_SET(params->cfg_pi_bw_3_0),
> +		 SD25G_LANE_LANE_2B_LN_CFG_PI_BW_3_0,
> +		 priv,
> +		 SD25G_LANE_LANE_2B(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER_SET
> +		 (params->cfg_dis_2ndorder),
> +		 SD25G_LANE_LANE_2C_LN_CFG_DIS_2NDORDER,
> +		 priv,
> +		 SD25G_LANE_LANE_2C(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN_SET(params->cfg_ctle_rstn),
> +		 SD25G_LANE_LANE_2E_LN_CFG_CTLE_RSTN,
> +		 priv,
> +		 SD25G_LANE_LANE_2E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0_SET
> +		 (params->cfg_itx_ipcml_base_1_0),
> +		 SD25G_LANE_LANE_00_LN_CFG_ITX_IPCML_BASE_1_0,
> +		 priv,
> +		 SD25G_LANE_LANE_00(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0_SET
> +		 (params->cfg_rx_reserve_7_0),
> +		 SD25G_LANE_LANE_44_LN_CFG_RX_RESERVE_7_0,
> +		 priv,
> +		 SD25G_LANE_LANE_44(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8_SET
> +		 (params->cfg_rx_reserve_15_8),
> +		 SD25G_LANE_LANE_45_LN_CFG_RX_RESERVE_15_8,
> +		 priv,
> +		 SD25G_LANE_LANE_45(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN_SET(params->cfg_dfeck_en) |
> +		 SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0_SET(params->cfg_rxterm_2_0),
> +		 SD25G_LANE_LANE_0D_LN_CFG_DFECK_EN |
> +		 SD25G_LANE_LANE_0D_LN_CFG_RXTERM_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_0D(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0_SET
> +		 (params->cfg_vga_ctrl_byp_4_0),
> +		 SD25G_LANE_LANE_21_LN_CFG_VGA_CTRL_BYP_4_0,
> +		 priv,
> +		 SD25G_LANE_LANE_21(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0_SET
> +		 (params->cfg_eqr_force_3_0),
> +		 SD25G_LANE_LANE_22_LN_CFG_EQR_FORCE_3_0,
> +		 priv,
> +		 SD25G_LANE_LANE_22(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0_SET
> +		 (params->cfg_eqc_force_3_0) |
> +		 SD25G_LANE_LANE_1C_LN_CFG_DFE_PD_SET(params->cfg_dfe_pd),
> +		 SD25G_LANE_LANE_1C_LN_CFG_EQC_FORCE_3_0 |
> +		 SD25G_LANE_LANE_1C_LN_CFG_DFE_PD,
> +		 priv,
> +		 SD25G_LANE_LANE_1C(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN_SET
> +		 (params->cfg_sum_setcm_en),
> +		 SD25G_LANE_LANE_1E_LN_CFG_SUM_SETCM_EN,
> +		 priv,
> +		 SD25G_LANE_LANE_1E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0_SET
> +		 (params->cfg_init_pos_iscan_6_0),
> +		 SD25G_LANE_LANE_25_LN_CFG_INIT_POS_ISCAN_6_0,
> +		 priv,
> +		 SD25G_LANE_LANE_25(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0_SET
> +		 (params->cfg_init_pos_ipi_6_0),
> +		 SD25G_LANE_LANE_26_LN_CFG_INIT_POS_IPI_6_0,
> +		 priv,
> +		 SD25G_LANE_LANE_26(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD_SET(params->cfg_erramp_pd),
> +		 SD25G_LANE_LANE_18_LN_CFG_ERRAMP_PD,
> +		 priv,
> +		 SD25G_LANE_LANE_18(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0_SET
> +		 (params->cfg_dfedig_m_2_0),
> +		 SD25G_LANE_LANE_0E_LN_CFG_DFEDIG_M_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_0E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG_SET(params->cfg_en_dfedig),
> +		 SD25G_LANE_LANE_0E_LN_CFG_EN_DFEDIG,
> +		 priv,
> +		 SD25G_LANE_LANE_0E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_40_LN_R_TX_POL_INV_SET(params->r_tx_pol_inv) |
> +		 SD25G_LANE_LANE_40_LN_R_RX_POL_INV_SET(params->r_rx_pol_inv),
> +		 SD25G_LANE_LANE_40_LN_R_TX_POL_INV |
> +		 SD25G_LANE_LANE_40_LN_R_RX_POL_INV,
> +		 priv,
> +		 SD25G_LANE_LANE_40(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN_SET(params->cfg_rx2tx_lp_en) |
> +		 SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN_SET(params->cfg_tx2rx_lp_en),
> +		 SD25G_LANE_LANE_04_LN_CFG_RX2TX_LP_EN |
> +		 SD25G_LANE_LANE_04_LN_CFG_TX2RX_LP_EN,
> +		 priv,
> +		 SD25G_LANE_LANE_04(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN_SET(params->cfg_rxlb_en),
> +		 SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN,
> +		 priv,
> +		 SD25G_LANE_LANE_1E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_19_LN_CFG_TXLB_EN_SET(params->cfg_txlb_en),
> +		 SD25G_LANE_LANE_19_LN_CFG_TXLB_EN,
> +		 priv,
> +		 SD25G_LANE_LANE_19(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(0),
> +		 SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
> +		 priv,
> +		 SD25G_LANE_LANE_2E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(1),
> +		 SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
> +		 priv,
> +		 SD25G_LANE_LANE_2E(sd_index));
> +
> +	sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(0),
> +		 SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
> +		 priv,
> +		 SD_LANE_25G_SD_LANE_CFG(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(0),
> +		 SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
> +		 priv,
> +		 SD25G_LANE_LANE_1C(sd_index));

This looks quite terrible :(

Can we do a table here for these and then write the configuration table,
that may look better and easy to maintain ?

> +
> +	usleep_range(1000, 2000);
> +
> +	sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(1),
> +		 SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
> +		 priv,
> +		 SD25G_LANE_LANE_1C(sd_index));
> +
> +	usleep_range(10000, 20000);
> +
> +	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xff),
> +		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
> +		 priv,
> +		 SD25G_LANE_CMU_FF(sd_index));
> +
> +	value = sdx5_rd(priv, SD25G_LANE_CMU_C0(sd_index));
> +	value = SD25G_LANE_CMU_C0_PLL_LOL_UDL_GET(value);
> +
> +	if (value) {
> +		dev_err(macro->priv->dev, "25G PLL Loss of Lock: 0x%x\n", value);
> +		ret = -EINVAL;
> +	}
> +
> +	value = sdx5_rd(priv, SD_LANE_25G_SD_LANE_STAT(sd_index));
> +	value = SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE_GET(value);
> +
> +	if (value != 0x1) {
> +		dev_err(macro->priv->dev, "25G PMA Reset failed: 0x%x\n", value);
> +		ret = -EINVAL;

continue on error..?

> +	}
> +
> +	sdx5_rmw(SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS_SET(0x1),
> +		 SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS,
> +		 priv,
> +		 SD25G_LANE_CMU_2A(sd_index));
> +
> +	sdx5_rmw(SD_LANE_25G_SD_SER_RST_SER_RST_SET(0x0),
> +		 SD_LANE_25G_SD_SER_RST_SER_RST,
> +		 priv,
> +		 SD_LANE_25G_SD_SER_RST(sd_index));
> +
> +	sdx5_rmw(SD_LANE_25G_SD_DES_RST_DES_RST_SET(0x0),
> +		 SD_LANE_25G_SD_DES_RST_DES_RST,
> +		 priv,
> +		 SD_LANE_25G_SD_DES_RST(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0),
> +		 SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
> +		 priv,
> +		 SD25G_LANE_CMU_FF(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0_SET
> +		 (params->cfg_alos_thr_2_0),
> +		 SD25G_LANE_LANE_2D_LN_CFG_ALOS_THR_2_0,
> +		 priv,
> +		 SD25G_LANE_LANE_2D(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ_SET(0),
> +		 SD25G_LANE_LANE_2E_LN_CFG_DIS_SQ,
> +		 priv,
> +		 SD25G_LANE_LANE_2E(sd_index));
> +
> +	sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_PD_SQ_SET(0),
> +		 SD25G_LANE_LANE_2E_LN_CFG_PD_SQ,
> +		 priv,
> +		 SD25G_LANE_LANE_2E(sd_index));
> +
> +	return ret;
> +}
> +
> +static int sparx5_sd10g28_apply_params(struct sparx5_serdes_macro *macro,
> +				       struct sparx5_sd10g28_params *params)
> +{
> +	struct sparx5_serdes_private *priv = macro->priv;
> +	int ret = 0;
> +	u32 value;
> +	u32 sd_lane_tgt = macro->sidx;
> +	void __iomem *sd_inst;
> +	u32 sd_index = macro->stpidx;
> +
> +	if (params->is_6g)
> +		sd_inst = sdx5_inst_get(priv, TARGET_SD6G_LANE, sd_index);
> +	else
> +		sd_inst = sdx5_inst_get(priv, TARGET_SD10G_LANE, sd_index);
> +	/* Note: SerDes SD10G_LANE_1 is configured in 10G_LAN mode */
> +	sdx5_rmw(SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(1),
> +		 SD_LANE_SD_LANE_CFG_EXT_CFG_RST,
> +		 macro->priv,
> +		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
> +
> +	usleep_range(1000, 2000);
> +
> +	sdx5_rmw(SD_LANE_SD_LANE_CFG_EXT_CFG_RST_SET(0),
> +		 SD_LANE_SD_LANE_CFG_EXT_CFG_RST,
> +		 priv,
> +		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
> +
> +	sdx5_rmw(SD_LANE_SD_LANE_CFG_MACRO_RST_SET(1),
> +		 SD_LANE_SD_LANE_CFG_MACRO_RST,
> +		 priv,
> +		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT_SET(0x0) |
> +		      SD10G_LANE_LANE_93_R_REG_MANUAL_SET(0x1) |
> +		      SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT_SET(0x1) |
> +		      SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT_SET(0x1) |
> +		      SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL_SET(0x0),
> +		      SD10G_LANE_LANE_93_R_DWIDTHCTRL_FROM_HWT |
> +		      SD10G_LANE_LANE_93_R_REG_MANUAL |
> +		      SD10G_LANE_LANE_93_R_AUXCKSEL_FROM_HWT |
> +		      SD10G_LANE_LANE_93_R_LANE_ID_FROM_HWT |
> +		      SD10G_LANE_LANE_93_R_EN_RATECHG_CTRL,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_93(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_94_R_ISCAN_REG_SET(0x1) |
> +		      SD10G_LANE_LANE_94_R_TXEQ_REG_SET(0x1) |
> +		      SD10G_LANE_LANE_94_R_MISC_REG_SET(0x1) |
> +		      SD10G_LANE_LANE_94_R_SWING_REG_SET(0x1),
> +		      SD10G_LANE_LANE_94_R_ISCAN_REG |
> +		      SD10G_LANE_LANE_94_R_TXEQ_REG |
> +		      SD10G_LANE_LANE_94_R_MISC_REG |
> +		      SD10G_LANE_LANE_94_R_SWING_REG,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_94(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_9E_R_RXEQ_REG_SET(0x1),
> +		      SD10G_LANE_LANE_9E_R_RXEQ_REG,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_9E(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_A1_R_SSC_FROM_HWT_SET(0x0) |
> +		      SD10G_LANE_LANE_A1_R_CDR_FROM_HWT_SET(0x0) |
> +		      SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT_SET(0x1),
> +		      SD10G_LANE_LANE_A1_R_SSC_FROM_HWT |
> +		      SD10G_LANE_LANE_A1_R_CDR_FROM_HWT |
> +		      SD10G_LANE_LANE_A1_R_PCLK_GATING_FROM_HWT,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_A1(sd_index));
> +
> +	sdx5_rmw(SD_LANE_SD_LANE_CFG_RX_REF_SEL_SET(params->cmu_sel) |
> +		 SD_LANE_SD_LANE_CFG_TX_REF_SEL_SET(params->cmu_sel),
> +		 SD_LANE_SD_LANE_CFG_RX_REF_SEL |
> +		 SD_LANE_SD_LANE_CFG_TX_REF_SEL,
> +		 priv,
> +		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0_SET
> +		      (params->cfg_lane_reserve_7_0),
> +		      SD10G_LANE_LANE_40_CFG_LANE_RESERVE_7_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_40(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL_SET
> +		      (params->cfg_ssc_rtl_clk_sel),
> +		      SD10G_LANE_LANE_50_CFG_SSC_RTL_CLK_SEL,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_50(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_35_CFG_TXRATE_1_0_SET
> +		      (params->cfg_txrate_1_0) |
> +		      SD10G_LANE_LANE_35_CFG_RXRATE_1_0_SET
> +		      (params->cfg_rxrate_1_0),
> +		      SD10G_LANE_LANE_35_CFG_TXRATE_1_0 |
> +		      SD10G_LANE_LANE_35_CFG_RXRATE_1_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_35(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0_SET
> +		      (params->r_d_width_ctrl_2_0),
> +		      SD10G_LANE_LANE_94_R_DWIDTHCTRL_2_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_94(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0_SET
> +		      (params->cfg_pma_tx_ck_bitwidth_2_0),
> +		      SD10G_LANE_LANE_01_CFG_PMA_TX_CK_BITWIDTH_2_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_01(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0_SET
> +		      (params->cfg_rxdiv_sel_2_0),
> +		      SD10G_LANE_LANE_30_CFG_RXDIV_SEL_2_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_30(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0_SET
> +		      (params->r_pcs2pma_phymode_4_0),
> +		      SD10G_LANE_LANE_A2_R_PCS2PMA_PHYMODE_4_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_A2(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_13_CFG_CDRCK_EN_SET(params->cfg_cdrck_en),
> +		      SD10G_LANE_LANE_13_CFG_CDRCK_EN,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_13(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_23_CFG_DFECK_EN_SET
> +		      (params->cfg_dfeck_en) |
> +		      SD10G_LANE_LANE_23_CFG_DFE_PD_SET(params->cfg_dfe_pd) |
> +		      SD10G_LANE_LANE_23_CFG_ERRAMP_PD_SET
> +		      (params->cfg_erramp_pd),
> +		      SD10G_LANE_LANE_23_CFG_DFECK_EN |
> +		      SD10G_LANE_LANE_23_CFG_DFE_PD |
> +		      SD10G_LANE_LANE_23_CFG_ERRAMP_PD,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_23(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1_SET
> +		      (params->cfg_dfetap_en_5_1),
> +		      SD10G_LANE_LANE_22_CFG_DFETAP_EN_5_1,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_22(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_DFE_EN_SET
> +		      (params->cfg_pi_DFE_en),
> +		      SD10G_LANE_LANE_1A_CFG_PI_DFE_EN,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_1A(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_02_CFG_EN_ADV_SET(params->cfg_en_adv) |
> +		      SD10G_LANE_LANE_02_CFG_EN_MAIN_SET(params->cfg_en_main) |
> +		      SD10G_LANE_LANE_02_CFG_EN_DLY_SET(params->cfg_en_dly) |
> +		      SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0_SET
> +		      (params->cfg_tap_adv_3_0),
> +		      SD10G_LANE_LANE_02_CFG_EN_ADV |
> +		      SD10G_LANE_LANE_02_CFG_EN_MAIN |
> +		      SD10G_LANE_LANE_02_CFG_EN_DLY |
> +		      SD10G_LANE_LANE_02_CFG_TAP_ADV_3_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_02(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_03_CFG_TAP_MAIN_SET(params->cfg_tap_main),
> +		      SD10G_LANE_LANE_03_CFG_TAP_MAIN,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_03(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0_SET
> +		      (params->cfg_tap_dly_4_0),
> +		      SD10G_LANE_LANE_04_CFG_TAP_DLY_4_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_04(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0_SET
> +		      (params->cfg_vga_ctrl_3_0),
> +		      SD10G_LANE_LANE_2F_CFG_VGA_CTRL_3_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_2F(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0_SET
> +		      (params->cfg_vga_cp_2_0),
> +		      SD10G_LANE_LANE_2F_CFG_VGA_CP_2_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_2F(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0_SET
> +		      (params->cfg_eq_res_3_0),
> +		      SD10G_LANE_LANE_0B_CFG_EQ_RES_3_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0B(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0D_CFG_EQR_BYP_SET(params->cfg_eq_r_byp),
> +		      SD10G_LANE_LANE_0D_CFG_EQR_BYP,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0D(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0_SET
> +		      (params->cfg_eq_c_force_3_0) |
> +		      SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN_SET
> +		      (params->cfg_sum_setcm_en),
> +		      SD10G_LANE_LANE_0E_CFG_EQC_FORCE_3_0 |
> +		      SD10G_LANE_LANE_0E_CFG_SUM_SETCM_EN,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0E(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_23_CFG_EN_DFEDIG_SET
> +		      (params->cfg_en_dfedig),
> +		      SD10G_LANE_LANE_23_CFG_EN_DFEDIG,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_23(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_06_CFG_EN_PREEMPH_SET
> +		      (params->cfg_en_preemph),
> +		      SD10G_LANE_LANE_06_CFG_EN_PREEMPH,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_06(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0_SET
> +		      (params->cfg_itx_ippreemp_base_1_0) |
> +		      SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0_SET
> +		      (params->cfg_itx_ipdriver_base_2_0),
> +		      SD10G_LANE_LANE_33_CFG_ITX_IPPREEMP_BASE_1_0 |
> +		      SD10G_LANE_LANE_33_CFG_ITX_IPDRIVER_BASE_2_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_33(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0_SET
> +		      (params->cfg_ibias_tune_reserve_5_0),
> +		      SD10G_LANE_LANE_52_CFG_IBIAS_TUNE_RESERVE_5_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_52(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_37_CFG_TXSWING_HALF_SET
> +		      (params->cfg_txswing_half),
> +		      SD10G_LANE_LANE_37_CFG_TXSWING_HALF,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_37(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER_SET
> +		      (params->cfg_dis_2nd_order),
> +		      SD10G_LANE_LANE_3C_CFG_DIS_2NDORDER,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_3C(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_39_CFG_RX_SSC_LH_SET
> +		      (params->cfg_rx_ssc_lh),
> +		      SD10G_LANE_LANE_39_CFG_RX_SSC_LH,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_39(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0_SET
> +		      (params->cfg_pi_floop_steps_1_0),
> +		      SD10G_LANE_LANE_1A_CFG_PI_FLOOP_STEPS_1_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_1A(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16_SET
> +		      (params->cfg_pi_ext_dac_23_16),
> +		      SD10G_LANE_LANE_16_CFG_PI_EXT_DAC_23_16,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_16(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8_SET
> +		      (params->cfg_pi_ext_dac_15_8),
> +		      SD10G_LANE_LANE_15_CFG_PI_EXT_DAC_15_8,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_15(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0_SET
> +		      (params->cfg_iscan_ext_dac_7_0),
> +		      SD10G_LANE_LANE_26_CFG_ISCAN_EXT_DAC_7_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_26(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0_SET
> +		      (params->cfg_cdr_kf_gen1_2_0),
> +		      SD10G_LANE_LANE_42_CFG_CDR_KF_GEN1_2_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_42(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0_SET
> +		      (params->r_cdr_m_gen1_7_0),
> +		      SD10G_LANE_LANE_0F_R_CDR_M_GEN1_7_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0F(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0_SET
> +		      (params->cfg_pi_bw_gen1_3_0),
> +		      SD10G_LANE_LANE_24_CFG_PI_BW_GEN1_3_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_24(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0_SET
> +		      (params->cfg_pi_ext_dac_7_0),
> +		      SD10G_LANE_LANE_14_CFG_PI_EXT_DAC_7_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_14(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_1A_CFG_PI_STEPS_SET(params->cfg_pi_steps),
> +		      SD10G_LANE_LANE_1A_CFG_PI_STEPS,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_1A(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0_SET
> +		      (params->cfg_mp_max_3_0),
> +		      SD10G_LANE_LANE_3A_CFG_MP_MAX_3_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_3A(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG_SET
> +		      (params->cfg_rstn_dfedig),
> +		      SD10G_LANE_LANE_31_CFG_RSTN_DFEDIG,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_31(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0_SET
> +		      (params->cfg_alos_thr_3_0),
> +		      SD10G_LANE_LANE_48_CFG_ALOS_THR_3_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_48(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0_SET
> +		      (params->cfg_predrv_slewrate_1_0),
> +		      SD10G_LANE_LANE_36_CFG_PREDRV_SLEWRATE_1_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_36(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0_SET
> +		      (params->cfg_itx_ipcml_base_1_0),
> +		      SD10G_LANE_LANE_32_CFG_ITX_IPCML_BASE_1_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_32(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0_SET
> +		      (params->cfg_ip_pre_base_1_0),
> +		      SD10G_LANE_LANE_37_CFG_IP_PRE_BASE_1_0,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_37(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8_SET
> +		      (params->cfg_lane_reserve_15_8),
> +		      SD10G_LANE_LANE_41_CFG_LANE_RESERVE_15_8,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_41(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN_SET
> +		      (params->r_en_auto_cdr_rstn),
> +		      SD10G_LANE_LANE_9E_R_EN_AUTO_CDR_RSTN,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_9E(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0C_CFG_OSCAL_AFE_SET
> +		      (params->cfg_oscal_afe) |
> +		      SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE_SET
> +		      (params->cfg_pd_osdac_afe),
> +		      SD10G_LANE_LANE_0C_CFG_OSCAL_AFE |
> +		      SD10G_LANE_LANE_0C_CFG_PD_OSDAC_AFE,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0C(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
> +		      (params->cfg_resetb_oscal_afe[0]),
> +		      SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0B(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE_SET
> +		      (params->cfg_resetb_oscal_afe[1]),
> +		      SD10G_LANE_LANE_0B_CFG_RESETB_OSCAL_AFE,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0B(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_83_R_TX_POL_INV_SET
> +		      (params->r_tx_pol_inv) |
> +		      SD10G_LANE_LANE_83_R_RX_POL_INV_SET
> +		      (params->r_rx_pol_inv),
> +		      SD10G_LANE_LANE_83_R_TX_POL_INV |
> +		      SD10G_LANE_LANE_83_R_RX_POL_INV,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_83(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN_SET
> +		      (params->cfg_rx2tx_lp_en) |
> +		      SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN_SET
> +		      (params->cfg_tx2rx_lp_en),
> +		      SD10G_LANE_LANE_06_CFG_RX2TX_LP_EN |
> +		      SD10G_LANE_LANE_06_CFG_TX2RX_LP_EN,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_06(sd_index));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_0E_CFG_RXLB_EN_SET(params->cfg_rxlb_en) |
> +		      SD10G_LANE_LANE_0E_CFG_TXLB_EN_SET(params->cfg_txlb_en),
> +		      SD10G_LANE_LANE_0E_CFG_RXLB_EN |
> +		      SD10G_LANE_LANE_0E_CFG_TXLB_EN,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_0E(sd_index));
> +
> +	sdx5_rmw(SD_LANE_SD_LANE_CFG_MACRO_RST_SET(0),
> +		 SD_LANE_SD_LANE_CFG_MACRO_RST,
> +		 priv,
> +		 SD_LANE_SD_LANE_CFG(sd_lane_tgt));
> +
> +	sdx5_inst_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
> +		      SD10G_LANE_LANE_50_CFG_SSC_RESETB,
> +		      sd_inst,
> +		      SD10G_LANE_LANE_50(sd_index));
> +
> +	sdx5_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
> +		 SD10G_LANE_LANE_50_CFG_SSC_RESETB,
> +		 priv,
> +		 SD10G_LANE_LANE_50(sd_index));
> +
> +	sdx5_rmw(SD_LANE_MISC_SD_125_RST_DIS_SET(params->fx_100),
> +		 SD_LANE_MISC_SD_125_RST_DIS,
> +		 priv,
> +		 SD_LANE_MISC(sd_lane_tgt));
> +
> +	sdx5_rmw(SD_LANE_MISC_RX_ENA_SET(params->fx_100),
> +		 SD_LANE_MISC_RX_ENA,
> +		 priv,
> +		 SD_LANE_MISC(sd_lane_tgt));
> +
> +	sdx5_rmw(SD_LANE_MISC_MUX_ENA_SET(params->fx_100),
> +		 SD_LANE_MISC_MUX_ENA,
> +		 priv,
> +		 SD_LANE_MISC(sd_lane_tgt));

Table for this set as well as other places please

-- 
~Vinod
