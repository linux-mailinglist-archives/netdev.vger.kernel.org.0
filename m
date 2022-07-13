Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6ED572CE9
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiGMFQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiGMFQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:16:51 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2053.outbound.protection.outlook.com [40.107.212.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282C0D4BE4
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:16:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTXOW1/iYOFRcyyTodgM12tdyYt0DPy65WHCEbBUjex1SBWVoMrAAj5hgitcz1jXGke/f3TWwuUtRHovbDm4KQhTevFhBAf1lKcsVmlslS1CkwDhcpuSCEDkxfuPv9HxUxs3HWwEhvAPt8lXN7WQ2gItmcBVy0lz0bxPa4S67dKjjGgkHHRSX+2qYmeqkR0O1mNhTQ2c3j89bMOkhJAUAWx1DYsHQ1q8wueaJSA/h8ExFfgfVnp/yRKTqnbTGtqvNGjT+uY1mFBWBzp8WA3gfyrXhYe1HTjH7Tb6OyY+Yj9v2mSyihNfsF3Pt1N7GZvAw+RH9czABsGh8plPhkcOqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWltZG7E52S6NJA/yPRwQYeBpU8QVN6l5EGjV9HFYOM=;
 b=TcOrbkUMhtiOJqg8n+5Yksp1egRHTBXyyX21xta0kMd+PLcdTkLTjIQM0b/GTfHvuQ2Xkjq6D6xTM8GIioBOMTOXKU44/PKiqDW9Nwkjxludr0sIJT0TxyA1ednxb77jo59lRfIyEQ1+fpd0AtVhH0rS6zgpMAPY1UITu1SG7W9t0MbpVH0rUwt1KDlf2zxvz0n88nqhErRAZ8RR9e+p/G2uiPEl6ONNrZTLiemcaUfqCud/wAksuWxXRUZM21aYLvPDR0nGmCzT7i0KmV1f7Fnk2+wPtxFAm+G7Le/nHXGiKLWFJCGWAFcdzbuZrCPnX+oH5Wt3KYa8jkbBWaQvRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWltZG7E52S6NJA/yPRwQYeBpU8QVN6l5EGjV9HFYOM=;
 b=lBx3vLcOzEEuHeteoLGEP+I7PPrswe+1NkjD6u3y/ZepJ4sPXzy0a11GerJ2/AoQa7h2fEfmWLFd/YiK2dWeFNCefi4sAwx5AgflOx650Efff60Wa/D4AjKCaQL3TfiV2Wp63gCgwZoPEd3uCvnoTVM5XMaB7ARv8HiIWPgdW3ydGy7QSw9Yhi2Ujdx8bMoNTHBx0VAYIOsZNky8imOCq0EoQy0dYVllnPWrtXj4mZUyZsZYXb2OJMBCrJbANEh7560Rmhf0FeVSfMp12EiBY46fbxy4BIvNkD4WjcO0brSzlccH9H0MwEt9migkiSz1wKO6xK/LoKKsMXJctdL3+Q==
Received: from DM6PR21CA0013.namprd21.prod.outlook.com (2603:10b6:5:174::23)
 by DM6PR12MB3498.namprd12.prod.outlook.com (2603:10b6:5:11a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 05:16:47 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::96) by DM6PR21CA0013.outlook.office365.com
 (2603:10b6:5:174::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.10 via Frontend
 Transport; Wed, 13 Jul 2022 05:16:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Wed, 13 Jul 2022 05:16:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Jul
 2022 05:16:45 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 12 Jul
 2022 22:16:44 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 12 Jul
 2022 22:16:42 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <galp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next V2 2/6] net/tls: Multi-threaded calls to TX tls_dev_del
Date:   Wed, 13 Jul 2022 08:15:59 +0300
Message-ID: <20220713051603.14014-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220713051603.14014-1-tariqt@nvidia.com>
References: <20220713051603.14014-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fdfdd60-2840-4b35-ea05-08da648ee21a
X-MS-TrafficTypeDiagnostic: DM6PR12MB3498:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p52i+FsWrVOqjK3I8hcgzVnhqQUt1juIgL6F3bzfNNmJeH37wp+QkuYuSO5NfarL2LWSdh0vadNnSVyFSRIMz9ESUxYHgd2Gi5HK4Z0smhkSitNg4FFaIuDcN8p//rzI0bQUviBvY6PSW0iRJ9g++YybfV5i6OGPQ48qpJsUz4vGizJjH/P+yONoGNQTdXqDmeAMr8+HZcF9B3Zv8WgfhrePttrlHItGRW9K/IszsZv06vBkec6pM1l76t9NajZCg2vOWsh2w56plAUmaNInIpr2D6ke+6RoxaAM+A483rouliUdKbNxZMqoQHfVYqhXBc9Ncw5AvYx/W2zBIYQQws+0WXTWa/ngFfDAiBvVCuDcrAopaziUM5X4tSra9zvxlc0yGxqmk1HswygrPIP9aZQ7QBabdelBwtGr/MwaPcd+kstobfT1Ga9RAuQgE9TfYl6Hi/kt7bg+jTnusWPpuNze2BIL7gTNCFM+0bjA951Llcv9Y4YUjMITIAjqpFzQLYXlCbKYYsqZ6pTuvw8PpG92rmmO0ufa9loYLuS5jLbwx6SGY7sZkrYz1qYKdRh4DvJBpDlmr3xapjZyA3YtSoT5Mz9lcLIHvZfEAF0iRObVzLFL4E1z0i/hsZZwEFrFTtXIIFUA0QibVQzj5v4F6T38s6+kRSfwV+mA/hh9YCIgn9Qf8qKXZCSMv+95OSP0kUiiowRUGic7/LRu8i0Rf2c029DAWg01vCmW3EkyezBbB7NQJHg1rqYmRQmlU38Vfqxwemw4sz4sXkpmfKnJJ98+dc1rj8QQK3fnZGWob8IIFSiumgZrDesfXyrHUy1TArTeX28YH4S58L9R1cnUmBPSdoAijfoKqB+jmdBr1GE=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966006)(36840700001)(40470700004)(478600001)(82740400003)(1076003)(316002)(54906003)(40460700003)(107886003)(2616005)(186003)(81166007)(83380400001)(110136005)(2906002)(6666004)(70586007)(41300700001)(70206006)(4326008)(8676002)(8936002)(5660300002)(86362001)(7696005)(36860700001)(356005)(336012)(82310400005)(47076005)(26005)(426003)(36756003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 05:16:46.6801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fdfdd60-2840-4b35-ea05-08da648ee21a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3498
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple TLS device-offloaded contexts can be added in parallel via
concurrent calls to .tls_dev_add, while calls to .tls_dev_del are
sequential in tls_device_gc_task.

This is not a sustainable behavior. This creates a rate gap between add
and del operations (addition rate outperforms the deletion rate).  When
running for enough time, the TLS device resources could get exhausted,
failing to offload new connections.

Replace the single-threaded garbage collector work with a per-context
alternative, so they can be handled on several cores in parallel. Use
a new dedicated destruct workqueue for this.

Tested with mlx5 device:
Before: 22141 add/sec,   103 del/sec
After:  11684 add/sec, 11684 del/sec

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/net/tls.h    |  2 ++
 net/tls/tls.h        |  4 +--
 net/tls/tls_device.c | 65 +++++++++++++++++++-------------------------
 net/tls/tls_main.c   |  7 ++++-
 4 files changed, 38 insertions(+), 40 deletions(-)

v2:
Per Jakub's comments:
- Remove bundling of work and back-pointer. Put directly in tls_offload_context_tx.
- Use new dedicated workqueue for destruct works. Flush it on cleanup.

diff --git a/include/net/tls.h b/include/net/tls.h
index 8742e13bc362..57a8fbbf395d 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -142,6 +142,8 @@ struct tls_offload_context_tx {
 
 	struct scatterlist sg_tx_data[MAX_SKB_FRAGS];
 	void (*sk_destruct)(struct sock *sk);
+	struct work_struct destruct_work;
+	struct tls_context *ctx;
 	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
 	 * Currently the belief is that there is not enough
diff --git a/net/tls/tls.h b/net/tls/tls.h
index 8005ee25157d..e0ccc96a0850 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -133,7 +133,7 @@ static inline struct tls_msg *tls_msg(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_TLS_DEVICE
-void tls_device_init(void);
+int tls_device_init(void);
 void tls_device_cleanup(void);
 int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
 void tls_device_free_resources_tx(struct sock *sk);
@@ -143,7 +143,7 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
 int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 			 struct sk_buff *skb, struct strp_msg *rxm);
 #else
-static inline void tls_device_init(void) {}
+static inline int tls_device_init(void) { return 0; }
 static inline void tls_device_cleanup(void) {}
 
 static inline int
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index fdb7b7a4b05c..ba528dbb69b4 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -46,10 +46,8 @@
  */
 static DECLARE_RWSEM(device_offload_lock);
 
-static void tls_device_gc_task(struct work_struct *work);
+static struct workqueue_struct *destruct_wq __read_mostly;
 
-static DECLARE_WORK(tls_device_gc_work, tls_device_gc_task);
-static LIST_HEAD(tls_device_gc_list);
 static LIST_HEAD(tls_device_list);
 static LIST_HEAD(tls_device_down_list);
 static DEFINE_SPINLOCK(tls_device_lock);
@@ -68,29 +66,17 @@ static void tls_device_free_ctx(struct tls_context *ctx)
 	tls_ctx_free(NULL, ctx);
 }
 
-static void tls_device_gc_task(struct work_struct *work)
+static void tls_device_tx_del_task(struct work_struct *work)
 {
-	struct tls_context *ctx, *tmp;
-	unsigned long flags;
-	LIST_HEAD(gc_list);
-
-	spin_lock_irqsave(&tls_device_lock, flags);
-	list_splice_init(&tls_device_gc_list, &gc_list);
-	spin_unlock_irqrestore(&tls_device_lock, flags);
-
-	list_for_each_entry_safe(ctx, tmp, &gc_list, list) {
-		struct net_device *netdev = ctx->netdev;
+	struct tls_offload_context_tx *offload_ctx =
+		container_of(work, struct tls_offload_context_tx, destruct_work);
+	struct tls_context *ctx = offload_ctx->ctx;
+	struct net_device *netdev = ctx->netdev;
 
-		if (netdev && ctx->tx_conf == TLS_HW) {
-			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
-							TLS_OFFLOAD_CTX_DIR_TX);
-			dev_put(netdev);
-			ctx->netdev = NULL;
-		}
-
-		list_del(&ctx->list);
-		tls_device_free_ctx(ctx);
-	}
+	netdev->tlsdev_ops->tls_dev_del(netdev, ctx, TLS_OFFLOAD_CTX_DIR_TX);
+	dev_put(netdev);
+	ctx->netdev = NULL;
+	tls_device_free_ctx(ctx);
 }
 
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
@@ -99,21 +85,17 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	bool async_cleanup;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
+	list_del(&ctx->list); /* Remove from tls_device_list / tls_device_down_list */
+	spin_unlock_irqrestore(&tls_device_lock, flags);
+
 	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
 	if (async_cleanup) {
-		list_move_tail(&ctx->list, &tls_device_gc_list);
+		struct tls_offload_context_tx *offload_ctx = tls_offload_ctx_tx(ctx);
 
-		/* schedule_work inside the spinlock
-		 * to make sure tls_device_down waits for that work.
-		 */
-		schedule_work(&tls_device_gc_work);
+		queue_work(destruct_wq, &offload_ctx->destruct_work);
 	} else {
-		list_del(&ctx->list);
-	}
-	spin_unlock_irqrestore(&tls_device_lock, flags);
-
-	if (!async_cleanup)
 		tls_device_free_ctx(ctx);
+	}
 }
 
 /* We assume that the socket is already connected */
@@ -1150,6 +1132,9 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	start_marker_record->len = 0;
 	start_marker_record->num_frags = 0;
 
+	INIT_WORK(&offload_ctx->destruct_work, tls_device_tx_del_task);
+	offload_ctx->ctx = ctx;
+
 	INIT_LIST_HEAD(&offload_ctx->records_list);
 	list_add_tail(&start_marker_record->list, &offload_ctx->records_list);
 	spin_lock_init(&offload_ctx->lock);
@@ -1389,7 +1374,7 @@ static int tls_device_down(struct net_device *netdev)
 
 	up_write(&device_offload_lock);
 
-	flush_work(&tls_device_gc_work);
+	flush_workqueue(destruct_wq);
 
 	return NOTIFY_DONE;
 }
@@ -1428,14 +1413,20 @@ static struct notifier_block tls_dev_notifier = {
 	.notifier_call	= tls_dev_event,
 };
 
-void __init tls_device_init(void)
+int __init tls_device_init(void)
 {
+	destruct_wq = alloc_workqueue("ktls_device_destruct", 0, 0);
+	if (!destruct_wq)
+		return -ENOMEM;
+
 	register_netdevice_notifier(&tls_dev_notifier);
+	return 0;
 }
 
 void __exit tls_device_cleanup(void)
 {
 	unregister_netdevice_notifier(&tls_dev_notifier);
-	flush_work(&tls_device_gc_work);
+	flush_workqueue(destruct_wq);
+	destroy_workqueue(destruct_wq);
 	clean_acked_data_flush();
 }
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index f71b46568112..9703636cfc60 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -1141,7 +1141,12 @@ static int __init tls_register(void)
 	if (err)
 		return err;
 
-	tls_device_init();
+	err = tls_device_init();
+	if (err) {
+		unregister_pernet_subsys(&tls_proc_ops);
+		return err;
+	}
+
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
 	return 0;
-- 
2.21.0

