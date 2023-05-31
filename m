Return-Path: <netdev+bounces-6868-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB5AB7187A2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:40:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D97328150A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1644174CA;
	Wed, 31 May 2023 16:40:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAEF14AB3
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:40:11 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9725A98;
	Wed, 31 May 2023 09:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685551208; x=1717087208;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=31w1L7iaMyzGQGyp37RoZI/9VVqxvAgaTkEQeqy9b8o=;
  b=L0/T9wfVoq9XJZkpWxIDD6hux5HTy4FbM5lLxRtVA1mjlGoC3Esml47S
   Zav8/hlbE0l1u6tpEDYXTBloKszX80tdrxvH0blde/MG8j5rmnxnJP6hC
   0EIGB1iw1HDjRYbfl9vnwFy9vHOxsVyvjqgdQs8wS4/mLSR87AHcKqnWj
   ad7C7akWXtiI2PUATy6csXJ5+QTUtgswsO35sW6tiLRlri5YjxVkqI5/Q
   XqXq1c5AveWjpeSgEnKixVRLcHCAVrHQ0LD/OoGdNW0PlQ9TZ1XtZrmpE
   ZCKboIQQIDk/obu346W6/zoz9sOBV9Eah4U7ZxG1oWcBIhpFigc63QbCt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="357684438"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="357684438"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 09:40:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="953695934"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="953695934"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 31 May 2023 09:40:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 09:40:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 09:40:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 09:40:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 09:40:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yxd9EzhT7CsQUhPGBmhqL3B+Oef/qAT5xzDuGnSkNRwCN6KJtq5ppVzBU4VSvzGLPCJGodmwPUqaYz2dlm7ENiVc13ghe0AFDCdHZc4UNL+VqAIUE9lYML0ccmbC8392BuUtDaBfoPuiUSf9gPmmnsDAkIlQ848fD8z2v6YUA69YyNXBO89J/uQ62FimPfTcHFthQsMsttuiL66yWV8Y2meMOEHRnzpAQ8ZT0IBXCMsqd+XTkXm6WJxE6beepLRGajcdXYv7kjxVlwmtDH8JfXBWcalSAEZCTq+iyZH1dLITMqcPIN5r8cs8R76ZwjYsnW0q/5tknSHnWlpGHneS9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTPcOa0x9NeOIy1x3ZM3sNSamW1aMIjhLWISDMeXqm4=;
 b=lOS7uhEr4rkKMFKMHqIsDOUHnQEmJz6qje6pQ+m1qh+ry/Fr7YFQUCkxNWfgXKm1NgFelyzJ5pCN8acClgS7l02O+yhhpUrk1i5dDfQj4IuolqXI0eqocBNWqNfSGKcMGr2kohVOF/WLse6LICKiZQBwFgW/4UZsMi52SMEfkmIOPI/EqtHft+WOAla/vCD5Cjr0WyJ5XkI/fZcz1qJEB4ZfriQMj1qT7r4NEH5tBxgnA9xpja1fWvmBpkIaRQOC21uYIorJiBV9nYsXMlu1P3NmpfPAabWqpHZQn5lAGrbpKLbCCOYVfinT5SApH6f9/94twnustEBrxUP9AvXvBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5160.namprd11.prod.outlook.com (2603:10b6:510:3e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.22; Wed, 31 May 2023 16:39:59 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:39:59 +0000
Date: Wed, 31 May 2023 18:39:44 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Magnus Karlsson <magnus.karlsson@intel.com>, "Michal
 Kubiak" <michal.kubiak@intel.com>, Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Christoph Hellwig <hch@lst.de>, Paul Menzel
	<pmenzel@molgen.mpg.de>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 03/12] iavf: optimize Rx buffer allocation a
 bunch
Message-ID: <ZHd4UPXgNaJlmyv1@boxer>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
 <20230530150035.1943669-4-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230530150035.1943669-4-aleksander.lobakin@intel.com>
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d277515-150d-44b1-652a-08db61f5ac41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5X5Vt3cbeBlFX5K0Cw095ffECWE6OLvESZIkLvNlW3BysCNDPXyB5htUQ0E/aVT2L5wY+BE8946gYZ/c5E4uqxbvpeFc4REJ2wWgwm+WgKx4UmFWY9sgI3dQB0iwPdeWYOvtanQ2BVKQtzqb67d58BSoiSzSTOw+t0JApV5z/6PYeq6qp9kGEm5JWz7J2dBM3tPqvTdJ+l+3xjgj7Xhe7OavkS1NAMC+QJJHp3np1xznqrx11T16VCzbBqI6G6jC38RJC+KJodEs/a/f2HytC+Uekkgk7HsEukshf3QSlJ7DoUn2EKc1gXUWhs8c8fmW2m9IWUhfXuw54+JNH4Hth4ACqyuuzDa/fTmqNcroIX9QUAfOmXaci1f0YNNmytfNwWqpBMpIQgtzqdDTC9uAzd4GM/gEhz38msbxL5UpfKb4ODl2wZXd5hZyy2MWFcO3BOLdzB8DmjgBhw0vKgHAHtJWX65WrkD79gzz4nFTIMAfbnoQ5WUQqSCaK0xF9NbxmnSG2qAVKSbgxFfwmsYxZZN/yCLmbJvoOlCv7LMvi8BsGfcSDK5LEIBEegrkIh3d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199021)(44832011)(7416002)(66476007)(66556008)(66946007)(4326008)(6636002)(8676002)(316002)(41300700001)(54906003)(5660300002)(6862004)(8936002)(30864003)(2906002)(6486002)(6666004)(478600001)(26005)(6512007)(186003)(83380400001)(9686003)(6506007)(33716001)(82960400001)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?95jDUzcka2LHeedt4LPZ9epCsHE3+72ccDgLaIKUzmwEfmeJnoQcALsBSohL?=
 =?us-ascii?Q?vl+oIOYNT5x4qnqnmLz6NzdRmgpMUHXAKEWDYabzzg005VyI2dbgCtoBzXnB?=
 =?us-ascii?Q?B/WtI2Z9d5SfcPd2VgI+oOCFPk6vDXOpTmJ4dUEGQz635tM40PUaIdjCXFKd?=
 =?us-ascii?Q?7N4dGnk7CpK318NdCwKUnfSm+tVkWVBUmr9ka9R3qirMVsL8LNTbfzp4G4DH?=
 =?us-ascii?Q?nN7P/PdCwLNCgZFdOBS2tRc9h/7xodRvd6w7c4c7L6v/uKQLF78E6HKvEzim?=
 =?us-ascii?Q?kMd4oFTRF307zTdo7QQr/cm50QZ1Lv2FeEPHkJd3cAfX2t2OtgOHCqYh9l/z?=
 =?us-ascii?Q?RzdvaflsKU+wxW3EvIfmX8ETSsS+a0dx1U7rZoUGDuWoreNUZqgpN4UTWeYU?=
 =?us-ascii?Q?riz4UfXhmV2Mjn1EXDM7uXjGoZUm8vKjZHMleFOggTbb0ejnUyo5RCW8QGpq?=
 =?us-ascii?Q?/qAQBD5oWr1lxOZSVRHNK7otFg74PUm3gHPYNatPFdI5Eh75OXtEUG50HD1E?=
 =?us-ascii?Q?FyzY+Bqt1NRlJrm/ZVjJaJ+QWczrGqrQ8ZguFfM6fbfchvbQOM+uhOyepqSW?=
 =?us-ascii?Q?Nmzm3bx8Ao2i+LpAxaXh2g/ojFQNtiU/qd0jktynJodY3AMIO53n1T/l1Zij?=
 =?us-ascii?Q?nGAETEebD4AXqwq9Hd7sRKPtb8qEpWc7GoqyVTA5WqeKuOIQDkiq8EGgRWyb?=
 =?us-ascii?Q?bFlaRzJUsX9/StKDq9idGswHA6UlPgdBxElwOFn5PPOyh7cUgUTxH1jsJu6h?=
 =?us-ascii?Q?wnjXCluUI1AJ1sGuKzEDYBjy0zGM7YkXQ1kiqVnIKLqSdeB0YE/H+ICZ1OCi?=
 =?us-ascii?Q?ABM0Q9IkuQAEuHqj8dY+oDTqHTVycmjZH4ZUdU5i7nViJfgmGpUxmjQ6eiKr?=
 =?us-ascii?Q?TIfaOsionaCW2bMacZ7SqThxIdRve3aKQjwyir3wbMK41r5m8LVW3Htqgcv6?=
 =?us-ascii?Q?mGrE1mYDgilmY+iSKz0hPuLteOuB/IxV3O5c1EeoCfVMMfw07HFKmAjBETSX?=
 =?us-ascii?Q?QOdiQjRnK2hB/QGydaMvh82yb+qQZJhXdnM5ZcslPZfcLubOnlYw8dT9yOaj?=
 =?us-ascii?Q?5t5E9XOi+pDfYQrJ+2LoxGv/ShZvT2pueUlOEpJ4x2CrDnR/U3Xsfjvdam9q?=
 =?us-ascii?Q?kOeFgQQfieVG/7ykTF4MMOE295RbkjVHu9nJaQmxQvZ+Q2AhYdrwY2l5oqNs?=
 =?us-ascii?Q?lKZwb7rnaP4/CCsqkFkZztEbF+63pE9F+9/t4o86eWXNTSR9MFIxppdCJxAi?=
 =?us-ascii?Q?D45XEu3fb0h+PNwirYIzfAeoQnEKQJ7EIxWtbyk3TQSgl8HxXDr+kamMhGQ2?=
 =?us-ascii?Q?aXqTeFteD1xeanxc80Uqt1GPvh5sDExWcOllT82jF7SAyMMSUIpV+2epd5y8?=
 =?us-ascii?Q?zNjBdCrYOyz+CpLT/xmn9Sf/GGDqvW2w98CIiEnfwLj9cp1lYADwblHDBdBN?=
 =?us-ascii?Q?qhF1WB7V/98iNV/icFVJyz9+Pzjo+5jOtNp5f3mnVXfX69zpqYsCgmf9zab3?=
 =?us-ascii?Q?PYKWZmq/0WSHuw622q5Cs0yNLOV4qzF/db/hpUDCEX5j2XJ2jzQcI/Zni62x?=
 =?us-ascii?Q?lclcMVLqu4R3OdN8zthpwmeRuuOz8dPDCr4wp6Jwm5RxnuaZrLsT0IHcZsq/?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d277515-150d-44b1-652a-08db61f5ac41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:39:59.1112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OaXVZBtJ/P6Jaoyg+ZlDNqsky2zRbRXuM9NSulTuwaQNSW5Y8GxcpnvzG7kjLd1AhKXu0CnKEAxordL8S8AI3t0qm5KizFCkGWFEoPrB6IQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5160
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 05:00:26PM +0200, Alexander Lobakin wrote:
> The Rx hotpath code of IAVF is not well-optimized TBH. Before doing any
> further buffer model changes, shake it up a bit. Notably:
> 
> 1. Cache more variables on the stack.
>    DMA device, Rx page size, NTC -- these are the most common things
>    used all throughout the hotpath, often in loops on each iteration.
>    Instead of fetching (or even calculating, as with the page size) them
>    from the ring all the time, cache them on the stack at the beginning
>    of the NAPI polling callback. NTC will be written back at the end,
>    the rest are used read-only, so no sync needed.

I like calculating page size once per napi istance. Reduces a bunch of
branches ;)

Yet another optimization I did on other drivers was to store rx_offset
within ring struct. I skipped iavf for some reason. I can follow-up with
that, but I'm bringing this up so we keep an eye on it.

> 2. Don't move the recycled buffers around the ring.
>    The idea of passing the page of the right-now-recycled-buffer to a
>    different buffer, in this case, the first one that needs to be
>    allocated, moreover, on each new frame, is fundamentally wrong. It
>    involves a few o' fetches, branches and then writes (and one Rx
>    buffer struct is at least 32 bytes) where they're completely unneeded,
>    but gives no good -- the result is the same as if we'd recycle it
>    inplace, at the same position where it was used. So drop this and let
>    the main refilling function take care of all the buffers, which were
>    processed and now need to be recycled/refilled.
> 3. Don't allocate with %GPF_ATOMIC on ifup.

s/GPF/GFP

>    This involved introducing the @gfp parameter to a couple functions.
>    Doesn't change anything for Rx -> softirq.
> 4. 1 budget unit == 1 descriptor, not skb.
>    There could be underflow when receiving a lot of fragmented frames.
>    If each of them would consist of 2 frags, it means that we'd process
>    64 descriptors at the point where we pass the 32th skb to the stack.
>    But the driver would count that only as a half, which could make NAPI
>    re-enable interrupts prematurely and create unnecessary CPU load.

How would this affect 9k MTU workloads?

> 5. Shortcut !size case.
>    It's super rare, but possible -- for example, if the last buffer of
>    the fragmented frame contained only FCS, which was then stripped by
>    the HW. Instead of checking for size several times when processing,
>    quickly reuse the buffer and jump to the skb fields part.

would be good to say about pagecnt_bias handling.

> 6. Refill the ring after finishing the polling loop.
>    Previously, the loop wasn't starting a new iteration after the 64th
>    desc, meaning that we were always leaving 16 buffers non-refilled
>    until the next NAPI poll. It's better to refill them while they're
>    still hot, so do that right after exiting the loop as well.
>    For a full cycle of 64 descs, there will be 4 refills of 16 descs
>    from now on.

As said on different sub-thread, I'd rather see the bullets above as a
separate patches.

> 
> Function: add/remove: 4/2 grow/shrink: 0/5 up/down: 473/-647 (-174)
> 
> + up to 2% performance.

I am sort of not buying that. You are removing iavf_reuse_rx_page() here
which is responsible for reusing the page, but on next patch that is
supposed to avoid page split perf drops by 30%. A bit confusing?

> 
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c |   2 +-
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c | 259 +++++++++-----------
>  drivers/net/ethernet/intel/iavf/iavf_txrx.h |   3 +-
>  3 files changed, 114 insertions(+), 150 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index a5a6c9861a93..ade32aa1ed78 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -1236,7 +1236,7 @@ static void iavf_configure(struct iavf_adapter *adapter)
>  	for (i = 0; i < adapter->num_active_queues; i++) {
>  		struct iavf_ring *ring = &adapter->rx_rings[i];
>  
> -		iavf_alloc_rx_buffers(ring, IAVF_DESC_UNUSED(ring));
> +		iavf_alloc_rx_buffers(ring);
>  	}
>  }
>  
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> index a7121dc5c32b..fd08ce67380e 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> @@ -736,7 +736,6 @@ void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
>  	/* Zero out the descriptor ring */
>  	memset(rx_ring->desc, 0, rx_ring->size);
>  
> -	rx_ring->next_to_alloc = 0;
>  	rx_ring->next_to_clean = 0;
>  	rx_ring->next_to_use = 0;
>  }
> @@ -792,7 +791,6 @@ int iavf_setup_rx_descriptors(struct iavf_ring *rx_ring)
>  		goto err;
>  	}
>  
> -	rx_ring->next_to_alloc = 0;
>  	rx_ring->next_to_clean = 0;
>  	rx_ring->next_to_use = 0;
>  
> @@ -812,9 +810,6 @@ static inline void iavf_release_rx_desc(struct iavf_ring *rx_ring, u32 val)
>  {
>  	rx_ring->next_to_use = val;
>  
> -	/* update next to alloc since we have filled the ring */
> -	rx_ring->next_to_alloc = val;
> -
>  	/* Force memory writes to complete before letting h/w
>  	 * know there are new descriptors to fetch.  (Only
>  	 * applicable for weak-ordered memory model archs,
> @@ -828,12 +823,17 @@ static inline void iavf_release_rx_desc(struct iavf_ring *rx_ring, u32 val)
>   * iavf_alloc_mapped_page - recycle or make a new page
>   * @rx_ring: ring to use
>   * @bi: rx_buffer struct to modify
> + * @dev: device used for DMA mapping
> + * @order: page order to allocate
> + * @gfp: GFP mask to allocate page
>   *
>   * Returns true if the page was successfully allocated or
>   * reused.
>   **/
>  static bool iavf_alloc_mapped_page(struct iavf_ring *rx_ring,
> -				   struct iavf_rx_buffer *bi)
> +				   struct iavf_rx_buffer *bi,
> +				   struct device *dev, u32 order,
> +				   gfp_t gfp)
>  {
>  	struct page *page = bi->page;
>  	dma_addr_t dma;
> @@ -845,23 +845,21 @@ static bool iavf_alloc_mapped_page(struct iavf_ring *rx_ring,
>  	}
>  
>  	/* alloc new page for storage */
> -	page = dev_alloc_pages(iavf_rx_pg_order(rx_ring));
> +	page = __dev_alloc_pages(gfp, order);
>  	if (unlikely(!page)) {
>  		rx_ring->rx_stats.alloc_page_failed++;
>  		return false;
>  	}
>  
>  	/* map page for use */
> -	dma = dma_map_page_attrs(rx_ring->dev, page, 0,
> -				 iavf_rx_pg_size(rx_ring),
> -				 DMA_FROM_DEVICE,
> -				 IAVF_RX_DMA_ATTR);
> +	dma = dma_map_page_attrs(dev, page, 0, PAGE_SIZE << order,
> +				 DMA_FROM_DEVICE, IAVF_RX_DMA_ATTR);
>  
>  	/* if mapping failed free memory back to system since
>  	 * there isn't much point in holding memory we can't use
>  	 */
> -	if (dma_mapping_error(rx_ring->dev, dma)) {
> -		__free_pages(page, iavf_rx_pg_order(rx_ring));
> +	if (dma_mapping_error(dev, dma)) {
> +		__free_pages(page, order);
>  		rx_ring->rx_stats.alloc_page_failed++;
>  		return false;
>  	}
> @@ -898,32 +896,36 @@ static void iavf_receive_skb(struct iavf_ring *rx_ring,
>  }
>  
>  /**
> - * iavf_alloc_rx_buffers - Replace used receive buffers
> + * __iavf_alloc_rx_buffers - Replace used receive buffers
>   * @rx_ring: ring to place buffers on
> - * @cleaned_count: number of buffers to replace
> + * @to_refill: number of buffers to replace
> + * @gfp: GFP mask to allocate pages
>   *
> - * Returns false if all allocations were successful, true if any fail
> + * Returns 0 if all allocations were successful or the number of buffers left
> + * to refill in case of an allocation failure.
>   **/
> -bool iavf_alloc_rx_buffers(struct iavf_ring *rx_ring, u16 cleaned_count)
> +static u32 __iavf_alloc_rx_buffers(struct iavf_ring *rx_ring, u32 to_refill,
> +				   gfp_t gfp)
>  {
> -	u16 ntu = rx_ring->next_to_use;
> +	u32 order = iavf_rx_pg_order(rx_ring);
> +	struct device *dev = rx_ring->dev;
> +	u32 ntu = rx_ring->next_to_use;
>  	union iavf_rx_desc *rx_desc;
>  	struct iavf_rx_buffer *bi;
>  
>  	/* do nothing if no valid netdev defined */
> -	if (!rx_ring->netdev || !cleaned_count)
> -		return false;
> +	if (unlikely(!rx_ring->netdev || !to_refill))
> +		return 0;
>  
>  	rx_desc = IAVF_RX_DESC(rx_ring, ntu);
>  	bi = &rx_ring->rx_bi[ntu];
>  
>  	do {
> -		if (!iavf_alloc_mapped_page(rx_ring, bi))
> -			goto no_buffers;
> +		if (!iavf_alloc_mapped_page(rx_ring, bi, dev, order, gfp))
> +			break;
>  
>  		/* sync the buffer for use by the device */
> -		dma_sync_single_range_for_device(rx_ring->dev, bi->dma,
> -						 bi->page_offset,
> +		dma_sync_single_range_for_device(dev, bi->dma, bi->page_offset,
>  						 rx_ring->rx_buf_len,
>  						 DMA_FROM_DEVICE);
>  
> @@ -943,23 +945,17 @@ bool iavf_alloc_rx_buffers(struct iavf_ring *rx_ring, u16 cleaned_count)
>  
>  		/* clear the status bits for the next_to_use descriptor */
>  		rx_desc->wb.qword1.status_error_len = 0;
> -
> -		cleaned_count--;
> -	} while (cleaned_count);
> +	} while (--to_refill);
>  
>  	if (rx_ring->next_to_use != ntu)
>  		iavf_release_rx_desc(rx_ring, ntu);
>  
> -	return false;
> -
> -no_buffers:
> -	if (rx_ring->next_to_use != ntu)
> -		iavf_release_rx_desc(rx_ring, ntu);
> +	return to_refill;
> +}
>  
> -	/* make sure to come back via polling to try again after
> -	 * allocation failure
> -	 */
> -	return true;
> +void iavf_alloc_rx_buffers(struct iavf_ring *rxr)
> +{
> +	__iavf_alloc_rx_buffers(rxr, IAVF_DESC_UNUSED(rxr), GFP_KERNEL);
>  }
>  
>  /**
> @@ -1104,32 +1100,6 @@ static bool iavf_cleanup_headers(struct iavf_ring *rx_ring, struct sk_buff *skb)
>  	return false;
>  }
>  
> -/**
> - * iavf_reuse_rx_page - page flip buffer and store it back on the ring
> - * @rx_ring: rx descriptor ring to store buffers on
> - * @old_buff: donor buffer to have page reused
> - *
> - * Synchronizes page for reuse by the adapter
> - **/
> -static void iavf_reuse_rx_page(struct iavf_ring *rx_ring,
> -			       struct iavf_rx_buffer *old_buff)

this is recycling logic so i feel this removal belongs to patch 04, right?

> -{
> -	struct iavf_rx_buffer *new_buff;
> -	u16 nta = rx_ring->next_to_alloc;
> -
> -	new_buff = &rx_ring->rx_bi[nta];
> -
> -	/* update, and store next to alloc */
> -	nta++;
> -	rx_ring->next_to_alloc = (nta < rx_ring->count) ? nta : 0;
> -
> -	/* transfer page from old buffer to new buffer */
> -	new_buff->dma		= old_buff->dma;
> -	new_buff->page		= old_buff->page;
> -	new_buff->page_offset	= old_buff->page_offset;
> -	new_buff->pagecnt_bias	= old_buff->pagecnt_bias;
> -}
> -
>  /**
>   * iavf_can_reuse_rx_page - Determine if this page can be reused by
>   * the adapter for another receive
> @@ -1191,30 +1161,26 @@ static bool iavf_can_reuse_rx_page(struct iavf_rx_buffer *rx_buffer)
>  
>  /**
>   * iavf_add_rx_frag - Add contents of Rx buffer to sk_buff
> - * @rx_ring: rx descriptor ring to transact packets on
> - * @rx_buffer: buffer containing page to add
>   * @skb: sk_buff to place the data into
> + * @rx_buffer: buffer containing page to add
>   * @size: packet length from rx_desc
> + * @pg_size: Rx buffer page size
>   *
>   * This function will add the data contained in rx_buffer->page to the skb.
>   * It will just attach the page as a frag to the skb.
>   *
>   * The function will then update the page offset.
>   **/
> -static void iavf_add_rx_frag(struct iavf_ring *rx_ring,
> +static void iavf_add_rx_frag(struct sk_buff *skb,
>  			     struct iavf_rx_buffer *rx_buffer,
> -			     struct sk_buff *skb,
> -			     unsigned int size)
> +			     u32 size, u32 pg_size)
>  {
>  #if (PAGE_SIZE < 8192)
> -	unsigned int truesize = iavf_rx_pg_size(rx_ring) / 2;
> +	unsigned int truesize = pg_size / 2;
>  #else
>  	unsigned int truesize = SKB_DATA_ALIGN(size + IAVF_SKB_PAD);
>  #endif
>  
> -	if (!size)
> -		return;
> -
>  	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, rx_buffer->page,
>  			rx_buffer->page_offset, size, truesize);
>  
> @@ -1224,63 +1190,47 @@ static void iavf_add_rx_frag(struct iavf_ring *rx_ring,
>  #else
>  	rx_buffer->page_offset += truesize;
>  #endif
> +
> +	/* We have pulled a buffer for use, so decrement pagecnt_bias */
> +	rx_buffer->pagecnt_bias--;
>  }
>  
>  /**
> - * iavf_get_rx_buffer - Fetch Rx buffer and synchronize data for use
> - * @rx_ring: rx descriptor ring to transact packets on
> - * @size: size of buffer to add to skb
> + * iavf_sync_rx_buffer - Synchronize received data for use
> + * @dev: device used for DMA mapping
> + * @buf: Rx buffer containing the data
> + * @size: size of the received data
>   *
> - * This function will pull an Rx buffer from the ring and synchronize it
> - * for use by the CPU.
> + * This function will synchronize the Rx buffer for use by the CPU.
>   */
> -static struct iavf_rx_buffer *iavf_get_rx_buffer(struct iavf_ring *rx_ring,
> -						 const unsigned int size)
> +static void iavf_sync_rx_buffer(struct device *dev, struct iavf_rx_buffer *buf,
> +				u32 size)

you have peeled out all of the contents of this function, why not calling
dma_sync_single_range_for_cpu() directly?

>  {
> -	struct iavf_rx_buffer *rx_buffer;
> -
> -	rx_buffer = &rx_ring->rx_bi[rx_ring->next_to_clean];
> -	prefetchw(rx_buffer->page);
> -	if (!size)
> -		return rx_buffer;
> -
> -	/* we are reusing so sync this buffer for CPU use */
> -	dma_sync_single_range_for_cpu(rx_ring->dev,
> -				      rx_buffer->dma,
> -				      rx_buffer->page_offset,
> -				      size,
> +	dma_sync_single_range_for_cpu(dev, buf->dma, buf->page_offset, size,
>  				      DMA_FROM_DEVICE);
> -
> -	/* We have pulled a buffer for use, so decrement pagecnt_bias */
> -	rx_buffer->pagecnt_bias--;
> -
> -	return rx_buffer;
>  }
>  
>  /**
>   * iavf_build_skb - Build skb around an existing buffer
> - * @rx_ring: Rx descriptor ring to transact packets on
> - * @rx_buffer: Rx buffer to pull data from
> - * @size: size of buffer to add to skb
> + * @rx_buffer: Rx buffer with the data
> + * @size: size of the data
> + * @pg_size: size of the Rx page
>   *
>   * This function builds an skb around an existing Rx buffer, taking care
>   * to set up the skb correctly and avoid any memcpy overhead.
>   */
> -static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
> -				      struct iavf_rx_buffer *rx_buffer,
> -				      unsigned int size)
> +static struct sk_buff *iavf_build_skb(struct iavf_rx_buffer *rx_buffer,
> +				      u32 size, u32 pg_size)
>  {
>  	void *va;
>  #if (PAGE_SIZE < 8192)
> -	unsigned int truesize = iavf_rx_pg_size(rx_ring) / 2;
> +	unsigned int truesize = pg_size / 2;
>  #else
>  	unsigned int truesize = SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) +
>  				SKB_DATA_ALIGN(IAVF_SKB_PAD + size);
>  #endif
>  	struct sk_buff *skb;
>  
> -	if (!rx_buffer || !size)
> -		return NULL;
>  	/* prefetch first cache line of first page */
>  	va = page_address(rx_buffer->page) + rx_buffer->page_offset;
>  	net_prefetch(va);
> @@ -1301,36 +1251,33 @@ static struct sk_buff *iavf_build_skb(struct iavf_ring *rx_ring,
>  	rx_buffer->page_offset += truesize;
>  #endif
>  
> +	rx_buffer->pagecnt_bias--;
> +
>  	return skb;
>  }
>  
>  /**
> - * iavf_put_rx_buffer - Clean up used buffer and either recycle or free
> + * iavf_put_rx_buffer - Recycle or free used buffer
>   * @rx_ring: rx descriptor ring to transact packets on
> - * @rx_buffer: rx buffer to pull data from
> + * @dev: device used for DMA mapping
> + * @rx_buffer: Rx buffer to handle
> + * @pg_size: Rx page size
>   *
> - * This function will clean up the contents of the rx_buffer.  It will
> - * either recycle the buffer or unmap it and free the associated resources.
> + * Either recycle the buffer if possible or unmap and free the page.
>   */
> -static void iavf_put_rx_buffer(struct iavf_ring *rx_ring,
> -			       struct iavf_rx_buffer *rx_buffer)
> +static void iavf_put_rx_buffer(struct iavf_ring *rx_ring, struct device *dev,
> +			       struct iavf_rx_buffer *rx_buffer, u32 pg_size)
>  {
> -	if (!rx_buffer)
> -		return;
> -
>  	if (iavf_can_reuse_rx_page(rx_buffer)) {
> -		/* hand second half of page back to the ring */
> -		iavf_reuse_rx_page(rx_ring, rx_buffer);
>  		rx_ring->rx_stats.page_reuse_count++;

what is the purpose of not reusing the page but bumping the meaningless
stat? ;)

> -	} else {
> -		/* we are not reusing the buffer so unmap it */
> -		dma_unmap_page_attrs(rx_ring->dev, rx_buffer->dma,
> -				     iavf_rx_pg_size(rx_ring),
> -				     DMA_FROM_DEVICE, IAVF_RX_DMA_ATTR);
> -		__page_frag_cache_drain(rx_buffer->page,
> -					rx_buffer->pagecnt_bias);
> +		return;
>  	}
>  
> +	/* we are not reusing the buffer so unmap it */
> +	dma_unmap_page_attrs(dev, rx_buffer->dma, pg_size,
> +			     DMA_FROM_DEVICE, IAVF_RX_DMA_ATTR);
> +	__page_frag_cache_drain(rx_buffer->page, rx_buffer->pagecnt_bias);
> +
>  	/* clear contents of buffer_info */
>  	rx_buffer->page = NULL;
>  }
> @@ -1350,14 +1297,6 @@ static bool iavf_is_non_eop(struct iavf_ring *rx_ring,
>  			    union iavf_rx_desc *rx_desc,
>  			    struct sk_buff *skb)
>  {
> -	u32 ntc = rx_ring->next_to_clean + 1;
> -
> -	/* fetch, update, and store next to clean */
> -	ntc = (ntc < rx_ring->count) ? ntc : 0;
> -	rx_ring->next_to_clean = ntc;
> -
> -	prefetch(IAVF_RX_DESC(rx_ring, ntc));
> -
>  	/* if we are the last buffer then there is nothing else to do */
>  #define IAVF_RXD_EOF BIT(IAVF_RX_DESC_STATUS_EOF_SHIFT)
>  	if (likely(iavf_test_staterr(rx_desc, IAVF_RXD_EOF)))
> @@ -1383,11 +1322,16 @@ static bool iavf_is_non_eop(struct iavf_ring *rx_ring,
>  static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
>  {
>  	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
> +	const gfp_t gfp = GFP_ATOMIC | __GFP_NOWARN;
> +	u32 to_refill = IAVF_DESC_UNUSED(rx_ring);
> +	u32 pg_size = iavf_rx_pg_size(rx_ring);
>  	struct sk_buff *skb = rx_ring->skb;
> -	u16 cleaned_count = IAVF_DESC_UNUSED(rx_ring);
> -	bool failure = false;
> +	struct device *dev = rx_ring->dev;
> +	u32 ntc = rx_ring->next_to_clean;
> +	u32 ring_size = rx_ring->count;
> +	u32 cleaned_count = 0;
>  
> -	while (likely(total_rx_packets < (unsigned int)budget)) {
> +	while (likely(cleaned_count < budget)) {
>  		struct iavf_rx_buffer *rx_buffer;
>  		union iavf_rx_desc *rx_desc;
>  		unsigned int size;
> @@ -1396,13 +1340,11 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
>  		u64 qword;
>  
>  		/* return some buffers to hardware, one at a time is too slow */
> -		if (cleaned_count >= IAVF_RX_BUFFER_WRITE) {
> -			failure = failure ||
> -				  iavf_alloc_rx_buffers(rx_ring, cleaned_count);
> -			cleaned_count = 0;
> -		}
> +		if (to_refill >= IAVF_RX_BUFFER_WRITE)
> +			to_refill = __iavf_alloc_rx_buffers(rx_ring, to_refill,
> +							    gfp);
>  
> -		rx_desc = IAVF_RX_DESC(rx_ring, rx_ring->next_to_clean);
> +		rx_desc = IAVF_RX_DESC(rx_ring, ntc);
>  
>  		/* status_error_len will always be zero for unused descriptors
>  		 * because it's cleared in cleanup, and overlaps with hdr_addr
> @@ -1424,24 +1366,38 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
>  		       IAVF_RXD_QW1_LENGTH_PBUF_SHIFT;
>  
>  		iavf_trace(clean_rx_irq, rx_ring, rx_desc, skb);
> -		rx_buffer = iavf_get_rx_buffer(rx_ring, size);
> +		rx_buffer = &rx_ring->rx_bi[ntc];
> +
> +		/* Very rare, but possible case. The most common reason:
> +		 * the last fragment contained FCS only, which was then
> +		 * stripped by the HW.

you could also mention this is happening for fragmented frames

> +		 */
> +		if (unlikely(!size))
> +			goto skip_data;
> +
> +		iavf_sync_rx_buffer(dev, rx_buffer, size);
>  
>  		/* retrieve a buffer from the ring */
>  		if (skb)
> -			iavf_add_rx_frag(rx_ring, rx_buffer, skb, size);
> +			iavf_add_rx_frag(skb, rx_buffer, size, pg_size);
>  		else
> -			skb = iavf_build_skb(rx_ring, rx_buffer, size);
> +			skb = iavf_build_skb(rx_buffer, size, pg_size);
>  
>  		/* exit if we failed to retrieve a buffer */
>  		if (!skb) {
>  			rx_ring->rx_stats.alloc_buff_failed++;
> -			if (rx_buffer && size)
> -				rx_buffer->pagecnt_bias++;
>  			break;
>  		}
>  
> -		iavf_put_rx_buffer(rx_ring, rx_buffer);
> +skip_data:
> +		iavf_put_rx_buffer(rx_ring, dev, rx_buffer, pg_size);
> +
>  		cleaned_count++;
> +		to_refill++;
> +		if (unlikely(++ntc == ring_size))
> +			ntc = 0;
> +
> +		prefetch(IAVF_RX_DESC(rx_ring, ntc));
>  
>  		if (iavf_is_non_eop(rx_ring, rx_desc, skb))
>  			continue;
> @@ -1488,8 +1444,18 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
>  		total_rx_packets++;
>  	}
>  
> +	rx_ring->next_to_clean = ntc;
>  	rx_ring->skb = skb;
>  
> +	if (to_refill >= IAVF_RX_BUFFER_WRITE) {
> +		to_refill = __iavf_alloc_rx_buffers(rx_ring, to_refill, gfp);
> +		/* guarantee a trip back through this routine if there was
> +		 * a failure
> +		 */
> +		if (unlikely(to_refill))
> +			cleaned_count = budget;
> +	}
> +
>  	u64_stats_update_begin(&rx_ring->syncp);
>  	rx_ring->stats.packets += total_rx_packets;
>  	rx_ring->stats.bytes += total_rx_bytes;
> @@ -1497,8 +1463,7 @@ static int iavf_clean_rx_irq(struct iavf_ring *rx_ring, int budget)
>  	rx_ring->q_vector->rx.total_packets += total_rx_packets;
>  	rx_ring->q_vector->rx.total_bytes += total_rx_bytes;
>  
> -	/* guarantee a trip back through this routine if there was a failure */
> -	return failure ? budget : (int)total_rx_packets;
> +	return cleaned_count;
>  }
>  
>  static inline u32 iavf_buildreg_itr(const int type, u16 itr)
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.h b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> index 234e189c1987..9c6661a6edf2 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> @@ -383,7 +383,6 @@ struct iavf_ring {
>  	struct iavf_q_vector *q_vector;	/* Backreference to associated vector */
>  
>  	struct rcu_head rcu;		/* to avoid race on free */
> -	u16 next_to_alloc;
>  	struct sk_buff *skb;		/* When iavf_clean_rx_ring_irq() must
>  					 * return before it sees the EOP for
>  					 * the current packet, we save that skb
> @@ -426,7 +425,7 @@ static inline unsigned int iavf_rx_pg_order(struct iavf_ring *ring)
>  
>  #define iavf_rx_pg_size(_ring) (PAGE_SIZE << iavf_rx_pg_order(_ring))
>  
> -bool iavf_alloc_rx_buffers(struct iavf_ring *rxr, u16 cleaned_count);
> +void iavf_alloc_rx_buffers(struct iavf_ring *rxr);
>  netdev_tx_t iavf_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
>  void iavf_clean_tx_ring(struct iavf_ring *tx_ring);
>  void iavf_clean_rx_ring(struct iavf_ring *rx_ring);
> -- 
> 2.40.1
> 

