Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C49C1637C2
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgBRXzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:55:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5580 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727322AbgBRXzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:55:37 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01INnqoB012769;
        Tue, 18 Feb 2020 15:55:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Ag4dXDsjk1D07eqAqFFknPruP8CHt4TDzHFeX2fMPlc=;
 b=i9Xk2QK4+4Z4dWJo0QWYZWLUj6siVAGp1yCvNIHlUvvQhowy7llfqUierxY/q9YFFMe8
 D+L4w4HlW9D5OiwFOvj+/PSFwN42N94OdMk4jzptk8E42YcfvrFW0mFmvbfjF6sFdRYa
 H2b8y2O8hHZhedGfErooEjJlcsSy7mITnnA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y8jtdjek7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Feb 2020 15:55:08 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 18 Feb 2020 15:55:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIwpQGsFNPZ5fnU/Sr2yUfAHQawNKOifEWNmjNR4KbtOZpnx7P5flWjKH5ajhOjHcfNreJ1vfDxt4Ed7ZnLuZqgaRjzfqwZjKfMGEN1f2Q3B9tfUygmoMEVzfgpR2pGXnsSEpjpTKRpL1HHI2/ZO8Oh0qx2UX3+YS6KYRqai4VzQPWIQgBwqhLby7KHxxQFkM72nKDDpB3lZeLR7Q+5LKb512g91GvIJQKR9IfblIhZBTNn3n3VRL6Y8yBaugxL8x6z5e6GkegQHpEWwokK61hMGD0S1QUfFWaM20RyU4na9+07mweyJPX+FiNqrd7bzZjXvISrcnMnzc7xMRWSU/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag4dXDsjk1D07eqAqFFknPruP8CHt4TDzHFeX2fMPlc=;
 b=eEV7hmlLfLpse1lOvRJC+1im0SCoCHnebinP7XpHejGOV56/Z+bTFPcrnEVN1grRyZLCvzGXDleR7DvXlyP6RMKn7yorkUg10jBIJMOvozJYYsQ6HmYnawKRDLa53+Iw7ylrGEAlIjw/1EtADuoUA/Lc2zSHNCEUKJmImwezfnduahoaKfZF0Dd9ruUpFQl7lTsfBQxOcM3imn9KM7gZZMq4URWnwiR6uPojKrgNexZ6infPqbUNHFQydCfixEP77ofF1z/hmA7LzzhHnX4lrPYd6u60RLw6UFVqQgHmr9lKJTOQHtEOoJWCuc4c1M+dmuFOcXvWumotKhi8n6HXug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag4dXDsjk1D07eqAqFFknPruP8CHt4TDzHFeX2fMPlc=;
 b=BiRCREP4yTS70ORSnIO998UT07X0B+QFTb4SGZ6wEzSybKgBncSaSSlrB6A+snauQmXBA3uvKDuhM+eyg2BsQAPlm5ZqRx8JCUHuZ8+rS0AaHemxELNiinHF+EtbQaKR0VwGDKqLqYdmKTAa3nMJNovZXBJPAeHsXGaGMOWgmtI=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB3211.namprd15.prod.outlook.com (20.179.50.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Tue, 18 Feb 2020 23:55:06 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2729.032; Tue, 18 Feb 2020
 23:55:06 +0000
Subject: Re: possible deadlock in bpf_lru_push_free
From:   Yonghong Song <yhs@fb.com>
To:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com>
CC:     <andriin@fb.com>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>
References: <20200217052336.5556-1-hdanton@sina.com>
 <dca36c4b-bbf5-b215-faa9-1992240f2b69@fb.com>
Message-ID: <d7ec13dc-a7e7-9381-9728-9157454cadc9@fb.com>
Date:   Tue, 18 Feb 2020 15:55:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <dca36c4b-bbf5-b215-faa9-1992240f2b69@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR12CA0057.namprd12.prod.outlook.com
 (2603:10b6:300:103::19) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:500::4:4c4a) by MWHPR12CA0057.namprd12.prod.outlook.com (2603:10b6:300:103::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Tue, 18 Feb 2020 23:55:04 +0000
X-Originating-IP: [2620:10d:c090:500::4:4c4a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea455a2f-5227-49a5-1979-08d7b4cdfa5d
X-MS-TrafficTypeDiagnostic: DM6PR15MB3211:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB321171B0625847A202AAFEBFD3110@DM6PR15MB3211.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10001)(10019020)(346002)(376002)(39860400002)(136003)(396003)(366004)(189003)(199004)(2616005)(8936002)(81156014)(86362001)(8676002)(81166006)(31696002)(31686004)(36756003)(4326008)(52116002)(30864003)(110136005)(66946007)(5660300002)(66476007)(316002)(66556008)(186003)(16526019)(6512007)(6486002)(2906002)(966005)(478600001)(6506007)(53546011)(99710200001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3211;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Xpvx0VMU7GtjAygFaDtUyuls2lF8DapENY6N+fz1Uo7+LXqqF2fqZQvsX1P9LgxMNDcUiUqS2E5Nnl3AofJSQWNLLJXVv4ndC38bu+1gnKuVYL0t+JVeMukBkJyVtY8WHDPfroV7kKe7uL6RBLEqRJHUW3At5n/kFVTTboeE4hQExIn3v6JUJG0CynH3kI1t2SQYT00yu/xLI3ZnOYaklyh5VHtHbgLRKTaM4tMJHh025FwJqtZYaNrhNBplU7dRJO1DlO+H0/mPxDPTGws+CbpMHTpsQf9exZBVAckOLf8ljEfKp8c+0sT3nzKNhhmLCi7BeRJG7svj/8Sr97Beg3Mfxkuzi06NILsEvp6R4CahLC5LVhb9uh3dWTQ49FmZFGI436ZQ1UkLRexYCnrckVXFO7r0AEZbU/d2Dx0aq+n+vzuCvicDgydU99BMjK2r5DJmnafouMGpbUWk/57HxXW9zFXKT9gPTxbHG8mqbM9xe/t7UkSOuEZy8G1K640hVnBtKDIAi5EXig1+pLyTZEa9N9doBAHNfMTsDbkgjv5hOqS5+ZCjy4gEwbW87H4WFTBtHpi5MBBqHOCm3kXJbaulZy7Alo55gljNMwyU/ZVPCk30ChG+GA96VKGf5IPxaOy4HaVXI1IP0QnrdawLA==
X-MS-Exchange-AntiSpam-MessageData: N9OU0CAlgpNmg49tc+4WZE2DQHhq5Q8MOlMrvKtFRrWGQTazi73yiZrwF09Nqnzxn/tQq87HxoysGHrlahT9Rhrf0kVAOyJoxyxnI4jIzJgsqotVAncjH5UP6HILbRZ9PS1+GRy7TazpGqG6Fsod8NplB0SY4NR10Ac1J3Yt9v1Qq1YsLE9Okn08gNEtksON
X-MS-Exchange-CrossTenant-Network-Message-Id: ea455a2f-5227-49a5-1979-08d7b4cdfa5d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2020 23:55:06.0553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RiqNNIj+EhOOXweUpOUEcDn0c9bvSznSCLH/Yjte7OOKRj4EqbwqTvpC7Uvta8hk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3211
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-18_08:2020-02-18,2020-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=852 clxscore=1015 bulkscore=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002180163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/20 9:44 AM, Yonghong Song wrote:
> 
> 
> On 2/16/20 9:23 PM, Hillf Danton wrote:
>>
>> On Sun, 16 Feb 2020 04:17:09 -0800
>>> syzbot has found a reproducer for the following crash on:
>>>
>>> HEAD commit:    2019fc96 Merge 
>>> git://git.kernel.org/pub/scm/linux/kernel/g..
>>> git tree:       net
>>> console output: 
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D1358bb11e00000&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=zrgWcBnddWkMWG2zm-9nC8EwvHMsuqw_-EEXwl23XLg&e= 
>>>
>>> kernel config:  
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D735296e4dd620b10&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=kbT6Yw89JDoIWSQtlLJ7sjyNoP2Ulud27GNorna1zQk&e= 
>>>
>>> dashboard link: 
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D122b5421d14e68f29cd1&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=U3pdUmrcroaeNsJ9DgFbTlvftQUCUcJ1CW_0NxS8yGA&e= 
>>>
>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>> syz repro:      
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D14b67d6ee00000&d=DwIDAg&c=5VD0RTtNlTh3ycd41b3MUw&r=DA8e1B5r073vIqRrFz7MRA&m=npe_gMkFnfxt6F5dGLs6zsNHWkYM30LkMFOk1_ZR1w8&s=TuSfjosRFQW3ArpQwikTtx-dgLLBSMgJfVKtUltqQBM&e= 
>>>
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the 
>>> commit:
>>> Reported-by: syzbot+122b5421d14e68f29cd1@syzkaller.appspotmail.com
>>>
>>> ======================================================
>>> WARNING: possible circular locking dependency detected
>>> 5.6.0-rc1-syzkaller #0 Not tainted
>>> ------------------------------------------------------
>>> syz-executor.4/13544 is trying to acquire lock:
>>> ffffe8ffffcba0b8 (&loc_l->lock){....}, at: bpf_common_lru_push_free 
>>> kernel/bpf/bpf_lru_list.c:516 [inline]
>>> ffffe8ffffcba0b8 (&loc_l->lock){....}, at: 
>>> bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
>>>
>>> but task is already holding lock:
>>> ffff888094985960 (&htab->buckets[i].lock){....}, at: 
>>> __htab_map_lookup_and_delete_batch+0x617/0x1540 
>>> kernel/bpf/hashtab.c:1322
>>>
>>> which lock already depends on the new lock.
>>>
>>>
>>> the existing dependency chain (in reverse order) is:
>>>
>>> -> #2 (&htab->buckets[i].lock){....}:
>>>         __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 
>>> [inline]
>>>         _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>>>         htab_lru_map_delete_node+0xce/0x2f0 kernel/bpf/hashtab.c:593
>>>         __bpf_lru_list_shrink_inactive kernel/bpf/bpf_lru_list.c:220 
>>> [inline]
>>>         __bpf_lru_list_shrink+0xf9/0x470 kernel/bpf/bpf_lru_list.c:266
>>>         bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:340 
>>> [inline]
>>>         bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
>>>         bpf_lru_pop_free+0x87c/0x1670 kernel/bpf/bpf_lru_list.c:499
>>>         prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
>>>         __htab_lru_percpu_map_update_elem+0x67e/0xa90 
>>> kernel/bpf/hashtab.c:1069
>>>         bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
>>>         bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
>>>         generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
>>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>>         __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
>>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>> -> #1 (&l->lock){....}:
>>>         __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
>>>         _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
>>>         bpf_lru_list_pop_free_to_local kernel/bpf/bpf_lru_list.c:325 
>>> [inline]
>>>         bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:447 [inline]
>>>         bpf_lru_pop_free+0x67f/0x1670 kernel/bpf/bpf_lru_list.c:499
>>>         prealloc_lru_pop+0x2c/0xa0 kernel/bpf/hashtab.c:132
>>>         __htab_lru_percpu_map_update_elem+0x67e/0xa90 
>>> kernel/bpf/hashtab.c:1069
>>>         bpf_percpu_hash_update+0x16e/0x210 kernel/bpf/hashtab.c:1585
>>>         bpf_map_update_value.isra.0+0x2d7/0x8e0 kernel/bpf/syscall.c:181
>>>         generic_map_update_batch+0x41f/0x610 kernel/bpf/syscall.c:1319
>>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>>         __do_sys_bpf+0x9b7/0x41e0 kernel/bpf/syscall.c:3460
>>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>> -> #0 (&loc_l->lock){....}:
>>>         check_prev_add kernel/locking/lockdep.c:2475 [inline]
>>>         check_prevs_add kernel/locking/lockdep.c:2580 [inline]
>>>         validate_chain kernel/locking/lockdep.c:2970 [inline]
>>>         __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
>>>         lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
>>>         __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 
>>> [inline]
>>>         _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>>>         bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
>>>         bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
>>>         __htab_map_lookup_and_delete_batch+0x8d4/0x1540 
>>> kernel/bpf/hashtab.c:1374
>>>         htab_lru_map_lookup_and_delete_batch+0x34/0x40 
>>> kernel/bpf/hashtab.c:1491
>>>         bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>>         __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
>>>         __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>>         __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>>         do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>>
>>> other info that might help us debug this:
>>>
>>> Chain exists of:
>>>    &loc_l->lock --> &l->lock --> &htab->buckets[i].lock
>>>
>>>   Possible unsafe locking scenario:
>>>
>>>         CPU0                    CPU1
>>>         ----                    ----
>>>    lock(&htab->buckets[i].lock);
>>>                                 lock(&l->lock);
>>>                                 lock(&htab->buckets[i].lock);
>>>    lock(&loc_l->lock);
>>>
>>>   *** DEADLOCK ***
>>>
>>> 2 locks held by syz-executor.4/13544:
>>>   #0: ffffffff89bac240 (rcu_read_lock){....}, at: 
>>> __htab_map_lookup_and_delete_batch+0x54b/0x1540 
>>> kernel/bpf/hashtab.c:1308
>>>   #1: ffff888094985960 (&htab->buckets[i].lock){....}, at: 
>>> __htab_map_lookup_and_delete_batch+0x617/0x1540 
>>> kernel/bpf/hashtab.c:1322
>>>
>>> stack backtrace:
>>> CPU: 0 PID: 13544 Comm: syz-executor.4 Not tainted 
>>> 5.6.0-rc1-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, 
>>> BIOS Google 01/01/2011
>>> Call Trace:
>>>   __dump_stack lib/dump_stack.c:77 [inline]
>>>   dump_stack+0x197/0x210 lib/dump_stack.c:118
>>>   print_circular_bug.isra.0.cold+0x163/0x172 
>>> kernel/locking/lockdep.c:1684
>>>   check_noncircular+0x32e/0x3e0 kernel/locking/lockdep.c:1808
>>>   check_prev_add kernel/locking/lockdep.c:2475 [inline]
>>>   check_prevs_add kernel/locking/lockdep.c:2580 [inline]
>>>   validate_chain kernel/locking/lockdep.c:2970 [inline]
>>>   __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3954
>>>   lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
>>>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>>>   _raw_spin_lock_irqsave+0x95/0xcd kernel/locking/spinlock.c:159
>>>   bpf_common_lru_push_free kernel/bpf/bpf_lru_list.c:516 [inline]
>>>   bpf_lru_push_free+0x250/0x5b0 kernel/bpf/bpf_lru_list.c:555
>>>   __htab_map_lookup_and_delete_batch+0x8d4/0x1540 
>>> kernel/bpf/hashtab.c:1374
>>>   htab_lru_map_lookup_and_delete_batch+0x34/0x40 
>>> kernel/bpf/hashtab.c:1491
>>>   bpf_map_do_batch+0x3f5/0x510 kernel/bpf/syscall.c:3348
>>>   __do_sys_bpf+0x1f7d/0x41e0 kernel/bpf/syscall.c:3456
>>>   __se_sys_bpf kernel/bpf/syscall.c:3355 [inline]
>>>   __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3355
>>>   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> Reclaim hash table elememt outside bucket lock.
> 
> Thanks for the following patch. Yes, we do have an potential issue
> with the above deadlock if LRU hash map is not preallocated.
> 
> I am not a RCU expert, but maybe you could you help clarify
> one thing below?
> 
>>
>> --- a/kernel/bpf/hashtab.c
>> +++ b/kernel/bpf/hashtab.c
>> @@ -1259,6 +1259,7 @@ __htab_map_lookup_and_delete_batch(struc
>>       u64 elem_map_flags, map_flags;
>>       struct hlist_nulls_head *head;
>>       struct hlist_nulls_node *n;
>> +    struct hlist_nulls_node *node_to_free = NULL;
>>       unsigned long flags;
>>       struct htab_elem *l;
>>       struct bucket *b;
>> @@ -1370,9 +1371,10 @@ again_nocopy:
>>           }
>>           if (do_delete) {
>>               hlist_nulls_del_rcu(&l->hash_node);
>> -            if (is_lru_map)
>> -                bpf_lru_push_free(&htab->lru, &l->lru_node);
>> -            else
>> +            if (is_lru_map) {
>> +                l->hash_node.next = node_to_free;
>> +                node_to_free = &l->hash_node;
> 
> Here, we change "next" pointer. How does this may impact the existing 
> parallel map lookup which does not need to take bucket pointer?

Thanks for Martin for explanation! I think changing l->hash_node.next is
unsafe here as another thread may execute on a different cpu and
traverse the same list. It will see hash_node.next = NULL and it is
unexpected.

How about the following patch?

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 2d182c4ee9d9..246ef0f2e985 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -56,6 +56,7 @@ struct htab_elem {
                         union {
                                 struct bpf_htab *htab;
                                 struct pcpu_freelist_node fnode;
+                               struct htab_elem *link;
                         };
                 };
         };
@@ -1256,6 +1257,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map 
*map,
         void __user *ukeys = u64_to_user_ptr(attr->batch.keys);
         void *ubatch = u64_to_user_ptr(attr->batch.in_batch);
         u32 batch, max_count, size, bucket_size;
+       struct htab_elem *node_to_free = NULL;
         u64 elem_map_flags, map_flags;
         struct hlist_nulls_head *head;
         struct hlist_nulls_node *n;
@@ -1370,9 +1372,14 @@ __htab_map_lookup_and_delete_batch(struct bpf_map 
*map,
                 }
                 if (do_delete) {
                         hlist_nulls_del_rcu(&l->hash_node);
-                       if (is_lru_map)
-                               bpf_lru_push_free(&htab->lru, &l->lru_node);
-                       else
+                       if (is_lru_map) {
+                               /* l->hnode overlaps with * 
l->hash_node.pprev
+                                * in memory. l->hash_node.pprev has been
+                                * poisoned and nobody should access it.
+                                */
+                               l->link = node_to_free;
+                               node_to_free = l;
+                       } else
                                 free_htab_elem(htab, l);
                 }
                 dst_key += key_size;
@@ -1380,6 +1387,13 @@ __htab_map_lookup_and_delete_batch(struct bpf_map 
*map,
         }

         raw_spin_unlock_irqrestore(&b->lock, flags);
+
+       while (node_to_free) {
+               l = node_to_free;
+               node_to_free = node_to_free->link;
+               bpf_lru_push_free(&htab->lru, &l->lru_node);
+       }
+
         /* If we are not copying data, we can go to next bucket and avoid
          * unlocking the rcu.
          */


