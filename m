Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE433F0B56
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 20:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhHRS6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 14:58:42 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:36430
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229558AbhHRS6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 14:58:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=He6KfXEUmsu8cRFgg+ckenu7Px1pzjRlXv8n8hXBZtoVkePP061jYlfuIkRn8Hx0VJXnhJT/F/XV0hyEcJ+89K6GDanqpH+4WgxqXnyNHK2tWWOTNdzWzrIHJdQUiKoeo7XXbAdz5cNf9Vib+8y83h4Lqp+G5EuLLklHZLg6QLICIuX05APQHxqwPxthGDVsotip7YDHakQdyUPk5ghJB07ozo5aJXZkSf1zzh0Df9GUAPKk1h+B3I0IR3+EMBsBrGUR/WQqG9lyySLEmgajczy8jdksgK2nZKl2ibmpwb8NCUDR5cB9N3reF1Rj4jWcbyUobsxR/HbCB8vVoQcTaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSt9xUnoUUi5uFJkMbBGmOAN5BRnvSQDxuYQtmZ/CgI=;
 b=dhpmfQberGGeHeNZ5QmZQEOCQ0AuKi8pxzNEjo1buBz1ZCVWUueuocUOgtt7wfLkQrImq+6c/WrPz+HE/i9iFNar1gmuhSasjjp1Mf6lJCs25527tS4VNEnam8YILj0HPTt7Y9mLf6mDDHAmkD1+7t/WJ9bab9SELsdOI78i1OZRovsIlNyhHDEuVjLtzYKeiahrBGT/Bxew8aGXhitJ2RXQTEpOOkLWQT4/GHHPvsS46d37rqIIV8c0s4vnPiVlYJK+VLQ3iYFCnxl45QkiIgVRM/Kt7mMiONcJhR8RWy7yb0s0h26bLdHrdx6OgIubuZWgA4K62tT0usy2R1Vccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSt9xUnoUUi5uFJkMbBGmOAN5BRnvSQDxuYQtmZ/CgI=;
 b=YI/ydjFLAVwDdK9ZZZ68LUt+XdAatJKUTc4ajpt9n+zIwp72JKvPzYj6MQov2509aWSKdhl4pQzRCT64YFKPnG7MIrYFn3stSuV3orv1gRSJCVu7rSEscy14ui6cTRBJtPpgO0xl2ZSQ+Y/ikkYIkv4Tx/4SMG6t8XSZGVJsl08=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3197.eurprd04.prod.outlook.com (2603:10a6:802:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 18 Aug
 2021 18:58:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 18:58:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [RFC v2 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [RFC v2 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXk/d+YbIxm9WgDUCf14eDNGcnWKt5nf2A
Date:   Wed, 18 Aug 2021 18:58:00 +0000
Message-ID: <20210818185759.5bedb6cpw7k4bgaf@skbuf>
References: <20210818061922.12625-1-xiaoliang.yang_1@nxp.com>
 <20210818061922.12625-6-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20210818061922.12625-6-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9577bf4-2180-4d89-1b7a-08d9627a19ac
x-ms-traffictypediagnostic: VI1PR04MB3197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3197FDA77B60C703BBDBD6ABE0FF9@VI1PR04MB3197.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9bvEOgf8ehjIq7GrJPw4BVqDqeTx5eiRA5e6ncF+fIW5gqIVlw6I+JJZQMQr0wcJSp88kBCU+9o56XyZr49UBzWuzaVqSbUqJ+y+AgiFibUHs1ni/l1S5QFj+8fH/0kk8JnyTvunww3FCjR/MuP3SRnmy9sgLXQcD3/eqYdUK6sYEQK8q79Ct2AIXdo/sMIQKQJ8bXfI/qhGzrMKTB+zEcvrkYQ++dHFRFjNb6W3It8ZT6zpbXai3A/aiw+1fYrd49X5E4hcsRRdgySq4UwzgCsCm7hhIhSibwb6Q9BOUU6dSH0QfKiSl+acS7XvnN6CGKavd3w7okKDPd33WKksd23IkKk4rRx6DbCP1bB9QPS5j7xon/fuS4thsfRWRz+QkMLWaMZeKK2SwhLNzcDVGUSDNR/SCcDHD9LGuNiGX9W1h049/Bja+vzDdHST2ywANa4rMtgXkeNxr//OrzmPo1elcZAYUNp7dN4KQSw2wFDZVRAxH9ZOak3no0mucuz2Tk9zKb2voRTEoh9jB1vCZ3Q7KUZ5THQS+0gwYIGq915XQvDBH0nXcVXXoJsZTyxLGtVwNNldIoj+wNf4XKd7dJstRZSkvN7z+jM6QwRypLnKGK626aAfNyNtJAVLS0aIvvg/XTET5omi9FwGPDeRwnpfUf3oHw+nzigOhNeEE3/28TNowjm6Nnq7qKmhjMNasQHcatMeOYXWPV0QmTUkcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(76116006)(71200400001)(9686003)(66446008)(316002)(83380400001)(66556008)(186003)(44832011)(6512007)(7416002)(8936002)(66476007)(86362001)(478600001)(33716001)(26005)(6636002)(66946007)(1076003)(6862004)(64756008)(38070700005)(122000001)(38100700002)(4326008)(8676002)(2906002)(6486002)(6506007)(5660300002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DJFYjbmFnau648RB/OJozKmSd9SicWvYUb1s2vc0SUGR5cdiszx8PoP9ahzB?=
 =?us-ascii?Q?7GxhoJOdZaG0zeJGG6QhZL/RsL6JQsynywsw9B4OgUrmDr9zgULC9CvW0MOz?=
 =?us-ascii?Q?n4OryRmig9HILJU4L4Gz+GrQ8vr9t2Ix4G/GbVZYCaWAvcwLMVLqJSft1QRi?=
 =?us-ascii?Q?/VGRW9EhwGfe2b8vBAhbRt/X9U/nGerz7ceW5UmcYVb/EDt36r0vA2U1uR1I?=
 =?us-ascii?Q?FPyMwqsKwRbsuThhFV4QR7mB6JXh7aAtOTTFrauHeMYNWIWvmnUMQ6aWCwxU?=
 =?us-ascii?Q?KsCryS7oO0weSM2KGRivAGJEZ7qT4vMItj7P/3OlaSudnmKlxkpZV4w8XroG?=
 =?us-ascii?Q?z8Si6fmfV+BxllUym+mIkfP7AgwUKPc3QxYpFraOkX+b3Ts6DcBb7ZhqI65J?=
 =?us-ascii?Q?NL670+bbqZRB0WqfQAWTPB4LWSwjT6DBiJB29UeAQ4O+fgO3tMrot2gDpOQP?=
 =?us-ascii?Q?1+thtUDmU9y7bplt/DBhxAYN7Mj8e4m0A6RGohIR9M6l5cnNtgDeOqhv7hvq?=
 =?us-ascii?Q?Kg2K62HvJ1X+LoQJZXmf8qZYOFtoZkt/bhuYPel5+zO4gvLF4zjXjAx0sYFg?=
 =?us-ascii?Q?ZD/aOi54/W0JP4qA4zrkrReHCczy49OO96nUeyhbcCH3Tce2c6NXwrLhVwgY?=
 =?us-ascii?Q?TQ/VxG8aFJ87hsmC20Q/UyyqxMRrdOBUHCC1nBGtdPbs/ZgKO0Yp6KOPenyP?=
 =?us-ascii?Q?QC67ObhHrCZd2dNSFrQm8DOGRtcyecX9Bno9IcwLdalFv1LM+VzTZ+jiwZCv?=
 =?us-ascii?Q?jRg0q7fBOiZHxpGGsoptHQe3rS3mTkoqgHgpkWFqyMCAxoqIqNtMEIoWFTcH?=
 =?us-ascii?Q?COapMH06bMkGfXizPsY2R/dlXMdhikV0KTYu/0gCmN2HzOOcKjSkXWWx3HwS?=
 =?us-ascii?Q?P2j8EbnaRSmUKibQFNDUG82obmAOxW1bN3wEFinypdPs+gLJ7w1PhuOEHV7W?=
 =?us-ascii?Q?OW8GQv2cWzNYhXYa5ZjKqxV8Jf6Z13Tx9LrBPvroREIdmhiij7Ye+BRxjI2h?=
 =?us-ascii?Q?hA/ormHZyK9P75d0VQX/B5Z5jB65QJdWyGLfCJ5qR6lcCsqA2KCOJX7njmVz?=
 =?us-ascii?Q?knNGQSuaRV8lornIltliuwXi91Q/wDQPf2Y2PdeeZeOwtkpgWcQA6m3IxmnO?=
 =?us-ascii?Q?GXAiF9bVGy3SYNftc4sxnSZLLi0Z5n1R+IMFHhyQWa/7MJtZpoqUfpF+9HjJ?=
 =?us-ascii?Q?6iw7bjvUwV96eLWDd5hpH8+hQsqeLS3V3NRChEsCpp8po8AeTsTc6OauSeQu?=
 =?us-ascii?Q?3Su7HSWdQelYH1RG4APFuyZHxIdrr4REBgcOl6nsEqH5QW7KLZURKtYRN5Aw?=
 =?us-ascii?Q?a4y22eC7e227sN9p6g7mzC0I?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A5D8BDBD30E1334BA17FA2CD1891F442@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9577bf4-2180-4d89-1b7a-08d9627a19ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 18:58:00.3858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q5Y/9viWc5JnmtdpA67z9m68Qk6LajLj9VYDgci8B+WZUljkyxhxeKqDVUmvaznIKtnRqIdMk2Q7OuTFREJLGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3197
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:19:19PM +0800, Xiaoliang Yang wrote:
> +struct felix_psfp_list {
> +	struct list_head stream_list;
> +	struct list_head sfi_list;
> +	struct list_head sgi_list;
> +};
> +

Hmm, is there any reason why this data structure is not part of struct ocel=
ot?
Three empty list_head items should not consume that much memory. To
reiterate, now we're trying to minimize the stuff that sits in DSA vs
what is in the ocelot library itself.

Microchip people, please shout if you have other hardware with this TSN
implementation that can be supported by the ocelot driver.

>  /* Platform-specific information */
>  struct felix_info {
>  	const struct resource		*target_io_res;
> @@ -36,6 +42,8 @@ struct felix_info {
>  	 */
>  	bool				quirk_no_xtr_irq;
> =20
> +	struct felix_psfp_list		*psfp;
> +
>  	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
>  	void	(*mdio_bus_free)(struct ocelot *ocelot);
>  	void	(*phylink_validate)(struct ocelot *ocelot, int port,
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/oce=
lot/felix_vsc9959.c
> index f966a253d1c7..4bb3c4023b85 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> +struct felix_stream_filter_counters {
> +	u32 match;
> +	u32 not_pass_gate;
> +	u32 not_pass_sdu;
> +	u32 red;
> +};
> +
> +static struct felix_psfp_list vsc9959_psfp;

You cannot just do that, instantiate a singleton structure in a driver
that can potentially probe on more than one switch in a system. It is
just not proper driver design. Just put the lists

> +static bool vsc9959_stream_table_lookup(struct list_head *stream_list,
> +					struct felix_stream *stream)
> +{
> +	struct felix_stream *tmp;
> +
> +	list_for_each_entry(tmp, stream_list, list)
> +		if (ether_addr_equal(tmp->dmac, stream->dmac) &&
> +		    tmp->vid =3D=3D stream->vid)
> +			return 1;
> +
> +	return 0;

A function that returns bool should return true or false.

> +}
> +
> +static struct felix_stream *
> +vsc9959_stream_table_get(struct list_head *stream_list, unsigned long id=
)
> +{
> +	struct felix_stream *tmp;
> +
> +	list_for_each_entry(tmp, stream_list, list)
> +		if (tmp->id =3D=3D id)
> +			return tmp;
> +
> +	return NULL;
> +}

I mostly don't have a problem with the rest of the patch. When you send
v3 you can just drop the RFC tag.=
