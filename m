Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950BB4ADBEA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379246AbiBHPDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379219AbiBHPDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:03:07 -0500
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00077.outbound.protection.outlook.com [40.107.0.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58C4C061576;
        Tue,  8 Feb 2022 07:03:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCWdQw+J8isnObd0y/Au5SaxFxX9xFeJE/uFPWLe0qYA38HjodoG6sbbWpIb+QCFlrwjmVbkeY4mv5elde/c+boRahs6Y4bk7GIBnXhOBtijsOnhLPq/fG+tyxg5vDC3YvbZhzumSlOPysVsD/ISIUrxOki2hs8csb+sohIEUAiXWQWwS4cva2odPH8hs0PNZ+SWtV5nTmz4G3Yrv0CflQGi2qlx4Qp7IjLySbb35oOcvxzxCbdLGoQ/Wk0w4v4/eiQ73sBJUbdmgcAgJjQzlpcYG5pjAC/8Zrdnu16T0Atk1qYCReTeLwriMTMDj/H7IYcJEI0fSeW8yGLae/XcHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJsGYVPKtITexxciYt78g0u951o++hiN43YJfIR2ccg=;
 b=Nty2FWTrKjF084MyOvkJl5L8n/5r41WKEPHleM2+ASliD/65paxog62IrNCu8ll5BRtyUMGMlEGQP3RbJ9/OmP2uCaTznqWENvvKebnzwlbxc+sxJDoBp7T8pmTD0fDzB8DKoSUH+zpz8SzGsmxhnJ+y2R2feOiVG8emk6PNErKlhEQrwl/ntoxckZmcQc7I3aB07dRTu2L4AzPA/ssNOdt2lyhkF3G64eZzAX3FijkTteUnrYGGg4RLWkB5gNUwN2Me5Qls97Q+sqK1+nulnYH++uzEL/C6lUlr4Csj1r0mJINzTI5wH2rOTrwSmIvYldKTsCt3lbcFOAmjXOa3kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qJsGYVPKtITexxciYt78g0u951o++hiN43YJfIR2ccg=;
 b=CfwB8Vn2g7qUQH7NBYeZ6xcct7bAzNWrNk6jycKRqmMNVH+JTpLFw9+OlNwuihIlgoU8vjam7Lb4P+lR1aigMDh+Bb3RHU0G2WVBeM8CARDgghUZM+12Y7r5Pd2eWEy8J1hZhvqlVpg5Qf0yCBKkg8lLb/fmyPpmxq/weKBSqio=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB8050.eurprd04.prod.outlook.com (2603:10a6:20b:246::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 15:03:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 15:03:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYHKbq8GXukjoutEaxquFuvaFzqayJwKKA
Date:   Tue, 8 Feb 2022 15:03:04 +0000
Message-ID: <20220208150303.afoabx742j4ijry7@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
In-Reply-To: <20220208044644.359951-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 128114fb-ac57-4c9d-bff5-08d9eb141bb2
x-ms-traffictypediagnostic: AM8PR04MB8050:EE_
x-microsoft-antispam-prvs: <AM8PR04MB8050CB7727432EFC15BEEBEFE02D9@AM8PR04MB8050.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zFrGzE48lZcs6tevSrQaju8BFKnMdbMfEj7c0xEu8VZD8GT3AFgJ186hp020+rFxIWJs+BCAh1FmV1p0zZadOwpSTiq5atN/7iNSFvtHRAUXlVDSG2/e4RCM/XJd5cm3ZM7XbnL7XyMrTJFQa83KCb4z1XIWhTHQnoiTSqv02GA6e07YjimBPdjeh06O5fSchONjUlg5f24SlykcupMPfS+bb5/4hNhxJg/CsN08lQ1Qxqw+mdTfI82UWbDmjy0PiOArQD4NWDW/bVABEg3JeSA6U7oFhXr8BsawZsN0sH2MneJjP/e2f0lN0I/7dRMKRWl4pHHejnPB89p8LWpkaBIo1rQL3piTO+VgGlwgK+MYv3KbPqqYFKsmUt1ByzxCDKL5CDuN30v9wLNS53RVQeytsElmDfxoLhSKEL3lb8mRwr10gqlFrEi9HGxo08IXJjIJP2Fm3okswFcntcN3YCyvvg9EWBaLonc/GEZBD2UkHqSwzEFoYSLuGqedqmHU7mPKyBQtEa+6aRbteNPFKbaSB8JdbM9hFcm7lNTwWV1Ta5RdjfWt4MwSCChLJ9i//RJNU4wU5ZRQa0yjyVEhJ9rasz5uJBolP4ACI4XZrIWo2wChACzRBrYGk/U0MSo797P38FfMF0obpHmr2f73Po3iwKjvWXrq58Ew6Qg8MMsznpAaap+qEO0xJ+0+Dvk8fQQfg3h+TPwYYHQ8rKGhOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(508600001)(86362001)(8936002)(6486002)(76116006)(2906002)(6506007)(66446008)(66556008)(91956017)(66946007)(71200400001)(64756008)(6916009)(8676002)(316002)(54906003)(66476007)(38070700005)(44832011)(9686003)(186003)(6512007)(38100700002)(83380400001)(5660300002)(33716001)(26005)(1076003)(4326008)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nTpFGh17puV10SIMWPcbBQ5bLeePIdCeNs+p2ixwMGbQALTSvG+WYVG7lwei?=
 =?us-ascii?Q?hpGAxUXNNzZaMzIdfMpy+ddy5+oJMQg0pZpfR/DC4cvFp/LxMBdEgbolowiB?=
 =?us-ascii?Q?JZs4sPOGslMVcpyicuxRoOYaQ3p6LdW+dXtm7Dc16/G3WRBqkUbQSDfEsByt?=
 =?us-ascii?Q?LmhJLrJFl6/U2zFbI4ne4inVgey9f9ohasc6L7thdAX9BF/3+Wd5Fp1DhRW3?=
 =?us-ascii?Q?4X9tW/Y9QcxEVs0PlF4r/AYd81T4mFdMRNZZ2OxLI0l7lPBvuhW9oksCYtvL?=
 =?us-ascii?Q?ejRx7B+LMP5hwP4b6OXF3U9rHxpI0gdtBwhqWL5q3qzZTUJr0vl8chyeo4kO?=
 =?us-ascii?Q?NO7tRIY/scMFriRrDW5+lMg0n8ODSLEP8ehmICdsdhsXQV2itWJ/mo2goEc1?=
 =?us-ascii?Q?2Eq+EMImzSjIyU4tQ6KmK9KByvebn1Qcr6V7Wnlsa42nvIyK4puCdOBfBjb1?=
 =?us-ascii?Q?sX3djgOGWnVwRUEjwhYHxF65CYGEaTmOzNuRgdjZaTCuSjgcy09BARaXdViG?=
 =?us-ascii?Q?qUkdeZKfO8KJW4Y9piAh+96+cBO3Gklf2nYObiiDCYpv6/Ai2nCQqFbqWkTy?=
 =?us-ascii?Q?TfVuKRl7y0CReBhkeylx6VoyKQhV2AvKIQJgPuF17skebnqIFovE/S6Z7S8p?=
 =?us-ascii?Q?C6O5IdMoZf/2dbAnjeLE6ZrvTu0+n8nGE+vPu8gQvWDalCBR+gU9xjO42txD?=
 =?us-ascii?Q?4gI/Ir/Myj4UYijXdV2LL5FNpqPKhukmDHwCfCTd/KiB8IFq9NPdXxVqohI6?=
 =?us-ascii?Q?oTsHZeI0m8Kmp5u4XcHCFOqZVcSRWhwRmerYvHC1c4Z2fUj8e8K7HaaGt4EZ?=
 =?us-ascii?Q?REXIXPE222L3dOMIVTY0bcZSDQeOYjusF8kBURPiDWSx3rLgtxK3TNKYcYXh?=
 =?us-ascii?Q?D9Isr4QD+ipb8ws6khozHind2uOnBPd876918nTaSnPkcFXzG22weBBy0UIV?=
 =?us-ascii?Q?guGWdc6P8kCDUksnuLkQrr2QdX6DQMVcw5JrmUwuqSqZFhZbT7zKJfFc/1oL?=
 =?us-ascii?Q?+ZKxxEusjccNZDj8GNoBuipsIYtnVpXkEYYjOEE6FQRaENnd/rj8vXSsLPjN?=
 =?us-ascii?Q?OU+BOAzjJORb+Iifc73LCULqgD4hQof1ipkxzTaYKexEZbSkUv2BYufDFQD6?=
 =?us-ascii?Q?HyFlrge8eLokpnzOoibsuIZJhG9s1LFElReIjVu5pJ8bEE6ZYqF2TR9QvQNT?=
 =?us-ascii?Q?judUSmej1knGnrvTRYu2R7HcJKtazD7yx2AcaiPzn5x1JBdyiUbq6hOa24/T?=
 =?us-ascii?Q?PQvjIl8mb6BmSzef8V1DnSxox2mdn6aZ8lG4a29I7RANkFZFcb/ejMeiz1fg?=
 =?us-ascii?Q?r8lQlrSnwoKcjibH6axbQotAlT97DM+nsFy024vepMZl0NsjHCP5foJgLb/0?=
 =?us-ascii?Q?Ai01OFlP8tVTdBIskRxv/5r9/zKNEbN4IKwIB2bGuhHSj/Of4wgKTCAhZNhI?=
 =?us-ascii?Q?0Deio1CVFrZVGzDkg/q1S8FasFVQGvfTAUtYNy5QghgAUuPE8zdAp38jG38+?=
 =?us-ascii?Q?qpP6KAP8J7lh1wQaRpNWyxLfAuEdX5uscJsVOjjqh4/BZwRwrfCulNCxwp6b?=
 =?us-ascii?Q?7ioKAaohzHqby0HnyMh2MSLAAHLqmBVbtuZIx/SuEvsaUUtnJT8uxHZUMllN?=
 =?us-ascii?Q?vEpyD8zRtt8mKCTQb+37YRLJRe5h7406y5DBhu/Rre1t?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <796176F8B4425246A9306D4A7F2577C8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128114fb-ac57-4c9d-bff5-08d9eb141bb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 15:03:04.4958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dx5kHqKsNWm/JeYVjf5VmgaxSOUAdH0ENoovIZzskbv3vVNH/SX4ZZZJMG18JdetD7cM3oq0cf5sraOpAlQtwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8050
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 08:46:44PM -0800, Colin Foster wrote:
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
>  drivers/net/ethernet/mscc/ocelot.c | 78 +++++++++++++++++++++++++-----
>  include/soc/mscc/ocelot.h          |  8 +++
>  2 files changed, 73 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 455293aa6343..5efb1f3a1410 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1737,32 +1737,41 @@ void ocelot_get_strings(struct ocelot *ocelot, in=
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
> +

This is a bug which causes ocelot->stats to be overwritten with the
statistics of port 0, for all ports. Either move the variable
declaration and initialization with 0 in the larger scope (outside the
"for" loop), or initialize idx with i * ocelot->num_stats.

>  		/* Configure the port to read the stats from */
>  		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
> =20
> -		for (j =3D 0; j < ocelot->num_stats; j++) {
> -			u32 val;
> -			unsigned int idx =3D i * ocelot->num_stats + j;
> +		list_for_each_entry(region, &ocelot->stats_regions, node) {
> +			err =3D ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
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

I'd prefer if you reduce the apparent complexity of this logic by
creating some temporary variables:

	u64 *stat =3D &ocelot->stats[idx + j];
	u64 val =3D region->buf[j];

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
> @@ -1779,10 +1788,11 @@ static void ocelot_check_stats_work(struct work_s=
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

Please, as a separate change, introduce a function that reads the
statistics for a single port, and make ethtool call that and not the
entire port array, it's pointless.

> +	WARN_ONCE(err, "Error %d updating ethtool stats\n", err);
> =20
>  	/* Copy all counters */
>  	for (i =3D 0; i < ocelot->num_stats; i++)

and here, in the unseen part of the context, lies:

	/* Copy all counters */
	for (i =3D 0; i < ocelot->num_stats; i++)
		*data++ =3D ocelot->stats[port * ocelot->num_stats + i];

I think this is buggy, because this is a reader of ocelot->stats which
is not protected by ocelot->stats_lock (it was taken and dropped by
ocelot_update_stats). But a second ocelot_update_stats() can run
concurrently with ethtool and ruin the day, modifying the array at the
same time as it's being read out.

The new function that you introduce, for reading the stats of a single
port, should require that ocelot->stats_lock is already held, and you
should hold it from top-level (ocelot_get_ethtool_stats).

> @@ -1799,6 +1809,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, i=
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
> +		region->buf =3D devm_kcalloc(ocelot->dev, region->count,
> +					   sizeof(*region->buf), GFP_KERNEL);
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
> @@ -2799,6 +2844,13 @@ int ocelot_init(struct ocelot *ocelot)
>  				 ANA_CPUQ_8021_CFG_CPUQ_BPDU_VAL(6),
>  				 ANA_CPUQ_8021_CFG, i);
> =20
> +	ret =3D ocelot_prepare_stats_regions(ocelot);
> +	if (ret) {
> +		destroy_workqueue(ocelot->stats_queue);
> +		destroy_workqueue(ocelot->owq);
> +		return ret;
> +	}
> +
>  	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
>  	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
>  			   OCELOT_STATS_CHECK_DELAY);
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 312b72558659..d3291a5f7e88 100644
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
