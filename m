Return-Path: <netdev+bounces-8180-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 765C6722FAD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDC391C20902
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF5624E97;
	Mon,  5 Jun 2023 19:20:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE41BDDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:20:03 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34281AD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:19:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7mOqhbRu77ew+oJTEWg+HGnwTlYaCsFc7ves1XAsY9KEnS6pNsDSNoLsliBHdsp77heYRMlQpIyqFzBFGcp+XXTqGARZZfGncVCDP9DgZl5Nb8GlRsiv3j2Fo7fEzI4hTWrJ7fUn120V/y/rt1o2iJZzlWnHb6SIkodyY/yQrEpTB30XI+yT4FYnKyKxWLLkqYq6vjeNzpueRb0yl1T6c6IUjZPtOzcPHAPXZC8MPbuhgxSGhYFOuFDSxkZRVmh5wznzBHZ2UU6omNKalCzAUq8CegzrpKFG0FhZVdt69t2bUCgprprpE5V9v62PNpNvHdiiNfQ242ZDgiMyd3+YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2I4/UkgZBzu+PNIhBrAcjSz0zSzNgNQiblOoWe3Monk=;
 b=cq/kUDA1XnQdUy+EW8UNdBbh0x2Q8TjWvqw5ZvqKZCJBJM34djaOkT6Alo+0XW5fDA7Ax8K1qnajPKHWkqMEAJMDcBq2J+iNreuYTbpoiWgdVDx+2ptstcLrWzenjMMmMCa7WhqHJLtv3yLLcumyeW4feM3CsLG55j71S4TGl8s8gyaCuTWuRYWXrjHFqF6sC3E/bxtp7ONn1ULK18NJpkEefyiT7hHI1HAJEFPftuYzoVzk21dkg6HHTgxytRNCwzvl1oHlcQ1spmEC/nTTJPY/nCe3ugJos9UovNHrcKj1IJzAm4DNNDA3Bb5x+v0LkkXcyz67YlfxUgg61WSFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2I4/UkgZBzu+PNIhBrAcjSz0zSzNgNQiblOoWe3Monk=;
 b=ZKPPdFHP4u/cqgnFhW72stjz0+c0IuQpAtZ05YwLAgdP02rRTRKmpI0xtE9bQeAc3D3sMMV84oHlw1NM9UMQWqMnIU/hW4515Km5lV3GIsLPIzA1vH8MUCzkx7wnEB2X2xEGjVvZw1kq1BkNBJK1bVNd/UQ2AYkgeeXKEf5L008=
Received: from BN9PR03CA0122.namprd03.prod.outlook.com (2603:10b6:408:fe::7)
 by SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.26; Mon, 5 Jun
 2023 19:18:20 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::e8) by BN9PR03CA0122.outlook.office365.com
 (2603:10b6:408:fe::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 19:18:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:18:17 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:15 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 5 Jun 2023 14:18:14 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 3/6] sfc: add function to atomically update a rule in the MAE
Date: Mon, 5 Jun 2023 20:17:36 +0100
Message-ID: <d72046e44328bab1fcfb8c7154a9e7cfcc30b209.1685992503.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1685992503.git.ecree.xilinx@gmail.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|SA1PR12MB6870:EE_
X-MS-Office365-Filtering-Correlation-Id: 55dae5cf-5854-43c9-e842-08db65f99e41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k6k4CSAOkRL4V4GGyqS1o6rHDowNKH0kpZx05NSAv3ltFPOgqjH29tlypQwofRIRVTE1FVBrkosvfXXYuUpbluZydiHJwApv4ndNE6nOh6uyLzgswKOAUsy8OwimHAN/fqAH73dELnzIX43Osbbf6/RiOV/R4gyR20fuxJUPM32zwrbo1jZaFU+ssAvB0OQtfxV7eHiCS9IgzFmML1cte2+7J50off5bGoyihSLiOp+eeNyo1mOVHtw0BWOBoiPnD2/xuGYMBdWDQgzI/+AcEDbnqJ8WxeBihonx1PlS+1jUPsc4uSrp12U99DqXe5O8ywv+EcxouOUALNGlfo0fCZpr6IJPqtQX2ySRW8c8PGQ12OhWqE2PgozTgNxXlj9WOT815c/jQPGix8cEIKOg6BCogKPI4DRakm7CiL8zIhbszvwVIPCIrYEa9b63v98u57EZUvSlPVUxtlLM6VW9S55HSb6i0iaA9+NTOc0rE/f5Shaym5i1CSa8WEaUHA+OEAtMZkb7a3X9NVsbmFQodWP7j/SLYgVe7SoY0wfVfM08acCsJoB3fcRmM75PM+9eHklKlES7yXX1JGlTxSbS4buoWsg2R1XubN3FIeRvb1L5R8zMeeOHc3NTsxfJZtjGbGaibffGs/i9dxe16d2xCB8n/I3iduLIgMHxjLiUt71jt082OPC3obkesDk2YSgtPH5hLX9RU4QeF3ZwOgtA5kv9G3BFPoTQ7Yx52aNfkvB8C1oEVRNn9weTMGAGK5QECSyNiN8a7vr4mxN/+pvAoQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199021)(46966006)(40470700004)(36840700001)(8676002)(82310400005)(40480700001)(36860700001)(336012)(47076005)(83380400001)(426003)(8936002)(356005)(82740400003)(4326008)(81166007)(36756003)(2876002)(41300700001)(316002)(26005)(9686003)(70206006)(70586007)(6666004)(2906002)(40460700003)(478600001)(15650500001)(5660300002)(54906003)(110136005)(86362001)(55446002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:18:17.9126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55dae5cf-5854-43c9-e842-08db65f99e41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6870
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

efx_mae_update_rule() changes the action-set-list attached to an MAE
 flow rule in the Action Rule Table.
We will use this when neighbouring updates change encap actions.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 23 +++++++++++++++++++++++
 drivers/net/ethernet/sfc/mae.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 37a4c6925ad4..4eef5d18817a 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -1229,6 +1229,29 @@ int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
 	return 0;
 }
 
+int efx_mae_update_rule(struct efx_nic *efx, u32 acts_id, u32 id)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_RULE_UPDATE_IN_LEN);
+	MCDI_DECLARE_STRUCT_PTR(response);
+
+	BUILD_BUG_ON(MC_CMD_MAE_ACTION_RULE_UPDATE_OUT_LEN);
+	response = _MCDI_DWORD(inbuf, MAE_ACTION_RULE_UPDATE_IN_RESPONSE);
+
+	MCDI_SET_DWORD(inbuf, MAE_ACTION_RULE_UPDATE_IN_AR_ID, id);
+	if (efx_mae_asl_id(acts_id)) {
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_ASL_ID, acts_id);
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_AS_ID,
+				      MC_CMD_MAE_ACTION_SET_ALLOC_OUT_ACTION_SET_ID_NULL);
+	} else {
+		/* We only had one AS, so we didn't wrap it in an ASL */
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_ASL_ID,
+				      MC_CMD_MAE_ACTION_SET_LIST_ALLOC_OUT_ACTION_SET_LIST_ID_NULL);
+		MCDI_STRUCT_SET_DWORD(response, MAE_ACTION_RULE_RESPONSE_AS_ID, acts_id);
+	}
+	return efx_mcdi_rpc(efx, MC_CMD_MAE_ACTION_RULE_UPDATE, inbuf, sizeof(inbuf),
+			    NULL, 0, NULL);
+}
+
 int efx_mae_delete_rule(struct efx_nic *efx, u32 id)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_RULE_DELETE_OUT_LEN(1));
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index 1cf8dfeb0c28..c542aab43ea1 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -105,6 +105,7 @@ int efx_mae_unregister_encap_match(struct efx_nic *efx,
 
 int efx_mae_insert_rule(struct efx_nic *efx, const struct efx_tc_match *match,
 			u32 prio, u32 acts_id, u32 *id);
+int efx_mae_update_rule(struct efx_nic *efx, u32 acts_id, u32 id);
 int efx_mae_delete_rule(struct efx_nic *efx, u32 id);
 
 int efx_init_mae(struct efx_nic *efx);

