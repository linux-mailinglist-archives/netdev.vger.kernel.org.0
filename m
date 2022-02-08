Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2854AD9BB
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353454AbiBHNZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355470AbiBHNZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:25:19 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60044.outbound.protection.outlook.com [40.107.6.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43E5C0086B7;
        Tue,  8 Feb 2022 05:18:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTFXpDeqhGBp8/54IlEB6EgGju1APBP8TyCN41lJMvIBfmDG6Q2vRMMjTnThewagtUyE3HVucewL5qnqjQ0VXx7bqA6WpssP/EOEykUQNDMzJQl6yqwuQCfoDWjGq8yDHKMh0HJgdX0zwQWV2AzWlas4qZCP4ndwtLdQMYN8sFDsoz5KAlf/O4ar0fFrV2s7KcJERVApK0VIgiSbHcXRAfRzZMBLOY7sVZmo2s7OIj2+jPiM5lj45pg45s7T6YC8wwiPcn9M3zV8FdOzG3dNFtBurGTx1ym5PdVTMLNveMcJ9/0EmJVmnY/uWmbVyrH9jkU0iY/CSprCEy/7ppwDsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84z0OEyb3VV0tqXocEWfInmSXFPxtRLnGm7fdZA1fgY=;
 b=dnkDk7k9WKRRXf6siTP0mVyOdSDkfGqf/sjvRYdTudEeiGTGSSbeY9zQLluuhHrkKJ8aa0rAHMCm5euK7MhJ3i2H7jZMfh5n9OPsr0ExR832crjgPT+Qgwj9XkmbuLMO7lnY6lzIqWuDaLHOfp4ODEnZA89KS8HZuz5Ms+HMgd+zHhpdzQLFZFOYTWUeuIunwQR9q/Npp1XG2lIdvduPAoXkGhhvZfMyl3qHEYiphO8ryfSHKE1AOOysOLHgvuoumgzskZAYBA1u/3dKAFO+//my6+s7XchOme4n94Zrc99wvkR5b0Vk4hsO+gDTB4NaGPUYr5XZ82A4gLM4Y6JzZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84z0OEyb3VV0tqXocEWfInmSXFPxtRLnGm7fdZA1fgY=;
 b=no5DRHIVXGqai/wh9+6rsJF+6Yg/is2xkrJAvbKX8au1tOeKRMeuK7yBRMfBgZvguHfgsjuajVvpPcLzvwT7GCgxd5y+NG6omBGC4Ma2a0J4DkDjV+pjswtqxvHWBaJqRov9K+GKtnG69t+EfP2JxbQqsZfpDpkuC4jIFrobWv4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR04MB3202.eurprd04.prod.outlook.com (2603:10a6:206:8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 13:18:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 13:18:50 +0000
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
Thread-Index: AQHYHKbq8GXukjoutEaxquFuvaFzqayJo4OA
Date:   Tue, 8 Feb 2022 13:18:50 +0000
Message-ID: <20220208131849.7n5hr5hc3fgcgpnz@skbuf>
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
x-ms-office365-filtering-correlation-id: 7db90fd5-d657-4971-4098-08d9eb058bc9
x-ms-traffictypediagnostic: AM5PR04MB3202:EE_
x-microsoft-antispam-prvs: <AM5PR04MB3202EF67A02417598BF9B0B4E02D9@AM5PR04MB3202.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /XZhsJzajVfeHl8e+7GWvO9Un3FAc/V2aoVQnTJ7ViEdTSwV3XSxxulcxSqelOvWVmTewXYvZPhn22UBnq5DJTtmh58RicCFw9PBQJS3QOJVGn8l8NVFviWvak/Oasnec7n5KcPs+lDlCk7nL5IrGbtnaapGdxCeuuAzdCGQG78FNoscX6/7Z6Hm4vj+01YwGc+o7KrKVyYaePy3R3RLj5uPxdlrOCDrimF8yA682mi0vDg4WUwCtY/jKyI97CtkXJcWsgy7Cs/4K040dpBu8VxqSE0wpHDaHdeCECNYDHlW9jhBM05gCkjC5oWllsqJu4P6wVSnNlLnriecnoscJVwnjxdsAoqX1OY+/icITKj8i823uk8xdo8rmxDzEp3iYEbB+ZCqxD+M9ZyORztKmFXEaK6eZ+BadUhbtDDd2Xif+x2b/NDrzowmYCnYG0WRz/jq+slCSP24lD2a7eLRCDGEK7YImIwJJj6mqQQd9k7pznwln9dqGyQy+8IUhzAjWS1Try95yX/T9YMG+G9GXz/R4gWKdT/pxZQEX151sjKB2y/dQeizxT7pzzNQ2qvGQgZhyVwDbWvGDykerAXyErc/KQX3Ix+BWd6kdI8Ter9mFjbDI+FDuy8SLD4LYdoSWCkn59K8U4gOHUoD+4vGnDUMBe5exn9CM6/BC+xZQxygaIAoKj24ML4rzgEAlga1H5l5iiftopgjyEAZIXEiOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(9686003)(71200400001)(6486002)(83380400001)(5660300002)(186003)(33716001)(44832011)(38070700005)(1076003)(508600001)(6512007)(26005)(6506007)(2906002)(122000001)(86362001)(6916009)(54906003)(66556008)(316002)(66476007)(66446008)(64756008)(66946007)(38100700002)(4326008)(76116006)(8936002)(8676002)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?S4T8NwYxcHr2lFkaaxIPSToVRQzO86dXHaGq354MxxRFNWP5v/NA/ztSwr57?=
 =?us-ascii?Q?l8p91xvjuKFCS8fG8vAbk8u22MkuoKdeuLUrZlD3iU0Bh53hvFO5ciewSB/S?=
 =?us-ascii?Q?Vf4zy34OUe/qrP5RLZo9KW7HtBa75t+SY5v/laFhPdVC0wwtH2uwu2G8+w88?=
 =?us-ascii?Q?zBYdKr8vrckbSmFF3sQEqiHRHeK0B0QtUoPcPSnneTDPUG9QzO9lhLxl6qvs?=
 =?us-ascii?Q?WhrDmIsHxNt/BWyxYwPUdfujbVClnYYQ4vrd1Ta5zFaoJPEEpP3hPVC5nTNR?=
 =?us-ascii?Q?9JfBhzDroiYAyjJajpeDds1C6W0y2/WUaHXPEUtKx8slMTl0sS6q1oW7+Trc?=
 =?us-ascii?Q?9CRPErGvvZtosJXpi7iLcg0jZvgUoxD9WYdJHWzhEeQMWV8dn1M6130We3zC?=
 =?us-ascii?Q?ON29QDKn+zqq1TKus8/dD6VE6QSam69aQBjM5fKdJVpTxUfsAzGN0RbuKGnI?=
 =?us-ascii?Q?VNSR/0aKZ0Pjr322NwY5CD4vOXmt6SVI/0AZrCA/q2j71UlXRci137LNZQFr?=
 =?us-ascii?Q?9VlI685hbGJqmBU83iDmS/nPv15a7xIxbwTwh5IGuRElOLjvU3pezufmDpWj?=
 =?us-ascii?Q?DwnVwPCss5h6su6nBH6YGUwBied9UqeqHvSRyTN6ewL7J9r8F73G+c0eKJR1?=
 =?us-ascii?Q?XaDt45hbTVgvMEWgrVFy/V9OCmtWSxdUVXVLSHdSTXY17thA2MAj/kCSVFrG?=
 =?us-ascii?Q?QipichdXuSJern8dwyHRJQCFpRcD2T58H3TtE1cbMGrgP76WSaOyqwxKvnqu?=
 =?us-ascii?Q?9a0fw3vgJJcdqxL4MCggyrgSBFME1dIZOMrmcb1KZP7fQ73aRHMrT3HMQvFU?=
 =?us-ascii?Q?KPMf8lg7MK46d9FSvtCC/OhXAlAnfNK5fquoNN+2wemKcSweWX6a9ZhOxSLV?=
 =?us-ascii?Q?SzThUGiNHjWKmUeeBV0uq/XB+dDSIQj51nAyZA0qxXG6IIGO2NGW2nMSKPyo?=
 =?us-ascii?Q?YEfPRsp/hhFUr8cvcGVeocP0blMSBtmiVDxrg+PV8TaXzjq4e4gDDo3L9cah?=
 =?us-ascii?Q?iFwP4VJuRCRV4zVTDbdFcGu2hvb1Hcru1pdninnIwOVhkzPfEbtSjEa/RBzm?=
 =?us-ascii?Q?ISn4Sl1GzkEU3SCMd0psfOAtttLax6B02tHt2xQLdz5yHHYDeZWjzdGGDMNm?=
 =?us-ascii?Q?bsy84rm6tWSUS7RtBy465nh2G/xvnqBS0EWLDTmYPxFHCARzy8CgU6NIU5Qw?=
 =?us-ascii?Q?GWg+H+atXi7B28P51qErH53HCrTY3CY2I44uOmLhkdG8FXAmDovcvTxaLwnj?=
 =?us-ascii?Q?Bb9YKqkuboyFNyUr41UBc0oWnBDsJlTndn0rAd5keuj+Riux2/aIWpPRW/T2?=
 =?us-ascii?Q?uLeLLI91mLIqE6vewxvVsYKssizoHGMNqqMiERaq2A/iBHYZBHn3z95IIaih?=
 =?us-ascii?Q?gsdZP6XeFdSkt0z7k6QHlrdRUcLZtZedmQ+od4BegN74TJYZUucq4zAGNhnK?=
 =?us-ascii?Q?VwkfwbYzr7Zq0m7s5DWq0tcSADdcfmPa1VOibvOZ/WJnOWinSOXGgfVSwr9j?=
 =?us-ascii?Q?NZJmoa/h3zqOmgXvoNwhYlKIVOS6NuXxYbNXFnXpELRYrbfWlyIiReDfoxI7?=
 =?us-ascii?Q?qN2sFGP4cSjkIIx4DidtPx11dGEx2kXiFzbe3Nu4W7oXANtqKun9R2COIlFk?=
 =?us-ascii?Q?/7TW/Rzdxe3JAHWPo9N2r83YkzPkT11tPqTRDRZc070O?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CED7D1BA4F9F4E4A822F8A0EB41821BA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7db90fd5-d657-4971-4098-08d9eb058bc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 13:18:50.1597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E6RGqlyzJR2HVIQf3Nf5fekzx4MlsKfmfNdGOTcjde7cUIKYjHzoYV3aUy/TjWrWSHWmtOL/jSTlrX4dNnGUOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3202
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

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Just one minor comment below, but all in all it's fine as is, too.

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
> +	WARN_ONCE(err, "Error %d updating ethtool stats\n", err);

I think a dev_err(ocelot->dev, ...) would be more appropriate here.
WARN_ON() should be used for truly critical errors (things that should
never happen unless bugs are present). When the assertion holds true, a
WARN_ON() will print a stack trace, and when "panic_on_warn" is enabled,
a WARN() is effectively a BUG() and crashes the kernel.

include/asm-generic/bug.h says:

/*
 * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
 * significant kernel issues that need prompt attention if they should ever
 * appear at runtime.
 *
 * Do not use these macros when checking for invalid external inputs
 * (e.g. invalid system call arguments, or invalid data coming from
 * network/devices), and on transient conditions like ENOMEM or EAGAIN.
 * These macros should be used for recoverable kernel issues only.
 * For invalid external inputs, transient conditions, etc use
 * pr_err[_once/_ratelimited]() followed by dump_stack(), if necessary.
 * Do not include "BUG"/"WARNING" in format strings manually to make these
 * conditions distinguishable from kernel issues.
 *
 * Use the versions with printk format strings to provide better diagnostic=
s.
 */

> =20
>  	/* Copy all counters */
>  	for (i =3D 0; i < ocelot->num_stats; i++)
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
