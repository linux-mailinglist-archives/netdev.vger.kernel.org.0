Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F59E66E26A
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjAQPjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbjAQPhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:37:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F5A41B4E
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YuJJR+MqDlngbfmULThGAgORmUmdEw6x4vv7zqZpe6dZqv1vD8NDzreFLFQIgEqXQ61Qg1GkNaLh8CMc9Xl4voxhZztlKfoTDKdm19wjIQg7CE41aQmILgF0NvivkmFU9URDdg1WIz6oTVo8NgIvnMXT6hio+4ViASsbyFkusXhyKt+IhvfbnQ26Tut9YxoL9PsrbhWnHwz22+XN7KPtnbsglzJFgy2vusUGW7mUQ9E8i6m9qyl8f6w9tD+jaZGq7CUClpf3bNykSh/nGR1SF3NDGSgiaor+AiJNfr9t2aA7j5C2oQ0RTgJFVdmm3zJ3webRcLlbpIyzlU9S87DHKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sJ5vp5wDGPjGcWcJvh3Xr6RlgO9G3rehM6YY9DqtG/8=;
 b=atc0Z2WBKsrmloyi6nz93k0whzuU4XOJd/v7mW1JnXTD+nn/M4UsgUdZrypVMdDyEm3wu6mJUqnClPhAxHN3b45ddUIEFGZi8BtsQtzsnzE8DS/M1mADCmhMfk+gW7N1Lun8lCdd6qjiSSs7IcXmnz99tx/JboIJsbbOidYdXwb4NiINQenv2xvJaqsM1TvmBMtft5faiCQq2SI1LeMlmwQi6oLj0vO4XJNbIVL7zBnFZN/PZtY3XWOHq8XTDNQtRBoAF4t2WlVtaMTGcNTx5O+4o0lUiZQm9TOSjp8Ubl2Js4iVgyhgPYKou/akQQKv5d3BCuksLQ1d3ccNFN9QhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJ5vp5wDGPjGcWcJvh3Xr6RlgO9G3rehM6YY9DqtG/8=;
 b=VWBJIa4kMuN/hKTqOgrimkvJZ8CskkXqjNE6eyK/jmCjjFS6KI/7Mp/k9kgRRk512wy22tbP8IbQoXA5l6dNgC+h8EJQTziuxjkJmu+LBv7NFUkdgw/kMSwzh8x7SnIMJdz1en5AszO8nTS6cPuX0sxMKHzrdFowmAGX6AjVpGne2mRpHVP6InG+SwiPgzqhzLX4rO67XQhuHPgWawvwhbN76cMVaB+fnzsFhO2NXhiRIM01aLolksGZ0oygAygUjdwBnEmASm5ncvBzFSS2gBvEwI4LTSnGgFdpHwwgSbsBWj7V6K1+ysRfgaWM+aSz9XcdRdx6YtfZE8t0a+AJWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:37:00 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:00 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Yoray Zack <yorayz@nvidia.com>, Aurelien Aptel <aaptel@nvidia.com>,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 09/25] nvme-tcp: RX DDGST offload
Date:   Tue, 17 Jan 2023 17:35:19 +0200
Message-Id: <20230117153535.1945554-10-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: a695132e-a136-4e60-5b61-08daf8a0ac55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BySIWHowjdVarF7jVblirU26b81s/I4gJ5fW0kBTlefv7NYB5bwqN+monA0frY2nvXglLHDuFpikIpmDn8wd0zXNUV8uTm7V+w3A10vVgYXv1SU0qjWA0pp1TQ7jz1tbO/q6oUcd1SAX/AljBwxS4DO3Zpg8yZufWJNuGx8c9GX2kQkUKA9mT1sJXanjGd8xm1huDZej0xvHivyrprYMg7MoRUecaN78TjRbnePU7B7oUuMOUTEZU80Y4aGIOuTlApDyXOnE73oWcXKWgXPt0V8b0ULB/lEpgdDnRGOt38ACvmfvmQwl17vzykmSXMq2qZghaTqk7HFHbE8EZQcSuZAWWs8ky5yEZNmY6KA3hz8wUn5skq6lwDJj7isuqpafQKUThT2iZ7uTr3I0/QMl96KtlNXHKPISmYHpmNdT9nWeiTJxvZHnpCU3n4NP4r2d5Bv51FtQ1aDDZimZ53nezCz8pYHNHNbMdAxs6BlwIbUR8TGfKiAOLJXQbJCTbEPzxoZzR8kpQRtB+pYd+rqIdbcN3WdLYVdGzj+0mAAzMhUtfNSWdo2nqq04Nc1rALldw1cSWmbJ8F0323Pl51w3VszHLg95rJJrbwJhfIRYJXXVBMhzhNbc1S1zbXPKr7T9nuarsmrhBzUQPujjmSGSvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(54906003)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z0wGzduMgZK/p7ZnCyyE8kRYUQuk4cI72F+fwxavdjKii16VjlrcIwbOGREd?=
 =?us-ascii?Q?F8Yn0jDaLWQCTRXHMMQznTRdQgHAlYYkjOQonrCMhOqlWFE3WOHtueY8U6Td?=
 =?us-ascii?Q?83kEPOuAJO/YEjmUpcMxzkhFXUq34drvi/mhU1QPACnEN5AxN7yvAB062UPA?=
 =?us-ascii?Q?RelKGwr6JfMpZs19nzNlZ91Wn++uu9RyTXmw0MgqtGEHwaMTGB/cHWBNJOPY?=
 =?us-ascii?Q?jioKgLApkxrW9fr7Etn1//kGGA+D6XBFZwnZhlvddLP3ymPS5SVI5ZrcVAqh?=
 =?us-ascii?Q?G3TTPZjkon+9ZqBU/O1SdJRdaBDfefv39J04xbogg2aXIHCf6WzNWcy26L6I?=
 =?us-ascii?Q?p4wR2BKOaBEk+J+TGpFh/nG1K2ekVCfDIq8PxkBtruvEHc2JpPeenZLhTH6r?=
 =?us-ascii?Q?Km0dD4m/ezqJSb6PPA7bRy2LTyroPExOuKJCCoCJ3kHpyaITGkwCC8U4ImWe?=
 =?us-ascii?Q?XRWSvl9mHLNBfwBsUCfrMUdPgYH1yRvLmI/wM3IAAMpv4m2E56O/xzPZdeGA?=
 =?us-ascii?Q?citd+tOrw3bJ/0rVRJ58xWStq5O7Db8iNO1EZCIzue3DxYUmSv9Jn90ceWKH?=
 =?us-ascii?Q?gaoG/y0I2HkV+sUH53zJJHRLiAMH5L3kI7pWFmubapSPhE/TSWmlenKgbKGb?=
 =?us-ascii?Q?QWfUusv3eanmpC8APj0PwjwIb+9DSAN0U+2xG4TM+oOvaVQx+5rtp5WFAo+D?=
 =?us-ascii?Q?Yt+fwbZF1ITp32y5gFLRX/1V5QzSCrlFOhKXyVshE/hLWgb1bfZ7GrhmRvB/?=
 =?us-ascii?Q?kHUaKKSmb1gfb9RRbUODnDNz0t6hG4CobRCKAR+G4Hx/veICaInFudXz+4IU?=
 =?us-ascii?Q?7NFkaO6Vs1WRoibhGTZ5/dHnI6WvnM06/rlwfEXVEnDCeM+XrZGt0+dGvctm?=
 =?us-ascii?Q?0xNxW/vJDmv4C4c5TlU16mejMD3iZkOB/+ughYYEDZQyMROZvUkRQTCVVGwu?=
 =?us-ascii?Q?QwtuhOrXXjcxalWlgwvdakxm01BP6zK2MIRjbPTlfXE7YB6bSAt31ua0V4Tf?=
 =?us-ascii?Q?Xkl8lwKj8b830RJ2B1SYv+65+mATzAtEqSzOokluP8ul3r0GwEM2Dbpvu0DE?=
 =?us-ascii?Q?xw+Yk5eGmWLWoEcn1JwIb2ZrbmZlaTCPWvj54ZTLMiqUlbeWf0Ok11PePkXy?=
 =?us-ascii?Q?X4O2m4RAfxlMejPDOQ5P9o3uPnP5PKIlPuJKRb0H05acHHOiCZ3FrStONdjg?=
 =?us-ascii?Q?4F7AmE0lhEf6DrdpNcyTwpJmIxmuN2Oyx6evaZrtGg1naLHgrV2sA1HfQVlp?=
 =?us-ascii?Q?jN2NcJsnZyJ2IRLa09AOLZHCAhj/dkX4X+vsPmYAKihbvK0sz6Ga2fRTUV84?=
 =?us-ascii?Q?RT8Z3fdLzrZ/4F4q0ytCcQ9FG/8Rgb7e2sv9dGXRfPL4hP2o91WhnBTnTpIz?=
 =?us-ascii?Q?f9GTF0TUroiXrVJhvCOZN9O3jH4sX4BkDlYea9lqHzdZvaGv1FTjYDDQO4ff?=
 =?us-ascii?Q?XzFr+T/jftcLs3W3LjRw2g2YK8K0hou/mEtr3nkz+MMwBB4n+vaaTMhCyGyi?=
 =?us-ascii?Q?FxNxwWTz/hx0qATkydovzaOHzHzD5pTHKEvtqnjb5Zrp7MSDYfikEJ+4V/mr?=
 =?us-ascii?Q?M/CoEWQ+rX5TGwZFigCs4TPwNnAjYJROR95z9NaP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a695132e-a136-4e60-5b61-08daf8a0ac55
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:36:59.8264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CMDDxp2dMmOdGABSq3EX6oy912PCLcmkfdWAM0kwz+qEGaZ29lfGvpVk8tGME0o1YyH7aFu3II+vZjLkYuabg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8177
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
index 968b8b6459ef..87259574ee1a 100644
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
@@ -287,9 +292,22 @@ static inline size_t nvme_tcp_pdu_last_send(struct nvme_tcp_request *req,
 
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
@@ -297,7 +315,7 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
 {
 	int ret;
 
-	if (!netdev || !is_netdev_ulp_offload_active(netdev) ||
+	if (!netdev || !is_netdev_ulp_offload_active(netdev, NULL) ||
 	    !netdev->netdev_ops->ulp_ddp_ops->limits)
 		return false;
 
@@ -313,6 +331,18 @@ static bool nvme_tcp_ddp_query_limits(struct net_device *netdev,
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
@@ -327,6 +357,38 @@ static int nvme_tcp_req_map_sg(struct nvme_tcp_request *req, struct request *rq)
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
@@ -386,6 +448,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 {
 	struct net_device *netdev = queue->ctrl->offloading_netdev;
 	struct ulp_ddp_config config = {.type = ULP_DDP_NVME};
+	bool offload_ddp = test_bit(ULP_DDP_C_NVME_TCP_BIT,
+				    netdev->ulp_ddp_caps.active);
+	bool offload_ddgst_rx = test_bit(ULP_DDP_C_NVME_TCP_DDGST_RX_BIT,
+					 netdev->ulp_ddp_caps.active);
 	int ret;
 
 	config.nvmeotcp.pfv = NVME_TCP_PFV_1_0;
@@ -412,7 +478,10 @@ static int nvme_tcp_offload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	inet_csk(queue->sock->sk)->icsk_ulp_ddp_ops = &nvme_tcp_ddp_ulp_ops;
-	set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (offload_ddp)
+		set_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	if (queue->data_digest && offload_ddgst_rx)
+		set_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 	return 0;
 }
 
@@ -426,6 +495,7 @@ static void nvme_tcp_unoffload_socket(struct nvme_tcp_queue *queue)
 	}
 
 	clear_bit(NVME_TCP_Q_OFF_DDP, &queue->flags);
+	clear_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags);
 
 	netdev->netdev_ops->ulp_ddp_ops->sk_del(netdev, queue->sock->sk);
 
@@ -518,11 +588,26 @@ static bool nvme_tcp_resync_request(struct sock *sk, u32 seq, u32 flags)
 
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
@@ -805,6 +890,9 @@ static void nvme_tcp_init_recv_ctx(struct nvme_tcp_queue *queue)
 	queue->pdu_offset = 0;
 	queue->data_remaining = -1;
 	queue->ddgst_remaining = 0;
+#ifdef CONFIG_ULP_DDP
+	queue->ddp_ddgst_valid = true;
+#endif
 }
 
 static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
@@ -1008,7 +1096,8 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 	size_t rcv_len = min_t(size_t, *len, queue->pdu_remaining);
 	int ret;
 
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_resync_response(queue, skb, *offset);
 
 	ret = skb_copy_bits(skb, *offset,
@@ -1072,6 +1161,10 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		nvme_cid_to_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
+	if (queue->data_digest &&
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
+		nvme_tcp_ddp_ddgst_update(queue, skb);
+
 	while (true) {
 		int recv_len, ret;
 
@@ -1100,7 +1193,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		recv_len = min_t(size_t, recv_len,
 				iov_iter_count(&req->iter));
 
-		if (queue->data_digest)
+		if (queue->data_digest &&
+		    !test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 			ret = skb_copy_and_hash_datagram_iter(skb, *offset,
 				&req->iter, recv_len, queue->rcv_hash);
 		else
@@ -1142,8 +1236,11 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
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
@@ -1154,9 +1251,25 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
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
@@ -1167,9 +1280,8 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 			le32_to_cpu(queue->exp_ddgst));
 	}
 
+out:
 	if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
-		struct request *rq = nvme_cid_to_rq(nvme_tcp_tagset(queue),
-					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
 		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
@@ -1978,7 +2090,8 @@ static void __nvme_tcp_stop_queue(struct nvme_tcp_queue *queue)
 	kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	nvme_tcp_restore_sock_calls(queue);
 	cancel_work_sync(&queue->io_work);
-	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags))
+	if (test_bit(NVME_TCP_Q_OFF_DDP, &queue->flags) ||
+	    test_bit(NVME_TCP_Q_OFF_DDGST_RX, &queue->flags))
 		nvme_tcp_unoffload_socket(queue);
 }
 
@@ -2008,7 +2121,8 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
 			goto err;
 
 		netdev = ctrl->queues[idx].ctrl->offloading_netdev;
-		if (netdev && is_netdev_ulp_offload_active(netdev)) {
+		if (netdev &&
+		    is_netdev_ulp_offload_active(netdev, &ctrl->queues[idx])) {
 			ret = nvme_tcp_offload_socket(&ctrl->queues[idx]);
 			if (ret) {
 				dev_err(nctrl->device,
@@ -2027,7 +2141,7 @@ static int nvme_tcp_start_queue(struct nvme_ctrl *nctrl, int idx)
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

