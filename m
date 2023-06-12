Return-Path: <netdev+bounces-10168-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6547272CA2C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:33:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3DBF1C20BDC
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42D31E52A;
	Mon, 12 Jun 2023 15:31:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC261DDD3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:31:57 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB7F1B8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:31:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBpN6q8cBQVelU5CuTtfALO4sVExCUWWpU6fnQhe89X6cigdzhiOnpAgWgLzEIJSnP6QJUmpV4lfrQkNEuTCQd37ayoJePDEh8OLIp+TjKj7Q1Um3ScvBsYW+8+8xDGlkeR1Flv8MBIYrc/tst0H2jXRMkcnpAfs1e+QMWG9uWECEpa2Ti0WofF2ZNsBodnDQFVmO99VaTG2k3jwbgFYZsedrIePa+PypyeZCSD3ndEayJO/03k3TmiJn/r2CKcZzFvh6vzRVRPCcblf8I1f7geNEv1vi4BJzR69ktT9w44xIHX4g25hFfSOcO/FFmj8GyllFxO2hQo31xFrcr3zSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6byfS3JCzwaHeqcN6GdOMja7PSan1fPBZDDpXo7fOU=;
 b=WNk7yxdaF2mzwE8EPIOqxsWN51b86IWeNUHGWmcB+SGSVPEfOkRP/m0VvthZiqF+9Y8p7n4d4KkoYZgw42BEqhtZHj3ZLcOxnxfS0jedGg6IVqkOj+Yq2VgZIy9uX0Fk9h1E4fzteacWem4GHjtDYFAxahaxFacSpIvfuuO4BU3PINHiIsX6ufSvaO5WJZINCK3hnomYHEEf1DMeXrryNbGfStgIzQU27MOGCyyuJaqsAjeUNf4aq1X+uG+tcE/Wq3rmQgmgn/U6J35yvc40syEX3L0MhBrXVgE8WXnQzmz8v3n5+cXK+Xzyf3v31dJ7tILT4EvegaZRf4ybJ7y4Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6byfS3JCzwaHeqcN6GdOMja7PSan1fPBZDDpXo7fOU=;
 b=L9o2ZsoMVSmoQvPBxz+7vGhvkZF1pR58h488uHIJnYN3Bv/+QZXbEC1r6LOUHpYEtkewVBXycOEXAVR4Q/TS5INZRApHGlw+iRi9qJCUH5TZRmXh9k1UN3JI/rbSh81fKFFKnK6D/kTJQjKFSwoU5pfYeRu0Mw5l1AqJQiN6ZVmegpNezxs8Yh0JXSHoQq4JHe7P/UzRNsteerVc3bA4HHdM1ZJg0LUAGZ1RviSY718tsnXiOA43vmbqkihsgjAPMU29enYu8YL8MQaf/dm8oCVr/jWxXh9KO4kZ5ha9UzkgKshFUWDW+NUBXTdr1jr3tOdsqdVmgSShld+z3cPO3A==
Received: from DM6PR07CA0056.namprd07.prod.outlook.com (2603:10b6:5:74::33) by
 PH0PR12MB8773.namprd12.prod.outlook.com (2603:10b6:510:28d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 15:31:53 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:5:74:cafe::c8) by DM6PR07CA0056.outlook.office365.com
 (2603:10b6:5:74::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 15:31:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 15:31:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:33 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:31 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 04/10] mlxsw: spectrum_router: Access rif->dev from params in mlxsw_sp_rif_create()
Date: Mon, 12 Jun 2023 17:31:03 +0200
Message-ID: <7397c89078f4736857e9f8cbcf41f9b361960cf9.1686581444.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686581444.git.petrm@nvidia.com>
References: <cover.1686581444.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|PH0PR12MB8773:EE_
X-MS-Office365-Filtering-Correlation-Id: 58499557-6fa4-4171-6256-08db6b5a263a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EPwSDl6WrD1EFtoetl0KcHSNj89yFPYai4gbz/fqFi2QnPqi9bLJt1o3lUSE4Tailz5feUyiqRMXvPh1jNEaftCOEE5mha5I2UJUx7B/asrvj0lua9GJpwSfFMb/i0X1r8P1W3CcZnYjmp0YlrW49hFqNswX8AMxF+PFAbxMvltJyMJXSa3HClfmMiICCN3kJt34AB3Tb3lKX1eA0Iik/SfYU27LrXXOD9VFTPkcJaEmFjAOuQe6znhTNPfvRZC5NANCavtlf3TUzK7zoZg4Q/PS3xYPZgzb0csVkEReGZGkMp25JH3BZrTXS8VJEZBQwlA2HBkl1FNSl3YR49J5PBwc3BfWgp5qZwWTCPcEQP0hGSZIt5NWC4z7S85QqR2PRGkBLUxqGaaLSGut2dFLVYeE48yLc5heO9u8HGhcQe+BYeb0OxFRM75W0RRmcRkq+aU/VfWKch4YHy1wvW00lRO39qFfzC4ovWpeTOpqq0L+2i6fgCwaJ0pB86yF/4X5cYBj7IagwF55oRJK02kAaYYCu48n7rYGWvZgkfgehTeyDYZOBSb10DhgbxmvzFMF9dh98HoF7hVp3KvIrrrE0mlRiNRncf0J/lHcgET+T627UFVi+TOoPBwYPFtDoilTsXmuG+JaaN+FaYbryvHD/7fqDaezKKiKLQDHsm2FDXFVaoAKzI8+1dswaKo6BGf6Xz6acIgRdu0MJZLtL/a8Cuf27PkOKQ0bx83X/ODff673Y983MD67XQHOuSbQmimX
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(86362001)(82310400005)(107886003)(7696005)(40460700003)(316002)(8676002)(41300700001)(82740400003)(83380400001)(5660300002)(26005)(40480700001)(7636003)(356005)(6666004)(36860700001)(8936002)(36756003)(336012)(4326008)(426003)(70586007)(47076005)(66574015)(70206006)(478600001)(186003)(16526019)(2906002)(54906003)(110136005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:31:53.4239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58499557-6fa4-4171-6256-08db6b5a263a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8773
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The previous patch added a helper to access a netdevice given a RIF. Using
this helper in mlxsw_sp_rif_create() is unreasonable: the netdevice was
given in RIF creation parameters. Just take it there.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e9183c223575..da582ef8efda 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8138,7 +8138,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		err = -ENOMEM;
 		goto err_rif_alloc;
 	}
-	dev_hold(rif->dev);
+	dev_hold(params->dev);
 	mlxsw_sp->router->rifs[rif_index] = rif;
 	rif->mlxsw_sp = mlxsw_sp;
 	rif->ops = ops;
@@ -8166,12 +8166,12 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 			goto err_mr_rif_add;
 	}
 
-	if (netdev_offload_xstats_enabled(rif->dev,
+	if (netdev_offload_xstats_enabled(params->dev,
 					  NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
 		err = mlxsw_sp_router_port_l3_stats_enable(rif);
 		if (err)
 			goto err_stats_enable;
-		mlxsw_sp_router_hwstats_notify_schedule(rif->dev);
+		mlxsw_sp_router_hwstats_notify_schedule(params->dev);
 	} else {
 		mlxsw_sp_rif_counters_alloc(rif);
 	}
@@ -8189,7 +8189,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_fid_put(fid);
 err_fid_get:
 	mlxsw_sp->router->rifs[rif_index] = NULL;
-	dev_put(rif->dev);
+	dev_put(params->dev);
 	kfree(rif);
 err_rif_alloc:
 	mlxsw_sp_rif_index_free(mlxsw_sp, rif_index, rif_entries);
-- 
2.40.1


