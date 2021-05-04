Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05933372A8A
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 14:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhEDNAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:00:41 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:57985
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230433AbhEDNAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 09:00:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WR39g+DqP+ckQLdhKKPQnkfQ53lFplHdPr0GdJH4rk5RTtq//ZJ9EHH+Dl1WszQ/w7oME+xFyrP4qjTycbZ/ZcuzK6MdZVH7k32MFcP5b3y/2FIL1Hmq11h7n/vH2j3KLlfWnmjomMUUAqy9i6y5z1o70NltbEpR7jdtW0nPSoSeQfUAiyljIuq7FpIUOqMxExkL6Vsdvp7bsgh4zpP1xJBQIJxhR9Zm8xrrDP+lOFngNVXVARk6oYku9mGIeQ1idn8MQOep27Ok2OzjQVDzaLYj0jbvkcODORa8SZHDqDHX1yIbUNzTw7tLjq39xTMbLPLesgyIF9Sc7H0mqlU9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUU/ee0ZN8YAWQuJzVTzSOssGA6/h9OnuBknX9P2HDk=;
 b=mJC5iQY3xm3saPN/86/HhG4gX7zqCEyjXAmlyrvGYzNUDfG2qWtby/vwN3KH7C3V85YysPCEUcOafvfw0qHheKhzyxDuthq8r4yFC3Tll0lKRNw0QqE7rZL22gWrg4PbqPRm3Rtfe2FKUZH8ScC2CQ1w8Aqg59s7Ck5zpabifX4wSln4CVEN3j8AZKvxxbJF1HpKTd0Yop5T4v4S+v3PcCiKNS/c1dTCcS1HAzYJJdhyPWfW2pB1EgmmQWnjxJnh+K+fSsMd4mcYkEgjnUIDesJl87vR17FGToND46S7NRLaCWIHmW3c1MDo8R+sFypcxQfqML+rVHxc1TCi2B6VEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUU/ee0ZN8YAWQuJzVTzSOssGA6/h9OnuBknX9P2HDk=;
 b=QIbBLMnSFN5VyogKJ1wKX6ohHGfAYZg6LLTo7E/UncMBHFRStMdC3UaM41tw9jv1yO+vG864G9utrAH0o3zZiqw/j0ATCkNe6QugxPNlJvSpkiskcQFi1uUtKrlEOpeitxtCDxhOsSdcJnC4/QRrMIyQYLBIRjhN0HJywzdctCc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.41; Tue, 4 May
 2021 12:59:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 12:59:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Colin Foster <colin.foster@in-advantage.com>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Thread-Topic: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Thread-Index: AQHXQKP/w6NmRV8LhkOQoP6VPcP45arTQY4AgAAH3AA=
Date:   Tue, 4 May 2021 12:59:43 +0000
Message-ID: <20210504125942.nx5b6j2cy34qyyhm@skbuf>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <YJE+prMCIMiQm26Z@lunn.ch>
In-Reply-To: <YJE+prMCIMiQm26Z@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.127.41.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2382902-b8a8-42e7-2859-08d90efc7cba
x-ms-traffictypediagnostic: VI1PR0402MB3406:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34062CB6E67AAC914FDFA304E05A9@VI1PR0402MB3406.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zC1xyh+fjhUZbYQKd8djBtXG/Xi6Dqhcj86NXgwMo/DB4JE3/+k4jgf7Zv1b+8z4JFVqswWaHj1YjH1ruFzKR3UUDth3PKrPHe2lQzjWi+f/pKd0iOqLftNDRJM+NoVkPVjngsBLHMS2w1v8ozGZ164feoSytC9Kr2c77R5kZh4JDX7EDnzb/USbPTG+JYxIoScU9kcXVFoxIefAsWkHffJVO1Yy4mUmtD0fHedHBZCeMYme9KzE22Pjc92peJtkHo2+RSx6aEmy0BThMtuEj66LsXPy0Jxy+6KTLb/L6D2w2zDuwU5vku8kjuikOna5yzY9Tx9rY6Uw+gD8y1VVsiwl6isGNxCs1SpLXyJaab1gSsIrrLHRyNkAXB6OGSnplq/+I2BvM6/s0V8hEC1xd7Gb+MXXiPga0UmD1uSHjkH0x5YulCMyikGv+Fz7p2ZLEp2t5Wly0h3NiWVDmrNquK3Xdm4s9OWEdTnwJ+BofLLeo/heoD6MWM9QrqsEzax4pm11Geib+yiPgcAew1INSrqTQygIeW/eiQCkGEUlKGUWyjX6dzDhHQWbrDTLKL9M5HaTjYM6AVVxd1jpCdAAC+b83Kg+qhHTI1VzSC9XyZg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(396003)(39860400002)(366004)(136003)(376002)(186003)(4326008)(33716001)(44832011)(1076003)(26005)(5660300002)(478600001)(71200400001)(7416002)(66556008)(83380400001)(66446008)(86362001)(8676002)(64756008)(76116006)(8936002)(316002)(91956017)(6916009)(6512007)(9686003)(54906003)(2906002)(38100700002)(66476007)(122000001)(6486002)(6506007)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/Pm1tSXoVdAs4mHS9v6K6CxQgHZJST7SvuV0gtayQNDzkPtzERs84ErLs+LW?=
 =?us-ascii?Q?Led0SQCd2wjL4/bp+1twbDMtgifIrq5aF5EJ2fWmfvsT3QctbS7NI0h0AhPH?=
 =?us-ascii?Q?5aSpwKYlA79+VyehhzTEMSj9lijlfzwHtvGc/oEblf6P+f4O8au8OTwpaW1e?=
 =?us-ascii?Q?zev+XxeAJeD9SCJ0UC0by2lXbERPwmPmOuRx1BOOr37YksYkZDMXyaYEfCGh?=
 =?us-ascii?Q?9vI/mQHtoWT2r6PuGQidNtJ7zYv4AcCyDjfrYwZV+ljiPBrBByN22EkcgnzB?=
 =?us-ascii?Q?GRNOpfRTuh2uhK+HACbCkHsmXnQugh8z62NwS3affkk8jHVgiOKn19pmflGY?=
 =?us-ascii?Q?JAFGUH0qAreHEytb6yxN4Mt7goSim/v7G4VzSPjjwYHH6r389ef2I63cnCaT?=
 =?us-ascii?Q?MpocWi0aGfNtEPbybMNqmhGss4x+rtpcSHW2Ppw6DA+fVwcnaCUnzd2JIs6y?=
 =?us-ascii?Q?lym2XIj4ZNtVsAeQz1805td3AA2JZahjQzrXFvgG9eoA2UDjsznDkRxNe7Di?=
 =?us-ascii?Q?lXmhGBERBnECEy/GeuyP7boGvp9Z99SStA3D0xIJL0mWUnVc2+JefL2RyryF?=
 =?us-ascii?Q?sIB5GyIIWZfJDypgbXiAcXWCFtAQ5Pi6mJ9x5UokKlEHIc7RKFT+dmZIEwoH?=
 =?us-ascii?Q?kwP4PZ/n+ISGTQ3yWTV5qw6zBnYQv/P17S5tHMAvjO5+ofEy7avc9N+KfhWY?=
 =?us-ascii?Q?li8DK68g2XZH8nbO3y3cCr2G0xfHLA5AiYmNOglX8v9FcoAdGGjTEIoEHgt0?=
 =?us-ascii?Q?C+4V0WI68k+3OP6nT728yQkdgBfZpM5MK2XVHlwJTB7/jLC4CNgW/xqkgZ/+?=
 =?us-ascii?Q?v7I9hLWoDQuR+AO0dq2MAxF2fcGwylu4538HxjwweegMMG/0nnYTEf4RNcoS?=
 =?us-ascii?Q?yqkbYpOit9CqB3yW6dhsqGOgvcjtuFkJA+Cm+RBoJ2TgsdNLrdkQoXRcxdzW?=
 =?us-ascii?Q?cqjweQJvLlH+ztZLBX7y7/6/KZ2siJpiQpzwWgMhu64TPD0M/Tt8ymCOm2fr?=
 =?us-ascii?Q?IXA9dUILE30OSaeq7KXviOaF2qL3wgGL7uhyCm2Q/EpJWIC16oepo4hGV3+a?=
 =?us-ascii?Q?K/lkWNXC1THqvROvKOaYs8wY0oaEfjsg2yM3vsd/xnIMfhYTZj5i+j9TmLt6?=
 =?us-ascii?Q?BEophoF+XVmbSIzemxA2abEusiLGCFn4ANQV4FzU6AyZKo3Z5lOZbQWPmfT7?=
 =?us-ascii?Q?ucTR5kMxaOlZjw6krs+N67cxFy3CdcFYe2CgRzKvxQIT0+4RwOmlYue4SuXO?=
 =?us-ascii?Q?bCc2I9Es5/hYpgL16ymXja3SnjJ/lgpG3nNIu5GY5Lc8pMPDVHUCFvwF+1q8?=
 =?us-ascii?Q?I4x4n6NNskSiwsYo33YpTRJ4?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8C3A98F4575F44488AB4145C25648932@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2382902-b8a8-42e7-2859-08d90efc7cba
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2021 12:59:43.5568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oSz41ET9OFRT/mfKL82yz2ezTJlB9b4epNG8XRy8CkgZ5vWbuolnlplOmWI2aazlRwIcl1+G5cbPOLB9OVIoAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 02:31:34PM +0200, Andrew Lunn wrote:
> On Mon, May 03, 2021 at 10:11:27PM -0700, Colin Foster wrote:
> > Add support for control for VSC75XX chips over SPI control. Starting wi=
th the
> > VSC9959 code, this will utilize a spi bus instead of PCIe or memory-map=
ped IO to
> > control the chip.
>=20
> Hi Colin
>=20
> Please fix your subject line for the next version. vN should of been
> v1. The number is important so we can tell revisions apart.

Yes, it was my indication to use --subject-prefix=3D"[PATCH vN net-next]",
I was expecting Colin to replace N with 1, 2, 3 etc but I didn't make
that clear enough :)

> >=20
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  arch/arm/boot/dts/rpi-vsc7512-spi-overlay.dts |  124 ++
> >  drivers/net/dsa/ocelot/Kconfig                |   11 +
> >  drivers/net/dsa/ocelot/Makefile               |    5 +
> >  drivers/net/dsa/ocelot/felix_vsc7512_spi.c    | 1214 +++++++++++++++++
> >  include/soc/mscc/ocelot.h                     |   15 +
>=20
> Please split this patch up. The DT overlay will probably be merged via
> ARM SOC, not netdev. You also need to document the device tree
> binding, as a separate patch.
>=20
> > +	fragment@3 {
> > +		target =3D <&spi0>;
> > +		__overlay__ {
> > +			#address-cells =3D <1>;
> > +			#size-cells =3D <0>;
> > +			cs-gpios =3D <&gpio 8 1>;
> > +			status =3D "okay";
> > +
> > +			vsc7512: vsc7512@0{
> > +				compatible =3D "mscc,vsc7512";
> > +				spi-max-frequency =3D <250000>;
> > +				reg =3D <0>;
> > +
> > +				ports {
> > +					#address-cells =3D <1>;
> > +					#size-cells =3D <0>;
> > +
> > +					port@0 {
> > +						reg =3D <0>;
> > +						ethernet =3D <&ethernet>;
> > +						phy-mode =3D "internal";

Additionally, being a completely off-chip switch, are you sure that the
phy-mode is "internal"?

> > +						fixed-link {
> > +							speed =3D <1000>;
> > +							full-duplex;
> > +						};
> > +					};
> > +
> > +					port@1 {
> > +						reg =3D <1>;
> > +						label =3D "swp1";
> > +						status =3D "disabled";
> > +					};
> > +
> > +					port@2 {
> > +						reg =3D <2>;
> > +						label =3D "swp2";
> > +						status =3D "disabled";
> > +					};
> > +static void vsc7512_phylink_validate(struct ocelot *ocelot, int port,
> > +				     unsigned long *supported,
> > +				     struct phylink_link_state *state)
> > +{
> > +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D {
> > +		0,
> > +	};
>=20
> This function seems out of place. Why would SPI access change what the
> ports are capable of doing? Please split this up into more
> patches. Keep the focus of this patch as being adding SPI support.

What is going on is that this is just the way in which the drivers are
structured. Colin is not really "adding SPI support" to any of the
existing DSA switches that are supported (VSC9953, VSC9959) as much as
"adding support for a new switch which happens to be controlled over
SPI" (VSC7512).
The layering is as follows:
- drivers/net/dsa/ocelot/felix_vsc7512_spi.c: deals with the most
  hardware specific SoC support. The regmap is defined here, so are the
  port capabilities.
- drivers/net/dsa/ocelot/felix.c: common integration with DSA
- drivers/net/ethernet/mscc/ocelot*.c: the SoC-independent hardware
  support.

I'm not actually sure that splitting the port PHY mode support in a
separate patch is possible while keeping functional intermediate
results. But I do agree about the rest, splitting the device tree
changes, etc.=
