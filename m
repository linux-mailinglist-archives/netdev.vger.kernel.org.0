Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09554256AA6
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 00:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgH2WjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 18:39:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728063AbgH2WjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 18:39:23 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07TMVmul021717;
        Sat, 29 Aug 2020 15:39:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xcJJXxboOdcxkNUPsO2qQn1SecjFmMSxiDF50FRjXnw=;
 b=bUWM9RiJ101G1IYobOgJH1OqZvwEoFP/cwN1ixttKxLmce3Nzp7MygOIlwySQ3dnlAxM
 phu/t2HdKdrtjgyZnXir+bFwaUGEwk1RUdN/HzbROckOmNiJqTrAahwYNi1vpmGclfsE
 LLIvLnDZBwLGWWqeE5SH3e5Zpj94cy4EcXQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 337jbct7yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 29 Aug 2020 15:39:03 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 29 Aug 2020 15:39:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTzZjoayxncLRfcBdO4CIWNta/aIh2F52mR8sQvHg4znBgEb5i8NcfL7Rd9tOeyv8uK+lcvmf6AmYuXyF+YmE6G4xykrSZL2oMaS6e02T7eqMktHrw/5Ol8zZ7rz0XNwjGtrWPeJYiMfIw/mCX+1Nqo+cUKHDnm+suVZrlC2FoGEtotk3RtDE0DVESNRvTudp1PHuaM2VMZolqgavoSAouZMt5OMFYn4wTOeBAB+7J1MZB8rwps3OrOhsOWXcBVd06EUgRxdlS6F0WtO/pHRjF+y3sEba5D63GnTx3EAOe9qGoF5k2kZ1WJmPYG+rCJkAE7ijSLVKOCEnw3cDZtD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcJJXxboOdcxkNUPsO2qQn1SecjFmMSxiDF50FRjXnw=;
 b=TeDKitbKdScBi3rlHLg/s7j8F7Rf5vwu7Vi9DxnrTNEotyx6ZILwnxRMf9G6wEXE1XuCt2YuxwmoxzUqqhYH/29nJ9lMIW5ScuwITzyc7echGonJUoEP6M0scNapaZfetbsn1n4nBML9hBBZFfhYozaUIAZvWykQIxCo7RBhWWQHbcy8mcMqJQ0ZAzgnuMhXatxRc2Q2UVxLDGt2RD+ERG95p1w7jjHegfaqXwWXXhxw2IXPMgiOMuISqFhcjVfiIL2/ADI+9a34tIagSB8gEir/6N+oMZA1bMxLuguLh2Wi3394KBXpJNBOCecl8PI+O2wwTJL1w3y+YK60wR8CVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcJJXxboOdcxkNUPsO2qQn1SecjFmMSxiDF50FRjXnw=;
 b=NcywErjqmRXzHkVupcFFOSdgPqlC6ndtLd0ckeO39EEVSqj24HRK2ef/Ea8jaX7l2ra29SS451VRicdJBAm1ZujsRy5GU/orLM9165m/sXmpzrNsPtzTOViiKIR7o+Gb1CKK64voWoEYdQ49GFRi7OKUj7dW3IPyWe1ow/Y5ssc=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3787.namprd15.prod.outlook.com (2603:10b6:303:4d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Sat, 29 Aug
 2020 22:38:47 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446%3]) with mapi id 15.20.3326.024; Sat, 29 Aug 2020
 22:38:47 +0000
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: Add sleepable tests
To:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <josef@toxicpanda.com>,
        <bpoirier@suse.com>, <akpm@linux-foundation.org>,
        <hannes@cmpxchg.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
References: <20200827220114.69225-1-alexei.starovoitov@gmail.com>
 <20200827220114.69225-6-alexei.starovoitov@gmail.com>
 <00667ff9-1f1d-068b-4f5d-4a90385437b1@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <6ffb1b52-51a0-3faa-04d8-77a9e54d03a9@fb.com>
Date:   Sat, 29 Aug 2020 15:38:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <00667ff9-1f1d-068b-4f5d-4a90385437b1@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0061.namprd07.prod.outlook.com
 (2603:10b6:a03:60::38) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BYAPR07CA0061.namprd07.prod.outlook.com (2603:10b6:a03:60::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Sat, 29 Aug 2020 22:38:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:9043]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3614df0-b796-42c9-e1e5-08d84c6c4b0b
X-MS-TrafficTypeDiagnostic: MW3PR15MB3787:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB378775DF3BC783A794E590D6D7530@MW3PR15MB3787.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1gjzZW3V85jc+Y50RxQxKEPOsxy30tYw5QE75IQOjYy+DzUDOorbxMdsbbnymphx4Z/woG8RCLG3OUWD4mIY8ahCX+voRTB0vfghUrtSGH55qSC9t0Uc7lO5/IOF/8uD+1KTlUkcUjKZV13EB9qeNjc/m9o7elqWlPAWB+xup5wJBUIplDYtCJ9uOp+jw8KhbSSAhNsV/d5d96XFh96SGk5oUpJdaPinsNuYfc2EQtEU9cttpzM+fQDtdCwtlxn9YzMMfefoMUJXmXS4G2TVO/Ut3zXSUJfPPpfJyMSRAOqhIvfGWvP+yczA4HKpYE7UWRVpgWlyXyCkvWqjUgor3P8SE/QUtZVmflEOfx1KhV3ISPOIZ75/TyBymkkfZEG5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(5660300002)(36756003)(2906002)(86362001)(4326008)(31696002)(8936002)(53546011)(66476007)(66556008)(8676002)(6486002)(956004)(2616005)(31686004)(186003)(16576012)(316002)(66946007)(83380400001)(478600001)(6666004)(110136005)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DqWhfdTkDFVbLwaW4m9LZUOm6+De6+cqz1+aRp5RCO3/11bbhFuZJtd/D1c6VTuax3ZMNcdIZU3hXHK9TQiNKqY6ihGH3s4bh0y1CqqLix53JS7EVNwgfWd+jnA++7o7fV+WbfkxqtH5JnXjoix4aendt1+Xw2oD6VWFQBN3I/pu56SCSZ/4ITaKYR5tDffobk8XoJ1VphTgZB3kzJ7b+3oRwZNOt6U3t5Lm0oF1AC8hvb2s4h1u/y4ODc9vNrF84et+2Sc16ygxDlBp3IEI60RnSSw1/hw8pK/j4Pv+7r9uQCrMOJ4NZGr9mwsWkT9rD/aKE5PLye8ZEBNf/zQ1hthsgJ7w9RW0PNjXqmUqsu0Gnl0vXQHMlJEm4SJoYagiSJDHWnR+rgE4OfE9BdDsOFZcYWsVOk4hIVagwE8Ke4ISGLd0tfsEXuosek8FETyD6d05QDvCEcAaDpkHGf19twMDIFozyg6LgvvNLUixq2U3I/tczzHNft/w74c5GqrZhq3V7gEpUS6PMik9IxK1njTl0fWapvsnbyRJy/wCja/yJzk3fTsqIaxnxKdtvetWyC2U+CYi4fIN39neJqCrU99qorew7VaejDhATDouDnJ0MmAc369VilOC/Dqi+r1ArW1EiZJ5dqx5bgE+uuLHmDFsxZacpDB/Lx8YUZQbNzU=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3614df0-b796-42c9-e1e5-08d84c6c4b0b
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2020 22:38:47.4503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gFJqpGqg4gSztfvKeQgaPOu+GS6kyDrGZxTmhJgdoU230CBDJ3ux1ZPwwdXiOQ1M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3787
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-29_15:2020-08-28,2020-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 impostorscore=0 suspectscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 spamscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008290184
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/20 3:13 PM, Yonghong Song wrote:
> 
> When running selftest, I hit the following kernel warning:
> 
> [  250.871267] ============================================
> [  250.871902] WARNING: possible recursive locking detected
> [  250.872561] 5.9.0-rc1+ #830 Not tainted
> [  250.873166] --------------------------------------------
> [  250.873991] true/2053 is trying to acquire lock:
> [  250.874715] ffff8fc1f9cd2068 (&mm->mmap_lock#2){++++}-{3:3}, at: 
> __might_fault+0x3e/0x90
> [  250.875943]
> [  250.875943] but task is already holding lock:
> [  250.876688] ffff8fc1f9cd2068 (&mm->mmap_lock#2){++++}-{3:3}, at: 
> do_mprotect_pkey+0xb5/0x2f0
> [  250.877978]
> [  250.877978] other info that might help us debug this:
> [  250.878797]  Possible unsafe locking scenario:
> [  250.878797]
> [  250.879708]        CPU0
> [  250.880095]        ----
> [  250.880482]   lock(&mm->mmap_lock#2);
> [  250.881063]   lock(&mm->mmap_lock#2);
> [  250.881645]
> [  250.881645]  *** DEADLOCK ***
> [  250.881645]
> [  250.882559]  May be due to missing lock nesting notation
> [  250.882559]
> [  250.883613] 2 locks held by true/2053:
> [  250.884194]  #0: ffff8fc1f9cd2068 (&mm->mmap_lock#2){++++}-{3:3}, at: 
> do_mprotect_pkey+0xb5/0x2f0
> [  250.885558]  #1: ffffffffbc47b8a0 (rcu_read_lock_trace){....}-{0:0}, 
> at: __bpf_prog_enter_sleepable+0x0/0x40
> [  250.887062]
> [  250.887062] stack backtrace:
> [  250.887583] CPU: 1 PID: 2053 Comm: true Not tainted 5.9.0-rc1+ #830
> [  250.888546] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
> BIOS 1.9.3-1.el7.centos 04/01/2014
> [  250.889896] Call Trace:
> [  250.890222]  dump_stack+0x78/0xa0
> [  250.890644]  __lock_acquire.cold.74+0x209/0x2e3
> [  250.891350]  lock_acquire+0xba/0x380
> [  250.891919]  ? __might_fault+0x3e/0x90
> [  250.892510]  ? __lock_acquire+0x639/0x20c0
> [  250.893150]  __might_fault+0x68/0x90
> [  250.893717]  ? __might_fault+0x3e/0x90
> [  250.894325]  _copy_from_user+0x1e/0xa0
> [  250.894946]  bpf_copy_from_user+0x22/0x50
> [  250.895581]  bpf_prog_3717002769f30998_test_int_hook+0x76/0x60c
> [  250.896446]  ? __bpf_prog_enter_sleepable+0x3c/0x40
> [  250.897207]  ? __bpf_prog_exit+0xa0/0xa0
> [  250.897819]  bpf_trampoline_18669+0x29/0x1000
> [  250.898476]  bpf_lsm_file_mprotect+0x5/0x10
> [  250.899133]  security_file_mprotect+0x32/0x50
> [  250.899816]  do_mprotect_pkey+0x18a/0x2f0
> [  250.900472]  __x64_sys_mprotect+0x1b/0x20
> [  250.901107]  do_syscall_64+0x33/0x40
> [  250.901670]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  250.902450] RIP: 0033:0x7fd95c141ef7
> [  250.903014] Code: ff 66 90 b8 0b 00 00 00 0f 05 48 3d 01 f0 ff ff 73 
> 01 c3 48 8d 0d 21 c2 2
> 0 00 f7 d8 89 01 48 83 c8 ff c3 b8 0a 00 00 00 0f 05 <48> 3d 01 f0 ff ff 
> 73 01 c3 48 8d 0d 01
> c2 20 00 f7 d8 89 01 48 83
> [  250.905732] RSP: 002b:00007ffd4c291fe8 EFLAGS: 00000246 ORIG_RAX: 
> 000000000000000a
> [  250.906773] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 
> 00007fd95c141ef7
> [  250.907866] RDX: 0000000000000000 RSI: 00000000001ff000 RDI: 
> 00007fd95bf20000
> [  250.908906] RBP: 00007ffd4c292320 R08: 0000000000000000 R09: 
> 0000000000000000
> [  250.909915] R10: 00007ffd4c291ff0 R11: 0000000000000246 R12: 
> 00007fd95c341000
> [  250.910919] R13: 00007ffd4c292408 R14: 0000000000000002 R15: 
> 0000000000000801
> 
> Could this be an real issue here?
> 
> do_mprotect_pkey() gets a lock of current->mm->mmap_lock
> before calling security_file_mprotect(bpf_lsm_file_mprotect).
> Later on, when do _copy_to_user(), page fault may happen
> and current->mm->mmap_lock might be acquired again and may
> have a deadlock here?

Hmm. It does sound like dead_lock.
But I don't understand why I don't see this splat.
I have
LOCKDEP=y
DEBUG_ATOMIC_SLEEP=y
LOCK_DEBUGGING_SUPPORT=y
KASAN=y
in my .config and don't see it :(
Could pls send me your .config?
I'll analyze further.
Thanks for the reporting!
