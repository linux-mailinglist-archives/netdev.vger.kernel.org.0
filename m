Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED62F8295
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbhAORcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:32:32 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbhAORcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 12:32:31 -0500
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 899128C0C3;
        Fri, 15 Jan 2021 12:22:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610731360;
        bh=8M68yMSh+ONng7YwxXamLg53dQTCctYPBWEjK47ZkO8=; h=From:To:Date;
        b=IIFtX/OWNN+9L+EigmEeqMCEQzyT96lm1qNyJtZFX+QQgmG4r0AhL7GK7RFMdvOc4
         U25GAarUMc8bvT6adHwk5c1S5ZwEfr69ixWvVhtUU3S1QP4iAgY2nTG2lV2R658v5z
         D92qYYpyF0pYbyRDjNTsqZBS2ZsAbSsq/NKFMlBHoL+Cf/KZwRCZP+n6KgG5Z9bs3i
         ZyHA150JhRmY4Ixiv4NH1d/tDamRdD6Ed5oU0/78bpZ3j8QCx4LRYVLsM8lANS+L4T
         /lZXCZlal88KVZgt57mAMVEaxi6BbOnaNlCquuHSqvCINa1T3gu/T8G1kpT5B0YWNM
         /yQbvTFtDL7wQ==
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 791478C0B9;
        Fri, 15 Jan 2021 12:22:40 -0500 (EST)
Received: from LOUTCSGWY02.napa.ad.etn.com (loutcsgwy02.napa.ad.etn.com [151.110.126.85])
        by mail.eaton.com (Postfix) with ESMTPS;
        Fri, 15 Jan 2021 12:22:40 -0500 (EST)
Received: from SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) by
 LOUTCSGWY02.napa.ad.etn.com (151.110.126.85) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:22:39 -0500
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:22:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Fri, 15 Jan 2021 12:22:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULhGLvvZmCyOPI+9Vnq3ZVLUqbN6aeHOlJWapHuYg2CR+BsJFaXFEAwr/2uSERs9ZeJ5b5M9Zu1ADmWfSSVM9FNGpa9LxhPpPY3Q8qAHQYaPUjeg2Uwst7XHikdDEuJ1LffQQC+GkdIeusF5UxDqhVT+/4MkJSGM1qKANwc5fcUc/bKBuCJDDwAau6MEnv/KjfVmxDhyQBUFaefXnumCYdMAkpprYaaPb+iXV/e8asF3sC7J79fdht+3PtCG9s5he8EHYnK98KpN190QIid2Scy3PA9mWlJDQVpwHidjbKPrWFO5bmEXGGlB/8ANV6lA5d3fCML8v1EhJmCZDVm/SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIVqBrzOAQW5L/nmIThXBg8yRHO+pNqnrd1hAs3GMWc=;
 b=YcslPiBeHz8U1R7VhQNBk1OCq3XULxaNN/FbYNs2kwuYXfl6Yav2rtZUkudZgoTrPnSfMi9yWkOBsK1RxL2btsxa8IG4z5qv615UEJD83eCu4CZrF007QxrF3lmqrFeF5gR669kTNRF5tzso5Cz9eXVgYO2GGbKV1mogbzOpPcj4TgGY60PMSTjkS9vrdYU1rRtnw5ldQiUis4ou/tFTsU8goBWKb6BgHV++0Hw2cAiPN5ZaO+7zj9ktW/OIV1p/CxDnTbXV5jlO59ts4bmhjaIPcxVVOS132/jVHQVFKkzP+tl4sJuvQCTjzS/R5MsVuG4cnOfSYSCGErEdYSajXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIVqBrzOAQW5L/nmIThXBg8yRHO+pNqnrd1hAs3GMWc=;
 b=FqRjnL+ynEVNaXBMX8zoUvTAbCmHyU5bgcJVCSDuI/XMcvO2U63rQUAycwQCe/L7pFtqyyZQ5PoAlK2VzJpTgYLsa7qPk2fZbeN1WlxU/eo2idNTw+pb+Vwd9E3HWuaZ1FlTUe8zqivBlCL2GquX+nHed88m91sQvSiaZf7sCIQ=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR17MB0991.namprd17.prod.outlook.com (2603:10b6:300:9e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 17:22:38 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 17:22:38 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
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
Subject: Subject: [PATCH v3 net-next 3/4] net:phy: Add PHY_RST_AFTER_PROBE
 flag for LAN8710/20/40
Thread-Topic: Subject: [PATCH v3 net-next 3/4] net:phy: Add
 PHY_RST_AFTER_PROBE flag for LAN8710/20/40
Thread-Index: AdbrYwRiIY4X9+eYSeSXW75fPkbWWA==
Date:   Fri, 15 Jan 2021 17:22:38 +0000
Message-ID: <MW4PR17MB4243D8F6B61CE0B20E512F65DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b626aa24-736b-4e57-d9ea-08d8b97a282d
x-ms-traffictypediagnostic: MWHPR17MB0991:
x-microsoft-antispam-prvs: <MWHPR17MB099105D3BB6EADA98DBD12AEDFA70@MWHPR17MB0991.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QNwWCItQKQG8PbQN6w7YGAlue+YZfge5gNK0Gw2cn+MHlPlEKQwR5jIzgvD7Osx9YxciJ4NVXA9bYtLCwW9c1TcfleOhBVVMEgmxhb1EE4TBhkAP+IsYhPG4UxEdMH6DRBGr2VZ4KQ1qZh4/xj+hWosmxARdZkLMBcWymTJxZKUJznWHvUPAndVDLMe4rrZSXqLrLOOUZpTGUXC7KuDMH2tgKwVkdJBLeWaxqj9LW1qlWbhR8Y3WOmG4uIFFmmR3I3IpeVTSOxc5Cb8gbamK52xUzpxJYGVayes47x3zFb9w8Tcl+YPR5qgLIkbLECbapuEB4gLboRfk74xgxRcUoJxVrSQmCsHsixtdZyyXT6RQ2IXWFr+wY1UqFunZ3ewCfMXi1MKEft7V/W9Ir1LfM0/kRsGA8F0N6p0/AtZowQCTdlfBr5ee1rliE4jG13Kk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(366004)(376002)(396003)(33656002)(921005)(26005)(52536014)(316002)(186003)(71200400001)(8676002)(6506007)(8936002)(66556008)(64756008)(86362001)(66476007)(66946007)(55016002)(66446008)(76116006)(478600001)(9686003)(2906002)(83380400001)(7696005)(5660300002)(7416002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?X+nN5dSw0R0WuDFNv4oNQL0rgLpxYCrBeW0qiTFgLasTh7OBMrEv86y3eX5U?=
 =?us-ascii?Q?2BFH6OBY/qXBYOwqoy9M3NdWzfx9qS0WewUAUZJcEIzvBbeG15/m4K55D7+X?=
 =?us-ascii?Q?gtBihSddyoC9nUerpuJZgNoUEtJurVHN+wISvZl/yxQ1vco99FNdINnkZOSP?=
 =?us-ascii?Q?G2Rqi/ETcEo7fX1KYUzNzylnRPFbno+V0n4NYQ8htv1YaMjlJknMWk6lY4I9?=
 =?us-ascii?Q?O5xl5YtjBWZQeNf1JIXfSAQVtMFv7qQquHpzUgo68qI8/3j1RRD7Q1BfvZy1?=
 =?us-ascii?Q?eB59NakE0ddJiG9UEvt7uQIbAE/78KZG4xElJoLB5lFdVz00Ao7dZ7c8heOs?=
 =?us-ascii?Q?9P42IB6lzbRD3r6NBrrX/6SgoOREgn/7XfbZq0u1aCWncxuNfNjPwX6gtUji?=
 =?us-ascii?Q?TzbCMGd5sedbxkY7fH+g9Z86w8tf8abTsc5NaXl560bZadp/v2BG/N082eaZ?=
 =?us-ascii?Q?OahnzkJ47E+I6b7WgKNNAWBkTlz43Ukk4JUDQ/+JV3+Fr/g4vj1sfkFH2oJG?=
 =?us-ascii?Q?+1iwhCZoNp49FNZfcWlm6Jy5p1UAIR7glAurMV8dXzwngEJXLHxJxp5kmma+?=
 =?us-ascii?Q?AJgyRoTE7PEws3Sryjoexo/JUOng3Sq3LRd2rIBDzEevZbGF0gAMuNW6/Wti?=
 =?us-ascii?Q?dGxezE3NPfyGKPyPpFMSuNGg7Ex2Pj+V6Hdx3JdKkMZwr9AdmlyKXeSr8u3D?=
 =?us-ascii?Q?ZLr4PURM5sM8rswPjqLk07rPoS/9VX/ezgKG9HsN9wEhVfZ6LR+AQgD9CctF?=
 =?us-ascii?Q?SxGD5X6GuGtm3YxN1vK9cVVmo0UXVJKDFipZ0O6xbwU5kZiu14edj4OgNUGV?=
 =?us-ascii?Q?qmPtu0bYaXTKcCS+HfKg1eYmdHo3BPsF4piqq7hQ4tsYI2e7fPDu4cMkG/jT?=
 =?us-ascii?Q?BK9eGGHCMQ379voaMBhOqlnDETMIj0K1X0LHPh2artcCQ2IuoEUUHRrRjLbm?=
 =?us-ascii?Q?wCNn1cOt6GvEXZJUIRuHuefheT7t4Iy1uGvyPnqj2SY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b626aa24-736b-4e57-d9ea-08d8b97a282d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 17:22:38.2574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UJCPFlsMf1095lhSz33Si+brv0UO98XLaAfmExX95iiBFN4mQrbMBP9EfJBYjfR+TxAc/KgEDhrRXVm0CmlHjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR17MB0991
X-TM-SNTS-SMTP: 3A22FAC690925F71BB81079C7F55CF37D53CE705BD300D0C0A0D5E229F921BAC2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25914.001
X-TM-AS-Result: No--0.691-7.0-31-10
X-imss-scan-details: No--0.691-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25914.001
X-TMASE-Result: 10--0.691500-10.000000
X-TMASE-MatchedRID: Ts72c050/H6YizZS4XBb3z9B1SHosSXQUg5zxCPHJW0aV9cxC+J6txMn
        vir+JcmK+wdgGolwcUXE3UW02mrQtXFXmAqsdcFc9u1rQ4BgXPI/pOSL72dTfwdkFovAReUoaUX
        s6FguVy0UXnr/BQqsZHJjT27AC7OnYgYeypZcRHOqh5pv1eDPzy9Xl/s/QdUMeqbdaFPgv6T9r/
        IF0UqfoAQzkAzkcS6bxEHRux+uk8jQ9TRN0mhS16hup1L61UUr3prOdNg+PTOLUB4JCHYYh61u5
        /UAe6WMGi/pF2Nsj/0iBu2mW8qchH51Om7yvvuFXaDesAxaWRDCCzk250PBCR3Gm5R2h/Q7LjnH
        09LU/owIi37pJqP4+7/Oj7BAzdYuDfWVvHtiYgM=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFRename unused PHY_RST_AFTER_CLK_EN flag to PHY_RST_AFTER_PROBE for
LAN8710/LAN8720 and LAN8740. This flag can be used by phy_probe() to
assert PHY hardware reset after probing the driver.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/smsc.c | 4 ++--
 include/linux/phy.h    | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 33372756a451..ea966e463dbf 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -432,7 +432,7 @@ static struct phy_driver smsc_phy_driver[] =3D {
 	.name		=3D "SMSC LAN8710/LAN8720",
=20
 	/* PHY_BASIC_FEATURES */
-
+	.flags		=3D PHY_RST_AFTER_PROBE,
 	.probe		=3D smsc_phy_probe,
 	.remove		=3D smsc_phy_remove,
=20
@@ -459,7 +459,7 @@ static struct phy_driver smsc_phy_driver[] =3D {
 	.name		=3D "SMSC LAN8740",
=20
 	/* PHY_BASIC_FEATURES */
-	.flags		=3D PHY_RST_AFTER_CLK_EN,
+	.flags		=3D PHY_RST_AFTER_PROBE,
=20
 	.probe		=3D smsc_phy_probe,
=20
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 58b4a2d45df9..0d588ec6cd5e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -78,7 +78,7 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_IGNORE_INTERRUPT	-2
=20
 #define PHY_IS_INTERNAL		0x00000001
-#define PHY_RST_AFTER_CLK_EN	0x00000002
+#define PHY_RST_AFTER_PROBE	0x00000002
 #define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
=20
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

