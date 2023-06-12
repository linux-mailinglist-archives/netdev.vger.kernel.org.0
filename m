Return-Path: <netdev+bounces-10170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8443B72CA37
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:33:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 960C21C20AC9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D1B61F17F;
	Mon, 12 Jun 2023 15:32:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A27A1DDC6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:32:03 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D41819B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:32:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ng8GHBpTTVjNaJ005Ivr0y6KJYCKXPvPy86N7LiOC9W0LwjLI3S5FVosFJPzP+KhFdsmCcC0TzEqSmgDBViXze/BqPOCd4T7UQbXlUbgQGOMPGy10f6xsTEl+QD32J10rs6OXGtZxlTf8Xgs14fC+F+ffJAhSCPmjmB8peH+H3Rw+V9MsUGQfCYp4jRHVm8GVjJ4weHY5XH5vRzf5Ezxw1CVTxTwYu8jliC6X2o+7h8UyEfmQ+9H6xAy+oTgzH3JWCk0O3KD1y1qZRyNAJgtKLL+BrzjoCJfeq9KwpSpkDHtZgUNKHA6t1CgimL8Fo1trtSf3o5pjmhjVIb9TTTy4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDhanY2btMW7p6lKU+RZssWiCjDWKaMz6V3XGB1xTy0=;
 b=LzbN2asNB3/YC9n9TCQec8gY18uWwFvi3AL9uUrgnYE97GDgv0/vqGPA3dMnSdQezf5GOfOcltMr5LJJzhM+Jn2HF+JQbd1ea6W+vqv6xTgA53yetz4e8z/fWbipMeNRzSZU+e7PqTzr0njBZnWC92N8teRYZPanzQtQ8cWhLbvzIj05Gks7Y3aTPx8DRa+Jp7E41X9n3s1bj2BrRspiRNn1e68pn4pRai2Re5z8e4rVHCOr1Z5mVZBxNbG1sVA5hocb1cn0h8aoHu4mkD0Qx/50c6JVqVI8osOCa2wwznpkGS1R2kvDpEcfUKQQ2dh4vu/WD4jvXr6B4PicMXDVaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDhanY2btMW7p6lKU+RZssWiCjDWKaMz6V3XGB1xTy0=;
 b=c0lG/rQNIDKjAlAhpsWUlB+1sHTWQGOm1yTYXci0IBFG9c9sYT3KicybG6polDukRp7XvYnF/F7eQJ2+kXkEg2NK07eiT2lK/vWHq84Ox/CLtQgOH767aoUiWBzzqin5Yc9Zi2co8MdVft1+Js8Bvjoai0jvseyBLl1GZEYSB1A46oR62fbTNpnUnQoYa3yny799+QuGpDrFtvGPL/PfZjj/BJpxdq9E9qz3GAjyIJnWXw9HrMNM08EQve1JqIOYoszRYNUrwKrJFiwTac3qcvneXa3U37tPHD+O+0r5U+OryJt3Dku6PRNTb+a8ITuEtzqZGCjbOLRt5gL09amPyQ==
Received: from BN9PR03CA0103.namprd03.prod.outlook.com (2603:10b6:408:fd::18)
 by DS7PR12MB5813.namprd12.prod.outlook.com (2603:10b6:8:75::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 15:31:59 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::26) by BN9PR03CA0103.outlook.office365.com
 (2603:10b6:408:fd::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:31:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29 via Frontend Transport; Mon, 12 Jun 2023 15:31:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:38 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:36 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: spectrum_router: Access nhgi->rif through a helper
Date: Mon, 12 Jun 2023 17:31:05 +0200
Message-ID: <f2b63bf0d353c2b7a4ad5c9454e3f50ddf28b118.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|DS7PR12MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: c85fd9f4-526d-4611-2d93-08db6b5a2963
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WRcMR1vTTc5Sqzd4btvPTpuKdExkY9k+qQPZwQ/NinOXkuTrzQ5QODS6w03Zih31lWmj6ctj21BqYejj1SNQgbuPLacu4bctM2h2e6TaRR5jTRLSdNSofKo6tHXtPH9bQ52SSxVJOivSjZ9t+WGSj5naMhbI305xta/hJfYK85UNDdJ7EaXXutpw0mVL3hIFOTA+vbAEPvSl60XdZGQowGBb0Ylxf9i/Hb0ZF5qtuPPkszePM98bbm9y5FZ9cVF/BZ8mGYYuOejHeyHvxMFX3VLYwTsyrWAJ45dt4Q7JzVedCPYENBP+YlmBmVfW5JbtxAP3XYYD86Ww8UbBYtVxv/X4ABanM0Aqn9S3yB/zINvilEYknyMJ3ibKHT/eYio+RuXWmoGhw41OnCcpbXGjVUZ5rmJzuDkXdmsFzcarXHiUzvnE6qasBYXRNQ7N/zRlWFi4xWqQijJWzb99BfrvDmhhdT8WrvBgUfNnUj2vTP4NShgauI175V5rYkXy4Qbufy2FL8wIHAvKTHE/l7cMRTmWnJNUzERibfInxQPy+7B/1nmPqGx2zNZb8zwJTyAXWJ5c3u/ZskHk0Bcuiv1EZ09r4JKtidPJTWpDsZespccAIBU+GzHIkyNdXgFXOvqw9NTM+fzD+V3M34RMc8RBmTM4KjgYo+KiHOoR3KJoiHbwCgTKzWAgpDRcUOxX1iyeA0PmrmWd8OnShgx6NxmjUM+8AvsKrwVFEieKpbeA4VCMh5mizMlXQqCDbkkFhgFc8QImv5zQQZrlH2LEUa/uGg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(6666004)(7696005)(478600001)(36860700001)(66574015)(47076005)(16526019)(26005)(107886003)(426003)(336012)(83380400001)(186003)(36756003)(2616005)(82310400005)(86362001)(82740400003)(7636003)(356005)(40480700001)(4326008)(70586007)(70206006)(316002)(8936002)(8676002)(5660300002)(41300700001)(2906002)(110136005)(54906003)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:31:58.6776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c85fd9f4-526d-4611-2d93-08db6b5a2963
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5813
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To abstract away deduction of RIF from the corresponding next hop group
info (NHGI), mlxsw currently uses a macro. In its current form, that macro
is impossible to extend to more general computation. Therefore introduce a
helper, mlxsw_sp_nhgi_rif(), and use it throughout. This will make it
possible to change the deduction path easily later on.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d7013727da21..e05c47568ece 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2966,9 +2966,14 @@ struct mlxsw_sp_nexthop_group_info {
 	   is_resilient:1;
 	struct list_head list; /* member in nh_res_grp_list */
 	struct mlxsw_sp_nexthop nexthops[];
-#define nh_rif	nexthops[0].rif
 };
 
+static struct mlxsw_sp_rif *
+mlxsw_sp_nhgi_rif(const struct mlxsw_sp_nexthop_group_info *nhgi)
+{
+	return nhgi->nexthops[0].rif;
+}
+
 struct mlxsw_sp_nexthop_group_vr_key {
 	u16 vr_id;
 	enum mlxsw_sp_l3proto proto;
@@ -5510,7 +5515,7 @@ mlxsw_sp_fib_entry_should_offload(const struct mlxsw_sp_fib_entry *fib_entry)
 	case MLXSW_SP_FIB_ENTRY_TYPE_REMOTE:
 		return !!nh_group->nhgi->adj_index_valid;
 	case MLXSW_SP_FIB_ENTRY_TYPE_LOCAL:
-		return !!nh_group->nhgi->nh_rif;
+		return !!mlxsw_sp_nhgi_rif(nh_group->nhgi);
 	case MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE:
 	case MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP:
 	case MLXSW_SP_FIB_ENTRY_TYPE_NVE_DECAP:
@@ -5772,7 +5777,8 @@ static int mlxsw_sp_fib_entry_op_remote(struct mlxsw_sp *mlxsw_sp,
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
 		adjacency_index = nhgi->adj_index;
 		ecmp_size = nhgi->ecmp_size;
-	} else if (!nhgi->adj_index_valid && nhgi->count && nhgi->nh_rif) {
+	} else if (!nhgi->adj_index_valid && nhgi->count &&
+		   mlxsw_sp_nhgi_rif(nhgi)) {
 		trap_action = MLXSW_REG_RALUE_TRAP_ACTION_NOP;
 		adjacency_index = mlxsw_sp->router->adj_trap_index;
 		ecmp_size = 1;
@@ -5791,7 +5797,7 @@ static int mlxsw_sp_fib_entry_op_local(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_fib_entry *fib_entry,
 				       enum mlxsw_reg_ralue_op op)
 {
-	struct mlxsw_sp_rif *rif = fib_entry->nh_group->nhgi->nh_rif;
+	struct mlxsw_sp_rif *rif = mlxsw_sp_nhgi_rif(fib_entry->nh_group->nhgi);
 	enum mlxsw_reg_ralue_trap_action trap_action;
 	char ralue_pl[MLXSW_REG_RALUE_LEN];
 	u16 trap_id = 0;
-- 
2.40.1


