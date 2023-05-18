Return-Path: <netdev+bounces-3508-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2B737079CE
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1AFB1C21011
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854B9138E;
	Thu, 18 May 2023 05:48:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF4F137D
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 05:48:59 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9401C1721;
	Wed, 17 May 2023 22:48:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhVUaVojghzZBKZFIMu8HrHkwt+N9vgvEhXxVugXBQeD1HC208kYHLy0ens/J+w9m4EJyDGLdd7z6zdsnCdktzWhxlVdj5b30bw9ZDk1pOT9TXxuXqJpz3aUwBUFd4LMr1XfTeEHUDV79gNkFV11foYegn5GOvEVL11QUqnnXz1xZYchzqaRV1w73wvyPcajfulJJD+jqwwReOujcT4YJUgeHPOxlBMbhF2ciK2Tnc8nr5D+PLICyAHSoFouUB7kBBFO3SFFOdSTHKBDbbl47cZYt73Cpd1wIB+aubxU6b/q7PR8SChSq7qN0b/VNo+F0+xgvqBODykvI+BnTnkWVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uP8Aev+gMBcJF8nbYQIyLgLTxjWnvh55/t4jh0rTaEw=;
 b=BNaeI3+t6UixIVmDLetXhHAt4hBJm4jYwOIJU9BXmkfP9fuE+cZ4CHkZEy9F4hHIU3DOInpOBF/5liNuBj0hDtNEX7tZs3DyuIi8ijZD95vbs238e/hwyoFA7nZ6SNAlPBjq0ZRcCaN06hOoLbU8DsIuq2VauIAA3p599FsZ2rob1ZVHGIrY4BAxXBYnvwGIL3XiNQX7DK4zuOMnWrqzfTHuevyW4BiRMs0f7lSYxfdBkLyYtHrHHLWxkRnsLj+IPCnD1W9GjbXGohMLb+IO8nGyFeBoW+ZDbjXAigFtKh3wzcI0uSm2FMyouAbWQmUnG49NeBJTur7zl0osz8l0jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uP8Aev+gMBcJF8nbYQIyLgLTxjWnvh55/t4jh0rTaEw=;
 b=OAQYt/2jOvmF+8SgIS2xs6AWYHVeCIYICe/m6ZPL0qATfyaMOh/10PHOI01Ty/quyIisah/BFPdNmsYveaOzkMQPtxJVWCBjzAxO+Y5CYr1HLoGyQTQh0MgJFs0YXKEqMWMjyVoqzOlIuvZOWsL96Yza//3BcFA7yGyOF0biOBQ=
Received: from BN9PR03CA0113.namprd03.prod.outlook.com (2603:10b6:408:fd::28)
 by PH7PR12MB6564.namprd12.prod.outlook.com (2603:10b6:510:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 05:48:54 +0000
Received: from BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::4) by BN9PR03CA0113.outlook.office365.com
 (2603:10b6:408:fd::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.18 via Frontend
 Transport; Thu, 18 May 2023 05:48:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT103.mail.protection.outlook.com (10.13.176.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.19 via Frontend Transport; Thu, 18 May 2023 05:48:54 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 18 May
 2023 00:48:53 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 17 May
 2023 22:48:53 -0700
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 18 May 2023 00:48:51 -0500
From: <alejandro.lucero-palau@amd.com>
To: <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <martin.habets@amd.com>, <edward.cree@amd.com>,
	<linux-doc@vger.kernel.org>, <corbet@lwn.net>, <jiri@nvidia.com>, "Alejandro
 Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH net] sfc: fix devlink info error handling
Date: Thu, 18 May 2023 06:48:22 +0100
Message-ID: <20230518054822.20242-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT103:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 61008f14-8dc6-41d7-20ed-08db576390e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U7B8znOtgbS7QiRs4NXKbObTmOStgGWa2KIdb5QO6CqhcUdGxfCa+ndiuadxyOfmSsq0Lt/NAwOmM2mg3i1jCmSNew5+PXqf4dTeolmx5KqsJg0U/576zeh5OArf4wLpgkzqXqNaArDSXz0ZPRRNAsau/FrQF8hbXEGYeJLpR/uMjlM4pI7wrmnV1ZPLbq24E3dZ3CGOAB+nTpyX2WpSx+1cgbA4sadU5N392qlJBB5kqdv+aJOjxB8aUBvaky6XqBmEoD5vsU52AjVvBtxzxkt+3urzH2CCtKAXmBgi16VZ9uIUS3P1cxAB51JQUcZFxN5ccpdR4M30kC7hPvVzRTjPWCStVEWcbTesQOOVPvE+fQ2GZUxjn4zxX8m/q3R83GgYEFhYBM41muQdk/vZr/EbLStoR07WaYc84gOhoiFINjzB++9Lxrnewzjcih4qVVquhEJpv/ARKwKVbWKs7XJiIxu9IRa3vK4ya2dAjTxtpaJYCePaLmgY5H0AoxSlZ6+7rNPTgFIXC+LMieKzSeOeWI86qfgncGouhMdrGM190xU3zOCfnRTmK1MXB+q3FTEoY1TLQE4XTYdoO2XsUyLp2ZN0WT2p7wVa5BClNOq62c/VctyUKkO6JnLl057JQv4I/ZP1okJ9fUg4OCfnuuAJ9QT/B4vcQ0kJ+TW/3TNzUoi1Fdp+AJ3oueQKsSXZGgsBZK2PgXLB1/eqayyBiAfmoyr8rjjD9u1Ue9Ogd9rIfT3tkWpbwqsI4WeReYCeS4BoxQD83QKjn1l/gGkY9w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199021)(40470700004)(46966006)(36840700001)(40460700003)(70206006)(316002)(6636002)(478600001)(70586007)(4326008)(54906003)(110136005)(36756003)(86362001)(47076005)(83380400001)(1076003)(426003)(36860700001)(186003)(26005)(2616005)(8936002)(2906002)(5660300002)(8676002)(2876002)(40480700001)(6666004)(336012)(82310400005)(356005)(82740400003)(81166007)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 05:48:54.7164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61008f14-8dc6-41d7-20ed-08db576390e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Avoid early devlink info return if errors arise with MCDI commands
executed for getting the required info from the device. The rationale
is some commands can fail but later ones could still give useful data.
Moreover, some nvram partitions could not be present which needs to be
handled as a non error.

The specific errors are reported through system messages and if any
error appears, it will be reported generically through extack.

Fixes 14743ddd2495 (sfc: add devlink info support for ef100)
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 95 ++++++++++++--------------
 1 file changed, 45 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index 381b805659d3..ef9971cbb695 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -171,9 +171,14 @@ static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 
 	rc = efx_mcdi_nvram_metadata(efx, partition_type, NULL, version, NULL,
 				     0);
+
+	/* If the partition does not exist, that is not an error. */
+	if (rc == -ENOENT)
+		return 0;
+
 	if (rc) {
-		netif_err(efx, drv, efx->net_dev, "mcdi nvram %s: failed\n",
-			  version_name);
+		netif_err(efx, drv, efx->net_dev, "mcdi nvram %s: failed (rc=%d)\n",
+			  version_name, rc);
 		return rc;
 	}
 
@@ -187,36 +192,33 @@ static int efx_devlink_info_nvram_partition(struct efx_nic *efx,
 static int efx_devlink_info_stored_versions(struct efx_nic *efx,
 					    struct devlink_info_req *req)
 {
-	int rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_BUNDLE,
-					      DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
-	if (rc)
-		return rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_MC_FIRMWARE,
-					      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
-	if (rc)
-		return rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
-					      EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
-	if (rc)
-		return rc;
-
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_EXPANSION_ROM,
-					      EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
-	if (rc)
-		return rc;
+	int err;
 
-	rc = efx_devlink_info_nvram_partition(efx, req,
-					      NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
-					      EFX_DEVLINK_INFO_VERSION_FW_UEFI);
-	return rc;
+	/* We do not care here about the specific error but just if an error
+	 * happened. The specific error will be reported inside the call
+	 * through system messages, and if any error happened in any call
+	 * below, we report it through extack.
+	 */
+	err = efx_devlink_info_nvram_partition(efx, req,
+					       NVRAM_PARTITION_TYPE_BUNDLE,
+					       DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_MC_FIRMWARE,
+						DEVLINK_INFO_VERSION_GENERIC_FW_MGMT);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_SUC_FIRMWARE,
+						EFX_DEVLINK_INFO_VERSION_FW_MGMT_SUC);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_EXPANSION_ROM,
+						EFX_DEVLINK_INFO_VERSION_FW_EXPROM);
+
+	err |= efx_devlink_info_nvram_partition(efx, req,
+						NVRAM_PARTITION_TYPE_EXPANSION_UEFI,
+						EFX_DEVLINK_INFO_VERSION_FW_UEFI);
+	return err;
 }
 
 #define EFX_VER_FLAG(_f)	\
@@ -587,27 +589,20 @@ static int efx_devlink_info_get(struct devlink *devlink,
 {
 	struct efx_devlink *devlink_private = devlink_priv(devlink);
 	struct efx_nic *efx = devlink_private->efx;
-	int rc;
+	int err;
 
-	/* Several different MCDI commands are used. We report first error
-	 * through extack returning at that point. Specific error
-	 * information via system messages.
+	/* Several different MCDI commands are used. We report if errors
+	 * happened through extack. Specific error information via system
+	 * messages inside the calls.
 	 */
-	rc = efx_devlink_info_board_cfg(efx, req);
-	if (rc) {
-		NL_SET_ERR_MSG_MOD(extack, "Getting board info failed");
-		return rc;
-	}
-	rc = efx_devlink_info_stored_versions(efx, req);
-	if (rc) {
-		NL_SET_ERR_MSG_MOD(extack, "Getting stored versions failed");
-		return rc;
-	}
-	rc = efx_devlink_info_running_versions(efx, req);
-	if (rc) {
-		NL_SET_ERR_MSG_MOD(extack, "Getting running versions failed");
-		return rc;
-	}
+	err = efx_devlink_info_board_cfg(efx, req);
+
+	err |= efx_devlink_info_stored_versions(efx, req);
+
+	err |= efx_devlink_info_running_versions(efx, req);
+
+	if (err)
+		NL_SET_ERR_MSG_MOD(extack, "Errors when getting device info. Check system messages");
 
 	return 0;
 }
-- 
2.17.1


