Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E460F51DDAC
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392177AbiEFQiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 12:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358520AbiEFQiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 12:38:18 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069835DA52
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 09:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=me1GlME2QK0xGBWboxP1tdvnA/gRUk0RJevVvyhJqRt+tbiKdFvhsYh2t/ufbcIQ3DfnTPb9Elpe/266zrrZKbAOiFc0rmuaVT0IFA7VZlcFSrAL3gfj5yC3kkuyCRKwC64cFDXXJk46t6iwxFNgFRjdvs/b05eYonx4zW9skkvIO4Gt7tet+K1uoFJ08EUNB68qWZbo0+7ark/x2Rgdc6rbUqbqgLAdOWWQoQznqcbDus9bAStExaPBw18+wl+jfs+zbd84ihCZApP/z91atL8a+h0bA65XF0Gr1eanmJCrdzs24l1zNT+Adr5Dnrj0wyfXMdbdweAQUrARPd8acQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5svlUGm2izAYGLkyHOluvBqGRh4Xmmyirs9Nlw2j3A=;
 b=lYzGMl22WUFYG/kQ71IOkI+Nb+esGpxhycBH21eJI1eufCBjLDCBDYGgVdnivhWceHnIAengtscyCRYuptzcVZIpKklbRFJi9VDuQfgjIr5Jsc6Hqx64xgYFG6serSYOHUr+j7KyUwE10aBQdglZRSfxq7jPCpZqfgO9RKXaA05KI+cbuT2q65PBxCQCNbvdP0kJcLDzoQ4kH1zP3/vzoCDyDMBZYBtkxfnrgBi9L9w51MXMUaBtok+h7Yt8f2JSntKsoQA1h6i1QOtCawT1Tovcao34XzKNre5lEJybtVrn/YQe8SYzH1kPRZavy48E5ZvX9rjdHL33sqokGBi6Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5svlUGm2izAYGLkyHOluvBqGRh4Xmmyirs9Nlw2j3A=;
 b=VRrZTh4Hzu6YeHD5kcbbujhGATnZnp65oYSWN7oI0AuNXi9tpW9meEyaFxzLQoOrfbdb1L+YuLOAJUIk55JPnyIX0F2GIvsmz0HrJOaX5Q1/GVjPmSeuW3bXXRcjuXPvpyTiyq/+QNL2RYqk3Dm476atLLlSz4myCvLM9R6Umfgnz9aH02vigt9k5kQ7pPxhVUZGKySUUVmIfkG4fx/jWSXGfytmc4z2wt3tCreyB1lx3t86H9AVoD2PCSbmSyh4asTHSc9376TOYFX/cbxHAoQhVbErazfU0MjiGDIozDFMePXwIAQYrUWwBhDT74dwwSJJsxhzdw55sm1gJG/gwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22)
 by DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 6 May
 2022 16:34:33 +0000
Received: from BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::cdc2:b13d:821b:d3d7]) by BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::cdc2:b13d:821b:d3d7%4]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 16:34:33 +0000
Message-ID: <e837a0a7-dff5-9c56-d84c-f2c050656c0b@nvidia.com>
Date:   Fri, 6 May 2022 19:34:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220427175048.225235-1-maximmi@nvidia.com>
 <20220428151142.3f0ccd83@kernel.org>
 <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
 <20220429121117.21bf7490@kernel.org>
 <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
 <3f5f17a11d294781a5e500b3903aa902@AcuMS.aculab.com>
 <41abbf9f-8719-f2a7-36b5-fd6835bb133d@nvidia.com>
 <5dba0c54c647491a85366834c8c1c7d1@AcuMS.aculab.com>
 <f1fa7f2c-d5ef-256b-0bc3-87950c2b6ab7@nvidia.com>
 <1f45be856eae43a5bca0af524f5b02b9@AcuMS.aculab.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <1f45be856eae43a5bca0af524f5b02b9@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0416.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18b::7) To BL1PR12MB5142.namprd12.prod.outlook.com
 (2603:10b6:208:312::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83cef305-47cd-4153-b659-08da2f7e4ca9
X-MS-TrafficTypeDiagnostic: DM5PR12MB1244:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1244C0112AA42BB7072B598ADCC59@DM5PR12MB1244.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cwwzrnhpB1OUg4vlqymSwnSSAiuYOHnhQS7c+loGgZ4BgxKi+d50eGcESwkWOwsZ3nLh2po8KMnv4dfV3eTGNTj/boRMrryLp5lk3otzkX/PCLV34208LLKG9l4CKiASyJV88D4HKJcRr5tqFw1R8tv7XXr/nvxEIbMVLFxDX0L4ifas+1TgMZusylzRUcwwxkdDawLNustz88Zz+7YCkMgOuBXXdoraFtRClg31C9KCZpinto1qEkj4M+NVMbmjDM7krLlP3CRgp726d/MuzOQhb9M7+CNbmbhya9UTPazwUFB2Q+QI+rSUHpXUcB7fish5A+x/QXhZqfcg8R5hk7V58j/FiBx85g2qOhjxK31LjlJHXoRkuKVxNWhvn9+SmqYcfOe9isAD1ewRelSaKUvmDAAdKvxGtvpVunwR4BTzn09a8GGHiyH2dDFG1rzI8XkdCxsN3KTIUzRkbR36tt1Pdt20LdX3/pi8oFZltpHSP9zWr+HWW4xhMIQhmy23uxU/AhHAo5sKMn+syr4mpHqp29ZotN7wg47Ucqy+ieOdwLUZvyKHUGTLbbnnmzBTwpNYWZECGOcjGwu+aZXwNOJmycmAIfRyKYNooc63PfAUYhnILlpaSW/u++zPNTJe+OzFRXnRatZCiDQF6VGEqa5D9jDncdyBLZ5ra6ecXzSy1veChNpeltPy7qTwBvCp53dGOQWDCrFGKpe4bGw9Mn79zWJpmM7dSyqTVbJiHbc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5142.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6666004)(26005)(6916009)(54906003)(38100700002)(6486002)(2906002)(316002)(2616005)(186003)(86362001)(508600001)(31696002)(6512007)(83380400001)(36756003)(53546011)(31686004)(5660300002)(8936002)(8676002)(66946007)(4326008)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0ZqL2ZQZC9jb2F3SUpHNHgwelcxaytoTjBWNk5BVFlMOStwemJDWDZ2N3lW?=
 =?utf-8?B?NFNMdlU2QVJCQkpNQ0oxL3hOTEhOYnN0QnZJRGREbXBsWVVIY0doY3EzVlAr?=
 =?utf-8?B?Sit0ckdncGVPenFvZStIR2Vld0tabVVvLzVOK2FPZXhQbnpjeGJubjFoNWFQ?=
 =?utf-8?B?a3oxWlFidUpHR3ZPRVpHdnJUOXM0VWd1c3NoZktBRkF2L0Q2QkF2OU03V2Vt?=
 =?utf-8?B?eVl4dWY0bWsxNXRETU80dVZKZlliVEdjcGpQUmprcHJmRmlCbDhCZHlFdkti?=
 =?utf-8?B?RTYyUUZvZTlSQkxOYU92bUY3Y25ibWJhcDlOVkY0eTFSdUFReGphaGNYdGFR?=
 =?utf-8?B?M0FMYkJQV0lLV0ZLOGZuSit0anc2Ukhpb2x6eUpGRHdEaHc5UVEySTk4Rmxq?=
 =?utf-8?B?UHd4L3lneDJ2Y2Y2QmEzQXNQZHFHZWljb2VJYk9nZmpkUlMxMzA0ZEVpV3FZ?=
 =?utf-8?B?TFN6Rzd4RjNTd1FZYjJHQVpUMVM3L21TZkpHMElFN1AzdEQ0Q3NkUWlmYU9G?=
 =?utf-8?B?a29mQmxnMFdjQWo4ci9sMjVqcmlBL1BYcTZZWVVWcUp3QjJIUHBqcU11MnAr?=
 =?utf-8?B?WDhYb3NzSDE1QjZkdEFBOUpYSGhEWERuVkg3NUZJVmVQSnFLRGxjZG51Qnlw?=
 =?utf-8?B?eml1Yys5UGpRdTVVOTlha3JMc0JsS09jMXIxb2lLZFpZQ3ZOazdwK3R2R0d2?=
 =?utf-8?B?OHZwdDdjbW5xZ2pHSFhxa0pQc1JZbFBrcDZRdU1uRVVub1U5aTFNcXpaZ1hG?=
 =?utf-8?B?TWNHeFd4QmtiTjk3YzFTWXRiK0JXT2VycnZNenpCQXBsdVQzVEN3M1FSTWtk?=
 =?utf-8?B?Tlc3S2ZpWm9ZZm96L01SbTFPQTV6SHZ5ZUR3Q3VMcmx2eTd2Mk91WVpFQXRI?=
 =?utf-8?B?MUR3VUcyTDlIeGxESk1KS0JIbDBEMnR2a3lOT0JqUXpMM202QnFPOW5ySEFN?=
 =?utf-8?B?QlVuZGdLUE0wNUdZdCtyTE95SjZFNnBxRlVJNThHOURmLzFkeEVBWS9TNk5i?=
 =?utf-8?B?aTU4N0tVMnV6OWVqdjBzZkZLak5zYUxBR0tGam5TK0gvcUV1MlVlK2RyeWFP?=
 =?utf-8?B?aDFqeW1acFZWUEJ6UEdScGphSFFUTmhNTlBzR1BuZ1BoRENFbVJkVG9RWlhC?=
 =?utf-8?B?TkNic29jOHVIYURQZDB4RThoZFZaTzRud3pmYUJHMVBNcjBVQmpSNzZMYmN3?=
 =?utf-8?B?b0l2cFRCNlRFcHIvQ1A4NzRJTm9FQnhzUG03WDEzejVJTlRJdFEvN0hKRDdT?=
 =?utf-8?B?T3JIT0ZrOWhnNUR5bEZwaU14QUp3V3hmYUx1bEpmNWlTMmRxYVdzQW95MEdD?=
 =?utf-8?B?c0ZTRWpmTnVxUE5Qb2owdldPTXRlVVp5Vm5YdzZMS1UySkVUdVRYQ0ZiRXlX?=
 =?utf-8?B?N2FoRVZ5WDJDYzFHbk1xQWpwdklzMkFTQWhOanVrZ1pSbG9KN1BTVk9WOGpN?=
 =?utf-8?B?OTkybEpWNzFkY1J4QUlEak5oZkFiQ05VQjNEU0RJMC85aVBxOVB1dFZFNHVs?=
 =?utf-8?B?cjQzTnhiOXZWcHVmM2lZdktyeWp6T256VzRVUk9oU1hFY0FHRkRLQkp0aFJK?=
 =?utf-8?B?TG9Veis0blRZUTYxZWttME12RlYwSFcvQ3R0cEp1c0ZNZEFxYkQyYVZzYTdE?=
 =?utf-8?B?Ukg1MDNEOWFyejFuS2Q1QVEvUWRUcDdmV2piQWhoQ0xJUHRWT1p2NE9iRGh2?=
 =?utf-8?B?MVUyNTFvOWJaZmhNS1ZKUXVwZmYzQ3FNdE5YUWNoa3pSUDNZWk1jdzZ0N3hT?=
 =?utf-8?B?WVEyMExDeTVadjdnVlFFUWt1d0NGai9MUjVwdzJkajZPaDFyWDRiVmZnNiti?=
 =?utf-8?B?OFpsdUJBdFJYOEo0dzFDQ1dpZVdRZmE0c1NlQjZTWEF4c0hCSkpKQlF0WHpP?=
 =?utf-8?B?NTVVTlhuNjgrODhaRGRmRmw2M2hlZ3dNSGljemUvYiswazJYdnhPOW01Z2tj?=
 =?utf-8?B?ZkI1VFhYc3IrVW91UHBQdkNxN1duaEdZMmdIeE1MUUpoZVJNaG14RkpTbGpV?=
 =?utf-8?B?VEhPUUJ2TXFqTTlZZEY3WmtxNFEvMHdObFZ6MmdTRzlyNzN2azNVRHdnYm9V?=
 =?utf-8?B?dkVLS3VGSnBuMW1RNlVBc05lb1QwVVFaMkJ1ck5LeVd6K3V3NHdZYWNIaUpT?=
 =?utf-8?B?RTg3dmVuVkZ2TVRRbHQvaFBOVkVxaGtqYUtVYzV2UEhJZFBQWUUzOWMyU0k5?=
 =?utf-8?B?RkxXTnBpdWgvRFdWeUVxLzZjZWFzZ01veXJiK0ZKZC9UVXlIT0VrL2hBaDlk?=
 =?utf-8?B?dmxLbnFmQ3ZndUVhbG1UVU9PNXNvaTQ4cGpheDdRVkxjcmcySDNUaFBMa2Zz?=
 =?utf-8?B?K3NGdDE4TU9rZjBZQVZiR083bDJPdUpvSStPbk1CaW5QUkNaY2Zxdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cef305-47cd-4153-b659-08da2f7e4ca9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5142.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 16:34:32.9777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fCdoubmsZfuvVieF+16bhETCd7PZWTEly0esxxWwsctsKyOfrCakx7HwkWgHD0o7iE2MqTC1ntt8vBP3aUy13Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1244
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-06 11:09, David Laight wrote:
> From: Maxim Mikityanskiy
>> Sent: 05 May 2022 19:28
>>
>> On 2022-05-05 16:48, David Laight wrote:
>>> From: Maxim Mikityanskiy
>>>> Sent: 05 May 2022 13:40
>>>>
>>>> On 2022-05-04 12:49, David Laight wrote:
>>>>>>> If you declare the union on the stack in the callers, and pass by value
>>>>>>> - is the compiler not going to be clever enough to still DDRT?
>>>>>>
>>>>>> Ah, OK, it should do the thing. I thought you wanted me to ditch the
>>>>>> union altogether.
>>>>>
>>>>> Some architectures always pass struct/union by address.
>>>>> Which is probably not what you had in mind.
>>>>
>>>> Do you have any specific architecture in mind? I couldn't find any
>>>> information that it happens anywhere, x86_64 ABI [1] (pages 20-21)
>>>> aligns with my expectations, and my common sense can't explain why would
>>>> some architectures do what you say.
>>>>
>>>> In C, when the caller passes a struct as a parameter, the callee can
>>>> freely modify it. If the compiler silently replaced it with a pointer,
>>>> the callee would corrupt the caller's local variable, so such approach
>>>> requires the caller to make an extra copy.
>>>
>>> Yes, that is what happens.
>>
>> I did a quick experiment with gcc 9 on m68k and i386, and it doesn't
>> confirm what you claim.
>>
>> #include <stdint.h>
>> #include <stdio.h>
>>
>> union test {
>>           uint32_t x;
>>           uint32_t *y;
>> };
>>
>> void func1(void *ptr, union test t)
>> {
>>           if (ptr) {
>>                   printf("%p %u\n", ptr, t.x);
>>           } else {
>>                   printf("%u\n", *t.y);
>>           }
>> }
>>
>> void func2(void *ptr, uint32_t *y)
>> {
>>           if (ptr) {
>>                   printf("%p %u\n", ptr, (uint32_t)y);
>>           } else {
>>                   printf("%u\n", *y);
>>           }
>> }
>>
>> gcc -S test.c -fno-strict-aliasing -o -
>>
>> I believe this minimal example reflects well enough what happens in my
>> code. The assembly generated for func1 and func2 are identical. In both
>> cases the second parameter is passed on the stack by value, not by pointer.
> 
> Hmmm, perhaps it is/was only sparc32 that passed all structures by reference.

Looks like sparc32 really does this crazy thing (and if the callee wants 
to modify the union, it has to make a copy). Well, it's always great to 
learn something new - thanks for the information!

I'll consider it, but I'll likely keep the union anyway, since other 
options are uglier or less performant on common 64-bit architectures, 
and sparc32 is a legacy architecture that is unlikely to be used with 
the new performance feature of TLS zerocopy sendfile.

> godbolt doesn't seem to have a sparc compiler and I don't have a
> working sparc system any more.

I just installed a cross-compiler from the repository and inspected the 
assembly.

> It is also possible that the calling conventions are slightly
> different than the ones I remember using years ago.
> 
> Certainly on i386 even 4 byte structures are returned by reference.

Right, return values are a different thing, there is this pseudo 
parameter that points to the buffer for the struct being returned, but 
I'm not going to return my union, I only pass it as a parameter, so it 
doesn't concern me.

> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

