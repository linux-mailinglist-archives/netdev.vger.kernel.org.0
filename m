Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E151B4BCDB1
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbiBTKAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 05:00:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243655AbiBTKAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 05:00:20 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2046.outbound.protection.outlook.com [40.107.236.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B18546A7;
        Sun, 20 Feb 2022 01:59:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWDkrSE/2vdXxcFRXUvH4ZTLAM5rU9rFU+nOskVCZ5tKNxcfCDJe+hBnjQXszcKz5CH0vMCpQhwaDOjbg3M4Fmd/0cbHPV0XjT12pn1emxIUqryEn40MjAYrIAPn9enamFhnVZFhtzca6Qlh+d+gbMUqF3GMTldRZjPrK0oIHtELkFaTH0blcdG1QNPrw605Smh4YXe5YT6Om671gZ+b+6d1odpbC+nCr7aG4Kq8k+BKTj0lRYzXieDncgVUJUOPQMP1Kp9yxRRuVnqlnVo0c6tjCFPx2Tj+tx1/MSabPYOH2dSXziOuWLz76IfWHRrMlCG1SbUjPkJXI5amjkPibQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIDrPuj78Tj53tWWn+hoHOLUp1Ek5O/NH902OD5bwUQ=;
 b=PX/a/G/+as8SRtObjDKTmlgECIUgdLLdVeg/2Dejv89hNvnoeZY1vF5+/MLHethb5/QxY2cPQmX/4dwlCfc+kxDo//wcJ1xrpFbXO82UB4/tPGIIIzodMcYeNkD/DRjIDWbMZ19JaPE+n/QHRpk3VOdNm42nQnAB94XTqikEcsT51hxPDR+qvtJdCNhxl6L6R1FzJQol0X1cWcLkfWU88sdj95ypxHFZGryP+2R/tmAWCz1Wex//ToTL+IuMM/gBXQk0lCRecA7gKcVZ+uJJcmatPkCa2s6Sg5fKrMIaVqwdOVDveTk0sNWyF9wbFotiwx9TdjSbOaGQb6B/RU7tPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIDrPuj78Tj53tWWn+hoHOLUp1Ek5O/NH902OD5bwUQ=;
 b=HDgrEg2684hNWiSC0Lv+X7QiRw7utyZUhKmq+HVkSvxzx7gWF5d0oN9iIpZ2H0v/DVUSc109gi53Krrh0v02hw6WPB+23VGM9hC9od1va9COxMZujIzoLBUzUUcWbGAkxpbY9VZkMIQYuyN/kI8BOCwb/yEGFn90vTOePfZ/3DLLeNH1wq+IZH9yzQm0K8/iiYfliXn0tBXpdKGeDtK7BNN7o/KY2SamRyx9nQlA8JEhPuanQFFhpTOUvElxs7CDo1xfKzQPUq2FlF2prRRiV2lcIGeMa8k7LHDgvz+q5GWwMgiCstQ9CKIKR+HnFGv48OoeAXPYeAY3hunyyqLM1g==
Received: from MW2PR16CA0064.namprd16.prod.outlook.com (2603:10b6:907:1::41)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Sun, 20 Feb
 2022 09:59:39 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::4) by MW2PR16CA0064.outlook.office365.com
 (2603:10b6:907:1::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.25 via Frontend
 Transport; Sun, 20 Feb 2022 09:59:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:59:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:59:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:59:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:59:26 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 15/15] vfio/mlx5: Use its own PCI reset_done error handler
Date:   Sun, 20 Feb 2022 11:57:16 +0200
Message-ID: <20220220095716.153757-16-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ef1f248-14a3-4d62-1311-08d9f457b554
X-MS-TrafficTypeDiagnostic: DM4PR12MB5890:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5890D07193EF90AF8E3896F8C3399@DM4PR12MB5890.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IiGs4mDISlR0FRDiY4VFsnfwS3MkQODMKHYDo6V3hFYMMPyaPH5/K/wnTMljCXcOTmCcs8dd7EEbKQgez0PuMxB7R/mYXAW0H4WnkdT9WVMHmTYcPJSQxPldJkrbqC9q9Jx8DAsX2znpplMfIZZvwj1KwjfDNwaLISlqVC6Y7Gv9O+xPKKcaYFn0txIpx45pJVfIIp9wvykaProBo/zzQA8MHCwx6IXxHLzK5m2D0NusLXqlONOVhBV33GKfFAVvEN9d64vLh+5faNujvBCjVFcbuqJ0kBB55zAAgT86S6puS2TYrRIiLxYaqa7L0mut3YG6Vld4UKP2+02knvWO+88Bh7AeN2jA5plYHozG6lpIg24693fdzMFycF6RMFCEexaPcWjykdD4FZTIemHIO0DpxlAkGG+YE0Y+Vu/QhmchMDI/oxFsB6rP9NpO1qlJneoaBcWQvQOehhB3c+j5kuvC0apxJnO/7tbU6cYtEOG0R/uY6OsdszyM1ko4IQo62Ydj21ji4wGCWe4TDbs6OMqveFj84/C00sE0ftLLbVQfvuwPb7nSbq1lWaHLT3QH1dVxwSXrtIk5UfQ68k4ULyx74oZee15s6ofkNR7ym99V7ZxJ/VF8VLSOSeVNyh/aVDNmsuzp8vkF0pkXXtMw5XofkYCurO8QI6ZcXu5Kn9Wn6U9sgqw+K6PiOYz4+2cZ91tP2RTEwuznEoWUWonBUg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8936002)(110136005)(316002)(47076005)(6636002)(54906003)(508600001)(36756003)(5660300002)(8676002)(4326008)(6666004)(7696005)(7416002)(70586007)(70206006)(83380400001)(82310400004)(2906002)(426003)(2616005)(1076003)(336012)(186003)(26005)(36860700001)(81166007)(86362001)(40460700003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:59:39.0060
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef1f248-14a3-4d62-1311-08d9f457b554
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 2be78cc78928..046d5ff6f1f4 100644
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

