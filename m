Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E48597531
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbiHQRme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237189AbiHQRmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:42:32 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2087.outbound.protection.outlook.com [40.107.22.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3C5A1D60
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:42:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UirMdyH7OYq2+0KV2EZKz3WLb7pbJbYGSvRMZfIP7wz8/tGrjc6RRGoKwG28Y6vB4RExNkWQCnM3thPoYs5JMW2wBxAt0o33fGKFBv9f+wnSW+IFKYY2JOcro89XAK9SDqTkm82T0HkbmgDKhUPxrFJFy8geVSDpKPzKK8wiu1pF3zpjHhHIO9yj36w7FL4ItRI1py+l9+mVIemhuApE26qF1z5vSTGWTjMnMHCltmtlTkps59YxVw9FeLVpWd67+0oaovV4A5biZvjygeZa1DEDb95SXP4nmnJ76k3ziKZ0gXc5nK/5NKFjepGojNNgv6svMgIG2AYcQypAIx+iFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/4btbqLlTN6vrIkuvcjJ7fW44orccG5ZLTyTaofliY=;
 b=fpCDFYDg6ZzmtQaOono1mfLDQAIwBkjdKgLAscL40FTB+ASfmQjJL/Ibi+46mCzZf9sv620AhtSkUrcbjgzKQ4da0HeD6DS8PpWdQ623UsvpDkY1tzC4EJvjL7Enzi9OjNgA6YanMHpwNnZIDGQdE/bU/Wt+/II/zhkhsEd8Fq637QZM46IPuCQjSoH+iWD7Ypo1Q82DiiBOZ1sKuD4mUs12MDTZP+p18+V/9/TMA1cIlDY8P2RBDwPgWO2trJ2XvyBdZAXM+/LxQZPrLfK81356u0dq5ZoW/NwC/wWm+LUuokZIEUF9UFxfFTZWFBrJSYYjDLZlXABXT7EwCF0EfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/4btbqLlTN6vrIkuvcjJ7fW44orccG5ZLTyTaofliY=;
 b=S5/G8zhWn19XYIwBcRFnMoguNLJmmZUy3ab4DaR7QuqnEiAx4RaDC0gIviK+Q/azu8AspkzDeQ/LTSOx9ZRjfS6qemAzz2l9llcjC4P4jC1AAx9SESXzV39wj7ToBYsJPBpY2XioF1+Wefu4xYk3ntbET8KXdU3eMHNFW74plY0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR0401MB2680.eurprd04.prod.outlook.com (2603:10a6:4:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 17:42:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 17:42:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 6/8] net: mscc: ocelot: make struct ocelot_stat_layout
 array indexable
Thread-Topic: [PATCH net 6/8] net: mscc: ocelot: make struct
 ocelot_stat_layout array indexable
Thread-Index: AQHYsXet4txs5KEUy0mU0hPxnOpCE62yp00AgABIogCAACEwgIAAI/GAgAApbgA=
Date:   Wed, 17 Aug 2022 17:42:27 +0000
Message-ID: <20220817174226.ih5aikph6qyc2xtz@skbuf>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com> <YvyO1kjPKPQM0Zw8@euler>
 <20220817110644.bhvzl7fslq2l6g23@skbuf>
 <20220817130531.5zludhgmobkdjc32@skbuf> <Yv0FwVuroXgUsWNo@colin-ia-desktop>
In-Reply-To: <Yv0FwVuroXgUsWNo@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f615d35-af43-44ef-9c77-08da8077da0f
x-ms-traffictypediagnostic: DB6PR0401MB2680:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FEPx8L7U6GOTg2+h8sDn8Z7uwbFPXr0RSzgh/85Z6pnHc8i14NPK8jXMpJBpkb8hJWsvHVWM73N7T68cRxTm8IqmZw0rtS3PUN3g81Ni+o3At8Co164ZxSv5cs31yB4aX6OEC5r8YIlQZ2IxOlG/fgaqO/t89E6wVzN3AOi6dwfIfIC9hMCYBeucVe2Esz5IYta+X5vU0WMHPB4L40e1eiQjqzWpsA689DytPEXoRPaxhEnfP8IARAHHFhomf9FOtYFSbaAO4vnGEVJsCLPTTU+zNc/iGmZa57iYPRnk6Yoset4rraj7wpjjtDC68m8qe5UKT8nWomYLg3iuH2Ae7BLTuFzmCn6vn0si+sl1MhusMRxB9wW4gCUiGGtpuDqtnYz0lJFkLd6fnyRiTzrRpb+OPemq77BY2m7XwZiwuURYJIS/IeRzRJhKSnPSpVYiCRKcvyweHiYPY6VSUu4nNnyVfevfX6M0LLnW1i07yiJh/E3uZ8oC6rv0LkxVQ4UP9ypeLDP7UFXIaxr+lRbPbw/k2Gi+ZdzuTsgB81D0WN68jEd8ST7REZFWX07Ag2F63q+MZ5HnOH0iGst4sEWPSU8S3uNrDWXW55AaGNAu89irINQktmUq8UOwX2NPmO3LPs7l2g2cS8spseBDaJ/uducAy88JrxSexHTX3laOlSjx1FoaB/8SFwudPNswAYJrNOv6qsVp5+B0PUmdit6PFqMA9QRmH1dOwrs0kqvHRP2Gq1sBXHO09OEniSoSkeyJl2W/iBH4fDzPjl3kvvK/Z+DNH4X1FQKo1F75npj+RUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(478600001)(6506007)(38070700005)(186003)(86362001)(6512007)(26005)(1076003)(9686003)(6486002)(71200400001)(83380400001)(41300700001)(66446008)(54906003)(33716001)(5660300002)(66476007)(316002)(8676002)(76116006)(66556008)(64756008)(6916009)(4326008)(66946007)(38100700002)(122000001)(8936002)(7416002)(44832011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E/7m9EGL5afv9iRq+XxyFzQ60yIIFuJSmrkLAEiO6scyRvsF3+pciJgPhsOi?=
 =?us-ascii?Q?W7Noul/h5QBZVlbNrkiog12KswW8AGu7inLgyJK5LEN4hRby/HqTZ8suhtWT?=
 =?us-ascii?Q?TR7fnID39JtMdM2UfqkHDwtn8RvqdzOi7u1D+KXMSCXf3SUU08CKeTq4Utpy?=
 =?us-ascii?Q?0nMYrRj5P9HYHDN/V4qC0K2gr1+xs0sF4TNzgXgTUGFz20vw46ei43doIzLl?=
 =?us-ascii?Q?wWWf84JDUzrirAXUMdWZRI+kolVSOc+gR1tNNelxntX8tJKCNxJp++gkEPb0?=
 =?us-ascii?Q?UOqWgQkloPOXLoLOUyiIUjPMi1wJ6C/5VoIB1ykgRba/MGxBt0hhSTUKalnB?=
 =?us-ascii?Q?iMH/woZhfbn8uE7/McvsYUWCrha96yzhLotrEzBAXZZzswdIbMR5YzGybCtV?=
 =?us-ascii?Q?VBcq2UXUWSXQargUchDrhmsk2H28bTrJ1EQy/9Q6Uho+pq/vOJVtw6nQyMUC?=
 =?us-ascii?Q?DQVWTOPwnyXcsZ3v6yVwkMG1Q+kSAfw9tbFYQe9LpTku66n1EfobTJIs/q7s?=
 =?us-ascii?Q?8hY2g0+QGxm4zeGKdFapHScW17u17DJd2W6dv1ll1HwNghxqhTWFEd8JOxzc?=
 =?us-ascii?Q?P57xCjlV0rpAbfghKk3WGwQA9jXkOJN2JkYp7FYU/b0Zcs41OJyeWsAqXLWy?=
 =?us-ascii?Q?DTGrvvcqxd7Gn6eo1urY5ZUWgbViROCwJBhCiZKJgQiFONftxLtHUOnNJXrm?=
 =?us-ascii?Q?+Edg2ARhbc9MA7SOxAHcNshNu+Zc8agm1mXKnN1goiw5OeokkKnl/AzzXhhy?=
 =?us-ascii?Q?0egTw3n+BKNXppjB/6ZubQib/OWNvsrZ7huFHoMn0nt9aeMQuVoBTylaHMSw?=
 =?us-ascii?Q?5irjW9yD3nLDmYbKhXYErpmHZFdIbI1uaBOmFIzhYUoVa3iB6mv7SHuzVb/f?=
 =?us-ascii?Q?EfhypjiFg0ySc1SQReGx2UwU5pKOfOk7acfyQeEPN2svWkxTbG6F5cXKAHbI?=
 =?us-ascii?Q?Qga3tFR/rovR7KN+UyUGUmQUWKpdVo08NML99xsnKSjWr7jUCCfRBy0ljY0I?=
 =?us-ascii?Q?9G609r6YeTiiR6WnWaR2EBcdVBwzfkLA3Xs9wXxubP54hOotLL7ADKRqdLtn?=
 =?us-ascii?Q?YzNJcnRFXILxRN7MQBCIYsSRlOuaApWzMgnyAm2ZWbJ7LGWyNRFldDtQPFeH?=
 =?us-ascii?Q?cyk8e2VhqXbHJ2XiUK3SajkIM1Z0wI2sXBgzSQhMeulj+XegfUf7UbIMIPKH?=
 =?us-ascii?Q?LyNS8biJuN1TpGr9jKmSm/bCjP0RuaQohTLBHpowaoiODed2nMgkWSsdQr7+?=
 =?us-ascii?Q?C+/Uw89/O/fHrAcuKtJyr9cmBZl3unR8H6tnsdJzPHFB/6okaZQMRq9qBuMr?=
 =?us-ascii?Q?oNAsGN3G0uc2KL50FVKSiRobpO/BWTPAOwwuph5kEOb63tABd8C510V8EoUL?=
 =?us-ascii?Q?EK1raAUqpVyyE+qtq2G/1Bp/qFtPhQUGOqZw/9CUYndlXEEiVkOKhr8ioY5U?=
 =?us-ascii?Q?GI6l5SBYn+jql+ajtihnSoK9aSUJCIPgr01Qx9QGfghWKWUTVuUaVS/N3Y7P?=
 =?us-ascii?Q?v6/BmqltOzCH51ANF/SCNuFqu8cAKqB6x/mDN+rQrtytvcjCukBX8CJoJAh4?=
 =?us-ascii?Q?9N2CvbYFTgukbyb9iXSwg38pYrux0pTeD3QF2GBSPS4XW7QEMvX9vbfdle5c?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <611336985CF647489BA9BB905EB9D97E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f615d35-af43-44ef-9c77-08da8077da0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 17:42:27.3953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Mtb3RC9e/pJSXgfd1uJ8wT3L1FbKM7mH/T5kaHX+Ho588Z572c+svkBvxIPd8OsBOyharc2Lj9xBBCiHfx59A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2680
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 08:14:09AM -0700, Colin Foster wrote:
> On Wed, Aug 17, 2022 at 01:05:32PM +0000, Vladimir Oltean wrote:
> > On Wed, Aug 17, 2022 at 02:06:44PM +0300, Vladimir Oltean wrote:
> > > I think in practice this means that ocelot_prepare_stats_regions() wo=
uld
> > > need to be modified to first sort the ocelot_stat_layout array by "re=
g"
> > > value (to keep bulking efficient), and then, I think I'd have to keep=
 to
> > > introduce another array of u32 *ocelot->stat_indices (to keep specifi=
c
> > > indexing possible). Then I'd have to go through one extra layer of
> > > indirection; RX_OCTETS would be available at
> > >=20
> > > ocelot->stats[port * OCELOT_NUM_STATS + ocelot->stat_indices[OCELOT_S=
TAT_RX_OCTETS]].
> > >=20
> > > (I can wrap this behind a helper, of course)
> > >=20
> > > This is a bit complicated, but I'm not aware of something simpler tha=
t
> > > would do what you want and what I want. What are your thoughts?
> >=20
> > Or simpler, we can keep enum ocelot_stat sorted in ascending order of
> > the associated SYS_COUNT_* register addresses. That should be very much
> > possible, we just need to add a comment to watch out for that. Between
> > switch revisions, the counter relative ordering won't differ. It's just
> > that RX and TX counters have a larger space between each other.
>=20
> That's what I thought was done... enum order =3D=3D register order. But
> that's a subtle, currently undocumented "feature" of my implementation
> of the bulk reads. Also, it now relies on the fact that register order
> is the same between hardware products - that's the new requirement that
> I'm addressing.
>=20
> I agree it would be nice to not require specific ordering, either in the
> display order of `ethtool -S` or the definition order of enum
> ocelot_stat. That's telling me that at some point someone (likely me?)
> should probably write a sorting routine to guarantee optimized reads,
> regardless of how they're defined or if there are common / unique
> register sets.
>=20
> The good thing about the current implementation is that the worst case
> scenario is it will just fall back to the original behavior. That was
> intentional.

How about we add this extra check?

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/etherne=
t/mscc/ocelot_stats.c
index d39908c1c6c9..85259de86ec2 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -385,7 +385,7 @@ EXPORT_SYMBOL(ocelot_port_get_stats64);
 static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 {
 	struct ocelot_stats_region *region =3D NULL;
-	unsigned int last;
+	unsigned int last =3D 0;
 	int i;
=20
 	INIT_LIST_HEAD(&ocelot->stats_regions);
@@ -402,6 +402,12 @@ static int ocelot_prepare_stats_regions(struct ocelot =
*ocelot)
 			if (!region)
 				return -ENOMEM;
=20
+			/* enum ocelot_stat must be kept sorted in the same
+			 * order as ocelot->stats_layout[i].reg in order to
+			 * have efficient bulking.
+			 */
+			WARN_ON(last >=3D ocelot->stats_layout[i].reg);
+
 			region->base =3D ocelot->stats_layout[i].reg;
 			region->count =3D 1;
 			list_add_tail(&region->node, &ocelot->stats_regions);

If not, help me understand the concern better.

> Tangentially related: I'm having a heck of a time getting the QSGMII
> connection to the VSC8514 working correctly. I plan to write a tool to
> print out human-readable register names. Am I right to assume this is
> the job of a userspace application, translating the output of
> /sys/kernel/debug/regmap/ reads to their datasheet-friendly names, and
> not something that belongs in some sort of sysfs interface? I took a
> peek at mv88e6xxx_dump but it didn't seem to be what I was looking for.

Why is the mv88e6xxx_dump kind of program (using devlink regions) not
what you're looking for?

There's also ethtool --register-dump which some DSA drivers have support
for (again, mv88e6xxx), but I think that's mainly per port.

I tried to add support for devlink regions to dump the PGIDs, but doing
this from the common ocelot switch lib is a PITA, because in the devlink
callbacks, we need to access the struct ocelot *ocelot from the
struct devlink *devlink. But DSA keeps the devlink pointer one way, and
the ocelot switchdev driver another. To know how to retrieve the ocelot
pointer from the devlink pointer, you'd need to know where to search for it=
.

So I'm thinking, if we add devlink regions to ocelot, it would be just
for DSA for now.=
