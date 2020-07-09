Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE921A2CE
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 16:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgGIO4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 10:56:34 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:13415
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726970AbgGIO4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 10:56:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGdnXRbAFR9wi2ilhLZM/JNerQtIPwprt+Nxbegz9vTbf3OqqGNj7jBXPztUC1qocl2Tj+keL695uUcyjN7BD6wbqbqL6YkQsV6n38wmsDGmmFExRakiOAtnCMPSaLcF/XVPvevNMYq61Evr9mwmVH5tcgyKQXvo6iACoHAgIArEqXTo5bSAP5QhN7OOB3heSWDVFGED0SR1i2Oko40KCXRZn9cthzv/utqVdSgIeJI9OZUjg6oQjnCxG+PCGh6WepYV7KKHor6QWedRHiZKtLX72cwsR338UF5AStZUA34o39f0C0BWtJuBUVwx2A6+TZbwfsepVrIM1Y5ZONs34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/VomMYIA4yTdZdOzeeyCM75LjOMLuKKMPbzpw/3pa0=;
 b=C7tkcZYDi0+AEyEDQiZYjwmJ8kC7Oebdmkgq7ZBHLmOmnobpiMmx2xY8KcjIAfUdcnfgOjTQ06ugRpV3Osk1az1M4jfA0nRIL3j9TxG4LCsxrycC0X5baBbsabBJ5Zjtr0p8VwgMA2FXHwjaufGW9BxCNrD6qjFEF83HbzqTrDAtnuEgvajuQB0GETaLRd/e02LVHOprT52kG6S8dkrWrMyNNqKYt+hL1tRvbNvJxGokYbeFf89n6UDM6eY2KMBj0OrnVAmel60C8BsqmOYoaRfklPkGd9HRBMTekMEFJd6cosYdUPv+JqelgyVSQFgb/MQ+7R/u8wH79+ScDTRJbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/VomMYIA4yTdZdOzeeyCM75LjOMLuKKMPbzpw/3pa0=;
 b=VmdGc/e6X4D8XBgSWnLEclTcfbMAIGsmJSC7qnQchOVG1N2oZnRmLrBSrH7vA6+wT7XrTGSzwHuJchznFYe+pZKNFUrzbk4GZTc1iiYjwa9ZMGuWmhRwR4cwPjSfrLqaaxxw24dB2z06d1OotHXAS/knMzp5cETad9pC3ZQI63g=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM5PR0502MB2915.eurprd05.prod.outlook.com (2603:10a6:203:9e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Thu, 9 Jul
 2020 14:56:22 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 14:56:22 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        Fijalkowski Maciej <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        cristian.dumitrescu@intel.com,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH 2/2] xsk: i40e: ice: ixgbe: mlx5: rename xsk zero-copy driver interfaces
Date:   Thu,  9 Jul 2020 17:56:34 +0300
Message-Id: <20200709145634.4986-2-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200709145634.4986-1-maximmi@mellanox.com>
References: <CAJ8uoz2sud5wBFpWKfC-i4n9E77KnQWGPsKLysumsA23pHEjEQ@mail.gmail.com>
 <20200709145634.4986-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0021.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::34) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR07CA0021.eurprd07.prod.outlook.com (2603:10a6:208:ac::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Thu, 9 Jul 2020 14:56:21 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b3ba0e4a-4a9a-4c37-7aaf-08d824183ec7
X-MS-TrafficTypeDiagnostic: AM5PR0502MB2915:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0502MB29159D2A0D27597AECD3341AD1640@AM5PR0502MB2915.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-Forefront-PRVS: 04599F3534
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJAK6QORiRCZH3uXtAgbBOWw/ZCYQrSCzodnZj/iOGMiduyzyiUZK85Ey1KBTDJKp+Dkwo/zi0r8XQEdZBAdyQ+lubps1rxWJ9i29hyEuNgmAdr1OcMCRlzjGqaeWxtFX/H11+METzFk80+JLWTSgZMX6oFaA5iT4NN2MKeNCtygtY2wLUgZ1cLaL176L8PJ6W5+aRTe6N7QBfu36DmDS7bcxunFfXlsHuCXL93p4e+pb4ZoSe9lIU73eYKcNyVevRgxv6AhQ+OtmK6+XSo6ujmAfrJkasze2UJS+qrNSMKesEJhnw/mltmUUF7yl3OM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(36756003)(6916009)(186003)(4326008)(16526019)(478600001)(6512007)(86362001)(83380400001)(6666004)(8676002)(54906003)(1076003)(956004)(2906002)(6506007)(8936002)(2616005)(6486002)(52116002)(26005)(7416002)(66556008)(66476007)(107886003)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: elIWpunpNo+fGJTtW+yzqEcmiojh9qtkrlldBR5l+iB5gFdFl+caMau+gWykRMjim5KYqyH8LFE2UzNEqMitpZPuZUVWBQoHE/1s872R66iRtyQ8rkkiESwn1ZRfZzRH2DhLexaMjA2UIyEP1CGvKCI/sk8sKxSrI2uyv9LD0xAWisf/LPrQ8PB6a1h0sURLV/NhBsXAz2i7Svwzopnjc5RjJfDrR75w1kk0OOkyOGndBz4kP9vJEsoI9HuHb8lNC1lgcwlmlBhLTvcv/zkzBlJuYD3UuqKu7go3BoK+lcKPZbE/zlg8s7DBqt+O0mleaifO2IhL3G89k51oIcc8apOAyFGhgHn779kjBHs+OoWO1knRAcwp3j8EQMHnQexp8y3aDaMR5X2Sc70EusQUYNnpaMWHH2TVV6pAlNzb8i4ex9kACds+Npk3kBvrz3styimDYpZKlwfBIH4dNlid0l06AjXQ6Hp28N3oQKNcLqvr0tHV32v9gH7lC+DLNv9G
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3ba0e4a-4a9a-4c37-7aaf-08d824183ec7
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 14:56:22.7678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSwY5pmIQE31j3XTZP7tqNmXBaQX/z4nkw80UtQqIriBJ7DK4rcB6Ph9ilSPjCSTHbhtT4UJLDeRf/tSDkqZuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0502MB2915
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Rename the AF_XDP zero-copy driver interface functions to better
reflect what they do after the replacement of umems with buffer
pools in the previous commit. Mostly it is about replacing the
umem name from the function names with xsk_buff and also have
them take the a buffer pool pointer instead of a umem. The
various ring functions have also been renamed in the process so
that they have the same naming convention as the internal
functions in xsk_queue.h. This so that it will be clearer what
they do and also for consistency.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c     |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c    | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h  |  8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c  | 10 +++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h  |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      |  4 ++--
 7 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c2e06f5a092f..4385052d8c5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -446,7 +446,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->xsk_pool->umem, xsk_frames);
+		xsk_tx_completed(sq->xsk_pool, xsk_frames);
 
 	sq->stats->cqes += i;
 
@@ -476,7 +476,7 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->xsk_pool->umem, xsk_frames);
+		xsk_tx_completed(sq->xsk_pool, xsk_frames);
 }
 
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 8ccd9203ee25..3503e7711178 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -11,13 +11,13 @@ static int mlx5e_xsk_map_pool(struct mlx5e_priv *priv,
 {
 	struct device *dev = priv->mdev->device;
 
-	return xsk_buff_dma_map(pool->umem, dev, 0);
+	return xsk_pool_dma_map(pool, dev, 0);
 }
 
 static void mlx5e_xsk_unmap_pool(struct mlx5e_priv *priv,
 				 struct xsk_buff_pool *pool)
 {
-	return xsk_buff_dma_unmap(pool->umem, 0);
+	return xsk_pool_dma_unmap(pool, 0);
 }
 
 static int mlx5e_xsk_get_pools(struct mlx5e_xsk *xsk)
@@ -64,14 +64,14 @@ static void mlx5e_xsk_remove_pool(struct mlx5e_xsk *xsk, u16 ix)
 
 static bool mlx5e_xsk_is_pool_sane(struct xsk_buff_pool *pool)
 {
-	return xsk_umem_get_headroom(pool->umem) <= 0xffff &&
-		xsk_umem_get_chunk_size(pool->umem) <= 0xffff;
+	return xsk_pool_get_headroom(pool) <= 0xffff &&
+		xsk_pool_get_chunk_size(pool) <= 0xffff;
 }
 
 void mlx5e_build_xsk_param(struct xsk_buff_pool *pool, struct mlx5e_xsk_param *xsk)
 {
-	xsk->headroom = xsk_umem_get_headroom(pool->umem);
-	xsk->chunk_size = xsk_umem_get_chunk_size(pool->umem);
+	xsk->headroom = xsk_pool_get_headroom(pool);
+	xsk->chunk_size = xsk_pool_get_chunk_size(pool);
 }
 
 static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 3dd056a11bae..7f88ccf67fdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -22,7 +22,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 					    struct mlx5e_dma_info *dma_info)
 {
-	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool->umem);
+	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool);
 	if (!dma_info->xsk)
 		return -ENOMEM;
 
@@ -38,13 +38,13 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 
 static inline bool mlx5e_xsk_update_rx_wakeup(struct mlx5e_rq *rq, bool alloc_err)
 {
-	if (!xsk_umem_uses_need_wakeup(rq->xsk_pool->umem))
+	if (!xsk_uses_need_wakeup(rq->xsk_pool))
 		return alloc_err;
 
 	if (unlikely(alloc_err))
-		xsk_set_rx_need_wakeup(rq->xsk_pool->umem);
+		xsk_set_rx_need_wakeup(rq->xsk_pool);
 	else
-		xsk_clear_rx_need_wakeup(rq->xsk_pool->umem);
+		xsk_clear_rx_need_wakeup(rq->xsk_pool);
 
 	return false;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index e46ca8620ea9..5d8b5fe2161c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -83,7 +83,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(pool->umem, &desc)) {
+		if (!xsk_tx_peek_desc(pool, &desc)) {
 			/* TX will get stuck until something wakes it up by
 			 * triggering NAPI. Currently it's expected that the
 			 * application calls sendto() if there are consumed, but
@@ -92,11 +92,11 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool->umem, desc.addr);
-		xdptxd.data = xsk_buff_raw_get_data(pool->umem, desc.addr);
+		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool, desc.addr);
+		xdptxd.data = xsk_buff_raw_get_data(pool, desc.addr);
 		xdptxd.len = desc.len;
 
-		xsk_buff_raw_dma_sync_for_device(pool->umem, xdptxd.dma_addr, xdptxd.len);
+		xsk_buff_raw_dma_sync_for_device(pool, xdptxd.dma_addr, xdptxd.len);
 
 		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, check_result))) {
 			if (sq->mpwqe.wqe)
@@ -113,7 +113,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			mlx5e_xdp_mpwqe_complete(sq);
 		mlx5e_xmit_xdp_doorbell(sq);
 
-		xsk_umem_consume_tx_done(pool->umem);
+		xsk_tx_release(pool);
 	}
 
 	return !(budget && work_done);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index ddb61d5bc2db..a05085035f23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -15,13 +15,13 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
 
 static inline void mlx5e_xsk_update_tx_wakeup(struct mlx5e_xdpsq *sq)
 {
-	if (!xsk_umem_uses_need_wakeup(sq->xsk_pool->umem))
+	if (!xsk_uses_need_wakeup(sq->xsk_pool))
 		return;
 
 	if (sq->pc != sq->cc)
-		xsk_clear_tx_need_wakeup(sq->xsk_pool->umem);
+		xsk_clear_tx_need_wakeup(sq->xsk_pool);
 	else
-		xsk_set_tx_need_wakeup(sq->xsk_pool->umem);
+		xsk_set_tx_need_wakeup(sq->xsk_pool);
 }
 
 #endif /* __MLX5_EN_XSK_TX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 42e80165ca6c..5c1c15bab6ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -518,7 +518,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	if (xsk) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL, NULL);
-		xsk_buff_set_rxq_info(rq->xsk_pool->umem, &rq->xdp_rxq);
+		xsk_pool_set_rxq_info(rq->xsk_pool, &rq->xdp_rxq);
 	} else {
 		/* Create a page_pool and register it with rxq */
 		pp_params.order     = 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 4f9a1d6e54fd..e05422190d29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -390,7 +390,7 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 		 * allocating one-by-one, failing and moving frames to the
 		 * Reuse Ring.
 		 */
-		if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, pages_desired)))
+		if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, pages_desired)))
 			return -ENOMEM;
 	}
 
@@ -489,7 +489,7 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	 * one-by-one, failing and moving frames to the Reuse Ring.
 	 */
 	if (rq->xsk_pool &&
-	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, MLX5_MPWRQ_PAGES_PER_WQE))) {
+	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool, MLX5_MPWRQ_PAGES_PER_WQE))) {
 		err = -ENOMEM;
 		goto err;
 	}
-- 
2.20.1

