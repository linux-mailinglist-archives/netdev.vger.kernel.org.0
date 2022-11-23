Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871C7636C9F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiKWVzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiKWVzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:55:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B8E5E9F6;
        Wed, 23 Nov 2022 13:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669240501; x=1700776501;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yDCNZlSOrMUn0wdw1Xr23OGo0jtsEcUyQncI86N0RCU=;
  b=GipqIS9eBblwJ3123LT9UOmcIKx5/nWddaUyMC7x3h0N0U5H72lFAhWU
   3mOHiVhQIbtUBgAe7oE2IYlpLT9RbE44SpEJ3+0lqcNuzKgfQhtt1RDq0
   M6ZIbGR5fh3Yafc2PXMT6aSzzLqNs7xryucspStADG4wLLY5kn2jojZ3K
   g8oUUdKwFC76Sh/qMPEDhxgbH697oImn+sevf3RdqEGevR1z8e5Cz+hiF
   L9sWw9ekJViN9KYic9pILPF/vq4u27qyMuXwaHICADKJEsIGf6QZkzl7n
   WTmydCBfD1UkvRPRgMJvYANYIwkzbfboiR92PxjkNQjI8xEqwjHjV4RXz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301727892"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301727892"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 13:55:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="644257931"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="644257931"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2022 13:55:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 13:54:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 13:54:59 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 13:54:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQeCUaxb5AIscphCS4Y4BGT3GbwGYfbk6e+zJdK5IFWDhKLfYseoXSCg5AQV8bwAU1CknzDp4ieUEXJErkHaphVXpFhStCehJ3zXTR0SzHUy54yKeptoiGqQyodBiW65MJzyxPfRwtjzwXRrfWN/akiN8estn3xe7Obqy7fGTaUXr4nxE1OsCgNPCGsjq1mvWGeZ7Bt7sfe7PGCoZYMHorays2wUEsFckT0LbR+GYxXc1tPFKzlv1TwT3/6tM1Mj+vZqaGnAtYTxsHT7Hmg3uQdHuG9fxSI+k4RfhpMLUmvzB8W4FdpWoXIeNlyztB9teehkcXSjIM5TXVgwpAxo9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I26D8MYSTC6kfetoUS/vUHoApbisgoVW2ipG+WcQZJo=;
 b=J0me2GW1pYr0ODaYG5ZslRvj5/zTVVGwuaOA2YPBYUt4nQ7NCBdtJCDvOUXEpRAWrPuJGZ3AaRQM4Fe5Cc+Tfe3Aq7NKaXQtuHnni5CBBeAdXlwz9xoPlRqFqAun51GwMRnCiMKP/e22YHtmhGi6V8DviJQTkxo2pSLoAt/iEXDARfaQw6eqj5/sPQta4BYWDya2+2WE2cf87yar6IKRD871ZJKAfsnheig4WNbzCiQDajiqNP8W9wP5PLb4ApSdlEz2I947uVWHlKMzO9JruAJg4wPNczoLjsfA9z33XrrbPFPEjCBOFLoor0Ug02qi5MmDO6HOU9fQFbaq97kQxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Wed, 23 Nov
 2022 21:54:55 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Wed, 23 Nov 2022
 21:54:54 +0000
Date:   Wed, 23 Nov 2022 22:54:18 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     <sdf@google.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>
Subject: Re: [xdp-hints] [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
Message-ID: <Y36WiiijyDqNioIn@boxer>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-7-sdf@google.com>
 <874jupviyc.fsf@toke.dk>
 <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
 <20221123111431.7b54668e@kernel.org>
 <Y3557Ecr80Y9ZD2z@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3557Ecr80Y9ZD2z@google.com>
X-ClientProxiedBy: FR3P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SN7PR11MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: f360e94d-b541-48e6-b7e7-08dacd9d5ad7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zl6uoXyPiTmiTCYsUilWDt2xkWDc5mwFXWUhHfKqlYyEjez99RHbD3ZIATM7PaJUdQXxyf5b7scrYsS0mujO+CAVerorEJBVs2j8QEfqucHq25CvMs5uTJcYgrb2D+QpH3ZfcXJS42YlO3uT6kgfB+xGAEZXas8Thd1lr5OUWhvqdyQrmJ3A4h869c4HGJCfX+pfa6Fi+A71iBSFFO5S40FQGVCcN/Nt8qaBb3VwolKmtNk3hBYudbGrkrCMKFxfXrEJa2mVmtbFtO5RfbNEtAIZeybHhelupGhJVfMxFiouohoRtDfbdl2EifK+OvjdIKtr+qUS7Fd+j5gh5Q7GHAB/hltqK3sUCBS4ftYzCOAbm95OTojrVYvHO4AX0MiVzCNOJXBPjwO07soG1UpriJ5DpZLSypNMvRtNNUB4/t5l6ekxEjhxmIzdyGZULYd9Lq4PZNT45kLm3ATffDS1WgCl8BBrCaPElHR89wuWvrtqajjZp+o0jk63IuGvhqbm8253EckzmM4eil+Gwo74RGZNaJ6g5W27LCZJlL28qERkL1tn4tVo9zYae8Lphxf9kkN/MyMfg59cXIlz5TlbC0yGUhRYjXfjtE0ErSz8reFEJW/dfHEHUJEOZ1pYQKym/H/hpZTW54YXqjM+MfwiaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199015)(7416002)(5660300002)(33716001)(8936002)(186003)(26005)(6916009)(4326008)(8676002)(316002)(6512007)(9686003)(66476007)(66946007)(66556008)(41300700001)(82960400001)(86362001)(38100700002)(2906002)(54906003)(44832011)(6506007)(478600001)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D4jAUV/jYA4O/7/RFDjmbQM2KEK/QF6wd69O7VCUn4vWtv9wsho8V79QLQe6?=
 =?us-ascii?Q?LzwPVVmzyGhTuEsw2Mxj71xntUvGHqCREq+fx+EF2ED/8RSHsT//0yEjHhBk?=
 =?us-ascii?Q?RdpNw6XkTS1iceo8p+Tzqth6EdOI4knGxpdhFkCr3GPXb7UhrLtF40tWP7Rj?=
 =?us-ascii?Q?jFYvAsKyA1n5BZUgv7oZiZUFKe8gg/LlDggslpD8juk1q7YTKRaZFcOJ1dJD?=
 =?us-ascii?Q?C2n/fAHRE/EzvwJJ1nQHJnWtrinKfDAkjKd+W4nHPmNWTWKj3mWS9MK2JYzu?=
 =?us-ascii?Q?IF0uuuAJ0XGOFtqzKB50K1A8MwYLqlySfWZ9mRajDqTU6acGDGyKMpUV+Pw1?=
 =?us-ascii?Q?UcULvPDLs7sFirk0hyR86q0lIRz5S0f7Q9Tbb0DRSEFArr1erq8hl67+AwQM?=
 =?us-ascii?Q?W5oGkZCT5ypsepLFT2ecleeck+zJol2oU/C181wneACjMoH8G83Xw4jaBve7?=
 =?us-ascii?Q?hz+H4EANu9OAfh5wcyPgNOlYrHCbz1CfIaFDJBYApqrkiI4hUsJUjOH+/vcZ?=
 =?us-ascii?Q?i35/njbOlyQS3FPZ1beqZ4+c2vqCWhzf3GR2FCaro/Vq6g7rjpMCa6D/uU5i?=
 =?us-ascii?Q?uqSv+AeThX6QhiljhlpU0HF6KtxBGhP++hfaA98Slgm9R5Zt4peqV3mZonrp?=
 =?us-ascii?Q?KZG2PHbHveRiO0l9dyRwXG9yzzby6HVlOToaY9Jswlb06P/owMvj+83PBBm1?=
 =?us-ascii?Q?bV1ayewPZnPjHrrvu/qIsROKKJRInybwawTJbXTAIAYNv0covUeGnO/tyqB7?=
 =?us-ascii?Q?HLUY2Cw7l/2zCZy7Z6ZlW9jcvL6jq9lnndcaaqJI3mahngvGpQtpLnI8AVQE?=
 =?us-ascii?Q?9A76oK5ryGpTcY5qDUZW7zTH4JlDVk+NGpLHb8jfP9Jk+Zz4yEOH0xW6SsR+?=
 =?us-ascii?Q?oEeMSi0ZpV21GlWTnpP5cm+lhmlm9QfqYHKCkAxghbArMY+MZmXHdLNU9Okq?=
 =?us-ascii?Q?taLrvLmw4O920491UXSb6RXUh7yj3rSbI0IqeeprNfhMK/5DFjJop0dE2kD/?=
 =?us-ascii?Q?5cgpDLlqWnIXwfOC3EtG8CdkOTky1UDOs2NRvQNf9nbvRBi1VhTX4xCx9wrn?=
 =?us-ascii?Q?+Tl6NwdHdsi2zIxbDwcxy4pmc+FXKwiHD7i8tMCRUpN8Fcfsd5U8PtfwhxfQ?=
 =?us-ascii?Q?BmteaGciS/eNCrVJ6VWK4yp5MZBbICgncqkr3Qxok5SUueVBZcS6AXidhX5B?=
 =?us-ascii?Q?/9zdMy8+99pVcmbDC3ZYspoOUnKGgqeaXxywKBNr315SfjY3ltE59aPDwhCa?=
 =?us-ascii?Q?5gN6LEbWBDt7/y+ONA0SGRG1DTst/Gkz1Y92Mh0RigfeCZG/Qlo7gsewQ0QX?=
 =?us-ascii?Q?GwIxKDS6c6/R8d1dGIBZ9j+gXc9VW+PGh0i1eTTtyKyN6OGJaQOpx8rcesvR?=
 =?us-ascii?Q?EGBaS+RI2JF4jhMXLGjIMMFETPwyfwbx61u+kSIUnkL4xPNTosKBzZiTQVCL?=
 =?us-ascii?Q?pmWpkFcweFrbrEQWjOmv8tfYCRoD4NA/XKS12dZv4bwHdOAH4e1f8X8iFr4s?=
 =?us-ascii?Q?yu7kqg/bWaPuKmhbCzN2qU4bpEAI2C3dDGZFwZ6wSiYPsSZUxws3vDsNd8rt?=
 =?us-ascii?Q?b6Tb2AZY59AFhaoexf3dDY4OiI5D5EqG6tVjPBIKlyW3yDtYpiZIwlPIez/x?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f360e94d-b541-48e6-b7e7-08dacd9d5ad7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 21:54:54.7117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8KJ+z9u8Da6l9wi9drdxW3bY8FtaGbUDZSJ5XsjnYVBPaRsyFWiqYO7imfeSp1OPiESWcyxZM8D6Cq2KGarMVAZ5QV0L54N6Fht/CSot3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 11:52:12AM -0800, sdf@google.com wrote:
> On 11/23, Jakub Kicinski wrote:
> > On Wed, 23 Nov 2022 10:26:41 -0800 Stanislav Fomichev wrote:
> > > > This embedding trick works for drivers that put xdp_buff on the stack,
> > > > but mlx5 supports XSK zerocopy, which uses the xsk_buff_pool for
> > > > allocating them. This makes it a bit awkward to do the same thing
> > there;
> > > > and since it's probably going to be fairly common to do something like
> > > > this, how about we just add a 'void *drv_priv' pointer to struct
> > > > xdp_buff that the drivers can use? The xdp_buff already takes up a
> > full
> > > > cache line anyway, so any data stuffed after it will spill over to a
> > new
> > > > one; so I don't think there's much difference performance-wise.
> > >
> > > I guess the alternative is to extend xsk_buff_pool with some new
> > > argument for xdp_buff tailroom? (so it can kmalloc(sizeof(xdp_buff) +
> > > xdp_buff_tailroom))
> > > But it seems messy because there is no way of knowing what the target
> > > device's tailroom is, so it has to be a user setting :-/
> > > I've started with a priv pointer in xdp_buff initially, it seems fine
> > > to go back. I'll probably convert veth/mlx4 to the same mode as well
> > > to avoid having different approaches in different places..
> 
> > Can we not do this please? Add 16B of "private driver space" after
> > the xdp_buff in xdp_buff_xsk (we have 16B to full cacheline), the

It is time to jump the hints train I guess:D

We have 8 bytes left in the cacheline that xdp_buff occupies - pahole
output below shows that cb spans through two cachelines. Did you mean
something else though?

> > drivers decide how they use it. Drivers can do BUILD_BUG_ON() for their
> > expected size and cast that to whatever struct they want. This is how
> > various offloads work, the variable size tailroom would be an over
> > design IMO.
> 
> > And this way non XSK paths can keep its normal typing.
> 
> Good idea, prototyped below, lmk if it that's not what you had in mind.
> 
> struct xdp_buff_xsk {
> 	struct xdp_buff            xdp;                  /*     0    56 */
> 	u8                         cb[16];               /*    56    16 */
> 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
> 	dma_addr_t                 dma;                  /*    72     8 */
> 	dma_addr_t                 frame_dma;            /*    80     8 */
> 	struct xsk_buff_pool *     pool;                 /*    88     8 */
> 	u64                        orig_addr;            /*    96     8 */
> 	struct list_head           free_list_node;       /*   104    16 */
> 
> 	/* size: 120, cachelines: 2, members: 7 */
> 	/* last cacheline: 56 bytes */
> };
> 
> Toke, I can try to merge this into your patch + keep your SoB (or feel free
> to try this and retest yourself, whatever works).
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> index bc2d9034af5b..837bf103b871 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -44,6 +44,11 @@
>  	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
>  	 sizeof(struct mlx5_wqe_inline_seg))
> 
> +struct mlx5_xdp_cb {
> +	struct mlx5_cqe64 *cqe;
> +	struct mlx5e_rq *rq;
> +};
> +
>  struct mlx5e_xsk_param;
>  int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param
> *xsk);
>  bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index c91b54d9ff27..84d23b2da7ce 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -5,6 +5,7 @@
>  #include "en/xdp.h"
>  #include <net/xdp_sock_drv.h>
>  #include <linux/filter.h>
> +#include <linux/build_bug.h>
> 
>  /* RX data path */
> 
> @@ -286,8 +287,14 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct
> mlx5e_rq *rq,
>  					      u32 cqe_bcnt)
>  {
>  	struct xdp_buff *xdp = wi->au->xsk;
> +	struct mlx5_xdp_cb *cb;
>  	struct bpf_prog *prog;
> 
> +	BUILD_BUG_ON(sizeof(struct mlx5_xdp_cb) > XSKB_CB_SIZE);
> +	cb = xp_get_cb(xdp);
> +	cb->cqe = NULL /*cqe*/;
> +	cb->rq = rq;

I believe that these could be set once at a setup time within a pool -
take a look at xsk_pool_set_rxq_info(). This will save us cycles so that
we will skip assignments per each processed xdp_buff.

AF_XDP ZC performance comes in a major part from the fact that thanks to
xsk_buff_pool we have less work to do per each processed buffer.

> +
>  	/* wi->offset is not used in this function, because xdp->data and the
>  	 * DMA address point directly to the necessary place. Furthermore, the
>  	 * XSK allocator allocates frames per packet, instead of pages, so
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index f787c3f524b0..b298590429e7 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -19,8 +19,11 @@ struct xdp_sock;
>  struct device;
>  struct page;
> 
> +#define XSKB_CB_SIZE 16
> +
>  struct xdp_buff_xsk {
>  	struct xdp_buff xdp;
> +	u8 cb[XSKB_CB_SIZE]; /* Private area for the drivers to use. */
>  	dma_addr_t dma;
>  	dma_addr_t frame_dma;
>  	struct xsk_buff_pool *pool;
> @@ -143,6 +146,11 @@ static inline dma_addr_t xp_get_frame_dma(struct
> xdp_buff_xsk *xskb)
>  	return xskb->frame_dma;
>  }
> 
> +static inline void *xp_get_cb(struct xdp_buff *xdp)
> +{
> +	return (void *)xdp + offsetof(struct xdp_buff_xsk, cb);
> +}

This should have a wrapper in include/net/xdp_sock_drv.h that drivers will
call.

Generally I think this should fly but I'm not sure about cb being 16
bytes.

> +
>  void xp_dma_sync_for_cpu_slow(struct xdp_buff_xsk *xskb);
>  static inline void xp_dma_sync_for_cpu(struct xdp_buff_xsk *xskb)
>  {
> 
> > > > I'll send my patch to add support to mlx5 (using the drv_priv pointer
> > > > approach) separately.
> > >
> > > Saw them, thanks! Will include them in v3+.
