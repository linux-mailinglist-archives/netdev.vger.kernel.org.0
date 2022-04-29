Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB149514CA9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376974AbiD2OZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbiD2OZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:25:32 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D934A3CA
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:22:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gcn8b9spRNMP8dSLEz3RNM9/TQJzeB1KlouAYaIfI7Q/dfuoGzF6MdDA/gX/9SXZPqbpOfg5X1GQLjgRJT9kITXAe7/VlRfgEyF8IB5RcH7+qEIfYpCoCdWS02JMg4yiNr6XXXLn0hdy2wL7ON9thiDNT/Of9Rcphny8snO/fP9IsMldzzKBi9Iag0TmoY4acBIXXtkKS667Z//kOJ2A3jUtpJFMAe+D4YhXmiOcHVzOLD7O0Ww7XGB2jdjqYzxBb8R2I0IfQuMFO7qWL02JBFwiqflHS5zVCYx/4Zh2ku0BJPo6l6gCZ9hm9737WEswJYuwXqXKLkPMbdYIGbCYIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDlCISdhPHLJ9SeDDY3nAcIzkF0eaXU/GiVHyRM+pnk=;
 b=fPPWhscYT/776OJUgDnJhxM0wQGZ9XYuXDlXPFZpgKF8S9J8gtKQWz1zN0175WGIZLn7u8PIZpDIWQVwhsCYgeRO7KF8CBnHskAW9lpci7OIsCSrSxi32fHGgO54ojnUaWm5zH1SBqsKcat9L5uhU60npCpCIL7DspYXzqaIizbSgvHlBxAxw/sSGaYqBhAwydQn3TyeMoFCMJ4OR6E6l5o5X9D1oJyAzdyPiUJJkMa7QVdSPtYychER/HoXYvnFR8uesDx928312gByHMD9oX5Ci+wbQyD5QU2OG9zr8uuqfBuVFplb9QieA6nKE8ZNc+XSC5wlCLYULn2wkztKiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDlCISdhPHLJ9SeDDY3nAcIzkF0eaXU/GiVHyRM+pnk=;
 b=dB07mKNehaLmwRG/eYIbvS+gP4lTD/xIC7j4yWNf/u/FXNP3OkaFVqHjg7syvVkO3zdiy8W5jmXy9r+u9drS0AmtgnqjiO9FQKgaFNM0CFJ8tQ6N9fvfMJXYvk4Vvbaeac3haPMLE8TplEY03EdqtLDsrN/nINidVSKM9bnUHbBDdpgv0AQSxcfz1x8UUBaNYhOUNjsbBkotokuAqaV65SiKiEBQFjh4R20xB0Acx67nsqb14ySf5FKcKq2YhuaWjFxCbXJ3EpmRzLd+Q0ZMur9rKPMVeI37JdQYP/JxOjPTBPlcFL+sfym60eAoNYpKaS6t+nCrxCi2icLZZ0jiyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by SJ1PR12MB6148.namprd12.prod.outlook.com (2603:10b6:a03:459::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Fri, 29 Apr
 2022 14:22:10 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5186.023; Fri, 29 Apr 2022
 14:22:10 +0000
Message-ID: <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
Date:   Fri, 29 Apr 2022 17:21:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
References: <20220427175048.225235-1-maximmi@nvidia.com>
 <20220428151142.3f0ccd83@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220428151142.3f0ccd83@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0450.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::30) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17b65cc7-c4cb-4759-36b9-08da29eba587
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6148:EE_
X-Microsoft-Antispam-PRVS: <SJ1PR12MB614805F598F0CA5E67AA7CE1DCFC9@SJ1PR12MB6148.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8LLk1X0NMBdCUKN6TPRmXfoUXYKJlsWchNPVkfUt5Mosry04VC9xk35AISljZ3D6UHq33Li4/qfVmncqi9s930w+tsGtbzTgQRNgIacnYgfnTBV44iZESFInDN7S0piY2TBgzFDP86yWNCDSN3zdivy1CRcbnl/VNFVKMnIJhPfpzHXOU3yiqi5SSjuXgp1xPtvmo+hqSeFA2mupVhlgFOs8Lxb5mf+hMqUZlVhzGg372LM6Pr1Lz5ZdCsqZfi4Px/0Z5NF08iLhT9IDL9ZN3YDjNnb4533NeXK/RaTkrjOPmS5pgr8izMdlMHO2c53HGnEm6ha6z6+v79deSXUmx9I7LRGKRK4O0jdNmrJ8ZSb2tECtXqmmOd8DNUY8Ov6Jh6QJ9Oe2wPNsJY0xSZcPRHf4lGjRVdZ+qAxVWisVmYtPspCh4bcLzurgbNSP7g6uOQIw75LawgLD0vSMCr1AU0tWtSe/11uNOIgCVKLhe6CTLeVTdQ7DxnEcmv/fdl0lX8uRvJ5AXr74EdDG+p/gshLvCtHbifcOTt71aJDJP6cJH4VchHxQeE9EIniaMLC/XJpeb6B1F7ymB3r+LhAvbvKhXQOPdMO3xX77Qi3ja/UfRjwAEYRJFfsgbcE6rdcBqpTmejfFkAXiJWmGzkXDNf/2kJ79Rk7x4HrPrTBiyRk7Hb6oJZyLud+oMv4cPDxsT3Oqe38RXwxXfSR85FLbFBsQhsAOzhgvRmOjB8kWwygNp5Jq6VyRIItEmsxr3QAE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(6506007)(31686004)(186003)(2616005)(83380400001)(54906003)(6916009)(2906002)(36756003)(6512007)(8936002)(26005)(5660300002)(6666004)(53546011)(86362001)(66556008)(66476007)(66946007)(508600001)(4326008)(8676002)(38100700002)(6486002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzFOaWdlNklTVjBCb0l1RUV0cnZuYnE4WFlJcGtFTWpVQ2wyYmxpZHNYeHdF?=
 =?utf-8?B?bGN0NUp1bUpHTWxBWGEwb2U0WkRqOE1RcFZvazRQd2hyTGhZczA5T3h1RXZX?=
 =?utf-8?B?Qmg4TnpTNS9tK2dTb2Rob1V3d1QrQUdWa1RjWkVCSTkwTTdTbG5Xd2NzdVFa?=
 =?utf-8?B?eE1MY0k5VlFkYVpGY2RXSjREOWdFNFE3dWd6bFZKRk9FMjFKWXRMVDBxN2N2?=
 =?utf-8?B?RVZHSENYMUFyU2o1akhBVkVUTk5oUm5rcUMrVzJEdmVjb2xWdXAzVDF0S3hv?=
 =?utf-8?B?T1kyVEcrOEw4RUdISkp3MG43MlVhQ3RvbG80WFZZKzFQVVBMdnVoMmlTQmhm?=
 =?utf-8?B?djlGTzJvMmQ4TXZuTDdNSDAyejZLUVp3RG1wKzV5L0R4UG9xSGpoekgyaWdL?=
 =?utf-8?B?ZE5sS01ZVlo0ZWJUT2hFZGJPY2FNRkxJcGZrZVhoL0ZuMXVyaXRTRFVUbVFh?=
 =?utf-8?B?M0YwaEJsZDV1c1Y3WTZyTWdvN3RFNGMzUnJJOGpEUW5saUIwb2lzVkhEMWFR?=
 =?utf-8?B?U2F4SkludThLQjhiT3o2OHJZZDdyV0JlZUlLK0dSR1B4SUlvTk4zYWI3YU1N?=
 =?utf-8?B?ZDZsdnJ3dzBCeDJ6QU9xZW9KamlyRm9ZblpIMW4ydzZqallwRFhWSnVZTnM3?=
 =?utf-8?B?cW5zT3N5dWl0Y0d4Z3pNUVpyV2FaZG5zcCtmSXBGMkl6WVY0dnN0RUxyOVd0?=
 =?utf-8?B?emx0N295Z28zL0ZUUEFOdzlJZTNnNmlGbU5VOW8wWFk2ODBoeGYwOHJaWnRD?=
 =?utf-8?B?Nk9oc3BocHdMdlRxZ1pSREhJdzJMeXZnOWpNSGtuQWZWazRib280RitDVElD?=
 =?utf-8?B?OTFIdTY5b1ViQmJHV1NKQ2lscEVqNEt3VmNVL2c4VmJEWFlyVmlXUjhoY0ZD?=
 =?utf-8?B?ZTJtVjFnTGFjT1FYSVo0NjA1SlIrdlhEaENCc1VnNUErTUw2czN3Mm1NcVJD?=
 =?utf-8?B?L0xoR0trcHRESFpFTW81MmloWDE1bDEyc3pUNktpLythdCt3dm13RndvczBV?=
 =?utf-8?B?MlNGRmxCeHZISHZUdEJQejYxZkFaY1NGUlprR3ViaVZpc01YdldqMlRCYVRJ?=
 =?utf-8?B?UkpKQ0dUdUdvbGNHZGJJMkpMS1NHbCt1UzQ3REhoS05mTjA3a0xEWlNyK3RD?=
 =?utf-8?B?N2h2RDRmVWFJUlRUcElVZGFuT3lFSkpmVjcxeG5zQkcxWmx0SVplbms3WFFJ?=
 =?utf-8?B?WXBTT0xHNWozMEk3bWxhY2s0Q2EybjZGeTJ4aTFxQXdrb1psczI0cnEvdFZP?=
 =?utf-8?B?bDZHYWxCQk5iOWE2NWRaTlN6UjhrbnFsbGxnbWZsdmJoemk2TUdYeitOQXc2?=
 =?utf-8?B?M3F5VkdQbUVreExndHpWS21Va0FuN2d5S1FmOHdrU1RFRysxM2h4Nkd5VFZq?=
 =?utf-8?B?Zm11NURQbGhCUjkzSWZ3SThXalZQWmlIYzdZOW5mSXdyU3VvT3ZESVJDU2hY?=
 =?utf-8?B?SmF1Y1ZDUGxrazR5QW1yWU1IcGFBNDNYSnNiS2pkbE01MUFsL01CQ1h2OVRX?=
 =?utf-8?B?OFUvRUVOeXVLTjIwcUlUaE95bVBJL28zYnR2Q1ViMlVrYUNoOTh4TUtPTjdF?=
 =?utf-8?B?bXFOblJ4MmV3L3BrY1FHSnFJanRqZW5nMDY4Ti9sTWh5eWg1b2FaUXFFQkky?=
 =?utf-8?B?M1I2bjRSMDR2MzBVSUZJazRwbkF4R29RVXE3djB4MTJ0ZkNiVDBweDgvakdY?=
 =?utf-8?B?QnpDZ2xycU5yWnJaQVRUeXZJY2xyRU9pYkw1REhBcE52UzVKTjVQTmQ2NVhT?=
 =?utf-8?B?d2Uyamx5V1crb2dtR3BEaWV3QVBGckx1eTAxL0ZRZlNXVEFQMFhGVW1mRVI3?=
 =?utf-8?B?Y1NLL2IwRGsxVUt1N25BNThpZ256SWJRd2djUTRuVnJjaTdLVER5MlJ6ekFt?=
 =?utf-8?B?Y3h0ZDg0aUFtblppQms4Umc3blBtT0x0ZDdLbHR5MEk3L2VIeFlMamQ3eEEr?=
 =?utf-8?B?SnpDVVpKb3VQOXkvUFc4czRWM3k2b21RWk1PR3Z2b2Fva1FDUlR0ZnVaalJY?=
 =?utf-8?B?TU5rWU1UZ1UxaXpUSkVKcFVJdFdFRkJCQXN6ZnV6bTFlYjlJVjRsNWdzcFhj?=
 =?utf-8?B?b2ZzZFkwNDVLY0Q0MEUwcVRaeDJoVFZ1OWRWQVRLRzlnd0krR2FKQmF2ZlRx?=
 =?utf-8?B?YzRwUG52YlBwdHlaWWdvZmo3YmU3SHRrdnkrMWV1R3hVQkFsMmRUNVRqVXZQ?=
 =?utf-8?B?OWU5WUdFUjJIVjE3aFp1TXdOYzZ5TVhKWkhnRDQzY0FZZWNaUUlOSXcvQkdj?=
 =?utf-8?B?d0Z2aU9lekh2bUhZSTVNUUV4K1Y3bTEvb2NyckNic3VycXRBTXVYYjNVK0Ur?=
 =?utf-8?B?blo5Umx6b1RBUGY0N3RxK3V2N0NSRGxWa04xWWhhSVdLb052QkxIdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b65cc7-c4cb-4759-36b9-08da29eba587
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:22:10.0782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYHhTnPnRR1u/x/OedEHohCaHv7CjgnmmFr/OOhd2j4jpCeln+xMV9/YfS3iyexXBNMt0RO8TjmiifSY2UJJtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6148
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-29 01:11, Jakub Kicinski wrote:
>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>> index b12f81a2b44c..715401b20c8b 100644
>> --- a/net/tls/tls_device.c
>> +++ b/net/tls/tls_device.c
>> @@ -411,10 +411,16 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
>>   	return 0;
>>   }
>>   
>> +union tls_iter_offset {
>> +	struct iov_iter *msg_iter;
>> +	int offset;
>> +};
> 
> Is this sort of atrocity used elsewhere in the kernel?
> If you can't refactor the code you can pack args into
> a structure

What's the point of packing arguments into a struct in this particular 
case? Depending on zc_page, I need either msg_iter or offset, and I'm 
reusing the same CPU register to pass either of them. The performance 
isn't affected, and the amount of memory used is the same. A struct 
won't allow to achieve this, it would force me to drag 8 extra bytes, 
but we already use all 6 registers used to pass parameters on x86_64.

> but I've not seen people cast mutually exclusive
> arguments to a union type.

It's the purpose of a union, to hold one of mutually exclusive values, 
isn't it?

> Is this "inspired" by some higher
> level language?

It's unfortunately inspired by C and its freedom to allow 
microoptimizations/hacks. The hack here is that I use a pointer being 
NULL or not-NULL as an indicator what type the other argument has.

The closest alternative from high-level languages I can think of is 
enums with attached data from rust or swift. However, rust isn't smart 
enough to perform the optimization I described, so no, it's not inspired 
by it :)

Options that I see here:

1. Union.

2. Just pass both parameters and use one of them. Drawbacks: now we have 
7 parameters, one will be passed through the stack, and it's datapath code.

3. Pass `struct iov_iter *` and cast it to `int offset` when zc_page 
isn't NULL. As we are compiling with -fno-strict-aliasing, and int 
shouldn't be bigger than a pointer on all supported architectures, it's 
going to work, and we still have 6 parameters.

4. Combine `int offset` and `int flags` into a single 64-bit parameter.

Which one do you prefer, or do you have anything better in mind?

>>   static int tls_push_data(struct sock *sk,
>> -			 struct iov_iter *msg_iter,
>> +			 union tls_iter_offset iter_offset,
>>   			 size_t size, int flags,
>> -			 unsigned char record_type)
>> +			 unsigned char record_type,
>> +			 struct page *zc_page)
>>   {
>>   	struct tls_context *tls_ctx = tls_get_ctx(sk);
>>   	struct tls_prot_info *prot = &tls_ctx->prot_info;
>> @@ -480,15 +486,29 @@ static int tls_push_data(struct sock *sk,
>>   		}
>>   
>>   		record = ctx->open_record;
>> -		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
>> -		copy = min_t(size_t, copy, (max_open_record_len - record->len));
>> -
>> -		if (copy) {
>> -			rc = tls_device_copy_data(page_address(pfrag->page) +
>> -						  pfrag->offset, copy, msg_iter);
>> -			if (rc)
>> -				goto handle_error;
>> -			tls_append_frag(record, pfrag, copy);
>> +
>> +		if (!zc_page) {
>> +			copy = min_t(size_t, size, pfrag->size - pfrag->offset);
>> +			copy = min_t(size_t, copy, max_open_record_len - record->len);
> 
> Nope, refactor this please. 95% sure you don't need 4 indentation
> levels here. Space left in record can be calculated before the if,
> then you can do
> 
> if (zc_page) {
> 	..
> } else if (copy) {
> 	..
> }

It'll save one indentation level for the zc_page case, but not for the 
other:

copy = min_t(size_t, size, max_open_record_len - record->len);
if (zc_page && copy) {
     ...
} else {
     // I still have to do this in non-zc case:
     copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
     if (copy) {
         // Same indentation level as in my patch.
         ...
     }
}

Is it good enough?

>> +			if (copy) {
>> +				rc = tls_device_copy_data(page_address(pfrag->page) +
>> +							  pfrag->offset, copy,
>> +							  iter_offset.msg_iter);
>> +				if (rc)
>> +					goto handle_error;
>> +				tls_append_frag(record, pfrag, copy);
>> +			}
>> +		} else {
>> +			copy = min_t(size_t, size, max_open_record_len - record->len);
>> +			if (copy) {
>> +				struct page_frag _pfrag;
> 
> And name your variables right :/
> 
>> +				_pfrag.page = zc_page;
>> +				_pfrag.offset = iter_offset.offset;
>> +				_pfrag.size = copy;
>> +				tls_append_frag(record, &_pfrag, copy);
>> +			}
>>   		}
> 
>>   		size -= copy;
>> @@ -551,8 +571,8 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>>   			goto out;
>>   	}
>>   
>> -	rc = tls_push_data(sk, &msg->msg_iter, size,
>> -			   msg->msg_flags, record_type);
>> +	rc = tls_push_data(sk, (union tls_iter_offset)&msg->msg_iter, size,
>> +			   msg->msg_flags, record_type, NULL);
>>   
>>   out:
>>   	release_sock(sk);
>> @@ -564,11 +584,14 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
>>   			int offset, size_t size, int flags)
>>   {
>>   	struct tls_context *tls_ctx = tls_get_ctx(sk);
>> +	struct tls_offload_context_tx *ctx;
>>   	struct iov_iter	msg_iter;
>>   	char *kaddr;
>>   	struct kvec iov;
>>   	int rc;
>>   
>> +	ctx = tls_offload_ctx_tx(tls_ctx);
>> +
>>   	if (flags & MSG_SENDPAGE_NOTLAST)
>>   		flags |= MSG_MORE;
>>   
>> @@ -580,12 +603,18 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
>>   		goto out;
>>   	}
>>   
>> +	if (ctx->zerocopy_sendfile) {
>> +		rc = tls_push_data(sk, (union tls_iter_offset)offset, size,
>> +				   flags, TLS_RECORD_TYPE_DATA, page);
>> +		goto out;
>> +	}
>> +
>>   	kaddr = kmap(page);
>>   	iov.iov_base = kaddr + offset;
>>   	iov.iov_len = size;
>>   	iov_iter_kvec(&msg_iter, WRITE, &iov, 1, size);
>> -	rc = tls_push_data(sk, &msg_iter, size,
>> -			   flags, TLS_RECORD_TYPE_DATA);
>> +	rc = tls_push_data(sk, (union tls_iter_offset)&msg_iter, size,
>> +			   flags, TLS_RECORD_TYPE_DATA, NULL);
>>   	kunmap(page);
>>   
>>   out:
>> @@ -659,7 +688,8 @@ static int tls_device_push_pending_record(struct sock *sk, int flags)
>>   	struct iov_iter	msg_iter;
>>   
>>   	iov_iter_kvec(&msg_iter, WRITE, NULL, 0, 0);
>> -	return tls_push_data(sk, &msg_iter, 0, flags, TLS_RECORD_TYPE_DATA);
>> +	return tls_push_data(sk, (union tls_iter_offset)&msg_iter, 0, flags,
>> +			     TLS_RECORD_TYPE_DATA, NULL);
>>   }
>>   
>>   void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
>> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
>> index 7b2b0e7ffee4..8ef86e04f571 100644
>> --- a/net/tls/tls_main.c
>> +++ b/net/tls/tls_main.c
>> @@ -513,6 +513,31 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
>>   	return rc;
>>   }
>>   
>> +static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
>> +				   int __user *optlen)
>> +{
>> +	struct tls_context *tls_ctx = tls_get_ctx(sk);
>> +	struct tls_offload_context_tx *ctx;
>> +	int len, value;
>> +
>> +	if (get_user(len, optlen))
>> +		return -EFAULT;
>> +
>> +	if (len != sizeof(value))
> 
> the size check should match the one in setsockopt()
> 
>> +		return -EINVAL;
>> +
>> +	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)
>> +		return -EBUSY;
> 
> see setsockopt()
> 
>> +	ctx = tls_offload_ctx_tx(tls_ctx);
>> +
>> +	value = ctx->zerocopy_sendfile;
>> +	if (copy_to_user(optval, &value, sizeof(value)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
> 
>> +static int do_tls_setsockopt_tx_zc(struct sock *sk, sockptr_t optval,
>> +				   unsigned int optlen)
>> +{
>> +	struct tls_context *tls_ctx = tls_get_ctx(sk);
> 
> Highly annoying but each file has its own scheme of naming variables,
> tls_main uses ctx for tls_context.
> 
>> +	struct tls_offload_context_tx *ctx;
>> +	int val;
> 
> unsigned
> 
>> +	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)
> 
> How's tls_ctx ever gonna be NULL here?

Shouldn't be possible, I'll drop the check.

> We should allow setting the option for non-HW. It's an opt-in, the app
> has opted in, the fact that the kernel will not make use of the liberty
> to apply the optimization is not important, no?

Yes, I agree that if the application opted in, it should work properly 
regardless of whether the optimization actually did turn on. However, 
the indication could be useful, for example, for diagnostic purposes, to 
show the user whether zerocopy mode was enabled, if someone is trying to 
debug some performance issue. If you insist, though, I can make 
setsockopt succeed and getsockopt return 1. What do you think?

>> +		return -EINVAL;
>> +
>> +	if (sockptr_is_null(optval) || optlen < sizeof(val))
>> +		return -EINVAL;
>> +
>> +	if (copy_from_sockptr(&val, optval, sizeof(val)))
>> +		return -EFAULT;
>> +
>> +	ctx = tls_offload_ctx_tx(tls_ctx);
>> +	ctx->zerocopy_sendfile = val;
> 
> if (val > 1)
> 	EINVAL.
> 
>> +	return 0;
>> +}

Thanks for the comments!
