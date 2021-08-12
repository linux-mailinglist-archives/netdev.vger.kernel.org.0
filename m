Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698D83EA862
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 18:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhHLQRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 12:17:18 -0400
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:34944
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229728AbhHLQRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 12:17:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTlkFvFueO8gwSZpdKZKEtSNR2d2lTPMhfc8XFMO7lM8B4RdFfBPFCMyLk/JrCOzvMriqh90Tizw4lVm8ki8UOMVAenbQB9ylVseqJBhszJnr/fVydp0Iq/LP4D+e2Hjxqt3whLbTEyGNCx9WuICmrqM3BadhcyqKSYFvr8RoTrfpaNc+dhghSzLHKN9n1R5PTPCU4gLa8qW7Eit3yZyN8symfoGj2AebL0wvTQEYZMzHlQpnoweNphXBdtkM3ROGbi+nezBEsk2swT3BfbxdmwzdqSCBTk5D3IBwct7BTtY71WPqglua0HHW0oZz9B+L2vOWKOma0SIRFb7MXR5zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxpogszB+1AGAXbk58TlY+qlEvO/RVaWQI4OyqAepKU=;
 b=ZAZbKRljWywIhjx1lY4yyaVUN0WgfKpKwEMPsMRVUTM0rEeQdIlhQjjNAQIROSgl9YsbKyD1TU6XA0teSEpSLYTs1Y6h6m8AwmuRVQG7iqCNEJLpCjVBQC4Tj1E8TIHKKvLLZX8ELdeJNK/3H7B9wxtzIkW7KTaHcuLyhgOq8435s0RnKJxUFk6ffE0LRjli0YNWJ8GpqsZq42idqjMgB5LXZrRMGh5GsLghPeifSxs/oCCQPWIloJu16zava8vHtePW4ZCBe7DzKnKOUh70ikJbJ9Cm925aMsPiaoHRMesKIIkONTTnWWPvCOXYU0Bct6VDdK0lHc59EWCnAAIFwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxpogszB+1AGAXbk58TlY+qlEvO/RVaWQI4OyqAepKU=;
 b=m5/ptso4Ps2EVRaZN0iifoSLd7oH7fkBzCkzugk4dX7cMatGOKFmcLYDy8qDSJWoGgLjBZqnirisFldgLOf1nGe6zTFaHnJtYju5GqqR7yv1m8YwIcaWPXr8awPuQuYpyStRS1aiKabcKvFl/ukwuGLDR6EPGdg8PPWOgADdRLo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Thu, 12 Aug
 2021 16:16:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 16:16:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [RFC PATCH net-next] net: bridge: switchdev: expose the port
 hwdom as a netlink attribute
Thread-Topic: [RFC PATCH net-next] net: bridge: switchdev: expose the port
 hwdom as a netlink attribute
Thread-Index: AQHXj3QDbXaslFq0Uku6QIcW7zUvjatwAGKAgAALnAA=
Date:   Thu, 12 Aug 2021 16:16:48 +0000
Message-ID: <20210812161648.ncxtaftsoq5txnui@skbuf>
References: <20210812121703.3461228-1-vladimir.oltean@nxp.com>
 <YRU/s7Zfl67FhI7+@shredder>
In-Reply-To: <YRU/s7Zfl67FhI7+@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 129cbc79-b39b-4894-17d4-08d95dac9681
x-ms-traffictypediagnostic: VI1PR04MB3968:
x-microsoft-antispam-prvs: <VI1PR04MB39688B1CF815701EB7038E83E0F99@VI1PR04MB3968.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 65DYVg+5FBlJKpW67hnT9BFcTxXYlGU6uibqXdyLRVGpYB5h4oc/0ch/rWYSxV0voB3EokYhNnfty1CWd9U8PMsNLKKx9ctk+ctahiPAPIqjL5NEqR8fspG3oiCewXwUZtnUSa3nqaqzhdfg7jL3KjfQojZr4Z6qDt5EYFsQA6SIkYadgIsgGpnl/qwzszg7uwAB/hEdujwEKB4h+vpZD4p7mOZ8J9uod2IaINoCkJZSzG04DvSdMJGDe0UPJ/2EhAtKkijIqQ5uYKK9q0986j+hwKOJXz/wgOpDjk1j4JGyfnE1sYVRFpT/ay1f9eEj7WfRltIrY7ozx/1iYH8jXNH0pAxfetpMZl8H+EsSL2NVdB53+6dfRXFy5jbiaxVpP8SzynSorIglwjGNm4D488Cfet1svBhomzNhpGmOwEwLN+VFoMqpRr5H2Dkc99ZWzrVAGQfUlmy+f4qwlO/ptEPTjXzTju5cdBZsv+8MYvB7t8CG4/qtkSL4pfM2zslxD0GGQVspemn+dv0gTnl66ynci/gD+eIdWNO+7blHvkZWYxDw8JNiqZL0C9y3bC/22+ZPiJTNj1Um+ACeePaw9ClF1OJ1DFSxb0nFY50DMZ1CdK8zomRp8QAc62VrfJ4U4mSzT+cmmk3ouwfMv4sH4B2PbhkZxWGjJMcMTIvZo2rm0g00pVunZQAzUbUTzehmwo622RDdJq9QfVYzkMSmMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39850400004)(396003)(136003)(346002)(366004)(376002)(71200400001)(8936002)(7416002)(9686003)(91956017)(76116006)(6512007)(26005)(66476007)(33716001)(8676002)(66556008)(64756008)(186003)(66946007)(1076003)(6916009)(66446008)(44832011)(5660300002)(54906003)(478600001)(4326008)(86362001)(38100700002)(2906002)(83380400001)(316002)(122000001)(6506007)(6486002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NIRuh/6mv0gkcX9uFJl7vrb0zUZpDD3LjQ0z7zT9bLtRAtSJzrm0RrrEwNwF?=
 =?us-ascii?Q?ITi6o1ozJkmBcAZVZ9PxvzRXjnmU1uSq7QrBoHVjwcZiflZemCUE/aRVOQNO?=
 =?us-ascii?Q?/bC2LOYv/RLTQjocXDzqPVU23PMcQx2mLdyOdg61cquXr1kG4NGuajqxN9/W?=
 =?us-ascii?Q?EvsegRJRswQJHQvsUTxIW3xgqWejrvMxRVDlJqxNvioX4YPPbudO4wtpCnKb?=
 =?us-ascii?Q?fLXJhnaNw+rc4qChJCN5zRLIT1uaJ8Om6PKtBP7ygncErMwccdvOv2jRMobs?=
 =?us-ascii?Q?Qd7iXyvB6On0WcCA4T/Vo55aXZwhUtWbDEEqrCfWXT8rpll1+5S17M202nGj?=
 =?us-ascii?Q?f99F66H/vB6gNyrDjU93HxvSsWPS/u1SkEW37r89DEDQYb1qRjOLitMBcFR9?=
 =?us-ascii?Q?0MexoYPM+xlL3u8LMF+9GSj6mZUQCJpDvlfeYEMfBuNYJUbxYCloXyH/eN6E?=
 =?us-ascii?Q?bTD6p5OgrKBl5xR7CcUjL9COJzwWlxGMWrtLQJhQn5C2HtFT+20KDLLm8x10?=
 =?us-ascii?Q?4V1knV+PL7opZKb7i1UYpE+dgbSJL0MuQp1R9oJhVBQW1aSauVG3TSWICTxJ?=
 =?us-ascii?Q?Zsu8n5DljMCo30zlhMOcjgFGNbCilmwr0HS4fDAVxXZJTrCkjSP2/p2f5mRJ?=
 =?us-ascii?Q?JGFImRzcHkNEx+mcKuYF+UjpT7Zvp2G0FxaM7TWAK0+NSvvmatqpV41fOdZt?=
 =?us-ascii?Q?sUSxzHBlrlfhUfYpzB0Qba4kCeD4JaRUvH6m07Id+qVK00g7hoyAKfBGtSOO?=
 =?us-ascii?Q?Xfha8RO/5pS+d9qcO91zIjfIkT1JxZbzxY34+I7LcJpUmyMHuvnbLovxBXYK?=
 =?us-ascii?Q?gF9zspKQG1rt1aygFpvE4sjuMO6BYU2H4T9eczl448y3+25BdVy6LYUFNm6P?=
 =?us-ascii?Q?qGz9OePjEgPBLnKD3Sx0psIdqy32Bmlo5DWQD2G2URJHq93pU6YzSz0QO3OE?=
 =?us-ascii?Q?X5sjgTWfTlMzsdwancqn2rdiHZY4esi1DAssTbTWLF0v0McJUpa2JU0x5Hkt?=
 =?us-ascii?Q?xM72EACIc6cjLAsCAKAYChLcJOxMO+x9uNF3eWcxZXITwoReFOAbgTGZuHFL?=
 =?us-ascii?Q?r4MrrxMoKJlGZMT3Tb0VxAc+lwXtqVqudog2KOlLWjgKlRoyPo58PigEKDYS?=
 =?us-ascii?Q?5zH6YVGPZg2ZB+DS2yrirj3VwUfH9/pkBsykd0QouE1p3FUhkGt2xYgg1Ozx?=
 =?us-ascii?Q?KSVw5/ND4Vqsryc5MkBXCUCXoK4zwalfkJmCIKdj3QujHWgEJsagiiJ4o0KM?=
 =?us-ascii?Q?MvrHVYoClMfxBV27H0/q4hotwpz+CFYnJRGCVuVH0HNNDJmQmF/tuftDJkGM?=
 =?us-ascii?Q?WypiAODp+7W6M/TtyudSC9QC?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8C1F62DA56D49945BE2DAF4DA525D239@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 129cbc79-b39b-4894-17d4-08d95dac9681
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 16:16:48.9237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: in8RMka4UVQC6fato6t88aJu6VVDS1Dpw6pVx+vi+9B8MJTBslRRJqUPhlyYNKr4//PSVcmoetcze+bGI7g+ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 06:35:15PM +0300, Ido Schimmel wrote:
> Makes sense to me. Gives us further insight into the offload process. I
> vaguely remember discussing this with Nik in the past. The
> hwdom/fwd_mark is in the tree for long enough to be considered a stable
> and useful concept.
>=20
> You are saying that it is useful to expose despite already having
> "switchid" exposed because you can have interfaces with the same
> "switchid" that are not member in the same hardware domain? E.g., the
> LAG example. If so, might be worth explicitly spelling it out in the
> commit message.

Indeed, the "switchid" is static, whereas the "hwdom" depends upon the
current configuration. So it is useful as a debug feature for the
reasons you mention, but I am also a bit worried whether we should
expose this now, since I am not sure if it will impact future redesigns
of the bridge driver or switchdev (the hwdom is a pretty detailed bit of
information). Basically the only guarantee we're giving user space is
that a hwdom of zero means unoffloaded, and two non-zero and equal
integer values can forward between each other without involving the CPU.
The numbers themselves are arbitrary, mean nothing and can vary even
depending on the port join order into the bridge. That shouldn't impose
any restrictions going further, should it?=
