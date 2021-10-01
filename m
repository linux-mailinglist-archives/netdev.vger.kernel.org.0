Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF61141F81E
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 01:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhJAXS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 19:18:59 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:63224
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230009AbhJAXSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 19:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeiHH55wtq51tDRXqTtzQHHq4nLrXv/SHXrJ2YKSKzQazDAtL6wZsB/1pJnjxUAyH3lkqghrWBvCGhifytWPDLacrTSpBN6WR2pOyDG+wKA/B9sHytwxrxdgTDd/8M+WSlgFw6EnRzzn52PC5n23q17J6n0QCMScI9zcVDKcNQo2CY9p9N2tMObAi7MRr/BIp+s+K74PFa5eaXQ1OohhnKp8NmzlFqqkbIWHpON6/wWe/TdChUSBasvgw5v49hnMlt1FH60Pre0Rn1HBpKvV0Rh5Dd4+E/xdSQHdbAKKsG3yVX4mM+3gSyXxjo7PgxcdbbXWaER3Z46zwxSo2ZjalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRrE2gftkxDZkUBNWDMuuDeA8BQ+ZLrST2dhthHpaNU=;
 b=jp3X2VoXuZ9k5CGh66zusF9BgJLGTwFXjVs6pVMq3EE4o87rSSJB4b4epg/C69rR9Et/zCtvpcVEEcFlAnVZdB4MgVgAbEygCnmCIqYMcPFSURImCEkQryQmRJ6U0Crmlh9sg8jDNyX6b8TRNxrn4eeB4u7fCWZIut84JC5cBjl3ClCxGkRZi4jIzXbqSiMtQR5ec4v5MF2PyGKWdh/uLQOhN9nW+xuxjzRbyp3CyZB3wYUtrIhXmVdwJubPnyq4Wqt2GGvSaHpZdJWa7cJco2U0IeyHvFGULiHF8DqwpJpgDh4PGHR8Tx2M24YTbVz/uXiulKnc08vkNmiSnjH5bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRrE2gftkxDZkUBNWDMuuDeA8BQ+ZLrST2dhthHpaNU=;
 b=CCB+UZNPABrZOuVePqchP5cKJEh9ynrdhRT+FVlo/ASbF6e0T421HL2cHGt7KV3zzT8zCESqIhtA/hHPKTtVnSr78mCKSscblDYKVEN8WWf1odfTPjRwjbwxJG8qwoBkSRl/KOZFo/4kHuxyBMSZNf0iQ7l/dl+dGraPAVUqg5w=
Received: from AM6PR04MB5128.eurprd04.prod.outlook.com (2603:10a6:20b:5::16)
 by AM6PR04MB6343.eurprd04.prod.outlook.com (2603:10a6:20b:fd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 23:17:08 +0000
Received: from AM6PR04MB5128.eurprd04.prod.outlook.com
 ([fe80::d826:aa72:3d7b:6e11]) by AM6PR04MB5128.eurprd04.prod.outlook.com
 ([fe80::d826:aa72:3d7b:6e11%5]) with mapi id 15.20.4544.025; Fri, 1 Oct 2021
 23:17:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        Po Liu <po.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Topic: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Index: AQHXtc/NwIV3BgN/R0a4xHtuLk/jJqu+tuCAgAAJ3YCAAAOmAIAABOMA
Date:   Fri, 1 Oct 2021 23:17:07 +0000
Message-ID: <20211001231706.szeo66plekzwszci@skbuf>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
 <20211001151115.5f583f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211001224633.u7ylsyy4mpl5kmmo@skbuf>
 <20211001155936.48eec95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211001155936.48eec95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebc01d51-ccc2-41c2-2904-08d9853196e4
x-ms-traffictypediagnostic: AM6PR04MB6343:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB634385F6491C1AB49DE84A62E0AB9@AM6PR04MB6343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2qVqD0u34xWoRyVffO4yJTUPN6CuXKkGd41P43C9vow+jLapWN3yS6r6387UHrXsedn6xyxTT4iCL39fAT+Qloh/FFDAvzg9/V+d6A5PmEz3lEiu03frz7db4OYxvmakXcttWQdSediDhJV1EakeFNsEPq7RX7hHCVtIa8NHSkhyHneRWjtma8Ixg9skBHrux7gscdaJeo22W9gXzNesRhZFwUT0/39Xyx0rKCXpXjXUvgRtk3K9mbzJEawJbsPOwwHsf42iR2Ez90fBuvFzHXVcsVTKP7oSfpQlfJtJnyovEB5+/eo8vDHrV8Jecs/yMyufhNHZtdg82V/y5URIRY06Rrs77noiICIZXnbL7wmKeymiEaN4XfOSD/Hig8SPboku0BkU8x2rUp3o5Uldm5nMtBy33hGoZ0RcyYv+kFUCgMuwsKwbUt1XFPf70etthtv0zwx1mhZO5XbIcdnFYKqRHOCsZG2+VnAvc3R9SBdVQ5e7JXf/j9/1Ya/5LAfAmHZdjVpYicCFvbFDjSQFM25e5CDCc3kKvarkaecp1gFLZhiZyDHFCgeg5XgAL9SGCRhjgbEK/LqJxb4pusSTJZDRNi9dWVBFqRevaZwmQIr5le7eVTSOdI5/Nj0t6PTXSzHZ33+CrNlM1WN3FlUyILHb5l2q4b2LvPNs6KHsDTVrE/A28GYO69VnFS55E5Yn+QMpCAO5jiblclb7RHNyag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5128.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(186003)(8676002)(71200400001)(5660300002)(508600001)(1076003)(9686003)(6512007)(83380400001)(44832011)(316002)(38070700005)(7416002)(6486002)(6916009)(86362001)(8936002)(66446008)(66556008)(66476007)(2906002)(33716001)(122000001)(38100700002)(76116006)(54906003)(91956017)(26005)(4326008)(66946007)(6506007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ctaj30RceCZfGQM4wGNPh2t8mDgX3KEGF3D8gqm1TVaHq962u0XaGo9J8iWX?=
 =?us-ascii?Q?i0BMffVxStVu9XdeQZcnz/mUL2zy4N+lryjHnlGT40CWT7HXvb5AVyPUCWzW?=
 =?us-ascii?Q?L4lIPjN96GM/nU2s+DQBYheijob/RrJ6dWcXhjmEYD1jE6Liy4viN+DUZDPp?=
 =?us-ascii?Q?2w0qOTBAaKz31nXXhVi5FnUodbPZn8f4sHLTS3wgoP+x451/0milVlSnsOoR?=
 =?us-ascii?Q?sgWdKIQ9O3qY/YBrhB++eOs4f+uQTzMN5WZrg697WTu6hBh6uXd9QjiqGwxX?=
 =?us-ascii?Q?v84SBU/q4RWxJSv9bCPntL4fkgnULlQg0RT2KpIMXxbnKloEK1UXUztbcPnV?=
 =?us-ascii?Q?KApjYPpHwVGOBzLbZ4cXtApliFN4BScyjQyZeGevjJ4rWitzPjs04LhEsyhf?=
 =?us-ascii?Q?YwXo50DMvEpBng8gSA/UBOyZ/5pZMORVAil5VTgSbULdHNDsc119DzeeC6Fc?=
 =?us-ascii?Q?yxJEtusOlxJ8NNKB5Ec/gOVxy0PNdiRqiAC7XkicPHomysy57/OY3bg0MHlK?=
 =?us-ascii?Q?IETEcnUSFOakbuqpSwdVkki2CbZ9mWgilHrLEMZgGCqeo8Y04gs28iIG9Glc?=
 =?us-ascii?Q?Wtzm06JHYKb1sOwdXXI1BUTYXVdiCDAmVhfgFzLmzCsvO7jnYVyn6Z+Md4hH?=
 =?us-ascii?Q?xARJ3no6E22wzpnr3+UYy0NJuSUiSPixBx9Z0/MLDJd94ko2Mt6w4Sh7Z35p?=
 =?us-ascii?Q?iCCuyQ8RNwGu13gVBkj6DAu1Pfi910BzMSaOcnCvA/QnAQWA2RJpupBkFqDq?=
 =?us-ascii?Q?lwZ++12hlmVFYcjbrjeTFKgf2IxWBMSqTfOkIHu6b4+nFKP9C/4Ox4QUpprk?=
 =?us-ascii?Q?Al+J5THoLtGZjWp837UuRq2W93WFEZdoWkryU++dvrOVEONoCvX0m+OFfDfU?=
 =?us-ascii?Q?spPHwWkLrJzbIz05W4e/1tBMW1OPO6CHVBkSSTYT2EGPy4MS5sx0ez1jk2N6?=
 =?us-ascii?Q?tsmz3ZwnhKZ2TGfwcnn4Ft5H0ixrxD0lX8cNWB0d55170fR2gtcKP2rHeD6p?=
 =?us-ascii?Q?N42Hwa3y+L+Yh3VGmU6h0wSos4Ez7GwuxJud4NKgr4CbvvjlH4vobI+gpFWN?=
 =?us-ascii?Q?IdFBBVL9R7MpmHZjwKM4Krli8hwAYnkvQO5Tl66+B3Gk6l9eiK4BgkgtEsGV?=
 =?us-ascii?Q?TtPplztFiSTBmPdkHr+2RmVcQVVr9zdZmEXDSae+6pOl/wooeNq5hJvE4cgh?=
 =?us-ascii?Q?UilPTzq5+D75BhbLHVLSYMTJ3fECD34+iygCyp8SEkoYH4UaGoLcEE1fgpW1?=
 =?us-ascii?Q?ipjvBuppv9oP1isV9IzYYQhePOKEpj9wr7k7JRykcAZ6wePEQG28Psx+aHs2?=
 =?us-ascii?Q?2l35XpKLfHwCItiKnlFoZaHx41pqy+/WH7nYor9f7Uo6Iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB617D2C15B4734284690203916F115E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5128.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc01d51-ccc2-41c2-2904-08d9853196e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2021 23:17:07.9323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JtyvIK53z+yGzVhvJa5HJQqjLNenC7JhhmpHf7bq8GzmD3ZllC4nRibIToxcUJe6ADQZlXRGtlkz9intmK+fkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 03:59:36PM -0700, Jakub Kicinski wrote:
> On Fri, 1 Oct 2021 22:46:34 +0000 Vladimir Oltean wrote:
> > On Fri, Oct 01, 2021 at 03:11:15PM -0700, Jakub Kicinski wrote:
> > > On Thu, 30 Sep 2021 15:59:40 +0800 Xiaoliang Yang wrote: =20
> > > > VSC9959 hardware supports Per-Stream Filtering and Policing(PSFP).
> > > > This patch series add PSFP support on tc flower offload of ocelot
> > > > driver. Use chain 30000 to distinguish PSFP from VCAP blocks. Add g=
ate
> > > > and police set to support PSFP in VSC9959 driver. =20
> > >
> > > Vladimir, any comments? =20
> >=20
> > Sorry, I was intending to try out the patches and get an overall feel
> > from there, but I had an incredibly busy week and simply didn't have ti=
me.
> > If it's okay to wait a bit more I will do that tomorrow.
>=20
> Take your time, I'll mark it as Deferred for now.

Thank you.

> Maybe I shouldn't comment based on the snippets of understanding but
> "steal some FDB entries" would be my first reaction.

No, it's absolutely reasonable. I feel like it's also going to be your
second reaction, and third, and...

The thing is, if we depend on the bridge driver's state only for this
snowflake piece of hardware, user experience is going to absolutely suck.
Having a selftest inside the kernel would be the litmus test we need for
deciding whether the way we expose the feature is sane or not.
The kernel should abstract the hardware and its quirks and provide a
standardized and abstract interface, that's literally its job. If you
tell me your hardware needs special massaging in this or that way, I'm
better off just using a random SDK.

> Xiaoliang said:
>=20
> 	The PSFP gate and police action are set on ingress port, and
> 	"tc-filter" has no parameter to set the forward port for the
> 	filtered stream.
>=20
> which seems to undersell TC.

I know, right? That's the loop we can't get out of, TSN is still pretty
much in its infancy, and with pre-standard hardware it's really difficult
to create software models that stand the test of time.
I've seen other hardware implementations for PSFP and they do use TCAM
and are strictly decoupled from the bridging service. Microchip say that
their newer hardware generations are also thought out this way. So while
yes, Ocelot is driving me crazy for special-casing the NULL stream
identification function and implementing it using bridge FDB entries
(because those types of flows only match on MAC DA and VLAN ID, somebody
thought "oh, I know something that can already do that!"). That is
definitely not what TSN streams in the general sense are about, and I do
feel that classifier-action pairs in TC are really the right software
model overall, from an application/user point of view.=
