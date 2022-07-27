Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB14D58236A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 11:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiG0Jo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 05:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiG0JoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 05:44:16 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529B03FA1D
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 02:44:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etyIF957G0Nd8LuvARv1mAQQnySaTy4EiTfS0c1buFxxwVaZMkg/u/kbcy5WSh6J8Ez1D7P1ff0Ckdegif3eYU+358GoOTQdDr223Uk/BHSc4DwjHKua1eEO+RYtmEi6hITk+qPzN4cC/0213dm6mNSuzgn8XsBK0V68sS/o5cn3FJ9X+TOTzwtZDrALU21C/L1XzBMwqKY2WGKQ64OxCFwR4l51cPlurXif4G+1NJfCvM36FxXSDFYzmhbTRW5GdmQRmjmY0FdH0TfT3G/e3lyTLywBHVuuKiNRRq2/CmfJjTD63Mso8Ks2XrhRaTzuZvnqjH2dTjnCZtGNFXJj2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SqJxg7I/qApxRIIGirWw/WUl1XjW2wwdbCK6MxUuDw=;
 b=N3FOOKBMTOKxn0AbV4VpmDDyr2VUdqUqKC3LUGyIcslzOylLCICo5RWDry0FKWtZ8GW+In1+B6e3/qrCjl17gbJ1NVoysbxCdrRenEx2ggLgv2PyJPHXeoJS6S0c4A6hJ84KXbDEYDNKhjTJ9v7iKpJZcz2SkVJkg4lQGkQtOzgEl3MV49/GH0hs275RWA6aAAaTu7N6ltoU+XJV9crlqekgeL9vPBpnKCfbyCbykn4LMku2p4KLhPNsBtK2J9w1722YWMyGxoq6dSaiw5IvVz8JFyH+ly4xYcAm0U4qwYL9/TmvAro+Db1wviclnzvfX0HIUKP1GGTzXdz0uQyAVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SqJxg7I/qApxRIIGirWw/WUl1XjW2wwdbCK6MxUuDw=;
 b=V2uQsizccBk5DmYEZoem2WmdI8+2zfNv2j/kmoacoPIqJ82PRKTdbWhYker0ELTgFHsSyWkcY7Ir8FQ943/Pa9WoA1JnMhWtWT0/mbnH03WBCG9ISWqFjBBl3s7sGmjvUhX/UJhI9OHti7Y41VYmIU/SaXB3RwR3fFOgwaKO/WPpLOt4aDFasxXgjaTwfHx0WXcFH7BQLVW6LgC5v4NuqKxI/Yf/9iPiecLBqqsbHny83F9swq6hT5bIXHSpFk1WLDPSnLwy0qQ4YaolaErg28CGql5EgSOpb3jgoNcl7JH347nouWZKMeL22cCjyPguheduqfJOvopFse2+Zvu3XQ==
Received: from BN7PR06CA0044.namprd06.prod.outlook.com (2603:10b6:408:34::21)
 by DM6PR12MB2955.namprd12.prod.outlook.com (2603:10b6:5:181::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 09:44:13 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::a9) by BN7PR06CA0044.outlook.office365.com
 (2603:10b6:408:34::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Wed, 27 Jul 2022 09:44:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 09:44:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 09:44:12 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 02:44:11 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 02:44:09 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next V3 2/6] net/tls: Multi-threaded calls to TX tls_dev_del
Date:   Wed, 27 Jul 2022 12:43:42 +0300
Message-ID: <20220727094346.10540-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220727094346.10540-1-tariqt@nvidia.com>
References: <20220727094346.10540-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38ffa0c0-0c45-4b26-b61e-08da6fb4907c
X-MS-TrafficTypeDiagnostic: DM6PR12MB2955:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DtD2SCC0N1TES5SK2xZBcd05XK4Aaq3jvy9INy/oGqPk8AE6eBCTvzxeNzNLMsDTvCWtr2lI/IzaChQLg5i9QP6yBlIZkfrHjS8TsgqLqLi1wt43eqI6p/QxJyLhBvJk2S5oqyDABSz+KktPtAB4jGLGlAm/y2y7ggdkiAv4ncMutIgMxK7uWtM+Pk8weNgz1OKnMdp3vwIr9IcO7XvBXZ4LIlhc6hjXUs3VNjDPQkV3zsIoOo0MDd8/yt4X3GdU82lwYBUv0KdwRCpN3movsPvanrtRLcvMK/7RRMIo7Tm6q5jQX9u+4VT87+79LKR6wtB5Bfw091Xk4rNJPWHiR7Z0+7WSG/f+q/EBaIk1FbqerumObSgICmasIY2Cb+LtOJZz4+M4xgZROX90FP4ExjiHq+dDZbl16M6wRVL88kpYWnSWCafR96rjayopS4DdcAV5IdXdGGqecvdMTa/iELaeqlL6d74NHD4r2lLOCWUFuufXPWbFa6Xo/nGMGbPHzVazLuAxpuGIK6fiqepq35Ux4Hv4EdFaFoEXRuyu4XWALFE34JU6CsepOK1gv4Lk0fk6Batyh6XE1GBOmjkIsEY3TlnTpmahblUZ03xtYoCisFrboJvGJ4/uxL3AzZAc3u5iQA0Cdb80BqyY4AsRll1VADuDmF9AgHigDbde1XjcytNVWMzydYwdbY2xuxi5AjXTUsxIPFYVNvqtwGldGaiRMo/mQNmo93RZ+dfVsmkcbBL8A7+oVhcxwIPp/EzA9wbUOinHQ7YAjZih0DXiKLpjNH3VBbV+GCmeOs32QFs1k8rYg0Nu3YPLLOeaxXZws3pE/45hcfAYfuVxJPRY3w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(376002)(396003)(46966006)(36840700001)(40470700004)(47076005)(336012)(36860700001)(86362001)(83380400001)(426003)(186003)(2616005)(7696005)(356005)(1076003)(6666004)(107886003)(26005)(82740400003)(478600001)(110136005)(54906003)(36756003)(5660300002)(81166007)(41300700001)(70586007)(70206006)(8676002)(8936002)(40460700003)(4326008)(40480700001)(2906002)(82310400005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 09:44:13.3360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ffa0c0-0c45-4b26-b61e-08da6fb4907c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2955
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 net/tls/tls_device.c | 63 ++++++++++++++++++++++----------------------
 2 files changed, 33 insertions(+), 32 deletions(-)

v3:
Rebased on top of 3d8c51b25a23 net/tls: Check for errors in tls_device_init
in which error handling for tls_device_init() is introduced.

diff --git a/include/net/tls.h b/include/net/tls.h
index abb050b0df83..b75b5727abdb 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -161,6 +161,8 @@ struct tls_offload_context_tx {
 
 	struct scatterlist sg_tx_data[MAX_SKB_FRAGS];
 	void (*sk_destruct)(struct sock *sk);
+	struct work_struct destruct_work;
+	struct tls_context *ctx;
 	u8 driver_state[] __aligned(8);
 	/* The TLS layer reserves room for driver specific state
 	 * Currently the belief is that there is not enough
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 7861086aaf76..6167999e5000 100644
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
@@ -104,16 +90,15 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 		return;
 	}
 
+	list_del(&ctx->list); /* Remove from tls_device_list / tls_device_down_list */
 	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
 	if (async_cleanup) {
-		list_move_tail(&ctx->list, &tls_device_gc_list);
+		struct tls_offload_context_tx *offload_ctx = tls_offload_ctx_tx(ctx);
 
-		/* schedule_work inside the spinlock
+		/* queue_work inside the spinlock
 		 * to make sure tls_device_down waits for that work.
 		 */
-		schedule_work(&tls_device_gc_work);
-	} else {
-		list_del(&ctx->list);
+		queue_work(destruct_wq, &offload_ctx->destruct_work);
 	}
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 
@@ -1160,6 +1145,9 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	start_marker_record->len = 0;
 	start_marker_record->num_frags = 0;
 
+	INIT_WORK(&offload_ctx->destruct_work, tls_device_tx_del_task);
+	offload_ctx->ctx = ctx;
+
 	INIT_LIST_HEAD(&offload_ctx->records_list);
 	list_add_tail(&start_marker_record->list, &offload_ctx->records_list);
 	spin_lock_init(&offload_ctx->lock);
@@ -1399,7 +1387,7 @@ static int tls_device_down(struct net_device *netdev)
 
 	up_write(&device_offload_lock);
 
-	flush_work(&tls_device_gc_work);
+	flush_workqueue(destruct_wq);
 
 	return NOTIFY_DONE;
 }
@@ -1440,12 +1428,23 @@ static struct notifier_block tls_dev_notifier = {
 
 int __init tls_device_init(void)
 {
-	return register_netdevice_notifier(&tls_dev_notifier);
+	int err;
+
+	destruct_wq = alloc_workqueue("ktls_device_destruct", 0, 0);
+	if (!destruct_wq)
+		return -ENOMEM;
+
+	err = register_netdevice_notifier(&tls_dev_notifier);
+	if (err)
+		destroy_workqueue(destruct_wq);
+
+	return err;
 }
 
 void __exit tls_device_cleanup(void)
 {
 	unregister_netdevice_notifier(&tls_dev_notifier);
-	flush_work(&tls_device_gc_work);
+	flush_workqueue(destruct_wq);
+	destroy_workqueue(destruct_wq);
 	clean_acked_data_flush();
 }
-- 
2.21.0

