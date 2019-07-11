Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC8B65FC7
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfGKSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:54:15 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:8419
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728469AbfGKSyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:54:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3waZ69g1NFk2KOWPRfHJPVEORdoO5mYf+AnbYDY0WGMUGrPWSw7m1Gs9vlxNUg2bzBWejd8jhYGHYrFfEfkvGcOU4gDsLoqqzyr/H6JwDJqqZ8JCwb/YrwrXrzDR3f4+C7qIvzypq1XWnI4YehCFJHVLTxJfq5zf6qnfKTtgKsSn6Lp+EO6BhFp4NqbKTBQUPCKPf+l59PoP5zrCGXw4twS6swuI9MhZJxPKbf6BtxUwz8roeNUdxG0kZ2oCO7JBsx6bJorKgATEbok28KwlpQ8jysXDAMbdWUNT/qAvbL2cXBR7Q5tqqn0R65xJT6QDF7oMpXAO9bdBVUSG2GT8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssXVf1/VAv2I/tRpT0HyIkfYv9KLqXTnMIpu5NObBAE=;
 b=dPbIHKuYc5PgLg9lfiPsZnhbBy0Gat6oSWWMqSPJLe9iI8V4Yh+pmeo8XxRhS7Z9uxsdQPbec2miBsC7/KJJBdrxI+QmNeA8ZIsBhcWvFDzrEbzD61smfDUGnryEy196SjgNttpuhdNInu4elKsUrv7IUQd0aqzsZnRUYFixT6aL24GG7ReX7hcQYLIkijV4JXX2hTZ8BtvNd3wVc8CGKHDX2hUT1MFR0zGQlcqrRNI1y7aZY6kcn2o0df5q3bzSF4nJfUyRd8BurIAVZxnR4dAimas3RtWt0gVGRpM6VmY0VrnatbHpwET+JPE987f9keix/lMpjgYaUBCSpG/Kxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssXVf1/VAv2I/tRpT0HyIkfYv9KLqXTnMIpu5NObBAE=;
 b=Uh6QGE6QUqtgkamoEF903dB0lCe0aDpJJf7YUinloox1XTewfZO+DguXzcx5x1jbr9HyZBSAT3zAwsyP38gzdHAsvm6dROxD02Jys8wgB/jBdplfgMNh4NPD9sGbborpel7voBwNvOJ1T4qLkXB1osrJPb3GR3qiduraLaU7opM=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2770.eurprd05.prod.outlook.com (10.172.218.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 11 Jul 2019 18:54:11 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::4828:eda7:c6d:69e1%9]) with mapi id 15.20.2052.022; Thu, 11 Jul 2019
 18:54:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/6] net/mlx5: E-Switch, Fix default encap mode
Thread-Topic: [net 1/6] net/mlx5: E-Switch, Fix default encap mode
Thread-Index: AQHVOBoGWcR3Fm+MckCsnHZIlNuzQw==
Date:   Thu, 11 Jul 2019 18:54:11 +0000
Message-ID: <20190711185353.5715-2-saeedm@mellanox.com>
References: <20190711185353.5715-1-saeedm@mellanox.com>
In-Reply-To: <20190711185353.5715-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4bbae51-fdbb-4b6c-3f49-08d7063128e6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2770;
x-ms-traffictypediagnostic: AM4PR0501MB2770:
x-microsoft-antispam-prvs: <AM4PR0501MB277029979BC4302EE92FEBA2BEF30@AM4PR0501MB2770.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0095BCF226
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(199004)(189003)(68736007)(6116002)(3846002)(1076003)(86362001)(446003)(81166006)(8676002)(486006)(53936002)(71190400001)(25786009)(66476007)(66446008)(64756008)(66556008)(11346002)(66946007)(14454004)(81156014)(6916009)(2616005)(476003)(36756003)(7736002)(99286004)(6506007)(50226002)(66066001)(52116002)(386003)(4326008)(76176011)(478600001)(5660300002)(2906002)(6436002)(6486002)(316002)(305945005)(102836004)(8936002)(26005)(186003)(54906003)(256004)(107886003)(71200400001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2770;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hiOPokT6h/q2qagHZYJg0kkLVvTbiFazdGGPhdY0Yyn0dtbz0BbiWk8OIe2K9klsGuVJQ1wZGPV8+ECKeWnEOYy+nrCySxrjyukYUzp3C4RrmGjRZwzcQR1Iwx8pQPEXEJ4Lc0UGiB9iNwU4FLrSDHtwzhMY085R4tumvDJrxyv+wpEdaGcW3QWshB3acITM3+0A9tREnF6t7bcvh9riDoI6QSELcmUiFh0/3116QIybbFwRoAbH5dPGlD2mma4IDvGauji55NfJ50Jex7hMWUBkaJfcFeG1kPiASJq7ClvGQGA9RpDozUoputOCR98xJbhhcU0reJNCyn8nH4BLRsCMU+zG9mjRbTqKlf79auDZ0XwGS5zl/fp2b2z/N5NG9Jpm03g6in4jMQ9PtbrMRk1aI6iibBE0xPX6XTyyKvw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4bbae51-fdbb-4b6c-3f49-08d7063128e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2019 18:54:11.6271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2770
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Encap mode is related to switchdev mode only. Move the init of
the encap mode to eswitch_offloads. Before this change, we reported
that eswitch supports encap, even tough the device was in non
SRIOV mode.

Fixes: 7768d1971de67 ('net/mlx5: E-Switch, Add control for encapsulation')
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c          | 5 -----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 7 +++++++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 6a921e24cd5e..e9339e7d6a18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1882,11 +1882,6 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->enabled_vports =3D 0;
 	esw->mode =3D SRIOV_NONE;
 	esw->offloads.inline_mode =3D MLX5_INLINE_MODE_NONE;
-	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) &&
-	    MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap))
-		esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
-	else
-		esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_NONE;
=20
 	dev->priv.eswitch =3D esw;
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 47b446d30f71..c2beadc41c40 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1840,6 +1840,12 @@ int esw_offloads_init(struct mlx5_eswitch *esw, int =
vf_nvports,
 {
 	int err;
=20
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat) &&
+	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, decap))
+		esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
+	else
+		esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+
 	err =3D esw_offloads_steering_init(esw, vf_nvports, total_nvports);
 	if (err)
 		return err;
@@ -1901,6 +1907,7 @@ void esw_offloads_cleanup(struct mlx5_eswitch *esw)
 	esw_offloads_devcom_cleanup(esw);
 	esw_offloads_unload_all_reps(esw, num_vfs);
 	esw_offloads_steering_cleanup(esw);
+	esw->offloads.encap =3D DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
=20
 static int esw_mode_from_devlink(u16 mode, u16 *mlx5_mode)
--=20
2.21.0

