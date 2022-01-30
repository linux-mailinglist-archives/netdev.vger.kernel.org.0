Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEADD4A378C
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355619AbiA3QPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:11 -0500
Received: from mail-bn1nam07on2061.outbound.protection.outlook.com ([40.107.212.61]:50563
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355559AbiA3QPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ItX97/hYrMSrKTjUCKaXKPLysarO8SEBiTe6DrgOTbZOxYQGiEtZLtJpwjX3j5JSRXT+ruwcv4egk5zG33rMU2EyndLaLflYCEkzBgP0Tf58jf67aJZMyEUjOSgrAy6oLAJnTvxIFPDZCcZyVzFOZ/bixEP02Qe3/O+wXYCWwaABiIVU/z5CkK+0lg2hv/8r59vqATuQZYSnBc7zn0eo67cGhiVJZHc6R5HoHvJCubI/NTAkxyP+wkjLybsCkj2fq7WmKryBrCwwdabSIsgLoqyZeJTnk8VBV5bZ1YnBKJrCh3l9mb0H4SFngnLAL4bBJcBa99tV5XJ2gt2BJHelFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=Bf3uz0JG5l/QKS4DoPH+XJkFRzbe0szBClfek6g+m/ix3kLLueHPvipkQajmOUyEwexef13FC7RVcozAZBG/LP4QDUvzo5KdULPC0KF3i/P6G4jK46GsM7aLOFyxwAMjoiQYQbi+VvHd8CJEJ/fMc8N60zzz9cmzj2NQCxcmENVNnTOFwL+G7u0mP6pu7GRERGYrob/t1P4wRqAIDbRugE4gThWaVRM2hSJBDMoWebET7fZq+vpJyC6JMdjfbZYwYI3Foq1hA3J/jejL7Sc+tODmlqGx+YZbQTwZLr0SeNlfJuJjUkbh6wOTCRMBJ02dGvO+vFUvzBMz+u2qxuUQyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6yP+UcaESGvVDA99CJM19WVOqvMzB4Yg0hQqHcAhk4=;
 b=b555GxN91+9fqgv77gKUGrViueqVsYY/FEqbDTOp+O9G3Bmouell3YL7bIDb80j7wQ/xSjnkQWPwlMNX6tk1nM+A7w90VHfj6LQVbF14Awafxlwv/DtoRyteVwVD7zRgkFqBYFYsdzyIHzyf4ytVXV0GtlvW8aCYKStnzu1kVaqZZyb2cBilwU0QxQoOJZ9CZG07jV9DagiP++YHWfgRWvcHnGQPjR1yMRZ9TV5MJ3/isPaJol1ghitm4njthSIXb6EHt64jxxog+cLwdDYqJsV5/klZ6ZwVT49dmJ4S8ZucX16lQ3RzJ7Lib1HkVa+Mi8/cOKJ5tGthV8ovhQ123g==
Received: from DM6PR10CA0005.namprd10.prod.outlook.com (2603:10b6:5:60::18) by
 DM6PR12MB4436.namprd12.prod.outlook.com (2603:10b6:5:2a3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Sun, 30 Jan 2022 16:14:57 +0000
Received: from DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:60:cafe::3a) by DM6PR10CA0005.outlook.office365.com
 (2603:10b6:5:60::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Sun, 30 Jan 2022 16:14:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT056.mail.protection.outlook.com (10.13.173.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:14:57 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:14:56 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:14:55 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:14:52 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 03/15] net/mlx5: Disable SRIOV before PF removal
Date:   Sun, 30 Jan 2022 18:08:14 +0200
Message-ID: <20220130160826.32449-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc9aa207-a038-4895-4179-08d9e40ba88a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4436:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4436E7E47512383E077978BEC3249@DM6PR12MB4436.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yo+CQ2ilfI2OiqZ+Zym9DaBmPIa/p6gXkhBRw41yDxKGCtELkxBUTbVZnfgBAHQSdcz9IoZrrfUx0BYD9C6OcLWHyvoSx8+PjH6cg/18hQ28GUNCft97Ja+YUu4YS/tJ1avQrUtemEDp7tckkZ1D/+RWF3zb4n4HEoC0xxi9YE6RoKbWY9vL6iWMQS8rchWSwMZgAUcE/biRDWVImoGil2oCsyFLz6lb5uGZEQLr/pF57e9kRNBz9dMDMAH1zDoTrGGxYKvCO4414W/Gk84EdPkWSMhAnp6UnItlwpSdxoj/1VEzLtVQkv09xdYQENLhbXcZ8dGcfRxdhEHyzLUchdUJTJ5Z36iZeA4d2EcYX1H3njkX0u8kcdGJ5wNnv6deILJQ8Wpi8o2RUa5qjyJWp2qPw/41xyJXtC59VK+tQSebzYmQZrmNZQwFQ1fy/uMXUqEP9FC8TsBVO3XuPmNIk6qZq8/SlXS3d7PrTJvzOj5Do7dWKeL7eCPzn0d697cea0qV26eeA0kfw1n5YWDCF0bEthOI+rmOicFa+gE9Aww3/yT4cjuVFm/t8lifqf2nLfS+ruP6QXsf95/Yu+l3pyFQcq597aB7q1gdScMHq+bnEa9PkrNkknoQRt7J3SkVKJSJ45H1XcHXYA9iVzUp18Fhgelu8L82w3GnLwPsG2jgEt4mJ/i3nHwZFuImqRjN+eTeZQaAqhbaMZQmSZc7hQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(1076003)(26005)(36860700001)(107886003)(186003)(336012)(2616005)(86362001)(82310400004)(40460700003)(83380400001)(5660300002)(47076005)(36756003)(70586007)(70206006)(4326008)(356005)(81166007)(8936002)(8676002)(508600001)(2906002)(6666004)(7696005)(54906003)(110136005)(316002)(6636002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:14:57.1635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9aa207-a038-4895-4179-08d9e40ba88a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4436
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
index 2c774f367199..5b8958186157 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1620,6 +1620,7 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_unregister(devlink);
+	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6f8baa0f2a73..37b2805b3bf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -164,6 +164,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
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

