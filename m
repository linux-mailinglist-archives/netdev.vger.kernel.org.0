Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAA57AAE12
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391044AbfIEVv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:28 -0400
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:23041
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391022AbfIEVv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZ3Mvk+q6+7cWWFHCzxzZA2lyCZpHetyway6qRQIBMtP1Dnimu0/CpaDwijWHuMZDxQAfsTuwz7HNX6wmwCQ3dNRGZIC/12dnpYGM2j9Ike9tc9G93gt3M1A6QXliwV2YRn9qmBuCi7/OGGxFrgQ+jUrFL5A/chuhpRw1OJ5h4/dTiaVSraA6Y+lgBFm95PY6nLxI3jqsSjx8XU85fmqt0sD72HYhTVrd/HjqKKsnjO8hlc3z0AM2ksL8JhXVtoi4U8FbpM8I4OxSjFEpkOsiTwC1X3at2T5OHa6/P/DopUnK+sIMYXvb2pcprqrruUkzCmPreZAM6xt0v2wlw0tqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuncUR2OKm1nnv8m06+QxZIszuJQi/diDMP2bXWyfPY=;
 b=DZ1SN7V6oH2cMBjTWr6/lRz47yVbmE9ZiH1GP/87y3dJM6XTxIe6S5cmi5EDaik4EDfygm6BiITml4cliyq4nhvCiXUftUNb1M3ck8iESXDj25ecBV/WRqOBVSI7Yw3pdN2Jh/yZYKoh/YGbrjO7+T5x8X6m0aIqxb87II8ZcTGgdkCBW5pq6fYv0i9ZYkncqs3n9HG/hulY+OafaasDriOLYRNQyQQku4cs7O0XK3czZJVTOjdw+B4b/aBoDMXj7JBRGfhbgG1q7vOtqGPOCrGg1XX+nkLfVNhfe7GwRbgp5gg5hM4wpV2mkSer/tWwX8IhGrI+aHbPMBphw4TgMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuncUR2OKm1nnv8m06+QxZIszuJQi/diDMP2bXWyfPY=;
 b=hKfO78/o/0w8nAaoNEDOATyDyMgfdF95dOvWsayPdcsqu9pAIJc5ycGXXGrS0EOaKdu/IFZjClziiOpLyO+MXMtbg2s/HQ7qZIc8UnUNFVi7+6Q9dxbWE0lzniNxN7+U3CRB+o930blRDmoHFkJysQYEOyS+LdjUSsFXBZ6LtGs=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:17 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/14] net/mlx5: DR, Remove redundant dev_name print from
 err log
Thread-Topic: [net-next 12/14] net/mlx5: DR, Remove redundant dev_name print
 from err log
Thread-Index: AQHVZDQKmEE5qZpjU0mzlSnvL6gE7A==
Date:   Thu, 5 Sep 2019 21:51:15 +0000
Message-ID: <20190905215034.22713-13-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad2d0dfc-11de-455a-4526-08d7324b2d16
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB276889199175FB27EFDEE6DDBEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:462;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PWVFuQvgb94wKqB0hMezccGsuhDqvolS/2g5Ip5ftdV8GKY6w3Aox2BuebycDlrqpxP9dp9Mtlft8WqF2/dM8MD/EVgv5KNKxfykAnPvr8lbXfR0VFv8+uM5+N4rkytB+C8hdNdFiFIWHqlYpnw4Le9Ca+BKlvUAdkCEA3VPqVk/Ny6ZM0MSHMySUoeH9z1raH6LoUU17u3IyiOYoZZtTXsBTTGBGMr9m5bQKt7bfkqMR5iyBON+29lhM2ORocJE/Oa5crd9SHrrPQs6JJUvzOZ8N0XmPEHOUG3ZvN86ucF2Il4715WgsK79679gI+hZ6fWZhHcmr3dV6A43ByfHQ5Qie2zo51rz94ZuNryr8hIvQx0Usowyk/5BKIH2CE2l2MOXsraP6PSU8pVByUcFnaW4LwfVY2CeaOrn+cRFg8M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2d0dfc-11de-455a-4526-08d7324b2d16
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:16.6505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4JihQcwUzYR7dDlq9rRy/kxjknDWaWCYdShV9xfC5hrur9heooYy0nYXo0gznSQOSvT4PphVtfq2WzmhLusnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5_core_err already prints the name of the device.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_domain.c       | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index 461cc2c30538..5b24732b18c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -72,24 +72,21 @@ static int dr_domain_init_resources(struct mlx5dr_domai=
n *dmn)
=20
 	dmn->ste_icm_pool =3D mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_STE);
 	if (!dmn->ste_icm_pool) {
-		mlx5dr_err(dmn, "Couldn't get icm memory for %s\n",
-			   dev_name(dmn->mdev->device));
+		mlx5dr_err(dmn, "Couldn't get icm memory\n");
 		ret =3D -ENOMEM;
 		goto clean_uar;
 	}
=20
 	dmn->action_icm_pool =3D mlx5dr_icm_pool_create(dmn, DR_ICM_TYPE_MODIFY_A=
CTION);
 	if (!dmn->action_icm_pool) {
-		mlx5dr_err(dmn, "Couldn't get action icm memory for %s\n",
-			   dev_name(dmn->mdev->device));
+		mlx5dr_err(dmn, "Couldn't get action icm memory\n");
 		ret =3D -ENOMEM;
 		goto free_ste_icm_pool;
 	}
=20
 	ret =3D mlx5dr_send_ring_alloc(dmn);
 	if (ret) {
-		mlx5dr_err(dmn, "Couldn't create send-ring for %s\n",
-			   dev_name(dmn->mdev->device));
+		mlx5dr_err(dmn, "Couldn't create send-ring\n");
 		goto free_action_icm_pool;
 	}
=20
@@ -312,16 +309,14 @@ mlx5dr_domain_create(struct mlx5_core_dev *mdev, enum=
 mlx5dr_domain_type type)
 					    dmn->info.caps.log_icm_size);
=20
 	if (!dmn->info.supp_sw_steering) {
-		mlx5dr_err(dmn, "SW steering not supported for %s\n",
-			   dev_name(mdev->device));
+		mlx5dr_err(dmn, "SW steering is not supported\n");
 		goto uninit_caps;
 	}
=20
 	/* Allocate resources */
 	ret =3D dr_domain_init_resources(dmn);
 	if (ret) {
-		mlx5dr_err(dmn, "Failed init domain resources for %s\n",
-			   dev_name(mdev->device));
+		mlx5dr_err(dmn, "Failed init domain resources\n");
 		goto uninit_caps;
 	}
=20
--=20
2.21.0

