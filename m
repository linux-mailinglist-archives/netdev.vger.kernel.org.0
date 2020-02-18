Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA18162D4D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgBRRp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:45:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38000 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726656AbgBRRp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:45:27 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01IHVk7Y014277;
        Tue, 18 Feb 2020 09:44:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1At1t5/Q1xBsCwufzrjKeADwrXo0F+mLR8sLOZEu7jk=;
 b=lzPkbmrFAaTRfDoRP7njmYUcp9lG0aJ7AW79z+BjGcsvDtEU1sv99kV6dOszQt2lj7gn
 Edg4nAPWQ5Y4KuyYpgtYWlqWtz/4Pj2yljWGwl1pW4Uwx88kDTgaaXwusFo+3x45R7hq
 Gxd9226WR6xTgm+xCAX9vbSgF9rFACbtTOY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y8fxbhk9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Feb 2020 09:44:45 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 18 Feb 2020 09:44:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zvr55xyEfMhekXKOSZ4P0KMM9ucPysk/dsNvrn6wlk6L8TePx9XvWxh1vunPsCHjOdQRHst4ZC4MZf9xpN5OWuonLntzkm6Xfp7qzqxRmc1ihOn/G3byRjRZq+cOdmWRqxqgneTUBYgtv7xhp8Uy5rKjt2g0FU6PlqceWgaLRrOnd3yxXyDNM5IizFuHIn1N+a1y2kwelMZSqQveliaI0Kh5gHfvbbdkpNQgIUBR45+VVRmhxQl6wai+4RgmAFThctb5/URHu4WnwAmpfi3MIu70e95cTsimP1XEwMi6Elo+t+HG6c0IfKCVntpWW2kF3zlirMUm/1i3k9pPe6ZaxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1At1t5/Q1xBsCwufzrjKeADwrXo0F+mLR8sLOZEu7jk=;
 b=lJytRXy6PMV4Q2GNDn2vIC2m5wqbD6IdmFCEZ8y4jjiKQkDs9MJZhoHf4dzn0Z4Ct66XiQZ7IwoeACMB9TCKHGez+wTh9UNEQuUINKrxVlRxyUUgk/hl4XJfFkMcmmJAxxO/6uB9gUmhGcyVOCAyoo2r+1CMkTl76kRrsoXXqm30Red50w+v41T3gwJXaaJyH+KsmdGJqE0nfx4t6RPS9Tz+7yVIBmkBpgp1y2Kzzsur/2MSZMAO9IlueCosIG2bTBU7YhYYGZSEpaFSvadOPAVpQM25dKjUWZLhrGxH+VUc7OBcsdIG8RDjH+j+hAlne+PeUSsT8MaSOntLQngpow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1At1t5/Q1xBsCwufzrjKeADwrXo0F+mLR8sLOZEu7jk=;
 b=ho2ARIvAn7lDAfysFDZMYbCvH/YmFjFahf0QPfQMm28ly1yRrpm+seSnAHNeKFfMqBB40dJmCR6xiL2sQ7H0EV1R1EoT76VJuYg47UbKbkdRPRY+ODSLToxddfKRfetRf6zwkG6QHzKaiHhQ38jJ8JLcfpdZDiHkP2qIR0Si+vU=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3209.namprd15.prod.outlook.com (20.179.51.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Tue, 18 Feb 2020 17:44:43 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 17:44:43 +0000
Subject: Re: possible deadlock in bpf_lru_push_free
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com>
CC:     <andriin@fb.com>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>
References: <20200217052336.5556-1-hdanton@sina.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <dca36c4b-bbf5-b215-faa9-1992240f2b69@fb.com>
Date:   Tue, 18 Feb 2020 09:44:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200217052336.5556-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0033.namprd14.prod.outlook.com
 (2603:10b6:300:12b::19) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::5:fd19) by MWHPR14CA0033.namprd14.prod.outlook.com (2603:10b6:300:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Tue, 18 Feb 2020 17:44:41 +0000
X-Originating-IP: [2620:10d:c090:500::5:fd19]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c238162-3e7c-498d-74f9-08d7b49a3c7f
X-MS-TrafficTypeDiagnostic: DM6PR15MB3209:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB32098E288F88E18D8F3BCA57D3110@DM6PR15MB3209.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10001)(10019020)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(189003)(31696002)(110136005)(2906002)(6486002)(36756003)(6512007)(52116002)(66476007)(4326008)(16526019)(186003)(66946007)(478600001)(966005)(6506007)(31686004)(81156014)(81166006)(8676002)(53546011)(5660300002)(316002)(66556008)(2616005)(8936002)(86362001)(99710200001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3209;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmM9R3ypAam7FGZs9yizciqujb0fjOa3jAf7eth8QvoywQtMJctk5bUqVf4+ItNPx2NeME2e8v0QuBWes7zHbhaXbrcmdWYlT5R8PNoWpIzgxUekYNDxnEtLltvsxCCcnj9qq7fjp45qr80LW1Z+O7nfPsQODpcCC74KicEVaH8G4K7XFh9lgEC5KJuER45xeK4Ng3HIUjH51hYVAQfLGez+x07hlFDP8XU5Zcu7csfoXezJdwosZcIAEE+5UbS+vXUlVB88idmgakOJqwCughLEAUqNgF981f3QxF0Yixhv3wz+wtH2OSaYI64rjyG4VOVk2emJEnOi/jO6y4avsUd4yI7sfW5yfdy5/zXPv2+t0rIeO0v0jbbb6Vu+sxPTc51ffyM2qFXYeozMoQdORozjCbovxTKtKNGk+yMpbZrEUZDBeHOXMLceiOeGZUM2fwzD2ERSHD+HyE2I+m75sCGlUsEpO5WwodUH9Pw4fQfkmpbhAhNDWcKgMsv1l39uGLB0boIybYvZ7LnWrNAVJ8XciSU6q0+WTfJF8gK7oE1JR1FJbjkwP92LpZZvXAHbJUtAZE4uMtM0AP6Majll55SgeVfKfgvBzxMDT3QTbKD429K5N0Ze5LDEoB4/QeU77QcgTPZ1R9DGJCwGhO7OXg==
X-MS-Exchange-AntiSpam-MessageData: peISKVRoAyqV/rwnud5TGH+5T+sZpuv6g+Vt32YR0Rvs50GqX+UJ//S+JiGLSbjYRyPd/JwWOiwxOhV1AQnSzja8aLK48u1Hq+VJ3tLpUfx7fQi5vrTP8akedsdiWgI5dFtADgMzKpr8ihr1CV42wmzoknJEY2k4qmmdMZ/dFsD+vB4tkSu2OkBBO42cYLiN
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c238162-3e7c-498d-74f9-08d7b49a3c7f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 17:44:43.0932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GP+KZx/2hDwDEWTYJ5wEYljJXDFFcVkCFsVAqgmmR+xF2i2nHmrtTnTv63rRBKLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3209
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_05:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=525 malwarescore=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002180124
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/20 9:23 PM, Hillf Danton wrote:
> 
> On Sun, 16 Feb 2020 04:17:09 -0800
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    2019fc96 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
>> git tree:       net
>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D1358bb11e00000&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=zrgWcBnddWkMWG2zm-9nC8EwvHMsuqw_-EEXwl23XLg&e=
>> kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D735296e4dd620b10&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=kbT6Yw89JDoIWSQtlLJ7sjyNoP2Ulud27GNorna1zQk&e=
>> dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D122b5421d14e68f29cd1&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=U3pdUmrcroaeNsJ9DgFbTlvftQUCUcJ1CW_0NxS8yGA&e=
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>> syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D14b67d6ee00000&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=TuSfjosRFQW3ArpQwikTtx-dgLLBSMgJfVKtUltqQBM&e=
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com
>>
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> 5.6.0-rc1-syzkaller #0 Not tainted
>> ------------------------------------------------------
>> syz-executor.4/13544 is trying to acquire lock:
>> ffffe8ffffcba0b8 (&loc_l->lock){....}, at: bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
>> ffffe8ffffcba0b8 (&loc_l->lock){....}, at: bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
>>
>> but task is already holding lock:
>> ffff888094985960 (&htab->buckets[i].lock){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 (&htab->buckets[i].lock){....}:
>>         __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>>         _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>>         htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593
>>         __bpf_lru_list_shrink_inactive kernel/bpf/bpf_lru_list.c:220 [inline]
>>         __bpf_lru_list_shrink+0xf9/0x470 kernel/bpf/bpf_lru_list.c:266
>>         bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:340 [inline]
>>         bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
>>         bpf_lru_pop_free+0x87c/0x1670 kernel/bpf/bpf_lru_list.c:499
>>         prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
>>         __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
>>         bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
>>         bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
>>         generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>         __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> -> #1 (&l->lock){....}:
>>         __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>>         _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
>>         bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325 [inline]
>>         bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
>>         bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499
>>         prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
>>         __htab_lru_percpu_map_update_elem+0x67e/0xa90 kernel/bpf/hashtab.c:1069
>>         bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
>>         bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
>>         generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>         __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> -> #0 (&loc_l->lock){....}:
>>         check_prev_add kernel/locking/lockdep.c:2475 [inline]
>>         check_prevs_add kernel/locking/lockdep.c:2580 [inline]
>>         validate_chain kernel/locking/lockdep.c:2970 [inline]
>>         __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
>>         lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
>>         __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>>         _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>>         bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
>>         bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
>>         __htab_map_lookup_and_delete_batch+0x8d4/0x1540 kernel/bpf/hashtab.c:1374
>>         htab_lru_map_lookup_and_delete_batch+0x34/0x40 kernel/bpf/hashtab.c:1491
>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>         __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> other info that might help us debug this:
>>
>> Chain exists of:
>>    &loc_l->lock --> &l->lock --> &htab->buckets[i].lock
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&htab->buckets[i].lock);
>>                                 lock(&l->lock);
>>                                 lock(&htab->buckets[i].lock);
>>    lock(&loc_l->lock);
>>
>>   *** DEADLOCK ***
>>
>> 2 locks held by syz-executor.4/13544:
>>   #0: ffffffff89bac240 (rcu_read_lock){....}, at: __htab_map_lookup_and_delete_batch+0x54b/0x1540 kernel/bpf/hashtab.c:1308
>>   #1: ffff888094985960 (&htab->buckets[i].lock){....}, at: __htab_map_lookup_and_delete_batch+0x617/0x1540 kernel/bpf/hashtab.c:1322
>>
>> stack backtrace:
>> CPU: 0 PID: 13544 Comm: syz-executor.4 Not tainted 5.6.0-rc1-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>>   print_circular_bug.isra.0.cold+0x163/0x172 kernel/locking/lockdep.c:1684
>>   check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
>>   check_prev_add kernel/locking/lockdep.c:2475 [inline]
>>   check_prevs_add kernel/locking/lockdep.c:2580 [inline]
>>   validate_chain kernel/locking/lockdep.c:2970 [inline]
>>   __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
>>   lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
>>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>>   _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>>   bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
>>   bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
>>   __htab_map_lookup_and_delete_batch+0x8d4/0x1540 kernel/bpf/hashtab.c:1374
>>   htab_lru_map_lookup_and_delete_batch+0x34/0x40 kernel/bpf/hashtab.c:1491
>>   bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>   __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
>>   __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>   __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Reclaim hash table elememt outside bucket lock.

Thanks for the following patch. Yes, we do have an potential issue
with the above deadlock if LRU hash map is not preallocated.

I am not a RCU expert, but maybe you could you help clarify
one thing below?

> 
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1259,6 +1259,7 @@ __htab_map_lookup_and_delete_batch(struc
>   	u64 elem_map_flags, map_flags;
>   	struct hlist_nulls_head *head;
>   	struct hlist_nulls_node *n;
> +	struct hlist_nulls_node *node_to_free = NULL;
>   	unsigned long flags;
>   	struct htab_elem *l;
>   	struct bucket *b;
> @@ -1370,9 +1371,10 @@ again_nocopy:
>   		}
>   		if (do_delete) {
>   			hlist_nulls_del_rcu(&l->hash_node);
> -			if (is_lru_map)
> -				bpf_lru_push_free(&htab->lru, &l->lru_node);
> -			else
> +			if (is_lru_map) {
> +				l->hash_node.next = node_to_free;
> +				node_to_free = &l->hash_node;

Here, we change "next" pointer. How does this may impact the existing 
parallel map lookup which does not need to take bucket pointer?

> +			} else
>   				free_htab_elem(htab, l);
>   		}
>   		dst_key += key_size;
> @@ -1380,6 +1382,12 @@ again_nocopy:
>   	}
>   
>   	raw_spin_unlock_irqrestore(&b->lock, flags);
> +
> +	while (node_to_free) {
> +		l = container_of(node_to_free, struct htab_elem, hash_node);
> +		node_to_free = node_to_free->next;
> +		bpf_lru_push_free(&htab->lru, &l->lru_node);
> +	}
>   	/* If we are not copying data, we can go to next bucket and avoid
>   	 * unlocking the rcu.
>   	 */
> 
