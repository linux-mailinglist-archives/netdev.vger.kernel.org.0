Return-Path: <netdev+bounces-2993-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6819704E79
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C483281576
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B210D261FE;
	Tue, 16 May 2023 13:01:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919D334CD9;
	Tue, 16 May 2023 13:01:02 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3081FD2;
	Tue, 16 May 2023 06:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684242045; x=1715778045;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5yES6UWlHAk3yctlW2JmTx6twdoSIRyZmXxmMG+24n0=;
  b=I26ACX5rmEw7crh1UWJ2P4/MuA3WfA2Ac2WYCrNz+Zv0UvzVg6Iimz7f
   k6a8HZ1PGvyqVEbjaYV770QK/H79JCAhIENt8e4MVa9O6S5TlBMRsJ3Hl
   mf2O6CFHsSl7B2RtwLa9fjlqJAOVx+O/3VixCFHybr6oB3skEjuVQrrAl
   VViQfxLmdy0yPfPOBY7eNtDJCl7LaKYjSp8M8gkSrQIklVzyHOAGKe8bv
   J2BxIAdpUWpcQ6XDFW0ybcXCIA1VFH66/QSatKbBxH1fV68JMvC4YMFxU
   uc2Z+RatScRSCiGvjSzr0V5BiFQkMl0rK7lulGv8rv/kp9bCv04KDKCni
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414875888"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="414875888"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 05:58:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="704394677"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="704394677"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 16 May 2023 05:58:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 05:58:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 05:58:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 05:58:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuUMMNXa2AQG/FwLjVGEzEtVxGuEV5hEsjjzNPptXlEJ5UZnhug7tblIYqIIyOPnhuShIcCLFduMNLXEMINUH6t8vD2fd/qwxQ1nSRRKNpnwwiZfwMEwFr5qSC7AKLIi8Azi7FjH6E1B5PJsjw8EgT8X0+g4uSnTTZVBOgfDRon6kmz1fZK4yJnhob3/P356+BjdiZ0tHfxhCETlKJ16fcWwVLo8nSqhbWssU7Na2JKc4opKxLhSNxGfeeg4E5933qwBG77aRFHPZwG6S3ucX7aZTnh2nl/rsg6BVRvKchKAirPksluN1JrMY2svGdju111lLYj7Gcz01krm1VbNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFHEou/tBv5logPrt4Rtb7BPwqEWwGQC1LjSXVbKh/U=;
 b=dv+xqvMcwPkBWN0oLcVctD5bQol5aZ+iBaciLLKIWOcxuFsT3wYd9VREmx0iU14jy57p9DMiuDmc+ebCgggslnqJFGBIatodaL2kZyBCv2i+pMVU3uuWDBnpp54sDGaNaO9Fw4bDm7pKewAuLnNHdeV+MzZtW+c1nE+3Hu8d+BLohobZ8HKeB7ig3v9JDWbYoYrynCVs8h71aEzq521rOvJSh+A2PbXHhW0eke84rzWq0RwQl8p93XYwDCnKYGh6K/FW4ZnI4zVoVhQnAinnATixbkNc46IYqBd1on1PIoaFoSDHzMjQIM1uaD9a+PS0A9ax4Z+u1gIQDTE4Tjj7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB6671.namprd11.prod.outlook.com (2603:10b6:a03:44b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.24; Tue, 16 May
 2023 12:58:40 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 12:58:39 +0000
Date: Tue, 16 May 2023 14:58:26 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
CC: <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
	<yhs@fb.com>, <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
	<haoluo@google.com>, <jolsa@kernel.org>, <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH bpf-next v2 07/10] selftests/xsx: test for huge pages
 only once
Message-ID: <ZGN98qXSvzggA1Yu@boxer>
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
 <20230516103109.3066-8-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230516103109.3066-8-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR0P281CA0156.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 407ff40b-0b18-4d4a-8b31-08db560d44c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vflE2CNeyATUKzXQRCZWZW+i5NuqQ57btWCIKwrBRXZhOB569YuqeCLsSPkwXvC3Afext6y3IlP58tn3AtXOjRzbQ37emEUSz5sbzRUmUD4XznpesGWeQsG3IQzb9rL1PmF6TNv2noKxQSYL1Yj0XUnou7ZS6HK5U28WX3thZi6a2z54XMREhQAXMbJB7GzbEDvrISGeIlJTv4Pg9arzCuzse/pODgSoTlV/ZBzAmnNxl9KOz9TYXCfVLAyWcgKdoJXqDjPTi/6XwPbViE0Vftq0EkUd4g+ZJjHTPO9s8sW0Mg2uHqKYXtJrIy5BeXvxkKfIbRNnDHiVnDogHqYml35Y6YoButKEmv2PoyG1vEGYFn+d4W6T0tuscJmcF4kNeNlQseewfGkhHNZhz+HChuwlLYrXBDBuGkNDF3P35lhPHJ3FzxZL6TOOGRLGsNpybsEOCpULNmdbp4a7HgL7jBuPotc/QyyM00wQDOGWhc12QQoaVjCVIiQwFVdVxpt2Ghg9TMiIr1wKqHqYBHbTUTfe7HLeOJt4YkfS/fnvGl/AgIpSifJm89tEg1op/LsgTtgWrnVToHsTOw1tTVrySE5hZW9mGYFHBwvdUyNRm4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199021)(6506007)(186003)(9686003)(8676002)(82960400001)(8936002)(66476007)(26005)(107886003)(2906002)(5660300002)(30864003)(44832011)(83380400001)(6512007)(7416002)(478600001)(38100700002)(66556008)(41300700001)(6486002)(6666004)(316002)(4326008)(6916009)(66946007)(86362001)(33716001)(14583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cB3eBsBXBnJ24E4GANJL0QjW1UhT6Kqz/ZU9lTYK+2pmcs4798DN7bN4E/Nu?=
 =?us-ascii?Q?RExU23fa/uN1ufegl30D6qhOeDrcM+j9UFuVvwcqdH4/0UBhRnQ9TR7xyh0L?=
 =?us-ascii?Q?HB6C+YKOBc+LzTrMUocgKP/xUd0wtSwepRXpJnrV3k0Id5gg/ImtzIszLJCX?=
 =?us-ascii?Q?w3lUJHRjhfAghTE/ELaPMAcZ2LzVNQHAa0dNFDDDM8yXUUvGuxEFbElRiUfa?=
 =?us-ascii?Q?GrrjSwTjdF1RTjCoiwj87yGg7pWBa6AL6oFHlyt6IvMQwGipPhr7WOdhJDJg?=
 =?us-ascii?Q?HfZwuFxB5d38qDdwXqc51Fk783T5zyDo40JfX+m5FEnJTNj6VwLBaUZgUYfy?=
 =?us-ascii?Q?wpRggLXkwcFns3Apo9yRYQlpjfNQOKPmkBMn0T3nhIlhiODeiG0mU1dS8dF9?=
 =?us-ascii?Q?At3xeZqS+2TyyolblrrFlxLKKyp+ymjDk6UCY/Di2r0iZvyMnzHZthGM3SNc?=
 =?us-ascii?Q?/5oIpFERpLFNG/xrwNu5OLeE2Le0uZ5bfOT1Z6Q4cP77OuZuSR/O4KxaGqBh?=
 =?us-ascii?Q?bXf2kYnxHccf3qArKTwkge8AzJni0n2hJH7kkQWYeCqpeR48kePDA04XbEKm?=
 =?us-ascii?Q?ZzxRgP3YSl5ewii7mUlI8vNbTZSXIaqsJHSaVhYWp+Fp9HQJYlDcVKM1R0AI?=
 =?us-ascii?Q?Hqo3PDulvcFF6t7ZLUSbodrH1m9OHMskdkntim+3Sr9UzY6bA0Fclnw0la8N?=
 =?us-ascii?Q?bixQ5RrAx/awHhnQo+oJq/wdS4VjrUB5j7l9e5DXzZrIBr0StIM9KZA12Pbv?=
 =?us-ascii?Q?5D9LN+FWIgGNJbxGNc0ykVdYzVWNxA0HzwDxp9D2SRlU4qsr+Jg2x6wsBXX8?=
 =?us-ascii?Q?4LYlMVe/dm3WnCYAF4vkhr6GJ7iDKamnHBR4OHVAdtIdoOKYVktwA2BZDw8y?=
 =?us-ascii?Q?EozZf1KBluc+o56NX2+kTCQpoI3xZ0gVOx/gKa4y0g1a4oAdi88qyVZ3QSRJ?=
 =?us-ascii?Q?GTrkTYgzkxtPRQmsx1XF1uY4zJTuSKbsEvNcbjq+amIbY4DCQymvuGHHOKLC?=
 =?us-ascii?Q?yp02R6CsmJ6hz74tAkBBAhJhBPfWzhr0noyX+9VGhaDG0pvSq+z+JbUV1bqN?=
 =?us-ascii?Q?rRwzsqeedF7dcJblfjX8/iOHXuAGOVzw1B/DdG1gJv9RbFHREFLwcOoldX/O?=
 =?us-ascii?Q?oQZolsNJUAmJRnwcgAQ8KEZ7loDoqvv78JyLxs3aY+JD27w7XWoPnyVbBVj+?=
 =?us-ascii?Q?bt0MMRQ9FAjcgqlR7yclW/kzJSkG5pYok7enqoOl+qS7WfvHdde+zZkeLoGp?=
 =?us-ascii?Q?lzcSy9QdVmZK9sFpNfngPi5YTu3G4K6o6d4ZuGHzNXxcpUOrs5zTk7ct+1sh?=
 =?us-ascii?Q?s+CD4qn++WVFQgrUks3uRDInr5virdPQlucFzzRppXY6B2xxDAKSzJ2VwpQO?=
 =?us-ascii?Q?t17WYCHMRZCVKc8Y7eq0GkaJ8utsCdxP+xa3E++Yj2wathZR57+OP4JS+olV?=
 =?us-ascii?Q?6EGtvHz7Wfv7xOzaGvursYiE8KMDHfKX/5a2bJkC7ycYAHYsxdJYK7d8wZ+B?=
 =?us-ascii?Q?C5fCqg4XFgkry5v2YRwWSF3rZmqi7nbaG0sI7ke1Oh0RhCl4Qt6kir8gDiDX?=
 =?us-ascii?Q?BG5liWQKVpiTyJqn1pidNOPr1aIQOVMipStazbCu8yUtY7cmer5tpr3SN9/V?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 407ff40b-0b18-4d4a-8b31-08db560d44c4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 12:58:39.4263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1MglSztGPM8Zpv0K+JuOviIEvBx7J7zXv8cJMdPJZloBSjpT712/PyoE3vNeKAZ7MEilPwiZRciywwIsy/7n1/SGKsykU4Eaamvi1ItcSaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6671
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 12:31:06PM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Test for hugepages only once at the beginning of the execution of the
> whole test suite, instead of before each test that needs huge
> pages. These are the tests that use unaligned mode. As more unaligned
> tests will be added, so the current system just does not scale.
> 
> With this change, there are now three possible outcomes of a test run:
> fail, pass, or skip. To simplify the handling of this, the function
> testapp_validate_traffic() now returns this value to the main loop. As
> this function is used by nearly all tests, it meant a small change to
> most of them.

I don't get the need for that change. Why couldn't we just store the
retval to test_spec and then check it in run_pkt_test() just like we check
test->fail currently? Am i missing something?

> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 186 +++++++++++------------
>  tools/testing/selftests/bpf/xskxceiver.h |   2 +
>  2 files changed, 94 insertions(+), 94 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index d488d859d3a2..f0d929cb730a 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1413,6 +1413,12 @@ static int testapp_validate_traffic(struct test_spec *test)
>  	struct ifobject *ifobj_rx = test->ifobj_rx;
>  	struct ifobject *ifobj_tx = test->ifobj_tx;
>  
> +	if ((ifobj_rx->umem->unaligned_mode && !ifobj_rx->unaligned_supp) ||
> +	    (ifobj_tx->umem->unaligned_mode && !ifobj_tx->unaligned_supp)) {
> +		ksft_test_result_skip("No huge pages present.\n");
> +		return TEST_SKIP;
> +	}
> +
>  	xsk_attach_xdp_progs(test, ifobj_rx, ifobj_tx);
>  	return __testapp_validate_traffic(test, ifobj_rx, ifobj_tx);
>  }
> @@ -1422,16 +1428,18 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
>  	return __testapp_validate_traffic(test, ifobj, NULL);
>  }
>  
> -static void testapp_teardown(struct test_spec *test)
> +static int testapp_teardown(struct test_spec *test)
>  {
>  	int i;
>  
>  	test_spec_set_name(test, "TEARDOWN");
>  	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
>  		if (testapp_validate_traffic(test))
> -			return;
> +			return TEST_FAILURE;
>  		test_spec_reset(test);
>  	}
> +
> +	return TEST_PASS;
>  }
>  
>  static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
> @@ -1446,20 +1454,23 @@ static void swap_directions(struct ifobject **ifobj1, struct ifobject **ifobj2)
>  	*ifobj2 = tmp_ifobj;
>  }
>  
> -static void testapp_bidi(struct test_spec *test)
> +static int testapp_bidi(struct test_spec *test)
>  {
> +	int res;
> +
>  	test_spec_set_name(test, "BIDIRECTIONAL");
>  	test->ifobj_tx->rx_on = true;
>  	test->ifobj_rx->tx_on = true;
>  	test->total_steps = 2;
>  	if (testapp_validate_traffic(test))
> -		return;
> +		return TEST_FAILURE;
>  
>  	print_verbose("Switching Tx/Rx vectors\n");
>  	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
> -	__testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
> +	res = __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
>  
>  	swap_directions(&test->ifobj_rx, &test->ifobj_tx);
> +	return res;
>  }
>  
>  static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj_rx)
> @@ -1476,115 +1487,94 @@ static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj
>  		exit_with_error(errno);
>  }
>  
> -static void testapp_bpf_res(struct test_spec *test)
> +static int testapp_bpf_res(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "BPF_RES");
>  	test->total_steps = 2;
>  	test->nb_sockets = 2;
>  	if (testapp_validate_traffic(test))
> -		return;
> +		return TEST_FAILURE;
>  
>  	swap_xsk_resources(test->ifobj_tx, test->ifobj_rx);
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_headroom(struct test_spec *test)
> +static int testapp_headroom(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "UMEM_HEADROOM");
>  	test->ifobj_rx->umem->frame_headroom = UMEM_HEADROOM_TEST_SIZE;
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_stats_rx_dropped(struct test_spec *test)
> +static int testapp_stats_rx_dropped(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "STAT_RX_DROPPED");
> +	if (test->mode == TEST_MODE_ZC) {
> +		ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
> +		return TEST_SKIP;
> +	}
> +
>  	pkt_stream_replace_half(test, MIN_PKT_SIZE * 4, 0);
>  	test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
>  		XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 3;
>  	pkt_stream_receive_half(test);
>  	test->ifobj_rx->validation_func = validate_rx_dropped;
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_stats_tx_invalid_descs(struct test_spec *test)
> +static int testapp_stats_tx_invalid_descs(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "STAT_TX_INVALID");
>  	pkt_stream_replace_half(test, XSK_UMEM__INVALID_FRAME_SIZE, 0);
>  	test->ifobj_tx->validation_func = validate_tx_invalid_descs;
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_stats_rx_full(struct test_spec *test)
> +static int testapp_stats_rx_full(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "STAT_RX_FULL");
>  	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
>  	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
>  							 DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
> -	if (!test->ifobj_rx->pkt_stream)
> -		exit_with_error(ENOMEM);
>  
>  	test->ifobj_rx->xsk->rxqsize = DEFAULT_UMEM_BUFFERS;
>  	test->ifobj_rx->release_rx = false;
>  	test->ifobj_rx->validation_func = validate_rx_full;
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_stats_fill_empty(struct test_spec *test)
> +static int testapp_stats_fill_empty(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "STAT_RX_FILL_EMPTY");
>  	pkt_stream_replace(test, DEFAULT_UMEM_BUFFERS + DEFAULT_UMEM_BUFFERS / 2, MIN_PKT_SIZE);
>  	test->ifobj_rx->pkt_stream = pkt_stream_generate(test->ifobj_rx->umem,
>  							 DEFAULT_UMEM_BUFFERS, MIN_PKT_SIZE);
> -	if (!test->ifobj_rx->pkt_stream)
> -		exit_with_error(ENOMEM);
>  
>  	test->ifobj_rx->use_fill_ring = false;
>  	test->ifobj_rx->validation_func = validate_fill_empty;
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -/* Simple test */
> -static bool hugepages_present(struct ifobject *ifobject)
> +static int testapp_unaligned(struct test_spec *test)
>  {
> -	size_t mmap_sz = 2 * ifobject->umem->num_frames * ifobject->umem->frame_size;
> -	void *bufs;
> -
> -	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
> -		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB, -1, 0);
> -	if (bufs == MAP_FAILED)
> -		return false;
> -
> -	mmap_sz = ceil_u64(mmap_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
> -	munmap(bufs, mmap_sz);
> -	return true;
> -}
> -
> -static bool testapp_unaligned(struct test_spec *test)
> -{
> -	if (!hugepages_present(test->ifobj_tx)) {
> -		ksft_test_result_skip("No 2M huge pages present.\n");
> -		return false;
> -	}
> -
>  	test_spec_set_name(test, "UNALIGNED_MODE");
>  	test->ifobj_tx->umem->unaligned_mode = true;
>  	test->ifobj_rx->umem->unaligned_mode = true;
>  	/* Let half of the packets straddle a 4K buffer boundary */
>  	pkt_stream_replace_half(test, MIN_PKT_SIZE, -MIN_PKT_SIZE / 2);
> -	testapp_validate_traffic(test);
>  
> -	return true;
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_single_pkt(struct test_spec *test)
> +static int testapp_single_pkt(struct test_spec *test)
>  {
>  	struct pkt pkts[] = {{0, MIN_PKT_SIZE, 0, true}};
>  
>  	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_invalid_desc(struct test_spec *test)
> +static int testapp_invalid_desc(struct test_spec *test)
>  {
>  	struct xsk_umem_info *umem = test->ifobj_tx->umem;
>  	u64 umem_size = umem->num_frames * umem->frame_size;
> @@ -1626,10 +1616,10 @@ static void testapp_invalid_desc(struct test_spec *test)
>  	}
>  
>  	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_xdp_drop(struct test_spec *test)
> +static int testapp_xdp_drop(struct test_spec *test)
>  {
>  	struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
>  	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
> @@ -1639,10 +1629,10 @@ static void testapp_xdp_drop(struct test_spec *test)
>  			       skel_rx->maps.xsk, skel_tx->maps.xsk);
>  
>  	pkt_stream_receive_half(test);
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_xdp_metadata_count(struct test_spec *test)
> +static int testapp_xdp_metadata_count(struct test_spec *test)
>  {
>  	struct xsk_xdp_progs *skel_rx = test->ifobj_rx->xdp_progs;
>  	struct xsk_xdp_progs *skel_tx = test->ifobj_tx->xdp_progs;
> @@ -1663,10 +1653,10 @@ static void testapp_xdp_metadata_count(struct test_spec *test)
>  	if (bpf_map_update_elem(bpf_map__fd(data_map), &key, &count, BPF_ANY))
>  		exit_with_error(errno);
>  
> -	testapp_validate_traffic(test);
> +	return testapp_validate_traffic(test);
>  }
>  
> -static void testapp_poll_txq_tmout(struct test_spec *test)
> +static int testapp_poll_txq_tmout(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "POLL_TXQ_FULL");
>  
> @@ -1674,14 +1664,14 @@ static void testapp_poll_txq_tmout(struct test_spec *test)
>  	/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
>  	test->ifobj_tx->umem->frame_size = 2048;
>  	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
> -	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
> +	return testapp_validate_traffic_single_thread(test, test->ifobj_tx);
>  }
>  
> -static void testapp_poll_rxq_tmout(struct test_spec *test)
> +static int testapp_poll_rxq_tmout(struct test_spec *test)
>  {
>  	test_spec_set_name(test, "POLL_RXQ_EMPTY");
>  	test->ifobj_rx->use_poll = true;
> -	testapp_validate_traffic_single_thread(test, test->ifobj_rx);
> +	return testapp_validate_traffic_single_thread(test, test->ifobj_rx);
>  }
>  
>  static int xsk_load_xdp_programs(struct ifobject *ifobj)
> @@ -1698,6 +1688,22 @@ static void xsk_unload_xdp_programs(struct ifobject *ifobj)
>  	xsk_xdp_progs__destroy(ifobj->xdp_progs);
>  }
>  
> +/* Simple test */
> +static bool hugepages_present(void)
> +{
> +	size_t mmap_sz = 2 * DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE;
> +	void *bufs;
> +
> +	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
> +		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, MAP_HUGE_2MB);
> +	if (bufs == MAP_FAILED)
> +		return false;
> +
> +	mmap_sz = ceil_u64(mmap_sz, HUGEPAGE_SIZE) * HUGEPAGE_SIZE;
> +	munmap(bufs, mmap_sz);
> +	return true;
> +}
> +
>  static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
>  		       thread_func_t func_ptr)
>  {
> @@ -1713,94 +1719,87 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
>  		printf("Error loading XDP program\n");
>  		exit_with_error(err);
>  	}
> +
> +	if (hugepages_present())
> +		ifobj->unaligned_supp = true;
>  }
>  
>  static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_type type)
>  {
> +	int ret = TEST_SKIP;
> +
>  	switch (type) {
>  	case TEST_TYPE_STATS_RX_DROPPED:
> -		if (mode == TEST_MODE_ZC) {
> -			ksft_test_result_skip("Can not run RX_DROPPED test for ZC mode\n");
> -			return;
> -		}
> -		testapp_stats_rx_dropped(test);
> +		ret = testapp_stats_rx_dropped(test);
>  		break;
>  	case TEST_TYPE_STATS_TX_INVALID_DESCS:
> -		testapp_stats_tx_invalid_descs(test);
> +		ret = testapp_stats_tx_invalid_descs(test);
>  		break;
>  	case TEST_TYPE_STATS_RX_FULL:
> -		testapp_stats_rx_full(test);
> +		ret = testapp_stats_rx_full(test);
>  		break;
>  	case TEST_TYPE_STATS_FILL_EMPTY:
> -		testapp_stats_fill_empty(test);
> +		ret = testapp_stats_fill_empty(test);
>  		break;
>  	case TEST_TYPE_TEARDOWN:
> -		testapp_teardown(test);
> +		ret = testapp_teardown(test);
>  		break;
>  	case TEST_TYPE_BIDI:
> -		testapp_bidi(test);
> +		ret = testapp_bidi(test);
>  		break;
>  	case TEST_TYPE_BPF_RES:
> -		testapp_bpf_res(test);
> +		ret = testapp_bpf_res(test);
>  		break;
>  	case TEST_TYPE_RUN_TO_COMPLETION:
>  		test_spec_set_name(test, "RUN_TO_COMPLETION");
> -		testapp_validate_traffic(test);
> +		ret = testapp_validate_traffic(test);
>  		break;
>  	case TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT:
>  		test_spec_set_name(test, "RUN_TO_COMPLETION_SINGLE_PKT");
> -		testapp_single_pkt(test);
> +		ret = testapp_single_pkt(test);
>  		break;
>  	case TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME:
>  		test_spec_set_name(test, "RUN_TO_COMPLETION_2K_FRAME_SIZE");
>  		test->ifobj_tx->umem->frame_size = 2048;
>  		test->ifobj_rx->umem->frame_size = 2048;
>  		pkt_stream_replace(test, DEFAULT_PKT_CNT, MIN_PKT_SIZE);
> -		testapp_validate_traffic(test);
> +		ret = testapp_validate_traffic(test);
>  		break;
>  	case TEST_TYPE_RX_POLL:
>  		test->ifobj_rx->use_poll = true;
>  		test_spec_set_name(test, "POLL_RX");
> -		testapp_validate_traffic(test);
> +		ret = testapp_validate_traffic(test);
>  		break;
>  	case TEST_TYPE_TX_POLL:
>  		test->ifobj_tx->use_poll = true;
>  		test_spec_set_name(test, "POLL_TX");
> -		testapp_validate_traffic(test);
> +		ret = testapp_validate_traffic(test);
>  		break;
>  	case TEST_TYPE_POLL_TXQ_TMOUT:
> -		testapp_poll_txq_tmout(test);
> +		ret = testapp_poll_txq_tmout(test);
>  		break;
>  	case TEST_TYPE_POLL_RXQ_TMOUT:
> -		testapp_poll_rxq_tmout(test);
> +		ret = testapp_poll_rxq_tmout(test);
>  		break;
>  	case TEST_TYPE_ALIGNED_INV_DESC:
>  		test_spec_set_name(test, "ALIGNED_INV_DESC");
> -		testapp_invalid_desc(test);
> +		ret = testapp_invalid_desc(test);
>  		break;
>  	case TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME:
>  		test_spec_set_name(test, "ALIGNED_INV_DESC_2K_FRAME_SIZE");
>  		test->ifobj_tx->umem->frame_size = 2048;
>  		test->ifobj_rx->umem->frame_size = 2048;
> -		testapp_invalid_desc(test);
> +		ret = testapp_invalid_desc(test);
>  		break;
>  	case TEST_TYPE_UNALIGNED_INV_DESC:
> -		if (!hugepages_present(test->ifobj_tx)) {
> -			ksft_test_result_skip("No 2M huge pages present.\n");
> -			return;
> -		}
>  		test_spec_set_name(test, "UNALIGNED_INV_DESC");
>  		test->ifobj_tx->umem->unaligned_mode = true;
>  		test->ifobj_rx->umem->unaligned_mode = true;
> -		testapp_invalid_desc(test);
> +		ret = testapp_invalid_desc(test);
>  		break;
>  	case TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME: {
>  		u64 page_size, umem_size;
>  
> -		if (!hugepages_present(test->ifobj_tx)) {
> -			ksft_test_result_skip("No 2M huge pages present.\n");
> -			return;
> -		}
>  		test_spec_set_name(test, "UNALIGNED_INV_DESC_4K1_FRAME_SIZE");
>  		/* Odd frame size so the UMEM doesn't end near a page boundary. */
>  		test->ifobj_tx->umem->frame_size = 4001;
> @@ -1814,27 +1813,26 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>  		umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
>  		assert(umem_size % page_size > MIN_PKT_SIZE);
>  		assert(umem_size % page_size < page_size - MIN_PKT_SIZE);
> -		testapp_invalid_desc(test);
> +		ret = testapp_invalid_desc(test);
>  		break;
>  	}
>  	case TEST_TYPE_UNALIGNED:
> -		if (!testapp_unaligned(test))
> -			return;
> +		ret = testapp_unaligned(test);
>  		break;
>  	case TEST_TYPE_HEADROOM:
> -		testapp_headroom(test);
> +		ret = testapp_headroom(test);
>  		break;
>  	case TEST_TYPE_XDP_DROP_HALF:
> -		testapp_xdp_drop(test);
> +		ret = testapp_xdp_drop(test);
>  		break;
>  	case TEST_TYPE_XDP_METADATA_COUNT:
> -		testapp_xdp_metadata_count(test);
> +		ret = testapp_xdp_metadata_count(test);
>  		break;
>  	default:
>  		break;
>  	}
>  
> -	if (!test->fail)
> +	if (ret == TEST_PASS)
>  		ksft_test_result_pass("PASS: %s %s%s\n", mode_string(test), busy_poll_string(test),
>  				      test->name);
>  	pkt_stream_restore_default(test);
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index be4664a38d74..00862732e751 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -30,6 +30,7 @@
>  #define TEST_PASS 0
>  #define TEST_FAILURE -1
>  #define TEST_CONTINUE 1
> +#define TEST_SKIP 2
>  #define MAX_INTERFACES 2
>  #define MAX_INTERFACE_NAME_CHARS 16
>  #define MAX_SOCKETS 2
> @@ -148,6 +149,7 @@ struct ifobject {
>  	bool release_rx;
>  	bool shared_umem;
>  	bool use_metadata;
> +	bool unaligned_supp;
>  	u8 dst_mac[ETH_ALEN];
>  	u8 src_mac[ETH_ALEN];
>  };
> -- 
> 2.34.1
> 

