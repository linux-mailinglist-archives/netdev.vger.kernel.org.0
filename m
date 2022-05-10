Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9A2521031
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238334AbiEJJGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiEJJG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:06:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98462415EE;
        Tue, 10 May 2022 02:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0jdH2nTUmdaVa1TkismMMs9FODn8G9wLgLIzRAgmtEyekrTSkeUMi4dY2ln8fkbc/4qUR/hJDbLnre50UvP6XeupgE3bMh2PQOrTTZMXFYMa4c5GtQoo2oRJB5xcTxMELBcCD6Mfw6HU5/kkDuklgq3gtpCGJglI5KMSlBMNtrNU1Cb7zlZfatqi7MIoYSgJPc20eQBZhVOPJqVQJMPsuChJOo2hOeYnSS0iwJxc/hDcIgqYysBvlDbgpf/oQ/rx8Gc5OIHB7H5aeHR9ZqQdsjs2S6Ls/+6Ur2KvhlxUTcyQNmqwEsNCeiz4fFLx83+Zz+8ZaQ3zWyMxIK99g1V8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoQQxkwFlEPlGYynXtSx0OtJoUDM6cC5N1YIjJDiA1o=;
 b=EN4T4y0rRSZ1woe4viBYZ5AZNfnhuZGgKFdomNaluIQTa6LmE83fHRMW49Ib4TF6WM53NhuXuRBKe96Dwwy2B2cJVTzIhU1U3nBNvFdXV6aQIgaHvZk9mQLKjWDhvG8Y1kCCYwzjv4TUDlSbW3THjSkCriXzVefvd9G6dWasVJ70SG2XWn9uW21rZac4SmHC8czeVL97Ajg7LB5NhMXJEcZBO3TEGGs3OHBvuWU4+PAus/IyQMHg/5UPsEIuwwJ0SPtAaAKxajBzh6yOfrgtkI3pRvZtXRPzNUj9nlJydOuvwr7SfGyJX+BqYvYoGoPO5jev+VGYWBbxyQKBqrY92g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoQQxkwFlEPlGYynXtSx0OtJoUDM6cC5N1YIjJDiA1o=;
 b=AWuzT61bdc8f/L4QvNXeQG4YOk2SAqRqzOlTX5Q7xsALoF9IECHO+1YYmqH1G4WTzUDXQw4U+n6RF/usuCeLj4t43XzP9DvMy9rAQNnLBQylmh0Qq58O3flNIVbvI2gTUJM2yDgNv0IGKucYZuXcb1Vu3MmxdwPP+nKitKdx3cL4kxEmFn5Y6TbtN6cDawMV4//uGmLFcex7NdWfuJuw+rrFZ3nrx8j9SDc4DGu8f2FCUfQkdisYfKma1SbLDOtWVWJFASDXNYHX9bOHHDIM3KLgfnQGV5jzaIcsruVTSI+faXdbJYLUSXvVVrvhavTgj1pkZaKnyWRbZVaEDvGgbQ==
Received: from MW4PR04CA0222.namprd04.prod.outlook.com (2603:10b6:303:87::17)
 by BYAPR12MB3543.namprd12.prod.outlook.com (2603:10b6:a03:130::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Tue, 10 May
 2022 09:02:30 +0000
Received: from CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::e6) by MW4PR04CA0222.outlook.office365.com
 (2603:10b6:303:87::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Tue, 10 May 2022 09:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT019.mail.protection.outlook.com (10.13.175.57) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Tue, 10 May 2022 09:02:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 10 May 2022 09:02:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 10 May 2022 02:02:29 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 10 May 2022 02:02:26 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 mlx5-next 3/4] vfio/mlx5: Refactor to enable VFs migration in parallel
Date:   Tue, 10 May 2022 12:02:05 +0300
Message-ID: <20220510090206.90374-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220510090206.90374-1-yishaih@nvidia.com>
References: <20220510090206.90374-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43ca9bfc-8a35-41ed-d1c8-08da3263cfff
X-MS-TrafficTypeDiagnostic: BYAPR12MB3543:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3543037415590D7196A157E9C3C99@BYAPR12MB3543.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7+NlZnWHSJh6huO80KjAvrEeGDmtcAtQU0du/tMJn8qUehNFVGwXaWU2Ua345CnPTARYdS2h9ZOgeycLmFntzGiLIHQQll9wEGrcGlzp8LdsUOr88ynbWLcLrEtcqRdMww1Wk3/Gj8j73LDzetp0wFoXEy00e/bOx8iHY6p+N9vO6KpEMd6v1vsFi/aaN65f8AYbtMA+Oh61tAouunvHu/V0un31INVqJaGY1llZlLNTi+FjmInEyEPNc6R4+rgmClmDgRzvdWgrRM39e3T+YIwfY/aqUxS7+rw8MzH6LDHyXvWYYlgrUC2kyo5dTPDjfhEL3uKw8in2kYZhvSOxwigGLEVzsDB0DMe/BoIoZ3h6LbNnsJBSApaohy9eGw3Z0uXOKmW+39gEkRo+9jetiON7PksDTo13jdwVtUbt7+IPGcGUJqMmwfacbaVEKOB11pELvJH0o7QT1N/mdUBE+IWZ5ltyH3X1ikuq8UE5hH/8aUS0FMO+x6AQjVB6TawY9XcW9tn0mVDwxQS4Ai9X6G/sm4rB0+5g1ykHz3M6U0EKbsfL8DI/MRrXRTm+zpiumymSP88OESAJwFW3YCv34zLnZ5/YN8vbu6kcwvj5XFy9MYTxiihB3iS2zlyzSj3ulQq5G5+9BgNSsgLVyaAur9ga9cql8U1cyWoRZHgDd56/Ue3zyl68uLzFOdcdCxzjgJZrngsYKQHQAWKJ8os2g==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8936002)(316002)(508600001)(36860700001)(110136005)(54906003)(81166007)(6636002)(356005)(70586007)(8676002)(86362001)(4326008)(70206006)(83380400001)(40460700003)(26005)(6666004)(30864003)(7696005)(1076003)(2616005)(186003)(82310400005)(426003)(336012)(2906002)(47076005)(5660300002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 09:02:29.7740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ca9bfc-8a35-41ed-d1c8-08da3263cfff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3543
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
index eddb7dedc047..2d6e323de268 100644
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
@@ -120,6 +115,10 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
 	if (mvdev->vf_id < 0)
 		goto end;
 
+	if (mlx5vf_cmd_get_vhca_id(mvdev->mdev, mvdev->vf_id + 1,
+				   &mvdev->vhca_id))
+		goto end;
+
 	mutex_init(&mvdev->state_mutex);
 	spin_lock_init(&mvdev->reset_lock);
 	mvdev->nb.notifier_call = mlx5fv_vf_event;
@@ -137,23 +136,18 @@ void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev)
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
@@ -171,8 +165,6 @@ int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
 
 err_exec:
 	kfree(out);
-end:
-	mlx5_vf_put_core_dev(mdev);
 	return ret;
 }
 
@@ -217,21 +209,23 @@ static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
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
@@ -245,7 +239,7 @@ int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 	MLX5_SET(save_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_SAVE_VHCA_STATE);
 	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
-	MLX5_SET(save_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(save_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(save_vhca_state_in, in, size, migf->total_length);
 
@@ -253,37 +247,28 @@ int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
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
@@ -292,6 +277,7 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 		goto end;
 	}
 
+	mdev = mvdev->mdev;
 	err = mlx5_core_alloc_pd(mdev, &pdn);
 	if (err)
 		goto end;
@@ -307,7 +293,7 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 	MLX5_SET(load_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_LOAD_VHCA_STATE);
 	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
-	MLX5_SET(load_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(load_vhca_state_in, in, vhca_id, mvdev->vhca_id);
 	MLX5_SET(load_vhca_state_in, in, mkey, mkey);
 	MLX5_SET(load_vhca_state_in, in, size, migf->total_length);
 
@@ -319,7 +305,6 @@ int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
 err_reg:
 	mlx5_core_dealloc_pd(mdev, pdn);
 end:
-	mlx5_vf_put_core_dev(mdev);
 	mutex_unlock(&migf->lock);
 	return err;
 }
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index dd4257b27d22..94928055c005 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -43,16 +43,15 @@ struct mlx5vf_pci_core_device {
 	struct mlx5_core_dev *mdev;
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
index 26065487881f..2db6b816f003 100644
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

