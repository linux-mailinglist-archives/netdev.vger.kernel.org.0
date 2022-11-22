Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38DB63446F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiKVTSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 14:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbiKVTS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 14:18:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71097617F;
        Tue, 22 Nov 2022 11:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669144705; x=1700680705;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=x2r0dLTz9oiov2RFh+wX+FpMm3Wd7aaO4TfHXIQpOJU=;
  b=M5EXunOgeRnApjg1sb3ZOs2KJIFXWV4oYbfKIIvGajUrzF9gUlQnvu0D
   54voEjSdauWjSR7WaXrNHbxPPXnBXVwxhcJ0acmQPug0iWZ9517d6TER3
   bvFjTCCe9rlir+RYoo0cVtiO8MwWeS739aGDH/xIa7MltGAjK76OyHmt5
   Yit3rc2HHaPx/H4PKjVIl0bvgLAJ5VmzR9DEnEfwx6AoWvUtyg+njV1Ue
   I4BGGavd3Hf1xBJ/FY/Q1ALCl3xIEItSgpaQZxl3xAGaIwjwl/pu17xND
   ze514lhbJdKehisDaiwlogGpi8vd/xrMOlKdQc6zfX3eH+NBdnhc0Zlu5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="313927799"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="313927799"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 11:18:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="592250445"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="592250445"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 22 Nov 2022 11:18:20 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 11:18:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 11:18:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 11:18:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnYX0bUYsIG1JNRbuz9I8A4U1TxOLuy01YFfit4Yp3Kr51V+vKqibjLWFw/y4vXC6LMPpHxqBYuEOzS5O1u9OT1PqC3/2jczU5I0u2iZ6j5/Onl4Qvm19Nr4EpZwGbdqG5ttRMFKwt73UID+pgtLXqnpBxdUYnfRdSWd7o77vVUWKVsXW51pxb9FxbSx1kezb1LF4RS/QGlANbhlyElUjhYpBU5kq/sRQXxp+DEp7yrDNB5w2P7YXkQ5c3+/erMYh7+LZp+f59FnQF6Qii37ZBA5Gluh3wCdIlUjrPMbYMncPYr+B9gKJcO+T1Vgye9Ch3I3/dDwBMWpnp904g6lHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OB1MuzvUbor76T/8/XphfjjXZLnu780SJnj1Fo1uc1c=;
 b=Gj6KEb1NCL/GBVk7xQvP+yFbeT6OAFkyDR33A8N86xqDZeD6qUOBoG+CG1TmzN4PgGou3o57zcpv6lebq0GpzASTsihbiChcMBTvymD5dH/F1+x2i1LPQnt4JhujZTP0GSaWgrISkWDO16tp1baLFqdSD3/qjAEYWJCXV/ijkO0kwQTYqnFQXOHon03gbNvYW/t8rka3cZO89b1BwZJzzeQzRWzCGVfHTj5x4949X130LtSSE7mgaF8jeOVSpQ68bFDgEiBgO5mSTqzvLB9ADh3MQD9FH+ebF8dPTcMaGHfNbNq9pXAlRJqzjnGdOnJ+zcdvncNhsllZ1EJxMGX2vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SA0PR11MB4607.namprd11.prod.outlook.com (2603:10b6:806:9b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 19:18:17 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::bd73:eae0:3c7:804]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::bd73:eae0:3c7:804%2]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 19:18:17 +0000
Date:   Tue, 22 Nov 2022 14:17:58 -0500
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Will Deacon" <will@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        <iommu@lists.linux.dev>, <maciej.fijalkowski@intel.com>,
        <magnus.karlsson@intel.com>
Subject: Re: [PATCH -next] iommu/dma: avoid expensive indirect calls for sync
 operations
Message-ID: <Y30gZm0mO4YNO85d@localhost.localdomain>
References: <20221112040452.644234-1-edumazet@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221112040452.644234-1-edumazet@google.com>
X-ClientProxiedBy: SJ0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::11) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SA0PR11MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dfc55cb-f42c-4e28-ff0f-08daccbe4f45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wkHFU5XS8lonEWoxhwcHqX+5rY2r2cV7hqplWY4w41MHOWCUHo0FHNEENtAF86uTKCoT7Y2T+3WBtp6nImH0fxBV/S4ptEvUaHhrfM2spp99jQRhoWXlrP4veu60HwzxgZuUE13mPdTtqEIcFcYIXVZ4LS0FxHZyVlLFA8+/SxJDzmNTUPedUbTZ1QJF4AzBZrD66cw+Jr7PHiQlJ0p2yoNbKEF66Aofh2CUKPwwquVKsI3yHmnI0Yg/HfZ/1Q+lrAhJ1q9TrYxxUs6hgr1XS3JzQwpbeDYHNaGXtHesOYrFknHgM1GKJIFOdW4hXm75wqpFW6Hx5D7/MsTYGxpkfBPX4i+kHtYW3CRvV1KR4TxBXRIwwKu0VuscRfoeE9c1zA5IYnld5UUyt4etYBeKSN02dmVVOyOHWRq+PebmZ8nUzFGddKYlS3rptnv7SBrf5vsyucx72UyIsGVbSPjVvpFz1in0rC3wvX//pupiigbOLOraL948iQIVLR4Dm1f8HYpzNJMYiXscI7jhXKNNbHhr/JEbqH4hB3KcL8xZA2ERnR1HoIGv6G15/jbtD0Bn+MTMYY10VRcCehWfQcwmsx1k5QtNwjzqCEBDfcMRWr495ueKyGYksBxdxE2QE0Ar8R+HT+7Pzve1Tk14ZJa/kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199015)(5660300002)(54906003)(83380400001)(6916009)(44832011)(82960400001)(6506007)(316002)(66476007)(8676002)(9686003)(41300700001)(4326008)(26005)(66946007)(66556008)(8936002)(186003)(38100700002)(2906002)(86362001)(6512007)(6666004)(107886003)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rz6+KCnr4p9kAK/H//UBnTCP0P9+Vi8P+cSOIu7rNqR3i2+8/5S7jlQC+xay?=
 =?us-ascii?Q?YHcJGoCoEU8Lt3xiMOEBprXcdJ/i9NNT3CqNm6CNP3g3nl2ZMRva2rGnssK/?=
 =?us-ascii?Q?LhLphup8b1MLWl1yfvcpw/NM0ZxH/VE1dgG/ypGwsqrQrpdnewi7T432ADDm?=
 =?us-ascii?Q?ylj5sRAiMKNDdy3EMeTbJVhBaSR+hZhQiI27Kfjj/gm2mVXyZ0eQ5VjAanOY?=
 =?us-ascii?Q?06Fq1RpnttT5bokUnGZt/1CUIxewtqWj2MI268Tgmzm94o6SNHX0ZjmwTJNm?=
 =?us-ascii?Q?PIPU/yqHGYGd86C/hmAA0E2/n4wu9ESCp96POhTkb1GnHjD7GnkV2/8mSqIB?=
 =?us-ascii?Q?1PdUE79ixgIhvH/Ow7VQre/YlGcLxnGfccTqoBpl4heb+yrMlm8ALS1+k676?=
 =?us-ascii?Q?G/zacgWGbOGmF76bkU2Bcy96x/8otIPtxtCS12n/ZxMZrB1NVwDr0YONq8pK?=
 =?us-ascii?Q?6aHkFQ7WeL3Ody7n1gro2B1Yr7dUQoJ7MO3JyHcAV1sHZjH/UrNZ9RTehNdq?=
 =?us-ascii?Q?Gzk1qs1O/tG6jvtEHZ3ISfEfq6Z0NA7zfBdy10AfpdxzOGyEB7fgAZxCiern?=
 =?us-ascii?Q?c0LS2qeEqgyKHrxiB/pMWtIvZfbWCP7Jo4iet9UeilcZGCQOCZSlT2uCWGJH?=
 =?us-ascii?Q?maUiyPAdG7bpHwzu+2J994ymxtipLHQtoUqKKNfiBdDWfj0qXleJAS5Zk47Z?=
 =?us-ascii?Q?Lo42gcvJXr57je1FPtrc+aQ2NtUjcINVcdWVnvUi9A+wvEQHx40YGC8fHM04?=
 =?us-ascii?Q?TtBBqy79UE1Osv8hmc7Z45TNwmrTkhA4zfFv6gN+lg7kLJwdshnk33ZmTz9N?=
 =?us-ascii?Q?V5DffKgV4733ZVvvCZL/xeyC5cdtcA7glSnMMjflyh6vhiKToJqaQuWr8zvE?=
 =?us-ascii?Q?no4LogJaKRiyIb7CjEEH2os5D7X4s1pSYBGZCEPAdbBD4lRa41ld2xG7Cct3?=
 =?us-ascii?Q?WAJFXwM4S8mj6Qi6eKKU7FxD2trPNZwI/7njW4LDXtLOne5ZFqKZyP7wNfdW?=
 =?us-ascii?Q?UqjSBQGzoQvRyQoug+k26VmWpkkl1oz/CHjfduf6DhKavVokEQdgmRDtpeM9?=
 =?us-ascii?Q?oX6qqtFHMQ/du+5XwTvF7xnEQVNDOaKhujAvN0tM944qIYIOA5RT3n0FyF8y?=
 =?us-ascii?Q?/Zf75n6XmlBci/UaFeYRLX+ltc6pBN4I3aKowzZTEZMRS40ikyb8uvYRBnCL?=
 =?us-ascii?Q?AzPymPYOaoGdE6RouZOHkcrkKU3Ox0L/vP80vZdCkWd61firM3ZhSt5o4Mo3?=
 =?us-ascii?Q?stubHNSOvQCWr9a8pkp3WPQPlEfxcoQtajWnZ1hAvstHDFeSV1FHHuejV3dQ?=
 =?us-ascii?Q?tMVhNZ/pr6qf0zeUhKnMF1qYusfNweO0cTA8+SH8Le1RGiTc6sKwBEvDBdqE?=
 =?us-ascii?Q?dyZJg5letxtESXjmYNdR1kA4DIlUPpblypCsoCqYl78mEd9Y3NJjQuaCmDJr?=
 =?us-ascii?Q?dYxy98b8M8K+kij61EJOfw+WHDiWpUB35NW+I3khDDJ5N06FLpAawg2+JiuH?=
 =?us-ascii?Q?ZImkEyh3e5Ji59Yl45HVsBZTSSvzvYJEAfPTO4eJ+YtAvPrLxJG0sQPC/dAd?=
 =?us-ascii?Q?aB2fH3T29lDKQ+Y3dH69nmd9v6PUVT2/0Esd1LysiiLfJdzsPMFiqMFJtx5/?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfc55cb-f42c-4e28-ff0f-08daccbe4f45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 19:18:17.3280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FxVjr3myvWHnTJrzMU5ZEwrdhem7ciCfFHkmGBo4pkgw6hKCp8KuHVzzgL083EOpVyExfOB+gttag4wN8YdWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4607
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 04:04:52AM +0000, Eric Dumazet wrote:
> Quite often, NIC devices do not need dma_sync operations
> on x86_64 at least.
> 
> Indeed, when dev_is_dma_coherent(dev) is true and
> dev_use_swiotlb(dev) is false, iommu_dma_sync_single_for_cpu()
> and friends do nothing.
> 
> However, indirectly calling them when CONFIG_RETPOLINE=y
> consumes about 10% of cycles on a cpu receiving packets
> from softirq at ~100Gbit rate, as shown in [1]
> 
> Even if/when CONFIG_RETPOLINE is not set, there
> is a cost of about 3%.
> 
> This patch adds a copy of iommu_dma_ops structure,
> where sync_single_for_cpu, sync_single_for_device,
> sync_sg_for_cpu and sync_sg_for_device are unset.


Larysa from our team has found out this patch introduces also a
functional improvement for batch allocation in AF_XDP while iommmu is
turned on.
In 'xp_alloc_batch()' function there is a check if DMA needs a
synchronization. If so, batch allocation is not supported and we can
allocate only one buffer at a time.

The flag 'dma_need_sync' is being set according to the value returned by
the function 'dma_need_sync()' (from '/kernel/dma/mapping.c').
That function only checks if at least one of two DMA ops is defined:
'ops->sync_single_for_cpu' or 'ops->sync_single_for_device'.

> +static const struct dma_map_ops iommu_nosync_dma_ops = {
> +	iommu_dma_ops_common_fields
> +
> +	.sync_single_for_cpu	= NULL,
> +	.sync_single_for_device	= NULL,
> +	.sync_sg_for_cpu	= NULL,
> +	.sync_sg_for_device	= NULL,
> +};
> +#undef iommu_dma_ops_common_fields
> +
>  /*
>   * The IOMMU core code allocates the default DMA domain, which the underlying
>   * IOMMU driver needs to support via the dma-iommu layer.
> @@ -1586,7 +1612,8 @@ void iommu_setup_dma_ops(struct device *dev, u64 dma_base, u64 dma_limit)
>  	if (iommu_is_dma_domain(domain)) {
>  		if (iommu_dma_init_domain(domain, dma_base, dma_limit, dev))
>  			goto out_err;
> -		dev->dma_ops = &iommu_dma_ops;
> +		dev->dma_ops = dev_is_dma_sync_needed(dev) ?
> +				&iommu_dma_ops : &iommu_nosync_dma_ops;
>  	}
>  
>  	return;

 This code removes defining 'sync_*' DMA ops if they are not actually
 used. Thanks to that improvement the function 'dma_need_sync()' will
 always return more meaningful information if any DMA synchronization is
 actually needed for iommu.

 Together with Larysa we have applied that patch and we can confirm it
 helps for batch buffer allocation in AF_XDP ('xsk_buff_alloc_batch()'
 call) when iommu is enabled.
