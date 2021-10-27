Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AED043C707
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbhJ0KAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:47 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:45624
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241309AbhJ0KAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gq9BjPFZ/8yDm3hmjaMOec4RtH83GvA/mKll6Zv0a+BgCMx3cmfXqOn2iqzp3lw/Hcczqi7N/FWZ3uZrY46rp0vBqcsGWBUFrojAi0Q0nlxv5KuSV3m8Y6ZplXMDaQvDtRLtptvLcXMy3f9WYcrbvLwxRt2Yddu1rLHj/fOFD7FpNK1eVsNbiOUIKiJGJ6lI64HxS9T/VfkUBZA3Zpmt1tixw1lAVm2P+j4izNXaj2iV0/Tkv4jsWcDZ1Kzi/QgKLm3qzMGx3MY04i5WrSb2XMDVmtcwyR0kbyCXXLqVK6chiZZAD6CoUEWFY+YJtszvJ/IdMUA4L4bx5pLwK1F/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=WSCow8DFZfy+E2RsnPr/dJ2nIrvxfFc4DF6xCaPzAN8IIub7oBSo63ePQESFHRKuSySl2lbKBucKzBhemoxvH12gEP2AYg/46WQZgopNY598cSFtzIoc+BjoF3JLRSWdAf06qJWmEVCw/0q5+ggTJzGCperiT1WbuYXK9cH6+laMsvhv0Y8MxGhwPJfr0pezMFnbAF1TJTxFZZ6hTQLx5MVgvqnoGtjw5b8BJ7EPojlmPWghlwnIxbzVCC0NJlQolmEAN1j7nws/bZ293Pmw9/MOmUi8leysbsjgIgCvEbhfjfAvUXX9tvnX7TrviDFy4+xRWB+23vGwbM9k54W6CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=oOgj721RkdAhF6AGLEYARgA2D/Fa9+VmBXV/q9KA8i80dUiHQnkABu1NxXBGr7Ysro7Nrm/ihvfnkCiEYwzaCHD+p5jTz8zsFjjP/ygB+rGiQFRcS441xg5C8NMqLmIfuPKnDUnKbqA9ikxYy9pvufkKVSRsnPUPFillcMZOjXTWkF9VOuRut89clYAGTviEKQpXE0VqVP5J4uCnu+4ZXCjzekQ9qQk5dL4LoI8yDHnpG4SLF9JbU/9rxqDbC2OC1T1cJqcqzHXXd1iYyX81lPfvKgF3Za17estyKy//WXInja8CAMMcMo2dRD8XUvnb8W4y9+0u58SyfF9Q9tevHg==
Received: from BN9P223CA0021.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::26)
 by MN2PR12MB4535.namprd12.prod.outlook.com (2603:10b6:208:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 09:58:09 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::e3) by BN9P223CA0021.outlook.office365.com
 (2603:10b6:408:10b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:58:09 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:58:07 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:58:04 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 05/13] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Wed, 27 Oct 2021 12:56:50 +0300
Message-ID: <20211027095658.144468-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211027095658.144468-1-yishaih@nvidia.com>
References: <20211027095658.144468-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eed23909-cc11-4cbd-e7e0-08d9993047d0
X-MS-TrafficTypeDiagnostic: MN2PR12MB4535:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4535264A7DD38C3C9400733BC3859@MN2PR12MB4535.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bHIAQ3Sm97Ax7Orld/anhq6zulQaHfJkviYqVhoWW5H66w+RrraythelsPBRzt9qoEUFJ9jtUDsPO5fYSwM1SUAqXuKktrN/7K+nYgsdvjGF93+atYR1zRRNngtdgioo/c6OSTTOYOEESuZhmkxWgs3ZBWPE/+B1AeBkndpEarKfMrZ0/yYhMsIy0ezfa7dAzwVRZJawfZT+92PfY2hcU7I20WdKsvEb8jlPVRf148E5hXYEjCTkbPwGxxPRi4lIdZRNOZV/3cg2+XEZJ6Ax9fFnC53EuGsFkptqv5GeDCW+CVEZT2iPGYmFfiiZxLLh97WiKhfFWH+oTY3IS05/YFarIMUSX2D6cY6QScangdJABhWsxO/hoMzCxNmNGHdWyQ+wsP4skOpU5FAhC7I5bDFpSGg4kzgCEhBLVRcy1roRBx3YMDu5tjHQFihzUQTinhuxede3jiuoUZEcO+d3kU7oqHpiOQ1gGzMTTuLSqHdfJvnHGjwjP8F3KdQ7u3cDJBUrc4Rdxf/n/a1NsC+Q4yYKjC4g0udJyixkWuYST9qD8h94O5sddpmF+ZTu0sYSnkiKn/OZYiA+KL9XZMnaMtcQGkYAxs680G11QYGTSBT2YeM7m3/tYvnqbPwQFS4FO8KKKS/Yzc9wCAJoe4hs7Y7tlgyL31RB1Yl9+yH6p9zUBz8+H05889W31H9aqmMvHLoxaoBFZuqqQL1Eq9/56A==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36756003)(36860700001)(36906005)(508600001)(6636002)(83380400001)(82310400003)(6666004)(26005)(5660300002)(426003)(8676002)(54906003)(110136005)(186003)(7696005)(316002)(47076005)(2906002)(1076003)(336012)(7636003)(86362001)(70586007)(2616005)(107886003)(8936002)(356005)(70206006)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:58:09.0339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eed23909-cc11-4cbd-e7e0-08d9993047d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4535
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

