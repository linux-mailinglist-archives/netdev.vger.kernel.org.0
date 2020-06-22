Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A632036E4
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgFVMfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:35:11 -0400
Received: from mail-eopbgr80070.outbound.protection.outlook.com ([40.107.8.70]:10734
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbgFVMfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 08:35:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiJm6QO8yJ8KMOwyVGU4l2pBrSQEMyj0iGc4qYcKjZMxEZLCBBpMn4TyOUhc+mw7M97pZziJN/g1sMF/txAdf5kppewYSmZj59HbZ37zMCHjg0nmnfK9gX4Frc9FoWEY1tWvlNuOgnExrBbVDxfRFHtyqBGCUzXdzlM8p6bdDwvvtCug3jpsYCDwRQG3fOCPp4Lmjug+t5kwBuIdqvcd5vZus8tCYn9pbfo6eDKrQ24v2MqZZjFyY5MT8BBohWjYLpk3RGmpzXDA8Xv4jHYKsCrsQkpVcxE6AUXSo7IroqVvmTX3QP5fMUmuLEXRWMMRNggHJc2nKaaCr/nvSRLo8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShMWyqtOole/xyU76SInN7Q1i6PtFByRgTaI+Ga5oAE=;
 b=ETZliuzvE28nZD6ZyMCy31KYjx7AS2mdIm5pbroH6RnOxs9ZVO2pk+i+YUk2E0TgoI8BxmikeHKmLgeN1NrMMzvCo7j2aVG/pEDFKackrx0xSvj2joANxEw3xEjxAzzl7pNSjy8ouqRtuAkl5Fu3kwI2BK2F2qxbu5zD7GBwW7n9TDYTVJdIVdpe8f43L82QI5ncyhk7pam/0YOGuqHrnhKrdW5QpLk2MxBsYfgrEk4oKh4hUSZPPNtGmUZNwWZF2Z52e/YtqY1Ig3urVnzGfmJuhfT7P8DVx0jP+PmjfY2RB7cbTUyoK9tE9TuBITje/NLIzZ0v2bpLvbJIINqDNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ShMWyqtOole/xyU76SInN7Q1i6PtFByRgTaI+Ga5oAE=;
 b=jEk9kD7P64RrxOFXiLe0kRWoE6H93285G6AP6IfaP8KGkG2Ox6Eo6AxBL5t//Rz0mjMr4qqFy00J6piuz9u5lkv3eUml2O+E+Me0nHkR6THU3ryxuMXlAWQnZWMLYaIyawZL5cuxyxdBONrnRa6wmjH0/GtwGYDPF3iVdz/Pho4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3837.eurprd04.prod.outlook.com
 (2603:10a6:803:25::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 12:35:07 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 12:35:07 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: RE: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pcs_ops
Thread-Topic: [PATCH net-next v3 5/9] net: dsa: add support for
 phylink_pcs_ops
Thread-Index: AQHWSB8ioI+cI4qHb0G+pa0hKk9LCqjkbb+AgAANnYCAABI4gIAAAfBQ
Date:   Mon, 22 Jun 2020 12:35:06 +0000
Message-ID: <VI1PR0402MB3871B441D15250A8970DD5A4E0970@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-6-ioana.ciornei@nxp.com>
 <20200622102213.GD1551@shell.armlinux.org.uk>
 <20200622111057.GM1605@shell.armlinux.org.uk>
 <20200622121609.GN1605@shell.armlinux.org.uk>
In-Reply-To: <20200622121609.GN1605@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ece6917-37ae-41fb-e835-08d816a8b208
x-ms-traffictypediagnostic: VI1PR0402MB3837:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3837A0DF36DE77B89A5CF38EE0970@VI1PR0402MB3837.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: prEiwh3Hg7c4rql2LkKJFCG3jEfKetD8cQEICxd0aTZS9F8/zYyudIzhKBY16PuM/CquF+JcmjUttAFgbNNVQlPnVk4/Jf5fuBYqhyaX+N5uJ7zgxjZzWZXxiqmQVop7LtuLXy25HJPtdJw4q+kK5lWTanEY3hO+2Hk1zy4Ec7O/I3d4g7Ou4oo+/lFS8SSL8sG6sc8C81Yhz7zTBjstA35EZ8i27jCBWq/w1KoP44O23ZVXNYjghsdLa9NO2vYQxBpx2CnEEa4OVg1Bfu5+4+JXEDx8zKLaT6SZpmuJ56ZYfBPJZTkaUMhlQQ53LXtka3wHHgTAcrUsMSzuj3Lk8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(5660300002)(55016002)(478600001)(8676002)(8936002)(2906002)(83380400001)(6506007)(186003)(71200400001)(9686003)(26005)(33656002)(66946007)(7696005)(52536014)(44832011)(4326008)(316002)(54906003)(66446008)(66476007)(86362001)(64756008)(66556008)(76116006)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: JOBquDRguhpfyQJ8hjfefKop/vhhmV+czf9xJJagl4fp9TN39OU27G7KBZTgM9/Bz4hWXowwRcGtfXnfO0pWHHnI27HFCeOKCpfdTWisf8lYga98xcxH5AB9ZxBR9d1rL/7xk0+rp1QpCHo+utzUZ3yRpsq0npBg+2Q0mti4i6CXXwAeq5iOUBhuGTSLd1OTtPUyzxEF9IS2akVU/wzD5QCSSqqrqGJn8W0+hn4TtePe/JrCBiwlo0vmG/F/ep/oH0W25bDFa06o6xkwJLR5ElMgbNMxgOTFz5AGKdQEXRzxNyb19b2HErnXysNLiY3HuzSgj3DpeCybf8rBo7XAbhuDfGLqj8sPuTPk9yi81klZdEc5EX0ViwmKoRpr9m/PwumT4zRJGvsuKUg1JjzbkuF6nUd9O9KtiJr1N2O1XkELXf+GLrOahhFcLD4QsaOCiFe5CjaDzBmsNA/XwYF0+9cz+TVl1OEPvWjISYHPArE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ece6917-37ae-41fb-e835-08d816a8b208
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 12:35:06.8940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8c5O55xtLm5bHtLcz7l4bE1IEBypFmzgafzkSbsASYMJTIuw/dYw9H8G54IrCqpodCMInAYo3oEqk3Lv30x8Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3837
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next v3 5/9] net: dsa: add support for phylink_pc=
s_ops
>=20
> On Mon, Jun 22, 2020 at 12:10:57PM +0100, Russell King - ARM Linux admin
> wrote:
> > On Mon, Jun 22, 2020 at 11:22:13AM +0100, Russell King - ARM Linux admi=
n
> wrote:
> > > On Mon, Jun 22, 2020 at 01:54:47AM +0300, Ioana Ciornei wrote:
> > > > In order to support split PCS using PHYLINK properly, we need to
> > > > add a phylink_pcs_ops structure.
> > > >
> > > > Note that a DSA driver that wants to use these needs to implement
> > > > all 4 of them: the DSA core checks the presence of these 4
> > > > function pointers in dsa_switch_ops and only then does it add a
> > > > PCS to PHYLINK. This is done in order to preserve compatibility
> > > > with drivers that have not yet been converted, or don't need, a spl=
it PCS
> setup.
> > > >
> > > > Also, when pcs_get_state() and pcs_an_restart() are present, their
> > > > mac counterparts (mac_pcs_get_state(), mac_an_restart()) will no
> > > > longer get called, as can be seen in phylink.c.
> > >
> > > I don't like this at all, it means we've got all this useless
> > > layering, and that layering will force similar layering veneers into
> > > other parts of the kernel (such as the DPAA2 MAC driver, when we
> > > eventually come to re-use pcs-lynx there.)
> > >

The veneers that you are talking about are one phylink_pcs_ops structure
and 4 functions that call lynx_pcs_* subsequently. We have the same thing
for the MAC operations.

Also, the "veneers" in DSA are just how it works, and I don't want to chang=
e
its structure without a really good reason and without a green light from
DSA maintainers.

> > > I don't think we need that - I think we can get to a position where
> > > pcs-lynx is called requesting that it bind to phylink as the PCS,
> > > and it calls phylink_add_pcs() directly, which means we do not end
> > > up with veneers in DSA nor in the DPAA2 MAC driver - they just need
> > > to call the pcs-lynx initialisation function with the phylink
> > > instance for it to attach to.

What I am most concerned about is that by passing the PCS ops directly to t=
he
PCS module we would lose any ability to apply SoC specific quirks at runtim=
e
such as errata workarounds.

On the other hand, I am not sure what is the concrete benefit of doing it y=
our way.
I understand that for a PHY device the MAC is not involved in the call path=
 but in the
case of the PCS the expectation is that it's tightly coupled in the silicon
and not plug-and-play.

- Ioana

> > >
> > > Yes, that requires phylink_add_pcs() to change slightly, and for
> > > there to be a PCS private pointer, as I have previously stated.  At
> > > the moment, changing that is really easy - the phylink PCS backend
> > > has no in-tree users at the moment.  So there is no reason not to
> > > get this correct right now.
> >
> > How about something like this?  I don't want to embed a mdio_device
> > inside struct phylink_pcs because that would not be appropriate for
> > some potential users (e.g., Marvell 88E6xxx DSA drivers, Marvell NETA,
> > PP2, etc.)
>=20
> Just to be clear, I'm expecting discussion on this approach, rather than =
a patch
> series appearing - I've already tweaked this patch slightly, adding a "po=
ll" option
> to cater for the "pcs_poll" facility that was introduced into the phylink=
_config
> structure - which I think makes more sense here, as it's all part of the =
PCS.
>=20
> I'd like there to be some concensus _before_ I go through the users I hav=
e in my
> tree converting them to this, rather than converting them, and then havin=
g to
> convert them to something else.
>=20
> So, if we can agree on what this should look like, then I feel it would m=
ake the
> development process a lot easier for everyone concerned.
>=20

