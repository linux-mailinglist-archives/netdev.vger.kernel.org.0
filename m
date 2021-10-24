Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE32438788
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhJXIeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:18 -0400
Received: from mail-dm6nam12on2059.outbound.protection.outlook.com ([40.107.243.59]:16865
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231564AbhJXIeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j10VRmCf3xGUTRvmVke+JNJ9vSIrLTJUFmwKejAjfkEhGh/vYn43HLSn/oOk7OQhKKrfPQTihNftqrNUIUIgwVge8Qh7Y0C/LkHhJaPjzg39fErUA3Yst1hOEZLbpPJUMRAOS4fCXJVClA5MJeFavfwhkjSwdG2n+PBwRupEkMwv1A5Jhs5b523HBt6iMZB1vzcFpFjmuFLcM6/5vLwzrwo65fY52dKuykMqF3hA2W9DmznT4Bo4tEhBAqqOzRdo/uMp8d95htLiU0cYoMSyb2lHgAG+ml/o6RxR62DjECB1ykJP8y+ogJdF9o5UZBa9TrQ+Yt2RYS5BpCr+QIodKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=SGM/5WyQiFedKLhgRGeSt51bs8U3p9iwIg62/gXzWEExN2b/C9Qf45DCkEm4R06eFM0U7bNDWN3OYG65m1KcVX96pUxhMaQdjCJ9IqGwhRiI+h5W3CZQ5hWxQPYuETE3+gEVYftdl66JYcrhBzFrkf8Zl5HUAUn7jXHZXf97CBktvM2SWHvEEgPiA1PbCh4y1ZjvHN4gspy72hvCPhxVHalGT0YNtYlB6IZobBUcdEd1BKLOjoOWEsLy/Afd4hXNpWjjJ2zB2/3XcEjDKDyGmA/2/W6AgXp65uw0eznxpD8q3HS1Zf2yvabMnS29y8esWxTaeo8AJLI6gmOuXnDvsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=rxrDpXNKpSErQ7TUV+yNIUWngZm0TVMYim07zMmg6r7TnrVt5Ago8q22diPVRJSdTsVSnGEdyeLsL863TuQ5YxxoO5I2Kv1I83h9jiKubLCv7Wgwmt6bg9YzwhcnkvOMTZlfXcN1rZaUnhIVdFJSUA/r4lMOtlqvK/EF4C1Vs7qrP9dw/BDm+lJn/Ry2KagLTBc3hVALHMAuhnL1WUQnpvxgzS9YihMRqBA86geGLh7ltfKRlw0CC918iCz9KkfKdGCM4yBo777RzOwoZsrrm6fOhksVfxoBmw04DxSXfImeuDOqGy8VdBZxayO6ViKbZ8oOWAxnFucZmLB12bEqCw==
Received: from BN9PR03CA0276.namprd03.prod.outlook.com (2603:10b6:408:f5::11)
 by BN8PR12MB3508.namprd12.prod.outlook.com (2603:10b6:408:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Sun, 24 Oct
 2021 08:31:52 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::6e) by BN9PR03CA0276.outlook.office365.com
 (2603:10b6:408:f5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:51 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 01:31:50 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:47 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 05/13] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Sun, 24 Oct 2021 11:30:11 +0300
Message-ID: <20211024083019.232813-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7ba1389-37bd-4281-9bf2-08d996c8bad0
X-MS-TrafficTypeDiagnostic: BN8PR12MB3508:
X-Microsoft-Antispam-PRVS: <BN8PR12MB35086D53EBAC37BDCDB36B3EC3829@BN8PR12MB3508.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zsHJpSWvEhJeeOi/TPVqnBveQ6/fX4zcCtpby6pLSyYutFD8+UllGmhbUlTRqcY9ZF5fgpODeBZcRZxwLZ9yDkvBwLHJViv3qU6p14DJcm09t4RHhkT3ZgtkwzfhyxeK/NOgETODUUvVcVrH9pp+6bCRbwWgNEnRZl5Ki9qmktrKD4th33yX1B+VoF1zCYHW+kqTB5hiyaLhEfpjUkJYY0/44Ua6LG2B7U4H+5/xq7jeCgEYrUvmmqmDbKElPtpljFZb4+ca6SLMkJzgkQx5cruMH/Cw8AHGtKlR/FqdsKD3lWzfySHqYBlJ2XQ98jdEKEZZN1YlT+5f91aD5peYZjCGagCyqvlY6fY3uE2d9LrWowldPcAtg0T/WfyRPAM5EAnyTrTHNymq17eYXfObgKVtaaVkBHjpZ73UJXpRP2QMlh3XQc/uHD83PFJNiyueSlSW3h8qpbRdgNcK0AJvUlJU4AyAJUPgRFQVyTpAywJSHpTNc7YagO1TdF1Z8+3Oy8GbVhEn1I9zMr9PkIhYvoXQslW968YoZeP57HZ/GIpH5Kkhp3reFZ6iaK7Aznvs+15isQLRoMU2cDf25rNuK85zZjUsaf5GYayFLsHK6RbEdXBCRewTH9p3KyxMGmZkqiFkYEgzGY638Z6wFsrRNlUrzCvbhl25cwvRDHv3YIdwnbYQMNap9diSOeBi37JfJlfL8y+cjsT30nUxG6hWqw==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(1076003)(5660300002)(2616005)(8676002)(86362001)(316002)(110136005)(508600001)(36756003)(7636003)(8936002)(36860700001)(82310400003)(6636002)(426003)(6666004)(336012)(70206006)(70586007)(356005)(26005)(186003)(4326008)(47076005)(83380400001)(7696005)(107886003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:51.9865
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ba1389-37bd-4281-9bf2-08d996c8bad0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3508
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

