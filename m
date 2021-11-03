Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3C74441AD
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhKCMkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:40:53 -0400
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:19014
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230472AbhKCMkw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 08:40:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCP2inrj7rqFz3jNfrPHBR/5+AM1LNTYJHOAdQ/p7zKW4MLQgh/PxHsUMXoqhlTvroEzD2KuGgn4v87EDK3XNPZ5jJQ2sj1gvJiDF00jHtq0NzaUcgT4rtoDdtDBUghJySOIC+FmH+I5vAbTSVIn46U/R8XgmJO5j76bUkAkj3xhiinreZuc47c2n3FjBBoXK3sVkexqEtYFg5YDyUL87bceJtFiu4hsfRVWM2rN+Z4eFnd9O7N5J87WQdYlvMUchuM1SaOgBLzgHY/1W62YaK4J37iBExEEqLoykUXi+VwVIJiaxhQvi+/V5LUvr274ywN/G9nYGVJfTjXHNeK2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjEmARf6ZJGl/P8b68BCroHV9hFrNLSKHjo9BkVrUl4=;
 b=IPdCinp9rwIbfN3RSK9geSZpYWtpXxXLTNdoezHVEUj67Z44ZfGS5vIOJd+t7FX4h2SlD7bclmFdrjhM+N/wPXIVZbh0uLtxNoubg3yuK59HR9oEiPK7vH9twYEIPk9wS0AEWE5rOmZUfFhvNVInrfQsZjpHj4jyWLAP23/npIFlg+S6e03Kv7gFXld3LGScdInxEptLpE/ekfOces3hVT/09+OpSMlbPD4a5hKvc/F4SUShsY0Ss9kjd+uFO0gx+6mJJlrRubYYIAvD4kdrSdqkiTq8fAsyF3kfp2zJGZk07DCLEuVO0xKGn44hwX+m4LXZlUwgGfubCtVRcBNT7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjEmARf6ZJGl/P8b68BCroHV9hFrNLSKHjo9BkVrUl4=;
 b=pEfLQeGzsjmPc3oRWbMTomr7AUW7cEomvE5otGlsMTImxXN6fPEGU1JRJRbSxHQ9AVc8mXXfOMH0802abxGCzZ+hlGs30i/wJgdb6UOn9po4C8NA9+s9WE76bkbkBuOvgoSR78ABf8M1F7pNaHnoM8ZHYd8HmCLFDij8hJ7N1Is=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4814.eurprd04.prod.outlook.com (2603:10a6:803:53::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Wed, 3 Nov
 2021 12:38:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 12:38:13 +0000
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
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Thread-Topic: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Thread-Index: AQHX0JQMizPbr20xM0ur1htXAvgjtKvxviqA
Date:   Wed, 3 Nov 2021 12:38:12 +0000
Message-ID: <20211103123811.im5ua7kirogoltm7@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-4-clement.leger@bootlin.com>
In-Reply-To: <20211103091943.3878621-4-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65b43e1e-4f81-429e-c94a-08d99ec6cd09
x-ms-traffictypediagnostic: VI1PR04MB4814:
x-microsoft-antispam-prvs: <VI1PR04MB48147ED09CFDDBA1D8BE602FE08C9@VI1PR04MB4814.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:267;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dr7UppVCtlmRmE87PCvOmOilOo4hcFC3FpgvrZE0vHes+xlJ9ZL9ksy2pqqKnWfP5oPMUgTSTBuuR2is21Sd0XPqo9X9vAoOLe8VvtDw/hTBTDVMOJmDPywGps3oqj1BOppkoPgzZa/OSJwZhxnL9IY7AHPLWAbCziEn8CS1lqqOZ0tNxjHLiy7iZrG1NQRSunGOqIhROIyocVvJFJDIS+lNsc5mDtss74KZDpi3PX0LYKd5P+dj6hgVdCtc5QvWJVdb85dv2qfJjE0Z8d8+Jb+r6ybO2vA8gzX8jH0mKkDGqgf9wanRnISbwIkDsDywEegGcheQJyol+aQK3U5xCCfLWmiitviD5VoyFFy9Dj4MPrMzGwIzeeS65JnVuCGuFtudnceK5dpHtVkMryiZ7BwMpHhIcogWFJv3KDPHfxtj8hwyoPk+D3x137ynBll7+JcPqOebGZFlfQBppAUGc21H3pH8Mz8kbeGv4eteU2anyPY3A8/5BApzr5zj9FfJ3b6fGxiNbAiDrnXDK1LXo6Qf8xHz3v+vvpYEyh30X6ubvw94otkCSN8K+LfBnY/UPoxVhZ4oJ+Wa+oFrr4EL+3Wikig4CiRyhtsoCswRs5ttWweiGckscAxfQhF+C5WyOyZVereXokkLOh5cNlSOJh0/hKOg/eFwk/vFAYNCPNeVXnmUtvDG1Z60ZeYrDsZaTmachMihfXFJKNNrZcohEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(91956017)(6486002)(76116006)(7416002)(66946007)(66476007)(66556008)(64756008)(508600001)(66446008)(1076003)(86362001)(6512007)(316002)(5660300002)(83380400001)(9686003)(6506007)(38070700005)(6916009)(38100700002)(122000001)(66574015)(186003)(26005)(4326008)(71200400001)(8936002)(54906003)(33716001)(2906002)(44832011)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gdU3+raXjpsaZljk+cO77xZMyiSbksk+xy4QpXsdyoZadvccGI7m/tV4FU?=
 =?iso-8859-1?Q?9cFndJ2YOimio2jjMNDxHvgcdzIe+N554Mgs4NDMortVtOzd9lrhhHSock?=
 =?iso-8859-1?Q?dkIJgOumbSv/5+y/HY0XbjIQ/E25rlWMGP0/KSbqTi6CsbwXmItSRImkHR?=
 =?iso-8859-1?Q?YwHDwr4spj8yNQbWqRuOIpOZ35PAYDwWhjrlq8vhZR5UrUjhzuIfI3tpim?=
 =?iso-8859-1?Q?eXVKbwoU4dMeEkpWGfZkI2mlzVS8CBUfceLt47cdeAw2Cjm9sBh6h+t2rI?=
 =?iso-8859-1?Q?VLMXh1ujFw2tUTQ34MN1V0TnI1qeae35xdX8nxYGlY/JMRDqQjJ1HmPH6+?=
 =?iso-8859-1?Q?vk+Sonczm3Q2SrsMUoyFWt4MpWoCdaGljcdFHroqaL8OEbHnu3QItXjTE5?=
 =?iso-8859-1?Q?JGDQ7xp92sj88XJsfhXMvjHU8u8M6M31ta0JZZQR4eQCArRHdKBzSXziAz?=
 =?iso-8859-1?Q?Us59vGCkaREQPOh9I5hPfrZ9rK0hWCGGOwBl9qW8K/CKYdKbDtFRqlLY1Y?=
 =?iso-8859-1?Q?OzmnfNfnsrhXuPBfHaAX/fp6GRMng8AkJcwcx0VAg6Ui4KPzw+Ii4ufwKS?=
 =?iso-8859-1?Q?qQRq6diMqwxJ/Rzde71QkfKRIVvTG8Wa4026PhLXXflss+ayJuSAFTgODk?=
 =?iso-8859-1?Q?l7n2VMh+yc9m07Lmm6VE+8MX2fqgswA2Eq95Jen7oG5MICFHDC2mHVSKaL?=
 =?iso-8859-1?Q?DTf1hhQAeoex6xNMqWqh/vYsY54co9/lOcRbawYSmSKz5mE8xq3xyvVGVt?=
 =?iso-8859-1?Q?aBtwnH6iyslHcAJ1gdO+qadVGkFAvXsLFeJgajsDSq3HQcXpsauhh9OcgB?=
 =?iso-8859-1?Q?iGmncAbb1PzeVfrhCIJaN5NfkK5Yo2GKLy3SwjDZxCSbAQea0VR4r5GolJ?=
 =?iso-8859-1?Q?kaAEbXC1XrUwfLuwC6KgdGahNa+Kk7wxNMxCLi+3ag6kghaaUmBE0F0S8l?=
 =?iso-8859-1?Q?zIiRQn0CXBvW/p75kG6jnfN1IzJNMqA68bFzJsYt/T7iq+ubmSFunLAcXH?=
 =?iso-8859-1?Q?0VUDGTvHvBv8IC4o0NM5eoHVPSy1u4Lx/II9bNnbltBN2aP2D2O9QNGG6e?=
 =?iso-8859-1?Q?oaJB9ehNzbNdaj7iaYWdpwEViLOtgvtDKJP4W4pT5VJbp9rAS3ruGfSxH+?=
 =?iso-8859-1?Q?+zqK/JHIWUF1UuUaLRBZPU6AeL+MzTFeHpyEFZQcVOtsZ6ytoRpSBVXkRi?=
 =?iso-8859-1?Q?dmmanA5lfjzOmDpTWSKAhooBvGcNz0AE4zZD1ZctsRe2i9qr2r/eejd/Pq?=
 =?iso-8859-1?Q?fPdBcm4UktnLABjfkxa4YLyrtfry0cy0fdA2JXM+f6U4TfSpCiOZuCqISm?=
 =?iso-8859-1?Q?bZnj9tY1oaeB9Wh1CgRH8SnyE88GmdiHo10/muroTXbLYcQGWgBGpCqfq7?=
 =?iso-8859-1?Q?d6RiFCLYDyp6Ygs10z7YIeMFtFj3tDOjY2JYmWQvuZg7zDTOaqRRRxxJnG?=
 =?iso-8859-1?Q?m4jRXyf6ewPT7C0NJcKxa2nKXQZJ0Juk4ShGIwvzRvkhKtah7lp8p/poyZ?=
 =?iso-8859-1?Q?M8MM/NS7KJNy+aCINvpxigvXsmXYTuCMLbA/9vrNqWBCIxM1KIcACjjQXp?=
 =?iso-8859-1?Q?3DR9TZhXS5lyl5SHS0dxsaZnX1Wb60/h3wWyQ4/I9zEy/UEBepIiAg2bKU?=
 =?iso-8859-1?Q?UHPktLHhXAkhwFPbZBIcOQ+tO4qgzQKZCiaKbsya86GZ+Fp0JSi36odq/w?=
 =?iso-8859-1?Q?tx6c+nqTp5mI1yKF75e3nxJtWSvoox7gbvgfevzt?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A4AC68BDD172AB4790E38B0858A05FF0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b43e1e-4f81-429e-c94a-08d99ec6cd09
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 12:38:12.9959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cj5u0PQlVlle3EkpneAJ4xQvAtdiKBq9UV804b56lGsEnnwu8tFvL5jj3QqUu/sTprbyKDhgKHNXH6Xj5O9pww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4814
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 10:19:40AM +0100, Cl=E9ment L=E9ger wrote:
> IFH preparation can take quite some time on slow processors (up to 5% in
> a iperf3 test for instance). In order to reduce the cost of this
> preparation, pre-compute IFH since most of the parameters are fixed per
> port. Only rew_op and vlan tag will be set when sending if different
> than 0. This allows to remove entirely the calls to packing() with basic
> usage. In the same time, export this function that will be used by FDMA.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---

Honestly, this feels a bit cheap/gimmicky, and not really the
fundamental thing to address. In my testing of a similar idea (see
commits 67c2404922c2 ("net: dsa: felix: create a template for the DSA
tags on xmit") and then 7c4bb540e917 ("net: dsa: tag_ocelot: create
separate tagger for Seville"), the net difference is not that stark,
considering that now you need to access one more memory region which you
did not need before, do a memcpy, and then patch the IFH anyway for the
non-constant stuff.

Certainly, for the calls to ocelot_port_inject_frame() from DSA, I would
prefer not having this pre-computed IFH.

Could you provide some before/after performance numbers and perf counters?

>  drivers/net/ethernet/mscc/ocelot.c | 23 ++++++++++++++++++-----
>  include/soc/mscc/ocelot.h          |  5 +++++
>  2 files changed, 23 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/ms=
cc/ocelot.c
> index e6c18b598d5c..97693772595b 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -1076,20 +1076,29 @@ bool ocelot_can_inject(struct ocelot *ocelot, int=
 grp)
>  }
>  EXPORT_SYMBOL(ocelot_can_inject);
> =20
> +void ocelot_ifh_port_set(void *ifh, struct ocelot_port *port, u32 rew_op=
,
> +			 u32 vlan_tag)
> +{
> +	memcpy(ifh, port->ifh, OCELOT_TAG_LEN);
> +
> +	if (vlan_tag)
> +		ocelot_ifh_set_vlan_tci(ifh, vlan_tag);
> +	if (rew_op)
> +		ocelot_ifh_set_rew_op(ifh, rew_op);
> +}
> +EXPORT_SYMBOL(ocelot_ifh_port_set);
> +
>  void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
>  			      u32 rew_op, struct sk_buff *skb)
>  {
> +	struct ocelot_port *port_s =3D ocelot->ports[port];
>  	u32 ifh[OCELOT_TAG_LEN / 4] =3D {0};
>  	unsigned int i, count, last;
> =20
>  	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
>  			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
> =20
> -	ocelot_ifh_set_bypass(ifh, 1);
> -	ocelot_ifh_set_dest(ifh, BIT_ULL(port));
> -	ocelot_ifh_set_tag_type(ifh, IFH_TAG_TYPE_C);
> -	ocelot_ifh_set_vlan_tci(ifh, skb_vlan_tag_get(skb));
> -	ocelot_ifh_set_rew_op(ifh, rew_op);
> +	ocelot_ifh_port_set(ifh, port_s, rew_op, skb_vlan_tag_get(skb));
> =20
>  	for (i =3D 0; i < OCELOT_TAG_LEN / 4; i++)
>  		ocelot_write_rix(ocelot, ifh[i], QS_INJ_WR, grp);
> @@ -2128,6 +2137,10 @@ void ocelot_init_port(struct ocelot *ocelot, int p=
ort)
> =20
>  	skb_queue_head_init(&ocelot_port->tx_skbs);
> =20
> +	ocelot_ifh_set_bypass(ocelot_port->ifh, 1);
> +	ocelot_ifh_set_dest(ocelot_port->ifh, BIT_ULL(port));
> +	ocelot_ifh_set_tag_type(ocelot_port->ifh, IFH_TAG_TYPE_C);
> +
>  	/* Basic L2 initialization */
> =20
>  	/* Set MAC IFG Gaps
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index fef3a36b0210..b3381c90ff3e 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -6,6 +6,7 @@
>  #define _SOC_MSCC_OCELOT_H
> =20
>  #include <linux/ptp_clock_kernel.h>
> +#include <linux/dsa/ocelot.h>
>  #include <linux/net_tstamp.h>
>  #include <linux/if_vlan.h>
>  #include <linux/regmap.h>
> @@ -623,6 +624,8 @@ struct ocelot_port {
> =20
>  	struct net_device		*bridge;
>  	u8				stp_state;
> +
> +	u8				ifh[OCELOT_TAG_LEN];
>  };
> =20
>  struct ocelot {
> @@ -754,6 +757,8 @@ void __ocelot_target_write_ix(struct ocelot *ocelot, =
enum ocelot_target target,
>  bool ocelot_can_inject(struct ocelot *ocelot, int grp);
>  void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
>  			      u32 rew_op, struct sk_buff *skb);
> +void ocelot_ifh_port_set(void *ifh, struct ocelot_port *port, u32 rew_op=
,
> +			 u32 vlan_tag);
>  int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff=
 **skb);
>  void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);
> =20
> --=20
> 2.33.0
>=
