Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1B3C437EA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732530AbfFMPB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:01:56 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:43534
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732522AbfFMOcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWCj32etC61wpg4nzdc5w1MsWIwQWofLo41Kdkz9zHM=;
 b=sp/mFwuhPKqTXQOGt6j4q+m9BhZQCsl+r8fepuhDOKft6+M2DgKoqAiToMeIW/pcK5lvjBF7BtqQSktrxDDxnJUcOnVAlYR/1IIxjrGYtyYyZ3w5Jbw+R02IxWF3OUJiUWQXuJalzhuQ0hcOx6S645S1ttlYlr4W2nJOdXcoMj0=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2845.eurprd04.prod.outlook.com (10.175.23.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 14:32:06 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::714d:36e8:3ca4:f188%3]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 14:32:07 +0000
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
Thread-Index: AQHVIbKP9yXQ7A3ipUiyPT36szP9naaZPIMAgAAIqNCAAA3egIAATeZg
Date:   Thu, 13 Jun 2019 14:32:06 +0000
Message-ID: <VI1PR0402MB28005B0C87815A58789B8B04E0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
 <20190613081400.2cicsjpslxoidoox@shell.armlinux.org.uk>
 <VI1PR0402MB2800B6F4FC9C90C96E22979AE0EF0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190613093437.p4c6xiolrwzikmhq@shell.armlinux.org.uk>
In-Reply-To: <20190613093437.p4c6xiolrwzikmhq@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3027202-1093-40f9-27a4-08d6f00be962
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2845;
x-ms-traffictypediagnostic: VI1PR0402MB2845:
x-microsoft-antispam-prvs: <VI1PR0402MB2845BD7F20C42DDA394F4330E0EF0@VI1PR0402MB2845.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(346002)(136003)(376002)(199004)(189003)(305945005)(476003)(11346002)(44832011)(71200400001)(71190400001)(446003)(486006)(14454004)(6916009)(54906003)(316002)(4326008)(74316002)(68736007)(25786009)(33656002)(8676002)(81156014)(2906002)(81166006)(6246003)(256004)(229853002)(14444005)(55016002)(99286004)(53936002)(6436002)(3846002)(6116002)(5660300002)(52536014)(9686003)(7696005)(86362001)(8936002)(7736002)(26005)(66476007)(66556008)(64756008)(66446008)(73956011)(66946007)(102836004)(66066001)(478600001)(186003)(6506007)(76176011)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2845;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VBmNFI3F6LWbXtTbwFgFmZOKtT+UrdC27grp6yZ1YPWe2EZkvpZpxV0QBOfPyVvcBc6sdDrW+JWKOWwP2tw4gzaAkMAExAOT1BPnu2IQbPssriu0qC5SznLZlD04M7BNqlLfyrOGTkgD4Dj9NjqCRK8ud6i5ommwcEmInTYjd8alruYdffPdI1pkMOb31sxs9M+iF+/H7fP+H54uYK0BQmMtGPSSSyoZ5ONjyCQTXFTJhLxToWg3tVrzNb5L9mO7sUXG+h94wEJMs0yaRq0+dqD9ImF92tYEb7VrmKw9uB9ypdK2faHMGd4ycYyKpRVqKY0qM/ymdcs7nJ17+nadWmjZto02JZBDbw3FfquMEuP4xI5yU7VvSa90W/nm3jfvCAVRoSZTPBMCwsmSB8SlgOu/FD+aEw3/CF2yrAmSAUY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3027202-1093-40f9-27a4-08d6f00be962
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:32:06.8582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH] net: phylink: set the autoneg state in
> phylink_phy_change
>=20
> On Thu, Jun 13, 2019 at 08:55:16AM +0000, Ioana Ciornei wrote:
> > > Subject: Re: [PATCH] net: phylink: set the autoneg state in
> > > phylink_phy_change
> > >
> > > On Thu, Jun 13, 2019 at 09:37:51AM +0300, Ioana Ciornei wrote:
> > > > The phy_state field of phylink should carry only valid information
> > > > especially when this can be passed to the .mac_config callback.
> > > > Update the an_enabled field with the autoneg state in the
> > > > phylink_phy_change function.
> > >
> > > an_enabled is meaningless to mac_config for PHY mode.  Why do you
> > > think this is necessary?
> >
> > Well, it's not necessarily used in PHY mode but, from my opinion, it sh=
ould
> be set to the correct value nonetheless.
> >
> > Just to give you more context, I am working on adding phylink support o=
n
> NXP's DPAA2 platforms where any interaction between the PHY
> management layer and the Ethernet devices is made through a firmware.
> > When the .mac_config callback is invoked, the driver communicates the
> new configuration to the firmware so that the corresponding net_device ca=
n
> see the correct info.
> > In this case, the an_enabled field is not used for other purpose than t=
o
> inform the net_device of the current configuration and nothing more.
>=20
> The fields that are applicable depend on the negotiation mode:
>=20
> - Non-inband (PHY or FIXED): set the speed, duplex and pause h/w
>    parameters as per the state's speed, duplex and pause settings.
>    Every other state setting should be ignored; they are not defined
>    for this mode of operation.
>=20
> - Inband SGMII: set for inband SGMII reporting of speed and duplex
>    h/w parameters.  Set pause mode h/w parameters as per the state's
>    pause settings.  Every other state setting should be ignored; they
>    are not defined for this mode of operation.
>=20
> - Inband 802.3z: set for 1G or 2.5G depending on the PHY interface mode.
>    If an_enabled is true, allow inband 802.3z to set the duplex h/w
>    parameter.  If an_enabled and the MLO_PAUSE_AN bit of the pause
>    setting are true, allow 802.3z to set the pause h/w parameter.
>    Advertise capabilities depending on the 'advertising' setting.
>=20
> There's only one case where an_enabled is used, which is 802.3z negotiati=
on,
> because the MAC side is responsible for negotiating the link mode.  In al=
l
> other cases, the MAC is not responsible for any autonegotiation.

It's clear for me that an_enabled is of use for the MAC only when clause 37=
 auto-negotiation is used.

However,  the DPAA2 software architecture abstracts the MAC and the network=
 interface into 2 separate entities that are managed by two different drive=
rs.
These drivers communicate only through a firmware.

This means that any ethtool issued on a DPAA2 network interface will go dir=
ectly to the firmware for the latest link information.
When the MAC driver is not capable to inform the firmware of the proper lin=
k configuration (eg whether the autoneg is on or not), the ethtool output w=
ill not be the correct one.

>=20
> It is important to stick to the above, which will ensure correct function=
ing of
> your driver - going off and doing your own thing (such as reading from ot=
her
> fields) is not guaranteed to give good results.
>=20

You're right, but unfortunately I am not dealing with a straight-forward ar=
chitecture.=20

--
Ioana

> >
> > --
> > Ioana
> >
> >
> > >
> > > >
> > > > Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > ---
> > > >  drivers/net/phy/phylink.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > > index 5d0af041b8f9..dd1feb7b5472 100644
> > > > --- a/drivers/net/phy/phylink.c
> > > > +++ b/drivers/net/phy/phylink.c
> > > > @@ -688,6 +688,7 @@ static void phylink_phy_change(struct
> > > > phy_device
> > > *phydev, bool up,
> > > >  		pl->phy_state.pause |=3D MLO_PAUSE_ASYM;
> > > >  	pl->phy_state.interface =3D phydev->interface;
> > > >  	pl->phy_state.link =3D up;
> > > > +	pl->phy_state.an_enabled =3D phydev->autoneg;
> > > >  	mutex_unlock(&pl->state_mutex);
> > > >
> > > >  	phylink_run_resolve(pl);
> > > > --
> > > > 1.9.1
> > > >
> > > >
> >
> >
>=20

