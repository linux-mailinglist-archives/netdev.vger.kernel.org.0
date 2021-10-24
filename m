Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8F438783
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhJXIeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:09 -0400
Received: from mail-bn1nam07on2052.outbound.protection.outlook.com ([40.107.212.52]:64064
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231290AbhJXIeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xu1HpVUdIlQn1lnxNNr2aFJ8kFyhzAHzS3GWWlxo5OFeDayBTLtLhYdahPYYCu7ItalrSbkMiW7wDPmkj7AEewCVLmGRK208GCKXGOyg1HTYEtc8XtDC65XxcCZjFU9jo1xbWkagWGwThUD9DpqaqHh87Xn5pzjek0mW6/PjdDKsy7eZGe4DJr95ymXwm0d/2VNu/zeQ2DWN1lwNckZP8W3+JRZEkkUB9M7M5qEfWDT86fTggkomJ07gHXa18mJzFzlVhTgBHzDcMDb9xtEH7PbeJTeB0OqWHAHOAUYmPOSPVuJ1KJnAMtIqHT3VUhPjUlvigvo8dCBF7vj/l9N/uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=UxwEGb1Tq9GCbfjoAuRX3+IQRB0eRF1folS+IMW7dnSiCw/O/NiP/Sd8RrCvcaJka7tb9JzVxESbSG+bIxi99chz+3Q0gjHyREAYDSCWmJ5jYhj34jon930bvF7mkHuzgwhlemtOyoeZLEbd9pX1fTpSSXJFIhWVg9wseVvQbbG8WDwXLEgstTyQUsLRzM41azQVnTxo+qyQnwIYvBuIGk1imGZVoPF/b0YbX7jFslpqRTAjx2rZ5wkYbu0Qdt6Cz7THx+0wXwdUhb064VG6oU5zFTgqPKCRvkODJbwzly0PnRgYEjTEvJBrHwizSXKQRUU1QWClI1EPXbrhoQymOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=E9719So0twS2RaXsq+pIDX3vriPnVdeqaa/Iy7b2jfcQPet+PmiLy3LiV/21Kogq2M2XEZ0d/XMT+67Gv+9UXq3z3dRR7E8Mv98cHZfI/GGxOAUDmz/Xyq2DIGb1qdPOwo7qCLtXtTfl73GYosaj5Opm+qxr2eksO9vlR/3FXsT8rQxLxRkmv6MSAjNdMBGoKSkWNe+XfpRHe6nBaFdl4F6F+JMXX7B/SooqaS6Uo4TIqgfOm7O3GPnS0Nraj4/7iGtLH8Ll+cvpKuBlgzxXcLiSlYxSMX71JSAEWwtYHeQpG+84PnIqxADlzT8A+N7EvyXOphO3uWV0vf8KeVFWCw==
Received: from BN6PR13CA0054.namprd13.prod.outlook.com (2603:10b6:404:11::16)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:31:45 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::81) by BN6PR13CA0054.outlook.office365.com
 (2603:10b6:404:11::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:45 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:43 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:40 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 03/13] net/mlx5: Disable SRIOV before PF removal
Date:   Sun, 24 Oct 2021 11:30:09 +0300
Message-ID: <20211024083019.232813-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 541e3490-0498-4d3f-fcfa-08d996c8b6dc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-Microsoft-Antispam-PRVS: <SA0PR12MB443267E868EF70E56041F588C3829@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VBpqrp2zkjMt3cMg3inqRKF4QUNPTvRYk2DBt9LiFnWKHwZQuwjen3Ae2n9mkogWNzfZVy8JylP6KZs7dQgc/Gr/89peovHqxRtDoi5um+mHKTDwDGcr1nms75DscpEqrmrUYv5Yj+y+yXtwak9v4JYcsRm0IdKiTuzAXLE+f08WDUTJnOzBE2q8hsyv6MH5s7h0FRiiYyULvKA0lMfDLcBjwHFcwpGx0UVKUs50ZKxC6G52DWtR07Ca7XvrjjCriYgKCuC7i+c1GWtNDIX1tB9Wcy6XyJ97wm4H97oxnJGXSF6Mi3GBAKD9BmELFNDLopaDDo6UqWtV3QQmo/6a/iFov5+NcYtWLD29GMHz468Tpp428+8k2QFn902I7yG/0NNmXa3VfiKj/NJ2lKd9tNM7nwjsQW5x0Uk7S3Zue5l51SroyF+Enqo30w/6vV7e1n9AdsYcfdbRrpPHmI1P95mWhE+I2xwWOEiENpO1hYl/uNVxkIV/fP16H23K48AtnY9qg3mSmh59cfjKTAFjrMTOJAtH78T0mWrnVerCQszHIcf0RRyGmgNIdUMV12lBRa7WDQpgZZT/VnsrV/XgH1L/zuH+sx8xbXIy0Fp/pSQeyeTASwdeY1Eaui4RfJujvinqq3zYJcaYye9LscQ6utLNch87XYJF+EYQSq9COldGKTwzCZQk2qvtuW7to1o/XM8Zlm+/mK9igcnyNprACA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(426003)(36756003)(83380400001)(70586007)(47076005)(70206006)(2616005)(7696005)(6666004)(336012)(8676002)(4326008)(82310400003)(8936002)(110136005)(54906003)(7636003)(36906005)(186003)(316002)(356005)(1076003)(508600001)(6636002)(5660300002)(26005)(86362001)(2906002)(107886003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:45.0390
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 541e3490-0498-4d3f-fcfa-08d996c8b6dc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
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

