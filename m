Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4263E79AC9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388540AbfG2VN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:27 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2445
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388459AbfG2VNZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cg0KwjrRBhNGPsHPvTBE9yvN2vgxxb6vNwLBDJyhAfvOQXb3wL1pP+8WZ20mms53N9+BI6sqbSxCa69siLCgVyqFo44VVSA3qk7ibaY3TayTpaUXjhLZO2i+ZtzVmDM45+0wYXjU8BNTDNIHrt+6nfQX4IOB+GvF0LWFNgzIJmzN7x3R6jrxzB2vPLu5nPVNGMiAW/yLeq4tySk4+hUPSt4sc7RyAyFa+cyKkKc3ys0al5zqYu0sFflze57lNWfVimGsUVskKw8U4ZIESk4HmVUVH1IEn0XCpQIFSAwKBxDuMt8Qi20htC2becSwMgAUcs+ZeW/KE947tzlFIuKyrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0i5aejQlheFphj2M+F0pcIc0C5Cn833NpesqFdDiR0=;
 b=d+A9Riv0I1L9SofgyCKUgFtd9HFG5vo0c7qwKykx23RBPhVHkRSHYPczF+xTRlyV5+55W38/BoXHl1dYQdZ7IClh6TF7aZ78bBtmj5jiko84oARDM4cms4crgwDq9v9GOUvJnanukW6JRm0Q1as4SwOw7FrflwB9fOPNXTC7X+XWkD7aokSqBclC8MDTLKRnhazRFISzPeiGHVl4kUvd7o1wcpiK1voJjcrsDooIwdtqDAB8A+0lDjh50ldM2Db3q+sDxoeDfUNjSTDkJEp/MazKgRaiyMOCWGy3yPpR1WZ6U+rkwal+DmD5C9TIrk+rfwHPcGxVYUtla6zeQjSl/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J0i5aejQlheFphj2M+F0pcIc0C5Cn833NpesqFdDiR0=;
 b=Qh000N4zuq/gpiWRxg9FRdWSIQDL1vGElbQNaDJfape7aZsILt3rmPlqQEuMF2KRa16VDPLFzS3ObsNpsQ+CYH9cqea9fcohltGiIwGxuDeI0RTa2zooIi58gIQGlcp0iNY9KBRh5aHqRTiGwkxoBDOqkkialQ70iCrbptdPBmw=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:13:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:13:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Roi Dayan <roid@mellanox.com>
Subject: [PATCH mlx5-next 09/11] net/mlx5: E-Switch, remove redundant error
 handling
Thread-Topic: [PATCH mlx5-next 09/11] net/mlx5: E-Switch, remove redundant
 error handling
Thread-Index: AQHVRlJr9MeQVxMrKkqK89Z/73ncQQ==
Date:   Mon, 29 Jul 2019 21:13:08 +0000
Message-ID: <20190729211209.14772-10-saeedm@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df21c283-c229-42b0-24a4-08d714698dca
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB2375AD0571EF72A1F7D7CB06BEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(4744005)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9lMJhpJWtZmIuajtc0QNBGLz4HcddiXg7D4M1JKP3+SmJAk28+xjV1AnL/cZ2BHUAr0W/+d+qxqm822t4FoaU1PrX5XlVYJ9IXBVkhrc1jbd6+5MCCjJtBpq7rzIKZmp4CWhNmKvyXf6Qfdr7Rp8d483iE/+SvOnDu3MSxIx/WHlN+zvHm73ZqELHtc1Yn6ySxuU68Mo2a+jQSaqsE294wWFGTwY9UzKt4QgYX854qe70IpCAoqO64057g2LTNODf+O1sgNLBNZo5fcFr4NQf0k/AcO02yk5z9tW04in6O6LzM4WrIn7mbKxeDrVYRJEUyCPAvMZX9MI1EvVmgvmbclomwKh3rcRhFM0CzZAgYTxEVCs1qEBZDc3rmbhqI14I/qA7h4v7zzjIrMpVYvjtHqgZKZwZk+jrhzf8pJ+IBg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df21c283-c229-42b0-24a4-08d714698dca
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:13:08.2529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't need to handle error flow of esw_create_legacy_table() in the
same branch, it is already being handled directly after the if statement,
for both legacy and switchdev modes in one place.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 6d82aefae6e1..17fb982b3489 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1855,8 +1855,6 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int=
 mode)
=20
 	if (mode =3D=3D MLX5_ESWITCH_LEGACY) {
 		err =3D esw_create_legacy_table(esw);
-		if (err)
-			goto abort;
 	} else {
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
--=20
2.21.0

