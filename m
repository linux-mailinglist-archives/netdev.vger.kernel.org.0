Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21F240BF08
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 06:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235806AbhIOEtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 00:49:08 -0400
Received: from mail-mw2nam08on2053.outbound.protection.outlook.com ([40.107.101.53]:18785
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231277AbhIOEtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 00:49:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h63OnptrU98yChz5QUE+n73qolSHjPnyLOcKv/kxMkjzJzvSeo4Xl2aKjQjaobw3xmF9tI0FTnv9za1WKWyVy6X1qUtjysE1Du1FIAtTZVAHr9jlFGv6ulufZoMgs5DVDwD1aFzeT6pbYrL2L4qjZ4G6c3AMeDE12dr4YtSPL8PERUk9FQTJbCJkBTzW4HBKuLhv/HpuxQrx4my7QlLJBaC1BH/0xHqWk+8shHPsiGuEa4y3vvv07q9z0L4ribbJiZR1u35kwGyMW5UURgAl0Lb2GVPDWfDrXLpscSLvhz30gPx1e6RbgdibK/UN5kmc+AzyGYIR/3ny9fo+4DePsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5sjBzbVxpamheXt9wCuNcwtcIjsYoXzm3rdBUSOY2nQ=;
 b=VGyyrMy6y8DVX7OiCFhoSIzrV7eAiucfslNjG0Cuw5SGEmDd0eECVx0AP2PMekKp+tfBnY7bw9Ux0VWVCF8+y4JCg0pGxc1gec0nBqTpqitsExzC4OnJKv+ik/YdjaGrPSzrqQULdmj/8DvuKXjIkCKqMxH9HN3v63p3gwNn8oVSxImbCrOspZtOOHzUAM27o6IyfsT1F8qfvXBt+VlnlvhjVf6oIJxeeDHTdZ4IMshlB6lV8Zh3NOegQwZXBT8w91cmv8xihaHpsNMTLuy7+VnhYE+CvY4KUNyQdxdIApFoVyL68J3d17OxGxkSTl2hZASZBThc7EquGFLpdRZI/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sjBzbVxpamheXt9wCuNcwtcIjsYoXzm3rdBUSOY2nQ=;
 b=qHzspfUZFXIY7RMzBfb703vFTr8ss8X9Qi4LYlvswLdrHcRg/j1Y3ygy0ielSeAC26vTOHrhQcVtAH3tJ2GU1PxQTQ3CVQG+L9/EymNjhGWBaNEzIgDmS3g6aFifgs2C63srU0agYFj2FlowyNOQ7nECuJC1/qVT/H8RC1qjX4aNW6+X7+c/ahMXS9e1r4Ty7qlLaiYSjACxhE5h3ZwL7ouaCfh3jBIMLXr9Pz92YUifiih6xy1PHLUq0b7mxRj5LNmdX9GrHma8+5pvownHqZWX/ab8leNZf+jODHN2HOktAJPDaiuMvZ3pfxAp9Z8vuTtKgLR/0okZQWKIsgYgCQ==
Received: from DM5PR05CA0004.namprd05.prod.outlook.com (2603:10b6:3:d4::14) by
 DM6PR12MB4283.namprd12.prod.outlook.com (2603:10b6:5:211::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.17; Wed, 15 Sep 2021 04:47:47 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::92) by DM5PR05CA0004.outlook.office365.com
 (2603:10b6:3:d4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.9 via Frontend
 Transport; Wed, 15 Sep 2021 04:47:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 04:47:46 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 15 Sep
 2021 04:47:46 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 15 Sep 2021 04:47:44 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <kuba@kernel.org>, <sriharsha.basavapatna@broadcom.com>,
        <ozsh@mellanox.com>, <netdev@vger.kernel.org>
CC:     <elic@nvidia.com>
Subject: [PATCH] net/{mlx5|nfp|bnxt}: Remove unnecessary RTNL lock assert
Date:   Wed, 15 Sep 2021 07:47:27 +0300
Message-ID: <20210915044727.266009-1-elic@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbe2ff39-33f3-4d0f-ab99-08d97803f6bd
X-MS-TrafficTypeDiagnostic: DM6PR12MB4283:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4283A68B60E71EDCEFF4262EABDB9@DM6PR12MB4283.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HONt8TsqX6G4pCbqIBzK/Xcln3/i5b47J6v1qgFrSHjm96dSvDoefI+mAsdJqQy6qRbB4T927aoeKHDqcuSm193P/I9cjVy2d5wk/IDGgZLBVPqQZzf3aQBQ9+o3EO0bgSzhMUATIdp+qWLD6A8mGFPMBquSOA1EJR5Z2G0qIdQhR3ihXfHK3vAOlJ6tjcv+lIWW1vce78xczOJ/hOB3eaBIHi+GPkdILGk5SGLW61mgxwJActQ2ysQEIWVJusX6S84tM5z4uOiCCMNH+Kr971TvtFhPCQk+MLOtzQLvvvpHqPSeIRPUDTGh1oPddRje4dAJLXPEBaLejUsS6oafnRh+Boz/1ypCBkPkK412dbO52pElz6FTeqvGQe/viyBvT29UOs9/dzMSP0igzY6UDPTOLhNLGRSm/p1Xl0TopsE4WMaD4OjlbsDw4+Ys451RNs51euUWUe2bkAhD2hdSqW5yEEv4fvlydMtkB/cFHYkffROKYCpc607Iiqoa5JfkUYgORD6aB6sMMeJBoiy8dSalSJS0gbyducFNpQpqCJMQa/DLGpMbxr6Jb4a8tdsMEy/sT79tCiihzqhBgUUQLIiNwMjriTK2+0OOdg7r/aWKr2H4l+qxmA/Ixshzpdg+a4YUhpIcXaEtoJVRq7WDKdge6tIwuNbPKM/j3xsQFrDug+L/7e1q4dysChkpiNK9ShsT28TT1KgnOtIQig8REQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(46966006)(36840700001)(26005)(478600001)(8936002)(70586007)(2616005)(70206006)(336012)(5660300002)(7636003)(36860700001)(316002)(82740400003)(8676002)(86362001)(4326008)(7696005)(6666004)(110136005)(2906002)(83380400001)(186003)(36906005)(1076003)(36756003)(82310400003)(47076005)(107886003)(356005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 04:47:46.8426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe2ff39-33f3-4d0f-ab99-08d97803f6bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4283
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the assert from the callback priv lookup function since it does
not require RTNL lock and is already protected by flow_indr_block_lock.

This will avoid warnings from being emitted to dmesg if the driver
registers its callback after an ingress qdisc was created for a
netdevice.

The warnings started after the following patch was merged:
commit 74fc4f828769 ("net: Fix offloading indirect devices dependency on qdisc order creation")

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 3 ---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 3 ---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 3 ---
 3 files changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 46fae1acbeed..e6a4a768b10b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1884,9 +1884,6 @@ bnxt_tc_indr_block_cb_lookup(struct bnxt *bp, struct net_device *netdev)
 {
 	struct bnxt_flower_indr_block_cb_priv *cb_priv;
 
-	/* All callback list access should be protected by RTNL. */
-	ASSERT_RTNL();
-
 	list_for_each_entry(cb_priv, &bp->tc_indr_block_list, list)
 		if (cb_priv->tunnel_netdev == netdev)
 			return cb_priv;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 51a4d80f7fa3..de03684528bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -300,9 +300,6 @@ mlx5e_rep_indr_block_priv_lookup(struct mlx5e_rep_priv *rpriv,
 {
 	struct mlx5e_rep_indr_block_priv *cb_priv;
 
-	/* All callback list access should be protected by RTNL. */
-	ASSERT_RTNL();
-
 	list_for_each_entry(cb_priv,
 			    &rpriv->uplink_priv.tc_indr_block_priv_list,
 			    list)
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 556c3495211d..64c0ef57ad42 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1767,9 +1767,6 @@ nfp_flower_indr_block_cb_priv_lookup(struct nfp_app *app,
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
 
-	/* All callback list access should be protected by RTNL. */
-	ASSERT_RTNL();
-
 	list_for_each_entry(cb_priv, &priv->indr_block_cb_priv, list)
 		if (cb_priv->netdev == netdev)
 			return cb_priv;
-- 
2.31.1

