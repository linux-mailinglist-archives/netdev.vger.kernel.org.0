Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C906E5B6347
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 00:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiILWIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 18:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiILWIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 18:08:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E827F4D267;
        Mon, 12 Sep 2022 15:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663020514; x=1694556514;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7Utv+K3BgofoY9ZmCag46XhG1fetGA5zy+J6KFJeWFs=;
  b=l8G8pKxsvf53RDs3hnLZ+3l5bGVSCbZEPx/G6yotLpPEIuVykTFgS90p
   S0ZRiZU3zNemsefXQ5w1g9P113JYTjYrbrFj2Tr5WwRGnkTgR5JTQHfk5
   WPRwOk60NuCRQj1QV2HtjmmPCQzSiAzRPxiDvz3deBb2YHd6sBWTIoUPL
   um9LNqdGp+XNZIGBiH2lkKQtSQIbUsYWTBIs/xrFtnSHwX1qRz63JXBrY
   725FNazd3nnC518r09BfYlPv/AP+728IYAwp3E5IMElWXK9pbXofK5ceU
   CpvLhhekwr3EKWGjBnCk65ovCDGcuVGCoIxc+6rABzDXPSGTViz+Z06qf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="299320613"
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="299320613"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 15:08:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,310,1654585200"; 
   d="scan'208";a="684606074"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 12 Sep 2022 15:08:34 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 15:08:33 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 15:08:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 15:08:32 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 15:08:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNGKFyaYjMrnTnj6QQV3ze2wRzK1fIR2mIbsMkMol1UwDDXjxyILBqGCkNQvhZZj3/I/+YhgqPhFLiDfse0XymaNXud8jmyMSoBjIijcS05S04VZmHwT/tfSJQ22Us2Nfiungq2kkoCvn9dNwd0jY7Tx68zvzQ3V5EuxUWJA92HBfxXKlEfG0G/9jxuXZQ8NS0f5MCFh5b7Q4SACsHyar5TcHANHZsUsSggRh+M+foCrRRhNh0CcUEQ3UzpJkwnSz8/BcQXGygC/Djp8oedAQGF+2+VIqHzqBymeu1H6MUq5r0spgFhnte8C+NJX0rMBa2eFrMpgr2oPFTCEUmRwQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fkMYQ3Lv6U6PJZfVLwTPRMORltK2aJ3gcqYRmnIKLs=;
 b=V55CtXzKTe3Gp3JgBuJALEI07WYVKEMLoQqKaqercMCw22X8Rq10hZ66f/kfBQ926E1QtPOmtpxs3A6gAYUP7tbbUbnf6nfjyyHIlN/tnHlaqbC+saM2KypOccdyzdQDrNuxnwrhgw/g1FQlCLcCmKquqB1Xbpvglkwfd2X/U88ggWVXYZIl7SWZ8xzT9h7xOl8sm6oDXDhGFa/ams4MlD9jGOsfhwJXw7VQ96kifAx5F7By4YGs4RixZP0gANO3uiYja9B+HHc6JEKZI6g5234BBVMAo7Gr0HnYKaDmzATOWNRKRop3xYtu3UATA/JLrMBLargQEr+j4ng7v+ETPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN7PR11MB6851.namprd11.prod.outlook.com (2603:10b6:806:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 22:08:31 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::a422:5962:2b89:d7f5%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 22:08:31 +0000
Message-ID: <4ff0b209-2770-3790-ae93-3ea81c15a03e@intel.com>
Date:   Mon, 12 Sep 2022 15:08:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v1] drivers/net/ethernet/intel/e100: check the
 return value of e100_exec_cmd()
Content-Language: en-US
To:     Li Zhong <floridsleeves@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
CC:     <pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <davem@davemloft.net>, <jesse.brandeburg@intel.com>
References: <20220909041645.2612842-1-floridsleeves@gmail.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20220909041645.2612842-1-floridsleeves@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::26) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SN7PR11MB6851:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c49a238-ebcf-435d-2747-08da950b53ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhtDwXZoyMS3TrteHaw2K+22jS17272qKExz0NMD+A4N+b4gN+Q9CcYtEsP2ay0ufjvxcQLYsaEK2czjyGiMBkbvQtFO6CZCXphMTapcPlPS1GNQ27NtK8Dc1rNRG4JVYyDznPxJwQ6iR78ljX6RjtuqZ1pA7rL6fB0wnFPzp5L9lOeI+J8mqw6iPPum1GX3JzvKQxyYRmFsKV9O9CChk+4reUyfpOOk2ddw0tr+n6X7R8aRwlEpBUbv+ePZCLgp9UgVQatjYguI8ii4cwACIXX3ZHm3+6/6TluTgJjdSXxvIrMARoht/soXqHQrwwfS4Hwo4jgWGDWES3WKCcjsDTqZSMaL4Yj0brQu5Gfzn+dgkv1inEO0kj+1Q9Wd5nOGefBkgteRR77Ij6F1L7YlgBwK2LyAUTkyhVfh4TIPUg+9tVwMGPKj79aardOBdwLbeE1KOZKRhfoMZzT/zY8vqSrssl3YW16IgD0pCA6pRtwPTgvRq7KLXNjJ7LlEh5HhV3zmZNiP/s9XG/tr+4I1JR3KVON2yPH2RP7WJhLiaMNCYB2f/kUXEYQifjY5xa8uqcULRQuCkMVrM5x3h+nH7Mg5WYRj3TqY6NBreIh/kOHe/T5hBIwKH9amcdGnerCSxLup2cxeCAotzeUFU9+0KvcBgZEWlBXTDqludFygCw5w4fTFnqUoG5HlLxvCXhqlIZLSj+XKCuYorJDOCabYa20EEuYFj7dA16DhPbVOBEiDoOY14SKposOq3taU7PKJ7qYhYuA3aOoba5hQF67nb1KJdlu7D/rZ2ltPnWlVDFg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(136003)(39850400004)(346002)(451199015)(31696002)(6506007)(38100700002)(66556008)(2616005)(31686004)(4326008)(53546011)(6512007)(82960400001)(2906002)(316002)(66476007)(6666004)(86362001)(41300700001)(107886003)(5660300002)(8936002)(66946007)(478600001)(6486002)(8676002)(36756003)(186003)(83380400001)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a1BxTktYUjJsWDZHcFUxS2hJeDRrSitjR1NLcGV2L2RaS25lc1RDTjlMTmpQ?=
 =?utf-8?B?eUoyWTFZVGlpRWx5L3kzd1V5ZFJnZ2RocEcraVR0aWptOHYvN2RhZE15dmNr?=
 =?utf-8?B?SGlKMUxxcmt5STY0S2JFdFcwVkJnRGxURmtBMUVibnhibTVDSHhYaVNNaDI3?=
 =?utf-8?B?bzFQRVI5M01aT3F1UXdFTkVFb3ZjeHBrMW91bEhQVDRqcjgwQ3l5eWxoc3k1?=
 =?utf-8?B?dU1WWmw4cDlKZXJ0RXExNkRqSkhCdXlGcnpLQmYxNkRaditzbzhmMTJXRGw3?=
 =?utf-8?B?SU5WeXFEUG9qbFMraG1TVkNsdGpmVEovdXkzUU1aTWF6YWIvanFSd2JyTWti?=
 =?utf-8?B?bUJWMmFZVTVHbVlBS0FSZGNReEI2NmhEY2o2Ym00KysrbUc4VGdDTVd3TThF?=
 =?utf-8?B?cXp5OW0rQk85eHdRZmFlcDZkMG43NGNKeXhLaWloY2RabEVRSm9oQkdqZFA5?=
 =?utf-8?B?UHdXbG9OWnFYUVMzL3Q1Yjk3aVA2R2dzdllQZGdYYnl5U3ZLVWdIRG9lbzhX?=
 =?utf-8?B?eTJsSzVUdTVMNmxYNk80ampoVHZUNUZlTmNsazNWSVRRNVJZQTZjb3p3eGhl?=
 =?utf-8?B?d0FHN3Y0U1dmY0tCelFWSHZwdnA0cnM1YmdnSDVWUjJnODgwaGFoaGtkYlVK?=
 =?utf-8?B?V2F3aXVxR1VvaUVSa3VBWEpCTXpJcTc1eXN6ZjhzSElkMEd4b3VIZzkyNmtL?=
 =?utf-8?B?SVVFeWJocTJQS3psOW9RQ1NQZVhCQXdOeTI3UW54ZGx0dU9zQmV3bklsKzhl?=
 =?utf-8?B?Lzh1SFRQSjRhVCtDSHhseFo1c3ljVER2bzExSXdtcmRUQ2lucXQzN0p4Mnox?=
 =?utf-8?B?YXkxcktGbm10anRTckZhNnJ0YWRGUm9QMzh5VWRNSFdmWlIvUmFic2FZL0Ni?=
 =?utf-8?B?U3VsKzVBeTdYUzE5SWZ4cHBMYzZIT1p1UzZ1azBvcGY5WWpsTEViaGE5L1Zj?=
 =?utf-8?B?YUxDckdYbjRacWR3amVVUnRHZUlNYWtDUTJWdGVyWTh5VGtkdEhUbnVuOFdj?=
 =?utf-8?B?T3FJTGVmK2ZCRGQ5M0RjZEpMVHg5VGJtV2JPSlFmVVJuU211RW9iMDNrUzJm?=
 =?utf-8?B?S1kvNFpOdTBpOW5idHMyNElnL0tYWFVGUFlNdGJCR1FFYUhjWmNtUDlkTUVu?=
 =?utf-8?B?RTVqNitrUEJFUjNYSXhpenZmeks5QkJWQjRaZ0RadFlLQmV0VVlFTjkvZ2RC?=
 =?utf-8?B?TDA0bFlwUTJkbERoUHJTSFpMeUJGT0NYcUFWck9iaWVaOCtYV3ZOQzZEcDR0?=
 =?utf-8?B?MEJjMFVFVEo3b0UzSmgzL2lVOGxUZ3c5L2xjTk5wYURXSmI5aDhVMEkzNllR?=
 =?utf-8?B?bTgzNDRLREFrN21lNWhpL0JsZ013NUp6S0lRSG9kWXVNejhEcGR5OUdzNElK?=
 =?utf-8?B?UEdSeGRndzV6c01nNCtCRXBwOGtHc05HeUpvcUpzUElwVU9aSG5lVk5GQ1B5?=
 =?utf-8?B?YWh1ckZvVUo3djk3VXp2NHYyUDVaTmJaY1dWa3lTSStuY05EeWtKZnIrQWZy?=
 =?utf-8?B?MkQzK0JIRDh2bjIxRC9sMlJxeTlWczZYNWpEMkx6dzhvNjJCZ0ZnWnJXbmtW?=
 =?utf-8?B?RHRodXZJZkRhME4vemswOEk0Z05wZ0tTODQ0NVh0UUNSR2dLWWQ2Q2xVdUVX?=
 =?utf-8?B?WnQyY2d0WE5WcDIwS1JCbmhlazBPY21WRmhsZ3NVTmV5eWlqeDRSNWtqVEt3?=
 =?utf-8?B?ckQ3WEpTbitCRUNIZldYUTJURUk5dHUyTXNRejhYeDBHM2pzZ0w3RUtWWWlh?=
 =?utf-8?B?NzVUNEZwK0tLMHFWZ3cyZ0VSN29uREJaV0xhMkdkNVlYUjdQbC9TUWY1NHlj?=
 =?utf-8?B?Qk12WGFzOVlJblNRcDJ0UER6VXRlamo5MzYrb3FjRmRxVmdodWM4Q0JTL2lC?=
 =?utf-8?B?a0hZQThIWkprY0k1eFRDcU92UkRpYUI5TVJDQzVQRXVPZkE1aDR0V1NWTk5E?=
 =?utf-8?B?YnhHcWdsWVBnVWNKdmY1WTNETUw2VDlXUDFxUzk4MjZ0bXR4NjB0VFc5NVVz?=
 =?utf-8?B?bklybWpHSEhkaTNpUFFrcXF5WjZxazFHMHFTR00wUG9PN28vR2k3K0xRRXNY?=
 =?utf-8?B?VDFROEo3bnNoL2dZSjdUeTI2SkYrWlowN3RBQmVBaDZ6eHpHNTVjZ2tKQXRW?=
 =?utf-8?B?cEwwbzhTV3YzK3o1VXQzMDgrakRBc1gyL1ZUVjRxdWhFclF1R2NUeElhdmE3?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c49a238-ebcf-435d-2747-08da950b53ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 22:08:31.1107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: voZQu5y6HZUAlrC8D3TScaTRRzVFCDbM5jqxfoUutmMdWUr6FnhrEKFr3Jb5gT51kMmi+qguYU6l8mQrMjTVtl29OiDnMCBnmY1kv1x2eFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6851
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/2022 9:16 PM, Li Zhong wrote:
> Check the return value of e100_exec_cmd() which could return error code
> when execution fails.

Are you coming across this as a real bug or as something reported by 
static analysis? If the latter, I suggest checking the return value and 
reporting it as debug, however, not changing existing behavior. We don't 
have validation on this driver so there is limited ability to check for 
regressions and the code has been like this for a long time without 
reported issues.

Thanks,
Tony

> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> ---
>   drivers/net/ethernet/intel/e100.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
> index 11a884aa5082..3b84745376fe 100644
> --- a/drivers/net/ethernet/intel/e100.c
> +++ b/drivers/net/ethernet/intel/e100.c
> @@ -1911,7 +1911,8 @@ static inline void e100_start_receiver(struct nic *nic, struct rx *rx)
>   
>   	/* (Re)start RU if suspended or idle and RFA is non-NULL */
>   	if (rx->skb) {
> -		e100_exec_cmd(nic, ruc_start, rx->dma_addr);
> +		if (!e100_exec_cmd(nic, ruc_start, rx->dma_addr))
> +			return;
>   		nic->ru_running = RU_RUNNING;
>   	}
>   }
