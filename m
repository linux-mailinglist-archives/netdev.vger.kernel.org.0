Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E6C4A400A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 11:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358115AbiAaKXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 05:23:01 -0500
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:43205
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1358111AbiAaKXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 05:23:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvpbQM05Q8v2Mhr2CM3LmUmmRPoVlpGdyvqx3tKyZfQ9oPkSmxraONNSd6XUQee6nUOA+1Ac65kzbbrJmnh+1W3HPhE9sNLOU5FAOmnM9BEDvb5dB3limuBBwDlq5Xi/3jNl3UacEQBLqG7/iqoIlHGotO0gM3CzWx9L3yyRx47mjkp40IToHA+T1MtjaLbIyfkNteDq0AkxuL84wcgUIlusZO+FwSkzudxkIcAlEip6MSr0gAZhu8gzw1dva/GIuC1SVpHHsf4/w9juNVUIx3Fg37jQfUgSWRJ4kTjr3cX+IRPNlTQO/PgpM4gI9adDiwrlJ0f6FLllDsVKAaUu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4Vlc8JUM9VnP3gZp5w0amswva/g9ho4Yx/VJyv03es=;
 b=AeUWK/1ERHRTBTR/jWp207/SFsLmRwoaQjzFqjPp3u2xyhjt+sRSJ9xsU6BOS6d4KpYaXzsMKUDHovt+GO/unHuWPYsUvKTS5n4qdMkQeQAqt5JmhwxEVA8xIpx+5h/QUPFhPuJ020FluVZVDv4/VXvy4KK42KmlJOPcKsCoZocXjYJc9pRM6zJnU5LdkibzqZ/WrA5o5uuPpYzadQ8WQ+eN1uHX9ADHxLJzkyKPSXQPQ/8NSS3McZkPMxKErwC/1sru5Te3BbN8nBIisBkVwIyKS199ghV2eEEkygAdn3j8RUcd4WISt72ArRJun2vwP3Y3qeu5uQKBkQVvhA/WXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4Vlc8JUM9VnP3gZp5w0amswva/g9ho4Yx/VJyv03es=;
 b=cUg+4OwOFzGia7PoY5EtU6YN1opQPccapzmj5Izr9qBeurAsjrqkGTaj3Wao1hOLGip2NJNE0sar8wVLE6z79V7mpgnracxHG/aoN62tuNkJT7uaZNyAwY7mg62vLGr+W0sv9lXvW25t/aO98l+jHjTKawgo4gtrKfuFN+9byKM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by HE1PR04MB3100.eurprd04.prod.outlook.com (2603:10a6:7:21::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Mon, 31 Jan
 2022 10:22:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 10:22:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v3 net-next 2/2] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v3 net-next 2/2] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYEbthVz9uQK5vg0meyf9zLzYRx6x89Y6A
Date:   Mon, 31 Jan 2022 10:22:55 +0000
Message-ID: <20220131102255.zgfmbzmffup6rste@skbuf>
References: <20220125071531.1181948-1-colin.foster@in-advantage.com>
 <20220125071531.1181948-3-colin.foster@in-advantage.com>
In-Reply-To: <20220125071531.1181948-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca412450-1bd9-4a23-4a98-08d9e4a3a599
x-ms-traffictypediagnostic: HE1PR04MB3100:EE_
x-microsoft-antispam-prvs: <HE1PR04MB31004A7D2F24D011A2B797ADE0259@HE1PR04MB3100.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BMfxcR3SVYdv5adXUQKBTNm1zJOPSNHX/VAOQjPpvwFlqXxvIIejOfiMn4/QVRFaqnD3LNc7Ew/flvlkCBOzavl8srcIoZFaTbb32tzQPnH8SQRji0Vb5Nl1Mku2OJ2oPxsRL96Os7xuxEQCKPJ6rnWK5n7qKB+bKknz9NIpHi9vCrHRxPVZ+82COWcaZMiulope9L9SEqmFSbojVm/Fps7tsc/mAgn/j5UolbXyJC+Tob/KXcI0qma6GeQjU/tPaN+plyYkhjsKQHcil4wqORfO9dONwp2jnvXgBHbP51UG8vAN8uv5sFtFK34L2zA8TAaFad4rgFjCMiNLE/Dzcv2jgk7yEE9XYpwPWoxCo7V8hLqAluaa2RAnMkIgRe7hZ7WazkAde2kwlZhSFk6la9yf9TwHJuNTkvPAEuMkyuwMkmphdMl3UHeJlLA5L/Zvf8AyZGarOHZ3sA14y0P1t0pBdxzi3DUb3g6Ul5o9LHVNXqdmy3vRdyDyvAN0dYDzhr+98XXXo2jWsT0646YPueNzcNu1a4XmPdlc00hQfEZbf+SmtvAWCtckOTWlqJ7XOJVfS6GPXBg7q8uQn7wpJ/LbiGglgkhol3N/uxRSUmRpxPv94EQpC+vm3LSOOgPu6nHn2xxQuE5NwXHvNZK5XgRXPHn8VmkBdN6AFzmSzaUJF0c9MhWvz+hFzIjHOc8aM0aW16GNdFZ4OhyI6GJo3ECJCWYoQaJ4TtVUyS72ynBP1dpC99VL+H0nABtRLrTI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(54906003)(86362001)(71200400001)(1076003)(186003)(26005)(6506007)(6512007)(6916009)(9686003)(66946007)(66556008)(66476007)(66446008)(64756008)(8936002)(33716001)(91956017)(76116006)(508600001)(6486002)(316002)(38100700002)(122000001)(83380400001)(38070700005)(8676002)(4326008)(2906002)(44832011)(5660300002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dlDnfg1SAhg4T32A5XUPn51xsyi42CRE6VxuI3eB50UGfeyvhSJelbSAcKKv?=
 =?us-ascii?Q?gzi2j0oixjnewsbHwfCFWvIJr2CisqjsqNOumfJmTzPfOaoAYyEProR/t9bN?=
 =?us-ascii?Q?g5YnJ5f4AmExwVvR2PCU0DOkxg2GbKcxfJawrpQ0Dy76XEM4Wzm3d1lKZYKQ?=
 =?us-ascii?Q?MousCqPhoew3dMkg7Yr89IWux4SDVouYViIJ3Zr+XaGCJF3G+WlzLffIji1Y?=
 =?us-ascii?Q?ChiAMRpzOB3gMlWFEBKKNZt/+te1m9eoxzzSaKvpkl+STfBp/B61I2FHzEfb?=
 =?us-ascii?Q?jSaXrkmSkoRmFOB0LR7lSA+6HZ2vBU/GTluGQLQeQpJg3EfeqQTKChRU/pw2?=
 =?us-ascii?Q?n3gBE6KMhfngMj7qTmgB70DnJwuPQei+ZRSlaKDUQiy+T0jOEmTKPgJnAtuN?=
 =?us-ascii?Q?rfqo1ze6bkEAtaDE/yRHJonFePIBUaaKzFfkg1qhEhYEpQn3UjZsbciqU/Sc?=
 =?us-ascii?Q?fyjVwLHs17pxIGt//NGgeBVPUST/zBwLbdASQvB3sIhiFSfVGlp9/VFo/vq0?=
 =?us-ascii?Q?cxnYf03biDSOYTNQIvVWmPHN8k2fznCZeAZuakbrj52CQGZ/oFO2OM1+QwrG?=
 =?us-ascii?Q?B6U1sqYVabxh6GsWRx91Kfywwo+h8iGTnn+VjrTkhtjkG5Y3X1qdXve/rqGY?=
 =?us-ascii?Q?eE3UH0I3fll/YCYLanmkbH+A8kvUCH0tM60zdrwN4BiETtaxoLXlb19G50Ef?=
 =?us-ascii?Q?VrPrvXsq0SiQORhGYy2YtoBDPvJdJeCcvOiZK+D180Lt/jumk+Zt2+185oSx?=
 =?us-ascii?Q?6YIrPJewMXnveZha7zZyuttQGYXvR8XFFjGLwtbTzNnilCWqf7ie0LczA+1d?=
 =?us-ascii?Q?4NHV7hszQ4eSuNlx5+5CaV/BrmugWgO1sgmxyORLNB06XjFrAYmtbZwqWZR6?=
 =?us-ascii?Q?Jplu23R6VcyYtNzvxtyrKIpRywnP1m6jkJDYWpJBTsp8nDSLFdfZS6kUAyUA?=
 =?us-ascii?Q?I+NBOmEVZVrZ1abCfKiful62RYufr557HV9893wcTscyrJn7fVCuLXYD5Sa1?=
 =?us-ascii?Q?brpTj/cpXOu/cxxC6Gp/+sydx3He4DXRk2ugvxQDHA0d8aNL147yFk67UHMN?=
 =?us-ascii?Q?pBzzSYHYm385qCqt5cFWVmF/CWBxQGQTtmBIyHqR+7e9cfC9Q3FmM/LBYHv1?=
 =?us-ascii?Q?J8WzXBXei/KCyW16kvU1OEpnnWY88cw2YBQugwCV2KFlyn+Bic9wYmkRfXBf?=
 =?us-ascii?Q?VEomhTJmxLZn8lZZsWHBt9MK+ZVhQUHxugAFZ6OoNtv0luIIosojCUwIcLS0?=
 =?us-ascii?Q?rThz8V59G7M3T2ZxT6D70LKuze0jRwwgEImPVAgbLb8ev4HrqSDfVqq1rYy8?=
 =?us-ascii?Q?yuXm/DkSbJVbIqPRp5EhkkGN046nWtHNOjSwww+eA6hjqpPkuIebdUfB8x7V?=
 =?us-ascii?Q?q+cPg3Tf19aOupS64s95Q7nA8YLe4KebQNlaw1+ZW7hcUVwK/iZqWhBk47Sf?=
 =?us-ascii?Q?3sTIWNXGAIavBaPU7D9pX0jtWKvTs2FCjdTwQyqJ44W95RLHhYO+pq/VZ0Fz?=
 =?us-ascii?Q?bDwo+1uVp4RwwqO+Y+0UbWXha51Dzqe4ocG+gi0YTmVtcudEHFEB5VkecHJz?=
 =?us-ascii?Q?AllE8D+JEaxfa6ceG5vqGpVpqK9KgDLiziukbQb0tVRiOdSpEZyJoVwCT4cb?=
 =?us-ascii?Q?7BOEMonjKnqMrUaKhk2UacU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <68D8BD4E713B0C46B0D157FDD0BDE57D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca412450-1bd9-4a23-4a98-08d9e4a3a599
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 10:22:55.8099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HapFQELSWAlr+JvH1cO0+vwhFHUVH5jyCtNVxpZ8CPkTd9uhgwLuypr/FMu0VpZDTZFyEet2exlCzlbeNP9DvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 11:15:31PM -0800, Colin Foster wrote:
> Create and utilize bulk regmap reads instead of single access for gatheri=
ng
> stats. The background reading of statistics happens frequently, and over
> a few contiguous memory regions.
>=20
> High speed PCIe buses and MMIO access will probably see negligible
> performance increase. Lower speed buses like SPI and I2C could see
> significant performance increase, since the bus configuration and registe=
r
> access times account for a large percentage of data transfer time.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 76 +++++++++++++++++++++++++-----
>  include/soc/mscc/ocelot.h          |  8 ++++
>  2 files changed, 71 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 455293aa6343..bf466eaeba3d 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1737,32 +1737,40 @@ void ocelot_get_strings(struct ocelot *ocelot, in=
t port, u32 sset, u8 *data)
>  }
>  EXPORT_SYMBOL(ocelot_get_strings);
> =20
> -static void ocelot_update_stats(struct ocelot *ocelot)
> +static int ocelot_update_stats(struct ocelot *ocelot)
>  {
> -	int i, j;
> +	struct ocelot_stats_region *region;
> +	int i, j, err =3D 0;
> =20
>  	mutex_lock(&ocelot->stats_lock);
> =20
>  	for (i =3D 0; i < ocelot->num_phys_ports; i++) {
> +		unsigned int idx =3D 0;

It is usual to leave a blank line between variable declarations and code.

>  		/* Configure the port to read the stats from */
>  		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
> =20
> -		for (j =3D 0; j < ocelot->num_stats; j++) {
> -			u32 val;
> -			unsigned int idx =3D i * ocelot->num_stats + j;
> +		list_for_each_entry(region, &ocelot->stats_regions, node) {
> +			err =3D ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,

I'd be tempted to pass SYS << TARGET_OFFSET here.

> +						   region->offset, region->buf,
> +						   region->count);
> +			if (err)
> +				goto out;
> =20
> -			val =3D ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> -					      ocelot->stats_layout[j].offset);
> +			for (j =3D 0; j < region->count; j++) {
> +				if (region->buf[j] < (ocelot->stats[idx + j] & U32_MAX))
> +					ocelot->stats[idx + j] +=3D (u64)1 << 32;
> =20
> -			if (val < (ocelot->stats[idx] & U32_MAX))
> -				ocelot->stats[idx] +=3D (u64)1 << 32;
> +				ocelot->stats[idx + j] =3D (ocelot->stats[idx + j] &
> +							~(u64)U32_MAX) + region->buf[j];
> +			}
> =20
> -			ocelot->stats[idx] =3D (ocelot->stats[idx] &
> -					      ~(u64)U32_MAX) + val;
> +			idx +=3D region->count;
>  		}
>  	}
> =20
> +out:
>  	mutex_unlock(&ocelot->stats_lock);
> +	return err;
>  }
> =20
>  static void ocelot_check_stats_work(struct work_struct *work)
> @@ -1779,10 +1787,11 @@ static void ocelot_check_stats_work(struct work_s=
truct *work)
> =20
>  void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data=
)
>  {
> -	int i;
> +	int i, err;
> =20
>  	/* check and update now */
> -	ocelot_update_stats(ocelot);
> +	err =3D ocelot_update_stats(ocelot);
> +	WARN_ONCE(err, "Error %d updating ethtool stats\n", err);
> =20
>  	/* Copy all counters */
>  	for (i =3D 0; i < ocelot->num_stats; i++)
> @@ -1799,6 +1808,43 @@ int ocelot_get_sset_count(struct ocelot *ocelot, i=
nt port, int sset)
>  }
>  EXPORT_SYMBOL(ocelot_get_sset_count);
> =20
> +static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
> +{
> +	struct ocelot_stats_region *region =3D NULL;
> +	unsigned int last;
> +	int i;
> +
> +	INIT_LIST_HEAD(&ocelot->stats_regions);
> +
> +	for (i =3D 0; i < ocelot->num_stats; i++) {
> +		if (region && ocelot->stats_layout[i].offset =3D=3D last + 1) {
> +			region->count++;
> +		} else {
> +			region =3D devm_kzalloc(ocelot->dev, sizeof(*region),
> +					      GFP_KERNEL);
> +			if (!region)
> +				return -ENOMEM;
> +
> +			region->offset =3D ocelot->stats_layout[i].offset;
> +			region->count =3D 1;
> +			list_add_tail(&region->node, &ocelot->stats_regions);
> +		}
> +
> +		last =3D ocelot->stats_layout[i].offset;
> +	}
> +
> +	list_for_each_entry(region, &ocelot->stats_regions, node) {
> +		region->buf =3D devm_kzalloc(ocelot->dev,
> +					   region->count * sizeof(*region->buf),
> +					   GFP_KERNEL);
> +
> +		if (!region->buf)
> +			return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
>  int ocelot_get_ts_info(struct ocelot *ocelot, int port,
>  		       struct ethtool_ts_info *info)
>  {
> @@ -2799,6 +2845,10 @@ int ocelot_init(struct ocelot *ocelot)
>  				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
>  				 ANA_CPUQ_8021_CFG, i);
> =20
> +	ret =3D ocelot_prepare_stats_regions(ocelot);
> +	if (ret)
> +		return ret;
> +

Destroy ocelot->stats_queue and ocelot->owq.

>  	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
>  	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
>  			   OCELOT_STATS_CHECK_DELAY);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index b66e5abe04a7..837450fdea57 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -542,6 +542,13 @@ struct ocelot_stat_layout {
>  	char name[ETH_GSTRING_LEN];
>  };
> =20
> +struct ocelot_stats_region {
> +	struct list_head node;
> +	u32 offset;
> +	int count;
> +	u32 *buf;
> +};
> +
>  enum ocelot_tag_prefix {
>  	OCELOT_TAG_PREFIX_DISABLED	=3D 0,
>  	OCELOT_TAG_PREFIX_NONE,
> @@ -673,6 +680,7 @@ struct ocelot {
>  	struct regmap_field		*regfields[REGFIELD_MAX];
>  	const u32 *const		*map;
>  	const struct ocelot_stat_layout	*stats_layout;
> +	struct list_head		stats_regions;
>  	unsigned int			num_stats;
> =20
>  	u32				pool_size[OCELOT_SB_NUM][OCELOT_SB_POOL_NUM];
> --=20
> 2.25.1
>=
