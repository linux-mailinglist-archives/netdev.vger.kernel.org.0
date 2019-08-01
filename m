Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF027E3A6
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388878AbfHAT52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:28 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388797AbfHAT51 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WwKWJYW8wNWtzQuM786aNlAf8pPgw7XRQ7a6/vkLtd2Xgn5SZBcX/7KQyUdiHV30hEl+iyevMDpDcNp74yQeZ6h3mkYgaXarp2yL7HLsuw9JiG+efbHJwSU1aUfKpVNTEu4YTj3j4s1h6uPfMTmsJ9m4RKvJE3SSKl4CIwt70LjGigvE4myZtVEPllnfDMh3cejgV61BPOXSkvn11RhFWJYYcXq5gMJm6/DQp5D+kwYsLS57RskJ3sC1wmmvMlGRCB6RkPQTkm+RRPietR3UZ6vWBkxGRCXt7uuZGb16GEfEF6UiK4KezjLjR+lzALuhQcdKkbI2qjZoCtMTrhttdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6xahIaDPCuvL2KuHbIc5UUHSg8LH1jNFtyCSZe6Zco=;
 b=E7wNGxZRO1OrAbjYflt2ju4c3zMXnBSp8hM8FXkUF3YsoirJSfxgKg0ZMqO1eQshDDs+0Dv3DW9QoM4ZecqpC4lYCAn3mFfm5ABJuuDB8/b/3g6Isb5NE2TERlsJbx/cpW0TzQEQ1O+CFDRp43HQpKWsSp/Eadn+Gne6b+vwXoPlFCymv8h67tQUoOM1atQV7xYN/TkVldIfbpeRFG3OrslONrpOl4c0FQSkhj5kUofgb0a31KOTtjUQThnJB3UvFzio3qWu5IhJgqeEUiOPAp7D8DoZeXX7P85Y6RRL/TIRPG/Z3ecUqVoHSvazOf3pb3DnoYtaRc9MlZYv9vUIDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6xahIaDPCuvL2KuHbIc5UUHSg8LH1jNFtyCSZe6Zco=;
 b=dsqbNWzuCIWEJhsRO7I30CCrH2FgFDhIrADjgrD2Jv7Aze2q8ZFa68G/dGl3WZH2pUQSNbhZP4ZJUY/1+2uI9s3XLfk/qe3Z4x1AISixbLL0M4phNE1FuTwly18h7Zl9pKO4aULb45awH6Zavkcn7p31u5jGbJsfcmOX/KiFofY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:57:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:57:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/12] net/mlx5e: Fix mlx5e_tx_reporter_create return value
Thread-Topic: [net-next 09/12] net/mlx5e: Fix mlx5e_tx_reporter_create return
 value
Thread-Index: AQHVSKNL6bciGH9RSUeFCNReVAP1nA==
Date:   Thu, 1 Aug 2019 19:57:06 +0000
Message-ID: <20190801195620.26180-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 809a5541-3f6c-467f-2758-08d716ba6e23
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759F82150B287AE528CED6DBEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mV+8A0JubLTJL+2015XLPAElEIH1yI6KY+s4E/JZl+rTkTcCgHH/eIPvL6AuI8hRTbpLkIzHZHEfhE6GScF/KlfmoLI64No3Vlyhrpqh17dsaNvTv7CJw74kFLCujyUOQ26x3oYFHDJrmT5gvyj8hp09qiSTFPXLfTHP6wy5Qnvze2A/p4kRQFjHLZhbOij+rPp9lplNp1HS3E/WhzwLNV4o0zR3MPKk8vuere8YxRDyyfDtTvpdIgEQyazTuiW02tx0RsGDi9q0TBUb2b6D6WoQj8MnBuJ638Jm3YtiVdVTOHBv+i52G5jheIa9mxjOw4P1tvu9fZD9tBUhkC03tg/SIQbWsjHvSBlTq3quafeTD+ExJn2v3xjUUmPysXdSj8Q5m4vG0j8ED0fgXY/mKm8YlCfA7ETyozsRlipVcdA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 809a5541-3f6c-467f-2758-08d716ba6e23
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:57:06.5199
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

Return error when failing to create a reporter in devlink. Since
NET_DEVLINK mandatory to MLX5_CORE in Kconfig, returned pointer
can't be NULL and can only hold an error in bad path.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index f3d98748b211..383ecfd85d8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -296,11 +296,13 @@ int mlx5e_tx_reporter_create(struct mlx5e_priv *priv)
 		devlink_health_reporter_create(devlink, &mlx5_tx_reporter_ops,
 					       MLX5_REPORTER_TX_GRACEFUL_PERIOD,
 					       true, priv);
-	if (IS_ERR(priv->tx_reporter))
+	if (IS_ERR(priv->tx_reporter)) {
 		netdev_warn(priv->netdev,
 			    "Failed to create tx reporter, err =3D %ld\n",
 			    PTR_ERR(priv->tx_reporter));
-	return IS_ERR_OR_NULL(priv->tx_reporter);
+		return PTR_ERR(priv->tx_reporter);
+	}
+	return 0;
 }
=20
 void mlx5e_tx_reporter_destroy(struct mlx5e_priv *priv)
--=20
2.21.0

