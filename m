Return-Path: <netdev+bounces-9287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4EAC7285AB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36FEC1C21007
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D5217FE4;
	Thu,  8 Jun 2023 16:45:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5385F19517
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:45:03 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6A730F5
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:44:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luMZ17NgeqVGKnfMTzK2BLWAw9xW6fcXS8EnlVOJrkN3PXIrD68hIYUPeBhsVSXnmY/BPBChhc8A4GNF+E84sz8ByAPsau1u8CuAEdQq6/02s77wNtu/BTbWWM6gvEunmNrsoagWTOUsPxVg+wepAyfZllntjtOP5DiCLQDBSWrAiLGsioUCN5vi7nMUJDRFusgf2NmmOT7wsKGtX3jCxRhixHkFzGvO5bptsPknlIoQcjnPGV1TrRj4SI+LnTNO+qNJhWD/eOTR47wE9gC8P2XiJik9bWwSCmge1MTrJgmtDgR6uJaln8d9Be5IKmITIyZGeObxUY4SLxcdp1+k7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVQu9BbSlaVl54KtFHOQ3YmeSTjgk+Dxfenbm4cnOKU=;
 b=aBxUmHlSe8XgRmsfxLGBi5Zi7zI9AgKCVlDfqIT+Jgv/Hu7vZ3teGOkrkbB07qpFjeIVq6T9/oDqSLDi1uDzh6G/mRdRKPO9HJT4oFMXBrAbxinZ9qRt/smDRtlK8e/Se/mVC4kirv+x4dQ5Efd908JJro0mvRJiWfcZyslj2y1BLgUU3WUO3LylViEVSBPD88xVSlClwt8de6SlM6TC8nqj36f9CkJsBQtex/ukPLqIc0RTweRtE7oSW195u9wVIjHL5jml4fmsBvBZP+WjtUk3iYbbrSCQkESXQ5jxtNjIIhsZlwyphU6DAmYfrvSc0QYx9xb8JyNKSUPKXj81zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVQu9BbSlaVl54KtFHOQ3YmeSTjgk+Dxfenbm4cnOKU=;
 b=4s785Z4zwK8vnqlXkBD814RQmoRtDt//j0brSOH7V/n0fwL/jyBxRgESCESEq+WOxMKXW1z7n8GOlAdNB9Ld9BzVW1ZSrxn2JcRk38nx8lXgs9Xr5asN6/f4i25xfroH3GRNF8vowiduKGxl6l9Wc0LC2BUNoCmwBHq7aZNMFkw=
Received: from CY5PR15CA0174.namprd15.prod.outlook.com (2603:10b6:930:81::12)
 by BL1PR12MB5077.namprd12.prod.outlook.com (2603:10b6:208:310::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Thu, 8 Jun
 2023 16:44:16 +0000
Received: from CY4PEPF0000E9CE.namprd03.prod.outlook.com
 (2603:10b6:930:81:cafe::48) by CY5PR15CA0174.outlook.office365.com
 (2603:10b6:930:81::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.26 via Frontend
 Transport; Thu, 8 Jun 2023 16:44:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9CE.mail.protection.outlook.com (10.167.241.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.13 via Frontend Transport; Thu, 8 Jun 2023 16:44:16 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Jun
 2023 11:44:15 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 8 Jun 2023 11:44:14 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>, Pieter Jansen van Vuuren
	<pieter.jansen-van-vuuren@amd.com>
Subject: [PATCH v2 net-next 3/6] sfc: add function to atomically update a rule in the MAE
Date: Thu, 8 Jun 2023 17:42:32 +0100
Message-ID: <d72046e44328bab1fcfb8c7154a9e7cfcc30b209.1686240142.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CE:EE_|BL1PR12MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 393e52df-225b-4a57-7493-08db683f9923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0Tb1YaWPzLilEpk8EIIc2AnXcy0Dq4RmYPGRRD1az0qx5PvHSTgsztCOMOMXIQtyMu1y+PlaWi3uqOujtv2VX9bgYQsV5tlJxefSD/JDU5pQfHN83GjyNJ5HTJ+jW6uBqZ5yQblEbSsfpqua2nJ31IiNbsX6H/cRaaUrxNk+Y09UcWuhgnabsNW+K8MqSjdmXB5uTAOXoLRxro4Dzxjn4u7COwKlvUNLIJANP/pHEyXp5r9xKggoiv8VwF+8SKUt9TeCTU5Y2Hb8dAan9JgcJyYIp6j2IOLrMDUIcaelfd/DQnW9O7GZs1M6j/uL24Aqe3VFt1/sbQ5fZdYqbzxCZMylO6npgygeZxTcPt+VK+0/TYI4uWwhvbidb//5GAwbi5R4gLweVtWG9H8NstWpO5yqhY7tVKLNT47YGPPIkVr+OzsYCYJCSsSCqse7a3z77tnVWGhfmMkNTkwg19kIo2pnAznsKYsLJ2jqmSFOWVFaWkQqMKNWx8TFw3NJaeVouf/rYvVnsCTuU5FMY4EI9tSqAUKFnloWIF6Tb0ZaCbhlvsLAztWW6j8nOE5xcppNz+4lgce/UPiGuTEO6JM2t42v5z8GpQYNv6+rWTG6ZC9AxUWNQnyQnFIBih3NBzZy8ql7IX7LY9hx2zabX9Zymvm/aexodqp1XJSq5RYD/oK5nCS23+xXeneNFIrJ5dF0YNB/av/QYiu330Jl4RXFUHTFP3jAWlB+FajdP7H/H34OCpkVHlkhRqyCkJJqjoyE3VMlvV0QHof6Ka02JEpmZg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(376002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(55446002)(86362001)(2876002)(2906002)(82310400005)(36756003)(15650500001)(40480700001)(47076005)(6666004)(83380400001)(426003)(186003)(36860700001)(26005)(9686003)(336012)(81166007)(82740400003)(478600001)(40460700003)(110136005)(54906003)(70586007)(70206006)(316002)(8936002)(4326008)(8676002)(41300700001)(356005)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 16:44:16.3429
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 393e52df-225b-4a57-7493-08db683f9923
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5077
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

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
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

