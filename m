Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9381D1968
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgEMP3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:29:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45836 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729359AbgEMP3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:29:30 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DFRNEw012475;
        Wed, 13 May 2020 08:29:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oxdzCy1kUiuhMnp63mteI6URtYqDjhfmjW2ecvAoOSU=;
 b=oBY2tRtgeAAv/kRun6FiU4JMCFT4uSr4Em0R9IUbbENQoKuXhr+IpX+DsyE0N65tRw/O
 yXXb+KA87swVaQFBpKvu9g0s3DvEXcEdpSFuqJ33b/ovcf2mtUhgMIaQxPdnJ7iVm5wQ
 bZi6Po07184x3JFD/zYEnOWrsMu/eXdW+Jk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x6wg62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 08:29:14 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 08:29:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJhfVfyZYDQ9aa/4AnP8Q3IDPsUQjaeA8ZQ41gYPlNq7E/3kNHZwZKluPZrYwr8hG0vLWnRklU/Iw3tCdx+ouCNT6gTzap90kE1MAV7Vm/Ky8yBbqMdogfHo3oK/UYNZonahz7bXiz7TOiwluP8bA757SJvAh/KWH6K/KmZwoMieWGNmoC4Ffm28lmtjmi8tU1jtkrbm8PV9qbhwgKjPr30iUqE/VDcBlknhilQuWEQ36nTOqnNLCN63Lj6fgZEUD0oATOzwdgJc57xl1R7vhsHaynpiIWU+JE7vCsmRNRSCwtUpXcMsNZsDE8PR6B0WehHTkGbUohk1izdyKZr1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxdzCy1kUiuhMnp63mteI6URtYqDjhfmjW2ecvAoOSU=;
 b=C8fM9GOmurFegAubfDIQceNpn1ruIHtqjbNeFznpPsf4pOlPAoaM8lLAkdxGrwVqvTVX/snOR2vTp11G3xyo41Jx7lvfVlqASZE6quz7xhbBJb22tLy30tK9lh+MSymPgY4WWkF1IWHr2CkecUYdZHt8Do4nASSK6KUjtdqYufKs7KhAwD80oJvUrNqrW05ilJADghDEascFW/tOcWEmQwNeCOJLIPLqwY6vIM/BmnmIFRTT791FLPhJpOLc9bwqCy8LTj5MO6QtnIJRBMl6hsaoQOMfT/GRaTC4T+m8IGqKq+joo+vGo4k8SGgjWB0rlb041QxqHwOCtFHHvvJIyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxdzCy1kUiuhMnp63mteI6URtYqDjhfmjW2ecvAoOSU=;
 b=ingH9zLG8+cM2s3gl77lIl2W2SxL514tUHUEa2c1TVQ6xnXPhKNDzwDjHOnDIgc5xckhVu/SpMNPfA4MJK3K1xzBysIr5pPEOftpxCFmiodxunBGt6WHr3YNY0BNqQoyC/79EyphxF7EKks8IlvZU28N7s1RZdjIDazq/P+VEX4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2552.namprd15.prod.outlook.com (2603:10b6:a03:14c::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Wed, 13 May
 2020 15:28:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 15:28:59 +0000
Subject: Re: [PATCH bpf-next 1/3] samples: bpf: refactor kprobe tracing user
 progs with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
References: <20200512144339.1617069-1-danieltimlee@gmail.com>
 <20200512144339.1617069-2-danieltimlee@gmail.com>
 <f8d524dc-245b-e8c6-3e0b-16969df76b0a@fb.com>
 <CAEKGpziAt7gDzqzvOO4=dMODB_wajFq-HbYNyfz6xNVaGaB9rQ@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c677db23-1680-6fcb-1629-0a93f60bf2c8@fb.com>
Date:   Wed, 13 May 2020 08:28:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CAEKGpziAt7gDzqzvOO4=dMODB_wajFq-HbYNyfz6xNVaGaB9rQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0003.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:86c3) by BY5PR16CA0003.namprd16.prod.outlook.com (2603:10b6:a03:1a0::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 15:28:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:86c3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7f825da-7ce8-4a45-482e-08d7f7525b56
X-MS-TrafficTypeDiagnostic: BYAPR15MB2552:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2552D6C090D6A8CC497BA181D3BF0@BYAPR15MB2552.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: we21f73cjF2AVKvk25Tc/vFSFwWBrxwC2VBvR6X6GxHikwTGnFoqhQHFyMiVApjWv7w7FEywc0NoIqNAg5vddU9kb52CXAskHtLiQm1/05ggHl8HWWhNakaNCgcYuok2nOHNUBpBd6EbkrZGCmsCm7SGaVziLYvwG+MeTM62bHyUXmaOBijMcOtK9RZF+gkZ2jBfoxe7FGsFEgCvo+5+WlkYDtMk+HxWXco1Tv84ABUR5KhHzxz05YXEaRFMlYV7H5idTxBS6hRec6CgACk7zOOjv0sWc4FidQAR2T4ApYs1aCqJXwnlsV8WlaY2EvBun8hT3Z7YsdpdPdF5zmlCdvDetI5BX/NGfFnLwx7Pg+o+UrVndp4nDpkKm51u98VLAducMkBHWvbE/7EIfQejjqtgGxIJxT8bjAlYmB7+kREh1SAOS8GD2jlSuY+a2tE8e35fJcsZTaeoXtP6Wij0u5DSZzlIlhPNgcKIdiwCMOg7LnXxaz6Ut7wEvPACprY0+pNTFUBII1HWKTQU4g65HPkoVlgaIda2U5jHFqMjZ7i63X9VxQoWyr6xSAVPhE6r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(136003)(39860400002)(396003)(346002)(33430700001)(8936002)(33440700001)(6486002)(6916009)(2616005)(5660300002)(316002)(2906002)(6512007)(8676002)(478600001)(36756003)(4326008)(66946007)(52116002)(54906003)(16526019)(6506007)(66556008)(66476007)(86362001)(31696002)(31686004)(53546011)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: d9Kik9ROB/VVGpIbCtlzxkU3IK0DT6srYJ7yv6f8STCLp4vLRiB7AGdfX77Ci3v5Eeq8wmBuGVCdJ5rOw/sJp3iQGavv0lgHuw1W/3kOKGQHv/53UUUhsxcmjmlYuijZr3sILYWm9e41aq7ZNP8fJ+vorXJ+Y2a4CI5BL2S28My5qHu649Y04UKi5bjh1vbt80dpchLTUJO6wMecQ/VMQysb12aHQmmsKxQ+rdsBk91ln7nS6mdM3FJK5ly4VHA1b+4iExfkWCtsO5mctR/vKhM8lFtFiyHXNV0aEnEo2KqjD9WlAgrYs8nGNdpmywV660G40l5DrWPMq4M3rmTsT+nuvaZUf9hweqpJ9xztrIiK07qxtCDmkpe5hCEDABBqrfbU5SU6EOm16ufHQJfGbY0LQQSevV+ZPpGA2+fkyyO2l9At3/rzHgBg8K8YlMWdBm9oG4xCNzP6458GI90yMH+TDES+DOS8WbaZzoriPWcuG1ICVlBfEuT83W2VQUf9J+08Rrx0gnS9OLbEks8i/A==
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f825da-7ce8-4a45-482e-08d7f7525b56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 15:28:59.0083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VpzujxDtlp8upEu3pG6n5wkSwg/qM66f2odxf6UnYTarKxiV80TY3OKFnFYNVRBD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2552
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_07:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 11:51 PM, Daniel T. Lee wrote:
> On Wed, May 13, 2020 at 10:40 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/12/20 7:43 AM, Daniel T. Lee wrote:
>>> Currently, the kprobe BPF program attachment method for bpf_load is
>>> quite old. The implementation of bpf_load "directly" controls and
>>> manages(create, delete) the kprobe events of DEBUGFS. On the other hand,
>>> using using the libbpf automatically manages the kprobe event.
>>> (under bpf_link interface)
>>>
>>> By calling bpf_program__attach(_kprobe) in libbpf, the corresponding
>>> kprobe is created and the BPF program will be attached to this kprobe.
>>> To remove this, by simply invoking bpf_link__destroy will clean up the
>>> event.
>>>
>>> This commit refactors kprobe tracing programs (tracex{1~7}_user.c) with
>>> libbpf using bpf_link interface and bpf_program__attach.
>>>
>>> tracex2_kern.c, which tracks system calls (sys_*), has been modified to
>>> append prefix depending on architecture.
>>>
>>> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>>> ---
>>>    samples/bpf/Makefile       | 12 +++----
>>>    samples/bpf/tracex1_user.c | 41 ++++++++++++++++++++----
>>>    samples/bpf/tracex2_kern.c |  8 ++++-
>>>    samples/bpf/tracex2_user.c | 55 ++++++++++++++++++++++++++------
>>>    samples/bpf/tracex3_user.c | 65 ++++++++++++++++++++++++++++----------
>>>    samples/bpf/tracex4_user.c | 55 +++++++++++++++++++++++++-------
>>>    samples/bpf/tracex6_user.c | 53 +++++++++++++++++++++++++++----
>>>    samples/bpf/tracex7_user.c | 43 ++++++++++++++++++++-----
>>>    8 files changed, 268 insertions(+), 64 deletions(-)
>>>
>>> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
>>> index 424f6fe7ce38..4c91e5914329 100644
>>> --- a/samples/bpf/Makefile
>>> +++ b/samples/bpf/Makefile
>>> @@ -64,13 +64,13 @@ fds_example-objs := fds_example.o
>>>    sockex1-objs := sockex1_user.o
>>>    sockex2-objs := sockex2_user.o
>>>    sockex3-objs := bpf_load.o sockex3_user.o
>>> -tracex1-objs := bpf_load.o tracex1_user.o $(TRACE_HELPERS)
>>> -tracex2-objs := bpf_load.o tracex2_user.o
>>> -tracex3-objs := bpf_load.o tracex3_user.o
>>> -tracex4-objs := bpf_load.o tracex4_user.o
>>> +tracex1-objs := tracex1_user.o $(TRACE_HELPERS)
>>> +tracex2-objs := tracex2_user.o
>>> +tracex3-objs := tracex3_user.o
>>> +tracex4-objs := tracex4_user.o
>>>    tracex5-objs := bpf_load.o tracex5_user.o $(TRACE_HELPERS)
>>> -tracex6-objs := bpf_load.o tracex6_user.o
>>> -tracex7-objs := bpf_load.o tracex7_user.o
>>> +tracex6-objs := tracex6_user.o
>>> +tracex7-objs := tracex7_user.o
>>>    test_probe_write_user-objs := bpf_load.o test_probe_write_user_user.o
>>>    trace_output-objs := bpf_load.o trace_output_user.o $(TRACE_HELPERS)
>>>    lathist-objs := bpf_load.o lathist_user.o
>>> diff --git a/samples/bpf/tracex1_user.c b/samples/bpf/tracex1_user.c
>>> index 55fddbd08702..1b15ab98f7d3 100644
>>> --- a/samples/bpf/tracex1_user.c
>>> +++ b/samples/bpf/tracex1_user.c
>>> @@ -1,21 +1,45 @@
>>>    // SPDX-License-Identifier: GPL-2.0
>>>    #include <stdio.h>
>>> -#include <linux/bpf.h>
>>>    #include <unistd.h>
>>> -#include <bpf/bpf.h>
>>> -#include "bpf_load.h"
>>> +#include <bpf/libbpf.h>
>>>    #include "trace_helpers.h"
>>>
>>> +#define __must_check
>>
>> This is not very user friendly.
>> Maybe not including linux/err.h and
>> use libbpf API libbpf_get_error() instead?
>>
> 
> This approach looks more apparent and can stick with the libbpf API.
> I'll update code using this way.
> 
>>> +#include <linux/err.h>
>>> +
>>>    int main(int ac, char **argv)
>>>    {
>>> -     FILE *f;
>>> +     struct bpf_link *link = NULL;
>>> +     struct bpf_program *prog;
>>> +     struct bpf_object *obj;
>>>        char filename[256];
>>> +     FILE *f;
>>>
>>>        snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
>>> +     obj = bpf_object__open_file(filename, NULL);
>>> +     if (IS_ERR(obj)) {
>>> +             fprintf(stderr, "ERROR: opening BPF object file failed\n");
>>> +             obj = NULL;
>>> +             goto cleanup;
>>
>> You do not need to goto cleanup, directly return 0 is okay here.
>> The same for other files in this patch.
>>
> 
> As you said, it would be better to return right away than to proceed
> any further. I'll apply the code at next patch.
> 
>>> +     }
>>> +
>>> +     prog = bpf_object__find_program_by_name(obj, "bpf_prog1");
>>> +     if (!prog) {
>>> +             fprintf(stderr, "ERROR: finding a prog in obj file failed\n");
>>> +             goto cleanup;
>>> +     }
>>> +
>>> +     /* load BPF program */
>>> +     if (bpf_object__load(obj)) {
>>> +             fprintf(stderr, "ERROR: loading BPF object file failed\n");
>>> +             goto cleanup;
>>> +     }
>>>
>>> -     if (load_bpf_file(filename)) {
>>> -             printf("%s", bpf_log_buf);
>>> -             return 1;
>>> +     link = bpf_program__attach(prog);
>>> +     if (IS_ERR(link)) {
>>> +             fprintf(stderr, "ERROR: bpf_program__attach failed\n");
>>> +             link = NULL;
>>> +             goto cleanup;
>>>        }
>>>
>>>        f = popen("taskset 1 ping -c5 localhost", "r");
>>> @@ -23,5 +47,8 @@ int main(int ac, char **argv)
>>>
>>>        read_trace_pipe();
>>>
>>> +cleanup:
>>> +     bpf_link__destroy(link);
>>> +     bpf_object__close(obj);
>>
>> Typically in kernel, we do multiple labels for such cases
>> like
>> destroy_link:
>>          bpf_link__destroy(link);
>> close_object:
>>          bpf_object__close(obj);
>>
>> The error path in the main() function jumps to proper label.
>> This is more clean and less confusion.
>>
>> The same for other cases in this file.
>>
> 
> I totally agree that multiple labels are much more intuitive.
> But It's not very common to jump to the destroy_link label.
> 
> Either when on the routine is completed successfully and jumps to the
> destroy_link branch, or an error occurred while bpf_program__attach
> was called "several" times and jumps to the destroy_link branch.
> 
> Single bpf_program__attach like this tracex1 sample doesn't really have
> to destroy link, since the link has been set to NULL on attach error and
> bpf_link__destroy() is designed to do nothing if passed NULL to it.
> 
> So I think current approach will keep consistent between samples since
> most of the sample won't need to jump to destroy_link.

Since this is the sample code, I won't enforce that. So yes, you can
keep your current approach.

> 
>>>        return 0;
>>>    }
>>> diff --git a/samples/bpf/tracex2_kern.c b/samples/bpf/tracex2_kern.c
>>> index d865bb309bcb..ff5d00916733 100644
>>> --- a/samples/bpf/tracex2_kern.c
>>> +++ b/samples/bpf/tracex2_kern.c
>>> @@ -11,6 +11,12 @@
>>>    #include <bpf/bpf_helpers.h>
>>>    #include <bpf/bpf_tracing.h>
>>>
>>> +#ifdef __x86_64__
>>> +#define SYSCALL "__x64_"
>>> +#else
>>> +#define SYSCALL
>>> +#endif
>>
>> See test_progs.h, one more case to handle:
>> #ifdef __x86_64__
>> #define SYS_NANOSLEEP_KPROBE_NAME "__x64_sys_nanosleep"
>> #elif defined(__s390x__)
>> #define SYS_NANOSLEEP_KPROBE_NAME "__s390x_sys_nanosleep"
>> #else
>> #define SYS_NANOSLEEP_KPROBE_NAME "sys_nanosleep"
>> #endif
>>
> 
> That was also one of the considerations when writing patches.
> I'm planning to refactor most of the programs in the sample using
> libbpf, and found out that there are bunch of samples that tracks
> syscall with kprobe. Replacing all of them will take lots of macros
> and I thought using prefix will be better idea.
> 
> Actually, my initial plan was to create macro of SYSCALL()
> 
>         #ifdef __x86_64__
>         #define PREFIX "__x64_"
>         #elif defined(__s390x__)
>         #define PREFIX "__s390x_"
>         #else
>         #define PREFIX ""
>         #endif
> 
>         #define SYSCALL(SYS) PREFIX ## SYS
> 
> And to use this macro universally without creating additional headers,
> I was trying to add this to samples/bpf/syscall_nrs.c which later
> compiles to samples/bpf/syscall_nrs.h. But it was pretty hacky way and
> it won't work properly. So I ended up with just adding prefix to syscall.

I think it is okay to create a trace_common.h to have this definition
defined in one place and use them in bpf programs.

> 
> Is it necessary to define all of the macro for each architecture?

Yes, if we define in trace_common.h, let us do for x64/x390x/others
similar to the above.

> 
>>> +
>>>    struct bpf_map_def SEC("maps") my_map = {
>>>        .type = BPF_MAP_TYPE_HASH,
>>>        .key_size = sizeof(long),
>>> @@ -77,7 +83,7 @@ struct bpf_map_def SEC("maps") my_hist_map = {
>>>        .max_entries = 1024,
>>>    };
>>>
>>> -SEC("kprobe/sys_write")
>>> +SEC("kprobe/" SYSCALL "sys_write")
>>>    int bpf_prog3(struct pt_regs *ctx)
>>>    {
>>>        long write_size = PT_REGS_PARM3(ctx);
>> [...]
> 
> 
> Thank you for your time and effort for the review :)
> 
> Best,
> Daniel
> 
