Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577164B0AF3
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239831AbiBJKgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:36:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239748AbiBJKgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:36:39 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2073.outbound.protection.outlook.com [40.107.21.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBC9FD6;
        Thu, 10 Feb 2022 02:36:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BF3fdH+xBFu6meoRUiTjzriFc50d8eXSlG1YDahVgcprZkx+h0sd5PVbZogyRHvCQ3fslElE118rpjbcnWcnkxBAWg/nap+NZcng/IBMw1/9JDh20lv+S3y6mIusHpLiqqZw6FxeXDyxI7votvTUpsjTv7bsuON7/bl95KeFvfP5CRrEE1MCPoa+LX9DkrfXN4B1ptg7tWh0nROBSsFsPVGa8Cg1NKi9rK+zHst3fImDmOzdEVmzSGfe+Our10j2AnVI+Yyr1vlb0nAE9SelipfyfeAsp496kuTiEbr2+hBqz2iA09sjBY0P6u7Qm+jaS5Bf5aa5H1hRSjC98sE02w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bhu4dFpTSRWfdXQm/2HtLs9GLkhHK0kU5HgWyY88zyk=;
 b=AkEjnmTjwFFh8bDbmIfm1Pjqe3amsKNHNZMTbiCohqS0+QK14GGRjdUMR6RYn5cyfX831DD5MLoNGyT9BqPUV/pkcKNjRykuOpcna+GfKg6wGsDU/+p2E4AmZTWjrjrBxLPHjwIhu5N/5mUkLFig2MtGXKBb7tg9+4Q60QkT6J4aSF/ag0qd9YjL3prKs8/lSMyQg+Yv+UxlkPxmfc8evc13nbBOyfeZAirwEhu0mPZu7ytKo/ths4dafP7UoilfjmtOcs1j7DI4C/D3HwNbGMpwxz9Wa1MsRBjkMR+AcPcnF0VqWt9opZSyHxc9oFHfufMM1qQN7PNLaAU2Jf3DTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bhu4dFpTSRWfdXQm/2HtLs9GLkhHK0kU5HgWyY88zyk=;
 b=Qup7PPp+l4LiPS4GRiIdaQgaLMY1y20oWhDqUV3cK/y/2w53riZ5sC9TtTdFMofVeBU91iUkPBH+0RUxNDt+GOrMIf6XyLuMkQ6xDcLy65awMClGBk2+tYl7EEm4gO1ZeqmiekaHU5Y+yduHz5SbWjPrIfP3bnmNQn8u58tDoFA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3899.eurprd04.prod.outlook.com (2603:10a6:8:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 10:36:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 10:36:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v6 net-next 5/5] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYHjTfHymZJxNNSUWpsn5mKney/KyMl74A
Date:   Thu, 10 Feb 2022 10:36:37 +0000
Message-ID: <20220210103636.gtkky2l2q7jyn7y5@skbuf>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
 <20220210041345.321216-6-colin.foster@in-advantage.com>
In-Reply-To: <20220210041345.321216-6-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fea4eb83-12b7-4eb1-8aae-08d9ec81379a
x-ms-traffictypediagnostic: DB3PR0402MB3899:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB3899633840D9D545CC4EFD89E02F9@DB3PR0402MB3899.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V/9k4bubWKpSLm5zrMPaq81Zw0VKJ/K228Tq23vjjIXI1lGeoWEwIz+CMIqgWjEnWvemqmCJSMSakoc2V8BoayF5IYi4GzICoO+IaGlBmlJoN+8j+VE/+ppEEVGz7OWUZwk90pY/49zpV0u1MClPfs2uAg6H/c+cAkoAglWfOd9BWOpNPYN6efXzzPo2WCrPwD6d6aO4e319qC6b2LcRcKINSt+xJsht3mW/CTG3+sBmg9yTH2mEIGSzJTtfKncZzET89t1OTtAOAnjBF0wzd4disTIyHaZvIgK5YRmuX0KaisVcC974jRFBa0bfH2IMdicwuW8G6qswgPWLDs5cJidtKePmvGXcbsYKm/ihPhIxWNVJuPp2Z9mEo/b0twgw+tQb0VmLUO54FH2LLKGeyyyRwT4Di01WHlgvFxpPgBsPKnRl1tICpYJTSDDlMwtyOz0Z2A4ryZW238E0JNXL0lZse8N9gcvMuJXaYs9nhpIS+1T2y2DgfWKiDy7v9H4O8GdT1ebJxxJijIKDn5svDjTeZCquDGfKuEFupnad3VN2CIl1Cxg1EZ9jZmlM16qVFhGqaV75ZywRYw4lVCugbFPNlW3WuOc4zYUWigEnMC/EHdqv8wBf0cH4EmmiXmjqJF8DL029oRpsSCbV5EmzI7gopmv7Kaew3eZpVBMH2NpNE/t39LamXALOcytnQAnngYoD0kkb7wi3kevT9DHt2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(33716001)(8936002)(38070700005)(316002)(54906003)(66476007)(8676002)(4326008)(38100700002)(76116006)(66946007)(1076003)(122000001)(91956017)(6916009)(66556008)(66446008)(64756008)(2906002)(26005)(5660300002)(86362001)(44832011)(6486002)(9686003)(6512007)(186003)(6506007)(508600001)(83380400001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jdHtGq4JFDW+sTXovCR+JdQCJwEsIUJIhU/kdroJn2RGdKw4JWCfMzFPY7Dg?=
 =?us-ascii?Q?dBU4omgJ3gpC0fAlELzW7vPp4mHZ0k3rzuaRWI4Z/FTo3YjSk9ral6hzHXXS?=
 =?us-ascii?Q?pT530W6xSRCk6pVCR/f/vpzPPE83UALgAtDtb9wA1nVNNFHzKoGW73p+NzSF?=
 =?us-ascii?Q?DI5BASlx8+Ymwt1yOeG5wgXvqjyN0WRWttcj5ORtymNmNuEV7pyiZKeb4egH?=
 =?us-ascii?Q?q+9Wr0pjiCO1hAnrWH8a0ttDJpgElMRIKNWNul+UMOCDxcoxyXMIYBHQ3WgF?=
 =?us-ascii?Q?dzBJ6SRe46X2IvYMJdpCF1spwtxKeMPvZf86GQf6RQFJ2HJ/+YSK58q+ETop?=
 =?us-ascii?Q?yRrR0dJfpohWiOTePBFkrEImj+JOV4lz01qsAUJXti5NI1QmeooDKZET0zOA?=
 =?us-ascii?Q?Y7jH4u1Xcm2s4hadfmxPpy9YVIeJ3GkzXwQ0rqkvOgd7RMnQErCuPM8ZRxKn?=
 =?us-ascii?Q?UhQJ0CnfCTKy+76Fmo0zj5dM/CAscG+2XJeg0krqkTXOSv1qar3WM+Q6rIlb?=
 =?us-ascii?Q?Pporv6K9dDa+TWJEuCs3p3TEQ8Q/PoDmO+IH7yNdCYdkkpIPOji7zThfvqTx?=
 =?us-ascii?Q?EG0aenjc4w8GAYU4nJqemjHt98wyhzVhRWgxnUarFwimxRDrWYbco7Epl8jE?=
 =?us-ascii?Q?RxPPI+uNNqdvrod/eNTdc1lHyT/V1XwCZmGYu766eaNgdQ9lS+2pP3f8Eagt?=
 =?us-ascii?Q?q7Cjw9bhH4vDDqbqX18KEWhMBrHWCc72g1hmwHeC/Ed+qCdj2o9hV83Z1m3O?=
 =?us-ascii?Q?kiWpaqjVUytfbGAAol5E9o2wsQ8jVAOATwhh7eUhJlRX14KesAGcStyURd0q?=
 =?us-ascii?Q?XAoTxurDSIS2Tt/8vS6B8uMQgeJxdlk0K8N+k41weMWjF4yMbccF3pahlUpp?=
 =?us-ascii?Q?SOM84Kl1qGAH/sAC9KHjGA4od2WaNro5Pdu51HyhLz9qKvWYDxREo34C+zjm?=
 =?us-ascii?Q?/yIBP7DUHOsvjgob7E5E+0upRXGgDKx+1mAV66WrCPrM1skkB6pBrGZES/NN?=
 =?us-ascii?Q?6ebgRAC16tS18TX6gO18HbVGeGiGNDX0b+xJa649N/0AZaaDS9g1SENZ5ZHS?=
 =?us-ascii?Q?Fvi0lVCW5D936bOm6KHp45OcVSELm6i5OTVFNUsQvoqkaNtIa0pr9tsC50zf?=
 =?us-ascii?Q?nbfNgSKzM7lfJFthxuJb32W8EOSUI/hcUq2xO5u9BFxQSTlidBmTcXVj/fI/?=
 =?us-ascii?Q?rMy/QtvfPOFWHRwcXEpjuG4UvNaHEMbfrXrqIDhU80namUQ5MlNtlYJsmhS4?=
 =?us-ascii?Q?Xveo20pHDrczXZS+0Y9jgBNW6bPz/ClYKNeqenbWCwBaBwUBnpBUm4pCOz18?=
 =?us-ascii?Q?wIIlvAgGyJwq8X8Dcoi/53NrMmHhFnVrck4m13CJfOvTv8eMiw/2nETRP5cz?=
 =?us-ascii?Q?mlEeL8Lk1nQPd9W4kU+gFFrA4CEfKJrEoM71fNVIq2WDZezSCcZUkDkPzZSx?=
 =?us-ascii?Q?zAhC4HL0i4iurGXxVRIYzk5Whdk+nljHfDT3De4hmjDuqriJ91aZBftDckxV?=
 =?us-ascii?Q?0jDC7AIBmnL3LwuKreSBmUZEy5jxR6rukxSpGSCPqs/jUh+j19oBgWK5Qx/+?=
 =?us-ascii?Q?ypo4SxuiAIXzqmIc2Bl5KE/m3MdlkWVYK/d9bxQ9jk5mda3Vu3Ik5nyQC/UQ?=
 =?us-ascii?Q?2Ba/R5jhWSAmwRLvcLEbJhqRL0lKpZf9rVYlqMZNv8ce?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89EC79AAEAD5BD43B6C9F0C7553F3A80@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fea4eb83-12b7-4eb1-8aae-08d9ec81379a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 10:36:37.6509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WWxRaNcCeKCPK6n84oAhT2gCNxzzId7UwWLGCufB/cNU76ikCnyr4ehBJzo6Uqu/kDiYnqZZ2j+4icaZKKrQGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3899
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 08:13:45PM -0800, Colin Foster wrote:
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
>  drivers/net/ethernet/mscc/ocelot.c | 79 +++++++++++++++++++++++++-----
>  include/soc/mscc/ocelot.h          |  8 +++
>  2 files changed, 75 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index ab36732e7d3f..fdbd31149dfc 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1738,25 +1738,36 @@ void ocelot_get_strings(struct ocelot *ocelot, in=
t port, u32 sset, u8 *data)
>  EXPORT_SYMBOL(ocelot_get_strings);
> =20
>  /* Caller must hold &ocelot->stats_lock */
> -static void ocelot_update_stats_for_port(struct ocelot *ocelot, int port=
)
> +static int ocelot_update_stats_for_port(struct ocelot *ocelot, int port)
>  {
> -	int j;
> +	unsigned int idx =3D port * ocelot->num_stats;
> +	struct ocelot_stats_region *region;
> +	int err, j;
> =20
>  	/* Configure the port to read the stats from */
>  	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
> =20
> -	for (j =3D 0; j < ocelot->num_stats; j++) {
> -		u32 val;
> -		unsigned int idx =3D port * ocelot->num_stats + j;
> +	list_for_each_entry(region, &ocelot->stats_regions, node) {
> +		err =3D ocelot_bulk_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> +					   region->offset, region->buf,
> +					   region->count);
> +		if (err)
> +			return err;
> =20
> -		val =3D ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> -				      ocelot->stats_layout[j].offset);
> +		for (j =3D 0; j < region->count; j++) {
> +			u64 *stat =3D &ocelot->stats[idx + j];
> +			u64 val =3D region->buf[j];
> =20
> -		if (val < (ocelot->stats[idx] & U32_MAX))
> -			ocelot->stats[idx] +=3D (u64)1 << 32;
> +			if (val < (*stat & U32_MAX))
> +				*stat +=3D (u64)1 << 32;
> +
> +			*stat =3D (*stat & ~(u64)U32_MAX) + val;
> +		}
> =20
> -		ocelot->stats[idx] =3D (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
> +		idx +=3D region->count;
>  	}
> +
> +	return err;
>  }
> =20
>  static void ocelot_check_stats_work(struct work_struct *work)
> @@ -1777,12 +1788,14 @@ static void ocelot_check_stats_work(struct work_s=
truct *work)
> =20
>  void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data=
)
>  {
> -	int i;
> +	int i, err;
> =20
>  	mutex_lock(&ocelot->stats_lock);
> =20
>  	/* check and update now */
> -	ocelot_update_stats_for_port(ocelot, port);
> +	err =3D ocelot_update_stats_for_port(ocelot, port);

ocelot_check_stats_work() should also check for errors.

> +	if (err)
> +		dev_err(ocelot->dev, "Error %d updating ethtool stats\n", err);
> =20
>  	/* Copy all counters */
>  	for (i =3D 0; i < ocelot->num_stats; i++)
> @@ -1801,6 +1814,41 @@ int ocelot_get_sset_count(struct ocelot *ocelot, i=
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
> @@ -2801,6 +2849,13 @@ int ocelot_init(struct ocelot *ocelot)
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
