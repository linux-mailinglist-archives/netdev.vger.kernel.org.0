Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A7B52102E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238326AbiEJJG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiEJJGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:06:24 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2012415EE;
        Tue, 10 May 2022 02:02:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgmzDiFSckSsq8cqfwizFuPY6bf1gLGjxiOFTPl1Xo7G+DlziDA4CBW5TPjtDf70pVzOkj6sxwkKsZLdth030iAAdosawLG/WoxOsHw4fX6jX6IAe/H+Nb0Xxmh7WGEUgT/crzb3idpH/EbF0XbYdNo1p5NaotGMRwG3AVkjxVzQLdBo6bCkXn8ZvX6V9y8uB3n+pjJm+OCVkAgZaSBKBnZsVF09vDDyf5A7CJtSH/0oOu1SC6rP55ez8w6r2uiots7cmnZ6wqQRTPW8O6BaqQQ014rgMI04XLQN89XjkSGxGEIuImXpwX58bnKtM5AxaGktFJ4vxwNXqp2Q+qIuGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S8SrpIf/Lat+BhZRQKoiLgahfmAYBon0yfVzzuEHEvc=;
 b=SUpnl2tEU/Geb8teYOtmO0Ph7rwDTjHPfZHv31w2mPNzxXFegXT7qJnh4ZtYiJ4SJwpuOwI4dbrroHKk/UA6SVNBIFIsCDCdGyy65MoB1wXP0f/+KTrYQz8Yx842grWJnr0OT/3w/GbEao9B0Uhr9I9E/Z5SJK1hT5o/C52CamsC+arxH2J/66aBRBLC2f/4wHSa+8g4V9pqhXfi3kOnIQ3NyjgpA0jylKwBWFcRmjXxtmn9K39Aqn9NU6yy9eW+u37ipUkgtJzzsS1iFb+VXCgpJhAdU1zs80iRwvzYvY/2tG0qGGOnH0WcE8LDnGTYTElW+OvqM5/44xku3pY9lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8SrpIf/Lat+BhZRQKoiLgahfmAYBon0yfVzzuEHEvc=;
 b=DhqbGz/AkUap03chmnoO/yb3NIcwVCBlyl3WSWNzTOaHZgvvBBVRPs4IJL9hn+pIojt4j7YUyvEES57XS6M5EgfpZ2ae9iML0vbtggCy0VZzPTSIZhUT85DuPpwMZgB7vFPuUNrXENE5KYmZHDA3Ev2VL1o3m9CXH6eE43Hji1HPSeREoUeHl1PnPijmpZ7fHgTdSmFrm+xmnVjFu6epFg4rA3/0j2342D9M2WFW9xo0/v/xkDsUM+DDQig7w9pgi/qSl5jGa6kCoLDnWDwyOSA6Q4qM8ARCxZmlSOBH0XM8xpCkWKWdykOrlxSiumvzeiP0+9BetoxPomMkZzmx9Q==
Received: from BN9PR03CA0147.namprd03.prod.outlook.com (2603:10b6:408:fe::32)
 by DS7PR12MB5815.namprd12.prod.outlook.com (2603:10b6:8:77::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Tue, 10 May
 2022 09:02:24 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::28) by BN9PR03CA0147.outlook.office365.com
 (2603:10b6:408:fe::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Tue, 10 May 2022 09:02:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 09:02:23 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 10 May 2022 09:02:23 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 10 May 2022 02:02:22 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 10 May 2022 02:02:20 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 mlx5-next 1/4] net/mlx5: Expose mlx5_sriov_blocking_notifier_register /  unregister APIs
Date:   Tue, 10 May 2022 12:02:03 +0300
Message-ID: <20220510090206.90374-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220510090206.90374-1-yishaih@nvidia.com>
References: <20220510090206.90374-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 434a1729-b3f8-40e0-3671-08da3263cc8b
X-MS-TrafficTypeDiagnostic: DS7PR12MB5815:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5815701B23176319FDADACDAC3C99@DS7PR12MB5815.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jSrPg0MqicDgA8oymCKjk+80R1bVO537Rh5fSpuCalb0qpN38ValfbnspriMRUpyil9qMM6CxIN94WcVQxs3ijrHE5cGEp7VWlXvJJbBQYBL7XMvqQDQAnn7V64vpcS/ZNIfmvu27uw/CJI1SWzVsf0a8c98GTA9KgfG3U94ObfodxWc33vHqRkue+0zqWWA6UpJR/SjXtbsqMMM5eRs2My9HaDGkRa4UEMgGvxIEJOZXVUvAOxVcAGeVJ1ZKzkrv4BHl17HirqDbF7nbKtfZa+8gOYtdQtvGI8dK0z3MrynG83VmqcGAWhi8gsYU0cEA5W34ToLE23FPkys8sc5asNIevFNyNfhrdpeQD6g/axGBEVo4oJvotYkKCRIU/08dEnBraVvkdu/5bCvlxRCRS7cjmtswChmCFcY6dJ/luCUDraidw9nJ5Ki9EHzhuv2HzQlhxL6w0h0Z1mXuDrK8Zf5bg1MK1NekJ8vrd9Uq0H/KIjC3srohMNtZy47bPQV8vTR1rYNSqiKul3ZZfob8OrAb2D4dA/LXmmd2E7pl1rOIkTEn7kylEj69EL2qWnK8RBwPpa2GPs3F97i0I81qGEIxZwuH0ikcX6Y/i4Dm1QYtQz0axGmq9+9rX2EKrrbwl9B6jXlu8WQB0zRgaA7EbEXBpgYetV7GEi979bJzE92IPeme7g9cu0x7VdcrgVzGVzcnLZAKKy2GS9EPi2Sw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(6666004)(2616005)(426003)(336012)(356005)(36756003)(47076005)(83380400001)(81166007)(70206006)(8676002)(7696005)(4326008)(70586007)(1076003)(5660300002)(40460700003)(82310400005)(36860700001)(26005)(110136005)(86362001)(316002)(54906003)(8936002)(6636002)(2906002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 09:02:23.9454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 434a1729-b3f8-40e0-3671-08da3263cc8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5815
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

