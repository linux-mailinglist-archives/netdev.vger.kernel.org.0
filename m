Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B496942BC0C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbhJMJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:51:45 -0400
Received: from mail-sn1anam02on2062.outbound.protection.outlook.com ([40.107.96.62]:18985
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239253AbhJMJvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:51:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHf4ho0BZ2SYU89aoCZATXAXyCUk0BxpyPZZr1PE+LNllUns4qdoK8CzRnbQNXvWG99KodLEstzgubcqlJ8h3CfxdCMLwrNWor6dni06/o59Rh7aIHDHt4E8bs7Q07K6hZb3Iz/EryZ3MXtKo2cA+zSdf55MHxaS/nBeQcxfWzYz/B8ZxAwaXDnRcaT8/6V5tYGscxwrsoP4Ho43lHFA2T58IErd24hnPa4ucDrLrC+39j0rLZX+xtuj9juCycQeVVVb/co+EfKEZkWrT8BCH/EJaRV3UBgjNt2K1F15OT6gxN30a91a3+962zeC0gRdO63d5VFEIgQHD1zIiXx7rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDzDerJ8BHTpflGMC1W6xDcWZWOCwERj9bPjORhyA/I=;
 b=oHcEUDbLIEa0G12G+FHii7O7gjByLWafu71Yxh2f2clEFt69cm9lD5q3jRx7MyH0bKkhCgT1kNKGZL8Nekbu3DmKQ4rxLXzliSLmsvZHA6bceKyc3ncXq+52DmlkUtmU7HtG2iL+K710RN4nKVUyH5/nw5J68EhSEc0unGV1E3i3Q3qayz+401sT82VyzdToXK8sarwcIOV6kAtIDyqcmJoJZnvzXaiBsPX0AKlD/aTGB+BNP7uR0wKoQcVB/tRuwU5WXimNd8/AmgFSLF9BP+x4IY5H3ettpfRlYXP8StlfLkNj6clWC4Ud3SUNB76hCW481mMZ3bEx/tBxj7Tkng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDzDerJ8BHTpflGMC1W6xDcWZWOCwERj9bPjORhyA/I=;
 b=MBv45fdsVzyNekJbTF8edZKyX44YtLgj1IGgH36uWyi67DWDARW9cqiGRlS0+4E6ZREF2n1HtLEC3SgWDi946fL3il9FCg37m7VuO771KSSvP3cdQ6oYPAD3pQV9DDMaiXsl7fUhQxO1yl80WGMFuJoNAOcqrqmILR6oAPHnt+GdvIATS9FzK3O0akW2VnJ/A52PCtqpjXIi+/uLKWzqr2lNSv5X55DWUx3x/6WSF4NDsviv3S8KC7IjWWWtytiWOjMRbpRW772CC/DZ+ca4sTx/O7PX58laMZg6nNUCjsWRaqXxyg0Kab4Rs8LlYeyWconyutATpx9S43BHfryKqQ==
Received: from BN0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:408:e6::19)
 by MW3PR12MB4377.namprd12.prod.outlook.com (2603:10b6:303:55::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 09:48:58 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::70) by BN0PR03CA0014.outlook.office365.com
 (2603:10b6:408:e6::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:57 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 02:48:56 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:53 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 10/13] vfio/mlx5: Expose migration commands over mlx5 device
Date:   Wed, 13 Oct 2021 12:47:04 +0300
Message-ID: <20211013094707.163054-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013094707.163054-1-yishaih@nvidia.com>
References: <20211013094707.163054-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b3a7f4d-640d-43a8-9920-08d98e2ead31
X-MS-TrafficTypeDiagnostic: MW3PR12MB4377:
X-Microsoft-Antispam-PRVS: <MW3PR12MB4377C937436AE2FC6AAFC626C3B79@MW3PR12MB4377.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qb6cFwTNGnmwpLT8YbNrZbJRHoLvUPYMGl6n2URgvsMimimx4rLs8f1FXdGruSFzJklPF4IU+UorvDNm6bivUzjNm2GLas6OCucQH4aUU9NpjXVyYMQWq9Ghs807dfXvOJymqvgj0Ar7HvFKsBtM5022VSylg+lGPiW8Un33DhzOnRH/DLc32ES7WYOiLhuy6EFeXnB9YSIvEaeWv9JL+B0xcbYN39uPIUAR+T+P2CPMr6mPYmnuU8PZtT33jo6ZZwDvMqNRNVYpQ0Ggw2VXmv4JKBdlZegy+Zyp4D7Sycw4NJ9OPs4VzDA1sigZBu4Gk7q7GsNnqYjtPzfshF/Uvm8AxzyafBX9PPQbH8YKPZCSXa/Z4qiNN7ftWg6drhCpf3XQtINbR7wZDixPQTv2p+aug33QuyIQ1t/GVIqweRuqEvgadkFmHpo3pvFgYj8u8LWPkhBN2e5tFX2ns49pR8TQi4vMsKIbQ2QlAbk9dQAoR5W7KQqtR+mB2Wzwc6bgiAnzResVZPA5oCh6ss27RJpv3PYsjU564+mYhDs6X50SeAnufdWliyMlnoSRsPbJ8tRh6BuItJAfUvzvFLnCZqmap9SamPhvPtksm0mOXXdUgSYMmTSbiDlEY5+Wrg65AeO0SEj3p/WT06PJjS90xu6JIeNb7OnJHz4RWXArY7P3ZfnV5Wt/NdXcSNGYS9WgCsxilYXokaHXk3a47STt8g==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36860700001)(47076005)(7636003)(110136005)(4326008)(7696005)(8676002)(356005)(5660300002)(6636002)(508600001)(316002)(54906003)(83380400001)(82310400003)(70586007)(26005)(86362001)(426003)(8936002)(6666004)(2906002)(186003)(1076003)(2616005)(36756003)(30864003)(107886003)(336012)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:57.3315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3a7f4d-640d-43a8-9920-08d98e2ead31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4377
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose migration commands over the device, it includes: suspend, resume,
get vhca id, query/save/load state.

As part of this adds the APIs and data structure that are needed to
manage the migration data.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 353 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |  43 +++++
 2 files changed, 396 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
new file mode 100644
index 000000000000..5b24a7625b8a
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -0,0 +1,353 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved
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
+					  u32 *state_size)
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
+			      struct mlx5_vhca_state_data *state, u32 *mkey)
+{
+	struct sg_dma_page_iter dma_iter;
+	int err = 0, inlen;
+	__be64 *mtt;
+	void *mkc;
+	u32 *in;
+
+	inlen = MLX5_ST_SZ_BYTES(create_mkey_in) +
+			sizeof(*mtt) * round_up(state->num_pages, 2);
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return -ENOMEM;
+
+	MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
+		 DIV_ROUND_UP(state->num_pages, 2));
+	mtt = (__be64 *)MLX5_ADDR_OF(create_mkey_in, in, klm_pas_mtt);
+
+	for_each_sgtable_dma_page(&state->mig_data.table.sgt, &dma_iter, 0)
+		*mtt++ = cpu_to_be64(sg_page_iter_dma_address(&dma_iter));
+
+	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
+	MLX5_SET(mkc, mkc, lr, 1);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, pd, pdn);
+	MLX5_SET(mkc, mkc, bsf_octword_size, 0);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
+	MLX5_SET(mkc, mkc, translations_octword_size,
+		 DIV_ROUND_UP(state->num_pages, 2));
+	MLX5_SET64(mkc, mkc, len, state->num_pages * PAGE_SIZE);
+	err = mlx5_core_create_mkey(mdev, mkey, in, inlen);
+
+	kvfree(in);
+
+	return err;
+}
+
+struct page *mlx5vf_get_migration_page(struct migration_data *data,
+				       unsigned long offset)
+{
+	unsigned long cur_offset = 0;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	if (offset < data->last_offset || !data->last_offset_sg) {
+		data->last_offset = 0;
+		data->last_offset_sg = data->table.sgt.sgl;
+		data->sg_last_entry = 0;
+	}
+
+	cur_offset = data->last_offset;
+
+	for_each_sg(data->last_offset_sg, sg,
+			data->table.sgt.orig_nents - data->sg_last_entry, i) {
+		if (offset < sg->length + cur_offset) {
+			data->last_offset_sg = sg;
+			data->sg_last_entry += i;
+			data->last_offset = cur_offset;
+			return nth_page(sg_page(sg),
+					(offset - cur_offset) / PAGE_SIZE);
+		}
+		cur_offset += sg->length;
+	}
+	return NULL;
+}
+
+void mlx5vf_reset_vhca_state(struct mlx5_vhca_state_data *state)
+{
+	struct migration_data *data = &state->mig_data;
+	struct sg_page_iter sg_iter;
+
+	if (!data->table.prv)
+		goto end;
+
+	/* Undo alloc_pages_bulk_array() */
+	for_each_sgtable_page(&data->table.sgt, &sg_iter, 0)
+		__free_page(sg_page_iter_page(&sg_iter));
+	sg_free_append_table(&data->table);
+end:
+	memset(state, 0, sizeof(*state));
+}
+
+int mlx5vf_add_migration_pages(struct mlx5_vhca_state_data *state,
+			       unsigned int npages)
+{
+	unsigned int to_alloc = npages;
+	struct page **page_list;
+	unsigned long filled;
+	unsigned int to_fill;
+	int ret = 0;
+
+	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
+	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
+	do {
+		filled = alloc_pages_bulk_array(GFP_KERNEL, to_fill,
+						page_list);
+		if (!filled) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		to_alloc -= filled;
+		ret = sg_alloc_append_table_from_pages(
+			&state->mig_data.table, page_list, filled, 0,
+			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
+			GFP_KERNEL);
+
+		if (ret)
+			goto err;
+		/* clean input for another bulk allocation */
+		memset(page_list, 0, filled * sizeof(*page_list));
+		to_fill = min_t(unsigned int, to_alloc,
+				PAGE_SIZE / sizeof(*page_list));
+	} while (to_alloc > 0);
+
+	kvfree(page_list);
+	state->num_pages += npages;
+
+	return 0;
+
+err:
+	kvfree(page_list);
+	return ret;
+}
+
+int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       u64 state_size,
+			       struct mlx5_vhca_state_data *state)
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
+	err = mlx5vf_add_migration_pages(state,
+				DIV_ROUND_UP_ULL(state_size, PAGE_SIZE));
+	if (err < 0)
+		goto err_alloc_pages;
+
+	err = dma_map_sgtable(mdev->device, &state->mig_data.table.sgt,
+			      DMA_FROM_DEVICE, 0);
+	if (err)
+		goto err_reg_dma;
+
+	err = _create_state_mkey(mdev, pdn, state, &mkey);
+	if (err)
+		goto err_create_mkey;
+
+	MLX5_SET(save_vhca_state_in, in, opcode,
+		 MLX5_CMD_OP_SAVE_VHCA_STATE);
+	MLX5_SET(save_vhca_state_in, in, op_mod, 0);
+	MLX5_SET(save_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(save_vhca_state_in, in, mkey, mkey);
+	MLX5_SET(save_vhca_state_in, in, size, state_size);
+
+	err = mlx5_cmd_exec_inout(mdev, save_vhca_state, in, out);
+	if (err)
+		goto err_exec;
+
+	state->state_size = state_size;
+
+	mlx5_core_destroy_mkey(mdev, mkey);
+	mlx5_core_dealloc_pd(mdev, pdn);
+	dma_unmap_sgtable(mdev->device, &state->mig_data.table.sgt,
+			  DMA_FROM_DEVICE, 0);
+	mlx5_vf_put_core_dev(mdev);
+
+	return 0;
+
+err_exec:
+	mlx5_core_destroy_mkey(mdev, mkey);
+err_create_mkey:
+	dma_unmap_sgtable(mdev->device, &state->mig_data.table.sgt,
+			  DMA_FROM_DEVICE, 0);
+err_reg_dma:
+	mlx5vf_reset_vhca_state(state);
+err_alloc_pages:
+	mlx5_core_dealloc_pd(mdev, pdn);
+end:
+	mlx5_vf_put_core_dev(mdev);
+	return err;
+}
+
+int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vhca_state_data *state)
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
+	err = dma_map_sgtable(mdev->device, &state->mig_data.table.sgt,
+			      DMA_TO_DEVICE, 0);
+	if (err)
+		goto err_reg;
+
+	err = _create_state_mkey(mdev, pdn, state, &mkey);
+	if (err)
+		goto err_mkey;
+
+	MLX5_SET(load_vhca_state_in, in, opcode,
+		 MLX5_CMD_OP_LOAD_VHCA_STATE);
+	MLX5_SET(load_vhca_state_in, in, op_mod, 0);
+	MLX5_SET(load_vhca_state_in, in, vhca_id, vhca_id);
+	MLX5_SET(load_vhca_state_in, in, mkey, mkey);
+	MLX5_SET(load_vhca_state_in, in, size, state->state_size);
+
+	err = mlx5_cmd_exec_inout(mdev, load_vhca_state, in, out);
+
+	mlx5_core_destroy_mkey(mdev, mkey);
+err_mkey:
+	dma_unmap_sgtable(mdev->device, &state->mig_data.table.sgt,
+			  DMA_TO_DEVICE, 0);
+err_reg:
+	mlx5_core_dealloc_pd(mdev, pdn);
+end:
+	mlx5_vf_put_core_dev(mdev);
+	return err;
+}
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
new file mode 100644
index 000000000000..66221df24b19
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * Copyright (c) 2021, NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+ */
+
+#ifndef MLX5_VFIO_CMD_H
+#define MLX5_VFIO_CMD_H
+
+#include <linux/kernel.h>
+#include <linux/mlx5/driver.h>
+
+struct migration_data {
+	struct sg_append_table table;
+
+	struct scatterlist *last_offset_sg;
+	unsigned int sg_last_entry;
+	unsigned long last_offset;
+};
+
+/* state data of vhca to be used as part of migration flow */
+struct mlx5_vhca_state_data {
+	u64 state_size;
+	u64 num_pages;
+	u32 win_start_offset;
+	struct migration_data mig_data;
+};
+
+int mlx5vf_cmd_suspend_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
+int mlx5vf_cmd_resume_vhca(struct pci_dev *pdev, u16 vhca_id, u16 op_mod);
+int mlx5vf_cmd_query_vhca_migration_state(struct pci_dev *pdev, u16 vhca_id,
+					  uint32_t *state_size);
+int mlx5vf_cmd_get_vhca_id(struct pci_dev *pdev, u16 function_id, u16 *vhca_id);
+int mlx5vf_cmd_save_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       u64 state_size,
+			       struct mlx5_vhca_state_data *state);
+void mlx5vf_reset_vhca_state(struct mlx5_vhca_state_data *state);
+int mlx5vf_cmd_load_vhca_state(struct pci_dev *pdev, u16 vhca_id,
+			       struct mlx5_vhca_state_data *state);
+int mlx5vf_add_migration_pages(struct mlx5_vhca_state_data *state,
+			       unsigned int npages);
+struct page *mlx5vf_get_migration_page(struct migration_data *data,
+				       unsigned long offset);
+#endif /* MLX5_VFIO_CMD_H */
-- 
2.18.1

