Return-Path: <netdev+bounces-3793-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9016B708E0C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 653401C2119E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 02:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6EB38B;
	Fri, 19 May 2023 02:54:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F91375
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 02:54:37 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE39171E;
	Thu, 18 May 2023 19:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684464844; x=1716000844;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1+DJOwujSInK2wEZ/m3KNn7TmTvUBzY4klP7FESkpPE=;
  b=O+Msi0tfNCsg8ah8zkP2wDNvMus2Ll2ReTltKvhkTpBK407eqcQ+6uVd
   Z0ZMje1v7JDVIJI344Fuw0mrRCAUEef2D9iHAVcVtGQsJZ9Eqdo74KuTl
   9d02Bh4aDfSJO7Qf9pDMwAa5QZZ4IwgZOB4BFuAHCsEpK20AjPZ0wB+mY
   1P8yXJVeIZ30xWVho1ocqKKk+DeZMZpbEClvil/owEliKRWCgZuknzeiU
   yX/N3v+MA0Z2u1Ul9w/QGslycVfQjn1b38hfNm3VrHJYqvfAbtWLn0Zj9
   BHGT9wyLY9BivAVnXRYs1wdCBwqaI5t0jkPHjEAa+YvXjDWUCONVBziVT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="336853159"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="336853159"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 19:53:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="702368561"
X-IronPort-AV: E=Sophos;i="6.00,175,1681196400"; 
   d="scan'208";a="702368561"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 18 May 2023 19:53:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 19:53:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 19:53:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 19:53:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 19:53:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PN48XeYa6M8mYxYd0tK1GuRcM65ljMTCoEYIurokQ53ts2szB/G11phn3YUkMkOU/E+DiMTckX/EmRxqR9lVFzywNV+kmFFDbZ/zz2cYrXHXXbdoJBr/7nhLDeqUhzho9aQiJpQOvpJ3mthe7p704kOBKWXigGtm9vmAR+0As7TCfzmyeZaNa3UjMAo25h8Uidr9N1YTOfi4+wSCmn8HFHuhU4/GR9bqWyo2ANYJOc2zSGsPoUZIUDBAfkpaMblsFTyeSnZN5g5/DL3BZXDmtenaclWuKy2IZw1rBMRpMg0K3Tasu0O4JIJGc31A7HpcUILsDcVBaVs2TfptpEb+5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vnt9SPvdD6dyt7qSCZve8Km/cz3aZP7wwbo/21j3Cj4=;
 b=ANNnrtlAkdI8May66efcMSvrEnOtT/K+PH1FQ38qtwWqBx1MaVCg9iqx4siAkG1TEpgTi3fTDRFn6DjXh2V679G42jT0PePsY/VZKrV2jEUse5MEOWYf0eInA6bizjfRqp2rsNri3cm2vvNB1MX5nUiBv7j0M6uwgSIbOdjEI0w3MKphreR75o3UG9IKSUtF4XZ0vDDCsMSiW2QftQMWCxJlwOAe9+Q+s2aXO4yMRqECaH6+Op/F+ty86PmQ3cwkOPd0pf+WnMAkjgjcIAFgrQPxk1eZ0SzQ/lM2rtNznY1s8l6gweAmKLd89aFZvIxYmWEaOMb3Pz+kb0LrHDqAGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by IA0PR11MB7862.namprd11.prod.outlook.com (2603:10b6:208:3dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 02:53:41 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf%6]) with mapi id 15.20.6387.030; Fri, 19 May 2023
 02:53:41 +0000
Date: Fri, 19 May 2023 10:53:27 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Shakeel Butt <shakeelb@google.com>
CC: Zhang Cathy <cathy.zhang@intel.com>, Yin Fengwei <fengwei.yin@intel.com>,
	Feng Tang <feng.tang@intel.com>, Eric Dumazet <edumazet@google.com>, Linux MM
	<linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, Brandeburg Jesse
	<jesse.brandeburg@intel.com>, Srinivas Suresh <suresh.srinivas@intel.com>,
	Chen Tim C <tim.c.chen@intel.com>, You Lizhen <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, <philip.li@intel.com>, <yujie.liu@intel.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Message-ID: <ZGbkp2nx7k+qXOBl@xsang-OptiPlex-9020>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
 <20230517162447.dztfzmx3hhetfs2q@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230517162447.dztfzmx3hhetfs2q@google.com>
X-ClientProxiedBy: SG2PR02CA0072.apcprd02.prod.outlook.com
 (2603:1096:4:54::36) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|IA0PR11MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d3f2f5f-e94b-43d3-1f12-08db58143fe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sm380xZGIBHe0LZXmfCZBLpdXkLH+KiX9FD8TzA5Y+YFkjulQPJ6kksPf7Goz9KzyPQ1QP1TPc4wSDjGQ5mXOO7tP9P0/E1rKgV3+8DOwL7jOqPiuKg8UqU+yg2EoODKprVHxWkySKwwLekr5smVSDAVfIibnJzGMy4VTNuXTATgIUXe56NUx1sIqJC+fTeVuP8v+qCOjCrfDtyNvdwZisf5dqWfufinGeWDm/dxkSXmNAKpcSsoS7zegMTymllUdcIAQFsnavC94doF28zkwaEIigQLDlSnRgSuvk8lXSoaS2y1WXphtebNrhr1F9Le7kwSq5Ooh4+V2MNW4D4gKTcA5ubieph9wy9ZBaRWTQESypFdB2zKgmsrFfo/K3kIi666BN37hzQVhr9JUZUPQSHnJ3sKuWEG0EsLNG6pq64FTEKAKRdV/FAzvkGlhc3sSf8boUCtCZQ6KMGrzTP1w1zc6IQ2PObUsQVHaiflxfQogS1xkG+aqOxDqopLr7oYrxms/gQLWNLEt3Khb1PilHT7TQjboKxeeKddrRnp2ZIhdsIS6Aitm/bErK/w4pMSiJwDxIWmauZ+y4iItI8ggFfPg7gaRENwHfhEjj85gV0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199021)(26005)(9686003)(6512007)(6506007)(53546011)(107886003)(966005)(83380400001)(86362001)(33716001)(82960400001)(186003)(38100700002)(316002)(54906003)(44832011)(478600001)(2906002)(4326008)(6916009)(8936002)(8676002)(41300700001)(5660300002)(66476007)(66556008)(66946007)(6666004)(45080400002)(6486002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BUB01DfN5AifqF4r6FmpnxYow73gM89pxMCcdsBPL93+YX61NeUsS2d5RPQI?=
 =?us-ascii?Q?iS6AovRjZrxyiwvcf56wV13D+wXumpNRDz9O3k/bWd86oqHFYg8xqgDxbr4o?=
 =?us-ascii?Q?FkP/7SBL8jbeOv7V8xDdVoQu8gPmNzf1DrEyFmK89cs/1uUX/nDxsLTyJAyX?=
 =?us-ascii?Q?FKCcqOCTN1ss+WyZzmQzfs5uwqlOvK21pnL/vk3uSvxQ/nBjg3cS1aGzpe5K?=
 =?us-ascii?Q?Vz+5RlGFmbiMLwLlAjuh09Xayc44eYQ90I7AAcNiQWcxUTSVsa52NvMVp2JM?=
 =?us-ascii?Q?9P/C+pnBse89OriPuox6OLLY4Wy5hDEPh1LxEmsO4+aSid3WXAdasChp4Gqb?=
 =?us-ascii?Q?zZIDxZ+2/ZAV1eZtmTy7E3G++FPqnK/MBJj4Ua2YV+u1xFYUFwXleYGOIyN2?=
 =?us-ascii?Q?He5USCdUUjBuXxiNd3IC+rHU5JNEBBcGRrGGhQ9+lfcbaenGIuRBtyEkyJzD?=
 =?us-ascii?Q?4IsPH+qX00VVDDTrE1Z6QnAy28mAI8ye9zy4pJe9+CQMGyhLsSskvnWIqlL2?=
 =?us-ascii?Q?EUv6D8czZ0Rn/YUa/1BAcWoTeoapZUQao5Ow8A75w/Jic1I+JRIWQOTCE55J?=
 =?us-ascii?Q?kSeYoR/0kquOiPnW4s2DEVaGFfNzLg/cpr7qVu6MPiyhNHSJ6A9ugp28e0e9?=
 =?us-ascii?Q?bzVdC0X5lah/VdAsKJbBjVXVLn+OX2bC8PcepnEst5Ep6GE73SRAIM/nsyUY?=
 =?us-ascii?Q?isG0DHkYQPju5Sf7i+gjBv9zy34fmbSKoqNxbdF4h9KKad86MlXoGX/tNXWZ?=
 =?us-ascii?Q?aglLnXJE39CzyID5g15YkFao8lWZ4yTeWAVk5VdGajmAnS/hhM/BIudOwKcw?=
 =?us-ascii?Q?bt8ZDOXH7wzziZOLiQhIo6UVnjW35yZFcxKk5UfCJfNhAYe3zJdkDfv3IA8T?=
 =?us-ascii?Q?XcCJu3KkYxBvbmjT5D9e0JQBnerijQU8HcM1ga/N/u0QXdYN7uV7hLVzyChN?=
 =?us-ascii?Q?bLZpoGkiG0Uorgtip3czq8MfYnyVWzReVJcmmm7RAJL09L7l0s/rr1tR0eYP?=
 =?us-ascii?Q?Nsjuv664lzxpmLJFGr0G828AvwDToru7L2f3r8lyfkQgRmZlnsJSLBTOsQxX?=
 =?us-ascii?Q?ruxR5DFFe+/IEXqh+CFDUFNbDrxF8FE5OqH4fVqo9uOkqZMf9cszU9XFD7lC?=
 =?us-ascii?Q?iNGPVTvLPh9u94HOBBloTde8grdrU1mU01ChG+XlIDfj1ZdIAicMZuemyZ/X?=
 =?us-ascii?Q?eVa9Patd86fWTYN2PNv998Eh2vgqCAL8yWJbWIgrEgiQP7oCat1EEyFKNngD?=
 =?us-ascii?Q?8M+vRWh8LFWLmCw0EjPULJXaHZN6Rod+Ut7and4CRZnCuustQjtKdimb/xWT?=
 =?us-ascii?Q?m+WYrP6cfckgDWMAZF4bIGzS9etKSIDhn7ZZuv3q3UIZobn7vzk4HW6Nwyya?=
 =?us-ascii?Q?lhfTf/lRgZdxIPvCi2Yc8ryxG3gT+SiD9JM3TmqmmHzdU4iKdL2xW9mQzpsU?=
 =?us-ascii?Q?kWaCE/F8r+yIxYxSc5sNdBVCAkRoYaElC5BvnQUEbdXkfmT9S6TZmSQjwjul?=
 =?us-ascii?Q?0/WqrEXF2lQIXTbmcsrM2V94ZEKj8IoRkh+TmWf5b6maI3GT077qL23W4Rd2?=
 =?us-ascii?Q?gOCwbLp/LSpdNrNKgtZ181Mo9PMvmmbaoqs7h06UY7L0Baif8TUfAvwAs2Pf?=
 =?us-ascii?Q?Xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3f2f5f-e94b-43d3-1f12-08db58143fe2
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 02:53:40.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21Kc9mIWgWomubP48q/33jS006qkxRgWtw1ydXB1G8Hg39qizK7l3iad53p7LEUkKP7sDdxKv6mMnLNSZhihgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7862
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

hi Shakeel,

On Wed, May 17, 2023 at 04:24:47PM +0000, Shakeel Butt wrote:
> On Tue, May 16, 2023 at 01:46:55PM +0800, Oliver Sang wrote:
> > hi Shakeel,
> > 
> > On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> > > +Feng, Yin and Oliver
> > > 
> > > >
> > > > > Thanks a lot Cathy for testing. Do you see any performance improvement for
> > > > > the memcached benchmark with the patch?
> > > >
> > > > Yep, absolutely :- ) RPS (with/without patch) = +1.74
> > > 
> > > Thanks a lot Cathy.
> > > 
> > > Feng/Yin/Oliver, can you please test the patch at [1] with other
> > > workloads used by the test robot? Basically I wanted to know if it has
> > > any positive or negative impact on other perf benchmarks.
> > 
> > is it possible for you to resend patch with Signed-off-by?
> > without it, test robot will regard the patch as informal, then it cannot feed
> > into auto test process.
> > and could you tell us the base of this patch? it will help us apply it
> > correctly.
> > 
> > on the other hand, due to resource restraint, we normally cannot support
> > this type of on-demand test upon a single patch, patch set, or a branch.
> > instead, we try to merge them into so-called hourly-kernels, then distribute
> > tests and auto-bisects to various platforms.
> > after we applying your patch and merging it to hourly-kernels sccussfully,
> > if it really causes some performance changes, the test robot could spot out
> > this patch as 'fbc' and we will send report to you. this could happen within
> > several weeks after applying.
> > but due to the complexity of whole process (also limited resourse, such like
> > we cannot run all tests on all platforms), we cannot guanrantee capture all
> > possible performance impacts of this patch. and it's hard for us to provide
> > a big picture like what's the general performance impact of this patch.
> > this maybe is not exactly what you want. is it ok for you?
> > 
> > 
> 
> Yes, that is fine and thanks for the help. The patch is below:

Thanks! we've already fetched the patch in our hourly kernels which under
performance testing now (in fact, as well as func tests)

the testing and bisection could last several days to several weeks, and if
bisected to this commit for any changes such like performance regression or
improvement, we will send report to you.

however, again, if you didn't see any report, it just mean our test robot
cannot sucessfully spot out this commit as the reason for  any performance/func
changes.

> 
> 
> From 93b3b4c5f356a5090551519522cfd5740ae7e774 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeelb@google.com>
> Date: Tue, 16 May 2023 20:30:26 +0000
> Subject: [PATCH] memcg: skip stock refill in irq context
> 
> The linux kernel processes incoming packets in softirq on a given CPU
> and those packets may belong to different jobs. This is very normal on
> large systems running multiple workloads. With memcg enabled, network
> memory for such packets is charged to the corresponding memcgs of the
> jobs.
> 
> Memcg charging can be a costly operation and the memcg code implements
> a per-cpu memcg charge caching optimization to reduce the cost of
> charging. More specifically, the kernel charges the given memcg for more
> memory than requested and keep the remaining charge in a local per-cpu
> cache. The insight behind this heuristic is that there will be more
> charge requests for that memcg in near future. This optimization works
> well when a specific job runs on a CPU for long time and majority of the
> charging requests happen in process context. However the kernel's
> incoming packet processing does not work well with this optimization.
> 
> Recently Cathy Zhang has shown [1] that memcg charge flushing within the
> memcg charge path can become a performance bottleneck for the memcg
> charging of network traffic.
> 
> Perf profile:
> 
> 8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_cancel
>     |
>      --8.97%--page_counter_cancel
> 	       |
> 		--8.97%--page_counter_uncharge
> 			  drain_stock
> 			  __refill_stock
> 			  refill_stock
> 			  |
> 			   --8.91%--try_charge_memcg
> 				     mem_cgroup_charge_skmem
> 				     |
> 				      --8.91%--__sk_mem_raise_allocated
> 						__sk_mem_schedule
> 						|
> 						|--5.41%--tcp_try_rmem_schedule
> 						|          tcp_data_queue
> 						|          tcp_rcv_established
> 						|          tcp_v4_do_rcv
> 						|          tcp_v4_rcv
> 
> The simplest way to solve this issue is to not refill the memcg charge
> stock in the irq context. Since networking is the main source of memcg
> charging in the irq context, other users will not be impacted. In
> addition, this will preseve the memcg charge cache of the application
> running on that CPU.
> 
> There are also potential side effects. What if all the packets belong to
> the same application and memcg? More specifically, users can use Receive
> Flow Steering (RFS) to make sure the kernel process the packets of the
> application on the CPU where the application is running. This change may
> cause the kernel to do slowpath memcg charging more often in irq
> context.
> 
> Link: https://lore.kernel.org/all/IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com [1]
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>  mm/memcontrol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5abffe6f8389..2635aae82b3e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2652,6 +2652,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool raised_max_event = false;
>  	unsigned long pflags;
>  
> +	/*
> +	 * Skip the refill in irq context as it may flush the charge cache of
> +	 * the process running on the CPUs or the kernel may have to process
> +	 * incoming packets for different memcgs.
> +	 */
> +	if (!in_task())
> +		batch = nr_pages;
> +
>  retry:
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
> -- 
> 2.40.1.606.ga4b1b128d6-goog
> 

