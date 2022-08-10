Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C04858E884
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiHJIQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiHJIQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:16:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94BF52E76
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:16:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSTEPGpueYIJEWh1jgKvdtkN6J7ljfpTyeOAj0YE5M1SrMMZoZ6mWURcbZcz6BcsEWbAkUO/7cjUSIpIvKnuWvWjfj31OW5UY5xsKXu6PHTwA8OiDRKikMmoQ0g2aAgld0P8lqoV4Xc5ifdf+tsQtjIeT86tpTeulIU9JX+qNd0t09yeUuAsXxWucuw1NioC5/SlcMgdpSAtXiiFm35SVFLcegUVolI7LBY7fDKWCtaSlif80hdoiJu+GeFHlZeFQGfT7SeMtSmmNTSc5gXLl6NGHj3kt9IBnwI8AwCNujmEuqMAWYxOAoh5FZjouCYLpo1vmUh/y0APBNO9HPapGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7a2SLgQeGD3039FMUPDCun46VZ9oyHzKTQyRAu8CW4=;
 b=XCw0V1GEbDI4vOEb5RgRwZ3rpdIpPif05H2WfQgY4gg9dZ0IbcngHWprb8wZz5SuL/nZ46acJE39WfaMfSmeR4jS5MsG/8Rf9SMmynrigCKE0ABlg2DJCLeu9FJow/q8a+RDsuclm61uXub2I0MJsWaKxpTG6ilIIeHe3T4pEMfIB42T8bizmPnEi6Eixt5FyA0J+woYs23DMOcRkcFxRBZFFjfd6NLUBjR+Ol3HREzb7LEa5uVNN8VKc9iuTwAgG2RgXlsiexE3M8e5EltFEHcZB7JoQ6myIglZMfW8PfkgpqgRKqnKq6u43wMR1CWyssANCuexIshMd/cNF/xrtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s7a2SLgQeGD3039FMUPDCun46VZ9oyHzKTQyRAu8CW4=;
 b=IpnM5T/wuqmmaZi7QA3GOqrRgki3THcQHMB7rIfmbS2etTAevJ0WTCvGz18CeSv+2G08eN+KjpoPEo3JEIhRfcp+ciGknPE/0yNWlgCt9BCXAzaCIaocqU7tqRonZR0DjvbpTf83j/aXbUE5jVZCV867dSBo4swC3o69lxyFZaH5lNUtJWpUqKt0a2spMkqasuQrGseYQS5tibIydDjxgaSFebQSaA7G2ZIMqPxeRbhME7Fl9eMWtyuXjJGqa6gBUTUzpxAl8FOV6Zqrrrk3xwC6x/SBS5iMvjK2IHrKINu2MLWs1S/2IjA9oGoezn3jG97OMAjJM7Hdv5/xFeOugQ==
Received: from DS7PR05CA0033.namprd05.prod.outlook.com (2603:10b6:8:2f::20) by
 IA1PR12MB6652.namprd12.prod.outlook.com (2603:10b6:208:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 08:16:12 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::48) by DS7PR05CA0033.outlook.office365.com
 (2603:10b6:8:2f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.9 via Frontend
 Transport; Wed, 10 Aug 2022 08:16:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Wed, 10 Aug 2022 08:16:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 10 Aug 2022 08:16:11 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 10 Aug 2022 01:16:10 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 10 Aug 2022 01:16:05 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "Vinay Kumar Yadav" <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net v2] net/tls: Use RCU API to access tls_ctx->netdev
Date:   Wed, 10 Aug 2022 11:16:02 +0300
Message-ID: <20220810081602.1435800-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c522280-489a-4b0c-3d7f-08da7aa89620
X-MS-TrafficTypeDiagnostic: IA1PR12MB6652:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HfwxLCeK3rsP5ssdmVxuS8/zbSvtzkbSb7vtPtopdmEbJzMKtr2FU2Cs9eyBZcQaXDdRkNAlOy39GJ3aXR0DUs8fT1jJuu6O9k4iJ9wkLoogXWH39SjJK66ZwBZhRwbxt+BVxK1GXXC9lzgORnzLfFoDzcZqLSWjg61WTn1rpg2KPTfnIt4f4l6Lma+NMe6kFmPQg2QN7+yUn2376WPdKC+rsyb489F4J4drKYuZOPhMO/KD5iiqT/m+GsgNqbiqJy8VgqkfKZRFzHRpQqOqC1n5eZH6ql0Sgq4J+jt0cHgCULUC55V8lPNMdXPjfPp7u1S0pxoS0RNxvoiV9u3jZa6uA7NxoIaeYyWHzdoCgv0ovrckQFZO3Pe7VUm0QUBTuabmCtx8/fmcUG/hDPgF6UwdV9t+EhscCBSQXYw8UZFKy1YiSPKHCio1TE3t5F3WVPH1o6uXw1w3tRrRyNZ8CXI4HDTI2SKnvOcjptvRnKzc26zTmhBexV9o8EWBI1WkvCKtrlMc/KODuFI6l1pdEjMjg02wq2fqancwKln83ZHtWEnrS/rHCWu8/+gBtHQjna0Ow26x9/1FdgjBRzCqQfJHJZZXN6C6/iqVqE7KrV9cb79g00RPsISw2pVVbEaek5Bn+rLzTAblFaSOCE/+93uiPZUf4lBzL62O3l2ov6WdLMi2hV7biJJicK32l79puFrv3PmrMAbPWC1kfOaBxdqMikIb6aI8QmTbl/zkcN9ugeaADse2T6U2w6K+srcJZWgfp5CREeh3re6uW+uUhQq49U0CfBmWDX/egzBDi0c2P8sONxCuVW7XSUv6kbHvheaEjV7fMaxPklNbGz6l7g==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(46966006)(36840700001)(40470700004)(356005)(82740400003)(7696005)(81166007)(41300700001)(6666004)(86362001)(26005)(36860700001)(83380400001)(40460700003)(2616005)(107886003)(336012)(186003)(1076003)(47076005)(426003)(7416002)(5660300002)(8936002)(8676002)(4326008)(70586007)(70206006)(40480700001)(82310400005)(36756003)(2906002)(54906003)(110136005)(316002)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 08:16:11.6886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c522280-489a-4b0c-3d7f-08da7aa89620
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6652
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, tls_device_down synchronizes with tls_device_resync_rx using
RCU, however, the pointer to netdev is stored using WRITE_ONCE and
loaded using READ_ONCE.

Although such approach is technically correct (rcu_dereference is
essentially a READ_ONCE, and rcu_assign_pointer uses WRITE_ONCE to store
NULL), using special RCU helpers for pointers is more valid, as it
includes additional checks and might change the implementation
transparently to the callers.

Mark the netdev pointer as __rcu and use the correct RCU helpers to
access it. For non-concurrent access pass the right conditions that
guarantee safe access (locks taken, refcount value). Also use the
correct helper in mlx5e, where even READ_ONCE was missing.

The transition to RCU exposes existing issues, fixed by this commit:

1. bond_tls_device_xmit could read netdev twice, and it could become
NULL the second time, after the NULL check passed.

2. Drivers shouldn't stop processing the last packet if tls_device_down
just set netdev to NULL, before tls_dev_del was called. This prevents a
possible packet drop when transitioning to the fallback software mode.

Fixes: 89df6a810470 ("net/bonding: Implement TLS TX device offload")
Fixes: c55dcdd435aa ("net/tls: Fix use-after-free after the TLS device goes down and up")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 drivers/net/bonding/bond_main.c               | 10 ++++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  8 +++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  8 +++-
 include/net/tls.h                             |  2 +-
 net/tls/tls_device.c                          | 38 ++++++++++++++-----
 net/tls/tls_device_fallback.c                 |  3 +-
 6 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ab7fdbbc2530..50e60843020c 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5338,8 +5338,14 @@ static struct net_device *bond_sk_get_lower_dev(struct net_device *dev,
 static netdev_tx_t bond_tls_device_xmit(struct bonding *bond, struct sk_buff *skb,
 					struct net_device *dev)
 {
-	if (likely(bond_get_slave_by_dev(bond, tls_get_ctx(skb->sk)->netdev)))
-		return bond_dev_queue_xmit(bond, skb, tls_get_ctx(skb->sk)->netdev);
+	struct net_device *tls_netdev = rcu_dereference(tls_get_ctx(skb->sk)->netdev);
+
+	/* tls_netdev might become NULL, even if tls_is_sk_tx_device_offloaded
+	 * was true, if tls_device_down is running in parallel, but it's OK,
+	 * because bond_get_slave_by_dev has a NULL check.
+	 */
+	if (likely(bond_get_slave_by_dev(bond, tls_netdev)))
+		return bond_dev_queue_xmit(bond, skb, tls_netdev);
 	return bond_tx_drop(dev, skb);
 }
 #endif
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index bfee0e4e54b1..172dcf4b58fa 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1932,6 +1932,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	int data_len, qidx, ret = 0, mss;
 	struct tls_record_info *record;
 	struct chcr_ktls_info *tx_info;
+	struct net_device *tls_netdev;
 	struct tls_context *tls_ctx;
 	struct sge_eth_txq *q;
 	struct adapter *adap;
@@ -1945,7 +1946,12 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	mss = skb_is_gso(skb) ? skb_shinfo(skb)->gso_size : data_len;
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (unlikely(tls_ctx->netdev != dev))
+	tls_netdev = rcu_dereference_bh(tls_ctx->netdev);
+	/* Don't quit on NULL: if tls_device_down is running in parallel,
+	 * netdev might become NULL, even if tls_is_sk_tx_device_offloaded was
+	 * true. Rather continue processing this packet.
+	 */
+	if (unlikely(tls_netdev && tls_netdev != dev))
 		goto out;
 
 	tx_ctx = chcr_get_ktls_tx_context(tls_ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 6b6c7044b64a..659332f3dcb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -808,6 +808,7 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 {
 	struct mlx5e_ktls_offload_context_tx *priv_tx;
 	struct mlx5e_sq_stats *stats = sq->stats;
+	struct net_device *tls_netdev;
 	struct tls_context *tls_ctx;
 	int datalen;
 	u32 seq;
@@ -819,7 +820,12 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	mlx5e_tx_mpwqe_ensure_complete(sq);
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
+	tls_netdev = rcu_dereference_bh(tls_ctx->netdev);
+	/* Don't WARN on NULL: if tls_device_down is running in parallel,
+	 * netdev might become NULL, even if tls_is_sk_tx_device_offloaded was
+	 * true. Rather continue processing this packet.
+	 */
+	if (WARN_ON_ONCE(tls_netdev && tls_netdev != netdev))
 		goto err_out;
 
 	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
diff --git a/include/net/tls.h b/include/net/tls.h
index b75b5727abdb..cb205f9d9473 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -237,7 +237,7 @@ struct tls_context {
 	void *priv_ctx_tx;
 	void *priv_ctx_rx;
 
-	struct net_device *netdev;
+	struct net_device __rcu *netdev;
 
 	/* rw cache line */
 	struct cipher_context tx;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index e3e6cf75aa03..a0cd1c950437 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -71,7 +71,13 @@ static void tls_device_tx_del_task(struct work_struct *work)
 	struct tls_offload_context_tx *offload_ctx =
 		container_of(work, struct tls_offload_context_tx, destruct_work);
 	struct tls_context *ctx = offload_ctx->ctx;
-	struct net_device *netdev = ctx->netdev;
+	struct net_device *netdev;
+
+	/* Safe, because this is the destroy flow, refcount is 0, so
+	 * tls_device_down can't store this field in parallel.
+	 */
+	netdev = rcu_dereference_protected(ctx->netdev,
+					   !refcount_read(&ctx->refcount));
 
 	netdev->tlsdev_ops->tls_dev_del(netdev, ctx, TLS_OFFLOAD_CTX_DIR_TX);
 	dev_put(netdev);
@@ -81,6 +87,7 @@ static void tls_device_tx_del_task(struct work_struct *work)
 
 static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 {
+	struct net_device *netdev;
 	unsigned long flags;
 	bool async_cleanup;
 
@@ -91,7 +98,14 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	}
 
 	list_del(&ctx->list); /* Remove from tls_device_list / tls_device_down_list */
-	async_cleanup = ctx->netdev && ctx->tx_conf == TLS_HW;
+
+	/* Safe, because this is the destroy flow, refcount is 0, so
+	 * tls_device_down can't store this field in parallel.
+	 */
+	netdev = rcu_dereference_protected(ctx->netdev,
+					   !refcount_read(&ctx->refcount));
+
+	async_cleanup = netdev && ctx->tx_conf == TLS_HW;
 	if (async_cleanup) {
 		struct tls_offload_context_tx *offload_ctx = tls_offload_ctx_tx(ctx);
 
@@ -229,7 +243,8 @@ static void tls_device_resync_tx(struct sock *sk, struct tls_context *tls_ctx,
 
 	trace_tls_device_tx_resync_send(sk, seq, rcd_sn);
 	down_read(&device_offload_lock);
-	netdev = tls_ctx->netdev;
+	netdev = rcu_dereference_protected(tls_ctx->netdev,
+					   lockdep_is_held(&device_offload_lock));
 	if (netdev)
 		err = netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq,
 							 rcd_sn,
@@ -710,7 +725,7 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 
 	trace_tls_device_rx_resync_send(sk, seq, rcd_sn, rx_ctx->resync_type);
 	rcu_read_lock();
-	netdev = READ_ONCE(tls_ctx->netdev);
+	netdev = rcu_dereference(tls_ctx->netdev);
 	if (netdev)
 		netdev->tlsdev_ops->tls_dev_resync(netdev, sk, seq, rcd_sn,
 						   TLS_OFFLOAD_CTX_DIR_RX);
@@ -1029,7 +1044,7 @@ static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
 	if (sk->sk_destruct != tls_device_sk_destruct) {
 		refcount_set(&ctx->refcount, 1);
 		dev_hold(netdev);
-		ctx->netdev = netdev;
+		RCU_INIT_POINTER(ctx->netdev, netdev);
 		spin_lock_irq(&tls_device_lock);
 		list_add_tail(&ctx->list, &tls_device_list);
 		spin_unlock_irq(&tls_device_lock);
@@ -1300,7 +1315,8 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 	struct net_device *netdev;
 
 	down_read(&device_offload_lock);
-	netdev = tls_ctx->netdev;
+	netdev = rcu_dereference_protected(tls_ctx->netdev,
+					   lockdep_is_held(&device_offload_lock));
 	if (!netdev)
 		goto out;
 
@@ -1309,7 +1325,7 @@ void tls_device_offload_cleanup_rx(struct sock *sk)
 
 	if (tls_ctx->tx_conf != TLS_HW) {
 		dev_put(netdev);
-		tls_ctx->netdev = NULL;
+		rcu_assign_pointer(tls_ctx->netdev, NULL);
 	} else {
 		set_bit(TLS_RX_DEV_CLOSED, &tls_ctx->flags);
 	}
@@ -1329,7 +1345,11 @@ static int tls_device_down(struct net_device *netdev)
 
 	spin_lock_irqsave(&tls_device_lock, flags);
 	list_for_each_entry_safe(ctx, tmp, &tls_device_list, list) {
-		if (ctx->netdev != netdev ||
+		struct net_device *ctx_netdev =
+			rcu_dereference_protected(ctx->netdev,
+						  lockdep_is_held(&device_offload_lock));
+
+		if (ctx_netdev != netdev ||
 		    !refcount_inc_not_zero(&ctx->refcount))
 			continue;
 
@@ -1346,7 +1366,7 @@ static int tls_device_down(struct net_device *netdev)
 		/* Stop the RX and TX resync.
 		 * tls_dev_resync must not be called after tls_dev_del.
 		 */
-		WRITE_ONCE(ctx->netdev, NULL);
+		rcu_assign_pointer(ctx->netdev, NULL);
 
 		/* Start skipping the RX resync logic completely. */
 		set_bit(TLS_RX_DEV_DEGRADED, &ctx->flags);
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index 618cee704217..7dfc8023e0f1 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -426,7 +426,8 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 				      struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	if (dev == tls_get_ctx(sk)->netdev || netif_is_bond_master(dev))
+	if (dev == rcu_dereference_bh(tls_get_ctx(sk)->netdev) ||
+	    netif_is_bond_master(dev))
 		return skb;
 
 	return tls_sw_fallback(sk, skb);
-- 
2.25.1

