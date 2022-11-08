Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE3B621A7A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbiKHR00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiKHR0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:22 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2086.outbound.protection.outlook.com [40.107.95.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0389C110C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUd05AlF3PS4ARjmRCa6fBE41kD4GpcmJRLEkGKdmHone15O62PViZGNwKZnfAaPSNQBSmVwXzCpDri6OzSw4GPj5hwtQ12uArj9squcw4AdQps8njEWSht9LDpjhA6M1YyaubKhRjeUeXOJN+EGR6Ps7QCnGTaDzHp160U37v4driY/hPsjUEQVr0xZB5JdNLIH75yQfcsugQqMYG7MqMnaeT5OEmFe6lUod4OCl0FN6gCl/IvGmanouuwybJH8aQPHN5Yrqis48yT+B/eVN0dpDDrAZpXD+P7EoB342JmYoEPam61N2sjmSvQ0Qnqc3hezAyhFv6Eqjs1NPPScSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLVBacy/udwPW6RbyJxchF44mJXCAfyMFW/wQPQk2Ag=;
 b=HXNsLpVWRJe1aD1dxEfBYEM8eNkl4mwDFWoNQR+T1eMIQXqXp7vzHy6oenDdOmM01OVjkFrv8L/inQ2J4L/0WrkZOSBLAO738AcuJGdUMjCARl4w3VB470ome0Q1u1yqICwMuQnAczxcuRAL+wPFFw72G4sE39zdd3EShVNeLIB0WYOpWzTdv86Dfnq+qtMhjjHhnRTuDxzVg4gp24/877VykOxvtZN/wnztJg3rNmQ3m4m4ZSqhhGHqzdmH2MhODjtwqKxpv0z/bNb4UwaGAC9Q61sAEzp4P6sonW5cS2fP/XgrInOni220ASTVU1V+W3t1aIYe4LQc3KvrpJ3lPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLVBacy/udwPW6RbyJxchF44mJXCAfyMFW/wQPQk2Ag=;
 b=xVJ3h+OO4etZBw4iYETfjHRVqVg0nzVXI/VhU0QOJKT+btZEzv3XvsM1AcW0PcQmrwSbn7bHoqRlFLCBNc+0GwLI13kPxVfEwAw2deXRp6RL8Li2uLU6OpPYM/3CRiDgeks9Hn3Eyiq+s7gI5b4MSSpHYnVxsSLp/5NJL3M7USg=
Received: from MW4PR03CA0073.namprd03.prod.outlook.com (2603:10b6:303:b6::18)
 by SN7PR12MB6887.namprd12.prod.outlook.com (2603:10b6:806:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Tue, 8 Nov
 2022 17:26:18 +0000
Received: from CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::97) by MW4PR03CA0073.outlook.office365.com
 (2603:10b6:303:b6::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT101.mail.protection.outlook.com (10.13.175.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 17:26:17 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:17 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:16 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:15 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 04/11] sfc: add ef100 MAE counter support functions
Date:   Tue, 8 Nov 2022 17:24:45 +0000
Message-ID: <32a8072177e57d66e6046d03a68ea6b7f99b73a9.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT101:EE_|SN7PR12MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 3375eb07-ac20-4a48-f9e1-08dac1ae5873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ne14KNqy8we4R1vWe8z8WOeAufUkaYbieeJlGOyVU9j86mwsaFD4JbJcq+A6COAbDE4yK+ri+Ae670Oa9NjOXM5d5J8v8NQz4a9JdNucaJLltGcahNJB9OgyJ1n5mVSrnkd1Wx2W0tugaFYdcYyKlmt6u8YOLVUowz2Zzc1FOhJTu5xwvDupLJGkGsmZRlr4ypbxM/yi9dk/OR9QkXZUcvvKBngwHjbiCLWLkQO1eK4HhD9/LiGapjW1Y9DP0xgUUxm+jHlhEtJT4Re2P5hCoLcanbexUaq/h2SdsN8jl6ta8fPZbSCncUTCkTchCGC04walkGtftuS+fj2hZPqD1eEhx3TEQippO2Q/OmD/FnT9TNVtVOCj6+s3wVAFB8K1LVqYVvm3O313NNzm4mUV7P36UnPOKG0uytiu52A6qS4tTCbp+fDs/+REmReaMmsZZ9mmaEz25Dm8sLK54DuwqclG7kQ4oii7uWezsoFMCl834Y9GUX/dl8/x2OWsIm656ZxXcyJRg7HziBwoqOINfx9515+pLB0BgHSUtzyLyKDdtr9BlDqTzJCJTAg23vr+mW15LFI4BXjXoqZBxssyUuJB7TBuFOy2Pk5oFCqgyPSMPIcyvS0fDhxmOwoXGhjes3xumBvKlvHI/RQiHNf2NVayb7KD3zUSvNmpQ4uM4NZeDenvhHfthAZMGNd1rqSI3jYxzyHvYhAr8OjATPzdHzZHT5azU+mkhS/5YTYYtO/tD6f1yiUbaBgb4rFjZDuixiU44b729Q7l1fITEN7EPM6bNEVYQvjKhql+BRtRLq0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(2876002)(316002)(82740400003)(86362001)(81166007)(55446002)(6636002)(82310400005)(54906003)(356005)(2906002)(110136005)(70206006)(41300700001)(70586007)(47076005)(8936002)(8676002)(186003)(40460700003)(426003)(336012)(83380400001)(478600001)(4326008)(26005)(6666004)(5660300002)(9686003)(36756003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:17.7406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3375eb07-ac20-4a48-f9e1-08dac1ae5873
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6887
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

Start and stop MAE counter streaming, and grant credits.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c  | 111 ++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h  |   4 ++
 drivers/net/ethernet/sfc/mcdi.h |   5 ++
 drivers/net/ethernet/sfc/tc.c   |   1 +
 drivers/net/ethernet/sfc/tc.h   |  18 ++++++
 5 files changed, 139 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 1e605e2a08c5..37722344c1cd 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -112,6 +112,117 @@ int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
 	return 0;
 }
 
+int efx_mae_start_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_COUNTERS_STREAM_START_V2_IN_LEN);
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTERS_STREAM_START_OUT_LEN);
+	u32 out_flags;
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_WORD(inbuf, MAE_COUNTERS_STREAM_START_V2_IN_QID,
+		      efx_rx_queue_index(rx_queue));
+	MCDI_SET_WORD(inbuf, MAE_COUNTERS_STREAM_START_V2_IN_PACKET_SIZE,
+		      efx->net_dev->mtu);
+	MCDI_SET_DWORD(inbuf, MAE_COUNTERS_STREAM_START_V2_IN_COUNTER_TYPES_MASK,
+		       BIT(MAE_COUNTER_TYPE_AR) | BIT(MAE_COUNTER_TYPE_CT) |
+		       BIT(MAE_COUNTER_TYPE_OR));
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_COUNTERS_STREAM_START,
+			  inbuf, sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	out_flags = MCDI_DWORD(outbuf, MAE_COUNTERS_STREAM_START_OUT_FLAGS);
+	if (out_flags & BIT(MC_CMD_MAE_COUNTERS_STREAM_START_OUT_USES_CREDITS_OFST)) {
+		netif_dbg(efx, drv, efx->net_dev,
+			  "MAE counter stream uses credits\n");
+		rx_queue->grant_credits = true;
+		out_flags &= ~BIT(MC_CMD_MAE_COUNTERS_STREAM_START_OUT_USES_CREDITS_OFST);
+	}
+	if (out_flags) {
+		netif_err(efx, drv, efx->net_dev,
+			  "MAE counter stream start: unrecognised flags %x\n",
+			  out_flags);
+		goto out_stop;
+	}
+	return 0;
+out_stop:
+	efx_mae_stop_counters(efx, rx_queue);
+	return -EOPNOTSUPP;
+}
+
+static bool efx_mae_counters_flushed(u32 *flush_gen, u32 *seen_gen)
+{
+	int i;
+
+	for (i = 0; i < EFX_TC_COUNTER_TYPE_MAX; i++)
+		if ((s32)(flush_gen[i] - seen_gen[i]) > 0)
+			return false;
+	return true;
+}
+
+int efx_mae_stop_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTERS_STREAM_STOP_V2_OUT_LENMAX);
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_COUNTERS_STREAM_STOP_IN_LEN);
+	size_t outlen;
+	int rc, i;
+
+	MCDI_SET_WORD(inbuf, MAE_COUNTERS_STREAM_STOP_IN_QID,
+		      efx_rx_queue_index(rx_queue));
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_COUNTERS_STREAM_STOP,
+			  inbuf, sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+
+	if (rc)
+		return rc;
+
+	netif_dbg(efx, drv, efx->net_dev, "Draining counters:\n");
+	/* Only process received generation counts */
+	for (i = 0; (i < (outlen / 4)) && (i < EFX_TC_COUNTER_TYPE_MAX); i++) {
+		efx->tc->flush_gen[i] = MCDI_ARRAY_DWORD(outbuf,
+							 MAE_COUNTERS_STREAM_STOP_V2_OUT_GENERATION_COUNT,
+							 i);
+		netif_dbg(efx, drv, efx->net_dev,
+			  "\ttype %u, awaiting gen %u\n", i,
+			  efx->tc->flush_gen[i]);
+	}
+
+	efx->tc->flush_counters = true;
+
+	/* Drain can take up to 2 seconds owing to FWRIVERHD-2884; whatever
+	 * timeout we use, that delay is added to unload on nonresponsive
+	 * hardware, so 2500ms seems like a reasonable compromise.
+	 */
+	if (!wait_event_timeout(efx->tc->flush_wq,
+				efx_mae_counters_flushed(efx->tc->flush_gen,
+							 efx->tc->seen_gen),
+				msecs_to_jiffies(2500)))
+		netif_warn(efx, drv, efx->net_dev,
+			   "Failed to drain counters RXQ, FW may be unhappy\n");
+
+	efx->tc->flush_counters = false;
+
+	return rc;
+}
+
+void efx_mae_counters_grant_credits(struct work_struct *work)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_COUNTERS_STREAM_GIVE_CREDITS_IN_LEN);
+	struct efx_rx_queue *rx_queue = container_of(work, struct efx_rx_queue,
+						     grant_work);
+	struct efx_nic *efx = rx_queue->efx;
+	unsigned int credits;
+
+	BUILD_BUG_ON(MC_CMD_MAE_COUNTERS_STREAM_GIVE_CREDITS_OUT_LEN);
+	credits = READ_ONCE(rx_queue->notified_count) - rx_queue->granted_count;
+	MCDI_SET_DWORD(inbuf, MAE_COUNTERS_STREAM_GIVE_CREDITS_IN_NUM_CREDITS,
+		       credits);
+	if (!efx_mcdi_rpc(efx, MC_CMD_MAE_COUNTERS_STREAM_GIVE_CREDITS,
+			  inbuf, sizeof(inbuf), NULL, 0, NULL))
+		rx_queue->granted_count += credits;
+}
+
 static int efx_mae_get_basic_caps(struct efx_nic *efx, struct mae_caps *caps)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_GET_CAPS_OUT_LEN);
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 3e0cd238d523..8f5de01dd962 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -27,6 +27,10 @@ void efx_mae_mport_mport(struct efx_nic *efx, u32 mport_id, u32 *out);
 
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
 
+int efx_mae_start_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
+int efx_mae_stop_counters(struct efx_nic *efx, struct efx_rx_queue *rx_queue);
+void efx_mae_counters_grant_credits(struct work_struct *work);
+
 #define MAE_NUM_FIELDS	(MAE_FIELD_ENC_VNET_ID + 1)
 
 struct mae_caps {
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index fbeb58104936..7e35fec9da35 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -221,6 +221,11 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define MCDI_BYTE(_buf, _field)						\
 	((void)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 1),	\
 	 *MCDI_PTR(_buf, _field))
+#define MCDI_SET_WORD(_buf, _field, _value) do {			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 2);			\
+	BUILD_BUG_ON(MC_CMD_ ## _field ## _OFST & 1);			\
+	*(__force __le16 *)MCDI_PTR(_buf, _field) = cpu_to_le16(_value);\
+	} while (0)
 #define MCDI_WORD(_buf, _field)						\
 	((u16)BUILD_BUG_ON_ZERO(MC_CMD_ ## _field ## _LEN != 2) +	\
 	 le16_to_cpu(*(__force const __le16 *)MCDI_PTR(_buf, _field)))
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 17e1a3447554..894f578b3296 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -751,6 +751,7 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	INIT_LIST_HEAD(&efx->tc->block_list);
 
 	mutex_init(&efx->tc->mutex);
+	init_waitqueue_head(&efx->tc->flush_wq);
 	rc = rhashtable_init(&efx->tc->match_action_ht, &efx_tc_match_action_ht_params);
 	if (rc < 0)
 		goto fail_match_action_ht;
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 4240c375a8e6..464fc92e2d37 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -14,6 +14,14 @@
 #include <net/flow_offload.h>
 #include <linux/rhashtable.h>
 #include "net_driver.h"
+#include "mcdi_pcol.h" /* for MAE_COUNTER_TYPE_* */
+
+enum efx_tc_counter_type {
+	EFX_TC_COUNTER_TYPE_AR = MAE_COUNTER_TYPE_AR,
+	EFX_TC_COUNTER_TYPE_CT = MAE_COUNTER_TYPE_CT,
+	EFX_TC_COUNTER_TYPE_OR = MAE_COUNTER_TYPE_OR,
+	EFX_TC_COUNTER_TYPE_MAX
+};
 
 #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
 
@@ -79,6 +87,12 @@ enum efx_tc_rule_prios {
  * @reps_filter_uc: VNIC filter for representor unicast RX (promisc)
  * @reps_filter_mc: VNIC filter for representor multicast RX (allmulti)
  * @reps_mport_vport_id: vport_id for representor RX filters
+ * @flush_counters: counters have been stopped, waiting for drain
+ * @flush_gen: final generation count per type array as reported by
+ *             MC_CMD_MAE_COUNTERS_STREAM_STOP
+ * @seen_gen: most recent generation count per type as seen by efx_tc_rx()
+ * @flush_wq: wait queue used by efx_mae_stop_counters() to wait for
+ *	MAE counters RXQ to finish draining
  * @dflt: Match-action rules for default switching; at priority
  *	%EFX_TC_PRIO_DFLT.  Named by *ingress* port
  * @dflt.pf: rule for traffic ingressing from PF (egresses to wire)
@@ -92,6 +106,10 @@ struct efx_tc_state {
 	struct rhashtable match_action_ht;
 	u32 reps_mport_id, reps_mport_vport_id;
 	s32 reps_filter_uc, reps_filter_mc;
+	bool flush_counters;
+	u32 flush_gen[EFX_TC_COUNTER_TYPE_MAX];
+	u32 seen_gen[EFX_TC_COUNTER_TYPE_MAX];
+	wait_queue_head_t flush_wq;
 	struct {
 		struct efx_tc_flow_rule pf;
 		struct efx_tc_flow_rule wire;
