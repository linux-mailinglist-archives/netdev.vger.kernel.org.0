Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2AC8AAE11
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391030AbfIEVv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:26 -0400
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:23041
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390949AbfIEVvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhIVlNo9GkRT5M4bPAE9N8iU5v3095e8gpc2LyEITtZoDcx64qQYGlfwUF4UWsdfO/XRWf01kf0NjAWuRj9vdSufOId3h1XpdNOCCePPwQgUSooKLhiiF3PipmpZoBop91o+wASqbo5Xj4XE3e1Sqib8cBmNs5H8a6xYLY9tRWUjw4Ihexkho0wuZfvOLDWRka7cLip0GPmiWO/VFdpE2YSCfv8VclGZWgX4em8iT031uFQQ7GbFSyegDLSe2sfOyqVhJT6sKs7C25n/qdkF2Uijebn4ulhCUtG18jutLRh2EdEDAsMkyPg1CVdFzeArieImdd3AvNFjhxJ3zkATFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu4IaaH6P7GuY95SLG8x0/9lp+ouBn1ay1ravDCMrYM=;
 b=DR4rmsHyLhZmw/wmpTfOoOSOIDswXP/ovwCPhaYepHPnVmNoxRPx01WRSsRjYEa3zPvhfFktRm+c0cV2ME5VCxGTr+yt3xtWNbTQdTH5XK8M+dvUJSFEv4KC3bYMM3IthMMCFCYtbS8w6nDpfTF/JRjsK0hojhfyB7bg9RNUu6A4NCwLcvEFKM80hBThugcae31h8Slr2CrCWI9wP/OVNrxtEeqyz8HgFfyD7k7sm0mdqP6fjdArwv+q+dK8XJmfpKHZbyL+ZvroUJnkWgxqOylk+D4sJA+HXG6wTNDlQAO89tbICPvgpJ4XKle6iMGq2JC7DRIGr2VawRJOx/OREA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mu4IaaH6P7GuY95SLG8x0/9lp+ouBn1ay1ravDCMrYM=;
 b=Gsc/5TRL4lf5rYJURu5y5M7Gm1Gg4x5PqfnKtxLvYPJQGpZoU16d5yw4kvQ45nsRaLKLoXvMn3TffLIZ5Yjzg8EmnOghmlTnKi/I32IkX6S3lHnoEh3ScfHRZ47Q4ERolsWvdQ1GcdcliDOUnWMANvsd2DG0zMxZFK6OMvNwrcM=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:10 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/14] net/mlx5e: Remove unnecessary clear_bit()s
Thread-Topic: [net-next 09/14] net/mlx5e: Remove unnecessary clear_bit()s
Thread-Index: AQHVZDQH/cHkMqT3s0en7GEolFfrFA==
Date:   Thu, 5 Sep 2019 21:51:09 +0000
Message-ID: <20190905215034.22713-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 97e9c790-bab6-449e-70a7-08d7324b2962
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2768847D78B1D7EB2AFDD066BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(14444005)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Zv4B/i9UIyK9wuMra+mJzUKNNsENTysxyQ11GejjGzeEq5v1d4/aLrOZSqIDAppJlJGcfRxqJ6fU+CIhQJovhmIWwWbl4+KhAVEM6cHEOIid9yxEINr9zSQRtyfzcHeFsFNZg2phbmf2TZMTaBOWSooLGKac3Vob/xibpQ48TVwMijxAdFxK7k0hx3YKbJCWFX7BQi7ekYbjSnSLuGP8+DZD0RDw5k8PfBuh9DylSlI/KpX9FB//OQOz2BuTvcxdouQlJ9qLUTKt45yhpS9KQLrp98OuqL4g06ROAgpQVPmoWkPtU30u0jjaZKmsqq2AUgK0lTici7YNXdzX6z9waFsQNJpDLBenN5bI14RE3AsZ9XYe/4RtZib5UzXtQq6f94P0m16CdX+CmsNutiXb4Htkb9+fDMEWKW4Tytl/VVc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e9c790-bab6-449e-70a7-08d7324b2962
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:09.8885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJrB1M9PyySqGmGN1vbyH+6P2yo4lO1G8WWY2WGmG/tQPNEwBDheICWXZaJa24v/jIT8eO0SOnJi1l1xWPQDzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Don't clear MLX5E_SQ_STATE_ENABLED on error in mlx5e_open_txqsq and
mlx5e_open_icosq, because it's not set there, and is 0 by default.

Fixes: acc6c5953af1 ("net/mlx5e: Split open/close channels to stages")
Fixes: 9d18b5144a0a ("net/mlx5e: Split open/close ICOSQ into stages")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index dadadf221087..cd51cd56484b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1315,7 +1315,6 @@ static int mlx5e_open_txqsq(struct mlx5e_channel *c,
 	return 0;
=20
 err_free_txqsq:
-	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	mlx5e_free_txqsq(sq);
=20
 	return err;
@@ -1403,7 +1402,6 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct =
mlx5e_params *params,
 	return 0;
=20
 err_free_icosq:
-	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	mlx5e_free_icosq(sq);
=20
 	return err;
--=20
2.21.0

