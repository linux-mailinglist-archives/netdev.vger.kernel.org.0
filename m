Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D3064E1CB
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiLOT3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiLOT3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:29:20 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2197854364
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671132552; x=1702668552;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VH4wIPbIwPFgX3Q6oe8tz2+V2zZHNdn4zGEignJjrfQ=;
  b=WyeYNnmJZSh1OvZCKL4w/tqxZPFXQGpPCMZ80hhATb3++p5btUwb/TFW
   vy9PoKt4qMrows0yIp6bO6/QOhkws6yCzEo2X/jzc5tT+eOXETKYwlsNh
   vct0fNpSTgEL1k8N30hme8eWbe1OrLTzh3wJyTRbmX7R/Tl7cziTJVnAA
   6Xqa1dOuDWhJwMX8VXzJkRvVuxAD9CxeOP1G6ir6m28+3Hiex0QAQbSMW
   Yv6BIME5MkgKzMiz8xU8jyyF1EdVw8+Gt/lqXecK7hNSiTZFMM783fSNO
   Xf46k48Qxh9XSW/Mr8athnwTGeJaVcXo0FkqO5tal1/0TjbDu5eaAPflF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="320666718"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="320666718"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 11:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="823848320"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="823848320"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 15 Dec 2022 11:29:10 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:29:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 11:29:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 11:29:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QA+AtmWfO1/zOpXvb+l7EH789MoEx3NWzhDL5RgYomtZgzDyeoz/JkAw3e6HamcUuTxubNR/YOgibFZT92nQoimRQcSxsUsm3aonx3Vo3G7h5Co3kvhP6sBvURnVwMGK6b2EPJhw/LC0tN0DiP1EZfKiK+vdzCptgayiltqYkLXebUP8MQe/7RxpWDKYtpFAqqv58pI5tDiP+xxCUBeg+tySi1zyO/pRtoMVVha+SoWQWvlx6pLeFjyhXfgS4PBah3zR9fRi2BtQxaYnC/fsdxfbdsHQvwmlcYnplYCeSmxhL385Rwh3OuhQYkSyVXi3u9yUQ+gDWjDkGwHT3ZTDvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eUCVbG1889Cx6YGfXOQJ9CDh/yk01wv98/tvpFoTkk=;
 b=FPEIy2vE/GMkn10VKm4tdZ+B1L1m4YKhVofV7Q+lqWdjUbbwO/gjpfM8KTzVjsNZCL+2GXhFNDy/UsT4mYhL/4nN6rXittZTkh49VjJFPy1k0UBOki50lWu84NREsHv8CJzyftjnNTd5y0E9dHOT5hFHKjLW9Gn5GVg2JGmmuNybkOFDtLBuYhUdD2OWDMUyZTq6W3Hk1udNaR3fubdU928De5s3pl/LNvOR0jLCwXBj4+sKwLQYE+olJ6/VwIRAXATbfHFSpE8C4CYyUVzCio0ItRg7nnUlDSqDZ5J2YQSEdBBvKsBmnU/4CYzzZbfN6O/YiTqM3E16rf2NZd3/XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6246.namprd11.prod.outlook.com (2603:10b6:8:99::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 19:29:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 19:29:07 +0000
Message-ID: <c7c98e4a-5f41-2095-c500-c141ea56a21a@intel.com>
Date:   Thu, 15 Dec 2022 11:29:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated directory
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-2-kuba@kernel.org> <Y5ruLxvHdlhhY+kU@nanopsycho>
 <20221215110925.6a9d0f4a@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215110925.6a9d0f4a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::17) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6246:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e50f20-3cfc-4e69-c056-08daded2a1fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eq+u6sGR9qvE7Coagr9wtIuNPlNkpo8x8Ej88di5rk7NnRqKyhgan9KlX6XojU4RedXpUSMFR0YvidrTG1BSYPQFFbaphgclVbum+ycXIaB8atVCIMizSFv5/O4t96aBfKDCpu9CNlxCHX0wNKV3/6Q7PcoKNhjBft48aIVugLTjCr3bwKdl7us94Hb7fu2uhlZz5g5EFZMMv+MSB7FRJYOPkXq4QhxDZf1fIZ3yJJSRYYO/yIOAgtuXaWCH59w/wExwegNW3aqjpuHurERO7vHJNX6AIzL6UMFI+IoZn2gCde/cycdpIG+waM4l3m3Di7+V4ButjP+rt/hf1d6JxwWzxIHB9xx1E+olS4r0TgoT/MdKfbt3Hact323fngacJ3CkJ3NqSMAiKLsn/AUIJADNxsFYWNT/M5xaQEjKGiF4m9nqNW2c0FW+uTpGLD6AjGmM3EtOPyhRc3XcUwlskdaQOCaG3DICNuVSbRbU+V3tKCzacUdXVMCXU6KacO8IrLyk5A0oKkfHIsSNRFduS+p1FCJA+dP08WAwkW0G/miqkav1loHg25awSIEn7iPP/v3iH5JdEYyoKekZoC8lkKxISqXf/OdrmWMiS/6W7bcftVqk6qD2NnvPQfU1CXElttJYZSaH0zjuoS5dzVCrt0ON0U6RApb21dCawK6d5nQDG1Ku9EjEc4CaxcfxxvbB6ZrWPaQL85RqOB5NA3j2boucC4YuQSuv6phRIF0asTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(376002)(366004)(346002)(396003)(451199015)(6486002)(2906002)(66556008)(4326008)(8676002)(66476007)(316002)(8936002)(66946007)(41300700001)(110136005)(31686004)(83380400001)(6512007)(38100700002)(6506007)(186003)(26005)(6666004)(478600001)(36756003)(5660300002)(53546011)(2616005)(31696002)(82960400001)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTBqSzd4RzEzVzZUSWVKenFyb3EwWW5FL0hLWEMzSXN2RXpwNHRhMDN5UnVC?=
 =?utf-8?B?Q1NEUDhtTVdGSERJQUQwdmRhb0FzOU8vbTVxTms3ZTNCckhmQ1phU1laVktG?=
 =?utf-8?B?R3pEQ2ZzMWMydFd5ZXJuWGRrMldzOTlxdC9TbkZQQlFOTUF0RGpOVzhjdUVD?=
 =?utf-8?B?ZGV0NzVZY1pnL2Vjdktia3A1T2hJdmpJeEI2bnlTQi9mOFlnQ3Q5TFJhVHJw?=
 =?utf-8?B?aWlpcUpPcllxcHZFQmRtQUFSeGJTOFZZb1VpVjB4Y29jRXV2c1lNZGRtODg1?=
 =?utf-8?B?MDVYcHhXQTN0UVpEbXoxTkIzZ3ZwQjdjZkdXd3B2T1Q4U2tYdnFWM1ZibWpL?=
 =?utf-8?B?VUdaSEticVZOWW9xLzNrNEJzWVpteURaVmpVL0Ird0lPNVZ6MXdRbktJNC9y?=
 =?utf-8?B?d29naVVLOS9lQSszV1VxcnN4TC85dGdENncwajhYZWpDL1k2TW9aRmZCMkZq?=
 =?utf-8?B?OXNPV2hkdjJGdHlObjJoNHlEaU9aRmdzMUw1dEpJTC9KZlNudTV6THNmRGZS?=
 =?utf-8?B?c3lYSWNsUVpRZkFuVkhONHNwZFl1MkhJS3RNMEdOYjVTd3h1c0daYWxOYmdW?=
 =?utf-8?B?MzNOWkR3T1d3RTdYVDk4TG9VTWRmQ3IrbWMrdTFVaGRjUWdsSHFheFcvaWhR?=
 =?utf-8?B?ZCtYNjcyNzdPUUxRKzJsbDlZd01SSWZjVFF5ZXdoOHFHTzFsTE50TGExLzM3?=
 =?utf-8?B?T204RTJwNlptOThRaVlCVnRVbXIvN0VYVE0xRDc5UmpRWS9RNHZLUkVRZmV6?=
 =?utf-8?B?V2E2MGRjcHV6NmhMVThpNnorSG1tQktwZnVaZzBxV1pobXZlUUpEVmxkeTE5?=
 =?utf-8?B?TnNsWElFTWVZd3N1ZU1EUWlGL21RM3lJY2QyUVRla0F1TVdyelE4YjJraUxZ?=
 =?utf-8?B?aG5uVjBweDA0ck8wZExURk5xS1NTUnpSQkN5MnlMcDM0eGZ3a1pmOC9MalZo?=
 =?utf-8?B?THRpTVA5VXA0bUNVSWdTTTFrZVNmZEg5RWRQaDJZT0pMVVcybWplNEY5Q2xG?=
 =?utf-8?B?dFE0Tm92NlVWV0hSaUJMWnVidzBoOE82ekgzRHF5WXhyL3JHYmhobExlWU5L?=
 =?utf-8?B?T2lEWGxiV0FIWmRrdytmMDFiOGtDMEVtRGRJV0pIeCtNRDdPRDBPWHBXYzJG?=
 =?utf-8?B?d2VMdjBqOXFUUHRjdkoyRHNJeElRZDNoc2F4RC96L3Zwd044NGFPVW9VZ2hC?=
 =?utf-8?B?bHhaOEx3Y3N4dTltVHphUWVLemx5bUNGUWNxVHpFZW13R2RSRTZUaTF3bHpi?=
 =?utf-8?B?Y1VGSm1XMXNyMG9EMHZpcUNKaktuN3hwaG1wSWVnaE1TdU1iRkdyWGVZNFZx?=
 =?utf-8?B?R2lqRHBMM3FZN0pMLzNYL0V0WjlUZkM1RXJWUzd6UHUwckpSY2RTU1NGcVNL?=
 =?utf-8?B?dWx2L2VNZm9vNVJka04ra1hYY2R5dXhCbHpOVi9PRmlYeVU4OGFvd3U0Rk0y?=
 =?utf-8?B?QURRNTQvY05sUlZzV3FLTThUUUlyVG5PN01xSW1Qc2FISVJXNHQxQUU3M3Nh?=
 =?utf-8?B?cUhmYWY0aHB4R3h1UEJzN0dhMUZKV2RNT0FibEUzTzdobTlibnY3bDhJTXlF?=
 =?utf-8?B?WDlrck0yYVRMaVhJaXlkRFRKdTRycFJPaE5wNFIrZzNTWHFkY1RLcXo0YkUz?=
 =?utf-8?B?MlJYSVkvRmM1dkhIOGQyeGxLMTJ1b2ZwamlucHVFbmM1U25XaVZIUWxoUEp3?=
 =?utf-8?B?UDFla2VISWR4QkRnM25LZzJyT0tWN1Q1Z2VzbnRLNVVnTVZPRGs0V254V0lT?=
 =?utf-8?B?NEJKVzU1eE5xRVROL2xJem5pQnFqWUg4eDZmeHhwbTJSSXhzWmV1WnNhOHJl?=
 =?utf-8?B?MGxWdVdHL1lhK2YvOVdrNTE5dDFQL2J1YVRFQ2l0OTh3a1lmdi9RaHVJcjNC?=
 =?utf-8?B?ZnRZRldFbGY0N0dJTElKaU5IMHV3MTd1dEpXVmJxdTlhaGF3ZTlPNXhPUFlX?=
 =?utf-8?B?YjUvSTBLbEVGbUNIQ01QSzJkYzRRRlZZQnVWa0NPeVJhQWZ2WHlySlJrbTNk?=
 =?utf-8?B?SWk1R05NVGNYajRZNi95d1hrOEk0WEhLTE9sTmhkWkZhQnJpRHJNQUxaMjJN?=
 =?utf-8?B?SEhhSXNNMVZpV3dPM3hUbE8xOVZrR21iUG10TlJIcGxhczZtMU9HWitDZVJR?=
 =?utf-8?B?T3QvNHZWbjhjcit4eSt6TStPc1M0STNEdkdpQWM4MlJld2NKRW9CaG9KUjUv?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e50f20-3cfc-4e69-c056-08daded2a1fb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 19:29:06.9881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXB/h50C+DDDr4xljJCL7x9gfShnYcWIdBdXZzQ0S9OTRqTP8XTg6hiOEns/hVxJfHgSlw87pGbH7d/GZ7HABirFUtsgVcBCsI44+IXcbUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6246
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



On 12/15/2022 11:09 AM, Jakub Kicinski wrote:
> On Thu, 15 Dec 2022 10:51:43 +0100 Jiri Pirko wrote:
>>> net/Makefile                            | 1 +
>>> net/core/Makefile                       | 1 -
>>> net/devlink/Makefile                    | 3 +++
>>> net/{core/devlink.c => devlink/basic.c} | 0  
>>
>> What's "basic" about it? It sounds a bit misleading.
> 
> Agreed, but try to suggest a better name ;)  the_rest_of_it.c ? :)
> 

I tried to think of something, but you already use core elsewhere in the
series. If our long term goal really is to split everything out then
maybe "leftover.c"? Or just "devlink/devlink.c"

>>> 4 files changed, 4 insertions(+), 1 deletion(-)
>>> create mode 100644 net/devlink/Makefile
>>> rename net/{core/devlink.c => devlink/basic.c} (100%)
>>>
>>> diff --git a/net/Makefile b/net/Makefile
>>> index 6a62e5b27378..0914bea9c335 100644
>>> --- a/net/Makefile
>>> +++ b/net/Makefile
>>> @@ -23,6 +23,7 @@ obj-$(CONFIG_BPFILTER)		+= bpfilter/
>>> obj-$(CONFIG_PACKET)		+= packet/
>>> obj-$(CONFIG_NET_KEY)		+= key/
>>> obj-$(CONFIG_BRIDGE)		+= bridge/
>>> +obj-$(CONFIG_NET_DEVLINK)	+= devlink/  
>>
>> Hmm, as devlink is not really designed to be only networking thing,
>> perhaps this is good opportunity to move out of net/ and change the
>> config name to "CONFIG_DEVLINK" ?
> 
> Nothing against it, but don't think it belongs in this patch.
> So I call scope creep.

Right. I think this patch set focusing on just the iteration for dumping
is good.
