Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9BD6EABC0
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbjDUNgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjDUNgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:36:03 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BA3E6B;
        Fri, 21 Apr 2023 06:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682084162; x=1713620162;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zf1MUQu1TV5ZdqwNqDZuluCCIpLkRf3GKXcIf2elivU=;
  b=de6ng3svoT6QSa19R3VKaVzzTg5RWvqMpBNK6/2iZZh2KZXuk54aNYRC
   x5X1v2YGQMcr3B/CWmEl5ECDq2wa8jVjYxl/p53FAqNazrqtFEtr0qnTl
   ivGOUT3piJWNOS3tAR2fi08redmLjX4h28Qxcbrk52/Fal3Gd5Narfok7
   3XaV8WZVM0r2SBKFfdA9zwFa/ZqsC/sle1sfMoB6ycEfKkjYvDwukphL5
   Ij/7okHBxaNvVcJxi0FcAQfp3VCRhpf75Bo/B8uG7kcGj8gOOg2zEvplR
   kEEKgEJXpFvao+WoofBz/P65KA57ZEWush2+GK0rn2qqHpOs4iIbvy2AH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="325592542"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="325592542"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 06:36:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="722742612"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722742612"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 21 Apr 2023 06:36:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 06:36:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 21 Apr 2023 06:36:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 21 Apr 2023 06:36:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 21 Apr 2023 06:36:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcR5gq/ylQX6lMc1KVJNCbmJetqg7KOIARZWhTzbILv8cEQhj+GPKWgTTxD8K3ppA/AgOGaaKSRZ7qci4LBVeVif/E7PHt8iyQKr0i4kR67w2kvYcRQ5mGrCburPpBpXnUwwY1H6K2gigi9enzKToa/INAdVIuV7zBSZzIVfyis+oValfsa/JO/xrhArKcJd+mDSKDtv0yXEvD3JnQT09y3w7OYsMHA8UPQJ3Brqz0es49pJXPmXQvl5U/0YtLkn0Q/1eX2KiKpqsypIcRatE3CcobnzQXnflgZVkIJXT5cIZS+v/VWzXNcQrVRk1rxvk3OySVBeEuBTm5lYTRoNeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wm0/VGSo0RKT4qkZGgtlMYJI95zmhsecUF1dn8t41Ls=;
 b=lFSnZCaWM6V3cYMA/5B51hrYAPBMfPHqiOj07FE7rRxM/0JMibDBb3QTFwb2G7DT5W/Sa483aAAqkyLMd/Ix5l4h+wW5IrWgH4pwBuHu3ste7zvBJ/DQ02ht5JuJL9aTISo5w56CdXAwPPt7dnuYgOB5hWk1HJTuhHOZLqabYRMnydV/RXYOEpVLRp5enuiwkcWANUZtm2Vv4tCoQaf/TB/C1BWs1R2s+9RlRXpHuTSnfgi2koTEiHiELCmRu9gRX4xQ3NcDaaVU3VqcrMoaqIwpoEcQp3rkKj4x2bJDIItQ16CBdfi/9hu8vw+8Mb7/3mzciZd8pLMRrMp3tlqsFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB6837.namprd11.prod.outlook.com (2603:10b6:303:221::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 13:35:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 13:35:58 +0000
Message-ID: <714b6bd0-014f-a5ab-af02-d4d9e4390454@intel.com>
Date:   Fri, 21 Apr 2023 15:34:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2] lan966x: Don't use xdp_frame when action is
 XDP_TX
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <alexandr.lobakin@intel.com>,
        <maciej.fijalkowski@intel.com>
References: <20230421131422.3530159-1-horatiu.vultur@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230421131422.3530159-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: 09b1e13a-7cec-41a6-004c-08db426d56bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hg+y2kF+g9FuOK6QYTYbXU/I5D9DyZj/+FVMPJcfN4o0HuCZm4T3wKEwvb460c6wJ/uO+TWbGR7v3OPFkPbCgcYS7Kk0MvIGCcCAOHQ2a6NYDzw5fnN6hheIYC5UeQSiyFvCibjsQOO7kmL2MTmlmaYLLIYQgZzedWp/zUvt4hXbH1lfvenjpqDBZnn5UYx8RpFBWUXVSfa2ZpZ8yiuEVvOXTDvFg4537C1YhjvVQSLeCXPb6bY53XxVU2FTzB6WExjMGAG4ncy07CW4nUSfNGZJxKbYn6PPVnTt13sXOlMPFpv+Ay2LX+7ke1mGU1RLCK9Cetrvf/dloSiLVBeSirnrYjP7J63GBl2Nw/RhM4ZcGwsauxucC7UYaaaYLodby8lkVHoimQsaqFWy7SV2CfFgGbzVE81G8ziqYQVzC1qxZotI+epdqm8KojolXta/EhZcC4d0FAmm0lsx+99Wjdwk4pl6FlW2yStkLH8FLUijaibZf7icDRaYJlQ0UvQXWBJdR+gtp6+Xo1aJF/kKbDm5+iyzqJD/o97u/DybqCu59oUbNTi0RUlKaH7p4ir0u+kaMHQ4sT5ug7ID5UO8pQtND5uLRD9TAWblsA9RIy+nKKEHBUfAvxHg9z90h/YOCXdiNVZd6bhZVDpPhbsvkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199021)(4326008)(66476007)(6916009)(316002)(66946007)(66556008)(478600001)(6666004)(6486002)(8936002)(41300700001)(8676002)(5660300002)(2906002)(7416002)(86362001)(82960400001)(31696002)(36756003)(38100700002)(2616005)(6512007)(6506007)(26005)(186003)(107886003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGNpM2FDRnhtZHhTeUJBOW1DenNvYXhacVZwYXltVXg4cXpqU1dBWFJPakhB?=
 =?utf-8?B?S0YzWVE1ZElPYWQ4b0ZuUmU3N1NQdFIzRnpBL2wvSEk4a29aUXV2NGpRSmVz?=
 =?utf-8?B?YlBqL0p6YWNJTWE4ZmlSQVdYWU92MTc4Mmgwbkt0UUpRbUkxR0tRbEk4U2Ra?=
 =?utf-8?B?U0hiUWJuZWZ1am1lZ3BBYjhPY2haRHlZNytIdVlnWmFPektZVWUwV2dLbmNz?=
 =?utf-8?B?dGJoRVJjTlBpZ1lwODljZVZFZm5kNitia29OWllRWjhaaStKWXVhVm9jY21v?=
 =?utf-8?B?UmhhQUxicWo2blRvZlNUMWlOenBGdTc5cGphMENHSFBzSVRpaWVPTkFESXVp?=
 =?utf-8?B?U09pd3NETzY1UFFKLzJpek55aEdkcXpVMStPYzFjUTFiQlpzTWkzNXFFWlJr?=
 =?utf-8?B?bzh6eXo3Q20vTlpsUHlxNWtvazR6cEs4cUJoVlJibUljVG5UbDJ0QVR6cmxP?=
 =?utf-8?B?aGU0WHRrYkU3NXJ3SFViL3c2K3pLbmF4WTlFczVjN1ZQQTZoNUF3Q2xMZnp0?=
 =?utf-8?B?NytjcWVwaHAvdENVWktIZHNpRHNiOUxxbkpqL0RoZ2NaamlSV09DN2IxOEFi?=
 =?utf-8?B?WG9GOVRMS295WHNYUVUyNkk0Q3Z4UThtN1dMNFlOMXpyUjdzL09FS3ovRERR?=
 =?utf-8?B?ajlHMHZscThJUzVucklPd2hTZld6Z09XTFdDVFRvWkl1R3ZncVNaQmRBOWs2?=
 =?utf-8?B?WFZNV2hVYk5LNDE1YW9tZ2lSSWFyQURIMTExQzAxL3N5Mm1nTHB1dndJWnVZ?=
 =?utf-8?B?enpQNkVXaGo1SXR6NmllR3o5Y0ZSZ0thMGcxZXhUV0dNQlNOTExCVjdjQWhS?=
 =?utf-8?B?MGFGRVlydjUxYVp5c2k0QXh4VnZtTGxhcEQxeU1BUlFOY004bW1QeGplZFNv?=
 =?utf-8?B?VkZ5c2h0eUcwQUw0cXQyVkdYcDFNdTZiL3RiaGFhLytSQWxrbk40ZkxBQXdp?=
 =?utf-8?B?V05GejlnbnlaR1RSWm1XeDJhajV5WlJkMk11TUZQUWczUFNhajZ1Zll4Qzc1?=
 =?utf-8?B?akpBcjl3N2R2dHdNajlJZmZRSzBtQ3IrcjNKdUFRYXZmYVZXMnB2OTJBNmR4?=
 =?utf-8?B?cmNWNW50NnlMQ3kyQTQyTGJaQnd0anNEengrQ2ZvemxucUwxNnRxZ3p1dWc2?=
 =?utf-8?B?RTNOM3hZUnhZbWw5bXVZMVJqR0luTUdDN0tVc1B0bnh1NHJjeGcrNlJEcFRD?=
 =?utf-8?B?d3lGdTJmQW1qK0lVRW1BbVdGVVhBVVM5ajRhcHBpazhiZkNKdmZqNk85NnVQ?=
 =?utf-8?B?Vm43MSthUVpTQk50akpiRW1DT1pYTEYxai9LVDBOdFdqYWhFOHNaaTFyNW5I?=
 =?utf-8?B?NkZYSVBYQzVGc1lIRVUvaU93L1hFYWhTNldlaXBTMEU0ejV3Z0JiWGJmMWgw?=
 =?utf-8?B?aHVLc3ZkS3Z1THZQSnRTL3I2Qm1ZTWpwYXYzWDJaYkVudFMrUk92ZXNiUUh0?=
 =?utf-8?B?MHRwU1hPU1NrcG93emhFS05ITFFGRlVmcWNQcmxieTFhVWROL284QUczYUl4?=
 =?utf-8?B?WDUvMzhhdjFlMzZIbm9rdzVVZG9IUGthMUdMWUFicUhSYjJIcnRPSE5ML0tR?=
 =?utf-8?B?bjVrdG5rOStWQW5GcEcyaithelhrZ1AyaittZUs2ZkJRYkJMVUkwMUFFQlQ2?=
 =?utf-8?B?SStVU000am41R2hDenJwZ2NkdmhLMTdjZVlINWVBZnMvQ2h2a3JwdjNIaC9K?=
 =?utf-8?B?ZHJLRk80ZWtqeFpmOFlJS2Iyd1QrUmhoMUdCK0JhWmt3dGU0L1lmSjFGYXZY?=
 =?utf-8?B?Y0ZCOExVMTFrUVY1VnRVTWJXbzZIMFpYSjhNZEVBTm9IK2RXbVJhN2tMdXp4?=
 =?utf-8?B?em44N2NPNDlubWViY1dPTjdnUVliMGl2NnhqWFRHOGZIcnA4RU1rSEtyYWdL?=
 =?utf-8?B?WnlNT2lEdHhuQy9hYnVuQVJxeGROQkl3bXEvZkhtZ2p0dVRESFpjQTZlV0dV?=
 =?utf-8?B?QUM3RnYrUkNwOHJSSTdkb0JMajRrME1EOWVVa00vdHNycDJ3R3RxTlQ3dHI0?=
 =?utf-8?B?bTZJWEhXblN3MlVnOUlBYklFNVNhbk9HTlBkZ2NJOStiaVVNWU5VL3JQUGxy?=
 =?utf-8?B?a1lKcEpYaTQvdis3d0FiWGJSSFNuTTNDNzc2cE5LMlBPR0RvdWN2TkNCbHZv?=
 =?utf-8?B?L1lkWTVMMHJ2L0pmcW1hRWtlRzJrNFlNWDVOSUd4S3Q2THc0UzFZZUl6aTA2?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b1e13a-7cec-41a6-004c-08db426d56bd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 13:35:58.0868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/VcM3TQFzFQ9WSyN7u84wL+TYBbuS+9+NJn38ABRXt5wLZHmz0hpUV2IKZUZ2YPB9A7DaBEbbtUKHJWMJIaXMDmnydM3Cazq5Uo0+CWFGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6837
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Fri, 21 Apr 2023 15:14:22 +0200

> When the action of an xdp program was XDP_TX, lan966x was creating
> a xdp_frame and use this one to send the frame back. But it is also
> possible to send back the frame without needing a xdp_frame, because
> it is possible to send it back using the page.
> And then once the frame is transmitted is possible to use directly
> page_pool_recycle_direct as lan966x is using page pools.
> This would save some CPU usage on this path, which results in higher
> number of transmitted frames. Bellow are the statistics:
> Frame size:    Improvement:
> 64                ~8%
> 256              ~11%
> 512               ~8%

Nice bump, esp. for 256 }:>

> 1000              ~0%
> 1500              ~0%

[...]

> @@ -699,15 +701,14 @@ static void lan966x_fdma_tx_start(struct lan966x_tx *tx, int next_to_use)
>  	tx->last_in_use = next_to_use;
>  }
>  
> -int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
> -			   struct xdp_frame *xdpf,
> -			   struct page *page,
> -			   bool dma_map)
> +int lan966x_fdma_xmit_xdpf(struct lan966x_port *port, void *ptr, u32 len)
>  {
>  	struct lan966x *lan966x = port->lan966x;
>  	struct lan966x_tx_dcb_buf *next_dcb_buf;
>  	struct lan966x_tx *tx = &lan966x->tx;
> +	struct xdp_frame *xdpf;
>  	dma_addr_t dma_addr;
> +	struct page *page;
>  	int next_to_use;
>  	__be32 *ifh;
>  	int ret = 0;
> @@ -722,8 +723,19 @@ int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
>  		goto out;
>  	}
>  
> +	/* Fill up the buffer */
> +	next_dcb_buf = &tx->dcbs_buf[next_to_use];
> +	next_dcb_buf->use_skb = false;
> +	next_dcb_buf->xdp_ndo = !len;
> +	next_dcb_buf->len = len + IFH_LEN_BYTES;

Is it intended that for .ndo_xdp_xmit cases this field will equal just
%IFH_LEN_BYTES as @len is zero?

> +	next_dcb_buf->used = true;
> +	next_dcb_buf->ptp = false;
> +	next_dcb_buf->dev = port->dev;
> +
>  	/* Generate new IFH */
> -	if (dma_map) {
> +	if (!len) {
> +		xdpf = ptr;
> +
>  		if (xdpf->headroom < IFH_LEN_BYTES) {
>  			ret = NETDEV_TX_OK;
>  			goto out;
[...]

Thanks,
Olek
