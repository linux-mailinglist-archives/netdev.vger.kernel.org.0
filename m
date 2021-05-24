Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C6438E65F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 14:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhEXMOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 08:14:09 -0400
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:49504
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232808AbhEXMOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 08:14:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebRsQAqrRcZqCQvD/t8aeAugWFlyaqrlzFUnzzfWkBQOItso66ccYodasfKU853Ifs0s9Lf7nzP5p/enIDKBZyWKT9RhnYmnEDhamzOcr+h8nSfMJ+Mz8kmN1h3MxYToPz0IsyEs6Ly1dqHC2O4J0/OEVqgfEGRJvJcpA3Fx+DOXVWk+IRbeN2IpQ3BYbU93zygC7O9e8Yg6Zz4+a26B+F47iBf789hYT0Xo6SwAcZh16FXiGDgokLpalR+xxx9liINQOkwGnlJgmHMsvceKvgef/FY7ThBBoVBYPsOVKcNSSR93mMnJDbZL9nlkHvgLtBRkY/JlEAzi+AX4aG1JXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXnB5h4pSrt36+EOykRw1Xn4xAKdZKJIyBj/MoJ0mD0=;
 b=Ptcxb3blfkMTJ9Hbk0e8I5hVqTeZjRb1N3ah/33DQ/TneR5niXkB8+maDj23Mnsb+zT5JWGkSj15E5JMC790xWKpmSLHZnAqyZVurSSJfEJ92+gIrc+3iwmlTrsi5OLRESXnANyV0GhdUZcHUxWZet1ZZxdb4eJ6foBDYeqFcCzW0BllVkfMcDw+fl3DFjBNVzgEBaBBMBuitoT65pZxeOPSQPHl6akShegAe3aBoqgonst19l3Md2NVPChqdYwycdVbOkQZ+rqMZG2dSmag5XG+mr8z4rProefeJ0eGNLajFkjXNhl9RJVasytQrYwxuBqexYpOSa4WuDW4b5ofZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXnB5h4pSrt36+EOykRw1Xn4xAKdZKJIyBj/MoJ0mD0=;
 b=of2Uw6NBqIENDkOkztaA301jE6jP17a8nyp69YkxUrZ56G5DPPA1xYcu72v70zxMi4TG8xtIUrFj51z4fmyIO+SLt1Y/euTp4gJNwS5mrAUNq8nq/iZ7AJnMMTAmglxrsRrKPchueVobbMur02iR7X3Z8fkdnCa/lhTMRA6M/NnpmIcz6Nu4iBafDEOgQ/e+X5u6aeBUyAHW58VTRo6lnpaEwdUIeaxUQ6vVOYgknRkqTfSPRylW488TsrIh9PNcgOoJHuQm4f3vOduo3iDpYzjTihntDZgymDWy3VqJK4FF7SGYQI9Lwe10iDh1OmbEHRdflv0Jr70KXhVp7c+C9Q==
Received: from DM6PR02CA0108.namprd02.prod.outlook.com (2603:10b6:5:1f4::49)
 by BYAPR12MB4711.namprd12.prod.outlook.com (2603:10b6:a03:95::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Mon, 24 May
 2021 12:12:35 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::c3) by DM6PR02CA0108.outlook.office365.com
 (2603:10b6:5:1f4::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend
 Transport; Mon, 24 May 2021 12:12:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 12:12:34 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 12:12:34 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 12:12:31 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net 2/2] net/tls: Fix use-after-free after the TLS device goes down and up
Date:   Mon, 24 May 2021 15:12:20 +0300
Message-ID: <20210524121220.1577321-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524121220.1577321-1-maximmi@nvidia.com>
References: <20210524121220.1577321-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c397fe0-13ca-42d3-5fb8-08d91ead36d3
X-MS-TrafficTypeDiagnostic: BYAPR12MB4711:
X-Microsoft-Antispam-PRVS: <BYAPR12MB47116F7B7A355EA33338EBB6DC269@BYAPR12MB4711.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gQeirb4u3vRZ7HvfUDS6isuIauSmQDDGxl9ZUu5SO/nSAOJo+X/eD1A6E90sRHBBve/7FkNHOVhBispmdFcd6YOQ8FthQbM05W83t+ew7Hqnm16urf0UcbLbuA/JbOWHz+hvj2jSe5sNMqF11ubGiJydbb3miEB21mlbl6f9GU3Riz8Y4st587xnSCi5R/2RlOQ1CZtT1s2RyyYCiAgP+Lai7hViEucMLD4FLx7NuLbH7T44pgC7rZksh8e8Qm2+IqTKVHwMkB26VsNGjoh8L3vewfRjfpSxChcVs7hm/i3Q/XnsZC3RAxBqZoITPKK+ycPOxNN1uOD2265m/W5pQ1cbQwYUaXs00DtXSkndRC1R22AJaNtyx0t9OW79hWLc4DkOqNl3nTLEUOVJw4GBUfYffaV2TFEiC4W5X9xpuc4N1QI79oxLWxvaHWLowuoCpqpmFJlJyuPjnrfQmnn8va0QUUyV15RGyPOm7bJUaALYmtknd5+U5Q+NQ9MwZsqWy6k0wFLLQ6hzPpvqFu6ntZdUln8M5KAroHozhdIG5HbgT6CKcRowPRKpqC5qIwy/Vb/h/6t8yURlI1IXfAEZ04igKOU74h/2vupP6Ivj86ZHHPPGkinjn2zr9JUNrFAC5snS3xwV7F4dka0SVxy2wMftXaZI9duiLonl7ITbah8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(376002)(36840700001)(46966006)(1076003)(36756003)(83380400001)(47076005)(82310400003)(6636002)(7636003)(82740400003)(7696005)(26005)(8676002)(6666004)(186003)(356005)(2616005)(70586007)(70206006)(36860700001)(54906003)(110136005)(86362001)(5660300002)(107886003)(478600001)(4326008)(426003)(336012)(36906005)(316002)(8936002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 12:12:34.6564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c397fe0-13ca-42d3-5fb8-08d91ead36d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a netdev with active TLS offload goes down, tls_device_down is
called to stop the offload and tear down the TLS context. However, the
socket stays alive, and it still points to the TLS context, which is now
deallocated. If a netdev goes up, while the connection is still active,
and the data flow resumes after a number of TCP retransmissions, it will
lead to a use-after-free of the TLS context.

This commit addresses this bug by keeping the context alive until its
normal destruction, and implements the necessary fallbacks, so that the
connection can resume in software (non-offloaded) kTLS mode.

On the TX side tls_sw_fallback is used to encrypt all packets. The RX
side already has all the necessary fallbacks, because receiving
non-decrypted packets is supported. The thing needed on the RX side is
to block resync requests, which are normally produced after receiving
non-decrypted packets.

The necessary synchronization is implemented for a graceful teardown:
first the fallbacks are deployed, then the driver resources are released
(it used to be possible to have a tls_dev_resync after tls_dev_del).

A new flag called TLS_RX_DEV_DEGRADED is added to indicate the fallback
mode. It's used to skip the RX resync logic completely, as it becomes
useless, and some objects may be released (for example, resync_async,
which is allocated and freed by the driver).

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/tls.h             |  9 ++++++
 net/tls/tls_device.c          | 52 +++++++++++++++++++++++++++++++----
 net/tls/tls_device_fallback.c |  8 ++++++
 net/tls/tls_main.c            |  1 +
 4 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 6531ace2a68b..8341a8d1e807 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -193,6 +193,11 @@ struct tls_offload_context_tx {
 	(sizeof(struct tls_offload_context_tx) + TLS_DRIVER_STATE_SIZE_TX)
 
 enum tls_context_flags {
+	/* tls_device_down was called after the netdev went down, device state
+	 * was released, and kTLS works in software, even though rx_conf is
+	 * still TLS_HW (needed for transition).
+	 */
+	TLS_RX_DEV_DEGRADED = 0,
 	/* Unlike RX where resync is driven entirely by the core in TX only
 	 * the driver knows when things went out of sync, so we need the flag
 	 * to be atomic.
@@ -265,6 +270,7 @@ struct tls_context {
 
 	/* cache cold stuff */
 	struct proto *sk_proto;
+	struct sock *sk;
 
 	void (*sk_destruct)(struct sock *sk);
 
@@ -447,6 +453,9 @@ static inline u16 tls_user_config(struct tls_context *ctx, bool tx)
 struct sk_buff *
 tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
 		      struct sk_buff *skb);
+struct sk_buff *
+tls_validate_xmit_skb_sw(struct sock *sk, struct net_device *dev,
+			 struct sk_buff *skb);
 
 static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 {
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 171752cd6910..bd9f1567aa39 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -50,6 +50,7 @@ static void tls_device_gc_task(struct work_struct *work);
 static DECLARE_WORK(tls_device_gc_work, tls_device_gc_task);
 static LIST_HEAD(tls_device_gc_list);
 static LIST_HEAD(tls_device_list);
+static LIST_HEAD(tls_device_down_list);
 static DEFINE_SPINLOCK(tls_device_lock);
 
 static void tls_device_free_ctx(struct tls_context *ctx)
@@ -759,6 +760,8 @@ void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq)
 
 	if (tls_ctx->rx_conf != TLS_HW)
 		return;
+	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags)))
+		return;
 
 	prot = &tls_ctx->prot_info;
 	rx_ctx = tls_offload_ctx_rx(tls_ctx);
@@ -961,6 +964,17 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 
 	ctx->sw.decrypted |= is_decrypted;
 
+	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
+		if (likely(is_encrypted || is_decrypted))
+			return 0;
+
+		/* After tls_device_down disables the offload, the next SKB will
+		 * likely have initial fragments decrypted, and final ones not
+		 * decrypted. We need to reencrypt that single SKB.
+		 */
+		return tls_device_reencrypt(sk, skb);
+	}
+
 	/* Return immediately if the record is either entirely plaintext or
 	 * entirely ciphertext. Otherwise handle reencrypt partially decrypted
 	 * record.
@@ -1290,6 +1304,26 @@ static int tls_device_down(struct net_device *netdev)
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 
 	list_for_each_entry_safe(ctx, tmp, &list, list)	{
+		/* Stop offloaded TX and switch to the fallback.
+		 * tls_is_sk_tx_device_offloaded will return false.
+		 */
+		WRITE_ONCE(ctx->sk->sk_validate_xmit_skb, tls_validate_xmit_skb_sw);
+
+		/* Stop the RX and TX resync.
+		 * tls_dev_resync must not be called after tls_dev_del.
+		 */
+		WRITE_ONCE(ctx->netdev, NULL);
+
+		/* Start skipping the RX resync logic completely. */
+		set_bit(TLS_RX_DEV_DEGRADED, &ctx->flags);
+
+		/* Sync with inflight packets. After this point:
+		 * TX: no non-encrypted packets will be passed to the driver.
+		 * RX: resync requests from the driver will be ignored.
+		 */
+		synchronize_net();
+
+		/* Release the offload context on the driver side. */
 		if (ctx->tx_conf == TLS_HW)
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_TX);
@@ -1297,13 +1331,21 @@ static int tls_device_down(struct net_device *netdev)
 		    !test_bit(TLS_RX_DEV_CLOSED, &ctx->flags))
 			netdev->tlsdev_ops->tls_dev_del(netdev, ctx,
 							TLS_OFFLOAD_CTX_DIR_RX);
-		WRITE_ONCE(ctx->netdev, NULL);
-		synchronize_net();
+
 		dev_put(netdev);
-		list_del_init(&ctx->list);
 
-		if (refcount_dec_and_test(&ctx->refcount))
-			tls_device_free_ctx(ctx);
+		/* Move the context to a separate list for two reasons:
+		 * 1. When the context is deallocated, list_del is called.
+		 * 2. It's no longer an offloaded context, so we don't want to
+		 *    run offload-specific code on this context.
+		 */
+		spin_lock_irqsave(&tls_device_lock, flags);
+		list_move_tail(&ctx->list, &tls_device_down_list);
+		spin_unlock_irqrestore(&tls_device_lock, flags);
+
+		/* Device contexts for RX and TX will be freed in on sk_destruct
+		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
+		 */
 	}
 
 	up_write(&device_offload_lock);
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index cacf040872c7..a72c89b48a59 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -431,6 +431,14 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(tls_validate_xmit_skb);
 
+struct sk_buff *tls_validate_xmit_skb_sw(struct sock *sk,
+					 struct net_device *dev,
+					 struct sk_buff *skb)
+{
+	return tls_sw_fallback(sk, skb);
+}
+EXPORT_SYMBOL_GPL(tls_validate_xmit_skb_sw);
+
 struct sk_buff *tls_encrypt_skb(struct sk_buff *skb)
 {
 	return tls_sw_fallback(skb->sk, skb);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 47b7c5334c34..fde56ff49163 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -636,6 +636,7 @@ struct tls_context *tls_ctx_create(struct sock *sk)
 	mutex_init(&ctx->tx_lock);
 	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
 	ctx->sk_proto = READ_ONCE(sk->sk_prot);
+	ctx->sk = sk;
 	return ctx;
 }
 
-- 
2.25.1

