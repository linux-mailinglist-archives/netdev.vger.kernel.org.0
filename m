Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAC94D092
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 16:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731980AbfFTOkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 10:40:19 -0400
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:7380
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726758AbfFTOkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 10:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzzIh9LJUekQ1gBuhD/7eziHhO/VaA8LErdeV3LMZBI=;
 b=RgGYkP83zs41E1jZA3vORCHxrlgSupDQ4WXNViaG2sXHOFrlKmR8lh3AfFTyhp3lG44FQVzHkWO8OAG6n8tH/E/1rUweAU3R1dJcjlmnzwvcMCvQqWdu6FNViKTCGNN1es4UHNtn+hkc8n2P5QXYq/ikDJKuKFKSFTXF8oGmCEw=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2765.eurprd04.prod.outlook.com (10.175.20.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 20 Jun 2019 14:40:15 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 14:40:15 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Thread-Topic: [PATCH] net: phylink: set the autoneg state in
 phylink_phy_change
Thread-Index: AQHVIbKP9yXQ7A3ipUiyPT36szP9naadLumAgAAczwCAADEEAIAAj3sAgAaboRA=
Date:   Thu, 20 Jun 2019 14:40:15 +0000
Message-ID: <VI1PR0402MB28003F352AFC71FEB1524B71E0E40@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190615.133021.572699563162351841.davem@davemloft.net>
 <20190615221328.4diebpopfzyfi4og@shell.armlinux.org.uk>
 <20190615.180854.999160704288745945.davem@davemloft.net>
 <20190616094226.bnhivshhnzeokplu@shell.armlinux.org.uk>
In-Reply-To: <20190616094226.bnhivshhnzeokplu@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.26.252.192]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 318d7de2-cf04-42dc-ce84-08d6f58d359f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2765;
x-ms-traffictypediagnostic: VI1PR0402MB2765:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR0402MB2765713CC139272CACFC1267E0E40@VI1PR0402MB2765.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(396003)(366004)(39850400004)(136003)(51914003)(53754006)(189003)(199004)(64756008)(53936002)(68736007)(305945005)(9686003)(66476007)(186003)(76176011)(4326008)(76116006)(256004)(73956011)(26005)(476003)(6506007)(71190400001)(5660300002)(66446008)(71200400001)(14454004)(229853002)(14444005)(86362001)(52536014)(3846002)(102836004)(55016002)(6306002)(81156014)(316002)(966005)(66066001)(81166006)(446003)(110136005)(99286004)(25786009)(66946007)(33656002)(486006)(2906002)(6436002)(54906003)(7736002)(44832011)(8936002)(66556008)(11346002)(74316002)(478600001)(6246003)(8676002)(7696005)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2765;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GoqS6V79BN19ZPgKuAmAxNlCrm4TrX57HXTuklVWESGHPth8I5xaMKPxgiZ39w7lrYZAkClBQ638nJL+hbm2lXa/qmrw44ufQeZ2QJ7Xv5V6Hcp0jt55AGxQiUACVb/Jaz+yVIwiBWbcZPnLAMnHgKx4Rrjz4jMIYo2A3pw6eoVHHll0LiZ0m20fNhVl+5E+fG1G/2mmfnfFsaIRrElpmy5L6YKLhuVuN9ZqCAfRLfLVIPaWIW6l3O5vBN1rAD4UaL9RFbL49gKoVkbassTlJ0GbwZ/1BfrW4SspIMsT5Vo6OAyH2AIfOKWgcIrTsox1k1tpOorOdiLtGJYwXPCQB5vmZ+AzcavraeGwQqHB36rjNb1psXgQN3RyjkFfyM07Ho2NSHGvTYWzp0Cgzj/Ukzjf5mkqqRLFbEQMfBQUWZE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318d7de2-cf04-42dc-ce84-08d6f58d359f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 14:40:15.6561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2765
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH] net: phylink: set the autoneg state in phylink_phy_c=
hange
>=20
> On Sat, Jun 15, 2019 at 06:08:54PM -0700, David Miller wrote:
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Date: Sat, 15 Jun 2019 23:13:28 +0100
> >
> > > On Sat, Jun 15, 2019 at 01:30:21PM -0700, David Miller wrote:
> > >> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > >> Date: Thu, 13 Jun 2019 09:37:51 +0300
> > >>
> > >> > The phy_state field of phylink should carry only valid
> > >> > information especially when this can be passed to the .mac_config
> callback.
> > >> > Update the an_enabled field with the autoneg state in the
> > >> > phylink_phy_change function.
> > >> >
> > >> > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> > >> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > >>
> > >> Applied and queued up for -stable, thanks.
> > >
> > > This is not a fix; it is an attempt to make phylink work differently
> > > from how it's been designed for the dpaa2 driver.  I've already
> > > stated that this field is completely meaningless, so I'm surprised
> > > you applied it.
> >
> > I'm sorry, I did wait a day or so to see any direct responses to this
> > patch and I saw no feedback.
> >
> > I'll revert.
>=20
> Hi Dave,
>=20
> Thanks for the revert.  There was discussion surrounding this patch:
>=20
> https://www.mail-archive.com/netdev@vger.kernel.org/thrd2.html#302220=20
>=20
> It was then re-posted as part of a later RFC series ("DPAA2 MAC
> Driver") which shows why the change was proposed, where the discussion
> continued on Friday.  The patch ended up with a slightly different subjec=
t line.
>=20
> There is still further discussion required to try and work out a way forw=
ard.
>=20
> Thanks.
>=20

Hi all,=20

Sorry for not commenting on this until now but last weekend I had an unfort=
unate accident and ended up with a broken ankle. I'll start responding to a=
ll the emails and get back into this.

--
Ioana

