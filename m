Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 683EC7E3A7
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388888AbfHAT5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:30 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388875AbfHAT5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yim4sytnja8I6x7iVttPKiHPcWOdTY7FfEUkmpgJiJvPGh3M9JmNU18B09sCgNjG1Ap7cGR8nsgKwd8fZq44ebbAWSyyoMytygOucmEpFELGqNd/HlXSSDrqDG/o5r1lFvYpkavZh38ulcODIacvhNzQveZ+pyoGJ2b5HLRR6dmrgajLrtw/SEKPboG7yeDLmalPfBaA8PXWNuICzXJ7R0uMfrEM/0Sc6+C2MKCSPB2EFva8lfohxB00HI2UyOAqgsosQ8y750lnwBtCpqMbwMGh4RcMgHKXIbxqWEQeBGIkMcRi79bTgIleeHE7eDaivsyDIOiWFryzKqIhUHwquQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZIGyTcXmqRGHz05a6z+xTwYavt4QabiFQSYHeQjHu0=;
 b=jHRafRnohyF3O4ycUv7SIEeGGR61cXWnvfxQMNQB/uWcmJMo/+XsiJCiZhKhJYYUk1rOZRPunV9GWlnM+O+1eL7FV+iiEdUPepKBK93v8rexsnbuG/4CKRv5Cx6lZgyYV+bp50SyYGzKHBmvGluaZt4YCM4+MtSvtm8wNFtTquBDsH169V+0H0SEiC97aPOtfBxbP3F8F1thYSMl3GRU9PF0KO1Mmc+vJcxX+L+jtuSrChL2A23/OAOHgdO2KaZ8UF6OjEklf60huc5yoXQMOfOsHQB3J739SrO/Um6Vx5Q/Vf++c494bKwf535IGYQ0L2xNB4Grdi7nswMkOt/C9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZIGyTcXmqRGHz05a6z+xTwYavt4QabiFQSYHeQjHu0=;
 b=miKpMs6Wv5uue06eSoVHNxB/LwKfAniOGb0dQdqEHc5tWq3E7e51eGKk35f62fk6mbPSc+n+0+zkBhH/9GUeceBr1DOGXnLWEzPPQqJpWnd1+m6+uJflo1SXTkOZ1cU3lYwDl4jxvvnxx6XiQ02nTaVCthwUVo0aPpI/wT+kJHI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:57:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:57:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/12] net/mlx5e: Set tx reporter only on successful
 creation
Thread-Topic: [net-next 10/12] net/mlx5e: Set tx reporter only on successful
 creation
Thread-Index: AQHVSKNMFuVH4j91IUepRlHrrbnV5w==
Date:   Thu, 1 Aug 2019 19:57:08 +0000
Message-ID: <20190801195620.26180-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5298a6c1-5439-4aff-bd2e-08d716ba6f41
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759CB7470A9DDF4AEC903EDBEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i3mqFISt6xkXirzOapJTQqyjAYhRPXBTAqZ4rfoUnKsKeErd3qn7FQPbCSruH5NpWZ4yTNWZblSgHRMVh2ePnCb8edXfdPij8aW/AKt/JYmQcXHKSSWmlVr0K0hdEUB5LGUVv1SdHKAYhAtwR2tgfKJv8XwQxxVSk4CV1hSdGA6f4y1owT9vnIYNv+BFA2Qbd8yrm20i2sKWygqnZcbIaISZa35JSjFW8TGGAPlfSD4+u8pW2fYNGcgE17Itve+IpxiD85Ihuz9kTP70vyBFLKMwivJdcksJwOl7ck3L5Vox60yIwtJoQCBl2bdTd7jBaVUtR1Uzwn7BEkE/g5Djxe2TwooRYF7JjFN6NQZzzdP4oxeiXIeJABZbo1U4IGbDnXuo4DopBfZKw0XhrtST/szesR39RphOAR01rpV0bak=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5298a6c1-5439-4aff-bd2e-08d716ba6f41
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:57:08.3881
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

From: Aya Levin <ayal@mellanox.com>

When failing to create tx reporter, don't set the reporter's pointer.
Creating a reporter is not mandatory for driver load, avoid
garbage/error pointer.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 14 ++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 383ecfd85d8a..f1c652f75718 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -117,7 +117,7 @@ static int mlx5_tx_health_report(struct devlink_health_=
reporter *tx_reporter,
 				 char *err_str,
 				 struct mlx5e_tx_err_ctx *err_ctx)
 {
-	if (IS_ERR_OR_NULL(tx_reporter)) {
+	if (!tx_reporter) {
 		netdev_err(err_ctx->sq->channel->netdev, err_str);
 		return err_ctx->recover(err_ctx->sq);
 	}
@@ -289,25 +289,27 @@ static const struct devlink_health_reporter_ops mlx5_=
tx_reporter_ops =3D {
=20
 int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
 {
+	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	struct devlink *devlink =3D priv_to_devlink(mdev);
=20
-	priv->tx_reporter =3D
+	reporter =3D
 		devlink_health_reporter_create(devlink, &mlx5_tx_reporter_ops,
 					       MLX5_REPORTER_TX_GRACEFUL_PERIOD,
 					       true, priv);
-	if (IS_ERR(priv->tx_reporter)) {
+	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev,
 			    "Failed to create tx reporter, err =3D %ld\n",
-			    PTR_ERR(priv->tx_reporter));
-		return PTR_ERR(priv->tx_reporter);
+			    PTR_ERR(reporter));
+		return PTR_ERR(reporter);
 	}
+	priv->tx_reporter =3D reporter;
 	return 0;
 }
=20
 void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv)
 {
-	if (IS_ERR_OR_NULL(priv->tx_reporter))
+	if (!priv->tx_reporter)
 		return;
=20
 	devlink_health_reporter_destroy(priv->tx_reporter);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index e75cb18c2256..4db595a7eb03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2325,7 +2325,7 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			goto err_close_channels;
 	}
=20
-	if (!IS_ERR_OR_NULL(priv->tx_reporter))
+	if (priv->tx_reporter)
 		devlink_health_reporter_state_update(priv->tx_reporter,
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
=20
--=20
2.21.0

