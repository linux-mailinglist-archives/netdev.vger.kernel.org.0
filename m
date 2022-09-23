Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FDD5E84E0
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiIWVaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbiIWV37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:29:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A17476FE
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:29:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwqErGS0Z8IvAgwdrlDuR7pCb8N4OUiQWPcxrhLw6WD8IlC878yjk+PKFWVeql2g7n0NsAw8qs0iVox5eb9ViS0jozJAmL59IqDgHRoOvkVV4MmG6Y7uCxtj+AVPNXh1IH+X2NLb08HZiH0jxRhFQI60iiDfGpRg/PjUPt+iIAbIfolq9vwI/7/V3mI8ZVzLd95/KlxxI3PSHwtsbuVbZ+SwzSaCZcSNFUsGF4DmBSt/glhhEpUaBurtn4TfYklwsrW9LDZ2nFWq8GLFGeV/iXGSGhTMloSdUQtIgRjXEE6kNGb7Tobhy8JrxQ/4HpDF74QCk3N4pskWQZ2faz2Vbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ew7wcuTV6den/C/5cJpCwSIL1GdjTmmqy4Kt7RgHoJw=;
 b=FiReKFGSWVJQW4Ka50pY8svB9vEzJ7yvNBxN4qucsL/H6spinlxgS6i7yAPP3D1xRZIW45XEcveqH6SVluYCT0ZuQO4EQAbbifLc6XT7qXFrVbGZeZQomqUi9iJMQ/u7D0nL45jq3ZQIS68dfreJ3WHZ7XY3ojd5ie25MBXW6ruJ3Iu5qMgbK+uFCNeLbs6/CYou7a69MigqdkyHdJClDOAWMHyERlYUth9C/sLczrmrFhU8O7wQ+sTeBQ4Jegd9knXqARmaFRWiHQTjsPQwHFNLH0LROAAq7pa3Gu1ks6/k3gs+Cz6dCUOkzhQdwMbLnuv+IyLsDlb6YguTTslVvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ew7wcuTV6den/C/5cJpCwSIL1GdjTmmqy4Kt7RgHoJw=;
 b=mTOpV0cdCxZVTRjSutpSI2nqRVfMrKCpe92Sn8oY9w4UibRx62ZOE2TIdij8dCe1otygXN6kESSJJVPl/76i52WJObewdwM+fbF8yNVzlur4l4Z9ZxUMPqAk1q49RSBS1Eb9Fa8W8a5F2Atdtqcjh/YGgjhX7GKyzXmfDNjCtYFYNNHF7sxw+shL6QH0vGdSg1j+KEiViNiGYpT+QkehBntWyHoigmXjroOHTksKqGGoyTvXpChRxrv87sKsNe1PMUC+jwijd2AFpk90nk5cW9rHBNp+oP92upOYMSY7pbkVFOs9REZYGfeW/Ph4uEZ+vWJzXgsMdUYZZ/PjUsEmAA==
Received: from BN9PR03CA0979.namprd03.prod.outlook.com (2603:10b6:408:109::24)
 by BN9PR12MB5307.namprd12.prod.outlook.com (2603:10b6:408:104::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 21:29:53 +0000
Received: from BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::64) by BN9PR03CA0979.outlook.office365.com
 (2603:10b6:408:109::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 21:29:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT071.mail.protection.outlook.com (10.13.177.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 21:29:53 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:51 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 14:29:51 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 23 Sep 2022 16:29:49 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 1/6] sfc: bind blocks for TC offload on EF100
Date:   Fri, 23 Sep 2022 22:05:33 +0100
Message-ID: <ce1d91bbb7828028139d2dc2270d80c011008e2e.1663962652.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1663962652.git.ecree.xilinx@gmail.com>
References: <cover.1663962652.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT071:EE_|BN9PR12MB5307:EE_
X-MS-Office365-Filtering-Correlation-Id: a1d239ab-af6e-44c5-be5e-08da9daac0e5
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZXmgD+ENq+xC8CrRm4sb5LHukKtsE+i6KumM0Eg7t96T4L6fnreOnDR69ukviKO3xl+tOXPWXIioieC+i1mGMeXNb2aMU7IjTot8M0jIJx2LA8PkE9LJr+oER7IHkQwGXw/eaHFBzojAgaQKMvRHvDyzxJP3ncntcMg1a08dAg1ZV8BhgWmYCvj3wMIGmbF63w/SeqJ2Wx3axca/h8lVUZE2wHPVc6+RQZkpsc59mvZcvB6AwOD74huK5cF/YUScL60nfoeWd0QLxRdUXfk0xC3YYqfJFv8c+soo5aqkX9Gj8S2K9oDnl5paS7zOoLuCWAj6/8vzqIL+65u/pZAA5FvdHtpLfUJ4dbHrhzvn7ARJs3msDxjaFqN+ARikant+JntgzXhb8aiXM1ra1xqKf7XOibm9LVavkuN/zcPnBUf/F5Ki+xvurp8G7zoV8bCCwUiDRKEwvKsrA6yvg/7XgXlj+VJ2xzWHTSVuiUsrXUJtMvD/RJ1r9jdb4y1+DACOPhTDwAOg93+Vl4aECXBMt07V9YwzmZhZuYC9TrhMVxHFVazYywyVJusSyagfNZ1OIAdesh16lmGw/dXIL2TTc2lrbSeNreNNwTGDXhBySC9hEttEtftgPOJDZfGkkhCwAik+cwhagZI7DchTuZ+xXa/8/0N3NsQRoYtiOls/DXjIcfUxdqWSqTpvwen4v00NTgCnXfm9tMgEY6tsHuYtDlDAJoK1Z7ZZtqPjCsxQAJBkEh9V6ARc723M6Ew3PLdWjARYz/VDEDVehVDena+4QGDqOw2WCF/ihL0xYfNroc33PTfFrO3xyXzKXQpFCCbV
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199015)(40470700004)(46966006)(36840700001)(316002)(55446002)(30864003)(36756003)(81166007)(2906002)(2876002)(5660300002)(82740400003)(4326008)(356005)(70206006)(83170400001)(40460700003)(70586007)(8936002)(47076005)(8676002)(36860700001)(54906003)(110136005)(41300700001)(478600001)(336012)(42882007)(9686003)(83380400001)(186003)(82310400005)(6666004)(26005)(40480700001)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:29:53.2004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d239ab-af6e-44c5-be5e-08da9daac0e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5307
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

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
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
index 000000000000..277ce8558aa0
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
+void efx_tc_block_unbind(void *cb_priv)
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
