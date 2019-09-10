Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E665CAF2AB
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfIJVqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:46:07 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:37381
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbfIJVqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 17:46:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZrknPgoUB56rekMHHr31h5PvDJVH8hUId11FwRnV/cnrTBzQ3gadyAxWI22ea8+6TL2QRviKvA4hRE8TLZs42fM/VxLY1i+YTCN8gKLU0hsYrbVkUKTKuPc6Mt+k6+wK2p9tHPDCxghoPCE7+lquevShHSnkHWW+D/1JRAr7vMLGPEoL0cOwG3+0hCSm4ilk2BjqmDRhtXHgzbHgpyP0Z1efz2TyDFli4mN141wh5qaXl82X3JWNNkTKNsLjBce4L9IR8rOBVX3Kre/gbY63cD8dRwJuCbz8bo/9SRCYcCHPf2Z3w049fsds9OnYXiCpAkbkUj6dM7QEqeNtQmptjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbTaRRMdCKfC/jyuaWVquDV0HROGHAcwJ6fqmc7ZUko=;
 b=TWtW37Obnr/RRDCzxOEolTVQ3TP0hvq/eb3POM3NQKulm6awqEM9j6uEIMkCMACpZSSTQn4deVe2naBw+JJllcrBUde70rMiRwCuOOJhiWsakIxmf0eSTgTpqwmZJoS5eWOaP4gNHqcyLtLys/dV9cMPMlBDq2TGh7AMIgN++PQNbYgTDVP6wh3w7smEG174trda4cuB4OFgul/h+3tT1+uzie7LKEvQgNb6zty9giSoJKU0/AK09KhrhliSVbzg+XKkCdTgW4eNJq/NFeiCP2J/hi4tI1uVpvRzVifhGL2Av7EWm97ANUiN9qDCg/ij/BW07t+iNvtir74bOAPXSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbTaRRMdCKfC/jyuaWVquDV0HROGHAcwJ6fqmc7ZUko=;
 b=JcCyj6Y63zQdELJxHs6uIzw/HRS+sB8cF3SM78Dl6sSASgLYz0m6IKl4AWX9qvhhx2TrMooS1/yFodbaugNaT5PsgtsTJr+wncz3Fj2OaZafMtscRsimoquTQDQe1yENVezNdZ5407tYqnhJ1Ar2TN1/bHEpB/3vxxF96GuQUPo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2598.eurprd05.prod.outlook.com (10.168.77.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 21:46:01 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 21:46:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 2/3] net/mlx5: Fix addr's type in mlx5dr_icm_dm
Thread-Topic: [net-next 2/3] net/mlx5: Fix addr's type in mlx5dr_icm_dm
Thread-Index: AQHVaCEjD22RjnHVJ0mjZCPcRKncqw==
Date:   Tue, 10 Sep 2019 21:46:00 +0000
Message-ID: <20190910214542.8433-3-saeedm@mellanox.com>
References: <20190910214542.8433-1-saeedm@mellanox.com>
In-Reply-To: <20190910214542.8433-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8e67c4d-c53d-479e-52bf-08d73638456d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2598;
x-ms-traffictypediagnostic: DB6PR0501MB2598:|DB6PR0501MB2598:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2598A90E69DD81F402E36258BEB60@DB6PR0501MB2598.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(966005)(81166006)(102836004)(6916009)(5660300002)(8936002)(14444005)(256004)(6486002)(50226002)(76176011)(6116002)(7736002)(99286004)(14454004)(36756003)(305945005)(4326008)(52116002)(6436002)(3846002)(107886003)(6506007)(386003)(8676002)(476003)(66066001)(6306002)(53936002)(11346002)(6512007)(446003)(2616005)(478600001)(64756008)(81156014)(486006)(1076003)(26005)(25786009)(86362001)(66946007)(66476007)(71190400001)(316002)(66556008)(54906003)(71200400001)(2906002)(66446008)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2598;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZJ5SDtwCcYlYed+ut0im+v8wBiTvaV+1LvycDmAthQkAAxz4XmGWZImVYxU/ynFh3dFr/VvqG23u52cl/uJRdG1Ip9uN2tmiGz5F6MpM7KG2QgZjEl1nWVSg04w6/5Br7JKl5TJys5cVC7IP5AMklAybo3DMl+p8oLNHvD2RYcIyEYON7e8pY/YwL/LnmKHuZOWxkOhcNvsEtTEcbD7gFe3cqyRX3r69M8Wc/pyH6Zth7aucJo/P0vyPZamDlzAPKtzJFUVYsAtzsSyBK1t9KNtYpjkkFCbLedEverYR0vHiKks1W52ZdFmCT5yibLv8OCHTXUy/G4pk1kdCi+aslnDhBwLmQaxHLOoMw0Ty/yfqdvmruGBu2M15zUGPJd5RbWs1F79t5Vl5pGx4pwOManaSSYulhCoBUnPaNAkQfFo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e67c4d-c53d-479e-52bf-08d73638456d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 21:46:00.9794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2JtK4MHkU0/Qcv/rUi/sRkoO9VRwJGVFLhvUQFfVnVczd4jqH3Xz9O8D+ExRfIOpDx7zCV7Q/lmCXP9W/brvSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

clang errors when CONFIG_PHYS_ADDR_T_64BIT is not set:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c:121:8:
error: incompatible pointer types passing 'u64 *' (aka 'unsigned long
long *') to parameter of type 'phys_addr_t *' (aka 'unsigned int *')
[-Werror,-Wincompatible-pointer-types]
                                   &icm_mr->dm.addr, &icm_mr->dm.obj_id);
                                   ^~~~~~~~~~~~~~~~
include/linux/mlx5/driver.h:1092:39: note: passing argument to parameter
'addr' here
                         u64 length, u16 uid, phys_addr_t *addr, u32 *obj_i=
d);
                                                           ^
1 error generated.

Use phys_addr_t for addr's type in mlx5dr_icm_dm, which won't change
anything with 64-bit builds because phys_addr_t is u64 when
CONFIG_PHYS_ADDR_T_64BIT is set, which is always when CONFIG_64BIT is
set.

Fixes: 29cf8febd185 ("net/mlx5: DR, ICM pool memory allocator")
Link: https://github.com/ClangBuiltLinux/linux/issues/653
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index e76f61e7555e..913f1e5aaaf2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -53,7 +53,7 @@ struct mlx5dr_icm_pool {
 struct mlx5dr_icm_dm {
 	u32 obj_id;
 	enum mlx5_sw_icm_type type;
-	u64 addr;
+	phys_addr_t addr;
 	size_t length;
 };
=20
--=20
2.21.0

