Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EE66899B5
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjBCN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjBCN2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:28:37 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489264686
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:28:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DT+se6EtQKO1IsuwOLt5EUYdiAobAsu2qxIiEjHfe7qltNUnFv3BrAYMHF3H/a8b8IsERd6vgRpxQnC/4tHeGIrb2l798dB5TzI+8iTtOWR+ixZShTTwjUgbQqEubRWBogsXMwvqjCop/OvOghypPsqVh8CueXBYN6MflcVIFOATWwivMCXlSp+M3iDw3M9n81Mi4IbJ0sDsQ0P/x5kH3/YLFr9Gfw+SAi/kesJ38DUT1wWDj7NbIH71ON/5G7TLVZSQydjZg4CliVhn907c6nU4XLcp/uRx5AkAQYR96wnbYO0nF30dxoXRrU+tQ55vhs6KbTRhReLDF9dAiJZbhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ba2Kq7e/xGwQoLYr5mKtQYFkhXZhqoRlrhkbFD6WVwg=;
 b=aVnhiP4m0BuwSbXHcZbvJdIAvvQd2497oVAattDl0rHyUXkykDXx9pEapngXr/ib5NU+CJ2RwOQv8m/0oMcLImrOkr1TqWCmkPLqkIGuwvK9doyWL08XQwVrFk2hSj9yLYTDSBIuq0wzkO6/tnwq39PpNWx7o8wvz1GDuNmT7iTgHkT9Hhibq23w0tLyGsfpFuWt3Au2SoZPsZPTBzV6V9ojPahT7pF7HWTT5Aoj1FSRI8wctyIiTMZ8wwDyyheLOk+rdzyrTKZxvEu4JENkdOn2WrDbJD2O1+iAgOWx4O6o9E8Ckh/0XhqLf5/62ckn7XqwZ74gFKEzh6rPNSMDPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ba2Kq7e/xGwQoLYr5mKtQYFkhXZhqoRlrhkbFD6WVwg=;
 b=oHJYC+IrC4RqTwwAvO4aavRlQXCnji8zb4WqmLZR7qCDeRv4f4oPWmBTWudRMMgFhOqBlbgcElMZcm8lFjqI4zeNYCJLU4d4gjXclrBA75L/viEgJaFom6HttIWDtgxt/ck6X9mF59460b0iRMKgp2rPA/LXpm/FFAVxI+qoXYW3rMwanokean9jd79VpQgRaCoXHdfIjMpttsfcoZxAQvlpey8ESzWZQ4Q4YeNcpyNmxu+qBxBpNJ8sQC4DosEOLKzWGqqYdW+NleA/869e4+78BnWR4SA8Z2mcn0EDTTZ9ID9ZE7H3lSfkJv+ahuNUJQTxcEgsIQ6cs3UwLrzaIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:28:21 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:28:21 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 09/25] nvme-tcp: RX DDGST offload
Date:   Fri,  3 Feb 2023 15:26:49 +0200
Message-Id: <20230203132705.627232-10-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::17) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: cea5c3bc-a12e-4f99-6d93-08db05ea84ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09S4SLc5mLPSwCW/PyDtmFi+HOey/3olqFW3yisIAVoB7slTnA0ob42WxSkXqkUMnsUjnGTQNfbNj/B77BfiM1UevIq3YGmvivrWkq/VSnXxuKa0vu/O7bDwGM90sEV4xlJrchoFyWqf1K7FH9zcLBYI5Ku77A/fnYLyeagXb7pv+UT+kj9tl8kqW6SbY5fhFwyfgKgl4jZv+tSxeGxP+D/FgEUvSWaKfQOI6t+OgYChW2bQSvBgX7NvgC+ULYQ+GAXwZk+sTDNshPL7RLEsPCFAJKj4TC4Vs0qpgeOwYq8KvZOq6MZQKSq2K6RRZUKFgUfas3N3yIUDVu/YVpUzlmbKRs5WM966qjYu2p3NeLCQDWoSHVRevM3x3HaqDdfZ+oWJ4IBVMHWR5ezvTp2T7X86KjEl5VIewkkKlbh4bo8iiSa2sd+ijyvgc7MUno3mj1wSIrx7FiRjqJBRiRg09hCbTR5N2f8CTRq3RMRKDzmlPmdrcF5QFnlPRGFo85bU9xWWF+NviQX6inwpQF945LTmSpS5aXUJ+AtO1NWgC0/A0UAK6NQIyxr96ai+f/Vo0HahfpAzGNb6KrF+1c2fj0YWd8dpwO5P1uBQ/We0T4Bq+s3GVJfScokhVVA08wpfRgL7NVW2VHqvqyVsx3Z98w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(186003)(6512007)(38100700002)(1076003)(6506007)(83380400001)(36756003)(2906002)(26005)(7416002)(478600001)(6666004)(6486002)(107886003)(86362001)(41300700001)(66476007)(66556008)(8676002)(2616005)(316002)(4326008)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7PpVl+66p9cbNOKIT/ikBEeqWBrJ+6tpaZjMzit2ppLlFwXVTFebBiKWjcz3?=
 =?us-ascii?Q?Bg1DuJ/RVM5WjdPcxNyrjBGaa5vhcXlq5tKdfyR3G0TDjYZm7gCETTHo8jce?=
 =?us-ascii?Q?XyxaPvv0+xUh6DSZEFavs6yfcVZXCrZ7GGDesJ0ZtZOAh+iAV/MnddQGj599?=
 =?us-ascii?Q?oMsEeiJGaDWRHHbkHvruh9Dsp8Mt53FMmA9cfYWK6eeyKWILeTwgHZtQqHXT?=
 =?us-ascii?Q?LEDq5tHX0Kax/jZR6dn89GqxqC78cfmqDmngYIO1Mf6lYu/KNAqES24PRxSg?=
 =?us-ascii?Q?xCxpocz9l61k36HD1K6gJkl5K0AHJHlP3THogWohlcWxGiYWtE3PFz95+seH?=
 =?us-ascii?Q?/grocVcXdMxiZUAV9pYkMdCP5GkK2VAl2sHxxUUh/bVbAm65Veixtf6yw3U7?=
 =?us-ascii?Q?8+u1/G19S8z5Si217tKL8M2/H3B8X2JyfTbVGX7bNpYrqMACMvp9gZEKye3Z?=
 =?us-ascii?Q?9TBFuMhI/Lg5F102cpi2RqClhDhi3mOJPzHUi2PdXLY5hidSWi/DNoVPjQXf?=
 =?us-ascii?Q?n0XVEsP3PllXztmqB6+w8zOECklxIdUS/uw8N+VEHYHh6NvVqR0WQ6w13vVB?=
 =?us-ascii?Q?cje129XytlZbHs9B18JJh3zjxl+oew83XLgsW0pvp3xtJjwx1PWwBt2J73YY?=
 =?us-ascii?Q?m4TMfwP0Z1QnjWJfnjtuBTwq2Br1+73YPmHaJq/mUq86idabWU+lmHVYvhH9?=
 =?us-ascii?Q?bXKtQVZbRXLVr5ZQQjHTebrMgOfvVbVfkphmpOVEi97RYgevMlXe11FzrYMn?=
 =?us-ascii?Q?vRH82GijKwg4jVYNy9DDpsqBxh/w2BJVxd4tzUTguaDRMbRWOxXobno9O1du?=
 =?us-ascii?Q?ImOKu7hGpJaavEBXZrLGL8/mtkG78QFpsW8JyJKxC/wo9ND0Z/WYhW4yemJy?=
 =?us-ascii?Q?AExuEsuLbpgaJ3+Lxt/RBHftKREvW81RVwcBJM6bUE3CvnctgBJbweZlgLA0?=
 =?us-ascii?Q?GtQvE4OUDUNDt0j63EckIxqjD5JAO2zLRZVByVE5fWIncBarzjyq/I2MPxhi?=
 =?us-ascii?Q?BdE5cJi8eXgXfYch5aGUFOLLtPYTXWP+2X8qamwoVcrpzSu/iMw3wdp5smWP?=
 =?us-ascii?Q?HBcRJbmY16rX8tdhwJ/HNmpEpwIYfUFawyvCM2c7FMNTMzOugnkSOmF43gOj?=
 =?us-ascii?Q?2hc0d+/3F3pFw6ay++Hjau8IY4RT262y45EIxH+2lZhoC/vByiAfUpgV3jqh?=
 =?us-ascii?Q?C/ZUCeNN50JXbT+y27h78IDBaMHMXgqaHKOim53FsuaACU4+Jnv7wcQhW9Yg?=
 =?us-ascii?Q?Ox+lYImVvkesI2MuQMDNskTw5DAg5fqC1mQ6EKcIBhFr7PPuPwvVHADhf2HW?=
 =?us-ascii?Q?EoJyYwsjZ2XccjT2VW+30UxB1ZyDFRxwpbA3Ez0O9doXjgPMp/CmWebY62y9?=
 =?us-ascii?Q?Cs1gEt8mmEBZEeD9CdbmFrfGWh0Vm71/cF96/M4rOtPKBnXes8Fqxy81LUmm?=
 =?us-ascii?Q?bx9HDsjxNSm9fhGVpVwtD1vELwwHjoGILHeWdB6AwMbJXcpFnOSDYkIAn+BF?=
 =?us-ascii?Q?wTvd+QWDmk2Gua4cjxkieFyJQJVBWWPqmfX8SyhSVCtvhGOY1+ErCp6VXCjx?=
 =?us-ascii?Q?2xhgsSiO5/q/xzZ/UBqqp9Vg/foCQ70DnyYJd6dW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea5c3bc-a12e-4f99-6d93-08db05ea84ab
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:28:21.1245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dwELrmrfC7xwn02HwnCBOlXCadzja0ma3QgrQJu3/tPnUe+uStb0eNMrnyE2zh5W/VMI7YA5Q6boZpjl7MeCCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 drivers/nvme/host/tcp.c | 142 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 128 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 533177971777..7e3feb694e46 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -116,6 +116,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_LIVE		= 1,
 	NVME_TCP_Q_POLLING	= 2,
 	NVME_TCP_Q_OFF_DDP	= 3,
+	NVME_TCP_Q_OFF_DDGST_RX = 4,
 };
 
 enum nvme_tcp_recv_state {
@@ -143,6 +144,9 @@ struct nvme_tcp_queue {
 	size_t			ddgst_remaining;
 	unsigned int		nr_cqe;
 
+#ifdef CONFIG_ULP_DDP
+	bool			ddp_ddgst_valid;
+
 	/*
 	 * resync_req is a speculative PDU header tcp seq number (with
 	 * an additional flag at 32 lower bits) that the HW send to
@@ -152,6 +156,7 @@ struct nvme_tcp_queue {
 	 *   is pending (ULP_DDP_RESYNC_PENDING).
 	 */
 	atomic64_t		resync_req;
+#endif
 
 	/* send state */
 	struct nvme_tcp_request *request;
@@ -288,9 +293,22 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 
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
+	ddgst_offload = test_bit(ULP_DDP_C_NVME_TCP_DDGST_RX_BIT,
+				 netdev->ulp_ddp_caps.active);
+	if (!queue && ddgst_offload)
+		return true;
+	if (queue && queue->data_digest && ddgst_offload)
+		return true;
+
+	return false;
 }
 
 static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
@@ -298,7 +316,7 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 {
 	int ret;
 
-	if (!netdev || !is_netdev_ulp_offload_active(netdev) ||
+	if (!netdev || !is_netdev_ulp_offload_active(netdev, NULL) ||
 	    !netdev->netdev_ops->ulp_ddp_ops->limits)
 		return false;
 
@@ -314,6 +332,18 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
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
@@ -328,6 +358,38 @@ static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
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
@@ -387,6 +449,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	struct net_device *netdev = queue->ctrl->offloading_netdev;
 	struct ulp_ddp_config config = {.type = ULP_DDP_NVME};
+	bool offload_ddp = test_bit(ULP_DDP_C_NVME_TCP_BIT,
+				    netdev->ulp_ddp_caps.active);
+	bool offload_ddgst_rx = test_bit(ULP_DDP_C_NVME_TCP_DDGST_RX_BIT,
+					 netdev->ulp_ddp_caps.active);
 	int ret;
 
 	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
@@ -413,7 +479,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
-	set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (offload_ddp)
+		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (queue->data_digest && offload_ddgst_rx)
+		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 	return 0;
 }
 
@@ -427,6 +496,7 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 
 	netdev->netdev_ops->ulp_ddp_ops->sk_del(netdev, queue->sock->sk);
 
@@ -519,11 +589,26 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
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
@@ -806,6 +891,9 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
 	queue->pdu_offset = 0;
 	queue->data_remaining = -1;
 	queue->ddgst_remaining = 0;
+#ifdef CONFIG_ULP_DDP
+	queue->ddp_ddgst_valid = true;
+#endif
 }
 
 static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
@@ -1009,7 +1097,8 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_resync_response(queue, skb, *offset);
 
 	ret = skb_copy_bits(skb, *offset,
@@ -1073,6 +1162,10 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		nvme_cid_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
+	if (queue->data_digest &&
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
+
 	while (true) {
 		int recv_len, ret;
 
@@ -1101,7 +1194,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
+		if (queue->data_digest &&
+		    !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
 				&req->iter, recv_len, queue->rcv_hash);
 		else
@@ -1143,8 +1237,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
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
@@ -1155,9 +1252,25 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
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
+		nvme_tcp_ddp_ddgst_recalc(queue->rcv_hash, rq,
+					  &queue->exp_ddgst);
+	}
+
 	if (queue->recv_ddgst != queue->exp_ddgst) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		req->status = cpu_to_le16(NVME_SC_DATA_XFER_ERROR);
@@ -1168,9 +1281,8 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 			le32_to_cpu(queue->exp_ddgst));
 	}
 
+out:
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
@@ -1981,7 +2093,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_unoffload_socket(queue);
 }
 
@@ -2011,7 +2124,8 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 			goto err;
 
 		netdev = ctrl->queues[idx].ctrl->offloading_netdev;
-		if (netdev && is_netdev_ulp_offload_active(netdev)) {
+		if (netdev &&
+		    is_netdev_ulp_offload_active(netdev, &ctrl->queues[idx])) {
 			ret = nvme_tcp_offload_socket(&ctrl->queues[idx]);
 			if (ret) {
 				dev_err(nctrl->device,
@@ -2030,7 +2144,7 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 			ctrl->offloading_netdev = NULL;
 			goto done;
 		}
-		if (is_netdev_ulp_offload_active(netdev))
+		if (is_netdev_ulp_offload_active(netdev, &ctrl->queues[idx]))
 			nvme_tcp_offload_limits(&ctrl->queues[idx], netdev);
 		/*
 		 * release the device as no offload context is
-- 
2.31.1

