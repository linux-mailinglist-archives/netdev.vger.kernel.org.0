Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9864B65D
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 14:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiLMNey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 08:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbiLMNea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 08:34:30 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A371AA0E;
        Tue, 13 Dec 2022 05:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670938449; x=1702474449;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yZ5oXWt0DNTW5e165xS3dKS3AAQ6ED3wTA1VQBebcV8=;
  b=kwW75huHu75uK9ZwuUSyQlt9pUeGI/2tDFb3zcYVdr7dsDpNqqSsgLN7
   6zorqg+oTg3oS869vSmfZ9rSlOZ6kPlYbfw1uaUuhDF/wAcypjNivpteH
   ANOlVGp5rUGa2tOPNdDxuqA56KCChJ66TWh3OTEfSoXWltYMVZ0JPEvHb
   wvc7NiZ5VlUhBfHhJ+SQLfPsLveKsiCfefmgBdh3JyKFEdxxcgfN0yp3q
   pfc5bAHtzR8d2h4hDtwl9TcjPfyyQ85N1kgsyacWLJ2PA1188OVvsylSa
   Y71xfScCOZ0C/udEU2MQiH9X4FcuXfuHY1j4I8D6SxJB8slsYSv3NwqjO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="315767858"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="315767858"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 05:34:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="717229051"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="717229051"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 13 Dec 2022 05:34:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 05:34:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 05:34:08 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 05:34:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYXoRWfVTUr+kIHgYF2Lc76IPEgF5cPQKSP84KuuefkfL6Dj965OPOzuBrwSHE9Odehy2dTr33KGd/olkrNOejG5gYC83D/mJxV1VPrRlFzz+O/qZFQK1Xh+10sm8C9jF9iSxIYL7XmUpRHYKtrBBBts727VmAIzNh3NSrQrFQXNg3Z2xiZIR6mzATKwBVmN1yyMObAB0WVEwwncgVTbQNB0ot2ht7GsFKICnGyIi1ncOCEN/Rqgi9KNzSqQzgMYzaTSC9LOjiFkT6HGcfBI8jd7I2VJBwQroD/L5fb6tbpF/niYPEO/T7X+MerJ3nu/speCN0ND73E3eO2d9OmogQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0xYQiBjlupEB+372Yu1e1JOI6UUHDYZQ0uLZaquqYE=;
 b=khKsIubmYCHi5ZgclHMeY3g862jl2ZluNBS7z+LAbge8E5r1ksaVXj1mDRYIdG2MxziPrPxZLGjAa6BpQbpYfm+begfthK6umxqx8XyobGjtFi3GBqE36OYqzbzbxO9NBRlWjUmZ+lKOqM1xrMA4shImqrVqSabSN98aI8CdH1pyTHZ+B2v1V/4oWJCMnu9uGI5yXX0l99mxCBZ8RLmRp00NXpv+P1q6D2oAJTekump9o/hA1tzVX2O1A8oXaFMhjZ099JMdmXv7wJiczS/z/YbnS1aewrYYaT+vTjqSaAMAiOa7AuaDBvHUNALIIMs8IaRfFKfLaIzAIIYBuO8MUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB5597.namprd11.prod.outlook.com (2603:10b6:a03:300::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 13:34:05 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 13:34:05 +0000
Date:   Tue, 13 Dec 2022 14:33:50 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 15/15] selftests/xsk: automatically switch XDP
 programs
Message-ID: <Y5h/Pr14E4To9C2r@boxer>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-16-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221206090826.2957-16-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0164.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::18) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: bb434c26-9c44-453d-3c4e-08dadd0eb465
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EbFc1x+l3KuWnzrw9DJxdfE8jX2WAFdUwv0KVIEnIOrFQ8A/FXsaiqAKJY9tCZDM3zkXMzBsYFCIcsvvRgqf+IxfFMWwRl6mFKcNcDX1KahP3P/SLiTszUmsJZw1q93nRZhLcmrjdb1s8w6i3VfZ7et0+29yGiRkv8GOo6Iv0DHJJcypZuBtoCW7daYP3u5MK1lQv0jjyfeQb5+PrRPxwDEIihUlO2qLGcbydkqG5O68U14X+Lau/mWv+cxyS58cyJQwbQIXm/WpzzfhM/sqnlMfV4xxkawUNKmLa9aNIFiOFFNGgrMSmF++hrPVZmbrXwVb3LTLn80hUuqiZnRkxecMBudRMlLyGy6LZcAgN8jx5nAdR9KflpT8w6HzL2Zi7svwtnJd+mqHgC80tV1J/iEZk4GQ8bypkFlT6S1yR8+ow1aJ7Xb/r1b1zVPfoR6w011zmG8zJcfjwaT64LOHPuBOalZEC5XhYNfLB8iWWhCpLx2WT/hCGwLQsbDr3ey6+AtuU+XZU5bsxf5NDHUNGPUh/aBdbidSJLYoFM7331q90jjw6ZbrbHBXQW5+nU9j2evqWuPEaTUzD6iN+KdlE1gd7bU3z5Ax30rChqfDEAvgEqge0AGogdAcQXIeNeRzvHabsMw3FMf8lYiuCRuKTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(376002)(39860400002)(346002)(366004)(136003)(451199015)(33716001)(6486002)(478600001)(6506007)(2906002)(86362001)(6666004)(44832011)(82960400001)(186003)(6512007)(26005)(9686003)(38100700002)(83380400001)(41300700001)(30864003)(8936002)(5660300002)(66476007)(8676002)(66946007)(6916009)(66556008)(316002)(7416002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kCFqqboZdU7kUON6KXFDp0JxDGHUeW6W2nHI8q6DBtPvgtesXUQ2AwifInWT?=
 =?us-ascii?Q?TPCJBacWHlfUPB2BUkW3ul1LlJ8K99SojMsdQk0EMmVR9RiJqLlyjLiaR7+W?=
 =?us-ascii?Q?qqLJUvt7MDkvQKMsrFLyvUMr7v/yXSBoTSgdoBfPU7Kh2JlcAswVhiaTqANG?=
 =?us-ascii?Q?QNj0MBUY3bYwW5dwuuuCplTzbe91MOcJCZg2dj2C1CkXFLDd/qU+bV9mAP+H?=
 =?us-ascii?Q?339qS7xHPRdJDQn7QlPOz9+8U43g4hP29oRNxxSYXvWO0Z2sNZskfz84P7fd?=
 =?us-ascii?Q?L4XLxWkUSJ6ttTk3MhSRWxYA9wOPjpXQ2HFCa02n7Zho53pzRda8FHz38tMQ?=
 =?us-ascii?Q?mFx8JFC2M1r9eUWW2cMAk3R5jFRCw1cw6DqfmpIQdOm+ETXEurPUkh3G6Gjv?=
 =?us-ascii?Q?vn0JanC6jcNEk31Zk3mDwU+fOVlBqfgIT3CUxPfIlORgF6bKPckvIpFbJtzC?=
 =?us-ascii?Q?NejoN0514dqOfcR4zzmwlGEsk9y2gXo42ICbvhROEf9R1MPHSQWw0TdJGjMV?=
 =?us-ascii?Q?IhSaYTeBMbu0KMDF+sAI2RiCEtZ3b5jqXdt3ur80EqwGEexr3HugCXoRL/ax?=
 =?us-ascii?Q?5aNBNSbCnNgiRdCjsDxSSkPPuJwI8VYknPreBT2DjNXEfX9DmWkrHRdixK3v?=
 =?us-ascii?Q?j1qEjjyfWwDCaNiDHF3meAs7URjaY1e2EI0MR1iCKrrU2uzkirIHZUlQ9Ik6?=
 =?us-ascii?Q?ntGOyIigAHD2OjKJOI4IR3ChRyDJXgPjZXXzMvGqItIFz+nRAtkd4chZAQ9v?=
 =?us-ascii?Q?grZTUWC7bYcPz5qKa8ScKJMGJDpIFxqt/LhN+KKGbS/xZAWyjW8T+7suBcgM?=
 =?us-ascii?Q?7IUG+xR2YwKdqiW4a0R6Ie3F+pS6FT0rELf26hTk747B6UHrbj2KkDGg7gEH?=
 =?us-ascii?Q?Fgh6e2kSXxX7tvHeVF5h4ZygrqZAwQQ93NKYFRcRod0AtRTHLDNJ2tMRD8ba?=
 =?us-ascii?Q?WRThOW3b76EOJA6gVaA4J0herNFPhNYAHAwe16NHjC8RSlk2FHeaiCd0qXYI?=
 =?us-ascii?Q?ZnT+blMRqjd4YSjXufSXZ0qBks7ua3NN4J6AHuG2pt00kjh1sVR5WmdH5Xg5?=
 =?us-ascii?Q?6qS4Orl7Jt9iNGG81pvc+0M62w9pgdumvE5wJe4M6w1h+ViGNR1sBhVLvbGd?=
 =?us-ascii?Q?fRCMaFXo2ZDKwoXRomXonmkA95NQl8rUyJTxzqoFUcEy9zvZb9VcyrP5m1Nn?=
 =?us-ascii?Q?bBlNrIoJGFl5eUNu/+GOa1Le+bUrMDOQFHCS/LIyEJnVvDItkbk2BzSFGg9u?=
 =?us-ascii?Q?PDIVPV4h4AcHvJu+rFTqb61Zg7cMqnd6AwpZlwxGrtcrTsYn8SzAmvEglsU6?=
 =?us-ascii?Q?rwsynbLDfA96hot8WgjC0JL9z0tcjImaDIG1KsV93tFxNateYFBzC5vs1XSP?=
 =?us-ascii?Q?B2hyGwKGSuo+JkuOt4ihKv/BdVLyWqYV9cTW1ok+f/HTEeIfLWTphE5orcD0?=
 =?us-ascii?Q?f4s3ciBYHJa1qLSZJbKSIdpFye2GYTR7s+tsz28c6nNz/eYuMa0Q4B8TUC4h?=
 =?us-ascii?Q?cx61xZFq1U4+mAF/JFi5JC4rnPNFizGWgKeF2EpvZClSUHh/F4FvAWvQx5++?=
 =?us-ascii?Q?8cT3aakQbAqOPUSlvXVIS55AUiUrI9Xq1ejjJ0WwuVAjo+/UG44xU8e3aDeZ?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb434c26-9c44-453d-3c4e-08dadd0eb465
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 13:34:05.4347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onxnuswGBQIPGGAoQ2OQnw/GAGeNTlI3U0CZfnC+eJd+ybJnyY0pacBcsY76dLIiZvnFjJvAVGNLLaU8Os4tyyFkBzUhsc+cRUo6FfcvQLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5597
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:08:26AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Implement automatic switching of XDP programs and execution modes if
> needed by a test. This makes it much simpler to write a test as it
> only has to say what XDP program it needs if it is not the default
> one. This also makes it possible to remove the initial explicit
> attachment of the XDP program as well as the explicit mode switch in
> the code. These are now handled by the same code that just checks if a
> switch is necessary, so no special cases are needed.
> 
> The default XDP program for all tests is one that sends all packets to
> the AF_XDP socket. If you need another one, please use the new
> function test_spec_set_xdp_prog() to specify what XDP programs and
> maps to use for this test.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xsk.c        |  14 +++
>  tools/testing/selftests/bpf/xsk.h        |   1 +
>  tools/testing/selftests/bpf/xskxceiver.c | 150 ++++++++++++-----------
>  tools/testing/selftests/bpf/xskxceiver.h |   7 +-
>  4 files changed, 102 insertions(+), 70 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
> index dc6b47280ec4..d9d44a29c7cc 100644
> --- a/tools/testing/selftests/bpf/xsk.c
> +++ b/tools/testing/selftests/bpf/xsk.c
> @@ -267,6 +267,20 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, void *umem_area,
>  	return err;
>  }
>  
> +bool xsk_is_in_drv_mode(u32 ifindex)

any reason why this can't live in xskxceiver currently?

> +{
> +	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> +	int ret;
> +
> +	ret = bpf_xdp_query(ifindex, XDP_FLAGS_DRV_MODE, &opts);
> +	if (ret) {
> +		printf("DRV mode query returned error %s\n", strerror(errno));
> +		return false;
> +	}
> +
> +	return opts.attach_mode == XDP_ATTACHED_DRV;
> +}
> +
>  int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags)
>  {
>  	int prog_fd;
> diff --git a/tools/testing/selftests/bpf/xsk.h b/tools/testing/selftests/bpf/xsk.h
> index 5624d31b8db7..3cb9d69589b8 100644
> --- a/tools/testing/selftests/bpf/xsk.h
> +++ b/tools/testing/selftests/bpf/xsk.h
> @@ -201,6 +201,7 @@ int xsk_attach_xdp_program(struct bpf_program *prog, int ifindex, u32 xdp_flags)
>  void xsk_detach_xdp_program(int ifindex, u32 xdp_flags);
>  int xsk_update_xskmap(struct bpf_map *map, struct xsk_socket *xsk);
>  void xsk_clear_xskmap(struct bpf_map *map);
> +bool xsk_is_in_drv_mode(u32 ifindex);
>  
>  struct xsk_socket_config {
>  	__u32 rx_size;
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 26cd64d4209f..ae9370f7145e 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -96,6 +96,9 @@
>  #include <time.h>
>  #include <unistd.h>
>  #include <stdatomic.h>
> +
> +#include "xsk_def_prog.skel.h"
> +#include "xsk_xdp_drop.skel.h"
>  #include "xsk.h"
>  #include "xskxceiver.h"
>  #include <bpf/bpf.h>
> @@ -362,7 +365,6 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
>  	xsk = calloc(1, sizeof(struct xsk_socket_info));
>  	if (!xsk)
>  		goto out;
> -	ifobject->xdp_flags = XDP_FLAGS_DRV_MODE;
>  	ifobject->bind_flags = XDP_USE_NEED_WAKEUP | XDP_ZEROCOPY;
>  	ifobject->rx_on = true;
>  	xsk->rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> @@ -501,6 +503,10 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
>  	test->total_steps = 1;
>  	test->nb_sockets = 1;
>  	test->fail = false;
> +	test->xdp_prog_rx = ifobj_rx->def_prog->progs.xsk_def_prog;
> +	test->xskmap_rx = ifobj_rx->def_prog->maps.xsk;
> +	test->xdp_prog_tx = ifobj_tx->def_prog->progs.xsk_def_prog;
> +	test->xskmap_tx = ifobj_tx->def_prog->maps.xsk;
>  }
>  
>  static void test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
> @@ -540,6 +546,16 @@ static void test_spec_set_name(struct test_spec *test, const char *name)
>  	strncpy(test->name, name, MAX_TEST_NAME_SIZE);
>  }
>  
> +static void test_spec_set_xdp_prog(struct test_spec *test, struct bpf_program *xdp_prog_rx,
> +				   struct bpf_program *xdp_prog_tx, struct bpf_map *xskmap_rx,
> +				   struct bpf_map *xskmap_tx)
> +{
> +	test->xdp_prog_rx = xdp_prog_rx;
> +	test->xdp_prog_tx = xdp_prog_tx;
> +	test->xskmap_rx = xskmap_rx;
> +	test->xskmap_tx = xskmap_tx;
> +}
> +
>  static void pkt_stream_reset(struct pkt_stream *pkt_stream)
>  {
>  	if (pkt_stream)
> @@ -1364,6 +1380,57 @@ static void handler(int signum)
>  	pthread_exit(NULL);
>  }
>  
> +static bool xdp_prog_changed(struct test_spec *test, struct ifobject *ifobj)
> +{
> +	return ifobj->xdp_prog != test->xdp_prog_rx || ifobj->mode != test->mode;
> +}
> +
> +static void xsk_attach_xdp_progs(struct test_spec *test, struct ifobject *ifobj_rx,
> +				 struct ifobject *ifobj_tx)
> +{
> +	int err;
> +
> +	if (xdp_prog_changed(test, ifobj_rx)) {
> +		xsk_detach_xdp_program(ifobj_rx->ifindex, mode_to_xdp_flags(ifobj_rx->mode));
> +		err = xsk_attach_xdp_program(test->xdp_prog_rx, ifobj_rx->ifindex,
> +					     mode_to_xdp_flags(test->mode));
> +		if (err) {
> +			printf("Error attaching XDP program\n");
> +			exit_with_error(-err);
> +		}
> +
> +		if (ifobj_rx->mode != test->mode && test->mode == TEST_MODE_DRV)

This strictly implies that TEST_MODE_SKB is followed by TEST_MODE_DRV,
correct? What if I would swap the order of the tests?

IOW why is it specific to TEST_MODE_DRV? I know that current code also
implies that, but maybe making it generic would make it easier to for
example run a standalone test later on?

> +			if (!xsk_is_in_drv_mode(ifobj_rx->ifindex)) {
> +				ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
> +				exit_with_error(EINVAL);
> +			}
> +
> +		ifobj_rx->xdp_prog = test->xdp_prog_rx;
> +		ifobj_rx->xskmap = test->xskmap_rx;
> +		ifobj_rx->mode = test->mode;
> +	}
> +
> +	if (ifobj_tx && !ifobj_tx->shared_umem && xdp_prog_changed(test, ifobj_tx)) {
> +		xsk_detach_xdp_program(ifobj_tx->ifindex, mode_to_xdp_flags(ifobj_tx->mode));
> +		err = xsk_attach_xdp_program(test->xdp_prog_tx, ifobj_tx->ifindex,
> +					     mode_to_xdp_flags(test->mode));
> +		if (err) {
> +			printf("Error attaching XDP program\n");
> +			exit_with_error(-err);
> +		}
> +
> +		if (ifobj_rx->mode != test->mode && test->mode == TEST_MODE_DRV)
> +			if (!xsk_is_in_drv_mode(ifobj_tx->ifindex)) {
> +				ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
> +				exit_with_error(EINVAL);
> +			}
> +
> +		ifobj_tx->xdp_prog = test->xdp_prog_tx;
> +		ifobj_tx->xskmap = test->xskmap_tx;
> +		ifobj_tx->mode = test->mode;
> +	}

All of the code above is repeated for ifobj_rx. So what if we do this:

/* FIXME: proper args and naming */
static void xsk_reattach_prog(int xyz, int abc)
{
	xsk_detach_xdp_program(ifobj_tx->ifindex, mode_to_xdp_flags(ifobj_tx->mode));
	err = xsk_attach_xdp_program(test->xdp_prog_tx, ifobj_tx->ifindex,
				     mode_to_xdp_flags(test->mode));
	if (err) {
		printf("Error attaching XDP program\n");
		exit_with_error(-err);
	}

	if (ifobj_rx->mode != test->mode && test->mode == TEST_MODE_DRV)
		if (!xsk_is_in_drv_mode(ifobj_tx->ifindex)) {
			ksft_print_msg("ERROR: XDP prog not in DRV mode\n");
			exit_with_error(EINVAL);
		}

	ifobj_tx->xdp_prog = test->xdp_prog_tx;
	ifobj_tx->xskmap = test->xskmap_tx;
	ifobj_tx->mode = test->mode;
}

Then in xsk_attach_xdp_progs:

	if (xdp_prog_changed(test, ifobj_rx)) {
		xsk_reattach_prog(xyz, abc);

	if (!ifobj_tx || ifobj_tx->shared_umem)
		return;

	if (xdp_prog_changed(test, ifobj_tx))
		xsk_reattach_prog(xyz, abc);

?

> +}
> +
>  static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj_rx,
>  				      struct ifobject *ifobj_tx)
>  {
> @@ -1411,7 +1478,11 @@ static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *i
>  
>  static int testapp_validate_traffic(struct test_spec *test)
>  {
> -	return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
> +	struct ifobject *ifobj_rx = test->ifobj_rx;
> +	struct ifobject *ifobj_tx = test->ifobj_tx;
> +
> +	xsk_attach_xdp_progs(test, ifobj_rx, ifobj_tx);
> +	return __testapp_validate_traffic(test, ifobj_rx, ifobj_tx);
>  }
>  
>  static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
> @@ -1454,7 +1525,7 @@ static void testapp_bidi(struct test_spec *test)
>  
>  	print_verbose("Switching Tx/Rx vectors\n");
>  	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
> -	testapp_validate_traffic(test);
> +	__testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
>  
>  	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
>  }
> @@ -1623,31 +1694,15 @@ static void testapp_invalid_desc(struct test_spec *test)
>  
>  static void testapp_xdp_drop(struct test_spec *test)
>  {
> -	struct ifobject *ifobj = test->ifobj_rx;
> -	int err;
> +	struct xsk_xdp_drop *skel_rx = test->ifobj_rx->xdp_drop;
> +	struct xsk_xdp_drop *skel_tx = test->ifobj_tx->xdp_drop;
>  
>  	test_spec_set_name(test, "XDP_CONSUMES_SOME_PACKETS");
> -	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> -	err = xsk_attach_xdp_program(ifobj->xdp_drop->progs.xsk_xdp_drop, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (err) {
> -		printf("Error attaching XDP_DROP program\n");
> -		test->fail = true;
> -		return;
> -	}
> -	ifobj->xskmap = ifobj->xdp_drop->maps.xsk;
> +	test_spec_set_xdp_prog(test, skel_rx->progs.xsk_xdp_drop, skel_tx->progs.xsk_xdp_drop,
> +			       skel_rx->maps.xsk, skel_tx->maps.xsk);
>  
>  	pkt_stream_receive_half(test);
>  	testapp_validate_traffic(test);
> -
> -	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> -	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (err) {
> -		printf("Error restoring default XDP program\n");
> -		exit_with_error(-err);
> -	}
> -	ifobj->xskmap = ifobj->def_prog->maps.xsk;
>  }
>  
>  static void testapp_poll_txq_tmout(struct test_spec *test)
> @@ -1689,7 +1744,7 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
>  
>  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
>  		       const char *dst_ip, const char *src_ip, const u16 dst_port,
> -		       const u16 src_port, thread_func_t func_ptr, bool load_xdp)
> +		       const u16 src_port, thread_func_t func_ptr)
>  {
>  	struct in_addr ip;
>  	int err;
> @@ -1708,23 +1763,11 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
>  
>  	ifobj->func_ptr = func_ptr;
>  
> -	if (!load_xdp)
> -		return;
> -
>  	err = xsk_load_xdp_programs(ifobj);
>  	if (err) {
>  		printf("Error loading XDP program\n");
>  		exit_with_error(err);
>  	}
> -
> -	ifobj->xdp_flags = mode_to_xdp_flags(TEST_MODE_SKB);
> -	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (err) {
> -		printf("Error attaching XDP program\n");
> -		exit_with_error(-err);
> -	}
> -	ifobj->xskmap = ifobj->def_prog->maps.xsk;
>  }
>  
>  static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
> @@ -1886,31 +1929,6 @@ static bool is_xdp_supported(int ifindex)
>  	return true;
>  }
>  
> -static void change_to_drv_mode(struct ifobject *ifobj)
> -{
> -	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
> -	int ret;
> -
> -	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
> -	ifobj->xdp_flags = XDP_FLAGS_DRV_MODE;
> -	ret = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
> -				     ifobj->xdp_flags);
> -	if (ret) {
> -		printf("Error attaching XDP program\n");
> -		exit_with_error(-ret);
> -	}
> -	ifobj->xskmap = ifobj->def_prog->maps.xsk;
> -
> -	ret = bpf_xdp_query(ifobj->ifindex, XDP_FLAGS_DRV_MODE, &opts);
> -	if (ret)
> -		exit_with_error(errno);
> -
> -	if (opts.attach_mode != XDP_ATTACHED_DRV) {
> -		ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
> -		exit_with_error(EINVAL);
> -	}
> -}
> -
>  int main(int argc, char **argv)
>  {
>  	struct pkt_stream *rx_pkt_stream_default;
> @@ -1951,9 +1969,9 @@ int main(int argc, char **argv)
>  	}
>  
>  	init_iface(ifobj_rx, MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2,
> -		   worker_testapp_validate_rx, true);
> +		   worker_testapp_validate_rx);
>  	init_iface(ifobj_tx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
> -		   worker_testapp_validate_tx, !shared_netdev);
> +		   worker_testapp_validate_tx);
>  
>  	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
>  	tx_pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
> @@ -1966,12 +1984,6 @@ int main(int argc, char **argv)
>  	ksft_set_plan(modes * TEST_TYPE_MAX);
>  
>  	for (i = 0; i < modes; i++) {
> -		if (i == TEST_MODE_DRV) {
> -			change_to_drv_mode(ifobj_rx);
> -			if (!shared_netdev)
> -				change_to_drv_mode(ifobj_tx);
> -		}
> -
>  		for (j = 0; j < TEST_TYPE_MAX; j++) {
>  			test_spec_init(&test, ifobj_tx, ifobj_rx, i);
>  			run_pkt_test(&test, i, j);
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index 3483ac240b2e..5c66908577ef 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -145,10 +145,11 @@ struct ifobject {
>  	struct xsk_def_prog *def_prog;
>  	struct xsk_xdp_drop *xdp_drop;
>  	struct bpf_map *xskmap;
> +	struct bpf_program *xdp_prog;
> +	enum test_mode mode;
>  	int ifindex;
>  	u32 dst_ip;
>  	u32 src_ip;
> -	u32 xdp_flags;
>  	u32 bind_flags;
>  	u16 src_port;
>  	u16 dst_port;
> @@ -168,6 +169,10 @@ struct test_spec {
>  	struct ifobject *ifobj_rx;
>  	struct pkt_stream *tx_pkt_stream_default;
>  	struct pkt_stream *rx_pkt_stream_default;
> +	struct bpf_program *xdp_prog_rx;
> +	struct bpf_program *xdp_prog_tx;
> +	struct bpf_map *xskmap_rx;
> +	struct bpf_map *xskmap_tx;
>  	u16 total_steps;
>  	u16 current_step;
>  	u16 nb_sockets;
> -- 
> 2.34.1
> 
