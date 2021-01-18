Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637892FA6F7
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406739AbhARRB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:01:59 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10501 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406846AbhARRBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:01:16 -0500
Received: from mail2.eaton.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAEC18C147;
        Mon, 18 Jan 2021 12:00:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610989231;
        bh=Wfl7az0IjmRSFbaXPIsXLs/wG0ywPClq20N12qCXeMA=; h=From:To:Date;
        b=RdGkvfEdAzVMaf9ryFL9zemRuYuvJjjvkc0I9tR22QDC/brBgSrv2Mhbk9lwXTeVx
         meKoYIzVrTdD/Ba/HHW+McPTCN/DigBo3HnaayswwjNKydx+MRuzN5AKWy+k8ue0Qj
         7pEQw72X4srdVFPX7QnJKh3kCWg1yAaeUZesdPtJUAJRz0UWSbVEQkjjUfYM81TFra
         D7YNzwa5M2p5uZUJbCnpu7mJa8wD16ZPtKqI2W+3Sl1uNCuFDG1fH7yK6tQOzkCm6B
         HFuT7dHjJLD3D8U/6m9A8TMGlzzypg6MBeX08qHHyps6flpPzPK5MJrbGisqpWZeLK
         fzKz9jBOgVINA==
Received: from mail2.eaton.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C42F28C12C;
        Mon, 18 Jan 2021 12:00:30 -0500 (EST)
Received: from LOUTCSGWY01.napa.ad.etn.com (loutcsgwy01.napa.ad.etn.com [151.110.126.83])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 12:00:30 -0500 (EST)
Received: from USSTCSHYB01.napa.ad.etn.com (151.110.40.171) by
 LOUTCSGWY01.napa.ad.etn.com (151.110.126.83) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 12:00:30 -0500
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 USSTCSHYB01.napa.ad.etn.com (151.110.40.171) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 12:00:26 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 18 Jan 2021 12:00:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuDRh5ffXMGs5qNulw08UFVu8ORI7vLmbtocX9Pmj8mb2GNvKbQmAZmhd6QKGx67icaJkBVcDBGHHNnV06kD82s2Ro2oTrmEVnbx/Ff0Mn4sJ7oguqWzC+fuWTxykXb7e+4oxTyKxmHuAgMXS6hv6sIeJDoZVJb2t9WtdeMAk2RpDsZBzQkDfDE1h3m11kQu6cOgryNWUSHarCcddmOkxCAVav55ynNUJZFn4MkZI3RfqRvxwSR1EPyCYDwNAR934p14lD2UZqlF35kxdnsmWTkoMdEF9yfCkcn0fofkA3gJ4G6pO3WwvC1PqK/ko3Hs54AEaRjlaVgwlIaJ5yvGgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvyEeRB569n072uKsipjRBZo+DE9Wwk4ybLOkZehvHA=;
 b=UNic4Nf6Egiv5zmxj+IhaHnGwIjBtsejq40wvzEmE1xQkkEACctAXmT7jlRU37esY/4EJdpDu0AmA+VoZH4R86zV6XSeVtPqfVLSE2fcHc2D4QJP9iuY76ND4isDaXu3ggC5AEkt1IswhFDTVW8b87oQyGfgGhP3if3fNSvqJT0Q7Q84zyDTxYQYLwRtLw81BsuIT8Lsg6MHunTVAVI9rpbKjKWeCo/TQBIv1mtq/lzdzz2w8eWFaY4MGwThdiCFD76/d+/oUUZ9nc4mMBaI3cZv1MIfRu9N9kBrBzmi2hV1Lbhy5Q6IT6RammosqJSziW3blebHYhDt4Er6lGpqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvyEeRB569n072uKsipjRBZo+DE9Wwk4ybLOkZehvHA=;
 b=UPNnYuMKW/pPOCt1+SwmbXphay0TuezX3hrSJCK5u6Tsr/ql0FQI7bNiKsIQyYNZVkWeotFDACH0JRWiXkgQKZWEgeATTmjwJ/JPtGGQfhYWvIyuNxs1M9Uq8v/fw5eXTayIgCa15l5CkKPr0xk8Y9m0J+b3TbR4KEpacBfmtTk=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR1701MB1743.namprd17.prod.outlook.com (2603:10b6:301:1b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 17:00:25 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 17:00:25 +0000
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
Subject: [PATCH v4 net-next 4/5] net: phy: Remove phy_reset_after_clk_enable()
Thread-Topic: [PATCH v4 net-next 4/5] net: phy: Remove
 phy_reset_after_clk_enable()
Thread-Index: Adbtu2iZYlc0mmDjSfO1ff6/QIbmSA==
Date:   Mon, 18 Jan 2021 17:00:25 +0000
Message-ID: <MW4PR17MB4243EC916C62F0C8FB5D50AFDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a525ad1-5580-4968-83c4-08d8bbd28cc4
x-ms-traffictypediagnostic: MWHPR1701MB1743:
x-microsoft-antispam-prvs: <MWHPR1701MB1743E18F2FF1E645D961AF57DFA40@MWHPR1701MB1743.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /nUbiHdsek5mUCltDbgVRykdR7zRmYYLEzR9+dtoEdM9aa5O3FX03XX9gVxwQFqNkG+l2CCznM1Gcn1QxS8n07viZ3bGF4NNK0jwTNviQKAV6ZkKjd2QhuQwoojS8rLxe1QX96kOoOTvcEm6HU31lgsexlHnZWCB/CPUdoj+TL+UqTSFjKlaQXehyfNctM6wti2mPRjDwP3pPWbzckjfBzfdm5A3L9G1de92edXP6zkF9x17qr+FeQQYZbbDc1sVl+lpaWa0+FhaX4Qgt3HXgfQHT1Y9q7M8DIKB0tlabK+uz2Pzj+Fd9JRsG5Hn9gt/9w+577wFEkPDx9nFPYXpwg4vVlEpFK8WfzVf37SazlN/EY2ocaYEP98NWYJjmiuS+lfYWYmDo4BsA36fDBf7r+ODMSKOX/oOKWkiy4OYJaKdLPHfAAkm2A004PmZzqeDFsijamX/GZ5JpdzkQ+4z+heZvDnUMsRHOCE2yjh1zllUFv0iFcQnmtCOHPHYoAreksqsbxo4mqMyhv7+SnCQ20teVCwaUdCn9KDKNg9QrzAmwzUi8G4E5J+9m9EwWcv6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(39860400002)(346002)(2906002)(33656002)(86362001)(110136005)(7696005)(66556008)(55016002)(186003)(921005)(9686003)(66476007)(8676002)(5660300002)(71200400001)(478600001)(26005)(83380400001)(52536014)(66946007)(6506007)(7416002)(64756008)(66446008)(8936002)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rAc/v2D4F48OIPD8RIdfsR8xnCr89Te5bdkFX8jGc/DrIEilEvyHQc0/UzB0?=
 =?us-ascii?Q?/mdxtI0tTnU5G/AxDKkM0O+nyhh2o4ohBmFszD2QpiB1/Vfiek6TColvpUUs?=
 =?us-ascii?Q?SumpfXgUJmGh5Kyur2FX5P0l+jLsEKIrT1TvVkfGlONptrr9DfbHbpz6w28c?=
 =?us-ascii?Q?QgI6BI7bsfzFuTS9xwaE9MgVWBoqa6sogU6N+ga138c0z7nOAt1pWVb7f7rW?=
 =?us-ascii?Q?1xXimmQ53PU83coN8McTX7Any8OrKwF65fbIsbKmLKGvfHDzdJFlLjvbmrBW?=
 =?us-ascii?Q?ANanFu9XF7aliM4S99+mAMLRNzppELZbGb2Qyj84a70SQuo984CupspfpfvM?=
 =?us-ascii?Q?kUTWSToj6hmOEhi1DnU+MkUaJpcWLLnMH0+C5w9kBcTAGz7YWL2H5BFym6xJ?=
 =?us-ascii?Q?Bu8Bk5jeVAFnGnplRIHd53MhsLtdK0oZpkkdRlnwy2OrgN//E/VORvaCtLXw?=
 =?us-ascii?Q?YBAYLo5pqHANZt0bZhiq4boYaoin7zHVkEGtRmKAB8TNgaBNqw00KvnaiUVY?=
 =?us-ascii?Q?u/d7LxRQ1wwilXqPgU/IUPo0f4fp/+LVeT0K/J5dkVsN2ZkAXVXhusz2mAdH?=
 =?us-ascii?Q?nN/FNsbuwYIL1UZoxoX1smHB0p7Lpf5O9TcuRmAnzlVL952huyJ4iOyaVkPA?=
 =?us-ascii?Q?cPQ1MhuDTP7Fu6mPiMTz+wTBaNo0/dtfHbCAhXMsw49jzH41sOD0jdK34m47?=
 =?us-ascii?Q?dWkmqX8+n6Bpl4HXNuRtw97rV/RnnklLeGtHRqov31kh/T60kJUseG3DBh0h?=
 =?us-ascii?Q?N1nFiflKdtvx7EJ6vDWy6Izh4pyaIfkz5Vzq7QMmKe+Bx2e0Mr6z/KoaGqT3?=
 =?us-ascii?Q?/T6b9y6b3NPjUDN31p9dVO0NUsfjGQaoh2XlSMaGPI53DrrxPyd3fJU3mrP5?=
 =?us-ascii?Q?Dtn8XPf/a8X8GNEjmfED4nBq/+18KJoC32imdCJaF1TYZ/M8AY1B/bzZXBVC?=
 =?us-ascii?Q?wWYUR9x6UIZW5/1ULW5TC6weALeUS8K3t8rsFL2PCBs=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a525ad1-5580-4968-83c4-08d8bbd28cc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 17:00:25.0965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mPhzwZIeLLKskXG0XkfCHc3LAqTorXfZRqBFRmlimd5tuzmCfw5LvXyVq3e5+DMYbBt1KTjtYDoVjLaibST3Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1701MB1743
X-TM-SNTS-SMTP: D9C0442D3C3A6084335C649A1CC9C1E1F27096DCB6CBE0D8986E06E8A3B533292002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.001
X-TM-AS-Result: No--1.233-7.0-31-10
X-imss-scan-details: No--1.233-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.001
X-TMASE-Result: 10--1.233400-10.000000
X-TMASE-MatchedRID: 7ndSsHxpBXKYizZS4XBb39WxbZgaqhS0ghehpAfYfg9tpkxrR+BG1qZs
        dSGzN6SbpdiAaXc1d4NYV++JgP70OCdHkp1v4jBLqJSK+HSPY+9lRzZAkKRGDVIxScKXZnK0CaW
        L02HP50V8bO6hWfRWzo9CL1e45ag4BXQM4inN7emL6q5RsNhv5A73P4/aDCIFKBVvFbsUM5Uo7E
        FGIwwE73wuf8NyavnbqMZ1ZfogWkFUIx36SrQFlaqHmm/V4M/PqWaMWrxmYY47fXZ8qCOriZqZC
        YSsFJCidgkRR8OiM/9YF3qW3Je6+zR3PUmMN/76WPfqURNxhMTCFJtK1ScYFoR5y1DPwtmhSaQh
        WYgn60DuqcqTg84wmk6o0TuJt/H9Xymv1UCOhHOQpNENucTvLVyQCnflp4PmEr8EAKxXM1y1rnR
        +ZHUF+XRIPNHXw7ge4hgG5y/uHEJ+3BndfXUhXQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFExtraneous PHY reset is not needed if the PHY is kept in reset whe=
n the
REF_CLK is turned off, so remove phy_reset_after_clk_enable() which is not
used anymore.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/phy_device.c | 24 ------------------------
 include/linux/phy.h          |  1 -
 2 files changed, 25 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index bbf794f0935a..bc3110aca61a 100644
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
index 4bbc7a06235c..3f84bbd307fa 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1395,7 +1395,6 @@ int phy_speed_down(struct phy_device *phydev, bool sy=
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

