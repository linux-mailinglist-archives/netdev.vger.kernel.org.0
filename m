Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2892149087
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgAXVz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:55:29 -0500
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:56737
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbgAXVz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 16:55:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I88EW3ld9bB0dq9ktlaQHpB1IV4LJiyssOrXeMhJPnWhcSqSvwbyRCAEJT7u7R1s4vwTQ0s6Qaiz7duSMpgVeGA5tA7Aw5HAR5PjY48rILYSvYYyWDwQ9Jw2G6RenyTRGiiqtjBoIuYJWeEv09CyOOjypMMeZDvhBiaUFR6Yi4Sf6r4ZaFJDu5oM9QhfWn2/WrOt1k7456Krbn0QhXq7k8jigtrlP06Qt22QGzr1vBn4oDPsPvl2OUx3GCyMcKFC97x9FbRP07qV5yM/EFglHZbCK/VZdIBekvGT02XwSuu3MX+6CoBwwp8Bna4pH625pecbraZy74vmIOfV29n9rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dki1iYIuuC7GDN4m9leXrHpV6rFmB1ISDqflyDuoZJ4=;
 b=lzvtQ2JN4JleMb9a/QjpX58dPo3vS2h4q2wZqsPwXfuGuNYs400mq9OkYaglrYyiXvuAAwG5dgMiO1/z8qq4k1eZzrP3gLxVPqV0LuZuYHrHenvHCVqs217UJmbK2N8PUbWGnWRsn7irVxQ7fYNIbJOaPO1Nqi2mf1qBfQ6p8m1ppKIiul/BKrh8uZehyDvJqrkoqgTOhbq7ERqejguLwHHlg+ez03KXx4/vDHKIMIyg1mQ9KZ1cZQBGG4gecM4DLBSBUQx4tCnrd5gnwGUYGDugCm1jPvC8O8iP6rRduTYq753h29lVChvlQ1+ubaILbzlaUD7w43IDBKBv11hP1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dki1iYIuuC7GDN4m9leXrHpV6rFmB1ISDqflyDuoZJ4=;
 b=OcWrmfCIzC+PI5K8EPFmWvg35QyMexlg7IMCpDbEFXlHp0RwD8Ag/g4oRHFSzjsOysXcG6simyQwyTQfe5qfW1KTLky50QUPX+S0I7b0ZUne4B/Ike7bbUuW0o9pW6uILmrLfHRTBqKy/opaDqRipWAoPFLCtq1Y0Zeqw1GcK9M=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5456.eurprd05.prod.outlook.com (20.177.201.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Fri, 24 Jan 2020 21:55:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 21:55:16 +0000
Received: from smtp.office365.com (209.116.155.178) by BY5PR17CA0038.namprd17.prod.outlook.com (2603:10b6:a03:167::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 21:55:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/14] ethtool: Add support for low latency RS FEC
Thread-Topic: [net-next 11/14] ethtool: Add support for low latency RS FEC
Thread-Index: AQHV0wD2ddAWdnPQRUiCpnz5P6HLqg==
Date:   Fri, 24 Jan 2020 21:55:16 +0000
Message-ID: <20200124215431.47151-12-saeedm@mellanox.com>
References: <20200124215431.47151-1-saeedm@mellanox.com>
In-Reply-To: <20200124215431.47151-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR17CA0038.namprd17.prod.outlook.com
 (2603:10b6:a03:167::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e40ef0e7-6e37-4d3c-1896-08d7a118188b
x-ms-traffictypediagnostic: VI1PR05MB5456:|VI1PR05MB5456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54567F6CA48122B2FFA5203ABE0E0@VI1PR05MB5456.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:428;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(956004)(4326008)(107886003)(5660300002)(316002)(54906003)(478600001)(8936002)(2616005)(6916009)(26005)(52116002)(6506007)(36756003)(8676002)(81166006)(81156014)(86362001)(16526019)(186003)(1076003)(66946007)(66476007)(66556008)(64756008)(66446008)(2906002)(19627235002)(6486002)(71200400001)(6512007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5456;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2np0W34+kz9buZ4FPh/bpL59lY9b8B53Va3LIll2gWSjxFM1MIIL1Mx3BPQZN72XhFarfTYE4wn8v5uaekFtYNQQVxZDQr4cQXKTMLomKeaUSf13DNMoZ7/V9ECc9K/GGEK5hSt/7vwQrAluSLiN/XBFtDVqqZtJ0d9zKln18qDVJZP9p7HELr7HBlbw3iV3E7obeg85F2NWFiQyeOyeH/C6cBzwLxHqgSvNpAH0UFbK3chwkuN1kJGks5gSAoesrCOvqkNmtIg0ptKbrQpwPmOQ0FK+373WcnNBjqC6vn2ICdsaUWMvX0C41NrUpZxSMPC71DVPw17cOukM4iee+IBzGIPTJ0ZYHPwIfLw6qQKgbGOJnv62NWGJpVtxrRaNAv8rLWzA8s9ejisT0M5F0EUvjn0EhdrXTRQlGDiDxBBACMB9H2H0WnmkZB3CYaDZMK03GQe0xCIr4fq9JHfUpgg0sTwA/b+0WE5do/QBhvFvTldadxv7KnDGj+I/+ORknwmMWWCm8hLZ6UkyDa7Kt+GCeWStBIwlueERsRyys9U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40ef0e7-6e37-4d3c-1896-08d7a118188b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:55:16.1489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zumzdJUzNBtTeWSUpUleN9xSMbpTeCz7d4tklx7aib57KZqyISSPa5UXqTIbcHB9PjKlwIHfYAvkpAENaGcmug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for low latency Reed Solomon FEC as LLRS.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
CC: Andrew Lunn <andrew@lunn.ch>
CC: Florian Fainelli <f.fainelli@gmail.com>
CC: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/phy/phy-core.c   | 2 +-
 include/uapi/linux/ethtool.h | 4 +++-
 net/ethtool/common.c         | 1 +
 net/ethtool/linkmodes.c      | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index a4d2d59fceca..e083e7a76ada 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -8,7 +8,7 @@
=20
 const char *phy_speed_to_str(int speed)
 {
-	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 74,
+	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS !=3D 75,
 		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
 		"If a speed or mode has been added please update phy_speed_to_str "
 		"and the PHY settings array.\n");
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 116bcbf09c74..e0c4383ea952 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1326,6 +1326,7 @@ enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
+	ETHTOOL_FEC_LLRS_BIT,
 };
=20
 #define ETHTOOL_FEC_NONE		(1 << ETHTOOL_FEC_NONE_BIT)
@@ -1333,6 +1334,7 @@ enum ethtool_fec_config_bits {
 #define ETHTOOL_FEC_OFF			(1 << ETHTOOL_FEC_OFF_BIT)
 #define ETHTOOL_FEC_RS			(1 << ETHTOOL_FEC_RS_BIT)
 #define ETHTOOL_FEC_BASER		(1 << ETHTOOL_FEC_BASER_BIT)
+#define ETHTOOL_FEC_LLRS		(1 << ETHTOOL_FEC_LLRS_BIT)
=20
 /* CMDs currently supported */
 #define ETHTOOL_GSET		0x00000001 /* DEPRECATED, Get settings.
@@ -1517,7 +1519,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR8_ER8_FR8_Full_BIT =3D 71,
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 =3D 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 =3D 73,
-
+	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 =3D 74,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index e621b1694d2f..8e4e809340f0 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -167,6 +167,7 @@ const char link_mode_names[][ETH_GSTRING_LEN] =3D {
 	__DEFINE_LINK_MODE_NAME(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, DR8, Full),
 	__DEFINE_LINK_MODE_NAME(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_NAME(FEC_LLRS, "LLRS"),
 };
 static_assert(ARRAY_SIZE(link_mode_names) =3D=3D __ETHTOOL_LINK_MODE_MASK_=
NBITS);
=20
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 96f20be64553..f049b97072fe 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -237,6 +237,7 @@ static const struct link_mode_info link_mode_params[] =
=3D {
 	__DEFINE_LINK_MODE_PARAMS(400000, LR8_ER8_FR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, DR8, Full),
 	__DEFINE_LINK_MODE_PARAMS(400000, CR8, Full),
+	__DEFINE_SPECIAL_MODE_PARAMS(FEC_LLRS),
 };
=20
 static const struct nla_policy
--=20
2.24.1

