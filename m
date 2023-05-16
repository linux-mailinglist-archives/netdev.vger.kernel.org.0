Return-Path: <netdev+bounces-2858-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A32D47044D5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DBB02813C7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4991E1C77F;
	Tue, 16 May 2023 05:47:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A37A3FDC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:47:14 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767823C32;
	Mon, 15 May 2023 22:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684216031; x=1715752031;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JGRSnyaOzF7kv0KcVT1yNJLFVyV6CwuI4uFF6+Zjk4c=;
  b=D2MJ3DGMJ4/ERxGA7yzVmMfiPAZF9QVtzdzaJreCXQ2jYUAa6buDrl5n
   PhV2Qv1i6W9LYL12FjQ7E3XDJZ3ClPikVEAUrrntvsUsLfO59v9a/Hv3V
   JpzrgMC4DjZbNmmtETlYZje2eHVlBwhYyfdpoMgWfSu8Ho26pqSn2aIPU
   StFxlbD0SS7TZxAxjr+lWYRGTqzgGDZ1at4zxm4EzYq+PL5N/EWxAK7Ig
   613XHsiUi761/Bg8xqELlvrQR+MC+TkWCqFcH3Y2YUadXd9jXBIq22Bww
   O7GSAYC+OT4coONTKGzAm2zXGRUQOGPTYQqGbfcNNXS91FNYJjetIKTS6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="379562778"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="379562778"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 22:47:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="790942888"
X-IronPort-AV: E=Sophos;i="5.99,277,1677571200"; 
   d="scan'208";a="790942888"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2023 22:47:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 22:47:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 22:47:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 22:47:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqICQ4mRqTSoxP0EYUoKTwrzSNolE9tCS8X3pUfPhmpwQgG9/m+CbGpjHzWgnJw5znWH/6PPpOJU8gij6/Uz/BlmnkfHeFyjV9Tosc2e7BUkWP2WgcSxeoUlzia82wsrP0SBpQEVD/238UkPJHxo/4TvViaKSgFWlT0KdT5pQVL/0EM+wk6QjcLBtpKEkRwZs+pXCRKzV+3ntfDkJraZHVZEcObNcmc/z+1qSxV6sx95NS7XTZIOGA1bOGBB4zziwnoh6AfMxjh9LtlylqcgZ+T6RvpKaf/0Qhshklw0Pi5svd1S/ydRlIHSPO4z9hUzPbVug9jDa67gNe7CE+4cjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRC9RKQtiUia6cTDXuwAi3U49+MxznHa2CMxOjKX9uo=;
 b=YPS80Ntlj2J6ksDXyBsTeKYvdwinH/56LjVkAV20gkdyWdA+1cbTFKtEZe6wyZYux2aOnu1heSfYsIExJd6R0IxBiM+r9G/A3N8go9yZEuLwv1OdeazAxNam0QsBkvo/G96JrDsd782MhPj1YVobP6wIC3of2SwV7BH4dNMCLPIpDsJTBZUz9A5/V+2G7LWg3zDY6b6VtBJ5lGR5clsWoOSIqqAmPYhCPvXTva2loEkBwd0uPvp32E9DGii+GKH2JC6p2Soq62UZWTRk8X6CzOrh7W0Lm2ioXQxC5HCGmhyjWGVp6Cjb/u97W146C2a4AGODNCvmFYoCjeFSjlN/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by SA2PR11MB5068.namprd11.prod.outlook.com (2603:10b6:806:116::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 05:47:08 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::e073:f89a:39f9:bbf%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 05:47:08 +0000
Date: Tue, 16 May 2023 13:46:55 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Shakeel Butt <shakeelb@google.com>
CC: "Zhang, Cathy" <cathy.zhang@intel.com>, Yin Fengwei
	<fengwei.yin@intel.com>, Feng Tang <feng.tang@intel.com>, Eric Dumazet
	<edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups
	<cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org"
	<kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
	"Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C"
	<tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>,
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, <philip.li@intel.com>, <yujie.liu@intel.com>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Message-ID: <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
X-ClientProxiedBy: SG2PR06CA0195.apcprd06.prod.outlook.com (2603:1096:4:1::27)
 To PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|SA2PR11MB5068:EE_
X-MS-Office365-Filtering-Correlation-Id: fed1d9e9-a562-40e9-ad69-08db55d0fc44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Txz5xvy052jb7RuVHliQvYyKWLl/ZJZjvoY0mgELZvHGGxdBc5HohP9FN/Kk44mV2DxkjvfcSwAGx6U+QDtbdSF7g486gevyo35rEoUt2j9aFoGkXthPUKW8e+bECp2GIfgi/VUWTfMER35nGmFr/xFKl8WJC0DdOR83XyXU8OVRfn+OITlXvGc4JFWcpkUDlm88Er8NIHk54NgKBe+BAhI4+95mokwzZ2lVjrAUO8PgLIvxylX0mnTpvBYAs66T8I2Wh9URhPXpIJKK3UrlX1OIM2mPX31lfxSaUDMAVmDy/qZ0+Zy0PugP/vtva9LymSSMLAHlWLnjcN+/J7TBseonwChQdLwcnIEr2WOYs+2qKPyzV4oEdwp8XVXIr/dUWKpr03A/ZPjEFIDMiZfYD8QqfKwMKcTVtGuWsWAZpI6aTDAY25R153VNmilIFVdarUr0Y8hIjZVz8vtCAN5arW9OrWGaT6fNIjBDXJ3UrDbKtNeLEUGX79s1VIxkNM6SDmmlqnpfL1qqZBN100AIjJzeDBfcZjHUTXwWSMA5qWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199021)(83380400001)(54906003)(966005)(478600001)(6666004)(26005)(6512007)(6486002)(9686003)(107886003)(186003)(6506007)(33716001)(44832011)(2906002)(6916009)(4326008)(38100700002)(66556008)(41300700001)(82960400001)(66476007)(66946007)(8936002)(316002)(8676002)(5660300002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9BrLYLTkLvwI/oST5AGkJwV0Q9iyORxHvcR2PiI/BzqLyeLZK4oRBJUrbViX?=
 =?us-ascii?Q?NCpOz3FTbozBokvNfkYE3RkzxaCeuBeIRoPU4QsefVulhaT5uI5+VPpriG18?=
 =?us-ascii?Q?+6T21J77YbLAe/Z0/EbkhDHCy8nDN3R3iX8W7d7jfRPNgSq/yalKc4yrH0bN?=
 =?us-ascii?Q?dw0HuHuRva/nJ4nVnrpu+cXz+5Rv7T9Tn6XuWtxgzMttqXzsfvCzbjRWO147?=
 =?us-ascii?Q?Ji4BNq5tQoaDRlCAdY41Y+dIHIHxj7e2xTAGhhWBOqrZ+Df5ZH+FK6cRAtAa?=
 =?us-ascii?Q?j4i5RvUPsWCaskB9U09T1z6g+5H5KzmLg7mEVy+3pmJkMl4pwQ6WTyD+P9js?=
 =?us-ascii?Q?S0UokhE+4q26CLnLm92m8L0PdRYiBH7U6lQ+I+koCrRdog4yKF4cUZE9vkyd?=
 =?us-ascii?Q?sbhryPVI1xR4RGc7GiSIarIk1hFCbXjjAnhCLx0AE9IvkGuDRKt9XxpBIJ1K?=
 =?us-ascii?Q?x4Xvemm5EPMMQ+LSH3pdCuTR3T7o0ZzG4ipdbVvXXCWxBEdz+dPcWg/07ljL?=
 =?us-ascii?Q?M9XjkWijkoboCV1i8dbdNuyjRsiMRjyagX1QsCapua8k6uv90XsjHWCD22J6?=
 =?us-ascii?Q?6t5q+j/phS89afukYgs0LROS7EGQgwG9CzzqJIV94Sb9cTIOeptxUEgY8kmF?=
 =?us-ascii?Q?mbuF4mFN0sO57leCCSkPkpNQNwg3NB45clrp5WEltuwJyaanD3Zfb3v+MUD/?=
 =?us-ascii?Q?/3EZxRISPt4QQZFUI3zyHbo+Kvcm28kBbw7EEb9FcCdD0TbWTJRHjrWm0FWB?=
 =?us-ascii?Q?lmVaqAhqspQm0hEoLdIRYzED0UHhad3aVR6kHkm+tpohRxwef7ZURNSkt9eF?=
 =?us-ascii?Q?Pus+Kl25uiLq4GgvrhhfkLEofLp9zkef2waxTk/bWrjAl8qQVv0sD9hl657H?=
 =?us-ascii?Q?joTw7QPg+NhNbJRPojLHcEXM964jfceac1KbQNOVKN7u/w14/Bcyc+pDhoQi?=
 =?us-ascii?Q?nRUPTJ9/KT/vp2A12ZEnYI0yGEUTjkp7mlXT8lTyCTdJaUGphGGB07SxwYzd?=
 =?us-ascii?Q?Jp9bKut1qXJRRtrUqWG8DoJBMdbeKHeO+iGJ+3MXcigjqKoUeLfwZUHZY0gb?=
 =?us-ascii?Q?xX9wb7+rxH4AWABM/2JDhhhBV434E2pmj3eEo7vtvqf/ZtQiwS9VF3aD4+97?=
 =?us-ascii?Q?YkT24GhgsHdvxZyVTf2p5OasqegeUYxSKnGXquFv2tvEIjAK1p8b1uvleF7F?=
 =?us-ascii?Q?Gbp7UDcgbhooOWm+oaQq2qPVu4c3YBnfepzonDCtISACOB2lqqX7NdWFcYIu?=
 =?us-ascii?Q?lu5n+IVTotFMt/YPrhnSeQLIJwCnqoDVTmUjQZT4CcVE9HlKuSCaqqfjvxAV?=
 =?us-ascii?Q?JCJD5fYLPrDdPMLOHhTfKv77UqpEnHgRKGVOChAiHidllQE4YyRgabGeSM3c?=
 =?us-ascii?Q?GkhgpD5WHnx/BeGTox5qiDpwmzOHuVOq4FrN6ntmdg8XzJ2qzFCyYkrqu5Xu?=
 =?us-ascii?Q?R+ZpPvpENL3qXxGfCvSqBNZCxQE47Hie/AsXv0LWUHimsj85NBK8A0smriAg?=
 =?us-ascii?Q?1/nJAwd4GwLoZ7Kl9UZXEVxLZihNF1KKsiVPoFF0pvY0jS+qs44xr1+0XdqT?=
 =?us-ascii?Q?SERLQJhc5JMYkX09xAGW8CWAG68HtG3XGRt9CWKNcyJNf+cA7IuDAIQBKwoS?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fed1d9e9-a562-40e9-ad69-08db55d0fc44
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 05:47:08.2343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUoq4+1dzJ5jAjpvVkaiWmF/zOJsTBUT1QhEMgpd9WrNFy1zrMFRAj4XZYfrIogL1bBh+jB10eSCru5icKwSqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5068
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

hi Shakeel,

On Mon, May 15, 2023 at 12:50:31PM -0700, Shakeel Butt wrote:
> +Feng, Yin and Oliver
> 
> >
> > > Thanks a lot Cathy for testing. Do you see any performance improvement for
> > > the memcached benchmark with the patch?
> >
> > Yep, absolutely :- ) RPS (with/without patch) = +1.74
> 
> Thanks a lot Cathy.
> 
> Feng/Yin/Oliver, can you please test the patch at [1] with other
> workloads used by the test robot? Basically I wanted to know if it has
> any positive or negative impact on other perf benchmarks.

is it possible for you to resend patch with Signed-off-by?
without it, test robot will regard the patch as informal, then it cannot feed
into auto test process.
and could you tell us the base of this patch? it will help us apply it
correctly.

on the other hand, due to resource restraint, we normally cannot support
this type of on-demand test upon a single patch, patch set, or a branch.
instead, we try to merge them into so-called hourly-kernels, then distribute
tests and auto-bisects to various platforms.
after we applying your patch and merging it to hourly-kernels sccussfully,
if it really causes some performance changes, the test robot could spot out
this patch as 'fbc' and we will send report to you. this could happen within
several weeks after applying.
but due to the complexity of whole process (also limited resourse, such like
we cannot run all tests on all platforms), we cannot guanrantee capture all
possible performance impacts of this patch. and it's hard for us to provide
a big picture like what's the general performance impact of this patch.
this maybe is not exactly what you want. is it ok for you?


> 
> [1] https://lore.kernel.org/all/20230512171702.923725-1-shakeelb@google.com/
> 
> Thanks in advance.

