Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C7B3D2280
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhGVKZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:55 -0400
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:64672
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231648AbhGVKZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoUSrgSvotWqlY2n/pHnis2GKVIdKckmWB9m6aoA4p7U2v65WokUI0+cuEXc9fbQDMtx+VCkQgCodS0e+h78lU4WoeUrPw8eBnYl7b3NxjYfhoHxuW9IM56gWNsbYEm7I5Q4+3BMnXavOwTfdgxAluJfHkrGzKzgb62xbP8HdSxPYAOJ0G7d8iBLJJPuSveipPAKqFMsPAmrwq5lozuU/up6vwZ65G75+Zzydi5w7sfeRm6VgoVAzTIGxbMhtkoBUmS75A5a0ZS3z3GkmxdPNXpFNdzGnp/LFy9t+jHCi5F/gEz6OAJkqcloe8OGmbRCkh+BUdOklC0UzE9ctU3Aeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vg9NDsMpXNT2WtSCE/G2+6uynKnGET3ieyP1VjSOwI=;
 b=bF6bbnbC65AJJwcjsyoqJArgBPF5/BjtwAnX6deJtAqu6k64nOSsYcPvLQb27oSlg72J4P/fLMVtz549nasjEXHWXA+HINFxHLtY14S/M6RJgOEWWNsA6e8cUPPq7Wm+ay2G1FVDc0gCwAdCXP8hXcPKfCoLdk3Ckj7zY1fspCN4GRGJYdKMjUSM996QG299D6DC9b8SDbv3Dqb9OicXkFitZYiQZb8eJi/5xVb3VFfjiQkIFLqdAvtreDOcxGKF1nZah1eiZVsFhJ4/jsPGhM9ztfsO4WJt0oG4dPOuf0iR/khVEYIdrz/F5cjQpgsUZ9INT2taC4mv+kZn1l/lQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vg9NDsMpXNT2WtSCE/G2+6uynKnGET3ieyP1VjSOwI=;
 b=bm/Kg9CN3OIMvgNxPn6+KxWNns7wuwsgGcJO0odBM28ONLMf3Aib9WiWUvGzUueV7t2yYimeOELy2fyJT/3fXODz7OyzgHA6rC4IFVjtT9jqYrpyIkP0H8pEAk0o3w2ai+STFKSs7QD7hMKMpwRB3zQzy7bn4eeIOEjNCLlY8csMI7CrfBpVrCUmHdL61USMHY3LuDI1jMdMPolDs8JgfoDa2EWWYjhqe0Qq+LXnGpKZ+Q01bknJP9d8k0asor8+x0vgqKLOXJH8+v6UwV01y7oiMuoicOzIVt6O0cc2ba0luq0/LOe5Zpo/qQcdJQ3+NdISVCX4/tNUYJL45gOrug==
Received: from MW4PR04CA0265.namprd04.prod.outlook.com (2603:10b6:303:88::30)
 by SN6PR12MB2750.namprd12.prod.outlook.com (2603:10b6:805:77::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 11:06:14 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::57) by MW4PR04CA0265.outlook.office365.com
 (2603:10b6:303:88::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:06:14 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:06:14 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:09 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 25/36] nvme-tcp: TX DDGST offload
Date:   Thu, 22 Jul 2021 14:03:14 +0300
Message-ID: <20210722110325.371-26-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ad55c43-9e0a-4a43-1da6-08d94d00b8de
X-MS-TrafficTypeDiagnostic: SN6PR12MB2750:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2750C6FAD2FD915EC7F346E4BDE49@SN6PR12MB2750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:256;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g37DHSJKeP+/cMb63iyVuMHGgJhEH9Vy0riBvj563ua8p+rHiFgGiRJePKK/bRNaIxsKFwJ+vnHNGymYZDPNQFPriD+0UwnH9Kt21fOZdo51qHw7vCFSqn0oCvgvrnxXxfQIOFZ6G5kkHi/ldaUN6kOFeBaVPK+UbWwnVo4KlUSHgIxTBKPtuDWqL4bCYXrQMMD2IvyifJQl+Q1mVEfZvH9NNMy3YOshxvf+KoY/0bvjU6DMNmQ23CJWrR88iilxsgfcFYN0DUVh0sWso7Z7i7xYRieQTWpV64Df/oL9DPFluF66y6YwmMHPNsMmxVKrpB94k4MryrH4sJ+3yoY3QvhQGiMLxU3PCS6zfuArxtQMu1AwwItobjjrzvta5zRviko2cOFbOwI0WLlWyVaIEJH7OpB3v4LgIc3szzpBTbsEB2FW17mIavfc9rZbSqB3PALMB368No7AQLkY5fQEQFc+EMRKhANlm5AbhVt5gTPbQbwOEhRr5THmSz0HppkgTkNs/2Z/c1q9eWzMNc7TqIFznQ/x6uN/qp37SXmlUnyd9cl5SPCDElMogYWAww3j/bkGAKjFURbEKucamZjvrR7J1jDAZseqEbSZlj/VswIYT3QcSTmfqLbZsJS+58dbIRB/QdN74DykNUqamEFwZkcOWs8+JFnc/iP8Gjmwhn8XloOdI8fy2P24+bFww4pVu25Ec//39DIzlAdFQmjGIsDPg1yIsxAbT94np8OXwpM=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966006)(36840700001)(8676002)(4326008)(356005)(110136005)(82310400003)(186003)(70206006)(7636003)(1076003)(8936002)(107886003)(6666004)(2616005)(70586007)(921005)(5660300002)(36906005)(36860700001)(336012)(86362001)(83380400001)(54906003)(26005)(36756003)(82740400003)(47076005)(7696005)(316002)(2906002)(426003)(478600001)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:06:14.5479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad55c43-9e0a-4a43-1da6-08d94d00b8de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2750
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

This patch add support for TX DDGST offload.

Enable tx side of DDGST offload when supported.

if supported, NVMEoTCP will:
1. Stop compute the DDGST on transmitted pdus.
2. send dummy digest (only zeros).

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 drivers/nvme/host/tcp.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index b338cd2d9f65..b2a4316eddce 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -70,6 +70,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_POLLING	= 2,
 	NVME_TCP_Q_OFF_DDP	= 3,
 	NVME_TCP_Q_OFF_DDGST_RX = 4,
+	NVME_TCP_Q_OFF_DDGST_TX = 5,
 };
 
 enum nvme_tcp_recv_state {
@@ -372,6 +373,7 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	if (netdev->features & NETIF_F_HW_ULP_DDP) {
 		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
 		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
+		set_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags);
 	}
 
 	return ret;
@@ -388,6 +390,7 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 
 	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
 	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
+	clear_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags);
 
 	netdev->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
 
@@ -1269,6 +1272,7 @@ static void nvme_tcp_fail_request(struct nvme_tcp_request *req)
 static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 {
 	struct nvme_tcp_queue *queue = req->queue;
+	bool is_offload = test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags);
 
 	while (true) {
 		struct page *page = nvme_tcp_req_cur_page(req);
@@ -1277,6 +1281,9 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 		bool last = nvme_tcp_pdu_last_send(req, len);
 		int ret, flags = MSG_DONTWAIT;
 
+		if (is_offload && queue->data_digest)
+			flags |= MSG_DDP_CRC;
+
 		if (last && !queue->data_digest && !nvme_tcp_queue_more(queue))
 			flags |= MSG_EOR;
 		else
@@ -1292,15 +1299,19 @@ static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)
 		if (ret <= 0)
 			return ret;
 
-		if (queue->data_digest)
+		if (queue->data_digest && !is_offload)
 			nvme_tcp_ddgst_update(queue->snd_hash, page,
 					offset, ret);
 
 		/* fully successful last write*/
 		if (last && ret == len) {
 			if (queue->data_digest) {
-				nvme_tcp_ddgst_final(queue->snd_hash,
-					&req->ddgst);
+				if (!is_offload)
+					nvme_tcp_ddgst_final(queue->snd_hash,
+						&req->ddgst);
+				else
+					req->ddgst = 0;
+
 				req->state = NVME_TCP_SEND_DDGST;
 				req->offset = 0;
 			} else {
@@ -1324,6 +1335,9 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 	int flags = MSG_DONTWAIT;
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags) && queue->data_digest)
+		flags |= MSG_DDP_CRC;
+
 	if (inline_data || nvme_tcp_queue_more(queue))
 		flags |= MSG_MORE | MSG_SENDPAGE_NOTLAST;
 	else
@@ -1357,18 +1371,21 @@ static int nvme_tcp_try_send_cmd_pdu(struct nvme_tcp_request *req)
 
 static int nvme_tcp_try_send_data_pdu(struct nvme_tcp_request *req)
 {
+	int flags = MSG_DONTWAIT | MSG_MORE | MSG_SENDPAGE_NOTLAST;
 	struct nvme_tcp_queue *queue = req->queue;
 	struct nvme_tcp_data_pdu *pdu = req->pdu;
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	int len = sizeof(*pdu) - req->offset + hdgst;
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags) && queue->data_digest)
+		flags |= MSG_DDP_CRC;
+
 	if (queue->hdr_digest && !req->offset)
 		nvme_tcp_hdgst(queue->snd_hash, pdu, sizeof(*pdu));
 
 	ret = kernel_sendpage(queue->sock, virt_to_page(pdu),
-			offset_in_page(pdu) + req->offset, len,
-			MSG_DONTWAIT | MSG_MORE | MSG_SENDPAGE_NOTLAST);
+			offset_in_page(pdu) + req->offset, len, flags);
 	if (unlikely(ret <= 0))
 		return ret;
 
@@ -1399,6 +1416,9 @@ static int nvme_tcp_try_send_ddgst(struct nvme_tcp_request *req)
 	else
 		msg.msg_flags |= MSG_EOR;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags))
+		msg.msg_flags |= MSG_DDP_CRC;
+
 	ret = kernel_sendmsg(queue->sock, &msg, &iov, 1, iov.iov_len);
 	if (unlikely(ret <= 0))
 		return ret;
@@ -1908,7 +1928,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	cancel_work_sync(&queue->io_work);
 
 	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
-	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_TX, &queue->flags))
 		nvme_tcp_unoffload_socket(queue);
 }
 
-- 
2.24.1

