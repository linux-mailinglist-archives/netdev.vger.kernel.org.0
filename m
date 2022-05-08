Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB1151EDA9
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiEHNPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiEHNPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:15:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AD3FD33;
        Sun,  8 May 2022 06:11:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTVDIyJKOEHXSERq33cqs9BLSXZnhtknk8g5nSLe4+602CK1opYAsAA36amK72LH9kwhL3Pycnqp2a8TCkpZWm1VLZCBpZXI4W3GwLhLAHRh5KsEq8sQNjMsph4qRTPoAFeF5+iJ7WxN3YZSATG+e6U5UIpyb6EytyBOcPSlJcjWxPX99EiF41jVEl2xoMr21jlmEfzS9YpMklkNvF1qJ6x5Ojkp8nGuqSbZywHrtNQkcdmBeZtuXbSAEolvEacJwYcgBmXtoRz1NN4FTZQXzrba8ihlzhicCgpzXHZQvTqOqeNZohdwPtAB0n0J/xjBxeOxCPBfMevFkdauEBiv7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3jSgGjz2oCGbm+Gy/f4YsFFHVQ6CJcrnDfk9DeehoA=;
 b=lBU+8YAmaH26k6QKrC7d9bT2FSAxKSTACNNpSsXafwdzut5722l9osajSna/hBDRkYN7Oq/VLU1sJAjscZoT2hV64AcSswxIsqL+bq49rP9ZYImy7uxGxuR/1MUfnbHGIL1ROaktwPuEYGuxymsbi4Hbq5N7x6TwyWVFW5lSpKueIPQuZFoYSCEmahw5G0UcNhVRt9imCEnPSp4+ZTSY8t7r+mvh5zAJBDz/A3GDci+f8MBkhF1b50S4GTfupRM5pMsLQaXvnSZb9hmjatwg+JTMxiy0IEtI7fi7O4yhu3Cj7Si6yFKKEJhWaIs/FbgTain6QnlEy/n6TcNt8CMFxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3jSgGjz2oCGbm+Gy/f4YsFFHVQ6CJcrnDfk9DeehoA=;
 b=nFgkLHboWOfCDiL835rcMVUY+MiLA33aWhCCCyHjDNmN9T8jJAM82KBvzEOPE8BmPe2v9gMNdfKUJEmg1a0OWpZcXi2p/yPtyBLYVzNWwrAE5c2cQgRaP6OM2YXF8e1XYbL24EXmfw58Pd48UPfDNTDdvCUhQXU0gMZ/7yM8tYR/Ez/G+YGF6IXxTzknwqCCkuID0zfQAg7eNwFHgz3n9FsOAXwrTPQeHOlRoUSPawUjshMuSH3yDFjxK8Itzo1IoApAagv1T6yswSj9pzo8Yw/9d9B6I/SVW92hpkm8YYuZjclCqNJ43rKgeDd7h4m0npKHma+edefexBB16DFC4Q==
Received: from MW4PR04CA0376.namprd04.prod.outlook.com (2603:10b6:303:81::21)
 by BN6PR12MB1571.namprd12.prod.outlook.com (2603:10b6:405:4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 13:11:45 +0000
Received: from CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::2a) by MW4PR04CA0376.outlook.office365.com
 (2603:10b6:303:81::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 13:11:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT042.mail.protection.outlook.com (10.13.174.250) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 13:11:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 13:11:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 06:11:43 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 8 May
 2022 06:11:40 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 mlx5-next 2/4] vfio/mlx5: Manage the VF attach/detach callback from the PF
Date:   Sun, 8 May 2022 16:10:51 +0300
Message-ID: <20220508131053.241347-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220508131053.241347-1-yishaih@nvidia.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6179cd2e-39b8-4506-8751-08da30f44cf6
X-MS-TrafficTypeDiagnostic: BN6PR12MB1571:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1571111B5BD069B6868C6323C3C79@BN6PR12MB1571.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47YVnjXzZxhjqFhq7g1C2phWgRXU3Zas94QNjE76ptTh4eYzlSRk1A3JTdh3W8G8vCutUSPZw0cvFe2CEyZRXOMs/PPQ6IOydAuGUdE8fs4mrhmOit9xtDMozEJTtRfV/fUXThqMaymvWiEJ/vAJK44nuCVv+LvEmi7RAN4uIxfsWql+L9NF0EZlNzfYxzegB1z9vHhHBbm7F8or6EjSAL6rNaapMFSk2WxVtV5nQW0wQJnR2AZBONFgpLKATxpOBAacSx4rBc5+LIedWllMNB8HmPokBycSakgyOaNTPAt6yNtTydnL+d2crIoaFzPP5T2FeVO53UbzwFHzdDqAWKOnpM0yABQKa7jNJkktFpgVMRuJdOvO5vq77ZrSav6suAwvU7Tdju5fwf2TKQnGC84WtxwnQjauZm99k+lz/ixasroCoby0cNY98lwAUDG50RFlTr0xjZ/cX3XeAB7Vzt7dg5D76jMVqmkYOOihXtCZleUKi43GIJqWwlz1IBw+WSS5Pus2ugbQHl0Ov8Gq16PxYX6o/vyaea4TQHZlnmNykQPG/PiV4NaxD5tNDwbFCHnSqZywTgOKPfY3QV2GO7lLZd/Wir8EtPYIuioXaFXT0eZBRb3kAVnGEiEw4NlfKWLwhWLIICA7JUeoEnC6wHbmCtKTeT3sLxbV8llJWTPpV0lIVgFaa4QGFm1O/KQu7kCQY4h9u0Us8cBMunbFsw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(36860700001)(36756003)(82310400005)(5660300002)(8676002)(70206006)(4326008)(70586007)(1076003)(110136005)(54906003)(83380400001)(86362001)(40460700003)(186003)(6636002)(2616005)(26005)(336012)(7696005)(316002)(47076005)(6666004)(426003)(81166007)(356005)(508600001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 13:11:44.6631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6179cd2e-39b8-4506-8751-08da30f44cf6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1571
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manage the VF attach/detach callback from the PF.

This lets the driver to enable parallel VFs migration as will be
introduced in the next patch.

As part of this, reorganize the VF is migratable code to be in a
separate function and rename it to be set_migratable() to match its
functionality.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 63 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h  | 22 +++++++++++++
 drivers/vfio/pci/mlx5/main.c | 40 ++++-------------------
 3 files changed, 91 insertions(+), 34 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5c9f9218cc1d..5031978ae63a 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -71,6 +71,69 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
 	return ret;
 }
 
+static int mlx5fv_vf_event(struct notifier_block *nb,
+			   unsigned long event, void *data)
+{
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
+void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct pci_dev *pdev = mvdev->core_device.pdev;
+	int ret;
+
+	if (!pdev->is_virtfn)
+		return;
+
+	mvdev->mdev = mlx5_vf_get_core_dev(pdev);
+	if (!mvdev->mdev)
+		return;
+
+	if (!MLX5_CAP_GEN(mvdev->mdev, migration))
+		goto end;
+
+	mvdev->vf_id = pci_iov_vf_id(pdev);
+	if (mvdev->vf_id < 0)
+		goto end;
+
+	mutex_init(&mvdev->state_mutex);
+	spin_lock_init(&mvdev->reset_lock);
+	mvdev->nb.notifier_call = mlx5fv_vf_event;
+	ret = mlx5_sriov_blocking_notifier_register(mvdev->mdev, mvdev->vf_id,
+						    &mvdev->nb);
+	if (ret)
+		goto end;
+
+	mvdev->migrate_cap = 1;
+	mvdev->core_device.vdev.migration_flags =
+		VFIO_MIGRATION_STOP_COPY |
+		VFIO_MIGRATION_P2P;
+
+end:
+	mlx5_vf_put_core_dev(mvdev->mdev);
+}
+
 int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
 {
 	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 1392a11a9cc0..340a06b98007 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -7,6 +7,7 @@
 #define MLX5_VFIO_CMD_H
 
 #include <linux/kernel.h>
+#include <linux/vfio_pci_core.h>
 #include <linux/mlx5/driver.h>
 
 struct mlx5_vf_migration_file {
@@ -24,13 +25,34 @@ struct mlx5_vf_migration_file {
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
+void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
+void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
 int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 			       struct mlx5_vf_migration_file *migf);
 int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 			       struct mlx5_vf_migration_file *migf);
+void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 #endif /* MLX5_VFIO_CMD_H */
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index bbec5d288fee..9716c87e31f9 100644
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
@@ -596,24 +581,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	if (!mvdev)
 		return -ENOMEM;
 	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
-
-	if (pdev->is_virtfn) {
-		struct mlx5_core_dev *mdev =
-			mlx5_vf_get_core_dev(pdev);
-
-		if (mdev) {
-			if (MLX5_CAP_GEN(mdev, migration)) {
-				mvdev->migrate_cap = 1;
-				mvdev->core_device.vdev.migration_flags =
-					VFIO_MIGRATION_STOP_COPY |
-					VFIO_MIGRATION_P2P;
-				mutex_init(&mvdev->state_mutex);
-				spin_lock_init(&mvdev->reset_lock);
-			}
-			mlx5_vf_put_core_dev(mdev);
-		}
-	}
-
+	mlx5vf_cmd_set_migratable(mvdev);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
 		goto out_free;
@@ -622,6 +590,8 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 out_free:
+	if (mvdev->migrate_cap)
+		mlx5vf_cmd_remove_migratable(mvdev);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 	return ret;
@@ -632,6 +602,8 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
 	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
+	if (mvdev->migrate_cap)
+		mlx5vf_cmd_remove_migratable(mvdev);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 }
-- 
2.18.1

