Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5814E62A018
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 18:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiKORS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 12:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiKORSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 12:18:52 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2050.outbound.protection.outlook.com [40.107.103.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9EC6430;
        Tue, 15 Nov 2022 09:18:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5Qq31xBiJF3cDj35IdxLLaxqe0tAhRZrikReIpDms02eHq+jy+iWyDwNuh864mn5ti7HRjszkDUxpFNHPfUdOkAKv0qR6fYnbQYtReajO3HJ6ehX9Xld5i06RPCEygqihmz/MOWDDSwDmAvSbtJEas1bxZwNfxMVsLjEMfNlMC2UM0oty+UGBDrR3UwnBHS/tEhj5hg1mOjgPgnUAqu52bEbLmzsY0j9gGJ0vO44aQwd90Sp40TTJ5gxokxBtusKrf3WcFhfSIC/ZZlXF6ux/ArykSk00OoClpyfWNace0rJ65LJBrkpHXNGjKsGxsCP8/Sw2FYuLKGUgWS8rDI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nJfdjlNquieBAT2JS1UD0sTWNPYrOoXv+YhxzIPGjQ=;
 b=PWIZ89Yhl2h+zFeWXi3Zwslv/DNcTwG8GpcWmJyTaOo5gXdBuDPcpJkRcGke9BAem9Ud+D6mLxd9m22PiqMsNEkiPMSo2gg1Ei4nmCKkWHKW6kFPe9EObKMZqnOAIHrz8MyywjHhydoFTpkFH2dGr7YWXSnUKlMp7+wTwAQwgjcBlq8ttQG9Lftr2YGawDOYCeWbGBBz0cey7HJ/iaoOYsQqU58YOrbQjAdJpKYqf1KgBUDrLf+Knj20B5ll42URGQwI6Vf3ooH5DsghaqKJsvk3v2MFYPYSoILKzSX4THA90oCBaI4p+/U+hjbrXtz3KS577qzhWgqJZ5tjEZAFOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nJfdjlNquieBAT2JS1UD0sTWNPYrOoXv+YhxzIPGjQ=;
 b=cR9A3uMLohZnmX9gNiQnHb1vTFttIN5huY3945h+sJMR/1pKBaLPUNS5T4G6jLJIfCqopGjZHi0jjeV6bKezm2df0em43IpvSNmy1wvT7UKFPPtxCSdpafaFrzN8BGVg5mvuemJ42+6Nm1vbzRLUffB2bMWkR4o11u21oddasvI=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM8PR04MB8017.eurprd04.prod.outlook.com (2603:10a6:20b:249::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Tue, 15 Nov
 2022 17:18:48 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::6b44:4677:ad1d:b33a%6]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 17:18:48 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v4 1/2] net: page_pool: export page_pool_stats
 definition
Thread-Topic: [EXT] Re: [PATCH v4 1/2] net: page_pool: export page_pool_stats
 definition
Thread-Index: AQHY+QsTb4VRDCZRLEmyB3vYgHUBZq5AOKsAgAAA6vA=
Date:   Tue, 15 Nov 2022 17:18:48 +0000
Message-ID: <PAXPR04MB9185EEE74B09159C18C0FBDD89049@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221115155744.193789-1-shenwei.wang@nxp.com>
 <20221115155744.193789-2-shenwei.wang@nxp.com> <Y3PIYg+VsuBxq5cW@lunn.ch>
In-Reply-To: <Y3PIYg+VsuBxq5cW@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|AM8PR04MB8017:EE_
x-ms-office365-filtering-correlation-id: 85091baf-0b29-4108-089c-08dac72d757b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IdDpRGtSwo6EdsrkHL6Q2uR3tmrz4QQDfydFf0RcUgK4vUJwyG3OXSgvOS5T1tNUCieZdXoWpn4eQ5QPr8k+UnHYcylfkuJUVBeclKCxoC2GhFTt/1yE/60yCS7Pz7M5WHnV84+X/VNFZEtSqPS+OrLRlyYJ3Mt/dbjMLBKEJMcy7CNwBhfDr/4f4sbqyXefetiIy5EjaNjNnFIr3xCxDvsDcTy9yyEuEcDEMR4GEtV+/Fjxb/djmZXUUnkGWZCb5p67O5eh0/kETmLivc4LVo+F/00sHxF4lMdiQjJE4p/nm3VybKNRTBNYZBiht6/bzRGEOUlqVkReXdGIqInADZ1JbxAY8DJDapjj0KvHspBPVSnNIqFK2QCeF+ycI0JXY2NeG0ZMRbRWrhr/47Q2j3sxaR7befCUM/Hx+AJ5OYYMPj/bYXixcgkZ7Krl2T0MnsoLyUvNKLPggrznOl5Hev9GGhXhR2FIy0tothbJBqkKK2uq7nECf8l6n6EYkqsWtA0jL/p3i8dBDG6Ajq7PC+yICz+NanibVfx66IHscKPNcN19ptmU9ZWTkOWlTcOZodpo0C2Z7CYgT1HOij3QoiXkMT5ka2WHuuzGjk9xY1zJYzSoa7neUtDGPHVBNeZxMwQNC5/XPhrVw9NI43Uidcf6PodVFo6Aa24luXPcNHaWlv2zvf6twKv1ycuhJKEwDaOF5HPL2s7rUZDsvRYnLIpEDGYixKR2o9FdejC13CwvqLm3K3AJIoDLwOyjt5Xo7DyweFM6P5fB3bS6DcB5Vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199015)(66476007)(86362001)(71200400001)(8936002)(2906002)(55016003)(4326008)(8676002)(76116006)(66556008)(38070700005)(33656002)(64756008)(44832011)(5660300002)(66946007)(186003)(26005)(6506007)(7416002)(83380400001)(9686003)(478600001)(66446008)(53546011)(7696005)(54906003)(6916009)(122000001)(41300700001)(316002)(55236004)(52536014)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KErl16/taeKVi0LuMx2Q7AceQM0+ByWkDRRRyuewH2Gcz1NJwGV10MDaCNav?=
 =?us-ascii?Q?QUxtBIq2PgyiNj+AMyWyue6MbmzhviESDfOBA3O8zSGfetERmbsSZ7xEpsNF?=
 =?us-ascii?Q?Olbc9U8wjo/TB/RpA1eVZPQOhO4dDS/sposOqvXAymMhJez5ttQlsihWcO4g?=
 =?us-ascii?Q?BJtFsWPAKqf/KlO1zjznpUahnLrccncgIz8xxe8k+TpvnRMjbsXKGcQgq+5+?=
 =?us-ascii?Q?8d8y74nkqtk3pKCJpvPnINW15GHtLIkChMLbMwNSACeONo1HxRsnqj3bb7/A?=
 =?us-ascii?Q?l9rsZ7gPfK5DyqDOXCOLhwTPn4nrlcpU4CkJbHwABgFhthcEY6L6cy9y3zJa?=
 =?us-ascii?Q?XZ9XBtxPuopBRsrfwaMhkhXjKO0x58Fl7HNOzEaA44lb1mbG5wSZoPGw25yx?=
 =?us-ascii?Q?GSTIu3apA3cE00gMtkr09FZLyrbeN8KbjXXn9fXn9jP9eO+2wUntoAfA+eKM?=
 =?us-ascii?Q?/Uj9H52fTrT8uunThg+ZcWKusBy6wfAQIg/x/fMlZcsl62wsMWEIF/6Zr/sO?=
 =?us-ascii?Q?PbcjHrXwZa+6h8ovvtjzUm+9ogPJUWQxt5lD86scVV6knAIWnMpwIvp/rJL0?=
 =?us-ascii?Q?0PhmUoKfy5Fb9k3DxFKmZIUGY6ZH8u96RZ1nBBkOCjsSangW41IwvgWl34R8?=
 =?us-ascii?Q?wziVcJbwKiGqwvSySTatDUugzY3DH5q7o+6BF3MWBrL7ppuxnrPs93Jp77w9?=
 =?us-ascii?Q?IPl8mBgCFkILnUiMWNAxUmzWuJ4jRFshWNwzw617BhkD2++pKf8iWXnGhLnd?=
 =?us-ascii?Q?bikosksO/yVyxLOqc5CQfsMCtq+41nrM11MORYoQrGRJ9AcwDPmOmjhs6q6H?=
 =?us-ascii?Q?x25wBXy1QrD2MIgE43fpjr4vx74KowdVMNd5TSb8UUGcC73T3hItBKQFW4UR?=
 =?us-ascii?Q?q4yWdHEWIclnZHnviOn5esDBLXVERogUh0Biwlj79NLJ+tvt0ZqvGrJl2dLm?=
 =?us-ascii?Q?d3ATkxv09GjdZPDekWL76naVaY/TdAyHKk+UXKGt2MHLO9ruw+i051orH+Av?=
 =?us-ascii?Q?lZkN5KDGDj55mGt7rCEDcW8kHE+JabpnayUvZQQPrXAEvwwlTCGpz9msUJ2Y?=
 =?us-ascii?Q?nN04n7ZtCfiot6Mb7/oFw+isW4y+I8LtWaVMU8NQUsQ3L/dTPzLnIPU2yQSB?=
 =?us-ascii?Q?Vm+0wy/z3lDIVBNOjrTbEcAYl7zZIeR67RlWk8Yqi7COKi6QPjMvMsGP6gsu?=
 =?us-ascii?Q?YlAVRhXmKqBVNM2reztYfSpS6ZM3mWW3ha8OPPDANZDjKIQpjl5x/C19Ym32?=
 =?us-ascii?Q?3hLDMdleunW5g7h3HA4dZC6vd/LPVrSkAyQZd2YhnABHP8jG8ySASIc02Woo?=
 =?us-ascii?Q?paBo/LpYMfcpyTRw4WYget19LbTa4866EV/KFlbH//CUJY+xkUnhZ778ypFj?=
 =?us-ascii?Q?EfkG4y2zUQc6+kCcTvVqfB5ZhVIu1mtNOtUl0Yy06NJS+Emh2b1VsXpNVifG?=
 =?us-ascii?Q?Ywd2I3Dd3bflygXYQNJYH7kElvdlEBWJKmnW/0pu/IPC9Pi2J4wX2e8tr3Kq?=
 =?us-ascii?Q?QPTHY63Wx5BTn7c5CwekFNRP7yKVs9Jj/f68iTnpHFDN3+x2YXqWWEZR/fAP?=
 =?us-ascii?Q?xP2I8UNnGly3wiuhoRsTCp24g5RGdKWxecCNjv+V?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85091baf-0b29-4108-089c-08dac72d757b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 17:18:48.4643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sx7qjp9CCgdmd+9UIpFxp1lmrtSMKUE24GMtHROqYmmvx9VvK4vIcCjY4fjEJ3zOvWp3NG4SQjww8c0KOS6ehw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB8017
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, November 15, 2022 11:12 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Jesper Dangaard Brouer <hawk@kernel.org>; Ilias
> Apalodimas <ilias.apalodimas@linaro.org>; Alexei Starovoitov
> <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>; John Fastabend
> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH v4 1/2] net: page_pool: export page_pool_stats
> definition
>=20
> Caution: EXT Email
>=20
> On Tue, Nov 15, 2022 at 09:57:43AM -0600, Shenwei Wang wrote:
> > The definition of the 'struct page_pool_stats' is required even when
> > the CONFIG_PAGE_POOL_STATS is not defined. Otherwise, it is required
> > the drivers to handle the case of CONFIG_PAGE_POOL_STATS undefined.
>=20
> I agree the API is broken, but i think there is a better fix.
>=20
> There should be a stub of page_pool_get_stats() for when
> CONFIG_PAGE_POOL_STATS is disabled.
>=20
> Nothing actually dereferences struct page_pool_stats when you have this s=
tub.
> So it might be enough to simply have
>=20
> struct page_pool_stats{
> };
>=20

As the structure is open when the CONFIG_PAGE_POOL_STATS is enabled, you ca=
n not
prevent a user to access its members. The empty stub will still have proble=
ms in this
kind of situations.

Regards,
Shenwei

>        Andrew
