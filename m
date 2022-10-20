Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C874605C19
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiJTKU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbiJTKTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:19:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3141DF20
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReeOfiDwagDXkW3Acs26z0gG+50XdyTB/8HtD5ekTxIyImF2XP8f2anzqSSl+1ggAhHW7BaqLExS/78Jo8u4fdmSRxoP1+/clQnj6+7XyaFk1+7Tf0YiZxZZdH2MRK3I2HYGthN91prRnwmxDqkxUO4vFzdu+nfQqJ3KXvZkDXcCjbIm4JjqQ3uD/cSgr6DoqJtSxXj6ta0xjWGweHsgr0xi3x4mGsQZFh7VsCa8VfAXdwJcp6AOkkKPzC5kjNdf1znZX7HfY5EJE1s8FEXtQw6JQBwZWs0drYANeKKukGhAhjqFQbD2/v/QXpnzg1mJTPsptZxv5Cgyr3quIrcDyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOSqi5re3h0OUvmleHocILtcpMiASTI5glXPVqiYqHU=;
 b=hc6suvlO3kZSihLkchuWlWKdbwnhsrHJjfKcmRktb5KSbohmm3Yjvi1JZ85wUFn5BFKz39drsRGA6j4C0ZpvbRPtFrqbA1j27v2l1HKZovuvpE1GWSiZZZsetF3petZfTOGr54uS5c7F9TAB6GwEpFzaFKBX8oOupL2tT4zw0gaFyO6JZfpFCmTcGr5xvboyoeWaaDsMos+ya3fbGrZBPrcEHF/2ugGtc54FI2KWlPew7t2g3rEXp/9IqOJ1HWpOo5FjcWlMo/uTkfilxbW3PDIhAYi2sGtuwIK06hvc1S1mmtkvYJ7c6BDAr5xHRQzJKEN32amHVvpHi/nivIj6ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOSqi5re3h0OUvmleHocILtcpMiASTI5glXPVqiYqHU=;
 b=n5h4oBro3KEO+ddwMWp3eSuJs7NsWhFV0RUEfDk+6HEmBypAulQV9vfcIUgDbKLf/WUYFZkwRyRFJ/ibag9P4UMQ/v0KWDuMmR1mh8BURHcgSd+hUOP6UMp8wsCvxkynu53y2V/BqxDyHB76PdM8GTnx/MnIyd+QsVXPvqTBoVhjHfrZ8ZhIK3bCWGiWBh2tubfrqKbdQDAzkzhxbPvHE/k7I6653RKM43+a+Hfcnozv1qA/M827qCrq1YP8wIjfzQ6ZT8rvJU9CKJ3FjM3oEB1NC4YM/RhqZeBJwwhbl/xI8erJ2X7t1iJvsebtfDT7/w1MIfD/eOwColK23WHhFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:19:26 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:19:26 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 07/23] nvme-tcp: RX DDGST offload
Date:   Thu, 20 Oct 2022 13:18:22 +0300
Message-Id: <20221020101838.2712846-8-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0614.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::15) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 02fdc38c-0a42-4169-99f2-08dab28490d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JugFOtBsYEySwICeXhy7pMbnUCn1RMcs1kZvfe93lg/My9njDs+Q+kElmJc9bD+4KGvV+vhDHPYepJT5yd5zpvwYHngLCMl4vM3hvBAepB0G+rW9l33XK4raZ9wTwNwibvzUWPMB5D8jxWDDpwAofUBlIzZXb1kSq5Y/Oj+wddCrGEeaIwfCvlECHEk2iXjfybLFiAJe9z2tVo9X93DN+Xu0wHS4lK9L5elvJM1MlBtz4D034fbn3LI/+l0Ak9+xTt5/be5EOmJF1wBMfNWol5/EZZKlt+oSqnmLW7o8sT0hWgGWWwkt/JxSCPC39wU1LmHpqrxdyCAeZM60NtaHWbZlIcU/V1D+rwwDFKOmTrwnmRYmXbkUMCQ1osAHAtBRwqqK1MO5P8jDrL6mlMBkztZ4rCcaOR7z1CpAdKYZjFwSXLxQq1n7bM2pk/touYBRunj03GYEKFF87uYlfqSJIC2D+BXhBxQkkLw+1DsuDdH+NgaWbG4TLvhTWh5ajHunMC4kmGYReOIDZXb66qo5nhIC9FlZWqqg0oUwsij3LMjHCy+CAXOGgEbwokmuythjUqS2iAAaBmc5hduoHUX0YEYzEGpHqOY6EN8j5ytf11zoxUyxM7I/EsBS+GocSNb5msw7jFdvne/NlxgHBSsoCgKvWXyYDcYKC15wcT80l2zLkwUHekXKBY9gkC/J7GZa+ZE81TZ5K+x03RydV3SrmNV2aSRYxGYWtg74TGUC+34HQ7yz7fBB1T4sz+1qefdc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihu0CnTBnndwmnFsqW6j5Fc7uCBFAP00KvOEmgUJDNLxRpTIcSbxle5hYNRN?=
 =?us-ascii?Q?Oa0q+mtom0T15CzqPJzVVRXUzDik1H6hkrVFqnlXmTEvwjPrnVq195MBxtn9?=
 =?us-ascii?Q?eFCnE0Tta6JtwzOqK/cjEM7E6jc/Ulc2DIVLMACxwUuOvFoDdpAdmozEoK4R?=
 =?us-ascii?Q?7MXcn7tEXmypw+WQEr6lNJzc9barc+799kkzKUKlOvkOyVbvpBL3yh0v0LOG?=
 =?us-ascii?Q?Xu++QzXdnoEpyAcOhIP/SpwHqhK8V/6n9d1mXVKxgFpaNybYz2j03rjoyxXd?=
 =?us-ascii?Q?k8XWxw7JEHX6oo7JspF6fQ7DdHQtnvQQLGS0CSt9QTpAl3En3ayvkfq7WfM6?=
 =?us-ascii?Q?+1nfM852JHjNuUa/VHh9GMLFv2FSxx7y4wiswHTkzQyzacCrXrBPuyEA8y1j?=
 =?us-ascii?Q?6nXU19gj4GbpTrycU/QpHbOqtiK9df0irzrVZ1LeycExbg/lWbTGZTIettmZ?=
 =?us-ascii?Q?jV6+I3FGZpJuoFtR1XyCktqfKnnON3AMpSHAmXC8i00M66pwR7s7v4Rpx1vO?=
 =?us-ascii?Q?o+vwDzVJjlmB2e6fm2MKpBQrf5k/9LwpW9M7PQcwFqoxYPT4tK7aY9luAsf9?=
 =?us-ascii?Q?/NE1stJZ1FgNC9Z/Y7ey907eagkSDd3Z0QE9941pqX4u9jR/s7YZeXon+wKA?=
 =?us-ascii?Q?DBHPuxu89jzWnvYcxfmdJZDsRo9O2xSMibryU/RIhhzWDjRgYOfSWSACwyPG?=
 =?us-ascii?Q?fzAzr4a5CKUzYYlCHhU70pRd8/Fa/skofC43tkMLQ3H7OWaskWAYghAgBQ8R?=
 =?us-ascii?Q?kvxxLncwlApPo269QCcKENCiKzAroHkFUtFzUBGH48VdmBb29CUcML3NB6oE?=
 =?us-ascii?Q?dmls43Uw1kpEJLLRwqyeq+yBcIJqKMf4dFulwUTv7xy6qQSFWY2Se8fxCxBd?=
 =?us-ascii?Q?E/19AZmbJfuFp80AZ2WsGNG+7l/M5E7tumJbuHr+89lNk0VbmQlr4kESxnQi?=
 =?us-ascii?Q?0d//Yhh1OaTiXzd0LmHzGZ12xig10kNlRxX1WbqHQBQbMnMspSYjjl2wo/ka?=
 =?us-ascii?Q?sniN9Lv3ybLFudeHF74jFeMdPFLmgWxqgJFVBBt3mXhSuyurC3Di1sFYSTEk?=
 =?us-ascii?Q?98Y8gcuBliO/zsugxcdnpM6gafNviWcEHlUfI9hDd5sm/lLKzIB5/O6xbaHw?=
 =?us-ascii?Q?6Wh5o4jMUAesc6LUbr+8f8+TdZuth5OBev3/vn+QKihb2r891WUM3HMpG7JZ?=
 =?us-ascii?Q?sSnCLqMOhC10j0K2mwTuuMQqOduw46ks6vsJDiJu1Q3MkMAEYkAbOUT0Dl+U?=
 =?us-ascii?Q?hx+jKFh4BC8/wnCa2a/G+CmiQ/Ao13L3l4CDisPKsW7Kn+sHZWe3x6nKKunp?=
 =?us-ascii?Q?c9RsegwYksjRYcHQPKXGZrBFQlOE/XhTmBfDEHPqxpPfVx/BXg2P7VPOpuNw?=
 =?us-ascii?Q?wP+F0sgkXF1jLR8oqTPK2hzYqXgkRTdQnGTUIpRHCwYvbaiSgvbKxkNQZl4a?=
 =?us-ascii?Q?bRdp8oBDjPJoRGim9PyXqcZwCc+6rYUxtJYYsQ9JYz7YDcr/LsBmoXVE2/o1?=
 =?us-ascii?Q?5OgK5PmiDHWSgXM34ThFBc1nPSBTUqFv2vAfS8gdkp+ZIyQHKKJBBNo9gtu1?=
 =?us-ascii?Q?SbghUs29etk5wLtfwrPGRfrJU20hmXX2mAuGNWhg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fdc38c-0a42-4169-99f2-08dab28490d4
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:19:26.2250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iC6UULfknA0v1oV4AJUhubrd8D7MKsmbyf7RcnQ5FGobp6wHVoCPpYdqu0FoI+uY+eENZjfKkjxrs20GqzKGGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

Enable rx side of DDGST offload when supported.

At the end of the capsule, check if all the skb bits are on, and if not
recalculate the DDGST in SW and check it.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 113 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 104 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 0fe4ff9e098b..76aed532186c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -115,6 +115,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
 	NVME_TCP_Q_OFF_DDP	= 3,
+	NVME_TCP_Q_OFF_DDGST_RX = 4,
 };
 
 enum nvme_tcp_recv_state {
@@ -142,6 +143,9 @@ struct nvme_tcp_queue {
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
 
+#ifdef CONFIG_ULP_DDP
+	bool			ddp_ddgst_valid;
+
 	/*
 	 * HW can request a tcp seq num to continue
 	 * offload in case of resync.
@@ -150,6 +154,7 @@ struct nvme_tcp_queue {
 	 *   is pending (ULP_DDP_RESYNC_PENDING).
 	 */
 	atomic64_t		resync_req;
+#endif
 
 	/* send state */
 	struct nvme_tcp_request *request;
@@ -308,6 +313,18 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 	return true;
 }
 
+static inline bool nvme_tcp_ddp_ddgst_ok(struct nvme_tcp_queue *queue)
+{
+	return queue->ddp_ddgst_valid;
+}
+
+static inline void nvme_tcp_ddp_ddgst_update(struct nvme_tcp_queue *queue,
+					     struct sk_buff *skb)
+{
+	if (queue->ddp_ddgst_valid)
+		queue->ddp_ddgst_valid = IS_ULP_CRC(skb);
+}
+
 static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
 {
 	int ret;
@@ -322,6 +339,38 @@ static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
 	return 0;
 }
 
+static void nvme_tcp_ddp_ddgst_recalc(struct ahash_request *hash,
+				      struct request *rq,
+				      __le32 *ddgst)
+{
+	struct nvme_tcp_request *req;
+
+	if (!rq)
+		return;
+
+	req = blk_mq_rq_to_pdu(rq);
+
+	if (!req->offloaded) {
+		/* if we have DDGST_RX offload without DDP the request
+		 * wasn't mapped, so we need to map it here
+		 */
+		if (nvme_tcp_req_map_sg(req, rq))
+			return;
+	}
+
+	req->ddp.sg_table.sgl = req->ddp.first_sgl;
+	ahash_request_set_crypt(hash, req->ddp.sg_table.sgl, (u8 *)ddgst,
+				req->data_len);
+	crypto_ahash_digest(hash);
+
+	if (!req->offloaded) {
+		/* without DDP, ddp_teardown() won't be called, so
+		 * free the table here
+		 */
+		sg_free_table_chained(&req->ddp.sg_table, SG_CHUNK_SIZE);
+	}
+}
+
 static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags);
 static void nvme_tcp_ddp_teardown_done(void *ddp_ctx);
 static const struct ulp_ddp_ulp_ops nvme_tcp_ddp_ulp_ops = {
@@ -389,7 +438,8 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	if (!nvme_tcp_ddp_query_limits(netdev, &limits))
 		return 0;
 
-	if (!(limits.lmt.offload_capabilities & ULP_DDP_C_NVME_TCP))
+	if (!(limits.lmt.offload_capabilities &
+	      (ULP_DDP_C_NVME_TCP|ULP_DDP_C_NVME_TCP_DDGST_RX)))
 		return 0;
 
 	config.cfg.type		= ULP_DDP_NVME;
@@ -417,7 +467,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
-	set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (limits.lmt.offload_capabilities & ULP_DDP_C_NVME_TCP)
+		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (limits.lmt.offload_capabilities & ULP_DDP_C_NVME_TCP_DDGST_RX)
+		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 	return 0;
 }
 
@@ -431,6 +484,7 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 
 	netdev->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
 
@@ -518,6 +572,20 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
 #else
 
+static inline bool nvme_tcp_ddp_ddgst_ok(struct nvme_tcp_queue *queue)
+{
+	return true;
+}
+
+static inline void nvme_tcp_ddp_ddgst_update(struct nvme_tcp_queue *queue,
+					     struct sk_buff *skb)
+{}
+
+static void nvme_tcp_ddp_ddgst_recalc(struct ahash_request *hash,
+				      struct request *rq,
+				      __le32 *ddgst)
+{}
+
 static int nvme_tcp_setup_ddp(struct nvme_tcp_queue *queue, u16 command_id,
 			      struct request *rq)
 {
@@ -801,6 +869,9 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
 	queue->pdu_offset = 0;
 	queue->data_remaining = -1;
 	queue->ddgst_remaining = 0;
+#ifdef CONFIG_ULP_DDP
+	queue->ddp_ddgst_valid = true;
+#endif
 }
 
 static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
@@ -1003,7 +1074,8 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_resync_response(queue, skb, *offset);
 
 	ret = skb_copy_bits(skb, *offset,
@@ -1066,6 +1138,10 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		nvme_cid_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
+	if (queue->data_digest &&
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
+
 	while (true) {
 		int recv_len, ret;
 
@@ -1094,7 +1170,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
+		if (queue->data_digest &&
+		    !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
 				&req->iter, recv_len, queue->rcv_hash);
 		else
@@ -1136,8 +1213,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	char *ddgst = (char *)&queue->recv_ddgst;
 	size_t recv_len = min_t(size_t, *len, queue->ddgst_remaining);
 	off_t off = NVME_TCP_DIGEST_LENGTH - queue->ddgst_remaining;
+	struct request *rq;
 	int ret;
 
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
 	ret = skb_copy_bits(skb, *offset, &ddgst[off], recv_len);
 	if (unlikely(ret))
 		return ret;
@@ -1148,9 +1228,24 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 	if (queue->ddgst_remaining)
 		return 0;
 
+	rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
+			    pdu->command_id);
+
+	if (test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags)) {
+		/*
+		 * If HW successfully offloaded the digest
+		 * verification, we can skip it
+		 */
+		if (nvme_tcp_ddp_ddgst_ok(queue))
+			goto out;
+		/*
+		 * Otherwise we have to recalculate and verify the
+		 * digest with the software-fallback
+		 */
+		nvme_tcp_ddp_ddgst_recalc(queue->rcv_hash, rq, &queue->exp_ddgst);
+	}
+
 	if (queue->recv_ddgst != queue->exp_ddgst) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		req->status = cpu_to_le16(NVME_SC_DATA_XFER_ERROR);
@@ -1161,9 +1256,8 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 			le32_to_cpu(queue->exp_ddgst));
 	}
 
+out:
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
@@ -1962,7 +2056,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_unoffload_socket(queue);
 }
 
-- 
2.31.1

