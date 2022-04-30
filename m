Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C505160B0
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 23:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245645AbiD3WAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 18:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245553AbiD3WAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 18:00:18 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2055.outbound.protection.outlook.com [40.107.104.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6476D527F6;
        Sat, 30 Apr 2022 14:56:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOGBSYBNvfsOOG/r6FkWsoYjiWgRzl7MI1vssfckOZ0tPMpsuPzMq43PUjEfFFOlA2BAYZlBNId/YBoGQt009RO1XJZMLjWNkivyMnMZ/biExRgZsSg3wLYdD+UjeWxm49TG5Ui043g5mlN0+vr1xl4XSKa1hDw9J2PFGyxsQEsGf/1AJhSi3rd5s4coW2wSxUxdrIJZd/HGMOqj9Du2lff6tmsJfVVuUSq8js+cu/DXam7eDtUKfpWMHV55TFUOMEADyEDy0O0TTviO/X+g8hZiRPafnpUiCiPtuRJkcs5Bd+N/uYxPWnfDVIkb55CBRfVTRMeiWNqu5+m3J375dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYe2g6hTgqn8PArETQ1vKhZSEn3LPnlsPNt8emul5DU=;
 b=Y0HS4VFwqoyHuJkeVwHjV2t/PmqyOJVfvYkYjNOJvY3yqjGhImgDuB0aaOryzDbgZrqr/Hgv0fNfPFFwFTvg0zsmCrzUd4pMPZbAw/27u5TxIo1Ir0itQhjAyhEaRW8/hk6kXfhGYjN4JbOaRhmjX8HWSb2IwQmPqMIJKWRz0nhcUX6CgnEcPfOfONt3fpFBXBPJfN2cFQS4N5tAJKXIOCLfUlEOVkSWXY4agaaG6IsiOa1olaJjLrUdNTHt9ZME8b2YaJg0HRmwnGfhhwJPWXqFVeA0iPP4bnYOBdyUtM3Rl5gx/QLM2X1ZxX00CjGlDjMEwfTrUjhZvAd/xmJtdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYe2g6hTgqn8PArETQ1vKhZSEn3LPnlsPNt8emul5DU=;
 b=AqtXe+sW30SKNy36gQz+zZJTEGotCjFSRyAkYGB67J9qmMxVEqae5JinycXvqUjGFKJLIvC/wDD1R7wGIr9/S1gkULRCgarl7ml/bl3Gld2AFqjP4s3JVmNEqELS5yEh8+PcW9UJ5AatCKzu4OncYQOMQkqQta7jgYQzqB/rBr8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5430.eurprd04.prod.outlook.com (2603:10a6:20b:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Sat, 30 Apr
 2022 21:56:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.014; Sat, 30 Apr 2022
 21:56:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Thread-Topic: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Thread-Index: AQHYXCE0wfZ6v7cjxEOPYespSpyp0K0Ig9+AgAAyBwCAAEw8gA==
Date:   Sat, 30 Apr 2022 21:56:52 +0000
Message-ID: <20220430215651.4lk66lwnzslqtgtb@skbuf>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
 <20220429233049.3726791-3-colin.foster@in-advantage.com>
 <20220430142457.7l2towhbptdvrfje@skbuf> <20220430172400.GA3846867@euler>
In-Reply-To: <20220430172400.GA3846867@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f54f7ae-4818-4df6-4433-08da2af455c2
x-ms-traffictypediagnostic: AM6PR04MB5430:EE_
x-microsoft-antispam-prvs: <AM6PR04MB543094014472C77A86020CB6E0FF9@AM6PR04MB5430.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X/npOr8kLyMC3C3NYqdwoUGn8VWE3cE188Ob+Vu3lfGMfq62PQ2wtKSQc5kCkT4v/ILVL/ii/qhh43V6b5zhTLG4c/AWkPvQK4hj7gjGS1EF4NEDG0iox7pBu6UOIPFpmCKZSP4B8Rv25+O1AI+DZYgdgELHK9EnhL4/DlJ0R8ySPJZISvxLaXzGoqZests7XOZImrbSnAhRxjtmmS6iw/X+jgRrodzpg7LvnJ8rpuTkgAVEB87AuqLl5P+5NkrfllgvfSb70zDK15DW3cBJslSuim/euYlDxlLdoO3BX4D2Eltmog0kPuBrZtVZQgWNQytv00BDxX/GgjOkVP0ZjCdKqYSWxD3fI8iz1qc93+Tj7H7k4CyIGa61SxtauX+MaloDLu4if0qJWizDTV85pcqpHFSSEF5ajlCYfbnbr8RQ0eiber/xW0AEX3PP3wWa0ADkGKaKUJCefHS9GQpk6lPCbAQaOeIRxqUjA1cEtO72YvGtpiKyTmsnIwrGda4Lwr4KkmLUdil1AYXLUUHpjYe4xXETGK9qFXled+Y5aZh1R6FfBacfbZUcOioydP4Ikeh/USt7qSVmlHWZCuqFe/cmu2XV0XJjSopZoim/Ih72yYntkdM5ap3HDPkIHLObP/Gu8Ja4Ih2VydEep09JDbc4Y5Hxm5gwcNF1g9Un1Y67eROf1wtlva5GYiZ11aETA8GcM7W7OVH9Lou79yMiE9pQqRXWMFYYsh5G2xtHvD39wMhPCDxH296lt3nHoCqhDSlpCYJNRZ7I+gZt+I+KNtCui9gEMIUpLrMkQT2AqY/IPei9u9kV/e0rW5jHYeF50Aa7dUKkf6IEULYvEd/PWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(54906003)(6916009)(44832011)(6486002)(966005)(66446008)(5660300002)(7416002)(83380400001)(316002)(66476007)(91956017)(4326008)(8676002)(64756008)(76116006)(66946007)(33716001)(8936002)(71200400001)(86362001)(66556008)(6512007)(9686003)(38100700002)(1076003)(26005)(38070700005)(186003)(2906002)(508600001)(122000001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u+CBF+77Imamp1SPmZftwNMPHI2XBM494jRJlV8d6hBBl6FRRZrZWDDocA32?=
 =?us-ascii?Q?JR/WzoN9bsF3GoFz+UkRe/Nl/SjdCws2c6Agycc2MDDy/31yTX0khH6qGLYh?=
 =?us-ascii?Q?w4dcbyQiSqfgBklz5tzEQ3KsI+qbscUeldbcT24Bn9Y+RiyWtfsuYXpruhzm?=
 =?us-ascii?Q?15P/vmAR99mBLjZnJNVZ6nmr35vmji+tXtu129kz/Xis2F4XAN1NWN0/A9SI?=
 =?us-ascii?Q?trTKL9ZLtyrWzppKatd9ZTzMvJZnxxwd27fgsoCLTg06Op8u66DxJT0Yc/Da?=
 =?us-ascii?Q?SVxGpWlbUOn1gDA7c7K6aLcFz0+f0YgkOIkYyShGvuMD9DHY8f/goMDjQV2P?=
 =?us-ascii?Q?keQOrL9ozXK6C2V/MEJGW8sUmW51/+mlU0iW0pKPanLZcKF1gwbaGJJalVJB?=
 =?us-ascii?Q?dfWmgN5+14Do4NTDgcVEoHg9NKeFdCSQdJ1WQw83PRwyVwpQzFi+5QacgyfQ?=
 =?us-ascii?Q?Ee9Eo9tBXDpZ2OuhOSOXT+WklDZoVOWJyii2oBzlKWY6GD+GLSn73w2TTWmO?=
 =?us-ascii?Q?4tMCvE0pkPsMtZYdMk1zjBesD4SSmvoCVX9/fESIMVdygn56p8mBdYZ2T4ZC?=
 =?us-ascii?Q?WOBla8ZSF7hVP2C6vm9tBCgHrBvcudpJEUPT/V1vUEtoLDROAfT55GaqdmUT?=
 =?us-ascii?Q?9dCVPJQTN/S+Z1X43Ko8YfzEyMySqsboM+8FGXSZ8vGiWPDShr5fKQh34PtW?=
 =?us-ascii?Q?1nEJsveHk9RDAmhasjh9xOkYjyqMBZ84c8wU/MMMGKEMIoOHqHrMXW6LpoBO?=
 =?us-ascii?Q?nEtZK8HK8DPnuH0scnMkKgAeYhQ7nh3jZaFDC/e4RqqSYOSTtAqwNoz8XrLW?=
 =?us-ascii?Q?9gthHc8NAf31spzFdLOomTBteQp5e0c57XrewK2O0gQyCm3hg85tIvGwmhr+?=
 =?us-ascii?Q?9kScngnPiy8ZJ+FH4qrYjIajf6UujGIO6gTt6xDb342eRJavmCrr9yppRV6j?=
 =?us-ascii?Q?v8zitECu0aKz3o9VllcWzjcD+1gcPxEwvYg+aeaIRxroMmVxju1nNc2T9SWH?=
 =?us-ascii?Q?58gRLjs1e3b9GjCAWm8pzyHLXMcpxLT/xN6wZRgU9Gapr/kVigCN5e1b28Y0?=
 =?us-ascii?Q?yS904NZQXZoVH2jimMy8yaDZzy6i8Y4t/po+ftx0K5BcbHBSjRyZQXIqR2lr?=
 =?us-ascii?Q?f7GB5S4gSqS/SSOKY6hSmmCYJmLF8NpXHvTWWLXD4ye5IEZMJlOF26iiOTPy?=
 =?us-ascii?Q?LvyP+dOgxArnMbr0rkIDNDy0odARNlXNTp2tTyZjOnjWXSwzJqg0H0EtW/SI?=
 =?us-ascii?Q?pSLmP3dvHyvnGaCuIrHmLqf5wofpD9M4+uAM3xdwSQSNtyWopqNDoV67k4gP?=
 =?us-ascii?Q?DGxjDsCUb+oT2+LIoR4zFd+zvxJ4dguNNgDKgQZAXQo5QnWShbqAB36DLliT?=
 =?us-ascii?Q?ScqypJRQpTN1KrAClRG/3v+o+7hTe6Fdhi05IeyJ7W1wQT/C3xCYiGcMiuBG?=
 =?us-ascii?Q?A8yBDWlYd/AJBngo5I31157OyInjH7m+kNCyC3UCAxbX0xsTwafoHoDGD+Ia?=
 =?us-ascii?Q?4RgtqdyjoYZ8tAdD/+FvPB2aq/C0ehaDZBc/vY12NEv6+8pyajb7hnP7y/fE?=
 =?us-ascii?Q?2t9jpW28FeiML31Tq1aVyxYB5yqkp6fhqQhU6veNK/AYdU+6DbrALqlhBoHT?=
 =?us-ascii?Q?6AbUzs9QYU6M2fZaMi7IJ1HAN0gnIrqeHA89vyr+K93RcHYar9V1HomTZJMG?=
 =?us-ascii?Q?it1d2u7cVDIQD1kYo0GCxhaM/fv7w0ijJHICvOKjSsFv7v73eetwBMiF4AkO?=
 =?us-ascii?Q?LCg5fijfkB9Q7eK2X5cdMtZ+J6zLwLU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <58194CFABC336A42AA300C9C1EF5A9C6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f54f7ae-4818-4df6-4433-08da2af455c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2022 21:56:52.5371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEuAB/6qa+gV+uGFR79zCXTC8tSQHx7iM2R7uKBolI5sI/fE5AP+kDsYFCcYxWYWH+aLZw+eOrbh5S9t/yuBvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5430
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 10:24:00AM -0700, Colin Foster wrote:
> Hi Vladimir,
>=20
> On Sat, Apr 30, 2022 at 02:24:57PM +0000, Vladimir Oltean wrote:
> > Hi Colin,
> >=20
> > On Fri, Apr 29, 2022 at 04:30:49PM -0700, Colin Foster wrote:
> > > Each instance of an ocelot struct has the ocelot_vcap_props structure=
 being
> > > referenced. During initialization (ocelot_init), these vcap_props are
> > > detected and the structure contents are modified.
> > >=20
> > > In the case of the standard ocelot driver, there will probably only b=
e one
> > > instance of struct ocelot, since it is part of the chip.
> > >=20
> > > For the Felix driver, there could be multiple instances of struct oce=
lot.
> > > In that scenario, the second time ocelot_init would get called, it wo=
uld
> > > corrupt what had been done in the first call because they both refere=
nce
> > > *ocelot->vcap. Both of these instances were assigned the same memory
> > > location.
> > >=20
> > > Move this vcap_props memory to within struct ocelot, so that each ins=
tance
> > > can modify the structure to their heart's content without corrupting =
other
> > > instances.
> > >=20
> > > Fixes: 2096805497e2b ("net: mscc: ocelot: automatically detect VCAP
> > > constants")
> > >=20
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> >=20
> > To prove an issue, you must come with an example of two switches which
> > share the same struct vcap_props, but contain different VCAP constants
> > in the hardware registers. Otherwise, what you call "corruption" is jus=
t
> > "overwriting with the same values".
> >=20
> > I would say that by definition, if two such switches have different VCA=
P
> > constants, they have different vcap_props structures, and if they have
> > the same vcap_props structure, they have the same VCAP constants.
> >=20
> > Therefore, even in a multi-switch environment, a second call to
> > ocelot_vcap_detect_constants() would overwrite the vcap->entry_width,
> > vcap->tg_width, vcap->sw_count, vcap->entry_count, vcap->action_count,
> > vcap->action_width, vcap->counter_words, vcap->counter_width with the
> > exact same values.
> >=20
> > I do not see the point in duplicating struct vcap_props per ocelot
> > instance.
> >=20
> > I assume you are noticing some problems with VSC7512? What are they?
>=20
> I'm not seeing issues, no. I was looking to implement the shared
> ocelot_vcap struct between the 7514 and (in-development 7512. In doing
> so I came across this realization that these per-file structures could
> be referenced multiple times, which was the point of this patch. If the
> structure were simply a const configuration there would be no issue, but
> since it is half const and half runtime populated it got more complicated=
.
>=20
> (that is likely why I didn't make it shared initially... which feels
> like ages ago at this point)
>=20
> Whether or not hardware exists that could be affected by this corner
> case I don't know.

VSC7512 documentation at the following link, VCAP constants are laid out
in tables 72-74 starting with page 112:
https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10489.pdf

VSC7514 documentation at the following link, VCAP constants are laid out
in tables 71-73 starting with page 111:
https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf

As you can see, they are identical. Coincidence? I think not. After all,
they are from the same generation and have the same port count.
So even if the new vsc7512 driver reuses the vsc7514 structure for VCAP
properties, and is instantiated in a system where a vsc7514 switch is
also instantiated, I claim that nothing bad will happen. Are you
claiming otherwise? What is that bad thing, exactly?

>=20
> > Note that since VSC7512 isn't currently supported by the kernel, even a
> > theoretical corruption issue doesn't qualify as a bug, since there is n=
o
> > way to reproduce it. All the Microchip switches supported by the kernel
> > are internal to an SoC, are single switches, and they have different
> > vcap_props structures.
>=20
> I see. So I do have a misunderstanding in the process.
>=20
> I shouldn't have submitted this to net, because it isn't an actual "bug"
> I observed. Instead it was a potential issue with existing code, and
> could have affected certain hardware configurations. How should I have
> sent this out? (RFC? net-next? separate conversation discussing the
> validity?)

I can't answer how you should have sent out this patch, since I don't
yet understand what is gained by making the change.

> Back to this patch in particular:
>=20
> You're saying there's no need to duplicate the vcap_props structure
> array per ocelot instance. Understood. Would it be an improvement to
> split up vcap into a const configuration section (one per hardware
> layout) and a detected set? Or would you have any other suggestion?

Maybe, although I assume the only reason why you're proposing that is
that you want to then proceed and make the detected properties unique
per switch, which again would increase the memory footprint of the
driver for a reason I am not following.

I suppose there's also the option of leaving code that isn't broken
alone?

> And, of course, I can drag this along with my 7512 patch set for now,

Why?

> or try to get this in now. This one feels like it is worth keeping
> separate...
>=20
> And thanks as always for your feedback!=
