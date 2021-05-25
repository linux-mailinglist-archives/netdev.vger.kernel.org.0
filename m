Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56D7390061
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhEYL4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:56:05 -0400
Received: from mail-am6eur05on2060.outbound.protection.outlook.com ([40.107.22.60]:52001
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231770AbhEYL4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 07:56:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mL+crMvAvcvLDjxZjdPWOptL7aIjKmmaiDA8AynpOLviOCdythLkjARSygOttqsFRM/gJLAtiF7TkumcTOfonyKTe/sDKQ0ojbi6RgSNpR+6l3g4mLtoyPTrwvAc+sII2yBwjLtkNuucVfhyfT67kkxh9Wm3MNzTPZQI3QNNc2kMAFUE10WuKlqA3/S/G24cmGsJQf7wfh3ZPbDnIjCCJs4bD99/+cUX0X3SZD1SuLa+8maKKTFLa9oUgGxmVKNhu+56SmHXMFlL51GVrvI7RlhJINRhe3zVU+c8CC5QzZJZdSn8YcxoGkz26Ei4OjZfFPnq8pg8U5y5FMXKQeri3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0tTdmtFrzIKPAKDNTTJ/YsBmqEy8vZ+6eSWDP6S6L0=;
 b=YamQxIetQzo7FX9bN9ZVSZiZK10n+/OUwr6nVMDGAjacud6faiD2YP9KyYLWgqNUWFBaYphtgKKsuOotW7+wsZzhGYNjpbS9rXgVeJeHoI6VFfKpE1KZdn7yOCjYPQ7VtgZrSRfpB0n2QsW8WbNG8zox6K51lYeKpokuHqhheCnvVD0zwOaNywkYRIOGF/46UFDubr7GUpGyhSBGHb5TTrwF+/q8m/tzAo4JiV1ad4/KmQGVLoWxxwRJcjUg9652bgeeiZdZc3AUevkRVMaFjOKVDohUqow4l/q6Fv44hBOE5T+TISRNcojtOfUPunJzW8JjGBh3cnXYje64x0cNYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0tTdmtFrzIKPAKDNTTJ/YsBmqEy8vZ+6eSWDP6S6L0=;
 b=s4RlmC2XF30VYU6D3VtqZkYDV4QphTXbSkz7DGttahyprA4f6ikaU77IRe8zLixz/nIyrNf6aBiJ/v+GIL+YBafq1Gplx4+UKEIbOxnMp0SW644tdaYQMmhaWInlkebGyIoabUpx/XA6acDyvPPeZxthbBj/2VG6KORzcL+VEvc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 11:54:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 11:54:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO buses
 for 100base-T1 and 100base-TX
Thread-Topic: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO
 buses for 100base-T1 and 100base-TX
Thread-Index: AQHXUPOx4aLMBMHr9UOu/+AIQB4kIarzdpMAgACg9IA=
Date:   Tue, 25 May 2021 11:54:30 +0000
Message-ID: <20210525115429.6bj4pvmudur3ixyy@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-12-olteanv@gmail.com> <YKxecB8aDJ4m5x7R@lunn.ch>
In-Reply-To: <YKxecB8aDJ4m5x7R@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36b4e894-3bdf-4a20-aaf7-08d91f73db0a
x-ms-traffictypediagnostic: VE1PR04MB6511:
x-microsoft-antispam-prvs: <VE1PR04MB65118F1CE79D6FEAF393EB45E0259@VE1PR04MB6511.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ej3JvardYzQr3ZUeF6dav3slgZyuBSjuNlOtmzIGyHuR8pv3oImYRISo67qAlC30p0s3Qgafimq53FyEvraCCv4e60cQkDeyfPkNkVOHw6E3TbnEYd/w6CumnBCXTa/vMPQI9Yu+XZ9N4Rhpfs56t3TUUO8jj+J3dyg/3G8915WqpSIqufITOOxHx+kPkPZH+EOQ0+ZArnRd+vqBGVZfUMc57sFE3aunrzYmMHcz3fppoe2M+04xV/VtvvRpnA06sDJmENodw8UcRxLTUmUbYM4OmKHSVvTxHeP+DwhjSf7QqyC0n7IRy6BzFYcADvuC1ZrOAmLwVoUs+uVu+DDv3PrXg6WQbkJ2xiWgGFdbYqZYv8c0bAgB6n9ynehNzMS195pbCreeXM7tAVxI/21CkT6FiNlY1X7HtlsP9sG43lHluKTF+tiyqtcECw8JVa89xvkkbuX059skRGCLQf08E+rYfNvWHBYIh/3q+qcQo6gt1uxkAx6jX5ewlVZ+O1hZTivi+8MKPY2V+YBSwuQW7Ft9s3mgmVtpXxQO5LkfYoDUVs0UMNWb1UimSm2KNuzL57ETvYnyyWaAzH8ZT/n5gjwZQnxXV6zEmKEEi4yzY3c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66946007)(76116006)(86362001)(186003)(66556008)(54906003)(64756008)(6512007)(44832011)(38100700002)(2906002)(66476007)(66446008)(122000001)(5660300002)(6486002)(83380400001)(8936002)(8676002)(1076003)(6506007)(71200400001)(6916009)(26005)(498600001)(9686003)(4326008)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ad3btKyTBrzp/nNS0NdgUBt3fQ2vdlus5rVEQWly6suPNnXAEPj3KqmJx7q5?=
 =?us-ascii?Q?Y8leAJKHvX/0VlwPMMi7mQ9VIMs0p/YZJQH7jIxhD1T1tTfrumm0oyLmQF/T?=
 =?us-ascii?Q?TeIrxvYbbv/E6v1omPAdj4SdyfWDQvlb8SjUPmSyLylbaUbUEA8KDd4bRe21?=
 =?us-ascii?Q?Xi6qRj5WGMIr6t2bYAvuyL7Lt1BUWBkESfq56xqPOrixPOF001571vQfziej?=
 =?us-ascii?Q?qjDhbarE3juaW43X7H6Fxbud0uwli6CLSPTnHLITyIl39ZYWfXSSj6TlQmJs?=
 =?us-ascii?Q?4b5FcEuSgJgVTIvmDSkJrOTSyE9T1i2bpDHyitA0dYRE8sjLR1TzycFxh/Er?=
 =?us-ascii?Q?DnpmHpHGG6C6UgI/PayE0GUlv1CJlzPe99rbCcFW1XozHvCvSV0aMpZ+OUob?=
 =?us-ascii?Q?k7oxfSVZ3ym3ktMCfwroYriXd8ziy1pw1S2Hsvvdeb/QjkIRxPghkOGhKORS?=
 =?us-ascii?Q?LFggfxav1ezr+eqdRYTC6d9gtjiy71JBPHHaEfBy11Yv4AexDM2N2Zvd/VUq?=
 =?us-ascii?Q?NJ2kDel4Q3200bY0sVSuw4Fzzh2aidjVOxzzF8lcwa4fKNkViERi4a3xo1MY?=
 =?us-ascii?Q?Jcs7LCuirZFYgfhiELDvRNEI5ngUbfWOLw8+l33N84vfb4ehLb+5rJgEBXvU?=
 =?us-ascii?Q?XbSD/KSeEyH1mLS9wyyPEtVp5FCA9NZLtBOETyeK5QakRvxNZ1DGXYAVY9v6?=
 =?us-ascii?Q?65z4asxe49+5zpA8HepR53/MM3z0qINtyly23+BRzDJwmddA5Cq6AYgjE+o1?=
 =?us-ascii?Q?QZiIhvlOM0WB+9C7XfnWQfbSghiPj5FFWmuZHC13oP+CZfhVHYuj8UwRduEc?=
 =?us-ascii?Q?5og7dApWlhFC9rb822V87S/LPV4FM1y8tqnZERoOfJWJ5Mpzxl7CWUipQ5Qc?=
 =?us-ascii?Q?XZMjaJaT/+4bNXEO+TFuUjV626u5ejGGJtAUwlC4U1Vi3e8Uw9nIkWGLdv4q?=
 =?us-ascii?Q?mKltrv/hoLmbtevbPZje+SLgYsmDAjp/QN7WTnh7CgHEw+iX9KKUXIAhpcQj?=
 =?us-ascii?Q?oNEb9rPajmwggos4P6CzcDoEodNxoTvnTkRVeEBXVCr0rrSIzbzKWqoyuJTL?=
 =?us-ascii?Q?4S4MGqMT8/2MVPXK4dBC4+pMsKjWsP/5kJXPkgUm3LWjbMF9ll0WT6vJN5Wm?=
 =?us-ascii?Q?pnhW/JghMsnus3S+phFuZpFHMMYYe6TNA6Oq+yQl4QE1l+z0yGAFdngVksSk?=
 =?us-ascii?Q?8lW/Eb7MbWSU46cdH4jUchrFcq7COivF4srrXbFcCKnT+lwvf+WMHMuXsDKg?=
 =?us-ascii?Q?xdCl4mYZGiBlOmtUT+8kfwypnWlJY4FQnawRuoPrq0Dd6f+KalHe3rIrg8FU?=
 =?us-ascii?Q?dvuaF57fENdsS3yIC1b8y2WH?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5937574ADF88D740BD245E9CF1A0690F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b4e894-3bdf-4a20-aaf7-08d91f73db0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 11:54:30.5275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 59lQybch6jxpidlAsz9Io+9HhmU0UVICtBXEq5O7LsTGQIdrpHZ3j+JnrvzDaopqlBdBOP8Np9tujK+oIcvp+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 04:18:24AM +0200, Andrew Lunn wrote:
> On Tue, May 25, 2021 at 02:22:12AM +0300, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > The SJA1110 contains two types of integrated PHYs: one 100base-TX PHY
> > and multiple 100base-T1 PHYs.
> >=20
> > The access procedure for the 100base-T1 PHYs is also different than it
> > is for the 100base-TX one. So we register 2 MDIO buses, one for the
> > base-TX and the other for the base-T1. Each bus has an OF node which is
> > a child of the "mdio" subnode of the switch, and they are recognized by
> > compatible string.
>=20
> The mv88e6xxx also can have two MDIO busses. It is however an internal
> bus for the internal PHYs and an external bus. The code however
> evolved, since earlier devices only had one MDIO i ended up with a
> binding like this:
>=20
>        mdio {
>                 #address-cells =3D <1>;
>                 #size-cells =3D <0>;
>                 interrupt-parent =3D <&gpio0>;
>                 interrupts =3D <27 IRQ_TYPE_LEVEL_LOW>;
>                 interrupt-controller;
>                 #interrupt-cells =3D <2>;
>=20
>                 switch0: switch@0 {
>                         compatible =3D "marvell,mv88e6390";
>                         reg =3D <0>;
>                         reset-gpios =3D <&gpio5 1 GPIO_ACTIVE_LOW>;
>=20
>                         mdio {
>                                 #address-cells =3D <1>;
>                                 #size-cells =3D <0>;
>                                 switch1phy0: switch1phy0@0 {
>                                         reg =3D <0>;
>                                         interrupt-parent =3D <&switch0>;
>                                         interrupts =3D <0 IRQ_TYPE_LEVEL_=
HIGH>;
>                                 };
>                         };
>=20
>                         mdio1 {
>                                 compatible =3D "marvell,mv88e6xxx-mdio-ex=
ternal";
>                                 #address-cells =3D <1>;
>                                 #size-cells =3D <0>;
>                                 switch1phy9: switch1phy0@9 {
>                                         reg =3D <9>;
>                                 };
>                         };
>                 };
>         };
>=20
> It however sounds like you have the two busses one level deeper?
>=20
> It would be good if you document this as part of the binding.

Yes, it looks like this:

	ethernet-switch@2 {
		compatible =3D "nxp,sja1110a";

		ethernet-ports {
			...
		};

		mdio {
			#address-cells =3D <1>;
			#size-cells =3D <0>;

			mdio@0 {
				reg =3D <0>;
				compatible =3D "nxp,sja1110-base-t1-mdio";
				#address-cells =3D <1>;
				#size-cells =3D <0>;

				sw2_port5_base_t1_phy: ethernet-phy@1 {
					compatible =3D "ethernet-phy-ieee802.3-c45";
					reg =3D <0x1>;
				};

				...
			};

			mdio@1 {
				reg =3D <1>;
				compatible =3D "nxp,sja1110-base-tx-mdio";
				#address-cells =3D <1>;
				#size-cells =3D <0>;

				sw2_port1_base_tx_phy: ethernet-phy@1 {
					reg =3D <0x1>;
				};
			};
		};
	};

I will try to document it.=
