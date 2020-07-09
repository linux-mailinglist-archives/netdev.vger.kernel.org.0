Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFE021A2CC
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 16:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGIO4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 10:56:30 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:13415
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbgGIO4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 10:56:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jo/Rg3FECAz2eXuowiTpmSdYePKT+zVXFV50IL2BaQkaTDT0m9ZC/hnkQpp9qXr1enCfDXZJ0wLp+zHA7qVQMrVfNSYqYmgy1lpwXawbZzmHU3QRr+RiBO9c4ytfYViiKFKjklZ9ueOjy/NHwuXZM4s4LWF/M13SO4THMKAbkF1XgxfEhtYbfaEZhz4bGmWSUr/cuqamJyi4HAYA5L5bFJNNhgLKi+8b/Pq5/Qek76FRFqYiWeRuL2kyQcGJyGyuwCxAmmig5YDiQF5Nm24xuPZXQH1LsCvMDyZ7w1rS1rKgdjKxnWDeC0lTQ+oFzHHaDs266mG2h30iSbC8sKL2PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbo41Sbs+/Vis3/f598BFx5JB8WHO8zEbhtTgRM3ulE=;
 b=b8xVBrg65z0eZOntFMpaBIZwswvwNNXcOyzOo3sl7T9lqvPH94frgcbVPvErTC8jTe7ji/2GpLpnGqD2W1mSUGTXMrAPyYQPL7EkGjfprtxxdnEeGwYOTunYVjvgWfsxWAXrj5S+J323upDjdVoKsxdyFzqvm0hu+ptkNL/ad8OMpy8q1tcI+O/5O68bfAMuyGFpbGGQw7HOWrQSqfXBTncYaRS+/yWhU/YzvirjzNkmFSVn/qLwQztEocXdE14okMwfs3yQlHJFeIN1wJo1f3GGYZjIbXWOwayKk9JWrcFFKYfYFXzyMJPq0e9lAY/cZzpJRaT+ZCGic/D/lBo/dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbo41Sbs+/Vis3/f598BFx5JB8WHO8zEbhtTgRM3ulE=;
 b=c5pj7zLtj0OmXpLAmWI8figSGFEvYhP0nyD7mnLOfqh5S+m8QR2zNzOxWDcvXE41eWJ2FHA9+H4cw55ZuVJJWNrtlfzmGkJWzI2pDxtf0qK7oEb4ZhPw6WHgET37scXTM5SIFM+es+K6WaiLrovt2QeBHEmGVDE8XV4gXliIEf8=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM5PR0502MB2915.eurprd05.prod.outlook.com (2603:10a6:203:9e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Thu, 9 Jul
 2020 14:56:21 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::55:e9a6:86b0:8ba2%7]) with mapi id 15.20.3174.022; Thu, 9 Jul 2020
 14:56:20 +0000
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
Subject: [PATCH 1/2] xsk: i40e: ice: ixgbe: mlx5: pass buffer pool to driver instead of umem
Date:   Thu,  9 Jul 2020 17:56:33 +0300
Message-Id: <20200709145634.4986-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <CAJ8uoz2sud5wBFpWKfC-i4n9E77KnQWGPsKLysumsA23pHEjEQ@mail.gmail.com>
References: <CAJ8uoz2sud5wBFpWKfC-i4n9E77KnQWGPsKLysumsA23pHEjEQ@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0021.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::34) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR07CA0021.eurprd07.prod.outlook.com (2603:10a6:208:ac::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Thu, 9 Jul 2020 14:56:18 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15ef261a-973a-4510-684a-08d824183d24
X-MS-TrafficTypeDiagnostic: AM5PR0502MB2915:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0502MB29159324FB59A049F4E57477D1640@AM5PR0502MB2915.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 04599F3534
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZ2QCS+BMS5x56JDE8/Fnhr75wNLdeMvTscIOyInKDzLY6bE2MuGNn8g2f3ri10upSUVjOoRX/Zwx8z/7VO2qBmgAS+KwNtUo7qCSy4y3Z5dCngvDzNdQslLXYzjRC3NZysRj3RivSb9ZN5rKkSZo28m6r1zhhtXlGjJod0UY92JvEhnFvQYQmuVBJFreTqGIiLNuYoOh52+Xx3zqNJhyv+Ki+lvlbLghzrb1WLgW98nQfD/exjRuG9ydRauhcKhfctWOgWDl5WvKEd3O3jAgAJwA3AHwxwKx79OZLH+6qRjAry71Q/8zonHQazaIL87DL6ytLC9uEoF0zVHXpqjsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(36756003)(6916009)(186003)(4326008)(16526019)(478600001)(6512007)(86362001)(83380400001)(6666004)(8676002)(54906003)(1076003)(956004)(2906002)(6506007)(8936002)(2616005)(30864003)(6486002)(52116002)(26005)(7416002)(66556008)(66476007)(107886003)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QtFfbqcsNDRmNUb3Gyc4Rk/RcbzltPGmcb175zES83q69H+ANL785e/oAoQP1TFLh4tLgHQeRjgw/iqsz1ejPllTHlgPFkD/Px5lxrpxWG4lJYqfm0QMUDvKp1KHeFmGP/VgOpikTL+7Lk+IzMr2B7vMvj55HnEPP5XivKA126kAUXELuu7m5QZCDLfQWKkpIOuBs/1qsvFWB9Q40DhMtT7k3UIpDY8BRDOh9mOp7FQ+fY2o6gLyHRKX6qEb36tSRR+agT4Gaaei2OOV9lDHWJ5HB2GxmZrMzh3A/WzUAnKjiQH+8htorOs/zfypNPwyYIsw3t33xc9+DZht2c3n6NRKkZDV8F+qJsiwDjB0dBF3PoZNrPAY/iQQelfC0uLvr0aMtQZ0504gN3ay4s1dVZm9tymnusJ0XYZtw3ENnjqpVsslTGnoGA5Cu3B0q7ZJ30W/UJMzvkIYWuTyM2UhZUNUtRwQ9eATLRDxJUv3beg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ef261a-973a-4510-684a-08d824183d24
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 14:56:20.6340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sr5xHPtS1GcZcYw4Q+RNS/zO6GHbd3QgMNROVcgHqVr4APJhYeQxdgnURI7Y6DOW2v4tEmC0+u44LWw24W/RxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0502MB2915
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Replace the explicit umem reference passed to the driver in
AF_XDP zero-copy mode with the buffer pool instead. This in
preparation for extending the functionality of the zero-copy mode
so that umems can be shared between queues on the same netdev and
also between netdevs. In this commit, only an umem reference has
been added to the buffer pool struct. But later commits will add
other entities to it. These are going to be entities that are
different between different queue ids and netdevs even though the
umem is shared between them.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
Magnus, here are my minor changes to the mlx5 part (only mlx5 is
included in these two patches). I renamed pool to xsk_pool when used
outside of en/xsk and renamed umem.{c,h} to pool.{c,h}.

 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  19 +--
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |   5 +-
 .../mlx5/core/en/xsk/{umem.c => pool.c}       | 110 +++++++++---------
 .../ethernet/mellanox/mlx5/core/en/xsk/pool.h |  27 +++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  10 +-
 .../mellanox/mlx5/core/en/xsk/setup.c         |  12 +-
 .../mellanox/mlx5/core/en/xsk/setup.h         |   2 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  14 +--
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.h   |   6 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/umem.h |  29 -----
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   2 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  49 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  16 +--
 15 files changed, 152 insertions(+), 153 deletions(-)
 rename drivers/net/ethernet/mellanox/mlx5/core/en/xsk/{umem.c => pool.c} (51%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 1e7c7f10db6e..e4a02885a603 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -24,7 +24,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
 mlx5_core-$(CONFIG_MLX5_CORE_EN) += en_main.o en_common.o en_fs.o en_ethtool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
 		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
-		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/umem.o \
+		en/reporter_tx.o en/reporter_rx.o en/params.o en/xsk/pool.o \
 		en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o en/devlink.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c44669102626..d95296e28b97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -441,7 +441,7 @@ struct mlx5e_xdpsq {
 	struct mlx5e_cq            cq;
 
 	/* read only */
-	struct xdp_umem           *umem;
+	struct xsk_buff_pool      *xsk_pool;
 	struct mlx5_wq_cyc         wq;
 	struct mlx5e_xdpsq_stats  *stats;
 	mlx5e_fp_xmit_xdp_frame_check xmit_xdp_frame_check;
@@ -603,7 +603,7 @@ struct mlx5e_rq {
 	struct page_pool      *page_pool;
 
 	/* AF_XDP zero-copy */
-	struct xdp_umem       *umem;
+	struct xsk_buff_pool  *xsk_pool;
 
 	struct work_struct     recover_work;
 
@@ -726,12 +726,13 @@ struct mlx5e_hv_vhca_stats_agent {
 #endif
 
 struct mlx5e_xsk {
-	/* UMEMs are stored separately from channels, because we don't want to
-	 * lose them when channels are recreated. The kernel also stores UMEMs,
-	 * but it doesn't distinguish between zero-copy and non-zero-copy UMEMs,
-	 * so rely on our mechanism.
+	/* XSK buffer pools are stored separately from channels,
+	 * because we don't want to lose them when channels are
+	 * recreated. The kernel also stores buffer pool, but it doesn't
+	 * distinguish between zero-copy and non-zero-copy UMEMs, so
+	 * rely on our mechanism.
 	 */
-	struct xdp_umem **umems;
+	struct xsk_buff_pool **pools;
 	u16 refcnt;
 	bool ever_used;
 };
@@ -923,7 +924,7 @@ struct mlx5e_xsk_param;
 struct mlx5e_rq_param;
 int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
-		  struct xdp_umem *umem, struct mlx5e_rq *rq);
+		  struct xsk_buff_pool *xsk_pool, struct mlx5e_rq *rq);
 int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int wait_time);
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
 void mlx5e_close_rq(struct mlx5e_rq *rq);
@@ -933,7 +934,7 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		     struct mlx5e_sq_param *param, struct mlx5e_icosq *sq);
 void mlx5e_close_icosq(struct mlx5e_icosq *sq);
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct xdp_umem *umem,
+		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect);
 void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c9d308e91965..c2e06f5a092f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -446,7 +446,7 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq)
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->umem, xsk_frames);
+		xsk_umem_complete_tx(sq->xsk_pool->umem, xsk_frames);
 
 	sq->stats->cqes += i;
 
@@ -476,7 +476,7 @@ void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq)
 	}
 
 	if (xsk_frames)
-		xsk_umem_complete_tx(sq->umem, xsk_frames);
+		xsk_umem_complete_tx(sq->xsk_pool->umem, xsk_frames);
 }
 
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
@@ -561,4 +561,3 @@ void mlx5e_set_xmit_fp(struct mlx5e_xdpsq *sq, bool is_mpw)
 	sq->xmit_xdp_frame = is_mpw ?
 		mlx5e_xmit_xdp_frame_mpwqe : mlx5e_xmit_xdp_frame;
 }
-
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
similarity index 51%
rename from drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
rename to drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 331ca2b0f8a4..8ccd9203ee25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -1,31 +1,31 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
-/* Copyright (c) 2019 Mellanox Technologies. */
+/* Copyright (c) 2019-2020, Mellanox Technologies inc. All rights reserved. */
 
 #include <net/xdp_sock_drv.h>
-#include "umem.h"
+#include "pool.h"
 #include "setup.h"
 #include "en/params.h"
 
-static int mlx5e_xsk_map_umem(struct mlx5e_priv *priv,
-			      struct xdp_umem *umem)
+static int mlx5e_xsk_map_pool(struct mlx5e_priv *priv,
+			      struct xsk_buff_pool *pool)
 {
 	struct device *dev = priv->mdev->device;
 
-	return xsk_buff_dma_map(umem, dev, 0);
+	return xsk_buff_dma_map(pool->umem, dev, 0);
 }
 
-static void mlx5e_xsk_unmap_umem(struct mlx5e_priv *priv,
-				 struct xdp_umem *umem)
+static void mlx5e_xsk_unmap_pool(struct mlx5e_priv *priv,
+				 struct xsk_buff_pool *pool)
 {
-	return xsk_buff_dma_unmap(umem, 0);
+	return xsk_buff_dma_unmap(pool->umem, 0);
 }
 
-static int mlx5e_xsk_get_umems(struct mlx5e_xsk *xsk)
+static int mlx5e_xsk_get_pools(struct mlx5e_xsk *xsk)
 {
-	if (!xsk->umems) {
-		xsk->umems = kcalloc(MLX5E_MAX_NUM_CHANNELS,
-				     sizeof(*xsk->umems), GFP_KERNEL);
-		if (unlikely(!xsk->umems))
+	if (!xsk->pools) {
+		xsk->pools = kcalloc(MLX5E_MAX_NUM_CHANNELS,
+				     sizeof(*xsk->pools), GFP_KERNEL);
+		if (unlikely(!xsk->pools))
 			return -ENOMEM;
 	}
 
@@ -35,68 +35,68 @@ static int mlx5e_xsk_get_umems(struct mlx5e_xsk *xsk)
 	return 0;
 }
 
-static void mlx5e_xsk_put_umems(struct mlx5e_xsk *xsk)
+static void mlx5e_xsk_put_pools(struct mlx5e_xsk *xsk)
 {
 	if (!--xsk->refcnt) {
-		kfree(xsk->umems);
-		xsk->umems = NULL;
+		kfree(xsk->pools);
+		xsk->pools = NULL;
 	}
 }
 
-static int mlx5e_xsk_add_umem(struct mlx5e_xsk *xsk, struct xdp_umem *umem, u16 ix)
+static int mlx5e_xsk_add_pool(struct mlx5e_xsk *xsk, struct xsk_buff_pool *pool, u16 ix)
 {
 	int err;
 
-	err = mlx5e_xsk_get_umems(xsk);
+	err = mlx5e_xsk_get_pools(xsk);
 	if (unlikely(err))
 		return err;
 
-	xsk->umems[ix] = umem;
+	xsk->pools[ix] = pool;
 	return 0;
 }
 
-static void mlx5e_xsk_remove_umem(struct mlx5e_xsk *xsk, u16 ix)
+static void mlx5e_xsk_remove_pool(struct mlx5e_xsk *xsk, u16 ix)
 {
-	xsk->umems[ix] = NULL;
+	xsk->pools[ix] = NULL;
 
-	mlx5e_xsk_put_umems(xsk);
+	mlx5e_xsk_put_pools(xsk);
 }
 
-static bool mlx5e_xsk_is_umem_sane(struct xdp_umem *umem)
+static bool mlx5e_xsk_is_pool_sane(struct xsk_buff_pool *pool)
 {
-	return xsk_umem_get_headroom(umem) <= 0xffff &&
-		xsk_umem_get_chunk_size(umem) <= 0xffff;
+	return xsk_umem_get_headroom(pool->umem) <= 0xffff &&
+		xsk_umem_get_chunk_size(pool->umem) <= 0xffff;
 }
 
-void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk)
+void mlx5e_build_xsk_param(struct xsk_buff_pool *pool, struct mlx5e_xsk_param *xsk)
 {
-	xsk->headroom = xsk_umem_get_headroom(umem);
-	xsk->chunk_size = xsk_umem_get_chunk_size(umem);
+	xsk->headroom = xsk_umem_get_headroom(pool->umem);
+	xsk->chunk_size = xsk_umem_get_chunk_size(pool->umem);
 }
 
 static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
-				   struct xdp_umem *umem, u16 ix)
+				   struct xsk_buff_pool *pool, u16 ix)
 {
 	struct mlx5e_params *params = &priv->channels.params;
 	struct mlx5e_xsk_param xsk;
 	struct mlx5e_channel *c;
 	int err;
 
-	if (unlikely(mlx5e_xsk_get_umem(&priv->channels.params, &priv->xsk, ix)))
+	if (unlikely(mlx5e_xsk_get_pool(&priv->channels.params, &priv->xsk, ix)))
 		return -EBUSY;
 
-	if (unlikely(!mlx5e_xsk_is_umem_sane(umem)))
+	if (unlikely(!mlx5e_xsk_is_pool_sane(pool)))
 		return -EINVAL;
 
-	err = mlx5e_xsk_map_umem(priv, umem);
+	err = mlx5e_xsk_map_pool(priv, pool);
 	if (unlikely(err))
 		return err;
 
-	err = mlx5e_xsk_add_umem(&priv->xsk, umem, ix);
+	err = mlx5e_xsk_add_pool(&priv->xsk, pool, ix);
 	if (unlikely(err))
-		goto err_unmap_umem;
+		goto err_unmap_pool;
 
-	mlx5e_build_xsk_param(umem, &xsk);
+	mlx5e_build_xsk_param(pool, &xsk);
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		/* XSK objects will be created on open. */
@@ -112,9 +112,9 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 
 	c = priv->channels.c[ix];
 
-	err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
+	err = mlx5e_open_xsk(priv, params, &xsk, pool, c);
 	if (unlikely(err))
-		goto err_remove_umem;
+		goto err_remove_pool;
 
 	mlx5e_activate_xsk(c);
 
@@ -132,11 +132,11 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 	mlx5e_deactivate_xsk(c);
 	mlx5e_close_xsk(c);
 
-err_remove_umem:
-	mlx5e_xsk_remove_umem(&priv->xsk, ix);
+err_remove_pool:
+	mlx5e_xsk_remove_pool(&priv->xsk, ix);
 
-err_unmap_umem:
-	mlx5e_xsk_unmap_umem(priv, umem);
+err_unmap_pool:
+	mlx5e_xsk_unmap_pool(priv, pool);
 
 	return err;
 
@@ -146,7 +146,7 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 	 */
 	if (!mlx5e_validate_xsk_param(params, &xsk, priv->mdev)) {
 		err = -EINVAL;
-		goto err_remove_umem;
+		goto err_remove_pool;
 	}
 
 	return 0;
@@ -154,45 +154,45 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 
 static int mlx5e_xsk_disable_locked(struct mlx5e_priv *priv, u16 ix)
 {
-	struct xdp_umem *umem = mlx5e_xsk_get_umem(&priv->channels.params,
+	struct xsk_buff_pool *pool = mlx5e_xsk_get_pool(&priv->channels.params,
 						   &priv->xsk, ix);
 	struct mlx5e_channel *c;
 
-	if (unlikely(!umem))
+	if (unlikely(!pool))
 		return -EINVAL;
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
-		goto remove_umem;
+		goto remove_pool;
 
 	/* XSK RQ and SQ are only created if XDP program is set. */
 	if (!priv->channels.params.xdp_prog)
-		goto remove_umem;
+		goto remove_pool;
 
 	c = priv->channels.c[ix];
 	mlx5e_xsk_redirect_rqt_to_drop(priv, ix);
 	mlx5e_deactivate_xsk(c);
 	mlx5e_close_xsk(c);
 
-remove_umem:
-	mlx5e_xsk_remove_umem(&priv->xsk, ix);
-	mlx5e_xsk_unmap_umem(priv, umem);
+remove_pool:
+	mlx5e_xsk_remove_pool(&priv->xsk, ix);
+	mlx5e_xsk_unmap_pool(priv, pool);
 
 	return 0;
 }
 
-static int mlx5e_xsk_enable_umem(struct mlx5e_priv *priv, struct xdp_umem *umem,
+static int mlx5e_xsk_enable_pool(struct mlx5e_priv *priv, struct xsk_buff_pool *pool,
 				 u16 ix)
 {
 	int err;
 
 	mutex_lock(&priv->state_lock);
-	err = mlx5e_xsk_enable_locked(priv, umem, ix);
+	err = mlx5e_xsk_enable_locked(priv, pool, ix);
 	mutex_unlock(&priv->state_lock);
 
 	return err;
 }
 
-static int mlx5e_xsk_disable_umem(struct mlx5e_priv *priv, u16 ix)
+static int mlx5e_xsk_disable_pool(struct mlx5e_priv *priv, u16 ix)
 {
 	int err;
 
@@ -203,7 +203,7 @@ static int mlx5e_xsk_disable_umem(struct mlx5e_priv *priv, u16 ix)
 	return err;
 }
 
-int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
+int mlx5e_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_params *params = &priv->channels.params;
@@ -212,6 +212,6 @@ int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
 	if (unlikely(!mlx5e_qid_get_ch_if_in_group(params, qid, MLX5E_RQ_GROUP_XSK, &ix)))
 		return -EINVAL;
 
-	return umem ? mlx5e_xsk_enable_umem(priv, umem, ix) :
-		      mlx5e_xsk_disable_umem(priv, ix);
+	return pool ? mlx5e_xsk_enable_pool(priv, pool, ix) :
+		      mlx5e_xsk_disable_pool(priv, ix);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
new file mode 100644
index 000000000000..dca0010a0866
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019-2020, Mellanox Technologies inc. All rights reserved. */
+
+#ifndef __MLX5_EN_XSK_POOL_H__
+#define __MLX5_EN_XSK_POOL_H__
+
+#include "en.h"
+
+static inline struct xsk_buff_pool *mlx5e_xsk_get_pool(struct mlx5e_params *params,
+						       struct mlx5e_xsk *xsk, u16 ix)
+{
+	if (!xsk || !xsk->pools)
+		return NULL;
+
+	if (unlikely(ix >= params->num_channels))
+		return NULL;
+
+	return xsk->pools[ix];
+}
+
+struct mlx5e_xsk_param;
+void mlx5e_build_xsk_param(struct xsk_buff_pool *pool, struct mlx5e_xsk_param *xsk);
+
+/* .ndo_bpf callback. */
+int mlx5e_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid);
+
+#endif /* __MLX5_EN_XSK_POOL_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index d147b2f13b54..3dd056a11bae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -19,10 +19,10 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt);
 
-static inline int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
+static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
 					    struct mlx5e_dma_info *dma_info)
 {
-	dma_info->xsk = xsk_buff_alloc(rq->umem);
+	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool->umem);
 	if (!dma_info->xsk)
 		return -ENOMEM;
 
@@ -38,13 +38,13 @@ static inline int mlx5e_xsk_page_alloc_umem(struct mlx5e_rq *rq,
 
 static inline bool mlx5e_xsk_update_rx_wakeup(struct mlx5e_rq *rq, bool alloc_err)
 {
-	if (!xsk_umem_uses_need_wakeup(rq->umem))
+	if (!xsk_umem_uses_need_wakeup(rq->xsk_pool->umem))
 		return alloc_err;
 
 	if (unlikely(alloc_err))
-		xsk_set_rx_need_wakeup(rq->umem);
+		xsk_set_rx_need_wakeup(rq->xsk_pool->umem);
 	else
-		xsk_clear_rx_need_wakeup(rq->umem);
+		xsk_clear_rx_need_wakeup(rq->xsk_pool->umem);
 
 	return false;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index cc46414773b5..a0b9dff33be9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -44,7 +44,7 @@ static void mlx5e_build_xsk_cparam(struct mlx5e_priv *priv,
 }
 
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
-		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
+		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c)
 {
 	struct mlx5e_channel_param *cparam;
@@ -63,7 +63,7 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_free_cparam;
 
-	err = mlx5e_open_rq(c, params, &cparam->rq, xsk, umem, &c->xskrq);
+	err = mlx5e_open_rq(c, params, &cparam->rq, xsk, pool, &c->xskrq);
 	if (unlikely(err))
 		goto err_close_rx_cq;
 
@@ -71,13 +71,13 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_close_rq;
 
-	/* Create a separate SQ, so that when the UMEM is disabled, we could
+	/* Create a separate SQ, so that when the buff pool is disabled, we could
 	 * close this SQ safely and stop receiving CQEs. In other case, e.g., if
-	 * the XDPSQ was used instead, we might run into trouble when the UMEM
+	 * the XDPSQ was used instead, we might run into trouble when the buff pool
 	 * is disabled and then reenabled, but the SQ continues receiving CQEs
-	 * from the old UMEM.
+	 * from the old buff pool.
 	 */
-	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, umem, &c->xsksq, true);
+	err = mlx5e_open_xdpsq(c, params, &cparam->xdp_sq, pool, &c->xsksq, true);
 	if (unlikely(err))
 		goto err_close_tx_cq;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
index 0dd11b81c046..ca20f1ff5e39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.h
@@ -12,7 +12,7 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 			      struct mlx5e_xsk_param *xsk,
 			      struct mlx5_core_dev *mdev);
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
-		   struct mlx5e_xsk_param *xsk, struct xdp_umem *umem,
+		   struct mlx5e_xsk_param *xsk, struct xsk_buff_pool *pool,
 		   struct mlx5e_channel *c);
 void mlx5e_close_xsk(struct mlx5e_channel *c);
 void mlx5e_activate_xsk(struct mlx5e_channel *c);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index e0b3c61af93e..e46ca8620ea9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
 
 #include "tx.h"
-#include "umem.h"
+#include "pool.h"
 #include "en/xdp.h"
 #include "en/params.h"
 #include <net/xdp_sock_drv.h>
@@ -66,7 +66,7 @@ static void mlx5e_xsk_tx_post_err(struct mlx5e_xdpsq *sq,
 
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 {
-	struct xdp_umem *umem = sq->umem;
+	struct xsk_buff_pool *pool = sq->xsk_pool;
 	struct mlx5e_xdp_info xdpi;
 	struct mlx5e_xdp_xmit_data xdptxd;
 	bool work_done = true;
@@ -83,7 +83,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		if (!xsk_umem_consume_tx(umem, &desc)) {
+		if (!xsk_umem_consume_tx(pool->umem, &desc)) {
 			/* TX will get stuck until something wakes it up by
 			 * triggering NAPI. Currently it's expected that the
 			 * application calls sendto() if there are consumed, but
@@ -92,11 +92,11 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			break;
 		}
 
-		xdptxd.dma_addr = xsk_buff_raw_get_dma(umem, desc.addr);
-		xdptxd.data = xsk_buff_raw_get_data(umem, desc.addr);
+		xdptxd.dma_addr = xsk_buff_raw_get_dma(pool->umem, desc.addr);
+		xdptxd.data = xsk_buff_raw_get_data(pool->umem, desc.addr);
 		xdptxd.len = desc.len;
 
-		xsk_buff_raw_dma_sync_for_device(umem, xdptxd.dma_addr, xdptxd.len);
+		xsk_buff_raw_dma_sync_for_device(pool->umem, xdptxd.dma_addr, xdptxd.len);
 
 		if (unlikely(!sq->xmit_xdp_frame(sq, &xdptxd, &xdpi, check_result))) {
 			if (sq->mpwqe.wqe)
@@ -113,7 +113,7 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget)
 			mlx5e_xdp_mpwqe_complete(sq);
 		mlx5e_xmit_xdp_doorbell(sq);
 
-		xsk_umem_consume_tx_done(umem);
+		xsk_umem_consume_tx_done(pool->umem);
 	}
 
 	return !(budget && work_done);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index 39fa0a705856..ddb61d5bc2db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -15,13 +15,13 @@ bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
 
 static inline void mlx5e_xsk_update_tx_wakeup(struct mlx5e_xdpsq *sq)
 {
-	if (!xsk_umem_uses_need_wakeup(sq->umem))
+	if (!xsk_umem_uses_need_wakeup(sq->xsk_pool->umem))
 		return;
 
 	if (sq->pc != sq->cc)
-		xsk_clear_tx_need_wakeup(sq->umem);
+		xsk_clear_tx_need_wakeup(sq->xsk_pool->umem);
 	else
-		xsk_set_tx_need_wakeup(sq->umem);
+		xsk_set_tx_need_wakeup(sq->xsk_pool->umem);
 }
 
 #endif /* __MLX5_EN_XSK_TX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
deleted file mode 100644
index bada94973586..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
-/* Copyright (c) 2019 Mellanox Technologies. */
-
-#ifndef __MLX5_EN_XSK_UMEM_H__
-#define __MLX5_EN_XSK_UMEM_H__
-
-#include "en.h"
-
-static inline struct xdp_umem *mlx5e_xsk_get_umem(struct mlx5e_params *params,
-						  struct mlx5e_xsk *xsk, u16 ix)
-{
-	if (!xsk || !xsk->umems)
-		return NULL;
-
-	if (unlikely(ix >= params->num_channels))
-		return NULL;
-
-	return xsk->umems[ix];
-}
-
-struct mlx5e_xsk_param;
-void mlx5e_build_xsk_param(struct xdp_umem *umem, struct mlx5e_xsk_param *xsk);
-
-/* .ndo_bpf callback. */
-int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid);
-
-int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries);
-
-#endif /* __MLX5_EN_XSK_UMEM_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ec5658bbe3c5..73321cd86246 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -32,7 +32,7 @@
 
 #include "en.h"
 #include "en/port.h"
-#include "en/xsk/umem.h"
+#include "en/xsk/pool.h"
 #include "lib/clock.h"
 
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index 83c9b2bbc4af..b416a8ee2eed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -33,7 +33,7 @@
 #include <linux/mlx5/fs.h>
 #include "en.h"
 #include "en/params.h"
-#include "en/xsk/umem.h"
+#include "en/xsk/pool.h"
 
 struct mlx5e_ethtool_rule {
 	struct list_head             list;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b04c8572adea..42e80165ca6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -58,7 +58,7 @@
 #include "en/monitor_stats.h"
 #include "en/health.h"
 #include "en/params.h"
-#include "en/xsk/umem.h"
+#include "en/xsk/pool.h"
 #include "en/xsk/setup.h"
 #include "en/xsk/rx.h"
 #include "en/xsk/tx.h"
@@ -365,7 +365,7 @@ static void mlx5e_rq_err_cqe_work(struct work_struct *recover_work)
 static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
-			  struct xdp_umem *umem,
+			  struct xsk_buff_pool *xsk_pool,
 			  struct mlx5e_rq_param *rqp,
 			  struct mlx5e_rq *rq)
 {
@@ -391,9 +391,9 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	rq->mdev    = mdev;
 	rq->hw_mtu  = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq   = &c->rq_xdpsq;
-	rq->umem    = umem;
+	rq->xsk_pool = xsk_pool;
 
-	if (rq->umem)
+	if (rq->xsk_pool)
 		rq->stats = &c->priv->channel_stats[c->ix].xskrq;
 	else
 		rq->stats = &c->priv->channel_stats[c->ix].rq;
@@ -518,7 +518,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	if (xsk) {
 		err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq,
 						 MEM_TYPE_XSK_BUFF_POOL, NULL);
-		xsk_buff_set_rxq_info(rq->umem, &rq->xdp_rxq);
+		xsk_buff_set_rxq_info(rq->xsk_pool->umem, &rq->xdp_rxq);
 	} else {
 		/* Create a page_pool and register it with rxq */
 		pp_params.order     = 0;
@@ -857,11 +857,11 @@ void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 
 int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
 		  struct mlx5e_rq_param *param, struct mlx5e_xsk_param *xsk,
-		  struct xdp_umem *umem, struct mlx5e_rq *rq)
+		  struct xsk_buff_pool *xsk_pool, struct mlx5e_rq *rq)
 {
 	int err;
 
-	err = mlx5e_alloc_rq(c, params, xsk, umem, param, rq);
+	err = mlx5e_alloc_rq(c, params, xsk, xsk_pool, param, rq);
 	if (err)
 		return err;
 
@@ -966,7 +966,7 @@ static int mlx5e_alloc_xdpsq_db(struct mlx5e_xdpsq *sq, int numa)
 
 static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 			     struct mlx5e_params *params,
-			     struct xdp_umem *umem,
+			     struct xsk_buff_pool *xsk_pool,
 			     struct mlx5e_sq_param *param,
 			     struct mlx5e_xdpsq *sq,
 			     bool is_redirect)
@@ -982,9 +982,9 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->uar_map   = mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
 	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
-	sq->umem      = umem;
+	sq->xsk_pool  = xsk_pool;
 
-	sq->stats = sq->umem ?
+	sq->stats = sq->xsk_pool ?
 		&c->priv->channel_stats[c->ix].xsksq :
 		is_redirect ?
 			&c->priv->channel_stats[c->ix].xdpsq :
@@ -1449,13 +1449,13 @@ void mlx5e_close_icosq(struct mlx5e_icosq *sq)
 }
 
 int mlx5e_open_xdpsq(struct mlx5e_channel *c, struct mlx5e_params *params,
-		     struct mlx5e_sq_param *param, struct xdp_umem *umem,
+		     struct mlx5e_sq_param *param, struct xsk_buff_pool *xsk_pool,
 		     struct mlx5e_xdpsq *sq, bool is_redirect)
 {
 	struct mlx5e_create_sq_param csp = {};
 	int err;
 
-	err = mlx5e_alloc_xdpsq(c, params, umem, param, sq, is_redirect);
+	err = mlx5e_alloc_xdpsq(c, params, xsk_pool, param, sq, is_redirect);
 	if (err)
 		return err;
 
@@ -1948,7 +1948,7 @@ static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
-			      struct xdp_umem *umem,
+			      struct xsk_buff_pool *xsk_pool,
 			      struct mlx5e_channel **cp)
 {
 	int cpu = cpumask_first(mlx5_comp_irq_get_affinity_mask(priv->mdev, ix));
@@ -1987,9 +1987,9 @@ static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 	if (unlikely(err))
 		goto err_napi_del;
 
-	if (umem) {
-		mlx5e_build_xsk_param(umem, &xsk);
-		err = mlx5e_open_xsk(priv, params, &xsk, umem, c);
+	if (xsk_pool) {
+		mlx5e_build_xsk_param(xsk_pool, &xsk);
+		err = mlx5e_open_xsk(priv, params, &xsk, xsk_pool, c);
 		if (unlikely(err))
 			goto err_close_queues;
 	}
@@ -2350,12 +2350,12 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 
 	mlx5e_build_channel_param(priv, &chs->params, cparam);
 	for (i = 0; i < chs->num; i++) {
-		struct xdp_umem *umem = NULL;
+		struct xsk_buff_pool *xsk_pool = NULL;
 
 		if (chs->params.xdp_prog)
-			umem = mlx5e_xsk_get_umem(&chs->params, chs->params.xsk, i);
+			xsk_pool = mlx5e_xsk_get_pool(&chs->params, chs->params.xsk, i);
 
-		err = mlx5e_open_channel(priv, i, &chs->params, cparam, umem, &chs->c[i]);
+		err = mlx5e_open_channel(priv, i, &chs->params, cparam, xsk_pool, &chs->c[i]);
 		if (err)
 			goto err_close_channels;
 	}
@@ -3917,13 +3917,14 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 	u16 ix;
 
 	for (ix = 0; ix < chs->params.num_channels; ix++) {
-		struct xdp_umem *umem = mlx5e_xsk_get_umem(&chs->params, chs->params.xsk, ix);
+		struct xsk_buff_pool *xsk_pool =
+			mlx5e_xsk_get_pool(&chs->params, chs->params.xsk, ix);
 		struct mlx5e_xsk_param xsk;
 
-		if (!umem)
+		if (!xsk_pool)
 			continue;
 
-		mlx5e_build_xsk_param(umem, &xsk);
+		mlx5e_build_xsk_param(xsk_pool, &xsk);
 
 		if (!mlx5e_validate_xsk_param(new_params, &xsk, mdev)) {
 			u32 hr = mlx5e_get_linear_rq_headroom(new_params, &xsk);
@@ -4543,8 +4544,8 @@ static int mlx5e_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	case XDP_QUERY_PROG:
 		xdp->prog_id = mlx5e_xdp_query(dev);
 		return 0;
-	case XDP_SETUP_XSK_UMEM:
-		return mlx5e_xsk_setup_umem(dev, xdp->xsk.umem,
+	case XDP_SETUP_XSK_POOL:
+		return mlx5e_xsk_setup_pool(dev, xdp->xsk.pool,
 					    xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 350f9c54e508..4f9a1d6e54fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -264,8 +264,8 @@ static inline int mlx5e_page_alloc_pool(struct mlx5e_rq *rq,
 static inline int mlx5e_page_alloc(struct mlx5e_rq *rq,
 				   struct mlx5e_dma_info *dma_info)
 {
-	if (rq->umem)
-		return mlx5e_xsk_page_alloc_umem(rq, dma_info);
+	if (rq->xsk_pool)
+		return mlx5e_xsk_page_alloc_pool(rq, dma_info);
 	else
 		return mlx5e_page_alloc_pool(rq, dma_info);
 }
@@ -296,7 +296,7 @@ static inline void mlx5e_page_release(struct mlx5e_rq *rq,
 				      struct mlx5e_dma_info *dma_info,
 				      bool recycle)
 {
-	if (rq->umem)
+	if (rq->xsk_pool)
 		/* The `recycle` parameter is ignored, and the page is always
 		 * put into the Reuse Ring, because there is no way to return
 		 * the page to the userspace when the interface goes down.
@@ -383,14 +383,14 @@ static int mlx5e_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, u8 wqe_bulk)
 	int err;
 	int i;
 
-	if (rq->umem) {
+	if (rq->xsk_pool) {
 		int pages_desired = wqe_bulk << rq->wqe.info.log_num_frags;
 
 		/* Check in advance that we have enough frames, instead of
 		 * allocating one-by-one, failing and moving frames to the
 		 * Reuse Ring.
 		 */
-		if (unlikely(!xsk_buff_can_alloc(rq->umem, pages_desired)))
+		if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, pages_desired)))
 			return -ENOMEM;
 	}
 
@@ -488,8 +488,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 	/* Check in advance that we have enough frames, instead of allocating
 	 * one-by-one, failing and moving frames to the Reuse Ring.
 	 */
-	if (rq->umem &&
-	    unlikely(!xsk_buff_can_alloc(rq->umem, MLX5_MPWRQ_PAGES_PER_WQE))) {
+	if (rq->xsk_pool &&
+	    unlikely(!xsk_buff_can_alloc(rq->xsk_pool->umem, MLX5_MPWRQ_PAGES_PER_WQE))) {
 		err = -ENOMEM;
 		goto err;
 	}
@@ -737,7 +737,7 @@ bool mlx5e_post_rx_mpwqes(struct mlx5e_rq *rq)
 	 * the driver when it refills the Fill Ring.
 	 * 2. Otherwise, busy poll by rescheduling the NAPI poll.
 	 */
-	if (unlikely(alloc_err == -ENOMEM && rq->umem))
+	if (unlikely(alloc_err == -ENOMEM && rq->xsk_pool))
 		return true;
 
 	return false;
-- 
2.20.1

