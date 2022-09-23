Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1195E84E2
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiIWVaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbiIWVaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:30:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5266CF4A
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:29:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsswcSB/ZwNwnedeHbNXnNiBEZvwcss/JKV9nEBpiXtK7BjBA9PLCB/YxjoVzx2uYrVB+6jKBxZd51azmvhpDizQ8y5UK4XMvC0ilZT+lwN8gemoUwT7BMhEpE4UFEDtd3GktYfpTbu5IfinC3Zx1UyX/WxJSB8RZzQ0crpNmNo2tWou5dvQNpTY7TIBgKIu4IExUke+Qzm/ztHNOH7xUQYyrHBX8xLhuh8mahjVdDctSFXS1LS8Ypn71vzjdW1L2Q6yeOjTIYj3fdp4BmcySMeRjzabOWn+NYUVMWfv4R4iYJz5G04vDJmHFRjlG1haO3a0Ey1LPcmR4J5xdVuj9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8Hg90LR61pr4LwLxsbnlGf3IH/tS3z4I9w9KSgUIew=;
 b=VvAF4SFy8V3hZhjgARZK2b0GVDzRR8i74eVQgXHPBQ0IDobf3diRgj7djbnMaLOEoisxZ+swgwDixGM9whmDVc672mgviaig2L75l99gqhSRXYtRlWjVDYjd/Q0X0sir6mJCtmjiUiv5NMA3d7jvuHv5s8Hbj5xdKEHx+8VIdDk5TdGR49RV8GVVsMj8UeWaIfEeEtCofAVgc2+yhittSoLGdSzWJP+YmVDGIYBJTCztkYrk+P/RQTBaVraB9HlEOqoSuVnVwU5O+BfX91yUKoe6OjntfRL6fCsAYPqNmet4CNi9WJKI46t/Rhc4oKjrCanZ8zxFNWr+Xz6MFAHsdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8Hg90LR61pr4LwLxsbnlGf3IH/tS3z4I9w9KSgUIew=;
 b=K12hpgxoVR4Baae40NPDA4y2oFmINQaR9wWXOco3OTeHRSolDAO1N6/izO6/Qrb2Ukzd8glH1qevj2CgZa/lGFSe3Qz54VHmFhPn/ESSFzAZ2BNTn0bEeA6cfBmMoi9gVHJZJh6mwTXeB2AI8G0tuyO4NZ8JbNjGmxF/IX56wgwnkYu8JV/xhAQF83HjaAow2Nid0gjz+ULjWT8NjvNWbU/iAMxe1wkb3UNuvAJkXQN76/xCI8mftAlNfOYYTHX/97hb9yA6/YwUCNJHgPyyz3ioGrERHqynFgForvn7j4ID+ZdyXpJf6caT/61/u/3Vao+Q8BAtIYnaAZ4rDgDB2Q==
Received: from BN9PR03CA0059.namprd03.prod.outlook.com (2603:10b6:408:fb::34)
 by PH8PR12MB6697.namprd12.prod.outlook.com (2603:10b6:510:1cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Fri, 23 Sep
 2022 21:29:57 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::fe) by BN9PR03CA0059.outlook.office365.com
 (2603:10b6:408:fb::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 21:29:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 21:29:56 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:56 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 23 Sep 2022 16:29:54 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 4/6] sfc: add a hashtable for offloaded TC rules
Date:   Fri, 23 Sep 2022 22:05:36 +0100
Message-ID: <d01262d8c5162f3ee740554b10e8d062bdc05e51.1663962653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1663962652.git.ecree.xilinx@gmail.com>
References: <cover.1663962652.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT040:EE_|PH8PR12MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a70660c-0332-4269-11fb-08da9daac320
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQFhnw41IBkS+wQU6Rigr4wF7rKQsDLXfFAn2CpMJXgxdfuo7ZOMltNBeidbGsJ0CaNgQhXqLbOQpa2ttS6W88Oj/bLdsqR1nOzs1bmiA6cM37+MsLQHbgvgDpVbLMbKhA6jTl5DIZOyi+dGgHrjGpOzxqO6XoMoZ6IkwY4cD2JZk6gRy7yYl3SRhQmxk02gIkYKPRUW/hubw+nxtSxbJ7SCkX1M3DPCoSH5sOAPt0ladqhrsq7nM8oe1LgRwkCV1MGMJsf9eg0wUckt+uPhJ4MuCpMydLvmnWhQcq1j5Ew5eoV9KIEXUGf3TCCMfMcGT9mhhrleS5XiyQ/PgycVSO8TY/JbnPoASVy7IdomzJNoPQchO5A6/7j87oF/WkG89/EvNuD0D/CplzaWlqpTHlWkhDarxeF0KGC3fkpS227LL4cKBV0Mz55SU2yaXvm8UZPJ0ehXyAcsuJxVqwRkHiUe1gSDpXA9I2B5Js8V1L05qcV9HPuTpjRkdgdyQ5cg5epuQxpKzEt7v9PkeeCZiX2AgokcPcnspSS4VpIyqGUpTiLGz6QGD++ySpTjZ9NfXKsfiqdRY9cj7NTRGtf7SUqManDm2mo+x6g6qZvebtenKfxJjPftHOEQ9R2gYZ0wc5eIrNZaFeyZ60LfoFJdqZ51hcYx2r9OM9h6r2NHhwEG5p3924pHeLOqNYzNfDk3qvzBlU8LgKlHBPxgeWnGtQVA06ipkuh3nRGZnwGnb+72Y2vtkUW5N8HoX3+99pk169JlF5A4FgHE9jk89TnSA/kqoA6PJVgSTQg05pGqS6qCjlxdzYGnP4Ow2XLGPRBZ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(478600001)(110136005)(54906003)(8676002)(316002)(70586007)(4326008)(6666004)(356005)(26005)(36860700001)(70206006)(9686003)(82310400005)(336012)(83170400001)(5660300002)(41300700001)(36756003)(82740400003)(2876002)(47076005)(40480700001)(2906002)(81166007)(186003)(40460700003)(83380400001)(42882007)(8936002)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:29:56.9381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a70660c-0332-4269-11fb-08da9daac320
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6697
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

Nothing inserts into this table yet, but we have code to remove rules
 on FLOW_CLS_DESTROY or at driver teardown time, in both cases also
 attempting to remove the corresponding hardware rules.

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c |   2 +-
 drivers/net/ethernet/sfc/ef100_rep.h |   1 +
 drivers/net/ethernet/sfc/tc.c        | 115 ++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/tc.h        |   7 ++
 4 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index 0a631e0c9914..869f806a6b67 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -135,7 +135,7 @@ static void efx_ef100_rep_get_stats64(struct net_device *dev,
 	stats->tx_errors = atomic64_read(&efv->stats.tx_errors);
 }
 
-static const struct net_device_ops efx_ef100_rep_netdev_ops = {
+const struct net_device_ops efx_ef100_rep_netdev_ops = {
 	.ndo_open		= efx_ef100_rep_open,
 	.ndo_stop		= efx_ef100_rep_close,
 	.ndo_start_xmit		= efx_ef100_rep_xmit,
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 070f700893c1..c21bc716f847 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -66,4 +66,5 @@ void efx_ef100_rep_rx_packet(struct efx_rep *efv, struct efx_rx_buffer *rx_buf);
  * Caller must hold rcu_read_lock().
  */
 struct efx_rep *efx_ef100_find_rep_by_mport(struct efx_nic *efx, u16 mport);
+extern const struct net_device_ops efx_ef100_rep_netdev_ops;
 #endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index cb7f76c74e66..51e75feb7a42 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -15,6 +15,39 @@
 #include "ef100_rep.h"
 #include "efx.h"
 
+#define EFX_EFV_PF	NULL
+/* Look up the representor information (efv) for a device.
+ * May return NULL for the PF (us), or an error pointer for a device that
+ * isn't supported as a TC offload endpoint
+ */
+struct efx_rep *efx_tc_flower_lookup_efv(struct efx_nic *efx,
+					 struct net_device *dev)
+{
+	struct efx_rep *efv;
+
+	if (!dev)
+		return ERR_PTR(-EOPNOTSUPP);
+	/* Is it us (the PF)? */
+	if (dev == efx->net_dev)
+		return EFX_EFV_PF;
+	/* Is it an efx vfrep at all? */
+	if (dev->netdev_ops != &efx_ef100_rep_netdev_ops)
+		return ERR_PTR(-EOPNOTSUPP);
+	/* Is it ours?  We don't support TC rules that include another
+	 * EF100's netdevices (not even on another port of the same NIC).
+	 */
+	efv = netdev_priv(dev);
+	if (efv->parent != efx)
+		return ERR_PTR(-EOPNOTSUPP);
+	return efv;
+}
+
+static const struct rhashtable_params efx_tc_match_action_ht_params = {
+	.key_len	= sizeof(unsigned long),
+	.key_offset	= offsetof(struct efx_tc_flow_rule, cookie),
+	.head_offset	= offsetof(struct efx_tc_flow_rule, linkage),
+};
+
 static void efx_tc_free_action_set(struct efx_nic *efx,
 				   struct efx_tc_action_set *act, bool in_hw)
 {
@@ -59,10 +92,74 @@ static void efx_tc_delete_rule(struct efx_nic *efx, struct efx_tc_flow_rule *rul
 	rule->fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 }
 
+static void efx_tc_flow_free(void *ptr, void *arg)
+{
+	struct efx_tc_flow_rule *rule = ptr;
+	struct efx_nic *efx = arg;
+
+	netif_err(efx, drv, efx->net_dev,
+		  "tc rule %lx still present at teardown, removing\n",
+		  rule->cookie);
+
+	efx_mae_delete_rule(efx, rule->fw_id);
+
+	/* Release entries in subsidiary tables */
+	efx_tc_free_action_set_list(efx, &rule->acts, true);
+
+	kfree(rule);
+}
+
+static int efx_tc_flower_destroy(struct efx_nic *efx,
+				 struct net_device *net_dev,
+				 struct flow_cls_offload *tc)
+{
+	struct netlink_ext_ack *extack = tc->common.extack;
+	struct efx_tc_flow_rule *rule;
+
+	rule = rhashtable_lookup_fast(&efx->tc->match_action_ht, &tc->cookie,
+				      efx_tc_match_action_ht_params);
+	if (!rule) {
+		/* Only log a message if we're the ingress device.  Otherwise
+		 * it's a foreign filter and we might just not have been
+		 * interested (e.g. we might not have been the egress device
+		 * either).
+		 */
+		if (!IS_ERR(efx_tc_flower_lookup_efv(efx, net_dev)))
+			netif_warn(efx, drv, efx->net_dev,
+				   "Filter %lx not found to remove\n", tc->cookie);
+		NL_SET_ERR_MSG_MOD(extack, "Flow cookie not found in offloaded rules");
+		return -ENOENT;
+	}
+
+	/* Remove it from HW */
+	efx_tc_delete_rule(efx, rule);
+	/* Delete it from SW */
+	rhashtable_remove_fast(&efx->tc->match_action_ht, &rule->linkage,
+			       efx_tc_match_action_ht_params);
+	netif_dbg(efx, drv, efx->net_dev, "Removed filter %lx\n", rule->cookie);
+	kfree(rule);
+	return 0;
+}
+
 int efx_tc_flower(struct efx_nic *efx, struct net_device *net_dev,
 		  struct flow_cls_offload *tc, struct efx_rep *efv)
 {
-	return -EOPNOTSUPP;
+	int rc;
+
+	if (!efx->tc)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&efx->tc->mutex);
+	switch (tc->command) {
+	case FLOW_CLS_DESTROY:
+		rc = efx_tc_flower_destroy(efx, net_dev, tc);
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+		break;
+	}
+	mutex_unlock(&efx->tc->mutex);
+	return rc;
 }
 
 static int efx_tc_configure_default_rule(struct efx_nic *efx, u32 ing_port,
@@ -239,6 +336,8 @@ void efx_fini_tc(struct efx_nic *efx)
 
 int efx_init_struct_tc(struct efx_nic *efx)
 {
+	int rc;
+
 	if (efx->type->is_vf)
 		return 0;
 
@@ -247,6 +346,10 @@ int efx_init_struct_tc(struct efx_nic *efx)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&efx->tc->block_list);
 
+	mutex_init(&efx->tc->mutex);
+	rc = rhashtable_init(&efx->tc->match_action_ht, &efx_tc_match_action_ht_params);
+	if (rc < 0)
+		goto fail_match_action_ht;
 	efx->tc->reps_filter_uc = -1;
 	efx->tc->reps_filter_mc = -1;
 	INIT_LIST_HEAD(&efx->tc->dflt.pf.acts.list);
@@ -254,6 +357,11 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	INIT_LIST_HEAD(&efx->tc->dflt.wire.acts.list);
 	efx->tc->dflt.wire.fw_id = MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL;
 	return 0;
+fail_match_action_ht:
+	mutex_destroy(&efx->tc->mutex);
+	kfree(efx->tc);
+	efx->tc = NULL;
+	return rc;
 }
 
 void efx_fini_struct_tc(struct efx_nic *efx)
@@ -261,10 +369,15 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 	if (!efx->tc)
 		return;
 
+	mutex_lock(&efx->tc->mutex);
 	EFX_WARN_ON_PARANOID(efx->tc->dflt.pf.fw_id !=
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
 	EFX_WARN_ON_PARANOID(efx->tc->dflt.wire.fw_id !=
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
+	rhashtable_free_and_destroy(&efx->tc->match_action_ht, efx_tc_flow_free,
+				    efx);
+	mutex_unlock(&efx->tc->mutex);
+	mutex_destroy(&efx->tc->mutex);
 	kfree(efx->tc);
 	efx->tc = NULL;
 }
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 3e2299c5a885..94a04374e505 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -12,6 +12,7 @@
 #ifndef EFX_TC_H
 #define EFX_TC_H
 #include <net/flow_offload.h>
+#include <linux/rhashtable.h>
 #include "net_driver.h"
 
 /* Error reporting: convenience macros.  For indicating why a given filter
@@ -55,6 +56,8 @@ struct efx_tc_action_set_list {
 };
 
 struct efx_tc_flow_rule {
+	unsigned long cookie;
+	struct rhash_head linkage;
 	struct efx_tc_match match;
 	struct efx_tc_action_set_list acts;
 	u32 fw_id;
@@ -69,6 +72,8 @@ enum efx_tc_rule_prios {
  * struct efx_tc_state - control plane data for TC offload
  *
  * @block_list: List of &struct efx_tc_block_binding
+ * @mutex: Used to serialise operations on TC hashtables
+ * @match_action_ht: Hashtable of TC match-action rules
  * @reps_mport_id: MAE port allocated for representor RX
  * @reps_filter_uc: VNIC filter for representor unicast RX (promisc)
  * @reps_filter_mc: VNIC filter for representor multicast RX (allmulti)
@@ -81,6 +86,8 @@ enum efx_tc_rule_prios {
  */
 struct efx_tc_state {
 	struct list_head block_list;
+	struct mutex mutex;
+	struct rhashtable match_action_ht;
 	u32 reps_mport_id, reps_mport_vport_id;
 	s32 reps_filter_uc, reps_filter_mc;
 	struct {
