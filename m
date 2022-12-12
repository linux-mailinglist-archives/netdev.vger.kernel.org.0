Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D52C764A30C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 15:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiLLOUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 09:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiLLOUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 09:20:17 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB4DF037;
        Mon, 12 Dec 2022 06:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670854812; x=1702390812;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=f5Cd4CvF0ZoDkc9x/PIOnNxqLfWDojkGTGXhoviSk34=;
  b=nuWJBE0DXnfj1h0PHsgcZ2uaIJjlnEeX6aO7XICTtozMNlVd6GReFByi
   k02eOudtQq8cfoothmpTVC7Mcz28n8vjB/P3Z/FFBENSjJobUO5pkIaxW
   ISlB9wQke5dfLxf3TP5ocvka6B6dQlFEQnu0ZP9p15DljxIhj+fMZjq//
   KfLRqEgyNeR5kJczgMg5/oYT82oJxeHGgvZMxV5BzcHJxrSU9oswtB7vh
   YRPaQij8qJ6+CIgmzXwg0AQBiCzigtq2YC2uGxTfJAaYHg2iKbna+FF4w
   ASjxcJUxSXF2Dh0viEUr+o8unKspdKGYaeQj+g4clsioyWHvb1nbX00Om
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="317892155"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="317892155"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 06:19:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10558"; a="716813690"
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="716813690"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 12 Dec 2022 06:19:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 06:19:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 06:19:50 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 06:19:50 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 06:19:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaAYDpOFojMunFWvJMX/eH1y8m2asaQAxcZ/PGRyisFvGAc7OEsUxIW+yHAfO9/sX+PziHZozp1i7JzKZRupkEwXg60wMGxZOeCLHG9KaY1dJ2pz76UHaKT7gOah52SqpYk1cTvjF+5hf9ZhHHOjBSjlg0CSNnl/cnildQaJg0J63MkLIqHxQ4M84J50E/ButqPC+6dfIMTQBh1+OvHkKDhjOlUz6FjOSkNzbTSzxapSTbJTscf1q1/pipJP2j3RUh5BygMNtkwO7F37eTvGkFOfpF45A8mt7NcF8+6Bd2bvz8RgZBROq853XQbTSUI7TrNWyyHiCpqoL5CixUXY3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiFDDUi5MEVr91Tprim3KvsIg4mfAlWJUudLeUJgwh4=;
 b=cO1BJKtfCMvX0kuDlasUHZV8Adf5CdcSXV9N3nI/GH0u5yBcmZ62NOYb0qFWkLmZO4I02ENIDaHDpcStGIxtSpC/Oc3ATCvhvnR59ehYjUokzRfMKsw/Yrf4jzWkAls6rqowgaSfZE8rIW61thZ45hyJ3PR7puvjp4oaKkT1Ya1lW6IqCrv6cX3uemxBWmp3GxgYJRrchFa9AwoRP4ZKiLdQmifXHk92UTvoy1Ca92UL+1Rzrk7JyLtQf6HFdUzKJgn+pCzxf1WNVlrylPJnoNVjsIQg4VLi00u5Oi17Tnb2bFSWxTgLQ+bM4VJNRO6o7OQCcr2uFNwlyNS3VMp+CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5609.namprd11.prod.outlook.com (2603:10b6:510:e0::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Mon, 12 Dec 2022 14:19:48 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 14:19:48 +0000
Date:   Mon, 12 Dec 2022 15:19:36 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <yhs@fb.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>, <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next 08/15] selftests/xsk: remove namespaces
Message-ID: <Y5c4eD2mRT/qHUi4@boxer>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
 <20221206090826.2957-9-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221206090826.2957-9-magnus.karlsson@gmail.com>
X-ClientProxiedBy: FR3P281CA0051.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::9) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: d535c168-bcfa-447c-f246-08dadc4becfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhhSzPCnuytlUCbIecRP5+JQPPAzjdPGuyU1m6MtlVlsgEa2HY+KnucZQkgLko+p7YnqF0bPFDS7XJ6D5Scf2d9P9Jtf5vrnwsfZbXcJa2X6tvIxKoOnlt+m79WiDP4IP1lDCuA2RZ13Nip5o5z0ZO3EgDDR/rKKK3X27es6Mh8jvJcM3S1maLEFXuaQYi3ofdVW7YhP5m3KAa5U1kjuyMof2UictvsuM/8Te8camkmPRYyA+OR/cpCRLF7piA15mVlM00TPuRJ2sUUwTyvLITQB7zEfidHpUPthQ6+iw2Un9/CDxb85hApzeWL2J0l+ah5i1A2ew6mO6K1VyQFymheINPYh+6YH3KMR7cqPmBc5hT1mIWO7w12WUTZfNWhd07dmFNXyGrrYinS0hEKOqq1uMNjIormBuxb9eel5KcQB1sdy1YfLK92fscwy4lZ0FHHsI9b+IKv5vndUlc2Tyc37jPxxZDvcwemXo5kUDiyv6h1sy9euKgbcvr6zAUWjzuPOHLQqbQSikMmY9DrhFP5XUAm7cWrWz2wem33jrrdwAZ2Dr5C9lHJonbZNH+u/YZUUucH+D0/AY4pp/k2JH5v+cw6275YAOTuY+NeoBYubGbLz7QQkMt1VG1yAJdPLlgV+5RvVvQdC8zYXpUrr0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199015)(7416002)(6506007)(5660300002)(44832011)(26005)(6916009)(41300700001)(4326008)(316002)(9686003)(6512007)(6666004)(66556008)(8936002)(8676002)(66946007)(83380400001)(82960400001)(2906002)(33716001)(38100700002)(86362001)(66476007)(186003)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yFXoXl7cB0sP4uv3ct/Ks60jiS1GmNRQtihmuHq2c5XBOrVgN6pPBNE3daOX?=
 =?us-ascii?Q?IL8Pk5gAllvn7UPhf41nzosMYEiyC9kqZGiG6cN7r0FGvAIT0266h0WaNuFS?=
 =?us-ascii?Q?PKbuz3l2UXJ7O7w7BfNUFDKufF+bsMTUIzUvjFgrR1mGi4sYjJdOoEmfYqI0?=
 =?us-ascii?Q?9y4d3q8FCwucwqdATrSjkGcv/IFizLDlwQrggCsYHBlrwjjsqblDMlf5Autt?=
 =?us-ascii?Q?zpInVn0Bny2fe4js+drcyv7bn10iCs2xrSPnXc+u0FKRF8MnGX9qwnTMEDDp?=
 =?us-ascii?Q?mfrGruDYqVIiCoT/jJePSXESTOKAGpScZDdpFC4uoCsjdh4bCIRkShWKJf1n?=
 =?us-ascii?Q?w0i6+ZjU1ccHnZr0CH8p/Ibg7QxRQuhRqeZvec9Wklh2eK5LY8it145m2zNx?=
 =?us-ascii?Q?Mm8ADbCzgQLJzJuGT8VNoS5vCJfjAWWu88s9/aAYoC06ZUBxtHr4eXq6z7Oa?=
 =?us-ascii?Q?iPIUa3BNxKW4v3pYGLgBY4UIdjfR3/We8KW/DApAYBMk+Y4W+0myvTwAe/X7?=
 =?us-ascii?Q?cE/XVpv61zC7TYovFxT0niOdlPBJ8t3pnls1zfZy2skR8+S1G/pGzy9otpeD?=
 =?us-ascii?Q?VUWIKY41/uhIWGSxclZm3xVnfGS6El9wHSTPGLLO57B8NM5FBa38p8rl2AWc?=
 =?us-ascii?Q?dCvQttE/ot7lUrwy3UAK1HOE2cix+XGieVvXK0QXVu6uLdBe53Mx784uXdoF?=
 =?us-ascii?Q?TuY6TIoLL8j2EYCwTPy2H3b+CpJYj1B3ffi1/vZo58LHhyvMNbQg447hgUzO?=
 =?us-ascii?Q?axVS7aw47S4K1z+r60NDXgD4ETA0fGnK0W2CLuKc13BjfS3UfSVs04tLpXus?=
 =?us-ascii?Q?2anU+o9QEJXy+RkLn6KCLHIjnAxI0/dBOTD7cKU3lx9xu20sbjyvI/8R6sme?=
 =?us-ascii?Q?ansN4j+6jtl8WRgnSbLHoIF9VcNmAKMh4iIKWQP4PJc9XojSN19Fx6rl0Bj/?=
 =?us-ascii?Q?CxITDtC16Jd+WfeaYJq717pW5Aw+R2dhYSfBoyGmxJdznCe2zGEBTghyhsKT?=
 =?us-ascii?Q?o3eAD74JxHwTDa7P1BOdksnzljV2MIXow4qU0Kg/TKFgFSc5bsqXO4tjX+ks?=
 =?us-ascii?Q?MsVlUmThRuP8Yrq4S168CmTDbgvcskzRcdcKCB0Cl82QzBfVE6pv02n/jQQ9?=
 =?us-ascii?Q?BC8Zv5t44tFf4nNRYV/ZssTw3O1n04L+7/hUjqWaIsD+4uJlffzj1pfPYAa7?=
 =?us-ascii?Q?vSpysLgwflc+2eEINUPzhDxdHZG+SKU98z1wDNyWqAXRIDvPDDyQQEmtdb7O?=
 =?us-ascii?Q?PH69p4G8bCSLr9Jpvv703F8beXOKRORoskiWJer3MxtZIWsiywAOV2T8IDxJ?=
 =?us-ascii?Q?Ji9fZTN9BI+S8LS6y7UWO0OqN5DAw0WoWVS5Bu/Cl2AoDxkeYyE/jmWJDRRU?=
 =?us-ascii?Q?WTlU35tLedoyXqrR2cOGxzwSgPq5EwiSiL87KmDOsY6tCyR7KfvDAa7u6QZw?=
 =?us-ascii?Q?xoeBipnjQCmJetB+NNCd+0lH/gdt7DhlYDdRrj71c13lrsHLia7Y1NXJ8r9V?=
 =?us-ascii?Q?Cz0XGXG76iTlu1q2Fu7yKrzyd0ADF7YUw4Q21kBGZyyH1lUNLRVWZ+RsT31n?=
 =?us-ascii?Q?ecGop5HeYfXhrGHMAYapw1llWeNXyDMmGgzPtu02hRVv+7idv0M9lT/MC53f?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d535c168-bcfa-447c-f246-08dadc4becfc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 14:19:48.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1y3b2JzWaV7u0h9uQMpSwE/u8fXnBI21yCrHeCfPR7LLHGg84itPlZ7TE83WDzCEX2QEA6TT4d3uSkmPCaiNOZG7TluqrJG9ypio/WL05gE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5609
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:08:19AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Remove the namespaces used as they fill no function. This will
> simplify the code for speeding up the tests in the following commits.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/testing/selftests/bpf/test_xsk.sh    | 33 +++++++----------
>  tools/testing/selftests/bpf/xsk_prereqs.sh | 12 ++-----
>  tools/testing/selftests/bpf/xskxceiver.c   | 42 +++-------------------
>  tools/testing/selftests/bpf/xskxceiver.h   |  3 --
>  4 files changed, 19 insertions(+), 71 deletions(-)
> 

(...)

> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 72578cebfbf7..0aaf2f0a9d75 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -55,12 +55,11 @@
>   * Flow:
>   * -----
>   * - Single process spawns two threads: Tx and Rx
> - * - Each of these two threads attach to a veth interface within their assigned
> - *   namespaces
> - * - Each thread Creates one AF_XDP socket connected to a unique umem for each
> + * - Each of these two threads attach to a veth interface
> + * - Each thread creates one AF_XDP socket connected to a unique umem for each
>   *   veth interface
> - * - Tx thread Transmits 10k packets from veth<xxxx> to veth<yyyy>
> - * - Rx thread verifies if all 10k packets were received and delivered in-order,
> + * - Tx thread Transmits a number of packets from veth<xxxx> to veth<yyyy>
> + * - Rx thread verifies if all packets were received and delivered in-order,
>   *   and have the right content
>   *
>   * Enable/disable packet dump mode:
> @@ -399,28 +398,6 @@ static void usage(const char *prog)
>  	ksft_print_msg(str, prog);
>  }
>  
> -static int switch_namespace(const char *nsname)
> -{
> -	char fqns[26] = "/var/run/netns/";
> -	int nsfd;
> -
> -	if (!nsname || strlen(nsname) == 0)
> -		return -1;
> -
> -	strncat(fqns, nsname, sizeof(fqns) - strlen(fqns) - 1);
> -	nsfd = open(fqns, O_RDONLY);
> -
> -	if (nsfd == -1)
> -		exit_with_error(errno);
> -
> -	if (setns(nsfd, 0) == -1)
> -		exit_with_error(errno);
> -
> -	print_verbose("NS switched: %s\n", nsname);
> -
> -	return nsfd;
> -}
> -
>  static bool validate_interface(struct ifobject *ifobj)
>  {
>  	if (!strcmp(ifobj->ifname, ""))
> @@ -438,7 +415,7 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
>  	opterr = 0;
>  
>  	for (;;) {
> -		char *sptr, *token;
> +		char *sptr;
>  
>  		c = getopt_long(argc, argv, "i:Dvb", long_options, &option_index);
>  		if (c == -1)
> @@ -455,9 +432,6 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
>  
>  			sptr = strndupa(optarg, strlen(optarg));

Wasn't this strndupa needed only because of strsep usage?
I feel that now you can just memcpy directly from optarg to ifobj->nsname.

>  			memcpy(ifobj->ifname, strsep(&sptr, ","), MAX_INTERFACE_NAME_CHARS);
> -			token = strsep(&sptr, ",");
> -			if (token)
> -				memcpy(ifobj->nsname, token, MAX_INTERFACES_NAMESPACE_CHARS);
>  			interface_nb++;
>  			break;
>  		case 'D':
> @@ -1283,8 +1257,6 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>  	int ret, ifindex;
>  	void *bufs;
>  
> -	ifobject->ns_fd = switch_namespace(ifobject->nsname);
> -
>  	if (ifobject->umem->unaligned_mode)
>  		mmap_flags |= MAP_HUGETLB;
>  
> @@ -1843,8 +1815,6 @@ static struct ifobject *ifobject_create(void)
>  	if (!ifobj->umem)
>  		goto out_umem;
>  
> -	ifobj->ns_fd = -1;
> -
>  	return ifobj;
>  
>  out_umem:
> @@ -1856,8 +1826,6 @@ static struct ifobject *ifobject_create(void)
>  
>  static void ifobject_delete(struct ifobject *ifobj)
>  {
> -	if (ifobj->ns_fd != -1)
> -		close(ifobj->ns_fd);
>  	free(ifobj->umem);
>  	free(ifobj->xsk_arr);
>  	free(ifobj);

(...)
