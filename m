Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0635FCCE
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfGDSQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:28 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:20736
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727345AbfGDSQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nkodeJMKUTCg8+4busllUk9zvN4hacNe7eqEsiXeeLg=;
 b=PRovZNldRYx1AJNAb+zbI3CsF1tbSFT1dhe1ocMxGMgEs0teb1Azab8QLcNsYG3gbIA2YgSNT7At50WDia87NEyW+YBM4xIDsyXr+hKQL7735N+n+DO/FIquCf27Lkaerjh9RfS3ERoCgzKU0CjB+L47C0a/g7Jr9dGQcQFLHLM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:16:15 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:16:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Thread-Topic: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Thread-Index: AQHVMpSRMNqGH6CUt0mO53TsqPfd/w==
Date:   Thu, 4 Jul 2019 18:16:15 +0000
Message-ID: <20190704181235.8966-15-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7a8988e-3bc0-414d-25ec-08d700abb37c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB25845897ADECE8EBA343F9CCBEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(30864003)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(53946003)(36756003)(53936002)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gjB8anwj26kZL9EUqqZ7j2r/T83E5SIfyJnvkIEyUPujV7J1GXj93180GzYnGugxtELc/XhAUEMapDUYPtqKdvCRAsUAESijm8K0aRIYEj2AVUP8Hs7rPCyDgkbuVoBZuYFbj1VCHrRvn66agK8IgzEtljWj2mnYMoO1QDrEVHJg8oM7bCjUz67zfluBTHX0Dqp7aLx6x9hlSfXlKRR+ImrrB+Ntqu8P3c14KtD0eQIYzk8bE/dJqtb0wk746V9LwdLhF+8OSMXYhRTogrCiqQ2yea7gRCXAUJvu7wex/1ImsPkaRgNM9ckacm4YNSzdHZQwkklIEM6aNKmdjaIPUrZ2cFlmkBbNZ5SS7H4uprIDayNscwAZkToSrm6098PE4lBZflfBzmouJttVEUszW1BsLm+K/1+MoW0QyPvPRqw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a8988e-3bc0-414d-25ec-08d700abb37c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:16:15.2874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add support for transmit side kernel-TLS acceleration.
Offload the crypto encryption to HW.

Per TLS connection:
- Use a separate TIS to maintain the HW context.
- Use a separate encryption key.
- Maintain static and progress HW contexts by posting the proper
  WQEs at creation time, or upon resync.
- Use a special DUMP opcode to replay the previous frags and sync
  the HW context.

To make sure the SQ is able to serve an xmit request, increase
SQ stop room to cover:
- static params WQE,
- progress params WQE, and
- resync DUMP per frag.

Currently supporting TLS 1.2, and key size 128bit.

Tested over ConnectX-6Dx qemu simulator.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   8 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  93 ++++
 .../mellanox/mlx5/core/en_accel/ktls.h        |  97 ++++
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 455 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/tls.c         |   5 +
 .../mellanox/mlx5/core/en_accel/tls.h         |  11 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |   5 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   3 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  29 ++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  18 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  15 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 14 files changed, 751 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_t=
x.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index cf2b342b7566..c44ec0ca64b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -62,4 +62,5 @@ mlx5_core-$(CONFIG_MLX5_FPGA) +=3D fpga/cmd.o fpga/core.o=
 fpga/conn.o fpga/sdk.o
 mlx5_core-$(CONFIG_MLX5_EN_IPSEC) +=3D en_accel/ipsec.o en_accel/ipsec_rxt=
x.o \
 				     en_accel/ipsec_stats.o
=20
-mlx5_core-$(CONFIG_MLX5_EN_TLS) +=3D en_accel/tls.o en_accel/tls_rxtx.o en=
_accel/tls_stats.o
+mlx5_core-$(CONFIG_MLX5_EN_TLS) +=3D en_accel/tls.o en_accel/tls_rxtx.o en=
_accel/tls_stats.o \
+				   en_accel/ktls.o en_accel/ktls_tx.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index b66d88f582f7..db4fdbe3c9ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -202,7 +202,10 @@ struct mlx5e_umr_wqe {
 	struct mlx5_wqe_ctrl_seg       ctrl;
 	struct mlx5_wqe_umr_ctrl_seg   uctrl;
 	struct mlx5_mkey_seg           mkc;
-	struct mlx5_mtt                inline_mtts[0];
+	union {
+		struct mlx5_mtt        inline_mtts[0];
+		u8                     tls_static_params_ctx[0];
+	};
 };
=20
 extern const char mlx5e_self_tests[][ETH_GSTRING_LEN];
@@ -325,6 +328,9 @@ struct mlx5e_tx_wqe_info {
 	u32 num_bytes;
 	u8  num_wqebbs;
 	u8  num_dma;
+#ifdef CONFIG_MLX5_EN_TLS
+	skb_frag_t *resync_dump_frag;
+#endif
 };
=20
 enum mlx5e_dma_map_type {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index ef16f9e41cf4..ddfe19adb3d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -15,9 +15,15 @@
 #else
 /* TLS offload requires additional stop_room for:
  *  - a resync SKB.
+ * kTLS offload requires additional stop_room for:
+ * - static params WQE,
+ * - progress params WQE, and
+ * - resync DUMP per frag.
  */
 #define MLX5E_SQ_TLS_ROOM  \
-	(MLX5_SEND_WQE_MAX_WQEBBS)
+	(MLX5_SEND_WQE_MAX_WQEBBS + \
+	 MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS + \
+	 MAX_SKB_FRAGS * MLX5E_KTLS_MAX_DUMP_WQEBBS)
 #endif
=20
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
new file mode 100644
index 000000000000..d2ff74d52720
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "en.h"
+#include "en_accel/ktls.h"
+
+static int mlx5e_ktls_create_tis(struct mlx5_core_dev *mdev, u32 *tisn)
+{
+	u32 in[MLX5_ST_SZ_DW(create_tis_in)] =3D {};
+	void *tisc;
+
+	tisc =3D MLX5_ADDR_OF(create_tis_in, in, ctx);
+
+	MLX5_SET(tisc, tisc, tls_en, 1);
+
+	return mlx5e_create_tis(mdev, in, tisn);
+}
+
+static int mlx5e_ktls_add(struct net_device *netdev, struct sock *sk,
+			  enum tls_offload_ctx_dir direction,
+			  struct tls_crypto_info *crypto_info,
+			  u32 start_offload_tcp_sn)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(netdev);
+	struct mlx5e_ktls_offload_context_tx *tx_priv;
+	struct tls_context *tls_ctx =3D tls_get_ctx(sk);
+	struct mlx5_core_dev *mdev =3D priv->mdev;
+	int err;
+
+	if (WARN_ON(direction !=3D TLS_OFFLOAD_CTX_DIR_TX))
+		return -EINVAL;
+
+	if (WARN_ON(!mlx5e_ktls_type_check(mdev, crypto_info)))
+		return -EOPNOTSUPP;
+
+	tx_priv =3D kvzalloc(sizeof(*tx_priv), GFP_KERNEL);
+	if (!tx_priv)
+		return -ENOMEM;
+
+	tx_priv->expected_seq =3D start_offload_tcp_sn;
+	tx_priv->crypto_info  =3D crypto_info;
+	mlx5e_set_ktls_tx_priv_ctx(tls_ctx, tx_priv);
+
+	/* tc and underlay_qpn values are not in use for tls tis */
+	err =3D mlx5e_ktls_create_tis(mdev, &tx_priv->tisn);
+	if (err)
+		goto create_tis_fail;
+
+	err =3D mlx5_ktls_create_key(mdev, crypto_info, &tx_priv->key_id);
+	if (err)
+		goto encryption_key_create_fail;
+
+	mlx5e_ktls_tx_offload_set_pending(tx_priv);
+
+	return 0;
+
+encryption_key_create_fail:
+	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
+create_tis_fail:
+	kvfree(tx_priv);
+	return err;
+}
+
+static void mlx5e_ktls_del(struct net_device *netdev,
+			   struct tls_context *tls_ctx,
+			   enum tls_offload_ctx_dir direction)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(netdev);
+	struct mlx5e_ktls_offload_context_tx *tx_priv =3D
+		mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+
+	mlx5_ktls_destroy_key(priv->mdev, tx_priv->key_id);
+	mlx5e_destroy_tis(priv->mdev, tx_priv->tisn);
+	kvfree(tx_priv);
+}
+
+static const struct tlsdev_ops mlx5e_ktls_ops =3D {
+	.tls_dev_add =3D mlx5e_ktls_add,
+	.tls_dev_del =3D mlx5e_ktls_del,
+};
+
+void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
+{
+	struct net_device *netdev =3D priv->netdev;
+
+	if (!mlx5_accel_is_ktls_device(priv->mdev))
+		return;
+
+	netdev->hw_features |=3D NETIF_F_HW_TLS_TX;
+	netdev->features    |=3D NETIF_F_HW_TLS_TX;
+
+	netdev->tlsdev_ops =3D &mlx5e_ktls_ops;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
new file mode 100644
index 000000000000..407da83474ef
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#ifndef __MLX5E_KTLS_H__
+#define __MLX5E_KTLS_H__
+
+#include "en.h"
+
+#ifdef CONFIG_MLX5_EN_TLS
+#include <net/tls.h>
+#include "accel/tls.h"
+
+#define MLX5E_KTLS_STATIC_UMR_WQE_SZ \
+	(sizeof(struct mlx5e_umr_wqe) + MLX5_ST_SZ_BYTES(tls_static_params))
+#define MLX5E_KTLS_STATIC_WQEBBS \
+	(DIV_ROUND_UP(MLX5E_KTLS_STATIC_UMR_WQE_SZ, MLX5_SEND_WQE_BB))
+
+#define MLX5E_KTLS_PROGRESS_WQE_SZ \
+	(sizeof(struct mlx5e_tx_wqe) + MLX5_ST_SZ_BYTES(tls_progress_params))
+#define MLX5E_KTLS_PROGRESS_WQEBBS \
+	(DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_BB))
+#define MLX5E_KTLS_MAX_DUMP_WQEBBS 2
+
+enum {
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD     =3D 0,
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_OFFLOAD        =3D 1,
+	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_AUTHENTICATION =3D 2,
+};
+
+enum {
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START     =3D 0,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_SEARCHING =3D 1,
+	MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_TRACKING  =3D 2,
+};
+
+struct mlx5e_ktls_offload_context_tx {
+	struct tls_offload_context_tx *tx_ctx;
+	struct tls_crypto_info *crypto_info;
+	u32 expected_seq;
+	u32 tisn;
+	u32 key_id;
+	bool ctx_post_pending;
+};
+
+struct mlx5e_ktls_offload_context_tx_shadow {
+	struct tls_offload_context_tx         tx_ctx;
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+};
+
+static inline void
+mlx5e_set_ktls_tx_priv_ctx(struct tls_context *tls_ctx,
+			   struct mlx5e_ktls_offload_context_tx *priv_tx)
+{
+	struct tls_offload_context_tx *tx_ctx =3D tls_offload_ctx_tx(tls_ctx);
+	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
+
+	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
+
+	shadow =3D (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
+
+	shadow->priv_tx =3D priv_tx;
+	priv_tx->tx_ctx =3D tx_ctx;
+}
+
+static inline struct mlx5e_ktls_offload_context_tx *
+mlx5e_get_ktls_tx_priv_ctx(struct tls_context *tls_ctx)
+{
+	struct tls_offload_context_tx *tx_ctx =3D tls_offload_ctx_tx(tls_ctx);
+	struct mlx5e_ktls_offload_context_tx_shadow *shadow;
+
+	BUILD_BUG_ON(sizeof(*shadow) > TLS_OFFLOAD_CONTEXT_SIZE_TX);
+
+	shadow =3D (struct mlx5e_ktls_offload_context_tx_shadow *)tx_ctx;
+
+	return shadow->priv_tx;
+}
+
+void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv);
+void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_t=
x *priv_tx);
+
+struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
+					 struct mlx5e_txqsq *sq,
+					 struct sk_buff *skb,
+					 struct mlx5e_tx_wqe **wqe, u16 *pi);
+void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					   struct mlx5e_tx_wqe_info *wi,
+					   struct mlx5e_sq_dma *dma);
+
+#else
+
+static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
+{
+}
+
+#endif
+
+#endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
new file mode 100644
index 000000000000..968b79ab0b70
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -0,0 +1,455 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include <linux/tls.h>
+#include "en.h"
+#include "en/txrx.h"
+#include "en_accel/ktls.h"
+
+enum {
+	MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2 =3D 0x2,
+};
+
+enum {
+	MLX5E_ENCRYPTION_STANDARD_TLS =3D 0x1,
+};
+
+#define EXTRACT_INFO_FIELDS do { \
+	salt    =3D info->salt;    \
+	rec_seq =3D info->rec_seq; \
+	salt_sz    =3D sizeof(info->salt);    \
+	rec_seq_sz =3D sizeof(info->rec_seq); \
+} while (0)
+
+static void
+fill_static_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *pr=
iv_tx)
+{
+	struct tls_crypto_info *crypto_info =3D priv_tx->crypto_info;
+	char *initial_rn, *gcm_iv;
+	u16 salt_sz, rec_seq_sz;
+	char *salt, *rec_seq;
+	u8 tls_version;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =3D
+			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+		EXTRACT_INFO_FIELDS;
+		break;
+	}
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	gcm_iv      =3D MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
+	initial_rn  =3D MLX5_ADDR_OF(tls_static_params, ctx, initial_record_numbe=
r);
+
+	memcpy(gcm_iv,      salt,    salt_sz);
+	memcpy(initial_rn,  rec_seq, rec_seq_sz);
+
+	tls_version =3D MLX5E_STATIC_PARAMS_CONTEXT_TLS_1_2;
+
+	MLX5_SET(tls_static_params, ctx, tls_version, tls_version);
+	MLX5_SET(tls_static_params, ctx, const_1, 1);
+	MLX5_SET(tls_static_params, ctx, const_2, 2);
+	MLX5_SET(tls_static_params, ctx, encryption_standard,
+		 MLX5E_ENCRYPTION_STANDARD_TLS);
+	MLX5_SET(tls_static_params, ctx, dek_index, priv_tx->key_id);
+}
+
+static void
+build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u32 sqn,
+		    struct mlx5e_ktls_offload_context_tx *priv_tx,
+		    bool fence)
+{
+	struct mlx5_wqe_ctrl_seg     *cseg  =3D &wqe->ctrl;
+	struct mlx5_wqe_umr_ctrl_seg *ucseg =3D &wqe->uctrl;
+
+#define STATIC_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_KTLS_STATIC_UMR_WQE_SZ, MLX5_SEND_WQE_DS)
+
+	cseg->opmod_idx_opcode =3D cpu_to_be32((pc << 8) | MLX5_OPCODE_UMR |
+					     (MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS << 24));
+	cseg->qpn_ds           =3D cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+					     STATIC_PARAMS_DS_CNT);
+	cseg->fm_ce_se         =3D fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+	cseg->imm              =3D cpu_to_be32(priv_tx->tisn);
+
+	ucseg->flags =3D MLX5_UMR_INLINE;
+	ucseg->bsf_octowords =3D cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) =
/ 16);
+
+	fill_static_params_ctx(wqe->tls_static_params_ctx, priv_tx);
+}
+
+static void
+fill_progress_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *=
priv_tx)
+{
+	MLX5_SET(tls_progress_params, ctx, pd, priv_tx->tisn);
+	MLX5_SET(tls_progress_params, ctx, record_tracker_state,
+		 MLX5E_TLS_PROGRESS_PARAMS_RECORD_TRACKER_STATE_START);
+	MLX5_SET(tls_progress_params, ctx, auth_state,
+		 MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD);
+}
+
+static void
+build_progress_params(struct mlx5e_tx_wqe *wqe, u16 pc, u32 sqn,
+		      struct mlx5e_ktls_offload_context_tx *priv_tx,
+		      bool fence)
+{
+	struct mlx5_wqe_ctrl_seg *cseg =3D &wqe->ctrl;
+
+#define PROGRESS_PARAMS_DS_CNT \
+	DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_DS)
+
+	cseg->opmod_idx_opcode =3D
+		cpu_to_be32((pc << 8) | MLX5_OPCODE_SET_PSV |
+			    (MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS << 24));
+	cseg->qpn_ds           =3D cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
+					     PROGRESS_PARAMS_DS_CNT);
+	cseg->fm_ce_se         =3D fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+
+	fill_progress_params_ctx(wqe->data, priv_tx);
+}
+
+static void tx_fill_wi(struct mlx5e_txqsq *sq,
+		       u16 pi, u8 num_wqebbs,
+		       skb_frag_t *resync_dump_frag)
+{
+	struct mlx5e_tx_wqe_info *wi =3D &sq->db.wqe_info[pi];
+
+	wi->skb              =3D NULL;
+	wi->num_wqebbs       =3D num_wqebbs;
+	wi->resync_dump_frag =3D resync_dump_frag;
+}
+
+void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_t=
x *priv_tx)
+{
+	priv_tx->ctx_post_pending =3D true;
+}
+
+static bool
+mlx5e_ktls_tx_offload_test_and_clear_pending(struct mlx5e_ktls_offload_con=
text_tx *priv_tx)
+{
+	bool ret =3D priv_tx->ctx_post_pending;
+
+	priv_tx->ctx_post_pending =3D false;
+
+	return ret;
+}
+
+static void
+post_static_params(struct mlx5e_txqsq *sq,
+		   struct mlx5e_ktls_offload_context_tx *priv_tx,
+		   bool fence)
+{
+	struct mlx5e_umr_wqe *umr_wqe;
+	u16 pi;
+
+	umr_wqe =3D mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_STATIC_UMR_WQE_SZ, &pi);
+	build_static_params(umr_wqe, sq->pc, sq->sqn, priv_tx, fence);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, NULL);
+	sq->pc +=3D MLX5E_KTLS_STATIC_WQEBBS;
+}
+
+static void
+post_progress_params(struct mlx5e_txqsq *sq,
+		     struct mlx5e_ktls_offload_context_tx *priv_tx,
+		     bool fence)
+{
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	wqe =3D mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_PROGRESS_WQE_SZ, &pi);
+	build_progress_params(wqe, sq->pc, sq->sqn, priv_tx, fence);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, NULL);
+	sq->pc +=3D MLX5E_KTLS_PROGRESS_WQEBBS;
+}
+
+static void
+mlx5e_ktls_tx_post_param_wqes(struct mlx5e_txqsq *sq,
+			      struct mlx5e_ktls_offload_context_tx *priv_tx,
+			      bool skip_static_post, bool fence_first_post)
+{
+	bool progress_fence =3D skip_static_post || !fence_first_post;
+
+	if (!skip_static_post)
+		post_static_params(sq, priv_tx, fence_first_post);
+
+	post_progress_params(sq, priv_tx, progress_fence);
+}
+
+struct tx_sync_info {
+	u64 rcd_sn;
+	s32 sync_len;
+	int nr_frags;
+	skb_frag_t *frags[MAX_SKB_FRAGS];
+};
+
+static bool tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx=
,
+			     u32 tcp_seq, struct tx_sync_info *info)
+{
+	struct tls_offload_context_tx *tx_ctx =3D priv_tx->tx_ctx;
+	struct tls_record_info *record;
+	int remaining, i =3D 0;
+	unsigned long flags;
+	bool ret =3D true;
+
+	spin_lock_irqsave(&tx_ctx->lock, flags);
+	record =3D tls_get_record(tx_ctx, tcp_seq, &info->rcd_sn);
+
+	if (unlikely(!record)) {
+		ret =3D false;
+		goto out;
+	}
+
+	if (unlikely(tcp_seq < tls_record_start_seq(record))) {
+		if (!tls_record_is_start_marker(record))
+			ret =3D false;
+		goto out;
+	}
+
+	info->sync_len =3D tcp_seq - tls_record_start_seq(record);
+	remaining =3D info->sync_len;
+	while (remaining > 0) {
+		skb_frag_t *frag =3D &record->frags[i];
+
+		__skb_frag_ref(frag);
+		remaining -=3D skb_frag_size(frag);
+		info->frags[i++] =3D frag;
+	}
+	/* reduce the part which will be sent with the original SKB */
+	if (remaining < 0)
+		skb_frag_size_add(info->frags[i - 1], remaining);
+	info->nr_frags =3D i;
+out:
+	spin_unlock_irqrestore(&tx_ctx->lock, flags);
+	return ret;
+}
+
+static void
+tx_post_resync_params(struct mlx5e_txqsq *sq,
+		      struct mlx5e_ktls_offload_context_tx *priv_tx,
+		      u64 rcd_sn)
+{
+	struct tls_crypto_info *crypto_info =3D priv_tx->crypto_info;
+	__be64 rn_be =3D cpu_to_be64(rcd_sn);
+	bool skip_static_post;
+	u16 rec_seq_sz;
+	char *rec_seq;
+
+	switch (crypto_info->cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		struct tls12_crypto_info_aes_gcm_128 *info =3D
+			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+
+		rec_seq =3D info->rec_seq;
+		rec_seq_sz =3D sizeof(info->rec_seq);
+		break;
+	}
+	default:
+		WARN_ON(1);
+	}
+
+	skip_static_post =3D !memcmp(rec_seq, &rn_be, rec_seq_sz);
+	if (!skip_static_post)
+		memcpy(rec_seq, &rn_be, rec_seq_sz);
+
+	mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, skip_static_post, true);
+}
+
+static int
+tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+		    skb_frag_t *frag, u32 tisn, bool first)
+{
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct mlx5_wqe_eth_seg  *eseg;
+	struct mlx5_wqe_data_seg *dseg;
+	struct mlx5e_tx_wqe *wqe;
+	dma_addr_t dma_addr =3D 0;
+	u16 ds_cnt, ds_cnt_inl;
+	u8  num_wqebbs;
+	u16 pi, ihs;
+	int fsz;
+
+	ds_cnt =3D sizeof(*wqe) / MLX5_SEND_WQE_DS;
+	ihs    =3D eth_get_headlen(skb->dev, skb->data, skb_headlen(skb));
+	ds_cnt_inl =3D DIV_ROUND_UP(ihs - INL_HDR_START_SZ, MLX5_SEND_WQE_DS);
+	ds_cnt +=3D ds_cnt_inl;
+	ds_cnt +=3D 1; /* one frag */
+
+	wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
+
+	num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
+
+	cseg =3D &wqe->ctrl;
+	eseg =3D &wqe->eth;
+	dseg =3D  wqe->data;
+
+	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP)=
;
+	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | ds_cnt);
+	cseg->imm              =3D cpu_to_be32(tisn);
+	cseg->fm_ce_se         =3D first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
+
+	eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
+	memcpy(eseg->inline_hdr.start, skb->data, ihs);
+	dseg +=3D ds_cnt_inl;
+
+	fsz =3D skb_frag_size(frag);
+	dma_addr =3D skb_frag_dma_map(sq->pdev, frag, 0, fsz,
+				    DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->pdev, dma_addr)))
+		return -ENOMEM;
+
+	dseg->addr       =3D cpu_to_be64(dma_addr);
+	dseg->lkey       =3D sq->mkey_be;
+	dseg->byte_count =3D cpu_to_be32(fsz);
+	mlx5e_dma_push(sq, dma_addr, fsz, MLX5E_DMA_MAP_PAGE);
+
+	tx_fill_wi(sq, pi, num_wqebbs, frag);
+	sq->pc +=3D num_wqebbs;
+
+	WARN(num_wqebbs > MLX5E_KTLS_MAX_DUMP_WQEBBS,
+	     "unexpected DUMP num_wqebbs, %d > %d",
+	     num_wqebbs, MLX5E_KTLS_MAX_DUMP_WQEBBS);
+
+	return 0;
+}
+
+void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					   struct mlx5e_tx_wqe_info *wi,
+					   struct mlx5e_sq_dma *dma)
+{
+	struct mlx5e_sq_stats *stats =3D sq->stats;
+
+	mlx5e_tx_dma_unmap(sq->pdev, dma);
+	__skb_frag_unref(wi->resync_dump_frag);
+	stats->ktls_ooo_dump_packets++;
+	stats->ktls_ooo_dump_bytes +=3D wi->num_bytes;
+}
+
+static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
+{
+	struct mlx5_wq_cyc *wq =3D &sq->wq;
+	u16 pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+
+	tx_fill_wi(sq, pi, 1, NULL);
+
+	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
+}
+
+static struct sk_buff *
+mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
+			 struct mlx5e_txqsq *sq,
+			 struct sk_buff *skb,
+			 u32 seq)
+{
+	struct mlx5e_sq_stats *stats =3D sq->stats;
+	struct mlx5_wq_cyc *wq =3D &sq->wq;
+	struct tx_sync_info info =3D {};
+	u16 contig_wqebbs_room, pi;
+	u8 num_wqebbs;
+	int i;
+
+	if (!tx_sync_info_get(priv_tx, seq, &info)) {
+		/* We might get here if a retransmission reaches the driver
+		 * after the relevant record is acked.
+		 * It should be safe to drop the packet in this case
+		 */
+		stats->ktls_ooo_drop_no_sync_data++;
+		goto err_out;
+	}
+
+	if (unlikely(info.sync_len < 0)) {
+		u32 payload;
+		int headln;
+
+		headln =3D skb_transport_offset(skb) + tcp_hdrlen(skb);
+		payload =3D skb->len - headln;
+		if (likely(payload <=3D -info.sync_len))
+			return skb;
+
+		stats->ktls_ooo_drop_bypass_req++;
+		goto err_out;
+	}
+
+	stats->ktls_ooo++;
+
+	num_wqebbs =3D MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS +
+		(info.nr_frags ? info.nr_frags * MLX5E_KTLS_MAX_DUMP_WQEBBS : 1);
+	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	contig_wqebbs_room =3D mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+	if (unlikely(contig_wqebbs_room < num_wqebbs))
+		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
+
+	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
+
+	for (i =3D 0; i < info.nr_frags; i++)
+		if (tx_post_resync_dump(sq, skb, info.frags[i],
+					priv_tx->tisn, !i))
+			goto err_out;
+
+	/* If no dump WQE was sent, we need to have a fence NOP WQE before the
+	 * actual data xmit.
+	 */
+	if (!info.nr_frags)
+		tx_post_fence_nop(sq);
+
+	return skb;
+
+err_out:
+	dev_kfree_skb_any(skb);
+	return NULL;
+}
+
+struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
+					 struct mlx5e_txqsq *sq,
+					 struct sk_buff *skb,
+					 struct mlx5e_tx_wqe **wqe, u16 *pi)
+{
+	struct mlx5e_ktls_offload_context_tx *priv_tx;
+	struct mlx5e_sq_stats *stats =3D sq->stats;
+	struct mlx5_wqe_ctrl_seg *cseg;
+	struct tls_context *tls_ctx;
+	int datalen;
+	u32 seq;
+
+	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
+		goto out;
+
+	datalen =3D skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	if (!datalen)
+		goto out;
+
+	tls_ctx =3D tls_get_ctx(skb->sk);
+	if (unlikely(tls_ctx->netdev !=3D netdev))
+		goto out;
+
+	priv_tx =3D mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
+
+	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
+		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
+		*wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+		stats->ktls_ctx++;
+	}
+
+	seq =3D ntohl(tcp_hdr(skb)->seq);
+	if (unlikely(priv_tx->expected_seq !=3D seq)) {
+		skb =3D mlx5e_ktls_tx_handle_ooo(priv_tx, sq, skb, seq);
+		if (unlikely(!skb))
+			goto out;
+		*wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+	}
+
+	priv_tx->expected_seq =3D seq + datalen;
+
+	cseg =3D &(*wqe)->ctrl;
+	cseg->imm =3D cpu_to_be32(priv_tx->tisn);
+
+	stats->ktls_enc_packets +=3D skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs =
: 1;
+	stats->ktls_enc_bytes   +=3D datalen;
+
+out:
+	return skb;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
index dc15c5c9e557..f8b93b62a7d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c
@@ -190,6 +190,11 @@ void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
 	struct net_device *netdev =3D priv->netdev;
 	u32 caps;
=20
+	if (mlx5_accel_is_ktls_device(priv->mdev)) {
+		mlx5e_ktls_build_netdev(priv);
+		return;
+	}
+
 	if (!mlx5_accel_is_tls_device(priv->mdev))
 		return;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h b/drive=
rs/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
index 3f5d72163b56..9015f3f7792d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.h
@@ -33,8 +33,10 @@
 #ifndef __MLX5E_TLS_H__
 #define __MLX5E_TLS_H__
=20
-#ifdef CONFIG_MLX5_EN_TLS
+#include "accel/tls.h"
+#include "en_accel/ktls.h"
=20
+#ifdef CONFIG_MLX5_EN_TLS
 #include <net/tls.h>
 #include "en.h"
=20
@@ -94,7 +96,12 @@ int mlx5e_tls_get_stats(struct mlx5e_priv *priv, u64 *da=
ta);
=20
 #else
=20
-static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv) { }
+static inline void mlx5e_tls_build_netdev(struct mlx5e_priv *priv)
+{
+	if (mlx5_accel_is_ktls_device(priv->mdev))
+		mlx5e_ktls_build_netdev(priv);
+}
+
 static inline int mlx5e_tls_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tls_cleanup(struct mlx5e_priv *priv) { }
 static inline int mlx5e_tls_get_count(struct mlx5e_priv *priv) { return 0;=
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 7d191d98ac94..71384ad1a443 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -269,6 +269,11 @@ struct sk_buff *mlx5e_tls_handle_tx_skb(struct net_dev=
ice *netdev,
 	int datalen;
 	u32 skb_seq;
=20
+	if (MLX5_CAP_GEN(sq->channel->mdev, tls)) {
+		skb =3D mlx5e_ktls_handle_tx_skb(netdev, sq, skb, wqe, pi);
+		goto out;
+	}
+
 	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
 		goto out;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index c1b73a548857..94e84db3f8f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3054,6 +3054,9 @@ int mlx5e_create_tis(struct mlx5_core_dev *mdev, void=
 *in, u32 *tisn)
=20
 	MLX5_SET(tisc, tisc, transport_domain, mdev->mlx5e_res.td.tdn);
=20
+	if (MLX5_GET(tisc, tisc, tls_en))
+		MLX5_SET(tisc, tisc, pd, mdev->mlx5e_res.pdn);
+
 	if (mlx5_lag_is_lacp_owner(mdev))
 		MLX5_SET(tisc, tisc, strict_lag_tx_port_affinity, 1);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 483d321d2151..6854f132d505 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -50,6 +50,15 @@ static const struct counter_desc sw_stats_desc[] =3D {
 #ifdef CONFIG_MLX5_EN_TLS
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
+
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_no_sync_data=
) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_bypass_req) =
},
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ctx) },
 #endif
=20
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
@@ -218,6 +227,16 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_pri=
v *priv)
 #ifdef CONFIG_MLX5_EN_TLS
 			s->tx_tls_ooo		+=3D sq_stats->tls_ooo;
 			s->tx_tls_resync_bytes	+=3D sq_stats->tls_resync_bytes;
+
+			s->tx_ktls_enc_packets           +=3D sq_stats->ktls_enc_packets;
+			s->tx_ktls_enc_bytes             +=3D sq_stats->ktls_enc_bytes;
+			s->tx_ktls_ooo                   +=3D sq_stats->ktls_ooo;
+			s->tx_ktls_ooo_drop_no_sync_data +=3D
+				sq_stats->ktls_ooo_drop_no_sync_data;
+			s->tx_ktls_ooo_drop_bypass_req   +=3D sq_stats->ktls_ooo_drop_bypass_re=
q;
+			s->tx_ktls_ooo_dump_bytes        +=3D sq_stats->ktls_ooo_dump_bytes;
+			s->tx_ktls_ooo_dump_packets      +=3D sq_stats->ktls_ooo_dump_packets;
+			s->tx_ktls_ctx                   +=3D sq_stats->ktls_ctx;
 #endif
 			s->tx_cqes		+=3D sq_stats->cqes;
 		}
@@ -1238,6 +1257,16 @@ static const struct counter_desc sq_stats_desc[] =3D=
 {
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, nop) },
+#ifdef CONFIG_MLX5_EN_TLS
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_drop_no_sync_data=
) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_drop_bypass_req) =
},
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_dump_bytes) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_dump_packets) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_enc_packets) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_enc_bytes) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ctx) },
+#endif
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_none) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, stopped) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, dropped) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index cdddcc46971b..01a0f2c9e4fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -121,6 +121,15 @@ struct mlx5e_sw_stats {
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tx_tls_ooo;
 	u64 tx_tls_resync_bytes;
+
+	u64 tx_ktls_ooo;
+	u64 tx_ktls_ooo_drop_no_sync_data;
+	u64 tx_ktls_ooo_drop_bypass_req;
+	u64 tx_ktls_ooo_dump_bytes;
+	u64 tx_ktls_ooo_dump_packets;
+	u64 tx_ktls_enc_packets;
+	u64 tx_ktls_enc_bytes;
+	u64 tx_ktls_ctx;
 #endif
 };
=20
@@ -229,6 +238,15 @@ struct mlx5e_sq_stats {
 #ifdef CONFIG_MLX5_EN_TLS
 	u64 tls_ooo;
 	u64 tls_resync_bytes;
+
+	u64 ktls_ooo;
+	u64 ktls_ooo_drop_no_sync_data;
+	u64 ktls_ooo_drop_bypass_req;
+	u64 ktls_ooo_dump_bytes;
+	u64 ktls_ooo_dump_packets;
+	u64 ktls_enc_packets;
+	u64 ktls_enc_bytes;
+	u64 ktls_ctx;
 #endif
 	/* less likely accessed in data path */
 	u64 csum_none;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 200301d6bac5..600e92cb629a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -38,6 +38,7 @@
 #include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/ktls.h"
 #include "lib/clock.h"
=20
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
@@ -320,11 +321,17 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, str=
uct sk_buff *skb,
 	if (unlikely(contig_wqebbs_room < num_wqebbs)) {
 #ifdef CONFIG_MLX5_EN_IPSEC
 		struct mlx5_wqe_eth_seg cur_eth =3D wqe->eth;
+#endif
+#ifdef CONFIG_MLX5_EN_TLS
+		struct mlx5_wqe_ctrl_seg cur_ctrl =3D wqe->ctrl;
 #endif
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
 		wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
 #ifdef CONFIG_MLX5_EN_IPSEC
 		wqe->eth =3D cur_eth;
+#endif
+#ifdef CONFIG_MLX5_EN_TLS
+		wqe->ctrl =3D cur_ctrl;
 #endif
 	}
=20
@@ -473,6 +480,14 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bu=
dget)
 			skb =3D wi->skb;
=20
 			if (unlikely(!skb)) {
+#ifdef CONFIG_MLX5_EN_TLS
+				if (wi->resync_dump_frag) {
+					struct mlx5e_sq_dma *dma =3D
+						mlx5e_dma_get(sq, dma_fifo_cc++);
+
+					mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma);
+				}
+#endif
 				sqcc +=3D wi->num_wqebbs;
 				continue;
 			}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/fw.c
index eb9680293b06..a19790dee7b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -239,6 +239,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
=20
+	if (MLX5_CAP_GEN(dev, tls)) {
+		err =3D mlx5_core_get_caps(dev, MLX5_CAP_TLS);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
=20
--=20
2.21.0

