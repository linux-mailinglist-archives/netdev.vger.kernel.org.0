Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEF13D2281
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhGVKZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:56 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:45665
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231787AbhGVKZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnhQ9i5QlvfeWrnDKX7QOf+blAaSZlmFHZWsg/yx9MhqD2DBeoXHC97XGS4ie4ENKqc10t/ALd0izlW4dQgNrnjFxlkas97dd2Duo631nBRCCB031mGqbAD7CcrI38cOrgZhW8AviWHhhvVzcAU8xcM7WbsEFm2cCc4uZx9JMW9BoqxJ9WNRk+yad0E+myQL5jBCEiE1jAfzYbKrAzWdE9UR+jOkUXnC0afOs5uSAP668klH7B/Sl4+wMmP6WIa+z6r6L50KIQcxsiuDUaU8JvQ2VSkDth/MIToENvpXL5aJRJUuj3w2NdinJMC8XT/67VkMDGbAtPOdVumPbSwHEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DXfAQaODcu21Hc+bFAT+d5pV1pV6/PALQOiipDJy6k=;
 b=iKRhk+x891SZTY/DbvzeeOpVe9j6kAJ3CkrHkm0kFkW2tEldUPtcCmfc4KfSI08VCjwCcFCTbjZ14HFabePa674dMiOEVvl6MuIjX0wHEj9Khxh4tBOQULPl86qAYQmEZZ7N3tVQgju4mtxPExebedNSLkpeO6ngi4TuktBD67YCAXsvxWKAEkIar62eFnP39gsMI2AcpBdSlSK7qR6FJIcDJ2ChY3kmjQy66t3UwOlBeGLjnID13NHxRNDGPzCXudAmuC49G7m7Z1+MmFzULxUEVF3Vo76hkhcuwPnBJ19TAiFqn/25USCViuzxt0Bh3fOLZQuaS75cHKjtCtU0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DXfAQaODcu21Hc+bFAT+d5pV1pV6/PALQOiipDJy6k=;
 b=L9kuNVVXWEjP0mGJD0UuHK+DNFdgWXJuI3b9gaLbTaxkjlCGF/Bm/Hg7o4L/2hGsYz+2f4IwuCwx3LYMZsLG9PHR3hRE2kr1X+oxlPM9CfYiLOZYfFCbfvPBJqWhVPa9juh3C3FiJvzBGhRx1VxCviHwM6bqdFEU9pj4Vg3YSQCmmZIJ+EAdqGD/i30eM92Qp8g6CehBCd8dh1Aner1fXzPjIHfObPAncvSYGcR/hAHXDFqYHu7H2UTzwr+a9QlVmecu8vEo1AGCokL5Jkr7+ZZUzwTBtt5P42nPbxYsW6aKszNSPqEGQa3OQbu166QrnZ4+zjjPbd3AIYFhmN/yRg==
Received: from DM5PR1401CA0005.namprd14.prod.outlook.com (2603:10b6:4:4a::15)
 by MN2PR12MB3838.namprd12.prod.outlook.com (2603:10b6:208:16c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 11:06:20 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::30) by DM5PR1401CA0005.outlook.office365.com
 (2603:10b6:4:4a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:19 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 04:06:18 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:14 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 26/36] nvme-tcp: Mapping between Tx NVMEoTCP pdu and TCP sequence
Date:   Thu, 22 Jul 2021 14:03:15 +0300
Message-ID: <20210722110325.371-27-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dde884d6-4271-472c-008a-08d94d00bbe7
X-MS-TrafficTypeDiagnostic: MN2PR12MB3838:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3838A22A58325FC88478AF56BDE49@MN2PR12MB3838.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jc5hW52iz0l4l3T3bzDIE4gxLlkHcWGxF3scS0gxjgNLbPgTwoZkNWHS3LPNBNHFHwbBnn5EtS5ilkpWjWk+63nJN35l8sbKmeaTsYw6aCr98E+WOHkcBs8ScYs8Z9eYVQ0j3bhiWNc9iR095Cp7IszLfU6nSFbsNNVQzL4FDD+p6mpNs/7Q1lSRa6KPZT/p+L/XEyFPgB0YZln07wfG/FyFusxm0iFuOdLtbYkr7wvKVSpnB7WQSGwxDWZV/F3Y/pXeEzQ0iPawZCjhMxY93FVQ5QhG3ygl12dT8mEp7l5IjfvPRtSUPPcqB6pUbbsFnfEKJFtk+UL3d7rJ6YKSa+mwKNefS3QI6HfEF+8wLw/BHWGC73v+OT1gzNfQ+wZb9S5OAy2Y6Anq2/HicmY98JDnrwHfv+Lrfb2K2uSGOpwGWN9BSerUUAaWUKWoy2ETPvgV2+eWk2ihr4gOqV63WO/OxFL5w1h0tQxp3ohAeCvvLiWpe5juE1N4NAMfR4ay0G7kSmSnDV/OGXqlsRdLph1MYX/K5pHusErO6BgF+bFiQrjtEQKQVBN73xgV2b3HnyRHgh1ydAAG9uW0TCrMoPCd8mUpJmrsvxhy/KOkmbE2tW82uE/MGyQMyghuq3dpA0uDoma4KhnX/gBy86gsEh7y0Mq9YQI0Zzkh31+Cp98sPQyT60oASErfPsVtnmRsMaXCrEuMuRfSAMLzyZcNr7FWKQjG1c2yPJf2ra6zRKc=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(46966006)(36840700001)(70206006)(2906002)(70586007)(54906003)(7416002)(336012)(5660300002)(107886003)(478600001)(8676002)(110136005)(7696005)(2616005)(8936002)(426003)(4326008)(26005)(186003)(7636003)(356005)(82740400003)(86362001)(47076005)(36756003)(83380400001)(36860700001)(921005)(82310400003)(1076003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:19.6403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dde884d6-4271-472c-008a-08d94d00bbe7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3838
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

This commit maintains a mapping from TCP sequence number to NVMEoTCP pdus,
for DDGST tx offload using the ULP_DDP API.
When send a pdu it save the req in ulp_ddp_pdu_info struct.

This mapping is used:
    1. When packet is retransmitted, If this packet contain NVMEoTCP DDGST,
       The NIC might needs all the pdu again for computing the DDGST.
    2. If packet is offloaded but will not go to the offloaded netdev,
       Then SW will need to be able to fallback and compute the DDGST.

Add founction nvme_tcp_ddgest_fallback(pdu_info):
        caclulate the data digest for ulp_ddp_pdu_info
	(requested by the netdev).

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 drivers/nvme/host/tcp.c | 93 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index b2a4316eddce..e030d1baa6bb 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -154,6 +154,55 @@ static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
 static int nvme_tcp_try_send(struct nvme_tcp_queue *queue);
 
+#ifdef CONFIG_ULP_DDP
+static int nvme_tcp_map_pdu_info(struct nvme_tcp_queue *queue,
+				  size_t sent_size,
+				  u32 pdu_len, u32 data_len)
+{
+	u32 start_seq = tcp_sk(queue->sock->sk)->write_seq - sent_size;
+	struct nvme_tcp_request *req = queue->request;
+	struct request *rq = blk_mq_rq_from_pdu(req);
+
+	return ulp_ddp_map_pdu_info(queue->sock->sk, start_seq, req->pdu,
+				    pdu_len, data_len, rq);
+}
+
+static void nvme_tcp_close_pdu_info(struct nvme_tcp_queue *queue)
+{
+	if (queue->data_digest &&
+	    test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags))
+		ulp_ddp_close_pdu_info(queue->sock->sk);
+}
+
+bool nvme_tcp_need_map(struct nvme_tcp_queue *queue)
+{
+	return queue->data_digest &&
+		test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags)
+		&& queue->sock && queue->sock->sk
+		&& ulp_ddp_need_map(queue->sock->sk);
+
+}
+#else
+
+static int nvme_tcp_map_pdu_info(struct nvme_tcp_queue *queue,
+				  size_t sent_size,
+				  u32 pdu_len, u32 data_len)
+{
+	return 0;
+}
+
+static void nvme_tcp_close_pdu_info(struct nvme_tcp_queue *queue)
+{
+}
+
+bool nvme_tcp_need_map(struct nvme_tcp_queue *queue)
+{
+	return false;
+}
+#endif
+
+
+
 static inline struct nvme_tcp_ctrl *to_tcp_ctrl(struct nvme_ctrl *ctrl)
 {
 	return container_of(ctrl, struct nvme_tcp_ctrl, ctrl);
@@ -285,11 +334,13 @@ static void nvme_tcp_ddp_ddgst_recalc(struct ahash_request *hash,
 
 #ifdef CONFIG_ULP_DDP
 
+void nvme_tcp_ddp_ddgst_fallback(struct ulp_ddp_pdu_info *pdu_info);
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
 static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
 static const struct ulp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
 	.resync_request		= nvme_tcp_resync_request,
 	.ddp_teardown_done	= nvme_tcp_ddp_teardown_done,
+	.ddp_ddgst_fallback	= nvme_tcp_ddp_ddgst_fallback,
 };
 
 static int nvme_tcp_teardown_ddp(struct nvme_tcp_queue *queue,
@@ -371,6 +422,12 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
 	if (netdev->features & NETIF_F_HW_ULP_DDP) {
+		if (ulp_ddp_init_tx_offload(queue->sock->sk)) {
+			netdev->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
+			dev_put(netdev);
+			return -ENOMEM;
+		}
+
 		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
 		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 		set_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags);
@@ -392,6 +449,9 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 	clear_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags);
 
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags))
+		ulp_ddp_release_tx_offload(queue->sock->sk);
+
 	netdev->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = NULL;
@@ -1269,6 +1329,19 @@ static void nvme_tcp_fail_request(struct nvme_tcp_request *req)
 	nvme_tcp_end_request(blk_mq_rq_from_pdu(req), NVME_SC_HOST_PATH_ERROR);
 }
 
+#ifdef CONFIG_ULP_DDP
+void nvme_tcp_ddp_ddgst_fallback(struct ulp_ddp_pdu_info *pdu_info)
+{
+	struct request *rq = pdu_info->req;
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+	struct nvme_tcp_queue *queue = req->queue;
+
+	nvme_tcp_ddp_ddgst_recalc(queue->snd_hash, rq);
+	nvme_tcp_ddgst_final(queue->snd_hash, &pdu_info->ddgst);
+}
+
+#endif
+
 static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
@@ -1333,7 +1406,8 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	int len = sizeof(*pdu) + hdgst - req->offset;
 	struct request *rq = blk_mq_rq_from_pdu(req);
 	int flags = MSG_DONTWAIT;
-	int ret;
+	int ret, check;
+	u32 data_len;
 
 	if (test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags) && queue->data_digest)
 		flags |= MSG_DDP_CRC;
@@ -1353,6 +1427,13 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	if (unlikely(ret <= 0))
 		return ret;
 
+	if (nvme_tcp_need_map(queue)) {
+		data_len = inline_data ? req->data_len : 0;
+		check = nvme_tcp_map_pdu_info(queue, ret, len, data_len);
+		if (unlikely(check))
+			return check;
+	}
+
 	len -= ret;
 	if (!len) {
 		if (inline_data) {
@@ -1360,6 +1441,7 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 			if (queue->data_digest)
 				crypto_ahash_init(queue->snd_hash);
 		} else {
+			nvme_tcp_close_pdu_info(queue);
 			nvme_tcp_done_send_req(queue);
 		}
 		return 1;
@@ -1376,7 +1458,7 @@ static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
 	struct nvme_tcp_data_pdu *pdu = req->pdu;
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	int len = sizeof(*pdu) - req->offset + hdgst;
-	int ret;
+	int ret, check;
 
 	if (test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags) && queue->data_digest)
 		flags |= MSG_DDP_CRC;
@@ -1389,6 +1471,12 @@ static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
 	if (unlikely(ret <= 0))
 		return ret;
 
+	if (nvme_tcp_need_map(queue)) {
+		check = nvme_tcp_map_pdu_info(queue, ret, len, req->data_len);
+		if (unlikely(check))
+			return check;
+	}
+
 	len -= ret;
 	if (!len) {
 		req->state = NVME_TCP_SEND_DATA;
@@ -1424,6 +1512,7 @@ static int nvme_tcp_try_send_ddgst(struct nvme_tcp_request *req)
 		return ret;
 
 	if (req->offset + ret == NVME_TCP_DIGEST_LENGTH) {
+		nvme_tcp_close_pdu_info(queue);
 		nvme_tcp_done_send_req(queue);
 		return 1;
 	}
-- 
2.24.1

