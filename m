Return-Path: <netdev+bounces-7775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0726B721771
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 15:33:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B8B4280F96
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1791AD2F;
	Sun,  4 Jun 2023 13:33:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C158BF9
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 13:33:11 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD09DE
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 06:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPc24x/rBLO1XaKwWHX4RvsFsLEOvcpKdlX6Au+4zhWfqH2jaI7vkvr0H5BggYOz2KrA+RLtej+THq/ifHQ6HOfcxt0LRy7Ju0fqWrfUKNKLjPXTyGUSjKHOZKDfCSeLVWxfwaHbzZUv8g9+aR4N6O2WO0wjKzzW5G9sT8R/bzJtXAojsCMjujMlI7ygJVlNFLvx56w2Tr+aBpxU5NerUik/b1W5KNozWAiGv+yQn9NbcQpPJ7ClSjPGaQ2aiZn0banx91VghrgGPoGMXKgepX5oYNJ7rdbsLDg1dKRRpZJgP5w0LsqOaobDz+U+XANqgcfegk2w88YMfE1umfaSYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8jGSruOf5CubbY4z3mW7OGGV2M3jkVZnsjZs3lm4q8=;
 b=kYqI+wP+rnzfVtaE/iZMpGQihPpBP9l91JFDUpIiMK0g36EvDhAbAlNVupA1IS1O3VxZ3BG94j+upIGfCObtae8zLMsk4i9X2reP7r4iaCvjZm8VrM42YaRN4QHX2T5EGmb+IMeqq6MVtwor9ink0HKoezicln08sawQZSeXfYHvYBZF/RxK92uOAtnkEZONbHXdPRN+kwOXOamggLAAwP6VTjGEy1SkvYCOocjK7uUu+Cm+ZXM1YwPi9cMl78pz6BDYaOZCdfOXfagPUA5AqTxsecx9HdTcMeXhFaBxso71vac4xYXzCUZb0Wzqy0jX1UJ92uyvQSEEsXo9ZIz7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8jGSruOf5CubbY4z3mW7OGGV2M3jkVZnsjZs3lm4q8=;
 b=j8g5VXxcfI8NK4LnQbGZKXqiztaDJ+i66CD+nIiHr5ZBXSGMpkFiKrImJ13wBYxFi5JuSGnCYiIfHmtrXoYwHRxq58RvO+NSOrnsm6IEQDR0YNACX7qWdsiWieQiPFdnzz2/2a79wWEQZ3hjGtTZpSoAf26uOR2/y1kddJWAutwJKR/TgiFTV5JGf1p+SV3o+tlzP9+ZfRyyXOsxTJQdggZY8WyKv9l1VkOQLAWC1Aap1LsXL7loDO2eroq9VJZZcgcFRQuMZyXDGqOfbk7Gw8NfA0aMX6LfQZJPBpAJWCndHz4I/NJ8v62DaoxMn1dUdGyTercqkYgs5TFN3v+qvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MN2PR12MB4374.namprd12.prod.outlook.com (2603:10b6:208:266::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.27; Sun, 4 Jun 2023 13:33:08 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402%4]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 13:33:07 +0000
Message-ID: <99d127c4-d6cc-4f68-8b73-3ba4f4e6b864@nvidia.com>
Date: Sun, 4 Jun 2023 16:33:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2] lib/libnetlink: ensure a minimum of 32KB for the
 buffer used in rtnl_recvmsg()
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Ahern <dsahern@gmail.com>, Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
 Hangbin Liu <liuhangbin@gmail.com>, Phil Sutter <phil@nwl.cc>,
 Jakub Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
References: <20190213015841.140383-1-edumazet@google.com>
 <b42f0dcb-3c8c-9797-a9f1-da71642e26cc@gmail.com>
 <7517ba8c-2f51-6ced-ba84-e349f5db8cac@nvidia.com>
 <20230531145148.2cb3cbe8@hermes.local>
Content-Language: en-US
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230531145148.2cb3cbe8@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0174.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::17) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|MN2PR12MB4374:EE_
X-MS-Office365-Filtering-Correlation-Id: 751b70b5-1464-4ef0-52df-08db65003b87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tnsWO4H/+GZEeOB2SdnBTWA/RpOrubskC3swMhUrjNyWyEP3FOFMr4pNOEeby/mh/O6TUl4AsCvgKbcS7GOtnyE6xjYYL2QCOl8KMhZUvv+acL0YARjGKhvG8fLRY10u63eod1JPjx1ehP0e0BVAyE5oIWwvzSW6hV6IL/Lm6O0/Yb0vpaiJZLW245YpL/5FNchKTj3ubhvErbfEFZjLbRGCbb46Kq8MpoQK/H/bc0ruCVb28XKX7y1DE5kHVdir77LXQlQjOPx5ixBz1V/GqIIfvphvD+m4etOC44Hpxf9nfb5RORLjAHIhbgkVjxrcqtKlVxc/Tr5zuIoWIaHhiSQHGiU5cKLCZWgucv5lpTRsen9b2XhuURa+lKyc71ueZlPDNPEQFnTaVQ2T65dyhbYfQCZOq1Z86N/CKGfU0A1Fzq0c0D7KzAC6VxK72Oe37w4u77yvw5ZxyvVkj6Kxeilk8hLF1tzOzcX+sGtePeCt65UuqmC2H0JR4yYCPBeLAOXsKJmHDnH2lamBbTedCsI/Svw+EoCe+ENzBlDywaFeWZkLScdKNBA7lDntvWvKIHVXwx3jcZ23/V3VVI1U5Amm6GGcDSQcyK+DKnFmGgG1uJx6ulJvsX6B4qLuZl3axjj6VSKoo5QPktvNA725yg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(4326008)(6916009)(66556008)(316002)(66476007)(66946007)(186003)(2616005)(38100700002)(31696002)(86362001)(26005)(6506007)(6512007)(83380400001)(53546011)(6486002)(478600001)(6666004)(36756003)(54906003)(31686004)(5660300002)(8676002)(8936002)(2906002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1hCUTlIMzVuRmpYWUl5dERUVmEvT3F6S0lJbC9MNis4dmNhQ3FQYU0yS2hP?=
 =?utf-8?B?M1FHNUJYMzlndU9hMFQ1RjFHTTMzalAwNVJ5a0Q2M2w3Y1JxRW1YWXRmTngv?=
 =?utf-8?B?MXlQSmdBYi93QkIzRUtWVFlsTldJV2czTzdLNS9wTWxwZktjZnh5Z1dia3lE?=
 =?utf-8?B?akJsYkNHTmdFM3RWQzA5eWhZeE1ycTBhSEV3dnZvWCtrTDE3WGRDRi9hMEc1?=
 =?utf-8?B?bmlRdXNlbGw1OXFCMTlITU4vekRBbzRqdXV3R25VSXBUTzViaVpaOWNnc0Jl?=
 =?utf-8?B?dXV3WTM1a2xyclBvc3B3Z3V1RHV2OUN2aFYxai9MbEN3Qno1TFo4M1JpT3Zr?=
 =?utf-8?B?K1pLNlpqUXl2dE1jRzZKWXpDV2t4Qnl1VDRheFJLc2FEanhUMGxKcXM3SVcx?=
 =?utf-8?B?bGwzdU9BUFh1RktXKzAySkpqcTFIRTdadW1ObGx3eXc1OHRWYzJ3SDFPTGZS?=
 =?utf-8?B?ZmhZaThZajlFTzdxdGxlcm02U2h1d09xdklKR1RqVUV0NUxGeUVaYktldHY4?=
 =?utf-8?B?TklVRG1vVzRGNVR5NjZGWXB0cmFCM05IYlltU2ZxYnU2YnpsMWJvSGs0ZXEr?=
 =?utf-8?B?YmVNT1VFK0pqQmgwNzd0cFNQcjRrUGI1dlY0ZERGSWQ4UFJLVWVhSnJmSEQw?=
 =?utf-8?B?dStyUldlWnJ6Z2pSSjk0b09ZdzlHYzlGT2NvVFdpMjA2MDBUS2liNFJZaHNj?=
 =?utf-8?B?L0VHVnpWc2Jia3RkVmpQSkxmZHNyTjZ4SVJPMWNQWVFaS2FXK3owVkdBdDYz?=
 =?utf-8?B?SVBIa0plN0U4VHJTcDhOVlhMaGRyVGJSTHlGQkZsbUM2aFE3eWJBOHBwNmJ2?=
 =?utf-8?B?VGhISnJSN0pLUmFnUnJQbG5tMjhGc01rQ1JIbVlvcytnQWhtSFY3clVaam1y?=
 =?utf-8?B?dkcxVC9TUDlPYmRjd0JxREFId2lIN0REZEN1Mk4raXNuSkRZUy8rZnJPSGdi?=
 =?utf-8?B?dXdQM1VEV0l0RVRDaW1ZMmJzM21CbmkxK3N6T1l5ZkgwV2xmMWNhZk1SemZK?=
 =?utf-8?B?THU0dGQ4b2NhYTk5UDR2QmM5amFIMlNBZGE4TE1sY3cvSHY1MWp1dXNCTEdG?=
 =?utf-8?B?U09Wa0VqbjVrcUV3TlRiR2I2Z2oyeHh5eVo0NWQyNlMrb1Nuc3BlZVQ1Zmw2?=
 =?utf-8?B?aSt3R05NMkRnTmxJMWFWOEMwVmpBNm54eVlUV1NWaXhyTmdTaUNMVzM3b0Zi?=
 =?utf-8?B?Nit1Ri9kaE1zZDYvOE5TVXVrZGI1bWp5Nll6eTVhUzRaSUJXUi93TVduaUJU?=
 =?utf-8?B?VWFoWFhuR3RkSVlVWFIyVFhobjEyZ3dlbWJxWUJOQk9LcmlNSEw4U0d4STlR?=
 =?utf-8?B?ZW9tSGdDZHZpQWZBbjNvR01EYUhTVVRiY3JWMlJ5Tzlhd0tUN09jM2VOTGxx?=
 =?utf-8?B?Zk5ZcVhmZmZJZCtPbVBic0hxT3NFdWpqSjM0Ykh0TGoxVkx6SDZ2VnQ3aEdx?=
 =?utf-8?B?WlRueTZGRS9UTFNqdUFJUUJ6UDNob09vTStibVVSelN1anhuU1RlL1ZuZGs4?=
 =?utf-8?B?Q1lFVlRsbyt3WlFSQmZia3pmSXF5ZDN2QXBEaVdrOGV0dG0wZGhUY2p5SkFX?=
 =?utf-8?B?UE1OeG9oT0FnUkxEY2JkLzViU1UxZmUrNHVzNkxvZlFKYk5QMWlybFNUY2VV?=
 =?utf-8?B?TGtNTFZGdEQyNFQ3eStBWWJCSk5mWWF0NS9PdGE3QzI2enJEMUllQjNpdEpS?=
 =?utf-8?B?VENlOUpxWk5GeCtkaFppNHlncWNmeVRNSHFhbnNqZmJTdWVNREp5V1dML1Bh?=
 =?utf-8?B?ZVFGN1ZJWm9hUEVmbi92WDJqTnFwdlROUTRrSytMamNjZjBxaFUwc1N5bUU1?=
 =?utf-8?B?ZzIxTW5RUEV2QUtXOE43OUo3bDFRTk13Y1VneWxMTmQ3UlhUVkpQZ2h1TGtL?=
 =?utf-8?B?WkZQdDNjaUNrZi9XRUVZcTV3VXNreUx1WXBFdHJ0K2Z3NFF6a3lveWlCUyt5?=
 =?utf-8?B?cm85ZW0yZWl0Vnl0Y01iQ3J0UnA0dFpETExXZDdTYlFTb01nQ2NCeUJUNU84?=
 =?utf-8?B?eSt2d25GVzFMalRPZEQzcjFUYnZxbjl1bzBnUTFUcTh3cUtsL09JbEFGZXND?=
 =?utf-8?B?VEpQZ1NDMWdnL3g3VmJZblo2KzZKOElhZ0RpRjBBWVVOSFIwRWwyYkdkQ24r?=
 =?utf-8?Q?QoaS+OvYBz5CbOquCjzFH6t50?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751b70b5-1464-4ef0-52df-08db65003b87
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 13:33:07.8758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3asq9dN10CALL+U2h/dXws6WCtVRS5qioQF7eLa2BMbb8T9+KruMd8EOXEv7QF2D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4374
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 01/06/2023 0:51, Stephen Hemminger wrote:
> On Mon, 29 May 2023 15:29:51 +0300
> Gal Pressman <gal@nvidia.com> wrote:
> 
>> On 13/02/2019 4:04, David Ahern wrote:
>>> On 2/12/19 6:58 PM, Eric Dumazet wrote:  
>>>> In the past, we tried to increase the buffer size up to 32 KB in order
>>>> to reduce number of syscalls per dump.
>>>>
>>>> Commit 2d34851cd341 ("lib/libnetlink: re malloc buff if size is not enough")
>>>> brought the size back to 4KB because the kernel can not know the application
>>>> is ready to receive bigger requests.
>>>>
>>>> See kernel commits 9063e21fb026 ("netlink: autosize skb lengthes") and
>>>> d35c99ff77ec ("netlink: do not enter direct reclaim from netlink_dump()")
>>>> for more details.
>>>>
>>>> Fixes: 2d34851cd341 ("lib/libnetlink: re malloc buff if size is not enough")
>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>> Cc: Hangbin Liu <liuhangbin@gmail.com>
>>>> Cc: Phil Sutter <phil@nwl.cc>
>>>> ---
>>>>  lib/libnetlink.c | 2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
>>>> index 1892a02ab5d0d73776c9882ffc77edcd2c663d01..0d48a3d43cf03065dacbd419578ab10af56431a4 100644
>>>> --- a/lib/libnetlink.c
>>>> +++ b/lib/libnetlink.c
>>>> @@ -718,6 +718,8 @@ static int rtnl_recvmsg(int fd, struct msghdr *msg, char **answer)
>>>>  	if (len < 0)
>>>>  		return len;
>>>>  
>>>> +	if (len < 32768)
>>>> +		len = 32768;
>>>>  	buf = malloc(len);
>>>>  	if (!buf) {
>>>>  		fprintf(stderr, "malloc error: not enough buffer\n");
>>>>  
>>>
>>> I believe that negates the whole point of 2d34851cd341 - which I have no
>>> problem with. 2 recvmsg calls per message is overkill.
>>>
>>> Do we know of any single message sizes > 32k? 2d34851cd341 cites
>>> increasing VF's but at some point there is a limit. If not, the whole
>>> PEEK thing should go away and we just malloc 32k (or 64k) buffers for
>>> each recvmsg.
>>>   
>>
>> Hey,
>>
>> Sorry for reviving this old thread, but I see this topic was already
>> discussed here :).
>> I have a system where the large number of VFs result in a message
>> greater than 32k, which makes a simple 'ip link' command return an error.
>>
>> Should we change the kernel's 'max_recvmsg_len' to 64k? Any other (more
>> robust) ideas to resolve this issue?
> 
> No matter what the size, someone will always have too many VF's to fit
> in the response. There is no way to get a stable solution without doing
> some API changes.
> 
> It is possible to dump millions of routes, so it is not directly a netlink
> issue more that the current API is slamming all the VF's as info blocks
> under a single message response.
> 
> That would mean replacing IFLA_VFINFO_LIST with a separate query

Thanks Stephen!
How would you imagine it? Changing the userspace to split each (PF, VF)
to a separate netlink call instead of a single call for each PF?

