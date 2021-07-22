Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691AF3D2286
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhGVK0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:17 -0400
Received: from mail-bn1nam07on2055.outbound.protection.outlook.com ([40.107.212.55]:35134
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231670AbhGVK0O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:26:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaLb2VtSoBv5PfQrXQxn9DyfQXDjLfzx4g5SZ7gnsl/Fa5LjDl/IaRW70xwiZYtavTGknJfWlGKc9OiftrOkbgH68nNnztSXDnD5KO+uw8c9XftRKfmDWgv35gmCUbEXAOwZ7G85TyBxj8ReJeJdI9VMzOJ0z6CcEoUjw2n7LpnHjM+7b/Sl8AkQ7CDjSr7RDxz4VONX52XBornYxU9pSP7Djw6GybpC0Iqa0O0/321CkP25SzZ8Ql5F9TiA3F2jD4b7+o6V6IFzazyXUipl4fUDBxj6xrWIseTpQQ5IV/dZmT17angg0d6B3aHMGBITgxYZFzyT0jwJbR1AZMA1QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Vsen5bhy2iMXAw5gSfBDTtXKWFC9pBrUrotXQM4q40=;
 b=Vb9xXCJs8uOU4KCkUCWKhipFqKm2rhjaxFbjXBV8oCTD5T4XzzDo8abXnqApvsyWrPsayQIeiX+GlYPWCjHVciOZriWET58DBjqY/5RS8m4+KqMIHif15a5q6s5hVNt2YQUAi2TEvSlv3YPk0yXqNrOLtmmm0zDSqcN3bd+WAJzUgkFzhLKyfoYhzCabJyU33PkwBaC5EkHqZQDdsMHXAi6HvKZRGErEpdUAi5kXU783NlxXHfQ9j81HJXDhJ6OZupBAr8vo1TriiTFQkITgKZztNls8YB+6Guc0lVXT6Mqd16ZS4XVQE8PR0BfnP7sXPfF7q0BK20LxrsR+ahKT+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Vsen5bhy2iMXAw5gSfBDTtXKWFC9pBrUrotXQM4q40=;
 b=ahv8U6rpesu0L9yQELROfWNnxx7gN/YTLZtxNuMAEJLURO7+KfuukGy7kub95C+Ge7FJJNkBTjMW6e3Zs0Qya90IRKm26JHzsmfZIjwTWCc+owgEap7yfRTaHDpv/ciWT7XMiiugql2yBPb9CKAtCWvqg3+3tDNZEkIrA/oqkTx+gEBK4ijKgPU33Hhpp1UuBttV3slEaw+YIC6nYh0f21p0kH3aXU7dCXJmgCYuTGGQx5dnwKSZTSQWhoZL1Sf/ROiArTnwLfePs/DA59h3HjkUl+U7TZw2v7N5qgLntLqDnOu1tdfWRQwfpd1EM+X9TAciGjPGvNFxV51sztehsQ==
Received: from DM5PR12CA0068.namprd12.prod.outlook.com (2603:10b6:3:103::30)
 by BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 22 Jul
 2021 11:06:48 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:103:cafe::84) by DM5PR12CA0068.outlook.office365.com
 (2603:10b6:3:103::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:47 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:46 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:41 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 31/36] net/mlx5e: NVMEoTCP DDGST Tx offload queue init/teardown
Date:   Thu, 22 Jul 2021 14:03:20 +0300
Message-ID: <20210722110325.371-32-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e33b59a9-fa94-4fee-141e-08d94d00ccc9
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:
X-Microsoft-Antispam-PRVS: <BYAPR12MB274370019DD04C4886B6E2F9BDE49@BYAPR12MB2743.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:164;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xxAVwlP6OO+eSmTy8dmDdUXuJtqK0QR7Mv2Q15HgjZn2to/nrruJxHLDq+OViXw/KszeXw2yQhgwF0dmJTW+eKbiqYXeGLtZAzgcOjTw0878ngeZlToMdRqjjuMHKE8qTXnizsvfz/WrbRyop0Tpiu9pc/GGLqNk+Eo2uQn+cgZsGkoUrjgujoeZRWWtQ/L63E392F0dhlcpMeasNUbTaqOpauTmH//VbVPESWnmH0dS4MLsc3S0AzD/ZHUf7fLQeOcW6vyY+wD/3EPqwuLyOSF3j6BKJH1XFrQfXPtbMiULrGdXL3LeBsnVBbYcR4HM+XDivHbLht3UFicUU1p1v6m7I6rx2xlCE/LbrArzQ4eOTJ4pZ5w77NnENZGNTvzzR8/+fLIPev0UcXJd+XqOwAAxGVmWycUcg8M969kVdPiCI/BazX4/CXq7wVI6rg5kT70JZjTOqqwSDLCvxISDDslhWpdVHKuKvJXP/bVByxG7m1F0vgGBean6jDpDd6+BM+pf5PD7lhKL/HkDZeoJ5PdWDHozWWpfeUYqPBhiVOr4iwQ0N+Q75BdXr9cbBPnWiDaxL4pxCMvdHsy7y9R95kny7clhpatOzqU+GNQjUXj3TAeEtiOrEekxm5hAl9dHLwfTullGrAeT2oUYFTApZDSZ5E0GZzasrQDgx1q7MlnCBUq6eVEUrteQNc4dRFxcadDuJdxEWfARGTE+YLgITITy3gLREd0uSSq1/zOoqJA=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(110136005)(8936002)(316002)(426003)(336012)(70206006)(4326008)(8676002)(36906005)(2906002)(1076003)(186003)(7696005)(70586007)(107886003)(36756003)(7416002)(26005)(7636003)(2616005)(54906003)(82740400003)(6666004)(82310400003)(921005)(47076005)(356005)(5660300002)(478600001)(36860700001)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:47.9345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e33b59a9-fa94-4fee-141e-08d94d00ccc9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2743
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

  This commit add support for DDGST TX offload to the mlx5e_nvmeotcp_queue_init/teardown function.
  If enable, mlx5e_nvmeotcp_queue_init will call mlx5e_nvmeotcp_queue_tx_init to handle TX offload init.

  Add to mlx5e NVMEoTCP queue is responsible for:
  - Create a separate TIS to identify the queue and maintain the HW context
  - Update ulp_ddp_ctx params.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 47 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    | 12 ++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index d42f346ac8f5..6023e1ae7be4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -669,6 +669,36 @@ mlx5e_nvmeotcp_queue_rx_init(struct mlx5e_nvmeotcp_queue *queue,
 	return err;
 }
 
+static int
+mlx5e_nvmeotcp_queue_tx_init(struct mlx5e_nvmeotcp_queue *queue,
+			     struct mlx5_core_dev *mdev,
+			     struct net_device *netdev)
+{
+	struct sock *sk = queue->sk;
+	int err, tisn;
+
+	err = mlx5e_nvmeotcp_create_tis(mdev, &tisn);
+
+	if (err) {
+		mlx5_core_err(mdev, "create tis failed, %d\n", err);
+		return err;
+	}
+
+	queue->tisn = tisn;
+	queue->ulp_ddp_ctx.expected_seq = tcp_sk(sk)->write_seq;
+	queue->pending = true;
+	queue->end_seq_hint = 0;
+	queue->ulp_ddp_ctx.netdev = netdev;
+	queue->ulp_ddp_ctx.ddgst_len = 4;
+
+	/* following this assignment mlx5e_nvmeotcp_is_sk_tx_device_offloaded
+	 * will return true and ulp_ddp_ctx might be accessed
+	 * by the netdev's xmit function.
+	 */
+	smp_store_release(&sk->sk_validate_xmit_skb, ulp_ddp_validate_xmit_skb);
+	return err;
+}
+
 #define OCTWORD_SHIFT 4
 #define MAX_DS_VALUE 63
 static int
@@ -680,6 +710,8 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	bool crc_rx = ((netdev->features & NETIF_F_HW_ULP_DDP) &&
 		       (config->dgst & NVME_TCP_DATA_DIGEST_ENABLE));
 	bool zerocopy = (netdev->features & NETIF_F_HW_ULP_DDP);
+	bool crc_tx = (config->dgst & NVME_TCP_DATA_DIGEST_ENABLE)  &&
+		(netdev->features & NETIF_F_HW_ULP_DDP);
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_nvmeotcp_queue *queue;
@@ -709,6 +741,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 		goto free_queue;
 	}
 
+	queue->crc_tx = crc_tx;
 	queue->crc_rx = crc_rx;
 	queue->zerocopy = zerocopy;
 	queue->ulp_ddp_ctx.type = ULP_DDP_NVME;
@@ -736,6 +769,12 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	if (err)
 		goto destroy_rx;
 
+	if (crc_tx) {
+		err = mlx5e_nvmeotcp_queue_tx_init(queue, mdev, netdev);
+		if (err)
+			goto remove_queue_from_hash;
+	}
+
 	stats->nvmeotcp_queue_init++;
 	write_lock_bh(&sk->sk_callback_lock);
 	ulp_ddp_set_ctx(sk, queue);
@@ -743,6 +782,9 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	refcount_set(&queue->ref_count, 1);
 	return err;
 
+remove_queue_from_hash:
+	rhashtable_remove_fast(&priv->nvmeotcp->queue_hash,
+			       &queue->hash, rhash_queues);
 destroy_rx:
 	if (zerocopy || crc_rx)
 		mlx5e_nvmeotcp_destroy_rx(queue, mdev, zerocopy);
@@ -778,6 +820,11 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 	rhashtable_remove_fast(&priv->nvmeotcp->queue_hash, &queue->hash,
 			       rhash_queues);
 	ida_simple_remove(&priv->nvmeotcp->queue_ids, queue->id);
+	if (queue->crc_tx) {
+		smp_store_release(&sk->sk_validate_xmit_skb, NULL);
+		mlx5e_nvmeotcp_delete_tis(priv, queue->tisn);
+	}
+
 	write_lock_bh(&sk->sk_callback_lock);
 	ulp_ddp_set_ctx(sk, NULL);
 	write_unlock_bh(&sk->sk_callback_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index b9642e130b97..3bc45b81da06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -47,12 +47,16 @@ struct mlx5e_nvmeotcp_sq {
  *	@sk: The socket used by the NVMe-TCP queue
  *	@zerocopy: if this queue is used for zerocopy offload.
  *	@crc_rx: if this queue is used for CRC Rx offload.
+ *	@crc_tx: if this queue is used for CRC Tx offload.
  *	@ccid: ID of the current CC
  *	@ccsglidx: Index within the scatter-gather list (SGL) of the current CC
  *	@ccoff_inner: Current offset within the @ccsglidx element
  *	@priv: mlx5e netdev priv
  *	@inv_done: invalidate callback of the nvme tcp driver
  *	@after_resync_cqe: indicate if resync occurred
+ *	@tisn: Destination TIS number created for NVMEoTCP CRC TX offload
+ *	@pending: indicate if static/progress params need to be send to NIC.
+ *	@end_seq_hint: Tx ooo - offload packet only if it ends after the hint.
  */
 struct mlx5e_nvmeotcp_queue {
 	struct ulp_ddp_ctx		ulp_ddp_ctx;
@@ -66,7 +70,7 @@ struct mlx5e_nvmeotcp_queue {
 	u32				tag_buf_table_id;
 	struct rhash_head		hash;
 	refcount_t			ref_count;
-	bool				dgst;
+	int				dgst;
 	int				pda;
 	u32				ccid_gen;
 	u32				max_klms_per_wqe;
@@ -74,6 +78,12 @@ struct mlx5e_nvmeotcp_queue {
 	struct sock			*sk;
 	bool				zerocopy;
 	bool				crc_rx;
+	bool				crc_tx;
+	/* for crc_tx offload */
+	int				tisn;
+	bool				pending;
+	u32				end_seq_hint;
+	u32				start_pdu_hint;
 
 	/* current ccid fields */
 	off_t				ccoff;
-- 
2.24.1

