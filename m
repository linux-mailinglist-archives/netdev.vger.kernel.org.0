Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E389D9A3DF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfHVXf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:35:56 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726560AbfHVXfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:35:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tp1E9yNQv80GhbRTaXJvVu3wjhuq/F+/HDqzq1Pk/XMO0mskD++GPJbE3+FBYmTqKu6V1IF9SIHAfx7slKZN0kqaLUnvzvheSR6MR8JzFkiTHC1Em/AhERuYvZuWYaksbX8TXDkCNflLUR41J76bQkzAgts5+nXFOW7ASAYFOOIiV36MPUsoCkIUiVcloEbfIw/pKrRuL5kTntu22e5ndIbDy9Hk/vnRne9P4CVW7HdW3nNzQoYP1bptmi09KfIbgVTQ670F/5tLW6hiIbwOmEp1tWFPu4v83BPO6o0PN/W9w+ZLaaytsLKx8non+ftSYSMKeNo3oLfXJsnDAgGa2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jnt10ubrTsqx/rJweGamKwKqgIb0KMw3YeGiCnT0CnU=;
 b=bJq1xXPY5kD3lHYaLmePfmPnwLvL7GYIsER7eAI/mF5au9V23k56AINHhSavPfPmT1B4t2cTFHt469BWiRsmIkDkw/i2p2txjHgCExfNB6Ov+JNiUsWaMBHIbZaAHE5XntnqOZE79JEGZYdEjEj2lyAzMWGV22LPeKruY3yhZ8nOH1ICj8OASK3oI8UtOuz9bmxBp+Yi5ORxTN/lB9LoHHPVsBH8yHMX32fOp9u4uXEHiEEcdH3CaJUGLqc/IjpPXAskk5VJulKqjI8fnHXLdcMNvCESYf4Tam9Po+oGkJLlc7ua+UF0eunkADZMyW+1CeQDJRn5N01NCv2SWwujVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jnt10ubrTsqx/rJweGamKwKqgIb0KMw3YeGiCnT0CnU=;
 b=iCHMipS6nPMoAG+Sn6xDHLwcAr1zpF0Ena2otkVaupJABy9J/hiYMxxkvE/xqGiKQwL44hDVkXjWSigwWqK12wnifwTSdjC1w+5rUAnjR03zyDFEAJCqzTFHZUImOFoMzYLvcoTt0aDOJRIJKpjNgkC+6d6LMCTS2t6TwJpTkms=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:48 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 2/8] net/mlx5e: Expose new function for TIS destroy loop
Thread-Topic: [net-next 2/8] net/mlx5e: Expose new function for TIS destroy
 loop
Thread-Index: AQHVWUJT+6HUFE0ZR06vkvFUGmdCqw==
Date:   Thu, 22 Aug 2019 23:35:48 +0000
Message-ID: <20190822233514.31252-3-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 637aab87-16d4-4302-5297-08d727597610
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2817462B1E276B1B909D9331BEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(256004)(14444005)(53936002)(14454004)(107886003)(6436002)(4326008)(8676002)(8936002)(81166006)(99286004)(81156014)(50226002)(25786009)(76176011)(316002)(54906003)(52116002)(5660300002)(71190400001)(71200400001)(186003)(386003)(66066001)(6506007)(476003)(102836004)(305945005)(1076003)(486006)(446003)(11346002)(66446008)(64756008)(66556008)(66476007)(66946007)(36756003)(6916009)(6512007)(2906002)(2616005)(26005)(3846002)(86362001)(7736002)(478600001)(6486002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7xvGqKFhqXsplVVvtWAGK3ScgwEBNewe6vtlFZ5u4ZVdCZEJK6Rvq7XtcpNvU81cQnCrv3XySB4WYM4XQz/Lr2Ss5ybKvoKSg0e/dcqe7+g0lWXknK5NUuE1IgKV3qpquAGJPDRgHoHecxg2EmeBnrLs+hDBmfQRiMNRKcHLPH7q/GsBtdDO8FS3eOvXY28w1yTxTP702ImcimE+rgjZe91Tl/60aP8ggKbjsCcfCybUND3ebh1815vRD2G2H0msKGGY9vGDteBzC/MBJ5TR1K7ixzUnok4kvWKYtYcn8IaE9d4e5oEEm1xY2bCig1deo/u+0tgdBZzjKLpkzsMU0C7wJjPrdSfAUM/vT8ZDXnCrVbAoL+w4GYOR3XE+nt+UPX75I9ieM4dGLccC+CWGqkSSCCUUDihS2VypZD46/Hc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 637aab87-16d4-4302-5297-08d727597610
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:48.4597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0plxssCMHi/aq4V1tboYhBX2O0iHezxEL4TV1ZF7KcR588j6HXS/crxAKnSvWikK2qZIkaVNTDsish2uj85uig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
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
index fa4bf2d4bcd4..d0cda5181ab4 100644
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
index 3c0d36b2b91c..b94fc3a35e10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1618,7 +1618,7 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 {
 	struct mlx5e_rep_priv *rpriv =3D priv->ppriv;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	int tc, err;
+	int err;
=20
 	err =3D mlx5e_create_tises(priv);
 	if (err) {
@@ -1654,18 +1654,15 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *pri=
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

