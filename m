Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5232DE8E2
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgLRSWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 13:22:42 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbgLRSWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 13:22:42 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BIIFjbV021535;
        Fri, 18 Dec 2020 10:21:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=D4LbI2RClyrz+DeZSRGNs8KRTiRGVpUSFrTVYJ/V6lw=;
 b=Fpg6lTZBHVSLjFDcXgUkUyftOftyCc49voHjM4DTDEj6dDbWkILh7JN+op8uKOZoo1H0
 PzUvbyrT2mv9edDKGyfQofU8UVhI6Mem3ZK8dinHHiTru07/copQqrQ9gvhf21tkc3EA
 OEs6EFOU2ufC0kbI1Ih2OekDgfrr3vp14JQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35gwa89g6p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 18 Dec 2020 10:21:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 18 Dec 2020 10:21:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ1IOeSI5YO/qNwO7UaaVLOhJTLAy0G1pFVEsZ3HmhQpoD+XncYtTgwe6F9O25G7xRIny0oUUnGeUDj3jxAbGD+6xgJe2V+BoeciR6aOEAYpAGy9dHNQwZs4JL/u0c7MoILPLjV81o3DOdpHYo28tZK75cNvRWkngm63mgd9n8BNrfoZuW7LzC68Aehd42xEBMSHnKlSmPIPDb3G9kB83rRNKisnB7s5ofRhBys7L90ZyCb5Gc2Li3lmIcB2zaJjqqsTuBxAA+Je42DwSKgakrW4FuS5L6QgyaHiDpkNFFL3wsVaPKCSYe/H4C5hE+io5S0ccMIzNK2J3vdihRTrYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4LbI2RClyrz+DeZSRGNs8KRTiRGVpUSFrTVYJ/V6lw=;
 b=VfWXAUTh+ofrN6qDven85bwsNn+tYo8ToxzaMziSpwuRskuH1ltT8O29BgzxAuVzxkba9egYRoZoHTPGm1fBvUdoCIs9G0fNoO4tq73+zJPRnzY2zDHxh51G4mEBzO4x+m0x+yBM3kRpTHes5qinSRxke09QAi4m8BcBxTlM/hUfKmPbL+qmBmZGE+YN8x/WrgKKo4x6ayqCe5KjdEYAG2kmEdpkoCJe7ma/u0MiGhlOJqT5E8NLW8bYGMYSUsv2wfR5YKsK3ZQJblaHGTMYLjQoaPcXZTZjrvpgnEgxztJPzB7O5mwwYvhdCK4t0JFPCy8qfzwm7I/MIL8KIO27ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4LbI2RClyrz+DeZSRGNs8KRTiRGVpUSFrTVYJ/V6lw=;
 b=RyxF7qC7QaHtY5RQCaK8G0ReHCpRznyjJ9xaHEsaLDtGeTviHSDULH4BQt8g5pfcrNd+um9SGlrR2iK2jgz+bhtysR/luIQb2W0b+mUTkWcBauq6tZBDfgGZyknC3i8YwqWyp3ttERhdUlKuA+MBZNiGTyzZwxdMO6iuepK1w6U=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3366.namprd15.prod.outlook.com (2603:10b6:a03:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.19; Fri, 18 Dec
 2020 18:21:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 18:21:45 +0000
Subject: Re: [PATCH 1/1 v3 bpf-next] bpf: increment and use correct thread
 iterator
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
References: <20201211171138.63819-1-jonathan.lemon@gmail.com>
 <20201211171138.63819-2-jonathan.lemon@gmail.com>
 <39fcac29-4c93-1c76-62ba-728618a25fe5@fb.com>
 <20201218180628.qz3qjb7y3sa4rbn3@bsd-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <83075184-ec82-b935-1bce-31cd7758ee1e@fb.com>
Date:   Fri, 18 Dec 2020 10:21:41 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201218180628.qz3qjb7y3sa4rbn3@bsd-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:8460]
X-ClientProxiedBy: CO2PR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:104:3::24) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::119f] (2620:10d:c090:400::5:8460) by CO2PR06CA0066.namprd06.prod.outlook.com (2603:10b6:104:3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 18:21:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ef0480e-631b-4c5d-e103-08d8a381c6e5
X-MS-TrafficTypeDiagnostic: BYAPR15MB3366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3366D146A4B5C432BB04CB8FD3C30@BYAPR15MB3366.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ULQkOLMRTMzagl3rokwv+jNGTQYZqT+0srzybbsv+/uZr9WrjQkoUnG9Q78zxr9MQT2S258B42oOhQl2DMyhUMU7saK2jZT+wGmpD8mKYhBfvkzHAx7ElhMdZIG6QkkLXyQfxDGBkZkRDRhk8PxdYBHGRzC/pd2ASpITgTOtnJmOChuyCZX93wjo6t+rLZh2oiLx4LLv9nAeQeZ5tTZjZTccd/lcbEpAleopCaHA9vScnc5MmPbmffc+V9u/xChw8PXUmFqhUvjBmiGYJl/IoOC5ZlawxNqqenKoIYp7rn8hg4mfPaRC2gNyB26/pxJ8+sU/d/UCRCcWzXnLCo5FmSUiYKPCIay8YTb9EHDhbmAKqGMdQ6cCPIg2r3k4RcQzMAJx26Fo6sAB6O3rMWcHh30/VLYeLB4rveAhrAar7cM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(346002)(396003)(66476007)(66556008)(36756003)(83380400001)(16526019)(6666004)(66946007)(2616005)(53546011)(8676002)(5660300002)(31696002)(186003)(478600001)(86362001)(316002)(52116002)(8936002)(31686004)(6916009)(2906002)(6486002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MTNET29La3czZmdRQ08rV0NTNDZBbkRMMmhqV1VaRmg1TEVoSUFkSDE1b096?=
 =?utf-8?B?dWNDd243WXRxNURBcTNybjdKdzFCR0ZZdDY4YUV4NnpnTXBRdXdkUE14bXQx?=
 =?utf-8?B?OWUrNlJNU213OTk1QnZrR0ltN0lURU1RTTdKRTh0UGk2OE5Zb01mS2g2bENl?=
 =?utf-8?B?ZklpS3BTTk9GRmNZcUkxdEZsdFlPeXlZeStOSURkMHBNQjExSk82QlBZREdr?=
 =?utf-8?B?aUFHZzNrZTBtYUVTQU9UckN2L1JOblU2bzhjWVVlVldCNmxjWitnZUE1QUl6?=
 =?utf-8?B?RXlOSGVzZFNONEd0MEFCVnVuK2l6Z1ovT1VrajRQdWxYeTVWMVBxaHlPNTh4?=
 =?utf-8?B?c0ZkUTlkdU1qZTlnVlJSN1R2VG9UVk1kU24yaUVmcGRxeHhCcjFYZHJYMDUr?=
 =?utf-8?B?MWxHZmI4ZmhtWDl3eUhLZWk4TVVvd3FSdVcxeGtDdklwalNKRVNsdm5BOXAz?=
 =?utf-8?B?NlFwVUlLZnA0ZEdGRG9qRlpMWEFKUXhwNi9FNEwrM1dQcGFYQ25iaFN3ZkJ5?=
 =?utf-8?B?djJVZGZCUnI1dXZ2ZTZiUWVjdFFsK25xK2NpSFVCTXlPSE96WHVXcGlWTW1h?=
 =?utf-8?B?S2lrR3BSREROckNsemx5a2d4cHdVemUxaTVqSHUvbjBvZmxnQk1Hbk5lTVRK?=
 =?utf-8?B?TmNISDJFYkkwZ2t6MWdwRnovb1pQT1NwdFNWTFBBamJGNFEwNEZCQ09paysv?=
 =?utf-8?B?Q05yQ25lekFudFVaYmFLR3VWLzRVN3NmWmRYTU1RRExjZzhoaW5sZHlJVVBq?=
 =?utf-8?B?VnZ5c0JBeHgxdndwdlAwczE0VzVweEhGOFRVZXpFYmJ2Z2ZtNEhZdG13bVFu?=
 =?utf-8?B?WFl1SWMvUzRRSU9SUDZEYXJxeFFJQ0FMZW1INHBXSnppUERVSmdJTUNLS2xK?=
 =?utf-8?B?ZUE0VlZUVitObFQ2OFlNSnMreDViZXRmeHFHZVVuRTdTem5vS3RXQzJmN3FV?=
 =?utf-8?B?YUVBYkEyTFNwbnRHbmt0RWZCaWl4UHdFOVV2WE8rTEhyNjRmVU9vUndxbnRk?=
 =?utf-8?B?WUR2cDUzY3I3Z3RDVVp3Vm96QjdpeExtSU84OVU2a0w5aEQ1S0FoQ2d2RjlG?=
 =?utf-8?B?YjBDeDBTUTJZYUs3LzVZbUxkVEkwakVYOUloOFJ5dHJaRDh1RmVFakR6Qith?=
 =?utf-8?B?V0FLb1dvd290T1liQWl2N3ZnZkpEQU9qMXMwaDI4RndyeE9kTnhWWlljQUdi?=
 =?utf-8?B?b1NRMHdnNnhIRXFYYTA1RTdHQzd5MHBsSUJTWXdXVUtLd0prNUNGbUtMZmR6?=
 =?utf-8?B?RGoxTi9kRjQ5WXo2ZkFIbmpEV0NNSzREcEpZeFpjREdBYnRrZWJUWCtLZy8y?=
 =?utf-8?B?SEZMM1JRYkdLQTJpQ3AzeitNUXh6VFk1TWhyc1ZuU0lqM1lhejdoT05SL0hs?=
 =?utf-8?B?QzdTMHdlSXdvTVE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 18:21:45.4998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef0480e-631b-4c5d-e103-08d8a381c6e5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vjJ7PVRdfYGoO5to5vQXs21YIOKeabcNXasoUAeHScsrrjkfh49gYL+gMwgx2hsE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3366
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-18_10:2020-12-18,2020-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/20 10:06 AM, Jonathan Lemon wrote:
> On Fri, Dec 18, 2020 at 08:53:22AM -0800, Yonghong Song wrote:
>>
>>
>> On 12/11/20 9:11 AM, Jonathan Lemon wrote:
>>> From: Jonathan Lemon <bsd@fb.com>
>>>
>>> On some systems, some variant of the following splat is
>>> repeatedly seen.  The common factor in all traces seems
>>> to be the entry point to task_file_seq_next().  With the
>>> patch, all warnings go away.
>>>
>>>       rcu: INFO: rcu_sched self-detected stall on CPU
>>>       rcu: \x0926-....: (20992 ticks this GP) idle=d7e/1/0x4000000000000002 softirq=81556231/81556231 fqs=4876
>>>       \x09(t=21033 jiffies g=159148529 q=223125)
>>>       NMI backtrace for cpu 26
>>>       CPU: 26 PID: 2015853 Comm: bpftool Kdump: loaded Not tainted 5.6.13-0_fbk4_3876_gd8d1f9bf80bb #1
>>>       Hardware name: Quanta Twin Lakes MP/Twin Lakes Passive MP, BIOS F09_3A12 10/08/2018
>>>       Call Trace:
>>>        <IRQ>
>>>        dump_stack+0x50/0x70
>>>        nmi_cpu_backtrace.cold.6+0x13/0x50
>>>        ? lapic_can_unplug_cpu.cold.30+0x40/0x40
>>>        nmi_trigger_cpumask_backtrace+0xba/0xca
>>>        rcu_dump_cpu_stacks+0x99/0xc7
>>>        rcu_sched_clock_irq.cold.90+0x1b4/0x3aa
>>>        ? tick_sched_do_timer+0x60/0x60
>>>        update_process_times+0x24/0x50
>>>        tick_sched_timer+0x37/0x70
>>>        __hrtimer_run_queues+0xfe/0x270
>>>        hrtimer_interrupt+0xf4/0x210
>>>        smp_apic_timer_interrupt+0x5e/0x120
>>>        apic_timer_interrupt+0xf/0x20
>>>        </IRQ>
>>>       RIP: 0010:get_pid_task+0x38/0x80
>>>       Code: 89 f6 48 8d 44 f7 08 48 8b 00 48 85 c0 74 2b 48 83 c6 55 48 c1 e6 04 48 29 f0 74 19 48 8d 78 20 ba 01 00 00 00 f0 0f c1 50 20 <85> d2 74 27 78 11 83 c2 01 78 0c 48 83 c4 08 c3 31 c0 48 83 c4 08
>>>       RSP: 0018:ffffc9000d293dc8 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
>>>       RAX: ffff888637c05600 RBX: ffffc9000d293e0c RCX: 0000000000000000
>>>       RDX: 0000000000000001 RSI: 0000000000000550 RDI: ffff888637c05620
>>>       RBP: ffffffff8284eb80 R08: ffff88831341d300 R09: ffff88822ffd8248
>>>       R10: ffff88822ffd82d0 R11: 00000000003a93c0 R12: 0000000000000001
>>>       R13: 00000000ffffffff R14: ffff88831341d300 R15: 0000000000000000
>>>        ? find_ge_pid+0x1b/0x20
>>>        task_seq_get_next+0x52/0xc0
>>>        task_file_seq_get_next+0x159/0x220
>>>        task_file_seq_next+0x4f/0xa0
>>>        bpf_seq_read+0x159/0x390
>>>        vfs_read+0x8a/0x140
>>>        ksys_read+0x59/0xd0
>>>        do_syscall_64+0x42/0x110
>>>        entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>       RIP: 0033:0x7f95ae73e76e
>>>       Code: Bad RIP value.
>>>       RSP: 002b:00007ffc02c1dbf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
>>>       RAX: ffffffffffffffda RBX: 000000000170faa0 RCX: 00007f95ae73e76e
>>>       RDX: 0000000000001000 RSI: 00007ffc02c1dc30 RDI: 0000000000000007
>>>       RBP: 00007ffc02c1ec70 R08: 0000000000000005 R09: 0000000000000006
>>>       R10: fffffffffffff20b R11: 0000000000000246 R12: 00000000019112a0
>>>       R13: 0000000000000000 R14: 0000000000000007 R15: 00000000004283c0
>>>
>>> The attached patch does 3 things:
>>>
>>> 1) If unable to obtain the file structure for the current task,
>>>      proceed to the next task number after the one returned from
>>>      task_seq_get_next(), instead of the next task number from the
>>>      original iterator.
>>
>> Looks like this fix is the real fix for the above warnings.
>> Basically, say we have
>>     info->tid = 10 and returned curr_tid = 3000 and tid 3000 has no files.
>> the current logic will go through
>>     - set curr_tid = 11 (info->tid++) and returned curr_tid = 3000
>>     - set curr_tid = 12 and returned curr_tid = 3000
>>     ...
>>     - set curr_tid = 3000 and returned curr_tid = 3000
>>     - set curr_tid = 3001 and return curr_tid >= 3001
>>
>> All the above works are redundant work, and it may cause issues
>> for non preemptable kernel.
>>
>> I suggest you factor out this change plus the following change
>> which suggested by Andrii early to a separate patch carried with
>> the below Fixes tag.
>>
>> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
>> index 0458a40edf10..56bcaef72e36 100644
>> --- a/kernel/bpf/task_iter.c
>> +++ b/kernel/bpf/task_iter.c
>> @@ -158,6 +158,7 @@ task_file_seq_get_next(struct
>> bpf_iter_seq_task_file_info *info)
>>                  if (!curr_task) {
>>                          info->task = NULL;
>>                          info->files = NULL;
>> +                       info->tid = curr_tid + 1;
>>                          return NULL;
>>                  }
> 
> Sure this isn't supposed to be 'curr_tid'?  task_seq_get_next() stops
> when there are no more threads found.  This increments the thread id
> past the search point, and would seem to introduce a potential off-by-one
> error.

This is for the case where read() syscall return length 0, but user
space still keep read(). You are right, we may skip one newly created 
one indeed.

Although such a usecase is not common, but info->tid = curr_tid
certainly more correct than info->tid = curr_tid + 1.

So thanks for suggestion, LGTM.

> 
> That is:
>     curr_tid = 3000.
>     call task_seq_get_next() --> return NULL, curr_tid = 3000.
>        (so there is no tid >= 3000)
>     set curr_tid = 3001.
> 
>     next restart (if there is one) skips a newly created 3000.
> 
