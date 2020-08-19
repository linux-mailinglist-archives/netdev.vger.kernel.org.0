Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA21E249C72
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgHSLtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgHSLrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 07:47:02 -0400
Received: from mail.kernel.org (ip5f5ad5a3.dynamic.kabel-deutschland.de [95.90.213.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 516F32080C;
        Wed, 19 Aug 2020 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597837582;
        bh=K/TA65WsLXZf8BWFVZatpLXWEsuuyX3vzmz5kGE6CMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asYZL6wpN998uDspvLQLvK3RnhHfASpEITWQd5b6XicSMGT2PmW7LgVXtNIz4SJGG
         KeOTO1XbeWkXd6fRymZiRSFgsIIxumXzDRrzg9+qdaKxFWZCxuHH2OeJ6EkTwPmsY/
         YCoCXQTWZ4MFLTDSylCVQHFZrmi/4ctKb8g/8tUc=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1k8MXq-00EuZy-TA; Wed, 19 Aug 2020 13:46:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linuxarm@huawei.com, mauro.chehab@huawei.com,
        Chen Feng <puck.chen@hisilicon.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Liwei Cai <cailiwei@hisilicon.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 01/49] staging: hikey9xx: Add hisilicon DRM driver for hikey960/970
Date:   Wed, 19 Aug 2020 13:45:29 +0200
Message-Id: <2002b1c05fa14a1ff6c19d220c0e5afd1ea18156.1597833138.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1597833138.git.mchehab+huawei@kernel.org>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Feng <puck.chen@hisilicon.com>

Add initial driver for hikey960 DRM driver, backported
from OOT tree. Later patches will be needed to make this
driver work.

[jstultz: Rework patchset to use upstream adv7511 and remove duplicated code]

[mchehab+huawei@kernel.org: port just a subset of the
 original patch and place it at staging]

Signed-off-by: Chen Feng <puck.chen@hisilicon.com>
Signed-off-by: Liwei Cai <cailiwei@hisilicon.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/staging/hikey9xx/gpu/Kconfig          |   52 +
 drivers/staging/hikey9xx/gpu/Makefile         |   12 +
 drivers/staging/hikey9xx/gpu/dw_drm_dsi.c     | 1650 +++++++++
 drivers/staging/hikey9xx/gpu/dw_dsi_reg.h     |  145 +
 drivers/staging/hikey9xx/gpu/kirin_dpe_reg.h  | 3114 +++++++++++++++++
 .../hikey9xx/gpu/kirin_drm_dpe_utils.c        |  731 ++++
 .../hikey9xx/gpu/kirin_drm_dpe_utils.h        |   58 +
 drivers/staging/hikey9xx/gpu/kirin_drm_drv.c  |  380 ++
 drivers/staging/hikey9xx/gpu/kirin_drm_drv.h  |   60 +
 drivers/staging/hikey9xx/gpu/kirin_drm_dss.c  |  701 ++++
 .../hikey9xx/gpu/kirin_drm_overlay_utils.c    | 1288 +++++++
 drivers/staging/hikey9xx/gpu/kirin_fb.c       |   94 +
 drivers/staging/hikey9xx/gpu/kirin_fbdev.c    |  470 +++
 13 files changed, 8755 insertions(+)
 create mode 100644 drivers/staging/hikey9xx/gpu/Kconfig
 create mode 100644 drivers/staging/hikey9xx/gpu/Makefile
 create mode 100644 drivers/staging/hikey9xx/gpu/dw_drm_dsi.c
 create mode 100644 drivers/staging/hikey9xx/gpu/dw_dsi_reg.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_dpe_reg.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_drm_drv.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_drm_drv.h
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_drm_dss.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_drm_overlay_utils.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_fb.c
 create mode 100644 drivers/staging/hikey9xx/gpu/kirin_fbdev.c

diff --git a/drivers/staging/hikey9xx/gpu/Kconfig b/drivers/staging/hikey9xx/gpu/Kconfig
new file mode 100644
index 000000000000..5533ee624f29
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/Kconfig
@@ -0,0 +1,52 @@
+config DRM_HISI_KIRIN
+	tristate "DRM Support for Hisilicon Kirin series SoCs Platform"
+	depends on DRM && OF && ARM64
+	select DRM_KMS_HELPER
+	select DRM_GEM_CMA_HELPER
+	select DRM_KMS_CMA_HELPER
+	select HISI_KIRIN_DW_DSI
+	help
+	  Choose this option if you have a hisilicon Kirin chipsets(hi6220).
+	  If M is selected the module will be called kirin-drm.
+
+config DRM_KIRIN_960
+	tristate "DRM Support for Hisilicon Kirin960 series SoCs Platform"
+	depends on DRM && OF && ARM64
+	select DRM_KMS_HELPER
+	select DRM_GEM_CMA_HELPER
+	select DRM_KMS_CMA_HELPER
+	select HISI_KIRIN_DW_DSI
+	help
+	  Choose this option if you have a hisilicon Kirin chipsets(kirin960).
+	  If M is selected the module will be called kirin-drm.
+
+config HISI_KIRIN_DW_DSI
+	tristate "HiSilicon Kirin specific extensions for Synopsys DW MIPI DSI"
+	depends on DRM_HISI_KIRIN || DRM_KIRIN_960
+	select DRM_MIPI_DSI
+	select DRM_PANEL
+	help
+	 This selects support for HiSilicon Kirin SoC specific extensions for
+	 the Synopsys DesignWare DSI driver. If you want to enable MIPI DSI on
+	 hi6220 based SoC, you should selet this option.
+
+config DRM_PANEL_HIKEY960_NTE300NTS
+	tristate "Hikey960 NTE300NTS video mode panel"
+	depends on OF
+	depends on DRM_MIPI_DSI
+	help
+		Say Y here if you want to enable LCD panel driver for Hikey960 boadr.
+		Current support panel: NTE300NTS(1920X1200)
+
+config HISI_FB_970
+	tristate "DRM Support for Hisilicon Kirin970 series SoCs Platform"
+	depends on DRM && OF && ARM64
+	depends on DRM_MIPI_DSI
+	help
+	  Choose this option if you have a hisilicon Kirin chipsets(kirin970).
+	  If M is selected the module will be called kirin-drm.
+
+config HDMI_ADV7511_AUDIO
+	tristate "HDMI Support ADV7511 audio"
+	help
+	  Choose this option to support HDMI ADV7511 audio.
diff --git a/drivers/staging/hikey9xx/gpu/Makefile b/drivers/staging/hikey9xx/gpu/Makefile
new file mode 100644
index 000000000000..42d1ed179264
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/Makefile
@@ -0,0 +1,12 @@
+EXTRA_CFLAGS += \
+		-Iinclude/drm
+
+kirin-drm-y := kirin_fbdev.o \
+		kirin_fb.o \
+		kirin_drm_drv.o \
+		kirin_drm_dss.o \
+		kirin_drm_dpe_utils.o \
+		kirin_drm_overlay_utils.o \
+
+obj-$(CONFIG_DRM_KIRIN_960) += kirin-drm.o
+obj-$(CONFIG_HISI_KIRIN_DW_DSI) += dw_drm_dsi.o
diff --git a/drivers/staging/hikey9xx/gpu/dw_drm_dsi.c b/drivers/staging/hikey9xx/gpu/dw_drm_dsi.c
new file mode 100644
index 000000000000..1d1d4f49609c
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/dw_drm_dsi.c
@@ -0,0 +1,1650 @@
+/*
+ * DesignWare MIPI DSI Host Controller v1.02 driver
+ *
+ * Copyright (c) 2016 Linaro Limited.
+ * Copyright (c) 2014-2016 Hisilicon Limited.
+ *
+ * Author:
+ *	<shizongxuan@huawei.com>
+ *	<zhangxiubin@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/component.h>
+#include <linux/of_graph.h>
+#include <linux/iopoll.h>
+#include <video/mipi_display.h>
+#include <linux/gpio/consumer.h>
+#include <linux/of_address.h>
+
+#include <drm/drm_of.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_mipi_dsi.h>
+#include <drm/drm_encoder_slave.h>
+#include <drm/drm_atomic_helper.h>
+#include <drm/drm_panel.h>
+
+#include "dw_dsi_reg.h"
+#include "kirin_dpe_reg.h"
+#include "kirin_drm_dpe_utils.h"
+
+#define DTS_COMP_DSI_NAME "hisilicon,hi3660-dsi"
+
+#define MAX_TX_ESC_CLK		10
+#define ROUND(x, y)		((x) / (y) + \
+				((x) % (y) * 10 / (y) >= 5 ? 1 : 0))
+#define ROUND1(x, y)	((x) / (y) + ((x) % (y)  ? 1 : 0))
+#define PHY_REF_CLK_RATE	19200000
+#define PHY_REF_CLK_PERIOD_PS	(1000000000 / (PHY_REF_CLK_RATE / 1000))
+
+#define encoder_to_dsi(encoder) \
+	container_of(encoder, struct dw_dsi, encoder)
+#define host_to_dsi(host) \
+	container_of(host, struct dw_dsi, host)
+#define connector_to_dsi(connector) \
+	container_of(connector, struct dw_dsi, connector)
+#define DSS_REDUCE(x)	((x) > 0 ? ((x) - 1) : (x))
+
+enum dsi_output_client {
+	OUT_HDMI = 0,
+	OUT_PANEL,
+	OUT_MAX
+};
+
+struct mipi_phy_params {
+	u64 lane_byte_clk;
+	u32 clk_division;
+
+	u32 clk_lane_lp2hs_time;
+	u32 clk_lane_hs2lp_time;
+	u32 data_lane_lp2hs_time;
+	u32 data_lane_hs2lp_time;
+	u32 clk2data_delay;
+	u32 data2clk_delay;
+
+	u32 clk_pre_delay;
+	u32 clk_post_delay;
+	u32 clk_t_lpx;
+	u32 clk_t_hs_prepare;
+	u32 clk_t_hs_zero;
+	u32 clk_t_hs_trial;
+	u32 clk_t_wakeup;
+	u32 data_pre_delay;
+	u32 data_post_delay;
+	u32 data_t_lpx;
+	u32 data_t_hs_prepare;
+	u32 data_t_hs_zero;
+	u32 data_t_hs_trial;
+	u32 data_t_ta_go;
+	u32 data_t_ta_get;
+	u32 data_t_wakeup;
+
+	u32 phy_stop_wait_time;
+
+	u32 rg_vrefsel_vcm;
+	u32 rg_hstx_ckg_sel;
+	u32 rg_pll_fbd_div5f;
+	u32 rg_pll_fbd_div1f;
+	u32 rg_pll_fbd_2p;
+	u32 rg_pll_enbwt;
+	u32 rg_pll_fbd_p;
+	u32 rg_pll_fbd_s;
+	u32 rg_pll_pre_div1p;
+	u32 rg_pll_pre_p;
+	u32 rg_pll_vco_750m;
+	u32 rg_pll_lpf_rs;
+	u32 rg_pll_lpf_cs;
+	u32 rg_pll_enswc;
+	u32 rg_pll_chp;
+
+	u32 pll_register_override;		/*0x1E[0]*/
+	u32 pll_power_down;			/*0x1E[1]*/
+	u32 rg_band_sel;				/*0x1E[2]*/
+	u32 rg_phase_gen_en;		/*0x1E[3]*/
+	u32 reload_sel;				/*0x1E[4]*/
+	u32 rg_pll_cp_p;				/*0x1E[7:5]*/
+	u32 rg_pll_refsel;				/*0x16[1:0]*/
+	u32 rg_pll_cp;				/*0x16[7:5]*/
+	u32 load_command;
+};
+
+struct dsi_hw_ctx {
+	void __iomem *base;
+	char __iomem *peri_crg_base;
+
+	struct clk *dss_dphy0_ref_clk;
+	struct clk *dss_dphy1_ref_clk;
+	struct clk *dss_dphy0_cfg_clk;
+	struct clk *dss_dphy1_cfg_clk;
+	struct clk *dss_pclk_dsi0_clk;
+	struct clk *dss_pclk_dsi1_clk;
+};
+
+struct dw_dsi_client {
+	u32 lanes;
+	u32 phy_clock; /* in kHz */
+	enum mipi_dsi_pixel_format format;
+	unsigned long mode_flags;
+};
+
+struct mipi_panel_info {
+	u8 dsi_version;
+	u8 vc;
+	u8 lane_nums;
+	u8 lane_nums_select_support;
+	u8 color_mode;
+	u32 dsi_bit_clk; /* clock lane(p/n) */
+	u32 burst_mode;
+	u32 max_tx_esc_clk;
+	u8 non_continue_en;
+
+	u32 dsi_bit_clk_val1;
+	u32 dsi_bit_clk_val2;
+	u32 dsi_bit_clk_val3;
+	u32 dsi_bit_clk_val4;
+	u32 dsi_bit_clk_val5;
+	u32 dsi_bit_clk_upt;
+	/*uint32_t dsi_pclk_rate;*/
+
+	u32 hs_wr_to_time;
+
+	/* dphy config parameter adjust*/
+	u32 clk_post_adjust;
+	u32 clk_pre_adjust;
+	u32 clk_pre_delay_adjust;
+	u32 clk_t_hs_exit_adjust;
+	u32 clk_t_hs_trial_adjust;
+	u32 clk_t_hs_prepare_adjust;
+	int clk_t_lpx_adjust;
+	u32 clk_t_hs_zero_adjust;
+	u32 data_post_delay_adjust;
+	int data_t_lpx_adjust;
+	u32 data_t_hs_prepare_adjust;
+	u32 data_t_hs_zero_adjust;
+	u32 data_t_hs_trial_adjust;
+	u32 rg_vrefsel_vcm_adjust;
+
+	/*only for Chicago<3660> use*/
+	u32 rg_vrefsel_vcm_clk_adjust;
+	u32 rg_vrefsel_vcm_data_adjust;
+};
+
+struct ldi_panel_info {
+	u32 h_back_porch;
+	u32 h_front_porch;
+	u32 h_pulse_width;
+
+	/*
+	** note: vbp > 8 if used overlay compose,
+	** also lcd vbp > 8 in lcd power on sequence
+	*/
+	u32 v_back_porch;
+	u32 v_front_porch;
+	u32 v_pulse_width;
+
+	u8 hsync_plr;
+	u8 vsync_plr;
+	u8 pixelclk_plr;
+	u8 data_en_plr;
+
+	/* for cabc */
+	u8 dpi0_overlap_size;
+	u8 dpi1_overlap_size;
+};
+
+struct dw_dsi {
+	struct drm_encoder encoder;
+	struct drm_bridge *bridge;
+	struct drm_panel *panel;
+	struct mipi_dsi_host host;
+	struct drm_connector connector; /* connector for panel */
+	struct drm_display_mode cur_mode;
+	struct dsi_hw_ctx *ctx;
+	struct mipi_phy_params phy;
+	struct mipi_panel_info mipi;
+	struct ldi_panel_info ldi;
+	u32 lanes;
+	enum mipi_dsi_pixel_format format;
+	unsigned long mode_flags;
+	struct gpio_desc *gpio_mux;
+	struct dw_dsi_client client[OUT_MAX];
+	enum dsi_output_client cur_client;
+	bool enable;
+};
+
+struct dsi_data {
+	struct dw_dsi dsi;
+	struct dsi_hw_ctx ctx;
+};
+
+struct dsi_phy_range {
+	u32 min_range_kHz;
+	u32 max_range_kHz;
+	u32 pll_vco_750M;
+	u32 hstx_ckg_sel;
+};
+
+static const struct dsi_phy_range dphy_range_info[] = {
+	{   46875,    62500,   1,    7 },
+	{   62500,    93750,   0,    7 },
+	{   93750,   125000,   1,    6 },
+	{  125000,   187500,   0,    6 },
+	{  187500,   250000,   1,    5 },
+	{  250000,   375000,   0,    5 },
+	{  375000,   500000,   1,    4 },
+	{  500000,   750000,   0,    4 },
+	{  750000,  1000000,   1,    0 },
+	{ 1000000,  1500000,   0,    0 }
+};
+
+void dsi_set_output_client(struct drm_device *dev)
+{
+	enum dsi_output_client client;
+	struct drm_connector *connector;
+	struct drm_encoder *encoder;
+	struct dw_dsi *dsi;
+
+	mutex_lock(&dev->mode_config.mutex);
+
+	/* find dsi encoder */
+	drm_for_each_encoder(encoder, dev)
+		if (encoder->encoder_type == DRM_MODE_ENCODER_DSI)
+			break;
+	dsi = encoder_to_dsi(encoder);
+
+	/* find HDMI connector */
+	drm_for_each_connector(connector, dev)
+		if (connector->connector_type == DRM_MODE_CONNECTOR_HDMIA)
+			break;
+
+	/*
+	 * set the proper dsi output client
+	 */
+	client = connector->status == connector_status_connected ?
+		OUT_HDMI : OUT_PANEL;
+	if (client != dsi->cur_client) {
+		/* associate bridge and dsi encoder */
+		if (client == OUT_HDMI)
+			encoder->bridge = dsi->bridge;
+		else
+			encoder->bridge = NULL;
+
+		gpiod_set_value_cansleep(dsi->gpio_mux, client);
+		dsi->cur_client = client;
+		/* let the userspace know panel connector status has changed */
+		drm_sysfs_hotplug_event(dev);
+		DRM_INFO("client change to %s\n", client == OUT_HDMI ?
+				 "HDMI" : "panel");
+	}
+
+	mutex_unlock(&dev->mode_config.mutex);
+}
+EXPORT_SYMBOL(dsi_set_output_client);
+
+static void get_dsi_phy_ctrl(struct dw_dsi *dsi,
+							struct mipi_phy_params *phy_ctrl)
+{
+	struct mipi_panel_info *mipi = NULL;
+	struct drm_display_mode *mode = NULL;
+	u32 dphy_req_kHz;
+	int bpp;
+	u32 id = 0;
+	u32 ui = 0;
+	u32 m_pll = 0;
+	u32 n_pll = 0;
+	u32 m_n_fract = 0;
+	u32 m_n_int = 0;
+	u64 lane_clock = 0;
+	u64 vco_div = 1;
+
+	u32 accuracy = 0;
+	u32 unit_tx_byte_clk_hs = 0;
+	u32 clk_post = 0;
+	u32 clk_pre = 0;
+	u32 clk_t_hs_exit = 0;
+	u32 clk_pre_delay = 0;
+	u32 clk_t_hs_prepare = 0;
+	u32 clk_t_lpx = 0;
+	u32 clk_t_hs_zero = 0;
+	u32 clk_t_hs_trial = 0;
+	u32 data_post_delay = 0;
+	u32 data_t_hs_prepare = 0;
+	u32 data_t_hs_zero = 0;
+	u32 data_t_hs_trial = 0;
+	u32 data_t_lpx = 0;
+	u32 clk_pre_delay_reality = 0;
+	u32 clk_t_hs_zero_reality = 0;
+	u32 clk_post_delay_reality = 0;
+	u32 data_t_hs_zero_reality = 0;
+	u32 data_post_delay_reality = 0;
+	u32 data_pre_delay_reality = 0;
+
+	WARN_ON(!phy_ctrl);
+	WARN_ON(!dsi);
+
+	id = dsi->cur_client;
+	mode = &dsi->cur_mode;
+	mipi = &dsi->mipi;
+
+	/*
+	 * count phy params
+	 */
+	bpp = mipi_dsi_pixel_format_to_bpp(dsi->client[id].format);
+	if (bpp < 0)
+		return;
+	if (mode->clock > 80000)
+	    dsi->client[id].lanes = 4;
+	else
+	    dsi->client[id].lanes = 3;
+	if (dsi->client[id].phy_clock)
+		dphy_req_kHz = dsi->client[id].phy_clock;
+	else
+		dphy_req_kHz = mode->clock * bpp / dsi->client[id].lanes;
+
+	lane_clock = dphy_req_kHz / 1000;
+	DRM_INFO("Expected : lane_clock = %llu M\n", lane_clock);
+
+	/************************  PLL parameters config  *********************/
+	/*chip spec :
+		If the output data rate is below 320 Mbps,
+		RG_BNAD_SEL should be set to 1.
+		At this mode a post divider of 1/4 will be applied to VCO.
+	*/
+	if ((320 <= lane_clock) && (lane_clock <= 2500)) {
+		phy_ctrl->rg_band_sel = 0;	/*0x1E[2]*/
+		vco_div = 1;
+	} else if ((80 <= lane_clock) && (lane_clock < 320)) {
+		phy_ctrl->rg_band_sel = 1;
+		vco_div = 4;
+	} else {
+		DRM_ERROR("80M <= lane_clock< = 2500M, not support lane_clock = %llu M\n",
+			lane_clock);
+	}
+
+	m_n_int = lane_clock * vco_div * 1000000UL / DEFAULT_MIPI_CLK_RATE;
+	m_n_fract = ((lane_clock * vco_div * 1000000UL * 1000UL / DEFAULT_MIPI_CLK_RATE) % 1000) * 10 / 1000;
+
+	if (m_n_int % 2 == 0) {
+		if (m_n_fract * 6 >= 50) {
+			n_pll = 2;
+			m_pll = (m_n_int + 1) * n_pll;
+		} else if (m_n_fract * 6 >= 30) {
+			n_pll = 3;
+			m_pll = m_n_int * n_pll + 2;
+		} else {
+			n_pll = 1;
+			m_pll = m_n_int * n_pll;
+		}
+	} else {
+		if (m_n_fract * 6 >= 50) {
+			n_pll = 1;
+			m_pll = (m_n_int + 1) * n_pll;
+		} else if (m_n_fract * 6 >= 30) {
+			n_pll = 1;
+			m_pll = (m_n_int + 1) * n_pll;
+		} else if (m_n_fract * 6 >= 10) {
+			n_pll = 3;
+			m_pll = m_n_int * n_pll + 1;
+		} else {
+			n_pll = 2;
+			m_pll = m_n_int * n_pll;
+		}
+	}
+
+	/*if set rg_pll_enswc=1, rg_pll_fbd_s can't be 0*/
+	if (m_pll <= 8) {
+		phy_ctrl->rg_pll_fbd_s = 1;
+		phy_ctrl->rg_pll_enswc = 0;
+
+		if (m_pll % 2 == 0) {
+			phy_ctrl->rg_pll_fbd_p = m_pll / 2;
+		} else {
+			if (n_pll == 1) {
+				n_pll *= 2;
+				phy_ctrl->rg_pll_fbd_p = (m_pll  * 2) / 2;
+			} else {
+				DRM_ERROR("phy m_pll not support!m_pll = %d\n", m_pll);
+				return;
+			}
+		}
+	} else if (m_pll <= 300) {
+		if (m_pll % 2 == 0)
+			phy_ctrl->rg_pll_enswc = 0;
+		else
+			phy_ctrl->rg_pll_enswc = 1;
+
+		phy_ctrl->rg_pll_fbd_s = 1;
+		phy_ctrl->rg_pll_fbd_p = m_pll / 2;
+	} else if (m_pll <= 315) {
+		phy_ctrl->rg_pll_fbd_p = 150;
+		phy_ctrl->rg_pll_fbd_s = m_pll - 2 * phy_ctrl->rg_pll_fbd_p;
+		phy_ctrl->rg_pll_enswc = 1;
+	} else {
+		DRM_ERROR("phy m_pll not support!m_pll = %d\n", m_pll);
+		return;
+	}
+
+	phy_ctrl->rg_pll_pre_p = n_pll;
+
+	lane_clock = m_pll * (DEFAULT_MIPI_CLK_RATE / n_pll) / vco_div;
+	DRM_INFO("Config : lane_clock = %llu\n", lane_clock);
+
+	/*FIXME :*/
+	phy_ctrl->rg_pll_cp = 1;		/*0x16[7:5]*/
+	phy_ctrl->rg_pll_cp_p = 3;		/*0x1E[7:5]*/
+
+	/*test_code_0x14 other parameters config*/
+	phy_ctrl->rg_pll_enbwt = 0;	/*0x14[2]*/
+	phy_ctrl->rg_pll_chp = 0;		/*0x14[1:0]*/
+
+	/*test_code_0x16 other parameters config,  0x16[3:2] reserved*/
+	phy_ctrl->rg_pll_lpf_cs = 0;	/*0x16[4]*/
+	phy_ctrl->rg_pll_refsel = 1;		/*0x16[1:0]*/
+
+	/*test_code_0x1E other parameters config*/
+	phy_ctrl->reload_sel = 1;			/*0x1E[4]*/
+	phy_ctrl->rg_phase_gen_en = 1;	/*0x1E[3]*/
+	phy_ctrl->pll_power_down = 0;		/*0x1E[1]*/
+	phy_ctrl->pll_register_override = 1;	/*0x1E[0]*/
+
+	/*HSTX select VCM VREF*/
+	phy_ctrl->rg_vrefsel_vcm = 0x55;
+	if (mipi->rg_vrefsel_vcm_clk_adjust != 0)
+		phy_ctrl->rg_vrefsel_vcm = (phy_ctrl->rg_vrefsel_vcm & 0x0F) |
+			((mipi->rg_vrefsel_vcm_clk_adjust & 0x0F) << 4);
+
+	if (mipi->rg_vrefsel_vcm_data_adjust != 0)
+		phy_ctrl->rg_vrefsel_vcm = (phy_ctrl->rg_vrefsel_vcm & 0xF0) |
+			(mipi->rg_vrefsel_vcm_data_adjust & 0x0F);
+
+	/*if reload_sel = 1, need to set load_command*/
+	phy_ctrl->load_command = 0x5A;
+
+	/********************  clock/data lane parameters config  ******************/
+	accuracy = 10;
+	ui =  10 * 1000000000UL * accuracy / lane_clock;
+	/*unit of measurement*/
+	unit_tx_byte_clk_hs = 8 * ui;
+
+	/* D-PHY Specification : 60ns + 52*UI <= clk_post*/
+	clk_post = 600 * accuracy + 52 * ui + mipi->clk_post_adjust * ui;
+
+	/* D-PHY Specification : clk_pre >= 8*UI*/
+	clk_pre = 8 * ui + mipi->clk_pre_adjust * ui;
+
+	/* D-PHY Specification : clk_t_hs_exit >= 100ns*/
+	clk_t_hs_exit = 1000 * accuracy + mipi->clk_t_hs_exit_adjust * ui;
+
+	/* clocked by TXBYTECLKHS*/
+	clk_pre_delay = 0 + mipi->clk_pre_delay_adjust * ui;
+
+	/* D-PHY Specification : clk_t_hs_trial >= 60ns*/
+	/* clocked by TXBYTECLKHS*/
+	clk_t_hs_trial = 600 * accuracy + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_trial_adjust * ui;
+
+	/* D-PHY Specification : 38ns <= clk_t_hs_prepare <= 95ns*/
+	/* clocked by TXBYTECLKHS*/
+	if (mipi->clk_t_hs_prepare_adjust == 0)
+		mipi->clk_t_hs_prepare_adjust = 43;
+
+	clk_t_hs_prepare = ((380 * accuracy + mipi->clk_t_hs_prepare_adjust * ui) <= (950 * accuracy - 8 * ui)) ?
+		(380 * accuracy + mipi->clk_t_hs_prepare_adjust * ui) : (950 * accuracy - 8 * ui);
+
+	/* clocked by TXBYTECLKHS*/
+	data_post_delay = 0 + mipi->data_post_delay_adjust * ui;
+
+	/* D-PHY Specification : data_t_hs_trial >= max( n*8*UI, 60ns + n*4*UI ), n = 1*/
+	/* clocked by TXBYTECLKHS*/
+	data_t_hs_trial = ((600 * accuracy + 4 * ui) >= (8 * ui) ? (600 * accuracy + 4 * ui) : (8 * ui)) + 8 * ui +
+		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_trial_adjust * ui;
+
+	/* D-PHY Specification : 40ns + 4*UI <= data_t_hs_prepare <= 85ns + 6*UI*/
+	/* clocked by TXBYTECLKHS*/
+	if (mipi->data_t_hs_prepare_adjust == 0)
+		mipi->data_t_hs_prepare_adjust = 35;
+
+	data_t_hs_prepare = ((400  * accuracy + 4 * ui + mipi->data_t_hs_prepare_adjust * ui) <= (850 * accuracy + 6 * ui - 8 * ui)) ?
+		(400  * accuracy + 4 * ui + mipi->data_t_hs_prepare_adjust * ui) : (850 * accuracy + 6 * ui - 8 * ui);
+
+	/* D-PHY chip spec : clk_t_lpx + clk_t_hs_prepare > 200ns*/
+	/* D-PHY Specification : clk_t_lpx >= 50ns*/
+	/* clocked by TXBYTECLKHS*/
+	clk_t_lpx = (((2000 * accuracy - clk_t_hs_prepare) >= 500 * accuracy) ?
+		((2000 * accuracy - clk_t_hs_prepare)) : (500 * accuracy)) +
+		mipi->clk_t_lpx_adjust * ui;
+
+	/* D-PHY Specification : clk_t_hs_zero + clk_t_hs_prepare >= 300 ns*/
+	/* clocked by TXBYTECLKHS*/
+	clk_t_hs_zero = 3000 * accuracy - clk_t_hs_prepare + 3 * unit_tx_byte_clk_hs + mipi->clk_t_hs_zero_adjust * ui;
+
+	/* D-PHY chip spec : data_t_lpx + data_t_hs_prepare > 200ns*/
+	/* D-PHY Specification : data_t_lpx >= 50ns*/
+	/* clocked by TXBYTECLKHS*/
+	data_t_lpx = clk_t_lpx + mipi->data_t_lpx_adjust * ui; /*2000 * accuracy - data_t_hs_prepare;*/
+
+	/* D-PHY Specification : data_t_hs_zero + data_t_hs_prepare >= 145ns + 10*UI*/
+	/* clocked by TXBYTECLKHS*/
+	data_t_hs_zero = 1450 * accuracy + 10 * ui - data_t_hs_prepare +
+		3 * unit_tx_byte_clk_hs + mipi->data_t_hs_zero_adjust * ui;
+
+	phy_ctrl->clk_pre_delay = ROUND1(clk_pre_delay, unit_tx_byte_clk_hs);
+	phy_ctrl->clk_t_hs_prepare = ROUND1(clk_t_hs_prepare, unit_tx_byte_clk_hs);
+	phy_ctrl->clk_t_lpx = ROUND1(clk_t_lpx, unit_tx_byte_clk_hs);
+	phy_ctrl->clk_t_hs_zero = ROUND1(clk_t_hs_zero, unit_tx_byte_clk_hs);
+	phy_ctrl->clk_t_hs_trial = ROUND1(clk_t_hs_trial, unit_tx_byte_clk_hs);
+
+	phy_ctrl->data_post_delay = ROUND1(data_post_delay, unit_tx_byte_clk_hs);
+	phy_ctrl->data_t_hs_prepare = ROUND1(data_t_hs_prepare, unit_tx_byte_clk_hs);
+	phy_ctrl->data_t_lpx = ROUND1(data_t_lpx, unit_tx_byte_clk_hs);
+	phy_ctrl->data_t_hs_zero = ROUND1(data_t_hs_zero, unit_tx_byte_clk_hs);
+	phy_ctrl->data_t_hs_trial = ROUND1(data_t_hs_trial, unit_tx_byte_clk_hs);
+	phy_ctrl->data_t_ta_go = 4;
+	phy_ctrl->data_t_ta_get = 5;
+
+	clk_pre_delay_reality = phy_ctrl->clk_pre_delay + 2;
+	clk_t_hs_zero_reality = phy_ctrl->clk_t_hs_zero + 8;
+	data_t_hs_zero_reality = phy_ctrl->data_t_hs_zero + 4;
+	data_post_delay_reality = phy_ctrl->data_post_delay + 4;
+
+	phy_ctrl->clk_post_delay = phy_ctrl->data_t_hs_trial + ROUND1(clk_post, unit_tx_byte_clk_hs);
+	phy_ctrl->data_pre_delay = clk_pre_delay_reality + phy_ctrl->clk_t_lpx +
+		phy_ctrl->clk_t_hs_prepare + clk_t_hs_zero_reality + ROUND1(clk_pre, unit_tx_byte_clk_hs) ;
+
+	clk_post_delay_reality = phy_ctrl->clk_post_delay + 4;
+	data_pre_delay_reality = phy_ctrl->data_pre_delay + 2;
+
+	phy_ctrl->clk_lane_lp2hs_time = clk_pre_delay_reality + phy_ctrl->clk_t_lpx +
+		phy_ctrl->clk_t_hs_prepare + clk_t_hs_zero_reality + 3;
+	phy_ctrl->clk_lane_hs2lp_time = clk_post_delay_reality + phy_ctrl->clk_t_hs_trial + 3;
+	phy_ctrl->data_lane_lp2hs_time = data_pre_delay_reality + phy_ctrl->data_t_lpx +
+		phy_ctrl->data_t_hs_prepare + data_t_hs_zero_reality + 3;
+	phy_ctrl->data_lane_hs2lp_time = data_post_delay_reality + phy_ctrl->data_t_hs_trial + 3;
+	phy_ctrl->phy_stop_wait_time = clk_post_delay_reality +
+		phy_ctrl->clk_t_hs_trial + ROUND1(clk_t_hs_exit, unit_tx_byte_clk_hs) -
+		(data_post_delay_reality + phy_ctrl->data_t_hs_trial) + 3;
+
+	phy_ctrl->lane_byte_clk = lane_clock / 8;
+	phy_ctrl->clk_division = (((phy_ctrl->lane_byte_clk / 2) % mipi->max_tx_esc_clk) > 0) ?
+		(phy_ctrl->lane_byte_clk / 2 / mipi->max_tx_esc_clk + 1) :
+		(phy_ctrl->lane_byte_clk / 2 / mipi->max_tx_esc_clk);
+
+	DRM_INFO("PHY clock_lane and data_lane config : \n"
+		"rg_vrefsel_vcm=%u\n"
+		"clk_pre_delay=%u\n"
+		"clk_post_delay=%u\n"
+		"clk_t_hs_prepare=%u\n"
+		"clk_t_lpx=%u\n"
+		"clk_t_hs_zero=%u\n"
+		"clk_t_hs_trial=%u\n"
+		"data_pre_delay=%u\n"
+		"data_post_delay=%u\n"
+		"data_t_hs_prepare=%u\n"
+		"data_t_lpx=%u\n"
+		"data_t_hs_zero=%u\n"
+		"data_t_hs_trial=%u\n"
+		"data_t_ta_go=%u\n"
+		"data_t_ta_get=%u\n",
+		phy_ctrl->rg_vrefsel_vcm,
+		phy_ctrl->clk_pre_delay,
+		phy_ctrl->clk_post_delay,
+		phy_ctrl->clk_t_hs_prepare,
+		phy_ctrl->clk_t_lpx,
+		phy_ctrl->clk_t_hs_zero,
+		phy_ctrl->clk_t_hs_trial,
+		phy_ctrl->data_pre_delay,
+		phy_ctrl->data_post_delay,
+		phy_ctrl->data_t_hs_prepare,
+		phy_ctrl->data_t_lpx,
+		phy_ctrl->data_t_hs_zero,
+		phy_ctrl->data_t_hs_trial,
+		phy_ctrl->data_t_ta_go,
+		phy_ctrl->data_t_ta_get);
+	DRM_INFO("clk_lane_lp2hs_time=%u\n"
+		"clk_lane_hs2lp_time=%u\n"
+		"data_lane_lp2hs_time=%u\n"
+		"data_lane_hs2lp_time=%u\n"
+		"phy_stop_wait_time=%u\n",
+		phy_ctrl->clk_lane_lp2hs_time,
+		phy_ctrl->clk_lane_hs2lp_time,
+		phy_ctrl->data_lane_lp2hs_time,
+		phy_ctrl->data_lane_hs2lp_time,
+		phy_ctrl->phy_stop_wait_time);
+}
+
+static void dw_dsi_set_mode(struct dw_dsi *dsi, enum dsi_work_mode mode)
+{
+	struct dsi_hw_ctx *ctx = dsi->ctx;
+	void __iomem *base = ctx->base;
+
+	writel(RESET, base + PWR_UP);
+	writel(mode, base + MODE_CFG);
+	writel(POWERUP, base + PWR_UP);
+}
+
+static void dsi_set_burst_mode(void __iomem *base, unsigned long flags)
+{
+	u32 val;
+	u32 mode_mask = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST |
+		MIPI_DSI_MODE_VIDEO_SYNC_PULSE;
+	u32 non_burst_sync_pulse = MIPI_DSI_MODE_VIDEO |
+		MIPI_DSI_MODE_VIDEO_SYNC_PULSE;
+	u32 non_burst_sync_event = MIPI_DSI_MODE_VIDEO;
+
+	/*
+	 * choose video mode type
+	 */
+	if ((flags & mode_mask) == non_burst_sync_pulse)
+		val = DSI_NON_BURST_SYNC_PULSES;
+	else if ((flags & mode_mask) == non_burst_sync_event)
+		val = DSI_NON_BURST_SYNC_EVENTS;
+	else
+		val = DSI_BURST_SYNC_PULSES_1;
+
+	set_reg(base + MIPIDSI_VID_MODE_CFG_OFFSET, val, 2, 0);
+}
+
+/*
+ * dsi phy reg write function
+ */
+static void dsi_phy_tst_set(void __iomem *base, u32 reg, u32 val)
+{
+	u32 reg_write = 0x10000 + reg;
+
+	/*
+	 * latch reg first
+	 */
+	writel(reg_write, base + MIPIDSI_PHY_TST_CTRL1_OFFSET);
+	writel(0x02, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
+	writel(0x00, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
+
+	/*
+	 * then latch value
+	 */
+	writel(val, base + MIPIDSI_PHY_TST_CTRL1_OFFSET);
+	writel(0x02, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
+	writel(0x00, base + MIPIDSI_PHY_TST_CTRL0_OFFSET);
+}
+
+static void dsi_mipi_init(struct dw_dsi *dsi, char __iomem *mipi_dsi_base)
+{
+	u32 hline_time = 0;
+	u32 hsa_time = 0;
+	u32 hbp_time = 0;
+	u64 pixel_clk = 0;
+	u32 i = 0;
+	u32 id = 0;
+	unsigned long dw_jiffies = 0;
+	u32 tmp = 0;
+	bool is_ready = false;
+	struct mipi_panel_info *mipi = NULL;
+	dss_rect_t rect;
+	u32 cmp_stopstate_val = 0;
+	u32 lanes;
+
+	WARN_ON(!dsi);
+	WARN_ON(!mipi_dsi_base);
+
+	id = dsi->cur_client;
+	mipi = &dsi->mipi;
+
+	if (mipi->max_tx_esc_clk == 0) {
+		DRM_INFO("max_tx_esc_clk is invalid!");
+		mipi->max_tx_esc_clk = DEFAULT_MAX_TX_ESC_CLK;
+	}
+
+	memset(&dsi->phy, 0, sizeof(struct mipi_phy_params));
+	get_dsi_phy_ctrl(dsi, &dsi->phy);
+
+	rect.x = 0;
+	rect.y = 0;
+	rect.w = dsi->cur_mode.hdisplay;
+	rect.h = dsi->cur_mode.vdisplay;
+	lanes = dsi->client[id].lanes - 1;
+	/***************Configure the DPHY start**************/
+
+	set_reg(mipi_dsi_base + MIPIDSI_PHY_IF_CFG_OFFSET, lanes, 2, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_CLKMGR_CFG_OFFSET, dsi->phy.clk_division, 8, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_CLKMGR_CFG_OFFSET, dsi->phy.clk_division, 8, 8);
+
+	outp32(mipi_dsi_base + MIPIDSI_PHY_RSTZ_OFFSET, 0x00000000);
+
+	outp32(mipi_dsi_base + MIPIDSI_PHY_TST_CTRL0_OFFSET, 0x00000000);
+	outp32(mipi_dsi_base + MIPIDSI_PHY_TST_CTRL0_OFFSET, 0x00000001);
+	outp32(mipi_dsi_base + MIPIDSI_PHY_TST_CTRL0_OFFSET, 0x00000000);
+
+	/* physical configuration PLL I*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x14,
+		(dsi->phy.rg_pll_fbd_s << 4) + (dsi->phy.rg_pll_enswc << 3) +
+		(dsi->phy.rg_pll_enbwt << 2) + dsi->phy.rg_pll_chp);
+
+	/* physical configuration PLL II, M*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x15, dsi->phy.rg_pll_fbd_p);
+
+	/* physical configuration PLL III*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x16,
+		(dsi->phy.rg_pll_cp << 5) + (dsi->phy.rg_pll_lpf_cs << 4) +
+		dsi->phy.rg_pll_refsel);
+
+	/* physical configuration PLL IV, N*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x17, dsi->phy.rg_pll_pre_p);
+
+	/* sets the analog characteristic of V reference in D-PHY TX*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x1D, dsi->phy.rg_vrefsel_vcm);
+
+	/* MISC AFE Configuration*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x1E,
+		(dsi->phy.rg_pll_cp_p << 5) + (dsi->phy.reload_sel << 4) +
+		(dsi->phy.rg_phase_gen_en << 3) + (dsi->phy.rg_band_sel << 2) +
+		(dsi->phy.pll_power_down << 1) + dsi->phy.pll_register_override);
+
+	/*reload_command*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x1F, dsi->phy.load_command);
+
+	/* pre_delay of clock lane request setting*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x20, DSS_REDUCE(dsi->phy.clk_pre_delay));
+
+	/* post_delay of clock lane request setting*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x21, DSS_REDUCE(dsi->phy.clk_post_delay));
+
+	/* clock lane timing ctrl - t_lpx*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x22, DSS_REDUCE(dsi->phy.clk_t_lpx));
+
+	/* clock lane timing ctrl - t_hs_prepare*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x23, DSS_REDUCE(dsi->phy.clk_t_hs_prepare));
+
+	/* clock lane timing ctrl - t_hs_zero*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x24, DSS_REDUCE(dsi->phy.clk_t_hs_zero));
+
+	/* clock lane timing ctrl - t_hs_trial*/
+	dsi_phy_tst_set(mipi_dsi_base, 0x25, dsi->phy.clk_t_hs_trial);
+
+	for (i = 0; i <= lanes; i++) {
+		/* data lane pre_delay*/
+		tmp = 0x30 + (i << 4);
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_pre_delay));
+
+		/*data lane post_delay*/
+		tmp = 0x31 + (i << 4);
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_post_delay));
+
+		/* data lane timing ctrl - t_lpx*/
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_lpx));
+
+		/* data lane timing ctrl - t_hs_prepare*/
+		tmp = 0x33 + (i << 4);
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_prepare));
+
+		/* data lane timing ctrl - t_hs_zero*/
+		tmp = 0x34 + (i << 4);
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_zero));
+
+		/* data lane timing ctrl - t_hs_trial*/
+		tmp = 0x35 + (i << 4);
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_hs_trial));
+
+		/* data lane timing ctrl - t_ta_go*/
+		tmp = 0x36 + (i << 4);
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_ta_go));
+
+		/* data lane timing ctrl - t_ta_get*/
+		tmp = 0x37 + (i << 4);
+		dsi_phy_tst_set(mipi_dsi_base, tmp, DSS_REDUCE(dsi->phy.data_t_ta_get));
+	}
+
+	outp32(mipi_dsi_base + MIPIDSI_PHY_RSTZ_OFFSET, 0x00000007);
+
+	is_ready = false;
+	dw_jiffies = jiffies + HZ / 2;
+	do {
+		tmp = inp32(mipi_dsi_base + MIPIDSI_PHY_STATUS_OFFSET);
+		if ((tmp & 0x00000001) == 0x00000001) {
+			is_ready = true;
+			break;
+		}
+	} while (time_after(dw_jiffies, jiffies));
+
+	if (!is_ready) {
+		DRM_INFO("phylock is not ready!MIPIDSI_PHY_STATUS_OFFSET=0x%x.\n",
+			tmp);
+	}
+
+	if (lanes >= DSI_4_LANES)
+		cmp_stopstate_val = (BIT(4) | BIT(7) | BIT(9) | BIT(11));
+	else if (lanes >= DSI_3_LANES)
+		cmp_stopstate_val = (BIT(4) | BIT(7) | BIT(9));
+	else if (lanes >= DSI_2_LANES)
+		cmp_stopstate_val = (BIT(4) | BIT(7));
+	else
+		cmp_stopstate_val = (BIT(4));
+
+	is_ready = false;
+	dw_jiffies = jiffies + HZ / 2;
+	do {
+		tmp = inp32(mipi_dsi_base + MIPIDSI_PHY_STATUS_OFFSET);
+		if ((tmp & cmp_stopstate_val) == cmp_stopstate_val) {
+			is_ready = true;
+			break;
+		}
+	} while (time_after(dw_jiffies, jiffies));
+
+	if (!is_ready) {
+		DRM_INFO("phystopstateclklane is not ready! MIPIDSI_PHY_STATUS_OFFSET=0x%x.\n",
+			tmp);
+	}
+
+	/*************************Configure the DPHY end*************************/
+
+	/* phy_stop_wait_time*/
+	set_reg(mipi_dsi_base + MIPIDSI_PHY_IF_CFG_OFFSET, dsi->phy.phy_stop_wait_time, 8, 8);
+
+	/*--------------configuring the DPI packet transmission----------------*/
+	/*
+	** 2. Configure the DPI Interface:
+	** This defines how the DPI interface interacts with the controller.
+	*/
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_VCID_OFFSET, mipi->vc, 2, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_COLOR_CODING_OFFSET, mipi->color_mode, 4, 0);
+
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, dsi->ldi.data_en_plr, 1, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, dsi->ldi.vsync_plr, 1, 1);
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, dsi->ldi.hsync_plr, 1, 2);
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, 0x0, 1, 3);
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_CFG_POL_OFFSET, 0x0, 1, 4);
+
+	/*
+	** 3. Select the Video Transmission Mode:
+	** This defines how the processor requires the video line to be
+	** transported through the DSI link.
+	*/
+	/* video mode: low power mode*/
+	set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x3f, 6, 8);
+	/* set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x0, 1, 14); */
+
+	/* TODO: fix blank display bug when set backlight*/
+	set_reg(mipi_dsi_base + MIPIDSI_DPI_LP_CMD_TIM_OFFSET, 0x4, 8, 16);
+	/* video mode: send read cmd by lp mode*/
+	set_reg(mipi_dsi_base + MIPIDSI_VID_MODE_CFG_OFFSET, 0x1, 1, 15);
+
+	set_reg(mipi_dsi_base + MIPIDSI_VID_PKT_SIZE_OFFSET, rect.w, 14, 0);
+
+	/* burst mode*/
+	dsi_set_burst_mode(mipi_dsi_base, dsi->client[id].mode_flags);
+	/* for dsi read, BTA enable*/
+	set_reg(mipi_dsi_base + MIPIDSI_PCKHDL_CFG_OFFSET, 0x1, 1, 2);
+
+	/*
+	** 4. Define the DPI Horizontal timing configuration:
+	**
+	** Hsa_time = HSA*(PCLK period/Clk Lane Byte Period);
+	** Hbp_time = HBP*(PCLK period/Clk Lane Byte Period);
+	** Hline_time = (HSA+HBP+HACT+HFP)*(PCLK period/Clk Lane Byte Period);
+	*/
+	pixel_clk = dsi->cur_mode.clock * 1000;
+	/*htot = dsi->cur_mode.htotal;*/
+	/*vtot = dsi->cur_mode.vtotal;*/
+	dsi->ldi.h_front_porch = dsi->cur_mode.hsync_start - dsi->cur_mode.hdisplay;
+	dsi->ldi.h_back_porch = dsi->cur_mode.htotal - dsi->cur_mode.hsync_end;
+	dsi->ldi.h_pulse_width = dsi->cur_mode.hsync_end - dsi->cur_mode.hsync_start;
+	dsi->ldi.v_front_porch = dsi->cur_mode.vsync_start - dsi->cur_mode.vdisplay;
+	dsi->ldi.v_back_porch = dsi->cur_mode.vtotal - dsi->cur_mode.vsync_end;
+	dsi->ldi.v_pulse_width = dsi->cur_mode.vsync_end - dsi->cur_mode.vsync_start;
+	if (dsi->ldi.v_pulse_width > 15) {
+		DRM_DEBUG_DRIVER("vsw exceeded 15\n");
+		dsi->ldi.v_pulse_width = 15;
+	}
+	hsa_time = dsi->ldi.h_pulse_width * dsi->phy.lane_byte_clk / pixel_clk;
+	hbp_time = dsi->ldi.h_back_porch * dsi->phy.lane_byte_clk / pixel_clk;
+	hline_time = ROUND1((dsi->ldi.h_pulse_width + dsi->ldi.h_back_porch +
+		rect.w + dsi->ldi.h_front_porch) * dsi->phy.lane_byte_clk, pixel_clk);
+
+	DRM_INFO("hsa_time=%d, hbp_time=%d, hline_time=%d\n",
+	    hsa_time, hbp_time, hline_time);
+	DRM_INFO("lane_byte_clk=%llu, pixel_clk=%llu\n",
+	    dsi->phy.lane_byte_clk, pixel_clk);
+	set_reg(mipi_dsi_base + MIPIDSI_VID_HSA_TIME_OFFSET, hsa_time, 12, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_VID_HBP_TIME_OFFSET, hbp_time, 12, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_VID_HLINE_TIME_OFFSET, hline_time, 15, 0);
+
+	/* Define the Vertical line configuration*/
+	set_reg(mipi_dsi_base + MIPIDSI_VID_VSA_LINES_OFFSET, dsi->ldi.v_pulse_width, 10, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_VID_VBP_LINES_OFFSET, dsi->ldi.v_back_porch, 10, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_VID_VFP_LINES_OFFSET, dsi->ldi.v_front_porch, 10, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_VID_VACTIVE_LINES_OFFSET, rect.h, 14, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_TO_CNT_CFG_OFFSET, 0x7FF, 16, 0);
+
+	/* Configure core's phy parameters*/
+	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_LPCLK_CFG_OFFSET, dsi->phy.clk_lane_lp2hs_time, 10, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_LPCLK_CFG_OFFSET, dsi->phy.clk_lane_hs2lp_time, 10, 16);
+
+	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_RD_CFG_OFFSET, 0x7FFF, 15, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_CFG_OFFSET, dsi->phy.data_lane_lp2hs_time, 10, 0);
+	set_reg(mipi_dsi_base + MIPIDSI_PHY_TMR_CFG_OFFSET, dsi->phy.data_lane_hs2lp_time, 10, 16);
+
+	/* Waking up Core*/
+	set_reg(mipi_dsi_base + MIPIDSI_PWR_UP_OFFSET, 0x1, 1, 0);
+}
+
+static void dsi_encoder_disable(struct drm_encoder *encoder)
+{
+	struct dw_dsi *dsi = encoder_to_dsi(encoder);
+	struct dsi_hw_ctx *ctx = dsi->ctx;
+	void __iomem *base = ctx->base;
+
+	if (!dsi->enable)
+		return;
+
+	dw_dsi_set_mode(dsi, DSI_COMMAND_MODE);
+	/* turn off panel's backlight */
+	if (dsi->panel && drm_panel_disable(dsi->panel))
+		DRM_ERROR("failed to disable panel\n");
+
+	/* turn off panel */
+	if (dsi->panel && drm_panel_unprepare(dsi->panel))
+		DRM_ERROR("failed to unprepare panel\n");
+
+	writel(0, base + PWR_UP);
+	writel(0, base + LPCLK_CTRL);
+	writel(0, base + PHY_RSTZ);
+	clk_disable_unprepare(ctx->dss_dphy0_ref_clk);
+	clk_disable_unprepare(ctx->dss_dphy0_cfg_clk);
+	clk_disable_unprepare(ctx->dss_pclk_dsi0_clk);
+
+	dsi->enable = false;
+}
+
+static int mipi_dsi_on_sub1(struct dw_dsi *dsi, char __iomem *mipi_dsi_base)
+{
+	WARN_ON(!mipi_dsi_base);
+
+	/* mipi init */
+	dsi_mipi_init(dsi, mipi_dsi_base);
+	DRM_INFO("dsi_mipi_init ok\n");
+	/* switch to cmd mode */
+	set_reg(mipi_dsi_base + MIPIDSI_MODE_CFG_OFFSET, 0x1, 1, 0);
+	/* cmd mode: low power mode */
+	set_reg(mipi_dsi_base + MIPIDSI_CMD_MODE_CFG_OFFSET, 0x7f, 7, 8);
+	set_reg(mipi_dsi_base + MIPIDSI_CMD_MODE_CFG_OFFSET, 0xf, 4, 16);
+	set_reg(mipi_dsi_base + MIPIDSI_CMD_MODE_CFG_OFFSET, 0x1, 1, 24);
+	/* disable generate High Speed clock */
+	/* delete? */
+	set_reg(mipi_dsi_base + MIPIDSI_LPCLK_CTRL_OFFSET, 0x0, 1, 0);
+
+	return 0;
+}
+
+static int mipi_dsi_on_sub2(struct dw_dsi *dsi, char __iomem *mipi_dsi_base)
+{
+	WARN_ON(!mipi_dsi_base);
+
+	/* switch to video mode */
+	set_reg(mipi_dsi_base + MIPIDSI_MODE_CFG_OFFSET, 0x0, 1, 0);
+
+	/* enable EOTP TX */
+	set_reg(mipi_dsi_base + MIPIDSI_PCKHDL_CFG_OFFSET, 0x1, 1, 0);
+
+	/* enable generate High Speed clock, continue clock */
+	set_reg(mipi_dsi_base + MIPIDSI_LPCLK_CTRL_OFFSET, 0x1, 2, 0);
+
+	return 0;
+}
+
+static void dsi_encoder_enable(struct drm_encoder *encoder)
+{
+	struct dw_dsi *dsi = encoder_to_dsi(encoder);
+	struct dsi_hw_ctx *ctx = dsi->ctx;
+	int ret;
+
+	if (dsi->enable)
+		return;
+
+	ret = clk_prepare_enable(ctx->dss_dphy0_ref_clk);
+	if (ret) {
+		DRM_ERROR("fail to enable dss_dphy0_ref_clk: %d\n", ret);
+		return;
+	}
+
+	ret = clk_prepare_enable(ctx->dss_dphy0_cfg_clk);
+	if (ret) {
+		DRM_ERROR("fail to enable dss_dphy0_cfg_clk: %d\n", ret);
+		return;
+	}
+
+	ret = clk_prepare_enable(ctx->dss_pclk_dsi0_clk);
+	if (ret) {
+		DRM_ERROR("fail to enable dss_pclk_dsi0_clk: %d\n", ret);
+		return;
+	}
+
+	mipi_dsi_on_sub1(dsi, ctx->base);
+
+	mipi_dsi_on_sub2(dsi, ctx->base);
+
+	/* turn on panel */
+	if (dsi->panel && drm_panel_prepare(dsi->panel))
+		DRM_ERROR("failed to prepare panel\n");
+
+	/*dw_dsi_set_mode(dsi, DSI_VIDEO_MODE);*/
+
+	/* turn on panel's back light */
+	if (dsi->panel && drm_panel_enable(dsi->panel))
+		DRM_ERROR("failed to enable panel\n");
+
+	dsi->enable = true;
+}
+
+static void dsi_encoder_mode_set(struct drm_encoder *encoder,
+				 struct drm_display_mode *mode,
+				 struct drm_display_mode *adj_mode)
+{
+	struct dw_dsi *dsi = encoder_to_dsi(encoder);
+
+	drm_mode_copy(&dsi->cur_mode, adj_mode);
+}
+
+static int dsi_encoder_atomic_check(struct drm_encoder *encoder,
+				    struct drm_crtc_state *crtc_state,
+				    struct drm_connector_state *conn_state)
+{
+	/* do nothing */
+	return 0;
+}
+
+static const struct drm_encoder_helper_funcs dw_encoder_helper_funcs = {
+	.atomic_check	= dsi_encoder_atomic_check,
+	.mode_set	= dsi_encoder_mode_set,
+	.enable		= dsi_encoder_enable,
+	.disable	= dsi_encoder_disable
+};
+
+static const struct drm_encoder_funcs dw_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+static int dw_drm_encoder_init(struct device *dev,
+			       struct drm_device *drm_dev,
+			       struct drm_encoder *encoder)
+{
+	int ret;
+	u32 crtc_mask = drm_of_find_possible_crtcs(drm_dev, dev->of_node);
+
+	if (!crtc_mask) {
+		DRM_ERROR("failed to find crtc mask\n");
+		return -EINVAL;
+	}
+
+	encoder->possible_crtcs = crtc_mask;
+	ret = drm_encoder_init(drm_dev, encoder, &dw_encoder_funcs,
+			       DRM_MODE_ENCODER_DSI);
+	if (ret) {
+		DRM_ERROR("failed to init dsi encoder\n");
+		return ret;
+	}
+
+	drm_encoder_helper_add(encoder, &dw_encoder_helper_funcs);
+
+	return 0;
+}
+
+static int dsi_host_attach(struct mipi_dsi_host *host,
+			   struct mipi_dsi_device *mdsi)
+{
+	struct dw_dsi *dsi = host_to_dsi(host);
+	u32 id = mdsi->channel >= 1 ? OUT_PANEL : OUT_HDMI;
+
+	if (mdsi->lanes < 1 || mdsi->lanes > 4) {
+		DRM_ERROR("dsi device params invalid\n");
+		return -EINVAL;
+	}
+
+	dsi->client[id].lanes = mdsi->lanes;
+	dsi->client[id].format = mdsi->format;
+	dsi->client[id].mode_flags = mdsi->mode_flags;
+	dsi->client[id].phy_clock = mdsi->phy_clock;
+
+	DRM_INFO("host attach, client name=[%s], id=%d\n", mdsi->name, id);
+
+	return 0;
+}
+
+static int dsi_host_detach(struct mipi_dsi_host *host,
+			   struct mipi_dsi_device *mdsi)
+{
+	/* do nothing */
+	return 0;
+}
+
+static int dsi_gen_pkt_hdr_write(void __iomem *base, u32 val)
+{
+	u32 status;
+	int ret;
+
+	ret = readx_poll_timeout(readl, base + CMD_PKT_STATUS, status,
+				 !(status & GEN_CMD_FULL), 1000,
+				 CMD_PKT_STATUS_TIMEOUT_US);
+	if (ret < 0) {
+		DRM_ERROR("failed to get available command FIFO\n");
+		return ret;
+	}
+
+	writel(val, base + GEN_HDR);
+
+	ret = readx_poll_timeout(readl, base + CMD_PKT_STATUS, status,
+				 status & (GEN_CMD_EMPTY | GEN_PLD_W_EMPTY),
+				 1000, CMD_PKT_STATUS_TIMEOUT_US);
+	if (ret < 0) {
+		DRM_ERROR("failed to write command FIFO\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int dsi_dcs_short_write(void __iomem *base,
+			       const struct mipi_dsi_msg *msg)
+{
+	const u16 *tx_buf = msg->tx_buf;
+	u32 val = GEN_HDATA(*tx_buf) | GEN_HTYPE(msg->type);
+
+	if (msg->tx_len > 2) {
+		DRM_ERROR("too long tx buf length %zu for short write\n",
+			  msg->tx_len);
+		return -EINVAL;
+	}
+
+	return dsi_gen_pkt_hdr_write(base, val);
+}
+
+static int dsi_dcs_long_write(void __iomem *base,
+			      const struct mipi_dsi_msg *msg)
+{
+	const u32 *tx_buf = msg->tx_buf;
+	int len = msg->tx_len, pld_data_bytes = sizeof(*tx_buf), ret;
+	u32 val = GEN_HDATA(msg->tx_len) | GEN_HTYPE(msg->type);
+	u32 remainder = 0;
+	u32 status;
+
+	if (msg->tx_len < 3) {
+		DRM_ERROR("wrong tx buf length %zu for long write\n",
+			  msg->tx_len);
+		return -EINVAL;
+	}
+
+	while (DIV_ROUND_UP(len, pld_data_bytes)) {
+		if (len < pld_data_bytes) {
+			memcpy(&remainder, tx_buf, len);
+			writel(remainder, base + GEN_PLD_DATA);
+			len = 0;
+		} else {
+			writel(*tx_buf, base + GEN_PLD_DATA);
+			tx_buf++;
+			len -= pld_data_bytes;
+		}
+
+		ret = readx_poll_timeout(readl, base + CMD_PKT_STATUS,
+					 status, !(status & GEN_PLD_W_FULL), 1000,
+					 CMD_PKT_STATUS_TIMEOUT_US);
+		if (ret < 0) {
+			DRM_ERROR("failed to get available write payload FIFO\n");
+			return ret;
+		}
+	}
+
+	return dsi_gen_pkt_hdr_write(base, val);
+}
+
+static ssize_t dsi_host_transfer(struct mipi_dsi_host *host,
+				    const struct mipi_dsi_msg *msg)
+{
+	struct dw_dsi *dsi = host_to_dsi(host);
+	struct dsi_hw_ctx *ctx = dsi->ctx;
+	void __iomem *base = ctx->base;
+	int ret;
+
+	switch (msg->type) {
+	case MIPI_DSI_DCS_SHORT_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
+	case MIPI_DSI_SET_MAXIMUM_RETURN_PACKET_SIZE:
+		ret = dsi_dcs_short_write(base, msg);
+		break;
+	case MIPI_DSI_DCS_LONG_WRITE:
+		ret = dsi_dcs_long_write(base, msg);
+		break;
+	default:
+		DRM_ERROR("unsupported message type\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct mipi_dsi_host_ops dsi_host_ops = {
+	.attach = dsi_host_attach,
+	.detach = dsi_host_detach,
+	.transfer = dsi_host_transfer,
+};
+
+static int dsi_host_init(struct device *dev, struct dw_dsi *dsi)
+{
+	struct mipi_dsi_host *host = &dsi->host;
+	struct mipi_panel_info *mipi = &dsi->mipi;
+	int ret;
+
+	host->dev = dev;
+	host->ops = &dsi_host_ops;
+
+	mipi->max_tx_esc_clk = 10;
+	mipi->vc = 0;
+	mipi->color_mode = DSI_24BITS_1;
+	mipi->clk_post_adjust = 120;
+	mipi->clk_pre_adjust= 0;
+	mipi->clk_t_hs_prepare_adjust= 0;
+	mipi->clk_t_lpx_adjust= 0;
+	mipi->clk_t_hs_trial_adjust= 0;
+	mipi->clk_t_hs_exit_adjust= 0;
+	mipi->clk_t_hs_zero_adjust= 0;
+
+	dsi->ldi.data_en_plr = 0;
+	dsi->ldi.vsync_plr = 0;
+	dsi->ldi.hsync_plr = 0;
+
+	ret = mipi_dsi_host_register(host);
+	if (ret) {
+		DRM_ERROR("failed to register dsi host\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int dsi_bridge_init(struct drm_device *dev, struct dw_dsi *dsi)
+{
+	struct drm_encoder *encoder = &dsi->encoder;
+	struct drm_bridge *bridge = dsi->bridge;
+	int ret;
+
+	/* associate the bridge to dsi encoder */
+	bridge->encoder = encoder;
+
+	ret = drm_bridge_attach(dev, bridge);
+	if (ret) {
+		DRM_ERROR("failed to attach external bridge\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int dsi_connector_get_modes(struct drm_connector *connector)
+{
+	struct dw_dsi *dsi = connector_to_dsi(connector);
+
+	return drm_panel_get_modes(dsi->panel);
+}
+
+static enum drm_mode_status
+dsi_connector_mode_valid(struct drm_connector *connector,
+			 struct drm_display_mode *mode)
+{
+	enum drm_mode_status mode_status = MODE_OK;
+
+	return mode_status;
+}
+
+static struct drm_encoder *
+dsi_connector_best_encoder(struct drm_connector *connector)
+{
+	struct dw_dsi *dsi = connector_to_dsi(connector);
+
+	return &dsi->encoder;
+}
+
+static struct drm_connector_helper_funcs dsi_connector_helper_funcs = {
+	.get_modes = dsi_connector_get_modes,
+	.mode_valid = dsi_connector_mode_valid,
+	.best_encoder = dsi_connector_best_encoder,
+};
+
+static enum drm_connector_status
+dsi_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct dw_dsi *dsi = connector_to_dsi(connector);
+	enum drm_connector_status status;
+
+	status = dsi->cur_client == OUT_PANEL ?	connector_status_connected :
+		connector_status_disconnected;
+
+	return status;
+}
+
+static void dsi_connector_destroy(struct drm_connector *connector)
+{
+	drm_connector_unregister(connector);
+	drm_connector_cleanup(connector);
+}
+
+static struct drm_connector_funcs dsi_atomic_connector_funcs = {
+	.dpms = drm_atomic_helper_connector_dpms,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.detect = dsi_connector_detect,
+	.destroy = dsi_connector_destroy,
+	.reset = drm_atomic_helper_connector_reset,
+	.atomic_duplicate_state = drm_atomic_helper_connector_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_connector_destroy_state,
+};
+
+static int dsi_connector_init(struct drm_device *dev, struct dw_dsi *dsi)
+{
+	struct drm_encoder *encoder = &dsi->encoder;
+	struct drm_connector *connector = &dsi->connector;
+	int ret;
+
+	connector->polled = DRM_CONNECTOR_POLL_HPD;
+	drm_connector_helper_add(connector,
+				 &dsi_connector_helper_funcs);
+
+	ret = drm_connector_init(dev, &dsi->connector,
+				 &dsi_atomic_connector_funcs,
+				 DRM_MODE_CONNECTOR_DSI);
+	if (ret)
+		return ret;
+
+	ret = drm_mode_connector_attach_encoder(connector, encoder);
+	if (ret)
+		return ret;
+
+	ret = drm_panel_attach(dsi->panel, connector);
+	if (ret)
+		return ret;
+
+	DRM_INFO("connector init\n");
+	return 0;
+}
+static int dsi_bind(struct device *dev, struct device *master, void *data)
+{
+	struct dsi_data *ddata = dev_get_drvdata(dev);
+	struct dw_dsi *dsi = &ddata->dsi;
+	struct drm_device *drm_dev = data;
+	int ret;
+
+	ret = dw_drm_encoder_init(dev, drm_dev, &dsi->encoder);
+	if (ret)
+		return ret;
+
+	if (dsi->bridge) {
+		ret = dsi_bridge_init(drm_dev, dsi);
+		if (ret)
+			return ret;
+	}
+
+	if (dsi->panel) {
+		ret = dsi_connector_init(drm_dev, dsi);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void dsi_unbind(struct device *dev, struct device *master, void *data)
+{
+	/* do nothing */
+}
+
+static const struct component_ops dsi_ops = {
+	.bind	= dsi_bind,
+	.unbind	= dsi_unbind,
+};
+
+static int dsi_parse_bridge_endpoint(struct dw_dsi *dsi,
+				     struct device_node *endpoint)
+{
+	struct device_node *bridge_node;
+	struct drm_bridge *bridge;
+
+	bridge_node = of_graph_get_remote_port_parent(endpoint);
+	if (!bridge_node) {
+		DRM_ERROR("no valid bridge node\n");
+		return -ENODEV;
+	}
+	of_node_put(bridge_node);
+
+	bridge = of_drm_find_bridge(bridge_node);
+	if (!bridge) {
+		DRM_INFO("wait for external HDMI bridge driver.\n");
+		return -EPROBE_DEFER;
+	}
+	dsi->bridge = bridge;
+
+	return 0;
+}
+
+static int dsi_parse_panel_endpoint(struct dw_dsi *dsi,
+				    struct device_node *endpoint)
+{
+	struct device_node *panel_node;
+	struct drm_panel *panel;
+
+	panel_node = of_graph_get_remote_port_parent(endpoint);
+	if (!panel_node) {
+		DRM_ERROR("no valid panel node\n");
+		return -ENODEV;
+	}
+	of_node_put(panel_node);
+
+	panel = of_drm_find_panel(panel_node);
+	if (!panel) {
+		DRM_DEBUG_DRIVER("skip this panel endpoint.\n");
+		return 0;
+	}
+	dsi->panel = panel;
+
+	return 0;
+}
+
+static int dsi_parse_endpoint(struct dw_dsi *dsi,
+			      struct device_node *np,
+			      enum dsi_output_client client)
+{
+	struct device_node *ep_node;
+	struct of_endpoint ep;
+	int ret = 0;
+
+	if (client == OUT_MAX)
+		return -EINVAL;
+
+	for_each_endpoint_of_node(np, ep_node) {
+		ret = of_graph_parse_endpoint(ep_node, &ep);
+		if (ret) {
+			of_node_put(ep_node);
+			return ret;
+		}
+
+		/* skip dsi input port, port == 0 is input port */
+		if (ep.port == 0)
+			continue;
+
+		/* parse bridge endpoint */
+		if (client == OUT_HDMI) {
+			if (ep.id == 0) {
+				ret = dsi_parse_bridge_endpoint(dsi, ep_node);
+				if (dsi->bridge)
+					break;
+			}
+		} else { /* parse panel endpoint */
+			if (ep.id > 0) {
+				ret = dsi_parse_panel_endpoint(dsi, ep_node);
+				if (dsi->panel)
+					break;
+			}
+		}
+
+		if (ret) {
+			of_node_put(ep_node);
+			return ret;
+		}
+	}
+
+	if (!dsi->bridge && !dsi->panel) {
+		DRM_ERROR("at least one bridge or panel node is required\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int dsi_parse_dt(struct platform_device *pdev, struct dw_dsi *dsi)
+{
+	struct dsi_hw_ctx *ctx = dsi->ctx;
+	int ret = 0;
+	struct device_node *np = NULL;
+
+	np = of_find_compatible_node(NULL, NULL, DTS_COMP_DSI_NAME);
+	if (!np) {
+			DRM_ERROR("NOT FOUND device node %s!\n",
+				    DTS_COMP_DSI_NAME);
+			return -ENXIO;
+	}
+
+	ctx->base = of_iomap(np, 0);
+	if (!(ctx->base)) {
+			DRM_ERROR ("failed to get base resource.\n");
+			return -ENXIO;
+	}
+
+	ctx->peri_crg_base = of_iomap(np, 1);
+	if (!(ctx->peri_crg_base)) {
+			DRM_ERROR ("failed to get peri_crg_base resource.\n");
+			return -ENXIO;
+	}
+
+	dsi->gpio_mux = devm_gpiod_get(&pdev->dev, "mux", GPIOD_OUT_HIGH);
+	if (IS_ERR(dsi->gpio_mux))
+		return PTR_ERR(dsi->gpio_mux);
+	/* set dsi default output to panel */
+	dsi->cur_client = OUT_PANEL;
+
+	/*dis-reset*/
+	/*ip_reset_dis_dsi0, ip_reset_dis_dsi1*/
+	outp32(ctx->peri_crg_base + PERRSTDIS3, 0x30000000);
+
+	ctx->dss_dphy0_ref_clk = devm_clk_get(&pdev->dev, "clk_txdphy0_ref");
+	if (IS_ERR(ctx->dss_dphy0_ref_clk)) {
+		DRM_ERROR("failed to get dss_dphy0_ref_clk clock\n");
+		return PTR_ERR(ctx->dss_dphy0_ref_clk);
+	}
+
+	ret = clk_set_rate(ctx->dss_dphy0_ref_clk, DEFAULT_MIPI_CLK_RATE);
+	if (ret < 0) {
+		DRM_ERROR("dss_dphy0_ref_clk clk_set_rate(%lu) failed, error=%d!\n",
+			DEFAULT_MIPI_CLK_RATE, ret);
+		return -EINVAL;
+	}
+
+	DRM_DEBUG("dss_dphy0_ref_clk:[%lu]->[%lu].\n",
+		DEFAULT_MIPI_CLK_RATE, clk_get_rate(ctx->dss_dphy0_ref_clk));
+
+	ctx->dss_dphy0_cfg_clk = devm_clk_get(&pdev->dev, "clk_txdphy0_cfg");
+	if (IS_ERR(ctx->dss_dphy0_cfg_clk)) {
+		DRM_ERROR("failed to get dss_dphy0_cfg_clk clock\n");
+		return PTR_ERR(ctx->dss_dphy0_cfg_clk);
+	}
+
+	ret = clk_set_rate(ctx->dss_dphy0_cfg_clk, DEFAULT_MIPI_CLK_RATE);
+	if (ret < 0) {
+		DRM_ERROR("dss_dphy0_cfg_clk clk_set_rate(%lu) failed, error=%d!\n",
+			DEFAULT_MIPI_CLK_RATE, ret);
+		return -EINVAL;
+	}
+
+	DRM_DEBUG("dss_dphy0_cfg_clk:[%lu]->[%lu].\n",
+		DEFAULT_MIPI_CLK_RATE, clk_get_rate(ctx->dss_dphy0_cfg_clk));
+
+	ctx->dss_pclk_dsi0_clk = devm_clk_get(&pdev->dev, "pclk_dsi0");
+	if (IS_ERR(ctx->dss_pclk_dsi0_clk)) {
+		DRM_ERROR("failed to get dss_pclk_dsi0_clk clock\n");
+		return PTR_ERR(ctx->dss_pclk_dsi0_clk);
+	}
+
+	return 0;
+}
+
+static int dsi_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct dsi_data *data;
+	struct dw_dsi *dsi;
+	struct dsi_hw_ctx *ctx;
+	int ret;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data) {
+		DRM_ERROR("failed to allocate dsi data.\n");
+		return -ENOMEM;
+	}
+	dsi = &data->dsi;
+	ctx = &data->ctx;
+	dsi->ctx = ctx;
+
+	/* parse HDMI bridge endpoint */
+	ret = dsi_parse_endpoint(dsi, np, OUT_HDMI);
+	if (ret)
+		return ret;
+
+	ret = dsi_host_init(dev, dsi);
+	if (ret)
+		return ret;
+
+	/* parse panel endpoint */
+	ret = dsi_parse_endpoint(dsi, np, OUT_PANEL);
+	if (ret)
+		goto err_host_unregister;
+
+	ret = dsi_parse_dt(pdev, dsi);
+	if (ret)
+		goto err_host_unregister;
+
+	platform_set_drvdata(pdev, data);
+
+	ret = component_add(dev, &dsi_ops);
+	if (ret)
+		goto err_host_unregister;
+
+	return 0;
+
+err_host_unregister:
+	mipi_dsi_host_unregister(&dsi->host);
+	return ret;
+}
+
+static int dsi_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &dsi_ops);
+
+	return 0;
+}
+
+static const struct of_device_id dsi_of_match[] = {
+	{.compatible = "hisilicon,hi3660-dsi"},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, dsi_of_match);
+
+static struct platform_driver dsi_driver = {
+	.probe = dsi_probe,
+	.remove = dsi_remove,
+	.driver = {
+		.name = "dw-dsi",
+		.of_match_table = dsi_of_match,
+	},
+};
+
+module_platform_driver(dsi_driver);
+
+MODULE_DESCRIPTION("DesignWare MIPI DSI Host Controller v1.02 driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/hikey9xx/gpu/dw_dsi_reg.h b/drivers/staging/hikey9xx/gpu/dw_dsi_reg.h
new file mode 100644
index 000000000000..00fac1f35265
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/dw_dsi_reg.h
@@ -0,0 +1,145 @@
+/*
+ * Copyright (c) 2016 Linaro Limited.
+ * Copyright (c) 2014-2016 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __DW_DSI_REG_H__
+#define __DW_DSI_REG_H__
+
+#define MASK(x)				(BIT(x) - 1)
+#define DEFAULT_MAX_TX_ESC_CLK	(10 * 1000000UL)
+/*
+ * regs
+ */
+#define PWR_UP                  0x04  /* Core power-up */
+#define RESET                   0
+#define POWERUP                 BIT(0)
+#define PHY_IF_CFG              0xA4  /* D-PHY interface configuration */
+#define CLKMGR_CFG              0x08  /* the internal clock dividers */
+#define PHY_RSTZ                0xA0  /* D-PHY reset control */
+#define PHY_ENABLECLK           BIT(2)
+#define PHY_UNRSTZ              BIT(1)
+#define PHY_UNSHUTDOWNZ         BIT(0)
+#define PHY_TST_CTRL0           0xB4  /* D-PHY test interface control 0 */
+#define PHY_TST_CTRL1           0xB8  /* D-PHY test interface control 1 */
+#define CLK_TLPX                0x10
+#define CLK_THS_PREPARE         0x11
+#define CLK_THS_ZERO            0x12
+#define CLK_THS_TRAIL           0x13
+#define CLK_TWAKEUP             0x14
+#define DATA_TLPX(x)            (0x20 + ((x) << 4))
+#define DATA_THS_PREPARE(x)     (0x21 + ((x) << 4))
+#define DATA_THS_ZERO(x)        (0x22 + ((x) << 4))
+#define DATA_THS_TRAIL(x)       (0x23 + ((x) << 4))
+#define DATA_TTA_GO(x)          (0x24 + ((x) << 4))
+#define DATA_TTA_GET(x)         (0x25 + ((x) << 4))
+#define DATA_TWAKEUP(x)         (0x26 + ((x) << 4))
+#define PHY_CFG_I               0x60
+#define PHY_CFG_PLL_I           0x63
+#define PHY_CFG_PLL_II          0x64
+#define PHY_CFG_PLL_III         0x65
+#define PHY_CFG_PLL_IV          0x66
+#define PHY_CFG_PLL_V           0x67
+#define DPI_COLOR_CODING        0x10  /* DPI color coding */
+#define DPI_CFG_POL             0x14  /* DPI polarity configuration */
+#define VID_HSA_TIME            0x48  /* Horizontal Sync Active time */
+#define VID_HBP_TIME            0x4C  /* Horizontal Back Porch time */
+#define VID_HLINE_TIME          0x50  /* Line time */
+#define VID_VSA_LINES           0x54  /* Vertical Sync Active period */
+#define VID_VBP_LINES           0x58  /* Vertical Back Porch period */
+#define VID_VFP_LINES           0x5C  /* Vertical Front Porch period */
+#define VID_VACTIVE_LINES       0x60  /* Vertical resolution */
+#define VID_PKT_SIZE            0x3C  /* Video packet size */
+#define VID_MODE_CFG            0x38  /* Video mode configuration */
+#define GEN_HDR			0x6c
+#define GEN_HDATA(data)		(((data) & 0xffff) << 8)
+#define GEN_HDATA_MASK		(0xffff << 8)
+#define GEN_HTYPE(type)		(((type) & 0xff) << 0)
+#define GEN_HTYPE_MASK		0xff
+#define GEN_PLD_DATA		0x70
+#define CMD_PKT_STATUS		0x74
+#define GEN_CMD_EMPTY		BIT(0)
+#define GEN_CMD_FULL		BIT(1)
+#define GEN_PLD_W_EMPTY		BIT(2)
+#define GEN_PLD_W_FULL		BIT(3)
+#define GEN_PLD_R_EMPTY		BIT(4)
+#define GEN_PLD_R_FULL		BIT(5)
+#define GEN_RD_CMD_BUSY		BIT(6)
+#define CMD_MODE_CFG		0x68
+#define MAX_RD_PKT_SIZE_LP	BIT(24)
+#define DCS_LW_TX_LP		BIT(19)
+#define DCS_SR_0P_TX_LP		BIT(18)
+#define DCS_SW_1P_TX_LP		BIT(17)
+#define DCS_SW_0P_TX_LP		BIT(16)
+#define GEN_LW_TX_LP		BIT(14)
+#define GEN_SR_2P_TX_LP		BIT(13)
+#define GEN_SR_1P_TX_LP		BIT(12)
+#define GEN_SR_0P_TX_LP		BIT(11)
+#define GEN_SW_2P_TX_LP		BIT(10)
+#define GEN_SW_1P_TX_LP		BIT(9)
+#define GEN_SW_0P_TX_LP		BIT(8)
+#define EN_ACK_RQST		BIT(1)
+#define EN_TEAR_FX		BIT(0)
+#define CMD_MODE_ALL_LP		(MAX_RD_PKT_SIZE_LP | \
+				 DCS_LW_TX_LP | \
+				 DCS_SR_0P_TX_LP | \
+				 DCS_SW_1P_TX_LP | \
+				 DCS_SW_0P_TX_LP | \
+				 GEN_LW_TX_LP | \
+				 GEN_SR_2P_TX_LP | \
+				 GEN_SR_1P_TX_LP | \
+				 GEN_SR_0P_TX_LP | \
+				 GEN_SW_2P_TX_LP | \
+				 GEN_SW_1P_TX_LP | \
+				 GEN_SW_0P_TX_LP)
+#define PHY_TMR_CFG             0x9C  /* Data lanes timing configuration */
+#define BTA_TO_CNT              0x8C  /* Response timeout definition */
+#define PHY_TMR_LPCLK_CFG       0x98  /* clock lane timing configuration */
+#define CLK_DATA_TMR_CFG        0xCC
+#define LPCLK_CTRL              0x94  /* Low-power in clock lane */
+#define PHY_TXREQUESTCLKHS      BIT(0)
+#define MODE_CFG                0x34  /* Video or Command mode selection */
+#define PHY_STATUS              0xB0  /* D-PHY PPI status interface */
+
+#define	PHY_STOP_WAIT_TIME      0x30
+#define CMD_PKT_STATUS_TIMEOUT_US	20000
+
+/*
+ * regs relevant enum
+ */
+enum dpi_color_coding {
+	DSI_24BITS_1 = 5,
+};
+
+enum dsi_video_mode_type {
+	DSI_NON_BURST_SYNC_PULSES = 0,
+	DSI_NON_BURST_SYNC_EVENTS,
+	DSI_BURST_SYNC_PULSES_1,
+	DSI_BURST_SYNC_PULSES_2
+};
+
+enum dsi_work_mode {
+	DSI_VIDEO_MODE = 0,
+	DSI_COMMAND_MODE
+};
+
+/*
+ * Register Write/Read Helper functions
+ */
+static inline void dw_update_bits(void __iomem *addr, u32 bit_start,
+				  u32 mask, u32 val)
+{
+	u32 tmp, orig;
+
+	orig = readl(addr);
+	tmp = orig & ~(mask << bit_start);
+	tmp |= (val & mask) << bit_start;
+	writel(tmp, addr);
+}
+
+#endif /* __DW_DRM_DSI_H__ */
diff --git a/drivers/staging/hikey9xx/gpu/kirin_dpe_reg.h b/drivers/staging/hikey9xx/gpu/kirin_dpe_reg.h
new file mode 100644
index 000000000000..61af8ef81878
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_dpe_reg.h
@@ -0,0 +1,3114 @@
+/*
+ * Copyright (c) 2016 Linaro Limited.
+ * Copyright (c) 2014-2016 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __KIRIN_DPE_REG_H__
+#define __KIRIN_DPE_REG_H__
+
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/bug.h>
+
+#include <linux/ion.h>
+#include <linux/hisi/hisi_ion.h>
+
+/*******************************************************************************
+**
+*/
+enum dss_chn_idx {
+	DSS_RCHN_NONE = -1,
+	DSS_RCHN_D2 = 0,
+	DSS_RCHN_D3,
+	DSS_RCHN_V0,
+	DSS_RCHN_G0,
+	DSS_RCHN_V1,
+	DSS_RCHN_G1,
+	DSS_RCHN_D0,
+	DSS_RCHN_D1,
+
+	DSS_WCHN_W0,
+	DSS_WCHN_W1,
+
+	DSS_CHN_MAX,
+
+	DSS_RCHN_V2 = DSS_CHN_MAX,  /*for copybit, only supported in chicago*/
+	DSS_WCHN_W2,
+
+	DSS_COPYBIT_MAX,
+};
+
+enum dss_channel {
+	DSS_CH1 = 0,	/* channel 1 for primary plane */
+	DSS_CH_NUM
+};
+
+#define PRIMARY_CH	DSS_CH1 /* primary plane */
+
+typedef struct dss_rect {
+	s32 x;
+	s32 y;
+	s32 w;
+	s32 h;
+} dss_rect_t;
+
+typedef struct dss_rect_ltrb {
+	s32 left;
+	s32 top;
+	s32 right;
+	s32 bottom;
+} dss_rect_ltrb_t;
+
+enum {
+	DSI_1_LANES = 0,
+	DSI_2_LANES,
+	DSI_3_LANES,
+	DSI_4_LANES,
+};
+
+enum dss_ovl_idx {
+	DSS_OVL0 = 0,
+	DSS_OVL1,
+	DSS_OVL2,
+	DSS_OVL3,
+	DSS_OVL_IDX_MAX,
+};
+
+#define DSS_WCH_MAX  (2)
+
+typedef struct dss_img {
+	uint32_t format;
+	uint32_t width;
+	uint32_t height;
+	uint32_t bpp;		/* bytes per pixel */
+	uint32_t buf_size;
+	uint32_t stride;
+	uint32_t stride_plane1;
+	uint32_t stride_plane2;
+	uint64_t phy_addr;
+	uint64_t vir_addr;
+	uint32_t offset_plane1;
+	uint32_t offset_plane2;
+
+	uint64_t afbc_header_addr;
+	uint64_t afbc_payload_addr;
+	uint32_t afbc_header_stride;
+	uint32_t afbc_payload_stride;
+	uint32_t afbc_scramble_mode;
+	uint32_t mmbuf_base;
+	uint32_t mmbuf_size;
+
+	uint32_t mmu_enable;
+	uint32_t csc_mode;
+	uint32_t secure_mode;
+	int32_t shared_fd;
+	uint32_t reserved0;
+} dss_img_t;
+
+typedef struct drm_dss_layer {
+	dss_img_t img;
+	dss_rect_t src_rect;
+	dss_rect_t src_rect_mask;
+	dss_rect_t dst_rect;
+	uint32_t transform;
+	int32_t blending;
+	uint32_t glb_alpha;
+	uint32_t color;		/* background color or dim color */
+	int32_t layer_idx;
+	int32_t chn_idx;
+	uint32_t need_cap;
+	int32_t acquire_fence;
+} drm_dss_layer_t;
+
+
+/*******************************************************************************
+**
+*/
+#define DEFAULT_MIPI_CLK_RATE	(192 * 100000L)
+#define DEFAULT_PCLK_DSI_RATE	(120 * 1000000L)
+
+#define DEFAULT_DSS_CORE_CLK_08V_RATE	(535000000UL)
+#define DEFAULT_DSS_CORE_CLK_07V_RATE	(400000000UL)
+#define DEFAULT_PCLK_DSS_RATE	(114000000UL)
+#define DEFAULT_PCLK_PCTRL_RATE	(80000000UL)
+#define DSS_MAX_PXL0_CLK_288M (288000000UL)
+#define DSS_MAX_PXL0_CLK_144M (144000000UL)
+
+#define DSS_ADDR  0xE8600000
+#define DSS_DSI_ADDR	(DSS_ADDR + 0x01000)
+#define DSS_LDI_ADDR	(DSS_ADDR + 0x7d000)
+#define PMC_BASE	(0xFFF31000)
+#define PERI_CRG_BASE	(0xFFF35000)
+#define SCTRL_BASE	(0xFFF0A000)
+
+#define GPIO_LCD_POWER_1V2  (54)
+#define GPIO_LCD_STANDBY    (67)
+#define GPIO_LCD_RESETN     (65)
+#define GPIO_LCD_GATING     (60)
+#define GPIO_LCD_PCLK_GATING (58)
+#define GPIO_LCD_REFCLK_GATING (59)
+#define GPIO_LCD_SPICS         (168)
+#define GPIO_LCD_DRV_EN        (73)
+
+#define GPIO_PG_SEL_A (72)
+#define GPIO_TX_RX_A (74)
+#define GPIO_PG_SEL_B (76)
+#define GPIO_TX_RX_B (78)
+
+/*******************************************************************************
+ **
+ */
+#define CRGPERI_PLL0_CLK_RATE	(1600000000UL)
+#define CRGPERI_PLL2_CLK_RATE	(960000000UL)
+#define CRGPERI_PLL3_CLK_RATE	(1600000000UL)
+
+#define DEFAULT_DSS_CORE_CLK_08V_RATE	(535000000UL)
+#define DEFAULT_DSS_CORE_CLK_07V_RATE	(400000000UL)
+#define DEFAULT_PCLK_DSS_RATE	(114000000UL)
+#define DEFAULT_PCLK_PCTRL_RATE	(80000000UL)
+#define DSS_MAX_PXL0_CLK_288M (288000000UL)
+
+#define MMBUF_SIZE_MAX	(288 * 1024)
+#define HISI_DSS_CMDLIST_MAX	(16)
+#define HISI_DSS_CMDLIST_IDXS_MAX (0xFFFF)
+#define HISI_DSS_COPYBIT_CMDLIST_IDXS	 (0xC000)
+#define HISI_DSS_DPP_MAX_SUPPORT_BIT (0x7ff)
+#define HISIFB_DSS_PLATFORM_TYPE  (FB_ACCEL_HI366x | FB_ACCEL_PLATFORM_TYPE_ASIC)
+
+#define DSS_MIF_SMMU_SMRX_IDX_STEP (16)
+#define CRG_PERI_DIS3_DEFAULT_VAL     (0x0002F000)
+#define SCF_LINE_BUF	(2560)
+#define DSS_GLB_MODULE_CLK_SEL_DEFAULT_VAL  (0xF0000008)
+#define DSS_LDI_CLK_SEL_DEFAULT_VAL    (0x00000004)
+#define DSS_DBUF_MEM_CTRL_DEFAULT_VAL  (0x00000008)
+#define DSS_SMMU_RLD_EN0_DEFAULT_VAL    (0xffffffff)
+#define DSS_SMMU_RLD_EN1_DEFAULT_VAL    (0xffffff8f)
+#define DSS_SMMU_OUTSTANDING_VAL		(0xf)
+#define DSS_MIF_CTRL2_INVAL_SEL3_STRIDE_MASK		(0xc)
+#define DSS_AFBCE_ENC_OS_CFG_DEFAULT_VAL			(0x7)
+#define TUI_SEC_RCH			(DSS_RCHN_V0)
+#define DSS_CHN_MAX_DEFINE (DSS_COPYBIT_MAX)
+
+/* perf stat */
+#define DSS_DEVMEM_PERF_BASE (0xFDF10000)
+#define CRG_PERIPH_APB_PERRSTSTAT0_REG (0x68)
+#define CRG_PERIPH_APB_IP_RST_PERF_STAT_BIT (18)
+#define PERF_SAMPSTOP_REG (0x10)
+#define DEVMEM_PERF_SIZE (0x100)
+
+/*
+ * DSS Registers
+*/
+
+/* MACROS */
+#define DSS_WIDTH(width)	((width) - 1)
+#define DSS_HEIGHT(height)	((height) - 1)
+
+#define RES_540P	(960 * 540)
+#define RES_720P	(1280 * 720)
+#define RES_1080P	(1920 * 1080)
+#define RES_1200P	(1920 * 1200)
+#define RES_1440P	(2560 * 1440)
+#define RES_1600P	(2560 * 1600)
+#define RES_4K_PHONE	(3840 * 2160)
+#define RES_4K_PAD	(3840 * 2400)
+
+#define DFC_MAX_CLIP_NUM	(31)
+
+/* for DFS */
+/* 1480 * 144bits */
+#define DFS_TIME	(80)
+#define DFS_TIME_MIN	(50)
+#define DFS_TIME_MIN_4K	(10)
+#define DBUF0_DEPTH	(1408)
+#define DBUF1_DEPTH	(512)
+#define DBUF_WIDTH_BIT	(144)
+
+#define GET_THD_RQOS_IN(max_depth)	((max_depth) * 10 / 100)
+#define GET_THD_RQOS_OUT(max_depth)	((max_depth) * 30 / 100)
+#define GET_THD_WQOS_IN(max_depth)	((max_depth) * 95 / 100)
+#define GET_THD_WQOS_OUT(max_depth)	((max_depth) * 70 / 100)
+#define GET_THD_CG_IN(max_depth)	((max_depth) - 1)
+#define GET_THD_CG_OUT(max_depth)	((max_depth) * 70 / 100)
+#define GET_FLUX_REQ_IN(max_depth)	((max_depth) * 50 / 100)
+#define GET_FLUX_REQ_OUT(max_depth)	((max_depth) * 90 / 100)
+#define GET_THD_OTHER_DFS_CG_HOLD(max_depth)	(0x20)
+#define GET_THD_OTHER_WR_WAIT(max_depth)	((max_depth) * 90 / 100)
+
+#define GET_RDMA_ROT_HQOS_ASSERT_LEV(max_depth)	((max_depth) * 30 / 100)
+#define GET_RDMA_ROT_HQOS_REMOVE_LEV(max_depth)	((max_depth) * 60 / 100)
+
+enum lcd_orientation {
+	LCD_LANDSCAPE = 0,
+	LCD_PORTRAIT,
+};
+
+enum lcd_format {
+	LCD_RGB888 = 0,
+	LCD_RGB101010,
+	LCD_RGB565,
+};
+
+enum lcd_rgb_order {
+	LCD_RGB = 0,
+	LCD_BGR,
+};
+
+enum dss_addr {
+	DSS_ADDR_PLANE0 = 0,
+	DSS_ADDR_PLANE1,
+	DSS_ADDR_PLANE2,
+};
+
+enum dss_transform {
+	DSS_TRANSFORM_NOP = 0x0,
+	DSS_TRANSFORM_FLIP_H = 0x01,
+	DSS_TRANSFORM_FLIP_V = 0x02,
+	DSS_TRANSFORM_ROT = 0x04,
+};
+
+enum dss_dfc_format {
+	DFC_PIXEL_FORMAT_RGB_565 = 0,
+	DFC_PIXEL_FORMAT_XRGB_4444,
+	DFC_PIXEL_FORMAT_ARGB_4444,
+	DFC_PIXEL_FORMAT_XRGB_5551,
+	DFC_PIXEL_FORMAT_ARGB_5551,
+	DFC_PIXEL_FORMAT_XRGB_8888,
+	DFC_PIXEL_FORMAT_ARGB_8888,
+	DFC_PIXEL_FORMAT_BGR_565,
+	DFC_PIXEL_FORMAT_XBGR_4444,
+	DFC_PIXEL_FORMAT_ABGR_4444,
+	DFC_PIXEL_FORMAT_XBGR_5551,
+	DFC_PIXEL_FORMAT_ABGR_5551,
+	DFC_PIXEL_FORMAT_XBGR_8888,
+	DFC_PIXEL_FORMAT_ABGR_8888,
+
+	DFC_PIXEL_FORMAT_YUV444,
+	DFC_PIXEL_FORMAT_YVU444,
+	DFC_PIXEL_FORMAT_YUYV422,
+	DFC_PIXEL_FORMAT_YVYU422,
+	DFC_PIXEL_FORMAT_VYUY422,
+	DFC_PIXEL_FORMAT_UYVY422,
+};
+
+enum dss_dma_format {
+	DMA_PIXEL_FORMAT_RGB_565 = 0,
+	DMA_PIXEL_FORMAT_ARGB_4444,
+	DMA_PIXEL_FORMAT_XRGB_4444,
+	DMA_PIXEL_FORMAT_ARGB_5551,
+	DMA_PIXEL_FORMAT_XRGB_5551,
+	DMA_PIXEL_FORMAT_ARGB_8888,
+	DMA_PIXEL_FORMAT_XRGB_8888,
+
+	DMA_PIXEL_FORMAT_RESERVED0,
+
+	DMA_PIXEL_FORMAT_YUYV_422_Pkg,
+	DMA_PIXEL_FORMAT_YUV_420_SP_HP,
+	DMA_PIXEL_FORMAT_YUV_420_P_HP,
+	DMA_PIXEL_FORMAT_YUV_422_SP_HP,
+	DMA_PIXEL_FORMAT_YUV_422_P_HP,
+	DMA_PIXEL_FORMAT_AYUV_4444,
+};
+
+enum dss_buf_format {
+	DSS_BUF_LINEAR = 0,
+	DSS_BUF_TILE,
+};
+
+enum dss_blend_mode {
+	DSS_BLEND_CLEAR = 0,
+	DSS_BLEND_SRC,
+	DSS_BLEND_DST,
+	DSS_BLEND_SRC_OVER_DST,
+	DSS_BLEND_DST_OVER_SRC,
+	DSS_BLEND_SRC_IN_DST,
+	DSS_BLEND_DST_IN_SRC,
+	DSS_BLEND_SRC_OUT_DST,
+	DSS_BLEND_DST_OUT_SRC,
+	DSS_BLEND_SRC_ATOP_DST,
+	DSS_BLEND_DST_ATOP_SRC,
+	DSS_BLEND_SRC_XOR_DST,
+	DSS_BLEND_SRC_ADD_DST,
+	DSS_BLEND_FIX_OVER,
+	DSS_BLEND_FIX_PER0,
+	DSS_BLEND_FIX_PER1,
+	DSS_BLEND_FIX_PER2,
+	DSS_BLEND_FIX_PER3,
+	DSS_BLEND_FIX_PER4,
+	DSS_BLEND_FIX_PER5,
+	DSS_BLEND_FIX_PER6,
+	DSS_BLEND_FIX_PER7,
+	DSS_BLEND_FIX_PER8,
+	DSS_BLEND_FIX_PER9,
+	DSS_BLEND_FIX_PER10,
+	DSS_BLEND_FIX_PER11,
+	DSS_BLEND_FIX_PER12,
+	DSS_BLEND_FIX_PER13,
+	DSS_BLEND_FIX_PER14,
+	DSS_BLEND_FIX_PER15,
+	DSS_BLEND_FIX_PER16,
+	DSS_BLEND_FIX_PER17,
+
+	DSS_BLEND_MAX,
+};
+
+enum dss_chn_module {
+	MODULE_MIF_CHN,
+	MODULE_AIF0_CHN,
+	MODULE_AIF1_CHN,
+	MODULE_MCTL_CHN_MUTEX,
+	MODULE_MCTL_CHN_FLUSH_EN,
+	MODULE_MCTL_CHN_OV_OEN,
+	MODULE_MCTL_CHN_STARTY,
+	MODULE_MCTL_CHN_MOD_DBG,
+	MODULE_DMA,
+	MODULE_DFC,
+	MODULE_SCL,
+	MODULE_SCL_LUT,
+	MODULE_ARSR2P,
+	MODULE_ARSR2P_LUT,
+	MODULE_POST_CLIP,
+	MODULE_PCSC,
+	MODULE_CSC,
+	MODULE_CHN_MAX,
+};
+
+enum dss_chn_cap {
+	MODULE_CAP_ROT,
+	MODULE_CAP_SCL,
+	MODULE_CAP_CSC,
+	MODULE_CAP_SHARPNESS_1D,
+	MODULE_CAP_SHARPNESS_2D,
+	MODULE_CAP_CE,
+	MODULE_CAP_AFBCD,
+	MODULE_CAP_AFBCE,
+	MODULE_CAP_YUV_PLANAR,
+	MODULE_CAP_YUV_SEMI_PLANAR,
+	MODULE_CAP_YUV_PACKAGE,
+	MODULE_CAP_MAX,
+};
+
+enum dss_ovl_module {
+	MODULE_OVL_BASE,
+	MODULE_MCTL_BASE,
+	MODULE_OVL_MAX,
+};
+
+enum dss_axi_idx {
+	AXI_CHN0 = 0,
+	AXI_CHN1,
+	AXI_CHN_MAX,
+};
+
+#define AXI0_MAX_DSS_CHN_THRESHOLD	(3)
+#define AXI1_MAX_DSS_CHN_THRESHOLD	(3)
+
+#define DEFAULT_AXI_CLK_RATE0	(120 * 1000000)
+#define DEFAULT_AXI_CLK_RATE1	(240 * 1000000)
+#define DEFAULT_AXI_CLK_RATE2	(360 * 1000000)
+#define DEFAULT_AXI_CLK_RATE3	(480 * 1000000)
+#define DEFAULT_AXI_CLK_RATE4	(667 * 1000000)
+#define DEFAULT_AXI_CLK_RATE5	(800 * 1000000)
+
+enum dss_rdma_idx {
+	DSS_RDMA0 = 0,
+	DSS_RDMA1,
+	DSS_RDMA2,
+	DSS_RDMA3,
+	DSS_RDMA4,
+	DSS_RDMA_MAX,
+};
+
+/*******************************************************************************
+ **
+ */
+
+#define PEREN0	(0x000)
+#define PERDIS0	(0x004)
+#define PEREN2	(0x020)
+#define PERDIS2	(0x024)
+#define PERCLKEN2	(0x028)
+#define PERSTAT2	(0x02C)
+#define PEREN3	(0x030)
+#define PERDIS3	(0x034)
+#define PERCLKEN3	(0x038)
+#define PERSTAT3	(0x03C)
+#define PEREN5	(0x050)
+#define PERDIS5	(0x054)
+#define PERCLKEN5	(0x058)
+#define PERSTAT5	(0x05C)
+#define PERRSTDIS0	(0x064)
+#define PERRSTEN2	(0x078)
+#define PERRSTDIS2	(0x07C)
+#define PERRSTEN3	(0x084)
+#define PERRSTDIS3	(0x088)
+#define PERRSTSTAT3 (0x08c)
+#define PERRSTEN4	(0x090)
+#define PERRSTDIS4	(0x094)
+#define PERRSTSTAT4 (0x098)
+#define CLKDIV3	(0x0B4)
+#define CLKDIV5	(0x0BC)
+#define CLKDIV10	(0x0D0)
+#define CLKDIV18	(0x0F0)
+#define CLKDIV20	(0x0F8)
+#define ISOEN	(0x144)
+#define ISODIS	(0x148)
+#define ISOSTAT	(0x14c)
+#define PERPWREN	(0x150)
+#define PERPWRDIS	(0x154)
+#define PERPWRSTAT (0x158)
+#define PERI_AUTODIV8	(0x380)
+#define PERI_AUTODIV9	(0x384)
+#define PERI_AUTODIV10	(0x388)
+
+#define NOC_POWER_IDLEREQ	(0x380)
+#define NOC_POWER_IDLEACK	(0x384)
+#define NOC_POWER_IDLE	(0x388)
+
+#define SCPWREN	(0x0D0)
+#define SCPEREN1 (0x040)
+#define SCPERDIS1  (0x044)
+#define SCPERCLKEN1 (0x048)
+#define SCPERRSTDIS1	(0x090)
+#define SCISODIS	(0x0C4)
+#define SCCLKDIV2	(0x258)
+#define SCCLKDIV4	(0x260)
+
+#define PERI_CTRL23	(0x060)
+#define PERI_CTRL29	(0x078)
+#define PERI_CTRL30	(0x07C)
+#define PERI_CTRL32	(0x084)
+#define PERI_STAT0	(0x094)
+#define PERI_STAT1	(0x098)
+#define PERI_STAT16	(0x0D4)
+
+#define PCTRL_DPHYTX_ULPSEXIT1	BIT(4)
+#define PCTRL_DPHYTX_ULPSEXIT0	BIT(3)
+
+#define PCTRL_DPHYTX_CTRL1	BIT(1)
+#define PCTRL_DPHYTX_CTRL0	BIT(0)
+
+/*******************************************************************************
+ **
+ */
+#define BIT_DSS_GLB_INTS	BIT(30)
+#define BIT_MMU_IRPT_S	BIT(29)
+#define BIT_MMU_IRPT_NS	BIT(28)
+#define BIT_DBG_MCTL_INTS	BIT(27)
+#define BIT_DBG_WCH1_INTS	BIT(26)
+#define BIT_DBG_WCH0_INTS	BIT(25)
+#define BIT_DBG_RCH7_INTS	BIT(24)
+#define BIT_DBG_RCH6_INTS	BIT(23)
+#define BIT_DBG_RCH5_INTS	BIT(22)
+#define BIT_DBG_RCH4_INTS	BIT(21)
+#define BIT_DBG_RCH3_INTS	BIT(20)
+#define BIT_DBG_RCH2_INTS	BIT(19)
+#define BIT_DBG_RCH1_INTS	BIT(18)
+#define BIT_DBG_RCH0_INTS	BIT(17)
+#define BIT_ITF0_INTS	BIT(16)
+#define BIT_DPP_INTS	BIT(15)
+#define BIT_CMDLIST13	BIT(14)
+#define BIT_CMDLIST12	BIT(13)
+#define BIT_CMDLIST11	BIT(12)
+#define BIT_CMDLIST10	BIT(11)
+#define BIT_CMDLIST9	BIT(10)
+#define BIT_CMDLIST8	BIT(9)
+#define BIT_CMDLIST7	BIT(8)
+#define BIT_CMDLIST6	BIT(7)
+#define BIT_CMDLIST5	BIT(6)
+#define BIT_CMDLIST4	BIT(5)
+#define BIT_CMDLIST3	BIT(4)
+#define BIT_CMDLIST2	BIT(3)
+#define BIT_CMDLIST1	BIT(2)
+#define BIT_CMDLIST0	BIT(1)
+
+#define BIT_SDP_DSS_GLB_INTS	BIT(29)
+#define BIT_SDP_MMU_IRPT_S	BIT(28)
+#define BIT_SDP_MMU_IRPT_NS	BIT(27)
+#define BIT_SDP_DBG_MCTL_INTS	BIT(26)
+#define BIT_SDP_DBG_WCH1_INTS	BIT(25)
+#define BIT_SDP_DBG_WCH0_INTS	BIT(24)
+#define BIT_SDP_DBG_RCH7_INTS	BIT(23)
+#define BIT_SDP_DBG_RCH6_INTS	BIT(22)
+#define BIT_SDP_DBG_RCH5_INTS	BIT(21)
+#define BIT_SDP_DBG_RCH4_INTS	BIT(20)
+#define BIT_SDP_DBG_RCH3_INTS	BIT(19)
+#define BIT_SDP_DBG_RCH2_INTS	BIT(18)
+#define BIT_SDP_DBG_RCH1_INTS	BIT(17)
+#define BIT_SDP_DBG_RCH0_INTS	BIT(16)
+#define BIT_SDP_ITF1_INTS	BIT(15)
+#define BIT_SDP_CMDLIST13	BIT(14)
+#define BIT_SDP_CMDLIST12	BIT(13)
+#define BIT_SDP_CMDLIST11	BIT(12)
+#define BIT_SDP_CMDLIST10	BIT(11)
+#define BIT_SDP_CMDLIST9	BIT(10)
+#define BIT_SDP_CMDLIST8	BIT(9)
+#define BIT_SDP_CMDLIST7	BIT(8)
+#define BIT_SDP_CMDLIST6	BIT(7)
+#define BIT_SDP_CMDLIST5	BIT(6)
+#define BIT_SDP_CMDLIST4	BIT(5)
+#define BIT_SDP_CMDLIST3	BIT(4)
+#define BIT_SDP_SDP_CMDLIST2	BIT(3)
+#define BIT_SDP_CMDLIST1	BIT(2)
+#define BIT_SDP_CMDLIST0	BIT(1)
+#define BIT_SDP_RCH_CE_INTS	BIT(0)
+
+#define BIT_OFF_DSS_GLB_INTS	BIT(31)
+#define BIT_OFF_MMU_IRPT_S	BIT(30)
+#define BIT_OFF_MMU_IRPT_NS	BIT(29)
+#define BIT_OFF_DBG_MCTL_INTS	BIT(28)
+#define BIT_OFF_DBG_WCH1_INTS	BIT(27)
+#define BIT_OFF_DBG_WCH0_INTS	BIT(26)
+#define BIT_OFF_DBG_RCH7_INTS	BIT(25)
+#define BIT_OFF_DBG_RCH6_INTS	BIT(24)
+#define BIT_OFF_DBG_RCH5_INTS	BIT(23)
+#define BIT_OFF_DBG_RCH4_INTS	BIT(22)
+#define BIT_OFF_DBG_RCH3_INTS	BIT(21)
+#define BIT_OFF_DBG_RCH2_INTS	BIT(20)
+#define BIT_OFF_DBG_RCH1_INTS	BIT(19)
+#define BIT_OFF_DBG_RCH0_INTS	BIT(18)
+#define BIT_OFF_WCH1_INTS	BIT(17)
+#define BIT_OFF_WCH0_INTS	BIT(16)
+#define BIT_OFF_WCH0_WCH1_FRM_END_INT	BIT(15)
+#define BIT_OFF_CMDLIST13	BIT(14)
+#define BIT_OFF_CMDLIST12	BIT(13)
+#define BIT_OFF_CMDLIST11	BIT(12)
+#define BIT_OFF_CMDLIST10	BIT(11)
+#define BIT_OFF_CMDLIST9	BIT(10)
+#define BIT_OFF_CMDLIST8	BIT(9)
+#define BIT_OFF_CMDLIST7	BIT(8)
+#define BIT_OFF_CMDLIST6	BIT(7)
+#define BIT_OFF_CMDLIST5	BIT(6)
+#define BIT_OFF_CMDLIST4	BIT(5)
+#define BIT_OFF_CMDLIST3	BIT(4)
+#define BIT_OFF_CMDLIST2	BIT(3)
+#define BIT_OFF_CMDLIST1	BIT(2)
+#define BIT_OFF_CMDLIST0	BIT(1)
+#define BIT_OFF_RCH_CE_INTS	BIT(0)
+
+#define BIT_OFF_CAM_DBG_WCH2_INTS	BIT(4)
+#define BIT_OFF_CAM_DBG_RCH8_INTS	BIT(3)
+#define BIT_OFF_CAM_WCH2_FRMEND_INTS  BIT(2)
+#define BIT_OFF_CAM_CMDLIST15_INTS	BIT(1)
+#define BIT_OFF_CAM_CMDLIST14_INTS	BIT(0)
+
+#define BIT_VACTIVE_CNT	BIT(14)
+#define BIT_DSI_TE_TRI	BIT(13)
+#define BIT_LCD_TE0_PIN	BIT(12)
+#define BIT_LCD_TE1_PIN	BIT(11)
+#define BIT_VACTIVE1_END	BIT(10)
+#define BIT_VACTIVE1_START	BIT(9)
+#define BIT_VACTIVE0_END	BIT(8)
+#define BIT_VACTIVE0_START	BIT(7)
+#define BIT_VFRONTPORCH	BIT(6)
+#define BIT_VBACKPORCH	BIT(5)
+#define BIT_VSYNC	BIT(4)
+#define BIT_VFRONTPORCH_END	BIT(3)
+#define BIT_LDI_UNFLOW	BIT(2)
+#define BIT_FRM_END	BIT(1)
+#define BIT_FRM_START	BIT(0)
+
+#define BIT_CTL_FLUSH_EN	BIT(21)
+#define BIT_SCF_FLUSH_EN	BIT(19)
+#define BIT_DPP0_FLUSH_EN	BIT(18)
+#define BIT_DBUF1_FLUSH_EN	BIT(17)
+#define BIT_DBUF0_FLUSH_EN	BIT(16)
+#define BIT_OV3_FLUSH_EN	BIT(15)
+#define BIT_OV2_FLUSH_EN	BIT(14)
+#define BIT_OV1_FLUSH_EN	BIT(13)
+#define BIT_OV0_FLUSH_EN	BIT(12)
+#define BIT_WB1_FLUSH_EN	BIT(11)
+#define BIT_WB0_FLUSH_EN	BIT(10)
+#define BIT_DMA3_FLUSH_EN	BIT(9)
+#define BIT_DMA2_FLUSH_EN	BIT(8)
+#define BIT_DMA1_FLUSH_EN	BIT(7)
+#define BIT_DMA0_FLUSH_EN	BIT(6)
+#define BIT_RGB1_FLUSH_EN	BIT(4)
+#define BIT_RGB0_FLUSH_EN	BIT(3)
+#define BIT_VIG1_FLUSH_EN	BIT(1)
+#define BIT_VIG0_FLUSH_EN	BIT(0)
+
+#define BIT_BUS_DBG_INT	BIT(5)
+#define BIT_CRC_SUM_INT	BIT(4)
+#define BIT_CRC_ITF1_INT	BIT(3)
+#define BIT_CRC_ITF0_INT	BIT(2)
+#define BIT_CRC_OV1_INT	BIT(1)
+#define BIT_CRC_OV0_INT	BIT(0)
+
+#define BIT_SBL_SEND_FRAME_OUT	BIT(19)
+#define BIT_SBL_STOP_FRAME_OUT	BIT(18)
+#define BIT_SBL_BACKLIGHT_OUT	BIT(17)
+#define BIT_SBL_DARKENH_OUT		BIT(16)
+#define BIT_SBL_BRIGHTPTR_OUT	BIT(15)
+#define BIT_STRENGTH_INROI_OUT	BIT(14)
+#define BIT_STRENGTH_OUTROI_OUT	BIT(13)
+#define BIT_DONE_OUT			BIT(12)
+#define BIT_PPROC_DONE_OUT		BIT(11)
+
+#define BIT_HIACE_IND	BIT(8)
+#define BIT_STRENGTH_INTP	BIT(7)
+#define BIT_BACKLIGHT_INTP	BIT(6)
+#define BIT_CE_END_IND	BIT(5)
+#define BIT_CE_CANCEL_IND	BIT(4)
+#define BIT_CE_LUT1_RW_COLLIDE_IND	BIT(3)
+#define BIT_CE_LUT0_RW_COLLIDE_IND	BIT(2)
+#define BIT_CE_HIST1_RW_COLLIDE_IND	BIT(1)
+#define BIT_CE_HIST0_RW_COLLIDE_IND	BIT(0)
+
+/*******************************************************************************
+ ** MODULE BASE ADDRESS
+ */
+
+#define DSS_MIPI_DSI0_OFFSET	(0x00001000)
+#define DSS_MIPI_DSI1_OFFSET	(0x00001400)
+
+#define DSS_GLB0_OFFSET	(0x12000)
+
+#define DSS_DBG_OFFSET	(0x11000)
+
+#define DSS_CMDLIST_OFFSET	(0x2000)
+
+#define DSS_SMMU_OFFSET	(0x8000)
+
+#define DSS_VBIF0_AIF	(0x7000)
+#define DSS_VBIF1_AIF	(0x9000)
+
+#define DSS_MIF_OFFSET	(0xA000)
+
+#define DSS_MCTRL_SYS_OFFSET	(0x10000)
+
+#define DSS_MCTRL_CTL0_OFFSET	(0x10800)
+#define DSS_MCTRL_CTL1_OFFSET	(0x10900)
+#define DSS_MCTRL_CTL2_OFFSET	(0x10A00)
+#define DSS_MCTRL_CTL3_OFFSET	(0x10B00)
+#define DSS_MCTRL_CTL4_OFFSET	(0x10C00)
+#define DSS_MCTRL_CTL5_OFFSET	(0x10D00)
+
+#define DSS_RCH_VG0_DMA_OFFSET	(0x20000)
+#define DSS_RCH_VG0_DFC_OFFSET (0x20100)
+#define DSS_RCH_VG0_SCL_OFFSET	(0x20200)
+#define DSS_RCH_VG0_ARSR_OFFSET	(0x20300)
+#define DSS_RCH_VG0_POST_CLIP_OFFSET	(0x203A0)
+#define DSS_RCH_VG0_PCSC_OFFSET	(0x20400)
+#define DSS_RCH_VG0_CSC_OFFSET	(0x20500)
+#define DSS_RCH_VG0_DEBUG_OFFSET	(0x20600)
+#define DSS_RCH_VG0_VPP_OFFSET	(0x20700)
+#define DSS_RCH_VG0_DMA_BUF_OFFSET	(0x20800)
+#define DSS_RCH_VG0_AFBCD_OFFSET	(0x20900)
+#define DSS_RCH_VG0_REG_DEFAULT_OFFSET	(0x20A00)
+#define DSS_RCH_VG0_SCL_LUT_OFFSET	(0x21000)
+#define DSS_RCH_VG0_ARSR_LUT_OFFSET	(0x25000)
+
+#define DSS_RCH_VG1_DMA_OFFSET	(0x28000)
+#define DSS_RCH_VG1_DFC_OFFSET (0x28100)
+#define DSS_RCH_VG1_SCL_OFFSET	(0x28200)
+#define DSS_RCH_VG1_POST_CLIP_OFFSET	(0x283A0)
+#define DSS_RCH_VG1_CSC_OFFSET	(0x28500)
+#define DSS_RCH_VG1_DEBUG_OFFSET	(0x28600)
+#define DSS_RCH_VG1_VPP_OFFSET	(0x28700)
+#define DSS_RCH_VG1_DMA_BUF_OFFSET	(0x28800)
+#define DSS_RCH_VG1_AFBCD_OFFSET	(0x28900)
+#define DSS_RCH_VG1_REG_DEFAULT_OFFSET	(0x28A00)
+#define DSS_RCH_VG1_SCL_LUT_OFFSET	(0x29000)
+
+#define DSS_RCH_VG2_DMA_OFFSET	(0x30000)
+#define DSS_RCH_VG2_DFC_OFFSET (0x30100)
+#define DSS_RCH_VG2_SCL_OFFSET	(0x30200)
+#define DSS_RCH_VG2_POST_CLIP_OFFSET	(0x303A0)
+#define DSS_RCH_VG2_CSC_OFFSET	(0x30500)
+#define DSS_RCH_VG2_DEBUG_OFFSET	(0x30600)
+#define DSS_RCH_VG2_VPP_OFFSET	(0x30700)
+#define DSS_RCH_VG2_DMA_BUF_OFFSET	(0x30800)
+#define DSS_RCH_VG2_AFBCD_OFFSET	(0x30900)
+#define DSS_RCH_VG2_REG_DEFAULT_OFFSET	(0x30A00)
+#define DSS_RCH_VG2_SCL_LUT_OFFSET	(0x31000)
+
+#define DSS_RCH_G0_DMA_OFFSET	(0x38000)
+#define DSS_RCH_G0_DFC_OFFSET	(0x38100)
+#define DSS_RCH_G0_SCL_OFFSET	(0x38200)
+#define DSS_RCH_G0_POST_CLIP_OFFSET (0x383A0)
+#define DSS_RCH_G0_CSC_OFFSET (0x38500)
+#define DSS_RCH_G0_DEBUG_OFFSET (0x38600)
+#define DSS_RCH_G0_DMA_BUF_OFFSET (0x38800)
+#define DSS_RCH_G0_AFBCD_OFFSET (0x38900)
+#define DSS_RCH_G0_REG_DEFAULT_OFFSET (0x38A00)
+
+#define DSS_RCH_G1_DMA_OFFSET	(0x40000)
+#define DSS_RCH_G1_DFC_OFFSET	(0x40100)
+#define DSS_RCH_G1_SCL_OFFSET	(0x40200)
+#define DSS_RCH_G1_POST_CLIP_OFFSET (0x403A0)
+#define DSS_RCH_G1_CSC_OFFSET (0x40500)
+#define DSS_RCH_G1_DEBUG_OFFSET (0x40600)
+#define DSS_RCH_G1_DMA_BUF_OFFSET (0x40800)
+#define DSS_RCH_G1_AFBCD_OFFSET (0x40900)
+#define DSS_RCH_G1_REG_DEFAULT_OFFSET (0x40A00)
+
+#define DSS_RCH_D2_DMA_OFFSET	(0x50000)
+#define DSS_RCH_D2_DFC_OFFSET	(0x50100)
+#define DSS_RCH_D2_CSC_OFFSET	(0x50500)
+#define DSS_RCH_D2_DEBUG_OFFSET	(0x50600)
+#define DSS_RCH_D2_DMA_BUF_OFFSET	(0x50800)
+#define DSS_RCH_D2_AFBCD_OFFSET	(0x50900)
+
+#define DSS_RCH_D3_DMA_OFFSET	(0x51000)
+#define DSS_RCH_D3_DFC_OFFSET	(0x51100)
+#define DSS_RCH_D3_CSC_OFFSET	(0x51500)
+#define DSS_RCH_D3_DEBUG_OFFSET	(0x51600)
+#define DSS_RCH_D3_DMA_BUF_OFFSET	(0x51800)
+#define DSS_RCH_D3_AFBCD_OFFSET	(0x51900)
+
+#define DSS_RCH_D0_DMA_OFFSET	(0x52000)
+#define DSS_RCH_D0_DFC_OFFSET	(0x52100)
+#define DSS_RCH_D0_CSC_OFFSET	(0x52500)
+#define DSS_RCH_D0_DEBUG_OFFSET	(0x52600)
+#define DSS_RCH_D0_DMA_BUF_OFFSET	(0x52800)
+#define DSS_RCH_D0_AFBCD_OFFSET	(0x52900)
+
+#define DSS_RCH_D1_DMA_OFFSET	(0x53000)
+#define DSS_RCH_D1_DFC_OFFSET	(0x53100)
+#define DSS_RCH_D1_CSC_OFFSET	(0x53500)
+#define DSS_RCH_D1_DEBUG_OFFSET	(0x53600)
+#define DSS_RCH_D1_DMA_BUF_OFFSET	(0x53800)
+#define DSS_RCH_D1_AFBCD_OFFSET	(0x53900)
+
+#define DSS_WCH0_DMA_OFFSET	(0x5A000)
+#define DSS_WCH0_DFC_OFFSET	(0x5A100)
+#define DSS_WCH0_CSC_OFFSET	(0x5A500)
+#define DSS_WCH0_ROT_OFFSET	(0x5A500)
+#define DSS_WCH0_DEBUG_OFFSET	(0x5A600)
+#define DSS_WCH0_DMA_BUFFER_OFFSET	(0x5A800)
+#define DSS_WCH0_AFBCE_OFFSET	(0x5A900)
+
+#define DSS_WCH1_DMA_OFFSET	(0x5C000)
+#define DSS_WCH1_DFC_OFFSET	(0x5C100)
+#define DSS_WCH1_CSC_OFFSET	(0x5C500)
+#define DSS_WCH1_ROT_OFFSET	(0x5C500)
+#define DSS_WCH1_DEBUG_OFFSET	(0x5C600)
+#define DSS_WCH1_DMA_BUFFER_OFFSET	(0x5C800)
+#define DSS_WCH1_AFBCE_OFFSET	(0x5C900)
+
+#define DSS_WCH2_DMA_OFFSET	(0x5E000)
+#define DSS_WCH2_DFC_OFFSET	(0x5E100)
+#define DSS_WCH2_CSC_OFFSET	(0x5E500)
+#define DSS_WCH2_ROT_OFFSET	(0x5E500)
+#define DSS_WCH2_DEBUG_OFFSET	(0x5E600)
+#define DSS_WCH2_DMA_BUFFER_OFFSET	(0x5E800)
+#define DSS_WCH2_AFBCE_OFFSET	(0x5E900)
+
+#define DSS_OVL0_OFFSET	(0x60000)
+#define DSS_OVL1_OFFSET	(0x60400)
+#define DSS_OVL2_OFFSET	(0x60800)
+#define DSS_OVL3_OFFSET	(0x60C00)
+
+#define DSS_DBUF0_OFFSET	(0x6D000)
+#define DSS_DBUF1_OFFSET	(0x6E000)
+
+#define DSS_HI_ACE_OFFSET	(0x6F000)
+
+#define DSS_DPP_OFFSET	(0x70000)
+#define DSS_TOP_OFFSET	(0x70000)
+#define DSS_DPP_COLORBAR_OFFSET	(0x70100)
+#define DSS_DPP_DITHER_OFFSET	(0x70200)
+#define DSS_DPP_CSC_RGB2YUV10B_OFFSET	(0x70300)
+#define DSS_DPP_CSC_YUV2RGB10B_OFFSET	(0x70400)
+#define DSS_DPP_DEGAMA_OFFSET	(0x70500)
+#define DSS_DPP_GAMA_OFFSET	(0x70600)
+#define DSS_DPP_ACM_OFFSET	(0x70700)
+#define DSS_DPP_ACE_OFFSET	(0x70800)
+#define DSS_DPP_LCP_OFFSET	(0x70900)
+#define DSS_DPP_ARSR1P_OFFSET	(0x70A00)
+#define DSS_DPP_BITEXT0_OFFSET	(0x70B00)
+#define DSS_DPP_GAMA_LUT_OFFSET	(0x71000)
+#define DSS_DPP_ACM_LUT_OFFSET	(0x72000)
+#define DSS_DPP_LCP_LUT_OFFSET	(0x73000)
+#define DSS_DPP_ACE_LUT_OFFSET	(0x79000)
+#define DSS_DPP_ARSR1P_LUT_OFFSET	(0x7B000)
+
+#define DSS_POST_SCF_OFFSET	DSS_DPP_ARSR1P_OFFSET
+#define DSS_POST_SCF_LUT_OFFSET	DSS_DPP_ARSR1P_LUT_OFFSET
+
+#define DSS_DPP_SBL_OFFSET	(0x7C000)
+#define DSS_LDI0_OFFSET	(0x7D000)
+#define DSS_IFBC_OFFSET	(0x7D800)
+#define DSS_DSC_OFFSET	(0x7DC00)
+#define DSS_LDI1_OFFSET	(0x7E000)
+
+/*******************************************************************************
+ ** GLB
+ */
+#define GLB_DSS_TAG	 (DSS_GLB0_OFFSET + 0x0000)
+
+#define GLB_APB_CTL	 (DSS_GLB0_OFFSET + 0x0004)
+
+#define GLB_DSS_AXI_RST_EN	(DSS_GLB0_OFFSET + 0x0118)
+#define GLB_DSS_APB_RST_EN	(DSS_GLB0_OFFSET + 0x011C)
+#define GLB_DSS_CORE_RST_EN	(DSS_GLB0_OFFSET + 0x0120)
+#define GLB_PXL0_DIV2_RST_EN	(DSS_GLB0_OFFSET + 0x0124)
+#define GLB_PXL0_DIV4_RST_EN	(DSS_GLB0_OFFSET + 0x0128)
+#define GLB_PXL0_RST_EN	(DSS_GLB0_OFFSET + 0x012C)
+#define GLB_PXL0_DSI_RST_EN	(DSS_GLB0_OFFSET + 0x0130)
+#define GLB_DSS_PXL1_RST_EN	(DSS_GLB0_OFFSET + 0x0134)
+#define GLB_MM_AXI_CLK_RST_EN	(DSS_GLB0_OFFSET + 0x0138)
+#define GLB_AFBCD0_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0140)
+#define GLB_AFBCD1_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0144)
+#define GLB_AFBCD2_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0148)
+#define GLB_AFBCD3_IP_RST_EN	(DSS_GLB0_OFFSET + 0x014C)
+#define GLB_AFBCD4_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0150)
+#define GLB_AFBCD5_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0154)
+#define GLB_AFBCD6_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0158)
+#define GLB_AFBCD7_IP_RST_EN	(DSS_GLB0_OFFSET + 0x015C)
+#define GLB_AFBCE0_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0160)
+#define GLB_AFBCE1_IP_RST_EN	(DSS_GLB0_OFFSET + 0x0164)
+
+#define GLB_MCU_PDP_INTS	(DSS_GLB0_OFFSET + 0x20C)
+#define GLB_MCU_PDP_INT_MSK	(DSS_GLB0_OFFSET + 0x210)
+#define GLB_MCU_SDP_INTS	(DSS_GLB0_OFFSET + 0x214)
+#define GLB_MCU_SDP_INT_MSK	(DSS_GLB0_OFFSET + 0x218)
+#define GLB_MCU_OFF_INTS	(DSS_GLB0_OFFSET + 0x21C)
+#define GLB_MCU_OFF_INT_MSK	(DSS_GLB0_OFFSET + 0x220)
+#define GLB_MCU_OFF_CAM_INTS	(DSS_GLB0_OFFSET + 0x2B4)
+#define GLB_MCU_OFF_CAM_INT_MSK	(DSS_GLB0_OFFSET + 0x2B8)
+#define GLB_CPU_PDP_INTS	(DSS_GLB0_OFFSET + 0x224)
+#define GLB_CPU_PDP_INT_MSK	(DSS_GLB0_OFFSET + 0x228)
+#define GLB_CPU_SDP_INTS	(DSS_GLB0_OFFSET + 0x22C)
+#define GLB_CPU_SDP_INT_MSK	(DSS_GLB0_OFFSET + 0x230)
+#define GLB_CPU_OFF_INTS	(DSS_GLB0_OFFSET + 0x234)
+#define GLB_CPU_OFF_INT_MSK	(DSS_GLB0_OFFSET + 0x238)
+#define GLB_CPU_OFF_CAM_INTS	(DSS_GLB0_OFFSET + 0x2AC)
+#define GLB_CPU_OFF_CAM_INT_MSK	(DSS_GLB0_OFFSET + 0x2B0)
+
+#define GLB_MODULE_CLK_SEL	(DSS_GLB0_OFFSET + 0x0300)
+#define GLB_MODULE_CLK_EN	(DSS_GLB0_OFFSET + 0x0304)
+
+#define GLB_GLB0_DBG_SEL	(DSS_GLB0_OFFSET + 0x310)
+#define GLB_GLB1_DBG_SEL	(DSS_GLB0_OFFSET + 0x314)
+#define GLB_DBG_IRQ_CPU	(DSS_GLB0_OFFSET + 0x320)
+#define GLB_DBG_IRQ_MCU	(DSS_GLB0_OFFSET + 0x324)
+
+#define GLB_TP_SEL	(DSS_GLB0_OFFSET + 0x0400)
+#define GLB_CRC_DBG_LDI0	(DSS_GLB0_OFFSET + 0x0404)
+#define GLB_CRC_DBG_LDI1	(DSS_GLB0_OFFSET + 0x0408)
+#define GLB_CRC_LDI0_EN	(DSS_GLB0_OFFSET + 0x040C)
+#define GLB_CRC_LDI0_FRM	(DSS_GLB0_OFFSET + 0x0410)
+#define GLB_CRC_LDI1_EN	(DSS_GLB0_OFFSET + 0x0414)
+#define GLB_CRC_LDI1_FRM	(DSS_GLB0_OFFSET + 0x0418)
+
+#define GLB_DSS_MEM_CTRL	(DSS_GLB0_OFFSET + 0x0600)
+#define GLB_DSS_PM_CTRL	(DSS_GLB0_OFFSET + 0x0604)
+
+/*******************************************************************************
+ ** DBG
+ */
+#define DBG_CRC_DBG_OV0	(0x0000)
+#define DBG_CRC_DBG_OV1	(0x0004)
+#define DBG_CRC_DBG_SUM	(0x0008)
+#define DBG_CRC_OV0_EN	(0x000C)
+#define DBG_DSS_GLB_DBG_O	(0x0010)
+#define DBG_DSS_GLB_DBG_I	(0x0014)
+#define DBG_CRC_OV0_FRM	(0x0018)
+#define DBG_CRC_OV1_EN	(0x001C)
+#define DBG_CRC_OV1_FRM	(0x0020)
+#define DBG_CRC_SUM_EN	(0x0024)
+#define DBG_CRC_SUM_FRM	(0x0028)
+
+#define DBG_MCTL_INTS	(0x023C)
+#define DBG_MCTL_INT_MSK	(0x0240)
+#define DBG_WCH0_INTS	(0x0244)
+#define DBG_WCH0_INT_MSK	(0x0248)
+#define DBG_WCH1_INTS	(0x024C)
+#define DBG_WCH1_INT_MSK	(0x0250)
+#define DBG_RCH0_INTS	(0x0254)
+#define DBG_RCH0_INT_MSK	(0x0258)
+#define DBG_RCH1_INTS	(0x025C)
+#define DBG_RCH1_INT_MSK	(0x0260)
+#define DBG_RCH2_INTS	(0x0264)
+#define DBG_RCH2_INT_MSK	(0x0268)
+#define DBG_RCH3_INTS	(0x026C)
+#define DBG_RCH3_INT_MSK	(0x0270)
+#define DBG_RCH4_INTS	(0x0274)
+#define DBG_RCH4_INT_MSK	(0x0278)
+#define DBG_RCH5_INTS	(0x027C)
+#define DBG_RCH5_INT_MSK	(0x0280)
+#define DBG_RCH6_INTS	(0x0284)
+#define DBG_RCH6_INT_MSK	(0x0288)
+#define DBG_RCH7_INTS	(0x028C)
+#define DBG_RCH7_INT_MSK	(0x0290)
+#define DBG_DSS_GLB_INTS	(0x0294)
+#define DBG_DSS_GLB_INT_MSK	(0x0298)
+#define DBG_WCH2_INTS	(0x029C)
+#define DBG_WCH2_INT_MSK	(0x02A0)
+#define DBG_RCH8_INTS	(0x02A4)
+#define DBG_RCH8_INT_MSK	(0x02A8)
+
+/*******************************************************************************
+ ** CMDLIST
+ */
+
+#define CMDLIST_CH0_PENDING_CLR	(0x0000)
+#define CMDLIST_CH0_CTRL	(0x0004)
+#define CMDLIST_CH0_STATUS	(0x0008)
+#define CMDLIST_CH0_STAAD	(0x000C)
+#define CMDLIST_CH0_CURAD	(0x0010)
+#define CMDLIST_CH0_INTE	(0x0014)
+#define CMDLIST_CH0_INTC	(0x0018)
+#define CMDLIST_CH0_INTS	(0x001C)
+#define CMDLIST_CH0_SCENE	(0x0020)
+#define CMDLIST_CH0_DBG	(0x0028)
+
+#define CMDLIST_DBG	(0x0700)
+#define CMDLIST_BUF_DBG_EN	(0x0704)
+#define CMDLIST_BUF_DBG_CNT_CLR	(0x0708)
+#define CMDLIST_BUF_DBG_CNT	(0x070C)
+#define CMDLIST_TIMEOUT_TH	(0x0710)
+#define CMDLIST_START	(0x0714)
+#define CMDLIST_ADDR_MASK_EN	(0x0718)
+#define CMDLIST_ADDR_MASK_DIS	(0x071C)
+#define CMDLIST_ADDR_MASK_STATUS	(0x0720)
+#define CMDLIST_TASK_CONTINUE	(0x0724)
+#define CMDLIST_TASK_STATUS	(0x0728)
+#define CMDLIST_CTRL	(0x072C)
+#define CMDLIST_SECU	(0x0730)
+#define CMDLIST_INTS	(0x0734)
+#define CMDLIST_SWRST	(0x0738)
+#define CMD_MEM_CTRL	(0x073C)
+#define CMD_CLK_SEL		(0x0740)
+#define CMD_CLK_EN	(0x0744)
+
+#define HISI_DSS_MIN_ROT_AFBCE_BLOCK_SIZE (256)
+#define HISI_DSS_MAX_ROT_AFBCE_BLOCK_SIZE (480)
+
+#define BIT_CMDLIST_CH_TASKDONE_INTS	    BIT(7)
+#define BIT_CMDLIST_CH_TIMEOUT_INTS	    BIT(6)
+#define BIT_CMDLIST_CH_BADCMD_INTS	    BIT(5)
+#define BIT_CMDLIST_CH_START_INTS	           BIT(4)
+#define BIT_CMDLIST_CH_PENDING_INTS	    BIT(3)
+#define BIT_CMDLIST_CH_AXIERR_INTS	    BIT(2)
+#define BIT_CMDLIST_CH_ALLDONE_INTS	    BIT(1)
+#define BIT_CMDLIST_CH_ONEDONE_INTS	    BIT(0)
+
+#define BIT_CMDLIST_CH15_INTS	BIT(15)
+#define BIT_CMDLIST_CH14_INTS	BIT(14)
+#define BIT_CMDLIST_CH13_INTS	BIT(13)
+#define BIT_CMDLIST_CH12_INTS	BIT(12)
+#define BIT_CMDLIST_CH11_INTS	BIT(11)
+#define BIT_CMDLIST_CH10_INTS	BIT(10)
+#define BIT_CMDLIST_CH9_INTS	BIT(9)
+#define BIT_CMDLIST_CH8_INTS	BIT(8)
+#define BIT_CMDLIST_CH7_INTS	BIT(7)
+#define BIT_CMDLIST_CH6_INTS	BIT(6)
+#define BIT_CMDLIST_CH5_INTS	BIT(5)
+#define BIT_CMDLIST_CH4_INTS	BIT(4)
+#define BIT_CMDLIST_CH3_INTS	BIT(3)
+#define BIT_CMDLIST_CH2_INTS	BIT(2)
+#define BIT_CMDLIST_CH1_INTS	BIT(1)
+#define BIT_CMDLIST_CH0_INTS	BIT(0)
+
+/*******************************************************************************
+ ** AIF
+ */
+#define AIF0_CH0_OFFSET	(DSS_VBIF0_AIF + 0x00)
+#define AIF0_CH0_ADD_OFFSET	(DSS_VBIF0_AIF + 0x04)
+#define AIF0_CH1_OFFSET	(DSS_VBIF0_AIF + 0x20)
+#define AIF0_CH1_ADD_OFFSET	(DSS_VBIF0_AIF + 0x24)
+#define AIF0_CH2_OFFSET	(DSS_VBIF0_AIF + 0x40)
+#define AIF0_CH2_ADD_OFFSET	(DSS_VBIF0_AIF + 0x44)
+#define AIF0_CH3_OFFSET	(DSS_VBIF0_AIF + 0x60)
+#define AIF0_CH3_ADD_OFFSET	(DSS_VBIF0_AIF + 0x64)
+#define AIF0_CH4_OFFSET	(DSS_VBIF0_AIF + 0x80)
+#define AIF0_CH4_ADD_OFFSET	(DSS_VBIF0_AIF + 0x84)
+#define AIF0_CH5_OFFSET	(DSS_VBIF0_AIF + 0xA0)
+#define AIF0_CH5_ADD_OFFSET	(DSS_VBIF0_AIF + 0xa4)
+#define AIF0_CH6_OFFSET	(DSS_VBIF0_AIF + 0xC0)
+#define AIF0_CH6_ADD_OFFSET	(DSS_VBIF0_AIF + 0xc4)
+#define AIF0_CH7_OFFSET	(DSS_VBIF0_AIF + 0xE0)
+#define AIF0_CH7_ADD_OFFSET	(DSS_VBIF0_AIF + 0xe4)
+#define AIF0_CH8_OFFSET	(DSS_VBIF0_AIF + 0x100)
+#define AIF0_CH8_ADD_OFFSET	(DSS_VBIF0_AIF + 0x104)
+#define AIF0_CH9_OFFSET	(DSS_VBIF0_AIF + 0x120)
+#define AIF0_CH9_ADD_OFFSET	(DSS_VBIF0_AIF + 0x124)
+#define AIF0_CH10_OFFSET	(DSS_VBIF0_AIF + 0x140)
+#define AIF0_CH10_ADD_OFFSET	(DSS_VBIF0_AIF + 0x144)
+#define AIF0_CH11_OFFSET	(DSS_VBIF0_AIF + 0x160)
+#define AIF0_CH11_ADD_OFFSET	(DSS_VBIF0_AIF + 0x164)
+#define AIF0_CH12_OFFSET	(DSS_VBIF0_AIF + 0x180)
+#define AIF0_CH12_ADD_OFFSET	(DSS_VBIF0_AIF + 0x184)
+
+#define AIF1_CH0_OFFSET	(DSS_VBIF1_AIF + 0x00)
+#define AIF1_CH0_ADD_OFFSET	(DSS_VBIF1_AIF + 0x04)
+#define AIF1_CH1_OFFSET	(DSS_VBIF1_AIF + 0x20)
+#define AIF1_CH1_ADD_OFFSET	(DSS_VBIF1_AIF + 0x24)
+#define AIF1_CH2_OFFSET	(DSS_VBIF1_AIF + 0x40)
+#define AIF1_CH2_ADD_OFFSET	(DSS_VBIF1_AIF + 0x44)
+#define AIF1_CH3_OFFSET	(DSS_VBIF1_AIF + 0x60)
+#define AIF1_CH3_ADD_OFFSET	(DSS_VBIF1_AIF + 0x64)
+#define AIF1_CH4_OFFSET	(DSS_VBIF1_AIF + 0x80)
+#define AIF1_CH4_ADD_OFFSET	(DSS_VBIF1_AIF + 0x84)
+#define AIF1_CH5_OFFSET	(DSS_VBIF1_AIF + 0xA0)
+#define AIF1_CH5_ADD_OFFSET	(DSS_VBIF1_AIF + 0xa4)
+#define AIF1_CH6_OFFSET	(DSS_VBIF1_AIF + 0xC0)
+#define AIF1_CH6_ADD_OFFSET	(DSS_VBIF1_AIF + 0xc4)
+#define AIF1_CH7_OFFSET	(DSS_VBIF1_AIF + 0xE0)
+#define AIF1_CH7_ADD_OFFSET	(DSS_VBIF1_AIF + 0xe4)
+#define AIF1_CH8_OFFSET	(DSS_VBIF1_AIF + 0x100)
+#define AIF1_CH8_ADD_OFFSET	(DSS_VBIF1_AIF + 0x104)
+#define AIF1_CH9_OFFSET	(DSS_VBIF1_AIF + 0x120)
+#define AIF1_CH9_ADD_OFFSET	(DSS_VBIF1_AIF + 0x124)
+#define AIF1_CH10_OFFSET	(DSS_VBIF1_AIF + 0x140)
+#define AIF1_CH10_ADD_OFFSET	(DSS_VBIF1_AIF + 0x144)
+#define AIF1_CH11_OFFSET	(DSS_VBIF1_AIF + 0x160)
+#define AIF1_CH11_ADD_OFFSET	(DSS_VBIF1_AIF + 0x164)
+#define AIF1_CH12_OFFSET	(DSS_VBIF1_AIF + 0x180)
+#define AIF1_CH12_ADD_OFFSET	(DSS_VBIF1_AIF + 0x184)
+
+/* aif dmax */
+
+#define AIF_CH_CTL	(0x0000)
+
+#define AIF_CH_CTL_ADD (0x0004)
+
+/* aif common */
+#define AXI0_RID_MSK0	(0x0800)
+#define AXI0_RID_MSK1	(0x0804)
+#define AXI0_WID_MSK	(0x0808)
+#define AXI0_R_QOS_MAP	(0x080c)
+#define AXI1_RID_MSK0	(0x0810)
+#define AXI1_RID_MSK1	(0x0814)
+#define AXI1_WID_MSK	(0x0818)
+#define AXI1_R_QOS_MAP	(0x081c)
+#define AIF_CLK_SEL0	(0x0820)
+#define AIF_CLK_SEL1	(0x0824)
+#define AIF_CLK_EN0	(0x0828)
+#define AIF_CLK_EN1	(0x082c)
+#define MONITOR_CTRL	(0x0830)
+#define MONITOR_TIMER_INI	(0x0834)
+#define DEBUG_BUF_BASE	(0x0838)
+#define DEBUG_CTRL	(0x083C)
+#define AIF_SHADOW_READ	(0x0840)
+#define AIF_MEM_CTRL	(0x0844)
+#define AIF_MONITOR_EN	(0x0848)
+#define AIF_MONITOR_CTRL	(0x084C)
+#define AIF_MONITOR_SAMPLE_MUN	(0x0850)
+#define AIF_MONITOR_SAMPLE_TIME	(0x0854)
+#define AIF_MONITOR_SAMPLE_FLOW	(0x0858)
+
+/* aif debug */
+#define AIF_MONITOR_READ_DATA	(0x0880)
+#define AIF_MONITOR_WRITE_DATA	(0x0884)
+#define AIF_MONITOR_WINDOW_CYCLE	(0x0888)
+#define AIF_MONITOR_WBURST_CNT	(0x088C)
+#define AIF_MONITOR_MIN_WR_CYCLE	(0x0890)
+#define AIF_MONITOR_MAX_WR_CYCLE	(0x0894)
+#define AIF_MONITOR_AVR_WR_CYCLE	(0x0898)
+#define AIF_MONITOR_MIN_WRW_CYCLE	(0x089C)
+#define AIF_MONITOR_MAX_WRW_CYCLE	(0x08A0)
+#define AIF_MONITOR_AVR_WRW_CYCLE	(0x08A4)
+#define AIF_MONITOR_RBURST_CNT	(0x08A8)
+#define AIF_MONITOR_MIN_RD_CYCLE	(0x08AC)
+#define AIF_MONITOR_MAX_RD_CYCLE	(0x08B0)
+#define AIF_MONITOR_AVR_RD_CYCLE	(0x08B4)
+#define AIF_MONITOR_MIN_RDW_CYCLE	(0x08B8)
+#define AIF_MONITOR_MAX_RDW_CYCLE	(0x08BC)
+#define AIF_MONITOR_AVR_RDW_CYCLE	(0x08C0)
+#define AIF_CH_STAT_0	(0x08C4)
+#define AIF_CH_STAT_1	(0x08C8)
+
+#define AIF_MODULE_CLK_SEL	(0x0A04)
+#define AIF_MODULE_CLK_EN	(0x0A08)
+
+typedef struct dss_aif {
+	u32 aif_ch_ctl;
+	u32 aif_ch_ctl_add;
+} dss_aif_t;
+
+typedef struct dss_aif_bw {
+	u64 bw;
+	u8 chn_idx;
+	s8 axi_sel;
+	u8 is_used;
+} dss_aif_bw_t;
+
+/*******************************************************************************
+ ** MIF
+ */
+#define MIF_ENABLE	(0x0000)
+#define MIF_MEM_CTRL	(0x0004)
+
+#define MIF_CTRL0	(0x000)
+#define MIF_CTRL1	(0x004)
+#define MIF_CTRL2	(0x008)
+#define MIF_CTRL3	(0x00C)
+#define MIF_CTRL4	(0x010)
+#define MIF_CTRL5	(0x014)
+#define REG_DEFAULT (0x0500)
+#define MIF_SHADOW_READ	(0x0504)
+#define MIF_CLK_CTL	(0x0508)
+
+#define MIF_STAT0	(0x0600)
+
+#define MIF_STAT1	(0x0604)
+
+#define MIF_STAT2	(0x0608)
+
+#define MIF_CTRL_OFFSET	(0x20)
+#define MIF_CH0_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 1)
+#define MIF_CH1_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 2)
+#define MIF_CH2_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 3)
+#define MIF_CH3_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 4)
+#define MIF_CH4_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 5)
+#define MIF_CH5_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 6)
+#define MIF_CH6_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 7)
+#define MIF_CH7_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 8)
+#define MIF_CH8_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 9)
+#define MIF_CH9_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 10)
+#define MIF_CH10_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 11)
+#define MIF_CH11_OFFSET	(DSS_MIF_OFFSET + MIF_CTRL_OFFSET * 12)
+#define MIF_CTRL_NUM	(12)
+
+#define LITTLE_LAYER_BUF_SIZE	(256 * 1024)
+#define MIF_STRIDE_UNIT (4 * 1024)
+
+typedef struct dss_mif {
+	u32 mif_ctrl1;
+	u32 mif_ctrl2;
+	u32 mif_ctrl3;
+	u32 mif_ctrl4;
+	u32 mif_ctrl5;
+} dss_mif_t;
+
+/*
+ ** stretch blt, linear/tile, rotation, pixel format
+ ** 0 0 000
+ */
+enum dss_mmu_tlb_tag_org {
+	MMU_TLB_TAG_ORG_0x0 = 0x0,
+	MMU_TLB_TAG_ORG_0x1 = 0x1,
+	MMU_TLB_TAG_ORG_0x2 = 0x2,
+	MMU_TLB_TAG_ORG_0x3 = 0x3,
+	MMU_TLB_TAG_ORG_0x4 = 0x4,
+	MMU_TLB_TAG_ORG_0x7 = 0x7,
+
+	MMU_TLB_TAG_ORG_0x8 = 0x8,
+	MMU_TLB_TAG_ORG_0x9 = 0x9,
+	MMU_TLB_TAG_ORG_0xA = 0xA,
+	MMU_TLB_TAG_ORG_0xB = 0xB,
+	MMU_TLB_TAG_ORG_0xC = 0xC,
+	MMU_TLB_TAG_ORG_0xF = 0xF,
+
+	MMU_TLB_TAG_ORG_0x10 = 0x10,
+	MMU_TLB_TAG_ORG_0x11 = 0x11,
+	MMU_TLB_TAG_ORG_0x12 = 0x12,
+	MMU_TLB_TAG_ORG_0x13 = 0x13,
+	MMU_TLB_TAG_ORG_0x14 = 0x14,
+	MMU_TLB_TAG_ORG_0x17 = 0x17,
+
+	MMU_TLB_TAG_ORG_0x18 = 0x18,
+	MMU_TLB_TAG_ORG_0x19 = 0x19,
+	MMU_TLB_TAG_ORG_0x1A = 0x1A,
+	MMU_TLB_TAG_ORG_0x1B = 0x1B,
+	MMU_TLB_TAG_ORG_0x1C = 0x1C,
+	MMU_TLB_TAG_ORG_0x1F = 0x1F,
+};
+
+/*******************************************************************************
+ **SMMU
+ */
+#define SMMU_SCR	(0x0000)
+#define SMMU_MEMCTRL	(0x0004)
+#define SMMU_LP_CTRL	(0x0008)
+#define SMMU_PRESS_REMAP	(0x000C)
+#define SMMU_INTMASK_NS	(0x0010)
+#define SMMU_INTRAW_NS	(0x0014)
+#define SMMU_INTSTAT_NS	(0x0018)
+#define SMMU_INTCLR_NS	(0x001C)
+
+#define SMMU_SMRx_NS	(0x0020)
+#define SMMU_RLD_EN0_NS	(0x01F0)
+#define SMMU_RLD_EN1_NS	(0x01F4)
+#define SMMU_RLD_EN2_NS	(0x01F8)
+#define SMMU_CB_SCTRL	(0x0200)
+#define SMMU_CB_TTBR0	(0x0204)
+#define SMMU_CB_TTBR1	(0x0208)
+#define SMMU_CB_TTBCR	(0x020C)
+#define SMMU_OFFSET_ADDR_NS	(0x0210)
+#define SMMU_SCACHEI_ALL	(0x0214)
+#define SMMU_SCACHEI_L1	(0x0218)
+#define SMMU_SCACHEI_L2L3	(0x021C)
+#define SMMU_FAMA_CTRL0	(0x0220)
+#define SMMU_FAMA_CTRL1	(0x0224)
+#define SMMU_ADDR_MSB	(0x0300)
+#define SMMU_ERR_RDADDR	(0x0304)
+#define SMMU_ERR_WRADDR	(0x0308)
+#define SMMU_FAULT_ADDR_TCU (0x0310)
+#define SMMU_FAULT_ID_TCU	(0x0314)
+
+#define SMMU_FAULT_ADDR_TBUx	(0x0320)
+#define SMMU_FAULT_ID_TBUx	(0x0324)
+#define SMMU_FAULT_INFOx	(0x0328)
+#define SMMU_DBGRPTR_TLB	(0x0380)
+#define SMMU_DBGRDATA_TLB	(0x0380)
+#define SMMU_DBGRDATA0_CACHE	(0x038C)
+#define SMMU_DBGRDATA1_CACHE	(0x0390)
+#define SMMU_DBGAXI_CTRL	(0x0394)
+#define SMMU_OVA_ADDR	(0x0398)
+#define SMMU_OPA_ADDR	(0x039C)
+#define SMMU_OVA_CTRL	(0x03A0)
+#define SMMU_OPREF_ADDR	(0x03A4)
+#define SMMU_OPREF_CTRL	(0x03A8)
+#define SMMU_OPREF_CNT	(0x03AC)
+
+#define SMMU_SMRx_S	(0x0500)
+#define SMMU_RLD_EN0_S	(0x06F0)
+#define SMMU_RLD_EN1_S	(0x06F4)
+#define SMMU_RLD_EN2_S	(0x06F8)
+#define SMMU_INTMAS_S	(0x0700)
+#define SMMU_INTRAW_S	(0x0704)
+#define SMMU_INTSTAT_S	(0x0708)
+#define SMMU_INTCLR_S	(0x070C)
+#define SMMU_SCR_S	(0x0710)
+#define SMMU_SCB_SCTRL	(0x0714)
+#define SMMU_SCB_TTBR	(0x0718)
+#define SMMU_SCB_TTBCR	(0x071C)
+#define SMMU_OFFSET_ADDR_S	(0x0720)
+
+#define SMMU_SID_NUM	(64)
+
+typedef struct dss_smmu {
+	u32 smmu_scr;
+	u32 smmu_memctrl;
+	u32 smmu_lp_ctrl;
+	u32 smmu_press_remap;
+	u32 smmu_intmask_ns;
+	u32 smmu_intraw_ns;
+	u32 smmu_intstat_ns;
+	u32 smmu_intclr_ns;
+	u32 smmu_smrx_ns[SMMU_SID_NUM];
+	u32 smmu_rld_en0_ns;
+	u32 smmu_rld_en1_ns;
+	u32 smmu_rld_en2_ns;
+	u32 smmu_cb_sctrl;
+	u32 smmu_cb_ttbr0;
+	u32 smmu_cb_ttbr1;
+	u32 smmu_cb_ttbcr;
+	u32 smmu_offset_addr_ns;
+	u32 smmu_scachei_all;
+	u32 smmu_scachei_l1;
+	u32 smmu_scachei_l2l3;
+	u32 smmu_fama_ctrl0_ns;
+	u32 smmu_fama_ctrl1_ns;
+	u32 smmu_addr_msb;
+	u32 smmu_err_rdaddr;
+	u32 smmu_err_wraddr;
+	u32 smmu_fault_addr_tcu;
+	u32 smmu_fault_id_tcu;
+	u32 smmu_fault_addr_tbux;
+	u32 smmu_fault_id_tbux;
+	u32 smmu_fault_infox;
+	u32 smmu_dbgrptr_tlb;
+	u32 smmu_dbgrdata_tlb;
+	u32 smmu_dbgrptr_cache;
+	u32 smmu_dbgrdata0_cache;
+	u32 smmu_dbgrdata1_cache;
+	u32 smmu_dbgaxi_ctrl;
+	u32 smmu_ova_addr;
+	u32 smmu_opa_addr;
+	u32 smmu_ova_ctrl;
+	u32 smmu_opref_addr;
+	u32 smmu_opref_ctrl;
+	u32 smmu_opref_cnt;
+	u32 smmu_smrx_s[SMMU_SID_NUM];
+	u32 smmu_rld_en0_s;
+	u32 smmu_rld_en1_s;
+	u32 smmu_rld_en2_s;
+	u32 smmu_intmas_s;
+	u32 smmu_intraw_s;
+	u32 smmu_intstat_s;
+	u32 smmu_intclr_s;
+	u32 smmu_scr_s;
+	u32 smmu_scb_sctrl;
+	u32 smmu_scb_ttbr;
+	u32 smmu_scb_ttbcr;
+	u32 smmu_offset_addr_s;
+
+	u8 smmu_smrx_ns_used[DSS_CHN_MAX_DEFINE];
+} dss_smmu_t;
+
+/*******************************************************************************
+ ** RDMA
+ */
+
+#define DMA_OFT_X0	(0x0000)
+#define DMA_OFT_Y0	(0x0004)
+#define DMA_OFT_X1	(0x0008)
+#define DMA_OFT_Y1	(0x000C)
+#define DMA_MASK0	(0x0010)
+#define DMA_MASK1	(0x0014)
+#define DMA_STRETCH_SIZE_VRT	(0x0018)
+#define DMA_CTRL	(0x001C)
+#define DMA_TILE_SCRAM	(0x0020)
+
+#define DMA_PULSE	(0x0028)
+#define DMA_CORE_GT	(0x002C)
+#define RWCH_CFG0	(0x0030)
+
+#define WDMA_DMA_SW_MASK_EN	(0x004C)
+#define WDMA_DMA_START_MASK0	(0x0050)
+#define WDMA_DMA_END_MASK0	(0x0054)
+#define WDMA_DMA_START_MASK1	(0x0058)
+#define WDMA_DMA_END_MASK1	(0x005C)
+
+#define DMA_DATA_ADDR0	(0x0060)
+#define DMA_STRIDE0	(0x0064)
+#define DMA_STRETCH_STRIDE0	(0x0068)
+#define DMA_DATA_NUM0	(0x006C)
+
+#define DMA_TEST0	(0x0070)
+#define DMA_TEST1	(0x0074)
+#define DMA_TEST3	(0x0078)
+#define DMA_TEST4	(0x007C)
+#define DMA_STATUS_Y	(0x0080)
+
+#define DMA_DATA_ADDR1	(0x0084)
+#define DMA_STRIDE1	(0x0088)
+#define DMA_STRETCH_STRIDE1	(0x008C)
+#define DMA_DATA_NUM1	(0x0090)
+
+#define DMA_TEST0_U	(0x0094)
+#define DMA_TEST1_U	(0x0098)
+#define DMA_TEST3_U	(0x009C)
+#define DMA_TEST4_U	(0x00A0)
+#define DMA_STATUS_U	(0x00A4)
+
+#define DMA_DATA_ADDR2	(0x00A8)
+#define DMA_STRIDE2	(0x00AC)
+#define DMA_STRETCH_STRIDE2	(0x00B0)
+#define DMA_DATA_NUM2	(0x00B4)
+
+#define DMA_TEST0_V	(0x00B8)
+#define DMA_TEST1_V	(0x00BC)
+#define DMA_TEST3_V	(0x00C0)
+#define DMA_TEST4_V	(0x00C4)
+#define DMA_STATUS_V	(0x00C8)
+
+#define CH_RD_SHADOW	(0x00D0)
+#define CH_CTL	(0x00D4)
+#define CH_SECU_EN	(0x00D8)
+#define CH_SW_END_REQ	(0x00DC)
+#define CH_CLK_SEL	(0x00E0)
+#define CH_CLK_EN	(0x00E4)
+
+/*******************************************************************************
+ ** DFC
+ */
+#define DFC_DISP_SIZE	(0x0000)
+#define DFC_PIX_IN_NUM	(0x0004)
+#define DFC_GLB_ALPHA	(0x0008)
+#define DFC_DISP_FMT	(0x000C)
+#define DFC_CLIP_CTL_HRZ	(0x0010)
+#define DFC_CLIP_CTL_VRZ	(0x0014)
+#define DFC_CTL_CLIP_EN	(0x0018)
+#define DFC_ICG_MODULE	(0x001C)
+#define DFC_DITHER_ENABLE	(0x0020)
+#define DFC_PADDING_CTL	(0x0024)
+
+typedef struct dss_dfc {
+	u32 disp_size;
+	u32 pix_in_num;
+	u32 disp_fmt;
+	u32 clip_ctl_hrz;
+	u32 clip_ctl_vrz;
+	u32 ctl_clip_en;
+	u32 icg_module;
+	u32 dither_enable;
+	u32 padding_ctl;
+} dss_dfc_t;
+
+/*******************************************************************************
+ ** SCF
+ */
+#define DSS_SCF_H0_Y_COEF_OFFSET	(0x0000)
+#define DSS_SCF_Y_COEF_OFFSET	(0x2000)
+#define DSS_SCF_UV_COEF_OFFSET	(0x2800)
+
+#define SCF_EN_HSCL_STR	(0x0000)
+#define SCF_EN_VSCL_STR	(0x0004)
+#define SCF_H_V_ORDER	(0x0008)
+#define SCF_SCF_CORE_GT	(0x000C)
+#define SCF_INPUT_WIDTH_HEIGHT	(0x0010)
+#define SCF_OUTPUT_WIDTH_HEIGHT	(0x0014)
+#define SCF_COEF_MEM_CTRL  (0x0018)
+#define SCF_EN_HSCL	(0x001C)
+#define SCF_EN_VSCL	(0x0020)
+#define SCF_ACC_HSCL	(0x0024)
+#define SCF_ACC_HSCL1	(0x0028)
+#define SCF_INC_HSCL	(0x0034)
+#define SCF_ACC_VSCL	(0x0038)
+#define SCF_ACC_VSCL1	(0x003C)
+#define SCF_INC_VSCL	(0x0048)
+#define SCF_EN_NONLINEAR	(0x004C)
+#define SCF_EN_MMP	(0x007C)
+#define SCF_DB_H0	(0x0080)
+#define SCF_DB_H1	(0x0084)
+#define SCF_DB_V0	(0x0088)
+#define SCF_DB_V1	(0x008C)
+#define SCF_LB_MEM_CTRL	(0x0090)
+#define SCF_RD_SHADOW	(0x00F0)
+#define SCF_CLK_SEL	(0x00F8)
+#define SCF_CLK_EN	(0x00FC)
+
+/* MACROS */
+#define SCF_MIN_INPUT	(16)
+#define SCF_MIN_OUTPUT	(16)
+
+/* Threshold for SCF Stretch and SCF filter */
+#define RDMA_STRETCH_THRESHOLD	(2)
+#define SCF_INC_FACTOR	(1 << 18)
+#define SCF_UPSCALE_MAX	(60)
+#define SCF_DOWNSCALE_MAX	  (60)
+#define SCF_EDGE_FACTOR (3)
+#define ARSR2P_INC_FACTOR (65536)
+
+typedef struct dss_scl {
+	u32 en_hscl_str;
+	u32 en_vscl_str;
+	u32 h_v_order;
+	u32 input_width_height;
+	u32 output_width_height;
+	u32 en_hscl;
+	u32 en_vscl;
+	u32 acc_hscl;
+	u32 inc_hscl;
+	u32 inc_vscl;
+	u32 en_mmp;
+	u32 scf_ch_core_gt;
+	u32 fmt;
+} dss_scl_t;
+
+enum scl_coef_lut_idx {
+	SCL_COEF_NONE_IDX = -1,
+	SCL_COEF_YUV_IDX = 0,
+	SCL_COEF_RGB_IDX = 1,
+	SCL_COEF_IDX_MAX = 2,
+};
+
+/*******************************************************************************
+ ** ARSR2P  v0
+ */
+#define ARSR2P_INPUT_WIDTH_HEIGHT		(0x000)
+#define ARSR2P_OUTPUT_WIDTH_HEIGHT		(0x004)
+#define ARSR2P_IHLEFT		(0x008)
+#define ARSR2P_IHRIGHT		(0x00C)
+#define ARSR2P_IVTOP		(0x010)
+#define ARSR2P_IVBOTTOM		(0x014)
+#define ARSR2P_IHINC		(0x018)
+#define ARSR2P_IVINC		(0x01C)
+#define ARSR2P_UV_OFFSET		(0x020)
+#define ARSR2P_MODE		(0x024)
+#define ARSR2P_SKIN_THRES_Y		(0x028)
+#define ARSR2P_SKIN_THRES_U		(0x02C)
+#define ARSR2P_SKIN_THRES_V		(0x030)
+#define ARSR2P_SKIN_CFG0		(0x034)
+#define ARSR2P_SKIN_CFG1		(0x038)
+#define ARSR2P_SKIN_CFG2		(0x03C)
+#define ARSR2P_SHOOT_CFG1		(0x040)
+#define ARSR2P_SHOOT_CFG2		(0x044)
+#define ARSR2P_SHARP_CFG1		(0x048)
+#define ARSR2P_SHARP_CFG2		(0x04C)
+#define ARSR2P_SHARP_CFG3		(0x050)
+#define ARSR2P_SHARP_CFG4		(0x054)
+#define ARSR2P_SHARP_CFG5		(0x058)
+#define ARSR2P_SHARP_CFG6		(0x05C)
+#define ARSR2P_SHARP_CFG7		(0x060)
+#define ARSR2P_SHARP_CFG8		(0x064)
+#define ARSR2P_SHARP_CFG9		(0x068)
+#define ARSR2P_TEXTURW_ANALYSTS		(0x06C)
+#define ARSR2P_INTPLSHOOTCTRL		(0x070)
+#define ARSR2P_DEBUG0		(0x074)
+#define ARSR2P_DEBUG1		(0x078)
+#define ARSR2P_DEBUG2		(0x07C)
+#define ARSR2P_DEBUG3		(0x080)
+#define ARSR2P_LB_MEM_CTRL		(0x084)
+#define ARSR2P_IHLEFT1		(0x088)
+#define ARSR2P_IHRIGHT1		(0x090)
+#define ARSR2P_IVBOTTOM1		(0x094)
+
+#define ARSR2P_LUT_COEFY_V_OFFSET (0x0000)
+#define ARSR2P_LUT_COEFY_H_OFFSET (0x0100)
+#define ARSR2P_LUT_COEFA_V_OFFSET (0x0300)
+#define ARSR2P_LUT_COEFA_H_OFFSET (0x0400)
+#define ARSR2P_LUT_COEFUV_V_OFFSET (0x0600)
+#define ARSR2P_LUT_COEFUV_H_OFFSET (0x0700)
+
+typedef struct dss_arsr2p_effect {
+	u32 skin_thres_y;
+	u32 skin_thres_u;
+	u32 skin_thres_v;
+	u32 skin_cfg0;
+	u32 skin_cfg1;
+	u32 skin_cfg2;
+	u32 shoot_cfg1;
+	u32 shoot_cfg2;
+	u32 sharp_cfg1;
+	u32 sharp_cfg2;
+	u32 sharp_cfg3;
+	u32 sharp_cfg4;
+	u32 sharp_cfg5;
+	u32 sharp_cfg6;
+	u32 sharp_cfg7;
+	u32 sharp_cfg8;
+	u32 sharp_cfg9;
+	u32 texturw_analysts;
+	u32 intplshootctrl;
+} dss_arsr2p_effect_t;
+
+typedef struct dss_arsr2p {
+	u32 arsr_input_width_height;
+	u32 arsr_output_width_height;
+	u32 ihleft;
+	u32 ihright;
+	u32 ivtop;
+	u32 ivbottom;
+	u32 ihinc;
+	u32 ivinc;
+	u32 offset;
+	u32 mode;
+	dss_arsr2p_effect_t arsr2p_effect;
+	u32 ihleft1;
+	u32 ihright1;
+	u32 ivbottom1;
+} dss_arsr2p_t;
+
+/*******************************************************************************
+ ** POST_CLIP  v g
+ */
+#define POST_CLIP_DISP_SIZE	(0x0000)
+#define POST_CLIP_CTL_HRZ	(0x0010)
+#define POST_CLIP_CTL_VRZ	(0x0014)
+#define POST_CLIP_EN	(0x0018)
+
+typedef struct dss_post_clip {
+	u32 disp_size;
+	u32 clip_ctl_hrz;
+	u32 clip_ctl_vrz;
+	u32 ctl_clip_en;
+} dss_post_clip_t;
+
+/*******************************************************************************
+ ** PCSC v
+ */
+#define PCSC_IDC0	(0x0000)
+#define PCSC_IDC2	(0x0004)
+#define PCSC_ODC0	(0x0008)
+#define PCSC_ODC2	(0x000C)
+#define PCSC_P0	(0x0010)
+#define PCSC_P1	(0x0014)
+#define PCSC_P2	(0x0018)
+#define PCSC_P3	(0x001C)
+#define PCSC_P4	(0x0020)
+#define PCSC_ICG_MODULE	(0x0024)
+#define PCSC_MPREC	(0x0028)
+
+typedef struct dss_pcsc {
+	u32 pcsc_idc0;
+} dss_pcsc_t;
+
+/*******************************************************************************
+ ** CSC
+ */
+#define CSC_IDC0	(0x0000)
+#define CSC_IDC2	(0x0004)
+#define CSC_ODC0	(0x0008)
+#define CSC_ODC2	(0x000C)
+#define CSC_P0	(0x0010)
+#define CSC_P1	(0x0014)
+#define CSC_P2	(0x0018)
+#define CSC_P3	(0x001C)
+#define CSC_P4	(0x0020)
+#define CSC_ICG_MODULE	(0x0024)
+#define CSC_MPREC	(0x0028)
+
+typedef struct dss_csc {
+	u32 idc0;
+	u32 idc2;
+	u32 odc0;
+	u32 odc2;
+	u32 p0;
+	u32 p1;
+	u32 p2;
+	u32 p3;
+	u32 p4;
+	u32 icg_module;
+	u32 mprec;
+} dss_csc_t;
+
+/*******************************************************************************
+ **channel DEBUG
+ */
+#define CH_DEBUG_SEL (0x600)
+
+/*******************************************************************************
+ ** VPP
+ */
+#define VPP_CTRL (0x700)
+#define VPP_MEM_CTRL (0x704)
+
+/*******************************************************************************
+ **DMA BUF
+ */
+#define DMA_BUF_CTRL	(0x800)
+#define DMA_BUF_SIZE  (0x850)
+#define DMA_BUF_MEM_CTRL	(0x854)
+#define DMA_BUF_DBG0 (0x0838)
+#define DMA_BUF_DBG1 (0x083c)
+
+#define AFBCD_HREG_HDR_PTR_LO	(0x900)
+#define AFBCD_HREG_PIC_WIDTH	(0x904)
+#define AFBCD_HREG_PIC_HEIGHT	(0x90C)
+#define AFBCD_HREG_FORMAT	(0x910)
+#define AFBCD_CTL		(0x914)
+#define AFBCD_STR	(0x918)
+#define AFBCD_LINE_CROP	(0x91C)
+#define AFBCD_INPUT_HEADER_STRIDE	(0x920)
+#define AFBCD_PAYLOAD_STRIDE	(0x924)
+#define AFBCD_MM_BASE_0	(0x928)
+#define AFBCD_AFBCD_PAYLOAD_POINTER	(0x930)
+#define AFBCD_HEIGHT_BF_STR	(0x934)
+#define AFBCD_OS_CFG	(0x938)
+#define AFBCD_MEM_CTRL	(0x93C)
+#define AFBCD_SCRAMBLE_MODE	(0x940)
+#define AFBCD_HEADER_POINTER_OFFSET	(0x944)
+#define AFBCD_MONITOR_REG1_OFFSET	(0x948)
+#define AFBCD_MONITOR_REG2_OFFSET	(0x94C)
+#define AFBCD_MONITOR_REG3_OFFSET	(0x950)
+#define AFBCD_DEBUG_REG0_OFFSET	(0x954)
+
+#define AFBCE_HREG_PIC_BLKS	(0x900)
+#define AFBCE_HREG_FORMAT	(0x904)
+#define AFBCE_HREG_HDR_PTR_LO	(0x908)
+#define AFBCE_HREG_PLD_PTR_LO	(0x90C)
+#define AFBCE_PICTURE_SIZE	(0x910)
+#define AFBCE_CTL	(0x914)
+#define AFBCE_HEADER_SRTIDE	(0x918)
+#define AFBCE_PAYLOAD_STRIDE	(0x91C)
+#define AFBCE_ENC_OS_CFG	(0x920)
+#define AFBCE_MEM_CTRL	(0x924)
+#define AFBCE_QOS_CFG	(0x928)
+#define AFBCE_THRESHOLD	(0x92C)
+#define AFBCE_SCRAMBLE_MODE	(0x930)
+#define AFBCE_HEADER_POINTER_OFFSET	(0x934)
+
+#define ROT_FIRST_LNS	(0x530)
+#define ROT_STATE	(0x534)
+#define ROT_MEM_CTRL		(0x538)
+#define ROT_SIZE	(0x53C)
+#define ROT_CPU_CTL0	(0x540)
+#define ROT_CPU_START0	(0x544)
+#define ROT_CPU_ADDR0	(0x548)
+#define ROT_CPU_RDATA0	(0x54C)
+#define ROT_CPU_RDATA1	(0x550)
+#define ROT_CPU_WDATA0	(0x554)
+#define ROT_CPU_WDATA1	(0x558)
+#define ROT_CPU_CTL1	(0x55C)
+#define ROT_CPU_START1	(0x560)
+#define ROT_CPU_ADDR1	(0x564)
+#define ROT_CPU_RDATA2	(0x568)
+#define ROT_CPU_RDATA3	(0x56C)
+#define ROT_CPU_WDATA2	(0x570)
+#define ROT_CPU_WDATA3	(0x574)
+
+#define CH_REG_DEFAULT (0x0A00)
+
+/* MACROS */
+#define MIN_INTERLEAVE	(7)
+#define MAX_TILE_SURPORT_NUM	(6)
+
+/* DMA aligned limited:  128bits aligned */
+#define DMA_ALIGN_BYTES	(128 / BITS_PER_BYTE)
+#define DMA_ADDR_ALIGN	(128 / BITS_PER_BYTE)
+#define DMA_STRIDE_ALIGN	(128 / BITS_PER_BYTE)
+
+#define TILE_DMA_ADDR_ALIGN	(256 * 1024)
+
+#define DMA_IN_WIDTH_MAX	(2048)
+#define DMA_IN_HEIGHT_MAX	(8192)
+
+#define AFBC_PIC_WIDTH_MIN	(16)
+#define AFBC_PIC_WIDTH_MAX	(8192)
+#define AFBC_PIC_HEIGHT_MIN	(16)
+#define AFBC_PIC_HEIGHT_MAX	(4096)
+
+#define AFBCD_TOP_CROP_MAX	(15)
+#define AFBCD_BOTTOM_CROP_MAX	(15)
+
+#define AFBC_HEADER_STRIDE_BLOCK	(16)
+
+#define AFBC_PAYLOAD_STRIDE_BLOCK	(1024)
+
+#define AFBC_SUPER_GRAPH_HEADER_ADDR_ALIGN	(128)
+#define AFBC_HEADER_ADDR_ALIGN	(64)
+#define AFBC_HEADER_STRIDE_ALIGN	(64)
+
+#define AFBC_PAYLOAD_ADDR_ALIGN_32	(1024)
+#define AFBC_PAYLOAD_STRIDE_ALIGN_32	(1024)
+#define AFBC_PAYLOAD_ADDR_ALIGN_16	(512)
+#define AFBC_PAYLOAD_STRIDE_ALIGN_16	(512)
+
+#define AFBC_BLOCK_ALIGN	(16)
+
+#define AFBCE_IN_WIDTH_MAX	(512)
+#define WROT_IN_WIDTH_MAX	(512)
+
+#define MMBUF_BASE	(0x40)
+#define MMBUF_LINE_NUM	(8)
+#define MMBUF_ADDR_ALIGN	(64)
+
+enum DSS_AFBC_HALF_BLOCK_MODE {
+	AFBC_HALF_BLOCK_UPPER_LOWER_ALL = 0,
+	AFBC_HALF_BLOCK_LOWER_UPPER_ALL,
+	AFBC_HALF_BLOCK_UPPER_ONLY,
+	AFBC_HALF_BLOCK_LOWER_ONLY,
+};
+
+typedef struct dss_rdma {
+	u32 oft_x0;
+	u32 oft_y0;
+	u32 oft_x1;
+	u32 oft_y1;
+	u32 mask0;
+	u32 mask1;
+	u32 stretch_size_vrt;
+	u32 ctrl;
+	u32 tile_scram;
+
+	u32 data_addr0;
+	u32 stride0;
+	u32 stretch_stride0;
+	u32 data_num0;
+
+	u32 data_addr1;
+	u32 stride1;
+	u32 stretch_stride1;
+	u32 data_num1;
+
+	u32 data_addr2;
+	u32 stride2;
+	u32 stretch_stride2;
+	u32 data_num2;
+
+	u32 ch_rd_shadow;
+	u32 ch_ctl;
+
+	u32 dma_buf_ctrl;
+
+	u32 vpp_ctrl;
+	u32 vpp_mem_ctrl;
+
+	u32 afbcd_hreg_hdr_ptr_lo;
+	u32 afbcd_hreg_pic_width;
+	u32 afbcd_hreg_pic_height;
+	u32 afbcd_hreg_format;
+	u32 afbcd_ctl;
+	u32 afbcd_str;
+	u32 afbcd_line_crop;
+	u32 afbcd_input_header_stride;
+	u32 afbcd_payload_stride;
+	u32 afbcd_mm_base_0;
+
+	u32 afbcd_afbcd_payload_pointer;
+	u32 afbcd_height_bf_str;
+	u32 afbcd_os_cfg;
+	u32 afbcd_mem_ctrl;
+	u32 afbcd_scramble_mode;
+	u32 afbcd_header_pointer_offset;
+
+	u8 vpp_used;
+	u8 afbc_used;
+} dss_rdma_t;
+
+typedef struct dss_wdma {
+	u32 oft_x0;
+	u32 oft_y0;
+	u32 oft_x1;
+	u32 oft_y1;
+
+	u32 mask0;
+	u32 mask1;
+	u32 stretch_size_vrt;
+	u32 ctrl;
+	u32 tile_scram;
+
+	u32 sw_mask_en;
+	u32 start_mask0;
+	u32 end_mask0;
+	u32 start_mask1;
+	u32 end_mask1;
+
+	u32 data_addr;
+	u32 stride0;
+	u32 data1_addr;
+	u32 stride1;
+
+	u32 stretch_stride;
+	u32 data_num;
+
+	u32 ch_rd_shadow;
+	u32 ch_ctl;
+	u32 ch_secu_en;
+	u32 ch_sw_end_req;
+
+	u32 dma_buf_ctrl;
+	u32 dma_buf_size;
+
+	u32 rot_size;
+
+	u32 afbce_hreg_pic_blks;
+	u32 afbce_hreg_format;
+	u32 afbce_hreg_hdr_ptr_lo;
+	u32 afbce_hreg_pld_ptr_lo;
+	u32 afbce_picture_size;
+	u32 afbce_ctl;
+	u32 afbce_header_srtide;
+	u32 afbce_payload_stride;
+	u32 afbce_enc_os_cfg;
+	u32 afbce_mem_ctrl;
+	u32 afbce_qos_cfg;
+	u32 afbce_threshold;
+	u32 afbce_scramble_mode;
+	u32 afbce_header_pointer_offset;
+
+	u8 afbc_used;
+	u8 rot_used;
+} dss_wdma_t;
+
+/*******************************************************************************
+ ** MCTL  MUTEX0 1 2 3 4 5
+ */
+#define MCTL_CTL_EN	(0x0000)
+#define MCTL_CTL_MUTEX	(0x0004)
+#define MCTL_CTL_MUTEX_STATUS	(0x0008)
+#define MCTL_CTL_MUTEX_ITF	(0x000C)
+#define MCTL_CTL_MUTEX_DBUF	(0x0010)
+#define MCTL_CTL_MUTEX_SCF	(0x0014)
+#define MCTL_CTL_MUTEX_OV	(0x0018)
+#define MCTL_CTL_MUTEX_WCH0	(0x0020)
+#define MCTL_CTL_MUTEX_WCH1	(0x0024)
+#define MCTL_CTL_MUTEX_WCH2	(0x0028)
+#define MCTL_CTL_MUTEX_RCH8	(0x002C)
+#define MCTL_CTL_MUTEX_RCH0	(0x0030)
+#define MCTL_CTL_MUTEX_RCH1	(0x0034)
+#define MCTL_CTL_MUTEX_RCH2	(0x0038)
+#define MCTL_CTL_MUTEX_RCH3	(0x003C)
+#define MCTL_CTL_MUTEX_RCH4	(0x0040)
+#define MCTL_CTL_MUTEX_RCH5	(0x0044)
+#define MCTL_CTL_MUTEX_RCH6	(0x0048)
+#define MCTL_CTL_MUTEX_RCH7	(0x004C)
+#define MCTL_CTL_TOP	(0x0050)
+#define MCTL_CTL_FLUSH_STATUS	(0x0054)
+#define MCTL_CTL_CLEAR	(0x0058)
+#define MCTL_CTL_CACK_TOUT	(0x0060)
+#define MCTL_CTL_MUTEX_TOUT	(0x0064)
+#define MCTL_CTL_STATUS	(0x0068)
+#define MCTL_CTL_INTEN	(0x006C)
+#define MCTL_CTL_SW_ST	(0x0070)
+#define MCTL_CTL_ST_SEL	(0x0074)
+#define MCTL_CTL_END_SEL	(0x0078)
+#define MCTL_CTL_CLK_SEL	(0x0080)
+#define MCTL_CTL_CLK_EN	(0x0084)
+#define MCTL_CTL_DBG	(0x00E0)
+
+/*******************************************************************************
+ ** MCTL  SYS
+ */
+#define MCTL_CTL_SECU_CFG	(0x0000)
+#define MCTL_PAY_SECU_FLUSH_EN  (0x0018)
+#define MCTL_CTL_SECU_GATE0	(0x0080)
+#define MCTL_CTL_SECU_GATE1	(0x0084)
+#define MCTL_CTL_SECU_GATE2	(0x0088)
+#define MCTL_DSI0_SECU_CFG_EN	(0x00A0)
+#define MCTL_DSI1_SECU_CFG_EN	(0x00A4)
+
+#define MCTL_RCH0_FLUSH_EN	(0x0100)
+#define MCTL_RCH1_FLUSH_EN	(0x0104)
+#define MCTL_RCH2_FLUSH_EN	(0x0108)
+#define MCTL_RCH3_FLUSH_EN	(0x010C)
+#define MCTL_RCH4_FLUSH_EN	(0x0110)
+#define MCTL_RCH5_FLUSH_EN	(0x0114)
+#define MCTL_RCH6_FLUSH_EN	(0x0118)
+#define MCTL_RCH7_FLUSH_EN	(0x011C)
+#define MCTL_WCH0_FLUSH_EN	(0x0120)
+#define MCTL_WCH1_FLUSH_EN	(0x0124)
+#define MCTL_OV0_FLUSH_EN	(0x0128)
+#define MCTL_OV1_FLUSH_EN	(0x012C)
+#define MCTL_OV2_FLUSH_EN	(0x0130)
+#define MCTL_OV3_FLUSH_EN	(0x0134)
+#define MCTL_RCH8_FLUSH_EN	(0x0138)
+#define MCTL_WCH2_FLUSH_EN	(0x013C)
+
+#define MCTL_RCH0_OV_OEN	(0x0160)
+#define MCTL_RCH1_OV_OEN	(0x0164)
+#define MCTL_RCH2_OV_OEN	(0x0168)
+#define MCTL_RCH3_OV_OEN	(0x016C)
+#define MCTL_RCH4_OV_OEN	(0x0170)
+#define MCTL_RCH5_OV_OEN	(0x0174)
+#define MCTL_RCH6_OV_OEN	(0x0178)
+#define MCTL_RCH7_OV_OEN	(0x017C)
+
+#define MCTL_RCH_OV0_SEL	(0x0180)
+#define MCTL_RCH_OV1_SEL	(0x0184)
+#define MCTL_RCH_OV2_SEL	(0x0188)
+#define MCTL_RCH_OV3_SEL	(0x018C)
+
+#define MCTL_WCH0_OV_IEN   (0x01A0)
+#define MCTL_WCH1_OV_IEN   (0x01A4)
+
+#define MCTL_WCH_OV2_SEL   (0x01A8)
+#define MCTL_WCH_OV3_SEL   (0x01AC)
+
+#define MCTL_WB_ENC_SEL	(0x01B0)
+#define MCTL_DSI_MUX_SEL	(0x01B4)
+
+#define MCTL_RCH0_STARTY	(0x01C0)
+#define MCTL_RCH1_STARTY	(0x01C4)
+#define MCTL_RCH2_STARTY	(0x01C8)
+#define MCTL_RCH3_STARTY	(0x01CC)
+#define MCTL_RCH4_STARTY	(0x01D0)
+#define MCTL_RCH5_STARTY	(0x01D4)
+#define MCTL_RCH6_STARTY	(0x01D8)
+#define MCTL_RCH7_STARTY	(0x01DC)
+
+#define MCTL_MCTL_CLK_SEL	(0x01F0)
+#define MCTL_MCTL_CLK_EN	(0x01F4)
+#define MCTL_MOD_CLK_SEL	(0x01F8)
+#define MCTL_MOD_CLK_EN	(0x01FC)
+
+#define MCTL_MOD0_DBG	(0x0200)
+#define MCTL_MOD1_DBG	(0x0204)
+#define MCTL_MOD2_DBG	(0x0208)
+#define MCTL_MOD3_DBG	(0x020C)
+#define MCTL_MOD4_DBG	(0x0210)
+#define MCTL_MOD5_DBG	(0x0214)
+#define MCTL_MOD6_DBG	(0x0218)
+#define MCTL_MOD7_DBG	(0x021C)
+#define MCTL_MOD8_DBG	(0x0220)
+#define MCTL_MOD9_DBG	(0x0224)
+#define MCTL_MOD10_DBG	(0x0228)
+#define MCTL_MOD11_DBG	(0x022C)
+#define MCTL_MOD12_DBG	(0x0230)
+#define MCTL_MOD13_DBG	(0x0234)
+#define MCTL_MOD14_DBG	(0x0238)
+#define MCTL_MOD15_DBG	(0x023C)
+#define MCTL_MOD16_DBG	(0x0240)
+#define MCTL_MOD17_DBG	(0x0244)
+#define MCTL_MOD18_DBG	(0x0248)
+#define MCTL_MOD19_DBG	(0x024C)
+#define MCTL_MOD20_DBG	(0x0250)
+#define MCTL_MOD0_STATUS	(0x0280)
+#define MCTL_MOD1_STATUS	(0x0284)
+#define MCTL_MOD2_STATUS	(0x0288)
+#define MCTL_MOD3_STATUS	(0x028C)
+#define MCTL_MOD4_STATUS	(0x0290)
+#define MCTL_MOD5_STATUS	(0x0294)
+#define MCTL_MOD6_STATUS	(0x0298)
+#define MCTL_MOD7_STATUS	(0x029C)
+#define MCTL_MOD8_STATUS	(0x02A0)
+#define MCTL_MOD9_STATUS	(0x02A4)
+#define MCTL_MOD10_STATUS	(0x02A8)
+#define MCTL_MOD11_STATUS	(0x02AC)
+#define MCTL_MOD12_STATUS	(0x02B0)
+#define MCTL_MOD13_STATUS	(0x02B4)
+#define MCTL_MOD14_STATUS	(0x02B8)
+#define MCTL_MOD15_STATUS	(0x02BC)
+#define MCTL_MOD16_STATUS	(0x02C0)
+#define MCTL_MOD17_STATUS	(0x02C4)
+#define MCTL_MOD18_STATUS	(0x02C8)
+#define MCTL_MOD19_STATUS	(0x02CC)
+#define MCTL_MOD20_STATUS	(0x02D0)
+#define MCTL_SW_DBG	(0x0300)
+#define MCTL_SW0_STATUS0	(0x0304)
+#define MCTL_SW0_STATUS1	(0x0308)
+#define MCTL_SW0_STATUS2	(0x030C)
+#define MCTL_SW0_STATUS3	(0x0310)
+#define MCTL_SW0_STATUS4	(0x0314)
+#define MCTL_SW0_STATUS5	(0x0318)
+#define MCTL_SW0_STATUS6	(0x031C)
+#define MCTL_SW0_STATUS7	(0x0320)
+#define MCTL_SW1_STATUS	(0x0324)
+
+#define MCTL_MOD_DBG_CH_NUM (10)
+#define MCTL_MOD_DBG_OV_NUM (4)
+#define MCTL_MOD_DBG_DBUF_NUM (2)
+#define MCTL_MOD_DBG_SCF_NUM (1)
+#define MCTL_MOD_DBG_ITF_NUM (2)
+#define MCTL_MOD_DBG_ADD_CH_NUM (2)
+
+enum dss_mctl_idx {
+	DSS_MCTL0 = 0,
+	DSS_MCTL1,
+	DSS_MCTL2,
+	DSS_MCTL3,
+	DSS_MCTL4,
+	DSS_MCTL5,
+	DSS_MCTL_IDX_MAX,
+};
+
+typedef struct dss_mctl {
+	u32 ctl_mutex_itf;
+	u32 ctl_mutex_dbuf;
+	u32 ctl_mutex_scf;
+	u32 ctl_mutex_ov;
+} dss_mctl_t;
+
+typedef struct dss_mctl_ch_base {
+	char __iomem *chn_mutex_base;
+	char __iomem *chn_flush_en_base;
+	char __iomem *chn_ov_en_base;
+	char __iomem *chn_starty_base;
+	char __iomem *chn_mod_dbg_base;
+} dss_mctl_ch_base_t;
+
+typedef struct dss_mctl_ch {
+	u32 chn_mutex;
+	u32 chn_flush_en;
+	u32 chn_ov_oen;
+	u32 chn_starty;
+	u32 chn_mod_dbg;
+} dss_mctl_ch_t;
+
+typedef struct dss_mctl_sys {
+	u32 ov_flush_en[DSS_OVL_IDX_MAX];
+	u32 chn_ov_sel[DSS_OVL_IDX_MAX];
+	u32 wchn_ov_sel[DSS_WCH_MAX];
+	u8 ov_flush_en_used[DSS_OVL_IDX_MAX];
+	u8 chn_ov_sel_used[DSS_OVL_IDX_MAX];
+	u8 wch_ov_sel_used[DSS_WCH_MAX];
+} dss_mctl_sys_t;
+
+/*******************************************************************************
+ ** OVL
+ */
+#define OVL_SIZE	(0x0000)
+#define OVL_BG_COLOR	(0x4)
+#define OVL_DST_STARTPOS	(0x8)
+#define OVL_DST_ENDPOS	(0xC)
+#define OVL_GCFG	(0x10)
+#define OVL_LAYER0_POS	(0x14)
+#define OVL_LAYER0_SIZE	(0x18)
+#define OVL_LAYER0_SRCLOKEY	(0x1C)
+#define OVL_LAYER0_SRCHIKEY	(0x20)
+#define OVL_LAYER0_DSTLOKEY	(0x24)
+#define OVL_LAYER0_DSTHIKEY	(0x28)
+#define OVL_LAYER0_PATTERN	(0x2C)
+#define OVL_LAYER0_ALPHA	(0x30)
+#define OVL_LAYER0_CFG	(0x34)
+#define OVL_LAYER0_INFO_ALPHA	(0x40)
+#define OVL_LAYER0_INFO_SRCCOLOR	(0x44)
+#define OVL_LAYER1_POS	(0x50)
+#define OVL_LAYER1_SIZE	(0x54)
+#define OVL_LAYER1_SRCLOKEY	(0x58)
+#define OVL_LAYER1_SRCHIKEY	(0x5C)
+#define OVL_LAYER1_DSTLOKEY	(0x60)
+#define OVL_LAYER1_DSTHIKEY	(0x64)
+#define OVL_LAYER1_PATTERN	(0x68)
+#define OVL_LAYER1_ALPHA	(0x6C)
+#define OVL_LAYER1_CFG	(0x70)
+#define OVL_LAYER1_INFO_ALPHA	(0x7C)
+#define OVL_LAYER1_INFO_SRCCOLOR	(0x80)
+#define OVL_LAYER2_POS	(0x8C)
+#define OVL_LAYER2_SIZE	(0x90)
+#define OVL_LAYER2_SRCLOKEY	(0x94)
+#define OVL_LAYER2_SRCHIKEY	(0x98)
+#define OVL_LAYER2_DSTLOKEY	(0x9C)
+#define OVL_LAYER2_DSTHIKEY	(0xA0)
+#define OVL_LAYER2_PATTERN	(0xA4)
+#define OVL_LAYER2_ALPHA	(0xA8)
+#define OVL_LAYER2_CFG	(0xAC)
+#define OVL_LAYER2_INFO_ALPHA	(0xB8)
+#define OVL_LAYER2_INFO_SRCCOLOR	(0xBC)
+#define OVL_LAYER3_POS	(0xC8)
+#define OVL_LAYER3_SIZE	(0xCC)
+#define OVL_LAYER3_SRCLOKEY	(0xD0)
+#define OVL_LAYER3_SRCHIKEY	(0xD4)
+#define OVL_LAYER3_DSTLOKEY	(0xD8)
+#define OVL_LAYER3_DSTHIKEY	(0xDC)
+#define OVL_LAYER3_PATTERN	(0xE0)
+#define OVL_LAYER3_ALPHA	(0xE4)
+#define OVL_LAYER3_CFG	(0xE8)
+#define OVL_LAYER3_INFO_ALPHA	(0xF4)
+#define OVL_LAYER3_INFO_SRCCOLOR	(0xF8)
+#define OVL_LAYER4_POS	(0x104)
+#define OVL_LAYER4_SIZE	(0x108)
+#define OVL_LAYER4_SRCLOKEY	(0x10C)
+#define OVL_LAYER4_SRCHIKEY	(0x110)
+#define OVL_LAYER4_DSTLOKEY	(0x114)
+#define OVL_LAYER4_DSTHIKEY	(0x118)
+#define OVL_LAYER4_PATTERN	(0x11C)
+#define OVL_LAYER4_ALPHA	(0x120)
+#define OVL_LAYER4_CFG	(0x124)
+#define OVL_LAYER4_INFO_ALPHA	(0x130)
+#define OVL_LAYER4_INFO_SRCCOLOR	(0x134)
+#define OVL_LAYER5_POS	(0x140)
+#define OVL_LAYER5_SIZE	(0x144)
+#define OVL_LAYER5_SRCLOKEY	(0x148)
+#define OVL_LAYER5_SRCHIKEY	(0x14C)
+#define OVL_LAYER5_DSTLOKEY	(0x150)
+#define OVL_LAYER5_DSTHIKEY	(0x154)
+#define OVL_LAYER5_PATTERN	(0x158)
+#define OVL_LAYER5_ALPHA	(0x15C)
+#define OVL_LAYER5_CFG	(0x160)
+#define OVL_LAYER5_INFO_ALPHA	(0x16C)
+#define OVL_LAYER5_INFO_SRCCOLOR	(0x170)
+#define OVL_LAYER6_POS	(0x14)
+#define OVL_LAYER6_SIZE	(0x18)
+#define OVL_LAYER6_SRCLOKEY	(0x1C)
+#define OVL_LAYER6_SRCHIKEY	(0x20)
+#define OVL_LAYER6_DSTLOKEY	(0x24)
+#define OVL_LAYER6_DSTHIKEY	(0x28)
+#define OVL_LAYER6_PATTERN	(0x2C)
+#define OVL_LAYER6_ALPHA	(0x30)
+#define OVL_LAYER6_CFG	(0x34)
+#define OVL_LAYER6_INFO_ALPHA	(0x40)
+#define OVL_LAYER6_INFO_SRCCOLOR	(0x44)
+#define OVL_LAYER7_POS	(0x50)
+#define OVL_LAYER7_SIZE	(0x54)
+#define OVL_LAYER7_SRCLOKEY	(0x58)
+#define OVL_LAYER7_SRCHIKEY	(0x5C)
+#define OVL_LAYER7_DSTLOKEY	(0x60)
+#define OVL_LAYER7_DSTHIKEY	(0x64)
+#define OVL_LAYER7_PATTERN	(0x68)
+#define OVL_LAYER7_ALPHA	(0x6C)
+#define OVL_LAYER7_CFG	(0x70)
+#define OVL_LAYER7_INFO_ALPHA	(0x7C)
+#define OVL_LAYER7_INFO_SRCCOLOR	(0x80)
+#define OVL_LAYER0_ST_INFO	(0x48)
+#define OVL_LAYER1_ST_INFO	(0x84)
+#define OVL_LAYER2_ST_INFO	(0xC0)
+#define OVL_LAYER3_ST_INFO	(0xFC)
+#define OVL_LAYER4_ST_INFO	(0x138)
+#define OVL_LAYER5_ST_INFO	(0x174)
+#define OVL_LAYER6_ST_INFO	(0x48)
+#define OVL_LAYER7_ST_INFO	(0x84)
+#define OVL_LAYER0_IST_INFO	(0x4C)
+#define OVL_LAYER1_IST_INFO	(0x88)
+#define OVL_LAYER2_IST_INFO	(0xC4)
+#define OVL_LAYER3_IST_INFO	(0x100)
+#define OVL_LAYER4_IST_INFO	(0x13C)
+#define OVL_LAYER5_IST_INFO	(0x178)
+#define OVL_LAYER6_IST_INFO	(0x4C)
+#define OVL_LAYER7_IST_INFO	(0x88)
+#define OVL_LAYER0_PSPOS	(0x38)
+#define OVL_LAYER0_PEPOS	(0x3C)
+#define OVL_LAYER1_PSPOS	(0x74)
+#define OVL_LAYER1_PEPOS	(0x78)
+#define OVL_LAYER2_PSPOS	(0xB0)
+#define OVL_LAYER2_PEPOS	(0xB4)
+#define OVL_LAYER3_PSPOS	(0xEC)
+#define OVL_LAYER3_PEPOS	(0xF0)
+#define OVL_LAYER4_PSPOS	(0x128)
+#define OVL_LAYER4_PEPOS	(0x12C)
+#define OVL_LAYER5_PSPOS	(0x164)
+#define OVL_LAYER5_PEPOS	(0x168)
+#define OVL_LAYER6_PSPOS	(0x38)
+#define OVL_LAYER6_PEPOS	(0x3C)
+#define OVL_LAYER7_PSPOS	(0x74)
+#define OVL_LAYER7_PEPOS	(0x78)
+
+#define OVL6_BASE_ST_INFO	(0x17C)
+#define OVL6_BASE_IST_INFO	(0x180)
+#define OVL6_GATE_CTRL	(0x184)
+#define OVL6_RD_SHADOW_SEL	(0x188)
+#define OVL6_OV_CLK_SEL	(0x18C)
+#define OVL6_OV_CLK_EN	(0x190)
+#define OVL6_BLOCK_SIZE	(0x1A0)
+#define OVL6_BLOCK_DBG	(0x1A4)
+#define OVL6_REG_DEFAULT (0x1A8)
+
+#define OVL2_BASE_ST_INFO	(0x8C)
+#define OVL2_BASE_IST_INFO	(0x90)
+#define OVL2_GATE_CTRL	(0x94)
+#define OVL2_OV_RD_SHADOW_SEL	(0x98)
+#define OVL2_OV_CLK_SEL	(0x9C)
+#define OVL2_OV_CLK_EN	(0xA0)
+#define OVL2_BLOCK_SIZE	(0xB0)
+#define OVL2_BLOCK_DBG	(0xB4)
+#define OVL2_REG_DEFAULT	(0xB8)
+
+/* LAYER0_CFG */
+#define BIT_OVL_LAYER_SRC_CFG	BIT(8)
+#define BIT_OVL_LAYER_ENABLE	BIT(0)
+
+/* LAYER0_INFO_ALPHA */
+#define BIT_OVL_LAYER_SRCALPHA_FLAG	BIT(3)
+#define BIT_OVL_LAYER_DSTALPHA_FLAG	BIT(2)
+
+/* LAYER0_INFO_SRCCOLOR */
+#define BIT_OVL_LAYER_SRCCOLOR_FLAG	BIT(0)
+
+#define OVL_6LAYER_NUM		(6)
+#define OVL_2LAYER_NUM		(2)
+
+typedef struct dss_ovl_layer {
+	u32 layer_pos;
+	u32 layer_size;
+	u32 layer_pattern;
+	u32 layer_alpha;
+	u32 layer_cfg;
+
+} dss_ovl_layer_t;
+
+typedef struct dss_ovl_layer_pos {
+	u32 layer_pspos;
+	u32 layer_pepos;
+
+} dss_ovl_layer_pos_t;
+
+typedef struct dss_ovl {
+	u32 ovl_size;
+	u32 ovl_bg_color;
+	u32 ovl_dst_startpos;
+	u32 ovl_dst_endpos;
+	u32 ovl_gcfg;
+	u32 ovl_block_size;
+	dss_ovl_layer_t ovl_layer[OVL_6LAYER_NUM];
+	dss_ovl_layer_pos_t ovl_layer_pos[OVL_6LAYER_NUM];
+	u8 ovl_layer_used[OVL_6LAYER_NUM];
+} dss_ovl_t;
+
+typedef struct dss_ovl_alpha {
+	u32 src_amode;
+	u32 src_gmode;
+	u32 alpha_offsrc;
+	u32 src_lmode;
+	u32 src_pmode;
+
+	u32 alpha_smode;
+
+	u32 dst_amode;
+	u32 dst_gmode;
+	u32 alpha_offdst;
+	u32 dst_pmode;
+
+	u32 fix_mode;
+} dss_ovl_alpha_t;
+
+/*******************************************************************************
+ ** DBUF
+ */
+#define DBUF_FRM_SIZE	(0x0000)
+#define DBUF_FRM_HSIZE	(0x0004)
+#define DBUF_SRAM_VALID_NUM	(0x0008)
+#define DBUF_WBE_EN	(0x000C)
+#define DBUF_THD_FILL_LEV0	(0x0010)
+#define DBUF_DFS_FILL_LEV1	(0x0014)
+#define DBUF_THD_RQOS	(0x0018)
+#define DBUF_THD_WQOS	(0x001C)
+#define DBUF_THD_CG	(0x0020)
+#define DBUF_THD_OTHER	(0x0024)
+#define DBUF_FILL_LEV0_CNT	(0x0028)
+#define DBUF_FILL_LEV1_CNT	(0x002C)
+#define DBUF_FILL_LEV2_CNT	(0x0030)
+#define DBUF_FILL_LEV3_CNT	(0x0034)
+#define DBUF_FILL_LEV4_CNT	(0x0038)
+#define DBUF_ONLINE_FILL_LEVEL	(0x003C)
+#define DBUF_WB_FILL_LEVEL	(0x0040)
+#define DBUF_DFS_STATUS	(0x0044)
+#define DBUF_THD_FLUX_REQ_BEF	(0x0048)
+#define DBUF_DFS_LP_CTRL	(0x004C)
+#define DBUF_RD_SHADOW_SEL	(0x0050)
+#define DBUF_MEM_CTRL (0x0054)
+#define DBUF_PM_CTRL (0x0058)
+#define DBUF_CLK_SEL (0x005C)
+#define DBUF_CLK_EN (0x0060)
+#define DBUF_THD_FLUX_REQ_AFT (0x0064)
+#define DBUF_THD_DFS_OK (0x0068)
+#define DBUF_FLUX_REQ_CTRL (0x006C)
+#define DBUF_REG_DEFAULT  (0x00A4)
+
+/*******************************************************************************
+ ** DPP
+ */
+#define DPP_RD_SHADOW_SEL	(0x000)
+#define DPP_DEFAULT	(0x004)
+#define DPP_ID	(0x008)
+#define DPP_IMG_SIZE_BEF_SR	(0x00C)
+#define DPP_IMG_SIZE_AFT_SR	(0x010)
+#define DPP_SBL	(0x014)
+#define DPP_SBL_MEM_CTRL	(0x018)
+#define DPP_ARSR1P_MEM_CTRL	(0x01C)
+#define DPP_CLK_SEL	(0x020)
+#define DPP_CLK_EN	(0x024)
+#define DPP_DBG1_CNT	(0x028)
+#define DPP_DBG2_CNT	(0x02C)
+#define DPP_DBG1	(0x030)
+#define DPP_DBG2	(0x034)
+#define DPP_DBG3	(0x038)
+#define DPP_DBG4	(0x03C)
+#define DPP_INTS	(0x040)
+#define DPP_INT_MSK	(0x044)
+#define DPP_ARSR1P	(0x048)
+#define DPP_DBG_CNT  DPP_DBG1_CNT
+
+#define DPP_CLRBAR_CTRL (0x100)
+#define DPP_CLRBAR_1ST_CLR (0x104)
+#define DPP_CLRBAR_2ND_CLR (0x108)
+#define DPP_CLRBAR_3RD_CLR (0x10C)
+
+#define DPP_CLIP_TOP (0x180)
+#define DPP_CLIP_BOTTOM (0x184)
+#define DPP_CLIP_LEFT (0x188)
+#define DPP_CLIP_RIGHT (0x18C)
+#define DPP_CLIP_EN (0x190)
+#define DPP_CLIP_DBG (0x194)
+
+#define DITHER_PARA (0x000)
+#define DITHER_CTL (0x004)
+#define DITHER_MATRIX_PART1 (0x008)
+#define DITHER_MATRIX_PART0 (0x00C)
+#define DITHER_ERRDIFF_WEIGHT (0x010)
+#define DITHER_FRC_01_PART1 (0x014)
+#define DITHER_FRC_01_PART0 (0x018)
+#define DITHER_FRC_10_PART1 (0x01C)
+#define DITHER_FRC_10_PART0 (0x020)
+#define DITHER_FRC_11_PART1 (0x024)
+#define DITHER_FRC_11_PART0 (0x028)
+#define DITHER_MEM_CTRL (0x02C)
+#define DITHER_DBG0 (0x030)
+#define DITHER_DBG1 (0x034)
+#define DITHER_DBG2 (0x038)
+
+#define CSC10B_IDC0	(0x000)
+#define CSC10B_IDC1	(0x004)
+#define CSC10B_IDC2	(0x008)
+#define CSC10B_ODC0	(0x00C)
+#define CSC10B_ODC1	(0x010)
+#define CSC10B_ODC2	(0x014)
+#define CSC10B_P00	(0x018)
+#define CSC10B_P01	(0x01C)
+#define CSC10B_P02	(0x020)
+#define CSC10B_P10	(0x024)
+#define CSC10B_P11	(0x028)
+#define CSC10B_P12	(0x02C)
+#define CSC10B_P20	(0x030)
+#define CSC10B_P21	(0x034)
+#define CSC10B_P22	(0x038)
+#define CSC10B_MODULE_EN	(0x03C)
+#define CSC10B_MPREC	(0x040)
+
+#define GAMA_EN	(0x000)
+#define GAMA_MEM_CTRL	(0x004)
+
+#define ACM_EN	(0x000)
+#define ACM_SATA_OFFSET	(0x004)
+#define ACM_HUESEL	(0x008)
+#define ACM_CSC_IDC0	(0x00C)
+#define ACM_CSC_IDC1	(0x010)
+#define ACM_CSC_IDC2	(0x014)
+#define ACM_CSC_P00	(0x018)
+#define ACM_CSC_P01	(0x01C)
+#define ACM_CSC_P02	(0x020)
+#define ACM_CSC_P10	(0x024)
+#define ACM_CSC_P11	(0x028)
+#define ACM_CSC_P12	(0x02C)
+#define ACM_CSC_P20	(0x030)
+#define ACM_CSC_P21	(0x034)
+#define ACM_CSC_P22	(0x038)
+#define ACM_CSC_MRREC	(0x03C)
+#define ACM_R0_H	(0x040)
+#define ACM_R1_H	(0x044)
+#define ACM_R2_H	(0x048)
+#define ACM_R3_H	(0x04C)
+#define ACM_R4_H	(0x050)
+#define ACM_R5_H	(0x054)
+#define ACM_R6_H	(0x058)
+#define ACM_LUT_DIS0	(0x05C)
+#define ACM_LUT_DIS1	(0x060)
+#define ACM_LUT_DIS2	(0x064)
+#define ACM_LUT_DIS3	(0x068)
+#define ACM_LUT_DIS4	(0x06C)
+#define ACM_LUT_DIS5	(0x070)
+#define ACM_LUT_DIS6	(0x074)
+#define ACM_LUT_DIS7	(0x078)
+#define ACM_LUT_PARAM0	(0x07C)
+#define ACM_LUT_PARAM1	(0x080)
+#define ACM_LUT_PARAM2	(0x084)
+#define ACM_LUT_PARAM3	(0x088)
+#define ACM_LUT_PARAM4	(0x08C)
+#define ACM_LUT_PARAM5	(0x090)
+#define ACM_LUT_PARAM6	(0x094)
+#define ACM_LUT_PARAM7	(0x098)
+#define ACM_LUT_SEL	(0x09C)
+#define ACM_MEM_CTRL	(0x0A0)
+#define ACM_DEBUG_TOP	(0x0A4)
+#define ACM_DEBUG_CFG	(0x0A8)
+#define ACM_DEBUG_W	(0x0AC)
+
+#define ACE_EN	(0x000)
+#define ACE_SKIN_CFG	(0x004)
+#define ACE_LUT_SEL	(0x008)
+#define ACE_HIST_IND	(0x00C)
+#define ACE_ACTIVE	(0x010)
+#define ACE_DBG	(0x014)
+#define ACE_MEM_CTRL	(0x018)
+#define ACE_IN_SEL	(0x01C)
+#define ACE_R2Y	(0x020)
+#define ACE_G2Y	(0x024)
+#define ACE_B2Y	(0x028)
+#define ACE_Y_OFFSET	(0x02C)
+#define ACE_Y_CEN	(0x030)
+#define ACE_U_CEN	(0x034)
+#define ACE_V_CEN	(0x038)
+#define ACE_Y_EXT	(0x03C)
+#define ACE_U_EXT	(0x040)
+#define ACE_V_EXT	(0x044)
+#define ACE_Y_ATTENU 	(0x048)
+#define ACE_U_ATTENU	(0x04C)
+#define ACE_V_ATTENU	(0x050)
+#define ACE_ROTA	(0x054)
+#define ACE_ROTB 	(0x058)
+#define ACE_Y_CORE	(0x05C)
+#define ACE_U_CORE	(0x060)
+#define ACE_V_CORE	(0x064)
+
+#define LCP_XCC_COEF_00	(0x000)
+#define LCP_XCC_COEF_01	(0x004)
+#define LCP_XCC_COEF_02	(0x008)
+#define LCP_XCC_COEF_03	(0x00C)
+#define LCP_XCC_COEF_10	(0x010)
+#define LCP_XCC_COEF_11	(0x014)
+#define LCP_XCC_COEF_12	(0x018)
+#define LCP_XCC_COEF_13	(0x01C)
+#define LCP_XCC_COEF_20	(0x020)
+#define LCP_XCC_COEF_21	(0x024)
+#define LCP_XCC_COEF_22	(0x028)
+#define LCP_XCC_COEF_23	(0x02C)
+#define LCP_GMP_BYPASS_EN	(0x030)
+#define LCP_XCC_BYPASS_EN	(0x034)
+#define LCP_DEGAMA_EN	(0x038)
+#define LCP_DEGAMA_MEM_CTRL	(0x03C)
+#define LCP_GMP_MEM_CTRL	(0x040)
+
+typedef struct dss_arsr1p {
+	u32 ihleft;
+	u32 ihright;
+	u32 ihleft1;
+	u32 ihright1;
+	u32 ivtop;
+	u32 ivbottom;
+	u32 uv_offset;
+	u32 ihinc;
+	u32 ivinc;
+	u32 mode;
+	u32 format;
+
+	u32 skin_thres_y;
+	u32 skin_thres_u;
+	u32 skin_thres_v;
+	u32 skin_expected;
+	u32 skin_cfg;
+	u32 shoot_cfg1;
+	u32 shoot_cfg2;
+	u32 sharp_cfg1;
+	u32 sharp_cfg2;
+	u32 sharp_cfg3;
+	u32 sharp_cfg4;
+	u32 sharp_cfg5;
+	u32 sharp_cfg6;
+	u32 sharp_cfg7;
+	u32 sharp_cfg8;
+	u32 sharp_cfg9;
+	u32 sharp_cfg10;
+	u32 sharp_cfg11;
+	u32 diff_ctrl;
+	u32 lsc_cfg1;
+	u32 lsc_cfg2;
+	u32 lsc_cfg3;
+	u32 force_clk_on_cfg;
+
+	u32 dpp_img_hrz_bef_sr;
+	u32 dpp_img_vrt_bef_sr;
+	u32 dpp_img_hrz_aft_sr;
+	u32 dpp_img_vrt_aft_sr;
+} dss_arsr1p_t;
+
+#define ARSR1P_INC_FACTOR (65536)
+
+#define ARSR1P_IHLEFT		(0x000)
+#define ARSR1P_IHRIGHT		(0x004)
+#define ARSR1P_IHLEFT1		(0x008)
+#define ARSR1P_IHRIGHT1		(0x00C)
+#define ARSR1P_IVTOP		(0x010)
+#define ARSR1P_IVBOTTOM		(0x014)
+#define ARSR1P_UV_OFFSET		(0x018)
+#define ARSR1P_IHINC		(0x01C)
+#define ARSR1P_IVINC		(0x020)
+#define ARSR1P_MODE			(0x024)
+#define ARSR1P_FORMAT		(0x028)
+#define ARSR1P_SKIN_THRES_Y		(0x02C)
+#define ARSR1P_SKIN_THRES_U		(0x030)
+#define ARSR1P_SKIN_THRES_V		(0x034)
+#define ARSR1P_SKIN_EXPECTED	(0x038)
+#define ARSR1P_SKIN_CFG			(0x03C)
+#define ARSR1P_SHOOT_CFG1		(0x040)
+#define ARSR1P_SHOOT_CFG2		(0x044)
+#define ARSR1P_SHARP_CFG1		(0x048)
+#define ARSR1P_SHARP_CFG2		(0x04C)
+#define ARSR1P_SHARP_CFG3		(0x050)
+#define ARSR1P_SHARP_CFG4		(0x054)
+#define ARSR1P_SHARP_CFG5		(0x058)
+#define ARSR1P_SHARP_CFG6		(0x05C)
+#define ARSR1P_SHARP_CFG7		(0x060)
+#define ARSR1P_SHARP_CFG8		(0x064)
+#define ARSR1P_SHARP_CFG9		(0x068)
+#define ARSR1P_SHARP_CFG10		(0x06C)
+#define ARSR1P_SHARP_CFG11		(0x070)
+#define ARSR1P_DIFF_CTRL		(0x074)
+#define ARSR1P_LSC_CFG1		(0x078)
+#define ARSR1P_LSC_CFG2		(0x07C)
+#define ARSR1P_LSC_CFG3		(0x080)
+#define ARSR1P_FORCE_CLK_ON_CFG		(0x084)
+
+/*******************************************************************************
+ ** BIT EXT
+ */
+#define BIT_EXT0_CTL (0x000)
+
+#define U_GAMA_R_COEF	(0x000)
+#define U_GAMA_G_COEF	(0x400)
+#define U_GAMA_B_COEF	(0x800)
+#define U_GAMA_R_LAST_COEF (0x200)
+#define U_GAMA_G_LAST_COEF (0x600)
+#define U_GAMA_B_LAST_COEF (0xA00)
+
+#define ACM_U_H_COEF	(0x000)
+#define ACM_U_SATA_COEF	(0x200)
+#define ACM_U_SATR0_COEF	(0x300)
+#define ACM_U_SATR1_COEF	(0x340)
+#define ACM_U_SATR2_COEF	(0x380)
+#define ACM_U_SATR3_COEF	(0x3C0)
+#define ACM_U_SATR4_COEF	(0x400)
+#define ACM_U_SATR5_COEF	(0x440)
+#define ACM_U_SATR6_COEF	(0x480)
+#define ACM_U_SATR7_COEF	(0x4C0)
+
+#define LCP_U_GMP_COEF	(0x0000)
+#define LCP_U_DEGAMA_R_COEF	(0x5000)
+#define LCP_U_DEGAMA_G_COEF	(0x5400)
+#define LCP_U_DEGAMA_B_COEF	(0x5800)
+#define LCP_U_DEGAMA_R_LAST_COEF (0x5200)
+#define LCP_U_DEGAMA_G_LAST_COEF (0x5600)
+#define LCP_U_DEGAMA_B_LAST_COEF (0x5A00)
+
+#define ACE_HIST0	(0x000)
+#define ACE_HIST1	(0x400)
+#define ACE_LUT0	(0x800)
+#define ACE_LUT1	(0xA00)
+
+#define ARSR1P_LSC_GAIN		(0x084)
+#define ARSR1P_COEFF_H_Y0	(0x0F0)
+#define ARSR1P_COEFF_H_Y1	(0x114)
+#define ARSR1P_COEFF_V_Y0	(0x138)
+#define ARSR1P_COEFF_V_Y1	(0x15C)
+#define ARSR1P_COEFF_H_UV0	(0x180)
+#define ARSR1P_COEFF_H_UV1	(0x1A4)
+#define ARSR1P_COEFF_V_UV0	(0x1C8)
+#define ARSR1P_COEFF_V_UV1	(0x1EC)
+
+#define HIACE_INT_STAT (0x0000)
+#define HIACE_INT_UNMASK (0x0004)
+#define HIACE_BYPASS_ACE (0x0008)
+#define HIACE_BYPASS_ACE_STAT (0x000c)
+#define HIACE_UPDATE_LOCAL (0x0010)
+#define HIACE_LOCAL_VALID (0x0014)
+#define HIACE_GAMMA_AB_SHADOW (0x0018)
+#define HIACE_GAMMA_AB_WORK (0x001c)
+#define HIACE_GLOBAL_HIST_AB_SHADOW (0x0020)
+#define HIACE_GLOBAL_HIST_AB_WORK (0x0024)
+#define HIACE_IMAGE_INFO (0x0030)
+#define HIACE_HALF_BLOCK_H_W (0x0034)
+#define HIACE_XYWEIGHT (0x0038)
+#define HIACE_LHIST_SFT (0x003c)
+#define HIACE_HUE (0x0050)
+#define HIACE_SATURATION (0x0054)
+#define HIACE_VALUE (0x0058)
+#define HIACE_SKIN_GAIN (0x005c)
+#define HIACE_UP_LOW_TH (0x0060)
+#define HIACE_UP_CNT (0x0070)
+#define HIACE_LOW_CNT (0x0074)
+#define HIACE_GLOBAL_HIST_LUT_ADDR (0x0080)
+#define HIACE_LHIST_EN (0x0100)
+#define HIACE_LOCAL_HIST_VxHy_2z_2z1 (0x0104)
+#define HIACE_GAMMA_EN (0x0108)
+#define HIACE_GAMMA_VxHy_3z2_3z1_3z_W (0x010c)
+#define HIACE_GAMMA_EN_HV_R (0x0110)
+#define HIACE_GAMMA_VxHy_3z2_3z1_3z_R (0x0114)
+#define HIACE_INIT_GAMMA (0x0120)
+#define HIACE_MANUAL_RELOAD (0x0124)
+#define HIACE_RAMCLK_FUNC (0x0128)
+#define HIACE_CLK_GATE (0x012c)
+#define HIACE_GAMMA_RAM_A_CFG_MEM_CTRL (0x0130)
+#define HIACE_GAMMA_RAM_B_CFG_MEM_CTRL (0x0134)
+#define HIACE_LHIST_RAM_CFG_MEM_CTRL (0x0138)
+#define HIACE_GAMMA_RAM_A_CFG_PM_CTRL (0x0140)
+#define HIACE_GAMMA_RAM_B_CFG_PM_CTRL (0x0144)
+#define HIACE_LHIST_RAM_CFG_PM_CTRL (0x0148)
+
+/*******************************************************************************
+ ** IFBC
+ */
+#define IFBC_SIZE	(0x0000)
+#define IFBC_CTRL	(0x0004)
+#define IFBC_HIMAX_CTRL0	(0x0008)
+#define IFBC_HIMAX_CTRL1	(0x000C)
+#define IFBC_HIMAX_CTRL2	(0x0010)
+#define IFBC_HIMAX_CTRL3	(0x0014)
+#define IFBC_EN	(0x0018)
+#define IFBC_MEM_CTRL	(0x001C)
+#define IFBC_INSERT	(0x0020)
+#define IFBC_HIMAX_TEST_MODE	(0x0024)
+#define IFBC_CORE_GT	(0x0028)
+#define IFBC_PM_CTRL	(0x002C)
+#define IFBC_RD_SHADOW	(0x0030)
+#define IFBC_ORISE_CTL	(0x0034)
+#define IFBC_ORSISE_DEBUG0	(0x0038)
+#define IFBC_ORSISE_DEBUG1	(0x003C)
+#define IFBC_RSP_COMP_TEST	(0x0040)
+#define IFBC_CLK_SEL	(0x044)
+#define IFBC_CLK_EN	(0x048)
+#define IFBC_PAD	(0x004C)
+#define IFBC_REG_DEFAULT	(0x0050)
+
+/*******************************************************************************
+ ** DSC
+ */
+#define DSC_VERSION	(0x0000)
+#define DSC_PPS_IDENTIFIER	(0x0004)
+#define DSC_EN	(0x0008)
+#define DSC_CTRL	(0x000C)
+#define DSC_PIC_SIZE	(0x0010)
+#define DSC_SLICE_SIZE	(0x0014)
+#define DSC_CHUNK_SIZE	(0x0018)
+#define DSC_INITIAL_DELAY	(0x001C)
+#define DSC_RC_PARAM0	(0x0020)
+#define DSC_RC_PARAM1	(0x0024)
+#define DSC_RC_PARAM2	(0x0028)
+#define DSC_RC_PARAM3	(0x002C)
+#define DSC_FLATNESS_QP_TH	(0x0030)
+#define DSC_RC_PARAM4	(0x0034)
+#define DSC_RC_PARAM5	(0x0038)
+#define DSC_RC_BUF_THRESH0	(0x003C)
+#define DSC_RC_BUF_THRESH1	(0x0040)
+#define DSC_RC_BUF_THRESH2	(0x0044)
+#define DSC_RC_BUF_THRESH3	(0x0048)
+#define DSC_RC_RANGE_PARAM0	(0x004C)
+#define DSC_RC_RANGE_PARAM1	(0x0050)
+#define DSC_RC_RANGE_PARAM2	(0x0054)
+#define DSC_RC_RANGE_PARAM3	(0x0058)
+#define DSC_RC_RANGE_PARAM4	(0x005C)
+#define DSC_RC_RANGE_PARAM5	(0x0060)
+#define DSC_RC_RANGE_PARAM6	(0x0064)
+#define DSC_RC_RANGE_PARAM7	(0x0068)
+#define DSC_ADJUSTMENT_BITS	(0x006C)
+#define DSC_BITS_PER_GRP	(0x0070)
+#define DSC_MULTI_SLICE_CTL	(0x0074)
+#define DSC_OUT_CTRL	(0x0078)
+#define DSC_CLK_SEL	(0x007C)
+#define DSC_CLK_EN	(0x0080)
+#define DSC_MEM_CTRL	(0x0084)
+#define DSC_ST_DATAIN	(0x0088)
+#define DSC_ST_DATAOUT	(0x008C)
+#define DSC0_ST_SLC_POS	(0x0090)
+#define DSC1_ST_SLC_POS	(0x0094)
+#define DSC0_ST_PIC_POS	(0x0098)
+#define DSC1_ST_PIC_POS	(0x009C)
+#define DSC0_ST_FIFO	(0x00A0)
+#define DSC1_ST_FIFO	(0x00A4)
+#define DSC0_ST_LINEBUF	(0x00A8)
+#define DSC1_ST_LINEBUF	(0x00AC)
+#define DSC_ST_ITFC	(0x00B0)
+#define DSC_RD_SHADOW_SEL	(0x00B4)
+#define DSC_REG_DEFAULT	(0x00B8)
+
+/*******************************************************************************
+ ** LDI
+ */
+#define LDI_DPI0_HRZ_CTRL0	(0x0000)
+#define LDI_DPI0_HRZ_CTRL1	(0x0004)
+#define LDI_DPI0_HRZ_CTRL2	(0x0008)
+#define LDI_VRT_CTRL0	(0x000C)
+#define LDI_VRT_CTRL1	(0x0010)
+#define LDI_VRT_CTRL2	(0x0014)
+#define LDI_PLR_CTRL	(0x0018)
+#define LDI_SH_MASK_INT	(0x001C)
+#define LDI_3D_CTRL	(0x0020)
+#define LDI_CTRL	(0x0024)
+#define LDI_WORK_MODE	(0x0028)
+#define LDI_DE_SPACE_LOW	(0x002C)
+#define LDI_DSI_CMD_MOD_CTRL	(0x0030)
+#define LDI_DSI_TE_CTRL	(0x0034)
+#define LDI_DSI_TE_HS_NUM	(0x0038)
+#define LDI_DSI_TE_HS_WD	(0x003C)
+#define LDI_DSI_TE_VS_WD	(0x0040)
+#define LDI_FRM_MSK	(0x0044)
+#define LDI_FRM_MSK_UP	(0x0048)
+#define LDI_VINACT_MSK_LEN	(0x0050)
+#define LDI_VSTATE	(0x0054)
+#define LDI_DPI0_HSTATE	(0x0058)
+#define LDI_DPI1_HSTATE	(0x005C)
+#define LDI_CMD_EVENT_SEL	(0x0060)
+#define LDI_SRAM_LP_CTRL	(0x0064)
+#define LDI_ITF_RD_SHADOW	(0x006C)
+#define LDI_DPI1_HRZ_CTRL0	(0x00F0)
+#define LDI_DPI1_HRZ_CTRL1	(0x00F4)
+#define LDI_DPI1_HRZ_CTRL2	(0x00F8)
+#define LDI_OVERLAP_SIZE	(0x00FC)
+#define LDI_MEM_CTRL	(0x0100)
+#define LDI_PM_CTRL	(0x0104)
+#define LDI_CLK_SEL	(0x0108)
+#define LDI_CLK_EN	(0x010C)
+#define LDI_IF_BYPASS	(0x0110)
+#define LDI_FRM_VALID_DBG (0x0118)
+/* LDI GLB*/
+#define LDI_PXL0_DIV2_GT_EN (0x0210)
+#define LDI_PXL0_DIV4_GT_EN (0x0214)
+#define LDI_PXL0_GT_EN (0x0218)
+#define LDI_PXL0_DSI_GT_EN (0x021C)
+#define LDI_PXL0_DIVXCFG (0x0220)
+#define LDI_DSI1_CLK_SEL (0x0224)
+#define LDI_VESA_CLK_SEL (0x0228)
+/* DSI1 RST*/
+#define LDI_DSI1_RST_SEL (0x0238)
+/* LDI INTERRUPT*/
+#define LDI_MCU_ITF_INTS (0x0240)
+#define LDI_MCU_ITF_INT_MSK (0x0244)
+#define LDI_CPU_ITF_INTS (0x0248)
+#define LDI_CPU_ITF_INT_MSK (0x024C)
+/* LDI MODULE CLOCK GATING*/
+#define LDI_MODULE_CLK_SEL (0x0258)
+#define LDI_MODULE_CLK_EN (0x025C)
+
+/*******************************************************************************
+ ** MIPI DSI
+ */
+#define MIPIDSI_VERSION_OFFSET	(0x0000)
+#define MIPIDSI_PWR_UP_OFFSET	(0x0004)
+#define MIPIDSI_CLKMGR_CFG_OFFSET	(0x0008)
+#define MIPIDSI_DPI_VCID_OFFSET	(0x000c)
+#define MIPIDSI_DPI_COLOR_CODING_OFFSET	(0x0010)
+#define MIPIDSI_DPI_CFG_POL_OFFSET	(0x0014)
+#define MIPIDSI_DPI_LP_CMD_TIM_OFFSET	(0x0018)
+#define MIPIDSI_PCKHDL_CFG_OFFSET	(0x002c)
+#define MIPIDSI_GEN_VCID_OFFSET	(0x0030)
+#define MIPIDSI_MODE_CFG_OFFSET	(0x0034)
+#define MIPIDSI_VID_MODE_CFG_OFFSET	(0x0038)
+#define MIPIDSI_VID_PKT_SIZE_OFFSET	(0x003c)
+#define MIPIDSI_VID_NUM_CHUNKS_OFFSET	(0x0040)
+#define MIPIDSI_VID_NULL_SIZE_OFFSET	(0x0044)
+#define MIPIDSI_VID_HSA_TIME_OFFSET	(0x0048)
+#define MIPIDSI_VID_HBP_TIME_OFFSET	(0x004c)
+#define MIPIDSI_VID_HLINE_TIME_OFFSET	(0x0050)
+#define MIPIDSI_VID_VSA_LINES_OFFSET	(0x0054)
+#define MIPIDSI_VID_VBP_LINES_OFFSET	(0x0058)
+#define MIPIDSI_VID_VFP_LINES_OFFSET	(0x005c)
+#define MIPIDSI_VID_VACTIVE_LINES_OFFSET	(0x0060)
+#define MIPIDSI_EDPI_CMD_SIZE_OFFSET	(0x0064)
+#define MIPIDSI_CMD_MODE_CFG_OFFSET	(0x0068)
+#define MIPIDSI_GEN_HDR_OFFSET	(0x006c)
+#define MIPIDSI_GEN_PLD_DATA_OFFSET	(0x0070)
+#define MIPIDSI_CMD_PKT_STATUS_OFFSET	(0x0074)
+#define MIPIDSI_TO_CNT_CFG_OFFSET	(0x0078)
+#define MIPIDSI_HS_RD_TO_CNT_OFFSET	(0x007C)
+#define MIPIDSI_LP_RD_TO_CNT_OFFSET	(0x0080)
+#define MIPIDSI_HS_WR_TO_CNT_OFFSET	(0x0084)
+#define MIPIDSI_LP_WR_TO_CNT_OFFSET	(0x0088)
+#define MIPIDSI_BTA_TO_CNT_OFFSET	(0x008C)
+#define MIPIDSI_SDF_3D_OFFSET	(0x0090)
+#define MIPIDSI_LPCLK_CTRL_OFFSET	(0x0094)
+#define MIPIDSI_PHY_TMR_LPCLK_CFG_OFFSET	(0x0098)
+#define MIPIDSI_PHY_TMR_CFG_OFFSET	(0x009c)
+#define MIPIDSI_PHY_RSTZ_OFFSET	(0x00a0)
+#define MIPIDSI_PHY_IF_CFG_OFFSET	(0x00a4)
+#define MIPIDSI_PHY_ULPS_CTRL_OFFSET	(0x00a8)
+#define MIPIDSI_PHY_TX_TRIGGERS_OFFSET	(0x00ac)
+#define MIPIDSI_PHY_STATUS_OFFSET	(0x00b0)
+#define MIPIDSI_PHY_TST_CTRL0_OFFSET	(0x00b4)
+#define MIPIDSI_PHY_TST_CTRL1_OFFSET	(0x00b8)
+#define MIPIDSI_INT_ST0_OFFSET	(0x00bc)
+#define MIPIDSI_INT_ST1_OFFSET	(0x00c0)
+#define MIPIDSI_INT_MSK0_OFFSET	(0x00c4)
+#define MIPIDSI_INT_MSK1_OFFSET	(0x00c8)
+#define INT_FORCE0	(0x00D8)
+#define INT_FORCE1	(0x00DC)
+#define MIPIDSI_DSC_PARAMETER_OFFSET	(0x00f0)
+#define MIPIDSI_PHY_TMR_RD_CFG_OFFSET	(0x00f4)
+#define VID_SHADOW_CTRL	(0x0100)
+#define DPI_VCID_ACT	(0x010C)
+#define DPI_COLOR_CODING_ACT	(0x0110)
+#define DPI_LP_CMD_TIM_ACT	(0x0118)
+#define VID_MODE_CFG_ACT	(0x0138)
+#define VID_PKT_SIZE_ACT	(0x013C)
+#define VID_NUM_CHUNKS_ACT	(0x0140)
+#define VID_NULL_SIZE_ACT	(0x0144)
+#define VID_HSA_TIME_ACT	(0x0148)
+#define VID_HBP_TIME_ACT	(0x014C)
+#define VID_HLINE_TIME_ACT	(0x0150)
+#define VID_VSA_LINES_ACT	(0x0154)
+#define VID_VBP_LINES_ACT	(0x0158)
+#define VID_VFP_LINES_ACT	(0x015C)
+#define VID_VACTIVE_LINES_ACT	(0x0160)
+#define SDF_3D_ACT	(0x0190)
+
+/*******************************************************************************
+ ** MMBUF
+ */
+#define SMC_LOCK	(0x0000)
+#define SMC_MEM_LP	(0x0004)
+#define SMC_GCLK_CS	(0x000C)
+#define SMC_QOS_BACKDOOR	(0x0010)
+#define SMC_DFX_WCMD_CNT_1ST	(0x0014)
+#define SMC_DFX_WCMD_CNT_2ND	(0x0018)
+#define SMC_DFX_WCMD_CNT_3RD	(0x001C)
+#define SMC_DFX_WCMD_CNT_4TH	(0x0020)
+#define SMC_DFX_RCMD_CNT_1ST	(0x0024)
+#define SMC_DFX_RCMD_CNT_2ND	(0x0028)
+#define SMC_DFX_RCMD_CNT_3RD	(0x002C)
+#define SMC_DFX_RCMD_CNT_4TH	(0x0030)
+#define SMC_CS_IDLE	(0x0034)
+#define SMC_DFX_BFIFO_CNT0	(0x0038)
+#define SMC_DFX_RDFIFO_CNT1	(0x003C)
+#define SMC_SP_SRAM_STATE0	(0x0040)
+#define SMC_SP_SRAM_STATE1	(0x0044)
+
+enum hisi_fb_pixel_format {
+	HISI_FB_PIXEL_FORMAT_RGB_565 = 0,
+	HISI_FB_PIXEL_FORMAT_RGBX_4444,
+	HISI_FB_PIXEL_FORMAT_RGBA_4444,
+	HISI_FB_PIXEL_FORMAT_RGBX_5551,
+	HISI_FB_PIXEL_FORMAT_RGBA_5551,
+	HISI_FB_PIXEL_FORMAT_RGBX_8888,
+	HISI_FB_PIXEL_FORMAT_RGBA_8888,
+
+	HISI_FB_PIXEL_FORMAT_BGR_565,
+	HISI_FB_PIXEL_FORMAT_BGRX_4444,
+	HISI_FB_PIXEL_FORMAT_BGRA_4444,
+	HISI_FB_PIXEL_FORMAT_BGRX_5551,
+	HISI_FB_PIXEL_FORMAT_BGRA_5551,
+	HISI_FB_PIXEL_FORMAT_BGRX_8888,
+	HISI_FB_PIXEL_FORMAT_BGRA_8888,
+
+	HISI_FB_PIXEL_FORMAT_YUV_422_I,
+
+	/* YUV Semi-planar */
+	HISI_FB_PIXEL_FORMAT_YCbCr_422_SP,	/* NV16 */
+	HISI_FB_PIXEL_FORMAT_YCrCb_422_SP,
+	HISI_FB_PIXEL_FORMAT_YCbCr_420_SP,
+	HISI_FB_PIXEL_FORMAT_YCrCb_420_SP,	/* NV21 */
+
+	/* YUV Planar */
+	HISI_FB_PIXEL_FORMAT_YCbCr_422_P,
+	HISI_FB_PIXEL_FORMAT_YCrCb_422_P,
+	HISI_FB_PIXEL_FORMAT_YCbCr_420_P,
+	HISI_FB_PIXEL_FORMAT_YCrCb_420_P,	/* HISI_FB_PIXEL_FORMAT_YV12 */
+
+	/* YUV Package */
+	HISI_FB_PIXEL_FORMAT_YUYV_422_Pkg,
+	HISI_FB_PIXEL_FORMAT_UYVY_422_Pkg,
+	HISI_FB_PIXEL_FORMAT_YVYU_422_Pkg,
+	HISI_FB_PIXEL_FORMAT_VYUY_422_Pkg,
+	HISI_FB_PIXEL_FORMAT_MAX,
+
+	HISI_FB_PIXEL_FORMAT_UNSUPPORT = 800
+};
+
+struct dss_hw_ctx {
+	void __iomem *base;
+	struct regmap *noc_regmap;
+	struct reset_control *reset;
+
+	void __iomem *noc_dss_base;
+	void __iomem *peri_crg_base;
+	void __iomem *pmc_base;
+	void __iomem *sctrl_base;
+
+	struct clk *dss_axi_clk;
+	struct clk *dss_pclk_dss_clk;
+	struct clk *dss_pri_clk;
+	struct clk *dss_pxl0_clk;
+	struct clk *dss_pxl1_clk;
+	struct clk *dss_mmbuf_clk;
+	struct clk *dss_pclk_mmbuf_clk;
+
+	bool power_on;
+	int irq;
+
+	wait_queue_head_t vactive0_start_wq;
+	u32 vactive0_start_flag;
+	ktime_t vsync_timestamp;
+	ktime_t vsync_timestamp_prev;
+
+	struct iommu_domain *mmu_domain;
+	struct ion_client *ion_client;
+	struct ion_handle *ion_handle;
+	struct iommu_map_format iommu_format;
+	char __iomem *screen_base;
+	unsigned long smem_start;
+	unsigned long screen_size;
+};
+
+struct dss_crtc {
+	struct drm_crtc base;
+	struct dss_hw_ctx *ctx;
+	bool enable;
+	u32 out_format;
+	u32 bgr_fmt;
+};
+
+struct dss_plane {
+	struct drm_plane base;
+	/*void *ctx;*/
+	void *acrtc;
+	u8 ch; /* channel */
+};
+
+struct dss_data {
+	struct dss_crtc acrtc;
+	struct dss_plane aplane[DSS_CH_NUM];
+	struct dss_hw_ctx ctx;
+};
+
+/* ade-format info: */
+struct dss_format {
+	u32 pixel_format;
+	enum hisi_fb_pixel_format dss_format;
+};
+
+#define MIPI_DPHY_NUM	(2)
+
+/* IFBC compress mode */
+enum IFBC_TYPE {
+	IFBC_TYPE_NONE = 0,
+	IFBC_TYPE_ORISE2X,
+	IFBC_TYPE_ORISE3X,
+	IFBC_TYPE_HIMAX2X,
+	IFBC_TYPE_RSP2X,
+	IFBC_TYPE_RSP3X,
+	IFBC_TYPE_VESA2X_SINGLE,
+	IFBC_TYPE_VESA3X_SINGLE,
+	IFBC_TYPE_VESA2X_DUAL,
+	IFBC_TYPE_VESA3X_DUAL,
+	IFBC_TYPE_VESA3_75X_DUAL,
+
+	IFBC_TYPE_MAX
+};
+
+/* IFBC compress mode */
+enum IFBC_COMP_MODE {
+	IFBC_COMP_MODE_0 = 0,
+	IFBC_COMP_MODE_1,
+	IFBC_COMP_MODE_2,
+	IFBC_COMP_MODE_3,
+	IFBC_COMP_MODE_4,
+	IFBC_COMP_MODE_5,
+	IFBC_COMP_MODE_6,
+};
+
+/* xres_div */
+enum XRES_DIV {
+	XRES_DIV_1 = 1,
+	XRES_DIV_2,
+	XRES_DIV_3,
+	XRES_DIV_4,
+	XRES_DIV_5,
+	XRES_DIV_6,
+};
+
+/* yres_div */
+enum YRES_DIV {
+	YRES_DIV_1 = 1,
+	YRES_DIV_2,
+	YRES_DIV_3,
+	YRES_DIV_4,
+	YRES_DIV_5,
+	YRES_DIV_6,
+};
+
+/* pxl0_divxcfg */
+enum PXL0_DIVCFG {
+	PXL0_DIVCFG_0 = 0,
+	PXL0_DIVCFG_1,
+	PXL0_DIVCFG_2,
+	PXL0_DIVCFG_3,
+	PXL0_DIVCFG_4,
+	PXL0_DIVCFG_5,
+	PXL0_DIVCFG_6,
+	PXL0_DIVCFG_7,
+};
+
+/* pxl0_div2_gt_en */
+enum PXL0_DIV2_GT_EN {
+	PXL0_DIV2_GT_EN_CLOSE = 0,
+	PXL0_DIV2_GT_EN_OPEN,
+};
+
+/* pxl0_div4_gt_en */
+enum PXL0_DIV4_GT_EN {
+	PXL0_DIV4_GT_EN_CLOSE = 0,
+	PXL0_DIV4_GT_EN_OPEN,
+};
+
+/* pxl0_dsi_gt_en */
+enum PXL0_DSI_GT_EN {
+	PXL0_DSI_GT_EN_0 = 0,
+	PXL0_DSI_GT_EN_1,
+	PXL0_DSI_GT_EN_2,
+	PXL0_DSI_GT_EN_3,
+};
+
+typedef struct mipi_ifbc_division {
+	u32 xres_div;
+	u32 yres_div;
+	u32 comp_mode;
+	u32 pxl0_div2_gt_en;
+	u32 pxl0_div4_gt_en;
+	u32 pxl0_divxcfg;
+	u32 pxl0_dsi_gt_en;
+} mipi_ifbc_division_t;
+
+/*******************************************************************************
+**
+*/
+#define outp32(addr, val) writel(val, addr)
+#define outp16(addr, val) writew(val, addr)
+#define outp8(addr, val) writeb(val, addr)
+#define outp(addr, val) outp32(addr, val)
+
+#define inp32(addr) readl(addr)
+#define inp16(addr) readw(addr)
+#define inp8(addr) readb(addr)
+#define inp(addr) inp32(addr)
+
+#define inpw(port) readw(port)
+#define outpw(port, val) writew(val, port)
+#define inpdw(port) readl(port)
+#define outpdw(port, val) writel(val, port)
+
+#ifndef ALIGN_DOWN
+#define ALIGN_DOWN(val, al)  ((val) & ~((al) - 1))
+#endif
+#ifndef ALIGN_UP
+#define ALIGN_UP(val, al)    (((val) + ((al) - 1)) & ~((al) - 1))
+#endif
+
+#define to_dss_crtc(crtc) \
+	container_of(crtc, struct dss_crtc, base)
+
+#define to_dss_plane(plane) \
+	container_of(plane, struct dss_plane, base)
+
+#endif
diff --git a/drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.c b/drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.c
new file mode 100644
index 000000000000..2d6809b72b42
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.c
@@ -0,0 +1,731 @@
+/* Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <drm/drmP.h>
+
+#include "drm_mipi_dsi.h"
+#include "kirin_drm_dpe_utils.h"
+
+int g_debug_set_reg_val = 0;
+
+extern u32 g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX];
+
+mipi_ifbc_division_t g_mipi_ifbc_division[MIPI_DPHY_NUM][IFBC_TYPE_MAX] = {
+	/*single mipi*/
+	{
+		/*none*/
+		{XRES_DIV_1, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_0, PXL0_DSI_GT_EN_1},
+		/*orise2x*/
+		{XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3},
+		/*orise3x*/
+		{XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_1, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3},
+		/*himax2x*/
+		{XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_2, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3},
+		/*rsp2x*/
+		{XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_3, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3},
+		/*rsp3x  [NOTE]reality: xres_div = 1.5, yres_div = 2, amended in "mipi_ifbc_get_rect" function*/
+		{XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_4, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3},
+		/*vesa2x_1pipe*/
+		{XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3},
+		/*vesa3x_1pipe*/
+		{XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3},
+		/*vesa2x_2pipe*/
+		{XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3},
+		/*vesa3x_2pipe*/
+		{XRES_DIV_3, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_2, PXL0_DSI_GT_EN_3}
+	},
+
+	/*dual mipi*/
+	{
+		/*none*/
+		{XRES_DIV_2, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_1, PXL0_DSI_GT_EN_3},
+		/*orise2x*/
+		{XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_0, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3},
+		/*orise3x*/
+		{XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_1, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3},
+		/*himax2x*/
+		{XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_2, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3},
+		/*rsp2x*/
+		{XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_3, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3},
+		/*rsp3x*/
+		{XRES_DIV_3, YRES_DIV_2, IFBC_COMP_MODE_4, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_OPEN, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3},
+		/*vesa2x_1pipe*/
+		{XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3},
+		/*vesa3x_1pipe*/
+		{XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_5, PXL0_DIV2_GT_EN_CLOSE,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, PXL0_DSI_GT_EN_3},
+		/*vesa2x_2pipe*/
+		{XRES_DIV_4, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_3, PXL0_DSI_GT_EN_3},
+		/*vesa3x_2pipe*/
+		{XRES_DIV_6, YRES_DIV_1, IFBC_COMP_MODE_6, PXL0_DIV2_GT_EN_OPEN,
+			PXL0_DIV4_GT_EN_CLOSE, PXL0_DIVCFG_5, 3} }
+};
+
+void set_reg(char __iomem *addr, uint32_t val, uint8_t bw, uint8_t bs)
+{
+	u32 mask = (1UL << bw) - 1UL;
+	u32 tmp = 0;
+
+	tmp = inp32(addr);
+	tmp &= ~(mask << bs);
+
+	outp32(addr, tmp | ((val & mask) << bs));
+
+	if (g_debug_set_reg_val) {
+		printk(KERN_INFO "writel: [%p] = 0x%x\n", addr,
+			     tmp | ((val & mask) << bs));
+	}
+}
+
+static int mipi_ifbc_get_rect(struct dss_rect *rect)
+{
+	u32 ifbc_type;
+	u32 mipi_idx;
+	u32 xres_div;
+	u32 yres_div;
+
+	ifbc_type = IFBC_TYPE_NONE;
+	mipi_idx = 0;
+
+	xres_div = g_mipi_ifbc_division[mipi_idx][ifbc_type].xres_div;
+	yres_div = g_mipi_ifbc_division[mipi_idx][ifbc_type].yres_div;
+
+	if ((rect->w % xres_div) > 0)
+		DRM_ERROR("xres(%d) is not division_h(%d) pixel aligned!\n", rect->w, xres_div);
+
+	if ((rect->h % yres_div) > 0)
+		DRM_ERROR("yres(%d) is not division_v(%d) pixel aligned!\n", rect->h, yres_div);
+
+	/*
+	** [NOTE] rsp3x && single_mipi CMD mode amended xres_div = 1.5, yres_div = 2 ,
+	** VIDEO mode amended xres_div = 3, yres_div = 1
+	*/
+	rect->w /= xres_div;
+	rect->h /= yres_div;
+
+	return 0;
+}
+
+static void init_ldi_pxl_div(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *ldi_base;
+	struct drm_display_mode *mode;
+	struct drm_display_mode *adj_mode;
+
+	u32 ifbc_type = 0;
+	u32 mipi_idx = 0;
+	u32 pxl0_div2_gt_en = 0;
+	u32 pxl0_div4_gt_en = 0;
+	u32 pxl0_divxcfg = 0;
+	u32 pxl0_dsi_gt_en = 0;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	mode = &acrtc->base.state->mode;
+	adj_mode = &acrtc->base.state->adjusted_mode;
+
+	ldi_base = ctx->base + DSS_LDI0_OFFSET;
+
+	ifbc_type = IFBC_TYPE_NONE;
+	mipi_idx = 0;
+
+	pxl0_div2_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_div2_gt_en;
+	pxl0_div4_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_div4_gt_en;
+	pxl0_divxcfg = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_divxcfg;
+	pxl0_dsi_gt_en = g_mipi_ifbc_division[mipi_idx][ifbc_type].pxl0_dsi_gt_en;
+
+	set_reg(ldi_base + LDI_PXL0_DIV2_GT_EN, pxl0_div2_gt_en, 1, 0);
+	set_reg(ldi_base + LDI_PXL0_DIV4_GT_EN, pxl0_div4_gt_en, 1, 0);
+	set_reg(ldi_base + LDI_PXL0_GT_EN, 0x1, 1, 0);
+	set_reg(ldi_base + LDI_PXL0_DSI_GT_EN, pxl0_dsi_gt_en, 2, 0);
+	set_reg(ldi_base + LDI_PXL0_DIVXCFG, pxl0_divxcfg, 3, 0);
+}
+
+void init_other(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *dss_base;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	dss_base = ctx->base;
+
+	/**
+	 * VESA_CLK_SEL is set to 0 for initial,
+	 * 1 is needed only by vesa dual pipe compress
+	 */
+	set_reg(dss_base + DSS_LDI0_OFFSET + LDI_VESA_CLK_SEL, 0, 1, 0);
+}
+
+void init_ldi(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *ldi_base;
+	struct drm_display_mode *mode;
+	struct drm_display_mode *adj_mode;
+
+	dss_rect_t rect = {0, 0, 0, 0};
+	u32 hfp, hbp, hsw, vfp, vbp, vsw;
+	u32 vsync_plr = 0;
+	u32 hsync_plr = 0;
+	u32 pixelclk_plr = 0;
+	u32 data_en_plr = 0;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return ;
+	}
+
+	mode = &acrtc->base.state->mode;
+	adj_mode = &acrtc->base.state->adjusted_mode;
+
+	hfp = mode->hsync_start - mode->hdisplay;
+	hbp = mode->htotal - mode->hsync_end;
+	hsw = mode->hsync_end - mode->hsync_start;
+	vfp = mode->vsync_start - mode->vdisplay;
+	vbp = mode->vtotal - mode->vsync_end;
+	vsw = mode->vsync_end - mode->vsync_start;
+
+	ldi_base = ctx->base + DSS_LDI0_OFFSET;
+
+	rect.x = 0;
+	rect.y = 0;
+	rect.w = mode->hdisplay;
+	rect.h = mode->vdisplay;
+	mipi_ifbc_get_rect(&rect);
+
+	init_ldi_pxl_div(acrtc);
+
+	outp32(ldi_base + LDI_DPI0_HRZ_CTRL0,
+		hfp | ((hbp + DSS_WIDTH(hsw)) << 16));
+	outp32(ldi_base + LDI_DPI0_HRZ_CTRL1, 0);
+	outp32(ldi_base + LDI_DPI0_HRZ_CTRL2, DSS_WIDTH(rect.w));
+	outp32(ldi_base + LDI_VRT_CTRL0,
+		vfp | (vbp << 16));
+	outp32(ldi_base + LDI_VRT_CTRL1, DSS_HEIGHT(vsw));
+	outp32(ldi_base + LDI_VRT_CTRL2, DSS_HEIGHT(rect.h));
+
+	outp32(ldi_base + LDI_PLR_CTRL,
+		vsync_plr | (hsync_plr << 1) |
+		(pixelclk_plr << 2) | (data_en_plr << 3));
+
+	/* bpp*/
+	set_reg(ldi_base + LDI_CTRL, acrtc->out_format, 2, 3);
+	/* bgr*/
+	set_reg(ldi_base + LDI_CTRL, acrtc->bgr_fmt, 1, 13);
+
+	/* for ddr pmqos*/
+	outp32(ldi_base + LDI_VINACT_MSK_LEN, vfp);
+
+	/*cmd event sel*/
+	outp32(ldi_base + LDI_CMD_EVENT_SEL, 0x1);
+
+	/* for 1Hz LCD and mipi command LCD*/
+	set_reg(ldi_base + LDI_DSI_CMD_MOD_CTRL, 0x1, 1, 1);
+
+	/*ldi_data_gate(hisifd, true);*/
+
+#ifdef CONFIG_HISI_FB_LDI_COLORBAR_USED
+	/* colorbar width*/
+	set_reg(ldi_base + LDI_CTRL, DSS_WIDTH(0x3c), 7, 6);
+	/* colorbar ort*/
+	set_reg(ldi_base + LDI_WORK_MODE, 0x0, 1, 1);
+	/* colorbar enable*/
+	set_reg(ldi_base + LDI_WORK_MODE, 0x0, 1, 0);
+#else
+	/* normal*/
+	set_reg(ldi_base + LDI_WORK_MODE, 0x1, 1, 0);
+#endif
+
+	/* ldi disable*/
+	set_reg(ldi_base + LDI_CTRL, 0x0, 1, 0);
+}
+
+void init_dbuf(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	struct drm_display_mode *mode;
+	struct drm_display_mode *adj_mode;
+	char __iomem *dbuf_base;
+
+	int sram_valid_num = 0;
+	int sram_max_mem_depth = 0;
+	int sram_min_support_depth = 0;
+
+	u32 thd_rqos_in = 0;
+	u32 thd_rqos_out = 0;
+	u32 thd_wqos_in = 0;
+	u32 thd_wqos_out = 0;
+	u32 thd_cg_in = 0;
+	u32 thd_cg_out = 0;
+	u32 thd_wr_wait = 0;
+	u32 thd_cg_hold = 0;
+	u32 thd_flux_req_befdfs_in = 0;
+	u32 thd_flux_req_befdfs_out = 0;
+	u32 thd_flux_req_aftdfs_in = 0;
+	u32 thd_flux_req_aftdfs_out = 0;
+	u32 thd_dfs_ok = 0;
+	u32 dfs_ok_mask = 0;
+	u32 thd_flux_req_sw_en = 1;
+	u32 hfp, hbp, hsw, vfp, vbp, vsw;
+
+	int dfs_time = 0;
+	int dfs_time_min = 0;
+	int depth = 0;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	mode = &acrtc->base.state->mode;
+	adj_mode = &acrtc->base.state->adjusted_mode;
+
+	hfp = mode->hsync_start - mode->hdisplay;
+	hbp = mode->htotal - mode->hsync_end;
+	hsw = mode->hsync_end - mode->hsync_start;
+	vfp = mode->vsync_start - mode->vdisplay;
+	vbp = mode->vtotal - mode->vsync_end;
+	vsw = mode->vsync_end - mode->vsync_start;
+
+	dbuf_base = ctx->base + DSS_DBUF0_OFFSET;
+
+	if (mode->hdisplay * mode->vdisplay >= RES_4K_PHONE)
+		dfs_time_min = DFS_TIME_MIN_4K;
+	else
+		dfs_time_min = DFS_TIME_MIN;
+
+	dfs_time = DFS_TIME;
+	depth = DBUF0_DEPTH;
+
+	DRM_DEBUG("dfs_time=%d,\n"
+		"adj_mode->clock=%d\n"
+		"hsw=%d\n"
+		"hbp=%d\n"
+		"hfp=%d\n"
+		"mode->hdisplay=%d\n"
+		"mode->vdisplay=%d\n",
+		dfs_time,
+		adj_mode->clock,
+		hsw,
+		hbp,
+		hfp,
+		mode->hdisplay,
+		mode->vdisplay);
+
+	/*
+	** int K = 0;
+	** int Tp = 1000000  / adj_mode->clock;
+	** K = (hsw + hbp + mode->hdisplay +
+	**	hfp) / mode->hdisplay;
+	** thd_cg_out = dfs_time / (Tp * K * 6);
+	*/
+	thd_cg_out = (dfs_time * adj_mode->clock * 1000UL * mode->hdisplay) /
+		(((hsw + hbp + hfp) + mode->hdisplay) * 6 * 1000000UL);
+
+	sram_valid_num = thd_cg_out / depth;
+	thd_cg_in = (sram_valid_num + 1) * depth - 1;
+
+	sram_max_mem_depth = (sram_valid_num + 1) * depth;
+
+	thd_rqos_in = thd_cg_out * 85 / 100;
+	thd_rqos_out = thd_cg_out;
+	thd_flux_req_befdfs_in = GET_FLUX_REQ_IN(sram_max_mem_depth);
+	thd_flux_req_befdfs_out = GET_FLUX_REQ_OUT(sram_max_mem_depth);
+
+	sram_min_support_depth = dfs_time_min * mode->hdisplay / (1000000 / 60 / (mode->vdisplay +
+		vbp + vfp + vsw) * (DBUF_WIDTH_BIT / 3 / BITS_PER_BYTE));
+
+	/*thd_flux_req_aftdfs_in   =[(sram_valid_num+1)*depth - 50*HSIZE/((1000000/60/(VSIZE+VFP+VBP+VSW))*6)]/3*/
+	thd_flux_req_aftdfs_in = (sram_max_mem_depth - sram_min_support_depth) / 3;
+	/*thd_flux_req_aftdfs_out  =  2*[(sram_valid_num+1)* depth - 50*HSIZE/((1000000/60/(VSIZE+VFP+VBP+VSW))*6)]/3*/
+	thd_flux_req_aftdfs_out = 2 * (sram_max_mem_depth - sram_min_support_depth) / 3;
+
+	thd_dfs_ok = thd_flux_req_befdfs_in;
+
+	DRM_DEBUG("hdisplay=%d\n"
+		"vdisplay=%d\n"
+		"sram_valid_num=%d,\n"
+		"thd_rqos_in=0x%x\n"
+		"thd_rqos_out=0x%x\n"
+		"thd_cg_in=0x%x\n"
+		"thd_cg_out=0x%x\n"
+		"thd_flux_req_befdfs_in=0x%x\n"
+		"thd_flux_req_befdfs_out=0x%x\n"
+		"thd_flux_req_aftdfs_in=0x%x\n"
+		"thd_flux_req_aftdfs_out=0x%x\n"
+		"thd_dfs_ok=0x%x\n",
+		mode->hdisplay,
+		mode->vdisplay,
+		sram_valid_num,
+		thd_rqos_in,
+		thd_rqos_out,
+		thd_cg_in,
+		thd_cg_out,
+		thd_flux_req_befdfs_in,
+		thd_flux_req_befdfs_out,
+		thd_flux_req_aftdfs_in,
+		thd_flux_req_aftdfs_out,
+		thd_dfs_ok);
+
+	outp32(dbuf_base + DBUF_FRM_SIZE, mode->hdisplay * mode->vdisplay);
+	outp32(dbuf_base + DBUF_FRM_HSIZE, DSS_WIDTH(mode->hdisplay));
+	outp32(dbuf_base + DBUF_SRAM_VALID_NUM, sram_valid_num);
+
+	outp32(dbuf_base + DBUF_THD_RQOS, (thd_rqos_out << 16) | thd_rqos_in);
+	outp32(dbuf_base + DBUF_THD_WQOS, (thd_wqos_out << 16) | thd_wqos_in);
+	outp32(dbuf_base + DBUF_THD_CG, (thd_cg_out << 16) | thd_cg_in);
+	outp32(dbuf_base + DBUF_THD_OTHER, (thd_cg_hold << 16) | thd_wr_wait);
+	outp32(dbuf_base + DBUF_THD_FLUX_REQ_BEF, (thd_flux_req_befdfs_out << 16) | thd_flux_req_befdfs_in);
+	outp32(dbuf_base + DBUF_THD_FLUX_REQ_AFT, (thd_flux_req_aftdfs_out << 16) | thd_flux_req_aftdfs_in);
+	outp32(dbuf_base + DBUF_THD_DFS_OK, thd_dfs_ok);
+	outp32(dbuf_base + DBUF_FLUX_REQ_CTRL, (dfs_ok_mask << 1) | thd_flux_req_sw_en);
+
+	outp32(dbuf_base + DBUF_DFS_LP_CTRL, 0x1);
+}
+
+void init_dpp(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	struct drm_display_mode *mode;
+	struct drm_display_mode *adj_mode;
+	char __iomem *dpp_base;
+	char __iomem *mctl_sys_base;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	mode = &acrtc->base.state->mode;
+	adj_mode = &acrtc->base.state->adjusted_mode;
+
+	dpp_base = ctx->base + DSS_DPP_OFFSET;
+	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
+
+	outp32(dpp_base + DPP_IMG_SIZE_BEF_SR,
+		(DSS_HEIGHT(mode->vdisplay) << 16) | DSS_WIDTH(mode->hdisplay));
+	outp32(dpp_base + DPP_IMG_SIZE_AFT_SR,
+		(DSS_HEIGHT(mode->vdisplay) << 16) | DSS_WIDTH(mode->hdisplay));
+
+#ifdef CONFIG_HISI_FB_DPP_COLORBAR_USED
+	void __iomem *mctl_base;
+	outp32(dpp_base + DPP_CLRBAR_CTRL, (0x30 << 24) |(0 << 1) | 0x1);
+	set_reg(dpp_base + DPP_CLRBAR_1ST_CLR, 0xFF, 8, 16);
+	set_reg(dpp_base + DPP_CLRBAR_2ND_CLR, 0xFF, 8, 8);
+	set_reg(dpp_base + DPP_CLRBAR_3RD_CLR, 0xFF, 8, 0);
+
+	mctl_base = ctx->base +
+		g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
+
+	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x1, 1, 0);
+	set_reg(mctl_base + MCTL_CTL_EN, 0x1, 32, 0);
+	set_reg(mctl_base + MCTL_CTL_TOP, 0x2, 32, 0); /*auto mode*/
+	set_reg(mctl_base + MCTL_CTL_DBG, 0xB13A00, 32, 0);
+
+	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 2, 0);
+	set_reg(mctl_sys_base + MCTL_OV0_FLUSH_EN, 0x8, 4, 0);
+	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x0, 1, 0);
+#endif
+}
+
+void enable_ldi(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *ldi_base;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	ldi_base = ctx->base + DSS_LDI0_OFFSET;
+
+	/* ldi enable */
+	set_reg(ldi_base + LDI_CTRL, 0x1, 1, 0);
+}
+
+void disable_ldi(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *ldi_base;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	ldi_base = ctx->base + DSS_LDI0_OFFSET;
+
+	/* ldi disable */
+	set_reg(ldi_base + LDI_CTRL, 0x0, 1, 0);
+}
+
+void dpe_interrupt_clear(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *dss_base;
+	u32 clear;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	dss_base = ctx->base;
+
+	clear = ~0;
+	outp32(dss_base + GLB_CPU_PDP_INTS, clear);
+	outp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS, clear);
+	outp32(dss_base + DSS_DPP_OFFSET + DPP_INTS, clear);
+
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_MCTL_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_WCH0_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_WCH1_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH0_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH1_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH2_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH3_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH4_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH5_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH6_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH7_INTS, clear);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_DSS_GLB_INTS, clear);
+}
+
+void dpe_interrupt_unmask(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *dss_base;
+	u32 unmask;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	dss_base = ctx->base;
+
+	unmask = ~0;
+	unmask &= ~(BIT_DPP_INTS | BIT_ITF0_INTS | BIT_MMU_IRPT_NS);
+	outp32(dss_base + GLB_CPU_PDP_INT_MSK, unmask);
+
+	unmask = ~0;
+	unmask &= ~(BIT_VSYNC | BIT_VACTIVE0_START
+		| BIT_VACTIVE0_END | BIT_FRM_END | BIT_LDI_UNFLOW);
+
+	outp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK, unmask);
+}
+
+void dpe_interrupt_mask(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *dss_base;
+	u32 mask;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return ;
+	}
+
+	dss_base = ctx->base;
+
+	mask = ~0;
+	outp32(dss_base + GLB_CPU_PDP_INT_MSK, mask);
+	outp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK, mask);
+	outp32(dss_base + DSS_DPP_OFFSET + DPP_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_DSS_GLB_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_MCTL_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_WCH0_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_WCH1_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH0_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH1_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH2_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH3_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH4_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH5_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH6_INT_MSK, mask);
+	outp32(dss_base + DSS_DBG_OFFSET + DBG_RCH7_INT_MSK, mask);
+}
+
+int dpe_init(struct dss_crtc *acrtc)
+{
+	struct drm_display_mode *mode;
+	struct drm_display_mode *adj_mode;
+
+	mode = &acrtc->base.state->mode;
+	adj_mode = &acrtc->base.state->adjusted_mode;
+
+	init_dbuf(acrtc);
+	init_dpp(acrtc);
+	init_other(acrtc);
+	init_ldi(acrtc);
+
+	hisifb_dss_on(acrtc->ctx);
+	hisi_dss_mctl_on(acrtc->ctx);
+
+	hisi_dss_mctl_mutex_lock(acrtc->ctx);
+
+	hisi_dss_ovl_base_config(acrtc->ctx, mode->hdisplay, mode->vdisplay);
+
+	hisi_dss_mctl_mutex_unlock(acrtc->ctx);
+
+	enable_ldi(acrtc);
+
+	mdelay(60);
+
+	return 0;
+}
+
+void dss_inner_clk_pdp_enable(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *dss_base;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+	dss_base = ctx->base;
+
+	outp32(dss_base + DSS_IFBC_OFFSET + IFBC_MEM_CTRL, 0x00000088);
+	outp32(dss_base + DSS_DSC_OFFSET + DSC_MEM_CTRL, 0x00000888);
+	outp32(dss_base + DSS_LDI0_OFFSET + LDI_MEM_CTRL, 0x00000008);
+	outp32(dss_base + DSS_DBUF0_OFFSET + DBUF_MEM_CTRL, 0x00000008);
+	outp32(dss_base + DSS_DPP_DITHER_OFFSET + DITHER_MEM_CTRL, 0x00000008);
+}
+
+void dss_inner_clk_common_enable(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+	char __iomem *dss_base;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+	dss_base = ctx->base;
+
+	/*core/axi/mmbuf*/
+	outp32(dss_base + DSS_CMDLIST_OFFSET + CMD_MEM_CTRL, 0x00000008);  /*cmd mem*/
+
+	outp32(dss_base + DSS_RCH_VG0_SCL_OFFSET + SCF_COEF_MEM_CTRL, 0x00000088);/*rch_v0 ,scf mem*/
+	outp32(dss_base + DSS_RCH_VG0_SCL_OFFSET + SCF_LB_MEM_CTRL, 0x00000008);/*rch_v0 ,scf mem*/
+	outp32(dss_base + DSS_RCH_VG0_ARSR_OFFSET + ARSR2P_LB_MEM_CTRL, 0x00000008);/*rch_v0 ,arsr2p mem*/
+	outp32(dss_base + DSS_RCH_VG0_DMA_OFFSET + VPP_MEM_CTRL, 0x00000008);/*rch_v0 ,vpp mem*/
+	outp32(dss_base + DSS_RCH_VG0_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_v0 ,dma_buf mem*/
+	outp32(dss_base + DSS_RCH_VG0_DMA_OFFSET + AFBCD_MEM_CTRL, 0x00008888);/*rch_v0 ,afbcd mem*/
+
+	outp32(dss_base + DSS_RCH_VG1_SCL_OFFSET + SCF_COEF_MEM_CTRL, 0x00000088);/*rch_v1 ,scf mem*/
+	outp32(dss_base + DSS_RCH_VG1_SCL_OFFSET + SCF_LB_MEM_CTRL, 0x00000008);/*rch_v1 ,scf mem*/
+	outp32(dss_base + DSS_RCH_VG1_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_v1 ,dma_buf mem*/
+	outp32(dss_base + DSS_RCH_VG1_DMA_OFFSET + AFBCD_MEM_CTRL, 0x00008888);/*rch_v1 ,afbcd mem*/
+
+	outp32(dss_base + DSS_RCH_VG2_SCL_OFFSET + SCF_COEF_MEM_CTRL, 0x00000088);/*rch_v2 ,scf mem*/
+	outp32(dss_base + DSS_RCH_VG2_SCL_OFFSET + SCF_LB_MEM_CTRL, 0x00000008);/*rch_v2 ,scf mem*/
+	outp32(dss_base + DSS_RCH_VG2_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_v2 ,dma_buf mem*/
+
+	outp32(dss_base + DSS_RCH_G0_SCL_OFFSET + SCF_COEF_MEM_CTRL, 0x00000088);/*rch_g0 ,scf mem*/
+	outp32(dss_base + DSS_RCH_G0_SCL_OFFSET + SCF_LB_MEM_CTRL, 0x0000008);/*rch_g0 ,scf mem*/
+	outp32(dss_base + DSS_RCH_G0_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_g0 ,dma_buf mem*/
+	outp32(dss_base + DSS_RCH_G0_DMA_OFFSET + AFBCD_MEM_CTRL, 0x00008888);/*rch_g0 ,afbcd mem*/
+
+	outp32(dss_base + DSS_RCH_G1_SCL_OFFSET + SCF_COEF_MEM_CTRL, 0x00000088);/*rch_g1 ,scf mem*/
+	outp32(dss_base + DSS_RCH_G1_SCL_OFFSET + SCF_LB_MEM_CTRL, 0x0000008);/*rch_g1 ,scf mem*/
+	outp32(dss_base + DSS_RCH_G1_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_g1 ,dma_buf mem*/
+	outp32(dss_base + DSS_RCH_G1_DMA_OFFSET + AFBCD_MEM_CTRL, 0x00008888);/*rch_g1 ,afbcd mem*/
+
+	outp32(dss_base + DSS_RCH_D0_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_d0 ,dma_buf mem*/
+	outp32(dss_base + DSS_RCH_D0_DMA_OFFSET + AFBCD_MEM_CTRL, 0x00008888);/*rch_d0 ,afbcd mem*/
+	outp32(dss_base + DSS_RCH_D1_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_d1 ,dma_buf mem*/
+	outp32(dss_base + DSS_RCH_D2_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_d2 ,dma_buf mem*/
+	outp32(dss_base + DSS_RCH_D3_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*rch_d3 ,dma_buf mem*/
+
+	outp32(dss_base + DSS_WCH0_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*wch0 DMA/AFBCE mem*/
+	outp32(dss_base + DSS_WCH0_DMA_OFFSET + AFBCE_MEM_CTRL, 0x00000888);/*wch0 DMA/AFBCE mem*/
+	outp32(dss_base + DSS_WCH0_DMA_OFFSET + ROT_MEM_CTRL, 0x00000008);/*wch0 rot mem*/
+	outp32(dss_base + DSS_WCH1_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*wch1 DMA/AFBCE mem*/
+	outp32(dss_base + DSS_WCH1_DMA_OFFSET + AFBCE_MEM_CTRL, 0x00000888);/*wch1 DMA/AFBCE mem*/
+	outp32(dss_base + DSS_WCH1_DMA_OFFSET + ROT_MEM_CTRL, 0x00000008);/*wch1 rot mem*/
+	outp32(dss_base + DSS_WCH2_DMA_OFFSET + DMA_BUF_MEM_CTRL, 0x00000008);/*wch2 DMA/AFBCE mem*/
+	outp32(dss_base + DSS_WCH2_DMA_OFFSET + ROT_MEM_CTRL, 0x00000008);/*wch2 rot mem*/
+}
+int dpe_irq_enable(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	if (ctx->irq)
+		enable_irq(ctx->irq);
+
+	return 0;
+}
+
+int dpe_irq_disable(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx;
+
+	ctx = acrtc->ctx;
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	if (ctx->irq)
+		disable_irq(ctx->irq);
+
+	/*disable_irq_nosync(ctx->irq);*/
+
+	return 0;
+}
diff --git a/drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.h b/drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.h
new file mode 100644
index 000000000000..7ee992273d72
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_drm_dpe_utils.h
@@ -0,0 +1,58 @@
+/* Copyright (c) 2013-2014, Hisilicon Tech. Co., Ltd. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef KIRIN_DRM_DPE_UTILS_H
+#define KIRIN_DRM_DPE_UTILS_H
+
+#include "kirin_dpe_reg.h"
+
+/*#define CONFIG_HISI_FB_OV_BASE_USED*/
+/*#define CONFIG_HISI_FB_DPP_COLORBAR_USED*/
+/*#define CONFIG_HISI_FB_LDI_COLORBAR_USED*/
+
+void set_reg(char __iomem *addr, uint32_t val, uint8_t bw, uint8_t bs);
+
+void init_dbuf(struct dss_crtc *acrtc);
+void init_dpp(struct dss_crtc *acrtc);
+void init_other(struct dss_crtc *acrtc);
+void init_ldi(struct dss_crtc *acrtc);
+
+void deinit_ldi(struct dss_crtc *acrtc);
+void enable_ldi(struct dss_crtc *acrtc);
+void disable_ldi(struct dss_crtc *acrtc);
+
+void dss_inner_clk_pdp_enable(struct dss_crtc *acrtc);
+void dss_inner_clk_common_enable(struct dss_crtc *acrtc);
+void dpe_interrupt_clear(struct dss_crtc *acrtc);
+void dpe_interrupt_unmask(struct dss_crtc *acrtc);
+void dpe_interrupt_mask(struct dss_crtc *acrtc);
+
+int dpe_irq_enable(struct dss_crtc *acrtc);
+int dpe_irq_disable(struct dss_crtc *acrtc);
+
+int dpe_init(struct dss_crtc *acrtc);
+
+void hisifb_dss_on(struct dss_hw_ctx *ctx);
+void hisi_dss_mctl_on(struct dss_hw_ctx *ctx);
+
+void hisi_dss_unflow_handler(struct dss_hw_ctx *ctx, bool unmask);
+int hisi_dss_mctl_mutex_lock(struct dss_hw_ctx *ctx);
+int hisi_dss_mctl_mutex_unlock(struct dss_hw_ctx *ctx);
+int hisi_dss_ovl_base_config(struct dss_hw_ctx *ctx, u32 xres, u32 yres);
+
+void hisi_fb_pan_display(struct drm_plane *plane);
+void hisi_dss_online_play(struct drm_plane *plane, drm_dss_layer_t *layer);
+
+u32 dss_get_format(u32 pixel_format);
+
+#endif
diff --git a/drivers/staging/hikey9xx/gpu/kirin_drm_drv.c b/drivers/staging/hikey9xx/gpu/kirin_drm_drv.c
new file mode 100644
index 000000000000..edb690062f64
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_drm_drv.c
@@ -0,0 +1,380 @@
+/*
+ * Hisilicon Kirin SoCs drm master driver
+ *
+ * Copyright (c) 2016 Linaro Limited.
+ * Copyright (c) 2014-2016 Hisilicon Limited.
+ *
+ * Author:
+ *	<cailiwei@hisilicon.com>
+ *	<zhengwanchun@hisilicon.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/of_platform.h>
+#include <linux/component.h>
+#include <linux/of_graph.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_atomic_helper.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "kirin_drm_drv.h"
+
+
+#ifdef CONFIG_DRM_FBDEV_EMULATION
+static bool fbdev = true;
+MODULE_PARM_DESC(fbdev, "Enable fbdev compat layer");
+module_param(fbdev, bool, 0600);
+#endif
+
+
+static struct kirin_dc_ops *dc_ops;
+
+static int kirin_drm_kms_cleanup(struct drm_device *dev)
+{
+	struct kirin_drm_private *priv = dev->dev_private;
+
+	if (priv->fbdev) {
+		kirin_drm_fbdev_fini(dev);
+		priv->fbdev = NULL;
+	}
+
+	drm_kms_helper_poll_fini(dev);
+	drm_vblank_cleanup(dev);
+	dc_ops->cleanup(dev);
+	drm_mode_config_cleanup(dev);
+	devm_kfree(dev->dev, priv);
+	dev->dev_private = NULL;
+
+	return 0;
+}
+
+static void kirin_fbdev_output_poll_changed(struct drm_device *dev)
+{
+	struct kirin_drm_private *priv = dev->dev_private;
+
+	dsi_set_output_client(dev);
+
+	if (priv->fbdev)
+		drm_fb_helper_hotplug_event(priv->fbdev);
+	else
+		priv->fbdev = kirin_drm_fbdev_init(dev);
+}
+
+static const struct drm_mode_config_funcs kirin_drm_mode_config_funcs = {
+	.fb_create = drm_fb_cma_create,
+	.output_poll_changed = kirin_fbdev_output_poll_changed,
+	.atomic_check = drm_atomic_helper_check,
+	.atomic_commit = drm_atomic_helper_commit,
+};
+
+static void kirin_drm_mode_config_init(struct drm_device *dev)
+{
+	dev->mode_config.min_width = 0;
+	dev->mode_config.min_height = 0;
+
+	dev->mode_config.max_width = 2048;
+	dev->mode_config.max_height = 2048;
+
+	dev->mode_config.funcs = &kirin_drm_mode_config_funcs;
+}
+
+static int kirin_drm_kms_init(struct drm_device *dev)
+{
+	struct kirin_drm_private *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	dev->dev_private = priv;
+	dev_set_drvdata(dev->dev, dev);
+
+	/* dev->mode_config initialization */
+	drm_mode_config_init(dev);
+	kirin_drm_mode_config_init(dev);
+
+	/* display controller init */
+	ret = dc_ops->init(dev);
+	if (ret)
+		goto err_mode_config_cleanup;
+
+	/* bind and init sub drivers */
+	ret = component_bind_all(dev->dev, dev);
+	if (ret) {
+		DRM_ERROR("failed to bind all component.\n");
+		goto err_dc_cleanup;
+	}
+
+	/* vblank init */
+	ret = drm_vblank_init(dev, dev->mode_config.num_crtc);
+	if (ret) {
+		DRM_ERROR("failed to initialize vblank.\n");
+		goto err_unbind_all;
+	}
+	/* with irq_enabled = true, we can use the vblank feature. */
+	dev->irq_enabled = true;
+
+	/* reset all the states of crtc/plane/encoder/connector */
+	drm_mode_config_reset(dev);
+
+	//if (fbdev)
+	//	priv->fbdev = kirin_drm_fbdev_init(dev);
+
+	/* init kms poll for handling hpd */
+	drm_kms_helper_poll_init(dev);
+
+	/* force detection after connectors init */
+	(void)drm_helper_hpd_irq_event(dev);
+
+	return 0;
+
+err_unbind_all:
+	component_unbind_all(dev->dev, dev);
+err_dc_cleanup:
+	dc_ops->cleanup(dev);
+err_mode_config_cleanup:
+	drm_mode_config_cleanup(dev);
+	devm_kfree(dev->dev, priv);
+	dev->dev_private = NULL;
+
+	return ret;
+}
+
+static const struct file_operations kirin_drm_fops = {
+	.owner		= THIS_MODULE,
+	.open		= drm_open,
+	.release	= drm_release,
+	.unlocked_ioctl	= drm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= drm_compat_ioctl,
+#endif
+	.poll		= drm_poll,
+	.read		= drm_read,
+	.llseek		= no_llseek,
+	.mmap		= drm_gem_cma_mmap,
+};
+
+static int kirin_gem_cma_dumb_create(struct drm_file *file,
+				     struct drm_device *dev,
+				     struct drm_mode_create_dumb *args)
+{
+	return drm_gem_cma_dumb_create_internal(file, dev, args);
+}
+
+static int kirin_drm_connectors_register(struct drm_device *dev)
+{
+	struct drm_connector *connector;
+	struct drm_connector *failed_connector;
+	int ret;
+
+	mutex_lock(&dev->mode_config.mutex);
+	drm_for_each_connector(connector, dev) {
+		ret = drm_connector_register(connector);
+		if (ret) {
+			failed_connector = connector;
+			goto err;
+		}
+	}
+	mutex_unlock(&dev->mode_config.mutex);
+
+	return 0;
+
+err:
+	drm_for_each_connector(connector, dev) {
+		if (failed_connector == connector)
+			break;
+		drm_connector_unregister(connector);
+	}
+	mutex_unlock(&dev->mode_config.mutex);
+
+	return ret;
+}
+
+static struct drm_driver kirin_drm_driver = {
+	.driver_features	= DRIVER_GEM | DRIVER_MODESET | DRIVER_PRIME |
+				  DRIVER_ATOMIC | DRIVER_HAVE_IRQ | DRIVER_RENDER,
+	.fops				= &kirin_drm_fops,
+	.set_busid			= drm_platform_set_busid,
+
+	.gem_free_object	= drm_gem_cma_free_object,
+	.gem_vm_ops		= &drm_gem_cma_vm_ops,
+	.dumb_create		= kirin_gem_cma_dumb_create,
+	.dumb_map_offset	= drm_gem_cma_dumb_map_offset,
+	.dumb_destroy		= drm_gem_dumb_destroy,
+
+	.prime_handle_to_fd	= drm_gem_prime_handle_to_fd,
+	.prime_fd_to_handle	= drm_gem_prime_fd_to_handle,
+	.gem_prime_export	= drm_gem_prime_export,
+	.gem_prime_import	= drm_gem_prime_import,
+	.gem_prime_get_sg_table = drm_gem_cma_prime_get_sg_table,
+	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
+	.gem_prime_vmap		= drm_gem_cma_prime_vmap,
+	.gem_prime_vunmap	= drm_gem_cma_prime_vunmap,
+	.gem_prime_mmap		= drm_gem_cma_prime_mmap,
+
+	.name			= "kirin",
+	.desc			= "Hisilicon Kirin SoCs' DRM Driver",
+	.date			= "20170309",
+	.major			= 1,
+	.minor			= 0,
+};
+
+#ifdef CONFIG_OF
+/* NOTE: the CONFIG_OF case duplicates the same code as exynos or imx
+ * (or probably any other).. so probably some room for some helpers
+ */
+static int compare_of(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+#else
+static int compare_dev(struct device *dev, void *data)
+{
+	return dev == data;
+}
+#endif
+
+static int kirin_drm_bind(struct device *dev)
+{
+	struct drm_driver *driver = &kirin_drm_driver;
+	struct drm_device *drm_dev;
+	int ret;
+
+	//drm_platform_init(&kirin_drm_driver, to_platform_device(dev));
+
+	drm_dev = drm_dev_alloc(driver, dev);
+	if (!drm_dev)
+		return -ENOMEM;
+
+	drm_dev->platformdev = to_platform_device(dev);
+
+	ret = kirin_drm_kms_init(drm_dev);
+	if (ret)
+		goto err_drm_dev_unref;
+
+	ret = drm_dev_register(drm_dev, 0);
+	if (ret)
+		goto err_kms_cleanup;
+
+	/* connectors should be registered after drm device register */
+	ret = kirin_drm_connectors_register(drm_dev);
+	if (ret)
+		goto err_drm_dev_unregister;
+
+	DRM_INFO("Initialized %s %d.%d.%d %s on minor %d\n",
+		 driver->name, driver->major, driver->minor, driver->patchlevel,
+		 driver->date, drm_dev->primary->index);
+
+	return 0;
+
+err_drm_dev_unregister:
+	drm_dev_unregister(drm_dev);
+err_kms_cleanup:
+	kirin_drm_kms_cleanup(drm_dev);
+err_drm_dev_unref:
+	drm_dev_unref(drm_dev);
+
+	return ret;
+}
+
+static void kirin_drm_unbind(struct device *dev)
+{
+	drm_put_dev(dev_get_drvdata(dev));
+}
+
+static const struct component_master_ops kirin_drm_ops = {
+	.bind = kirin_drm_bind,
+	.unbind = kirin_drm_unbind,
+};
+
+static struct device_node *kirin_get_remote_node(struct device_node *np)
+{
+	struct device_node *endpoint, *remote;
+
+	/* get the first endpoint, in our case only one remote node
+	 * is connected to display controller.
+	 */
+	endpoint = of_graph_get_next_endpoint(np, NULL);
+	if (!endpoint) {
+		DRM_ERROR("no valid endpoint node\n");
+		return ERR_PTR(-ENODEV);
+	}
+	of_node_put(endpoint);
+
+	remote = of_graph_get_remote_port_parent(endpoint);
+	if (!remote) {
+		DRM_ERROR("no valid remote node\n");
+		return ERR_PTR(-ENODEV);
+	}
+	of_node_put(remote);
+
+	if (!of_device_is_available(remote)) {
+		DRM_ERROR("not available for remote node\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	return remote;
+}
+
+static int kirin_drm_platform_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct component_match *match = NULL;
+	struct device_node *remote;
+
+	dc_ops = (struct kirin_dc_ops *)of_device_get_match_data(dev);
+	if (!dc_ops) {
+		DRM_ERROR("failed to get dt id data\n");
+		return -EINVAL;
+	}
+
+	remote = kirin_get_remote_node(np);
+	if (IS_ERR(remote))
+		return PTR_ERR(remote);
+
+	component_match_add(dev, &match, compare_of, remote);
+
+	return component_master_add_with_match(dev, &kirin_drm_ops, match);
+
+	return 0;
+}
+
+static int kirin_drm_platform_remove(struct platform_device *pdev)
+{
+	component_master_del(&pdev->dev, &kirin_drm_ops);
+	dc_ops = NULL;
+	return 0;
+}
+
+static const struct of_device_id kirin_drm_dt_ids[] = {
+	{ .compatible = "hisilicon,hi3660-dpe",
+	  .data = &dss_dc_ops,
+	},
+	{ /* end node */ },
+};
+MODULE_DEVICE_TABLE(of, kirin_drm_dt_ids);
+
+static struct platform_driver kirin_drm_platform_driver = {
+	.probe = kirin_drm_platform_probe,
+	.remove = kirin_drm_platform_remove,
+	.driver = {
+		.name = "kirin-drm",
+		.of_match_table = kirin_drm_dt_ids,
+	},
+};
+
+module_platform_driver(kirin_drm_platform_driver);
+
+MODULE_AUTHOR("cailiwei <cailiwei@hisilicon.com>");
+MODULE_AUTHOR("zhengwanchun <zhengwanchun@hisilicon.com>");
+MODULE_DESCRIPTION("hisilicon Kirin SoCs' DRM master driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/hikey9xx/gpu/kirin_drm_drv.h b/drivers/staging/hikey9xx/gpu/kirin_drm_drv.h
new file mode 100644
index 000000000000..b361f5f69932
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_drm_drv.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (c) 2016 Linaro Limited.
+ * Copyright (c) 2014-2016 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __KIRIN_DRM_DRV_H__
+#define __KIRIN_DRM_DRV_H__
+
+#include <drm/drmP.h>
+#include <linux/ion.h>
+#include <linux/hisi/hisi_ion.h>
+#include <linux/hisi/hisi-iommu.h>
+
+#include "drm_crtc.h"
+#include "drm_fb_helper.h"
+
+#define MAX_CRTC	2
+
+#define to_kirin_fbdev(x) container_of(x, struct kirin_fbdev, fb_helper)
+
+/* display controller init/cleanup ops */
+struct kirin_dc_ops {
+	int (*init)(struct drm_device *dev);
+	void (*cleanup)(struct drm_device *dev);
+};
+
+struct kirin_drm_private {
+	struct drm_fb_helper *fb_helper;
+	struct drm_fb_helper *fbdev;
+	struct drm_crtc *crtc[MAX_CRTC];
+};
+
+struct kirin_fbdev {
+	struct drm_fb_helper fb_helper;
+	struct drm_framebuffer *fb;
+
+	struct ion_client *ion_client;
+	struct ion_handle *ion_handle;
+	struct iommu_map_format iommu_format;
+	void *screen_base;
+	unsigned long smem_start;
+	unsigned long screen_size;
+	int shared_fd;
+};
+
+extern const struct kirin_dc_ops dss_dc_ops;
+extern void dsi_set_output_client(struct drm_device *dev);
+
+struct drm_framebuffer *kirin_framebuffer_init(struct drm_device *dev,
+		struct drm_mode_fb_cmd2 *mode_cmd);
+struct drm_fb_helper *kirin_drm_fbdev_init(struct drm_device *dev);
+void kirin_drm_fbdev_fini(struct drm_device *dev);
+
+
+#endif /* __KIRIN_DRM_DRV_H__ */
diff --git a/drivers/staging/hikey9xx/gpu/kirin_drm_dss.c b/drivers/staging/hikey9xx/gpu/kirin_drm_dss.c
new file mode 100644
index 000000000000..2a92372d0c81
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_drm_dss.c
@@ -0,0 +1,701 @@
+/*
+ * Hisilicon Hi6220 SoC ADE(Advanced Display Engine)'s crtc&plane driver
+ *
+ * Copyright (c) 2016 Linaro Limited.
+ * Copyright (c) 2014-2016 Hisilicon Limited.
+ *
+ * Author:
+ *	Xinliang Liu <z.liuxinliang@hisilicon.com>
+ *	Xinliang Liu <xinliang.liu@linaro.org>
+ *	Xinwei Kong <kong.kongxinwei@hisilicon.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <video/display_timing.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+#include <linux/of_address.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_atomic.h>
+#include <drm/drm_atomic_helper.h>
+#include <drm/drm_plane_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+
+#include "kirin_drm_drv.h"
+
+#include "kirin_drm_dpe_utils.h"
+#include "kirin_dpe_reg.h"
+
+#define DTS_COMP_DSS_NAME "hisilicon,hi3660-dpe"
+
+#define DSS_DEBUG	0
+
+static const struct dss_format dss_formats[] = {
+	/* 16bpp RGB: */
+	{ DRM_FORMAT_RGB565, HISI_FB_PIXEL_FORMAT_RGB_565 },
+	{ DRM_FORMAT_BGR565, HISI_FB_PIXEL_FORMAT_BGR_565 },
+	/* 32bpp [A]RGB: */
+	{ DRM_FORMAT_XRGB8888, HISI_FB_PIXEL_FORMAT_RGBX_8888 },
+	{ DRM_FORMAT_XBGR8888, HISI_FB_PIXEL_FORMAT_BGRX_8888 },
+	{ DRM_FORMAT_RGBA8888, HISI_FB_PIXEL_FORMAT_RGBA_8888 },
+	{ DRM_FORMAT_BGRA8888, HISI_FB_PIXEL_FORMAT_BGRA_8888 },
+	/*{ DRM_FORMAT_ARGB8888,  },*/
+	/*{ DRM_FORMAT_ABGR8888,  },*/
+};
+
+static const u32 channel_formats1[] = {
+	DRM_FORMAT_RGB565, DRM_FORMAT_BGR565,
+	DRM_FORMAT_XRGB8888, DRM_FORMAT_XBGR8888,
+	DRM_FORMAT_RGBA8888, DRM_FORMAT_BGRA8888
+};
+
+u32 dss_get_channel_formats(u8 ch, const u32 **formats)
+{
+	switch (ch) {
+	case DSS_CH1:
+		*formats = channel_formats1;
+		return ARRAY_SIZE(channel_formats1);
+	default:
+		DRM_ERROR("no this channel %d\n", ch);
+		*formats = NULL;
+		return 0;
+	}
+}
+
+/* convert from fourcc format to dss format */
+u32 dss_get_format(u32 pixel_format)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dss_formats); i++)
+		if (dss_formats[i].pixel_format == pixel_format)
+			return dss_formats[i].dss_format;
+
+	/* not found */
+	DRM_ERROR("Not found pixel format!!fourcc_format= %d\n",
+		  pixel_format);
+	return HISI_FB_PIXEL_FORMAT_UNSUPPORT;
+}
+
+/*******************************************************************************
+ **
+ */
+static void dss_ldi_set_mode(struct dss_crtc *acrtc)
+{
+	int ret;
+	u32 clk_Hz;
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+	struct drm_display_mode *mode = &acrtc->base.state->mode;
+	struct drm_display_mode *adj_mode = &acrtc->base.state->adjusted_mode;
+
+
+	DRM_INFO("mode->clock(org) = %u\n", mode->clock);
+	if(mode->clock == 148500){
+		clk_Hz = 144000 * 1000UL;
+	} else if(mode->clock == 83496){
+		clk_Hz = 80000 * 1000UL;
+	} else if(mode->clock == 74440){
+		clk_Hz = 72000 * 1000UL;
+	} else if(mode->clock == 74250){
+		clk_Hz = 72000 * 1000UL;
+	} else {
+		clk_Hz = mode->clock * 1000UL;;
+	}
+
+	/*
+	 * Success should be guaranteed in mode_valid call back,
+	 * so failure shouldn't happen here
+	 */
+	ret = clk_set_rate(ctx->dss_pxl0_clk, clk_Hz);
+	if (ret) {
+		DRM_ERROR("failed to set pixel clk %dHz (%d)\n", clk_Hz, ret);
+	}
+	adj_mode->clock = clk_get_rate(ctx->dss_pxl0_clk) / 1000;
+	DRM_INFO("dss_pxl0_clk = %u\n",  adj_mode->clock);
+
+	dpe_init(acrtc);
+}
+
+static int dss_power_up(struct dss_crtc *acrtc)
+{
+	int ret;
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	ret = clk_prepare_enable(ctx->dss_pxl0_clk);
+	if (ret) {
+		DRM_ERROR("failed to enable dss_pxl0_clk (%d)\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(ctx->dss_pri_clk);
+	if (ret) {
+		DRM_ERROR("failed to enable dss_pri_clk (%d)\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(ctx->dss_pclk_dss_clk);
+	if (ret) {
+		DRM_ERROR("failed to enable dss_pclk_dss_clk (%d)\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(ctx->dss_axi_clk);
+	if (ret) {
+		DRM_ERROR("failed to enable dss_axi_clk (%d)\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(ctx->dss_mmbuf_clk);
+	if (ret) {
+		DRM_ERROR("failed to enable dss_mmbuf_clk (%d)\n", ret);
+		return ret;
+	}
+	dss_inner_clk_pdp_enable(acrtc);
+	dss_inner_clk_common_enable(acrtc);
+	dpe_interrupt_mask(acrtc);
+	dpe_interrupt_clear(acrtc);
+	dpe_irq_enable(acrtc);
+	dpe_interrupt_unmask(acrtc);
+
+	ctx->power_on = true;
+	return 0;
+}
+
+#if 0
+static void dss_power_down(struct dss_crtc *acrtc)
+{
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	dpe_interrupt_mask(acrtc);
+	dpe_irq_disable(acrtc);
+
+	ctx->power_on = false;
+}
+#endif
+
+static int dss_enable_vblank(struct drm_device *dev, unsigned int pipe)
+{
+	struct kirin_drm_private *priv = dev->dev_private;
+	struct dss_crtc *acrtc = to_dss_crtc(priv->crtc[pipe]);
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	if (!ctx->power_on)
+		(void)dss_power_up(acrtc);
+
+	return 0;
+}
+
+static void dss_disable_vblank(struct drm_device *dev, unsigned int pipe)
+{
+	struct kirin_drm_private *priv = dev->dev_private;
+	struct dss_crtc *acrtc = to_dss_crtc(priv->crtc[pipe]);
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	if (!ctx->power_on) {
+		DRM_ERROR("power is down! vblank disable fail\n");
+		return;
+	}
+}
+
+static irqreturn_t dss_irq_handler(int irq, void *data)
+{
+	struct dss_crtc *acrtc = data;
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+	void __iomem *dss_base = ctx->base;
+
+	u32 isr_s1 = 0;
+	u32 isr_s2 = 0;
+	u32 isr_s2_dpp = 0;
+	u32 isr_s2_smmu = 0;
+	u32 mask = 0;
+
+	isr_s1 = inp32(dss_base + GLB_CPU_PDP_INTS);
+	isr_s2 = inp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS);
+	isr_s2_dpp = inp32(dss_base + DSS_DPP_OFFSET + DPP_INTS);
+	isr_s2_smmu = inp32(dss_base + DSS_SMMU_OFFSET + SMMU_INTSTAT_NS);
+
+	outp32(dss_base + DSS_SMMU_OFFSET + SMMU_INTCLR_NS, isr_s2_smmu);
+	outp32(dss_base + DSS_DPP_OFFSET + DPP_INTS, isr_s2_dpp);
+	outp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INTS, isr_s2);
+	outp32(dss_base + GLB_CPU_PDP_INTS, isr_s1);
+
+	isr_s1 &= ~(inp32(dss_base + GLB_CPU_PDP_INT_MSK));
+	isr_s2 &= ~(inp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK));
+	isr_s2_dpp &= ~(inp32(dss_base + DSS_DPP_OFFSET + DPP_INT_MSK));
+
+	if (isr_s2 & BIT_VACTIVE0_START) {
+		ctx->vactive0_start_flag++;
+		wake_up_interruptible_all(&ctx->vactive0_start_wq);
+	}
+
+	if (isr_s2 & BIT_VSYNC)
+		ctx->vsync_timestamp = ktime_get();
+
+	if (isr_s2 & BIT_LDI_UNFLOW) {
+		mask = inp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
+		mask |= BIT_LDI_UNFLOW;
+		outp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK, mask);
+
+		DRM_ERROR("ldi underflow!\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void dss_crtc_enable(struct drm_crtc *crtc)
+{
+	struct dss_crtc *acrtc = to_dss_crtc(crtc);
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+	int ret;
+
+	if (acrtc->enable)
+		return;
+
+	if (!ctx->power_on) {
+		ret = dss_power_up(acrtc);
+		if (ret)
+			return;
+	}
+
+	acrtc->enable = true;
+}
+
+static void dss_crtc_disable(struct drm_crtc *crtc)
+{
+	struct dss_crtc *acrtc = to_dss_crtc(crtc);
+
+	if (!acrtc->enable)
+		return;
+
+	/*dss_power_down(acrtc);*/
+	acrtc->enable = false;
+}
+
+static int dss_crtc_atomic_check(struct drm_crtc *crtc,
+				 struct drm_crtc_state *state)
+{
+	/* do nothing */
+	return 0;
+}
+
+static void dss_crtc_mode_set_nofb(struct drm_crtc *crtc)
+{
+	struct dss_crtc *acrtc = to_dss_crtc(crtc);
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	if (!ctx->power_on)
+		(void)dss_power_up(acrtc);
+	dss_ldi_set_mode(acrtc);
+}
+
+static void dss_crtc_atomic_begin(struct drm_crtc *crtc,
+				  struct drm_crtc_state *old_state)
+{
+	struct dss_crtc *acrtc = to_dss_crtc(crtc);
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	if (!ctx->power_on)
+		(void)dss_power_up(acrtc);
+}
+
+static void dss_crtc_atomic_flush(struct drm_crtc *crtc,
+				  struct drm_crtc_state *old_state)
+
+{
+
+}
+
+static const struct drm_crtc_helper_funcs dss_crtc_helper_funcs = {
+	.enable		= dss_crtc_enable,
+	.disable	= dss_crtc_disable,
+	.atomic_check	= dss_crtc_atomic_check,
+	.mode_set_nofb	= dss_crtc_mode_set_nofb,
+	.atomic_begin	= dss_crtc_atomic_begin,
+	.atomic_flush	= dss_crtc_atomic_flush,
+};
+
+static const struct drm_crtc_funcs dss_crtc_funcs = {
+	.destroy	= drm_crtc_cleanup,
+	.set_config	= drm_atomic_helper_set_config,
+	.page_flip	= drm_atomic_helper_page_flip,
+	.reset		= drm_atomic_helper_crtc_reset,
+	.set_property = drm_atomic_helper_crtc_set_property,
+	.atomic_duplicate_state	= drm_atomic_helper_crtc_duplicate_state,
+	.atomic_destroy_state	= drm_atomic_helper_crtc_destroy_state,
+};
+
+static int dss_crtc_init(struct drm_device *dev, struct drm_crtc *crtc,
+			 struct drm_plane *plane)
+{
+	struct kirin_drm_private *priv = dev->dev_private;
+	struct device_node *port;
+	int ret;
+
+	/* set crtc port so that
+	 * drm_of_find_possible_crtcs call works
+	 */
+	port = of_get_child_by_name(dev->dev->of_node, "port");
+	if (!port) {
+		DRM_ERROR("no port node found in %s\n",
+			  dev->dev->of_node->full_name);
+		return -EINVAL;
+	}
+	of_node_put(port);
+	crtc->port = port;
+
+	ret = drm_crtc_init_with_planes(dev, crtc, plane, NULL,
+					&dss_crtc_funcs);
+	if (ret) {
+		DRM_ERROR("failed to init crtc.\n");
+		return ret;
+	}
+
+	drm_crtc_helper_add(crtc, &dss_crtc_helper_funcs);
+	priv->crtc[drm_crtc_index(crtc)] = crtc;
+
+	return 0;
+}
+
+static int dss_plane_prepare_fb(struct drm_plane *plane,
+				const struct drm_plane_state *new_state)
+{
+	/* do nothing */
+	return 0;
+}
+
+static void dss_plane_cleanup_fb(struct drm_plane *plane,
+				 const struct drm_plane_state *old_state)
+{
+	/* do nothing */
+}
+
+static int dss_plane_atomic_check(struct drm_plane *plane,
+				  struct drm_plane_state *state)
+{
+	struct drm_framebuffer *fb = state->fb;
+	struct drm_crtc *crtc = state->crtc;
+	struct drm_crtc_state *crtc_state;
+	u32 src_x = state->src_x >> 16;
+	u32 src_y = state->src_y >> 16;
+	u32 src_w = state->src_w >> 16;
+	u32 src_h = state->src_h >> 16;
+	int crtc_x = state->crtc_x;
+	int crtc_y = state->crtc_y;
+	u32 crtc_w = state->crtc_w;
+	u32 crtc_h = state->crtc_h;
+	u32 fmt;
+
+	if (!crtc || !fb)
+		return 0;
+
+	fmt = dss_get_format(fb->pixel_format);
+	if (fmt == HISI_FB_PIXEL_FORMAT_UNSUPPORT)
+		return -EINVAL;
+
+	crtc_state = drm_atomic_get_crtc_state(state->state, crtc);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
+
+	if (src_w != crtc_w || src_h != crtc_h) {
+		DRM_ERROR("Scale not support!!!\n");
+		return -EINVAL;
+	}
+
+	if (src_x + src_w > fb->width ||
+	    src_y + src_h > fb->height)
+		return -EINVAL;
+
+	if (crtc_x < 0 || crtc_y < 0)
+		return -EINVAL;
+
+	if (crtc_x + crtc_w > crtc_state->adjusted_mode.hdisplay ||
+	    crtc_y + crtc_h > crtc_state->adjusted_mode.vdisplay)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void dss_plane_atomic_update(struct drm_plane *plane,
+				    struct drm_plane_state *old_state)
+{
+	hisi_fb_pan_display(plane);
+}
+
+static void dss_plane_atomic_disable(struct drm_plane *plane,
+				     struct drm_plane_state *old_state)
+{
+	//struct dss_plane *aplane = to_dss_plane(plane);
+}
+
+static const struct drm_plane_helper_funcs dss_plane_helper_funcs = {
+	.prepare_fb = dss_plane_prepare_fb,
+	.cleanup_fb = dss_plane_cleanup_fb,
+	.atomic_check = dss_plane_atomic_check,
+	.atomic_update = dss_plane_atomic_update,
+	.atomic_disable = dss_plane_atomic_disable,
+};
+
+static struct drm_plane_funcs dss_plane_funcs = {
+	.update_plane	= drm_atomic_helper_update_plane,
+	.disable_plane	= drm_atomic_helper_disable_plane,
+	.set_property = drm_atomic_helper_plane_set_property,
+	.destroy = drm_plane_cleanup,
+	.reset = drm_atomic_helper_plane_reset,
+	.atomic_duplicate_state = drm_atomic_helper_plane_duplicate_state,
+	.atomic_destroy_state = drm_atomic_helper_plane_destroy_state,
+};
+
+static int dss_plane_init(struct drm_device *dev, struct dss_plane *aplane,
+			  enum drm_plane_type type)
+{
+	const u32 *fmts;
+	u32 fmts_cnt;
+	int ret = 0;
+
+	/* get properties */
+	fmts_cnt = dss_get_channel_formats(aplane->ch, &fmts);
+	if (ret)
+		return ret;
+
+	ret = drm_universal_plane_init(dev, &aplane->base, 1, &dss_plane_funcs,
+				       fmts, fmts_cnt, type);
+	if (ret) {
+		DRM_ERROR("fail to init plane, ch=%d\n", aplane->ch);
+		return ret;
+	}
+
+	drm_plane_helper_add(&aplane->base, &dss_plane_helper_funcs);
+
+	return 0;
+}
+
+static int dss_enable_iommu(struct platform_device *pdev, struct dss_hw_ctx *ctx)
+{
+	struct device *dev = NULL;
+
+	dev = &pdev->dev;
+
+	/* create iommu domain */
+	ctx->mmu_domain = iommu_domain_alloc(dev->bus);
+	if (!ctx->mmu_domain) {
+		pr_err("iommu_domain_alloc failed!\n");
+		return -EINVAL;
+	}
+
+	iommu_attach_device(ctx->mmu_domain, dev);
+
+	return 0;
+}
+
+static int dss_dts_parse(struct platform_device *pdev, struct dss_hw_ctx *ctx)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = NULL;
+	int ret = 0;
+
+	np = of_find_compatible_node(NULL, NULL, DTS_COMP_DSS_NAME);
+	if (!np) {
+			DRM_ERROR("NOT FOUND device node %s!\n",
+				    DTS_COMP_DSS_NAME);
+			return -ENXIO;
+	}
+
+	ctx->base = of_iomap(np, 0);
+	if (!(ctx->base)) {
+			DRM_ERROR ("failed to get ade base resource.\n");
+			return -ENXIO;
+	}
+
+	ctx->peri_crg_base  = of_iomap(np, 1);
+	if (!(ctx->peri_crg_base)) {
+			DRM_ERROR ("failed to get ade peri_crg_base  resource.\n");
+			return -ENXIO;
+	}
+
+	ctx->sctrl_base  = of_iomap(np, 2);
+	if (!(ctx->sctrl_base)) {
+			DRM_ERROR ("failed to get ade sctrl_base  resource.\n");
+			return -ENXIO;
+	}
+
+	ctx->pmc_base = of_iomap(np, 3);
+	if (!(ctx->pmc_base)) {
+			DRM_ERROR ("failed to get ade pmc_base   resource.\n");
+			return -ENXIO;
+	}
+
+	ctx->noc_dss_base = of_iomap(np, 4);
+	if (!(ctx->noc_dss_base)) {
+			DRM_ERROR ("failed to get noc_dss_base  resource.\n");
+			return -ENXIO;
+	}
+
+	/* get irq no */
+	ctx->irq = irq_of_parse_and_map(np, 0);
+	if (ctx->irq <= 0) {
+		DRM_ERROR("failed to get irq_pdp resource.\n");
+		return -ENXIO;
+	}
+
+	DRM_INFO("dss irq = %d.", ctx->irq);
+
+	ctx->dss_mmbuf_clk = devm_clk_get(dev, "clk_dss_axi_mm");
+	if (!ctx->dss_mmbuf_clk) {
+		DRM_ERROR("failed to parse dss_mmbuf_clk\n");
+	    return -ENODEV;
+	}
+
+	ctx->dss_axi_clk = devm_clk_get(dev, "aclk_dss");
+	if (!ctx->dss_axi_clk) {
+		DRM_ERROR("failed to parse dss_axi_clk\n");
+		return -ENODEV;
+	}
+
+	ctx->dss_pclk_dss_clk = devm_clk_get(dev, "pclk_dss");
+	if (!ctx->dss_pclk_dss_clk) {
+		DRM_ERROR("failed to parse dss_pclk_dss_clk\n");
+	    return -ENODEV;
+	}
+
+	ctx->dss_pri_clk = devm_clk_get(dev, "clk_edc0");
+	if (!ctx->dss_pri_clk) {
+		DRM_ERROR("failed to parse dss_pri_clk\n");
+	    return -ENODEV;
+	}
+
+	ret = clk_set_rate(ctx->dss_pri_clk, DEFAULT_DSS_CORE_CLK_07V_RATE);
+	if (ret < 0) {
+		DRM_ERROR("dss_pri_clk clk_set_rate(%lu) failed, error=%d!\n",
+			DEFAULT_DSS_CORE_CLK_07V_RATE, ret);
+		return -EINVAL;
+	}
+
+	DRM_INFO("dss_pri_clk:[%lu]->[%llu].\n",
+		DEFAULT_DSS_CORE_CLK_07V_RATE, (uint64_t)clk_get_rate(ctx->dss_pri_clk));
+
+	ctx->dss_pxl0_clk = devm_clk_get(dev, "clk_ldi0");
+	if (!ctx->dss_pxl0_clk) {
+		DRM_ERROR("failed to parse dss_pxl0_clk\n");
+		return -ENODEV;
+	}
+
+	ret = clk_set_rate(ctx->dss_pxl0_clk, DSS_MAX_PXL0_CLK_144M);
+	if (ret < 0) {
+		DRM_ERROR("dss_pxl0_clk clk_set_rate(%lu) failed, error=%d!\n",
+			DSS_MAX_PXL0_CLK_144M, ret);
+		return -EINVAL;
+	}
+
+	DRM_INFO("dss_pxl0_clk:[%lu]->[%llu].\n",
+		DSS_MAX_PXL0_CLK_144M, (uint64_t)clk_get_rate(ctx->dss_pxl0_clk));
+
+	/* regulator enable */
+
+	dss_enable_iommu(pdev, ctx);
+
+	return 0;
+}
+
+static int dss_drm_init(struct drm_device *dev)
+{
+	struct platform_device *pdev = dev->platformdev;
+	struct dss_data *dss;
+	struct dss_hw_ctx *ctx;
+	struct dss_crtc *acrtc;
+	struct dss_plane *aplane;
+	enum drm_plane_type type;
+	int ret;
+	int i;
+
+	dss = devm_kzalloc(dev->dev, sizeof(*dss), GFP_KERNEL);
+	if (!dss) {
+		DRM_ERROR("failed to alloc dss_data\n");
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, dss);
+
+	ctx = &dss->ctx;
+	acrtc = &dss->acrtc;
+	acrtc->ctx = ctx;
+	acrtc->out_format = LCD_RGB888;
+	acrtc->bgr_fmt = LCD_RGB;
+
+	ret = dss_dts_parse(pdev, ctx);
+	if (ret)
+		return ret;
+
+	ctx->ion_client = NULL;
+	ctx->ion_handle = NULL;
+	ctx->screen_base = 0;
+	ctx->screen_size = 0;
+	ctx->smem_start = 0;
+
+	ctx->vactive0_start_flag = 0;
+	init_waitqueue_head(&ctx->vactive0_start_wq);
+
+	/*
+	 * plane init
+	 * TODO: Now only support primary plane, overlay planes
+	 * need to do.
+	 */
+	for (i = 0; i < DSS_CH_NUM; i++) {
+		aplane = &dss->aplane[i];
+		aplane->ch = i;
+		/*aplane->ctx = ctx;*/
+		aplane->acrtc = acrtc;
+		type = i == PRIMARY_CH ? DRM_PLANE_TYPE_PRIMARY :
+			DRM_PLANE_TYPE_OVERLAY;
+
+		ret = dss_plane_init(dev, aplane, type);
+		if (ret)
+			return ret;
+	}
+
+	/* crtc init */
+	ret = dss_crtc_init(dev, &acrtc->base, &dss->aplane[PRIMARY_CH].base);
+	if (ret)
+		return ret;
+
+	/* vblank irq init */
+	ret = devm_request_irq(dev->dev, ctx->irq, dss_irq_handler,
+			       IRQF_SHARED, dev->driver->name, acrtc);
+	if (ret) {
+	    DRM_ERROR("fail to  devm_request_irq, ret=%d!", ret);
+		return ret;
+	}
+
+	disable_irq(ctx->irq);
+
+	dev->driver->get_vblank_counter = drm_vblank_no_hw_counter;
+	dev->driver->enable_vblank = dss_enable_vblank;
+	dev->driver->disable_vblank = dss_disable_vblank;
+
+	return 0;
+}
+
+static void dss_drm_cleanup(struct drm_device *dev)
+{
+	struct platform_device *pdev = dev->platformdev;
+	struct dss_data *dss = platform_get_drvdata(pdev);
+	struct drm_crtc *crtc = &dss->acrtc.base;
+
+	drm_crtc_cleanup(crtc);
+}
+
+const struct kirin_dc_ops dss_dc_ops = {
+	.init = dss_drm_init,
+	.cleanup = dss_drm_cleanup
+};
diff --git a/drivers/staging/hikey9xx/gpu/kirin_drm_overlay_utils.c b/drivers/staging/hikey9xx/gpu/kirin_drm_overlay_utils.c
new file mode 100644
index 000000000000..98ab748b8d8e
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_drm_overlay_utils.c
@@ -0,0 +1,1288 @@
+/* Copyright (c) 2008-2011, Hisilicon Tech. Co., Ltd. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_atomic.h>
+#include <drm/drm_atomic_helper.h>
+#include <drm/drm_plane_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+
+#include "kirin_drm_dpe_utils.h"
+#include "kirin_drm_drv.h"
+
+
+#define DSS_CHN_MAX_DEFINE (DSS_COPYBIT_MAX)
+
+static int mid_array[DSS_CHN_MAX_DEFINE] = {0xb, 0xa, 0x9, 0x8, 0x7, 0x6, 0x5, 0x4, 0x2, 0x1, 0x3, 0x0};
+
+/*
+** dss_chn_idx
+** DSS_RCHN_D2 = 0,	DSS_RCHN_D3,	DSS_RCHN_V0,	DSS_RCHN_G0,	DSS_RCHN_V1,
+** DSS_RCHN_G1,	DSS_RCHN_D0,	DSS_RCHN_D1,	DSS_WCHN_W0,	DSS_WCHN_W1,
+** DSS_RCHN_V2,   DSS_WCHN_W2,
+*/
+/*lint -e785*/
+u32 g_dss_module_base[DSS_CHN_MAX_DEFINE][MODULE_CHN_MAX] = {
+	/* D0 */
+	{
+	MIF_CH0_OFFSET,
+	AIF0_CH0_OFFSET,
+	AIF1_CH0_OFFSET,
+	MCTL_CTL_MUTEX_RCH0,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH0_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD0_DBG,
+	DSS_RCH_D0_DMA_OFFSET,
+	DSS_RCH_D0_DFC_OFFSET,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	DSS_RCH_D0_CSC_OFFSET,
+	},
+
+	/* D1 */
+	{
+	MIF_CH1_OFFSET,
+	AIF0_CH1_OFFSET,
+	AIF1_CH1_OFFSET,
+	MCTL_CTL_MUTEX_RCH1,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH1_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH1_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH1_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD1_DBG,
+	DSS_RCH_D1_DMA_OFFSET,
+	DSS_RCH_D1_DFC_OFFSET,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	DSS_RCH_D1_CSC_OFFSET,
+	},
+
+	/* V0 */
+	{
+	MIF_CH2_OFFSET,
+	AIF0_CH2_OFFSET,
+	AIF1_CH2_OFFSET,
+	MCTL_CTL_MUTEX_RCH2,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH2_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH2_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH2_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD2_DBG,
+	DSS_RCH_VG0_DMA_OFFSET,
+	DSS_RCH_VG0_DFC_OFFSET,
+	DSS_RCH_VG0_SCL_OFFSET,
+	DSS_RCH_VG0_SCL_LUT_OFFSET,
+	DSS_RCH_VG0_ARSR_OFFSET,
+	DSS_RCH_VG0_ARSR_LUT_OFFSET,
+	DSS_RCH_VG0_POST_CLIP_OFFSET,
+	DSS_RCH_VG0_PCSC_OFFSET,
+	DSS_RCH_VG0_CSC_OFFSET,
+	},
+
+	/* G0 */
+	{
+	MIF_CH3_OFFSET,
+	AIF0_CH3_OFFSET,
+	AIF1_CH3_OFFSET,
+	MCTL_CTL_MUTEX_RCH3,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH3_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH3_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH3_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD3_DBG,
+	DSS_RCH_G0_DMA_OFFSET,
+	DSS_RCH_G0_DFC_OFFSET,
+	DSS_RCH_G0_SCL_OFFSET,
+	0,
+	0,
+	0,
+	DSS_RCH_G0_POST_CLIP_OFFSET,
+	0,
+	DSS_RCH_G0_CSC_OFFSET,
+	},
+
+	/* V1 */
+	{
+	MIF_CH4_OFFSET,
+	AIF0_CH4_OFFSET,
+	AIF1_CH4_OFFSET,
+	MCTL_CTL_MUTEX_RCH4,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH4_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH4_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH4_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD4_DBG,
+	DSS_RCH_VG1_DMA_OFFSET,
+	DSS_RCH_VG1_DFC_OFFSET,
+	DSS_RCH_VG1_SCL_OFFSET,
+	DSS_RCH_VG1_SCL_LUT_OFFSET,
+	0,
+	0,
+	DSS_RCH_VG1_POST_CLIP_OFFSET,
+	0,
+	DSS_RCH_VG1_CSC_OFFSET,
+	},
+
+	/* G1 */
+	{
+	MIF_CH5_OFFSET,
+	AIF0_CH5_OFFSET,
+	AIF1_CH5_OFFSET,
+	MCTL_CTL_MUTEX_RCH5,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH5_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH5_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH5_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD5_DBG,
+	DSS_RCH_G1_DMA_OFFSET,
+	DSS_RCH_G1_DFC_OFFSET,
+	DSS_RCH_G1_SCL_OFFSET,
+	0,
+	0,
+	0,
+	DSS_RCH_G1_POST_CLIP_OFFSET,
+	0,
+	DSS_RCH_G1_CSC_OFFSET,
+	},
+
+	/* D2 */
+	{
+	MIF_CH6_OFFSET,
+	AIF0_CH6_OFFSET,
+	AIF1_CH6_OFFSET,
+	MCTL_CTL_MUTEX_RCH6,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH6_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH6_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH6_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD6_DBG,
+	DSS_RCH_D2_DMA_OFFSET,
+	DSS_RCH_D2_DFC_OFFSET,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	DSS_RCH_D2_CSC_OFFSET,
+	},
+
+	/* D3 */
+	{
+	MIF_CH7_OFFSET,
+	AIF0_CH7_OFFSET,
+	AIF1_CH7_OFFSET,
+	MCTL_CTL_MUTEX_RCH7,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH7_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH7_OV_OEN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH7_STARTY,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD7_DBG,
+	DSS_RCH_D3_DMA_OFFSET,
+	DSS_RCH_D3_DFC_OFFSET,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	DSS_RCH_D3_CSC_OFFSET,
+	},
+
+	/* W0 */
+	{
+	MIF_CH8_OFFSET,
+	AIF0_CH8_OFFSET,
+	AIF1_CH8_OFFSET,
+	MCTL_CTL_MUTEX_WCH0,
+	DSS_MCTRL_SYS_OFFSET + MCTL_WCH0_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_WCH0_OV_IEN,
+	0,
+	0,
+	DSS_WCH0_DMA_OFFSET,
+	DSS_WCH0_DFC_OFFSET,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	DSS_WCH0_CSC_OFFSET,
+	},
+
+	/* W1 */
+	{
+	MIF_CH9_OFFSET,
+	AIF0_CH9_OFFSET,
+	AIF1_CH9_OFFSET,
+	MCTL_CTL_MUTEX_WCH1,
+	DSS_MCTRL_SYS_OFFSET + MCTL_WCH1_FLUSH_EN,
+	DSS_MCTRL_SYS_OFFSET + MCTL_WCH1_OV_IEN,
+	0,
+	0,
+	DSS_WCH1_DMA_OFFSET,
+	DSS_WCH1_DFC_OFFSET,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	DSS_WCH1_CSC_OFFSET,
+	},
+	/* V2 */
+	{
+	MIF_CH10_OFFSET,
+	AIF0_CH11_OFFSET,
+	AIF1_CH11_OFFSET,
+	MCTL_CTL_MUTEX_RCH8,
+	DSS_MCTRL_SYS_OFFSET + MCTL_RCH8_FLUSH_EN,
+	0,
+	0,
+	DSS_MCTRL_SYS_OFFSET + MCTL_MOD8_DBG,
+	DSS_RCH_VG2_DMA_OFFSET,
+	DSS_RCH_VG2_DFC_OFFSET,
+	DSS_RCH_VG2_SCL_OFFSET,
+	DSS_RCH_VG2_SCL_LUT_OFFSET,
+	0,
+	0,
+	DSS_RCH_VG2_POST_CLIP_OFFSET,
+	0,
+	DSS_RCH_VG2_CSC_OFFSET,
+	},
+	/* W2 */
+	{
+	MIF_CH11_OFFSET,
+	AIF0_CH12_OFFSET,
+	AIF1_CH12_OFFSET,
+	MCTL_CTL_MUTEX_WCH2,
+	DSS_MCTRL_SYS_OFFSET + MCTL_WCH2_FLUSH_EN,
+	0,
+	0,
+	0,
+	DSS_WCH2_DMA_OFFSET,
+	DSS_WCH2_DFC_OFFSET,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	DSS_WCH2_CSC_OFFSET,
+	},
+};
+
+/*lint +e785*/
+u32 g_dss_module_ovl_base[DSS_MCTL_IDX_MAX][MODULE_OVL_MAX] = {
+	{DSS_OVL0_OFFSET,
+	DSS_MCTRL_CTL0_OFFSET},
+
+	{DSS_OVL1_OFFSET,
+	DSS_MCTRL_CTL1_OFFSET},
+
+	{DSS_OVL2_OFFSET,
+	DSS_MCTRL_CTL2_OFFSET},
+
+	{DSS_OVL3_OFFSET,
+	DSS_MCTRL_CTL3_OFFSET},
+
+	{0,
+	DSS_MCTRL_CTL4_OFFSET},
+
+	{0,
+	DSS_MCTRL_CTL5_OFFSET},
+};
+
+/*SCF_LUT_CHN coef_idx*/
+int g_scf_lut_chn_coef_idx[DSS_CHN_MAX_DEFINE] = {-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1};
+
+u32 g_dss_module_cap[DSS_CHN_MAX_DEFINE][MODULE_CAP_MAX] = {
+	/* D2 */
+	{0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1},
+	/* D3 */
+	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
+	/* V0 */
+	{0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1},
+	/* G0 */
+	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
+	/* V1 */
+	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
+	/* G1 */
+	{0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
+	/* D0 */
+	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
+	/* D1 */
+	{0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
+
+	/* W0 */
+	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
+	/* W1 */
+	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
+
+	/* V2 */
+	{0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1},
+	/* W2 */
+	{1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1},
+};
+
+/* number of smrx idx for each channel */
+u32 g_dss_chn_sid_num[DSS_CHN_MAX_DEFINE] = {
+	4, 1, 4, 4, 4, 4, 1, 1, 3, 3, 3, 2
+};
+
+/* start idx of each channel */
+/* smrx_idx = g_dss_smmu_smrx_idx[chn_idx] + (0 ~ g_dss_chn_sid_num[chn_idx]) */
+u32 g_dss_smmu_smrx_idx[DSS_CHN_MAX_DEFINE] = {
+	0, 4, 5, 9, 13, 17, 21, 22, 26, 29, 23, 32
+};
+u32 g_dss_mif_sid_map[DSS_CHN_MAX] = {
+	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+};
+
+static int hisi_pixel_format_hal2dma(int format)
+{
+	int ret = 0;
+
+	switch(format) {
+	case HISI_FB_PIXEL_FORMAT_RGB_565:
+	case HISI_FB_PIXEL_FORMAT_BGR_565:
+		ret = DMA_PIXEL_FORMAT_RGB_565;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBX_4444:
+	case HISI_FB_PIXEL_FORMAT_BGRX_4444:
+		ret = DMA_PIXEL_FORMAT_XRGB_4444;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBA_4444:
+	case HISI_FB_PIXEL_FORMAT_BGRA_4444:
+		ret = DMA_PIXEL_FORMAT_ARGB_4444;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBX_5551:
+	case HISI_FB_PIXEL_FORMAT_BGRX_5551:
+		ret = DMA_PIXEL_FORMAT_XRGB_5551;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBA_5551:
+	case HISI_FB_PIXEL_FORMAT_BGRA_5551:
+		ret = DMA_PIXEL_FORMAT_ARGB_5551;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_RGBX_8888:
+	case HISI_FB_PIXEL_FORMAT_BGRX_8888:
+		ret = DMA_PIXEL_FORMAT_XRGB_8888;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBA_8888:
+	case HISI_FB_PIXEL_FORMAT_BGRA_8888:
+		ret = DMA_PIXEL_FORMAT_ARGB_8888;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_YUV_422_I:
+	case HISI_FB_PIXEL_FORMAT_YUYV_422_Pkg:
+	case HISI_FB_PIXEL_FORMAT_YVYU_422_Pkg:
+	case HISI_FB_PIXEL_FORMAT_UYVY_422_Pkg:
+	case HISI_FB_PIXEL_FORMAT_VYUY_422_Pkg:
+		ret = DMA_PIXEL_FORMAT_YUYV_422_Pkg;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_YCbCr_422_P:
+	case HISI_FB_PIXEL_FORMAT_YCrCb_422_P:
+		ret = DMA_PIXEL_FORMAT_YUV_422_P_HP;
+		break;
+	case HISI_FB_PIXEL_FORMAT_YCbCr_420_P:
+	case HISI_FB_PIXEL_FORMAT_YCrCb_420_P:
+		ret = DMA_PIXEL_FORMAT_YUV_420_P_HP;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_YCbCr_422_SP:
+	case HISI_FB_PIXEL_FORMAT_YCrCb_422_SP:
+		ret = DMA_PIXEL_FORMAT_YUV_422_SP_HP;
+		break;
+	case HISI_FB_PIXEL_FORMAT_YCbCr_420_SP:
+	case HISI_FB_PIXEL_FORMAT_YCrCb_420_SP:
+		ret = DMA_PIXEL_FORMAT_YUV_420_SP_HP;
+		break;
+
+	default:
+		DRM_ERROR("not support format(%d)!\n", format);
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+static int hisi_pixel_format_hal2dfc(int format)
+{
+	int ret = 0;
+
+	switch (format) {
+	case HISI_FB_PIXEL_FORMAT_RGB_565:
+		ret = DFC_PIXEL_FORMAT_RGB_565;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBX_4444:
+		ret = DFC_PIXEL_FORMAT_XBGR_4444;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBA_4444:
+		ret = DFC_PIXEL_FORMAT_ABGR_4444;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBX_5551:
+		ret = DFC_PIXEL_FORMAT_XBGR_5551;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBA_5551:
+		ret = DFC_PIXEL_FORMAT_ABGR_5551;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBX_8888:
+		ret = DFC_PIXEL_FORMAT_XBGR_8888;
+		break;
+	case HISI_FB_PIXEL_FORMAT_RGBA_8888:
+		ret = DFC_PIXEL_FORMAT_ABGR_8888;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_BGR_565:
+		ret = DFC_PIXEL_FORMAT_BGR_565;
+		break;
+	case HISI_FB_PIXEL_FORMAT_BGRX_4444:
+		ret = DFC_PIXEL_FORMAT_XRGB_4444;
+		break;
+	case HISI_FB_PIXEL_FORMAT_BGRA_4444:
+		ret = DFC_PIXEL_FORMAT_ARGB_4444;
+		break;
+	case HISI_FB_PIXEL_FORMAT_BGRX_5551:
+		ret = DFC_PIXEL_FORMAT_XRGB_5551;
+		break;
+	case HISI_FB_PIXEL_FORMAT_BGRA_5551:
+		ret = DFC_PIXEL_FORMAT_ARGB_5551;
+		break;
+	case HISI_FB_PIXEL_FORMAT_BGRX_8888:
+		ret = DFC_PIXEL_FORMAT_XRGB_8888;
+		break;
+	case HISI_FB_PIXEL_FORMAT_BGRA_8888:
+		ret = DFC_PIXEL_FORMAT_ARGB_8888;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_YUV_422_I:
+	case HISI_FB_PIXEL_FORMAT_YUYV_422_Pkg:
+		ret = DFC_PIXEL_FORMAT_YUYV422;
+		break;
+	case HISI_FB_PIXEL_FORMAT_YVYU_422_Pkg:
+		ret = DFC_PIXEL_FORMAT_YVYU422;
+		break;
+	case HISI_FB_PIXEL_FORMAT_UYVY_422_Pkg:
+		ret = DFC_PIXEL_FORMAT_UYVY422;
+		break;
+	case HISI_FB_PIXEL_FORMAT_VYUY_422_Pkg:
+		ret = DFC_PIXEL_FORMAT_VYUY422;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_YCbCr_422_SP:
+		ret = DFC_PIXEL_FORMAT_YUYV422;
+		break;
+	case HISI_FB_PIXEL_FORMAT_YCrCb_422_SP:
+		ret = DFC_PIXEL_FORMAT_YVYU422;
+		break;
+	case HISI_FB_PIXEL_FORMAT_YCbCr_420_SP:
+		ret = DFC_PIXEL_FORMAT_YUYV422;
+		break;
+	case HISI_FB_PIXEL_FORMAT_YCrCb_420_SP:
+		ret = DFC_PIXEL_FORMAT_YVYU422;
+		break;
+
+	case HISI_FB_PIXEL_FORMAT_YCbCr_422_P:
+	case HISI_FB_PIXEL_FORMAT_YCbCr_420_P:
+		ret = DFC_PIXEL_FORMAT_YUYV422;
+		break;
+	case HISI_FB_PIXEL_FORMAT_YCrCb_422_P:
+	case HISI_FB_PIXEL_FORMAT_YCrCb_420_P:
+		ret = DFC_PIXEL_FORMAT_YVYU422;
+		break;
+
+	default:
+		DRM_ERROR("not support format(%d)!\n", format);
+		ret = -1;
+		break;
+	}
+
+	return ret;
+}
+
+static int hisi_dss_aif_ch_config(struct dss_hw_ctx *ctx, int chn_idx)
+{
+	void __iomem *aif0_ch_base;
+	int mid = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	mid = mid_array[chn_idx];
+	aif0_ch_base = ctx->base + g_dss_module_base[chn_idx][MODULE_AIF0_CHN];
+
+	set_reg(aif0_ch_base, 0x0, 1, 0);
+	set_reg(aif0_ch_base, (uint32_t)mid, 4, 4);
+
+	return 0;
+}
+
+static int hisi_dss_smmu_config(struct dss_hw_ctx *ctx, int chn_idx, bool mmu_enable)
+{
+	void __iomem *smmu_base;
+	u32 idx = 0, i = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	smmu_base = ctx->base + DSS_SMMU_OFFSET;
+
+	for (i = 0; i < g_dss_chn_sid_num[chn_idx]; i++) {
+		idx = g_dss_smmu_smrx_idx[chn_idx] + i;
+		if (!mmu_enable)
+			set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 1, 32, 0);
+		else
+			set_reg(smmu_base + SMMU_SMRx_NS + idx * 0x4, 0x70, 32, 0);
+	}
+
+	return 0;
+}
+
+static int hisi_dss_mif_config(struct dss_hw_ctx *ctx, int chn_idx, bool mmu_enable)
+{
+	void __iomem *mif_base;
+	void __iomem *mif_ch_base;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	mif_base = ctx->base + DSS_MIF_OFFSET;
+	mif_ch_base = ctx->base +
+		g_dss_module_base[chn_idx][MODULE_MIF_CHN];
+
+	if (!mmu_enable) {
+		set_reg(mif_ch_base + MIF_CTRL1, 0x1, 1, 5);
+	} else  {
+		set_reg(mif_ch_base + MIF_CTRL1, 0x00080000, 32, 0);
+	}
+
+	return 0;
+}
+
+int hisi_dss_mctl_mutex_lock(struct dss_hw_ctx *ctx)
+{
+	void __iomem *mctl_base;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	mctl_base = ctx->base +
+		g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
+
+	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x1, 1, 0);
+
+	return 0;
+}
+
+int hisi_dss_mctl_mutex_unlock(struct dss_hw_ctx *ctx)
+{
+	void __iomem *mctl_base;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	mctl_base = ctx->base +
+		g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
+
+	set_reg(mctl_base + MCTL_CTL_MUTEX, 0x0, 1, 0);
+
+	return 0;
+}
+
+static int hisi_dss_mctl_ov_config(struct dss_hw_ctx *ctx, int chn_idx)
+{
+	void __iomem *mctl_base;
+	u32 mctl_rch_offset = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	mctl_rch_offset = (uint32_t)(MCTL_CTL_MUTEX_RCH0 + chn_idx * 0x4);
+
+	mctl_base = ctx->base +
+		g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
+
+	set_reg(mctl_base + MCTL_CTL_EN, 0x1, 32, 0);
+	set_reg(mctl_base + MCTL_CTL_TOP, 0x2, 32, 0); /*auto mode*/
+	set_reg(mctl_base + MCTL_CTL_DBG, 0xB13A00, 32, 0);
+
+	set_reg(mctl_base + mctl_rch_offset, 0x1, 32, 0);
+	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 2, 0);
+	set_reg(mctl_base + MCTL_CTL_MUTEX_DBUF, 0x1, 2, 0);
+	set_reg(mctl_base + MCTL_CTL_MUTEX_OV, 1 << DSS_OVL0, 4, 0);
+
+	return 0;
+}
+
+static int hisi_dss_mctl_sys_config(struct dss_hw_ctx *ctx, int chn_idx)
+{
+	void __iomem *mctl_sys_base;
+
+	u32 layer_idx = 0;
+	u32 mctl_rch_ov_oen_offset = 0;
+	u32 mctl_rch_flush_en_offset = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
+	mctl_rch_ov_oen_offset = MCTL_RCH0_OV_OEN + chn_idx * 0x4;
+	mctl_rch_flush_en_offset = MCTL_RCH0_FLUSH_EN + chn_idx * 0x4;
+
+	set_reg(mctl_sys_base + mctl_rch_ov_oen_offset,
+		((1 << (layer_idx + 1)) | (0x100 << DSS_OVL0)), 32, 0);
+
+	set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0x8, 4, 0);
+
+	set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, chn_idx, 4, (layer_idx + 1) * 4);
+
+	set_reg(mctl_sys_base + MCTL_OV0_FLUSH_EN, 0xd, 4, 0);
+	set_reg(mctl_sys_base + mctl_rch_flush_en_offset, 0x1, 32, 0);
+
+	return 0;
+}
+
+static int hisi_dss_rdma_config(struct dss_hw_ctx *ctx,
+	const dss_rect_ltrb_t *rect, u32 display_addr, u32 hal_format,
+	u32 bpp, int chn_idx, bool afbcd, bool mmu_enable)
+{
+	void __iomem *rdma_base;
+
+	u32 aligned_pixel = 0;
+	u32 rdma_oft_x0 = 0;
+	u32 rdma_oft_y0 = 0;
+	u32 rdma_oft_x1 = 0;
+	u32 rdma_oft_y1 = 0;
+	u32 rdma_stride = 0;
+	u32 rdma_bpp = 0;
+	u32 rdma_format = 0;
+	u32 stretch_size_vrt = 0;
+
+	u32 stride_align = 0;
+	u32 mm_base_0 = 0;
+	u32 mm_base_1 = 0;
+
+	u32 afbcd_header_addr = 0;
+	u32 afbcd_header_stride = 0;
+	u32 afbcd_payload_addr = 0;
+	u32 afbcd_payload_stride = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	if (bpp == 4) {
+		rdma_bpp = 0x5;
+	} else if (bpp == 2) {
+		rdma_bpp = 0x0;
+	} else {
+		rdma_bpp = 0x0;
+	}
+
+	rdma_base = ctx->base +
+		g_dss_module_base[chn_idx][MODULE_DMA];
+
+	aligned_pixel = DMA_ALIGN_BYTES / bpp;
+	rdma_oft_x0 = rect->left / aligned_pixel;
+	rdma_oft_y0 = rect->top;
+	rdma_oft_x1 = rect->right / aligned_pixel;
+	rdma_oft_y1 = rect->bottom;
+
+	rdma_format = hisi_pixel_format_hal2dma(hal_format);
+	if (rdma_format < 0) {
+		DRM_ERROR("layer format(%d) not support !\n", hal_format);
+		return -EINVAL;
+	}
+
+	if (afbcd) {
+		mm_base_0 = 0;
+		mm_base_1 = mm_base_0 + rect->right * bpp * MMBUF_LINE_NUM;
+		mm_base_0 = ALIGN_UP(mm_base_0, MMBUF_ADDR_ALIGN);
+		mm_base_1 = ALIGN_UP(mm_base_1, MMBUF_ADDR_ALIGN);
+
+		if ((((rect->right - rect->left) + 1) & (AFBC_HEADER_ADDR_ALIGN - 1)) ||
+				(((rect->bottom - rect->top) + 1) & (AFBC_BLOCK_ALIGN - 1))) {
+			DRM_ERROR("img width(%d) is not %d bytes aligned, or "
+					"img heigh(%d) is not %d bytes aligned!\n",
+					((rect->right - rect->left) + 1), AFBC_HEADER_ADDR_ALIGN,
+					((rect->bottom - rect->top) + 1), AFBC_BLOCK_ALIGN);
+		}
+
+		if ((mm_base_0 & (MMBUF_ADDR_ALIGN - 1)) || (mm_base_1 & (MMBUF_ADDR_ALIGN - 1))) {
+			DRM_ERROR("mm_base_0(0x%x) is not %d bytes aligned, or "
+					"mm_base_1(0x%x) is not %d bytes aligned!\n",
+					mm_base_0, MMBUF_ADDR_ALIGN,
+					mm_base_1, MMBUF_ADDR_ALIGN);
+		}
+		/*header*/
+		afbcd_header_stride = (((rect->right - rect->left) + 1) / AFBC_BLOCK_ALIGN) * AFBC_HEADER_STRIDE_BLOCK;
+		afbcd_header_addr = (uint32_t)(unsigned long)display_addr;
+
+		/*payload*/
+		if (bpp == 4)
+			stride_align = AFBC_PAYLOAD_STRIDE_ALIGN_32;
+		else if (bpp == 2)
+			stride_align = AFBC_PAYLOAD_STRIDE_ALIGN_16;
+		else
+			DRM_ERROR("bpp(%d) not supported!\n", bpp);
+
+		afbcd_payload_stride = (((rect->right - rect->left) + 1) / AFBC_BLOCK_ALIGN) * stride_align;
+
+		afbcd_payload_addr = afbcd_header_addr + ALIGN_UP(16 * (((rect->right - rect->left) + 1) / 16) *
+				(((rect->bottom - rect->top) + 1) / 16), 1024);
+		afbcd_payload_addr = afbcd_payload_addr +
+			(rect->top / AFBC_BLOCK_ALIGN) * afbcd_payload_stride +
+			(rect->left / AFBC_BLOCK_ALIGN) * stride_align;
+
+		set_reg(rdma_base + CH_REG_DEFAULT, 0x1, 32, 0);
+		set_reg(rdma_base + CH_REG_DEFAULT, 0x0, 32, 0);
+		set_reg(rdma_base + DMA_OFT_X0, rdma_oft_x0, 12, 0);
+		set_reg(rdma_base + DMA_OFT_Y0, rdma_oft_y0, 16, 0);
+		set_reg(rdma_base + DMA_OFT_X1, rdma_oft_x1, 12, 0);
+		set_reg(rdma_base + DMA_OFT_Y1, rdma_oft_y1, 16, 0);
+		set_reg(rdma_base + DMA_STRETCH_SIZE_VRT, (rect->bottom - rect->top), 13, 0);
+		set_reg(rdma_base + DMA_CTRL, rdma_format, 5, 3);
+		set_reg(rdma_base + DMA_CTRL, (mmu_enable ? 0x1 : 0x0), 1, 8);
+
+		set_reg(rdma_base + AFBCD_HREG_PIC_WIDTH, (rect->right - rect->left), 16, 0);
+		set_reg(rdma_base + AFBCD_HREG_PIC_HEIGHT, (rect->bottom - rect->top), 16, 0);
+		set_reg(rdma_base + AFBCD_CTL, AFBC_HALF_BLOCK_UPPER_LOWER_ALL, 2, 6);
+		set_reg(rdma_base + AFBCD_HREG_HDR_PTR_LO, afbcd_header_addr, 32, 0);
+		set_reg(rdma_base + AFBCD_INPUT_HEADER_STRIDE, afbcd_header_stride, 14, 0);
+		set_reg(rdma_base + AFBCD_PAYLOAD_STRIDE, afbcd_payload_stride, 20, 0);
+		set_reg(rdma_base + AFBCD_MM_BASE_0, mm_base_0, 32, 0);
+		set_reg(rdma_base + AFBCD_HREG_FORMAT, 0x1, 1, 21);
+		set_reg(rdma_base + AFBCD_SCRAMBLE_MODE, 0x0, 32, 0);
+		set_reg(rdma_base + AFBCD_AFBCD_PAYLOAD_POINTER, afbcd_payload_addr, 32, 0);
+		set_reg(rdma_base + AFBCD_HEIGHT_BF_STR, (rect->bottom - rect->top), 16, 0);
+
+		set_reg(rdma_base + CH_CTL, 0xf005, 32, 0);
+	} else {
+		stretch_size_vrt = rdma_oft_y1 - rdma_oft_y0;
+		rdma_stride = ((rect->right - rect->left) + 1) * bpp / DMA_ALIGN_BYTES;
+
+		set_reg(rdma_base + CH_REG_DEFAULT, 0x1, 32, 0);
+		set_reg(rdma_base + CH_REG_DEFAULT, 0x0, 32, 0);
+
+		set_reg(rdma_base + DMA_OFT_X0, rdma_oft_x0, 12, 0);
+		set_reg(rdma_base + DMA_OFT_Y0, rdma_oft_y0, 16, 0);
+		set_reg(rdma_base + DMA_OFT_X1, rdma_oft_x1, 12, 0);
+		set_reg(rdma_base + DMA_OFT_Y1, rdma_oft_y1, 16, 0);
+		set_reg(rdma_base + DMA_CTRL, rdma_format, 5, 3);
+		set_reg(rdma_base + DMA_CTRL, (mmu_enable ? 0x1 : 0x0), 1, 8);
+		set_reg(rdma_base + DMA_STRETCH_SIZE_VRT, stretch_size_vrt, 32, 0);
+		set_reg(rdma_base + DMA_DATA_ADDR0, display_addr, 32, 0);
+		set_reg(rdma_base + DMA_STRIDE0, rdma_stride, 13, 0);
+
+		set_reg(rdma_base + CH_CTL, 0x1, 1, 0);
+	}
+
+	return 0;
+}
+
+static int hisi_dss_rdfc_config(struct dss_hw_ctx *ctx,
+	const dss_rect_ltrb_t *rect, u32 hal_format, u32 bpp, int chn_idx)
+{
+	void __iomem *rdfc_base;
+
+	u32 dfc_pix_in_num = 0;
+	u32 size_hrz = 0;
+	u32 size_vrt = 0;
+	u32 dfc_fmt = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	rdfc_base = ctx->base +
+		g_dss_module_base[chn_idx][MODULE_DFC];
+
+	dfc_pix_in_num = (bpp <= 2) ? 0x1 : 0x0;
+	size_hrz = rect->right - rect->left;
+	size_vrt = rect->bottom - rect->top;
+
+	dfc_fmt = hisi_pixel_format_hal2dfc(hal_format);
+	if (dfc_fmt < 0) {
+		DRM_ERROR("layer format (%d) not support !\n", hal_format);
+		return -EINVAL;
+	}
+
+	set_reg(rdfc_base + DFC_DISP_SIZE, (size_vrt | (size_hrz << 16)), 29, 0);
+	set_reg(rdfc_base + DFC_PIX_IN_NUM, dfc_pix_in_num, 1, 0);
+	//set_reg(rdfc_base + DFC_DISP_FMT, (bpp <= 2) ? 0x0 : 0x6, 5, 1);
+	set_reg(rdfc_base + DFC_DISP_FMT, dfc_fmt, 5, 1);
+	set_reg(rdfc_base + DFC_CTL_CLIP_EN, 0x1, 1, 0);
+	set_reg(rdfc_base + DFC_ICG_MODULE, 0x1, 1, 0);
+
+	return 0;
+}
+
+int hisi_dss_ovl_base_config(struct dss_hw_ctx *ctx, u32 xres, u32 yres)
+{
+	void __iomem *mctl_sys_base;
+	void __iomem *mctl_base;
+	void __iomem *ovl0_base;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
+	mctl_base = ctx->base +
+		g_dss_module_ovl_base[DSS_OVL0][MODULE_MCTL_BASE];
+	ovl0_base = ctx->base +
+		g_dss_module_ovl_base[DSS_OVL0][MODULE_OVL_BASE];
+
+	set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x1, 32, 0);
+	set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x0, 32, 0);
+
+	set_reg(ovl0_base + OVL_SIZE, (xres - 1) | ((yres - 1) << 16), 32, 0);
+#ifdef CONFIG_HISI_FB_OV_BASE_USED
+	set_reg(ovl0_base + OVL_BG_COLOR, 0xFFFF0000, 32, 0);
+#else
+	set_reg(ovl0_base + OVL_BG_COLOR, 0xFF000000, 32, 0);
+#endif
+	set_reg(ovl0_base + OVL_DST_STARTPOS, 0x0, 32, 0);
+	set_reg(ovl0_base + OVL_DST_ENDPOS, (xres - 1) | ((yres - 1) << 16), 32, 0);
+	set_reg(ovl0_base + OVL_GCFG, 0x10001, 32, 0);
+
+	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 32, 0);
+	set_reg(mctl_base + MCTL_CTL_MUTEX_DBUF, 0x1, 2, 0);
+	set_reg(mctl_base + MCTL_CTL_MUTEX_OV, 1 << DSS_OVL0, 4, 0);
+
+	set_reg(mctl_sys_base + MCTL_RCH_OV0_SEL, 0x8, 4, 0);
+	set_reg(mctl_sys_base + MCTL_OV0_FLUSH_EN, 0xd, 4, 0);
+
+	return 0;
+}
+
+static int hisi_dss_ovl_config(struct dss_hw_ctx *ctx,
+	const dss_rect_ltrb_t *rect, u32 xres, u32 yres)
+{
+	void __iomem *ovl0_base;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return -1;
+	}
+
+	ovl0_base = ctx->base +
+		g_dss_module_ovl_base[DSS_OVL0][MODULE_OVL_BASE];
+
+	set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x1, 32, 0);
+	set_reg(ovl0_base + OVL6_REG_DEFAULT, 0x0, 32, 0);
+	set_reg(ovl0_base + OVL_SIZE, (xres - 1) |
+		((yres - 1) << 16), 32, 0);
+	set_reg(ovl0_base + OVL_BG_COLOR, 0xFF000000, 32, 0);
+	set_reg(ovl0_base + OVL_DST_STARTPOS, 0x0, 32, 0);
+	set_reg(ovl0_base + OVL_DST_ENDPOS, (xres - 1) |
+		((yres - 1) << 16), 32, 0);
+	set_reg(ovl0_base + OVL_GCFG, 0x10001, 32, 0);
+	set_reg(ovl0_base + OVL_LAYER0_POS, (rect->left) |
+		((rect->top) << 16), 32, 0);
+	set_reg(ovl0_base + OVL_LAYER0_SIZE, (rect->right) |
+		((rect->bottom) << 16), 32, 0);
+	set_reg(ovl0_base + OVL_LAYER0_ALPHA, 0x00ff40ff, 32, 0);
+	set_reg(ovl0_base + OVL_LAYER0_CFG, 0x1, 1, 0);
+
+	return 0;
+}
+
+static void hisi_dss_qos_on(struct dss_hw_ctx *ctx)
+{
+	char __iomem *noc_dss_base;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	noc_dss_base = ctx->noc_dss_base;
+
+	outp32(noc_dss_base + 0xc, 0x2);
+	outp32(noc_dss_base + 0x8c, 0x2);
+	outp32(noc_dss_base + 0x10c, 0x2);
+	outp32(noc_dss_base + 0x18c, 0x2);
+}
+
+static void hisi_dss_mif_on(struct dss_hw_ctx *ctx)
+{
+	char __iomem *dss_base;
+	char __iomem *mif_base;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	dss_base = ctx->base;
+	mif_base = ctx->base + DSS_MIF_OFFSET;
+
+	set_reg(mif_base + MIF_ENABLE, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH0_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH1_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH2_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH3_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH4_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH5_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH6_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH7_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH8_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH9_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+
+	set_reg(dss_base + MIF_CH10_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+	set_reg(dss_base + MIF_CH11_OFFSET + MIF_CTRL0, 0x1, 1, 0);
+}
+
+void hisi_dss_smmu_on(struct dss_hw_ctx *ctx)
+{
+	void __iomem *smmu_base;
+	struct iommu_domain_data *domain_data = NULL;
+	uint32_t phy_pgd_base = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	smmu_base = ctx->base + DSS_SMMU_OFFSET;
+
+	set_reg(smmu_base + SMMU_SCR, 0x0, 1, 0);  /*global bypass cancel*/
+	set_reg(smmu_base + SMMU_SCR, 0x1, 8, 20); /*ptw_mid*/
+	set_reg(smmu_base + SMMU_SCR, 0xf, 4, 16); /*pwt_pf*/
+	set_reg(smmu_base + SMMU_SCR, 0x7, 3, 3);  /*interrupt cachel1 cach3l2 en*/
+	set_reg(smmu_base + SMMU_LP_CTRL, 0x1, 1, 0);  /*auto_clk_gt_en*/
+
+	/*Long Descriptor*/
+	set_reg(smmu_base + SMMU_CB_TTBCR, 0x1, 1, 0);
+
+	set_reg(smmu_base + SMMU_ERR_RDADDR, 0x7FF00000, 32, 0);
+	set_reg(smmu_base + SMMU_ERR_WRADDR, 0x7FFF0000, 32, 0);
+
+	/*disable cmdlist, dbg, reload*/
+	set_reg(smmu_base + SMMU_RLD_EN0_NS, DSS_SMMU_RLD_EN0_DEFAULT_VAL, 32, 0);
+	set_reg(smmu_base + SMMU_RLD_EN1_NS, DSS_SMMU_RLD_EN1_DEFAULT_VAL, 32, 0);
+
+	/*cmdlist stream bypass*/
+	set_reg(smmu_base + SMMU_SMRx_NS + 36 * 0x4, 0x1, 32, 0); /*debug stream id*/
+	set_reg(smmu_base + SMMU_SMRx_NS + 37 * 0x4, 0x1, 32, 0); /*cmd unsec stream id*/
+	set_reg(smmu_base + SMMU_SMRx_NS + 38 * 0x4, 0x1, 32, 0); /*cmd sec stream id*/
+
+	/*TTBR0*/
+	domain_data = (struct iommu_domain_data *)(ctx->mmu_domain->priv);
+	phy_pgd_base = (uint32_t)(domain_data->phy_pgd_base);
+	set_reg(smmu_base + SMMU_CB_TTBR0, phy_pgd_base, 32, 0);
+}
+
+void hisifb_dss_on(struct dss_hw_ctx *ctx)
+{
+	/* dss qos on*/
+	hisi_dss_qos_on(ctx);
+	/* mif on*/
+	hisi_dss_mif_on(ctx);
+	/* smmu on*/
+	hisi_dss_smmu_on(ctx);
+}
+
+void hisi_dss_mctl_on(struct dss_hw_ctx *ctx)
+{
+	char __iomem *mctl_base = NULL;
+	char __iomem *mctl_sys_base = NULL;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+	mctl_base = ctx->base +
+		g_dss_module_ovl_base[DSS_MCTL0][MODULE_MCTL_BASE];
+	mctl_sys_base = ctx->base + DSS_MCTRL_SYS_OFFSET;
+
+	set_reg(mctl_base + MCTL_CTL_EN, 0x1, 32, 0);
+	set_reg(mctl_base + MCTL_CTL_MUTEX_ITF, 0x1, 32, 0);
+	set_reg(mctl_base + MCTL_CTL_DBG, 0xB13A00, 32, 0);
+	set_reg(mctl_base + MCTL_CTL_TOP, 0x2, 32, 0);
+}
+
+void hisi_dss_unflow_handler(struct dss_hw_ctx *ctx, bool unmask)
+{
+	void __iomem *dss_base;
+	u32 tmp = 0;
+
+	if (!ctx) {
+		DRM_ERROR("ctx is NULL!\n");
+		return;
+	}
+
+	dss_base = ctx->base;
+
+	tmp = inp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK);
+	if (unmask)
+		tmp &= ~BIT_LDI_UNFLOW;
+	else
+		tmp |= BIT_LDI_UNFLOW;
+
+	outp32(dss_base + DSS_LDI0_OFFSET + LDI_CPU_ITF_INT_MSK, tmp);
+}
+
+static int hisi_vactive0_start_config(struct dss_hw_ctx *ctx)
+{
+	int ret = 0;
+	u32 times = 0;
+	u32 prev_vactive0_start = 0;
+
+	prev_vactive0_start = ctx->vactive0_start_flag;
+
+REDO:
+	ret = wait_event_interruptible_timeout(ctx->vactive0_start_wq,
+		(prev_vactive0_start != ctx->vactive0_start_flag),
+		msecs_to_jiffies(300));
+	if (ret == -ERESTARTSYS) {
+		if (times < 50) {
+			times++;
+			mdelay(10);
+			goto REDO;
+		}
+	}
+
+	if (ret <= 0) {
+		DRM_ERROR("wait_for vactive0_start_flag timeout! ret=%d.\n", ret);
+
+		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
+void hisi_fb_pan_display(struct drm_plane *plane)
+{
+	struct drm_plane_state *state = plane->state;
+	struct drm_framebuffer *fb = state->fb;
+	struct drm_display_mode *mode;
+	struct drm_display_mode *adj_mode;
+
+	struct dss_plane *aplane = to_dss_plane(plane);
+	struct dss_crtc *acrtc = aplane->acrtc;
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	struct kirin_drm_private *priv = plane->dev->dev_private;
+	struct kirin_fbdev *fbdev = to_kirin_fbdev(priv->fbdev);
+
+	ktime_t prepare_timestamp;
+	u64 vsync_timediff;
+
+	bool afbcd = false;
+	bool mmu_enable = true;
+	dss_rect_ltrb_t rect;
+	u32 bpp;
+	u32 stride;
+	u32 display_addr;
+	u32 hal_fmt;
+	int chn_idx = DSS_RCHN_D2;
+
+	int crtc_x = state->crtc_x;
+	int crtc_y = state->crtc_y;
+	unsigned int crtc_w = state->crtc_w;
+	unsigned int crtc_h = state->crtc_h;
+	u32 src_x = state->src_x >> 16;
+	u32 src_y = state->src_y >> 16;
+	u32 src_w = state->src_w >> 16;
+	u32 src_h = state->src_h >> 16;
+
+	u32 hfp, hbp, hsw, vfp, vbp, vsw;
+
+	mode = &acrtc->base.state->mode;
+	adj_mode = &acrtc->base.state->adjusted_mode;
+
+	bpp = fb->bits_per_pixel / 8;
+	stride = fb->pitches[0];
+
+	display_addr = (u32)fbdev->smem_start + src_y * stride;
+
+	rect.left = 0;
+	rect.right = src_w - 1;
+	rect.top = 0;
+	rect.bottom = src_h - 1;
+	hal_fmt = dss_get_format(fb->pixel_format);
+
+	DRM_DEBUG("channel%d: src:(%d,%d, %dx%d) crtc:(%d,%d, %dx%d), rect(%d,%d,%d,%d),"
+		"fb:%dx%d, pixel_format=%d, stride=%d, paddr=0x%x, bpp=%d, bits_per_pixel=%d.\n",
+		chn_idx, src_x, src_y, src_w, src_h,
+		crtc_x, crtc_y, crtc_w, crtc_h,
+		rect.left, rect.top, rect.right, rect.bottom,
+		fb->width, fb->height, hal_fmt,
+		stride, display_addr, bpp, fb->bits_per_pixel);
+
+	hfp = mode->hsync_start - mode->hdisplay;
+	hbp = mode->htotal - mode->hsync_end;
+	hsw = mode->hsync_end - mode->hsync_start;
+	vfp = mode->vsync_start - mode->vdisplay;
+	vbp = mode->vtotal - mode->vsync_end;
+	vsw = mode->vsync_end - mode->vsync_start;
+
+	vsync_timediff = (uint64_t)(mode->hdisplay + hbp + hfp + hsw) *
+		(mode->vdisplay + vbp + vfp + vsw) *
+		1000000000UL / (adj_mode->clock * 1000);
+
+	prepare_timestamp = ktime_get();
+
+	if ((ktime_to_ns(prepare_timestamp) > ktime_to_ns(ctx->vsync_timestamp)) &&
+		(ktime_to_ns(prepare_timestamp) - ktime_to_ns(ctx->vsync_timestamp) < (vsync_timediff - 2000000)) &&
+		(ktime_to_ns(ctx->vsync_timestamp_prev) != ktime_to_ns(ctx->vsync_timestamp))) {
+		DRM_DEBUG("vsync_timediff=%llu, timestamp_diff=%llu!\n",
+			vsync_timediff, ktime_to_ns(prepare_timestamp) - ktime_to_ns(ctx->vsync_timestamp));
+	} else {
+		DRM_DEBUG("vsync_timediff=%llu.\n", vsync_timediff);
+
+		if (hisi_vactive0_start_config(ctx) != 0) {
+			DRM_ERROR("hisi_vactive0_start_config failed!\n");
+			return;
+		}
+	}
+	ctx->vsync_timestamp_prev = ctx->vsync_timestamp;
+
+	hisi_dss_mctl_mutex_lock(ctx);
+	hisi_dss_aif_ch_config(ctx, chn_idx);
+	hisi_dss_mif_config(ctx, chn_idx, mmu_enable);
+	hisi_dss_smmu_config(ctx, chn_idx, mmu_enable);
+
+	hisi_dss_rdma_config(ctx, &rect, display_addr, hal_fmt, bpp, chn_idx, afbcd, mmu_enable);
+	hisi_dss_rdfc_config(ctx, &rect, hal_fmt, bpp, chn_idx);
+	hisi_dss_ovl_config(ctx, &rect, mode->hdisplay, mode->vdisplay);
+
+	hisi_dss_mctl_ov_config(ctx, chn_idx);
+	hisi_dss_mctl_sys_config(ctx, chn_idx);
+	hisi_dss_mctl_mutex_unlock(ctx);
+
+	hisi_dss_unflow_handler(ctx, true);
+
+	enable_ldi(acrtc);
+}
+
+void hisi_dss_online_play(struct drm_plane *plane, drm_dss_layer_t *layer)
+{
+	struct drm_plane_state *state = plane->state;
+	struct drm_display_mode *mode;
+	struct drm_display_mode *adj_mode;
+
+	struct dss_plane *aplane = to_dss_plane(plane);
+	struct dss_crtc *acrtc = aplane->acrtc;
+	struct dss_hw_ctx *ctx = acrtc->ctx;
+
+	ktime_t prepare_timestamp;
+	u64 vsync_timediff;
+
+	bool afbcd = false;
+	bool mmu_enable = true;
+	dss_rect_ltrb_t rect;
+	u32 bpp;
+	u32 stride;
+	u32 display_addr;
+
+	int chn_idx = DSS_RCHN_D2;
+	u32 hal_fmt = 0;
+	u32 src_w = state->src_w >> 16;
+	u32 src_h = state->src_h >> 16;
+
+	u32 hfp, hbp, hsw, vfp, vbp, vsw;
+
+	mode = &acrtc->base.state->mode;
+	adj_mode = &acrtc->base.state->adjusted_mode;
+
+	bpp = layer->img.bpp;
+	stride = layer->img.stride;
+	display_addr = layer->img.vir_addr;
+	hal_fmt = layer->img.format;
+
+	rect.left = 0;
+	rect.right = src_w - 1;
+	rect.top = 0;
+	rect.bottom = src_h - 1;
+
+	hfp = mode->hsync_start - mode->hdisplay;
+	hbp = mode->htotal - mode->hsync_end;
+	hsw = mode->hsync_end - mode->hsync_start;
+	vfp = mode->vsync_start - mode->vdisplay;
+	vbp = mode->vtotal - mode->vsync_end;
+	vsw = mode->vsync_end - mode->vsync_start;
+
+	vsync_timediff = (uint64_t)(mode->hdisplay + hbp + hfp + hsw) *
+		(mode->vdisplay + vbp + vfp + vsw) *
+		1000000000UL / (adj_mode->clock * 1000);
+
+	prepare_timestamp = ktime_get();
+
+	if ((ktime_to_ns(prepare_timestamp) > ktime_to_ns(ctx->vsync_timestamp)) &&
+		(ktime_to_ns(prepare_timestamp) - ktime_to_ns(ctx->vsync_timestamp) < (vsync_timediff - 2000000)) &&
+		(ktime_to_ns(ctx->vsync_timestamp_prev) != ktime_to_ns(ctx->vsync_timestamp))) {
+		DRM_DEBUG("vsync_timediff=%llu, timestamp_diff=%llu!\n",
+			vsync_timediff, ktime_to_ns(prepare_timestamp) - ktime_to_ns(ctx->vsync_timestamp));
+	} else {
+		DRM_DEBUG("vsync_timediff=%llu.\n", vsync_timediff);
+
+		if (hisi_vactive0_start_config(ctx) != 0) {
+			DRM_ERROR("hisi_vactive0_start_config failed!\n");
+			return;
+		}
+	}
+
+	ctx->vsync_timestamp_prev = ctx->vsync_timestamp;
+
+	hisi_dss_mctl_mutex_lock(ctx);
+	hisi_dss_aif_ch_config(ctx, chn_idx);
+	hisi_dss_mif_config(ctx, chn_idx, mmu_enable);
+	hisi_dss_smmu_config(ctx, chn_idx, mmu_enable);
+
+	hisi_dss_rdma_config(ctx, &rect, display_addr, hal_fmt, bpp, chn_idx, afbcd, mmu_enable);
+	hisi_dss_rdfc_config(ctx, &rect, hal_fmt, bpp, chn_idx);
+	hisi_dss_ovl_config(ctx, &rect, mode->hdisplay, mode->vdisplay);
+
+	hisi_dss_mctl_ov_config(ctx, chn_idx);
+	hisi_dss_mctl_sys_config(ctx, chn_idx);
+	hisi_dss_mctl_mutex_unlock(ctx);
+
+	hisi_dss_unflow_handler(ctx, true);
+
+	enable_ldi(acrtc);
+}
diff --git a/drivers/staging/hikey9xx/gpu/kirin_fb.c b/drivers/staging/hikey9xx/gpu/kirin_fb.c
new file mode 100644
index 000000000000..834c9a381a4a
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_fb.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2013 Red Hat
+ * Author: Rob Clark <robdclark@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <drm/drmP.h>
+
+#include "kirin_drm_drv.h"
+
+#include "drm_crtc.h"
+#include "drm_crtc_helper.h"
+
+struct kirin_framebuffer {
+	struct drm_framebuffer base;
+};
+#define to_kirin_framebuffer(x) container_of(x, struct kirin_framebuffer, base)
+
+
+static int kirin_framebuffer_create_handle(struct drm_framebuffer *fb,
+		struct drm_file *file_priv,
+		unsigned int *handle)
+{
+	//struct kirin_framebuffer *kirin_fb = to_kirin_framebuffer(fb);
+	return 0;
+}
+
+static void kirin_framebuffer_destroy(struct drm_framebuffer *fb)
+{
+	struct kirin_framebuffer *kirin_fb = to_kirin_framebuffer(fb);
+
+	DRM_DEBUG("destroy: FB ID: %d (%p)", fb->base.id, fb);
+
+	drm_framebuffer_cleanup(fb);
+
+	kfree(kirin_fb);
+}
+
+static int kirin_framebuffer_dirty(struct drm_framebuffer *fb,
+		struct drm_file *file_priv, unsigned flags, unsigned color,
+		struct drm_clip_rect *clips, unsigned num_clips)
+{
+	return 0;
+}
+
+static const struct drm_framebuffer_funcs kirin_framebuffer_funcs = {
+	.create_handle = kirin_framebuffer_create_handle,
+	.destroy = kirin_framebuffer_destroy,
+	.dirty = kirin_framebuffer_dirty,
+};
+
+struct drm_framebuffer *kirin_framebuffer_init(struct drm_device *dev,
+		struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	struct kirin_framebuffer *kirin_fb = NULL;
+	struct drm_framebuffer *fb;
+	int ret;
+
+	kirin_fb = kzalloc(sizeof(*kirin_fb), GFP_KERNEL);
+	if (!kirin_fb) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	fb = &kirin_fb->base;
+
+	drm_helper_mode_fill_fb_struct(fb, mode_cmd);
+
+	ret = drm_framebuffer_init(dev, fb, &kirin_framebuffer_funcs);
+	if (ret) {
+		dev_err(dev->dev, "framebuffer init failed: %d\n", ret);
+		goto fail;
+	}
+
+	DRM_DEBUG("create: FB ID: %d (%p)", fb->base.id, fb);
+
+	return fb;
+
+fail:
+	kfree(kirin_fb);
+
+	return ERR_PTR(ret);
+}
diff --git a/drivers/staging/hikey9xx/gpu/kirin_fbdev.c b/drivers/staging/hikey9xx/gpu/kirin_fbdev.c
new file mode 100644
index 000000000000..424a4107db56
--- /dev/null
+++ b/drivers/staging/hikey9xx/gpu/kirin_fbdev.c
@@ -0,0 +1,470 @@
+/*
+ * Copyright (C) 2013 Red Hat
+ * Author: Rob Clark <robdclark@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <drm/drmP.h>
+#include <drm_crtc_helper.h>
+
+#include <linux/ion.h>
+#include <linux/hisi/hisi_ion.h>
+
+#include "kirin_drm_drv.h"
+#include "kirin_dpe_reg.h"
+#include "kirin_drm_dpe_utils.h"
+
+#include "drm_crtc.h"
+#include "drm_fb_helper.h"
+
+//#define CONFIG_HISI_FB_HEAP_CARVEOUT_USED
+
+#define FBDEV_BUFFER_NUM 3
+struct fb_dmabuf_export
+{
+    __u32 fd;
+    __u32 flags;
+};
+#define FBIOGET_DMABUF  _IOR('F', 0x21, struct fb_dmabuf_export)
+
+#define HISIFB_IOCTL_MAGIC 'M'
+#define HISI_DRM_ONLINE_PLAY _IOW(HISIFB_IOCTL_MAGIC, 0x21, struct drm_dss_layer)
+
+/*
+ * fbdev funcs, to implement legacy fbdev interface on top of drm driver
+ */
+
+#define HISI_FB_ION_CLIENT_NAME	"hisi_fb_ion"
+
+unsigned long kirin_alloc_fb_buffer(struct kirin_fbdev *fbdev, int size)
+{
+	struct ion_client *client = NULL;
+	struct ion_handle *handle = NULL;
+	size_t buf_len = 0;
+	unsigned long buf_addr = 0;
+	int shared_fd = -1;
+
+	if (NULL == fbdev) {
+		DRM_ERROR("fbdev is NULL!\n");
+		return -EINVAL;
+	}
+
+	client = fbdev->ion_client;
+	handle = fbdev->ion_handle;
+
+	buf_len = size;
+
+	client = hisi_ion_client_create(HISI_FB_ION_CLIENT_NAME);
+	if (!client) {
+		DRM_ERROR("failed to create ion client!\n");
+		return -ENOMEM;
+	}
+	memset(&fbdev->iommu_format, 0, sizeof(struct iommu_map_format));
+
+#ifdef CONFIG_HISI_FB_HEAP_CARVEOUT_USED
+	handle = ion_alloc(client, buf_len, PAGE_SIZE, ION_HEAP(ION_GRALLOC_HEAP_ID), 0);
+#else
+	handle = ion_alloc(client, buf_len, PAGE_SIZE, ION_HEAP(ION_SYSTEM_HEAP_ID), 0);
+#endif
+	if (!handle) {
+		DRM_ERROR("failed to ion_alloc!\n");
+		goto err_return;
+	}
+
+	fbdev->screen_base = ion_map_kernel(client, handle);
+	if (!fbdev->screen_base) {
+		DRM_ERROR("failed to ion_map_kernel!\n");
+		goto err_ion_map;
+	}
+
+#ifdef CONFIG_HISI_FB_HEAP_CARVEOUT_USED
+	if (ion_phys(client, handle, &buf_addr, &buf_len) < 0) {
+		DRM_ERROR("failed to get ion phys!\n");
+		goto err_ion_get_addr;
+	}
+#else
+	if (ion_map_iommu(client, handle, &(fbdev->iommu_format))) {
+		DRM_ERROR("failed to ion_map_iommu!\n");
+		goto err_ion_get_addr;
+	}
+
+	buf_addr = fbdev->iommu_format.iova_start;
+#endif
+
+	fbdev->shared_fd = shared_fd;
+	fbdev->smem_start = buf_addr;
+	fbdev->screen_size = buf_len;
+	memset(fbdev->screen_base, 0x0, fbdev->screen_size);
+
+	fbdev->ion_client = client;
+	fbdev->ion_handle = handle;
+
+	return buf_addr;
+
+err_ion_get_addr:
+	ion_unmap_kernel(client, handle);
+err_ion_map:
+	ion_free(client, handle);
+err_return:
+	return 0;
+}
+
+static int kirin_fbdev_mmap(struct fb_info *info, struct vm_area_struct * vma)
+{
+	struct sg_table *table = NULL;
+	struct scatterlist *sg = NULL;
+	struct page *page = NULL;
+	unsigned long remainder = 0;
+	unsigned long len = 0;
+	unsigned long addr = 0;
+	unsigned long offset = 0;
+	unsigned long size = 0;
+	int i = 0;
+	int ret = 0;
+
+	struct drm_fb_helper *helper = (struct drm_fb_helper *)info->par;
+	struct kirin_fbdev *fbdev = to_kirin_fbdev(helper);
+
+	if (NULL == info) {
+		DRM_ERROR("info is NULL!\n");
+		return -EINVAL;
+	}
+
+	if (NULL == fbdev) {
+		DRM_ERROR("fbdev is NULL!\n");
+		return -EINVAL;
+	}
+
+	table = ion_sg_table(fbdev->ion_client, fbdev->ion_handle);
+	if ((table == NULL) || (vma == NULL)) {
+		DRM_ERROR("table or vma is NULL!\n");
+		return -EFAULT;
+	}
+
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+
+	addr = vma->vm_start;
+	offset = vma->vm_pgoff * PAGE_SIZE;
+	size = vma->vm_end - vma->vm_start;
+
+	if (size > info->fix.smem_len) {
+		DRM_ERROR("size=%lu is out of range(%u)!\n", size, info->fix.smem_len);
+		return -EFAULT;
+	}
+
+	for_each_sg(table->sgl, sg, table->nents, i) {
+		page = sg_page(sg);
+		remainder = vma->vm_end - addr;
+		len = sg->length;
+
+		if (offset >= sg->length) {
+			offset -= sg->length;
+			continue;
+		} else if (offset) {
+			page += offset / PAGE_SIZE;
+			len = sg->length - offset;
+			offset = 0;
+		}
+		len = min(len, remainder);
+		ret = remap_pfn_range(vma, addr, page_to_pfn(page), len,
+			vma->vm_page_prot);
+		if (ret != 0) {
+			DRM_ERROR("failed to remap_pfn_range! ret=%d\n", ret);
+		}
+
+		addr += len;
+		if (addr >= vma->vm_end)
+			return 0;
+	}
+
+	return 0;
+}
+
+static int kirin_dmabuf_export(struct fb_info *info, void __user *argp)
+{
+	int ret;
+	struct drm_fb_helper *helper;
+	struct kirin_fbdev *fbdev;
+	struct fb_dmabuf_export dmabuf_export;
+
+	helper = (struct drm_fb_helper *)info->par;
+	fbdev = to_kirin_fbdev(helper);
+
+	ret = copy_from_user(&dmabuf_export, argp, sizeof(struct fb_dmabuf_export));
+	if (ret) {
+		DRM_ERROR("copy for user failed!ret=%d.\n", ret);
+		ret = -EINVAL;
+	} else {
+		dmabuf_export.flags = 0;
+		dmabuf_export.fd = ion_share_dma_buf_fd(fbdev->ion_client, fbdev->ion_handle);
+		if (dmabuf_export.fd < 0) {
+			DRM_ERROR("failed to ion_share!\n");
+		}
+
+		ret = copy_to_user(argp, &dmabuf_export, sizeof(struct fb_dmabuf_export));
+		if (ret) {
+			DRM_ERROR("copy to user failed!ret=%d.", ret);
+			ret = -EFAULT;
+		}
+	}
+
+	return ret;
+}
+
+static int kirin_dss_online_compose(struct fb_info *info, void __user *argp)
+{
+	int ret;
+	struct drm_fb_helper *helper;
+	struct kirin_drm_private *priv;
+	struct drm_plane *plane;
+
+	struct drm_dss_layer layer;
+
+	helper = (struct drm_fb_helper *)info->par;
+	priv = helper->dev->dev_private;
+	plane =priv->crtc[0]->primary;
+
+	ret = copy_from_user(&layer, argp, sizeof(struct drm_dss_layer));
+	if (ret) {
+		DRM_ERROR("copy for user failed!ret=%d.\n", ret);
+		return -EINVAL;
+	}
+
+	hisi_dss_online_play(plane, &layer);
+
+	return ret;
+}
+
+static int kirin_fb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOSYS;
+	void __user *argp = (void __user *)arg;
+
+	if (NULL == info) {
+		DRM_ERROR("info is NULL!\n");
+		return -EINVAL;
+	}
+
+	switch (cmd) {
+	case FBIOGET_DMABUF:
+		ret = kirin_dmabuf_export(info, argp);
+		break;
+	case HISI_DRM_ONLINE_PLAY:
+		ret = kirin_dss_online_compose(info, argp);
+		break;
+	default:
+		break;
+	}
+
+	if (ret == -ENOSYS)
+		DRM_ERROR("unsupported ioctl (%x)\n", cmd);
+
+	return ret;
+}
+
+
+static struct fb_ops kirin_fb_ops = {
+	.owner = THIS_MODULE,
+
+	/* Note: to properly handle manual update displays, we wrap the
+	 * basic fbdev ops which write to the framebuffer
+	 */
+	.fb_read = drm_fb_helper_sys_read,
+	.fb_write = drm_fb_helper_sys_write,
+	.fb_fillrect = drm_fb_helper_sys_fillrect,
+	.fb_copyarea = drm_fb_helper_sys_copyarea,
+	.fb_imageblit = drm_fb_helper_sys_imageblit,
+	.fb_mmap = kirin_fbdev_mmap,
+
+	.fb_check_var = drm_fb_helper_check_var,
+	.fb_set_par = drm_fb_helper_set_par,
+	.fb_pan_display = drm_fb_helper_pan_display,
+	.fb_blank = drm_fb_helper_blank,
+	.fb_setcmap = drm_fb_helper_setcmap,
+
+	.fb_ioctl = kirin_fb_ioctl,
+	.fb_compat_ioctl = kirin_fb_ioctl,
+};
+
+static int kirin_fbdev_create(struct drm_fb_helper *helper,
+		struct drm_fb_helper_surface_size *sizes)
+{
+	struct kirin_fbdev *fbdev = to_kirin_fbdev(helper);
+	struct drm_device *dev = helper->dev;
+	struct drm_framebuffer *fb = NULL;
+	struct fb_info *fbi = NULL;
+	struct drm_mode_fb_cmd2 mode_cmd = {0};
+	int ret, size;
+	unsigned int bytes_per_pixel;
+
+	DRM_DEBUG("create fbdev: %dx%d@%d (%dx%d)\n", sizes->surface_width,
+			sizes->surface_height, sizes->surface_bpp,
+			sizes->fb_width, sizes->fb_height);
+
+	mode_cmd.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
+			sizes->surface_depth);
+
+	mode_cmd.width = sizes->surface_width;
+	mode_cmd.height = sizes->surface_height * FBDEV_BUFFER_NUM;
+
+	bytes_per_pixel = DIV_ROUND_UP(sizes->surface_bpp, 8);
+	mode_cmd.pitches[0] = sizes->surface_width * bytes_per_pixel;
+	//mode_cmd.pitches[0] = align_pitch(mode_cmd.width, sizes->surface_bpp);
+
+	/* allocate backing bo */
+	size = mode_cmd.pitches[0] * mode_cmd.height;
+	DRM_DEBUG("allocating %d bytes for fb %d", size, dev->primary->index);
+
+	fb = kirin_framebuffer_init(dev, &mode_cmd);
+	if (IS_ERR(fb)) {
+		dev_err(dev->dev, "failed to allocate fb\n");
+		/* note: if fb creation failed, we can't rely on fb destroy
+		 * to unref the bo:
+		 */
+		ret = PTR_ERR(fb);
+		goto fail;
+	}
+
+	mutex_lock(&dev->struct_mutex);
+
+	fbdev->ion_client = NULL;
+	fbdev->ion_handle = NULL;
+	fbdev->screen_base = NULL;
+	fbdev->smem_start = 0;
+	fbdev->screen_size = 0;
+	memset(&fbdev->iommu_format, 0, sizeof(struct iommu_map_format));
+
+	kirin_alloc_fb_buffer(fbdev, size);
+
+	fbi = drm_fb_helper_alloc_fbi(helper);
+	if (IS_ERR(fbi)) {
+		dev_err(dev->dev, "failed to allocate fb info\n");
+		ret = PTR_ERR(fbi);
+		goto fail_unlock;
+	}
+
+	DRM_DEBUG("fbi=%p, dev=%p", fbi, dev);
+
+	fbdev->fb = fb;
+	helper->fb = fb;
+
+	fbi->par = helper;
+	fbi->flags = FBINFO_DEFAULT;
+	fbi->fbops = &kirin_fb_ops;
+
+	strcpy(fbi->fix.id, "dss");
+
+	drm_fb_helper_fill_fix(fbi, fb->pitches[0], fb->depth);
+	drm_fb_helper_fill_var(fbi, helper, sizes->fb_width, sizes->fb_height);
+
+	dev->mode_config.fb_base = fbdev->smem_start;
+	fbi->screen_base = fbdev->screen_base;
+	fbi->screen_size = fbdev->screen_size;
+	fbi->fix.smem_start = fbdev->smem_start;
+	fbi->fix.smem_len = fbdev->screen_size;
+
+	DRM_DEBUG("par=%p, %dx%d", fbi->par, fbi->var.xres, fbi->var.yres);
+	DRM_DEBUG("allocated %dx%d fb", fbdev->fb->width, fbdev->fb->height);
+
+	mutex_unlock(&dev->struct_mutex);
+
+	return 0;
+
+fail_unlock:
+	mutex_unlock(&dev->struct_mutex);
+fail:
+	if (ret) {
+		if (fb) {
+			drm_framebuffer_unregister_private(fb);
+			drm_framebuffer_remove(fb);
+		}
+	}
+	return ret;
+}
+
+static const struct drm_fb_helper_funcs kirin_fb_helper_funcs = {
+	.fb_probe = kirin_fbdev_create,
+};
+
+/* initialize fbdev helper */
+struct drm_fb_helper *kirin_drm_fbdev_init(struct drm_device *dev)
+{
+	struct kirin_drm_private *priv = dev->dev_private;
+	struct kirin_fbdev *fbdev = NULL;
+	struct drm_fb_helper *helper;
+	int ret;
+
+	fbdev = kzalloc(sizeof(*fbdev), GFP_KERNEL);
+	if (!fbdev)
+		goto fail;
+
+	priv->fb_helper = helper = &fbdev->fb_helper;
+
+	drm_fb_helper_prepare(dev, helper, &kirin_fb_helper_funcs);
+
+	DRM_INFO("num_crtc=%d, num_connector=%d.\n",
+		dev->mode_config.num_crtc, dev->mode_config.num_connector);
+
+	ret = drm_fb_helper_init(dev, helper,
+			dev->mode_config.num_crtc, dev->mode_config.num_connector);
+	if (ret) {
+		dev_err(dev->dev, "could not init fbdev: ret=%d\n", ret);
+		goto fail;
+	}
+
+	ret = drm_fb_helper_single_add_all_connectors(helper);
+	if (ret)
+		goto fini;
+
+	/* disable all the possible outputs/crtcs before entering KMS mode */
+	drm_helper_disable_unused_functions(dev);
+
+	ret = drm_fb_helper_initial_config(helper, 32);
+	if (ret)
+		goto fini;
+
+	priv->fbdev = helper;
+
+	return helper;
+
+fini:
+	drm_fb_helper_fini(helper);
+fail:
+	kfree(fbdev);
+	return NULL;
+}
+
+void kirin_drm_fbdev_fini(struct drm_device *dev)
+{
+	struct kirin_drm_private *priv = dev->dev_private;
+	struct drm_fb_helper *helper = priv->fbdev;
+	struct kirin_fbdev *fbdev;
+
+	drm_fb_helper_unregister_fbi(helper);
+	drm_fb_helper_release_fbi(helper);
+
+	drm_fb_helper_fini(helper);
+
+	fbdev = to_kirin_fbdev(priv->fbdev);
+
+	/* this will free the backing object */
+	if (fbdev->fb) {
+		drm_framebuffer_unregister_private(fbdev->fb);
+		drm_framebuffer_remove(fbdev->fb);
+	}
+
+	kfree(fbdev);
+
+	priv->fbdev = NULL;
+}
-- 
2.26.2

