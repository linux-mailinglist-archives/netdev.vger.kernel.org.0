Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADEC59112C
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 15:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbiHLNGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 09:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiHLNGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 09:06:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18E032B89;
        Fri, 12 Aug 2022 06:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660309590; x=1691845590;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OQhcGXbYHLTGGRO+1NpIc+8HIaSitLcsyEX6Y49W6jI=;
  b=FKSukcIzZS1GCuKtb0q0VKLw1LM7zGTm1SesjQLqCiT00lZ1h24ZHiMu
   Fy++qpIXDY+U76UfVywFwEau2gigvuHB/IU2UwIKvzJmWXQiUWBLE5hq5
   Rcm1LBsvF4BM+Z9AG9akeHNJcvPPgXDSDTM2Zv7eGUoAE5oAsYrog7gpd
   sgJ5F2y0sMie3zur7lf4xh2Z+JP+C1C1BcbCQyA9/ysAtwk13NudggI4n
   jDGw+JG5SeqSQVNU4dAQR6FI+8Dg+Xi0pLeebgVnLTkco3/lgtlikTwkE
   Wix5P3Qi45vWS63wATYywEW2nlZuQt4WiKzvJ85Nv4V9ma6z3bmTwzxBQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="289160297"
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="289160297"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 06:06:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="665817714"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2022 06:06:28 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 12 Aug 2022 06:06:28 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 12 Aug 2022 06:06:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 12 Aug 2022 06:06:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 12 Aug 2022 06:06:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQwZixNT5Dj+jGY0V3RaAU3I62Tq1bruxoOWESlURAYZwwPajH3XyYZwAWjOxdxkO2i3isRphord187hD9GH2GzpDyKwlcKSXmc6WBQ+VFqsEeivvro0nRu+LFRlU/BQ6SmJHnFEfTX4aH8uD4e2miu6Nh5/GvULwAuT5OzjnLlM4GduAB5h0u5AThLpQitPmDXD33E2eRRpAN6J+mLGwVnLDUxJQM7BXhOHjEQCifQfwqWgfr1BSnAOlneijxdh7mY8jn6c2wyAJaA0dDRmm7d26zGx7oIjqYqSOMsKpsa1m8yxOsCppj9D4kPZp8Dj8dlW+nUcQYxtrSsiaWnY2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L670zAzBYTI8QBb4yeSYSb5QyBHNbGlodjKwLMJKyJ8=;
 b=Ds23oM9fxql90kmpxMHIf6SrnTXBYczag0RBBWUaBkjMO2KEBkm/Kyu88uUqcG3tGlLc2SWXK3EplLHBEAuNZVElk8YpevZKLbjQ31AdufYTrMYFwUtf/3TZFo5V06sIrQHdnqTIF4RjUreFuvC+Zfk3K1bEFwQHQPYhfgJHmLsQ+6RobB1mHV5fWPWaDkarPRp+NxKDj0S2gKICAQvoHTi2bPS9fwxG5kBSR2EYJy8Q9fw30EveFrlg0gswMugIpiAMtXrrH/ZrsWWeb873XLjOLfV0251cYeK4MnCZa+AYyfaz9Jbnn63LeY4KhZuJqugVq3wdUlHnnXAXcNKJ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5351.namprd11.prod.outlook.com (2603:10b6:208:318::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.10; Fri, 12 Aug 2022 13:06:25 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5876:103b:22ca:39b7%4]) with mapi id 15.20.5525.011; Fri, 12 Aug 2022
 13:06:25 +0000
Date:   Fri, 12 Aug 2022 15:06:12 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     <magnus.karlsson@intel.com>, <bjorn@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <jonathan.lemon@gmail.com>, <bpf@vger.kernel.org>,
        Alasdair McWilliam <alasdair.mcwilliam@outlook.com>,
        Intrusion Shield Team <dnevil@intrusion.com>
Subject: Re: [PATCH bpf] xsk: fix corrupted packets for XDP_SHARED_UMEM
Message-ID: <YvZQRKcEO6JsyDfa@boxer>
References: <20220812113259.531-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220812113259.531-1-magnus.karlsson@gmail.com>
X-ClientProxiedBy: AM6P194CA0108.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::49) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d589ddc-9640-455d-0546-08da7c63762c
X-MS-TrafficTypeDiagnostic: BL1PR11MB5351:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ZKdQ1AdXzEjQ/haN9836VtzI/4xX63S04it9+72En6w4tqRub5CKRGq8y1hgIQWmAMElV2ocOnTvtHeXsTdMjzQQqUGT4z+4TVM6vvvxBxkhxDi/SYVOb1HcnnTLwzxJTb8yjblYdy8KZxvQdwAQ2lhC1Ti/S6q3xV7320lhbA7eX9r2f1daEjSzaNYJbTFo+8u8sh0FtqR7H7Gd3lyMBnCI27sc6bLHDBUrQqwT/OWO/pCARnfIXB5bQRPnHfqwXXU8m/G9a7CQM0ZJUZg4fAjz4Rw25fmYix4hwWnznpxq0TcCkDa5MAYlrdgIIBo6uxiQ7KX1s3yJVX/ZIGd880bfnE4LZ4bVksb3o9V9BrzMGjOQ80c10Q2Zf3C1Mhnkn+ZlDAP4+tf0xt/dFM9wkKMUdjqk69McL8c01MK+7XSXqc/EtDwQuOMp1TZ7Cab1MdFRMLApyMvTsWrCvjylseQPVL0zze6jZ0rto2BkjajnAyeK+TI09vOI42QDUNDMQIcGEmEksYbW9MaOG0Ycsh5r7ZyAYmz21nbroYZCUoTyVnx18j/+wZIMlevPJ+4YsZJSOvY2A0i5s24DJdzBkHrbpeuwhX3u6MWFMGiZyDZOQB+dpOzyeJtycMEoj2laLNhx02HRGliPi2r9QwVxHiOr3/zRNZuQ/mE8pnYWeBUVfKuuO4JCKPvwvLQyKqjtk3u+uSaREsPF4HEN5mojBsn4ydMpepVgGREU1DpmneTTDEgDmHRLMoM4wA3TuUObLzARRtVq0NEGoy6tkCqWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(39860400002)(376002)(136003)(366004)(346002)(33716001)(316002)(41300700001)(82960400001)(66946007)(66556008)(66476007)(2906002)(6666004)(6506007)(8676002)(4326008)(26005)(38100700002)(6512007)(9686003)(44832011)(5660300002)(186003)(45080400002)(83380400001)(478600001)(54906003)(8936002)(86362001)(966005)(6916009)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y/c7tAyZaKsdViF/45WeQ1G1EavIE6hBvpgz2scI3n8gaOVDxOv2xUE7vFBj?=
 =?us-ascii?Q?fHyxk21FXhF/JU0iPIqVOoGw0HIbJbEqdargphSW+TGWvioy8uLpvRzPJh3z?=
 =?us-ascii?Q?neF/XvRao1NddHhlA+xFmLf6rUb7VeAGUC8A5Yn+I5JmO/Xma7Lq6SiQPone?=
 =?us-ascii?Q?oIj+quwnF5PZ4a8PQR1BLwDczwNDGsHw0kAmtrr4JvrtnZ1Vi8FTx9bzEpn2?=
 =?us-ascii?Q?b7IyBhTvDbEMeiIQU4DFWTGuEsyZzMbjWPisa6fTnizu5KgTdxzvnaUVUE4T?=
 =?us-ascii?Q?+GBEks5BWqU/o2Y45m7Az8BOcTIJyEwD9QhpSxDVWKQaGdUfA3RI9DQmzwYJ?=
 =?us-ascii?Q?ynRoH1yw4a4z6XoRGPcx/cKNGej9SA6uijtuBXVgXZEZjJwKi+lJDmQmK3TN?=
 =?us-ascii?Q?lDLKOXh95gEVk9nQ6grNIMbXdyiJLeMF8vqtlaIfy0CzAQJbb0rywZMR7CAb?=
 =?us-ascii?Q?m4JZ6ieeie8yAXZq9998uUfSGekN8xT4Wz+r5/JQlqh3q41skPoTRFv21I6p?=
 =?us-ascii?Q?BDTSjPD9rbyft1jl+Ln1IbUbx/yOjqXWLLJlSB59JcQsBwWY5CrSghUguXJx?=
 =?us-ascii?Q?rnOyzkpTttjF04oeXFao0VhSHMblShu2nohrT43Ss0EsHKMM4AfUL86XFo/e?=
 =?us-ascii?Q?twRo40Jk5DJeHTqCMcBnH9fJvl4eUHS4RYRhzcZkjw+Goi3E0AZlIexMiumb?=
 =?us-ascii?Q?8MJBfl24jkBo5wseybqrdWm0VhqvvrdByAEyzwMnpVz+EV+qid3j7KjFY7MK?=
 =?us-ascii?Q?kLdTOudPSpMUCS0hgeFyTB0iVzjwWHd3r8KoPMVtuc9o1NZ8WunSQQIwceWg?=
 =?us-ascii?Q?LlWhjLom8H5cOKicn8wU8tCVeRalvfKQZYh1hSuqjt5MaqnamSV1P8wCWxZE?=
 =?us-ascii?Q?8nbSoAu2MgmUtF6HLQ+SxnxW06SleVrZTpxOR8AJXdZMv4yCpnCa8mjm1I90?=
 =?us-ascii?Q?+kIPQbnotalv7up/UyutSqUPsu56F/m9Ne8IqYjlFPWfuF/Bg9scDOpblfYn?=
 =?us-ascii?Q?rPhFl8gSAgohWf8A51XgC9etn5NzG3eAKtYAm1Tinexy7DZpiFX88P/4eiO+?=
 =?us-ascii?Q?UkIiYJVUTeNTTgqe1nvFQf07fqXlmiZsegELnYWFGU3Vw4zoiDEjOUmcHdMb?=
 =?us-ascii?Q?5rDh2abioxR8uLhs/4zTp4XDgly8tz7tCoBgBIdNOsshs7SdOjtA/txbVwVx?=
 =?us-ascii?Q?sKLXtsmzKH0aKG6h/LwLmBRkObBUErM3uMDwUBKx16ukmurwnlu4jZODHcy2?=
 =?us-ascii?Q?jYbeo81qLWaSDWp2pU/7r60S0n2jjEwdAL5Jmy9Nf8up/9Q+CTqngyQM+q0j?=
 =?us-ascii?Q?vL1+Vl+snEC3l+HEYLbY+OL2UoLBGPJCSqDXMI/VHUlu0+VUOdIZw8ASuYAd?=
 =?us-ascii?Q?isL3K9T7XMl5d64vcmteZqxwRL9q3j4t+BVR7zsTvtGIRZbQzmrvLqmlNBFl?=
 =?us-ascii?Q?LSBRUbEDC81HZJIZx2wxHvTpB+m2leB4dl2pBEvjwWmADdyKjKPhplvjopsn?=
 =?us-ascii?Q?2WcGuG5dBYn/7HWIwvtagr6YGmE7Tkld2sYwa2UlnrvjkG5b+YTJBfYjFJaw?=
 =?us-ascii?Q?7WDR0rl0z2TxYA8Rzg4omHG8K2Z8kPrF/SRsu26SxgIEb69RodXQhBj5wybP?=
 =?us-ascii?Q?sreFcnZgM4pR8fxwOen/Mj4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d589ddc-9640-455d-0546-08da7c63762c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 13:06:25.4111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKRjEHT6yse1Wt3e6M2cyGzSGOfP5XrVniUOHOxHiRgS5uOuBuWYoyEP9vHVjd3lL6CO6AjRMZkgxwTqP9SVczUKIJkdcEY8PtacFKPeeuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 01:32:59PM +0200, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix an issue in XDP_SHARED_UMEM mode together with aligned mode were

s/were/where

> packets are corrupted for the second and any further sockets bound to
> the same umem. In other words, this does not affect the first socket
> bound to the umem. The culprit for this bug is that the initialization
> of the DMA addresses for the pre-populated xsk buffer pool entries was
> not performed for any socket but the first one bound to the umem. Only
> the linear array of DMA addresses was populated. Fix this by
> populating the DMA addresses in the xsk buffer pool for every socket
> bound to the same umem.
> 
> Fixes: 94033cd8e73b8 ("xsk: Optimize for aligned case")
> Reported-by: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
> Reported-by: Intrusion Shield Team <dnevil@intrusion.com>
> Tested-by: Alasdair McWilliam <alasdair.mcwilliam@outlook.com>
> Link: https://lore.kernel.org/xdp-newbies/6205E10C-292E-4995-9D10-409649354226@outlook.com/
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  net/xdp/xsk_buff_pool.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index f70112176b7c..a71a8c6edf55 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -379,6 +379,16 @@ static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
>  
>  static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
>  {
> +	if (!pool->unaligned) {
> +		u32 i;
> +
> +		for (i = 0; i < pool->heads_cnt; i++) {
> +			struct xdp_buff_xsk *xskb = &pool->heads[i];
> +
> +			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);

I wondered if it would be better to move it to the end of func and use
pool->dma_pages, but it probably doesn't matter in the end.

Great catch!
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> +		}
> +	}
> +
>  	pool->dma_pages = kvcalloc(dma_map->dma_pages_cnt, sizeof(*pool->dma_pages), GFP_KERNEL);
>  	if (!pool->dma_pages)
>  		return -ENOMEM;
> @@ -428,12 +438,6 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>  
>  	if (pool->unaligned)
>  		xp_check_dma_contiguity(dma_map);
> -	else
> -		for (i = 0; i < pool->heads_cnt; i++) {
> -			struct xdp_buff_xsk *xskb = &pool->heads[i];
> -
> -			xp_init_xskb_dma(xskb, pool, dma_map->dma_pages, xskb->orig_addr);
> -		}
>  
>  	err = xp_init_dma_info(pool, dma_map);
>  	if (err) {
> 
> base-commit: 4e4588f1c4d2e67c993208f0550ef3fae33abce4
> -- 
> 2.34.1
> 
