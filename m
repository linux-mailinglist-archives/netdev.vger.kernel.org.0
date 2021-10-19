Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D6D43341D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhJSLBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:01:49 -0400
Received: from mail-mw2nam08on2055.outbound.protection.outlook.com ([40.107.101.55]:55872
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235320AbhJSLBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ycez+8bDCi35bBAufWDKHhb6GUvklOLNdCUc2w8txAxbzwP/Nbyznwb3a/nvZYCzOJ6GWj+RWqC5aZtR3UKOPCsS2DlPoV4lZQKtaFWt6q2cl1ecPzfvf7Gp2SUzQWz4QXUQszbj8c2hd3a49xugoYT9dlWdB+mHD846KErcJzwapswQSfsar4K5+6Uoq/r1mQ/vQBYaVp20mr76+5oR7FvwM2X9/P5d/LqdVSsYZTa3/vQ+HzHPLuh6JPJ+S6E3F9op2ceI33+zglsKQxiKSWNdfx+2KfLU4m0M186OUQSkef42b/NftIsVvnPSRpVHQ7krsNNUNGfnnAfkgxz0jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=QJXNyU5qVveAM6lXFMvl5EZm0WBjZ2UgToeK/4594M0VSmDDbGRlCulbh+hQrpWH3bBvvqYQ95Z7V/WJ4/YAEMvx1rgnsvnLktf8IolpPVySjLPNrugVWpsJsBNm4l/1VR934KEqiK2/u99HyC09UDZI4v3pP9W7/uXM5WayjTa8c35SJz0HLs0pZv8hVQ39VdnWEOsHN6uH/nCHqM3iJxHio6mMac1Vx0nud/YD3xmEmbC+PV4/xyoSjP0MF2z0zGYWZCqIayKEIVZlrbqoSKxrDw1+fT4CCdtc/rkciLfdYO30bdTE9wwHz3t5NNx9+4+OvZgkMyXVuQhc5EeMIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=AmMuRecHoexdCSocSjKhnYlJORYzxL7rA7F3v436vfvihI/9SZ6XFMHaN/lM7jSQq6Ev9zNyrwLptOXNDEv4X1z4CqgO+judlRQSJaBbpClUm2Hom08p8/XqbgzB79bXYx5SjHT6K/AGOPdUDuIW7luIy9TtJeVL2ZFKCDqAWOePMyNmPz0hS4Qb+DcJt4FXkMHYSiMKJcTucK1f1kMQ92kNH5qUXUctAcbPLz4HtGIGrAD8D4e7U6AlOScSKVkC7BZ8gy8xetkrgc/LfNLVUtMRFevIVbalMASFpsfCp925/iJjz/DI7buCZiDiSJIy/yiwQOfLI+fFM2Fimvo4lQ==
Received: from BN0PR04CA0016.namprd04.prod.outlook.com (2603:10b6:408:ee::21)
 by MN2PR12MB4256.namprd12.prod.outlook.com (2603:10b6:208:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 10:59:31 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::58) by BN0PR04CA0016.outlook.office365.com
 (2603:10b6:408:ee::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:30 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 03:59:20 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:17 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 03/14] net/mlx5: Disable SRIOV before PF removal
Date:   Tue, 19 Oct 2021 13:58:27 +0300
Message-ID: <20211019105838.227569-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbbe4664-a2ca-4ef6-19e9-08d992ef8732
X-MS-TrafficTypeDiagnostic: MN2PR12MB4256:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4256C4594ED02EACBCFE96ABC3BD9@MN2PR12MB4256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0xIIyclpzT74vTaRCorz0wK8AtoGFoMEfDr/f2JROKjXHjQoMEoKGJFR+0zWl2Qstha4z+HbLzSNlzbPIpC1wZfYiCT2svHjb7d8tCv9fe1V+n9bA+PobI704CfKjWRsV0N2KqPUXr0DEiLah3wnAIw270Anb4zmk+TX5Cet5BxeegBZUOXGMMBbvNcYVjXLXko1ytgPh1hkg6hD/NPjDpPPZxetgIiigrgkGZvZ2UptRYL7vO/jnCGuwYpAtz+deD57y+37NUZULsAAxaVrF4mixMhdeHhTwCPxn+vWgU75YVo1fF1ojuOsN0MpJBjLbF40vX8bKuqYgagsEihYtbzjgwdxMJCvTPfaSA6JFIMfpvsqcnztiX9ruLSwEE0X7ANT9bmv3rAgcRxpKLZkTUw/zl7ivfzzTc7C/H1qO3rdXfmdHwi/ESjAj+V6v8QWtpKRkGe7uVg9DobAtZO8o1F8vw//bLfSreKeLVRDWlJycu/CtuIW1bngrGU0tnN7TIgu2szsni++TlLsrgMpZgPW3ERBv4HvClkW/eqGyTGKRtNPxa7VGN/hrrBfpj1taGqJ7o3wnwAMb3nA2DHqPeKyIiUAYhwSG8xsFL+ke6lP8TxBZnipk4jd8CTjBfApLGR5jQG0NTTazoTQdXvtK+reCQZ47v5E0BpVaiOXS3i+LWwT5XYEEEJD92oBUoinvXCXdD/BWwfHzK6vumTQA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(356005)(70586007)(5660300002)(7696005)(1076003)(6666004)(508600001)(107886003)(2616005)(36860700001)(7636003)(336012)(82310400003)(2906002)(186003)(8936002)(70206006)(426003)(6636002)(86362001)(316002)(47076005)(110136005)(4326008)(36756003)(8676002)(83380400001)(54906003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:30.7755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbe4664-a2ca-4ef6-19e9-08d992ef8732
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Virtual functions depend on physical function for device access (for example
firmware host PAGE management), so make sure to disable SRIOV once PF is gone.

This will prevent also the below warning if PF has gone before disabling SRIOV.
"driver left SR-IOV enabled after remove"

Next patch from this series will rely on that when the VF may need to
access safely the PF 'driver data'.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c     | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 79482824c64f..0b9a911acfc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1558,6 +1558,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	mlx5_sriov_disable(pdev);
 	devlink_reload_disable(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 230eab7e3bc9..f21d64416f7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -140,6 +140,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
 void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
+void mlx5_sriov_disable(struct pci_dev *pdev);
 int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 24c4b4f05214..887ee0f729d1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -161,7 +161,7 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	return err;
 }
 
-static void mlx5_sriov_disable(struct pci_dev *pdev)
+void mlx5_sriov_disable(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	int num_vfs = pci_num_vf(dev->pdev);
-- 
2.18.1

