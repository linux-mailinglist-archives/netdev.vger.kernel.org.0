Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BD33DE092
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhHBUVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:21:05 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:27294
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231367AbhHBUVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:21:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mr5r9bnZvNdVCI7tePrkrTeazPSDoiSydjw7QGxNfCtkXeRUQF98KEMknCLBJlpDNG7JjwHdGFv6neQRe6ojovI5CiiKpFdsIz2JDfvnSkhOOz4j8+2kBhnJ+QR9eYNDP6gv1g8A385L90WmGBHtMznxa33xR/7F6BnPU8Yz2A1y2X4fbR1Gyd98GZOsa/bsY5heFkhySZNf6IvIKPQQBNX4xZ95bRT2IQkW60r0XjxN/wu5AlGIJQ+ZNoCs6U1lLZkyhyGRlkHn/2HO+gLA29U1twzPizzgEmE+94T9mP5NC890mfbEYq3Hpb49lhOH5N98nl9m7o08YTzvNvN0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M26dBlMJsr3ZJwPdEx0rUoJZIp8oBqYgbOc9zjRx2sU=;
 b=JbcfoqSbCe0HSoXhkquKXUJndrnqoG7Yp+c0+N0msjVoYqjyA31Aj5+MUgGVnoP63oPc+90OxcF6kqvk1wU9z+gigr09xExhAnHu+i0M2jwZsudKfFBxxoySXYJmMhlCtWlHWz1L+aHRSrwPxErzf1Ue0dzkjO5g2StfbXK8arzYsn/LoGbYlh4EdsJmJqWbbiMML3QM/YER2qawGT+vexV0srBJtwDuDF3g9hNm0oGzYgW2DIAgmKfEIkW5kcbi42ctEPYoMSgqAdLRybyI5HaaMwAjhaj1ACwf0FqAT2KnnOS7UJYmF5fy2urtAjwK475qTuSnoUj3SA0fAr55tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M26dBlMJsr3ZJwPdEx0rUoJZIp8oBqYgbOc9zjRx2sU=;
 b=R1KTZeA3sD2P2M2ZatUrDsxI0ivu15V0QU01WOgG/EzSBrn/InUXM9nn+nnZF/VgupnjtGmcWMtLxNnVw53KjsRDx4AKikvspUL5weXNaPZmrhPd/y9fJ/y22Ywc6Ir0+Y/ovy38VW6BJ0lyHr7ZiDk1qhqohHRN8Q0vyAY11HM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Mon, 2 Aug
 2021 20:20:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 20:20:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Networking <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>
Subject: Re: [PATCH] switchdev: add Kconfig dependencies for bridge
Thread-Topic: [PATCH] switchdev: add Kconfig dependencies for bridge
Thread-Index: AQHXh61yQBka7eM/OUS0Ww/tlViNv6tgZe6AgAAjW4CAAAnwgIAADhEAgAAHHIA=
Date:   Mon, 2 Aug 2021 20:20:47 +0000
Message-ID: <20210802202047.sqc6yef75dcoowuc@skbuf>
References: <20210802144813.1152762-1-arnd@kernel.org>
 <20210802162250.GA12345@corigine.com>
 <CAK8P3a0R1wvqNE=tGAZt0GPTZFQVw=0Y3AX0WCK4hMWewBc2qA@mail.gmail.com>
 <20210802190459.ruhfa23xcoqg2vj6@skbuf>
 <CAK8P3a1sT+bJitQH6B5=+bnKzn-LMJX1LnQtGTBptuDG-co94g@mail.gmail.com>
In-Reply-To: <CAK8P3a1sT+bJitQH6B5=+bnKzn-LMJX1LnQtGTBptuDG-co94g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 149df573-17c7-41c2-c881-08d955f303db
x-ms-traffictypediagnostic: VI1PR04MB7119:
x-microsoft-antispam-prvs: <VI1PR04MB711973005C89F9BC57DF6755E0EF9@VI1PR04MB7119.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fiLTNTjBc4JDjIJ+fM0eIZLwrE32qdEGPlmEM2S7G+SzLv+jSLOhZ7NRh8Ox6pdE4blniFKkuVoisum3s9XtJCjVlHjj68J1y8phTA013Oh0B/bDtkRkhNFYw6TKey2d2xs+MSG1QhDsi37WWGikc2kTi319WPlHIMcY7X0XtYIuQ3aRL8mlbSmmlkEHBis2TK0yAryJqAZB4yzdZ2/qHOXCZVRrIWe8kJKOIi3LcVTOnIhEeRkzw05SfYghu0MiFFlQxVmQyKegBDvEsB8PYH3BzMlJ5l+E/F7pVQH/r6hFYnMu5Pbqj8A0eidyMdd6ClKUFIDekiWkTEEpUoJQAlwLXHnzz+CERQ6tbmFpJ0sWCbia0c7m+/VijnA5sb0Xl7QCezjv8KQhSbbg15WFK3eq58ROg5cu7bPb3kJRU3QUYjFSQPEmFf3Qw70alyZhdQxrKkndF9WZqFjXWAA+VXGp+S66+EJluB9cdGK/zSaDg7h6zReJGEhJXB73HGEzyaEKSIanLhvgcUJAzb2ch51LRST2BWTBvYFft0M6HWbwK7CH72q2cqSzTk8Q0HF1HUiELUwTEWm8W2DNQkLHQHNbRGhYzjk9lXWLaAVOGOBC56YIaxW4I/dU6N08e+FmrDl/kfUd4QU7nlEQPDMYULLIo1OHWVrTP3j0wDJEAxCvW6p7S7bNztv0RSR9yNEzOfarbPVEcN49FwUlkMGsuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(136003)(376002)(39860400002)(396003)(186003)(33716001)(86362001)(76116006)(38070700005)(66446008)(26005)(6486002)(122000001)(316002)(54906003)(38100700002)(7416002)(5660300002)(4326008)(66946007)(6916009)(2906002)(8676002)(8936002)(53546011)(71200400001)(6506007)(9686003)(6512007)(83380400001)(64756008)(66556008)(66476007)(44832011)(1076003)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5/XCrQGuRjZwNXw17mPky6Hhi3EMlZ24q4/Kx8Zv7KQQi6x+XtSpOcA+s0Xp?=
 =?us-ascii?Q?TQ9tIADsjqbazf71nMn5gbbDDMkuyWqpfxbB2JKY/9NyMEpODd9eEM7DdUmD?=
 =?us-ascii?Q?HXZWh6SDvhi6rkdVkGro2HtWMFFESLe1U3znPPhtoyosArgi71DiueB80/1r?=
 =?us-ascii?Q?DdyO/jeRI+s73op1M23LGn26gJdXCmDurU0U74CtSoh1pFtjuRet3kLUVKi+?=
 =?us-ascii?Q?qCueUWqeKp+3MScBlYO6Ogxk8apfwQxhtlbMpBa8+npBlGMx7Go99irZd5bh?=
 =?us-ascii?Q?MMYpQTn3X3+n9/WPDb3qO9Oygy8fSkv6L1nBVvUJC90ftkEqeRsrIHEZzWki?=
 =?us-ascii?Q?mkGKnN5+9q0IP+apyWZsscUZ7d3P7U49FFJN/ANCBcWvpVwdGUCjAoZexz82?=
 =?us-ascii?Q?He0I4ccC46dHz9aIAkiYkBxVUM0rir6MTuXI7PJK8m2WY9XkC++rNeV5GYSS?=
 =?us-ascii?Q?M5RK4/QxnHshctNdM/XLCxRmm0OjH78s1OZVrvFFT/D2M2vpKLeZUpYSEsWG?=
 =?us-ascii?Q?vqPnzZt/IR8ESbzMOz51s6Vfi5AqtG9mtvIFk4nlLhU00AHtswuXBt188n6U?=
 =?us-ascii?Q?racY2rF7P86OVTTVjGoX1p7iRqer1/wzdGXtxPFK5fQsI5cFth3f4J0U5UDK?=
 =?us-ascii?Q?qE4GeYzZQEbkzJ5rUduSkuE7gm9iAjP9q5U7rxir9NL3qd5nawhUFAqKqW5M?=
 =?us-ascii?Q?xVrzlqNy+gbiGVe7VgsSHjnjZC6Evoki1W7Dmyz+Lp01BxfnAoyDdFqe4eUk?=
 =?us-ascii?Q?7Y2t6TngKcsCYs4S3VptYu3bX2W1PSAzmcYWHnhLOijvKecS3exrFDIdMPye?=
 =?us-ascii?Q?t7Y1ZyLrOfyegWESi6jX9IAGsRK+rBX4r71tXXkmtRJTD/OTfIs7EQgsOCRa?=
 =?us-ascii?Q?b4UFt2LbYJaZNP/mT21dDZjk5JGpGPmmY6YDh/y91Ehsb9TZdPmp0HC3OzfW?=
 =?us-ascii?Q?D25HJ6YB+nwv57G/1Q7vfbLIdW/9qHWWaZSqCkWz2lf09bI1ykPQ9LKL5WQ3?=
 =?us-ascii?Q?lsvQlUyoCQ9/E9UfmTbkbKa8QHAjqtw/gJjvU9kKw9eDRtksG4/Zx6ZcnzW4?=
 =?us-ascii?Q?LGdJBTvGV0+DRO8qGenpncSvyM4XzEwHppj6UlYS2yxkL7MEQbAfZq5Mhbha?=
 =?us-ascii?Q?8otYk/d0AgSpvIvkUxZunV8uww04YqKQG4mMZ6hhEsm70Ffxx3elQLGybTAI?=
 =?us-ascii?Q?skQrQiODcaWrtmCGZyTmiIPaMn7F7nfLEPlMiHKVtNp3z3b5me28qvRQCWCq?=
 =?us-ascii?Q?X3J0LPbLdGL2KNWZ0rG2Lavs2OOAy/2056qxT4xgysnMyrS7+8LaNfeSRPio?=
 =?us-ascii?Q?pyRgPP/T0mOpzMIdM4HlO8r9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <66D7CD25520E78469E6616D59F8EDEDA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 149df573-17c7-41c2-c881-08d955f303db
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 20:20:47.8176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvfZB1CQnbwGZ7GuEszncas3KoqIQYV7myf/+3NgMlT9agBfCx2dhY91h2x7sS0th/TjKhotDP8B5z1vdixtqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 09:55:20PM +0200, Arnd Bergmann wrote:
> On Mon, Aug 2, 2021 at 9:05 PM Vladimir Oltean <vladimir.oltean@nxp.com> =
wrote:
> >
> > On Mon, Aug 02, 2021 at 08:29:25PM +0200, Arnd Bergmann wrote:
> > > If this looks correct to you, I can submit it as a standalone patch.
> >
> > I think it's easiest I just ask you to provide a .config that triggers
> > actual build failures and we can go from there.
>=20
> This one is with an arm64 allmodconfig, plus
>=20
> CONFIG_PTP_1588_CLOCK=3Dy
> CONFIG_TI_K3_AM65_CPTS=3Dy
> CONFIG_TI_K3_AM65_CPSW_NUSS=3Dy

Yeah, ok, I remember now, I saw that TI_CPSW_SWITCHDEV is tristate, and
incorrectly thought that TI_K3_AM65_CPSW_SWITCHDEV (which is mostly a
copy-paste job of the main cpsw anyway, makes you cringe that they wrote
a separate driver for it) is tristate too.

The options are either to make TI_K3_AM65_CPSW_SWITCHDEV tristate like
TI_CPSW_SWITCHDEV is, and to edit the Makefile accordingly to make
am65-cpsw-switchdev.o part of obj-$(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV),
or to extend the BRIDGE || BRIDGE=3Dn dependency to TI_K3_AM65_CPSW_NUSS
which is the direct tristate dependency of CONFIG_TI_K3_AM65_CPSW_SWITCHDEV=
,
and to make CONFIG_TI_K3_AM65_CPSW_SWITCHDEV simply depend on BRIDGE.=
