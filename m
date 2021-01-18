Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9392FA6E7
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406711AbhARQ70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:59:26 -0500
Received: from mail.eaton.com ([192.104.67.6]:10401 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393126AbhARQ7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 11:59:17 -0500
Received: from mail.eaton.com (simtcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 578509611F;
        Mon, 18 Jan 2021 11:58:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610989110;
        bh=+j4J2G8aXeuZQGASUHS9h/5ER/9KPptcn5gDY9K0GiI=; h=From:To:Date;
        b=OtEAet0NG1da3F+5m4A/t684rmIwPihWjqpBZ9tfw6KPT7Z0XqEAR9R6DKKQxCIHU
         tkPzGhZloxF6H1nRjGcKVnBEQW2QuP4z0H+Z8aw38ur+YjbWuy+UOgmOiJYJrksfUT
         gxaIKQjOZNlnHtAd9jkdZGUHeda5IVG/91z/dUceHmlnnWlI4cO855OU15Huk1zr+u
         HaGTtXMVToeC8kfKZTx75TJFnkh6+yllKVFmtkYzxNf3rViDd8QH+C9p+/RZ455ViF
         WP5ULAJ7yaMLxjSCE6k3r6Zwnnq+/8nIMIdct0NBzeix3s3EytfJGJgjPGMdcuK/Ft
         BXdFKr3L4glCg==
Received: from mail.eaton.com (simtcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D92996118;
        Mon, 18 Jan 2021 11:58:30 -0500 (EST)
Received: from LOUTCSGWY01.napa.ad.etn.com (loutcsgwy01.napa.ad.etn.com [151.110.126.83])
        by mail.eaton.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 11:58:30 -0500 (EST)
Received: from USSTCSHYB02.napa.ad.etn.com (151.110.40.172) by
 LOUTCSGWY01.napa.ad.etn.com (151.110.126.83) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 11:58:29 -0500
Received: from USLTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.152) by
 USSTCSHYB02.napa.ad.etn.com (151.110.40.172) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 11:58:29 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 hybridmail.eaton.com (151.110.240.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 18 Jan 2021 11:58:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cihJtqvIdeFnm3+iclKfrbbwiH2OCOhWWskO9NRf3xeF9FUTBqqEYcqaH0+a1BAd08q2J2KYnpSdGiwZ980Fl9ur+lP77ImSMSs8vXahLtRFRHlEPHN2AwV4x5eL5dr0zqgp0MB+E/P5hKYpR50sCW6v9V3wVXrdbKmi1VZblcHgc2GG+LUy/T5lo8C5riMilfVfxSPM/M6kfpOn5w3suA+GAsGfqd5R7rqsKPhGgB7XG+SLyYvLwhWEf7YeJKnHV/iVa6VUsNWbFVI1Ta1rDJYiB2gUmoRuDJRx1893/6u3fGUcsJHrKf0eNPSF+Yhw9Bsv4Xd/KDS1Uc1LDTrkRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dveKWaEXj8caS5/n9t7s0BIkBhY8itPQ4f/FCswjBr4=;
 b=TKk6ObgNxrknTWB8iFD1bw2rRjgZihXCjyZzdK7DAcirFEQJwHTgmZskFvbqsLsRMiBVVetgzv1S4RDEM/uE44jCTRaefPat73qXUDufqQM5Tk0HgrWZx3g+uaGBBas2cxybPZfuatTTdM3jsNNvumeVfPjcSXSjsoSNOp8WA1PcBY0lGm0VqYuZUk6xJumzX1uMfQR2Oq5pqBaCg+x2wj4u32kklRolcEMogN415R4rvNnokBdD4NcNbOMso/iR/GPKtlp5nC4UIR7lrnZ2Q+B0PcgS1bh/WzS+UgMNgt/Mplt75ZZqrSvcBwgTzXzwtLUaANXv6TTU25K0vpqW1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dveKWaEXj8caS5/n9t7s0BIkBhY8itPQ4f/FCswjBr4=;
 b=zRXGGYRothmnLlkZ8yaNLXqSsQAS/Xr2NxTUIqxVr5qf+RvTU1FRFLMObB0YEj7vYCT8ctuS2u2qWk2AcXHoPuh6kaL2yftinIFUB/+ioaOBA198Q9mYuRKKGEpOKnq24/yiYqncl1ZONv/3W8y1lyuGHK8Dn5JVDV7Esb9Mj3c=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MWHPR1701MB1743.namprd17.prod.outlook.com (2603:10b6:301:1b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 16:58:28 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 16:58:28 +0000
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
Subject: [PATCH v4 net-next 1/5] net: phy: Add PHY_RST_AFTER_PROBE flag
Thread-Topic: [PATCH v4 net-next 1/5] net: phy: Add PHY_RST_AFTER_PROBE flag
Thread-Index: AdbtuyJ8H2lqftHoQdi+B2oA/e66ag==
Date:   Mon, 18 Jan 2021 16:58:27 +0000
Message-ID: <MW4PR17MB4243C51A3D1616487F201B2EDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a540c0c3-d924-4760-cded-08d8bbd246f5
x-ms-traffictypediagnostic: MWHPR1701MB1743:
x-microsoft-antispam-prvs: <MWHPR1701MB17432C33818C2745D22D6DB5DFA40@MWHPR1701MB1743.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vzhap/8YO6f0t2uPb7JBThiiyfCXQdfMnWSGxMEwoAZJ2XlGXLqEo9m3c9fEE6BBO1K15cntYTWvwyzt3h3No/McbwIZi/wymNoWetvtEDnQemXUoi5wJ1mTo8Lrwu50fBaam7VcGyqMYkUA6GRg76p/8ZwXnLfZ5AS1+VCuGI2vcolQS7KXNGhQzsQHqLM6/AbdnNzrUSG2vU7Y9dqo+JdjKopWh8XdBSgbd/mBSpLZWQI70p89mU7OAyH3dP+2XzIImY+v/2g7tr5bmUHKN5XoRzaMXwjxAMTK8YBOtPUJtF1j9vHxNTStqSSUiOXq0x4qzo7uzhIasuyZyNJTPnlbEN01iMuNN1QbjDubqbqpOhCFMmJF9TiSo8mvgBTtDBQHtyT57tOw33Vf/2vqnkm5ItO12hmTETOSNbDDo9/kndpaWQTbfLwRpvmAc2Gc8VGQbfxS0RK0Ak2Ke/+ekD/VlnokZQPryK1guuTE5NzUox0cuOW/w2ERn2+TjKmo9bU96IOYoTjpgcfYyo8OAIMzk2eNJ6vMxjb/IpmHBf0xGbjYbRcuiPs9MdEZCDpY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(346002)(396003)(52536014)(478600001)(26005)(83380400001)(76116006)(316002)(6506007)(7416002)(66946007)(8936002)(64756008)(66446008)(86362001)(110136005)(7696005)(66556008)(2906002)(33656002)(55016002)(8676002)(5660300002)(71200400001)(921005)(186003)(66476007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gxTBwu+3p15dWwNihlhHRPzNVgL2LMMPoirqWvnwHfigNAhb0fzp4McG6ls9?=
 =?us-ascii?Q?p+yHPwXx9OLJeHBY5nyowNzfLPuaiRKIaKV5kMwJDSGJ2bEgXcfJxVX1u+pB?=
 =?us-ascii?Q?jm1wOtmwdyJ8Dmjl0TIWfqAvIKK1u9SInIwraj6hcdHx2QgRLz8Ew44nMiaY?=
 =?us-ascii?Q?ey7P6OHg42tzUY68+NevKwkA7ouirNuxK8WpqIvjvdvoMoh3EwyBkjJYV/jS?=
 =?us-ascii?Q?Wk7jDIa3Vb+hINARPuFsIanGcYWR2Osctp2wxlgC+bxVVeHGVvLqQDWGY4UF?=
 =?us-ascii?Q?oRxgVV2yN71e7Ay5LIWm+1bFoEPcCMu8/rg+zDQmxpGYA+ylLHGPG5Tjn2gR?=
 =?us-ascii?Q?xVuCX1AQL4K1hL0HHUJ121IBUgZd/r+79EJgrM1ZbKT78925NwqVwbufqVoS?=
 =?us-ascii?Q?/Pat9xUOK4U6kZsOV7UcVYfQCyxW9R3uR7/A2AwSBPFXh62Vh/MMQLmKx2Bz?=
 =?us-ascii?Q?CV7hR1aDeon6YKd7rFrfGdqrXObhL50dGmwNMLdesKflWGPdqF/mjgHaISMB?=
 =?us-ascii?Q?bQt7Dnb7V2GnJY1ENi2Ef/mu8ZBx2z6LjLSF1dLlJX3kMq9hnHQm3F04T7PM?=
 =?us-ascii?Q?tnIofPX+br3jb3+6BEISqpBaSH9Ow5sgfTR9HHeZ7+QEhBpH41khq0Ys4CRX?=
 =?us-ascii?Q?uy+gdtt2wi72EBGj+n3/z2sv0SpWJSSuYDcWoSZaQF4J7fmcK/s7zD9YyB9n?=
 =?us-ascii?Q?J3W1mMWl+PzuT/ggkIv+TbPK2prtNlsp3P+m688dTtVJOYNvJj3+0tyw+uKR?=
 =?us-ascii?Q?ulUn64LjqnO4qrU5mDoSAYZovOGC2r5tG9Sdu96IIHG9QIYApEYkYA1aZYm0?=
 =?us-ascii?Q?/AEw3izdBAYE1U3hbdhVM9FRU0MJk9I+oPstOiqTxmzOoysDM2nsQoQFtUJw?=
 =?us-ascii?Q?3CPX6/Rhk8BrILefNw4wbjPxFnya3ZOjAKKlKMA5UXFDARs+pCX+76Vsz6ZB?=
 =?us-ascii?Q?z7l2mbw+FHhbofB1EzClk1ljlnX+DDqMAF80e2AghSc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a540c0c3-d924-4760-cded-08d8bbd246f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 16:58:27.9462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WtOCP5f1sCZVNfEVaD7c9XA+wT2wzOeD9I/W9WZdy+jUBffQcezxA1+dxCp3UtNyafreFXRV1CdUsAgx8eRQgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1701MB1743
X-TM-SNTS-SMTP: 760525C78B59ACB84A4252DD62099E4C0D1BD3FBB49D8E6D5D80E016DFE172702002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.001
X-TM-AS-Result: No--3.147-7.0-31-10
X-imss-scan-details: No--3.147-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.001
X-TMASE-Result: 10--3.146800-10.000000
X-TMASE-MatchedRID: Ts72c050/H6YizZS4XBb36oXHZz/dXlxWw/S0HB7eoPAJMh4mAwEG30/
        GxbBOLivolMF7w4ybQAuWuaCqkcrH3FXmAqsdcFc9u1rQ4BgXPI/pOSL72dTfwdkFovAReUoaUX
        s6FguVy34l0WsxmdIxwIrJOPBAlx1rxoKRhlIKmWqh5pv1eDPz9WgcD0fC9Cbw62uSG5kL1ZGVK
        ommfqPJ1t1cL6hCLycV1uoDPGLPAigcQ9540RHYcZW5ai5WKly5i/w/+ZVg4BVPGE8e1nYHyxa4
        kD49kbF1bwGPsv4KnwPfN1A5usbmuI8/ySPD+KlzQE+1H9tIa/KsMGb+Kwkw2UhHUKciBvrHcab
        lHaH9DsuOcfT0tT+jAiLfukmo/j7v86PsEDN1i7cilLKw9Et1g==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFAdd new flag PHY_RST_AFTER_PROBE for LAN8710/20/40. This flag is i=
ntended
for phy_probe() to assert hardware reset after probing the PHY.

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/smsc.c | 4 ++--
 include/linux/phy.h    | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index ddb78fb4d6dc..5ee45c48efbb 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -433,7 +433,7 @@ static struct phy_driver smsc_phy_driver[] =3D {
 	.name		=3D "SMSC LAN8710/LAN8720",
=20
 	/* PHY_BASIC_FEATURES */
-
+	.flags		=3D PHY_RST_AFTER_PROBE,
 	.probe		=3D smsc_phy_probe,
 	.remove		=3D smsc_phy_remove,
=20
@@ -460,7 +460,7 @@ static struct phy_driver smsc_phy_driver[] =3D {
 	.name		=3D "SMSC LAN8740",
=20
 	/* PHY_BASIC_FEATURES */
-	.flags		=3D PHY_RST_AFTER_CLK_EN,
+	.flags		=3D PHY_RST_AFTER_CLK_EN & PHY_RST_AFTER_PROBE,
=20
 	.probe		=3D smsc_phy_probe,
=20
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 24fcc6456a9e..4bbc7a06235c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -81,6 +81,7 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_RST_AFTER_CLK_EN	0x00000002
 #define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
+#define PHY_RST_AFTER_PROBE	0x00000008
=20
 /**
  * enum phy_interface_t - Interface Mode definitions
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

