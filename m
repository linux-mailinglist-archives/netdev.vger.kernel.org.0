Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F373B1A8F6C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 02:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634522AbgDNX7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:59:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727849AbgDNX7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:59:41 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03ENwCXm006698;
        Tue, 14 Apr 2020 16:59:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=sIqbxY4OgeZFV7HzPCx9UEKUD0KJ7VJq4xcp+WQYFko=;
 b=hGZN3W8Qid7nHhGK1TgIk6BX6qXdgf5zE15QM0cVUM/qnwXBB4g01JmLZMuZlHARzP5p
 tVlXsgRx2wdi2LZje0S6xFLwLUNHQYcP85V0Gf3KlWNZo74AdtxwN4G4WE/EMeXGcsb+
 ethVT9lq1dhXQ/yB0bw6NAqWI+xmYBgRbQ4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7fryr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Apr 2020 16:59:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 14 Apr 2020 16:59:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eY1ED8CoQwU3jSDVTPvV/qGXMAIfCWIk2hNsscJ+JxAs+INsxoziNdw8cC6N7HkdjJS0C6oQyygODayITq63kxT/s0iVIIW4NyzFTwnOpATy+i+hyShvssXQySL5NrPG5K6PhZnzsecTrARTIQ01ydA4YeibgFEjzZ14xWUDGzhoWJCgLyxVXfk8l2/ASB3iaUwCTLj67VbpotY1X1c1aqUZV/kTZi5BxaonyUjKpp6wwc5Gz6SPqPtNIVkjCTnvsHOTcCMkFFjLnQLbiXdlmER2SRzG/sjCmUoGENGRFu5ilOm0DnnmuISwR2eWScDuIUYtd5NwRObzMZa+LO8dvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIqbxY4OgeZFV7HzPCx9UEKUD0KJ7VJq4xcp+WQYFko=;
 b=CYYdi2bkUzPFtaQ+j9olF9/5GBp9Cl7wEloerSfBNtxIKUFh+LrwpLg1kXgXf8QTdVx5lJefvFcWcFYD/zlkha+qzaSXcWuHAatjYMkglrToBmDCxTQF2gQPBC6ZBe8Fsy9GLHs2QlmSERt9HwDPiI0xjY3tIFmr2Ibq7ncI8TCGfmlGpZOTPEZqwRXwXFbV1pvAVAgKRDLnPG/KcfIEfiyNGyzrYGNxHHT5FmjnWOoyaqYfp4ZiWWRz1sMyChPg8b6K0rGJ7ipZguEnsv5RCGS49dVffMqYvuaBw3k1gCeOTECELwVvJWkGt1+v9yc770fUSnZ7s47vFKxsnpfPJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sIqbxY4OgeZFV7HzPCx9UEKUD0KJ7VJq4xcp+WQYFko=;
 b=D84eW+chZyiOHZlgEkQwPlNKLNeZ8Ho3eMLqodUHK3mF8SYhhxRQ8i3jyQnhUh4g49CVbgtw1sR9CqLXTfRV+p2PwmtSfJ00aqVp+WW6+oFGDignBk3d5BSK2qAyhDP9lN+XTG3nKSBXhoebVCo2/kqO0Q+/XkF0ZSCkldW89Yc=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3835.namprd15.prod.outlook.com (2603:10b6:303:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Tue, 14 Apr
 2020 23:59:24 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 23:59:24 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4bf72b3c-5fee-269f-1d71-7f808f436db9@fb.com>
Date:   Tue, 14 Apr 2020 16:59:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4Bzawu2dFXL7nvYhq1tKv9P7Bb9=6ksDpui5nBjxRrx=3_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:300:6c::13) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:2316) by MWHPR04CA0051.namprd04.prod.outlook.com (2603:10b6:300:6c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24 via Frontend Transport; Tue, 14 Apr 2020 23:59:23 +0000
X-Originating-IP: [2620:10d:c090:400::5:2316]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46344bc9-01e4-4cb4-2b4c-08d7e0cfdbb7
X-MS-TrafficTypeDiagnostic: MW3PR15MB3835:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB383569191DDAD50644BBE617D3DA0@MW3PR15MB3835.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(396003)(376002)(346002)(136003)(366004)(39860400002)(6916009)(5660300002)(8676002)(31686004)(6506007)(2616005)(2906002)(16526019)(53546011)(186003)(81156014)(478600001)(54906003)(36756003)(316002)(4326008)(8936002)(86362001)(31696002)(6486002)(66476007)(6666004)(66556008)(52116002)(66946007)(6512007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZiFW771Ta1W16j4UJzTJZmt8LV5z6GS/O7bXTycurJq1sBosejX9iwL6jdRLJgq/4d75wftExgtzVjq8e72X/e9yBYQAa+6FRhHaV+XqUtZrcjHgJ4TNdk0VFn5f85GSr7SMQoeTGwXiRjlcVURDVCPPssWnwCUjIIDbFwl8GZapxYHr0lGO6eb61QdbKwXY0mWL0QzUZPCWMlEgEsKozQGoWW3o7/uZqKMf60Ptj9a6SIb9JHpKH26cn+yAn8y6J2X5YPiuvMWU57wwhqny7YlAq6xV/vNJAL9opR5cDw6ECUsT6+cj2RjGnz2bXTqTuCWdtjxubUsI2AdsxIvT9pJaAXlE/uAgkDgLYZnBH9ipFJk89norndnVIz39Urg2WzQlnllIUmDxKbitLchEYSLkQo/NQpNrTXz99B4jXMfGyWj3GN3sCFz8NJbJaKg+
X-MS-Exchange-AntiSpam-MessageData: isr9ZNPo8EPtBvtU3EGYY+TyuQ94/KTIifQpimBc5SC2vrTTJQsy1bbAkL8jXzpXA1Gzhc3OioJRaMXQQWGi9Xa1DePlGNWJ/2y0knG6jdE4rkeU+5DK6kublXJEwcq6KxafFYt+iLUaxYPzsPHlEWNtiMS7nvuZDwmormci60l+UHlJAOa1xXu2F59GG8kk
X-MS-Exchange-CrossTenant-Network-Message-Id: 46344bc9-01e4-4cb4-2b4c-08d7e0cfdbb7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 23:59:24.7242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cYGdKAmuwpvleUDyrJ7zPbLVwPmO/L4MBMoUnHUhVMioj+oBPaCVlqByR4AVx6cg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3835
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_11:2020-04-14,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004140173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/20 10:56 PM, Andrii Nakryiko wrote:
> On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Given a loaded dumper bpf program, which already
>> knows which target it should bind to, there
>> two ways to create a dumper:
>>    - a file based dumper under hierarchy of
>>      /sys/kernel/bpfdump/ which uses can
>>      "cat" to print out the output.
>>    - an anonymous dumper which user application
>>      can "read" the dumping output.
>>
>> For file based dumper, BPF_OBJ_PIN syscall interface
>> is used. For anonymous dumper, BPF_PROG_ATTACH
>> syscall interface is used.
> 
> We discussed this offline with Yonghong a bit, but I thought I'd put
> my thoughts about this in writing for completeness. To me, it seems
> like the most consistent way to do both anonymous and named dumpers is
> through the following steps:

The main motivation for me to use bpf_link is to enumerate
anonymous bpf dumpers by using idr based link_query mechanism in one
of previous Andrii's RFC patch so I do not need to re-invent the wheel.

But looks like there are some difficulties:

> 
> 1. BPF_PROG_LOAD to load/verify program, that created program FD.
> 2. LINK_CREATE using that program FD and direntry FD. This creates
> dumper bpf_link (bpf_dumper_link), returns anonymous link FD. If link

bpf dump program already have the target information as part of
verification propose, so it does not need directory FD.
LINK_CREATE probably not a good fit here.

bpf dump program is kind similar to fentry/fexit program,
where after successful program loading, the program will know
where to attach trampoline.

Looking at kernel code, for fentry/fexit program, at raw_tracepoint_open
syscall, the trampoline will be installed and actually bpf program will
be called.

So, ideally, if we want to use kernel bpf_link, we want to
return a cat-able bpf_link because ultimately we want to query
file descriptors which actually 'read' bpf program outputs.

Current bpf_link is not cat-able.
I try to hack by manipulating fops and other stuff, it may work,
but looks ugly. Or we create a bpf_catable_link and build an 
infrastructure around that? Not sure whether it is worthwhile for this 
one-off thing (bpfdump)?

Or to query anonymous bpf dumpers, I can just write a bpf dump program
to go through all fd's to find out.

BTW, my current approach (in my private branch),
anonymous dumper:
    bpf_raw_tracepoint_open(NULL, prog) -> cat-able fd
file dumper:
    bpf_obj_pin(prog, path)  -> a cat-able file

If you consider program itself is a link, this is like what
described below in 3 and 4.


> FD is closed, dumper program is detached and dumper is destroyed
> (unless pinned in bpffs, just like with any other bpf_link.
> 3. At this point bpf_dumper_link can be treated like a factory of
> seq_files. We can add a new BPF_DUMPER_OPEN_FILE (all names are for
> illustration purposes) command, that accepts dumper link FD and
> returns a new seq_file FD, which can be read() normally (or, e.g.,
> cat'ed from shell).

In this case, link_query may not be accurate if a bpf_dumper_link
is created but no corresponding bpf_dumper_open_file. What we really
need to iterate through all dumper seq_file FDs.

> 4. Additionally, this anonymous bpf_link can be pinned/mounted in
> bpfdumpfs. We can do it as BPF_OBJ_PIN or as a separate command. Once
> pinned at, e.g., /sys/fs/bpfdump/task/my_dumper, just opening that
> file is equivalent to BPF_DUMPER_OPEN_FILE and will create a new
> seq_file that can be read() independently from other seq_files opened
> against the same dumper. Pinning bpfdumpfs entry also bumps refcnt of
> bpf_link itself, so even if process that created link dies, bpf dumper
> stays attached until its bpfdumpfs entry is deleted.
> 
> Apart from BPF_DUMPER_OPEN_FILE and open()'ing bpfdumpfs file duality,
> it seems pretty consistent and follows safe-by-default auto-cleanup of
> anonymous link, unless pinned in bpfdumpfs (or one can still pin
> bpf_link in bpffs, but it can't be open()'ed the same way, it just
> preserves BPF program from being cleaned up).
> 
> Out of all schemes I could come up with, this one seems most unified
> and nicely fits into bpf_link infra. Thoughts?
> 
>>
>> To facilitate target seq_ops->show() to get the
>> bpf program easily, dumper creation increased
>> the target-provided seq_file private data size
>> so bpf program pointer is also stored in seq_file
>> private data.
>>
>> Further, a seq_num which represents how many
>> bpf_dump_get_prog() has been called is also
>> available to the target seq_ops->show().
>> Such information can be used to e.g., print
>> banner before printing out actual data.
>>
>> Note the seq_num does not represent the num
>> of unique kernel objects the bpf program has
>> seen. But it should be a good approximate.
>>
>> A target feature BPF_DUMP_SEQ_NET_PRIVATE
>> is implemented specifically useful for
>> net based dumpers. It sets net namespace
>> as the current process net namespace.
>> This avoids changing existing net seq_ops
>> in order to retrieve net namespace from
>> the seq_file pointer.
>>
>> For open dumper files, anonymous or not, the
>> fdinfo will show the target and prog_id associated
>> with that file descriptor. For dumper file itself,
>> a kernel interface will be provided to retrieve the
>> prog_id in one of the later patches.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h            |   5 +
>>   include/uapi/linux/bpf.h       |   6 +-
>>   kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
>>   kernel/bpf/syscall.c           |  11 +-
>>   tools/include/uapi/linux/bpf.h |   6 +-
>>   5 files changed, 362 insertions(+), 4 deletions(-)
>>
> 
> [...]
> 
