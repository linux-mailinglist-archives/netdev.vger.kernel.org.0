Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B931C1799B0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgCDUYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:24:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:33140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCDUYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:24:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5C5CCAD41;
        Wed,  4 Mar 2020 20:24:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 0A14DE037F; Wed,  4 Mar 2020 21:24:46 +0100 (CET)
Message-Id: <a0ad19a363ee0be54663a62867d1c1178d07a7f1.1583347351.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583347351.git.mkubecek@suse.cz>
References: <cover.1583347351.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 02/25] update UAPI header copies
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Wed,  4 Mar 2020 21:24:46 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to v5.6-rc1.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 uapi/linux/ethtool.h    | 17 +++++++++++++++++
 uapi/linux/net_tstamp.h | 27 +++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 9afd2e6c5eea..16198061d723 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -591,6 +591,9 @@ struct ethtool_pauseparam {
  * @ETH_SS_RSS_HASH_FUNCS: RSS hush function names
  * @ETH_SS_PHY_STATS: Statistic names, for use with %ETHTOOL_GPHYSTATS
  * @ETH_SS_PHY_TUNABLES: PHY tunable names
+ * @ETH_SS_LINK_MODES: link mode names
+ * @ETH_SS_MSG_CLASSES: debug message class names
+ * @ETH_SS_WOL_MODES: wake-on-lan modes
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -602,6 +605,12 @@ enum ethtool_stringset {
 	ETH_SS_TUNABLES,
 	ETH_SS_PHY_STATS,
 	ETH_SS_PHY_TUNABLES,
+	ETH_SS_LINK_MODES,
+	ETH_SS_MSG_CLASSES,
+	ETH_SS_WOL_MODES,
+
+	/* add new constants above here */
+	ETH_SS_COUNT
 };
 
 /**
@@ -1505,6 +1514,11 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
 	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
 	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
+	ETHTOOL_LINK_MODE_400000baseKR8_Full_BIT	 = 69,
+	ETHTOOL_LINK_MODE_400000baseSR8_Full_BIT	 = 70,
+	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT = 71,
+	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
+	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
@@ -1616,6 +1630,7 @@ enum ethtool_link_mode_bit_indices {
 #define SPEED_56000		56000
 #define SPEED_100000		100000
 #define SPEED_200000		200000
+#define SPEED_400000		400000
 
 #define SPEED_UNKNOWN		-1
 
@@ -1680,6 +1695,8 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
 #define WAKE_MAGICSECURE	(1 << 6) /* only meaningful if WAKE_MAGIC */
 #define WAKE_FILTER		(1 << 7)
 
+#define WOL_MODE_COUNT		8
+
 /* L2-L4 network traffic flow types */
 #define	TCP_V4_FLOW	0x01	/* hash or spec (tcp_ip4_spec) */
 #define	UDP_V4_FLOW	0x02	/* hash or spec (udp_ip4_spec) */
diff --git a/uapi/linux/net_tstamp.h b/uapi/linux/net_tstamp.h
index 3d421d912193..f96e650d0af9 100644
--- a/uapi/linux/net_tstamp.h
+++ b/uapi/linux/net_tstamp.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * Userspace API for hardware time stamping of network packets
  *
@@ -89,6 +90,14 @@ enum hwtstamp_tx_types {
 	 * queue.
 	 */
 	HWTSTAMP_TX_ONESTEP_SYNC,
+
+	/*
+	 * Same as HWTSTAMP_TX_ONESTEP_SYNC, but also enables time
+	 * stamp insertion directly into PDelay_Resp packets. In this
+	 * case, neither transmitted Sync nor PDelay_Resp packets will
+	 * receive a time stamp via the socket error queue.
+	 */
+	HWTSTAMP_TX_ONESTEP_P2P,
 };
 
 /* possible values for hwtstamp_config->rx_filter */
@@ -140,4 +149,22 @@ struct scm_ts_pktinfo {
 	__u32 reserved[2];
 };
 
+/*
+ * SO_TXTIME gets a struct sock_txtime with flags being an integer bit
+ * field comprised of these values.
+ */
+enum txtime_flags {
+	SOF_TXTIME_DEADLINE_MODE = (1 << 0),
+	SOF_TXTIME_REPORT_ERRORS = (1 << 1),
+
+	SOF_TXTIME_FLAGS_LAST = SOF_TXTIME_REPORT_ERRORS,
+	SOF_TXTIME_FLAGS_MASK = (SOF_TXTIME_FLAGS_LAST - 1) |
+				 SOF_TXTIME_FLAGS_LAST
+};
+
+struct sock_txtime {
+	__kernel_clockid_t	clockid;/* reference clockid */
+	__u32			flags;	/* as defined by enum txtime_flags */
+};
+
 #endif /* _NET_TIMESTAMPING_H */
-- 
2.25.1

