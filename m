Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD8AF2AA
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfIJVqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:46:03 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:37381
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbfIJVqD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 17:46:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWTz0bSI+ilPotrUtc68Kv8PRvy7AxaFWT2bKfVdEnPOfh0m8/qQZmbUGViyewO+yuCFVjCBD/poPAv0zQlyt2kkd2KS09Km0/HQ7GLrRHnRTKolGvjAbxG2c8xyZ7Vd0QEvO5tra4IETazEyMB29aD/vYpthivfKYyWfiTFxiT/YBX/E1OGgNAm4mGGuZrb1hpnZv8UiyBaO9kevDGG/t11bdtfbnPZdCVzXYnobVEk3/sG+wTQ7gi62Icc0g84H8Ul5Kwyq2TGfJFoKmfIzeNIRKgseKVlMU2uD1e/bz7clNdeStbMorrjlMLSi2M3k/Cs2jZhzNutiQcHVtsdeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyHlOOVmspOlmLxmGBw7J3chgM/jFXIiqrFVHnpe3x8=;
 b=m7nIZTBTFyAW41p4yy1scvcdCf5H+6kLzlB5wWsEN1GzHQPMJvPnxawOWObSlnEqOcBul0LPoW8BB3fJNVsuYylYmLMAdDqejAN7nj0AduYKW4BTuR1b9C4AE5RIt45C2QPjiBU7QBaSKaBF8sFbymcZue/bkoKG5WCSvi6wp9pS9IHaKnqkHGt3j+mPUd6Y8D9iHzUqTlTkDrnXLaPkfluARtlvYJL1LMXoJun5YZNQfA453ehUOXx5AP+jVaMxwyi7v3HPR6AlRGmgYxKWa6eg8J4qLyA1prUf9uqIHzkmDCnG8EmjvQNtpi+aPU9PAOfEIyXBDScQCsI7fYGzog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyHlOOVmspOlmLxmGBw7J3chgM/jFXIiqrFVHnpe3x8=;
 b=f23YtY4sj3YoOcJKXJF098ZAcGo9zGK1oPDaMXw8AtIRttKTEKtUTbjsMQvLIjgTZiCvCPnN+gMbhHnsKMeQVZEF/3xGMVHHaTCp6h5XEhexicBcjWMb3JNm+Tqn98A381tgsi3bwKh6VUKPSOg7FXvPsYcnsMFosLTUIJXYI8U=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2598.eurprd05.prod.outlook.com (10.168.77.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 21:45:59 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 21:45:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Austin Kim <austindh.kim@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 1/3] net/mlx5: Fix rt's type in
 dr_action_create_reformat_action
Thread-Topic: [net-next 1/3] net/mlx5: Fix rt's type in
 dr_action_create_reformat_action
Thread-Index: AQHVaCEiekGybPINEUy+0l1DJ5FqgQ==
Date:   Tue, 10 Sep 2019 21:45:59 +0000
Message-ID: <20190910214542.8433-2-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 37188515-071b-47b1-d4ed-08d73638448a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2598;
x-ms-traffictypediagnostic: DB6PR0501MB2598:|DB6PR0501MB2598:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2598FA4CC40FAC2100EABF5CBEB60@DB6PR0501MB2598.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:186;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(966005)(81166006)(102836004)(6916009)(5660300002)(8936002)(14444005)(256004)(6486002)(50226002)(76176011)(6116002)(7736002)(99286004)(14454004)(36756003)(305945005)(4326008)(52116002)(6436002)(3846002)(107886003)(6506007)(386003)(8676002)(476003)(66066001)(6306002)(53936002)(11346002)(6512007)(446003)(2616005)(478600001)(64756008)(81156014)(486006)(1076003)(26005)(25786009)(86362001)(66946007)(66476007)(71190400001)(316002)(66556008)(54906003)(71200400001)(2906002)(66446008)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2598;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tlMScDkph03YHWZQ0JT3nFabzwWhx0xnsxt7Jjw9lE1DELXFsRE9oEv13rZZhbAaW2dJtS46PTOwSsuQY6UsDqQ8WGGN2dOhzcZjdys4Jh8FtOGdCe0ehjBrvZodFxM6AdktvD1TE72SDyO3NoqA/2BFieK/JSVt9KpYRlCReMiU1TcNy0KkdAffRjMNCu2fZ7a85HvMlrzP97OhWqJmanEGJrdFrQiBy1XHD4+yoIRuJO9JtthCVYguhMiJ3FB7bwEUi5Qt/d8WyRhe2STfOYFS/a3iaXiz7+UhD5wbLI2w/PhoMXEaiHc2uIHmLGZDkuux24OYcnlNHhgk5ZG2/lLvWR2dLHoNBN1zEhWBNFVm7A7Ef4np+kBnqpy611Knmj1EeD6acAI3/SES4nBGUlFRMIUzESZf1Ww3xMj4OB0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37188515-071b-47b1-d4ed-08d73638448a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 21:45:59.4251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8lKi4/ZOZ9Hu6DgswqX2q0sPFtEZgZmSOkBJqbnRUJsd56nJd1QDeSPx4ol93n1xyW0LT9gyGVLWbWjpXepnzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

clang warns:

drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1080:9:
warning: implicit conversion from enumeration type 'enum
mlx5_reformat_ctx_type' to different enumeration type 'enum
mlx5dr_action_type' [-Wenum-conversion]
                        rt =3D MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
                           ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1082:9:
warning: implicit conversion from enumeration type 'enum
mlx5_reformat_ctx_type' to different enumeration type 'enum
mlx5dr_action_type' [-Wenum-conversion]
                        rt =3D MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
                           ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c:1084:51:
warning: implicit conversion from enumeration type 'enum
mlx5dr_action_type' to different enumeration type 'enum
mlx5_reformat_ctx_type' [-Wenum-conversion]
                ret =3D mlx5dr_cmd_create_reformat_ctx(dmn->mdev, rt, data_=
sz, data,
                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~            ^~
3 warnings generated.

Use the right type for rt, which is mlx5_reformat_ctx_type so there are
no warnings about mismatched types.

Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
Link: https://github.com/ClangBuiltLinux/linux/issues/652
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Austin Kim <austindh.kim@gmail.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b=
/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a02f87f85c17..7d81a7735de5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1074,7 +1074,7 @@ dr_action_create_reformat_action(struct mlx5dr_domain=
 *dmn,
 	case DR_ACTION_TYP_L2_TO_TNL_L2:
 	case DR_ACTION_TYP_L2_TO_TNL_L3:
 	{
-		enum mlx5dr_action_type rt;
+		enum mlx5_reformat_ctx_type rt;
=20
 		if (action->action_type =3D=3D DR_ACTION_TYP_L2_TO_TNL_L2)
 			rt =3D MLX5_REFORMAT_TYPE_L2_TO_L2_TUNNEL;
--=20
2.21.0

