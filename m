Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84814F96D0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfKLROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:14:10 -0500
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:60022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbfKLROJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:14:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LscgLewkaYjDkNzvPktc9EnveBDRDf0FTN1RYBypMZoUJC8ssLrmKZasDYxe9VSAzMR8DBbRWjsXElL/oXMg7a9gvBew/t+926IU7rGistOVUBshw75uXJeFd/fXhJHb2mP1mVXeMFl9t40CT82Eqb00Fol8FpvFyqaDh0RT5s7Qeww0CpwfgjfBBDcX1otmm7/y8ud36BLitsnE/NxR6iqfwOoKlg7SBqtKibRu+F06yhKQ7F2CeFrE1pI9rc4ow4R1OyLVyyzAefRnXCh0oEyjO9LIYXjDaq8N8gM8T0loqnVLcUpPE1x5vyu5ZA+8D27gUM3SY4tZ1Xodlc54/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtgNMDIQwbVfMCX5/NE/flx28j8u2lx1H90N47orPdw=;
 b=aOfwTQ2GBVI1LTILwmHbObOSoYwW2R5zPKj5d2o8u/P9zHeY1uh50FpFb/X1vNcU39Frd74pLTg5IMh/4QT2p8oiCtqMVUzoXggJGu66eKYHdwc/MPb/wNRRAqNUKhcInK2wBwGY7n5oCS8od8fVc2rMWA8zs3zJwKi6p29OcL+tXZwA5dt37/tx6I4lNV6Z7Hqjhp+a89I34mKjxf4ros9ZnvWQn4o15Jd/FBXeMRd2EZtyS4+Q8oNWhsxj1uEjsJ/qfX1zoRyDaORlUKY5gMnrlqWOqUBzAHK9aamx92lLbH9XYgJOC6FRJbSVBW3NpnCBNiXZOEM30wgC6Mmoug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtgNMDIQwbVfMCX5/NE/flx28j8u2lx1H90N47orPdw=;
 b=NXAJVRr7MgY3QUjk91osHaVsTVSJT7f84REj+wUCf7MTY0Y4nE0/OryLe+y3KZ1Tpr+i3/OeY7olWSGWIQ9TP6u8U+bWoBn7dnHWhLl7lYx95B5AFT5p0PiO+tJHx7tzH6jHueyisO5AknfAWQDbJ9Spdj9WspbR5pnh0hEKLDk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6078.eurprd05.prod.outlook.com (20.178.125.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Tue, 12 Nov 2019 17:13:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:13:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 6/8] net/mlx5: Add devlink reload
Thread-Topic: [net-next 6/8] net/mlx5: Add devlink reload
Thread-Index: AQHVmXyMk1uNfUotdkGRSRIr2PCrLg==
Date:   Tue, 12 Nov 2019 17:13:49 +0000
Message-ID: <20191112171313.7049-7-saeedm@mellanox.com>
References: <20191112171313.7049-1-saeedm@mellanox.com>
In-Reply-To: <20191112171313.7049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cc43e68f-bccd-42c6-daa5-08d76793af57
x-ms-traffictypediagnostic: VI1PR05MB6078:|VI1PR05MB6078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6078C9EAE59393BDE1599F1BBE770@VI1PR05MB6078.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(199004)(189003)(71200400001)(446003)(71190400001)(11346002)(3846002)(76176011)(6506007)(386003)(52116002)(256004)(316002)(476003)(14444005)(2616005)(486006)(6116002)(66446008)(1076003)(102836004)(66946007)(54906003)(6512007)(64756008)(66556008)(66476007)(86362001)(5660300002)(305945005)(2906002)(6916009)(7736002)(8676002)(81166006)(50226002)(8936002)(6436002)(478600001)(6486002)(14454004)(81156014)(36756003)(26005)(186003)(25786009)(99286004)(4326008)(107886003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6078;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: berIBA32htR1LX0gRpbbGmFBEEVlIzZJEgE0HGJ6aFt0r3gh1MGPR2jEBSbVC1KK3AYHYz43Sha5aMhMeiL6CeR8kT9Y+wIv6T/hiWhT0mIk5CHgDb0XykxDLa6wT9DrXiyoJBO66e1ViRCNbDPMYRRgJzLVAKyveakknvBAO4uIIC8Sm6L+mdR9eKqzGSJffrq6qwwntsPK4aOZQxjIk46kAuckou1EhNjZOb+AIatJhoECoFkH9zr7dNNUgci42ngao0EPxX7a1ERr+ih6wI22KWMsgUphoNoN52FrOdqOxXepUWXyJZEWAuKt8qBmZyDTMe2BV4qS4MkIcLMHs6mS4dxhv8I0LXc2cy2RjXkAd0exoVOUxgbwTT49hVgZYf8V+pkDSDeDAQtDraHXfjo0YamETyLsX0LvJgqK0Pludq9PL/tVBUU9aG8+xGg+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc43e68f-bccd-42c6-daa5-08d76793af57
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:13:49.7617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h2ERPoyEencxIdk5NJZbGFuzgGmQD338Hdp2ShfdM7vmxYbJlnum8wnWzJvUlqPnUUuCfDi6/b6Unu10N9Tlgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Implement devlink reload for mlx5.

Usage example:
devlink dev reload pci/0000:06:00.0

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 20 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 ++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  3 +++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index b2c26388edb1..ac108f1e5bd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -85,6 +85,22 @@ mlx5_devlink_info_get(struct devlink *devlink, struct de=
vlink_info_req *req,
 	return 0;
 }
=20
+static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_ch=
ange,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+
+	return mlx5_unload_one(dev, false);
+}
+
+static int mlx5_devlink_reload_up(struct devlink *devlink,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+
+	return mlx5_load_one(dev, false);
+}
+
 static const struct devlink_ops mlx5_devlink_ops =3D {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set =3D mlx5_devlink_eswitch_mode_set,
@@ -96,6 +112,8 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 #endif
 	.flash_update =3D mlx5_devlink_flash_update,
 	.info_get =3D mlx5_devlink_info_get,
+	.reload_down =3D mlx5_devlink_reload_down,
+	.reload_up =3D mlx5_devlink_reload_up,
 };
=20
 struct devlink *mlx5_devlink_alloc(void)
@@ -235,6 +253,7 @@ int mlx5_devlink_register(struct devlink *devlink, stru=
ct device *dev)
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
+	devlink_reload_enable(devlink);
 	return 0;
=20
 params_reg_err:
@@ -244,6 +263,7 @@ int mlx5_devlink_register(struct devlink *devlink, stru=
ct device *dev)
=20
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_reload_disable(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index c9a091d3226c..31fbfd6e8bb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1168,7 +1168,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_put_uars_page(dev, dev->priv.uar);
 }
=20
-static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 {
 	int err =3D 0;
=20
@@ -1226,7 +1226,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, b=
ool boot)
 	return err;
 }
=20
-static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
+int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
 	if (cleanup) {
 		mlx5_unregister_device(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/=
net/ethernet/mellanox/mlx5/core/mlx5_core.h
index b100489dc85c..da67b28d6e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -243,4 +243,7 @@ enum {
=20
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
+
+int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
+int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
 #endif /* __MLX5_CORE_H__ */
--=20
2.21.0

