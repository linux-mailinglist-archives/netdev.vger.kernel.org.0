Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C084D9A9D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348018AbiCOLtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348003AbiCOLti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:49:38 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2105.outbound.protection.outlook.com [40.107.117.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E395E27FFB;
        Tue, 15 Mar 2022 04:48:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/Q2CL1goNiMHYQjSm+wlz+HJrS9rlQXN+25t5gXBlkY0gxwhl91MoXDYQBOvO5L6ex8Lw8GlkjcPpqUuwZIQAJisFYZNfWjbk/yPLpFZLu2cDZAhcnq3BiAALRUwRM7pDdTSCjc8Og8Wq+wFCjwDTqpHScSrSu48y44gq/G6gQROENMDbuZkuaTjDUSNbK6qnLSR/5+l5X5xlMkZsTrYuXMWneWVfUpM6KYK4GUe8450f16zBuQlf/Tc1HAlPGKdfbax1wyUAelEq8IiC2tx71I7W5Yr0fN08haNR9cbQWwVC8OQhRcvkUhoBR3PVmJuHHs7LrhyhSSNf1WVVNLjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6f+9E7eRrCZtFl/R5Tz1jC7D1JwV64nyOwPidDWEu4=;
 b=ftTra4rOlQd5QxgRuMsJxpJgxSOA3jPhE4sVJLpYyWa3nF7qtYR8j5INB4KSjWqf4U05U3XbfARe8ZOj0IroQmRGZ+v4RYWPvc2ewHrjJpeVn/ec+iyoJ5onB0FBbclRPV95vIRSH12SuDqAevutQI6+Zxo8b04iqCYjpGgdxexAmCRl02i5hymBz4SZbTkk3g0IyNkHs49JlbxGFRqyYN/50Oev/tGHOA7s6SWV47U8/YKhaBBRZlNZu4wppxTVi6bj+qiO4dUpxdcdV61SXG+X1wUKnxuOZFfPJU9/fq+9g7UcUHEechiLu7q+YAUwB7oM8275RHwa0d1CkSDV+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6f+9E7eRrCZtFl/R5Tz1jC7D1JwV64nyOwPidDWEu4=;
 b=PV4MKdJ0QyNf9waGbX0XgPvBzSpbpNxEisD3kAbEZLoqnM1l457D1rdBgcARoq5JivZQNeh9BnRz6q4ILYkuF7E7RU4QWtvQU8kHsT1Ym0nnKUwZILySN8fId1JuNHKh78A6zXcKXqOGLXc5+VRZyHK3CIer2V8tNciaXUzrbWk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SG2PR06MB3498.apcprd06.prod.outlook.com (2603:1096:4:a1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Tue, 15 Mar
 2022 11:48:21 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 11:48:21 +0000
Message-ID: <9aa7d222-57ff-ad0c-7094-a3ee160ddb83@vivo.com>
Date:   Tue, 15 Mar 2022 19:48:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] selftests/bpf: fix array_size.cocci warning
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Christy Lee <christylee@fb.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Delyan Kratunov <delyank@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "zhengkui_guo@outlook.com" <zhengkui_guo@outlook.com>
References: <b01130f4-0f9c-9fe4-639b-0dcece4ca09a@iogearbox.net>
 <20220309033518.1743-1-guozhengkui@vivo.com>
 <CAEf4BzY0F3g8oH7+u14DTs707STVSCi8j=A5_S=hn6VRXHzzXg@mail.gmail.com>
From:   Guo Zhengkui <guozhengkui@vivo.com>
In-Reply-To: <CAEf4BzY0F3g8oH7+u14DTs707STVSCi8j=A5_S=hn6VRXHzzXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR04CA0059.apcprd04.prod.outlook.com
 (2603:1096:202:14::27) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2290d22-24d8-4c80-c50a-08da0679b403
X-MS-TrafficTypeDiagnostic: SG2PR06MB3498:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB3498DACE22868AF4BCDA4C51C7109@SG2PR06MB3498.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: McsambJ2gglT6krcxHE1Cx8HzodAQ1RVtvhF3xNHa9EzaqyIxoypjNpvvh48xGcdmKsLHvIf+XXP6KvSoN7scnayOuiJNGHXY/PAZbI6Fdmxv6q0GhugpgeBnBKzYCLX90HJpjrin3pChUmdqAvJmqdlvMhbidUg1Cy5SUbyCYgig2JHCPMmfRzm5pUa4A+R54qoOkyJS/4yj4/SWFsLyciVTZ6/7oqRR0w5w+JTXdLTCnMdNAipChTQG4cCMtm8Aa+WqITpdivcLRyxGzJlxeXJrUB/q8hsYOkXRzcJ7+5/abvqJDsy6jevDtbEXpcz7Pe2pbGx9elONRE0r/Tl7EbD4j6SkHkwLfQR9tFOFjCo+sgtWJzJA5c6yvqnYi6D3wIQdinGZ7PmF4Jy+Eal0iU/qDPQzdjI+lMZfFW1f5g1M9CD2Bg1C7YSdyfJhv4QT3A2rkzzmtrB/mYv3mynBqGNqM1jT4Jsu6W0A9/YGs5XZyXvwxJxBgBLwO10ZEunepIDdPKnBxQdJSEfMlT6kbpcJeELf7Y+nC57RGAHoi+18YxCgY25GI7yJe7jeHr9Fx7h7wtgAoXfmUaONd4v4KtUuSuA0KuwbjSvzH2paGEBM4SdvUVF9zxYTs/f6h7dogBqhbUV/FPAUu2gWgYzP5gDBkclnEjFd1A26YJfqUJxldxR4A8ZCL7pR8t+Z/HzWaT68UlGu8q0IhL8yP0t+1oFLWlyaF/fT3TzCagz+cSp/hz4ohRjTT5K6aWO3Lgwnvx9T99uBtmRDoAQ0kGExg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6486002)(31696002)(316002)(36756003)(4326008)(54906003)(508600001)(86362001)(6916009)(53546011)(8676002)(52116002)(6512007)(31686004)(6506007)(38350700002)(38100700002)(26005)(5660300002)(2906002)(66946007)(66476007)(66556008)(2616005)(83380400001)(7416002)(8936002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjdBcmYzd0YwRk56Z24zUVBkNXl1SFh1dm5yU2lFaGhIRGErRzVOaXprdjh2?=
 =?utf-8?B?VVAzejlyTy81end4TXcvWmxzaE5qWHBBSk9uZUQ5L2ZsMVRBMXJrejVsME9t?=
 =?utf-8?B?R3RwVDFjV3VheGVNR2YwWFhreXhabXNCVmVtYnM3c1BRRzF6SHRKc2FqME1W?=
 =?utf-8?B?MUh4OVdFMUVOMStRNnA2Y2pucEg2U3BWVjFPTEJWOWdwSjVXZ2Y1MEVINmM4?=
 =?utf-8?B?bnU0dnhTV0NUMzNlNEY1ZzlRdnFuY1pIL012U2RuSTFXNHpZMXhQRitCb2N5?=
 =?utf-8?B?cFowRmZrRk9BdFE0eHB0enpIeU1ob3ExTVA2dzk4dVpjUURTMy9jSDN4VVFu?=
 =?utf-8?B?UWNsdDZhS1AybnppSi9lcmdhTXgyaDBUWi8rWHprNzI0NGFzV081eS9ITmQ1?=
 =?utf-8?B?OXdvSlF5OGRCalEvNmkwLzB4RTA5UHpMeHNwRTVLT21TOWRKT1V6Z21LRGlW?=
 =?utf-8?B?RmJtSU9JRndhZWlteHRZWXFzOTJkcDVYcGxmUUNCajZxNjhBendMMWpoOEpz?=
 =?utf-8?B?eDBqbTR4RTAzK1NJMG82N3JUYjkvRTZ4ZllaaHlzdEh0UU84ZE4zdHNDay9Q?=
 =?utf-8?B?eWE0SWQ1TVZaR0szTUtuR2pMODBNcGRYNUdnaWlCWTFmS08vQlp1MUNKVDVH?=
 =?utf-8?B?eTlvbzd4S1E4QWhBM2ZCeUtBajk2S0pmQkhqSGs1bWdWUjhhb3BDYUdvNXVH?=
 =?utf-8?B?eTd6RWVLZXpnbHV6cW1Ob3lUVzhJcFk2OVU5QWNxWlNNdXBEejJCT0RCQ3hG?=
 =?utf-8?B?NzBOREZJQ0JNRDdtRVFndm15c05hNWxobE9lM3RFb3BPSkJLTFJCZS9tQXA1?=
 =?utf-8?B?a3dxQlNiMUZSWnZzTlpvWHRDNnlqRStDeHR5bGZ5UDR4V3RWSHlHZWZZUHJv?=
 =?utf-8?B?UUVrZU1KVzdDRUtOZDNnUS91OHI0WVpWZUhXWnFjNTM0ZnpvZzFiV2dCSzJH?=
 =?utf-8?B?TFIrNUZQcUdoZGhRQUVheDFmQWkyQll1VDUvZXZUcXFNT0k0cFhwMHNSZ0xT?=
 =?utf-8?B?Y3pHUHpCZ0hla3JSSTY4cnRKVW1vaW9YTERleFZNam5PSnZKWkt1cVlzVHA3?=
 =?utf-8?B?MEdnVGY5OGRzU0NSUmZmTXlPT3NmZmpuSEdhZDJ1dGc1b09FQW8wTlo2ZWg2?=
 =?utf-8?B?K3JIaU5HMzJ6N3BTMW9Xak1LeG1XbEIwWjNqaWNnV2lJOWZRM2cxcnhiakIr?=
 =?utf-8?B?VVVqQTcvU1BEdGZETU1reVl1VUkwT1QwVzlNR3QraW0xYzRNVlNGSE5TZWFR?=
 =?utf-8?B?ZU9tbER6anhzQ1BiazNhTHhwZzJhSXV4Q2VaZ2w3OEVWSFRPeHozQ3Q3a2ZO?=
 =?utf-8?B?dDZXV0NzejBpdkpDd1FzbGxuR1FsQks5Zkh1M3poR1htK3gzcTVVQjhmWEZz?=
 =?utf-8?B?bCtHSjlydVR3RitKbWFEeGtKUlhYRnZuSW1GZTNFUjNjN21odHJNVTlTcUts?=
 =?utf-8?B?OU5FZmpPZGtNOFU0cVNxRTJ4aWJWUmRYSFBPNEJsMDhVZDdCWmlxOTNVbUJD?=
 =?utf-8?B?K1M5Sm9nUEovTldKeGNhbndHYWNkWTQwcUs3R2JXNDV1L3AzVENPaXVwWFcz?=
 =?utf-8?B?ZnhwMDdmd2ZzZHhXYmQyWHFBcUZNOS9rN1hSNUFOY3pSa2hzQ0QwamdYVldZ?=
 =?utf-8?B?M05lelhmblNKT0QyOG0zRjZxeW9UUmk0bVdCR0ltMk15WGo3WVNRMmh2SXM4?=
 =?utf-8?B?VW42YUZGVkYvQWpac1FTdE0zNVJ6OFg2eW0rRy9pU0RDb1ZUNHoxT1kxKytW?=
 =?utf-8?B?ZGRkRUh3TDRzRDkzbWUzNjFVYmN5U3Y1aW1Vc2Z2cXVnM21DcHY4V2lqcmw3?=
 =?utf-8?B?MWl2UzNvNFBqdnFoLzhkTEtVaHlQU1JYNTV3NXJ0M2I0T0ZCbFc5SG03ZUlv?=
 =?utf-8?B?N2VkdklsUjBmS2hlQ0xCUnJ2S0ZSaVcrd2pGNkhUZ2VxWFF4Z1Zsai9ZK2RX?=
 =?utf-8?Q?lDA8lAjMLNhIUnaHM3rrMOmtx6VA+eG3?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2290d22-24d8-4c80-c50a-08da0679b403
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 11:48:21.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzKohw5hI7NdSVgQYdMqBI5u2BIKavCIRyTM8FwDeourqwGsxApvMzS3y35YRbpu7Ykev+vRp4VAt5Ak7JVzOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3498
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/3/12 2:38, Andrii Nakryiko wrote:
> On Tue, Mar 8, 2022 at 7:36 PM Guo Zhengkui <guozhengkui@vivo.com> wrote:
>>
>> Fix the array_size.cocci warning in tools/testing/selftests/bpf/
>>
>> Use `ARRAY_SIZE(arr)` in bpf_util.h instead of forms like
>> `sizeof(arr)/sizeof(arr[0])`.
>>
>> Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
>> ---
>>   .../selftests/bpf/prog_tests/cgroup_attach_autodetach.c     | 2 +-
>>   .../testing/selftests/bpf/prog_tests/cgroup_attach_multi.c  | 2 +-
>>   .../selftests/bpf/prog_tests/cgroup_attach_override.c       | 2 +-
>>   tools/testing/selftests/bpf/prog_tests/global_data.c        | 6 +++---
>>   tools/testing/selftests/bpf/prog_tests/obj_name.c           | 2 +-
>>   tools/testing/selftests/bpf/progs/syscall.c                 | 3 ++-
>>   tools/testing/selftests/bpf/progs/test_rdonly_maps.c        | 3 ++-
>>   tools/testing/selftests/bpf/test_cgroup_storage.c           | 2 +-
>>   tools/testing/selftests/bpf/test_lru_map.c                  | 4 ++--
>>   tools/testing/selftests/bpf/test_sock_addr.c                | 6 +++---
>>   tools/testing/selftests/bpf/test_sockmap.c                  | 4 ++--
>>   11 files changed, 19 insertions(+), 17 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
>> index fc8e8a34a3db..a500f2c15970 100644
>> --- a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
>> +++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
>> @@ -3,6 +3,7 @@
>>
>>   #include <linux/ptrace.h>
>>   #include <linux/bpf.h>
>> +#include <bpf_util.h>
> 
> bpf_util.h isn't supposed to be included from BPF source code side. Is
> this ARRAY_SIZE() use so important for BPF programs? Maybe just leave
> existing code under progs/*.c as is?

I think so. Just leave progs/*.c unchanged. I'll commit PATCH v3.

> 
>>   #include <bpf/bpf_helpers.h>
>>
>>   const struct {
>> @@ -64,7 +65,7 @@ int full_loop(struct pt_regs *ctx)
>>   {
>>          /* prevent compiler to optimize everything out */
>>          unsigned * volatile p = (void *)&rdonly_values.a;
>> -       int i = sizeof(rdonly_values.a) / sizeof(rdonly_values.a[0]);
>> +       int i = ARRAY_SIZE(rdonly_values.a);
>>          unsigned iters = 0, sum = 0;
>>
>>          /* validate verifier can allow full loop as well */
> 
> [...]

Zhengkui
