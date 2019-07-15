Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795FE69C5E
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732456AbfGOUKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:10:05 -0400
Received: from mail-eopbgr50045.outbound.protection.outlook.com ([40.107.5.45]:60879
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732427AbfGOUKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 16:10:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Htjik/qt6ggRYULDJUqP0wh0xNYf/vR2VOMNTyZEXXeMfq3Yhp1uEZFmRRYQ+5hnKBsn7MnGKE+pUvQBATLGi7yMowJqsN2cQ0fBixTXVPmpDkP/XfaW8SNfr99T1JPt2he/nppYwZu9A1vbOQSbSJZBvJR+xjmtBdTVenG29cvOZc/ArWL1Re+IITB7VCFxdg1lG1ReXfwUGIFuamP4ULhfUqxPODfAjPY7gb8xaXkQKmB4qdG5X8QSJDi4heQhruFG5fLY6SflS+rBahIm4smSvBnPdF0wdJNYypCPRj5VXC2ozOEo2JiTHjLdVGTgmA12OQ9SQ5/s05v4eqdmGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Gv8mR6Ywm4T8CshI+Tsc3ht+12fhm7XTqWQQ/WsFGg=;
 b=dE3EhEUKlKkq5fVzuzgIMkAMtksUQgHwOJhnIbiFwhj5LkzX4Yl6kbSwMaPhefH3q1TE639P+LvFnBVJ2Ee3V03/Nbw47E4OiSvk/I34nJNU3m5zKr0P7sOY8iUbqE1JBMWtPZQVtUnXKpF1N0J4L6QsIhRbAJqnNO1iYZTg+hNol00DYh4UVCfEowX21Bgywf2Mr6pu3O+t/i3c8ytp/4OPMAQ5z1cLwn+U08ijR1jR3PS77WCglj9hGrJ9TqCKOgRGgibqF/T2O38BSNdutW68UG/SNKzwdZgSwDYSQLO39fSwmPEo/dwDAvM0u4HY5qekvyXCCW9jyP07YAmRJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Gv8mR6Ywm4T8CshI+Tsc3ht+12fhm7XTqWQQ/WsFGg=;
 b=AYHbSKGT8VTWE26yLaR/rRTmQG2FBhllOG3ePE0/yupdxzCUTlT+GoGJ5DPzU//n569NmK+CToK2YTvs5W/vcz5T8AY56EMctZwHIe/ES+nIJvOn24VhpC3l86ZpRZDnZt5SbdL4w09NGkO8fw7aM/tIGV8xliQx3T+YGqu7oSk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2485.eurprd05.prod.outlook.com (10.168.74.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 20:09:58 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 20:09:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/3] net/mlx5e: Allow dissector meta key in tc flower
Thread-Topic: [net 3/3] net/mlx5e: Allow dissector meta key in tc flower
Thread-Index: AQHVO0lGL8Q0SBKBF0idvLtfCFhulg==
Date:   Mon, 15 Jul 2019 20:09:58 +0000
Message-ID: <20190715200940.31799-4-saeedm@mellanox.com>
References: <20190715200940.31799-1-saeedm@mellanox.com>
In-Reply-To: <20190715200940.31799-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 821ca68c-f117-4d04-2375-08d70960690d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2485;
x-ms-traffictypediagnostic: DB6PR0501MB2485:
x-microsoft-antispam-prvs: <DB6PR0501MB2485DE933DF316E9A645EDD6BECF0@DB6PR0501MB2485.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(6436002)(305945005)(25786009)(7736002)(102836004)(6116002)(26005)(6506007)(81166006)(3846002)(81156014)(53936002)(107886003)(36756003)(14444005)(478600001)(486006)(6512007)(186003)(256004)(8676002)(68736007)(386003)(8936002)(2906002)(66556008)(86362001)(99286004)(66476007)(476003)(66946007)(64756008)(2616005)(446003)(11346002)(66066001)(5660300002)(71200400001)(66446008)(14454004)(71190400001)(4326008)(6916009)(52116002)(76176011)(1076003)(50226002)(54906003)(6486002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2485;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U/H/Ay5QKjQiwoAcMBJ3cZXkCqycvHSe8LrCYMNDswxvlwCzVBWRoxgY2f5ykADu8DFNAyN/lBoBN5IHm75JHKVGeaJLp+730XYS33DF9Wt0C7AeAoA0R1UdO3n79KlrLixOFCUiE8T65uloeItbiyRE5uowRaY60DOAxLqX4T8KClI7715jsLeH0rNrnI543WHanEu77vwJqFYvZvpKY+iH33kBKSecaMwitDucra9kyiCm3/8OeDEhXOxwLmNKsT9MYZ7y08NKoWYkfBhsQ5Zxak7R2l3AKnNjsWTSPolzcWvzHqlDASCBDbDa5LmYP0legA2KblB7hlQiQE+pg+Udf/AHE8+azEIq2bOChh6UqsFUpkOVGzDYy/Y9iKtWQtdYPobJdQLPFHgUJDEaVduliy1Dsq8KkAxnDScim8w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821ca68c-f117-4d04-2375-08d70960690d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 20:09:58.2722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2485
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Recently, fl_flow_key->indev_ifindex int field was refactored into
flow_dissector_key_meta field. With this, flower classifier also sets
FLOW_DISSECTOR_KEY_META flow dissector key. However, mlx5 flower dissector
validation code rejects filters that use flow dissector keys that are not
supported. Add FLOW_DISSECTOR_KEY_META to the list of allowed dissector
keys in __parse_cls_flower() to prevent following error when offloading
flower classifier to mlx5:

Error: mlx5_core: Unsupported key.

Fixes: 8212ed777f40 ("net: sched: cls_flower: use flow_dissector for ingres=
s ifindex")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index b95e0ae4d7fd..cc096f6011d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1499,7 +1499,8 @@ static int __parse_cls_flower(struct mlx5e_priv *priv=
,
 	*match_level =3D MLX5_MATCH_NONE;
=20
 	if (dissector->used_keys &
-	    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	    ~(BIT(FLOW_DISSECTOR_KEY_META) |
+	      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 	      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 	      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
 	      BIT(FLOW_DISSECTOR_KEY_VLAN) |
--=20
2.21.0

