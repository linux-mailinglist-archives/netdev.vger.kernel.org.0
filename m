Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837BC51EDA6
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbiEHNPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiEHNPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:15:35 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2082.outbound.protection.outlook.com [40.107.100.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6526DE0CC;
        Sun,  8 May 2022 06:11:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdQ9iYMaZMyTA5qgYCVEqityRoz5lH7CApvMJMl08kfIZjKc13pI5wa7naxHgnmM12ctgkQLj8vk0IK/cm2n2753RCHvXREAa1Rk8sfzUbz099yCxohiNWOcdkWz8bpJFEm2GkJB7BXTd+UBgEGBx3w4jl+9fPrY+WQUsQPvBvnG2B55ZT6y1TRaiqhuhvEZ3d6XBc/aAjJtqxOmqz1lrgKk+5OE7ucKeLAFM9K4Ub3RFShOf5YqyITFa7O4lKKxEaK15ojMzPPMuXX4FOQgOSsBzmHBccBMmbi7zoUL5zCSy/Ca4RSudasKxyKa+n3fU3EG5k7cImUk5YmJxMPI4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8SrpIf/Lat+BhZRQKoiLgahfmAYBon0yfVzzuEHEvc=;
 b=lmuxMQN08vZY4ki7FJe98+tbOtnvpa+3Fn2Wakm9LRFIbplREhuOQpNKYfPpXBjVRVICOS06rnIed4N0W2I08WuvDAZf0nixNp1V+pueMEgdbRwMh/ULriZyyk0uRFVqHCcAJ2wjlDlaDs1oXK6mRm9YokivqBHhQAGIF/y/Zpgf5dei0dRu0FfxJAfXE7fUu6Zqxl83rJc9swCoRIgOrGhlyb119ImqoZ6/EBOD2Xpo2+I1vIxbSBps0eNIehNsk6MVvofU4ygb5KBYzq24xijCwLiUulHtR/FfbPDiY9nF7I2Mk7Xjg026qARZQJSzOOhXyHdKtziQo6VfHHiNjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8SrpIf/Lat+BhZRQKoiLgahfmAYBon0yfVzzuEHEvc=;
 b=pz6YpdTdIGhQ6kFvSCu8cDGWC90M0BEJpxHt0EE8NL2q2gSaihSjwYYbnLNyccM/2Z4P6Olfgjj0hCNXrDH3EjEz6tRvalS23ky8uFWc3dpMj9sF7RUF8lfh54BEHyIl6zATZL8Q+pC2aSHtj2DCJl4oRt2ccgCDy5ONbam3PlNhE4w6joNUVsbolWbO2+IsKOkoMx+/MwWcs4pYtrGBWBDLorjXUt1QqjyT2Fxvh19n+tgOCmy8I/vKra72aC9Vo1uWrsEQJvmEyXgYIvzEt+zBtjrWNIvqOinlj/m/tzY+UGTlh4z0QGaZqHRfhfaAQd6FZNqf11J68zZL92+yGg==
Received: from MW3PR05CA0006.namprd05.prod.outlook.com (2603:10b6:303:2b::11)
 by BL0PR12MB2386.namprd12.prod.outlook.com (2603:10b6:207:47::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sun, 8 May
 2022 13:11:41 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2b:cafe::7c) by MW3PR05CA0006.outlook.office365.com
 (2603:10b6:303:2b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13 via Frontend
 Transport; Sun, 8 May 2022 13:11:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 13:11:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 13:11:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 06:11:40 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 8 May
 2022 06:11:37 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 mlx5-next 1/4] net/mlx5: Expose mlx5_sriov_blocking_notifier_register /  unregister APIs
Date:   Sun, 8 May 2022 16:10:50 +0300
Message-ID: <20220508131053.241347-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220508131053.241347-1-yishaih@nvidia.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c302453-9ccb-458a-a613-08da30f44b04
X-MS-TrafficTypeDiagnostic: BL0PR12MB2386:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2386A23B89C6A6A17E063A39C3C79@BL0PR12MB2386.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KFSJkBf2bi9KqvNCn0LfU6wfRpQlFjk1Wpcmed1o4U3e6gFFWazdfILlhIzsQKm0aAvU31OHLP3TCR0yaidHJhalWeWQvdX3AZbP/UIVDnJpZnNlAuF6zjYiANIqzyIqn1cQUsNVwdl2Hl1yII66/8h/9Ru9pFf+vAJ4bb2w8qPqbwkCiFr6zXU2bn6jX2j6UU4sNNada9GYiIOmYHTyWzmLdKMR7HjR3Ya/Jh7Qnf5Z9ezPu8Z9vpGk+NmuNKFQnxc3lgAEF5mrYr9oTi3nq1FRT/iVhsd0GpUuRbUw3Ly00fbtKange9Gaqz3Sb2RwiEd/lZDFU1JgC6QDomJ2Jh8AAmxUJ7r1+9rYVF3+lZa0tn5lfDLxXw3rtT0Ec7IOFNWwz3eA5XNaC9+w1MLkClia9EoRqLCnh9g5tARz83LqNHAa9CeSOYnwR8KE/bXvbRlhX5GD9tazPonm4cqoiPGIWagAjycZi8Kw4kdDdtP81V0Hd9zZX/kPTg8QZ4TWrvAKat2pmPfFriSSVzo60gBKYvIKzAIo2GpMIsGPZP9SbYyBtdSYN/YGA8V4x2jqBfu91R/Ln036N3rzM37Oj1UiPToqvaZDWkv10lwJxrDb5dR4BQbtSYDMA6RD3ddcETa3vqh4Z7H4mzlI7SE2rn9u5ZTWR/k61FimnBQNCPqmn/hYoN/Vy3feQ9KzKnHnemaJ+wJLBRe/lkpdlDwvxA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(1076003)(8936002)(6636002)(316002)(5660300002)(47076005)(508600001)(82310400005)(426003)(54906003)(110136005)(336012)(36756003)(186003)(70206006)(70586007)(40460700003)(36860700001)(4326008)(86362001)(26005)(2616005)(8676002)(81166007)(6666004)(83380400001)(356005)(2906002)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 13:11:41.4002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c302453-9ccb-458a-a613-08da30f44b04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2386
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

