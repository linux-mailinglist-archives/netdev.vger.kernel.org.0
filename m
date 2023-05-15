Return-Path: <netdev+bounces-2767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E06CB703E88
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 22:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B0EA28133C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 20:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8204119918;
	Mon, 15 May 2023 20:20:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBC518C2B
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 20:20:37 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2096.outbound.protection.outlook.com [40.107.95.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3069A13C0F;
	Mon, 15 May 2023 13:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KigEPu4UeyvdDSaI2JH1lmm908eweRvJnEHRmN8zpl3hkn3ghY8WW97MGjYFjD9CtyyTg4aMNz/ovP2cCq1n6KY0Rs8VV1ueJK3R92MS7Q2DaBTWSGBYaDb8KtYPtTo1b9gWeIWgXi4K5EWAX+V2jzCjOKgza7HMc4lofqAffU9rQXN4iztTuTuZIdAXy2YqjBHzTGZPT7mD9OU5ucnD4QZQCDJHln2kGjLWovFOBQR4gAhBED2L3ILqRhYpI/Cr/+pQUzJ8zChqXflLkCl/esFc11F1ZxNAuu/lDA/9CF5KIukyFfhqgrgVSx42ceCCERaCtBV8enfAOT8iZFbnNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihWegdt3+JFMivnC07y4+g6LzKMvvJC5hrefy90bfPs=;
 b=YKH1VAm15jrtcN98vejk8ui8bnjbfDv8hYruJTyt/X2O7Uqza2z1jFCsAnTiA4qnCmmr2B2kJLm9uRkAh++bYYd1wT2T4B3EMu4vMX5bMlSDv7XQAkc7shVO6egrmEHg/pCni7RrFNnlc16X2GEB3L6urwDLTRlZhBPRWCVQ8Lbnf+aX4JozWYDh5OWICRG3vffp52MSOkuK4K8A1eP3Bi+U1viccrpZzPEnotCc4NQV5NTL82yfEf1ELRjWgAPVpgT5/mRBHfPowk7bbI6gCjQJSZLkx8KjyCVJ4LczdIODCb0feQzsDl20Dmb8l/jmIBh3nou5ajY1lZLZlERMvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihWegdt3+JFMivnC07y4+g6LzKMvvJC5hrefy90bfPs=;
 b=i/YQVYV8HFHw+qog/2Yx6DD+IG/XYvRctG/hR8C+GytV+AhfLee+KR+T+xXGtQ/hFjtRnRypG5adLQyAbXNoik8PZmw7uKIYdx0KZmlVqpZlhapJfPgYNxSvU71kiC7oJDoL2DnhbBY3Qi/uCWOQA+hkJP7ScdDC3221veEFCU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6432.namprd13.prod.outlook.com (2603:10b6:408:194::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.14; Mon, 15 May
 2023 20:19:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 20:19:38 +0000
Date: Mon, 15 May 2023 22:19:31 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: wuych <yunchuan@nfschina.com>, dchickles@marvell.com,
	sburla@marvell.com, fmanlunas@marvell.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: liquidio: lio_core: Remove unnecessary
 (void*) conversions
Message-ID: <ZGKT01kLOQNRqx9I@corigine.com>
References: <20230515084906.61491-1-yunchuan@nfschina.com>
 <61522ef5-7c7a-4bee-bcf6-6905a3290e76@kili.mountain>
 <2c8a5e3f-965e-422a-b347-741bcc7d33ce@kili.mountain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c8a5e3f-965e-422a-b347-741bcc7d33ce@kili.mountain>
X-ClientProxiedBy: AS4P190CA0032.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: a89ec0a1-0185-43d0-838c-08db5581b51f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SEDbk4noLQB/P5HkK/25kmgzUzm97TvQX22/lO1GTc2LWYRyGJlHywdeTCU1L34go2ge+icPlcTCszSFGYoD17SbzoV/4cgmsDUk9gFglsaZSWzD92RXl4eXGHWxk2fQpgI3V3tiZS8mLDrq5ctsa5FI3DVkhoDtFiRyyeGrTF+rpfbb6zt3SZ9IMbj4PcPfnaYkEtcjrXCYGuLLgwWmNJIP18M8IkDVOsBEPIRY6Lhksfz4XZcXuzU2drAFgZ8rDDuZHA4Mug+xPjjmcrFVC1qmzhBDDvDLv1/EEitJ1lif6mgzWk5TMpw307HwMHCeB0aY8XbLUZ0diJ+4SVqMHURQFqqakV73e3u3dw7bvdmUXlF0+ShM9L3amIUjoAHN9522aCb13fLonFTnegKcoEV41zs5/+jldR7s+I8ch5+FHyMklAwUb8/4RLXCfjMzFhC+1HYzKcyGPaQtebe3GF3xWX7jGcjnp6mnDAUwxue6nzfap4C+4C4UM7NoSvxOn6zB5JTGbBuzBHTs5sEdo5QtFhueCXiLPrernmqQjHfZpVZ8Yigc9ZKweAt7N8ukXQyM24gmuG/GVXbW3Q8QVFFF+tkvopWFZP7YI2X+z30=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(396003)(136003)(376002)(346002)(451199021)(478600001)(186003)(6506007)(6512007)(86362001)(6666004)(83380400001)(66946007)(6916009)(4326008)(66476007)(66556008)(2616005)(6486002)(41300700001)(5660300002)(316002)(8936002)(8676002)(7416002)(2906002)(44832011)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?trnmBTMe3s63hkIw/dvktBVQUbUi1iOpvleXCPZTJeuSLJb0cMwBu7Be/E0i?=
 =?us-ascii?Q?zJ3UY5gXLQomZkTsC3xx39xQvP7I/2yu7IhUwQZPUPrP8iizGOsgDhin8hBC?=
 =?us-ascii?Q?fP//z1kIfhG5t5kJZ5yjvrOY6tDxFz2egVH9FnmTGZh59gTs+7pQ/+kCR3Va?=
 =?us-ascii?Q?iJD7DxT+et30t2CsGJlRYXxBq3cul1llYBi2/fxGurXlghS6EAoblSvz+6vr?=
 =?us-ascii?Q?2m2L2z2iyiujM0cg3afzzxIxzZYxHICBwNbG6/ZjaP3bKC/NamzMDchXpxeK?=
 =?us-ascii?Q?Frp8sMRKystcdW5j376XXDtHVA6WObkTY5BZpobi8xmcJYIKexM8TjPcpVpH?=
 =?us-ascii?Q?wdLuQ2P8ZabBeHI/+i0QeUJ+6iAbyHivqBKWLkofpcMUY/J18xO42wGMAxlJ?=
 =?us-ascii?Q?+lSxNiGOzIZi7fgTbLZ8YguCzS8T9WQwI8798ktqzvRWcTkoLJwlue0dZJcL?=
 =?us-ascii?Q?XFD8GjYSLOS7JdQ81vFgVWszimTessnFYEXpa6xpN0PhkFPfzP6GxpwzEhlc?=
 =?us-ascii?Q?VayIqbvvjZLDxRA01OQjEMEB4Fcpam2yb7QbzmjZ6D5Mw0eEgLqhMMHB8dUr?=
 =?us-ascii?Q?D7Yzc6h75IwjsL3yqi8LsfbWnxJ3JQlO+60xGfLNKOrgZUOfpyyPFZWU7HZG?=
 =?us-ascii?Q?RAUT49zKC2QZ/QgFGrMr+JK0BMktgVjRgpVAfmfYAaOj4lCrLFI6aBceapee?=
 =?us-ascii?Q?I9pNg2PzQngziw7QOy0y98wnk2zDdWD5X1ZVziLSHwGuxp4DfPMMbyS1dR/A?=
 =?us-ascii?Q?wNfxUZ8ZEUemNFLjZofGr2e0RUZql6VxkLMTuQp+XMgXIKty2iPihHLd+c4g?=
 =?us-ascii?Q?0hbTAkhyoMzmcYv+sjcsQC90dr4p6OnHTEn/qBcexG2u5uUJaafUCSXEmply?=
 =?us-ascii?Q?DVPDrgoJua9bXT+nc+QMeSbH6W68EcYKoda29SB2YlI7p1PyfOxhrpI+ccz7?=
 =?us-ascii?Q?y5Yq6pD7li1UwodQYJfQoMs5tjv+FkjjI7pRNPyMPBhBSnM8xUQsUlUmzLKk?=
 =?us-ascii?Q?uug0n/7J+mCd08KWwRCunAHTNntg0MAu4Vu/pDcADuuXEyXL6hzAXlCLoeOT?=
 =?us-ascii?Q?86yZLli424VP536a173GMELji1uTmX7TxquAXGjBvXw9uns7HJoV48glEg0v?=
 =?us-ascii?Q?POJt3iLo3EEbgLwTOCHFO4ck1HO8JOfD9VpqDUnvFIvPAtc1gjB8DM8AbGFA?=
 =?us-ascii?Q?tAne+g17Wa+UxP3jgsFyORmvPAxCBQzAtgJ/EkYln0Bl51mJUCTkGL7IMXwG?=
 =?us-ascii?Q?HyicuqdSYahTZoXDrExeYiwnxzktetaPaG/09fDIAuYH2Yw3tFSm7h7P13fa?=
 =?us-ascii?Q?JYbkPOgkPXRS/nt5hglQxVY0lqANIhkdQwFw9W8AFJnx05DimfP4ywkaf0I9?=
 =?us-ascii?Q?WntQPUB+7R7Ah1ZU0fDGer4tAAFUGY1WLP328Yr7TADG2cFcH4fSeXsUqECR?=
 =?us-ascii?Q?GtTVC52AvF3Gani/n1D2xAImMrQ+K8ndbY5pUYR7uvdhA5gfegQY/0DnRK/J?=
 =?us-ascii?Q?wwxCKZx0OEjLqJWGFQOrhfRjzQatVvwEUT+2zB5lMp1vLy7WU3lCP78LLxfT?=
 =?us-ascii?Q?Li0p3M4OSJdnXiQLAkdFXJ/dPuXduzh3tTG1tgym2rQ7wIundOOQua2Vx5pC?=
 =?us-ascii?Q?hDy4Cf/aV8EDMJywoHI8rEaHQffnXe1+DqNYoEk4Zd1++ya1riQnVm252m3m?=
 =?us-ascii?Q?j7KLEw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a89ec0a1-0185-43d0-838c-08db5581b51f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 20:19:38.2504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24GMND91BpEAKaDX8scXQG8ji35LbQhJEBLmX9bixkf88/Z5hgqeTb5bMTGymxx8Ielyh3NOiimvubZRmw0OzjlLfP4C7cGO778YIbsJRD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6432
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 05:56:21PM +0300, Dan Carpenter wrote:
> On Mon, May 15, 2023 at 12:28:19PM +0300, Dan Carpenter wrote:
> > On Mon, May 15, 2023 at 04:49:06PM +0800, wuych wrote:
> > > Pointer variables of void * type do not require type cast.
> > > 
> > > Signed-off-by: wuych <yunchuan@nfschina.com>
> > > ---
> > >  drivers/net/ethernet/cavium/liquidio/lio_core.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/cavium/liquidio/lio_core.c b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> > > index 882b2be06ea0..10d9dab26c92 100644
> > > --- a/drivers/net/ethernet/cavium/liquidio/lio_core.c
> > > +++ b/drivers/net/ethernet/cavium/liquidio/lio_core.c
> > > @@ -904,8 +904,7 @@ static
> > >  int liquidio_schedule_msix_droq_pkt_handler(struct octeon_droq *droq, u64 ret)
> > >  {
> > >  	struct octeon_device *oct = droq->oct_dev;
> > > -	struct octeon_device_priv *oct_priv =
> > > -	    (struct octeon_device_priv *)oct->priv;
> > > +	struct octeon_device_priv *oct_priv = oct->priv;
> > >  
> > 
> > Networking code needs to be in Reverse Christmas Tree order.  Longest
> > lines first.  This code wasn't really in Reverse Christmas Tree order
> > to begine with but now it's more obvious.
> 
> Oh, duh.  This obviously can't be reversed because it depends on the
> first declaration.  Sorry for the noise.

FWIIW, I think the preferred approach for such cases is to
separate the declaration and initialisation. Something like:

	struct octeon_device *oct = droq->oct_dev;
	struct octeon_device_priv *oct_priv;

	oct_priv = oct->priv;


