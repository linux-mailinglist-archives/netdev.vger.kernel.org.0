Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D58F2D49BA
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbgLITDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:03:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37128 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730088AbgLITDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 14:03:53 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9Idiln009464;
        Wed, 9 Dec 2020 11:02:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ASrKwipcH19nsEj9VfejKOxvai7f8gGKP8n8PofQekw=;
 b=c0rVzVHo1kS0T3PB5T+DG01IAaNCjy5b1vq6W7mW/0rEkv6ACUxAxC2yDojCjq9VtZ5t
 mqLTBcrTio/aywSMj4UMHLur5PXZCnDi5XR5G0WvgZH/XDpuXdXyatZMZzQ6piYzC4fZ
 1prRX2MSkOYLRA86NXZeww2P8Up1y6ljpsI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35a66x4wwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 11:02:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 11:02:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m7L1eL3aijI4w077AmDl8Q90eYd3qZGmtjSNZM2dpIxsNYvYwarI9kvpqfNaCMpRcR3ISVznXS1UIF/gEsD22S/fghOEUay+d4bTOauPaTgjqZHUUo0k6F2g8fDHcB+l7TuCcM4wwoIda81yOf7ASK7/70PR+L/GyYjO2/JOHoz1gbEqNGoBangesi1kTzO+n4dn/EAvm65ODEbfX7oKBl9Ny2ismI0T/LLlCPh17wD9bfGf3P3lHbQpjKnleYbrShOkYeS4uSKyLA1VONMSntfkKklq3nGf6l5I9EiB/h5A4nSFi8C1fE/U2voDtMgWICtmpR1ZRjVm4f7GiBazgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASrKwipcH19nsEj9VfejKOxvai7f8gGKP8n8PofQekw=;
 b=fCgWByMPqrNhHhMC6b+h3oiO+pR5HIQrr+3CwxXN+EAZhPBppN3dYOqMlZyKrF2Wv7J5YAErK4k6acETJfaGPvTmPQ5bTslwkqsa63PeMui+guF8Lf7MaLNp/8jLz18XdZQkYkqzjq3EWeXhxHYcZvGgSmh/bw63V1ZeAT1pczuA9Szt7+DfgZEBaHpXOTj05Ci00SHWoyhbZN3YgvhzFo/N7+XqEd4ynUcLqtnd7KSspdDI4Pfux6Om9k4icqPxD2VrpAWcEpuZQQr0YqNBAuC/KkBSE0pkuSAqji8Xe/cmfUhk8vB1aFIiWC4mK60lvi+UPzGTj6/GVe8yF6abcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASrKwipcH19nsEj9VfejKOxvai7f8gGKP8n8PofQekw=;
 b=Z6iFKr/oRRe3AxlXeuIzCsVISGtk2FnzlnBp/1SkrkuT39A1G27Ce417nLuxZRavZqFEn/D0jUkD4Szuh68rz5okvzzvIXtUA+MvzNaZT3l+8QpyDcqDW0GRFVRuvS9IFuEOs6v3f9EE03rdkW//bAnN94f48jcQe/p0iFXGquU=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2822.namprd15.prod.outlook.com (2603:10b6:a03:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Wed, 9 Dec
 2020 19:02:55 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3632.021; Wed, 9 Dec 2020
 19:02:55 +0000
Subject: Re: [PATCH v2 bpf-next] bpf: increment and use correct thread
 iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
References: <20201204034302.2123841-1-jonathan.lemon@gmail.com>
 <2b90f131-5cb0-3c67-ea2e-f2c66ad918a7@fb.com>
 <20201204171452.bl4foim6x7nf3vvn@bsd-mbp.dhcp.thefacebook.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e6e8dd8c-f537-bea8-93ac-4badd3234c85@fb.com>
Date:   Wed, 9 Dec 2020 11:02:54 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201204171452.bl4foim6x7nf3vvn@bsd-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:3517]
X-ClientProxiedBy: BY3PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:254::16) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::113f] (2620:10d:c090:400::5:3517) by BY3PR05CA0011.namprd05.prod.outlook.com (2603:10b6:a03:254::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Wed, 9 Dec 2020 19:02:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07ba8cd3-8337-4b88-e28f-08d89c75096f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2822:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2822F70D9A7B08672D89CDD8D3CC0@BYAPR15MB2822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZY1WgeBv8idCDAv/aRfYwu4lWkWyPUwfbf4UMFTFhIyKwcUTyk/pxF/6vhXYGBpitJbH5UesJCDuq2ZMGMmQ7TkupS5mwVrEZ0PyKsO4rpKTMPPeA2gvjxTypK5JPb+KT2xFHd2I1NprtqLEbGWlIumnysyQ3A63JFqdmv8DcWGC1biU7LMf8jLwtb/oGmWvYxRdvycNkzSshv08mfgGfMFjYEHwA8uVgDqj5q/uJhG+M1xwGyytZB4iOfLy3diXDDAP7H4HvjYz+k8MgXrBZIlGu2w2LmZC7YNU+zrWmthaBT1Q2f8V3KlyrtEEJRg3dZ0K5rfAmNwqc5kFEudZSRsfADWJO9eEduwR1roe/x0gpJZKhYTPz/mqhFSaVe//GwF9tlJ2YxRjYRpMec6uJiib7clUPNqhhI4Bby6Pg6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(8676002)(8936002)(66476007)(508600001)(66556008)(52116002)(4326008)(5660300002)(66946007)(83380400001)(16526019)(2906002)(6916009)(186003)(53546011)(6486002)(31686004)(36756003)(2616005)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aU40Mlp2MXNySy9hNGtOWjdWZlFNaFJjbWF5SFRHZWdMZ1NBZW9Jd01DUzZG?=
 =?utf-8?B?RnVHVDFqbzNxSUlkcS9vbEZxLzcwZmJmU0ZYWkhka0Y5NEdibjVMY3ZoRTlP?=
 =?utf-8?B?NllHRDRFUVBUREdEalN5cDRqTllBZjd6Vk1BdzJwYXVteWNvRHZNVzBWNEJa?=
 =?utf-8?B?WE5EdDVSbVBlcFRHWWZJSCs5czVOcGlKM2QzZGgwVnVROGFLajloeWxkUy8r?=
 =?utf-8?B?Wkg2dDMxbjNCU0tjZ1ViVDA0aFFWa0lMcEFacGJLMjI5QXNVbmhkZ0pyQVFY?=
 =?utf-8?B?NTUwY3ZmeXN0UzdpaTdwME9LeFZaKzNPbFVyTGpiSlV5YmxUaGdQRE5UUWJI?=
 =?utf-8?B?NFVlMlovUTExc2xyZGo0SVEvUUMvQ21xb1FoeGptbXhTME9wV2hoRUN6VEM0?=
 =?utf-8?B?T1BPRGhGVXV3RlMrTkhLdHRRb3E1eU81TU1XTFhyMWM3ZmFOL1VWeTY2VkVv?=
 =?utf-8?B?UXNIR3EzQnFzb3R5YjVjNzNXQ1lMM0taWHduZ1N0Qm1td2oyZHhxSGROOUNx?=
 =?utf-8?B?a2kzaFBwMXN2bFZxcldoYnJabFhsV2FmSFNoQjlHaklET0dTbkw0UjdXQ3hM?=
 =?utf-8?B?a1h3ckVKRzdVS0RKc0RKWlRPSGdJOS80ZnVqU2hPZUlmcnlwMFo4SmlrVEdO?=
 =?utf-8?B?MC8xbW5SYXpZSlpxSWRYMVpld2hRTzREdFd5MTduVVY1RzdNNVc3Q0Uxb2NW?=
 =?utf-8?B?cW4zVHltbTkwUWoxNXRUYUVoVDk0VC90dzVWSUlCYStzWVUxZ0s4OHlNRmIx?=
 =?utf-8?B?dDZmWmlwSTY2MDFCZkdxcEducUI4QmZyK0hiZEphWnhkeWZvaW9QaDRoNGs0?=
 =?utf-8?B?MVZiek15TW5YYTRqM1kvRkpRNWpZSTNmUHppU0s5d25KcmZ2VXFKamNjVktm?=
 =?utf-8?B?N20wOXJYWkFPcFNLbGFSTzhpU3FMQTV4ZVJxbUVRcWJmNGVYZjNlWmtQUDRB?=
 =?utf-8?B?WGZqVE5MamJBZXIyc0dkNEdNT2NxR21ZN3FoMEp5cDVGaUU5TTBpZG9yMENY?=
 =?utf-8?B?SU5SdnJDM1QvTXRxQlhlTTBOQUkwUXZSWDc4d3RCZHdWS0g2enNMN0Vwam5R?=
 =?utf-8?B?RUhTQlc2T0cxUjJOV2s4SzJoalFwSVhIWWpRN0tUOSt2UGRRVHF5MXZ0SEJK?=
 =?utf-8?B?NW9nYzZjd0NKblcrZHdBQm1CODYzY3BXNzFBNkluQXN2ZXJuSVFPOFJDQ2ln?=
 =?utf-8?B?Um9LazY1aWloMDlhZ0NWektDOEJaMm9yQjJzaTBQTUlCd2dYemxCd3pwTUZF?=
 =?utf-8?B?dy90d2RoQUtkZko5a1BTNlBpbG96U3UrUXdKbkRtOU5xSWpJU1A1M0FoNjdY?=
 =?utf-8?B?M0cvbFZhYXUxRmg2bldnZU10ZGFILzdoRGRBRGhLWVhlMG1zNHdzSzRUdnA4?=
 =?utf-8?B?VTY4QjAvSTZWR1E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 19:02:55.5110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ba8cd3-8337-4b88-e28f-08d89c75096f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1Ez608rXCyRdicwLwkD/IhG2+F8JILPKqxcBm3XZRNFxjsI5zBAKHLRimcZ65h3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2822
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_14:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090133
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

Maybe you can post v3 of the patch with the above information in the
commit description so people can better understand what the problem
you are trying to solve here?

Also, could you also send to bpf@vger.kernel.org?

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

I did some limited experiments and did not trigger a case where
task->tgid != task->pid not agreeing with !thread_group_leader().
Will need more tests in the environment to reproduce the warning
to confirm whether this is the culprit or not.

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
> 
