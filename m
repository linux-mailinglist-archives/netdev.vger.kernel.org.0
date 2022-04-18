Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57137505B26
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244310AbiDRPhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbiDRPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:36:49 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2085.outbound.protection.outlook.com [40.107.102.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4465838E
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 07:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIkV+Fx/9aM0Y2gquRA9AChIox8YuKsZTEMwgqOUakicraP/wIDwiJKIomCZNs6rcxSlD6H6oM5TFIMbbUs7xtSjvsfXLpDjcYfFtm6029NUKjQ8nQXLSlQCxACodKByURun38Kd4biY55/eCOAlWp9f37bDDvkudQGaR4rTGMKCCmLdpESYSVzTRUZH6s/OPpnWlZF85OmZyG2KDsNpO/qK7l5QKN3VOP5T+kDKRWgJlRE+wTaKsP3hsCJA6fUbBf7TPb4pVzUlnZdnFOkc2hSFnq1hNDv8f/vRg/JtI81lEaObwB5GDhh55LEzldFpEhxbanyJ2rgPtK08v+8fZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/C8iJSA/GCHtodKJegRggUkqsBlE+Wyin52UthjFBNY=;
 b=hhDlrSOSrpApUdH1ARV6sbFz3aUzWYDDHA1GC1dYxNeI7ONaPl+QwaawYtpY+mZSonGKkjYBcOzsOENOMnnkAYcB6Fml2H9cEtyYyqKQY4n91qzzYBm8zJYrQixUNv1DPUrgc8EBocrFL4c7A69TYibIChYpygugGGRX5aVe3sw663Y+dJxjCkKHPkLKxlVuHtxAXC2oc7E46Sv79+pu9KEaBFLyCC4gU1wrtLsD/PXYGUW06MGhiKY0OCLfvzZKKjx3/SZgJuWRDyf1DNST2DCYbGw/7AqD8dsqUbHqpydiwyoEuH5NdqIJ7/h5x/Yb5b7mPrUImZR2yDCSnOwY9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/C8iJSA/GCHtodKJegRggUkqsBlE+Wyin52UthjFBNY=;
 b=H+YF5Tysy4itYSV8GTeRkWEvPQH3dscHfrPsPOz04utIFlHS4ucayOwCuBXmiTkMj27HY0FRAcUKCiACzfM0Jk6SjBIN9QJIQccMG79vO0lxdy5AoMIPtrnIB20qZ4lBB2izltChgSizbHhf33qN3YSriXJP5DMkq+MTh5u+DKNtDZVYaQxh8La5yGjDbfypu+ugfd7jBQfX32hh0odDrOM3cOKiJCc5C9X5v2D4Suz+gyTxnl6m3Xg80Zm4g32Qcaxj+sxCX7ZFiF5KcmVIHgBjsGw8WkVHQTc5X7QrF8HDakikpHB2t8stfeXQ9+5qqsLemcZ3UV2pltIvYWc0Tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MW4PR12MB5667.namprd12.prod.outlook.com (2603:10b6:303:18a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 14:56:37 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%9]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 14:56:37 +0000
Message-ID: <3c90d3cd-5224-4224-e9d9-e45546ce51c6@nvidia.com>
Date:   Mon, 18 Apr 2022 17:56:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
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
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220414122808.09f31bfe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0178.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::21) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec14cd81-c985-4afc-0fbb-08da214ba342
X-MS-TrafficTypeDiagnostic: MW4PR12MB5667:EE_
X-Microsoft-Antispam-PRVS: <MW4PR12MB566746F5CA2F603EF588CB90DCF39@MW4PR12MB5667.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6KUZbT1QdiChWF5zJc23pgq1No8vrXzZo+4UbyR4RpsCla7DZ58b1ngAKfKdv7GASdBY/xUu5Ln40TS9jLXvHrOzE4DWyOASmvB1lis+zJQFBh1dFmlgnYlo4XzkjAiDR2flxsthgkNo/bednAcQrnGf8F3Dou/vXTMS6Lyx1kdnkcPCPC/B/Idul26BDmfuahvlPzELnboL/BGm6Q2AIaEnANDKQLRGW3EfpGzt/y5NPF3NQHo4s8VJoOeiBABjjZrsnadvCv7CTls+DgIWLLpaa32sQz7hOZtXo8LlHaQ/lXOvQwvjdch5jDwken+rIW/4uAo7UHqKtE80/TBMyrvvm9GZAFJp68I8Kgx+qwxWZlrHZ2OTWtnLyP8JF9b5uZ69Lmo0cC144YtPE5uxKZ4MVcBIS5BUoKQmH2VgfT2B/4kTxb50qOBbgawjg8yUPrCS43RP8WB45h+Ou6FCHWwZJ4CoBAHX1DfGLSWgHdOJndz0PAWDo2fVv1T7ljXVtxIuqSGw8v18mHZ6vTScm1wPVFG0hTKr2HMAF/kwKXa1sVkCcXzOLmPH9xnOpNzffoED6cIqhHJsFRiWHhevXqpz7s0WOOSBk6h+isp3Qe/3jd0fKvQNqQGxS3qUv2NWbfoQo3QatcfcQgQOxWMSLzgDP/3MZMjvboADXFBoamoOj73FMpg8Y+XwAUtt2Q7Orj1kbvWfpsaYHbf1TFek9E3S3jBjdzRKg98oTwfIyNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(2616005)(4326008)(5660300002)(38100700002)(31696002)(186003)(86362001)(8936002)(66946007)(83380400001)(8676002)(66476007)(66556008)(6506007)(6666004)(6486002)(31686004)(508600001)(36756003)(316002)(6916009)(54906003)(6512007)(2906002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0s0OEtBTHpZUjFVcm4wZUE5ejRVc1BqbW9FZ0E5WTVKNWtkN0Y5THJOM0Fv?=
 =?utf-8?B?aG82c291TkhnWGx0OWdwZUpLcU95aGVFbE5iQ1dqWjF6b2M1dU5tUndqcSs5?=
 =?utf-8?B?c2JLaFZnU1pQenl1dE9ZeENBbTVacXVhMDdlVkllMVhLaXZRSHlXQlZSVUw4?=
 =?utf-8?B?N0JHWGV5dXVKUzFhL25FazBSV1RzTUVOYi85MGE1bUIySGJWbExhQ0pucHVn?=
 =?utf-8?B?M2prdUVnOXMybFVUNUd1UDc1M2FMMU9JQ3JvSXpEaDVSZ0VLei8wekJhQkVh?=
 =?utf-8?B?MjR0VWhOa3RPdXRWZ0J3TGlUQktnNDBOcUdXSGFGSmhMNm0zMmNoV1RBckI2?=
 =?utf-8?B?VUJTRmhGa2E2VHNhTDFLTkwvNWNXOVpNS1VRYjFrV3VudkZCaFpETlJucGFm?=
 =?utf-8?B?KzZhY1BNUkloeDEyRFRpc2xDWUJ2d2NlMmZiVnMwaWNKRXlWcmtyNTNOTmUy?=
 =?utf-8?B?Vm5RKzBocVc3MTJOMExHMjJuZ2tZQTFtZmxoUFBZMVVWNDU1NDUrdmhyZi9E?=
 =?utf-8?B?bHM1MnFUSEM4SUFGalRBaG1FWHFDYzVuS2dsbldzUXBUVWJtNXFnNVZjM3hY?=
 =?utf-8?B?N1V5VTA4WGVQM1NDak9qMy9FeUhRbCs2R0tvbE9wWmswRkR4UVJJcS84QXZN?=
 =?utf-8?B?b1lBeVpNUUtGMVY4REN3V1NKRlJBSFE5K1FCekZBNjR5THZwdzluMWd2aW9z?=
 =?utf-8?B?ZHNXb0VLa3lkZ1BzMFBpM1BGYWVBaktPdjhQZm45cEMwYkphd3F5a3RUeU9K?=
 =?utf-8?B?RjQ1eUlBNjl3U0N3aWUxQnlFcktNRklYUitUczY0SXpyNENmV2ZLT2pWV3lq?=
 =?utf-8?B?ZGhGUlQwdUhEQmdEMTVmb25zK290cHdYL1hxREpIT0JQMExoTDljeE9jWk9Y?=
 =?utf-8?B?NTVNcHFBV1BYb0loRDFSVy8waHFMVHFITTVudlVqRDlGczBjS1NuMCtPUlF6?=
 =?utf-8?B?WVAyZmV4Z1pXSXpGOGZrVXNLdjRHcUpCKzhteG1lWEJwdnpsRWlXaS92aFFt?=
 =?utf-8?B?RzlRT3ViNjNFOURaSFVEMjR0NFF6WWwvSjg1c2xlbVZUZ2N2R1FPYnhuV1kr?=
 =?utf-8?B?RGZrVUJXWTJPdHkxSEtkTEhBZWVPeHpGKzJ5SVI3OThxRnM0dWxYRjBtTmtQ?=
 =?utf-8?B?WldFejJzTU5vaDhlOTdiQkNTcWw1YjRBMVBTUGlEOHdvOWROYzkyTmVxRlRP?=
 =?utf-8?B?YXVBdEhRK0ZEZE85K0pKdXdpRmVGODhDTnVqbmVrRmhpMGkvK0xWTUViWkFQ?=
 =?utf-8?B?S3p2ZkhhcGI4Um52NDB1TkZQL3ZlZmExaXdJZnc0QkxjeDcwNDZmc3lwVklT?=
 =?utf-8?B?NFFRYnJmM1lwcW4vb2x5b1lIOEx5NWpIamJJSEcxSlc0YVo0Nm9SZWxZa0xI?=
 =?utf-8?B?WHdMcFg4aTYrNWY4UlpDMi9rQUhHV1UxcEpjVFFNSC82VjFKSDFZaCtLSWNj?=
 =?utf-8?B?cmE0M01CRWczU1ZsWTJncnZGRThHUGViZCtBY2RXOTRsWXBsQkEyZVhMdHR1?=
 =?utf-8?B?THIwc3dmNFc0Mm1BNGZWUzRMYWxLVE91QzY4R3hMN2ZVNzdCa21mVTNTbmYx?=
 =?utf-8?B?RlFDOThDWXppOTc0cG9SZXF2c1B3TlRVaWxzQTY1MjJZTTBad0lpVzVOajBs?=
 =?utf-8?B?Q1dGTDc4N3JqZkU2ZGdVUzFianE4NFZTWkI2djY5NnlBNU5LbDhGbHprclJ2?=
 =?utf-8?B?QytaK2E4VHFuT2dtelhQbGh0Q2NWYnJTcUoxaTBsNzVYVzJTdDhOZEY4V1dH?=
 =?utf-8?B?YTlidHNZWXNPUlM1VXd5akV1UDVpTFJQRFU5aHRGc2ZlU3RXWkN6c3pNcU5S?=
 =?utf-8?B?OE9zWTNnRlFGcFRQVTFEclVDLzlOb2RuN2s5Zmt2OGdVN25tWlpUQkl5RFlz?=
 =?utf-8?B?b1NGRjdlWDdrc0ZFT0E2eU9WTTcxUDNndEVxNlJKYzBjdWRJY3dZQjZ1UXFj?=
 =?utf-8?B?ZEFQSzhrMXRLL0xOVUJlQXp2SzZxTTRXdkVWVVltQ2pMRUUxMW03cExBYWd0?=
 =?utf-8?B?Zm84U2NlR0l6cU81YmxRVERjVFhlUkNyU3l2cDA3OXVER0VzMnJGT013T1Ar?=
 =?utf-8?B?UUk4TVBLZDFTaEs0bEVIVGk0SElOSU5Zd1F2ZGEvMWZ6aHRUcUVhOFl4QVNw?=
 =?utf-8?B?VzBUVFN3bjNvWWxZVWo5MTFPWjhSWGV0RmZ5ZGRLMjZYeXNNOE1KODFPNjM5?=
 =?utf-8?B?NExjS0VNQ2RiT3FnV2tFeFBIRjcyakE1M0l2QWEweFJidXllQnlDbm9lRWpC?=
 =?utf-8?B?ZTVZZ2EwTGJzVGRYMHh0VG9kdmg4WnBrV050dlh6bEJLd251b2FKYzdXa3VY?=
 =?utf-8?B?a0xYK1FZd3ZRZEl1M0xiT3ltai9ZVlJPNFhROXJRZ0JxNUFvVk5Idz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec14cd81-c985-4afc-0fbb-08da214ba342
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 14:56:37.4293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UWnIr5HuX/tAL7yiguEA5OhjnpLDbLYJ7E8MbPhRWdRTITldAYEiH/a2cugRqUoCrhLb+RvwA4u+pBtAEUc0PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5667
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-14 13:28, Jakub Kicinski wrote:
> On Wed, 13 Apr 2022 16:49:56 +0300 Maxim Mikityanskiy wrote:
>> Calling tls_append_frag when max_open_record_len == record->len might
>> add an empty fragment to the TLS record if the call happens to be on the
>> page boundary. Normally tls_append_frag coalesces the zero-sized
>> fragment to the previous one, but not if it's on page boundary.
>>
>> If a resync happens then, the mlx5 driver posts dump WQEs in
>> tx_post_resync_dump, and the empty fragment may become a data segment
>> with byte_count == 0, which will confuse the NIC and lead to a CQE
>> error.
>>
>> This commit fixes the described issue by skipping tls_append_frag on
>> zero size to avoid adding empty fragments. The fix is not in the driver,
>> because an empty fragment is hardly the desired behavior.
>>
>> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   net/tls/tls_device.c | 12 +++++++-----
>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>> index 12f7b56771d9..af875ad4a822 100644
>> --- a/net/tls/tls_device.c
>> +++ b/net/tls/tls_device.c
>> @@ -483,11 +483,13 @@ static int tls_push_data(struct sock *sk,
>>   		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
>>   		copy = min_t(size_t, copy, (max_open_record_len - record->len));
>>   
>> -		rc = tls_device_copy_data(page_address(pfrag->page) +
>> -					  pfrag->offset, copy, msg_iter);
>> -		if (rc)
>> -			goto handle_error;
>> -		tls_append_frag(record, pfrag, copy);
>> +		if (copy) {
>> +			rc = tls_device_copy_data(page_address(pfrag->page) +
>> +						  pfrag->offset, copy, msg_iter);
>> +			if (rc)
>> +				goto handle_error;
>> +			tls_append_frag(record, pfrag, copy);
>> +		}
> 
> I appreciate you're likely trying to keep the fix minimal but Greg
> always says "fix it right, worry about backports later".
> 
> I think we should skip more, we can reorder the mins and if
> min(size, rec space) == 0 then we can skip the allocation as well.

Sorry, I didn't get the idea. Could you elaborate?

Reordering the mins:

copy = min_t(size_t, size, max_open_record_len - record->len);
copy = min_t(size_t, copy, pfrag->size - pfrag->offset);

I assume by skipping the allocation you mean skipping 
tls_do_allocation(), right? Do you suggest to skip it if the result of 
the first min_t() is 0?

record->len used in the first min_t() comes from ctx->open_record, which 
either exists or is allocated by tls_do_allocation(). If we move the 
copy == 0 check above the tls_do_allocation() call, first we'll have to 
check whether ctx->open_record is NULL, which is currently checked by 
tls_do_allocation() itself.

If open_record is not NULL, there isn't much to skip in 
tls_do_allocation on copy == 0, the main part is already skipped, 
regardless of the value of copy. If open_record is NULL, we can't skip 
tls_do_allocation, and copy won't be 0 afterwards.

To compare, before (pseudocode):

tls_do_allocation {
     if (!ctx->open_record)
         ALLOCATE RECORD
         Now ctx->open_record is not NULL
     if (!sk_page_frag_refill(sk, pfrag))
         return -ENOMEM
}
handle errors from tls_do_allocation
copy = min(size, pfrag->size - pfrag->offset)
copy = min(copy, max_open_record_len - ctx->open_record->len)
if (copy)
     copy data and append frag

After:

if (ctx->open_record) {
     copy = min(size, max_open_record_len - ctx->open_record->len)
     if (copy) {
         // You want to put this part of tls_do_allocation under if (copy)?
         if (!sk_page_frag_refill(sk, pfrag))
             handle errors
         copy = min(copy, pfrag->size - pfrag->offset)
         if (copy)
             copy data and append frag
     }
} else {
     ALLOCATE RECORD
     if (!sk_page_frag_refill(sk, pfrag))
         handle errors
     // Have to do this after the allocation anyway.
     copy = min(size, max_open_record_len - ctx->open_record->len)
     copy = min(copy, pfrag->size - pfrag->offset)
     if (copy)
         copy data and append frag
}

Either I totally don't get what you suggested, or it doesn't make sense 
to me, because we have +1 branch in the common path when a record is 
open and copy is not 0, no changes when there is no record, and more 
repeating code hard to compress.

If I missed your idea, please explain in more details.

> Maybe some application wants to do zero-length sends to flush the
> MSG_MORE and would benefit that way?

If it's a zero-length send, it means that size is 0 initially, and 
max_open_record_len - ctx->open_record->len isn't 0 (otherwise the 
record would have been closed at a previous iteration). That doesn't 
sound related to swapping the mins and skipping tls_do_allocation on 
copy == 0.

Thanks,
Max

>>   		size -= copy;
>>   		if (!size) {
> 

