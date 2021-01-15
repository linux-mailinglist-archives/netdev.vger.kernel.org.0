Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324A22F829A
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbhAORdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:33:39 -0500
Received: from mail.eaton.com ([192.104.67.6]:10501 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbhAORdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 12:33:38 -0500
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73EC8A40E4;
        Fri, 15 Jan 2021 12:23:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610731410;
        bh=FM+Y27qcdPGmrbTMRUtFEyoOo2/l4vOjhw3MyBY+XMk=; h=From:To:Date;
        b=A3k2JsxpsGJoggavd3wfdTB76GT4r4AtBUrIrDGqArecS2BVaMGKgoRHlhnBDk4Pr
         38kKcU4GR6in9uqiTCZffT+VD4WSZmbX7R/Z05+lZCIGzPesjGbSaMbqi6J+A4rJuk
         SjiU643zgOE7DDVVx4uppQ/puPvXoPTcwvIb9nxk9iIV6GLsqwp1toZ2mYnQLzJ0/b
         Kj3H3AW+UcbvY/UqH628Jwip0rbK2QzoZnlXM+baXyF7XpI1r9lGWTinoBKVh+Uzwc
         HRblEwq+Gwdr0RgUmKe9ORIm1omuQOKf9ii4ogZnGwtorD+cC7Xjrx4VvBj4UH2GvA
         EoYs2Q9sNUl3A==
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C90EA40E2;
        Fri, 15 Jan 2021 12:23:30 -0500 (EST)
Received: from LOUTCSGWY04.napa.ad.etn.com (loutcsgwy04.napa.ad.etn.com [151.110.126.21])
        by mail.eaton.com (Postfix) with ESMTPS;
        Fri, 15 Jan 2021 12:23:30 -0500 (EST)
Received: from USLTCSHYB01.napa.ad.etn.com (151.110.40.71) by
 LOUTCSGWY04.napa.ad.etn.com (151.110.126.21) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:23:29 -0500
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 USLTCSHYB01.napa.ad.etn.com (151.110.40.71) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:23:28 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Fri, 15 Jan 2021 12:23:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbdjN7Tyh1TlKCpt/pXmcJ76tRQeyKiNysILKXHVJFE7Ne9t6NahhPC/7NylrJfMUZFVuZNOEElXEVhHnZAb1vqZfF6z85fddcfnwVroYJIMnfEUEYGqwr9mR/Ye0Pk2pbKFpBMruQDi5Vg30b3kI8UFbuOWdGjpaQ3WWSuUusWCmOwAEGjYtCgHNovvENb5vQndgDAtVLSNAGoOzQrGugMDzyoUI5uxtqPmjMmghSLNvSdBTF6lpGNeJrMZ5PSJZeVlGCVN4JMzT4xlrF6ia0an0BL6QdGAU6PlrOCvSJQLdLm9NTeSEb2N8/fw/xukd5bpuxCDOnH/hqnSmJfqBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1cwj9Xl9RNZm+xVFt1PbZ0xgNuPrvUiJZgBfAoQPnU=;
 b=Ff1LgV/nBuqGvyZT0go0QPTrpfX+F/b270tjNYR0WTCsmwLI6+5uS5fsW+NmYTFZTt286UUFjOI/nlZms4omqzr2/OU04dbT0ndbUauvH1ey2EDXRJSobydg0lRpd2nth0bfZ8Dw0tx09CUTezUFf8cHG4NbPpeUgIfy8bV/8LrPpetbqW1bdOQ6ygboJanwBnyefRJMryE/FjtxUbP+jjpig7ZD2f/tMP8VComV+CPPemQAqafBeyok5b1FTKqKUClccYJqXK4OY67fFBWNj1Hz0vJQo6W+zddwBHAYtaoJtFKtgp3cXT9kijYg/xPTSt6tDyZv8KDvjIGBUAj/ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A1cwj9Xl9RNZm+xVFt1PbZ0xgNuPrvUiJZgBfAoQPnU=;
 b=jMvRMa1Vam/IWoxF/obpQ/qkAAi9BAFdsAYTQVPx1oguMMhciVyTkLWSyFLJTha3C9J2GaGrrne4ibhgUqdPLJN9uQFTfLRq4KyjzzLoKmt+ptWkUnHoChcefPbZUbxF2EuU9JH2kCRNWCKZGHRlHQwAMfGYvyYqBq8W/x8YoHc=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR17MB0991.namprd17.prod.outlook.com (2603:10b6:300:9e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Fri, 15 Jan
 2021 17:23:27 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 17:23:27 +0000
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
Subject: Subject: [PATCH v3 net-next 4/4] net:phy: Hold LAN8710/20/40 in reset
 after probing
Thread-Topic: Subject: [PATCH v3 net-next 4/4] net:phy: Hold LAN8710/20/40 in
 reset after probing
Thread-Index: AdbrYyHB6iHG167iR6CP+hGjiVkkHA==
Date:   Fri, 15 Jan 2021 17:23:27 +0000
Message-ID: <MW4PR17MB42433723972317D0AAB25DD1DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b07d013c-43a7-4464-bb46-08d8b97a4575
x-ms-traffictypediagnostic: MWHPR17MB0991:
x-microsoft-antispam-prvs: <MWHPR17MB0991CF0D247CE65A8894585FDFA70@MWHPR17MB0991.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rt3zfoB2eBo2PT+ShjKXVwTL4AgqKbpgkk06lvJgQZoPEMESiUhcxhHoin1b/+yjfhAGroDJuVXHFtFzSJpjEVkwWwKZiUTNfczDrhRff0npqtae6XzLFD91jcwcuDFZmFEfEOzy4wdhgZ05r+lzJZYJrhVxA4/FFLmPbmbyJONbtxt5zA7fD/Cmd6NKRM6KBhVWwiUxHJLSSZGeXJ/AgaG4zbJzH+VRVq6/d/xdqMRzkHcuPZ0EPDviGLbwcq0PyIH1zh30Otc/WPJiaYVe59tG0NZXsdo1c4b418ObutIOGi5Epr5SkK3YiMA28Xhs4d7fx0W+XWBSY4CydzMLl9a1+BGBYxgfU7oLEH7iUOVl3EbuGTVBlJ2BsM3Lmtr9vo4LP7GCs2hQgT9qJzE261+G/+xyT8jTL/wN3IeOHHd0FNLyk7aJ4vcsK0OWzGoY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(366004)(376002)(396003)(33656002)(921005)(26005)(52536014)(316002)(186003)(71200400001)(8676002)(6506007)(8936002)(66556008)(64756008)(86362001)(66476007)(66946007)(55016002)(66446008)(76116006)(4744005)(478600001)(9686003)(2906002)(83380400001)(7696005)(5660300002)(7416002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1eHUpIid2ojZ8v7brrXOYnvlVhBX4hX0kF9Hl2C9kIVxhma74e2WsklsL1/U?=
 =?us-ascii?Q?hSloZdBE/pfQ5pB8goHIpuk4udbpj1lgAdasJ58f78W5qQV31/1rlXztjvti?=
 =?us-ascii?Q?NgwmLxf8pQG0qgnkRHjL14Glcc9mVeuYh7LPRQrAp1A10r42sxNH3uoLoe7E?=
 =?us-ascii?Q?BW12e1X3dRfdVyGxriw0YwfNbr/QFbmf/PtrZnZlIo9PNG7b8vIRPROdl6iu?=
 =?us-ascii?Q?9n+cLEfsWhnp5TyfGMNZBT2iihefflYBk5RnOA6bYDclxepsJanmbRwyBiDK?=
 =?us-ascii?Q?hfxWEs80r+L59yh0nNgNal5m0YYWmrVrct4kwQozKm+52TEnMI0lElGm3mCr?=
 =?us-ascii?Q?ElRN/zIftmNwlVSEB6l+vUBaIJtndieowoKIEvVf2ds1/OjWgTquWjU6+W4n?=
 =?us-ascii?Q?OQF8O7ViobyUhZtGYHp5qcbLExXRh/fEgW+M41BnJ3twQrynYOKulUOfoEvv?=
 =?us-ascii?Q?Ne29pAH6o1do4XMP0hmNw2Vu+pxVSgI4jsB2Lr7VrZwuUpGeer9Hif5FA0W1?=
 =?us-ascii?Q?r2ilk3YIYRjmTv8LxH4b5V92qy7N5bVB6PWzPFDLFv5lqnBy37TJGCYLoIj3?=
 =?us-ascii?Q?izeYJR+emTSpc1L1WVu9aLFRBrkLZs/FLgVtTpBad2vVP/yiNdsxuzw9f3eh?=
 =?us-ascii?Q?KZ5txb8sNwHQ8DFz3j/Mr/GrL1hZjPVZA7bbobXWmDVmGRCM5bA33VlszC/0?=
 =?us-ascii?Q?khUd8oBwi+hh8ylkNqGcFPF5+uI5T/y4G4PC0LiIedLspDdp1ARNoUBYFZUa?=
 =?us-ascii?Q?pT+NCE2CKoPslEci5skbFINfk4RphH00bSuD+O+4ZDJB6ToMwyQ1IazxQPaC?=
 =?us-ascii?Q?TfloCAXbvic/N12PHzywL6HzyjTW/kj7qXDtaU2mN1CaHdQkq4vHwwWBA2zZ?=
 =?us-ascii?Q?ZCk3YSLb9ncD3uy8S1JT60VXhYeYs8l2F5xfG6Gof2bF4reUjOkgzZIA6ECd?=
 =?us-ascii?Q?8eRo7YpDMxJr+fcTUfN55hSe7CXWw6Fxn+LjZai9tJg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b07d013c-43a7-4464-bb46-08d8b97a4575
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 17:23:27.4660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ATpZjZoswFubjeg1ahf80Gy4LNpGMuq4p1SSaoD00nxiHEQCFIVD3jcc9vK+mZz/A7rhvl3tySjsTKao12ZYQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR17MB0991
X-TM-SNTS-SMTP: C28AD4038357781D2383312D57602D79E51647FAB2B7337E2154B86B66DAE0262002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25914.001
X-TM-AS-Result: No--0.010-7.0-31-10
X-imss-scan-details: No--0.010-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25914.001
X-TMASE-Result: 10--0.009700-10.000000
X-TMASE-MatchedRID: uc5cNCUKFYqYizZS4XBb39WxbZgaqhS0XGjQf7uckKvAJMh4mAwEG0/T
        IrLQ9Peu+PIDJm8nMt1aoQEg7IZiKbVdhtJxXnUIfJy8LojR0khLXPA26IG0hN9RlPzeVuQQhqJ
        xi9IzezKQ4SVxasmmgbBn8A2CciYo0N7DjAdxZNQmAvD9QfRqyuTCMddcL/gjymsk/wUE4hrAXW
        GZ8uxEzvYHSPi19GdptEoay9K4dYmW4OQeCUNoQC+t66KGtpg7wZkwW8Om7l0zKPNMJt1cItOJD
        ukJ6FgKPiNrAzfNmmmuVcedRt77E9vQudwJa1UEbiWMdLprM/mbjP55bWdtQcixCjPGQhvOQwym
        txuJ6y0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFAssert PHY reset at the end of phy_probe(), for PHYs bearing the
PHY_RST_AFTER_PROBE flag. For FEC-based devices this ensures that PHYs are
always in reset or power-down whenever the REF_CLK is turned off.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/phy_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 13bae0ce31b8..322f569a1162 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2902,7 +2902,7 @@ static int phy_probe(struct device *dev)
=20
 out:
 	/* Assert the reset signal */
-	if (err)
+	if (err || phydev->drv->flags & PHY_RST_AFTER_PROBE)
 		phy_device_reset(phydev, 1);
=20
 	mutex_unlock(&phydev->lock);
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

