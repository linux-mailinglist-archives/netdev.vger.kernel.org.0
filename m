Return-Path: <netdev+bounces-8719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B62EC725545
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58A5C28120C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905AD6AA6;
	Wed,  7 Jun 2023 07:18:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9121C3A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:18:58 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CFBE6B;
	Wed,  7 Jun 2023 00:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686122337; x=1717658337;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U9BMiHlbFJNvV44cawwgmHJfPZst8d6vbpWFC5n0oo8=;
  b=DPfg/cvvDwxBVEivyMQwRQ0WPPyBvlLjp4ze//cL0/mjsIiaY5gkT66F
   HhKTJUsjb0yyD7DYQa39BSz2nai/Ux9Zuk/4+BkWbu844WlfJ2xezi/CF
   t3MD+vcWTSJWt4md/m+j+r272Dq9FG+diRSEk45oijSYjimm7E+THvYSL
   y24gJNomJqOGxb3PRmBI09P0/gO+HseDoeszH6th2pouQdHeLc95w2MbG
   xXKEmy478++8jMqt+9N7hp35qL7raH2LcMedmC+sQn/Gzn8OcFbhVfdRp
   UIhV5N6vctr3i4A9Yvx5PwL02hQePYsWFNhzk9KNyB+zE7EhkxCKrNh+e
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="420461772"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="420461772"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 00:18:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="833552774"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="833552774"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2023 00:18:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 00:18:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 00:18:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 00:18:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 00:18:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EG+zngTyWI0cZqfM1aH7ukOU9FomMOQwGW63s1glIRon1a7ghoKkRe++TduSYiwYF73yKSKyZiUGGwtQCkGstWU6ObS7P4sjunx7WG/WfD+C9Q8cn8n5gUwsca7VIbhg7NyhbP83d/J6myssv4LHKGkBXREKWhu0zUXwR3gruKkQw4GCYvcgJoU7OwQye1PNVgp/WGO8t0upyVyS2GUi5Jh+XFnRCW5z7sVo0wOjdYvnBEBhKZwoLdSrrnVM5e6NJtdnVgCXaGqpTRXU9n02IhWJ8WSh5FfltE2Q0rKEtH0mtOApQXMK5nC4NuPDSCZuiyxVEok8NuUI6S+z0AixDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLC0UU0PVcfkyTb3Axm+8MBdI/8sGCCCx1tjt6UiWIQ=;
 b=Z/qKrP9cEO4ZnQGDP7UUGVttcfjrB3/oecVDqgoi4Q5tRWJtQuRBn1ANl3vt10oKre38Wa3TpqD5CRokSDmUMFAEtDVCZVxm44WFA1hbqzjo6zrsRVYg1wJZTDcmavDVqn51xSTHKGjy1Bw/8xYJrhwoRMRYoe0hyJP7iEVb4KphE8qGySPaNMd1yZLgOHLJBuksna1UNWRgQVu5LXReZl3wiGt5ZCOsyZJxYWF/ojGZtCgeS9kwTa5Rs62XpHzXh9qSDH0keiaqJoxkt4pyvtVMCbOhCWVyDXM8E/1hmZoIW1K9so4O3wVh5TpXf13CYNQtc4JPmFETJhnxECP23Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by DS0PR11MB6351.namprd11.prod.outlook.com (2603:10b6:8:cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 07:18:51 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::9376:9c9d:424a:a0fe%5]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 07:18:51 +0000
Date: Wed, 7 Jun 2023 09:15:52 +0200
From: Larysa Zaremba <larysa.zaremba@intel.com>
To: Hangyu Hua <hbh25y@gmail.com>
CC: <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: sched: fix possible refcount leak in
 tc_chain_tmplt_add()
Message-ID: <ZIAuqHiemLrpH6Fr@lincoln>
References: <20230607022301.6405-1-hbh25y@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230607022301.6405-1-hbh25y@gmail.com>
X-ClientProxiedBy: FR0P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::20) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|DS0PR11MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: 674c6cc5-4ea9-49cc-7e88-08db6727717a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /j0e4NncTXptfCdLHkEfKaEjaT4dZgNtxsd1zlv8PkLBxckzFQxC4ujFemppw7SIixhJooABiVq247GAFjlF1Q3jBMx6AKA+Tpdf7k57I19G5GIr/R/SfWqu4vMP8SbB+XjUUyMytm4Tgfrmtli/sFjbHb9h/cTuAwMyKb1M/nssvyoG0i8GUOUFuFS++b+zsPlhDS5tApenVMXTRhQSGRIcEZ4N5PU3M0JdJ7UV4gEfHot3ajE3Jv35oeGUvKkbQ348KJEvxxDC+Ra4AZKfPa9dx37oNSc8ibuMBxbN/yPdHbp4BLrGsOj4nwpU/nzUH0jsvRi4H6y8lrtQOwMVvyU/9ry8/Lg+1jorYQTQook2MnZJhJf+cyIuRLW4Vik69FgdfuX5HmjS45iqYLa67d6vPW7yuJCDZNRopNGEzSZ+5VZqWZRMHhhly3GG0nJ7lBZzeiIOAqdhb3Nm9d0TGI6itbKOhACRWNKc9fdPzd3jduwk1zbp452Ar6+rQMZHu1eW29vgADQCix2tcU+R5hW+bV6WFzqE18kUqNex5av0Mwx+O5UHfo9mqCEfpk/F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199021)(4744005)(2906002)(33716001)(86362001)(82960400001)(38100700002)(41300700001)(6486002)(316002)(5660300002)(8936002)(8676002)(478600001)(66946007)(66556008)(66476007)(6916009)(4326008)(6506007)(9686003)(6512007)(26005)(186003)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fACWIt3uoGJ+qX1uakAq1C2/uSxDwymw/svzHDyxNDhUNdSDQmM5/zG9wGah?=
 =?us-ascii?Q?C+ZuEV530kPF1FoVp7fJHC9G9Pr5P3/ldHNUALYdD/aDSFOeeMbf+Pb9dSCy?=
 =?us-ascii?Q?BzjXL1mRK/VEhIivOGB87gszlxn/Ekc/JDEe1ppEfjIhwLe5WOunL0WUr15f?=
 =?us-ascii?Q?RaGOHqX5A1do2NDvZ/dxEcjIVL9hg+w1c8C40YeKG5vkDlf0EwnrU/f0IaID?=
 =?us-ascii?Q?FkP8nBw6pKueh7e0ds3zUe7/rvhowNUxQUkl7H+tdF+/feHBGAoFiiqW5TfC?=
 =?us-ascii?Q?jhgXmBKOs1I7unCzV8H1u0zhtq2Zv/MTDdcAUIRyOkqJMOh2q3DGnFy1SVyR?=
 =?us-ascii?Q?ANUIe4mHoyXd5zRx21KADkA6Cm2jYnEadEgGB+jQ3ekdKkkl5JJhCAwFrMoF?=
 =?us-ascii?Q?JBrV+xKw4nbXSXxhA5WIDmtOUQOsYZkamIKvLReG2jZAOcCd8OrViaHVvUQA?=
 =?us-ascii?Q?1KqK+T0ugzlVhzF6rx50pMdmCrHHtPxox6/jxUI+RaSn2HcVChhWPFt6GmRS?=
 =?us-ascii?Q?F0NT/4bgE038B/mEtDzhgDrX/Vp6No3TGapzRytq1QvLzDYqNtxmYabaKWRa?=
 =?us-ascii?Q?fPmB/wvTXKBq7zxt2PONBU3wUXOGNZ7Ulz3mVkn0ybzy+Yw+oyGMV/B5EJww?=
 =?us-ascii?Q?uQXJ8nApLmWSpblyp+KYozMmbb1uCVAyLL2lvxrvPm3XMgFoI9apnr49f2Xb?=
 =?us-ascii?Q?eCb+QmvIZqcTzeSucmQl3ivZQsm9vm5c3tsrto9TE75+piJfhrmqHUwNkLJR?=
 =?us-ascii?Q?FOKnkVUW4fiG4IYJMUTWCrRTd3wVgYwnS5jYCPotQl32qDLidCP/Owq9qpGI?=
 =?us-ascii?Q?/CcVXclfEtJ8UCE9Cbn28BsclrIICZArnDdy0XawPGbmJLPaIqYzdTkXKbu0?=
 =?us-ascii?Q?vQKDZTk/UO/fqjUW92OWL/+HHdu61kmwjM8Lw563Lw93mK0WRvTlsb4j2bRo?=
 =?us-ascii?Q?rwwOFfQ7Wx5BnLhXCxhZU40BA6FyiEvm9g+muBF88O+eHFXx9YMM9j4DwBc3?=
 =?us-ascii?Q?/YdWFUCzEj829dFxrQUui/Vua7O0JxMH7InAK4JkGMUntSFOzf8xDmrKkKYv?=
 =?us-ascii?Q?p7WC/tAP1oJIs/coNFTZPi5wG1px2LoBAqvosvsHuJbEbv5el8HTMi6DSMRN?=
 =?us-ascii?Q?Aag+hgjnFrQK8YMHIGLjmuLa5KyxtrF9mo3fmZrBkKvFj5Fo82IWNmf2eTNP?=
 =?us-ascii?Q?LI6lF+zA/lweD2G8YfzZ/UA/uwRDY8cXy5qAbPJYqkgCTdgzisHgFPvN1mIL?=
 =?us-ascii?Q?sVCeyC+VrIuuMPzsKM0K0syYMqwsJ79gIPkQkOusvTJXoyYmVuihDyXw2EzT?=
 =?us-ascii?Q?Dl+IfI6u9u5rsexKRVClIh6sxd4QbQVuZu8ATSa1XtAVwrzRE9b6MDrWQc/z?=
 =?us-ascii?Q?Z/979nd6EvmXbS90VeP1ROBC9rhENdzGeg4uftVy7lSE48CVnsSt0q9lU5Ed?=
 =?us-ascii?Q?+ACo3vX8kFtL+UtUVjrvBFeKvJ2GFBI65HYSv8EUO8dCacWNu3XWupzeS/7F?=
 =?us-ascii?Q?Lw9IIcyFU5rt1Ow4KVrvrjUU6l++e0syeTAN3Rjmvbn19fmT/pkIJNhoe/6j?=
 =?us-ascii?Q?FJIgPi8DI1BtvH8oHnjh78ggLwjyUyIb1BvSgPq4jBammOCmKnof8hLRJRMW?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 674c6cc5-4ea9-49cc-7e88-08db6727717a
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 07:18:50.9657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVeYhCc6JO6vW6ClUrMQZ50Qh9POMj/6v+t46xdU795AhWS6NK74J6FVSzFnxOJgPeyDgTQlxuViig6afixL0qeMfA5Os6auGt43DHTeCmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:23:01AM +0800, Hangyu Hua wrote:
> try_module_get will be called in tcf_proto_lookup_ops. So module_put needs
> to be called to drop the refcount if ops don't implement the required
> function.
> 
> Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> 	
> 	v2: fix the patch description.
> 
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

