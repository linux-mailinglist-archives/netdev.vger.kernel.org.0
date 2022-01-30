Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337C44A3798
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355590AbiA3QPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:25 -0500
Received: from mail-bn1nam07on2059.outbound.protection.outlook.com ([40.107.212.59]:28932
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355585AbiA3QPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MCOJ8D0/1PfX6pxQa9JbcZM6yd0LB0wZIOsWG2xqKriBSVUtoN5FZkS92lIv3iFBmFknPwnPdzFYKVxfx2NoYBQ6gVDa2WTbMCl42ofpwhe0mJzqmksu1WZxY7cqIaQZq07lEx1DDjouNA1fy4xeQqA1hzUXchpKIytUspUU1LF4+Y7fOELLTYj0CnP9RRDg8fUno7lfuAMqZLeR4CEh2zMFAZfZ0aepHCWQlOvrx5+6QQ6pnN6jXoCsg21gpRbUZcB5uxHn+TOGtSRbXN8g2KCl+dqVw9QyQA4RgN7oxLWrE03eIt1io3BQHzJoyIHs0dMr8k6zPOBK4gJRvY5YDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=DzKCtCixgmlM/IxvBFVddxgqS4bQn3hyfWiyiUa8d38R6KPSUz/rjk2JwCHyj7IxWQQhpIvWHEQ3/iWJ+3RSpf9cscNstO/gYF1XtJada/Y9+uDbd7M6TxnUI3jHwKcYTUuqC5XsYdCwJ8tB6YlEYq17ZqzueEdTdxXwPUx7nNxh6Mg4gkuOebIG2GfiPkiEfzwQLaW/idOURKQngknAt3sej65NLtihbG2xShfoU6/PGqydCriAqIyDGZFIea7CIw7kN3FgeG/2gK54c0KtA7MuoN0uHqYU1c8egYtAMwWa4mLuAu3U4TBnmbhv8hxPZzoiIzo0M2eKOKD5O9ekzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=GVE7J5OdNbUjCIiX3kWhvhaPwBImIWIVoGWId4fp/vtrlIsFcfxoLIsqJ0W8q2Sjbff1Lx+ystThNCZ6c+6AM6WSS2lAwVJbVyLWZhLVl4PHSwiJoYGPBEjzebwFWAegvxFvnfI7vjaq5csqjOgCbDHmj0vYLZAfjtRUmVZPObpV0/eixJTml4pTDQfBLwm01EiGqnuGbM19ZZJkewTvuiCWqLoWPEMWDhmV0RtQtkEjGkTaib2gzyRgSrblMgGGHSDRyNJweDaVPXhm34DiijOE6EbmxEyz0q7hGn5ofPywdKnIEofdJ8SSeZWu2xfeTukW3qjOGGdXL8Fh9+98VQ==
Received: from DS7PR03CA0347.namprd03.prod.outlook.com (2603:10b6:8:55::6) by
 BL0PR12MB4884.namprd12.prod.outlook.com (2603:10b6:208:1ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Sun, 30 Jan
 2022 16:15:03 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::36) by DS7PR03CA0347.outlook.office365.com
 (2603:10b6:8:55::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:03 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:14:59 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 05/15] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Sun, 30 Jan 2022 18:08:16 +0200
Message-ID: <20220130160826.32449-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f40fcb2e-00e0-4562-f2c2-08d9e40bac1a
X-MS-TrafficTypeDiagnostic: BL0PR12MB4884:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB48847049C96DB9E7A57CE256C3249@BL0PR12MB4884.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qKrZG0Egx29Iauvgg2sgI+Uefjbku8B2aPiqIY5Sy7EsHw4BSyX2hVinCQRxiN70kUWFdiLooNb0TuWQsTA90JbFlEhCyTMdufr7hi9xg5KK8GNulxYKgyfm4YLXfTYkr+jKEjZv4Vah5FjlVzK7XphN+UhSDt/IYYpeCuMiU6/8ODE/rkBYMUfWiGtvwDuVC/nyxqSlJF7kWxXNiEzszdLGS0olAz1qGKgFeoJhNHP/jA+nADSIrxY8q406Q+vHD+nPOy4jbVMoY+9c2DGx+eZ9FjM5otGapixUgvce2Y2cUpDbzvzvqRBMAddYJZvwqZO0eC8AXFe+tYSM9RpPaS3Q9rJo2IoAvEyl/cM5xIXDCa/hWjLI7ekT4yCD2kAB8290yyWs54jm72H0Bsxlg5XQLaaNsddXqLdPLjY8JnLrhX7SSs3ON/+A7Tu4kEOyFtfogTFPG0m/xC4zk4CEAKAT4E6IXD+ZE8JAYTejPK0/HSWpR81nbl2/y3uzcv8ghPSkB70InB4dr+9dldsKn/BmfjxDViZrUmwMyxHs2AjF7A9upfpZrO58VBSIOpgg5rudTsyxjoj4o/ZoQ1e4gP9UsU7bkO/diODZgzXsp2YfGme2y1/Mlv5B3zbE+ZJwpMM0R4eNt90B7MTkf68m3TMDWwGEPi99XNxIQRCt/DPWFR+NBobNYKL7pLERmtypAv0Tv92d9YSkizrSJ07/nA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36756003)(107886003)(426003)(336012)(26005)(81166007)(2616005)(356005)(5660300002)(2906002)(1076003)(186003)(40460700003)(47076005)(4326008)(508600001)(70586007)(82310400004)(8936002)(70206006)(86362001)(8676002)(36860700001)(316002)(7696005)(6666004)(83380400001)(110136005)(6636002)(54906003)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:03.1606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f40fcb2e-00e0-4562-f2c2-08d9e40bac1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4884
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
 .../net/ethernet/mellanox/mlx5/core/main.c    | 44 +++++++++++++++++++
 include/linux/mlx5/driver.h                   |  3 ++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5b8958186157..e9aeba4267ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1881,6 +1881,50 @@ static struct pci_driver mlx5_core_driver = {
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
+			__releases(&mdev->intf_state_mutex)
+{
+	mutex_unlock(&mdev->intf_state_mutex);
+}
+EXPORT_SYMBOL(mlx5_vf_put_core_dev);
+
 static void mlx5_core_verify_params(void)
 {
 	if (prof_sel >= ARRAY_SIZE(profile)) {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 78655d8d13a7..319322a8ff94 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1143,6 +1143,9 @@ int mlx5_dm_sw_icm_alloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type,
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

