Return-Path: <netdev+bounces-8343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 45BD7723C57
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:57:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648301C20E60
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC841E52B;
	Tue,  6 Jun 2023 08:57:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D953D8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:57:17 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E627E76;
	Tue,  6 Jun 2023 01:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686041833; x=1717577833;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Va6H68SXQsSGup5D/E85THfMfsgPCyLFJOQoTfRDasc=;
  b=cMV2UDbujIQhkLBGKFVnFpiTA19rnEju/HTHyrVbLnSmDZasRpO91PaH
   kRkYSV61364BIS5PA+KlDGA0Y3Qc4PJIXIffE0XfLdIvg6NFx/nmB9QYi
   i5hd2z+ZS4c4oNy2GcGSYMsk9TzkGGxl9a8skr9VZupVoeuyzldfFQXtc
   2wo8gDE+3RFH0lgslyW1BY5ekEBj4ltFDz/kvp0uQ4/CTeQMK0WJvk5rP
   +pIEM6o9TxZeGpkvPchxz2S6JdsfxIml7/2uRyXcnU4bc56EuyD3J3CFK
   uwZyXxAOheDhcwhuXDvW5udj35S1hFrMWnNbWHwy4GqlO6VegrOSPfXSc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="356618892"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="356618892"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 01:56:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659435896"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="659435896"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 06 Jun 2023 01:56:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 01:56:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 01:56:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 01:56:50 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 01:56:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJhD16VdXJCRmZXWWSuWpjKVL5AHrRUfCaKQabK9kQUVCXw3n0nw/LACRBdaSGJTzmDz6XDY0aa9iRqK0QFUYex31CoTMZEn5Zql3R4mnP0yWP0PkNdZut7zuiuYO769l53NanKlsoiFwhAnk84vE4L+q0q5xtH1uwiCFQnriFT9lAC4OliJC/NSZ/+j7O6MA3xGmFLpbaA2JWjluTQkCYrbcVNSCh96IwcRwkS/bzHtEeUe4xdj1eOtkV5upUosvHVwq1raWhGqL1wdvJfgxkikJAcaPoFXjE/D8/8PgJcXyfPZKFCzkTEuqXJEJNhrlaW/uO28WZaEUcEc7InwGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmqF29KecM67z0kONfU3oX6pgwaAy1lXTJDySsoWbys=;
 b=gM2Ewmj6O2/Af1jWzyvPW7zqn6XNwSbmUqgFuSFXM+ct1V20e5NhY0E/82oaZwnEp6uIRFtoTFOtrLReLe6AIZVe5cPsiWK2UIhCKh3V3jFq8o0zheJYXep+gUc0VFj6NqiNUjzaIrWavIGjtJFXfrmBi0Nwc+wlUvy15vjacGShGS/Wv4ndR3k1BwUbet7FgsFJ5ftQoWIuUs5FS8LXYFEG7V9tzx0y3fAPZYGtY/VPF+YSFRQU5LwIezsssSVRMZYoFXKC+aanWUVjhPF/3fOBEBJN9zJ8CEcze3WnuGSdmwTUwjZ3wt4ceB+zSP7bOuizZ2AQJFqarU/duk1ggQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by SA2PR11MB5083.namprd11.prod.outlook.com (2603:10b6:806:11b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 08:56:48 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:56:48 +0000
Date: Tue, 6 Jun 2023 10:53:55 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Hangyu Hua <hbh25y@gmail.com>
CC: <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: sched: fix possible refcount leak in
 tc_chain_tmplt_add()
Message-ID: <ZH70I+yV66OpMxbo@lincoln>
References: <20230605070158.48403-1-hbh25y@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605070158.48403-1-hbh25y@gmail.com>
X-ClientProxiedBy: DB7PR05CA0057.eurprd05.prod.outlook.com
 (2603:10a6:10:2e::34) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|SA2PR11MB5083:EE_
X-MS-Office365-Filtering-Correlation-Id: bcd016b1-702c-49d8-5789-08db666bf63e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8CgHoOLZmQALcDTL66n0EhJc5adS8sydOgcVr/wt8boqn8h8KKK5k5cOfg06WLZTvf9Op3FysTHbptjK4mSRb4qYA2LsnEIo88pgnG3jyiWQeRKjD8c+M4nuBKPfhn5cI4SjEcshvxTeM+jk3OB7dXyj24axJRkt700jiPaIaw7IxkAlNtbs6a08ko48TRaCyCUkJwBERjZSt9tNzKv0sdbZFVJrEvZ8j4DfdEWktvM4Y0f8RGMfFlYTMxlbC9vPvMlJGN4kZkSt6CvJw/fkNz27gnUAJYPBjEAlTU5xZAoXirAjUHOBSIzuxp6RSxFtV54xR954TC9v9JvmqgHVWprZvo8qEz6eroegNTElNo/rNFR2Dg19loeB9/r8jIg6HDBkEertTbygQYLyjQ09sGApkRx/4pTbTuaRwbL32HuQEzaUtI8extUPQdCAbK73PLnol4YDKn5PTdRUGzCERVOM6Al5nULLukAy1H5x6IO4fvrFOJwM1K5uZVm2bcXR8+UlYXYRv6anR0te3w0My9WYc+HK0JqWO5LmxgqBxQUpoizDN4zlvFaOOy3o/pm36DkmNc2dvEspDVwrAeRzl3RBm0DoPPjPckMlsXpheQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(6486002)(6666004)(9686003)(6512007)(6506007)(26005)(83380400001)(186003)(86362001)(316002)(7416002)(44832011)(66946007)(66556008)(66476007)(4326008)(6916009)(5660300002)(8936002)(8676002)(2906002)(33716001)(82960400001)(41300700001)(478600001)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7fM/OvcPhw1PHUO3drzhc0denhR4ozCXTBDFx0xjNd00AVspjTrKll5R4oPH?=
 =?us-ascii?Q?jyvEBpFwnWWpq5Il1iK76FDihw4+JvaDcCUJ8XRpECbhFnitnYVEsGtBD4an?=
 =?us-ascii?Q?nDtb7l7hp3KeRa3ze9dHnlYsc+RjE/9XkEFriFsMTX100OP+0DY2jGS1E/Ft?=
 =?us-ascii?Q?1WnJ/cEQ3nmPMXyewDTg5K8gpOMjrZfCFH8bA3vt5eqkaXyyy5+RghRIThDT?=
 =?us-ascii?Q?wjg+RTnPla/VBEiw9Tz5SxBGfdMdWkhkhULg5gO5/qqD8J5YJDDnKE8xvnu7?=
 =?us-ascii?Q?4f/WAM4N5jm79od+Qkor6Gl1CxcpOsjlikXAg9z4wDShqFN3EDnFrO+gNDfa?=
 =?us-ascii?Q?F8tCNaUzY/MiePf62limBccr01xwMppmuW77vG3NVT/c5iEcH4Ctm/5Ls3CK?=
 =?us-ascii?Q?h2PWlvF+ijBPciKF2qSUVULVKoP+0fwZP4PUcD2iV54MwPOwE0ohGD5HkBW5?=
 =?us-ascii?Q?mK0cjj1jaVzS4mE7JJ7OaWuCDlVABNzg/SDl2xcwFBgGO2V0tjI9eoEleryT?=
 =?us-ascii?Q?XG2+q14FG0dKxeakCW6WlHERbwoizBZXMPl2byeufTNsGqocQ7inUZgJbJy0?=
 =?us-ascii?Q?qXRz6ZN6s9JOn1MG0UnxH/VTq3yl4qJdTpBIfOm3+2vyOa7GD8T4V5mg7zhM?=
 =?us-ascii?Q?3tgCTdeyyUt7A/SgZ3ewLS8yrJaHvOfxCe1HwGJbak93LFwNXWX4VzzyiZla?=
 =?us-ascii?Q?cmhB8IFY1nlej9JG311UbLGfIlgoGKYv6j79e91agmvt7eV8UXaCd/5ADWxH?=
 =?us-ascii?Q?8TuHqonfrsZiEfaXUqfhI2tjKsQKGNayctpufO6gZDCAQ/XJXDydvD+rQLeJ?=
 =?us-ascii?Q?MUhLv+9NS8OxcimffZhZFeTTE0wSGmABWqIy4ZMzjleOMmQfUsYv+/SFVuXb?=
 =?us-ascii?Q?KdB/V2GBvYjkPs+DT/g/UirN0T1G3sBWbUjeYO5G6UaLtlI/xjOPrc/4VbWk?=
 =?us-ascii?Q?4xUyAKuzFdRegDOzv48W3U3BqSJZeOtPPbRfFtxN9Yih52ii5Ebi/jsvL9LP?=
 =?us-ascii?Q?OccPmYeXBwQ03nIZG5eKj0HLLRsqTeJhjDtSX1zs1JMMooRoh1UXQ8jSyDM1?=
 =?us-ascii?Q?pu2ouc6oGpQdk32tcB0oFuM/zukN+CU1EAWYtfTN0pvVRzm6vcGCv4ZaafkO?=
 =?us-ascii?Q?UGxPDAWnZMfNkKuKBNeTjQOi5yOHPLGy94DrRyBYfQ0PaQMysA+cPdJ6kWi/?=
 =?us-ascii?Q?SPNzTqT6GuaIwe1d7kMfYKWHvMErlWDC0acmBh57bM4DwTJme/Ub/XcV6+RH?=
 =?us-ascii?Q?h9utvMXgx1r+Cfw8nqhelm8jLS6wHuC3LyopWecokKWDpdM5bRp5qI3Ob4s5?=
 =?us-ascii?Q?GUhyKxGBX+sNf7+5s+TfZ1LR82mHiqv5nkalPMVC88vNmB1AumqwaSQA4lcq?=
 =?us-ascii?Q?q4//bR0iaWuuuDNOyHT6SGcM5W72yiYlVVBF6iyfxhRK4y4cYzzzGd1yGIry?=
 =?us-ascii?Q?0tmjDxHHWBO7ZRcmZ8HY6DtLeXhx/nU9tzhfOP5aQr+lUGfTevLxPHvVtF24?=
 =?us-ascii?Q?LhAM5haoX7KiIORQfGDHMq5U+/1suxtwmdUcwbv3FVtIOZqTMuwVngLZ1pli?=
 =?us-ascii?Q?gKfy/wLkLXE8DhD5j6b/N8pCmZBN4yzhWAZG+BPJHrw86z6JkqNUWP8K8rJB?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd016b1-702c-49d8-5789-08db666bf63e
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:56:48.3187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: myivvvkRKNqBrgtNVJ2jk7CTqusJsgp45WJk1yWevmtqqZI+LZiqI0DoNX2QQc8Mg1PPC9tGT1afV/BL5KIhwpRiwUBQ/NgJJsmDff7t7/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5083
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 03:01:58PM +0800, Hangyu Hua wrote:
> try_module_get can be called in tcf_proto_lookup_ops. So if ops don't
> implement the corresponding function we should call module_put to drop
> the refcount.
> 

Code seems reasonable. But commit message is pretty hard to understand.
Please, replace "corresponding" with "required".
Also change the first sentence, do not use "can". From what I see, successful
execution of tcf_proto_lookup_ops always means we now hold reference to module.

CC me in v2, I'll give you Reviewed-by.

> Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/sched/cls_api.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2621550bfddc..92bfb892e638 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2952,6 +2952,7 @@ static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
>  		return PTR_ERR(ops);
>  	if (!ops->tmplt_create || !ops->tmplt_destroy || !ops->tmplt_dump) {
>  		NL_SET_ERR_MSG(extack, "Chain templates are not supported with specified classifier");
> +		module_put(ops->owner);
>  		return -EOPNOTSUPP;
>  	}
>  
> -- 
> 2.34.1
> 
> 

