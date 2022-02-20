Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8934BCDCB
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243639AbiBTJ74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:59:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiBTJ7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:59:52 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8325546AC;
        Sun, 20 Feb 2022 01:59:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkoOEWiR5rNjvq5MI3edWxBnBgaBS2azGxzFgSJZv0temiUjtO2aTUaaAa+mXPO1qO6fuUUCQQrETvzOpKiA50eNor/gdYVz618d/q65+EgEpdKiKsKh0P27wC+FKWaP02kJ86tIjorBrR1PVb27nPFgQ0MFj/k6Clw2WQf/hSaFduwSEUtSV2mplHKFgnixtkxJd3LJLpRGQIXAsKimMfFtlhW8HGdz1ZyTR5SIEBs4Vcozpw++E/r54chRsAO5MwK3GP5aP47XUhffFzuqI4aEGSRU6itxWCkgaSp9LcsbCNcYsPe9wzCv0sYz7i4km8t5QGq23PRE8iNSs666TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7C9tX4kP8W89Mrf4mmijlxMrlM7BtvYPIr1UgzIxSU=;
 b=B0oBwqpBJzTbL/HXfnP/XUz0vYYRFxrsenMCUDSUTUO5wN1i7rtOd2XsbihshDt39pZzXh1/tOiyBqKz7R1LCc1j9rubPavXsJiu0+DXS1hV5Qjo1y+L3e90ULTJg3GCKJr5UP+wPL+3JK9hVln8bzgnADpYQnNDt1+8R8nBB1REVxoLNmFhBfjMYwrAzzcyQfednEtX852/x7e1ho/J3jGc+P6ge0FAlwjbnkxaa+8C8+NPgIiwD2Lq9/oB6x8RzGrDQfXU3fF5gC0tq8x0RTOMQDDaIlTjqqTm3z0tX9xznI5Lbi2JADjmKpoPXKytboZj1vkyobABcq/M3wUNKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7C9tX4kP8W89Mrf4mmijlxMrlM7BtvYPIr1UgzIxSU=;
 b=uhpsNLFuHGxUywKmA2Ry/Le417J33Qoaba+4QjIGOC4jST9xqiBgGK9qnJtXRNECxsuBVuGkjc/1eNs4TRGsJVf2Rpd+UbwGN3DpS5ahKtstFCe3w/mV03FLpt6uofsy6xIfvinaL4zq4UpIOcw3Bo8TyYfhaqfjnSSBN5+gJxfxpjEIaoauDyuo0coROxH6S2ldD2Z7r3ZYeMKxL2X3XWnTfS7/gh7oJXj4MEz0Wn1kNQwGh49nfzRMmqBHPepkSyyqNKZr0Ucs88Ds2qyjR+gkU/YLH/h/kZsxxmqWe7u7si2bwdzucE1VVydbNd1cK3wcRjQrrw+hsuPNn2+vGw==
Received: from DM5PR12CA0053.namprd12.prod.outlook.com (2603:10b6:3:103::15)
 by DM6PR12MB4092.namprd12.prod.outlook.com (2603:10b6:5:214::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sun, 20 Feb
 2022 09:59:17 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::53) by DM5PR12CA0053.outlook.office365.com
 (2603:10b6:3:103::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Sun, 20 Feb 2022 09:59:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:59:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:59:16 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:59:16 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:59:11 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 12/15] vfio/mlx5: Expose migration commands over mlx5 device
Date:   Sun, 20 Feb 2022 11:57:13 +0200
Message-ID: <20220220095716.153757-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c63df99-deb4-4600-eaef-08d9f457a898
X-MS-TrafficTypeDiagnostic: DM6PR12MB4092:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB40925E77B448773CED36AF8BC3399@DM6PR12MB4092.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nhnuyjwp9vmvbvlxZ5dkg2xGDy8SaWBrou/sy+uHcxRzwPWq5c2PDkVoAmb8vYYz1u0A/BWH81JJDUXPFVgo4Dc/e76fFo21kkQb7fG3TRFLFjUum+GoLUycjS8UnHctJAdJTvLsz7fwBDXKjGXCbssbwz9yFesMZgFs/U+zaj9HAztO6qBP5VLxtCDN9kNTPJZD7/m+98heUKvj9j9Rqsgjc/DCiUIihHvdR2WTpbbK9G1FEW5mzQ+4ryFOz+D1fw3b9WcDhsC6CTEKwX7W8kTHMxC8kiq9cBCRqHQhwqDTWOsGUqiTHnHre0wzpg6d5gjaoAxYcyUMDto5nyl+tkX5D3DRGfe11b4K2Z+7RkpeScdx8gMYFwSnShOTExBVDelOXI8LcgYfXYdLSU7wbu17E1p1ilD6gHlBCQkMtkG2oqnz5sBsydUn4IaonFy6LckrEGSALCFS4+Y1rogd5IGKUF1LoFbpfo8fP4actwRh6mYaMGV6sggmarM7rlFnT2TM+LsphTONrVRxL23GRl/JX5YlXdqeM4Q7r0D+h5OLAwTiK3MyBgyhJnNNq3Za/ceiU2qBOHKJ9iQk3Z9kETUQAKlcdOTFh56lYx9nF0ijkMiGsXtLMinEAtJ2ZFftzmw+h0QdMTQFszm+GUTEJaLVnPPPav58fbMKscv5Nxq1dIUwzRj9XW9CM5/GiZ4LY0E+J6rRBVYd89sFoOHs4KivP/NUpNyruHRGnICGioxhHrQhKI63g+lYI95Uh1Vx
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(316002)(8936002)(7416002)(86362001)(5660300002)(2906002)(40460700003)(7696005)(508600001)(356005)(81166007)(26005)(1076003)(82310400004)(336012)(8676002)(2616005)(426003)(70586007)(36860700001)(54906003)(6636002)(110136005)(36756003)(4326008)(70206006)(186003)(47076005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:59:17.5843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c63df99-deb4-4600-eaef-08d9f457a898
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4092
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 drivers/vfio/pci/mlx5/cmd.c | 259 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |  35 +++++
 2 files changed, 294 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
new file mode 100644
index 000000000000..5c9f9218cc1d
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -0,0 +1,259 @@
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
+	for_each_sgtable_dma_page(&migf->table.sgt, &dma_iter, 0)
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
+	mutex_lock(&migf->lock);
+	if (!migf->total_length) {
+		err = -EINVAL;
+		goto end;
+	}
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
+	mutex_unlock(&migf->lock);
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

