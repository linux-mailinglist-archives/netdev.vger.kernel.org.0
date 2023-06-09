Return-Path: <netdev+bounces-9634-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E50F472A147
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 353531C20EA2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594FE20696;
	Fri,  9 Jun 2023 17:33:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9E019E52
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:04 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA1B1FDB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgE36ejAfhotib1soVKOd5QW1FX83weasoOBzTPgfE0zEaOhMpRTyS+U/x0CMIa09PmkLLKCaWBrJ7jB+1Mi8drNVycB3LIIakUtteVqPkxwBzesU+A0btZfYffx/lkujsf0RhApR3yZ0aOY8uVtqRxA1Q/Tg37Ab+UVHrsVhv6fgrUpLuwpxeiYZr8Ix5mD5kgBWvJZhzbkmpABZSmVN9Ai2CRsycZhXTCZnYnZDTpw72vXs4lL42pd3LK2Yz/a0qblYMqjQRg4Hyu4Zrlu/0IxeZzeDtStzX/peT1I9a/dGwAipPAbQEGsrTAo3NJ3bghW/C13SjPvgl3M+nWOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhPM5gAji0J3SJGI6nrMuSIjM7zs9fqv/nyaRP7KZ0U=;
 b=bODA8eAqhVDAN4ZkD5FrdEQQNkTkYnxHM8bKbsVQGHlVvbsgzDoiSiyLtvGvCVNZhTOwna55Jkr6fw77lad0B1IBK7gU9Ij3h/LTfOMszO8/joteu3rWrKescfvqGD1HiXzbZ6Tb8h+d8Vo8Oy9EDD+aaa7R8lbkK+mh71bfnRG+2xg4RBdnKe5XsJ9xlvrR8Ck8LqoR/mKMGDUqi8yyzLpFCNnVStvALZV/Fr5a+cXqzMS8fsDh1cw+QvHS8po8DzNj7tAbtc2dce7o8ET60zuXsTDDJY8+mUJNqwnHRovKv3F703wWoJ0usFW/MbYjUr/VVzoKtdioc93B/ciRBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhPM5gAji0J3SJGI6nrMuSIjM7zs9fqv/nyaRP7KZ0U=;
 b=T//3OVQUePuAZJISqqWGTbHZnNxVKqKeqSurIPKp8QI0FLUL83FAG3hmIPes6AKWeJNgA1kJ+IzteZSW++pnGTHKnHRkGgnEj41crG/Th15gkverHrNq9xc1vMwdMpGYdWR2cxOWqiveQjBo23J1pPqrvLmpC06zzXoCLMLxNbdlXzYjHanuerD3tv2OG8sVFpM0kVIRr1UhMgcpAMtmAok0AfTTCW/ivEuiUvKi8z1bo65dYkFL/FpCagc0+/LjyNIOIG1XzUBwLRS/6gBLyC6LM+qWcBWNICIgvj4qPTocWAJtegWCT5QK3/UanEZdTkEDf8+3X+JgJ85/yt7N4g==
Received: from DS0PR17CA0005.namprd17.prod.outlook.com (2603:10b6:8:191::6) by
 IA1PR12MB7734.namprd12.prod.outlook.com (2603:10b6:208:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 17:33:00 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:8:191:cafe::ba) by DS0PR17CA0005.outlook.office365.com
 (2603:10b6:8:191::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:32:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:43 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:41 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum_router: mlxsw_sp_router_fini(): Extract a helper variable
Date: Fri, 9 Jun 2023 19:32:06 +0200
Message-ID: <c79d2114b7764b3191ebdb0a8e81b61b53a48528.1686330238.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686330238.git.petrm@nvidia.com>
References: <cover.1686330238.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|IA1PR12MB7734:EE_
X-MS-Office365-Filtering-Correlation-Id: 40ed7dc4-e847-4b14-8d09-08db690f922b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZxbGXp84jpDB2UAwmAc8NplAjDqbD7cEXJPLOFAnyLwNVOc9d25vS1W3b9VbM0f/nLZvq3wrsMBLTSLzLw4u/PR2oG7ZGTwoypJVuAKZRWlG7lCKQP+XSKd4nNnVkvpOh9tcpDJyDxFDGBJDSjSrjHm4rDDV5InlNM6KgOYwFBCM8nJJXanBExQnVeosnJMY+N2f5QZYP+DecTRIBYD+XFR1bQfStl9FnNvC/YzlNsj4J50wNNM8ct4u+7CAq9wCG8qWS7QklduqXC6UuDefakUqr00vixTt8/r9YaBHjA2gx0j2BHWbd0sCZk2bbmKiIEBaxGYYERc/wMeicAM7ggjxiyyjo2Zxrsm2s3ZofAkX1SxlKpiX8NCIWLsebowILzp8tl21ajWm+gy4rKWrMrmygUn85GLodXz6nW9gIsqf+e6x6oVjNT54B/JLbBjG4taN1ODHTguMk3BGvnVTFsjSWwBkebhT1yckaqxoHSuU7TQEztYEL80cCNw5aaoXthza3Ifap1QJBkxOu15RCMeGkpfp/Crz6ELY9tF7b/l7ZKvCnjxzJzGbmPM6XL2WJ5Np/ME5rgdRE9o3pW9sjwM14x+uFSjzjFs7dR0WT/lYNgj2ehl1dB5s5kelRRFrH/Yt/MkP2Jfp+8OAf8FNtVvKn77L5tla538nShFl8+NynIoQI+adHOPMRzmMBwzqlVloeeDzzlmI4HnqF7aAUTGdwk+gD2IZlyqft5CP6cY9KIayBm5DGkc1vjjS6Cfp
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(40460700003)(82310400005)(66574015)(40480700001)(26005)(107886003)(41300700001)(5660300002)(426003)(16526019)(186003)(36756003)(36860700001)(47076005)(70206006)(316002)(6666004)(70586007)(8936002)(83380400001)(336012)(478600001)(2616005)(54906003)(8676002)(110136005)(86362001)(2906002)(7636003)(82740400003)(7696005)(356005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:32:59.9716
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ed7dc4-e847-4b14-8d09-08db690f922b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7734
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make mlxsw_sp_router_fini() more similar to the _init() function (and more
concise) by extracting the `router' handle to a named variable and using
that throughout. The availability of a dedicated `router' variable will
come in handy in following patches.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 25 ++++++++++---------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7304e8a29cf9..583d0b717e25 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -10664,15 +10664,16 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
+
 	unregister_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
-					  &mlxsw_sp->router->netdevice_nb);
-	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp),
-				&mlxsw_sp->router->fib_nb);
+					  &router->netdevice_nb);
+	unregister_fib_notifier(mlxsw_sp_net(mlxsw_sp), &router->fib_nb);
 	unregister_nexthop_notifier(mlxsw_sp_net(mlxsw_sp),
-				    &mlxsw_sp->router->nexthop_nb);
-	unregister_netevent_notifier(&mlxsw_sp->router->netevent_nb);
-	unregister_inet6addr_notifier(&mlxsw_sp->router->inet6addr_nb);
-	unregister_inetaddr_notifier(&mlxsw_sp->router->inetaddr_nb);
+				    &router->nexthop_nb);
+	unregister_netevent_notifier(&router->netevent_nb);
+	unregister_inet6addr_notifier(&router->inet6addr_nb);
+	unregister_inetaddr_notifier(&router->inetaddr_nb);
 	mlxsw_core_flush_owq();
 	mlxsw_sp_mp_hash_fini(mlxsw_sp);
 	mlxsw_sp_neigh_fini(mlxsw_sp);
@@ -10680,12 +10681,12 @@ void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp_vrs_fini(mlxsw_sp);
 	mlxsw_sp_mr_fini(mlxsw_sp);
 	mlxsw_sp_lpm_fini(mlxsw_sp);
-	rhashtable_destroy(&mlxsw_sp->router->nexthop_group_ht);
-	rhashtable_destroy(&mlxsw_sp->router->nexthop_ht);
+	rhashtable_destroy(&router->nexthop_group_ht);
+	rhashtable_destroy(&router->nexthop_ht);
 	mlxsw_sp_ipips_fini(mlxsw_sp);
 	mlxsw_sp_rifs_fini(mlxsw_sp);
 	__mlxsw_sp_router_fini(mlxsw_sp);
-	cancel_delayed_work_sync(&mlxsw_sp->router->nh_grp_activity_dw);
-	mutex_destroy(&mlxsw_sp->router->lock);
-	kfree(mlxsw_sp->router);
+	cancel_delayed_work_sync(&router->nh_grp_activity_dw);
+	mutex_destroy(&router->lock);
+	kfree(router);
 }
-- 
2.40.1


