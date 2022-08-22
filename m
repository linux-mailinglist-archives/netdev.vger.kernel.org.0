Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09659B7BE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 04:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiHVCj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 22:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiHVCj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 22:39:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B66E23170;
        Sun, 21 Aug 2022 19:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661135994; x=1692671994;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=D66hnLPTCud8DP//h2IKQR1witsuK/Lobxm71Fo1/Ls=;
  b=n1ib9oO1WcC5G2KpbkGBp9u61ZXaF27PpsiY7QURZd6dPwyGSZOpgd/Z
   3PaB0+uh23uJhcKdhUA6f14BTQ1N+D4kluFY4UgQ74TUMX+jWGyYRS1MC
   IGvmd0Z+UUNHV7KfjwJSWx6CHpMXZgeoOv5FMdCDpdUa66HCPXhZBDTDu
   6v6yfmx1f4HW9LK9f/QrlFRBnJnt7peP7C8nOrNFqd0nz14R1W8+d2iHc
   fpRvkA0MxSd4+9Hbacc+Rah3Fp+ffxp2uoXhxpZvZNHR/PPUt3njGrQHe
   +dzj1eGx0we8XriLkOUMqfEcIfb5nG0dhRFfF0UyjlxlRrxflT97xtEre
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="294587954"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="294587954"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 19:39:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="608785565"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 21 Aug 2022 19:39:53 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 19:39:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 21 Aug 2022 19:39:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Sun, 21 Aug 2022 19:39:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMmxUDfAF5RjfbQMWHG6KFcZO+HOSn/vDNiqRCxUN8RpszfdTw4aLpM4KrTtFe2NEGUMHCj7G1bwRIOpeZph4lTA7DcU75TNdf3pC98HSOmIb3lltznpoOQeMW7lJ5NFF8wZLXN94hjEmkJLXP0GyzWPpUAzmvY5wWAsSMgi4o4xW9aQQv1OBcJXkSsSuupgDuy1hyYDGV44uBTbreXYxQ7beyIsuJwgSmuEycEGlqebT3AJD7tEto5Xau8ETaMKCWFm5JifdZNzoZffE9o10fSPC3knCTdBPTezDH7wIHHFJd4XeNEFqdVn9e/NF+X6BCOyTDjMzFBP/xtIzfQK6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/L2pj0oVIZeUCUZg+p09BvICWmsvmKpZ2XB8VfNgdw=;
 b=RFY2Pl8cSdRuWPzwZ6IZthfwD7Adn2KUv7het/hW8Ko90EWrWegSD5L1PlzRBFY9AIveVpggRHnYma5/9ljbixYdmXB3xc4O1FFmAPlcb+c8j9v6kadKEput1i23j47i+sfIWLd3zfPaAchKfQGu83rcWof/IdOq/v31CHV5928a6Yd8XAEUSXnOrdq7VICxYOZINY+foXTNPsCDUY88y+WGMzYpbBjP7uNglp+JsjRbmwPmBXTWfuXweAKmd7d+EPePxdQq7/tSXQ4IzsZhBQa7/UOe0hzf/ZJlZTCdIhLXousenSTlaQd1NxQI1cIcJeQ7c4ZP1k++rqR2+nzgTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6304.namprd11.prod.outlook.com (2603:10b6:208:3c0::7)
 by CY4PR11MB1398.namprd11.prod.outlook.com (2603:10b6:903:2a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 02:39:44 +0000
Received: from MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::d446:1cb8:3071:f4e8]) by MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::d446:1cb8:3071:f4e8%6]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 02:39:44 +0000
Date:   Mon, 22 Aug 2022 10:39:02 +0800
From:   Feng Tang <feng.tang@intel.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Koutn?? <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "Sang, Oliver" <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "lkp@lists.01.org" <lkp@lists.01.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for
 low/min
Message-ID: <YwLsRqJDRtshKQ1P@feng-clx>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-2-shakeelb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220822001737.4120417-2-shakeelb@google.com>
X-ClientProxiedBy: SG2PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:4:91::19) To MN0PR11MB6304.namprd11.prod.outlook.com
 (2603:10b6:208:3c0::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd7334d1-0c52-4f7e-9cc3-08da83e7921e
X-MS-TrafficTypeDiagnostic: CY4PR11MB1398:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/r093FSHUA7k2p44Zx+dfKy6nWz8kY94JVbPeCod/E82bhyIvTUtB1I0RzO0W6n7KN0/y0Be3Lezhm4bZLsK8Qe1OsnF2iOpiEn69wrwERm0ybRTqL+wR03mcTwzRNDstnPr2DSAl+CNTczCw3TO3CiXoiZzr3LrHq4c9VAwFEJt7zvonL7sSmkZ8yr34MuGR15jXnrsWGr6iUQnm4QHbVecwELjyl3/OzaIe4Hyf3dd3wkRZqrYbwt22Ypw6s1hsG88cyzQs/ivermWazbCFaocWDULc0Wn7z8giNWQ9l+SV1FY39Iot8kQXmjk/zV+PMos6gFdsswZRp4YR4AHC11lCdinqOSD3H16KxJp/hwsOrqTs+jkzsEL+mRnv7wxQ0AGdow6mBMrQWH2kDXhJRGwAnpM9nPpZJRx9XYc/Rb9x7DtXfrSh0itin1lSOLZnLJxsHq4rk6o8P+/VwmoNXvycZztuUjCFZ4wYt6wHSZz+xdnLggBbdpkFY7bmaVd8UozgqYtcwB47o9jS+yqK2kepwHJjxe6/0WOA1lIRKDyOXtqLgr9vvTXS1ERnxm4no3pu1XhVEKERxxOLktzjw4678DYo8p0wAvoksVnFHEaezIUWiNMKPlamjVxQC/qBUQihkTXMar2v77he1F0ft1vjAhjTVkR9O2aBF1Z+/4GViErp3tGS/qEtQ3u8yOgOnp2FVBeWNNdEkYHF2g6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6304.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(376002)(136003)(366004)(396003)(39860400002)(41300700001)(6666004)(6506007)(186003)(6486002)(478600001)(9686003)(6512007)(26005)(83380400001)(2906002)(5660300002)(44832011)(7416002)(33716001)(8936002)(316002)(6916009)(54906003)(8676002)(66476007)(66556008)(4326008)(66946007)(82960400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gxwu32/9n9ZS2q4ZcFQg0+FrfQkjoFTn92fGHYuZU/VKVYocVHpa2cVo+VNx?=
 =?us-ascii?Q?jRG27YXMXo1dvd4Avce34ZOz32Jhm9+Cshvdm46MpiOFQGQOVsTGKnk7ZzgK?=
 =?us-ascii?Q?KUoht7Hu+EtFnbt29tEWPzawjUkH6PovEJjvMBZYdubz/s+XfPKH/Bp9LRw5?=
 =?us-ascii?Q?YYs/aFpGTvzwavu3JABUq6RLL0IzBaxL6DItC5n+wQqqbAl+P7f88ysctJrx?=
 =?us-ascii?Q?SLtuZ8Jzw+A/KwC7Z7RpyjwfjDgYIZxp9jQqguc/vSEFpLOnMjaOFFgigpkV?=
 =?us-ascii?Q?LUHlgT6iMQDwvVBhvuQbNAQbnvOpX9KkQSckxdtHI27GVhJOQRzS+3rZCYyj?=
 =?us-ascii?Q?XupvW+nGs+PIJ0F6if5JvaEMDEovS9yPWJIi0CNFUpUubGC5fUp1AOWxfT54?=
 =?us-ascii?Q?AklWGdSnFTvJrSurZow0rwvKoiSZCobi7HVQFOR97/trduD9UboOAE1jAxtE?=
 =?us-ascii?Q?D80I/wMyPwDIlNPzeB4ZmOfOEqow4hapqcB1pRS8VVRxAiswI4pXc6E0A2Wa?=
 =?us-ascii?Q?JEvLC39NvtoFMqxr7STrt1vuWGRkyHVroZCn2gyYNouTQBkP9PdYSNN4HH7u?=
 =?us-ascii?Q?42h6yq+6lMu0cjXhP/7fII/lt2w6lhK3eq6DxbTAM5F0oxpmLrhmDZeQCyYR?=
 =?us-ascii?Q?zGfldF0oJFP50GzaDkfTybwMwNA1lLrH7jIVQscnYN2te4T1p2LM+JWkHc+m?=
 =?us-ascii?Q?pZ2N+baX6dc6RlbVqSfXgAeDloMgLm2/Wf5CKms3YhSg4nPoK+DmzQeCwPYe?=
 =?us-ascii?Q?yBgJRVoY2frNNR2SHfdWXgSCD4fchOY8Vbd7Py2bLnU0MhzJiEOfOtIRUgWm?=
 =?us-ascii?Q?EAzS0XEce8Dg9DeUQviR7xpylnaZdzb+E89J9uhjf2QULemnK9XsbaPLacEX?=
 =?us-ascii?Q?VM9deE985OJxTVBI1zY77Q23vQMyEXHDB7j3MObTXvoDlcv4Fji24aAWeMyH?=
 =?us-ascii?Q?rNEUiqYRywS+KHzmof3g1+mOa0IhOk0FPNQj/IexWri+5OoS/NcORZpKTGow?=
 =?us-ascii?Q?170U+Z3j4lU+mRKyjH7Hf4kXiMe3ONzI8LY5iRACAQZy+Rq38Ejg0RglTW7u?=
 =?us-ascii?Q?e0/mVT+Jah8VzRUTAiDuN5Pt33LhR4Y3b2odBQegrBqu8S/I0s5VpbGMuyJT?=
 =?us-ascii?Q?iUDWviAX7RzR+EMRbBjmKHRgsuNxh6MgAStc6rHC+RM1wy+vyuYjjaT/AIYF?=
 =?us-ascii?Q?rA1WvapV3avgaCR5AcCDrQVGvo6vplvQij4f0IhawqWlPK2N9J6zvwGBBCqd?=
 =?us-ascii?Q?axIJ7z0Ti2Y4QdGh5SIq9hhHkTyTIpJBUR/NJZUWHoHZHzJYz18/e6k9XCOJ?=
 =?us-ascii?Q?zoLvd67JH90kphwVz6TNfcUyMK86EW+oFmvLRMm6hGkLCDVModxGXrfzLOuI?=
 =?us-ascii?Q?rx4MWp15d8yXgCmOmuKZH6wpEa022/e1/KZ/46zlLny5opBO89vm3/K3wRtc?=
 =?us-ascii?Q?62SGw00fZb/Yp0VPOdk7D3akwJM+g15eEqplCJ1OsxN5vPDo8pNIqAfeADzP?=
 =?us-ascii?Q?MV5c2OEPn9RmLFaG8kJKgckEqD6ytdOSSmpNQpDJ8SIYYOCSA0hBDyihejyv?=
 =?us-ascii?Q?ZC95BnUmu0NN2Tatg6OjLQc2EwrpCE6bSReXG/yd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7334d1-0c52-4f7e-9cc3-08da83e7921e
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6304.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 02:39:44.0072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49G4tI0KVqxdzHvQc1EYtlS31zudfecna8rMybI9b8G/SC/OqyYx3VoEsVn0V/l9Xlj63VDmYfmWpZYjFDyTbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1398
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 08:17:35AM +0800, Shakeel Butt wrote:
> For cgroups using low or min protections, the function
> propagate_protected_usage() was doing an atomic xchg() operation
> irrespectively. It only needs to do that operation if the new value of
> protection is different from older one. This patch does that.
> 
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately. More specifically
> memory.min equal to size of netperf binary and memory.low double of
> that.
> 
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> 
> Results (average throughput of netperf):
> Without (6.0-rc1)	10482.7 Mbps
> With patch		14542.5 Mbps (38.7% improvement)
> 
> With the patch, the throughput improved by 38.7%
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

Reviewed-by: Feng Tang <feng.tang@intel.com>

Thanks!

- Feng

> ---
>  mm/page_counter.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index eb156ff5d603..47711aa28161 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
>  				      unsigned long usage)
>  {
>  	unsigned long protected, old_protected;
> -	unsigned long low, min;
>  	long delta;
>  
>  	if (!c->parent)
>  		return;
>  
> -	min = READ_ONCE(c->min);
> -	if (min || atomic_long_read(&c->min_usage)) {
> -		protected = min(usage, min);
> +	protected = min(usage, READ_ONCE(c->min));
> +	old_protected = atomic_long_read(&c->min_usage);
> +	if (protected != old_protected) {
>  		old_protected = atomic_long_xchg(&c->min_usage, protected);
>  		delta = protected - old_protected;
>  		if (delta)
>  			atomic_long_add(delta, &c->parent->children_min_usage);
>  	}
>  
> -	low = READ_ONCE(c->low);
> -	if (low || atomic_long_read(&c->low_usage)) {
> -		protected = min(usage, low);
> +	protected = min(usage, READ_ONCE(c->low));
> +	old_protected = atomic_long_read(&c->low_usage);
> +	if (protected != old_protected) {
>  		old_protected = atomic_long_xchg(&c->low_usage, protected);
>  		delta = protected - old_protected;
>  		if (delta)
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
