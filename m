Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D1A59B7B4
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 04:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiHVCcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 22:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiHVCcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 22:32:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E25B2316B;
        Sun, 21 Aug 2022 19:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661135510; x=1692671510;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7mqlmf4nE6XZxy6FrrXnNdanXlIfzXZjbW+EADVO9o8=;
  b=gaB6+8bt9bWmE1eJCy6b0DfWIHG3DwIdFEBQGhiNp8sTo+9aD+P8coo4
   SJVwhGb/B4bHz/cSwIfiNcJskmOXTAuUQoKmrDbem6kT0KZptaaYSBtYz
   A646qdcuEjfwYjLGI8xtCfSIajeFhzrmN3O6qG6uCC9tW8TK8hLQmuWmr
   fQXVe4dbxgruKuNjw/7PkGhxUQLHKFz6X/T7Ui2HLLN0BSQcIM5fgkTE1
   r74iuchytCcYEvi1gxkWpJs/98SxmJz3eR+norFDnSnGvp7qBOOXIAcz1
   gQpk0FFpiezzGeZuYIfkHXl2cBqOxSUpvg3+/PgblZja1Vrd64CDYoUaA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="319337329"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="319337329"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 19:31:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="637986873"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 21 Aug 2022 19:31:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 19:31:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 21 Aug 2022 19:31:48 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Sun, 21 Aug 2022 19:31:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQkcf0clTEGStPQW04XfCVJapnUhWT8PZaR5hIH19bPHf1xahZTnj7/2o9A3kPlSDre55gpyMnNc74jbMgXL939HABgvOdeE+csFbT5O+hqbo9/00pQEVVlpG3Hmgt+bjt2KX4N9I8KEvMPKM17ywVg3BAfCesrJxlZOlDY2cJ3Ml/Qw+yPErBOXTtpC02oWm5SFXZyE/4rYl7kgxDBKOyAiGOfObpFte2mGxpC5iG5Vv3OFnC8dmSyeTBk0MXwvHRkYMoxvnwwwAob58pru6ZeZ1kL8IAFLNIxwpR6ShxTWgls2GbQZyScRERXn5iyuKUN66VvNEDD1YYaCrH7znQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuKvvgm2JD29AOvQGvFJ6uabMzcKjapjTY9zOBiOg7o=;
 b=HLJgarvkGrRcCeKoTsyRNJjlm3bw9BcJ6+RK0aOJBDGMAEC8uzka2V1xw6WEJRvc7WHd/05G9NsiihCGXLMha8JKgJ1/x3mgpzNM9KfsPy7/cMZO/5r+hNPSjFUNdOqRVMl8rqgUlDRirap7yuszLgG4mbemlHE9nnwioJWyRE1TRA03SvMBmHlBvjb3SxbRae2nyR2PYyi1/GdedumFoIrBDzb3/jw7LT3Si7wSoR84L7YIDwpOrtz5hL2hRWRsH83V8Hvl8OFsWLcZSYsJZNlxDDxQEp1Ar67o1thzP8maDHgubgGKfde+stbJDHIc6zuwMecrFbvGtrGaKN7iyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6304.namprd11.prod.outlook.com (2603:10b6:208:3c0::7)
 by MW3PR11MB4729.namprd11.prod.outlook.com (2603:10b6:303:5d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Mon, 22 Aug
 2022 02:31:44 +0000
Received: from MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::d446:1cb8:3071:f4e8]) by MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::d446:1cb8:3071:f4e8%6]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 02:31:44 +0000
Date:   Mon, 22 Aug 2022 10:30:51 +0800
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
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Message-ID: <YwLqW8Bc2CWCJsAE@feng-clx>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220822001737.4120417-4-shakeelb@google.com>
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To MN0PR11MB6304.namprd11.prod.outlook.com
 (2603:10b6:208:3c0::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55bc82f2-98ea-4d81-5a2d-08da83e67418
X-MS-TrafficTypeDiagnostic: MW3PR11MB4729:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/RV8gM3i27Oo2VbeRSRkN08XiCGAf7e7GBn7fvkXbKWFjObGWk7jC+ex+ElwdR932xeG+RG38rGu0wVKXMxM2jv9G/AZ72+QbFYd+HqqGCTt6cBYT0cmZA1o+8+pirGg/sO0nw3vM0HOhZgu2PRxGk1MgLXl18FbclvxX/ZUitqOIRKMugO5g/nk373E5pFW21PNILLrIh+Fb9xau6J0jFeIgCm51TICnj1phGnr/g5Z83sRiCfLeBh9NYIBl6aGns/rM881aeNT5mZiNoydLLIDKDRKUIlZbsYh+hcuyXalhcLO3i3pjgrRuzQPXqiQwtRh/+65eikz3tci7PceCdVAPe+YAvvAZrvgknHdOqHcg7V/MWcDRBvwerO3sDDsfzWJ5VdTB+vOdCcL8z6bwatRU3YJyObjpx9kLbPMmnF6In1N2cyT3TGPKxW7NEeKxtJp9PpnXWo+dFVXZFid1heMTYyZdz3J2dogEDugo2vFp44WqTNlfeRsn8Qkl7bxfNKzSYy51UJc6AevYpsBJ2FKNKeQMFm5X9Lp6VpIUzazUzODWmDCEw2DhRsLalo4pdq4JNMLRHJixplfoM+S1mgpJjpHqBdyqXctx0/HruOPKiWPFFR8hf1bluph13ey9Hl3Lz8zbC7qMoghxcMEwDZkbXpAZ2rSmc0xpChlaQjak9IEwoD6oRIuj5Js4GLtuENSv27A4y/8g+qbuSFEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6304.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(396003)(39860400002)(366004)(346002)(376002)(5660300002)(6486002)(478600001)(186003)(83380400001)(2906002)(44832011)(7416002)(38100700002)(41300700001)(8936002)(86362001)(66556008)(8676002)(66476007)(4326008)(54906003)(33716001)(6916009)(66946007)(6666004)(9686003)(6506007)(316002)(82960400001)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JvVuy5H6mJLxyXneY9GFTYVev51MHF1TrSIshdH9XUFQo1BsnlLxzJKQFOCZ?=
 =?us-ascii?Q?ONnbLyyyfkaLA2V3LZOlf00jdGpQPaB+UeXrW3ZnJu4LwN4FwjkdfI9veUGB?=
 =?us-ascii?Q?Ge9H7kSuUcxEYFz1Nel0MT4va08YAqod52gp1vbwjqrT0Td3hL6gPq5yAytl?=
 =?us-ascii?Q?TVq4I5l4BS/S6lSGr6AcfpH/YrKhPd7rSLiMz+qbkkdhqk9ME5WocX6+cK2M?=
 =?us-ascii?Q?D9cfrfHblP8kgjhyA6M37b517tPDN7vWkaHg/aCMvYX+DhtW0mCS0VmTz1/A?=
 =?us-ascii?Q?0SVmBX5rHOialVw9TMo1svq+OCuSeU6cMxnZS6vI0ivFVEj7ZIcQThXrt3ls?=
 =?us-ascii?Q?GhrnJYvU9o4hUllNUeVltf4ITtGEYn23QJo12s4X+eFxGRxPmAo8yDNNp2m6?=
 =?us-ascii?Q?2kmoIhj+al2T9dAkKG944H1RcFWOr/LpNvSYbtXFwKLQDqcpKCuTUrpA21pa?=
 =?us-ascii?Q?YpEW2RGUvtXrASFJ9oEnlFzGWsgGkFQQSn9oO3o+3xF2STqi9Wh94wUwPyiP?=
 =?us-ascii?Q?THbaNzrD9peLPVxXtgRf5394UtX/cc/t0LdHPy18KZcy3x/d70ug3cfyoKU/?=
 =?us-ascii?Q?ZELSX2xDrxkIhrB6nNxFS+DOCGbKpcIy2VVVd+wQ9UKHSMkQBC/Uh4v5J0g7?=
 =?us-ascii?Q?uUdsWmNftepH5LThZkU6eVR+ex/m9aYx5gBHqkKf38mEgseLbUUBFyMzIFxF?=
 =?us-ascii?Q?MOSGGdcyQNblO/BAsbph4tSwJa80Z+txtZwI5qeXCfBWh20eJqVOck3rsA+G?=
 =?us-ascii?Q?MzaZmYnQ6mULzZ0gt0THIQH26Ou/YoLuqxDIlgwTcHVxqkSu9Q+hjc1jKuZs?=
 =?us-ascii?Q?AO3cd/OycgWopneis30fk7tqQHy2fcRuOR1G7hFxInLv+P6QsQUIkI1weW5G?=
 =?us-ascii?Q?zHp0PQLfN3M83EXfnjtIpOE9/rhq8oSAanMvw/lbrPOoWA59NV+n6glhXLU4?=
 =?us-ascii?Q?S9cNgmpeVX9pnyDSlxudr6KQo0DcGhizibhwAdTBEWgBIkYMgYdFyN3LFUwD?=
 =?us-ascii?Q?UT+Lm0dFJ/PSkjWkvFmoD5fDAC3h2byrJr2Nx9A4SegfDIjj84vxrsMadHlC?=
 =?us-ascii?Q?g1Qk8hKa+Id6xX92f4hIylGGcN4lPwxmI5ahO6GGsbq8eF2SXWg65i8/I32I?=
 =?us-ascii?Q?A+W4R7TrRrVoW9RojxXxBqZhI8XsAMUkn0VyEvZCCJ4dSffs6aSOx4ouFbCf?=
 =?us-ascii?Q?6ZJVEkGkb5YeBh/w1+Anq5KU0O8F51lU/1Mh0noP7mCzkCkdg7Ba5xiNFhZG?=
 =?us-ascii?Q?iLB+5gxMbd4N2RpAbuucj8Vj+bUQ8m3KWpFqDF0/mYwbRj02jrCdueefFaKO?=
 =?us-ascii?Q?3RARtUwbSwENs18vmDDScKvUTkwHjekh8t1ngYlgcoH66ODF9p929s/fInG5?=
 =?us-ascii?Q?2PGC2cHkluu8X4n4jJn7CfHiQtIDEkpBdsc6USI9oXd/XMhGG/CxB8murH64?=
 =?us-ascii?Q?M6550W/W0Lqk7iRZ/PNsq2gD80BFlgv9mRTFtjQwufLhel8m0jb1RXlNXD/2?=
 =?us-ascii?Q?BUJHwGuuz3inN+MKPi0OLUDys08hjmv/lGD/KFeyP0n6fHgSPclzyQ2gqpkG?=
 =?us-ascii?Q?CRVl6zvpaVGT14fKnyiujKbgzaq+5soKHlQopPIm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55bc82f2-98ea-4d81-5a2d-08da83e67418
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6304.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 02:31:44.1534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ECR4CeuVZiYlOpwO1S+Qr3Jx20gRBrt9iQzIiEghMiT89g/ov2aLB4QZKNJ2EadwxxX9IP4PhAPWSqyqeUt2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4729
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 08:17:37AM +0800, Shakeel Butt wrote:
> For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
> machines and the network intensive workloads requiring througput in
> Gbps, 32 is too small and makes the memcg charging path a bottleneck.
> For now, increase it to 64 for easy acceptance to 6.0. We will need to
> revisit this in future for ever increasing demand of higher performance.
> 
> Please note that the memcg charge path drain the per-cpu memcg charge
> stock, so there should not be any oom behavior change.
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
> Without (6.0-rc1)       10482.7 Mbps
> With patch              17064.7 Mbps (62.7% improvement)
> 
> With the patch, the throughput improved by 62.7%.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

This batch number has long been a pain point :) thanks for the work!

Reviewed-by: Feng Tang <feng.tang@intel.com>

- Feng

> ---
>  include/linux/memcontrol.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d31ce55b1c0..70ae91188e16 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -354,10 +354,11 @@ struct mem_cgroup {
>  };
>  
>  /*
> - * size of first charge trial. "32" comes from vmscan.c's magic value.
> - * TODO: maybe necessary to use big numbers in big irons.
> + * size of first charge trial.
> + * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
> + * workload.
>   */
> -#define MEMCG_CHARGE_BATCH 32U
> +#define MEMCG_CHARGE_BATCH 64U
>  
>  extern struct mem_cgroup *root_mem_cgroup;
>  
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
