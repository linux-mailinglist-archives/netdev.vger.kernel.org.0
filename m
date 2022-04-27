Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3686F51163B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiD0K4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiD0K4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:56:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7740F39D24B;
        Wed, 27 Apr 2022 03:30:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vv5GLkAYHly/M79Og5i8Qn5o5wDfV8UtCDdJ4Kg8mok4LCWH+7D51K4yYx0fyFaWVmjeNX0mlhjatGBN8BLhO3kl4nCM22nOE5ysSTka6JbWstcMedTLLJIr8uPKRwhhFt9WbdXYwA0NNWK/uVsaAVvoCnwMOaqn1UrePh9ifLJYYAUIVWdi1WN+e7huWgFF4Kr8bW3GavURxtCpTKMLbOelPDgaOEe/Vji/cSRWA3W+SAsPpLedJ79wtO7UClk4ml3OdS/cnzxM3xSSgat7qrh5EAFM2PAWjjUshxptsgrh4xovsVWW1i7Hd9G3ITCXvhMrDAoKyFDMZtln9DFo3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kns1flc6bQFiKq2tOQDObbbcAtmS/ko6avejXc0GLBQ=;
 b=T1f1WrZTE3psdaxcuL42MO31vgVZxkUxfv2VI/2AUGLrNQURuGHtlhmTwhHfLGfbDa44ZAaW+4Icu0B3gkefO74UsmapAQkWqjqTcnZEzGGT9hBb/dYHHAMyjD+rGoLL0EAdbbguLMKoIhyxzypJJAvQmsV99icgnEBxdxv9vrmtD8PGtO9THK8atFrOlyU0yJ5FDTWVVrAV3jbD5rfcevabJQRU2z3I3igzaLS3aFKpQArwHKK6GizbYnMhpsDYSjBmeE/SyhxTse5MknFzIuYgIoGM9gnfS92IgFr84Rb5t1OBh8QITHATl7et1yhSe/dhJpai87cFtmAMhFOwsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kns1flc6bQFiKq2tOQDObbbcAtmS/ko6avejXc0GLBQ=;
 b=GzRxTmFCPzi5Z1ikLD3o/CItOKw8p7tbqB5mhlse55L7QYpcNT2nEtkIgaXatxR6FqDVmO7xVP868EqODBjakPrJVFBAnJUsDgQZ3Woa2HsYx4KJfE/Wqjszk7JyfyTqOlf+LzeT2VEa5B2smedjVl+B8PEApfcod2bpyh3DDGeQ7hSEOp2ODk49ERWuIxQGTj2A4De4A/lP/VMLFud4DGUWchYQGE/jFLyzjM1lQFXw1oPSljhpoiTiu8ltqbXS+8izbv//bjDmey48XclkPnb57D9Yhm2Sm1U+uSroOc8yNhewgQfAq6cYBMzvd2E/GOGi+xPZes5snabtL8UeuQ==
Received: from MW4PR03CA0016.namprd03.prod.outlook.com (2603:10b6:303:8f::21)
 by BL0PR12MB2500.namprd12.prod.outlook.com (2603:10b6:207:4e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.18; Wed, 27 Apr
 2022 09:32:05 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::2e) by MW4PR03CA0016.outlook.office365.com
 (2603:10b6:303:8f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Wed, 27 Apr 2022 09:32:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Wed, 27 Apr 2022 09:32:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 09:32:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 02:32:04 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 27 Apr
 2022 02:32:01 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH mlx5-next 3/5] vfio/mlx5: Manage the VF attach/detach callback from the PF
Date:   Wed, 27 Apr 2022 12:31:18 +0300
Message-ID: <20220427093120.161402-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220427093120.161402-1-yishaih@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d51fcffd-5127-4e3e-78fe-08da2830cae5
X-MS-TrafficTypeDiagnostic: BL0PR12MB2500:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2500BEF159CBBB40AC21F925C3FA9@BL0PR12MB2500.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4h/4uju/kEcPuSBW48glraFBrmFJxHWm0tTS7m4+79yRN/7xV/AWzEEiQgp8vFCpjULpqP9z0wOvkKqZuxQBCOq30Sye4A/7gHV4EsPNbe24UJUxmxgBNHZxtnHkfWGpnFed/g3tuK1D03LEoJCb1M6S4ghXj/wibEeQGEi2SOTwCgFrpzL9gZ9BBQAgrdmMeP/PueN+xshDyOLs+tFagZQ8brfxKxu71ANgKt7kDp6YqX3ghWkn5UDZF8s1TtzpcpRGiOjgiLPhDbDKVfwtS1CnyEb24MSAquoQNwkXNrfRECtVKeITBqAe5fz8HV1D6KHPB8KNetWnTyHXi/FwWvMR2aioyNByYUfBIuuKzlQbpfYh5thW6L3+GY4BSBqg+X6LdDtnF4Q3SnROXKJ/xBRGXtQKz4DcJnlXTJG9oKn99jaMdcP/vhvP+cygLlRnJ/AFgmRW5cJ0inHaQP8TKR0GVVOM4B8GgBxjlICUKGNCIGcG/KTg/nmtljxVk/fr9dEOLxYv4p2/5Wf5/YgWJHx55bJNq1zI4Bc11Y3Y1PtL5hDtM/sAfNYO2ShlK3ZyejcUOopv7wo29i/Fr+6UGC604Xe0fpKkXnzrlCqJAP/nRuNo95NfKaO0sNyNLr+8Dmnrxmc5he96r7XgIVkA4C0hfklD1OvGDzYJcpzmF5LLoCv7bto6ZTHQlezpamcfNdm8o0kIzNLs2MDoMpskNw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(4326008)(508600001)(36756003)(82310400005)(6666004)(26005)(40460700003)(47076005)(6636002)(316002)(83380400001)(110136005)(54906003)(1076003)(2616005)(336012)(426003)(186003)(5660300002)(356005)(8676002)(70206006)(70586007)(8936002)(81166007)(7696005)(86362001)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 09:32:05.2986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d51fcffd-5127-4e3e-78fe-08da2830cae5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2500
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manage the VF attach/detach callback from the PF.

This lets the driver to enable parallel VFs migration as will be
introduced in the next patch.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 59 +++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/mlx5/cmd.h  | 23 +++++++++++++-
 drivers/vfio/pci/mlx5/main.c | 25 ++++-----------
 3 files changed, 82 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index d608b8167f58..1f84d7b9b9e5 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -71,21 +71,70 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
 	return ret;
 }
 
-bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev)
+static int mlx5fv_vf_event(struct notifier_block *nb,
+			   unsigned long event, void *data)
 {
-	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	struct mlx5vf_pci_core_device *mvdev =
+		container_of(nb, struct mlx5vf_pci_core_device, nb);
+
+	mutex_lock(&mvdev->state_mutex);
+	switch (event) {
+	case MLX5_PF_NOTIFY_ENABLE_VF:
+		mvdev->mdev_detach = false;
+		break;
+	case MLX5_PF_NOTIFY_DISABLE_VF:
+		mvdev->mdev_detach = true;
+		break;
+	default:
+		break;
+	}
+	mlx5vf_state_mutex_unlock(mvdev);
+	return 0;
+}
+
+void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
+{
+	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
+						&mvdev->nb);
+}
+
+bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct pci_dev *pdev = mvdev->core_device.pdev;
 	bool migratable = false;
+	int ret;
 
-	if (!mdev)
+	mvdev->mdev = mlx5_vf_get_core_dev(pdev);
+	if (!mvdev->mdev)
 		return false;
+	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
+		goto end;
+	mvdev->vf_id = pci_iov_vf_id(pdev);
+	if (mvdev->vf_id < 0)
+		goto end;
 
-	if (!MLX5_CAP_GEN(mdev, migration))
+	mutex_init(&mvdev->state_mutex);
+	spin_lock_init(&mvdev->reset_lock);
+	mvdev->nb.notifier_call = mlx5fv_vf_event;
+	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
+						    &mvdev->nb);
+	if (ret)
 		goto end;
 
+	mutex_lock(&mvdev->state_mutex);
+	if (mvdev->mdev_detach)
+		goto unreg;
+
+	mlx5vf_state_mutex_unlock(mvdev);
 	migratable = true;
+	goto end;
 
+unreg:
+	mlx5vf_state_mutex_unlock(mvdev);
+	mlx5_sriov_blocking_notifier_unregister(mvdev->mdev, mvdev->vf_id,
+						&mvdev->nb);
 end:
-	mlx5_vf_put_core_dev(mdev);
+	mlx5_vf_put_core_dev(mvdev->mdev);
 	return migratable;
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 2da6a1c0ec5c..f47174eab4b8 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -7,6 +7,7 @@
 #define MLX5_VFIO_CMD_H
 
 #include <linux/kernel.h>
+#include <linux/vfio_pci_core.h>
 #include <linux/mlx5/driver.h>
 
 struct mlx5_vf_migration_file {
@@ -24,14 +25,34 @@ struct mlx5_vf_migration_file {
 	unsigned long last_offset;
 };
 
+struct mlx5vf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	int vf_id;
+	u16 vhca_id;
+	u8 migrate_cap:1;
+	u8 deferred_reset:1;
+	/* protect migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
+	struct mlx5_vf_migration_file *resuming_migf;
+	struct mlx5_vf_migration_file *saving_migf;
+	struct notifier_block nb;
+	struct mlx5_core_dev *mdev;
+	u8 mdev_detach:1;
+};
+
 int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
 int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
 int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
 					  size_t *state_size);
 int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
-bool mlx5vf_cmd_is_migratable(struct pci_dev *pdev);
+bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 			       struct mlx5_vf_migration_file *migf);
+void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 #endif /* MLX5_VFIO_CMD_H */
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 2578f61eaeae..445c516d38d9 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -17,7 +17,6 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include <linux/sched/mm.h>
-#include <linux/vfio_pci_core.h>
 #include <linux/anon_inodes.h>
 
 #include "cmd.h"
@@ -25,20 +24,6 @@
 /* Arbitrary to prevent userspace from consuming endless memory */
 #define MAX_MIGRATION_SIZE (512*1024*1024)
 
-struct mlx5vf_pci_core_device {
-	struct vfio_pci_core_device core_device;
-	u16 vhca_id;
-	u8 migrate_cap:1;
-	u8 deferred_reset:1;
-	/* protect migration state */
-	struct mutex state_mutex;
-	enum vfio_device_mig_state mig_state;
-	/* protect the reset_done flow */
-	spinlock_t reset_lock;
-	struct mlx5_vf_migration_file *resuming_migf;
-	struct mlx5_vf_migration_file *saving_migf;
-};
-
 static struct page *
 mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 			  unsigned long offset)
@@ -444,7 +429,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
  * This function is called in all state_mutex unlock cases to
  * handle a 'deferred_reset' if exists.
  */
-static void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
+void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev)
 {
 again:
 	spin_lock(&mvdev->reset_lock);
@@ -597,13 +582,11 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
 
-	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(pdev)) {
+	if (pdev->is_virtfn && mlx5vf_cmd_is_migratable(mvdev)) {
 		mvdev->migrate_cap = 1;
 		mvdev->core_device.vdev.migration_flags =
 			VFIO_MIGRATION_STOP_COPY |
 			VFIO_MIGRATION_P2P;
-		mutex_init(&mvdev->state_mutex);
-		spin_lock_init(&mvdev->reset_lock);
 	}
 
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
@@ -614,6 +597,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 out_free:
+	if (mvdev->migrate_cap)
+		mlx5vf_cmd_remove_migratable(mvdev);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 	return ret;
@@ -624,6 +609,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
 	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
+	if (mvdev->migrate_cap)
+		mlx5vf_cmd_remove_migratable(mvdev);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 }
-- 
2.18.1

