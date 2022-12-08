Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79EE64704D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 14:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiLHNAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 08:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiLHNAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 08:00:08 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BA18C6AC;
        Thu,  8 Dec 2022 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670504406; x=1702040406;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=l4r+hyLj2s+fmw6P4XM9UPrAT8nv6S86Z7R2r/MXyBg=;
  b=jrfpkfRZ6RdvKAdm3ybo9lygi3GYEdqAMWhgyrnkZ7r21rQgkXPq7Nbq
   wHAe1zSvQLZhzd3w+qzymceAbbbqjRqVL3YDqzRiY0rwabrArDMPkfDJN
   Rfgbj/dsZTr6CUThFVetojJgPB6Wpj0H+VuDmlotvdsP04sd4rJFdoTB5
   nb6JHgsRlus4zK8NAxr2VFLVimNPutagmym31mqEOBunsQPpVNriZO9xr
   7/xS5TXUCxeWtY4Jq5fTp2l7+nAa6a4EMKyvsZGSBAMk1gfBSqocON3mR
   auOr4WvHHdpxCr7NKzXFV4bTDyfDxBehz+pq3oVxzyEMbXuQjIZHh04GS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="403428648"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="403428648"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 05:00:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="753549568"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="753549568"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2022 05:00:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 05:00:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 05:00:05 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 05:00:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 05:00:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTrJGOOK3siq/T6tzkUvmvsPXRXLt3I+ppxL4LO01ZQasDq6b2NhwxUEAaIVd/FG/136WcynOEyh0RnTBfKd9CcLxOYNSZRJOYYr8HK9dSw49tlO+JbKs8NLRhL7H538pMUgR0HRthVt1xu6XZWdOCJB4RbWux/Of6/m6U+vxm4/PK/f+jIXXo4KhDJV6HFOiru2LYIy3aL5fbyOxfB/Tengkpq47/lt3yGWpDiD17w/iuVbgwok+nntiSKcRwOuhaqlVb767S4D3tFVBQ6Htj3K1bDgSiumqxB37WxjgVy4nKQd8Yrw+hu8q7d6Mn7nydS1jAk5vtOOXFwEqZVksA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phexLxgH/n20uhP0O72ffa93YudiDX0oq+Rtfo88suQ=;
 b=N5jnjajSUeZCRSi0qTOrZMcdaUdAvkQ5Ud3phMQR1TgQs60qjFDdXwI+opuXR1ABiWo04Retc9q8qRPbc+7IHFq660jXSi89JWoFkgEUhZ0BPpH+etNSj0c+9pzng7Zad7HkkxesYcee8h98jZ4NjHa4t9C2r4VYa84wCBNC0GNWtyoawUoQ1hYkkINUg4WtmEso+5HpduhwgJzw/7mS3W/NN3vq0YjkC+f8dCQu5H+2FBoaKSjOA6vtNLTgAT+Yc25UuFScEeijRVlLM/7My4365cndX2tDbgg95dJC0WSDkZi4FYU6xGZurUDH64C6YICaespKqFSbmd1ulPyRRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 BL1PR11MB5238.namprd11.prod.outlook.com (2603:10b6:208:313::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 12:59:58 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 12:59:58 +0000
Date:   Thu, 8 Dec 2022 13:59:50 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next v2 5/6] tsnep: Add RX queue info for XDP support
Message-ID: <Y5HfxltuOThxi+Wf@boxer>
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-6-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221208054045.3600-6-gerhard@engleder-embedded.com>
X-ClientProxiedBy: FR3P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|BL1PR11MB5238:EE_
X-MS-Office365-Filtering-Correlation-Id: 5913f776-29ef-4a2a-dc95-08dad91c1b97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hzIWQvMI3B2cLbeAX7ch3lXHIqMoytU2pApZRDDqAfaAib/LR/jZLvfQQ6Zuw8PMlZOyRVYoZdtiDmhWePxB8qyr6uBizgzXSZmM4D2YcOaem39iJcmZEKDSdKzx8uOZM4N0U9yY1EYPNu4TWTuEg0MWDA0hNZDCfCfARypBs0AdrNt9Wx+WlrSRSYJEV0OJA+eQtyCl8sc9LSZFFfAiBddwNkzdZh9PaLsA6QKwnEFQd8FBZhayRn8xy0l8dWWA8cUOXiRA5bb7mRJnDkcDIj0EIcitqOH9Lv5Fx5qPuTgyAzV9iQwGs2u+YM+pdM4YcHI8PSoTR9n5gmXa1uNoqynn+5i2XpS1dbY41WcLDU91S1OhaTozdlcBKg7VpK7M/vKPTd6dTURlNZywqMaYBE2YMknWGHIYtGDJ8SZfKr8PovMo0ODTCOsr+p/8qo0wyqP0HbIADq0vLDHHJ0y+04P+YRPrNz8ntaa6mL9i/ivDqHCPEaDXnuviQYCVcC0bLIOsY9D9DW76HQN683h7FyV9fOMFUUneL3Foe1GQrn9DDJHkGfmuETAYrn2eRxQ3oFPDydkOnxzXlCDW7bpE9Ji2takDvmROTo2b9s4s/c228N3Ppy2K4qhzs/ZXJWqPEQ7jd2ZmS1g8HJl99bmyXdVNJYDk28H4AVtSv6pVJzbUxM2mB7IegE/cnFRbHHdi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199015)(33716001)(2906002)(86362001)(8936002)(5660300002)(44832011)(4326008)(7416002)(38100700002)(478600001)(83380400001)(6486002)(66946007)(66556008)(6916009)(82960400001)(316002)(8676002)(9686003)(41300700001)(6506007)(6512007)(186003)(6666004)(26005)(66476007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bS6COl6Uxlg8Jkx3IXrsXXGy5QN9TzQ0BYL0MU6fgShxkRHrziSBXZdy/AgU?=
 =?us-ascii?Q?II7+dAyNMQnBsu00YEEZCCujt88H8SKBjvHQyphHDkA+XEzmWFS6h4wwDmvU?=
 =?us-ascii?Q?qWkFcjrGoFvQzr17kZRMQjC5DVtGujSeGv15qa4eZxo5lhetIbZ0tyNfTT+s?=
 =?us-ascii?Q?kylx/malURNITCEdLvNBhMTSYtL9UmroDn2yGH/fQlXNwjZsDJV8M1Knkiq9?=
 =?us-ascii?Q?leQHr2oXvqoSF1mCMXvW1g0055STgp4CmH3noh2FHlvFoVbV6jZDv4+DN9Nf?=
 =?us-ascii?Q?BWWSAajMMkjdCG1PyUwXyr4p/5iL1+ZIbZ6GlMEsgS3PrtrF3jPzVnOxhrU2?=
 =?us-ascii?Q?eYwRFH7P3KmKPdudvMeE4qlmQWck4a8hoJoMEDG7zmOFrhFuonwjgGOUCRAj?=
 =?us-ascii?Q?1v8OpfquWpLE3R++lgOEA/cBafAx2UU8PdsimXEkUjNiDzMBum3M0XtdS1d6?=
 =?us-ascii?Q?mvl22Q7rEXm1LTroosqNhr0gXH5MWOrM0vMmE52vwFGUQ6HUyxJe0XQno8Ug?=
 =?us-ascii?Q?4szu1MTu2Yc0D11sL4NMCX6CnXxD3BCEM7JzNPETsEiPUXnlSMzt/4Zw5Pei?=
 =?us-ascii?Q?DK2S79JBl5BsRcB+5dKZSp04qv2FPqoSd7309v9lOjBPy8C97IkDE6m+auNQ?=
 =?us-ascii?Q?M8z+oolc/5EYvkYA/y0zdQHMCV3PFp8W5CpHvPM4W7St3qnGkG2WAxwvMUUi?=
 =?us-ascii?Q?QxiY8ocNSHeHIMTmP9yNv+U1oU0TmLa6lfFd34zV1eHW3+e1gnfFTlatjoIW?=
 =?us-ascii?Q?9obOH5fP7MR3lAAZ+/4/6nOlvwvc597Ib1MVp9p+pQ0YOfeEpyOlMNNgforb?=
 =?us-ascii?Q?q/z02d++dN9KlIQrreaYvg1+JmlZ1oxS7QrsoHdHKYfSQb1PW5Sqf/VxMNbJ?=
 =?us-ascii?Q?mGLnDm2j4kjAyzbCWOw/LKoPBJjgHhHmbVpu46tRuUC4sHoIVj2ZQ989gSEL?=
 =?us-ascii?Q?kbSywYagruIDzUM2yNKXpF6GPM03ny1sfJMlQd/6OihKxj//f0IzJHibTkf6?=
 =?us-ascii?Q?xIhRELsMNvOuXqQ798HKWrp+PEOcURRuvX67P0HacIjeUSAJcfI73oHcz9pR?=
 =?us-ascii?Q?id6pE9Lp741YHpA/ZDRFgqXQZ+pucyrSYtEYIJ0fu1qpcO/yl6A2ynhKY/7N?=
 =?us-ascii?Q?Iad7OCRf/KP52Bi3LnKBExX84klAQlEmxeLQW8ANaKFK0RR5kHgudUKYD3G7?=
 =?us-ascii?Q?Y7ekHEhrunRiLA/3eqfYKrxTr+3R1JiotWrmm1dQA1DR5FvAGNwlyAbN4U61?=
 =?us-ascii?Q?7vGdW6WdFJCvWp+TGNxIE3E4ycLc4be6Jq4yCD2etZbkQ+k669suVUwaxBYB?=
 =?us-ascii?Q?uJdfSyYAI7xqXzyfP7BXVG83YnjFt1avhule3HtY1JWUejmU+TKA3EPgtdXv?=
 =?us-ascii?Q?TfTJGSmsGBOForXoTI7OIKeX/FsXcxmwJi9MfyBJiBgqKoZ2fxcw+VqyHf+6?=
 =?us-ascii?Q?9Jniqvmlk0tamJmAa2QYCnlkFhJCIVwACciOTJs6dx60f6FV1fcKPeSyo/Zm?=
 =?us-ascii?Q?Jh0kaEXS5EKGIzjg/TXtyy9O1JxJ5NatMD5JLvu4xkktI8jRFHWiDY9p78jg?=
 =?us-ascii?Q?SPepw05JeZxdq75QNlp9ngMFIDzMJinv8XR+EcqQagz0ikbZi+56cQVxJJBH?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5913f776-29ef-4a2a-dc95-08dad91c1b97
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 12:59:57.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vz9Rx/xn54e/j2krx36kbmuXFCcYu+zZMC/uc1dJi8jBFe6SMHT3IaSnLP3LldONAhNxHKlTKVRkOoLAug+OHT+REkzjssZPh9JXooUEPdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5238
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 06:40:44AM +0100, Gerhard Engleder wrote:
> Register xdp_rxq_info with page_pool memory model. This is needed for
> XDP buffer handling.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep.h      |  5 ++--
>  drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
>  2 files changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
> index 0e7fc36a64e1..70bc133d4a9d 100644
> --- a/drivers/net/ethernet/engleder/tsnep.h
> +++ b/drivers/net/ethernet/engleder/tsnep.h
> @@ -127,6 +127,7 @@ struct tsnep_rx {
>  	u32 owner_counter;
>  	int increment_owner_counter;
>  	struct page_pool *page_pool;
> +	struct xdp_rxq_info xdp_rxq;

this occupies full cacheline, did you make sure that you don't break
tsnep_rx layout with having xdp_rxq_info in the middle of the way?

>  
>  	u32 packets;
>  	u32 bytes;
> @@ -139,11 +140,11 @@ struct tsnep_queue {
>  	struct tsnep_adapter *adapter;
>  	char name[IFNAMSIZ + 9];
>  
> +	struct napi_struct napi;
> +
>  	struct tsnep_tx *tx;
>  	struct tsnep_rx *rx;
>  
> -	struct napi_struct napi;

why this move?

> -
>  	int irq;
>  	u32 irq_mask;
>  	void __iomem *irq_delay_addr;
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index ebfc08c1c46d..2b662a98b62a 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -806,6 +806,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>  		entry->page = NULL;
>  	}
>  
> +	if (xdp_rxq_info_is_reg(&rx->xdp_rxq))
> +		xdp_rxq_info_unreg(&rx->xdp_rxq);
> +
>  	if (rx->page_pool)
>  		page_pool_destroy(rx->page_pool);
>  
> @@ -821,7 +824,7 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>  	}
>  }
>  
> -static int tsnep_rx_ring_init(struct tsnep_rx *rx)
> +static int tsnep_rx_ring_init(struct tsnep_rx *rx, unsigned int napi_id)
>  {
>  	struct device *dmadev = rx->adapter->dmadev;
>  	struct tsnep_rx_entry *entry;
> @@ -864,6 +867,15 @@ static int tsnep_rx_ring_init(struct tsnep_rx *rx)
>  		goto failed;
>  	}
>  
> +	retval = xdp_rxq_info_reg(&rx->xdp_rxq, rx->adapter->netdev,
> +				  rx->queue_index, napi_id);
> +	if (retval)
> +		goto failed;
> +	retval = xdp_rxq_info_reg_mem_model(&rx->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					    rx->page_pool);
> +	if (retval)
> +		goto failed;
> +
>  	for (i = 0; i < TSNEP_RING_SIZE; i++) {
>  		entry = &rx->entry[i];
>  		next_entry = &rx->entry[(i + 1) % TSNEP_RING_SIZE];
> @@ -1112,7 +1124,8 @@ static bool tsnep_rx_pending(struct tsnep_rx *rx)
>  }
>  
>  static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
> -			 int queue_index, struct tsnep_rx *rx)
> +			 unsigned int napi_id, int queue_index,
> +			 struct tsnep_rx *rx)
>  {
>  	dma_addr_t dma;
>  	int retval;
> @@ -1122,7 +1135,7 @@ static int tsnep_rx_open(struct tsnep_adapter *adapter, void __iomem *addr,
>  	rx->addr = addr;
>  	rx->queue_index = queue_index;
>  
> -	retval = tsnep_rx_ring_init(rx);
> +	retval = tsnep_rx_ring_init(rx, napi_id);
>  	if (retval)
>  		return retval;
>  
> @@ -1250,6 +1263,7 @@ int tsnep_netdev_open(struct net_device *netdev)
>  {
>  	struct tsnep_adapter *adapter = netdev_priv(netdev);
>  	int i;
> +	unsigned int napi_id;
>  	void __iomem *addr;
>  	int tx_queue_index = 0;
>  	int rx_queue_index = 0;
> @@ -1257,6 +1271,11 @@ int tsnep_netdev_open(struct net_device *netdev)
>  
>  	for (i = 0; i < adapter->num_queues; i++) {
>  		adapter->queue[i].adapter = adapter;
> +
> +		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
> +			       tsnep_poll);
> +		napi_id = adapter->queue[i].napi.napi_id;
> +
>  		if (adapter->queue[i].tx) {
>  			addr = adapter->addr + TSNEP_QUEUE(tx_queue_index);
>  			retval = tsnep_tx_open(adapter, addr, tx_queue_index,
> @@ -1267,7 +1286,7 @@ int tsnep_netdev_open(struct net_device *netdev)
>  		}
>  		if (adapter->queue[i].rx) {
>  			addr = adapter->addr + TSNEP_QUEUE(rx_queue_index);
> -			retval = tsnep_rx_open(adapter, addr,
> +			retval = tsnep_rx_open(adapter, addr, napi_id,
>  					       rx_queue_index,
>  					       adapter->queue[i].rx);
>  			if (retval)
> @@ -1299,8 +1318,6 @@ int tsnep_netdev_open(struct net_device *netdev)
>  		goto phy_failed;
>  
>  	for (i = 0; i < adapter->num_queues; i++) {
> -		netif_napi_add(adapter->netdev, &adapter->queue[i].napi,
> -			       tsnep_poll);
>  		napi_enable(&adapter->queue[i].napi);
>  
>  		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
> @@ -1321,6 +1338,8 @@ int tsnep_netdev_open(struct net_device *netdev)
>  			tsnep_rx_close(adapter->queue[i].rx);
>  		if (adapter->queue[i].tx)
>  			tsnep_tx_close(adapter->queue[i].tx);
> +
> +		netif_napi_del(&adapter->queue[i].napi);
>  	}
>  	return retval;
>  }
> @@ -1339,7 +1358,6 @@ int tsnep_netdev_close(struct net_device *netdev)
>  		tsnep_disable_irq(adapter, adapter->queue[i].irq_mask);
>  
>  		napi_disable(&adapter->queue[i].napi);
> -		netif_napi_del(&adapter->queue[i].napi);
>  
>  		tsnep_free_irq(&adapter->queue[i], i == 0);
>  
> @@ -1347,6 +1365,8 @@ int tsnep_netdev_close(struct net_device *netdev)
>  			tsnep_rx_close(adapter->queue[i].rx);
>  		if (adapter->queue[i].tx)
>  			tsnep_tx_close(adapter->queue[i].tx);
> +
> +		netif_napi_del(&adapter->queue[i].napi);
>  	}
>  
>  	return 0;
> -- 
> 2.30.2
> 
