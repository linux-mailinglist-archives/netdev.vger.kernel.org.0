Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD75295CF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390465AbfEXKaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:30:23 -0400
Received: from mail-eopbgr30058.outbound.protection.outlook.com ([40.107.3.58]:3974
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390156AbfEXKaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 06:30:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0P4bK4pIP9q7aqYJyRL3edWJmnYDFT8qT9rNfFlrwc=;
 b=eScqUrTVqudoA2+hMFA6Ik5lqmY66AAmT02+1yJNE1hFBe6Lt/RMx3Rdfm3W2XoP1OHgcC25ance4sYw3TQZSjdJxsRaEzT0ro6Tg1YrCP5+5b1fSlMXJoIRosffqHW7Yg+5gmZPFB7eOHyyWLyPfpXpPi3FPmTqARYYEE1soVk=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3663.eurprd04.prod.outlook.com (52.134.14.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Fri, 24 May 2019 10:30:18 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 10:30:18 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [RFC PATCH net-next 2/9] net: phy: Guard against the presence of
 a netdev
Thread-Topic: [RFC PATCH net-next 2/9] net: phy: Guard against the presence of
 a netdev
Thread-Index: AQHVEQW66VSOZj2NTUKIRdrxG/7Xx6Z5SOGAgADLNAA=
Date:   Fri, 24 May 2019 10:30:18 +0000
Message-ID: <VI1PR0402MB280048FACD410AA6356B2410E0020@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-3-ioana.ciornei@nxp.com>
 <20190523221835.GB21208@lunn.ch>
In-Reply-To: <20190523221835.GB21208@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ea7b01a-0177-4106-d350-08d6e032d166
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3663;
x-ms-traffictypediagnostic: VI1PR0402MB3663:
x-microsoft-antispam-prvs: <VI1PR0402MB3663B1A150E1B5F3FBB35582E0020@VI1PR0402MB3663.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(396003)(39860400002)(346002)(199004)(189003)(6436002)(76116006)(8676002)(44832011)(73956011)(55016002)(68736007)(486006)(7736002)(9686003)(305945005)(476003)(33656002)(81156014)(74316002)(2906002)(81166006)(25786009)(8936002)(14454004)(66446008)(66476007)(446003)(64756008)(66556008)(256004)(14444005)(52536014)(5024004)(54906003)(71190400001)(71200400001)(66066001)(66946007)(6506007)(316002)(4326008)(26005)(478600001)(86362001)(102836004)(3846002)(6916009)(99286004)(229853002)(53936002)(7696005)(11346002)(6116002)(5660300002)(6246003)(186003)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3663;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HHsTAx05fxnPDtQnH5AFV2cbPGh5m1gjYfrooFkFQOIqFR6iYzQ7ugU2OIxQaytEvZ5K7r9bbTJIbO+qtYIYjx0iSaD4GxtNbS00NbBnr/ENBVlWOTZel34l3zGahrvDAsP5IT4X3pHcp0RncczwyIs7lDOypOn2aPwzvhOH+kGK2KUs7YJPnBqc0r/j3nUQx2Xwk+HhWG++WsBJIm6GEGfU8m2ENSh/alKL+SzrwWXxwZkmn6IgVqZtqy2lWW286+QLuHzcT0+SHNo3DgmzO6Ws2nqr1DBvxe7JojnUJ/4j8WmS2uqf2iKLeS1u64g/TsJlU7JAXi2x/XR/7BeE9spCHEI3YRNthqN1YCOtPlqSkg/s6914KkdaeTXR6/ZqGltACkTYsCqpbbgY4AF+KHDjFvkOqjPksyIh4ED21Hk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ea7b01a-0177-4106-d350-08d6e032d166
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 10:30:18.4596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3663
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [RFC PATCH net-next 2/9] net: phy: Guard against the presenc=
e of a
> netdev
>=20
> On Thu, May 23, 2019 at 01:20:38AM +0000, Ioana Ciornei wrote:
> > A prerequisite for PHYLIB to work in the absence of a struct
> > net_device is to not access pointers to it.
> >
> > Changes are needed in the following areas:
> >
> >  - Printing: In some places netdev_err was replaced with phydev_err.
> >
> >  - Incrementing reference count to the parent MDIO bus driver: If there
> >    is no net device, then the reference count should definitely be
> >    incremented since there is no chance that it was an Ethernet driver
> >    who registered the MDIO bus.
> >
> >  - Sysfs links are not created in case there is no attached_dev.
> >
> >  - No netif_carrier_off is done if there is no attached_dev.
>=20
> Hi Ioana
>=20
> Looking at the functions changed here, they seem to be related to phy_att=
ach(),
> phy_connect(), and phy_detach() etc. Is the intention you can call these
> functions and pass a NULL pointer for the net_device?
>=20
> 	Andrew

Hi Andrew,

Yes, the intention is exactly to pass a NULL pointer for the  net_device fr=
om PHYLINK.
The changes that do this are in "[RFC,net-next,5/9] net: phylink: Add phyli=
nk_create_raw".

--
Ioana
