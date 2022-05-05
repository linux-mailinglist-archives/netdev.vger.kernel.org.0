Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E443C51BFA9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377552AbiEEMoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377743AbiEEMoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:44:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2390F13D02
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 05:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxqY1bbej166hQx/6/UVLrWgzx+AqRuExzfOjcj0DqThXwXGeY/I5TyOXFc3kanizK8n7yJKMlKUIveIFTJfHMu3oifk93fSprYvWyFSE6wMag8UJWzTjcYeKXg1YAbMrZNWJFrOphRbfKTWRnrJ839/JeC3tgTDNKMZZKkyZRCiMrQn5ZpYrBeXHEahPEQdC5dY61eh7C7EkNLOfrcy0k5PFQs5b5oSSNJknfV1pdGBqPJj5SgGG+viKJHrs03x47A5MG92Q/VbmLR2KqUgEpLl4IjWOkst6KnzsxNdcc0wQgESAeFuu2/NRft7lIuhFmSvuT2A/YFGJ15Jwx4hzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5xSS+GWZYKs5aCa2qsGGN9/MLhSvPF9m35aRB+EpkI=;
 b=kCwLgfOAOiOv8TaV/M3z7RKrJePv9fMx7QuMRYnIAYb16Vn5hXCTnGTmr2zho8kPXDxF3BJZwp2n+qJYzwEoSHOT1W7B6EBzCJSZbk9QjdB+MuCeGUB5kM7bbtosOxDiBie8UTY2uI4ofMjX5pxPtSwjeSEFQX4KD4EJqUbZw4PkEgHi64riSzuk1McAwZVvEa5hmy4tKQge+rQA/V+cx12IJ4zWJMfN/QJfAAE0sbnu/a114SVsSiqNGzkAMeGpsu6qZa/UlYi66FLxPPYBbUU6kdggyetgEZ/4nZMk/YNycgQ3znI7Pi6IauT5EfJHAY0HN1cry5mxfzBPvOykcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5xSS+GWZYKs5aCa2qsGGN9/MLhSvPF9m35aRB+EpkI=;
 b=JNZvFicOZ+DE4zO5Ug5C9d42awx+kgoWk+tRAaBjjhk4K2WNgQp+/cLdIiPyfAfw9M/99krxsLueslfgNuKMdlEvRbyAy1h1bsWwO9xtIXJ34K/V4hOfpLgpNXdAI2KRP3MgO5LlU9xr4Oom8bpHOS+lcT/I87m9PEFn4MSvDag96qCVeTynSMV8kia4xoWAEiY4iChOPuZ4WzCUVt+g9m5TcIh4SsMhJspwkh/s/ymUrhZPbDX35Ci8j07Qc84OoRJnt1VoQNkFoMXrTCehJABsgdr+5jaC2LUT8rra7HmNKqjX4shvkmblZfBXQKgh2mMV0rt+yvoVxzm8ei3DMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by SN6PR12MB2654.namprd12.prod.outlook.com (2603:10b6:805:73::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 12:40:24 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 12:40:24 +0000
Message-ID: <41abbf9f-8719-f2a7-36b5-fd6835bb133d@nvidia.com>
Date:   Thu, 5 May 2022 15:40:13 +0300
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
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <3f5f17a11d294781a5e500b3903aa902@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0159.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::9) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce662d29-a279-4852-9507-08da2e946c7b
X-MS-TrafficTypeDiagnostic: SN6PR12MB2654:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB265445E45B46C822D822F61ADCC29@SN6PR12MB2654.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MJvtESQCgp4py5TcjNzYb+8kfekUSnz+R4SutbyZmdKKve6VNo/5+CiFX2uGT42jBWbJFdhcd4Ip7/CUKnjnnhD82vl5C0/7Eq2wmkrn4zNbMnV1v55i6uJJEdfmNIA09b38r7GdHullmCkhH8qoPj9kEqBvXULG1/qMGQezaHpsfrnXJ7pO5jUpFY0Yef4MHgBE8zQtkAlw+/POphOS1aBxf+dJuLpTEQcMFJtBSQ1kx4qmfQ6CtdBVr81XNqfdDku0a1MKe4ClB04yHP1HhBblzRa8FxzYjdawib4a3HzVvq0J18jd08+32+y3ULOgsyWbGkReDVgfWXvSSVznEZrNqmRJRcK0F8Xh77YKUimxEWmJ+8vfa8EmgLTCNDZb4K7O1ucaLLIYvKxGQ/c858rm4i/NSRXfERrYG0XmfIg5e7DY7d2lGpygV4grc3kZi9exvXW/CvP4Znv4bDDUKsmIJu0yeVpehtcUw3AuHcC6uCiwzyytpKOtRnxJUKz52zeny2ZS6pAhAWMOz+qqRv/DMYnUVNZLTrKzIcVFesNtN47slS/R8wpx0ObAyy2Y8QnrVbH9uZZ1to1KTytmIG6xl3XjWTUXTZnwuqTYEsL9qCuRtU2Unv5pHJdJeZ3vDC68Wb6vRgj+SYn0pHYE59DehHNes7WKozzzax4mG4O/myJXuUZ9nfjuoimkefRCZcKOB1K4EGs5AgunZjyarW0nIfElf19mXZooMJlrrKOq2aI6/zw78aM/rqLOmJO0l3IuvchneTSvmFjr3/c68js7JL4g4hJ+qhPItbufWg7atDO3+/1XyhKieXjlLEzg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(8936002)(6506007)(2616005)(4326008)(8676002)(316002)(31696002)(86362001)(6916009)(83380400001)(54906003)(966005)(6486002)(5660300002)(66556008)(66946007)(66476007)(36756003)(2906002)(26005)(508600001)(31686004)(6512007)(53546011)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDk5Z2pLQ3lzMVZZWERwK3AveThGeE85cEMrZWNyQms5NkhTdXBKQ1BHbk1F?=
 =?utf-8?B?dlZkRjUzbWNEalZ5YUloUWxEcTc1eENhNnRIeVRGMEVQQnpvcjluYklpUEJ6?=
 =?utf-8?B?QmNsUW56SmpXdGRKK0Yxamt3RWZmeGNTTWpYTzZOZWUzbkZDbEVZK0lqcGFI?=
 =?utf-8?B?TUhQK1QvOXk0Mk5pRTZ6dzhVdDRHNS9GVWlJdW1HckgrZHBQMmZFWVJwa0N1?=
 =?utf-8?B?bW92Q01wOUJEOVdDTUQyZWRxT1Qzd2E3RXgrOE85THQwRkZFaEF1TzFBbURG?=
 =?utf-8?B?V3hYbmJWUUQrbDZzQlFRcjhKdVRYMFFkRnJnc3ZCOFV2R21OT0doeGcyRXg1?=
 =?utf-8?B?T0xMMFJ4bENLSUJlU3NIT0tvOXRlaG5oaktHa3dUS2ZzK0JsSnhhMHd3RG5m?=
 =?utf-8?B?emtoWW16NzFydHBvQnorV3RmWmRUSHlrbUVuam9OMWZ3M05DR1J4eG1nYUNI?=
 =?utf-8?B?R1BKd1RLc0djZkl3aEV5ck1ZLy90aGhoeG8yZUJRdFBnYmF0blNucmxvbm1t?=
 =?utf-8?B?MVhwejlkNWdpZW1QUGVkM1E3TXlXMkQ3YW9tSEkwZkVHdHhWUTVJTGFCYjh3?=
 =?utf-8?B?WTRGMWlEb29BREo4YmxyamJwQ3VhcllubkhRbk1XUXo1bndVVzhhcXpLYm9U?=
 =?utf-8?B?SEhyYit5amJNV2wxWHJjN2YwSXdlOWJRYmszTEZWR05jVjFuOGNyZjlpNE9R?=
 =?utf-8?B?N2V5Tm5zaUpBM09vM2RHaFRYb1BsL0RaR2Y0cC9LQUJTbkZwY2V0TVZaMFpC?=
 =?utf-8?B?MFN1QVBScEY0Mzl2dVlhTFdrQ0N2S3RHRGNZM2t5dXFWSFpPZGllT3owb1J0?=
 =?utf-8?B?SmEyUXYzU1JpY2IvWi9TR2w1Qnc3cmxsR3JoNVBYWEdNT2t5Q2ZiZ0VCTWty?=
 =?utf-8?B?cmlKVlRER2V1TjNlWis3QVRvVDljZnlNVnhqVitJUUVPRzFhdTBPRmEwdGlX?=
 =?utf-8?B?R1loZGlDSDAwa20rQ2NGeWpjK0VtZUJwSkZyaVp2b0lDWDNzRHU0ejBKd3Mz?=
 =?utf-8?B?U3VCc0d3ZmpQbGV1ZUFKcjZxZzBSWEN2amUyNFRLS2NTanhDOXNpb2k0dXRN?=
 =?utf-8?B?c2ZVakE1LzZVRVVvZFBVb3ZKM0FoRnZlRXJDYjRQRGh2RUNGVkFDb1lJWHZp?=
 =?utf-8?B?QlZJa0VTVWo1bnFleVhuTjA5NFljSmhuVW9PU2RPc0tFRTlSRTRhL3NwbWFQ?=
 =?utf-8?B?K3hxVnExZEM3M25MYnpnRmlRUExpU1RLNC8yU3prZldZZGFTOXVHWnh0Wjk5?=
 =?utf-8?B?ZWdtMWhFZ3BFVzVGNGZ0K2Z5MjZSaytRTzJGSjNybGtqNGxpQ3B1RjhWTXFW?=
 =?utf-8?B?R00vS1lSNS80TCtnQnZXbzhlWHhCVEZKaDV4aXQ0NUNqK2loV0lacWxSczVB?=
 =?utf-8?B?Ky9aU1hscDBIdWJHR2M1c2t0NzVWcGptUlNYVSswMHJ6UjBjYjkyalpYQ3JE?=
 =?utf-8?B?cFJpckZXRm5VVC80RzdtL1kxTFdQOVlBUDVXRTZkL1plMEZNdWh4WHh6ajNR?=
 =?utf-8?B?WHozQW43RHk4djUvS3hSNSt6ZXNwY3NIUS9HTGo2MENIVDU2akFTaXQvYkRp?=
 =?utf-8?B?eGNDV3dYUXMrUllqVGpEYWN2NW55RnNXeE5WN0xadERmeWwvUE82c3FORHps?=
 =?utf-8?B?Zll5K2lCR2swNWhyUnVLOUt1ekt2RkoyWWhsNm4vRHpYaXlYbzh6bjJqcmFn?=
 =?utf-8?B?RFh3VjRHbDhWVmovYXdaWElLQURZWlhJSE13NkxMc2I1dlhoWVVYRFNnbTNQ?=
 =?utf-8?B?VFZlU1dRUmlyVTZnYUdHNTRxeWNUdmNBNGxLTUxnS3FjOTNodUU0UXB0MFF5?=
 =?utf-8?B?U3VTZUQxNmVPa0JVQ3VVL2JPeEVGeE1oSzBPb2ljaFBoakhPOS9GZkhrcCsv?=
 =?utf-8?B?Q1F2ZDBKaVZlbGY0cE9yNElSSi9KU3lCSTBxTWtuUHQ5Ykk3M1RNK0k4Witu?=
 =?utf-8?B?R1F4SUVSc1RGdTcyTG92M1Rnd3RyZmtrS3U4WThPRmZUYXVpU2pmaERORzho?=
 =?utf-8?B?ayt0clFCSmlpaXZTekQ0WlN6dHRqK3Z1RVBrVlBBVWQzamZxY0lkRVJYekVO?=
 =?utf-8?B?eHFYNUEyVnA2em5aU1NSQW55TmVEaW12dTU4aDg2aE1jWWxvS3VoY2s2Rnk1?=
 =?utf-8?B?MnRSUjVpa2FNUjF2dCsxRktYUUlEaTF0Umpyc2d2ellyM1ZLMy95ZFFjSTBq?=
 =?utf-8?B?UTNPemdSWkN0RHE5c2RqcXZ5TG5uK2dsZEdwUVQxc1JHRVA4ZDBMY1NvTmdu?=
 =?utf-8?B?Y1EyNitBdXNGWlV1cGlWZEl4K3h1SE1tR0FSTTJHaUc2bEtNTFJXS0ltTjBG?=
 =?utf-8?B?NGFLc1gzekNyWE9jSlhoRXJ3QmNrQWs5NFg2eXdQTjdTUVBiMVB1UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce662d29-a279-4852-9507-08da2e946c7b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 12:40:24.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XTo4wPCc9gen61r4N1gcdk2WwZaftHOmJbBXgSIh3N89OUXdWrWbV2sQ3P69wRdY1n58p6W3RzyLWP8/TXvjrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2654
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-04 12:49, David Laight wrote:
>>> If you declare the union on the stack in the callers, and pass by value
>>> - is the compiler not going to be clever enough to still DDRT?
>>
>> Ah, OK, it should do the thing. I thought you wanted me to ditch the
>> union altogether.
> 
> Some architectures always pass struct/union by address.
> Which is probably not what you had in mind.

Do you have any specific architecture in mind? I couldn't find any 
information that it happens anywhere, x86_64 ABI [1] (pages 20-21) 
aligns with my expectations, and my common sense can't explain why would 
some architectures do what you say.

In C, when the caller passes a struct as a parameter, the callee can 
freely modify it. If the compiler silently replaced it with a pointer, 
the callee would corrupt the caller's local variable, so such approach 
requires the caller to make an extra copy. Making an extra copy on the 
stack and passing a pointer doesn't make any sense to me if you can just 
make a copy on the stack (or to a register) and call it a parameter.

If you know any specific architecture supported by Linux that passes all 
unions by a pointer, could you please point me to it? Maybe I'm missing 
something in my logic, and a real-world example will explain things, but 
at the moment it sounds unrealistic to me.

Thanks,
Max

[1]: 
https://www.intel.com/content/dam/develop/external/us/en/documents/mpx-linux64-abi.pdf

> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

