Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0E14C2E46
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbiBXOVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235441AbiBXOVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:21:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3243D14FFC6;
        Thu, 24 Feb 2022 06:21:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HxkhiDmihLLfLoNzidXflyYxxupUJ3xcuTlaZlpVyDga3Z3W2F5Qu9w5Q0V3D6pdtNh8tXOAs0jjtswNnAMgu5i/IJtQqUXdl6PuL/eNGYVHbpqim3pPkfImXaf8KkcRk+BHvjrCc5knSFbymadgBmSIVxU2ZgmN1yymC6drsTLLnVeZwAhL6ylCw/2spVNpX5ilWep8ZFyqLxngQTl3GwjSUc7ydHpRQa9VMmU3x0S+F0JvXyliAAHSr11Ac8Ig3Lu3tpudwT1vvDlvsQz7WgHjVIuZxVCSBdO77k7QZdXa5PnqLRjxqL0XX64/fSB02RQ62B+BLce2OU4eLTmRCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=L6CRgVkCVHlcIabDeaYvl5/9Q6O/gT8MTAKSoHF4Ow+ZOI9ozuzKh/8hl45NdQXCHZ/owJl8O4XFiAXZ+wGgeTMDyl07M36bhQ/lEwfLgu7MURwpw9UaZZbgiISrOGUkovu7J+Kt0f1COsyGhQIe7lA/uuCNR+yiH7Sg3vy7XNG9w2u8lIFkDiOr0r5fd37YYeLyjUId4FA0c6rZLyAtMuSRYnuDNFSkORvzAAISWYVRd1kM3/qJY2+L+WwYnIKX+hMRgs160pC78EKSR/pYcxO0w8dkxRJjngVkp37RAMnWIzibd2sgheNne7na5MSztfBw7bElOIfc4AWkoM+jdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61gwSfylWpcH4wUM2gijTwlrZsz7BPMQi4AgoGVantk=;
 b=WfNp2eYgCl2jU86PJ8wbdLFiYJv8mT0M4xE1mCeGZnRg33enV4x6JKgCl+LTghp9v/JX3ANwWbIxItsq7GXAsuUt1jGj0pKoIr0dN1+dpda4P0YUM9AdusmPEjFkCuP5NxwcKGELzCMZBk+xpoeeptVrs/9+iLhaNy1JPw9Z7P7ciH6+wggkm/FIln8Pf6MSXtUhUhsZbMPX56r3FU7UR2Eucp3ADeduqRSewS7Er+gqDARHbuW11xd5z1gRUuFbVC8wdZzvnmS2XKk3jsTudCXiGwJXPXkaksLAnweFaW9FF8TEg/fymYnO9Ie2BGdjsNTtG7VgxDL9qV3YEuoSVA==
Received: from BN9PR03CA0285.namprd03.prod.outlook.com (2603:10b6:408:f5::20)
 by BYAPR12MB3510.namprd12.prod.outlook.com (2603:10b6:a03:13a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 14:21:18 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::a5) by BN9PR03CA0285.outlook.office365.com
 (2603:10b6:408:f5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Thu, 24 Feb 2022 14:21:17 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:21:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:21:14 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:12 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:08 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 05/15] net/mlx5: Expose APIs to get/put the mlx5 core device
Date:   Thu, 24 Feb 2022 16:20:14 +0200
Message-ID: <20220224142024.147653-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1be073da-7d26-4814-69c5-08d9f7a0eaf4
X-MS-TrafficTypeDiagnostic: BYAPR12MB3510:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB35108DC4E4D11A42521736C3C33D9@BYAPR12MB3510.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +IRN0mfsbvWfD5PwE091Jv5WmYiPP16A5OI4cLoudcuSsEQx3sItC17m9IXqpcD/MSKYlZU5AYumY56kNSRlD2RNmycGgUUs36D7017iVawCXw3e0NSZ30vuVTeEC4+/4oMnDMupFVXQ7sLty1GaFPOjUru5aB/kqzA+DLbnFN7jVa5CHjFSPWGc3uemMoYLQxjIOtFVqLIGNENGgVtrXCICru1khi8n0pRwOjFLFx2J1wIxyzGMSU65NOlcloHIUiNypDlEuzO9ANBWm1BdTy/u3cNQvOZfrGGZRaHk4n0bgntnEZgC3Iz4gLchrwUD4N5wtMK0kBa4OuYxNivGja9Aic0Wbq5eYOc7Tw+1r+p4VABaXr+Kl4nP0tIrVPFxpMQRfhb0B5IspTPUkIxYXMCdMKBVqR/qPVknzVybTl4KOF8FjdWCUDJRhfeMM0jowlzP/nWQGXcFpcWB9fkFFFuSzlHFRiC/mMvs3/woAbYHtbBlrOxFSRep6kBBnw8ZdoXVAAFOnjXrCSpi3rAW+C2ThL8OUOzUQ5DtN/N6gNwEdcRpj/WiVEte6n0Gm9YW2q3LQl54oLoYbmbPYMPoL6v/rxqcc6hjRNJX1D1+GA1pI+3yBjyEroAN88HLADTd0wZJhyU/c5tdBqIRL9hTVFCsuy8JCEO7rCGCQEMBLY0uyR98kmBXMrqro9wv/+lq2ZsqHUzDDTch59RIB6nqmg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(63350400001)(36860700001)(5660300002)(426003)(83380400001)(7696005)(40460700003)(7416002)(2906002)(110136005)(6666004)(63370400001)(8936002)(47076005)(54906003)(6636002)(36756003)(336012)(2616005)(4326008)(81166007)(26005)(82310400004)(316002)(1076003)(86362001)(356005)(8676002)(508600001)(186003)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:21:15.6475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be073da-7d26-4814-69c5-08d9f7a0eaf4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3510
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

