Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B1CDCF63
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443338AbfJRTii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:38 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443309AbfJRTie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBVkhU6q04xSHJhixyT7G2gXPia+aCPMYCUfVKuAkEuzgBIwustZwDDpimjs6iKZYO/C+5wgQ6FpF4KsnEJfbX9ObZnT2rbtZ5aQCs9fUcAZWDy/9Xr2hJADFTAfz2U3EnBPCmSnZ9iMj1HTaAewi20wTslrq97mCtul+Vw8AFkpJ/VLq51GYqyXTq9VPX3x+GEi4C4D0+TR4iqumBEGKts1k38qfqMagHMZeqAySYD+dp47A4rx7ml6GX0KXeuG7G/N9ONJexH9NqvXzLkBTb0QQ1HEJfocThNFKWoF64TJnSvst9ZR6KoJkFXYJ/SJPKGh0y2zkweMptccikuyPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VHufOjSR/mDe9c0ABUrj9DDQWWgqmP2OppV+ubLVRU=;
 b=QkxCkv3hngptzL/A7UYI/iPYveNF9k/IYHYCEkLix1CAVtNNw/30orTHe3G4s9RGOVcWPTuIaMNtSK7lyIBuixMZAA26D1ekmYf2RFkN3CTKjmNQgd25arHDN341b7hjV1ZY5zxxkT/dI6uKPHxkj8+MgInzWP0iFQMF+laFYl0j7qLvMMNDsOAp3Lk6DMgYJLwJWVAMUqw/Mz3oiVJ+43p8DNHvFawKQFFY4fLuISX5+FsC0IXa3wHXNRf44pPM7tnu0iBi1UVrhycwBXaahoRD9OBFqzIrQoiEQ69OSFqOibm3xUm8YxbKhA0UZ3logkIlqxLQABUhbJsreR1Vlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3VHufOjSR/mDe9c0ABUrj9DDQWWgqmP2OppV+ubLVRU=;
 b=fIsv+/bFdMxSa3svz8Aq7gAPv2sLTFYg5Kfo6Ep00HOB3YT8ETrz/Qr7hLfzuUrPGerllSdzJccJvg6PO3+C7+0h0T27L5/0Srt8bFU6R4LO52ouoOtsMlAICQ8FTZbHbVzVcKLC/V8ghufRDCWJjjXC7ASqZ+eD4/RCYvuARb8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/15] net/mlx5e: kTLS, Remove unneeded cipher type checks
Thread-Topic: [net 10/15] net/mlx5e: kTLS, Remove unneeded cipher type checks
Thread-Index: AQHVheuYt8ZSCuWx0EiiNXo89gj2lA==
Date:   Fri, 18 Oct 2019 19:38:20 +0000
Message-ID: <20191018193737.13959-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 3e79d9f3-edc6-4ce4-82bf-08d75402bb24
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03921B592F77220129EFD75EBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qLG59JNjIltO2qtob9F5eU6f0JA3PpTEAC4CEyJcP+SE0ns8bGvN6QDbEYT1Ne4x2USEh5I4PCxN9uO0SH5gUwEIi0lAWQbLWELDtcKP8N1wg9MoJbqT/uugr7yFtLSzvwg2g8skt9Z0t5lTRQVbYqQeTJd3Zr06BM6rExg9rA2KVM8UOPF5+e8W93+AsCOv58MXYtZvbJ67MpOCFMNj9DKH7QHb+K7CDOtdldPdrNJUBiEDinLXg+q3yBw15kWXXFwaxW5yGbrnRFbBnaixTNEyD4ql0fQFqNVfsoB7pnYF3d6dCAFcUH3Pr1oI8VEjJY14MS1Aw/et9bJYqgfRNCE78zvm8usb4/8gT+/JUKAOrf+XdE6Hx9ntiHFOTTygec1pw0VqRiPixmByz+4/QxdvDLSwSeXa0T4O91/QJdd7yNdbeOnmJkS7NkjG/GJI
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e79d9f3-edc6-4ce4-82bf-08d75402bb24
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:20.4363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Prqz4rpYqKzLuXNcLEJk7kJJbTcNxcZrPJlSwv/R0qp3yU0cbmcDx4SRPMm8iinm4e9sTUVhAqK1A2Fz67oK8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Cipher type is checked upon connection addition.
No need to recheck it per every TX resync invocation.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index e10b0bb696da..1bfeb558ff78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -31,9 +31,6 @@ fill_static_params_ctx(void *ctx, struct mlx5e_ktls_offlo=
ad_context_tx *priv_tx)
 	char *salt, *rec_seq;
 	u8 tls_version;
=20
-	if (WARN_ON(crypto_info->cipher_type !=3D TLS_CIPHER_AES_GCM_128))
-		return;
-
 	info =3D (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 	EXTRACT_INFO_FIELDS;
=20
@@ -243,9 +240,6 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 	u16 rec_seq_sz;
 	char *rec_seq;
=20
-	if (WARN_ON(crypto_info->cipher_type !=3D TLS_CIPHER_AES_GCM_128))
-		return;
-
 	info =3D (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
 	rec_seq =3D info->rec_seq;
 	rec_seq_sz =3D sizeof(info->rec_seq);
--=20
2.21.0

