Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB0D62810B
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbiKNNRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbiKNNQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:34 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDA92AC6C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSLzmPThr6m6rs9jTgF2V2uwdM+w8HPLWx7pPgSM7JE/IV9QhkoTrC4roIeTcd2tYboJ60TWOQVuQqX/Ql2IerREz2trax029gyQ5p+4SWKTkXcrgSl9cxCke9EmSa1Gg5TS5/MbYrjKnEBrEHguFgDM3T/wdnCGstxkdPwn77dDk5+lntL3QhPHJZ02a1eJ/bR0PT0FL0Md7SkoHBisfkVfenxOoKl4TlI+eQOaxu0wjBYN74M4+xjop/sa5n7IGdgcWBeiTmVSZCu3TPZ7lKhbZOwMHPbGy4EpRU2KqcOj/x++j3EgijLHDhHpu2/r3DdK3Nx584pIV8AqJMTQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0STpD9VlgS/r/P+BMFrBIUlOsjfeEyn8GaI1km/PGgo=;
 b=RODoF2+KEc8tRdCzn7KBC0oKbnIpO977nrlSDgD004OKOIzYc9K+lDmjaFX1zNyg38CQVFTkYoxPpGe1HAofo1NJ36s/5eiexU33wygBTvL+NYsz6bqJrmbi32fUe89m61pFW/wKh0rjko4rPR1pHsD2JsGPfvVo++YHL4lR2RK2GstqxsjqSVSRMr6DUVDLNmnv8rf2ZNw1+hPXrzSZvb8Ppppq84ohum4mn4mgA6T0BbpabrntgedM+3aHyFkzCauGN54xZZq2oI1iMr2Gp1TWmM3RSX1wpmDK0ev19K1hQRrNdyc7BgOH+Wa/2s8Da9VNV+APkHydNZdyazU33Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0STpD9VlgS/r/P+BMFrBIUlOsjfeEyn8GaI1km/PGgo=;
 b=pAZNYjQjPwKBugMi7tF3+raw0pAmiViiq73EfEh+WTmpXgeutoocEC+/fddpbKhekkHHR0QSfNZTdcoL9S1FQ4hTUEGewNEfcqOZT+JtRAwtIH2sO8keT2cl4SVWpqobQl1S/xvYPHeJTxw/JM7t1wgqGTTSYZYD2ulqObWHHTU=
Received: from MW4PR03CA0176.namprd03.prod.outlook.com (2603:10b6:303:8d::31)
 by MN2PR12MB4190.namprd12.prod.outlook.com (2603:10b6:208:1dd::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:26 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::3a) by MW4PR03CA0176.outlook.office365.com
 (2603:10b6:303:8d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:25 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:25 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:24 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:23 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 07/12] sfc: add hashtables for MAE counters and counter ID mappings
Date:   Mon, 14 Nov 2022 13:15:56 +0000
Message-ID: <65a4eb3d889a0475e9ca85d8aa32175d13cd2f53.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT066:EE_|MN2PR12MB4190:EE_
X-MS-Office365-Filtering-Correlation-Id: 62735f48-9e35-4a97-40d5-08dac6426f0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6CL+YBjSnG3f793pSb7/ovziXeoOOJz3UxdvgtgExt8/i4T4E7Jjz+FS9BZvtwGfs8bXtqjSzIviciD4revIHViQ2NynXI0nwLyHccERnoIsqD+E5IJbNuUCzq+Skz3PFow0WeCFq1EkcZAC7T/jtWUbH13j1O4gs3XXyWmJc8EQliDsp2v/De8XNSpBt7q0cdxj94rAGjrpx2gxvZwM+DcVjPtJ26n5kA6/dGhe5RIpjYEuzE2QwpK0l+nRc8SDdcQxvJEaJmcFwebwTRazYlF1h/9gdCUeoPd/6oaLOED7CniZJUTz3ATnY55A6d5n9KbwmwROpl/sOYzzO2ftYxquZA1TFV0Cmn3vgZ2Wv9G7EvN9VjDWtkY2W8DFSf7GwcIZx49zAo92QsUTTu4J6UoaBNplZE41WqRLJwIZM4xEj5RZYAcRjmlOo2EDK4ZnNb+wTBqmDSSQdiHOFBPxrp9HNn4rIsIxfnukiXiH8DmFJTAPzqDTK75aVT1Bo29dhv27K0+A+NPs5HxLx3aVAbxwJlnPF0uBfWtOG4/rqyXgD/bL78KjCQIC2qZ4JCrlT/4lmDr1P8p1lSBM09kpretHeAs6o6I805NuNrJUR05FgiLHTnkCRIjbNbKeXoaw5c5N4/w488nyXHXoNSJ/tsu6al+7gqzGLDaaFTb3p4IlmnPepDHdFOfush9jAt5We0TWIfPd1otihQjBPsq2Q9KQB0kEAf3bP0RhXb3QDm3SHSKtvv9zTN11jGzhHCt/Pc3g/kJBFKOhqZfFLZs/cT8yDfE8TcuxsXs3o49i0DE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(8936002)(356005)(478600001)(81166007)(6666004)(40460700003)(2906002)(5660300002)(54906003)(6636002)(36756003)(110136005)(316002)(40480700001)(426003)(55446002)(70586007)(86362001)(41300700001)(186003)(70206006)(47076005)(4326008)(9686003)(26005)(82740400003)(8676002)(83380400001)(336012)(36860700001)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:25.7712
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62735f48-9e35-4a97-40d5-08dac6426f0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4190
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Nothing populates them yet.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc.c          |  6 +++
 drivers/net/ethernet/sfc/tc.h          |  4 ++
 drivers/net/ethernet/sfc/tc_counters.c | 61 ++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_counters.h | 19 ++++++++
 4 files changed, 90 insertions(+)

diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 37d56a1ba958..8ea7f5213049 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -752,6 +752,9 @@ int efx_init_struct_tc(struct efx_nic *efx)
 
 	mutex_init(&efx->tc->mutex);
 	init_waitqueue_head(&efx->tc->flush_wq);
+	rc = efx_tc_init_counters(efx);
+	if (rc < 0)
+		goto fail_counters;
 	rc = rhashtable_init(&efx->tc->match_action_ht, &efx_tc_match_action_ht_params);
 	if (rc < 0)
 		goto fail_match_action_ht;
@@ -764,6 +767,8 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->extra_channel_type[EFX_EXTRA_CHANNEL_TC] = &efx_tc_channel_type;
 	return 0;
 fail_match_action_ht:
+	efx_tc_destroy_counters(efx);
+fail_counters:
 	mutex_destroy(&efx->tc->mutex);
 	kfree(efx->tc->caps);
 fail_alloc_caps:
@@ -784,6 +789,7 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 			     MC_CMD_MAE_ACTION_RULE_INSERT_OUT_ACTION_RULE_ID_NULL);
 	rhashtable_free_and_destroy(&efx->tc->match_action_ht, efx_tc_flow_free,
 				    efx);
+	efx_tc_fini_counters(efx);
 	mutex_unlock(&efx->tc->mutex);
 	mutex_destroy(&efx->tc->mutex);
 	kfree(efx->tc->caps);
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 97dc06f2e694..6c8ebb2d79c0 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -75,6 +75,8 @@ enum efx_tc_rule_prios {
  * @caps: MAE capabilities reported by MCDI
  * @block_list: List of &struct efx_tc_block_binding
  * @mutex: Used to serialise operations on TC hashtables
+ * @counter_ht: Hashtable of TC counters (FW IDs and counter values)
+ * @counter_id_ht: Hashtable mapping TC counter cookies to counters
  * @match_action_ht: Hashtable of TC match-action rules
  * @reps_mport_id: MAE port allocated for representor RX
  * @reps_filter_uc: VNIC filter for representor unicast RX (promisc)
@@ -96,6 +98,8 @@ struct efx_tc_state {
 	struct mae_caps *caps;
 	struct list_head block_list;
 	struct mutex mutex;
+	struct rhashtable counter_ht;
+	struct rhashtable counter_id_ht;
 	struct rhashtable match_action_ht;
 	u32 reps_mport_id, reps_mport_vport_id;
 	s32 reps_filter_uc, reps_filter_mc;
diff --git a/drivers/net/ethernet/sfc/tc_counters.c b/drivers/net/ethernet/sfc/tc_counters.c
index 4a310cd7f17f..9a4d1d2a1271 100644
--- a/drivers/net/ethernet/sfc/tc_counters.c
+++ b/drivers/net/ethernet/sfc/tc_counters.c
@@ -13,6 +13,67 @@
 #include "mae.h"
 #include "rx_common.h"
 
+/* Counter-management hashtables */
+
+static const struct rhashtable_params efx_tc_counter_id_ht_params = {
+	.key_len	= offsetof(struct efx_tc_counter_index, linkage),
+	.key_offset	= 0,
+	.head_offset	= offsetof(struct efx_tc_counter_index, linkage),
+};
+
+static const struct rhashtable_params efx_tc_counter_ht_params = {
+	.key_len	= offsetof(struct efx_tc_counter, linkage),
+	.key_offset	= 0,
+	.head_offset	= offsetof(struct efx_tc_counter, linkage),
+};
+
+static void efx_tc_counter_free(void *ptr, void *__unused)
+{
+	struct efx_tc_counter *cnt = ptr;
+
+	kfree(cnt);
+}
+
+static void efx_tc_counter_id_free(void *ptr, void *__unused)
+{
+	struct efx_tc_counter_index *ctr = ptr;
+
+	WARN_ON(refcount_read(&ctr->ref));
+	kfree(ctr);
+}
+
+int efx_tc_init_counters(struct efx_nic *efx)
+{
+	int rc;
+
+	rc = rhashtable_init(&efx->tc->counter_id_ht, &efx_tc_counter_id_ht_params);
+	if (rc < 0)
+		goto fail_counter_id_ht;
+	rc = rhashtable_init(&efx->tc->counter_ht, &efx_tc_counter_ht_params);
+	if (rc < 0)
+		goto fail_counter_ht;
+	return 0;
+fail_counter_ht:
+	rhashtable_destroy(&efx->tc->counter_id_ht);
+fail_counter_id_ht:
+	return rc;
+}
+
+/* Only call this in init failure teardown.
+ * Normal exit should fini instead as there may be entries in the table.
+ */
+void efx_tc_destroy_counters(struct efx_nic *efx)
+{
+	rhashtable_destroy(&efx->tc->counter_ht);
+	rhashtable_destroy(&efx->tc->counter_id_ht);
+}
+
+void efx_tc_fini_counters(struct efx_nic *efx)
+{
+	rhashtable_free_and_destroy(&efx->tc->counter_id_ht, efx_tc_counter_id_free, NULL);
+	rhashtable_free_and_destroy(&efx->tc->counter_ht, efx_tc_counter_free, NULL);
+}
+
 /* TC Channel.  Counter updates are delivered on this channel's RXQ. */
 
 static void efx_tc_handle_no_channel(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/tc_counters.h b/drivers/net/ethernet/sfc/tc_counters.h
index 400a39b00f01..f998cee324c7 100644
--- a/drivers/net/ethernet/sfc/tc_counters.h
+++ b/drivers/net/ethernet/sfc/tc_counters.h
@@ -10,6 +10,7 @@
 
 #ifndef EFX_TC_COUNTERS_H
 #define EFX_TC_COUNTERS_H
+#include <linux/refcount.h>
 #include "net_driver.h"
 
 #include "mcdi_pcol.h" /* for MAE_COUNTER_TYPE_* */
@@ -21,6 +22,24 @@ enum efx_tc_counter_type {
 	EFX_TC_COUNTER_TYPE_MAX
 };
 
+struct efx_tc_counter {
+	u32 fw_id; /* index in firmware counter table */
+	enum efx_tc_counter_type type;
+	struct rhash_head linkage; /* efx->tc->counter_ht */
+};
+
+struct efx_tc_counter_index {
+	unsigned long cookie;
+	struct rhash_head linkage; /* efx->tc->counter_id_ht */
+	refcount_t ref;
+	struct efx_tc_counter *cnt;
+};
+
+/* create/uncreate/teardown hashtables */
+int efx_tc_init_counters(struct efx_nic *efx);
+void efx_tc_destroy_counters(struct efx_nic *efx);
+void efx_tc_fini_counters(struct efx_nic *efx);
+
 extern const struct efx_channel_type efx_tc_channel_type;
 
 #endif /* EFX_TC_COUNTERS_H */
