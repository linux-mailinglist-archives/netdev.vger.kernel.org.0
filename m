Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4684376E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbfFMO6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 10:58:55 -0400
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:5822
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732628AbfFMO4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+WdjLwPEYv/CG5NGDhgBFWh/OqzUuDDyozDVaj8og4=;
 b=Z0HMQ1vUscFk1kJaq20rB8PPRlNgLFKnFDsLZW3GBXDar/JpXQkgZgttzeq6R4zONfxuCir5sLfrpAwbEkBWyCUzTEed9G86WNzn/+89o0idLHXDPry8xBKANUXoigRwyJyBCSS5VB++D53oVG6JIfkJSh+y21TdgVxKn0XK5iI=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2783.eurprd04.prod.outlook.com (10.172.255.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 14:56:01 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 14:56:01 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: phylink: set the autoneg state in phylink_phy_change
Thread-Topic: [PATCH] net: phylink: set the autoneg state in
 phylink_phy_change
Thread-Index: AQHVIbKP9yXQ7A3ipUiyPT36szP9naaZPIMAgAAIqNCAAA3egIAATeZggAAH6ICAAANgwA==
Date:   Thu, 13 Jun 2019 14:56:01 +0000
Message-ID: <VI1PR0402MB28008D841D50843C0212FBFBE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190613081400.2cicsjpslxoidoox@shell.armlinux.org.uk>
 <VI1PR0402MB2800B6F4FC9C90C96E22979AE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190613093437.p4c6xiolrwzikmhq@shell.armlinux.org.uk>
 <VI1PR0402MB28005B0C87815A58789B8B04E0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190613144143.lx54zqh5qg47cead@shell.armlinux.org.uk>
In-Reply-To: <20190613144143.lx54zqh5qg47cead@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a588e970-52e0-44b9-b3d2-08d6f00f4053
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2783;
x-ms-traffictypediagnostic: VI1PR0402MB2783:
x-microsoft-antispam-prvs: <VI1PR0402MB27832AD911293D92DB276EE1E0EF0@VI1PR0402MB2783.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(39860400002)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(52536014)(99286004)(73956011)(2906002)(66946007)(66476007)(66556008)(64756008)(66446008)(186003)(26005)(76116006)(478600001)(14454004)(6506007)(102836004)(76176011)(7696005)(86362001)(6916009)(5660300002)(3846002)(6116002)(14444005)(66066001)(8936002)(11346002)(71200400001)(71190400001)(446003)(81166006)(68736007)(81156014)(8676002)(7736002)(305945005)(33656002)(229853002)(44832011)(476003)(486006)(4326008)(74316002)(6436002)(6246003)(256004)(55016002)(9686003)(316002)(25786009)(53936002)(54906003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2783;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ka25ShJsowLZIoryCHm3frIfeDT05JKh8jfL4aLacZBl/vszsLJOlB7mHub1IOhmdGOj4QvHzenlPG0mKOKULQy9n3CVyFs55qj2VURmA2E0r7wgmAIx+nPzHnIt2ZrsgmOTBKZtFF3KIWdN5P5qojf9mfEfnpykqbznBrBvTmn5kEk3xR5ZsaFwQFk0l08UjE+B8hnyZIbsAf6TIFBq8Dfxx+iBqI0bNZRml4iwz2uEHiW2Vh+07pvrOThgf0bkU3L1OW3SjukPCLIjv2xAjE8sO/sIh8w5mLXCExY25CpDv1CJsyNxL4FDVpN3WDrDKC1B3hSQaLGfawQgA43oi1kB3hW0aPUEp7WSBiKe/YPvWmc3YpVoEwkpZBOWMfJbhFr4ojqph1xrSvpBsBeiFNpV5EgRFDTg596SvB1IZwA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a588e970-52e0-44b9-b3d2-08d6f00f4053
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:56:01.2515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2783
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH] net: phylink: set the autoneg state in
> phylink_phy_change
>=20
> On Thu, Jun 13, 2019 at 02:32:06PM +0000, Ioana Ciornei wrote:
> >
> > > Subject: Re: [PATCH] net: phylink: set the autoneg state in
> > > phylink_phy_change
> > >
> > > On Thu, Jun 13, 2019 at 08:55:16AM +0000, Ioana Ciornei wrote:
> > > > > Subject: Re: [PATCH] net: phylink: set the autoneg state in
> > > > > phylink_phy_change
> > > > >
> > > > > On Thu, Jun 13, 2019 at 09:37:51AM +0300, Ioana Ciornei wrote:
> > > > > > The phy_state field of phylink should carry only valid
> > > > > > information especially when this can be passed to the .mac_conf=
ig
> callback.
> > > > > > Update the an_enabled field with the autoneg state in the
> > > > > > phylink_phy_change function.
> > > > >
> > > > > an_enabled is meaningless to mac_config for PHY mode.  Why do
> > > > > you think this is necessary?
> > > >
> > > > Well, it's not necessarily used in PHY mode but, from my opinion,
> > > > it should
> > > be set to the correct value nonetheless.
> > > >
> > > > Just to give you more context, I am working on adding phylink
> > > > support on
> > > NXP's DPAA2 platforms where any interaction between the PHY
> > > management layer and the Ethernet devices is made through a firmware.
> > > > When the .mac_config callback is invoked, the driver communicates
> > > > the
> > > new configuration to the firmware so that the corresponding
> > > net_device can see the correct info.
> > > > In this case, the an_enabled field is not used for other purpose
> > > > than to
> > > inform the net_device of the current configuration and nothing more.
> > >
> > > The fields that are applicable depend on the negotiation mode:
> > >
> > > - Non-inband (PHY or FIXED): set the speed, duplex and pause h/w
> > >    parameters as per the state's speed, duplex and pause settings.
> > >    Every other state setting should be ignored; they are not defined
> > >    for this mode of operation.
> > >
> > > - Inband SGMII: set for inband SGMII reporting of speed and duplex
> > >    h/w parameters.  Set pause mode h/w parameters as per the state's
> > >    pause settings.  Every other state setting should be ignored; they
> > >    are not defined for this mode of operation.
> > >
> > > - Inband 802.3z: set for 1G or 2.5G depending on the PHY interface mo=
de.
> > >    If an_enabled is true, allow inband 802.3z to set the duplex h/w
> > >    parameter.  If an_enabled and the MLO_PAUSE_AN bit of the pause
> > >    setting are true, allow 802.3z to set the pause h/w parameter.
> > >    Advertise capabilities depending on the 'advertising' setting.
> > >
> > > There's only one case where an_enabled is used, which is 802.3z
> > > negotiation, because the MAC side is responsible for negotiating the
> > > link mode.  In all other cases, the MAC is not responsible for any
> autonegotiation.
> >
> > It's clear for me that an_enabled is of use for the MAC only when claus=
e 37
> auto-negotiation is used.
> >
> > However,  the DPAA2 software architecture abstracts the MAC and the
> network interface into 2 separate entities that are managed by two differ=
ent
> drivers.
> > These drivers communicate only through a firmware.
> >
> > This means that any ethtool issued on a DPAA2 network interface will go
> directly to the firmware for the latest link information.
>=20
> So you won't be calling phylink_ethtool_ksettings_get(), which means you
> won't be returning correct information anyway.
>=20
> > When the MAC driver is not capable to inform the firmware of the proper
> link configuration (eg whether the autoneg is on or not), the ethtool out=
put
> will not be the correct one.
>=20
> You don't get to know the list of supported link modes, so I don't see ho=
w
> the ethtool information can be correct.
>=20
> I'd like to see the patches _before_ I consider accepting your proposed
> phylink change.

Sure. I'll send an RFC as soon as possible.

>=20
> > > It is important to stick to the above, which will ensure correct
> > > functioning of your driver - going off and doing your own thing
> > > (such as reading from other
> > > fields) is not guaranteed to give good results.
> >
> > You're right, but unfortunately I am not dealing with a straight-forwar=
d
> architecture.
>=20
> At this point, I think you need to explain why you want to use phylink, a=
s you
> seem to be saying that your driver is unable to conform to what phylink
> expects due to firmware.

That's going to be in the cover letter.

--
Ioana
