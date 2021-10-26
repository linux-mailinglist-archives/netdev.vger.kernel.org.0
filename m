Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA7843AE93
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhJZJJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:09:58 -0400
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:40832
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233574AbhJZJJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbppjNnWtOt69sS0DKkGGWBr2HgAg6XA3088Ev1xfG6OnCjlG2jEk+QsG4k/ThhaPCGJ2+RVYAy6WnKbdzbGzsTrw08b/OYWifruK2zX8cJ06H32wqYjgnzlwCvdN2ln6nd+KpW2ZDaZWpsZfjS6jR0XLk+S0JzPKg+xzXYGTCgcpk7SjRH0xGMQt2GmCXSHPSfrP8PBK7MZuvJB0OE4xTizU0Hcm5l4jrAgaR9ejZmxXDcLhRcvSb9aSsnZ351dCZf3ZFU/3Bwemxxsy7gScAypsaQ0bPAq0M7aQoYRamDtf2uUlniy7CR6dLy4JEl4mXCAQt68AuJDkHQwrj78Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=CWo7E5X9ZmY6zLPsH7dK/VahHA9a4lFA6irQaJNejuSpkt4GiPRU11gU9p26OVxBQUpl04NxiPjxz+8lEByeXRkcDxLyK85ejI7ypokoV3HYgtLQpG1mQ4cHpS43xuQ7rXI3X8yK3dGa5CXfiayYXgW3D4K8K6kUnMVxN3h7caRQKfXtG1+JDoHiohFQWVWGm43TykZXnpiAUZ+Qd4J8H2O+kBcN8eQc3iaZC1hGDtglPm6KHkuL5Cp+wup0wN7aBDKFxvWir1zC7GEylDamFveeaB+VVoJL8i/O1zMJqRSkwnWUly5JYR4li7lvThnSK7FfJqVwPCyOUiom0rtS8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATQOdGVF4dTjbvMJ1bmmazMNjFwWqMg4M5PKqHqf20k=;
 b=nj7Pyf0DXX9dWSi1pV7C4xwZWTEpXwcUeuQZ1zzyW/LoCBJ2o/EX/cC+WDnhNj0X2qVFIVHo6/plkITCx/GkD5KtO9RtrQ4uv/g1IuCzTUbwxWYwsqUmI2zt2QDmhMqAEoIxx63vbF/l+8/rBtiaY8c0zCpsabK9xiUhr+qKjaWoPyEbuPNd2dYYdsM5sdMHdcGCbIMEFUf2wRhUOfsC8f1PzR1BXr9xPK/Gec3T7Jah1hmQmLwUT9a9CjtYBhuIfdnGNuxbzgYjk/p2TtQc+ghcE+IpE1soyyvwrsLThNr1e2tMUVMqpA7ySuhedCGRKGoTvLM+lqLKrJ84tLhW3A==
Received: from DS7PR03CA0192.namprd03.prod.outlook.com (2603:10b6:5:3b6::17)
 by BN7PR12MB2804.namprd12.prod.outlook.com (2603:10b6:408:2f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 09:07:20 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::70) by DS7PR03CA0192.outlook.office365.com
 (2603:10b6:5:3b6::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:20 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:19 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:19 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:16 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 03/13] net/mlx5: Disable SRIOV before PF removal
Date:   Tue, 26 Oct 2021 12:05:55 +0300
Message-ID: <20211026090605.91646-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d72313e1-7c9a-4f7c-9612-08d998600410
X-MS-TrafficTypeDiagnostic: BN7PR12MB2804:
X-Microsoft-Antispam-PRVS: <BN7PR12MB2804C4A6F0F46B51FAF04D89C3849@BN7PR12MB2804.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tp/X5+F+aiQJ3zFCNggTkV5zc1NA/+L9NXE6/1ZDejvib5bXoJMl7R+IagifC2EtJ6cskWca6aHRxjo1QEDvuk+rZjMUNngIUWOAiT+LuGjkA8smE12krU1Wyki7Oa+hfcOu0hjHlE4+Az+0iEWSVhM0FsR9bvIcRca4gvu3qdb+8rsB/TomX7xA6mHka75LDKfZwswg+hzGopa+0v1aOellPItMOzlLtv+g+cYM6I3zX/hiRMZycOOnIYCzHk4nQ09ymvUyaK6d5UGbc/Zeb1UdDCRCaIWK7Aui+hQn7YwbVnchp3SmTJwA+wVBsjgcifxDqjv+lOT2Be7lLA8qx7ypdK2wqrd4WLVatgjSERrK0VWxykCNsfqOSUwnASvJNIRkXuOhStbuEyyaqfHmZYxtF2qEX2ZvYt78ueLNToq2nqJHy4flouDmxdjHCUBjl8kYrRDuGUbNPnePLDsPJU8oa8U1ymjqPc3wUFRNyOvmQGlozoXLOnFn7DdePTXsB9/UVcdf2cKdhrIyQuHkX8SZuk/l0LPiDyu2L29XpyIdz4PQKIyclkzFleRfyVfw7ADjbGqi+/unqJJM/7cwSF8plEyI6qL2BTZCZAZsvm0D4DwwyFfEQSrGz7No9hww9jpxvcXBxNeo/5IlvHYOH0DkhPFflTM3jodTpbHFWM6qzQ8NGdYkrSDaBrvRCn8dkkw9abCM7JTeEB8DB4kwuQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(5660300002)(107886003)(2616005)(86362001)(316002)(8676002)(4326008)(8936002)(82310400003)(426003)(336012)(47076005)(6666004)(1076003)(70586007)(36860700001)(70206006)(110136005)(36756003)(54906003)(7636003)(2906002)(356005)(6636002)(7696005)(26005)(83380400001)(186003)(508600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:20.1104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d72313e1-7c9a-4f7c-9612-08d998600410
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2804
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

