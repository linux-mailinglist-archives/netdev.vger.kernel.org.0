Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3152D1E7042
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437511AbgE1XVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:21:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:49250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437494AbgE1XV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9562AAFE8;
        Thu, 28 May 2020 23:21:27 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B8CA4E32D2; Fri, 29 May 2020 01:21:27 +0200 (CEST)
Message-Id: <eda90c3f9b209b7470c0acc6f34c5c60a06c65f3.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 04/21] update UAPI header copies
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:27 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel v5.7-rc7.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 uapi/linux/ethtool.h         |   9 +-
 uapi/linux/ethtool_netlink.h | 175 +++++++++++++++++++++++++++++++++++
 uapi/linux/if_link.h         |   6 +-
 uapi/linux/net_tstamp.h      |   6 ++
 4 files changed, 193 insertions(+), 3 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index d3dcb459195c..c5c394899270 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -594,6 +594,9 @@ struct ethtool_pauseparam {
  * @ETH_SS_LINK_MODES: link mode names
  * @ETH_SS_MSG_CLASSES: debug message class names
  * @ETH_SS_WOL_MODES: wake-on-lan modes
+ * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
+ * @ETH_SS_TS_TX_TYPES: timestamping Tx types
+ * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -608,6 +611,9 @@ enum ethtool_stringset {
 	ETH_SS_LINK_MODES,
 	ETH_SS_MSG_CLASSES,
 	ETH_SS_WOL_MODES,
+	ETH_SS_SOF_TIMESTAMPING,
+	ETH_SS_TS_TX_TYPES,
+	ETH_SS_TS_RX_FILTERS,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -1521,8 +1527,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
-	ETHTOOL_LINK_MODE_FEC_LLRS_BIT                   = 74,
-
+	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index ad6d3a00019d..10061e4b16d9 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -24,6 +24,21 @@ enum {
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
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -43,6 +58,22 @@ enum {
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
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -228,6 +259,150 @@ enum {
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
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index cb88bcb47287..978f98c76be1 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -461,6 +461,7 @@ enum {
 	IFLA_MACSEC_REPLAY_PROTECT,
 	IFLA_MACSEC_VALIDATION,
 	IFLA_MACSEC_PAD,
+	IFLA_MACSEC_OFFLOAD,
 	__IFLA_MACSEC_MAX,
 };
 
@@ -487,6 +488,7 @@ enum macsec_validation_type {
 enum macsec_offload {
 	MACSEC_OFFLOAD_OFF = 0,
 	MACSEC_OFFLOAD_PHY = 1,
+	MACSEC_OFFLOAD_MAC = 2,
 	__MACSEC_OFFLOAD_END,
 	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
 };
@@ -970,11 +972,12 @@ enum {
 #define XDP_FLAGS_SKB_MODE		(1U << 1)
 #define XDP_FLAGS_DRV_MODE		(1U << 2)
 #define XDP_FLAGS_HW_MODE		(1U << 3)
+#define XDP_FLAGS_REPLACE		(1U << 4)
 #define XDP_FLAGS_MODES			(XDP_FLAGS_SKB_MODE | \
 					 XDP_FLAGS_DRV_MODE | \
 					 XDP_FLAGS_HW_MODE)
 #define XDP_FLAGS_MASK			(XDP_FLAGS_UPDATE_IF_NOEXIST | \
-					 XDP_FLAGS_MODES)
+					 XDP_FLAGS_MODES | XDP_FLAGS_REPLACE)
 
 /* These are stored into IFLA_XDP_ATTACHED on dump. */
 enum {
@@ -994,6 +997,7 @@ enum {
 	IFLA_XDP_DRV_PROG_ID,
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
+	IFLA_XDP_EXPECTED_FD,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/uapi/linux/net_tstamp.h b/uapi/linux/net_tstamp.h
index f96e650d0af9..7ed0b3d1c00a 100644
--- a/uapi/linux/net_tstamp.h
+++ b/uapi/linux/net_tstamp.h
@@ -98,6 +98,9 @@ enum hwtstamp_tx_types {
 	 * receive a time stamp via the socket error queue.
 	 */
 	HWTSTAMP_TX_ONESTEP_P2P,
+
+	/* add new constants above here */
+	__HWTSTAMP_TX_CNT
 };
 
 /* possible values for hwtstamp_config->rx_filter */
@@ -140,6 +143,9 @@ enum hwtstamp_rx_filters {
 
 	/* NTP, UDP, all versions and packet modes */
 	HWTSTAMP_FILTER_NTP_ALL,
+
+	/* add new constants above here */
+	__HWTSTAMP_FILTER_CNT
 };
 
 /* SCM_TIMESTAMPING_PKTINFO control message */
-- 
2.26.2

