Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB6E6BB3FC
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCONLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjCONK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:10:57 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2751C968C6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678885856; x=1710421856;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lvq11KOJ2RtxkmjUyJvCOqWHtJ6bgYWkU/K+H5jb884=;
  b=Lbn5iNpn19AMd8fapgS6irr8SSvxSqoXlk6n0ZMkF/BPPjdyiOCm7InG
   Blu4OYSzFvyDgmYZe1455FfzmgXVleLAL5CyB+qbvL7dUuisNwv1a3rdG
   LMqLTRGjzPkElZtIe/8SiSup8Kn3fL3LO7jYfDKliHU3Ic1iW12t3G3Lz
   xUmgb5OIn1x2BKpDz8CKPtt9BV/nhtDd7LMzm9OqFDH9MEbdTwNz5vAJV
   Dai13YIA9QexjghWUC9c1S0dYch3xDQ2ms1xbJcb4hdgkLVygNUKvHDFr
   /S7j9bFbk+8vtAAZsMF8ru/jPasvaHGZSTybZbXiBiS2XQYwHAFzOlB2C
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="335184562"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="335184562"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 06:10:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="743688135"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="743688135"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 15 Mar 2023 06:10:55 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 06:10:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 06:10:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 06:10:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRfmhm2I1N/Nqxa0WRC47Gvvr3GtT4QjHdMlkoNCaTmLf0ccdzLZSyIoF3GBYpytsdf7EHAz1f8RFrdVTbhbzA0L4WQ2D8O780Adt4Yy6fCqBN/6xekjrGiy46ORGRuxHts+MzlsvdbGFP5A07GmwURqH60v/m7Jds+nYM9iBQSTfiEcT1SMzf49+xOiZC6/vGu00kubx0wKKUm/puTa4+Ggmr0ibuzPXv2HiHLXltDiokO5Zb2G874ofcHyv8mi3nSHzWEzDaX0LAlk+h6jEgkm7t9D+vR1jIw5VUWrof34uWMVZjFTjJC0NdNo2KaqYUR/7J0BrNB8CFJDucKNnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xi/O56pnH4fB7Z0qTcN55x76lz/oMZWHzQ4mHp0z6UI=;
 b=Q+HP5DwbhPxMWfSnK8kfEI0DA8I7vkkN0my1GCdQdrQxMoRUiUFzCWI/eAwBtc2fAf3e/Yyrgrn959N1VNW9MHYXizA/YBaHrC4uKCiELFtFWd4waN/NZ9tXUt1XjQtKxaphgRomcSnhSkPI3+PNVnjTecol23l9gLdamPwMz51WEXuqAuc2xIOUeBHYMJ0+7/g7anaeskugGVwefepIC/mQ1LbpzWt0fEZx+CxYcg6a5PPgGln5kCW1uWBh+uwB+KWjaJrqSMmJcAgul2Eap3pNk3MoJRwaFxEsz+J38ypH3WLM2X1SODjolBDL5qsvKRx/omp7/At99sJf9p7tLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH8PR11MB6903.namprd11.prod.outlook.com (2603:10b6:510:228::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:10:52 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 13:10:52 +0000
Date:   Wed, 15 Mar 2023 14:10:48 +0100
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>
Subject: Re: [net 03/14] net/mlx5: Fix setting ec_function bit in MANAGE_PAGES
Message-ID: <ZBHD2J8I1WGf9gnB@nimitz>
References: <20230314174940.62221-1-saeed@kernel.org>
 <20230314174940.62221-4-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314174940.62221-4-saeed@kernel.org>
X-ClientProxiedBy: LO4P265CA0247.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::6) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH8PR11MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: dda0144d-3fcd-443f-67ad-08db2556b3fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmveMEOmJb1F+BBxEMB6dB344ZzMiAagCk6pRlmhi6q7iU7fMpuAOPNvKEJMnR/n1leHW1jr0+DyLHliljhfnS0N5cJkoSUv9nZbOZSxDz9i85Lg17eDzOkpHwqIC909RbA//RgvCg3b1uAJtQh/Jc5+lznLtTTzZfoWDW258l6I/ZGRs5DqoISOah2lzfO2B98+76eWJQH9GWsByDpWnKy3e/3mfsrbz5TA5pzwk5YWtIXycHK+NDkRCPKRAoGs825qinuE3nFyWMhILOYsy0kbToif7cX+arpU+GcUY55/1rs9yz+e7r5V6etVCsUwAA4/Gp5z8Nkl8ZIFvDSmVnZvwbqTF75THCM7HLqJalHcqC3p1Qpj5v07wC37wN9Ub1WGZu4dvvFNlJhmVNxWXuq4ZxS+Cdp2PFlz0qaH9ovn5HuZwIR1ZkQeQQkR2ho2dMOc55tNWfP+Izb+KjZjRfdLIXaGm1K9BztqpVj5KQYilOFXk1NTC+Y3Boabw+KUgWlDPoudUdXEsfiY+XFflWE0oRK+ko/IyqXfPQY5oeJJ+f37dyUfmy2IHlP8deZFbJJJ3hL8YR9DzctDw8f4gyclaFpTNNvSozEvdS8jC8D6zSP7PJKl7qkklIlOlR/MtyHefI8ejh7Tzs7IMV+zeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(33716001)(83380400001)(54906003)(478600001)(6486002)(6666004)(6506007)(6512007)(26005)(186003)(9686003)(38100700002)(86362001)(2906002)(44832011)(7416002)(5660300002)(8936002)(41300700001)(8676002)(66556008)(6916009)(4326008)(82960400001)(316002)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aafnZFtM9JmPJzNiMi2msDSectVopbuntq+CZu7phIg9N687g8ZgolvTUeCO?=
 =?us-ascii?Q?/HK+bt1Wsml0DUgAiia8pBmWiF11g3eS2XwJ0JajMqU29s/2LnDXn1WkQTHz?=
 =?us-ascii?Q?+14hvAPhcuB4IIY+bMesq/tdP6ttY5OQLQPkKj5I/oBlEW3KyuSUrposi7ia?=
 =?us-ascii?Q?9t7Y7DLeAfhs9z9HU6gtM5UIpkIEpCqn7AR5HiiMLlGX59sYPOJwp7LJhusK?=
 =?us-ascii?Q?inB5kz4lc2Wrl3ie0OUgT2IP8T9tj4kEpOKcBfWRrPmNH4BqBKRuR2zY2hbs?=
 =?us-ascii?Q?cwuD5XZqr/2FqSoM00P3Y1JvnIXVW84KNz2jWYbkLsU9XopXdstgomydvZc/?=
 =?us-ascii?Q?pj5qpsDLr8IEmGEL6CiKdQHVJfwHb0iCuoFmY9Kyo35i9GY/qEvbhlxTQ6jp?=
 =?us-ascii?Q?VLqdaOUMFP1lWBmPRoNO+6q90d5b0nFN91bSGPzVykI9SG3Skt3/j+R45lEs?=
 =?us-ascii?Q?7yvZ63ZAF8HY06Dwgb2fN7gZNebS5aRWYZxoEvN2ToBnbyjYUBrdY5uVhZJ1?=
 =?us-ascii?Q?RsiQuaFF5X4M3qMnV2T/FlrqbYiqJF+Grdcl1FwGexMQsxvkXyqnQp03GHYW?=
 =?us-ascii?Q?iQ61qr5N+3HU9fY70XeAi763UuH6WkInv+CcehctkjUTWKShQnZM0DWH/tsm?=
 =?us-ascii?Q?KdFAb+etWo/T4EKlqdjOR4Bj5E6QvIKxpuuHYCywRuVsGzckp+HDLeTO1HlI?=
 =?us-ascii?Q?25qWRNKnwJICg58XcCsna5ERAL011mgrUVMqyvkEjIzzlKVmzvUDHdApx4j5?=
 =?us-ascii?Q?uRz55icpAvSOBPvtdTw3Q4L0+FL+7yfoF5YDxjo/yGY283VRwnQwknzyCTCM?=
 =?us-ascii?Q?dtkUJ8/YXcmfLgy7nqqWEkjJTgTfsqIvpzsnMLUa4aAJbL1j1w+I76aaP9f0?=
 =?us-ascii?Q?MmI0+cd98bEJ/S5NA3vEZ235uo1wF0wIgCLAnN6UWhgDIQCbswUcE32Deqmp?=
 =?us-ascii?Q?RflB1b8Zsv2aYCcGua5SCBKD8OkJoyylSASFHGxeyvXKMky2700P2i9p5SAo?=
 =?us-ascii?Q?aAnHLxwiTRX3PiQjJXvhU8CGNBRoklaH/rSE8EFRqyO1v20kKodHUOrlB+ra?=
 =?us-ascii?Q?QeGr3VgFbINK09JZhgdjKAMxlpGIuRmsA+AjmZJ8dcFv7nu2c2PUYmzBSUNg?=
 =?us-ascii?Q?1txmU8d/pbrINX4a5Cw0Q34JSM+415zyE6uSOyhT8iigCd/mZjoAHCxXnD1l?=
 =?us-ascii?Q?pYnlo+mNS1l5BWLQy3f+0IoMeAftwYD+x/ISrONcTh5lCR+AJlpNA5PxQ6o3?=
 =?us-ascii?Q?lpaDbUsjJu0p0dwXL1cQGKuuleHBX0EgW2qMEEiRtFDQT9RsE0ZcLSrANQeB?=
 =?us-ascii?Q?OBGm8CJRFPVEb8eu0fmV5PAdGl7VsdPD0C9IXn1Zlpfrec2Tsm1WJQ2paxBW?=
 =?us-ascii?Q?qBfK4NVvvfl2ZqRWGf3OOIOAAPKNB/H5fZVaCKEldCGsLtIuAoj+2tntW9EY?=
 =?us-ascii?Q?ugayxqi1p3A+h93/U2TbEdb6DcaQhiZ6Ps0PoUI6PrRRRbwCROAvlff02h7O?=
 =?us-ascii?Q?Ji3B54Mvln9RGRPhhJQAbCD+QwGECaRKViNJVMPJiWnrVRmWiO4pXVLZasT6?=
 =?us-ascii?Q?nit3sxfewlHm4LuaGtgAt6FPkq4+RnD7UAJ11IX74B6wkwAzwNo0a0PXsvkb?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dda0144d-3fcd-443f-67ad-08db2556b3fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:10:52.1697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 276VbZ/0vvG1TFq7sigVtbMHwQuJ1uuA/rAEbZDlAuHCkgolok7dkUqTxQRZxoZmW1pUOrGXyfR7fUwLBpKhEwVCIG/R4kKGQxgwh7OSrSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6903
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:49:29AM -0700, Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> When ECPF is a page supplier, reclaim pages missed to honor the
> ec_function bit provided by the firmware. It always used the ec_function
> to true during driver unload flow for ECPF. This is incorrect.
> 
> Honor the ec_function bit provided by device during page allocation
> request event.
> 
> Fixes: d6945242f45d ("net/mlx5: Hold pages RB tree per VF")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../ethernet/mellanox/mlx5/core/pagealloc.c    | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
> index 64d4e7125e9b..bd2712b2317d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
> @@ -82,6 +82,16 @@ static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_funct
>  	return func_id <= mlx5_core_max_vfs(dev) ?  MLX5_VF : MLX5_SF;
>  }
>  
> +static u32 get_ec_function(u32 function)
> +{
> +	return function >> 16;
> +}
> +
> +static u32 get_func_id(u32 function)
> +{
> +	return function & 0xffff;
> +}
> +
Some code in this file is mlx5 'namespaced', some is not. It may be a
little easier to follow the code knowing explicitly whether it is driver
vs core code, just something to consider.

Other than that, looks fine, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>

>  static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
>  {
>  	struct rb_root *root;
> @@ -665,7 +675,7 @@ static int optimal_reclaimed_pages(void)
>  }
>  
>  static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
> -				   struct rb_root *root, u16 func_id)
> +				   struct rb_root *root, u32 function)
>  {
>  	u64 recl_pages_to_jiffies = msecs_to_jiffies(mlx5_tout_ms(dev, RECLAIM_PAGES));
>  	unsigned long end = jiffies + recl_pages_to_jiffies;
> @@ -674,11 +684,11 @@ static int mlx5_reclaim_root_pages(struct mlx5_core_dev *dev,
>  		int nclaimed;
>  		int err;
>  
> -		err = reclaim_pages(dev, func_id, optimal_reclaimed_pages(),
> -				    &nclaimed, false, mlx5_core_is_ecpf(dev));
> +		err = reclaim_pages(dev, get_func_id(function), optimal_reclaimed_pages(),
> +				    &nclaimed, false, get_ec_function(function));
>  		if (err) {
>  			mlx5_core_warn(dev, "failed reclaiming pages (%d) for func id 0x%x\n",
> -				       err, func_id);
> +				       err, get_func_id(function));
>  			return err;
>  		}
>  
> -- 
> 2.39.2
> 
