Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4043341A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhJSLBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:01:47 -0400
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:43232
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235315AbhJSLBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TO+rlkTIB7I3GipoCT9vQhOdzhOl5bemBSyh4WZEAvSZVuML/iQfQbK33o1MPUSoh/bQijtcGJSZ4c6ZmjJRWUXyihQ+coIoIcvvabtFRJEXwFrenfSRJqixBzCJQuPoaXkhRpmfM37dzwYdCCozQh4vePomdTVmXC0pZXuW7iVg8X+/h25qF3sbbUDeMsouupvI30GW8bQ1R68VTN9pLZEmhGF9m6CzWAauhuz2QhznKBKOLAgAB8y3eWyD5mpS8sQBUqezefuWDZc7oUQTLpXZxidxqTzYlE50o8Ucr6YNoni8W52wlM5dBOg0wneFIb69Ej9D0kvnJCbOC/FidQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=Q8nZhcY4rBZoLVHYCLFF0IWzwJwnMVdvWTCHTZArPEIFI4WlWkz8kLXVjELk84vufok2F1vJHVhA6niUrDjqk0t++XA/lSO00+db03B8t+MXwxArErZjb+d1p+LsYh1A9c/5eM1+BZswebnj13WfVSmlgXqJX8ouAnWrQTIiTtk98QjKw7y5o5QVvOVHQFOm67VaB5GKVl0HJEsqENhdzTl7FL/W4HCeCVCyxBB6cwV0+/9ja7OVw9pS7xkVzA7N1c9HoIYVf4NU9pe2Q/dxn0fE0VZBuzzIWBCo5bKckijZpBP+BfREF7/8Xa9JE601Y/IQRiijRRYgUMJCHdFQvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=d9klGhN1FrWQl/+r+D/TPIUOTHgFBmjaruPYrlXhrPZofVqClxTfLIKTix6UJ6Wlvi/mquLJbSm+mkCoLAt5k3X+imUjlaNn3zEfz5FZKTO/uHz6g/Lj4Aj2JBM9+iKTof669UiOI+QNHQhuT8V9lxdYo+MsPs4HLWuG78LO2/xz6HGOFnowsTy8Isrz5Y8ZxMIo1fzd6JUXoU2DM3omPiOwx9ZpWtKoTHVz+8F9DCptgreysJ/hJdHIWlwS403jQ8/5UvWjctvcBRRWUZIyiGnx0gfZdY2+l8KTaJ35itM75sZU3jKvIzKtDlEOWnLT3p55R3RM4XxVkSPWrWvtYQ==
Received: from DM5PR04CA0072.namprd04.prod.outlook.com (2603:10b6:3:ef::34) by
 CY4PR1201MB0197.namprd12.prod.outlook.com (2603:10b6:910:23::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 10:59:30 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::f1) by DM5PR04CA0072.outlook.office365.com
 (2603:10b6:3:ef::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:30 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:27 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:24 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 05/14] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Tue, 19 Oct 2021 13:58:29 +0300
Message-ID: <20211019105838.227569-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211019105838.227569-1-yishaih@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5773b9b1-14b4-4608-acd0-08d992ef86ab
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0197:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0197C8048E4438F2746E390CC3BD9@CY4PR1201MB0197.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qlA7fcjHq5W7Wpjx13LS95N9NaBtQPqL5WL5xMt8hcVhthIsqkie0GjDPlDqyotMunzQEDuMN3IvEa1WjUZWeNuo23tCAUHM4jFnjZ63knazczQMUoma7ATHoLbqp/E9TDpwu1rv4kFq7tTwiG5Jiq6PEmcxpHxRxvCGtzsfl5bDblA8jvZq7nkyczuanJk8b7qLUzvaO1DaGpS4fF/ilUpqxdry8/M+EogWYlGh12MOYx+Y2FL5AgLYUF7MKEny3SpdwgV2GwZvjUlo6dzAcUreFFBqmrp8pgDsg5F0mhBfreWQk7LRCbbk2m3L0SBujklUxfkgJchFiGGMBZ5Yd+G69j2tAWBcNxhJKIZK5q0Z1tHW7wqOZRY5ehLCZQRSHqfSAtjxfvUTBR2X8HkvowiE3YnNORmPuQHve8dRiBsT3N+wml60HyEy5AtAz4dpsh49B/p66Sb/nfqjRbF7JFEDyeLZDBO/KXVBuoF1kc68i3s2ejOGjPSRvARlx0+/IA5Unp0eKVYGXyyYHw2RCXSrr8pHOYOZSovd+8WWwkVQFb7iYEKA/cQFKzBgLznsAYdwcs+nNwTYw6LAnmpC2gwvgjk4BGEfIuWujcIwaOr+rJEtw5D3OHCZFT/GktcN5x03Kei24RVvZ6J10tdG5zwBbci6ZojVda1LFENzjZ8DNPYYxreHAejgrjapQzQS7sjpUvwWiJWBmW1c63a33A==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(107886003)(83380400001)(7696005)(8936002)(1076003)(508600001)(26005)(47076005)(86362001)(316002)(82310400003)(70586007)(70206006)(54906003)(6636002)(8676002)(4326008)(7636003)(36860700001)(426003)(110136005)(356005)(336012)(186003)(5660300002)(2906002)(2616005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:30.2803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5773b9b1-14b4-4608-acd0-08d992ef86ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0197
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose an API to get the mlx5 core device from a given VF PCI device if
mlx5_core is its driver.

Upon the get API we stay with the intf_state_mutex locked to make sure
that the device can't be gone/unloaded till the caller will complete
its job over the device, this expects to be for a short period of time
for any flow that the lock is taken.

Upon the put API we unlock the intf_state_mutex.

The use case for those APIs is the migration flow of a VF over VFIO PCI.
In that case the VF doesn't ride on mlx5_core, because the device is
driving *two* different PCI devices, the PF owned by mlx5_core and the
VF owned by the vfio driver.

The mlx5_core of the PF is accessed only during the narrow window of the
VF's ioctl that requires its services.

This allows the PF driver to be more independent of the VF driver, so
long as it doesn't reset the FW.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 43 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  3 ++
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 0b9a911acfc1..38e7c692e733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1796,6 +1796,49 @@ static struct pci_driver mlx5_core_driver = {
 	.sriov_set_msix_vec_count = mlx5_core_sriov_set_msix_vec_count,
 };
 
+/**
+ * mlx5_vf_get_core_dev - Get the mlx5 core device from a given VF PCI device if
+ *                     mlx5_core is its driver.
+ * @pdev: The associated PCI device.
+ *
+ * Upon return the interface state lock stay held to let caller uses it safely.
+ * Caller must ensure to use the returned mlx5 device for a narrow window
+ * and put it back with mlx5_vf_put_core_dev() immediately once usage was over.
+ *
+ * Return: Pointer to the associated mlx5_core_dev or NULL.
+ */
+struct mlx5_core_dev *mlx5_vf_get_core_dev(struct pci_dev *pdev)
+			__acquires(&mdev->intf_state_mutex)
+{
+	struct mlx5_core_dev *mdev;
+
+	mdev = pci_iov_get_pf_drvdata(pdev, &mlx5_core_driver);
+	if (IS_ERR(mdev))
+		return NULL;
+
+	mutex_lock(&mdev->intf_state_mutex);
+	if (!test_bit(MLX5_INTERFACE_STATE_UP, &mdev->intf_state)) {
+		mutex_unlock(&mdev->intf_state_mutex);
+		return NULL;
+	}
+
+	return mdev;
+}
+EXPORT_SYMBOL(mlx5_vf_get_core_dev);
+
+/**
+ * mlx5_vf_put_core_dev - Put the mlx5 core device back.
+ * @mdev: The mlx5 core device.
+ *
+ * Upon return the interface state lock is unlocked and caller should not
+ * access the mdev any more.
+ */
+void mlx5_vf_put_core_dev(struct mlx5_core_dev *mdev)
+{
+	mutex_unlock(&mdev->intf_state_mutex);
+}
+EXPORT_SYMBOL(mlx5_vf_put_core_dev);
+
 static void mlx5_core_verify_params(void)
 {
 	if (prof_sel >= ARRAY_SIZE(profile)) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 441a2f8715f8..197a76ea3f0f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1138,6 +1138,9 @@ int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
 			   u64 length, u16 uid, phys_addr_t addr, u32 obj_id);
 
+struct mlx5_core_dev *mlx5_vf_get_core_dev(struct pci_dev *pdev);
+void mlx5_vf_put_core_dev(struct mlx5_core_dev *mdev);
+
 #ifdef CONFIG_MLX5_CORE_IPOIB
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 					  struct ib_device *ibdev,
-- 
2.18.1

