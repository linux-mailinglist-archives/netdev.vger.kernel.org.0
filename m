Return-Path: <netdev+bounces-8864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB357726210
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4960F281362
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C17935B52;
	Wed,  7 Jun 2023 14:03:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D03139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:03:55 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2054.outbound.protection.outlook.com [40.107.100.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDF21BE3
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxJkkaGBnzMHMuCO8BcBtqZXHY6iRjGCqYAPH3fMNcAwyTcoE1DFKXBAjSY6wSYnKtKgGV0VBnmHv8XdtfmjwdalHhRLeVKzgeobIAsQjObgBjOSeayZ3g0QJ6rGiEKWrdaBMgm0wy5KjqLJPpRBWyDeDPh37FgyL5EkV83eCGpHj+m80WkExKQ1CumlnzKLiLggn9x4WSWqYNT7jEAlKjbEzuxxTnRg464NJjYuMYFw5ca4MfL7S6X7ZdNWbeVFzY3dqdQcYOHe63agsagHrhDQND3Q/ltz349HQlHMy4obXncJTBo99vR5zBrBCG1xHla5Q4a6Vdx3Y/0mvlFPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08mdLWmoN6o4y4Ni5yjGy3GFi/hsGOL3gNMPYutpx3k=;
 b=GD/uUIarTQ44la7VtVzI9Stat7TSCuVZ5sYdTnGLTD2apyzvoM/jK1AqtJblzWLmheLBVe4cJWAvzJZnDl3XdSlo18LxZN9OBYZDr+U1CNfVXogigIZxTni1uOCYrcZhSxXQLbHbSpakbmuJB9oKawKuTaYCIp7mzhtvDZtsvaQ5v4sg6J0Hrx7DbAmPBMTKVDTxDmKwnik1rQFlUYcmXvuXSbS19DxFtRlhjfTFk4eNNX+ySj8nJ9LPD1zKScs9vv5JiHTJd+gF6UMcblEAo/PenmpUEh1YndpPH8wNdfECw5iPH518aV6PiCnyw7jSxCftJFzFqAp/qB7DaVfMQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08mdLWmoN6o4y4Ni5yjGy3GFi/hsGOL3gNMPYutpx3k=;
 b=km/aFD+22nAypyzZzfeI+gcxO/5sOGxems6TWZmILLAJjXibZvQCMJIl1ebeWu0lS2bvLJn4L907qK7xu4RFlHEGJcHRIcCcONWO7cGv0X0D6T0eS1JQ7SYKXsHQRrTu3sd/qQrSUNAlgxtthQeWaXkNHLX3gGdTJVMQh2cASKKqCB3/2ay1Dkzf2jvNAWUSc6aiB9vreq5aGJTxeLBEwfSIlWyrZR1g90H1sJrUyi54LgCYD8/CqxZVu+if/o6RyeOM+lKN+XgPI7L2uyVy7cVYX/6d3CULo5NlRXOcSD416maoYkJzrM4TJXgiISKXLQwbAKqtZJrOeKIQ2RTveg==
Received: from BN9PR03CA0971.namprd03.prod.outlook.com (2603:10b6:408:109::16)
 by SJ2PR12MB8649.namprd12.prod.outlook.com (2603:10b6:a03:53c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 14:03:50 +0000
Received: from BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::74) by BN9PR03CA0971.outlook.office365.com
 (2603:10b6:408:109::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Wed, 7 Jun 2023 14:03:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT114.mail.protection.outlook.com (10.13.177.46) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.36 via Frontend Transport; Wed, 7 Jun 2023 14:03:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 7 Jun 2023
 07:03:41 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 7 Jun 2023 07:03:40 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Wed, 7 Jun 2023 07:03:39 -0700
From: Asmaa Mnebhi <asmaa@nvidia.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
CC: Asmaa Mnebhi <asmaa@nvidia.com>, <netdev@vger.kernel.org>,
	<cai.huoqing@linux.dev>, <brgl@bgdev.pl>, <chenhao288@hisilicon.com>,
	<huangguangbin2@huawei.com>, David Thompson <davthompson@nvidia.com>
Subject: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Date: Wed, 7 Jun 2023 10:03:35 -0400
Message-ID: <20230607140335.1512-1-asmaa@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT114:EE_|SJ2PR12MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: ae44f27d-527d-4d92-b45a-08db676004a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QijGzmpR53l4EtKroIeUvXPN3q6SYCu03cBe7kZuVK1KlMSLLZsHiP+IP04k/QT0gXBoX4tUf4d6xyOpTtILUJvCAs566iuESIu4GMg9JSGxl63GY7B8tAwGsPPbbDMZJftu1o/etlnDXWUX7Cww7IhBzIx3w/ab/54upvPpg+tyX0d5JHFF5gtaKyQ1HOM6xketx+sbpKEzbru0rf9UknyPhOb2H7b0s4kYHbzyz+Y999cWHLZAj5FMRK4z7BlkoFEhzhn+euCMD8VDlJUlZgv0kVGa3iu7gBQu3ZwzaHBRrBMmB0zx5fpTIynuBJiXPVYso6Y53VYm4JSGh+4hu0WzNmmsB9Fz2pmujV3CbHRl8elAkY6fWUxEgh7jEJOFh8yIk59ghaT6/3tolE9ziMlR5Nmb+fTCbjwEUNKcYmUG36amCdW6zhfBgew+RKvOKntSu5h19LH4EsvArpRFKQwdxHV3ixnezWbybWTgaX27R0iL7tkJMCuKGEbgK0zDigspBYaoX3hoVtZDW379VxXfDXZkJwj+8OFI31DuC/4/D+gL8pAFxXVe4aKZ3JB7IS3m7K5ly4Afj2RPsCFxL8uvob5O9ZTU6vl+1Op4UZmc4i0/qLdZtZ4E0ebgYxSzJyXgCnX8quTLzj5tmARvSZEh1NKpGtdUTpjFIfzLUAqHnByWrGQk4WMGUE4+mBDyQNlJmiOrAMQPl7Mewq+GNtwlutX4I9RyN11lUxYCrba5ZHVBPaVX7hZ3ox45UjvA
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(426003)(2906002)(47076005)(336012)(83380400001)(2616005)(82310400005)(36756003)(86362001)(356005)(82740400003)(7636003)(36860700001)(40480700001)(7696005)(41300700001)(6666004)(5660300002)(316002)(107886003)(8676002)(8936002)(54906003)(478600001)(70206006)(70586007)(4326008)(1076003)(110136005)(26005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 14:03:49.3541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae44f27d-527d-4d92-b45a-08db676004a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8649
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 694de9513b9f..609d038b034e 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -475,6 +475,9 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
 {
 	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
 
+	if (!priv)
+		return 0;
+
 	unregister_netdev(priv->netdev);
 	phy_disconnect(priv->netdev->phydev);
 	mlxbf_gige_mdio_remove(priv);
@@ -485,10 +488,7 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
 
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


