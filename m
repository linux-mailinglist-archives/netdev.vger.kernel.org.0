Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E66688C33
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 01:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjBCA7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 19:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjBCA7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 19:59:05 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1EF69B3C;
        Thu,  2 Feb 2023 16:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675385944; x=1706921944;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=P1Cttpgn8DTbtPPkqW35FHHgBbW24ZQi8CtAhWfjTkg=;
  b=iqzYBogZxcBqF7Pi6gbQXEI9YaRUAcFFoMCbLResEeqVrPpuNo6rtJUZ
   xZKzw46X1x9eZXxzEvaJjq/7Yh4omxxPupe/gee3oZli4ChnZPmEYDCuN
   f91zqxzRceLrmYK2jbhtM1nRBCZ5u75ZbCfNYuvAW4CGYGIzj56cM4VU1
   84SU9hPWqIF6QKYWi7H9MY9AnTJ8DRVznhfb5ZpPJvcntJ5AZ+ZmKDmfG
   QgsVjzGm3C+h5oPgQqXgIziO31NmY/H9uZIo0FQPsaKeO10C9bd4Lx7l/
   wOlzYfZjn1zaQ1oZ+BAcCvJ83hqEYK32Z5SqlFB35DkfXB6/03uUcbn6B
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="329905495"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="329905495"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 16:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="789494901"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="789494901"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 02 Feb 2023 16:59:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 16:59:02 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 16:59:02 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 16:59:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Itgn1Dw6rshOTnc1lSM1nFtfVGyUW0Nhw+u1G8CpgzxZ3flglpgbBcAPd5SwDjs6lOd0Ms8+VVF4xmiXbf8X0Ha1yzfpGLrC2WBN36tZdKBlz3MeGVrSO1i0ZYwmZpHfOvab3OANfGdjmsx9DINAnnO9ywtzl8SnWAh0fNwTDKRg8QGqLlbAjGDGAdR696SNsiKGyRYdP4dJbruScMTvN+D6NW/MaXqfmSQPNap+KWK7GxGlqoiYZZVfLUy9j1Ee5JXRAb5/dfsAczkWqg1Ue92YHU8L8wmxp7BhERFTabB4WMHaVQnup1LAi/Gl+2FNVbTvNoJDZiB3qz5qhboszw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IM2TdM+g/l7rJAS6/UvJg3N+8/vXGph9f5orTwl2OOM=;
 b=bkzf6wJNxfVuF/PCJBBbJUBoUCxFaALhSOzRXb4z6FkKiyfwl48klPbCCb/MQ1709Fc7K0uBuNPgddMosZjF0WwRkzsZQDVPyD9xUAf3Ds2qffHW/J/BLtPMi6mUrvcVN5EyCDTj5FakBbn1+J5jJK6c4PXfznn16lhUhqIuSd8qRyuV2X5y6XT8cTJyZYeVmxmq8+zqtAkbNSnGWFfglyb1ZpgRQ/ISK6pBOewUUN2bI7X5AgjONR6ZC8t4Wr4BRMx37LtjzAViSen/osDISxw/ATH0/m/6rf16d52aqcVEC3z+tPgWuHo72nPHCcZ1K+ujKMBTnQgTmzRhBb1CNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6206.namprd11.prod.outlook.com (2603:10b6:208:3c6::8)
 by IA1PR11MB7773.namprd11.prod.outlook.com (2603:10b6:208:3f0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23; Fri, 3 Feb
 2023 00:58:51 +0000
Received: from MN0PR11MB6206.namprd11.prod.outlook.com
 ([fe80::cd83:248f:1c9b:c9d]) by MN0PR11MB6206.namprd11.prod.outlook.com
 ([fe80::cd83:248f:1c9b:c9d%8]) with mapi id 15.20.6043.038; Fri, 3 Feb 2023
 00:58:51 +0000
Date:   Fri, 3 Feb 2023 08:58:23 +0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Yury Norov <yury.norov@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haniel Bristot de Oliveira <bristot@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Peter Lafreniere <peter@n8pjl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        "Vincent Guittot" <vincent.guittot@linaro.org>,
        <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH 3/9] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y9xcL56hw7nSxiyc@chenyu5-mobl1>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
 <20230121042436.2661843-4-yury.norov@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230121042436.2661843-4-yury.norov@gmail.com>
X-ClientProxiedBy: SG2PR02CA0071.apcprd02.prod.outlook.com
 (2603:1096:4:54::35) To MN0PR11MB6206.namprd11.prod.outlook.com
 (2603:10b6:208:3c6::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6206:EE_|IA1PR11MB7773:EE_
X-MS-Office365-Filtering-Correlation-Id: 608a4050-6233-42fd-5ebd-08db0581d0cd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m43jQcSYzv+JbYfXpTanuc3NLvZuZxA+ZOVTCfZU4KPgrSmL+ZwGfwHzWmXPYTHfsbSZKOdV425L40G2KbZ6BTdiyspXOyVD6gohMzVfCc39+yNF3KBYH3gKnInSS2DLORwmAQKn7JzJ0+jmbCHIGISRXEc77pp4P6GevpXk+FljOGDT5DV5M4VL0GuFZ+0rIhuOSINRee7BRZcF4GuoWuIc9cmZphvB+JA5im1ionZu8cInJVeCb5GGBzum8KltsFYC4AJyk1iQ5DINrrCyYPBk56XG2kaPZeW52eScxM0/afYkvoqMf4bFaCGNxZPL+s7BuE8Fo65PruHtCtmsKK5McHNhy4QPro6sP2kA6w3cEpdUPrOYCDah0aK0dwyZgZNZTqENnalgVUk90/1uVRHSxD0ae4fRt0HfdnAfqg3y6FGmRRXl7doOsJ/ZOQ2LejWWmxO3n2KM9HnCp/wwCT1LOFDlctnok+xoD+bfmqK8iLtsio9c3PlUD85OSsA3mx3rXDwOx5Og9x8Q0mqPTwdqm7OCJgvmsnYvWfC2UPbt4sGIWY68dCrqEIWIwuh5peFgu8H86sHgZk9FdoAdsLYVBs/RGeYn1deaIf8hZlftJkIS5g51TEJEEtdvjcTAHlNsR6iLGd+3+0W94+CFHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6206.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(136003)(346002)(396003)(366004)(39860400002)(451199018)(26005)(6512007)(53546011)(9686003)(478600001)(6506007)(186003)(6486002)(2906002)(83380400001)(33716001)(86362001)(38100700002)(5660300002)(316002)(7416002)(8676002)(7406005)(54906003)(82960400001)(6666004)(41300700001)(8936002)(4326008)(6916009)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0IBGDtvt6RUbVvEi3FIvgci7uHB9VUX2oqS0hvzanRnuJONKlJGqdGbvK0sB?=
 =?us-ascii?Q?AflhU+WXJXHGB3VVgZN2dvYjJfv1zQDUc/z8/IFxHm2BtZa+pnPaRmiymEEZ?=
 =?us-ascii?Q?nbmBWibUyDcac2+Z7WXqQHs7Vv950qWra1vTWcbq6i1deqUA0z71REJj8SVd?=
 =?us-ascii?Q?GFE+dy33JCfhTAweWatIxk+v+3ND/mYscxNsTAze1Z4Yj5wtlhqSv8GXIUPR?=
 =?us-ascii?Q?qaMqMZb+LoKn99QLovApktR2eOjaVnKrlckrLSK+6xVw+3kK/0w0FqGwm9BL?=
 =?us-ascii?Q?OjChPTkqludJ6Ftsvs/vwKM8NnwM8TO278QN8JvfKocIYEvgJdiaxYKBJibD?=
 =?us-ascii?Q?RPmInZrQdmqPcJYDCL/k2acrvbZ2PjGx39kxcSivbKbrqrM6zeE2dkX+sXmo?=
 =?us-ascii?Q?h+SVSuHSkANf8K1sE2VMKB6IPPZuA8PGRgtU04QzAkeSm9SfmJpHQZPO9415?=
 =?us-ascii?Q?YfLmwTE1eZz3lWfjdEZEv6EeIhL/IyRl3G2F0C8x6XLWcmtCPzMQO2izVF/q?=
 =?us-ascii?Q?ESDOfB+rOBLLPH1HgrQgBYUnXro0jCBS/gekvqhCdYJzU/XuC3g38YHnRnlL?=
 =?us-ascii?Q?wbmFxjD1CKPNqQtZZCgk8M5a4DJh0Rx014WIaIod7GWppHn5T2PaVHa4GJ0R?=
 =?us-ascii?Q?8iI6/oOidZt/G2I4R5Qko4jreXQNQv3GqTELEqdbpL6PLENq6YTOWXZnrKxy?=
 =?us-ascii?Q?Yu8iUjSPAemfEvpT7VRuCb74aGLXfQIAEiqcNEdLhegWlCxKURM/tpXj8LIV?=
 =?us-ascii?Q?8OvLEnfEcbNECD7vXMxdsKhBKwG+mn6qWthdwGJcmzxHDpCRaQkDX5AQMJZH?=
 =?us-ascii?Q?CEtPlZ8EDx8zuiIbwrA/01m6M6eVPYdbEMhDVm719f0hB2S2Aki23scYxCkL?=
 =?us-ascii?Q?0KJDl+/qTGzGN0aaTYIBCnurGRUVdzoqkvK1FCrekz+Y0XFOdP+rhSUjpYzP?=
 =?us-ascii?Q?Jfxv9suFvnqzbBq+XYdmO6N4UFvB45OUVMtpvEQHOj7+VfDNfZ/hU580/Z+X?=
 =?us-ascii?Q?r2j9j9n7/oppFwVY3yokAq+cDxY9rDDg17rYkv2iksHp2zelIXoqbJBe8ZjA?=
 =?us-ascii?Q?YzWBtV91BvcWcP4wwm6myggSCE2bgci6rmMrm3171vcJBJNpe/NjvjbPtnYw?=
 =?us-ascii?Q?URE7fQsJtKHk4OcYOkjHGgZNvsjI/VSjn2japC9LOU7+0Iy2vcR7T7sI944G?=
 =?us-ascii?Q?MRBNMCruWTuzoQaUDwfH3kJCI9s76pAoi1PMshwqr0d6cTz7TK0fYHsBjut3?=
 =?us-ascii?Q?c+jRxyKMAj1PDsZGoqR4dQd9lG0sB55Ddv7rQM3KINY3GBMdK1gVFr40u8uh?=
 =?us-ascii?Q?+xkitBRxfDG4dZH7n4SiTOzWzl81n2I1Xu1h9Gfs5M/Rf7PsGvhwgVbgnCJA?=
 =?us-ascii?Q?2OTsBmkI9OETd4jNbk4AdA5XglpgDLiZAW7R1qVMEvrz13hRqCU5R1wPiWA5?=
 =?us-ascii?Q?mtPqdJe4x1MxC3/PeCiGIQdA0uNC5TB+21F9xzKs5gvmeHOqedG5SjWuY72a?=
 =?us-ascii?Q?qbww7PXIlM8Tmr1P9OeGVnYT0jqTGOr/CS+KkVVms5Svcs8b6RxQgMSYFdHp?=
 =?us-ascii?Q?VjprcLr/Je9Yml3QIjqpEstfinoL6WucNTP+2amq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 608a4050-6233-42fd-5ebd-08db0581d0cd
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6206.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 00:58:51.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f22s6EC8C36/8/79BwRDQ1nsHqYYDnI39bT/wdDtCbvnJIbJxOhf9nBhIZWfvKxbprY7YJKB0S3N+5N3oBW5/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7773
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-20 at 20:24:30 -0800, Yury Norov wrote:
> The function finds Nth set CPU in a given cpumask starting from a given
> node.
> 
> Leveraging the fact that each hop in sched_domains_numa_masks includes the
> same or greater number of CPUs than the previous one, we can use binary
> search on hops instead of linear walk, which makes the overall complexity
> of O(log n) in terms of number of cpumask_weight() calls.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> Acked-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Peter Lafreniere <peter@n8pjl.ca>
> ---
>  include/linux/topology.h |  8 ++++++
>  kernel/sched/topology.c  | 57 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
>
[snip] 
> + * sched_numa_find_nth_cpu() - given the NUMA topology, find the Nth next cpu
> + *                             closest to @cpu from @cpumask.
Just minor question, the @cpu below is used as the index, right? What does "close to @cpu"
mean above?
> + * cpumask: cpumask to find a cpu from
> + * cpu: Nth cpu to find
Maybe also add description for @node?

thanks,
Chenyu
