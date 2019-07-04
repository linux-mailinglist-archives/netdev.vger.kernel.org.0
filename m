Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DE45FCCA
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfGDSQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:20 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:20736
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727229AbfGDSQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0mme7zyrKLkp086TmBwt3WhCcuoDfMsER2Y4UAoCuQ=;
 b=P3PPidi0+4kkpZf/58OmLc0TZN3+COaXw3/IVQ2cuFO2OFXHA4nMuE1QQF7KuBr+3WBMt8Q6Pqm2GzkRET7ocENRjJl9GOLNdOhMhJANZGabHJ1FmAXWmeoNoqJBtxz6qnd+eTf3cDWemymmgDVGKQlWGYrDQbxOoJX1y3s8nzE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:16:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:16:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/14] net/mlx5e: Tx, Unconstify SQ stop room
Thread-Topic: [net-next 11/14] net/mlx5e: Tx, Unconstify SQ stop room
Thread-Index: AQHVMpSNz7R1XNF+A0mED3TeAtJ+ng==
Date:   Thu, 4 Jul 2019 18:16:08 +0000
Message-ID: <20190704181235.8966-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 823f8932-2cd4-4333-e78f-08d700abaf5a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB25845522F4B5A586A6DAEDB3BEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:148;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NPSVIaqC/ohi3ZL8k63Dswu+tox5QIfeXCrWEeMBB+vsaNkl5YaBlmbBWLxP4s4aj2BwqCM+DrVA3NX1IyRWp3w3jb7crF0rTV8jZ8xD3cFS5RblDtjcE7PZ7GMS7N6/izWW91yeO6ZpNR6CAscNgEFjW+lOPRBgfCzRNaFoArbUIguYyhCQ5I0uYwy6Lvo/DvUxZXPICwhz+s8wCY2lusXZTmdtsMhnR4DwPaxs21nztx6sY9ZsRnAkza+6IsdROMFs7vWus3Z+OTdJfvv8Yh8BQxxJI5SMbVvGKxwVmvbSvmrB0I7UQCu4iUCSzTD4BKCt2KqHZbCoiTAopBuOe1xqQjiGUsAPUJI+1Nd3WmFHFz0PmygLvDYGMmeH19FK62RveQvI1Atzj1Y9bE9yHmDns/ZFkY6SlA5btNkBSdk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 823f8932-2cd4-4333-e78f-08d700abaf5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:16:08.1946
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

Use an SQ field for stop_room, and use the larger value only if TLS
is supported.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h   |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  | 14 ++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c  |  5 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c    | 18 ++----------------
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index d618b3a01bee..6ef1da508588 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -375,6 +375,7 @@ struct mlx5e_txqsq {
 	void __iomem              *uar_map;
 	struct netdev_queue       *txq;
 	u32                        sqn;
+	u16                        stop_room;
 	u8                         min_inline_mode;
 	struct device             *pdev;
 	__be32                     mkey_be;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 1280f4163b53..af6aec717d4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -6,6 +6,20 @@
=20
 #include "en.h"
=20
+#define MLX5E_SQ_NOPS_ROOM  MLX5_SEND_WQE_MAX_WQEBBS
+#define MLX5E_SQ_STOP_ROOM (MLX5_SEND_WQE_MAX_WQEBBS +\
+			    MLX5E_SQ_NOPS_ROOM)
+
+#ifndef CONFIG_MLX5_EN_TLS
+#define MLX5E_SQ_TLS_ROOM (0)
+#else
+/* TLS offload requires additional stop_room for:
+ *  - a resync SKB.
+ */
+#define MLX5E_SQ_TLS_ROOM  \
+	(MLX5_SEND_WQE_MAX_WQEBBS)
+#endif
+
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
=20
 static inline bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index cfeeb734ae8f..2d63d4832591 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1086,11 +1086,14 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *=
c,
 	sq->uar_map   =3D mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode =3D params->tx_min_inline_mode;
 	sq->stats     =3D &c->priv->channel_stats[c->ix].sq[tc];
+	sq->stop_room =3D MLX5E_SQ_STOP_ROOM;
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
 	if (MLX5_IPSEC_DEV(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
-	if (mlx5_accel_is_tls_device(c->priv->mdev))
+	if (mlx5_accel_is_tls_device(c->priv->mdev)) {
 		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
+		sq->stop_room +=3D MLX5E_SQ_TLS_ROOM;
+	}
=20
 	param->wq.db_numa_node =3D cpu_to_node(c->cpu);
 	err =3D mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 9740ca51921d..200301d6bac5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -40,19 +40,6 @@
 #include "en_accel/en_accel.h"
 #include "lib/clock.h"
=20
-#define MLX5E_SQ_NOPS_ROOM  MLX5_SEND_WQE_MAX_WQEBBS
-
-#ifndef CONFIG_MLX5_EN_TLS
-#define MLX5E_SQ_STOP_ROOM (MLX5_SEND_WQE_MAX_WQEBBS +\
-			    MLX5E_SQ_NOPS_ROOM)
-#else
-/* TLS offload requires MLX5E_SQ_STOP_ROOM to have
- * enough room for a resync SKB, a normal SKB and a NOP
- */
-#define MLX5E_SQ_STOP_ROOM (2 * MLX5_SEND_WQE_MAX_WQEBBS +\
-			    MLX5E_SQ_NOPS_ROOM)
-#endif
-
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
 	int i;
@@ -267,7 +254,7 @@ mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_=
buff *skb,
 		skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
=20
 	sq->pc +=3D wi->num_wqebbs;
-	if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, MLX5E_SQ_STOP_RO=
OM))) {
+	if (unlikely(!mlx5e_wqc_has_room_for(wq, sq->cc, sq->pc, sq->stop_room)))=
 {
 		netif_tx_stop_queue(sq->txq);
 		sq->stats->stopped++;
 	}
@@ -528,8 +515,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bud=
get)
 	netdev_tx_completed_queue(sq->txq, npkts, nbytes);
=20
 	if (netif_tx_queue_stopped(sq->txq) &&
-	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
-				   MLX5E_SQ_STOP_ROOM) &&
+	    mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc, sq->stop_room) &&
 	    !test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state)) {
 		netif_tx_wake_queue(sq->txq);
 		stats->wake++;
--=20
2.21.0

