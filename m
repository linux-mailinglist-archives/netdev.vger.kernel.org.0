Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77282195E7E
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgC0TTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:19:02 -0400
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:44243
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726738AbgC0TTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 15:19:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iWkY+rFKJRZiegBKuLaRNV4uoP+lPeUlV/iuCon2ty8lOBbPmbGun/KHFg10RHiMT+7jhHVao5lVG11cBf4vBKP9pXJLKD4XGbxlQhSHO4uCOcnxKj09eW33dWQgrb6TQw5+571CmQp2O0nq6dEy+pZAGh1Y5+sUL4gNENVYtsvl/GUUiyifZpjtIvn6nw/vXq/c17M4NeiwdS3PlErga+lGnhXdLWoWQXjHh2NN9MMRUHzRyp59awERLUyI63Bs6BuN910flYC13gOMN2MWGVR2PjWq03tFns7c0p/3fy7X3ygCWwCJHaI8tClqM8rZ9yFR4brAgYStlfgacXxshw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3ofnNaLSVlHUV6SDaatBNjulkZGOwQ/fuPVrMvXaM4=;
 b=JnzeawwAOJMzfhQj6RqwKyCasKPx7EcN/ovIJORd2HnarlRKAZGiDSYoi5zaCG+7EYTu3Dq+0rPTVOUjWzNTXaWJKNRfk7HHW+f5L+f44w1nfwBytkLc4TTaahaenwexzE3GtIFVwNIaqBf4HiC1vCpLBGelg8SGeUEPULuyXZUhNDzI9Cg80wnkKHpKtb6rlBWH+rRzLTS5FlQyK2XrgQguRy7KxMvgcdMplA7u7Fh7qnxaXB17jg+Kw90cdqEXFZy6YCbpY7X9m+OLk35qHXANQjOGdbLZaTYaIpgxgkAEFgrmt5Sd+EhuCYPmBu0e37TKlb0UALaVsL8rrR5qIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3ofnNaLSVlHUV6SDaatBNjulkZGOwQ/fuPVrMvXaM4=;
 b=Vmy6k4z8Mbq2GIr/uQgWQqRP0prvo+zk/3sXt9kn6+X6QTA4nhUGOZAFVej7K6DmTr5rH4FTNwHkdiuWfLenHHVQOUAyDL7GnUhrWPosHg316u+bv2gBOHN0Ja1d0Bayh0Q+76Vu49iyGWmh6r5YX//MpFi6JNB5PbkP67AZYH0=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB5644.eurprd04.prod.outlook.com (20.179.9.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Fri, 27 Mar 2020 19:18:56 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::e44e:f867:d67:e901%2]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 19:18:56 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florinel Iordache <florinel.iordache@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/9] dt-bindings: net: add backplane dt bindings
Thread-Topic: [PATCH net-next 2/9] dt-bindings: net: add backplane dt bindings
Thread-Index: AdYEazypBGJuG/DbQbi/6Lky4CI1+w==
Date:   Fri, 27 Mar 2020 19:18:56 +0000
Message-ID: <DB8PR04MB68283F0268E43CCB882C236CE0CC0@DB8PR04MB6828.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [79.115.60.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2bd02b25-fbfc-4a7e-c14f-08d7d283b1e7
x-ms-traffictypediagnostic: DB8PR04MB5644:|DB8PR04MB5644:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB564440BCB14E8548DF717718E0CC0@DB8PR04MB5644.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(71200400001)(478600001)(6636002)(66446008)(66946007)(81166006)(64756008)(55016002)(66556008)(8936002)(316002)(52536014)(66476007)(8676002)(7416002)(81156014)(9686003)(5660300002)(4326008)(7696005)(44832011)(86362001)(26005)(2906002)(110136005)(76116006)(33656002)(6506007)(186003)(54906003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A4eUOsl0RTrgwH3PBvVOXeI5KIwiuZ/liTjL3H/v9SAxKcxY/cyFSNbrv5h60ZkItoon2efx300rgDd9I37jxM6cSf9euKxB05bMiwZvZSD/vprq2kd7BLb37YcT4/1wyEbLb8/Lu1n5u9vC+ivkoLzNXr2YQTUpREhKRIgP1Q6tbjDPFaPV8wPhys8lFmgfCZm4IWxN7zBUlkR0EjrAdw3tq5JENb4kfd89JHvfvabf2k+WMjeZbh96/BIhps41ZpccxZjLAQAUv+aUl3j3NIglwr8V7h5b3MocsT9EmqcmPlb6BXYP02ZGGrAuCP0WwBcXf0r8+HiT28pdWdeK8wHjhKKVoJLRs9UaJaLTK6yVPcOUV2jvMxgswSrMgexGbJmlclTUHMepQm/7v89uuDHBrxqdc/3X8dYEMwaFyhMgCUYhAdfI+d6pMvC4D3h7
x-ms-exchange-antispam-messagedata: xsq5VFjRXAwpsc6czgCBX92PhlNbqcA0TCgLROC46rcz3rx0q28rsO/WbnQUcxUD+fLxwoYmwdNAwUTSnbZO0T0zq9JPoHteXzoJtis6GJMMQ/FmLI7PHXSKxqCNapavkI7BbQgKiDzXHdVapk9rXw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd02b25-fbfc-4a7e-c14f-08d7d283b1e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 19:18:56.2184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TEHOiziWjPPER/4uJuguueNivADUSNiPK+i0nZPqfBE5rvBQZxyM2WM311x3Hra0n3LX/1xjH/O/BH20JOyblg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5644
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next 2/9] dt-bindings: net: add backplane dt
> bindings
>=20
> On Fri, Mar 27, 2020 at 03:00:22PM +0000, Florinel Iordache wrote:
> > > On Thu, Mar 26, 2020 at 03:51:15PM +0200, Florinel Iordache wrote:
> > > > Add ethernet backplane device tree bindings
> > >
> > > > +  - |
> > > > +    /* Backplane configurations for specific setup */
> > > > +    &mdio9 {
> > > > +        bpphy6: ethernet-phy@0 {
> > > > +            compatible =3D "ethernet-phy-ieee802.3-c45";
> > > > +            reg =3D <0x0>;
> > > > +            lane-handle =3D <&lane_d>; /* use lane D */
> > > > +            eq-algorithm =3D "bee";
> > > > +            /* 10G Short cables setup: up to 30 cm cable */
> > > > +            eq-init =3D <0x2 0x5 0x29>;
> > > > +            eq-params =3D <0>;
> > > > +        };
> > > > +    };
> > >
> > > So you are modelling this as just another PHY? Does the driver get
> > > loaded based on the PHY ID in registers 2 and 3? Does the standard
> > > define these IDs or are they vendor specific?
> > >
> > > Thanks
> > >         Andrew
> >
> > Hi Andrew,
> > Thank you all for the feedback.
> > I am currently working to address the entire feedback received so far
> > for this new Backplane driver.
> >
> > Yes, we are modelling backplane driver as a phy driver.
>=20
> I think we need to think very carefully about that, and consider whether =
that
> really is a good idea.  phylib is currently built primarily around copper=
 PHYs,
> although there are some which also support fiber as well in weird "non-
> standard" forms.
>=20
> What worries me is the situation which I've been working on, where we wan=
t
> access to the PCS PHYs, and we can't have the PCS PHYs represented as a p=
hylib
> PHY because we may have a copper PHY behind the PCS PHY, and we want to b=
e
> talking to the copper PHY in the first instance (the PCS PHY effectively =
becomes
> a slave to the copper PHY.)
>=20

We should think about the case when the PCS is the only transceiver on the =
local
board, as is happening in the backplane case, and the Ethernet driver does =
not
support phylink but rather phylib. By suggesting to not register the PCS wi=
th
phylib, you're effectively implying that the interface should operate as a =
fixed-link.
This PCS is shared for DPAA1 and DPAA2, and only one of those drivers uses =
phylink.

> My worry is that we're ending up with conflicting implementations for the=
 same
> hardware which may only end up causing problems down the line.
>=20
> Please can you look at my DPAA2 PCS series which has been previously post=
ed to
> netdev -

I had a go today with your DPAA2 PCS patches and tried to see how one could
extend your approach in order to use it in combination with quad PCSs.

As I mentioned yesterday, in case of QSGMII all the 4 PCSs sit on the first=
 MAC's
internal MDIO. This leads to an error in probing the second MAC from the gr=
oup
of 4 since the mdio_device_register() will fail when trying with the same i=
nternal
MDIO bus the second time.

I cannot see how this limitation can be overcome going forward if we still =
pass the
entire internal MDIO bus as a handle, as you are doing, and not just the sp=
ecific
PCS node as the current patch set is proposing.

> it's rather difficult to work out who in NXP should be copied, because
> that information is not visible to those of us in the community - we only=
 find that
> out after someone inside NXP posts patches, and even then the MAINTAINERS
> file doesn't seem to get updated.
>=20
> It's also worth mentioning that on other SoCs, such as Marvell SoCs, the =
serdes
> and "PCS" are entirely separate hardware blocks, and the implementation i=
n the
> kernel, which works very well, is to use the drivers/phy for the serdes/c=
omphy as
> they call it, and the ethernet driver binds to the comphy to control the =
serdes
> settings, whereas the ethernet driver looks after the PCS.  I haven't bee=
n able to
> look at your code enough yet to work out if that would be possible.
>=20
> I also wonder whether we want a separate class of MDIO device for PCS PHY=
s,
> just as we have things like DSA switches implemented entirely separately =
from
> phylib - they're basically different sub- classes of a mdio device.
>=20
> I think we have around 20 or so weeks to hash this out, since it's clear =
that the
> 10gbase-kr (10GKR) phy interface mode can't be used until we've eliminate=
d it
> from existing dts files.
>=20
> > The driver is loaded based on PHY ID in registers 2 and 3 which are
> > specified by the standard but it is a vendor specific value:
> > 32-Bit identifier composed of the 3rd through 24th bits of the
> > Organizationally Unique Identifier (OUI) assigned to the device
> > manufacturer by the IEEE, plus a six-bit model number, plus a four-bit
> > revision number.
> > This is done in the device specific code and not in backplane generic
> > driver.
> > You can check support for QorIQ devices where qoriq_backplane_driver
> > is registered as a phy_driver:
> >
> > @file: qoriq_backplane.c
> > +static struct phy_driver qoriq_backplane_driver[] =3D {
> > +	{
> > +	.phy_id		=3D PCS_PHY_DEVICE_ID,
> > +	.name		=3D QORIQ_BACKPLANE_DRIVER_NAME,
> > +	.phy_id_mask	=3D PCS_PHY_DEVICE_ID_MASK,
> > +	.features       =3D BACKPLANE_FEATURES,
> > +	.probe          =3D qoriq_backplane_probe,
> > +	.remove         =3D backplane_remove,
> > +	.config_init    =3D qoriq_backplane_config_init,
> > +	.aneg_done      =3D backplane_aneg_done,
> >
> > Here we register the particular phy device ID/mask and driver name
> > specific for qoriq devices.
> > Also we can use generic routines provided by generic backplane driver
> > if they are suitable for particular qoriq device or otherwise we can
> > use more specialized specific routines like:
> > qoriq_backplane_config_init
> >
>=20
> --

