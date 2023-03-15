Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7347C6BB42F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjCONOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjCONOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:14:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9248F298CA
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678886065; x=1710422065;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=gwPTZYclh1WjOU6huyBXG2MTAD5Hwv7v/s428MOQOLI=;
  b=anBhPCWEP4fFg+JbnF4B/HDnrR26BGQPfZPjyGhHGCzP+iNSxbuXHA+T
   ddyog3+XTwbLFUB+9Yr/UzmgA6fZVU5py+TkI2GhUofYKmPmprdL6U4XR
   7xHqjaPBQ/mpRaGPhvSGLZEFFgoBZPd1htmg5DjWBmlgzSLWdrDPvQd14
   FfFhy862AWOVg9mfUqcyGZGDMgQXi8gj1/+DQpYuKON+BMI+J35QYshST
   Uwy4FHvlvqQYvXN7hT1Mv+FJLlHxybhFmabqEg9574Vq7N+xe3J6pN+/s
   2cPb6fdx+sD4pizMlWaD1QkXBjRidAemNjwF2h8zkvbYz2imHTiTJvZBw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="423968098"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="423968098"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 06:14:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925343243"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="925343243"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 15 Mar 2023 06:14:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 06:14:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 06:14:24 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 06:14:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbqRQAD2u06Bq0G0+jqRE9lGFnCfJoMVavB7uFGk33PMLJDtadtRSQ3QZlGf9gG8FicpS5jW9rReCC7avvH1KssDwYsT0GwH9U88nR9Y9xagJAVIqxUXajBrAIllEeFBSzCtoAn5jAIlJd+0cPt72eUgfiZD3YB8zo/WD8xVcxZ4TfHuQ1WcVOQnQujRsnjhzDSlFvSVxnFkjewH3jRcDRgwi/vOTVU3OnoAtd0ohNOsczHFjcRGlKHPTsDidIrXJel35nhPeLnKxM6w7KP/XacVA4azimqB5QI7uJCB2ZgmTsz77vge+s+Ae3XO33loD1cCy7yQT55kfnma8EcH4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXTx4QJWeh3tSGCd45SE52sWvBcRQOYOEB5Xrcfo114=;
 b=FML+tYW7/EjfcsIJQ238a7d8uU0xdSJ1GD1/STZVY/0fIqeFh3AuMDA/aiKz2n1qujOdqlBttFEBjmarUb8W35omibxn8WOprx8qdI0PVwEp8eWJio7Uje3OZE07x/nmG3XaETjRBZrWWQNjkio3Fq4Yt9LkVGo2WhNDs6pcVAMls52r3vZoT8PsKq970bY4EPBMLqPIiCx5UMoV5tbpay5PhJOvj/PLIZywtojhSWbnmAMoTafqNlEO15hef869j4j22ZpRlmpI+mjR6wlUZntVBU5MAGNkJ5WDZ/6bt58lTx6b7AUHqermhPs2qOK8xWVSChc6aAaTnyOFa7qUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13)
 by PH8PR11MB6903.namprd11.prod.outlook.com (2603:10b6:510:228::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:14:20 +0000
Received: from PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056]) by PH0PR11MB7471.namprd11.prod.outlook.com
 ([fe80::37bf:fa82:8a21:a056%2]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 13:14:20 +0000
Date:   Wed, 15 Mar 2023 14:14:20 +0100
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
Subject: Re: [net 02/14] net/mlx5e: Don't cache tunnel offloads capability
Message-ID: <ZBHErK6uc5WdEe5s@nimitz>
References: <20230314174940.62221-1-saeed@kernel.org>
 <20230314174940.62221-3-saeed@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314174940.62221-3-saeed@kernel.org>
X-ClientProxiedBy: LO4P123CA0120.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::17) To PH0PR11MB7471.namprd11.prod.outlook.com
 (2603:10b6:510:28a::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7471:EE_|PH8PR11MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: ca1881eb-7d35-420c-223d-08db25573044
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C0DTCvJiW/WPXihQMhDD8xK4SJrQmz6qigmrVvyyNQB5baldyosxYhhWYVrMrBbtwkPVJL3BFHDA0gCG7gMqkMdz2cA0zLpqsplQXYCYJlJchE6dt0vwX82NQvgwl27tGk+TMGHVKFYBsooXZ+fn6/m7Glf9MB3NT69jrT/StB+qn+kFaxlPdN+rDhDWnSBU91G+LiFDe5A8olVNl0qvrN4ee0U6zLySo9ZmFPCXWc4Q8uJGejWrWyQNqjwIshFnMzjXIaUAnlib+6Or+D+z3evhrd3du/q/Uh8AHZmZEJtZzacGVTz0rvwUgM61mXKCkMdmZ0iD3eOW2pZqtPeDD63un3K10sVDtmamyzpxkNnIXX4c3c1VoInwfIK6y2B2sD22A41w9JumZTg3l5IVwCLYMfL2JTDTvjFvSgPy+U2j8T2CSGTfY8QgwySfPCuAXdvvjh9Sr4TA5tvzFCPPRddwqdW5ap6mBwozfBd0T8bdeHHdyIjh+66o/LvlfQUwxiE9KsiibVzKWwI0kPtzzbGw+eW+6LGJ/+fwb5B1E3KsImnBZaZTbGuiMMgxXalLNP77a2sjQrcOtZYKHSDMLrY8ie+j4UCD9za5XchpNqWMhzuZWObQ3+ryQS0acEYVZ0fbfwNfXCGgS28yVQtf3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(33716001)(83380400001)(54906003)(478600001)(6486002)(6506007)(6512007)(26005)(186003)(9686003)(38100700002)(86362001)(2906002)(44832011)(7416002)(5660300002)(8936002)(41300700001)(8676002)(66556008)(6916009)(4326008)(82960400001)(316002)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tkBRVsxlBqnjLIVvwv7jQYvXhNfN9Zr3+GpxNipaeR/KxRHJiOOh7mLdMzKV?=
 =?us-ascii?Q?jiXqawSzguiRBjFq1RX+/k52IKHXbUfG5PRfMTQUHag981nzBUMDYHuc436H?=
 =?us-ascii?Q?LNJyVZTan1qdqHHSyF/VLck5X6E7jN2sdrKQP7+QR5IIBXjsI7+LKdPprwgt?=
 =?us-ascii?Q?qyPb3oTh26+L+5BhLNkGYG9FNyQrBvWTFvQN9m3YpUDT7QRLaTo0VYgtCICb?=
 =?us-ascii?Q?m0A0et13yb1XqnjMl+sLkriVDlYQLwPMPww4FcjdX6MPxbWWV2+riGMDiY2C?=
 =?us-ascii?Q?72qUOrL28fOWxM+tE3Up7H2oDZ4xCvAWxzd+I6crPOxD49fpso3flAIvpMKO?=
 =?us-ascii?Q?p+RYK185Dv/U+bRDlajeFetIkpjVq9yCpnUZnybRZZwvm1SObT7LbB7+bcV4?=
 =?us-ascii?Q?F08GzQ98jl+0gxh1uEvGS8qzd/8L69x/9SQfNt1w9HpBVI1HyZq2LRPXCeFl?=
 =?us-ascii?Q?tLaC/e3UeHebZ0+Q4Gy82WzeIkFwlxmXlbklcz7gIKW1PFo36gseCXwz2WHg?=
 =?us-ascii?Q?q0y75q9+rcKuNyIbMILufAH0TZM4kaHn7+vDApZ+bYtjNnZttS9tS2IyRTfH?=
 =?us-ascii?Q?Cb9a+KhtI91pvQCwpYpZJt9sdPJD6Z+VXJY7nyuWKfaElLEftxscVTCG5smp?=
 =?us-ascii?Q?sHhLEJIRVV9xcarAqqBFB77xmR9+dlvz6PYx5Y3/g6c+r/K0F5NZu4SNTH5G?=
 =?us-ascii?Q?FB7jaMm6MnFV80QV5U+VNo1rr7toh3nNqUYWOcAD1ZyOjgiFFBQi+BsZ6MZJ?=
 =?us-ascii?Q?5XW86ki2mxwbT+zfHTct2tgSYaQpC9wRC3SPtGYGwFLjZdA0szaztFMMbe/t?=
 =?us-ascii?Q?icYVdF+Z6ftR4gf1AwssH2dOzdtTiXnLTCEgrOpj4sCr9f88V6tuxVc1rYRQ?=
 =?us-ascii?Q?0vPtGkxHRxOugws9o5KrZv1U8ba5HKoc1+WdaGk8H1yrqgTKQrgVzeyN4/jI?=
 =?us-ascii?Q?cUsB2VpYIYejBOcJ496dFii//aUA06ONFyzYpT4vjzkyXujCnVE0v506tTg+?=
 =?us-ascii?Q?GEuoY2rjl5Z1JyRoXA/MouO5iT6KofMtRGg1Yem8r5jRsXWcu3w3KsnpPQ8d?=
 =?us-ascii?Q?oxuJHwwMmj29KWxzNzr/xn5QI6+QJUcl49b7iZfyY1hSfzOLWrozjkLXF2X0?=
 =?us-ascii?Q?lCj56mTmo/rceWQ7EbJGUwJ4oJVLaI/dK4o0AeyurPh3tQMOjMoRQBk8BikH?=
 =?us-ascii?Q?HkZi9q2QAGtegNrh2Usr+MhMAgkEZCGBJgie1FwyN1ytxT+tzqmZ0DO9YtcQ?=
 =?us-ascii?Q?93qI/n9zlcAbjs+lP0xWLsuSjsna+9t2pJcA8m/wZeNwfJBpN4ZKwHPhCKHh?=
 =?us-ascii?Q?cUm8nDKOtiKzjg5DRqt6swlhDXkk7OMj7tPOKtkb1chj6uU/ThBBsBIfxE8f?=
 =?us-ascii?Q?c1Y/483Bg65rw3pdrudrIl/WHIiDaVQvLymUeuvSJVCznD+3HrSU6SpYZ+Zf?=
 =?us-ascii?Q?Aok/rMR1tqPqBO04hbSUTGpuYHCydHcJgAklkogHY81W9xxGt9cn71j5Jjxj?=
 =?us-ascii?Q?PKneb5xNw9kUtB+WXjjJo+qzC6m3AF/Ji+UHrPf62mMkqXNF3/stfs7XPF4Y?=
 =?us-ascii?Q?uK7KSKTp86NYnKK6XzQaIXvJBmuTu4cvQy1ytvoqfNbOls6IETrW8bhtNh3w?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca1881eb-7d35-420c-223d-08db25573044
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:14:20.6617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IWuznZCQFVpu0VTmVE6YlmNgjFfe4rG8TjRQQfEJ44dAwuzxV+hRe+k6k86lEkvuAFgvrvVT2y127/PvA1oq/dtQ3LJrdHIF2CdQJ1UcnpI=
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

On Tue, Mar 14, 2023 at 10:49:28AM -0700, Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> When mlx5e attaches again after device health recovery, the device
> capabilities might have changed by the eswitch manager.
> 
> For example in one flow when ECPF changes the eswitch mode between
> legacy and switchdev, it updates the flow table tunnel capability.
> 
> The cached value is only used in one place, so just check the capability
> there instead.
> 
> Fixes: 5bef709d76a2 ("net/mlx5: Enable host PF HCA after eswitch is initialized")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h          | 1 -
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c     | 4 +---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c      | 1 -
>  drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 1 -
>  4 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 4276c6eb6820..4a19ef4a9811 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -313,7 +313,6 @@ struct mlx5e_params {
>  		} channel;
>  	} mqprio;
>  	bool rx_cqe_compress_def;
> -	bool tunneled_offload_en;
>  	struct dim_cq_moder rx_cq_moderation;
>  	struct dim_cq_moder tx_cq_moderation;
>  	struct mlx5e_packet_merge_param packet_merge;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 51b5f3cca504..56fc2aebb9ee 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4979,8 +4979,6 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
>  	/* TX inline */
>  	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
>  
> -	params->tunneled_offload_en = mlx5_tunnel_inner_ft_supported(mdev);
> -
>  	/* AF_XDP */
>  	params->xsk = xsk;
>  
> @@ -5285,7 +5283,7 @@ static int mlx5e_init_nic_rx(struct mlx5e_priv *priv)
>  	}
>  
>  	features = MLX5E_RX_RES_FEATURE_PTP;
> -	if (priv->channels.params.tunneled_offload_en)
> +	if (mlx5_tunnel_inner_ft_supported(mdev))
>  		features |= MLX5E_RX_RES_FEATURE_INNER_FT;
>  	err = mlx5e_rx_res_init(priv->rx_res, priv->mdev, features,
>  				priv->max_nch, priv->drop_rq.rqn,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 43fd12fb87b8..8ff654b4e9e1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -755,7 +755,6 @@ static void mlx5e_build_rep_params(struct net_device *netdev)
>  	mlx5e_set_rx_cq_mode_params(params, cq_period_mode);
>  
>  	params->mqprio.num_tc       = 1;
> -	params->tunneled_offload_en = false;
>  	if (rep->vport != MLX5_VPORT_UPLINK)
>  		params->vlan_strip_disable = true;
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
> index c2a4f86bc890..baa7ef812313 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
> @@ -70,7 +70,6 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
>  
>  	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
>  	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
> -	params->tunneled_offload_en = false;
>  
>  	/* CQE compression is not supported for IPoIB */
>  	params->rx_cqe_compress_def = false;
> -- 
> 2.39.2
> 
LGTM, thanks.
Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
