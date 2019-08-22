Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4489A156
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404516AbfHVUlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:41:44 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:41706
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404465AbfHVUlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:41:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXQk+IEUOGFbum6CeLNAlt+e9EphP8VP+hT7ZJSoG+xQl3kAe8T9WfYjXWOTS6AfyVTcG26ZzYae8/Jb3VrmBA4ZSrtsoTys7Hfceno8A0fTWU9dIFWIHheambgGQYhTSAPOa4OW+uDAfxJDeSU0Qftojj+wAe3Ywk9W8tMzE+H1Le5hjnruJy8yuFMxLZhShjd5gUWhgVnNE7M0KeRHh4Xh+rd1+kynwdAP9RA70sLlZUQah6xuxPcGFqmG2wT+Td/4NmMOb+GzfNpy7WSypbnoOIbJZ0ncabG06raoXyrP9RRJxPPIfdbB3gKE/VkLQNtRHAQY1sclEFFJYluHqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkjzRKJ3O2FSs5ShVfi5lwVPnPhK3JtPDwCLEsMVobw=;
 b=hgBxH2ktlBFHiRCzLfmJjeSfRSYngmCjPeGzZUklcBWg7FlhS64h5wsbhV/oGNaqdXUj3TJc5DXeogljLNkjs2Wa01p3EVi5GcrwpfzieLR+iGsT6XM2AJWes9Q+/v2aQPV79FQ+TJgIu6FZt2iamlV7od7/i/tsRnU8bpSQXo6/Oiz2GtALkFV9rpPv3VhZzPyg8fpw5OBbJujodBEzw8MkImM1YSA9yKSrEJMss9BnhnABNM1FEfybupYTT41ZtS12JS4q4tmtUzxZHX3sIPB3Xmw5uMcIcw26fRy3NokDTEnGzBPI3o32VaKvlvSpkmIlBnWaOfledbxX2SneSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkjzRKJ3O2FSs5ShVfi5lwVPnPhK3JtPDwCLEsMVobw=;
 b=M95Jbdu3cjN2r1MM9WCpw4JLbJzUh5x55BPoO7NqKLRG4joOE7WXvbTB+8BuzftJMUFnwt+hHMHWetoEovliqVCc4xYtSPVSnaGGoD4lCz5FF2D642edZWwisCPbP1fiZNbNTP9AwQ1NHzcJ2qRC/4oyOiFjf53o4JBFB9UXkXs=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2724.eurprd05.prod.outlook.com (10.172.221.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 20:41:40 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 20:41:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/4] net/mlx5e: Add num bytes metadata to WQE info
Thread-Topic: [net 3/4] net/mlx5e: Add num bytes metadata to WQE info
Thread-Index: AQHVWSoAQYs8mY7IvUGTjiwlgQTMVQ==
Date:   Thu, 22 Aug 2019 20:41:40 +0000
Message-ID: <20190822204121.16954-4-saeedm@mellanox.com>
References: <20190822204121.16954-1-saeedm@mellanox.com>
In-Reply-To: <20190822204121.16954-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d76686b7-0e55-4214-229c-08d72741227b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2724;
x-ms-traffictypediagnostic: AM4PR0501MB2724:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2724BA771763B2E9D4063FC5BEA50@AM4PR0501MB2724.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(199004)(189003)(446003)(36756003)(316002)(54906003)(478600001)(476003)(66946007)(64756008)(11346002)(8936002)(81156014)(50226002)(66556008)(8676002)(81166006)(4326008)(66476007)(486006)(2616005)(102836004)(66066001)(386003)(1076003)(6506007)(7736002)(305945005)(5660300002)(66446008)(26005)(6486002)(6916009)(71190400001)(71200400001)(6116002)(53936002)(256004)(14444005)(3846002)(14454004)(107886003)(186003)(25786009)(99286004)(76176011)(52116002)(2906002)(6512007)(6436002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2724;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AJbY77R8jH5PJzhOKrcb+Zc9VGv9iuJHXNpDGw/eOryqmMRy3pm62Hv2PG9Oq8n1CLP5it+WtOkEWW/2k0BArd6Otgtt02pjj4kXjaZ4DWKjoGadmLnuYkvfAvfll7Qxz1V3BzrZp4yv6VnXVyGqmNIPmv7sH62omPnpyU1DikFPfOEjz+VlwkUk5h5WSp8Tnjapsz//sowsdFItFzoGJmn8zQmb0UUh9IRvZ88FApP1o/byELMltHqos1wSAG5FzCw9GFolKmxp28i+Y8u0/mhNAe4jzSWe0yA4pWcLmmLLPFz49qjM9pyQUjxumQu993vu4cdG5j9zZMhy84YlXsaVdW5My9b9HTe9K81qDFzCeadlaiZpr1NTzyR1+fIq8IVDJZVlahPc6KImUTRK0KLUtQVVuOMHMcPr/C/f9vk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d76686b7-0e55-4214-229c-08d72741227b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 20:41:40.4345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JlRwAdC0TeG71lz2c6jqNmL8IUyCjBBdy6Pr70f1WIUNsYydrMAGmDUAnaoQ9CtiTd+10iAR9E8lPJGBPGqoXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2724
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

For TLS WQEs, metadata info did not include num_bytes. Due to this issue,
tx_tls_dump_bytes counter did not increment.

Modify tx_fill_wi() to fill num bytes. When it is called for non-traffic
WQE, zero is expected.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c   | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 8b93101e1a09..0681735ea398 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -109,13 +109,15 @@ build_progress_params(struct mlx5e_tx_wqe *wqe, u16 p=
c, u32 sqn,
=20
 static void tx_fill_wi(struct mlx5e_txqsq *sq,
 		       u16 pi, u8 num_wqebbs,
-		       skb_frag_t *resync_dump_frag)
+		       skb_frag_t *resync_dump_frag,
+		       u32 num_bytes)
 {
 	struct mlx5e_tx_wqe_info *wi =3D &sq->db.wqe_info[pi];
=20
 	wi->skb              =3D NULL;
 	wi->num_wqebbs       =3D num_wqebbs;
 	wi->resync_dump_frag =3D resync_dump_frag;
+	wi->num_bytes        =3D num_bytes;
 }
=20
 void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_t=
x *priv_tx)
@@ -143,7 +145,7 @@ post_static_params(struct mlx5e_txqsq *sq,
=20
 	umr_wqe =3D mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_STATIC_UMR_WQE_SZ, &pi);
 	build_static_params(umr_wqe, sq->pc, sq->sqn, priv_tx, fence);
-	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, NULL);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, NULL, 0);
 	sq->pc +=3D MLX5E_KTLS_STATIC_WQEBBS;
 }
=20
@@ -157,7 +159,7 @@ post_progress_params(struct mlx5e_txqsq *sq,
=20
 	wqe =3D mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_PROGRESS_WQE_SZ, &pi);
 	build_progress_params(wqe, sq->pc, sq->sqn, priv_tx, fence);
-	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, NULL);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, NULL, 0);
 	sq->pc +=3D MLX5E_KTLS_PROGRESS_WQEBBS;
 }
=20
@@ -296,7 +298,7 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb,
 	dseg->byte_count =3D cpu_to_be32(fsz);
 	mlx5e_dma_push(sq, dma_addr, fsz, MLX5E_DMA_MAP_PAGE);
=20
-	tx_fill_wi(sq, pi, num_wqebbs, frag);
+	tx_fill_wi(sq, pi, num_wqebbs, frag, fsz);
 	sq->pc +=3D num_wqebbs;
=20
 	WARN(num_wqebbs > MLX5E_KTLS_MAX_DUMP_WQEBBS,
@@ -323,7 +325,7 @@ static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
 	u16 pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
=20
-	tx_fill_wi(sq, pi, 1, NULL);
+	tx_fill_wi(sq, pi, 1, NULL, 0);
=20
 	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
 }
--=20
2.21.0

