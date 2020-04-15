Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9AE1AAEC4
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410467AbgDOQwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:52:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55736 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390653AbgDOQwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 12:52:02 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FGmvaA018609;
        Wed, 15 Apr 2020 09:51:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : references
 : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ekO22eQ+3BFa4d8J8wBAv1MSbEH0JL0bY3qZAlygo5k=;
 b=UcmKA0Vg2A2/+yPgXUPsqmQqSQMv6wXtXe6cxvS82AhC8S9f3eSoCRynOSqClEMwyXWK
 +0pTGw4VAOmqtPdsbGSsfK2D5l3uQbJX2mHckNZAolyEndJd+ZA0GpyVJgRymIYnwDfV
 G3Mha5kCQHOmqnB1VmYyV9b5xWaJxu3f9So= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7qetc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Apr 2020 09:51:45 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 09:51:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NS0eRMXqNS9TcPbmVugRnXxsTjv7byJ4kA05mk4as3aQm5pl3FENBsciHPsH73UeZsy1jiaxM28ZHoa425EaD5Q1BFWEizgE+zZY8rBWBtFSxAg1/HaaXk70kxBTBEkjfOzU5dKJ7Z+/3JzRtbH/eM8AYsvNyRyZUCd5iZ+Tgj/0+VNteXocsBV3GAl8TKUdK/uZrgEZjCEWUyJ+RX6dDaArbzfRvT7fEUwtPfu6Y5itGkpTvkWMLKDwsfJ0SuEPZHzp2dVEl6W4lECHdCkjbuX8adRGUTMBKsSDU15SdCQmJMrrVACupZToPCMUZsM0Wz5Z+h/Lo+Z5CVaaj4XtMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekO22eQ+3BFa4d8J8wBAv1MSbEH0JL0bY3qZAlygo5k=;
 b=Wwtxhtv/veC5CJ2A48IVfIDtsDy7TGdCJmof7BquSfC/+YfRuhOHEsEkRu4qgklr2Q+kpcELjG/fnGcNmOPNVEwVPPwSZO7fGl3WHPhNquWpcWGMVjZmqJrlFe1aSzAEue7FK8t89jvMvlrMP9rBpCtR95HENE+jU4wG7hHZWVXcmQeg4ikJJDyjQiyWXRWpg3+RywV8fbKiPqFk2wOSN8xqR6sFe9hpCG+hrUoHzTqukSCj+HxqwpG9uIeEij/OGPSSuRAVXmFZkSIQpP3jMFvhW//UnmLAeeoEGFTh1/u1Bv4wudaXMvVioagasyQmOvgm+Fj1wYmEpLqXX3bjEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekO22eQ+3BFa4d8J8wBAv1MSbEH0JL0bY3qZAlygo5k=;
 b=AsfQA+a+KQf5bd3/lp3TxKDDvv4e+AbgCKiHxPIbzTmn61qauAcIIZWWfMjymboXE5JeYWqGxNQdTs1BI7r7gaR/DDx4gmYSvyukwGEJxM6dojbLJr8TOMXxjkJSjOVnmZ6T3+UYyVFcBX1T7obQAAl67aEUB5VIpgeXKTa67MQ=
Received: from MW3PR15MB3753.namprd15.prod.outlook.com (2603:10b6:303:50::17)
 by MW3PR15MB3755.namprd15.prod.outlook.com (2603:10b6:303:4c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Wed, 15 Apr
 2020 16:51:43 +0000
Received: from MW3PR15MB3753.namprd15.prod.outlook.com
 ([fe80::599e:12d9:5804:c0e7]) by MW3PR15MB3753.namprd15.prod.outlook.com
 ([fe80::599e:12d9:5804:c0e7%9]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 16:51:43 +0000
Subject: Re: WARNING in bpf_cgroup_link_release
To:     Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com>,
        <ast@kernel.org>, <bpf@vger.kernel.org>,
        <john.fastabend@gmail.com>, <kafai@fb.com>, <kpsingh@chromium.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <syzkaller-bugs@googlegroups.com>,
        <yhs@fb.com>
References: <000000000000500e6f05a34ecc01@google.com>
 <4ba5ee0c-ec81-8ce3-6681-465e34b98a93@iogearbox.net>
From:   Andrii Nakryiko <andriin@fb.com>
Message-ID: <a9219326-c07c-1069-270c-4bef17ee7b88@fb.com>
Date:   Wed, 15 Apr 2020 09:51:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <4ba5ee0c-ec81-8ce3-6681-465e34b98a93@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR14CA0057.namprd14.prod.outlook.com
 (2603:10b6:300:81::19) To MW3PR15MB3753.namprd15.prod.outlook.com
 (2603:10b6:303:50::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:51:fde8:f2bb:1332] (2620:10d:c090:400::5:5913) by MWHPR14CA0057.namprd14.prod.outlook.com (2603:10b6:300:81::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.23 via Frontend Transport; Wed, 15 Apr 2020 16:51:42 +0000
X-Originating-IP: [2620:10d:c090:400::5:5913]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb256aa7-df6c-4050-be6b-08d7e15d46e5
X-MS-TrafficTypeDiagnostic: MW3PR15MB3755:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB37551A3F438E2F8B01C650DBC6DB0@MW3PR15MB3755.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3753.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(346002)(39860400002)(396003)(366004)(136003)(2906002)(83080400001)(966005)(36756003)(186003)(2616005)(16526019)(110136005)(316002)(66556008)(31686004)(52116002)(81156014)(5660300002)(8676002)(8936002)(66476007)(66946007)(7116003)(478600001)(6636002)(53546011)(31696002)(86362001)(6486002)(921003)(99710200001)(1121003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYfdK1wum4SuKwK5ZLEQeNaGF8TjA8dfs7CmOhgN74W5YLaFjw3p6mj0L4MC9Nm+nmoI9ieNcCrM2//3xstIeJEItJ5b1bc6qJ9HfiGvI+9il1GJqaJmO80UMDI7dHou9kOJbA4PT+8P4MJDXOfR4TpoS3gH/t2IoeTCs/TyjNDJnt4IW9Z/rX4QUqe34CrSr2iBLmfv4RynWjZmbh0KyckLieQllUaYmjCdz9NeZu0jID4TXCNFd1IXLkxtZ8jlISFotWvarHtODt6rXvsfN9MpeMfmxvi/c8SxL+LCQagLT+ZEbslqzOOdOUn1H3psRKzr9nsmKY/aZ7TaRvSK0oH3t73lNXuJ5tfnfztI18SZGD0YNbN2Gfk6PUw9ubXW07G98A8BzIHFtzf+c2zVnAAk+NM4k5ej+RKxpIIUHihvc19/CqOYrg701IqzqbU+dwAxcYN+UQL+s/EL+6PnQcSdg+AJvAoWZkddTMb4KHAE+2ypH9QCUO5Jp8DDlOpOD9IFqlo0NzlC1HsDSBWNYK7jkEVcSSntARnNG0BvCZuHsdTuWMmvDutv/mqBy7HKhyFAuU5qqE7hUm8nBnBACizLTfNeCWOvO+EKIF9qs4I=
X-MS-Exchange-AntiSpam-MessageData: zfGFesyJm4rdxl02syNsTCvT/REcPDYSmwn7HfEtnDZ9ZI82kFFUlKkRamUGjzlQ3ocf7ayapCHxcIaXi9sDNA7HtqWUQpDq5IKO4DGjaNr4d9iCqn+fkxg5jLyJtC1RoY8MI5i7+V6/lj81SVCy5dMcquJVKZ7n15G45gIbZiQfZ/2qxln0plwtopfGCnCX
X-MS-Exchange-CrossTenant-Network-Message-Id: eb256aa7-df6c-4050-be6b-08d7e15d46e5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:51:43.5487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Y/1Vq8aGYtEhFc3Vq4VwFXIhdxTTi04zUO8bRrZ0VoYn33TI26I+vVsMB1TIabU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3755
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_06:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 adultscore=0 malwarescore=0 phishscore=0
 mlxlogscore=860 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/20 4:57 AM, Daniel Borkmann wrote:
> On 4/15/20 8:55 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
> 
> Andrii, ptal.
> 
>> HEAD commit:    1a323ea5 x86: get rid of 'errret' argument to 
>> __get_user_x..
>> git tree:       bpf-next
>> console output: 
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D148ccb57e00000&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=-6XBbsNV1O4X5flrx4Yssfjc56d0qeSHgwHhd92UPJc&e= 
>> kernel config:  
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D8c1e98458335a7d1&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=s5-1AlWtSiBvo66WN4_UXoXMGIGIqsoUCrmAnxNnfX0&e= 
>> dashboard link: 
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D8a5dadc5c0b1d7055945&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=hAA0702qJH5EwRwvG0RKmj8FwIRm1O8hvmoS7ne5Dls&e= 
>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>
>> Unfortunately, I don't have any reproducer for this crash yet.
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the 
>> commit:
>> Reported-by: syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 25081 at kernel/bpf/cgroup.c:796 
>> bpf_cgroup_link_release+0x260/0x3a0 kernel/bpf/cgroup.c:796

This warning is triggered due to __cgroup_bpf_detach returning an error. 
It can do it only in two cases: either attached item is not found, which 
from starting at code some moreI don't see how that can happen. The 
other reason - kmalloc() failing to allocate memory for new effective 
prog array. The latter is a bit annoying behavior of cgroup detach, and 
I wonder if it makes sense to actually make that operation non-failing 
by replacing detached program with dummy noop program. Or at least do it 
if allocating new effective prog array fails. This wasn't previously 
triggered, because when user explicitly detaches and that fails, we'd be 
just returning this to user-space, but for links we have WARN_ON, 
because we have no way to propagate error back, because there is little 
user can do about that.

So, should we change detach to be non-failing (assuming program to be 
detached is found?)

>> Kernel panic - not syncing: panic_on_warn set ...
>> CPU: 0 PID: 25081 Comm: syz-executor.1 Not tainted 5.6.0-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, 
>> BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x188/0x20d lib/dump_stack.c:118
>>   panic+0x2e3/0x75c kernel/panic.c:221
>>   __warn.cold+0x2f/0x35 kernel/panic.c:582
>>   report_bug+0x27b/0x2f0 lib/bug.c:195
>>   fixup_bug arch/x86/kernel/traps.c:175 [inline]
>>   fixup_bug arch/x86/kernel/traps.c:170 [inline]
>>   do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
>>   do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
>>   invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
>> RIP: 0010:bpf_cgroup_link_release+0x260/0x3a0 kernel/bpf/cgroup.c:796
>> Code: cf ff 5b 5d 41 5c e9 df 2a e9 ff e8 da 2a e9 ff 48 c7 c7 20 f4 
>> 9d 89 e8 de a0 3a 06 5b 5d 41 5c e9 c5 2a e9 ff e8 c0 2a e9 ff <0f> 0b 
>> e9 57 fe ff ff e8 a4 3d 26 00 e9 2a fe ff ff e8 9a 3d 26 00
>> RSP: 0018:ffffc900019a7dc0 EFLAGS: 00010246
>> RAX: 0000000000040000 RBX: ffff88808c3eac00 RCX: ffffc9000415a000
>> RDX: 0000000000040000 RSI: ffffffff8189bea0 RDI: 0000000000000005
>> RBP: 00000000fffffff4 R08: ffff88809055e000 R09: ffffed1015cc70f4
>> R10: ffffed1015cc70f3 R11: ffff8880ae63879b R12: ffff88808c3eac60
>> R13: ffff88808c3eac10 R14: ffffc90000f32000 R15: ffffffff817f8e60
>>   bpf_link_free+0x80/0x140 kernel/bpf/syscall.c:2217
>>   bpf_link_put+0x15e/0x1b0 kernel/bpf/syscall.c:2243
>>   bpf_link_release+0x33/0x40 kernel/bpf/syscall.c:2251
>>   __fput+0x2e9/0x860 fs/file_table.c:280
>>   task_work_run+0xf4/0x1b0 kernel/task_work.c:123
>>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>>   exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
>>   prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
>>   syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
>>   do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
>>   entry_SYSCALL_64_after_hwframe+0x49/0xb3
>> RIP: 0033:0x45c889
>> Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 
>> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 
>> 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007fddaf43fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
>> RAX: 0000000000000000 RBX: 00007fddaf4406d4 RCX: 000000000045c889
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
>> RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000006
>> R13: 0000000000000078 R14: 00000000005043d2 R15: 0000000000000000
>> Kernel Offset: disabled
>> Rebooting in 86400 seconds..
>>
>>
>> ---
>> This bug is generated by a bot. It may contain errors.
>> See 
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=jBcp1pSQqrDLletxcTuqMoEa0bDhfqxI8vS5QM-yBGY&e=  
>> for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this bug report. See:
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23status&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=T2Ez0XmyIpHmEa_MPTTUOh61jMDXqwETtTaTbSe-2M4&s=jgiRP_4-vqlJiCpbXgMh0QfDg8iYJzW-i7MZS8KdapM&e=  
>> for how to communicate with syzbot.
>>
> 

