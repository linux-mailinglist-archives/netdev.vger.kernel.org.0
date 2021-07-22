Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDD63D226F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhGVKYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:24:36 -0400
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:43617
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231717AbhGVKYQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:24:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mm0PAopKCgJk49IlCPscU7SNh/3mpWaUBk1fVoqeYhbkuSfHyIyQWTOmXKd/IiozaZBMbTxB07wIKvfxXpqqXGwmC6R6XiUwijLJPv+wu6hwDvmvq16LGuceOceGncUkCpQlU0x/isJp78KplyfrPdlRzjB5LJYbcnDP4nbeB6u90IL6zjdiAnikcHZh3t6JcpmmwLDns6tx8Bd4nyA9EcyTwI7URUNgRM6ANut4i1zySgCAdBbiheZo3mdiclC1EnwkPZ2fvIvZ+o1L08q+v+UO2+Dme2mAf+FlrgirCGjut/3Ac8/XyukOBcFewlLntyHaefWiVlB+aisNtwoUqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7NCURwDQi4ArkZ7VF7g+H03CWQOyqQPqH7B9S++Aw4=;
 b=ZU7LwY1Lfrr1XZY082spDxYX6Xaj19wOdqKHD2PsLKwUxdddMm0FWj365LBqHlV8baSsfe32o1vxMghtgY8r4LXm+3iDH1mDXYvmZoMX50CQtwLJt3Po/I2DzLqmWsOvBydHhHSuiqONt1xO95eUcCJwnF69+m5VDNpLpuklt6kp2NBrMVVr9XJEOpEfvaH4KaLQsYeb26/1XvLkiPjsFa4tilAWG9BxlJFKBLmHTIDGcd6dYPR6UeJMfm3dnSOtV0Us9PWeEO71JxWTV0obK0JgEBJsJqUaTckR7Te3cgsXdeRkDKv7pPSxzlmY1ImCnHHbmt5VGANJyMU+x2gMPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7NCURwDQi4ArkZ7VF7g+H03CWQOyqQPqH7B9S++Aw4=;
 b=aUSHbtJbYdS02Wvavlav03qCrJ6TtkgUV5xYVRuK03UrUQKPh/y8aZuI0HCJSY1qhENSFXv+RDNQh4SRb4amnXkzHrn4HJLEYF8pmyOLBdtcCNPgjX7PV0UE8d77SKUZC0Dyf6STdd2rP021XdkVQBsJQdreRYDcKoc9hykYiyEeiz2yFiGRR8MZI8KqGzvxpYdFVSnNZL46p+XPrn0WalrZGhFaDhIMHJt2q74phZCl+w8wkKLL5RxbvEzzXV6wJT/E+pRdYZEqsK58P2aayhQOjLl3WAnZkh433H+ty76Y3Uw4Zm9WKWSMaBBP2T+YOklmtPlb3SThk/JKjQ4B7w==
Received: from BN6PR19CA0068.namprd19.prod.outlook.com (2603:10b6:404:e3::30)
 by MWHPR12MB1326.namprd12.prod.outlook.com (2603:10b6:300:10::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 11:04:49 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::c1) by BN6PR19CA0068.outlook.office365.com
 (2603:10b6:404:e3::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:04:48 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:04:48 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:04:43 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Yoray Zack <yorayz@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH v5 net-next 07/36] nvme-tcp: RX DDGST offload
Date:   Thu, 22 Jul 2021 14:02:56 +0300
Message-ID: <20210722110325.371-8-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc2619d2-7a9c-4a76-62a6-08d94d0085c2
X-MS-TrafficTypeDiagnostic: MWHPR12MB1326:
X-Microsoft-Antispam-PRVS: <MWHPR12MB13268EF528C49AAE2EF2919EBDE49@MWHPR12MB1326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4jkCKAWKu3oZpQfBu8by86pwIouE3ajRg17HJQ41Kvp5sqPPL5Y3cVNTLFE7GtFevWzTiRvVW4Cc6NdsivZaSh/p2sfG7g6shoU6iVIV84rpdCu6wdDTAJh/m0KvHGQIkW37mmxn2lmLlYciNJiBDQ5BqOv9Rprw2BIqh4BXF9HDLpDr0zZUukRgsLHL6mGFy+lvnJC2y7JXbUV1hLyGQ/gIF75eA4xY9iTMnaDgWFucgZmRfuu/NjL13SggY114duiHdZiw8jY/cnOKKx/nSdJRVVa2bNEKkv9Gd0mamyoob76pPapYCatvHZCnjmMb8UlZ7LYkhiEOnhobjR1MZwS/C+FvgGyqeX/nSMsuax764QQ54GH1CS6J098C/L7jj76WknEybngEU6HzCjvSy/kk5hx22iXItZpMMoUwXpo7hstNGNBMsAAJt5TrA825Yb9OWtQAbWTOJ+i1Jv/XqH19fUBU29tmRwJvISIdcSns98UAKaGME+m4MSZDR25o0ftH+tDhTsoU/wF6tEzBH6aad4BtkHAbgzBP1Bmr+3/9DGT2wPbYnhDNwvK26Znk96LLn5SUQXIcP//Og/jFgyrdz4k+mX1DFkCfH/gYw9jnFx3XRZel7GEX7LCHmMbBEPEZlv4zXoYs3zYzyyB4wDPa25QVlA1+SEl0dzxgg7jsP1eSPwb2A1VdhzvAQrL2B3E7SY5rYHi7AMIW0Xs3+ZceuvXo93d2yGbb2EfENBM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2616005)(2906002)(5660300002)(356005)(336012)(54906003)(1076003)(26005)(7696005)(86362001)(7416002)(508600001)(107886003)(36756003)(426003)(316002)(36906005)(921005)(4326008)(8676002)(47076005)(6666004)(70206006)(110136005)(8936002)(82310400003)(83380400001)(36860700001)(7636003)(186003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:04:48.7464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2619d2-7a9c-4a76-62a6-08d94d0085c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@mellanox.com>

Enable rx side of DDGST offload when supported.

At the end of the capsule, check if all the skb bits are
on, and if not recalculate the DDGST in SW and check it.

We reworked the receive-side DDGST calculation to always run
at the end, so as to keep a single flow for both offload and
non-offload. This change simplifies the code, but it may
degrade performance for non-offload DDGST calculation.

Signed-off-by: Yoray Zack <yorayz@mellanox.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---
 drivers/nvme/host/tcp.c | 86 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 34982fb0c655..b23fdbb4fd8b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -69,6 +69,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
 	NVME_TCP_Q_OFF_DDP	= 3,
+	NVME_TCP_Q_OFF_DDGST_RX = 4,
 };
 
 enum nvme_tcp_recv_state {
@@ -96,6 +97,7 @@ struct nvme_tcp_queue {
 	size_t			data_remaining;
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
+	bool			ddgst_valid;
 
 	/* send state */
 	struct nvme_tcp_request *request;
@@ -230,6 +232,22 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 	return nvme_tcp_pdu_data_left(req) <= len;
 }
 
+static inline bool nvme_tcp_ddp_ddgst_ok(struct nvme_tcp_queue *queue)
+{
+	return queue->ddgst_valid;
+}
+
+static inline void nvme_tcp_ddp_ddgst_update(struct nvme_tcp_queue *queue,
+					     struct sk_buff *skb)
+{
+	if (queue->ddgst_valid)
+#ifdef CONFIG_ULP_DDP
+		queue->ddgst_valid = skb->ddp_crc;
+#else
+		queue->ddgst_valid = false;
+#endif
+}
+
 static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
 {
 	int ret;
@@ -243,6 +261,26 @@ static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
 	return 0;
 }
 
+static void nvme_tcp_ddp_ddgst_recalc(struct ahash_request *hash,
+				      struct request *rq)
+{
+	struct nvme_tcp_request *req;
+
+	if (!rq)
+		return;
+
+	req = blk_mq_rq_to_pdu(rq);
+
+	if (!req->offloaded && nvme_tcp_req_map_sg(req, rq))
+		return;
+
+	crypto_ahash_init(hash);
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	ahash_request_set_crypt(hash, req->ddp.sg_table.sgl, NULL,
+				le32_to_cpu(req->data_len));
+	crypto_ahash_update(hash);
+}
+
 #ifdef CONFIG_ULP_DDP
 
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
@@ -330,8 +368,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
-	if (netdev->features & NETIF_F_HW_ULP_DDP)
+	if (netdev->features & NETIF_F_HW_ULP_DDP) {
 		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
+	}
 
 	return ret;
 }
@@ -346,6 +386,7 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 
 	netdev->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
 
@@ -721,6 +762,7 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
 	queue->pdu_offset = 0;
 	queue->data_remaining = -1;
 	queue->ddgst_remaining = 0;
+	queue->ddgst_valid = true;
 }
 
 static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
@@ -914,7 +956,8 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_resync_response(queue, skb, *offset);
 
 	ret = skb_copy_bits(skb, *offset,
@@ -977,14 +1020,14 @@ static int nvme_tcp_consume_skb(struct nvme_tcp_queue *queue, struct sk_buff *sk
 
 #ifdef CONFIG_ULP_DDP
 	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags)) {
-		if (queue->data_digest)
+		if (queue->data_digest && !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 			ret = skb_ddp_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
 					queue->rcv_hash);
 		else
 			ret = skb_ddp_copy_datagram_iter(skb, *offset, iter, recv_len);
 	} else {
 #endif
-		if (queue->data_digest)
+		if (queue->data_digest && !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 			ret = skb_copy_and_hash_datagram_iter(skb, *offset, iter, recv_len,
 					queue->rcv_hash);
 		else
@@ -1003,6 +1046,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	struct nvme_tcp_request *req;
 	struct request *rq;
 
+	if (queue->data_digest && test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
 	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
 		dev_err(queue->ctrl->ctrl.device,
@@ -1055,7 +1100,6 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 
 	if (!queue->data_remaining) {
 		if (queue->data_digest) {
-			nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
 			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
 		} else {
 			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
@@ -1076,8 +1120,12 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	char *ddgst = (char *)&queue->recv_ddgst;
 	size_t recv_len = min_t(size_t, *len, queue->ddgst_remaining);
 	off_t off = NVME_TCP_DIGEST_LENGTH - queue->ddgst_remaining;
+	bool offload_fail, offload_en;
+	struct request *rq = NULL;
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
 	ret = skb_copy_bits(skb, *offset, &ddgst[off], recv_len);
 	if (unlikely(ret))
 		return ret;
@@ -1088,18 +1136,25 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	if (queue->ddgst_remaining)
 		return 0;
 
-	if (queue->recv_ddgst != queue->exp_ddgst) {
-		dev_err(queue->ctrl->ctrl.device,
-			"data digest error: recv %#x expected %#x\n",
-			le32_to_cpu(queue->recv_ddgst),
-			le32_to_cpu(queue->exp_ddgst));
-		return -EIO;
+	rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
+
+	offload_fail = !nvme_tcp_ddp_ddgst_ok(queue);
+	offload_en = test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
+	if (!offload_en || offload_fail) {
+		if (offload_en && offload_fail)  // software-fallback
+			nvme_tcp_ddp_ddgst_recalc(queue->rcv_hash, rq);
+
+		nvme_tcp_ddgst_final(queue->rcv_hash, &queue->exp_ddgst);
+		if (queue->recv_ddgst != queue->exp_ddgst) {
+			dev_err(queue->ctrl->ctrl.device,
+				"data digest error: recv %#x expected %#x\n",
+				le32_to_cpu(queue->recv_ddgst),
+				le32_to_cpu(queue->exp_ddgst));
+			return -EIO;
+		}
 	}
 
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = blk_mq_tag_to_rq(nvme_tcp_tagset(queue),
-						pdu->command_id);
-
 		nvme_tcp_end_request(rq, NVME_SC_SUCCESS);
 		queue->nr_cqe++;
 	}
@@ -1851,7 +1906,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
 
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_unoffload_socket(queue);
 }
 
-- 
2.24.1

