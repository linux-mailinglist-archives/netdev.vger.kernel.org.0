Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC285EB0A4
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiIZS70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiIZS7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:59:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C627890834
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:59:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR3PcUy53w2/nsO6pX/rfCtgz6HXFyT/UdwdaDpLabycboVaX+SfZUpJCLSkenI+tNi/xEl5vfjPJLFpk1Q5HJvuurGPP3JKco3JJjMrAmzyEDY5m/i1T1W3aSSWkuoeSC3mYDBdO5kd3RdHjBveai6yFW7fkx+xMnlXDM9ht20fFULEwAPRD+AXhb/PYaofCdeFb7dxCybeDPieQNj9uVzZZNpWFcECxdNCk1MtgllrCW24y/fHK3wz9WJDW7NR37DUjVZEGM1NhequAXSw2kiRYD2RLyuXuEiDlP+qO08jj6/SvSy/ew2cLHTercs1iCh0HXBxdD1pc2OteD+8sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yv/RigN1PhsiPl4uNhy4A9xXIFZsMFFvkdKFFVtjC4o=;
 b=jMSU4mSTOcklWbzgyGOYxv3+XPinVTJ6DgeQwAyDfbpo2js/o7Rt8Vn+XbtT1toTiufcPJzCFdSk+Ehi+6fcG8V0k8YXhO1w7TuELdaiEU3KPF57D9/xnhgfnqFoBfhnEME21t9fo4oNHRUm+AO5xds8snZ7gc6ENMWq+ciYyAQ1ABjU30XRkaOleuK3qrmmJGNLE9AxhwvMlLXWeFZt9K/jvJsuxjeI+ZUbd6EvVOxX8zSwr3Jd5Jbx4938W16ilEBkfVsCj2gO3jv3ko4bIpc/hILmib0bzlNmcPlawvTvQPbI2t51CSkxJvVlklmcL9UH2Z5FP3o7rTQZkmjAPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yv/RigN1PhsiPl4uNhy4A9xXIFZsMFFvkdKFFVtjC4o=;
 b=IpqBB3bacFdkXRfPd+wvb7tcEBNwPVttHdrCWQcUflgQaToa2S0amec3hidPpd274DD9qf63nJuDktoWwM+qWx2jytOjOPeMb0vgjpXFnxgZt5pihgjzMlxBL2y6t/RivuVYatddU9nibxqKYr/zhdtxiQrKU9CSgWCnDquEtLONYTbs778SQgog95snEsOwktxjH3+1vh/06hGe71Sgql0D+DsiqRIqtK6a6o2FDYkAI3yydRNjtJScjLAcn5p1TbRyZiPDFCUrW0iN9W1snqF9Xva2cI6cD0ARzi5Rk9hMLKnMv4VqsdQnfx+JDcyaDpRIOCJjydn6Cd0HcSXSZA==
Received: from MW4P222CA0019.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::24)
 by CH0PR12MB5297.namprd12.prod.outlook.com (2603:10b6:610:d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 18:59:08 +0000
Received: from CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::e3) by MW4P222CA0019.outlook.office365.com
 (2603:10b6:303:114::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19 via Frontend
 Transport; Mon, 26 Sep 2022 18:59:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT110.mail.protection.outlook.com (10.13.175.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 18:59:07 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 13:59:06 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 11:59:06 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 26 Sep 2022 13:59:04 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 4/6] sfc: add a hashtable for offloaded TC rules
Date:   Mon, 26 Sep 2022 19:57:34 +0100
Message-ID: <7f40c76ce6a2a3ba434782ad17977be20b6b11df.1664218348.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1664218348.git.ecree.xilinx@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT110:EE_|CH0PR12MB5297:EE_
X-MS-Office365-Filtering-Correlation-Id: bbcc55c7-6b24-48bc-f53c-08da9ff130cd
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjYucVJHyCrT+MdV4a0HmW7/zD/K+hQPnvpRPhqPD5fcnwYjjVN9Fttfr68rgUgmcwBbT6tIVEXZkPkMqBNiqWVuU7rMqCRjw5gKuMYk6hKsNyzasv5Vm7vgSB+0ZNzLk8E4VvgZ9PEBl+cPjURnaJccSnaA568FxfQ0AsCpjgpR0W6EhZs74OISWqtwEgvwUekxj1rHbFTXllxyjRw2phoxHKBdAlxPeXvbyb4X5IRdMBDQg36XhCLuxC6tlceJy16D4a0vyIN/NyLQB98poRQtb7QlGGn5Qfs25rOPxaaeJAgLoukfnRtYVY55N1iPzxtaQ44es8Cx6PkaJ8IxfW/Yc0vjz5s7AA4e6kSbMqQQmKyredCFPjQmehM4w459l5cNA3lc6ZOyLV3SO9XJBzgQmk4/uAxA6FUFtDzN1cNI5OXBfyFiT2hJV1yD5GgORz5V+/lBxtLEaeeswWqORaNPic+cxIqqeT3Jbs+XWCD3KjWHB0vZKt1FA+O3EQMEX2DS5ufNTVarT8pG+RCXwoJVUdPEyHXqK4ygeaFrfJzZ5SEeKeNbsh0Opjqgt8RvEjFja/P/MNA7Vd17nqnU5PWllhcLqire2l8473g+YDy5q6hrP4aEP715EPkB2etTZJwBw8yTorezYSvD2BAXv+RJaHVIkTIelO7Tydif48YSa8qzYO38mIfIAgUNnRJIO/A8bRKh+C0IwOGKGVaJ4K2XHd+Zek8z8SEQcEdBcDYOf7rpLY9Uc5/EOqC7lld68wJfwU+DSHW2Z/9zyVDfZObeEAGYeKvn3opxhoytBjsN4VbDSY6fuKvUsRTn0BUX
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(40480700001)(316002)(110136005)(54906003)(55446002)(478600001)(70586007)(70206006)(8676002)(4326008)(41300700001)(82740400003)(6666004)(9686003)(36860700001)(83380400001)(40460700003)(26005)(8936002)(5660300002)(83170400001)(81166007)(2876002)(2906002)(356005)(42882007)(82310400005)(336012)(47076005)(186003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 18:59:07.8429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbcc55c7-6b24-48bc-f53c-08da9ff130cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5297
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
index cb7f76c74e66..08e2af665380 100644
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
+static struct efx_rep *efx_tc_flower_lookup_efv(struct efx_nic *efx,
+						struct net_device *dev)
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
