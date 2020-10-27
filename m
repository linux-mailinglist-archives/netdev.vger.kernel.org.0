Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476EC29CD3D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgJ1BiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:21 -0400
Received: from mail.eaton.com ([192.104.67.6]:10601 "EHLO simtcimsva03.etn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833010AbgJ0X3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:29:45 -0400
Received: from simtcimsva03.etn.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E497EA4128;
        Tue, 27 Oct 2020 19:29:44 -0400 (EDT)
Received: from simtcimsva03.etn.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6997A4126;
        Tue, 27 Oct 2020 19:29:44 -0400 (EDT)
Received: from LOUTCSGWY04.napa.ad.etn.com (loutcsgwy04.napa.ad.etn.com [151.110.126.21])
        by simtcimsva03.etn.com (Postfix) with ESMTPS;
        Tue, 27 Oct 2020 19:29:44 -0400 (EDT)
Received: from USSTCSHYB02.napa.ad.etn.com (151.110.40.172) by
 LOUTCSGWY04.napa.ad.etn.com (151.110.126.21) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Tue, 27 Oct 2020 19:29:44 -0400
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 USSTCSHYB02.napa.ad.etn.com (151.110.40.172) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Tue, 27 Oct 2020 19:29:44 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Tue, 27 Oct 2020 19:29:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYfqraKMFv8OEl0FrO55zq4KyEb+mLE9T0uKdXVklc3TZV9fnG6m0nqZEajGAZVKK64bfMRzHcuuCd1ljBY556Egd7yPfGGSUpprn+KZ/HGZljuE4p4OxzQZvlI6YOAa0HNJGAd5UwGyurTFKm/aQUITB+XLDqDW/pckengYqTXRoH5BFTaW+cuhVF0sml0cpGTwenpsqIKfHxQar1Q+yY7E6kNRMJZP/6pYr+4jaLPNjk9Q0V3Zbk2+7bHy8pOHim0UqVunuiydkLU8Q2l4L+MirnNAa0Fes7lwoY0/jxDTEJ0JK97nzaBNhm6t1GTmv56mFW+PvIUt2KSnI/L2Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3O2CLcE3xK6RFlgP2CUKze4E2Xi6wiVspst8zrUrms=;
 b=cux/uvzPfDlOCXLDTzZYnt3/nFSFaT3LnqAZix9xDCD4ULsVwX3ILgUBJJoyYfAo9SJAvtBH6nVoTvsWhtbtsFkOW1Gm2gnhmMpmgn+SYi9gALLnakUYFhmdb2FyX2mKjl4+FbnQgXGNSA3yLq9ZLlkKfOTbioZizsXnJ3UZU3LnAsXlPZHwCvZ90gwtr1uj6YuFMAL/h5pPhuDEW9MVC2dfGOA617AKKtO/SniLebV5f8HPMX8HcZbir5hk/IVvup8CezZstDapcUDE7IGrmyP32+l7+I1ZC4MYDszRS9yJu+hWJ/d+Kt2F9uV7KN5ID7kCedxjl5s1pL87q9Oa+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3O2CLcE3xK6RFlgP2CUKze4E2Xi6wiVspst8zrUrms=;
 b=VxCwxAoLBhArqN1LKqONPdTPBksxqBLvWISZ28v4Q/xcDHBu7pazx7LP5IXadttMwHdGvL9l7WPLLKWnAf6e2bWmZTEI7qRtmNOZYhevY7dWxA+4p95diEHjLRkCgPywj8zqFCQDT9JS3X/CdjO3mk63j+XCa6Vtf25CUmpVa0o=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR17MB1942.namprd17.prod.outlook.com
 (2603:10b6:903:94::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Tue, 27 Oct
 2020 23:29:42 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 23:29:42 +0000
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
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: [PATCH 4/4] net:phy: fix phy_reset_after_clk_enable()
Thread-Topic: [PATCH 4/4] net:phy: fix phy_reset_after_clk_enable()
Thread-Index: AdasuQkOukfiBTpdRwSD+B+Lawlh0Q==
Date:   Tue, 27 Oct 2020 23:29:42 +0000
Message-ID: <CY4PR1701MB18784D5BA799B00DB3B722CEDF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 080c9694-12fb-4159-26fc-08d87ad02eba
x-ms-traffictypediagnostic: CY4PR17MB1942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR17MB1942CAE0B5A5B1E0C41DF189DF160@CY4PR17MB1942.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e7nFdnVw0d2RuTfcjDeXr85b5mh5KSJ4VpP/gh8CbHWyKKp1yY0g46EW3QTuBPIRmYX419aMZ2qYFib/xL+3yI3wGNm8SX4cHKGJ2ckqaYU7lwSFNrj1Jzpwp6dkJ/0XfUxgHBGj7vN3sxyGI/CCGZ6s9Vp1gi2KHi/UCBmFOXYYkyuk8fd3ktJK6SqIRdGlX8ZcZZoULyBcRdrewcXuAmYKXa/dAQTLylCO+p/k3TF78K7jDjTYZLTsPCv/bLOTl3gQlQoJGbXod8gRgQaNsCbW9PsQYLh14fQBIpop0tCGW/4dyXLZ5BVwhg6IZeYsiMdT23E0n6FLecg3vAJfWW8lTLieCfma/d7TV3LyDYdwqVAW+aiIxXM3Eo+JeMZ6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(6506007)(8676002)(8936002)(107886003)(9686003)(2906002)(86362001)(4326008)(64756008)(66946007)(33656002)(478600001)(52536014)(66476007)(76116006)(66556008)(5660300002)(66446008)(71200400001)(316002)(186003)(26005)(110136005)(7696005)(55016002)(83380400001)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: TdztZJtOTNgd5tHiQ4JFAqY3YsBr1uoL+W+36C0FL16qNHdXPBTRX+v84oFir8ip/NDNvvc6GlBYeeG+LoZA7oEfSP8HiDsMv5VQOkND2inbv3G67qUnBixREAme11Z2ZnWc60raE/mCOleNpVmb7EPhE9Rewy66DFICJYtVqnCP1T5Hz8g8R4zUWxvConNS7DfdaY3KhI5F+YLFiU5JTCTB30CfUmGFMtfyBhmqEToaal8cGYYPd//9iy1dAiG/OjPSngBQz/lfc+XLmOYWtKMVvIgSuwBHyZdvYYKRAq97TJvcLIxMYGAV2c0YIq46rvPBmnJ1gBD3SanbrUDauWK/vUDSwPsPDHqFA6XnsXcCyCX7OWZmUzdvdTEkxLhhIeNFZfps0K8tUkUaIu+NsQMJjO809yhLDhUXh7K1k7TcS7ltDx45AIA4D8C2x7bNUxD01skzed3U/AfEjWWIhwV5KnC6mu6h0EHOikQfsMRHxjawYcAxcZPKD5bqNCn4Eepd0uo5VyjwdAfw1xfWh4d2RIzorTUVwclLQDpL0aauEFbdoQ6yhHjuOfne8QdyvSWTWOM9NTs1qp8+f1yNG2ZOR2msmo08ocYBxRad/YAcWSYYPUObrUXpxGZzp1TweE4zzewbyQBzCbyCmIkhFQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080c9694-12fb-4159-26fc-08d87ad02eba
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 23:29:42.7903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RXeuFQDozkSb+/O+Pz6h6l6SfL48nLFY2kS3tBNX/bG/do70UDJ9el00RhvfsaD+m/3PMP6RWpWeXp4D/uXpmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR17MB1942
X-TM-SNTS-SMTP: 289FF318D6D2C0E72DDC84C4BF19B98D7AB02B8D2BD3F335519A2FEAD889CDBA2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25752.003
X-TM-AS-Result: No--1.462-10.0-31-10
X-imss-scan-details: No--1.462-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25752.003
X-TMASE-Result: 10--1.461600-10.000000
X-TMASE-MatchedRID: VIUqeHku7VWYizZS4XBb35VRzPxemJL0APiR4btCEeYd0WOKRkwsh4JV
        W4oTDi/+9Xs2dZbNGMQvaz8LO7iprs66BgIQlQw1KrDHzH6zmUVDfut2Lc1Yh46/j5xrRs7TbBU
        Wr0rJkZaAm9VaUn5RP3iCTLyLchkE9rqf24A6kyuKYdYQLbymTUtc8DbogbSE31GU/N5W5BAwL8
        r97br5Dfm0VF/d5QzVPUUtABYMZ11AjTccdWiAVc36paW7ZnFoVaIFkbBGkf56pt1oU+C/pPsYG
        dcqzBoA5TZfzvOelefkwjHXXC/4I8ZW5ai5WKly6aDim3tCWcLL/GO+jGolvn47BUdXTX5TP0ny
        Gx5fRCrA0HChDTm8BPIlq2CU017g75M+3u/5d1OqKgBXRKikvBZhzFlLECqlp5DFxO/tuzWUSSJ
        PERKCCG1G0sdA2yd47FHW4PQA8ke6rLuaBPjT2g==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFSubject: [PATCH 4/4] net:phy: fix phy_reset_after_clk_enable()

Description: Resetting PHY chip during operation has the effect of
reverting all configuration registers to default. Therefore,
fully re-configure the PHY after a reset.

Also, avoid resetting the PHY if the reset is already asserted,
as this would deassert the reset which might be unexpected for
the entity that previously asserted it.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/phy_device.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5dab6be6fc38..85678b1600c0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1801,7 +1801,7 @@ int phy_loopback(struct phy_device *phydev, bool enab=
le)
 EXPORT_SYMBOL(phy_loopback);

 /**
- * phy_reset_after_clk_enable - perform a PHY reset if needed
+ * phy_reset_after_clk_enable - perform a PHY reset if needed and reconfig=
ure
  * @phydev: target phy_device struct
  *
  * Description: Some PHYs are known to need a reset after their refclk was
@@ -1811,15 +1811,29 @@ EXPORT_SYMBOL(phy_loopback);
  */
 int phy_reset_after_clk_enable(struct phy_device *phydev)
 {
+	int ret;
+
 	if (!phydev || !phydev->drv)
 		return -ENODEV;

-	if (phydev->drv->flags & PHY_RST_AFTER_CLK_EN) {
+	if ((phydev->drv->flags & PHY_RST_AFTER_CLK_EN) &&
+	    !phy_device_reset_status(phydev)) {
+
 		phy_device_reset(phydev, 1);
-		phy_device_reset(phydev, 0);
+		/* phy_init_hw will bring the phy out of reset
+		 * and run its config_init method.
+		 */
+		ret =3D phy_init_hw(phydev);
+		if (ret < 0)
+			return ret;
+
+		/* re-configure interrupts if needed */
+		if (phydev->interrupts =3D=3D PHY_INTERRUPT_ENABLED) {
+			phy_free_interrupt(phydev);
+			phy_request_interrupt(phydev);
+		}
 		return 1;
 	}
-
 	return 0;
 }
 EXPORT_SYMBOL(phy_reset_after_clk_enable);
--
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

