Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0044C2E33
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbiBXOWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiBXOWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:22:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E99D138597;
        Thu, 24 Feb 2022 06:22:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZa6YPtuCrZRhV1YddlZ2SJnt6WLXwGierRdoNvV23PYNoboQHMoVlv/8JuMlT6AjCMXa1wQStZeuex94XQc551szWfZW0Ih0JoatN5vbFSDV/KWrb28Y+4zdkGJEQH/GFdiyY0Igpyc2f1txwk8O7I+ae5BgvUKoYOIfqKK+Iu+B13SEEdXqvAeD+REl3GLWbg48a8QEfa4JrgIF91h2Y0CiJiX6arhgVSOgSh6PN1RucmzjT511i1YXaqYj5gBK+anhqT0ldcb+c/9gs8lJD9H0+xdPQRw9hC+XwPzh43+hRTS4uXxbR32e9hM4OE0JvN3xoHBXr1SGvFgMjtrxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5oEc9MWVMWURkwYvktgLc4sEI1t8S8agd6owH4PfcE=;
 b=MFNUIkGIopz1RzUePEiae/Q/SiBFKt4zXqV5WNCTcqJ4OeKLEzFRpa8ULj8/snJuNjBn50TzRaOKK730QfclzATby5f4X6P+Czzr9mVSE4nABE/bBFgLfKKOkRhCch3e235Nmohm9bojuK9oAOrHFHd8Vcq4cvpkzzyirRwTeLG4M8r5lTjfg5SidG14ZVN99FMg48r7oEAONK74jeBIuX0gux84YHQbZExWfIrZ477zZg6u4eVqzT00/F3IZKeG+B5WOeHoXst1p0H2RHMTqf7dnYNfROXopvPJt5T7phuQwmSQQA5B4M3t9J2DajgbkKx8E9iMemqxuW33eLatcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5oEc9MWVMWURkwYvktgLc4sEI1t8S8agd6owH4PfcE=;
 b=Q1EqQpvJ4OOkgAxrjRGuai6yFWQdGTKkgwqp68Nmh/qoTKW1NApSk6CoBlZPhKhuS9poy8ssnjacYPRpZZ7Rv5Q/A9NK8Qgef9E0QDh1WZlHgwheC7l6HDkzu/pK5XStqDFCk+CJ7oVefKa6DjK8d5YIczZdCP2LZPvXW8xaTldYi5OmqywpEpNZZj4CUpdk9dlnMRePs1XsukSmN7MJvOq0dNK1uDEcvGfh11NVSGrzN9Ega181+ij0YjCS7p+VKQIMlj1D+/9rxb/SoTR5cJIZZx9/R76MVp40tmWWnQKBMJ2/qUkZF6enyhb7zpJpAN1GGf85lf9vNPf8Y+Ce8Q==
Received: from BN6PR11CA0019.namprd11.prod.outlook.com (2603:10b6:405:2::29)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Thu, 24 Feb
 2022 14:22:01 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:2:cafe::65) by BN6PR11CA0019.outlook.office365.com
 (2603:10b6:405:2::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 14:22:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:22:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:22:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:21:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:21:54 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 15/15] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Thu, 24 Feb 2022 16:20:24 +0200
Message-ID: <20220224142024.147653-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220224142024.147653-1-yishaih@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 728e70c3-3a71-485e-9068-08d9f7a10603
X-MS-TrafficTypeDiagnostic: BY5PR12MB4180:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB41809FF0305552F98670C9C0C33D9@BY5PR12MB4180.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZtAKI3NFD7LEYpcdJOWlky5XXr/+G6W2QWhjzAJbmQ+6YEavF1v/YiZY/4lZc/HVka0gdV3Eqjq0SU5IlJxHXl75agpZpBvkFQkKgWNhvDFH14oy9UaO+fs/DvxMxA+DV70fnoDFJW6pxmjofI8QjLMU6kRGu7qxnc7nkNEwKtlBLR2srPEtXUpPmTN12gCSqILVBpj7Kg8y/kvBwREbIJGdWFYvyg7VHo+yLSzDs0GNIVYHGimER8ZAQ3/ymeNwCinyMG4lDcmSBnqsRM4BCsdWFD2MJ/Wfz2AQbdjnDo0sJKCr31bhPs5Pu2kwt03/KmutyurJzgPOEEu4vqc2+SIvvswMB1Ec/yTcHwV8UVthOjogNwkW9khgCM6FSUmvY0Tz338bTgqPS7f8m2AK4qJuzLwgfTGHvmaOK/75Ysd3VSu9NND/AJyLz6Um8JXZQZQQ92GgVyuyX+/qk8bQYPjr6RCMFEY+NCEi+rah2xIdaXyUGENL0aYdu7uf39vdFCyRkydp38GLWN/CzjPONluv2EffF/P3teB+NAgscsyGgOJIWkyZtXU+82VzH4Tff5fFUjTHb7QdxpFjpaSjf0R82dvAxaOf9gwvC3qFB4kD8UyeMCLD517+7NFrCydcHvNgtrfieya+XsgGW+zswB2ZMPTvCBapU5/QxwnMNFyzGvdt9jKmnmgwLSIV2ZH620sGyykHDaE4GOljwYp0g==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(47076005)(5660300002)(82310400004)(4326008)(2906002)(7416002)(86362001)(36756003)(40460700003)(83380400001)(70206006)(70586007)(8676002)(110136005)(36860700001)(2616005)(1076003)(54906003)(426003)(356005)(6636002)(316002)(26005)(508600001)(186003)(81166007)(7696005)(6666004)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:22:01.0609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 728e70c3-3a71-485e-9068-08d9f7a10603
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register its own handler for pci_error_handlers.reset_done and update
state accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 57 ++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index ae1e40f7b290..282a9d4bf776 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -29,9 +29,12 @@ struct mlx5vf_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	u16 vhca_id;
 	u8 migrate_cap:1;
+	u8 deferred_reset:1;
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
 	struct mlx5_vf_migration_file *resuming_migf;
 	struct mlx5_vf_migration_file *saving_migf;
 };
@@ -437,6 +440,25 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	return ERR_PTR(-EINVAL);
 }
 
+/*
+ * This function is called in all state_mutex unlock cases to
+ * handle a 'deferred_reset' if exists.
+ */
+static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
+{
+again:
+	spin_lock(&mvdev->reset_lock);
+	if (mvdev->deferred_reset) {
+		mvdev->deferred_reset = false;
+		spin_unlock(&mvdev->reset_lock);
+		mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		mlx5vf_disable_fds(mvdev);
+		goto again;
+	}
+	mutex_unlock(&mvdev->state_mutex);
+	spin_unlock(&mvdev->reset_lock);
+}
+
 static struct file *
 mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 			    enum vfio_device_mig_state new_state)
@@ -465,7 +487,7 @@ mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 			break;
 		}
 	}
-	mutex_unlock(&mvdev->state_mutex);
+	mlx5vf_state_mutex_unlock(mvdev);
 	return res;
 }
 
@@ -477,10 +499,34 @@ static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 
 	mutex_lock(&mvdev->state_mutex);
 	*curr_state = mvdev->mig_state;
-	mutex_unlock(&mvdev->state_mutex);
+	mlx5vf_state_mutex_unlock(mvdev);
 	return 0;
 }
 
+static void mlx5vf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	if (!mvdev->migrate_cap)
+		return;
+
+	/*
+	 * As the higher VFIO layers are holding locks across reset and using
+	 * those same locks with the mm_lock we need to prevent ABBA deadlock
+	 * with the state_mutex and mm_lock.
+	 * In case the state_mutex was taken already we defer the cleanup work
+	 * to the unlock flow of the other running context.
+	 */
+	spin_lock(&mvdev->reset_lock);
+	mvdev->deferred_reset = true;
+	if (!mutex_trylock(&mvdev->state_mutex)) {
+		spin_unlock(&mvdev->reset_lock);
+		return;
+	}
+	spin_unlock(&mvdev->reset_lock);
+	mlx5vf_state_mutex_unlock(mvdev);
+}
+
 static int mlx5vf_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct mlx5vf_pci_core_device *mvdev = container_of(
@@ -562,6 +608,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 					VFIO_MIGRATION_STOP_COPY |
 					VFIO_MIGRATION_P2P;
 				mutex_init(&mvdev->state_mutex);
+				spin_lock_init(&mvdev->reset_lock);
 			}
 			mlx5_vf_put_core_dev(mdev);
 		}
@@ -596,11 +643,17 @@ static const struct pci_device_id mlx5vf_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
 
+static const struct pci_error_handlers mlx5vf_err_handlers = {
+	.reset_done = mlx5vf_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver mlx5vf_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = mlx5vf_pci_table,
 	.probe = mlx5vf_pci_probe,
 	.remove = mlx5vf_pci_remove,
+	.err_handler = &mlx5vf_err_handlers,
 };
 
 static void __exit mlx5vf_pci_cleanup(void)
-- 
2.18.1

