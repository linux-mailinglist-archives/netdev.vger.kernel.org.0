Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481A6623468
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiKIUTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiKIUTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:19:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E995FF00E
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668025152; x=1699561152;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5tKApycKASwNZU7o5IytabDOOsFBkx3IR4z7a8A/xa0=;
  b=jFK4o35vH9M/IpzmZn9rZuEsYFME8AT3TIS0aoqN6NT9UT2FTmlya+41
   92cAEv8m2MquPF0E2GRwBwA0TfFFWws2DWuCpRhN/i+NY/IkCPJEVCSdS
   sxcqGFpfNvHdMYG3gZvbg8n2RhEdxzeoa5VB1chQ5wDGd6U0kKt9l7cb4
   hgaTPP4wnoTdApKSHnSA7+zx3eij5yTmFqJJVHZdRHaexwDL59cXcQOa0
   NgJSuOh3VST4xLRFRvxK5IhzGoVa/D6XzNtPbgIXSa8MfJYdJtP96q5Pm
   zcMiF0UEogG8HQsH9zjdLcwotIoigoAasPuYzrsCQtdgmVfpAKsrU0AY2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="397390080"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="397390080"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 12:19:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="614825316"
X-IronPort-AV: E=Sophos;i="5.96,151,1665471600"; 
   d="scan'208";a="614825316"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 09 Nov 2022 12:19:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 12:19:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 12:19:10 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 12:19:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 12:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsHvR3zVkgzQrsho1nan8yX/DhqVLFbyD7qG8OSNSjndQ3gAIfhBAk6k7i8iw8oW+jWNlwozFVX5Pcfuse1GO8qqb+VE/ObREQEGHxCqSMdiymhAuodI7GnrX2W/dARSloiMR2wUQkxElz1tY+MG4aYRGyhTnBuN3NK5ylQqBm6BChpLS3ssALJJkVl6SXKWV/Jr5Q8pMvyAk4J48wwaTn6iL4Imm4oj5tBdKW8gG/tS4OcEP+hxqmYNGyHKn+Cm/v+jUrmL0KVPW0rn/qhrdHok+9BE10ZNklOF8zeE7q6Y21zBtDfSikN2rTCDuO4pqP/f866KjJ61IsvlLt2xAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmlySrMej/f8Xor6KiHSG9rt1qByPfrPV/EDqORZVxo=;
 b=oPujvK05182g5c0N0FwagmJCV7Fa3PLP3/agaarwX2tnii3Cd3gjiMqzc7P9trOs6pk7dwziV+0md8wtmyjz3HvBTCW3hHyyATeUkk6v+X2e4LwfFaTDkA61aVBvI9o92BCt8jEHIDAvdCwFr3CTAnAN257BfCT9WPpRnv8c6nlcA4ExG0mFz2jGQUA/pnqjsyYyOIjH085H12GY77vx9jyzKvk6MdAG9GRmr7hc8LW/keNf9A3U8xxsBCwZto353L6uKfvgvjh6UZi0fS3eYw3Q6C0EIFwiwc+5oGMQSkmKQkKgXRBlGIq0N0Dc624uS/vVjR2/ZtKAhhvzm9KzzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BL3PR11MB6338.namprd11.prod.outlook.com (2603:10b6:208:3b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Wed, 9 Nov
 2022 20:19:08 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 20:19:07 +0000
Message-ID: <8555d632-33c5-9ebe-5650-ec772facdee5@intel.com>
Date:   Wed, 9 Nov 2022 12:19:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net 2/3] ice: use int for n_per_out loop
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
        <netdev@vger.kernel.org>, <richardcochran@gmail.com>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20221108235116.3522941-1-anthony.l.nguyen@intel.com>
 <20221108235116.3522941-3-anthony.l.nguyen@intel.com>
 <20221109163712.1154266-1-alexandr.lobakin@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221109163712.1154266-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR20CA0021.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BL3PR11MB6338:EE_
X-MS-Office365-Filtering-Correlation-Id: c29084b7-0cb2-4a7c-1e37-08dac28fa78e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QN5kTHF4g6IrWkPEdunzgjqZLeJlz8uIGXZuRJ5wcCxCP20LU1O83W9lyGibejf0t4tpVanDxDigQxrE1q0tjDXnnyiXXl6c6hkWR1w5f3DiYkapAhVjYVg91TYMaAj0/JAcurlqYwlV0wIjZ0fxlTWAXvl0ioDJmRCskFdseEjkI7IrwpVNnW2Ntus0vUOtK2I7RPvPZFlpcnQcJl3Jlh3h4bMmtvWVAeeF0CUV72F1BqwpqkX/yZrvVU3j/kgPNVgyL0yQW0TqdZlHfJrxbTM+QFKm+F/RTI4G6OY3p0hK5GP48F/fK6s6EMvJdwHmbNw88ZxvLQtjdPn+P44LbFphCw/dRvmLMmKEsH8JMZw5w4MxnmmY2xe35depSe0eKstAk+sdc/eduSdwWGA1qzOuccf6g4XCODZUhEYP1BYbDj3hNejG5ks7n6fs3EkkOa8joiDlA5hYiAlUcg9HVkaJk/SmhDrmi61/qUJrFP2URLtHjDtec/uQlH5SVshmtVkVsXCHrj9p5/mcOnlwITanRGXY3ER2LwVQbj0dNvzO2MXeHqoO65ZyJxnW/KCYvbCrdsGr4cK5VJ+JPsGotmfX8cU4DmqBmbnIFTiA0ZWJtYmA78uzhZoV3F1afFhy1s3jwKm81bGtl5NJiuak7jQc3yD1bULj7c+t+HT4w9KzB495ewsncDBswk9opcLdaenGT/6BR10H95iI3mD/3f4YxI05zINflS0+wngr2RESpJDSdJPJFAcD+ldrz4ocgUHM7QdlvspWDRuMN6LFndmrUaXg/Tn969hhp4ogLEg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199015)(6486002)(31686004)(478600001)(6636002)(6666004)(107886003)(82960400001)(54906003)(38100700002)(37006003)(316002)(8676002)(6862004)(36756003)(41300700001)(83380400001)(8936002)(31696002)(86362001)(4326008)(26005)(186003)(53546011)(6512007)(5660300002)(66476007)(2906002)(66556008)(6506007)(66946007)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2FXaTFURE50ZGJ4dTkvRk5IelBDSzhvNmxqdXJ3c04wY2E0Zmw4RWV2VWxh?=
 =?utf-8?B?K281SHBSSlByZmJJSysyMmU1SC84emt6aUJvWU5FNDMzZjVTbFNLSTdISWNU?=
 =?utf-8?B?TStJTHptQ0Y3akc0bmhtWTg4TDkwRU5TT3BFUW9zQStVMndUd1hpN3grcXhh?=
 =?utf-8?B?T3NGaE5kRXZyeTNTTThFUzVmRVd5TmNadGpnVTFoaWlCbkxPdmJoUWIwOUwv?=
 =?utf-8?B?K1NseFp0LzNaZTVwMkw1ZDNQb2NDOGY0M1BpVzIvSU5Ya1hVOWxGNEtPTzl0?=
 =?utf-8?B?TGR3Uzk5ZUNoTlUrYzN2WWJ6Z3pDeWZrZ2ZTTUFjSlcyRmFyNXZRaTVsOWpa?=
 =?utf-8?B?WHlHUTBGRGpwOTV1VDBVaGU1b3pTbVJ2NzF4NFhLcGtUZFVCZVlGa2N0TTI5?=
 =?utf-8?B?engycmhSTWxZVUdLWmwyb2Z5eTlmclErbTN6SlMxekh5OEtjSERqRXpENERr?=
 =?utf-8?B?dHpzZkhQcDZlUGpIelVsYlBBeERMSGx3Y1ljZVFNWlhZbTJpVjc3MlFVeWVQ?=
 =?utf-8?B?UnlFaHZKVUxCT1ZYaS9Ld0l0QVFFcEdma05wNDhQVkN5NDI3aGl5OTM3VjM1?=
 =?utf-8?B?eDE1aUwrd2tsMTk3QURDVVZzK1FDaVJwUng5WGRjUERYaGhuamE2MlVQanVX?=
 =?utf-8?B?MTJPUVJBU3F1WFljbUtNY1BlcWJPYnNiNDBnOXNRaTUyKzc5MUFrN0g5SzJ0?=
 =?utf-8?B?NEdKUHVvVksxZU5uaFV2VWt3alI0eVA2ZlNhaWpiS3lJRGlPaTlYYWVUdHFu?=
 =?utf-8?B?UzkwbXlnM1ZqRVlkWml6N045S2lGUEhEL2srV09nalhUeWxQbG5Jd2w5bmRm?=
 =?utf-8?B?OTlnQzRUOVBWalYrK3RSMDQ4Sm1hUExVUUpjYU5PSXFCQ0JBcExQVThhaWhm?=
 =?utf-8?B?RDBJTUZpNmJOMHhtWjVER2llK1ZQNWJhRGc2WUxCYm4wZXZNS2cvWmdNZUc2?=
 =?utf-8?B?OXFGN1pHQldHQVNDTVUvaWwzbnFBSkEzWlZoSHhDZzNDbDhuTXNTQkwwbGJG?=
 =?utf-8?B?Smc3Z2pSd0xCcUprSE5nS3JHZXc2WWZpVjRFUDRHM3JDSDMvOTJDcDZEVWd1?=
 =?utf-8?B?SUs5OTJWdjJ1QWZwd3lKOUZTYmlFcnpwQWZkZ29vV056NmZXcWpLZFJQcTFB?=
 =?utf-8?B?bkMzUS83SXk5aEVISVBleVFrZFRHWFBUS0FyQVJiKytqaEV3UFRBQVZqWVNz?=
 =?utf-8?B?ZFZMeDhQRXBjdWNnVXNUc1dTUC9veTVVNFNaRFBLN2UyTmd0eG5ON2xsSkcv?=
 =?utf-8?B?MmdTUDVuZEJGdGxuMitBVXJPYTRJZmhMem0wbUo1NStVR3ZQQUpKUmFveUt3?=
 =?utf-8?B?UkQ4SDYrVEtXQXo0c0FhTHhCd0JTaFlvbVg1SGhPYkZYVkIxNGtZVXRSeEND?=
 =?utf-8?B?QlEwMmNqdXJFU2ZGc0tPeW8vTTAwejBLeXpvWTZ4UVRONldtd1hFbkF6dkth?=
 =?utf-8?B?aDJTTi93eElGRFExWDk0SzhoQkxVZnplMmJZd0dNdHBucFc4YTh1am11QUxK?=
 =?utf-8?B?U25yNFlPT213OVZOc3lpQ2F0bE9nQTVWZTRWU3pnUUxobWMrSGc3ZXppMGU1?=
 =?utf-8?B?bWtVNEhPajVCT3pWLy9aRzBDYVkrMHU3SmpINTRiUVdWZ0ozTTB5ZDhLajI3?=
 =?utf-8?B?ajVsMHdHTWZ3aWJkV01KRzJ1VDhFdG5xYWlYcDc2M2xZOU5VRHFpTk5kNlZt?=
 =?utf-8?B?ZTlsUS9id0hac09sR2RzcGRnekppNXZQQlBiYUprdU5QaWl5M1Q3VEpaL0lx?=
 =?utf-8?B?d1ZyaFlJa2dQN2EydmY2cGs3ZGQyKzVMR0Ezall5UHlMWmZaYnhkZmdaT1JB?=
 =?utf-8?B?My9qYXZXMHBiOGxaZ0ppM2RjV0FXQ1ZJK1FvdHZrdEhLVVVVL2tmdVd4OTdq?=
 =?utf-8?B?RStEMWsrMDNTT2dKOGxFeXprVDNlU2F4NTBTdlI5SHRzbFU1blB5MTJCQU16?=
 =?utf-8?B?dTJ1dmFWSHdpTzJpMEtNWkFDeEdXRS9yTzhjQkxuUys5eXZQNndqcVNWNHR6?=
 =?utf-8?B?SWUvdkVKQW80Y2Y4d3NxN1Q3VzhPZXJSaVdZTDh3R2hNK1RUbk5VMlQ4UGdB?=
 =?utf-8?B?a1N1MUFmdkJiTzNqZ1hWWGM3V3ZRTERNVytnekRKS08rSmtyQi8zT2lySTZa?=
 =?utf-8?B?c2oxUTFGc0xEU3JtQUcySWw4ZEZNMHl0UGNCeEErM01BR1YvUDRLTlRpbjR4?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c29084b7-0cb2-4a7c-1e37-08dac28fa78e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 20:19:07.5129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VG87Iv6HF8iVYlpt8ml5CnR1PzPgVL4C32LmrNr4ChKVPgYfhKX4h63QB56tZMaQqGPr60g4EOY5L3T4jeFLMOjl0+MdjK2QiqOOHuYhOo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6338
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/2022 8:37 AM, Alexander Lobakin wrote:
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> Date: Tue,  8 Nov 2022 15:51:15 -0800
> 
>> From: Jacob Keller <jacob.e.keller@intel.com>
>>
>> In ice_ptp_enable_all_clkout and ice_ptp_disable_all_clkout we use a uint
>> for a for loop iterating over the n_per_out value from the struct
>> ptp_clock_info. The struct member is a signed int, and the use of uint
>> generates a -Wsign-compare warning:
>>
>>    drivers/net/ethernet/intel/ice/ice_ptp.c: In function ‘ice_ptp_enable_all_clkout’:
>>    drivers/net/ethernet/intel/ice/ice_ptp.c:1710:23: error: comparison of integer expressions of different signedness: ‘uint’ {aka ‘unsigned int’} and ‘int’ [-Werror=sign-compare]
>>     1710 |         for (i = 0; i < pf->ptp.info.n_per_out; i++)
>>          |                       ^
>>    cc1: all warnings being treated as errors
>>
>> While we don't generally compile with -Wsign-compare, its still a good idea
> 
> -Wsign-compare is disabled even on W=2.
> 
>> not to mix types. Fix the two functions to use a plain signed integer.
> 
> It's still a good idea to not use ints when values below zero are
> not used. Here both @i's are used as iterators from zero and above.
> The change is just pointless. I would even understand if you casted
> ::n_per_out to `u32` in the loop condition and -Wsign-compare was
> enabled on W=1 or 2, but not this.
> 

Fair. I wonder if the struct ptp_clock_info structure can be switched to 
use uints? It doesn't make sense to have a negative number for these n_* 
fields...

Either way, we can drop this patch. I am investigating where I saw the 
report for this and am going to change that build to not use -Wsign-compare.

Thanks,
Jake
