Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D4ADCF65
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443345AbfJRTim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:42 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443337AbfJRTij (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMLmC5bpYOeIWAHsi/iBbeJB8vwTNLWOUY6swEyaZ2p/SC3OszAyILZasnIva0mS19JniJKDldp3VuvdvTdMVdkVIjMiBLv9DLQMwLK+WSi8IW+NhzkbuNRASVowX8G5b0C/Djc3qiuBZUmfIbYRU9BREvCNKQsFdfzffBOarBwr1cHytOn2RyqWUsoGU6z46lIr30lzen3wS0bCQT/Rgo8yze5gIYpjcqeE1EyZx7MavVuk1aA1dr4kpSSySzqIWrhTVoozrH2VauP7EEDnnN8TW0kwdurWMEPrBBNSMg6zg0ZTGX5dh1ALilyQxzGZViwmqL0byZzhNYNpshJBVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVo1GlIgjXf4pVDYU+MZaAaeSXqrolH7ALmG2oqFG1g=;
 b=JQ7Ifn9zAFyvT0H+tGCLriu+OWTFwCaM8xGba/j+suvF8EqJb4XEOicxgcZa2kIonyWL2/wjQtbL6zUWeKNoylT2+yxQ+hLXe2QOu/v0avbDVupj6JNI8YV2E/Gn92lD40H494XBRPiAHetPKgqUhynK9YzH32lBqokK3W6cJJuwAj8TGNNDLXJpxps0Ezza+h/OxuZoIC6Hh3oAFqC10ZUAQXpcmJWf7qPMrSC5sJWX2P7QUqN3Rm54VSxTCh97uGwIkTbcib2BmwcVvavhrn2s/ewaogBUcsb2mQpW3fL5uW53YSbjeLiLJeAbXpo46JGZmwcyQsE/hROZj8T1KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVo1GlIgjXf4pVDYU+MZaAaeSXqrolH7ALmG2oqFG1g=;
 b=kzZe2PjpXgsZdcthLt4+kV0Q4lUJKTDJ1tUtwlWLx3mz+2L8jE5ghdm69VAwbZKgAcCBXV7rYGUxQEKl5NbiPn7uneZRQXoJrTIhYepBQwGSB4/xsVmdZx1hxML54aQPDztXAC582vbPiuG5+BVxcmLuf2cLaMrA1KpmuK6Pqmw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Thread-Topic: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Thread-Index: AQHVheubJJkqR3lyxEm2rDcZyu4Jag==
Date:   Fri, 18 Oct 2019 19:38:24 +0000
Message-ID: <20191018193737.13959-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 7a599eb6-bb4a-4695-177c-08d75402bd92
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392506E8B6508AD7ECCDEAEBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DXQqK+I8H4HwNvbG4yk6d52DwpzQzfxn4lpZhrL6FRufDDh9FgMtqfS5g1gQrAmHmcGfe1+8YOqJHi4kvGZOxbZNPBFqDJ9rXXmwr/sa4265Rj4mwIT0FFwi9OBlp+ZsdaFhosaYhTBOREpr1rWfKAnaYPn9ApEPzLzoojsbQx+Y6P52jEfCbDgQx7U4TbVOruL2DtKiekAicgV3+pUpWGDlP77p9MCrU2jPdfpS1nf51blRJMHF/YyFyGZX9Z0Xa0E4l31NipnZ5Rw8vrFloEQAnYpzAOmj2RzHWqWGQKFogfVve+eDKq+Uea7MUxlPXlZTuo6oJxxVBrelp5zHP1cYFFm1n+S9GKjvY0xQxbqoxuh3DlamtKnLdIqMpCPLNEW5w0oDVGKaOv8IyWcCQrsawT/3STHMHlZoXJ86f0IlijNb7yQVp/gAxEqV+65Y
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a599eb6-bb4a-4695-177c-08d75402bd92
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:24.5389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jxpdB+j8A8SaMszTFJiTzxcxSJ6pNbJwlmd3GQX15vu3jMbXv4pEfsupuEeKXdldnbh0QZ240PlLuyx1ZI/mBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Once the kTLS TX resync function is called, it used to return
a binary value, for success or failure.

However, in case the TLS SKB is a retransmission of the connection
handshake, it initiates the resync flow (as the tcp seq check holds),
while regular packet handle is expected.

In this patch, we identify this case and skip the resync operation
accordingly.

Counters:
- Add a counter (tls_skip_no_sync_data) to monitor this.
- Bump the dump counters up as they are used more frequently.
- Add a missing counter descriptor declaration for tls_resync_bytes
  in sq_stats_desc.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 58 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 16 +++--
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 10 ++--
 3 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index badc6fd26a14..778dab1af8fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -185,26 +185,33 @@ struct tx_sync_info {
 	skb_frag_t frags[MAX_SKB_FRAGS];
 };
=20
-static bool tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx=
,
-			     u32 tcp_seq, struct tx_sync_info *info)
+enum mlx5e_ktls_sync_retval {
+	MLX5E_KTLS_SYNC_DONE,
+	MLX5E_KTLS_SYNC_FAIL,
+	MLX5E_KTLS_SYNC_SKIP_NO_DATA,
+};
+
+static enum mlx5e_ktls_sync_retval
+tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
+		 u32 tcp_seq, struct tx_sync_info *info)
 {
 	struct tls_offload_context_tx *tx_ctx =3D priv_tx->tx_ctx;
+	enum mlx5e_ktls_sync_retval ret =3D MLX5E_KTLS_SYNC_DONE;
 	struct tls_record_info *record;
 	int remaining, i =3D 0;
 	unsigned long flags;
-	bool ret =3D true;
=20
 	spin_lock_irqsave(&tx_ctx->lock, flags);
 	record =3D tls_get_record(tx_ctx, tcp_seq, &info->rcd_sn);
=20
 	if (unlikely(!record)) {
-		ret =3D false;
+		ret =3D MLX5E_KTLS_SYNC_FAIL;
 		goto out;
 	}
=20
 	if (unlikely(tcp_seq < tls_record_start_seq(record))) {
-		if (!tls_record_is_start_marker(record))
-			ret =3D false;
+		ret =3D tls_record_is_start_marker(record) ?
+			MLX5E_KTLS_SYNC_SKIP_NO_DATA : MLX5E_KTLS_SYNC_FAIL;
 		goto out;
 	}
=20
@@ -316,20 +323,26 @@ static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
 	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
 }
=20
-static struct sk_buff *
+static enum mlx5e_ktls_sync_retval
 mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_context_tx *priv_tx,
 			 struct mlx5e_txqsq *sq,
-			 struct sk_buff *skb,
+			 int datalen,
 			 u32 seq)
 {
 	struct mlx5e_sq_stats *stats =3D sq->stats;
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
+	enum mlx5e_ktls_sync_retval ret;
 	struct tx_sync_info info =3D {};
 	u16 contig_wqebbs_room, pi;
 	u8 num_wqebbs;
 	int i =3D 0;
=20
-	if (!tx_sync_info_get(priv_tx, seq, &info)) {
+	ret =3D tx_sync_info_get(priv_tx, seq, &info);
+	if (unlikely(ret !=3D MLX5E_KTLS_SYNC_DONE)) {
+		if (ret =3D=3D MLX5E_KTLS_SYNC_SKIP_NO_DATA) {
+			stats->tls_skip_no_sync_data++;
+			return MLX5E_KTLS_SYNC_SKIP_NO_DATA;
+		}
 		/* We might get here if a retransmission reaches the driver
 		 * after the relevant record is acked.
 		 * It should be safe to drop the packet in this case
@@ -339,13 +352,8 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_con=
text_tx *priv_tx,
 	}
=20
 	if (unlikely(info.sync_len < 0)) {
-		u32 payload;
-		int headln;
-
-		headln =3D skb_transport_offset(skb) + tcp_hdrlen(skb);
-		payload =3D skb->len - headln;
-		if (likely(payload <=3D -info.sync_len))
-			return skb;
+		if (likely(datalen <=3D -info.sync_len))
+			return MLX5E_KTLS_SYNC_DONE;
=20
 		stats->tls_drop_bypass_req++;
 		goto err_out;
@@ -360,7 +368,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 	 */
 	if (!info.nr_frags) {
 		tx_post_fence_nop(sq);
-		return skb;
+		return MLX5E_KTLS_SYNC_DONE;
 	}
=20
 	num_wqebbs =3D mlx5e_ktls_dumps_num_wqebbs(sq, info.nr_frags, info.sync_l=
en);
@@ -397,7 +405,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 		page_ref_add(skb_frag_page(f), n - 1);
 	}
=20
-	return skb;
+	return MLX5E_KTLS_SYNC_DONE;
=20
 err_out:
 	for (; i < info.nr_frags; i++)
@@ -408,8 +416,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 		 */
 		put_page(skb_frag_page(&info.frags[i]));
=20
-	dev_kfree_skb_any(skb);
-	return NULL;
+	return MLX5E_KTLS_SYNC_FAIL;
 }
=20
 struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
@@ -445,10 +452,15 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_d=
evice *netdev,
=20
 	seq =3D ntohl(tcp_hdr(skb)->seq);
 	if (unlikely(priv_tx->expected_seq !=3D seq)) {
-		skb =3D mlx5e_ktls_tx_handle_ooo(priv_tx, sq, skb, seq);
-		if (unlikely(!skb))
+		enum mlx5e_ktls_sync_retval ret =3D
+			mlx5e_ktls_tx_handle_ooo(priv_tx, sq, datalen, seq);
+
+		if (likely(ret =3D=3D MLX5E_KTLS_SYNC_DONE))
+			*wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
+		else if (ret =3D=3D MLX5E_KTLS_SYNC_FAIL)
+			goto err_out;
+		else /* ret =3D=3D MLX5E_KTLS_SYNC_SKIP_NO_DATA */
 			goto out;
-		*wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
 	}
=20
 	priv_tx->expected_seq =3D seq + datalen;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index ac6fdcda7019..7e6ebd0505cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -52,11 +52,12 @@ static const struct counter_desc sw_stats_desc[] =3D {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_bytes) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ctx) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_bytes) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_skip_no_sync_data) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_no_sync_data) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_bypass_req) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_packets) },
-	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_bytes) },
 #endif
=20
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
@@ -288,11 +289,12 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_pr=
iv *priv)
 			s->tx_tls_encrypted_bytes   +=3D sq_stats->tls_encrypted_bytes;
 			s->tx_tls_ctx               +=3D sq_stats->tls_ctx;
 			s->tx_tls_ooo               +=3D sq_stats->tls_ooo;
+			s->tx_tls_dump_bytes        +=3D sq_stats->tls_dump_bytes;
+			s->tx_tls_dump_packets      +=3D sq_stats->tls_dump_packets;
 			s->tx_tls_resync_bytes      +=3D sq_stats->tls_resync_bytes;
+			s->tx_tls_skip_no_sync_data +=3D sq_stats->tls_skip_no_sync_data;
 			s->tx_tls_drop_no_sync_data +=3D sq_stats->tls_drop_no_sync_data;
 			s->tx_tls_drop_bypass_req   +=3D sq_stats->tls_drop_bypass_req;
-			s->tx_tls_dump_bytes        +=3D sq_stats->tls_dump_bytes;
-			s->tx_tls_dump_packets      +=3D sq_stats->tls_dump_packets;
 #endif
 			s->tx_cqes		+=3D sq_stats->cqes;
 		}
@@ -1472,10 +1474,12 @@ static const struct counter_desc sq_stats_desc[] =
=3D {
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ctx) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ooo) },
-	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_data) },
-	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_req) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_packets) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_bytes) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_resync_bytes) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_skip_no_sync_data) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_data) },
+	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_req) },
 #endif
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_none) },
 	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, stopped) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 79f261bf86ac..869f3502f631 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -129,11 +129,12 @@ struct mlx5e_sw_stats {
 	u64 tx_tls_encrypted_bytes;
 	u64 tx_tls_ctx;
 	u64 tx_tls_ooo;
+	u64 tx_tls_dump_packets;
+	u64 tx_tls_dump_bytes;
 	u64 tx_tls_resync_bytes;
+	u64 tx_tls_skip_no_sync_data;
 	u64 tx_tls_drop_no_sync_data;
 	u64 tx_tls_drop_bypass_req;
-	u64 tx_tls_dump_packets;
-	u64 tx_tls_dump_bytes;
 #endif
=20
 	u64 rx_xsk_packets;
@@ -273,11 +274,12 @@ struct mlx5e_sq_stats {
 	u64 tls_encrypted_bytes;
 	u64 tls_ctx;
 	u64 tls_ooo;
+	u64 tls_dump_packets;
+	u64 tls_dump_bytes;
 	u64 tls_resync_bytes;
+	u64 tls_skip_no_sync_data;
 	u64 tls_drop_no_sync_data;
 	u64 tls_drop_bypass_req;
-	u64 tls_dump_packets;
-	u64 tls_dump_bytes;
 #endif
 	/* less likely accessed in data path */
 	u64 csum_none;
--=20
2.21.0

