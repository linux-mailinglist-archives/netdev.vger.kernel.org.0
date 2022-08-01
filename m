Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179095865F2
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiHAIBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 04:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHAIBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:01:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AB2FD02
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:01:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ui4VdvCGo+fI48jptdePnRRd6dIwM4fl3Fv8tK93R4t9BnMrdToW+UVju1dxf6Q2rbH/ei39Tqh3Ha1NehBbZs9r09G18CHYmlqFjvneOUMJtY6+3PrkY+RgHtEIvij5mLE/7mkUzfEfwathgzWENTHXqnPkc1es2AiL4vN3euMRU8fmuSd2j1U06/Xqw/0OsqNZgD3CxhsiPzZP0cHP9ot6FZW5eCGJkgaouj+zgqfq9ubyTz+VByHUu6Lsrre/xx5IA/QvTPyRlRylXwDHWy4tUzNbYAJFo1xkvMB6r83QPqatFElxkOmeey31YpAflwA3sZmak6dlRw6uAzDvFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aWcm32iXFDcU+ZeTfHxS3w9gLUdvnfULkFPV5KyWk8=;
 b=bITeLXJWmmY8ltZicN+NgdJIJKrxQnsBWi9hI86QbL/RZhwcyprpr8/voYarxtulsumA1kLE5F2MU/RcDSRcoSwjOhmuZR3z+Zvcq5rNuWo0ppCvTB9iXoV6LurSeeuQiSvUOY8kP6bwFyL8BrH9FVFfmjLpakqM6wLVBvR+zWnDECztk33A2AIpK1Ckz3uGOPVBe8cMmeYE3ohSKRF/A5QQbSooZ0GGRX5l08+c45n4rIF73h+gKHC4viyyswSOzRVDtYx8LLUt/pX3/XPH+6vG04eEmFWbX7qToMCsWnKATgh95wCKPnrQWI4r5PWyXc83MU4poOyFF1bgcd1deA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aWcm32iXFDcU+ZeTfHxS3w9gLUdvnfULkFPV5KyWk8=;
 b=ma1G3gI9fJBGLhOcV4H5RWEuk0dnf4quQ/xLcoa4rA+mXiMHFQ43lKaA9TZhifZs7Rg7EK+0zdoV/CsejUldWXAeG1OuvLI2AH5cUHAjPOMZLgBucNOZuwbfhhwvIz7GqAn8TnQQ8sgjBKOunSJfG8NDkfBumeN4Uo4mJfVhVkVf9gSzVi6UfqklEr31adpd5jKRkjNvPqeHXFJ2OjHU5LbHgfPmwjcj9J1WufvVOjC/EA96QDsWsX5Mu+DPq3NVyVymDOjGvULUnnzqsKhYGLoCmQJ8zmygNPCw5oUrwVNwoBBQZr3Bwu5NEJmzJpEEPrYRiLZm2INxKMvYeETJHQ==
Received: from DM6PR12CA0008.namprd12.prod.outlook.com (2603:10b6:5:1c0::21)
 by PH8PR12MB6675.namprd12.prod.outlook.com (2603:10b6:510:1c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 08:01:04 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::ac) by DM6PR12CA0008.outlook.office365.com
 (2603:10b6:5:1c0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15 via Frontend
 Transport; Mon, 1 Aug 2022 08:01:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Mon, 1 Aug 2022 08:01:03 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 1 Aug 2022 08:01:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 1 Aug 2022 01:01:02 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Mon, 1 Aug 2022 01:00:59 -0700
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
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Date:   Mon, 1 Aug 2022 11:00:53 +0300
Message-ID: <20220801080053.21849-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cea67ef5-2860-4f00-5fc2-08da7393fb3d
X-MS-TrafficTypeDiagnostic: PH8PR12MB6675:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2V9eMeGxC2gdJSMgNQTLezImAyN2ANlBeRyA4GWiJJcNRrRuoiMBTtu+AHzo+YFFADvPeoJ819S6M0+QM3lyTKUwHEE95HnozG+GmieY7iNigwopLbcz0xIyj0ELKAvGlmy9PyMk0uN2By/hnYE66FXuIq0S+MPBVSaARmkP57jQYSZ3imnBiv0d+BpfuqyQKoaeW54/LyOlAOFO4qcId5OhZuL8cU2t1eBAZw2fQd01OYsrq5L4CVwl0R7X01HpvXVsjEaAyJEswXT4TzMN4mn+GoW2COTo7lTQrj5Q8N9Cd7SAZtkNXfg3bh4/xUya1X5LTu/j2cBqiYBNbqAnDeH2gRNRu9wviGbt8XU/jXeYgkkrprr9pg4GsZYGXZgblAX6fZCjOESWNoC44C1C2YLt4qI3FCxsnCyJUobqtqEabrhIHg9MS1q/g9G9+mbW29yiIOPLYQPLdzoid0/PKZsHtgzy2lXCtngse+idBkhat4a7TgtjGL23S+v0JYwSJya7yVUKYTMRlX8gcrME5ThamoKOF/bW+IuPVsnGh2Xo7zL0/2X1UGm8dhMQn8hIb7kDR4wSKZAk0YY+wTBh26ggKxVRl2SIPLna8pPK32PDguvGiH/Y0cXNwRRU2FFl4sMlMijUdbc/LYk5WXcxsZjuKJ14aoRkUKl1+m4pb2AyGJgkzQT9HMzOFguY1RtILq7dIu1Rjh2M2OQ4ExMwR7FZ3AEwSX+n1/oXbKE40GSDGDFaTt6d0VdoSLI/Yc0Aokl2iRVUK0nQaIubarZdE7qIM7JsK8vuvDkZxLhtVhcjwv7QUGqU2J0buJDlnhNRXgJBeAK/iKHXpY1E1+/FcQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(39860400002)(396003)(46966006)(40470700004)(36840700001)(70586007)(2906002)(70206006)(8676002)(4326008)(8936002)(81166007)(356005)(5660300002)(82740400003)(1076003)(107886003)(478600001)(186003)(2616005)(40460700003)(47076005)(426003)(336012)(316002)(7696005)(41300700001)(26005)(36860700001)(54906003)(110136005)(6666004)(83380400001)(86362001)(36756003)(82310400005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 08:01:03.7742
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cea67ef5-2860-4f00-5fc2-08da7393fb3d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6675
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  2 +-
 include/net/tls.h                             |  2 +-
 net/tls/tls_device.c                          | 38 ++++++++++++++-----
 net/tls/tls_device_fallback.c                 |  3 +-
 4 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 6b6c7044b64a..d8dea2aa7ade 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -819,7 +819,7 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	mlx5e_tx_mpwqe_ensure_complete(sq);
 
 	tls_ctx = tls_get_ctx(skb->sk);
-	if (WARN_ON_ONCE(tls_ctx->netdev != netdev))
+	if (WARN_ON_ONCE(rcu_dereference_bh(tls_ctx->netdev) != netdev))
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
index 18c7e5c6d228..351d8959d80f 100644
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

