Return-Path: <netdev+bounces-9290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0FD7285B2
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9FC8280D34
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B2AC19912;
	Thu,  8 Jun 2023 16:45:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091F019E5B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:45:10 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B842D59
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OViWSoK6tLmLy23G2z+anxmy4+doaGvL2hHNbTQIAyPIRrML/8ZU4np5sP5GQkuocCzdmYRdv7uymKAfLVCgHQb5x/ltvUifxoaiBTvufRubkv9hreF996zTfC+Yz1s7fcTFcfblgHtvA+Qdq1nULlMBbGpNAyITQ0OiBz12Inl8hhVPtZjN0Y1p2kmNfKNLhPDRxHXXErYTesMpvfANZm06d0AhL1rYJiSKs9dSrjxKPXIwaueVvQhasusmUM/p+PjATd0UENpcd9Rk3gD3+7pBS8sOtqKxs0NQGiKQ4mGylj22t9PspIw94JvG4hQXnyTMANx60YMscqgKm1Pbew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVD/p/n01EcqeeccM99fy69VJy7iUROpSA3bsMMOp6c=;
 b=Mhh9N/Lag5z4Qjq2wJLcmnxvx08jkk84Jc0bXLckk7r9HwPGXS2ui+//6N8HcZYgiHRHaCXHEqoMW013K5zhC5+pTC4KtDAsmtffP0A8yJCnpiSHZaF08RkskiIpRNaV18TZ5F8/M6yG7oMaQo9rCwikOrKNGGqLTDuIu0Jpqkjb67Z0KCfqbjMSqGILTa/WIGzYwR8G4ZMMKcMOHSJUjieVOXGqUR8F4HDfn17oA8uevYep9kW8DccjKV11JtDXEfGgz38UaNSjQI21GtcF1v8GRDJh2HLoV0a/xpJllSWrN2+0+nnkGPCC/sxExOr6MbxTcP1a1m29uhDzBlXrqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVD/p/n01EcqeeccM99fy69VJy7iUROpSA3bsMMOp6c=;
 b=AealQeZxfoz9lahdoUVwogPrbWsPQUbY0Vj4/mrdm8D7OqylDJbcXofkkPZwxRQWrYnBzrh8eF6ODx1Vdj24r9JtIr6uWoSofv5yqFHDOUeNH2N4E3YpZhkuV3CnxMQmjE7ft/5nmZcjh8MsiN6lxjz6z1Rbzl0g51UbdJVUZJ4=
Received: from CY8PR11CA0017.namprd11.prod.outlook.com (2603:10b6:930:48::26)
 by SJ2PR12MB8184.namprd12.prod.outlook.com (2603:10b6:a03:4f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Thu, 8 Jun
 2023 16:44:18 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:930:48:cafe::ee) by CY8PR11CA0017.outlook.office365.com
 (2603:10b6:930:48::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.26 via Frontend
 Transport; Thu, 8 Jun 2023 16:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.13 via Frontend Transport; Thu, 8 Jun 2023 16:44:17 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Jun
 2023 11:44:17 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Jun
 2023 11:44:16 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 8 Jun 2023 11:44:15 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>, Pieter Jansen van Vuuren
	<pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH v2 net-next 4/6] sfc: MAE functions to create/update/delete encap headers
Date: Thu, 8 Jun 2023 17:42:33 +0100
Message-ID: <ec28374eb94989fba657207c6373126bc25cc5b7.1686240142.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1686240142.git.ecree.xilinx@gmail.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|SJ2PR12MB8184:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b898a3b-15fa-4f99-f388-08db683f9a14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8zTqoUrJwlfIKkKjWmm0nkJl/NrLsyN74eQB9TKTTKPF2mtGmfb0bEgJDRjNBszvdcBHXtBStO0JTgav7wH+VbRgteY3p35kZeTEVhhxyvcf7SUA9c+m8uWX6LnTro0pg+RlKj8LLazZB1dCCaR7niZL1Wjw/MBM8NB6zXZqQC3FtG/1C1y41BInUBFj65RtiiPUI0bggnrGQBoP9yi7XBdXoCETG2KjjbLy1mHjtcG41LW16z79DmMMAg596R1KZLowubdLlecM3nyFCFr59aaGSNs8H3fHI2hgU90Mu/qDnFxbwhcw9IE8oWeR3OJz9+FCtsCFwzMfFAAnCaIdZ+YfO+cO9c5G2UrODYYNr6g9h9SXWB9xH0CwXzb1evg9KbupA55zUJWJcxvVb3K/BLuHbKcP/rJ/BSOXslKyrgiHXFz+MG/d+UcJDxtwE7VO0htosYRszW0UGl1rxunr7hX8KS6o5lVLTwxbLhPPRfHdej5JPCazlKfFx6THR9IBc+dqFQufPDmNXpO34KsHaHSJCJ61XG438MBDpNQpAoOJEBxfXgvQXSQ5PFYS+32ZXiWrtl5pZrID+WzuKYN4dj6mwqyEhf9oBl8NEzy3952IwqnqUcyjiqQK1YqraqnaYsf/QCbIcQUBR4XSSejfqITNmkOYi4qcSrcYsHZKWRqLhT+RICAbxneK+qOydNQBpLqGEU5f2ii5yBdyU7ztgka80h5m0v6lsBz/ncePSfvhk96pfN4UtrGy+cGNita8wHdfNF5AjRKY8Y8SNrnXOg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(46966006)(40470700004)(36840700001)(54906003)(110136005)(82740400003)(40460700003)(4326008)(478600001)(40480700001)(5660300002)(8936002)(36756003)(55446002)(15650500001)(2876002)(8676002)(86362001)(2906002)(81166007)(82310400005)(70206006)(70586007)(316002)(356005)(41300700001)(26005)(186003)(47076005)(36860700001)(9686003)(6666004)(426003)(83380400001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 16:44:17.9256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b898a3b-15fa-4f99-f388-08db683f9a14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8184
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Besides the raw header data, also pass the tunnel type, so that the
 hardware knows it needs to update the IP Total Length and UDP Length
 fields (and corresponding checksums) for each packet.
Also, populate the ENCAP_HEADER_ID field in efx_mae_alloc_action_set()
 with the fw_id returned from efx_mae_allocate_encap_md().

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
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
 

