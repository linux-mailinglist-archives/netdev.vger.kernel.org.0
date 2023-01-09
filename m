Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D108662722
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237046AbjAINdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbjAINca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:32:30 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB091E3E0
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:32:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bep8HeouC3LDKRQzp1tEGzyare3ZOw9amCSGOlOx98hV0/TGvaLVx2zzibVz95YeAWy6X7FRo546nWGksj/pm/tRTLI/DQ8AopigklUanJlaVCt/KQ4SQjvweAL+G7k66ipmZCMLJxqfL7IBO4Hmx/4V5gGN1uIB/wqarmGBkUlYIX6vVPJmiXqnb2sbgyirNaIIwr2PmlCoq6BGcznhrkaeujF2Xj1a1VYRPj98TpQmQcHWwB6z9GlYK7wgN/bAqY5l3+Q4Cdum5SuhhcjdDBEo2bAAVqJyw/PBDsygId1kmuBJcq2a4oJ8YXa4uHzWAhvMz/ewpMwYstfhAkfZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lepBZ7M1caxjFTO54h8rHOvePvQXdmCfS983givpSGQ=;
 b=YagCOOv/O3aKZpZlnY5xBkxhbVLFUoWa/nL/06QUahweS5BRlWG6c1MgUaneYnbFHkcFjby8mgCBRDvIZKNK+MZe3PuW2Ti67M91pcM2wTLxIdCzypcyH/sqxBUjhG8UVRrW1NuQPO2CD6y3qUrRzmHzBNUX1vu65J7tptmdFMeZqYVAUvKtmBa72o8KLyXcq2fG74RcStZ7G5Dr8oqya08GtzZwK77BmL5LMDbsujlUxqyCkJLRQ7RyMbvZhhmb4ZN1FSGvbZJdTWVfiOj6ip8cOklPRHdGaRKWB6TuD5iXXFgveYidtZDN1Vfjw2LS7rkjeDftP1hHFqotrDMttQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lepBZ7M1caxjFTO54h8rHOvePvQXdmCfS983givpSGQ=;
 b=skFTGnqgo/XzR8YtIqH5PJhb7udnHtJtrNdPuyUTlDHAGxdjAydBI537FWd55y38cay6c8KBJrwpSTm7dAcfI/FhXovGnognDxQD9Cb1qhlSKA5yBQEiJZ8lZmnZwf7ySidSA02YEJXLXjzvvoE8k6rBolnXk21+PDsu4Tpx91I9lUS087UkTFukm3/KBb6VN0NaixBRGM0bEseDjUZ6YYjUOkGUOwKCdw6iPm8ZPsuKOuQehE1w78p+EwWTPI4dLLeAQ1W7vMrBqi9Gsz6y916Ht2e2/QsRQKMiFMN7Hvq/OSDMx6J18A3uvt5PPuLMcwH7O0DNdWFnrkzF3G38zA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:32:24 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:32:24 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Yoray Zack <yorayz@nvidia.com>, Aurelien Aptel <aaptel@nvidia.com>,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 09/25] nvme-tcp: RX DDGST offload
Date:   Mon,  9 Jan 2023 15:31:00 +0200
Message-Id: <20230109133116.20801-10-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::33) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: accd3615-23cb-4505-0141-08daf245f171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 10z+sMuMKT9KRgxhZQ+j7j5EsfyirKpjzllliGEdHf599QKeyHgin2XfI0Wk9xX9YmO15x5hffhP42xiXNeX+Ic/DlyaDMYtDqFJt2KCGOybLw9pFkandPqy8h8GiuqcQnMx+VnvvRaNvT4YHg325eAs+g+93zUHBwjyH99Z+QTkNJU9AEywXSocBZHwh5yqdvJ8FemYXc0CWTNhTMOtGgiJffBStoLQGyte2MWz2b5fcSXNaTmrGoNnjXcg9KhFk26lwgc4xv792SeVua7u/8nNbib1j8TmBcNzYjc5Cfsg7morRV6uEldwyYH0+LTIwvqma7zMAI0EzaQndZTFyr9W3uSgFElrm27R576L+RFUY6zRLmhtE5VUWHBcWNRZf99rFlf+qZ/g6rdM4wSPrav5s0AInyxqu4WpRqMTc6U7QY750OajSp/N0uv2lGJ4sG2M7mcqSIRCGbCc30/XvPX0T8DkH87qPw1hKCgQZOCjObqPZ5hAAYDbVIz/ZSF5yoFSXh6oC74JpNTR/sV9JHydsV9+NtG8oefM9cA8Y8Muyh1SrLAXXein+yGgD2SrXlKRuWUqzQ5GWCIuaScFq3zTA+h8JRZF2OyJWjQ48uCmexSGT+K1Ta7mjvyrxLleh9aDIbG1NB8cps3gtGdAJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(54906003)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(6666004)(107886003)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jguHcYkR+8lZKzp23uDbwWHntNha0GQE3Fe9mBz6d9dl1G8rf+clgQhggXw7?=
 =?us-ascii?Q?RB4cd5RVnmqeG1wqY7mmLO1c+suJR3K0W1O0dcRiWUH6X1yCiy9IShxniguW?=
 =?us-ascii?Q?AtKFooufzKHX/UE8siLLGazCMM37urySrqZR8m+zxf3jR92Rkxbih9kq0Kuz?=
 =?us-ascii?Q?h3kpPVKsQ2TcHCQhkmhRqnOjYyzwk098UHIk5gsZ4BpNj4VBcgzRPNFes6VB?=
 =?us-ascii?Q?cVfJ/8egZKFxjaFAl2LJ+kvnHCxUqVraxUUQGt8paxCXVS0v1LQGbVIlSlV5?=
 =?us-ascii?Q?Vn71pD7MZ7nwvS1gLTcWGiYFxXgJM47UDT2ozLPsKgC6gVKwxGTMgQA2DWdm?=
 =?us-ascii?Q?RTJyGkdhJhvK38rQk9M2gNRXgELIHVItA2MaVmEW371K/UEca9206rD9R347?=
 =?us-ascii?Q?Virc/8sHDCC246kgGow4i5oRypU7SldxWxZQ2m+Dxe2O16cE1eP659oYEV8C?=
 =?us-ascii?Q?64MntwBiOA9UrHLY2u2xyHu71AQdhyVYvzIJ05FztrbEpz+ZRAx9IKhj8xBB?=
 =?us-ascii?Q?iEK8Y/ew79vIn9lQi1X1/j0vNGWbjjIepc7jmRrdB4y1h1YEw3dtF3C65MRI?=
 =?us-ascii?Q?v3RYQpGYO3PLOWH1b3y3Vl0T9bM98m+YFuAqKSFuAxUZZC91OYh0YbKd32CY?=
 =?us-ascii?Q?den9jdeZBZMqOJV5JFqj20efHh+spnIhacg6pg2Rru1MEU3arXYeY1pNTi2s?=
 =?us-ascii?Q?sa1XF8de85r14zdFaBZsRwyE8rIb9Y42UVtMkELvnrTa+e0f93CkLGaTDh6y?=
 =?us-ascii?Q?x1HmwPGmo7lKYMUfW5JqhmYKGjcR8iHHPjMDvNbhLtowmYYEfRQoMErR5xpb?=
 =?us-ascii?Q?pYVGU6LSQTqb4I1FHaAKdDuWwlgh8ETWXaX7QN7KZAts6We1RNJ75X5rbG9d?=
 =?us-ascii?Q?YTfcsofj9WWYFL+Hus08Q4F7t2paLFhafnCZwXcpFfySTeiNqhdeqfS+NmhC?=
 =?us-ascii?Q?wNp8sVHJGygdx5OCiWLtm/JG40o7FbEEaV5MgxO3AD9zICENLVCCa2nPItBR?=
 =?us-ascii?Q?QD5A/Th/hMpM68Kjt4KYSSKnH0mX9mzLUsBI9CAupKoGqe1OTFO/lgN5UbT0?=
 =?us-ascii?Q?t+3dBfKBDwqEtNbd8XqCj+pJjLbmWM40x1e1A78MFcmtbANGk/682QLBkijg?=
 =?us-ascii?Q?f9t57fvAi0wOqvr4FCWCnv8tWa2d7v+MiOKpDLTn608+RWLQXnM+fAkmwCsM?=
 =?us-ascii?Q?dRXfRV4ZM60mPOnmm8JQaHnB3DBLP6pK5pnLFtsC36gG4NH7VIB3VW0UL46i?=
 =?us-ascii?Q?9zwQv6H5zwFiJWjcanfV/RIMDqO2siUX1WwkUMPXYe0ooQyuutfKtMYSsG5Q?=
 =?us-ascii?Q?5Wz9cRwqpM+GGtQ3YEPDe+hXscJ52yoxaEuYk+1vyWiU+IVqjuNNcMsVzoFj?=
 =?us-ascii?Q?VOeXyVT7Y/rdtDlvIarDrlXfJKBrkdOXpaoaUiSqKVlAU0SZq8GqB3sxRjfG?=
 =?us-ascii?Q?kWTKJYYFfSXbVnncx7lkCFDqQ8lVbVCVkDENeVin1ubBKlfWyjgnkklwZiVR?=
 =?us-ascii?Q?g2obO7Sc1eUcghoZyvyPT4dL2O9E12EH6moe7ZZy/FvxsVBpibpTbdOKlnk7?=
 =?us-ascii?Q?pLT54ITWzw4L+3zTaFGaMcdLUXhWuaV1ELNhIcxJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: accd3615-23cb-4505-0141-08daf245f171
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:32:24.4507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VvjjOBzLmM7TkdFlDzD2+8tHluWpGM3byylVrPZMBF0TZNIw8l0rSkxrViSMQn2OoM3Ppwi4JLkIV+1ZZIDKlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 drivers/nvme/host/tcp.c | 138 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 124 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 718d968d94d6..4bd2b03dcf4f 100644
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
 	 * resync_req is a speculative PDU header tcp seq number (with
 	 * an additional flag at 32 lower bits) that the HW send to
@@ -151,6 +155,7 @@ struct nvme_tcp_queue {
 	 *   is pending (ULP_DDP_RESYNC_PENDING).
 	 */
 	atomic64_t		resync_req;
+#endif
 
 	/* send state */
 	struct nvme_tcp_request *request;
@@ -287,9 +292,21 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 
 #ifdef CONFIG_ULP_DDP
 
-static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
+static inline bool is_netdev_ulp_offload_active(struct net_device *netdev,
+						struct nvme_tcp_queue *queue)
 {
-	return test_bit(ULP_DDP_C_NVME_TCP_BIT, netdev->ulp_ddp_caps.active);
+	bool ddgst_offload;
+
+	if (test_bit(ULP_DDP_C_NVME_TCP_BIT, netdev->ulp_ddp_caps.active))
+		return true;
+
+	ddgst_offload = test_bit(ULP_DDP_C_NVME_TCP_DDGST_RX_BIT, netdev->ulp_ddp_caps.active);
+	if (!queue && ddgst_offload)
+		return true;
+	if (queue && queue->data_digest && ddgst_offload)
+		return true;
+
+	return false;
 }
 
 static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
@@ -297,7 +314,7 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 {
 	int ret;
 
-	if (!netdev || !is_netdev_ulp_offload_active(netdev) ||
+	if (!netdev || !is_netdev_ulp_offload_active(netdev, NULL) ||
 	    !netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_limits)
 		return false;
 
@@ -313,6 +330,18 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
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
+		queue->ddp_ddgst_valid = skb_is_ulp_crc(skb);
+}
+
 static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
 {
 	int ret;
@@ -327,6 +356,38 @@ static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
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
@@ -386,6 +447,9 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	struct net_device *netdev = queue->ctrl->offloading_netdev;
 	struct ulp_ddp_config config = {.type = ULP_DDP_NVME};
+	bool offload_ddp = test_bit(ULP_DDP_C_NVME_TCP_BIT, netdev->ulp_ddp_caps.active);
+	bool offload_ddgst_rx = test_bit(ULP_DDP_C_NVME_TCP_DDGST_RX_BIT,
+					 netdev->ulp_ddp_caps.active);
 	int ret;
 
 	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
@@ -410,7 +474,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
-	set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (offload_ddp)
+		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (queue->data_digest && offload_ddgst_rx)
+		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 	return 0;
 }
 
@@ -424,6 +491,7 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 
 	netdev->netdev_ops->ulp_ddp_ops->ulp_ddp_sk_del(netdev, queue->sock->sk);
 
@@ -511,11 +579,26 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
 #else
 
-static inline bool is_netdev_ulp_offload_active(struct net_device *netdev)
+static inline bool is_netdev_ulp_offload_active(struct net_device *netdev,
+						struct nvme_tcp_queue *queue)
 {
 	return false;
 }
 
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
@@ -797,6 +880,9 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
 	queue->pdu_offset = 0;
 	queue->data_remaining = -1;
 	queue->ddgst_remaining = 0;
+#ifdef CONFIG_ULP_DDP
+	queue->ddp_ddgst_valid = true;
+#endif
 }
 
 static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
@@ -999,7 +1085,8 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_resync_response(queue, skb, *offset);
 
 	ret = skb_copy_bits(skb, *offset,
@@ -1062,6 +1149,10 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		nvme_cid_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
+	if (queue->data_digest &&
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
+
 	while (true) {
 		int recv_len, ret;
 
@@ -1090,7 +1181,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
+		if (queue->data_digest &&
+		    !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
 				&req->iter, recv_len, queue->rcv_hash);
 		else
@@ -1132,8 +1224,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
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
@@ -1144,9 +1239,24 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
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
@@ -1157,9 +1267,8 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 			le32_to_cpu(queue->exp_ddgst));
 	}
 
+out:
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
@@ -1966,7 +2075,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_unoffload_socket(queue);
 }
 
@@ -1996,7 +2106,7 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 			goto err;
 
 		netdev = ctrl->queues[idx].ctrl->offloading_netdev;
-		if (netdev && is_netdev_ulp_offload_active(netdev)) {
+		if (netdev && is_netdev_ulp_offload_active(netdev, &ctrl->queues[idx])) {
 			ret = nvme_tcp_offload_socket(&ctrl->queues[idx]);
 			if (ret) {
 				dev_err(nctrl->device,
@@ -2015,7 +2125,7 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 			ctrl->offloading_netdev = NULL;
 			goto done;
 		}
-		if (is_netdev_ulp_offload_active(netdev))
+		if (is_netdev_ulp_offload_active(netdev, &ctrl->queues[idx]))
 			nvme_tcp_offload_limits(&ctrl->queues[idx], netdev);
 		/* release the device as no offload context is established yet. */
 		dev_put(netdev);
-- 
2.31.1

