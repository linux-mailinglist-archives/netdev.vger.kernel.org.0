Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED5669800A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 16:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjBOP7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 10:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBOP7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 10:59:32 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D37A2312D;
        Wed, 15 Feb 2023 07:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676476771; x=1708012771;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K1GeWd1hu2jnlIhe7V3FnVrzmxtzqucF6hjj2YP+Qrc=;
  b=hq3uDx4C6fDNh+yCGW0q0Jx7ytdbL70f0qjMUcMvtuG/ct0z+QU8asoc
   6cRl9GZV1Sa/79OFWv4aGW22FXOe95TSPfFN2j+blv61pJrQvHJx6GYeS
   aekQtTiAdl7v3X6Ii3H22iC2DRiayIfLENzMYn8I3VjLYAs37Co8143kZ
   YFE7MIhB4UAlASckwUoiv5GCPpbJoG4+pkO7NvaW6blMynpUmWu6j0MwC
   RfnsbdEyo7qhSGETaKcI7OC+b1mYkqVpc0BzOLpbHcYSChOiWGypgWjb5
   2QtjJmktc2IVBsaBR2TtyRkhv73tfDv5TKKzzTAjdLfEnl2zQ9XINWv1G
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396084408"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="396084408"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 07:59:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="843624355"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="843624355"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2023 07:59:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:59:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 07:59:28 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 07:59:28 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 07:59:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbgD5hlNN+u0qBSEN3zWqBWLSQM4bNQeUvsD9oDJ2MWtriFKAUhFJmYbdXpi82/XCIhfN88o1D7Aus4H8uW4OlCfzNw3axsmB02CpsNvMvj4l3eDcaC9Tf5XDQcDXe3YPrXTdbnFGRa4PkJ4Omp+amX1PZvrkHOamSl0lsk5M+hCK6xPCfJVIX5k26E0KsmKcbqd5wvyhd4m9yrimVqPfGYbCEOlK5QDxer6x/Ziu0DF+ubnkJga6GtVTj3p2lcK9IJNOcXkMA/qG2rlpLYfZIjBizdypflvZeewwxQh36Hegd56HIUpGYj/3oHLAiZWWQr4flWtBp+hExxXL4oYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tkdLC8Y5hQJQTNMwntOQ5lBvgemy+dXRCYfUoE3ivkA=;
 b=Dmf1pSZWD/XsLZVeE2Yfls+rzmj1Hx8bsaRu9Dp04ZFv75x0JhytKtS9BqOM0u+Sd+7Jn5v/XZeqTA8w06fXvfngf5hC9qlcKd0CDNtTB+1+ISc9+/Z72oQ6TE2bEITBZNWL6DV9zB7vJXlDQpaohQ0l4EZmnZN2NsprDymsLyo5HYamIElahGkSXhceioPsOoHK0clVZu0Q+zztNMUgD+xWIpfz1INgnRny+igXeXR+hE89PsPPeVcS7zucCIhPQxDLQqhUKxh23VDu51gnLGgGK0Kp9IYx8L2KFe/v+V2dH1/IzgcC6Pxge70lsriCjPvw2ZSMvNHB9gR6JDHtug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS0PR11MB7216.namprd11.prod.outlook.com (2603:10b6:8:11c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 15:59:26 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 15:59:26 +0000
Message-ID: <0a479141-7887-462a-b154-bcb8881b43c2@intel.com>
Date:   Wed, 15 Feb 2023 16:58:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] ipv6: Add lwtunnel encap size of all siblings in
 nexthop calculation
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>
CC:     Lu Wei <luwei32@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230214092933.3817533-1-luwei32@huawei.com>
 <d5f2c46c-cf68-3ec9-ec87-f6748ede1d1f@intel.com>
 <c5e3cf7c-1a94-4929-5691-9ccb4c7a194b@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <c5e3cf7c-1a94-4929-5691-9ccb4c7a194b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB6P192CA0021.EURP192.PROD.OUTLOOK.COM (2603:10a6:4:b8::31)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS0PR11MB7216:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b85e5aa-9487-4bbd-3be5-08db0f6d9cb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cLx7GXwbBL+04DeTaCZ4lZzK1spmV9eTc9MUKLcvmu2Is/cD3jed6r113D2QdbZh32KPhQLOaDTUewWf4M/J4hRLh8rJc9BHj5u//oGq4MkSYQJ4Q4F10aehBHgQuCC3sD8jX0jM5ELjxzUdHzSw2i++7UIYB32fIthNwA6EoBhCSviz3eWd3nr+8M1JJbZNwHsEgUTUjqk07Tx2r2ZWfMzVQ+Xaoat99PwcbSVLjoMt0TBGps+8PdMXuv8Pl61KbCIxKfst1yKHii7scpWpWFKOQ6mG1iXtwmh4R/lrNKltSceqX+yENdaBqLiaRFLBzpWuP35pJ/ML86KEG0ZYOWDRkL9gTAKsS4Vq6QwDj/KB5tTQT4QlWB3hxnUJOJD5tZspWFr0ScZBz+jU3re1wKBGFmaGZ3r5SFrwqFeL+vcC7gecvmIcYKwT3TCK2JVpMAytaPCWUmSgW0lqqE/Qqb4DLKH5iNMGc9m9G5fOS3BYsUyuqnU1soFrrw0TO1lXl1S1v6S6ApDmeRtarCvNJJX9ED17j/gDEQEhkJrD0EfYi2kWRPH7dETwyDQfFxy/zZ7uuzk0h8CX3esVokivurdPGSzqNbJRJLjkgpj1c3feHA5yaN6lSvg7R6zHTik8wB8cHrkVF+EmZeortoCMi+R0yiMmI6wo1FaiE4mzDWksZWOeVCwOAnsG9TynNFfPtQt3wQojkTlmW0shFTw1EGnsd+ILWZVgUVLqAJAbjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199018)(6486002)(36756003)(2616005)(316002)(186003)(6512007)(66476007)(66556008)(66946007)(8676002)(31696002)(26005)(31686004)(6506007)(478600001)(82960400001)(53546011)(6666004)(38100700002)(86362001)(6916009)(4326008)(8936002)(5660300002)(2906002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTBpYkU0TlRJdEtOb3dIODk5Ui9PYnNXOGJHZlV2Sjhsb2VvU3BrS2xXc3Mv?=
 =?utf-8?B?UlFZRjdUWVBtN045UHJMWmZ2Rm90dTlxZWdlL05veExIdDhNOU5rWkRiQTgy?=
 =?utf-8?B?MTI5dEtTNTVITlNwZlVCVjR3bFA2NEpUTlIzL2s2R0FYWlQ2T2VpMXZYamwr?=
 =?utf-8?B?NFM0YlBKb3ZPTjk0K01XQk4vNEkzRmZGU0hOa2MwaHRKaTMxUHAwV2pDRC91?=
 =?utf-8?B?QkI1alN6YXJHdEE2V3JKWW5xak5KRjJwK2JzRkduUm80d3VCSENOY1Niaklk?=
 =?utf-8?B?M3RjS2pqQnpWcGxtVkEwVWZXUWJNM0l3MnVRZWdsVklvUEpPRTd2RWxOY2Jz?=
 =?utf-8?B?Z2Jmb1FZbW44QXRaQWpoVS82YUI1Y2I2VGJLNmliRW9Fd3ZkS0JKNWdEQURy?=
 =?utf-8?B?M1YxNlJuLy9mandKay9YUHpSRzBERE1SYWZrNlNwQnAvQ05FaktIWllNc0FV?=
 =?utf-8?B?NFZ3N2szU2IvNGF5ZzZPTXZnWmpmakJJQmxTSmN1T0pkdFVtY1NDcTEyV0Z0?=
 =?utf-8?B?cGc3WXhhWk5YY3AyMWtDaGErRFI4b0xKOE5IYW9BU1ZjVGxkdXZ5SDNhQTJU?=
 =?utf-8?B?SC9URUs2dTlEOGtQU0dFNEt0eDQ0S2ZlS3NTWnlCK24rbmhCRUpQVUdCV1pI?=
 =?utf-8?B?ZWdBVmg0dkdOUWgxall3U3JvNHhvRVFVVytaRHFsdG03NzRXdGV3VEhoWVk4?=
 =?utf-8?B?dmRRVGtJYnRTMnVYaFM4K3hSRDY1eWNkU290c2hlMnJCd0VvbnczeGZEWEFG?=
 =?utf-8?B?TlcyU3NJdkpGRVNYWTVxSW1XQVBuaTcyY1J3bHh1U2pNTVgrMlVZR0FGMmd1?=
 =?utf-8?B?YS8yRUxIb3Zwd1BLNHNadW9vOVJLZHVWMmNVRVJQL2hSVGZ0cmVtTFJhT25K?=
 =?utf-8?B?WmxQWExDeTVPWDRja2JlRWVWOVYwS3hDZ1NTOTZ3UUJhM3ZRN2FHQjA0UWo1?=
 =?utf-8?B?VkZ6cDBTU2dGSnFncGVuYmEyaGlUbExxbWFqOTFCK0twQTBjam5zazFpbDY5?=
 =?utf-8?B?VjNoTVJFclJBajNMSnRZR0RpRmxIcXBjUGlmT2JxeG83bmwvdG1NTlZyM1pp?=
 =?utf-8?B?RnVZWm1xb3ZVS3o3ZEFHa3RkWGloeFB2amtSU0MxVkV3eUhrYXFObG9LVnp6?=
 =?utf-8?B?S3ZqaTJSK2JqOStNTWpJSk1EVC9LSmNKVEwxS25HZFp4dVpQNlVSMFFQdFV2?=
 =?utf-8?B?U1FzR1EvZFNpekgxSUhBYzlvUE5sb2ZId3NpQXRUbUpXRTZYSmJDLzJBV3Rq?=
 =?utf-8?B?WXRsalZ5SngxWGt0TEZZQXZWblA3TEJSdFZJSmVmMjB6cExXMEtMcFJSQmV6?=
 =?utf-8?B?OG1oZ1JlM204YTd4L1FzdHh3R21zV2NEbzNGYnI4T3FNZkN0dVB2azNSM1dR?=
 =?utf-8?B?cjRUaUhsSy8zRlJmK1JGMStHbzVFQmU2U3p0UDJjNG1oZEYvL3YwRzFrNWpV?=
 =?utf-8?B?NE9ra0Z1Z0lzQWRSazFKdFdKd1h4aHozRVBTV1VqVzc4QmFRM3lkK2c5MnA4?=
 =?utf-8?B?RTVnRCtyS3c3WDUydWplRURRd2RVdlo1WnlpL0tVeG1CTUM3Tmg0TEczenRZ?=
 =?utf-8?B?YWhTbFRaN2lzZm9ObEVsdTFQR0YvMkluYU1UR1U2NUFpRW5uYUhmU3NCUTZq?=
 =?utf-8?B?Y0hwYWtyVWQ4SWlNbjArdzRwdUVSWXd2dGY0UWxFcVQ3Tlg4eUdqNDhyTTdR?=
 =?utf-8?B?K3Jjb05HZzhjcFA5dU9mV2htTitrUjdLMnJyT09xZTFKcDZGQkR0alBtN1Ns?=
 =?utf-8?B?eTY4YWxhTTVQVmdFeURzYWRYQ3dGMWplbEN6SkVNbGl0Sk5XSTNwZ0duYVNR?=
 =?utf-8?B?YXBnUDB2WG5jNENoRXVVcXRMK1B1WWZEWHE4VEVxZFdFeDNoZkJIMmgxeUV1?=
 =?utf-8?B?NmFKaHE3UHBHOGZueFVsNjU5YXNFNU82elR0QWdMblZQQ0Q3bEV4dE1jWnh0?=
 =?utf-8?B?VmdUTFE2WWVna0VSWnRzMVdUS21lL29nWndXdEpnRUlzQ3lUMVVVaklNWVhL?=
 =?utf-8?B?OXFURTQyUVJhOCtOdXNrN0FmbVBtUVNRUEZNOVBGdDFlejJRYXRFcFhNU2pP?=
 =?utf-8?B?QkxhYzFmYWU5T2M4bVFucmttN2YwaktsOGUvdVJaczVOaE1IZWhaZGJlWDZP?=
 =?utf-8?B?K09yUDNnSGJteFhrdEpmWnA4TEsraFNBd25iUkE1ZjF0d3QvYUlEMUlwQW5i?=
 =?utf-8?Q?RbdVH4d9Bf0+BE19jd3H+e8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b85e5aa-9487-4bbd-3be5-08db0f6d9cb6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 15:59:26.0753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rs52fDxSCUyK8iCTihSqYZKcqqS8+4kf7NJe8awf2l5h4lNr4/0ufmMqDw8fQ3VdVH0ShqqK6klhdN1ZdAi56fQFvXbeYzrzLzUyV5vA/Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue, 14 Feb 2023 11:11:04 -0700

> On 2/14/23 10:39 AM, Alexander Lobakin wrote:
>>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>>> index e74e0361fd92..a6983a13dd20 100644
>>> --- a/net/ipv6/route.c
>>> +++ b/net/ipv6/route.c
>>> @@ -5540,16 +5540,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
>>>  		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
>>>  					 &nexthop_len);
>>>  	} else {
>>> +		struct fib6_info *sibling, *next_sibling;
>>>  		struct fib6_nh *nh = f6i->fib6_nh;
>>>  
>>>  		nexthop_len = 0;
>>>  		if (f6i->fib6_nsiblings) {
>>> -			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
>>> -				    + NLA_ALIGN(sizeof(struct rtnexthop))
>>> -				    + nla_total_size(16) /* RTA_GATEWAY */
>>> -				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
>>> +			rt6_nh_nlmsg_size(nh, &nexthop_len);
>>>  
>>> -			nexthop_len *= f6i->fib6_nsiblings;
>>> +			list_for_each_entry_safe(sibling, next_sibling,
>>> +						 &f6i->fib6_siblings, fib6_siblings) {
>>> +				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
>>> +			}
>>
>> Just a random nitpick that you shouldn't put braces {} around oneliners :D
>>
> 
> I believe there can be exceptions and braces make multiple lines like
> that more readable.

Hmm, you know, agree for this one, that for-loop line break changes
things a bit.

Thanks,
Olek
