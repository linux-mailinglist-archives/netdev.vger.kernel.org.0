Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 918AEDCF5C
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443307AbfJRTiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:25 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443157AbfJRTiX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqXFr+9BHxCYfve5j3Y2Cbe8SlqEI6JO8+EznJa17tIfpdMm89/QsYfcJt5XDKjqBQhXv+8HLICDexNjvFe944v5rbo0pBfdpmq1ax3wmqL+5JXHzoSH+DtRlO/hjDlfMJU3zhK3BT/jPK/lRvtON7GLAJ2EGErgSwXkkkk6A8XQJuewPmu9YD3rmmo9q2r4rdz1QkoM1Q01CG4cpND/MNlaYdUGeF8judFaO9KtwKVVdE4nIkxNprAbaejX19+R632Qw0LhsTn5ScCp14bVywJHgyMpu7p+xfvK83G2IvVwTfKTe2Ot7LskWlM6tJnVqtTXpa6HDyo5M0mUBJk4xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSk2Ie3Q4wJ7VjbK0ZYe1+Lmre66v9UjUGYO3CoqHKI=;
 b=Eg2pgy91P6nrx/TcvNz04tdEE+GOiH/BaIUKv89Rvy8FkQcdgJ+VMkDZfWn3vi/KAD7z50byMiwxdV6IVE1lPSoISGlAbRtGfjPDsdPVmQNWpEviGQdSj9bg0IklmsanIBxQW1YtLpmhWI9Cw0HRgPzkA+emA6oFQI8uGUCMMapkk4YRPV5Zv26VnZRRIg2+cyaoBA19Uep1E1kH/fAzzgC7gtkEcKOA1P2NG5M77wSU2yBcMwbPcQEwzVgp9ylZZScurKiU/5ltKGGhx951exZbNctwxFvDHVgqitNPrHo058ceVUNfFSTem5SmZ1vHFReh5l2Mob8DEKPbFfD+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSk2Ie3Q4wJ7VjbK0ZYe1+Lmre66v9UjUGYO3CoqHKI=;
 b=DJ+JsDSeCaqv0fsNhE6TMi3MXLV/f/ZBAS5vEA4CGdNmIOhcOWr7VjMNEznAR8R7rFZ6nehium0owJP4TMG8xoeq0wDuanfRok4Ui0pDBLbTrwC9xcNEOQ6ir2Q6rDEBLqUtyb3oJWKsxQGX4PsrQvFiK38le65cwznrkhMgJF0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/15] net/mlx5e: kTLS, Size of a Dump WQE is fixed
Thread-Topic: [net 04/15] net/mlx5e: kTLS, Size of a Dump WQE is fixed
Thread-Index: AQHVheuSwzOlP/azmUesItL6CNiDzA==
Date:   Fri, 18 Oct 2019 19:38:09 +0000
Message-ID: <20191018193737.13959-5-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
In-Reply-To: <20191018193737.13959-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eb704d5-0e85-4c8f-20fb-08d75402b47b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392A8196A98AAB7587427F2BE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:275;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PevLeJtlNzHm49Kgo4qz7jtVdPSUD6vV+cbz0kPtWoL4xLxV3a1j6yUm9R43hXnNM9HmLMEeqJXgTtVq1XinlQI1Ok9xGnTOkJNsv32DqQOHZzNJI6LGOnmoNFX9J7UkIVa3JKjzBjZw4/Pkh78aPz+DJFx4d4LnI/Lr1iyYYF0SLyZEtJ8FNtdKdaAKLWB3BxcQC/f8IyXHEArvkvRd1ucY22pov+vGFSl6JcsE2X5GLq0rUuWAMMTOxL4FpJXJPLDYLJsNo232uPFbuOH+fhfSMeguP2Xr0xRhDuI//Gfn4I5rHwPznRvjQyYdpHrn4F1F05Ba3GX8s7Cysaj1LqM3Rg4j6kfJt72O9E9ZA7lvzybUQe8Wb8b35PurE9imDFzRqOtSTfZYR4EymxtNgsGdFwO14i6YyCgS6QX1j6mpcBzYh+ZA73XwcGnJfRPl
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb704d5-0e85-4c8f-20fb-08d75402b47b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:09.2919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RljSIgIowsAd5lP52S29FaQ34V0S9CAo3AocFR0vkyha6ortvjukBP6oTOKwz2IwuvMASJBhOJ5PISfgbWJRaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

No Eth segment, so no dynamic inline headers.
The size of a Dump WQE is fixed, use constants and remove
unnecessary checks.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h   |  2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h |  9 ++++++++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c       | 17 +++--------------
 3 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 182d5c5664eb..25f9dda578ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -23,7 +23,7 @@
 #define MLX5E_SQ_TLS_ROOM  \
 	(MLX5_SEND_WQE_MAX_WQEBBS + \
 	 MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS + \
-	 MAX_SKB_FRAGS * MLX5E_KTLS_MAX_DUMP_WQEBBS)
+	 MAX_SKB_FRAGS * MLX5E_KTLS_DUMP_WQEBBS)
 #endif
=20
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index c4c128908b6e..eb692feba4a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -21,7 +21,14 @@
 	 MLX5_ST_SZ_BYTES(tls_progress_params))
 #define MLX5E_KTLS_PROGRESS_WQEBBS \
 	(DIV_ROUND_UP(MLX5E_KTLS_PROGRESS_WQE_SZ, MLX5_SEND_WQE_BB))
-#define MLX5E_KTLS_MAX_DUMP_WQEBBS 2
+
+struct mlx5e_dump_wqe {
+	struct mlx5_wqe_ctrl_seg ctrl;
+	struct mlx5_wqe_data_seg data;
+};
+
+#define MLX5E_KTLS_DUMP_WQEBBS \
+	(DIV_ROUND_UP(sizeof(struct mlx5e_dump_wqe), MLX5_SEND_WQE_BB))
=20
 enum {
 	MLX5E_TLS_PROGRESS_PARAMS_AUTH_STATE_NO_OFFLOAD     =3D 0,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 90c6ce530a18..ac54767b7d86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -250,11 +250,6 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 	mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, skip_static_post, true);
 }
=20
-struct mlx5e_dump_wqe {
-	struct mlx5_wqe_ctrl_seg ctrl;
-	struct mlx5_wqe_data_seg data;
-};
-
 static int
 tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t *frag, u32 tisn, bo=
ol first)
 {
@@ -262,7 +257,6 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t =
*frag, u32 tisn, bool fir
 	struct mlx5_wqe_data_seg *dseg;
 	struct mlx5e_dump_wqe *wqe;
 	dma_addr_t dma_addr =3D 0;
-	u8  num_wqebbs;
 	u16 ds_cnt;
 	int fsz;
 	u16 pi;
@@ -270,7 +264,6 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t =
*frag, u32 tisn, bool fir
 	wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
=20
 	ds_cnt =3D sizeof(*wqe) / MLX5_SEND_WQE_DS;
-	num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS);
=20
 	cseg =3D &wqe->ctrl;
 	dseg =3D &wqe->data;
@@ -291,12 +284,8 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t=
 *frag, u32 tisn, bool fir
 	dseg->byte_count =3D cpu_to_be32(fsz);
 	mlx5e_dma_push(sq, dma_addr, fsz, MLX5E_DMA_MAP_PAGE);
=20
-	tx_fill_wi(sq, pi, num_wqebbs, frag, fsz);
-	sq->pc +=3D num_wqebbs;
-
-	WARN(num_wqebbs > MLX5E_KTLS_MAX_DUMP_WQEBBS,
-	     "unexpected DUMP num_wqebbs, %d > %d",
-	     num_wqebbs, MLX5E_KTLS_MAX_DUMP_WQEBBS);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_DUMP_WQEBBS, frag, fsz);
+	sq->pc +=3D MLX5E_KTLS_DUMP_WQEBBS;
=20
 	return 0;
 }
@@ -368,7 +357,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	stats->tls_ooo++;
=20
 	num_wqebbs =3D MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS +
-		(info.nr_frags ? info.nr_frags * MLX5E_KTLS_MAX_DUMP_WQEBBS : 1);
+		(info.nr_frags ? info.nr_frags * MLX5E_KTLS_DUMP_WQEBBS : 1);
 	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 	contig_wqebbs_room =3D mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
 	if (unlikely(contig_wqebbs_room < num_wqebbs))
--=20
2.21.0

