Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D107952102F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbiEJJGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiEJJG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:06:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5CD243102;
        Tue, 10 May 2022 02:02:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5HUkoJnqo3NgE4OjagfBNFV87mD27lSG7S4actVdP2DLFyXLxtvHwfKflXJxYczN5hQa3i41xvDYkNw1qcZH8I/wzOABghTb7m/kKieqXcSrgp2Oqs9NLU9MrLb3gmCsaQR8bMcXIm/NhhX1zMdVOrNLaL/sXNXYZkdSHOY8wZQIIjL2S118KMp9c3QlhSHpOigfPl8nm/tgLQdvI3IoB8xoKyiX5Gn1GT7n2/YUoPFpPUBNPK3FBdmAjVRJt+ST5HIcKtugBCBRM29ON7jwf1GpE1a23jSig/jBitbPw5Tds1jOm7pnhbXP3466WeRAjwGKWQsYFQm+6MqRPOBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTT49T9BQL5NUW4JY+ynp+9PRZYGgj3jzGrxRyfxqq4=;
 b=JdaoOiJCX+JvSfAfgp4UrvxtZsyo1xsZHUCLBXxfNIjdI1aeeOQTUdHpdf2VNrqkTA6/x1jRWEsYspQMfTDZYtlZjCgd0Vd8osdagcrZjqymAoGrveH0dsOc2ogGTgzTaHdlcT1IZTpKan/mSqoAXgfgBecfsX/R85jzu4pu7cpct7WVSRtsSkyOy6xKKShsQ2F0ylClViZvj1e7xtFdvNNz+GB+P8w2HPtzz2fGz42EOL+a+nmfnoBdcoBhIbZji6u1w+ZXstBL/0GbeskXYyZ18rfLNCUw2kIfPgZJ0VrMkWd0KC7QobC2/k0YonOJ8XrZwOBpFJPuGsprhWS8TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTT49T9BQL5NUW4JY+ynp+9PRZYGgj3jzGrxRyfxqq4=;
 b=be1B1PLC0zTUScXvc0efgDLW0nLLIr7/WghGSmZBvrYsqFHlo1jr/uSh875HX9psp//e5YjSqopbbflH2FUw2N1atxAsF2KnI+FNCIylHut4UBZxlpAuXH3TT7M7tYfRPnYKMNzphNBVKXtUBIh8u7H0WJEcn+B2JbIv6/buXkqxTV5SCmcHzdrq0ADopvBXq0SLRP7igIBxM1ksjfyr4I3zq+EeND3l7P05CfR9B/ZuY6o8djDica0a9IQXpv0B6Bt/HyvONgtq9hWryvMsCt4oqiRHbOPcmeL7JgMEzWvtCevELsWEsbjTvV9UYmmycsvWrcHDPVN5yTF8KiPUoQ==
Received: from MW4PR04CA0361.namprd04.prod.outlook.com (2603:10b6:303:81::6)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 09:02:27 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::11) by MW4PR04CA0361.outlook.office365.com
 (2603:10b6:303:81::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Tue, 10 May 2022 09:02:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 09:02:26 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 10 May 2022 09:02:26 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 10 May 2022 02:02:25 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 10 May 2022 02:02:23 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 mlx5-next 2/4] vfio/mlx5: Manage the VF attach/detach callback from the PF
Date:   Tue, 10 May 2022 12:02:04 +0300
Message-ID: <20220510090206.90374-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220510090206.90374-1-yishaih@nvidia.com>
References: <20220510090206.90374-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e621053e-3b77-4e7b-35d0-08da3263ce32
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0107:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0107367129B232541958BCA8C3C99@DM5PR1201MB0107.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJJ61mbLCXZfGXVxwUb7Z6bsK7QG6l8qPQQ/GqFMN/kXOesFHgZZGCdQObFtOJArfiiHkN21ise2CPlzk+Yrw/+LQufICFuAMu36ub9ooyNfkos6s24s+W+4dV/HSeRjL0tos80dN7BP9U6/1yRlPe4dRZVQFHR2nhfMVeX/gEv9sNfMsRF8RoqfjnY7NS4Hc3lBX6Og48u20dQ3+q3qJkqJ3zGSTKTrTq6EYQ4Bds3oeH+4py2QOAnIzK6zif3MspzR330eHw3fSdacy8op2zNvfqBDUaTIowdNGVoDXwZMUZ4K1PhiGsYtG1oP72i0nT48qbTBr4TF996OIiKW/KPC0eIToeFvOa4faEPj9Nk098AoiP6CGyUlDWjD3IFx4NhxlU1FTF6pLvN7GHzb7zpIL0dPYN/AGYc5nulBWGv7CEwXJatitmALNl8FrD+9d8TmucCGpyhApDtc3XeduApjqP4cdw7+GOGVYPvOwGvieYbauzy1gh9vcH1VWAHdlsJj4kr0ZOQfPdQ0DbDYBJNkCGutxlZUInRs2f3NfyL51tVKvmrGI1+kA0ksJL3QihGpUZPUKlXUYBP+ZkCu01bB1y4UiExqHOV1Kx0jiZ2iCY7Vo5LMXFczuSx7X3YSVqzA8Jmbzxkb/4EEUV9S7tvpoMOvxGlVOCf1uAxO0Wdh07DqU5aW22nQMoDwkFteD1nVqmIj/rki/jAkztScww==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(36756003)(81166007)(1076003)(186003)(336012)(47076005)(356005)(2906002)(426003)(5660300002)(2616005)(6636002)(110136005)(54906003)(8936002)(26005)(316002)(6666004)(83380400001)(8676002)(82310400005)(508600001)(70206006)(86362001)(4326008)(36860700001)(7696005)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 09:02:26.7801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e621053e-3b77-4e7b-35d0-08da3263ce32
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0107
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
 drivers/vfio/pci/mlx5/cmd.c  | 66 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h  | 22 ++++++++++++
 drivers/vfio/pci/mlx5/main.c | 38 +++------------------
 3 files changed, 92 insertions(+), 34 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5c9f9218cc1d..eddb7dedc047 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -71,6 +71,72 @@ int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
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
+	if (!mvdev->migrate_cap)
+		return;
+
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
index 1392a11a9cc0..dd4257b27d22 100644
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
+	u8 mdev_detach:1;
+	/* protect migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
+	/* protect the reset_done flow */
+	spinlock_t reset_lock;
+	struct mlx5_vf_migration_file *resuming_migf;
+	struct mlx5_vf_migration_file *saving_migf;
+	struct notifier_block nb;
+	struct mlx5_core_dev *mdev;
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
index bbec5d288fee..26065487881f 100644
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
@@ -622,6 +590,7 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	return 0;
 
 out_free:
+	mlx5vf_cmd_remove_migratable(mvdev);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 	return ret;
@@ -632,6 +601,7 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
 	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
+	mlx5vf_cmd_remove_migratable(mvdev);
 	vfio_pci_core_uninit_device(&mvdev->core_device);
 	kfree(mvdev);
 }
-- 
2.18.1

