Return-Path: <netdev+bounces-7492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52FE972076F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D45BA1C21152
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5967A1C76B;
	Fri,  2 Jun 2023 16:22:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475341C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:22:08 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7D0E57;
	Fri,  2 Jun 2023 09:21:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ij1LtQytjSHeZfTlbYvYq4qIKb9ENG1gXKRkd5Ib2s9FYFyk1J7Jy24dBqsNLRJoM6baTqAkDjgBlHiWAMVgtte5zeaVDMekeOk+x9drcApYVWWbHPmE372sGYIzBvewRUSstRAz+TnhMhwMvU7Yoj2+bDL06OYSbtE14HE3zfb3L2thuymsTyCtL/jrSahZctrQXqVnd2tReW0hD65lW1N8F+9Aa2/NVx49sNL6fWNpbE3mC+hnSG0RthHI4/z6SdRLDsj9dW9hBUaRwGHrmZkNt6xeKFzl4DXjVA853sdDrSknVC+/8HfGuRLVcs7E427pc5xa9Ehx9bsWugqQMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9giz0xQ60pGzrcWxSkdHE7GN86NMbK2lwKUUmrkQIw=;
 b=iCaeEsU5vhUOnSzAB1EfgMXLZ/Rg5mnhLFPKVxQ76RG+Xf+walS/hey4DILKv7mBe/LQNUhU6lWPM3KKnFt6QrsB1fOJ6zEeYBT3JUdlvfeYCqsJxGSbJS4biCJUSgULTap3goNVcIPKnVtSOWHaNV7ITvUkALZ6mp6v2UHdJobwArnvVDDb/+CbYUrcQL+A9SEIMXQgNqUJz3cEvdpgN8KsHfVkVQBj1B6o1b+LU+KuGlrgvF0leshmMVTRiZuunxc1+O8OxKbFo4/cuLrUBgYZKOrvsuPz0AW69x7SQoVbXadfAEDI2DhFCgbFXb1AV+3lIhJzVDsXOALbKQfvoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9giz0xQ60pGzrcWxSkdHE7GN86NMbK2lwKUUmrkQIw=;
 b=QltKcDemRJiQLUavzrmxJTVWwM2eyaObiOANVzyxEcaWS5D87QT/SLpVI61piVVB3T2QRzd99IxPuCCniomjVbaIB0PC2NMF0+ZjoJcUyTbgJSrHCPoEOkDgmqROPURV9m2BG12RrzIh5m4kTjFNUj28yox3esLNa9Vq++zW3N+TnVE9800MsvuAZ+c87e3+S1/YxNyRhvjdEfBSGKcdeVIM+G0WBbtUGkOzUXie2EdZPInxmvopwUQr5K421nayH3MvOzfJPDIpVMOruEFqqJ61EY/gm8a45UYqO0d/hoTzc3XQtCpAt/6c78d88W8jw8By3ixawg81QJ71ZSaKrw==
Received: from DM6PR18CA0016.namprd18.prod.outlook.com (2603:10b6:5:15b::29)
 by SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 16:20:51 +0000
Received: from DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::fa) by DM6PR18CA0016.outlook.office365.com
 (2603:10b6:5:15b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.25 via Frontend
 Transport; Fri, 2 Jun 2023 16:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT090.mail.protection.outlook.com (10.13.172.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 16:20:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:38 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:35 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: spectrum_router: Do not query MAX_VRS on each iteration
Date: Fri, 2 Jun 2023 18:20:08 +0200
Message-ID: <4e14a05ab55f8fce70ad4c6821a83f910f9b6a88.1685720841.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685720841.git.petrm@nvidia.com>
References: <cover.1685720841.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT090:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: 894825d4-5321-4add-225f-08db638554e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/Dcg2i0QqMaij7h/8BH+ovEIJNj+fYQCFb3DT0yHnY0knckvIjG0W+rgoRhh5bHA2okWQdBc0OoIWlE9NIWJ0b7eXQnqQd6q607EL0vPNNhF0hFjwBfXXHwPow0nWRXxf+kQayM4WjLdcN3rtxyXOigDSzEgc2PWcBC4/yOTR97u+7UD+5JnNxAnIYlZGMyoMVF9/e8VA/lzpKGHkh2M3gV5zxeH88zKI9cRNPTCnGf59sopac3h5ywCRxapHweCuT+YWpI0fQE9TdiaJznYcx+5xIltWyCuPixcnHdK+ylUOwpZHZUyqJNXhNNH9Pa1qaOqf415PzFQK3ZVtW5bIlTNvTyCFUrLj1HEOnSED/70B2tlNTBdSQ06rrn3oE2aFaNVkL0rmta59zqf4M8tNOzB0lCxi3piDosgiudrEsTY/FeWJxnMhhwcGI7lllwOANU/M+QxlUeT795llU+3RJeFdaV/lxh+J6/lKshw4GrVbtiefbwRSDfBUKkDGeu/1uzK8gijV5IM3Oy1EFgkchnjYeIA5tsmBjZlDeULqxB/SbRDpURiXGHaJwIQnY4jdwUYg+LoG2SD4nJMDXBATo5qilWxHUBx2ZCCR3oIRsGWvojJ31jHfudGWAH1DcbLUi2WhQ3dvKyYvP61ril8sHnOXRvYcOu0iQ3afPSAsbAQZwXH723ondRkNu+DOsp+zyUqCMY4/gAxdnU/BFf9apHxpYdAbj0muUdsuwgA53UPm7XyvVAnOaE7DIITedDR
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199021)(36840700001)(40470700004)(46966006)(36756003)(2906002)(86362001)(82310400005)(5660300002)(40480700001)(83380400001)(186003)(40460700003)(16526019)(426003)(66574015)(47076005)(36860700001)(26005)(107886003)(6666004)(82740400003)(478600001)(336012)(356005)(110136005)(54906003)(70206006)(4326008)(41300700001)(70586007)(7636003)(316002)(2616005)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:20:50.7884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 894825d4-5321-4add-225f-08db638554e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

MLXSW_CORE_RES_GET involves a call to spectrum_core, a separate module.
Instead of making the call on every iteration, cache it up front, and use
the value.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c    | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f88b0197a6ac..7304e8a29cf9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -748,10 +748,11 @@ static bool mlxsw_sp_vr_is_used(const struct mlxsw_sp_vr *vr)
 
 static struct mlxsw_sp_vr *mlxsw_sp_vr_find_unused(struct mlxsw_sp *mlxsw_sp)
 {
+	int max_vrs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS);
 	struct mlxsw_sp_vr *vr;
 	int i;
 
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
+	for (i = 0; i < max_vrs; i++) {
 		vr = &mlxsw_sp->router->vrs[i];
 		if (!mlxsw_sp_vr_is_used(vr))
 			return vr;
@@ -792,12 +793,13 @@ static u32 mlxsw_sp_fix_tb_id(u32 tb_id)
 static struct mlxsw_sp_vr *mlxsw_sp_vr_find(struct mlxsw_sp *mlxsw_sp,
 					    u32 tb_id)
 {
+	int max_vrs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS);
 	struct mlxsw_sp_vr *vr;
 	int i;
 
 	tb_id = mlxsw_sp_fix_tb_id(tb_id);
 
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
+	for (i = 0; i < max_vrs; i++) {
 		vr = &mlxsw_sp->router->vrs[i];
 		if (mlxsw_sp_vr_is_used(vr) && vr->tb_id == tb_id)
 			return vr;
@@ -959,6 +961,7 @@ static int mlxsw_sp_vrs_lpm_tree_replace(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_fib *fib,
 					 struct mlxsw_sp_lpm_tree *new_tree)
 {
+	int max_vrs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS);
 	enum mlxsw_sp_l3proto proto = fib->proto;
 	struct mlxsw_sp_lpm_tree *old_tree;
 	u8 old_id, new_id = new_tree->id;
@@ -968,7 +971,7 @@ static int mlxsw_sp_vrs_lpm_tree_replace(struct mlxsw_sp *mlxsw_sp,
 	old_tree = mlxsw_sp->router->lpm.proto_trees[proto];
 	old_id = old_tree->id;
 
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
+	for (i = 0; i < max_vrs; i++) {
 		vr = &mlxsw_sp->router->vrs[i];
 		if (!mlxsw_sp_vr_lpm_tree_should_replace(vr, proto, old_id))
 			continue;
@@ -7298,9 +7301,10 @@ static void mlxsw_sp_vr_fib_flush(struct mlxsw_sp *mlxsw_sp,
 
 static void mlxsw_sp_router_fib_flush(struct mlxsw_sp *mlxsw_sp)
 {
+	int max_vrs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS);
 	int i, j;
 
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_VRS); i++) {
+	for (i = 0; i < max_vrs; i++) {
 		struct mlxsw_sp_vr *vr = &mlxsw_sp->router->vrs[i];
 
 		if (!mlxsw_sp_vr_is_used(vr))
-- 
2.40.1


