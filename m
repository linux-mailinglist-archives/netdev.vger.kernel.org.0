Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A7651EDA8
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbiEHNPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 09:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiEHNPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 09:15:45 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFD2E0CC;
        Sun,  8 May 2022 06:11:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=na2MC1qB+S46MtAW3syY4OmO0xlXBUsrdQbIPIHwo4X4uYGE/hGymyUO57ZVURH5UC40u7Rmi5tZs9JHW5Ws/diXTIZ+fNU7O/zFs1QMRxHRVYsTQfAGWwFPl5/5LCIjHtXnJHYLhpU75eFOQy7ptcXXO09ZQRIDLXYK+7htP9z9muZWi2QhohF6QDS2FCiqOAjGvlEFBa1hOaPWIOFyD0UAJWTl3rdv9KYpBhB3zhLkJEDcVyKhMkjnOAFcTdBCys4hB4kdUGGQkjIRs/sBan8CpebjHwx83OgNNSW5jtu4r2Tx9VK3TNjGARUQhqaa7Y+Oh3lRp7RtQbX44X6J5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=414Lu1qD+Ha+GhDwTsSrTf4FyCjW5r34+jzbgahNiME=;
 b=DetTQS2od+KmqtbvpfMw8owEhxbS/4o923rAerLDQCCoBZ2eGS8//HKvQGH8UZBmDxVrHZutZvpGxwbZnJzqMIBM67wN3N82HGBgwLN8cuw224ZGtlIVraxXjwDiGUwDg1SYc0LDBmfCWGACrbLf7QkYZwDASarwZyZeIrsgkK0kf4b9yyAWe2KiGGREvv3W1BvOrOd1xoJCKYzCnqay86w7n4Z394Cb2IVWIPbXpuLdd71PEUC8uTiYQSzNPx067zBCmAV5GAQn5GjOzT3ckvq1N0Zi44ZXxewvwgaOYPTQCQbV6jhLLkAbR7SgHdh45Ge70oyieKp8N2vu90LnlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=414Lu1qD+Ha+GhDwTsSrTf4FyCjW5r34+jzbgahNiME=;
 b=E7VAEjYQbEtN8OofRur3HpKDoUQkaw0zSu2+prVUu8rEtS7SAqgiaug4qU9TIoogFvWh+QcMa71y8RYyeClLBEfl6iGB2fG+kfaWMXVAM7u8NEGZNbAhSZrAM8idYwqP+AEsm6hg+PJJa2f8+a5V2s4ORCeAtohL+lceYV2aE+9X88TC+Mms3TLV1QBW3y/ZJ2o1ffsW/zHIW4sPEfziwoIVzGgAKvch0vYVe0uwEFzteyIV2vnzh4I6DmRSW7WwOHeKAVO/39nfxOMXyYnVlArWF0vJG0Cp/79qmjPRWQhZJ4IbTYDm/418XdmeZM96IvV9QHB3H707zE4V/ku9LA==
Received: from MW4PR03CA0176.namprd03.prod.outlook.com (2603:10b6:303:8d::31)
 by MN2PR12MB3422.namprd12.prod.outlook.com (2603:10b6:208:ce::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 13:11:48 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::85) by MW4PR03CA0176.outlook.office365.com
 (2603:10b6:303:8d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Sun, 8 May 2022 13:11:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 13:11:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 13:11:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 06:11:46 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 8 May
 2022 06:11:44 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 mlx5-next 3/4] vfio/mlx5: Refactor to enable VFs migration in parallel
Date:   Sun, 8 May 2022 16:10:52 +0300
Message-ID: <20220508131053.241347-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220508131053.241347-1-yishaih@nvidia.com>
References: <20220508131053.241347-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43c9c98e-9f37-431d-ccbb-08da30f44f01
X-MS-TrafficTypeDiagnostic: MN2PR12MB3422:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB342215F1B2804DAAA226C5F6C3C79@MN2PR12MB3422.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oy5h6R7poIRBNT5FjDreb+IViSLPfdmP157axfc0Brjfv3OpnAYzTmXGpATW/UO42Pm0Hm2Yl4a46Vk+1d6yan1WwDcrcflpPc4mvxy69A93JxGkKa5krzfcGD4F0fa/TJoJBUBXFB12RWLtnROdipIFlLxy7C2XP9+UL+T6BeV4cWs+Ip5xyCNV0660z16Eob0OH/b+bjxobuGIblvD2VOVql0JFHcjnpOsNWJfcRaGoglgRC623x1BovVm06zdvW/vEmqgigmkIY2Jcb5sNiXYwB5bT4aZlbsfhhQL7R9DhV73jIiE6RhSn5gj+hJOsAmzxFVru78uUtYwvMIChYz6ANzOqw2JZdSYha3CgBfqoGHJvfwTsX3RXM0lVOPmFfzt6nMAurvViy2otYhMyEdxIloF7xq3h/R8ttLLaEBixQzl+/8kx84+ICS45CQb3xQ4OzmNw+bwY+V+qUrSlO9asoFru/B/748ShDSwqd54ljDCmJ5veNK0nn9JNRb6HK8ryP3n2PB2U7y8gZAFOKhdkCZdjahbK/BEVuhhv6hZ5P9k/FWO+1JOA9tuNcst5t3DXcNNZx5A/W8Hp+KRTUCSbMlfBjPXF+ilcbb2roPpCwjMSL/FUs7JOfDGB+9b9Q1YtFdOMZjwY9UkYXXymd7L1talQT5Y3tMZlwZGCKC9IvBJvttgQzUt7pqRZvedSegFREUbbSGWMfzupnT6sw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(36860700001)(82310400005)(36756003)(5660300002)(30864003)(8676002)(70206006)(4326008)(70586007)(8936002)(1076003)(110136005)(83380400001)(54906003)(86362001)(40460700003)(186003)(2616005)(6636002)(26005)(336012)(7696005)(47076005)(316002)(81166007)(6666004)(426003)(356005)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 13:11:48.0768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c9c98e-9f37-431d-ccbb-08da30f44f01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3422
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/mlx5/cmd.c  | 103 +++++++++++++++--------------------
 drivers/vfio/pci/mlx5/cmd.h  |  11 ++--
 drivers/vfio/pci/mlx5/main.c |  44 ++++-----------
 3 files changed, 59 insertions(+), 99 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5031978ae63a..9a6e3d3e0d44 100644
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
@@ -117,6 +112,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
 	if (mvdev->vf_id < 0)
 		goto end;
 
+	if (mlx5vf_cmd_get_vhca_id(mvdev->mdev, mvdev->vf_id + 1,
+				   &mvdev->vhca_id))
+		goto end;
+
 	mutex_init(&mvdev->state_mutex);
 	spin_lock_init(&mvdev->reset_lock);
 	mvdev->nb.notifier_call = mlx5fv_vf_event;
@@ -134,23 +133,18 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
 	mlx5_vf_put_core_dev(mvdev->mdev);
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
@@ -168,8 +162,6 @@ int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
 
 err_exec:
 	kfree(out);
-end:
-	mlx5_vf_put_core_dev(mdev);
 	return ret;
 }
 
@@ -214,21 +206,23 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
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
@@ -242,7 +236,7 @@ int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 	MLX5_SET(save_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_SAVE_VHCA_STATE);
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
-	MLX5_SET(save_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(save_vhca_state_in, in, size, migf->total_length);
 
@@ -250,37 +244,28 @@ int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
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
@@ -289,6 +274,7 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 		goto end;
 	}
 
+	mdev = mvdev->mdev;
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
 		goto end;
@@ -304,7 +290,7 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 	MLX5_SET(load_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_LOAD_VHCA_STATE);
 	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
-	MLX5_SET(load_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(load_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(load_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(load_vhca_state_in, in, size, migf->total_length);
 
@@ -316,7 +302,6 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 err_reg:
 	mlx5_core_dealloc_pd(mdev, pdn);
 end:
-	mlx5_vf_put_core_dev(mdev);
 	mutex_unlock(&migf->lock);
 	return err;
 }
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 340a06b98007..2a20b7435393 100644
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
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev);
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
index 9716c87e31f9..5bda6c0e194c 100644
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

