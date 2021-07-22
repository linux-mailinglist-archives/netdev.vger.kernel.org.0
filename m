Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A753D2279
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhGVKZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:17 -0400
Received: from mail-mw2nam10on2076.outbound.protection.outlook.com ([40.107.94.76]:3360
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231635AbhGVKZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QilGpbRlZOWCTrjR9FdVfcemeJfEDi4wPgKARnApjHZKlW66bqxI5+HNDhZ/dWp0b7veS6TrHa+IJos126DSEKz59LkMAz4+eehjmKbQP/Itb/+3nShpIcBn/JuV+Yh4SHClaQWt6TqussIRrxMcjNdfheoWJV7l5qV1COCTgXwdXAlJZ6HPrHOLFpGaHQ/QnqkfHv6lNY/VCWADQrWFLJvKZyL45veeuiS32iWO0vLJoERNgyDbIX4LQhV7PHk31rMLlIv/q/Ux5B6JOKZKcda5ft5CfCv0iqXZXPdClb4nDL/63VTYDY3HSXxeKNE98otwHOu4aMljLQbvjbneNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ih0DogM3eCmXM6lcaCWNE5D6+pFQiv7HQwXNqPd2cjE=;
 b=iO9UHkufITfBZOGSHPfDqj51s/+c+xdV+W6QXtlF98phU2iipNDLrh5R3e01IAFmFNm7OStLIvJo/FVlXNjibh4zB0eu7cRgwmSrKmRkU2zSVKkyzBOPYpvbSZuw4ZTZ5lfmf88N4zArqYcWzUTn2MWzvM9+WbnJ38DQGJChCQuDB2HK1iDWQo/tcUpuqFiMHMxT4dDWvzvtwHHYJnTQe0qLPv01hHsWOMWE5AyOj0U87ZLaJrXlsVhSrHioL7egyVJAoAqWVDAAHuMmWSNpW4NC5NVXLInq7IsP0VpIp6eaAz2KXt60zynnk4jAq2lUHUtL0D1p4IU4z/dJCYVXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ih0DogM3eCmXM6lcaCWNE5D6+pFQiv7HQwXNqPd2cjE=;
 b=hsycMXJysGKmLm9e/BStdoLm2yKWEIMVl4aQmDVMtB+etR0MEYjzmNQxkDHaj87+luta+O8IQSTBWusImvRtfFSlC+PctYs1IUFi8A8jpifvLziPwFSicDACelr/bn5C+Q9WaMCROMKugpW1sdJ0TVzddEaXpsdMCfjobvBK/9CVhAxfwLNlTRtMV9u1wCbxqHFEJJnBEnDun0vH7W/LJwxG7t6KJPD6AllJFcGHK9i88UqAEHnsjmzG+Mt9pg/S01GRyO6bczDKiYN84N9nlrjRjndtKHLuvVrNVj6W4Wza8jF8lZRSy7m27ecwupM5ULS9mTv6sBg6EUGGwrOJkA==
Received: from DM6PR02CA0089.namprd02.prod.outlook.com (2603:10b6:5:1f4::30)
 by BN8PR12MB3076.namprd12.prod.outlook.com (2603:10b6:408:61::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 22 Jul
 2021 11:05:41 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::4b) by DM6PR02CA0089.outlook.office365.com
 (2603:10b6:5:1f4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:41 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:05:40 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:36 +0000
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
Subject: [PATCH v5 net-next 18/36] net/mlx5e: NVMEoTCP, data-path for DDP+DDGST offload
Date:   Thu, 22 Jul 2021 14:03:07 +0300
Message-ID: <20210722110325.371-19-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed132b1b-499f-4575-2072-08d94d00a506
X-MS-TrafficTypeDiagnostic: BN8PR12MB3076:
X-Microsoft-Antispam-PRVS: <BN8PR12MB307629266C47BAD29B9C519FBDE49@BN8PR12MB3076.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UuNaxI+Pp31kFm3MUvEOBEXaINJOfKe6VlnvW957DF5dJUG0sPqXzfSNx1Rx7JEXkq5JbujJ9kuB/F24d07sEHo9e3SmH4U4DgicafEFPuusBlNc9YGBqp3/ASIRi0WG74bEQtijtrUZbhN/Twv+vXB8bsDKRe8CkImM2SMhUb1+hG3tw2Ymzlq1Mo41/bfH8X1Pp1o6lTHvItLDTSvf0WvBnX+XmzHXdssiuOQ3DjPZz0fDLzoDWMiLUJKLHwj5W3th6H7t1VucmvR2DgjJxkeYy6+nwdHMi9mG/fAhWJlIsXDp8A/9aNhWSlD7oNlpDDXEJq+DYarisSe2IZI8xlbHGVUE1sgVqE1MmGvKA/u7jYqKy/dSB68hAatOih+7dklDdnx0w2b8prqr3pvuPUvYzhaZ+pR29S2NJaYwY2eDUXBMqvurEt3bhu53jlDN+6rKaIR5F+Hhiyc/wKDw8GGjXxFR+wh3jyNR71CciluuhCbO63Yb8gsbJAkYYLAINUEHB8RJkH21uzr5NEy1RV/Wds5BgGUCjNw4kKN5P7Sk4jMh4KPGJ6f7LhXQHW8gB1LIAG06ElTZHdQTCWl7OCPq6NPrBLNHTQiYHlVc+6Jwk82K0qcOXKZ77qt5qkl3gAEnGT9TVz6MKSKKjUJPP694XOYqy/nFbzIhYJOD90NMMwLevgWpOIJPWyiS1yHBeoHR44j5qvAMPYM7IAieBFCk7pYqFVmzGT09aOTSCXZSmvl3EAuymUwif9sejGlX
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(46966006)(36840700001)(83380400001)(36906005)(8936002)(5660300002)(6666004)(2906002)(186003)(356005)(7636003)(426003)(8676002)(2616005)(30864003)(47076005)(7696005)(7416002)(54906003)(86362001)(26005)(70206006)(336012)(478600001)(1076003)(4326008)(36756003)(82740400003)(110136005)(316002)(107886003)(921005)(70586007)(36860700001)(82310400003)(21314003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:41.2537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed132b1b-499f-4575-2072-08d94d00a506
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This patch implements the data-path for direct data placement (DDP)
and DDGST offloads. NVMEoTCP DDP constructs an SKB from each CQE, while
pointing at NVME destination buffers. In turn, this enables the offload,
as the NVMe-TCP layer will skip the copy when src == dst.

Additionally, this patch adds support for DDGST (CRC32) offload.
HW will report DDGST offload only if it has not encountered an error
in the received packet. We pass this indication in skb->ddp_crc
up the stack to NVMe-TCP to skip computing the DDGST if all
corresponding SKBs were verified by HW.

This patch also handles context resynchronization requests made by
NIC HW. The resync request is passed to the NVMe-TCP layer
to be handled at a later point in time.

Finally, we also use the skb->ddp_crc bit to avoid skb_condense.
This is critical as every SKB that uses DDP has a hole that fits
perfectly with skb_condense's policy, but filling this hole is
counter-productive as the data there already resides in its
destination buffer.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   1 +
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 248 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |  43 +++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  41 ++-
 7 files changed, 330 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 0ae9e5e38ec7..992b396907ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -102,4 +102,4 @@ mlx5_core-$(CONFIG_MLX5_SF) += sf/vhca_event.o sf/dev/dev.o sf/dev/driver.o
 #
 mlx5_core-$(CONFIG_MLX5_SF_MANAGER) += sf/cmd.o sf/hw_table.o sf/devlink.o
 
-mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o en_accel/nvmeotcp_rxtx.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index d88ecd04d5da..c87f32492ea4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -589,6 +589,7 @@ struct mlx5e_rq;
 typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64*);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe_mpwrq)(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+			       struct mlx5_cqe64 *cqe,
 			       u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 8e7b877d8a12..9a6fbd1b1c34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -25,6 +25,7 @@ static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, void *data,
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 7f88ccf67fdd..112c5b3ec165 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -11,6 +11,7 @@
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
new file mode 100644
index 000000000000..31586f574fc0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -0,0 +1,248 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#include "en_accel/nvmeotcp_rxtx.h"
+#include "en_accel/nvmeotcp.h"
+#include <linux/mlx5/mlx5_ifc.h>
+
+#define	MLX5E_TC_FLOW_ID_MASK  0x00ffffff
+static void nvmeotcp_update_resync(struct mlx5e_nvmeotcp_queue *queue,
+				   struct mlx5e_cqe128 *cqe128)
+{
+	const struct ulp_ddp_ulp_ops *ulp_ops;
+	u32 seq;
+
+	seq = be32_to_cpu(cqe128->resync_tcp_sn);
+	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
+	if (ulp_ops && ulp_ops->resync_request)
+		ulp_ops->resync_request(queue->sk, seq, ULP_DDP_RESYNC_REQ);
+}
+
+static void mlx5e_nvmeotcp_advance_sgl_iter(struct mlx5e_nvmeotcp_queue *queue)
+{
+	struct nvmeotcp_queue_entry *nqe = &queue->ccid_table[queue->ccid];
+
+	queue->ccoff += nqe->sgl[queue->ccsglidx].length;
+	queue->ccoff_inner = 0;
+	queue->ccsglidx++;
+}
+
+static inline void
+mlx5e_nvmeotcp_add_skb_frag(struct net_device *netdev, struct sk_buff *skb,
+			    struct mlx5e_nvmeotcp_queue *queue,
+			    struct nvmeotcp_queue_entry *nqe, u32 fragsz)
+{
+	dma_sync_single_for_cpu(&netdev->dev,
+				nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
+				fragsz, DMA_FROM_DEVICE);
+	page_ref_inc(compound_head(sg_page(&nqe->sgl[queue->ccsglidx])));
+	// XXX: consider reducing the truesize, as no new memory is consumed
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			sg_page(&nqe->sgl[queue->ccsglidx]),
+			nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
+			fragsz,
+			fragsz);
+}
+
+static struct sk_buff*
+mlx5_nvmeotcp_add_tail_nonlinear(struct mlx5e_nvmeotcp_queue *queue,
+				 struct sk_buff *skb, skb_frag_t *org_frags,
+				 int org_nr_frags, int frag_index)
+{
+	struct mlx5e_priv *priv = queue->priv;
+
+	while (org_nr_frags != frag_index) {
+		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+			dev_kfree_skb_any(skb);
+			return NULL;
+		}
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				skb_frag_page(&org_frags[frag_index]),
+				skb_frag_off(&org_frags[frag_index]),
+				skb_frag_size(&org_frags[frag_index]),
+				skb_frag_size(&org_frags[frag_index]));
+		page_ref_inc(skb_frag_page(&org_frags[frag_index]));
+		frag_index++;
+	}
+	return skb;
+}
+
+static struct sk_buff*
+mlx5_nvmeotcp_add_tail(struct mlx5e_nvmeotcp_queue *queue, struct sk_buff *skb,
+		       int offset, int len)
+{
+	struct mlx5e_priv *priv = queue->priv;
+
+	if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+		dev_kfree_skb_any(skb);
+		return NULL;
+	}
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			virt_to_page(skb->data),
+			offset,
+			len,
+			len);
+	page_ref_inc(virt_to_page(skb->data));
+	return skb;
+}
+
+static void mlx5_nvmeotcp_trim_nonlinear(struct sk_buff *skb,
+					 skb_frag_t *org_frags,
+					 int *frag_index,
+					 int remaining)
+{
+	unsigned int frag_size;
+	int nr_frags;
+
+	/* skip @remaining bytes in frags */
+	*frag_index = 0;
+	while (remaining) {
+		frag_size = skb_frag_size(&skb_shinfo(skb)->frags[*frag_index]);
+		if (frag_size > remaining) {
+			skb_frag_off_add(&skb_shinfo(skb)->frags[*frag_index],
+					 remaining);
+			skb_frag_size_sub(&skb_shinfo(skb)->frags[*frag_index],
+					  remaining);
+			remaining = 0;
+		} else {
+			remaining -= frag_size;
+			skb_frag_unref(skb, *frag_index);
+			*frag_index += 1;
+		}
+	}
+
+	/* save original frags for the tail and unref */
+	nr_frags = skb_shinfo(skb)->nr_frags;
+	memcpy(&org_frags[*frag_index], &skb_shinfo(skb)->frags[*frag_index],
+	       (nr_frags - *frag_index) * sizeof(skb_frag_t));
+	while (--nr_frags >= *frag_index)
+		skb_frag_unref(skb, nr_frags);
+
+	/* remove frags from skb */
+	skb_shinfo(skb)->nr_frags = 0;
+	skb->len -= skb->data_len;
+	skb->truesize -= skb->data_len;
+	skb->data_len = 0;
+}
+
+struct sk_buff*
+mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt,
+			     bool linear)
+{
+	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	skb_frag_t org_frags[MAX_SKB_FRAGS];
+	struct mlx5e_nvmeotcp_queue *queue;
+	struct nvmeotcp_queue_entry *nqe;
+	int org_nr_frags, frag_index;
+	struct mlx5e_cqe128 *cqe128;
+	u32 queue_id;
+
+	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
+	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
+	if (unlikely(!queue)) {
+		dev_kfree_skb_any(skb);
+		return NULL;
+	}
+
+	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
+	if (cqe_is_nvmeotcp_resync(cqe)) {
+		nvmeotcp_update_resync(queue, cqe128);
+		mlx5e_nvmeotcp_put_queue(queue);
+		return skb;
+	}
+
+	/* If a resync occurred in the previous cqe,
+	 * the current cqe.crcvalid bit may not be valid,
+	 * so we will treat it as 0
+	 */
+	if (unlikely(queue->after_resync_cqe)) {
+		skb->ddp_crc = 0;
+		queue->after_resync_cqe = 0;
+	} else {
+		if (queue->crc_rx)
+			skb->ddp_crc = cqe_is_nvmeotcp_crcvalid(cqe);
+		else
+			skb->ddp_crc = cqe_is_nvmeotcp_zc(cqe);
+	}
+
+	if (!cqe_is_nvmeotcp_zc(cqe)) {
+		mlx5e_nvmeotcp_put_queue(queue);
+		return skb;
+	}
+
+	/* cc ddp from cqe */
+	ccid = be16_to_cpu(cqe128->ccid);
+	ccoff = be32_to_cpu(cqe128->ccoff);
+	cclen = be16_to_cpu(cqe128->cclen);
+	hlen  = be16_to_cpu(cqe128->hlen);
+
+	/* carve a hole in the skb for DDP data */
+	if (linear) {
+		skb_trim(skb, hlen);
+	} else {
+		org_nr_frags = skb_shinfo(skb)->nr_frags;
+		mlx5_nvmeotcp_trim_nonlinear(skb, org_frags, &frag_index,
+					     cclen);
+	}
+
+	nqe = &queue->ccid_table[ccid];
+
+	/* packet starts new ccid? */
+	if (queue->ccid != ccid || queue->ccid_gen != nqe->ccid_gen) {
+		queue->ccid = ccid;
+		queue->ccoff = 0;
+		queue->ccoff_inner = 0;
+		queue->ccsglidx = 0;
+		queue->ccid_gen = nqe->ccid_gen;
+	}
+
+	/* skip inside cc until the ccoff in the cqe */
+	while (queue->ccoff + queue->ccoff_inner < ccoff) {
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(off_t, remaining,
+			       ccoff - (queue->ccoff + queue->ccoff_inner));
+
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	/* adjust the skb according to the cqe cc */
+	while (to_copy < cclen) {
+		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
+			dev_kfree_skb_any(skb);
+			mlx5e_nvmeotcp_put_queue(queue);
+			return NULL;
+		}
+
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(int, remaining, cclen - to_copy);
+
+		mlx5e_nvmeotcp_add_skb_frag(netdev, skb, queue, nqe, fragsz);
+		to_copy += fragsz;
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	if (cqe_bcnt > hlen + cclen) {
+		remaining = cqe_bcnt - hlen - cclen;
+		if (linear)
+			skb = mlx5_nvmeotcp_add_tail(queue, skb,
+						     offset_in_page(skb->data) +
+								hlen + cclen,
+						     remaining);
+		else
+			skb = mlx5_nvmeotcp_add_tail_nonlinear(queue, skb,
+							       org_frags,
+							       org_nr_frags,
+							       frag_index);
+	}
+
+	mlx5e_nvmeotcp_put_queue(queue);
+	return skb;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
new file mode 100644
index 000000000000..65456b46c33f
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+#ifndef __MLX5E_NVMEOTCP_RXTX_H__
+#define __MLX5E_NVMEOTCP_RXTX_H__
+
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+
+#include <linux/skbuff.h>
+#include "en.h"
+
+struct sk_buff*
+mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt, bool linear);
+
+static inline int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	struct mlx5e_cqe128 *cqe128;
+
+	if (!cqe_is_nvmeotcp_zc(cqe) || cqe_is_nvmeotcp_resync(cqe))
+		return cqe_bcnt;
+
+	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
+	return be16_to_cpu(cqe128->hlen);
+}
+
+#else
+static inline struct sk_buff*
+mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt, bool linear)
+{ return skb; }
+
+static inline int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{ return cqe_bcnt; }
+
+#endif /* CONFIG_MLX5_EN_NVMEOTCP */
+
+static inline u16 mlx5e_get_headlen_hint(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	return min_t(u32, MLX5E_RX_MAX_HEAD, mlx5_nvmeotcp_get_headlen(cqe, cqe_bcnt));
+}
+
+
+#endif /* __MLX5E_NVMEOTCP_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e92dd4666955..8a20a5800e20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,6 +48,7 @@
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/tls_rxtx.h"
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_rxtx.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
@@ -57,9 +58,11 @@
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				struct mlx5_cqe64 *cqe,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				   struct mlx5_cqe64 *cqe,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
@@ -1186,6 +1189,12 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	/* queue up for recycling/reuse */
 	page_ref_inc(di->page);
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, true);
+#endif
+
 	return skb;
 }
 
@@ -1194,8 +1203,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
+	u16 headlen = mlx5e_get_headlen_hint(cqe, cqe_bcnt);
 	struct mlx5e_wqe_frag_info *head_wi = wi;
-	u16 headlen      = min_t(u32, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	u16 frag_headlen = headlen;
 	u16 byte_cnt     = cqe_bcnt - headlen;
 	struct sk_buff *skb;
@@ -1204,7 +1213,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	 * might spread among multiple pages.
 	 */
 	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
+			     ALIGN(headlen, sizeof(long)));
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
 		return NULL;
@@ -1230,6 +1239,12 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	skb->tail += headlen;
 	skb->len  += headlen;
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, false);
+#endif
+
 	return skb;
 }
 
@@ -1389,7 +1404,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
@@ -1423,17 +1438,18 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_rep = {
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				   struct mlx5_cqe64 *cqe,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
-	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
+	u16 headlen = mlx5e_get_headlen_hint(cqe, cqe_bcnt);
 	u32 frag_offset    = head_offset + headlen;
 	u32 byte_cnt       = cqe_bcnt - headlen;
 	struct mlx5e_dma_info *head_di = di;
 	struct sk_buff *skb;
 
 	skb = napi_alloc_skb(rq->cq.napi,
-			     ALIGN(MLX5E_RX_MAX_HEAD, sizeof(long)));
+			     ALIGN(headlen, sizeof(long)));
 	if (unlikely(!skb)) {
 		rq->stats->buff_alloc_err++;
 		return NULL;
@@ -1464,11 +1480,18 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	skb->tail += headlen;
 	skb->len  += headlen;
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, false);
+#endif
+
 	return skb;
 }
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				struct mlx5_cqe64 *cqe,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
 	struct mlx5e_dma_info *di = &wi->umr.dma_info[page_idx];
@@ -1510,6 +1533,12 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 	/* queue up for recycling/reuse */
 	page_ref_inc(di->page);
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (cqe_is_nvmeotcp(cqe))
+		skb = mlx5e_nvmeotcp_handle_rx_skb(rq->netdev, skb, cqe,
+						   cqe_bcnt, true);
+#endif
+
 	return skb;
 }
 
@@ -1548,7 +1577,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
-- 
2.24.1

