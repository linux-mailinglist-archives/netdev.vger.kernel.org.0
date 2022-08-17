Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FA959796D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 00:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbiHQWD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 18:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238561AbiHQWD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 18:03:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80083.outbound.protection.outlook.com [40.107.8.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECA16E2DB
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 15:03:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Awe63hCNVKHK9v1XmkcDlM7FyAgttoKJnX6LoG/22n2L7aXnnqLd01JUkb5uHfJYR4DUOrCoIKjTtKf5JnTR7mdR5Cd+ZSv4DvpG0v5LnNBwM63HpIAg4mSbXuMkubBinf69DJbdaKCu9sgA4vOdqNcXZs3st8ZMBY4iN3mKUk1BkMvLvbbdZDtn+Qv00zMH/LF75rksuQIvPiZmK32/s50uvy69Hdm33WP5WpdSiaTcXcQVXWYIixpmDhmKKqptsUXBn55Vak0ztFKY2GG3H/8m1gY5eGI8bGG4lJxdV2LG45VhAVhm3JtmaxJr1CdOjtf6hF3Smg6Xh35Hj0Rjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+yrI40xSqxakNCOZxYaJC14/RAmjCtVNv+povmW2UI=;
 b=DvLDcqLU+X6Afm3v79b/E3A5cDyBzd8Q1Fe989RWCYquaMjPc68h6pDsuILT2CJ1rahfseisnlTVZhxq7KAq1EcAZ2GVGIFRzjMQEaTR73mPvcfotVgaSwliDPBz8mmrfrUJA8xfMGuKJcfhdp8zA8PKo/ryxDNCVR5LbXj/ApfCkJbu22KvJ8FxVouYFZt8R67599PiJKm/ILh5h8ZxURyGXuJt38+1INuIdgVy7KLnrLXxpPp/JKVID7gCQAvxtvl0QsDmlfnLMpBNWG7zmw3y8ubngQhTthkwzO1jlOnaSobVx18AOgVh5XfK4rCI1gGJmY6qK2YSdYy0j20xSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+yrI40xSqxakNCOZxYaJC14/RAmjCtVNv+povmW2UI=;
 b=bwh4Jd86j4dpChkPjgcTtLsRK6sjM/jrboSZQBK2a2Nr57Oi1CZPSbnbZLfOKxkvWlLrdufVWjg46QxBiDGlFEJtBByAbUKBLp4oGCq8kVEUcfCGnOgOUmenz9S5ddNn7KI7FocTdhf0f0g6rizkMQfi3wCwPJnaz5NQKKUa7wc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB3PR0402MB3850.eurprd04.prod.outlook.com (2603:10a6:8:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 22:03:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 22:03:51 +0000
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
Thread-Index: AQHYsXet4txs5KEUy0mU0hPxnOpCE62yp00AgABIogCAACEwgIAAI/GAgAApbgCAADOZgIAAFXGA
Date:   Wed, 17 Aug 2022 22:03:51 +0000
Message-ID: <20220817220351.j6pzwufbdfqz3vat@skbuf>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com> <YvyO1kjPKPQM0Zw8@euler>
 <20220817110644.bhvzl7fslq2l6g23@skbuf>
 <20220817130531.5zludhgmobkdjc32@skbuf> <Yv0FwVuroXgUsWNo@colin-ia-desktop>
 <20220817174226.ih5aikph6qyc2xtz@skbuf> <Yv1Tyy7mmHW1ltCP@colin-ia-desktop>
In-Reply-To: <Yv1Tyy7mmHW1ltCP@colin-ia-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f1acef8-06ca-43fc-8da0-08da809c5eab
x-ms-traffictypediagnostic: DB3PR0402MB3850:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /BzoZYMnOxNFeZOGB8Jglx+Rhh0l1sS6RD9XedNrZ2rO1wP2+3AHwqAi1UyTM5WHOtB/FwO3BvDXpZS3c5yX7+nk1INl3yQ5sx3GOrhFM9A7azH4Ny0S/MzvJsEQ30HCez3JCdBAi3JFKDVsD1Hv9R0cQC9f64Ak5sxX0U9fLeFfVTWOFQ/mxT/uwKcwc04u7UfOEdOKxP9yPC9iEBWm5F3DX1YU9OWoOZ+QTcUZlil0N8GIvXrXccMYYEojQ7AshbPacD5m4dOWBKg4SjhqAqNFDnOE+a8u/dlZ2oANbPMtLOxmhKfGBvObkbnw53t/DSV8xzkZngziNE+/eBOtF6ZNS9gSPNyeilPj7HcVtLa6utr2GEzv1UFs7SWM8XV4GEnvXg6zcpsa/GU2/IMSXJglzrGCqlfWA9trt7X0HUasmKC0pEtdd626fyLlYrSw9pse1hkOWLyf9Abi/2A2iLCnbLR7D3vBhBgNrm3hEnZYQhEBIlB92WW91OolhhKXkgCFF6dfivgurbyC6Ha40lodWkK9ZkIpB8JvJ/25dsbcW1n3sEInHZpXsFLvD3aVu+jA8edPol1Q4ZKwMm6r25llPbIK+3Z6a6GT2TPp2mrGZ5lCruCn7DXa2WojsNf/BQWhixxcOJkA0K1T9mSmIozpeDn1rCINpfG8tpQqC/DQPC+ez3I5/Smc8gRlfSApM8lejZI3P3j7P6uU2MySLQFgGI1+TgOUxR2mOgYYewYi0MlU12Xc66buC5kvzKO3C5yl43hEJZRN/4xwGj+Q7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(1076003)(38100700002)(38070700005)(186003)(8936002)(122000001)(83380400001)(5660300002)(66476007)(8676002)(76116006)(66556008)(64756008)(33716001)(4326008)(66446008)(66946007)(2906002)(478600001)(44832011)(7416002)(6512007)(26005)(91956017)(54906003)(6506007)(71200400001)(316002)(9686003)(6916009)(6486002)(41300700001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Oyn6simW+xwJxNOcoCtgtGHimC/WOGVi0tfh20E/zbcFlpSyALkROicgaPHV?=
 =?us-ascii?Q?zKcJT0IqlvyNhiWyBmPniKbCvWGdYupCLW9OrzbJwcAnAIx8r+QiqsibcNxj?=
 =?us-ascii?Q?aO4n00sNtNLpJ8hUfMYJx54cGHgkKe9shDEsWy/73SGP29z6LPRB5QuMU2Rx?=
 =?us-ascii?Q?jbeIOo+gW8i3HS7KFuo0yvJWM1fgTxyjWN8py82q4UxED/sYqXZ8vXevPm5z?=
 =?us-ascii?Q?/3zn4+0dUiQ2R61Qjfa8B0ltgmkLLts7xxmj9rFCVq1/OmJop6uDtNMTGibQ?=
 =?us-ascii?Q?oHicLh5berLirbT49QZH79kEXmZjzy4H0+MrOHPONMDfjXfzcp4uvL/q+IaD?=
 =?us-ascii?Q?HrH7ulpcRVe3WESTe4mKbCSkfQHzoFkBQ1Xlqjwq6Si9/LrEWfmyG71hsu1t?=
 =?us-ascii?Q?4c88j88YfLprwRT8Qa6ZeXmjpG4GBxOV1otIhwdHFvAUFIdBd/TOwOgeOz3O?=
 =?us-ascii?Q?hBbfOPhjtmiDtARUH8nqeFSWoETgvCYKMgNM0SmE8s8DEzT797f6WuRdafko?=
 =?us-ascii?Q?XEtsQdujrYTynyjPAT4ciJjHIcqByPAbCrPEd1x+yU5g0zJDVaL9TbZJIpKs?=
 =?us-ascii?Q?PHP60M60hbUKSb3MLAqZPGbiKIdcSVAqxKQNfT9k+8Ez7I09PtWpwS1d2pHl?=
 =?us-ascii?Q?j1YSRWpWZk2JTJdN4RbHE08rBCcK7lUQtNFCOjym95Pvy0LuDiTFy8DRcFod?=
 =?us-ascii?Q?EmRZcMPUHbAqCgRTb3JsYToCJlR0e9v0A6UxLnPUXAfBbOqNcU4yT1a0v8IZ?=
 =?us-ascii?Q?0nb3TIJRpOUYJ5gdrBVkw8q8nOCmoLWkBGtBv9lt86vtPYvU0UmT/TtmQJ7e?=
 =?us-ascii?Q?jCW3Wg6sf8/vMonFn3N1lq+Esfd8zfUGylRbI2b9n8JHzWZ1XmlKCVFC/s56?=
 =?us-ascii?Q?rezqlOa0OKa3MJvU+Gvqpc7R8PPddAvJGzB0qavfFfEGD6v2OMZDKSpw1hrh?=
 =?us-ascii?Q?vi7m9XLNSKKMLxUGiG3xGmmYJInvnWim+2xR6UWD/2p+bmjNGaDUu4xkwsiQ?=
 =?us-ascii?Q?Y3HetzLB2lejA0sR1LEnUQAWIbeGApQw3W8NsQLc7P9tgDOml/DCPvXHsdlm?=
 =?us-ascii?Q?o5NNjz6kGstU5nUZw5WhOppZOMXkcGw6fDSAvB5z2T0Vh30PmJiavVo0f+uM?=
 =?us-ascii?Q?4KccwM82HudLslBtmiIsLgpULE+PPmXQzbDrUhbaPMa3S5G0hc6vZrbwG0vJ?=
 =?us-ascii?Q?81N9ZQT/ljPT7uBvEWzHGJya4hmpeOBdfqmX6wVnftDSOscrjAzR7OQ+O/4m?=
 =?us-ascii?Q?jh92HJvjwtKhoq+CF6jh08hn01DaofmA9uH9TjbIwO7MuY/LIqqwzavfIyYQ?=
 =?us-ascii?Q?7J9d3ePUcOoSejT+/xI5x2Wqj8H838KDQNTjr6Hg+srTt+aVIXTIyaUnNQrY?=
 =?us-ascii?Q?Wxyv/j/vtzfFLYG95jDM/bbwdHM487xZUF7VdyYw9Myuabrsxvou8sIvtJej?=
 =?us-ascii?Q?5KW1Jf7Su1Vam2IkBnbmMVuo2mnm3rz1SaJqFiPxyn3iqk9Or7Yh0TUGNKhE?=
 =?us-ascii?Q?xZMujmzi9XnIelpmfxtZ54+FxKPPDecCNaLKF3h8wKzFV1GXsqUEXaSRQ16a?=
 =?us-ascii?Q?XH+ZvM8HDEdlDAdx1NOiajfYjGyu9Hzt46M+Phrr6tR5BqA6nnilcpon3wu+?=
 =?us-ascii?Q?HQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0207575CC68D844590B477035FFEB5A3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1acef8-06ca-43fc-8da0-08da809c5eab
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 22:03:51.7744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: byW39C/6nVtqUjCd2ZxPNfRCJg+bYLK0vVXOKyKRZ7A5wfMRuP2HHviyhGc8i396KC2zhojPNWwjv13Z45Sl9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3850
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 01:47:07PM -0700, Colin Foster wrote:
> > How about we add this extra check?
> >=20
> > diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/eth=
ernet/mscc/ocelot_stats.c
> > index d39908c1c6c9..85259de86ec2 100644
> > --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> > +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> > @@ -385,7 +385,7 @@ EXPORT_SYMBOL(ocelot_port_get_stats64);
> >  static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
> >  {
> >  	struct ocelot_stats_region *region =3D NULL;
> > -	unsigned int last;
> > +	unsigned int last =3D 0;
> >  	int i;
> > =20
> >  	INIT_LIST_HEAD(&ocelot->stats_regions);
> > @@ -402,6 +402,12 @@ static int ocelot_prepare_stats_regions(struct oce=
lot *ocelot)
> >  			if (!region)
> >  				return -ENOMEM;
> > =20
> > +			/* enum ocelot_stat must be kept sorted in the same
> > +			 * order as ocelot->stats_layout[i].reg in order to
> > +			 * have efficient bulking.
> > +			 */
> > +			WARN_ON(last >=3D ocelot->stats_layout[i].reg);
> > +
> >  			region->base =3D ocelot->stats_layout[i].reg;
> >  			region->count =3D 1;
> >  			list_add_tail(&region->node, &ocelot->stats_regions);
> >=20
> > If not, help me understand the concern better.
>=20
> You get my concern. That's a good comment / addition. Gaps are welcome
> in the register layout, but moving backwards will ensure (in the current
> implementation) inefficiencies.

Ok. The WARN_ON() won't trigger with current code. Do you mind if I add
it as a net-next change, and don't resend this series for net? I'm
worried I'll miss this week's "net" pull request which means I'll have
to wait some more for the other rework surrounding stats handling in the
ocelot driver (which in turn is a dependency for frame preemption).

> >=20
> > > Tangentially related: I'm having a heck of a time getting the QSGMII
> > > connection to the VSC8514 working correctly. I plan to write a tool t=
o
> > > print out human-readable register names. Am I right to assume this is
> > > the job of a userspace application, translating the output of
> > > /sys/kernel/debug/regmap/ reads to their datasheet-friendly names, an=
d
> > > not something that belongs in some sort of sysfs interface? I took a
> > > peek at mv88e6xxx_dump but it didn't seem to be what I was looking fo=
r.
> >=20
> > Why is the mv88e6xxx_dump kind of program (using devlink regions) not
> > what you're looking for?
>=20
> I suspect the issue I'm seeing is that there's something wrong with the
> HSIO registers that control the QSGMII interface between the 7512 and
> the 8514. Possibly something with PLL configuration / calibration? I
> don't really know yet, and bouncing between the source
> (ocelot_vsc7514.c, {felix,ocelot-ext}.c, phy-ocelot-serdes.c), the
> reference design software, and the datasheet is slowing me down quite a
> bit. Unless I am mistaken, it feels like the problems I'm chasing down
> are at the register <> datasheet interface and not something exposed
> through any existing interfaces.

So you mean you suspect that the HSIO register definitions are somehow
wrong? You mean the phy-ocelot-serdes.c driver seems to behave strangely
in a way that could possibly indicate it's accessing the wrong stuff?
Do you have any indication that this is the case? I'm not familiar at
all with blocks that weren't instantiated on NXP hardware (we have our
own SERDES), and I see you're already monitoring the right source files,
so I'm afraid there isn't much that I can help you with.

> I plan to get some internal support on that front that can hopefully
> point me in the right direction, or find what I have set up incorrectly.
> Otherwise it probably doesn't even make sense to send out anything for
> review until the MFD set gets accepted. Though maybe I'm wrong there.

IDK, if you have a concrete description of the problem, I suppose the
contributors to the SERDES driver may be able to come up with a
suggestion or two?

I suggest you try to cover all bases; is the HSIO PLL locked and at the
right frequency for QSGMII? Does the lane acquire CDR lock? Are in-band
autoneg settings in sync between the PCS and the PHY? Does the PCS
report link up?

> I'd also like to try to keep my patch version count down to one nibble
> next time, so I'm planning on keeping ports 0-3 and ports 4-7+ in
> separate patch sets :D=
