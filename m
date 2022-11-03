Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C137B6185BD
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiKCRF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiKCRFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:05:21 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5A61E714
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667495083; x=1699031083;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pl+30FMsCoeZQeRjgO/C3V/yxt8NqRBa8FaUJWTnr7Y=;
  b=GJ1wmFynsNmaTsWnGOhXC39S6eH5/nNav4XV0SMv2jQ+bnvfZX9+IiHm
   7PtDyrqhkwZgMkvlNbSis3qSXJxvjqSnNBzOL70suKX7Nv+8st+B18Sn7
   vOnAmGKUq/mMcHokACblx/Nj4Qj6MpD+9JDI8cwelFJrz0AEeU4FMZ+4/
   bSeU5Y4ABl5BHGfnbZw8Gbj+rH4ytzXxOsnXFMVcCusMSGkAsDCA5LkZF
   7CfM4E4/F86Cs7cZ8umaLfySE3H1eqDo+IRiEjloV9jbpww05QuyQembA
   r8mw0AQp5F1UKclJA/tjdMjCD6YjHGb7QOg+W91plUBzrLvfVX2lzykv9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="297204596"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="297204596"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 10:04:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="612729743"
X-IronPort-AV: E=Sophos;i="5.96,134,1665471600"; 
   d="scan'208";a="612729743"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 03 Nov 2022 10:04:39 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 10:04:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 10:04:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 10:04:38 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 10:04:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I3gTjWLzw9qJcqo2z3/4PR4gtZkQMPCG3SC28JuxkNOIK7ZQhfWYiUgian1peiEwdILRhLMQ6PZXNMLRYt/PErIKZbGNW7lmfzW5pY26cHBtcrICu5Tqya5IoFXDUM/VAqSIj6bbSnyiPW45AOuPnpHtMhGbSOVdX/MFzkDp5CjdFHncvZCHHTleTM+aocdfX0K13hNwUdZEQZqaP10nekLM/3we4fUN2dnHvKtpFp+ZYEsTYzHXD2u0PmB/svNRQ2Vd2jt+KKke7r0aPsFerf+MB7sjbq9zyl6rROK/41MmFn1Ua8HnuTD+os0u9xtNFzZrdmYVRCavMQlF1x1mng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2HcWchxo4E1DmLYeAfA+tvHHgbscIx6kMLfOFJlGnE=;
 b=nwq9dpkZEzXjMRk7AyMTD9wwKI2RRWiTk1ZGhdoKpuVYRhtxYG6mvsBhNjX/vdgQY21jsXt32sUMbAr4telqgtTneaPpaWlH5/PM2FJiH7E3DTU3eqnHgxOnh/Yq/VxHnUWepNI/tq6ltl3JJ/qBDNX8CE5+gjRHov6BSgwD4CYlq7upyJF+Q7+OKovmOZAHP0in5hwtfzt0d6N79PNpsb82oa99tQXW7zmMuh13w5/IJ+c+8+++NDCUU0u0Wl1iyouc1xNAMV+wKiCiE4Q5uNyvPXJTARp8nudYDpX7DOXihAUkeXFBY3hB0Vj4xEwIG4seHI+XQgpKoVnKRoZBzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5951.namprd11.prod.outlook.com (2603:10b6:510:145::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 17:04:36 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%6]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 17:04:36 +0000
Message-ID: <986fc7c6-af01-20a0-e862-8f77b1ccae76@intel.com>
Date:   Thu, 3 Nov 2022 10:04:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v2 08/13] genetlink: inline genl_get_cmd()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221102213338.194672-1-kuba@kernel.org>
 <20221102213338.194672-9-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221102213338.194672-9-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0028.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::41) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 2956ae36-c6c0-4209-9807-08dabdbd7c6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zsm0hGVGhO7vKzFxLvdJrqwd63THugN0/7XwkFgmxU8WFkRsG+Zn5Hjvi8GCvUm9CyhD834M7j/+eJcSEIWSiMAmFvICq2Vk7zf8Bh3CfKNWnxGAKhzbb012hnoM9+DRFdCniIGVOuWMsJ9904tYMCfoJtTvTm1PooWi74KA809AZPi5CmAum6HHvcjs3gNT5AWnFL72nbT84oWcGfhhYWI/wid4Zim29m1jQ3uVSM1TrHm9mtNySyw3O2/GNaDyBbSgesGGkMxN8wZR8CpGi66IjNZ/lldT6Fif+yw9mQdnFuxtLo5GbrBiPp6vQ157bs4O6dd4Yi0v7HTTjvpJ+a/G9KlaCIh5p40DfmzXSCtgHZ5Liat//NkyLQDW20nYNfCfSCYW49mSXu7KOAQNO/0czx5zsQ4e8ieMqH0SAxA03RHNz4pcSO6+KJ1CVUeRTacDkJmutJB7oxcjsEg8/Kqsb/CnJJ4ZCUmdL7QWr6ZfmGwgb3YNwqyA3dD0CGWd1iLv4w9/HzVkco1JUUZbQTj94KMEWUm2+OCk/BIlYeb+PmYD1XhjsSh9T/LxFmqwn+lQwGpmxhRFCgBM1M5BdtQfUVMFfjj16k7YTCDa7yDdJg7ODlpmjf7hmKh7X/9jI1VorM/+j+KQbbTXvMnLS8XlDktNd5E59HRUD/lGMGyIrHVFhRrgyacrGbgQBvMNiR1fCnOe0kFZCekvAcdU6RsfjOSjSTOeOFc2puXZpjpa39bqvA4PYJgLJ2A/rKcS9vE0yVctsgz9JsSY4U50Igal77eidteQwuxuYMx+lbE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(7416002)(66946007)(66476007)(66556008)(4326008)(8676002)(41300700001)(2906002)(8936002)(316002)(5660300002)(53546011)(478600001)(6486002)(83380400001)(38100700002)(82960400001)(6506007)(6666004)(31696002)(86362001)(26005)(186003)(6512007)(2616005)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WCtpUFR3ODZlcXFVWmgvd1ptS1lFQmt1UUlETzJhNUhZaDJOSnhtWGtSMjZH?=
 =?utf-8?B?TWcvSWFwMzNyZ2s3Y3p0NE1tWTFmTVBTdDFwY1EwM0tHaXBGdHZPTUdoL1JO?=
 =?utf-8?B?eERFbDE5OG9JMWdDSEZQZ3l4ZFg4ZGNRTkl1bkhPWmZWWE5qbDhTcGdGd2JF?=
 =?utf-8?B?M1EvZkdvcytiZ0pxdGtqc1M5MFlRQ1hpNDlHYzlkdFJBYklLY2lUT1RtTXRs?=
 =?utf-8?B?QlR4SnlMd1N6N2ZkVGdheTJ3OC9DVGRxeG9uWWtGdC9BRFVkYXlhRkx6VmZ0?=
 =?utf-8?B?WU1OMmNaMEtkTHJ4Wm8rYnhCdHAzOGtadzM1alVKdU9UYUY0eTlFV3VUWFg1?=
 =?utf-8?B?UjM2QzhYaklPclZtYStRNUNmekFvOEx3cTdkVlBSdFFQTEkxcW41T0NtbHo0?=
 =?utf-8?B?MWw1dU9tWXYwVWlQTlVBR1lyTWdGVkJOV3N4ZjhNMVlEUHJzTGI0YlNidUNH?=
 =?utf-8?B?dGJyYVdKYktPVEZBc0xsbnhjemlSczRoMWUwSEQ5MHYzU0djWVpTcmtvY3pH?=
 =?utf-8?B?d3NIU29YY2FQZ2o0dGxERmhIbnJwWmdQWk9wdFlLM0MvTzlDS0c1R1pRY2Ni?=
 =?utf-8?B?emtDS0ZTWGZTQWthdlRHY2hwa0QybGUwc2ZEVUsvdzcyU3NXN3Yrb3dUWlFK?=
 =?utf-8?B?MzRIdFJvTUJ2a1VSV0p3cVRIWFh6ZHpRZkNwVDREb0d6ZWJ0ZlE4TFJ3QVcw?=
 =?utf-8?B?YnJTZEhHT1k5b0lkUmVuMG5rRXlZVVVQbFpFUGtuK2lZN0Z1Y09xRmdzOHdh?=
 =?utf-8?B?UkFFWTJURlVWek9KQi8vSHZXUlNoM2x2NWgwbDBmRithN2VaUnp2OUFxQ0oz?=
 =?utf-8?B?NzE4ZjJZdmRWbjlHWUROTHlaVkZKek54ekowckQ2WUwvTWgyRzhYeno4V0lP?=
 =?utf-8?B?VVR3b0wxMVRlaTRKTWFIM1RVdmMwRW5STjVRYk9HemtocWpnVlhrWXZpbW5J?=
 =?utf-8?B?NDVEaVg4anpzMnNlb1ZweFk2aStnQk1TcmpmRS9MSVlJVXVzaHJTa1lrdWtK?=
 =?utf-8?B?L0NZaWFUZHVWcHFSS2lqcEl3dzhrV2tGcXI4Y1k4SFlHUjg5SHFyUlpscDhK?=
 =?utf-8?B?RTBuK1Voc3JZN0V1ZGRQSWRraWo0cjlUYXNlTnpoMzZjbzI1ZjR4R2hST2Jp?=
 =?utf-8?B?ZG9USWFsSzJ5bnlleks3UXdzZ1ptM0ZCTjZILzlWWDV2V2pmWklrWGhXdUtw?=
 =?utf-8?B?ZHlsMEVDUTJqeURmSi9CUmM0cUFQWUhTeUpESm10UDhlWFlwV042a2FTNnRw?=
 =?utf-8?B?VTA2aUd4WU0rZGh6YmZhclpqMGh4R0FPc1Bub1l5MGxkQVVPbUVMSXY0K1RV?=
 =?utf-8?B?ZWxUbFJFdE5vMW4yTjZSY3pxSGF6TnE1QnEyZXRPdk1LYVU3QWEwOVhBeEht?=
 =?utf-8?B?ZFFZaHYzR3JVMVZxc09yTHMwYm1FbjI3eGVnNXI1ZXJ3elljNGlsV3NIUklG?=
 =?utf-8?B?S3lrbllSRzNueFFLTFhPZHJqY2VibU9Gd0JuQ2tJU2lYWWV0dzVhaEhkTUkv?=
 =?utf-8?B?VGtOZ21WVWdXODhQdStTeUdWcG1qZzZhTGRIbGFOTVFhSitNZlpqMVdGOURH?=
 =?utf-8?B?Y3huZGdrLzU2aWswb1kxb2k2eFZYdGZWVU45OHlLb291d1RnaFJaeWZsVS9y?=
 =?utf-8?B?c1NyQmFHa2lFTmFoUDBHa2xoZkhFQTZjV0VIbmNYSmdaUERoNkEydVBOdWwz?=
 =?utf-8?B?dE96UjhOTjJkRmREdVFZTHU1ZmNGYzZjYUNMODFvMnFMSXl2ZytQMjNOWlZX?=
 =?utf-8?B?RFZlOFNXZzJwdm9TVGx5RElFSUtZK3lEZ0NqNlpmV1J0REhVSlVmemZ4bFV2?=
 =?utf-8?B?RTVwY1VHUWUwUloybjhpYlQ3djI2SnJOU0ZLSlErMUg3VHhuenlodk5lR3oy?=
 =?utf-8?B?eVF6UXlNZXY2cGJLamE4MW8xYXRZb0s3V3RCWWRja0UxeElSbkFrZDhaWjB4?=
 =?utf-8?B?SlBkOVRuOHNKbDRlRHhiRzF0ek1ocUZsNlhTRjB0WllqQUt1UmdxSHE1UGVu?=
 =?utf-8?B?ZjdaNjVvYTdvOTA1aXVDWSt0Y25zSkUrWmtSMzFPT2c3ZlU2NzJqZE1BWFph?=
 =?utf-8?B?bUNyMVhhWjNDaTFmWUxUeXNyY2ZMdGtKaVlCb1V5eWM2WlpWZURJRlRJZU5k?=
 =?utf-8?B?TXgrMCtReUpBejRFdklqc2FrMk1zSVBtMlJIRWtBejZnRDREM2x4VXA2c1py?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2956ae36-c6c0-4209-9807-08dabdbd7c6f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 17:04:36.7689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10rcWta/08+XJa3JjXjvMxoFEenY+2Kw2+0EiYFoXYbbP2kNFr+s65wjutQCtv9YWxy0KOPn+t7llVQDO1Jxgozvb8+L5Khw5x9FcB6Sw3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5951
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2022 2:33 PM, Jakub Kicinski wrote:
> All callers go via genl_get_cmd_split() now,
> so merge genl_get_cmd() into it.

In some sense this is merging genl_get_cmd_split into genl_get_cmd since 
thats the name we end up with, but practically/code-wise its merging the 
other way then renaming back to genl_get_cmd.

Still looks good.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   net/netlink/genetlink.c | 30 ++++++++++++------------------
>   1 file changed, 12 insertions(+), 18 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 93e33e20a0e8..ec32b6063a3f 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -181,14 +181,6 @@ static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
>   	return -ENOENT;
>   }
>   
> -static int genl_get_cmd(u32 cmd, const struct genl_family *family,
> -			struct genl_ops *op)
> -{
> -	if (!genl_get_cmd_full(cmd, family, op))
> -		return 0;
> -	return genl_get_cmd_small(cmd, family, op);
> -}
> -
>   static int
>   genl_cmd_full_to_split(struct genl_split_ops *op,
>   		       const struct genl_family *family,
> @@ -231,13 +223,15 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
>   }
>   
>   static int
> -genl_get_cmd_split(u32 cmd, u8 flags, const struct genl_family *family,
> -		   struct genl_split_ops *op)
> +genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
> +	     struct genl_split_ops *op)
>   {
>   	struct genl_ops full;
>   	int err;
>   
> -	err = genl_get_cmd(cmd, family, &full);
> +	err = genl_get_cmd_full(cmd, family, &full);
> +	if (err == -ENOENT)
> +		err = genl_get_cmd_small(cmd, family, &full);
>   	if (err) {
>   		memset(op, 0, sizeof(*op));
>   		return err;
> @@ -867,7 +861,7 @@ static int genl_family_rcv_msg(const struct genl_family *family,
>   
>   	flags = (nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP ?
>   		GENL_CMD_CAP_DUMP : GENL_CMD_CAP_DO;
> -	if (genl_get_cmd_split(hdr->cmd, flags, family, &op))
> +	if (genl_get_cmd(hdr->cmd, flags, family, &op))
>   		return -EOPNOTSUPP;
>   
>   	if ((op.flags & GENL_ADMIN_PERM) &&
> @@ -1265,8 +1259,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>   		ctx->single_op = true;
>   		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
>   
> -		if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
> -		    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
> +		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
> +		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
>   			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
>   			return -ENOENT;
>   		}
> @@ -1406,10 +1400,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>   		struct genl_ops op;
>   
>   		if (ctx->single_op) {
> -			if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO,
> -					       ctx->rt, &doit) &&
> -			    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP,
> -					       ctx->rt, &dumpit)) {
> +			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
> +					 ctx->rt, &doit) &&
> +			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
> +					 ctx->rt, &dumpit)) {
>   				WARN_ON(1);
>   				return -ENOENT;
>   			}
