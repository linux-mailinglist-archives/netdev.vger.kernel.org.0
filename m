Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D138E4441B8
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhKCMnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:43:35 -0400
Received: from mail-eopbgr30048.outbound.protection.outlook.com ([40.107.3.48]:33507
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232102AbhKCMne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 08:43:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REhVNfIIw9pSvbsPNKV4D4yvS8SW0Am9vtSX2ATarZC3febglJ2pDfTt2DHUirWJc5W6wo1Yy8pPnKMY+FeE7VnvlWUtZRk+BuWoEvBBcD63tQKtWLFLOLyp2V5wNZRMlV+M1J20fMEwDja3heRT8GF+84A9lFTSlEB0c2w3VvdMJ3X2pzX5yp4Q5XQHl3RO8nvqo18B2g142vVSLHOEgT0PF4QgXNC+jdKaXXzx7m9ToaPzhsbFj68AI+Ua859YRojzGAod6chEr3dPGWTVnd6Y5snMZNftGDu4G3BaP4wYlCe9NkUWjoBvIGtdE0J8AAW15+CLLwwNOOmLSp829w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1RwlS0x73SCEhphSH7Y1bimmvizD1vhGDfdMZpcVuM=;
 b=WpjGm2CZrU/1rAhP9S9Q/O37DJAlAM+QdyUQs0uDJMH/XjTRNMGvu7VZ/StU9SgE+I21bHJDyhJBSwr76pn/FF0UgoxAnMB+1cob5FnKjnNDqPta4iCVvqRwbAwMq4UQ29eK7QbyDbxEBh1kErrdoeN/swb7TS4t0E8V3KJBX2DBEjCOcaWxmZwFFFSwy/nQ8eeg4GPYi355yjKRY0r5o9bPqjc/WThoz2Xx8u79bxppE7ZmUUIS3pTXpuhtWFKW8dMmm5qRi6jwWx9ZcjQYpW+OZdEUbRfVHKG3qfMC/5zVQiOxlAdi5DYoSPECxIfIVG3AEpwIJe/rq/E7LPsINQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1RwlS0x73SCEhphSH7Y1bimmvizD1vhGDfdMZpcVuM=;
 b=L2ByGdVbh30xf7w9HinZcuNlw140XoR4XoCH4eexjmlwdDPWUnDuQCyGNjdpKApuA17NgT9WNq2+10rJzcrZWP7ZusrWEqvpZe3l+SaeZ6ybdIFiVxwqUXekhW8CfgGk5DEKF6KWqG4eJLOr31syUe8haPxLJA44v2t3EeLXUWg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5135.eurprd04.prod.outlook.com (2603:10a6:803:62::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Wed, 3 Nov
 2021 12:40:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 12:40:55 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 4/6] net: ocelot: add support for ndo_change_mtu
Thread-Topic: [PATCH v2 4/6] net: ocelot: add support for ndo_change_mtu
Thread-Index: AQHX0JQNbBf1f8rxU0yw3pmW3csadqvxvuwA
Date:   Wed, 3 Nov 2021 12:40:55 +0000
Message-ID: <20211103124054.pcgruuipw5cpup6v@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-5-clement.leger@bootlin.com>
In-Reply-To: <20211103091943.3878621-5-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f2e5bb1-1b77-478f-eabb-08d99ec72ddf
x-ms-traffictypediagnostic: VI1PR04MB5135:
x-microsoft-antispam-prvs: <VI1PR04MB51359BE4C3C0477267ADAF6AE08C9@VI1PR04MB5135.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:415;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1R7TLhatc008FRnN71CrujFPlL2QJDPUevoWUQQIbZFAomtcQTSma7Euv7WVg9N89b8KpQo4l716bgqdGD4+21tOFjMjvxY2fUih3eCI4z6A4E+QmzEmpLrMEPCrZk2ex0M7uMFoGr+0ZLEJiIHohBbMeGHul6n5qxoP7bBbhQhctkOwVOYBsl+mYYQ2DYZoak+14vaQHZETJjdbUyVcP5XslWbdWOzGQaSE/4pXI77E25T+9Cl9tO9bM5L3oS5VcLyd9mtqwqaK4KCm3cBW0XSkiXLrAhimh1KTyalOhCDVee8+9rg31oNQVDSHLFSfWAztFNlgg03rhavM2N09y5EWjnJkrW12xxyU/Bmws79jcALYGRZEeZcK2wevIeZdahm/Cd7G3O/R7bOD3h7AN2cvBGUs87UF2Mxgk4ESBHk48Bnvxn0uSTNly1+OP3+L3A36iV+c6Cs+bC+OhSOIRurcKxy3XE8Txi7RZBi2YXYF3kzIoMtYTheRX8m+8dSoWFzDT/FsAPfGUo0Ebq0CKL+SL9yQ+QY/CPa0MOtfbDSuS04waqKdFU6+NcZcIHwphv6+p5xr5effFyhj6HzOLHzdq0IPtAwNM1Mmt117GNINv172pDfi/1lAaDqxJMmZVRhloyIyQoy4J38Ql+/Y28zLBr/vahvh6gNB/LkbCODt0iAzLQR3ixEfYFkrTln64yFeR7sKENIqIb8S8Aua0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4326008)(44832011)(9686003)(6512007)(6916009)(316002)(5660300002)(1076003)(186003)(54906003)(6486002)(33716001)(91956017)(8936002)(122000001)(2906002)(83380400001)(66476007)(7416002)(508600001)(64756008)(38070700005)(66556008)(6506007)(8676002)(38100700002)(26005)(66946007)(76116006)(86362001)(66446008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ItM2KfvRSuDOei3D1Y8QtEauzWJDaoDrH4Ney0/KUMoFl1g1FmdSc95oVa?=
 =?iso-8859-1?Q?X4CQcRBsGodYxoCE4uLEN/BCKAwzR/Fj+Uh41hPXgCyQvK3w8Z0rk8IIA/?=
 =?iso-8859-1?Q?0A2gJowFARq4EPM/z7/r2jTu3jik+TdlVEKm5m2mRIal5nfy66nC6r4BJs?=
 =?iso-8859-1?Q?TM3GrgRNAclA9INitm6ncLxtR3cjWx/m7S92UlY51/tTaLMcoRuFXoDb/V?=
 =?iso-8859-1?Q?JrqMd3QVWpTKWYPNvteoyX4nNemQX07RR8VLmz7a2xH9Klgz4AWF701KsW?=
 =?iso-8859-1?Q?En5D8t8PLkVYbJqkVoxyGIKmuCsLwZGIX9zVYR9UmBwuLESDJQTSS+XgEC?=
 =?iso-8859-1?Q?a4npnNv8ukohRPEmINt5f18Gz2tzQwEDS3wcK9EcMVz5wnu7nJli0ISlCJ?=
 =?iso-8859-1?Q?s+eRMaPXqIzGqulJzfneRdHOA6k23sH6fliKIlgNYKoFAacxxWCdpE7byo?=
 =?iso-8859-1?Q?apHpd+9PJU/qzSHM6/NgHiEN9inrpvbjLm8GHMjhCwUbjs/hVPmSVkqBq4?=
 =?iso-8859-1?Q?lmMpz7RWU1iZIJZuHuL5yc0YmqX404naF/YfVt2ZuP8VetneC2oq1DR5Yk?=
 =?iso-8859-1?Q?MDgU9Uw30G4gr0SgHAWGNKTlXn829g3LjQDUW+lBGHpmjxvlhf4b0Rq6/j?=
 =?iso-8859-1?Q?yl6DNZ7cY62nqCiJixy6eil8g+lYA26+O9mMQDVFMcq8xAUEXHoXVvMp/Z?=
 =?iso-8859-1?Q?+VRTaSbwsw5eBl39hudWwYiLdRhnFKzuKvr3UW2v0q98f8NqsBlTvyGu7H?=
 =?iso-8859-1?Q?ZW0EaHQJRlNIPhTkkYywW7HUrRQSP0QpWAx4MGHYEEmZhBaoMo1+HVXtkt?=
 =?iso-8859-1?Q?HSfZ96Mur9YqRh0P4ByRWMOA8Rnr/Jdfzci9RSACtS7xPguIWlWqZPtrib?=
 =?iso-8859-1?Q?PN69NfcER/k7XOTxvtVZLh02rK78DRdq7lS/UuBS6kAg+hHzKJlhBxslLn?=
 =?iso-8859-1?Q?sIdi2sxAVOP3vVG38XYK5zOM18m7pLnswucUMMHI5F8BPvVCHdsoYZA20q?=
 =?iso-8859-1?Q?9wUII5dDbexylfpJ6MTdIuO6g61MwqML6loEvrs7DOL1tM/OrPE9SjKsRN?=
 =?iso-8859-1?Q?pi9E8Xf6GPERxcHFdiz770fC3/kSjuJ8QxkVG1vSpWA8dERl9D+0Ce4l2w?=
 =?iso-8859-1?Q?oZo0gcammFbJ7kNtrbvNzEcor5FGOFGE/0UXf3WWHr9EJ5lnb8swd5TV4k?=
 =?iso-8859-1?Q?ldgqFSnPf7jLupgFr2yT+l+q4wVGkHXmcWiTG27Pov8sseXUJkOHorVLBr?=
 =?iso-8859-1?Q?MiUHU+vToOnKk88BosjqENUL+Nj/+lf+PVOIqao7j8v1xy7Q467kNVXUK/?=
 =?iso-8859-1?Q?7OItzFhX+HsVycGLyDI9UkuGuxOy+X0g1zTnlpNr0CVqIu4N7y8j6gdrdu?=
 =?iso-8859-1?Q?V9Z0+YusirGN1TKp6MN03oxbGOLTi9L/KvGO2e2CVclanEBJhFefWLbdQl?=
 =?iso-8859-1?Q?Lr+xtqmRhTNADMsc/ewumNl0LHzg13fRQ0jyVdWEwDzqciRd3qlPhNtPAr?=
 =?iso-8859-1?Q?4ZD2jkpC06acOgc4JqmwFQ1/5LUb3MVXpfxubPYqX9c27bQ1Y9QBiS7hCw?=
 =?iso-8859-1?Q?j8WKTpYyqk2hC7MrM8OvMO2dOvuasgTL+t9znpz5ugjp9rwcMO7f5wHACV?=
 =?iso-8859-1?Q?mlZ/ATtdEVFQopAe3X9NS6RA2Plm5ZBQFF4x50YUzwFps6QvjXADf4dub4?=
 =?iso-8859-1?Q?6TB0w77qzxnqH3lW4yC6khz5+pEPnD8ullkn0AE8?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <DC0CC7D3B73CFD4D953FA7705DF96B27@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f2e5bb1-1b77-478f-eabb-08d99ec72ddf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 12:40:55.4256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4OfDUKYnIQc5j1BpL+1YlOE5gg4XZ0I5nsXgDfCqhHYGIS+4cFXf+9J1/6p0Rw2saJEwL75KgeduGYdfmx84hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 10:19:41AM +0100, Cl=E9ment L=E9ger wrote:
> This commit adds support for changing MTU for the ocelot register based
> interface. For ocelot, JUMBO frame size can be set up to 25000 bytes
> but has been set to 9000 which is a saner value and allow for maximum
> gain of performances. Frames larger than 9000 bytes do not yield
> a noticeable improvement.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.h     |  2 ++
>  drivers/net/ethernet/mscc/ocelot_net.c | 14 ++++++++++++++
>  2 files changed, 16 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/ms=
cc/ocelot.h
> index e43da09b8f91..ba0dec7dd64f 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -32,6 +32,8 @@
> =20
>  #define OCELOT_PTP_QUEUE_SZ	128
> =20
> +#define OCELOT_JUMBO_MTU	9000
> +
>  struct ocelot_port_tc {
>  	bool block_shared;
>  	unsigned long offload_cnt;
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/etherne=
t/mscc/ocelot_net.c
> index d76def435b23..5916492fd6d0 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -482,6 +482,18 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *=
skb, struct net_device *dev)
>  	return NETDEV_TX_OK;
>  }
> =20
> +static int ocelot_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *ocelot_port =3D &priv->port;
> +	struct ocelot *ocelot =3D ocelot_port->ocelot;
> +
> +	ocelot_port_set_maxlen(ocelot, priv->chip_port, new_mtu);
> +	WRITE_ONCE(dev->mtu, new_mtu);

The WRITE_ONCE seems absolutely gratuitous to me.

> +
> +	return 0;
> +}
> +
>  enum ocelot_action_type {
>  	OCELOT_MACT_LEARN,
>  	OCELOT_MACT_FORGET,
> @@ -768,6 +780,7 @@ static const struct net_device_ops ocelot_port_netdev=
_ops =3D {
>  	.ndo_open			=3D ocelot_port_open,
>  	.ndo_stop			=3D ocelot_port_stop,
>  	.ndo_start_xmit			=3D ocelot_port_xmit,
> +	.ndo_change_mtu			=3D ocelot_change_mtu,
>  	.ndo_set_rx_mode		=3D ocelot_set_rx_mode,
>  	.ndo_set_mac_address		=3D ocelot_port_set_mac_address,
>  	.ndo_get_stats64		=3D ocelot_get_stats64,
> @@ -1699,6 +1712,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int po=
rt, struct regmap *target,
> =20
>  	dev->netdev_ops =3D &ocelot_port_netdev_ops;
>  	dev->ethtool_ops =3D &ocelot_ethtool_ops;
> +	dev->max_mtu =3D OCELOT_JUMBO_MTU;
> =20
>  	dev->hw_features |=3D NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
>  		NETIF_F_HW_TC;
> --=20
> 2.33.0
>=
