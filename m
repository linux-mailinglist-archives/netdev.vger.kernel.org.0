Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6ED7453CD7
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 00:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhKPXuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 18:50:51 -0500
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:2574
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229791AbhKPXuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 18:50:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZ7hJTqW0Fxk5V0WmVs0BJnWDKGlbgAaSEtdyGtK780rD3Yg8qVXoI90srcDvkTCuv7tlDVwablHL2m5CewvGLu1z3tQ352djU6htqLFbNvs8fqcz2sQJ7YvIyKOTWKyIwucjgrtUPpWY+Q8zhpld8vCB0MZ+R3TGbKrx4xPxUCHUkZlLP/0UFVbnvq7Rp8RZgOt525pVzsqHlczA8ifdSpkvQyVoaYzvZltwp2RgrsuGIxQ/UxcQUYcft4Bzh2tx7vc8VUKTOux3YgxiSe0llKBQQk+Asb+XrXWn68TAqxwlzY2I50KRNWwFgDoB//gXADoozBxVlHhazb4PLVTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AF9B0YauBuy/f8Seym8HMwzHLZ48pAJGXC+tsGNFP8=;
 b=iCll+GHCxcoibMZhpG55/JjUPwFNyS0ZsFepDdPznGG5yWKwyapbUrcGceT/zdDORdJvI21Yt6sDVAm1pWjzzAg9e49tKfHrgtnqLsHGVn2mfX46sxbELf8gtjCNj32zkbn5As/aR87wmfxYp7IhR1wToffYV4Ak1ePNkvQ9U4TxoZy5qML1j3ggDjoiiz2IWxbdB+rVSq+l2oUGbFdZuVyHxlAyr0D1fPOMdov/hU3I6sQ1waJ5O1EJNjrRyfFe0yv8d8ci6Ag/rxk26JsdLIPiES6Ruf0VXBJLbh55BAYtnuzLG8+dleMo+mwoDlefTd9F76NJ4S7VU6gbR8d4OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AF9B0YauBuy/f8Seym8HMwzHLZ48pAJGXC+tsGNFP8=;
 b=dJKzITPZRpdgHvn3hiLJhY1jAr/upvWl/wxiJoe6YD8tGpyCJwIeN0Qa7Tcnolt7bXVl5hsaz0C6fWNEwu1pRSCIBlcF+eEPDPx2JWUptOt+K0WvrzvvSyZ/5hFOQFaNckRMYgGpr0JSXilOMmiQtpMQ74CYXbVp2gx6n4CZqyc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 23:47:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Tue, 16 Nov 2021
 23:47:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Thread-Topic: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Thread-Index: AQHX2rKEbcpEShKMr0uAL3+1lm3+rawGxRgAgAANOoCAAAEBAA==
Date:   Tue, 16 Nov 2021 23:47:49 +0000
Message-ID: <20211116234748.zf55qtibqapuzral@skbuf>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116225652.nlw3wkktc5c572bv@skbuf>
 <20211116234413.GA14085@DESKTOP-LAINLKC.localdomain>
In-Reply-To: <20211116234413.GA14085@DESKTOP-LAINLKC.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f77ecb3-76a8-47f9-1e3b-08d9a95b7fc1
x-ms-traffictypediagnostic: VI1PR0402MB3615:
x-microsoft-antispam-prvs: <VI1PR0402MB36152D4D9C1B907AFFE1851AE0999@VI1PR0402MB3615.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KIrxytwqQmlWTy0gRC8IMl44kmsr5qxC6TuQL016lVpCZD/34GRgiXptxSEQd6PiG0nIsjV0UOp76omfuI7RAxqcJrL3jUkgqeMFucl/KFoUzecrL2eiIeefvUAGSjeAGO+4H2VfPZcIbrhnpgu9ljMxUlhaRagc2a5FS6OP+hXZBVKofbIGY2+gme/xIKEvYbONdrylSBWRVyN3a8hIR6v4dJstuJ9+4+vG7PL41zpG2ia0Eu7EhePY0KpdwS0FNwC3kZrX4J/BnXmTgkfPdcXO5NSY0KJlDCdfYKg/40HoguNHdBeMriqFdngzhJ8+adJ6nyHo2PwtlaamrrebcvULnOab33UXurK79eiSPwRHfbcxRFiOq/z2/rC4w3eDmB1OcPjTBa2CO17icOMEz1YLhysrQLrg/hp5aAp54FKrSnxw9XJpzVVd4Uk9aWuEa3Kjs6umO9bpf4Ur/otRjPF5R9qzmNEw28dvPhGdhT+iSsbFGHZSpacY6/hXQDFkzG6DPiwXampo2hKMs8VNvDengrYXozUY9qzLmw5vMFiUfmWK+lKZMlbBaXy5zTyEPlzE92U+blnPbeCG7h0YjY/afLuETX7C4S1PnAjtsn3WDEcG36fABrIdE2/bO5GZzFLPd9t4VINe3wHtYvz9R/udWP9zbyjqCKvvQQcq3eqdO9XwsqPN2r4jOlml6YAOtfszipU7j7Cp6TUlJT2XkmHpEvBrdr3TJ3o3WPpHiSFWgVb+PkmYaETytE6US1ghG11mjOD/tDpQXOO4RB9jnyIXTAyOaHIuTeuEIHAZHMA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(44832011)(2906002)(9686003)(6512007)(66476007)(26005)(64756008)(7416002)(71200400001)(54906003)(508600001)(6486002)(316002)(122000001)(83380400001)(1076003)(6506007)(5660300002)(8936002)(38070700005)(38100700002)(6916009)(66946007)(4326008)(76116006)(91956017)(966005)(33716001)(66446008)(86362001)(186003)(8676002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q8+i9bh+N93xrKGTDzT4rG7QNTOHwnMWp1BziKRePhxCiKUD1FAWIvgxXGF2?=
 =?us-ascii?Q?pu1k2ptCqWlc9qZwKXVZLzhBsJVBupPsERcFezHxtoVc7ByAIfy5dJr/SCqi?=
 =?us-ascii?Q?m46FiGqFKwh3dLkbJUbBYTiq8d0aZSQtfGQbbanobgyYcMQ1M5vnw12pLTBO?=
 =?us-ascii?Q?ORZpTHRTnbz7CI4Ss0dq7654heP+xX60E5QJoa38sPpT6PRX2rjyUkvfwOkv?=
 =?us-ascii?Q?K0lVPPfMY6GysAKcUXk41BD9MJneY/XxB+ndNSHGT+5U/gQ9cNqttbVoAUag?=
 =?us-ascii?Q?HyfI4M0rWOFX8Kw2vO0LLCFsZEN3k850n9CXAmTWjl6fB9o0F/mrLtv1Fe2U?=
 =?us-ascii?Q?qCNIQz5tD68CbXngYhK0e2GnHOQfAoIM+4dlpq0NG0Q/LKwE0rErP4Dp3GNd?=
 =?us-ascii?Q?qnBeDxrjdnNBFku9EJm4PtOYKE1g3iAkYMff+oLGoAiE6VN4mNylHxleDRJ4?=
 =?us-ascii?Q?bzl/XRulPuIBOua64q3JGz0mVErM3t0mRZRbiZgC+9P2kr2FwQ9cqSqhS2Rs?=
 =?us-ascii?Q?NnJ9nYDpxz/t+6eeBljUbrfkRNgarEKhTPFFVxkM3cm4UBWaihHAGZPoeSqV?=
 =?us-ascii?Q?W+CkiLDahy6WtAgLtfEJYF2jo1HsGJaSuBuDKuMHH2QdsdwUUcN1NiGsQ04e?=
 =?us-ascii?Q?PxuIPkpKLaZCh9VoU3IYMTo7bw5A8NlkC+gv5Iis4P7t6QB5w6BCKdcYMVMF?=
 =?us-ascii?Q?RLd+4XrkcUtz7/e7C5PRrAYIUv/MPyX5dTbUF2NER35W3pwVOvmj8QCBHOrU?=
 =?us-ascii?Q?YJ4S/9BCYmwHOfu9lKXDm+U0QDz4LJu5MiLb3IRZmV5kDb4ZeqL9NYIo94sq?=
 =?us-ascii?Q?hgn+hhm2gKefO120vak532/AWVG2lBcKjte3MkhzYdxvvpiS0IVTw2M/8bVD?=
 =?us-ascii?Q?bTk05ErxO8ydjSniT2yMma5GgD1oAc3PIbF1fOMuz3xubDwMKleOz9/9Wu3Q?=
 =?us-ascii?Q?65spFcAtCZIqvv9K6p0sIRTcqiPCvBXARJc5geOchRYsbNulR5zLaVaBEL8H?=
 =?us-ascii?Q?TKoMoSCX7yFTW8+q1HH9PDir37S2tMPUaa1GhssSfa4qqSNSxBjJBffSbv8S?=
 =?us-ascii?Q?GyDJhuBUvgzwUfTXlDI3MSZHp8eN+L8v3RjmdUR5mvor5pFSjNVMZvbG4R6q?=
 =?us-ascii?Q?dpSbKJTQZxhFL78Vm88/n4tlkM4St7oDtJquxnRhTiapJBhKJKwMh/iwkglZ?=
 =?us-ascii?Q?w+HZ6oVwL6YSxK+Gb0mdyWpDrhAknjY3Lh286EepQU81HQ6FMXs+MPVt4Cy0?=
 =?us-ascii?Q?MQm5UFfrz96TE+hfglYmhV2ztJKgASHImPxBPut/k2brwOXU1TqM3kMrENeZ?=
 =?us-ascii?Q?m1ppvMexj9V9NQK1cxJiq6nTSkY4Ix9lFAHiHwTMU5fRhfrpalYLSw6v/UEX?=
 =?us-ascii?Q?CJK29Peuy3tjHblXWL/TL20VH8oasxc1GEZQP6ZuI0aJMs+5R9GrljTeZWUO?=
 =?us-ascii?Q?oOCgFVFychp1JjAx6XMCK2agFhIEy5ueLzA9EUScdbdst+L2o9EJfXlpBXPt?=
 =?us-ascii?Q?cGmdN8JKwL+tJBtB7MsjJPhWo5V3eCn4oYHMOMgCmjMxtsUZe71herNRuFAn?=
 =?us-ascii?Q?57gV2B/jcENJSFAjpd1oA2IuyA4oTK9vuV+K85E/uiY+o3oI/+oApFL4Qwfl?=
 =?us-ascii?Q?6dspx7TllHPoYUIZcO4Zads=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5690D19A7FF76F47919EDB805614D441@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f77ecb3-76a8-47f9-1e3b-08d9a95b7fc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 23:47:49.8937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8sCNHDouOV589gFonuai5XWrr9+iXUzGpnC6tGRiDYWEJQ8ctbAax1y9w1Enf9eNmiDZqIIC19IoFsWMySxtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 03:44:13PM -0800, Colin Foster wrote:
> On Tue, Nov 16, 2021 at 10:56:54PM +0000, Vladimir Oltean wrote:
> > On Mon, Nov 15, 2021 at 10:23:05PM -0800, Colin Foster wrote:
> > > My apologies for this next RFC taking so long. Life got in the way.
> > >=20
> > > The patch set in general is to add support for the VSC7511, VSC7512,
> > > VSC7513 and VSC7514 devices controlled over SPI. The driver is
> > > relatively functional for the internal phy ports (0-3) on the VSC7512=
.
> > > As I'll discuss, it is not yet functional for other ports yet.
> > >=20
> > >=20
> > > I still think there are enough updates to bounce by the community
> > > in case I'm terribly off base or doomed to chase my tail.
> >=20
> > I wanted to do some regression-testing with this patch set on the
> > Seville switch, but up until now I've been trying to actually make it
> > compile. See the changes required for that. Note that "can compile"
> > doesn't mean "can compile without warnings". Please check the build
> > reports on each individual patch on Patchwork and make sure the next
> > submission is warning-free. Note that there's a considerable amount of
> > drivers to build-test in both on and off configurations.
> > https://patchwork.kernel.org/project/netdevbpf/patch/20211116062328.194=
9151-21-colin.foster@in-advantage.com/
>=20
> I'm very embarrassed. I scrambled at the end to try to clean things up
> and didn't run enough tests. Sorry about that!

Don't worry, just make a note of one more thing to check next time.
My T1040RDB doesn't seem to want to boot right now, I don't know what's
up with it. My regression testing might be delayed for a little bit,
sorry for that.=
