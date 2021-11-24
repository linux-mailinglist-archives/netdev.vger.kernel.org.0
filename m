Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C7445CDA1
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243522AbhKXULE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:11:04 -0500
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:20960
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237240AbhKXULC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 15:11:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f00xgTk9IBDa3T3MaGQRaeWwyi4gMg6x2hELsPwDEBGJvufindVawGJJHuntQDFGdHYwVd7otp9MZxmQo2qFNmyhn4+JyhTw1WKVZcJrbnoIHdkUZL4nDV1XrAKqVuFMZJvbjbewi9vGUWsBzWZX1gxcqEG9ylxUTE5nLXoUXG86M8pLop002a6Yx8Wkf9cAphpZqc0aIFNHkNinH6A7D+AKg3hdLsCzOQIAVNXGj4J20aJPYPbexvjFju3RVLFs5Jb7pA1UNKc5j6bcReLrm84RGxThn1QsmSimIRRPIF0yQxbY28ZwTAS6HznHiXYF5ewIbsykRAVmKqyXdY2QFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lz4dkG/IhphdwbwsULGogc18ilTejXfRZZhc4xGeths=;
 b=jbqFK0J7dIOO8Edo8vmaCZMuXNXcZDgRsr+130gl85lDxH4hyxr07koJf3bCtMiGetJbELVkcF1yVwJB+209ML6zC4TW7YA0+UyhUMgiCNjnOjtyb2600l8PhrCHRdclKp6kpMPhU4MEabsplHMKuiRpvH8FsLXH/Eo0jCtFE+WmIxGynLOtkqlYMDn+rlcKUGsZRjpKKOpfHYge9guH7dd4aogTn2qVsKHK2AMlmfXop35jPXRRTqZ8HkOB51QBOJwtcCfWD7LFTGZmI9HkOV0gSO8HeXxj8D/0VQ1qr+gE8bv0QnICvXuIqa9I9LyJ3nL0wjdpa/YM0gRsVZQtHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lz4dkG/IhphdwbwsULGogc18ilTejXfRZZhc4xGeths=;
 b=p+XpyNLYZVr6m3vJ4FZtyzdKcn4tGiN+EqK0h6PbcaTANxVY19ddsWe7BdcBr3avtlBy99MumRjtXCwdxU9bF4rXr5MW/4mUY+vZscp/auoZdyIaur8O2trF+vOmgvWCATR0tK/tpoDbDOuxhFqQcMDvIZXa2BIJLZQzDkvGh+E=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Wed, 24 Nov
 2021 20:07:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 20:07:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 09/12] net: dsa: ocelot: convert to
 phylink_generic_validate()
Thread-Topic: [PATCH RFC net-next 09/12] net: dsa: ocelot: convert to
 phylink_generic_validate()
Thread-Index: AQHX4VworEPGZtPC/ky6l8gH4vjjS6wTGy4A
Date:   Wed, 24 Nov 2021 20:07:49 +0000
Message-ID: <20211124200748.mrjuzgwunnn4zjxf@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwSD-00D8Ln-88@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mpwSD-00D8Ln-88@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b679cbd-6e51-4bed-ab0b-08d9af86170c
x-ms-traffictypediagnostic: VI1PR0402MB2797:
x-microsoft-antispam-prvs: <VI1PR0402MB279783644ED4584F043FDC41E0619@VI1PR0402MB2797.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 86kwIL78lr5xjgWU0Vt16i3HFAlVg+J2mDtjysE+2D1IJUFAkD2LWFq++S15pYB9eyMseSw2xt7dfDQKbNxvyI4UBiAJx0zcGtIPpTPVVZhAWl9uJdZJOnOc4BhV8K5gbmtIxObJcomwPAXjgQGJ1CJm4KeGMuj6eund69XkI6dyM5c1hD6ey251+1eGyk0ELHYtKvMh1dnUmosJNBmZvuZXbuxRzeWXnJfB3uJNLcuNaCwSsoZj1w+qJTehG40F/2FNxTHhX10ijKU22vNFH8f66InnPEPfetTHjmWwqnd+CvT9Ak6gceO+w/Uh12HR2KJVNGgzsLjJSZkCXx9BywPp4GBQdiH81lpoxsqXpFVCja8d407dM17rmpn8TM5utq2a625yKoIIqEhOWFrL+z0LLoTsO7/HpThy4CkyzMVbFYmhD9fBLZKzMKfL3R4ffXXEFOxeO8IHqD9EMdGhZs3HUwoLwXM7dUGBTzIi9lqYD+19Out4pWFvYZOD/nbbjp+AfoCue3tAe8cKQFJOXmGNM4ujjCCUEkBthtBccbZvl/DcIjz23X1nYDqAFamPOKdoweV0RWhOPYAe7tde6s/m6Dxfw3Yv6+q6fS7HF7aFbL89lazEaqwrzSKIwlO8SWC8LvZuEk4TCP6fE28jkbLESTFeB9Keqdz7qeX1PXIhrYcXM3jSQ1ptrMBAuAZ//WQQ4qGlaHGggYYDFLPPmCejmsdRxt/bidSYDIMUEVo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8676002)(1076003)(5660300002)(38100700002)(86362001)(26005)(6486002)(83380400001)(33716001)(38070700005)(2906002)(66446008)(9686003)(6512007)(91956017)(76116006)(66946007)(316002)(71200400001)(122000001)(54906003)(8936002)(44832011)(508600001)(4326008)(64756008)(6506007)(66556008)(66476007)(7416002)(186003)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ql5dKhb8M4irnXBx9tCGbPaTaEZNbHpmNtsOGXzGb51dTesh11rQe9TChbzY?=
 =?us-ascii?Q?rgJ6o1/CcEveDwigCdpX5j+v7KBYU6rR89VI7ECGPW7FaS3XeqNpYRZDcV1t?=
 =?us-ascii?Q?wc+84K33SK4XZVC1YfQvMdsGzRUMiyKo476bzI7K5eIG7elcCbQcAGZUD/cE?=
 =?us-ascii?Q?JBorPL0Y9x0xdVq/zuS+DWAXEoAD0Z0ZM0XeqL2Lnn4ZNpOWR4UmCM+U6s5x?=
 =?us-ascii?Q?Bj1+WpRbDxhOweWzHml9wGCcfk6+eLOltTMfbxO5dXl8fpJfGxQwAh3Pi9CS?=
 =?us-ascii?Q?cndxxHdRyVIatkDYZts5aawrDYLSSgpA43xcoP624x+E8kZ6iSFzKfpom2BC?=
 =?us-ascii?Q?LejZMK+6i0/nb9D/y46ItAdfS1b4clVFuz5PwFcq+DuE7k3NtQ273OzBbV4J?=
 =?us-ascii?Q?giuWwjYBaFcoXQgwgVX6WodBQQHUajVe2FygiuuL6z/Brxo9WSNzemGFfRoZ?=
 =?us-ascii?Q?WE2HZsu0t0TfX8mPkfiBTE0b7Z1psfw9yR0+/dzlb2+selSfbPtd4+rYCnye?=
 =?us-ascii?Q?4TRBlvf3/L3h2R+KX+p3kPcljFphfcntPwV1rdcTro3JreqhfY0eectMkP/y?=
 =?us-ascii?Q?h4ScqoeEyMZFUEEuaqQs78UQ77S0K3BWc6wL3PQZuBeyhdO6P5ReB0rrGJEL?=
 =?us-ascii?Q?XXY6+9zCiNi8JDcF+m7WLnJ1IQWJ610nPP4UAyn44wiT2CUdAwfDwe8gNWjp?=
 =?us-ascii?Q?msOz4kQzo1OayfhGy59K1/TMH86/xQNzddfaxUywPjD9DIcV115RleH9p8rW?=
 =?us-ascii?Q?+rPJxiVhXz+amPgReh9Q006cR/LA592clXztWukfg/vxTLtcb2ic4jObB83g?=
 =?us-ascii?Q?4kUFBh7xhoCsrB59pP0YsXZbKr2zIP5Dyi5xxhgLo/WdPqs6g4hRjEIJjtEX?=
 =?us-ascii?Q?DkAD4nBse4MENcVQVwOJKGWPwrxrXxwurYMV3mjTHjHs5mOAXaVr82ocuXfm?=
 =?us-ascii?Q?WZ5PnuuDvemc69tYg2qp0kkZYlS4TOD0nZ2Bx3R52rhvVhOqZuK5GGQ6Tk8F?=
 =?us-ascii?Q?r/s05hOPhUHxZ1EmfUeCoIAkFkd9BWkQ6T+T1lxH6ADUFyRZsxyZGdO8d2T6?=
 =?us-ascii?Q?6sJGGz2XKj2rtnpjjoO+c2t98XmPX4e94AvSYQaoyPPuv5kVTQl2sy40NCVR?=
 =?us-ascii?Q?ul0NGKSzjFjlMWo1Uk8Bi0RU2m+9SZVX83reUe6dweOGWFr2QHEjoO1zKS9I?=
 =?us-ascii?Q?dL2ngH+z5ggYFRwKPJ79AtMC7b91tNiRS2P/yL6C6XE93mtLOPPPdEmWCevY?=
 =?us-ascii?Q?ImVWgWq1jczbIzwJWrT5fQIMWHrwwD1VNmbtLmPZbz9gkJ3CKG25fwGmdUcM?=
 =?us-ascii?Q?zo9n/ELdJWQ6OjYjPNDGYQOTPDWlOXmEQnknraFNESM9U4tIYypI6kNSQrUh?=
 =?us-ascii?Q?cBknz+Lxm9Ho1xyswW3kXHBlgsbNnwAPSw6d9Np+4f+lngZdwOktYOHV01aC?=
 =?us-ascii?Q?oXFMybCWv/byAxPu8wyS9pjdXm1BjDzfQMrG99XhaI+7VauH0CQru7BnpxOW?=
 =?us-ascii?Q?X+WKWUqQ9FvKnyXB0xAK4b0LpaQ6J+xinHFLIMaJi5C34pDn4crxz0+O9KAa?=
 =?us-ascii?Q?fN1SU7mpQe6EKQPC3q28OHMU0Q2iIJcSyK997RlDGwXh9KJ8jqRIoKTp4zh2?=
 =?us-ascii?Q?CCh5uUTKVLw1XDVREWcVuJmE9z0pewxNYkvDJGjReEnU?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <75A6A21C6E8B7D4C933054A872942E6E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b679cbd-6e51-4bed-ab0b-08d9af86170c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 20:07:49.5641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AvTEs2OdmcNXt/zwkrwMirMtWj/jl1NLk+ke7IAFvPqaXfA07OdmAdEuAhEEdzloFlUcFl2/UL+d78IZg/foDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 05:53:09PM +0000, Russell King (Oracle) wrote:
> Populate the supported interfaces and MAC capabilities for the Ocelot
> DSA switches and remove the old validate implementation to allow DSA to
> use phylink_generic_validate() for this switch driver.
>=20
> The felix_vsc9959 and seville_vsc9953 sub-drivers only supports a
> single interface mode, defined by ocelot_port->phy_mode, so we indicate
> only this interface mode to phylink. Since phylink restricts the
> ethtool link modes based on interface, we do not need to make the MAC
> capabilities dependent on the interface mode.

Yes, and this driver cannot make use of phylink_generic_validate()
unless something changes in phylink_get_linkmodes(). You've said a
number of times that PHY rate adaptation via PAUSE frames is not
something that is supported, yet it works with 2500base-x and the felix
driver, and we use this functionality on LS1028A-QDS boards and the
AQR412 PHY, and customer boards using LS1028A probably use it too. See
this comment in ocelot_phylink_mac_link_up():

	/* Handle RX pause in all cases, with 2500base-X this is used for rate
	 * adaptation.
	 */
	mac_fc_cfg |=3D SYS_MAC_FC_CFG_RX_FC_ENA;

The reason why you've said it isn't supported is because "it will
confuse MAC and PCS drivers at the moment", which is something that does
not happen for this particular combination of MAC and PCS (Lynx) drivers
and SERDES protocol (because the speed is fixed, there is no reason to
look at the "speed" argument which represents the media-side link speed).

And what has to change in phylink_get_linkmodes() is this:

void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interf=
ace,
			   unsigned long mac_capabilities)
{
	unsigned long caps =3D MAC_SYM_PAUSE | MAC_ASYM_PAUSE;

	switch (interface) {
(...)
	case PHY_INTERFACE_MODE_2500BASEX:
		caps |=3D MAC_2500FD;
		break;
(...)
	}

	phylink_caps_to_linkmodes(linkmodes, caps & mac_capabilities);
}

As long as phylink_caps_to_linkmodes() doesn't have additional logic to
not remove the gigabit and lower link modes from the PHY advertisement
and supported masks when MAC_2500FD is set but MAC_1000FD and lower
aren't (and the driver requests rate adaptation via PAUSE frames for
this PHY mode), then the generic validation method is going to introduce
regressions here, which are not acceptable.

Otherwise the patch looks good.

>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/ocelot/felix.c           | 11 ++++---
>  drivers/net/dsa/ocelot/felix.h           |  5 ++--
>  drivers/net/dsa/ocelot/felix_vsc9959.c   | 37 +++++-------------------
>  drivers/net/dsa/ocelot/seville_vsc9953.c | 34 +++++-----------------
>  4 files changed, 21 insertions(+), 66 deletions(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index e487143709da..26529db951fc 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -801,15 +801,14 @@ static int felix_vlan_del(struct dsa_switch *ds, in=
t port,
>  	return ocelot_vlan_del(ocelot, port, vlan->vid);
>  }
> =20
> -static void felix_phylink_validate(struct dsa_switch *ds, int port,
> -				   unsigned long *supported,
> -				   struct phylink_link_state *state)
> +static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
> +				   struct phylink_config *config)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
>  	struct felix *felix =3D ocelot_to_felix(ocelot);
> =20
> -	if (felix->info->phylink_validate)
> -		felix->info->phylink_validate(ocelot, port, supported, state);
> +	if (felix->info->phylink_get_caps)
> +		felix->info->phylink_get_caps(ocelot, port, config);
>  }
> =20
>  static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
> @@ -1644,7 +1643,7 @@ const struct dsa_switch_ops felix_switch_ops =3D {
>  	.get_ethtool_stats		=3D felix_get_ethtool_stats,
>  	.get_sset_count			=3D felix_get_sset_count,
>  	.get_ts_info			=3D felix_get_ts_info,
> -	.phylink_validate		=3D felix_phylink_validate,
> +	.phylink_get_caps		=3D felix_phylink_get_caps,
>  	.phylink_mac_config		=3D felix_phylink_mac_config,
>  	.phylink_mac_link_down		=3D felix_phylink_mac_link_down,
>  	.phylink_mac_link_up		=3D felix_phylink_mac_link_up,
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/feli=
x.h
> index dfe08dddd262..1060add151de 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -43,9 +43,8 @@ struct felix_info {
> =20
>  	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
>  	void	(*mdio_bus_free)(struct ocelot *ocelot);
> -	void	(*phylink_validate)(struct ocelot *ocelot, int port,
> -				    unsigned long *supported,
> -				    struct phylink_link_state *state);
> +	void	(*phylink_get_caps)(struct ocelot *ocelot, int port,
> +				    struct phylink_config *config);
>  	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
>  					phy_interface_t phy_mode);
>  	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/oce=
lot/felix_vsc9959.c
> index 42ac1952b39a..091d33a52e41 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -938,39 +938,16 @@ static int vsc9959_reset(struct ocelot *ocelot)
>  	return 0;
>  }
> =20
> -static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
> -				     unsigned long *supported,
> -				     struct phylink_link_state *state)
> +static void vsc9959_phylink_get_caps(struct ocelot *ocelot, int port,
> +				     struct phylink_config *config)
>  {
>  	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> -	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> =20
> -	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> -	    state->interface !=3D ocelot_port->phy_mode) {
> -		linkmode_zero(supported);
> -		return;
> -	}
> -
> -	phylink_set_port_modes(mask);
> -	phylink_set(mask, Autoneg);
> -	phylink_set(mask, Pause);
> -	phylink_set(mask, Asym_Pause);
> -	phylink_set(mask, 10baseT_Half);
> -	phylink_set(mask, 10baseT_Full);
> -	phylink_set(mask, 100baseT_Half);
> -	phylink_set(mask, 100baseT_Full);
> -	phylink_set(mask, 1000baseT_Half);
> -	phylink_set(mask, 1000baseT_Full);
> -
> -	if (state->interface =3D=3D PHY_INTERFACE_MODE_INTERNAL ||
> -	    state->interface =3D=3D PHY_INTERFACE_MODE_2500BASEX ||
> -	    state->interface =3D=3D PHY_INTERFACE_MODE_USXGMII) {
> -		phylink_set(mask, 2500baseT_Full);
> -		phylink_set(mask, 2500baseX_Full);
> -	}
> +	__set_bit(ocelot_port->phy_mode,
> +		  config->supported_interfaces);

This fits on a single line.

> =20
> -	linkmode_and(supported, supported, mask);
> -	linkmode_and(state->advertising, state->advertising, mask);
> +	config->mac_capabilities =3D MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> +		MAC_10 | MAC_100 | MAC_1000 | MAC_2500FD;
>  }
> =20
>  static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
> @@ -2161,7 +2138,7 @@ static const struct felix_info felix_info_vsc9959 =
=3D {
>  	.ptp_caps		=3D &vsc9959_ptp_caps,
>  	.mdio_bus_alloc		=3D vsc9959_mdio_bus_alloc,
>  	.mdio_bus_free		=3D vsc9959_mdio_bus_free,
> -	.phylink_validate	=3D vsc9959_phylink_validate,
> +	.phylink_get_caps	=3D vsc9959_phylink_get_caps,
>  	.prevalidate_phy_mode	=3D vsc9959_prevalidate_phy_mode,
>  	.port_setup_tc		=3D vsc9959_port_setup_tc,
>  	.port_sched_speed_set	=3D vsc9959_sched_speed_set,
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/o=
celot/seville_vsc9953.c
> index 899b98193b4a..37759853e1b2 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -994,36 +994,16 @@ static int vsc9953_reset(struct ocelot *ocelot)
>  	return 0;
>  }
> =20
> -static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
> -				     unsigned long *supported,
> -				     struct phylink_link_state *state)
> +static void vsc9953_phylink_get_caps(struct ocelot *ocelot, int port,
> +				     struct phylink_config *config)
>  {
>  	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> -	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> =20
> -	if (state->interface !=3D PHY_INTERFACE_MODE_NA &&
> -	    state->interface !=3D ocelot_port->phy_mode) {
> -		linkmode_zero(supported);
> -		return;
> -	}
> -
> -	phylink_set_port_modes(mask);
> -	phylink_set(mask, Autoneg);
> -	phylink_set(mask, Pause);
> -	phylink_set(mask, Asym_Pause);
> -	phylink_set(mask, 10baseT_Full);
> -	phylink_set(mask, 10baseT_Half);
> -	phylink_set(mask, 100baseT_Full);
> -	phylink_set(mask, 100baseT_Half);
> -	phylink_set(mask, 1000baseT_Full);
> -
> -	if (state->interface =3D=3D PHY_INTERFACE_MODE_INTERNAL) {
> -		phylink_set(mask, 2500baseT_Full);
> -		phylink_set(mask, 2500baseX_Full);
> -	}
> +	__set_bit(ocelot_port->phy_mode,
> +		  config->supported_interfaces);
> =20
> -	linkmode_and(supported, supported, mask);
> -	linkmode_and(state->advertising, state->advertising, mask);
> +	config->mac_capabilities =3D MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
> +		MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;

I would prefer if MAC_10 was aligned with MAC_ASYM_PAUSE, if possible. Than=
ks.

>  }
> =20
>  static int vsc9953_prevalidate_phy_mode(struct ocelot *ocelot, int port,
> @@ -1185,7 +1165,7 @@ static const struct felix_info seville_info_vsc9953=
 =3D {
>  	.num_tx_queues		=3D OCELOT_NUM_TC,
>  	.mdio_bus_alloc		=3D vsc9953_mdio_bus_alloc,
>  	.mdio_bus_free		=3D vsc9953_mdio_bus_free,
> -	.phylink_validate	=3D vsc9953_phylink_validate,
> +	.phylink_get_caps	=3D vsc9953_phylink_get_caps,
>  	.prevalidate_phy_mode	=3D vsc9953_prevalidate_phy_mode,
>  };
> =20
> --=20
> 2.30.2
>=
