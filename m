Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA78F357EC6
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 11:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhDHJLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 05:11:15 -0400
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:1453
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230360AbhDHJLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 05:11:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AA4j+xJojwzP+17Kraza7U3Wwsqe0uid5d17uH7fyHFxonNABQMcvS7GtZCeegO7jxRIT36Z9FijFNT7VtRLxWy5rZ6k9fZGdO5CVXPu4064SuFF8B582YlfviewPeEGxjRrQh6U6KIirDF5MZUuaIbyKROP7++c8MbWCtkMCOIhoNNukJfbXX6sW7wtFYUnK5HsMPdBThjxgR6cEq0CSrdpA6YnGtztYtKJUDDtQx1ZP8cxqRUxufjMJKpAbvIWvuk9uPcZ/rV6wwNhb83UvEL1ETfqtBFXOHuSF04PhLdL4bd0UFdyBVscdWP8LTqKnsZkmiuR5SQ22CAbHzik6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlcZgYgrgCV/2AMLFsa9OHbkLO0EqJZiTcUFRFtyvdg=;
 b=m1kDnUUPJJ+5AZ1ZlkyaOYXH3mCrdrBXBBhgnbhzeGL0SP7Hq/4oz9+pKHUqjv+fg9TOZTbPW1AmwANp3vgU1sjMNIh5jzBsllOoIGw3YlBulTpEyS9RZF2N9g036lNf3LJtEi0IMvrj2R6hfc4wwwCnc7WELCtj72Q/KXiiK/YiOrkr/w0NjFhozl0FOOfqAUEu6cRlOqXAirv1MFGfNBfWFYdeIGfFYJ5ZBwfvPnNpJF8S+lDXoy3D9Zcg2FOnm01Q9iX4j67NQqox431Xo0d9K3XDzeWZU1ubEK4mq4IYnhVKM32de4WbwOa5pkamuZcmWMJP+AN/uHCR8QSwJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlcZgYgrgCV/2AMLFsa9OHbkLO0EqJZiTcUFRFtyvdg=;
 b=Q4zbRCeiI4hLh051cwjq+Ub2mMgosx0QzA1oM29dKNgkl/KvWduLrtPQbCXE4+NA73961wTzZEFsNBo+vpLcjiKFZf9vunH5H17vhsjNxFe1KQyLJR6BInnPwyh0IosKLOEc5HHzeodtom9+Vfu0VXAgVDYRkPm48Jl+9RGHPke3jwrKj2ySqUsSwIBIf3ixSzDahdIRn2yxCxyAIgWijWHXf+uCD+gGweu6E6V+uduHcGGVq1V8bUf+bmUfgocgd9MAaMF6vgnVvnHmYqBipu7fkldDFSMqwmIJPNolfh4CM/s0+TNJk+BKor28WM1cK++q2Z24UTxfVld2RhX3Lg==
Received: from BN6PR11CA0008.namprd11.prod.outlook.com (2603:10b6:405:2::18)
 by BYAPR12MB4709.namprd12.prod.outlook.com (2603:10b6:a03:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Thu, 8 Apr
 2021 09:10:59 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:2:cafe::47) by BN6PR11CA0008.outlook.office365.com
 (2603:10b6:405:2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 09:10:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 09:10:58 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 09:10:58 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 8 Apr 2021 09:10:55 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>, <parav@nvidia.com>,
        <si-wei.liu@oracle.com>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Eli Cohen <elic@nvidia.com>
Subject: [PATCH 2/5] vdpa/mlx5: Use the correct dma device when registering memory
Date:   Thu, 8 Apr 2021 12:10:44 +0300
Message-ID: <20210408091047.4269-3-elic@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210408091047.4269-1-elic@nvidia.com>
References: <20210408091047.4269-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14dfed17-a01f-45c6-c2bc-08d8fa6e397a
X-MS-TrafficTypeDiagnostic: BYAPR12MB4709:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4709DDB59FEFCA43A2719E4EAB749@BYAPR12MB4709.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96FszvgrHwYyygsWfNLZotPmTOdaH8zB4bx7mYjq0Cs0bbbbUfZ9b53DiuV/bdFJrYOPt9R7uaagzgjWLWPe3kJLUobWDbZg1PfEA3G0Z8EKULydVArlHzfP3vKaWo9GM/VG+Ch8Pt0J/rtiLox/C3VDRx24UsPn3wxYVvGYYexC/SKYjGy9nVpAd9MtKrRHBeAB6XBH8rKF4zx/XdvJXH3C/WvNOAVTHu3KdPTcVtTiRgPtqxFcJgPSrJHizWrdkvyJSxlGb9TrbPzPWaCfCvHcKhNQUVlA+Mnx4iItGxsSMcjWZ8FArNjx6CfcWdItqxNViKFmUqkteAbmbS0Cmm4P1jxkEcaaqGUi08nHxutLeRpwE0ORRzojUpSeJ18i6I8ZJrcAjczPLXMF3+qX9OMmOmjY8RZMoaQTV7WTOqBOuWh0yWSHsIXk/0125Sb9/ErZOgpLzUP6HCbv63RpxJXwYSU2+4S/QnqSonFhYbwmV57shWWvkY98ykGFcN+pnxzq6ntxoMr73h83yJa51GM3Y/TQYFvIqi9hKA8RNkoJQsURRTgsFx2ZpODzB5QYcg7d8Bjv+DTenzQ/pootA9b4DXJ6uVqZucAdCu1eHlF+vz2yOz/M7JGD72IbaQY68znjHNcIdHx0mfxZFbnTGIbLObkSMEZk2Z0h7D/T+mQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(36840700001)(46966006)(356005)(107886003)(82310400003)(110136005)(36906005)(26005)(1076003)(336012)(2906002)(54906003)(7636003)(316002)(70586007)(4326008)(6666004)(70206006)(47076005)(86362001)(36860700001)(7696005)(8676002)(186003)(2616005)(8936002)(36756003)(426003)(83380400001)(82740400003)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 09:10:58.8829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dfed17-a01f-45c6-c2bc-08d8fa6e397a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In cases where the vdpa instance uses a SF (sub function), the DMA
device is the parent device. Use a function to retrieve the correct DMA
device.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
 drivers/vdpa/mlx5/core/mr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index d300f799efcd..3908ff28eec0 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -219,6 +219,11 @@ static void destroy_indirect_key(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_m
 	mlx5_vdpa_destroy_mkey(mvdev, &mkey->mkey);
 }
 
+static struct device *get_dma_device(struct mlx5_vdpa_dev *mvdev)
+{
+	return &mvdev->mdev->pdev->dev;
+}
+
 static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr,
 			 struct vhost_iotlb *iotlb)
 {
@@ -234,7 +239,7 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 	u64 pa;
 	u64 paend;
 	struct scatterlist *sg;
-	struct device *dma = mvdev->mdev->device;
+	struct device *dma = get_dma_device(mvdev);
 
 	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
 	     map; map = vhost_iotlb_itree_next(map, start, mr->end - 1)) {
@@ -291,7 +296,7 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
 
 static void unmap_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr *mr)
 {
-	struct device *dma = mvdev->mdev->device;
+	struct device *dma = get_dma_device(mvdev);
 
 	destroy_direct_mr(mvdev, mr);
 	dma_unmap_sg_attrs(dma, mr->sg_head.sgl, mr->nsg, DMA_BIDIRECTIONAL, 0);
-- 
2.30.1

