Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C69343E441
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhJ1OyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:54:17 -0400
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:54241
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230258AbhJ1OyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:54:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPgoyzh3RXAPCwldOUVY2Q9uyblkfj9S2VuSxeuiD7EkN+WOBLHkXxRCb10mj7gpmQPKTuWThcEmB1/DffHAHOxTJvkt4Z99CZJcylU4RNEQuF2reJHQByTwdgM2wXzR88L1DeDhZQ0BE4JJmqBJnfgfkkDA3VdWq0liM7duv1uX9Hv9qp455ea9ZkDqfI8kIRIkK4KdaHigJj4L1VmPBLBMjbRCboxo/DwpqdjsEuuDC5ZDd5GWlpTs350DMlV17qUMhQiVDNQbgSpSquBA8TinwQ+NcdfznPrV3G/jWvPfvM8OTIxD1i+q555MQSbv1FyRGdCnuHbe6XCjwvi3Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Js1dWL36ADUq0uShb7jNMEIHELKAZMeYPM/bTlVLYVA=;
 b=DUO7LMwMGKek0IGJyD457y9vnGqewzvv6olDD9/d9LEP85Eh+2/m9rMsoUu4ljP81XedPOTiptjht3LJlbedX1IGnyK6V3j2DrzCfwjB453S++tQab2wRNW99uSSbuXa51txCVJALc1k6mc5z/omRlQRRGbkMpgeutYhqjYxASuLYAc4pjw0rIeQ71lJWaE/c01ystPwcPsabkLnbUPSXQ7IbwVCJtIP9LMQfYd6nW1CsExw7lLb4rwgbmdk2ikI87QxH5NK97RuxdZcfeme6r/H/WCrr9O7kVX3bPsA8eRX9b/py+12mOHANRvnXqTQs9CVdf1TSsO4r1cNBNgrAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Js1dWL36ADUq0uShb7jNMEIHELKAZMeYPM/bTlVLYVA=;
 b=MgIqRhfa2CY/IoIFYRCLqN5i/IVrwp6XXSpj6Bke1ohF9t/zh1VhIRZpgEeWBCNXl2RtZFl6REAKKdp+ovEQNKicpwv9TIXf876cgm4hMa5ZggwLYiA4njL1IW2+mtKy1oo73jBlgEi8d7laQh6xKf7QiaYEL6Mlar+yerju2A4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Thu, 28 Oct
 2021 14:51:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 14:51:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Topic: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Index: AQHXzALaBu1tOZHr/E6Z7NAaubhTaKvoceaAgAACkQCAAAIaAIAABFaAgAADtgA=
Date:   Thu, 28 Oct 2021 14:51:43 +0000
Message-ID: <20211028145142.xjgd3u2xz7kpijtl@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
 <20211028134932.658167-2-clement.leger@bootlin.com>
 <20211028140611.m7whuwrzqxp2t53f@skbuf> <20211028161522.6b711bb2@xps-bootlin>
 <20211028142254.mbm7gczhhb4h5g3n@skbuf> <20211028163825.7ccb1dea@xps-bootlin>
In-Reply-To: <20211028163825.7ccb1dea@xps-bootlin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 430e1969-9683-4938-a963-08d99a227554
x-ms-traffictypediagnostic: VI1PR04MB5854:
x-microsoft-antispam-prvs: <VI1PR04MB58548EE781DF06929207AE40E0869@VI1PR04MB5854.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: enoEI5SxhziKna3H2SiYHRRlv9HmNv003PY3nr8AK7vOr1Ef8eOu5eAJx61gEchZWCS+/C83Gp339zP//n0USSjwQ3iQZJOBiMxn8oChFCJQpVv77OxKjN8Ycpv5rWy1UcPryBL7hd8yTTeHSqihU6wdIoxG3MZlKNdo8PfgyV71LOZHSUwSuW8HUqQOIL+FkGw5dRMePNL0pMp4OwvQ6vjA7I4jx28AWSSV49Cbei/P4i5JDM18aqt/hz8yXPjIy5rncHVBVMW/OqMwPu46Ybnq9Zov5XlPvH5cl6902rOcTQXTFvPaalCuB6BOH8s1yc3txps8ROWZYEA+Y1OjpFEJvrWkhe27S3ZloMhli7fOsCnn0JdbUJZ7VUtJK7urvM46giKz6w6GsLLeDNsWHblP5X5lCLekELBxWn+pv/I5FPHycUWb4oeM9Wi0cMSGmdjoR92IMpSWXHJoimAmbJuKvMqB/C5QKPF3EBVzkXDTSIzhYLY3ZwV6D1WuJ+TCCuLAuYcTYSOgmgeMInIkUOL6UpnkafYBlvDNvdlRtMJx9Qo2cj31acOjqVs4PLkQHbqMI0O1/ErGTE2auvvSbT3LhpsqZvEt6o6WkvKvuNztH7I8B4k9I8jY0N/Oo8KcOVaU7Ba2Eb9Cl5eHBZOp6jVDTYx20uLcOaseV65raufxdNRw2x7biXEUUIPH2XUmJQWS7DyTbbKr798bMtzGzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66946007)(66574015)(316002)(26005)(7416002)(44832011)(508600001)(186003)(6916009)(8676002)(66556008)(66476007)(91956017)(66446008)(83380400001)(64756008)(5660300002)(76116006)(1076003)(6486002)(86362001)(9686003)(54906003)(8936002)(71200400001)(38100700002)(6512007)(122000001)(33716001)(6506007)(38070700005)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/VLOOY7uH6hj2MWLN2p2+hjo25Iq4k35TCyKUG1hFiEuSxGeF0GD5HFDfO?=
 =?iso-8859-1?Q?K/X++l27axXTyc0BANeNWiLDEBzfAyjZIy0UVu5wHrjR7SQQQXXBpWTbXW?=
 =?iso-8859-1?Q?uO1EJQ2JsIE4Tdf4nbErU7L3xlDYXAym/sPlMupN8ffsFfXuERb6auYLqA?=
 =?iso-8859-1?Q?ja6z3FxC30aFR4+fSeGQCg6AkSteeEOnbs5s/CFMfeVUnFwm5jcH2+YgQw?=
 =?iso-8859-1?Q?5CO5aAIhrbwwre5MXLrgitag+aeitgK8oNi6SI4mAKmKgudGe3KYw1muZ1?=
 =?iso-8859-1?Q?kl1LHsuo9DuS6+UeonjwgS5Warvk1OkEZRAUHDC+cr7znrT/VpZB7KmLgT?=
 =?iso-8859-1?Q?NVbOL4awnEsKftzm58HEniyuGyAlHTOCu6a8qDssO3R5LS7PA/Ximlh6R/?=
 =?iso-8859-1?Q?eKWQ8YZ/f2G4YiTHraQ6SFgQ5d0fl0nhEVgtZGklozKdfTPdfE0UAaMaL1?=
 =?iso-8859-1?Q?MwuLl1rt5aTOfdarAc91avcEqYUpMIviWZpGoxD6lwJQuOYo79g8cLDvJD?=
 =?iso-8859-1?Q?nP/cIOXgSLJhhwLmCvoKrFPen2rOxog1jW+eeHj3BWhhbaVYWbMfFIdUh9?=
 =?iso-8859-1?Q?lIWNnh7zFtyeV/9lmtYb9f9k9OVdh5bspZwoRM5Bq/gyXRljeu7zjPvKpN?=
 =?iso-8859-1?Q?rK2SDFwABARE14CiLSD1rYah87fZrIr9Tyi7J5iC6eZcYLJNqWoodNRrX7?=
 =?iso-8859-1?Q?edgn/sLkg+0QiclQze4Wu5Et3EOKkWG/EWoDznR2pZGDLuKarHUtxDDVhI?=
 =?iso-8859-1?Q?JPl9Nc0fcfeUdGq9njRIwCYlWCbOoHj85a+oGYfz/gqE6jSQS4g76UZcGM?=
 =?iso-8859-1?Q?hHx3waa+RTlKpVHQhK7LX9hQJfiUfLNI/8JQaK2gqsDauljqQnQWEiQ8Yn?=
 =?iso-8859-1?Q?aVgLCAvXzeOHTjZhH/i9BjGzZsQAeg+Oz5B3e5RALqK3x0j79sj64gEUcW?=
 =?iso-8859-1?Q?7eLj4Lc2PNEDkBwZBY29IzKADcgYjWlsd2NeedxPs37wq8Yj22ou96Z/BW?=
 =?iso-8859-1?Q?GCo4BT8OaVca1WMxss1p55WRKnrz5zZlh8BHBUTwp/Gu+bnyyedz8TyhPa?=
 =?iso-8859-1?Q?EgrhcBt+ghv4mT3Hbs8BZbqzvDre89xU7fYrV8aj7WDpj5K2FIY72/6058?=
 =?iso-8859-1?Q?rG/AhW5DxPFYCbhpDKO8qYLVwGvej8zIArXG15SxGhZ6lh3PaIGHDNv8xO?=
 =?iso-8859-1?Q?dZoFfl7Kw+8lbEK7V+rhYYFrSwbZoS81o/4gLXtMZ2AD/I7n0bWthIBjGw?=
 =?iso-8859-1?Q?nn7Wi+PLS0sBmE9O/yaOqNmi2U2qowupayw0f2ts5lMHcz3egSmOSTY+c4?=
 =?iso-8859-1?Q?MVir2t5t8GTAQAsf8yPi1HCUCISv54of4XjplaQr6iNjQeEvkj3yfzGQKg?=
 =?iso-8859-1?Q?qb90HOfY7uKwrmPYgYYuaq9Arf8vT6PAcsi2CUC6lZzlKpwInIKexqeGA8?=
 =?iso-8859-1?Q?X0w4hyDaziHHRqozO8J6l131vDTW3OFnSoeHdYttvfYjaAjqAoLciJMktp?=
 =?iso-8859-1?Q?bNDZzcDvSU9hnYIFzxZxhVGG7LmI9oKIICWw859NiHCOgE6NXV5OxVBcCY?=
 =?iso-8859-1?Q?KRBTuVWjVPsaPBEVQ2D3fJB57/V0bPuwhr5RbYl8hELb+gYrhR/SHtYq4t?=
 =?iso-8859-1?Q?dCNYQsvP+rCIJMksTkIyF5HNiQmbo94KaWv5Kv7+AgFA3KoJjugh9CRGgR?=
 =?iso-8859-1?Q?LUizVBKSqG4jMCwQQY7+6js9rZgvjwIostzBQig3?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <5F743C66B500364687DCEE5359CF2B57@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 430e1969-9683-4938-a963-08d99a227554
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 14:51:43.6944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dk9BwQcjsXzxCVXRpcjNwvGYATb1qWhvplNyRfm+8F3Ff3tlsla4BcFrjeG0jBnxS7QuCZ/7LUp41pi07aD73w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 04:38:25PM +0200, Cl=E9ment L=E9ger wrote:
> Le Thu, 28 Oct 2021 14:22:55 +0000,
> Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
>=20
> > On Thu, Oct 28, 2021 at 04:15:22PM +0200, Cl=E9ment L=E9ger wrote:
> > > Le Thu, 28 Oct 2021 14:06:12 +0000,
> > > Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
> > >  =20
> > > > On Thu, Oct 28, 2021 at 03:49:30PM +0200, Cl=E9ment L=E9ger wrote: =
=20
> > > > > Add support to get mac from device-tree using
> > > > > of_get_mac_address.
> > > > >=20
> > > > > Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> > > > > ---
> > > > >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
> > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c index
> > > > > d51f799e4e86..c39118e5b3ee 100644 ---
> > > > > a/drivers/net/ethernet/mscc/ocelot_vsc7514.c +++
> > > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c @@ -526,7 +526,10
> > > > > @@ static int ocelot_chip_init(struct ocelot *ocelot, const
> > > > > struct ocelot_ops *ops) ocelot_pll5_init(ocelot);
> > > > > =20
> > > > > -	eth_random_addr(ocelot->base_mac);
> > > > > +	ret =3D of_get_mac_address(ocelot->dev->of_node,
> > > > > ocelot->base_mac);   =20
> > > >=20
> > > > Why not per port? This is pretty strange, I think. =20
> > >=20
> > > Hi Vladimir,
> > >=20
> > > Currently, all ports share the same base mac address (5 first
> > > bytes). The final mac address per port is computed in
> > > ocelot_probe_port by adding the port number as the last byte of the
> > > mac_address provided.
> > >=20
> > > Cl=E9ment =20
> >=20
> > Yes, I know that, but that's not my point.
> > Every switch port should be pretty much compliant with
> > ethernet-controller.yaml, if it could inherit that it would be even
> > better. And since mac-address is an ethernet-controller.yaml property,
> > it is pretty much non-obvious at all that you put the mac-address
> > property directly under the switch, and manually add 0, 1, 2, 3 etc
> > to it. My request was to parse the mac-address property of each port.
> > Like this:
> >=20
> > base_mac =3D random;
> >=20
> > for_each_port() {
> > 	err =3D of_get_mac_address(port_dn, &port_mac);
> > 	if (err)
> > 		port_mac =3D base_mac + port;
> > }
>=20
> Ok indeed. So I will parse each port for a mac-address property. Do you
> also want a fallback to use the switch base mac if not specified in
> port or should I keep the use of a default random mac as the base
> address anyway ?

Isn't the pseudocode I posted above explicit enough? Sorry...
Keep doing what the driver is doing right now, with an optional
mac-address override per port.
Why would we read the mac-address property of the switch? Which other
switch driver does that? Are there device trees in circulation where
this is being done?

> > > > > +	if (ret)
> > > > > +		eth_random_addr(ocelot->base_mac);
> > > > > +
> > > > >  	ocelot->base_mac[5] &=3D 0xf0;
> > > > > =20
> > > > >  	return 0;
> > > > > --=20
> > > > > 2.33.0 =20
> > > >    =20
> >  =20
>=
