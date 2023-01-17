Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55166E81E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjAQVDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjAQVCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:02:38 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF454A1E7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 11:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673983763; x=1705519763;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6719Nzg+fhwtjRieMKlFnI6t8MR80ILJCgxBgBsFf38=;
  b=UfFOV15OTj9tXu5TNxJd7VMypDnBR8jFr9o7cRcICz8BPJ85cW9I034U
   O5yHe7WJIgDYaXOC5iOif/R/2MBh+Sxfn1wvlc83hxXzV8hZcUdeBxWAo
   HwLmAgkj0W/L91olHjts6wnK1DDjrhVoVHRVI/d9ecoPJcCZ7o0aima7e
   gBbF1Fbf2mqRYWepENGDcVwMaQvEGbelc4jQc55krabc3qSf1ESpNh89A
   mI8qUCcA6vMJKCQSO3M6cFgooSCbsBIeypjGkFzW76LGfXtCYSl1E5rjd
   R6SiFrH0Hp3PwaG18wFfk5SQ09RZGNApjGBjHFnGYXcEcV7kGAF+B8wQg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326069702"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326069702"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 11:29:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="801862230"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="801862230"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jan 2023 11:29:22 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 11:29:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 11:29:22 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 11:29:22 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 11:29:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNzTnIqR8czMUA/A5PzixoIozwcs3UK/EKMWBLRU6Bt3xP62m183CheXoQegC0qfEFHkSzbvQSK7M25V6nGfqELGN3kCaSKN8NfRCsQ/0rhfYNAIGYydNuoo8xOyqRwDmDrr4rRWeho0gBLTHCIezVn+dsFTUgDs75dzNv7ZGHBE67SHkfBELZERXD/UOzpEBVt26p5viBi2SkC2paHmZNTApfQLJZ7mS3ifOuTyGWKTTrukZyoMx1hxwIVsqiPCFs93eDNUPGhTMbtRSPS/BeyK1dCIYVcvTGTLuYUx3GSNzTXWknUH5Cw44UiGH5b/KOc0ULzIWDYbPKI+GhLftw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZ/44lCwkRZxoMGRMH0r74BW3/3dFnQYFKxnt2GIaQU=;
 b=jaw4W9bczN/yD3pKZYAoEy3HAgIchFhLIfO7qo3tqB/kDLrAL8AhLbf8O7J+neAiNcJo5iVtA5UKo/H8Ld1YI7d6wI/tSyP/wwbkqh/3JQlf5/mQHHmUSN9P6koQkhmqDssfhJCoHKBUxWaUIwYiH0+ZKWIMqDF6AgBbPZB/UH9Z6xRu1M7ICiPXBTBoif03G/NuGEdUvWP7lFwjp/vX0NLlnK/1XGHJAUKxpWX+dJC8nMzec7FsOy3zLZmJT3iH6ym1vd/SRMx8K/8Xz2tolq++Dz82vD5V1EZSUbB1wpZB4oxW4Be41JaMDBS9uTPt2UeXBPaGeOG8GafVH6Tv8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB5194.namprd11.prod.outlook.com (2603:10b6:806:118::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 19:29:19 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 19:29:19 +0000
Message-ID: <937ba89a-42e1-813c-9d1e-975b8dc9616a@intel.com>
Date:   Tue, 17 Jan 2023 11:29:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] net: avoid irqsave in skb_defer_free_flush
Content-Language: en-US
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <167395854720.539380.12918805302179692095.stgit@firesoul>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <167395854720.539380.12918805302179692095.stgit@firesoul>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: e550d9a2-79b0-4a71-6674-08daf8c120d3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+13q+vbNZ7jCZe1yD8SJOAI6roQHC+G4Z70HYZNEfVg66a3DWjXdgqsKdl54+joJWCyzJtvvy+5qebmnr6xGJfKVssYhIcPafOdU7cLifuk87M5KeypGXds+0jkqS1TW9Edtf0m+CPUS8Ldd+nhB69FVdEYIPcdctrSRuKq66shsJJYKXw6hhtQHumHBO0RZwxmHnkvU79uEtus0ZHfoVE4niDKH8jsY0TMrUdort+S5A89u9JtJ5SYOKvt/o2jQMpqglnFl0pIB9gw05ckVjt6iFjDzcgQjHyK5v4uT6Dz2kq+24uLd+9v9lBZAmB/sMHXKHX2h6ri/ZI6/PX8pyMUSC/pK8DD8/17yMQgwyOlSF7dRyniGPIxJR1j35aZMNQoRwRaB60Kgugbin3BoLzWCo7rbvtq16CwiWNDBtazDMFzdxkdyzV9aTr1BKbHO9Z/F0JAbGePBhup2jGb6kg1Raipv/MYuGdrFtEvPXNTFcl7Ia7vU6E+FCzBev+dJbi9+XV8NjodoldLfrkeRMeNCzhsAIpcAvP49X6VPsnwbRgnYXWGwh4eKJMo7i6ux1XFmawqqR+beiGdyk8hPmRNbeoO5aOpDhaaixjfv7wN8n27luvW3tK1rkFLeZgOz0ah8cX2Qp0lMXwdge6gXI1vKl8iQq9lS8hhj0LGCSabXIqMDzuYx60C3Jg5mlVHlzoBcIJBD1gTYqDRXwZvAikjk8Q4H7Q6L37khuYqhk8MfTEIMjWXwkjbqVGrY8slW20KtvZtLfndqYIPoy+fOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199015)(83380400001)(31686004)(966005)(54906003)(6486002)(478600001)(6512007)(36756003)(31696002)(82960400001)(38100700002)(2616005)(186003)(86362001)(2906002)(41300700001)(53546011)(6506007)(26005)(6666004)(8676002)(8936002)(66946007)(66476007)(66556008)(4326008)(5660300002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjJEUzMyUkU5ZTlteFpBSkpuWFlrZFBjWGdlYk05S01lVGZoRmFaVVc2OVVo?=
 =?utf-8?B?MHlJMU1TZ3Rzcmdacm13R01XNW1pa3A2bjdDLy9rQXBQVnpPK1dOWHlEV1pC?=
 =?utf-8?B?TUxGSng5THpYc0UzaHBSdHA4aXBVZ080SmFnTmxGSE5DMDNNM213RktIT3k0?=
 =?utf-8?B?NkZjOW5uck83cWZ3cXAvaWdFK3RRRTFhT3dWMENLTnBtbHRmUTFndHlNY2k5?=
 =?utf-8?B?aTlZbktObzJQYVFoaTZCZkZ4c2xQZEpQYUtMek0ra2dkdW5ZaXV5dnNWMWQx?=
 =?utf-8?B?TG5YakdXS3pnR2E3cm5ZUzJjWTE1T2tXMTZMZ1JQTTl1cUx0S1BGQjkweEl6?=
 =?utf-8?B?bXpNUzQ4aFdLUnpKakdsaGg1SzZLelBiYTBQL01jMEtiSXZpMWJMbGMvbGNx?=
 =?utf-8?B?NlZGN1R4OTQ4dkF1S1RUZmlDSzZNZEdnZWlxcVF6Nk5USVcwZWVzeUVjaVpL?=
 =?utf-8?B?RHBoQUNvUHl3UHhzRm1HTGJtd3BRR1hLWW0yQ3U3MFJiUnF5QVZzdnhDamRW?=
 =?utf-8?B?QURZVkVuNmtveElkNnVleWxVTWQ1SkdOU2NRRHFreWN0N2Ric3FqVlBvQlRK?=
 =?utf-8?B?SmN2VExTZkdXalpMR285KzArV1E4eGEvZFAxTjhaSUhaQzVvY09vUDdkUVRV?=
 =?utf-8?B?c3B6OW81L1JuYWtWdzQ5dC9pcm1MNXNIcGdJSUlINE5tNS94S1VrYWFYSklj?=
 =?utf-8?B?ajVIeGxFSWZCZExTYXpSMVIwalBJWno1QWVFVm5VV0ZSZFFTTXRUTVc3QWho?=
 =?utf-8?B?TDhyN3M3T1duTW5TMDNyQUlKbDZYVG9YZks2ZlhYcmJPN3ZpTUd1dHNOUGdu?=
 =?utf-8?B?akFHN2lJRm9GY2ZOSm43ZHVKZllSY2pxckJVcHI1U0ZUaUVNckRqcXdac2JT?=
 =?utf-8?B?eitYVFlSOHd2bVcrL3pzTmx6YThXa1VjK3dRTjVBZytveG1BY3E5a3BVaDR0?=
 =?utf-8?B?WlMxanVXNWluS2lJdXVqUExERFFZUVpld0NMTmtLOWpMSktEd2RpT3Mxak5G?=
 =?utf-8?B?cmJhM3BKM1UyalFrZWY0K3ZUMndBREJQYlY5bE52OUF6THJ0QlpIb3dSeTBE?=
 =?utf-8?B?emcrMi9IOXlwTHpUQ0lIRnd3YUFOZCtlQVh2YVhBclBEdFdTTnZjOFFaaDFw?=
 =?utf-8?B?MFJPbGdEN2h1L3Q4Q3lrYmdydGlRcndxMmVwWithaFdGbVRlcHJIVXlMNVNn?=
 =?utf-8?B?c3VFa2lLTWNvVXhoMk9uS04yMkpsWVFKNnJsWGxtUUlFQXFtWEd5WmJpY0dU?=
 =?utf-8?B?Qko5VHJsR0FZMytXcEgrZlhmb1JaeDcxT0FPc2pKQTcwWHY0NFE3Q2w5RXpK?=
 =?utf-8?B?eElHb2k0U01FRDhVQm1lY2drQzQ1M2tZd1RPNmt4eWNnNjk3ck9WeTUxcjdC?=
 =?utf-8?B?cmpWMnU3WHJSTU1GaE4wTmVLUEYxK1Z5Y1ZqYnhYRXUyVURkNmlCSVM4cmxO?=
 =?utf-8?B?dFBJWitqbkdoTUp4UWVvazlpUjVtSGFEZUM0ZUVPeWdhR3BXbGZWMTgrYTZp?=
 =?utf-8?B?elpWS0U5dGxaMWdhOC9tc3lwZHhVL2F0N1MxckpxNXdYOXFpcWVWVERjNXps?=
 =?utf-8?B?L01IUVhPUW9weTNiSTY4MFdVeEx5c1R5WVFvdGhOMkhTZ2xtTTZ5M2ZHWEdD?=
 =?utf-8?B?RVNtRDBqVEI1ekE1aStjaXR5TzIvbkI1T0FaT2FRY0JHWHNKZm5JRnRtN3RQ?=
 =?utf-8?B?dGZ6UHJMcWNBOUVTMkZKZ2NHbFVSOGRWQzVBYVlORWJHY2hDR2FCZTdRUkdu?=
 =?utf-8?B?QXVuV3hRVnZFbHZ3djBJdndhUWJhUDNiT3g5K255RHR3VFpaYnV4c050ZFNM?=
 =?utf-8?B?M3pDSitBdisvdXUvRG5acGZVTU56RG11dUZNWVozNHlFaU5GWnZMUEhMUWs3?=
 =?utf-8?B?Z2lMWUxZYkxCZTVDdVpsZTFjcU1TVVUwYU1Dd2MzVlB2a1RFMUI4MS9ZMnZ0?=
 =?utf-8?B?VnRSbUFna2FxZmw2TE9ETVhVdTZTbW5YQjhFeDFzUjdnUjNHVnlpSldBM0tT?=
 =?utf-8?B?NklOUUYwY1V6NGw2UHp5OXRUUzZSRHdxckpYVXU4R1N4WHdHQVhGSVhYN0hN?=
 =?utf-8?B?OTZMU2M4bkxrdERYRGczYVk0Z0QxbGlIZit6eFpJRVZBSGxuZnkvZWZUVi9N?=
 =?utf-8?B?WDJPK09qbURLMGVkUlRlV2s0dHFJRzI2ZDg1K0pZbVBJTGdhR01La1hUT3hu?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e550d9a2-79b0-4a71-6674-08daf8c120d3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 19:29:19.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgJpoE+12Jvngx5qJR5bSMRsLKRKb6eZx3CRIrbf8NP8w3EHSAVxElDxqFi4PIaMl5KUbpN4HvhhUDb8ks5/AxhXrR+ca8WCiWrqKG3Ukus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5194
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2023 4:29 AM, Jesper Dangaard Brouer wrote:
> The spin_lock irqsave/restore API variant in skb_defer_free_flush can
> be replaced with the faster spin_lock irq variant, which doesn't need
> to read and restore the CPU flags.
> 
> Using the unconditional irq "disable/enable" API variant is safe,
> because the skb_defer_free_flush() function is only called during
> NAPI-RX processing in net_rx_action(), where it is known the IRQs
> are enabled.
> 

Did you mean disabled here? If IRQs are enabled that would mean the
interrupt could be triggered and we would need to irqsave, no?

> Expected gain is 14 cycles from avoiding reading and restoring CPU
> flags in a spin_lock_irqsave/restore operation, measured via a
> microbencmark kernel module[1] on CPU E5-1650 v4 @ 3.60GHz.
> 
> Microbenchmark overhead of spin_lock+unlock:
>  - spin_lock_unlock_irq     cost: 34 cycles(tsc)  9.486 ns
>  - spin_lock_unlock_irqsave cost: 48 cycles(tsc) 13.567 ns
> 

Fairly minor change in perf, and..

> We don't expect to see a measurable packet performance gain, as
> skb_defer_free_flush() is called infrequently once per NIC device NAPI
> bulk cycle and conditionally only if SKBs have been deferred by other
> CPUs via skb_attempt_defer_free().
> 

Not really measurable as its not called enough, but..

> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_sample.c
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/dev.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index cf78f35bc0b9..9c60190fe352 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6616,17 +6616,16 @@ static int napi_threaded_poll(void *data)
>  static void skb_defer_free_flush(struct softnet_data *sd)
>  {
>  	struct sk_buff *skb, *next;
> -	unsigned long flags;
>  
>  	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
>  	if (!READ_ONCE(sd->defer_list))
>  		return;
>  
> -	spin_lock_irqsave(&sd->defer_lock, flags);
> +	spin_lock_irq(&sd->defer_lock);
>  	skb = sd->defer_list;
>  	sd->defer_list = NULL;
>  	sd->defer_count = 0;
> -	spin_unlock_irqrestore(&sd->defer_lock, flags);
> +	spin_unlock_irq(&sd->defer_lock);
>  

It's also less code and makes it more clear what dependency this section
has.

Seems ok to me, with the minor nit I think in the commit message:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  	while (skb != NULL) {
>  		next = skb->next;
> 
> 
