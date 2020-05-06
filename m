Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FDC1C7C4A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgEFVUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:20:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33340 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729477AbgEFVUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:20:31 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046LE8eK025645;
        Wed, 6 May 2020 14:20:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SKMqdkDMgUCRYKKP8haZ3C9W//Nx/eQVEPl49vZ/YmA=;
 b=Cmw7cHVenYIXx6VqHW9BpXaQqL+DkvofGMSdEABoqXCO7ja3MP+7j9XeVhsUPo6k5YbJ
 lYar5yMyehlF7xoHaxr9xrcrV0Y6KegRhDTfUHwVS7huwmFXCfoi94lVn2C9QuZefFuO
 0xpaKPCPmnMmnWsozz8BJL9GzHs0tmq0Dtk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30uxuxj7e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 14:20:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 14:20:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ2LKbcjT3JJYc8zaAsy/30Z0T8yyGxP1EjPdKkg1mbBpmlrO7/ZKVaEbRYxwKkALEcO8x5QXx8xyTocQ3VT7pUv9PhZ6+DshyLYje32ufvlc6n/yM7l0yJ+tHlsL/xME5YCgZbhisnXw9CcGV8Fu5vuLNrNyJ1SLgxm330hRZvpOHKWHr4aH/X/+0R3Cn1PMjGzLek8waRse94FKkZYXMIG5Sb1epksnzKU5LOTH/NZ1/GjTTVd6ckmVnPcB4KUynUpAnTHWxa+d2Yp3TlnVjea8A5P7wuUq/ACKmT7ce1XmF0M9AUaF7LI4AvTZaevC+kFvFe6b1NKH6KU6vHm2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKMqdkDMgUCRYKKP8haZ3C9W//Nx/eQVEPl49vZ/YmA=;
 b=HrssjaCR9HbAR6GfdpwrxFomyIdaOrxPd8NKhT4hBlmUFCJRVNLI9M781CCUlBAEg5wDcUGW/0m0z05Rdzb+h/FSBScSTI/lc3Dp8aM0LagQoXeCtT6RskmQzBQTmxYPLweG27FspgA5lHMs9m6Rw3XHoPdp9W0l29V7j6eykdURZRZRxnLDLHbLkDsfOC0ffVM9KJex3v78wwHt1oHAvXesgqoBPBB4uVNrJO1iKhBZV3+vEQQPCvXK9lxmm9aXJQh/HIIsy6N7cHTLNHEqMr0/Otvqeb6QYJ/Esti3mMb5DxJ2fND2sZ243YqmDAo5DIfcVvdUifGV5JCDJek/Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKMqdkDMgUCRYKKP8haZ3C9W//Nx/eQVEPl49vZ/YmA=;
 b=fmpPxF3bFxaSmCIrHGPSD5Oc6TPWRZ2xyA4xqolkze8QqrU3zPmc7XQ7jJopplVELqrsVvxYNjyKPWQMcW18lJrfnruOzvjb7HOS8r0XE0CFpmAFP9bDMoJBhNcnPgHxL3hysncvHaYJcEy/47jgSkyyD3TeMpOJCPWr14fk9VQ=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3061.namprd15.prod.outlook.com (2603:10b6:a03:b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 6 May
 2020 21:20:13 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 21:20:13 +0000
Subject: Re: [PATCH bpf-next v2 11/20] bpf: add task and task/file iterator
 targets
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062559.2048228-1-yhs@fb.com>
 <CAEf4BzbySjaBQSMTET=HGD_K748GOXZZQ7zMhgtEqE-JgJGbdQ@mail.gmail.com>
 <8758f1c9-f4ea-af99-9af8-afe9fb210928@fb.com>
 <CAEf4BzaTTdChHsEy=WX8-j-1c66baZnppK6WaSjexewjph0O=g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2f2bb9c4-6fd2-3fdb-959d-0ce408168c85@fb.com>
Date:   Wed, 6 May 2020 14:20:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzaTTdChHsEy=WX8-j-1c66baZnppK6WaSjexewjph0O=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:66a9) by BY5PR16CA0017.namprd16.prod.outlook.com (2603:10b6:a03:1a0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 21:20:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:66a9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75e4c297-5ca5-41dd-7051-08d7f20343c7
X-MS-TrafficTypeDiagnostic: BYAPR15MB3061:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3061CEA8B4E472791EA25CB3D3A40@BYAPR15MB3061.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBxITUPwBbEEa+Vb2f3QTKXOMmFqC7rm/BqBthT+1UpdSPhKaFtyNQFKe6DRQoZU7qbQoBPLBDT1b8opP9AYkSvd52PC4g5EZKr/OgSrBYpSBTRHjKei3piQAu3Bc3ni0/zsPE9LJUbjZLl/AJZfqqh7RJfodZ2SQ74vmKQI0QvorFP0yrjOVCJgVQQpCMNppCgJvhdvwC3i9u0ADQigT8wHb2ls7ANOrk/3pKicBWGRyqHW4EMnDb4mObPO7UFPsB1D9kObROiZ/SKyx/5It3Pmcdj9LCRMKjK1hetQM8UtnQlXqE0f9VjDCcTMzohABWd5aR/soiV619s1L4g3Eq2IXXehARfDgrlWUo6nOy2krbpzrnMNflQYJ6cRQINVTLfK3ygjsDdUatEm5STu1NFPzETGjQKHumn2mgKNIhYH9oRR+J+OIHJi70am8icz03IRXEZZZLkDOvCO0ziPEeVhbFI23TJcvw3WNnrfuyzsHYey3glLaXCgG/f8vH/PC5LeTZKOl1j9RmZXc6GlZ3QqjLLJzFSOBzQD8ubpOcLb/MG1wR5wcq4chXRxgm+H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(346002)(366004)(396003)(33430700001)(31696002)(36756003)(6512007)(4326008)(66556008)(54906003)(86362001)(33440700001)(6916009)(478600001)(2616005)(5660300002)(6486002)(8936002)(66476007)(31686004)(53546011)(52116002)(66946007)(8676002)(6506007)(16526019)(316002)(186003)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eXeawxw662kDGaAwt/Y3t0OvUDlr6vAT6So/wHTkdLHG+MZVCR0uVCZbioVI76O32ur1P3DObpShNNBWgoxCxr1rPeohux1sjRgXEjLwSSmOJFrbO69IrHVbP7ZUAobv3Aco8wpGGGXAt8Q/zyb/ZrA/9AGsl5Vo/TtdJT5vdq7sZ7vNKApd4RWxjgpYB6rQOb2JEKD9/uoMV+oydkSVLNipSjmtzRsaZkwhB749xLhJAtMbLl6iwIKl5POKffDp6pc5KHx14S/xwlz7USuXojLdwB5ueBPJEAouLMQII3QJu8jyMnncrM+rdtA3jdQxn8TJPp4lrKORdM5oCrutBslab1E6GZYE00AL2GhX6VSs1Gv1TPO+Im76WwNdUSQzVLzbnQpqjhF1moPd/pqdpiYA3rvOpOvg01+SAyrXKcYfAc+J/Fz84UkbC9Ar6cyNq62u1dgQg+Sl3Jla2x8zR47B4r8Hzt0F9FXK37Sfk5AH9MVTzmYr6QGlSxTieBc1MIJ8K4nPTb3y+EwWrNe/NpoYFc8C1xQybfI3ESh9XEfrXuVExL6BhQVqYxEJl0ucBRAHFrQ072fWR6BtJ09x3TONBB2J9BmU832ihiByOJlKqmyKqJ9N8H7L0i2znhWkdWgbkxGX9kPmvmLOYcoPS6VVpAzbRJo0w5XDM/4aRMBZteMsepHRjZSDcR/mFCDZlCL1bsg4NJlhXDdl4B8mttaauoQpCuASr+PMCvJe/xKj8++t6FctGwdhWuf8apLSoZ7Gtf1I8OSxjUz4fy6g5AYlViENq2gQ1R6JFRwznt6A5b0nRGSUwOOtzzCW0te0g13JAhugl6nWBpb5rMtFiA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e4c297-5ca5-41dd-7051-08d7f20343c7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 21:20:13.4270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxF620H0iC+aA9hqutA3lu0q4awLfAnWM7SeVGYLWzM+uDJulLHDKhc3aR2cbWtL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3061
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/20 1:51 PM, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 11:24 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 5/6/20 12:30 AM, Andrii Nakryiko wrote:
>>> On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> Only the tasks belonging to "current" pid namespace
>>>> are enumerated.
>>>>
>>>> For task/file target, the bpf program will have access to
>>>>     struct task_struct *task
>>>>     u32 fd
>>>>     struct file *file
>>>> where fd/file is an open file for the task.
>>>>
>>>> Signed-off-by: Yonghong Song <yhs@fb.com>
>>>> ---
>>>
>>> I might be missing some subtleties with task refcounting for task_file
>>> iterator, asked few questions below...
>>>
>>>>    kernel/bpf/Makefile    |   2 +-
>>>>    kernel/bpf/task_iter.c | 336 +++++++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 337 insertions(+), 1 deletion(-)
>>>>    create mode 100644 kernel/bpf/task_iter.c
>>>>
>>>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>>>> index b2b5eefc5254..37b2d8620153 100644
>>>> --- a/kernel/bpf/Makefile
>>>> +++ b/kernel/bpf/Makefile
>>>> @@ -2,7 +2,7 @@
>>>>    obj-y := core.o
>>>>    CFLAGS_core.o += $(call cc-disable-warning, override-init)
>>>>
>>>> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o
>>>> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o
>>>>    obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>>>>    obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>>>>    obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>>>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>>>> new file mode 100644
>>>> index 000000000000..1ca258f6e9f4
>>>> --- /dev/null
>>>> +++ b/kernel/bpf/task_iter.c
>>>> @@ -0,0 +1,336 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>> +/* Copyright (c) 2020 Facebook */
>>>> +
>>>> +#include <linux/init.h>
>>>> +#include <linux/namei.h>
>>>> +#include <linux/pid_namespace.h>
>>>> +#include <linux/fs.h>
>>>> +#include <linux/fdtable.h>
>>>> +#include <linux/filter.h>
>>>> +
>>>> +struct bpf_iter_seq_task_common {
>>>> +       struct pid_namespace *ns;
>>>> +};
>>>> +
>>>> +struct bpf_iter_seq_task_info {
>>>> +       struct bpf_iter_seq_task_common common;
>>>
>>> you have comment below in init_seq_pidns() that common is supposed to
>>> be the very first field, but I think it's more important and
>>> appropriate here, so that whoever adds anything here knows that order
>>> of field is important.
>>
>> I can move the comments here.
>>
>>>
>>>> +       struct task_struct *task;
>>>> +       u32 id;
>>>> +};
>>>> +
>>>
>>> [...]
>>>
>>>> +static int __task_seq_show(struct seq_file *seq, void *v, bool in_stop)
>>>> +{
>>>> +       struct bpf_iter_meta meta;
>>>> +       struct bpf_iter__task ctx;
>>>> +       struct bpf_prog *prog;
>>>> +       int ret = 0;
>>>> +
>>>> +       meta.seq = seq;
>>>> +       prog = bpf_iter_get_info(&meta, in_stop);
>>>> +       if (prog) {
>>>
>>>
>>> nit: `if (!prog) return 0;` here would reduce nesting level below
>>>
>>>> +               meta.seq = seq;
>>>> +               ctx.meta = &meta;
>>>> +               ctx.task = v;
>>>> +               ret = bpf_iter_run_prog(prog, &ctx);
>>>> +       }
>>>> +
>>>> +       return 0;
>>>
>>> return **ret**; ?
>>
>> It should return "ret". In task_file show() code is similar but correct.
>> I can do early return with !prog too although we do not have
>> deep nesting level yet.
>>
>>>
>>>> +}
>>>> +
>>>
>>> [...]
>>>
>>>> +
>>>> +static struct file *task_file_seq_get_next(struct pid_namespace *ns, u32 *id,
>>>> +                                          int *fd, struct task_struct **task,
>>>> +                                          struct files_struct **fstruct)
>>>> +{
>>>> +       struct files_struct *files;
>>>> +       struct task_struct *tk;
>>>> +       u32 sid = *id;
>>>> +       int sfd;
>>>> +
>>>> +       /* If this function returns a non-NULL file object,
>>>> +        * it held a reference to the files_struct and file.
>>>> +        * Otherwise, it does not hold any reference.
>>>> +        */
>>>> +again:
>>>> +       if (*fstruct) {
>>>> +               files = *fstruct;
>>>> +               sfd = *fd;
>>>> +       } else {
>>>> +               tk = task_seq_get_next(ns, &sid);
>>>> +               if (!tk)
>>>> +                       return NULL;
>>>> +
>>>> +               files = get_files_struct(tk);
>>>> +               put_task_struct(tk);
>>>
>>> task is put here, but is still used below.. is there some additional
>>> hidden refcounting involved?
>>
>> Good question. I had an impression that we take a reference count
>> for task->files so task should not go away. But reading linux
>> code again, I do not have sufficient evidence to back my claim.
>> So I will reference count task as well, e.g., do not put_task_struct()
>> until all files are done here.
> 
> All threads within the process share files table. So some threads
> might exit, but files will stay, which is why task_struct and
> files_struct have separate refcounting, and having refcount on files
> doesn't guarantee any particular task will stay alive for long enough.
> So I think we need to refcount both files and task in this case.
> Reading source code of copy_files() in kernel/fork.c (CLONE_FILES
> flags just bumps refcnt on old process' files_struct), seems to
> confirm this as well.

Just checked the code. It does look like files are shared among
threads (tasks). So yes, in this case, reference counting to
both task and file_table needed.

> 
>>
>>>
>>>> +               if (!files) {
>>>> +                       sid = ++(*id);
>>>> +                       *fd = 0;
>>>> +                       goto again;
>>>> +               }
>>>> +               *fstruct = files;
>>>> +               *task = tk;
>>>> +               if (sid == *id) {
>>>> +                       sfd = *fd;
>>>> +               } else {
>>>> +                       *id = sid;
>>>> +                       sfd = 0;
>>>> +               }
>>>> +       }
>>>> +
>>>> +       rcu_read_lock();
[...]
