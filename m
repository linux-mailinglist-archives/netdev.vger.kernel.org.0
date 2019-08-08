Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D8C86B68
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404854AbfHHUW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:28 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404702AbfHHUW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbMQfPx7V+KgI5npEolXKVjIsCdsY9boXjS1GyYbi66Cjd8QvmfsoNjt/wIFBf1vhje2r7HgT+lkY5UM+5gMDz1Aorn6Bfz9MWz4MfGAyWjjL764sR9SJblbiDID1n5a4qauTougyX/stlavLBsLrlSi0kYh7PWT9m1LjA6b3Rm8U+SrX29W2/m8GJeACgm+T57bKFKC6Zcw1NJXbK0cIDG0o6twaIPSTuzti/Ze2XSWzZst46xohVGHiRyeh43J7r1Eqj+/Ir9VL8ZxO9E3z73TM4AhaUngWlz/qDhpcRNIJeL9LcxXpf1jW17p7iWIC5wfCsaYKKmBTlQWpLHCUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZ2ZE0FEao8wSfgZMaChJgy2vsHNKtk9Ch1vlfUDRbY=;
 b=euHd0J1JLEOVVdx9+cYRPr6bpOrv6hpqjZyohghS3I0x7QfzbbmVBxhLoZd5CKcMPtYAauZjWHxcGP5qACh7fg4vnPTzHtwsSdy76/wtfhUWtKakpPScFGGuGsKaMVy35g+yYPCxtOynqJII3r4Wlycx0nIMQSzSnqVUQPbr3LA4nHqhjMgJM5lUfNi0MZZR6XRM2FQ+qvMGgTGNJD2hkBrs7F8KlKW1u+dcJLRwC8ibYGlTDNKd+uaz3MHwbfRxrfYa/BKBM5TSj1uFuA84DLiHv6oSDfq57NiMSRz2/jgpzmvwR2p2kVGhpkMK6/fekji5+CzGbqSIqoVtrbhxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZ2ZE0FEao8wSfgZMaChJgy2vsHNKtk9Ch1vlfUDRbY=;
 b=Ob3PPRz3JJ6JInb1uur7VD23rCPRBW5TTwOsuaeJHrOiIFrqYPHYwgf346eSR0sXmNnnHFZ7ESKlBLZEQPAztjmqjAVTtZtzWybokkHPV7i19O7ciXel+qRE48bIvsZfcM90+0Py9/TyJBznSxvULWWaDuLJAntRaUELs7PIJjw=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:14 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/12] net/mlx5e: kTLS, Fix tisn field placement
Thread-Topic: [net 09/12] net/mlx5e: kTLS, Fix tisn field placement
Thread-Index: AQHVTib3K1lM8h2lhUmY6oj+yX+KQQ==
Date:   Thu, 8 Aug 2019 20:22:14 +0000
Message-ID: <20190808202025.11303-10-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebf511ab-9fd7-4089-2934-08d71c3e19fd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB22576BF69860289B374CDE4BBED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fBzO0jnu78LABuii51MzVYrlY9oTa0H4DxTkTc63WccpVcSQdIn+8a8ufpvZZW9/DvEcO2u2Yz9a5qkvyy2Bazk9wvWF/n+FqG/9WHQci8HiEI0o3734+aFJPxvzQo5wZrm4LkYvk/SimyUtx9I5V1saVZNhgzVzPK6ZGqGxZuvguZA3kRfsF3sTA4sMD5mJv1pLWUH55QqLIyh8OskWNXaaVf9bTNV+IA+nkuBmAMGKnjWMIMDZ+5hmyVZmfnCBFIjjZfvCSzwolzQR4HTKAOtPKWDSQbPCdn339qaFnZ43dYIgBg1o4R9dFd0WtGezdQxrKaKQtKbsCTol7SNQGoKfYLha8CL/cIbcfVmK5QqvbQcOZDoZa9Mo5XaafhdEELYMNgiqO0JdDVunegrPg6hK5grVAU/+F65Fwrg0Awo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf511ab-9fd7-4089-2934-08d71c3e19fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:14.8275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oISuJ3mLRkOX48aQcAwI7/Z0RwtHHBLfW9t2wSaO1//TMq3ui/QegdFQjppcDjpsKutMXims6itK3zDocWIyZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Shift the tisn field in the WQE control segment, per the
HW specification.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index cfc9e7d457e3..8b93101e1a09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -69,7 +69,7 @@ build_static_params(struct mlx5e_umr_wqe *wqe, u16 pc, u3=
2 sqn,
 	cseg->qpn_ds           =3D cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 					     STATIC_PARAMS_DS_CNT);
 	cseg->fm_ce_se         =3D fence ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
-	cseg->tisn             =3D cpu_to_be32(priv_tx->tisn);
+	cseg->tisn             =3D cpu_to_be32(priv_tx->tisn << 8);
=20
 	ucseg->flags =3D MLX5_UMR_INLINE;
 	ucseg->bsf_octowords =3D cpu_to_be16(MLX5_ST_SZ_BYTES(tls_static_params) =
/ 16);
@@ -278,7 +278,7 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb,
=20
 	cseg->opmod_idx_opcode =3D cpu_to_be32((sq->pc << 8)  | MLX5_OPCODE_DUMP)=
;
 	cseg->qpn_ds           =3D cpu_to_be32((sq->sqn << 8) | ds_cnt);
-	cseg->tisn             =3D cpu_to_be32(tisn);
+	cseg->tisn             =3D cpu_to_be32(tisn << 8);
 	cseg->fm_ce_se         =3D first ? MLX5_FENCE_MODE_INITIATOR_SMALL : 0;
=20
 	eseg->inline_hdr.sz =3D cpu_to_be16(ihs);
@@ -434,7 +434,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_dev=
ice *netdev,
 	priv_tx->expected_seq =3D seq + datalen;
=20
 	cseg =3D &(*wqe)->ctrl;
-	cseg->tisn =3D cpu_to_be32(priv_tx->tisn);
+	cseg->tisn =3D cpu_to_be32(priv_tx->tisn << 8);
=20
 	stats->tls_encrypted_packets +=3D skb_is_gso(skb) ? skb_shinfo(skb)->gso_=
segs : 1;
 	stats->tls_encrypted_bytes   +=3D datalen;
--=20
2.21.0

