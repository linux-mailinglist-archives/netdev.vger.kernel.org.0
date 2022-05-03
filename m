Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF045518CA6
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 20:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238525AbiECTAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 15:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238429AbiECTAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 15:00:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FA525C5A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 11:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqrzVhlpT5Z8RCuUvOEA9s7O2ztUoNGEsZ79TGpC//NpNhhwIAm5YehvqrqQHDlqSs7mSjn/8ULoiPWOAmMUBeQenBfuikLa2fm3iYDqB0Nj4nf9FymVAL6X2p9BaeLQeElLcaFRun4A+hsKSCFn0ZxijGAAqgQWe5wAGJ/DRq6xxpb83WhLoeVDn8VUOTxTr0Di1QdxaOXOt8v/Y0uOhCpUrN6iGuc11OFT+Zufg4hJVUop8Ww7LHMLC+t4QVfmInCDiHcQKmzkEkkUBZWFy13w1wX56jy4rVbdqci3dsAx7H/kqMF+oqjJlsrPEwsPDSR4XL0DPLRDhwc9CjBIRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4smPnT9mkm92BFUAGeVn+lW/TgkAFUEcuxCXsObwH0=;
 b=ALFjWJ6nzC0tBHuKVrwrPejImElr6FgtrLb+jhke4IxPKHkN7a/YLl2befi15EPM9czKygufATtUGIphyIGPZTxh75PfULwKEIWLJNF7XrBQPs8fIt0jWkT3Wyprsu9EQ9ODAvWoWsoiDlY94SjGviIULicBS7tMttjDIE6eadP7g6rLEbOjETl9rX8SwpeXpL9Z6Wlq2EZ7viSOwkBhd2RoF70vFkz6GZoFbFJsKEUuYn6Z0vINMlKx0iKuMr1W+I//yzY9nfzvklE0l8btUJ7MflaTs/XiB1TXMtKCPYCQqUZBqXCMezYrzNubND2gRUuNXTzpQ8M0L6z+mhHcsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4smPnT9mkm92BFUAGeVn+lW/TgkAFUEcuxCXsObwH0=;
 b=XlCY0a69NY9QeMKvX3Htjw+/SCycY9PKpZaCFuTuaAwUgMytIFABAUmdM8VXPov64bV6R9TDwpQtsS/TjkvVAwQbAV5gkMbIAF+UB1mpHUClHDl+9BFK9vBeEmHxAzbTyFADDtz1IH690ktY8xig+XtPKRrgIGhJIzosFt4B0XPqHhjP7y3YSWL/oNWTBQkChMD+nejQRh57O48HIjMDCibr93twYsM4Yb6+cDFQkHySIYYNEMFHIDVEZ/Cw/Z7uajdqNVmiLLQ6hFcX1oTR/21Ypk380ceHHZrOgKghI6HPZTSpC55VcArHKPeYNs3wjb+Of2a4RjuhTzdK9KCdvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22)
 by BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 18:57:00 +0000
Received: from BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::cdc2:b13d:821b:d3d7]) by BL1PR12MB5142.namprd12.prod.outlook.com
 ([fe80::cdc2:b13d:821b:d3d7%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 18:56:59 +0000
Message-ID: <db461463-23ac-de03-806b-6ce2b7ea1d6b@nvidia.com>
Date:   Tue, 3 May 2022 21:56:48 +0300
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
 <d99c36fd-2bd3-acc6-6c37-7eb439b04949@nvidia.com>
 <20220429121117.21bf7490@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220429121117.21bf7490@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0089.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::6) To BL1PR12MB5142.namprd12.prod.outlook.com
 (2603:10b6:208:312::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29fa541e-eda0-406b-1db5-08da2d36b3cf
X-MS-TrafficTypeDiagnostic: BL1PR12MB5158:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB515834B563A8F85E156609B7DCC09@BL1PR12MB5158.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRLmetgM3x35U+okwburBrn+77GakPnuLWPXUupxQnp4CDfC9I+802Y8383gwgfHpnpBt6sFVJGxVtUTjYBI3IgibY8qY/RijCSTlioEzhYwFS/Q47iLMMuV63lCEa1OzQawiQ9q5yre4rdutVHUdMh8GQ16hNGEl+4Ite2edL/qlNgtmKlryPmFQifebSzVCAgJ+dIze7zwtj6ViBjipEbhVP9oJ+XApLNZd888NLgeBjz8djbNjuwjoRpi2NVy4zewJsU8lqfEmwtcwlis8vTUANkuIw86NJMayzcEX6LNjmY7Ej9A5KCN6+3lR+lzZqWYSU8or3z6VNFWYrUfd+NjzAOhJXJ87HDQRY/u4p3eOOhA9zvldKKzfdajGylBo+yJVXcGXRQR+AaQILvkDPbEmdDy/Tznz48NprefvQLNyWX63avJRT2TF1JZkZrSNL5nS3GyGhJXkN5F57jkmBaROq7lqlKS+SKeDXGq25r61CuuX34jMg46JxBSVZJdae3uj7YcfvTF419DhTCBtJ5pKx9WjBP5BiRq4ofEnluXDPBfI5ih7VYFrMR+P5F3pqJbdqi1FShCWBgmkKMYp7Q9RnMqSZwC835zeQAUjh+MAjOXnP++E4Jrgg/PWGx7DALo8DUh7WyC7eWvmg+1erKDYd9p8tnvlPoqZjS6f5DQdzt+sJJyXFaRJ77sOjFh5dQ1zYsLyijvrmdUqr+mdsU/JYdAqc8uSe9Zn5Tx6XISUZwT7gckuOsHYgw9F8JA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5142.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(2906002)(316002)(2616005)(6666004)(38100700002)(86362001)(31696002)(186003)(8936002)(83380400001)(508600001)(53546011)(6506007)(5660300002)(26005)(6512007)(66476007)(36756003)(8676002)(66556008)(4326008)(66946007)(6916009)(31686004)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1pVcHZLWGZjOXhDUm8vZnhEc0NlOHFjTkNnczA4dTRheHJjb3ZsbFAram1i?=
 =?utf-8?B?SVlveVpOYSt5ZVBzcThPWXNRQzJiR1Rha2orUFVBM21mQkt0QU9oOGxTZTVC?=
 =?utf-8?B?QUFoOFNzVk54UFFyWVFiQVh4UzY3dHlHTStNcDF1SUQ1RW5KTHFjTThZQ3NE?=
 =?utf-8?B?amVDZVU4K29TZHZTdlM0TUR1Zk5MZ0YwbDdrSU1FSk15QS94ZnFnMlJtMmwv?=
 =?utf-8?B?NlFjMElMSi9oZjRSSCtsbWwxNytGVzRMV3dDWEwyV2p0bTllckptaVZXeG9x?=
 =?utf-8?B?WDI3bjR1bVNzZFRld29hbHViNWZISmYxamphMG1oMkcrWXh5Zml5aVFBNTAy?=
 =?utf-8?B?UXhYRXNiUlBrWGFTMXc4aWtOM3c2NG1BcmRKbE5pVlhKMjNoNS93bjMvODRK?=
 =?utf-8?B?bjBneW9ta2tONklvc0F4dDQzR0ZkcWcrTUc4K2xMeWppK1QxU20wa2c5d2xQ?=
 =?utf-8?B?RlBEeEtZQ1RkMjhNZE40QjJZbjV1N2o1bGF1eE1xekd0bk5qY25vVHVDbWdF?=
 =?utf-8?B?L2toWTZPOXd6cHdTdDNJcTVjYlNCVEdnMjZycVhSMlNzYkVRMnVTZG1Yek4r?=
 =?utf-8?B?aHZmc0l5VmljaVB0bVVFVlRBRk9lWTcra2xlai9GOGdhUXF5SUNHYXc4Unpu?=
 =?utf-8?B?ZWN3b1dtV0pkS2RsdnAzdVJDQksyT2FSdzFCK1JCc1ptT1A2VkRkLytxVm1s?=
 =?utf-8?B?eG93dDFrR3FnNnVkM0RPWHFMc1BTdVVXVjFLcjFvVExLRlF0dWNDSEh0SEdG?=
 =?utf-8?B?cG1aZW1LR0haUkkzZXU1eHhkZGdoS1FjNlk1TFgxTGFHKzg2UDZ0cEdMbUQy?=
 =?utf-8?B?M1RVeVJ4ZXA5VDhsRWE0NHZra1pFVVQxdHBwNXFHSlF5SzU1SHhkR1J1RnU5?=
 =?utf-8?B?UTFnSkxOVjdsZzl1akdYRk9uS2lrSStyRTlLSTM4Rk5VbzlMZWdIcEtGRCth?=
 =?utf-8?B?cnZPcmh5MGZqNVJKdDFTZkZ6SmY5cjJTbnBQTDdUUThDNWg5V1VoRm13Q1U1?=
 =?utf-8?B?VTZhRmZxNnE2NVZPV2tXWm4rWk1BZENrQ2EweGR0aEt2Qm9YODhuMUtCRjda?=
 =?utf-8?B?bEdmMEp3b1ZQTVlEa3V6M0JxcGNUM21iY2duYXZvcGE2cjQzMUN6U1FoTU5F?=
 =?utf-8?B?UGxocld0NUhteHFZK2V4RStNUC9xTG1ZMDJOK0U1K0RnMU1wUnVUZ3NvdTBF?=
 =?utf-8?B?MTFjY1FqOGd0K2t4OElqcU1OdDB1UDdMVWlBK05wK1BOUTJ2UDEwWHp6ZWMv?=
 =?utf-8?B?akhFUjNEZ0Q0aW13ZHNrQitzNWh2amM2WnRTZE9tdnVXcHBnb1hJT0gxWXVi?=
 =?utf-8?B?aXpjdWVvbThNS1JETnVIWERzcnlDazFWVnBJNzBrZU4veHA3YUZmalhBU0xu?=
 =?utf-8?B?ZWU3VnJMd2kxTGx0WkxIV3ZlYS9aTHU0WlBpTHk1NnYyREFMVGVITFR0VEZO?=
 =?utf-8?B?UG1NQS9EVnpTN2l3SXh6aUxGREg3UytyZ3B2Tm5XQlRUT29YTllaaXI3UmJw?=
 =?utf-8?B?ZldDaUd1Mit6VWNpOXk0enhjMmZuVFJYWi9WeVJnZTRSVllSV1pjTzIrNDlF?=
 =?utf-8?B?NkpHQjJCclVpNTIyRTkzUGlRVWhpNTNqSEpwRE5CQzRNdG5mRVNLRHdTR3Zl?=
 =?utf-8?B?ZFhWd0JmWExQZ09nVExEMU5BMlBPNkd1Q0tRSXVSUnZxMDVIdXFsRWpaVUlj?=
 =?utf-8?B?aFZaaVlOV05SNkprVkN3NGNaamlCS2MzWUJRVmVDeERjSVppd0o0dXRZRlVz?=
 =?utf-8?B?SjUyZUJrZm92NUZ6NzVYMC9aQ3dNdVg4VHZqM1RTNit0R1IwZTBBeUJCYnFv?=
 =?utf-8?B?WFJYQWZjQ09VU0E4eDRJalRpL09ldTY0QnY4dXBYU0NxVHVOUDVIbERGUlRS?=
 =?utf-8?B?aWREYkFHOWxiL3VTUzE0akRrNzNLaEcrdkNRemdCdlpqSEJSRkVFY1hsSi9O?=
 =?utf-8?B?WXNXc3haZVpSVkNoTEFtUEQ4bVZtd0E1WHA5Qm8xaUg2dUwvakxvWktKRVk0?=
 =?utf-8?B?bnQ1RUN5ek1ZUC8xb0c4RGU1ekthVFNzNk9zTitCWUphZ0Jsc2NQbHRsTGlG?=
 =?utf-8?B?U1gwSjY0a3gycHllODBocldwaUVxRWY4bVl3WU5SSWNRMmZ3UzBsYTV2Wjgy?=
 =?utf-8?B?ME12ZlRSanpJMkNIWk9UbURLRHNjWTdBNGFlSmRaNGJtdStWamN3WE5EU3U2?=
 =?utf-8?B?cXN3cmRKRWtpelJoRWdYaUVsSVpoS3BncHhqRXRhUDk0YTRkN2pBUEJvQTcy?=
 =?utf-8?B?aEZ4Z2VQazJ3NDJ2YjNFNFV2d1R6TUZiUDE3aFhpS1VQUWE2WE9MREdmTmgr?=
 =?utf-8?B?L2ZyT2RCeDZSaiswMmVySXVQSFlHdGM3cno2UWo2bjVJa1dqNnZrQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fa541e-eda0-406b-1db5-08da2d36b3cf
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5142.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 18:56:59.7806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1cSkV/4ztoPdirIwh0oMB8vtbS2pDbeZwfaxkpW1UbaRYRhIBqVp4QwHUBn4Z6LI2ScxAq8LZye+4mvClDXsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-29 22:11, Jakub Kicinski wrote:
> On Fri, 29 Apr 2022 17:21:59 +0300 Maxim Mikityanskiy wrote:
>> On 2022-04-29 01:11, Jakub Kicinski wrote:
>>>> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
>>>> index b12f81a2b44c..715401b20c8b 100644
>>>> --- a/net/tls/tls_device.c
>>>> +++ b/net/tls/tls_device.c
>>>> @@ -411,10 +411,16 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
>>>>    	return 0;
>>>>    }
>>>>    
>>>> +union tls_iter_offset {
>>>> +	struct iov_iter *msg_iter;
>>>> +	int offset;
>>>> +};
>>>
>>> Is this sort of atrocity used elsewhere in the kernel?
>>> If you can't refactor the code you can pack args into
>>> a structure
>>
>> What's the point of packing arguments into a struct in this particular
>> case? Depending on zc_page, I need either msg_iter or offset, and I'm
>> reusing the same CPU register to pass either of them. The performance
>> isn't affected, and the amount of memory used is the same. A struct
>> won't allow to achieve this, it would force me to drag 8 extra bytes,
>> but we already use all 6 registers used to pass parameters on x86_64.
> 
> I know why you're doing this, but you're not writing assembly:
> 
> +	rc = tls_push_data(sk, (union tls_iter_offset)&msg_iter, size,
> 
> +	return tls_push_data(sk, (union tls_iter_offset)&msg_iter, 0, flags,
> 
> even if it's legal C (i.e. not UB) it looks awkward.

It's not UB, cast between a union and its element type is well-defined in C.

>>> but I've not seen people cast mutually exclusive
>>> arguments to a union type.
>>
>> It's the purpose of a union, to hold one of mutually exclusive values,
>> isn't it?
> 
> The union itself is not the problem.
> 
>>> Is this "inspired" by some higher
>>> level language?
>>
>> It's unfortunately inspired by C and its freedom to allow
>> microoptimizations/hacks. The hack here is that I use a pointer being
>> NULL or not-NULL as an indicator what type the other argument has.
>>
>> The closest alternative from high-level languages I can think of is
>> enums with attached data from rust or swift. However, rust isn't smart
>> enough to perform the optimization I described, so no, it's not inspired
>> by it :)
>>
>> Options that I see here:
>>
>> 1. Union.
>>
>> 2. Just pass both parameters and use one of them. Drawbacks: now we have
>> 7 parameters, one will be passed through the stack, and it's datapath code.
>>
>> 3. Pass `struct iov_iter *` and cast it to `int offset` when zc_page
>> isn't NULL. As we are compiling with -fno-strict-aliasing, and int
>> shouldn't be bigger than a pointer on all supported architectures, it's
>> going to work, and we still have 6 parameters.
>>
>> 4. Combine `int offset` and `int flags` into a single 64-bit parameter.
>>
>> Which one do you prefer, or do you have anything better in mind?
> 
> If you declare the union on the stack in the callers, and pass by value
> - is the compiler not going to be clever enough to still DDRT?

Ah, OK, it should do the thing. I thought you wanted me to ditch the 
union altogether.

>>>>    static int tls_push_data(struct sock *sk,
>>>> -			 struct iov_iter *msg_iter,
>>>> +			 union tls_iter_offset iter_offset,
>>>>    			 size_t size, int flags,
>>>> -			 unsigned char record_type)
>>>> +			 unsigned char record_type,
>>>> +			 struct page *zc_page)
>>>>    {
>>>>    	struct tls_context *tls_ctx = tls_get_ctx(sk);
>>>>    	struct tls_prot_info *prot = &tls_ctx->prot_info;
>>>> @@ -480,15 +486,29 @@ static int tls_push_data(struct sock *sk,
>>>>    		}
>>>>    
>>>>    		record = ctx->open_record;
>>>> -		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
>>>> -		copy = min_t(size_t, copy, (max_open_record_len - record->len));
>>>> -
>>>> -		if (copy) {
>>>> -			rc = tls_device_copy_data(page_address(pfrag->page) +
>>>> -						  pfrag->offset, copy, msg_iter);
>>>> -			if (rc)
>>>> -				goto handle_error;
>>>> -			tls_append_frag(record, pfrag, copy);
>>>> +
>>>> +		if (!zc_page) {
>>>> +			copy = min_t(size_t, size, pfrag->size - pfrag->offset);
>>>> +			copy = min_t(size_t, copy, max_open_record_len - record->len);
>>>
>>> Nope, refactor this please. 95% sure you don't need 4 indentation
>>> levels here. Space left in record can be calculated before the if,
>>> then you can do
>>>
>>> if (zc_page) {
>>> 	..
>>> } else if (copy) {
>>> 	..
>>> }
>>
>> It'll save one indentation level for the zc_page case, but not for the
>> other:
>>
>> copy = min_t(size_t, size, max_open_record_len - record->len);
>> if (zc_page && copy) {
>>       ...
>> } else {
>>       // I still have to do this in non-zc case:
>>       copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
> 
> Can pfrag->size - pfrag->offset really be 0 provided
> tls_do_allocation() did not return an error?

No, it can't. Now it makes more sense to me. Thanks for the clarification.

>>       if (copy) {
>>           // Same indentation level as in my patch.
>>           ...
>>       }
>> }
>>
>> Is it good enough?
> 
>>> We should allow setting the option for non-HW. It's an opt-in, the app
>>> has opted in, the fact that the kernel will not make use of the liberty
>>> to apply the optimization is not important, no?
>>
>> Yes, I agree that if the application opted in, it should work properly
>> regardless of whether the optimization actually did turn on. However,
>> the indication could be useful, for example, for diagnostic purposes, to
>> show the user whether zerocopy mode was enabled, if someone is trying to
>> debug some performance issue. If you insist, though, I can make
>> setsockopt succeed and getsockopt return 1. What do you think?
> 
> I'd say "whether the optimization is applicable" rather than "whether
> the optimization is turned on". User can check whether the connection
> is using SW or HW TLS if they want to make sure it's taken advantage of.
> 
> Speaking of which, should we report the state of this knob via socket
> diag?

That sounds like an option, I'll take a look. TLS doesn't expose 
anything via diag yet, does it? The only option to distinguish SW/HW TLS 
is ethtool, and there is no per-socket check, right? Cause a HW TLS 
socket can downgrade to SW after tls_device_down, and ethtool won't show it.
