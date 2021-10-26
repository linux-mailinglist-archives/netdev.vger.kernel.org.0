Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EC243AE98
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhJZJKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:10:00 -0400
Received: from mail-mw2nam10on2046.outbound.protection.outlook.com ([40.107.94.46]:60993
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233847AbhJZJJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqWR27zmUONEX6CP5+whAnvzmYjd2ANAuArG36nWBOHpLjYO6s0tVi0hLfd60Td9cf1pFsfp2Fd/6Xk/ml2js6rbGDJLhcpzhb6NrUpvEc9lIkLeo7MR4paWHKB6k0nWkVXMUjW4pADvfzkyG+j0jHsBukG246C748vQq/pdXEG+ppal5chwMWMlJmww/PrwQ2MXRfuARQ8KbKN1cYhgjxDHrCznFuuW9hLxX9FuQIrMKy+zQEK6iJ9y7CGSqesS2xV2su4tFV+nEFgCT6PEtgHfE0OSPSjohS+i8h9yqdmwz7poZrfk+xOlel9XYNAHNLkMlTGwGwZ+r6JglPaHUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=GiaLUboLm0t7im/SUxIaqHE+dEsABGsIoME+tQtRuddjpGKeGQwyuA6kgjlBPUQaf3hmEn7aM0bW8BPj1/RoHz7BrHzT41FMAfgFgTr3EOJtaWRPogtNIyZ/MW2tM5z6KQ9YPB7oTWWc37WLQ0YY7odos969RpG9rN+nvpfkjeIBDzOiYXcqqU/QjVmX6jYyPf1bOcfnibj6UmM6rNs4bsqX179Jzs2LjjUZfCt4nn2YLSyKMJw9zu7xd1FxL860IrYm0/jdc9j5mFqR6J2WK31DY82VeDiEJRW8ALGPAyi+Zi9/EqFJ+IUyDLFi90sN6Efvpl+TospzN6yfs81q9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=l54WGBOMpDHkiYngcNRmlH6nVNc1aaKY9j7vKHOTvnOpxwUQoJwR+hN1GLFrh6X/c77juP6PVADfGgDGXkXZ7PMO8vYXnj34KoB387+f5d78p8xMhxNK+0C+nsLNr2/xb6AOKtlxY7C1qoTK7R5J/HAzvHImiIF2yDhAOZc3XNNKw3amJMz1M6rzaxYcmKejNVnfJUS5h2myitIiejsmk6gYZxlu2ueZqmhcP8zx8G4So/6uytvTBCewHvG6BZHt69nUVIfrFCMqRqehnUfOpQZEiKjQTuI27rKGJY7xlTfJAh11+Y038YM4pjQ1yObtaFcl03WqYlkcpThE137+kA==
Received: from DS7PR03CA0198.namprd03.prod.outlook.com (2603:10b6:5:3b6::23)
 by DM6PR12MB4959.namprd12.prod.outlook.com (2603:10b6:5:208::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:07:27 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::8) by DS7PR03CA0198.outlook.office365.com
 (2603:10b6:5:3b6::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:26 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:26 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:23 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 05/13] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Tue, 26 Oct 2021 12:05:57 +0300
Message-ID: <20211026090605.91646-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211026090605.91646-1-yishaih@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63d1cd38-ba1d-4742-0899-08d99860082a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4959:
X-Microsoft-Antispam-PRVS: <DM6PR12MB49596F44746F54D6C61B5B73C3849@DM6PR12MB4959.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wDeGDDPzUrtF/WDYyhB8/ck7f23lL/pIsyPctR0cErWAMlM2K1Ksh2dXdSG8jIza+zL3LViaDs3z7U31hOGH1QeMGgtbcb9nUHYqJyqkDBdRcxIZfgPfhWLDOO1hDYpF8LW8dBbzfi9GLynMAt5OdHroYLLbbYTbZeRB0Yqrs4MAYD1DFGBuGTRLqbUsyCx/XoQ92Fn94etU9aCGBu1um6aH+AMz/axWAXVntkttBQh5GFKgCbNsuwTs0DL+0yIeImIPsa8bue4W+qGOpmR/Wr89GezsCgcCL5e/4pjVk1LaHvVRJ/yQ3TsjcPA9lMCwGW9jAVgaP2sauFqzlwa5mm8sqw9LdRRxS80c1IyIbNNani0wjv8FA63DxS8P82qRUjv8qdmfIQ3j/TWd0xeH8RUSpuSjZG3+n87mc1F8iJHeqCWtXDCcxFn8ARqkWzFnEq6FgWh3NOeCbtnH9CfW5XYTB+3D/ZCosQsOXE2I32HIWg5Z0BbWkzrwWN/l+32Ez0ZjaHLnacI8APe2rnZsGyflBNk/YMVfyspw/9iJfoCm+qGUE7iXPbz3B3bp6O3WFid1pm+7wMmf/YZfHRlaB6LMCB3V2ZQpvqEV2wo3ji7G/WaV4BqrACxl4mmLMJ1rafrTeuvuRM7oDFw4OzUetUO+GwkjMP6Mp0iuwjk6t8k1AmC0VV4BeXwDFNMTZYtSYBUu/C+TTfJ3RRKuJmrgWA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(1076003)(70586007)(82310400003)(110136005)(70206006)(336012)(316002)(7636003)(2616005)(107886003)(2906002)(8936002)(426003)(4326008)(54906003)(86362001)(7696005)(508600001)(6636002)(5660300002)(26005)(36906005)(36860700001)(356005)(36756003)(8676002)(83380400001)(6666004)(47076005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:26.9411
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d1cd38-ba1d-4742-0899-08d99860082a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4959
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

