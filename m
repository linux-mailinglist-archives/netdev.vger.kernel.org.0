Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B2E586C29
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 15:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiHANmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 09:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiHANl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 09:41:58 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B35395BB
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 06:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659361317; x=1690897317;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=30ja3NE7+yyeqBCW9uZIZ6ItTToD8RnA0eldDxVwsa8=;
  b=iNqOsHNOB85LwApfhb2AtK/9oRmJOk6Ku6OheerHE9TWT/ZLo+twP3Sa
   Ct7hFnunqahuOfW6rqHxt3PJNh+wEYUmO0j9C89e2pUxeMr1gQ3+fzIoc
   lh6AB/FwWT7sMZwTD1YrcHqJ1aCySbDuZCj1wL/VHO8YOfBxOfxnYYsrX
   rtguh1Sr3E9MzgjPYWz4k3Uuw4I/otBb30jaq/kC03kd7uYdVHj3nDzai
   f2qSNT5j+JxdFzu5CA3voISeoYFPw3ZRRFoRWN87rs6RIH2xmf78gnwC1
   0uet1ngyXPIbPf4nmVzfxQFwSxHG6MpUsvlxDkGLWwiJH7HM7B6xqBxbD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="269527292"
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="269527292"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 06:41:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="728442601"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 01 Aug 2022 06:41:56 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 06:41:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 06:41:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 1 Aug 2022 06:41:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LypjbU6NzM5CsnzeyN6fM/WqNf8BmRmAU2fXf5fzUB37B+4oLoju3KTXYBC61VcF1uL58yw7Roy3cS88FZpMKOZo9SSNlNcxwRAH3sd9lFBg6FBnCmiTRw7BMJkLbeIdW3mZP/ldQBKiczppdzDUcEL3WCu4RxBsoV8zrz8IB1ocGWrj6nxK7FLe4FsdXG36zkZrwZSxmn8EUXnNpvF7UYsUH2FdFUcrs2AHf2CyHaKW7pSNW6DaS+r0n3z+Dj8Z4tmjDYauT8iBLXR3alWc7+9WwywS2mTMLFvqvFcLb4YB7aR170Zsv7dLMXVUJt45qFpOjFbd/5JvTzjJ+zaR2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SN0oX0gbfO00C89ucw12eKjhs4ATxOhGcIg+84tmYQ=;
 b=CsspkLHgOUIVm2mrhAntih7FzbBYVwndf0ODP60fWlHGQB2udX+4wLADZnA51zsm/k4VRDkpkVtNZy0Rpw2X6J97QlMT1tJcfKXQIAN/PQ2Ojgk4QfR/UW3E+eNSPZzbJBlCpKGYroK1y2P4cgat4gIF8ZDlv3S8tslGZpHAsdM0JtK96bTcn4po/xjrFoEtYjraZll93bNZqjZThsd8NSfY4pbP6M5LZP+n92JfWq58f95MaPk6SVZDmWWDwspc/pKxqovkQEwFL7xbNwp8Cu7/zt35mFx9DU2dnPZJbsMwogT+E0qB4yGfFZKgkJsnUAwrtv4yUNhkZP6m5z4bAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MWHPR11MB1661.namprd11.prod.outlook.com (2603:10b6:301:b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.14; Mon, 1 Aug 2022 13:41:54 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9cba:7299:ab7d:b669%7]) with mapi id 15.20.5482.015; Mon, 1 Aug 2022
 13:41:54 +0000
Date:   Mon, 1 Aug 2022 15:41:41 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on
 striding RQ
Message-ID: <YufYFQ6JN91lQbso@boxer>
References: <20220729121356.3990867-1-maximmi@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220729121356.3990867-1-maximmi@nvidia.com>
X-ClientProxiedBy: FR3P281CA0099.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8515fa0-7873-4e49-7aef-08da73c39859
X-MS-TrafficTypeDiagnostic: MWHPR11MB1661:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nIE4EjlsaP2SJwnNh7gnSjhhkrGDD/sT+VVYwiK6bV8vanqAvIKDQ5dYtusT6EZ0m1NN5/CtFNhfYArlGC5xUFHxiWkL6AdtcQXVR0SumrNFEmt33nFdCaY0M0JAPzta6MWxwQkYEbNsdt44/+ti071tPNeLEW67uCoXpK1oE3oGqEfY1exmWEYWDvJBKlcyCf6sY+YGpYoidNaTMaoUdmO7yvNFkyEjJOxqGiZAhARyRlnU2l3UWsMiUYzuaqlBwFaJCo3nTiaIY6WB4gKN+X05PDSW08QzqSrkxTY9zIPzRFR5RHoS0yQzX8z4EdAEYCuzS3IYhr1v2B0Ri2cXefOupQMLaTn4yVKYpwvDBcLoL1xZ8RVa1oCgLV39GOrQvHAtGUd3wX9EIRkfQEbDERz2EF2zJ0hVSgT85MbtORTC/LAgAXfmE6QnhcM5xFqXRsAewQ/y/JNSCUqubZQK8tnWazf1TfM4Tu2IFNTfUJBqyi82ldQcGasaJbAUIhq5dXpQ5dmrCMUROkkqmYz9tV0Z8D1qNRxJHp5j2QfXwon66sOTK0uiGLR3WyD1NCqqCHc+jgC/gSMl6+WgApn5nEJg0YZMMk6tLs0uOKxbqXXl55h9SV7mQ6aIzpX5EV+m5Uy2Vbu5fl/shSCM27WM/98lDgFyGut/wrXj8JoQe3US0D1quRJk/mIJRmY2i9/Ydly7j4TfwIMSYmS5fKwt/LULACwrDIRpXbqxsCIz5Ww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(396003)(136003)(376002)(346002)(366004)(38100700002)(8676002)(4326008)(6486002)(478600001)(86362001)(6506007)(33716001)(2906002)(6666004)(41300700001)(54906003)(6916009)(5660300002)(82960400001)(7416002)(44832011)(9686003)(6512007)(26005)(8936002)(316002)(186003)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPUQxdF84LvmilvCAbpzH+VHK1cbTK1GMQrF9dY7Tvvm2d3e0y4G3GUm1wkO?=
 =?us-ascii?Q?Z5nyKYxOMV/APzSrIuEvV6xiPomk+ijVMi0zs/v+2mIGLp54uPGRxPYqvXuE?=
 =?us-ascii?Q?EQSj/XV3bMwKiWwt9EruUFfLmzQygCCFj3W0aFvuoJZ9IosNCmUP53CT8JCi?=
 =?us-ascii?Q?jKI0cudM3uD9759ir/XkXijwz4FSCb9GpLxs5Gshxs//JmE0n0kNk95m5eNM?=
 =?us-ascii?Q?iBBAlQdrIRTtOBJ2i7JysYmus0i6eEk2N1yy/cqrRQrNISzoLdSGA24tF+sc?=
 =?us-ascii?Q?+c0uDUO2ndZ3JJskigHkeG5lcehthBbdYE6/3L5z+g9IGqe+/3RiJYphmO8y?=
 =?us-ascii?Q?l3WTGjOq5Zrm6bzlajT9iuw8HXzMsidrlIV75B6YxbCq5sBMvdPUU1lIygXU?=
 =?us-ascii?Q?Z5Ucf7/UGtdmAhaliwIxjLg3oBVWmrKVbi/lItHsq9t5I7ayvDVP1INONu2T?=
 =?us-ascii?Q?AGvD9U9dBE9Xf28QQLB8Vj4fXk63ZoP0h9Kc3GCp+uSlgU0LWQMIZmSb2+Tv?=
 =?us-ascii?Q?GmRS0Xj4+hU4tVBX3a2apvb8mEThMt7MPO7VFccEfUAR24ZNGrvnoiw/y2Rq?=
 =?us-ascii?Q?Mn3bgFmhjZj6SyB4L9ou/s/GcioHgRsO4/MbJEK/oP8FmdfGPL22mMB3ee8n?=
 =?us-ascii?Q?uOFk44B6/WZ90bBmoimIjmW27DXbC4jYchnP3LgFgv5WTGol2eVRUtLmo3jm?=
 =?us-ascii?Q?xBBN//AdALHXViFO29HUNKHIuSBcZtssTbbDkLJiUU6QXRMhFhXaW7bPHuWp?=
 =?us-ascii?Q?RAUImrkj2KTMenLIeg/pkAQzK8jgOB4GQU7H/CEpUcefnVgbTlnyAZu2ccUQ?=
 =?us-ascii?Q?p5jzTICeACMtHU9aaBlx4VUJGXpKfb3R2JPo7A15NecBTnmGSVnHyUqoOyuT?=
 =?us-ascii?Q?NQgBfSghMfbjYcU+hKrfApJo5YZ/ORPeYYB5jt/2Vd7INGer0TltR6+v6u+B?=
 =?us-ascii?Q?tnBx3StqJKhDrzZimBT8YnkZcZp5YvQ58wRSCnpevr6f79/KHW19Rlbcl3Ze?=
 =?us-ascii?Q?3WkpDi/mr5ON/Vav5IxScb7TXJXR2XS/gw80t58S+Ls/0cPrZMZTtXa55kDW?=
 =?us-ascii?Q?6jvtvwXsre0O0oAi4dQc/H6gwW6Nnpo+mmCl4AGWLphImY1JrR/PFmBLQGVl?=
 =?us-ascii?Q?lgNO27o1QuXJb09FDJvMUN+EIncZx3c5bKd5QColPy/bNL4nSBSAb2x61ECB?=
 =?us-ascii?Q?vLbCpZU/e2pQhmsIHuFFhulHc5vt4bnOaaDG0OmnrPf+HQm/ZEEiwh4LqzMy?=
 =?us-ascii?Q?8tSMrrL9xY1WlAnV2PtvjERsN0vwFwPO72OUw4+RzRLXqXkimKXgEIZ9M9Xk?=
 =?us-ascii?Q?A2RCQx9Bb36ycQM71yp+lKO+DcaAm76YAWHrzcCFMN1WbQYbPcEYGEvndx4l?=
 =?us-ascii?Q?+NTfQItWf5hQbSOF/E1QxsbO/PjOeUUg3Ch9fnKDT6AFJwaZ5q48/aMgnU2P?=
 =?us-ascii?Q?YnPOuB9r8PJF+o8uw4i38O35CiK+2SJYB6G58VMtFz6lKe2xAPTtpZ+GlDpK?=
 =?us-ascii?Q?jLW79AT0oh2evy7C4EgU7Fq+U6MNlBrouQ9vjl8VqFBeYRLjGce+AkQB32sT?=
 =?us-ascii?Q?GBLzhN4yq34J8/qiCOJTR5jRSwal1r6r7YyQhV2sWhO/rNdzJigO27CIjbtX?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8515fa0-7873-4e49-7aef-08da73c39859
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 13:41:53.9414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOW2pvrrhRLaZZ8ovF/m3Qisxqr4iJ/GzJT5qr6CxoCqHITfyeu0Pdg/MsC9MijOMR/FK3aH3UdtRzmxIkRpsXSw3eQc9p1K+f+K1ziBaCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1661
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:13:56PM +0300, Maxim Mikityanskiy wrote:
> Striding RQ uses MTT page mapping, where each page corresponds to an XSK
> frame. MTT pages have alignment requirements, and XSK frames don't have
> any alignment guarantees in the unaligned mode. Frames with improper
> alignment must be discarded, otherwise the packet data will be written
> at a wrong address.

Hey Maxim,
can you explain what MTT stands for?

> 
> Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    | 14 ++++++++++++++
>  include/net/xdp_sock_drv.h                         | 11 +++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> index a8cfab4a393c..cc18d97d8ee0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> @@ -7,6 +7,8 @@
>  #include "en.h"
>  #include <net/xdp_sock_drv.h>
>  
> +#define MLX5E_MTT_PTAG_MASK 0xfffffffffffffff8ULL

What if PAGE_SIZE != 4096 ? Is aligned mode with 2k frame fine for MTT
case?

> +
>  /* RX data path */
>  
>  struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
> @@ -21,6 +23,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
>  static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
>  					    struct mlx5e_dma_info *dma_info)
>  {
> +retry:
>  	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool);
>  	if (!dma_info->xsk)
>  		return -ENOMEM;
> @@ -32,6 +35,17 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
>  	 */
>  	dma_info->addr = xsk_buff_xdp_get_frame_dma(dma_info->xsk);
>  
> +	/* MTT page mapping has alignment requirements. If they are not
> +	 * satisfied, leak the descriptor so that it won't come again, and try
> +	 * to allocate a new one.
> +	 */
> +	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
> +		if (unlikely(dma_info->addr & ~MLX5E_MTT_PTAG_MASK)) {
> +			xsk_buff_discard(dma_info->xsk);
> +			goto retry;
> +		}
> +	}

I don't know your hardware much, but how would this work out performance
wise? Are there any config combos (page size vs chunk size in unaligned
mode) that you would forbid during pool attach to queue or would you
better allow anything?

Also would be helpful if you would describe the use case you're fixing.

Thanks!

> +
>  	return 0;
>  }
>  
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 4aa031849668..0774ce97c2f1 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -95,6 +95,13 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
>  	xp_free(xskb);
>  }
>  
> +static inline void xsk_buff_discard(struct xdp_buff *xdp)
> +{
> +	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
> +
> +	xp_release(xskb);
> +}
> +
>  static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
>  {
>  	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> @@ -238,6 +245,10 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
>  {
>  }
>  
> +static inline void xsk_buff_discard(struct xdp_buff *xdp)
> +{
> +}
> +
>  static inline void xsk_buff_set_size(struct xdp_buff *xdp, u32 size)
>  {
>  }
> -- 
> 2.25.1
> 
