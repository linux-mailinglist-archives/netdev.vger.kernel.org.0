Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD5A43E38C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhJ1OZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:25:27 -0400
Received: from mail-eopbgr10066.outbound.protection.outlook.com ([40.107.1.66]:53061
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230265AbhJ1OZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:25:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=laoE6O2W5mfI54gNJ9Y1v9pM3wpLCxun0r7EaQqNhvBsXUrF5EhrM6WCkEg1fo/Ep5FBCMpOr2E7EhHvi+2r6+Y9GSbFF2oT6CZI8fIePb//F2S6w47CBHv70zU5WH5UMIlgc7kUDPWCfZ9gCUTKoLXEHBdmYmaJYx09PKlNtley6YexQlymhCFmGxTPSSQ8x0jl7F7EPvAsqlxSyaIF87NpVsjyhJgvVnBegse7WfEbwimFRXDGOgq0Vaimghyu3eIJOh/kNEGvueaJ5VP04r33vBlJhyX2REZl/oCJtcRDcpDaKsmgD5n+941mQqGWmch0c0d3SNR66UgkExdnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39mzozdy59doAnJm+7jzTZcaUxrbLgjdHyXw7EXGAVA=;
 b=oMZhvPXv1WdyXFtL+tItn3PD4OnRFhG+BM3LLZcZyfUhtlipnQr351S9ibiDjWZZ4Ftg3+qtjnSMusugT2C9DCcpccAv0XHYRr5SvAoCaBpLElwULFkyPapTGY9P4NlAZisdmHiLTiEYpoRyq5jvUrf/vBuRJL7Dh0vy6878JEHRfyiw0sictgVF3c1Xx/bh4PzMA7vggjfsocrHvb7vWhUS8oJDTtikTxXXRPIfEpavQTVwvg0BQpFok76wyoFn/axOG+RQpo/Fe8zORYUChQrbslnW0uwsigW4ty+aayoQX2TBi7j2882QjSewJp+IiSFUjm0s3HyxnLsfdcwmWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39mzozdy59doAnJm+7jzTZcaUxrbLgjdHyXw7EXGAVA=;
 b=mV2loxwV7veu/N19dmL2C4Bo0WGZa1COdxgEaKndd7kVkTTd7PPS1+y5vGzRzEs20pblYMH3CArDWUJyXNTAdqxCjgefD4s+oglogQXFsz3Wa8q+vUirm7SmEiWsDNCH0JtqGuBNvWq4m0XsSmb0VYTUxuQhq9GJUynFHblLo28=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5695.eurprd04.prod.outlook.com (2603:10a6:803:e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 14:22:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 14:22:55 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Topic: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Index: AQHXzALaBu1tOZHr/E6Z7NAaubhTaKvoceaAgAACkQCAAAIaAA==
Date:   Thu, 28 Oct 2021 14:22:55 +0000
Message-ID: <20211028142254.mbm7gczhhb4h5g3n@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
 <20211028134932.658167-2-clement.leger@bootlin.com>
 <20211028140611.m7whuwrzqxp2t53f@skbuf> <20211028161522.6b711bb2@xps-bootlin>
In-Reply-To: <20211028161522.6b711bb2@xps-bootlin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b1486f8-192c-4ea1-5c63-08d99a1e6f3d
x-ms-traffictypediagnostic: VI1PR04MB5695:
x-microsoft-antispam-prvs: <VI1PR04MB5695AA36CD04736A2FAAE2F3E0869@VI1PR04MB5695.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sAUb4kdSgIQtM/YzIsxl+tu4QMj0fUAiVC1tnDAwOOxQGzPKaZY6S0SVkwcFQf2NrFKN1iY+yZFDAgUaTcSBv0q0U8ODSmBAwRqpH+vbeTFZCyCcLAP2LkqLcY/gm2bpy1nr2yc99c9ac1O/d2M5lErk86RSnzzO8qNl97n8A/FlaYApbEarhUFaWsMkVb8gZwVp1ZuutsgXXCcU55+oBlW70NKpdFWrUn+waL1CNNck+rkYPSpWxq7CtjjvRUreg22HSctJw/hWZwMEkURz0XoDHrGdpmKYaGSTSiodojNHf44ugr4x+vaD7UIubzHJ/J03uyRcp4W0G9/HGL34XwW+CfNWlC3ELdhlC10/2Vc1TZyRgnN1xqTS68quwXsT2o5X29cALKCFgXDUAbMM7JdowSs3zreaj03Vrksbrg7hZsxAnJ/337pGafLnTyCk3E4at8QA73pGIck+bC7VmJdXIh1Omp9TZBBAdRwPPxsiLaOhrnFBZ0ASDcjSawRQJXMjg/grOkGQE6jSjsDU0WNbV/QdmvvWtbYybS6OoshL0BKAuTTegm2s7R/V7n6E/2fYBpZ+gni49Q+DaCgsCL9TEbYKe7ifn8vIL4p9THKY6K/vjUtbRafih0oKr6edJqpzX5wZoybFv4bfjtHD2LZ7/FfsmOuPZ7OcWc5PAJPIFbuKshzHiTBbSorHT3qSyN2f+UpE6buRxtCA+Xwe3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(33716001)(86362001)(6506007)(6512007)(66476007)(508600001)(8936002)(76116006)(64756008)(66946007)(6916009)(4326008)(71200400001)(186003)(66556008)(26005)(316002)(66446008)(5660300002)(38100700002)(9686003)(7416002)(38070700005)(2906002)(8676002)(122000001)(44832011)(6486002)(54906003)(91956017)(66574015)(83380400001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?MABjGHLz3A+2Hh45d9WwwHFrjxYptsOZthttsjyws0pwrbx2Sy+qzlEInl?=
 =?iso-8859-1?Q?i4EzxwqGOi0zxJsYpdhmgqHHltBixp3GvzdcM4KjwzZK9H2FTNLBBF7Otd?=
 =?iso-8859-1?Q?C5YLMfY2va+VQp9iFC86Iq5ioku6snAZzbrQdY6d/HV35iv+pC6q6TC+U3?=
 =?iso-8859-1?Q?/WmLWkxC0tuRoDTT7N0BobwxvZR06xzgTrXIAJa6K10Qj5zlbVGRuyBkbg?=
 =?iso-8859-1?Q?Czf/Rr0HbU2DCtl85Xbnl329bKviOjuFidCo2SQ5kGoGJHz1Tx1M+AY2+t?=
 =?iso-8859-1?Q?MC/AwWdhlWKiRQIk6cKtz/lMRKpqIxWHKgL97GqITxiL3SoGfSYu2PBWsn?=
 =?iso-8859-1?Q?BvG0zUHD27PahG+uTLjXX3fBObtqK3ZVtVuFKJZ7rFr8iM9vrDwCovcymo?=
 =?iso-8859-1?Q?l25Y1VbzffS4RGV/6qdo4oEnbN0BpSBkma0yQiXk5h2Hc8Ycg0c7OzWvTD?=
 =?iso-8859-1?Q?CeWXWllpfFRZpWYh/Wikw98jdNOO7nxW4/yrLlhepETuJl0HL0N37bR93X?=
 =?iso-8859-1?Q?d1orqfxFxKGCspcDwF+QTOp0QJTdXDzKcdtPPLABVmHfy1BFmjDZe/Gij8?=
 =?iso-8859-1?Q?DS2FK0Ma2ArjsknEZ9Hny/1Pl57kNC9t3tklQbB8u+IaZHSEldSetsHTIt?=
 =?iso-8859-1?Q?VXmFyQwL+5bSM5eX04n76h+pNLAGO5CDPE4pcH5QRZDvEu3peBx9Fd1WZc?=
 =?iso-8859-1?Q?kBR3OgV29PBiQjVSeKkF9lqWznQqm9ENLelQUktbavk/tD0MaLlumbGr38?=
 =?iso-8859-1?Q?Wc1+KKn64J3CA3NgfeLJWx/5yzWiULLiTsCnHIwLmxIMyiTmnKurMRhklm?=
 =?iso-8859-1?Q?M38TRqdyAbxsUkOJj7Eq0OEILTAdtS7hWFSlKDH+vzQ+QF5Mp37ZscQEQ9?=
 =?iso-8859-1?Q?B6TYAlK1J4OnADfgyXekz3jF3sE3D1A1JqxzULnoelt0fQmEzDtongCwhc?=
 =?iso-8859-1?Q?rcVRpc4ZCtkyvNRT49snGJyr9cTQz1tU1Nbrq2Xct+TEtDMoDUhuPJF+Af?=
 =?iso-8859-1?Q?y0p9THvExSFh/E5m2hb/QtjvqrDsHLSdlFEbyqZGcl7MCBtXzprILDF1Zl?=
 =?iso-8859-1?Q?Hgl+M3eHvS8sDj5nQguShyZsQMxqURkAFbqdt8uTsBzlpshhLyljT6jXRu?=
 =?iso-8859-1?Q?IxvaDuKQT0PZZHUo3vQZWblhSg0vH4NuHDILL9K+qqYe+iCcAPnyhp14CU?=
 =?iso-8859-1?Q?4j8XR7dihiy0TEixvZ8+ZJBoUBzUrAHPdh4Kgt1TD6B3QUgBPJ4mCjA4xk?=
 =?iso-8859-1?Q?Wp6I681tGr/7/t6EIiQF/DWhQPIDzGhwSMc1mQ2ABh1NWbKjkC6e5jO2Tw?=
 =?iso-8859-1?Q?alsFrfpefUBc1OKCqxDwXq1lBprYhcDuUhpPDBlH/XFAyHlxFJ+KUZjS2J?=
 =?iso-8859-1?Q?HwJASBc8izNzRBsutgNag3z7c+oJsLRvn0M9e164bFru6+zahdPYYs/yMg?=
 =?iso-8859-1?Q?mSmuMK7xHMn9hVH+t+6VEhHUyXhzeX5lJg+RxGIVagQU593JnAibT0l4y5?=
 =?iso-8859-1?Q?2Y1Vhdyb/XfOYgDZdCparASKxEwG9pHvWRA5Wr0O/uyn3nK41h9HFudIE0?=
 =?iso-8859-1?Q?bwQglv1R2oWhzJqK9j4GAFZO9InL2L1vLI6LHU3m12IWowghebTs4uCuW3?=
 =?iso-8859-1?Q?t+p4Psqkas1HDXUKqlpGtx0vkyG3Pc1UOosCkb3RDH1LuKcRve2giYSk13?=
 =?iso-8859-1?Q?FZTOoXHw9htBCuo2oFu3LsfqVNRxy+K7aKPnBInS?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <3D4EAD2B20F1A249B4C9DF10B117E44A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b1486f8-192c-4ea1-5c63-08d99a1e6f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 14:22:55.4445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/yHIZg7r3VtMMjeeBMKGmcXyDUja7cZYJKL/OsQFSzlnjhzjstwrfyOrmd5V9c46il3paT9skuHwvCiP7OQYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5695
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 04:15:22PM +0200, Cl=E9ment L=E9ger wrote:
> Le Thu, 28 Oct 2021 14:06:12 +0000,
> Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
>=20
> > On Thu, Oct 28, 2021 at 03:49:30PM +0200, Cl=E9ment L=E9ger wrote:
> > > Add support to get mac from device-tree using of_get_mac_address.
> > >=20
> > > Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> > > ---
> > >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c index
> > > d51f799e4e86..c39118e5b3ee 100644 ---
> > > a/drivers/net/ethernet/mscc/ocelot_vsc7514.c +++
> > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c @@ -526,7 +526,10 @@
> > > static int ocelot_chip_init(struct ocelot *ocelot, const struct
> > > ocelot_ops *ops) ocelot_pll5_init(ocelot);
> > > =20
> > > -	eth_random_addr(ocelot->base_mac);
> > > +	ret =3D of_get_mac_address(ocelot->dev->of_node,
> > > ocelot->base_mac); =20
> >=20
> > Why not per port? This is pretty strange, I think.
>=20
> Hi Vladimir,
>=20
> Currently, all ports share the same base mac address (5 first
> bytes). The final mac address per port is computed in ocelot_probe_port
> by adding the port number as the last byte of the mac_address provided.
>=20
> Cl=E9ment

Yes, I know that, but that's not my point.
Every switch port should be pretty much compliant with
ethernet-controller.yaml, if it could inherit that it would be even
better. And since mac-address is an ethernet-controller.yaml property,
it is pretty much non-obvious at all that you put the mac-address
property directly under the switch, and manually add 0, 1, 2, 3 etc to it.
My request was to parse the mac-address property of each port. Like
this:

base_mac =3D random;

for_each_port() {
	err =3D of_get_mac_address(port_dn, &port_mac);
	if (err)
		port_mac =3D base_mac + port;
}

> > > +	if (ret)
> > > +		eth_random_addr(ocelot->base_mac);
> > > +
> > >  	ocelot->base_mac[5] &=3D 0xf0;
> > > =20
> > >  	return 0;
> > > --=20
> > > 2.33.0
> >  =20
>=
