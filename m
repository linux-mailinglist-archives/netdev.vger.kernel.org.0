Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781EB14CC86
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 15:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgA2Ogk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 09:36:40 -0500
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6170
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbgA2Ogk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 09:36:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkeBwyapY0TkMfIUw1GADX4a/XFFjL+GNAmD5/C03tPIGTACme+QgG9yagQzI7S8J4ty8Zjul0VsgR9Jsu5K6azQSevMoV1vl+uJFFsa0gIK7/Lr4Kuxuw6IGDvTait8/aOBkxXvveA8TUUG64tRoGJNYJVrEiu6g56pnNU/7dRr48jyPjNvF4aj+gaknKSi3lh/UIgKkvUWF2oRJdBP7ajvK53uTcK9zPRoHc0m+i27Pl1cx+HzTchg1MGLcOA9p7q7MprpLCZGC7u7f0jW2kdrYuUc28CRB/pJBRlKfJWhOja0b7xWWLs6cL0hV3YiWA6Tuqo9tisDY+dfmwx3+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4/qGcdLnEe8S8t8hOIxW/jPwjg9+5OMs3cFo0/ZxY4=;
 b=DYCdOfQGk2Uk6XYd4p2vKg10AmjJ7j4LamldVRQxho46NbnK/ISwRTMEh+QQEfqluUAgDlxau+Zvguri0gBLYD6UkUOWFCCnjFPlaFIrpHA9BsGvRpaw4+J7mtCvuhVVM/HXJTpXRDzuemMIdlSWVn1rTeXb11y7LAKkKY3yyI+WswWSZqgKsVA71IY1UglwPz47f+wn0WwVksT4LghxkPnPoSsCyLl09BBahnBY4ySBBVz0l48fAZ3vQX8aGoZGXdv3+6wejhzOZaaBtaWA4vx1R//jEGkBUH8zvuGa9PYcsNeDl00FE9ZeuHPKocTg0fvgPi1vc7VgXw8mxB8RaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4/qGcdLnEe8S8t8hOIxW/jPwjg9+5OMs3cFo0/ZxY4=;
 b=W8JdaP7SNBowXgNHlbvNF55GhWFZv78iX+aX/zmxN9oKQZNB4ntvREg6ZLvjEEpbqEMDL7nCNvWkXWsVrGngrwNIJw4AL/NJrEG75CcSteQMLgzYxmQk0/8nW6GUE/0pYw5IsvPL20mXLGB2Veddoq7+ciicsx0GKEA/Lk2CDQw=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB5866.eurprd04.prod.outlook.com (20.179.12.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Wed, 29 Jan 2020 14:36:31 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2665.027; Wed, 29 Jan 2020
 14:36:31 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ykaukab@suse.de" <ykaukab@suse.de>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Topic: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
 indication
Thread-Index: AQHV0Sw23V0HaV1F6UKjzaVeqBvXWaf2+L4AgADjpXCABvOdgIABdECAgAEnbfCAAAv8gIAABX6ggAA1CoCAAAayoA==
Date:   Wed, 29 Jan 2020 14:36:31 +0000
Message-ID: <DB8PR04MB698588200EE839607F055B24EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1579701573-6609-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1579701573-6609-2-git-send-email-madalin.bucur@oss.nxp.com>
 <68921c8a-06b6-d5c0-e857-14e7bc2c0a94@gmail.com>
 <DB8PR04MB6985606F38572D8512E8D27EEC0F0@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <77e3ddcb-bddb-32d8-9c87-48ba9a7f2773@gmail.com>
 <CA+h21hq7U_EtetuLZN5rjXcq+cRUoD0y_76LxuHpoC53J70CEQ@mail.gmail.com>
 <DB8PR04MB6985139D4ABED85B701445A9EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <CA+h21hpSpgQsQ0kRmSaC2qfmFj=0KadDjwEK2Bvkz72g+iGxBQ@mail.gmail.com>
 <DB8PR04MB6985B0A712634DCFCD5390A4EC050@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200129134447.GA25384@lunn.ch>
In-Reply-To: <20200129134447.GA25384@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 26488ef0-e268-4ad5-43d8-08d7a4c8a21c
x-ms-traffictypediagnostic: DB8PR04MB5866:|DB8PR04MB5866:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB586651CEB80EAC697FBB28CAAD050@DB8PR04MB5866.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02973C87BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(189003)(199004)(2906002)(52536014)(53546011)(6506007)(86362001)(110136005)(54906003)(186003)(316002)(8936002)(478600001)(26005)(5660300002)(81166006)(8676002)(81156014)(7696005)(4326008)(66946007)(76116006)(66476007)(66556008)(64756008)(66446008)(55016002)(71200400001)(33656002)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5866;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ui7b7H1fqKLKJcMXZF+44ISyTAHaOPL31ue7adHn4+VBtDsj2pDcgRwfmI9vYKeOvBX6D3pH1jRbuN/N5SMN9sXtVRAzmfPWbgwiu+QECyeCFJDyddfhswuzo7gCKOLBtt527fsKIrwDs4efp1MMi7xCJdnU+lfEOc1E4xxtQBZB+ep8pGb40vB9ssFklYkRfJ/bbNczQRMw5SZVv4qK5yQjrSeWNpc32K6UyU3ekl/sqLmhCEmCF+4Im3DdNjDtW4mBvWjUMe/BumipDHAEyNzUV+WEVBamWFnoPV0bo4B+V1qPUiUfvUadk9mWEaFTf4xLAUer7YPPuNd88wxWLmKtjVaMu3tx3WR3gVWbfaLlv3jM0fjXS6iMEZBi5ee7MRgQsRYpWieXBcmhZJfCWlGACIoBkNAyIMd8K006+pmxe3gwDacPcE+u28E7Slc0
x-ms-exchange-antispam-messagedata: rlSZZGh08rOgB3BtpmsDL9v3ZVgjrApWQhcNsrm/qZBhVHck2M6flZUc9nuWXhC7OpJDyIc5pJyfb/g95mROeMaAxf8cs0RYqBTCpDEh2O9yiBP3T4KUQBMEU8bw/Q4wEc4JqidiKv4gBlPccSO4YQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26488ef0-e268-4ad5-43d8-08d7a4c8a21c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2020 14:36:31.5952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JWr9WHk5ldkZOFR/zRhkYk0Mdt3TrOEkxwBe9Dgl31CfCFzDmh3a88EDvcuWfwWnAVMOwGyh2bIVLd1FfbFLOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5866
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, January 29, 2020 3:45 PM
> To: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>; Florian Fainelli
> <f.fainelli@gmail.com>; davem@davemloft.net; hkallweit1@gmail.com;
> netdev@vger.kernel.org; ykaukab@suse.de; Russell King - ARM Linux admin
> <linux@armlinux.org.uk>
> Subject: Re: [PATCH net-next 1/2] net: phy: aquantia: add rate_adaptation
> indication
>=20
> > I know it is set because someone does put some work in designing a
> system,
> > in provisioning a correct firmware image.
>=20
> Hi Madalin
>=20
> That is one of the things i don't like about the aquantia PHY. It can
> have all sorts of magic in its firmware, but the firmware is specific
> to the board. Is this phydev->rate_adaptation going to be correct for
> any other board using an Aquantia PHY?

It's a vendor policy I cannot comment upon. Probably it gives them more
visibility / control over the use-cases of their products and also
leaves less room for configuration issues on a device that's not that
simple. As far as I can tell from the public information available, the
Aquantia PHYs we have support for in the kernel have this capability.
Whether it can be disabled through various means, I cannot provide any
guarantees. I'm not aware of any way to determine if the rate adaptation
is functional or not, Vladimir seems to have some information on that.

Nor do I need to know, my approach here is "non nocere", if there is a
chance for the PHY to link with the partner at a different speed than the
one supported on the system interface, do not prevent it by deleting those
modes, as the dpaa_eth driver does now. Whether that link will be successfu=
l
or not depends upon many variables and only some are related to rate adapta=
tion.

While it would be perfect to have total control over those variables, to ch=
eck
each and every bit that could have a value conflicting with the intended us=
e
case, this would require open documentation from the PHY vendor, a large ef=
fort=20
and would have a limited benefit in the end. Somehow, these devices do work
today, without exposing all the internal knobs to the user. If we invest th=
e
above said large effort, we'll have them still working, but we'll have user=
s
puzzled at a myriad of options at their fingertips. Then we'd need them to =
spend
some time with the board schematic in hand, to make sure they feed in the c=
orrect
values for everything. We're at a certain point on the curve between good
usability and full features, I'm not saying it's the best position, that it
cannot be improved upon, just that we need to have a balanced approach and =
some
priorities.

> I think at least you need to poke around in the Aquantia PHY registers
> and ensure this feature is actually enabled before setting this bit to
> true.
>=20
> 	Andrew

That would change this bit from "rate adaptation capable" (my intent) to
"rate adaptation functional" (outside my scope). In anyone cares to add the
latter I'm not against it but I can settle with the former.

Regards,
Madalin
