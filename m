Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90332CF46B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgLDSzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:55:47 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729780AbgLDSzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:55:47 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Is9tR029883;
        Fri, 4 Dec 2020 10:54:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=wH3QmWXJANZPOgzUw+3IBOepsWKFys5WCKiWtGOBcIM=;
 b=dfVynZ7wP6FoBxYaO5vCWG9qhBlMIrUy89CUqkgJdPecXR4xueoW//mshZtPJ1vFM3bD
 2uKQe2g40fEsf1bm5apmLA7mlU6DE08/bP4sOPsWlCPuNa3zd6i7st3az9nCReDD52T4
 JAJnHtJ4zznOQMiifEKk4xJiA6L7SzGzJqc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 357tfmr4e1-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Dec 2020 10:54:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 10:54:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBRmjkCnL0BhCfqjKzCV5IH4C9+X4AtjRR/dhLDLH4xD45bjDizeRCZ8iXaqkfeQDrO9s1KduCzATQt0ly0eCL93M7fOstpoNJO2kIIyE52/2QEA80ZyX8/DPiw24gqE7hrF/XKRAuCA+OiJdKIFaDTxkb2auudyWzvveZ9CP7wS9xbNMt5s0CLw02ZVeEIyflMt/Db1Fw96jF4KDetLDXQBdhJ604Ug09U1f1Jw9ODMBMkyCkCctVs+VmSfYW9X/Dpqh76X3heq4dPrhSJZKhpvBhm4JMF1xglJ5XLe9GAaJSWa9GctosKKbvVmI79Qcpt1MTbEX5Yew6qWePZ6+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wH3QmWXJANZPOgzUw+3IBOepsWKFys5WCKiWtGOBcIM=;
 b=bTzQ1MKaJvk8SWs2X1NpPWfFZd8Ux1lD9IWBmjkPCGi7PfX/7pZtEMCyEdwN0/35VJKuX/6WzHCrE0pvvhytu+SSY2h66Tn5hmjYwErGSPcYnSQOFmrkvTALLzhESoo61GNPKSWllRndf8WvOMpuYX6UdeaGMblBrQt/LiI3rLOLG4XKiyLIufMvtZBJUK+TBzGloHu61zSLvtpENTomydCjWmsgGjoL1TmZFkVRqtLiA3lN37rDUIjrF4yZNKVIdd+OfUx8C0HrVTjJc1UxZjp5o8pMkhApwyiS1+4J4IeZ+UVtI7lD7Mzydk+9xxZWwRuqoDJwtfH43Ief76Mw5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wH3QmWXJANZPOgzUw+3IBOepsWKFys5WCKiWtGOBcIM=;
 b=jhCre4gYQPoshgwFLh3Wmn3FQZ4HoR1OVSCSAMYKK3B0jfyzzSbIdYOhV3Hi7rMfV5xxxLpdVw8lxJwbaYtu961ZSZUdCulQ8I26Ssdf0Nt6qlPyOXKhEc5y74UP9oCspylVpGLyUnFja0Ma+JyNJHUvxoLHFWMcmy4M5L98vm0=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 18:54:48 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 18:54:48 +0000
Subject: Re: [PATCH v2 bpf-next] bpf: increment and use correct thread
 iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
References: <20201204034302.2123841-1-jonathan.lemon@gmail.com>
 <2b90f131-5cb0-3c67-ea2e-f2c66ad918a7@fb.com>
 <20201204171452.bl4foim6x7nf3vvn@bsd-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ad119bd4-7c92-c623-1137-56345db38c7d@fb.com>
Date:   Fri, 4 Dec 2020 10:54:45 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201204171452.bl4foim6x7nf3vvn@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:fab1]
X-ClientProxiedBy: MWHPR19CA0004.namprd19.prod.outlook.com
 (2603:10b6:300:d4::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::12b3] (2620:10d:c090:400::5:fab1) by MWHPR19CA0004.namprd19.prod.outlook.com (2603:10b6:300:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 18:54:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afbff1ed-f6e7-4287-ca66-08d89886128e
X-MS-TrafficTypeDiagnostic: BYAPR15MB3192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3192CAE5C3D5C8704811D9DBD3F10@BYAPR15MB3192.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R+FRQUG1xFbHAQKgF+vb3D79Pr2CMfrUygl941skltF+VZFqR4Fa0iQXOPVQWUa5o+i2IBVL80UqhqUyaJF5EpyFyOk3PJkqZn1INoBZNXL0ykD95s+AdawF2QwfU0jQxIPldEY5TM9V4VvaUeIhId+T9zJcTQtNT64qdgKOXlzSXZCCUdwXuW5Y210lRiYSCcCglL5zVIbd67t1TSlUHEC53l7e9K/Ag4DrBBg6XweuKUW6RYa4EN2/2ve1mB5JZW1L4APi7ql4uXwtZLb41mNWIE5PJvfJrQkEsgtrdw748dA5TI9ILac/2E345qDg6ofC8MOh8AzVTEebvJQKbSZzA1Uo8NtmAVg+Nv60j5a0aQINvitYnj1N4Gmyy/vG4l4CzvPw/cHx8CCB/roAb3AvFj2wQ0I/95NezXpJsNA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(346002)(366004)(136003)(6916009)(86362001)(53546011)(8936002)(16526019)(8676002)(5660300002)(31686004)(186003)(4326008)(83380400001)(2906002)(52116002)(316002)(478600001)(31696002)(66556008)(36756003)(66476007)(66946007)(2616005)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OXlqdEh3WEcrMy95Y1lRdjhnVzRySTdkSHIrd2tubVdxZ0tCalBJZHM3cmcy?=
 =?utf-8?B?a3Y2eU8xOTNjUWVINkIvZHRwVVRua1R0aUdNVS81dlBnL2tGRDczbmprUFBo?=
 =?utf-8?B?cytXT3hYbUs3d3hMNlUyT0w2d2FOZDRnSUtKL3dNaW5oTGVDRzluSjlxSStM?=
 =?utf-8?B?akJVS0VXYUIyeDNOb2RUdG5sZVFjRHBKS3VQZnRrem9kTHExb21uUVF1eUN6?=
 =?utf-8?B?aWtTYTJMNjNqUHRKZldXV0x1VjcrRlYyYnRiS05GNXQ3VTVsTllNaEFZUWJT?=
 =?utf-8?B?dUpqWmdmQWMwemRlend4QkE0ZEtyVHB5bXpSZGs5MUplYk5RelNjYUpLVUJy?=
 =?utf-8?B?QUdOS2xTTUI0TkI3R1Z0cDBJSTF4TkdoY2pyZVE3elo2dFQrclFMNDNqRE5B?=
 =?utf-8?B?ckkvRUxQbG9EU3M0OHU4WmlERHlybkN4Wm13K2o5SEdHRzVPVTk3NEJvazRu?=
 =?utf-8?B?dEJNVkQvb2JaRE1qVU5CQUxiZEtjd2liZEViTHhpUGxic04rU00wVkJhenNh?=
 =?utf-8?B?aW15NitMUG1FditCVnpIcklMUFBmRzRzZnBYY1V0cW4wakR2cnBPLytXaEtC?=
 =?utf-8?B?emF4WGFnanpQOS8rVER5THpWVHpGQklEWDlGM2h4aDNLbmhxNjdIL0w3TmtH?=
 =?utf-8?B?elJvNEtoc0ZWOHVsZUlBeExlRjRRRWpaaVlSTXV1VFM5eGNRdVdpdnBBUWVP?=
 =?utf-8?B?RjlCMnYyWTAwNHlBK1E5S1JTS1FieDdjYjBFeXZ5L0V1ZWM5blQ5NDlNcDVY?=
 =?utf-8?B?cG9JVVlWeDJaK1VJcDgycVh1elk5VVQxc2hJZzd5bXZmY1krby9uMkZKMWMr?=
 =?utf-8?B?bkVpNDVPQk1lbENrV2pjVlJ0QzBvSG9ySjlLbVZlNFdnd1BxenZ1VXVSN0hj?=
 =?utf-8?B?Y3h2eHhVQzBWaEtmUUFDNk5nSFQxMm5JRGpvUTh6Tm1YN1NCZ1huOVVFTWQ0?=
 =?utf-8?B?aHFGNVRjV1dUb3RGT1FLV1ZkeWNlb2dlL2tzREZKK1MxZnFiQmN3VHp5ZGxQ?=
 =?utf-8?B?cldlWU1peEUvUll5RnFBLzF2M3VSM0pXK0R1SmpCV1I1dXlmbUhtcks3Nnh5?=
 =?utf-8?B?eG5ya3c5eXU0K2hXMDl2SFowT3AxZFlWVnV2Mk51NldMbXkyK1d5YmlUUlFn?=
 =?utf-8?B?TWlMNGJweUNVVXRoL3BPR1JBbHFCamNRYzBhMEExRXpaVWJ2UEdZUUl5dVdJ?=
 =?utf-8?B?YVZFNlVkZUFSLzg1SHNtQ3JmTkF5NmFMMXIveFJzOTJFV3dpeDM0Y0p5OUEx?=
 =?utf-8?B?QUhZSXhLbGs5MnVVT0p5aXprNmxma3BYVHFwZTR1SVJlQk54Q01nbFQwQTVy?=
 =?utf-8?B?aUU1cGxZS3Izcy9XVzJzejdIemRJdms2aG5rekd2cEFKdW96R0xNMjgydmcx?=
 =?utf-8?B?Y1BETUt4cWZGVWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: afbff1ed-f6e7-4287-ca66-08d89886128e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 18:54:47.9281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouOmOBm4v8m4c43fZgy6wdplzHbzjaAXQ8uHxEMaF4EmmCcRCKINbJ6KO/gN1O5J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_08:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 spamscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012040107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/20 9:14 AM, Jonathan Lemon wrote:
> On Fri, Dec 04, 2020 at 12:01:53AM -0800, Yonghong Song wrote:
>>
>>
>> On 12/3/20 7:43 PM, Jonathan Lemon wrote:
>>> From: Jonathan Lemon <bsd@fb.com>
>>
>> Could you explain in the commit log what problem this patch
>> tries to solve? What bad things could happen without this patch?
> 
> Without the patch, on a particular set of systems, RCU will repeatedly
> generate stall warnings similar to the trace below.  The common factor
> for all the traces seems to be using task_file_seq_next().  With the
> patch, all the warnings go away.
> 
>   rcu: INFO: rcu_sched self-detected stall on CPU
>   rcu: \x0910-....: (20666 ticks this GP) idle=4b6/1/0x4000000000000002 softirq=14346773/14346773 fqs=5064
>   \x09(t=21013 jiffies g=25395133 q=154147)
>   NMI backtrace for cpu 10
>   #1
>   Hardware name: Quanta Leopard ORv2-DDR4/Leopard ORv2-DDR4, BIOS F06_3B17 03/16/2018
>   Call Trace:
>    <IRQ>
>    dump_stack+0x50/0x70
>    nmi_cpu_backtrace.cold.6+0x13/0x50
>    ? lapic_can_unplug_cpu.cold.30+0x40/0x40
>    nmi_trigger_cpumask_backtrace+0xba/0xca
>    rcu_dump_cpu_stacks+0x99/0xc7
>    rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
>    ? tick_sched_do_timer+0x60/0x60
>    update_process_times+0x24/0x50
>    tick_sched_timer+0x37/0x70
>    __hrtimer_run_queues+0xfe/0x270
>    hrtimer_interrupt+0xf4/0x210
>    smp_apic_timer_interrupt+0x5e/0x120
>    apic_timer_interrupt+0xf/0x20
>    </IRQ>
>   RIP: 0010:find_ge_pid_upd+0x5/0x20
>   Code: 80 00 00 00 00 0f 1f 44 00 00 48 83 ec 08 89 7c 24 04 48 8d 7e 08 48 8d 74 24 04 e8 d5 d3 9a 00 48 83 c4 08 c3 0f 1f 44 00 00 <48> 89 f8 48 8d 7e 08 48 89 c6 e9 bc d3 9a 00 cc cc cc cc cc cc cc
>   RSP: 0018:ffffc9002b7abdb8 EFLAGS: 00000297 ORIG_RAX: ffffffffffffff13
>   RAX: 00000000002ca5cd RBX: ffff889c44c0ba00 RCX: 0000000000000000
>   RDX: 0000000000000002 RSI: ffffffff8284eb80 RDI: ffffc9002b7abdc4
>   RBP: ffffc9002b7abe0c R08: ffff8895afe93a00 R09: ffff8891388abb50
>   R10: 000000000000000c R11: 00000000002ca600 R12: 000000000000003f
>   R13: ffffffff8284eb80 R14: 0000000000000001 R15: 00000000ffffffff
>    task_seq_get_next+0x53/0x180
>    task_file_seq_get_next+0x159/0x220
>    task_file_seq_next+0x4f/0xa0
>    bpf_seq_read+0x159/0x390
>    vfs_read+0x8a/0x140
>    ksys_read+0x59/0xd0
>    do_syscall_64+0x42/0x110
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> 
>>> If unable to obtain the file structure for the current task,
>>> proceed to the next task number after the one returned from
>>> task_seq_get_next(), instead of the next task number from the
>>> original iterator.
>> This seems a correct change. The current code should still work
>> but it may do some redundant/unnecessary work in kernel.
>> This only happens when a task does not have any file,
>> no sure whether this is the culprit for the problem this
>> patch tries to address.
>>
>>>
>>> Use thread_group_leader() instead of comparing tgid vs pid, which
>>> might may be racy.
>>
>> I see
>>
>> static inline bool thread_group_leader(struct task_struct *p)
>> {
>>          return p->exit_signal >= 0;
>> }
>>
>> I am not sure whether thread_group_leader(task) is equivalent
>> to task->tgid == task->pid or not. Any documentation or explanation?
>>
>> Could you explain why task->tgid != task->pid in the original
>> code could be racy?
> 
> My understanding is that anything which uses pid_t for comparision
> in the kernel is incorrect.  Looking at de_thread(), there is a
> section which swaps the pid and tids around, but doesn't seem to
> change tgid directly.
> 
> There's also this comment in linux/pid.h:
>          /*
>           * Both old and new leaders may be attached to
>           * the same pid in the middle of de_thread().
>           */
> 
> So the safest thing to do is use the explicit thread_group_leader()
> macro rather than trying to open code things.

in de_thread(), I see p->exit_signal (used in thread_group_leader())
has race as well.

...
                 exchange_tids(tsk, leader);
                 transfer_pid(leader, tsk, PIDTYPE_TGID);
                 transfer_pid(leader, tsk, PIDTYPE_PGID);
                 transfer_pid(leader, tsk, PIDTYPE_SID);

                 list_replace_rcu(&leader->tasks, &tsk->tasks);
                 list_replace_init(&leader->sibling, &tsk->sibling);

                 tsk->group_leader = tsk;
                 leader->group_leader = tsk;

                 tsk->exit_signal = SIGCHLD;
                 leader->exit_signal = -1;

                 BUG_ON(leader->exit_state != EXIT_ZOMBIE);
                 leader->exit_state = EXIT_DEAD;
...

But I am not sure how this race or pid race could impact
task traversal differently.

> 
> 
>>> Only obtain the task reference count at the end of the RCU section
>>> instead of repeatedly obtaining/releasing it when iterathing though
>>> a thread group.
>>
>> I think this is an optimization and not about the correctness.
> 
> Yes, but the loop in question can be executed thousands of times, and
> there isn't much point in doing this needless work.  It's unclear
> whether this is a significant time contribution to the RCU stall,
> but reducing the amount of refcounting isn't a bad thing.

Sure. Totally agree.
