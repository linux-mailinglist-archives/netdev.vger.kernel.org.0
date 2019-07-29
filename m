Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5A779D09
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbfG2Xu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:27 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:57824
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729105AbfG2XuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1pAvmqB4LwgaJPBKilCDcmVQaJgynyIR2jJI7wVg5B6xPWBBkWkLQLIffTVqdzRfVMCylxmjs2z3QxIpdKhpDU7YgpdOqbsZtMTc3l2sloLMac1UaNRHtqHyG4SJ54UqPLm921Sn/L1D7XuBuxeI4UN5qcmkBZE4B8EzFHmjrGIm7OO3vlO/DJjcrZnJXsHns2AHIImhjtCMBmoucNVgumUskR8FASIJuKwHa4biqj1QiGsiAhYfobsTIqnC6y0qeWaseBYFkvkh9TqRBZnnqbWwQ3z5gqsTKmSAJe1DAvYZykTVy7wnC1Mp90ySfBZ7wH0dcClhjVC3FMx8aHy+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbzfrSwMRj3PHAS3ib4eSNxXmzdjep6GA2TyD04cILE=;
 b=SHPtc58p2Gd3Xleaj76HJ+148bMltYM9xg3d5EezbEfQ+4tFJFACN7YZ/nZhm5FgMe8f47AFdBokAMW741gwVpQp88wZeQCaEbNLWhUZp/Weav1QbStphagwTw8LMZ+CouR0BNIwA90uB1IDaHNvNs9aruS93+7RBb4HdHnKxcbBaLG89RCQFgUnEvPuBe9VaN0XZ9H1+SbBBGgA3B94JPnI/lDLrgWxiIbBmC9pD4uENR6IfNz7nyLHJ+hmmOJBXHsRP/fOqgkHayees8UBycauxclmhVLHDopIDtInCvczIgvX1GjeU3VgdzRfUeyhATmxZWCludiLdO6zF7p6RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbzfrSwMRj3PHAS3ib4eSNxXmzdjep6GA2TyD04cILE=;
 b=jF3qbXvbkmAfe6jWkFug+K6YdMCt1tCivD2mwFQzxBKsiaku42LrXm8Iy0KNV6rqHISOe8pV2/IFKc8UW9K3g681AWUpJUKsI97HBLQXT9+lf8nrN7Rqb0Be3e4BpHDOMmOW0+4LXCByVKVG2iSiSQh6TEwsIRTuer9lK5HCd5I=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:16 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/13] net/mlx5e: Print a warning when LRO feature is
 dropped or not allowed
Thread-Topic: [net-next 01/13] net/mlx5e: Print a warning when LRO feature is
 dropped or not allowed
Thread-Index: AQHVRmhf1zpTLl9Vk0e3zVKwgqQQ5w==
Date:   Mon, 29 Jul 2019 23:50:16 +0000
Message-ID: <20190729234934.23595-2-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf83e877-c589-47ef-0c29-08d7147f8189
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB2343C49A0FB6AE057DB1BC28BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vOGj2lByqysTmfcvCyhavRzwz3dqtSy1pOYAYquBTQBiD766QHI89jpAueMNG9nKR0xzQiky3Zh6moeEOpJtz2Bsd1odjkaMO/5oOkQ/89MFx549ZVQhU47Wy26GYjUZpvGmqQgkWN28SR1aeA2D+6oDYjU2+NZ80hbnLheAFNJ0c7hWCUkOkwuWVVaolNm1hD8wbeq+eiZm5BUe4E75JxtriAlMahmIOZINa21afvulAt9EI/oMy2Kbq8v69EN2eOcs7x3vlypcZU9bYjwD9g4Idvk2Kkx6f8r/gYYPCJBWuXRwlol68JlCnXiZw05HRsYkGSYkbWoklXNlHQC37i3PrcViROn15EXPeEYRAMsNyGVu4OeU0G3sN7b4WyHeWOrcInq/VspKWwfmb8JwULK/tvyOsv98vb9tXgW+qao=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf83e877-c589-47ef-0c29-08d7147f8189
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:16.7257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

When user enables LRO via ethtool and if the RQ mode is legacy,
mlx5e_fix_features drops the request without any explanation.
Add netdev_warn to cover this case.

Fixes: 6c3a823e1e9c ("net/mlx5e: RX, Remove HW LRO support in legacy RQ")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 47eea6b3a1c3..776eb46d263d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3788,9 +3788,10 @@ static netdev_features_t mlx5e_fix_features(struct n=
et_device *netdev,
 			netdev_warn(netdev, "Dropping C-tag vlan stripping offload due to S-tag=
 vlan\n");
 	}
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		features &=3D ~NETIF_F_LRO;
-		if (params->lro_en)
+		if (features & NETIF_F_LRO) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
+			features &=3D ~NETIF_F_LRO;
+		}
 	}
=20
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
--=20
2.21.0

