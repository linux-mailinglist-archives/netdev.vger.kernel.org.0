Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F13256A9E
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 00:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgH2WOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 18:14:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52622 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727885AbgH2WOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 18:14:05 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07TM7ZLC010370;
        Sat, 29 Aug 2020 15:13:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=iLuaJeFGGtD6ps81dbTvuU1deIu32lzqsmssnfhNAn0=;
 b=dF520uLVPTBsykZ1GWVvd7NaRPl9vZQoa5+2UQY1pyX3gu6PK8qnUnSKTPLYUj79kaan
 jY0Hfee9HsGoAhAFuwUfRkKKrECgkYPHrgRcKOo8DX+kG2jS5IO/lY10Bucv9/f3YTwp
 MghJ1va12T2hu6Nu9Hvac+pzcWwAvI9HQDc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 337mhnht5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 29 Aug 2020 15:13:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 29 Aug 2020 15:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/OczCDyq4emD8AQxI2m4Jk27vyOG4Eu7SYSscNsJiAQzTHzTs/FbeUCxqzAMHcumxsY/OzYUfGid91PQKnD9HMiJpzpRMfDzTShISr68XlxaH+0PvWdeFdXsa+KS7OmKnCyyC1rU+eQfajoHOVt2Eqm03o6rFFqntb3F+alLZ+Dyawj1tSfTg3tmJDw0ILejoFt0aGJlzvHM3BEGxf59IdJvMRnIDmDXhXzpID9JrDfLc8T1D1tawbbTenYuuYhXZPrmaOeE/dYqCFgMCb1IFtQv0C0lVYqjdxy1QYDPQIxIXp0i4rXdBv7LkRAjfi8IG3PfiaHRHHiJSWTk7/XHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLuaJeFGGtD6ps81dbTvuU1deIu32lzqsmssnfhNAn0=;
 b=atFK3js4+x6dlcN/N4/s6WuRN6x9PKdJdzX+e3ImOF/99F5jy3DEOd46ZkKsU6z17yuN5MJlYr4dtTsN7Y5c0U+LJDfanmtvlxYL+rBQoMGUZhMGuj9Gtk1sDOwID4nWvpshPcWJij4km5QtL97lDX7CCPHcQaV5XyLYtVxr43Jur1beP8Vj7yfN6UwuCENEyi8JQZO3pZeN7W2mKPzcASjKh4RVjGmWCle66kM8ZMAk75KmHtnKxPq4QYvyUfkQWBXvf0iIFpLlbNtUrT55TA5m4zH1srPLtpzNxfUGMPHxWJBCxs9FYICK/0LjfVlcTgB9GE5GMFPNjUBBjcwzMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLuaJeFGGtD6ps81dbTvuU1deIu32lzqsmssnfhNAn0=;
 b=QguY+rPUojwlUxbU27BsvXD6bxNt9yaiZktJ7yBTuu8V/9qYHZvdbg829UJtKJmrrS3sJjRMV7HkHzJC8nCbtdrmfWJzm3IUnqSaSAQ6I2Ws6H+M8dYCyfO3fF8BmS9sOG6llhAOWDQK0CyIcYZ/xYGSEa7k8+fXXvA+oihEJzI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.21; Sat, 29 Aug
 2020 22:13:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3326.023; Sat, 29 Aug 2020
 22:13:28 +0000
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: Add sleepable tests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <josef@toxicpanda.com>,
        <bpoirier@suse.com>, <akpm@linux-foundation.org>,
        <hannes@cmpxchg.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-6-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <00667ff9-1f1d-068b-4f5d-4a90385437b1@fb.com>
Date:   Sat, 29 Aug 2020 15:13:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200827220114.69225-6-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0052.prod.exchangelabs.com (2603:10b6:208:23f::21)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR01CA0052.prod.exchangelabs.com (2603:10b6:208:23f::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.20 via Frontend Transport; Sat, 29 Aug 2020 22:13:26 +0000
X-Originating-IP: [2620:10d:c091:480::1:8d72]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b984a07-bcfa-4c2a-f05d-08d84c68c18c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2725DFF4478F3E2CDD324915D3530@BYAPR15MB2725.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2UHQIVhHAQbndHON8ze15ADutURTrKnU9nIsKLPG5PAh6XwX0O5kUkn1dp0/J83Ihw1V1T1TwZvUz38RO75vODgBrlASd4F8RhUe8i0+Hck44rKpSb0yat3/AZrsF5Jo+vqbz042rhRso8tPK66K6WFO0RfiGPhzLy+9PhS5B+kxHedNeexMWTWq0SoGygRuFDtOxVJJp9q9xAwq+JRw0MDPrmMusnCYcA3jIU8lVpuBLZyi80pGQgbYwUUkA7OwPlM6jV3Fy7Zd+a/5bwQU4/pxwbYKwVqzZ2Vm74rveXsLY8cJ+6PY1FYvvD5mWVnzs3c+eiYmBFQcKqFDIKUTceSe/TkrpJx9NEHUaJYVUwmUSx2Alb2xngdBRmsyx/E7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(366004)(396003)(8936002)(31686004)(186003)(2906002)(52116002)(53546011)(16576012)(6666004)(5660300002)(2616005)(956004)(6486002)(66556008)(4326008)(316002)(31696002)(66946007)(66476007)(8676002)(83380400001)(86362001)(478600001)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: NwuJGkTJncTI89yCJ0D9U8NPUgpWK2DQHBhjq2XBAjN5TpVYnIJ1itUfhY7zNAXkPMFGsPK04FR62Qe7fcKsALmuTxKrQ7GUVdSIxEprPmWlymiwyFfK5sJ5LqI/rRtNglbZlEFejYaNkHh4LTun7480t/ckAlRcM+vsjSE8Vp51C6TXPBZdnHBJPVl4groVuhaK8puY6p7FBba0iB0P4OmxzI66ZAVdZAHf/tTkYK58A2frp3ZUhS27RgpK6ibv9rVMTSqtUHlBi3alqobCbeAQBhGZwoLINEDFAoNtmUrfMb/Jnd11DzfwW+NAtB2XZrrw8TzPujVORYr+Tl/T8SwRJRigVnpAn/dwVyr5TqRjxNBdKfCnf8lHEK/Hru8mki8mRwsveWoGMCW+q8uH1izKR/JV65AwevqcnmzXbv3wAdEe0whst9zEtUuPU6/bS3ZqDHB2H3BGumVQEHvVLDjl/TJfhQ6mHjrfEPef3d3gabm6VB4O0ilCO2JvaUuJiHWtdtn9Xb4e4NCqZVvamJj9BEN7FTGKo6FfJXUY0a9wwASf11TQeTwJYW0MBEvpmE4aljWh0g2HSxdRgW+CBf+A9laA0uwcaEn/KDHuIh0PdL7GdYuWwjxeO21hKa8Vyal2r8w+fM5T6/KPm2vNa7ErY2lMLNIQlI7eyOXi4s4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b984a07-bcfa-4c2a-f05d-08d84c68c18c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2020 22:13:28.4751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTqLs6/7jVvXp7ycyrt1tlnUUgTB/FFtmLBeVTsVmqLyuR5m3Lvrm8lJQqg4Oz6i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-29_15:2020-08-28,2020-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 impostorscore=0
 clxscore=1011 suspectscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/20 3:01 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Modify few tests to sanity test sleepable bpf functionality.
> 
> Running 'bench trig-fentry-sleep' vs 'bench trig-fentry' and 'perf report':
> sleepable with SRCU:
>     3.86%  bench     [k] __srcu_read_unlock
>     3.22%  bench     [k] __srcu_read_lock
>     0.92%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
>     0.50%  bench     [k] bpf_trampoline_10297
>     0.26%  bench     [k] __bpf_prog_exit_sleepable
>     0.21%  bench     [k] __bpf_prog_enter_sleepable
> 
> sleepable with RCU_TRACE:
>     0.79%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry_sleep
>     0.72%  bench     [k] bpf_trampoline_10381
>     0.31%  bench     [k] __bpf_prog_exit_sleepable
>     0.29%  bench     [k] __bpf_prog_enter_sleepable
> 
> non-sleepable with RCU:
>     0.88%  bench     [k] bpf_prog_740d4210cdcd99a3_bench_trigger_fentry
>     0.84%  bench     [k] bpf_trampoline_10297
>     0.13%  bench     [k] __bpf_prog_enter
>     0.12%  bench     [k] __bpf_prog_exit
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: KP Singh <kpsingh@google.com>
> ---
>   tools/testing/selftests/bpf/bench.c           |  2 +
>   .../selftests/bpf/benchs/bench_trigger.c      | 17 +++++
>   .../selftests/bpf/prog_tests/test_lsm.c       |  9 +++
>   tools/testing/selftests/bpf/progs/lsm.c       | 66 ++++++++++++++++++-
>   .../selftests/bpf/progs/trigger_bench.c       |  7 ++
>   5 files changed, 99 insertions(+), 2 deletions(-)
> 
[...]
> diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
> index b4598d4bc4f7..49fa6ca99755 100644
> --- a/tools/testing/selftests/bpf/progs/lsm.c
> +++ b/tools/testing/selftests/bpf/progs/lsm.c
> @@ -9,16 +9,41 @@
>   #include <bpf/bpf_tracing.h>
>   #include  <errno.h>
>   
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} array SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_HASH);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} hash SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_LRU_HASH);
> +	__uint(max_entries, 1);
> +	__type(key, __u32);
> +	__type(value, __u64);
> +} lru_hash SEC(".maps");
> +
>   char _license[] SEC("license") = "GPL";
>   
>   int monitored_pid = 0;
>   int mprotect_count = 0;
>   int bprm_count = 0;
>   
> -SEC("lsm/file_mprotect")
> +SEC("lsm.s/file_mprotect")

When running selftest, I hit the following kernel warning:

[  250.871267] ============================================ 

[  250.871902] WARNING: possible recursive locking detected 

[  250.872561] 5.9.0-rc1+ #830 Not tainted 

[  250.873166] -------------------------------------------- 

[  250.873991] true/2053 is trying to acquire lock: 

[  250.874715] ffff8fc1f9cd2068 (&mm->mmap_lock#2){++++}-{3:3}, at: 
__might_fault+0x3e/0x90
[  250.875943] 

[  250.875943] but task is already holding lock: 

[  250.876688] ffff8fc1f9cd2068 (&mm->mmap_lock#2){++++}-{3:3}, at: 
do_mprotect_pkey+0xb5/0x2f0 

[  250.877978] 

[  250.877978] other info that might help us debug this: 

[  250.878797]  Possible unsafe locking scenario: 

[  250.878797] 

[  250.879708]        CPU0 

[  250.880095]        ---- 

[  250.880482]   lock(&mm->mmap_lock#2); 

[  250.881063]   lock(&mm->mmap_lock#2); 

[  250.881645] 

[  250.881645]  *** DEADLOCK ***
[  250.881645] 

[  250.882559]  May be due to missing lock nesting notation 

[  250.882559]
[  250.883613] 2 locks held by true/2053:
[  250.884194]  #0: ffff8fc1f9cd2068 (&mm->mmap_lock#2){++++}-{3:3}, at: 
do_mprotect_pkey+0xb5/0x2f0
[  250.885558]  #1: ffffffffbc47b8a0 (rcu_read_lock_trace){....}-{0:0}, 
at: __bpf_prog_enter_sleepable+0x0/0x40
[  250.887062]
[  250.887062] stack backtrace:
[  250.887583] CPU: 1 PID: 2053 Comm: true Not tainted 5.9.0-rc1+ #830
[  250.888546] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.9.3-1.el7.centos 04/01/2014
[  250.889896] Call Trace:
[  250.890222]  dump_stack+0x78/0xa0
[  250.890644]  __lock_acquire.cold.74+0x209/0x2e3
[  250.891350]  lock_acquire+0xba/0x380
[  250.891919]  ? __might_fault+0x3e/0x90
[  250.892510]  ? __lock_acquire+0x639/0x20c0
[  250.893150]  __might_fault+0x68/0x90
[  250.893717]  ? __might_fault+0x3e/0x90
[  250.894325]  _copy_from_user+0x1e/0xa0
[  250.894946]  bpf_copy_from_user+0x22/0x50
[  250.895581]  bpf_prog_3717002769f30998_test_int_hook+0x76/0x60c
[  250.896446]  ? __bpf_prog_enter_sleepable+0x3c/0x40
[  250.897207]  ? __bpf_prog_exit+0xa0/0xa0
[  250.897819]  bpf_trampoline_18669+0x29/0x1000
[  250.898476]  bpf_lsm_file_mprotect+0x5/0x10
[  250.899133]  security_file_mprotect+0x32/0x50
[  250.899816]  do_mprotect_pkey+0x18a/0x2f0
[  250.900472]  __x64_sys_mprotect+0x1b/0x20
[  250.901107]  do_syscall_64+0x33/0x40
[  250.901670]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  250.902450] RIP: 0033:0x7fd95c141ef7
[  250.903014] Code: ff 66 90 b8 0b 00 00 00 0f 05 48 3d 01 f0 ff ff 73 
01 c3 48 8d 0d 21 c2 2
0 00 f7 d8 89 01 48 83 c8 ff c3 b8 0a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 
73 01 c3 48 8d 0d 01
c2 20 00 f7 d8 89 01 48 83
[  250.905732] RSP: 002b:00007ffd4c291fe8 EFLAGS: 00000246 ORIG_RAX: 
000000000000000a
[  250.906773] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 
00007fd95c141ef7
[  250.907866] RDX: 0000000000000000 RSI: 00000000001ff000 RDI: 
00007fd95bf20000
[  250.908906] RBP: 00007ffd4c292320 R08: 0000000000000000 R09: 
0000000000000000
[  250.909915] R10: 00007ffd4c291ff0 R11: 0000000000000246 R12: 
00007fd95c341000
[  250.910919] R13: 00007ffd4c292408 R14: 0000000000000002 R15: 
0000000000000801

Could this be an real issue here?

do_mprotect_pkey() gets a lock of current->mm->mmap_lock
before calling security_file_mprotect(bpf_lsm_file_mprotect).
Later on, when do _copy_to_user(), page fault may happen
and current->mm->mmap_lock might be acquired again and may
have a deadlock here?


>   int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
>   	     unsigned long reqprot, unsigned long prot, int ret)
>   {
> +	char args[64];
> +	__u32 key = 0;
> +	__u64 *value;
> +
>   	if (ret != 0)
>   		return ret;
>   
> @@ -28,6 +53,18 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
>   	is_stack = (vma->vm_start <= vma->vm_mm->start_stack &&
>   		    vma->vm_end >= vma->vm_mm->start_stack);
>   
> +	bpf_copy_from_user(args, sizeof(args), (void *)vma->vm_mm->arg_start);
> +
> +	value = bpf_map_lookup_elem(&array, &key);
> +	if (value)
> +		*value = 0;
> +	value = bpf_map_lookup_elem(&hash, &key);
> +	if (value)
> +		*value = 0;
> +	value = bpf_map_lookup_elem(&lru_hash, &key);
> +	if (value)
> +		*value = 0;
> +
>   	if (is_stack && monitored_pid == pid) {
>   		mprotect_count++;
>   		ret = -EPERM;
> @@ -36,7 +73,7 @@ int BPF_PROG(test_int_hook, struct vm_area_struct *vma,
>   	return ret;
>   }
>   
[...]
