Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091BA4B0AF2
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbiBJKev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:34:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239746AbiBJKet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:34:49 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30077.outbound.protection.outlook.com [40.107.3.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02249FF1;
        Thu, 10 Feb 2022 02:34:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIzUontJTpyrDcEP/FW+HGwFcqejOJV+mh8DBI4PCZCEduW07GeFtKuFwhy5Zr6KTtcZHTy+spZctg6tKcs+/1clQyhFftx870Cq0l+6T5hYNvuSWMAsXMgxI+UQQo/7oImIKpyLZ00zah9B1qbz0WNZ8kGwJI8geUVehOj7jxGyhpy7jbikCa3ObooNohh9jRUYfJIOUqU3iOvu+grhqWEgD5WZ9s9vBq0mgzldziQuWqsLA2eYu4E4OXYrWJ+5Mn5/gZQYeV5Qm45j9PYhTC3QWJGd9mXcpcvK4X/pxj9Bc70vjaIccDLUbW0hUs1RKfgVkggm9NNWM+qhzpG9vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTF4O52L6+K1nvAJg6kUnZz7djG5j1e9FJus8l65UUA=;
 b=JJQUqXEFKk6v+5yMdrbabKIRRxVupmx9VIvp80Ia+am+sSWukxk6WhFyb+egw4Yto7WcmQ63iUzKJw942bQ5o8CBxMrTSmkSnZjAZcu0+b8eTDz5JaSNFjxXE06vL/yzkYIqiuomcJyg/ovbblZ2IY64OO7gDnKbbbV4q4o6biXLrf9YdpfXdiXX7LK9uNnTr24hLzjs3yfbN9573bSgUyfkE6maGYO5ZZZ5I+US/xQu7PYrL9YnGpM2jSMS2uwQj5s6doSsWMPSUIX53AChCYolMxOSycZaj5W7o7QL9SE4CVojI0gNdItrtMaEijbpP8fx/FSaYKQgusNd3sAOSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTF4O52L6+K1nvAJg6kUnZz7djG5j1e9FJus8l65UUA=;
 b=CSWaxz8IHzROSfyaHA7U3bCHbIm5YUTk0FzHJZ/hDu8gx5SSkBfmmoo15kxhTBrxN/nEhpCQQTNzpxlNAyc+iQPCP+u3llCPzTS0W1YPw5CbWmsr/sNR8medygzyFrQiSRfR3kcIIhD7bQ7BAvHhdMBmq81V/sPPbvRdBadJwb0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3899.eurprd04.prod.outlook.com (2603:10a6:8:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 10:34:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 10:34:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v6 net-next 2/5] net: mscc: ocelot: remove unnecessary
 stat reading from ethtool
Thread-Topic: [PATCH v6 net-next 2/5] net: mscc: ocelot: remove unnecessary
 stat reading from ethtool
Thread-Index: AQHYHjTeSRre4+TdMUarRWdg03eF1ayMlzsA
Date:   Thu, 10 Feb 2022 10:34:47 +0000
Message-ID: <20220210103446.3rdnulyk5p7tzgn6@skbuf>
References: <20220210041345.321216-1-colin.foster@in-advantage.com>
 <20220210041345.321216-3-colin.foster@in-advantage.com>
In-Reply-To: <20220210041345.321216-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8d7b709-9b7d-4c06-a29f-08d9ec80f5d6
x-ms-traffictypediagnostic: DB3PR0402MB3899:EE_
x-microsoft-antispam-prvs: <DB3PR0402MB38997037FDBAB26A592B9DDFE02F9@DB3PR0402MB3899.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vPIJllB+gJHSLiDuLV1gyFKrMdxNo2YTTTCdPA8HkW5NKxK/xkOJqETajAZcuQnUwN/Yl1ypg63vuucUuGPW4WjqbqISXoaD2NrL7SaHhErvFkFF5hSvgSp+zGHMmcXyzQYvA7VnSfIeehY3/nkmsU67jVqzdvcjsJK44QzeiqTA7jGUT84HvjmX/48CsiqT29nMNvRkxgdZpdXa4aJS3X+XoTw2648s+EU6vzWBEOAKNvXM2IHqBNZa85PmbryFYB8c6jmqrlvDw3pJYf3u7pJ8yvi7xRyP8C37KC81ySk7mdWBBFAN1umrR3SfIKVW438XhbUwJIiatUNeQmyIGAmMoyGOg1yPZJTxAC2TSVfhy5Kprcoi2Q2JHlH2aYgemUnJN8SeuGBw9bmxeLiFkPiLvkBJYJdW7lLvTdlT1obe0Z+j9+Dlfo0szvqOYFP9kMsFKYNKenPDum8vPJ+ZKFcNfXdIHk3Mf+8NZm70lC+r7WzJxMmF9f9pmAZs8W3aGTK0mGq7kCeacytTW7U4I05/+lPig2EKRI54EPkgmVkB8Po8Zn0UjFS8z2hi5CTq7R0fZRKZ1Z8KMuD89eDoWVtaXlcx6Yy27S0vTXt+Pw8EMjL8iYJEm0yTwlVk8NUxn6hBqoRqgW240DfULNicSRzlxYnAanDNM0H4T1UogOstry9ow1XYnugKVh9hn5SvPDe7Ir4cfeZJa/Q3YAbSCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(33716001)(8936002)(38070700005)(316002)(54906003)(66476007)(8676002)(4326008)(38100700002)(76116006)(66946007)(1076003)(122000001)(91956017)(6916009)(66556008)(66446008)(64756008)(2906002)(26005)(5660300002)(86362001)(44832011)(6486002)(9686003)(6512007)(186003)(6506007)(508600001)(83380400001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?C8lpwtAFhG4DYRdl4OfZvdpBsfJFFTLHrF5dWIHbOpXwuyxKWg4TX/4xm0O/?=
 =?us-ascii?Q?5F6U6A3l2dp0AZvZhKY8ZuoU7qUI1OFllqYIlb6cuNlZ48nUD62X7vm4Wqe+?=
 =?us-ascii?Q?blaYFDIj6l0JthP67nL9S7q6X9P6noKRZqnSAJeNr99Dv5cMU57KC+jSQVrb?=
 =?us-ascii?Q?SGIwOhtVLYEHTDgMmy5820M/7xlThm1S3/dmsAnQBlKh5ZAJALt7hM2vSNXX?=
 =?us-ascii?Q?ciE84m2S2fCh8YCaNp19vqnhmBoWSgogdNRnlWP3OS9XP5g30Q4qTeacDvyi?=
 =?us-ascii?Q?czq8RxwFblTm7b9UrN+Pri+X78mwzfbHhBA/6i6Xnhf/rVt7kWKGkxL4J9Fd?=
 =?us-ascii?Q?+B1Gi93z18pFwRtRjvgQiGmPmj9S2SwDgUlsLtVz0Jz3FXR4o0lLHmz+myoT?=
 =?us-ascii?Q?plqxUoJ/NeBSPUpwc42d9V2z1/GbEVVM82Vh/g8kKwfPbpjA/eDglEG+eFit?=
 =?us-ascii?Q?l0LjAI4nR9AOvHQFaahk/r2qTqYn0z0z6B5AtHaZSNZpz+vgnEYbW4K6W6br?=
 =?us-ascii?Q?gSDRgtL0SJ7EZrjc/+CC/loLJG0IGKbX/fN7r9Fdarb0CEXRLKTWXg+P7XsW?=
 =?us-ascii?Q?7NZPwBxkAQ0dNqCc11mcUc0sce7u5p93Kvn98V40VxJp7vTJCuKRdrtqxLGL?=
 =?us-ascii?Q?5cbVr9U3xTHiu7DXrML7IXV6cK+yYA6TetFf1Q9uGGgxqmoddHmDcrNup0tb?=
 =?us-ascii?Q?+J0iDRcGnfULDf6sdP+TvVK1hYYBxw026Wx9dhjI1n8ThwbvVqJ+0t9yjg+P?=
 =?us-ascii?Q?r+Ge+F0koDrMnzw5uxg8q4A25XkgF82YkIz0sa2VX7T3kySSs4TisQPp7o7k?=
 =?us-ascii?Q?Q3475K0hjM0mhcWe1PUHBuuEkLGTTk3Jnd8uI38HFXTZGqnyVZ/QOPuNeNji?=
 =?us-ascii?Q?eVlkUrZwnvmPszcw8CFeaIETeASoLzVt8pH3fHoxbg8lT8ahE/XaJv6ITCH2?=
 =?us-ascii?Q?1yXChUvRD2XRbtzT0oP0WCl7IlZ9bCCrFzyeiZMqOHbOmb1qlq2NPDf3rksI?=
 =?us-ascii?Q?lCsO3Kl84B2/niNoyX5+1NGFiD3YBP1MwzjkN2Fg8UUCdGQpyAJpEQV4QGsV?=
 =?us-ascii?Q?ghiUAMwLfgcweH+O2ZqdRdNa1gb9ZG+jRoct2CvQX8D+GDxUQNGoNaxkaayA?=
 =?us-ascii?Q?YxrO531Rzr4DApzeVlNCTiyJWD86NekR1U9Yg1xOvQg+QwRTKZB5NFkwr6lB?=
 =?us-ascii?Q?SgRmwNbRhoP77kFojOBhu6K5cMnUtAdho5OH1ymE1JvcgG3Yo+H87v1eKgrH?=
 =?us-ascii?Q?sPi4XHPqyTttOdwM9uYCGT1ochiEkOFssHMYebOmXClLO3bobYK8V+ZDhMtm?=
 =?us-ascii?Q?aKZRtCxPHuUUKw72dEL90qNuCU+Z6D3aHHWQSExif6g04Btq2/enO5Gr+sfM?=
 =?us-ascii?Q?JISwYgWpGc4xIeMsy2y26knyEEAHv9DCEtcpzjjlcSoiuIMsFNr1s57exuWM?=
 =?us-ascii?Q?ZjmTyiTLHSZrvLS7tTFrT9hOse1ZXsohM/aNVz2tpDashibd4NYC205dkDtU?=
 =?us-ascii?Q?93/P97Jk+EMh3WgEoLR8EBFgNJuqDXh4YYMIRrIEW08N94TCFG9EZ2BoPaI2?=
 =?us-ascii?Q?fhuKVl0e5jAFf921bnMWQyrEgeoT8Rw93m3HIBFJq0zqUCsOWbD8h0afwJAb?=
 =?us-ascii?Q?t+SUldOSCV3wgg4doJG7dah3qGjYBv/BeV9DxN4Ty72w?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <95D952DA4770CB4EB2594E26C2AB5817@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d7b709-9b7d-4c06-a29f-08d9ec80f5d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 10:34:47.2839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cX84PY6PdKC3pyTOCuZqDUer2JD01fsdobxXyy6p6qZqwn54gI2ztaNTlc+ftKB0Y5DLhfp/YaAs3IzaCAdICg==
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

On Wed, Feb 09, 2022 at 08:13:42PM -0800, Colin Foster wrote:
> The ocelot_update_stats function only needs to read from one port, yet it
> was updating the stats for all ports. Update to only read the stats that
> are necessary.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/ethernet/mscc/ocelot.c | 33 +++++++++++++++---------------
>  1 file changed, 16 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index 6933dff1dd37..ab36732e7d3f 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1738,27 +1738,24 @@ void ocelot_get_strings(struct ocelot *ocelot, in=
t port, u32 sset, u8 *data)
>  EXPORT_SYMBOL(ocelot_get_strings);
> =20
>  /* Caller must hold &ocelot->stats_lock */
> -static void ocelot_update_stats(struct ocelot *ocelot)
> +static void ocelot_update_stats_for_port(struct ocelot *ocelot, int port=
)

If you need to resend, I think a name more consistent with the rest of
the driver would be "ocelot_port_update_stats".

>  {
> -	int i, j;
> +	int j;
> =20
> -	for (i =3D 0; i < ocelot->num_phys_ports; i++) {
> -		/* Configure the port to read the stats from */
> -		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
> +	/* Configure the port to read the stats from */
> +	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port), SYS_STAT_CFG);
> =20
> -		for (j =3D 0; j < ocelot->num_stats; j++) {
> -			u32 val;
> -			unsigned int idx =3D i * ocelot->num_stats + j;
> +	for (j =3D 0; j < ocelot->num_stats; j++) {
> +		u32 val;
> +		unsigned int idx =3D port * ocelot->num_stats + j;
> =20
> -			val =3D ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> -					      ocelot->stats_layout[j].offset);
> +		val =3D ocelot_read_rix(ocelot, SYS_COUNT_RX_OCTETS,
> +				      ocelot->stats_layout[j].offset);
> =20
> -			if (val < (ocelot->stats[idx] & U32_MAX))
> -				ocelot->stats[idx] +=3D (u64)1 << 32;
> +		if (val < (ocelot->stats[idx] & U32_MAX))
> +			ocelot->stats[idx] +=3D (u64)1 << 32;
> =20
> -			ocelot->stats[idx] =3D (ocelot->stats[idx] &
> -					      ~(u64)U32_MAX) + val;
> -		}
> +		ocelot->stats[idx] =3D (ocelot->stats[idx] & ~(u64)U32_MAX) + val;
>  	}
>  }
> =20
> @@ -1767,9 +1764,11 @@ static void ocelot_check_stats_work(struct work_st=
ruct *work)
>  	struct delayed_work *del_work =3D to_delayed_work(work);
>  	struct ocelot *ocelot =3D container_of(del_work, struct ocelot,
>  					     stats_work);
> +	int i;
> =20
>  	mutex_lock(&ocelot->stats_lock);
> -	ocelot_update_stats(ocelot);
> +	for (i =3D 0; i < ocelot->num_phys_ports; i++)
> +		ocelot_update_stats_for_port(ocelot, i);
>  	mutex_unlock(&ocelot->stats_lock);
> =20
>  	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
> @@ -1783,7 +1782,7 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot=
, int port, u64 *data)
>  	mutex_lock(&ocelot->stats_lock);
> =20
>  	/* check and update now */
> -	ocelot_update_stats(ocelot);
> +	ocelot_update_stats_for_port(ocelot, port);
> =20
>  	/* Copy all counters */
>  	for (i =3D 0; i < ocelot->num_stats; i++)
> --=20
> 2.25.1
>=
