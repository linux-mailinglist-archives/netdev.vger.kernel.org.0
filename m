Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643053972FF
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhFAMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:10:11 -0400
Received: from mail-bn8nam12on2069.outbound.protection.outlook.com ([40.107.237.69]:57070
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231201AbhFAMKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 08:10:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbl8XH9M5lwtwc4WWdI6SWRIFGqTWgY0Y4WXIIdh8TZyzZ5uQPhA/uaz9MYovV05RXYN6TeIw1j9RCYaxLTc3afo/l/L0/JjeDLvKTBLUhX0zmj5KWm+3V+31Wq+3cZyRCKug2H9hdUQKERz7cMcg6u8ntfFKn2Ng0UFmQjpC8NeOt+FrNl0xngyFqV14Vvgi7m/SBY3EZWjAd9ZecEz5WDg2hVy4A9ZR80DSCazrwKd15+egZl9diTYDRC2ziAtr8E//sominllCNIa82HqWYiOT5mFyEq/q0IjtctaoXreivFdMHg9kLtDZjx/LKNYV3iNu62mDJaSCAYCRa8iag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2Y9GqSHpGEk/JhDQ5pklj5RoDVjugprC7vsGpN9p2g=;
 b=jC6cPZ4uQoKC/FlhaLNAx5Z5WLYNryCT2am5bex/h2AyMEi1wuW41xOiDMPlE5c7EYIUOaq+iuq6eVQgjWMsyCIFZ80xy/QpTfrCu0PXNMmE1e5hcOgiY/+UAd9g2IxkahBBB0xbwLdW3iF/vpVOi3WV+YYLymMBBEMVZhbgRSpXQ6Ax3IyMI5OsPiR9dMZwh5pazxWX91fU6bnbRT+KWa7SOGaM7kT8EMSVLNQs2aRsvdUbI/w5qveUa44KxaVwDkHvP+sfeLmxyd3JkUSPbnJg3ZrpHhrUannUZB7gWCRNyLJ2syWcQc/UMrEAkBvCfRssbvE6T1UHSQOeoHVlLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2Y9GqSHpGEk/JhDQ5pklj5RoDVjugprC7vsGpN9p2g=;
 b=IuIrle4TVU4ZsXqxgeX3bEmzDoFLDcIl5B25uxJCY5nV9YA1TwZYqW519mlWdwLmraKELneE6M6RO/VE6XkqjKTaXrEQLbQZt3GKzneAeF9J+0PEFQDCiyvZ3NxJqDHUdB7M/Zttt+35eYSyx4wUHo/ZwCNmC5qAUWsYDL0gV77VPT2INIHLfgbULAQJUlNFr315vITTstrC61HfEdikp85JGtuZ0UNmdAG/pKS8uhUFwZAHTJDDX/F7DZYNNUsQQAxgmGZPlXoPCQWHYBfTPxBtvr+3Of5NY7S7vMqp6oBjMQLpzLD1+Et6Iy/xgc3krx0Mc8IiIT9NrXxaw06JVA==
Received: from BN0PR04CA0027.namprd04.prod.outlook.com (2603:10b6:408:ee::32)
 by DM6PR12MB2777.namprd12.prod.outlook.com (2603:10b6:5:51::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.29; Tue, 1 Jun
 2021 12:08:27 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::b3) by BN0PR04CA0027.outlook.office365.com
 (2603:10b6:408:ee::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Tue, 1 Jun 2021 12:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Tue, 1 Jun 2021 12:08:26 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Jun
 2021 05:08:25 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Jun 2021 05:08:19 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Aviad Yehezkel" <aviadye@nvidia.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH net v2 2/2] net/tls: Fix use-after-free after the TLS device goes down and up
Date:   Tue, 1 Jun 2021 15:08:00 +0300
Message-ID: <20210601120800.2177503-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601120800.2177503-1-maximmi@nvidia.com>
References: <20210601120800.2177503-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1cdae2c-3120-4c31-ccd2-08d924f5f66d
X-MS-TrafficTypeDiagnostic: DM6PR12MB2777:
X-Microsoft-Antispam-PRVS: <DM6PR12MB277752E768ADA31470CA883EDC3E9@DM6PR12MB2777.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZgpISjxfBLts3ZFr2BZocrDugaapjObd7moVYdTXbLrzjxSnpDDp8TB33ZKWNtXTxLAfDnYcP+vkK9DV0Em8bxUUtXIe2V/d1KlmuX8Ogkl/+nNBtDOBn0dVeIK/ueH94n/xDmt6lATUcy/VnUfl1SePuZBC+lQ0dvf/mqG1gBmTvq1F9r89j08nWLoFZNmJC/cFFr3WLOiSES5XudsBxaJ+E648i5EPXDLzsCHzq62RGh291BQkg/86RBfdfUmfbCjK3HchBtRKJWcDvBe2zUTbwtPrZVIf1z/sHOLZ+90VtPIr5zAOJnG+/uiEmq8BWbddf6UNSgI++y3j3kPK4h/pXG/Qb/LB0ragSxHbLofw8p4ET6RAaBX/6Rti5LfZ5Nib5NOB2CCAW9N8LReHmpC+LpXOppqcKfxWuNqmfQ3/0OEaR2l6wSkU0SGeB2PiihVxCgNEx09P7sShzEmOuCjB35g2WBoVytQRpif4y/WwENekwhJYhXsxLhbOKzQCrqLSMYxdJIrI0bYLHx888hfp0uT98/WAnUrw0jd1teSmwWHV47X3gc8JdMl2sRiVNA7xjakYPb+rmeTlY7n3fHrWd4v2hr16FL9/QdzfuvAnCUGvAcdUV0ih+rD/n8rsXRY65h4EE89UubCat1IN6+g4EcY5D3N7Jhp0ExIkM+c=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(36840700001)(46966006)(6666004)(70586007)(426003)(36860700001)(70206006)(336012)(36756003)(2906002)(1076003)(7696005)(478600001)(2616005)(82310400003)(316002)(356005)(6636002)(83380400001)(8936002)(82740400003)(47076005)(5660300002)(107886003)(8676002)(186003)(7636003)(4326008)(26005)(110136005)(54906003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 12:08:26.7825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1cdae2c-3120-4c31-ccd2-08d924f5f66d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2777
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
 net/tls/tls_device_fallback.c |  7 +++++
 net/tls/tls_main.c            |  1 +
 4 files changed, 64 insertions(+), 5 deletions(-)

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
index cacf040872c7..e40bedd112b6 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -431,6 +431,13 @@ struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
 }
 EXPORT_SYMBOL_GPL(tls_validate_xmit_skb);
 
+struct sk_buff *tls_validate_xmit_skb_sw(struct sock *sk,
+					 struct net_device *dev,
+					 struct sk_buff *skb)
+{
+	return tls_sw_fallback(sk, skb);
+}
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

