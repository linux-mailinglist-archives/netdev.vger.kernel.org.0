Return-Path: <netdev+bounces-10174-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D67F372CA45
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:35:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2186C1C20BDA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E2DA21CF7;
	Mon, 12 Jun 2023 15:32:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1239A1DDC6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:32:08 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BE5E5F
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:32:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZ4VBU37Bqx6gGw2A+EcLMMM7OvNpdLENI4EorC9E3cUI8jeb6Bf+iCV3kQCx4cU0nOy48KaPqWGUzoDkRs9FyV84rPVZ8BbvGwP9uOBjlpKz71IwT2eVYK11Da36jodbP5lJeUMD3lNNyuFYHu0DraMnIaOgaLNIFC48t56rJBFTDFizVS6vPS7er0aUwpYMev5xdyXwep+cSmrDFTO8ASBjQwyVs8tqAftdgGyc4NE5jboOUyxffMqEyQemiWZcs7cdI6YKOoM0nhhLTWc3p6KwoFbOQ4m9WWx7nW8gf1C/vOzM6RRlMrO/E2UtMw7NxTTYx/UZPa/pafUQ47lgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=346IJnFdp0GldBZP8WgJWw5nqVAOt5hKPu/N0GFNKs8=;
 b=IoWJf+GoU+VZrnpvaHg4iGlC3t7dAfMR1haz6meLhTGCmKHqnG2v1DCawYSS5EuWa8sHZirv1YmJuMU0td6aL11sKIL6KnQJoatJF8uwdNQP4r5abI5S4fXss1s325ZJI5rV/XMAq1IkiFfgxA/UDYGEZo45oEgs+15whUWdfKRoRJyMTgJPzTOuq+2K2ZytxBtHEN3rZzRMP/f05MbcQPentRSkwTvzZZ2P4XE+TmeJUKoH6XaXVqqE+LjM3nlgEExkyXPvShyWZCBX4HcvHpN4vgeMB78hSIxpoBejov0L6dYgmqo5PA4P9bXaDPdZ+Ny5HHhPq6asOZebtvMjjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=346IJnFdp0GldBZP8WgJWw5nqVAOt5hKPu/N0GFNKs8=;
 b=iityXCUHNqYP4sb3m589KvwFkYwJ6/n1W+CPmOUYDdDgUjeBktcAVg7UNF5DXakAmoZikaNs1KGBIBSM9fOFESs/jyEedYgzU7BWuqRtEmTNUWix6NWMOJBCjOdg8LRwipw/EUU/WRFMmp+8DtRq2lLL/n1AC2KNLM65Sy+pIIoqKwd/XBGSQc4HkdYEfVPRpJ+gycIfeMLs/1F0rr3SYZNRErb855VRRekC4QQpbk3bauo3kN+8/qlCzhApu5huPfRlgsm20X3I3Jrp+gXphwXPEh+ud5amM3hcbNKUOzRUQhK4xNtkZpWMJvbbaSGpxpqozvhHF9IJmRfF+6JoLQ==
Received: from DS7P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::23) by
 SA1PR12MB6799.namprd12.prod.outlook.com (2603:10b6:806:25b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 15:32:04 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:8:2e:cafe::f2) by DS7P222CA0006.outlook.office365.com
 (2603:10b6:8:2e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:32:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 15:32:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:48 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:45 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 10/10] mlxsw: spectrum_router: Move IPIP init up
Date: Mon, 12 Jun 2023 17:31:09 +0200
Message-ID: <f0a95b2cefd739a8c3da890aaeacafda2e5e26bb.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|SA1PR12MB6799:EE_
X-MS-Office365-Filtering-Correlation-Id: cec56cf6-8e8c-4235-c1e8-08db6b5a2c95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Pp8P7lgwcGk/2jjmFh3tJb9s5NI7l0MGIqqis56Qu8hthI9y4zu7tL5ZLs69awA0rNOWrULYDN25eaiN3OL+mql31q5d1QXUOITPvDZ7GgQtkmY8Jg0GshM6BmtehmEqSuxAy2yMB70kQgnBOET8bx1QDltGKx239NxUO+YekK2JzHl5YUkMOZ/mRsVNsBJEi5CwCqauyu20pb7SVRhfTo6KscFJlV1bUf+36udmg1Zx5pRLG3R0Y0F10LbeZn54Vrw1zW4q1OEeFKTN0ZoZS2Dr42wUuNld2KnBA61KGypvpkZ1tp3eC875u4N9uamNNENdIrsJkjs/9oNBaqe5d4Suvs4yD2gtnLqLvtfKuf2rKhZ4Vyey5MuWG56rry3YVl41CyXV5yOOow3sDuf9YX6Kjgpbro5A/s+EbEetaAffLo6QjnP9r8IMyvGQ7U0brWMmUsDMmcg6xs8y6uR1cBS7oUaL3B3z6tVADxyi2S9u1sDbrA6EH7tBlpWxB/EpsjEBXNZ6txE/E6Zmafma47uFvEl/dG/Df42kobwISR+SjGOOKbOr7Pwzmc6ymnSR4+r/UMfRhYgZ+fePn1akhYvxzqVbiKaU7/F3rI0rWWD5ykI4ZNNXXvNks31e2WwuBeTxTmXD70zbR0YCUKt0v61L9kU6jZVCUBvkRYTmv51szW3XlRC44VLSK2yZersACBz4Fqx+VotQaiI4w8inQRYFZFlfIllK29ruMBlGB7cr1bgWrDyYqgyhBaaLX4Yf
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(40470700004)(46966006)(36840700001)(40460700003)(107886003)(7696005)(6666004)(36756003)(47076005)(426003)(336012)(66574015)(83380400001)(2616005)(82310400005)(86362001)(7636003)(82740400003)(26005)(356005)(40480700001)(36860700001)(16526019)(186003)(2906002)(110136005)(54906003)(316002)(4326008)(70586007)(70206006)(41300700001)(5660300002)(478600001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:32:04.0891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cec56cf6-8e8c-4235-c1e8-08db6b5a2c95
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6799
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

mlxsw will need to keep track of certain devices that are not related to
any of its front panel ports. This includes IPIP netdevices. To be able to
query the list of supported IPIP types, router->ipip_ops_arr needs to be
initialized.

To that end, move the IPIP initialization up (and finalization
correspondingly down).

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index fdb812152e71..43e8f19c7a0a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10643,14 +10643,14 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_router_init;
 
-	err = mlxsw_sp_rifs_init(mlxsw_sp);
-	if (err)
-		goto err_rifs_init;
-
 	err = mlxsw_sp->router_ops->ipips_init(mlxsw_sp);
 	if (err)
 		goto err_ipips_init;
 
+	err = mlxsw_sp_rifs_init(mlxsw_sp);
+	if (err)
+		goto err_rifs_init;
+
 	err = rhashtable_init(&mlxsw_sp->router->nexthop_ht,
 			      &mlxsw_sp_nexthop_ht_params);
 	if (err)
@@ -10776,10 +10776,10 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 err_nexthop_group_ht_init:
 	rhashtable_destroy(&mlxsw_sp->router->nexthop_ht);
 err_nexthop_ht_init:
-	mlxsw_sp_ipips_fini(mlxsw_sp);
-err_ipips_init:
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 err_rifs_init:
+	mlxsw_sp_ipips_fini(mlxsw_sp);
+err_ipips_init:
 	__mlxsw_sp_router_fini(mlxsw_sp);
 err_router_init:
 	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
@@ -10812,8 +10812,8 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_lpm_fini(mlxsw_sp);
 	rhashtable_destroy(&router->nexthop_group_ht);
 	rhashtable_destroy(&router->nexthop_ht);
-	mlxsw_sp_ipips_fini(mlxsw_sp);
 	mlxsw_sp_rifs_fini(mlxsw_sp);
+	mlxsw_sp_ipips_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
 	cancel_delayed_work_sync(&router->nh_grp_activity_dw);
 	mutex_destroy(&router->lock);
-- 
2.40.1


