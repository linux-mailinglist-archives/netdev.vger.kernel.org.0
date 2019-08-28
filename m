Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020EFA0A1A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfH1S6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:58:05 -0400
Received: from mail-eopbgr50073.outbound.protection.outlook.com ([40.107.5.73]:26958
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727000AbfH1S6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:58:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYQYwGyDrOGOtZalFto+7AjBceQnVlEVeQpycI+kkWmiwC0+zb6PUWW/9w3bwRecW+ywonO2OKIieZa4Em6f4grzKI5ECImlN57zHuA5ybFy4zHMjW++FE4EzdKSPEC4nClikEKw970Yotcvevxqf60FsRhzDe6PL4N2POVxPMrp4EWFV9nkGXAgHdqYRLY/mU4xT5LCdiXhR8tfICm7mf2VLNwvZVgdrs3rLQAKa8tNO2M39Jqz0OQ2oaamoHnIK+X6M+h3SZm9w39adisw6YUMy77RAcY3NJAVnTa+6tNMM+JMV7UC+QPJ2AkUAa5m2HMuDkPqVkOA7xd0KgAwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JK1nQMuxBAzF92gt1zJ+9ZccYto7Lul5RT5587Uh5YY=;
 b=EM8JJvW2xKF874Ps4LiSVgOTa8NVw1YKUyWzPG4LNNpEpRdQUTf7SAmcMOcfdBbTckL2kl98iogU6zsikLkdJz3570COIn9nBViUabq7gt/dvPTC+34YcQdJ+0SuBkNGZBZq23NOiFle7O871RSf/Y2ddyd93zrpALVQeIOhwPv9sFqus49PmjyGWaFTgP2NRZdd9X14NokuAkKPVF3u5BvjDES/3seBLiNIjySpWdvhgCmL7qQNlTdpPokgNdoyLcqkHWpuafaq0v5MwUXgBTy+OFQ/yuX8cl1f+D+A2Tvz6cKtDqEbca4jiDP1qljZ9aQOh+j12aPFm4ONOfrjlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JK1nQMuxBAzF92gt1zJ+9ZccYto7Lul5RT5587Uh5YY=;
 b=qv/YSWLCzode73QaJy6YZh22Ll/jv31M3I23rBptzDT20labz2igH4a70BBo+c+qbkoXK6uE689XvsR7p4UI3KEEX+zulvlkRvu5YeCCUhf/N9D96pf7jAJPDakvz7P4Gl0tYD9kOdErUtSQTHQI+8yCdDGVcItsKXBuPsfQzko=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2638.eurprd05.prod.outlook.com (10.172.80.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:43 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 2/8] net/mlx5e: Expose new function for TIS destroy loop
Thread-Topic: [net-next v2 2/8] net/mlx5e: Expose new function for TIS destroy
 loop
Thread-Index: AQHVXdJ5L4OoumWxQkSEcHXyxnOg4A==
Date:   Wed, 28 Aug 2019 18:57:43 +0000
Message-ID: <20190828185720.2300-3-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2562dabe-6d3b-469e-9023-08d72be99b82
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2638;
x-ms-traffictypediagnostic: VI1PR0501MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2638E82BCB8ADE0A361F8E6EBEA30@VI1PR0501MB2638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(6512007)(107886003)(6486002)(54906003)(1076003)(25786009)(3846002)(316002)(186003)(8936002)(5660300002)(6116002)(53936002)(81156014)(6436002)(478600001)(86362001)(14454004)(2906002)(6916009)(4326008)(81166006)(36756003)(7736002)(50226002)(66446008)(305945005)(256004)(66946007)(486006)(476003)(11346002)(2616005)(66066001)(446003)(66556008)(66476007)(71200400001)(52116002)(26005)(6506007)(386003)(102836004)(14444005)(71190400001)(76176011)(64756008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2638;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s+B23ebWWkKXXF94WR6u3Scrm2Q2vHC53tGGJ/8fqy0G8mHJvg4A37ebcpIEw9gH9ucIeEFd6FDsGmOQ0q/gIh6IQJGYbYB8V27KHXWCMD3dwLOy4D5xcepp0UMoLeuJWgvwSrstCic2hA2jWUv0MucgeFYRTzDbPdnrcyEkDFnl07OUPVDxgVg2HsjVhQTNJeg6jD/dyr10E42f1PBDSRUY0HWpbe9uhPP8B8S1YsIHwW49+V9JOObHl4Skbsf41AQ8JYMWhtERE6xIpfmCyco/+cWMldETB+EqhbMftpZS8gG4HgfjlRquKiJM4WB9eJJAddqhsySFwZwGFn09j+sXPj3u7+mOje9grMpcJH+Cr98UWEvfu+NYe0pumwzV6JF+oehj/Qqp+F1LTNzAlk6UmrG2m/jEH6Ld3UbGmW4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2562dabe-6d3b-469e-9023-08d72be99b82
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:43.5562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wBnzBqsfce9yL+dmZeExX8QMyP8tA5N7JHOGaHWcChB4vC9glSJ8pxmtPK67CgeStXD81TJRobMITPMWlCRZAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

For better modularity and code sharing.
Function internal change to be introduced in the next patches.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 13 +++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  |  9 +++------
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 446792799125..491c281416d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1107,6 +1107,7 @@ int mlx5e_create_tis(struct mlx5_core_dev *mdev, void=
 *in, u32 *tisn);
 void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u32 tisn);
=20
 int mlx5e_create_tises(struct mlx5e_priv *priv);
+void mlx5e_destroy_tises(struct mlx5e_priv *priv);
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv);
 void mlx5e_update_carrier(struct mlx5e_priv *priv);
 int mlx5e_close(struct net_device *netdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 8592b98d0e70..390e614ac46e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3179,6 +3179,14 @@ void mlx5e_destroy_tis(struct mlx5_core_dev *mdev, u=
32 tisn)
 	mlx5_core_destroy_tis(mdev, tisn);
 }
=20
+void mlx5e_destroy_tises(struct mlx5e_priv *priv)
+{
+	int tc;
+
+	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
+		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
+}
+
 int mlx5e_create_tises(struct mlx5e_priv *priv)
 {
 	int err;
@@ -3208,10 +3216,7 @@ int mlx5e_create_tises(struct mlx5e_priv *priv)
=20
 static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *priv)
 {
-	int tc;
-
-	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
-		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
+	mlx5e_destroy_tises(priv);
 }
=20
 static void mlx5e_build_indir_tir_ctx_common(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index e7ac6233037d..1623cd32f303 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1621,7 +1621,7 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	int tc, err;
+	int err;
=20
 	err =3D mlx5e_create_tises(priv);
 	if (err) {
@@ -1657,18 +1657,15 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *pri=
v)
 tc_esw_cleanup:
 	mlx5e_tc_esw_cleanup(&uplink_priv->tc_ht);
 destroy_tises:
-	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
-		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
+	mlx5e_destroy_tises(priv);
 	return err;
 }
=20
 static void mlx5e_cleanup_rep_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
-	int tc;
=20
-	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
-		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
+	mlx5e_destroy_tises(priv);
=20
 	if (rpriv->rep->vport =3D=3D MLX5_VPORT_UPLINK) {
 		/* clean indirect TC block notifications */
--=20
2.21.0

