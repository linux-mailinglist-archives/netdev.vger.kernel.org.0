Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF27D3DAB9D
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 21:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhG2TIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 15:08:25 -0400
Received: from mail-mw2nam10on2063.outbound.protection.outlook.com ([40.107.94.63]:55934
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229672AbhG2TIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 15:08:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jttqaFPhYR7Y1B+DOKN1Ha7sUI3wIrMcExPq7mDJ4ZTefuB80w7g3S+4AVeDZMJrLgCYfJuehzT862HS55GVT5cZOJoNGxNmQDooCxVFSqo3Ix4BwKz+jjTW0dX7ymX1pnWQrDCB/gzEKcHrIrY6XTObERiDUiYTvFL8s8ueXnPi1flk3KQGCGj3Fm76dwLSZkKue1oAx/Aglhb2xn+aJK9qyY1PAiObHSg7SJ0OUKEinOqjgORyoD3Ynnmxc77rixs86HFm7jMhznyUET4UzFilnHKPD7RNuhioTtwpGK8J8jcbyS+Ct+jkiyiYhffusI7ZqH5GykUb5dwsfLsfwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdVewL3qBXOZk6UJxnYeIR8gScs7T38a0nmSRJziWyo=;
 b=E3PW7Ro0RXEAbR5Lh02vwgjtFEBJSOaPld0sFB/3xaoR6/RSTp+NYlr8iKQXAAvXvUtgQ4RPz6GYWbGZCheakmSS8M7tLQwpZK16+FwcIVcjnvGP6bodWPy5LSsKqnqozwtLbdJ2h7g9pDFANXOQenvHKxI1QCAaYiUAUZQs0KF2Pnca4pDSAoigRhVk6mxuT1rr6uE3WdKn63/EqImun5//I2lyYouEmAf5QTnb3EgyEvArvSarFA/HFeh0wR4jcJPhT5vORCeHTgxAHlxUpTRuI9lsIABa7N4t8kI7lYVELASCHD+f+pUy1IFNes6r9D7Px999Jam2N9BAHwk0CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pdVewL3qBXOZk6UJxnYeIR8gScs7T38a0nmSRJziWyo=;
 b=G/+BqDW0L9zinf2wsKnRHN2K8Bt3toZ3QnZFgOABFgMGWe5I5IkIg0gT33U3s1qpaY7Oup1ic/pqqQOuOFJx02U8RZFo2WtBsWRSpsmWLYUyY9A4hlA/Sp+hx5TLgrehpVrV2YBHSfRbRwc9VIHrPswdhl+Nqv+moC4/Y0VjDjZRPmsw8teT/y/oU0wXfT38yTi1f2B0sbvOdkCJ84dakuaual8VVCLBFYyKOLeoN9w5ZDd2YQEe2ZO75FtHFwZ70SV+fFxus7CjwsXdkyaTQm7dJKvP3Q6FgnGEhvJ76aXYCj1Ii5IhXR7/Rs/I9fhP1OkhHFFqdJfW7cVDcWSFmQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Thu, 29 Jul
 2021 19:08:17 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.022; Thu, 29 Jul 2021
 19:08:17 +0000
Date:   Thu, 29 Jul 2021 16:08:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 3/5] RDMA/mlx5: Change the cache to hold mkeys
 instead of MRs
Message-ID: <20210729190816.GA2482631@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
 <d14d051add7957f72d93fe8a9aa148d3fad20024.1624362290.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d14d051add7957f72d93fe8a9aa148d3fad20024.1624362290.git.leonro@nvidia.com>
X-ClientProxiedBy: CH0PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:610:e6::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0271.namprd03.prod.outlook.com (2603:10b6:610:e6::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Thu, 29 Jul 2021 19:08:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m9BOC-00AQBr-7b; Thu, 29 Jul 2021 16:08:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cde195d0-18a9-457e-47f4-08d952c4391e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53027637BA7E0CCC83DD44EAC2EB9@BL1PR12MB5302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8QVkEW3C3Btj/jQ61nC/rV3ItXB3bN7La01xMs7mYK6bIxssXmA+Bh/Djmk+fHXNDAz+2rYN5vpp8M7M5Tp97q6kx6s+4NUUFqCbk0vPRBYDfD/Yh6+tEo61FTd/+/NGlqQkR6xCG3dekVQ9DQ/VD3dY/Nrod7t2lclwh4MZTapT2LsY8/lim3HSlQSAHseEezVrnt7R/ZV2AGRml4dapGByqj1VBKqsgZdt5dxZYz11mrcSwSkUSE1e8I+glN68t6DZ2V/DvmFbz/wqn89u/0rWSRUuArvFUL4dJ/VORPMM4XEH1swpeM8SWpulogiebKRThzLKYh/6Ru9FN13eLMB2lmMIS8vTfCPp2WDmlnaAU66sP3wVBBSLCZ2uyfLu6PxyBIoua8FYgbqP8Mhpd9mEMrfasp7cn/m05qeukGSzae6+RZl8UGdnv0OTU8hCWf3mU/5vXDQp5JkXiT5dFhAcO0FZXm4mMO5dDPtnNsMTaPLPnrnBGA7LnL7gmJF6FwCKaw5FjOf5s56z3Zi8mnGl6NQYMDEYTz8dUMlFnk5zb6c6LvR79+UCA8Ga3eDrORFVi0F9U7pNO0jbbGytublUMiIwkNgVa6Y/zF3k6puAzHSHPtYAu+ooFvdV3RG7dUVo44xkUMspWxvOM6DFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(4326008)(1076003)(66946007)(2906002)(66476007)(38100700002)(8936002)(9786002)(9746002)(478600001)(5660300002)(8676002)(2616005)(426003)(66556008)(83380400001)(186003)(26005)(86362001)(36756003)(33656002)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E9ZlETV8gLcrzGtJXhRJT0hOM6fURMpQEmmY3GyVxs8ZsNyebys3B9z/xDHM?=
 =?us-ascii?Q?SOgHAQfXYSxqKY8utDk425uzlL2QB2aomKdqZEDaas6RY7vDaRMH6upluBWr?=
 =?us-ascii?Q?bC3DOmrLIt6w3I5jC9/YHfLvNR3V0I285DeOekQYmpiQnixCP9OBbSedHCx2?=
 =?us-ascii?Q?pKLmBN+spQCoV5UGCkbYvFFcRnLbEoJ6M0SRY4BZTSnZtwPzJGjRT4FMTiHj?=
 =?us-ascii?Q?AzWN3ml4DVjwN3kyysTEfBV8EVAELing4gqSAjE+rauA7fJPs8GmZVvlZ3IU?=
 =?us-ascii?Q?rDU+89C6l7SL5HMUjB9upWyaXLFHhD+dW/AQRcoxoUqvwrCLGmoAqPpE7ShQ?=
 =?us-ascii?Q?S1Y0dWW33LUIFUhfNnr1qls2lGOSZalzWpDatKyuBP1amkEMBw9a8fyyFmze?=
 =?us-ascii?Q?dEt0t4OJNN5i3XhGYWu9hSITmQxYjcN+XmRlEHADU37cgqk7W1QVPyAxFAC/?=
 =?us-ascii?Q?Io3627IB+dBks3aIavCx2s0pFNprHy1kc2ziXZyYS4TrzI524F+nm8U/RWiy?=
 =?us-ascii?Q?0IbL4Tdh1dm3INGANBI0mpPVmCmKH4Q0DIxbvtE5n5JNoNKLiTcvBARfjGDB?=
 =?us-ascii?Q?+PhxmkmBJcnFyQgWjKw2mZYlRS4cn+bWT5oyr7zSeSSWyvIlhEl6BnM/u9/z?=
 =?us-ascii?Q?edUsrTiVl1l/SkBmCn6F5uQIFC7d4mOf79PJNUXoJNvqGnruijBQz4brNDCP?=
 =?us-ascii?Q?YEZU/lFy/gwFb5pGVJ2cMYQT+k2iVrngp5CGZYQz6hp4N6Xc/BaT/FMEuPzF?=
 =?us-ascii?Q?leHimrgHjXlqbmxUS2Gt0q544fpWi26ncgmrNGDUg3qyb43QfbXGFHzZaUZ7?=
 =?us-ascii?Q?4hRVyecZiJSEUIQ+zijQv7EKjMfSm/iIaMLP+C71Xd18XqWalpnzRXWJsKa2?=
 =?us-ascii?Q?TJYmtxErratv7yWxabohPClf+AhoWxl9PDb29DVo5kd9K+MjWHaqnP0dU+Le?=
 =?us-ascii?Q?gV87Eo4GtJE2YKHF2ZdPIyVDNVy6LZI3AioRuXaK98IL0u9M/G+dZSFkXUqC?=
 =?us-ascii?Q?zAtITKDgDL3VcetL5OSyVy2vv8NipMMuMhoMWO8BnQ1kYwGLmpFxqJRoYzKx?=
 =?us-ascii?Q?I0yzQRdeaj2ehG9IF++tOB+wbwQFlgZ3sN86u+GT8FE9aE+1EB8y2q5CRb0N?=
 =?us-ascii?Q?Iiganxw3aJCugsR9ZwZHEdqLaSh2BZhkdzFDIhKRUU4bKjgzB/OFN4i9/Uhl?=
 =?us-ascii?Q?IA+Y3P4vAyzBOgQ7iOWpo66mSDSghJPuYuLlB6BL90RenrjXcNgoZLhkvlBu?=
 =?us-ascii?Q?xpe0MenFB/rM7TvH1eQjZTyTMwG1yvq6q0jf7TGKfMX8rRGdXrVynDK04aBI?=
 =?us-ascii?Q?7Dwmx2RwsOikw4Pp5wqXjet3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde195d0-18a9-457e-47f4-08d952c4391e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 19:08:17.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ClL17iAzjkJoQtpVbrkvSvyK4W9aeG82MoriC6TeptJ+eXg/FZnkOtDZ4JXLxALQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 03:08:21PM +0300, Leon Romanovsky wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> Today the cache is an MR-cache, however, all members of MR, except for
> mkey, are not being used in the cache.
> Therefore, changing it to an mkey-cache so that the cache has its own
> memory and holds only the values needed for the cache.

This patch is quite big and seems to be doing a lot more than just
this

Frankly, I'm not sure what it is trying to do

> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index af11a0d8ebc0..ffb6f1d41f3d 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -634,6 +634,15 @@ struct mlx5_user_mmap_entry {
>  #define mlx5_update_odp_stats(mr, counter_name, value)		\
>  	atomic64_add(value, &((mr)->odp_stats.counter_name))
>  
> +struct mlx5r_cache_mkey {
> +	u32 key;
> +	struct mlx5_cache_ent *cache_ent;
> +	u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
> +	struct mlx5_async_work cb_work;
> +	/* Cache list element */
> +	struct list_head list;
> +};

This is the point, right? Lift these members out of the mlx5_ib_mr?

But out abd cb_work shouldn't be stored in perpetuity in the cache, it
is only needed short-term as part of the callback for async mkey
creation.

This should also be organized to not have so many alignment holes

Actually the only thing it does is store a u32 attached to each rbtree
so this looks like rather a lot of memory overhead, plus the
kfree/allocs.

I'd probably do this with an xarray on the mlx5_cache_ent
instead. Store the 'tail index' and adding is
'xa_insert(tail_index++)' and removing is 'xa_erase(tail_index--)'

Use xa_mk_value() and I think we have less than 31 bits of mkey,
right?

>  static inline bool is_odp_mr(struct mlx5_ib_mr *mr)
>  {
>  	return IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && mr->umem &&
> @@ -763,16 +758,16 @@ struct mlx5_cache_ent {
>  	u8 fill_to_high_water:1;
>  
>  	/*
> -	 * - available_mrs is the length of list head, ie the number of MRs
> +	 * - available_mkeys is the length of list head, ie the number of Mkeys
>  	 *   available for immediate allocation.
> -	 * - total_mrs is available_mrs plus all in use MRs that could be
> +	 * - total_mkeys is available_mkeys plus all in use Mkeys that could be
>  	 *   returned to the cache.
> -	 * - limit is the low water mark for available_mrs, 2* limit is the
> +	 * - limit is the low water mark for available_mkeys, 2* limit is the
>  	 *   upper water mark.
> -	 * - pending is the number of MRs currently being created
> +	 * - pending is the number of Mkeys currently being created
>  	 */
> -	u32 total_mrs;
> -	u32 available_mrs;
> +	u32 total_mkeys;
> +	u32 available_mkeys;
>  	u32 limit;
>  	u32 pending;

Put all the renaming in another patch, maybe as the last patch in the
series and do everything. Much too hard to read when renaming is
muddled with logic changes

Jason
