Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6014C8D40
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiCAOGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiCAOGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:06:09 -0500
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2179.outbound.protection.outlook.com [40.92.62.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE6940A20;
        Tue,  1 Mar 2022 06:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EE94onjQjaY8yqd9xFwmFfYiv5hTd9wsyi5VDklasl31HkYdaF2g91lygEX4CyAJZ0vCM769UHkklsYzKfzm3YPUySc5WlmCKxiF6Hleyp+XfIkCVqI8dSfPTjAAUggA+zre4V9A5t7jnMKjc6lKnA0Z5S+z9rfmV8n5yjXr4w9mNjYCaKeQNPDiSjs5cprMO1a2o0ZMsu38msuKatrsCjFiA9mjUkXW1xbS4Qq9tJRaVe5darKWTY0B6pv1oWnh/e/DolfRFug4TvRIYutwhebHxLXchPi3Cwqmwz2rf4uS8UvhpysN1D9ijcn9cawG3ql/865IYxAqSnav4gGRUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUjATnKtG+i6xVw/rARDYQGxzb53EVlxVlOsAU2xhyY=;
 b=aAVt+k5Ro0sYK887/t72ExdFV73VEbqQabPXGsaeEY14l1UlLeqK8/HQWabfzFVfn0nIvj/FEgcX8XfO00JUbC2ybw8ZfVdJQ5XqByK4MVLuOYDAbZPVEhzWv2WUG81Kk1t5xtWY348dfYLguHkuD2KOT7FLiCdUYn+XdNPDgJzC2/WRn5so7OkDZY7K31kYsMyDG9ateHtqU9CZnx/rD09r5GAg2hhos11TVBsQz7xKVBddFMCQYpICMzNn9ojt4liVZZzqG9+FLahS3hRLS5RDEW0SWtDqAmgZyAwZFVBUJ8aqP0HGCZ4zipANE+q8a17f2s5/afJw+RfatTF8SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUjATnKtG+i6xVw/rARDYQGxzb53EVlxVlOsAU2xhyY=;
 b=G9FagOLdrJxNNKZsE1pDrhqgFw/Ntx+6eTGA433uL3z06jFSvc8EZ4A7EM+w9Co9eN7ytlZSxx2P+15WA/vM9va42yLQ8NAq8stvM2vQTZObZ/U1gQqr78yyjX4Cajw8Kl1rrxlEosFHlIwOFcC1GP1zVNZmy2MHa+BuAsIVeO9NDBKuEI4DGfpBgP7LRI+giVERYXH5Acdsk1Izb462BLa9GhqhjXYCn6m7A8kIXzGheKXXlyPNJ//OG4DQ+ECLCe5knPHYXZOMRH94k7vcRhA8xlrYWVIUYhLHp1dzklCFQHmUrn1Gj2qlrv3rSf5aR9u0dt7Ncg6UgGk9k97bjg==
Received: from SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:16c::18)
 by SYYP282MB1600.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:7e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 14:05:24 +0000
Received: from SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
 ([fe80::6855:2b32:afdf:7cd0]) by SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
 ([fe80::6855:2b32:afdf:7cd0%4]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 14:05:24 +0000
Subject: Re: [PATCH] tcp: Remove the unused api
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <ME3P282MB3326B9CED47E29DFD3B7B41886019@ME3P282MB3326.AUSP282.PROD.OUTLOOK.COM>
 <CANn89iJ=hehGt4utoiuZD4R7ut6dcfxXLRDJ36N-rfH5u91JLw@mail.gmail.com>
 <CANn89i+_48N62mA63RpNhTtG0hGcv78Arj99jSqLt79+Gi7+rA@mail.gmail.com>
From:   Chen Tao <chentao3@hotmail.com>
Message-ID: <SYZP282MB3331D0404E33E294868C69BC86029@SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM>
Date:   Tue, 1 Mar 2022 22:05:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <CANn89i+_48N62mA63RpNhTtG0hGcv78Arj99jSqLt79+Gi7+rA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TMN:  [GymHwbHo42E11k8hfNX+rWaZ3dB+6s1dI3rvmuGWuXo=]
X-ClientProxiedBy: HK2PR04CA0044.apcprd04.prod.outlook.com
 (2603:1096:202:14::12) To SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:16c::18)
X-Microsoft-Original-Message-ID: <14d68ead-afb1-43e7-2d5e-c3ad9e72277e@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 662a4944-95de-4736-0117-08d9fb8c8804
X-MS-TrafficTypeDiagnostic: SYYP282MB1600:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p2kgeLqPZC/18U7rSVautv6mGPKgAEXRQ7aeXTj796q33WnH122tYrQCqrENjDGXqUzUx5RpbujeeIIlgduBlwySkVQqjsA/F4XWea2PePlJOrzlToGAmjFLyjfzUwbCvFv/GrWW3lcslKGNj94IUG5+YGcsksPXgTEZ/Q646zc3KDlWQE5C+TyNxsQBKufL84h6cffPyWelpxiCAj+2xocZ/RsnUNB0CLtpYy50hqIpTLE0m/GDVik/rtCSKYlOQPK+UIzoGAiM5jbRw0F81JKdQISX1/fD3Jljyy/latEHnNSFUc8Zm342RZAiRJuzVqmoFQHS/Hjf9Bow/sqFbBUs19h3qr9KiXfMcT+d2Zqf3mcrYZju6aUGH8E1/3+y1sCx/Hw6plAGVnYlEiOq3PTGfxEn8Be2jPNDLVnjuiTLILJm8rl9ZdCbA2J9QYWxbHnxOjVFexzTiYRLkT4VzfJmnE8YimG5dQUqz2ocvg+VxzDSouA+5OIlj2+nxYlXR/EnEWJo+EQIb0dHFGgVpxmoyzHTsaR0vLh3/UKTXtbzxSHDet+EiFVunnZzXXHmuducVB6Kkf6O+YlJQj3wfA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVVPN2RQSThxMmRQUXFOR1c1cUF6Y0I1Ky9tRTR6UTVaQnBpTWk0akJYQmlU?=
 =?utf-8?B?ZTBzVFpLYjdYcEx3K2NLenlNVmdvNGFGbTdDRng5MklXSURwTi9naGQyMnIz?=
 =?utf-8?B?VzlkdHdzYXVWYm8zZkt5UlNXZ3VNUTJKRnE5VTFyVklYWUxTcmRialE0cHJw?=
 =?utf-8?B?R2VYR25pRCttNzhjOVVxUjVBOHh6eWFxS282TzFNNk96N0MydVBFL3NFQUdK?=
 =?utf-8?B?eGtycjVkbTJjc2o5RExmenR1cnNsNjdxcDd5bWxia2JUL2JTdDZsdHFPR0pu?=
 =?utf-8?B?UW9nZ0lvVTUxZVRCRWdIcHVobUF6L0Jjd0VZQUVQSjlNR3V5alMxUTJLaXNO?=
 =?utf-8?B?cVBNdHRFRjF4QURrRFVreDF5ZUo5amdhc2NBYjJpTmVxMGEvSnc3MmU0VzVO?=
 =?utf-8?B?bkNjRXhhK0pYbUtZSjB4MVRSaS85Z09nT0xlRGFJRUNJK0NnaUV2bkEwOXBT?=
 =?utf-8?B?Qkp2MVloZUR2cFB2U1NQOGdZd3VGaU5WMGZuMy9saDlURnBCRzUxenVKaTY3?=
 =?utf-8?B?anJ5UEF1TXR4N0JBSmdHU2VRSlp2WWR1V2x2a1RHZ0NLRVJpUzJJZWhsaTRJ?=
 =?utf-8?B?MmNwTjR4RXV6Zy8vQ09VcFNvVSs1c1FOZWJyTFdQOFNpeVdnYmo2emF0RkFD?=
 =?utf-8?B?VmdrQjZ2c1FmYU96WE9zOGtVSGpLRDhzT1ZzVXhXWlBWcWptdTFrTDdHR013?=
 =?utf-8?B?ZkhZcGUzVzk3a3NWYjA5cEVvQlNqcUsxSFVIbUtPeVV1dk5NV3hkd0x3WjFl?=
 =?utf-8?B?ZXMvQ1BBME0zMVJuMkJHZkJkZ3J1L3ZQSVhhTVdONGRPN2hxd0IzOTNLOFBL?=
 =?utf-8?B?Qm1Ya1RjNHp6SE0wUXptNCtaYzdyYlBrbHhVRTRTaWlZMllMOXNGUERSN3hX?=
 =?utf-8?B?Q0tUcmFYNzhHbmhnWTRxYnMyQ1VjR3N5aGhrU1o0QjI5YUNTdCtZZHB5V1da?=
 =?utf-8?B?eFhTUWVCMHI0cFNIRkRkS2hCZ1NyTFZQaTJKdjc1N2JnR3pmNU1JWHB0M25C?=
 =?utf-8?B?YTljbkJmV0RpRUFEYjNOWjR5SE5aMGNUbmZ5WnAxQVlQeHdWRnlmTUp1R0pk?=
 =?utf-8?B?d011RDg5YWYvazJ5S0F0UVc1aWp1NENUTnFLWk15VVZBRE5hS09aUS9BU1Bk?=
 =?utf-8?B?QWNvblRkZmpVWHhyRGN4WXorelVtVDlTbk9iT3pKZ3ZTWCttNGlnLzYwdytK?=
 =?utf-8?B?bGZIb2tPeWE2Vk1kYS91LzN1OG9vamNHTXkzbndOa2tPMUpScjFTbkdXVGtk?=
 =?utf-8?B?TjVYTkZ4WUI3Qnc1bEFEd1VlcGthNUI4YzBkaExsTEIzb0VZQT09?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-746f3.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 662a4944-95de-4736-0117-08d9fb8c8804
X-MS-Exchange-CrossTenant-AuthSource: SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 14:05:24.7311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYYP282MB1600
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will be updated in v2, thanks a lot.

在 2022/3/1 0:08, Eric Dumazet 写道:
> Resend in non HTML mode, sorry for duplicates.
>
>
> On Mon, Feb 28, 2022 at 8:07 AM Eric Dumazet <edumazet@google.com> wrote:
>>
>>
>> On Mon, Feb 28, 2022 at 7:02 AM Chen Tao <chentao3@hotmail.com> wrote:
>>> From: Tao Chen <chentao3@hotmail.com>
>>>
>>> It seems that no one uses the tcp_write_queue_head after the
>>> commit <75c119afe147>, so remove it.
>>
>> Wrong commit, also please use the standardized way of citing commit.
>>
>> Last tcp_write_queue_head() use was removed in commit
>> 114f39feab36 ("tcp: restore autocorking")
>>
>>> Signed-off-by: Tao Chen <chentao3@hotmail.com>
>>> ---
>>>
>> Other than this changelog glitch, the patch is fine, thank you.
>>
