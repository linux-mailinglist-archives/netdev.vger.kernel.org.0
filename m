Return-Path: <netdev+bounces-8725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04531725653
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30F3D1C20C76
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B74B6FAB;
	Wed,  7 Jun 2023 07:48:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D4A63D7
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:48:23 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB16C213C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686124100; x=1717660100;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7jchcH81z8cwQCAX+eOss8qel755S9j4b63T9ZZy8tA=;
  b=lABXhihLUPj9+Sus/ZGRl5DOKkcrMIL7u/d7kguvy/eVRj8M3FnKO0ru
   8xqcG8xWj7sBYMnVVHt/7pfCo46b34tZW13mikfxZZEyIUwww/qbzzjuH
   brRswSj6/mFV2rHMJiCy3BYjzJEBaloT+HJv0UkCQIG64O49tWKHfn641
   4VGgEl2vaDailvy0PPLleuzz6nq+8nXXk7Zc88U89tOLbxDbRXUlYrTnk
   /+8NnczPX5tkqapCo7pY+N7Tjv9AsrnHWtRagBemtdEJijyWhRkHvCz4K
   mKb00c77JsoPl+pLf4j1MYoFHC8uUnmxBaMXrph4ZaTB4UMmCxYflVNdy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="341570385"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="341570385"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 00:48:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="712500458"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="712500458"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 07 Jun 2023 00:48:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 00:48:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 00:48:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 00:48:18 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 00:48:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i0cSNX4VbC3ZEpkvtHveHqvGrMnN2yavqIcWZwXEl74IjK67f+Lk5n0zcQJvyGFZjZy7lIgRACiHpR02Z87WnvSRNx6qZ72AAx+s/0IZMKxSIaIZiUrATe5LWthd/3nhJerdG+vmv6CAem+v55ccbilHAuduwy17LkjNy4I/GHBATdBhmsycQmkiQ5ZQT8ogkXY/u+/2Ihx/O2ovt9IibesbE4tyTl9wC5H7X4dC4MzPgY6jffdCN9W//Lm31gmEDqmD19Aqxa2Dx2uQKqBemyFGJcKgNw5Npd1zo9gZlR34oQbw3XzSJsq8I3VmxEqQcqnBrC6ECNsaOvsBUo9zUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10VpBSgV4pplURZwJOZwmEkFX5mNHk/zHFUCM5AjjRY=;
 b=CNjJmMfTi1g7en/TJ6t5xGomM9EO6YuOcz8h+ZabCrciWW5VqgZVuPvZG3/Pan89mqqOtZD9s+iSGKdAgpR/vn2W9AiSnnuzvT3lUGcx6qJ0NAJNzYyxUfrKan+eJiX2jbDykmO5i9p4io4vJW4PF9Vme/1eg/3JvXcStM2m4DpJWcZ0TvdejEE3J2d4anup6WZ7GsW3gvmfILz8RF31fjl6bUCmVja48VYZIj9FbPLlr77Du7eXh1BQC8oUYb+6q6TpCYmuAHxuk1Xbm3a4WeWfJNYEDvZF0MZP7hsCo3JbVuabzMxSUd639ylI/68mMe+AFYSgMzj68fkkBoDGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by SA3PR11MB7436.namprd11.prod.outlook.com (2603:10b6:806:307::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 07:48:11 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::35cf:8518:48ea:b10a]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::35cf:8518:48ea:b10a%6]) with mapi id 15.20.6455.028; Wed, 7 Jun 2023
 07:48:11 +0000
Date: Wed, 7 Jun 2023 15:47:59 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: David Howells <dhowells@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Eric Dumazet
	<edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, David Ahern
	<dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox
	<willy@infradead.org>, <netdev@vger.kernel.org>, <ying.huang@intel.com>,
	<feng.tang@intel.com>, <fengwei.yin@intel.com>, <oliver.sang@intel.com>
Subject: Re: [dhowells-fs:sendpage-1] [tcp] 77f5a42b2d:
 netperf.Throughput_Mbps -14.6% regression
Message-ID: <ZIA2L76MUoBLyfQf@xsang-OptiPlex-9020>
References: <202305260951.338c3bfe-oliver.sang@intel.com>
 <521116.1685091071@warthog.procyon.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <521116.1685091071@warthog.procyon.org.uk>
X-ClientProxiedBy: SG2PR02CA0093.apcprd02.prod.outlook.com
 (2603:1096:4:90::33) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|SA3PR11MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 664782fd-9ae1-4ebe-3779-08db672b8ad6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPpjLX/vWGFuakUFLwJNKXXd5J7fmb4kXQZLVL0YGdP6WbXbyk/44zuhXzggg2rvbiPBKjcQT5rivMgdn6EJJ8i1DuEbWqWih6PXmYNKv1klpprpMaOvdIr99za4bonDosgaF9UWyNYLUKx+LLQnBmm4IJHIvpeG/7f5Ax6q5uFopRp93gfrPRsymKrOTMa8ncgbwOZfwnj8Sf0EumSK0xOKXQKf2LJMYd6VBv1zOxXKbr6FhYiR+E6VoHzfCFO7knh2kdD0V31zaBZyBcfAN8QxhhcApAvYc04ownyF2GgkzcmnjGn/EdNIapDENFfZdjhHSC0eV7eU82vUwCoYn6DhtPKj9gEK5NSuGvRqaCukDe+NsXecG4dyyqApSJlRoivLvwq1XLPNuQnnv9pr/5pZugg9uTfSen0WbVNOig4WaMGNr9+u91T5excGgL33Q1jAyxS6gzuO83NBwmpArzqPBOJ6BzB455weVxOpxQjpozsppuzFK6LYL6Hrtg2NqBr58sRomcrZVmoBdIhzFdfM3BFgG6lPh0ZG9YkeIC4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199021)(8676002)(83380400001)(4326008)(6916009)(66476007)(66556008)(7416002)(8936002)(66946007)(5660300002)(316002)(54906003)(44832011)(2906002)(41300700001)(478600001)(9686003)(38100700002)(33716001)(6512007)(26005)(86362001)(186003)(6506007)(107886003)(6486002)(966005)(82960400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sD/6QZysIZi1Ej1BUDaZu7MmVOoIULWNf5b5Z+qJ9m5m+lj4K0qV+oI1lgJv?=
 =?us-ascii?Q?0hacZO7+lhO63crUiajHJT69ylTDgZmyoL8d99PA+z97UKUF3Q6JTmUWXwQG?=
 =?us-ascii?Q?l1jf16qHbZaxTwE4+iQnmlvar4TRo6O307U5d4Vd3y50GD/VHAXmL2SARamF?=
 =?us-ascii?Q?AbWVKFX+Ppvh8811Ion3L5d3m6kAPVFjuYVLKhA/p8OhEDoKQZBkxJVcMsX5?=
 =?us-ascii?Q?98Ud8Ze+UTmu9dzW2MXtvUoyrYZ4tsAM2p9wrFUgeCa9As2fXWR9v7VhxIAa?=
 =?us-ascii?Q?TUMfFGhqLQAIDJB+lHDoE5dtSnC1x16ZrtgfKxoSJvwny9/piLzqogbxrZLd?=
 =?us-ascii?Q?7JkSVUmjXuheLGiOF+19df5mQ2GrQzkHFaaLBwh7ClPTWFxKB1CxhL5MnnZC?=
 =?us-ascii?Q?+BLgWvKuz+VE6jD4gynnaId6PtJqEnX81uEtvNKF5KRwoOmJhNCr8S3UUU0B?=
 =?us-ascii?Q?AJpl5xVFBQ94/D9Yle7Xar50EjWbePTItcSauCh01u+M9aQu2b5Y4d8zRb6m?=
 =?us-ascii?Q?sNu6icfXLIO+TzaI9UxOdCGeiaHvyEhmY0XG2ENdcvM2O4eGQ+k0y9um38cP?=
 =?us-ascii?Q?NXByxW8duuB+ewZbrwlQaXASWMFo0dVLIp5gOUlr9SaMXkXKW26Va20QH8Gd?=
 =?us-ascii?Q?URV+8/YGBkrj/tOvliqS+UJWMuAwAZ3HqqrVFhAx6Sv9vWcm0W5VTbNtzXwh?=
 =?us-ascii?Q?JIUemBedA79z4XfzevmT5Lck753l6apU/Cdmc2+TYwOQZi4f7E9mSyQdT9CQ?=
 =?us-ascii?Q?QT7dhU2WyMNgxKXhk+UNGQV+q5WSvlyQmFttEDi9qUQyGUjC8ZpO/tRARX4s?=
 =?us-ascii?Q?I7njlNB5XxurLT2zCBnTlYCE4QXofEfCIiSuFGNlJATYKkS33wY7oGVmOVln?=
 =?us-ascii?Q?H/YdAW9w5Ko+z6H2+Xs59dZl+Dfq8fFx0te9a0hsdNVt5TrAW7l1HrfbHR8z?=
 =?us-ascii?Q?xxa6RahdhaKNBcVro8hrzK3fv3mkCthRDAFfK1FEiBf6GI1wNhQAn0MQeyGW?=
 =?us-ascii?Q?qHxugn+a5gnx98V8uos+6fSniD0DbCcvzxHmGGFg9Jm6q5XxsJTh0FAliuuo?=
 =?us-ascii?Q?/tD8apIiCsobnS7isAnoIKL3tTBOSUxSc73AtXMnj+3ueZs2m5vElIeKeaQ4?=
 =?us-ascii?Q?JJquMrBzSPTpISITDTpCsCdUNF6LVQJSJbHtuL9CfWAkyjv5EpJhcDN45fC/?=
 =?us-ascii?Q?IGzUZYUviwAEWvEMo4AomI1AK91C+uLHwGSB2T+EXexEqvr0CKDt6dYyF021?=
 =?us-ascii?Q?V0pA1yCmWwiwARm+VlxF/WOkTvf7ygJYGYcA90skjhJIxBfO6sqmg/QPelnS?=
 =?us-ascii?Q?4uFX8rKXqwBlUbJhIHEbLel7j2YoB8AmMRk0MITI8L7HWOEQ5PB+vrGVzf5i?=
 =?us-ascii?Q?PAo+2poE4qyuqrKqqAsKrCzZT+ek0q7YUeMiWoTD6hdjioaQsthUAhwcuhvw?=
 =?us-ascii?Q?YyIZBAWADZLDHs+ik/pwOH5wNHUBoYuKWfpAJ10Eb0L5hExS+zzgbj3dqpAS?=
 =?us-ascii?Q?qaWn6LXjm5SUWOMuX8qACb0bvp3nBA6y39AHtgXL4caBmHogoCaCOEFjFEaR?=
 =?us-ascii?Q?fbpfT3tYmkO8Sa2d+BdABk3QfDCxi22RfeL7WAk1WeFHRIj64D+Ryy+LLPYb?=
 =?us-ascii?Q?eA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 664782fd-9ae1-4ebe-3779-08db672b8ad6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 07:48:11.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cKSMxBHx0Pnq4+Af3F30p9o3Qda/DcPLpTvPx+ZCL8naW5bWT9tDXQo0HRwEeCaaXrL7B0lqo5Nf0de4raXuUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7436
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

hi, David,

On Fri, May 26, 2023 at 09:51:11AM +0100, David Howells wrote:
> kernel test robot <oliver.sang@intel.com> wrote:
> 
> > kernel test robot noticed a -14.6% regression of netperf.Throughput_Mbps on:
> 
> Okay, yes, I see something similar on my test machine.  Loopback throughput
> drops from ~32Gbit/s to ~26Gbit/s with the Convert do_tcp_sendpages patch.
> 
> But! The complete set of patches is not yet fully applied.  If you look at the
> two patches I've put on my sendpage-1 branch[1], the first brings the
> performance back to where it was before and the second bumps it up to
> ~43Gbit/s.
> 
> However, I don't want to push those into the network tree until support for
> MSG_SPLICE_PAGES is added to all the network protocols that support splicing.
> I have two more patchsets in the queue and there will be a third before I can
> get to that point.
> 
> Could you try running this branch through your tests?

sorry for late.

we tested the tip of below branch, as you said, it has better performance
even comparing to the parent of 77f5a42b2d

=========================================================================================
cluster/compiler/cpufreq_governor/ip/kconfig/nr_threads/rootfs/runtime/send_size/tbox_group/test/testcase:
  cs-localhost/gcc-11/performance/ipv4/x86_64-rhel-8.3/50%/debian-11.1-x86_64-20220510.cgz/300s/10K/lkp-icl-2sp2/TCP_SENDFILE/netperf

commit:
  b032c5b94f ("tcp: Support MSG_SPLICE_PAGES")
  77f5a42b2d ("tcp: Convert do_tcp_sendpages() to use MSG_SPLICE_PAGES")
  9d6db9b8db ("splice, net: Reimplement splice_to_socket() to pass multiple bufs to sendmsg()")

b032c5b94fdcfda3 77f5a42b2db3e39c971a7d11f0b 9d6db9b8dbfff4f947a14a85b90
---------------- --------------------------- ---------------------------
         %stddev     %change         %stddev     %change         %stddev
             \          |                \          |                \
     23176           -14.6%      19795           +21.7%      28199        netperf.Throughput_Mbps
   1483319           -14.6%    1266931           +21.7%    1804752        netperf.Throughput_total_Mbps

if you need more tests or more data, please let us know.

BTW, we noticed the reported commit has a new commit-id and now is in linux-next/master
  c5c37af6ecad95 ("tcp: Convert do_tcp_sendpages() to use MSG_SPLICE_PAGES")

and we noticed below regression still exists in current linux-next/master:

270a1c3de47e49dd c5c37af6ecad955acad82a440b8
---------------- ---------------------------
         %stddev     %change         %stddev
             \          |                \
      5458            -7.8%       5031        netperf.Throughput_Mbps
   1397479            -7.8%    1288167        netperf.Throughput_total_Mbps

since tips of below branch are not in linux-next/master so far. just FYI

> 
> Thanks,
> David
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=sendpage-1
> 
> 

