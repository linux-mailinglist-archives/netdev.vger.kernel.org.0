Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80FE62810C
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbiKNNRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237936AbiKNNQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5E22B246
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HO/eDfi79oMKRda6Mb5+eBmlxdUSAknNpErOA/KTyzRkLAOC4GB4yn79WYd9nMSVrpCJ9ahTskWfRt03Sps3yYkaynaRQYPk39GAXWIuCA5Zo8pK2ihHy4sjSC1xTO4MZXbPXYMcXWFuPYsPzVD4N7o+rigDaxqnaoyJAzJrPjYMNFuP9u2Hn+JnfunC9ZE43pQPauOmrKpYE1aQBVdWIzsPvX9v3p5YkFQvnRlnGV6k/LXrXq0NT+rhxvAKILU6Ymmllijh9oASB63mixDPr6AFZda/xwp8Lfozc67k1ca9QGabNtFk2MU6Y78fbx43ZcgAqUR3hyUb4GoyM6989w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wu2gnAQ3GdqgV2oCTvHTjYw4PahNJjVQeQDikoqum+Q=;
 b=csxohASF8MTJV701ZG0AbwHinNOOYCekraUvK9stw/q459ONpZdEEahlhD6tsXC/UOCqtb2jt2M4m+8hnMzQT8EDSjH5pktS36McYKAUifq9ym8XPyC7lUOVu8K0aKJ3iQDzkzbgM94wVEruvGvnqVuA8zoxrHp/vTCOIjWBJXZG/Js4BgjZrQKo2KW1aXVwJyJIK2jbw4MgPDFm8ejUcoGzsyAJpMThEG3Eo1HJJjh/mm7qYPkfR1x6UiI0m7z0LuFpBdqk7ERwCs+vU4ca7+xgyCfyNZMCmTmLCoFzid8kcJzEjpWcH2MyxoXPVlCbYZiHJyn05i7Kanv+Bdj7bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wu2gnAQ3GdqgV2oCTvHTjYw4PahNJjVQeQDikoqum+Q=;
 b=qOcVzujkpBDGha/VUZfpWqhyYh7rG4VmIqpeOhBGPLF9dU5W7hxtBbcBrAn6LdA/0bi5zSmcgIGRoA9aOPhL/zjo5JypbTSmebQl1NCeBHx8/GB23XUqGK8Voq3O2//HMcie/cve3PHUCY1h9WFwNb/giyxl4E3lcBSB+ZKqqVE=
Received: from DM6PR11CA0068.namprd11.prod.outlook.com (2603:10b6:5:14c::45)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:27 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::a7) by DM6PR11CA0068.outlook.office365.com
 (2603:10b6:5:14c::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:27 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:26 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:26 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:25 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 08/12] sfc: add functions to allocate/free MAE counters
Date:   Mon, 14 Nov 2022 13:15:57 +0000
Message-ID: <78072783c6146cbaa1d631e8adc17630085fc04a.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT009:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: a9446320-3e6a-4c33-3b5b-08dac6426fbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhTeO+Acxt5c11v3z+4um4DaeOSDFQDUkvpqh3cZlDdkcfJxgpt9btWSnggvItXYhseB3DJXMWkeQYpwjMW6CMG+M+4lxoCNdLT/FAuVXxjwwC1xEWSAbi3CoRV4oBtuGpLrBySt2wPVrS2gZqFPieOK9MqpMztdjO94vDefCWw31SgN847J13SPKxXYa9nxbA0IHob9GIX6IyuCImORt7xoQeGat7yc4byS0/qCPMhVG1qzzPDzxyU7JClyllKp3c4NWIekopqE+dSzYoymCyeOhlN+m7CJ68fXNyqlX4L7FWJN7jIdI9fXq0jWia46UKANUNdKkQGpKp32oL+TAn+XEeHJdfByL4qs2aWHw1EHMEk1eklbxtQ7FrZB5vehNgq3LNgv2KC/iC5ljoC2nmN8jCWajXmfPUYvLDY8MAAH3kGHt5xLiPUnGtfQEwJ+Au+Qj0saQSaeebTp514d3Ies1SHfQ3vm3NjORM4agsdqoJDDOLdSEifuwIGfLxGxEbEqpJQ9Ums1CyFSqwuQcpygJeWz5HioHIQPDQfsBPKeh8HPfbueM2SKEnnCydeJ0I2DatbrlfkjP/fn+6wAhCZVHmMBaPEPXWjMojXUEOKSWQ3NsXGIsKK0OPxJmgArbwtmxVF8Ski73VS90zRQPaDQS+6koRL3uKDIVvatxG4mucP+wILt8EbqIU7Bpo7au/ZpRmGjmBm7GTB003R8a93PTfFXXAniOYGPgsYiMq1mdHof8mIagz5vX921ThiSpwsjx7x0cxkKazAuItGGgQLftwDCtFu+kflxZp5nzRfmFE49vkd3F2/5txPlCIuC
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(356005)(82310400005)(8936002)(81166007)(478600001)(6636002)(6666004)(110136005)(54906003)(40460700003)(40480700001)(36756003)(41300700001)(86362001)(26005)(9686003)(186003)(5660300002)(70206006)(55446002)(4326008)(8676002)(70586007)(316002)(83380400001)(82740400003)(426003)(47076005)(336012)(2906002)(36860700001)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:27.0444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9446320-3e6a-4c33-3b5b-08dac6426fbe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796
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

efx_tc_flower_get_counter_index() will create an MAE counter mapped to
 the passed (TC filter) cookie, or increment the reference if one already
 exists for that cookie.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c         |  51 ++++++++++++
 drivers/net/ethernet/sfc/mae.h         |   3 +
 drivers/net/ethernet/sfc/tc_counters.c | 109 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_counters.h |   7 ++
 4 files changed, 170 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 37722344c1cd..f227b4f2a9a0 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -434,6 +434,57 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 #undef CHECK_BIT
 #undef CHECK
 
+int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_ALLOC_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_COUNTER_ALLOC_V2_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	if (!cnt)
+		return -EINVAL;
+
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_ALLOC_V2_IN_REQUESTED_COUNT, 1);
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_ALLOC_V2_IN_COUNTER_TYPE, cnt->type);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_COUNTER_ALLOC, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	/* pcol says this can't happen, since count is 1 */
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	cnt->fw_id = MCDI_DWORD(outbuf, MAE_COUNTER_ALLOC_OUT_COUNTER_ID);
+	cnt->gen = MCDI_DWORD(outbuf, MAE_COUNTER_ALLOC_OUT_GENERATION_COUNT);
+	return 0;
+}
+
+int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_COUNTER_FREE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_COUNTER_FREE_V2_IN_LEN);
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_FREE_V2_IN_COUNTER_ID_COUNT, 1);
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_FREE_V2_IN_FREE_COUNTER_ID, cnt->fw_id);
+	MCDI_SET_DWORD(inbuf, MAE_COUNTER_FREE_V2_IN_COUNTER_TYPE, cnt->type);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_COUNTER_FREE, inbuf, sizeof(inbuf),
+			  outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	/* pcol says this can't happen, since count is 1 */
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	/* FW freed a different ID than we asked for, should also never happen.
+	 * Warn because it means we've now got a different idea to the FW of
+	 * what counters exist, which could cause mayhem later.
+	 */
+	if (WARN_ON(MCDI_DWORD(outbuf, MAE_COUNTER_FREE_OUT_FREED_COUNTER_ID) !=
+		    cnt->fw_id))
+		return -EIO;
+	return 0;
+}
+
 static bool efx_mae_asl_id(u32 id)
 {
 	return !!(id & BIT(31));
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 8f5de01dd962..72343e90e222 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -45,6 +45,9 @@ int efx_mae_match_check_caps(struct efx_nic *efx,
 			     const struct efx_tc_match_fields *mask,
 			     struct netlink_ext_ack *extack);
 
+int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
+int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
+
 int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act);
 int efx_mae_free_action_set(struct efx_nic *efx, u32 fw_id);
 
diff --git a/drivers/net/ethernet/sfc/tc_counters.c b/drivers/net/ethernet/sfc/tc_counters.c
index 9a4d1d2a1271..6fd07ce61eb7 100644
--- a/drivers/net/ethernet/sfc/tc_counters.c
+++ b/drivers/net/ethernet/sfc/tc_counters.c
@@ -74,6 +74,115 @@ void efx_tc_fini_counters(struct efx_nic *efx)
 	rhashtable_free_and_destroy(&efx->tc->counter_ht, efx_tc_counter_free, NULL);
 }
 
+/* Counter allocation */
+
+static struct efx_tc_counter *efx_tc_flower_allocate_counter(struct efx_nic *efx,
+							     int type)
+{
+	struct efx_tc_counter *cnt;
+	int rc, rc2;
+
+	cnt = kzalloc(sizeof(*cnt), GFP_USER);
+	if (!cnt)
+		return ERR_PTR(-ENOMEM);
+
+	cnt->type = type;
+
+	rc = efx_mae_allocate_counter(efx, cnt);
+	if (rc)
+		goto fail1;
+	rc = rhashtable_insert_fast(&efx->tc->counter_ht, &cnt->linkage,
+				    efx_tc_counter_ht_params);
+	if (rc)
+		goto fail2;
+	return cnt;
+fail2:
+	/* If we get here, it implies that we couldn't insert into the table,
+	 * which in turn probably means that the fw_id was already taken.
+	 * In that case, it's unclear whether we really 'own' the fw_id; but
+	 * the firmware seemed to think we did, so it's proper to free it.
+	 */
+	rc2 = efx_mae_free_counter(efx, cnt);
+	if (rc2)
+		netif_warn(efx, hw, efx->net_dev,
+			   "Failed to free MAE counter %u, rc %d\n",
+			   cnt->fw_id, rc2);
+fail1:
+	kfree(cnt);
+	return ERR_PTR(rc > 0 ? -EIO : rc);
+}
+
+static void efx_tc_flower_release_counter(struct efx_nic *efx,
+					  struct efx_tc_counter *cnt)
+{
+	int rc;
+
+	rhashtable_remove_fast(&efx->tc->counter_ht, &cnt->linkage,
+			       efx_tc_counter_ht_params);
+	rc = efx_mae_free_counter(efx, cnt);
+	if (rc)
+		netif_warn(efx, hw, efx->net_dev,
+			   "Failed to free MAE counter %u, rc %d\n",
+			   cnt->fw_id, rc);
+	/* This doesn't protect counter updates coming in arbitrarily long
+	 * after we deleted the counter.  The RCU just ensures that we won't
+	 * free the counter while another thread has a pointer to it.
+	 * Ensuring we don't update the wrong counter if the ID gets re-used
+	 * is handled by the generation count.
+	 */
+	synchronize_rcu();
+	kfree(cnt);
+}
+
+/* TC cookie to counter mapping */
+
+void efx_tc_flower_put_counter_index(struct efx_nic *efx,
+				     struct efx_tc_counter_index *ctr)
+{
+	if (!refcount_dec_and_test(&ctr->ref))
+		return; /* still in use */
+	rhashtable_remove_fast(&efx->tc->counter_id_ht, &ctr->linkage,
+			       efx_tc_counter_id_ht_params);
+	efx_tc_flower_release_counter(efx, ctr->cnt);
+	kfree(ctr);
+}
+
+struct efx_tc_counter_index *efx_tc_flower_get_counter_index(
+				struct efx_nic *efx, unsigned long cookie,
+				enum efx_tc_counter_type type)
+{
+	struct efx_tc_counter_index *ctr, *old;
+	struct efx_tc_counter *cnt;
+
+	ctr = kzalloc(sizeof(*ctr), GFP_USER);
+	if (!ctr)
+		return ERR_PTR(-ENOMEM);
+	ctr->cookie = cookie;
+	old = rhashtable_lookup_get_insert_fast(&efx->tc->counter_id_ht,
+						&ctr->linkage,
+						efx_tc_counter_id_ht_params);
+	if (old) {
+		/* don't need our new entry */
+		kfree(ctr);
+		if (!refcount_inc_not_zero(&old->ref))
+			return ERR_PTR(-EAGAIN);
+		/* existing entry found */
+		ctr = old;
+	} else {
+		cnt = efx_tc_flower_allocate_counter(efx, type);
+		if (IS_ERR(cnt)) {
+			rhashtable_remove_fast(&efx->tc->counter_id_ht,
+					       &ctr->linkage,
+					       efx_tc_counter_id_ht_params);
+			kfree(ctr);
+			return (void *)cnt; /* it's an ERR_PTR */
+		}
+		ctr->cnt = cnt;
+		refcount_set(&ctr->ref, 1);
+	}
+	return ctr;
+}
+
 /* TC Channel.  Counter updates are delivered on this channel's RXQ. */
 
 static void efx_tc_handle_no_channel(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/tc_counters.h b/drivers/net/ethernet/sfc/tc_counters.h
index f998cee324c7..85f4919271eb 100644
--- a/drivers/net/ethernet/sfc/tc_counters.h
+++ b/drivers/net/ethernet/sfc/tc_counters.h
@@ -26,6 +26,7 @@ struct efx_tc_counter {
 	u32 fw_id; /* index in firmware counter table */
 	enum efx_tc_counter_type type;
 	struct rhash_head linkage; /* efx->tc->counter_ht */
+	u32 gen; /* Generation count at which this counter is current */
 };
 
 struct efx_tc_counter_index {
@@ -40,6 +41,12 @@ int efx_tc_init_counters(struct efx_nic *efx);
 void efx_tc_destroy_counters(struct efx_nic *efx);
 void efx_tc_fini_counters(struct efx_nic *efx);
 
+struct efx_tc_counter_index *efx_tc_flower_get_counter_index(
+				struct efx_nic *efx, unsigned long cookie,
+				enum efx_tc_counter_type type);
+void efx_tc_flower_put_counter_index(struct efx_nic *efx,
+				     struct efx_tc_counter_index *ctr);
+
 extern const struct efx_channel_type efx_tc_channel_type;
 
 #endif /* EFX_TC_COUNTERS_H */
