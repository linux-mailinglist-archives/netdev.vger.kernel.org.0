Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3AF1C7959
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgEFSZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:25:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30946 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727872AbgEFSZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:25:02 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046IG6Hf001070;
        Wed, 6 May 2020 11:24:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ogtnHT1r5HF9iSLr0eBD55cvJrmAFLXYaTVczo+f22Y=;
 b=LzZb41uqXCY76a64vQFqLOXuEn9gFP2LR4Ek6VBq/t0k7s+3amSSPnK4fAJClHZBtxwZ
 IqxkzEnquNb4u7bh8HzIIXFHE9vIaru5q31ZDxPy4/klzwINRyBPcP58XhJjdRdinbof
 Cuj/qEvP4GLNbXqrrVmPF4OAFbsoc4DD1Go= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30uxuxh9xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 11:24:49 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 11:24:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PLFzTmtwWIHkedHLWp1D4aqEcGdJB4IWYcqmz7USSMlqud8XCxBNhnGYEcSK0njHvAHXNDkU8gLLPGhBDO5z3VcBqByvWM6kLm9kO9wRAlDJoe37xdd+UJTEajtRNjWibNXjS1KPygUUCdvHE0221nkk4rg8TX6t+Fa52QApJhybttcXbJib+hgFXRJG+5zY0wSL7X0TGQfaCsfn+UXJYEbNH43MKgHDxvWzOHpHZ5TX/GobCFAB67x4KuYlQgfy7JvceFADc/BBJQcFML4YylddLZaegMqhj8dRfRzwFsTYLT3fvhivXaClL0pNwx7Lh9NtDY+0M4uoQCxiP8b6Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogtnHT1r5HF9iSLr0eBD55cvJrmAFLXYaTVczo+f22Y=;
 b=OY9E2mB51RCr/VlXmVAxKS0iM7tKnQku9v4jPAZCFUwPOohjvr1FE18QwWOMSLW3uc7EiglGmJKe+MTxBltMHvM7F+rtx+yy47UFUk/c64L9WSYXtzmVdE9hHeiQ1h4W/V2bUKC6VPb7rcEMSn507Q82AbubtthAFlmM79iks+eZLkeZLytowZdfvu/UkYoPMBAot0/STAtvPPDfGldHBT+ScU5yF03AxK2gcEMJqBLhnNMGSJQixOgrwGo+iZzxMLSIV70BExZYCPB3KySH7VjrWkMenuuzRFmWNH5QzgqjWG+TtFgTplCeYAw4iMcy08FlJQM4NSIsB+u6EMPcAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogtnHT1r5HF9iSLr0eBD55cvJrmAFLXYaTVczo+f22Y=;
 b=HtqCak0UR2KC9d0eSd1OM3q2OQcOWzQN8n6D3ok0UURlwUuh6qX1sFdvJ/uNxpINq6XAcdG1As6AnG6O+VW6Wl/JjFRtPZFZ9E3GXnOgwOYuWu08c5Db6v/h81zFrcUsuL6eh2vx3FzuTrKiulUYYAdLOC3WOESenO8AN/Ao5Os=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2789.namprd15.prod.outlook.com (2603:10b6:a03:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Wed, 6 May
 2020 18:24:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 18:24:47 +0000
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
From:   Yonghong Song <yhs@fb.com>
Message-ID: <8758f1c9-f4ea-af99-9af8-afe9fb210928@fb.com>
Date:   Wed, 6 May 2020 11:24:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzbySjaBQSMTET=HGD_K748GOXZZQ7zMhgtEqE-JgJGbdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0019.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:f689) by BY5PR17CA0019.namprd17.prod.outlook.com (2603:10b6:a03:1b8::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Wed, 6 May 2020 18:24:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:f689]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efb60b91-e995-41c0-29ec-08d7f1eac1f6
X-MS-TrafficTypeDiagnostic: BYAPR15MB2789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB278940343466FF27CD3BA4E1D3A40@BYAPR15MB2789.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aWIzv4v2HwShPin3hz4SBOW/ZOs04AcN4+sr9D85Txz5AaHA/3pNxwSDIaAczuF2iLrVp56Ot+kLLFaibB1rW3miXkED9gWFUhMjH15xzi/ozZOA44GHThA7OFgjKjpjvcH0LMXGN1bRUu+OR1H2RmFRiFrF/7dET8FYeS1UZ000BOsHRtwHbUTygscnkAe+p/AuwdWDICSgzPdcEfBlpLaBKN2UfXLNj7cZtVcOkviJshC8IuWOH+DIu96pVp0T3PV9JcFPEFEnV/EdjwsOkjUUjxaYqLe1BU4njAQWZHB4+knMq6K1xLycBfuZmTsyt2XPUGR/CIbTGjvUdy7F6GNjBUYCcR01WfIH3HWhLC/2JYtXh9JMFXzhG7eFzDpVketW8YWgQn0PYeDEbOFLnql7tUjXb7M6LhjmYMJNYozQdAEDAgvyajg9mklDQnwJG0AtGjcI8JVKS2Z/S6p1Tkd18SzpKmEr9v/7B657i/LM2ae/O7Tuztt10cQzkejTS2ox1fEcVlhVoH+4A6uxSRqxtaFK4H8dmLHz1XH5Dy2TXdTEMp0x9x5I+sBIawuL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(346002)(376002)(136003)(396003)(39860400002)(33430700001)(316002)(86362001)(8676002)(6916009)(36756003)(6512007)(31696002)(6486002)(33440700001)(52116002)(54906003)(186003)(66946007)(66556008)(31686004)(66476007)(16526019)(478600001)(2906002)(8936002)(53546011)(6506007)(5660300002)(4326008)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: D+avqlO9xt30uIjiCtDsR1ZWHJLvLOEw1uf8tQlGJBqZZTrfd4A3LdwNUQMNvUKrzRFUYzW4dr3DDDvlxybxCGNiLRlxRzij1HFcpCXwpDjj+XUrgxSqBAChOglQ8IRuKK/GnG03KP1ISOa3kTVgKkzz+s1znEuktPdAtIoV9ZnYBZMnQ/OPoduh0qamwtlvQtFVmPksGthEqcd8JAbnknsxY37yRjXWRaq8HyJkwsYqvwN+7OXgty+KFxQ/b0TO69y0J5fezXhURJDCPOBfVkkejKIQ51n470Zn5K1Vnq7F01NsCjp350QTZeDWgq9+r5C3CH8jELDvMwYbVZOYLZBRi0J2dXYAMNbdM6JqtORaQUYi+Aan6Jlp1G4y9YoOP2bQ5vlCoVceDRTJnlivcoxbN+Sq/Lps32cOQmdeMwPBJR0JXrFXd/XxZV5VTGt0GK40DFbKROatmR6FscNDyiAXwPoKxfW117E3LGUNyvRCEkhFkZLFnoAdLMWjWQngQEqRAtRxRCKphl8vNLdynXG8StCOt4mlmGF8jDV2eum8YGyrA/CsxnxvuDK0rk4iKJiOp9rZl9h99WR6eYwr/eK3EEdRPRy2gjJHZ+EXZmCUEbz9Op8EsIJ5SbdxLTcwpSfy9B/Sl/TGy/cFCrDDQaMxKN9zwbl3TEdPRmmI20BZFjbJN0sNmMIhytHjsMXGdQLdyX74BB7qFNF7iOwxw7PXkvRcWPn0R3C+vlE+byZlwejOU0HVHZazn84XRoMf1Bptk1G64GVIIhsJRSV5QAO3cxaGDAEbJjcbg/cdCOS+Kivbwmi+dqIkLzY0TW+8RbJG2nKC3el6lMvrJwIAfw==
X-MS-Exchange-CrossTenant-Network-Message-Id: efb60b91-e995-41c0-29ec-08d7f1eac1f6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 18:24:47.7309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfnqZlXVmhncw0VnlfU87s6aIIrk41swBOUUA+EHcdwhNcWdTnGYjqXpFLmVdw61
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2789
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/20 12:30 AM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Only the tasks belonging to "current" pid namespace
>> are enumerated.
>>
>> For task/file target, the bpf program will have access to
>>    struct task_struct *task
>>    u32 fd
>>    struct file *file
>> where fd/file is an open file for the task.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> I might be missing some subtleties with task refcounting for task_file
> iterator, asked few questions below...
> 
>>   kernel/bpf/Makefile    |   2 +-
>>   kernel/bpf/task_iter.c | 336 +++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 337 insertions(+), 1 deletion(-)
>>   create mode 100644 kernel/bpf/task_iter.c
>>
>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>> index b2b5eefc5254..37b2d8620153 100644
>> --- a/kernel/bpf/Makefile
>> +++ b/kernel/bpf/Makefile
>> @@ -2,7 +2,7 @@
>>   obj-y := core.o
>>   CFLAGS_core.o += $(call cc-disable-warning, override-init)
>>
>> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o
>> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o
>>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>>   obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> new file mode 100644
>> index 000000000000..1ca258f6e9f4
>> --- /dev/null
>> +++ b/kernel/bpf/task_iter.c
>> @@ -0,0 +1,336 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (c) 2020 Facebook */
>> +
>> +#include <linux/init.h>
>> +#include <linux/namei.h>
>> +#include <linux/pid_namespace.h>
>> +#include <linux/fs.h>
>> +#include <linux/fdtable.h>
>> +#include <linux/filter.h>
>> +
>> +struct bpf_iter_seq_task_common {
>> +       struct pid_namespace *ns;
>> +};
>> +
>> +struct bpf_iter_seq_task_info {
>> +       struct bpf_iter_seq_task_common common;
> 
> you have comment below in init_seq_pidns() that common is supposed to
> be the very first field, but I think it's more important and
> appropriate here, so that whoever adds anything here knows that order
> of field is important.

I can move the comments here.

> 
>> +       struct task_struct *task;
>> +       u32 id;
>> +};
>> +
> 
> [...]
> 
>> +static int __task_seq_show(struct seq_file *seq, void *v, bool in_stop)
>> +{
>> +       struct bpf_iter_meta meta;
>> +       struct bpf_iter__task ctx;
>> +       struct bpf_prog *prog;
>> +       int ret = 0;
>> +
>> +       meta.seq = seq;
>> +       prog = bpf_iter_get_info(&meta, in_stop);
>> +       if (prog) {
> 
> 
> nit: `if (!prog) return 0;` here would reduce nesting level below
> 
>> +               meta.seq = seq;
>> +               ctx.meta = &meta;
>> +               ctx.task = v;
>> +               ret = bpf_iter_run_prog(prog, &ctx);
>> +       }
>> +
>> +       return 0;
> 
> return **ret**; ?

It should return "ret". In task_file show() code is similar but correct.
I can do early return with !prog too although we do not have
deep nesting level yet.

> 
>> +}
>> +
> 
> [...]
> 
>> +
>> +static struct file *task_file_seq_get_next(struct pid_namespace *ns, u32 *id,
>> +                                          int *fd, struct task_struct **task,
>> +                                          struct files_struct **fstruct)
>> +{
>> +       struct files_struct *files;
>> +       struct task_struct *tk;
>> +       u32 sid = *id;
>> +       int sfd;
>> +
>> +       /* If this function returns a non-NULL file object,
>> +        * it held a reference to the files_struct and file.
>> +        * Otherwise, it does not hold any reference.
>> +        */
>> +again:
>> +       if (*fstruct) {
>> +               files = *fstruct;
>> +               sfd = *fd;
>> +       } else {
>> +               tk = task_seq_get_next(ns, &sid);
>> +               if (!tk)
>> +                       return NULL;
>> +
>> +               files = get_files_struct(tk);
>> +               put_task_struct(tk);
> 
> task is put here, but is still used below.. is there some additional
> hidden refcounting involved?

Good question. I had an impression that we take a reference count
for task->files so task should not go away. But reading linux
code again, I do not have sufficient evidence to back my claim.
So I will reference count task as well, e.g., do not put_task_struct()
until all files are done here.

> 
>> +               if (!files) {
>> +                       sid = ++(*id);
>> +                       *fd = 0;
>> +                       goto again;
>> +               }
>> +               *fstruct = files;
>> +               *task = tk;
>> +               if (sid == *id) {
>> +                       sfd = *fd;
>> +               } else {
>> +                       *id = sid;
>> +                       sfd = 0;
>> +               }
>> +       }
>> +
>> +       rcu_read_lock();
>> +       for (; sfd < files_fdtable(files)->max_fds; sfd++) {
> 
> files_fdtable does rcu_dereference on each iteration, would it be
> better to just cache files_fdtable(files)->max_fds into local
> variable? It's unlikely that there will be many iterations, but
> still...

I borrowed code from fs/proc/fd.c. But I can certainly to avoid
repeated reading max_fds as suggested.

> 
>> +               struct file *f;
>> +
>> +               f = fcheck_files(files, sfd);
>> +               if (!f)
>> +                       continue;
>> +               *fd = sfd;
>> +               get_file(f);
>> +               rcu_read_unlock();
>> +               return f;
>> +       }
>> +
>> +       /* the current task is done, go to the next task */
>> +       rcu_read_unlock();
>> +       put_files_struct(files);
>> +       *fstruct = NULL;
> 
> *task = NULL; for completeness?

if *fstruct == NULL, will try to get next task, so *task = NULL
is unnecessary, but I can add it, won't hurt and possibly make
it easy to understand.

> 
>> +       sid = ++(*id);
>> +       *fd = 0;
>> +       goto again;
>> +}
>> +
>> +static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
>> +{
>> +       struct bpf_iter_seq_task_file_info *info = seq->private;
>> +       struct files_struct *files = NULL;
>> +       struct task_struct *task = NULL;
>> +       struct file *file;
>> +       u32 id = info->id;
>> +       int fd = info->fd;
>> +
>> +       file = task_file_seq_get_next(info->common.ns, &id, &fd, &task, &files);
>> +       if (!file) {
>> +               info->files = NULL;
> 
> what about info->task here?

info->files == NULL indicates the end of iteration, info->task will not 
be checked any more. But I guess, I can assign NULL to task as well to
avoid confusion.

> 
>> +               return NULL;
>> +       }
>> +
>> +       ++*pos;
>> +       info->id = id;
>> +       info->fd = fd;
>> +       info->task = task;
>> +       info->files = files;
>> +
>> +       return file;
>> +}
>> +
> 
> [...]
> 
>> +
>> +struct bpf_iter__task_file {
>> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
>> +       __bpf_md_ptr(struct task_struct *, task);
>> +       u32 fd;
> 
> nit: sort of works by accident (due to all other field being 8-byte
> aligned pointers), shall we add __attribute__((aligned(8)))?

This is what I thought as well. It should work. But I think
add aligned(8) wont' hurt to expresss the intention.. Will add it.

> 
>> +       __bpf_md_ptr(struct file *, file);
>> +};
>> +
> 
> [...]
> 
