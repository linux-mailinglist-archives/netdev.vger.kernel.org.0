Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D339451C7F1
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384490AbiEESiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383278AbiEEShG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:37:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E48B5DD00
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 11:27:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkZx1lvD0c3CgkV3LWOLOBl+IxmxW44BBY9ggE5j7x11uSdnSPUe8zHGIc0IYm1MbYg+GDhfyc/i5BYKUShXT8hPPc1S7+ZaTgiIRVa9SESF3IlUJ1lHho6UY3o7xPqa+FoX/Oe5uHnQLbncAbHZNQwUiqEwNp+rzf9gKhC7sl1JWV23x9a7zZSwL7PMeJQo0AM0pBPVTWrWW4YZR8eczaM3nRZ8l1hUGoehW9M0rPILYPBWPWLVwyLglo3XigB08RWK1zT9DFEIcrfQHVgGaMvaGyx1ICOFvME9KMjBx8Hz7tAS1ZY+fmu3hCgTwjC9Q5B70SnqOGp262xz6QKcoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OduVbBu0e8yTlYvUayDKZJKDbPncvU/2Q0NLLmX4I8I=;
 b=jG3+Xsge2lhIcTkQUVuTussTHLPlJXZKw9lb4Sn2oHcU1myZYl67plbHcz+6/N31tHY/lE3LaUCpLxuwhO0/wjc/WyU08qB3od34IFD6CW7Dgx0u8pNGP8Ia+7Qz8Dk0oWX9JakB4Qb9TbQ+FWzQdv0OmmvqXK0KplzfROmA9orw3IUhN8WmeQQivbqhKZYW7MLSUF9wD35CBfkQmj14MPuGfSkpBuhkYu8Fo+h+tHiVcte0KVeFtc5a0HhdXCFLsJWU79irHg/z7LyCZBEALOUR9kf2mneIXellfFmVM00Gqrd+nV3Gl9B5E2GqPG13enPxn8pjRf6yMVkwMQ/aAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OduVbBu0e8yTlYvUayDKZJKDbPncvU/2Q0NLLmX4I8I=;
 b=f0V1Gg9xS//E3Gt4wpu8mACWcapibVAowo1Bv0lzQev78NYNr+vIxkCEX82ElQ7E4rRJCwbly9h94mc9abGnyFr/Cnk9q6hMROInkmHWSrl+lPsDvMC9BzmbS+Hi1ret3/Cg0AKllhclmZx6fup5wVHEwbmJB4rtSb+wMAAktlmvbLcvwm3JXhtjWGQMbUxBFjJKmYTGOo274+GsiHsCmqARsZHuM33SOgh3ZCqlP92jUjkGFLRl9QRIRMFKIlfkG4NqcgyQkVPRATDrwJxwQukWQzXpJDMQRAKnrKr9ZmR1w1ogLwju/UlkSfJo2Z1C2l4S59/dkzhiOTRaLsxzNA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by IA1PR12MB6331.namprd12.prod.outlook.com (2603:10b6:208:3e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 18:27:43 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 18:27:43 +0000
Message-ID: <f1fa7f2c-d5ef-256b-0bc3-87950c2b6ab7@nvidia.com>
Date:   Thu, 5 May 2022 21:27:32 +0300
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
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <5dba0c54c647491a85366834c8c1c7d1@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0533.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::18) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1a0e6fc-7fe8-4693-2c70-08da2ec4f14f
X-MS-TrafficTypeDiagnostic: IA1PR12MB6331:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB63315351F90C069713599F1DDCC29@IA1PR12MB6331.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6oHNTKc1sAF4jySboXsQ7pEs0hp6i13S8ibvCNuwoTDD5ZyhpuatsruI/qfL6Q47euK+UKRoRy00WqHqpOp03jC6lN/DNhejQVSpUHZazGA+FHpWlM3bC9xSFbjiBCXtufoRSS0K7ZUxNRlmq++fFi/7n6U5Cjqde5X0TVyfBJAYZvpHCQH7RnE1Iapgs+Csp6aaPYGHxJswYm1UC7aGTuW9GFNDA/T6fgIPWeVF5Agq5QZDzBlMA4+0kYi3Z7F8dtbyldkTND5VoQpFa8b2GK5pB7pSPLmQnwJtht5WKK6efEWu3AhDLNSpVx8bUqzzvjx7TFijI8DNmosWwNddz+r4RUcqaw9aKmqNl6JSWBrAr4GoSsaqFNtPInf5LVy1DFZTiHvkFR8u6PNUN+bQ5SxC+qdToO3spqUY8ksIcPzz6CFSA0atnvmITMsVTAwYmKJEOX1dHLGWnwHvsUHOZib5rM27p2JOXA3qhDlq1ec5xLf6WoaAR60ZQ9qATTMIqGXDgqILFo3nA3e/A+/tRcaGMTNDWOtfYuI7vNrE9ObsS0Ds4wwbvVmiZhbRxYB7cD7G9r5mxI1Mk3uDhkSc/K/xNyNSUN7aq0USSOABCTeB0saq4MJxuLBFkQomNdzg8J30gxMh/ILnaxzudBEsZDYiuHJyccMtrUjCpyHBtNlD7QSi1bWn1lCmpZ9+AiOfHWquf/iuSOdXkXuMQJC20AL3KD9reYXBKYuboIIZqIM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(508600001)(83380400001)(186003)(2616005)(31686004)(26005)(6512007)(2906002)(53546011)(316002)(5660300002)(54906003)(6506007)(66476007)(8676002)(66946007)(66556008)(6666004)(38100700002)(8936002)(86362001)(6486002)(31696002)(4326008)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTlvdTV1MGZGUzlvRjh6MFI0ZGs1d0pjZWhXRFpOeGk4clRjV1dzMHhKMG9S?=
 =?utf-8?B?ZFpEYkVsRTU2K2pWQWdFbHZWQ3RWRzhHbFF3anc1ZG1wYklsVEhoM2c3L3JW?=
 =?utf-8?B?dnEycUR4ZGYyUldISnVFOHJxMkI2UHl5RWp0N1pmeE9IaSs2bkF5ZWNHeXph?=
 =?utf-8?B?dHd4bUhMbWp2aXd6YXZ1UDZmTkprbXlOSXFxdXF3Vm9Ecmt0cDd0Vy9WV3dl?=
 =?utf-8?B?dktpbWhMSVVFVUJHY0gzVHF2c2FNcGRJVFVjYVVtR0U5RWc4NzgxNlZnNE5W?=
 =?utf-8?B?ZEsvcmRUV0VWeWp6bEJlTVlxR2Q0U0NaSzR2UHNxY3E1Tm04NE9RZmV5QXBG?=
 =?utf-8?B?RGtLZWltMnVwQzRLT2RwbWVKcTh3d0RDUFlTU29rb1BHZHJOaVVUZVhaNFBM?=
 =?utf-8?B?aUpHUTBQK0NHbkZ0cW83Smk5ZXpMQWdEZkgvcjJ4Q0g4ejZScTg5RmdjaHhZ?=
 =?utf-8?B?YlRHeGhGS1hIZ3VLQzQydVB5R2hXTGxxMjRrZ3M3UTJrZkZ5NzVNbG8zc2s3?=
 =?utf-8?B?TDUrT0Z2TkxNSFJ3a3MrZG5RN3FaK1A1dVNNanNIVGd3U2xobWxqRDFVdkVu?=
 =?utf-8?B?K3hoUTlrU3ZqUnNCR1BuUDh5a2duZHRXVVFJWEY2L0lsekpYNlRyd1BPVFFm?=
 =?utf-8?B?UVhmTWhoa1kySisxTXRzNGlSYkdhVHlMUE1MV3EwSGZxeUlXVGJsN09ZUzlD?=
 =?utf-8?B?RG5lWWdIbGlRQXBiYXlYTE9HSHFDdmI3Nkt3bmdqQXFmZmNPb2k5OER2dkg1?=
 =?utf-8?B?N3Jva3NKdndLd2UzRGJuMCs4T3kxNEpYdTV2NmxZbzBudUNuQTMzanRTRjN6?=
 =?utf-8?B?UGw0dG5WTFh4ZHNZZk8zblNhNTVmbGlEQXRwK1N2T05BSjl3STdhWUtwUWto?=
 =?utf-8?B?T0tUdlNHdEJtN2Y4R3B2Z2dxdHZnSCtOZURZcVFieWNRMGkyNzB3d1hHamdl?=
 =?utf-8?B?bEY2L2g2ZE10S00wRjlMMVVhZTl4anV2UWI3bmt4dm10dzAyendzK1Q0Tmhz?=
 =?utf-8?B?QXViTk04VXlMRmpVbkdFdDhFeTQ5WDRYUkkreXlFODkyL2ZZNEo1WTg2KzFm?=
 =?utf-8?B?c0VhekdxTkhCREt4ODQ2LzB0TzE0M25SelN6V05tdWF3Wk9YUW9LbDBrWVBK?=
 =?utf-8?B?VWdRMm1Bem5kSE1Hanh5c296Qm45SkI1TEZPK2FsdVl2NEVQZS9OQ3dJUTB3?=
 =?utf-8?B?Y09GQlhiRFVFUEJqTFZDaW9kS0YyN3RyYld2VXpuNjVydVdRRFJiWm5UbEh0?=
 =?utf-8?B?Q2xjYk1KUFZxWTJGNUtiZ1YwaEI4QWRoUG10c0ZFbW1WNCs5S2pxd2FVcm1V?=
 =?utf-8?B?SVpWNU5HL3Y5QmZxMjJwa3F0bXJEU3drK29RdGlUMTkzeGsvaGNQZmNsY2t3?=
 =?utf-8?B?TFFCd2xNU2U3OVo5MDlPcDEzZEFMMnVSTmJEQTc5Z04wQlYyNHEzSDdmTEV0?=
 =?utf-8?B?SnYzbldEeW0wVzk0VzFTei9tVFl5Q0NQQmdINFlremFGYWVYWEVleUJhaGRM?=
 =?utf-8?B?eFNoSmZDWHYzRHlZa25JNmZycHNhSDRPMUorTmhsS1l5LzgvUmdvWStUZXN0?=
 =?utf-8?B?Y1VLNmJsYmIvUlBYV2U5bWw1WU54U1hGUzRpNnh0cGMxTnBqSnVGSkp0dUVR?=
 =?utf-8?B?WHJwWkdpTjUzbFBLSXBWMjlMS3RaMmVIT1Jzd1pWZURiaFA0K29WNHBnODVj?=
 =?utf-8?B?ZEJjZkQzaXgxcXhoTHBOd0ozTUJrUEt5ZGFOTDhNN3hmTU9WeUhrN3Qya0dn?=
 =?utf-8?B?QkNDbTVYcU5naXphdk1Oa1hsendFdlM4QWVIYmN1NVIrQXlkRXd5bFFxdk5L?=
 =?utf-8?B?cUd6MUc4NXpzamRzTlFaSy82WXBFS3NsM3o2UENoQkc3dWdnSFk2czlTdTBR?=
 =?utf-8?B?MHFsRS9xWjYwKzNzWXRnanJwM0ZaZW9FNWNqK3g4Sm1ybXNGdUlWWERKMW44?=
 =?utf-8?B?Nkp1bGFobUFPU0dmbzBnSjdvbXA4REUwUG1pN3JuMG1OeUY0QTcxUitKUU0y?=
 =?utf-8?B?dmVJS0FFUVJ6cTV5ZDVjemNmeU9PTzIyamorc045dCtGTFQ3NmFRVi9nZHg0?=
 =?utf-8?B?UmkzbTNLdkZqMHBPNk1SdkdOTGYrRllBSUdZV1RDcGxNeXZaVXVWcXZ5R3J4?=
 =?utf-8?B?UWcwby9tNHp5QThEdGRzWGl4bUNqak1yU05saU1MWjZ4b3YwSzYxV28xd2Z3?=
 =?utf-8?B?bEpBT3owb2o0ait5bFZpck1KQnpMQTE1VVRDV1VId1ZBUGp0L29mRnBaNmlp?=
 =?utf-8?B?cUVQMDN2NmhIb0FsbjdUd2RIUFl0Skdjc2RpV1V4T0Nqb0RxOU9tZlVvZmdZ?=
 =?utf-8?B?MDU2TExGRVpXaUd5RUEzRVZpR25vWDhycDlVWk85QlpYVGMwSmRJdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a0e6fc-7fe8-4693-2c70-08da2ec4f14f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 18:27:43.5486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8aKRgBKw7WDavuRFRLCp4+EwotpB0pLkEyRrfNpfgTK+vB1ez0fDUVRFle8RO01oXo3+sz5GLIGfvuq1W62GLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6331
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

On 2022-05-05 16:48, David Laight wrote:
> From: Maxim Mikityanskiy
>> Sent: 05 May 2022 13:40
>>
>> On 2022-05-04 12:49, David Laight wrote:
>>>>> If you declare the union on the stack in the callers, and pass by value
>>>>> - is the compiler not going to be clever enough to still DDRT?
>>>>
>>>> Ah, OK, it should do the thing. I thought you wanted me to ditch the
>>>> union altogether.
>>>
>>> Some architectures always pass struct/union by address.
>>> Which is probably not what you had in mind.
>>
>> Do you have any specific architecture in mind? I couldn't find any
>> information that it happens anywhere, x86_64 ABI [1] (pages 20-21)
>> aligns with my expectations, and my common sense can't explain why would
>> some architectures do what you say.
>>
>> In C, when the caller passes a struct as a parameter, the callee can
>> freely modify it. If the compiler silently replaced it with a pointer,
>> the callee would corrupt the caller's local variable, so such approach
>> requires the caller to make an extra copy.
> 
> Yes, that is what happens.

I did a quick experiment with gcc 9 on m68k and i386, and it doesn't 
confirm what you claim.

#include <stdint.h>
#include <stdio.h>

union test {
         uint32_t x;
         uint32_t *y;
};

void func1(void *ptr, union test t)
{
         if (ptr) {
                 printf("%p %u\n", ptr, t.x);
         } else {
                 printf("%u\n", *t.y);
         }
}

void func2(void *ptr, uint32_t *y)
{
         if (ptr) {
                 printf("%p %u\n", ptr, (uint32_t)y);
         } else {
                 printf("%u\n", *y);
         }
}

gcc -S test.c -fno-strict-aliasing -o -

I believe this minimal example reflects well enough what happens in my 
code. The assembly generated for func1 and func2 are identical. In both 
cases the second parameter is passed on the stack by value, not by pointer.

>> Making an extra copy on the
>> stack and passing a pointer doesn't make any sense to me if you can just
>> make a copy on the stack (or to a register) and call it a parameter.
>>
>> If you know any specific architecture supported by Linux that passes all
>> unions by a pointer, could you please point me to it? Maybe I'm missing
>> something in my logic, and a real-world example will explain things, but
>> at the moment it sounds unrealistic to me.
> 
> Look at any old architecture, m68k almost certainly passes all structures
> by address.
> i386 would - but I think the 'regparm' option includes passing small
> structures by value.

i386 passes all parameters on the stack by default, and regparm makes 
some parameters be passed in registers instead of the stack, but it 
doesn't have any other weird effects. The value passed is the same in 
both cases, the only difference is registers vs stack.

> I think sparc32 used to, but that might have changed in the last 30 years.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

