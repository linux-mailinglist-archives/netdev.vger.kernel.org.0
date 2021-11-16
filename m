Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CE8453898
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238892AbhKPRhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:37:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:9713 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233537AbhKPRhq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 12:37:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="232468379"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="232468379"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 09:19:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="454322572"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 16 Nov 2021 09:19:54 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 09:19:53 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 09:19:53 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 16 Nov 2021 09:19:53 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 16 Nov 2021 09:19:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0y7G7Y6Nig1C4smkBP7ZLUa8Hh9+4pe6NulAOX9GVL49B4+xCRiT9tp9lKSUlsSdEHh/5ZgL+oB0P5P5zNUE+mryPPXRryy+Ekqm45nzx4CqPVjwaGzHWdgTuFHqr4ETa88BgpjbnkLB2K/29o3NtfEJEGWINl0Bco9SkYBjSKlk4gMIiuR4aCgRRiubqMSjxvym+X2If5AAZA7gDSgscpiTRr53zFloLft2U3JwuR8Ntceq92ojYgf9mylPirgcWi3GAfobbeiSRpSCbxuj+zOztzIurN/lqqORkCgxhzxyrOGDAmdnKT+3hIfc3EwqTAWW1GdxE2vk8ztWHffhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H4+UXQUg7j6boDKH8O5UH6hs3R1YMhMEO8SkirVQTRQ=;
 b=LkUabjJg9dcqPAGsTGgp8/GfHgxzanUL7OtFyjtCLOAWF+ndY45Z/xwgcaukEtY6Wqx1wjg2NgRXegmgcwmYfgKfyS3OcwP+mIktKs9UC3Iwr8pzEYOL3YzRBrygjZhoAsR/n+rkvGh34B1sI/4WDda1g8kc/erCey81QjFYOM3NNYLdi+m0m68BZdp4roQDXyo5iGOBjqD4evyFL77wQriMTRFvV0jRHOb1/yln2S/zgF4RgXAw+iOw2ugyvJuLMvpZQ/CAkQ8NSzXlaniSSinfmAgxGh//6q2MEPSevpva1/OlahqVHIqwbEVx0QlLle2WmWg9ddjZ74IieIqtHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H4+UXQUg7j6boDKH8O5UH6hs3R1YMhMEO8SkirVQTRQ=;
 b=TEiatnZyF77wLzPYktvIR5+leszUcrUTdJPcN8AGdUPn2YTocewLKO9dqh/YGrsOExw1z/nM3rDJqpweaz5THnlESXt+Ku320lJ8fsQJU1SHvN8whgPDcMKh7cTRHU1hygHjnc6BmY2bKJMQ73XuyiG2FdQjSpDAPAklkdrgbH0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) by
 DM6PR11MB4706.namprd11.prod.outlook.com (2603:10b6:5:2a5::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.26; Tue, 16 Nov 2021 17:19:52 +0000
Received: from DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::1c89:2776:b68b:6ce5]) by DM4PR11MB5326.namprd11.prod.outlook.com
 ([fe80::1c89:2776:b68b:6ce5%5]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 17:19:52 +0000
Message-ID: <ce7f36b6-fa4f-f6a4-a055-28893069cfa0@intel.com>
Date:   Tue, 16 Nov 2021 18:19:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: 32bit x86 build broken (was: Re: [GIT PULL] Networking for
 5.16-rc1)
Content-Language: en-US
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>
CC:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        <linux-can@vger.kernel.org>
References: <20211111163301.1930617-1-kuba@kernel.org>
 <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
 <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHk-=wiNEdrLirAbHwJvmp_s2Kjjd5eV680hTZnbBT2gXK4QbQ@mail.gmail.com>
 <20211112063355.16cb9d3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9999b559abecea2eeb72b0b6973a31fcd39087c1.camel@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
In-Reply-To: <9999b559abecea2eeb72b0b6973a31fcd39087c1.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM6P194CA0106.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::47) To DM4PR11MB5326.namprd11.prod.outlook.com
 (2603:10b6:5:391::8)
MIME-Version: 1.0
Received: from [192.168.100.217] (213.134.175.214) by AM6P194CA0106.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:8f::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 16 Nov 2021 17:19:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d19ce72c-2b8f-454e-fb7f-08d9a9254d0c
X-MS-TrafficTypeDiagnostic: DM6PR11MB4706:
X-Microsoft-Antispam-PRVS: <DM6PR11MB4706979B477FDFE095BAC2ECCB999@DM6PR11MB4706.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWi75tC5zG8hBXgvibZ9RSXxglGKIIi7oSqCo3ez+Y8yup8x2j+OFJ24JbVsolMwt5+/o5HWJYGhrTaJuYL5Yoo6pO33S2FtYN328rgeMVN8QPqfAGGwjlTHJtcE98rkP2P8/wLXkEn8iCJfIQxMXopdt8XfrYX6Hdfysr5EWfSQOA8P3qcgoJdunlo/43AJlnhcobvSp0G4yxGT7Bc7gCqpnV6DaAAzm2Uz0YoJqiAfd/lU/1S648WTUdw9DVvpG6aqyhLLBMK2z0fHxZuHNO18ThcunPzohCr6CPgDf2rZzKIKUGYIA5T+L11dWApnjrU+JhSsU/VbsW4D19nKaKSvOJ/QO0gi+Uk+QJVXBAWK7vkuUZemFCJcdpxzut1FDwkUdapvZAjqqyMY7P9GFxMbWftHy9yEYQO7zSkIIJQPcxlrPaom5/BnhTCRgdt6+BtQ9dMFbC+UcxeG82Kgt1L3nUKaLfqnHgBPb/EAz5MZz6T7CNLgLsM8XM9+Nwob8ID2a25lneouqxsdKU9jNJ/D5HxYhFZJkgf7Eg2e27zfdosrTaHTlxlekswCaLaDimZGbMl+Oe66Kcb/0w3iKYfYlZwHmWXfIFiYf/AGLjau7tvTMr6QUkk6z3F0ZucLosnWC0lmwn6B3Vgnm/SnTBgASzusufiHlgZcYNnLLjrcI/WqPDubZXZRiGXgy/EHNHg8WiwG5DLxEY8rsViaGWlJLvm7CsyC23UjFqKF6pM4Y6i/5sXjXiG2wcIZSWa2ZigzO88qVrTgvx50yk+x+Ed1GjPLYfMxALCMbCjcYD366gnsesxAgI4TvBUfrSUg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5326.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(316002)(4326008)(5660300002)(7416002)(53546011)(16576012)(8676002)(36756003)(38100700002)(4001150100001)(54906003)(110136005)(31686004)(8936002)(6666004)(956004)(2616005)(86362001)(26005)(66946007)(2906002)(83380400001)(31696002)(966005)(36916002)(508600001)(66556008)(66476007)(6486002)(82960400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bCswNHM4aUM5MEhsWHByZVUzbTJMMHhNWUlVMTNMbElzNHpTZ1dSNGRFTDBL?=
 =?utf-8?B?L0FZT1BSSWJVc21Ba29HOVZjalRTdlFQREpVZ2YzWXY1N0xZWFVWcmhrVXI4?=
 =?utf-8?B?dlkxUktHT0tjdTU2bXV1bkppdEhBb0FTUnJ3eFg0WHgyWGdJU0ZFdHI0Y3Mz?=
 =?utf-8?B?NTlLOTFLeURqNU8rNnZxcVF2NVhudFJUVmxhb2RJb1hwSnd6OG1KWU41RERi?=
 =?utf-8?B?c2RYM1RFNmhKYXlqcUMxRXg0NDAvRUlRbHJHUWJmdlc3Q0pCZENuTkxJOUNu?=
 =?utf-8?B?WVRLRHVBTmNrZmJFY1VLZGw2N1I0RlpVT0tSRVVma3QzNkM3Y08vMVY1L3Vx?=
 =?utf-8?B?VHBkb3orTTV0OWl5YStmV0lWMkhXNGlHeFlRLzI4Z0MxZVJWUkwwUmNzR1Av?=
 =?utf-8?B?QmZ6YUVCZGJ6THVTUHdyYUY0RXl2LytjMUJPcVJPSG4xZzFja20rUVYvbGV1?=
 =?utf-8?B?dzFlbENLMHBlcnVhMUNOeEhMZHh2ZVFVSHNRcW9VTzYzTXVNMHEvQnQ5YUdy?=
 =?utf-8?B?dVhzUkZ4b1FieHRiVTJIcUZoVENTc1VsS3RWd0c1T094dmhyZHJLSml4MDE5?=
 =?utf-8?B?MzU5c1Nib2V4Rkt0VmFJaUg1YjdUVUVUOXZNd1VMVVlIbGNNNzhpKzI1cmJP?=
 =?utf-8?B?bjlQeDZQV1lnZjh1RWt3OVBOODhWL3J4Y0VkUUFrSDU4cDdTL2o0QXhQRE9k?=
 =?utf-8?B?K2N4SU1WNkRGbnl5bkxEb2k3L08zQXdZVzBhQzNuQXR3TDNZTUt5UklZSXJM?=
 =?utf-8?B?Z2tLdE9QWXlTNFNSakozL0JLSStlcWh6cUtQajJDeTFFcjBnSXFBb1ZBU2sr?=
 =?utf-8?B?SDAzMkdzZUxZclFSUEI5eUdyVDVrSG0wU05OeUFvR0sva2tCZk45V1hKTFV1?=
 =?utf-8?B?aXdXcWt4VVNJSW1hUlh3cXV0QnlCWlZBZFdSRUYxMm1tRnNLMDluWDVqeEN0?=
 =?utf-8?B?YndqbG94NldLUU9UMDJ3dTBIYUUvVldWMmEvaWR0MC9MUXVFM2E4MTNuWE1h?=
 =?utf-8?B?OEIvTXhuZG5uOFI4TTV4TDkwb3BlOWdncVhVVXNmSENTODBPNGpYdm9vQ1d1?=
 =?utf-8?B?ME4reWk3eVc3b2lzc01laGtkeFVrWHhCTzN2ZXhzZjlGUHNaUURUMjBMSkJJ?=
 =?utf-8?B?cUxxOHRpUVJnSmhUYVBuMkloR1pPSmlRYWtFend6K1puTDNQV2xoMHFiT1NO?=
 =?utf-8?B?R202d3lXcWRHU2hKeFRZci9FY1Q2V2YxaEZYRXV3ellzbFA4R1A2cHlVZytR?=
 =?utf-8?B?bmFLc2tXV0x6Q0JlZzJOL2o3VFBIS09hUXdXdGFHVDNuR2wxQ000MjBDY3ll?=
 =?utf-8?B?Q2l4dHJrWmh6UjYwaUJsL2VWb2I0MFBKdUtEVGRhSzVIdTZTa1pXMzJVeUh2?=
 =?utf-8?B?akhPUHhCKzlGUDdSRndPVVN0QVAzTUVDNUFsMmZFdW5JWGJraGtEVG92ZXBs?=
 =?utf-8?B?ZUhHYXZIZW1UWFZEN2R2b21nYVlvTzgyVTFrN20xQ0hCWS9zWjVFYlR4cTQ0?=
 =?utf-8?B?ZTJKeElYU3ZkSi9EWGRLNSt4bmdWRkRFeW55ZHhyOUgvSHJwWjNRVS9Fa3Rz?=
 =?utf-8?B?dmplNjBrOE5SL2FHdFJsM2RvZHFicDZRUWd6YStmdXFGbUttd2JlMEpPa2hT?=
 =?utf-8?B?UHB5Vk1aZmQ1RHlGRHRmaWVxK2ZaSm1XY1A5SDEyc1ZoMnkyUFFKMHlCZXRD?=
 =?utf-8?B?Y09rbVlnRXVKMGU2ZXE4L0pIQmhBcnFHVUUrQlZJRzRXMHo1VXJkQnBFcnNH?=
 =?utf-8?B?MEdYTHplN2pUOVZQVE5jN0dER2UxTFlENTZyUzdibkZMWGFCcHdyNm9hNENR?=
 =?utf-8?B?RWk3VlB2SzBFWkwvMmNKZkd0aWVmazgrNXlLUnU3MTFnWDh0WXVFTkFiSEhk?=
 =?utf-8?B?bjJvNGNkOUxwNU9RU0R6ZnpGL1ExVmFpVlJrbWlDcU1XK24rdGxTMDFTTFBW?=
 =?utf-8?B?MGFsVTNlNU9SNmRZRVVZSEJMS0JpNzFzNU1nZXpIMDJKYkhFcXJDcW5YY05m?=
 =?utf-8?B?VE1tcWp5amV2R2lFUDJHUU14eURWa0FYbkNLUTJielFYSUxhdXYyMitQOTR2?=
 =?utf-8?B?bW1QU0wweVc1WHJUaTFrYUp6SGs5VUFQK2ZlbGdUTkpvZVpLOFFkVmtBcm4y?=
 =?utf-8?B?THdKQUo0NnhoSU5HbTA0RlZjOVZPVWsyWk40Y3UwRVhubDBpR3FKSlBJNlUr?=
 =?utf-8?B?cGdVaWdOTm83NWppVGtESnh2OXl5U29uM25ucjRaRmR3Qy9ndEZpUFRaMDJO?=
 =?utf-8?Q?SewpFPfwlnyYy6XP0/yxbNGneXrX5zjR6bBXCuRbc8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d19ce72c-2b8f-454e-fb7f-08d9a9254d0c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5326.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 17:19:52.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obQdnXBFobnqYw+7ujxyhBkIEk0uWVVsEqeOlJeU7Bgbkw5Bq/MDoFU81yaS/G49DnLmri2AvoC9xw/8Ck7lz+bQLzac5/8/+9jxk/eHKTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4706
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/2021 4:04 PM, Srinivas Pandruvada wrote:
> On Fri, 2021-11-12 at 06:33 -0800, Jakub Kicinski wrote:
>> On Thu, 11 Nov 2021 18:48:43 -0800 Linus Torvalds wrote:
>>> On Thu, Nov 11, 2021 at 5:46 PM Jakub Kicinski <kuba@kernel.org>
>>> wrote:
>>>> Rafael, Srinivas, we're getting 32 bit build failures after pulling
>>>> back
>>>> from Linus today.
>>>>
>>>> make[1]: *** [/home/nipa/net/Makefile:1850: drivers] Error 2
>>>> make: *** [Makefile:219: __sub-make] Error 2
>>>> ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:
>>>> In function ‘send_mbox_cmd’:
>>>> ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:7
>>>> 9:37: error: implicit declaration of function ‘readq’; did you mean
>>>> ‘readl’? [-Werror=implicit-function-declaration]
>>>>     79 |                         *cmd_resp = readq((void __iomem *)
>>>> (proc_priv->mmio_base + MBOX_OFFSET_DATA));
>>>>        |                                     ^~~~~
>>>>        |                                     readl
>>> Gaah.
>>>
>>> The trivial fix is *probably* just a simple
>> To be sure - are you planning to wait for the fix to come via
>> the usual path?  We can hold applying new patches to net on the
>> off chance that you'd apply the fix directly and we can fast
>> forward again :)
>>
>> Not that 32bit x86 matters all that much in practice, it's just
>> for preventing new errors (64b divs, mostly) from sneaking in.
>>
>> I'm guessing Rafeal may be AFK for the independence day weekend.
> He was off, but not sure if he is back. I requested Daniel to send PULL
> request for
> https://lore.kernel.org/lkml/a22a1eeb-c7a0-74c1-46e2-0a7bada73520@infradead.org/T/
>
>
>
Sorry for the delay, I'd been offline for the last few days.

I'm back now and I will be picking up the Arnd's patch shortly even 
though the simple fix is already there.


