Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F0142BBFA
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbhJMJuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:46 -0400
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:48044
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239088AbhJMJup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kflvq7wvoFGOKlF9APtW/MLy+MHHIVY0KUMkxUgUgWXJA89N2V8TO1JavP+j+yzY3HLFwsOtQRBt9r5WKDWoApWkirUXFvn9sEcyX9Qkvn0+mI1cdEEmsMa4Os03uv7d5wxIzxGkjPvpBrQYbumWJKC+iqEGJIl3G/qjMq1tVuswDR0/oUXxi2TUOzWDBVPq+sfZ9YONndcv0xf7Y33FnDctxcyDzhtKI1azm4h81tuxgPbKVTyAW3YaOyq9atRi25rXL++YXlCAx4EEpoz+a6/9XZfEQwHxIwrIxANgU67MqAHY0mNgEivMlgBuqwO65u8BiRrO+spjMRwYkYU/YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=dYsRC7zbm78bU6I+4BrINBTkznDMQALnIhAPz393APClsFyZqobbc3BKtcut4w3QIN/SVFc/cxrHUWO4U64NbT/vIPTCyHC0jWQpY2vXhh8f+zmK10CD5/cnSUHk8A/8FXh3Baqs+PkR22GN/K2eu8o+HnuZBjfwNSiynPQTiBzqjbmE+lhzmbceY0NmSL9PsczygxZeNQND314ISGwPuECiJiEcMPYqbD/thB6cJXcIGIzGshjgpV6jAv6iMS1ZN+g8aZt4y4Lwj42T6Nbit4Rqe1CvVRnVOwiwCy9xHZ8vrH1hCZnPkCAHyPt/DEW4BvMpJ45SLKzoDpjIxgWTeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rg93GuPxk5N0KtlMyEKO/efa5SGHQlpbOGoEZBLbxs=;
 b=IgQAQnWJYflGp8iLMOL5IgVUe+gMtEydEdafSQsalKZkr8zqPDkKU+PoCHp478B4hP1Yw9zNZntI9DSqrNXb4eXdvqWpX2ihkVxpjmOGA8Z+6Rm63ngf//s/l0zp3fbdTnIa7UYy/dETS9jtTuNhBzPZXBqha/Fb9OS+/OFWt4XYl/CalOoEbjmpnCMwEcVTVYkJZ0Ay16Y/LydXi9vsZtw/7fPZmbRAr/gfAxLPQJTsRrnscwIxGEE16DXJO6ONo0jlRT0G24YPwjCN7yYMcPRTEXNI9KdsZa6w+v2tjnE1TmoC3p6oWy8aZc5W5gyQk0FcPhkLZH2y1s8pi+y3gg==
Received: from BN0PR04CA0146.namprd04.prod.outlook.com (2603:10b6:408:ed::31)
 by BN6PR12MB1235.namprd12.prod.outlook.com (2603:10b6:404:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 09:48:40 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::65) by BN0PR04CA0146.outlook.office365.com
 (2603:10b6:408:ed::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:40 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 02:48:39 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:36 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 05/13] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Wed, 13 Oct 2021 12:46:59 +0300
Message-ID: <20211013094707.163054-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e37f6da-7c9c-4381-9906-08d98e2ea34d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1235:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1235AF4E1379E2B9D40304FEC3B79@BN6PR12MB1235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEczcYr2QqtNBG76yo2TnshSfGpttvv/mddVwXRfvEjDxA7rGDH8CCG/hDIZS6wwSAMMzVLV4XrdYUSY7/wIMbbu0coktk41QTpjA3k+XaVvU2relH0Fb4CauGRT0XZqmQZNy4J0e7KKH2oU9EIihS+Mt7gT11sfJNRMsLwZ+eH815ZfOabmWPeHQHEi/NZWVt0aTeAh8BYXa6Vkhh9zlw8gO7VM3Y/MwgBAmVz89onzOfdMPnXRj8FaFMFfJl9F5HNG3mbUGSkdMmOdTNgubyR3zX4pHmsnLDZYdRBMaO989Ov9vPwB3oTvLrgPvdIMyr9Mf767CoEQM8aUVEvl9YTQgewzkfemjDH6ffcFD1C7/Rg88MPNzkwZnfncynlLfPOkibsIJeU0mKmAah7vToQAjo0xA4oPTFEhNXCtaXVAdB0vuWO/dcSaA5mFVB8RoO5UEEJX4fU86ihav/F2K32at2WVGoqWeTwdz03R7VZkoBPurfmwSD/yU9ykUGKaVyzqTCbTJRFk1PwpnkMH6j5/XrA5BuhJppjo9gxO5RX2jy13XDFl6j4Lijp+8rMkDxD3iQofXdplEoYlfX1Qk/cqS436tqMXPwQNTe4jrq/+OWGp5EslyCIwaw3uPuIOVuiPoSGEzcjt8So+B6M9Yzam7qskolE0X4/TWUHYwE5iAQa+0VPHDbHL9Aqw1uzw7jZk9Tp7DIrLA4O5UU9tzQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(47076005)(83380400001)(54906003)(1076003)(508600001)(316002)(110136005)(356005)(2906002)(86362001)(6666004)(8936002)(36756003)(186003)(26005)(70206006)(36860700001)(107886003)(82310400003)(426003)(6636002)(70586007)(7636003)(5660300002)(4326008)(336012)(8676002)(2616005)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:40.7230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e37f6da-7c9c-4381-9906-08d98e2ea34d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1235
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

