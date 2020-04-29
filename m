Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B071BD7D6
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 11:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD2JDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 05:03:38 -0400
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO
        simtcimsva04.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgD2JDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 05:03:38 -0400
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 361C48C0AD;
        Wed, 29 Apr 2020 05:03:37 -0400 (EDT)
Received: from simtcimsva04.etn.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C68A8C0DB;
        Wed, 29 Apr 2020 05:03:37 -0400 (EDT)
Received: from LOUTCSGWY01.napa.ad.etn.com (loutcsgwy01.napa.ad.etn.com [151.110.126.83])
        by simtcimsva04.etn.com (Postfix) with ESMTPS;
        Wed, 29 Apr 2020 05:03:37 -0400 (EDT)
Received: from SIMTCSHUB02.napa.ad.etn.com (151.110.40.175) by
 LOUTCSGWY01.napa.ad.etn.com (151.110.126.83) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 29 Apr 2020 05:03:35 -0400
Received: from USLTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.151) by
 SIMTCSHUB02.napa.ad.etn.com (151.110.40.175) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Wed, 29 Apr 2020 05:03:34 -0400
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.56) by
 hybridmail.eaton.com (151.110.240.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Wed, 29 Apr 2020 05:03:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqrsjqt9U2zr26fm1A8Tzdnzi4gNVLS1gwL1LFUa5MAN8iExoBFzKJUw4iq5OHnwXRrKPNa8GIitLndYKCfrmI2utCDRQWpvgxRZop5QN4wRX7t2LPGDEaHXSCFIMGi1HB/VrLGdkKVy36l83iLoiPBg6BZFfmoMLANSBAbNgAGntWV2bKeQ2J813xbBnVHmPf8veNRzbbt9UtyDxS8JksXEG4wBB4sNkYXFQsSsF1uSY+btKpMD4wDvSn3Ps5LPf+DlkhIa6tYCxh6PnXoSan3B4yrSDUgtrozAHoeEwAgST7PKWTpmwO0gml0RDo+kI/qO9JFrr4H+m/6kv2ErVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/CDzfSYbzX7fjPJFXshj4DB3WTKrnquzQo8ppSVIwg=;
 b=edhzFf8NZ6Es/gZEA7tu3SSGI1s95lnUWV4ra+W0Wy/2TuttCSUXFHZTpmSYFasHk6lcA7kk/ZKd3dXCQuj2Y3H9j9wbOqcq4lIyx6kBu1YzzvzsRf4zzBE2twNL0Po2XlYv33FTqyEqRv0iQhQta3QlIu/MXODVmAScoO9Q9pt2z5tHOXwF/Ej2ggkgmEfu5CLofyxLAeqTldC2QKC/xfk4YXg69kVxHHM2AqICz8nuwWgh+9ozGes+7cW/nkkPmAsbncQWC9U9ciEr+BijXtri8Drs9Ku3s/ACGcYUI2vQkI204iKOJp8pPsXIzjzqjgoItPDoJdAQVSpnyB5LVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/CDzfSYbzX7fjPJFXshj4DB3WTKrnquzQo8ppSVIwg=;
 b=a7HAv5hv/C/pj+FDDTrF+BtppwIwuRXprG8Yo8loecF6p15f34jzQrbJIVf35eEv9aVh4Ew0G+m0UVPLwzOdZg6EI/sJ/WQ+hoNXDWLZY20xtpV7hp8gg1+otWCnAqUWS22v7Ftjd54FiBZ7Br0dHxY/sqlV+ymXzc2l5Kue08w=
Received: from CH2PR17MB3542.namprd17.prod.outlook.com (2603:10b6:610:40::24)
 by CH2PR17MB4008.namprd17.prod.outlook.com (2603:10b6:610:87::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 29 Apr
 2020 09:03:33 +0000
Received: from CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c]) by CH2PR17MB3542.namprd17.prod.outlook.com
 ([fe80::684d:3302:3158:502c%5]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 09:03:33 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: [PATCH 1/2] Revert commit 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Topic: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Thread-Index: AdYeA4i+jkYua/a0S76wXm6HsC2C+Q==
Date:   Wed, 29 Apr 2020 09:03:32 +0000
Message-ID: <CH2PR17MB3542FD48AB01562BF812A948DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [178.39.126.98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2061914b-81dd-4cf7-38d5-08d7ec1c3183
x-ms-traffictypediagnostic: CH2PR17MB4008:
x-ld-processed: d6525c95-b906-431a-b926-e9b51ba43cc4,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR17MB400827230EAB3AAD2BA49892DFAD0@CH2PR17MB4008.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wipl09OOdyvGW0I41mP/Z6Gf96Rmdt64obGzop2qANQuK1Yz2E9NyaTXne0zKi+hclCEAuGtNLVNRhq9E2u0cckjibBeBelgvnz2gQGJRSRaevpONPjHocSYA/hW9Rls7W6mZ+xGgZrmUFoeecclpEjionTDURH+65eKMl07AjiVTKsiB3QAj+gIuitNJA2OsHYHIHf7+MqqNcWpHWyHgJ/mH63GdTSLUvdODH8eAqsojYmw5WcpV71Wd7eNwvTBJjakxUsGWcnOWecJxXTxPjMnbsc1ibVIQE3080jZOBugk1i5DxYflbCikvYLZbFE9vgALCTANsVBjtTwCJZgP6FMhSXxe7G+Qf/s3mPNmMNXWUmQuPxv7ED5s1LcCWE2fL/Wa6WXSlM7qcri5z5G1h+VUX6GQ/mClnpv2yEkkuFRBw2UL6FI4zuW1Sv6NkwLyCQV8RlZfVO3ZEPnEkue3D8hem3OsC20Nxn+LHzDZ2s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3542.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(39850400004)(366004)(136003)(86362001)(52536014)(33656002)(71200400001)(66946007)(7416002)(4326008)(186003)(26005)(2906002)(478600001)(7696005)(55016002)(76116006)(6506007)(5660300002)(9686003)(66476007)(64756008)(8936002)(110136005)(107886003)(316002)(8676002)(66446008)(66556008)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6wCp3Jep8KUbCvdegKS0885VZlT2uIfwSt67m/vFhbzmOIj3CNP5OdSuIdTjUhwsSJrHcpEAJjgrsfM6yYJ0ebAnvdELBaRcvDE9YMi3x64JvUUNrnCnC35uX1rqxCaNyt7j5CMEHFyy6rnlLwERkXWgyjS44fbjeJ8ok/tAtK7G6rJeHILjxdpGpKGr0YJ8Sp8qkLCCglD//fV366d/zN9vth2JJNORNoH120snNvbVIoJjF85gcH6Btc5dXgm46Ppzu1gqFdVUKZPFfar2gENhrgpcPmOtwHs2+eDlfQAGWvxWF0x+Yd2NjOdSgLi0p+s1yyKXk7x2o/UzAHCHVal9bMEbmGN6uHZ+GExd+cd4bWZMfVVHbUmlPjcCAtZ1THNITB4WcI9HluIgv5ytjo4RM9CAln68nKKRN3yLRBQty7iBkQeX4fNmwuOqnsUHZczBkeHueitWRRQrxadZXnqRzv5aTRKjGvnl4ua2lK+M2dU9oHlKH9v5zk7FSjrQdSAzdS4ovwyX42WC4Pdi5cqrEZxP0HOcaZ16J/5HHdeCx8Bf3g297QniPXHTIzm/88uaI95JpJD7NpDP06iBPv/lemQLSvTAyW1moaV0kj8TIkp1dMXggD7ztmWM0HgF2oPr7OYhLg7mLY9PJw88hhRraRCU0dYiMt76lCSFJ8YwDNhed8uSw27kPROG5I22dIgsfKdjqGgAKywQEmES6lSHWCvhBtJKR0WqeiLYJRLOKTsePd9d8YN+76oAXVkFryeUaGfjBhM/ElGYfF1GyBi/bFRobGisSapOG7gEiD0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2061914b-81dd-4cf7-38d5-08d7ec1c3183
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 09:03:32.9217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zhh8nMzCPUpt3pklPPSGk7rW+TEyEvFUacaY66e2Jm5PEchUesBS9C7sMLmBHUtx96ASKM6YxLg0WBcCYryJPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR17MB4008
X-TM-SNTS-SMTP: F8F89B9D58206FC5811B375CFC95291E8C3B97DB363F1FEF09E144276C6B7C5C2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.5.0.1020-25384.005
X-TM-AS-Result: No--10.447-10.0-31-10
X-imss-scan-details: No--10.447-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.5.1020-25384.005
X-TMASE-Result: 10--10.447400-10.000000
X-TMASE-MatchedRID: bNhqr+E3/0QOMO1eHmEbOWPGZojyAoFaPbO0S2sWaK0N+F513KGyq0+m
        MtGpzwaWIVCASiY7MEIUjWDd/Oh+4dtLSbjubp9KM71h0SMVl8IGchEhVwJY3ygVbxW7FDOVSLn
        svWkgyVSDNFCP8LDMfqjpyvZE2YzMJIp5MhAnVvOHZXNSWjgdU+qhuTPUDQDtrNVhQyMnnxKVi6
        IEPauVN91CU2L3uA/PXMiY/iAeOO2M2HjKVoOdNIt6hZFSx91AmiIRKybdHSzNWDA/tkxh//7Iy
        0u8pGd3YAuqIPqt7rKxWWzz2LZKB3EwrsQriQqZyZHnIMmQ+DiNY/pqxovzxSrDA1gYfyhv9sX0
        jj6GDgrd79Rj8Xs8jTH23ywzT5a8IeFIFB+CV+wD2WXLXdz+Adi5W7Rf+s6QSMg2Oe/b8ExJaHl
        JC5ezgDj6kLXfljKxBJUFr+LNTcKeSiDxtQORDYKvnFrZK2UhX4aiKNqC2SPfc2Xd6VJ+ypt+dM
        PP5rY5fjHcmoF0kFQneo8mSRf54mLa2mSXQfrb2oIkXC6Ol0COws79FOIMZ4Fum2PEjqt1bWqU+
        jtUG9Mqtq5d3cxkNQwWxr7XDKH81IK8sJk+VxzzF8sf+OcnvN7JlpYIfngol4/743kGQ+uQk9lp
        hOYkjw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFDescription: This patch reverts commit 1b0a83ac04e3=20
("net: fec: add phy_reset_after_clk_enable() support")
which produces undesirable behavior when PHY interrupts are enabled.

Rationale: the SMSC LAN8720 (and possibly other chips) is known
to require a reset after the external clock is enabled. Calls to
phy_reset_after_clk_enable() in fec_main.c have been introduced in=20
commit 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
to handle the chip reset after enabling the clock.
However, this breaks when interrupts are enabled because
the reset reverts the configuration of the PHY interrupt mask to default
(in addition it also reverts the "energy detect" mode setting).
As a result the driver does not receive the link status change
and other notifications resulting in loss of connectivity.=20

Proposed solution: revert commit 1b0a83ac04e3 and bring the reset=20
before the PHY configuration by adding it to phy_init_hw() [phy_device.c].

Test results: using an iMX28-EVK-based board, these 2 patches successfully
restore network interface functionality when interrupts are enabled.
Tested using both linux-5.4.23 and latest mainline (5.6.0) kernels.

Fixes: 1b0a83ac04e383e3bed21332962b90710fcf2828 ("net: fec: add phy_reset_a=
fter_clk_enable() support")
Signed-off-by: Laurent Badel <laurentbadel@eaton.com>

---
 drivers/net/ethernet/freescale/fec_main.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethern=
et/freescale/fec_main.c
index 23c5fef2f..02b014837 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1918,7 +1918,6 @@ static int fec_enet_clk_enable(struct net_device *nde=
v, bool enable)
 		if (ret)
 			goto failed_clk_ref;
=20
-		phy_reset_after_clk_enable(ndev->phydev);
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
 		if (fep->clk_ptp) {
@@ -2895,7 +2894,6 @@ fec_enet_open(struct net_device *ndev)
 {
 	struct fec_enet_private *fep =3D netdev_priv(ndev);
 	int ret;
-	bool reset_again;
=20
 	ret =3D pm_runtime_get_sync(&fep->pdev->dev);
 	if (ret < 0)
@@ -2906,17 +2904,6 @@ fec_enet_open(struct net_device *ndev)
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
@@ -2933,12 +2920,6 @@ fec_enet_open(struct net_device *ndev)
 	if (ret)
 		goto err_enet_mii_probe;
=20
-	/* Call phy_reset_after_clk_enable() again if it failed during
-	 * phy_reset_after_clk_enable() before because the PHY wasn't probed.
-	 */
-	if (reset_again)
-		phy_reset_after_clk_enable(ndev->phydev);
-
 	if (fep->quirks & FEC_QUIRK_ERR006687)
 		imx6q_cpuidle_fec_irqs_used();
=20
--=20
2.17.1


-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

