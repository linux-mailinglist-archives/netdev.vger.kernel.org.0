Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2934C5EB0A1
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiIZS7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiIZS7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:59:07 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592798F96B
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlTyOjZXHsbg5yoQunwO1J7lhLUGW7vpWLaH1FHRjrCJLdC+vxyWFtsQBPil2wm7QN8jZpJDBXUsMlbosfTS9j00jyTjSzentvBTqcWN6dIyKWqkQjwXNUAmPRK7y965NIeM5HyFsTWyYtgdnN1yXw7m1zUh9Se2wb5aPZWayovYICyvzuPgxE/L00TrV65l2ZX5BeUbiGD8mcBaPTsmeDMH7GvL785/XY3cbz8usDJNUz3Td09JgGBwu0Tl7o6Cgvflyq8LkPR+6JaOqQnFRZXdyV6ZiDpQKNn/3JFyIfNTFCQyJypkm61JB+i1TF5tRp9sLTDYQLO4M4nj5W/SFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2iJJCNkkjpHUrPYHAvHAxugmUcyuqFeqfic5V/4EslU=;
 b=AMUAj7udtFNxllRzStoEpk60QeBNVZJ85zlv9MsJzvyn84giKnT2WutcmRZCW9bknfO5cmK3W9pjAttraOeo/6jTpp5ubObn8LhXfM0SVpSRZ7PndzmDSC25Q+SXStw7lRJA/nsZcu046X1SoWJHznZY4nDN66Rw/sev+j/xI/88g6ErCLNWvdJkOVq8AgRxz4ruCYMmkuqRH4rYsV9M9z89/iVJBjFwyfdEbd+ZDQUiIDlo5wZor4Sm8r4f7V3qZdmSwCnsnbOwJbJoasXRBo53fvxazsWaT0dCSOIwz8MZ18g4bza0LmRWFZkOELH9+seMZrnfZBfXks2QF2tRGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iJJCNkkjpHUrPYHAvHAxugmUcyuqFeqfic5V/4EslU=;
 b=KCrviE2Xm805V4N1N82So/6xi/u4Cj2frWzpvVDCOXhwQeyQpcZ5qIWHucbxwvw7azbrSJhXXuwyJQFRFiHhXwo9YmCRn49f7WlLLTYAYhv1lovmLMTH+WrDEiIyxO3jrvfmT7k5Ng7ywgvENPTYQoldZKiXK7/+bh+YNKUUhybuFsOnEND9QEQQqtfl6OCeZmUD7P6uLlF/1ss6fhFIDeHPn+ao3brMpt4HYElWVNunSqKMz4kKzz2p64xsy3VPa3x6hlu0iuEhFmda37MHKx/g8LVaRUesxBsM6Xwpg1OvBmbKEwWGYjkNGYGqvOxY6fZSGCOHnBNNfKR7ums20Q==
Received: from MW4PR03CA0016.namprd03.prod.outlook.com (2603:10b6:303:8f::21)
 by MW4PR12MB6828.namprd12.prod.outlook.com (2603:10b6:303:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 18:59:02 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::a3) by MW4PR03CA0016.outlook.office365.com
 (2603:10b6:303:8f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Mon, 26 Sep 2022 18:59:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 18:59:02 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 13:59:01 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 26 Sep 2022 13:59:00 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 1/6] sfc: bind blocks for TC offload on EF100
Date:   Mon, 26 Sep 2022 19:57:31 +0100
Message-ID: <097c1e9d6122630f909fb0c25868b6ce253a89c2.1664218348.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1664218348.git.ecree.xilinx@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|MW4PR12MB6828:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f9d76a0-a995-4d5d-b0ee-08da9ff12d7f
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m7WsJsG1JZwMXetIVw50jEgRNyTakOrAL4KsTvs5DrgMD/jGgB3U/PC/E2YSRKr6Vzbx4gZuexEMLGYW4JgNLiE+il1Yf7fPt1013WgWNvgzh7UDvI+VAgkfeM40+fPIg232H4v7WFBzjlQbhHSZzw7aCnfMCsBiB9E/mbY8t3hOrxTrTJDFTb+YlbG0dtaFu5bZP0/wW7yWx72IzK86RrNCXrI0OXSpaE7oQzaOT3005a9QyfamP6jkqcgRlV/5G5sBWUK8cCq4QyTLhCO5PkUZ251/UeboS7M7TJTuiiSLRiCkeIgmnrRbC8E9R0IR8lZVq12G9+zssYCTEVmFWuh8g9ar0gjL4t4Zx3QadzcLdg+gLN26N6ZW+cMSPLx+YBZMZJm/J9xxmISwvlZoxfosUVxm4aXLabrzDpu2xxs3w025Aa4USypEtapq+9cTIoqGNTfiiUxKLHEbWXaaXdPvymvXYTIlPo+ve6MfeEYtqsDoMSo3PEPU8BTIoTt72miHm3tOPv/HFgmcg0rnEUt8/nf8BDZC3lZvoZXxI5LmE4Grv79mU4a8IrxWP1q90SYfmpWC2sa3LdPgZUyXvcMmNulCbpLJj7b2Ofxz+5HPbVa2odmi4AN8xP7LC8v3HQi5+YTR6nhYpWwiRJOsdLWhxTIW4sgrOUyMzvo/Ep+mc8EWQRPn1n/5kGWzf1OPiB3DXainK3n4xSyZspgJL5QqScVdxFwg3FIgSuksYJQMMhWYq4t9UFK+ifZ/2gbtJeZGaBBAR9PbrMr9t9kyu7e9ulXruvU5Wm5OzEImuekwnQZur/FEnBiSLpO2hYtE
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(41300700001)(6666004)(30864003)(82310400005)(40460700003)(5660300002)(8936002)(26005)(336012)(36756003)(9686003)(83380400001)(36860700001)(47076005)(42882007)(2876002)(2906002)(356005)(81166007)(186003)(83170400001)(82740400003)(478600001)(110136005)(54906003)(316002)(8676002)(70586007)(40480700001)(70206006)(4326008)(55446002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 18:59:02.3749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f9d76a0-a995-4d5d-b0ee-08da9ff12d7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6828
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Bind direct blocks for the MAE-admin PF and each VF representor.
Currently these connect to a stub efx_tc_flower() that only returns
 -EOPNOTSUPP; subsequent patches will implement flower offloads to the
 Match-Action Engine.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Makefile       |   2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c |   4 +
 drivers/net/ethernet/sfc/ef100_nic.c    |   3 +
 drivers/net/ethernet/sfc/ef100_rep.c    |  16 +++
 drivers/net/ethernet/sfc/tc.c           |  14 ++-
 drivers/net/ethernet/sfc/tc.h           |   7 ++
 drivers/net/ethernet/sfc/tc_bindings.c  | 157 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_bindings.h  |  23 ++++
 8 files changed, 224 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/tc_bindings.c
 create mode 100644 drivers/net/ethernet/sfc/tc_bindings.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index bb06fa228367..b5e45fc6337e 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -9,7 +9,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
-                           mae.o tc.o
+                           mae.o tc.o tc_bindings.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 17b9d37218cb..88fa29572e23 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -23,6 +23,7 @@
 #include "mcdi_filters.h"
 #include "rx_common.h"
 #include "ef100_sriov.h"
+#include "tc_bindings.h"
 
 static void ef100_update_name(struct efx_nic *efx)
 {
@@ -246,6 +247,9 @@ static const struct net_device_ops ef100_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer      = efx_filter_rfs,
 #endif
+#ifdef CONFIG_SFC_SRIOV
+	.ndo_setup_tc		= efx_tc_setup,
+#endif
 };
 
 /*	Netdev registration
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 8061efdaf82c..ad686c671ab8 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1137,6 +1137,9 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 		 */
 		netif_warn(efx, probe, net_dev, "Failed to probe MAE rc %d\n",
 			   rc);
+	} else {
+		net_dev->features |= NETIF_F_HW_TC;
+		efx->fixed_features |= NETIF_F_HW_TC;
 	}
 #endif
 	return 0;
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 73ae4656a6e7..0a631e0c9914 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -14,6 +14,7 @@
 #include "ef100_nic.h"
 #include "mae.h"
 #include "rx_common.h"
+#include "tc_bindings.h"
 
 #define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
 
@@ -107,6 +108,20 @@ static int efx_ef100_rep_get_phys_port_name(struct net_device *dev,
 	return 0;
 }
 
+static int efx_ef100_rep_setup_tc(struct net_device *net_dev,
+				  enum tc_setup_type type, void *type_data)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+	struct efx_nic *efx = efv->parent;
+
+	if (type == TC_SETUP_CLSFLOWER)
+		return efx_tc_flower(efx, net_dev, type_data, efv);
+	if (type == TC_SETUP_BLOCK)
+		return efx_tc_setup_block(net_dev, efx, type_data, efv);
+
+	return -EOPNOTSUPP;
+}
+
 static void efx_ef100_rep_get_stats64(struct net_device *dev,
 				      struct rtnl_link_stats64 *stats)
 {
@@ -127,6 +142,7 @@ static const struct net_device_ops efx_ef100_rep_netdev_ops = {
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
 	.ndo_get_stats64	= efx_ef100_rep_get_stats64,
+	.ndo_setup_tc		= efx_ef100_rep_setup_tc,
 };
 
 static void efx_ef100_rep_get_drvinfo(struct net_device *dev,
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 0c0aeb91f500..23c4325e739a 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -58,6 +58,12 @@ static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rul
 	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 }
 
+int efx_tc_flower(struct efx_nic *efx, struct net_device *net_dev,
+		  struct flow_cls_offload *tc, struct efx_rep *efv)
+{
+	return -EOPNOTSUPP;
+}
+
 static int efx_tc_configure_default_rule(struct efx_nic *efx, u32 ing_port,
 					 u32 eg_port, struct efx_tc_flow_rule *rule)
 {
@@ -207,7 +213,11 @@ int efx_init_tc(struct efx_nic *efx)
 	rc = efx_tc_configure_default_rule_wire(efx);
 	if (rc)
 		return rc;
-	return efx_tc_configure_rep_mport(efx);
+	rc = efx_tc_configure_rep_mport(efx);
+	if (rc)
+		return rc;
+	efx->tc->up = true;
+	return 0;
 }
 
 void efx_fini_tc(struct efx_nic *efx)
@@ -218,6 +228,7 @@ void efx_fini_tc(struct efx_nic *efx)
 	efx_tc_deconfigure_rep_mport(efx);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.pf);
 	efx_tc_deconfigure_default_rule(efx, &efx->tc->dflt.wire);
+	efx->tc->up = false;
 }
 
 int efx_init_struct_tc(struct efx_nic *efx)
@@ -228,6 +239,7 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->tc = kzalloc(sizeof(*efx->tc), GFP_KERNEL);
 	if (!efx->tc)
 		return -ENOMEM;
+	INIT_LIST_HEAD(&efx->tc->block_list);
 
 	efx->tc->reps_filter_uc = -1;
 	efx->tc->reps_filter_mc = -1;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 309123c6b386..7b1a6fa0097d 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -11,6 +11,7 @@
 
 #ifndef EFX_TC_H
 #define EFX_TC_H
+#include <net/flow_offload.h>
 #include "net_driver.h"
 
 struct efx_tc_action_set {
@@ -49,6 +50,7 @@ enum efx_tc_rule_prios {
 /**
  * struct efx_tc_state - control plane data for TC offload
  *
+ * @block_list: List of &struct efx_tc_block_binding
  * @reps_mport_id: MAE port allocated for representor RX
  * @reps_filter_uc: VNIC filter for representor unicast RX (promisc)
  * @reps_filter_mc: VNIC filter for representor multicast RX (allmulti)
@@ -57,14 +59,17 @@ enum efx_tc_rule_prios {
  *	%EFX_TC_PRIO_DFLT.  Named by *ingress* port
  * @dflt.pf: rule for traffic ingressing from PF (egresses to wire)
  * @dflt.wire: rule for traffic ingressing from wire (egresses to PF)
+ * @up: have TC datastructures been set up?
  */
 struct efx_tc_state {
+	struct list_head block_list;
 	u32 reps_mport_id, reps_mport_vport_id;
 	s32 reps_filter_uc, reps_filter_mc;
 	struct {
 		struct efx_tc_flow_rule pf;
 		struct efx_tc_flow_rule wire;
 	} dflt;
+	bool up;
 };
 
 struct efx_rep;
@@ -72,6 +77,8 @@ struct efx_rep;
 int efx_tc_configure_default_rule_rep(struct efx_rep *efv);
 void efx_tc_deconfigure_default_rule(struct efx_nic *efx,
 				     struct efx_tc_flow_rule *rule);
+int efx_tc_flower(struct efx_nic *efx, struct net_device *net_dev,
+		  struct flow_cls_offload *tc, struct efx_rep *efv);
 
 int efx_tc_insert_rep_filters(struct efx_nic *efx);
 void efx_tc_remove_rep_filters(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/tc_bindings.c b/drivers/net/ethernet/sfc/tc_bindings.c
new file mode 100644
index 000000000000..d9401ee7b8e1
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc_bindings.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "tc_bindings.h"
+#include "tc.h"
+
+struct efx_tc_block_binding {
+	struct list_head list;
+	struct efx_nic *efx;
+	struct efx_rep *efv;
+	struct net_device *otherdev; /* may actually be us */
+	struct flow_block *block;
+};
+
+static struct efx_tc_block_binding *efx_tc_find_binding(struct efx_nic *efx,
+							struct net_device *otherdev)
+{
+	struct efx_tc_block_binding *binding;
+
+	ASSERT_RTNL();
+	list_for_each_entry(binding, &efx->tc->block_list, list)
+		if (binding->otherdev == otherdev)
+			return binding;
+	return NULL;
+}
+
+static int efx_tc_block_cb(enum tc_setup_type type, void *type_data,
+			   void *cb_priv)
+{
+	struct efx_tc_block_binding *binding = cb_priv;
+	struct flow_cls_offload *tcf = type_data;
+
+	switch (type) {
+	case TC_SETUP_CLSFLOWER:
+		return efx_tc_flower(binding->efx, binding->otherdev,
+				     tcf, binding->efv);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void efx_tc_block_unbind(void *cb_priv)
+{
+	struct efx_tc_block_binding *binding = cb_priv;
+
+	list_del(&binding->list);
+	kfree(binding);
+}
+
+static struct efx_tc_block_binding *efx_tc_create_binding(
+			struct efx_nic *efx, struct efx_rep *efv,
+			struct net_device *otherdev, struct flow_block *block)
+{
+	struct efx_tc_block_binding *binding = kmalloc(sizeof(*binding), GFP_KERNEL);
+
+	if (!binding)
+		return ERR_PTR(-ENOMEM);
+	binding->efx = efx;
+	binding->efv = efv;
+	binding->otherdev = otherdev;
+	binding->block = block;
+	list_add(&binding->list, &efx->tc->block_list);
+	return binding;
+}
+
+int efx_tc_setup_block(struct net_device *net_dev, struct efx_nic *efx,
+		       struct flow_block_offload *tcb, struct efx_rep *efv)
+{
+	struct efx_tc_block_binding *binding;
+	struct flow_block_cb *block_cb;
+	int rc;
+
+	if (tcb->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(!efx->tc))
+		return -ENETDOWN;
+
+	switch (tcb->command) {
+	case FLOW_BLOCK_BIND:
+		binding = efx_tc_create_binding(efx, efv, net_dev, tcb->block);
+		if (IS_ERR(binding))
+			return PTR_ERR(binding);
+		block_cb = flow_block_cb_alloc(efx_tc_block_cb, binding,
+					       binding, efx_tc_block_unbind);
+		rc = PTR_ERR_OR_ZERO(block_cb);
+		netif_dbg(efx, drv, efx->net_dev,
+			  "bind %sdirect block for device %s, rc %d\n",
+			  net_dev == efx->net_dev ? "" :
+			  efv ? "semi" : "in",
+			  net_dev ? net_dev->name : NULL, rc);
+		if (rc) {
+			list_del(&binding->list);
+			kfree(binding);
+		} else {
+			flow_block_cb_add(block_cb, tcb);
+		}
+		return rc;
+	case FLOW_BLOCK_UNBIND:
+		binding = efx_tc_find_binding(efx, net_dev);
+		if (binding) {
+			block_cb = flow_block_cb_lookup(tcb->block,
+							efx_tc_block_cb,
+							binding);
+			if (block_cb) {
+				flow_block_cb_remove(block_cb, tcb);
+				netif_dbg(efx, drv, efx->net_dev,
+					  "unbound %sdirect block for device %s\n",
+					  net_dev == efx->net_dev ? "" :
+					  binding->efv ? "semi" : "in",
+					  net_dev ? net_dev->name : NULL);
+				return 0;
+			}
+		}
+		/* If we're in driver teardown, then we expect to have
+		 * already unbound all our blocks (we did it early while
+		 * we still had MCDI to remove the filters), so getting
+		 * unbind callbacks now isn't a problem.
+		 */
+		netif_cond_dbg(efx, drv, efx->net_dev,
+			       !efx->tc->up, warn,
+			       "%sdirect block unbind for device %s, was never bound\n",
+			       net_dev == efx->net_dev ? "" : "in",
+			       net_dev ? net_dev->name : NULL);
+		return -ENOENT;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/* .ndo_setup_tc implementation
+ * Entry point for flower block and filter management.
+ */
+int efx_tc_setup(struct net_device *net_dev, enum tc_setup_type type,
+		 void *type_data)
+{
+	struct efx_nic *efx = efx_netdev_priv(net_dev);
+
+	if (efx->type->is_vf)
+		return -EOPNOTSUPP;
+	if (!efx->tc)
+		return -EOPNOTSUPP;
+
+	if (type == TC_SETUP_CLSFLOWER)
+		return efx_tc_flower(efx, net_dev, type_data, NULL);
+	if (type == TC_SETUP_BLOCK)
+		return efx_tc_setup_block(net_dev, efx, type_data, NULL);
+
+	return -EOPNOTSUPP;
+}
diff --git a/drivers/net/ethernet/sfc/tc_bindings.h b/drivers/net/ethernet/sfc/tc_bindings.h
new file mode 100644
index 000000000000..bcd63c270585
--- /dev/null
+++ b/drivers/net/ethernet/sfc/tc_bindings.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef EFX_TC_BINDINGS_H
+#define EFX_TC_BINDINGS_H
+#include "net_driver.h"
+
+#include <net/sch_generic.h>
+
+struct efx_rep;
+
+int efx_tc_setup_block(struct net_device *net_dev, struct efx_nic *efx,
+		       struct flow_block_offload *tcb, struct efx_rep *efv);
+int efx_tc_setup(struct net_device *net_dev, enum tc_setup_type type,
+		 void *type_data);
+#endif /* EFX_TC_BINDINGS_H */
