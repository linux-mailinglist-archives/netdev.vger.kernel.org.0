Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A807E3A8
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388884AbfHAT5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:30 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:25762
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388834AbfHAT53 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIb3iOt3rQVIiIdJiRQyDr/FokWcahXVosHINCMbIhhC9wcEK1gZM6iEt8iteXi6TkW5dULDsY5ZmrgApYRmpU7vyNIuK7OxG/EI30IRjL0qOPXYNBpq2jToMyWaG24amCKJoyWMRtBl8cRgv3cPZNChl3O7Hq/XipicKY7KtrskfP//+ZY4Zxp+QmM+eYgVmzL2ex9Q6i8CHOERfa79rlxhOPdbO04Co6Q5vPTMg7qpsj1R+zWVYxfs3U2Z6aRcVTN/bWa+vGehRPi7jUJ8ZveET/lxdJMc3Jn/T6ovT9f4FA/RxZ+xkoCcg7H1v+97w6q5myd1y59oSpzl5OGyhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAA5ispHQxmXPraFcFOhQcmOG1aXsSJC11fFmxHennM=;
 b=EVL2oj3H0gMj1XaSWbdqnz2nPbG0rEB7eQp6rE1ijTJhezLwB7lTKWOVpCa4AuL2YS/h04gbEVts4LRfbB7KFL61ObYaDB2U4yzX0O3YQ7Z53ukRhx7LNDSWvI7IhQrNh3jX0mXkEXMeSueppK2ZGWEW1wCjwxh+ylnsiV/NJzFm+dZn5lXloDmbLUoYreqhlmgUDaMF3IVFoMLthIX9w4SysDzZNOBa40DPceMu1aX7i2WL6vt1JcOLxyyWOMekaFM2tVLS8JP03WOL8GVsch8O5NqjVTUkR7qMqXL//aHCNVUv2sO59MESeQlZch5uelRJjkpWdpP100//DP5nwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAA5ispHQxmXPraFcFOhQcmOG1aXsSJC11fFmxHennM=;
 b=H2T7JfSG7NfXNqi1IWnH0N65YVhDamuLJtFa4MUgBxPBFUfGr4avyGrj1AQk4JKC3BQiOVE7fRmNBJhOhq06Hv5DeCQhunA3bR1W0H60mGfR4kcBWk4l5b+HWlh0NN1XFAn6ok22K9c6eO5kp4EDC4sSNc4qNlMe+GS5Rw0CXkY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:57:01 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:57:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/12] net/mlx5e: XDP, Slight enhancement for WQE fetch
 function
Thread-Topic: [net-next 06/12] net/mlx5e: XDP, Slight enhancement for WQE
 fetch function
Thread-Index: AQHVSKNI3zkkNcHhVUi2Nv5FAsPd0Q==
Date:   Thu, 1 Aug 2019 19:57:01 +0000
Message-ID: <20190801195620.26180-7-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29b3b4d2-b7f8-4b6e-9467-08d716ba6ae7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759FB0BCFF4250359949B44BEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QJ6mbiODCYgkjlOPeP4gMI06E1jbhcS8HyG6eEfTZmGuT8SOzB+2sdv5hQ6RH7o8gcGeI32YpVhtY5rYOTRS/1fOqNJ1kaGdzxh7gkXGxe5Uwp47GqA7iLxlpzidIDDuo1XUDB5w4eIGlCLzJA9MRLtfZVBC5FyluSYZ9GF1B6ze7um/Yd9zv4ncX6Vft0OP59Z6cLNTiZx0qPJ13iZGd91JwgFgEQjvXfLJ+SZybHsLXtrmHyciDm0znMEzHHGicC6UntvxtcLtCMo7sIdV49eZVC+IvDCGk996DkAMfejTjhz0vH+fICvj+ZDLiATXdcJysw7m/okU0gxLJT31RbV7dzPegCxZYWKSFpeGt57psN+yjtesAB1lvG0ztXwfLQ87S5pZ3WpQP4rvDf0uXh0GZnIydbk6XyYvQMVuUpM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b3b4d2-b7f8-4b6e-9467-08d716ba6ae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:57:01.1233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Instead of passing an output param, let function return the
WQE pointer.
In addition, pass &pi so it gets its value in the function,
and save the redundant assignment that comes after it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |  4 +---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h | 13 ++++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index 8cb98326531f..1ed5c33e022f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -187,14 +187,12 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5=
e_xdpsq *sq)
 	if (unlikely(contig_wqebbs < MLX5_SEND_WQE_MAX_WQEBBS))
 		mlx5e_fill_xdpsq_frag_edge(sq, wq, pi, contig_wqebbs);
=20
-	mlx5e_xdpsq_fetch_wqe(sq, &session->wqe);
+	session->wqe =3D mlx5e_xdpsq_fetch_wqe(sq, &pi);
=20
 	prefetchw(session->wqe->data);
 	session->ds_count  =3D MLX5E_XDP_TX_EMPTY_DS_COUNT;
 	session->pkt_count =3D 0;
=20
-	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-
 	mlx5e_xdp_update_inline_state(sq);
=20
 	stats->mpwqe++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index e0ed7710f5f1..36ac1e3816b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -190,14 +190,17 @@ mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 	session->ds_count++;
 }
=20
-static inline void mlx5e_xdpsq_fetch_wqe(struct mlx5e_xdpsq *sq,
-					 struct mlx5e_tx_wqe **wqe)
+static inline struct mlx5e_tx_wqe *
+mlx5e_xdpsq_fetch_wqe(struct mlx5e_xdpsq *sq, u16 *pi)
 {
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
-	u16 pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	struct mlx5e_tx_wqe *wqe;
=20
-	*wqe =3D mlx5_wq_cyc_get_wqe(wq, pi);
-	memset(*wqe, 0, sizeof(**wqe));
+	*pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	wqe =3D mlx5_wq_cyc_get_wqe(wq, *pi);
+	memset(wqe, 0, sizeof(*wqe));
+
+	return wqe;
 }
=20
 static inline void
--=20
2.21.0

