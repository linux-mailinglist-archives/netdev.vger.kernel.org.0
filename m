Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8574C27ED30
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgI3PgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:36:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10516 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3PgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:36:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UFZu9j011450;
        Wed, 30 Sep 2020 08:36:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vGGLXT79P55At4T+z6gzKnHK189JjqddB3iNBOAuB9A=;
 b=FYkuijEpS+5Hk0nQrmJ5lKmIrMBs/XM7aUPkfDMuy5gqXz+a72cespCqD0l47AHkbyk7
 KC80bWR+/HZ51LfX+QQwyNuJt2/wsbB8jYDyO5OSOm3K/sWr1WXeawSBzyNgTEpeoJrI
 0RMypflgikUQeKk82XAh78T5BOWT5q6hYBY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33tn4tschs-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 08:36:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 08:36:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpDwK0qPS1nFOHz9k9UcWSbtlfY5X4lHqkg7lanTC1fmmn/gnoigicnCn+hOfarHbo4CS1iDVn0gWyGUwlTbLchyl/2UwPfCA/5K08mM8z1f8zp9f45krYuJnEpmifubIV9Dz8E2thFtLoygksivPgFViMGBYUmef4Y70BESwrUNjadt9HFm/uyNUKY725P5833k1M/PFd8dn8bUjKhrNsFRi94n0WBHf2znnKrCni6/1r7tifjZSdxPcbbZwXzgJenCbVbdLAN9nlhZ+Z07pjhm9lOW8acQ6NnOjRdFWNYBonafaxvtlB6uue6jpBbvkBDcxI+sPpPjVYBgK/kMsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGGLXT79P55At4T+z6gzKnHK189JjqddB3iNBOAuB9A=;
 b=fmcv/pr6f5dl18HI88sH637rpZeP59e88ocGJc2yyIhwy633mk4tXZWykHkd81YrFkhDr03zbB/VpR+A4XR7B/TO35XT6i8bM2ZPRb0ShHjCYuYe/JA4T9k7eS7PrXh/W79Y5yYwrlfja6WvGz9fADLH23JqITje+Xt7NVH9tSW7Q8tK0glhhGcAtVlzen7F68lZil+FZ5qNgcR0mdN6TO0GkvcmKt70HPPNKRPwWjQ5A8h3XjDZGr9tGgpShM7Zfm4LNdwbwQuEIWFk5bgBff+wLcuZtBGhfGYR3EbwClg3ifKn33TkqwPz3LdYWhHxUqrm08681Vu/2VwHaJdAug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGGLXT79P55At4T+z6gzKnHK189JjqddB3iNBOAuB9A=;
 b=G1oUD8sP+X750+kC/WMeeFACYz1Wd9jTnPlFiwASKZJg24ZcgyunAYL3fM8taQbRQUyyU/5znaPOIdX4EYOq2fRqo1UUaiCFJxSBiyI7OYjjG0Zy72qn1H8hd74vRlnVbuWQIyDs9vGAO4W8rslLjPguhNE9uBh72dmdH/zLC+Q=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB4042.namprd15.prod.outlook.com (2603:10b6:303:49::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Wed, 30 Sep
 2020 15:35:58 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::fc4a:7d44:dff:e7bf]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::fc4a:7d44:dff:e7bf%6]) with mapi id 15.20.3433.035; Wed, 30 Sep 2020
 15:35:58 +0000
Subject: Re: [PATCH v2 bpf-next] bpf: fix raw_tp test run in preempt kernel
To:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200930002011.521337-1-songliubraving@fb.com>
 <CAADnVQ+jaUfJkD0POaRyrmrLueVP9x-rN8bcN5eEz4XPBk96bw@mail.gmail.com>
 <5684F41E-8748-4CBE-B37F-0E4AADC0A799@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <09b5c318-afb3-2c3a-1b2f-936eb1b9b32b@fb.com>
Date:   Wed, 30 Sep 2020 08:35:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <5684F41E-8748-4CBE-B37F-0E4AADC0A799@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:f22d]
X-ClientProxiedBy: MWHPR2001CA0011.namprd20.prod.outlook.com
 (2603:10b6:301:15::21) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:f22d) by MWHPR2001CA0011.namprd20.prod.outlook.com (2603:10b6:301:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25 via Frontend Transport; Wed, 30 Sep 2020 15:35:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9be34c6-1fc8-4602-3626-08d8655686eb
X-MS-TrafficTypeDiagnostic: MW3PR15MB4042:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB40426B082134C604E07527D2D7330@MW3PR15MB4042.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4NACkPLcESrB5fTBZG3sy2u8jr6G2GvHtgv693zwQqIjXYxrXg56cAaH1glEO8tKnkRbHa2yX8hRg0TlsIg+U38hLXH6z+un8M+CUeCVBHIwWXfFzoJ18sQAKgajI129T9kHZywQ1JzzcUbtbjyzrW5D2f8nPQNxG5cykKPtIMVr3Pi9WimR7xdRUvOe1RdTNTkSUMDOPhy7VXeSScekkpzhjChcUbvNwVmvKeB4YVLijNkYN35VWRx9zrQC+uIhvb3UZDoOIwOnc4bz9yB064Pw4qTpdWUIBkwfSGiNcEHaeHdwTvX3y8cqViitTRpbe9LMRIAH+pUfHoD+ND5VjR6uujK9AFyWc0kJgj5yY6a14TOgEki1W7j2Swy4xtVu6WZlfTpCNcEEdtTDs/qIzpTqnlVahq/GZhCdpLGBc8ehpzGbxMKzYrHlPi3yMs03A+kYOpo6+8K8MFiiXHrTe+Y4pGM0dT+s8ipqMGi6zVZn0hBg/l/AjKq2B4A3+b4v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(136003)(366004)(16526019)(8676002)(2906002)(4326008)(966005)(31696002)(66476007)(66556008)(31686004)(83380400001)(86362001)(36756003)(8936002)(54906003)(316002)(6666004)(110136005)(2616005)(186003)(6486002)(5660300002)(66946007)(52116002)(478600001)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: GPPTSnNREiWdLHaKEjt/Om2l6i5/Zx/YWvxAOf1pubJc579oTI4T6MkSmt1XV7mbc7WRzF10X8OrmN8h5jdwxqNvY6kIDdN9SS6jE06TstRa2vjsqwe+pgVGWoCbf45FI9UZdKF8iXvF6OB1Cx8OUqsoAMuCgkczz8ZQXBHXSwlQd89J/q6DXDbIKbUkGcD5CqCg/CfJRcQCchGc/pYBWcknOB9jmYz+YNB5gG9EbG4d9wBWwznuHwCoX4ZFsE7fdAyqdtYQkQjcJrUs7zhalzNapqhHoZVSQ19nhQlmeGDeR2I5QnYPZ550/SeRUg3Fhcl+R217RruTPAuJxJNjO55GJraMvmE90G/RLGJyqxJfSGs/YZa5l442dgTL7CgpGdgnu8bkTc2NRHSLHQFruzRe+DotMaHtujLQLuLTLaO9nHbRYpnjlws+wV/MIrX3Q1+fy7O5VIyXbS678Bw6FXQPQuZxP/ywDVcGVqGWSquxmR420ijBYI3b+zAUqPPybLZul27PR0TIdz3tMGOQDaNIw1oQsR2IVyRvT4Gq+AFbSvTMkPIYRj5rwtpGH8gvrEqvctneBOt8Xra2Ghz9PKBdDo4IHy/AIzUmwrSOyA6vv8Cd1DSVdMrnjOoNjr/RsB00ppid58z0i5gmMio35CvzKtGYTAsiYsBL1Wok8wc=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9be34c6-1fc8-4602-3626-08d8655686eb
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 15:35:58.0529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gt3aIusp77vi2EzMtJx6P13wgqpPZEO9qong3tpat+pioH6j1578NS7teLTGJzRd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4042
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_08:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011
 malwarescore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300124
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 11:45 PM, Song Liu wrote:
> 
> 
>> On Sep 29, 2020, at 8:23 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>
>> On Tue, Sep 29, 2020 at 5:20 PM Song Liu <songliubraving@fb.com> wrote:
>>>
>>> In preempt kernel, BPF_PROG_TEST_RUN on raw_tp triggers:
>>>
>>> [   35.874974] BUG: using smp_processor_id() in preemptible [00000000]
>>> code: new_name/87
>>> [   35.893983] caller is bpf_prog_test_run_raw_tp+0xd4/0x1b0
>>> [   35.900124] CPU: 1 PID: 87 Comm: new_name Not tainted 5.9.0-rc6-g615bd02bf #1
>>> [   35.907358] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>>> BIOS 1.10.2-1ubuntu1 04/01/2014
>>> [   35.916941] Call Trace:
>>> [   35.919660]  dump_stack+0x77/0x9b
>>> [   35.923273]  check_preemption_disabled+0xb4/0xc0
>>> [   35.928376]  bpf_prog_test_run_raw_tp+0xd4/0x1b0
>>> [   35.933872]  ? selinux_bpf+0xd/0x70
>>> [   35.937532]  __do_sys_bpf+0x6bb/0x21e0
>>> [   35.941570]  ? find_held_lock+0x2d/0x90
>>> [   35.945687]  ? vfs_write+0x150/0x220
>>> [   35.949586]  do_syscall_64+0x2d/0x40
>>> [   35.953443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> Fix this by calling migrate_disable() before smp_processor_id().
>>>
>>> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
>>> Reported-by: Alexei Starovoitov <ast@kernel.org>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>>
>>> ---
>>> Changes v1 => v2:
>>> 1. Keep rcu_read_lock/unlock() in original places. (Alexei)
>>> 2. Use get_cpu() instead of smp_processor_id(). (Alexei)
>>
>> Applying: bpf: fix raw_tp test run in preempt kernel
>> Using index info to reconstruct a base tree...
>> error: patch failed: net/bpf/test_run.c:293
>> error: net/bpf/test_run.c: patch does not apply
>> error: Did you hand edit your patch?
> 
> This is so weird. I cannot apply it myself. :(
> 
> [localhost] g co -b bpf-next-temp
> Switched to a new branch 'bpf-next-temp'
> 
> [localhost] g format-patch -b HEAD~1 --subject-prefix "PATCH v3 bpf-next"
> 0001-bpf-fix-raw_tp-test-run-in-preempt-kernel.patch

could you try without -b ?

> [localhost] g reset --hard HEAD~1
> HEAD is now at b0efc216f5779 libbpf: Compile in PIC mode only for shared library case
> 
> [localhost] g am 0001-bpf-fix-raw_tp-test-run-in-preempt-kernel.patch
> Applying: bpf: fix raw_tp test run in preempt kernel
> error: patch failed: net/bpf/test_run.c:293
> error: net/bpf/test_run.c: patch does not apply
> Patch failed at 0001 bpf: fix raw_tp test run in preempt kernel
> hint: Use 'git am --show-current-patch' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".

very odd indeed.

> Any hint on how to fix this? Alternatively, could you please pull the
> change from
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/song/linux.git  raw_tp_preempt_fix

pulled. thanks
