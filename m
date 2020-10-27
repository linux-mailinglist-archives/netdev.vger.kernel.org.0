Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B0929CD5D
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgJ1BiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:19 -0400
Received: from mail2.eaton.com ([192.104.67.3]:10500 "EHLO
        loutcimsva02.etn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833000AbgJ0X1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 19:27:04 -0400
Received: from loutcimsva02.etn.com (loutcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21F38F817F;
        Tue, 27 Oct 2020 19:26:58 -0400 (EDT)
Received: from loutcimsva02.etn.com (loutcimsva02.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A2AFF8167;
        Tue, 27 Oct 2020 19:26:58 -0400 (EDT)
Received: from SIMTCSGWY04.napa.ad.etn.com (simtcsgwy04.napa.ad.etn.com [151.110.126.121])
        by loutcimsva02.etn.com (Postfix) with ESMTPS;
        Tue, 27 Oct 2020 19:26:57 -0400 (EDT)
Received: from LOUTCSHUB04.napa.ad.etn.com (151.110.40.77) by
 SIMTCSGWY04.napa.ad.etn.com (151.110.126.121) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Tue, 27 Oct 2020 19:26:57 -0400
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 LOUTCSHUB04.napa.ad.etn.com (151.110.40.77) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Tue, 27 Oct 2020 19:26:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Tue, 27 Oct 2020 19:26:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPshk5Yhv9S/5u7jDLk874KIFWccOPAjt0rvIjxzyiYT1LDNyVJq9LRqg48PGwRPGpzzUY3/Hl6pXETSWpmJcvJ1DehAaDQiJ9xprHnkToBv1hhqFa8THHqH7tauLseZvIYWU5oDYD8HU5R4jFwIBVdFVICLgtT/KKaLsjOJy2M8wtkHS/Cmx0hhLEnJHl605UcD3t4blLTqBj7h/oFeRloZLWKUJngaMDLfRtwe/JN5HVTxTT4uf5DHT0q404ygSZzVNvcuviwJWLNA+b20F7MN3beuGr7KJ0YB30mcp4alHyqcDBrw6qc2wtS3AUZrqBdSWlyBAZeMOQhGWAIoZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9XAMYLbd7vO1yvGWcqNnTUG0nTD6pY5TEE/U38B4vQ=;
 b=buyxYuxgH0GBLathsqxgDw/JrFN+/ejB+jSF1D7jwj9HjYln19285vpJjM66K0TZ1ScZNK/TLoEyC4F3JgELRUdK4Z0dGgdDjXDV6NjE8TgubEbQi8t4GsI8CozsJWSc0yOE2/sEtw9PWoqLPXDeQtLCGHyotZ8SgRKR5hr0ofvZ5gQeZ/SAyy8eMNwVlkrOdiX1ZEQPvX98AVPmqbG1Ud7uU7LzoFLrx80kgQd2eGssJj35GcsQPEw76zZfXqpkIL/wWvR/5mhdOA02Y0aa4odQGf8nFAdnfG+PYwaoW0sUTvV/Af4aKVQAvDQZsCBOTX7Nu+A+UB70IcQtTC2Cug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9XAMYLbd7vO1yvGWcqNnTUG0nTD6pY5TEE/U38B4vQ=;
 b=psBQFS4Mww5GU8UodsXxNBahA7+c96cUQ3Yo1CunTqswXBXmS+feJMYC0kzCH/BwrZ6wzKd/EOJ1RIVTsYYh2f1nbXuSJThPATW+Jl91jVJGNgCpqJRiLesXI6HoDUlqf2neX1Tz5veZd2dB7InSYm5O9R5SPkhZOmjd8YhzSeM=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR17MB1942.namprd17.prod.outlook.com
 (2603:10b6:903:94::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Tue, 27 Oct
 2020 23:26:55 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 23:26:55 +0000
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
Subject: [PATCH net 1/4] net:phy:smsc: enable PHY_RST_AFTER_CLK_EN if ref
 clock is not set
Thread-Topic: [PATCH net 1/4] net:phy:smsc: enable PHY_RST_AFTER_CLK_EN if ref
 clock is not set
Thread-Index: AdasuKId7Rcgsqy5TdKHTeqpGTl6ug==
Date:   Tue, 27 Oct 2020 23:26:55 +0000
Message-ID: <CY4PR1701MB18781C29E0D94E7842A1DBCADF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61fe2121-f03b-47e8-3ea5-08d87acfcac6
x-ms-traffictypediagnostic: CY4PR17MB1942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR17MB1942A1C4F265F13C26BBA91DDF160@CY4PR17MB1942.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ps7lz1h7xuvNaSPaJhPw3df2Ahvx3quI86Pyi3rTABucn6miKc8ICjN5s9sr+yX2XLvr3UGBaXjcrSjeRtIta9d1SAkQoqDd/niWmOMSK+GqAHdTYBGsIOgiFKQyLGk7BaVbs2OHC6aU+EJU4y/UjwUWDz5GVcl2y5jW9UAZtAeSx569YIrpQY/zHBaMrWivHU2tK5k5a4TYYOaJl1taeAdnyS/kBeqh4AgRvoYKnEKhXlWGG3LXiUXNMha6eBxL3E9Ku0B8Hkw5srJrNwOo0CHGiprvwoFGECCYxeRbrAXMCpjKpbxS1T1wLlW9z29m1Jg14PikU0hx7OLjaGnVuoSX2HTEA3IEMUlCUdazCiZQfOOHKCUjPo8OD5+MrYTy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(6506007)(8676002)(8936002)(107886003)(9686003)(2906002)(86362001)(4326008)(64756008)(66946007)(33656002)(478600001)(52536014)(66476007)(76116006)(66556008)(5660300002)(66446008)(71200400001)(316002)(186003)(26005)(110136005)(7696005)(55016002)(83380400001)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DjD4Go6xJc86b1eBUM3cheCVRMqFe5cUXHfsxFuIZOKBStbqWMvjTFjcnHV+drnT8JamDvQtPB4muxQ6HtwYlcy0IG0UJbTVguEkn9eBo9hd1OB5jeppitaFtFOUYRChcGIqycWQjXYdUwZk47Ju5GnLT71/LcoYfYY+BmuZGdHWCQxyDq7xeXvbh2TUW+d6TZ7u0TkKeSByx8xF3h6h4c5Yb7aYOJD8YHRh4Db4sUCOqHhfzE6cWhumd/vkxUlpYfOKTw/2phK6Oi0689YEfB7L5k0k6AxLe/hmHuP27yywp7rAGV2Swf8y5wWFvZIZiD347xgpOoKurub9gHsQtZrf058/I1Q5Mo4PqUknxSUiVdG3mek0Pjj+2QoI+7EBggDdyNXRB5zo8M/0+MAeEapvSmtFwMvLa/AhVAYvlBSJsoWSoCZLm5yxX5Wp7x1/A6FqhxPICSm2SNjQYxykzUzdApX/5xNFCUfqLpyntXhTKzBrIveaR8mNaHlNokiiowFz/hVybe64LG4KeZbknlRdjbRnQkjjamYfk1UIEbQd5KICGUWyFxj6u+umCF3RHB0OSxny8YrVQb8UBmBUa2Soj82w/6lpPz7yNeWel1qSjZ03EaW05PIKQb4fDBVKbZsnJ2cg+9J+znSF7CUM7g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fe2121-f03b-47e8-3ea5-08d87acfcac6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 23:26:55.0634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SbW0FisJ3eWvER4fqF1vGnK8sdLVXpTW7MF21hoeEcGQOIW/QhM8WfoF1PgwPcYWcjuPcn/RqWMwgmvDfneuDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR17MB1942
X-TM-SNTS-SMTP: A6DFE5C5683E1DC8C8BE5E01C24FF83A4F4C6733C0CD068BDAF6975985C411752002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25752.003
X-TM-AS-Result: No-0.689-10.0-31-10
X-imss-scan-details: No-0.689-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25752.003
X-TMASE-Result: 10-0.689300-10.000000
X-TMASE-MatchedRID: e7Ukgmbx2cyYizZS4XBb35VRzPxemJL0APiR4btCEeYd0WOKRkwsh9Sh
        vIchwjOu/ojs7zY2kdlk5NRCsylb+a91xPCrfpdC/ccgt/EtX/3zDFXwlHc2qIdfRwNmJj4N224
        ueXqtKLvI49L/4WyKckk+8jV4IoVX0bQcZcDDFnw/ApMPW/xhXkyQ5fRSh265VWQnHKxp38huNR
        GoPKGToay1D/w95rX+sGfwDYJyJijlRxm3A2wKugtuKBGekqUpUfEQFBqv0mdDC7Q2i0S4itOJG
        GkIdSc4DsO2o1mDrpjoLQRNyVnczutNRF3pWfw8qNl2PpZjORaZqPu8XQH2ta3w6jnqiSeEqaWl
        lv2uQLQb+NnrrnzwGgZXX8DI70XVFwVtTn8Pj+qqUcpaEPPs/JWBOSsMjKAbwL6SxPpr1/I=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFSubject: [PATCH net 1/4] net:phy:smsc: enable PHY_RST_AFTER_CLK_EN=
 if ref clock is not set

Description: for compatibility, restore PHY_RST_AFTER_CLK_EN flag for=20
LAN8720, but clear it if the driver successfully retrieves a reference to
the ref clk. This ensures compatibility for systems that rely on the PHY
reset workaround, but fail to update their DT with the 'clocks' property
for SMSC PHY.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
Fixes: d65af21842f8 ("net: phy: smsc: LAN8710/20: remove PHY_RST_AFTER_CLK_=
EN=20
flag")
---
 drivers/net/phy/smsc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ec97669be5c2..321ed2a89045 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -294,6 +294,9 @@ static int smsc_phy_probe(struct phy_device *phydev)
 	if (ret)
 		return ret;
=20
+	if (priv->refclk)
+		phydev->drv->flags &=3D ~PHY_RST_AFTER_CLK_EN;
+
 	return 0;
 }
=20
@@ -397,7 +400,7 @@ static struct phy_driver smsc_phy_driver[] =3D {
 	.name		=3D "SMSC LAN8710/LAN8720",
=20
 	/* PHY_BASIC_FEATURES */
-
+	.flags		=3D PHY_RST_AFTER_CLK_EN,
 	.probe		=3D smsc_phy_probe,
 	.remove		=3D smsc_phy_remove,
=20
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

