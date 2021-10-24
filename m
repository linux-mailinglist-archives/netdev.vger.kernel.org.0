Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285E3438797
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhJXIem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:42 -0400
Received: from mail-co1nam11on2077.outbound.protection.outlook.com ([40.107.220.77]:34144
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231844AbhJXIed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:34:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJxgEQmN91tJJTv+88SJ2K/k+BT5fCqf+DLs1cPiCV2wwTV6yRo1TqKuLhvqtWcRY9dHSKDV5dlQJ7VR1mPoFiFOpOBM09yfNUvjIaBRMp1nTylyWrLtfG6FaQ/b+u0uYN76/GC3ukIenVqL9Ws+SORjg5ged7yx9C8FfBI2HKIxnxtxJbN4qBBjHMflLu/Eeeb24LeFDf0WBk4SGd39/4Jp9aV98KVXMC2FyF95rZCEGkGQ0rx/jHdtd6Y1lY5ZXaGn8CptirigcNAeoPenlvvdoYiyrAw46M4s8/qckNdwpxSRGuDzXzvnPsKLSjinNTsULQtXKYx4odXeLuTWYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZtEgqlk1th+fPXALjztdnvZiUAZroeuNvQQNlDHqroA=;
 b=jZIottsKNSbDy5oNgGdnRtwmT4kcYpZmICdm01SnMo5ZA5mbOq5aJXdJoq8j7kIs2ALb2CJ0WEcAWD+P1uSv/P8D54pC2XtG03YzmPazacHA7Z+YVJydSPM3VGOzfanmAsiI3KYOnoWIKjV3OWII0zp8Hr4xIyxAPc4foquo76M5dj8Ju22SpkxdVFIHDKD892p8ah9v1aG8NL+p0JBHQTdnaZQfYGAjUo1GvZhHOqyJ0SxVt+7d+2xw+wIp9xG+MmxFN2xyP/WujJOLePQwiLjy+Uum+JUCNV1Cxe2puYQtPpc04kdr0v2qNc70nt/8wqjvg6nT9C+YtNvaYhkCtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZtEgqlk1th+fPXALjztdnvZiUAZroeuNvQQNlDHqroA=;
 b=aeFMqEoP5VstFbXJ2buRZMO00Jqis+F2r/5PhzjaoidRqk/Clu3iXIl8moUOdaTXSC6DDPh9Tz07dhMT23cpwo/KU6bRu4oNKcwALC1p1YiWnOf/Vb+HjATaFVB1AfrLZrDjseCanuywzkMny6NlepaWgyZZ/MICbw+llnMIdm+1SYD3CgwfwlNywEtGxv7OMpp/cQvN/H+XBxdkcIUuXEotgzHB0Luy1mBsSKLBwcUsKEIGDwJ8wKl5hRuaPPTaE+ZVWjOC1JBdSVyOZCPTQMqNZv3IMtNpkX2zKj35GOX19gLaxZD23fcZQBAUKR7fXDzjVwozq86/xgv7FOfLUQ==
Received: from BN6PR19CA0106.namprd19.prod.outlook.com (2603:10b6:404:a0::20)
 by DM6PR12MB3322.namprd12.prod.outlook.com (2603:10b6:5:119::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Sun, 24 Oct
 2021 08:32:10 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:a0:cafe::84) by BN6PR19CA0106.outlook.office365.com
 (2603:10b6:404:a0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Sun, 24 Oct 2021 08:32:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:32:10 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:32:07 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:32:03 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 10/13] vfio/mlx5: Expose migration commands over mlx5 device
Date:   Sun, 24 Oct 2021 11:30:16 +0300
Message-ID: <20211024083019.232813-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211024083019.232813-1-yishaih@nvidia.com>
References: <20211024083019.232813-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9c4675c-c294-4c7b-6f13-08d996c8c5b9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3322:
X-Microsoft-Antispam-PRVS: <DM6PR12MB33222D453A5DE6AE82C249CDC3829@DM6PR12MB3322.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7z1zjAF1RjclAT8uQpdeObKU+2SyBJ0K7Sbj7bTiS7kuhaXjizOs42kssML9TVSePi/ODSZDjgb+nufY+uwAFadFctKN+aNaDr4qi4loZYTV0GFu+Hrj51xbtzPqADF+0VoeNXcXRgAqfDBM73RAJ6gzElbG9LSuejIE8LflWjpHhA2/lfc6wk6iIj9VQDSwc6SCAoQ+a4dYoyOTANrLsSUU4Jy5m69zILALiSEfdPsCJD/jfvqNPM/X/oJ85MSKJqhDgu40E+H0Td0xEAuPZCTSc7ujEIF5Mp7SOoU7UbcbO1oDIKsmG0Eh8PIDPY9vZTuVnK6FDykRUeZVo02/kqnBcEfcCfdKJAbLCLCHAphahwdNCe05LDFn27CR5FUgKEEFNa0HmQ5AJrS/GJIF1utczSOEGY1hDFFuItxlGAnobN0R5J4VLwvpLyLJAY3zsc0kBgmu1kQdO9n9ND8cVOQl14X25jKJfsRFc0GwMRSNBM89IAH24PMNnb3/v8cC3ybP05P066dI4aUxl2Hhtv8mfjzWXovh6XTWrh2Dvs2i2NIvobucxjTp6I00SPiYKrx0sEEJtHYoryZngcnvuu3OBVmTLtkWnTe6+BR6eaQNV4xNVY2kU9s7wm8AgO33yFiV0YtEhsrOkBQGM3A9cPoz7SbH288LynudmZJt/5I51ySC+5U/efwg+QWDpFnYyJP/e8t/0+N/z1cddDpSvw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(86362001)(4326008)(8676002)(26005)(30864003)(36756003)(2906002)(107886003)(426003)(7636003)(110136005)(8936002)(54906003)(186003)(6636002)(36906005)(82310400003)(336012)(316002)(1076003)(508600001)(5660300002)(47076005)(7696005)(36860700001)(83380400001)(2616005)(6666004)(70586007)(70206006)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:32:10.2036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c4675c-c294-4c7b-6f13-08d996c8c5b9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3322
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
 drivers/vfio/pci/mlx5/cmd.c | 354 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/pci/mlx5/cmd.h |  43 +++++
 2 files changed, 397 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
new file mode 100644
index 000000000000..98ec320c8c57
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -0,0 +1,354 @@
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
+	state->state_size = MLX5_GET(save_vhca_state_out, out,
+				     actual_image_size);
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

