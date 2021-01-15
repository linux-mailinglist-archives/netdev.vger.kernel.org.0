Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B840A2F8297
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbhAORcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:32:46 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10500 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbhAORcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 12:32:45 -0500
Received: from mail2.eaton.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13DE711A0BC;
        Fri, 15 Jan 2021 12:21:59 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610731319;
        bh=xGQqUqlz4xWnIHM6q49qdQ52Kx8vzK6HcVkw5TzuEq0=; h=From:To:Date;
        b=QkyFlNiAJ7YCDYamBh4SGWTPVH/xgsLz6/Ht7oPYLc9BiW7jOofjJb6GN/IfnVrQf
         4lN9PG6EbXs0iL5xlRGZ5dwVSH68jlINhjVDNaa5TKZrj1yz+ik7CJxx0aKursQnzi
         EOF7YbjB3rGJVZYRhdKwyCtIuDc0KiOavfvA3moTANgXXizCIo/RhxZ2EaGlVgH3r5
         O71uZELuKGZ55oRFPcqp2mpJKKees+CYZ67pWdqEymvzNSTL5RXodfzAK3gHpwW3/7
         WIERhQJFRlxykM6m2yl/vLgOzNYeL4MksDWBq/TIhpo65iYW1sLJKHh8Fni4n413S4
         iP2qoPDeEGIsw==
Received: from mail2.eaton.com (simtcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECD0911A0B4;
        Fri, 15 Jan 2021 12:21:58 -0500 (EST)
Received: from LOUTCSGWY03.napa.ad.etn.com (loutcsgwy03.napa.ad.etn.com [151.110.126.89])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Fri, 15 Jan 2021 12:21:58 -0500 (EST)
Received: from LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) by
 LOUTCSGWY03.napa.ad.etn.com (151.110.126.89) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:21:58 -0500
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 LOUTCSHUB03.napa.ad.etn.com (151.110.40.76) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:21:58 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Fri, 15 Jan 2021 12:21:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrTJAvqGVXEG90lzz+hwI8hQONa71asfZRaURzxtifQih90q+s3jA9cgSDeDMBrfxjMq+USYYYdtqOfCG75VSaCjzNgE5Nlqs7EX7RMHcWEvBywEA50w9J0E3Rp3wZ4hhhbGR9DCp57uuX20hZAuvJ0dzWW1PF54WykFwmTDIiI6zRW2rEztPQK923CMelpGPSr5LBXkfZrX66bYZ4U8nMiWtYsnosX/cj22kfvbwMATwQyEiOaSxTm/o0p5QJh9hu7c6uUuHiFh0rBy7DrUZ76oIFxHHhxnMr3bLMGTYaAoj/2UgB92oTIY+eGTCFrefXuXWWnQuXSDOeK/MZZ0fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wG5nOcjqH3ImltUuFuXAXz8Gqtooqov5pvPRHWJAJdE=;
 b=OnoVUYGc0msXBugjFncHRp8DXx0/YMfITltQbeVVk/U2l18cVMUYKSotR31GiJbLV2v/9tJEYZK2qWH8yW+YeXvBzyAP7GMR3GguPbAyrio3cKjV2cHWsKfjfXr9vzDadDNokFvplZbfZno9noBt4EnRR1kP6maHVArsfev4oi02xdpUeqlroykNsjds0FYjDOAg6zVBht0DmlEGCfd9OkjDE+tP7NOhLV2CFCVlbP9DQxP9R6s0+x1C1qXPOZkEi7D7PKw57640PJhz0FOwboNB4ANMbGxEAu4HF3h3D1E+y71jZdzfqGEf7tP4is7CHRuM2XEg5Aap7k0g1Yk1Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wG5nOcjqH3ImltUuFuXAXz8Gqtooqov5pvPRHWJAJdE=;
 b=dCKqMR9NrTpb+813tki7IfbeYDeT6Ji6F6gzbwXZTZ/9Spfpgr97uf0XefrmO2MhiehJ2/n2EUV7hLlzqMlm6XUZyN8/5YmBMeMFRg1o7xepMQkgFqmSNj181WDdXlKAiq8AdOJSdIf+1yN2vdb/Bp0Ch5hiZGXxGis1XAB8DKg=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MW4PR17MB4419.namprd17.prod.outlook.com (2603:10b6:303:66::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 17:21:56 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 17:21:56 +0000
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
Subject: Subject: [PATCH v3 net-next 2/4] net:phy: Remove
 phy_reset_after_clk_enable()
Thread-Topic: Subject: [PATCH v3 net-next 2/4] net:phy: Remove
 phy_reset_after_clk_enable()
Thread-Index: AdbrYuuHPfiU7HhNSTChPh/5gUZyqg==
Date:   Fri, 15 Jan 2021 17:21:56 +0000
Message-ID: <MW4PR17MB4243DA09E9168DB5B6675A52DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c6239f9-b1b8-405d-e6f0-08d8b97a0f6b
x-ms-traffictypediagnostic: MW4PR17MB4419:
x-microsoft-antispam-prvs: <MW4PR17MB44198557FD35667479389AF8DFA70@MW4PR17MB4419.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bd/bx+5SKI49UVSxE6rW4lTyV5JdBbBu2RVYKSSnrAMNARUje32hcDNveDga2GQjCfUeH1U5ptoVCqgPy4ftv2GvcJBcUn73Fg8EGc169/X27X51a9wTh9DJMo56UcrTjCLHgQLxjcM6H7n6/NaCfUtmCmA4pynV7DeFTU3rNZq+YJ+OkFZHF/H2Q8xWIIWZRphPryOiWVxY3iOtBhzwMQfVE9SBhGepyvEnJz7bv8NZxHgDt1evVwCgbK23QeGp44kATKdTKpKXfM4BaSjA5m/cmYSEIglH0gnyZYwSPJ0sOHWZ6gToyuYTNS++HVnF3asxq+Yv371ka8yeVtnlMsRjEYOvIhD5vWPWRhuyQ83xPoLa9AGNmU7JVfWH8C9dwbqcq6L5kWvsviqKrIonv60quExfetboTgFJgvq2DXjmPNJS5aQnTXXfE9CKr8XV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(376002)(366004)(64756008)(66556008)(5660300002)(66946007)(66476007)(66446008)(76116006)(52536014)(8676002)(110136005)(83380400001)(921005)(7416002)(9686003)(71200400001)(6506007)(55016002)(478600001)(26005)(186003)(86362001)(316002)(8936002)(2906002)(33656002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TjnGa5h4VIiy14J4YxD5uyyWFidAuD9OLDYqQbudqDfSS58gmXysYnsC1DlZ?=
 =?us-ascii?Q?Ytu3oZ4tizhjmLpBZhl7G2PFOmh7X74TZ7iZBToJZivR1NUAvIIhUTLE9dC2?=
 =?us-ascii?Q?rB+G7gZZW7jyIQyWGrMGlGNcoBtmXrJv7Q+ndn2aw77awj/57veVKiWuL/8P?=
 =?us-ascii?Q?+I3l7N00aWCByeVdZFFDdz4w/d9XclFMFMuAhShrOqCPPyjwRjZUE5WLTtth?=
 =?us-ascii?Q?UZ2GwHr/jOt/YXAk0Aaqio8kKFyyfneXTEJYWtheXeSziJ3cCIr5pTZI2Yh2?=
 =?us-ascii?Q?+zBoiN4DaZym/bUhyWXM767k13SVLRZUkw28n3jIevxOblV4ALPf1KCZpg6y?=
 =?us-ascii?Q?cTm59TBeh9J3kE7D2scqouGFfKCQd3TMWPpLGRTjEjvs7TB5GaYImYiE6PHW?=
 =?us-ascii?Q?cuD/atQON2fBM9cTtyFJHf0P+/uzHW+fIKNwFoWzv64EdEYBt1bZH983bfT5?=
 =?us-ascii?Q?l6+MIxZ3J5OQobZqg+KJTF21utfnJrAHJ4tgobY/a86oVCpHv29TT8ONy95w?=
 =?us-ascii?Q?pMlyoZ+OA0ffSUtjrMPk1WcfHqL1+f4rRUuwCBzbL9Kaj7HoZbkpP0V6hXQS?=
 =?us-ascii?Q?JzEqK+EoAHCE+CqWJ6lzWBPmtqUu4LU+mRvDfnm7dFjwJzP1i7io0iIqNaze?=
 =?us-ascii?Q?ZLq1pPLTZYM6/1Y5zq858YW7vWJRPyVayha1eh+6iu96CKqMle99DVDSvo5p?=
 =?us-ascii?Q?Q2Tcr55z+nbzF4WfBar+sKMdyZnUPxNO1BGjNNBiVSTNAWco4v3zf0E8cf/m?=
 =?us-ascii?Q?6sy3didz9aktV+7MXYDGrEn0T7PKZsIZkJ7hFak0dk09MtxE+OOnA3IY2x5b?=
 =?us-ascii?Q?kCifFgQU3RmChfvn77ZSfYHTTN/yCyFeBP7D91ctHxghLHTP0mwa1kh8fGZe?=
 =?us-ascii?Q?BlltD4yPlneqLgLZOAsQ9LEUU1VA50O2121mpsSvIWBIbcWNcu2xArjlEfF1?=
 =?us-ascii?Q?7wbPq7tPugP4ZZ5VkSLb3+SR7rhYLb6yhzpliRtEpnE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6239f9-b1b8-405d-e6f0-08d8b97a0f6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 17:21:56.7429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KXn84zyGNjrxfth/nq31bEjoBIuBwQ6M37dfZd/VnvChksAod5yG20z8Czpz96cdHNiRTYCFS76AdXVha3SEIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR17MB4419
X-TM-SNTS-SMTP: A3AA7D424CE9DCEA5B39EA78776CD879A68346BA6238F0D89966B23ADEB13F6E2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25914.001
X-TM-AS-Result: No--1.233-7.0-31-10
X-imss-scan-details: No--1.233-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25914.001
X-TMASE-Result: 10--1.233400-10.000000
X-TMASE-MatchedRID: 2AvozN8jT7+YizZS4XBb39WxbZgaqhS0ghehpAfYfg9tpkxrR+BG1qZs
        dSGzN6SbpdiAaXc1d4NYV++JgP70OCdHkp1v4jBLqJSK+HSPY+9lRzZAkKRGDVIxScKXZnK0CaW
        L02HP50V8bO6hWfRWzo9CL1e45ag4BXQM4inN7emL6q5RsNhv5A73P4/aDCIFKBVvFbsUM5Uo7E
        FGIwwE73wuf8NyavnbqMZ1ZfogWkFUIx36SrQFlaqHmm/V4M/PqWaMWrxmYY6gak9AH/Ey6Z4CI
        KY/Hg3AXU/IDt4T4+H6C0ePs7A07fhmFHnZFzVqN7ZN/h6fWu6xybItBysenwOzrg2UIxV2TZWj
        Mfj9NcvijtskpjikCRSodrzlSHLRDNYVgzcAnAGossGysLBVhBToeuCOIF/7eEm2gKYKY0ujMR9
        nDiGnUzrzjM5T1nKt5URqB3Gz4Xjh5kunxtNT9A==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFExtraneous PHY reset is not needed if the PHY is kept in reset whe=
n the
REF_CLK is turned off, so remove phy_reset_after_clk_enable() which is not
needed anymore.=20

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/phy_device.c | 24 ------------------------
 include/linux/phy.h          |  1 -
 2 files changed, 25 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 80c2e646c093..13bae0ce31b8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1798,30 +1798,6 @@ int phy_loopback(struct phy_device *phydev, bool ena=
ble)
 }
 EXPORT_SYMBOL(phy_loopback);
=20
-/**
- * phy_reset_after_clk_enable - perform a PHY reset if needed
- * @phydev: target phy_device struct
- *
- * Description: Some PHYs are known to need a reset after their refclk was
- *   enabled. This function evaluates the flags and perform the reset if i=
t's
- *   needed. Returns < 0 on error, 0 if the phy wasn't reset and 1 if the =
phy
- *   was reset.
- */
-int phy_reset_after_clk_enable(struct phy_device *phydev)
-{
-	if (!phydev || !phydev->drv)
-		return -ENODEV;
-
-	if (phydev->drv->flags & PHY_RST_AFTER_CLK_EN) {
-		phy_device_reset(phydev, 1);
-		phy_device_reset(phydev, 0);
-		return 1;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(phy_reset_after_clk_enable);
-
 /* Generic PHY support and helper functions */
=20
 /**
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9effb511acde..58b4a2d45df9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1390,7 +1390,6 @@ int phy_speed_down(struct phy_device *phydev, bool sy=
nc);
 int phy_speed_up(struct phy_device *phydev);
=20
 int phy_restart_aneg(struct phy_device *phydev);
-int phy_reset_after_clk_enable(struct phy_device *phydev);
=20
 #if IS_ENABLED(CONFIG_PHYLIB)
 int phy_start_cable_test(struct phy_device *phydev,
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

