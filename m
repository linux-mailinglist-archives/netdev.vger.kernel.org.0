Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12D4BCDF6
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243588AbiBTJ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:59:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242828AbiBTJ7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:59:06 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9401F54191;
        Sun, 20 Feb 2022 01:58:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4m+x0MarzeMSf8LfxX7SbjaNqzDpmZaL4gW/Y+znHf3Jm4F06y5hKgTIqli/j9XGwX9Vih7XUW1PabkC+h16fpnnmBnxuZUdZRh62D30zFxpnmo2vVx+F2I1TEos3zRusZ9ek0/yZL+v/MaJtrMvoRQKI83+8u0Go+Fjnn2RDlVz79MVh3RYEL7IW+EpUQY2bWavJLVKSWo+1LuxvgsEfQ3VkBAIlzDSYIVQ3yY3RrmXnNOjOBdV+PRHNew/aqrYiXFkYxPwK0i+SeaZanxXl7B3vbG0MEwP+UjQsEL6eVlP4lACNZjJqSY6fn4Rt9vNkPKaWLkONwAgf7JcX04JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=MAJYFVsDutKc+PYDMqnluj8JHd+N+aYitNQokfrXiumtVKsbe2Efza+NoUfvmKHklxihNfzdMbY0XDS8QIMN5C7E+1BHpABPULNJvHhY9pTQ/4/+1Qx9uGCHP8YGE4ciQNINugqaPu/wgVOEMFtDyo++TVwF76s0jLBZ3FaE3Ek2KOSjDmgYmxFscuCU6w45zLSI1XDLPDDjwJ2wW45znVtaZCsl/JI6qHwoQ9oqWtoqYp47NETlEY0u60sXAV7HDsv+8niwN60Y3Yg3+6TQKb+z3auLcQbHNtEPL7N9v2m9a+b4FkulH22Ah0dsQ5RGbVC3j59/XX6XQlZ2fzpkMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=TgfblsNv7B2qCoZvDiesk2NVBZ5tYr4iLmJj5iVcmUG67RLBLMScSWLtPQlRlk1o7uofAauFonqFigdl3Q2X8OOMX3KkeBN/PPt8vc0JWj1tGK/J7ZZ/quvn6UgmQbE8U5YbfzNBzPoFJBYC8jUQ79oZFZaB3ML/hTybBVdSSqzYCz7i1wuDEbsEtmxyCpJJisxmwPpKs2Xnh9NFwTfurYgv+CfBTYHrumsq91fIOMzQ+/AIrVg8HE/1yLKrUTm3ggn13YGnZeXVo7kYerVo5rDT5rW5gVTGGxw64dQxJYyh02//1uP3PSbaguJRWFiHy9fgf6q46wSQg3qa5rybkQ==
Received: from DS7PR03CA0129.namprd03.prod.outlook.com (2603:10b6:5:3b4::14)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Sun, 20 Feb
 2022 09:58:44 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b4:cafe::e5) by DS7PR03CA0129.outlook.office365.com
 (2603:10b6:5:3b4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:43 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:40 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:35 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 05/15] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Sun, 20 Feb 2022 11:57:06 +0200
Message-ID: <20220220095716.153757-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 689cde50-b9a3-4330-b505-08d9f457944c
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5609:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB56098A86EE3627DFD366AD4BC3399@SJ0PR12MB5609.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UmS8mUHlkHPDBKTLFpekjhIheYQC4ibn7GgbX7M00RoiqEocf1OjLwxzaDg0ghlL5geWYvjER6pTi/U8XoN2zO7HccoiM15ClReYn0lbZQH2HcWZcLMwhwxifpIF0SdFW/18ftGK6xCf3G2HCWzsK4VEeyIWtjWigxUPCP65Hu2eeFJrw8Gpv/U105wBjheDBJEIxjI9wGsy6bXiGp68a+jyw7/V1GVpYrVxBaPGVAi63izat8ulZurJNdFU2OF2sfrr8D9Zzep92ljrhkdZexOfOc395KEGDU8DT0VZzSNi774cp2ofqFKiuR7vvsCT4uJontYEdXTEnIy68SpNF00bp4rPB9xxXFjggkRQ35zWtWFkzUIjn5Mzrl5nBKSfxfuHXTNTtmT22cjCPOzsf3PF9jzmXVx9a9Ub2OHTGT+sTmvN+oCTf9nApv1uZ6C2q6p3ztaFYgptxiQ1hgcUMjnCBczDuSwYSr7W1B/UqvuyzOLOdUCqwH3R/Z2SZojbRmy+K5V3N9bRuNlU5foUWaj2EO7BeaGmGKY7JW468e4sNqLa3koNbyLOVVIRt3H4l0MzkgRmf2lJrVpbPtFG6ANn1WaQXnNP7ZmXvY6QkOiNKSU4kzLFerlZ6yI8JMxdjkLkAdBahqL/RHseYvnfmlqf+CJ0dg7Z1wZ2EF1LcaXf6IxadmEG3KcbhvYJdlvV6N29NXHfgPcrLk9qHtrxFQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(8676002)(1076003)(81166007)(356005)(70206006)(70586007)(508600001)(4326008)(36756003)(83380400001)(6666004)(316002)(86362001)(82310400004)(2906002)(7696005)(5660300002)(7416002)(40460700003)(36860700001)(186003)(26005)(8936002)(47076005)(426003)(336012)(110136005)(54906003)(2616005)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:43.5773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 689cde50-b9a3-4330-b505-08d9f457944c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

