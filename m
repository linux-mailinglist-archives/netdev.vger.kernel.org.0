Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9A44D0A4B
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 22:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241928AbiCGVwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 16:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbiCGVwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 16:52:38 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767D77561B;
        Mon,  7 Mar 2022 13:51:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pb3MYmzRRnY00BBtnTjMm2NG40omktzmwpgXFdC0BGpX6h3yRC9an2E3AcxDwtBMqcHPhy6ciSQaDn/e44jJszSfwHhs5ChVNQrXuz5jVIi9970JJh56pNxCjC8624SqihQ87XUxEuInqInvCweJGCViSRK0GZ8H05l3jL5zs3b2SoxMgyGR6YBCydkTM3iZjxt/IVN0xibRjJwcsWQEdZZgIpTOHwzSYHcluelmrYOlXPHRVSjUgX1ri/CYAdQMXsBShSfUp7f858Tc9U3zt3yEdnq7S9Y7s1/sgEDE+e5MAPamHWqFbIv/vqTaCTeP3a5YrlT+Hfr/XTdOfTHhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s4V27TKlIhjXQedX5qAINfBDfVaa8WSLWc1VboAWkZM=;
 b=QdvUU0dV0zpvoI8pefrRwE07Enmd36c9rntUZMRT4lz3geQPIyU4umrUQgoBABFfq7CP5US702vJUNDQtNRROHORRMLtNcZiOERqT2f+w+RgcN/jhADIGmvfnbTVm34G1xQoev5FRvOrlL1Ejfr4iqDNk9mZBph03WoTA7fugZJHC3j18vJxfUNAlurVEKF7sFv2wwLF/zBFtvg4cgumObQEYB4OMksX3FwK5sspzIQ/DZFHg0u0IGuKRnR1TXZAq3URuFWBn8vYyxdmxOTKyf9J4O0pFpzWnkuI3kYryktTPYIAumZl3geSYCdnzCJHWEu6dy58QRabhO8mt1Lidg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s4V27TKlIhjXQedX5qAINfBDfVaa8WSLWc1VboAWkZM=;
 b=FBtoVvW0mCBn4oybwnpLDMbgfF0fMCtO3vb4wf4O7mMwqm2dY0CfI1LHcisiD6qMn+ws0AvSqrFMwsl0ZLKquH1VRdZkqBazcCY29I7sX98/ituPqiZ97vWS/Xpjs3yIUnwxEk7PZa2kPYKk/QuaoHmFtdr3VNCfgXyq23XW6as=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6864.eurprd04.prod.outlook.com (2603:10a6:803:138::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 21:51:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 21:51:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v6 net-next 9/9] net: dsa: ocelot: add external ocelot
 switch control
Thread-Topic: [RFC v6 net-next 9/9] net: dsa: ocelot: add external ocelot
 switch control
Thread-Index: AQHYFVv2OFzTH6NzTEqZzYsfychF3ax9fC2AgDQ7Z4CAAvi9gA==
Date:   Mon, 7 Mar 2022 21:51:38 +0000
Message-ID: <20220307215137.bpsq3c2cczflzvro@skbuf>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-10-colin.foster@in-advantage.com>
 <20220131185043.tbp6uhpcsvyoeglp@skbuf> <20220306002849.GA1354623@euler>
In-Reply-To: <20220306002849.GA1354623@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71cbb363-a099-4aee-12fd-08da0084a861
x-ms-traffictypediagnostic: VI1PR04MB6864:EE_
x-microsoft-antispam-prvs: <VI1PR04MB68643EB2F8129F67AF1DC02AE0089@VI1PR04MB6864.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x0fff7oRRk24PzuwJFegtqe/RoKxlrqn9un3hmcrhlJuSV9yeCUB4iNyt9/IsoNsXppwmexNNcNPdhJWxEY7eImTULTOreC3aDnwc7EyiOzwZR8BxAD7mupizdDZk47kt/yE3GheaTg3OF05UeoUTjkcPPn4izud4vftIrbkkM8RJ1cXr7NqNxtvP1K06YjS44AsyDAWHaHWV4Vg4UF3veNV3zRukFI27R5oXIVpFu9mweSdaN81+h9jkI7wopF5frj/nYacs1OJP8/82S0TRLA2JRGPCoK5aUBWshhXWPsIqCmnLR25HR2kD7qf/+3hIHClj4VgwiCM/n822is01pO4KXSDpUYYw01ZkmUYyLJ2E/R1W2VlZtklFyNQinye/1Jo1KGK8foOhEzmpdQhfihIqMus2JIKBKkUgFTtvA1hd1L98MeKg06asSdLrYk8b7nXzJUAw3ijdCX2CaDjTtgVu0KH9QtCshp9AMfYSN11YNJTYH38Z7NAgGNsPkbFkZN8Gu7bg8QKmmOLt0VW6CJNl5tQAYQkvi5zxRh2OKLMByuPGW3QhPK16IvtNtPEG1xMRg7URlfqiahM8Ken+xqUVBYHOovQQwwdB3/YgINP/Jt6QZb4A0OC0UL7DUxplsxmR4BjdEznYK7lXpD4goixHeuCY54/n8oV0T2GT3rAPTfTQBkwRviT68PBOx87d8zFuCr0qUG1SpSKvZjdZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(71200400001)(316002)(83380400001)(6486002)(54906003)(508600001)(6506007)(76116006)(86362001)(91956017)(66476007)(4326008)(8676002)(64756008)(66946007)(66556008)(66446008)(26005)(6916009)(186003)(38070700005)(5660300002)(7416002)(8936002)(30864003)(44832011)(6512007)(9686003)(33716001)(1076003)(2906002)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xP9UY0AMcorj0Q9fbRD+X+7+n3HkmBFbMTHzVIFy5Rmkuf7jxKT6eHqmPuEp?=
 =?us-ascii?Q?5g7uF8TEDb1pkpQCm1eCYchwWiYHq7V3lCCloZNg9LJmgBdkjgL2taAfO4rp?=
 =?us-ascii?Q?eacABLJIhHmNeE2MSbTabzHcw9F74Pn6JHoD1VzEz5mtMPBlS1f0WMmuvFCI?=
 =?us-ascii?Q?GMAtfB1pGf94XwzGkABP6/vKouQbT58ezpi6EihUy7W5nl4r2qMNyrPQQChA?=
 =?us-ascii?Q?OXafQAjfqGwIYUzVmZmbRfj82wvjO99b+nZAuewtShQJRcoSZ74k5TvVHAyE?=
 =?us-ascii?Q?+JZkqneit3JOJ7TyZov/8KgGCsGeV7BCOqiNhslYnr2k1kTEZpEjtZpNxJLm?=
 =?us-ascii?Q?Kf56vgJL+i8AcgxMO7Q8D1NEEsfkAlzL+qJrUK7a/2WXWTn51lH61Dkx79WY?=
 =?us-ascii?Q?/IzHy1PI/I1kYpTwfkRI5sryivZVMTqDAqPSIz6Bcq+jMbPnQxHTiXPB/nEn?=
 =?us-ascii?Q?h4DGyWeXEyM7whXrO3JdR47t4UhZj8c18pNqmliJ2ZqTxuYue+f0DbMf30xT?=
 =?us-ascii?Q?VZO5uvgEv0Q3iTwWHOlFqc3RzMmWs1kRfy0bgz35UPfTlbNj2lTT5OQvBYUO?=
 =?us-ascii?Q?fZZ7kbFkPCfVQGhfCk4kLY9ljvOUtVTZPFjbCky1slZqmbaRE6cAcVToJu4n?=
 =?us-ascii?Q?w0fHSsnpqq7xgaYEF6QtYUbKfOTDVuaVEJwoUil7zXtV97PH/DA41arNW2n+?=
 =?us-ascii?Q?Az3IXlgrhXTf0JjgzWt8UeOc6iYjVYEZDGNPshlMmjVKl4Mk3emd1NP9/NB5?=
 =?us-ascii?Q?YUVcF8LquH5UMbS+0YUeDPc//p+DrJ1/nn86jVc4f7kz90RD08ji4u2N3WUJ?=
 =?us-ascii?Q?4W1DvbC5W6DA7mFQLLuh/t9gD15MwNVbDkG2H34cBSFmpgCQPxlM4olqob/3?=
 =?us-ascii?Q?fW3V32vi0dm7Qk5iwiISucHkH0MaWUh1aACtrGDRI4Joxvx2vvUFv92w0BKS?=
 =?us-ascii?Q?5Qc4xRdc+5besbhDy/qJUd0xBMHHK+5Y/+LVQ6IdL6YGFssgmw0GLuKdJDec?=
 =?us-ascii?Q?lI5diOmp9Xar8z9l3jGo/r7ojwiBDQXJydVFOd8VgFf8J5h5y18VT4CjM7ij?=
 =?us-ascii?Q?+YporxHu6LrQ5PAvnqSmsQAn0luBL/fd642QL8Cxg9vZDO8E3RSMHjVhdTIf?=
 =?us-ascii?Q?0yCxN0dnk2Sa9hHt4amR6gjOmWm5AFBVJsSJrqsjwkUZGti7MwStrYgClhmU?=
 =?us-ascii?Q?31YfaFWNzDC2o1FpzM8gr+rMyvYgGQHIIqETrvxWavjMGsQ9ADlYVXV+Jj8B?=
 =?us-ascii?Q?fgZPCCBqDblfGevEvEJkGK3dojLQUtAcWpaxMoxc3b/3K6Ubbc+MxzKhXjN2?=
 =?us-ascii?Q?lR2058Cs2BNdWfo6DmaWs1FlqFEVu6wc8bwMuxi229oWstBsS51vJ7IeXwBm?=
 =?us-ascii?Q?EMVbme9oEnVvmdi9KEmFZzeXTHf54moe6KVpaQrFyJeaLVhI5rnpZtOlPvqu?=
 =?us-ascii?Q?5F/tsxUkbRn1zumTeb1xWjMcn+GkqI02gRRNor0OsUw8hnlnG3PXa3jEczs5?=
 =?us-ascii?Q?NcTUI3/6t6MJR64b2tbjv2xEjifwdNxXX9LgyeZ7jJv63tVAOW3T6dZRdQlp?=
 =?us-ascii?Q?SM4NLacPRkStv0BSbP+u47hRSsSEDe5hh3jyUxhC1V/fsmoNZNJuwnZ8sXwz?=
 =?us-ascii?Q?TgGRR72e7mHAidVSQjKBCKs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3473DE1F434D364DA3D31EAA748C0BCB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71cbb363-a099-4aee-12fd-08da0084a861
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 21:51:38.6338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t0xda6bnKVpPzt9OHroSR1/Gu5JSwR5Hmm6HE/6DJlVq3YUKme9Gs+ONlpGJJngEu/lGwnCMyF3c5ApsKLsG5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6864
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 05, 2022 at 04:28:49PM -0800, Colin Foster wrote:
> Hi Vladimir,
>=20
> My apologies for the delay. As I mentioned in another thread, I went
> through the "MFD" updates before getting to these. A couple questions
> that might be helpful before I go to the next RFC.
>=20
> On Mon, Jan 31, 2022 at 06:50:44PM +0000, Vladimir Oltean wrote:
> > On Sat, Jan 29, 2022 at 02:02:21PM -0800, Colin Foster wrote:
> > > Add control of an external VSC7512 chip by way of the ocelot-mfd inte=
rface.
> > >=20
> > > Currently the four copper phy ports are fully functional. Communicati=
on to
> > > external phys is also functional, but the SGMII / QSGMII interfaces a=
re
> > > currently non-functional.
> > >=20
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> > >  drivers/mfd/ocelot-core.c           |   4 +
> > >  drivers/net/dsa/ocelot/Kconfig      |  14 +
> > >  drivers/net/dsa/ocelot/Makefile     |   5 +
> > >  drivers/net/dsa/ocelot/ocelot_ext.c | 681 ++++++++++++++++++++++++++=
++
> > >  include/soc/mscc/ocelot.h           |   2 +
> > >  5 files changed, 706 insertions(+)
> > >  create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
> > >=20
> > > diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
> > > index 590489481b8c..17a77d618e92 100644
> > > --- a/drivers/mfd/ocelot-core.c
> > > +++ b/drivers/mfd/ocelot-core.c
> > > @@ -122,6 +122,10 @@ static const struct mfd_cell vsc7512_devs[] =3D =
{
> > >  		.num_resources =3D ARRAY_SIZE(vsc7512_miim1_resources),
> > >  		.resources =3D vsc7512_miim1_resources,
> > >  	},
> > > +	{
> > > +		.name =3D "ocelot-ext-switch",
> > > +		.of_compatible =3D "mscc,vsc7512-ext-switch",
> > > +	},
> > >  };
> > > =20
> > >  int ocelot_core_init(struct ocelot_core *core)
> > > diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/=
Kconfig
> > > index 220b0b027b55..f40b2c7171ad 100644
> > > --- a/drivers/net/dsa/ocelot/Kconfig
> > > +++ b/drivers/net/dsa/ocelot/Kconfig
> > > @@ -1,4 +1,18 @@
> > >  # SPDX-License-Identifier: GPL-2.0-only
> > > +config NET_DSA_MSCC_OCELOT_EXT
> > > +	tristate "Ocelot External Ethernet switch support"
> > > +	depends on NET_DSA && SPI
> > > +	depends on NET_VENDOR_MICROSEMI
> > > +	select MDIO_MSCC_MIIM
> > > +	select MFD_OCELOT_CORE
> > > +	select MSCC_OCELOT_SWITCH_LIB
> > > +	select NET_DSA_TAG_OCELOT_8021Q
> > > +	select NET_DSA_TAG_OCELOT
> > > +	help
> > > +	  This driver supports the VSC7511, VSC7512, VSC7513 and VSC7514 ch=
ips
> > > +	  when controlled through SPI. It can be used with the Microsemi de=
v
> > > +	  boards and an external CPU or custom hardware.
> > > +
> > >  config NET_DSA_MSCC_FELIX
> > >  	tristate "Ocelot / Felix Ethernet switch support"
> > >  	depends on NET_DSA && PCI
> > > diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot=
/Makefile
> > > index f6dd131e7491..d7f3f5a4461c 100644
> > > --- a/drivers/net/dsa/ocelot/Makefile
> > > +++ b/drivers/net/dsa/ocelot/Makefile
> > > @@ -1,11 +1,16 @@
> > >  # SPDX-License-Identifier: GPL-2.0-only
> > >  obj-$(CONFIG_NET_DSA_MSCC_FELIX) +=3D mscc_felix.o
> > > +obj-$(CONFIG_NET_DSA_MSCC_OCELOT_EXT) +=3D mscc_ocelot_ext.o
> > >  obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) +=3D mscc_seville.o
> > > =20
> > >  mscc_felix-objs :=3D \
> > >  	felix.o \
> > >  	felix_vsc9959.o
> > > =20
> > > +mscc_ocelot_ext-objs :=3D \
> > > +	felix.o \
> > > +	ocelot_ext.o
> > > +
> > >  mscc_seville-objs :=3D \
> > >  	felix.o \
> > >  	seville_vsc9953.o
> > > diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/oc=
elot/ocelot_ext.c
> > > new file mode 100644
> > > index 000000000000..6fdff016673e
> > > --- /dev/null
> > > +++ b/drivers/net/dsa/ocelot/ocelot_ext.c
> >=20
> > How about ocelot_vsc7512.c for a name?
>=20
> I'm not crazy about "ocelot_ext" either... but I intend for this to
> support VSC7511, 7512, 7513, and 7514. I'm using 7512 as my starting
> point, but 7511 will be in quick succession, so I don't think
> ocelot_vsc7512 is appropriate.
>=20
> I'll update everything that is 7512-specific to be appropriately named.
> Addresses, features, etc. As you suggest below, there's some function
> names that are still around with the vsc7512 name that I'm changing to
> the more generic "ocelot_ext" version.
>=20
> [ ... ]
> > > +static struct ocelot_ext_data *felix_to_ocelot_ext(struct felix *fel=
ix)
> > > +{
> > > +	return container_of(felix, struct ocelot_ext_data, felix);
> > > +}
> > > +
> > > +static struct ocelot_ext_data *ocelot_to_ocelot_ext(struct ocelot *o=
celot)
> > > +{
> > > +	struct felix *felix =3D ocelot_to_felix(ocelot);
> > > +
> > > +	return felix_to_ocelot_ext(felix);
> > > +}
> >=20
> > I wouldn't mind a "ds_to_felix()" helper, but as mentioned, it would be
> > good if you could use struct felix instead of introducing yet one more
> > container.
> >=20
>=20
> Currently the ocelot_ext struct is unused, and will be removed from v7,
> along with these container conversions. I'll keep this in mind if I end
> up needing to expand things in the future.
>=20
> When these were written it was clear that "Felix" had no business
> dragging around info about "ocelot_spi," so these conversions seemed
> necessary. Now that SPI has been completely removed from this DSA
> section, things are a lot cleaner.
>=20
> > > +
> > > +static void ocelot_ext_reset_phys(struct ocelot *ocelot)
> > > +{
> > > +	ocelot_write(ocelot, 0, GCB_PHY_PHY_CFG);
> > > +	ocelot_write(ocelot, 0x1ff, GCB_PHY_PHY_CFG);
> > > +	mdelay(500);
> > > +}
> > > +
> > > +static int ocelot_ext_reset(struct ocelot *ocelot)
> > > +{
> > > +	struct felix *felix =3D ocelot_to_felix(ocelot);
> > > +	struct device *dev =3D ocelot->dev;
> > > +	struct device_node *mdio_node;
> > > +	int retries =3D 100;
> > > +	int err, val;
> > > +
> > > +	ocelot_ext_reset_phys(ocelot);
> > > +
> > > +	mdio_node =3D of_get_child_by_name(dev->of_node, "mdio");
> >=20
> >  * Return: A node pointer if found, with refcount incremented, use
> >  * of_node_put() on it when done.
> >=20
> > There's no "of_node_put()" below.
> >=20
> > > +	if (!mdio_node)
> > > +		dev_info(ocelot->dev,
> > > +			 "mdio children not found in device tree\n");
> > > +
> > > +	err =3D of_mdiobus_register(felix->imdio, mdio_node);
> > > +	if (err) {
> > > +		dev_err(ocelot->dev, "error registering MDIO bus\n");
> > > +		return err;
> > > +	}
> > > +
> > > +	felix->ds->slave_mii_bus =3D felix->imdio;
> >=20
> > A bit surprised to see MDIO bus registration in ocelot_ops :: reset and
> > not in felix_info :: mdio_bus_alloc.
>=20
> These are both good catches. Thanks! This one in particular was a relic
> of the initial spi_device design - no communication could have been
> performed at all until after the bus was getting initailized... which
> was in reset at the time.
>=20
> Now it is in the MFD core initialization.
>=20
> This brings up a question that I think you were getting at when MFD was
> first discussed for this driver:
>=20
> Should Felix know anything about the chip's internal MDIO bus? Or should
> the internal bus be a separate entry in the MFD?
>=20
> Currently my DT is structured as:
>=20
> &spi0 {
>         ocelot-chip@0 {
>                 compatible =3D "mscc,vsc7512_mfd_spi";
>                 ethernet-switch@0 {
>                         compatible =3D "mscc,vsc7512-ext-switch";
>                         ports {
>                         };
>=20
>                         /* Internal MDIO port here */
>                         mdio {
>                         };
>                 };
>                 /* External MDIO port here */
>                 mdio1: mdio1 {
>                         compatible =3D "mscc,ocelot-miim";
>                 };
>                 /* Additional peripherals here - pinctrl, sgpio, hsio... =
*/
>                 gpio: pinctrl@0 {
>                         compatible =3D "mscc,ocelot-pinctrl"
>                 };
>                 ...
>         };
> };
>=20
>=20
> Should it instead be:
>=20
> &spi0 {
>         ocelot-chip@0 {
>                 compatible =3D "mscc,vsc7512_mfd_spi";
>                 ethernet-switch@0 {
>                         compatible =3D "mscc,vsc7512-ext-switch";
>                         ports {
>                         };
>                 };
>                 /* Internal MDIO port here */
>                 mdio0: mdio0 {
>                         compatible =3D "mscc,ocelot-miim"
>                 };
>                 /* External MDIO port here */
>                 mdio1: mdio1 {
>                         compatible =3D "mscc,ocelot-miim";
>                 };
>                 /* Additional peripherals here - pinctrl, sgpio, hsio... =
*/
>                 gpio: pinctrl@0 {
>                         compatible =3D "mscc,ocelot-pinctrl"
>                 };
>                 ...
>         };
> };
>=20
> That way I could get rid of mdio_bus_alloc entirely. (I just tried it
> and it didn't "just work" but I'll do a little debugging)
>=20
> The more I think about it the more I think this is the correct path to
> go down.

As I've mentioned in the past, on NXP switches (felix/seville), there
was a different justification. There, the internal MDIO bus is used to
access the SGMII PCS, not any internal PHY as in the ocelot-ext case.
As opposed to the 'phy-handle' that describes the relationship between a
MAC and its (internal) PHY, no such equivalent 'pcs-handle' property
exists in a standardized form. So I wanted to avoid a dependency on OF
where the drivers would not learn any actual information from it.

It is also possible to have a non-OF based connection to the internal
PHY, but that has some limitations, because DSA has a lot of legacy in
this area. 'Non OF-based' means that there is a port which lacks both
'phy-handle' and 'fixed-link'. We have said that a user port with such
an OF node should be interpreted as having an internal PHY located on
the ds->slave_mii_bus at a PHY address equal to the port index.
Whereas the same conditions (no 'phy-handle', no 'fixed-link') on a CPU
port mean that the port is a fixed-link that operates at the largest
supported link speed.

Since you have a PHY on the CPU port, I'd tend to avoid any ambiguity
and explicitly specify the 'phy-handle', 'fixed-link' properties in the
device tree.

What I'm not completely sure about is whether you really have 2 MDIO
buses. I don't have a VSC7512, and I haven't checked the datasheet
(traveling right now) but this would be surprising to me.
Anyway, if you do, then at least try to match the $nodename pattern from
Documentation/devicetree/bindings/net/mdio.yaml. I don't think "mdio0"
matches "^mdio(@.*)?".

> [ ... ]
> > > +		return err;
> > > +
> > > +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA]=
, 1);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	do {
> > > +		msleep(1);
> > > +		regmap_field_read(ocelot->regfields[SYS_RESET_CFG_MEM_INIT],
> > > +				  &val);
> > > +	} while (val && --retries);
> > > +
> > > +	if (!retries)
> > > +		return -ETIMEDOUT;
> > > +
> > > +	err =3D regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA=
], 1);
> > > +
> > > +	return err;
> >=20
> > "err =3D ...; return err" can be turned into "return ..." if it weren't
> > for error handling. But you need to handle errors.
>=20
> With this error handling during a reset... these errors get handled in
> the main ocelot switch library by way of ocelot->ops->reset().
>=20
> I can add additional dev_err messages on all these calls if that would
> be useful.

Please interpret this in context. Your ocelot_ext_reset() function calls
of_mdiobus_register(), then does other work which may fail, then returns
that error code while leaving the MDIO bus dangling. When I said "you
need to handle errors" I meant "you need to unwind whatever work is done
in the function in the case of an error". If you are going to remove the
of_mdiobus_register(), there is probably not much left.

> [ ... ]
> > > +static void vsc7512_mdio_bus_free(struct ocelot *ocelot)
> > > +{
> > > +	struct felix *felix =3D ocelot_to_felix(ocelot);
> > > +
> > > +	if (felix->imdio)
> >=20
> > I don't think the conditional is warranted here? Did you notice a call
> > path where you were called while felix->imdio was NULL?
> >=20
>=20
> You're right. It was probably necessary for me to get off the ground,
> but not anymore. Removed.
>=20
> [ ... ]
> > > +static int ocelot_ext_probe(struct platform_device *pdev)
> > > +{
> > > +	struct ocelot_ext_data *ocelot_ext;
> > > +	struct dsa_switch *ds;
> > > +	struct ocelot *ocelot;
> > > +	struct felix *felix;
> > > +	struct device *dev;
> > > +	int err;
> > > +
> > > +	dev =3D &pdev->dev;
> > > +
> > > +	ocelot_ext =3D devm_kzalloc(dev, sizeof(struct ocelot_ext_data),
> > > +				  GFP_KERNEL);
> > > +
> > > +	if (!ocelot_ext)
> >=20
> > Try to omit blank lines between an assignment and the proceeding sanity
> > checks. Also, try to stick to either using devres everywhere, or nowher=
e,
> > within the same function at least.
>=20
> I switched both calls to not use devres and free both of these in remove
> now. However... (comments below)
>=20
> >=20
> > > +		return -ENOMEM;
> > > +
> > > +	dev_set_drvdata(dev, ocelot_ext);
> > > +
> > > +	ocelot_ext->port_modes =3D vsc7512_port_modes;
> > > +	felix =3D &ocelot_ext->felix;
> > > +
> > > +	ocelot =3D &felix->ocelot;
> > > +	ocelot->dev =3D dev;
> > > +
> > > +	ocelot->num_flooding_pgids =3D 1;
> > > +
> > > +	felix->info =3D &ocelot_ext_info;
> > > +
> > > +	ds =3D kzalloc(sizeof(*ds), GFP_KERNEL);
> > > +	if (!ds) {
> > > +		err =3D -ENOMEM;
> > > +		dev_err(dev, "Failed to allocate DSA switch\n");
> > > +		return err;
> > > +	}
> > > +
> > > +	ds->dev =3D dev;
> > > +	ds->num_ports =3D felix->info->num_ports;
> > > +	ds->num_tx_queues =3D felix->info->num_tx_queues;
> > > +
> > > +	ds->ops =3D &felix_switch_ops;
> > > +	ds->priv =3D ocelot;
> > > +	felix->ds =3D ds;
> > > +	felix->tag_proto =3D DSA_TAG_PROTO_OCELOT;
> > > +
> > > +	err =3D dsa_register_switch(ds);
> > > +
> > > +	if (err) {
> > > +		dev_err(dev, "Failed to register DSA switch: %d\n", err);
> > > +		goto err_register_ds;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +err_register_ds:
> > > +	kfree(ds);
> > > +	return err;
> > > +}
> > > +
> > > +static int ocelot_ext_remove(struct platform_device *pdev)
> > > +{
> > > +	struct ocelot_ext_data *ocelot_ext;
> > > +	struct felix *felix;
> > > +
> > > +	ocelot_ext =3D dev_get_drvdata(&pdev->dev);
> > > +	felix =3D &ocelot_ext->felix;
> > > +
> > > +	dsa_unregister_switch(felix->ds);
> > > +
> > > +	kfree(felix->ds);
> > > +
> > > +	devm_kfree(&pdev->dev, ocelot_ext);
> >=20
> > What is the point of devm_kfree?
> >=20
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +const struct of_device_id ocelot_ext_switch_of_match[] =3D {
> > > +	{ .compatible =3D "mscc,vsc7512-ext-switch" },
> > > +	{ },
> > > +};
> > > +MODULE_DEVICE_TABLE(of, ocelot_ext_switch_of_match);
> > > +
> > > +static struct platform_driver ocelot_ext_switch_driver =3D {
> > > +	.driver =3D {
> > > +		.name =3D "ocelot-ext-switch",
> > > +		.of_match_table =3D of_match_ptr(ocelot_ext_switch_of_match),
> > > +	},
> > > +	.probe =3D ocelot_ext_probe,
> > > +	.remove =3D ocelot_ext_remove,
> >=20
> > Please blindly follow the pattern of every other DSA driver, with a
> > ->remove and ->shutdown method that run either one, or the other, by
> > checking whether dev_get_drvdata() has been set to NULL by the other on=
e
> > or not. And call dsa_switch_shutdown() from ocelot_ext_shutdown() (or
> > vsc7512_shutdown, or whatever you decide to call it).
>=20
> ... I assume there's no worry that kfree gets called in each driver's
> remove routine but not in their shutdown? I'll read through commit
> 0650bf52b31f (net: dsa: be compatible with masters which unregister on sh=
utdown)
> to get a more thorough understanding of what's going on... but will
> blindly follow for now. :-)

The remove method is called when you unbind the driver from the
device. The shutdown method is called when you reboot. The latter can be
leaky w.r.t. memory allocation.

My request here was to provide a shutdown method implementation, and
hook it in the same way as other DSA drivers do.

> >=20
> > > +};
> > > +module_platform_driver(ocelot_ext_switch_driver);
> > > +
> > > +MODULE_DESCRIPTION("External Ocelot Switch driver");
> > > +MODULE_LICENSE("GPL v2");
> > > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > > index 8b8ebede5a01..62cd61d4142e 100644
> > > --- a/include/soc/mscc/ocelot.h
> > > +++ b/include/soc/mscc/ocelot.h
> > > @@ -399,6 +399,8 @@ enum ocelot_reg {
> > >  	GCB_MIIM_MII_STATUS,
> > >  	GCB_MIIM_MII_CMD,
> > >  	GCB_MIIM_MII_DATA,
> > > +	GCB_PHY_PHY_CFG,
> > > +	GCB_PHY_PHY_STAT,
> > >  	DEV_CLOCK_CFG =3D DEV_GMII << TARGET_OFFSET,
> > >  	DEV_PORT_MISC,
> > >  	DEV_EVENTS,
> > > --=20
> > > 2.25.1
> > >=
