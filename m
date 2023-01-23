Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A50677A49
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjAWLj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbjAWLjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:39:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B61B1352C
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 03:39:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VN4CAEmyyuQ3uVPAYnUEAqulMsz7Hk72kBhaD9t7um0OVCy4ofedoTP+H0j5hXUIFtsqIhzBOnr29kQD2k/9ezDskb5BBe+DTYcrZ6DLK65qtnsq+r+DxqxGUyPFmJOE4eRCBuLKkXpGLoAh18BLAJbxQeuWyv+agIaYoZgi6V2sE0ZLAN6glNzDY8k/1mXc1/nljBuWzWr0mdThMOr1J61IPFBDsonkbhCJ8QbNU3ORWbJwayX2321hLksDQqiQFtcW9cN5V7PQElgnyJrAq7agRUi5JzNEjIdlEFMT9hLHojzXy2UTgXLQpflNaN04ZClE+nOtXm6Ge3yyYqCUZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EIGOrGMT3DOsV6SnQ04ZlwXibVjBbkbDdjL/Iuq6nCs=;
 b=jYCOakSrIPxO0FokLOnDkc9R/jaxg6jdn5TRpkFZ0ROWtHzgG6LowMS31UrtXKGqk8BrC9qZ4urCCbg9SCO0dj2hRQM4R8jU5fCAkXZrqS4VKdwGJN3Lb1ScDEie/0Q4G9RLt5tWW3xqHrREm49umNI+2rXC5QfQC/8GIKPW4vjYsbwJHFFa4asWNpNkJVrhodRCAHjIObCK+oPkcsUApBooZIRU9G6Ipkc6DwzyyqhigKcuNpkjk0hAXo4H91DT6vqb6IaXDvlSi250wGciBbY2BTvei1Pk8iH6OoBCYSDtnChkYZ9DbOWWWY6qpAVnOSXI/+zi3F+/ZNaxzFkduQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EIGOrGMT3DOsV6SnQ04ZlwXibVjBbkbDdjL/Iuq6nCs=;
 b=Jea8WgH95VqyhGXmhZRFa82NPM3m9cDSTu0NYIpbDDSnXsIwYqaAzmI/sob/Zs+HA1flt9XF27kybQ6N2D6Z+Zh02e6g6RxCl9I2c0tlqjv8fCYoll2b3DyP1Aw2XVlT/pL3fbJyhA5AphiHHgkZt4XsGeGyIeLImXBfs1u06oihzYIFvsTu9L9FUrgfHtSl9sRKEepmHE6f7/ZKMhgrYJCKicDq0Xh7D1RVj9B7jbouI5+e1cubRTs29eNjzzXcgCRNj97qIJhiuJuTSTuXj2qUCws57WdT1Zo6yXKQ1cxTiKYs3qQV8tDKyHkmpieDoB+d+y4MT13UMtm2uxUSLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by PH8PR12MB7027.namprd12.prod.outlook.com (2603:10b6:510:1be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 11:39:52 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6002.028; Mon, 23 Jan 2023
 11:39:52 +0000
Message-ID: <f68f26dd-db46-4e08-2814-2ed3b25ddda9@nvidia.com>
Date:   Mon, 23 Jan 2023 13:39:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v4 1/6] net/sched: cls_api: Support hardware miss
 to tc action
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230122145512.8920-1-paulb@nvidia.com>
 <20230122145512.8920-2-paulb@nvidia.com> <Y85bxLzv9wgwh+h5@corigine.com>
Content-Language: en-US
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <Y85bxLzv9wgwh+h5@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::18) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|PH8PR12MB7027:EE_
X-MS-Office365-Filtering-Correlation-Id: 316dc12a-693b-48da-bb16-08dafd368a3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5PQ8MwrPBtNRsl/Neq1ow8b45kO9Kbh8pqOhoOPAQIxYDvPUXsPgmjmwNNo9ZMn+W1fuG89oGeiUr4BZFlAWPJXcV7Qv+PkU+hg9Ghu12qXdQw4Kzdjog6vuJ6TBp1KMsNwU+CJuuoknZoM7asROvqNus6Bq6x0YeihNWFS0FYSzaC79Pl5IqAxemRxlVp22OuVSaN9dGAKQMHVIz0WuJLRl3p+8PGHii6GYHDEHFemPN76tI/GqkqOSd6Aey78N6V4GJlBzDZEuSd1g4cuL8Mhd3TRb91elP/nihgMGOUY8rEuvEk8mIes82N3sxl/RmYDLQBMoRw0+9vn4qcEzddWrocXAUW9/wPjpSu7oXbvkAJYu4EDEcaeffQwlo6F7P9EI/mipKaEZhmlTA3EOEdMQOMz96Fld7m3ouVJnzx9tfn7w+/ey0btZhybNrOq8rUHoc66PpnBNLSSDosWXovR692e/ZySIY+02NyhNfjKWKlzH3/j+mUMb5QddGvoppA764nhu2Z1zjB8HbBdOLVK1oXnZydM6dHiI2aaFvWc2EopDt3KproN384HChOVYIc6SaPXqvgAti2BuEOuJi/WhqIIXRggY0v+sG8MHRjerzA0OjLSqmqyAOvjN25LXJ6oWpAtZp9bwptaA391i5+s5UZDohOxKLN1DrZFdIq6ns7uvIMlNJwLWDtMaaxDwUoFyGgAzHe+KVDDdbTyNeJRx9W95AYOJrBS+VjlP6MccDibYxqvdpsWVtn/xsbRKHcEKmAU9YEKezw5W6cqSgf020wNz+23tp7XXZpFyEZQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(38100700002)(83380400001)(31696002)(86362001)(41300700001)(2906002)(4326008)(5660300002)(8936002)(6916009)(8676002)(26005)(53546011)(6506007)(186003)(6512007)(6666004)(107886003)(66476007)(316002)(66946007)(54906003)(2616005)(66556008)(478600001)(6486002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFVReTVYb09NUndDS3E2T25TOXo3YUpZTlVCdS9SS2dRWlJYK0tDK25QWW9J?=
 =?utf-8?B?bE1jK3J1eDk3VmViUEFSZmpURmJ6YWZJaGFoaEtBTjRZK1doUkRHc0s3ODVo?=
 =?utf-8?B?eUhSa2xqV2szNTVsdzdVaUlVdVIyTlNRa1V6UlZycEpwZ1IxYzlFSHZEYlVn?=
 =?utf-8?B?M25vRlQxcGY5V2ZrVUlHS1k0N3lZczllbGEvSElsYU81bnhJV0w2S2hqdWYw?=
 =?utf-8?B?RlNDRU90VkVZKzRLSWFEUDYvU3lZcjNKVUx5clpVWFFxQ1RJM1U2QlRTRVVL?=
 =?utf-8?B?c05hZUQzTXQ1dTRNNkpZZTlYTm9WOEhhdFdpWGV1dnFIeTN4KzVUL0lwMDNO?=
 =?utf-8?B?R1F0Qnh3VFlaN1BRRDhGQWhQNFgrY254QWREZkZvUXdWcWlhUy9uSjUvTkRs?=
 =?utf-8?B?K0c0akVEQTA5OHRBd2ErYlAra0ZybGsrTXZUMyt2VVZJUTVFdVdOeW96cUZD?=
 =?utf-8?B?SEx6N0tqTW92NFIxWSsrbTU5Kyt4TGdOdGsxL3cwUXRxelduaXg0OUFRVmsz?=
 =?utf-8?B?QlBWcmVHRXpLVTNiTzQ3bm5KYUJYNHkrWnF6WENZd0gxRnpyMnJVNGZlc09i?=
 =?utf-8?B?MitiN0FVb3laazYzdjJvdzhHb3UvdTB2b29VU2dteXA2TEVuTWRYTzBXdXhP?=
 =?utf-8?B?c1J5eGNjSmozQ09MZTVoL1hkNmc5RzRFcVFOMjNYb2xTRU0xekVIdVpUTU1H?=
 =?utf-8?B?cGorTmpIK0FXd2hWMmRkWmNRVFhkd2twT1pIZFdwa3gwbjNrUWxQY1J1dkFV?=
 =?utf-8?B?Tldmb3F6UzIzUlFxa0pKTm5peWQ4MnN4a25iK3JudU5wYTV1N2Z3RzVJSWN0?=
 =?utf-8?B?WG9uUGx2dTNldmtWd3JtM0J2cWNSMGhYSFNPRldRZ2FaOXhzRVBVY2JvaG9s?=
 =?utf-8?B?ZEI4VjRsbDg4WGplYysxVnh2cDVwNmp3Y2t5U05GdlpCOWVnNzJPZW5qRTY1?=
 =?utf-8?B?TG9ManhpUFcycGlETE9sRjYvdlZvcmdjamJkZVB0amVSR0t1cEtaNEc5OVlY?=
 =?utf-8?B?SUl3aTVnTjFLQkZMRWhPL1JzVW1SUlFQRkF5d1NKL3pGNGZtdTBaQmJyckR2?=
 =?utf-8?B?MHB1WXJZMWM3NWM2SXl4TW5iZERyRWZhMVRxcXNhTDBvcWhvQmpZNnZZWjRI?=
 =?utf-8?B?S29FYjhFSXI0ZUFyWXp2MGhWTFc5aFF6Tm03UTE2a3JSOVdoaHRkZDVKVHVM?=
 =?utf-8?B?T1Z1Ti9IZ01nbTJQZE8veXlHbktYVHc5OFlrUWN5ajZ1dGxsWFh2NHBlOUhN?=
 =?utf-8?B?Vk9JK0lFM1dUcHArd2dlcjBjMGZXTHRlTlkvekwxZzdtV0hLbVRrNzc2U3pt?=
 =?utf-8?B?M1JRZThzc0xLK0ZPeE52ZXppMkVMUm92TVJrTDg1NEZCaEFIYW1sUDNNNWVM?=
 =?utf-8?B?ZXlGdWppKyt3MDR0a0t0WDd5M2ttRWtraWErbFk2Z0ZiSm5VVElHSFd1ZXFO?=
 =?utf-8?B?RERUWk9uR3VBMTV2bHZuY2tuekQrNjlKYVBFUjN1cEcxOFZIQk04ZFo3NEw2?=
 =?utf-8?B?NEcrWlFqbVdxZkVYZjV5eXBkVWM0RnNhV0pvR3MzSG1CTjRnTmthWnZ2b3Jm?=
 =?utf-8?B?cWRmeFpqblRvKzJCS3crckVRVHVnUXBOd2pUT0tDOGQyTUJjS1FpbmpaYWk3?=
 =?utf-8?B?UnZYaVBiR3JhZEJjZEZuQ0lqZWkwUlJXM2wwbDQ2NDV2UWJuL0NrOXU4OWxq?=
 =?utf-8?B?ZlhyY3lhVWJiNTVWREd4TnRYbDZNRXAxWGVUNG5rbVpQMWtLRHBncjV3YVpQ?=
 =?utf-8?B?dDNKVnh1S3EvM2JQT0VEbkNDaWRnK0diQTArQ3JIRmQ0UnlHMndjZ0lGdWlw?=
 =?utf-8?B?eUx3bmtVeUZ5cDlWbnhmL0ovSkk0WEVDaWVXZW9oRkpaNWQ1MVpmMVZtR3U5?=
 =?utf-8?B?YUlWbUx6Mmw4a1MrbmJVMGo0Y3hIbUFUbWNJbWlBZDR6ZTJUTFAzWHlmdXR2?=
 =?utf-8?B?bDdUVXRXYXc2TS8vNUhZVUwwalhneGI4YnpoWTdIcUpCbyttZ0czNzRpQ3gv?=
 =?utf-8?B?WDBrbUxVQ3NjWndwVEpVWURPcVh0VjRGZVV2a1RLbDk1VHRCU1V2d2RzV1Ns?=
 =?utf-8?B?ajZtUW1yL1FrTDV3Z3h5RmxtQS9DbzNvYlBrR3dGRE95YVVneVhGdmdxdGcv?=
 =?utf-8?Q?81iVAH8LKKSW4pT/hRoS/khii?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 316dc12a-693b-48da-bb16-08dafd368a3c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 11:39:51.8768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftvabOt9MLhGZmV55KczXP2wa+XPd0FuVYyg0T7yLyVMIx5iY+MLKtPgLQf6+lhqMk6YnH8bw62c94bmkjWynA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7027
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/01/2023 12:04, Simon Horman wrote:
> On Sun, Jan 22, 2023 at 04:55:07PM +0200, Paul Blakey wrote:
>> For drivers to support partial offload of a filter's action list,
>> add support for action miss to specify an action instance to
>> continue from in sw.
>>
>> CT action in particular can't be fully offloaded, as new connections
>> need to be handled in software. This imposes other limitations on
>> the actions that can be offloaded together with the CT action, such
>> as packet modifications.
>>
>> Assign each action on a filter's action list a unique miss_cookie
>> which drivers can then use to fill action_miss part of the tc skb
>> extension. On getting back this miss_cookie, find the action
>> instance with relevant cookie and continue classifying from there.
>>
>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> 
> ...
> 
>> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
>> index 4cabb32a2ad94..9ef85cf9b5328 100644
>> --- a/include/net/pkt_cls.h
>> +++ b/include/net/pkt_cls.h
> 
> ...
> 
>> @@ -240,21 +243,11 @@ struct tcf_exts {
>>   static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
>>   				int action, int police)
>>   {
>> -#ifdef CONFIG_NET_CLS_ACT
>> -	exts->type = 0;
>> -	exts->nr_actions = 0;
>> -	/* Note: we do not own yet a reference on net.
>> -	 * This reference might be taken later from tcf_exts_get_net().
>> -	 */
>> -	exts->net = net;
>> -	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
>> -				GFP_KERNEL);
>> -	if (!exts->actions)
>> -		return -ENOMEM;
>> +#ifdef CONFIG_NET_CLS
>> +	return tcf_exts_init_ex(exts, net, action, police, NULL, 0, false);
>> +#else
>> +	return -EOPNOTSUPP;
>>   #endif
> 
> nit: I think it would be nicer if there was a dummy implementation
> of tcf_exts_init_ex for the !CONFIG_NET_CLS case and #ifdefs
> could disappear from tcf_exts_init() entirely.
> 
> Likewise, elsewhere in this patch there seems to be new #if/#ifdefs
> Which may be in keeping with the style of this file. But I also
> think it's a style we ought to be moving away from.

I agree, I'll do that for v5.

> 
>> -	exts->action = action;
>> -	exts->police = police;
>> -	return 0;
>>   }
>>   
>>   /* Return false if the netns is being destroyed in cleanup_net(). Callers
> 
> ...
> 
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 5b4a95e8a1ee0..46524ae353c5a 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
> 
> ...
> 
>> +static struct tcf_exts_miss_cookie_node *
>> +tcf_exts_miss_cookie_lookup(u64 miss_cookie, int *act_index)
>> +{
>> +	union tcf_exts_miss_cookie mc = { .miss_cookie = miss_cookie, };
>> +
>> +	*act_index = mc.act_index;
>> +	return xa_load(&tcf_exts_miss_cookies_xa, mc.miss_cookie_base);
>> +}
>> +#endif /* IS_ENABLED(CONFIG_NET_TC_SKB_EXT) */
>> +
>> +static u64 tcf_exts_miss_cookie_get(u32 miss_cookie_base, int act_index)
>> +{
>> +	union tcf_exts_miss_cookie mc = { .act_index = act_index, };
>> +
>> +	if (!miss_cookie_base)
>> +		return 0;
> 
> nit: perhaps the compiler optimises this out, or it is otherwise
> unimportant,
> but doesn't the assignment
> of mc zero it's fields, other than .act_index only for:
> 
> 1. Any assignment of mc to be unused in the !miss_cookie_base case
> 2. mc.miss_cookie_base to be reassigned, otherwise
> 

It should always zero all other fields with such assignment, and both 
are equivalent while we don't have any other fields.


> FWIIW, I might have gone for something more like this (*untested*).
> 
> 	union tcf_exts_miss_cookie mc;
> 
> 	if (!miss_cookie_base)
> 		return 0;
> 
> 	mc.act_index = act_index;
> 	mc.miss_cookie_base = miss_cookie_base;
> 
> 	return mc.miss_cookie;
> 
>> +
>> +	mc.miss_cookie_base = miss_cookie_base;
>> +	return mc.miss_cookie;
>> +}
>> +
>>   #ifdef CONFIG_NET_CLS_ACT
>>   DEFINE_STATIC_KEY_FALSE(tc_skb_ext_tc);
>>   EXPORT_SYMBOL(tc_skb_ext_tc);
>> @@ -1549,6 +1642,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
>>   				 const struct tcf_proto *orig_tp,
>>   				 struct tcf_result *res,
>>   				 bool compat_mode,
>> +				 struct tcf_exts_miss_cookie_node *n,
>> +				 int act_index,
>>   				 u32 *last_executed_chain)
>>   {
>>   #ifdef CONFIG_NET_CLS_ACT
>> @@ -1560,13 +1655,40 @@ static inline int __tcf_classify(struct sk_buff *skb,
>>   #endif
>>   	for (; tp; tp = rcu_dereference_bh(tp->next)) {
>>   		__be16 protocol = skb_protocol(skb, false);
>> -		int err;
>> +		int err = 0;
>>   
>> -		if (tp->protocol != protocol &&
>> -		    tp->protocol != htons(ETH_P_ALL))
>> -			continue;
>> +		if (n) {
>> +			struct tcf_exts *exts;
>>   
>> -		err = tc_classify(skb, tp, res);
>> +			if (n->tp_prio != tp->prio)
>> +				continue;
>> +
>> +			/* We re-lookup the tp and chain based on index instead
>> +			 * of having hard refs and locks to them, so do a sanity
>> +			 * check if any of tp,chain,exts was replaced by the
>> +			 * time we got here with a cookie from hardware.
>> +			 */
>> +			if (unlikely(n->tp != tp || n->tp->chain != n->chain ||
>> +				     !tp->ops->get_exts))
>> +				return TC_ACT_SHOT;
>> +
>> +			exts = tp->ops->get_exts(tp, n->handle);
> 
> I see that this is probably safe, but it's not entirely obvious
> that tp->ops->get_exts will never by NULL here >
> 1) It is invariant on n, which is set in a different function and is in turn
> 2) invariant on ext->act_miss being set, several patches away, in the driver.
> 3) Which is lastly invariant on being a code path relating to for
>     hardware offload of a classifier where tp->ops->get_exts is defined.
> 
> Or perhaps I mixed it up somehow. But I do think at a minimum this
> ought to be documented.

Yes, I check for get_exts above it, and for !exts below it.

> 
> Which brings me to a more central concern with this series: it's very
> invasive and sets up a complex relationship between the core and the
> driver. Is this the right abstraction for the problem at hand?


I think so and the changes are pretty minimal, and align with what
we currently do with sw/hw cooperation.

> 
>> +			if (unlikely(!exts || n->exts != exts))
>> +				return TC_ACT_SHOT;
>> +
>> +			n = NULL;
>> +#ifdef CONFIG_NET_CLS_ACT
>> +			err = tcf_action_exec(skb, exts->actions + act_index,
>> +					      exts->nr_actions - act_index,
>> +					      res);
>> +#endif
>> +		} else {
>> +			if (tp->protocol != protocol &&
>> +			    tp->protocol != htons(ETH_P_ALL))
>> +				continue;
>> +
>> +			err = tc_classify(skb, tp, res);
>> +		}
>>   #ifdef CONFIG_NET_CLS_ACT
>>   		if (unlikely(err == TC_ACT_RECLASSIFY && !compat_mode)) {
>>   			first_tp = orig_tp;
> 
> ...
> 
>> @@ -1606,21 +1731,33 @@ int tcf_classify(struct sk_buff *skb,
>>   #if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
>>   	u32 last_executed_chain = 0;
>>   
>> -	return __tcf_classify(skb, tp, tp, res, compat_mode,
>> +	return __tcf_classify(skb, tp, tp, res, compat_mode, NULL, 0,
>>   			      &last_executed_chain);
>>   #else
>>   	u32 last_executed_chain = tp ? tp->chain->index : 0;
>> +	struct tcf_exts_miss_cookie_node *n = NULL;
>>   	const struct tcf_proto *orig_tp = tp;
>>   	struct tc_skb_ext *ext;
>> +	int act_index = 0;
>>   	int ret;
>>   
>>   	if (block) {
>>   		ext = skb_ext_find(skb, TC_SKB_EXT);
>>   
>> -		if (ext && ext->chain) {
>> +		if (ext && (ext->chain || ext->act_miss)) {
>>   			struct tcf_chain *fchain;
>> +			u32 chain = ext->chain;
> 
> nit: ext->chain seems to only be used once, as it was before this patch.
> Perhaps the chain local variable is an artifact of development
> and is best not added?

It is used to share the chain lookup code below without new scope or a 
'?' op (e.g n ? n->chain_index : ext->chain) which I think is cleaner.

> 
>> +
>> +			if (ext->act_miss) {
>> +				n = tcf_exts_miss_cookie_lookup(ext->act_miss_cookie,
>> +								&act_index);
>> +				if (!n)
>> +					return TC_ACT_SHOT;
>>   
>> -			fchain = tcf_chain_lookup_rcu(block, ext->chain);
>> +				chain = n->chain_index;
>> +			}
>> +
>> +			fchain = tcf_chain_lookup_rcu(block, chain);
>>   			if (!fchain)
>>   				return TC_ACT_SHOT;
>>   
> 
> ...
