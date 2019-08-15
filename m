Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396498F42D
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732736AbfHOTKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:21 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732639AbfHOTKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMPR4HqOr9NyDkB63ke6r5dMdlZlYKk75b5xjy8K+YuJdjYu+qq22gqr1922vr+neHjmCg5lZ+WBdrHEqsD+yYD4YiKdLgzg6HETmpgj4Y2RwEMoAVqkEDT0NAQ9k4jEDU3KBdADaBjVmSEqrNvV39wdRt8zNa+T9s+4hGnjMJiqJXj75zb+qdL4p28hE4zGX/3W9QqRSP5pkppJB+tlywDQPS3mURb4XwNvjJfkA/Ph2O9VwEj4JWt+ZZ3HkoAaZWFRmHHLgDIO6rDV5Z4MD58DdBDTfD9PYvHxLvchP1Pm7B9UDJPJuQ69juB38WjhXK6zNkCiiV9RyMMB3no0qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1kYxFBjik9N2xwFOav7mAeZBawod6t9fQeX+h5hr9o=;
 b=FrkYS1xwxrQ6d/EqU+639UhOg6gl4PR+th8emaFzHWkYLkYAAcFZJL2UPSp8CRpM4MgP+dg6SCj706bTx2tv/D0UXa+3liztDbaJEhCVpVa44LvIFvN/1sIpe3taSktk2S2CbthMsgFYJ5mQt0F9GWhpylKJ+Ury/i9DPe0UkLFlBIgTxjEccWWq/2kl5/YsR4/5x8prSlzPE0gLffEMf3l23TecVy9YgZffLX9e5+Mc9mQjM4tFtKiQ2q81pJQ4gn4GRIyebzsgOQ3AYPfdZNm9VGJ4hmKzk1Ghp+5jN8xBIsMPlwvoDJnwTS8S8nbE8J1HmmcTFHwBlEkzV4ETIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1kYxFBjik9N2xwFOav7mAeZBawod6t9fQeX+h5hr9o=;
 b=CH9sjXu8zCaxxiEb2qbP12DPz5gfUE0QGaEnIH4m9fw8HU3pzbh09nrSaerwPUtALsRBBRQKzhzYsJFI0Ea+h8pRI/0GzJNHFEqsO/LOpRhObstDU+ZwayOiZMZiAmq3fEJpy8D8os7evHUyOlbiDjlwe59Bp6KSOlSZJT/dwnc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:00 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/16] net/mlx5e: Add helper functions for reporter's
 basics
Thread-Topic: [net-next 07/16] net/mlx5e: Add helper functions for reporter's
 basics
Thread-Index: AQHVU50IAnqtLfDUkkGl58Kokaj0dg==
Date:   Thu, 15 Aug 2019 19:10:00 +0000
Message-ID: <20190815190911.12050-8-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94876235-f943-45a7-0830-08d721b42b39
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2440FBE3E3F1EF8DC3429615BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qtObe2VnJULk6vjjuYVveSWRF9GthCRgnZ3cSqH+6ux1XHJIFRvFVY5KBWoKEuxFo3lexZL9fdlOTesX/DkRQzN4ZpsE0NLnnhkx5i/jYB6YHCrDo3quKZkTCv95VD07mO1n+swGrpjGfWsR45oPtCNIhL5khErqv1rDyqErEGEvk9eu89DtCCyf7LSBGq0FwruU2Ch8tpIhoKHE1Nd5XbJXgWZ5XRhU20XWKd4eyN2rtcYRCMs7BhtCp7LsDZRZaZERJtevk4ZL5NgDcx27MySvDNfb0SaOBVTQjcTTRy5Xyz5NdZTf3UnlvyNi3SZBX+K1wdu9YFV4HFcw9dwn95/9Mx9ssVgWkDq3jHjUANvH1Z6wO04xb44OsbsRNjh62YX5rUvxb5O0ZFBh3hBps7ivp75Nbot0KHdWRbGl+Uo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94876235-f943-45a7-0830-08d721b42b39
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:00.1221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lFPDF7VgXh1ZN2TaokQemnrMKFbj3+/d/umtCLhBHc5w131vLsqJs0VWTgZH4aGGIo9mTfmsUU+4z4TsY1mRYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce helper functions for create and destroy reporters and update
channels. In the following patch, rx reporter is added and it will use
these helpers too.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/health.c | 17 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h |  4 ++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  9 +++------
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
index 63bf94cd5b67..c003757fbec0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -96,6 +96,23 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *c=
q, struct devlink_fmsg *
 	return 0;
 }
=20
+int mlx5e_health_create_reporters(struct mlx5e_priv *priv)
+{
+	return  mlx5e_reporter_tx_create(priv);
+}
+
+void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv)
+{
+	mlx5e_reporter_tx_destroy(priv);
+}
+
+void mlx5e_health_channels_update(struct mlx5e_priv *priv)
+{
+	if (priv->tx_reporter)
+		devlink_health_reporter_state_update(priv->tx_reporter,
+						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
+}
+
 int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
 {
 	struct mlx5_core_dev *mdev =3D channel->mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index 6725d417aaf5..b2c0ccc79b22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -29,5 +29,9 @@ int mlx5e_health_recover_channels(struct mlx5e_priv *priv=
);
 int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx);
+int mlx5e_health_create_reporters(struct mlx5e_priv *priv);
+void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv);
+void mlx5e_health_channels_update(struct mlx5e_priv *priv);
+
=20
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index aa71530a043c..656e9be4f301 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2324,10 +2324,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			goto err_close_channels;
 	}
=20
-	if (priv->tx_reporter)
-		devlink_health_reporter_state_update(priv->tx_reporter,
-						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
-
+	mlx5e_health_channels_update(priv);
 	kvfree(cparam);
 	return 0;
=20
@@ -3202,7 +3199,6 @@ static void mlx5e_cleanup_nic_tx(struct mlx5e_priv *p=
riv)
 {
 	int tc;
=20
-	mlx5e_reporter_tx_destroy(priv);
 	for (tc =3D 0; tc < priv->profile->max_tc; tc++)
 		mlx5e_destroy_tis(priv->mdev, priv->tisn[tc]);
 }
@@ -4970,12 +4966,14 @@ static int mlx5e_nic_init(struct mlx5_core_dev *mde=
v,
 		mlx5_core_err(mdev, "TLS initialization failed, %d\n", err);
 	mlx5e_build_nic_netdev(netdev);
 	mlx5e_build_tc2txq_maps(priv);
+	mlx5e_health_create_reporters(priv);
=20
 	return 0;
 }
=20
 static void mlx5e_nic_cleanup(struct mlx5e_priv *priv)
 {
+	mlx5e_health_destroy_reporters(priv);
 	mlx5e_tls_cleanup(priv);
 	mlx5e_ipsec_cleanup(priv);
 	mlx5e_netdev_cleanup(priv->netdev, priv);
@@ -5078,7 +5076,6 @@ static int mlx5e_init_nic_tx(struct mlx5e_priv *priv)
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_initialize(priv);
 #endif
-	mlx5e_reporter_tx_create(priv);
 	return 0;
 }
=20
--=20
2.21.0

