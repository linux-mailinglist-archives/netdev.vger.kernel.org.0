Return-Path: <netdev+bounces-10173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B35D272CA41
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E49891C20ADE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6DC21CDD;
	Mon, 12 Jun 2023 15:32:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A621DDC6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:32:06 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597031B8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:32:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4CEhZAAOg7gPU3peElJamj4/5YBQMLeX6HtuGJbzB6zEScCSNjbKu+PdP/y+jDVeve4ojRtUFnL1LAm1HeXCTNiC/aQlfSPfyuGwtvGVlSAh/5YNklc+H6YoBiTB0jY5MzqtBs08gs/q0+6Nly7+T+eGpa6AvgTnbR34GEJrOaE711GRxjaAoU39YFNky0h/iBS+e2Hg4d+d6uaC1ejxvBGxd9FxL0Vzz0n+5hGAm8g+xBRvpIvQbg8Y1m2Yj/7FqMIZyh1kU3/xzxud3+Mzd+1YKAiq8EyvIsmnFTXF3NYXN2rDancSntguSxWn5TDqhm1QbIaMvEnzBdeBatmWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNe09l6Fu1V58gw2kfhvuUBa7M63lm/1emz6arfF9NE=;
 b=UWPxJX9UCrRLRxcEREmFCTV4T7Xz+6FHwfjFFuU2aw6bzsmMtjQZg/2pogFvrt3miVpbHbgDqRaNV5Y+qeltp/7LmFI6YdIYdId2uptxF3bbWMfWYIcXlgaGylC4d97quKnVW1rM/R8JmjMvKZYQGBLxk564BLEN32HBHIhApRbQQEDPyOCbDCFqvRLYTHIbOuHxBbjJ61/+euxjNGiIluNAVuPHS6btJEN5DUsX5mdXtMzysREMajzq/eLuwvexh2WAnLzlhdZAYYfw3wUKKonNDUYLyfzxLHWgERUW3mqSxUrsWQ0IgXwUPQlVPJ+N8AiFfHWQC/XE5kpXI2rP9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNe09l6Fu1V58gw2kfhvuUBa7M63lm/1emz6arfF9NE=;
 b=CuRBCUoR2cvwwNn3efhS9uK+rB3CtT79SNPEP3mrAYySCRQJt3njr7Akhbac+91zayDxq9yWzMq3KmtBh0VTw2GIy4NDoeD3f/bZ4qSTSfkueAEAqBJRZApyKifg085Zept8+2P2psvRUcySKwCesbiGWjqt03Sb288gXuJvb55oscKW5nZ9nHLkCJEjcasxHfD1PYOdhL0A4t4YkSFtnuJKlCaq+U4SLVInguTEBw0+6sIY9Nw+NPiJyo3fGylGNtKgu/dxXhB3w4DAaz3p8tb+R1Rx2KsbQtlQ3Ii66pUSZC2mRCu7e/Ap4CpukuZL7+7IGDYd91QZx218BRwFtQ==
Received: from BN9PR03CA0322.namprd03.prod.outlook.com (2603:10b6:408:112::27)
 by BL3PR12MB6522.namprd12.prod.outlook.com (2603:10b6:208:3be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Mon, 12 Jun
 2023 15:32:03 +0000
Received: from BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:112:cafe::9d) by BN9PR03CA0322.outlook.office365.com
 (2603:10b6:408:112::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:32:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT088.mail.protection.outlook.com (10.13.177.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 15:32:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:31:45 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 08:31:43 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: spectrum_router: Extract a helper for RIF migration
Date: Mon, 12 Jun 2023 17:31:08 +0200
Message-ID: <feb908c81f1578b8e6be229b40fd9b46313ea74a.1686581444.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT088:EE_|BL3PR12MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a24b4c5-fb79-441a-af91-08db6b5a2be0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VF6PAZitYqqhj0DxGyarg+t4261TsfcZoJEDnS8ixFmiAWvVRjzHXyFVGglAvoKsVe90qlczyOUJnTKS8XvjjOSOR5E86bLT4EFhiqnZUOiZNII6Hr/pdhn7MFwvr0LmMgoVBKLCl/f2hxkYjLS7R8Cm0DU/AhL3Yrqhdc27LnB6Qi4DgKvHwZQMYDwaRt9I6K70GbE4qWROtGt5VLBInFvTPj6zXbn3pcO4DijZvROCbzrlWjuVZoXYUXK0liTUEwlz/iAXDMgN9cJXKXgcGhOs+GofjMpjCHT/ZDGV1FDuHtkwDEBlhx8Bweq2nnP74XdSn1axkKgMnVGisXS6r7iuWuJ/rTLgIc3NRZPiF3QXDh5RfLp0/IMDNapI5G03TioJCFlad92/xkqkKi/nWfxa+mfDZ0TjXEURRIHyo8L3KdG9LcAA1WFxaGKRa4iSgKIXQXsMeo/yjeeQob73h6PHyC6uhol0ts1nbNQZvNiQxpyTvk3k6jv0WuQk6LDyZX8O5HeuirZhWVQ0ug2EPhL7xoLR/KuJLtiu61d/T9Ke1ZliFYnXB1wPgtYIVrpnTpOkQCPQhu8TiswZ80pWQHXTLz34F3od7VWaqX6jMGQkg83NCYtVAqjUElav0UvVs2EIPF/l/sX0F7ISNQTUx9SwFYCi5shLqoUZyOcdtQxgxPDxqE3AED25KeFIcY0ZkTY3+ZVtKp5GivTu7dfOfrWY4TcoTnEpUIwG4eCml2iEYK8plzDAcRiJsYevLtAa
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(82310400005)(107886003)(7696005)(40460700003)(316002)(8676002)(41300700001)(82740400003)(83380400001)(5660300002)(26005)(40480700001)(7636003)(356005)(6666004)(36860700001)(8936002)(36756003)(336012)(4326008)(426003)(70586007)(47076005)(66574015)(70206006)(478600001)(186003)(16526019)(2906002)(54906003)(110136005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:32:02.8243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a24b4c5-fb79-441a-af91-08db6b5a2be0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6522
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

RIF configuration contains a number of parameters that cannot be changed
after the RIF is created. For the IPIP loopbacks, this is currently worked
around by creating a new RIF with the desired configuration changes
applied, and updating next hops to the new RIF, and then destroying the old
RIF. This operation will be useful as a reusable atom, so extract a helper
to that effect.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 25dbddabd91e..fdb812152e71 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1651,6 +1651,17 @@ static void mlxsw_sp_netdevice_ipip_ol_down_event(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_nexthop_rif_migrate(struct mlxsw_sp *mlxsw_sp,
 					 struct mlxsw_sp_rif *old_rif,
 					 struct mlxsw_sp_rif *new_rif);
+static void mlxsw_sp_rif_migrate_destroy(struct mlxsw_sp *mlxsw_sp,
+					 struct mlxsw_sp_rif *old_rif,
+					 struct mlxsw_sp_rif *new_rif,
+					 bool migrate_nhs)
+{
+	if (migrate_nhs)
+		mlxsw_sp_nexthop_rif_migrate(mlxsw_sp, old_rif, new_rif);
+
+	mlxsw_sp_rif_destroy(old_rif);
+}
+
 static int
 mlxsw_sp_ipip_entry_ol_lb_update(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_ipip_entry *ipip_entry,
@@ -1668,12 +1679,8 @@ mlxsw_sp_ipip_entry_ol_lb_update(struct mlxsw_sp *mlxsw_sp,
 		return PTR_ERR(new_lb_rif);
 	ipip_entry->ol_lb = new_lb_rif;
 
-	if (keep_encap)
-		mlxsw_sp_nexthop_rif_migrate(mlxsw_sp, &old_lb_rif->common,
-					     &new_lb_rif->common);
-
-	mlxsw_sp_rif_destroy(&old_lb_rif->common);
-
+	mlxsw_sp_rif_migrate_destroy(mlxsw_sp, &old_lb_rif->common,
+				     &new_lb_rif->common, keep_encap);
 	return 0;
 }
 
-- 
2.40.1


