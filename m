Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9937F2FA6F3
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406481AbhARRBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:01:48 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10600 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406113AbhARRAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:00:34 -0500
Received: from mail2.eaton.com (loutcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CF56F813D;
        Mon, 18 Jan 2021 11:59:50 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610989190;
        bh=FR7u+5nV9XNuk8cwggzwN1PRWimaL55RRnOCijxG6jQ=; h=From:To:Date;
        b=iX9PFj6DC9osudTgY58J95xoCfa9FEUXCFGq2w7NJh/QYWF4F/JXOXrTc20g02sTj
         oCfggkmsNc4c62bg7YtLXxNlcQrqYNVzrQc4V9dydTaj1++qkTcSg3fdsIMe6ozO1X
         ywyR+cUj8Np+0X3/6LgkScns8hIs9fNBOA0JaDlfXrSUK4sTHPHfCqDXfk3jwIhQOX
         EvHQhGulYsKWHGqDI3G6GZdHbtConVerxSvjbq8CUImNEynIprmgXPqvQgtRGG4AJF
         +GNjs3GSfT7IbQX1ufwRfRaUt7XHHV82PshwnDGOFy1JmZrNV+FTe4j5yjF62cylUo
         dCUquEx2NeE+A==
Received: from mail2.eaton.com (loutcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5A35F80EE;
        Mon, 18 Jan 2021 11:59:49 -0500 (EST)
Received: from LOUTCSGWY02.napa.ad.etn.com (loutcsgwy02.napa.ad.etn.com [151.110.126.85])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 11:59:49 -0500 (EST)
Received: from SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) by
 LOUTCSGWY02.napa.ad.etn.com (151.110.126.85) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 11:59:49 -0500
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 11:59:48 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 18 Jan 2021 11:59:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceJKKnKGUHFjPuGHpfo5ikanLW1Nec/0/fRmFk0M2+mZ4u4CAK/Dbko0YFHRRTFL2kbdqZU7TxHOYHJ6mcfRm13woUpc4Y/6btOHqTTx0GxxCl7BJ6ShS3Dta5ab4ezu0ClbZbEwMC6auAGY/SjE8dzmHlOTAMmN13aCgCwn1T2Uk721m7VDARsGpRF4f1MQjlGf/OC4TNtoUngd0JkmfYJSNW0MDfIzpxEgkBW6HDHZ6FVc5oFsk+Rh8JA9bO/6JCdxK09C27oG8zor0/de5n5QHgvsUy5sveqGaa7j5vKC78Th7TJlGWaAqPJcO1aadq8QU4j7Jp39RzJYAOGVtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUOqj+LGriRQgGl74HIaHWUdyEuiNStGskjuPVcp8V8=;
 b=ZYtnwzjGEA7nrXnfncpsZvjw+fr57eDitK/lkReOfsqQBaLbotmaiqJ00SbosnbSXmGncXe/o4bnKgppTrI5oMCT3zB/h5Q8jmz8L6zeLeBcU3xfwzHMFGmBhz9RxZfE9S3S3BhASJYHMCGhrau2CiX6e/5y8qq6p569edIx9FgpMQFdWucH6qqmj4XTdij+V3sPNPNeP6JUQt5cClqY1Qz3r7vkNN/61xmxEqrUn4eGkTLvZiOhE5293FLQ7NO7PHxodGzxqKc0eu/nZIXNRfknc32lsmdnO62QZPDHq+uIJIaTIZQMEEtCQFRQZraxxy9YQlyuQIndl5E0edj4VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUOqj+LGriRQgGl74HIaHWUdyEuiNStGskjuPVcp8V8=;
 b=pW49fSVGd4U3jMekFFhODOfleafzX7ejsbFY5PhN+F12hHvZ4hJC00b0k62VOatyGN18/K4pzhNEFQ1Asb26y9+B7UYsBAWdLa+fR/asbIzNB6WOSDUfhr8uWANsWuI7SVbycyzw4sxBTqw8C8LGZUKYzBJ0R8ub4q3jza2sgFY=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR1701MB1743.namprd17.prod.outlook.com (2603:10b6:301:1b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 16:59:47 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 16:59:47 +0000
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
Subject: [PATCH v4 net-next 3/5] net: fec: Remove PHY reset in fec_main.c
Thread-Topic: [PATCH v4 net-next 3/5] net: fec: Remove PHY reset in fec_main.c
Thread-Index: Adbtu1HUKzFBiCQ/SEic7YuI/IEzAw==
Date:   Mon, 18 Jan 2021 16:59:47 +0000
Message-ID: <MW4PR17MB4243FEDFB099E8FDE59C57DBDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8397c8f9-d2e6-4937-9374-08d8bbd27662
x-ms-traffictypediagnostic: MWHPR1701MB1743:
x-microsoft-antispam-prvs: <MWHPR1701MB1743052288C2C517C732CBEDDFA40@MWHPR1701MB1743.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IWf4d/hgrYBReAXis74sJbqInMoBUu548aA6xGq1K9eB6Voo3ZoqVAGnS5RN/np5SW3YM6xaFP4SPiOyFoEzYt9o2KZMi+aZmPbf4J9vPbfDueEbdTsxcn+y5d84pGZq2gR0lR5ap1QVKPp5qB7exZ6zA/FIz3Mty2x9QoL2ZuYsowEK92pdJ8Dfxo65i2b7cxANeRf+I2dR4MOdA1cZ/WpRenUD7PvKIUpxHqwoUxckCKoYZzsW2HJo/XbV6HNS6oLcuABz3rEByRq3ssyOEqa5sir23AGtMvmF6Gk8Lzuc1yOUVta+fkkWND/xzbqKkXfbgYFLg5/uJY6GxQ1Kp8bCFruuVwDcWVebfUieAWOtbt7v1j8W9GhwdjLE/Zx0/siZzidAfAfxrh8aeDdcMhM7MaKaMLMscnist/qCB49PGJIxewdiLJsws8BCZDWB4/cWszSDjeDwwv6PJ4GzjRblQRy3z4wluegcJ0B8Z5rNYi2yq6UT3BLcD/SU+XKd96VIJ3Q4xfI0h1SJ+jpM5RJSDImuQqWsSYZBS7r5tr1n4xRYmrW5FIcd3RFXAX9S
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(39860400002)(346002)(2906002)(33656002)(86362001)(110136005)(7696005)(66556008)(55016002)(186003)(921005)(9686003)(66476007)(8676002)(5660300002)(71200400001)(478600001)(26005)(83380400001)(52536014)(66946007)(6506007)(7416002)(64756008)(66446008)(8936002)(316002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?k3APiZORaMAiuhPkqGWpymVBLZeRLIJkisMQr/mxNJWYqlKeklySdNcYRZBZ?=
 =?us-ascii?Q?/DlWdQj0mqLt8Gnxw6MpNBP/u2FTmEybNyMu361Og6VsDua09hQVTCmI0Nb9?=
 =?us-ascii?Q?WtWR4RmTeoOyND41xplPhbsr7wYxAdaqUToihR3j+PC+kJWAEsapAS+ZbT2q?=
 =?us-ascii?Q?ONjycu/bHEYoKZHcp22wA+X3zFAAgwBoKC5uCZnji+vDmBK3yg/ICkEzGYIX?=
 =?us-ascii?Q?G+K7SHH0idYqqOdRa4VkdrigkkeL3lC9d41ev6Tubv1krTgPjhf4WAUYBjkU?=
 =?us-ascii?Q?i1Jpvy4y/u49Rii2TTjw/Pb739Pit94yOTxw/b6qljMn2jhi4OFKGfnLlvn+?=
 =?us-ascii?Q?NMFH5PsIr9s7Ty98NqdoTDayoiz49wJJR9DEheBoHs+8aglY8EgaRfzrcDXu?=
 =?us-ascii?Q?DPEXPfd39+giZcXfOxmE1jRvrLoPvzZA8MvGOCwmMf99R3BRqTOhBgNe2OLV?=
 =?us-ascii?Q?ZS8f/kYJtKpgEglfcrd2QTrheleCC1MztrWIqaIyvEDQ16zL9rxXIF7365cM?=
 =?us-ascii?Q?hi2LKoS36sWnTsbr9L3iw2FEAqNNY7LLbtRtz8c+pF4xvrBEKUMPLlw7obvv?=
 =?us-ascii?Q?Lrw+3yxL3qEFww3dxx9SwWEg+xiHWMXBV4zDp1rO8QNmuHXWrNUEfASm4wkh?=
 =?us-ascii?Q?d7iPHxsZySES6jIl/csa3QC7jLey2/psUTVvzVH0X3enMjAcUlWbDEl8o7YT?=
 =?us-ascii?Q?aRZ4LnKQ0lF4XJfhTwsYgn2UnBG0/CiD9eHhTzEF1jH+zKNmUzhwq8VXr9m6?=
 =?us-ascii?Q?35efAqBnZ5DP9LHfaWhA3hgIV8A3xmvWrYCGaQQpevHJ57DTi6fSTA5OTn6e?=
 =?us-ascii?Q?pIcORuZbmL3NpUwxxOoWlC3azPybU47mr7EzK1pItqUVN32biuk6a5qiT/S1?=
 =?us-ascii?Q?qWAltwU6EzDCXD5UlD9ounMLvA66XG/T7ey9ucflaMNBgZOme+2vfIdBysQp?=
 =?us-ascii?Q?0hSo3mWmy7Y002coSZwwo/C246q4V5tse/LlAoUipQY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8397c8f9-d2e6-4937-9374-08d8bbd27662
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 16:59:47.5040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j7+YxKGyink5KIFiIyQLyoBhmDsqyQbUeooHPMjYwK5pP8bK8gbxMrdLgmqOjj4GwO+jZPBnLfEDFghaIMOfQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1701MB1743
X-TM-SNTS-SMTP: 335BEC0248C2B30C37F4026611D43AE0BFB8CB4758FAAE72E2F1819B4DCAC3D92002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.001
X-TM-AS-Result: No-3.300-7.0-31-10
X-imss-scan-details: No-3.300-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.001
X-TMASE-Result: 10-3.299700-10.000000
X-TMASE-MatchedRID: tRtxWm8/OsGYizZS4XBb39WxbZgaqhS0SWg+u4ir2NNLxCuBTCXaKv1R
        U7wjeDcU2w9WUtAsFzdYV++JgP70OLwVYOCFOHvZqJSK+HSPY+9lRzZAkKRGDXAal2A1DQmsQBz
        oPKhLasiPqQJ9fQR1zkWeLerpe5E3tV2G0nFedQgHtOpEBhWiFk+crEA4+nhZ8jflxBKMkr4sta
        G2wt1Mam0T4AfKq7lu9dCytzw2Ek5c+NzN6CaS/oS/TV9k6ppAprzcyrz2L10W6M2A15L1QNs8F
        0VcKD1tvudrc9c6d41wRRhxqxsO8nL3NzSyDKLm9Ib/6w+1lWR6LoLL7h2v2qZwleT7xjO5CMkz
        RYtEwm1WCSKTdQ2Ceb6hIaKfExp033fj+sMArfOajHJnNR8XJH/GeipxRzf0DmuAyfSfU3vh0C1
        hzLwlv+QTG2mKTARW3ISi2pqKe8g1M5aSynbATzLgoH8ZRcJ8yetg4MSZLEgzsJHHHwer9R3Gm5
        R2h/Q7LjnH09LU/owIi37pJqP4+7/Oj7BAzdYuNmmWtdq6DqdWXGvUUmKP2w==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFPHY reset from the FEC driver is not needed if the PHY is kept in =
reset
after PHY driver probe, so remove phy_reset_after_clk_enable() and related
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

