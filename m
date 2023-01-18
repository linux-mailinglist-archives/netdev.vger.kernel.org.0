Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC77670EEA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjARAnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjARAly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:41:54 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31F193C4;
        Tue, 17 Jan 2023 16:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674001190; x=1705537190;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lw6AqdmJX/z7b4+Qpd0kTNCEGIr4CFyqWnC0lRs4/Jk=;
  b=maJ906v1sFb9EID+ENmMj0g6laSRMLZyeLWQzRxXsuxu+0GmCMmJrgzC
   noaTkZJL+lcnRLvtI3Zg2NUbM1tPyPg3UTjLz1ds4i5oYPZH/jngWY2SS
   5pKgnsd3q3u87MJFzO3rIOp/w98ZSqwrumqPfdSrKOjZ+u54ZObgmxOYj
   w9HhDKFt0Y7ehD3zwjuzp/Us20U+UgEfsySEx4//WJdJnV0nBbBCL37w7
   t9k9NYAywU/P/FGFdHjxCQVZ7qrBE96hF7s6B7ND9eswqIRwE0zvZ63Ja
   IK0QnROWAQmAi9w+J2zTAFj6MHQY8/K02EYFcJACOjrjLE00SEKsvHlh3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="305232325"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="305232325"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 16:19:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="767488122"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="767488122"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 17 Jan 2023 16:19:49 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:19:49 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 16:19:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 16:19:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSjLu7mxSRwQjOGkxj3JTA0RHUryYh0H7LjpftZcHD3HcjuLCch6v0Ex7ndt3ZxUD7uGZDoDELrodOQRQXRLD8GWzYuJqQ2J23In0wbTCjEioYs0b5HMwkV51nS5xLGDbaA9IpVeI3cjwuTmyFfWK4VLr41hGp1JzEbZY6J0Q4+DPdXHrAiiwvfRPmql7mkM1BzYydEDENv3sgl3Mypxm1wbUHhUlL5wiH5KJRw7PzUGXJEuXGDK4uHxi7BnmzPDA+zP2B7HqAVItHiizb3ENjZeSpCkxP/TdBOou8Ks0RwMaVAOrshcoCkBfnZOvLbUdGFC2xNFpaVSLnbObI5XLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNiIz5KsbcaSV5avyZQ6sdARPdKw8X3K+hvTJ9XOHh8=;
 b=m1cVDDamaPwgFULFi0BeZcvfOeYGp4oJK9jgUF0bxX+t7Q1t/lJoCM/YnWhNePanucV2cEt9eBc8YHEYcYpuPzRWoQjYcLEEnVOAAMSNpRVBVgMjo9r4AGnmbkE0f/O12u7g0A6/y0TLb1S0HTfwzVJBu56GeE86yTgG44auyw5v14pFwfDTVnErhZZrQJlNlqMi+HGBtt2gSDi2lj8XTJtWmAVmzhrQ5mUhgHjsw/ykpjwMoHyn/4nDUdNdp1vWmrYKlcnyO0Tpis+pFUTxJXFvOi8W6YeQza/RM//P/GzIJ9+gtBv0mK2KYv92lWpa1EjJujiI5nDp2MbQsKiRQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN2PR11MB4725.namprd11.prod.outlook.com (2603:10b6:208:263::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 00:19:46 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 00:19:46 +0000
Message-ID: <61004560-8dae-9abd-5362-d5ec4d846f87@intel.com>
Date:   Tue, 17 Jan 2023 16:19:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] net: macb: simplify TX timestamp handling
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Richard Cochran" <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230116220835.1844547-1-robert.hancock@calian.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230116220835.1844547-1-robert.hancock@calian.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0258.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN2PR11MB4725:EE_
X-MS-Office365-Filtering-Correlation-Id: 860af610-5554-4dcc-5795-08daf8e9b432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54sc54Z8kYFGd8ymawzO0SIZ49ZvAPj9+d8WFNwOT6HKVZq0RFLYBkczqLZ/nUAu3ygOa/nZdpDb9lFA5Xcy1/8bsS6f4920WsLJxSD1jMqAuKlYtjSlktKmkV7NDdU+BuokdCcUazfZuoQX5gWQwkOTeaq7eh6joKaMayrv2PxQU7ylqQ025DV8lCXWkYB2FFXmsiQekD+MpaJbN0+5IBJxpLrGDOxUU82xhX2uFRVcaf90g/YcxpfpzVve40AZgE3z3ml7XeZYs/sdBGqZOiLKNXBJSTMXSwUwnHW3B7GgxWWxc5hJbucJUPAKs4pq+fBg8mhHYUxIILhNoUIA5UNyRTWeMG8Wq45N2lgeLRFlbDakFxVexj1hiQM20kIFNExnBvuHjDfxBJqj6QP97abVegZFLK9cwFiKluOY3xl2QQDhXEg/gyF3wxOTDGR53CYqGfKBgpqCv2eyOpTjORmMomjS1oxuO4gkQLRYCQ/Vw9UbNLHJad9OXodwy+mtuDxxKxcAKHlQKYU5/QpMMJetENM0zKepn0e3xyoRotPwf/PcWSHSWWHjLUKCxQVSEe+SWzhwOL+gkYzkC0PaL8To5rIYdkvSL4uMUj87hOC452LN2EremGfJROYB8DsoGXRuhDdCSQuc+NzJMKOqCeyGxZ/dkf82xk9X48qIq3ZsZ2lwhBtN1DKO8twVRrmDvXyMMkfQrg7pm6Uce17Y349b/VDSehTHv6Y7Th0vcIo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(31686004)(36756003)(38100700002)(7416002)(8936002)(86362001)(66946007)(66476007)(8676002)(66556008)(31696002)(5660300002)(2906002)(4326008)(82960400001)(83380400001)(110136005)(6486002)(478600001)(6666004)(316002)(41300700001)(6512007)(53546011)(26005)(2616005)(6506007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nit0RGRoWU1NR0NHK3hBTjFlSkdTNHBSQVRGbmZYS0x3MjJsRUxuMUtobURL?=
 =?utf-8?B?RXpTVFgvdmtHU0JHTjhIUW9PNkY4eXhGa3hBOUphR01JcWUxQ3p6K1dxdUtD?=
 =?utf-8?B?TUxmRFdxUHBybVptcU10SytEUzlUblFrRlptZkp2WjlYQ3dGdU9MN3hUSTZl?=
 =?utf-8?B?bU1hYTc3eTU1SjdxZ1JrNEFSMW53M0xRUW9UZzFSWXljZ3dscUg4Nk5XZmt1?=
 =?utf-8?B?aU5QZDUyMHdhWlpISTVVUTcxSFRINXRkQThRaStVZkpaR09mMmUwNVVsNzJT?=
 =?utf-8?B?MHhpc05xdFpwSHljTkM2TUkybXVhT2lkZUxBMmxHQ0JnWHdwdGNtd3BIbitW?=
 =?utf-8?B?NjlSQmZJbWp3SC85M3d2bDRLR3k4ZWF1d2xZdnRYdFFLVTRHa0M5a3VVRGJ0?=
 =?utf-8?B?dGoyOWo4VVovWFluMmlNRnFJVXdxZ2ZPeFlHOEJ2Tm9HNHRQUmRuMDFrUnNG?=
 =?utf-8?B?bitZOFhjbXhPL1B5cDFUVEM4TURWSStGWVpkcFlQTmRaem4zeWV3bDBEdmlC?=
 =?utf-8?B?RHA5Q0RSckFwa0UySTlLMW9jbkJtVFRDTm00bHJQTUZNNWo3eG9aRi9yNVAr?=
 =?utf-8?B?SnRuVXY0NENCd3NqYWV1eUoxais0WlNKVnhVNGpITjVTMTdtaHovcXR3aDFs?=
 =?utf-8?B?VWhMU0FrVDZNaXRsR1dhRGhjYlBFaUFlOTJnK1VjTVNuRzhiK2hOL2RFWWov?=
 =?utf-8?B?QTlIZmhva0F0WUNzYjk3WHRTaXFDWk9HOHJydXF6YkQ4UERURnJYYkY3RXBQ?=
 =?utf-8?B?cWdWZnhhUGxFZ2pTdld6UzJMSTlyRi9PNHF1T0lkZXY1eCsyNms3a3Nad0xO?=
 =?utf-8?B?eDFMaXJxZDFldkNTcitrKzNKdEREajNOMzRzTWtReEh5bzdsT2dxejB3YTBp?=
 =?utf-8?B?bjJINkR4WkswQ2RmakpIVFpHbXFEei8rS0FBTnVzak9yZGZkWCsySEEzSWx2?=
 =?utf-8?B?Zy96VVA0a2JzYWgrSGtxSFhpT1NGQzYxbGR1bUF2dUc5NVBUbDdoZHdoeUdF?=
 =?utf-8?B?S0lrQlI2TVJCOHAxQkhyK2RCUHh4dmdhRGVEUGw1dmZVbW8vOWNINytPRTVG?=
 =?utf-8?B?cjh2b25xNm1qcmIvajl2REQwVXpDSFlBZlo4WFV1dG9yRklhS3ZldVJIUXpJ?=
 =?utf-8?B?ZFhRSkRxN1c0VkU1ajA1OGNHT0pxODN4d3ZiWTFMei9rMkR0N3FBS1ZrcDNv?=
 =?utf-8?B?b29zUmc3YnhxczQwRVA5TkFBWDlLT01rdThkNkI0cE84TXg5YllWRlJRNmpN?=
 =?utf-8?B?MFFrcm03b3BVNDIzei9VMEUvZzhKTFJRYXJYejJ2WWNjdkpvRzJ4NUZTSmJj?=
 =?utf-8?B?MitZRjh5V1YzdGFjL3c5dmhQWGRhZEdDeTV1Ky9OVlEveS9CSE5Oc2RNQzU4?=
 =?utf-8?B?TG9aenhPdDhka25JRUUwdU1JMU56cGlPYWdkM01FNEYzQ3VGcXdocVpjcVZj?=
 =?utf-8?B?eklmaXFkQzdzSUg4QStETFVpbnhSMzZnQ01BdzFvdEI2OXI4bHk0cXFnNyt4?=
 =?utf-8?B?OXJsKzhGbzVJRWN2V01VZkVmcnlsQXVWRXdvd3JidnR6T2ttYVBNQ2huYTFn?=
 =?utf-8?B?OEZYZm1OMDVyV0lPeEIwcXJCNDAwRUdKTDBXNGZBZ2ZTdTFOaFZMKzE1WkNz?=
 =?utf-8?B?U1VQQWtBUWFzNWZWdjBDODBEZWZwMXlvYlZ5bjB0YjFEcGZVc21wMjR4SU4x?=
 =?utf-8?B?NWhjRGprcDhlOWExN0JrdVk0VGgrR3BNZnk0WU1rcHNTVTdlRXFYaFdERlY1?=
 =?utf-8?B?V1B3Ni94OWdBME54MVdMSEJ2eU5odGVIV2poVWF3VnNzNlFmeE5XTmYvbTV6?=
 =?utf-8?B?bEgxaVN6Y3VSc3FXUWlMWDNvWVhFcjNkRnJvWUtKSnpvV0tCWGkybktuM0xa?=
 =?utf-8?B?NExlMlMzeVdGV2dRazA0L3k5MElwRGZQQkh1bmdXOTlrcWdGVlJuRFByV2VE?=
 =?utf-8?B?R2Zza3B0cTlXRVVBMlhhOS96TEFIWWpWY1JiRlJydXRwSUxqbTBHaGVsVyt5?=
 =?utf-8?B?ZXBvODRMUDJCRDRVcnJzOTc2eW82ekdhM2JCSXEvZkhEak4xcGtxd0VLeTM1?=
 =?utf-8?B?NHArQjBuWlROT2pESWVKaUtpOTBJQXBxQVlJWG1zaGxlVTJ4bW5mOVo4Mnpr?=
 =?utf-8?B?L0xsU2dpUVdDUWl1czFlYnRZc1pzQWQvZW5tZDhTbHRtMkhKK3E3SmhPUEtP?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 860af610-5554-4dcc-5795-08daf8e9b432
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 00:19:46.1862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsPBRF4sw5otyx+ln1SiYFGj1slRgrOznJvKPFYgb29K6hm5XTJomDWaQ6Scov80JBoFFE0Ok+UJ6FLqU1zS6YjXeZxtcfPQt5VnccQZSZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4725
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/16/2023 2:08 PM, Robert Hancock wrote:
> This driver was capturing the TX timestamp values from the TX ring
> during the TX completion path, but deferring the actual packet TX
> timestamp updating to a workqueue. There does not seem to be much of a
> reason for this with the current state of the driver. Simplify this to
> just do the TX timestamping as part of the TX completion path, to avoid
> the need for the extra timestamp buffer and workqueue.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---

Makes sense. I can't see anything that would require a work queue, and
removing that is a big win. (It's caused no end of troubles in some of
our Intel drivers, but we have no choice due to the hardware design :( )

I'm not super familiar with this code, but..

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  drivers/net/ethernet/cadence/macb.h      | 29 ++-------
>  drivers/net/ethernet/cadence/macb_main.c | 16 +++--
>  drivers/net/ethernet/cadence/macb_ptp.c  | 83 ++++++------------------
>  3 files changed, 34 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 9c410f93a103..14dfec4db8f9 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -768,8 +768,6 @@
>  #define gem_readl_n(port, reg, idx)		(port)->macb_reg_readl((port), GEM_##reg + idx * 4)
>  #define gem_writel_n(port, reg, idx, value)	(port)->macb_reg_writel((port), GEM_##reg + idx * 4, (value))
>  
> -#define PTP_TS_BUFFER_SIZE		128 /* must be power of 2 */
> -
>  /* Conditional GEM/MACB macros.  These perform the operation to the correct
>   * register dependent on whether the device is a GEM or a MACB.  For registers
>   * and bitfields that are common across both devices, use macb_{read,write}l
> @@ -819,11 +817,6 @@ struct macb_dma_desc_ptp {
>  	u32	ts_1;
>  	u32	ts_2;
>  };
> -
> -struct gem_tx_ts {
> -	struct sk_buff *skb;
> -	struct macb_dma_desc_ptp desc_ptp;
> -};
>  #endif
>  
>  /* DMA descriptor bitfields */
> @@ -1224,12 +1217,6 @@ struct macb_queue {
>  	void			*rx_buffers;
>  	struct napi_struct	napi_rx;
>  	struct queue_stats stats;
> -
> -#ifdef CONFIG_MACB_USE_HWSTAMP
> -	struct work_struct	tx_ts_task;
> -	unsigned int		tx_ts_head, tx_ts_tail;
> -	struct gem_tx_ts	tx_timestamps[PTP_TS_BUFFER_SIZE];
> -#endif
>  };
>  
>  struct ethtool_rx_fs_item {
> @@ -1340,14 +1327,14 @@ enum macb_bd_control {
>  
>  void gem_ptp_init(struct net_device *ndev);
>  void gem_ptp_remove(struct net_device *ndev);
> -int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb, struct macb_dma_desc *des);
> +void gem_ptp_txstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc);
>  void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc);
> -static inline int gem_ptp_do_txstamp(struct macb_queue *queue, struct sk_buff *skb, struct macb_dma_desc *desc)
> +static inline void gem_ptp_do_txstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc)
>  {
> -	if (queue->bp->tstamp_config.tx_type == TSTAMP_DISABLED)
> -		return -ENOTSUPP;
> +	if (bp->tstamp_config.tx_type == TSTAMP_DISABLED)
> +		return;
>  
> -	return gem_ptp_txstamp(queue, skb, desc);
> +	gem_ptp_txstamp(bp, skb, desc);
>  }
>  
>  static inline void gem_ptp_do_rxstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc)
> @@ -1363,11 +1350,7 @@ int gem_set_hwtst(struct net_device *dev, struct ifreq *ifr, int cmd);
>  static inline void gem_ptp_init(struct net_device *ndev) { }
>  static inline void gem_ptp_remove(struct net_device *ndev) { }
>  
> -static inline int gem_ptp_do_txstamp(struct macb_queue *queue, struct sk_buff *skb, struct macb_dma_desc *desc)
> -{
> -	return -1;
> -}
> -
> +static inline void gem_ptp_do_txstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc) { }
>  static inline void gem_ptp_do_rxstamp(struct macb *bp, struct sk_buff *skb, struct macb_dma_desc *desc) { }
>  #endif
>  
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 95667b979fab..6a0419acac9d 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1191,13 +1191,9 @@ static int macb_tx_complete(struct macb_queue *queue, int budget)
>  			/* First, update TX stats if needed */
>  			if (skb) {
>  				if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> -				    !ptp_one_step_sync(skb) &&
> -				    gem_ptp_do_txstamp(queue, skb, desc) == 0) {
> -					/* skb now belongs to timestamp buffer
> -					 * and will be removed later
> -					 */
> -					tx_skb->skb = NULL;
> -				}
> +				    !ptp_one_step_sync(skb))
> +					gem_ptp_do_txstamp(bp, skb, desc);
> +
>  				netdev_vdbg(bp->dev, "skb %u (data %p) TX complete\n",
>  					    macb_tx_ring_wrap(bp, tail),
>  					    skb->data);
> @@ -2260,6 +2256,12 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  		return ret;
>  	}
>  
> +#ifdef CONFIG_MACB_USE_HWSTAMP
> +	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> +	    (bp->hw_dma_cap & HW_DMA_CAP_PTP))
> +		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> +#endif
> +
>  	is_lso = (skb_shinfo(skb)->gso_size != 0);
>  
>  	if (is_lso) {
> diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
> index e6cb20aaa76a..f962a95068a0 100644
> --- a/drivers/net/ethernet/cadence/macb_ptp.c
> +++ b/drivers/net/ethernet/cadence/macb_ptp.c
> @@ -292,79 +292,39 @@ void gem_ptp_rxstamp(struct macb *bp, struct sk_buff *skb,
>  	}
>  }
>  
> -static void gem_tstamp_tx(struct macb *bp, struct sk_buff *skb,
> -			  struct macb_dma_desc_ptp *desc_ptp)
> +void gem_ptp_txstamp(struct macb *bp, struct sk_buff *skb,
> +		     struct macb_dma_desc *desc)
>  {
>  	struct skb_shared_hwtstamps shhwtstamps;
> -	struct timespec64 ts;
> -
> -	gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
> -	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> -	shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
> -	skb_tstamp_tx(skb, &shhwtstamps);
> -}
> -
> -int gem_ptp_txstamp(struct macb_queue *queue, struct sk_buff *skb,
> -		    struct macb_dma_desc *desc)
> -{
> -	unsigned long tail = READ_ONCE(queue->tx_ts_tail);
> -	unsigned long head = queue->tx_ts_head;
>  	struct macb_dma_desc_ptp *desc_ptp;
> -	struct gem_tx_ts *tx_timestamp;
> -
> -	if (!GEM_BFEXT(DMA_TXVALID, desc->ctrl))
> -		return -EINVAL;
> +	struct timespec64 ts;
>  
> -	if (CIRC_SPACE(head, tail, PTP_TS_BUFFER_SIZE) == 0)
> -		return -ENOMEM;
> +	if (!GEM_BFEXT(DMA_TXVALID, desc->ctrl)) {
> +		dev_warn_ratelimited(&bp->pdev->dev,
> +				     "Timestamp not set in TX BD as expected\n");
> +		return;
> +	}
>  
> -	desc_ptp = macb_ptp_desc(queue->bp, desc);
> +	desc_ptp = macb_ptp_desc(bp, desc);
>  	/* Unlikely but check */
> -	if (!desc_ptp)
> -		return -EINVAL;
> -	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
> -	tx_timestamp = &queue->tx_timestamps[head];
> -	tx_timestamp->skb = skb;
> +	if (!desc_ptp) {
> +		dev_warn_ratelimited(&bp->pdev->dev,
> +				     "Timestamp not supported in BD\n");
> +		return;
> +	}
> +
>  	/* ensure ts_1/ts_2 is loaded after ctrl (TX_USED check) */
>  	dma_rmb();
> -	tx_timestamp->desc_ptp.ts_1 = desc_ptp->ts_1;
> -	tx_timestamp->desc_ptp.ts_2 = desc_ptp->ts_2;
> -	/* move head */
> -	smp_store_release(&queue->tx_ts_head,
> -			  (head + 1) & (PTP_TS_BUFFER_SIZE - 1));
> -
> -	schedule_work(&queue->tx_ts_task);
> -	return 0;
> -}
> +	gem_hw_timestamp(bp, desc_ptp->ts_1, desc_ptp->ts_2, &ts);
>  
> -static void gem_tx_timestamp_flush(struct work_struct *work)
> -{
> -	struct macb_queue *queue =
> -			container_of(work, struct macb_queue, tx_ts_task);
> -	unsigned long head, tail;
> -	struct gem_tx_ts *tx_ts;
> -
> -	/* take current head */
> -	head = smp_load_acquire(&queue->tx_ts_head);
> -	tail = queue->tx_ts_tail;
> -
> -	while (CIRC_CNT(head, tail, PTP_TS_BUFFER_SIZE)) {
> -		tx_ts = &queue->tx_timestamps[tail];
> -		gem_tstamp_tx(queue->bp, tx_ts->skb, &tx_ts->desc_ptp);
> -		/* cleanup */
> -		dev_kfree_skb_any(tx_ts->skb);
> -		/* remove old tail */
> -		smp_store_release(&queue->tx_ts_tail,
> -				  (tail + 1) & (PTP_TS_BUFFER_SIZE - 1));
> -		tail = queue->tx_ts_tail;
> -	}
> +	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
> +	shhwtstamps.hwtstamp = ktime_set(ts.tv_sec, ts.tv_nsec);
> +	skb_tstamp_tx(skb, &shhwtstamps);
>  }
>  
>  void gem_ptp_init(struct net_device *dev)
>  {
>  	struct macb *bp = netdev_priv(dev);
> -	struct macb_queue *queue;
> -	unsigned int q;
>  
>  	bp->ptp_clock_info = gem_ptp_caps_template;
>  
> @@ -384,11 +344,6 @@ void gem_ptp_init(struct net_device *dev)
>  	}
>  
>  	spin_lock_init(&bp->tsu_clk_lock);
> -	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue) {
> -		queue->tx_ts_head = 0;
> -		queue->tx_ts_tail = 0;
> -		INIT_WORK(&queue->tx_ts_task, gem_tx_timestamp_flush);
> -	}
>  
>  	gem_ptp_init_tsu(bp);
>  
