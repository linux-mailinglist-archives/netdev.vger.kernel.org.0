Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388DD629E7C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiKOQIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiKOQIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:08:44 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35909B86E;
        Tue, 15 Nov 2022 08:08:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fL4uxxix84toMvW1N63P/5YgMQPEJf2yUFlcPmphx/yQDK/3UeCtJmN/MnhkAPTm0vKRL7xW+6vGJIMhgBKKdbb7xbsPR4mpnU03y+i5Ygojrxqha4yRdCB7nIsunBirEJGpAi28JDQkkFZQ/roogxAIrYtOJX6QrEE7h9lcSMMPrh+TxBcXm2/eb5rTtNYMrMouXXfs/xULOtjYkkIIUR38MBzXcZgBW8r7QwVARr3wEQK0d1rJLjI0SopJSUWRxyXiCAA2VtVb7vgHU5SaVF7oaxUKAvbzLOObOr0GLnjYDTMjHrjoSFV/VqKv6uBeHUJ2JPdthn0xAFllclIevw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPpmUTDIb5XhRzMR9fTwVG/LSrZpZ8/wZrjLpgVIcQM=;
 b=fv61544PeSTu0iicmGv+GwLX9jnL80DgTFs2qJKO7HdhnpdcklaIPsWOqgyptVgnqRZI4epFmE4Pa0XxABCbnO8C0ekGke7K9J3ZscieT1CagbbuV05u5brXIDvfBxUlR2NqiN518zClgqqBQj4IJ9b5L5KiiF9A68uqgsH8NFHrW5oGAA27XfB08NkVRlsbF5NaWXMtxHrpD/JYX9EGbtkacv9f1Hf/1N8ON2JQgM6kHL9WCc6w58N5sYFe7wjuk1WsrtiaCV8d5qPuSPGb1goa2hhX5nIbz3qYNcJsV3Kb4sOeAn5KN2rfNGXVPC02V1vz5hEFrg/1BX/nQq2t0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bPpmUTDIb5XhRzMR9fTwVG/LSrZpZ8/wZrjLpgVIcQM=;
 b=STBxCq6LB1ZiB3FiRps+VPDQnEnrHN2dfRwkbgz0F+fWhKdcv9xwfYyw5uNZ/Vs+B/ZN9G0q1ZQNh9x8O6kd0MRkFM4YQUttcv+4MPJkBG4Ik+2Dk4+uG3ERo/FsGBBkHKQHbpTsVNmh6ZLY4z3GUcIPb//msqAVGn6rIjX8EpU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB9592.eurprd04.prod.outlook.com (2603:10a6:102:271::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 16:08:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 16:08:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Thread-Topic: [PATCH v1 net-next 1/2] net: mscc: ocelot: remove redundant
 stats_layout pointers
Thread-Index: AQHY9g8iL4WNmd41D0+zI2HGRNCF864+i8WAgADRDACAANAcgA==
Date:   Tue, 15 Nov 2022 16:08:40 +0000
Message-ID: <20221115160839.rgyoa23yabrklpxd@skbuf>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-2-colin.foster@in-advantage.com>
 <20221114151535.k7rknwmy3erslfwo@skbuf> <Y3MK9PCz0JQSQNiQ@euler>
In-Reply-To: <Y3MK9PCz0JQSQNiQ@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PA4PR04MB9592:EE_
x-ms-office365-filtering-correlation-id: 703070c0-e6f5-4b5f-28e6-08dac723a983
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KUSvifA9shfdii4OpYuOsUvh25fhtZG0mNhHiGxCX3YsWzt0CWH4gFmnsZC/HzgsNmsD01dsxkp2KRkQhKvGgUoONo3o8uyWx/l1m9xFaQMJa9vNoJiMUguF+64DwCNm5oiu9JjMBv1SwHirJKKgzdhPQJ2cH4Yz+Zb6vZT0TtNNLFj0mNVGM1oNkforLkpQUdCtS6yAnT7JuOF4piLxYEoA28Qlgzsl/uvt22/LUY4nGt967hxjdzcOnpPoqYTSG9Ij1hV+bX57MlYbzYMXn9p/RaUxAWFrZY2nonF3adU/KAvwqQmvLi4J3p8wlwGzmiofwwG8T7CngYo9iOO9pxU2WqFJ2Ju/hLgf/RsHu+R4mW6E6VNM8FuVrupXWpxVrIrDDEX01HoS1tnxhcebL4bizVOfTOB6JnfwTxc8G4CN4zpfLlmuUjWulLdwPUXY8rSVV7bVIyZ4B7tLwVYV6fxs02lh33XVWQWokoxye2EeqBE4RgURpGReK+IZhYKyy77PEqV2osD9iO19rRFfTg3UlkFV4QVyOrCXoGM7qGXOuvIySN0hSBrJkwrlJ4BNXAlDkuy7Ofb2V6a8eWfI8BJj/TkiZtCC6vZTsw3IpkpsG8z26NSLGczFw8x0fd0Y9TCmcI51NHM40EL0tqudST6V67A/MYlf6dVLtPt7XznC67MexLPY/Q2OEC1zd07THkph0Z/RHgjz8ayFRWfu3RvLbSto0KcTl4SoGjdGPxqqo8MkFiIsY8maGIS4nPav3VS96mNMN2Lfcj3qd3tfuSWhznp5WZ3zYH8XtSbG5gU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(5660300002)(26005)(9686003)(8936002)(8676002)(66556008)(64756008)(4326008)(76116006)(66946007)(66446008)(7416002)(186003)(41300700001)(6512007)(66476007)(44832011)(1076003)(316002)(86362001)(122000001)(38100700002)(83380400001)(2906002)(33716001)(38070700005)(478600001)(71200400001)(966005)(6486002)(66899015)(54906003)(6506007)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fb88X/TQ1Oni2r4Xa2Tw6tNLVpTUlwNrdZLL55mt0DhPP+IvVHMNGbCxvybc?=
 =?us-ascii?Q?e/f9GTDDIA5Ceg812rRMWskhjY/oPbNgSxY9o6Xjl3HufgJkIRUE54LHzDSH?=
 =?us-ascii?Q?NtXNciS+MHXpX4rVHBqRJB1uBtpY6KqkAgignC06aMeV74CgOBpvfVHnwmQY?=
 =?us-ascii?Q?bRRKA7VRnh7tIFjE8jpeUrJn1WFfoih0Fh6m5sUTWrDvVAvNlSSBZQx+sO/N?=
 =?us-ascii?Q?OzckUGJBIkLpn3dzyO7q6O5ASeiV0I9f7/8k0MWbvF5lnJfsXlriIDp7xBkJ?=
 =?us-ascii?Q?Ru9Zav2ojWnNd/eYJndH0DZAsy4do7TigCRqKcJFw5HgU7XdB0wqW1Mm4Iff?=
 =?us-ascii?Q?/k8/M1yJXbRYY+Hb5ta8aUM9F0T80Mj58dyfocDpqP859tVTFuYMDBYLz9Wv?=
 =?us-ascii?Q?/zQUZwq2yhIzEUee4U0+Cjxo+97Rwt8NE9bQT6pLeFBCSuNJX68DUDliEJrl?=
 =?us-ascii?Q?CWCf/2HOMJZnXGXOx614GN/8wmpl0IIGqvsrhHX7GxNZqZxEwXaBNIVg99fP?=
 =?us-ascii?Q?alna1GUiFOmo8E6gogejWXT0J90JsGcN/LLGVBshCZ8Nlll2aRA106RyWsNO?=
 =?us-ascii?Q?GkQc3pHtD9+Agi9/Ov+UmMu7JchTkZ8/B9IQ66l17tty6ssmNpJs0qo9DZ2+?=
 =?us-ascii?Q?0Ya3javG5T6Un5CBPEaHafZBA7mMPWE9D6y7A5QKZUuTfteC1XV6ZEWv3+lR?=
 =?us-ascii?Q?Ctatgl1g/Vu6Bq5Z9Edf1nbNbcBXLqsMlWEMKarnkZe5Caq87MLdEI4VAfH9?=
 =?us-ascii?Q?I8BN3VmUCdFYeBJwyh044YPBNU8pJXb0g24qPj97HV/QK9qfRM9+tAkoReBc?=
 =?us-ascii?Q?mXRN9Mp01t/N9t6axkq2+9BknMzK47Q8Dl2BS3oJvAj9pumf4vgHZmjkT9Ci?=
 =?us-ascii?Q?smr4RUk08suNjzEIx4huv9W7mvlVP0C+Wb47sD1K/WM5Q9gSU0x7tMWjDlDD?=
 =?us-ascii?Q?M72Dw+hyZFlJ7K8dnWOd1OWTERmEfS8Q6tZvTZzameEm/6rLaj7YWFyY4GJb?=
 =?us-ascii?Q?UwmhmzVT5kdx0lE1lyHZyvX4K8H/GUcQtPakogeydsjNMfvOF7phGlalWO3a?=
 =?us-ascii?Q?6wQnuDG6e/B2NwObI81V2MkxoCXLr2fBWWw5I6QWQQG+zE2U6cEkSIeVaB/d?=
 =?us-ascii?Q?W+x3y/igjehUPTYI1zYcSSTNJ5DuLBZVVpRMOM+kpfvbtpaTGVY0tuvnFgSC?=
 =?us-ascii?Q?xVFk+ACNp8OXNmTr58kYP1S5QwM9AZ3ODS42q4RUsW6DpxaY65NKAc+WaEZ1?=
 =?us-ascii?Q?HSdHKcKhblpkv1kqdxHo4eT2wlkJvXrg2C9mSy78084iGpZcJHgRNHLFnKhX?=
 =?us-ascii?Q?S5EzmDpYY8F8DSFzpNDpsCaiSCmv/2eObSNTDIGKR78wg2SO6OcYh0bDTtdU?=
 =?us-ascii?Q?VMHiwCXRwiTSeROa2mleyfFqpU0UMMVKVxCMkhB4ChN7iX/Tas7cqPAN1FSq?=
 =?us-ascii?Q?bZefYmiw55NQ9IJAOYSgw9IdzqxsYart+0p3kHiPgvHh15PPykajq5giGlK7?=
 =?us-ascii?Q?nJec+jmllo7tL9WPdXYC+FDwm5eEgzb/cpDWD8ol43JCgAKeWH2FWOM//U2z?=
 =?us-ascii?Q?ioNZKTQcdU4YcL8Ff6pbNlIDSmwRPAAgzOU4tb8LeqF82hVnWOWu0Pjad7Kd?=
 =?us-ascii?Q?tQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D72356855A20540BF289381C4C43B54@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703070c0-e6f5-4b5f-28e6-08dac723a983
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 16:08:40.7605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gQ2hwMqpNEfSJClbRzHT2Gads2o+QvYSBYjtJb4lLYFVrEE0ryPNUfgeDz6vopl8PhZxxdiSm4C5CRAo7HAMWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9592
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 07:43:48PM -0800, Colin Foster wrote:
> > The issue is that not all Ocelot family switches support the MAC merge
> > layer. Namely, only vsc9959 does.
> >=20
> > With your removal of the ability to have a custom per-switch stats layo=
ut,
> > the only remaining thing for vsc9959 to do is to add a "bool mm_support=
ed"
> > to the common struct ocelot, and all the above extra stats will only be=
 read
> > from the common code in ocelot_stats.c only if mm_supported is set to t=
rue.
> >=20
> > What do you think, is this acceptable?
>=20
> That's an interesting solution. I don't really have any strong opinions
> on this one. I remember we'd had the discussion about making sure the
> stats are ordered (so that bulk stat reads don't get fragmented) and that
> wasn't an issue here. So I'm happy to go any route, either:

Oops, I completely forgot about this patch, which I promised I'd submit
to net-next and I never did:
https://patchwork.kernel.org/project/netdevbpf/patch/20220816135352.1431497=
-7-vladimir.oltean@nxp.com/#24973682

Would you mind picking it up since you're dealing with stats ATM anyway?

>=20
> 1. I fix up this patch and resubmit

Honestly, I don't quite remember today what I had in mind yesterday with
"mm_supported" - I'm not sure how that would work. I guess it involves
creating an extra struct ocelot_stat_layout array beyond ocelot_stats_layou=
t[],
which would be called ocelot_mm_stats_layout[].

What you mentioned just above with the stats ordering is going to be a
problem with this approach, because we'd need to modify ocelot_prepare_stat=
s_regions()
to construct the regions based on 2 distinct struct ocelot_stat_layout
arrays, depending on whether ocelot->mm_supported is set (at least that's
what I believe I was saying yesterday). But if we merge the arrays if
mm_supported is set, we need to merge them in a sorted way. Complicates
a lot of things.

> 2. I wait until the 9959 code lands, and do some tweaks for mac merge sta=
ts

Hmm, waiting for me to do something sounds like a potentially long wait.
Why do you need to make these changes exactly? To reduce the amount of
stuff exposed for vsc7512, right?

> 3. Maybe we deem this patch set unnecessary and drop it, since 9959 will
> start using custom stats again.
>=20
>=20
> Or maybe a 4th route, where ocelot->stats_layout remains in tact and
> felix->info->stats_layout defaults to the common stats. Only the 9959
> would have to override it?

Something like that, maybe we could have a helper that is used in
ocelot_stats.c like this:

static const struct ocelot_stat_layout *
ocelot_get_stats_layout(struct ocelot *ocelot)
{
	if (ocelot->stats_layout)
		return ocelot->stats_layout;

	return ocelot_stats_layout; // common for everyone except VSC9959
}

and we keep exposing to the world the OCELOT_COMMON_STATS macro and
whatever else is needed for VSC9959 to construct its own vsc9959_stats_layo=
ut.

Or..... hmm (sorry, this is a single-pass email, not gonna delete
anything previous), maybe we could implement the helper function like
this:

static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS=
] =3D {
	OCELOT_COMMON_STATS,
};

static const struct ocelot_stat_layout ocelot_mm_stats_layout[OCELOT_NUM_ST=
ATS] =3D {
	OCELOT_COMMON_STATS,
	OCELOT_STAT(RX_ASSEMBLY_ERRS),
	OCELOT_STAT(RX_SMD_ERRS),
	OCELOT_STAT(RX_ASSEMBLY_OK),
	OCELOT_STAT(RX_MERGE_FRAGMENTS),
	OCELOT_STAT(TX_MERGE_FRAGMENTS),
	OCELOT_STAT(RX_PMAC_OCTETS),
	OCELOT_STAT(RX_PMAC_UNICAST),
	OCELOT_STAT(RX_PMAC_MULTICAST),
	OCELOT_STAT(RX_PMAC_BROADCAST),
	OCELOT_STAT(RX_PMAC_SHORTS),
	OCELOT_STAT(RX_PMAC_FRAGMENTS),
	OCELOT_STAT(RX_PMAC_JABBERS),
	OCELOT_STAT(RX_PMAC_CRC_ALIGN_ERRS),
	OCELOT_STAT(RX_PMAC_SYM_ERRS),
	OCELOT_STAT(RX_PMAC_64),
	OCELOT_STAT(RX_PMAC_65_127),
	OCELOT_STAT(RX_PMAC_128_255),
	OCELOT_STAT(RX_PMAC_256_511),
	OCELOT_STAT(RX_PMAC_512_1023),
	OCELOT_STAT(RX_PMAC_1024_1526),
	OCELOT_STAT(RX_PMAC_1527_MAX),
	OCELOT_STAT(RX_PMAC_PAUSE),
	OCELOT_STAT(RX_PMAC_CONTROL),
	OCELOT_STAT(RX_PMAC_LONGS),
	OCELOT_STAT(TX_PMAC_OCTETS),
	OCELOT_STAT(TX_PMAC_UNICAST),
	OCELOT_STAT(TX_PMAC_MULTICAST),
	OCELOT_STAT(TX_PMAC_BROADCAST),
	OCELOT_STAT(TX_PMAC_PAUSE),
	OCELOT_STAT(TX_PMAC_64),
	OCELOT_STAT(TX_PMAC_65_127),
	OCELOT_STAT(TX_PMAC_128_255),
	OCELOT_STAT(TX_PMAC_256_511),
	OCELOT_STAT(TX_PMAC_512_1023),
	OCELOT_STAT(TX_PMAC_1024_1526),
	OCELOT_STAT(TX_PMAC_1527_MAX),
};

static const struct ocelot_stat_layout *
ocelot_get_stats_layout(struct ocelot *ocelot)
{
	if (ocelot->mm_supported)
		return ocelot_mm_stats_layout; // common + MM stats

	return ocelot_stats_layout; // just common stats
}

Then, setting mm_supported =3D true from vsc9959 would be enough, no need
to provide its own stats layout, no need to sort/merge anything.

How does this sound?=
