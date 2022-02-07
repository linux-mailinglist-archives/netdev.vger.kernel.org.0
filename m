Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D854AC756
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359452AbiBGR1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346102AbiBGRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:30 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087BDC0401D9;
        Mon,  7 Feb 2022 09:23:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjFupO2kjBP0R0MIndln7qZaUd1jjZQscxLCzp9+tBb42vc9TBjKWSYB0O6ZuJxSNGnecDrVRBunj0gJuNwHDP1SG4HHYk/lpbU4qmmAAgKQVdGcV0wWJG/wv8qRYyWQxkKBUj4rTYJiKbBiY2l0DmCLmFQ+kSikLaawcwmf9bq/46PiErCVVN5uJxQLQl9yk33LVovA4I8VHci33EDgDQOULt0zghgTDSM1Zm6xMTtj9uHt4P3bFl3rwvffcCPtmqDN9BQlO/bpsQtsaV4CwdNPQxFIqJZ588qLlrRt168gOvVCDAZij9f8b+Illrbnut3OOtlvTi2xhFokgLpCGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=QdJUMPwc+kKjOgnpPeH7dPXy53aImwzlcnndX9QXZpk1x+B+JdC8ljogOId5jw7q7S4Mypz12Pon6jcF8JOI/UnyghiKBog0gtqOXNHaTsFWbIWAP0h5iHfG0rbnICIRKwY9rV0RvxskNMdTXRRacSZZAA6D2A3NIpoOZB0c1zl1axKKJ2FpVyswVOE/aoXtcF5dEvnjB/BwP5rYSiqGq6qqwO1W6wu/ebw4kBbSG0RActM2iOFEoSISAhAPmYsT2i6tGPXNgNAL6EqajxCl2COQ5s195zhQNFKMh7r0Yq5LWhSG/2NOnd5eRmu4w4iJJDrc6PUyIw9sithPxlptUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=TAqkjWB+THf5ziMqtkMmCyda4cdgCySyqzpvG58sVDauLMrNDAiqlR70fmSnT95QhFjDE0lSDDa9ej7cyKhrHTH6E1k/ne7xIuHqgmia37ccdEw4NOxx2taDZnaUnhje9ia8sZTi+pvWhFFAAPWDlTglQAPvNakYgenhRQ9FKGE2SdcAaHRbg0epE5evp2ReumCR/D1HiDb8FOij6Iog381Rn3D6ciZN7UaFQxvHw5fH2fSx7fQ9Fj7AKmYRPyST9SkWTxHbYsYuqaAHga283gcV7Ck96qs5pce4gPDD9ZhCrNdSjkDZLxtFYKMV4cpQS/kJ6t6jmcUTxTC3y0PRRg==
Received: from MWHPR21CA0054.namprd21.prod.outlook.com (2603:10b6:300:db::16)
 by DM6PR12MB3435.namprd12.prod.outlook.com (2603:10b6:5:39::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 17:23:28 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:db:cafe::b9) by MWHPR21CA0054.outlook.office365.com
 (2603:10b6:300:db::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.4 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:26 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:22 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 05/15] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Mon, 7 Feb 2022 19:22:06 +0200
Message-ID: <20220207172216.206415-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efba22ce-a0a0-4470-a6a1-08d9ea5e8e0f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3435:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3435E35DA68E346740C6BAF0C32C9@DM6PR12MB3435.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rcj8wqHfUbAslH4F6kfBugbcv4NmEqTW7g2EE+Ppu+ePqjCjGeQnTOu1/d1KUbEE8vGhSpIGWEmfwvYDEET/D/fJaILDydddOKl7f7ihJ0rxGYkHLuHD3d0+sUxgAwSNuhlcl0pw5PbluEUoEqQyWoYs/L1dBb5UvEdzBRp8OLHbmYH+YdrPnHTu2GRh+k4rutgQdhZvxU7EROuMzLplUBfc7hcNBEVsOmcOOXEOGLHIYxNIg2fhbscl0KRe8w7rBLo2n0s4/xiueUYJLX60N8G4sPHoxOZURjbYoaGTyJIX+A9wYnsA/2pWjFRcitIyVddQm8yY2quLoCUlr8GUfenypTlG0X9xqnbKl+w5T2eW8483bjEbA1l+CcLvrZhSFufWsjSTHJSbuYoQ2OXyynNLK9qkvJP7coYVtDHQB5OBAFihGKPlP42GhHeBXvLXgyDieAi75tXmXT6L9yITFTDikFpjIL8uYR322XGPZR6gvC5r9ssAOX2Jzy2k86dNCB+9tCdldQnD41OnO9EIMtpeyxA/Ffj12LHH5K8OdwQnCXYs+BmRA68k7RFS+pRkhXC/YC+zWM/o5wyMA06Uyl3Gh3vdRQjkgbRW77oCPT1mKP0iQdpjpn9+f98hoz44ovuVh8PfTLGBqdG3Bo/3Fn5X+KYoX/LeIEyE9etUO839v6lNzZ573X5m0/YWDbbgmmuaZ/6UCsQG5COsWns0mbPSZkTJFQ1smrLmVgxxY86EM/Uf40PRQfbBJWOyBF5W
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(110136005)(316002)(54906003)(7696005)(6636002)(6666004)(2906002)(508600001)(82310400004)(40460700003)(8676002)(70586007)(8936002)(5660300002)(4326008)(70206006)(86362001)(36860700001)(81166007)(356005)(1076003)(336012)(36756003)(2616005)(26005)(426003)(186003)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:27.9289
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efba22ce-a0a0-4470-a6a1-08d9ea5e8e0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3435
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

