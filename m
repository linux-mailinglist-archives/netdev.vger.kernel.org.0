Return-Path: <netdev+bounces-7529-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B883720913
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 20:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAB421C211C4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522D81D2D6;
	Fri,  2 Jun 2023 18:25:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEAB156D2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 18:25:03 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D71123
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 11:25:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/8rkGDdYmMWI+5YjD3SjCCW4WGQ80ayGnHYgQIovatsBc+yka7DtnIgdIHJ3EzgSiD3+dFCjdloy3venj/UGBSc6/X7ElhS6oOrtxTo4rwUPtqXRZdGc53x0K61aFJ2IpDxDCtUfPFK2WCXrdLUGQ7greDsypEOvNYX9fksBmGMEnMLpd0aB9cvPqJ2xUVBjweGmq4sTq6jW7dJ1icJeRxIKEVoUpFygO4oTKObK5BuGVGB7Nz6m6+yOBgQji/CohPWYTAiReAR6JuUub/HmGG/cjZQFUuZS9zgaxsVpA2Iwb61ib7jBfqVf0mk+vxlLFUkB37xEVNULXPe1HS23g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5wpVcBmE5+PN6fkcvsY8/aZoyg0ldpaVsT9dOYwnVo=;
 b=dq7DZWvh+wFFPbr4J+FiVmwruKW71zNEj8nDCSIqDO6NX8u2Ro9PFE9jNVs+Fk3UkWn2zBF8qF2XryLrww4o9bm+VEPLREDj4aonWdGrgDhYha0o4f6yypt4xYTdU7BqpgNXgEjg4wTg/F98t958li+8utKg1zvG1fvVBmWwnQ6nlKVU8vrWyUg7ryrzYv8NcaARx8Z2Qu9l7E/4F1CDnqSSO3zggNYukRqu/2B/bGDjZZwpKT7XMKYeKe7UyBX6Argu2K1Bw3GnfdYqmcovHNXY3yJRGXnIQBIQxLKfH7oJfHyegQLLJguCBfSUZlsA3KUpjhIwvwwvaWpWlm0tZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5wpVcBmE5+PN6fkcvsY8/aZoyg0ldpaVsT9dOYwnVo=;
 b=sFJ2BW96ra8Rqwxeu0W339RQnUQmKks/Xz+/s+Om39b4r6XuXwCk8yRfxBpg9tfi4+3vP7941+Fnp6ECNVRViiJvmgP3y6RA+tekD6GXs1blnhHXOVGz00B51GoXVwiVeWBQp1KuMgtwlW2cXSPouJ639U94vC96Frg0AzXW1wAMq56UgPjVlDnQfEwfg0TCxOKrIO3KU7pPJONed768xWDe6BbMvOnW9mPK8c/51PFDeZSX2zzZyL93IqF11j9KIozRrzpzaqebJ2WuJkZYz2wLBbcNzgpfiMeBL6aTThMZNTGTi6MZb6xSlkq0gFcJ1hLfJKjn8mkottEidbDNNg==
Received: from DM6PR01CA0005.prod.exchangelabs.com (2603:10b6:5:296::10) by
 DS7PR12MB5863.namprd12.prod.outlook.com (2603:10b6:8:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.24; Fri, 2 Jun 2023 18:24:57 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::62) by DM6PR01CA0005.outlook.office365.com
 (2603:10b6:5:296::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 18:24:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.26 via Frontend Transport; Fri, 2 Jun 2023 18:24:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 11:24:47 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 2 Jun 2023 11:24:47 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 2 Jun 2023 11:24:45 -0700
From: Asmaa Mnebhi <asmaa@nvidia.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
CC: Asmaa Mnebhi <asmaa@nvidia.com>, <netdev@vger.kernel.org>,
	<cai.huoqing@linux.dev>, <brgl@bgdev.pl>, <chenhao288@hisilicon.com>,
	<huangguangbin2@huawei.com>, David Thompson <davthompson@nvidia.com>
Subject: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at shutdown
Date: Fri, 2 Jun 2023 14:24:43 -0400
Message-ID: <20230602182443.25514-1-asmaa@nvidia.com>
X-Mailer: git-send-email 2.30.1
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT068:EE_|DS7PR12MB5863:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ac51150-2da5-4811-0619-08db6396ab37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lr+IlD3MrKuB5JC2RfES6N0n1G6MdQ/7/D3nxPy5IXdg91nyPtrZZGp6GxHUhFDjTn8/h3aJT0ol3L8hSEKPkZip1Vq9hRO6xb6SAmbifyrk9ycCCqo7M4BHyZq2NIXv08WTzPvUZk+LpF/y6Jqlw2UiP+u0DHcEaaSSX2GAUApqMd/m/kWycNbrKh0FwQE1hIDBphIL0NOAg3odyoXvguKp0AzMq4KG0vVsowH1Rq1gH6B3cZbgvN3TLokIanK5ahiU8C6tde9ZtLF4SDEFtlP+OC3j9t3G7sMiofoRxfzTd043e659X3+E/l70dqgyndCJIe5rgcdaSS0tOdXGFQSwlfKtv6mo8IEFk7jbhJ0Tbjy43o0w/LKUFbTFhUiP59nT7f/U4iFUDAqA40WcMaDN3Z/HEJgtZ+9DTA7jL6vmRDhkundPGx6ABbBv7ZTwRjsKkoT9cK0f1oy6S+c44dwaCaYY6EjtrAAcclbNner1FyHt9Z4Ltx/MvXdS2xjlXJaT3KcR+V7K3bKYkFAE2QgSBjCQfLrs4Hz6h3vaRhGJYPk/54HIXOjzcJlmiIIV9PeeUFE9GlceSOOGKN3UDMzOkBqquNNaU9CfAksJZYSrGVoCl+ZZBjCPeY5WoFR64ytuPSqD70f+s6u0uM8IMj0AXsYPpWPlbW2yfXPHqrFuaMxXPWQ56dLeRa4ukZao2L+ULEBpiJ70ZpvmOVrYCZADuT1nNSOyrFSqy2zZCfNSym9OKLwmHNrqVWmDWims
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(86362001)(5660300002)(8936002)(2906002)(316002)(82310400005)(82740400003)(4326008)(356005)(7636003)(70586007)(70206006)(8676002)(54906003)(110136005)(47076005)(478600001)(36860700001)(41300700001)(40460700003)(186003)(40480700001)(2616005)(107886003)(7696005)(83380400001)(426003)(336012)(36756003)(26005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 18:24:57.0561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac51150-2da5-4811-0619-08db6396ab37
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5863
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

There is a race condition happening during shutdown due to pending napi transactions.
Since mlxbf_gige_poll is still running, it tries to access a NULL pointer and as a
result causes a kernel panic.
To fix this during shutdown, invoke mlxbf_gige_remove to disable and dequeue napi.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 694de9513b9f..7017f14595db 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -485,10 +485,7 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
 
 static void mlxbf_gige_shutdown(struct platform_device *pdev)
 {
-	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
-
-	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
-	mlxbf_gige_clean_port(priv);
+	mlxbf_gige_remove(pdev);
 }
 
 static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[] = {
-- 
2.30.1


