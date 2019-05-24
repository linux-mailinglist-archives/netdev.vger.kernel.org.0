Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B2A2997D
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403933AbfEXNzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:55:33 -0400
Received: from mail-eopbgr40074.outbound.protection.outlook.com ([40.107.4.74]:56035
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403874AbfEXNzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:55:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AtdFBjF8/T5kMUZECFIp3JPuWb2NXOeBac+JP2x10c=;
 b=gTVoZShJGCo0bf5q4zVwl7it3CTeZLuumImSV4yq3gROfAVwbi6szzRuwYgy1y7KJIHcME4r5799pEfEaSutFVFwyaI5ALjwKow6HFY4zNcIuQOjd7NjrJdIcKA5ry+kQI4I7+gXnmrhpqrXGaO1f4+qB53UgWrsZQyLarlEm7o=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3775.eurprd04.prod.outlook.com (52.134.15.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 13:55:29 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 13:55:29 +0000
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
Thread-Index: AQHVEQW66VSOZj2NTUKIRdrxG/7Xx6Z5SOGAgADLNACAAC4UAIAACfTg
Date:   Fri, 24 May 2019 13:55:29 +0000
Message-ID: <VI1PR0402MB28006FBB7DD365147363553FE0020@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-3-ioana.ciornei@nxp.com>
 <20190523221835.GB21208@lunn.ch>
 <VI1PR0402MB280048FACD410AA6356B2410E0020@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190524131048.GA2979@lunn.ch>
In-Reply-To: <20190524131048.GA2979@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25c99d2f-e9ff-466c-4a81-08d6e04f7b60
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3775;
x-ms-traffictypediagnostic: VI1PR0402MB3775:
x-microsoft-antispam-prvs: <VI1PR0402MB3775F80394ACE58C54ADAC9AE0020@VI1PR0402MB3775.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(136003)(376002)(346002)(189003)(199004)(8936002)(81156014)(11346002)(81166006)(256004)(54906003)(8676002)(486006)(5024004)(68736007)(229853002)(33656002)(66556008)(71200400001)(71190400001)(4326008)(66476007)(5660300002)(6116002)(14454004)(66446008)(64756008)(76116006)(25786009)(66946007)(73956011)(476003)(74316002)(86362001)(478600001)(6436002)(66066001)(446003)(6506007)(7736002)(2906002)(102836004)(305945005)(186003)(6246003)(99286004)(3846002)(7696005)(44832011)(76176011)(26005)(9686003)(316002)(53936002)(55016002)(52536014)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3775;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BkkVFwWIC8m8WGeLEoOSctS/isPa6Lti9M33Vx35jkJNo9aZyVX5eUiHsRd4jDX4N/ReGZYB+P9MSS0qbkVA4faPd7BfKO98OcvYUQva6Mh4VA7otvl8Whwt24FJ7L7dE8pS5ClXBJSg9dFhyWzluMUr3MiGvFvFXNCROXiEXlgQ/ssvrAKFwvA46kqlwfqFdGx/THF0vQgFc7DdthuFQ+EBP7o7nyf2iDoHprx0RaF5lhBRG2qsrXI5gutRHRv9eLK1aRyX5bhJnTDGgNl+EXjY5YUeHnBgv3Y+Ltv8ZGNqVjwahvkmVlTsjozDkIOpclmHsCNg2v8W0IYMYJNwHf1w5LL48O+47hau9gHwQkxGRTJDuMDZ+e84miTY+R5cC7odwXm8mtNHzB/mrxaThJqXc9iksbPfcfJNlj5ODmQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c99d2f-e9ff-466c-4a81-08d6e04f7b60
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 13:55:29.5329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3775
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [RFC PATCH net-next 2/9] net: phy: Guard against the presenc=
e of a
> netdev
>=20
> > > Hi Ioana
> > >
> > > Looking at the functions changed here, they seem to be related to
> > > phy_attach(), phy_connect(), and phy_detach() etc. Is the intention
> > > you can call these functions and pass a NULL pointer for the net_devi=
ce?
> > >
> > > 	Andrew
> >
> > Hi Andrew,
> >
> > Yes, the intention is exactly to pass a NULL pointer for the  net_devic=
e from
> PHYLINK.
> > The changes that do this are in "[RFC,net-next,5/9] net: phylink: Add
> phylink_create_raw".
>=20
> Hi Ioana
>=20
> I think in general, we don't want MAC drivers doing this.
>=20

Agreed.

> We should enforce that the general APIs get a netdev. PHYLINK uses
> phy_attach_direct() which is the lowest level of these attach() and
> connect() calls. And there is only one MAC driver using phy_attach_direct=
(). So
> please add checks for the netdev and return -EINVAL in these higher level=
 callers
> to phy_attach_direct().
>=20

Will add the checks in v2.

--
Ioana
