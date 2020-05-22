Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337FC1DF34F
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387413AbgEVXwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:47 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731169AbgEVXwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUSPYTBh27JZ3/fNgB94BZtgViSYkTNkcrg5sBF0GxnYS1Ekmw721lTGbARZ/l/ZCsxWDzsqHfAlOzeKdTGdTRZ1itQPyQpFqwEsS6K3VVmNkI/+mkNh27oJ0KTnfiXdS7NJEHbM8jLbd+JvqIfV6P70mwwWhROo6mZLlTCj+DJHOViU1+YOIMWtb++Glka+fuT4dOT1+Qpmw4Shl2pHLus3iXy1BbOHOZ1l1t5lO/Hab+1CEQn0laCVLIpZQR7DcL2uRhfhebJacIh7K0LNB12gEJ1mGZK4QSpBrNxxoxUXb8CgIjZPAf9w6ZuhUdQnX4zkWecMDYEyikl+ZVC6JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hX9G6FEBZ3T844jyrm13Zq8LB1uMtYfn0wFh73/lfY=;
 b=mQRm3JqkBvJoqA0Mq8XQVV/C56H0h97Rd31zTTIXwQlMZFYSXivWpcDUy9X82Fc+0JhGJ2kMgrs/bmfVk5wol/Erq9SlHkwlm2Pyxxc3rUjTBGR3s1LeR3SURbX1OGE6S4YbHoCEp9LAxvMGR4Gtc/uE+gIMobV5HOSRMOKetJSvgKYmXldVcIcwJajqNhCzH2FzQDBcwKmbvDMqkjluAHbwBtHcB0k1+RgvNNi/9R8fPKw7ND7Ll+bH7kopXCl8I1/P5g10WPjDWvH7U/ajrqQYP1mALpJVLWGlSgbYi3eWZj2pgv5kCXbn+uSAKsxA6dEUc/UoMiRP63SNAeuPew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hX9G6FEBZ3T844jyrm13Zq8LB1uMtYfn0wFh73/lfY=;
 b=d1TNnlHEM+4GYb1Bnt+OcvASp+3jwDLmHRqG2KJlOJEG2G1wFk5RUH76OBRPeROmjgB29q8JuIiEFtIz2fc5HLYNhE6q5SfOfAmRgs8VIwotI/XXBgtZx5/f6tfg93Y45ohFuXfXQf0iHfkHcpJEMpp9aWXvXb5d2OPC/pX01rw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/10] net/mlx5e: Introduce kconfig var for TC support
Date:   Fri, 22 May 2020 16:51:43 -0700
Message-Id: <20200522235148.28987-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:18 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: efc59a65-fd5c-4094-e35f-08d7feab2a4a
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4544C63736F3B370037291B1BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9l6JsRwWqSGTrx872qNS1+ccaqe/0x9a1rZkbLolmplQJ1A6HaJnTxvyJ6QvlThnf3azvue3Pfr/d9oDoYGFB+wtOpr3INENudvnSVbsRcH63qnvGJJnEfgsKTJtR4Iflvs27cxness7fF6VRuf9EgPFlMyrJFYnZ+zyjhczaHDRJh8KRVMiWnhIfNrAfpfGZRaFJi9YVNvb4R34Un5PSrAID1sjCakUvSxRvRa3+0Zadu5Enm2sLVRgo2D6pFkK3LNHfzCI/UWvhtuPIAmse8qHGwxf+tCcQpXSoA0LYUJwJyfVA+eWhUqURzYHSpoD8mfTGqkQ2iCTWI5mjm8YEFl2KF14pw4RwpQHxJ6HFS/mxLXBOGbhNrqVTIdgVt0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(30864003)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OJkR4yA1m60rDgkZTUSofFL1PjZlD4TuYYB12u207PNOTxPRQWLfQXOnyEkzbfNsEgOUi2cp9U23ehiCs9RXMVFAfgREBwHqlC2F1nQzbpAI3tU7P8cr2OfVtvC3vUgsNN+v2vswERTwh8lNLOoBfNpwGYqc6xJb4fussJltj8xnnMewUgDaWihQnq3G9Ryi46on2DVyNtJvTjVGt8dJKA45wxGOiuQFTOdDfAQqX3o0oVxmn/z+S7hxQPMigVj5f8pkE2dyedibsZtYL//AmTI/7AnGUzkLjYkcie/701nEnpXRfSribJbRi//cb5JWCwotWQkG0hha9jDBB2OnEbTyj9FGJtrfMvLoq47mZVDl7f4e7A6DZMpjQCsrvnpg0cN3PY7A2xUGEw2dcKfDd1jYIwhKiU+EvZ+HlHS26SHQ2p5CvgEsKwjq8Lgw2aSfnJUweQ72+K1BHwDjxwwC711Aeu4+SvnshmcwT3UrYU4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc59a65-fd5c-4094-e35f-08d7feab2a4a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:20.1806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tjQX3nEk4I9qayOdjVfSao4gudXyiv85TJoLzyrJU9MKng5nxInUGU/2jfO0+ZFtLP0IEXPRwRfvfM8EoSRwug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

In order to improve code maintainability and readability, introduce new
CONFIG_MLX5_CLS_ACT kconfig variable to control compilation of TC hardware
offloads implementation. This allows distinguishing between features that
require TC support (MPLSoUDP, etc.) and features that just rely on
representor functionality (rep_bond for live migration, etc.).

Modify rep_tc.h, rep_neigh.h, en_tc.h and chains.h files to provide stubs
for functions that are called from generic code.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Kconfig   | 17 ++++++-
 .../net/ethernet/mellanox/mlx5/core/Makefile  | 11 ++---
 .../mellanox/mlx5/core/en/rep/neigh.h         | 11 +++++
 .../ethernet/mellanox/mlx5/core/en/rep/tc.h   | 44 +++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   | 16 +++++--
 .../ethernet/mellanox/mlx5/core/esw/chains.h  | 19 ++++++++
 .../mellanox/mlx5/core/eswitch_offloads.c     |  2 +
 8 files changed, 109 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 7d69a3061f17..4256d59eca2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -78,9 +78,24 @@ config MLX5_ESWITCH
 	        Legacy SRIOV mode (L2 mac vlan steering based).
 	        Switchdev mode (eswitch offloads).
 
+config MLX5_CLS_ACT
+	bool "MLX5 TC classifier action support"
+	depends on MLX5_ESWITCH && NET_CLS_ACT
+	default y
+	help
+	  mlx5 ConnectX offloads support for TC classifier action (NET_CLS_ACT),
+	  works in both native NIC mdoe and Switchdev SRIOV mode.
+	  Actions get attached to a Hardware offloaded classifiers and are
+	  invoked after a successful classification. Actions are used to
+	  overwrite the classification result, instantly drop or redirect and/or
+	  reformat packets in wire speeds without involving the host cpu.
+
+	  If set to N, TC offloads in both NIC and switchdev modes will be disabled.
+	  If unsure, set to Y
+
 config MLX5_TC_CT
 	bool "MLX5 TC connection tracking offload support"
-	depends on MLX5_CORE_EN && NET_SWITCHDEV && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
+	depends on MLX5_CLS_ACT && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
 	default y
 	help
 	  Say Y here if you want to support offloading connection tracking rules
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 3c9d78e6695c..3c1f12c7175f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -33,18 +33,19 @@ mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 mlx5_core-$(CONFIG_MLX5_EN_ARFS)     += en_arfs.o
 mlx5_core-$(CONFIG_MLX5_EN_RXNFC)    += en_fs_ethtool.o
 mlx5_core-$(CONFIG_MLX5_CORE_EN_DCB) += en_dcbnl.o en/port_buffer.o
-mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o en_tc.o en/rep/tc.o en/rep/neigh.o en/tc_tun.o lib/port_tun.o \
-					lag_mp.o \
-					lib/geneve.o en/mapping.o en/tc_tun_vxlan.o en/tc_tun_gre.o \
-					en/tc_tun_geneve.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_PCI_HYPERV_INTERFACE) += en/hv_vhca_stats.o
+mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o lib/geneve.o lib/port_tun.o lag_mp.o
+mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
+					en/mapping.o esw/chains.o en/tc_tun.o \
+					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
+					diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 
 #
 # Core extra
 #
 mlx5_core-$(CONFIG_MLX5_ESWITCH)   += eswitch.o eswitch_offloads.o eswitch_offloads_termtbl.o \
-				      ecpf.o rdma.o esw/chains.o
+				      ecpf.o rdma.o
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
 mlx5_core-$(CONFIG_VXLAN)          += lib/vxlan.o
 mlx5_core-$(CONFIG_PTP_1588_CLOCK) += lib/clock.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
index 8eddb3ac0d74..32b239189c95 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
@@ -7,6 +7,8 @@
 #include "en.h"
 #include "en_rep.h"
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
 int mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv);
 void mlx5e_rep_neigh_cleanup(struct mlx5e_rep_priv *rpriv);
 
@@ -20,4 +22,13 @@ void mlx5e_rep_neigh_entry_release(struct mlx5e_neigh_hash_entry *nhe);
 
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
+#else /* CONFIG_MLX5_CLS_ACT */
+
+static inline int
+mlx5e_rep_neigh_init(struct mlx5e_rep_priv *rpriv) { return 0; }
+static inline void
+mlx5e_rep_neigh_cleanup(struct mlx5e_rep_priv *rpriv) {}
+
+#endif /* CONFIG_MLX5_CLS_ACT */
+
 #endif /* __MLX5_EN_REP_NEIGH__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
index 90da00626b97..86f92abf2fdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
@@ -5,11 +5,11 @@
 #define __MLX5_EN_REP_TC_H__
 
 #include <linux/skbuff.h>
-#include "en.h"
 #include "en_tc.h"
 #include "en_rep.h"
 
-struct mlx5e_rep_priv;
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
 int mlx5e_rep_tc_init(struct mlx5e_rep_priv *rpriv);
 void mlx5e_rep_tc_cleanup(struct mlx5e_rep_priv *rpriv);
 
@@ -21,7 +21,6 @@ void mlx5e_rep_tc_disable(struct mlx5e_priv *priv);
 
 int mlx5e_rep_tc_event_port_affinity(struct mlx5e_priv *priv);
 
-struct mlx5e_encap_entry;
 void mlx5e_rep_update_flows(struct mlx5e_priv *priv,
 			    struct mlx5e_encap_entry *e,
 			    bool neigh_connected,
@@ -36,10 +35,47 @@ int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		       void *type_data);
 void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv);
 
-struct mlx5e_tc_update_priv;
 bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct sk_buff *skb,
 			     struct mlx5e_tc_update_priv *tc_priv);
 void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv);
 
+#else /* CONFIG_MLX5_CLS_ACT */
+
+struct mlx5e_rep_priv;
+static inline int
+mlx5e_rep_tc_init(struct mlx5e_rep_priv *rpriv) { return 0; }
+static inline void
+mlx5e_rep_tc_cleanup(struct mlx5e_rep_priv *rpriv) {}
+
+static inline int
+mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv) { return 0; }
+static inline void
+mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv) {}
+
+static inline void
+mlx5e_rep_tc_enable(struct mlx5e_priv *priv) {}
+static inline void
+mlx5e_rep_tc_disable(struct mlx5e_priv *priv) {}
+
+static inline int
+mlx5e_rep_tc_event_port_affinity(struct mlx5e_priv *priv) { return NOTIFY_DONE; }
+
+static inline int
+mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
+		   void *type_data) { return -EOPNOTSUPP; }
+
+static inline void
+mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv) {}
+
+struct mlx5e_tc_update_priv;
+static inline bool
+mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
+			struct sk_buff *skb,
+			struct mlx5e_tc_update_priv *tc_priv) { return true; }
+static inline void
+mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv) {}
+
+#endif /* CONFIG_MLX5_CLS_ACT */
+
 #endif /* __MLX5_EN_REP_TC_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3829dfd39800..803f1066ac08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3728,7 +3728,7 @@ static int set_feature_cvlan_filter(struct net_device *netdev, bool enable)
 	return 0;
 }
 
-#ifdef CONFIG_MLX5_ESWITCH
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 static int set_feature_tc_num_filters(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -3839,7 +3839,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER,
 				    set_feature_cvlan_filter);
-#ifdef CONFIG_MLX5_ESWITCH
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_tc_num_filters);
 #endif
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_RXALL, set_feature_rx_all);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 9c59b7fe258a..037aa73bf9ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -80,9 +80,6 @@ enum {
 
 #define MLX5_TC_FLAG(flag) BIT(MLX5E_TC_FLAG_##flag##_BIT)
 
-int mlx5e_tc_nic_init(struct mlx5e_priv *priv);
-void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
-
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht);
 void mlx5e_tc_esw_cleanup(struct rhashtable *tc_ht);
 
@@ -173,9 +170,22 @@ void dealloc_mod_hdr_actions(struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 struct mlx5e_tc_flow;
 u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow);
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
+int mlx5e_tc_nic_init(struct mlx5e_priv *priv);
+void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv);
+
 int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 			    void *cb_priv);
 
+#else /* CONFIG_MLX5_CLS_ACT */
+static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
+static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
+static inline int
+mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{ return -EOPNOTSUPP; }
+#endif /* CONFIG_MLX5_CLS_ACT */
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
index f8c4239846ea..7679ac359e31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
@@ -6,6 +6,8 @@
 
 #include "eswitch.h"
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
+
 bool
 mlx5_esw_chains_prios_supported(struct mlx5_eswitch *esw);
 bool
@@ -46,4 +48,21 @@ void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw);
 int
 mlx5_eswitch_get_chain_for_tag(struct mlx5_eswitch *esw, u32 tag, u32 *chain);
 
+#else /* CONFIG_MLX5_CLS_ACT */
+
+static inline struct mlx5_flow_table *
+mlx5_esw_chains_get_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
+			  u32 level) { return ERR_PTR(-EOPNOTSUPP); }
+static inline void
+mlx5_esw_chains_put_table(struct mlx5_eswitch *esw, u32 chain, u32 prio,
+			  u32 level) {}
+
+static inline struct mlx5_flow_table *
+mlx5_esw_chains_get_tc_end_ft(struct mlx5_eswitch *esw) { return ERR_PTR(-EOPNOTSUPP); }
+
+static inline int mlx5_esw_chains_create(struct mlx5_eswitch *esw) { return 0; }
+static inline void mlx5_esw_chains_destroy(struct mlx5_eswitch *esw) {}
+
+#endif /* CONFIG_MLX5_CLS_ACT */
+
 #endif /* __ML5_ESW_CHAINS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 57ac2ef52e80..1c9be19ee025 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1727,7 +1727,9 @@ static int mlx5_esw_offloads_pair(struct mlx5_eswitch *esw,
 
 static void mlx5_esw_offloads_unpair(struct mlx5_eswitch *esw)
 {
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	mlx5e_tc_clean_fdb_peer_flows(esw);
+#endif
 	esw_del_fdb_peer_miss_rules(esw);
 }
 
-- 
2.25.4

