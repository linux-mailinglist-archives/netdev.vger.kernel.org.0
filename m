Return-Path: <netdev+bounces-6798-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CEBC718147
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC0082814C3
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC20614A85;
	Wed, 31 May 2023 13:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8B612B8C;
	Wed, 31 May 2023 13:20:22 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECFB98;
	Wed, 31 May 2023 06:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685539220; x=1717075220;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=66lkD6M4iWaaTy8nTphoZP8Un/mePP/5eW6PvgdmBhQ=;
  b=m3fFAhASHI/ostOyyXA/z8NA8HTPuhLiFiavfUS96wEOdFPm9sXhvMsz
   /A5lC+4Y5PmdCqwFGuYHfjZtuCjP788xeHb1FPuN5083FbZDSs/8M3QTU
   tlg1mw9OEOROUZSAkdEr2nxuuBrEf4Y3izAksgL60XUPa2TdQl0T3qpoM
   zehZlNidHZ+bZBWd1BQl6laT9p5f7wyLkHWTj5Ku+71VE6+VGGDpFaVCM
   K+rMj3CTkAoWxvxg1gu78eBuAL9bHtdOip/8RbtbzDbVbVFq6QE7P+g5c
   /HzXvPFaZcjV3F9q7s5KGwy252iYO0t//z8/h3GtoSoBy26TFhQD8tdnP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="421000425"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="421000425"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 06:20:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="953635601"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="953635601"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2023 06:20:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 06:20:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 06:20:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 06:20:18 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 06:20:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgJDcAkzK8lBAULsQbDeCVHx4WBZFsF3P9i/Dl4uB286PWQNxYkaO3s2Uusqz7GA28jUEnehW9zlD7wDF/Ltoxrq1g1sdYXcAjMeN5fw4FYtDDA3Kmnig+W1FJNzG97GNDyX+sxMNq5n7Hp1v6Y9NRhB7PkcnpvAK3tpM1Cq1GkzXJ+zLP+sY+slb59BSoQNXyZTomaW1W0dWdAR+zwWwK1EiyhNqepz+ZlrP5sN/msonqekXRvycaHjdehOEvgO2xjg0es1JkQh7a40Taengacxny1/OZ35MXP0xCqIZuRcqQWS8GWoK/61ULEBbButfsr2Appkzth9/n+Xok79LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HKhBleVxQnCpKpKmXuWM5XimVfoAylJgtMdhm/J7fb8=;
 b=I5h0MQFfhRkZjdq8YD6Rv+8/aLJdbVynnTl6KndAU3PS7yBDHDOQ5/OH7a8IE25BhrrisKU4mhNa4TN1WSWdWYOq/3LNWx0PciQ410SIEc/b6WIfnikOYiFvuSYFTkAf7XwfxuVlzslZdf0jhAJeyLoDCduj66FE9f8RGXBBh5S643HGLVYbUSmltaAC9VQKXFS0pn6XPTYYhKn6YLApnF8cmEeU9BYsggrnhREn4NkjsezTXoW+n/u/KrNq9fb7UPqCw0ZBvkSRUSiMoAgwEmrBHrKujjQiH7P5FFozmWV1rx2YNf/iUTp/3GpvQcbeqZLr8wZYLkHS1cCyDiUyKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5267.namprd11.prod.outlook.com (2603:10b6:610:e2::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.23; Wed, 31 May 2023 13:20:16 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 13:20:16 +0000
Date: Wed, 31 May 2023 15:20:09 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Magnus Karlsson <magnus.karlsson@gmail.com>
CC: <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
	<andrii@kernel.org>, <netdev@vger.kernel.org>, <magnus.karlsson@intel.com>,
	<bjorn@kernel.org>, <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH v2 bpf-next 13/22] xsk: report ZC multi-buffer capability
 via xdp_features
Message-ID: <ZHdJiRDMLxpesOLA@boxer>
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
 <20230529155024.222213-14-maciej.fijalkowski@intel.com>
 <CAJ8uoz1qa-XgntqSUtwjU_vCajDAbZqYgEVSajZxidmpG0cOFQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJ8uoz1qa-XgntqSUtwjU_vCajDAbZqYgEVSajZxidmpG0cOFQ@mail.gmail.com>
X-ClientProxiedBy: FR3P281CA0118.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5267:EE_
X-MS-Office365-Filtering-Correlation-Id: aa4eb2b9-02a7-44d0-bd85-08db61d9c5c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FbDd7bsrMv/b9WxQd1VRbrBF2NwqugKnnKpjeS47/leyTG2cj7uy3D0J7LCOF78a+Ce1eiRR/0cRYv3DDe2E8HaXHsqgyYFolYjjCig565phT0s28ai0JHrPBKq7B0KSZ5WCnVjGULoHoC60EQW25mWxB/mxPXYZX2lQooYe0EyklPxL2xbRXQLwEqDU8S7H3ocWp0oSqUhSCnVlVDZNfw3bSEbGHs0ve4eetb9uP06VnXLPp8QocvwOa9oPYTuXyf6pfDYD5cJIUnnx0kx6OK3kYzTf+TXWgOVHrJUTeE5wIgApOvc9EiZdWygD1SbMMEsBzUUO6gRfibTDQKOEu6sbkPUI7KI5wG4DzFmyfg9ZHM1e04JMrkCgqinXebHqOqzt4ntVAV4g/+iN8jx+Zm5WTwlmdYciNvxQ+YYvlNNZV5iuPT42MJDk8bGzb56h9zU9+RdluuwjIcO97h/vkm/GVZsnxihdSvsWn+5CPKZ333lTkTrGEPMvfpAVpqlbOGm9YR6rZcGGR39ELcUjhmB9t97Il1RsvW4LQsbRYHSSO7CoOaNleRwfQPzcPyHK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(83380400001)(316002)(66946007)(66476007)(66556008)(5660300002)(6666004)(4326008)(6916009)(107886003)(82960400001)(38100700002)(33716001)(8676002)(41300700001)(8936002)(6486002)(86362001)(6512007)(2906002)(44832011)(9686003)(6506007)(186003)(478600001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U2Nanjlu9jzg2anKkgN8BoPxMwaZ864kXgiM3EO2JGZV+VRPn/miYJwfHnca?=
 =?us-ascii?Q?MFA8cRF8kU6XZXvJONOOfwQymYWt/uEAuZ1267ZUROoJyFe/5PuFTA5kaEkU?=
 =?us-ascii?Q?L0QV6KyrHZ7mLFNIjyrHgpv9SUaN9L4MKZ7dXCzHbmqCgLIrKck0vFVfCP3g?=
 =?us-ascii?Q?hREUi+/nWPsLXxxprf6Bvnb8jqy+/9F4CPbidAmK4eWhNNoskSOVUhA/jAtJ?=
 =?us-ascii?Q?I7Dup462DrpNRMHOXOzEfqoZy71W3p5Is0iuJYwA4Bmd1sAulBTbji1fH4r0?=
 =?us-ascii?Q?oHdaYTtIcAJ70Ep0o6A4zjXBu4a9z1Wv/kot/Zesu1FbLH7mhxqo2JGb0rPu?=
 =?us-ascii?Q?4jD0MasrnDIj2rsrEPxRETUB0A/nZ88ELUJkknLI4bztpR75SzccOpmQhS/U?=
 =?us-ascii?Q?ugxk9SdjOwdVHz3MsSwEXnOWORsK9N09ZbOwlxMhGmoPOuR3Ve4p++03RiCS?=
 =?us-ascii?Q?g1SHqrhikcZkaeZaTr0YIAgEh9+5yh7CiHpPNzM/QVfPP2JHBNeYtMOBYVe0?=
 =?us-ascii?Q?S9AuCWKGvdfuCOb8eaSewrrosxGhyjJFVHfZw0V40rtxNs08gZJ+Ab9I7GGk?=
 =?us-ascii?Q?xeNnqOEAeBXN6jrkPuuudeLHMsP4hKF9zhcSTFgzxZWpypeJYfz5ZjjLUwKU?=
 =?us-ascii?Q?1PdBSLhA+UdF+GA0Y4Y5+53dP5IxCMGA5aIyLK/LoKMXcbss2kDyfIWaXwM7?=
 =?us-ascii?Q?P4vKa33p+jXLrLcgoa49ZxI5VkBqYzLTl98mBRYPW28sk3f2piLAX2S4tvM9?=
 =?us-ascii?Q?jvtNAaX8GzOapsccb4Ths9YOqR/gwWP5Q15F+QIth1mTK+OKvqMBtvq8BsqL?=
 =?us-ascii?Q?+RZNaqS/MBFucym3U4GVY1xTFOINbBu4ID6QpEDMPv9R/wDy15FZ6teZ/FkN?=
 =?us-ascii?Q?g4f8V3/doPGviO4l7CL0C9cBvBXOn23bznLDxjdmfUow+2fEVs4lA0IwzpmK?=
 =?us-ascii?Q?6aGJK70vXVGlf0NeoaXAJYWTQlfjacbc46qznlW0Gs4Vt7z3JWW/YKQM0+Wc?=
 =?us-ascii?Q?f8RFjrUHE4JwyZV+1RbYDoLfVPoUxaYR0pYx+gr/559OiEf+hQYVSGspp0w9?=
 =?us-ascii?Q?JZHk6mTh8F9YODPfU8AtUrsdxDs8ukh+Tu2GyQKkcbJ0H2ruup02cZ7qG59G?=
 =?us-ascii?Q?u2zmRX6b9jEom4sZ6EyfiAVxShpG/TSv77acVR/awuJBm0QOGDmAJwD5Y4co?=
 =?us-ascii?Q?amSyeqmWwNf5C6GIfilVJiBw4Uvy60fKT6LLAQOfDSWrlZJQ0I2gWgti4bUl?=
 =?us-ascii?Q?Clp7FVKj4kmeo7E4CmVy+jlUa2JWX4FQK2aCECBDEF0dHPcAEwv+E5CUN+yJ?=
 =?us-ascii?Q?Od9mXjYTT+L7o/yJT5OpdUnN1ZBBhrg+luyV4q5HNVhhPegCe9HrvP4eck2o?=
 =?us-ascii?Q?m1F/YWIxjazhRRcR9Titbgl4veUh0yVvmN2wjMXXAOxRqAZM5iqRzLRWuoXW?=
 =?us-ascii?Q?8hsN6f57MPSByNNI5nTLiGBgs57SlUIn+dR6h0Ga+YrahsDfgSXKv9uGydsu?=
 =?us-ascii?Q?fzBoTz83QiqHMQkzg7Q2kAUZ5Pr9pMDQW4S2C/bPGo75bT+mk+CV0q8Jhm2Q?=
 =?us-ascii?Q?BoEzT3vhnLAiW+NkQ+LA4vO4L4PuS0wMa92xfjaOGrHkj3Ru7oB21s3EJJ8f?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4eb2b9-02a7-44d0-bd85-08db61d9c5c0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 13:20:15.8431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRQLipFj6YNwdnFy+AcBRdFfS2vmV9q8SSQTKVj6VOkyjg2xstqi2PLC2mAwjDhJLdfmnWoFYBXI+VmEApGKkB9mVcUb46o+79J9V40UXRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5267
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:16:13PM +0200, Magnus Karlsson wrote:
> On Mon, 29 May 2023 at 17:57, Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > Introduce new xdp_feature NETDEV_XDP_ACT_NDO_ZC_SG that will be used to
> > find out if user space that wants to do ZC multi-buffer will be able to
> > do so against underlying ZC driver.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  include/uapi/linux/netdev.h | 4 ++--
> >  net/xdp/xsk_buff_pool.c     | 6 ++++++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> > index 639524b59930..bfca07224f7b 100644
> > --- a/include/uapi/linux/netdev.h
> > +++ b/include/uapi/linux/netdev.h
> > @@ -33,8 +33,8 @@ enum netdev_xdp_act {
> >         NETDEV_XDP_ACT_HW_OFFLOAD = 16,
> >         NETDEV_XDP_ACT_RX_SG = 32,
> >         NETDEV_XDP_ACT_NDO_XMIT_SG = 64,
> > -
> > -       NETDEV_XDP_ACT_MASK = 127,
> > +       NETDEV_XDP_ACT_NDO_ZC_SG = 128,
> 
> Since this flag has nothing to do with an NDO, I would prefer the
> simpler NETDEV_XDP_ACT_ZC_SG. What do you think?

+1, brain fart with that "NDO" on my side.

> 
> > +       NETDEV_XDP_ACT_MASK = 255,
> >  };
> >
> >  enum {
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index 0a9f8ea68de3..43cca5fa90cf 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -189,6 +189,12 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
> >                 goto err_unreg_pool;
> >         }
> >
> > +       if (!(netdev->xdp_features & NETDEV_XDP_ACT_NDO_ZC_SG) &&
> > +           flags & XDP_USE_SG) {
> > +               err = -EOPNOTSUPP;
> > +               goto err_unreg_pool;
> > +       }
> > +
> >         bpf.command = XDP_SETUP_XSK_POOL;
> >         bpf.xsk.pool = pool;
> >         bpf.xsk.queue_id = queue_id;
> > --
> > 2.35.3
> >
> >
> 

