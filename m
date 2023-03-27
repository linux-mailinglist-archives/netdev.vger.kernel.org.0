Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AB46CAC47
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbjC0Rwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjC0Rwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:52:31 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B731270F;
        Mon, 27 Mar 2023 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679939548; x=1711475548;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8C7qiAaGWXdcWH5e0gwd8WoShFTnO0L4h6ZSfsB6Mao=;
  b=cUQCaONyBkug5PZFamxbfDv6eLHA+hVylaL8kS+nBQJGkh3drTdjHvuv
   7RWeFPJocvXzDBQ9owIR1dJTL5RtOqgxjg6u4LB1LZKiJ2V3dxlA7hfjS
   rLPxr9VMa6doVwXMzcN7CleUI1mGMR3ApM8F3TJu9ZD5R8iqpdtAKcUQj
   r3ItGyb5YOP91ahbKLoEFLomtbZTb8guJUZwQzH2e6j4PPoIVYKdO6tbw
   D7Ofo+sJUOCxCl1YWMUbU3RpQLEsI2jCEeoNkSlve1ocO9dnBuY/g9L7x
   KLGkD0/XCeP5GBUtFv4pabYRXQwCKpgI6+4aaI+fpQXtg7koDOfiRQW67
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="324226276"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="324226276"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 10:52:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="748099503"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="748099503"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 27 Mar 2023 10:52:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 10:52:08 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 10:52:08 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 10:52:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNS59RSlKnVzma739SSqmsj/eEFkHDtzx8Hteld40H3b7G+a+X/DPIhs9dDWeHdsvdHsG1FpomhjeVmDSEK/YV8SQVva3jmn92JX7VZL0nroy8LcOzXTspjC2I/bJ3CzH8d6JvH//cIxXRxdM0Pp++jwX9DNPVU906vo7CeKkmSMENkKCEnbCMLD7fbVnQdDIZXG+ODowHj1pbyesQjjnk+rzuateYod1p+PcUJ1cyPsl3Gx/3sRRwiQh80TfoAOwnsa6fadqbh6UZYKfouQtjtaczqdxASc8qle427vOs5+25Vxd3qRYSPB3Gtekv+T8yCtv1aV3IOQuY79kDjiug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbniL+zq6+L3K7bhLYEkhZfVsKp+oPMDK1prxp9lWHw=;
 b=bRvFBr4X9QLFp0/yuwHL6G9Wjkp1Znn0hPxLi3zZXmmH+Y6FEmtOeB5hq3kezRGcD6NlS9C3auG4x6JkqIcz2H6AKOKDnNd0FXzTagsDj4UChKnT4y2sCV9UoCLANZT9lh2px0c+IXVGL1kQsKcY7G6N95MV+WqF2Bgzp0+dAwVamWMT2eLREwTfBGuQDGBnAlRD1R6+li41X3HtSyLBjx61whdoy/RTI1mGFUv9IjHEWlIQehcKBfgIpog1Rs9Cs7vk68mRCbgK+iiM+CCBPmOG9G5+d3sw03G/WgB1y6l6MYsPfYb6tyw5UqPdbaYZ8eLn1DYcblNYbb8h0zPWpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7857.namprd11.prod.outlook.com (2603:10b6:8:da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Mon, 27 Mar
 2023 17:52:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::ea5c:3d05:5d92:bc04]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::ea5c:3d05:5d92:bc04%7]) with mapi id 15.20.6222.030; Mon, 27 Mar 2023
 17:52:06 +0000
Message-ID: <5dce2b97-9f41-6ac0-cb64-de1e67e99526@intel.com>
Date:   Mon, 27 Mar 2023 10:52:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] docs: netdev: clarify the need to sending
 reverts as patches
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <corbet@lwn.net>, <linux-doc@vger.kernel.org>
References: <20230327172646.2622943-1-kuba@kernel.org>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230327172646.2622943-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:a03:505::11) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: e200d0e0-8e20-4f5a-7230-08db2eebfaa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/z/lwxYZxGjPgbjaJR3A6zzetXGTa2HHSgKJM4UfoxV20jbWdbdydfsFz5hQXvaTwWtmThMqRw+Mh7HPELDEeaDTLnDH2nRwR2TYXzsrlYTXN/V1nVINcrlhxFRVWb6ypwfmC7O9zkuUtvnWm8myTq3xIvYsumeqsk67KPyzCoWiQZKaPXRk7kDQEHeii1jWKC5TqZT2/I6BwyCDIGKx8i9KeV8nqRVosqSNgddTgH4/HXNmXgsqd8SHG/u6oZmDJG9H1RxkcPU0YokM5cV7qohTlEzdW+hpMXha0J5EpKaAn4cCKx14ZDj6yS3o7juLvqnwbl7ac6Zynv2dyJhIhOVpG9laDqxg3/OKkjjftMQbBE8FGVTwJaISITwfnGJpigLTvDC2vYT5xBGyWD8A4Q97MaGa96eEYFQ6SaptmsYuj8vBLT3r0jZU72W/PtijC4OISbjU5Hu8GpbV2b2rdeTFnqh+P1r4qdSjveN0mstzjP3J9Soe+cjxqlnaAjLdUMu+wlD4U2cVdXZRY6MMbuSz1Ln/C6IeUJ53GpFHITmK+a+c+oC6AohM4Q35mzA1ajCWPczvkn2f+nuhvqxbSNE6FbRencTukxoS9NugSS75vGv1XHvOTKJDY73gvQH6r3QG3B3Xpus66i56mOI7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(396003)(376002)(451199021)(53546011)(316002)(83380400001)(2616005)(38100700002)(31696002)(86362001)(478600001)(82960400001)(6486002)(186003)(6666004)(26005)(36756003)(6506007)(6512007)(5660300002)(8936002)(31686004)(2906002)(8676002)(4326008)(66946007)(66556008)(66476007)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFY5YVJiM2FQc0hSRmdvajlaS2FpWnNUeUpLMEhpbkczeitTb01BZCszU0V6?=
 =?utf-8?B?NUNoYklOakxwWlduUFQ5Z2EzNm1VeXlmYW9tNGIyT3ZWVW4rcHpHNVpYbC9Z?=
 =?utf-8?B?K1E1RXhHWDNVRGwzYmJMakZldzFtcGQvelhOMEw1Z1Q1aHNXTmlDRC9jWFJW?=
 =?utf-8?B?N3J6YUN2MVA0SGxPN2dPU3hyQ3F1UG1aak52Nk5jbFlpUVNQZDkzY3FCd3ht?=
 =?utf-8?B?SDRQayttWWJhSXR1MFpyMTBrYzh1V09rMVlJS2VOcXRVYTJBb3ZmcVV1VjVB?=
 =?utf-8?B?WG8wdTNpWVlyM0kydUFYQUd1Yis0NHB3M0NhcE9aNkFObG5lMS9OWGpwMWE4?=
 =?utf-8?B?U1gwSVZqU01VVnpQS01yV0JmM3FvcVlUay9vTWZBNEFPVXR4ckNBelJCK0wr?=
 =?utf-8?B?Q0YvNlYwSlkxVExBZW1CcmpwdW1uWnRUbzNPNDRaSmZwWFJSM0VXd2FiSUVE?=
 =?utf-8?B?OWlJYllzWjZ5aTJMS0NpRTFiSVYrb1Jlb0YveU9KWWtDTDNpQ1V6c2RDcU1F?=
 =?utf-8?B?VG94MUFXT0dxSkIySDNVbUdaUEhRMWJiYWUvbHZYS2NHenBqLzlzbHRKYWxr?=
 =?utf-8?B?Rk9aKy81VGZ1Q1dHQWFTaVNtdk1EajM5UEdjaGdDNnZ1OURFZWFPQTBPa2ZT?=
 =?utf-8?B?akdWR3hoajk5eWI4S044ZU5CbzJPazlWM3BndThwY2g0N1g3SmxwMHVZbjhC?=
 =?utf-8?B?T3JnVXgyZTZGM0FraGZFNXc2NkpSdW5ocEtlcW5LNEdCOUw1YkZGbWx2SE4r?=
 =?utf-8?B?RWVkYUJBN0dKelZtQXpzbmQzWWFwK1ZzNm1HMnAvWDRGa1NMSTQwaUNhOXdX?=
 =?utf-8?B?dUg3c2MzUWVIUVp5MXl6SW41bUEvNTVZcDlKU3hRakU4ZHBwakRzTzRYZHk5?=
 =?utf-8?B?cTBKWGFsRUJtaGk2T01iRFBXMmMrajFxQjZLQVdzYnk2clVoeHVaMWx2Uks4?=
 =?utf-8?B?cjFheEhhQmdRRGc3Z0hEYU5ic0lrZGlON1A4QzQ5UGtSZXBMZ3h4N3pkYjY1?=
 =?utf-8?B?ZHRNS1BpSkY3eWNQOFUzNVBKVlhNdFNSeW5JdEdGU0VsVW5icEY4Wm9zaDI3?=
 =?utf-8?B?U0NBelA0Rmk4cHNGNjVPcXI5d2w1ZHlNM21NRExmcnVzcEhzS2NWd2FVR2JJ?=
 =?utf-8?B?cStKQk1zV1QrdFJjQW4wSEtabmg1Z1pYMjViTW9RQkc5aE1TaGY2UXYxL1dP?=
 =?utf-8?B?UTg4ZEdMaCsvdDlZc3ZtazNnaUt0SXJaa1hpUVI3c05RL0lYazBkL2lQR2lT?=
 =?utf-8?B?Z1J2ZzhvZ1dncHoxLzFpa2lGalFXVzFIL3MrQnI4cXV3KzNHREtOVmUyQ2t4?=
 =?utf-8?B?RUorc0NaWUk3bkVCUFQ5amJsZFBSUTZUUmd4VXA0VVZFWCs0cW5rMzQ5VXVP?=
 =?utf-8?B?MDJKQUFneE9ZL0dOdHY0Yjgrb3REMGpnc2FwVW9sVndRWDB6UVgyNk1IMTBv?=
 =?utf-8?B?ZUFKcnpEUE02TlA2VGFSWWk1azl2VUxvNXlpMkJlUk5pYStNekFiVjJGMDg2?=
 =?utf-8?B?SFIwYVZJNmx2bTJnSXRTRUVyQmVYRnZFK1YxRXhSWU1jT1RNWTgwSE01andz?=
 =?utf-8?B?Vngyd1NUK1pxY0o3UlhpU2ZpM2hXNmpnbmxoNmF3VXA5bGFOeEZIRTVYSkxi?=
 =?utf-8?B?aS9QZ2NpUE5SQ01vaTljb1ZEa3dUcUN6d2llc0tTZ0xEQXFzL2ZuL0tJNHJ3?=
 =?utf-8?B?OHhxcHptUmtZbXROL25vSmYyT3ZOZTJUc1RDS240R2RLVTNvd3lqbGZEUFBY?=
 =?utf-8?B?MWRHS0w1empoeEJ3NXZuZGlwa0svWGhCekUwTi9yMHlySnNsWEtESktoNWlJ?=
 =?utf-8?B?S3NBNlVnR0xkZ0w4S2F1cUx0UlFlZ2dnTUJZR1ZBSDNFVUZwbHdKbFFnQ1RL?=
 =?utf-8?B?WjdSemtuRnhUNitBRldVbEQvZ3EyYStua2hIayt1eGptUjlqQlRoVEhqQ3N0?=
 =?utf-8?B?YXVZY0FKNUJuMTNpNFZad3VCMEd2WGNsNjJMZlorTm9IemIxQ2FhaVNZNkMr?=
 =?utf-8?B?b2lYcko0QUhQZDIwbnhqdGlHNUJ5OU01N2VFK1BCZHQyenRnUzhRS2w0SG42?=
 =?utf-8?B?RWYveEJkR0U3L0tlOXpvcytzYnFxZXBCeGxlWHJiMFM4UkhBeDhMQW5OWEZi?=
 =?utf-8?B?dEpkVzFqbzVPc0tEdktmT2hSVHAzYkI0bWVDWGQvcUVxZ3FjckRJRUQraVJV?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e200d0e0-8e20-4f5a-7230-08db2eebfaa0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 17:52:06.1572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMyzI27cCF44s3yfDGUhXmPWzCblVu7oDlhi8TJs3kOVSm6uoIei1g92oS5rJqVdTmCu/djS5kEfRnNJ52DyL0tkMhK4IlBmMFS6wPFEEPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7857
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2023 10:26 AM, Jakub Kicinski wrote:
> We don't state explicitly that reverts need to be submitted
> as a patch. It occasionally comes up.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: linux-doc@vger.kernel.org
> ---
>  Documentation/process/maintainer-netdev.rst | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
> index e31d7a951073..f6983563ff06 100644
> --- a/Documentation/process/maintainer-netdev.rst
> +++ b/Documentation/process/maintainer-netdev.rst
> @@ -184,11 +184,18 @@ Handling misapplied patches
>  
>  Occasionally a patch series gets applied before receiving critical feedback,
>  or the wrong version of a series gets applied.
> -There is no revert possible, once it is pushed out, it stays like that.
> +
> +Making the patch disappear once it is pushed out is not possible, the commit
> +history in netdev trees is stable.
>  Please send incremental versions on top of what has been merged in order to fix
>  the patches the way they would look like if your latest patch series was to be
>  merged.
>  
> +In cases where full revert is needed the revert has to be submitted
> +as a patch to the list with a commit message explaining the technical
> +problems with the reverted commit. Reverts should be used as a last resort,
> +when original change is completely wrong; incremental fixes are preferred.
> +

This is much clearer. It highlights that you won't rewind/modify
history, and explains the desire for incremental fixes better.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  Stable tree
>  ~~~~~~~~~~~
>  
