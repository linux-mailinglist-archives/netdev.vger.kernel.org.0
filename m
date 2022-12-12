Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC6664A49C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 17:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiLLQMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 11:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiLLQMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 11:12:13 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B16625B;
        Mon, 12 Dec 2022 08:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670861532; x=1702397532;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VAwLrVJTglVQxi8juiA/u3hrTmue0wSjqTYLt40QcEA=;
  b=n0IqWw5J9TL5eBs95WqzqK3lDyY85gISMry3fJKHHkLDfXMIQXokBMXL
   F8C211xUVGkFGjNpjjA3MDi1Sx/+nc/1iXTfcge+2SS+WYktQ4Y5dZ12F
   IQNGpdzBKGYV7E8u7U96388Rq64bXJnqevUecWMnQ2hdRDJO4vGiHWqs3
   hyBEbnGMhqAIlqNJy1+O/I2mYNzP4w+3V9e///AATlbRoQ6xdxkiBx0yz
   YoXkGyIUQtzeHFtrddjNvLJg7qJ9kf59BG35RliwBj5wMcZdMdiypxeDc
   bHk41GCZNhWPGQj2zKK9/sjlBfq0QfvigPyznGt2ZGKQ02Hkgt6uxsNOA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="382202536"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="382202536"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 08:11:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="755001147"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="755001147"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 12 Dec 2022 08:11:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 08:11:08 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 08:11:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 08:11:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 08:11:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4vL9ZW1LtEUw/kX1ftsjzVuAJ6cR9tr6SYrNZAlHF9uEBCSzMRyuFPZ2sVgz4m+J5st281PdLuHR70BgBoxYrfyzNcDIq4ISZ2KP6ZHbsU+AFaE4M/aKnkHvmmrRb72rUZksadZqCrlXwE5QtNWIv2ZsatbKzJdlUUMOnu2S4V4WygpDguxIqkJJSprtHnIARrEsiqOlbYMXT6QaHxl05GElq7/pJ5+dCOnfO42/sV121nduJrxLtPqTY8FIY1wHZw0Q3fuBhvRq+tYcz7kUVYMsPVxQcB8Vsxr7ARG3VdBSavTes2nWJpa332hULFyzPPQRW+u/6mYOtJ2GM9EMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47C+Ld5Bak4AnBMPFwBLKdnAua2IJh9sQKMSqZajsXg=;
 b=IMVFz5pS+VfFploVytJlS3s5kV2y6q1oaZj+BE5cHHDjNaos+xAYol6bj8TnXj07X/COkaQ8RF/P/ARYoKOyG8P/l7zbYVa/kTMm16dvF5YEmVegfqgNrj4RQ7F2LdcgdyPv8VKY230jeDfTy95fuSEg2rQCXR02C7ICRa06iu21jtEZqmGqNzTNEwpoYJoR8NQBvlNdeWmZX8DA9Sgq+psmg8WHDsS44Wtt//psoN0UDu6dsSNE/QOvlBXclbe++uMGOeAxfVSSn686rEf5baZQnrfsCUYZseI8JKaNnTj0SkMOlHoFOYvBh8+jfNYDngLNoR1fCIS11/kcXz+hKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB6194.namprd11.prod.outlook.com (2603:10b6:208:3ea::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 16:11:06 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 16:11:06 +0000
Date:   Mon, 12 Dec 2022 17:10:54 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 13/15] selftests/xsk: merge dual and single
 thread dispatchers
Message-ID: <Y5dSjs6AJYr6KqQK@boxer>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-14-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221206090826.2957-14-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR0P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::20) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: a91a4817-a4d7-402f-a291-08dadc5b7971
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bPoH1BFoVU6aHx3GUJHbj06L4zGeBBLuV5y5BzcO3iT8Dicvx4GlKG5vCjShHIQWf5quhHvmZcmIJJuKtrVeAT0+kO88VoBGwKeE1si9alZiA1OJmAkLlOmlLCaPY1a8HvnFVxXPVvigxpqZj9D4Srq9uUalo8hRt5fR5iiSHNjpC2bwN9No/kG/s+ecZaX+/ivXaaqtx23gbS2HUHUDnoTa/LtXEDBSQZAgkxShMQW9C9fDEvxt+Ofy36Dly8kNcZLqY1bTxNd0RbZZiZ2zniKhanYhBud/+RNlXf14w3znApCKDkiTuYUvu1jf2a9K1OpJ4szwXOZpYgvGLShpPHoQjn0WkcFANVTQseB0ZSdPUn0OGY2AtYtHWKbaROfJzWkeTVVbYZdyc/oZhW9wEeSITwreY1mD9CCw+zouc6tLfrizhEgJ0wpWYnfjHpn+OU2G8s/ZgNxXf+FKleF2FZhJLezX5yvo7BVX7OQWkoHm/o2bSJKYIuAC1dUgaSGloXpMnYSua+AhICKCUmkp0KPWl48s0wKZ3h9aos79CZoSg99WOPfNu+etjzgXi1B1T5oWvI+D9r6GMfUnizvCxZZfhmAD/WfZJnwbqNYBr7RRwG/Yu74Osct0TCmFzAQMyw9HC8/JpxksCAicKkY24nIYkzXkVBFXA00bTuF9N6wWuWRSj5/vn82f241u2/1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199015)(4326008)(41300700001)(5660300002)(8936002)(7416002)(44832011)(316002)(86362001)(66556008)(66946007)(66476007)(8676002)(6916009)(6486002)(83380400001)(38100700002)(478600001)(82960400001)(2906002)(6512007)(9686003)(26005)(6506007)(186003)(6666004)(33716001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BS2WejsHh2hg02A8J7UutRPNGVyVbGPiptNqZxS3EQXVagmA4Im1jDmGZ4S8?=
 =?us-ascii?Q?9c6gsTTSDvodJCzh21czql7kijHViAV0EzvMNmE7JqF21a5QBw0G5EN1Q23w?=
 =?us-ascii?Q?Nlx1TXhKikfuJRy7YucM0pSLQYkSuqaS7ALHtB5G0ci6nqrCwvfPHaPhHMo+?=
 =?us-ascii?Q?/cajoA/ktkp9GW63OzJqcNrTJp0sFx9Wpoz5NCW3oS3ogLdFVW4roeZfEyY0?=
 =?us-ascii?Q?pLBK1LbYme0LCcgHV984Q8dqwltgFn2bNiGLd9DrqcHx9jobWz8TIikW9V/J?=
 =?us-ascii?Q?btAsy4lmffEK6H/y2E393gST/TunSOiEFcNfJs99on+T1BzSCFuKAGe5v2vc?=
 =?us-ascii?Q?VDXkD/wpdx8vtFZx3iF8grQITpyRiDOoddHAdUi8rUz4Bo6aQW+vljapmPIu?=
 =?us-ascii?Q?+p1rEpCj/wXCVmPS87llU5HJoLl9VSeehI+8ToHWLmwXxYYVB8FEXR/tNieV?=
 =?us-ascii?Q?7W/e6IJN/9sAo6cImYoSlD6oFyb+44gXr5EKN0tipaXPiwJF1b1VW+Ci6g56?=
 =?us-ascii?Q?8BQYZR8sV918ln1E1jlrUMa7nxO9o8vLLuA5g02j4N/oFbDVki/utxTOvEIt?=
 =?us-ascii?Q?VxIoRhS9Br4X0oxpwFjPMsA32+vWdXXU7jTKRIrGH+7D8yuVRaW4/v6z53Iw?=
 =?us-ascii?Q?wtrxiDTkvgr1LtO//SaJ/uyR/CM/WtriNEyocqJLoHn7zI8C3yMUouf8NuFM?=
 =?us-ascii?Q?2z0qF6LVHhaEY7PhIfhw3X7dipyd1703Dy0L2novWqur/gYb4jvOhOddz/0P?=
 =?us-ascii?Q?EGfASXUID4PHm7fgMjc2L3jLzat02tFEP7LT8TtwlJRI9lBIS0vVYBYd0w4b?=
 =?us-ascii?Q?fHAWPHxZsr4my8UgAPm0xm7eRxSkMSEv4Hk5J1iDMJpAPF1YX8awdDHduKj7?=
 =?us-ascii?Q?wdKYcUFaBsTGdFgh8iXXJOxa2clZChP8C0pvCwdsGEYcj6PT14uCKysC5O9s?=
 =?us-ascii?Q?M32l/+8MSYD2p67+KVN52IkYU2JrWz7qVpElqy1B+nk8mH6z26Qcbxs3Ep5L?=
 =?us-ascii?Q?fW5DXt/ulXcKI1snSAKPkUXXGtfW0eA0rpsLkfSoz61iIoV+Jv6578erkoMU?=
 =?us-ascii?Q?c8hNs37mkCueiX/oYaEmHJ2kH5uj97qkFlIRWY6mwHRM3WOuIv2SpHYepguo?=
 =?us-ascii?Q?w2EkNqxtmBMp/M9PTbYt49aIyNRYNdjLu4qkJri6Xw2OcOxTCX26DH+6Wola?=
 =?us-ascii?Q?RYVddMpTJH0sBAKcP/E9Quemb4utkSzSArS3wGPiUsB/VdqKvLOxGecitghX?=
 =?us-ascii?Q?FDGl2VMl6lrElT8tS13o6aqcf/MUeYcdFl9lPRrcWMAN57N3oFhN8MG3xGsF?=
 =?us-ascii?Q?Qu5ASWTPSnRE9lHjMBS8sdLwwU3E+S+hbfxRx/mzXBup2IC17E3OawZyfejk?=
 =?us-ascii?Q?lMhIcmivFLYbjpUrRTz7ppL1CNBFRYnryStZQd29Aor8uPSp8OcOIsxVvHEj?=
 =?us-ascii?Q?KnKU4D5zzVrGhoTuPi/hWrdmElq5bQ7b33FTjuZ4lcsTDzEPY2oRkKD6rV0+?=
 =?us-ascii?Q?45ya8CoPFuR45zIuiEHT1+nCLhYPhv8PN0c5A7wDxzi6nR3Lo02AFBAT40dG?=
 =?us-ascii?Q?HdJ1fIpE7JKppckmMLE52ZLGo5K/v/ht83SvV7WAWLi9Rj7APPCq10gHD2iI?=
 =?us-ascii?Q?nswbqnF3OTWNy9mEHkwPlmo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a91a4817-a4d7-402f-a291-08dadc5b7971
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 16:11:06.5377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GiQroPtmsN1Q8zY7rDTtpROAxuHZbtZA92Jk15/zbaSBpHvTUb2Km8MQUCrWWYIJ5dxRTLR01DyL/gdq6kCsJ7ECDssjFcCKMlgT1ncLQlU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:08:24AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Make the thread dispatching code common by unifying the dual and
> single thread dispatcher code. This so we do not have to add code in
> two places in upcoming commits.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 120 ++++++++++-------------
>  1 file changed, 54 insertions(+), 66 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 522dc1d69c17..0457874c0995 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1364,85 +1364,61 @@ static void handler(int signum)
>  	pthread_exit(NULL);
>  }
>  
> -static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
> -						  enum test_type type)
> +static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj_rx,
> +				      struct ifobject *ifobj_tx)
>  {
> -	bool old_shared_umem = ifobj->shared_umem;
> -	pthread_t t0;
> -
> -	if (pthread_barrier_init(&barr, NULL, 2))
> -		exit_with_error(errno);
> -
> -	test->current_step++;
> -	if (type == TEST_TYPE_POLL_RXQ_TMOUT)
> -		pkt_stream_reset(ifobj->pkt_stream);
> -	pkts_in_flight = 0;
> -
> -	test->ifobj_rx->shared_umem = false;
> -	test->ifobj_tx->shared_umem = false;
> -
> -	signal(SIGUSR1, handler);
> -	/* Spawn thread */
> -	pthread_create(&t0, NULL, ifobj->func_ptr, test);
> -
> -	if (type != TEST_TYPE_POLL_TXQ_TMOUT)
> -		pthread_barrier_wait(&barr);
> -
> -	if (pthread_barrier_destroy(&barr))
> -		exit_with_error(errno);
> -
> -	pthread_kill(t0, SIGUSR1);
> -	pthread_join(t0, NULL);
> -
> -	if (test->total_steps == test->current_step || test->fail) {
> -		xsk_socket__delete(ifobj->xsk->xsk);
> -		xsk_clear_xskmap(ifobj->xskmap);
> -		testapp_clean_xsk_umem(ifobj);
> -	}
> -
> -	test->ifobj_rx->shared_umem = old_shared_umem;
> -	test->ifobj_tx->shared_umem = old_shared_umem;
> -
> -	return !!test->fail;
> -}
> -
> -static int testapp_validate_traffic(struct test_spec *test)
> -{
> -	struct ifobject *ifobj_tx = test->ifobj_tx;
> -	struct ifobject *ifobj_rx = test->ifobj_rx;
>  	pthread_t t0, t1;
>  
> -	if (pthread_barrier_init(&barr, NULL, 2))
> -		exit_with_error(errno);
> +	if (ifobj_tx)
> +		if (pthread_barrier_init(&barr, NULL, 2))
> +			exit_with_error(errno);
>  
>  	test->current_step++;
>  	pkt_stream_reset(ifobj_rx->pkt_stream);
>  	pkts_in_flight = 0;
>  
> +	signal(SIGUSR1, handler);
>  	/*Spawn RX thread */
>  	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
>  
> -	pthread_barrier_wait(&barr);
> -	if (pthread_barrier_destroy(&barr))
> -		exit_with_error(errno);
> +	if (ifobj_tx) {
> +		pthread_barrier_wait(&barr);
> +		if (pthread_barrier_destroy(&barr))
> +			exit_with_error(errno);
>  
> -	/*Spawn TX thread */
> -	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
> +		/*Spawn TX thread */
> +		pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
>  
> -	pthread_join(t1, NULL);
> -	pthread_join(t0, NULL);
> +		pthread_join(t1, NULL);
> +	}
> +
> +	if (!ifobj_tx)
> +		pthread_kill(t0, SIGUSR1);
> +	else
> +		pthread_join(t0, NULL);
>  
>  	if (test->total_steps == test->current_step || test->fail) {
> -		xsk_socket__delete(ifobj_tx->xsk->xsk);
> +		if (ifobj_tx)
> +			xsk_socket__delete(ifobj_tx->xsk->xsk);
>  		xsk_socket__delete(ifobj_rx->xsk->xsk);
>  		testapp_clean_xsk_umem(ifobj_rx);
> -		if (!ifobj_tx->shared_umem)
> +		if (ifobj_tx && !ifobj_tx->shared_umem)
>  			testapp_clean_xsk_umem(ifobj_tx);
>  	}
>  
>  	return !!test->fail;
>  }
>  
> +static int testapp_validate_traffic(struct test_spec *test)
> +{
> +	return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
> +}
> +
> +static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
> +{
> +	return __testapp_validate_traffic(test, ifobj, NULL);

One minor comment here is that for single thread we either spawn Rx or Tx
thread, whereas reading the code one could tell that single threaded test
works only on Rx.

Maybe rename to ifobj1 ifobj2 from ifobj_rx ifobj_rx? everything within is
generic, like, we have func_ptr, not tx_func_ptr, so this won't look odd
with ifobj1 as a name.

> +}
> +
>  static void testapp_teardown(struct test_spec *test)
>  {
>  	int i;
> @@ -1684,6 +1660,26 @@ static void testapp_xdp_drop(struct test_spec *test)
>  	ifobj->xskmap = ifobj->def_prog->maps.xsk;
>  }
>  
> +static void testapp_poll_txq_tmout(struct test_spec *test)
> +{
> +	test_spec_set_name(test, "POLL_TXQ_FULL");
> +
> +	test->ifobj_tx->use_poll = true;
> +	/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
> +	test->ifobj_tx->umem->frame_size = 2048;
> +	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> +	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
> +
> +	pkt_stream_restore_default(test);
> +}
> +
> +static void testapp_poll_rxq_tmout(struct test_spec *test)
> +{
> +	test_spec_set_name(test, "POLL_RXQ_EMPTY");
> +	test->ifobj_rx->use_poll = true;
> +	testapp_validate_traffic_single_thread(test, test->ifobj_rx);
> +}
> +
>  static int xsk_load_xdp_programs(struct ifobject *ifobj)
>  {
>  	ifobj->def_prog = xsk_def_prog__open_and_load();
> @@ -1799,18 +1795,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  		testapp_validate_traffic(test);
>  		break;
>  	case TEST_TYPE_POLL_TXQ_TMOUT:
> -		test_spec_set_name(test, "POLL_TXQ_FULL");
> -		test->ifobj_tx->use_poll = true;
> -		/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
> -		test->ifobj_tx->umem->frame_size = 2048;
> -		pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> -		testapp_validate_traffic_single_thread(test, test->ifobj_tx, type);
> -		pkt_stream_restore_default(test);
> +		testapp_poll_txq_tmout(test);
>  		break;
>  	case TEST_TYPE_POLL_RXQ_TMOUT:
> -		test_spec_set_name(test, "POLL_RXQ_EMPTY");
> -		test->ifobj_rx->use_poll = true;
> -		testapp_validate_traffic_single_thread(test, test->ifobj_rx, type);
> +		testapp_poll_rxq_tmout(test);
>  		break;
>  	case TEST_TYPE_ALIGNED_INV_DESC:
>  		test_spec_set_name(test, "ALIGNED_INV_DESC");
> -- 
> 2.34.1
> 
