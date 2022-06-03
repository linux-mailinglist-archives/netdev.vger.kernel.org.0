Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008BD53CADD
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239819AbiFCNsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 09:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbiFCNsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 09:48:01 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D31E2DF6
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 06:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiLizvFT0cuO0+3v8tvUARUrdestjAujpgY5iIu7tND8xfyXP1HWh3OJZ07Ef8K9tBip3swtSwzfVa6OewsUTlfMpwIfbujuNozMWMJOYwQfsusGbEzc/XbJm3RKr70InYUtuj9yqyy9zcizeZ7b5vWKMtd9ivuaKbYe85HiaZMQIWatBkMlbQSNxbMMYA8Ovxik1C6nszdoU7/EAbLmrQn44oAtAFHrO/QqGmfj8bPqRHbxWULxjvHubkp8ccnki9PBLH+mrJuM/iB2z8C7DZpOh6FrEBgCVakc4vsVsqAl1fKtGBQ4eBBvGiWNB7hRJV+5vbM2E1v/0Y3qWMr/4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VLqvlmZYSDjzDpZpCtNleM8oIaIumhv5ZvOOnq7ir4A=;
 b=OCwwFvrPVL4MkLtvuG2Cm7LChC4h5aTZ/TUHbt1r4LBQ8B/nTJUTYFxAVz4hWLSILljqB5+RzE5Fo/cREuN5MMMc5/sbmUQdKOR06niPYhkd+FkNh7uuAUfadAZEm+lDe2Trfa02Z8PSJhaGyEyCRp3DAeng0fGeFSM/7kJ3hokf+al9aU7LWoyZ11rRjmmXgyRxKTt26MNt/vPbVZ9ULWdwKN+QNRaZ6tWGMUDjIwqeW93j4b8DzsKAkFPrKH1AY5tOt2cCYWzxsJudaw6iyKY5zmSLyvt59q8k+wDK5MOhFpkjFZkdKK5gPdhsscCJ8TTjabJkEQ/0qoe0jAGrFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VLqvlmZYSDjzDpZpCtNleM8oIaIumhv5ZvOOnq7ir4A=;
 b=ow6uB/Uy1syYmO8cXzebvWpgX/EWse5KzW7sqcnxPjGxyOBca2GDlFvCC24ve8Xw+OkMn+FDm8XVX4i/DYmofPOk1cQBeMaueC7TLyEi6+i3fUT46YTXtsLRlfRIiwufSWmkNTt64d27LwojvV7PPzNOG4SVQzA1w6ZGdPfgzPVbZDsqB3UVI6bcUOl9t8VRf1fqzA4oWdAj6bDICYMSps72IR3umgkI+0sYLF35cbeNK6idBa+TjSzdjZE03XFHTKv2Fdxy5cWCJowFFeru2r8psz65luzdBG4zCOQ/37nBCh5I+ms3iKFsKfVL1lqJIgtJZsyR63Dvl7KBchuxSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MWHPR1201MB0014.namprd12.prod.outlook.com (2603:10b6:300:e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Fri, 3 Jun
 2022 13:47:56 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%5]) with mapi id 15.20.5314.015; Fri, 3 Jun 2022
 13:47:56 +0000
Message-ID: <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
Date:   Fri, 3 Jun 2022 16:47:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, tariqt@nvidia.com
References: <20220601122343.2451706-1-maximmi@nvidia.com>
 <20220601234249.244701-1-kuba@kernel.org>
 <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
 <20220602094428.4464c58a@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220602094428.4464c58a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0334.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::15) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0f34dd8-c0c9-4919-c7fd-08da4567a9ff
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0014:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0014F5BDB96A8B8F0CBC4E37DCA19@MWHPR1201MB0014.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrKDJ5TfZuKjvtC056VLbSw+BnBMf3LX0NmonDmP8HzqtqRvutlbEH6k0WT8C/8DqC+13wmJWNGutsp7CtHStvtyPHD5yfiAiNWkovl7mOuYg2enDREIRu/f0xyrJCQ6V3FGnGu0M9DvVQr6ZhUZRfcT/ZHZ3F65ZOd6Pptsa7jBZwu8A5+4pCzDkhAhuoqRaLCeFoyNQrfKIGXlmbz+Fwt2ZyosoQ6rJ3cHpS48Q7xy/WMmtm9pNwsQld8xCLkpJhym+mXgOSpp5cG+Bn3NlFipibzmPJUZkJfSkaurVDkkbDPVetNSVh/bMg+cM3oM1VUqzTu33Yc0hgOA8HJqkOvDhdo1Ta2uTKKYr02YXeFolBfizLD+rHv/vcYAwOHKlKJY9TKT3ZIymvXsBXGVW5YaBpyqnkFlWtOcZXPQI5G33FP0lZxhnYne19uanws5ZtLxFycx56muY8aKCUZf5/WFrAIbGEX1LGA4W7pmGQ6X9V1M8Qb3uJ1Y0OX7SgB2C1iDzKLgtUG5jgyW1Up74imLh0e9gtYJVFUY32VM41WXL7DDkFYT3hHAc7JhwAMkBu1DjIUt+kEeGX02JXAP7+SWJCsyMwkv0QeHJsJEoP9SXzGZafz9HIRXm7OWAqkAACWbFIad7+Nm034sXIhyHiDRYo48UBUOyLGE7Bk9tXoL7nnRfddi+b8cEtp5k8imVyHtvXeWTNm56Y0RZgLn9Wu5HnTgBhlwqvNRwX21b+7qyyhpAEdrGs4/isxBd+Gc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(2906002)(66946007)(2616005)(6666004)(4326008)(8676002)(66476007)(83380400001)(38100700002)(36756003)(107886003)(5660300002)(316002)(6916009)(186003)(508600001)(31696002)(26005)(86362001)(31686004)(6512007)(6506007)(6486002)(53546011)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0VmelF1U2cydnNRb0MvRGtZaDhQZExvblRHNlNjZVJqTzdlOEJ3ZXl6UWJY?=
 =?utf-8?B?cmwxbjZmN0xQWm9laFJYVkM4VFRrNW83bEV6VURHK09RdHkydzVtZTE1NEEr?=
 =?utf-8?B?dVpER1Q1a3liYWtOem9aT1ljK2MyWkFhWTMxMVBvc3YrN2hoVHRWaTBMa3Rq?=
 =?utf-8?B?VXd5UUZCNlVLUkticXZNbmQzZHFOWW9LMDhuRklNeENtMHVnak01VnZUOUVk?=
 =?utf-8?B?MnhyZGd5a0RsKzZKcTNVRXFxTFFKeXRSbTlxckd5OWk2bVZtb2JoWmNvLzAv?=
 =?utf-8?B?MmFzOXBubVBQcU9KOFpRNnIrWWhNY2hhR2F0bTgrSlNJVi8vWHNkdkJlejQy?=
 =?utf-8?B?WVRnamUydUJhV0VsNXVlMVd2YmpESmNuZkhRSGdZeVBGcTZaMFpQbmp4bTNz?=
 =?utf-8?B?aytBMFc0R3g3eGxGb2tKV2dYOFZiTFVuY3pJa1JKVHNROWwvTjR6akZpZkto?=
 =?utf-8?B?a0dLWHJmTVZtVEV6bHdxNnBDVS82dGxBUktiSmd0Qm1CdVR3T0pydzJIc2Fn?=
 =?utf-8?B?a0hWeG5VNnFZbmx0UzhYNGM0UnRQRGFVQi8zRTU5b1FuZWlMaW9UVVJNbzNW?=
 =?utf-8?B?ck9hRHgzVUIzcWpvYUZiR2RpWEM5RzNTcXdBMUZmS3BCL0JtL0piYkU3ZE5G?=
 =?utf-8?B?MDc0M0djaXlJQ1VISTExUHpWditKdHFKOVhKMERmcWpMMlNvTjZqMUVhQUFI?=
 =?utf-8?B?T0FoejZwY01kaHRoQWlGZlhPbUhCRjNUWnVkdS8vQzNhaG54eDJ0NVVrWjNn?=
 =?utf-8?B?YjNYeUxPU2FDa3lveFFuOG04STZKcWgrejQ5R3dMVTBvT0JaTER0cUxIMm9y?=
 =?utf-8?B?Ti8zMWNwNVR3UXNIN2VzSEVRem1rUlhiSzFPc2svYzlYa0tyclZhS0RmL3NC?=
 =?utf-8?B?dkIzRkFPdXUzWi9MZzFaaWRMejFkUUZOU0k0L254dFBqdk9ZRml3U3pZK1A1?=
 =?utf-8?B?dUliZzNGWnJmaFdOY2tGQlIxRUdidHh3MDJLWUtYMzh5TEFRVGV4MUNPQm5H?=
 =?utf-8?B?V2dFUFNaUXJJSnJReC9yd2ZQUE5tb25xSXRDVExISmoyMlZhem92Z0Z1TThX?=
 =?utf-8?B?VzkxZkE0SEdwWUhWN2xIdXk3d1VQZjJ4OUM4WnZLc3QxNXNqQUdxNW1tSE9V?=
 =?utf-8?B?NjdIU1JnUjc4am9SQzZ2N1RScjhQb2ltWGVCMzRCUWp2R3VyMGVNMkdkUEFD?=
 =?utf-8?B?VUI1WnIwcjVzZHQzQy90bVZJOGhycUtFY3NEc01rcjNtOCtRTXJmRmgxaXM3?=
 =?utf-8?B?WHVFbklhUnpTU1pWd3RWZ2phd3VOcFlJakNQY0g3N25DVFJrdlI2QTVIcHVm?=
 =?utf-8?B?NGVGMnpMNjFCdkwzNUFRWVRLRzdIbDFzUjIwNkxuUnpkS3dFVG82VktCUzV4?=
 =?utf-8?B?OFFWRjJCTUs5QjRZLzFib1kzRlVoaWZTOG0xMTVDOFJvdDJzb1RrWWwzZnJY?=
 =?utf-8?B?cXpGR21kUWREb1k1R3FnSXNKVS9ETUR0MUsySS9DL2Rsc2Y1NVJBUEdBdVVr?=
 =?utf-8?B?ejgxa0MrWVAxWS9EK1N6djNzcjE4QW5aOVZOZEM1TnZRL0F2TEZpRTFsN1BC?=
 =?utf-8?B?bHYyelZ0VVNMdmlwdlN4aHdKV01uSEtqZEE5dy8xTUc4cFJmSjRtYzVWdGZF?=
 =?utf-8?B?V2t2RnRxYk00aXAyNzJRNGFha1lZMndacXkrOEN5SGo3WFBReTJCNExrK1c2?=
 =?utf-8?B?SXBWcVllR0NvTGYwZVhpcWtEdHRvd2hUZ0ZyT0ZIN1hSYUwvQWhOelkxMml6?=
 =?utf-8?B?Qkg0blBHT1V1MldXNko3SW9WbGVVMzZYTjN1SDdQdnd1SWhEZmM4T0d4Wmov?=
 =?utf-8?B?Y21qczc3UXVRckVSWk9PUXdwbno1UjdnaE05TFlnTm9XaVcvazkwTWV2aDd2?=
 =?utf-8?B?RWNvSXdhRWg0dGQyOXNwM1FGNm9mVURwMWxmQU1HYVZFSUd4U0pYcFM4Qmtm?=
 =?utf-8?B?ODVTTUFGZGxpRDI5SzgyMlZQZnZrajNGSGx4NGlORS9BMms2R1JOeUt5MThI?=
 =?utf-8?B?QVhzQ0VXcUhUS1lJRlBZSzB6WG1mSXhXVTUzamZEUm4vbmNsU041Zlk3ZXBI?=
 =?utf-8?B?eW1kRGxBSzdxbURQdktaSU5lZVZJN1RZOWZkSGJiVGVpOE5NNUU4cE1YYUtD?=
 =?utf-8?B?VUh0bHNCZ3JCK3dGN2ZDb2VEWGk5QnZYTkk3NXE5dEtFSHlOM25DOEVaeW1i?=
 =?utf-8?B?alo0SXZudEZmVEVONER2YTBZOVFUNTV2aUxxd0xEZDZnaG0rYUY3aWtYc2tF?=
 =?utf-8?B?TlRsblFCYjdYbWFPUlI1UWRQWGZxUWpEWnp6MU90aHk2aXcyUWhzTm13RVVY?=
 =?utf-8?B?YmhoZnZpd3VEajBuTVRPbzNxT1diSXIrRHcxL1lac3ZwbU9ZVmJkUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f34dd8-c0c9-4919-c7fd-08da4567a9ff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 13:47:56.4906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxMfSRs1gjCxbv90NaEQP5/yd7o/+4G1YLCjrNp3lklN7JNq6yxh5jNmECJi0ghb9/hLx0hl4Ky9GXkgU9gABw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0014
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-02 19:44, Jakub Kicinski wrote:
> On Thu, 2 Jun 2022 12:13:53 +0300 Maxim Mikityanskiy wrote:
>> I would expect to get a comment on my patch, instead of submitting your
>> own v2
> 
> I replied to v1 that the name is not okay. And you didn't go with my
> suggestion.

Well, you didn't go with it either :)

I got two suggestions: "unsafe_sendfile" from you and "zc_sendfile" from 
a maintainer of iproute2. I had to choose one. I chose zc_sendfile, 
because it matches the name of the feature and comes from the iproute2 
maintainer. Sorry, but "unsafe_sendfile" doesn't make any sense to me 
and looks like a false ad and an attempt to put the feature in a bad light.

> This is a trivial matter, faster for me to send my own
> patch.
> 
>> and dropping my author and signed-off-by.
> 
> Sorry, you can add it now tho.
> 
>> On 2022-06-02 02:42, Jakub Kicinski wrote:
>>> Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
>>> sockets") used "key: value" format for the sendfile read-only
>>> optimization. Move to a more appropriate "flag" display format.
>>> Rename the flag to something based on the assumption it allows
>>> the kernel to make.
>>
>> The kernel feature is exposed to the userspace as "zerocopy sendfile",
>> see the constants for setsockopt and sock_diag.
>> ss should just print  whatever is exposed via sock_diag as is. IMO,
>> inventing new names for it would cause confusion. Calling the feature
>> by the same name everywhere looks clearer to me.
> 
> Sure, there discrepancy is a little annoying. Do you want to send
> the kernel rename patch, or should I?

You reviewed the kernel patch and were fine with the naming. Could you 
tell me what happened after merging the patch, what changed your mind 
and made you unhappy about it?

>>> the term "zero-copy"
>>> is particularly confusing in TLS where we call decrypt/encrypt
>>> directly from user space a zero-copy as well.
>>
>> I don't think "zerocopy_sendfile" is confusing. There is no second
>> zerocopy sendfile, and the zero-copy you are talking about is neither
>> related to sendfile nor exposed to the userspace, as far as I see.
> 
> What is your thinking based on?

You quoted the answer, I don't have much to add.

> I spent the last 8 months in meetings
> about TLS and I had to explain over and over that TLS zero-copy is not
> zero-copy. Granted that's the SW path that's to blame as it moves data
> from one place to another and still calls that zero-copy. But the term
> zero-copy is tainted for all of kernel TLS at this point.

That sounds like a good reason to rename the "zero-copy which is not 
actually zero-copy" feature. On the other hand, zerocopy sendfile is 
truly zerocopy, it doesn't have this issue.

> Unless we report a matrix with the number of copies per syscall I'd
> prefer to avoid calling random ones zero-copy again.
> 
>> What is confusing is calling a feature not by its name, but by one of
>> its implications, and picking a name that doesn't have any references
>> elsewhere.
> 
> The sockopt is a promise from the user space to the kernel that it will
> not modify the data in the file. So I'd prefer to call it sendfile_ro.

That's another way of thinking about it. So, one way is to request 
specific effects and deal with the limitations. Another way is to 
declare the limitations and let the supported optimizations kick in 
automatically. Both approaches look valid, but I have to think about it. 
It's hard to figure out which is better when we have only one 
optimization and one limitation.

> I have a similar (in spirit) optimization I'll send out for the Rx path
> which saves the SW path from making a copy when the user knows that
> there will be no TLS 1.3 padding. I want to call it expect_nopad or
> such, not tls13_zc or tls13_onefewercopy or IDK what.

The fact that zerocopy is a bad name for your feature doesn't mean that 
it's a bad name for mine.

I don't have all the details about your feature, but I suppose it's not 
truly zerocopy, because a copy is made when the userspace calls recv(). 
On the other hand, zerocopy sendfile is zerocopy all the way through 
from the file cache to the send WQE.

>> I believe, we are going to have more and more zerocopy features in
>> the kernel, and it's OK to distinguish them by "zerocopy TLS
>> sendfile", "zerocopy AF_XDP", etc. This is why my feature isn't
>> called just "zerocopy".
>>
>>   > > I suggest mentioning the purpose of this optimization: a huge
>>   > > performance boost of up to 2.4 times compared to non-zerocopy
>>   > > device offload. See the performance numbers from my commit
>>   > > message:
>>
>>   > That reads like and ad to me.
>>
>> My intention was to emphasize some positive points and give the
>> readers understanding why they may want to enable this feature.
>> "Zero-copy behavior" sounds neutral to me, and the following
>> paragraphs describe the limitations only, so I wanted to add some
>> positive phrasing like "improved performance" or "reduced CPU cycles
>> spent on extra copies". "Transmitting data directly to the NIC
>> without making an in-kernel copy" implies these points, but it's not
>> explicit. If you think it's obvious enough for the target audience,
>> I'm fine with the current version.
> 
> Everyone wants zero-copy, if that's what was being declared here
> we should just default it to enabled and not bother.
> 
> Developers need to read the fine print first.
> 
>>   > Avoid "salesman speak", the term "zero-copy"
>>
>> In the documentation you wrote, "true zero-copy behavior" was an
>> acceptable term, and the "ad" was the performance numbers.
> 
> I don't understand why you care about the numbers. They will be
> meaningless for other platforms (AMD), other versions of your NICs, and
> under real application loads. It seems like a declaration of a
> performance boost which can't be accurately delivered on. Do you really
> want the users to call you and say "your numbers show 40% improvement
> but we only see 20%"? I'm not dead-set on excluding the numbers, I just
> can't recall ever seeing numbers for a particular NIC included in the
> documentation for a feature or an API.

As I said in the previous email, it's not about having the numbers in 
the documentation. I'm not pushing for that, and I totally agree the 
numbers will be different for everyone. I simply suggested adding a note 
that zerocopy means performance increase, and I said that if it's 
obvious for the target audience, I'm fine with the current version.

>> However, in the context of this patch, you call "zerocopy" a
>> "salesman speak". What is different in this context that "zerocopy"
>> became an unwanted term?
> 
> I put that sentence in there because I thought you'd appreciate it.
> I can remove it if it makes my opinion look inconsistent.
> Trying to be nice always backfires for me, eh.

I'm sorry if I didn't read your intention right, but I felt the opposite 
of nice when I started receiving derogatory nicknames for my feature in 
a passive-aggressive manner.

We could have prevented all the miscommunication if you had sent me a 
note at the point when you felt we need to rename the whole feature. 
Instead, I was under impression that you suddenly started hating my 
feature, and I couldn't really get why.
