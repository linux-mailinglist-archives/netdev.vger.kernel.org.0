Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568DD5BFD98
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiIUMQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIUMQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:16:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB18F46;
        Wed, 21 Sep 2022 05:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663762610; x=1695298610;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=omzs0I/n2qRCyyjS414rnpKIf7/VXLZ93F6/HwMNDv4=;
  b=bIH0CSuPM9MxhaqlFZlzf0rPXP7yuyEvMXFS2gRUG8HurMx3n49GUSYl
   gGuwMHEDaA39JwB/wb2SYO9JLdxkGS9kH6kjam1ztTed/DhKtG7eZ+rLK
   2SIHERBu1/YNOnbMX7f6wvYPZ8Zm4LcgiCRGhdLF7zEXnyaRSP1/5UWlF
   oqvObiL4NpqrXCW0GwM8NvLqIc+S2M/97fZ2I6bAoKx37WgJszgpAq05+
   +RNqMXpGBv41vj6TBZD+ndqx9vDcoTnzFIA1rkXum+q94W8w+EV9dVzWp
   e55wwZpyr+DM1QOAJqPDIBPLaKP/K1tmWCrlLoS2kLNphp9/SSIaLSRyB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="280358075"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="280358075"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 05:16:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="596959022"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 21 Sep 2022 05:16:49 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 05:16:49 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 05:16:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 05:16:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 05:16:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lF/UN07xjM46sIeuOKG9Buhrcg7JgWiG6IwZnlF2Q+Xl0IUEggOBDHlBE/6dr7H9l4julknwHmeONE2Ivf3SVnVk8ZnBdqvUY/dOy9RDxuoXhS6scrGiieDy7RKvwov1KFQPwokSnU0vpSoDs1vfeU1pMXeffgnHHz1eY57o2VOfF+Y6/I1dAwgrcwzXikb5g3Z/El2p80aIjYEmOwFLEQ6SMt+G6vNiu0jaGcMCHt2ErSTaTrpEazYyL4H+0JF1hSxslIVHGKg1mZhlFXeKKjlrYFDIiQGJst90KZ5ktFn0zUzryWM38xNLAOueOoAo2rniGv1HdSGIe6ti266Thw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyw8VfBgDeUDqM2zvU9ztxXQWr34eSo8E+LcI8FQ7Zo=;
 b=YgigL0tWNBsy6nR558FXDvBMTNx04Ka7yWe7A9T5Y9Pl5d+scRRJnWcTgHBOJes6QP5dVV5M8xxoOHVucsnfUj37xAxGSoPZNf230Z253MR5bx/bjicnFQ6RqkqPFi/V/FGwkd5jVzrAsJxVFnoeMmaHE9XBh56oKHY8t9Gtp+InzQRouSjfvwnfaTEwTHRLI25EGJclXgQC+4vRyhNlhyuqa5kaNd1eGqUccRKQ30zmRhzslzXwzKXCo6Lb8F3eVjn6hs5CQrMKJKi2HexKvIuSMLRI0S+C4hYgA/yuDVl1ZYXSPUR44VDT/kE2NYHQk/lVuinrHREgIGr22xeW0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH7PR11MB6029.namprd11.prod.outlook.com (2603:10b6:510:1d0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.19; Wed, 21 Sep 2022 12:16:46 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::cd55:6bab:8dac:9a80]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::cd55:6bab:8dac:9a80%6]) with mapi id 15.20.5654.015; Wed, 21 Sep 2022
 12:16:46 +0000
Date:   Wed, 21 Sep 2022 14:16:39 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     Jalal Mostafa <jalal.a.mostapha@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <bjorn@kernel.org>, <magnus.karlsson@intel.com>,
        <jonathan.lemon@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <daniel@iogearbox.net>, <linux-kernel@vger.kernel.org>,
        <jalal.mostafa@kit.edu>
Subject: Re: [PATCH bpf v2] xsk: inherit need_wakeup flag for shared sockets
Message-ID: <YysApyiP4S3xdT8H@boxer>
References: <Yymq2WLA6q6TxnNq@ipe420-102>
 <CAJ8uoz2D9mGjZzo6SmAWtgbb0A3AB_Nk4eYXajenv3VDBA11=A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJ8uoz2D9mGjZzo6SmAWtgbb0A3AB_Nk4eYXajenv3VDBA11=A@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0101.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH7PR11MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: 01ba1279-5372-4b88-b0d3-08da9bcb2707
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: THl3XYtUXAihpVG9o9GuiUIVmQu2AW7rYPstFW78LMyHRfXXOSk6/53QWZjVcR7IyOYac21n+pp55xYojO3VBUtxukZE//e6fpKEsS8ihuJe4sSp6lEZDuwpIqhitnhMX4kli7zTPBqdpKl+AiHt/JByjfF3czjUjj3H+SI60giEfJnWIA1dZKU7+h2ixzE+Eqplpg3PVm7cHtpJde/79104hVKIhb+gbN02nj9vvKoeWi9GurxsLuVwvFZE7No0bzovJW4bZckTn79NNkI4XFzgYEwZEwT7t/5NWnCgXojxlF/j+Ewn+yK+hrS7PZFhCu7uYibycFnFwcjhQm4m256waf7UsQpgUPjK3srE/ftks1Wv1nlHDpVi20QBoy6kvTzPXXnHX9vpabGDHUXYeJIK9e0BMV+WDdPWh+PCgoPds5GXw+91spYKrBLYlrsS32QfS3cxR9J+wKCSHBxcuoee6vKzAxEW95eEVKP3x0bm1pbnS15eqTUJvaAgJh43KUxGNSf94odBQ5WilL8sfoTEhphJKbDenSMHe0+QQ+Smq/QSQEev+C3xCjWQAmi2s+eTHyHOYxTWIZNyrn3m2Wlfz5amrtMfSCYWVYcKN+jSKUuSZ/oMTSv+4+B/qUrufEDzLsslXUHaPIQrSQEje1vG0syJRJX9S4REGxaCJCTbf6Sr0xsJ+SuLaSyzTbw6teMft3JEjjjfTgGJmd54GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199015)(66476007)(6506007)(86362001)(38100700002)(82960400001)(478600001)(5660300002)(7416002)(44832011)(6486002)(2906002)(66556008)(186003)(4326008)(8676002)(6916009)(8936002)(316002)(83380400001)(66946007)(33716001)(41300700001)(6666004)(9686003)(26005)(6512007)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qUZlIHciofcd4CWGfc8fgBszBYBaDlmSbOW4dD1qMUXNikPiXQtNW8hdhOO/?=
 =?us-ascii?Q?NeyU7yyGvudHRxbKMTpag3u8MhXM81P3jpV7f9zM1oMDMQiop7N09bc2nJUL?=
 =?us-ascii?Q?Yg0T4NPBb0krFcwV7HV+WTfuYNnpJWjXIYTUe/bNbeQECBmHQkV1cJml+gME?=
 =?us-ascii?Q?Aill/3vD5kZc04VvgdFKOwE0TFAXnoQh8ky2Rmjnx3e6l5RMgro0xiPqqWrV?=
 =?us-ascii?Q?0EFX83FSjqooUDOQxYkkcIDPwmmzdX7NxhrIqKcHwV2S+e/lSQovJeZwZTfD?=
 =?us-ascii?Q?e6SnJiik/yOWuE6k4pwzMgfMpzL/mVfJdozRczTxoKWgYiKbGjJkx/LRljsp?=
 =?us-ascii?Q?YKqKIfSxbYxNd9SoBaF9L4eO/Uh57WWYx0qsaPhOazHBkkBqIvbdS5a8RZdX?=
 =?us-ascii?Q?MJvH2zT8/0kietRrxtj39VW1yT8YG7Ln7Sn9s/3HdFq8r3XVKmmtvOx19me4?=
 =?us-ascii?Q?FTBF2ABOMXPvgDIk/R4rh5JAe/Dqsbmx+blKB5+QtIzQPb1COZLsT3unOKB6?=
 =?us-ascii?Q?8C9xXz0pB0Iz4FC2BujokyZlWm0azI4BatxO/+m8WDIXYe+N5YWhYxhz1c51?=
 =?us-ascii?Q?1Df+T1tp/cIFFc3KCKsFPRLVFir0ejJvW0RrfY8IudIIblLVZwQra1Bx4srE?=
 =?us-ascii?Q?oOzyIejSRKUBH6qsJpeSxaKdTFV4i4Ts29zxVFSRA+l4qWLsBpCoJM+nJU6c?=
 =?us-ascii?Q?xD7rq5pMfifhgvTvrmbR4pnXiecimAszzG+UGgJgJo1qbcZreK7NHtXSewXs?=
 =?us-ascii?Q?BFZF5ccbYon6Ak1R1Dx5kM4Bq6GGLeASB/Rb+4Q9xjhRjVIOKUrjO4utNPSV?=
 =?us-ascii?Q?NLCiuCp5XibrNeMqyqeYT8wlspROQw6yGtVuCJF1WGn2gNGw+OImGsXykhPt?=
 =?us-ascii?Q?PgaCdkQyS2Y+WQ9GlC8lQon5TKLR8aBCGSWq6aVCk6Dt87WQY6DyXQUjaH2e?=
 =?us-ascii?Q?1UYCiYYEOVnlC4Alme/fTpxu92obfr+PaT+NLEMAydDJJgsHEqq1fUVZAZCj?=
 =?us-ascii?Q?ho3hprQQG2DGGUrSt3Op5DwLOWuq1DK7fLuztdKAuRnkI5OQ6gkxwTVsTcJF?=
 =?us-ascii?Q?Ohox8LbQIbcYOtp+LeXxNlHjBJgOboRdDKkXpJ7lDKHHP2n0V+Dy2HfEnvr5?=
 =?us-ascii?Q?Z6fSt2Q0tdobhPKU1xretZvqR+ExAYljGa6PSVE6J19Q6v52WlA8EHLzuU6C?=
 =?us-ascii?Q?cifWFM/1rA/8vs8tZYiJKl05GXcGFmv4Bs0tV/GBSReZXIMLSpYDEMeYQQSN?=
 =?us-ascii?Q?w7ypkc5GQGzBT0pSpFdJs9PM75MGDT+u+7AnysNF5sEF3ass//Txre/EHY/+?=
 =?us-ascii?Q?j7J8JC6TwITNueLp3ohfH5+0+V1JZuLTtw5ertlTQbHPI4uBaUMb4Hl29MRJ?=
 =?us-ascii?Q?JYZmXHSlABAEWbww/cSK3d10A04hhmwqsGR/5OhufTknV2JVWSLl6Gn8wMF3?=
 =?us-ascii?Q?3hqPZcry208k7+MgJFSFMbJhEpPafA5EjjFrs2/Ahwk0MFNC3sciCPKGF6kT?=
 =?us-ascii?Q?yNTo5PAxlI+UZV8My92O1QS+sr5HtqG+rlc+OwzV6nsf2gS8m1Ns5N5vYLPb?=
 =?us-ascii?Q?vsGeKoWPGBN1GrTfU6uLqAVnS32m8uZxCXDyXAExQ278Ao+lgG3/NTQVOuel?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 01ba1279-5372-4b88-b0d3-08da9bcb2707
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 12:16:46.3078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DGbXU/w17GVl0k0iOsrZQYsrfb1DG/rOl5v/ZdcEQKsdIDcFK5/XzUuA+xOzVqQNYQBawYV3ep+41Gg+8JYLi8bqMgZf/XrnKTpaH37GKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6029
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 03:34:19PM +0200, Magnus Karlsson wrote:
> On Tue, Sep 20, 2022 at 1:58 PM Jalal Mostafa
> <jalal.a.mostapha@gmail.com> wrote:
> >
> > The flag for need_wakeup is not set for xsks with `XDP_SHARED_UMEM`
> > flag and of different queue ids and/or devices. They should inherit
> > the flag from the first socket buffer pool since no flags can be
> > specified once `XDP_SHARED_UMEM` is specified. The issue is fixed
> > by creating a new function `xp_create_and_assign_umem_shared` to
> > create xsk_buff_pool for xsks with the shared umem flag set.

Hi Jalal,

Please update commit msg and remove reference to the new function that you
were creating on v1.

> 
> Thanks!
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> > Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")
> > Signed-off-by: Jalal Mostafa <jalal.a.mostapha@gmail.com>
> > ---
> >  include/net/xsk_buff_pool.h | 2 +-
> >  net/xdp/xsk.c               | 4 ++--
> >  net/xdp/xsk_buff_pool.c     | 5 +++--
> >  3 files changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> > index 647722e847b4..f787c3f524b0 100644
> > --- a/include/net/xsk_buff_pool.h
> > +++ b/include/net/xsk_buff_pool.h
> > @@ -95,7 +95,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
> >                                                 struct xdp_umem *umem);
> >  int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
> >                   u16 queue_id, u16 flags);
> > -int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
> > +int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
> >                          struct net_device *dev, u16 queue_id);
> >  int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs);
> >  void xp_destroy(struct xsk_buff_pool *pool);
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 5b4ce6ba1bc7..7bada4e8460b 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -954,8 +954,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >                                 goto out_unlock;
> >                         }
> >
> > -                       err = xp_assign_dev_shared(xs->pool, umem_xs->umem,
> > -                                                  dev, qid);
> > +                       err = xp_assign_dev_shared(xs->pool, umem_xs, dev,
> > +                                                  qid);
> >                         if (err) {
> >                                 xp_destroy(xs->pool);
> >                                 xs->pool = NULL;
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index a71a8c6edf55..ed6c71826d31 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -212,17 +212,18 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
> >         return err;
> >  }
> >
> > -int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
> > +int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
> >                          struct net_device *dev, u16 queue_id)
> >  {
> >         u16 flags;
> > +       struct xdp_umem *umem = umem_xs->umem;
> >
> >         /* One fill and completion ring required for each queue id. */
> >         if (!pool->fq || !pool->cq)
> >                 return -EINVAL;
> >
> >         flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
> > -       if (pool->uses_need_wakeup)
> > +       if (umem_xs->pool->uses_need_wakeup)
> >                 flags |= XDP_USE_NEED_WAKEUP;
> >
> >         return xp_assign_dev(pool, dev, queue_id, flags);
> > --
> > 2.34.1
> >
