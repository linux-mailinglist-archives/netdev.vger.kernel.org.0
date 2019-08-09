Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A362D88583
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfHIWEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:50 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:23013
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729331AbfHIWEq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnzFRoK5dt4la/CF1LrKQB4Flt5e3nSKkBGXqbb7b8VANiWJQ6hA0Hp8QvBvgY8+TFhRi3iIi/8wdwxvGOngsr22ckIVB4BsydMSmfczQsjotS1/qiY+0nYx9obQ9x/0ey/7YxrOs6BlztPU/7W46Ai+93T2pNPf5rKkDyAa/ABtO5Nc2uVG1NcClyS7nuapXuNrgXPFkxVzNiQWXNmcQI0WBqxRCdeMYvpMwuocp6Dq4rCnR9Cre/Mdk+3Fxu6JIuTIQJC5T7UGtkGlPryupZq75bvMZBKd77NIllZTlZA3XTvzezGTW7dyIcxpC4xyF28oaq5ztsx7X6cxmKiv0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aawjjsy4fzjYQMlqBdbaIqtCz0s7F7KIKIyXl+3Knjk=;
 b=kS2n6/mFom8Gx/D7BfIlZtKbNPTMC/rkek/ohBrKcu9p2L5T5A4aptcC+DURx6El5D6T3mtjwwbBILi8PWmVyyzjhDYrDVmPcrQ9Yg7NqSIzo89CASkwXTNt+6xY/TeQIX8QVCVVQCFnQ2Uh6SPjkta9kvQ18cXt6bgWWAzThapiIUGqy4ClqZcmQuT8rQRdbw2m67ZJXsPm/Lrt0yXgAL+o3nK4X0bQ1aNFKdLzceMbdlrWRGzCT/+UsSh9q61OwaWONj8RMufRADyxrj2OWQ2WRuZ2n7KKVCefKqxgxo8fcRDLRB2u3tGfD/HIg/0oT6jkIEKPFPLkClyHb4CSWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aawjjsy4fzjYQMlqBdbaIqtCz0s7F7KIKIyXl+3Knjk=;
 b=h6/sbskkwW9ifdc3WvKI3943s9MIP+xgiO7aK1EbLsAqgqeWiPiH4Hn/MSroU/1SwfJAhJNpv4FWRhWY2mJkKAORax43Ke4/ui7qIKmAxLEe+HFKMbxsxUm9iciL+tcv+OcH/f4+9pDADEaiYCMgdCxIamwm0N8YZ7PeszpP9+k=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2405.eurprd05.prod.outlook.com (10.168.71.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Fri, 9 Aug 2019 22:04:41 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/15] net/mlx5e: Simplify querying port representor parent
 id
Thread-Topic: [net-next 13/15] net/mlx5e: Simplify querying port representor
 parent id
Thread-Index: AQHVTv5x0V90y6q5jESiYAHVEomUdQ==
Date:   Fri, 9 Aug 2019 22:04:41 +0000
Message-ID: <20190809220359.11516-14-saeedm@mellanox.com>
References: <20190809220359.11516-1-saeedm@mellanox.com>
In-Reply-To: <20190809220359.11516-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c1f4183-9070-4ef6-265a-08d71d159419
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2405;
x-ms-traffictypediagnostic: DB6PR0501MB2405:
x-microsoft-antispam-prvs: <DB6PR0501MB24051FD454A3721E0CD4FDC6BED60@DB6PR0501MB2405.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(189003)(199004)(446003)(66556008)(36756003)(6512007)(6436002)(99286004)(66476007)(26005)(102836004)(53936002)(478600001)(5660300002)(316002)(8936002)(4326008)(486006)(71190400001)(11346002)(2616005)(386003)(66446008)(66946007)(6506007)(186003)(64756008)(6916009)(3846002)(6116002)(256004)(52116002)(305945005)(1076003)(476003)(81156014)(8676002)(107886003)(81166006)(86362001)(7736002)(14454004)(50226002)(71200400001)(66066001)(54906003)(2906002)(25786009)(6486002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2405;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1RJ/pJ1ivejDj9Zgc375E6ll/l/LVfSAZ6KaO0xFpaGkZEEoy+a9FcoRClY62zhcx4OekFuzZJ9J83za1rKOjtZ13LK0F8Z4MoSC26LeJAfhGMeLCjJILmnKEntTUdxSyB7HUK/jCKL71+6KzRTC3zrT5q8MgVh6iErott15l47l3yY0LvTM7mp/KUY8BXqEVKM3p6sgL8MY0Cjmv47B0Ib4VlvF/rPMRtcmj9XfzvAppdnwN0pXrgBbvQK/4VWkI/vGL8nl8cmAmHbig52izcLzBCqWxfUVRlZGm6p5yOlosqmSeH7dd1+JlAPjlwJF2VeWB9JnzGzlzZWvx0ElzDGAggyolJ8EtfW5PXlCuaiNRhLh/sNp0GuJgyiS+IE2zXIgoAZB3ocp93j1u1Pzwity9dcRMQskZCUg3EbcAkU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1f4183-9070-4ef6-265a-08d71d159419
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:41.3778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPKJ+rE7H1H3odqTwIweliZQ36bjSUjntgUIc2SKnZS2gX8Gtye0krHmYr0Pd/Qls1OPYA4Z91mrxr61uY3wTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

System image GUID doesn't depend on eswitch switchdev mode.

Hence, remove the check which simplifies the code.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Vu Pham <vuhuong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index cd957ff4e207..33ae66dc72e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -389,24 +389,17 @@ static const struct ethtool_ops mlx5e_uplink_rep_etht=
ool_ops =3D {
 	.set_pauseparam    =3D mlx5e_uplink_rep_set_pauseparam,
 };
=20
-static int mlx5e_rep_get_port_parent_id(struct net_device *dev,
-					struct netdev_phys_item_id *ppid)
+static void mlx5e_rep_get_port_parent_id(struct net_device *dev,
+					 struct netdev_phys_item_id *ppid)
 {
-	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
 	u64 parent_id;
=20
 	priv =3D netdev_priv(dev);
-	esw =3D priv->mdev->priv.eswitch;
-
-	if (esw->mode =3D=3D MLX5_ESWITCH_NONE)
-		return -EOPNOTSUPP;
=20
 	parent_id =3D mlx5_query_nic_system_image_guid(priv->mdev);
 	ppid->id_len =3D sizeof(parent_id);
 	memcpy(ppid->id, &parent_id, sizeof(parent_id));
-
-	return 0;
 }
=20
 static void mlx5e_sqs2vport_stop(struct mlx5_eswitch *esw,
@@ -1759,14 +1752,11 @@ static int register_devlink_port(struct mlx5_core_d=
ev *dev,
 	struct devlink *devlink =3D priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep =3D rpriv->rep;
 	struct netdev_phys_item_id ppid =3D {};
-	int ret;
=20
 	if (!is_devlink_port_supported(dev, rpriv))
 		return 0;
=20
-	ret =3D mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
-	if (ret)
-		return ret;
+	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
=20
 	if (rep->vport =3D=3D MLX5_VPORT_UPLINK)
 		devlink_port_attrs_set(&rpriv->dl_port,
--=20
2.21.0

