Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580375E84E3
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiIWVaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiIWVaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:30:19 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7808169C
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:30:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLd89qim7Rlqvw//vNBWI9+acBDj312uzdSIskVLV+A0gYYJRsSf6CNP66/ig7q7YY3MUnuUo+pPqjYiQynos0ONmkbU3sjR8gXVFgUDXrvleqh0Q0MTr5hO4Zxk1njjutGNGHSkA84PmCRkYlTqzk5ZYzIPqUuuX87p/5cwNfqvYBi9D4K2nUg1woida6A4RV5YOv1xqD2fIKlIBaZXLGdicZcO3rNdjhM15Og93keIYtEXIg8sOk2HlZm882YQoWSgRyTNxI9JUTaqPXoRY1kz4eeKlpE6QiKPhQjXCsrZg82F4GEG2Fic0OWcSEF+BBMsjfYaIc6f4fPKf0GPlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Wca0r18C7fEalj5IJLzpSrLfUWBjhLSzBRl+wK7pJ8=;
 b=lLTXS43YrvW8bC+x4t6coRTLF+bFdBqQd6voal5lRIZr4t3JPDg9fGG4IsGeI4diXT2Fc0O7gd+1BtrHBnuCUJA7Q/4ugqBrGt109izfIUlGj13UegzEOkRfX9OJNb7cL/tFgjytlliRS0krXKXDqXR8ClO6ZagmEgQnT1PzVbr7t/FgTRIBJxccGFjIrTNM0QuMnUu7JdCCSg8Pq8xJ7YFCw7crubsGF03+8lBI7pF0ASIIVKL5JFMvo9naeH+NPsONAY2x0w+NNHUv284voTkowDjbGWIpqPBFn2AXT+OyP8sJkkH1L5MN/bY3vjLgd6jJjyfqHDI/7wNlzW0urg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Wca0r18C7fEalj5IJLzpSrLfUWBjhLSzBRl+wK7pJ8=;
 b=k7VQPiVAoBcj1WDXFd1ZSSievbF0IOfXwKkx5gF+zhxs3epkU6zWrWG5MweVPAaNgoYAWWwPZ7bJKpwSzjVU9txcg3/ngp01sAfm2uSjzJFq5UBus1keK4EP+9XWeDHCPTgdFGgjVBF7ANqJFWxCIgwjdeEfwEMkM0Kwwuwk0xUCiud+e7Wxc8jxsoVGAQq6sv3gN0tFlqsNB13qGBlNxgLWhMde6rYvlhoykt44Aw1fAAnJ/1M+ErjAeDnQqvoEjVTo19FNc6k7TqQhHl418A7OQ0/VlnfseUwH5oRzwL3jShJVoswYiBdRLz/NzKi31xCUCHsrKPfiLEn3ycm4eg==
Received: from BN9PR03CA0897.namprd03.prod.outlook.com (2603:10b6:408:13c::32)
 by IA0PR12MB7627.namprd12.prod.outlook.com (2603:10b6:208:437::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Fri, 23 Sep
 2022 21:29:58 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::c7) by BN9PR03CA0897.outlook.office365.com
 (2603:10b6:408:13c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20 via Frontend
 Transport; Fri, 23 Sep 2022 21:29:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5654.14 via Frontend Transport; Fri, 23 Sep 2022 21:29:58 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 23 Sep
 2022 16:29:57 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 23 Sep 2022 16:29:56 -0500
From:   <ecree@xilinx.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH net-next 5/6] sfc: interrogate MAE capabilities at probe time
Date:   Fri, 23 Sep 2022 22:05:37 +0100
Message-ID: <cecc8784dc84519b206c1afa4c98810fd0ad22ef.1663962653.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1663962652.git.ecree.xilinx@gmail.com>
References: <cover.1663962652.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT049:EE_|IA0PR12MB7627:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a1b138d-8913-40c2-d06b-08da9daac401
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbjPjgWQSr/bEd2NrUMutyS3vjWDYWf+s5gNB26VPUCpOpGf+BIoaqeMRoi3WVSmL52LIhd7hyqY/jktjuq+Ub7JhyqK4ElU3t4whIplGOAGv/Frs0Ft/ogthQd2LLgEUzHxphkP33gazGz0YUYbhYDNCQMK+zN2pqAMkFeIA3kV00fVP/xhgpxbfXD2s0v6zLcCBCfGRJypsgqa9mwJ0BaQGre+ZOSHyPmF2MbYjQOnHVooaGY9pEkph0hWTAcbDOUAsEBa34g+mejPjwsX4C/drWFKcT4bZW9O8gehcCpNjWNaWbtY7yCJqoMQnrDwRaZRedmWCISYIhSVGlzugMcTtF9zv3bPFB9vXe+Hlil76tK9AgneiYnn1OMp1U3I7NSNovld698mrT1uGekXs8+zuyDmEZUoC47NujAKXcjc+9tzfX3KEl9L9+ap5XPuYc+eCR+cGucvDPq1wtSf+0Q5gcnNM1038gZNOIiPUiMrcRB9VNVQ4lt8jgN86uinBN8CbW/gvhmwj6aYwEB2cgCH6VWyzrdQoaX9ILMIF/Fa/UNpHzjG3kTCZhZZlg4yzxmiwKo7SMbnEkB1fVGJh7Ds/RV672LNVhbu/tGWlKvVOUPv6noG197ZycWoiuBJ6vz3JBVtZK9PUI73Q60yI/KwfUOk9aDa3kZkYjmxAOcMdXShsWASx88qaHp6L03R1yn+ZAtQrX0yHYXBIgUFqTor+5/yfG33pSfZFHfmlazvvTqE4YOx3YZSOxKNSIzk3fCDWPPpQgt+IDD9jb4Zm0whKDJEXZ9hTFKkUge9etU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199015)(36840700001)(46966006)(40470700004)(55446002)(40480700001)(26005)(9686003)(6666004)(41300700001)(110136005)(336012)(54906003)(5660300002)(186003)(8936002)(42882007)(82310400005)(2906002)(2876002)(36860700001)(36756003)(8676002)(70586007)(83380400001)(40460700003)(70206006)(316002)(4326008)(47076005)(83170400001)(478600001)(81166007)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 21:29:58.4175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a1b138d-8913-40c2-d06b-08da9daac401
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7627
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

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
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
index 51e75feb7a42..bc8c3cab4db8 100644
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
