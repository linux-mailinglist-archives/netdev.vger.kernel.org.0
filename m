Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2FA369886
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243123AbhDWRgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:36:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41766 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231400AbhDWRf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:35:58 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NHYpDS029852;
        Fri, 23 Apr 2021 10:35:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cMmB9Brbro31+m9HUol4Jnz0Dr8r7VjbBa75sKdbSgQ=;
 b=nAExWEgzTxfZAbF4ExMgR4AMlb1N/uipoKBRbqlLFE+Y1YrykCenWfBiajM0ctKn7uUN
 H7yNGjZSxjib+lO4w23uq4bkWW0AXBtCp5kaGkLvFsdtTzSuE0MbYXOxicPZiXrS+Y0e
 W3Cqjd1ZZGhzosIXRxUOVkX4uqsKjFZVV6U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3839usrcsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 10:35:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 10:35:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYTb19BOoAuwVV5s2V/8GiOIdisA7ddtcKo0tbQ3gxLeC2ydrT5gxKvldr0K+hDWFo00l0gKn6tvBrIr4dFVcGK+PLxfZ7RhdcsdXyEHk9IBXDkXcAlH15cfDnAxIQ0aQ6ZPDC9HeeLZzOVoIDWcPTyTO4aIYwFt2aCdqgG4OLMkdpWtPV+D7Cc6ArWnBUXckGca5AfX4etEVaVvgqg5y74ffzqTaGLOFa9lO417q+/TeEzGioNmTZPYFhGEOaXm/6fZN8WZMS00VWNj11ivH6ou9AvNtNhtQjMxbyy/8uJBrYvgaWoJW1SkBavFH8COk3ytUR3pX0Nbr14dIYB5xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMmB9Brbro31+m9HUol4Jnz0Dr8r7VjbBa75sKdbSgQ=;
 b=ZNE3SMSp5uZzOlnjo6Nd8Qq+ZmYJcEiCuc3SUSmxF7fJmCaHgc43sQ4t6jKQVF9UmxTFo7hDAmShTi23GjvQFZhZRLc8/J2i/v6WeYU963YBA+gLdj+SF+bbHUBwaVbH0P4tbmjPRVSs8HlcrpK91uBAJXOyhWxh7ZfA4DU+ZQxtDjmKxfAE0lnRhUCZMUteCajSQTYPhQxvr0vPboHD5ZLaFUd+yu1CrvwJ9Pjqg4rFVYWzL1BqseWxYDiyen2BZQcQmCAllIr1D/JW84OshbNeYO6XuzEsqXhFqwtAA9iJzigs7SiyNhaUVPHkGqMFkZo8Hjr01kPnfGmcN6mZ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4658.namprd15.prod.outlook.com (2603:10b6:806:19d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 17:35:06 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 17:35:06 +0000
Subject: Re: [PATCH v2 bpf-next 15/17] selftests/bpf: add function linking
 selftest
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210416202404.3443623-1-andrii@kernel.org>
 <20210416202404.3443623-16-andrii@kernel.org>
 <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com>
 <CAEf4BzasVszkBCA0Ra2NsU+0ixoR65khF2E6h7CG_P3FOyamFQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b49042fc-0af8-11f4-4316-39b0d6f0e6e4@fb.com>
Date:   Fri, 23 Apr 2021 10:35:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzasVszkBCA0Ra2NsU+0ixoR65khF2E6h7CG_P3FOyamFQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11)
 To SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 17:35:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2eb90c80-b2ad-4e53-a67c-08d9067e228e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4658:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB46585BD90E7B10AAA2AE2910D3459@SA1PR15MB4658.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZS0CLPEBeMt7cFPcycEQD9pqfilbs3/tR364WKxxmwGu7lV1MuRsZTHfxCWKpj5fb3/qLQVFIm2LZ7KYBTyYudJMdvP2Juxx/uOcMFRV3sKVCa0pEINu3PyIBuTipcRqdWkChLoT4Vh3GnrHRHP1PYYR8DZTFwz9s53nbze7qUsmWehCDuHkFB+OAG1Vhp8I6cETATSyGJwc2jD4BS5GNPtRTJkAVkt2jQUfHkkuQAQ3xLg2yLKTexGvsuoX4KTYK/6+I3xzN9Ypzc2wnyFpOFphc7NgilAs0new+XF+F3/aD0zi/IBSNABMf/eiL+AZkw1IBiMTI1nVG6GEdQx9Itr+SUlW7IUM7EdkCQBMK3ZcN9Z/SPKvEW1rX+o+V1TzCGfMmmgQmeBxzhrC0o3FGUAyJllw4Pcv+T6q3MUTGp3gyO2TicLyZF57NtpoaxUk2H0MYGqUqwRKlxG/o52aC77f9AOjzEBKgW4c79XGdttXrd8tC+m9TP8XgHi1FF7K46GBWLwfbkxbd077bfssgHOSWgM3lUTxTQ9YhZtx1RpAU71JK7c6YIIkpFtAWnDA1teVR10gDNZ4vUp8FvopmXs/Cf+39pDTdkBJh686dllEX83wicW8HhbX15srSoVgbV4b4ws/j0S0EOZRTCQfrKZSRmvIGzgvkk6AfIOtg5/xCvaTowzkb4imagaJ6v0i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(186003)(36756003)(5660300002)(31696002)(86362001)(16526019)(38100700002)(2906002)(31686004)(6666004)(8676002)(53546011)(83380400001)(4326008)(6916009)(52116002)(66476007)(54906003)(316002)(478600001)(66946007)(2616005)(8936002)(66556008)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?citCU29CZ2pEeSt0WFI1aHRNRWdkMFVYK1k0NnRCOWpXYTRPcVZOb0dkdXJk?=
 =?utf-8?B?RDVrMU1WYTZ3eU1VbkRNUWZDakI0dTE2MlJ4ZzRXcldhR3ZYa3lJVnNzTVJ1?=
 =?utf-8?B?d29WRkNEdVM1WkZqMWRpeHppYU03YTFSSHk5Rm1hMkhzTDA3NHd0VzBDbkdC?=
 =?utf-8?B?bmpScjBlTUtUMlQyUEJ5QmZYT0RuZGMwV1hZdXBvMmtqalRZTzZ1RVJxem5t?=
 =?utf-8?B?Y2QwWWx0aTBDc1BLQ3pNL0tnYm1QSUdKclhSSnl3LzNDTlhGZkJoOEdJK2NE?=
 =?utf-8?B?RnVGQnpzUWNDY3FyQWs5bmdobm0zMVV0R3J5K2w3NEEwK2h4eXdDMFhQNmFr?=
 =?utf-8?B?MGlYWnNVRFZIVkVDTGhROGh4UzczVEZ4TXJnWnJBRTZOS0FiQlMvUEZyM09p?=
 =?utf-8?B?am5meGxZam90TEtlZ0YvM3pnMWROZ05QSlE4RVVnaE1FeG40QmoxRkk0aUhG?=
 =?utf-8?B?U3FZN3VqaDNtVFAwNy84N1lKTDVkaTZlTm95R2NocEJlMXNFTmh6UGlVN2JH?=
 =?utf-8?B?bUNtNlJLU0dWTW12bzkwWnRpOW1DUWV2S25lYUtxUEc0OElKTnFDeERNK0w0?=
 =?utf-8?B?SFFjTElYV1lmSmtoQm9YUUpwTlRqa3lpNEVkeXpoWHE4RW9JUEhXNnA1bDJh?=
 =?utf-8?B?eWw3VVdMRHAwSWtaVW9JTy9mTTB5ZUhMcFhwQWJvZmQyK3pYTTQ1SDRaY2Vy?=
 =?utf-8?B?dFp6c1VhZUFZTFRzUUZjN25LNVJFT1BZVExLa01CaktaMURPNWlSSWVRZjM2?=
 =?utf-8?B?WEJlQUJyM3FpaUZpSTB4cjNET1NacWk3MzhHcDVFd3V5dXU0aWNKRzY4R3lX?=
 =?utf-8?B?ZFptVXZSQzdYbGZ1cTA0alF1WHMwVGU4bmREaTVxS1BWaEx5UGJSQ0JnUVg5?=
 =?utf-8?B?WnF5cmd4d3pBaUlXdzc0Y2w3YWhvVlY0QnN0WStGYmcxM054eXh0OXBZRjRh?=
 =?utf-8?B?TGl0VEJsV0c1VmFKakZxN0tidThWWDkxNjR1dGVPak4xQ3J0VmM4bmVxbjhq?=
 =?utf-8?B?K3FGVlRNNWtTWmtJWXBITkJXMUdEc0ZvR09STjZvczFwamRDQWpkVm0rNmU5?=
 =?utf-8?B?dmVUYTZVTzNyVFk4SGEyNUhTSzczRndCa0xiZFpFWElnNTRxREYvMjlhNEFr?=
 =?utf-8?B?SE5IL2laOHhhN1NHZENFbFhDS0JPOGIxYWsxdUREaG1yYnEvT2M5MDBuTUI4?=
 =?utf-8?B?aEhCT0k3NTJsQTYyMVRJK0phWFV2TFlzc0VuVHRTU2R1OFdHdW9YM0t6N2U2?=
 =?utf-8?B?NlJLclF5VklKdFpUTlArcXdJblZDVk1MU3UwVWorSzZWOUVLdFVFVmxuKzNF?=
 =?utf-8?B?eWVPc1ZYYUNpbnNLQkYwQnpQVHl5Tm43NUdZK3hra3BTVlV4UGo5YTZYa0xI?=
 =?utf-8?B?Z0lBaktqZVU5UURmV3Q3VGFYbHVjcmFsd2RROWtJK3ZENHV1Sk1CY1pvZzRm?=
 =?utf-8?B?bCtScXlWSXNrL1VQZ2ErQklGZTdVS08wUjFZc2lqL3FIR3d5SXVEUkxieG9N?=
 =?utf-8?B?alRHeFN4Ry9JT1UrT1p6ZUpZZkgzT0xWUk1RdmJxb3lqMmpVKzRsR1dvTHNP?=
 =?utf-8?B?dXlpcGh4eEVkcnozaW14NW9qd2NEMGhnTVhIbHdWcDVmc3pHTFRGYW4zLzQw?=
 =?utf-8?B?V1R5S0RvcWxQZmtaeWEvcFI5L1pTOFpIYUZLc014UUhaS1B4QmhQOGMxMGU4?=
 =?utf-8?B?QmFmR21hZGpMaXU3V1JPMy91R0lyMUcvTzF5b2tqUmtDeUZLTEJwUHVwcnBK?=
 =?utf-8?B?aVhBbFRUNVhybWpNeW1yZjZsR0pXOVhDUWhBVm9LRVZuaTcxSTNYZklKSlpQ?=
 =?utf-8?Q?egTGk+cB0QIZe16VmRCveIcZl95Z9Ea8Jcfig=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb90c80-b2ad-4e53-a67c-08d9067e228e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 17:35:06.6714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9DzAHym2PB3H3DJbv7ll0tGzgG3Rr6PrakHbUh4Y85yHxe2fbOf5WYn+N5KDMR/I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4658
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ELBrwXzbuTP6azRpVVcgKO9LoXS2nVnq
X-Proofpoint-ORIG-GUID: ELBrwXzbuTP6azRpVVcgKO9LoXS2nVnq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 10:18 AM, Andrii Nakryiko wrote:
> On Thu, Apr 22, 2021 at 5:50 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
>>> Add selftest validating various aspects of statically linking functions:
>>>     - no conflicts and correct resolution for name-conflicting static funcs;
>>>     - correct resolution of extern functions;
>>>     - correct handling of weak functions, both resolution itself and libbpf's
>>>       handling of unused weak function that "lost" (it leaves gaps in code with
>>>       no ELF symbols);
>>>     - correct handling of hidden visibility to turn global function into
>>>       "static" for the purpose of BPF verification.
>>>
>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>
>> Ack with a small nit below.
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
>>
>>> ---
>>>    tools/testing/selftests/bpf/Makefile          |  3 +-
>>>    .../selftests/bpf/prog_tests/linked_funcs.c   | 42 +++++++++++
>>>    .../selftests/bpf/progs/linked_funcs1.c       | 73 +++++++++++++++++++
>>>    .../selftests/bpf/progs/linked_funcs2.c       | 73 +++++++++++++++++++
>>>    4 files changed, 190 insertions(+), 1 deletion(-)
>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>>>    create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
>>>    create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
>>>
>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>>> index 666b462c1218..427ccfec1a6a 100644
>>> --- a/tools/testing/selftests/bpf/Makefile
>>> +++ b/tools/testing/selftests/bpf/Makefile
>>> @@ -308,9 +308,10 @@ endef
>>>
>>>    SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
>>>
>>> -LINKED_SKELS := test_static_linked.skel.h
>>> +LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
>>>
>>>    test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
>>> +linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
>>>
>>>    LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/linked_funcs.c b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>>> new file mode 100644
>>> index 000000000000..03bf8ef131ce
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>>> @@ -0,0 +1,42 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (c) 2021 Facebook */
>>> +
>>> +#include <test_progs.h>
>>> +#include <sys/syscall.h>
>>> +#include "linked_funcs.skel.h"
>>> +
>>> +void test_linked_funcs(void)
>>> +{
>>> +     int err;
>>> +     struct linked_funcs *skel;
>>> +
>>> +     skel = linked_funcs__open();
>>> +     if (!ASSERT_OK_PTR(skel, "skel_open"))
>>> +             return;
>>> +
>>> +     skel->rodata->my_tid = syscall(SYS_gettid);
>>> +     skel->rodata->syscall_id = SYS_getpgid;
>>> +
>>> +     err = linked_funcs__load(skel);
>>> +     if (!ASSERT_OK(err, "skel_load"))
>>> +             goto cleanup;
>>> +
>>> +     err = linked_funcs__attach(skel);
>>> +     if (!ASSERT_OK(err, "skel_attach"))
>>> +             goto cleanup;
>>> +
>>> +     /* trigger */
>>> +     syscall(SYS_getpgid);
>>> +
>>> +     ASSERT_EQ(skel->bss->output_val1, 2000 + 2000, "output_val1");
>>> +     ASSERT_EQ(skel->bss->output_ctx1, SYS_getpgid, "output_ctx1");
>>> +     ASSERT_EQ(skel->bss->output_weak1, 42, "output_weak1");
>>> +
>>> +     ASSERT_EQ(skel->bss->output_val2, 2 * 1000 + 2 * (2 * 1000), "output_val2");
>>> +     ASSERT_EQ(skel->bss->output_ctx2, SYS_getpgid, "output_ctx2");
>>> +     /* output_weak2 should never be updated */
>>> +     ASSERT_EQ(skel->bss->output_weak2, 0, "output_weak2");
>>> +
>>> +cleanup:
>>> +     linked_funcs__destroy(skel);
>>> +}
>>> diff --git a/tools/testing/selftests/bpf/progs/linked_funcs1.c b/tools/testing/selftests/bpf/progs/linked_funcs1.c
>>> new file mode 100644
>>> index 000000000000..cc621d4e4d82
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/bpf/progs/linked_funcs1.c
>>> @@ -0,0 +1,73 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/* Copyright (c) 2021 Facebook */
>>> +
>>> +#include "vmlinux.h"
>>> +#include <bpf/bpf_helpers.h>
>>> +#include <bpf/bpf_tracing.h>
>>> +
>>> +/* weak and shared between two files */
>>> +const volatile int my_tid __weak = 0;
>>> +const volatile long syscall_id __weak = 0;
>>
>> Since the new compiler (llvm13) is recommended for this patch set.
>> We can simplify the above two definition with
>>     int my_tid __weak;
>>     long syscall_id __weak;
>> The same for the other file.
> 
> This is not about old vs new compilers. I wanted to use .rodata
> variables, but I'll switch to .bss, no problem.

I see. You can actually hone one "const volatile ing my_tid __weak = 0" 
and another "long syscall_id __weak". This way, you will be able to
test both .rodata and .bss section.

> 
>>
>> But I am also okay with the current form
>> to *satisfy* llvm10 some people may still use.
>>
>>> +
>>> +int output_val1 = 0;
>>> +int output_ctx1 = 0;
>>> +int output_weak1 = 0;
>>> +
>>> +/* same "subprog" name in all files, but it's ok because they all are static */
>>> +static __noinline int subprog(int x)
>>> +{
>>> +     /* but different formula */
>>> +     return x * 1;
>>> +}
>>> +
>>> +/* Global functions can't be void */
>>> +int set_output_val1(int x)
>>> +{
>>> +     output_val1 = x + subprog(x);
>>> +     return x;
>>> +}
>>> +
>>> +/* This function can't be verified as global, as it assumes raw_tp/sys_enter
>>> + * context and accesses syscall id (second argument). So we mark it as
>>> + * __hidden, so that libbpf will mark it as static in the final object file,
>>> + * right before verifying it in the kernel.
>>> + *
>>> + * But we don't mark it as __hidden here, rather at extern site. __hidden is
>>> + * "contaminating" visibility, so it will get propagated from either extern or
>>> + * actual definition (including from the losing __weak definition).
>>> + */
>>> +void set_output_ctx1(__u64 *ctx)
>>> +{
>>> +     output_ctx1 = ctx[1]; /* long id, same as in BPF_PROG below */
>>> +}
>>> +
>>> +/* this weak instance should win because it's the first one */
>>> +__weak int set_output_weak(int x)
>>> +{
>>> +     output_weak1 = x;
>>> +     return x;
>>> +}
>>> +
>>> +extern int set_output_val2(int x);
>>> +
>>> +/* here we'll force set_output_ctx2() to be __hidden in the final obj file */
>>> +__hidden extern void set_output_ctx2(__u64 *ctx);
>>> +
>> [...]
