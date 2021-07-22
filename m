Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C93D2275
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhGVKZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:06 -0400
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:65409
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231751AbhGVKYy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GW7iU2lJakEqMd4qwY58nCV1fsdQULH9K8NkmnHDRE/UnIqbFhoAtyq4gbCv3OVSJIKTlfKUyCWxJ9P7Htsps7UcSvkYwttV3poY7oPgS5Fjj6//n3KEqnDKY6/jaRcVWLbnFrFfFm+y2q8uOiTfc+N1ICB9e7s8jvQkVyxr+QXt4VNEK7F7NL9Yx07iK139QR1/PdWTuUD9dMDuugzO3yS0nPdf7w/7cZ87eBN33xAHxhLjIEAwpX2pNbRyOej22NVA+G4DneRUYyr6lJBM6fPoai9glzHHWitQ3qW8LUQ2u1e17x4afueo8JCqkrq/TsFpqb6gnuazMStITNGqlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WL2JDoQ89OGPFn6abuFUKjgj2hi8qRpEuHy0HP4KAzw=;
 b=cz9TCUjOO82U4P9IZZ0pU2iVOw5AYIpGoDi0kN5BH0p3IStyaKbx/NO/1kgbGOoLkHvBB0lY8LI6TtWqntym6Xi9BVLQSMqFVsahz/h9ZFaIA0ESTjfhNggtkMvHTkbW44lOtsgiJVhwwzjMrtQVOsETwWTyBUl5b8MJQJMok3gbYfsj4Ebou9LmVY0fHmlHLqxPrCFs8AED5BdZGG57Axr2zBbDFa8Z1RGWp669ClxCeCHWMsbXBZe7IlsouGbXIrn1eXOtx0HzoUsFcr2tefgnqTIO/HD3fKs1MB8SqOvw4zsnmTyuSavSNTiWQfKnJAKBd3ZiTMAiiPrLbSfa2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WL2JDoQ89OGPFn6abuFUKjgj2hi8qRpEuHy0HP4KAzw=;
 b=cajbvZ1MhXrwwx3Rn3IMFUTV8fPEUfbcmkvhReGmlRA1qi9O0W2TqjV+LdWoqEmHGBDQNkNutyGWvbaus+Twgr+G7jEk4mxgYyhWDShyj53ExaCNSIHY4WukAvPtqwcEsIqRsG/RT4ctQhb9UK6WIpDKh1b0vPjp/rxGjJhweRrjbh1bzzKCnjx+67BC5Ddgn2DaLw5VBLPWIbp4TpktMxtgmcIIGuoyygP9dcTrg4VD0mAX75cKqUyP1uwThgcJITFpFqbsfUnUWUtUNV0oK6VpygE4pYVWQNdRJrkOrXPzNwAzxs67+fV1zOrNYjwVuHkagJTK6c0ANFZBmhnIeQ==
Received: from DM3PR14CA0144.namprd14.prod.outlook.com (2603:10b6:0:53::28) by
 SN6PR12MB2687.namprd12.prod.outlook.com (2603:10b6:805:73::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.26; Thu, 22 Jul 2021 11:05:22 +0000
Received: from DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:53:cafe::c7) by DM3PR14CA0144.outlook.office365.com
 (2603:10b6:0:53::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT035.mail.protection.outlook.com (10.13.172.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:22 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 04:05:21 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:17 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 14/36] net/mlx5e: NVMEoTCP use KLM UMRs
Date:   Thu, 22 Jul 2021 14:03:03 +0300
Message-ID: <20210722110325.371-15-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feb18609-960d-4230-8464-08d94d0099c3
X-MS-TrafficTypeDiagnostic: SN6PR12MB2687:
X-Microsoft-Antispam-PRVS: <SN6PR12MB268710C024C12102F5DF4D36BDE49@SN6PR12MB2687.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zGDFobRx6VM8KD+iBQfbGcPgmpukjRk9tOoX2ISxJLDwmE8zEvyWDQ93flsT+3mmcnS7bCV3yVje4Ei+aN48l9tmhnPjRi6CjobcH1VnP5qmT2KCdP2UoTeEKi20qhS3gZFbA2qFt9QzGHIr867lFqvOlfgrxcG8tnW0ho6QuI8d1064mkrPq1SaFsc9CJnmNojKVsh8y/EibDSpfAYDudS1tbQvAjKaB1GpmXM9Uy1vE7ReWbXMceAQu0fKRLLH7noEbkVAUZQ/6OfQcO5tFoXzpYLA3AtURUdOp5qAXmBHlAXej9TrSTFWAenG8XsPiVuVT8J96B3LVXkKw4CHUjuXdm+oF/oBF2CHatojoangM2EJ4/zOYAqhjCLJ3Fle1AHjEniR3wjBYBQjanXNOn9/490usbCA4IO13eNTbD69DXVtw7UJKZ6d3XfiG09PwlZtlTRxiwoueyiZUzMDKQ6dOl6hynJ4T6iNv0M6fkmZZWGTViZvBZn5a+moYVJlpg+JJtavJ58evDGNbvD77rif7mmHQuJ5DdvNB8k9WkQt+iqF+8Mv0jEMuFM/d/o5t+sQ4iPFxBsjvSNZR32vK5Dmly0iSpZ0hp28KPGXXE6uuRHXBcDUGstdR9hHEoLmBZICU1ahlmxl6+imgrBts+crIGa3SvCPIVmkmFolma+1NPkXOnUCIvJaQV3oHPX/CqXwabEsqk/iaaY5B3SY5CvPywoGG1+6hCie9rKuneY=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(46966006)(36840700001)(6666004)(426003)(86362001)(4326008)(70586007)(36860700001)(26005)(478600001)(5660300002)(921005)(2906002)(47076005)(82310400003)(70206006)(107886003)(1076003)(356005)(7636003)(7416002)(186003)(83380400001)(8676002)(36756003)(7696005)(82740400003)(316002)(8936002)(336012)(54906003)(110136005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:22.3592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: feb18609-960d-4230-8464-08d94d0099c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload uses buffer registration for ddp operation,
every request comprises from SG list that might have elements with size > 4K,
thus the appropriate way to perform buffer registration is with KLM UMRs.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   3 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 116 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  12 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  12 +-
 5 files changed, 145 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5bc38002d136..d88ecd04d5da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -238,7 +238,10 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	union {
+		struct mlx5_mtt        inline_mtts[0];
+		struct mlx5_klm	       inline_klms[0];
+	};
 };
 
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 055c3bc23733..529745aac7e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -41,6 +41,9 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
 	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	MLX5E_ICOSQ_WQE_UMR_NVME_TCP,
+#endif
 };
 
 /* General */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 04e88042b243..7fc3b13b1b35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/idr.h>
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
 #include "en/txrx.h"
 
@@ -19,6 +20,121 @@ static const struct rhashtable_params rhash_queues = {
 	.max_size = MAX_NVMEOTCP_QUEUES,
 };
 
+static void
+fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+		      struct mlx5e_umr_wqe *wqe, u16 ccid, u32 klm_entries,
+		      u16 klm_offset)
+{
+	struct scatterlist *sgl_mkey;
+	u32 lkey, i;
+
+	lkey = queue->priv->mdev->mlx5e_res.mkey.key;
+	for (i = 0; i < klm_entries; i++) {
+		sgl_mkey = &queue->ccid_table[ccid].sgl[i + klm_offset];
+		wqe->inline_klms[i].bcount = cpu_to_be32(sgl_mkey->length);
+		wqe->inline_klms[i].key	   = cpu_to_be32(lkey);
+		wqe->inline_klms[i].va	   = cpu_to_be64(sgl_mkey->dma_address);
+	}
+
+	for (; i < ALIGN(klm_entries, KLM_ALIGNMENT); i++) {
+		wqe->inline_klms[i].bcount = 0;
+		wqe->inline_klms[i].key    = 0;
+		wqe->inline_klms[i].va     = 0;
+	}
+}
+
+static void
+build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue,
+		       struct mlx5e_umr_wqe *wqe, u16 ccid, int klm_entries,
+		       u32 klm_offset, u32 len)
+{
+	u32 id = queue->ccid_table[ccid].klm_mkey.key;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg      *cseg = &wqe->ctrl;
+	struct mlx5_mkey_seg	       *mkc = &wqe->mkc;
+
+	u32 sqn = queue->sq->icosq.sqn;
+	u16 pc = queue->sq->icosq.pc;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+				   MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, KLM_ALIGNMENT)));
+	cseg->general_id = cpu_to_be32(id);
+
+	if (!klm_offset) {
+		ucseg->mkey_mask |= cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
+						MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
+		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, KLM_ALIGNMENT));
+		mkc->len = cpu_to_be64(queue->ccid_table[ccid].size);
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, KLM_ALIGNMENT));
+	ucseg->xlt_offset = cpu_to_be16(klm_offset);
+	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+}
+
+static void
+mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
+		       struct mlx5e_icosq *sq, u32 wqe_bbs, u16 pi)
+{
+	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	wi->num_wqebbs = wqe_bbs;
+	wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVME_TCP;
+}
+
+static void
+post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+	     u16 ccid,
+	     u32 klm_length,
+	     u32 *klm_offset)
+{
+	struct mlx5e_icosq *sq = &queue->sq->icosq;
+	u32 wqe_bbs, cur_klm_entries;
+	struct mlx5e_umr_wqe *wqe;
+	u16 pi, wqe_sz;
+
+	cur_klm_entries = min_t(int, queue->max_klms_per_wqe,
+				klm_length - *klm_offset);
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(ALIGN(cur_klm_entries, KLM_ALIGNMENT));
+	wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+	pi = mlx5e_icosq_get_next_pi(sq, wqe_bbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqe_bbs, pi);
+	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, *klm_offset,
+			       klm_length);
+	*klm_offset += cur_klm_entries;
+	sq->pc += wqe_bbs;
+	sq->doorbell_cseg = &wqe->ctrl;
+}
+
+static int
+mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+			    u16 ccid,
+			    u32 klm_length)
+{
+	u32 klm_offset = 0, wqes, wqe_sz, max_wqe_bbs, i, room;
+	struct mlx5e_icosq *sq = &queue->sq->icosq;
+
+	/* TODO: set stricter wqe_sz; using max for now */
+	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(queue->max_klms_per_wqe);
+
+	max_wqe_bbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+
+	room = mlx5e_stop_room_for_wqe(max_wqe_bbs) * wqes;
+	if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, room)))
+		return -ENOSPC;
+
+	for (i = 0; i < wqes; i++)
+		post_klm_wqe(queue, ccid, klm_length, &klm_offset);
+
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg);
+	return 0;
+}
+
 static int
 mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
 			      struct ulp_ddp_limits *limits)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
new file mode 100644
index 000000000000..329e114d6571
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+#ifndef __MLX5E_NVMEOTCP_UTILS_H__
+#define __MLX5E_NVMEOTCP_UTILS_H__
+
+#include "en.h"
+
+#define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
+	((struct mlx5e_umr_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_umr_wqe)))
+
+#endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 3c65fd0bcf31..9d821facbca4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -615,16 +615,20 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 		ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 		wi = &sq->db.wqe_info[ci];
 		sqcc += wi->num_wqebbs;
-#ifdef CONFIG_MLX5_EN_TLS
 		switch (wi->wqe_type) {
+#ifdef CONFIG_MLX5_EN_TLS
 		case MLX5E_ICOSQ_WQE_SET_PSV_TLS:
 			mlx5e_ktls_handle_ctx_completion(wi);
 			break;
 		case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 			mlx5e_ktls_handle_get_psv_completion(wi, sq);
 			break;
-		}
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+		case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
+			break;
+#endif
+		}
 	}
 	sq->cc = sqcc;
 }
@@ -694,6 +698,10 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 			case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 				mlx5e_ktls_handle_get_psv_completion(wi, sq);
 				break;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+			case MLX5E_ICOSQ_WQE_UMR_NVME_TCP:
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
-- 
2.24.1

