Return-Path: <netdev+bounces-209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB0966F5E60
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6971228104F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4623C4A12;
	Wed,  3 May 2023 18:44:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4AB46BA
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:44:05 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2056.outbound.protection.outlook.com [40.107.20.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FFA83D0;
	Wed,  3 May 2023 11:43:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ttyx6Q0vxEGRbFFz9rMZ8RL6bog9DvxuMMGY+bDTM8c8w9LW0cLD/bckP3GHw4/gWYHsPZ7nGpkhbf9oo2AZN9xn0f0mqcGlcbG6u49yGfxOQ3hzeCbBgv/1+szhOUQ2tCYo99H93ZOX5cPHW1XnaujY/R9tOFmHrylKq6hZnHaYBhySTY3puhpaJRjWCGBSWNIyWwO7fQYZX/HRTHdh6xHfgwH3PwxbLSzaihMcPT4BV9cSkpjPhw8l8LHM2FP92b9Ctmo+LW/ex51gZhZEiGMW3Tez7U8QI4BboNyzDqnYxwZKRNtDKw1V+7hZOMouse1ar+pRXx2HqzdLUfd/6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTo9T8Qu7zgy6rlXIueIoC1T01Qg7AwmeeQ19y3EDp8=;
 b=hurRSOo9e+SPz9HKxpo+/Z9apNRGoNVqzgtHz7XazfL6gzzfEiMm34gdL6wJuQx0PFa9cpGJAFXlkkZAHo+VNyusa3bsELFmlO+TSoIKb8ovKKrX/hds6kvvVKqbctrqr/qxx9ovPx33ypFDf+qyWktmgf3cZloxXQLSlHftl6mf7oj8PbkYDRbgkUeIaiYsrcSs2jv1u2nndoPMmVC04SYKpyWoa13FCRyr93yigk/Y+074LjB909mqQx26zQ6ozl2OHr5pxKpSdR3leOvSvmfGGqhjDCFkAE75yhj7wGOzbZaLNdSMrTVjZokJ3vSvs38hiW0pI8wyl31LVLdrjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTo9T8Qu7zgy6rlXIueIoC1T01Qg7AwmeeQ19y3EDp8=;
 b=l9xlEF8Z1wBb2bQ0i+XK6XaKkVEikM69+4VjCmnbuqtNnpj0Bgmp7bvXUVN77F8yzSP8p4IPaZj5aJ5UkYy7woESZr2HDiP26rg3V2sXF8qhS6jcBfm5WlEBKZ4xSHfBkvJ6YITGHrJ285MO5PB5vo2LscncbRRZoFlwro0oMf0=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DUZPR04MB9982.eurprd04.prod.outlook.com (2603:10a6:10:4db::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 18:41:59 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%5]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 18:41:59 +0000
From: Shenwei Wang <shenwei.wang@nxp.com>
To: Simon Horman <horms@kernel.org>
CC: Andrew Lunn <andrew@lunn.ch>, Wei Fang <wei.fang@nxp.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Clark Wang
	<xiaoning.wang@nxp.com>, dl-linux-imx <linux-imx@nxp.com>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Jesper Dangaard
 Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>,
	Alexander Lobakin <alexandr.lobakin@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
 functions to avoid forward declarations
Thread-Topic: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
 functions to avoid forward declarations
Thread-Index: AQHZfUKo4ZwVUtEG3EOjLFQNjL7Wpa9HnlQAgADiOCCAAC5aAIAAM7tw
Date: Wed, 3 May 2023 18:41:59 +0000
Message-ID:
 <PAXPR04MB918564D93054CEDF255DA251896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20230502220818.691444-1-shenwei.wang@nxp.com>
 <20230502220818.691444-2-shenwei.wang@nxp.com>
 <6dff0a5b-c74b-4516-8461-26fcd5d615f3@lunn.ch>
 <PAXPR04MB9185BD38BA486104EE5B7213896C9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ZFJ+9Ij+jOJO1+wu@kernel.org>
In-Reply-To: <ZFJ+9Ij+jOJO1+wu@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|DUZPR04MB9982:EE_
x-ms-office365-filtering-correlation-id: 239fdba7-9c92-4ea0-8928-08db4c061434
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 7RJ60YtXuRJV9Kpdzqsw0hbjMlNxMP8lOio47MpW2XrqBprTjWpxyP1Mv78Af2kG2x4KHiyEgjmsNolB07WjtbZaIdwGheGz0ia7dQL48cys+AHaq6UF28yQCKEx2NEKhGtDbZVLFP9l86cSpWWY3cX1mhlKVgCPWxKd0YpOsLDYV7jWTmJS327xoZgjrqZ9Q+6d9X0kOw96byGaowoIfnIlMhjr/9ndLRHdwAQC4jNPSApYcoa1CVbQLanLmc40B+oEKc1wS0rwQqV4yj1Da7DTtcm/wih8Ng7xJGX3tYP3QfFuoK3kFIMiNRQmcslyESqjkUKtS3dSSZ+pLUBjwc/SFqL8C11UTyZrntRx6HbtoHDh9sOCei1z2FIQEL7DWV5+zvaBMDuKEwN6SnZQErpnFAv4XonV4XRjD4nIxN0sxJccs2tcbu9+i4WtH+o/5ni2y4uHfbmx7tETPn6M0NXgYGNGBAc+Lk8SR2IpFQENy4eURRjvoLa9YW9SoCBkB2KG0L8Sfy8QY5ar9UG4mJtsz/zd93LN320QLjlclbPGFLv672Sj+rf25H5JkYPMNTWfMPWPzhrOyxxb06k/GT2OVlYoDNsUaDygM4UOhiYwrbR+sjKCbtAEKjrWj+FI
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199021)(26005)(186003)(83380400001)(54906003)(44832011)(6506007)(55236004)(2906002)(9686003)(53546011)(122000001)(7416002)(52536014)(66556008)(66946007)(66446008)(66476007)(64756008)(38100700002)(5660300002)(76116006)(8936002)(55016003)(316002)(8676002)(86362001)(33656002)(38070700005)(41300700001)(6916009)(71200400001)(478600001)(4326008)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?SbQp6nkj81I3eYbksvFva5xZ6YJT05pJdUiVnUfNziQnc/74m7v2BGUaPEaT?=
 =?us-ascii?Q?2XHfj/GIFTTiBVfAhfqkVG3zuSXLkg4vNv+fA95WWAjEu5Am6WWPEB9lWmEJ?=
 =?us-ascii?Q?EPKc/pLBFBteBUdx3hDIG6K1sOpQP5he5Fy3R58F6m2hU4tjBbcNcKNluUUN?=
 =?us-ascii?Q?m0uB0ER6C+T/vjW9ZVHZY/8b9WWqo8EXXDjxP1Zdja0z8BXqIvxEViIJWx+I?=
 =?us-ascii?Q?4sm3kI6Dz3bFslL/pqQPb5GgNg+gCpAYYRQ9zvsUb+2++V+ry1/Wmz8ndLK9?=
 =?us-ascii?Q?dpXbJWM/tSxvzbDo1qQ6TPGUmyq1t7tvUUkjJ0FnymuvqVoIspWcQ1mMllgi?=
 =?us-ascii?Q?BZWEEe4jdeU25pWsrJVy1roomKc/HhOuS+bLg+F9HtkBmRvKz5dnhshUbSw4?=
 =?us-ascii?Q?a//az8/znkP2gLM3+PpgqHhj5ief/15Wb7hl5mTHkdZgMGTCnmThAMJatkWx?=
 =?us-ascii?Q?9nyBHHuP+J44gwvY3UUSUYWrwTsHoUlMpxYPIh3pQAzWlXkFUBWToSCu4s/G?=
 =?us-ascii?Q?6TwCYf9lh4D6rKrxQxuFAqEtaIl3/jIkzJ/v6yvVC2zLP9WDOSqERhcAb9Y7?=
 =?us-ascii?Q?PI/I/i7+l1+Do0/RyZdR798myiy453Ms8Z16NHRaXv+GejIQtKU6jNTM2TtU?=
 =?us-ascii?Q?Bs2TaTHDfLq6aeKsblez9Rjtd33lDmWBJoNCc4/JEKxtujv2QsVXrEr2kWYt?=
 =?us-ascii?Q?tYUFvwVaG47Bk56hVL/6x+Iry7Ql9ZXx8UOUiL0r4LiSLT1nJzGFI51KNs4K?=
 =?us-ascii?Q?bkVfHQiBFtwA8y/pPnpdcvmW9SLavoymcSLC3ZEUHjvkQssuirBN1an4aLC7?=
 =?us-ascii?Q?jDiNq+sg34q1oxRLNYwxWqfQ3HhEbC2iPcZuRB+rmhOMgT6tzxJirgC8cajd?=
 =?us-ascii?Q?uXgIBsbKr92eQB2AXx4ZXW+Ivvg+KAVstYvVxpcCSMNNNY5BUo1A1+hLykRG?=
 =?us-ascii?Q?8YEpmzDn/rjnfkDroxR6j4q0cNmwoshBM6WezheMP93Rtihoo0O8HU0jtHf+?=
 =?us-ascii?Q?uCqFzhxql9fOsHMR8cAJ8tEEC9UTddXpnBWYNBU0ES7Xrg24ICvSzisCUUIZ?=
 =?us-ascii?Q?AEs1egzNEItfbc80syeBakNlvSSOpiQQjrZBpKuIygq5yIo/bO1cRJRmfbjt?=
 =?us-ascii?Q?jRTkzURlVLoaplF7A9nu+ALu5FC+Yy5o0uGKdxwkjdCNgsh6vmC9DuY4tUQx?=
 =?us-ascii?Q?qrI3aU0L8tErcJzK8SbMNj/EWV5awRblTi5S7xGFMBwdfOiTpTWZkbe9GEkT?=
 =?us-ascii?Q?/sshe2UxasW3ea48k0s6Qq34TKBL31sJiOy2X1ycokcE7rzcKFZslsQczhtT?=
 =?us-ascii?Q?ljkA7C0WoAWK3QMnEljX+NWhssuG0rXLdMY8LsiGPCdvi4q+f7q3CqpiwZO6?=
 =?us-ascii?Q?iPGmXO1X974PsSKQ/7zf3VmMVk4iGW0TTavF6Uq1A0QaFjNaBhrBkIZt+k8h?=
 =?us-ascii?Q?zXrKtGvSvzJyrxt37HBdFFLKF97hi3m+rRice8PsnA2jpusYo1nhstHk4BmK?=
 =?us-ascii?Q?79ES/OWBfwrwQKU12pTXZ/BEwY4/ccNszhNwhSOjvE4tTexplYUSgDvW0Atd?=
 =?us-ascii?Q?beNddW1BoJKPbt2zhEwNc7jn9wSVtLINmcrjo+oo?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 239fdba7-9c92-4ea0-8928-08db4c061434
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 18:41:59.5233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /NZ/93cH+pBCBx9Gb8f7QkLi1FLEP9DHjCsvh3NLkJQRlBbECRnOO1E5xHPjecIJc/GBypCMFeWxjQxH+rcjcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9982
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Simon Horman <horms@kernel.org>
> Sent: Wednesday, May 3, 2023 10:34 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Andrew Lunn <andrew@lunn.ch>; Wei Fang <wei.fang@nxp.com>; David S.
> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Clark Wang
> <xiaoning.wang@nxp.com>; dl-linux-imx <linux-imx@nxp.com>; Alexei
> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
> <john.fastabend@gmail.com>; Alexander Lobakin
> <alexandr.lobakin@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: Re: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the fun=
ctions to
> avoid forward declarations
>=20
> Caution: This is an external email. Please take care when clicking links =
or
> opening attachments. When in doubt, report the message using the 'Report =
this
> email' button
>=20
>=20
> On Wed, May 03, 2023 at 12:53:57PM +0000, Shenwei Wang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Tuesday, May 2, 2023 6:19 PM
> > > To: Shenwei Wang <shenwei.wang@nxp.com>
> > > Cc: Wei Fang <wei.fang@nxp.com>; David S. Miller
> > > <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> > > Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Clark
> > > Wang <xiaoning.wang@nxp.com>; dl- linux-imx <linux-imx@nxp.com>;
> > > Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> > > <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>;
> > > John Fastabend <john.fastabend@gmail.com>; Alexander Lobakin
> > > <alexandr.lobakin@intel.com>; netdev@vger.kernel.org; linux-
> > > kernel@vger.kernel.org; imx@lists.linux.dev
> > > Subject: [EXT] Re: [PATCH v2 net 2/2] net: fec: restructuring the
> > > functions to avoid forward declarations
> > >
> > > Caution: This is an external email. Please take care when clicking
> > > links or opening attachments. When in doubt, report the message
> > > using the 'Report this email' button
> > >
> > >
> > > On Tue, May 02, 2023 at 05:08:18PM -0500, Shenwei Wang wrote:
> > > > The patch reorganizes functions related to XDP frame transmission,
> > > > moving them above the fec_enet_run_xdp implementation. This
> > > > eliminates the need for forward declarations of these functions.
> > >
> > > I'm confused. Are these two patches in the wrong order?
> > >
> > > The reason that i asked you to fix the forward declaration in
> > > net-next is that it makes your fix two patches. Sometimes that is
> > > not obvious to people back porting patches, and one gets lost,
> > > causing build problems. So it is better to have a single patch which
> > > is maybe not 100% best practice merged to stable, and then a cleanup =
patch
> merged to the head of development.
> > >
> >
> > If that is the case, we should forgo the second patch. Its purpose was
> > to reorganize function order such that the subsequent patch to
> > net-next enabling XDP_TX would not encounter forward declaration issues=
.
>=20
> I think a good plan would be, as I understood Andrew's original suggestio=
n,
> to:
>=20
> 1. Only have patch 2/2, targeted at 'net', for now 2. Later, once that pa=
tch has
> been accepted into 'net', 'net-next' has
>    reopened, and that patch is present in 'net-next', then follow-up
>    with patch 1/2, which is a cleanup.

So should I re-submit the patch? Or you just take the 1st patch and drop th=
e 2nd one?

Thanks,
Shenwei

