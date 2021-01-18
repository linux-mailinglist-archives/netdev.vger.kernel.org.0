Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C732FA781
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407123AbhARRVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:21:13 -0500
Received: from mail.eaton.com ([192.104.67.6]:10502 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406772AbhARRCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:02:38 -0500
Received: from mail.eaton.com (simtcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57DC09611F;
        Mon, 18 Jan 2021 12:01:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610989286;
        bh=kmqHtmMSzu+xNcq+DHA60mreglxQnpW2bt8byhHajkw=; h=From:To:Date;
        b=qMompVRsHstOikAvOuecsFfV3aBnYQhifKCducaG47Kgea455/reRDGwlcfhzIFlq
         ZLfAxHUOr3cw+Wjq0846ipO4zOJ9JQH8sJ+KtycshvsK4I3BmfDPQRkT0+tKM5hInt
         /rvzKxsNwjjpCOaTlXu05vGCgQFl6EhPtUEXZq2jNEmOh2AolddR/eVLgNrgdX1s+n
         g+J5U71k3YToXnkG16KUHUyE3+mcIwIqVteU1wTaeYMx4fhKBIOGRYfMwQyjRhGX+6
         bhp3zkXWsImeXALTKsEep/gGkHMPaj8QuI4q6pdzQi8A+sWjY4OOaYIYDsnxp71vPD
         gIOaY8EiRROew==
Received: from mail.eaton.com (simtcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DC45960E7;
        Mon, 18 Jan 2021 12:01:26 -0500 (EST)
Received: from LOUTCSGWY02.napa.ad.etn.com (loutcsgwy02.napa.ad.etn.com [151.110.126.85])
        by mail.eaton.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 12:01:26 -0500 (EST)
Received: from SIMTCSHUB03.napa.ad.etn.com (151.110.40.176) by
 LOUTCSGWY02.napa.ad.etn.com (151.110.126.85) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 12:01:25 -0500
Received: from USLTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.152) by
 SIMTCSHUB03.napa.ad.etn.com (151.110.40.176) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 12:01:25 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 hybridmail.eaton.com (151.110.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 18 Jan 2021 12:01:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wqba0+VDU9u4Er+QyLNKsovYqrXdY8EwsBtco8zPvkeQVVvyIy76b3DmaEa3sJkmX8djsA4e9L5XzEutjY6qYVuk46vMDssK1Nl8zCZfSnsr0uOmKVRDk2ml4V7IEeMgF2AGaS+WF7N9VtG+DEqbtVw9X2d3MCSIIQhWP/WpHrOCb+oZ9Rrmj1UFSH8kI4JSDCcVbisow5vtU0Dgw7RIQ87mYKSGDmfUTaq+S3sy4Cxqi6B0t7KDGhDGThO7FxqtI/+D3oPueWcuXhwf/sIJQaDhgaTTeMjkkvBjZ6l8pnU/Ab+8jj3c/GBQuNUFAG7IKOT/ZqNhMi1izi2p/8McRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+TgaeS4AanbHmMTYwBfEcVVW/ztec/RINk7FLmUbE0=;
 b=G2WyG3HScUpdq3rJkMg3KEiUdAf7TxhxDm3QSJ5MFahnJzKj7WhtGW4WUxKlFdxJCdv2eLQa4dDoe/PS94ynHmTAeuB+eKaLM0hm+FBooK+w08VnX0DQmC+KSd1u7fO2DBm5gSXMC568j36FgmrDexryo9xdOl4YIDCKZXW/bs3dqEehvnosj0Gb5acE5Me18kkYl38LT0c9sf0p74L1Ka24OxxKIbP2dVVZaMv+BS3liOxZjaO4Bc1yBrxWk6qTfjrrXWln1nNJYbEWZXjouJNmgG9YGUcWEs9MkIi4b1gQE2wlZ0iVs+rNOM94/aPOw2uiF8AICE+tjE5R/SnKhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+TgaeS4AanbHmMTYwBfEcVVW/ztec/RINk7FLmUbE0=;
 b=5SIe9HsWXq5rZr+xQFHvHZSWUtTFZmscKLDGz+m1tAIgGNu20mAc0uXI7NXQGCP1rI6uo5NKekx+SSsstHU1BfY/VqGHNzP2N/rZsVD/tTEwAFeSYXzx/0QOPwT0JUJuEcQYJPWpNoHFUuqfduZiB+DLnHgscOFLZi5w9Zc2NSM=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR1701MB1743.namprd17.prod.outlook.com (2603:10b6:301:1b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 17:01:24 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 17:01:24 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
Subject: [PATCH v4 net-next 5/5] net: phy: Remove PHY_RST_AFTER_CLK_EN flag
Thread-Topic: [PATCH v4 net-next 5/5] net: phy: Remove PHY_RST_AFTER_CLK_EN
 flag
Thread-Index: Adbtu4uD2yH+k2AQQQug431lAfww7g==
Date:   Mon, 18 Jan 2021 17:01:24 +0000
Message-ID: <MW4PR17MB42431E772758824EEEC5C399DFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77024f4b-1247-48f1-312c-08d8bbd2affa
x-ms-traffictypediagnostic: MWHPR1701MB1743:
x-microsoft-antispam-prvs: <MWHPR1701MB1743A9DEE3D78DDB1A1E9919DFA40@MWHPR1701MB1743.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:118;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RWPEMY7Shrbna5rEXP0MmYkAYsPT65+qIW0E2ZCu7QWSzBNOXcFOtIZOaGvZ6bOtJF+eKvFgS85KlH3c9egdgmchX0vghtUf7ozAlZEPBSeV7BKCfoPSWEbdkczsGY0A+2VdiXad/y5a2dXyR5/jbY1gcyZLV+8zf12EASfX3QuezcB1h91eucxWcmjxsBF2hmUabc521Cl25FCj9g9b+D2TuTHG/kPg2VQ6iqb5xQAckbPnjzilI/SUlBwUBL3mK/8e4u0lm1F7WzsnbZ/nocXE1e5sPoX9MYRUZks5JufQJ2gVhaXEXhWg2azEcDD7/05FoAIPfcLMeQ1gfXeV94S+yEqLsT1wbOGsiKOYoJ3HkEkNfh82lHQB8DWeK82pac3bM5vMAHMcxXtbKuM2AlB5GZINXbmOIRlf72QcV4BSgY1VyU2QYwGrjphx5qQ6xoUxTXg9pzw2IAZHJ7UmVMKrUZ8eOcK2Jfee4Nri24Mg+a9OlXyPRuZ4xHJTqXDV/REXcuD8KEHwiI8o+0mmbDZU2ADPZxVkaXZWU5Kuq3uK0TkconHB8a4wOdwjFrE7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(39860400002)(346002)(2906002)(33656002)(86362001)(110136005)(7696005)(66556008)(55016002)(186003)(921005)(9686003)(66476007)(8676002)(5660300002)(71200400001)(478600001)(26005)(83380400001)(52536014)(66946007)(6506007)(7416002)(64756008)(66446008)(8936002)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TV0GBwp2iYKk7qfT6WC+Z5MJ+yrypJxM6uwi28vjjDzV0chtOedu0UnjN2lY?=
 =?us-ascii?Q?XKn/izOyV4TN/y2Lcn778DKNv4sOS8cE/+EuFFdyQZle3F7yibPJXfs7QiA2?=
 =?us-ascii?Q?XIJFXwJ/babRDc3LCH6HE8WeSj0x0zFeyvWNk8tCkAAyfeukKizz9j4qguy0?=
 =?us-ascii?Q?ezWBfIJIsJdVS+adhgBVFD/iAX1GhZOb6W4uncW8M++5YZzXuKJfwTzWL+Rf?=
 =?us-ascii?Q?wfz7ppFcbY4GZdV463fEgqAvnSxrVdY8ecFQwXt+Qtq3RUBk5tlGb8t6APc0?=
 =?us-ascii?Q?Pks/OkwL8ntbd4z/oCd96OGLZ0zDUjVJH4QrkLOh7BvOy8jdsMDN75aUzise?=
 =?us-ascii?Q?ag3giFimSZHMIGkVY9+3UpJ9SkVKVq/ebH1Ugdmub6VB8fL7WAGWi3h8F8FT?=
 =?us-ascii?Q?mkvm4IyhP1ERgR4fU4M4mdz+uYw/bta2HhjJqQjl9HXnhcuv556qPpgPIjMb?=
 =?us-ascii?Q?1+o6nYkkF363+t09E782zLHTgaCrOP24e3P1WVQdtzhI4/Yep4d2kYmUcxXB?=
 =?us-ascii?Q?RWJi8w5fsXFPNdw4KbnUVzD4ze6jVnDWDLE6Q+meSplo/F/UtCpyaqMyCQx7?=
 =?us-ascii?Q?qPkCwMVZt2Vmv7GpIP1rtrRw0eJfkMxlFnUvsESu/GT4bh6CzkNBqoBd9Gz9?=
 =?us-ascii?Q?xSPD+h3UzAbQriWToumGozAhTZbUb/5Vn73XjlWtSvMbkrFnf6PsG3FkCrM6?=
 =?us-ascii?Q?It+nu03ZtZdL1GETvQ7lykUj+nWIK7zrSM22LcFM9UJGIlOiX0Yy47aR+ckw?=
 =?us-ascii?Q?jvRGKAYNQwQ8sBXSHQ4+ED+CJTot9JUX41upJIh3OzDoFKl4EhO3GhRBY10i?=
 =?us-ascii?Q?060I3Q/MKMB0jO/tS+Kcww+bUCvxtZVXRPs2VOLvBtJJobKkkKZGN7pAqkh7?=
 =?us-ascii?Q?+toGUW7HCsfXmr8izKrMv1hLq+3VAEgAIg4NABk83rofGNBagyL0ayyLJ0GP?=
 =?us-ascii?Q?3ezHnr6BTQXhAnVs0DhHMy/vOsd5tWH+wmDEse3YefE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77024f4b-1247-48f1-312c-08d8bbd2affa
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 17:01:24.1805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/5hRWvD2LiCHFeklR9H0y/6wUrEko+DOqWRKyhbM+uEQOY0GaJiSwmG4rtz9kL1L0+Hm5YNteZtCNTvn/lmHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1701MB1743
X-TM-SNTS-SMTP: 316E7260C31F015FB125DF25AC8850A00F301B34E3B7021930D76C65D63565BB2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.001
X-TM-AS-Result: No--2.333-7.0-31-10
X-imss-scan-details: No--2.333-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.001
X-TMASE-Result: 10--2.332700-10.000000
X-TMASE-MatchedRID: +OPntZOax7eYizZS4XBb3xIRh9wkXSlFUg5zxCPHJW0c05FUWtYLThon
        Dr088qtFS17ESRNe8ZFw5T4Iaj538mJZXQNDzktSGjzBgnFZvQ5JaD67iKvY0xpX1zEL4nq3ljR
        8PizTzeOWiQhNVD49liq75Q09Yd+ONwVqxkW3/z9Ps79gcmEg0KlmjFq8ZmGOO312fKgjq4ltap
        T6O1Qb0yq2rl3dzGQ1ssOcArzi9zl5e0WTkY3zouRmUPwaKuTrxIOXFOVqB9ReFkcgd4yzUhx2z
        CUmW8rV3IIePq9PTXfJ1ZJszIgAnWTlGCKFGdAMFPAIS9hyhGrb0LncCWtVBG4ljHS6azP5m4z+
        eW1nbUHIsQozxkIbzkMMprcbiest
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFRemove unused PHY_RST_AFTER_CLK_EN flag.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/smsc.c | 2 +-
 include/linux/phy.h    | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 5ee45c48efbb..17a48f58e71c 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -460,7 +460,7 @@ static struct phy_driver smsc_phy_driver[] =3D {
 	.name		=3D "SMSC LAN8740",
=20
 	/* PHY_BASIC_FEATURES */
-	.flags		=3D PHY_RST_AFTER_CLK_EN & PHY_RST_AFTER_PROBE,
+	.flags		=3D PHY_RST_AFTER_PROBE,
=20
 	.probe		=3D smsc_phy_probe,
=20
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3f84bbd307fa..6e5525acc49c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -78,10 +78,9 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_IGNORE_INTERRUPT	-2
=20
 #define PHY_IS_INTERNAL		0x00000001
-#define PHY_RST_AFTER_CLK_EN	0x00000002
+#define PHY_RST_AFTER_PROBE	0x00000002
 #define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
-#define PHY_RST_AFTER_PROBE	0x00000008
=20
 /**
  * enum phy_interface_t - Interface Mode definitions
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

