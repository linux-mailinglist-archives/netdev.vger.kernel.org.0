Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563051079F4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfKVV1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:27:07 -0500
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:59697
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726774AbfKVV1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 16:27:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntWY1DUv0fOsR5vVfEDIFtHQTC/UmobAgq3UPVON+9daCrO1vEHlRnuAqrE6c5QOXaXPJ2LNCkcvkqT7eF7/mZZ8bleY5MnLILIeqW+Co0z0oLD4saOvKXjrRhnKXjFL21WujgtZwOXwGptmMDcP79TUmkg0eJpQtg9dX9ws7xi1AU1dhUzXlBBeo6uKuG1ZJhV+LKgtNx/gv2+9JPRpZiev2WMNBcZV20+kbbOrDPYona7JfmP1Qe4hFOlDDUBDBlluNgaWBXe1OcdL08HiwEZC0xbUPsCVmDDTbJrQeQ2yVPGpGPD3VZrzLsL3Glt4Hx6ILxkrr8k1DEbVqiTO+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suAspGz1pVxeQGa9QP2H6xDtvncB8vQdaOLC7ERps18=;
 b=dZLoqlT6YThca4zVT/N6B3+PLJnWnl7KzllkD5Hz795uU4vRjxlADWHDuPW2L0NI67ozICE8kBUzMZsWpPr+tvnC2OxKZp1Xlx2fi0svgcTVYOBp5tMXJ8sTbID9MYTgwIZVqGRCyPD9Ry/BxZJBTxjg5G1ZZ7y8DvGpfqm/aj24VSM0GsIA/wK0bJKxjB631MJFBH5ZUgz4sPphxeyI8URmzgdIQKXwwkfVx+A5CJtUq9s2SbUXqDPovcoqil2N2iiqTQHvXYMvzyxNfKz1+K4bFdlldI4ldDK60eCoRKfBPD7gkF1B05dgC2+n8zn3Njq8Bk0k3mkZx02LbK1FeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suAspGz1pVxeQGa9QP2H6xDtvncB8vQdaOLC7ERps18=;
 b=J5X/DOzenWvLnrvMM2arHknneIWc+LoeNRVAzjRJDCnl0lL56EfHn+YQELgooJYQ65AFgX7im4GRVgk89tfbCqTeBTMvLMuxEpql5CSRyItg5TgcBEJPwqqUhCUx85ndjzk1CaU8nQWyomcp6+7quirU+EAOE/7Q/Jp8aZto38Q=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4350.eurprd05.prod.outlook.com (52.134.31.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 21:26:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 21:26:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 6/6] net/mlx5e: Remove redundant pointer check
Thread-Topic: [net-next 6/6] net/mlx5e: Remove redundant pointer check
Thread-Index: AQHVoXuRUrz+39eRCU2G9CGhy55JAg==
Date:   Fri, 22 Nov 2019 21:26:56 +0000
Message-ID: <20191122212541.17715-7-saeedm@mellanox.com>
References: <20191122212541.17715-1-saeedm@mellanox.com>
In-Reply-To: <20191122212541.17715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fa90479c-2d05-4c4c-6aef-08d76f92b3ad
x-ms-traffictypediagnostic: VI1PR05MB4350:|VI1PR05MB4350:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4350F6FF5D9C004FDDDDCBABBE490@VI1PR05MB4350.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(256004)(14444005)(6512007)(1076003)(76176011)(107886003)(66946007)(50226002)(6506007)(66476007)(86362001)(52116002)(66066001)(8676002)(6916009)(386003)(81166006)(25786009)(64756008)(8936002)(4326008)(99286004)(66556008)(66446008)(81156014)(6436002)(6486002)(5660300002)(36756003)(2906002)(54906003)(102836004)(316002)(7736002)(71200400001)(71190400001)(3846002)(6116002)(305945005)(186003)(26005)(478600001)(2616005)(14454004)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4350;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2UCdj3IJNxNj7WACipKwZOzSYQOHhC91XpmQrhJL5//1mbKpjynHV3hhApfZdjEfLr41zPXvOm12ZC+1ulbsxEPWH6fH9YeTMJlG5Toy9GW4A8Ng2YrG28XO3nvclQu/Km1vzNS4GF08Y92AlZ0zWGWk6EAMn0H2U/DXQZTSYSLFO0UrOVZU67c352iSX1kXl84WnmrfMTtZuv2LR9F6HVOyfzpWXu8DWzq9TiQ4ZloBNfrMkELvAC/uQK0RU1kJk79eOoL1CEAbxvI1XE9VSwjTNzU3N9K4/nugJCqYjmcQTfMEWzflLZenlLjxiSIMLYmHbKQ3eXnPZEnrOXLzyvre8YBUT5jy2kaR7xUQdWfF5QNuo0XglNwUbTysSEnXaJAiRUosJeyedRUq9kanktnMFNRo9k32uquDqK5SOXfcNYVxpYPXVnFDGSXQ/ts1
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa90479c-2d05-4c4c-6aef-08d76f92b3ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 21:26:56.9208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /6M+KvYKaW92TRx6Svs6znDapV8GIke7/ltx8NIyP3iCXbwDXv7eGNv4qj7Ls+ZCcF/DabJzWKM8sqMx28sNxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4350
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

When code reaches the "out" label, n is guaranteed to be valid so we can
unconditionally call neigh_release.

Also change the label to release_neigh to better reflect the fact that
we unconditionally free the neighbour and also match other labels
convention.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 22 +++++++++----------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index fe227713fe94..784b1e26f414 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -236,13 +236,13 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv=
 *priv,
 		mlx5_core_warn(priv->mdev, "encap size %d too big, max supported is %d\n=
",
 			       ipv4_encap_size, max_encap_size);
 		err =3D -EOPNOTSUPP;
-		goto out;
+		goto release_neigh;
 	}
=20
 	encap_header =3D kzalloc(ipv4_encap_size, GFP_KERNEL);
 	if (!encap_header) {
 		err =3D -ENOMEM;
-		goto out;
+		goto release_neigh;
 	}
=20
 	/* used by mlx5e_detach_encap to lookup a neigh hash table
@@ -294,7 +294,7 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *=
priv,
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
-		goto out;
+		goto release_neigh;
 	}
 	e->pkt_reformat =3D mlx5_packet_reformat_alloc(priv->mdev,
 						     e->reformat_type,
@@ -314,9 +314,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *=
priv,
 	mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
 free_encap:
 	kfree(encap_header);
-out:
-	if (n)
-		neigh_release(n);
+release_neigh:
+	neigh_release(n);
 	return err;
 }
=20
@@ -355,13 +354,13 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv=
 *priv,
 		mlx5_core_warn(priv->mdev, "encap size %d too big, max supported is %d\n=
",
 			       ipv6_encap_size, max_encap_size);
 		err =3D -EOPNOTSUPP;
-		goto out;
+		goto release_neigh;
 	}
=20
 	encap_header =3D kzalloc(ipv6_encap_size, GFP_KERNEL);
 	if (!encap_header) {
 		err =3D -ENOMEM;
-		goto out;
+		goto release_neigh;
 	}
=20
 	/* used by mlx5e_detach_encap to lookup a neigh hash table
@@ -412,7 +411,7 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
-		goto out;
+		goto release_neigh;
 	}
=20
 	e->pkt_reformat =3D mlx5_packet_reformat_alloc(priv->mdev,
@@ -433,9 +432,8 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
 	mlx5e_rep_encap_entry_detach(netdev_priv(e->out_dev), e);
 free_encap:
 	kfree(encap_header);
-out:
-	if (n)
-		neigh_release(n);
+release_neigh:
+	neigh_release(n);
 	return err;
 }
=20
--=20
2.21.0

