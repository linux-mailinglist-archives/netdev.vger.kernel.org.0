Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8188E621A7F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbiKHR0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiKHR00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:26 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2072.outbound.protection.outlook.com [40.107.96.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1A7B81
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g+EsvHM6r1/e/tq4aBAsI19ddDwwGXa3fbWFnHyVWAFwhDOOS+pFV5CLLUO+kNDo1ykBSfYyZN+m2wklATi8YZ3TAW4DPjxupaN/BizVcbfwhndXLzwNvawIVkz9RfmDoN/SvJhAfqMsZ8yJJrt+8h6rXDLln7LKY41HRNjLNkrRMSbGMvPzcs8d9TvTkx9M+Ox5EYbeLcI2eeHD+VIEePoIbPtUSl0LpkO+AdUB0DTcmuoYVOuTkJmZPf5UpOqfJvKyUM3XXtweU1VDQQcBdgN+ylqSyhZPNsHTzfvZggc7sZ2Fk/NpVuyScReUCuUfrRUKvauxYQjEvxiMJMrPWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0STpD9VlgS/r/P+BMFrBIUlOsjfeEyn8GaI1km/PGgo=;
 b=A7bof2ibVn00UfQ4i1o3lepnVMjbPIEngUYZ+hP4wW6nwq1XG1Urh3tVtZP3wvrVHNrn16kacA2olw6xl9ffZ/oNwumfVB4/ppSPBrLX9RceJCosw35phaDNfpfCbezEbAlN5LK4jT175n+B1/wNzA34nFmhsapnU2c37K3LGBj6y0z/rVGFku490vgR7m+ZbO6RAQCZl0HDBAXgFF8tpW6v4sDVxci6bVFLShCdDJvrYj5/zQG1hG89y0s+i0Gj7xnWo0B1iPVQjs/1D1C+YcN0reO053I4rMmgIYpv7Y2bHPTZ/674fGgxAW+4u6IeCqRcxhXnGEOt2CNCBmbeVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0STpD9VlgS/r/P+BMFrBIUlOsjfeEyn8GaI1km/PGgo=;
 b=uS04ULNH/Enc2BEnzeYugagDqG4NlGrroC17Ky1qvcoPr2EMyqitjB9JkdVxCHsp1wvkN6nGoByUnpbLVvs3JoO/APCYjW+2+3Ywarnl3W7PicVfOpHY3aO17CmPOVnFarTvGZl0dahGDWJI1HDCpXwxx3QbV75vp5tO7kkLPQc=
Received: from MW4PR04CA0388.namprd04.prod.outlook.com (2603:10b6:303:81::33)
 by SN7PR12MB7275.namprd12.prod.outlook.com (2603:10b6:806:2ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 17:26:22 +0000
Received: from CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::cf) by MW4PR04CA0388.outlook.office365.com
 (2603:10b6:303:81::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT090.mail.protection.outlook.com (10.13.175.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Tue, 8 Nov 2022 17:26:22 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:19 -0600
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:18 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 06/11] sfc: add hashtables for MAE counters and counter ID mappings
Date:   Tue, 8 Nov 2022 17:24:47 +0000
Message-ID: <64a712ffb4ef488023d9934d65abfa9d6cbf061a.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT090:EE_|SN7PR12MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dd8708a-83a4-49da-0111-08dac1ae5b04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqujqrImN0BM3kg01aZH3HSX1nsU3IT6naZo6kw9FUeUxIW+Jj4fCWrpgbgiVafPN6weX+YpL7QPbJn1hE5DDVedOUNfPTm0yOp4Cgub6WeLyi0zS+8X00O0xS0E0PM1Ywie9Q0IOrr6z6ovAMDKroYiXEj29qBQ5f1ECWHbk9IEiHNh1n85cxrK+8g/sQ3s9wgSjnwyjdKkZ1m90WmX68XV6v0+YF8iWsC7l1BWJzWjpmXwPCm7b2Lfo621RtYgRe8md7cJliNfVqhAVjd8ZvcSkIW7+iDEu6Iq+a3lhP27l9P9d6p+LfcmSDISj9sqZcWcGl5BTvn22oazM4sbAuWOQZo1/3AzWuFt1GPi/qARoRXsCPjGdJGL6XnHHMiCBXS4n4SoC9067UuzDuPkULtbSY+Ea9M0hJAsqYPkLG5F6MUKuq5iRC3gwx+O6FasPUzYcU+MphgTg/7qcu2lBA2Z/SnfS/2NcLf2qEpwCcbWxiEJ7/ZHmMVoNpg0CHL5oWHuE+/F1tHSjxZ0ggr7OPmrTmjb4JNgSqhlzXOO9Bj43imhBafF6nDSIo4XsXDzrp0GfIXOIHCvN5+r8pWnWWXy7mNjuTlPYHWAuOVaHAqTWiR1nISp1rzlpPQau9cEPmTqdRAGloUkVGqleaQDm74TrXCn1ingOKpXDg56BduAKcLblMDDQbNKWniZ53lwZFxE9HMblla/i/cyrbzRAUCq3dUo5Ox30h6ygNcL0dSes6a3Zsz/3IgzxZ9tl1VlnHWY/8+ir08+G72blrgB+oJYLnFec93nKcnj/DG+3kE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(186003)(336012)(9686003)(26005)(36860700001)(83380400001)(47076005)(426003)(6666004)(2906002)(2876002)(40480700001)(40460700003)(110136005)(478600001)(54906003)(82310400005)(5660300002)(6636002)(41300700001)(4326008)(8936002)(70586007)(316002)(8676002)(70206006)(82740400003)(81166007)(36756003)(356005)(86362001)(55446002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:22.0243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd8708a-83a4-49da-0111-08dac1ae5b04
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7275
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
