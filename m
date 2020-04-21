Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE471B1C84
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgDUDWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:22:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:51502 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgDUDWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 23:22:43 -0400
IronPort-SDR: 3fRa5OAGhwalY/XuyLkbg3axvIY7+9CD3xEX4BskcC8v9hgbnshZAK1uYRoJaO7X6fmRWH7DEl
 6mV67Fn9sTJQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 20:22:06 -0700
IronPort-SDR: V6WRdNmUbSWk8JuvWd6Y/6EYKhyxVEH9kp2Vk7iBQuC0Xug0p3boXHxFsiSiuW7ggoPtuIC9ZE
 cuv4u/Sh0z6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="290315724"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2020 20:22:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jack Ping CHNG <jack.ping.chng@linux.intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 1/1] gwdpa: gswip: Introduce Gigabit Ethernet Switch (GSWIP) device driver
Date:   Mon, 20 Apr 2020 20:22:02 -0700
Message-Id: <20200421032202.3293500-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jack Ping CHNG <jack.ping.chng@linux.intel.com>

This driver enables the Intel's LGM SoC GSWIP block. GSWIP is a core module
tailored for L2/L3/L4+ data plane and QoS functions. It allows CPUs and
other accelerators connected to the SoC datapath to enqueue and dequeue
packets through DMAs. Most configuration values are stored in tables
such as Parsing and Classification Engine tables, Buffer Manager tables
and Pseudo MAC tables.

Signed-off-by: Jack Ping CHNG <jack.ping.chng@linux.intel.com>
Signed-off-by: Amireddy Mallikarjuna reddy <mallikarjunax.reddy@linux.intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/Kconfig            |  11 +
 drivers/net/ethernet/intel/Makefile           |   1 +
 drivers/net/ethernet/intel/gwdpa/Makefile     |   5 +
 .../net/ethernet/intel/gwdpa/gswip/Makefile   |  10 +
 .../net/ethernet/intel/gwdpa/gswip/gswip.h    | 448 ++++++++++
 .../ethernet/intel/gwdpa/gswip/gswip_core.c   | 804 ++++++++++++++++++
 .../ethernet/intel/gwdpa/gswip/gswip_core.h   |  90 ++
 .../ethernet/intel/gwdpa/gswip/gswip_dev.c    | 178 ++++
 .../ethernet/intel/gwdpa/gswip/gswip_dev.h    |  18 +
 .../ethernet/intel/gwdpa/gswip/gswip_mac.c    | 225 +++++
 .../ethernet/intel/gwdpa/gswip/gswip_port.c   | 330 +++++++
 .../ethernet/intel/gwdpa/gswip/gswip_reg.h    | 491 +++++++++++
 .../ethernet/intel/gwdpa/gswip/gswip_tbl.c    | 332 ++++++++
 .../ethernet/intel/gwdpa/gswip/gswip_tbl.h    | 194 +++++
 drivers/net/ethernet/intel/gwdpa/gswip/lmac.c |  46 +
 .../net/ethernet/intel/gwdpa/gswip/mac_cfg.c  | 524 ++++++++++++
 .../ethernet/intel/gwdpa/gswip/mac_common.h   | 238 ++++++
 .../net/ethernet/intel/gwdpa/gswip/mac_dev.c  | 186 ++++
 .../net/ethernet/intel/gwdpa/gswip/xgmac.c    | 643 ++++++++++++++
 .../net/ethernet/intel/gwdpa/gswip/xgmac.h    | 236 +++++
 20 files changed, 5010 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/gwdpa/Makefile
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/Makefile
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip.h
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.h
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.h
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_mac.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_port.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_reg.h
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.h
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/lmac.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/mac_cfg.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/mac_common.h
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/mac_dev.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/xgmac.c
 create mode 100644 drivers/net/ethernet/intel/gwdpa/gswip/xgmac.h

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index ad34e4335df2..db1c4e7a031f 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -342,4 +342,15 @@ config IGC
 	  To compile this driver as a module, choose M here. The module
 	  will be called igc.
 
+config INTEL_GSWIP
+	tristate "Intel(R) Gigabit Ethernet Switch IP support"
+	default n
+	depends on OF_MDIO
+	help
+	  Turn on this option to build GSWIP driver.
+	  Gigabit Ethernet Switch is a hardware IP in the
+	  Intel Networking SoCs. This driver consists of
+	  core and mac. It is part of the Intel gateway
+	  datapath architecture.
+
 endif # NET_VENDOR_INTEL
diff --git a/drivers/net/ethernet/intel/Makefile b/drivers/net/ethernet/intel/Makefile
index 3075290063f6..ab3281e9bc4c 100644
--- a/drivers/net/ethernet/intel/Makefile
+++ b/drivers/net/ethernet/intel/Makefile
@@ -16,3 +16,4 @@ obj-$(CONFIG_IXGB) += ixgb/
 obj-$(CONFIG_IAVF) += iavf/
 obj-$(CONFIG_FM10K) += fm10k/
 obj-$(CONFIG_ICE) += ice/
+obj-y += gwdpa/
diff --git a/drivers/net/ethernet/intel/gwdpa/Makefile b/drivers/net/ethernet/intel/gwdpa/Makefile
new file mode 100644
index 000000000000..ada65e907601
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for the Intel datapath specific drivers.
+#
+obj-$(CONFIG_INTEL_GSWIP)	+= gswip/
\ No newline at end of file
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/Makefile b/drivers/net/ethernet/intel/gwdpa/gswip/Makefile
new file mode 100644
index 000000000000..548b716d6984
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/Makefile
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for GSWIP
+#
+obj-y += gswip-dev.o gswip-core.o gswip-mac.o
+
+gswip-dev-y := gswip_dev.o
+gswip-core-y := gswip_core.o gswip_port.o gswip_tbl.o
+gswip-mac-y := mac_dev.o mac_cfg.o gswip_mac.o xgmac.o lmac.o
+
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip.h b/drivers/net/ethernet/intel/gwdpa/gswip/gswip.h
new file mode 100644
index 000000000000..1e8b4b5b146a
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip.h
@@ -0,0 +1,448 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2016-2019 Intel Corporation. */
+#ifndef _DATAPATH_GSWIP_H_
+#define _DATAPATH_GSWIP_H_
+
+#include <linux/device.h>
+#include <linux/bits.h>
+
+#define BR_PORT_MAP_NUM		16
+#define PMAC_BSL_THRES_NUM	3
+#define PMAC_HEADER_NUM		8
+
+enum gswip_cpu_parser_hdr_cfg {
+	GSWIP_CPU_PARSER_NIL,
+	GSWIP_CPU_PARSER_FLAGS,
+	GSWIP_CPU_PARSER_OFFSETS_FLAGS,
+	GSWIP_CPU_PARSER_RESERVED,
+};
+
+struct gswip_cpu_port_cfg {
+	u8 lpid;
+	bool is_cpu_port;
+	bool spec_tag_ig;
+	bool spec_tag_eg;
+	bool fcs_chk;
+	bool fcs_generate;
+	enum gswip_cpu_parser_hdr_cfg no_mpe_parser_cfg;
+	enum gswip_cpu_parser_hdr_cfg mpe1_parser_cfg;
+	enum gswip_cpu_parser_hdr_cfg mpe2_parser_cfg;
+	enum gswip_cpu_parser_hdr_cfg mpe3_parser_cfg;
+	bool ts_rm_ptp_pkt;
+	bool ts_rm_non_ptp_pkt;
+};
+
+enum gswip_pmac_short_frm_chk {
+	GSWIP_PMAC_SHORT_LEN_DIS,
+	GSWIP_PMAC_SHORT_LEN_ENA_UNTAG,
+	GSWIP_PMAC_SHORT_LEN_ENA_TAG,
+	GSWIP_PMAC_SHORT_LEN_RESERVED,
+};
+
+enum gswip_pmac_proc_flags_eg_cfg {
+	GSWIP_PMAC_PROC_FLAGS_NONE,
+	GSWIP_PMAC_PROC_FLAGS_TC,
+	GSWIP_PMAC_PROC_FLAGS_FLAG,
+	GSWIP_PMAC_PROC_FLAGS_MIX,
+};
+
+struct gswip_pmac_glb_cfg {
+	u8 pmac_id;
+	bool apad_en;
+	bool pad_en;
+	bool vpad_en;
+	bool svpad_en;
+	bool rx_fcs_dis;
+	bool tx_fcs_dis;
+	bool ip_trans_chk_reg_dis;
+	bool ip_trans_chk_ver_dis;
+	bool jumbo_en;
+	u16 max_jumbo_len;
+	u16 jumbo_thresh_len;
+	bool long_frm_chk_dis;
+	enum gswip_pmac_short_frm_chk short_frm_chk_type;
+	bool proc_flags_eg_cfg_en;
+	enum gswip_pmac_proc_flags_eg_cfg proc_flags_eg_cfg;
+	u16 bsl_thresh[PMAC_BSL_THRES_NUM];
+};
+
+struct gswip_pmac_bp_map {
+	u8 pmac_id;
+	u8 tx_dma_chan_id;
+	u32 tx_q_mask;
+	u32 rx_port_mask;
+};
+
+enum gswip_pmac_ig_cfg_src {
+	GSWIP_PMAC_IG_CFG_SRC_DMA_DESC,
+	GSWIP_PMAC_IG_CFG_SRC_DEF_PMAC,
+	GSWIP_PMAC_IG_CFG_SRC_PMAC,
+};
+
+struct gswip_pmac_ig_cfg {
+	u8 pmac_id;
+	u8 tx_dma_chan_id;
+	bool err_pkt_disc;
+	bool class_def;
+	bool class_en;
+	enum gswip_pmac_ig_cfg_src sub_id;
+	bool src_port_id_def;
+	bool pmac_present;
+	u8 def_pmac_hdr[PMAC_HEADER_NUM];
+};
+
+struct gswip_pmac_eg_cfg {
+	u8 pmac_id;
+	u8 dst_port_id;
+	u8 tc;
+	bool mpe1;
+	bool mpe2;
+	bool decrypt;
+	bool encrypt;
+	u8 flow_id_msb;
+	bool process_sel;
+	u8 rx_dma_chan_id;
+	bool rm_l2_hdr;
+	u8 num_byte_rm;
+	bool fcs_en;
+	bool pmac_en;
+	bool redir_en;
+	bool bsl_seg_disable;
+	u8 bsl_tc;
+	bool resv_dw1_en;
+	u8 resv_dw1;
+	bool resv_1dw0_en;
+	u8 resv_1dw0;
+	bool resv_2dw0_en;
+	u8 resv_2dw0;
+	bool tc_en;
+};
+
+struct gswip_lpid2gpid {
+	u16 lpid;
+	u16 first_gpid;
+	u16 num_gpid;
+	u8 valid_bits;
+};
+
+struct gswip_gpid2lpid {
+	u16 gpid;
+	u16 lpid;
+	u8 subif_grp_field;
+	bool subif_grp_field_ovr;
+};
+
+enum gswip_ctp_port_config_mask {
+	GSWIP_CTP_PORT_CONFIG_MASK_BRIDGE_PORT_ID	= BIT(0),
+	GSWIP_CTP_PORT_CONFIG_MASK_FORCE_TRAFFIC_CLASS	= BIT(1),
+	GSWIP_CTP_PORT_CONFIG_MASK_INGRESS_VLAN		= BIT(2),
+	GSWIP_CTP_PORT_CONFIG_MASK_INGRESS_VLAN_IGMP	= BIT(3),
+	GSWIP_CTP_PORT_CONFIG_MASK_EGRESS_VLAN		= BIT(4),
+	GSWIP_CTP_PORT_CONFIG_MASK_EGRESS_VLAN_IGMP	= BIT(5),
+	GSWIP_CTP_PORT_CONFIG_MASK_INRESS_NTO1_VLAN	= BIT(6),
+	GSWIP_CTP_PORT_CONFIG_MASK_EGRESS_NTO1_VLAN	= BIT(7),
+	GSWIP_CTP_PORT_CONFIG_INGRESS_MARKING		= BIT(8),
+	GSWIP_CTP_PORT_CONFIG_EGRESS_MARKING		= BIT(9),
+	GSWIP_CTP_PORT_CONFIG_EGRESS_MARKING_OVERRIDE	= BIT(10),
+	GSWIP_CTP_PORT_CONFIG_EGRESS_REMARKING		= BIT(11),
+	GSWIP_CTP_PORT_CONFIG_INGRESS_METER		= BIT(12),
+	GSWIP_CTP_PORT_CONFIG_EGRESS_METER		= BIT(13),
+	GSWIP_CTP_PORT_CONFIG_BRIDGING_BYPASS		= BIT(14),
+	GSWIP_CTP_PORT_CONFIG_FLOW_ENTRY		= BIT(15),
+	GSWIP_CTP_PORT_CONFIG_LOOPBACK_AND_MIRROR	= BIT(16),
+	GSWIP_CTP_PORT_CONFIG_MASK_FORCE		= BIT(31),
+};
+
+struct gswip_ctp_port_cfg {
+	u8 lpid;
+	u16 subif_id_grp;
+	u16 br_pid;
+	enum gswip_ctp_port_config_mask mask;
+	bool br_bypass;
+};
+
+enum gswip_lport_mode {
+	GSWIP_LPORT_8BIT_WLAN,
+	GSWIP_LPORT_9BIT_WLAN,
+	GSWIP_LPORT_GPON,
+	GSWIP_LPORT_EPON,
+	GSWIP_LPORT_GINT,
+	GSWIP_LPORT_OTHER = 0xFF,
+};
+
+struct gswip_ctp_port_info {
+	u8 lpid;
+	u16 first_pid;
+	u16 num_port;
+	enum gswip_lport_mode mode;
+	u16 br_pid;
+};
+
+enum gswip_br_port_cfg_mask {
+	GSWIP_BR_PORT_CFG_MASK_BR_ID			= BIT(0),
+	GSWIP_BR_PORT_CFG_MASK_IG_VLAN			= BIT(1),
+	GSWIP_BR_PORT_CFG_MASK_EG_VLAN			= BIT(2),
+	GSWIP_BR_PORT_CFG_MASK_IG_MARKING		= BIT(3),
+	GSWIP_BR_PORT_CFG_MASK_EG_REMARKING		= BIT(4),
+	GSWIP_BR_PORT_CFG_MASK_IG_METER			= BIT(5),
+	GSWIP_BR_PORT_CFG_MASK_EG_SUB_METER		= BIT(6),
+	GSWIP_BR_PORT_CFG_MASK_EG_CTP_MAPPING		= BIT(7),
+	GSWIP_BR_PORT_CFG_MASK_BR_PORT_MAP		= BIT(8),
+	GSWIP_BR_PORT_CFG_MASK_MCAST_DST_IP_LOOKUP	= BIT(9),
+	GSWIP_BR_PORT_CFG_MASK_MCAST_SRC_IP_LOOKUP	= BIT(10),
+	GSWIP_BR_PORT_CFG_MASK_MCAST_DST_MAC_LOOKUP	= BIT(11),
+	GSWIP_BR_PORT_CFG_MASK_MCAST_SRC_MAC_LEARNING	= BIT(12),
+	GSWIP_BR_PORT_CFG_MASK_MAC_SPOOFING		= BIT(13),
+	GSWIP_BR_PORT_CFG_MASK_PORT_LOCK		= BIT(14),
+	GSWIP_BR_PORT_CFG_MASK_MAC_LEARNING_LIMIT	= BIT(15),
+	GSWIP_BR_PORT_CFG_MASK_MAC_LEARNED_COUNT	= BIT(16),
+	GSWIP_BR_PORT_CFG_MASK_IG_VLAN_FILTER		= BIT(17),
+	GSWIP_BR_PORT_CFG_MASK_EG_VLAN_FILTER1		= BIT(18),
+	GSWIP_BR_PORT_CFG_MASK_EG_VLAN_FILTER2		= BIT(19),
+	GSWIP_BR_PORT_CFG_MASK_FORCE			= BIT(31),
+};
+
+enum gswip_pmapper_mapping_mode {
+	GSWIP_PMAPPER_MAPPING_PCP,
+	GSWIP_PMAPPER_MAPPING_DSCP,
+};
+
+enum gswip_br_port_eg_meter {
+	GSWIP_BR_PORT_EG_METER_BROADCAST,
+	GSWIP_BR_PORT_EG_METER_MULTICAST,
+	GSWIP_BR_PORT_EG_METER_UNKNOWN_MCAST_IP,
+	GSWIP_BR_PORT_EG_METER_UNKNOWN_MCAST_NON_IP,
+	GSWIP_BR_PORT_EG_METER_UNKNOWN_UCAST,
+	GSWIP_BR_PORT_EG_METER_OTHERS,
+	GSWIP_BR_PORT_EG_METER_MAX,
+};
+
+struct gswip_br_port_alloc {
+	u8 br_id;
+	u8 br_pid;
+};
+
+enum gswip_br_cfg_mask {
+	GSWIP_BR_CFG_MASK_MAC_LEARNING_LIMIT	= BIT(0),
+	GSWIP_BR_CFG_MASK_MAC_LEARNED_COUNT	= BIT(1),
+	GSWIP_BR_CFG_MASK_MAC_DISCARD_COUNT	= BIT(2),
+	GSWIP_BR_CFG_MASK_SUB_METER		= BIT(3),
+	GSWIP_BR_CFG_MASK_FORWARDING_MODE	= BIT(4),
+	GSWIP_BR_CFG_MASK_FORCE			= BIT(31),
+};
+
+enum gswip_br_fwd_mode {
+	GSWIP_BR_FWD_FLOOD,
+	GSWIP_BR_FWD_DISCARD,
+	GSWIP_BR_FWD_CPU,
+};
+
+struct gswip_br_alloc {
+	u8 br_id;
+};
+
+struct gswip_br_cfg {
+	u8 br_id;
+	enum gswip_br_cfg_mask mask;
+	bool mac_lrn_limit_en;
+	u16 mac_lrn_limit;
+	u16 mac_lrn_count;
+	u32 lrn_disc_event;
+	enum gswip_br_fwd_mode fwd_bcast;
+	enum gswip_br_fwd_mode fwd_unk_mcast_ip;
+	enum gswip_br_fwd_mode fwd_unk_mcast_non_ip;
+	enum gswip_br_fwd_mode fwd_unk_ucast;
+};
+
+struct gswip_qos_wred_q_cfg {
+	u8 qid;
+	u16 red_min;
+	u16 red_max;
+	u16 yellow_min;
+	u16 yellow_max;
+	u16 green_min;
+	u16 green_max;
+};
+
+struct gswip_qos_wred_port_cfg {
+	u8 lpid;
+	u16 red_min;
+	u16 red_max;
+	u16 yellow_min;
+	u16 yellow_max;
+	u16 green_min;
+	u16 green_max;
+};
+
+enum gswip_qos_q_map_mode {
+	GSWIP_QOS_QMAP_SINGLE_MD,
+	GSWIP_QOS_QMAP_SUBIFID_MD,
+};
+
+struct gswip_qos_q_port {
+	u8 lpid;
+	bool extration_en;
+	enum gswip_qos_q_map_mode q_map_mode;
+	u8 tc_id;
+	u8 qid;
+	bool egress;
+	u8 redir_port_id;
+	bool en_ig_pce_bypass;
+	bool resv_port_mode;
+};
+
+struct gswip_register {
+	u16 offset;
+	u16 data;
+};
+
+enum {
+	SPEED_LMAC_10M,
+	SPEED_LMAC_100M,
+	SPEED_LMAC_200M,
+	SPEED_LMAC_1G,
+	SPEED_XGMAC_10M,
+	SPEED_XGMAC_100M,
+	SPEED_XGMAC_1G,
+	SPEED_XGMII_25G,
+	SPEED_XGMAC_5G,
+	SPEED_XGMAC_10G,
+	SPEED_GMII_25G,
+	SPEED_MAC_AUTO,
+};
+
+enum gsw_portspeed {
+	/* 10 Mbit/s */
+	GSW_PORT_SPEED_10 = 10,
+
+	/* 100 Mbit/s */
+	GSW_PORT_SPEED_100 = 100,
+
+	/* 200 Mbit/s */
+	GSW_PORT_SPEED_200 = 200,
+
+	/* 1000 Mbit/s */
+	GSW_PORT_SPEED_1000 = 1000,
+
+	/* 2.5 Gbit/s */
+	GSW_PORT_SPEED_25000 = 25000,
+
+	/* 10 Gbit/s */
+	GSW_PORT_SPEED_100000 = 100000,
+};
+
+enum gsw_portlink_status {
+	LINK_AUTO,
+	LINK_UP,
+	LINK_DOWN,
+};
+
+enum gsw_flow_control_modes {
+	FC_AUTO,
+	FC_RX,
+	FC_TX,
+	FC_RXTX,
+	FC_DIS,
+	FC_INVALID,
+};
+
+/* Ethernet port interface mode. */
+enum gsw_mii_mode {
+	/* Normal PHY interface (twisted pair), use internal MII Interface */
+	GSW_PORT_HW_MII,
+
+	/* Reduced MII interface in normal mode */
+	GSW_PORT_HW_RMII,
+
+	/* GMII or MII, depending upon the speed */
+	GSW_PORT_HW_GMII,
+
+	/* RGMII mode */
+	GSW_PORT_HW_RGMII,
+
+	/* XGMII mode */
+	GSW_PORT_HW_XGMII,
+};
+
+struct core_common_ops {
+	int (*enable)(struct device *dev, bool enable);
+	int (*cpu_port_cfg_get)(struct device *dev,
+				struct gswip_cpu_port_cfg *cpu);
+	int (*reg_get)(struct device *dev, struct gswip_register *param);
+	int (*reg_set)(struct device *dev, struct gswip_register *param);
+};
+
+struct core_pmac_ops {
+	int (*gbl_cfg_set)(struct device *dev, struct gswip_pmac_glb_cfg *pmac);
+	int (*bp_map_get)(struct device *dev, struct gswip_pmac_bp_map *bp);
+	int (*ig_cfg_set)(struct device *dev, struct gswip_pmac_ig_cfg *ig);
+	int (*eg_cfg_set)(struct device *dev, struct gswip_pmac_eg_cfg *eg);
+};
+
+struct core_gpid_ops {
+	int (*lpid2gpid_set)(struct device *dev,
+			     struct gswip_lpid2gpid *lp2gp);
+	int (*lpid2gpid_get)(struct device *dev,
+			     struct gswip_lpid2gpid *lp2gp);
+	int (*gpid2lpid_set)(struct device *dev,
+			     struct gswip_gpid2lpid *gp2lp);
+	int (*gpid2lpid_get)(struct device *dev,
+			     struct gswip_gpid2lpid *gp2lp);
+};
+
+struct core_ctp_ops {
+	int (*alloc)(struct device *dev, struct gswip_ctp_port_info *ctp);
+	int (*free)(struct device *dev, u8 lpid);
+};
+
+struct core_br_port_ops {
+	int (*alloc)(struct device *dev, struct gswip_br_port_alloc *bp);
+	int (*free)(struct device *dev, struct gswip_br_port_alloc *bp);
+};
+
+struct core_br_ops {
+	int (*alloc)(struct device *dev, struct gswip_br_alloc *br);
+	int (*free)(struct device *dev, struct gswip_br_alloc *br);
+};
+
+struct core_qos_ops {
+	int (*q_port_set)(struct device *dev, struct gswip_qos_q_port *qport);
+	int (*wred_q_cfg_set)(struct device *dev,
+			      struct gswip_qos_wred_q_cfg *wredq);
+	int (*wred_port_cfg_set)(struct device *dev,
+				 struct gswip_qos_wred_port_cfg *wredp);
+};
+
+struct gsw_mac_ops {
+	/* Initialize MAC */
+	int (*init)(struct device *dev);
+
+	int (*set_macaddr)(struct device *dev, u8 *mac_addr);
+	int (*get_link_sts)(struct device *dev);
+
+	int (*get_duplex)(struct device *dev);
+
+	int (*set_speed)(struct device *dev, u8 speed);
+	int (*get_speed)(struct device *dev);
+
+	u32 (*get_mtu)(struct device *dev);
+	int (*set_mtu)(struct device *dev, u32 mtu);
+
+	u32 (*get_flowctrl)(struct device *dev);
+	int (*set_flowctrl)(struct device *dev, u32 val);
+
+	int (*get_pfsa)(struct device *dev, u8 *addr, u32 *mode);
+	int (*set_pfsa)(struct device *dev, u8 *mac_addr, u32 macif);
+
+	int (*get_mii_if)(struct device *dev);
+	int (*set_mii_if)(struct device *dev, u32 mii_mode);
+
+	u32 (*get_lpi)(struct device *dev);
+
+	int (*get_fcsgen)(struct device *dev);
+};
+
+struct gsw_adap_ops {
+	int (*sw_core_enable)(struct device *dev, u32 val);
+};
+#endif
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.c b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.c
new file mode 100644
index 000000000000..164840beaae4
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.c
@@ -0,0 +1,804 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation. */
+
+#include <asm/unaligned.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of_platform.h>
+
+#include "gswip_core.h"
+#include "gswip_dev.h"
+#include "gswip_reg.h"
+#include "gswip_tbl.h"
+#include "mac_common.h"
+
+#define GSWIP_VER		0x32
+
+/* TX DMA channels for PMAC0 to PMAC2 */
+#define PMAC0_TX_DMACHID_START	0
+#define PMAC0_TX_DMACHID_END	16
+#define PMAC1_TX_DMACHID_START	0
+#define PMAC1_TX_DMACHID_END	16
+#define PMAC2_TX_DMACHID_START	0
+#define PMAC2_TX_DMACHID_END	16
+
+#define MAX_JUMBO_FRM_LEN	10000
+
+/* Data Protocol Unit (DPU) */
+enum dpu {
+	DPU,
+	NON_DPU,
+};
+
+enum queue_id {
+	QUEUE0,
+	QUEUE1,
+	QUEUE2,
+	QUEUE3,
+	QUEUE4,
+	QUEUE5,
+	QUEUE6,
+	QUEUE7,
+	QUEUE8,
+	QUEUE9,
+	QUEUE10,
+};
+
+enum traffic_class {
+	TC0,
+	TC1,
+	TC2,
+	TC3,
+	TC_MAX,
+};
+
+struct eg_pce_bypass_path {
+	/* egress logical port id */
+	u8 eg_pid;
+	/* local extracted */
+	bool ext;
+	/* queue id */
+	u8 qid;
+	/* redirect logical port id */
+	u8 redir_pid;
+};
+
+struct ig_pce_bypass_path {
+	/* ingress logical port id */
+	u8 ig_pid;
+	/* local extracted */
+	bool ext;
+	/* traffic class */
+	u8 tc_start;
+	u8 tc_end;
+	/* queue id */
+	u8 qid;
+	/* redirect logical port id */
+	u8 redir_pid;
+};
+
+/* default GSWIP egress PCE bypass path Q-map */
+static struct eg_pce_bypass_path eg_pce_byp_path[] = {
+	{MAC2,  false, QUEUE0, MAC2 },
+	{MAC3,  false, QUEUE1, MAC3 },
+	{MAC4,  false, QUEUE2, MAC4 },
+	{MAC5,  false, QUEUE3, MAC5 },
+	{MAC6,  false, QUEUE4, MAC6 },
+	{MAC7,  false, QUEUE5, MAC7 },
+	{MAC8,  false, QUEUE6, MAC8 },
+	{MAC9,  false, QUEUE7, MAC9 },
+	{MAC10, false, QUEUE8, MAC10},
+};
+
+/* default GSWIP ingress PCE bypass path Q-map */
+static struct ig_pce_bypass_path ig_pce_byp_path[] = {
+	{PMAC0, false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC2,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC3,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC4,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC5,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC6,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC7,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC8,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC9,  false, TC0, TC_MAX, QUEUE10, PMAC2},
+	{MAC10, false, TC0, TC_MAX, QUEUE10, PMAC2},
+};
+
+static inline int pmac_ig_cfg(struct gswip_core_priv *priv, u8 pmac_id, u8 dpu)
+{
+	const struct core_pmac_ops *pmac_ops =  priv->ops.pmac_ops;
+	u8 start[] = { PMAC0_TX_DMACHID_START,
+		       PMAC1_TX_DMACHID_START,
+		       PMAC2_TX_DMACHID_START };
+	u8 end[] = { PMAC0_TX_DMACHID_END,
+		     PMAC1_TX_DMACHID_END,
+		     PMAC2_TX_DMACHID_END };
+	u8 pmac[] = { PMAC0, PMAC1, PMAC2 };
+	struct gswip_pmac_ig_cfg ig_cfg = {0};
+	int i, ret;
+
+	ig_cfg.pmac_id = pmac_id;
+	ig_cfg.err_pkt_disc = true;
+	ig_cfg.class_en = true;
+
+	for (i = start[pmac_id]; i < end[pmac_id]; i++) {
+		ig_cfg.tx_dma_chan_id = i;
+		ig_cfg.def_pmac_hdr[2] = FIELD_PREP(PMAC_IGCFG_HDR_ID,
+						    pmac[pmac_id]);
+
+		ret = pmac_ops->ig_cfg_set(priv->dev, &ig_cfg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static inline int pmac_eg_cfg(struct gswip_core_priv *priv, u8 pmac_id, u8 dpu)
+{
+	const struct core_pmac_ops *pmac_ops =  priv->ops.pmac_ops;
+	struct gswip_pmac_eg_cfg pmac_eg = {0};
+
+	pmac_eg.pmac_id = pmac_id;
+	pmac_eg.pmac_en = true;
+	pmac_eg.bsl_seg_disable = true;
+
+	return pmac_ops->eg_cfg_set(priv->dev, &pmac_eg);
+}
+
+static inline int pmac_glbl_cfg(struct gswip_core_priv *priv, u8 pmac_id)
+{
+	const struct core_pmac_ops *pmac_ops =  priv->ops.pmac_ops;
+	struct gswip_pmac_glb_cfg pmac_cfg = {0};
+
+	pmac_cfg.pmac_id = pmac_id;
+	pmac_cfg.rx_fcs_dis = true;
+	pmac_cfg.jumbo_en = true;
+	pmac_cfg.max_jumbo_len = MAX_JUMBO_FRM_LEN;
+	pmac_cfg.long_frm_chk_dis = true;
+	pmac_cfg.short_frm_chk_type = GSWIP_PMAC_SHORT_LEN_ENA_UNTAG;
+	pmac_cfg.proc_flags_eg_cfg_en = true;
+	pmac_cfg.proc_flags_eg_cfg = GSWIP_PMAC_PROC_FLAGS_MIX;
+
+	return pmac_ops->gbl_cfg_set(priv->dev, &pmac_cfg);
+}
+
+static int gswip_core_pmac_init_nondpu(struct gswip_core_priv *priv)
+{
+	int i, ret;
+
+	for (i = 0; i < priv->num_pmac; i++) {
+		ret = pmac_glbl_cfg(priv, i);
+		if (ret)
+			return ret;
+
+		ret = pmac_ig_cfg(priv, i, NON_DPU);
+		if (ret)
+			return ret;
+
+		ret = pmac_eg_cfg(priv, i, NON_DPU);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int gswip_core_set_def_eg_pce_bypass_qmap(struct gswip_core_priv *priv,
+						 enum gswip_qos_q_map_mode mode)
+{
+	const struct core_qos_ops *qos_ops =  priv->ops.qos_ops;
+	int num_elem = ARRAY_SIZE(eg_pce_byp_path);
+	struct gswip_qos_q_port q_map = {0};
+	int i, ret;
+
+	q_map.egress = true;
+	q_map.q_map_mode = mode;
+
+	for (i = 0; i < num_elem; i++) {
+		q_map.lpid = eg_pce_byp_path[i].eg_pid;
+		q_map.extration_en = eg_pce_byp_path[i].ext;
+		q_map.qid = eg_pce_byp_path[i].qid;
+		q_map.redir_port_id = eg_pce_byp_path[i].redir_pid;
+
+		ret = qos_ops->q_port_set(priv->dev, &q_map);
+		if (ret)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int gswip_core_set_def_ig_pce_bypass_qmap(struct gswip_core_priv *priv)
+{
+	const struct core_qos_ops *qos_ops =  priv->ops.qos_ops;
+	int num_elem = ARRAY_SIZE(ig_pce_byp_path);
+	struct gswip_qos_q_port q_map = {0};
+	int i, j, ret;
+
+	q_map.en_ig_pce_bypass = true;
+
+	for (i = 0; i < num_elem; i++) {
+		for (j = ig_pce_byp_path[i].tc_start;
+		     j < ig_pce_byp_path[i].tc_end; j++) {
+			q_map.lpid = ig_pce_byp_path[i].ig_pid;
+			q_map.qid = ig_pce_byp_path[i].qid;
+			q_map.redir_port_id = ig_pce_byp_path[i].redir_pid;
+			q_map.tc_id = j;
+
+			ret = qos_ops->q_port_set(priv->dev, &q_map);
+			if (ret)
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static inline u16 pmac_reg(u16 offset, u8 id)
+{
+	u16 pmac_offset[] = { 0, PMAC_REG_OFFSET_1, PMAC_REG_OFFSET_2 };
+
+	return offset += pmac_offset[id];
+}
+
+/* PMAC global configuration */
+static int gswip_pmac_glb_cfg_set(struct device *dev,
+				  struct gswip_pmac_glb_cfg *pmac)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 bsl_reg[] = { PMAC_BSL_LEN0, PMAC_BSL_LEN1, PMAC_BSL_LEN2 };
+	u16 ctrl_reg[] = { PMAC_CTRL_0, PMAC_CTRL_1,
+			   PMAC_CTRL_2, PMAC_CTRL_4 };
+	u16 ctrl[PMAC_CTRL_NUM] = {0};
+	u8 id;
+	int i;
+
+	if (pmac->pmac_id >= priv->num_pmac) {
+		dev_err(priv->dev, "Invalid pmac id %d\n", pmac->pmac_id);
+		return -EINVAL;
+	}
+
+	ctrl[0] = FIELD_PREP(PMAC_CTRL_0_FCSEN, pmac->rx_fcs_dis) |
+		  FIELD_PREP(PMAC_CTRL_0_APADEN, pmac->apad_en) |
+		  FIELD_PREP(PMAC_CTRL_0_VPAD2EN, pmac->svpad_en) |
+		  FIELD_PREP(PMAC_CTRL_0_VPADEN, pmac->vpad_en) |
+		  FIELD_PREP(PMAC_CTRL_0_PADEN, pmac->pad_en) |
+		  FIELD_PREP(PMAC_CTRL_0_FCS, pmac->tx_fcs_dis) |
+		  FIELD_PREP(PMAC_CTRL_0_CHKREG, pmac->ip_trans_chk_reg_dis) |
+		  FIELD_PREP(PMAC_CTRL_0_CHKVER, pmac->ip_trans_chk_ver_dis);
+
+	if (pmac->jumbo_en) {
+		ctrl[1] = pmac->max_jumbo_len,
+		ctrl[2] = FIELD_PREP(PMAC_CTRL_2_MLEN, 1);
+	}
+
+	ctrl[2] |= FIELD_PREP(PMAC_CTRL_2_LCHKL, pmac->long_frm_chk_dis);
+
+	switch (pmac->short_frm_chk_type) {
+	case GSWIP_PMAC_SHORT_LEN_DIS:
+		ctrl[2] |= FIELD_PREP(PMAC_CTRL_2_LCHKS, 0);
+		break;
+
+	case GSWIP_PMAC_SHORT_LEN_ENA_UNTAG:
+		ctrl[2] |= FIELD_PREP(PMAC_CTRL_2_LCHKS, 1);
+		break;
+
+	case GSWIP_PMAC_SHORT_LEN_ENA_TAG:
+		ctrl[2] |= FIELD_PREP(PMAC_CTRL_2_LCHKS, 2);
+		break;
+
+	case GSWIP_PMAC_SHORT_LEN_RESERVED:
+		ctrl[2] |= FIELD_PREP(PMAC_CTRL_2_LCHKS, 3);
+		break;
+	}
+
+	switch (pmac->proc_flags_eg_cfg) {
+	case GSWIP_PMAC_PROC_FLAGS_NONE:
+		break;
+
+	case GSWIP_PMAC_PROC_FLAGS_TC:
+		ctrl[3] |= FIELD_PREP(PMAC_CTRL_4_FLAGEN, 0);
+		break;
+
+	case GSWIP_PMAC_PROC_FLAGS_FLAG:
+		ctrl[3] |= FIELD_PREP(PMAC_CTRL_4_FLAGEN, 1);
+		break;
+
+	case GSWIP_PMAC_PROC_FLAGS_MIX:
+		ctrl[3] |= FIELD_PREP(PMAC_CTRL_4_FLAGEN, 2);
+		break;
+	}
+
+	id = pmac->pmac_id;
+
+	for (i = 0; i < PMAC_CTRL_NUM; i++)
+		regmap_write(priv->regmap, pmac_reg(ctrl_reg[i], id), ctrl[i]);
+
+	for (i = 0; i < PMAC_BSL_NUM; i++)
+		regmap_write(priv->regmap, pmac_reg(bsl_reg[i], id),
+			     pmac->bsl_thresh[i]);
+
+	return 0;
+}
+
+/* PMAC backpressure configuration */
+static int gswip_pmac_bp_map_get(struct device *dev,
+				 struct gswip_pmac_bp_map *bp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct pmac_tbl_prog pmac_tbl = {0};
+	int ret;
+
+	pmac_tbl.id = PMAC_BP_MAP;
+	pmac_tbl.pmac_id = bp->pmac_id;
+	pmac_tbl.addr = FIELD_GET(PMAC_BPMAP_TX_DMA_CH, bp->tx_dma_chan_id);
+	pmac_tbl.num_val = PMAC_BP_MAP_TBL_VAL_NUM;
+
+	ret = gswip_pmac_table_read(priv, &pmac_tbl);
+	if (ret)
+		return -EINVAL;
+
+	bp->rx_port_mask = pmac_tbl.val[0];
+	bp->tx_q_mask = pmac_tbl.val[1];
+	bp->tx_q_mask |= FIELD_PREP(PMAC_BPMAP_TX_Q_UPPER, pmac_tbl.val[2]);
+
+	return 0;
+}
+
+/* PMAC ingress configuration */
+static int gswip_pmac_ig_cfg_set(struct device *dev,
+				 struct gswip_pmac_ig_cfg *ig)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct pmac_tbl_prog pmac_tbl = {0};
+	u16 *val;
+	u16 i;
+
+	pmac_tbl.id = PMAC_IG_CFG;
+	pmac_tbl.pmac_id = ig->pmac_id;
+	pmac_tbl.addr = FIELD_GET(PMAC_IGCFG_TX_DMA_CH, ig->tx_dma_chan_id);
+
+	val = &pmac_tbl.val[0];
+	for (i = 0; i < 4; i++)
+		val[i] = get_unaligned_be16(&ig->def_pmac_hdr[i * 2]);
+
+	switch (ig->sub_id) {
+	case GSWIP_PMAC_IG_CFG_SRC_DMA_DESC:
+		break;
+
+	case GSWIP_PMAC_IG_CFG_SRC_PMAC:
+	case GSWIP_PMAC_IG_CFG_SRC_DEF_PMAC:
+		val[4] = PMAC_IGCFG_VAL4_SUBID_MODE;
+		break;
+	}
+
+	val[4] |= FIELD_PREP(PMAC_IGCFG_VAL4_PMAC_FLAG, ig->pmac_present) |
+		  FIELD_PREP(PMAC_IGCFG_VAL4_CLASSEN_MODE, ig->class_en) |
+		  FIELD_PREP(PMAC_IGCFG_VAL4_CLASS_MODE, ig->class_def) |
+		  FIELD_PREP(PMAC_IGCFG_VAL4_ERR_DP, ig->err_pkt_disc) |
+		  FIELD_PREP(PMAC_IGCFG_VAL4_SPPID_MODE, ig->src_port_id_def);
+
+	pmac_tbl.num_val = PMAC_IG_CFG_TBL_VAL_NUM;
+
+	return gswip_pmac_table_write(priv, &pmac_tbl);
+}
+
+/* PMAC egress configuration */
+static int gswip_pmac_eg_cfg_set(struct device *dev,
+				 struct gswip_pmac_eg_cfg *eg)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct pmac_tbl_prog pmac_tbl = {0};
+	u16 ctrl, pmac_ctrl4;
+	u16 *val;
+
+	pmac_ctrl4 = pmac_reg(PMAC_CTRL_4, eg->pmac_id);
+
+	pmac_tbl.id = PMAC_EG_CFG;
+	pmac_tbl.pmac_id = eg->pmac_id;
+	pmac_tbl.addr = FIELD_PREP(PMAC_EGCFG_DST_PORT_ID, eg->dst_port_id)
+			| FIELD_PREP(PMAC_EGCFG_FLOW_ID_MSB,
+				     eg->flow_id_msb);
+
+	ctrl = reg_rbits(priv, pmac_ctrl4, PMAC_CTRL_4_FLAGEN);
+
+	if (ctrl == PMAC_RX_FSM_IDLE) {
+		pmac_tbl.addr |= FIELD_PREP(PMAC_EGCFG_TC_4BITS, eg->tc);
+	} else if (ctrl == PMAC_RX_FSM_IGCFG) {
+		pmac_tbl.addr |= FIELD_PREP(PMAC_EGCFG_MPE1, eg->mpe1) |
+				 FIELD_PREP(PMAC_EGCFG_MPE2, eg->mpe2) |
+				 FIELD_PREP(PMAC_EGCFG_ECRYPT, eg->encrypt) |
+				 FIELD_PREP(PMAC_EGCFG_DECRYPT, eg->decrypt);
+	} else if (ctrl == PMAC_RX_FSM_DASA) {
+		pmac_tbl.addr |= FIELD_PREP(PMAC_EGCFG_TC_2BITS, eg->tc) |
+				 FIELD_PREP(PMAC_EGCFG_MPE1, eg->mpe1) |
+				 FIELD_PREP(PMAC_EGCFG_MPE2, eg->mpe2);
+	}
+
+	val = &pmac_tbl.val[0];
+	val[0] = FIELD_PREP(PMAC_EGCFG_VAL0_REDIR, eg->redir_en) |
+		 FIELD_PREP(PMAC_EGCFG_VAL0_RES_3BITS, ctrl) |
+		   FIELD_PREP(PMAC_EGCFG_VAL0_BSL, eg->bsl_tc) |
+		   FIELD_PREP(PMAC_EGCFG_VAL0_RES_2BITS, eg->resv_2dw0);
+
+	val[1] = FIELD_PREP(PMAC_EGCFG_VAL1_RX_DMA_CH, eg->rx_dma_chan_id);
+
+	val[2] = FIELD_PREP(PMAC_EGCFG_VAL2_FCS_MODE, eg->fcs_en) |
+		   FIELD_PREP(PMAC_EGCFG_VAL2_PMAC_FLAG, eg->pmac_en);
+
+	if (eg->rm_l2_hdr) {
+		val[2] |= PMAC_EGCFG_VAL2_L2HD_RM_MODE |
+			    FIELD_PREP(PMAC_EGCFG_VAL2_L2HD_RM,
+				       eg->num_byte_rm);
+	}
+
+	pmac_tbl.num_val = PMAC_EG_CFG_TBL_VAL_NUM;
+
+	return gswip_pmac_table_write(priv, &pmac_tbl);
+}
+
+static int gswip_cpu_port_cfg_get(struct device *dev,
+				  struct gswip_cpu_port_cfg *cpu)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 lpid, val;
+
+	lpid = cpu->lpid;
+	if (lpid >= priv->num_lport) {
+		dev_err(priv->dev, "Invalid cpu port id %d > %d\n",
+			lpid, priv->num_lport);
+		return -EINVAL;
+	}
+
+	cpu->is_cpu_port = lpid == priv->cpu_port;
+	cpu->spec_tag_ig = reg_rbits(priv, PCE_PCTRL_0(lpid),
+				     PCE_PCTRL_0_IGSTEN);
+	cpu->fcs_chk = reg_rbits(priv, SDMA_PCTRL(lpid), SDMA_PCTRL_FCSIGN);
+
+	reg_r16(priv, FDMA_PASR, &val);
+	cpu->no_mpe_parser_cfg = FIELD_GET(FDMA_PASR_CPU, val);
+	cpu->mpe1_parser_cfg = FIELD_GET(FDMA_PASR_MPE1, val);
+	cpu->mpe2_parser_cfg = FIELD_GET(FDMA_PASR_MPE2, val);
+	cpu->mpe3_parser_cfg = FIELD_GET(FDMA_PASR_MPE3, val);
+
+	reg_r16(priv, FDMA_PCTRL(lpid), &val);
+	cpu->spec_tag_eg = FIELD_GET(FDMA_PCTRL_STEN, val);
+	cpu->ts_rm_ptp_pkt = FIELD_GET(FDMA_PCTRL_TS_PTP, val);
+	cpu->ts_rm_non_ptp_pkt = FIELD_GET(FDMA_PCTRL_TS_NONPTP, val);
+
+	return 0;
+}
+
+static int gswip_register_get(struct device *dev, struct gswip_register *param)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+
+	reg_r16(priv, param->offset, &param->data);
+
+	return 0;
+}
+
+static int gswip_register_set(struct device *dev, struct gswip_register *param)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+
+	regmap_write(priv->regmap, param->offset, param->data);
+
+	return 0;
+}
+
+/* Global Port ID/ Logical Port ID */
+static int gswip_lpid2gpid_set(struct device *dev,
+			       struct gswip_lpid2gpid *lp2gp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 lpid, first_gpid, last_gpid, val;
+
+	lpid = lp2gp->lpid;
+	first_gpid = lp2gp->first_gpid;
+	last_gpid = first_gpid + lp2gp->num_gpid - 1;
+
+	if (lpid >= priv->num_lport) {
+		dev_err(priv->dev, "Invalid lpid %d >= %d\n",
+			lpid, priv->num_lport);
+		return -EINVAL;
+	}
+
+	if (last_gpid >= priv->num_glb_port) {
+		dev_err(priv->dev, "Invalid last gpid %d >= %d\n",
+			last_gpid, priv->num_glb_port);
+		return -EINVAL;
+	}
+
+	val = FIELD_PREP(ETHSW_GPID_STARTID_STARTID, first_gpid) |
+	      FIELD_PREP(ETHSW_GPID_STARTID_BITS, lp2gp->valid_bits);
+	regmap_write(priv->regmap, ETHSW_GPID_STARTID(lpid), val);
+
+	reg_wbits(priv, ETHSW_GPID_ENDID(lpid),
+		  ETHSW_GPID_ENDID_ENDID, last_gpid);
+
+	return 0;
+}
+
+static int gswip_lpid2gpid_get(struct device *dev,
+			       struct gswip_lpid2gpid *lp2gp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 lpid, val;
+
+	lpid = lp2gp->lpid;
+	if (lpid >= priv->num_lport) {
+		dev_err(priv->dev, "Invalid lpid %d >= %d\n",
+			lpid, priv->num_lport);
+		return -EINVAL;
+	}
+
+	reg_r16(priv, ETHSW_GPID_STARTID(lpid), &val);
+	lp2gp->first_gpid = FIELD_GET(ETHSW_GPID_STARTID_STARTID, val);
+	lp2gp->valid_bits = FIELD_GET(ETHSW_GPID_STARTID_BITS, val);
+
+	reg_r16(priv, ETHSW_GPID_ENDID(lpid), &val);
+	lp2gp->num_gpid = val - lp2gp->first_gpid + 1;
+
+	return 0;
+}
+
+static int gswip_gpid2lpid_set(struct device *dev,
+			       struct gswip_gpid2lpid *gp2lp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 val = 0;
+
+	if (gp2lp->lpid >= priv->num_lport) {
+		dev_err(priv->dev, "Invalid lpid %d >= %d\n",
+			gp2lp->lpid, priv->num_lport);
+		return -EINVAL;
+	}
+
+	if (gp2lp->gpid >= priv->num_glb_port) {
+		dev_err(priv->dev, "Invalid gpid %d >= %d\n",
+			gp2lp->gpid, priv->num_glb_port);
+		return -EINVAL;
+	}
+
+	val = FIELD_PREP(GPID_RAM_VAL_LPID, gp2lp->lpid) |
+	      FIELD_PREP(GPID_RAM_VAL_SUBID_GRP, gp2lp->subif_grp_field) |
+	      FIELD_PREP(GPID_RAM_VAL_OV, gp2lp->subif_grp_field_ovr);
+
+	regmap_write(priv->regmap, GPID_RAM_VAL, val);
+
+	if (tbl_rw_tmout(priv, GPID_RAM_CTRL, GPID_RAM_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to access gpid table\n");
+		return -EBUSY;
+	}
+
+	reg_r16(priv, GPID_RAM_CTRL, &val);
+
+	update_val(&val, GPID_RAM_CTRL_ADDR, gp2lp->gpid);
+	val |= FIELD_PREP(GPID_RAM_CTRL_OPMOD, 1) |
+	       FIELD_PREP(GPID_RAM_CTRL_BAS, 1);
+
+	regmap_write(priv->regmap, GPID_RAM_CTRL, val);
+
+	if (tbl_rw_tmout(priv, GPID_RAM_CTRL, GPID_RAM_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to write gpid table\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int gswip_gpid2lpid_get(struct device *dev,
+			       struct gswip_gpid2lpid *gp2lp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 val;
+
+	if (gp2lp->gpid >= priv->num_glb_port) {
+		dev_err(priv->dev, "gpid %d >= %d\n",
+			gp2lp->gpid, priv->num_glb_port);
+		return -EINVAL;
+	}
+
+	if (tbl_rw_tmout(priv, GPID_RAM_CTRL, GPID_RAM_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to access gpid table\n");
+		return -EBUSY;
+	}
+
+	reg_r16(priv, GPID_RAM_CTRL, &val);
+
+	update_val(&val, GPID_RAM_CTRL_ADDR, gp2lp->gpid);
+	val |= FIELD_PREP(GPID_RAM_CTRL_OPMOD, 0) |
+	       FIELD_PREP(GPID_RAM_CTRL_BAS, 1);
+
+	regmap_write(priv->regmap, GPID_RAM_CTRL, val);
+
+	if (tbl_rw_tmout(priv, GPID_RAM_CTRL, GPID_RAM_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to read gpid table\n");
+		return -EBUSY;
+	}
+
+	reg_r16(priv, GPID_RAM_VAL, &val);
+
+	gp2lp->lpid = FIELD_GET(GPID_RAM_VAL_LPID, val);
+	gp2lp->subif_grp_field = FIELD_GET(GPID_RAM_VAL_SUBID_GRP, val);
+	gp2lp->subif_grp_field_ovr = FIELD_GET(GPID_RAM_VAL_OV, val);
+
+	return 0;
+}
+
+static int gswip_enable(struct device *dev, bool enable)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 i;
+
+	for (i = 0; i < priv->num_lport; i++) {
+		reg_wbits(priv, FDMA_PCTRL(i), FDMA_PCTRL_EN, enable);
+		reg_wbits(priv, SDMA_PCTRL(i), SDMA_PCTRL_PEN, enable);
+	}
+
+	return 0;
+}
+
+static const struct core_common_ops gswip_core_common_ops = {
+	.enable = gswip_enable,
+	.cpu_port_cfg_get = gswip_cpu_port_cfg_get,
+	.reg_get = gswip_register_get,
+	.reg_set = gswip_register_set,
+};
+
+static const struct core_pmac_ops gswip_core_pmac_ops = {
+	.gbl_cfg_set = gswip_pmac_glb_cfg_set,
+	.bp_map_get = gswip_pmac_bp_map_get,
+	.ig_cfg_set = gswip_pmac_ig_cfg_set,
+	.eg_cfg_set = gswip_pmac_eg_cfg_set,
+};
+
+static const struct core_gpid_ops gswip_core_gpid_ops = {
+	.lpid2gpid_set = gswip_lpid2gpid_set,
+	.lpid2gpid_get = gswip_lpid2gpid_get,
+	.gpid2lpid_set = gswip_gpid2lpid_set,
+	.gpid2lpid_get = gswip_gpid2lpid_get,
+};
+
+static int gswip_core_setup_ops(struct gswip_core_priv *priv)
+{
+	struct core_ops *ops =  &priv->ops;
+
+	ops->common_ops = &gswip_core_common_ops;
+	ops->pmac_ops = &gswip_core_pmac_ops;
+	ops->gpid_ops = &gswip_core_gpid_ops;
+
+	return 0;
+}
+
+static int gswip_core_get_hw_cap(struct gswip_core_priv *priv)
+{
+	u16 val;
+
+	priv->ver = reg_rbits(priv, ETHSW_VERSION, ETHSW_VERSION_REV_ID);
+	if (priv->ver != GSWIP_VER) {
+		dev_err(priv->dev, "Wrong hardware ip version %d\n",
+			priv->ver);
+		return -EINVAL;
+	}
+
+	priv->num_phy_port = reg_rbits(priv, ETHSW_CAP_1, ETHSW_CAP_1_PPORTS);
+
+	reg_r16(priv, ETHSW_CAP_1, &val);
+	priv->num_lport = priv->num_phy_port;
+	priv->num_lport += FIELD_GET(ETHSW_CAP_1_VPORTS, val);
+	priv->num_q = FIELD_GET(ETHSW_CAP_1_QUEUE, val);
+
+	priv->num_pmac = reg_rbits(priv, ETHSW_CAP_13, ETHSW_CAP_13_PMAC);
+
+	reg_r16(priv, ETHSW_CAP_17, &val);
+	priv->num_br = (1 << FIELD_GET(ETHSW_CAP_17_BRG, val));
+	priv->num_br_port = (1 << FIELD_GET(ETHSW_CAP_17_BRGPT, val));
+
+	reg_r16(priv, ETHSW_CAP_18, &priv->num_ctp);
+
+	priv->num_glb_port = priv->num_br_port * 2;
+
+	return 0;
+}
+
+static int gswip_core_init(struct gswip_core_priv *priv)
+{
+	priv->br_map = devm_kzalloc(priv->dev, BITS_TO_LONGS(priv->num_br),
+				    GFP_KERNEL);
+	if (!priv->br_map)
+		return -ENOMEM;
+
+	priv->br_port_map = devm_kzalloc(priv->dev,
+					 BITS_TO_LONGS(priv->num_br_port),
+					 GFP_KERNEL);
+	if (!priv->br_port_map)
+		return -ENOMEM;
+
+	priv->ctp_port_map = devm_kzalloc(priv->dev,
+					  BITS_TO_LONGS(priv->num_ctp),
+					  GFP_KERNEL);
+	if (!priv->ctp_port_map)
+		return -ENOMEM;
+
+	spin_lock_init(&priv->tbl_lock);
+
+	gswip_core_setup_ops(priv);
+	gswip_core_setup_port_ops(priv);
+
+	return 0;
+}
+
+static int gswip_core_setup(struct gswip_core_priv *priv)
+{
+	int ret;
+
+	ret = gswip_core_set_def_eg_pce_bypass_qmap(priv,
+						    GSWIP_QOS_QMAP_SINGLE_MD);
+	if (ret)
+		return ret;
+
+	ret = gswip_core_set_def_ig_pce_bypass_qmap(priv);
+	if (ret)
+		return ret;
+
+	ret = gswip_core_pmac_init_nondpu(priv);
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int gswip_core_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device *parent = dev->parent;
+	struct gswip_core_priv *priv;
+	struct gswip_pdata *pdata = parent->platform_data;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pdev = pdev;
+	priv->dev = dev;
+	priv->regmap = pdata->core_regmap;
+
+	platform_set_drvdata(pdev, priv);
+
+	ret = gswip_core_get_hw_cap(priv);
+	if (ret)
+		return -EINVAL;
+
+	ret = gswip_core_init(priv);
+	if (ret)
+		return ret;
+
+	ret = gswip_core_setup(priv);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static const struct of_device_id gswip_core_of_match_table[] = {
+	{ .compatible = "gswip-core" },
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, gswip_core);
+
+static struct platform_driver gswip_core_drv = {
+	.probe = gswip_core_probe,
+	.driver = {
+		.name = "gswip_core",
+		.of_match_table = gswip_core_of_match_table,
+	},
+};
+
+module_platform_driver(gswip_core_drv);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.h b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.h
new file mode 100644
index 000000000000..614a9089c1b0
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_core.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2016-2019 Intel Corporation. */
+#ifndef _GSWIP_CORE_H_
+#define _GSWIP_CORE_H_
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/regmap.h>
+
+#include "gswip.h"
+
+/* table should be ready in 30 clock cycle */
+#define TBL_BUSY_TIMEOUT_US	1
+
+struct core_ops {
+	const struct core_common_ops *common_ops;
+	const struct core_pmac_ops *pmac_ops;
+	const struct core_gpid_ops *gpid_ops;
+	const struct core_ctp_ops *ctp_ops;
+	const struct core_br_port_ops *br_port_ops;
+	const struct core_br_ops *br_ops;
+	const struct core_qos_ops *qos_ops;
+};
+
+struct gswip_core_priv {
+	struct device *dev;
+
+	unsigned long *br_map;
+	unsigned long *br_port_map;
+	unsigned long *ctp_port_map;
+	void *pdev;
+
+	u8 cpu_port;
+	u8 num_lport;
+	u8 num_br;
+	u8 num_br_port;
+	u16 num_ctp;
+	u16 num_glb_port;
+	u16 num_pmac;
+	u16 num_phy_port;
+	u16 num_q;
+
+	u16 ver;
+	struct regmap *regmap;
+	/* table read/write lock */
+	spinlock_t tbl_lock;
+
+	struct core_ops ops;
+};
+
+static inline void update_val(u16 *val, u16 mask, u16 set)
+{
+	*val &= ~mask;
+	*val |= FIELD_PREP(mask, set);
+}
+
+static inline void reg_r16(struct gswip_core_priv *priv, u16 reg, u16 *val)
+{
+	unsigned int reg_val;
+
+	regmap_read(priv->regmap, reg, &reg_val);
+	*val = reg_val;
+}
+
+static inline void reg_wbits(struct gswip_core_priv *priv,
+			     u16 reg, u16 mask, u16 val)
+{
+	regmap_update_bits(priv->regmap, reg, mask, FIELD_PREP(mask, val));
+}
+
+static inline u16 reg_rbits(struct gswip_core_priv *priv, u16 reg, u16 mask)
+{
+	unsigned int reg_val;
+
+	regmap_read(priv->regmap, reg, &reg_val);
+	return FIELD_GET(mask, reg_val);
+}
+
+/* Access table with timeout */
+static inline int tbl_rw_tmout(struct gswip_core_priv *priv, u16 reg, u16 mask)
+{
+	unsigned int val;
+
+	return regmap_read_poll_timeout(priv->regmap, reg, val, !(val & mask),
+					0, TBL_BUSY_TIMEOUT_US);
+}
+
+int gswip_core_setup_port_ops(struct gswip_core_priv *priv);
+
+#endif
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.c b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.c
new file mode 100644
index 000000000000..90668f193840
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation. */
+
+#include <linux/clk.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/reset.h>
+
+#include "gswip.h"
+#include "gswip_dev.h"
+
+#define GSWIP_SUBDEV_MAC_MAX	9
+#define GSWIP_SUBDEV_CORE_MAX	1
+#define GSWIP_MAC_DEV_NAME	"gswip_mac"
+#define GSWIP_CORE_DEV_NAME	"gswip_core"
+
+struct gswip_priv {
+	struct device *dev;
+	u32 id;
+	int num_subdev_mac;
+	int num_subdev_core;
+	struct gswip_pdata pdata;
+};
+
+static int regmap_reg_write(void *context, unsigned int reg, unsigned int val)
+{
+	struct gswip_pdata *pdata = context;
+
+	writew(val, pdata->core + reg);
+
+	return 0;
+}
+
+static int regmap_reg_read(void *context, unsigned int reg, unsigned int *val)
+{
+	struct gswip_pdata *pdata = context;
+
+	*val = readw(pdata->core + reg);
+
+	return 0;
+}
+
+static const struct regmap_config gswip_core_regmap_config = {
+	.reg_bits = 16,
+	.val_bits = 16,
+	.reg_stride = 4,
+	.reg_write = regmap_reg_write,
+	.reg_read = regmap_reg_read,
+	.fast_io = true,
+};
+
+static int np_gswip_parse_dt(struct platform_device *pdev,
+			     struct gswip_priv *priv)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct gswip_pdata *pdata = &priv->pdata;
+	struct device_node *np;
+
+	pdata->sw = devm_platform_ioremap_resource_byname(pdev, "switch");
+	if (IS_ERR(pdata->sw))
+		return PTR_ERR(pdata->sw);
+
+	pdata->lmac = devm_platform_ioremap_resource_byname(pdev, "lmac");
+	if (IS_ERR(pdata->lmac))
+		return PTR_ERR(pdata->lmac);
+
+	pdata->core = devm_platform_ioremap_resource_byname(pdev, "core");
+	if (IS_ERR(pdata->core))
+		return PTR_ERR(pdata->core);
+	pdata->core_regmap = devm_regmap_init(dev, NULL, pdata,
+					      &gswip_core_regmap_config);
+	if (IS_ERR(pdata->core_regmap))
+		return PTR_ERR(pdata->core_regmap);
+
+	pdata->sw_irq = platform_get_irq_byname(pdev, "switch");
+	if (pdata->sw_irq < 0)
+		return -ENODEV;
+
+	pdata->core_irq = platform_get_irq_byname(pdev, "core");
+	if (pdata->core_irq < 0)
+		return -ENODEV;
+
+	pdata->ptp_clk = devm_clk_get(dev, "ptp");
+	if (IS_ERR(pdata->ptp_clk))
+		return PTR_ERR(pdata->ptp_clk);
+
+	pdata->sw_clk = devm_clk_get(dev, "switch");
+	if (IS_ERR(pdata->sw_clk))
+		return PTR_ERR(pdata->sw_clk);
+
+	for_each_node_by_name(node, GSWIP_MAC_DEV_NAME) {
+		priv->num_subdev_mac++;
+		if (priv->num_subdev_mac > GSWIP_SUBDEV_MAC_MAX) {
+			dev_err(dev, "too many GSWIP mac subdevices\n");
+			return -EINVAL;
+		}
+	}
+
+	if (!priv->num_subdev_mac) {
+		dev_err(dev, "GSWIP mac subdevice not found\n");
+		return -EINVAL;
+	}
+
+	np = of_find_node_by_name(node, GSWIP_CORE_DEV_NAME);
+	if (np) {
+		priv->num_subdev_core++;
+		of_node_put(np);
+	} else {
+		dev_err(dev, "GSWIP core subdevice not found\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct of_device_id gswip_of_match_table[] = {
+	{ .compatible = "intel,lgm-gswip" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, gswip_of_match_table);
+
+static int np_gswip_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct reset_control *rcu_reset;
+	struct gswip_priv *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+
+	ret = np_gswip_parse_dt(pdev, priv);
+	if (ret) {
+		dev_err(dev, "failed to parse device tree\n");
+		return ret;
+	}
+
+	dev->id = priv->id;
+
+	rcu_reset = devm_reset_control_get_optional(dev, NULL);
+	if (IS_ERR(rcu_reset)) {
+		dev_err(dev, "error getting reset control of gswip\n");
+		return PTR_ERR(rcu_reset);
+	}
+
+	reset_control_assert(rcu_reset);
+	udelay(1);
+	reset_control_deassert(rcu_reset);
+
+	dev_set_drvdata(dev, priv);
+
+	dev->platform_data = &priv->pdata;
+
+	ret = devm_of_platform_populate(dev);
+
+	return ret;
+}
+
+static struct platform_driver np_gswip_driver = {
+	.probe = np_gswip_probe,
+	.driver = {
+		.name = "np_gswip",
+		.of_match_table = gswip_of_match_table,
+	},
+};
+
+module_platform_driver(np_gswip_driver);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.h b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.h
new file mode 100644
index 000000000000..c687bb89afc9
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_dev.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2016-2019 Intel Corporation. */
+#ifndef _GSWIP_DEV_H
+#define _GSWIP_DEV_H
+
+struct gswip_pdata {
+	void __iomem *sw;
+	void __iomem *lmac;
+	void __iomem *core;
+	int sw_irq;
+	int core_irq;
+	struct clk *ptp_clk;
+	struct clk *sw_clk;
+	bool intr_flag;
+	struct regmap *core_regmap;
+};
+
+#endif
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_mac.c b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_mac.c
new file mode 100644
index 000000000000..eb8c8049a77f
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_mac.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation. */
+
+#include <linux/bitfield.h>
+#include <linux/types.h>
+
+#include "mac_common.h"
+
+int sw_core_enable(struct device *dev, u32 val)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+	u32 reg;
+
+	spin_lock_bh(&priv->sw_lock);
+	reg = sw_read(priv, GSWIP_CFG);
+	reg &= ~GSWIP_CFG_CORE_SE_EN;
+	reg |= FIELD_PREP(GSWIP_CFG_CORE_SE_EN, val);
+	sw_write(priv, GSWIP_CFG, reg);
+	spin_unlock_bh(&priv->sw_lock);
+
+	return 0;
+}
+
+int sw_set_mac_rxfcs_op(struct gswip_mac *priv, u32 val)
+{
+	u32 mac_op_cfg;
+
+	mac_op_cfg = sw_read(priv, MAC_OP_CFG_REG(priv->mac_idx));
+	if (FIELD_GET(MAC_OP_CFG_RX_FCS, mac_op_cfg) != val) {
+		mac_op_cfg &= ~MAC_OP_CFG_RX_FCS;
+		mac_op_cfg |= FIELD_PREP(MAC_OP_CFG_RX_FCS, val);
+		sw_write(priv, MAC_OP_CFG_REG(priv->mac_idx), mac_op_cfg);
+	}
+
+	return 0;
+}
+
+int sw_set_eee_cap(struct gswip_mac *priv, u32 val)
+{
+	u32 aneg_eee;
+
+	aneg_eee = sw_read(priv, ANEG_EEE_REG(priv->mac_idx));
+	aneg_eee &= ~ANEG_EEE_CAP;
+	aneg_eee |= FIELD_PREP(ANEG_EEE_CAP, val);
+	sw_write(priv, ANEG_EEE_REG(priv->mac_idx), aneg_eee);
+
+	return 0;
+}
+
+int sw_set_fe_intf(struct gswip_mac *priv, u32 macif)
+{
+	u32 mac_if_cfg;
+
+	mac_if_cfg = sw_read(priv, MAC_IF_CFG_REG(priv->mac_idx));
+
+	if (macif == LMAC_MII)
+		mac_if_cfg &= ~MAC_IF_CFG_CFGFE;
+	else
+		mac_if_cfg |= MAC_IF_CFG_CFGFE;
+
+	sw_write(priv, MAC_IF_CFG_REG(priv->mac_idx), mac_if_cfg);
+
+	return 0;
+}
+
+int sw_set_1g_intf(struct gswip_mac *priv, u32 macif)
+{
+	u32 mac_if_cfg;
+
+	mac_if_cfg = sw_read(priv, MAC_IF_CFG_REG(priv->mac_idx));
+
+	if (macif == LMAC_GMII)
+		mac_if_cfg &= ~MAC_IF_CFG_CFG1G;
+	else
+		mac_if_cfg |= MAC_IF_CFG_CFG1G;
+
+	sw_write(priv, MAC_IF_CFG_REG(priv->mac_idx), mac_if_cfg);
+
+	return 0;
+}
+
+int sw_set_2G5_intf(struct gswip_mac *priv, u32 macif)
+{
+	u32 mac_if_cfg;
+
+	mac_if_cfg = sw_read(priv, MAC_IF_CFG_REG(priv->mac_idx));
+
+	if (macif == XGMAC_GMII)
+		mac_if_cfg &= ~MAC_IF_CFG_CFG2G5;
+	else
+		mac_if_cfg |= MAC_IF_CFG_CFG2G5;
+
+	sw_write(priv, MAC_IF_CFG_REG(priv->mac_idx), mac_if_cfg);
+
+	return 0;
+}
+
+int sw_set_speed(struct gswip_mac *priv, u8 speed)
+{
+	u16 phy_mode = 0;
+	u8 speed_msb = 0, speed_lsb = 0;
+
+	phy_mode = sw_read(priv, PHY_MODE_REG(priv->mac_idx));
+
+	/* clear first */
+	phy_mode &= ~PHY_MODE_SPEED_MSB & ~PHY_MODE_SPEED_LSB;
+
+	speed_msb = FIELD_GET(SPEED_MSB, speed);
+	speed_lsb = FIELD_GET(SPEED_LSB, speed);
+	phy_mode |= FIELD_PREP(PHY_MODE_SPEED_MSB, speed_msb);
+	phy_mode |= FIELD_PREP(PHY_MODE_SPEED_LSB, speed_lsb);
+
+	sw_write(priv, PHY_MODE_REG(priv->mac_idx), phy_mode);
+
+	return 0;
+}
+
+int sw_set_duplex_mode(struct gswip_mac *priv, u32 val)
+{
+	u16 phy_mode;
+
+	phy_mode = sw_read(priv, PHY_MODE_REG(priv->mac_idx));
+	if (FIELD_GET(PHY_MODE_FDUP, phy_mode) != val) {
+		phy_mode &= ~PHY_MODE_FDUP;
+		phy_mode |= FIELD_PREP(PHY_MODE_FDUP, val);
+		sw_write(priv, PHY_MODE_REG(priv->mac_idx), phy_mode);
+	}
+
+	return 0;
+}
+
+int sw_get_duplex_mode(struct gswip_mac *priv)
+{
+	u16 phy_mode;
+	int val;
+
+	phy_mode = sw_read(priv, PHY_STAT_REG(priv->mac_idx));
+	val = FIELD_GET(PHY_STAT_FDUP, phy_mode);
+
+	return val;
+}
+
+int sw_get_linkstatus(struct gswip_mac *priv)
+{
+	u16 phy_mode;
+	int linkst;
+
+	phy_mode = sw_read(priv, PHY_STAT_REG(priv->mac_idx));
+	linkst = FIELD_GET(PHY_STAT_LSTAT, phy_mode);
+
+	return linkst;
+}
+
+int sw_set_linkstatus(struct gswip_mac *priv, u8 linkst)
+{
+	u16 phy_mode;
+	u8 val;
+
+	phy_mode = sw_read(priv, PHY_MODE_REG(priv->mac_idx));
+	val = FIELD_GET(PHY_MODE_LINKST, phy_mode);
+	if (val != linkst) {
+		phy_mode &= ~PHY_MODE_LINKST;
+		phy_mode |= FIELD_PREP(PHY_MODE_LINKST, linkst);
+		sw_write(priv, PHY_MODE_REG(priv->mac_idx), phy_mode);
+	}
+
+	return 0;
+}
+
+int sw_set_flowctrl(struct gswip_mac *priv, u8 val, u32 mode)
+{
+	u16 phy_mode;
+
+	phy_mode = sw_read(priv, PHY_MODE_REG(priv->mac_idx));
+
+	switch (mode) {
+	case FCONRX:
+		phy_mode &= ~PHY_MODE_FCONRX;
+		phy_mode |= FIELD_PREP(PHY_MODE_FCONRX, val);
+		break;
+
+	case FCONTX:
+		phy_mode &= ~PHY_MODE_FCONTX;
+		phy_mode |= FIELD_PREP(PHY_MODE_FCONTX, val);
+		break;
+	}
+
+	sw_write(priv, PHY_MODE_REG(priv->mac_idx), phy_mode);
+
+	return 0;
+}
+
+u32 sw_get_speed(struct gswip_mac *priv)
+{
+	u16 phy_mode = 0;
+	u32 speed_msb, speed_lsb, speed;
+
+	phy_mode = sw_read(priv, PHY_STAT_REG(priv->mac_idx));
+	speed_msb = FIELD_GET(PHY_STAT_SPEED_MSB, phy_mode);
+	speed_lsb = FIELD_GET(PHY_STAT_SPEED_LSB, phy_mode);
+	speed = (speed_msb << 2) | speed_lsb;
+
+	return speed;
+}
+
+u32 sw_mac_get_mtu(struct gswip_mac *priv)
+{
+	u32 reg, val;
+
+	reg = sw_read(priv, MAC_MTU_CFG_REG(priv->mac_idx));
+	val = FIELD_PREP(MAC_MTU_CFG_MTU, reg);
+
+	return val;
+}
+
+int sw_mac_set_mtu(struct gswip_mac *priv, u32 mtu)
+{
+	u32 val;
+
+	val = sw_mac_get_mtu(priv);
+	if (val != mtu)
+		sw_write(priv, MAC_MTU_CFG_REG(priv->mac_idx), mtu);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_port.c b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_port.c
new file mode 100644
index 000000000000..1fd611db9ffc
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_port.c
@@ -0,0 +1,330 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation.*/
+#include "gswip_core.h"
+#include "gswip_reg.h"
+#include "gswip_tbl.h"
+
+#define ENABLE		1
+#define DISABLE		0
+
+static int gswip_ctp_port_set(struct gswip_core_priv *priv,
+			      struct gswip_ctp_port_info *ctp)
+{
+	u16 val, last_port;
+
+	val = ctp->first_pid;
+	last_port = ctp->first_pid + ctp->num_port - 1;
+
+	switch (ctp->mode) {
+	case GSWIP_LPORT_8BIT_WLAN:
+		val |= FIELD_PREP(ETHSW_CTP_STARTID_MD, MD_WLAN8);
+		break;
+
+	case GSWIP_LPORT_9BIT_WLAN:
+		val |= FIELD_PREP(ETHSW_CTP_STARTID_MD, MD_WLAN8);
+		break;
+	case GSWIP_LPORT_GPON:
+	case GSWIP_LPORT_EPON:
+	case GSWIP_LPORT_GINT:
+	case GSWIP_LPORT_OTHER:
+		val |= FIELD_PREP(ETHSW_CTP_STARTID_MD, MD_OTHER);
+		break;
+	}
+
+	regmap_write(priv->regmap, ETHSW_CTP_STARTID(ctp->lpid), val);
+	regmap_write(priv->regmap, ETHSW_CTP_ENDID(ctp->lpid), last_port);
+
+	return 0;
+}
+
+static int gswip_ctp_port_get(struct gswip_core_priv *priv,
+			      struct gswip_ctp_port_info *ctp)
+{
+	u16 val, last_port;
+
+	reg_r16(priv, ETHSW_CTP_STARTID(ctp->lpid), &val);
+
+	ctp->mode = FIELD_GET(ETHSW_CTP_STARTID_MD, val);
+	ctp->first_pid = FIELD_GET(ETHSW_CTP_STARTID_STARTID, val);
+
+	last_port = reg_rbits(priv, ETHSW_CTP_ENDID(ctp->lpid),
+			      ETHSW_CTP_ENDID_ENDID);
+	ctp->num_port = last_port - ctp->first_pid + 1;
+
+	return 0;
+}
+
+static int gswip_ctp_port_alloc(struct device *dev,
+				struct gswip_ctp_port_info *ctp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	u16 first_ctp;
+	int ret;
+
+	if (!ctp->num_port || ctp->num_port >= priv->num_ctp) {
+		dev_err(priv->dev, "Invalid num of ctp port requested %d\n",
+			ctp->num_port);
+		return -EINVAL;
+	}
+
+	first_ctp = bitmap_find_next_zero_area(priv->ctp_port_map,
+					       priv->num_ctp, 0,
+					       ctp->num_port, 0);
+	if (first_ctp >= priv->num_ctp) {
+		dev_err(priv->dev, "Failed to find contiguous ctp port\n");
+		return -EINVAL;
+	}
+
+	bitmap_set(priv->ctp_port_map, first_ctp, ctp->num_port);
+	ctp->first_pid = first_ctp;
+
+	ret = gswip_ctp_port_set(priv, ctp);
+	if (ret) {
+		bitmap_clear(priv->ctp_port_map, first_ctp, ctp->num_port);
+		return ret;
+	}
+
+	reg_wbits(priv, SDMA_PCTRL(ctp->lpid), SDMA_PCTRL_PEN, ENABLE);
+
+	return 0;
+}
+
+static int gswip_ctp_port_free(struct device *dev, u8 lpid)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct gswip_ctp_port_info ctp;
+
+	if (lpid >= priv->num_lport) {
+		dev_err(priv->dev, "Invalid lpid %d\n", lpid);
+		return -EINVAL;
+	}
+
+	ctp.lpid = lpid;
+	gswip_ctp_port_get(priv, &ctp);
+
+	reg_wbits(priv, SDMA_PCTRL(lpid), SDMA_PCTRL_PEN, DISABLE);
+	regmap_write(priv->regmap, ETHSW_CTP_STARTID(lpid), 0);
+	regmap_write(priv->regmap, ETHSW_CTP_ENDID(lpid), 0);
+
+	bitmap_clear(priv->ctp_port_map, ctp.first_pid, ctp.num_port);
+
+	return 0;
+}
+
+static int gswip_bridge_port_alloc(struct device *dev,
+				   struct gswip_br_port_alloc *bp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct pce_tbl_prog pce_tbl = {0};
+	int ret;
+
+	bp->br_pid = find_first_zero_bit(priv->br_port_map, priv->num_br_port);
+	if (bp->br_pid >= priv->num_br_port) {
+		dev_err(priv->dev, "failed to alloc bridge port\n");
+		return -EINVAL;
+	}
+
+	set_bit(bp->br_pid, priv->br_port_map);
+
+	pce_tbl.id = PCE_IG_BRP_CFG;
+	pce_tbl.addr = bp->br_pid;
+	pce_tbl.val[4] = PCE_MAC_LIMIT_NUM |
+			 FIELD_PREP(PCE_IGBGP_VAL4_BR_ID, bp->br_id);
+
+	ret = gswip_pce_table_write(priv, &pce_tbl);
+	if (ret) {
+		clear_bit(bp->br_pid, priv->br_port_map);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int gswip_bridge_port_free(struct device *dev,
+				  struct gswip_br_port_alloc *bp)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct pce_tbl_prog pce_tbl = {0};
+	u16 br_pid;
+	int ret;
+
+	br_pid = bp->br_pid;
+	if (br_pid >= priv->num_br_port) {
+		dev_err(priv->dev, "brige port id %d >=%d\n",
+			br_pid, priv->num_br_port);
+		return -EINVAL;
+	}
+
+	if (!test_bit(br_pid, priv->br_port_map)) {
+		dev_err(priv->dev, "bridge port id %d is not in used\n",
+			br_pid);
+		return -EINVAL;
+	}
+
+	pce_tbl.id = PCE_IG_BRP_CFG;
+	pce_tbl.addr = br_pid;
+	pce_tbl.val[4] = PCE_MAC_LIMIT_NUM;
+
+	ret = gswip_pce_table_write(priv, &pce_tbl);
+	if (ret)
+		return ret;
+
+	clear_bit(br_pid, priv->br_port_map);
+
+	return 0;
+}
+
+static int gswip_bridge_alloc(struct device *dev, struct gswip_br_alloc *br)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+
+	br->br_id = find_first_zero_bit(priv->br_map, priv->num_br);
+	if (br->br_id >= priv->num_br) {
+		dev_err(priv->dev, "failed to alloc bridge\n");
+		return -EINVAL;
+	}
+
+	set_bit(br->br_id, priv->br_map);
+
+	return 0;
+}
+
+static int gswip_bridge_free(struct device *dev, struct gswip_br_alloc *br)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct pce_tbl_prog pce_tbl = {0};
+	u16 br_id;
+	int ret;
+
+	if (br->br_id >= priv->num_br) {
+		dev_err(priv->dev, "bridge id %d >= %d\n",
+			br->br_id, priv->num_br);
+		return -EINVAL;
+	}
+
+	br_id = br->br_id;
+	if (!test_bit(br_id, priv->br_map)) {
+		dev_err(priv->dev, "bridge id %d not allocated\n", br_id);
+		return 0;
+	}
+
+	pce_tbl.id = PCE_BR_CFG;
+	pce_tbl.addr = br_id;
+	pce_tbl.val[0] = PCE_MAC_LIMIT_NUM;
+
+	ret = gswip_pce_table_write(priv, &pce_tbl);
+	if (ret)
+		return ret;
+
+	clear_bit(br_id, priv->br_map);
+
+	return 0;
+}
+
+/* Set queue for a logical port based on egress/ingress packet.
+ * Then map the queue to an egress port.
+ *  +----------------------+               +---------------------+
+ *  | ingress logical port | -> queue/s -> | egress logical port |
+ *  +----------------------+               +---------------------+
+ */
+static int gswip_qos_q_port_set(struct device *dev,
+				struct gswip_qos_q_port *qport)
+{
+	struct gswip_core_priv *priv = dev_get_drvdata(dev);
+	struct pce_tbl_prog pce_tbl = {0};
+	struct bm_tbl_prog bm_tbl = {0};
+	u16 eg_port, val;
+	u8 qid;
+	int ret;
+
+	qid = qport->qid;
+
+	if (qport->egress) {
+		/* Egress packet always bypass PCE.
+		 * Queue identifier is set in the SDMA_BYPASS register
+		 * for each logical port.
+		 */
+		reg_r16(priv, SDMA_BYPASS(qport->lpid), &val);
+
+		if (!qport->extration_en) {
+			if (qport->q_map_mode == GSWIP_QOS_QMAP_SINGLE_MD)
+				val |= FIELD_PREP(SDMA_BYPASS_MD, 1);
+			else
+				val |= FIELD_PREP(SDMA_BYPASS_MD, 0);
+
+			val |= FIELD_PREP(SDMA_BYPASS_NMQID, qid);
+		} else {
+			val |= FIELD_PREP(SDMA_BYPASS_EXTQID, qid);
+		}
+
+		regmap_write(priv->regmap, SDMA_BYPASS(qport->lpid), val);
+	} else {
+		/* Ingress packet can bypass or not bypass PCE.
+		 * Queue identifier is set in the Queue Mapping Table
+		 * under PCE Table Programming. This table will be used
+		 * for bypass/no bypass case.
+		 */
+		pce_tbl.id = PCE_Q_MAP;
+		pce_tbl.addr = qport->tc_id;
+		pce_tbl.addr |= FIELD_PREP(PCE_Q_MAP_EG_PID, qport->lpid);
+
+		if (qport->en_ig_pce_bypass || qport->resv_port_mode) {
+			pce_tbl.addr |= PCE_Q_MAP_IG_PORT_MODE;
+		} else {
+			if (qport->extration_en)
+				pce_tbl.addr |= PCE_Q_MAP_LOCAL_EXTRACT;
+		}
+
+		pce_tbl.val[0] = qid;
+		ret = gswip_pce_table_write(priv, &pce_tbl);
+		if (ret)
+			return ret;
+
+		reg_wbits(priv, SDMA_BYPASS(qport->lpid),
+			  SDMA_BYPASS_PCEBYP, qport->en_ig_pce_bypass);
+	}
+
+	/* Redirect port id for table is bit 4, and bit (2,0) */
+	eg_port = FIELD_GET(BM_Q_MAP_VAL4_REDIR_PID, qport->redir_port_id);
+	val = FIELD_GET(BM_Q_MAP_VAL4_REDIR_PID_MSB, qport->redir_port_id);
+	eg_port |= FIELD_PREP(BM_Q_MAP_VAL4_REDIR_PID_BIT4, val);
+
+	/* Map queue to an egress port. */
+	bm_tbl.id = BM_Q_MAP;
+	bm_tbl.val[0] = eg_port;
+	bm_tbl.num_val = 1;
+	bm_tbl.qmap.qid = qid;
+
+	return gswip_bm_table_write(priv, &bm_tbl);
+}
+
+static const struct core_ctp_ops gswip_core_ctp_ops = {
+	.alloc = gswip_ctp_port_alloc,
+	.free = gswip_ctp_port_free,
+};
+
+static const struct core_br_port_ops gswip_core_br_port_ops = {
+	.alloc = gswip_bridge_port_alloc,
+	.free = gswip_bridge_port_free,
+};
+
+static const struct core_br_ops gswip_core_br_ops = {
+	.alloc = gswip_bridge_alloc,
+	.free = gswip_bridge_free,
+};
+
+static const struct core_qos_ops gswip_core_qos_ops = {
+	.q_port_set = gswip_qos_q_port_set,
+};
+
+int gswip_core_setup_port_ops(struct gswip_core_priv *priv)
+{
+	struct core_ops *ops =  &priv->ops;
+
+	ops->ctp_ops = &gswip_core_ctp_ops;
+	ops->br_port_ops = &gswip_core_br_port_ops;
+	ops->br_ops = &gswip_core_br_ops;
+	ops->qos_ops = &gswip_core_qos_ops;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_reg.h b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_reg.h
new file mode 100644
index 000000000000..50a13b68ef85
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_reg.h
@@ -0,0 +1,491 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2016-2019 Intel Corporation.
+ *
+ * GSWIP-O Top and Legacy MAC Register Description.
+ */
+#ifndef _GSWIP_REG_H
+#define _GSWIP_REG_H
+
+#define ETHSW_CAP_1			0x001c
+#define ETHSW_CAP_1_PPORTS		GENMASK(3, 0)
+#define ETHSW_CAP_1_VPORTS		GENMASK(7, 4)
+#define ETHSW_CAP_1_QUEUE		GENMASK(14, 8)
+#define ETHSW_CAP_1_GMAC		BIT(15)
+
+#define ETHSW_VERSION			0x004c
+#define ETHSW_VERSION_REV_ID		GENMASK(7, 0)
+#define ETHSW_VERSION_MOD_ID		GENMASK(15, 8)
+
+#define ETHSW_CAP_13			0x0058
+#define ETHSW_CAP_13_EVLAN		GENMASK(3, 0)
+#define ETHSW_CAP_13_INTRMON		GENMASK(7, 4)
+#define ETHSW_CAP_13_PAYLOAD		GENMASK(11, 8)
+#define ETHSW_CAP_13_PMAC		GENMASK(15, 12)
+
+#define ETHSW_CAP_17			0x0068
+#define ETHSW_CAP_17_BRGPT		GENMASK(3, 0)
+#define ETHSW_CAP_17_BRG		GENMASK(7, 4)
+#define ETHSW_CAP_17_PMAP		GENMASK(11, 8)
+
+#define ETHSW_CAP_18			0x006c
+#define ETHSW_CAP_18_CTP		GENMASK(15, 0)
+
+#define BM_RAM_VAL_OFFSET		4
+#define BM_RAM_VAL_0			0x010c
+#define BM_RAM_VAL_0_VAL0		GENMASK(15, 0)
+
+#define BM_RAM_ADDR			0x0110
+#define BM_RAM_ADDR_ADDR		GENMASK(15, 0)
+
+#define BM_RAM_CTRL			0x0114
+#define BM_RAM_CTRL_ADDR		GENMASK(4, 0)
+#define BM_RAM_CTRL_OPMOD		BIT(5)
+#define BM_RAM_CTRL_RMON		BIT(6)
+#define BM_RAM_CTRL_BAS			BIT(15)
+
+#define BM_RMON_GCTRL			0x0188
+#define BM_RMON_GCTRL_METER_RES		BIT(1)
+#define BM_RMON_GCTRL_ALLITF_RES	BIT(2)
+#define BM_RMON_GCTRL_INT_RES		BIT(3)
+#define BM_RMON_GCTRL_ITFID		GENMASK(11, 4)
+#define BM_RMON_GCTRL_PMAC_RES		BIT(12)
+#define BM_RMON_GCTRL_MRMON		BIT(14)
+#define BM_RMON_GCTRL_INTMON		BIT(15)
+
+#define BM_PCFG_OFFSET			8
+#define BM_PCFG(x)			(0x0200 + BM_PCFG_OFFSET * (x))
+#define BM_PCFG_CNTEN			BIT(0)
+
+#define BM_RMON_CTRL_OFFSET		8
+#define BM_RMON_CTRL(x)			(0x0204 + BM_RMON_CTRL_OFFSET * (x))
+#define BM_RMON_CTRL_RAM1_RES		BIT(0)
+#define BM_RMON_CTRL_RAM2_RES		BIT(1)
+
+#define BM_PWRED_RTH_0_OFFSET		24
+#define BM_PWRED_RTH_0(x)		(0x0280 + BM_PWRED_RTH_0_OFFSET * (x))
+#define BM_PWRED_RTH_0_MINTH		GENMASK(9, 0)
+
+#define BM_PWRED_RTH_1_OFFSET		24
+#define BM_PWRED_RTH_1(x)		(0x0284 + BM_PWRED_RTH_1_OFFSET * (x))
+#define BM_PWRED_RTH_1_MAXTH		GENMASK(9, 0)
+
+#define BM_PWRED_YTH_0_OFFSET		24
+#define BM_PWRED_YTH_0(x)		(0x0288 + BM_PWRED_YTH_0_OFFSET * (x))
+#define BM_PWRED_YTH_0_MINTH		GENMASK(9, 0)
+
+#define BM_PWRED_YTH_1_OFFSET		24
+#define BM_PWRED_YTH_1(x)		(0x028c + BM_PWRED_YTH_1_OFFSET * (x))
+#define BM_PWRED_YTH_1_MAXTH		GENMASK(9, 0)
+
+#define BM_PWRED_GTH_0_OFFSET		24
+#define BM_PWRED_GTH_0(x)		(0x0290 + BM_PWRED_GTH_0_OFFSET * (x))
+#define BM_PWRED_GTH_0_MINTH		GENMASK(9, 0)
+
+#define BM_PWRED_GTH_1_OFFSET		24
+#define BM_PWRED_GTH_1(x)		(0x0294 + BM_PWRED_GTH_1_OFFSET * (x))
+#define BM_PWRED_GTH_1_MAXTH		GENMASK(9, 0)
+
+#define PCE_TBL_VAL_30			0x1014
+#define PCE_TBL_VAL_29			0x1018
+#define PCE_TBL_VAL_28			0x101c
+#define PCE_TBL_VAL_27			0x1020
+#define PCE_TBL_VAL_26			0x1024
+
+#define PCE_TBL_KEY_33			0x1038
+#define PCE_TBL_KEY_32			0x103c
+#define PCE_TBL_KEY_31			0x1040
+#define PCE_TBL_KEY_30			0x1044
+#define PCE_TBL_KEY_29			0x1048
+#define PCE_TBL_KEY_28			0x104c
+#define PCE_TBL_KEY_27			0x1050
+#define PCE_TBL_KEY_26			0x1054
+#define PCE_TBL_KEY_25			0x1058
+#define PCE_TBL_KEY_24			0x105c
+#define PCE_TBL_KEY_23			0x1060
+#define PCE_TBL_KEY_22			0x1064
+#define PCE_TBL_KEY_21			0x1068
+#define PCE_TBL_KEY_20			0x106c
+#define PCE_TBL_KEY_19			0x1070
+#define PCE_TBL_KEY_18			0x1074
+#define PCE_TBL_KEY_17			0x1078
+#define PCE_TBL_KEY_16			0x107c
+
+#define PCE_TBL_VAL_25			0x1080
+#define PCE_TBL_VAL_24			0x1084
+#define PCE_TBL_VAL_23			0x1088
+#define PCE_TBL_VAL_22			0x108c
+#define PCE_TBL_VAL_21			0x1090
+#define PCE_TBL_VAL_20			0x1094
+#define PCE_TBL_VAL_19			0x1098
+#define PCE_TBL_VAL_18			0x109c
+#define PCE_TBL_VAL_17			0x10a0
+#define PCE_TBL_VAL_16			0x10a4
+
+#define PCE_TBL_MASK_3			0x10a8
+#define PCE_TBL_MASK_2			0x10ac
+#define PCE_TBL_MASK_1			0x10b0
+
+#define PCE_TBL_VAL_15			0x10b4
+#define PCE_TBL_VAL_14			0x10b8
+#define PCE_TBL_VAL_13			0x10bc
+#define PCE_TBL_VAL_12			0x10c0
+#define PCE_TBL_VAL_11			0x10c4
+#define PCE_TBL_VAL_10			0x10c8
+#define PCE_TBL_VAL_9			0x10cc
+#define PCE_TBL_VAL_8			0x10d0
+#define PCE_TBL_VAL_7			0x10d4
+#define PCE_TBL_VAL_6			0x10d8
+#define PCE_TBL_VAL_5			0x10dc
+
+#define PCE_TBL_KEY_15			0x01e0
+#define PCE_TBL_KEY_14			0x10e4
+#define PCE_TBL_KEY_13			0x10e8
+#define PCE_TBL_KEY_12			0x10ec
+#define PCE_TBL_KEY_11			0x10f0
+#define PCE_TBL_KEY_10			0x10f4
+#define PCE_TBL_KEY_9			0x10f8
+#define PCE_TBL_KEY_8			0x10fc
+#define PCE_TBL_KEY_7			0x1100
+#define PCE_TBL_KEY_6			0x1104
+#define PCE_TBL_KEY_5			0x1108
+#define PCE_TBL_KEY_4			0x110c
+#define PCE_TBL_KEY_3			0x1110
+#define PCE_TBL_KEY_2			0x1114
+#define PCE_TBL_KEY_1			0x1118
+#define PCE_TBL_KEY_0			0x111c
+
+#define PCE_TBL_MASK_0			0x1120
+
+#define PCE_TBL_VAL_4			0x1124
+#define PCE_TBL_VAL_3			0x1128
+#define PCE_TBL_VAL_2			0x112c
+#define PCE_TBL_VAL_1			0x1130
+#define PCE_TBL_VAL_0			0x1134
+
+#define PCE_TBL_ADDR			0x1138
+#define PCE_TBL_ADDR_ADDR		GENMASK(11, 0)
+
+#define PCE_TBL_CTRL			0x113c
+#define PCE_TBL_CTRL_ADDR		GENMASK(4, 0)
+#define PCE_TBL_CTRL_OPMOD		GENMASK(6, 5)
+#define PCE_TBL_CTRL_GMAP		GENMASK(10, 7)
+#define PCE_TBL_CTRL_KEYFORM		BIT(11)
+#define PCE_TBL_CTRL_VLD		BIT(12)
+#define PCE_TBL_CTRL_TYPE		BIT(13)
+#define PCE_TBL_CTRL_EXTOP		BIT(14)
+#define PCE_TBL_CTRL_BAS		BIT(15)
+
+#define PCE_PCTRL_OFFSET		40
+#define PCE_PCTRL_0(x)			(0x1200 + PCE_PCTRL_OFFSET * (x))
+#define PCE_PCTRL_0_PSTATE		GENMASK(2, 0)
+#define PCE_PCTRL_0_AGEDIS		BIT(3)
+#define PCE_PCTRL_0_PLOCK		BIT(4)
+#define PCE_PCTRL_0_TVM			BIT(5)
+#define PCE_PCTRL_0_VREP		BIT(6)
+#define PCE_PCTRL_0_CMOD		BIT(7)
+#define PCE_PCTRL_0_DPEN		BIT(8)
+#define PCE_PCTRL_0_CLPEN		BIT(9)
+#define PCE_PCTRL_0_PCPEN		BIT(10)
+#define PCE_PCTRL_0_IGSTEN		BIT(11)
+#define PCE_PCTRL_0_EGSTEN		BIT(12)
+#define PCE_PCTRL_0_MCST		BIT(13)
+#define PCE_PCTRL_0_SPFDIS		BIT(14)
+#define PCE_PCTRL_0_MSTP		BIT(15)
+
+#define FDMA_PASR			0x291c
+#define FDMA_PASR_CPU			GENMASK(1, 0)
+#define FDMA_PASR_MPE1			GENMASK(3, 2)
+#define FDMA_PASR_MPE2			GENMASK(5, 4)
+#define FDMA_PASR_MPE3			GENMASK(7, 6)
+
+#define FDMA_PCTRL_OFFSET		24
+#define FDMA_PCTRL(x)			(0x2a00 + FDMA_PCTRL_OFFSET * (x))
+#define FDMA_PCTRL_EN			BIT(0)
+#define FDMA_PCTRL_STEN			BIT(1)
+#define FDMA_PCTRL_DSCPRM		BIT(2)
+#define FDMA_PCTRL_VLANMOD		BIT(3)
+#define FDMA_PCTRL_TS_PTP		BIT(4)
+#define FDMA_PCTRL_TS_NONPTP		BIT(5)
+#define FDMA_PCTRL_HEADER_SHORT		BIT(6)
+#define FDMA_PCTRL_VLANTPID		BIT(7)
+
+#define SDMA_PCTRL_OFFSET		24
+#define SDMA_PCTRL(x)			(0x2f00 + SDMA_PCTRL_OFFSET * (x))
+#define SDMA_PCTRL_PEN			BIT(0)
+#define SDMA_PCTRL_FCEN			BIT(1)
+#define SDMA_PCTRL_MFCEN		BIT(2)
+#define SDMA_PCTRL_PAUFWD		BIT(3)
+#define SDMA_PCTRL_FCSFWD		BIT(4)
+#define SDMA_PCTRL_FCSIGN		BIT(5)
+#define SDMA_PCTRL_USFWD		BIT(6)
+#define SDMA_PCTRL_OSFWD		BIT(7)
+#define SDMA_PCTRL_LENFWD		BIT(8)
+#define SDMA_PCTRL_ALGFWD		BIT(9)
+#define SDMA_PCTRL_PHYEFWD		BIT(10)
+#define SDMA_PCTRL_PTHR			GENMASK(12, 11)
+#define SDMA_PCTRL_DTHR			GENMASK(14, 13)
+
+#define SDMA_PRIO_OFFSET		24
+#define SDMA_PRIO(x)			(0x2f04 + SDMA_PRIO_OFFSET * (x))
+#define SDMA_PRIO_BIT10			GENMASK(1, 0)
+#define SDMA_PRIO_USIGN			BIT(2)
+#define SDMA_PRIO_OSIGN			BIT(3)
+#define SDMA_PRIO_LENIGN		BIT(4)
+#define SDMA_PRIO_ALGIGN		BIT(5)
+#define SDMA_PRIO_PHYEIGN		BIT(6)
+#define SDMA_PRIO_MIN_IFG		GENMASK(11, 7)
+
+#define SDMA_BYPASS_OFFSET		24
+#define SDMA_BYPASS(x)			(0x2f10 + SDMA_BYPASS_OFFSET * (x))
+#define SDMA_BYPASS_MD			BIT(0)
+#define SDMA_BYPASS_NMQID		GENMASK(5, 1)
+#define SDMA_BYPASS_EXTQID		GENMASK(10, 6)
+#define SDMA_BYPASS_PCEBYP		BIT(11)
+#define SDMA_BYPASS_IGMIR		BIT(12)
+#define SDMA_BYPASS_EGMIR		BIT(13)
+
+#define PMAC_CTRL_0			0x340c
+#define PMAC_CTRL_0_CHKVER		BIT(5)
+#define PMAC_CTRL_0_CHKREG		BIT(6)
+#define PMAC_CTRL_0_FCS			BIT(7)
+#define PMAC_CTRL_0_PADEN		BIT(8)
+#define PMAC_CTRL_0_VPADEN		BIT(9)
+#define PMAC_CTRL_0_VPAD2EN		BIT(10)
+#define PMAC_CTRL_0_APADEN		BIT(11)
+#define PMAC_CTRL_0_FCSEN		BIT(12)
+
+#define PMAC_CTRL_1			0x3410
+#define PMAC_CTRL_1_MLEN		GENMASK(13, 0)
+
+#define PMAC_CTRL_2			0x3414
+#define PMAC_CTRL_2_LCHKS		GENMASK(1, 0)
+#define PMAC_CTRL_2_LCHKL		BIT(2)
+#define PMAC_CTRL_2_MLEN		BIT(3)
+
+#define PMAC_CTRL_4			0x341c
+#define PMAC_CTRL_4_FLAGEN		GENMASK(1, 0)
+#define PMAC_RX_FSM_IDLE		0x00
+#define PMAC_RX_FSM_IGCFG		0x01
+#define PMAC_RX_FSM_DASA		0x10
+
+#define PMAC_CTRL_NUM			4
+
+#define PMAC_REG_OFFSET_1		0x200
+#define PMAC_REG_OFFSET_2		0x600
+
+#define	PMAC_BSL_LEN0			0x3440
+#define	PMAC_BSL_LEN0_LEN0		GENMASK(15, 0)
+
+#define	PMAC_BSL_LEN1			0x3444
+#define	PMAC_BSL_LEN1_LEN1		GENMASK(15, 0)
+
+#define	PMAC_BSL_LEN2			0x3448
+#define	PMAC_BSL_LEN2_LEN2		GENMASK(15, 0)
+
+#define PMAC_BSL_NUM			3
+
+#define PMAC_TBL_VAL_OFFSET		0x200
+#define PMAC_TBL_VAL(_x)		\
+				({ typeof(_x) (x) = (_x); \
+				(0x3510 + PMAC_TBL_VAL_OFFSET * (x) * (x)); })
+#define PMAC_TBL_VAL_0_VAL0		GENMASK(15, 0)
+
+#define PMAC_TBL_VAL_SFT		4
+
+#define PMAC_TBL_ADDR_OFFSET		0x200
+#define PMAC_TBL_ADDR(_x)		\
+				({ typeof(_x) (x) = (_x); \
+				(0x3514 + PMAC_TBL_ADDR_OFFSET * (x) * (x)); })
+#define PMAC_TBL_ADDR_ADDR		GENMASK(11, 0)
+
+#define PMAC_TBL_CTRL_OFFSET		0x200
+#define PMAC_TBL_CTRL(_x)		\
+				({ typeof(_x) (x) = (_x); \
+				(0x3518 + PMAC_TBL_CTRL_OFFSET * (x) * (x)); })
+#define PMAC_TBL_CTRL_ADDR		GENMASK(2, 0)
+#define PMAC_TBL_CTRL_OPMOD		BIT(5)
+#define PMAC_TBL_CTRL_BAS		BIT(15)
+
+#define ETHSW_CTP_STARTID_OFFSET	8
+#define ETHSW_CTP_STARTID(x)		\
+				(0x3a00 + ETHSW_CTP_STARTID_OFFSET * (x))
+#define ETHSW_CTP_STARTID_STARTID	GENMASK(8, 0)
+#define ETHSW_CTP_STARTID_MD		GENMASK(15, 14)
+#define MD_WLAN8			0
+#define MD_WLAN9			1
+#define MD_OTHER			2
+
+#define ETHSW_CTP_ENDID_0		0x3a04
+#define ETHSW_CTP_ENDID(x)		\
+			(ETHSW_CTP_ENDID_0 + ETHSW_CTP_STARTID_OFFSET * (x))
+#define ETHSW_CTP_ENDID_ENDID		GENMASK(8, 0)
+
+#define ETHSW_GPID_STARTID_OFFSET	8
+#define ETHSW_GPID_STARTID(x)		\
+				(0x3a80 + ETHSW_GPID_STARTID_OFFSET * (x))
+#define ETHSW_GPID_STARTID_BITS		GENMASK(14, 12)
+#define ETHSW_GPID_STARTID_STARTID	GENMASK(7, 0)
+
+#define ETHSW_GPID_ENDID_OFFSET		8
+#define ETHSW_GPID_ENDID(x)		\
+				(0x3a84 + ETHSW_GPID_ENDID_OFFSET * (x))
+#define ETHSW_GPID_ENDID_ENDID		GENMASK(8, 0)
+
+#define GPID_RAM_VAL			0x3b00
+#define GPID_RAM_VAL_OV			BIT(15)
+#define GPID_RAM_VAL_SUBID_GRP		GENMASK(11, 4)
+#define GPID_RAM_VAL_LPID		GENMASK(3, 0)
+
+#define GPID_RAM_CTRL			0x3b04
+#define GPID_RAM_CTRL_BAS		BIT(15)
+#define GPID_RAM_CTRL_OPMOD		BIT(8)
+#define GPID_RAM_CTRL_ADDR		GENMASK(7, 0)
+
+/** GSWIP-O Top Register Description **/
+#define GSWIP_CFG			0x0000
+#define GSWIP_CFG_SS_HWRES_ON		BIT(1)
+#define GSWIP_CFG_CLK_MD		GENMASK(3, 2)
+#define GSWIP_CFG_CLK_MUX_SEL		GENMASK(12, 11)
+#define GSWIP_CFG_CORE_SE_EN		BIT(15)
+
+#define MACSEC_EN			0x0008
+#define GSWIPSS_IER0			0x0010
+
+#define GSWIPSS_ISR0			0x0014
+#define GSWIPSS_I_XGMAC2		BIT(2)
+#define GSWIPSS_I_XGMAC3		BIT(3)
+#define GSWIPSS_I_XGMAC4		BIT(4)
+#define GSWIPSS_I_XGMAC5		BIT(5)
+#define GSWIPSS_I_XGMAC6		BIT(6)
+#define GSWIPSS_I_XGMAC7		BIT(7)
+#define GSWIPSS_I_XGMAC8		BIT(8)
+#define GSWIPSS_I_XGMAC9		BIT(9)
+#define GSWIPSS_I_XGMAC10		BIT(10)
+
+#define GSWIPSS_IER1			0x0018
+#define GSWIPSS_ISR1			0x001c
+#define GSWIPSS_SPTAG_ETYPE		0x0038
+#define GSWIPSS_1588_CFG0		0x0050
+#define GSWIPSS_1588_CFG1		0x0054
+#define GSWIPSS_NCO1_LSB		0x0060
+#define GSWIPSS_NCO1_USB		0x0064
+#define GSWIPSS_NCO2_LSB		0x0068
+#define GSWIPSS_NC02_MSB		0x006c
+#define GSWIPSS_NCO3_LSB		0x0070
+#define GSWIPSS_NCO3_MSB		0x0074
+#define GSWIPSS_NC04_LSB		0x0078
+#define GSWIPSS_NC04_MSB		0x007c
+#define GSWIP_MEMLS0			0x0080
+#define GSWIP_MEMLS1			0x0084
+
+/* GSWIP-O Top: MAC Registers */
+#define MAC_IF_CFG			0X1200
+#define MAC_IF_CFG_CFG2G5		BIT(0)
+#define MAC_IF_CFG_CFG1G		BIT(1)
+#define MAC_IF_CFG_CFGFE		BIT(2)
+#define MAC_IF_CFG_PTP_DIS		BIT(11)
+#define MAC_IF_CFG_MAC_EN		BIT(12)
+#define MAC_IF_CFG_XGMAC_RES		BIT(13)
+#define MAC_IF_CFG_LMAC_RES		BIT(14)
+#define MAC_IF_CFG_ADAP_RES		BIT(15)
+
+#define MAC_OP_CFG			0X1204
+#define MAC_OP_CFG_RX_SPTAG		GENMASK(1, 0)
+#define MAC_OP_CFG_RX_TIME		GENMASK(3, 2)
+#define MAC_OP_CFG_RX_FCS		GENMASK(5, 4)
+#define MAC_OP_CFG_RX_FCS_M0		0x00
+#define MAC_OP_CFG_RX_FCS_M1		0x01
+#define MAC_OP_CFG_RX_FCS_M2		0X02
+#define MAC_OP_CFG_RX_FCS_M3		0x03
+
+#define MAC_MTU_CFG			0X1208
+#define MAC_MTU_CFG_MTU			GENMASK(13, 0)
+
+#define PHY_MODE			0x1270
+#define PHY_MODE_FCONRX			GENMASK(6, 5)
+#define PHY_MODE_FCONTX			GENMASK(8, 7)
+#define PHY_MODE_FCON_AUTO		0x00
+#define PHY_MODE_FCON_EN		0x01
+#define PHY_MODE_FCON_DIS		0x11
+#define PHY_MODE_FDUP			GENMASK(10, 9)
+#define PHY_MODE_FDUP_AUTO		0x00
+#define PHY_MODE_FDUP_FD		0x01
+#define PHY_MODE_FDUP_HD		0x11
+#define PHY_MODE_SPEED_LSB		GENMASK(12, 11)
+#define PHY_MODE_LINKST			GENMASK(14, 13)
+#define PHY_MODE_LINKST_AUTO		0x00
+#define PHY_MODE_LINKST_UP		0x01
+#define PHY_MODE_LINKST_DOWN		0x10
+#define PHY_MODE_SPEED_MSB		BIT(15)
+#define PHY_MODE_SPEED_10M		0x000
+#define PHY_MODE_SPEED_100M		0x001
+#define PHY_MODE_SPEED_1G		0x010
+#define PHY_MODE_SPEED_10G		0x011
+#define PHY_MODE_SPEED_2G5		0x100
+#define PHY_MODE_SPEED_5G		0x101
+#define PHY_MODE_SPEED_FLEX		0x110
+#define PHY_MODE_SPEED_AUTO		0x111
+
+#define PHY_STAT			0x1274
+#define PHY_STAT_FDUP			BIT(2)
+#define PHY_STAT_SPEED_LSB		GENMASK(4, 3)
+#define PHY_STAT_LSTAT			BIT(5)
+#define PHY_STAT_SPEED_MSB		BIT(11)
+
+#define ANEG_EEE			0x1278
+#define ANEG_EEE_CAP			GENMASK(1, 0)
+#define ANEG_EEE_CAP_AUTO		0x00
+#define ANEG_EEE_CAP_ON			0x01
+#define ANEG_EEE_CAP_OFF		0x11
+#define ANEG_EEE_CLK_STOP_CAP		GENMASK(3, 2)
+
+#define MAC_Q_INC			0x100
+#define MAC_IF_CFG_REG(x)		(MAC_IF_CFG + ((x) - MAC2) * MAC_Q_INC)
+#define MAC_OP_CFG_REG(x)		(MAC_OP_CFG + ((x) - MAC2) * MAC_Q_INC)
+#define MAC_MTU_CFG_REG(x)		\
+				(MAC_MTU_CFG + ((x) - MAC2) * MAC_Q_INC)
+#define PHY_MODE_REG(x)			(PHY_MODE + ((x) - MAC2) * MAC_Q_INC)
+#define PHY_STAT_REG(x)			(PHY_STAT + ((x) - MAC2) * MAC_Q_INC)
+#define ANEG_EEE_REG(x)			(ANEG_EEE + ((x) - MAC2) * MAC_Q_INC)
+
+/* GSWIP-O TOP: XGMAC indirect access */
+#define XGMAC_CTRL			0x1280
+#define XGMAC_REGACC_DATA0		0x1290
+#define XGMAC_REGACC_DATA1		0x1294
+
+#define XGMAC_REGACC_CTRL		0x1298
+#define XGMAC_REGACC_CTRL_ADDR		GENMASK(13, 0)
+#define XGMAC_REGACC_CTRL_OPMOD_WR	BIT(14)
+#define XGMAC_REGACC_CTRL_ADDR_BAS	BIT(15)
+
+/** Legacy MAC Register Description **/
+
+/* Legacy MAC: Common Registers */
+#define MAC_TEST			0x0300
+#define MAC_PFAD_CFG			0x0304
+#define MAC_PFSA_0			0x0308
+#define MAC_PFSA_1			0x030c
+#define MAC_PFSA_2			0x0310
+#define LMAC_IER			0x0320
+#define LMAC_ISR			0x0324
+#define LMAC_I_MAC2			BIT(0)
+
+#define LMAC_CNT_LSB			0x0328
+#define LMAC_CNT_MSB			0x032c
+#define LMAC_CNT_ACC			0x0330
+
+/* Legacy MAC: Single MAC Registers */
+#define MAC_CTRL0			0x040c
+#define MAC_CTRL0_GMII			GENMASK(1, 0)
+#define MAC_CTRL0_FDUP			GENMASK(3, 2)
+#define MAC_CTRL0_FCON			GENMASK(5, 4)
+#define MAC_CTRL0_FCS			BIT(7)
+#define MAC_CTRL0_PADEN			BIT(8)
+#define MAC_CTRL0_VPADEN		BIT(9)
+#define MAC_CTRL0_VPAD2EN		BIT(10)
+#define MAC_CTRL0_APADEN		BIT(11)
+
+#define LMAC_Q_INC			0x30
+#define MAC_CTRL0_REG(x)		(MAC_CTRL0 + ((x) - MAC2) * LMAC_Q_INC)
+
+#endif /* _GSWIP_REG_H_ */
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.c b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.c
new file mode 100644
index 000000000000..18e75e75d7ab
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.c
@@ -0,0 +1,332 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation.*/
+#include <linux/kernel.h>
+
+#include "gswip_core.h"
+#include "gswip_reg.h"
+#include "gswip_tbl.h"
+
+enum tbl_opmode {
+	TBL_RD,
+	TBL_WR,
+};
+
+enum tbl_busy_indication {
+	TBL_READY,
+	TBL_BUSY,
+};
+
+enum pce_tbl_opmode {
+	/* Address-based read access  */
+	PCE_OPMODE_ADRD,
+	/* Address-based write access */
+	PCE_OPMODE_ADWR,
+	/* Key-based read access      */
+	PCE_OPMODE_KSRD,
+	/* Key-based write access     */
+	PCE_OPMODE_KSWR
+};
+
+struct pce_tbl_config {
+	u16 num_key;
+	u16 num_mask;
+	u16 num_val;
+};
+
+struct pce_tbl_reg_map {
+	const u16 *key;
+	const u16 *mask;
+	const u16 *value;
+};
+
+static const u16 pce_tbl_key[] = {
+	PCE_TBL_KEY_0, PCE_TBL_KEY_1,   PCE_TBL_KEY_2, PCE_TBL_KEY_3,
+	PCE_TBL_KEY_4, PCE_TBL_KEY_5,   PCE_TBL_KEY_6, PCE_TBL_KEY_7,
+	PCE_TBL_KEY_8, PCE_TBL_KEY_9,   PCE_TBL_KEY_10, PCE_TBL_KEY_11,
+	PCE_TBL_KEY_12, PCE_TBL_KEY_13, PCE_TBL_KEY_14, PCE_TBL_KEY_15,
+	PCE_TBL_KEY_16, PCE_TBL_KEY_17, PCE_TBL_KEY_18, PCE_TBL_KEY_19,
+	PCE_TBL_KEY_20, PCE_TBL_KEY_21, PCE_TBL_KEY_22, PCE_TBL_KEY_23,
+	PCE_TBL_KEY_24, PCE_TBL_KEY_25, PCE_TBL_KEY_26, PCE_TBL_KEY_27,
+	PCE_TBL_KEY_28, PCE_TBL_KEY_29, PCE_TBL_KEY_30, PCE_TBL_KEY_31,
+	PCE_TBL_KEY_32, PCE_TBL_KEY_33,
+};
+
+static const u16 pce_tbl_mask[] = {
+	PCE_TBL_MASK_0, PCE_TBL_MASK_1, PCE_TBL_MASK_2, PCE_TBL_MASK_3,
+};
+
+static const u16 pce_tbl_value[] = {
+	PCE_TBL_VAL_0, PCE_TBL_VAL_1,   PCE_TBL_VAL_2, PCE_TBL_VAL_3,
+	PCE_TBL_VAL_4, PCE_TBL_VAL_5,   PCE_TBL_VAL_6, PCE_TBL_VAL_7,
+	PCE_TBL_VAL_8, PCE_TBL_VAL_9,   PCE_TBL_VAL_10, PCE_TBL_VAL_11,
+	PCE_TBL_VAL_12, PCE_TBL_VAL_13, PCE_TBL_VAL_14, PCE_TBL_VAL_15,
+	PCE_TBL_VAL_16, PCE_TBL_VAL_17, PCE_TBL_VAL_18, PCE_TBL_VAL_19,
+	PCE_TBL_VAL_20, PCE_TBL_VAL_21, PCE_TBL_VAL_22, PCE_TBL_VAL_23,
+	PCE_TBL_VAL_24, PCE_TBL_VAL_25, PCE_TBL_VAL_26, PCE_TBL_VAL_27,
+	PCE_TBL_VAL_28, PCE_TBL_VAL_29, PCE_TBL_VAL_30,
+};
+
+/* PCE table default entries for Key, Mask and Value.
+ * Only minimum entries settings are required by default.
+ */
+static const struct pce_tbl_config pce_tbl_def_cfg[] = {
+	/* Parser ucode table                      */
+	{ 0,  0,  4 },
+	/* Dummy                                   */
+	{ 0,  0,  0 },
+	/* VLAN filter table                       */
+	{ 1,  0,  1 },
+	/* PPPoE table                             */
+	{ 1,  0,  0 },
+	/* Protocol table                          */
+	{ 1,  1,  0 },
+	/* Application table                       */
+	{ 1,  1,  0 },
+	/* IP DA/SA MSB table                      */
+	{ 4,  4,  0 },
+	/* IP DA/SA LSB table                      */
+	{ 4,  4,  0 },
+	/* Packet length table                     */
+	{ 1,  1,  0 },
+	/* Inner PCP/DEI table                     */
+	{ 0,  0,  1 },
+	/* DSCP table                              */
+	{ 0,  0,  1 },
+	/* MAC bridging table                      */
+	{ 4,  0,  10},
+	/* DSCP2PCP configuration table            */
+	{ 0,  0,  2 },
+	/* Multicast SW table                      */
+	{ 19, 0,  10},
+	/* Dummy                                   */
+	{ 0,  0,  0 },
+	/* Traffic Flow table                      */
+	{ 34, 0,  31},
+	/* PBB tunnel template configuration table */
+	{ 0,  0,  11},
+	/* Queue mapping table                     */
+	{ 0,  0,  1 },
+	/* Ingress CTP port configuration table    */
+	{ 0,  0,  9 },
+	/* Egress CTP port configuration table     */
+	{ 0,  0,  7 },
+	/* Ingress bridge port configuration table */
+	{ 0,  0,  18},
+	/* Egress bridge port configuration table  */
+	{ 0,  0,  14},
+	/* MAC DA table                            */
+	{ 3,  1,  0 },
+	/* MAC SA table                            */
+	{ 3,  1,  0 },
+	/* Flags table                             */
+	{ 1,  1,  0 },
+	/* Bridge configuration table              */
+	{ 0,  0,  10},
+	/* Outer PCP/DEI table                     */
+	{ 0,  0,  1 },
+	/* Color marking table                     */
+	{ 0,  0,  1 },
+	/* Color remarking table                   */
+	{ 0,  0,  1 },
+	/* Payload table                           */
+	{ 1,  1,  0 },
+	/* Extended VLAN operation table           */
+	{ 4,  0,  6 },
+	/* P-mapping configuration table           */
+	{ 0,  0,  1 },
+};
+
+int gswip_pce_table_write(struct gswip_core_priv *priv,
+			  struct pce_tbl_prog *pce_tbl)
+{
+	struct regmap *regmap = priv->regmap;
+	u16 i, ctrl;
+
+	spin_lock(&priv->tbl_lock);
+
+	/* update key registers */
+	for (i = 0; i < pce_tbl_def_cfg[pce_tbl->id].num_key; i++)
+		regmap_write(regmap, pce_tbl_key[i], pce_tbl->key[i]);
+
+	/* update mask registers */
+	for (i = 0; i < pce_tbl_def_cfg[pce_tbl->id].num_mask; i++)
+		regmap_write(regmap, pce_tbl_mask[i], pce_tbl->mask[i]);
+
+	/* update value registers */
+	for (i = 0; i < pce_tbl_def_cfg[pce_tbl->id].num_val; i++)
+		regmap_write(regmap, pce_tbl_value[i], pce_tbl->val[i]);
+
+	ctrl = FIELD_PREP(PCE_TBL_CTRL_ADDR, pce_tbl->id) |
+	       FIELD_PREP(PCE_TBL_CTRL_OPMOD, PCE_OPMODE_ADWR) |
+	       FIELD_PREP(PCE_TBL_CTRL_BAS, TBL_BUSY);
+
+	/* update the pce table */
+	regmap_write(regmap, PCE_TBL_ADDR, pce_tbl->addr);
+	regmap_write(regmap, PCE_TBL_CTRL, ctrl);
+
+	if (tbl_rw_tmout(priv, PCE_TBL_CTRL, PCE_TBL_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to write pce table\n");
+		spin_unlock(&priv->tbl_lock);
+		return -EBUSY;
+	}
+
+	spin_unlock(&priv->tbl_lock);
+
+	return 0;
+}
+
+int gswip_pce_table_read(struct gswip_core_priv *priv,
+			 struct pce_tbl_prog *pce_tbl)
+{
+	u16 i, ctrl;
+
+	spin_lock(&priv->tbl_lock);
+
+	regmap_write(priv->regmap, PCE_TBL_ADDR, pce_tbl->addr);
+
+	ctrl = FIELD_PREP(PCE_TBL_CTRL_ADDR, pce_tbl->id) |
+	       FIELD_PREP(PCE_TBL_CTRL_OPMOD, PCE_OPMODE_ADRD) |
+	       FIELD_PREP(PCE_TBL_CTRL_BAS, TBL_BUSY);
+	regmap_write(priv->regmap, PCE_TBL_CTRL, ctrl);
+
+	if (tbl_rw_tmout(priv, PCE_TBL_CTRL, PCE_TBL_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to read pce table\n");
+		spin_unlock(&priv->tbl_lock);
+		return -EBUSY;
+	}
+
+	for (i = 0; i < pce_tbl_def_cfg[pce_tbl->id].num_key; i++)
+		reg_r16(priv, pce_tbl_key[i], &pce_tbl->key[i]);
+
+	for (i = 0; i < pce_tbl_def_cfg[pce_tbl->id].num_mask; i++)
+		reg_r16(priv, pce_tbl_mask[i], &pce_tbl->mask[i]);
+
+	for (i = 0; i < pce_tbl_def_cfg[pce_tbl->id].num_val; i++)
+		reg_r16(priv, pce_tbl_value[i], &pce_tbl->val[i]);
+
+	spin_unlock(&priv->tbl_lock);
+
+	return 0;
+}
+
+int gswip_bm_table_write(struct gswip_core_priv *priv,
+			 struct bm_tbl_prog *bm_tbl)
+{
+	struct regmap *regmap = priv->regmap;
+	u16 ctrl;
+	int i;
+
+	spin_lock(&priv->tbl_lock);
+
+	for (i = 0; i < bm_tbl->num_val; i++)
+		regmap_write(regmap, (BM_RAM_VAL_0 - i * BM_RAM_VAL_OFFSET),
+			     bm_tbl->val[i]);
+
+	regmap_write(regmap, BM_RAM_ADDR, bm_tbl->addr);
+
+	ctrl = bm_tbl->id;
+	ctrl |= FIELD_PREP(BM_RAM_CTRL_OPMOD, TBL_WR);
+	ctrl |= FIELD_PREP(BM_RAM_CTRL_BAS, TBL_BUSY);
+	regmap_write(regmap, BM_RAM_CTRL, ctrl);
+
+	if (tbl_rw_tmout(priv, BM_RAM_CTRL, BM_RAM_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to write bm table\n");
+		spin_unlock(&priv->tbl_lock);
+		return -EBUSY;
+	}
+
+	spin_unlock(&priv->tbl_lock);
+
+	return 0;
+}
+
+int gswip_bm_table_read(struct gswip_core_priv *priv,
+			struct bm_tbl_prog *bm_tbl)
+{
+	u16 ctrl;
+	int i;
+
+	spin_lock(&priv->tbl_lock);
+
+	regmap_write(priv->regmap, BM_RAM_ADDR, bm_tbl->addr);
+
+	ctrl = FIELD_PREP(BM_RAM_CTRL_ADDR, bm_tbl->id) |
+	       FIELD_PREP(BM_RAM_CTRL_OPMOD, TBL_RD) |
+	       FIELD_PREP(BM_RAM_CTRL_BAS, TBL_BUSY);
+	regmap_write(priv->regmap, BM_RAM_CTRL, ctrl);
+
+	if (tbl_rw_tmout(priv, BM_RAM_CTRL, BM_RAM_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to read bm table\n");
+		spin_unlock(&priv->tbl_lock);
+		return -EBUSY;
+	}
+
+	for (i = 0; i < bm_tbl->num_val; i++)
+		reg_r16(priv, (BM_RAM_VAL_0 - i * BM_RAM_VAL_OFFSET),
+			&bm_tbl->val[i]);
+
+	spin_unlock(&priv->tbl_lock);
+
+	return 0;
+}
+
+int gswip_pmac_table_write(struct gswip_core_priv *priv,
+			   struct pmac_tbl_prog *pmac_tbl)
+{
+	u16 pmac_id = pmac_tbl->pmac_id, ctrl;
+	int i;
+
+	spin_lock(&priv->tbl_lock);
+
+	for (i = 0; i < pmac_tbl->num_val; i++)
+		regmap_write(priv->regmap,
+			     (PMAC_TBL_VAL(pmac_id) - i * PMAC_TBL_VAL_SFT),
+			     pmac_tbl->val[i]);
+
+	regmap_write(priv->regmap, PMAC_TBL_ADDR(pmac_id), pmac_tbl->addr);
+
+	ctrl = FIELD_PREP(PMAC_TBL_CTRL_ADDR, pmac_tbl->id) |
+	       FIELD_PREP(PMAC_TBL_CTRL_OPMOD, TBL_WR) |
+	       FIELD_PREP(PMAC_TBL_CTRL_BAS, TBL_BUSY);
+	regmap_write(priv->regmap, PMAC_TBL_CTRL(pmac_id), ctrl);
+
+	if (tbl_rw_tmout(priv, PMAC_TBL_CTRL(pmac_id), PMAC_TBL_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to write pmac table\n");
+		spin_unlock(&priv->tbl_lock);
+		return -EBUSY;
+	}
+
+	spin_unlock(&priv->tbl_lock);
+
+	return 0;
+}
+
+int gswip_pmac_table_read(struct gswip_core_priv *priv,
+			  struct pmac_tbl_prog *pmac_tbl)
+{
+	u16 pmac_id = pmac_tbl->pmac_id, ctrl;
+	int i;
+
+	spin_lock(&priv->tbl_lock);
+
+	regmap_write(priv->regmap, PMAC_TBL_ADDR(pmac_id), pmac_tbl->addr);
+
+	ctrl = FIELD_PREP(PMAC_TBL_CTRL_ADDR, pmac_tbl->id) |
+	       FIELD_PREP(PMAC_TBL_CTRL_OPMOD, TBL_RD) |
+	       FIELD_PREP(PMAC_TBL_CTRL_BAS, TBL_BUSY);
+	regmap_write(priv->regmap, PMAC_TBL_CTRL(pmac_id), ctrl);
+
+	if (tbl_rw_tmout(priv, PMAC_TBL_CTRL(pmac_id), PMAC_TBL_CTRL_BAS)) {
+		dev_err(priv->dev, "failed to read pmac table\n");
+		spin_unlock(&priv->tbl_lock);
+		return -EBUSY;
+	}
+
+	for (i = 0; i < pmac_tbl->num_val; i++)
+		reg_r16(priv, (PMAC_TBL_VAL(pmac_id) - i * PMAC_TBL_VAL_SFT),
+			&pmac_tbl->val[i]);
+
+	spin_unlock(&priv->tbl_lock);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.h b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.h
new file mode 100644
index 000000000000..527a6b71910c
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/gswip_tbl.h
@@ -0,0 +1,194 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2016-2019 Intel Corporation. */
+#ifndef _GSW_TBL_RW_H_
+#define _GSW_TBL_RW_H_
+
+#define PCE_TBL_KEY_NUM		34
+#define PCE_TBL_VAL_NUM		31
+#define PCE_TBL_MASK_NUM	4
+#define PCE_MAC_LIMIT_NUM	255
+
+/* PCE queue mapping table */
+#define PCE_Q_MAP_LOCAL_EXTRACT			BIT(8)
+#define PCE_Q_MAP_IG_PORT_MODE			BIT(9)
+#define PCE_Q_MAP_EG_PID			GENMASK(7, 4)
+
+/* PCE ingress CTP port configuration table */
+#define PCE_IGCTP_VAL4_BYPASS_BR		BIT(15)
+
+/* PCE ingress bridge port configuration table */
+#define PCE_IGBGP_VAL10_PORT_MAP_0		10
+#define PCE_IGBGP_VAL4_LRN_LIMIT		GENMASK(7, 0)
+#define PCE_IGBGP_VAL4_BR_ID			GENMASK(13, 8)
+
+/* PCE EGBGP table */
+#define PCE_EGBGP_VAL4_DST_SUBIF_ID_GRP		GENMASK(7, 0)
+#define PCE_EGBGP_VAL4_DST_LPID			GENMASK(11, 8)
+#define PCE_EGBGP_VAL4_PMAPPER			BIT(14)
+
+/* PCE_BRGCFG table */
+#define PCE_BRGCFG_VAL1_BCAST_FW_MODE		GENMASK(1, 0)
+#define PCE_BRGCFG_VAL1_UCAST_FW_MODE		GENMASK(3, 2)
+#define PCE_BRGCFG_VAL1_MCAST_NIP_FW_MODE	GENMASK(5, 4)
+#define PCE_BRGCFG_VAL1_MCAST_IP_FW_MODE	GENMASK(7, 6)
+#define PCE_BRGCFG_VAL3_LRN_DISC_CNT		GENMASK(31, 16)
+
+/* BM_PQM_THRES table */
+#define BM_PQM_THRES_Q_NUM			GENMASK(7, 3)
+
+/* BM_Q_MAP table */
+#define BM_Q_MAP_VAL4_REDIR_PID			GENMASK(2, 0)
+#define BM_Q_MAP_VAL4_REDIR_PID_MSB		BIT(3)
+#define BM_Q_MAP_VAL4_REDIR_PID_BIT4		BIT(4)
+
+enum pce_tbl_id {
+	PCE_TFLOW	= 0x0f,
+	PCE_Q_MAP	= 0x11,
+	PCE_IG_CTP_CFG	= 0x12,
+	PCE_EG_CTP_CFG	= 0x13,
+	PCE_IG_BRP_CFG	= 0x14,
+	PCE_EG_BRP_CFG	= 0x15,
+	PCE_BR_CFG	= 0x19,
+	PCE_PMAP	= 0x1f,
+};
+
+#define PCE_TBL_KEY_NUM		34
+#define PCE_TBL_VAL_NUM		31
+#define PCE_TBL_MASK_NUM	4
+
+/* PCE programming table */
+struct pce_tbl_prog {
+	enum pce_tbl_id id;
+	u16 val[PCE_TBL_VAL_NUM];
+	u16 key[PCE_TBL_KEY_NUM];
+	u16 mask[PCE_TBL_MASK_NUM];
+	u16 addr;
+};
+
+/* BM programming table */
+enum bm_tbl_id {
+	BM_CTP_RX_RMON		= 0x00,
+	BM_CTP_TX_RMON		= 0x01,
+	BM_BR_RX_RMON		= 0x02,
+	BM_BR_TX_RMON		= 0x03,
+	BM_CTP_PCE_BYPASS_RMON	= 0x04,
+	BM_TFLOW_RX_RMON	= 0x05,
+	BM_TFLOW_TX_RMON	= 0x06,
+	BM_WFQ_PARAM		= 0x07,
+	BM_PQM_THRES		= 0x09,
+	BM_Q_MAP		= 0x0e,
+	BM_PMAC_CNTR		= 0x1c
+};
+
+#define BM_RAM_VAL_MAX		10
+
+struct rmon_cntr_tbl {
+	u16 ctr_offset : 6;
+	u16 port_offset : 10;
+};
+
+struct qmap_tbl {
+	u16 qid : 6;
+	u16 reserved : 10;
+};
+
+struct pmac_cntr_tbl {
+	u16 addr : 5;
+	u16 ctr_offset : 3;
+	u16 pmac_id : 3;
+	u16 reserved : 1;
+	u16 ctr_offset_hdr : 1;
+	u16 reserved1 : 3;
+};
+
+struct bm_tbl_prog {
+	enum bm_tbl_id id;
+	union {
+		struct rmon_cntr_tbl rmon_cntr;
+		struct qmap_tbl qmap;
+		struct pmac_cntr_tbl pmac_cntr;
+		u16 addr;
+	};
+	u16 val[BM_RAM_VAL_MAX];
+	u32 num_val;
+};
+
+/* PMAC programming table */
+enum pmac_tbl_id {
+	PMAC_BP_MAP,
+	PMAC_IG_CFG,
+	PMAC_EG_CFG,
+};
+
+#define PMAC_BP_MAP_TBL_VAL_NUM		3
+#define PMAC_IG_CFG_TBL_VAL_NUM		5
+#define PMAC_EG_CFG_TBL_VAL_NUM		3
+#define PMAC_TBL_VAL_MAX		11
+
+/* PMAC_BP_MAP table */
+/* Table Control */
+#define PMAC_BPMAP_TX_DMA_CH		GENMASK(4, 0)
+/* PMAC_TBL_VAL_2 */
+#define PMAC_BPMAP_TX_Q_UPPER		GENMASK(31, 16)
+
+/* PMAC_IG_CFG table */
+/* Table Control */
+#define PMAC_IGCFG_TX_DMA_CH		GENMASK(4, 0)
+/* PMAC_TBL_VAL_2 */
+#define PMAC_IGCFG_HDR_ID		GENMASK(7, 4)
+/* PMAC_TBL_VAL_4 */
+#define PMAC_IGCFG_VAL4_PMAC_FLAG	BIT(0)
+#define PMAC_IGCFG_VAL4_SPPID_MODE	BIT(1)
+#define PMAC_IGCFG_VAL4_SUBID_MODE	BIT(2)
+#define PMAC_IGCFG_VAL4_CLASSEN_MODE	BIT(3)
+#define PMAC_IGCFG_VAL4_CLASS_MODE	BIT(5)
+#define PMAC_IGCFG_VAL4_ERR_DP		BIT(7)
+
+/* PMAC_EG_CFG table */
+/* Table Control */
+#define PMAC_EGCFG_DST_PORT_ID		GENMASK(3, 0)
+#define PMAC_EGCFG_MPE1			BIT(4)
+#define PMAC_EGCFG_MPE2			BIT(5)
+#define PMAC_EGCFG_ECRYPT		BIT(6)
+#define PMAC_EGCFG_DECRYPT		BIT(7)
+#define PMAC_EGCFG_TC_4BITS		GENMASK(7, 4)
+#define PMAC_EGCFG_TC_2BITS		GENMASK(7, 6)
+#define PMAC_EGCFG_FLOW_ID_MSB		GENMASK(9, 8)
+/* PMAC_TBL_VAL_0 */
+#define PMAC_EGCFG_VAL0_RES_2BITS	GENMASK(1, 0)
+#define PMAC_EGCFG_VAL0_RES_3BITS	GENMASK(4, 2)
+#define PMAC_EGCFG_VAL0_REDIR		BIT(4)
+#define PMAC_EGCFG_VAL0_BSL		GENMASK(7, 5)
+/* PMAC_TBL_VAL_1 */
+#define PMAC_EGCFG_VAL1_RX_DMA_CH	GENMASK(3, 0)
+/* PMAC_TBL_VAL_2 */
+#define PMAC_EGCFG_VAL2_PMAC_FLAG	BIT(0)
+#define PMAC_EGCFG_VAL2_FCS_MODE	BIT(1)
+#define PMAC_EGCFG_VAL2_L2HD_RM_MODE	BIT(2)
+#define PMAC_EGCFG_VAL2_L2HD_RM		GENMASK(15, 8)
+
+struct pmac_tbl_prog {
+	u16 pmac_id;
+	enum pmac_tbl_id id;
+	u16 val[PMAC_TBL_VAL_MAX];
+	u8 num_val;
+	u16 addr;
+};
+
+struct gswip_core_priv;
+
+int gswip_pce_table_init(void);
+int gswip_pce_table_write(struct gswip_core_priv *priv,
+			  struct pce_tbl_prog *pce_tbl);
+int gswip_pce_table_read(struct gswip_core_priv *priv,
+			 struct pce_tbl_prog *pce_tbl);
+int gswip_bm_table_read(struct gswip_core_priv *priv,
+			struct bm_tbl_prog *bm_tbl);
+int gswip_bm_table_write(struct gswip_core_priv *priv,
+			 struct bm_tbl_prog *bm_tbl);
+int gswip_pmac_table_read(struct gswip_core_priv *priv,
+			  struct pmac_tbl_prog *pmac_tbl);
+int gswip_pmac_table_write(struct gswip_core_priv *priv,
+			   struct pmac_tbl_prog *pmac_tbl);
+
+#endif
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/lmac.c b/drivers/net/ethernet/intel/gwdpa/gswip/lmac.c
new file mode 100644
index 000000000000..2fef9eaeeadc
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/lmac.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation. */
+
+#include <linux/bitfield.h>
+#include <linux/types.h>
+
+#include "mac_common.h"
+
+int lmac_set_duplex_mode(struct gswip_mac *priv, u32 val)
+{
+	u32 mac_ctrl0 = lmac_read(priv, MAC_CTRL0_REG(priv->mac_idx));
+
+	if (FIELD_GET(MAC_CTRL0_FDUP, mac_ctrl0) != val) {
+		mac_ctrl0 &= ~MAC_CTRL0_FDUP;
+		mac_ctrl0 |= FIELD_PREP(MAC_CTRL0_FDUP, val);
+		lmac_write(priv, MAC_CTRL0_REG(priv->mac_idx), mac_ctrl0);
+	}
+
+	return 0;
+}
+
+int lmac_set_flowcon_mode(struct gswip_mac *priv, u32 val)
+{
+	u32 mac_ctrl0 = lmac_read(priv, MAC_CTRL0_REG(priv->mac_idx));
+
+	if (FIELD_GET(MAC_CTRL0_FCON, mac_ctrl0) != val) {
+		mac_ctrl0 &= ~MAC_CTRL0_FCON;
+		mac_ctrl0 |= FIELD_PREP(MAC_CTRL0_FCON, val);
+		lmac_write(priv, MAC_CTRL0_REG(priv->mac_idx), mac_ctrl0);
+	}
+
+	return 0;
+}
+
+int lmac_set_intf_mode(struct gswip_mac *priv, u32 val)
+{
+	u32 mac_ctrl0 = lmac_read(priv, MAC_CTRL0_REG(priv->mac_idx));
+
+	if (FIELD_GET(MAC_CTRL0_GMII, mac_ctrl0) != val) {
+		mac_ctrl0 &= ~MAC_CTRL0_GMII;
+		mac_ctrl0 |= FIELD_PREP(MAC_CTRL0_GMII, val);
+		lmac_write(priv, MAC_CTRL0_REG(priv->mac_idx), mac_ctrl0);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/mac_cfg.c b/drivers/net/ethernet/intel/gwdpa/gswip/mac_cfg.c
new file mode 100644
index 000000000000..2a0093d246cf
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/mac_cfg.c
@@ -0,0 +1,524 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation. */
+
+#include <linux/bitfield.h>
+#include <linux/ethtool.h>
+#include "mac_common.h"
+
+static int mac_speed_to_val(u32 speed)
+{
+	int val;
+
+	switch (speed) {
+	case SPEED_10M:
+		val = SPEED_10;
+		break;
+	case SPEED_100M:
+		val = SPEED_100;
+		break;
+	case SPEED_1G:
+		val = SPEED_1000;
+		break;
+	case SPEED_10G:
+		val = SPEED_10000;
+		break;
+	case SPEED_2G5:
+		val = SPEED_2500;
+		break;
+	case SPEED_5G:
+		val = SPEED_5000;
+		break;
+	default:
+		val = SPEED_UNKNOWN;
+	}
+
+	return val;
+}
+
+static int mac_get_speed(struct device *dev)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+	u32 mac_speed;
+
+	spin_lock_bh(&priv->mac_lock);
+	mac_speed = sw_get_speed(priv);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return mac_speed_to_val(mac_speed);
+}
+
+static int mac_set_physpeed(struct gswip_mac *priv, u32 phy_speed)
+{
+	spin_lock_bh(&priv->mac_lock);
+	xgmac_set_extcfg(priv, 1);
+
+	switch (phy_speed) {
+	default:
+	case SPEED_MAC_AUTO:
+		sw_set_speed(priv, SPEED_AUTO);
+		break;
+
+	case SPEED_XGMAC_10G:
+		xgmac_set_xgmii_speed(priv);
+		sw_set_speed(priv, SPEED_10G);
+		break;
+
+	case SPEED_GMII_25G:
+		sw_set_speed(priv, SPEED_2G5);
+		sw_set_2G5_intf(priv, XGMAC_GMII);
+		xgmac_set_gmii_2500_speed(priv);
+		break;
+
+	case SPEED_XGMII_25G:
+		sw_set_speed(priv, SPEED_2G5);
+		sw_set_2G5_intf(priv, XGMAC_XGMII);
+		xgmac_set_xgmii_2500_speed(priv);
+		break;
+
+	case SPEED_XGMAC_1G:
+		sw_set_speed(priv, SPEED_1G);
+		sw_set_1g_intf(priv, XGMAC_GMII);
+		xgmac_set_gmii_speed(priv);
+		xgmac_set_extcfg(priv, 1);
+		break;
+
+	case SPEED_XGMAC_10M:
+		sw_set_speed(priv, SPEED_10M);
+		fallthrough;
+	case SPEED_XGMAC_100M:
+		if (phy_speed != SPEED_XGMAC_10M)
+			sw_set_speed(priv, SPEED_100M);
+
+		sw_set_fe_intf(priv, XGMAC_GMII);
+		sw_set_1g_intf(priv, XGMAC_GMII);
+		xgmac_set_gmii_speed(priv);
+		break;
+
+	case SPEED_LMAC_10M:
+		sw_set_speed(priv, SPEED_10M);
+		fallthrough;
+	case SPEED_LMAC_100M:
+		if (phy_speed != SPEED_LMAC_10M)
+			sw_set_speed(priv, SPEED_100M);
+
+		sw_set_fe_intf(priv, LMAC_MII);
+		lmac_set_intf_mode(priv, 1);
+		break;
+
+	case SPEED_LMAC_1G:
+		sw_set_speed(priv, SPEED_1G);
+		sw_set_1g_intf(priv, LMAC_GMII);
+		lmac_set_intf_mode(priv, 2);
+		break;
+	}
+	spin_unlock_bh(&priv->mac_lock);
+
+	return 0;
+}
+
+static int mac_set_duplex(struct gswip_mac *priv, u32 mode)
+{
+	u32 val;
+
+	spin_lock_bh(&priv->mac_lock);
+	switch (mode) {
+	default:
+	case GSW_DUPLEX_AUTO:
+		val = PHY_MODE_FDUP_AUTO;
+		break;
+	case GSW_DUPLEX_HALF:
+		val = PHY_MODE_FDUP_HD;
+		break;
+	case GSW_DUPLEX_FULL:
+		val = PHY_MODE_FDUP_FD;
+		break;
+	}
+
+	sw_set_duplex_mode(priv, val);
+	lmac_set_duplex_mode(priv, val);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return 0;
+}
+
+static int mac_get_duplex(struct device *dev)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+	int val;
+
+	spin_lock_bh(&priv->mac_lock);
+	val = sw_get_duplex_mode(priv);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return val;
+}
+
+static int mac_get_linksts(struct device *dev)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+	int linksts;
+
+	spin_lock_bh(&priv->mac_lock);
+	linksts = sw_get_linkstatus(priv);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return linksts;
+}
+
+static int mac_set_linksts(struct gswip_mac *priv, u32 mode)
+{
+	u8 val;
+
+	spin_lock_bh(&priv->mac_lock);
+	switch (mode) {
+	default:
+	case LINK_AUTO:
+		val = PHY_MODE_LINKST_AUTO;
+		break;
+
+	case LINK_UP:
+		val = PHY_MODE_LINKST_UP;
+		break;
+
+	case LINK_DOWN:
+		val = PHY_MODE_LINKST_DOWN;
+		break;
+	}
+	sw_set_linkstatus(priv, val);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return 0;
+}
+
+static int mac_set_flowctrl(struct device *dev, u32 val)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+
+	if (val >= FC_INVALID)
+		return -EINVAL;
+
+	spin_lock_bh(&priv->mac_lock);
+	lmac_set_flowcon_mode(priv, val);
+
+	switch (val) {
+	default:
+	case FC_AUTO:
+		xgmac_tx_flow_ctl(priv, priv->pause_time, XGMAC_FC_EN);
+		xgmac_rx_flow_ctl(priv, XGMAC_FC_EN);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_AUTO, FCONRX);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_AUTO, FCONTX);
+		break;
+
+	case FC_RX:
+		/* Disable TX in XGMAC and GSWSS */
+		xgmac_tx_flow_ctl(priv, priv->pause_time, XGMAC_FC_DIS);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_DIS, FCONTX);
+
+		/* Enable RX in XGMAC and GSWSS */
+		xgmac_rx_flow_ctl(priv, XGMAC_FC_EN);
+
+		sw_set_flowctrl(priv, PHY_MODE_FCON_EN, FCONRX);
+		break;
+
+	case FC_TX:
+		/* Disable RX in XGMAC and GSWSS */
+		xgmac_rx_flow_ctl(priv, XGMAC_FC_DIS);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_DIS, FCONTX);
+
+		/* Enable TX in XGMAC and GSWSS */
+		xgmac_tx_flow_ctl(priv, priv->pause_time, XGMAC_FC_EN);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_EN, FCONTX);
+		break;
+
+	case FC_RXTX:
+		xgmac_tx_flow_ctl(priv, priv->pause_time, XGMAC_FC_EN);
+		xgmac_rx_flow_ctl(priv, XGMAC_FC_EN);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_EN, FCONRX);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_EN, FCONTX);
+		break;
+
+	case FC_DIS:
+		xgmac_tx_flow_ctl(priv, priv->pause_time, XGMAC_FC_DIS);
+		xgmac_rx_flow_ctl(priv, XGMAC_FC_DIS);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_DIS, FCONRX);
+		sw_set_flowctrl(priv, PHY_MODE_FCON_EN, FCONTX);
+		break;
+	}
+	spin_unlock_bh(&priv->mac_lock);
+
+	return 0;
+}
+
+inline int get_2G5_intf(struct gswip_mac *priv)
+{
+	u32 mac_if_cfg, macif;
+	int ret;
+
+	mac_if_cfg = sw_read(priv, MAC_IF_CFG_REG(priv->mac_idx));
+	macif = FIELD_PREP(MAC_IF_CFG_CFG2G5, mac_if_cfg);
+
+	if (macif == 0)
+		ret = XGMAC_GMII;
+	else if (macif == 1)
+		ret = XGMAC_XGMII;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+inline int get_1g_intf(struct gswip_mac *priv)
+{
+	u32 mac_if_cfg, macif;
+	int ret;
+
+	mac_if_cfg = sw_read(priv, MAC_IF_CFG_REG(priv->mac_idx));
+	macif = FIELD_GET(MAC_IF_CFG_CFG1G, mac_if_cfg);
+
+	if (macif == 0)
+		ret = LMAC_GMII;
+	else if (macif == 1)
+		ret = XGMAC_GMII;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+inline int get_fe_intf(struct gswip_mac *priv)
+{
+	u32 mac_if_cfg, macif;
+	int ret;
+
+	mac_if_cfg = sw_read(priv, MAC_IF_CFG_REG(priv->mac_idx));
+	macif = FIELD_GET(MAC_IF_CFG_CFGFE, mac_if_cfg);
+
+	if (macif == 0)
+		ret = LMAC_MII;
+	else if (macif == 1)
+		ret = XGMAC_GMII;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+static int mac_get_mii_interface(struct device *dev)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+	int intf, ret;
+	u8 mac_speed;
+
+	spin_lock_bh(&priv->mac_lock);
+	mac_speed = sw_get_speed(priv);
+	switch (mac_speed) {
+	case SPEED_10M:
+	case SPEED_100M:
+		intf = get_fe_intf(priv);
+		if (intf == XGMAC_GMII)
+			ret = GSW_PORT_HW_GMII;
+		else if (intf == LMAC_MII)
+			ret = GSW_PORT_HW_MII;
+		else
+			ret = -EINVAL;
+		break;
+
+	case SPEED_1G:
+		intf = get_1g_intf(priv);
+		if (intf == LMAC_GMII || intf == XGMAC_GMII)
+			ret = GSW_PORT_HW_GMII;
+		else
+			ret = -EINVAL;
+		break;
+
+	case SPEED_2G5:
+		intf = get_2G5_intf(priv);
+		if (intf == XGMAC_GMII)
+			ret = GSW_PORT_HW_GMII;
+		else if (intf == XGMAC_XGMII)
+			ret = GSW_PORT_HW_XGMII;
+		else
+			ret = -EINVAL;
+		break;
+
+	case SPEED_10G:
+		ret = GSW_PORT_HW_XGMII;
+		break;
+
+	case SPEED_AUTO:
+		ret = GSW_PORT_HW_XGMII;
+		break;
+
+	default:
+		ret = -EINVAL;
+	}
+	spin_unlock_bh(&priv->mac_lock);
+
+	return ret;
+}
+
+inline u32 set_mii_if_fe(u32 mode)
+{
+	u32 val = 0;
+
+	switch (mode) {
+	default:
+	case LMAC_MII:
+		val &= ~MAC_IF_CFG_CFGFE;
+		break;
+
+	case XGMAC_GMII:
+		val |= MAC_IF_CFG_CFGFE;
+		break;
+	}
+
+	return val;
+}
+
+inline u32 set_mii_if_1g(u32 mode)
+{
+	u32 val = 0;
+
+	switch (mode) {
+	default:
+	case LMAC_GMII:
+		val &= ~MAC_IF_CFG_CFG1G;
+		break;
+
+	case XGMAC_GMII:
+		val |= MAC_IF_CFG_CFG1G;
+		break;
+	}
+
+	return val;
+}
+
+inline u32 set_mii_if_2G5(u32 mode)
+{
+	u32 val = 0;
+
+	switch (mode) {
+	default:
+	case XGMAC_GMII:
+		val &= ~MAC_IF_CFG_CFG2G5;
+		break;
+
+	case XGMAC_XGMII:
+		val |= MAC_IF_CFG_CFG2G5;
+		break;
+	}
+
+	return val;
+}
+
+static int mac_set_mii_interface(struct device *dev, u32 mii_mode)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+	u32 reg_val = 0;
+
+	spin_lock_bh(&priv->mac_lock);
+	reg_val = sw_read(priv, MAC_IF_CFG_REG(priv->mac_idx));
+
+	/* Default modes...
+	 *		2.5G -	XGMAC_GMII
+	 *		1G   -	LMAC_GMII
+	 *		FE   -	LMAC_MII
+	 */
+	switch (mii_mode) {
+	default:
+	case GSW_PORT_HW_XGMII:
+		reg_val |= set_mii_if_2G5(XGMAC_XGMII);
+		break;
+
+	case GSW_PORT_HW_GMII:
+		reg_val |= set_mii_if_1g(XGMAC_GMII);
+		reg_val |= set_mii_if_fe(XGMAC_GMII);
+		reg_val |= set_mii_if_2G5(XGMAC_GMII);
+		break;
+
+	case GSW_PORT_HW_MII:
+		reg_val |= set_mii_if_fe(LMAC_MII);
+		break;
+	}
+
+	sw_write(priv, MAC_IF_CFG_REG(priv->mac_idx), reg_val);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return 0;
+}
+
+static u32 mac_get_mtu(struct device *dev)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+	u32 val;
+
+	spin_lock_bh(&priv->mac_lock);
+	val = sw_mac_get_mtu(priv);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return val;
+}
+
+static int mac_set_mtu(struct device *dev, u32 mtu)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+
+	if (mtu > LGM_MAX_MTU)
+		return -EINVAL;
+
+	spin_lock_bh(&priv->mac_lock);
+	sw_mac_set_mtu(priv, mtu);
+	xgmac_config_pkt(priv, mtu);
+	spin_unlock_bh(&priv->mac_lock);
+
+	return 0;
+}
+
+static int mac_init(struct device *dev)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+
+	xgmac_set_mac_address(priv, priv->mac_addr);
+	mac_set_mtu(dev, priv->mtu);
+	xgmac_config_packet_filter(priv, PROMISC);
+	xgmac_config_packet_filter(priv, PASS_ALL_MULTICAST);
+	mac_set_mii_interface(dev, GSW_PORT_HW_GMII);
+	mac_set_flowctrl(dev, FC_RXTX);
+	mac_set_linksts(priv, LINK_UP);
+	mac_set_duplex(priv, GSW_DUPLEX_FULL);
+	xgmac_set_mac_lpitx(priv, LPITX_EN);
+	mac_set_physpeed(priv, SPEED_XGMAC_10G);
+	/* Enable XMAC Tx/Rx */
+	xgmac_enable(priv);
+	xgmac_pause_frame_filter(priv, 1);
+	sw_set_eee_cap(priv, ANEG_EEE_CAP_OFF);
+	sw_set_mac_rxfcs_op(priv, MAC_OP_CFG_RX_FCS_M3);
+	xgmac_mdio_set_clause(priv, MDIO_CLAUSE22, (priv->mac_idx - MAC2));
+	xgmac_mdio_register(priv);
+
+	return 0;
+}
+
+static const struct gsw_mac_ops lgm_mac_ops = {
+	.init		= mac_init,
+	.set_mtu	= mac_set_mtu,
+	.get_mtu	= mac_get_mtu,
+	.set_mii_if	= mac_set_mii_interface,
+	.get_mii_if	= mac_get_mii_interface,
+	.set_flowctrl	= mac_set_flowctrl,
+	.get_link_sts	= mac_get_linksts,
+	.get_duplex	= mac_get_duplex,
+	.get_speed	= mac_get_speed,
+};
+
+static const struct gsw_adap_ops lgm_adap_ops = {
+	.sw_core_enable = sw_core_enable,
+};
+
+void mac_init_ops(struct device *dev)
+{
+	struct gswip_mac *priv = dev_get_drvdata(dev);
+
+	priv->mac_ops = &lgm_mac_ops;
+	priv->adap_ops = &lgm_adap_ops;
+}
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/mac_common.h b/drivers/net/ethernet/intel/gwdpa/gswip/mac_common.h
new file mode 100644
index 000000000000..581997a615d6
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/mac_common.h
@@ -0,0 +1,238 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2016-2019 Intel Corporation. */
+
+#ifndef _MAC_COMMON_H
+#define _MAC_COMMON_H
+
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+
+#include "gswip.h"
+#include "gswip_reg.h"
+#include "gswip_dev.h"
+
+#define LGM_MAX_MTU	10000
+#define LPITX_EN	1
+#define SPEED_LSB	GENMASK(1, 0)
+#define SPEED_MSB	BIT(2)
+#define MDIO_CLAUSE22	1
+#define MDIO_CLAUSE45	0
+
+/* MAC Index */
+enum mac_index {
+	PMAC0 = 0,
+	PMAC1,
+	MAC2,
+	MAC3,
+	MAC4,
+	MAC5,
+	MAC6,
+	MAC7,
+	MAC8,
+	MAC9,
+	MAC10,
+	PMAC2,
+	MAC_LAST,
+};
+
+enum packet_flilter_mode {
+	PROMISC = 0,
+	PASS_ALL_MULTICAST,
+	PKT_FR_DEF,
+};
+
+enum mii_interface {
+	LMAC_MII = 0,
+	LMAC_GMII,
+	XGMAC_GMII,
+	XGMAC_XGMII,
+};
+
+enum speed_interface {
+	SPEED_10M = 0,
+	SPEED_100M,
+	SPEED_1G,
+	SPEED_10G,
+	SPEED_2G5,
+	SPEED_5G,
+	SPEED_FLEX,
+	SPEED_AUTO
+};
+
+enum gsw_fcon {
+	FCONRX = 0,
+	FCONTX,
+	FDUP,
+};
+
+enum xgmac_fcon_on_off {
+	XGMAC_FC_EN = 0,
+	XGMAC_FC_DIS,
+};
+
+enum gsw_portduplex_mode {
+	GSW_DUPLEX_AUTO = 0,
+	GSW_DUPLEX_HALF,
+	GSW_DUPLEX_FULL,
+};
+
+struct xgmac_hw_features {
+	/* HW version */
+	u32 version;
+
+	/* HW Feature0 Register: core */
+	u32 gmii;	/* 1000 Mbps support */
+	u32 vlhash;	/* VLAN Hash Filter */
+	u32 sma;	/* SMA(MDIO) Interface */
+	u32 rwk;	/* PMT remote wake-up packet */
+	u32 mgk;	/* PMT magic packet */
+	u32 mmc;	/* RMON module */
+	u32 aoe;	/* ARP Offload */
+	u32 ts;		/* IEEE 1588-2008 Advanced Timestamp */
+	u32 eee;	/* Energy Efficient Ethernet */
+	u32 tx_coe;	/* Tx Checksum Offload */
+	u32 rx_coe;	/* Rx Checksum Offload */
+	u32 addn_mac;	/* Additional MAC Addresses */
+	u32 ts_src;	/* Timestamp Source */
+	u32 sa_vlan_ins;/* Source Address or VLAN Insertion */
+	u32 vxn;	/* VxLAN/NVGRE Support */
+	u32 ediffc;	/* Different Descriptor Cache */
+	u32 edma;	/* Enhanced DMA */
+
+	/* HW Feature1 Register: DMA and MTL */
+	u32 rx_fifo_size;	/* MTL Receive FIFO Size */
+	u32 tx_fifo_size;	/* MTL Transmit FIFO Size */
+	u32 osten;		/* One-Step Timestamping Enable */
+	u32 ptoen;		/* PTP Offload Enable */
+	u32 adv_ts_hi;		/* Advance Timestamping High Word */
+	u32 dma_width;		/* DMA width */
+	u32 dcb;		/* DCB Feature */
+	u32 sph;		/* Split Header Feature */
+	u32 tso;		/* TCP Segmentation Offload */
+	u32 dma_debug;		/* DMA Debug Registers */
+	u32 rss;		/* Receive Side Scaling */
+	u32 tc_cnt;		/* Number of Traffic Classes */
+	u32 hash_table_size;	/* Hash Table Size */
+	u32 l3l4_filter_num;	/* Number of L3-L4 Filters */
+
+	/* HW Feature2 Register: Channels(DMA) and Queues(MTL) */
+	u32 rx_q_cnt;		/* Number of MTL Receive Queues */
+	u32 tx_q_cnt;		/* Number of MTL Transmit Queues */
+	u32 rx_ch_cnt;		/* Number of DMA Receive Channels */
+	u32 tx_ch_cnt;		/* Number of DMA Transmit Channels */
+	u32 pps_out_num;	/* Number of PPS outputs */
+	u32 aux_snap_num;	/* Number of Aux snapshot inputs */
+};
+
+struct gswip_mac {
+	void __iomem *sw;	/* adaption layer */
+	void __iomem *lmac;	/* legacy mac */
+
+	/* XGMAC registers for indirect accessing */
+	u32 xgmac_ctrl_reg;
+	u32 xgmac_data0_reg;
+	u32 xgmac_data1_reg;
+
+	u32 sw_irq;
+	struct clk *ptp_clk;
+	struct clk *sw_clk;
+
+	struct device *dev;
+	struct device *parent;
+
+	spinlock_t mac_lock;	/* MAC spin lock*/
+	spinlock_t irw_lock;	/* lock for Indirect read/write */
+	spinlock_t sw_lock;	/* adaption lock */
+
+	/* Phy status */
+	u32 phy_speed;
+	const char *phy_mode;
+
+	u32 ver;
+	/* Index to point XGMAC 2/3/4/.. */
+	u32 mac_idx;
+	u32 mac_max;
+	u32 ptp_clk_rate;
+
+	struct xgmac_hw_features hw_feat;
+	const struct gsw_mac_ops *mac_ops;
+
+	const struct gsw_adap_ops *adap_ops;
+	u32 core_en_cnt;
+	struct mii_bus *mii;
+
+	u8 mac_addr[6];
+	u32 mtu;
+	bool promisc_mode;
+	bool all_mcast_mode;
+	u32 pause_time;
+};
+
+/*  GSWIP-O Top Register write */
+static inline void sw_write(struct gswip_mac *priv, u32 reg, u32 val)
+{
+	writel(val, priv->sw + reg);
+}
+
+/* GSWIP-O Top Register read */
+static inline int sw_read(struct gswip_mac *priv, u32 reg)
+{
+	return readl(priv->sw + reg);
+}
+
+/* Legacy MAC Register read */
+static inline void lmac_write(struct gswip_mac *priv, u32 reg, u32 val)
+{
+	writel(val, priv->lmac + reg);
+}
+
+/* Legacy MAC Register write */
+static inline int lmac_read(struct gswip_mac *priv, u32 reg)
+{
+	return readl(priv->lmac + reg);
+}
+
+/* prototype */
+void mac_init_ops(struct device *dev);
+void xgmac_init_priv(struct gswip_mac *priv);
+void xgmac_get_hw_features(struct gswip_mac *priv);
+void xgmac_set_mac_address(struct gswip_mac *priv, u8 *mac_addr);
+void xgmac_config_pkt(struct gswip_mac *priv, u32 mtu);
+void xgmac_config_packet_filter(struct gswip_mac *priv, u32 mode);
+void xgmac_tx_flow_ctl(struct gswip_mac *priv, u32 pause_time, u32 mode);
+void xgmac_rx_flow_ctl(struct gswip_mac *priv, u32 mode);
+int xgmac_set_mac_lpitx(struct gswip_mac *priv, u32 val);
+int xgmac_enable(struct gswip_mac *priv);
+int xgmac_disable(struct gswip_mac *priv);
+int xgmac_pause_frame_filter(struct gswip_mac *priv, u32 val);
+int xgmac_set_extcfg(struct gswip_mac *priv, u32 val);
+int xgmac_set_xgmii_speed(struct gswip_mac *priv);
+int xgmac_set_gmii_2500_speed(struct gswip_mac *priv);
+int xgmac_set_xgmii_2500_speed(struct gswip_mac *priv);
+int xgmac_set_gmii_speed(struct gswip_mac *priv);
+int xgmac_mdio_set_clause(struct gswip_mac *priv, u32 clause, u32 phy_id);
+int xgmac_mdio_register(struct gswip_mac *priv);
+
+int sw_mac_set_mtu(struct gswip_mac *priv, u32 mtu);
+u32 sw_mac_get_mtu(struct gswip_mac *priv);
+u32 sw_get_speed(struct gswip_mac *priv);
+int sw_set_flowctrl(struct gswip_mac *priv, u8 val, u32 mode);
+int sw_get_linkstatus(struct gswip_mac *priv);
+int sw_set_linkstatus(struct gswip_mac *priv, u8 linkst);
+int sw_get_duplex_mode(struct gswip_mac *priv);
+int sw_set_duplex_mode(struct gswip_mac *priv, u32 val);
+int sw_set_speed(struct gswip_mac *priv, u8 speed);
+int sw_set_2G5_intf(struct gswip_mac *priv, u32 macif);
+int sw_set_1g_intf(struct gswip_mac *priv, u32 macif);
+int sw_set_fe_intf(struct gswip_mac *priv, u32 macif);
+int sw_set_eee_cap(struct gswip_mac *priv, u32 val);
+int sw_set_mac_rxfcs_op(struct gswip_mac *priv, u32 val);
+
+int lmac_set_flowcon_mode(struct gswip_mac *priv, u32 val);
+int lmac_set_duplex_mode(struct gswip_mac *priv, u32 val);
+int lmac_set_intf_mode(struct gswip_mac *priv, u32 val);
+
+int sw_core_enable(struct device *dev, u32 val);
+#endif
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/mac_dev.c b/drivers/net/ethernet/intel/gwdpa/gswip/mac_dev.c
new file mode 100644
index 000000000000..028c580cdf8e
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/mac_dev.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation.
+ *
+ * GSWIP MAC controller driver.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/phy.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+
+#include "mac_common.h"
+
+#define	MAX_MAC	9
+
+static const char *link_status_to_str(int link)
+{
+	switch (link) {
+	case 0:
+		return "DOWN";
+	case 1:
+		return "UP";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static void gswss_update_interrupt(struct gswip_mac *priv, u32 mask, u32 set)
+{
+	u32 val;
+
+	val = (sw_read(priv, GSWIPSS_IER0) & ~mask) | set;
+	sw_write(priv, GSWIPSS_IER0, val);
+}
+
+static void lmac_update_interrupt(struct gswip_mac *priv, u32 mask, u32 set)
+{
+	u32 val;
+
+	val = (lmac_read(priv, LMAC_IER) & ~mask) | set;
+	lmac_write(priv, LMAC_IER, val);
+}
+
+static void gswss_clear_interrupt_all(struct gswip_mac *priv)
+{
+	unsigned long xgmac_status, lmac_status;
+	u32 pos;
+
+	xgmac_status = sw_read(priv, GSWIPSS_ISR0);
+	lmac_status = lmac_read(priv, LMAC_ISR);
+
+	pos = GSWIPSS_I_XGMAC2;
+	for_each_set_bit_from(pos, &xgmac_status, priv->mac_max)
+		gswss_update_interrupt(priv, BIT(pos), 0);
+
+	pos = LMAC_I_MAC2;
+	for_each_set_bit_from(pos, &lmac_status, priv->mac_max)
+		lmac_update_interrupt(priv, BIT(pos), 0);
+}
+
+static irqreturn_t mac_interrupt(int irq, void *data)
+{
+	struct gswip_mac *priv = data;
+
+	/* clear all interrupts */
+	gswss_clear_interrupt_all(priv);
+
+	return IRQ_HANDLED;
+}
+
+/* All MAC instances have one interrupt line and need to register only once. */
+static int mac_irq_init(struct gswip_mac *priv)
+{
+	return devm_request_irq(priv->dev, priv->sw_irq, mac_interrupt, 0,
+				"gswip_mac", priv);
+}
+
+static int get_mac_index(struct device_node *node, u32 *idx)
+{
+	if (!strstr(node->full_name, "@"))
+		return -EINVAL;
+
+	return kstrtou32(node->full_name + strlen(node->name) + 1, 0, idx);
+}
+
+static int mac_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int linksts, duplex, speed;
+	struct gswip_pdata *pdata;
+	struct device_node *node;
+	struct gswip_mac *priv;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	node = dev->of_node;
+	pdata = dev_get_platdata(dev->parent);
+
+	/* get the platform data */
+	priv->dev = &pdev->dev;
+	priv->parent = dev->parent;
+	priv->sw = pdata->sw;
+	priv->lmac = pdata->lmac;
+	priv->sw_irq = pdata->sw_irq;
+	priv->ptp_clk = pdata->ptp_clk;
+	priv->sw_clk = pdata->sw_clk;
+
+	/* Initialize spin lock */
+	spin_lock_init(&priv->mac_lock);
+	spin_lock_init(&priv->irw_lock);
+	spin_lock_init(&priv->sw_lock);
+
+	priv->mac_max =	MAX_MAC;
+	ret = get_mac_index(node, &priv->mac_idx);
+	if (ret)
+		return ret;
+
+	/* check the mac index range */
+	if (priv->mac_idx < 0 || priv->mac_idx > priv->mac_max) {
+		dev_err(dev, "Mac index Error!!\n");
+		return -EINVAL;
+	}
+
+	priv->ptp_clk_rate = clk_get_rate(priv->ptp_clk);
+
+	ret = of_property_read_string(node, "phy-mode", &priv->phy_mode);
+	if (ret)
+		return ret;
+
+	ret = of_property_read_u32(node, "speed", &priv->phy_speed);
+	if (ret)
+		return ret;
+
+	/* Request IRQ on first MAC instance */
+	if (!pdata->intr_flag) {
+		ret = mac_irq_init(priv);
+		if (ret)
+			return ret;
+		pdata->intr_flag = true;
+	}
+
+	dev_set_drvdata(dev, priv);
+	xgmac_init_priv(priv);
+	xgmac_get_hw_features(priv);
+	mac_init_ops(dev);
+
+	/* Initialize MAC */
+	priv->mac_ops->init(dev);
+
+	linksts = priv->mac_ops->get_link_sts(dev);
+	duplex = priv->mac_ops->get_duplex(dev);
+	speed = priv->mac_ops->get_speed(dev);
+
+	priv->adap_ops->sw_core_enable(dev, 1);
+
+	dev_info(dev, "Init done - Rev:%x Mac_id:%d Speed=%s Link=%s Duplex=%s\n",
+		 priv->ver, priv->mac_idx, phy_speed_to_str(speed),
+		 link_status_to_str(linksts), phy_duplex_to_str(duplex));
+
+	return 0;
+}
+
+static const struct of_device_id gswip_mac_match[] = {
+	{ .compatible = "gswip-mac" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, gswip_mac_match);
+
+static struct platform_driver gswip_mac_driver = {
+	.probe = mac_probe,
+	.driver = {
+		.name = "gswip-mac",
+		.of_match_table = gswip_mac_match,
+	},
+};
+
+module_platform_driver(gswip_mac_driver);
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/xgmac.c b/drivers/net/ethernet/intel/gwdpa/gswip/xgmac.c
new file mode 100644
index 000000000000..e3f9d9680579
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/xgmac.c
@@ -0,0 +1,643 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2016-2019 Intel Corporation. */
+
+#include <linux/bitfield.h>
+#include <linux/device.h>
+#include <linux/of_mdio.h>
+#include <linux/phy.h>
+
+#include "mac_common.h"
+#include "xgmac.h"
+
+/**
+ * xgmac_reg_rw - XGMAC register indirect read and write access.
+ * @priv: mac private data.
+ * @reg: register offset.
+ * @val:
+ *	read - pointer variable to read the value into.
+ *	write - pointer variable to the write value.
+ * @rd_wr: boolean value, true/false.
+ *	false - read.
+ *	true - write.
+ */
+static inline void xgmac_reg_rw(struct gswip_mac *priv, u16 reg, u32 *val,
+				bool rd_wr)
+{
+	void __iomem *xgmac_ctrl_reg  = priv->sw + priv->xgmac_ctrl_reg;
+	void __iomem *xgmac_data0_reg = priv->sw + priv->xgmac_data0_reg;
+	void __iomem *xgmac_data1_reg = priv->sw + priv->xgmac_data1_reg;
+	u32 access = XGMAC_REGACC_CTRL_ADDR_BAS;
+	u32 retries = 2000;
+
+	spin_lock_bh(&priv->irw_lock);
+	access &= ~XGMAC_REGACC_CTRL_OPMOD_WR;
+	if (rd_wr) {
+		writel(FIELD_GET(MASK_HIGH, *val), xgmac_data1_reg);
+		writel(FIELD_GET(MASK_LOW, *val), xgmac_data0_reg);
+		access |= XGMAC_REGACC_CTRL_OPMOD_WR;
+	}
+
+	writel(access | reg, xgmac_ctrl_reg);
+
+	do {
+		if (!(readl(xgmac_ctrl_reg) & XGMAC_REGACC_CTRL_ADDR_BAS))
+			break;
+		cpu_relax();
+	} while (--retries);
+	if (!retries)
+		dev_warn(priv->dev, "Xgmac register %s failed for Offset %x\n",
+			 rd_wr ? "write" : "read", reg);
+
+	if (!rd_wr)
+		*val = FIELD_PREP(MASK_HIGH, readl(xgmac_data1_reg)) |
+		       readl(xgmac_data0_reg);
+	spin_unlock_bh(&priv->irw_lock);
+}
+
+void xgmac_get_hw_features(struct gswip_mac *priv)
+{
+	struct xgmac_hw_features *hw_feat = &priv->hw_feat;
+	u32 mac_hfr0, mac_hfr1, mac_hfr2;
+
+	xgmac_reg_rw(priv, MAC_HW_F0, &mac_hfr0, false);
+	xgmac_reg_rw(priv, MAC_HW_F1, &mac_hfr1, false);
+	xgmac_reg_rw(priv, MAC_HW_F2, &mac_hfr2, false);
+	xgmac_reg_rw(priv, MAC_VER, &hw_feat->version, false);
+
+	priv->ver = FIELD_GET(MAC_VER_USERVER, hw_feat->version);
+
+	/* Hardware feature0 regiter*/
+	hw_feat->gmii = FIELD_GET(MAC_HW_F0_GMIISEL, mac_hfr0);
+	hw_feat->vlhash = FIELD_GET(MAC_HW_F0_VLHASH, mac_hfr0);
+	hw_feat->sma = FIELD_GET(MAC_HW_F0_SMASEL, mac_hfr0);
+	hw_feat->rwk = FIELD_GET(MAC_HW_F0_RWKSEL, mac_hfr0);
+	hw_feat->mgk = FIELD_GET(MAC_HW_F0_MGKSEL, mac_hfr0);
+	hw_feat->mmc = FIELD_GET(MAC_HW_F0_MMCSEL, mac_hfr0);
+	hw_feat->aoe = FIELD_GET(MAC_HW_F0_ARPOFFSEL, mac_hfr0);
+	hw_feat->ts = FIELD_GET(MAC_HW_F0_TSSEL, mac_hfr0);
+	hw_feat->eee = FIELD_GET(MAC_HW_F0_EEESEL, mac_hfr0);
+	hw_feat->tx_coe = FIELD_GET(MAC_HW_F0_TXCOESEL, mac_hfr0);
+	hw_feat->rx_coe = FIELD_GET(MAC_HW_F0_RXCOESEL, mac_hfr0);
+	hw_feat->addn_mac = FIELD_GET(MAC_HW_F0_ADDMACADRSEL, mac_hfr0);
+	hw_feat->ts_src = FIELD_GET(MAC_HW_F0_TSSTSSEL, mac_hfr0);
+	hw_feat->sa_vlan_ins = FIELD_GET(MAC_HW_F0_SAVLANINS, mac_hfr0);
+	hw_feat->vxn = FIELD_GET(MAC_HW_F0_VXN, mac_hfr0);
+	hw_feat->ediffc = FIELD_GET(MAC_HW_F0_EDIFFC, mac_hfr0);
+	hw_feat->edma = FIELD_GET(MAC_HW_F0_EDMA, mac_hfr0);
+
+	/* Hardware feature1 register*/
+	hw_feat->rx_fifo_size = FIELD_GET(MAC_HW_F1_RXFIFOSIZE, mac_hfr1);
+	hw_feat->tx_fifo_size = FIELD_GET(MAC_HW_F1_TXFIFOSIZE, mac_hfr1);
+	hw_feat->osten = FIELD_GET(MAC_HW_F1_OSTEN, mac_hfr1);
+	hw_feat->ptoen = FIELD_GET(MAC_HW_F1_PTOEN, mac_hfr1);
+	hw_feat->adv_ts_hi = FIELD_GET(MAC_HW_F1_ADVTHWORD, mac_hfr1);
+	hw_feat->dma_width = FIELD_GET(MAC_HW_F1_ADDR64, mac_hfr1);
+	hw_feat->dcb = FIELD_GET(MAC_HW_F1_DCBEN, mac_hfr1);
+	hw_feat->sph = FIELD_GET(MAC_HW_F1_SPHEN, mac_hfr1);
+	hw_feat->tso = FIELD_GET(MAC_HW_F1_TSOEN, mac_hfr1);
+	hw_feat->dma_debug = FIELD_GET(MAC_HW_F1_DBGMEMA, mac_hfr1);
+	hw_feat->rss = FIELD_GET(MAC_HW_F1_RSSEN, mac_hfr1);
+	hw_feat->tc_cnt = FIELD_GET(MAC_HW_F1_NUMTC, mac_hfr1);
+	hw_feat->hash_table_size = FIELD_GET(MAC_HW_F1_HASHTBLSZ, mac_hfr1);
+	hw_feat->l3l4_filter_num = FIELD_GET(MAC_HW_F1_L3L4FNUM, mac_hfr1);
+
+	/* Hardware feature2 register*/
+	hw_feat->rx_q_cnt = FIELD_GET(MAC_HW_F2_RXCHCNT, mac_hfr2);
+	hw_feat->tx_q_cnt = FIELD_GET(MAC_HW_F2_TXQCNT, mac_hfr2);
+	hw_feat->rx_ch_cnt = FIELD_GET(MAC_HW_F2_RXCHCNT, mac_hfr2);
+	hw_feat->tx_ch_cnt = FIELD_GET(MAC_HW_F2_TXCHCNT, mac_hfr2);
+	hw_feat->pps_out_num = FIELD_GET(MAC_HW_F2_PPSOUTNUM, mac_hfr2);
+	hw_feat->aux_snap_num = FIELD_GET(MAC_HW_F2_AUXSNAPNUM, mac_hfr2);
+
+	/* TC and Queue are zero based so increment to get the actual number */
+	hw_feat->tc_cnt++;
+	hw_feat->rx_q_cnt++;
+	hw_feat->tx_q_cnt++;
+}
+
+void xgmac_init_priv(struct gswip_mac *priv)
+{
+	u8 mac_addr[6] = {0x00, 0x00, 0x94, 0x00, 0x00, 0x08};
+
+	priv->mac_idx += MAC2;
+
+	priv->xgmac_ctrl_reg = XGMAC_CTRL_REG(priv->mac_idx);
+	priv->xgmac_data1_reg = XGMAC_DATA1_REG(priv->mac_idx);
+	priv->xgmac_data0_reg = XGMAC_DATA0_REG(priv->mac_idx);
+
+	/* Temp mac addr, Later eth driver will update */
+	mac_addr[5] = priv->mac_idx;
+	memcpy(priv->mac_addr, mac_addr, 6);
+
+	priv->mtu = LGM_MAX_MTU;
+	priv->promisc_mode = true;
+	priv->all_mcast_mode = true;
+}
+
+void xgmac_set_mac_address(struct gswip_mac *priv, u8 *mac_addr)
+{
+	u32 mac_addr_hi, mac_addr_low;
+	u32 val;
+
+	mac_addr_hi = (mac_addr[5] << 8) | (mac_addr[4] << 0);
+	mac_addr_low = (mac_addr[3] << 24) | (mac_addr[2] << 16) |
+			(mac_addr[1] <<  8) | (mac_addr[0] <<  0);
+
+	xgmac_reg_rw(priv, MAC_MACA0HR, &mac_addr_hi, true);
+
+	xgmac_reg_rw(priv, MAC_MACA0LR, &val, false);
+	if (val != mac_addr_low)
+		xgmac_reg_rw(priv, MAC_MACA0LR, &mac_addr_low, true);
+}
+
+inline void xgmac_prep_pkt_jumbo(u32 mtu, u32 *mac_rcr, u32 *mac_tcr)
+{
+	if (mtu < XGMAC_MAX_GPSL) {	/* upto 9018 configuration */
+		*mac_rcr |= MAC_RX_CFG_JE;
+		*mac_rcr &= ~MAC_RX_CFG_WD & ~MAC_RX_CFG_GPSLCE;
+		*mac_tcr &= ~MAC_TX_CFG_JD;
+
+	} else {			/* upto 16K configuration */
+		*mac_rcr &= ~MAC_RX_CFG_JE;
+		*mac_rcr |= MAC_RX_CFG_WD | MAC_RX_CFG_GPSLCE |
+			    FIELD_PREP(MAC_RX_CFG_GPSL,
+				       XGMAC_MAX_SUPPORTED_MTU);
+		*mac_tcr |= MAC_TX_CFG_JD;
+	}
+}
+
+inline void xgmac_prep_pkt_standard(u32 *mac_rcr, u32 *mac_tcr)
+{
+	*mac_rcr &= ~MAC_RX_CFG_JE & ~MAC_RX_CFG_WD & ~MAC_RX_CFG_GPSLCE;
+	*mac_tcr &= ~MAC_TX_CFG_JD;
+}
+
+void xgmac_config_pkt(struct gswip_mac *priv, u32 mtu)
+{
+	u32 mac_rcr, mac_tcr;
+
+	xgmac_reg_rw(priv, MAC_RX_CFG, &mac_rcr, false);
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, false);
+
+	if (mtu > XGMAC_MAX_STD_PACKET)
+		xgmac_prep_pkt_jumbo(mtu, &mac_rcr, &mac_tcr);
+	else
+		xgmac_prep_pkt_standard(&mac_rcr, &mac_tcr);
+
+	xgmac_reg_rw(priv, MAC_RX_CFG, &mac_rcr, true);
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, true);
+}
+
+void xgmac_config_packet_filter(struct gswip_mac *priv, u32 mode)
+{
+	u32 reg_val;
+
+	xgmac_reg_rw(priv, MAC_PKT_FR, &reg_val, false);
+
+	switch (mode) {
+	case PROMISC:
+		reg_val &= ~MAC_PKT_FR_PR;
+		reg_val |= FIELD_PREP(MAC_PKT_FR_PR, priv->promisc_mode);
+		break;
+
+	case PASS_ALL_MULTICAST:
+		reg_val &= ~MAC_PKT_FR_PM;
+		reg_val |= FIELD_PREP(MAC_PKT_FR_PM, priv->all_mcast_mode);
+		break;
+
+	default:
+		reg_val &= ~MAC_PKT_FR_PR & ~MAC_PKT_FR_PM;
+		reg_val |= FIELD_PREP(MAC_PKT_FR_PR, priv->promisc_mode) |
+			   FIELD_PREP(MAC_PKT_FR_PM, priv->all_mcast_mode);
+	}
+
+	xgmac_reg_rw(priv, MAC_PKT_FR, &reg_val, true);
+}
+
+void xgmac_tx_flow_ctl(struct gswip_mac *priv, u32 pause_time, u32 mode)
+{
+	u32 reg_val = 0;
+
+	xgmac_reg_rw(priv, MAC_TX_FCR, &reg_val, false);
+
+	switch (mode) {
+	case XGMAC_FC_EN:
+		/* enable tx flow control */
+		reg_val |= MAC_TX_FCR_TFE;
+
+		/* Set pause time */
+		reg_val &= ~MAC_TX_FCR_PT;
+		reg_val |= FIELD_PREP(MAC_TX_FCR_PT, pause_time);
+		break;
+
+	case XGMAC_FC_DIS:
+		reg_val &= ~MAC_TX_FCR_TFE;
+		break;
+	}
+
+	xgmac_reg_rw(priv, MAC_TX_FCR, &reg_val, true);
+}
+
+void xgmac_rx_flow_ctl(struct gswip_mac *priv, u32 mode)
+{
+	u32 reg_val = 0;
+
+	xgmac_reg_rw(priv, MAC_RX_FCR, &reg_val, false);
+
+	switch (mode) {
+	case XGMAC_FC_EN:
+		/* rx fc enable */
+		reg_val |= MAC_RX_FCR_RFE;
+		reg_val &= ~MAC_RX_FCR_PFCE;
+		break;
+
+	case XGMAC_FC_DIS:
+		reg_val &= ~MAC_RX_FCR_RFE;
+		break;
+	}
+
+	xgmac_reg_rw(priv, MAC_RX_FCR, &reg_val, true);
+}
+
+int xgmac_set_mac_lpitx(struct gswip_mac *priv, u32 val)
+{
+	u32 lpiate;
+
+	xgmac_reg_rw(priv, MAC_LPI_CSR, &lpiate, false);
+
+	if (FIELD_GET(MAC_LPI_CSR_LPIATE, lpiate) != val) {
+		lpiate &= ~MAC_LPI_CSR_LPIATE;
+		lpiate |= FIELD_PREP(MAC_LPI_CSR_LPIATE, val);
+	}
+
+	if (FIELD_GET(MAC_LPI_CSR_LPITXA, lpiate) != val) {
+		lpiate &= ~MAC_LPI_CSR_LPITXA;
+		lpiate |= FIELD_PREP(MAC_LPI_CSR_LPITXA, val);
+	}
+
+	xgmac_reg_rw(priv, MAC_LPI_CSR, &lpiate, true);
+
+	return 0;
+}
+
+int xgmac_enable(struct gswip_mac *priv)
+{
+	u32 mac_tcr, mac_rcr, mac_pfr;
+
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, false);
+	xgmac_reg_rw(priv, MAC_RX_CFG, &mac_rcr, false);
+	xgmac_reg_rw(priv, MAC_PKT_FR, &mac_pfr, false);
+
+	/* Enable MAC Tx */
+	if (!FIELD_GET(MAC_TX_CFG_TE, mac_tcr)) {
+		mac_tcr |= MAC_TX_CFG_TE;
+		xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, true);
+	}
+
+	/* Enable MAC Rx */
+	if (!FIELD_GET(MAC_RX_CFG_RE, mac_rcr)) {
+		mac_rcr |= MAC_RX_CFG_RE;
+		xgmac_reg_rw(priv, MAC_RX_CFG, &mac_rcr, true);
+	}
+
+	/* Enable MAC Filter Rx All */
+	if (!FIELD_GET(MAC_PKT_FR_RA, mac_pfr)) {
+		mac_pfr |= MAC_PKT_FR_RA;
+		xgmac_reg_rw(priv, MAC_PKT_FR, &mac_pfr, true);
+	}
+
+	return 0;
+}
+
+int xgmac_disable(struct gswip_mac *priv)
+{
+	u32 mac_tcr, mac_rcr, mac_pfr;
+
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, false);
+	xgmac_reg_rw(priv, MAC_RX_CFG, &mac_rcr, false);
+	xgmac_reg_rw(priv, MAC_PKT_FR, &mac_pfr, false);
+
+	/* Disable MAC Tx */
+	if (FIELD_GET(MAC_TX_CFG_TE, mac_tcr) != 0) {
+		mac_tcr &= ~MAC_TX_CFG_TE;
+		xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, true);
+	}
+
+	/* Disable MAC Rx */
+	if (FIELD_GET(MAC_RX_CFG_RE, mac_rcr) != 0) {
+		mac_rcr &= ~MAC_RX_CFG_RE;
+		xgmac_reg_rw(priv, MAC_RX_CFG, &mac_rcr, true);
+	}
+
+	/* Disable MAC Filter Rx All */
+	if (FIELD_GET(MAC_PKT_FR_RA, mac_pfr) != 0) {
+		mac_pfr &= ~MAC_PKT_FR_RA;
+		xgmac_reg_rw(priv, MAC_PKT_FR, &mac_pfr, true);
+	}
+
+	return 0;
+}
+
+int xgmac_pause_frame_filter(struct gswip_mac *priv, u32 val)
+{
+	u32 mac_pfr;
+
+	xgmac_reg_rw(priv, MAC_PKT_FR, &mac_pfr, false);
+
+	if (FIELD_GET(MAC_PKT_FR_PCF, mac_pfr) != val) {
+		/* Pause filtering */
+		mac_pfr &= ~MAC_PKT_FR_PCF;
+		mac_pfr |= FIELD_PREP(MAC_PKT_FR_PCF, val);
+	}
+
+	/* The Receiver module passes only those packets to the application
+	 * that pass the SA or DA address filter.
+	 */
+	if (FIELD_GET(MAC_PKT_FR_RA, mac_pfr) == 1)
+		mac_pfr &= ~MAC_PKT_FR_RA;
+
+	xgmac_reg_rw(priv, MAC_PKT_FR, &mac_pfr, true);
+
+	return 0;
+}
+
+int xgmac_set_extcfg(struct gswip_mac *priv, u32 val)
+{
+	u32 mac_extcfg;
+
+	xgmac_reg_rw(priv, MAC_EXTCFG, &mac_extcfg, false);
+
+	if (FIELD_GET(MAC_EXTCFG_SBDIOEN, mac_extcfg) != val) {
+		mac_extcfg &= ~MAC_EXTCFG_SBDIOEN;
+		mac_extcfg |= FIELD_PREP(MAC_EXTCFG_SBDIOEN, val);
+		xgmac_reg_rw(priv, MAC_EXTCFG, &mac_extcfg, true);
+	}
+
+	return 0;
+}
+
+int xgmac_set_xgmii_speed(struct gswip_mac *priv)
+{
+	u32 mac_tcr;
+
+	xgmac_disable(priv);
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, false);
+
+	if (FIELD_GET(MAC_TX_CFG_USS, mac_tcr) != 0)
+		mac_tcr &= ~MAC_TX_CFG_USS;
+
+	if (FIELD_GET(MAC_TX_CFG_SS, mac_tcr) != 0)
+		mac_tcr &= ~MAC_TX_CFG_SS;
+
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, true);
+	xgmac_enable(priv);
+
+	return 0;
+}
+
+int xgmac_set_gmii_2500_speed(struct gswip_mac *priv)
+{
+	u32 mac_tcr;
+
+	xgmac_disable(priv);
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, false);
+
+	if (FIELD_GET(MAC_TX_CFG_USS, mac_tcr) != 0)
+		mac_tcr &= ~MAC_TX_CFG_USS;
+
+	if (FIELD_GET(MAC_TX_CFG_SS, mac_tcr) != 0x2) {
+		mac_tcr &= ~MAC_TX_CFG_SS;
+		mac_tcr |= FIELD_PREP(MAC_TX_CFG_SS, 0x2);
+	}
+
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, true);
+	xgmac_enable(priv);
+
+	return 0;
+}
+
+int xgmac_set_xgmii_2500_speed(struct gswip_mac *priv)
+{
+	u32 mac_tcr;
+
+	xgmac_disable(priv);
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, false);
+
+	if (FIELD_GET(MAC_TX_CFG_USS, mac_tcr) != 1)
+		mac_tcr |= MAC_TX_CFG_USS;
+
+	if (FIELD_GET(MAC_TX_CFG_SS, mac_tcr) != 0x2) {
+		mac_tcr &= ~MAC_TX_CFG_SS;
+		mac_tcr |= FIELD_PREP(MAC_TX_CFG_SS, 0x2);
+	}
+
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, true);
+	xgmac_enable(priv);
+
+	return 0;
+}
+
+int xgmac_set_gmii_speed(struct gswip_mac *priv)
+{
+	u32 mac_tcr;
+
+	xgmac_disable(priv);
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, false);
+
+	if (FIELD_GET(MAC_TX_CFG_USS, mac_tcr) != 0)
+		mac_tcr &= MAC_TX_CFG_USS;
+
+	if (FIELD_GET(MAC_TX_CFG_SS, mac_tcr) != 0x3) {
+		mac_tcr &= ~MAC_TX_CFG_SS;
+		mac_tcr |= FIELD_PREP(MAC_TX_CFG_SS, 0x3);
+	}
+
+	xgmac_reg_rw(priv, MAC_TX_CFG, &mac_tcr, true);
+	xgmac_enable(priv);
+
+	return 0;
+}
+
+int xgmac_mdio_set_clause(struct gswip_mac *priv, u32 clause, u32 phy_id)
+{
+	u32 mdio_c22p = 0;
+
+	xgmac_reg_rw(priv, MDIO_C22P, &mdio_c22p, false);
+
+	if (clause == MDIO_CLAUSE22)
+		mdio_c22p |= MDIO_C22P_PORT(phy_id);
+	else
+		mdio_c22p &= ~MDIO_C22P_PORT(phy_id);
+
+	/* Select port 0, 1, 2 and 3 as Clause 22/45 ports */
+	xgmac_reg_rw(priv, MDIO_C22P, &mdio_c22p, true);
+
+	return 0;
+}
+
+static int xgmac_mdio_single_wr(struct gswip_mac *priv, u32 dev_adr,
+				u32 phy_id, u32 phy_reg, u32 phy_reg_data)
+{
+	u32 mdio_sccdr, mdio_scar;
+	u32 retries = 100;
+
+	/* wait for any previous MDIO read/write operation to complete */
+	/* Poll */
+	do {
+		xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, false);
+		if (!FIELD_GET(MDIO_SCCDR_BUSY, mdio_sccdr))
+			break;
+		cpu_relax();
+	} while (--retries);
+	if (!retries) {
+		dev_err(priv->dev, "Xgmac MDIO rd/wr operation failed\n");
+		return -ETIMEDOUT;
+	}
+
+	xgmac_reg_rw(priv, MDIO_SCAR, &mdio_scar, false);
+	mdio_scar &= ~MDIO_SCAR_DA & ~MDIO_SCAR_PA & ~MDIO_SCAR_RA;
+	mdio_scar |= FIELD_PREP(MDIO_SCAR_DA, dev_adr);
+	mdio_scar |= FIELD_PREP(MDIO_SCAR_PA, phy_id);
+	mdio_scar |= FIELD_PREP(MDIO_SCAR_RA, phy_reg);
+	xgmac_reg_rw(priv, MDIO_SCAR, &mdio_scar, true);
+
+	xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, false);
+	mdio_sccdr &= ~MDIO_SCCDR_SDATA & ~MDIO_SCCDR_CMD;
+	mdio_sccdr |= FIELD_PREP(MDIO_SCCDR_SDATA, phy_reg_data);
+	mdio_sccdr |= MDIO_SCCDR_BUSY;
+	mdio_sccdr &= ~MDIO_SCCDR_SADDR;
+	mdio_sccdr |= FIELD_PREP(MDIO_SCCDR_CMD, 1);
+	xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, true);
+
+	retries = 100;
+	/* wait for MDIO read operation to complete */
+	/* Poll */
+	do {
+		xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, false);
+		if (!FIELD_GET(MDIO_SCCDR_BUSY, mdio_sccdr))
+			break;
+		cpu_relax();
+	} while (--retries);
+	if (!retries) {
+		dev_err(priv->dev, "Xgmac MDIO rd/wr operation failed\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int xgmac_mdio_single_rd(struct gswip_mac *priv, u32 dev_adr,
+				u32 phy_id, u32 phy_reg)
+{
+	u32 mdio_sccdr, mdio_scar;
+	u32 retries = 100;
+	int phy_reg_data;
+
+	/* wait for any previous MDIO read/write operation to complete */
+	/* Poll */
+	do {
+		xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, false);
+		if (!FIELD_GET(MDIO_SCCDR_BUSY, mdio_sccdr))
+			break;
+		cpu_relax();
+	} while (--retries);
+	if (!retries) {
+		dev_err(priv->dev, "Xgmac MDIO rd/wr operation failed\n");
+		return -ETIMEDOUT;
+	}
+
+	/* initiate the MDIO read operation by updating desired bits
+	 * PA - phy address/id (0 - 31)
+	 * RA - phy register offset
+	 */
+
+	xgmac_reg_rw(priv, MDIO_SCAR, &mdio_scar, false);
+	mdio_scar &= ~MDIO_SCAR_DA & ~MDIO_SCAR_PA & ~MDIO_SCAR_RA;
+	mdio_scar |= FIELD_PREP(MDIO_SCAR_DA, dev_adr);
+	mdio_scar |= FIELD_PREP(MDIO_SCAR_PA, phy_id);
+	mdio_scar |= FIELD_PREP(MDIO_SCAR_RA, phy_reg);
+	xgmac_reg_rw(priv, MDIO_SCAR, &mdio_scar, true);
+
+	xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, false);
+	mdio_sccdr &= ~MDIO_SCCDR_CMD & ~MDIO_SCCDR_SDATA;
+	mdio_sccdr |= MDIO_SCCDR_BUSY;
+	mdio_sccdr &= ~MDIO_SCCDR_SADDR;
+	mdio_sccdr |= FIELD_PREP(MDIO_SCCDR_CMD, 3);
+	mdio_sccdr |= FIELD_PREP(MDIO_SCCDR_SDATA, 0);
+	xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, true);
+
+	retries = 100;
+	/* wait for MDIO read operation to complete */
+	/* Poll */
+	do {
+		xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, false);
+		if (!FIELD_GET(MDIO_SCCDR_BUSY, mdio_sccdr))
+			break;
+		cpu_relax();
+	} while (--retries);
+	if (!retries) {
+		dev_err(priv->dev, "Xgmac MDIO rd/wr operation failed\n");
+		return -ETIMEDOUT;
+	}
+
+	/* read the data */
+	xgmac_reg_rw(priv, MDIO_SCCDR, &mdio_sccdr, false);
+	phy_reg_data = FIELD_GET(MDIO_SCCDR_SDATA, mdio_sccdr);
+
+	return phy_reg_data;
+}
+
+static int xgmac_mdio_read(struct mii_bus *bus, int phyadr, int phyreg)
+{
+	struct gswip_mac *priv = bus->priv;
+
+	return xgmac_mdio_single_rd(priv, 0, phyadr, phyreg);
+}
+
+static int xgmac_mdio_write(struct mii_bus *bus, int phyadr, int phyreg,
+			    u16 phydata)
+{
+	struct gswip_mac *priv = bus->priv;
+
+	return xgmac_mdio_single_wr(priv, 0, phyadr, phyreg, phydata);
+}
+
+int xgmac_mdio_register(struct gswip_mac *priv)
+{
+	struct device_node *mdio_np;
+	struct mii_bus *bus;
+	int ret;
+
+	mdio_np = of_get_child_by_name(priv->dev->of_node, "mdio");
+	if (!mdio_np)
+		return -ENOLINK;
+
+	bus = mdiobus_alloc();
+	if (!bus)
+		return -ENOMEM;
+
+	bus->name = "xgmac_phy";
+	bus->read = xgmac_mdio_read;
+	bus->write = xgmac_mdio_write;
+	bus->reset = NULL;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-%x", bus->name, priv->mac_idx);
+	bus->priv = priv;
+	bus->parent = priv->dev;
+
+	/* At this moment gphy is not yet up (firmware not yet loaded), so we
+	 * avoid auto mdio scan.
+	 */
+	bus->phy_mask = 0xFFFFFFFF;
+
+	ret = of_mdiobus_register(bus, mdio_np);
+	if (ret) {
+		mdiobus_free(bus);
+		return ret;
+	}
+
+	priv->mii = bus;
+	dev_info(priv->dev, "XGMAC %d: MDIO register Successful\n",
+		 priv->mac_idx);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/gwdpa/gswip/xgmac.h b/drivers/net/ethernet/intel/gwdpa/gswip/xgmac.h
new file mode 100644
index 000000000000..0d1be931fcf3
--- /dev/null
+++ b/drivers/net/ethernet/intel/gwdpa/gswip/xgmac.h
@@ -0,0 +1,236 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2016-2019 Intel Corporation. */
+/* Xgmac registers indirect access */
+
+#ifndef _XGMAC_H
+#define _XGMAC_H
+
+#include <linux/bits.h>
+
+/* MAC register offsets */
+#define MAC_TX_CFG			0x0000
+#define MAC_TX_CFG_TE			BIT(0)
+#define MAC_TX_CFG_DDIC			BIT(1)
+#define MAC_TX_CFG_ISM			BIT(3)
+#define MAC_TX_CFG_ISR			GENMASK(7, 4)
+#define MAC_TX_CFG_IPG			GENMASK(10, 8)
+#define MAC_TX_CFG_IFP			BIT(11)
+#define MAC_TX_CFG_JD			BIT(16)
+#define MAC_TX_CFG_SARC			GENMASK(22, 20)
+#define MAC_TX_CFG_VNE			BIT(24)
+#define MAC_TX_CFG_VNM			BIT(25)
+#define MAC_TX_CFG_G9991EN		BIT(28)
+#define MAC_TX_CFG_SS			GENMASK(30, 29)
+#define MAC_TX_CFG_USS			BIT(31)
+
+#define MAC_RX_CFG			0x0004
+#define MAC_RX_CFG_RE			BIT(0)
+#define MAC_RX_CFG_ACS			BIT(1)
+#define MAC_RX_CFG_CST			BIT(2)
+#define MAC_RX_CFG_DCRCC		BIT(3)
+#define MAC_RX_CFG_SPEN			BIT(4)
+#define MAC_RX_CFG_USP			BIT(5)
+#define MAC_RX_CFG_GPSLCE		BIT(6)
+#define MAC_RX_CFG_WD			BIT(7)
+#define MAC_RX_CFG_JE			BIT(8)
+#define MAC_RX_CFG_IPC			BIT(9)
+#define MAC_RX_CFG_LM			BIT(10)
+#define MAC_RX_CFG_S2KP			BIT(11)
+#define MAC_RX_CFG_HDSMS		GENMASK(14, 12)
+#define MAC_RX_CFG_GPSL			GENMASK(29, 16)
+#define MAC_RX_CFG_ELEN			BIT(30)
+#define MAC_RX_CFG_ARPEN		BIT(31)
+
+#define MAC_PKT_FR			0x0008
+#define MAC_PKT_FR_PR			BIT(0)
+#define MAC_PKT_FR_HUC			BIT(1)
+#define MAC_PKT_FR_HMC			BIT(2)
+#define MAC_PKT_FR_DAIF			BIT(3)
+#define MAC_PKT_FR_PM			BIT(4)
+#define MAC_PKT_FR_DBF			BIT(5)
+#define MAC_PKT_FR_PCF			GENMASK(7, 6)
+#define MAC_PKT_FR_SAIF			BIT(8)
+#define MAC_PKT_FR_SAF			BIT(9)
+#define MAC_PKT_FR_HPF			BIT(10)
+#define MAC_PKT_FR_VTFE			BIT(16)
+#define MAC_PKT_FR_IPFE			BIT(20)
+#define MAC_PKT_FR_DNTU			BIT(21)
+#define MAC_PKT_FR_VUCC			BIT(22)
+#define MAC_PKT_FR_RA			BIT(31)
+#define MAC_TX_FCR			0x0070
+#define MAC_TX_FCR_FCB			BIT(0)
+#define MAC_TX_FCR_TFE			BIT(1)
+#define MAC_TX_FCR_PLT			GENMASK(6, 4)
+#define MAC_TX_FCR_DZPQ			BIT(7)
+#define MAC_TX_FCR_PT			GENMASK(31, 16)
+
+#define MAC_TX_FCR1			0x0074
+#define MAC_TX_FCR2			0x0078
+#define MAC_TX_FCR3			0x007C
+#define MAC_TX_FCR4			0x0080
+#define MAC_TX_FCR5			0x0084
+#define MAC_TX_FCR6			0x0088
+#define MAC_TX_FCR7			0x008C
+#define MAC_RX_FCR			0x0090
+#define MAC_RX_FCR_RFE			BIT(0)
+#define MAC_RX_FCR_UP			BIT(1)
+#define MAC_RX_FCR_PFCE			BIT(8)
+
+#define MAC_ISR				0x00b0
+#define MAC_IER				0x00b4
+#define MAC_RXTX_STS			0x00b8
+#define MAC_PMT_CSR			0x00c0
+#define MAC_RWK_PFR			0x00c4
+#define MAC_LPI_CSR			0x00d0
+#define MAC_LPI_CSR_TLPIEN		BIT(0)
+#define MAC_LPI_CSR_TLPIEX		BIT(1)
+#define MAC_LPI_CSR_RLPIEN		BIT(2)
+#define MAC_LPI_CSR_RLPIEX		BIT(3)
+#define MAC_LPI_CSR_TLPIST		BIT(8)
+#define MAC_LPI_CSR_RLPIST		BIT(9)
+#define MAC_LPI_CSR_RXRSTP		BIT(10)
+#define MAC_LPI_CSR_TXRSTP		BIT(11)
+#define MAC_LPI_CSR_LPITXEN		BIT(16)
+#define MAC_LPI_CSR_PLS			BIT(17)
+#define MAC_LPI_CSR_PLSDIS		BIT(18)
+#define MAC_LPI_CSR_LPITXA		BIT(19)
+#define MAC_LPI_CSR_LPIATE		BIT(20)
+#define MAC_LPI_CSR_TXCGE		BIT(21)
+
+#define MAC_LPI_TCR			0x00d4
+#define MAC_VER				0x0110
+#define MAC_VER_USERVER			GENMASK(23, 16)
+
+#define MAC_HW_F0			0x011c
+#define MAC_HW_F0_GMIISEL		BIT(1)
+#define MAC_HW_F0_VLHASH		BIT(4)
+#define MAC_HW_F0_SMASEL		BIT(5)
+#define MAC_HW_F0_RWKSEL		BIT(6)
+#define MAC_HW_F0_MGKSEL		BIT(7)
+#define MAC_HW_F0_MMCSEL		BIT(8)
+#define MAC_HW_F0_ARPOFFSEL		BIT(9)
+#define MAC_HW_F0_TSSEL			BIT(12)
+#define MAC_HW_F0_EEESEL		BIT(13)
+#define MAC_HW_F0_TXCOESEL		BIT(14)
+#define MAC_HW_F0_RXCOESEL		BIT(16)
+#define MAC_HW_F0_ADDMACADRSEL		GENMASK(22, 18)
+#define MAC_HW_F0_TSSTSSEL		GENMASK(26, 25)
+#define MAC_HW_F0_SAVLANINS		BIT(27)
+#define MAC_HW_F0_VXN			BIT(29)
+#define MAC_HW_F0_EDIFFC		BIT(30)
+#define MAC_HW_F0_EDMA			BIT(31)
+
+#define MAC_HW_F1			0x0120
+#define MAC_HW_F1_RXFIFOSIZE		GENMASK(4, 0)
+#define MAC_HW_F1_TXFIFOSIZE		GENMASK(10, 6)
+#define MAC_HW_F1_OSTEN			BIT(11)
+#define MAC_HW_F1_PTOEN			BIT(12)
+#define MAC_HW_F1_ADVTHWORD		BIT(13)
+#define MAC_HW_F1_ADDR64		GENMASK(15, 14)
+#define MAC_HW_F1_DCBEN			BIT(16)
+#define MAC_HW_F1_SPHEN			BIT(17)
+#define MAC_HW_F1_TSOEN			BIT(18)
+#define MAC_HW_F1_DBGMEMA		BIT(19)
+#define MAC_HW_F1_RSSEN			BIT(20)
+#define MAC_HW_F1_NUMTC			GENMASK(23, 21)
+#define MAC_HW_F1_HASHTBLSZ		GENMASK(25, 24)
+#define MAC_HW_F1_L3L4FNUM		GENMASK(30, 27)
+
+#define MAC_HW_F2			0x0124
+#define MAC_HW_F2_RXQCNT		GENMASK(3, 0)
+#define MAC_HW_F2_TXQCNT		GENMASK(9, 6)
+#define MAC_HW_F2_RXCHCNT		GENMASK(15, 12)
+#define MAC_HW_F2_TXCHCNT		GENMASK(21, 18)
+#define MAC_HW_F2_PPSOUTNUM		GENMASK(26, 24)
+#define MAC_HW_F2_AUXSNAPNUM		GENMASK(30, 28)
+
+#define MAC_EXTCFG			0x0140
+#define MAC_EXTCFG_SBDIOEN		BIT(8)
+
+#define MDIO_SCAR			0x200
+#define MDIO_SCAR_RA			GENMASK(15, 0)
+#define MDIO_SCAR_PA			GENMASK(20, 16)
+#define MDIO_SCAR_DA			GENMASK(25, 21)
+
+#define MDIO_SCCDR			0x204
+#define MDIO_SCCDR_SDATA		GENMASK(15, 0)
+#define MDIO_SCCDR_CMD			GENMASK(17, 16)
+#define MDIO_SCCDR_SADDR		BIT(18)
+#define MDIO_SCCDR_CR			GENMASK(21, 19)
+#define MDIO_SCCDR_BUSY			BIT(22)
+
+#define MDIO_C22P			0x220
+#define MDIO_C22P_PORT(idx)		BIT(idx)
+
+#define MAC_MACA0HR			0x0300
+#define MAC_MACA0LR			0x0304
+#define MAC_MACA1HR			0x0308
+#define MAC_MACA1LR			0x030c
+
+#define MMC_CR				0x0800
+
+#define MMC_TXOCTETCOUNT_GB_LO		0x0814
+#define MMC_TXFRAMECOUNT_GB_LO		0x081c
+#define MMC_TXBROADCASTFRAMES_G_LO	0x0824
+#define MMC_TXMULTICASTFRAMES_G_LO	0x082c
+#define MMC_TXUNICASTFRAMES_GB_LO	0x0864
+#define MMC_TXMULTICASTFRAMES_GB_LO	0x086c
+#define MMC_TXBROADCASTFRAMES_GB_LO	0x0874
+#define MMC_TXUNDERFLOWERROR_LO		0x087c
+#define MMC_TXOCTETCOUNT_G_LO		0x0884
+#define MMC_TXFRAMECOUNT_G_LO		0x088c
+#define MMC_TXPAUSEFRAMES_LO		0x0894
+#define MMC_TXVLANFRAMES_G_LO		0x089c
+
+#define MMC_RXFRAMECOUNT_GB_LO		0x0900
+#define MMC_RXOCTETCOUNT_GB_LO		0x0908
+#define MMC_RXOCTETCOUNT_G_LO		0x0910
+#define MMC_RXBROADCASTFRAMES_G_LO	0x0918
+#define MMC_RXMULTICASTFRAMES_G_LO	0x0920
+#define MMC_RXCRCERROR_LO		0x0928
+#define MMC_RXRUNTERROR			0x0930
+#define MMC_RXJABBERERROR		0x0934
+#define MMC_RXUNDERSIZE_G		0x0938
+#define MMC_RXOVERSIZE_G		0x093c
+#define MMC_RXUNICASTFRAMES_G_LO	0x0970
+#define MMC_RXLENGTHERROR_LO		0x0978
+#define MMC_RXOUTOFRANGETYPE_LO		0x0980
+#define MMC_RXPAUSEFRAMES_LO		0x0988
+#define MMC_RXFIFOOVERFLOW_LO		0x0990
+#define MMC_RXVLANFRAMES_GB_LO		0x0998
+#define MMC_RXWATCHDOGERROR		0x09a0
+
+#define MAC_TSTAMP_CR			0x0d00
+#define MAC_SUBSEC_INCR			0x0d04
+#define MAC_SYS_TIME_SEC		0x0d08
+#define MAC_SYS_TIME_NSEC		0x0d0c
+#define MAC_SYS_TIME_SEC_UPD		0x0d10
+#define MAC_SYS_TIME_NSEC_UPD		0x0d14
+#define MAC_TSTAMP_ADDNDR		0x0d18
+#define MAC_TSTAMP_STSR			0x0d20
+#define MAC_TXTSTAMP_NSECR		0x0d30
+#define MAC_TXTSTAMP_SECR		0x0d34
+#define MAC_TXTSTAMP_STS		0x0d38
+#define MAC_AUX_CTRL			0x0d40
+#define MAC_AUX_NSEC			0x0d48
+#define MAC_AUX_SEC			0x0d4c
+#define MAC_RX_PCH_CRC_CNT		0x0d2c
+
+#define XGMAC_Q_INC			0x100
+#define XGMAC_CTRL_REG(idx)					\
+	(XGMAC_REGACC_CTRL + ((idx) - MAC2) * XGMAC_Q_INC)
+#define XGMAC_DATA0_REG(idx)					\
+	(XGMAC_REGACC_DATA0 + ((idx) - MAC2) * XGMAC_Q_INC)
+#define XGMAC_DATA1_REG(idx)					\
+	(XGMAC_REGACC_DATA1 + ((idx) - MAC2) * XGMAC_Q_INC)
+
+#define MASK_LOW			GENMASK(15, 0)
+#define MASK_HIGH			GENMASK(31, 16)
+
+/* gaint packet size limit */
+#define XGMAC_MAX_GPSL			9000
+#define XGMAC_MAX_SUPPORTED_MTU		16380
+
+#define XGMAC_MAX_STD_PACKET		1518
+
+#endif
-- 
2.25.3

