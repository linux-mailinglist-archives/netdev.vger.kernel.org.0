Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4220549B7CB
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358431AbiAYPjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:39:32 -0500
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:15073
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1385355AbiAYPhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 10:37:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+Lb0uQbtewCw1VWKZpTJdJ8ARCCyf4e1arXWKJxNb4jYgg91HTSh9+sDwfpQtTZwLju0W1W1axlptt3QvFrN+56dUCYSWKIvgecthDt7Lx9iwXgqHGteQ7NAsjiQJaZc1rA/SST7p3JawVvHOKZ/GAkx7rT6mF4644KT84rXBv0WqpKIvLjDfIzm//d8Y02IawkSoHKRO8nz9vcv/chx1luVCZLteEwuEP3pwqK7+nrCk/fIb5aMVm/DT5P29yczjPhBvMsyI1eGzyblfhMmKCSc/a8qPqQza5IWKgRiDE7JCOlkOo7bZ0XeaGSIpn/sYh14HsMdjTNkvW+hLUg3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QcQs/cWeWLQhESfBX/sjyRVYXbwe2ACFDzcLkF75wo=;
 b=DdOjg1zSAv0J1OORi+Bfb0lS5huXN00sK2qeS9Ge0uFGbbpvzDmA6aMdMa2ZJlYGzXVIVsv95TsT6DOXZ4djBKkfT4ZB84RnO4z6xIpthXhkRqyrl0HG2Zsocb8nPcrqZjERapHhzRBwhUsdNoAYabGki//YJm0+vBrTHylbBsK3dZFclFaNT5++RCrbblomofwwKHhc2IpHD1wnS6L1qDgzm2mPRcec8APs2fb8TwqneVSSpFmN2Bwy06fWkzhrFWICnytW7r4cq+vVtturK6dvYWYMVZ47Sj3Sr4fZzvGWy5JE1JhxDTVH84xc0kSuLECWvMxYGD7kRXU+BL643Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QcQs/cWeWLQhESfBX/sjyRVYXbwe2ACFDzcLkF75wo=;
 b=NO4tYSCvvSYa+Tj4+qd2CNzyfI3kYHMNpKrxY03rken0gApR9OJTTIWF83PbK88gCUleElcsZHhAa3oiXDMXzjJmvtP+je+js8YpB0sTGHuoQR056i5jfVHhjNjkmYT8pA3dFuo+Fpo0Zx+S0+8mnxNjyx8+k0ivvxRIPrRiong=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6115.eurprd04.prod.outlook.com (2603:10a6:208:146::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 15:37:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 15:37:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Thread-Topic: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Thread-Index: AQHYAPlHUZ7+aaeSVU6jmUK14JiGzaxsOSsAgAC1gICAAAeKAIAAtFaAgAAKjACABFJtgIAAZxAAgAGSUQA=
Date:   Tue, 25 Jan 2022 15:37:12 +0000
Message-ID: <20220125153712.dnujk6k3nfxczmi3@skbuf>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf> <Yeoqof1onvrcWGNp@lunn.ch>
 <20220121040508.GA7588@hoboy.vegasvil.org>
 <20220121145035.z4yv2qsub5mr7ljs@skbuf>
 <20220121152820.GA15600@hoboy.vegasvil.org> <Ye5xN6sQvsfX1lmn@localhost>
 <20220124153716.GB28194@hoboy.vegasvil.org>
In-Reply-To: <20220124153716.GB28194@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88876fee-c9a7-40c0-030b-08d9e0188ed5
x-ms-traffictypediagnostic: AM0PR04MB6115:EE_
x-microsoft-antispam-prvs: <AM0PR04MB61153FD6DBAA46EA74CDA8D6E05F9@AM0PR04MB6115.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D6xyiy3xcZzfia8+5+s77vlioJf1KaRgs5FXr3KcZsqALdkAy92MGvx5ike//7Lx1iJAOKyTXSgpwkKCWlDp3pERx73qHbstSTbjKNworB8S5tJJ+Bi9MS1Z4jN9ndiDPDao/j2es5c9ZuUhbWBpqHQnUz8ZkFJjokcU6Vdl+OTdyrCtTgsn+rNVRwggBc67o8iYXCXymc6jmeJi8+POGwlfGvBUY8jw6A13DkYO/tul1nwl+/V8+TiK9TlJgNst6tES502ATSXamMb/GQ59Ztwqaqn89/yH6l3AN8wU9yHSnUFuDaGq2eQ/5tizc6yFJqW6J20E25Ll1U4kOl3JX8otmqylWYJ99ojhNUh6EYdmrfx1YRzMK7Gb9FV3dG66BmZbRdhDO3Q00CSE+mjlM7R05954+mxK4+9wm+/mxEIfB+bSCGY0fRH7NJ7oaUnwvg9GB8iPVR8dng+sMoB2o+Wshqe2y8lna1W/dQ/7/7tmbsa/o1H4I7Rc1CMHFCNv073yDGHV278jpobztIZUhb2qFPlt/fC5qNG44YMJa/KbcqS2WADNnlCLJFwAEFwchtm7l5nXrT9Lky206os916OZIaNEIqtMexiEysqxvPGqiTpq3p8NbCcodViTlIT9TnjcMfcFEWXVAs+3URpwy6mZvhzrx93HzshZx1E8TSPe3LCVFqoqG0FHaX5J5AY2gccQxg4y+QznaHaspAXryqob+xnb+BWQQEN1fiyHN1k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(6506007)(6512007)(9686003)(44832011)(2906002)(7416002)(86362001)(5660300002)(38070700005)(38100700002)(91956017)(66946007)(66476007)(66446008)(64756008)(8936002)(8676002)(4326008)(6916009)(54906003)(66556008)(76116006)(71200400001)(83380400001)(1076003)(316002)(33716001)(122000001)(26005)(186003)(6486002)(268134005)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1mG/WmVy5Ao2tpGM0Iuy46/sUfTtngPEstvLlUNPCkpjNc66n+WwEH569lng?=
 =?us-ascii?Q?NSpnoN12rU/5SR8MjCFesuuOlVQym+h63Di9UYDBm87UcqGNVoKywRXmKTUa?=
 =?us-ascii?Q?eyYnwznvMIyindma1HlPgXHs43qK/O11P2DK780i94xMSNgtaW798diH68ex?=
 =?us-ascii?Q?3YtVY4DMolAw5Mj4ctzcIuNLIaNAS8dbTib7zdjHFBV5wja6y3cLhBltnx2h?=
 =?us-ascii?Q?g2KbwShH30eEwz9aUl7wk0M4qiuo1xzDFQ80tAjuy8sJKUumv9t3hb2Rk3Oc?=
 =?us-ascii?Q?6X1LAaNKahEUMyorEfAkGAPztIH6c1ZM+CeRxqG3/w3jvIAxECH0f5NCNKgP?=
 =?us-ascii?Q?0j09OAHgRqRNh96Kv/o7GdoheHSqc9D8mee4V1HgBVoH4phsJiVWMUEuELC8?=
 =?us-ascii?Q?jl8CBXat23QeM7693I4+G9fuxYJwlWIh/K/03jPFACtSusC0uhoAPmRaxsml?=
 =?us-ascii?Q?EQb3KitKLRXF8gXHUOfBfy17UM4AYjy2/uopwVWBuZ16GlgbZgTdByBVPff7?=
 =?us-ascii?Q?YZwAkSx2JILiIiKFVeCK6wgCpTgb32YN8IBlL83ExgXdBUnmq6qQKenKp3/X?=
 =?us-ascii?Q?hFMbX4a0BmqdVD/Rq81Q4r8Nu0tjT5BccLkepaR+YzhY498U+X2UqmYf6Oix?=
 =?us-ascii?Q?C3+Kjn5KFFibYABhlT+1JiCDb+xIrE/o0SuKvp86e3txAiSJyLaOFkw7eAPS?=
 =?us-ascii?Q?XtUqGVAbOCxnzyeuSqRU6V6CJm7a+msdEAqqUH6zHc0IKXGadoC18wz61sip?=
 =?us-ascii?Q?4jCQ76qirA3FYR33UKXqMMdT/BVbNUtPwE2mH7T8INRGZelW2GSrsVmaL9kx?=
 =?us-ascii?Q?vKs2eB6ZVnvZCwPGdxgx+ez8DQeaH8kiD41SPU6eOOyKNyKBRrMifIvpLWKS?=
 =?us-ascii?Q?rSblC17kz4eC86hOb9iGaYjMW+vsdcRzpIb7N9L6y3Ns45yUD1CXv/JQ5wa5?=
 =?us-ascii?Q?zEeITb4kIKuw+vtqiBOyTh/CXKtw8MdS9y6b5SAEOF7yBqhKc0RLs/+bIuCa?=
 =?us-ascii?Q?DmZo/2GfculfvRtTN7JJHwy5nClHKWvKJAYQwV4xIvy0EVx/SgmluD/Cy3YR?=
 =?us-ascii?Q?kC33ZOHsg1AF9ItCiqcmIe5qBUEzNCmQYyFxn681tHyl4QaZo+8WkAXtSr+r?=
 =?us-ascii?Q?8bSCfnh5xoAwHpFqECjitHro1ovo/NCMuSYiQJPc7BRKgVlYF1xrcVSUIVtr?=
 =?us-ascii?Q?vjCbIzVW21GLtt8ELq8teVqBZRicFKEgu2IG2so/h1xJMhT8TAZgIoAjRu9J?=
 =?us-ascii?Q?o5XaZk3A6HPBqDVtMCMnpgcXX9OuttTwjX/AQGT0Qp3g2rOzBeW9gZQfBKGr?=
 =?us-ascii?Q?g6YmDBupaHx0xOosGG3/+OAmCReozKY/cJtYgBOFuivXOQe/FsbSZP+8fw8r?=
 =?us-ascii?Q?3Y3JSi2sLxHgMfbDnOLCcKATlZwsWcfi2HXPv4kptLBcvEwaH0c22VekuBwt?=
 =?us-ascii?Q?eca0R1akTKw9ZBZ3jZBkIXXVlpVTMjeo93sZmtTOmHEQH0wj+BDqdX8nTy6Y?=
 =?us-ascii?Q?CHJGxFS6fHBSDYJp42P/az4Ft24hGbCUi1PXdAY2UTBY/yQ15mv2UD3CgeZH?=
 =?us-ascii?Q?qsYI6XLEgZFydZY+mBuDm1V08/My/OSodMckYOY032aQq6dzJIipYAkSh4Xp?=
 =?us-ascii?Q?2fJZy+DELwPRF3slrgqFMs8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <049BA5E7EC3C3448B0C6BB0EA42C6EFF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88876fee-c9a7-40c0-030b-08d9e0188ed5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 15:37:12.9016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sUQ/WE/itsNiXhx3vK1UnD9u3GLPpSdvoOpq/51BdTRbFTpn5kuv1usXEbhVIvUjwsXVtdE/WdLherMSelRZJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 07:37:16AM -0800, Richard Cochran wrote:
> On Mon, Jan 24, 2022 at 10:28:23AM +0100, Miroslav Lichvar wrote:
>=20
> > FWIW, scm_timestamping has three fields and the middle one no longer
> > seems to be used. If a new socket/timestamping option enabled all
> > three (SW, MAC, PHY) timestamps in the cmsg, I think that would be a
> > nice feature.
>=20
> This won't work because:
>=20
> - There would need to be seven^W eight, not three slots.
>=20
> - Even with just three, the CMSG would have to have a bit that clearly
>   identifies the new format.
> =20
> > From an admin point of view, it makes sense to me to have an option to
> > disable PHY timestamps for the whole device if there are issues with
> > it. For debugging and applications, it would be nice to have an option
> > to get all of them at the same time.
>=20
> Right.  Those are two different use cases.  The present series
> addresses the first one.  The second one entails making a new flavor
> of time stamping API.

I agree that they are different use cases, but with the runtime PHC
change being now possible, there isn't really a clear-cut moment when an
application can now say "from this moment on, I'm only getting
timestamps from the new PHC". Especially when you switch over from the
PHY to the MAC, a few tens of ms may pass until you get an RX timestamp
from the PHY, and the MAC PHC may well be up and operational in the
meantime, and ptp4l synchronizing based on its timestamps.

I don't have a clear idea how to put it in practice, either. I'll think
about it, but the problem I see is that the phc_index reported by
"ethtool -T" becomes a fuzzy concept in the presence of multiple PHCs.
Adding the ability to retrieve timestamps from all of them doesn't make
it any easier to select which one gets reported to ethtool.
Maybe there's room for both the sysfs and the socket option after all.=
