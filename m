Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80307283DF6
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgJESEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:04:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58732 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726248AbgJESEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 14:04:40 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 095I4Lmp018023;
        Mon, 5 Oct 2020 11:04:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=R7AB2CBbs/E0R9L5fhij3LhdG84JIkG1snMomGCPz50=;
 b=ePgS0cWRRDq+KPog4jAgyFHcF+IvFYFrk78XAlLQCMNbKgpg++VA7R5PaylUqnr91jTk
 mh/VRcN9ZNgXJbsCkBGp03If5VQasdu9Yra/eTWqz4guTwHm+j5K5/Dphw2NT83bGRh5
 Cgjh/xoy7cMdNwUpANhn2zdmUo06hVBjQ2s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33xptn0p9d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 05 Oct 2020 11:04:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 5 Oct 2020 11:03:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lMKYJSmZn/PkXdhDZIcUcGu/TgrrFBAb3mBZrehncOh2v7H8lNrqCUan0XInw4nVt/jaeiS2I+GmZNGXA7AUES9rOuNMWGw8iTsJPgTLceLma7R8Wd5vhsUSzS145WgkigAXIaj3DbM/9tIU/DswOEcvs8teTR5j2iT/RDz9ZG4nMBlhRnDk5Z0zKxQRbc9j082+C9AZ9VLeHzSdEN4Hvyq5hWrD7n2WH9TGQjmUEonAE/INe6fVOp6tqK6vLSE3bKlld2VXZ+fVF/fQZ+uOEbBtEcn/y3b5DrpsnItuHtd0xw+r05W0i5hVdV3aWn/Fhrmm0pd6/n4omYvLjg0gag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7AB2CBbs/E0R9L5fhij3LhdG84JIkG1snMomGCPz50=;
 b=Fo44sYa3zYm5/9T3m/5O+lC9x3W5DYlgNS1ypTguHSGqeXiwx4/s10S5C5WrJMLKXM3VmFbQ48gf9YTDQ+5gBxOr0RF9HRR/ad3L0uAsKUe0RDGf12aIOmOlY+3WSL+6yGOVJlu33Gt1SSDDpiGyYpWb35NpXsBn83KXk7RaBbULJqd1LaoiTXgz9o3Rhy9lRs8qaXDN8BTyOmUQsa0RvEXjlhohIMtMhnKb9Xg/Z2HuJRnoMXwFtuxOP2EB1tOhILRhn6gqcfA+M+8FfuRsFqMKNbyKpRjx7JxD7U5+noPzaDBkz0MAmidFY6H09EuLHDtP2yzbJRPWQY4dQmMt0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7AB2CBbs/E0R9L5fhij3LhdG84JIkG1snMomGCPz50=;
 b=h8SA19+JVyW2vApNukOH8qn74NQt3k8CBDpGSTpt4THPFyvqnd22IioNwmVe7D8RyLvmZyBeKbBDuLV+UuezaHMUMb5+qgGio8359vunpva/IQvla0nqh4kOOyUCXINWrLLj76bVfVxBrZiABKY4uMNXKHRz3CNgowm+Mm2DSIk=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Mon, 5 Oct
 2020 18:03:58 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 18:03:58 +0000
Date:   Mon, 5 Oct 2020 11:03:46 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next] bpf: use raw_spin_trylock() for
 pcpu_freelist_push/pop in NMI
Message-ID: <20201005180346.gs2iznki5jnslqqp@kafai-mbp.dhcp.thefacebook.com>
References: <20201005165838.3735218-1-songliubraving@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005165838.3735218-1-songliubraving@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:1eab]
X-ClientProxiedBy: CO2PR07CA0052.namprd07.prod.outlook.com (2603:10b6:100::20)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:1eab) by CO2PR07CA0052.namprd07.prod.outlook.com (2603:10b6:100::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Mon, 5 Oct 2020 18:03:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90c03140-41ce-48bd-8cbc-08d869590811
X-MS-TrafficTypeDiagnostic: BYAPR15MB3046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30468E985BC2E09309CD7C01D50C0@BYAPR15MB3046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Zy8sKDLdWknkc2lbIB3u9SH19FjHXloq2fejBhv0tM7P7uLnz6XNObEkErUjY8WZlZdIRekgJskc9V7cC8Q3sXS1i2CZbH6vGPMIqIw6Z9MBCQnHyOd+9iEeLGzp3KPGflDZtAoZA8meuIKJfdg5AquYRdFg5uI0nAbYHWqfKkhwwpuA1Ba98pOHoWliiCZWK744A4ijQVjcOGe4yZJuv2E1TospuMScDtDp6HWimFHbc/kPPjux8wS7CxD1bodi8fc1kwgd9g2b11pVo9QmpY1dlJ5bDV4aHoUX+YmIRQfwMCc7xpXatgtYISbb7BXlUopA9xcKkT8d76k1yjzwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(376002)(346002)(55016002)(1076003)(478600001)(186003)(9686003)(16526019)(6506007)(66476007)(6636002)(66946007)(66556008)(86362001)(6666004)(5660300002)(2906002)(8676002)(4326008)(6862004)(7696005)(52116002)(8936002)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 98RtUjkCSiR7sBO1eXeFNj5ALhwFf/6m1/UD3Y19E8sHNBRTay9JYi+T2ikVdim0Qnrsdx9MbBqmoOUGTEHhflKsk97aLcjKBujTCaOn3LvPUekt3IbDoGqTBtplW4ous3XiIKlL4rgTLzBZ51CVs+DueRgTNY978BGr7Dl7+ks791x1OooUN3MrAm/B2/ehynUvd+1vbkF4caSTw5xlDIxXDk16W5D/gdMBhRfNM8JNtbVXK35i4wo9nf1Dr0PtMRnEOXx3Ad5ituxt0euogVD2K0BKDMNBwAWZfbHU2fuPLTkKrwHGFuJfKNMfaUy5oiN72wJade6ATaHX2xA9Yjx6FBVcKQ6GEsfKQXHoaIl16vyWJP4MEmZGeYpgD94MKImof5DQMdk9bD2Bip6SjBIyTGPkeefMbYdjxAeBzrSaq8oTzOB2MJ3o1ajQRP19MdRPE48R0KeZcfiweZj7eZaBvYN4xm8WACSYwgdJ+Jb1T2vtu3RG/jWFrZYOr49uYvAKpkLa7XOYYue5Qqv/6z4hDdkOFdJFXQlppLpndxZ6AXxwI1v5r3SPxefMnfF86Qc+g1OhCV58eDPR3aDagUlMG8IEvS5+m5GeabN16G2fVQ5Moexh5TP1tbxX/I/aS3fqlPdxl7VAJDI1XBRt0JiCmKrDXd602/fu0y2t4r4=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c03140-41ce-48bd-8cbc-08d869590811
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 18:03:58.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjfK73Q48o0ezAnGmFoE30H/DzoWIqAXZEjePLAV0FgFEQLJ4eNWGp7YD65SLmVp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-05_14:2020-10-05,2020-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 suspectscore=1 adultscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010050133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 09:58:38AM -0700, Song Liu wrote:
> Recent improvements in LOCKDEP highlighted a potential A-A deadlock with
> pcpu_freelist in NMI:
> 
> ./tools/testing/selftests/bpf/test_progs -t stacktrace_build_id_nmi
> 
> [   18.984807] ================================
> [   18.984807] WARNING: inconsistent lock state
> [   18.984808] 5.9.0-rc6-01771-g1466de1330e1 #2967 Not tainted
> [   18.984809] --------------------------------
> [   18.984809] inconsistent {INITIAL USE} -> {IN-NMI} usage.
> [   18.984810] test_progs/1990 [HC2[2]:SC0[0]:HE0:SE1] takes:
> [   18.984810] ffffe8ffffc219c0 (&head->lock){....}-{2:2}, at:
> __pcpu_freelist_pop+0xe3/0x180
> [   18.984813] {INITIAL USE} state was registered at:
> [   18.984814]   lock_acquire+0x175/0x7c0
> [   18.984814]   _raw_spin_lock+0x2c/0x40
> [   18.984815]   __pcpu_freelist_pop+0xe3/0x180
> [   18.984815]   pcpu_freelist_pop+0x31/0x40
> [   18.984816]   htab_map_alloc+0xbbf/0xf40
> [   18.984816]   __do_sys_bpf+0x5aa/0x3ed0
> [   18.984817]   do_syscall_64+0x2d/0x40
> [   18.984818]   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   18.984818] irq event stamp: 12
> [ ... ]
> [   18.984822] other info that might help us debug this:
> [   18.984823]  Possible unsafe locking scenario:
> [   18.984823]
> [   18.984824]        CPU0
> [   18.984824]        ----
> [   18.984824]   lock(&head->lock);
> [   18.984826]   <Interrupt>
> [   18.984826]     lock(&head->lock);
> [   18.984827]
> [   18.984828]  *** DEADLOCK ***
> [   18.984828]
> [   18.984829] 2 locks held by test_progs/1990:
> [ ... ]
> [   18.984838]  <NMI>
> [   18.984838]  dump_stack+0x9a/0xd0
> [   18.984839]  lock_acquire+0x5c9/0x7c0
> [   18.984839]  ? lock_release+0x6f0/0x6f0
> [   18.984840]  ? __pcpu_freelist_pop+0xe3/0x180
> [   18.984840]  _raw_spin_lock+0x2c/0x40
> [   18.984841]  ? __pcpu_freelist_pop+0xe3/0x180
> [   18.984841]  __pcpu_freelist_pop+0xe3/0x180
> [   18.984842]  pcpu_freelist_pop+0x17/0x40
> [   18.984842]  ? lock_release+0x6f0/0x6f0
> [   18.984843]  __bpf_get_stackid+0x534/0xaf0
> [   18.984843]  bpf_prog_1fd9e30e1438d3c5_oncpu+0x73/0x350
> [   18.984844]  bpf_overflow_handler+0x12f/0x3f0
> 
> This is because pcpu_freelist_head.lock is accessed in both NMI and
> non-NMI context. Fix this issue by using raw_spin_trylock() in NMI.
> 
> Since NMI interrupts non-NMI context, when NMI context tries to lock the
> raw_spinlock, non-NMI context of the same cpu may already have locked a
> lock and is blocked from unlocking the lock. For a system with N cpus,
> there could be N NMIs at the same time, and they may block N non-NMI
> raw_spinlocks. This is tricky for pcpu_freelist_push(), where unlike
> _pop(), failing _push() means leaking memory. This issue is more likely to
> trigger in non-SMP system.
> 
> Fix this issue with an extra list, pcpu_freelist.extralist. The extralist
> is primarily used to take _push() when raw_spin_trylock() failed on all
> the per cpu lists. It should be empty most of the time. The following
> table summarizes the behavior of pcpu_freelist in NMI and non-NMI:
> 
> non-NMI pop(): 	use _lock(); check per cpu lists first;
>                 if all per cpu lists are empty, check extralist;
>                 if extralist is empty, return NULL.
> 
> non-NMI push(): use _lock(); only push to per cpu lists.
> 
> NMI pop():    use _trylock(); check per cpu lists first;
>               if all per cpu lists are locked or empty, check extralist;
>               if extralist is locked or empty, return NULL.
> 
> NMI push():   use _trylock(); check per cpu lists first;
>               if all per cpu lists are locked; try push to extralist;
>               if extralist is also locked, keep trying on per cpu lists.
> 
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> 
> ---
> Changes v1 => v2:
> 1. Update commit log. (Daniel)
Acked-by: Martin KaFai Lau <kafai@fb.com>
