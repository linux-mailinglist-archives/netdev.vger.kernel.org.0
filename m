Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70B92DE7AF
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 17:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbgLRQy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 11:54:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3520 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbgLRQy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 11:54:26 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIGiFJP032547;
        Fri, 18 Dec 2020 08:53:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xYwOpPilIoxDK1raGg/MkqEMG7RMC+sqAbFv25iPrEU=;
 b=RzLIkUcqj0zGHvVkHYaXvs3zxqGx15FcxGE++mauzIlwg/0TltgzWG0fg9iKlzvv6oSq
 vDXCbx6VztEIPj+SLbGZQsGTvgkVUjbzwis5ZX/u8HzHrvZceOzElMfotB4x3xnjx866
 M5Cr2XbsMr483jlYXCB5AD/MDhQi0cCGcMo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35gxe5gp5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Dec 2020 08:53:31 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 08:53:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFKC54LoRAdIxQ64byVWIS0Zrb3qIUT08Z5yehYtqHWXeUpFq5ZddSUuDzsrp4uKV2/NQksmEJ9Rr5FakRuxiVHuNf63kOy17DuefqrRW8kvn9Y1OfWgUvHYvZVg65SDm3FjFOboiZusbGSZronTL4lB4j3PAEgJO2FnSd1aNF/Xn8K+c0CurTkQa+MCMIl2wVmOZImkc0n8w01S4ntuFNnF694MXoCEz9lwMdYyD7jbxGrrpLXvd2ZDpNHTqPKzyaTP2cokomI/6T8RjacyH0F6iVZMwd7mOEedhSLIF4LYDzcUduX5l4Qik/KUu+Z0pHVaOEy04gISHhcH36vZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYwOpPilIoxDK1raGg/MkqEMG7RMC+sqAbFv25iPrEU=;
 b=QuGuVFU695Q91LY4lLDSoNHWKjQlSOs5a6d8TSxaRR0iPEUdhAkWRSwe+p49HvlZQS77jRpFCCA2/KwWTr/nza8hlWiEb9HXL7Hg5axUzAe4PaT6/Z5Zfu2jtsKO3kxgM80cz0qS5xnIlJHoNhQEE30OoZxQxQUS1vDXlgdrOS9QLvplKmuvFp2D60JlpwPNwxqv7aJXvhJKzAgTh+NsIx9LIW1Q8glUT1chbrQV/MN8pOt6Vyu/c67wq7Cydd42O/goPSHOTVyNa10oJLq/TKvuf40nbnKu5ihaR5ZmcCx7p2kh1HrJZot4zBGvxm+CC6Mjbs3GvZIAHeo69thJ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYwOpPilIoxDK1raGg/MkqEMG7RMC+sqAbFv25iPrEU=;
 b=CjUnZhrsGMlqobIzw2VizpiDnfZnHwn43TsG/JR+n+CwjFUiEZJTEVmW+fLZxV5xeKJmPirzXYToYCr2DGbkjiU9b0E0wkS5Nj9ULo8g9dtHeSLDNFTXAfLSwih1rB7zSgLnAszXVicZGuhLeU4XmfRVgzl/aG+vW/+Iza6s568=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2726.namprd15.prod.outlook.com (2603:10b6:a03:157::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 16:53:25 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 16:53:25 +0000
Subject: Re: [PATCH 1/1 v3 bpf-next] bpf: increment and use correct thread
 iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>
References: <20201211171138.63819-1-jonathan.lemon@gmail.com>
 <20201211171138.63819-2-jonathan.lemon@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <39fcac29-4c93-1c76-62ba-728618a25fe5@fb.com>
Date:   Fri, 18 Dec 2020 08:53:22 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201211171138.63819-2-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:8460]
X-ClientProxiedBy: MWHPR1701CA0003.namprd17.prod.outlook.com
 (2603:10b6:301:14::13) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::119f] (2620:10d:c090:400::5:8460) by MWHPR1701CA0003.namprd17.prod.outlook.com (2603:10b6:301:14::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 16:53:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9295bac4-6f3b-47a1-cba5-08d8a3756f9d
X-MS-TrafficTypeDiagnostic: BYAPR15MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2726009227C96B283A68EE5FD3C30@BYAPR15MB2726.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tDsdwhLJgNtRGICa1bg20OISVneIwq+nWqMIQ/0Fx5EcquDdTfh8Fx4sj3k9XLAQHKBtphghN+nD2AyX1tiiLG0ePVZfslp6phh+aZvfcmcWlp44AsdT3GdijW6w1NawPIqIIFmjMOkwi9k3QmioFarfAWdzMnABKMDdU1TGfXhB1NjkFTtAA3DdyQsK/YzaqbqjGHWy2MQUuUVFMEp52XBLU4XzJGSN2gsTfBRIJurp8Q21oMd6QoKpCTT6YWgOwE9WGvQMRps6fVVF84D7cWlCSkOEH8gpgvHtSyrhrVqlYyGK0nOpvwqqK9MvMGuTSPohMTk1gT8nhnZpJNPIYXhnYRvPJG3pCCCBAG9gf2f5DEiMdANE9cd++9JQfwdNxuMLEcXEpG9aDEbbC3ITjmBu3Vs3VwIoUy3XvIKgyB8T3ZQFEEepS1Or6nzcgcFQxtLL1ZzWAdLJ9KpZJ2q/h5qbA3e3M3U+wDndV0V1SZY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(366004)(396003)(31686004)(2906002)(186003)(8676002)(316002)(8936002)(4326008)(16526019)(66556008)(66476007)(2616005)(52116002)(53546011)(31696002)(86362001)(478600001)(6486002)(36756003)(83380400001)(66946007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aUZaU2FERDUxVEtjRFBvTVlBd0RJMmNPRDJvdVhpSENEOU5vaDEwcXNCbWJV?=
 =?utf-8?B?bHYrNkVseWNyWmtBUHcwYzRTSjdhYUxrWEUyQncwc3FFbVVzNENQb2VCdG92?=
 =?utf-8?B?dWxic1RyWW5KQ011aUljNGoxVDlLc2JrUlk0cVZVSlFoUXVMZm53SnFZR0tB?=
 =?utf-8?B?eFR3WUlDWnBERlZuaWZldlpzOWtOZm9sUHN0dW5TUXZpK1kySWM1cjNVSkM2?=
 =?utf-8?B?Zytyd203L1JZT3BTZ1FnNDVnbVZZbEFjWk9qV0R4ZUVlRHY3N1hVaGZ3bnds?=
 =?utf-8?B?ckRMM2VoNDIyUDNiQ2pnQW5OZ2dINmQzek13QjBJM2Z3aVRWTHRnNFBOSmZK?=
 =?utf-8?B?QXI3M1lhUzJVNmFmLy9LMGM3SlVxb2pWZWhUL1VvSDFKWG5tOGFoM1BndzNB?=
 =?utf-8?B?VHVFMDgrSE5MYjlpUkVCTEFyTlc1dk1oK013M1RvN0xEVm5WQWpZVUxTUG9k?=
 =?utf-8?B?bW12cnJSZ1Q3WU1veWVFcFRSK2dYRzhLbytibHoyeXYwOC9zODNIR3Y4NkNx?=
 =?utf-8?B?YlhYdXlzNjRaNmp1T1dHQVdOZGtmYlhtZ2lQbkt0TDl4TUdqYlg3YlBrc0hh?=
 =?utf-8?B?U1RNY0NxMHZsckg1cldBVmRHTUZOMk9aMVJJZkdpTUhST3NHVlFZOHpES2ww?=
 =?utf-8?B?MEM0R0pZeEhjYkdBRGNQRnZlVFlxVDhvK0hPQjRHTld0d0dnZzFReVZ6bGJ1?=
 =?utf-8?B?L0s3L0QrL01xcnZoUDlYVmg4cy9HYnp1VVMyODU0UHRDck00M1hQanN4aWZ6?=
 =?utf-8?B?MnNYZjk1bjJ5bUpuem5vQXR3SjJoUFVuT3BQQStxcU13YjRKSllmdnVEaGVJ?=
 =?utf-8?B?OGdnaTJtMXNPSUJ2RjlxWlBQTUtiZ2kvRmk1bTNCSkFXNzFzVVNLRERoT3pC?=
 =?utf-8?B?YkJ3Y3d2TjVyU056NWxuRGJiR0lyTmFiN2taYjh6VURyUFZRZXNjYkZGMVZj?=
 =?utf-8?B?WnJhbXpNUCs0cDZ2TzZQV2FGMWZjSnR4YlU3R2RkeXdoeEM2aURlN3MyakJp?=
 =?utf-8?B?dzN0aHpieHpTUXJrd2N5Y1JOK05WVW1Mdi9oanEycUVzcnFWZDNBRVhRUURo?=
 =?utf-8?B?YjQ1WTJoSmhVa2pvU0pBRjVxY2h0cVo0WTh6bGtPWW80bk5rOHZWb0E3K2tt?=
 =?utf-8?B?TjZVQUh1dFdkb2ptTU9FTWFiUkZDVnlGTUlWRnBBaTYxT0hpOWIwYWp5TnJu?=
 =?utf-8?B?d2Y2VThvQ2k4RVljSFNZQ21UM1J4N0gxc3RzS0llaG11RWZseW9oM0JqVkhG?=
 =?utf-8?B?ekZsdlM2K1pXV0hwbkthLzhlUDJkZlIvM3d1YVZIMWo0MUUvNXhtQzRuNjdD?=
 =?utf-8?B?cCtaUG04cmxKNkJjdzEzclh5RDdyMkllc3Jzczd0SXFOSHhwQndWLzJObW50?=
 =?utf-8?B?MVpTajUyUXJWVkE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 16:53:25.0459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 9295bac4-6f3b-47a1-cba5-08d8a3756f9d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wgnTl1BjIvPtyhyOWQWK4dhfKfhaLb3b3RI43YdHOn4bM8CaTP3xskVchr8rgje
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2726
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_10:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012180115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/11/20 9:11 AM, Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> On some systems, some variant of the following splat is
> repeatedly seen.  The common factor in all traces seems
> to be the entry point to task_file_seq_next().  With the
> patch, all warnings go away.
> 
>      rcu: INFO: rcu_sched self-detected stall on CPU
>      rcu: \x0926-....: (20992 ticks this GP) idle=d7e/1/0x4000000000000002 softirq=81556231/81556231 fqs=4876
>      \x09(t=21033 jiffies g=159148529 q=223125)
>      NMI backtrace for cpu 26
>      CPU: 26 PID: 2015853 Comm: bpftool Kdump: loaded Not tainted 5.6.13-0_fbk4_3876_gd8d1f9bf80bb #1
>      Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A12 10/08/2018
>      Call Trace:
>       <IRQ>
>       dump_stack+0x50/0x70
>       nmi_cpu_backtrace.cold.6+0x13/0x50
>       ? lapic_can_unplug_cpu.cold.30+0x40/0x40
>       nmi_trigger_cpumask_backtrace+0xba/0xca
>       rcu_dump_cpu_stacks+0x99/0xc7
>       rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
>       ? tick_sched_do_timer+0x60/0x60
>       update_process_times+0x24/0x50
>       tick_sched_timer+0x37/0x70
>       __hrtimer_run_queues+0xfe/0x270
>       hrtimer_interrupt+0xf4/0x210
>       smp_apic_timer_interrupt+0x5e/0x120
>       apic_timer_interrupt+0xf/0x20
>       </IRQ>
>      RIP: 0010:get_pid_task+0x38/0x80
>      Code: 89 f6 48 8d 44 f7 08 48 8b 00 48 85 c0 74 2b 48 83 c6 55 48 c1 e6 04 48 29 f0 74 19 48 8d 78 20 ba 01 00 00 00 f0 0f c1 50 20 <85> d2 74 27 78 11 83 c2 01 78 0c 48 83 c4 08 c3 31 c0 48 83 c4 08
>      RSP: 0018:ffffc9000d293dc8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
>      RAX: ffff888637c05600 RBX: ffffc9000d293e0c RCX: 0000000000000000
>      RDX: 0000000000000001 RSI: 0000000000000550 RDI: ffff888637c05620
>      RBP: ffffffff8284eb80 R08: ffff88831341d300 R09: ffff88822ffd8248
>      R10: ffff88822ffd82d0 R11: 00000000003a93c0 R12: 0000000000000001
>      R13: 00000000ffffffff R14: ffff88831341d300 R15: 0000000000000000
>       ? find_ge_pid+0x1b/0x20
>       task_seq_get_next+0x52/0xc0
>       task_file_seq_get_next+0x159/0x220
>       task_file_seq_next+0x4f/0xa0
>       bpf_seq_read+0x159/0x390
>       vfs_read+0x8a/0x140
>       ksys_read+0x59/0xd0
>       do_syscall_64+0x42/0x110
>       entry_SYSCALL_64_after_hwframe+0x44/0xa9
>      RIP: 0033:0x7f95ae73e76e
>      Code: Bad RIP value.
>      RSP: 002b:00007ffc02c1dbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>      RAX: ffffffffffffffda RBX: 000000000170faa0 RCX: 00007f95ae73e76e
>      RDX: 0000000000001000 RSI: 00007ffc02c1dc30 RDI: 0000000000000007
>      RBP: 00007ffc02c1ec70 R08: 0000000000000005 R09: 0000000000000006
>      R10: fffffffffffff20b R11: 0000000000000246 R12: 00000000019112a0
>      R13: 0000000000000000 R14: 0000000000000007 R15: 00000000004283c0
> 
> The attached patch does 3 things:
> 
> 1) If unable to obtain the file structure for the current task,
>     proceed to the next task number after the one returned from
>     task_seq_get_next(), instead of the next task number from the
>     original iterator.

Looks like this fix is the real fix for the above warnings.
Basically, say we have
    info->tid = 10 and returned curr_tid = 3000 and tid 3000 has no files.
the current logic will go through
    - set curr_tid = 11 (info->tid++) and returned curr_tid = 3000
    - set curr_tid = 12 and returned curr_tid = 3000
    ...
    - set curr_tid = 3000 and returned curr_tid = 3000
    - set curr_tid = 3001 and return curr_tid >= 3001

All the above works are redundant work, and it may cause issues
for non preemptable kernel.

I suggest you factor out this change plus the following change
which suggested by Andrii early to a separate patch carried with
the below Fixes tag.

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 0458a40edf10..56bcaef72e36 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -158,6 +158,7 @@ task_file_seq_get_next(struct 
bpf_iter_seq_task_file_info *info)
                 if (!curr_task) {
                         info->task = NULL;
                         info->files = NULL;
+                       info->tid = curr_tid + 1;
                         return NULL;
                 }

> 
> 2) Use thread_group_leader() instead of the open-coded comparision
>     of tgid vs pid.

My experiment show there is no difference between thread_group_leader()
and comparing tgid/pid, but indeed using existing function is better,
so I am okay with this.

> 
> 3) Only obtain the task reference count at the end of the RCU section
>     instead of repeatedly obtaining/releasing it when iterathing though
>     a thread group.

The above two changes are not really fixing the rcu warnings, but
they are nice to have indeed. Could you put it into separate patch
(patch 2)? You can add the following improvement change as well

-bash-4.4$ git diff
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 0458a40edf10..f61e5ddb38ce 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -148,12 +148,12 @@ task_file_seq_get_next(struct 
bpf_iter_seq_task_file_info *info)
          * it held a reference to the task/files_struct/file.
          * Otherwise, it does not hold any reference.
          */
-again:
         if (info->task) {
                 curr_task = info->task;
                 curr_files = info->files;
                 curr_fd = info->fd;
         } else {
+again:
                 curr_task = task_seq_get_next(ns, &curr_tid, true);
                 if (!curr_task) {
                         info->task = NULL;

to reduce one branch for searching next task in task_file_seq_get_next() 
function.

> 
> Fixes: a650da2ee52a ("bpf: Add task and task/file iterator targets")
> Fixes: 67b6b863e6ab ("bpf: Avoid iterating duplicated files for task_file iterator")
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>   kernel/bpf/task_iter.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 0458a40edf10..66a52fcf589a 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -33,17 +33,17 @@ static struct task_struct *task_seq_get_next(struct pid_namespace *ns,
>   	pid = find_ge_pid(*tid, ns);
>   	if (pid) {
>   		*tid = pid_nr_ns(pid, ns);
> -		task = get_pid_task(pid, PIDTYPE_PID);
> +		task = pid_task(pid, PIDTYPE_PID);
>   		if (!task) {
>   			++*tid;
>   			goto retry;
> -		} else if (skip_if_dup_files && task->tgid != task->pid &&
> +		} else if (skip_if_dup_files && !thread_group_leader(task) &&
>   			   task->files == task->group_leader->files) {
> -			put_task_struct(task);
>   			task = NULL;
>   			++*tid;
>   			goto retry;
>   		}
> +		get_task_struct(task);
>   	}
>   	rcu_read_unlock();
>   
> @@ -164,7 +164,7 @@ task_file_seq_get_next(struct bpf_iter_seq_task_file_info *info)
>   		curr_files = get_files_struct(curr_task);
>   		if (!curr_files) {
>   			put_task_struct(curr_task);
> -			curr_tid = ++(info->tid);
> +			curr_tid = curr_tid + 1;
>   			info->fd = 0;
>   			goto again;
>   		}
> 
