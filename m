Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67C22F8250
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbhAOR2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:28:35 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10401 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732468AbhAOR2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 12:28:33 -0500
Received: from mail2.eaton.com (loutcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D78E7A0F9;
        Fri, 15 Jan 2021 12:20:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610731245;
        bh=fhIJd3B+xOEYdEqp5yPxGQMBVKXHFeJMJcekrU5Sc2w=; h=From:To:Date;
        b=aYPkmW6MBBn7/DOS4K73804+sHjALTOs/Az5Mj/MB0lBPNTV9pscgrHK1dDZ75s03
         5jBkW/lCDld43KpL2F0dqMT1P+zOhhfze81xgmD79Uq5VvB5RnhoAmgBI+a6zaKgi9
         Rg5yXAZB/YPVtZ5zR4gZsd0pqc9mi8FT+eyQHnl9d1tY4n0dQbYbSeb2rXOgIwqhiK
         dEtrLuMj3QEdChmvbVsWXrF86s/UAMeMsAaLFwvGgI0ejz9jAylId3YgGOzEI/ceAv
         E5p7SvST2XQXpl8DCDihdoJ/r+5mp2++hHQwKnhDXqwlMag7g/bo2YbFo8xAS/Ubu7
         m4lUWY1kWy1bA==
Received: from mail2.eaton.com (loutcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 248CF7A0A4;
        Fri, 15 Jan 2021 12:20:45 -0500 (EST)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Fri, 15 Jan 2021 12:20:45 -0500 (EST)
Received: from SIMTCSHUB03.napa.ad.etn.com (151.110.40.176) by
 SIMTCSGWY03.napa.ad.etn.com (151.110.126.189) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Fri, 15 Jan 2021 12:20:44 -0500
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 SIMTCSHUB03.napa.ad.etn.com (151.110.40.176) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 Jan 2021 12:20:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Fri, 15 Jan 2021 12:20:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl0WFtARb3FbXUsIQyP2jWLNyWJq7v5oEMZl3FYBOF4bqWotI4foGgdNbSLrhpokaiuEgKm0Dj3GrRt6iTo7ev1UpIj6LIUnYOSlxlin29p7MKofmix51fg5eUgkVVh0Bv1WRbPkWxypD+lPEkt1fG8XbuxCk14TdC1/0TWZTEnYx8W3LvGavyj6Oe74Ki+fhTaWCOiWi91rnqNP2apmE0BEl2C9OeLso2vQuZWSG/h4HkbP0zyEg/c0+Xn0ZK3qEJ1xCI+S44J4WINKiOomUmzoUYVwjPoEGgVUfZkdnysxkh22Qw+vPf4ASCGYAs5PVes/rCBtQLkq02gYSR+MiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCHsSYGDBoWMCwBAbRQhKGtd3vHDGX3kzLlmlA16Njs=;
 b=ASVmV0B+k6CLEStk5ScDFUXi0X8UXcEeaCUUS6PngX58eAaFEbFHVSz0mlne07KirOaKTofHdpqttdgyQm97dhF+SAsYVI4v/aRnodtaYchz/LQBi4r8aA6RkS+dsWS+57a3TiYQSjmW/RdmNy6FVihIzRha+8iQRQ5Cbjk1n2Bya/RtgHa4O7C+gMAsXTjrBXTyGRH5wXZ0HfFldmkpVvxkROtzTNU/DTBDCFU9JKPo9ZQuh6yjcm0kUUhVDEn6bwLFHJDZCLmb/pIt0DSOBLW7DChpWLZzGy+bOz4l2IqeIVP+5+5y60Br+nKKL5W7329kxEGTZ8fTrG5mb94k7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCHsSYGDBoWMCwBAbRQhKGtd3vHDGX3kzLlmlA16Njs=;
 b=nNtm0VzfyiVgvBk7NrZro/on9jLV0RWr6HPNxgmnq75iWXYpQ47UhsuevAHttKehs1AqHmy0UkYG0jf9ZvkqT7oWpc9CUhBtJ8P/xM3tGp0Lkdz9Ou/r3fCBvRBK+qkto8BFbd9X9sFexthcs2MFGGlphky0dD66LSXlDIMrM3Q=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MW4PR17MB4419.namprd17.prod.outlook.com (2603:10b6:303:66::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 17:20:42 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.012; Fri, 15 Jan 2021
 17:20:42 +0000
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
Subject: Subject: [PATCH v3 net-next 1/4] net:fec: Remove PHY reset in
 fec_main.c
Thread-Topic: Subject: [PATCH v3 net-next 1/4] net:fec: Remove PHY reset in
 fec_main.c
Thread-Index: AdbrYr7++CWT+FRPTZSQKT4jgjdJOw==
Date:   Fri, 15 Jan 2021 17:20:42 +0000
Message-ID: <MW4PR17MB4243A33292249C6E58AF7922DFA70@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c021d11-2a87-4052-0917-08d8b979e334
x-ms-traffictypediagnostic: MW4PR17MB4419:
x-microsoft-antispam-prvs: <MW4PR17MB4419B28DA864A5CDA3641A51DFA70@MW4PR17MB4419.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s4AXs5AYzPJ/RQkHgHWdR3X2CVxhGJHa+RWJaL4ktoG1pDAYRtIEuoCXHeSdT1L0r9nLrvbRVvH1yZW7a2xX+L0CWbNhasQSUBM6wJo648FjOJ2ehN+T93ARfmU8OR7+YRoLnkWAXJVIs4W3sqGsrtCb7q4KsZQoIFiMCNlc/al7EL3X4t84LiCTCcOqhmt0J0lENLdjPTKKGs4kUQnE0d6tYiMG23JaEST5rAhrhzjSCNP6RtcWAfNSLnTQmkom8TAQKEqeNeFEjX8YIPNU4wRIfNCt6pTX2fznqmYzAaBVTozxNdxPaMRvJ8Bdf4DMuOtvxy+wsusgbfLdt9rNt5lXeewJ8ORmvYD2TtgqvSCjmHO2NVPutQxTvYE6/ZkUN/MQ6xwHWYo02QDJBTSTbekO6qLDXZ2dsRoCTOx4+tG7Q5yT0xWEBmEP4wm3LyPF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(396003)(376002)(366004)(64756008)(66556008)(5660300002)(66946007)(66476007)(66446008)(76116006)(52536014)(8676002)(110136005)(83380400001)(921005)(7416002)(9686003)(71200400001)(6506007)(55016002)(478600001)(26005)(186003)(86362001)(316002)(8936002)(2906002)(33656002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Toj8dEYABGAxhhQlIT2s1Fp2Hxwtf8PFGbcI212XPtJhQvvYEQ3Y3dVp6D5n?=
 =?us-ascii?Q?zDpG4N+97MNg7ff5smtiK/WICuPDZXsO02WcSW5L61hffbWtm/gx2CUfw+5t?=
 =?us-ascii?Q?qMzLXvBcPVQx8yyTdsXaX8/Is4CGoEors32OfCTq//C9gc0HdF8Q/Prbh7rp?=
 =?us-ascii?Q?AltuMyYAVyUOSJrx3Q8ed3zN3gMaiD0qyBl7/W/HXIJwXWU/pz9RPm4hsv5D?=
 =?us-ascii?Q?HvedsGYtrwaVFArLnoHnEWxZFCRYaIYhBntLDIMpmfX14eZAmy45Gy7DIj0m?=
 =?us-ascii?Q?79kP2PZGAICPvEFNBJWr1Pit5aaQDt4Pd4lFYv17vSMgcw3J+ciw0ljWtCyW?=
 =?us-ascii?Q?Bnw6Wotj8oJH4oFjUiqS9ILm6UYHyeoac+nN3e1vX56MGTD0/HfVqd0dn5dW?=
 =?us-ascii?Q?4vFxoL1nNrj09vztzNJR3m8fhdPsBxHZY8hA6arP0CpjRilfPWdiTWjVvP6D?=
 =?us-ascii?Q?W6/zClLSF/9sWiJ9xs7dqNW6dv57uj2YE/gNGZrus7lVCu0lvATon8KB5+nF?=
 =?us-ascii?Q?+ldRAwXaMCJNSgywcGHeaX3wkKeXLK6UIwa9AVRh2Of0dkiTPyaSPNi8TRGp?=
 =?us-ascii?Q?v8xB2jtGp6Sj4+aPSEd05HDFPmD+p5VveDcKev0LbHAeFAYODdZU9rPubXkN?=
 =?us-ascii?Q?3aiMxo8inwvuM8ZMCLiiIFTViVQALCuHRqvZ8M901jVNYGLjWaFGsIjn/Tig?=
 =?us-ascii?Q?cZWt9FrYpkoDMX4bGwzmmNFAyWSK17TgR0R6VYBOnKD5QdDmO7+aNTYeQEZQ?=
 =?us-ascii?Q?J2o3Abuo46IM0HAGUG7pMYF6lCiJ+1Gdq0UiZm3RBAzDO1yhD21yYJCr3Fyd?=
 =?us-ascii?Q?wdgA3YNhXXn/gb6YEY+2aMXDk7qlh5UY4S+BtyqarOdGO+7SNt1ZjqvlXjeS?=
 =?us-ascii?Q?GSo0tmaw5sT4NKc9RAS4zHuxm6zKorDearbS1kYc3QxQxresYjyoXBDUTxnp?=
 =?us-ascii?Q?B7ZwMJ5o4fMm2PW3OWEh1MTcmKo3oXQ3RFbUQU2Gbdc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c021d11-2a87-4052-0917-08d8b979e334
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 17:20:42.5252
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ckjHzePIC0Bf9U4o1FOYRBV5Bv7figBPji5oNbwNWwNm1si7/12AbEFmlGx/SgxgJpc4QasWQp2zUeFCLcOpSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR17MB4419
X-TM-SNTS-SMTP: 2E9C080D028A85FF1DD2F820325231D86B9F4140DA0C1F7F19CFC2035070C83C2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25914.001
X-TM-AS-Result: No-3.300-7.0-31-10
X-imss-scan-details: No-3.300-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25914.001
X-TMASE-Result: 10-3.299700-10.000000
X-TMASE-MatchedRID: STqljHqeHoKYizZS4XBb39WxbZgaqhS0SWg+u4ir2NNLxCuBTCXaKv1R
        U7wjeDcU2w9WUtAsFzdYV++JgP70OLwVYOCFOHvZqJSK+HSPY+9lRzZAkKRGDXAal2A1DQmsQBz
        oPKhLasiPqQJ9fQR1zkWeLerpe5E3tV2G0nFedQgHtOpEBhWiFk+crEA4+nhZ8jflxBKMkr4sta
        G2wt1Mam0T4AfKq7lu9dCytzw2Ek5c+NzN6CaS/oS/TV9k6ppAprzcyrz2L10W6M2A15L1QNs8F
        0VcKD1tvudrc9c6d41wRRhxqxsO8nL3NzSyDKLm9Ib/6w+1lWR6LoLL7h2v2qZwleT7xjO5CMkz
        RYtEwm2+AMD0EBGg2n+liOD53f81+gtHj7OwNO0Q+z869mqTM9749Jrx8fKasqAx100+fIn75Xe
        2tnKQTMBLH078rTuq7KWGMIeFrc6JEBFXqtSpcFLN7fT7HZh1x9xhohK+mrDUVKtZoQGNkOcv/7
        VpcmcwrjXJyhLgaI9f0tLknZr0ioz9HzOW7y4iDtw08RUeIIOJNKCbyQlUpEMMprcbiest
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFPHY reset from the FEC driver is not needed if PHY chip is kept in=
 reset
after PHY driver probe, so remove phy_reset_after_clk_enable() and related=
=20
code from fec_main.c.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 40 -----------------------
 1 file changed, 40 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethern=
et/freescale/fec_main.c
index 04f24c66cf36..c9401c758364 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1911,27 +1911,6 @@ static int fec_enet_mdio_write(struct mii_bus *bus, =
int mii_id, int regnum,
 	return ret;
 }
=20
-static void fec_enet_phy_reset_after_clk_enable(struct net_device *ndev)
-{
-	struct fec_enet_private *fep =3D netdev_priv(ndev);
-	struct phy_device *phy_dev =3D ndev->phydev;
-
-	if (phy_dev) {
-		phy_reset_after_clk_enable(phy_dev);
-	} else if (fep->phy_node) {
-		/*
-		 * If the PHY still is not bound to the MAC, but there is
-		 * OF PHY node and a matching PHY device instance already,
-		 * use the OF PHY node to obtain the PHY device instance,
-		 * and then use that PHY device instance when triggering
-		 * the PHY reset.
-		 */
-		phy_dev =3D of_phy_find_device(fep->phy_node);
-		phy_reset_after_clk_enable(phy_dev);
-		put_device(&phy_dev->mdio.dev);
-	}
-}
-
 static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 {
 	struct fec_enet_private *fep =3D netdev_priv(ndev);
@@ -1958,7 +1937,6 @@ static int fec_enet_clk_enable(struct net_device *nde=
v, bool enable)
 		if (ret)
 			goto failed_clk_ref;
=20
-		fec_enet_phy_reset_after_clk_enable(ndev);
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
@@ -2972,7 +2950,6 @@ fec_enet_open(struct net_device *ndev)
 {
 	struct fec_enet_private *fep =3D netdev_priv(ndev);
 	int ret;
-	bool reset_again;
=20
 	ret =3D pm_runtime_resume_and_get(&fep->pdev->dev);
 	if (ret < 0)
@@ -2983,17 +2960,6 @@ fec_enet_open(struct net_device *ndev)
 	if (ret)
 		goto clk_enable;
=20
-	/* During the first fec_enet_open call the PHY isn't probed at this
-	 * point. Therefore the phy_reset_after_clk_enable() call within
-	 * fec_enet_clk_enable() fails. As we need this reset in order to be
-	 * sure the PHY is working correctly we check if we need to reset again
-	 * later when the PHY is probed
-	 */
-	if (ndev->phydev && ndev->phydev->drv)
-		reset_again =3D false;
-	else
-		reset_again =3D true;
-
 	/* I should reset the ring buffers here, but I don't yet know
 	 * a simple way to do that.
 	 */
@@ -3005,12 +2971,6 @@ fec_enet_open(struct net_device *ndev)
 	/* Init MAC prior to mii bus probe */
 	fec_restart(ndev);
=20
-	/* Call phy_reset_after_clk_enable() again if it failed during
-	 * phy_reset_after_clk_enable() before because the PHY wasn't probed.
-	 */
-	if (reset_again)
-		fec_enet_phy_reset_after_clk_enable(ndev);
-
 	/* Probe and connect to PHY when open the interface */
 	ret =3D fec_enet_mii_probe(ndev);
 	if (ret)
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

