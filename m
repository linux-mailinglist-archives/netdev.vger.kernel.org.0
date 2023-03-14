Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978C56BA0C0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCNU36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjCNU34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:29:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF17E31E0C
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678825795; x=1710361795;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8yu+w7WOsFbbL3k5fTSylEZXzPjNj5fpo6tXY5VhJ9E=;
  b=m0o+0LhNCkiJktqm45USGchPu3rxNgVCZysIq8zE0vmeS413oJkso93b
   k+a596cVXWvrvv3sEqY0Xhx9DQt1uBmibdgf0L25qzDE/A5Ch8WwVp4/y
   oewXz0tlRHt4Og7250JSIEIWIVlTvLlfBWptqCrRvDQvHffSoWqtQiaIa
   xEHHvYp8/UYAZ3N3HnM9Bajkn1AHDMqpjISncQsc85lsVnHdDpGfHqC4L
   K0/kMPTKeIqSdjRPBm6Kg4dkfgSvzMoKtNLt/RplFmyGR1R9aO+zEop2l
   izWdZaQeDoqOVwf4gUfM7/VeFyN5M7pZX3g838ZGjKj2lrVy8uO9wphvI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="400117538"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="400117538"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 13:29:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="681570763"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="681570763"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 14 Mar 2023 13:29:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 13:29:54 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 13:29:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 13:29:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 13:29:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOA92gm+7lv+TbTRXhj4mKVd3UpmsDu1zzC5W2x5d5FzblGHuXsE4r31INTL0Iq1HLcEAjvV9lJEV+4RddGgcQbK+0i6Z0WjSlqPCXnhlz/5zlQQrKKfxxQN3fMGV4mBRU5Qd4d4JAnUYirRdDfSUzeB2ZCzRZWnf3XbTGRePkuXu40V9xaYk4dyl0vTSnEfccMiBr3HAMnpHUbjzp/prpdU+8vlxsuDVf3kdw7U/2qV2ir+m68OaOnCDTisWqRkV03wHSozRmP6AEqzA6RYgzD6Sn0/8AQkYY4VN6gLT56XG1JDosdeIhwwA5Eb7cA6PhmPmSIvSwTaIFnPH5RdYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfXYNLQe6LLJRHacz8YCsgtzoPHMkr0vUbt8iG/b3hQ=;
 b=Qu0dnK8nsz7gK+gum7oWRUi0T792HKScg/pKmu6xw7CjNKPh1DkRbaXwXbivwwSsiIRMdXESnF9z6mvFZakRj/B3F9XtjAY32LsCyKxa+2FIhD/1EKmXf5uDaskgYiljehWn2lqiKSmBYle6v3hTPm7qohj9t4dipsDrMe0/yHgcUaEa5wFsBcre/7k1F5gqFo+yFxB5ayx/jcZcU0vRObMPf+aI2XVXkv1dp/UWdlGnb4lezc8DrjlyL1o7Z/sEEkdXOol064xzQLgm4Dxiqc1UyWyGGMKE6SEMBKhb0TMaIexs4QRFaLf1HGQ0VwiQ1XXNlgk5Q385MtGr0obx8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by IA1PR11MB7869.namprd11.prod.outlook.com (2603:10b6:208:3f6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 20:29:51 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c2c3:34a1:b4cd:b162]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c2c3:34a1:b4cd:b162%6]) with mapi id 15.20.6178.022; Tue, 14 Mar 2023
 20:29:51 +0000
Message-ID: <cb406635-0c44-ef7e-2bc9-3c1ecd5c2779@intel.com>
Date:   Tue, 14 Mar 2023 13:29:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [Intel-wired-lan] [PATCH net v1 1/2] ice: fix W=1 headers
 mismatch
Content-Language: en-US
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20230313203608.1680781-1-jesse.brandeburg@intel.com>
 <20230313203608.1680781-2-jesse.brandeburg@intel.com>
 <f0c898f5-f4cb-34dc-91f6-a83106c52c0e@intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <f0c898f5-f4cb-34dc-91f6-a83106c52c0e@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0070.namprd16.prod.outlook.com
 (2603:10b6:907:1::47) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|IA1PR11MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 08105ad0-90cf-4431-0b2b-08db24cadcb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UJTGuQkkFJuhiXiiLjJJsx/xbVzJfZSYMtYytHU/drjsdBk62JRXm8rINvXXaI5nEr0Yw2FlRSLJrgmDjONK+KiEYqbRiRH6XQPmySzRgjIIEVD1T3t8i5X1HUc4T1OnpN9SLvB9Fpm0bTTu70xZMfT4vu3OmsPtt09I5uVgXIjmaQtKU7akgeGSFA7U6cakeOgx9jt2kf/CjL8jAwmXh1srS4wJNuN3GYlpPY2biRUpQXEiFjiJR5shGk+67uZ1DUdQPg1WeKe9ClilDPjNJwsZwXm1zsuAVKqOvr+YIOFcmHKyrJUyeBJPLsm3oifYAk6quHSbT7yZnYFeqeQIC4fe3c9smdjhU0rUH3FLr3bB9MF/aCOkFO7MSNDhKfac6VvU1Ri25QdssQU7IN8VGrHJ/A89Sj39d9dlDnUDXB+FT6zxPlgFrMnbB2X07Ki2IFpqvQWvcjxJfxQIb7MygSGHqFj045VYI7AaFm6GjxTXrLvdVaARnOkdFX12nnhiIufWMtVV7qq3sjaTuWR99XveY+kRevvbI9h1Qjt7n3pd/Nl3X5cmDt9zz5m5KCqoWBHUXjPCeGDLpdjntxStarhtyb8pxHRZX4hlmf9F7Im249fpz3OwN/yNhmfBDbGCM4ZTTODDBAGzakTJVNDr6HH7xEp1tjttTCP/td86KlNv5sS1Iwu1ldKVzsvaO5IFPIL98y7VuD0zljypllV/C1O824RNfB6Mq3xNUOw7y9Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199018)(31686004)(8936002)(36756003)(316002)(6636002)(37006003)(478600001)(66476007)(66556008)(4326008)(8676002)(66946007)(41300700001)(6862004)(2906002)(5660300002)(44832011)(86362001)(31696002)(6486002)(26005)(53546011)(6506007)(6512007)(6666004)(2616005)(186003)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGRVU0FhY05uSE1MMzQ4YndtZmRpU2I1UXAwNzRDWjlyS1V1WUkwVjVVZGZR?=
 =?utf-8?B?TEFaclJGdDZFcW1sS2xUNFduUE8zVWZXekl4UXU1WnhtZmR6czE5ZTc0c1Ro?=
 =?utf-8?B?QXhuRHBkekg1bWdTellrVDdpRW9VbFZBcWFuY1pUNS81ejViUTZxYWJJOGRy?=
 =?utf-8?B?d2xFQXZIai8xeTdYTXA0VDRkbnhzcnh4K3ZHR3d0S0hxV0dGN0lEZ2YvTzN4?=
 =?utf-8?B?NGhJUXd1eDRFUmNwN0xwUytuRWpHdWxLMytOcjJSSXhyS08vaGJ2dTN1Ymtl?=
 =?utf-8?B?MFpTMWp5WnE1Z1Jub2RiaFVmZGRyeTRYZlowVDlqQlhHMVh0cjhRZDhFdFg3?=
 =?utf-8?B?MGJxeG1USDYydmo1dGdwaUZvWGtkQ0NySzltZXpzRXZrV0I0dDJXNE03am11?=
 =?utf-8?B?bXVwQ2xDRjh6czY5a1JqbVpTZjV2ZHh4M2pCRTBsdjlST2tEOTNBT1ZPeUlM?=
 =?utf-8?B?SjRid3REbUF2WXJBUkh3OVYvNWxkMUk4aFdSUkcxZWVHdjlkVkVxMUpRVFdD?=
 =?utf-8?B?Y2xYVzA4ZEhrdFlWQ29ydmQzTWd4cjROK05zUk80NVFIbHVQRnpCK3pUdDVo?=
 =?utf-8?B?L0FmeVhhMFd4SFBRWXpjQnpSOXVCcVJiU3QrTGtFNUhoUnV0M1ZmRkJMYlA3?=
 =?utf-8?B?ckZlNmxhcUNDRitLWUtCZVpGRWNBWWlEOGNKMjFwclZCRlJnM1pvUGFPZ2pS?=
 =?utf-8?B?ems4aXhnVGpobFpGQU1IM3EwY1l0aG9aWTl1SlhYS1JFcHJubGFSUjdzNGlQ?=
 =?utf-8?B?bkwzbzVTNTZCTDMzU2tqcGtZbnlJOUxvSGlYWXFpbENIeDMwNnAwem5ic3hP?=
 =?utf-8?B?MzNIc3BuTXI5YkNGdFBySWViTEc2RjFnakxSek8yTEc0aU42RC9SZ3BjZDFG?=
 =?utf-8?B?M2hVN0JvNTFZS0VScHlPOFhZUXJpTmljb1l0UmZLUWpOQnBNbmJXNzdPMlBr?=
 =?utf-8?B?bmc4cTRiN09BakoxK3ZOQmRoa1BURDNFUWpGbkpZSE1ZREtwL3BuaWhxU0ov?=
 =?utf-8?B?Z0lXYmYrZUg0dFV2L1ZiTWZzOTNYWmhZZmRDV05SSWpWeU5xcXFTdXMvK2JW?=
 =?utf-8?B?czZVVmhxN0RRUk10QjZDR2JyMitYUG1hdkJLQ0RGWnZ5eEI4Q1RaRnVud0M0?=
 =?utf-8?B?Tit1SGkrZk01bDQ1SWEzMjAxYjlFTVYzRHc5RUVvSzdJNlFmR1BmZGVaNzFk?=
 =?utf-8?B?aituSFBpSjdTbFJoRUNPdjNyTVdCZG0xRTVpcjMrWkV2cFc1ZVFpOHNDVkRF?=
 =?utf-8?B?Y0NwMkd4N2J4WXFaa3VVZzV3QW0zSUxLMEFOTVRsK3pYd3BTZGpHTm5idGVm?=
 =?utf-8?B?RStnQTZMaHZpVDEraEpFZkI0YTM2N0k4aUZseStZT1JtWHRlcUkxVk9ta3E4?=
 =?utf-8?B?NSsrZlFyb1FYUG9yd1N6YjlwWWNZdlFLMTFSVm1VTm1HNW1EZXdhQkdxa2FZ?=
 =?utf-8?B?UmdmaklNYy9VMjdiSDFZZi8wdVkrVm9MdzJhZzNmNmZjalhuUUFUaFZXRmVL?=
 =?utf-8?B?K3RScG5GWkRxcjJKdDd6ZkJzSStGQXFaMmRtZGFhU1pvWGdZVTRLSFNlNE1x?=
 =?utf-8?B?MXRZY2ljckpoaHlIRWh2Y3h4aEdPc0xob3FVaGoyQ200UUN0c25UWlp4UnNG?=
 =?utf-8?B?Z05iSDRGSzI1VE41ekJCS08wRFY5UlFmcklrN2VqeG9xL1hkekJHUTdRMWNh?=
 =?utf-8?B?OUROTzB6MGFVeit6U2RXYjVLd1g3a3R1aERldXBOZ05zeTJZcWVjbHAwczFy?=
 =?utf-8?B?a05TTTk0bzVyOTNTTTdJZDZ4K0hJVWlXTnp1aUlDaTFnVDkvLzB2Mmx1SS9F?=
 =?utf-8?B?RTQvOGpQK09oYU9LaXltZ0pSZzM1V3BJeURtMUowNHZ2dHlsZHo0WG53QkUv?=
 =?utf-8?B?c1g3cENHdmJRL1NsUVZBUGg1K3dZOFBOZE9RcXlUOGVOQWdla2VITXJXNG9l?=
 =?utf-8?B?eitJVGxldnB1T2JjR1ZUVlVaakxMOWlmaS9POVErejU2bnFxaEllcWh2K0Iv?=
 =?utf-8?B?RWI4Y3g0UEVRZTZDcjBPSEo2am42Tm4vZ0cxWHdsZDRLK0RrSmRSSm1xbDRX?=
 =?utf-8?B?ZTNxNmZRNXRoZFdObzFTMVo5TG1vMTJzbVdFM0tNTjZLM1N0aDhNVkVhcyto?=
 =?utf-8?B?RHJQVU5Dc0VHNGxHcUpvbDI4SmZpMEFIcW5ySjl4djM3dzNZQ1VVaDQ5MWZy?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08105ad0-90cf-4431-0b2b-08db24cadcb5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 20:29:50.9777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALUOlGW6mY2VZyqgV4XvF8FC2AusUe22WxEofcFj28nJ9SQ0UtR7dDb9rawG4nz5t7tL8Y0CYUsaCJGW1E3MTpoa0dPYQtw6UCjlSvs4GMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7869
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/2023 6:54 AM, Alexander Lobakin wrote:
> From: Brandeburg, Jesse <jesse.brandeburg@intel.com>

>> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
>> @@ -438,6 +438,7 @@ int __ice_xmit_xdp_ring(struct xdp_buff *xdp, struct ice_tx_ring *xdp_ring,
>>   * ice_finalize_xdp_rx - Bump XDP Tx tail and/or flush redirect map
>>   * @xdp_ring: XDP ring
>>   * @xdp_res: Result of the receive batch
>> + * @first_idx: index to write from caller
>>   *
>>   * This function bumps XDP Tx tail and/or flush redirect map, and
>>   * should be called when a batch of packets has been processed in the
> 
> How is Rx hotpath related to "ice_switch" O_o :D Those are 2 separate
> fixes or at least the cover shouldn't say they belong to one topic.

Thanks for the review:

Quoting myself:
> Fix a couple of small issues, with a small refactor to correctly handle
> a possible misconfiguration of RDMA filters, and some trivial function
> headers that didn't match their function.

Please see the last half of the sentence, regarding fixing these trivial
comment-only issues. If you still think that isn't enough I can reword
or resend, but in this case I don't think there is anything wrong, do
you agree after my explanation? Did I miss something?

Thanks,
Jesse

