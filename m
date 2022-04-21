Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D146509B46
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 10:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387019AbiDUIz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 04:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387014AbiDUIzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 04:55:23 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855DE205E6
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:52:33 -0700 (PDT)
Received: from kwepemi100022.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KkWVn4lr1z1J9wt;
        Thu, 21 Apr 2022 16:51:45 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100022.china.huawei.com (7.221.188.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 16:52:31 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 16:52:31 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH ethtool-next v2 1/2] update UAPI header copies
Date:   Thu, 21 Apr 2022 16:46:45 +0800
Message-ID: <20220421084646.15458-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220421084646.15458-1-huangguangbin2@huawei.com>
References: <20220421084646.15458-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Update to kernel commit cc4bdef26ecd.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 uapi/linux/ethtool_netlink.h |  9 ++++
 uapi/linux/if_link.h         | 97 ++++++++++++++++++++++++++++++++++++
 uapi/linux/net_tstamp.h      | 17 ++++++-
 uapi/linux/netlink.h         |  1 +
 uapi/linux/rtnetlink.h       | 16 ++++++
 5 files changed, 139 insertions(+), 1 deletion(-)

diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index d8b19cf..378ad7d 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -318,6 +318,12 @@ enum {
 
 /* RINGS */
 
+enum {
+	ETHTOOL_TCP_DATA_SPLIT_UNKNOWN = 0,
+	ETHTOOL_TCP_DATA_SPLIT_DISABLED,
+	ETHTOOL_TCP_DATA_SPLIT_ENABLED,
+};
+
 enum {
 	ETHTOOL_A_RINGS_UNSPEC,
 	ETHTOOL_A_RINGS_HEADER,				/* nest - _A_HEADER_* */
@@ -330,6 +336,9 @@ enum {
 	ETHTOOL_A_RINGS_RX_JUMBO,			/* u32 */
 	ETHTOOL_A_RINGS_TX,				/* u32 */
 	ETHTOOL_A_RINGS_RX_BUF_LEN,                     /* u32 */
+	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
+	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
+	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_RINGS_CNT,
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index 9ed264d..34002e7 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -211,6 +211,9 @@ struct rtnl_link_stats {
  * @rx_nohandler: Number of packets received on the interface
  *   but dropped by the networking stack because the device is
  *   not designated to receive packets (e.g. backup link in a bond).
+ *
+ * @rx_otherhost_dropped: Number of packets dropped due to mismatch
+ *   in destination MAC address.
  */
 struct rtnl_link_stats64 {
 	__u64	rx_packets;
@@ -243,6 +246,23 @@ struct rtnl_link_stats64 {
 	__u64	rx_compressed;
 	__u64	tx_compressed;
 	__u64	rx_nohandler;
+
+	__u64	rx_otherhost_dropped;
+};
+
+/* Subset of link stats useful for in-HW collection. Meaning of the fields is as
+ * for struct rtnl_link_stats64.
+ */
+struct rtnl_hw_stats64 {
+	__u64	rx_packets;
+	__u64	tx_packets;
+	__u64	rx_bytes;
+	__u64	tx_bytes;
+	__u64	rx_errors;
+	__u64	tx_errors;
+	__u64	rx_dropped;
+	__u64	tx_dropped;
+	__u64	multicast;
 };
 
 /* The struct should be in sync with struct ifmap */
@@ -347,6 +367,7 @@ enum {
 	 */
 	IFLA_PARENT_DEV_NAME,
 	IFLA_PARENT_DEV_BUS_NAME,
+	IFLA_GRO_MAX_SIZE,
 
 	__IFLA_MAX
 };
@@ -534,6 +555,7 @@ enum {
 	IFLA_BRPORT_MRP_IN_OPEN,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
+	IFLA_BRPORT_LOCKED,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
@@ -709,7 +731,55 @@ enum ipvlan_mode {
 #define IPVLAN_F_PRIVATE	0x01
 #define IPVLAN_F_VEPA		0x02
 
+/* Tunnel RTM header */
+struct tunnel_msg {
+	__u8 family;
+	__u8 flags;
+	__u16 reserved2;
+	__u32 ifindex;
+};
+
 /* VXLAN section */
+
+/* include statistics in the dump */
+#define TUNNEL_MSG_FLAG_STATS	0x01
+
+#define TUNNEL_MSG_VALID_USER_FLAGS TUNNEL_MSG_FLAG_STATS
+
+/* Embedded inside VXLAN_VNIFILTER_ENTRY_STATS */
+enum {
+	VNIFILTER_ENTRY_STATS_UNSPEC,
+	VNIFILTER_ENTRY_STATS_RX_BYTES,
+	VNIFILTER_ENTRY_STATS_RX_PKTS,
+	VNIFILTER_ENTRY_STATS_RX_DROPS,
+	VNIFILTER_ENTRY_STATS_RX_ERRORS,
+	VNIFILTER_ENTRY_STATS_TX_BYTES,
+	VNIFILTER_ENTRY_STATS_TX_PKTS,
+	VNIFILTER_ENTRY_STATS_TX_DROPS,
+	VNIFILTER_ENTRY_STATS_TX_ERRORS,
+	VNIFILTER_ENTRY_STATS_PAD,
+	__VNIFILTER_ENTRY_STATS_MAX
+};
+#define VNIFILTER_ENTRY_STATS_MAX (__VNIFILTER_ENTRY_STATS_MAX - 1)
+
+enum {
+	VXLAN_VNIFILTER_ENTRY_UNSPEC,
+	VXLAN_VNIFILTER_ENTRY_START,
+	VXLAN_VNIFILTER_ENTRY_END,
+	VXLAN_VNIFILTER_ENTRY_GROUP,
+	VXLAN_VNIFILTER_ENTRY_GROUP6,
+	VXLAN_VNIFILTER_ENTRY_STATS,
+	__VXLAN_VNIFILTER_ENTRY_MAX
+};
+#define VXLAN_VNIFILTER_ENTRY_MAX	(__VXLAN_VNIFILTER_ENTRY_MAX - 1)
+
+enum {
+	VXLAN_VNIFILTER_UNSPEC,
+	VXLAN_VNIFILTER_ENTRY,
+	__VXLAN_VNIFILTER_MAX
+};
+#define VXLAN_VNIFILTER_MAX	(__VXLAN_VNIFILTER_MAX - 1)
+
 enum {
 	IFLA_VXLAN_UNSPEC,
 	IFLA_VXLAN_ID,
@@ -741,6 +811,7 @@ enum {
 	IFLA_VXLAN_GPE,
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
+	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
@@ -774,6 +845,7 @@ enum {
 	IFLA_GENEVE_LABEL,
 	IFLA_GENEVE_TTL_INHERIT,
 	IFLA_GENEVE_DF,
+	IFLA_GENEVE_INNER_PROTO_INHERIT,
 	__IFLA_GENEVE_MAX
 };
 #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
@@ -819,6 +891,8 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
+	IFLA_GTP_CREATE_SOCKETS,
+	IFLA_GTP_RESTART_COUNT,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
@@ -857,6 +931,7 @@ enum {
 	IFLA_BOND_PEER_NOTIF_DELAY,
 	IFLA_BOND_AD_LACP_ACTIVE,
 	IFLA_BOND_MISSED_MAX,
+	IFLA_BOND_NS_IP6_TARGET,
 	__IFLA_BOND_MAX,
 };
 
@@ -1153,6 +1228,17 @@ enum {
 
 #define IFLA_STATS_FILTER_BIT(ATTR)	(1 << (ATTR - 1))
 
+enum {
+	IFLA_STATS_GETSET_UNSPEC,
+	IFLA_STATS_GET_FILTERS, /* Nest of IFLA_STATS_LINK_xxx, each a u32 with
+				 * a filter mask for the corresponding group.
+				 */
+	IFLA_STATS_SET_OFFLOAD_XSTATS_L3_STATS, /* 0 or 1 as u8 */
+	__IFLA_STATS_GETSET_MAX,
+};
+
+#define IFLA_STATS_GETSET_MAX (__IFLA_STATS_GETSET_MAX - 1)
+
 /* These are embedded into IFLA_STATS_LINK_XSTATS:
  * [IFLA_STATS_LINK_XSTATS]
  * -> [LINK_XSTATS_TYPE_xxx]
@@ -1170,10 +1256,21 @@ enum {
 enum {
 	IFLA_OFFLOAD_XSTATS_UNSPEC,
 	IFLA_OFFLOAD_XSTATS_CPU_HIT, /* struct rtnl_link_stats64 */
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO,	/* HW stats info. A nest */
+	IFLA_OFFLOAD_XSTATS_L3_STATS,	/* struct rtnl_hw_stats64 */
 	__IFLA_OFFLOAD_XSTATS_MAX
 };
 #define IFLA_OFFLOAD_XSTATS_MAX (__IFLA_OFFLOAD_XSTATS_MAX - 1)
 
+enum {
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_UNSPEC,
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_REQUEST,		/* u8 */
+	IFLA_OFFLOAD_XSTATS_HW_S_INFO_USED,		/* u8 */
+	__IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX,
+};
+#define IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX \
+	(__IFLA_OFFLOAD_XSTATS_HW_S_INFO_MAX - 1)
+
 /* XDP section */
 
 #define XDP_FLAGS_UPDATE_IF_NOEXIST	(1U << 0)
diff --git a/uapi/linux/net_tstamp.h b/uapi/linux/net_tstamp.h
index fcc61c7..55501e5 100644
--- a/uapi/linux/net_tstamp.h
+++ b/uapi/linux/net_tstamp.h
@@ -62,7 +62,7 @@ struct so_timestamping {
 /**
  * struct hwtstamp_config - %SIOCGHWTSTAMP and %SIOCSHWTSTAMP parameter
  *
- * @flags:	no flags defined right now, must be zero for %SIOCSHWTSTAMP
+ * @flags:	one of HWTSTAMP_FLAG_*
  * @tx_type:	one of HWTSTAMP_TX_*
  * @rx_filter:	one of HWTSTAMP_FILTER_*
  *
@@ -78,6 +78,21 @@ struct hwtstamp_config {
 	int rx_filter;
 };
 
+/* possible values for hwtstamp_config->flags */
+enum hwtstamp_flags {
+	/*
+	 * With this flag, the user could get bond active interface's
+	 * PHC index. Note this PHC index is not stable as when there
+	 * is a failover, the bond active interface will be changed, so
+	 * will be the PHC index.
+	 */
+	HWTSTAMP_FLAG_BONDED_PHC_INDEX = (1<<0),
+#define HWTSTAMP_FLAG_BONDED_PHC_INDEX	HWTSTAMP_FLAG_BONDED_PHC_INDEX
+
+	HWTSTAMP_FLAG_LAST = HWTSTAMP_FLAG_BONDED_PHC_INDEX,
+	HWTSTAMP_FLAG_MASK = (HWTSTAMP_FLAG_LAST - 1) | HWTSTAMP_FLAG_LAST
+};
+
 /* possible values for hwtstamp_config->tx_type */
 enum hwtstamp_tx_types {
 	/*
diff --git a/uapi/linux/netlink.h b/uapi/linux/netlink.h
index e83e2e3..105b79f 100644
--- a/uapi/linux/netlink.h
+++ b/uapi/linux/netlink.h
@@ -72,6 +72,7 @@ struct nlmsghdr {
 
 /* Modifiers to DELETE request */
 #define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
+#define NLM_F_BULK	0x200	/* Delete multiple objects	*/
 
 /* Flags for ACK message */
 #define NLM_F_CAPPED	0x100	/* request was capped */
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
index e01efa2..8f874be 100644
--- a/uapi/linux/rtnetlink.h
+++ b/uapi/linux/rtnetlink.h
@@ -146,6 +146,8 @@ enum {
 #define RTM_NEWSTATS RTM_NEWSTATS
 	RTM_GETSTATS = 94,
 #define RTM_GETSTATS RTM_GETSTATS
+	RTM_SETSTATS,
+#define RTM_SETSTATS RTM_SETSTATS
 
 	RTM_NEWCACHEREPORT = 96,
 #define RTM_NEWCACHEREPORT RTM_NEWCACHEREPORT
@@ -185,6 +187,13 @@ enum {
 	RTM_GETNEXTHOPBUCKET,
 #define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
 
+	RTM_NEWTUNNEL = 120,
+#define RTM_NEWTUNNEL	RTM_NEWTUNNEL
+	RTM_DELTUNNEL,
+#define RTM_DELTUNNEL	RTM_DELTUNNEL
+	RTM_GETTUNNEL,
+#define RTM_GETTUNNEL	RTM_GETTUNNEL
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
@@ -752,6 +761,12 @@ enum rtnetlink_groups {
 #define RTNLGRP_NEXTHOP		RTNLGRP_NEXTHOP
 	RTNLGRP_BRVLAN,
 #define RTNLGRP_BRVLAN		RTNLGRP_BRVLAN
+	RTNLGRP_MCTP_IFADDR,
+#define RTNLGRP_MCTP_IFADDR	RTNLGRP_MCTP_IFADDR
+	RTNLGRP_TUNNEL,
+#define RTNLGRP_TUNNEL		RTNLGRP_TUNNEL
+	RTNLGRP_STATS,
+#define RTNLGRP_STATS		RTNLGRP_STATS
 	__RTNLGRP_MAX
 };
 #define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
@@ -800,6 +815,7 @@ enum {
 #define RTEXT_FILTER_MRP	(1 << 4)
 #define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
 #define RTEXT_FILTER_CFM_STATUS	(1 << 6)
+#define RTEXT_FILTER_MST	(1 << 7)
 
 /* End of information exported to user level */
 
-- 
2.33.0

