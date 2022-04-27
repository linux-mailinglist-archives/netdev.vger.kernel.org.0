Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C58851151C
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 12:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiD0Kog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiD0Ko3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:44:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DC828B770;
        Wed, 27 Apr 2022 03:25:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAvXeudEQAKvuVNfcNv6GT+3J225YKEqUhNggHBwvsrtoMq2sfMZhQoDsJ8UDEzEXGZT6yNRZGDC3u+HyH0wyQpBZvBGtqeArktQQt5ksc0eP+wMpakA1ED5+GFATFtOp9uy+MFTc1p6QWP9QgY+WmKJX2KzMmaZHucwx6gS2HovYS4KhwOpl+TE3FiYldwweiHIQcHPTQ7evgP59jucVUnryu2YKWBTupMhQNOIa1HQG24Pnpdd2utO5YFDrxUgmAE7JCUyFl7bqEWWc2Q2JcZZpaejRSFqJcY9LOpqN55JdcnkWyaqyB7CYCeDKQKgyAk3UBzv41mGcatvWX1smA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8SrpIf/Lat+BhZRQKoiLgahfmAYBon0yfVzzuEHEvc=;
 b=ETIZLItbeKCoRPY5VgFEhFbKEy7JijvUqL9S5bcFjTe03I1gMSjovQAtX41B923G+DgKjI6XiHUasMrrQTjF30Xo07IkMpyxEyLPozFmbxXwwgGqxMEKufo3yAG+6GojetdKokt961IjWsiTO5c+TaBAlSGfEMu8Qk/XigAP1PZnVnz/9P7RPj6Ca/PKVonExhpC7DHK3nkMhVKfeU7qFsZTkeUNGFAhj1nCu3jtZghji30AamOgj4k7eSTXPAaf7g8GZfVBspNQX2//nWoi5Mq4/4/Ua9Zrp+dyWyRhdzF/lwPXPQDmTu/pHxstXSUtZc34K7UizlHyBHaK2LFMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8SrpIf/Lat+BhZRQKoiLgahfmAYBon0yfVzzuEHEvc=;
 b=e3Cu1gCDscRshi13sqlsV2DemcL5pfLr6tyfJwVgeHvc2sTbA7gvvgZEV59yoKQGyYYye2q0aZ0qsi+NWsNO/AfyXcKlGVJBHyVW8FwS1xC+bBsQXH8v/ArEC0dGmp+bqrbZ264Sxkv0SXFgl/tTAJdCaEtSB1p4zzNBT5i1uk4o2j730kEFw0Or35yO+VtZngjAwPAv/jo5Yuw8Z2MGK71J+tyEqy2bqxyAUNK/+FZfOA/hwyxWDHuRLyhz7DYbwfp64Rs2Ae4nzdukgxs92+wlPuN+vNkZcWEoXsab2KK3hBors8u2vSJnvJGeTUG6UHbfZdm0WFdShLPfRfEExg==
Received: from DM6PR02CA0156.namprd02.prod.outlook.com (2603:10b6:5:332::23)
 by DM5PR12MB4661.namprd12.prod.outlook.com (2603:10b6:4:aa::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 09:32:02 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::e8) by DM6PR02CA0156.outlook.office365.com
 (2603:10b6:5:332::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Wed, 27 Apr 2022 09:32:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Wed, 27 Apr 2022 09:32:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 09:32:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 02:32:01 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 27 Apr
 2022 02:31:58 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH mlx5-next 2/5] net/mlx5: Expose mlx5_sriov_blocking_notifier_register /  unregister APIs
Date:   Wed, 27 Apr 2022 12:31:17 +0300
Message-ID: <20220427093120.161402-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220427093120.161402-1-yishaih@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e395181b-67f6-4eed-328c-08da2830c930
X-MS-TrafficTypeDiagnostic: DM5PR12MB4661:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB46617FD19AA4C4A406B6FAD8C3FA9@DM5PR12MB4661.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /BDpMMCWqdmZBLC3n0u6ja72v09NCz9CYcIk06cBYQf6ueHIms+7cjiW9JNwBgEbynUe64kryA9oCmDKEsMikuRG5DqzwxjkPAWPm6v+jGOulP4YwJaqd0KKkGdrLBUjI/wCPNVRCXZBTGs2wWa29FVozk7Q921Ias7iCcMzcTR16+okcGr4ybuChOsQTy01dUwIm+/PTLizxP7tswH1qXbr0FhIJzLh4LBZqFPoegO3W7oiHpeSbSTnO9UncKHYfs5hXsyBUt7/xvGbCQyfoWm8/rSHnvA932y93v0oX4ALlnax83Uv6sq3ND/QtrQyrUDsyKQGAurcxVx5b2+a3QjjMxUpGjKVxdfj6WkMN2KjAHcp6J80A20vdL3J2YAQniixWEMWmWupubjFlpg3ugWvKS/4G08r27AAG2soOfPuX1+uqCoRwNA4qde6Y/FLZbXe8EhbF48mno6wgTKMULWnZaSKl2N7nggVgoUJ3i65f3lGX90GLH0l8gKddxOJD97IxyVYych8qDMaPLX7+0Z3g7fFGULu4oj9zPKsq7TdV2UcVwo3vtsgJSvGbKsm3Jibu+vx1W1bT8aQZM9iAlek35yHMXMdlFP83tGHCDpknO68+ZMw6LhoyVUxtD7+221216fwdgUvVbqXx7rTXqsdFX7Bc2tnhHlT7JRoWcFyAoBmIcE8hcW9U1mlAxHY8Gpx2WNX1d73MlVpHIukGQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70586007)(47076005)(426003)(8936002)(4326008)(8676002)(70206006)(508600001)(83380400001)(336012)(356005)(7696005)(40460700003)(86362001)(2906002)(2616005)(5660300002)(82310400005)(26005)(81166007)(6636002)(1076003)(6666004)(186003)(54906003)(36860700001)(36756003)(316002)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 09:32:02.4173
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e395181b-67f6-4eed-328c-08da2830c930
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4661
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose mlx5_sriov_blocking_notifier_register / unregister APIs to let a
VF register to be notified for its enablement / disablement by the PF.

Upon VF probe it will call mlx5_sriov_blocking_notifier_register() with
its notifier block and upon VF remove it will call
mlx5_sriov_blocking_notifier_unregister() to drop its registration.

This can give a VF the ability to clean some resources upon disable
before that the command interface goes down and on the other hand sets
some stuff before that it's enabled.

This may be used by a VF which is migration capable in few cases.(e.g.
PF load/unload upon an health recovery).

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 65 ++++++++++++++++++-
 include/linux/mlx5/driver.h                   | 12 ++++
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 887ee0f729d1..2935614f6fa9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -87,6 +87,11 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 enable_vfs_hca:
 	num_msix_count = mlx5_get_default_msix_vec_count(dev, num_vfs);
 	for (vf = 0; vf < num_vfs; vf++) {
+		/* Notify the VF before its enablement to let it set
+		 * some stuff.
+		 */
+		blocking_notifier_call_chain(&sriov->vfs_ctx[vf].notifier,
+					     MLX5_PF_NOTIFY_ENABLE_VF, dev);
 		err = mlx5_core_enable_hca(dev, vf + 1);
 		if (err) {
 			mlx5_core_warn(dev, "failed to enable VF %d (%d)\n", vf, err);
@@ -127,6 +132,11 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 	for (vf = num_vfs - 1; vf >= 0; vf--) {
 		if (!sriov->vfs_ctx[vf].enabled)
 			continue;
+		/* Notify the VF before its disablement to let it clean
+		 * some resources.
+		 */
+		blocking_notifier_call_chain(&sriov->vfs_ctx[vf].notifier,
+					     MLX5_PF_NOTIFY_DISABLE_VF, dev);
 		err = mlx5_core_disable_hca(dev, vf + 1);
 		if (err) {
 			mlx5_core_warn(dev, "failed to disable VF %d\n", vf);
@@ -257,7 +267,7 @@ int mlx5_sriov_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
 	struct pci_dev *pdev = dev->pdev;
-	int total_vfs;
+	int total_vfs, i;
 
 	if (!mlx5_core_is_pf(dev))
 		return 0;
@@ -269,6 +279,9 @@ int mlx5_sriov_init(struct mlx5_core_dev *dev)
 	if (!sriov->vfs_ctx)
 		return -ENOMEM;
 
+	for (i = 0; i < total_vfs; i++)
+		BLOCKING_INIT_NOTIFIER_HEAD(&sriov->vfs_ctx[i].notifier);
+
 	return 0;
 }
 
@@ -281,3 +294,53 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev)
 
 	kfree(sriov->vfs_ctx);
 }
+
+/**
+ * mlx5_sriov_blocking_notifier_unregister - Unregister a VF from
+ * a notification block chain.
+ *
+ * @mdev: The mlx5 core device.
+ * @vf_id: The VF id.
+ * @nb: The notifier block to be unregistered.
+ */
+void mlx5_sriov_blocking_notifier_unregister(struct mlx5_core_dev *mdev,
+					     int vf_id,
+					     struct notifier_block *nb)
+{
+	struct mlx5_vf_context *vfs_ctx;
+	struct mlx5_core_sriov *sriov;
+
+	sriov = &mdev->priv.sriov;
+	if (WARN_ON(vf_id < 0 || vf_id >= sriov->num_vfs))
+		return;
+
+	vfs_ctx = &sriov->vfs_ctx[vf_id];
+	blocking_notifier_chain_unregister(&vfs_ctx->notifier, nb);
+}
+EXPORT_SYMBOL(mlx5_sriov_blocking_notifier_unregister);
+
+/**
+ * mlx5_sriov_blocking_notifier_register - Register a VF notification
+ * block chain.
+ *
+ * @mdev: The mlx5 core device.
+ * @vf_id: The VF id.
+ * @nb: The notifier block to be called upon the VF events.
+ *
+ * Returns 0 on success or an error code.
+ */
+int mlx5_sriov_blocking_notifier_register(struct mlx5_core_dev *mdev,
+					  int vf_id,
+					  struct notifier_block *nb)
+{
+	struct mlx5_vf_context *vfs_ctx;
+	struct mlx5_core_sriov *sriov;
+
+	sriov = &mdev->priv.sriov;
+	if (vf_id < 0 || vf_id >= sriov->num_vfs)
+		return -EINVAL;
+
+	vfs_ctx = &sriov->vfs_ctx[vf_id];
+	return blocking_notifier_chain_register(&vfs_ctx->notifier, nb);
+}
+EXPORT_SYMBOL(mlx5_sriov_blocking_notifier_register);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9424503eb8d3..3d1594bad4ec 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -445,6 +445,11 @@ struct mlx5_qp_table {
 	struct radix_tree_root	tree;
 };
 
+enum {
+	MLX5_PF_NOTIFY_DISABLE_VF,
+	MLX5_PF_NOTIFY_ENABLE_VF,
+};
+
 struct mlx5_vf_context {
 	int	enabled;
 	u64	port_guid;
@@ -455,6 +460,7 @@ struct mlx5_vf_context {
 	u8	port_guid_valid:1;
 	u8	node_guid_valid:1;
 	enum port_state_policy	policy;
+	struct blocking_notifier_head notifier;
 };
 
 struct mlx5_core_sriov {
@@ -1155,6 +1161,12 @@ int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type
 struct mlx5_core_dev *mlx5_vf_get_core_dev(struct pci_dev *pdev);
 void mlx5_vf_put_core_dev(struct mlx5_core_dev *mdev);
 
+int mlx5_sriov_blocking_notifier_register(struct mlx5_core_dev *mdev,
+					  int vf_id,
+					  struct notifier_block *nb);
+void mlx5_sriov_blocking_notifier_unregister(struct mlx5_core_dev *mdev,
+					     int vf_id,
+					     struct notifier_block *nb);
 #ifdef CONFIG_MLX5_CORE_IPOIB
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 					  struct ib_device *ibdev,
-- 
2.18.1

