Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A25510228
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348865AbiDZPv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349544AbiDZPv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:51:57 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6CB11054A
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:48:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9G7AbThXrifCGzMq9kkHuUctWOFAyErVk7tW2Cw0OHj1h66Ht1M/E78rkFMIvgvKvUgnF1V8R4oaDAkXiYYaRTHvDX4B8Zy9IapwyR3iROyiYsY2VHwC3RYS6f14nDD+Yr+v0thOXptRDuvwul/qNTxiVzQuoXyJAjGAkaJfo/64cTIH3c2nA23pkhAVvPcQk1ZKlhuI2DNjk8yyy80WwskR9Ms6OoQd9nwJ1Nz8FbdM38vosSid+3csBjgx7SLDaveGXTelKtjWDksrSNIAIXhn6eCkdCwUQl9OAz90Wx7gSqzCuUFGDkbcOqwJKCEGDVQm1MV01FWl80VA4/afg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Fx3oZuWykKrFaw7fXDEKavpkkZZsTk2Di02138uam0=;
 b=WeVT4R253cYgXT18mjXuGFCLu+cxyWdqwQkKRn4z/YtrkkFhOZCXofHxLgB8uauqT67WvDaqvY9RD1lMYmBD9DUuEU2FfhuwT5NkPvIFU3XJjIi/c94QDqu0/9Fx3v2cZM65NjSV7r2iRitLimnZ03LWXmmkXuNeRRl1YSAM0Oq0jrBPeLbdeb8ZH7y1GbSXUjImQsxKqccdSVOdCpiHXmR+NrNqcOPQNFUQ9uyAtAuKAyrrQu1Zwsfrbj1EZSWPZLTgaysO5iDUmLpkp5LRtLygQ1oPX6z3mbY7l2UWe3Ytz+3zm/R5mWUXOojfPzpiRV0KAH2qJCWm5RWYrD6t+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Fx3oZuWykKrFaw7fXDEKavpkkZZsTk2Di02138uam0=;
 b=AoFl7SVQ+P9egIx3euzva8PR0p+E051khdJ8Bpk8IkYXjp/fppWgxGbn5X3yupcvwcTky/y4Bdaa2tzPKFiPR6KVKYr0uy0uJG1Okl1l52BbV3it9BrpZ256DkOaiymR5JvVKd9OhhTRAmhmLq5uBhffIRcFLKwZobt0cATTsAskK8EZmzwxkcmQv1aNfZzU/7FAnJLLVNU2wm+mB32tdYBzSmyAyjzebLQIx45ipt9SAsQ+GQBM1sE229WfQBTJT99PMLC6Fo6KkTVazGPEzrAMBfAaMqC0+EQtDM0ilcPXL+1rQaB3SEuo4nx1asnDbMuRji14+TJqoWRXq7fmvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BL0PR12MB4996.namprd12.prod.outlook.com (2603:10b6:208:1c6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 15:48:47 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 15:48:47 +0000
Message-ID: <6aee5f52-90ec-aa26-bb9c-e13e9e5abfc2@nvidia.com>
Date:   Tue, 26 Apr 2022 18:48:37 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] tls: Skip tls_append_frag on zero copy size
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Ilya Lesokhin <ilyal@mellanox.com>, netdev@vger.kernel.org
References: <20220413134956.3258530-1-maximmi@nvidia.com>
 <20220414122808.09f31bfe@kernel.org>
 <3c90d3cd-5224-4224-e9d9-e45546ce51c6@nvidia.com>
 <da984a08-1730-1b0c-d845-cf7ec732ba4c@nvidia.com>
 <20220422075502.27532722@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220422075502.27532722@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0100.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::12) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ba35229-645d-4468-6f64-08da279c3fd5
X-MS-TrafficTypeDiagnostic: BL0PR12MB4996:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB49966259B33E2184BA1C3D7DDCFB9@BL0PR12MB4996.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dPvct+ALYKnQLskW/GUAjalMlLjAt8cjHIp5f0Dt/USa/uJydJRu3t4F9wvqLagtwYXVz6stFXkHsO42pGNYqF+sRcJ9xwS9bihR20YmCmg4its8LvOpJ7rSKzmraAETZogRHNSU6zFQIXaeiUg466Jvypr/fntq8wGqacXFulbqRQElZRYdY0Pe6GJdzRFZjGTISmpqJRRa4ajdTVWAHTGOYi29Lb8Y8GuIMk7BNhPqC0d8v5sfYIrfC3OPgENBpmYH3MIw7Yk5wU9gnCgGA+hD+Qdi3Z94hGZpTjNYJ+p6svX05JWusHXZcMH/Pn79ywO05/sHH319ELwg/tsGFEFucgRtsHjk1xw32Jey8TyPcbM3Sx9pHfMOsQxrwT6VVrMGBm61KR/Sj6XQ+Lz+kqO3NSnoayW2LP5ei+444k/reiM/CqId5n7BWd8XoCYd6Tdi7GqpDw/xJnFEq01JNNGa+4WcfbMumC4DlWtm4FM2qCVao8MLB0WYas3VX5XRK7xmRYn+S5pjmG52eyJ8g93Xm0Bg995a0EyLIQd37Uazv/8DT5IvuFz+AwAiXmgH7JdJJJuNcX1OZr8lcpDvJFw693/GHfd7Jpseogj+6aob2+f1A8ps4dnzy36fLfzdAyuZmp/UC0patbpByjPmB/1Jbc0rwMwmN9XrCwhprJj2YbpAOi00Z7UXd2ripxrh4U807Y15Z6zx7MEHtgokMp0uDdai6dvdkW5i77BbDEo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(316002)(66556008)(66946007)(53546011)(38100700002)(4326008)(8676002)(6512007)(186003)(2616005)(31686004)(8936002)(2906002)(6486002)(5660300002)(36756003)(6916009)(31696002)(66476007)(83380400001)(26005)(508600001)(6666004)(54906003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0w3a0VWWGZWVVZDelRmVlBQTmY3SXFFNStxQzVwNVI1TUgzc2ljMXFxcWp0?=
 =?utf-8?B?VWtWS3FyWXU2eWJhWWRvZU82dDVCY21nZGVRL0RVSWlJUElaaUluV1lVSEtV?=
 =?utf-8?B?eUNGNkY1Ty91RUd2Ukx4MTIwNlVqc1BHS294VVVqWHRXNFVDNDlRRFd0RnlQ?=
 =?utf-8?B?N21OUE80Rkl0UW1RR3JvaXVQYzRNVzYrSDF2VTNlZGFQUk83QmloVlQ3YnE2?=
 =?utf-8?B?dkZpUmNvdlJLcjdEeHZBYlNiVGJYSW9LdCt3Vy9lTWRud0UyNGZYOGRaT2h4?=
 =?utf-8?B?K0gvL3ByZk4xMW9rSGtsbDhVWCtyNzFWVGxMNk52MVpZcnNMbmZyd1FBRC96?=
 =?utf-8?B?NTc5NzJPcmE4WmlsOHBnYVpGRHdzNzF0M0d0Mm8yYklIdk1TaVBYSGJUcE5v?=
 =?utf-8?B?emY4NmU3YVJ0UG9xTXo3R203RGl1ZnJINFRuUmRXSndBVi9OOFJUOXpOTGlm?=
 =?utf-8?B?Y3FrYTE5RlpEZ3ByMzlrajRHaEJha0tiSGtwczZJVHMzaElUdHkvL2hpN1Z6?=
 =?utf-8?B?UXJ0OWN6TTc2RkR2RzhqVVVhcE8wODNLNEJ6K1pUalhMNy9xdVROM3l3QlVY?=
 =?utf-8?B?d2tGUWRPOFBVeTArWWpKcVVRVW0rVUxLTEFnQWJ1OUcyS1lRMXNoQmsyc2Yw?=
 =?utf-8?B?eFRqYlhGNHEyTGt4V2xhRUpqYjhBbE9aTngwRXMyMXAvTDJUVUNvZENmUFZJ?=
 =?utf-8?B?d2x4RnhwTFp4R2w5R2NNaDBUTFBVWEhOMmpkaWdiUmdoTTFydHFHaUVrek85?=
 =?utf-8?B?QmRscWd1OFI4ZXNGeWlsejZCSDZhS2huR0J5dFFrRTRmRXZuRG9yRlh1cFNY?=
 =?utf-8?B?SjZQRWdmSk1hcVhWZVY3aVo1RDFKWEJWeTZoMkpHaUV2TVl6WFlRNHR4TGVj?=
 =?utf-8?B?WXJzYmdBRTRLQStRQ3ovcjN2cEcxWTNySGhmK0QxUkJqajd4eUh5S21OMk5G?=
 =?utf-8?B?Q1NzU3FsdVBMNEhUK0hsR0hNcVdEZVRzL2lZVXBmdWRGam4rNHdubnM3TXFQ?=
 =?utf-8?B?cHRSOXBpR2pGVFhqZUduVTUxV3hIWWFoMWsxTWxNMFRmaGYyRnM5TEQ5dGp6?=
 =?utf-8?B?eE04bTh6SEFDRjZtS2EvMXMwOGp6Y0FlNmtIMjMwenNKdUd3SUNZNGpVMzMx?=
 =?utf-8?B?Snh3RDZHZzF4OXJJS3BtR1N4M2xZVVEyazIrL3ZQSWhRZXBYZUE3RldmazJ6?=
 =?utf-8?B?YmFCT0JIVzlCRVNUcDVER0FyRm5BVWtKZXAxeStWcHZESG05d043YzV5MzZy?=
 =?utf-8?B?UXA0bXlYN0c4ZzFRSW5HT0RxSVBUL0JTTlZ5dDMrNDJtUmUwS3pUMkpLTU1N?=
 =?utf-8?B?MnppQmFpbEUrY0xTUzhtbklQd044Z3UvSUx3cXhmS0Y1NzFtQy82Szh5Zmp6?=
 =?utf-8?B?SWRjQktGTlFLalRUK0ZwSjVsZEErUm41RS80eDZKRjF6NnFibFBBU2NGUHVq?=
 =?utf-8?B?OHdWS1NuYkZGSHR0SGpZcHBrYTVWWE03Q2Fid1ZWZWxHNmJndWU1bldLQlE0?=
 =?utf-8?B?NXhPZ3psTWxWNFBBOUhTV0VoS3kyMTd0dGNtcXlJclRIdXV5aHJFOERQTitk?=
 =?utf-8?B?NVNLMjVNcVZOS2pRVzdnN3p6cVROWmVtRk5kcnhpSEM2cUwvVjVQRXpMQmxJ?=
 =?utf-8?B?Q0taNjIrdDFIaVdQMEYxNEg0R2JHTHljTnBLLzBRbjFzdnRuS3B1SU9CRlB0?=
 =?utf-8?B?dUxSRDJwTFVaWnNEOFJUUlN5OWZEWEhyOHd0NElRdmNPbFpOdHdURGdGeXl3?=
 =?utf-8?B?SU1HU0Z5NFdYOElzRHpkQzhDTWVGWUhPRDYzSTJxc09ybnBJVzFVSW1nTUp5?=
 =?utf-8?B?TXFmNDg4WGZQVWY3ZExZZ3UwMTNSc1hPeHJZdHQweDVGWGRzeWVVcTBZeXVi?=
 =?utf-8?B?SitZc0JFdUkyM21aaFF5ckRMZGFiaWxqdTdzM0FJaEVsTXpmeFg5RUdhYzJK?=
 =?utf-8?B?by9jRnNJYy9PYThVSmdxTGFhbHdRVFRBVDRIL0ZmVS9TNHRQdGl5TWk5aTVK?=
 =?utf-8?B?eHE2QWl6YlZQRXBaY0UxU1EvQ2RTb09jODM3TkdwTEFRV054R25YYiszemZ1?=
 =?utf-8?B?MnVvREtHSGNpMktwWEd0MTQ5WGplQ0Q3dDVZQ0ZRcW9tMS9jSFI0RjFSUnJT?=
 =?utf-8?B?UUgvaytJaUpMc2pLOFgzM3IvZDZWcGpjSEorVk9SeWtkS29XM0JDK3Z6azJ4?=
 =?utf-8?B?WHk5ekg1NmJZRlQrczlmMDlydU9zRUtWTWFieWtxVmd1dzMwOThyK0xmZlla?=
 =?utf-8?B?M2VEY3dmd1hzMHB4TGlSYVA3TUZHSG1KdGg0SFBYWk1paU5NU1FYbzQ5NFlt?=
 =?utf-8?B?ckxyS2RFR21NQ3l2eHFJcFpmNXIwUDNGWHRqRXYvUUdBRmNpSkpHQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba35229-645d-4468-6f64-08da279c3fd5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 15:48:47.1629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBuHi78nUcxV44SOyLWS64VHaIKe+zh90BEm7F+c3uXxoOIRFKjMEEDyGZv6aCgGFR6xmjh9sk+JMHcJukG/RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4996
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-22 17:55, Jakub Kicinski wrote:
> On Thu, 21 Apr 2022 12:47:18 +0300 Maxim Mikityanskiy wrote:
>> On 2022-04-18 17:56, Maxim Mikityanskiy wrote:
>>> On 2022-04-14 13:28, Jakub Kicinski wrote:
>>>> I appreciate you're likely trying to keep the fix minimal but Greg
>>>> always says "fix it right, worry about backports later".
>>>>
>>>> I think we should skip more, we can reorder the mins and if
>>>> min(size, rec space) == 0 then we can skip the allocation as well.
>>>
>>> Sorry, I didn't get the idea. Could you elaborate?
>>>
>>> Reordering the mins:
>>>
>>> copy = min_t(size_t, size, max_open_record_len - record->len);
>>> copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
>>>
>>> I assume by skipping the allocation you mean skipping
>>> tls_do_allocation(), right? Do you suggest to skip it if the result of
>>> the first min_t() is 0?
>>>
>>> record->len used in the first min_t() comes from ctx->open_record, which
>>> either exists or is allocated by tls_do_allocation(). If we move the
>>> copy == 0 check above the tls_do_allocation() call, first we'll have to
>>> check whether ctx->open_record is NULL, which is currently checked by
>>> tls_do_allocation() itself.
>>>
>>> If open_record is not NULL, there isn't much to skip in
>>> tls_do_allocation on copy == 0, the main part is already skipped,
>>> regardless of the value of copy. If open_record is NULL, we can't skip
>>> tls_do_allocation, and copy won't be 0 afterwards.
>>>
>>> To compare, before (pseudocode):
>>>
>>> tls_do_allocation {
>>>       if (!ctx->open_record)
>>>           ALLOCATE RECORD
>>>           Now ctx->open_record is not NULL
>>>       if (!sk_page_frag_refill(sk, pfrag))
>>>           return -ENOMEM
>>> }
>>> handle errors from tls_do_allocation
>>> copy = min(size, pfrag->size - pfrag->offset)
>>> copy = min(copy, max_open_record_len - ctx->open_record->len)
>>> if (copy)
>>>       copy data and append frag
>>>
>>> After:
>>>
>>> if (ctx->open_record) {
>>>       copy = min(size, max_open_record_len - ctx->open_record->len)
>>>       if (copy) {
>>>           // You want to put this part of tls_do_allocation under if (copy)?
>>>           if (!sk_page_frag_refill(sk, pfrag))
>>>               handle errors
>>>           copy = min(copy, pfrag->size - pfrag->offset)
>>>           if (copy)
>>>               copy data and append frag
>>>       }
>>> } else {
>>>       ALLOCATE RECORD
>>>       if (!sk_page_frag_refill(sk, pfrag))
>>>           handle errors
>>>       // Have to do this after the allocation anyway.
>>>       copy = min(size, max_open_record_len - ctx->open_record->len)
>>>       copy = min(copy, pfrag->size - pfrag->offset)
>>>       if (copy)
>>>           copy data and append frag
>>> }
>>>
>>> Either I totally don't get what you suggested, or it doesn't make sense
>>> to me, because we have +1 branch in the common path when a record is
>>> open and copy is not 0, no changes when there is no record, and more
>>> repeating code hard to compress.
>>>
>>> If I missed your idea, please explain in more details.
>>
>> Jakub, is your comment still relevant after my response? If not, can the
>> patch be merged?
> 
> I'd prefer if you refactored the code so tls_push_data() looks more
> natural.

I would be happy to improve the code, but I honestly didn't understand 
your idea. My attempt to understand it only made the code worse.

> But the patch is correct so if you don't want to you can
> repost.

OK, I'm resubmitting as is, but in case you find time to elaborate on 
your refactoring idea, I'm still open to suggestions.

Thanks.

> Sorry for the delay.

