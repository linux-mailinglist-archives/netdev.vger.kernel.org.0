Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F465EB0A6
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiIZS71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiIZS7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:59:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3907293236
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:59:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R0aGDN7UEPbGrFk1FMdFkjWH6esev89qdayrcK8/mx5Q4F/dsc2zEmTPuakeUhtP3C6QdWIZN5n3ML3/PtPTxbjI0iT6u3k8x2yY+zu1VfxM+WIaR8jNWqMJz/gq0E9IEOfEA+JxYJqvqXOSUNEJ+gqw8xP3oXLq79NiB1cTyECRsn7tu0YXwpOxw4eqmCyIpuLqxqCdSwYSztxZTEiyKEWSHeV639/Y+NrqbrgYTMXzbrX7hE3EmPt93FiTOYqsxK7blzfzmUfHhTrM2SmGLVhOQzXFXmmhHs7ODb071zxrX7m104f3hAYd2ppJSYYIafaOxpF9pYd8Hq/E0zLpcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHRRLhWBg+fXPLq20be5c8j1o+4f7c4qdC9knupKCNI=;
 b=GThmLvrvxj6mXwz1V3B0eX+JzgY7s83Vv/a8DMhAbTfoBUW6Zx4C5saShyoa+tIkRaNv6DmwGqXJeTWn9uAJEG4Ap7lkHHomidsxEYWUsvoFOqD0CjU+HHUb2FoSZ6kWh+26ZGqpdV8Xp23rv2EBxC/QJGyHKjQUKeU+qAKo1kFHkRFDuPcJeHCLDxxLJXJJW+JhXJJBCxxy1DiFLRrH2zRBm8nXx0ja2Uvks5hordDvxJti6uaAJV2yFzCxfL41lTSRifuRXuNC2KLyuf/s9KQARmEV+TUHeCqvertFI0jG/RZETzPksNIlWVpoMCWbx9zGyl/xG8OLw1zEcyxlyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHRRLhWBg+fXPLq20be5c8j1o+4f7c4qdC9knupKCNI=;
 b=kodpqIknFjDAVxgB76Jx8IVt17J3MHJgN0l5jgnQJeNry5lfCf4JOQMNPJPY5KiYcrNYcSONq247def+Yb+uGEhsFeMhKBc9K42HsL0PBQzWxaw6cUSTVUOzzNcDl4CvE0KMXaEWHbNpDw+kodaphIrcgRz23UJWVaNYTbS5ZjgpkV4iA4GpPaIQyXV7qmQX/GZbZ4ki0ZbMAyVaokBza/cw9FtDaP8jozbgfItSZ2lJFZP2Q7pnY8PBXCTw2dAgcALDgiqSJTB7dUdC3pkUwIW4KkOpOTGH28DMWngUEoS4VhLjtScWplMvBZrP1mv+B08R4zyImLxzXXxscfJRxw==
Received: from MW4PR03CA0108.namprd03.prod.outlook.com (2603:10b6:303:b7::23)
 by DM4PR12MB5103.namprd12.prod.outlook.com (2603:10b6:5:392::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 26 Sep
 2022 18:59:09 +0000
Received: from CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::d6) by MW4PR03CA0108.outlook.office365.com
 (2603:10b6:303:b7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25 via Frontend
 Transport; Mon, 26 Sep 2022 18:59:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT104.mail.protection.outlook.com (10.13.174.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Mon, 26 Sep 2022 18:59:08 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 13:59:08 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 26 Sep
 2022 13:59:07 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 26 Sep 2022 13:59:06 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 5/6] sfc: interrogate MAE capabilities at probe time
Date:   Mon, 26 Sep 2022 19:57:35 +0100
Message-ID: <cd9228aaa1c6b8edc68a37493d2f17a0d34ab3d5.1664218348.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1664218348.git.ecree.xilinx@gmail.com>
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT104:EE_|DM4PR12MB5103:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b93c1e-460f-4a1a-b04b-08da9ff13160
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzJ9wy6omdJSg5sQOMGk57Elh4Bczm4Uc1sYX7TdFEhghfNhTrY5SEFoPMTX0qb0ONqzv6QpUS1GHQleYbzYPO+31wmmyTasUmfat/o3BTznL86AQLH1Hha7ceoY4g5QHQC1TUXpnjMPtoZVn/k9CFy4xXzAzEwlmmvIv8ATJ7Lejj+2PkJhOS2SmvFujNc2d4YrVgG0k0haPyMJUNXta8lVHghQTcr7RCMmd1IDtiPMNQiT6LyBABd1JpEnumTiivra1vTVb/B174p2oRi2BvT4rfETUXq2kg237iYA2DAuigAwp8EffrnCA1JZ7lB2lZ4/z51PQdQffB7y0ijjQ2+uSf63KlWMXtNJQhJ+M6SAmFz8MEqRcDFMUGp9PiKs2prwXmWpOr329/akshhsMNft5q5DvoV0vxMKGScFXTSfR+CsKNUBWyLMNNkmUVdZldMDSlwMJkPmvadjaJeqProp7Zs22dteQipOurOSnPX6cZO3OvO1u8ObQEeXOLDr+XmrjsPsPFr3b5pFhGua0Zn6538gP7HpvxuYbsMiW1LDZ9gvbVqg6UeMyVrEZ0cPTUAkaZN2CJkXRb4YNCffrIIcJz7eACIONtbugpdhDRXHWkAs3mwIztF5rqqkoYX0BGql2DdfmBVPSaNsONverHi8bH7GKlHXjH+ezcqX6gpcOb2ieNYsf80ZOPRiqLfCmJ5unu9hvDS7+CBxUmqYRpXX8rpJ7HsbzXsH3PdP4SeitpZdCmqkvjss43TKsPGayI/bKrr7eHRPtRuMKsYNhu5XxyEOowZVWsnwfLRvQZE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199015)(36840700001)(40470700004)(46966006)(110136005)(36756003)(2906002)(2876002)(186003)(55446002)(5660300002)(8936002)(42882007)(336012)(47076005)(41300700001)(81166007)(9686003)(26005)(40480700001)(356005)(4326008)(8676002)(70586007)(70206006)(82740400003)(83380400001)(36860700001)(82310400005)(316002)(40460700003)(54906003)(83170400001)(6666004)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 18:59:08.8826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b93c1e-460f-4a1a-b04b-08da9ff13160
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5103
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

Different versions of EF100 firmware and FPGA bitstreams support different
 matching capabilities in the Match-Action Engine.  Probe for these at
 start of day; subsequent patches will validate TC offload requests
 against the reported capabilities.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 56 ++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h | 10 ++++++
 drivers/net/ethernet/sfc/tc.c  | 25 +++++++++++++++
 drivers/net/ethernet/sfc/tc.h  |  2 ++
 4 files changed, 93 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 97627f5e3674..19138b2d2f5c 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -112,6 +112,62 @@ int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id)
 	return 0;
 }
 
+static int efx_mae_get_basic_caps(struct efx_nic *efx, struct mae_caps *caps)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_GET_CAPS_OUT_LEN);
+	size_t outlen;
+	int rc;
+
+	BUILD_BUG_ON(MC_CMD_MAE_GET_CAPS_IN_LEN);
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_GET_CAPS, NULL, 0, outbuf,
+			  sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	caps->match_field_count = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_MATCH_FIELD_COUNT);
+	caps->action_prios = MCDI_DWORD(outbuf, MAE_GET_CAPS_OUT_ACTION_PRIOS);
+	return 0;
+}
+
+static int efx_mae_get_rule_fields(struct efx_nic *efx, u32 cmd,
+				   u8 *field_support)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_GET_AR_CAPS_OUT_LEN(MAE_NUM_FIELDS));
+	MCDI_DECLARE_STRUCT_PTR(caps);
+	unsigned int count;
+	size_t outlen;
+	int rc, i;
+
+	BUILD_BUG_ON(MC_CMD_MAE_GET_AR_CAPS_IN_LEN);
+
+	rc = efx_mcdi_rpc(efx, cmd, NULL, 0, outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	count = MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_COUNT);
+	memset(field_support, MAE_FIELD_UNSUPPORTED, MAE_NUM_FIELDS);
+	caps = _MCDI_DWORD(outbuf, MAE_GET_AR_CAPS_OUT_FIELD_FLAGS);
+	/* We're only interested in the support status enum, not any other
+	 * flags, so just extract that from each entry.
+	 */
+	for (i = 0; i < count; i++)
+		if (i * sizeof(*outbuf) + MC_CMD_MAE_GET_AR_CAPS_OUT_FIELD_FLAGS_OFST < outlen)
+			field_support[i] = EFX_DWORD_FIELD(caps[i], MAE_FIELD_FLAGS_SUPPORT_STATUS);
+	return 0;
+}
+
+int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps)
+{
+	int rc;
+
+	rc = efx_mae_get_basic_caps(efx, caps);
+	if (rc)
+		return rc;
+	return efx_mae_get_rule_fields(efx, MC_CMD_MAE_GET_AR_CAPS,
+				       caps->action_rule_fields);
+}
+
 static bool efx_mae_asl_id(u32 id)
 {
 	return !!(id & BIT(31));
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 0369be4d8983..2b49a88b303c 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -27,6 +27,16 @@ void efx_mae_mport_mport(struct efx_nic *efx, u32 mport_id, u32 *out);
 
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 selector, u32 *id);
 
+#define MAE_NUM_FIELDS	(MAE_FIELD_ENC_VNET_ID + 1)
+
+struct mae_caps {
+	u32 match_field_count;
+	u32 action_prios;
+	u8 action_rule_fields[MAE_NUM_FIELDS];
+};
+
+int efx_mae_get_caps(struct efx_nic *efx, struct mae_caps *caps);
+
 int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act);
 int efx_mae_free_action_set(struct efx_nic *efx, u32 fw_id);
 
diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
index 08e2af665380..2b2d45b97305 100644
--- a/drivers/net/ethernet/sfc/tc.c
+++ b/drivers/net/ethernet/sfc/tc.c
@@ -305,6 +305,23 @@ int efx_init_tc(struct efx_nic *efx)
 {
 	int rc;
 
+	rc = efx_mae_get_caps(efx, efx->tc->caps);
+	if (rc)
+		return rc;
+	if (efx->tc->caps->match_field_count > MAE_NUM_FIELDS)
+		/* Firmware supports some match fields the driver doesn't know
+		 * about.  Not fatal, unless any of those fields are required
+		 * (MAE_FIELD_SUPPORTED_MATCH_ALWAYS) but if so we don't know.
+		 */
+		netif_warn(efx, probe, efx->net_dev,
+			   "FW reports additional match fields %u\n",
+			   efx->tc->caps->match_field_count);
+	if (efx->tc->caps->action_prios < EFX_TC_PRIO__NUM) {
+		netif_err(efx, probe, efx->net_dev,
+			  "Too few action prios supported (have %u, need %u)\n",
+			  efx->tc->caps->action_prios, EFX_TC_PRIO__NUM);
+		return -EIO;
+	}
 	rc = efx_tc_configure_default_rule_pf(efx);
 	if (rc)
 		return rc;
@@ -344,6 +361,11 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	efx->tc = kzalloc(sizeof(*efx->tc), GFP_KERNEL);
 	if (!efx->tc)
 		return -ENOMEM;
+	efx->tc->caps = kzalloc(sizeof(struct mae_caps), GFP_KERNEL);
+	if (!efx->tc->caps) {
+		rc = -ENOMEM;
+		goto fail_alloc_caps;
+	}
 	INIT_LIST_HEAD(&efx->tc->block_list);
 
 	mutex_init(&efx->tc->mutex);
@@ -359,6 +381,8 @@ int efx_init_struct_tc(struct efx_nic *efx)
 	return 0;
 fail_match_action_ht:
 	mutex_destroy(&efx->tc->mutex);
+	kfree(efx->tc->caps);
+fail_alloc_caps:
 	kfree(efx->tc);
 	efx->tc = NULL;
 	return rc;
@@ -378,6 +402,7 @@ void efx_fini_struct_tc(struct efx_nic *efx)
 				    efx);
 	mutex_unlock(&efx->tc->mutex);
 	mutex_destroy(&efx->tc->mutex);
+	kfree(efx->tc->caps);
 	kfree(efx->tc);
 	efx->tc = NULL;
 }
diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
index 94a04374e505..baf1e67b58a5 100644
--- a/drivers/net/ethernet/sfc/tc.h
+++ b/drivers/net/ethernet/sfc/tc.h
@@ -71,6 +71,7 @@ enum efx_tc_rule_prios {
 /**
  * struct efx_tc_state - control plane data for TC offload
  *
+ * @caps: MAE capabilities reported by MCDI
  * @block_list: List of &struct efx_tc_block_binding
  * @mutex: Used to serialise operations on TC hashtables
  * @match_action_ht: Hashtable of TC match-action rules
@@ -85,6 +86,7 @@ enum efx_tc_rule_prios {
  * @up: have TC datastructures been set up?
  */
 struct efx_tc_state {
+	struct mae_caps *caps;
 	struct list_head block_list;
 	struct mutex mutex;
 	struct rhashtable match_action_ht;
