Return-Path: <netdev+bounces-3863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03222709426
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16B50280E63
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDD76AA0;
	Fri, 19 May 2023 09:53:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9866108
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 09:53:51 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5FCE43;
	Fri, 19 May 2023 02:53:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fimr7oFq6uBMZ/co6tv80lOLiMmecBBAO6BV6XgFmY7OX8VnL8pxNA9881yDa33D+dWeOrhYi1QqQtK1zLEqIhYJyLxn8fMKEXAbFHH/DJW/ho6ZFp5REkDu2od+2q5sFdi+LLQq1omochbJqCFJfMRhRvkSJVsHOYATHgwG08eK2waw9ve4xqxQ2n4insBtNu1ElFrATroaSUKsUsq8PlNHpB96soYVaJB6MOu71IAFhXQ8po/Id15k2ICiPDdiGJeETEHWZscPCoQBpuvqM8NCF0T92WUm+rgwpYBARmKJxJ2Chw81IgBqRf1SFmK0JZA5MaMraQ8O+mT5BEV+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Thw2JDIIJRcOGGl+bnz5CqYKZijEABnSU16Y0DTTRbc=;
 b=jBtGsU/kLxn3na408DeHlA4JpPIU+QGmbtp1vlkTU2uAnMTJPxGhgZp2Sq6zkt/rvbCceXeBTIELMQK00lpEM7PLS7CV0Di45ruRXYwSLHalxTJ4KkL1tD4BivWUPtgNPyXn9OBFhHFNMvkaCYJyy/oOPIEBwmcZASSeGJ9UczkldocwX8ATI21IwAim2auqdo1MknjrXJw43rcVxUwjsAgdpztYCK2xubXT1hl4Qa/0Z3Dz3heoScpn7yfA3sPYNsxoe5FBGD5xtKMkDdD//VZYg0ffEjUMX2WTInAGigGFEBCnQ9+4VmT/ReiNCCMxDDJ2Hi4Esh8Ef8O2Hx+uAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Thw2JDIIJRcOGGl+bnz5CqYKZijEABnSU16Y0DTTRbc=;
 b=AopWHLiiFTGTZMLO8iRoc8g15m+hyzdAdW3DYtYa+91FUr4ttMuqqhfIpCN84fwrf3p3Rn6YtQRvh/GTdWgeGlQGy3pw1R0PS0mog8NFlnBmZeCn2Z7oILtO+SqvgDT7gYDFDMxo2EJbkQn8B284SivzVaYCbMZlKrdUH71YzNY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5690.namprd13.prod.outlook.com (2603:10b6:a03:405::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Fri, 19 May
 2023 09:53:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:53:37 +0000
Date: Fri, 19 May 2023 11:53:29 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Stefan Roesch <shr@devkernel.io>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
	ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org,
	olivier@trillion01.com
Subject: Re: [PATCH v13 4/7] io-uring: add napi busy poll support
Message-ID: <ZGdHGXOfbPd+i1qh@corigine.com>
References: <20230518211751.3492982-1-shr@devkernel.io>
 <20230518211751.3492982-5-shr@devkernel.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518211751.3492982-5-shr@devkernel.io>
X-ClientProxiedBy: AM8P191CA0008.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: 654f6f11-29ff-4b61-05ee-08db584eea87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8an3R5NLg3qRPheqWmem8ZczAYYV6g9cRni+mwjnAx0bX7igleHoEluALtPO6V2fIFh523vNLX4SpAJ/bn9QOXD8c9qa98KmHOiZutrRrVxJEglu4P+ZTZiR7VjQ89ivUKr4LGDaiGMgnd3m7UwXeL56FTknqqO24NpnziLGYy1cqBBJJFWnOpyIzpyMyKt+ZmaqurkJJXZNQ0T06JrFedUAQY5V4PAQueoc7FT2lIJB2EJfUWTMm7Ylo8ffUu1qSU044+3WvgDEU6EPDX0PJOKSS6/dkbPQItdJH009ZfEmA0nUmBEsrHeNCiqiUKFtlgcOEXTQ17gxt7FwUDQKm/ERcnsgFSO/1YwZMewnqTMcDLzEGdL/lukTA8Mge7Af/SWYVrRDNaQ09xfUklSLrHwsAhk80mttnrm7mgtHj5N0Kx/2T8lwVZKqt6a7gtiM8ospiAgE48dBfsXs+i2JDT3ndOTCEkHzb6U8ES7vSkwZevHGVtrcR7yfULM8s9duzwOXEOXIGC8gPy1MC8Y0DF/k17mR6lgI0Y7aR7BniaJfWVMueCNVahUqvW8xQpL7bQCulfMp1Xck2l8DGbNajavJGjhSF9t1VAFte+kA0BV0pVHXWTPY6YSMIR5PVslAoWuYLmLb4PdU0BbHo+tNXkTsd3iI+p1TYiM+94u4SrY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(346002)(136003)(376002)(451199021)(66476007)(36756003)(4326008)(316002)(66556008)(86362001)(6916009)(478600001)(6486002)(66946007)(2906002)(5660300002)(6666004)(44832011)(2616005)(8676002)(41300700001)(6512007)(38100700002)(8936002)(186003)(6506007)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SlhzrsUfx3oesZqXrmpckOELNO6QFAII+X8YqWCTdGbf3yPO6YqjUQrcPLQ4?=
 =?us-ascii?Q?i7rRJgLgnwaF/b3iWPZlnpzrsFNgkPlBtXK2pRJ6vAJpvQNf99+zLdccVLKU?=
 =?us-ascii?Q?XtwI+yeZzmKtskZ9bP0A+TKrT1SPzusKSA42tLnstOyzmtlgkqcD+Uct2uWA?=
 =?us-ascii?Q?v1C2bErL/Aa4+xPF6LgEfJIe8X+2uQU68uTPdYOZSHkKZgfOdfumxUq8xlYj?=
 =?us-ascii?Q?WV3uSzlfeT0Cg0QWukzKT4PPWmur5UCQv7GAIeRD5V3M58fW5SZI6WfyMWOf?=
 =?us-ascii?Q?p+N0BDLyovfn8hc4Isim0dUE3Ntm+Nwz4Nrb7F7LoBC4HaR3PCmAHRou6d+I?=
 =?us-ascii?Q?dB07igS51y0uaS/TN+Ar8rFvnTmO9GPTmnrxwOLQe5BSwMiISzC3AOY6ItDO?=
 =?us-ascii?Q?mX3QJtL6mad1IEHnWDOaEAD6fGiWY5vXwAL1UgVfNT5ivJhOQkBdY/YHFT9+?=
 =?us-ascii?Q?K8V+vsCkmYE4Hn5kVwZAYklteNWBdDrMLV1S3jbjBsLOn5hEZDdFe/L/cjTf?=
 =?us-ascii?Q?EOumPs7OwdXYhJTTJFN1Qyw+Ca34kTH9CFvr20iie0AKt3rr2VLiuwCJ9BDN?=
 =?us-ascii?Q?+oImCmyK7liamMO3m6vF1fCvZoQY2b22UXs5HcF9dOnLuyikSAXfkZUeJWEU?=
 =?us-ascii?Q?nDyuijMee95gqIv8q2+K6e8uzJFWGx8H8tJDTY56z1WSHWroEhuqbVVImI8R?=
 =?us-ascii?Q?9kHYexmN2TmDtHcsk3ZUggLh3tJAS5u2MOp6yWkBPjHyMn6CPQlkTNsUZpS3?=
 =?us-ascii?Q?SkJjnydEuqVWHotIZv9hzUfheyZpHro53iGDf3GMWcCZ08rOS6DvvfBAQe/X?=
 =?us-ascii?Q?wx0UeWN/NM+CPAi5w1TGkdnJ9fhWmk/zs1TrVuER0mEogPYrmqAtnGzBm1Nx?=
 =?us-ascii?Q?DXHN7qLa21guuXnmyz1mXgCfOSGDNnH1Jj/XfoYIgSf3c5o3BOegV9iWEX3B?=
 =?us-ascii?Q?ZJ4/3ddLA3JwghykbVx0Vo02pBfxGKnlgcP02dzNJ95k+pT9YkSwafYP3JJp?=
 =?us-ascii?Q?rS5kWRJF5bb9QK9flwFePzbRP2DufpSgjZLBiDxLDmk1lNnZ2Re3ETStmURJ?=
 =?us-ascii?Q?WHPtOrBxxgaOOgqBOacsjK9OKT/eQyPjM1jXNGMgalqrtaJuLYKl0PfSV9Xl?=
 =?us-ascii?Q?TcgjLqkyzo7Bi/4+mJfmNGFaMJFQmpzRWWJ1jRwnURRuF/do7FEQQ6hmQUJn?=
 =?us-ascii?Q?5rSWq0jBymwE705WaXtSST411CuzmDlgBBjjY0om8f0M65HIjBIjrD87SD14?=
 =?us-ascii?Q?70sWBkREi7XEEnGN/Ofy0OrRPDMM+WNte2JwcbwrZf9NugcLKv3xKijantEN?=
 =?us-ascii?Q?7Ql0sLCsUjTdUrYYjS/TeSD5p4yfCu/6JX2fKC7MZUXw/6CYygXiZ2J1RoqW?=
 =?us-ascii?Q?W5Ep7ujBpSIkTRZxIsMMl7hroNPDVxiM8qmGNzfVN7xUMybTmBiGBqgDiU3G?=
 =?us-ascii?Q?7X0qhPRESQEcWwfcySpzG3qoDna/0FxsCVbD251cpSQOmccksuEINWikxQE2?=
 =?us-ascii?Q?tvAF2DS/IzIi66vTIW2aZF51gEnAH6hy7peCyG+Lj6djXA4AtMrZEmidOaye?=
 =?us-ascii?Q?FI1CtdVTA8FGMZK/259KEQNTKkWrs5+V/zem77eWXJ7a0nkSN2LHCwg4E6Pl?=
 =?us-ascii?Q?r2seFmzbw1xjvknPW4OWmS2pkCT3oOBZi10R0oqpyeH2dCCQNCA7mzL0Xbel?=
 =?us-ascii?Q?8GYIdg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654f6f11-29ff-4b61-05ee-08db584eea87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:53:36.9839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFtHR/yZSVuqiJQxvshut1mao8jk6vcmbqS26CbPHwbmhSAToiY+GyGF2h6BNjhMLmVslFdHyd/wkezoBc1leebXkIMezW3nNmQUnHrhMcA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5690
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 02:17:48PM -0700, Stefan Roesch wrote:
> This adds the napi busy polling support in io_uring.c. It adds a new
> napi_list to the io_ring_ctx structure. This list contains the list of
> napi_id's that are currently enabled for busy polling. The list is
> synchronized by the new napi_lock spin lock. The current default napi
> busy polling time is stored in napi_busy_poll_to. If napi busy polling
> is not enabled, the value is 0.
> 
> In addition there is also a hash table. The hash table store the napi
> id ond the pointer to the above list nodes. The hash table is used to

nit: is 'ond' correct here?

> speed up the lookup to the list elements. The hash table is synchronized
> with rcu.
> 
> The NAPI_TIMEOUT is stored as a timeout to make sure that the time a
> napi entry is stored in the napi list is limited.
> 
> The busy poll timeout is also stored as part of the io_wait_queue. This
> is necessary as for sq polling the poll interval needs to be adjusted
> and the napi callback allows only to pass in one value.
> 
> This has been tested with two simple programs from the liburing library
> repository: the napi client and the napi server program. The client
> sends a request, which has a timestamp in its payload and the server
> replies with the same payload. The client calculates the roundtrip time

nit: checkpatch.pl --codespell says:


:636: WARNING: 'calcualte' may be misspelled - perhaps 'calculate'?
and stores it to calcualte the results.
                 ^^^^^^^^^

...

