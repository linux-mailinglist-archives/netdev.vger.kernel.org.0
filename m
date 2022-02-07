Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDAE4AC765
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377420AbiBGR1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348644AbiBGRYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:24:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB45C0401D6;
        Mon,  7 Feb 2022 09:24:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPaZ0LcPVhPnu3r6gfdEZgiP9PBu4fv+1I3fXWdt3w+fkGzDU+IdmPUxm1Cz92IHSOyUxHFizygd9SjKd0X27ScxT9bMxWxGCOaMnU6SRrnHDukN3J9URhydDlOBGir1AQ3XaJ6P8WjuZuh9l6y/oQC6BdCUfPswsk7zNFTPrdWD887wI21uyel1kFen23RBZmXufaYUCiK72cgoDkpDxjtyx4KyTz31A5p8tRH/2H0CEe31/L1/2MBgCqeTGRI5+o1TFhi+R7OCG5dJpCD5btJz455Oz3A4KBm2hdVVU7hNFS/Z6GEicVelDEAcMV2KsWazwYj4BKPyQbAJ4/tWvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdEvb6AWR53BRkZhnnpX7dTU+RBHrPZOwgBbrsCyrIU=;
 b=VR7plKKQaAnF+4cR9rMmlik0uav2KS2ilz2mif6NT67fgp+y71rTEmlO4D9srfqx0hqULmmpOezLGdmp9F4QYT1iJtBZ81JkF6eDFnuM0RwTS8ttWQlbKhDjVnmfK2uj9F2wVEA9e+K9KEBnkA1gSF9jOXymRqzzxUQSoxy4Jvyz5PF4scN3hRxGSYpr9aebF83l+1qtkKAscgNiPGQSCDOjacemXLa+/lh7tEw3glRwvPIGfavs7g84zX+F/32nNFLcfCLWonQsdElRa8ApeOgB6XU7bKdUa+r177UZFB4G8CCOYt98SE4hv3ii54q1lXTKQcY1h8wgP9AfJtA+DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdEvb6AWR53BRkZhnnpX7dTU+RBHrPZOwgBbrsCyrIU=;
 b=dTNid7XyZf7f8w6N7kD1Pr7pqA//v+83dbkTK6KKb8dSrW5GcnCozfhYNnU3cpMVyfuXSSf1einjtvHHFxVXhUQyWaxDe3DpTIKV1OQ8zlSC8WTAK1occ0zd0LmVSpEsK/lq2IGjmWN/tdZ2Eju8gFJiEjg1voNQeyHfz+SlZHDEYa21L0H6QDID3BVBPky+WrL52IgEnKQEtFvvushYGOnreYNXl82BdHhMpvEXWJKLJFHpysZN9MI7og8FGO4dk1oG8VEFmYP8Mf/0+CaW/8B2Twoy6sskRr0EFe43jX5ywgfn0gG+bc+YkdFkodG1wwzerUCyptvbB/zkt8wHww==
Received: from MWHPR19CA0011.namprd19.prod.outlook.com (2603:10b6:300:d4::21)
 by BN8PR12MB3122.namprd12.prod.outlook.com (2603:10b6:408:44::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 17:24:08 +0000
Received: from CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::c2) by MWHPR19CA0011.outlook.office365.com
 (2603:10b6:300:d4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Mon, 7 Feb 2022 17:24:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT043.mail.protection.outlook.com (10.13.174.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:24:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:24:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:24:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:24:02 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 14/15] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Mon, 7 Feb 2022 19:22:15 +0200
Message-ID: <20220207172216.206415-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a67e1fce-460e-433e-4d6a-08d9ea5ea5b5
X-MS-TrafficTypeDiagnostic: BN8PR12MB3122:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3122F61D88D571C65231EA67C32C9@BN8PR12MB3122.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gaJI6dlZ46ajk08py6L09yG9Dfaq58MIfPUTyD8WQgmpbYUW5ZoI3VqK7/bhsmJ9abbYD894gvGqoncdiv+4Eg8RLxIvRSjUSwlNlJJTaPL+zwIjjEbW1m/ZTDjxv8kcEI2IsmMPHvylkDXtaNH6aEu/cn+0d6rlcqiGSYrxKGhvrtQE/v0uSYJOIIjMja0EX5hpSvmt06mE/WlyXPOv+mmIDDrJlNzgMFBR6Ur7mod6TXx7b3wqnsUY1O5YdlegzgCh/vsN2YZlZiM2NoI8a/Lvdkk2slnXR9wKWa9Ej985oK8eOHuIgt1J1b5MFUkK2XIR9ph0r2SfbqmlS9KadMP7flb0edbbqUyRcv44CdegJF4ZsZNBVxKzfcazYzZ7Eu6sIQV1v383E26DfJgGwB5axA2fjCy4pePD1+dRKbx8tsnjDinYX9SdDQmMyUR+MTe1qa3u4VR7TpbdGQq/TV2HhzlmlArpzLFTj1O8Ta6tBBpBu8JTRjA7rQNoyGCIAJhPSPzT61DxaBouu7gVgIbgvN7t9JdDAycqVminq1TRNcNLOjBd8CMJmgkgMDREBYXPmLZAVyP0OykBSmMMUbUxhe2esqGE3HT2QZqzwaYVAubFMBWipLD+7I91yRkwmJXXA/GbnbdoPFMkm2I26Q7dTJX/AoBXn2PaMf8L4Qyq8fkkNdVAlPLBlBTi50Bd3mEBt7ntqCxDP9DvJiO0Lg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(8676002)(70586007)(70206006)(8936002)(6636002)(82310400004)(110136005)(54906003)(316002)(186003)(1076003)(2616005)(336012)(426003)(26005)(83380400001)(6666004)(508600001)(86362001)(7696005)(47076005)(36756003)(40460700003)(2906002)(81166007)(356005)(5660300002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:24:07.6490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a67e1fce-460e-433e-4d6a-08d9ea5ea5b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3122
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
index acd205bcff70..63a889210ef3 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -28,9 +28,12 @@
 struct mlx5vf_pci_core_device {
 	struct vfio_pci_core_device core_device;
 	u8 migrate_cap:1;
+	u8 deferred_reset:1;
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
 	u16 vhca_id;
 	struct mlx5_vf_migration_file *resuming_migf;
 	struct mlx5_vf_migration_file *saving_migf;
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

