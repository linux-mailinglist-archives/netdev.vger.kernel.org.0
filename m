Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FADF4A37A1
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355657AbiA3QPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:15:38 -0500
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:28384
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1355585AbiA3QP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:15:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfr/1066nLWdBj3qDmTbSYfq8ouHzZD9INKeYNSGTdHUP0XoJTTQ6kcQMeUnwCw6I/LiTae7K0VtO0Q4S8ewHUE6E7H/EFJZkhd2KWkB4nbJOTfmnAcxImEofOKHsX/b6hFEZBJ5dwVQV+AiMQuDw/xDi44cPC/OcW3ly0XTQ6q+33fczlu0j8C7sgvLOLrVKU+trSj0h445k5EtCESjFgAIr71++4jnlHGrup2X9R5XmnKmpPjA98QJNkzWfv9+mh5yQpCEn9cgP76QPT8EQROlaLBkACUjmjDdDJEvCTMAVJq4VsnKrzMjDuJZkyDF9d14nE8Vok3w4Wam4jgPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUGZ7H6m2Hkz6WZMTo1QbfqWiunjBO18GuofxuYbjCU=;
 b=npu5/VmliNmWXuolZraBiwKuz343dDzMfhLklaTSIjbp3/sUkmzVmE+mDaG+VlaFNHJBkGg7k8Vn2R28QUaQvsVV/GTTzHiff3gMCpoT9d+zH2f3QkRuhBw5fnm0TOGe3K9bU4SDJ3RDWa86UlgnFqo5N9v/VkB/SGeDYZFsjXiWgZctwnupyav9gFOlBp4tL4cQnD5isXh20V5KvLcohJg/9y6tlANhn+om8iHEup3FIJluHo4p6WOBEYCIsQhGiLjl6Z4e4kC9GO+cNLNibS8jpPrxGwy6Xdrcyr6Tg1mA40KO1c6r9A1qkcVJj+YFv+SbHn5NO1hwM2+LUQD6fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUGZ7H6m2Hkz6WZMTo1QbfqWiunjBO18GuofxuYbjCU=;
 b=UBUyMjAmKWQ5yww/SrA6B+bFCAfa6Pgjz6/u/GaD9bbPSUUW1NW/DfkJsY+7Be3b8ke3Y7Ce1cinNSCPznl5FKsq7VvcOOUFow5VPa6h05v3XsKBjUaii31FgF4zSPDxUtj4q/8v7QkHhbLaFfF06brsumSnjgNpSvwkBXe1Kovib2oWXpC3DSqLfR8QLvwk8xkPJ3XrjNWL/zVQeGCJOLeoAvQs3ywkbVYmK2eXhkOe4HJx86w5QoyJy1VBI2j7+yZWJISPKt5yZY1FLfZ6XtaiOBElDmaZzBfmNEjlwu4n2vIwq2G1MDnp9McjeUkJT9L2sh/kBCMjmfBj3CrJQA==
Received: from DM6PR07CA0047.namprd07.prod.outlook.com (2603:10b6:5:74::24) by
 DM6PR12MB3292.namprd12.prod.outlook.com (2603:10b6:5:18c::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Sun, 30 Jan 2022 16:15:25 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::50) by DM6PR07CA0047.outlook.office365.com
 (2603:10b6:5:74::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20 via Frontend
 Transport; Sun, 30 Jan 2022 16:15:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:15:25 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:15:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:15:23 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:15:20 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 11/15] vfio/mlx5: Expose migration commands over mlx5 device
Date:   Sun, 30 Jan 2022 18:08:22 +0200
Message-ID: <20220130160826.32449-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220130160826.32449-1-yishaih@nvidia.com>
References: <20220130160826.32449-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 523a3a84-0bb1-46a0-b41a-08d9e40bb961
X-MS-TrafficTypeDiagnostic: DM6PR12MB3292:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB32928C649A09CE74D16CC6CBC3249@DM6PR12MB3292.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZQ340CVr8+M3iMI2YKx2bJ7luPiLYyKTDedvibMxwCv3/tGv4/PWGfvmnisHtg/iyLn7HPM/CeJkjJnDziKgYc6YKDWovA8x+Z3VbQAZidjtKTjFAZZF9Z3nX8eAMZYf06WH97RLIC8zgJ5DPDIe9Te0D5lcXEZiAbWMcIzKga/nX2l34wpF2Z09FPusWipDGVFSNK0ed2sXhtqdJDw5mRiBsAN8PkJtXHVIDakS6LtQGNOhsPDNJs0XwAxnaeXN7ylj0I3+HLX6Dm6wlwPy5/5kNKPyoMQhYQTltqvCTIfwk/ui77t29urMZ9x8jGNMN4SKPURRed7tqM+OkkX6/jK0wRcsDhnQ8tilwOXsgUocrW5XdfFVwfMquNUAJe9vw7Wm0CTbE4jhdWtd3KDI0czLHPMHPk+RIFHPHr52uaMaY2oFO68MC3U+5roqxZyF4AdbYzL5TaW80ysTE0byqUv9965Qj8MOpxGo7Y+g/mJwBZblntNZ/N2CC71D2kepaKEw8WKT2lu3nw2Oc4o9hZRMFSiypkZFNZDqDd1KbhELOUUH0f+0a7q0jqHhbmx+LYgw2C0/Z9pzW6+3ehlpJ1t7B+AOxX3vn4RdyQOC8cgD0Fi7qk9SlRTOHY4RZOuh7mtCNIoTtjPhzBPL7agjPoamwpIlnfWOf5tbtUZRjEoblTl30iACjU87oD3tEg//c3wxr1cwCm09GxBBrRvFw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(7696005)(426003)(82310400004)(336012)(107886003)(5660300002)(2616005)(2906002)(1076003)(186003)(26005)(356005)(508600001)(36860700001)(81166007)(40460700003)(86362001)(83380400001)(47076005)(8936002)(6636002)(8676002)(36756003)(4326008)(316002)(70206006)(70586007)(54906003)(110136005)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:15:25.4347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 523a3a84-0bb1-46a0-b41a-08d9e40bb961
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3292
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose migration commands over the device, it includes: suspend, resume,
get vhca id, query/save/load state.

As part of this adds the APIs and data structure that are needed to manage
the migration data.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 252 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |  35 +++++
 2 files changed, 287 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
new file mode 100644
index 000000000000..fcf2dab0541a
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include "cmd.h"
+
+int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod)
+{
+	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	u32 out[MLX5_ST_SZ_DW(suspend_vhca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(suspend_vhca_in)] = {};
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	MLX5_SET(suspend_vhca_in, in, opcode, MLX5_CMD_OP_SUSPEND_VHCA);
+	MLX5_SET(suspend_vhca_in, in, vhca_id, vhca_id);
+	MLX5_SET(suspend_vhca_in, in, op_mod, op_mod);
+
+	ret = mlx5_cmd_exec_inout(mdev, suspend_vhca, in, out);
+	mlx5_vf_put_core_dev(mdev);
+	return ret;
+}
+
+int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod)
+{
+	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	u32 out[MLX5_ST_SZ_DW(resume_vhca_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(resume_vhca_in)] = {};
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	MLX5_SET(resume_vhca_in, in, opcode, MLX5_CMD_OP_RESUME_VHCA);
+	MLX5_SET(resume_vhca_in, in, vhca_id, vhca_id);
+	MLX5_SET(resume_vhca_in, in, op_mod, op_mod);
+
+	ret = mlx5_cmd_exec_inout(mdev, resume_vhca, in, out);
+	mlx5_vf_put_core_dev(mdev);
+	return ret;
+}
+
+int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
+					  size_t *state_size)
+{
+	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	MLX5_SET(query_vhca_migration_state_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
+	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(query_vhca_migration_state_in, in, op_mod, 0);
+
+	ret = mlx5_cmd_exec_inout(mdev, query_vhca_migration_state, in, out);
+	if (ret)
+		goto end;
+
+	*state_size = MLX5_GET(query_vhca_migration_state_out, out,
+			       required_umem_size);
+
+end:
+	mlx5_vf_put_core_dev(mdev);
+	return ret;
+}
+
+int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id)
+{
+	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	u32 in[MLX5_ST_SZ_DW(query_hca_cap_in)] = {};
+	int out_size;
+	void *out;
+	int ret;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	out_size = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	out = kzalloc(out_size, GFP_KERNEL);
+	if (!out) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, other_function, 1);
+	MLX5_SET(query_hca_cap_in, in, function_id, function_id);
+	MLX5_SET(query_hca_cap_in, in, op_mod,
+		 MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1 |
+		 HCA_CAP_OPMOD_GET_CUR);
+
+	ret = mlx5_cmd_exec_inout(mdev, query_hca_cap, in, out);
+	if (ret)
+		goto err_exec;
+
+	*vhca_id = MLX5_GET(query_hca_cap_out, out,
+			    capability.cmd_hca_cap.vhca_id);
+
+err_exec:
+	kfree(out);
+end:
+	mlx5_vf_put_core_dev(mdev);
+	return ret;
+}
+
+static int _create_state_mkey(struct mlx5_core_dev *mdev, u32 pdn,
+			      struct mlx5_vf_migration_file *migf, u32 *mkey)
+{
+	size_t npages = DIV_ROUND_UP(migf->total_length, PAGE_SIZE);
+	struct sg_dma_page_iter dma_iter;
+	int err = 0, inlen;
+	__be64 *mtt;
+	void *mkc;
+	u32 *in;
+
+	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) +
+		sizeof(*mtt) * round_up(npages, 2);
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
+		 DIV_ROUND_UP(npages, 2));
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
+
+	for_each_sgtable_dma_page (&migf->table.sgt, &dma_iter, 0)
+		*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, rr, 1);
+	MLX5_SET(mkc, mkc, rw, 1);
+	MLX5_SET(mkc, mkc, pd, pdn);
+	MLX5_SET(mkc, mkc, bsf_octword_size, 0);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
+	MLX5_SET(mkc, mkc, translations_octword_size, DIV_ROUND_UP(npages, 2));
+	MLX5_SET64(mkc, mkc, len, migf->total_length);
+	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
+	kvfree(in);
+	return err;
+}
+
+int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vf_migration_file *migf)
+{
+	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	u32 pdn, mkey;
+	int err;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	err = mlx5_core_alloc_pd(mdev, &pdn);
+	if (err)
+		goto end;
+
+	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE,
+			      0);
+	if (err)
+		goto err_dma_map;
+
+	err = _create_state_mkey(mdev, pdn, migf, &mkey);
+	if (err)
+		goto err_create_mkey;
+
+	MLX5_SET(save_vhca_state_in, in, opcode,
+		 MLX5_CMD_OP_SAVE_VHCA_STATE);
+	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
+	MLX5_SET(save_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
+	MLX5_SET(save_vhca_state_in, in, size, migf->total_length);
+
+	err = mlx5_cmd_exec_inout(mdev, save_vhca_state, in, out);
+	if (err)
+		goto err_exec;
+
+	migf->total_length =
+		MLX5_GET(save_vhca_state_out, out, actual_image_size);
+
+	mlx5_core_destroy_mkey(mdev, mkey);
+	mlx5_core_dealloc_pd(mdev, pdn);
+	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
+	mlx5_vf_put_core_dev(mdev);
+
+	return 0;
+
+err_exec:
+	mlx5_core_destroy_mkey(mdev, mkey);
+err_create_mkey:
+	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_FROM_DEVICE, 0);
+err_dma_map:
+	mlx5_core_dealloc_pd(mdev, pdn);
+end:
+	mlx5_vf_put_core_dev(mdev);
+	return err;
+}
+
+int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vf_migration_file *migf)
+{
+	struct mlx5_core_dev *mdev = mlx5_vf_get_core_dev(pdev);
+	u32 out[MLX5_ST_SZ_DW(save_vhca_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	u32 pdn, mkey;
+	int err;
+
+	if (!mdev)
+		return -ENOTCONN;
+
+	err = mlx5_core_alloc_pd(mdev, &pdn);
+	if (err)
+		goto end;
+
+	err = dma_map_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
+	if (err)
+		goto err_reg;
+
+	err = _create_state_mkey(mdev, pdn, migf, &mkey);
+	if (err)
+		goto err_mkey;
+
+	MLX5_SET(load_vhca_state_in, in, opcode,
+		 MLX5_CMD_OP_LOAD_VHCA_STATE);
+	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
+	MLX5_SET(load_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(load_vhca_state_in, in, mkey, mkey);
+	MLX5_SET(load_vhca_state_in, in, size, migf->total_length);
+
+	err = mlx5_cmd_exec_inout(mdev, load_vhca_state, in, out);
+
+	mlx5_core_destroy_mkey(mdev, mkey);
+err_mkey:
+	dma_unmap_sgtable(mdev->device, &migf->table.sgt, DMA_TO_DEVICE, 0);
+err_reg:
+	mlx5_core_dealloc_pd(mdev, pdn);
+end:
+	mlx5_vf_put_core_dev(mdev);
+	return err;
+}
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
new file mode 100644
index 000000000000..69a1481ed953
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+ */
+
+#ifndef MLX5_VFIO_CMD_H
+#define MLX5_VFIO_CMD_H
+
+#include <linux/kernel.h>
+#include <linux/mlx5/driver.h>
+
+struct mlx5_vf_migration_file {
+	struct file *filp;
+	struct mutex lock;
+
+	struct sg_append_table table;
+	size_t total_length;
+	size_t allocated_length;
+
+	/* Optimize mlx5vf_get_migration_page() for sequential access */
+	struct scatterlist *last_offset_sg;
+	unsigned int sg_last_entry;
+	unsigned long last_offset;
+};
+
+int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
+int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
+int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
+					  size_t *state_size);
+int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
+int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vf_migration_file *migf);
+int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vf_migration_file *migf);
+#endif /* MLX5_VFIO_CMD_H */
-- 
2.18.1

