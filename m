Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67065115CB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiD0KxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiD0KxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:53:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1BD28B757;
        Wed, 27 Apr 2022 03:25:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnI29QbeS3K5lZimZRVkgpmJA3lBrYkNhwfQFjAZJkaexDJb08Vb62OlqOXAArfmRVv5LR1lHobc7ycMMHVSfPk5BGoY1LEY7bEJFJ2pQnabvjx7QiUlS0KDmWsiXVLLHb9+L8j4DzRPYGX8AXA52U0whwtktaVIhLuh2t5nRwmYbDKMyIeJx+Nbpd/ZF8znggDBIegDJ3VL845a4+/BP2Rf4Vt9s7vvP527STqTHtXeWIZwoQrt6DKufSWnXJScmSrlN+y4oZxYBKKs1W/UKCejdAL9N5JbZkG/xGknvLYlXTS2cQbgrKCn/H5ixDBTGXIMi89NQIG8j8xBU/EQxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6F7Xr3Y6KXBBcNb3WRzbiJjmuIjnrFqXNSJxYpKeqk=;
 b=M6IJ3bl2rrBW+x5lPmTyUNQrVMjf6C2XDwYMv6ZPVRyuEgT0HeOiEaewRUZdwGERjiS4LbdFh7xfLnV0mlIRN9KfyPVC55kX9b18IG3LRqG6KmpakMHX9w9WXxAcbYagpV8Qy/tNLWDerKIahJeQxYKVK/mb3KtkIlj+D5cGsTsjd+9SQV+j46BceY61hBnqd/9i1u02uZtWnxrwtFxAyVsBZjYMT+f/sL7sQkBWkqCMP46t8HlZNy7Zub8ooWVd8hhXsCCDEBYUOnkz7AGPv9SMKKi6qg/D1ml+FzY/6NRNZYuhZLAMYMQakxAxusrLTCd3ab3e142Vy/hw0vfOzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6F7Xr3Y6KXBBcNb3WRzbiJjmuIjnrFqXNSJxYpKeqk=;
 b=m1u+8Qc1ob0JAzl9nqrFYUdymWm33uxJJo7gOy0kz6PE3WXXJaGwyHme13c+TjRrbqSspButX4FXldoyzI3yAB65eid48xsXEkhSq6a6WSRHn5M8++DsXdFlqqQEsA0taR9dzjwZmSd9mea8WTGkCG3w+JF/uUqR/ncv6QXkp42c1GavMlnwVwRc98hKoNc0D2wzSLwcYn7grEBoGS0hqI54rVHq/rWs/Vd1XBhLCHWDAec+n33nhXqyJpu6s7PuGVgTBbc0zNkugEG6qP4vjKi3D5BwEybCibJ0P0XRA0CghllD3auKdB2J0mTcl2/ceWDJ5/zx5D3kPQJoCL9ufw==
Received: from DM6PR07CA0046.namprd07.prod.outlook.com (2603:10b6:5:74::23) by
 CY4PR12MB1701.namprd12.prod.outlook.com (2603:10b6:903:121::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Wed, 27 Apr 2022 09:32:09 +0000
Received: from DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::6d) by DM6PR07CA0046.outlook.office365.com
 (2603:10b6:5:74::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Wed, 27 Apr 2022 09:32:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT046.mail.protection.outlook.com (10.13.172.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Wed, 27 Apr 2022 09:32:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 09:32:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 02:32:07 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 27 Apr
 2022 02:32:04 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH mlx5-next 4/5] vfio/mlx5: Refactor to enable VFs migration in parallel
Date:   Wed, 27 Apr 2022 12:31:19 +0300
Message-ID: <20220427093120.161402-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220427093120.161402-1-yishaih@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4e0869c-4a08-4378-8dcd-08da2830ccf0
X-MS-TrafficTypeDiagnostic: CY4PR12MB1701:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB17010BB1E204A9ED8BABFBC7C3FA9@CY4PR12MB1701.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxRaz3MLifJphAwvtuhTWbEQaBn1JpwvJ9ndOUBGooWhZKugPJZDBai1mGghOQ/tWG1oADyCcygN3mWW3TZVjtFSGZs2bX4nnA7m9CFpqeBdL70qZfs9zq9VGtGe68mN63cWJgFN2jcOwnBO+eNqRoNjd7LEIm8OuZi0WnRV3DUcLqLHFVqgFgUlNRfYgFIXDNi/Xqdt1AYZl09LFF/S1PA9IVATgZZQF8Tlm++KoQd3ZqxCZDj/TFq43xfO7l467awOl3RPs+4n++M097MeY2QKjaqUXjfam4xz/RbskJS9A1FbiiHeTy6ENFtE51VBUWNV7U3jZWVF7cCgZaMG22kEnFV469MNlMb7ZBZZedzOPi7TlEAW822YVy8P7inPu5f99j6sMbP03ji1R7YGqallcThUNQ1weUIbBhAcatTjjHQGf7h5dJfytIcqHU6ZssgPGoiTLnG8ONhGPDCO0vfV8kiXJWKrpaBfXLMrz0TsQrROH9453z5kgCwsgcf2qb7gHCRKwCf8/uA2zmCGDyJ7MjthsbxOPO9il1ZeuliLj81AiQWCNvYbnyJtgpT+PboEMKXxbuqUJ2McOuMLkrQmFDEom13pKWgT2cmGl8wztd6PaiWZPOj2MPyoGZSEJUnFn/JcfO01tOkWx0S8002daq9ab7LgnPMn2IIdx01SbVvjuHV08fCxITbpkXYUaHsRyj3HsyuuW0+3OHZUaQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(70206006)(316002)(5660300002)(36756003)(7696005)(186003)(2906002)(30864003)(4326008)(8676002)(83380400001)(6636002)(8936002)(70586007)(110136005)(54906003)(2616005)(47076005)(86362001)(40460700003)(336012)(426003)(82310400005)(508600001)(81166007)(356005)(6666004)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 09:32:08.6486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e0869c-4a08-4378-8dcd-08da2830ccf0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1701
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor to enable different VFs to run their commands over the PF
command interface in parallel and to not block one each other.

This is done by not using the global PF lock that was used before but
relying on the VF attach/detach mechanism to sync.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 102 +++++++++++++++--------------------
 drivers/vfio/pci/mlx5/cmd.h  |  11 ++--
 drivers/vfio/pci/mlx5/main.c |  44 ++++-----------
 3 files changed, 58 insertions(+), 99 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 1f84d7b9b9e5..ba06b797d630 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -5,70 +5,65 @@
 
 #include "cmd.h"
 
-int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod)
+static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
+				  u16 *vhca_id);
+
+int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 {
-	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
 	u32 out[MLX5_ST_SZ_DW(suspend_vhca_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(suspend_vhca_in)] = {};
-	int ret;
 
-	if (!mdev)
+	lockdep_assert_held(&mvdev->state_mutex);
+	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
 	MLX5_SET(suspend_vhca_in, in, opcode, MLX5_CMD_OP_SUSPEND_VHCA);
-	MLX5_SET(suspend_vhca_in, in, vhca_id, vhca_id);
+	MLX5_SET(suspend_vhca_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(suspend_vhca_in, in, op_mod, op_mod);
 
-	ret = mlx5_cmd_exec_inout(mdev, suspend_vhca, in, out);
-	mlx5_vf_put_core_dev(mdev);
-	return ret;
+	return mlx5_cmd_exec_inout(mvdev->mdev, suspend_vhca, in, out);
 }
 
-int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod)
+int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod)
 {
-	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
 	u32 out[MLX5_ST_SZ_DW(resume_vhca_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(resume_vhca_in)] = {};
-	int ret;
 
-	if (!mdev)
+	lockdep_assert_held(&mvdev->state_mutex);
+	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
 	MLX5_SET(resume_vhca_in, in, opcode, MLX5_CMD_OP_RESUME_VHCA);
-	MLX5_SET(resume_vhca_in, in, vhca_id, vhca_id);
+	MLX5_SET(resume_vhca_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(resume_vhca_in, in, op_mod, op_mod);
 
-	ret = mlx5_cmd_exec_inout(mdev, resume_vhca, in, out);
-	mlx5_vf_put_core_dev(mdev);
-	return ret;
+	return mlx5_cmd_exec_inout(mvdev->mdev, resume_vhca, in, out);
 }
 
-int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
+int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size)
 {
-	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
 	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
 	int ret;
 
-	if (!mdev)
+	lockdep_assert_held(&mvdev->state_mutex);
+	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
-	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(query_vhca_migration_state_in, in, op_mod, 0);
 
-	ret = mlx5_cmd_exec_inout(mdev, query_vhca_migration_state, in, out);
+	ret = mlx5_cmd_exec_inout(mvdev->mdev, query_vhca_migration_state, in,
+				  out);
 	if (ret)
-		goto end;
+		return ret;
 
 	*state_size = MLX5_GET(query_vhca_migration_state_out, out,
 			       required_umem_size);
-
-end:
-	mlx5_vf_put_core_dev(mdev);
-	return ret;
+	return 0;
 }
 
 static int mlx5fv_vf_event(struct notifier_block *nb,
@@ -125,6 +120,9 @@ bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev)
 	if (mvdev->mdev_detach)
 		goto unreg;
 
+	if (mlx5vf_cmd_get_vhca_id(mvdev->mdev, mvdev->vf_id + 1, &mvdev->vhca_id))
+		goto unreg;
+
 	mlx5vf_state_mutex_unlock(mvdev);
 	migratable = true;
 	goto end;
@@ -138,23 +136,18 @@ bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev)
 	return migratable;
 }
 
-int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
+static int mlx5vf_cmd_get_vhca_id(struct mlx5_core_dev *mdev, u16 function_id,
+				  u16 *vhca_id)
 {
-	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
 	u32 in[MLX5_ST_SZ_DW(query_hca_cap_in)] = {};
 	int out_size;
 	void *out;
 	int ret;
 
-	if (!mdev)
-		return -ENOTCONN;
-
 	out_size = MLX5_ST_SZ_BYTES(query_hca_cap_out);
 	out = kzalloc(out_size, GFP_KERNEL);
-	if (!out) {
-		ret = -ENOMEM;
-		goto end;
-	}
+	if (!out)
+		return -ENOMEM;
 
 	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
 	MLX5_SET(query_hca_cap_in, in, other_function, 1);
@@ -172,8 +165,6 @@ int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
 
 err_exec:
 	kfree(out);
-end:
-	mlx5_vf_put_core_dev(mdev);
 	return ret;
 }
 
@@ -218,21 +209,23 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
 	return err;
 }
 
-int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf)
 {
-	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
 	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	struct mlx5_core_dev *mdev;
 	u32 pdn, mkey;
 	int err;
 
-	if (!mdev)
+	lockdep_assert_held(&mvdev->state_mutex);
+	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
+	mdev = mvdev->mdev;
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
-		goto end;
+		return err;
 
 	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE,
 			      0);
@@ -246,7 +239,7 @@ int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 	MLX5_SET(save_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_SAVE_VHCA_STATE);
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
-	MLX5_SET(save_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(save_vhca_state_in, in, size, migf->total_length);
 
@@ -254,37 +247,28 @@ int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 	if (err)
 		goto err_exec;
 
-	migf->total_length =
-		MLX5_GET(save_vhca_state_out, out, actual_image_size);
-
-	mlx5_core_destroy_mkey(mdev, mkey);
-	mlx5_core_dealloc_pd(mdev, pdn);
-	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
-	mlx5_vf_put_core_dev(mdev);
-
-	return 0;
-
+	migf->total_length = MLX5_GET(save_vhca_state_out, out,
+				      actual_image_size);
 err_exec:
 	mlx5_core_destroy_mkey(mdev, mkey);
 err_create_mkey:
 	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
 err_dma_map:
 	mlx5_core_dealloc_pd(mdev, pdn);
-end:
-	mlx5_vf_put_core_dev(mdev);
 	return err;
 }
 
-int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf)
 {
-	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	struct mlx5_core_dev *mdev;
 	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
 	u32 pdn, mkey;
 	int err;
 
-	if (!mdev)
+	lockdep_assert_held(&mvdev->state_mutex);
+	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
 	mutex_lock(&migf->lock);
@@ -293,6 +277,7 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 		goto end;
 	}
 
+	mdev = mvdev->mdev;
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
 		goto end;
@@ -308,7 +293,7 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 	MLX5_SET(load_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_LOAD_VHCA_STATE);
 	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
-	MLX5_SET(load_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(load_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(load_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(load_vhca_state_in, in, size, migf->total_length);
 
@@ -320,7 +305,6 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 err_reg:
 	mlx5_core_dealloc_pd(mdev, pdn);
 end:
-	mlx5_vf_put_core_dev(mdev);
 	mutex_unlock(&migf->lock);
 	return err;
 }
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index f47174eab4b8..3246c73395bc 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -43,16 +43,15 @@ struct mlx5vf_pci_core_device {
 	u8 mdev_detach:1;
 };
 
-int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
-int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
-int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
+int mlx5vf_cmd_suspend_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
+int mlx5vf_cmd_resume_vhca(struct mlx5vf_pci_core_device *mvdev, u16 op_mod);
+int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 					  size_t *state_size);
-int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
 bool mlx5vf_cmd_is_migratable(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev);
-int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
-int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 			       struct mlx5_vf_migration_file *migf);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 #endif /* MLX5_VFIO_CMD_H */
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 445c516d38d9..f9793a627c24 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -208,8 +208,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 
-	ret = mlx5vf_cmd_query_vhca_migration_state(
-		mvdev->core_device.pdev, mvdev->vhca_id, &migf->total_length);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
+						    &migf->total_length);
 	if (ret)
 		goto out_free;
 
@@ -218,8 +218,7 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	if (ret)
 		goto out_free;
 
-	ret = mlx5vf_cmd_save_vhca_state(mvdev->core_device.pdev,
-					 mvdev->vhca_id, migf);
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf);
 	if (ret)
 		goto out_free;
 	return migf;
@@ -346,8 +345,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	int ret;
 
 	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_STOP) {
-		ret = mlx5vf_cmd_suspend_vhca(
-			mvdev->core_device.pdev, mvdev->vhca_id,
+		ret = mlx5vf_cmd_suspend_vhca(mvdev,
 			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_RESPONDER);
 		if (ret)
 			return ERR_PTR(ret);
@@ -355,8 +353,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
-		ret = mlx5vf_cmd_resume_vhca(
-			mvdev->core_device.pdev, mvdev->vhca_id,
+		ret = mlx5vf_cmd_resume_vhca(mvdev,
 			MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_RESPONDER);
 		if (ret)
 			return ERR_PTR(ret);
@@ -364,8 +361,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
-		ret = mlx5vf_cmd_suspend_vhca(
-			mvdev->core_device.pdev, mvdev->vhca_id,
+		ret = mlx5vf_cmd_suspend_vhca(mvdev,
 			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_INITIATOR);
 		if (ret)
 			return ERR_PTR(ret);
@@ -373,8 +369,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
-		ret = mlx5vf_cmd_resume_vhca(
-			mvdev->core_device.pdev, mvdev->vhca_id,
+		ret = mlx5vf_cmd_resume_vhca(mvdev,
 			MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_INITIATOR);
 		if (ret)
 			return ERR_PTR(ret);
@@ -409,8 +404,7 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
-		ret = mlx5vf_cmd_load_vhca_state(mvdev->core_device.pdev,
-						 mvdev->vhca_id,
+		ret = mlx5vf_cmd_load_vhca_state(mvdev,
 						 mvdev->resuming_migf);
 		if (ret)
 			return ERR_PTR(ret);
@@ -517,34 +511,16 @@ static int mlx5vf_pci_open_device(struct vfio_device *core_vdev)
 	struct mlx5vf_pci_core_device *mvdev = container_of(
 		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
 	struct vfio_pci_core_device *vdev = &mvdev->core_device;
-	int vf_id;
 	int ret;
 
 	ret = vfio_pci_core_enable(vdev);
 	if (ret)
 		return ret;
 
-	if (!mvdev->migrate_cap) {
-		vfio_pci_core_finish_enable(vdev);
-		return 0;
-	}
-
-	vf_id = pci_iov_vf_id(vdev->pdev);
-	if (vf_id < 0) {
-		ret = vf_id;
-		goto out_disable;
-	}
-
-	ret = mlx5vf_cmd_get_vhca_id(vdev->pdev, vf_id + 1, &mvdev->vhca_id);
-	if (ret)
-		goto out_disable;
-
-	mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	if (mvdev->migrate_cap)
+		mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
 	vfio_pci_core_finish_enable(vdev);
 	return 0;
-out_disable:
-	vfio_pci_core_disable(vdev);
-	return ret;
 }
 
 static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
-- 
2.18.1

