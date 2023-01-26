Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877C767D143
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbjAZQXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjAZQXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:23:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476463403A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:23:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m36Ne2LGhI36TZRb+qgPsoGGftQuYLCEFqjYzhtXnxvfLrLXhWNcK7ar8swNNfi6Gh//5SMrmnjpHTSNFb2bl0V9iY921/IUq+M3Sxabf3IhwSRijrUjgXqmQY9f9UTwUCdLPwujwTQEKBIYc5W0pGBJE7sh6TByymtQh/vP9KwWfnkNCt1bWNJAcqBakiW/C0944akWVjS52i5dHgnRogUEtzHCvnd/KSTpKZaIZRCS6kXUWTIyN7RoaHhJ05mJsH00bgPFWRGIOzxJENuYGAk7VqvfJTu/KGLTfoWH7RIL3GEgQhNJzRv0N3zucAMyLSGt3Im+ANwQTEtVl24oUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ba2Kq7e/xGwQoLYr5mKtQYFkhXZhqoRlrhkbFD6WVwg=;
 b=jyHAcXpEPlsjypYCjj6EpLiwRRMQURs2MNwmdFGllR5p+DUtQW4NybUVT66outQozfwfNPY/OK13AjvK27KSZoYhVqTY1Vm7KRKzdE6x7R33Mzpg1ikZOihbG4UJVHLAAk9NhW9nT2VL8fbwp2gDstVLZeu3zMDXpHERGnJrkZ3ttbmmmN35S1Q+YqMXXNmengBlSarG6JYtKfQ/+G3L20x2pW/pnqQSt8RLR2VCYA24l1Q7Ul8k0pO3a1Q4jfiKncQQI9cAwXM/HE330TMWNysBlMdKMmAGITP6mfL6s8zyFeNqkIXmpHENTV39F8vYK+spI/JZ8xk/m0D0IIlo6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ba2Kq7e/xGwQoLYr5mKtQYFkhXZhqoRlrhkbFD6WVwg=;
 b=TN2AfmO1hqorNk625bC4qMleMyAHrARiCNLn46vLU72uGhWopIvF6s/I/laNuWjPMtggcSbJFTXpWSqA7m/QPs3ArOfdcxSQc4GT9u9oSjgrerWq5CqGini5RaWHOAtSrchiieowRin8Krw7zj0+hS4/zSpyQBoDYYnusMZSgPr0Lovqq+fPCHfN8Hzlc4DKU36HDm/4ctdGfmsQV+uKRKorJWhxeCGIcAnhbS11+fBsiC1RkzDkBh3ZZRA+Vl5Qnv5L8c+ZnBMlzi5xJDYgkbImXERKK8eB+VWkhZQGX1G3xkW2rosHL4dbbcHYMsDF75b3GXIexdg5e4SOMLCgig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:22:45 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:44 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 09/25] nvme-tcp: RX DDGST offload
Date:   Thu, 26 Jan 2023 18:21:20 +0200
Message-Id: <20230126162136.13003-10-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0075.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::8) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: b58ab031-400f-4776-c95f-08daffb98e09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kuqk1kMxmdlebWTcyabnlTwfQPsuQsCnaAlbDddyOIpmmQtNLgvh4laFlKyaMotK2e6dQQH+c2ECh2jnOUHCE7cS5tP+fnambYshss5C3exK+lQFXRd5yvQXsoYPuUOpSFt9wIrL08l8s6ZWSoiIRp67Ly29NTl8SPNyOW5RmSvcoo/4EpJH8uZM8EL9xger+tHFKU181ZIhFiQiIMDmtN7zg/vPblezvEE+SSHwViJ5PQw5FZ3CzR12SXx5InyUn+8yoVi8wOsn/u63JqHdrWcurJGef7Bw/j0MgHcUCjCIui+019YdMAOjMNJ9wv74azNjK7PVOkPwFt9ET4D31XM5eC20yPXLMjzvZs/gYoYxWaqnJlAHqAjFg1WbzCXVlnL+8Ldtlhk3VoFsCYkaK6+s0HhJK+Jtg4RaWddprw6Q7Oi+7c77FSkNPV/qQOZGYAdxUzfZLSfsFr+6kXNK9qDOs+WyVyOgB80+BnkYh3YzkTybp9svpTrwfaTEyqt2xzzW1TKY86qTI26mBqXBWxTXwABHX3a87Im7Hb5feMlYh0W8V2q7cnhgy/zptz9bpeFxdTMCzCwV27yH4XzWAli74TYY6RO2pgiCHmvb37CeyVO58eLUceVxvl8OrGCBad4MtSdliM6NH2TYm12gcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5D6LIGQwvQ3ymkNDEcNO86lGFKkWgxGGssAnbNlC92zLWQYReX3qXZ/V0e40?=
 =?us-ascii?Q?KTsH/Tliyf509WApKGFBSHJstBn30ZBvWAQuln674ZODjaIM6Mn+5n4g01xx?=
 =?us-ascii?Q?jqYHLO9vqcb8fQuBCr9ajIyTwvVT4QRAylbngwMnurh6VDI8STG6MDlmJK8l?=
 =?us-ascii?Q?dhUkGvs/u9msFF0w0fDm4zimLeA2LSsGXXqWvK3dRbW7A83iK1bWzcwzPfqL?=
 =?us-ascii?Q?xI8j2U4hPmtzmZQ2PWFNQnDhGdjLVY1x4SoYmhM7fIJ8XibJBIfWRDEYHf7k?=
 =?us-ascii?Q?Ia43v9G60I2/RGKWRz2vwQs8t8WASqOUMRTRxru/iCBq4WXwE1DE2mXYJzWE?=
 =?us-ascii?Q?aANq/Gwvzz72OWGumylHsdxzIqX19TVKvPrbZn1uDkBtCzVtUf+H9pQr3PUv?=
 =?us-ascii?Q?7L8nWKq6y4j6Dh5Jj97zfLmu2ozhsqa94k0/VkPLQaSUEdwl7xkLv++T8faY?=
 =?us-ascii?Q?H0bxsfBX3DCrD7N6T0Q6qPvrJh22AJgJ9jbRHAncwElisp7sjGMkOg7ahRM8?=
 =?us-ascii?Q?3HmwEK6NR4IJK4STlQx6mNgc77LlH7qVh2AfTRAErMtBn+nH9Fg3zsWe8+s6?=
 =?us-ascii?Q?R91+27s7k2icF6UKaRNwpPIv35JEWN702QyMZHUKWSg1CorlRqFC2eJhR+Da?=
 =?us-ascii?Q?0/Rzk+TB+hv18hVXTSsDYk5oO+3MIO2I0v4q1+u/sHdRBc/UUbsM96gDAES1?=
 =?us-ascii?Q?ZmQRh/oHX9TyxFRm4gSNvEV9SBG9i0LndWAgoj1YnJ+bn4OT64seLWaJRceE?=
 =?us-ascii?Q?I2NoYATDnK1ztwWSD+GDowbbFeeN9BudycFVVGAhJVLz7ln3jLYQn+1fmM9C?=
 =?us-ascii?Q?a3As8HgLJn9sJGA6XaXb3FB9Orz6+nCVd0mBTqdMd7MrESUd1IWVN8OfAIMp?=
 =?us-ascii?Q?fA+bMSdb/DL/kWseESGNU4xHUw1ZSn+zi6nnC45JMuLuSPpXnWtr4Ghr2zR5?=
 =?us-ascii?Q?d1S1Rwo7lOEJV03lGldFEQJ2yGOanltVkeassGi4VDkbYw2xCSje7YigwsDu?=
 =?us-ascii?Q?dy1QNZ4wbUcvmOV3qAPLUVNrwYB1L/UzjOZlwvJQDHbZH3KRJ/IoB4JCEnwh?=
 =?us-ascii?Q?jb1IqqzHPR7AaxdXzqE/LI/wSFcFArUdc1p92t0mKg4NzwouNJytGQ52lAG6?=
 =?us-ascii?Q?iBdn1L+m/IeQO9MJKsbPmsd4cdmiU+sd3OAf3jSTw7VNlgHmMX3kgnQJn4Zu?=
 =?us-ascii?Q?X5E37ccJ8/Nws9prUd7yPzVqI3nsB2FR+TIgTBlqjgsjTYH6uXWN2eomnW/5?=
 =?us-ascii?Q?4QjQdaYrdfllYJHazKA2bYhLt6k2+skCuF4+XyUh8TmYXfLP9ZsKI0svlFla?=
 =?us-ascii?Q?IITCotdGNw1DakeXeAx7UTq16j/uuxaWATPOqe/grwTuheWy0QcbD0TEP2qO?=
 =?us-ascii?Q?yH7sNJuuc4k/9GNb/snH+mY7YfbPNulF6k3umXYpql7iCtawAteH4r2TK0KB?=
 =?us-ascii?Q?COE/tnT0Zw8wkTCgJqwvY88+CPbfXiemahmV028hDzrN1fviobPG/EanRL8H?=
 =?us-ascii?Q?p7kxurItUBp2AcCehGc45x8tpd4F2v0FdW1X5ML9CrfxFKgQU54TZgzvuYHU?=
 =?us-ascii?Q?aByaRrUIqO7MbctXJDZn+8nZXUbqmVqRdgtqCNCx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58ab031-400f-4776-c95f-08daffb98e09
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:44.4804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xo46kPylO4UXY1nxRoMUy8AiGxk7vCoWqI0xUqL4uFLh+b/NxUaS4mQKFE/GVOHfcfVgZltVFlSK0wpxmzauUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
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

