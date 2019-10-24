Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632EEE3C24
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406464AbfJXTjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:39:12 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:46757
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436879AbfJXTjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:39:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V16HK5PnuZjvDv4yu2IC3SxG6OKpjRHy4Qpyg032Sl3cnSPeitPRroQEqlNLIUhE9JVsNQAxd9qfWZC62HtRbQIM7K3lTHZ6Lp2v9m+xHHaP7jqQDq36uJMa9IHoIfHbjwrOoH7IzcOMhocvgbZ9mfjW387FW9DWOA3Hwg5fcQWT6TbUBejDzetqkYULeOFrCjrWRP4soRFpie3WMFNGfOJn2Ik5uloGNPh3LulM8inx0sEkEKaPBQf+qQoTGvYPhWd58SXvndZ7OIxwPd4Enm4s1h38+YI+Ahn9vQHFBK7YIGyBidiCzWdhOGO4JuqLkqRSXDLXLva1WDhplFFd7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DCuZCZhn5qBrFVldQ8rRBI72pnYlaPytvPzfkV0pUE=;
 b=SsgFDmp3CpTB8p6QQF1FeOVjo3PlZGfsx/fgqIse8CDCwXj6ZkwRQXKtBsRdEw0e/uNCz06Pe8qwIcLAo4t+zoouD7yYymiU6GVVDc742pe8bgMS+wdSH0zSkbVSjE+RV5EwYbzjl8R7Vqh/XohFRpfYXnrT5fVQ88wK7rhRd67eiGEThAdsP5EOlEX4Ye4Wq6y0u28km1ikNLix76UFnKX2o+/PRR0Nbz2u/hexRxbNhvCHkCrqtCeipNqy+TOOvATEG8tTzu0ZjNDoG5fq6sxC38SCGm+4Yh9GbUqeL6psieuDLIPoUWB0EqUO000Uo/xkcsBvyFfaJfT7vpPOrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DCuZCZhn5qBrFVldQ8rRBI72pnYlaPytvPzfkV0pUE=;
 b=BUnirTyFWHXlZBJuakNaalhsX36nzgvBiqQ1n0quA9in5pviTemtc7U07ExUAueA+CcECMrpDnDRgSoCSCZjEjKj/BANFxczPANT5DH6pCUrJ6g8VgNdLKlttJcFO7+7fbtmPZnK665VtkEMHKYsyvHHJIqBvE5O+AZRVEbSLvE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:39:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:39:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 10/11] net/mlx5e: Fix ethtool self test: link speed
Thread-Topic: [net 10/11] net/mlx5e: Fix ethtool self test: link speed
Thread-Index: AQHViqKvZ9HYF4wkhk2hfJc5VbJ7ng==
Date:   Thu, 24 Oct 2019 19:39:00 +0000
Message-ID: <20191024193819.10389-11-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7a8314b6-e7f6-4cb5-8401-08d758b9d18e
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4623431E1CA5CBAB0CA33C34BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B/kkr0Gl/EXCOWhV8Zk9cSmfwGFeK5FSnYujuYDek1CoNR5mHcHTzjesWvYSUFMopKxeIBvbptcLczPLdTJSBnS0LXAJN3SBASEVefYeJadKN5cTdJlRPGkXsPdTwruCd3+gelUm3GefNUmGtoWBIM7lrQuE+iC019xeYWxNZs8cEsTmKG5F5W/khTb8oy2n8ZUJFKDXtrr5+kLliQ8ZuO66pyFUiAG680byfW5Qakxae4c3ldrCHlQxuhwSCvDE75PmBrrkOh1R11jJSIfBrccYT7K3KfXlw4/mxdu3JMtO9gDgR85qBx7GNAIMyhm2Dlvd8ye7futLC4+bRInBME9OrDYAtYpqP+dRukeKKoTkK124Z6jK5XyLi+UaLIRcD3SqkvbJGAvOqgCNMpJJ8NtkU3uZsqLURtWiZYrGjd4R26hTNQ0ZGjPObIjKsHUD
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8314b6-e7f6-4cb5-8401-08d758b9d18e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:39:00.6325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xrKZrWZE37ABYZBl9U4uOrJY25AH6DTRpG0XLwBfmBhw6wBKDn9rzNpXWRty7diLQDDpi5WwrGPgtl06O5igCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Ethtool self test contains a test for link speed. This test reads the
PTYS register and determines whether the current speed is valid or not.
Change current implementation to use the function mlx5e_port_linkspeed()
that does the same check and fails when speed is invalid. This code
redundancy lead to a bug when mlx5e_port_linkspeed() was updated with
expended speeds and the self test was not.

Fixes: 2c81bfd5ae56 ("net/mlx5e: Move port speed code from en_ethtool.c to =
en/port.c")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 840ec945ccba..bbff8d8ded76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -35,6 +35,7 @@
 #include <linux/udp.h>
 #include <net/udp.h>
 #include "en.h"
+#include "en/port.h"
=20
 enum {
 	MLX5E_ST_LINK_STATE,
@@ -80,22 +81,12 @@ static int mlx5e_test_link_state(struct mlx5e_priv *pri=
v)
=20
 static int mlx5e_test_link_speed(struct mlx5e_priv *priv)
 {
-	u32 out[MLX5_ST_SZ_DW(ptys_reg)];
-	u32 eth_proto_oper;
-	int i;
+	u32 speed;
=20
 	if (!netif_carrier_ok(priv->netdev))
 		return 1;
=20
-	if (mlx5_query_port_ptys(priv->mdev, out, sizeof(out), MLX5_PTYS_EN, 1))
-		return 1;
-
-	eth_proto_oper =3D MLX5_GET(ptys_reg, out, eth_proto_oper);
-	for (i =3D 0; i < MLX5E_LINK_MODES_NUMBER; i++) {
-		if (eth_proto_oper & MLX5E_PROT_MASK(i))
-			return 0;
-	}
-	return 1;
+	return mlx5e_port_linkspeed(priv->mdev, &speed);
 }
=20
 struct mlx5ehdr {
--=20
2.21.0

