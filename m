Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72F259B775
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 04:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbiHVCMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 22:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiHVCL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 22:11:59 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD74721830;
        Sun, 21 Aug 2022 19:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661134315; x=1692670315;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=78YdFVWcZoZhkv1NVUGW31kEaECXwO+E+G/qPSQW6CE=;
  b=W/ogPRAHKvkWGHaeJwu1BdfXzzN6zIwdZhVnUKZIcnbt/bGoxbkoQmMK
   njXbpjpNyLm5kft8G+fzU7QYgiOD06CrU39FXr83dPHaOg3TnwZnP3AzG
   XTqXCmNcxLSFv8cbO36Z8hXreQP+rnwowWLu1wZsORHc0VBUNIwpFeeLd
   VysuSoR1jePUJwzBIFtQHxGKOmlerbJad+kquCRkInfJJC8HtEuW1Qzih
   rgqhCYgPzpvl4iirFbX7WCKqunPYADA+Xruj+Gt5GL2zGhKoUXRVdqCX4
   O7XhunBnPb1gOnXnuoiNzgggJfDi1NqHlU3iJJ/3Dl/vyN6j7ZtBjdiE+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="292044198"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="292044198"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 19:11:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="585320276"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 21 Aug 2022 19:11:54 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 19:11:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 19:11:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 21 Aug 2022 19:11:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Sun, 21 Aug 2022 19:11:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSPfGxouI/uVT8DD2X3g5vpiDx7hi3ey9gDOyIlUAlRH/N7e7WqxTZ6VvBnqlqDMMSq7BoJYREDPqrH8fYr7dL6y3jqoYoNv8/UJrHRzJmjjiMUcJGxBlqPfZ+ttkmQ+wu86gYtbcbFvhuw/Cegm4tdUkC5otzgdHetOs9PkEf1jTNAjlfxs1nLai7Hou2YIepSR/86T/Zn2b5wu2k50zejgQGZP+6hE50G3r7qbUKOAY1aLvfPSufQPlQQNSTtgZbe5qoFZlZH4q3NY/fZULVk9/EdUScsmApD17P2PWzSdSYrm/05XE2evviYU1uFC7ENI1A+mVDq+1d/0OKfnlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QS46K2SjSk7QYsRrN9eqQROkEiFpdvrl4ySRGovL7E=;
 b=GxT1cvx44ULZkyYW4VDEFFodvpamZ17fa7PDNdwnh/OnBtxbaMqhXlvTHy7cnyGntRRolySEAvbKj8EjeBiQ4AjkoiJFA3gggSGp6yAz6eLJwScnqyKpfMq4SFfgnkEkIR/TRM1IYS/iJ1aMFLBjnVcsWZpWzyXO4SYMZQ4vnsPNQLOLDPnWcvf44nAI1jPpB6Co/SWhFkGscpkY6/V0Y5E8acezd060Qv0fqjv0AQufxHaqLVQJkEsJEcNAsU2aWlvU6XOmq5ItUW2cBn1EMVmx1dkzl++j1CAUJCFn98Gq33/gOOy9tIyAnT0fh7+8Ujr6yHRMH5wVg0fG2yn9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6304.namprd11.prod.outlook.com (2603:10b6:208:3c0::7)
 by MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Mon, 22 Aug
 2022 02:11:46 +0000
Received: from MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::d446:1cb8:3071:f4e8]) by MN0PR11MB6304.namprd11.prod.outlook.com
 ([fe80::d446:1cb8:3071:f4e8%6]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 02:11:46 +0000
Date:   Mon, 22 Aug 2022 10:10:58 +0800
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
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter
 fields
Message-ID: <YwLlsr0jNq5m6v8z@feng-clx>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-3-shakeelb@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220822001737.4120417-3-shakeelb@google.com>
X-ClientProxiedBy: SG2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:3:18::22) To MN0PR11MB6304.namprd11.prod.outlook.com
 (2603:10b6:208:3c0::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6355a0f8-9e87-4525-6e94-08da83e3a9dc
X-MS-TrafficTypeDiagnostic: MWHPR11MB1886:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDTuGsoA2UrOQU2vNAJUHmZep+OSBorVFbsozBxAOUF39TOID5ISxQm0A270GcXePKZw1KimfYyGaEK/uiAKlT1hazQN0MPdYM1xWc3sI5vyNWm9PUGOFslSnKWyFAgeRHoglTLbIuLsC5C3/DHgg7tCm2QL7EJfpj/3EfjGAZhF0ii/mlwIVWmnxAynLUUr9D15+aOFrH/LPHnVZNgYhxTs1Shx49/+FJlkgCGUiQw5eSyAISkkCtTK5hBGVhV3NQa6nWbBFv6FKocDnOlIcB+w+WMlpjY/SzPe9vO5+WHCck3Tjc9Pq/w+z2PxHE+QtD2WOnh1/JvZxz6v4um2KNfcLUwLrVO4j9wL6sXZoODZ22ncBhRp64Eji8oIvxyzIwiLsVqwspgkDi5AQg6l1B2p+BewMtVfHPFbgBeUdzT3TeQwdMUEyMUOev7d16mzdSA4Ckbag/om4QjiG5l3HvRUzC7G6iAFNLGT90rTdnZXrHtBzgQ2DLESIEDTlZpnoxbbSInkgiEoy70JgQEcepkYNqjVGhLBKV0lvuk7TmXBd5Z0DRZPvZKvhOjjMEZTCh5/IfGpLC2+EKlO2ABx3FAanOFqmVlTa4bAvK90yyXYmRMxchsiWtS0mpQW3N22k7ib7IpP4QVZUjSPYPZuaGC5LWIa6Zh2EolJonLhtzP2JH5Wp3b0pS6TBrcjU6oI0oVQf5cPPfdIz75gHpicbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6304.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(39860400002)(396003)(346002)(136003)(366004)(186003)(8936002)(66946007)(66556008)(66476007)(8676002)(7416002)(316002)(38100700002)(5660300002)(6916009)(54906003)(4326008)(26005)(2906002)(478600001)(6486002)(9686003)(6512007)(82960400001)(86362001)(83380400001)(33716001)(41300700001)(6506007)(44832011)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Zh8NzrPLTbsQX5cKrejTA+nIDFMBgb6ddZ/wFV8IFrc7sGDV+AeSYM8k7T7?=
 =?us-ascii?Q?jmpCIPP+qf7gVzUycm1uTlbOoDV8cxQaZ9hBa/0TkS3ifY3bGzIciqrfjp4O?=
 =?us-ascii?Q?n4T7NgxZ0B1fRPdGPynthXym30nv2ECDhAyyvT80zHl2A5Z2MiDoPksOHno9?=
 =?us-ascii?Q?7j0iBbC5voOgG3ntu5FYXYBwE/msOCEInOij5ukyJsrwiqlQG6o6h7632GzO?=
 =?us-ascii?Q?1kJCH2hzbqtX6gx6yJc1PR+VGQXjl7BqM1zncx6deU/F0ktRDr1CifPHi0dy?=
 =?us-ascii?Q?wkCbHHwdt7+mkVichVwB3CsqWQeFsE4pf0s6Djbqn2r8c8FlR80R3fz5dxe7?=
 =?us-ascii?Q?LeaYogZRpWJ5956YWjPdg+V3pyJvyadioghJ0bC5YageDcaSMQkr12SwpK6f?=
 =?us-ascii?Q?2wpVoj4s9NGsQd3BUkOdVkAfXAvGqTbDuxUgdY1plgaO5vrT2bfp5ab40SGy?=
 =?us-ascii?Q?k3aE1+foxTZE8xgv/cnD+RX8nwVPf1YvMyMv7UlKteffxZbMIhLZhifV9HgP?=
 =?us-ascii?Q?kQSzy0q5GX5OVF6U9Y/l1gFWPhwjwba/yZt3Rl/DDzGfSxTjYRErAxBTjRjl?=
 =?us-ascii?Q?0PUxOPePDvgz3wBBASMH5HIEkZt1zWQskNxN2/E9OyTiZn1VHAHqok6R3Znh?=
 =?us-ascii?Q?laKm9eYHCjF867ojxQO2GvkE+A39L2W7i2SxLM004H9jkewr6+9E/SY/x9A2?=
 =?us-ascii?Q?Vn3RGRCej6GumzWWCRTrn6OKT41JyWnluuYW0se2Afi3NnS1OUAnV0z/qKlt?=
 =?us-ascii?Q?NpLEhG4UQT6g6j4I0jPqQxVvD+5VCRxHzsc1roMUGYhlT5MAWnmY7geI0aVd?=
 =?us-ascii?Q?8fwIZn9bIE4rFjl7a9oI79bPvLdFxmMEijrAz4FueYBK2p2iqb/ak6t010YF?=
 =?us-ascii?Q?VZZR9OnR75ZbZkw/wRW61QtHeS1/rH73kZe5wuWDjh1KjG4Xgc0xGaSD1QtR?=
 =?us-ascii?Q?nhnhXnXkkEQbSrZAm4gnrg+SpSYrimoIV5zFPrX16gCSgLhv2S6T5l3sHi6i?=
 =?us-ascii?Q?H8nSe3d3dxkJ6fAajYHVdetCwRT3gQ7ajJ2OgjYEcUGWEcdhmM08Wkcj6bD7?=
 =?us-ascii?Q?/BoRAMmUcSV4RA1dvlt1ujgyJVX81NNpEVu0q1eQ8LcictlIX/E/W6KMNvDN?=
 =?us-ascii?Q?t4/SeemwgEyZRq6mpKrPejCKkDOAMhlG+kV3KZcmQe1qpw6z135QvOr/V+yV?=
 =?us-ascii?Q?jndBkmDEPsv3T9FpZ14MmIp0DJHdCdMgFDiA/KDKrEXJ8xRHI9qA9l2CPczd?=
 =?us-ascii?Q?6VHqe7/Xk99FLgn12AC//l6LUxcIZCYOuxzSAFkXkNzD7whloB3UiIuPJQbP?=
 =?us-ascii?Q?V32UNoixv5QaB1POqmE7S5gsLl4j5W6NuOxTKIc87G89hqxA/EmvBiTCe+ZG?=
 =?us-ascii?Q?FsAbVZNqlxmKZsAFpEhosJEYVQ4T/y3+F3foXMlTZ2WGkxZNRgvDqXsUgBaA?=
 =?us-ascii?Q?Kn5VZP/d9fdz6gm6WCpKiOMymgwSWZztaDP1+lNRDDsBPQKB8YCjManctVQm?=
 =?us-ascii?Q?HseUrOgyjzUhFaEzd+CMv5dGyan/DeDDqGGgCjeSRCFZ3E5Nrn1/GYjaJWEW?=
 =?us-ascii?Q?IYOMsgC1NPEGjk4XrAel89cnHtIbHp+rvBa4g0r3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6355a0f8-9e87-4525-6e94-08da83e3a9dc
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6304.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 02:11:45.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pIlH2IyQRt6EOclIXk5563xG60kLW7uO2GGsEVzuIfeBr8xXflf0brXIMoz/V0KIpt1L+/mKDEstwP5/LtaUxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1886
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

On Mon, Aug 22, 2022 at 08:17:36AM +0800, Shakeel Butt wrote:
> With memcg v2 enabled, memcg->memory.usage is a very hot member for
> the workloads doing memcg charging on multiple CPUs concurrently.
> Particularly the network intensive workloads. In addition, there is a
> false cache sharing between memory.usage and memory.high on the charge
> path. This patch moves the usage into a separate cacheline and move all
> the read most fields into separate cacheline.
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
> With patch		12413.7 Mbps (18.4% improvement)
> 
> With the patch, the throughput improved by 18.4%.
> 
> One side-effect of this patch is the increase in the size of struct
> mem_cgroup. However for the performance improvement, this additional
> size is worth it. In addition there are opportunities to reduce the size
> of struct mem_cgroup like deprecation of kmem and tcpmem page counters
> and better packing.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

Looks good to me, with one nit below. 

Reviewed-by: Feng Tang <feng.tang@intel.com>

> ---
>  include/linux/page_counter.h | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 679591301994..8ce99bde645f 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -3,15 +3,27 @@
>  #define _LINUX_PAGE_COUNTER_H
>  
>  #include <linux/atomic.h>
> +#include <linux/cache.h>
>  #include <linux/kernel.h>
>  #include <asm/page.h>
>  
> +#if defined(CONFIG_SMP)
> +struct pc_padding {
> +	char x[0];
> +} ____cacheline_internodealigned_in_smp;
> +#define PC_PADDING(name)	struct pc_padding name
> +#else
> +#define PC_PADDING(name)
> +#endif

There are 2 similar padding definitions in mmzone.h and memcontrol.h:

	struct memcg_padding {
		char x[0];
	} ____cacheline_internodealigned_in_smp;
	#define MEMCG_PADDING(name)      struct memcg_padding name

	struct zone_padding {
		char x[0];
	} ____cacheline_internodealigned_in_smp;
	#define ZONE_PADDING(name)	struct zone_padding name;

Maybe we can generalize them, and lift it into include/cache.h? so
that more places can reuse it in future.

Thanks,
Feng

