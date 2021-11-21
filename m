Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C08458545
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238378AbhKURQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:16:36 -0500
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:48965
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230330AbhKURQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 12:16:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJDSvvpq4fp3DDPDdrGDIZgkTfN8faAB16YduNTBcoaPV+4dNCO6qSkeDmdX5X0kRbQhX/8nFM97ka06wQPV51s868zc9P9rL7t3wL5lT85zJ1msVDvHFKIM7CzBM1MMjNwOK60qoRseB06Ret9Z/Vp/DZr6jTSXyjP5T2yeURViPx+LXj0MBujbbFTazNz/mRGXK9KdCmFdr7H8rhCdp5YK3DEAm8scxSxslSmzsxgLYBS2/4T+kaSmxf7ho7m/byjRMDLjhxIGjexmWdBe3MZqmcgV2IqQ6tIUqLHFtA+5w/bwDxAEoHkwW8/76BnpICor9VK/omd1F8D5G3adPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDg5cArKypF6thDiEyJkdhnYlY9jqGLorjx5wv1g5JE=;
 b=HFaAR0s+RWu/RJkb49qv1OCqzUlvpu8O0qKtlr9pncjX7y5R+Jv+s43UNskAZnUJlBtrRH4sdzByXZLLATk3/qP3i3WsQlAOa0YiqyZ/CLJkv9YGCkRHSXHO1HpIRuuWjx2OVCnev+Alqvxj16GOsXGvzl1/i0FbCA8S6ul1KodU6ZpEPl7S7RcVuU/4V2+5vrIFsMD5U+v8VsUN5ql68lJYoz/Hn940QXy1ljYjl6NPePNMMdbXhn7l1R33khBzzwOqNSBarNnEpyh+LmNTZgEWw9zBkh41s3lqB3sSLap5Ll5VCs9baLjfIRY7G1NO7/sB94g4EoS59La5D1JrFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDg5cArKypF6thDiEyJkdhnYlY9jqGLorjx5wv1g5JE=;
 b=R8v8R3Tw2+m8eAjqkK926VPHytP8cckt0SCPWNGVynnwmEILKeE8ya/2qYtH2/r/9JludfsKnkuFF0nDet3DdY7ARwoFme9TBoipRnKOv32W/ue/DEjNmrmRU//35/akGZsOC1VpdXYK/WbXGJ1C5NYIOlxciQgQCaCXW0rWeu0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5343.eurprd04.prod.outlook.com (2603:10a6:803:48::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Sun, 21 Nov
 2021 17:13:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 17:13:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 4/6] net: dsa: ocelot: felix: add
 per-device-per-port quirks
Thread-Topic: [PATCH v1 net-next 4/6] net: dsa: ocelot: felix: add
 per-device-per-port quirks
Thread-Index: AQHX3ZbybzsFc4blWU6OwKIocdCQW6wOOwAA
Date:   Sun, 21 Nov 2021 17:13:25 +0000
Message-ID: <20211121171324.j6kxclyhaheihpja@skbuf>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-5-colin.foster@in-advantage.com>
In-Reply-To: <20211119224313.2803941-5-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6d1d9e2-1b99-4537-a3d8-08d9ad123ac6
x-ms-traffictypediagnostic: VI1PR04MB5343:
x-microsoft-antispam-prvs: <VI1PR04MB534381F8CA6596CA18C36632E09E9@VI1PR04MB5343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 60GCCcyIUkcStqZFcL47IlXcizw2zZ22tAixUWkDUCYdqcErlQKEwH5TcrZKRsDMuu788Od9eokN6rEI2qDKAtFoLS1+JedCqKlTjR6a+xHX4/KrXtbJzH8PTCagHSU69P8aCAJPHL+fZtcAAubGyYQsjxGTZIFdiT6aS4snjEs+bEbWAXW5PS6cwv5AYWWjJm8aPaB0aYylCzwVX72ewHpY/WE7b8OV+MIM+PLGW5lwuMCzEUYxGK5ufIv6urnadj9BixsoILTlHYZEPl/48mIIC6okplKTeajkqIZI8oXb+e7WTHZnersAJ6uOuTSS8hxS7GgzYWtIDgMR+sxLuBNHp5Bl7+3gL2O2aiZWNunHFQtulqTsyl3DZ4BGJGEDvkKwQHE1EyY210fqV5P+BKDXvEg3pQXMIoAzvNsWA1/JJUpZInmHVscpOcdegZoneZPnBrf+d0wJwkhtXXPZuZ+plnpYFBys+/Z1ujsm7xbkpT8+Pc5SwCVPYPEUKJofaE3/nO1lPLLUTlI0X/5qeYqovGkOrXQZQCz+VMkfLp6RKfZzJgkfXL5guo7UPZLAcXRM/dH6joaBPUAYhg4hU30qZoXn5/SjTD6y0ta4gj1+A4J2fzZ8MBqI12h8bJsiW936GSHkCLibHxdBqX+K3vggw95DYv+SRbEgBBinzVx3UgYQc7ptJhgm9xx1VCTA40872lvfhCgvUKOlGQLW+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(7416002)(33716001)(5660300002)(6916009)(26005)(9686003)(83380400001)(4326008)(64756008)(66446008)(44832011)(38100700002)(54906003)(71200400001)(2906002)(122000001)(66476007)(66556008)(38070700005)(1076003)(66946007)(6506007)(6486002)(508600001)(8936002)(316002)(8676002)(91956017)(76116006)(86362001)(6512007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jRvnZFZm51F79NE0INJN14+V+BpBTvAGsQkuvkFJFTyOuFP+40/ZVJ60cfO+?=
 =?us-ascii?Q?p3xgpeWkcZ7a4qcEoQxx84C4jixZgiQ7gLM22sO1EgquOkQXvhMmcSv4EOvi?=
 =?us-ascii?Q?DMsGAH+3ITDfR8vQYTBwpHx3RDX1TSjKS8dHJoUhovdbBSC6JOQ4h+QS9e2H?=
 =?us-ascii?Q?DoLyHDUB5iEuzcUwiJVqSRrYqz+ANFHqUIGO69cHVAz0zBaa94mxUzs9HUac?=
 =?us-ascii?Q?r3OnCsHMChn2AjCwdBuYxFlSQH5GUfXUGAjIlGwSXJc5Kx5coXqAdZE6rl5V?=
 =?us-ascii?Q?7boOgV9cxw65mXzpARQU7Gqi0IcsWW8qD+hDhw9bgC+fot6+cC1zsY2J42P9?=
 =?us-ascii?Q?3C6nSW2eHV67Nz+aGKjgroQjty7clNELq4zO/m1SUXHdn3lyXE3Z1GSjSu6p?=
 =?us-ascii?Q?ma0N40P7CBJEC4uBBdABOoT8GzcqVf91iI3Z3ODQUJWz5entTu4uzGlnqcEU?=
 =?us-ascii?Q?F+L0f8YX67T0ONxdwOVM6gUe+mlqBGFimxVq34aGq5C20uU4PsBJ+0bl7TMV?=
 =?us-ascii?Q?uQ5EXtosVcdKcyTSN5E5Sv1aRI52XAuWd6SOUgFk9Z69XxuaBpOokBN6WPxB?=
 =?us-ascii?Q?ZrDtx01/51b5TMAyBTuCYH2ZRy2o+y6JiM7/WYk3wJKS8VS+HH6hF/a1pOme?=
 =?us-ascii?Q?t8hvWzVjQryEZQ4QUBKMwnLhNtYxEfjjvPyQK8Q0JgEck2sR6ppvt7bxiUCk?=
 =?us-ascii?Q?Oza0fWSk2cses4UlDfEUEygd8hOYukQumClmOADNSvqB1y6xe+iuQzITIxiU?=
 =?us-ascii?Q?T3IEA+vhk8Og915Z+9fPF2aj/IiWBbx1FTnBlpfZWekrTTHP7ULdPmGEKP6c?=
 =?us-ascii?Q?IjfKJFX2A0VXUES8rohCtAzdaDKkyfSywutmfuhNlgRwXS+b6YD8s67rzdWf?=
 =?us-ascii?Q?YvrAN0ONmYFX0LN2nsyfVRRSDSCkYN8OZj2CATw7kDEh+dLl1DpvE2G96Mm5?=
 =?us-ascii?Q?LOe+ELlrxvnoBpKvV5Tf5zBu0HhFeQkxes1eAhIdl3+ppp2ITutDPepVYnRK?=
 =?us-ascii?Q?htuEVvM7nhApKiPaqrRY3AlPIBYvi5HEjLh1wLN13Beusfp31IjJkfh+G1Df?=
 =?us-ascii?Q?FzB1jA1nAUU7LqvO1vLkfZVkUwzPpEM+JI7cbICSxR4hhkc35k74nNB8aCQv?=
 =?us-ascii?Q?JwQcIkbWMd5jKhVwvDo93p0QjgOBOqJT0hqI/NcECi246vT8CWMHRVoHS/t2?=
 =?us-ascii?Q?WgT/ifrVY0p5mS1lL+MDbrm5YYwCx/oU20na5QJrvgo8J0MVKWpMBZoh6K3u?=
 =?us-ascii?Q?81lBUtYhYe8gTte0/jPps+I3IO6wtm/m4BJPpNe62VYjjqszEfrch9h/fChc?=
 =?us-ascii?Q?DnJtIwTmoG5abFSHV2eTMaJeKt7Mpm6gH3ZLMK2zBfBwojLWa8NT1TEvYem2?=
 =?us-ascii?Q?w6VTbnlbTqZKsXnZ1fmC17jlg+fDe95X2KFxP/49vE/jWe4vhd/RhC95n1OG?=
 =?us-ascii?Q?ORNGhyE+lxGg/RZnHmS9GurKFz5qdzqF8ot7WaBr3ZzTrwgBbD7Z+Le8PkdU?=
 =?us-ascii?Q?raWriR1bw9IUeQGy8i/4X3qWzH1dtiaJBXSeeGVeTZH1VaNDdS7ADjja+w5a?=
 =?us-ascii?Q?FOxLnQE8jYzIbc3BzCgXz3DGSV+0iNl+7j/0cwNsVR59tO2jkK0BMDIdmsYe?=
 =?us-ascii?Q?AiGNlsKzubeqC7I6EjIEnd0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18A326311691EE498E92B40B9B5A02C5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d1d9e2-1b99-4537-a3d8-08d9ad123ac6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 17:13:25.4850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eK0G2+rMBiIoRKmsNZc6g2Vjz72B/UaS7lNEgH2LsTh4cBtBZYJTWUl2uKzqRMSivZOSD6OFe9lX4Og6eFHaYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 02:43:11PM -0800, Colin Foster wrote:
> Initial Felix-driver products (VSC9959 and VSC9953) both had quirks
> where the PCS was in charge of rate adaptation. In the case of the
> VSC7512 there is a differnce in that some ports (ports 0-3) don't have
> a PCS and others might have different quirks based on how they are
> configured.
>=20
> This adds a generic method by which any port can have any quirks that
> are handled by each device's driver.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/dsa/ocelot/felix.c           | 20 +++++++++++++++++---
>  drivers/net/dsa/ocelot/felix.h           |  4 ++++
>  drivers/net/dsa/ocelot/felix_vsc9959.c   |  1 +
>  drivers/net/dsa/ocelot/seville_vsc9953.c |  1 +
>  4 files changed, 23 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/feli=
x.c
> index 2a90a703162d..5be2baa83bd8 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -824,14 +824,25 @@ static void felix_phylink_mac_config(struct dsa_swi=
tch *ds, int port,
>  		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
>  }
> =20
> +unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
> +						int port)
> +{
> +	return FELIX_MAC_QUIRKS;
> +}
> +EXPORT_SYMBOL(felix_quirks_have_rate_adaptation);
> +

I would prefer if you don't introduce an actual virtual function for
this. An unsigned long bitmask constant per device family should be
enough. Even if we end up in a situation where internal PHY ports have
one set of quirks and SERDES ports another, I would rather keep all
quirks in a global namespace from 0 to 31, or whatever. So the quirks
can be per device, instead or per port, and they can still say "this
device's internal PHY ports need this", or "this device's SERDES ports
need that". Does that make sense?

>  static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
>  					unsigned int link_an_mode,
>  					phy_interface_t interface)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
> +	unsigned long quirks;
> +	struct felix *felix;
> =20
> +	felix =3D ocelot_to_felix(ocelot);
> +	quirks =3D felix->info->get_quirks_for_port(ocelot, port);
>  	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
> -				     FELIX_MAC_QUIRKS);
> +				     quirks);
>  }
> =20
>  static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
> @@ -842,11 +853,14 @@ static void felix_phylink_mac_link_up(struct dsa_sw=
itch *ds, int port,
>  				      bool tx_pause, bool rx_pause)
>  {
>  	struct ocelot *ocelot =3D ds->priv;
> -	struct felix *felix =3D ocelot_to_felix(ocelot);
> +	unsigned long quirks;
> +	struct felix *felix;
> =20
> +	felix =3D ocelot_to_felix(ocelot);
> +	quirks =3D felix->info->get_quirks_for_port(ocelot, port);
>  	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
>  				   interface, speed, duplex, tx_pause, rx_pause,
> -				   FELIX_MAC_QUIRKS);
> +				   quirks);
> =20
>  	if (felix->info->port_sched_speed_set)
>  		felix->info->port_sched_speed_set(ocelot, port, speed);
> diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/feli=
x.h
> index 515bddc012c0..251463f7e882 100644
> --- a/drivers/net/dsa/ocelot/felix.h
> +++ b/drivers/net/dsa/ocelot/felix.h
> @@ -52,6 +52,7 @@ struct felix_info {
>  					u32 speed);
>  	struct regmap *(*init_regmap)(struct ocelot *ocelot,
>  				      struct resource *res);
> +	unsigned long (*get_quirks_for_port)(struct ocelot *ocelot, int port);
>  };
> =20
>  extern const struct dsa_switch_ops felix_switch_ops;
> @@ -72,4 +73,7 @@ struct felix {
>  struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)=
;
>  int felix_netdev_to_port(struct net_device *dev);
> =20
> +unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
> +						int port);
> +
>  #endif
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/oce=
lot/felix_vsc9959.c
> index 4ddec3325f61..7fc5cf28b7d9 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -2166,6 +2166,7 @@ static const struct felix_info felix_info_vsc9959 =
=3D {
>  	.port_setup_tc		=3D vsc9959_port_setup_tc,
>  	.port_sched_speed_set	=3D vsc9959_sched_speed_set,
>  	.init_regmap		=3D ocelot_regmap_init,
> +	.get_quirks_for_port	=3D felix_quirks_have_rate_adaptation,
>  };
> =20
>  static irqreturn_t felix_irq_handler(int irq, void *data)
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/o=
celot/seville_vsc9953.c
> index ce30464371e2..c996fc45dc5e 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1188,6 +1188,7 @@ static const struct felix_info seville_info_vsc9953=
 =3D {
>  	.phylink_validate	=3D vsc9953_phylink_validate,
>  	.prevalidate_phy_mode	=3D vsc9953_prevalidate_phy_mode,
>  	.init_regmap		=3D ocelot_regmap_init,
> +	.get_quirks_for_port	=3D felix_quirks_have_rate_adaptation,
>  };
> =20
>  static int seville_probe(struct platform_device *pdev)
> --=20
> 2.25.1
>=
