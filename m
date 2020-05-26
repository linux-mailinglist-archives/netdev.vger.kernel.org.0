Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0BC1D5DA8
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgEPBaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:30:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:39711 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgEPBai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 21:30:38 -0400
IronPort-SDR: NS0jBLtmu8i+MSfM6j6g+HyVPeTkA3kJxdSMctGvYDEzXf3vvBWXp8BocFzvt0dUi9Gm+wc0o6
 PZc7DbFRje7A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 18:30:38 -0700
IronPort-SDR: w3Ws/zzXe+1ajL5Z/AryATJvC8PQFejBkHfbECcnkphEvIOivgH0Vwh4BBMbq1W4gPaIVzAWdV
 uwCycKdbsqqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,397,1583222400"; 
   d="scan'208";a="307569380"
Received: from wkbertra-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.131.129])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 18:30:37 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, linville@tuxdriver.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: [ethtool RFC 1/3] uapi: Update headers from the kernel [DO NOT APPLY]
Date:   Fri, 15 May 2020 18:30:24 -0700
Message-Id: <20200516013026.3174098-2-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516013026.3174098-1-vinicius.gomes@intel.com>
References: <20200516013026.3174098-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only helps for testing while the kernel side patches are not applied.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 uapi/linux/ethtool.h         |  49 ++++++-
 uapi/linux/ethtool_netlink.h | 267 +++++++++++++++++++++++++++++++++++
 2 files changed, 315 insertions(+), 1 deletion(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index d3dcb45..676a472 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -18,7 +18,9 @@
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
+#ifndef __KERNEL__
 #include <limits.h> /* for INT_MAX */
+#endif
 
 /* All structures exposed to userland should be defined such that they
  * have the same layout for 32-bit and 64-bit userland.
@@ -367,6 +369,28 @@ struct ethtool_eee {
 	__u32	reserved[2];
 };
 
+/**
+ * struct ethtool_fp - Frame Preemption information
+ * @cmd: ETHTOOL_{G,S}FP
+ * @fp_supported: If frame preemption is supported.
+ * @fp_enabled: If frame preemption should be advertised to the link partner
+ *	as enabled.
+ * @supported_queues_mask: Bitmask indicating which queues support being
+ *	configured as preemptible (bit 0 -> queue 0, bit N -> queue N).
+ * @preemptible_queues_mask: Bitmask indicating which queues are
+ *	configured as preemptible (bit 0 -> queue 0, bit N -> queue N).
+ * @min_frag_size: Minimum size for all non-final fragment size.
+ */
+struct ethtool_fp {
+	__u32	cmd;
+	__u8	fp_supported;
+	__u8	fp_enabled;
+	__u32	supported_queues_mask;
+	__u32	preemptible_queues_mask;
+	__u32	min_frag_size;
+	__u32	reserved[2];
+};
+
 /**
  * struct ethtool_modinfo - plugin module eeprom information
  * @cmd: %ETHTOOL_GMODULEINFO
@@ -594,6 +618,9 @@ struct ethtool_pauseparam {
  * @ETH_SS_LINK_MODES: link mode names
  * @ETH_SS_MSG_CLASSES: debug message class names
  * @ETH_SS_WOL_MODES: wake-on-lan modes
+ * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
+ * @ETH_SS_TS_TX_TYPES: timestamping Tx types
+ * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -608,6 +635,9 @@ enum ethtool_stringset {
 	ETH_SS_LINK_MODES,
 	ETH_SS_MSG_CLASSES,
 	ETH_SS_WOL_MODES,
+	ETH_SS_SOF_TIMESTAMPING,
+	ETH_SS_TS_TX_TYPES,
+	ETH_SS_TS_RX_FILTERS,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -1433,6 +1463,9 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_GFECPARAM	0x00000050 /* Get FEC settings */
 #define ETHTOOL_SFECPARAM	0x00000051 /* Set FEC settings */
 
+#define ETHTOOL_GFP		0x00000052 /* Get Frame Preemption settings */
+#define ETHTOOL_SFP		0x00000053 /* Set Frame Preemption settings */
+
 /* compatibility with older code */
 #define SPARC_ETH_GSET		ETHTOOL_GSET
 #define SPARC_ETH_SSET		ETHTOOL_SSET
@@ -1659,6 +1692,18 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
 	return 0;
 }
 
+#define MASTER_SLAVE_CFG_UNSUPPORTED		0
+#define MASTER_SLAVE_CFG_UNKNOWN		1
+#define MASTER_SLAVE_CFG_MASTER_PREFERRED	2
+#define MASTER_SLAVE_CFG_SLAVE_PREFERRED	3
+#define MASTER_SLAVE_CFG_MASTER_FORCE		4
+#define MASTER_SLAVE_CFG_SLAVE_FORCE		5
+#define MASTER_SLAVE_STATE_UNSUPPORTED		0
+#define MASTER_SLAVE_STATE_UNKNOWN		1
+#define MASTER_SLAVE_STATE_MASTER		2
+#define MASTER_SLAVE_STATE_SLAVE		3
+#define MASTER_SLAVE_STATE_ERR			4
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
@@ -1897,7 +1942,9 @@ struct ethtool_link_settings {
 	__u8	eth_tp_mdix_ctrl;
 	__s8	link_mode_masks_nwords;
 	__u8	transceiver;
-	__u8	reserved1[3];
+	__u8	master_slave_cfg;
+	__u8	master_slave_state;
+	__u8	reserved1[1];
 	__u32	reserved[7];
 	__u32	link_mode_masks[0];
 	/* layout of link_mode_masks fields:
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index ad6d3a0..5d35804 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -24,6 +24,24 @@ enum {
 	ETHTOOL_MSG_DEBUG_SET,
 	ETHTOOL_MSG_WOL_GET,
 	ETHTOOL_MSG_WOL_SET,
+	ETHTOOL_MSG_FEATURES_GET,
+	ETHTOOL_MSG_FEATURES_SET,
+	ETHTOOL_MSG_PRIVFLAGS_GET,
+	ETHTOOL_MSG_PRIVFLAGS_SET,
+	ETHTOOL_MSG_RINGS_GET,
+	ETHTOOL_MSG_RINGS_SET,
+	ETHTOOL_MSG_CHANNELS_GET,
+	ETHTOOL_MSG_CHANNELS_SET,
+	ETHTOOL_MSG_COALESCE_GET,
+	ETHTOOL_MSG_COALESCE_SET,
+	ETHTOOL_MSG_PAUSE_GET,
+	ETHTOOL_MSG_PAUSE_SET,
+	ETHTOOL_MSG_EEE_GET,
+	ETHTOOL_MSG_EEE_SET,
+	ETHTOOL_MSG_TSINFO_GET,
+	ETHTOOL_MSG_CABLE_TEST_ACT,
+	ETHTOOL_MSG_PREEMPT_GET,
+	ETHTOOL_MSG_PREEMPT_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -43,6 +61,25 @@ enum {
 	ETHTOOL_MSG_DEBUG_NTF,
 	ETHTOOL_MSG_WOL_GET_REPLY,
 	ETHTOOL_MSG_WOL_NTF,
+	ETHTOOL_MSG_FEATURES_GET_REPLY,
+	ETHTOOL_MSG_FEATURES_SET_REPLY,
+	ETHTOOL_MSG_FEATURES_NTF,
+	ETHTOOL_MSG_PRIVFLAGS_GET_REPLY,
+	ETHTOOL_MSG_PRIVFLAGS_NTF,
+	ETHTOOL_MSG_RINGS_GET_REPLY,
+	ETHTOOL_MSG_RINGS_NTF,
+	ETHTOOL_MSG_CHANNELS_GET_REPLY,
+	ETHTOOL_MSG_CHANNELS_NTF,
+	ETHTOOL_MSG_COALESCE_GET_REPLY,
+	ETHTOOL_MSG_COALESCE_NTF,
+	ETHTOOL_MSG_PAUSE_GET_REPLY,
+	ETHTOOL_MSG_PAUSE_NTF,
+	ETHTOOL_MSG_EEE_GET_REPLY,
+	ETHTOOL_MSG_EEE_NTF,
+	ETHTOOL_MSG_TSINFO_GET_REPLY,
+	ETHTOOL_MSG_CABLE_TEST_NTF,
+	ETHTOOL_MSG_PREEMPT_GET_REPLY,
+	ETHTOOL_MSG_PREEMPT_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -185,6 +222,8 @@ enum {
 	ETHTOOL_A_LINKMODES_PEER,		/* bitset */
 	ETHTOOL_A_LINKMODES_SPEED,		/* u32 */
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
+	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
+	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
@@ -228,6 +267,234 @@ enum {
 	ETHTOOL_A_WOL_MAX = __ETHTOOL_A_WOL_CNT - 1
 };
 
+/* FEATURES */
+
+enum {
+	ETHTOOL_A_FEATURES_UNSPEC,
+	ETHTOOL_A_FEATURES_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_FEATURES_HW,				/* bitset */
+	ETHTOOL_A_FEATURES_WANTED,			/* bitset */
+	ETHTOOL_A_FEATURES_ACTIVE,			/* bitset */
+	ETHTOOL_A_FEATURES_NOCHANGE,			/* bitset */
+
+	/* add new constants above here */
+	__ETHTOOL_A_FEATURES_CNT,
+	ETHTOOL_A_FEATURES_MAX = __ETHTOOL_A_FEATURES_CNT - 1
+};
+
+/* PRIVFLAGS */
+
+enum {
+	ETHTOOL_A_PRIVFLAGS_UNSPEC,
+	ETHTOOL_A_PRIVFLAGS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PRIVFLAGS_FLAGS,			/* bitset */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PRIVFLAGS_CNT,
+	ETHTOOL_A_PRIVFLAGS_MAX = __ETHTOOL_A_PRIVFLAGS_CNT - 1
+};
+
+/* RINGS */
+
+enum {
+	ETHTOOL_A_RINGS_UNSPEC,
+	ETHTOOL_A_RINGS_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_RINGS_RX_MAX,				/* u32 */
+	ETHTOOL_A_RINGS_RX_MINI_MAX,			/* u32 */
+	ETHTOOL_A_RINGS_RX_JUMBO_MAX,			/* u32 */
+	ETHTOOL_A_RINGS_TX_MAX,				/* u32 */
+	ETHTOOL_A_RINGS_RX,				/* u32 */
+	ETHTOOL_A_RINGS_RX_MINI,			/* u32 */
+	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
+	ETHTOOL_A_RINGS_TX,				/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_RINGS_CNT,
+	ETHTOOL_A_RINGS_MAX = (__ETHTOOL_A_RINGS_CNT - 1)
+};
+
+/* CHANNELS */
+
+enum {
+	ETHTOOL_A_CHANNELS_UNSPEC,
+	ETHTOOL_A_CHANNELS_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_CHANNELS_RX_MAX,			/* u32 */
+	ETHTOOL_A_CHANNELS_TX_MAX,			/* u32 */
+	ETHTOOL_A_CHANNELS_OTHER_MAX,			/* u32 */
+	ETHTOOL_A_CHANNELS_COMBINED_MAX,		/* u32 */
+	ETHTOOL_A_CHANNELS_RX_COUNT,			/* u32 */
+	ETHTOOL_A_CHANNELS_TX_COUNT,			/* u32 */
+	ETHTOOL_A_CHANNELS_OTHER_COUNT,			/* u32 */
+	ETHTOOL_A_CHANNELS_COMBINED_COUNT,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CHANNELS_CNT,
+	ETHTOOL_A_CHANNELS_MAX = (__ETHTOOL_A_CHANNELS_CNT - 1)
+};
+
+/* COALESCE */
+
+enum {
+	ETHTOOL_A_COALESCE_UNSPEC,
+	ETHTOOL_A_COALESCE_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_COALESCE_RX_USECS,			/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_USECS_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS,			/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_IRQ,		/* u32 */
+	ETHTOOL_A_COALESCE_STATS_BLOCK_USECS,		/* u32 */
+	ETHTOOL_A_COALESCE_USE_ADAPTIVE_RX,		/* u8 */
+	ETHTOOL_A_COALESCE_USE_ADAPTIVE_TX,		/* u8 */
+	ETHTOOL_A_COALESCE_PKT_RATE_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_USECS_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_LOW,		/* u32 */
+	ETHTOOL_A_COALESCE_PKT_RATE_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_USECS_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_RX_MAX_FRAMES_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
+	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_COALESCE_CNT,
+	ETHTOOL_A_COALESCE_MAX = (__ETHTOOL_A_COALESCE_CNT - 1)
+};
+
+/* PAUSE */
+
+enum {
+	ETHTOOL_A_PAUSE_UNSPEC,
+	ETHTOOL_A_PAUSE_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_PAUSE_AUTONEG,			/* u8 */
+	ETHTOOL_A_PAUSE_RX,				/* u8 */
+	ETHTOOL_A_PAUSE_TX,				/* u8 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PAUSE_CNT,
+	ETHTOOL_A_PAUSE_MAX = (__ETHTOOL_A_PAUSE_CNT - 1)
+};
+
+/* EEE */
+
+enum {
+	ETHTOOL_A_EEE_UNSPEC,
+	ETHTOOL_A_EEE_HEADER,				/* nest - _A_HEADER_* */
+	ETHTOOL_A_EEE_MODES_OURS,			/* bitset */
+	ETHTOOL_A_EEE_MODES_PEER,			/* bitset */
+	ETHTOOL_A_EEE_ACTIVE,				/* u8 */
+	ETHTOOL_A_EEE_ENABLED,				/* u8 */
+	ETHTOOL_A_EEE_TX_LPI_ENABLED,			/* u8 */
+	ETHTOOL_A_EEE_TX_LPI_TIMER,			/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_EEE_CNT,
+	ETHTOOL_A_EEE_MAX = (__ETHTOOL_A_EEE_CNT - 1)
+};
+
+/* TSINFO */
+
+enum {
+	ETHTOOL_A_TSINFO_UNSPEC,
+	ETHTOOL_A_TSINFO_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_TSINFO_TIMESTAMPING,			/* bitset */
+	ETHTOOL_A_TSINFO_TX_TYPES,			/* bitset */
+	ETHTOOL_A_TSINFO_RX_FILTERS,			/* bitset */
+	ETHTOOL_A_TSINFO_PHC_INDEX,			/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TSINFO_CNT,
+	ETHTOOL_A_TSINFO_MAX = (__ETHTOOL_A_TSINFO_CNT - 1)
+};
+
+/* CABLE TEST */
+
+enum {
+	ETHTOOL_A_CABLE_TEST_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_HEADER,		/* nest - _A_HEADER_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_CABLE_TEST_CNT,
+	ETHTOOL_A_CABLE_TEST_MAX = __ETHTOOL_A_CABLE_TEST_CNT - 1
+};
+
+/* CABLE TEST NOTIFY */
+enum {
+	ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_CODE_OK,
+	ETHTOOL_A_CABLE_RESULT_CODE_OPEN,
+	ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT,
+	ETHTOOL_A_CABLE_RESULT_CODE_CROSS_SHORT,
+};
+
+enum {
+	ETHTOOL_A_CABLE_PAIR_A,
+	ETHTOOL_A_CABLE_PAIR_B,
+	ETHTOOL_A_CABLE_PAIR_C,
+	ETHTOOL_A_CABLE_PAIR_D,
+};
+
+enum {
+	ETHTOOL_A_CABLE_RESULT_UNSPEC,
+	ETHTOOL_A_CABLE_RESULT_PAIR,		/* u8 ETHTOOL_A_CABLE_PAIR_ */
+	ETHTOOL_A_CABLE_RESULT_CODE,		/* u8 ETHTOOL_A_CABLE_RESULT_CODE_ */
+
+	__ETHTOOL_A_CABLE_RESULT_CNT,
+	ETHTOOL_A_CABLE_RESULT_MAX = (__ETHTOOL_A_CABLE_RESULT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_FAULT_LENGTH_UNSPEC,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR,	/* u8 ETHTOOL_A_CABLE_PAIR_ */
+	ETHTOOL_A_CABLE_FAULT_LENGTH_CM,	/* u32 */
+
+	__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT,
+	ETHTOOL_A_CABLE_FAULT_LENGTH_MAX = (__ETHTOOL_A_CABLE_FAULT_LENGTH_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED,
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED
+};
+
+enum {
+	ETHTOOL_A_CABLE_NEST_UNSPEC,
+	ETHTOOL_A_CABLE_NEST_RESULT,		/* nest - ETHTOOL_A_CABLE_RESULT_ */
+	ETHTOOL_A_CABLE_NEST_FAULT_LENGTH,	/* nest - ETHTOOL_A_CABLE_FAULT_LENGTH_ */
+	__ETHTOOL_A_CABLE_NEST_CNT,
+	ETHTOOL_A_CABLE_NEST_MAX = (__ETHTOOL_A_CABLE_NEST_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_CABLE_TEST_NTF_UNSPEC,
+	ETHTOOL_A_CABLE_TEST_NTF_HEADER,	/* nest - ETHTOOL_A_HEADER_* */
+	ETHTOOL_A_CABLE_TEST_NTF_STATUS,	/* u8 - _STARTED/_COMPLETE */
+	ETHTOOL_A_CABLE_TEST_NTF_NEST,		/* nest - of results: */
+
+	__ETHTOOL_A_CABLE_TEST_NTF_CNT,
+	ETHTOOL_A_CABLE_TEST_NTF_MAX = (__ETHTOOL_A_CABLE_TEST_NTF_CNT - 1)
+};
+
+/* FRAME PREEMPTION */
+enum {
+	ETHTOOL_A_PREEMPT_UNSPEC,
+	ETHTOOL_A_PREEMPT_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_PREEMPT_SUPPORTED,			/* u8 */
+	ETHTOOL_A_PREEMPT_ACTIVE,			/* u8 */
+	ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_PREEMPT_QUEUES_SUPPORTED,		/* u32 */
+	ETHTOOL_A_PREEMPT_QUEUES_PREEMPTIBLE,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_PREEMPT_CNT,
+	ETHTOOL_A_PREEMPT_MAX = (__ETHTOOL_A_PREEMPT_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
-- 
2.26.2

