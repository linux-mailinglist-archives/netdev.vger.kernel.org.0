Return-Path: <netdev+bounces-8176-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A50D722F9C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 337B7280FC8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D18F24140;
	Mon,  5 Jun 2023 19:19:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B474DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:19:20 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::609])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641CD10B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:18:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uqv/2H56LgtEM/bfaGACZ6YBkkculfJkXChtmmN+O8nSk0XvkrDmvwng9Y4jQVeaeNWvym76E6J7GzR8RRpGAixDf4qV/cWS9J+hI/Y5j/NpOsjrVX1qnd5dre+WrZ2NlH2DxAB34ZdMJcP6lCbDpUPggeTp40a8Y929IJva9U/LicUzsdeD/MiYB86gbmq7C/vZ8NYmU4ZYx0qkjCaMuIbXcW+rbmSs8l2z8Uk7aGPK47ORQsz52NrCTaIa7c6ndNR+1x2ysKFGL6zzlB7GDCNEJkYEeLgXzRkRY5LjsK3nqDlP9a9XhTaiSbmEQpMJyYd78lsQVih7A4N5WTGvdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73Imw7gMxz+NAg0Ah5LkSxSLLaq+8n/YvAEL5yB+zJ4=;
 b=IqWJtj4GH52BrJ71mhSC3zvg0fGzJilsezpTTuwszHUMRUj6PVa7KWGtleMrZwmmhT6LINLYb+nzdSRNMGShdSFAP/hZBwUo8FR3/hiVixYvVQoWcT/dL5byS8AwfMv0sJnoODMC0ZoQYHnPmiE+6KeKXgXWskpYx1+obtrkyoDmKK7VNA9tCHBjfwZs0oyccAwH5FOSWLcPMh+zM5hqE7R/qH0fWHsle93iANRYM0kyqIHNR0qCXrTAz6+tiFb8brmVpX2A9Ekgf2q4UjLXeLrIHYzGWz9utAGr2Re27zxz89KCxvKbUlK7YSyYmAfb9vks56ob1faRomZAX1mnJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73Imw7gMxz+NAg0Ah5LkSxSLLaq+8n/YvAEL5yB+zJ4=;
 b=I3Z5JhS1fBJU2dSWyvMkKDXFiAOz1jVye9q1rLKERSw9qiOTyaVbMQFZcJTzPy4aaRt0gvBUHmd3lDzsALnU9AXEbxAS/lo9tpEgikXkoPXnGJcpEEIM5f0H9ybVSnGMr9FZRF2J39CtsAGERYV3Zx3OqvCEYcWHJJHQCIOoK98=
Received: from BN8PR15CA0072.namprd15.prod.outlook.com (2603:10b6:408:80::49)
 by DS0PR12MB6535.namprd12.prod.outlook.com (2603:10b6:8:c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 19:18:20 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::6e) by BN8PR15CA0072.outlook.office365.com
 (2603:10b6:408:80::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32 via Frontend
 Transport; Mon, 5 Jun 2023 19:18:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:18:20 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:16 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 5 Jun 2023 14:18:15 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 4/6] sfc: MAE functions to create/update/delete encap headers
Date: Mon, 5 Jun 2023 20:17:37 +0100
Message-ID: <ec28374eb94989fba657207c6373126bc25cc5b7.1685992503.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|DS0PR12MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: ac889a56-7b4d-4aac-7e50-08db65f99fe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8GyjSWrG9VVytAa1CW2sAGBylMsSG5qdd7WQsUw1Up//kvqu9ZWE+mkAHgjRctegaobl+fYfHjnoosoo2Hyj63EC2m1n7xgwEkLvRYdoVCZ6Gjs3imFzlsmgoXKrHyXm95nrK5WE2KWeKGESRg3bpnew3ExIOyjnIVMxSfNF7t0NdKcwHx8aKxNWP+7RthaCjyu9NfnNXAk6jaZwFkfec33GBJg2oKncYm42mdeaxE87u3vAVlgn4IdC9RKGfosy7InzOiSieC2ZwAahD1DfmRdm3ouD6iF2yBWCD+wzFBgwNRWP+Wy0NuDTiRrAuIUwN//ugDs9e0Ls17khgcR3mLmqi64nQcK+SCSqNheALMDq1MnxwAldDCPn1/vILOGlRrSm8XYEV6aEyra6aEtrnS9t1423vzOk9VNuzVdElT3iH3s9mAcK4Hsq9uzMVbhB6F9tQQRD9qEFV/X0wWoCBzzlQEw7gdGLskG7/s4YrRnqn2vh4fvHCocto2ko+RcvAsRUNU5QEWRJC9m+gs9uE3B54v5wJp+ZFHbLgZw0o2j4LVvIDhAlXQhx6YZ6aHUdqxSa76VSlXbxeH2so2Aup9Dr3nZb/Zfo95OsKeYylcj+1523F/e6xkJl6G7KU8U7c4WoJakEAcrtrAnQmtqq4mEQLYwkqdjjT91FGzAu09gKL8dvyYjfC/TnvQTgoGG2FSR+D3uLpTo8xycv/L4VNBzqXppHNdWPW5H7wXsklz43/l8ESGrmQO7KwojaQsOabLBRG17u5SyUwZCDKbS9VQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(83380400001)(40460700003)(47076005)(336012)(426003)(2906002)(2876002)(36756003)(86362001)(55446002)(82310400005)(81166007)(356005)(82740400003)(36860700001)(40480700001)(316002)(41300700001)(6666004)(5660300002)(8936002)(8676002)(54906003)(110136005)(478600001)(4326008)(70206006)(70586007)(9686003)(26005)(15650500001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:18:20.6624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac889a56-7b4d-4aac-7e50-08db65f99fe5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6535
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Besides the raw header data, also pass the tunnel type, so that the
 hardware knows it needs to update the IP Total Length and UDP Length
 fields (and corresponding checksums) for each packet.
Also, populate the ENCAP_HEADER_ID field in efx_mae_alloc_action_set()
 with the fw_id returned from efx_mae_allocate_encap_md().

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/mae.c | 90 +++++++++++++++++++++++++++++++++-
 drivers/net/ethernet/sfc/mae.h |  7 +++
 2 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 4eef5d18817a..0cab508f2f9d 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -15,6 +15,7 @@
 #include "mcdi.h"
 #include "mcdi_pcol.h"
 #include "mcdi_pcol_mae.h"
+#include "tc_encap_actions.h"
 
 int efx_mae_allocate_mport(struct efx_nic *efx, u32 *id, u32 *label)
 {
@@ -610,6 +611,87 @@ static int efx_mae_encap_type_to_mae_type(enum efx_encap_type type)
 	}
 }
 
+int efx_mae_allocate_encap_md(struct efx_nic *efx,
+			      struct efx_tc_encap_action *encap)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ENCAP_HEADER_ALLOC_IN_LEN(EFX_TC_MAX_ENCAP_HDR));
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_LEN);
+	size_t inlen, outlen;
+	int rc;
+
+	rc = efx_mae_encap_type_to_mae_type(encap->type);
+	if (rc < 0)
+		return rc;
+	MCDI_SET_DWORD(inbuf, MAE_ENCAP_HEADER_ALLOC_IN_ENCAP_TYPE, rc);
+	inlen = MC_CMD_MAE_ENCAP_HEADER_ALLOC_IN_LEN(encap->encap_hdr_len);
+	if (WARN_ON(inlen > sizeof(inbuf))) /* can't happen */
+		return -EINVAL;
+	memcpy(MCDI_PTR(inbuf, MAE_ENCAP_HEADER_ALLOC_IN_HDR_DATA),
+	       encap->encap_hdr,
+	       encap->encap_hdr_len);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ENCAP_HEADER_ALLOC, inbuf,
+			  inlen, outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	encap->fw_id = MCDI_DWORD(outbuf, MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID);
+	return 0;
+}
+
+int efx_mae_update_encap_md(struct efx_nic *efx,
+			    struct efx_tc_encap_action *encap)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ENCAP_HEADER_UPDATE_IN_LEN(EFX_TC_MAX_ENCAP_HDR));
+	size_t inlen;
+	int rc;
+
+	rc = efx_mae_encap_type_to_mae_type(encap->type);
+	if (rc < 0)
+		return rc;
+	MCDI_SET_DWORD(inbuf, MAE_ENCAP_HEADER_UPDATE_IN_ENCAP_TYPE, rc);
+	MCDI_SET_DWORD(inbuf, MAE_ENCAP_HEADER_UPDATE_IN_EH_ID,
+		       encap->fw_id);
+	inlen = MC_CMD_MAE_ENCAP_HEADER_UPDATE_IN_LEN(encap->encap_hdr_len);
+	if (WARN_ON(inlen > sizeof(inbuf))) /* can't happen */
+		return -EINVAL;
+	memcpy(MCDI_PTR(inbuf, MAE_ENCAP_HEADER_UPDATE_IN_HDR_DATA),
+	       encap->encap_hdr,
+	       encap->encap_hdr_len);
+
+	BUILD_BUG_ON(MC_CMD_MAE_ENCAP_HEADER_UPDATE_OUT_LEN != 0);
+	return efx_mcdi_rpc(efx, MC_CMD_MAE_ENCAP_HEADER_UPDATE, inbuf,
+			    inlen, NULL, 0, NULL);
+}
+
+int efx_mae_free_encap_md(struct efx_nic *efx,
+			  struct efx_tc_encap_action *encap)
+{
+	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ENCAP_HEADER_FREE_OUT_LEN(1));
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ENCAP_HEADER_FREE_IN_LEN(1));
+	size_t outlen;
+	int rc;
+
+	MCDI_SET_DWORD(inbuf, MAE_ENCAP_HEADER_FREE_IN_EH_ID, encap->fw_id);
+	rc = efx_mcdi_rpc(efx, MC_CMD_MAE_ENCAP_HEADER_FREE, inbuf,
+			  sizeof(inbuf), outbuf, sizeof(outbuf), &outlen);
+	if (rc)
+		return rc;
+	if (outlen < sizeof(outbuf))
+		return -EIO;
+	/* FW freed a different ID than we asked for, should also never happen.
+	 * Warn because it means we've now got a different idea to the FW of
+	 * what encap_mds exist, which could cause mayhem later.
+	 */
+	if (WARN_ON(MCDI_DWORD(outbuf, MAE_ENCAP_HEADER_FREE_OUT_FREED_EH_ID) != encap->fw_id))
+		return -EIO;
+	/* We're probably about to free @encap, but let's just make sure its
+	 * fw_id is blatted so that it won't look valid if it leaks out.
+	 */
+	encap->fw_id = MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL;
+	return 0;
+}
+
 int efx_mae_lookup_mport(struct efx_nic *efx, u32 vf_idx, u32 *id)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
@@ -833,8 +915,12 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
 		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_PROTO_BE,
 				 act->vlan_proto[1]);
 	}
-	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
-		       MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL);
+	if (act->encap_md)
+		MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
+			       act->encap_md->fw_id);
+	else
+		MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
+			       MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL);
 	if (act->deliver)
 		MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DELIVER,
 			       act->dest_mport);
diff --git a/drivers/net/ethernet/sfc/mae.h b/drivers/net/ethernet/sfc/mae.h
index c542aab43ea1..24abfe509690 100644
--- a/drivers/net/ethernet/sfc/mae.h
+++ b/drivers/net/ethernet/sfc/mae.h
@@ -90,6 +90,13 @@ int efx_mae_check_encap_type_supported(struct efx_nic *efx,
 int efx_mae_allocate_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
 int efx_mae_free_counter(struct efx_nic *efx, struct efx_tc_counter *cnt);
 
+int efx_mae_allocate_encap_md(struct efx_nic *efx,
+			      struct efx_tc_encap_action *encap);
+int efx_mae_update_encap_md(struct efx_nic *efx,
+			    struct efx_tc_encap_action *encap);
+int efx_mae_free_encap_md(struct efx_nic *efx,
+			  struct efx_tc_encap_action *encap);
+
 int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act);
 int efx_mae_free_action_set(struct efx_nic *efx, u32 fw_id);
 

