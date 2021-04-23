Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C498F3698C5
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243444AbhDWR7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:59:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243414AbhDWR7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 13:59:33 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13NHvCMg024728;
        Fri, 23 Apr 2021 10:58:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OsyOlUj6gobzYShITbD6g/UIMkuSiUieh2GrL+W9j/o=;
 b=AJS7XJn4PAXO3FJhyJG+euYI8c2VCHgsKYDIwDki0oPN2tgw2RWS5I1CZtSQ6SwVZx3X
 w0XAGin2ufauQ1z0hCFiv0r9sI741WTN/BWJ+dVxCNn4WutbtL+tQnVICL3W+uuuqhP4
 pAyXb4r6LKGrBGTedaeUt00Vu+Rlzf/bmxo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3839vur5ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 10:58:41 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 10:58:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvogjXfipV2ciQr79+OxHcNICffyZgYEf9OMER2kRwd0FmY0+HvkjhW+6COaSM3ZuZKuH9+PZHSwP0PN9J1+JnV9OFL1Wm5SU7IgpN7nSpmrXM8sEt51oSWROBOdL0NQhIZOH+nNtazHUBYOLqwYxZhukrQeNcXjYWuSdWsFoONrVyhNGA7lUMmPh6cTG/Taxnt5HeFUUSZ06Ju+yBg9I+3rT36fqUPQIuBO435ug9fSEn6w7wvN1Yyoym6HpuPp2LrQAT3VfFOkbKBnQwp7adD39atqz78XUA0Dvk1q8Kg+f9k/YeGAysbj4Z+L6MeK459I7xFa22KhcECZKdSeEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsyOlUj6gobzYShITbD6g/UIMkuSiUieh2GrL+W9j/o=;
 b=hg+VK4lFeSoLKOYU8obVGLYZigLEQjlJ61FZHZYSLsiVYQMq0t20CK/WkMa54zQyzOh0mVjOObemEKwt+KdXfTf4xHjgyjMSjkb6jxT3Q63gfBedh4pBcjEgmKeNFGlm7RZ4bGnyuMnCJUY5voj5cP2pMVOZehlU/jHxxoPqmYVIFjjKRfKMJ6qpfnNMAOvOuXtA83VSPhYuw1Sdc3QQ7nh68ZTIuLoLp/plrFTIgQg2Nt9VUXl7hOuz0ylxkqPP0qUNAd1U8Rto5ygUL5fQivHoNvera5tkbwDUjXpvWikFh95pqqkLfGotIrpXfTZUT3AGim43I4IvxPB7laYrFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB5032.namprd15.prod.outlook.com (2603:10b6:806:1db::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 17:58:05 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 17:58:05 +0000
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
 <b49042fc-0af8-11f4-4316-39b0d6f0e6e4@fb.com>
 <CAEf4BzbP+trfjW-_AwcLsmS=79jqXWoRbQJnSH2xkE=MOxN2Gg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <94f367e9-24f0-5ba6-eb8d-2951dee4219a@fb.com>
Date:   Fri, 23 Apr 2021 10:58:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzbP+trfjW-_AwcLsmS=79jqXWoRbQJnSH2xkE=MOxN2Gg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MWHPR19CA0067.namprd19.prod.outlook.com
 (2603:10b6:300:94::29) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MWHPR19CA0067.namprd19.prod.outlook.com (2603:10b6:300:94::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 17:58:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dca94f9b-b7c6-484c-13da-08d90681584a
X-MS-TrafficTypeDiagnostic: SA1PR15MB5032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB5032B1966071C6AA9119BA86D3459@SA1PR15MB5032.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YeZMmRv0tQV4XKrRWYsdMdsZb5GQuE3dlH5zeRpi8KSub6tUNmWeVHze0HgsLMlPzB1vYXjin4dt6rEz8uHq9td2KocDW7AK2vx1OS+tMWrKL5kUQ+b2vQbI+19ItFGlpASXvajdqxVRBxQKLjdcVT0J4PRnO5Kjw2wMYgFO3lLqBsc/JGlvdzKwdqzvrhIJg/rMVHppKMPVpDUI8O3WY/6AiOyFoWtIVS8LoxAoEFrr0UkRyWCKfzc/+6vyxIms3RbIm/+r/+UQMGmEwGymZacZ0FbX71kbbd+k0XC3U4WLUwCs+WyAhKI9Ty06fW1lM0cLd6ORVHm/bbcjVsYK3yWR+rtWB5bXBSREU+RGfcLAZKHDhYxUkAk0enPBnZWXJraqXfrkpnE6pb6hg2UF7KF8acpNW0K7bah5A8qf7CSkpsYU7e3zcOZXXijO+0e6zn5ITGRWLoioPwJgZKzQ5AdnVH28Rsv5Dy6hVTgAgvUiugLcNylAHbR7kjE49YDIMpuZg8rw/HdPMqa3Gi6p9ns73gZg/G4wX5VvOWOxJ2Nm8dIuFF1pPTrT3PD/bRFKjUx6lqju7QWbeYdZShOZkGt7gxHFLuQjvFxneuW7jgCf7fo57iIWG2g+qZv75X0gLUYCgtvz53vD1ToY123wI1VgTBfvEI7/1E1VCa4cgQ5dS2DXUbmH7NiHtbwXoc5y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(498600001)(66476007)(66946007)(8936002)(6916009)(54906003)(66556008)(8676002)(5660300002)(2616005)(6666004)(6486002)(53546011)(4326008)(186003)(16526019)(31696002)(2906002)(36756003)(38100700002)(83380400001)(31686004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZW9TSmVLYnFvbU9tWGt2Z1Z3aE8vVThKeWdPMkcyVC9HdmFEaXVZVmtCVURx?=
 =?utf-8?B?Qm1DYWN5YXgrcGZ5K00zTi9FOHlsUVpzQzZRclJOdE4zdGRNY051QkxsT2xD?=
 =?utf-8?B?dlN5emRmWU9qRUlRRlE0YXRMK0wvbkFZN3NQd2FCdENSKzVTWjVTcDNsdDBH?=
 =?utf-8?B?RUhlOWhHdUtETHllMzVCWnZ1VERCaGN0S01YMHdldk5WTnRYdnhZcGx4Z29W?=
 =?utf-8?B?elp2TE0wRXpJMitKM2NQTU5hMFpoYVBCN2d1TDY3c05NelE4YnVqS3lRYWg1?=
 =?utf-8?B?Z3ZINHBub1hHci9qOTllS2JQdWxYbjJFTmZvU0lIUlluTi9CTkRKUXNsMDEr?=
 =?utf-8?B?K0tLRlM5Z1pSWWlMVFJTYlpqL2txSzhTQng2NEFGVmh0MExUem1ZRTREZy9j?=
 =?utf-8?B?VnVRa1FPS0MzNGxjVjM3YnlaT1RTZ1VXUnQ2c3ZjSGFnRVNOZTRWVGtGVXI4?=
 =?utf-8?B?cVkrV3hpSXUxWncwOHluSTZpemoyalYzMm1ZeVdOYU1mNnZvL3o1QlZtSXJ5?=
 =?utf-8?B?NmpiS0NXOE1HRkNyOThPaG5pZUU1UzVPME9vN3QxWlhMNWtyTEVQYnRBZDJP?=
 =?utf-8?B?S1B1WDdwUndpYks2S0psczcwWnJkd1h6dlhORjdyNVdHVW1WTzRYY0M3L2pw?=
 =?utf-8?B?cEd3VmxvakRDK2N1WmhUVGpzaFdsc1pySFhEU2RyVzBsNkNMUHpXMUVndDNE?=
 =?utf-8?B?TlBHanhTb1dmb3BBZUxUNjRPMk1wVTNKcW9mWmpVd0lRUzlMWU1xN2FqOVZO?=
 =?utf-8?B?aDlycG83MGVtckxCaHlPVGtnYmVybEljaEFFd2VRWHhjbm5XbXhEUnpvbkF1?=
 =?utf-8?B?UWZRRVZpVGFZZFJKaFREUWNZSE43SWZZcXRQVVRwL1dvZ0V2RjdiYXd3UG1t?=
 =?utf-8?B?dzl4Wi9vK0ZhRnNGZ2tua0NzM2tpUTV4ZlhRN3FCWmV1RzdiZUdYYnlqNitD?=
 =?utf-8?B?NEFNY1N5SHNmU2RuRzJQbFlPY2JpRTBJWlhVeGhPS0JMdHdldWtKZThtdjdt?=
 =?utf-8?B?VUF1SzJ1clYrNzhuKzJraGdVU3hDQ3dNWHc3MElVMjZTU3JNS0NMbFh4UFZq?=
 =?utf-8?B?c2NWajdnSUc3VW1tT0htZ0s5dE5ZZGtpU0VvV0lzenNrNmdpa0NKeHhPZUp1?=
 =?utf-8?B?QUJTSWlpVTgzZHRZZGwvUFVDNW9FdXFYVkV0NXh5L0NJemRZdHNlaWprWElq?=
 =?utf-8?B?SXRMZFY5dEIxY29MK211cTN1dUFmVXJoVEhuSHk4MWNXYWpmYkRGMkVucTQy?=
 =?utf-8?B?S1BmY1JFK1hEODM3Zm5xdnNGbThDL1Z0amlGZE1OUzYrdmpmQUE2RFZzNHVE?=
 =?utf-8?B?cWVJK0Q1NFYvWEttcFlMdlRaMVgrVUEyL0NpNkFKcWdjbjc4aTN5YXFrR2k5?=
 =?utf-8?B?aVpzVDhEYms1aWk0ck0wb3pvVDFkR3F1amRNenlXUzBpT05mdVFzaGtBWW5R?=
 =?utf-8?B?ekhxQTE5UThDa0hZK09QQ1NvOHNUOEc4bWMvYy9nUkYzUjlCa2xnejhBck1v?=
 =?utf-8?B?VkV6UEpxKzR3cEtZaEpIZUppNG5KSVlzdy9LU1R2cjhVQmRKVFRhS0FsaDNr?=
 =?utf-8?B?V3plWFNFdWdTTVA1QkVwUVFISmdpRmY5bCtlSzA5cHpGbjUyLzBNRkRFWmlz?=
 =?utf-8?B?RGplNzd5NkVhYzR3RHR3Q2IwRlg5YTJHMDRQK3NqV2dGYnRvR3dNTWVEeGZC?=
 =?utf-8?B?YVRHQ1NIME12aU1HbHd3eS8venFsaE8zL1FaQ3NpMjBhUDRMSmtScXFTMzZj?=
 =?utf-8?B?TVRyQUczSGNlQTR2Q0IwZ1NOZlQ2V2NoZVRQMDhSMzdSNThBY0NqSWFrRFhW?=
 =?utf-8?Q?mFSlpYAf8TAFnWoed+g2NVPeMaga95INsokrE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dca94f9b-b7c6-484c-13da-08d90681584a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 17:58:05.2332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUBzShE6jLEC7k/kfJQTMk7JktMnDz2ICb89D8m6e2tFOIwFB+mu93Cbv59jR4Ap
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5032
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: xOoSHs0GpmfV6oCS0iC5D_E0AZVCCalT
X-Proofpoint-GUID: xOoSHs0GpmfV6oCS0iC5D_E0AZVCCalT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 suspectscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 10:55 AM, Andrii Nakryiko wrote:
> On Fri, Apr 23, 2021 at 10:35 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/23/21 10:18 AM, Andrii Nakryiko wrote:
>>> On Thu, Apr 22, 2021 at 5:50 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>>
>>>>
>>>> On 4/16/21 1:24 PM, Andrii Nakryiko wrote:
>>>>> Add selftest validating various aspects of statically linking functions:
>>>>>      - no conflicts and correct resolution for name-conflicting static funcs;
>>>>>      - correct resolution of extern functions;
>>>>>      - correct handling of weak functions, both resolution itself and libbpf's
>>>>>        handling of unused weak function that "lost" (it leaves gaps in code with
>>>>>        no ELF symbols);
>>>>>      - correct handling of hidden visibility to turn global function into
>>>>>        "static" for the purpose of BPF verification.
>>>>>
>>>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>>>>
>>>> Ack with a small nit below.
>>>>
>>>> Acked-by: Yonghong Song <yhs@fb.com>
>>>>
>>>>> ---
>>>>>     tools/testing/selftests/bpf/Makefile          |  3 +-
>>>>>     .../selftests/bpf/prog_tests/linked_funcs.c   | 42 +++++++++++
>>>>>     .../selftests/bpf/progs/linked_funcs1.c       | 73 +++++++++++++++++++
>>>>>     .../selftests/bpf/progs/linked_funcs2.c       | 73 +++++++++++++++++++
>>>>>     4 files changed, 190 insertions(+), 1 deletion(-)
>>>>>     create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>>>>>     create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
>>>>>     create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
>>>>>
>>>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>>>>> index 666b462c1218..427ccfec1a6a 100644
>>>>> --- a/tools/testing/selftests/bpf/Makefile
>>>>> +++ b/tools/testing/selftests/bpf/Makefile
>>>>> @@ -308,9 +308,10 @@ endef
>>>>>
>>>>>     SKEL_BLACKLIST := btf__% test_pinning_invalid.c test_sk_assign.c
>>>>>
>>>>> -LINKED_SKELS := test_static_linked.skel.h
>>>>> +LINKED_SKELS := test_static_linked.skel.h linked_funcs.skel.h
>>>>>
>>>>>     test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
>>>>> +linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
>>>>>
>>>>>     LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
>>>>>
>>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/linked_funcs.c b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>>>>> new file mode 100644
>>>>> index 000000000000..03bf8ef131ce
>>>>> --- /dev/null
>>>>> +++ b/tools/testing/selftests/bpf/prog_tests/linked_funcs.c
>>>>> @@ -0,0 +1,42 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0
>>>>> +/* Copyright (c) 2021 Facebook */
>>>>> +
>>>>> +#include <test_progs.h>
>>>>> +#include <sys/syscall.h>
>>>>> +#include "linked_funcs.skel.h"
>>>>> +
>>>>> +void test_linked_funcs(void)
>>>>> +{
>>>>> +     int err;
>>>>> +     struct linked_funcs *skel;
>>>>> +
>>>>> +     skel = linked_funcs__open();
>>>>> +     if (!ASSERT_OK_PTR(skel, "skel_open"))
>>>>> +             return;
>>>>> +
>>>>> +     skel->rodata->my_tid = syscall(SYS_gettid);
>>>>> +     skel->rodata->syscall_id = SYS_getpgid;
>>>>> +
>>>>> +     err = linked_funcs__load(skel);
>>>>> +     if (!ASSERT_OK(err, "skel_load"))
>>>>> +             goto cleanup;
>>>>> +
>>>>> +     err = linked_funcs__attach(skel);
>>>>> +     if (!ASSERT_OK(err, "skel_attach"))
>>>>> +             goto cleanup;
>>>>> +
>>>>> +     /* trigger */
>>>>> +     syscall(SYS_getpgid);
>>>>> +
>>>>> +     ASSERT_EQ(skel->bss->output_val1, 2000 + 2000, "output_val1");
>>>>> +     ASSERT_EQ(skel->bss->output_ctx1, SYS_getpgid, "output_ctx1");
>>>>> +     ASSERT_EQ(skel->bss->output_weak1, 42, "output_weak1");
>>>>> +
>>>>> +     ASSERT_EQ(skel->bss->output_val2, 2 * 1000 + 2 * (2 * 1000), "output_val2");
>>>>> +     ASSERT_EQ(skel->bss->output_ctx2, SYS_getpgid, "output_ctx2");
>>>>> +     /* output_weak2 should never be updated */
>>>>> +     ASSERT_EQ(skel->bss->output_weak2, 0, "output_weak2");
>>>>> +
>>>>> +cleanup:
>>>>> +     linked_funcs__destroy(skel);
>>>>> +}
>>>>> diff --git a/tools/testing/selftests/bpf/progs/linked_funcs1.c b/tools/testing/selftests/bpf/progs/linked_funcs1.c
>>>>> new file mode 100644
>>>>> index 000000000000..cc621d4e4d82
>>>>> --- /dev/null
>>>>> +++ b/tools/testing/selftests/bpf/progs/linked_funcs1.c
>>>>> @@ -0,0 +1,73 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0
>>>>> +/* Copyright (c) 2021 Facebook */
>>>>> +
>>>>> +#include "vmlinux.h"
>>>>> +#include <bpf/bpf_helpers.h>
>>>>> +#include <bpf/bpf_tracing.h>
>>>>> +
>>>>> +/* weak and shared between two files */
>>>>> +const volatile int my_tid __weak = 0;
>>>>> +const volatile long syscall_id __weak = 0;
>>>>
>>>> Since the new compiler (llvm13) is recommended for this patch set.
>>>> We can simplify the above two definition with
>>>>      int my_tid __weak;
>>>>      long syscall_id __weak;
>>>> The same for the other file.
>>>
>>> This is not about old vs new compilers. I wanted to use .rodata
>>> variables, but I'll switch to .bss, no problem.
>>
>> I see. You can actually hone one "const volatile ing my_tid __weak = 0"
>> and another "long syscall_id __weak". This way, you will be able to
>> test both .rodata and .bss section.
> 
> I wonder if you meant to have one my_tid __weak in .bss and another
> my_tid __weak in .rodata. Or just my_tid in .bss and syscall_id in
> .rodata?
> 
> If the former (mixing ELF sections across definitions of the same
> symbol), then it's disallowed right now. libbpf will error out on
> mismatched sections. I tested this with normal compilation, it does
> work and the final section is the section of the winner.
> 
> But I think that's quite confusing, actually, so I'm going to leave it
> disallowed for now. E.g., if one file expects a read-write variable
> and another expects that same variable to be read-only, and the winner
> ends up being read-only one, then the file expecting read-write will
> essentially have incorrect code (and will be rejected by BPF verifier,
> if anything attempts to write). So I think it's better to reject it at
> the linking time.
> 
> But I'll do one (my_tid) as .bss, and another (syscall_id) as .rodata.

I mean this one. Permitting the same variable in both .bss and .rodata
sections is never a good practice.

> 
>>
>>>
>>>>
>>>> But I am also okay with the current form
>>>> to *satisfy* llvm10 some people may still use.
>>>>
>>>>> +
>>>>> +int output_val1 = 0;
>>>>> +int output_ctx1 = 0;
>>>>> +int output_weak1 = 0;
>>>>> +
>>>>> +/* same "subprog" name in all files, but it's ok because they all are static */
>>>>> +static __noinline int subprog(int x)
>>>>> +{
>>>>> +     /* but different formula */
>>>>> +     return x * 1;
>>>>> +}
>>>>> +
>>>>> +/* Global functions can't be void */
>>>>> +int set_output_val1(int x)
>>>>> +{
>>>>> +     output_val1 = x + subprog(x);
>>>>> +     return x;
>>>>> +}
>>>>> +
>>>>> +/* This function can't be verified as global, as it assumes raw_tp/sys_enter
>>>>> + * context and accesses syscall id (second argument). So we mark it as
>>>>> + * __hidden, so that libbpf will mark it as static in the final object file,
>>>>> + * right before verifying it in the kernel.
>>>>> + *
>>>>> + * But we don't mark it as __hidden here, rather at extern site. __hidden is
>>>>> + * "contaminating" visibility, so it will get propagated from either extern or
>>>>> + * actual definition (including from the losing __weak definition).
>>>>> + */
>>>>> +void set_output_ctx1(__u64 *ctx)
>>>>> +{
>>>>> +     output_ctx1 = ctx[1]; /* long id, same as in BPF_PROG below */
>>>>> +}
>>>>> +
>>>>> +/* this weak instance should win because it's the first one */
>>>>> +__weak int set_output_weak(int x)
>>>>> +{
>>>>> +     output_weak1 = x;
>>>>> +     return x;
>>>>> +}
>>>>> +
>>>>> +extern int set_output_val2(int x);
>>>>> +
>>>>> +/* here we'll force set_output_ctx2() to be __hidden in the final obj file */
>>>>> +__hidden extern void set_output_ctx2(__u64 *ctx);
>>>>> +
>>>> [...]
