Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A2B334744
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 19:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbhCJS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 13:56:15 -0500
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:26464
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233493AbhCJSzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 13:55:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MijQQj4TqtVDiunTGpZlFtNrKMqOP3fLN7lmWz7qRLIqBngNTuY+DQkdTWbr0PL4ETy1JSDysRQG3KUsGbmNFiiaHknRnQY1iAFqAvuldZBB8fE+OuFFM346fbKuGU/jhs+vuo3LORysw6gmxYkzQOwHcyDKwb3VNg281o0UowDcYI9XndQqAfGwLw4jX545ELmyJ8afgsLHr9vfZZBj2YfeiBrDn5T5WhBohiutan8iUufBI89RrPo55+XQmip224lfEtrvsZlBpbUmzTNcoUWcPaQ2fiCSPI8md7U3/FUY/69ouHQQSTKvO5+qGlssTl4sa887XlnJLgxya3b5AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeFdXi4FFDfR3+/8Ko1l246JaaBq0P22qH98F5tr62s=;
 b=Q0eO/NDwqs5fyhfngWJTymPk/ig2vWDmRVvJiFyvAwARuEKvlNM37ISERyEk+82OfX89M9pvi46U0kAtdcmklvAC29COzGenR+04rmulgoxIOs7iVPTiz5cnKzBIFs/jMGc/VjMngiy1oJAkvT9Nzve/bg864oaqAPfKytXnyjBk/Pjt4K9oUPHFf2+NSC4a3ehk1GFl/2+lQJWjB5KeW15lbFcL/0aYQPam/pP8COrr1HAxAjN2lmbSOUDY5T/d//pwzy/H01GQj/2GQ9Ast9egP4LUXzeGV/eWcWxmd1haDzUgzOFt/1GIRBvZd2MxPOmi1SbPJ1IBqMZnkkmgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QeFdXi4FFDfR3+/8Ko1l246JaaBq0P22qH98F5tr62s=;
 b=eVxXHZ+09UkWVYEzuHyzlvwJCcGkKJfija/cDFlyigS0fmpWC2Cbvm7YKHdgwYTESWh0yn/0N0e/KFLtfvIQkQwGBdAow2bEz54KNIJ0xpnta1yUGY/CkLcTp2w0cSLRmVz46bSERS98QP9yxmobXEoMXqJvSluJd3kOQabl0wQgNxfMwrp/NFLYd4USgBx9c+a70oZ9lbyMl1KXQtbrASdlG7trpHrQVPBeEq4OiL6JRdPsPL+sP1V8wSlfQmEcV3hQ489WqoOnHwFbrKveOmlOYjSR0Vwq2ZFBY7ix/7YMFkMcPUoAP1EL3dnFqvgBpOD8RCtXqAhp+f7wQAaQKg==
Received: from DM5PR16CA0026.namprd16.prod.outlook.com (2603:10b6:4:15::12) by
 BN6PR1201MB2480.namprd12.prod.outlook.com (2603:10b6:404:b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Wed, 10 Mar
 2021 18:55:45 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::2e) by DM5PR16CA0026.outlook.office365.com
 (2603:10b6:4:15::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 18:55:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 18:55:44 +0000
Received: from [172.27.15.160] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 18:55:39 +0000
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 htb_select_queue
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <maximmi@mellanox.com>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <tariqt@nvidia.com>,
        <xiyou.wangcong@gmail.com>
References: <000000000000c0510605bd1bfd39@google.com>
 <21985b6f-a13b-2208-790a-bfe42e1b1985@gmail.com>
 <cb2163b1-8b63-1934-b786-050e903785b4@nvidia.com>
 <a6201db2-9c88-b80e-eed5-11c49e462b91@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <88b238ac-76be-c8ee-ee26-e9a9ecc2b467@nvidia.com>
Date:   Wed, 10 Mar 2021 20:55:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <a6201db2-9c88-b80e-eed5-11c49e462b91@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d1b7c48-1daf-483f-baf0-08d8e3f61c2f
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2480:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2480A9EB0097E84B44A3A5CCDC919@BN6PR1201MB2480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6FrG+d/eCmFvY43i973xpBGigPp6/kAe9d9NOfkT6PKltf1EhnebMeHiJZP+P+YgVd3bLg/iCJ2T74PgRYebVyUZCzwZWNOtlrlmOm2TYADrIueUlm0TagP4mf1DNJQdP4XShmQl/hbm+lv+x9TOVV1MsvQpKNg9c6pNE4yoaCmHsupz2Tl/8iRfDvtSBtlBA3tacfOLXqMvVh65gRh25MQxA6Kxu85QTXED4QLcnA4qxgcsbu6mCq9L6PqllwXEB4pWRoYyadPnptKP+hKol0t+MqEf1evXOoB9ZbDRgVD2m9Rxdhn9N+GQO6hNFuDG+Q0evrzVdb1mus/Y+hykweHN20S/6SlI/Rd1t1zQ9otpgsow0liN7+pusws4f/iwdCG9AKQDcTdl6ns9DDiXML3qCMRFQ7q348XjOm/eOzQNe72/tvPvykvOpkOqcJdLJDQr9+qRueS5Ry48BX1Hax+cwyPVQK4jC8flMZ13ZFq44bef3TKCmjWBfZTN+ddP8YJf99434JAaBe1X86E9ZoYfuhfGsjIz7XoRnNYMqt+jYE48nU60BlJA2VYwGh8EwW51Ak9KkjVDqt6xrvZzuMmO7+YL9yqHeJm7lwRB2uaYVU3hSwMQCQI8kyAG1Jg02yFGX5PkHZ+QJDoLYpose34A4xWzlIf8sAjS1Lf22iTfeyS+1B6oz6hNusT153bgBex1ZLnlUVMjYIRdsvCurY4TjZ8R1LLWcIB9Y0W91sUFfoXrQ6KGTCF4ucF5EO8hTr5K3s/Xt9thoTN7lGUV+xFZOXAInxMh/y3giH7OwVD5rUMJEoQ2ju3OtxGfWQ6D6+JzI250zmihCaRi4XqNDD9DvZVWADT08Nmu7fErNSna8mam9C8YvwpXODWAXvQ8
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(36840700001)(46966006)(86362001)(36860700001)(8676002)(47076005)(36756003)(82310400003)(70586007)(5660300002)(336012)(30864003)(36906005)(70206006)(316002)(2616005)(16576012)(31696002)(2906002)(110136005)(426003)(8936002)(186003)(34070700002)(7416002)(16526019)(6666004)(26005)(966005)(31686004)(478600001)(921005)(83380400001)(53546011)(7636003)(356005)(45080400002)(82740400003)(99710200001)(2101003)(83996005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 18:55:44.5656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d1b7c48-1daf-483f-baf0-08d8e3f61c2f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-10 19:03, Eric Dumazet wrote:
> 
> 
> On 3/10/21 3:54 PM, Maxim Mikityanskiy wrote:
>> On 2021-03-09 17:20, Eric Dumazet wrote:
>>>
>>>
>>> On 3/9/21 4:13 PM, syzbot wrote:
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    38b5133a octeontx2-pf: Fix otx2_get_fecparam()
>>>> git tree:       net-next
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=166288a8d00000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b53a709f04722ca12a3c
>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119454ccd00000
>>>>
>>>> The issue was bisected to:
>>>>
>>>> commit d03b195b5aa015f6c11988b86a3625f8d5dbac52
>>>> Author: Maxim Mikityanskiy <maximmi@mellanox.com>
>>>> Date:   Tue Jan 19 12:08:13 2021 +0000
>>>>
>>>>       sch_htb: Hierarchical QoS hardware offload
>>>>
>>>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ab12ecd00000
>>>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=106b12ecd00000
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ab12ecd00000
>>>>
>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>> Reported-by: syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com
>>>> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
>>>>
>>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>>>> #PF: supervisor instruction fetch in kernel mode
>>>> #PF: error_code(0x0010) - not-present page
>>>> PGD 183fe067 P4D 183fe067 PUD 21aef067 PMD 0
>>>> Oops: 0010 [#1] PREEMPT SMP KASAN
>>>> CPU: 0 PID: 10125 Comm: syz-executor.0 Not tainted 5.11.0-rc7-syzkaller #0
>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>> RIP: 0010:0x0
>>>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>>>> RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
>>>> RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
>>>> RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
>>>> RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
>>>> R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
>>>> R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
>>>> FS:  00007f73f9698700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506f0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>> Call Trace:
>>>>    htb_offload net/sched/sch_htb.c:1011 [inline]
>>>>    htb_select_queue+0x17f/0x2c0 net/sched/sch_htb.c:1349
>>>>    tc_modify_qdisc+0x44a/0x1a50 net/sched/sch_api.c:1657
>>>>    rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
>>>>    netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>>>>    netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>>>>    netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>>>>    netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>>>>    sock_sendmsg_nosec net/socket.c:652 [inline]
>>>>    sock_sendmsg+0xcf/0x120 net/socket.c:672
>>>>    ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
>>>>    ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
>>>>    __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
>>>>    do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> RIP: 0033:0x466019
>>>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
>>>> RSP: 002b:00007f73f9698188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>>>> RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466019
>>>> RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
>>>> RBP: 00000000004bd067 R08: 0000000000000000 R09: 0000000000000000
>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
>>>> R13: 00007fffefccc11f R14: 00007f73f9698300 R15: 0000000000022000
>>>> Modules linked in:
>>>> CR2: 0000000000000000
>>>> ---[ end trace e1544e8206616773 ]---
>>>> RIP: 0010:0x0
>>>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>>>> RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
>>>> RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
>>>> RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
>>>> RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
>>>> R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
>>>> R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
>>>> FS:  00007f73f9698700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506e0
>>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>>
>>>>
>>>> ---
>>>> This report is generated by a bot. It may contain errors.
>>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>
>>>> syzbot will keep track of this issue. See:
>>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>>>> syzbot can test patches for this issue, for details see:
>>>> https://goo.gl/tpsmEJ#testing-patches
>>>>
>>>
>>>
>>> Hmm... what about this :
>>>
>>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>>> index f87d07736a1404edcfd17a792321758cd4bdd173..680afb5bfe2294a5531c7aaeed698b95ea3ab20c 100644
>>> --- a/net/sched/sch_api.c
>>> +++ b/net/sched/sch_api.c
>>> @@ -1651,15 +1651,16 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>>>                           err = -ENOENT;
>>>                   }
>>>           } else {
>>> -               struct netdev_queue *dev_queue;
>>> +               struct netdev_queue *dev_queue = NULL;
>>>                     if (p && p->ops->cl_ops && p->ops->cl_ops->select_queue)
>>>                           dev_queue = p->ops->cl_ops->select_queue(p, tcm);
>>> -               else if (p)
>>> -                       dev_queue = p->dev_queue;
>>> -               else
>>> -                       dev_queue = netdev_get_tx_queue(dev, 0);
>>> -
>>> +               if (!dev_queue) {
>>> +                       if (p)
>>> +                               dev_queue = p->dev_queue;
>>> +                       else
>>> +                               dev_queue = netdev_get_tx_queue(dev, 0);
>>> +               }
>>>                   q = qdisc_create(dev, dev_queue, p,
>>>                                    tcm->tcm_parent, tcm->tcm_handle,
>>>                                    tca, &err, extack);
>>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>>> index dff3adf5a9156c2412c64a10ad1b2ce9e1367433..cc6eccd688701ae00255f07e32fb4b0efbaf45ce 100644
>>> --- a/net/sched/sch_htb.c
>>> +++ b/net/sched/sch_htb.c
>>> @@ -1008,6 +1008,8 @@ static void htb_set_lockdep_class_child(struct Qdisc *q)
>>>      static int htb_offload(struct net_device *dev, struct tc_htb_qopt_offload *opt)
>>>    {
>>> +       if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
>>> +               return -EOPNOTSUPP;
>>
>> My fault, all calls to htb_offload must be protected by if (q->offload). Rather than checking tc_can_offload and ndo_setup_tc in htb_offload every time, I suggest to fix htb_select_queue:
>>
>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>> index dff3adf5a915..b23203159996 100644
>> --- a/net/sched/sch_htb.c
>> +++ b/net/sched/sch_htb.c
>> @@ -1340,8 +1340,12 @@ htb_select_queue(struct Qdisc *sch, struct tcmsg *tcm)
>>   {
>>       struct net_device *dev = qdisc_dev(sch);
>>       struct tc_htb_qopt_offload offload_opt;
>> +    struct htb_sched *q = qdisc_priv(sch);
>>       int err;
>>
>> +    if (!q->offload)
>> +        return sch->dev_queue;
>> +
>>       offload_opt = (struct tc_htb_qopt_offload) {
>>           .command = TC_HTB_LEAF_QUERY_QUEUE,
>>           .classid = TC_H_MIN(tcm->tcm_parent),
>>
>> htb_init ensures that tc_can_offload and ndo_setup_tc are checked if q->offload is true. Also, we can avoid changing tc_modify_qdisc if htb_select_queue mimics its behavior in non-offload mode, as shown above.
>>
>> There is also a case where htb_select_queue returns NULL on errors, and that is handled in qdisc_create (the error message will be "No device queue given"), which I think is a sane behavior.
>>
>> What do you think of this fix? If it fits, I'll send it as a patch.
> 
> 
> I think that it is not enough, since you overwrite q->offload in htb_init()
> even if an error will be provided.
> 
> So a malicious user will find its way.

I doubt that, because if htb_init returns an error, the qdisc gets 
destroyed immediately (well, after a call to htb_destroy), and I believe 
all these operations are protected by RTNL, so a malicious user has no 
way to insert a call to another callback.

> You probably also need this :

However, I'll likely need something like this anyway, because HTB must 
not call ndo_setup_tc on destroy if it didn't call it on init. It may 
crash in a similar way if ndo_setup_tc is not implemented. Thanks for 
helping me spot that - if you don't mind, I'll base my second patch on 
your code below.

> 
> 
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index dff3adf5a9156c2412c64a10ad1b2ce9e1367433..d15ee7cf33b34221d09dfc81105dcb6c2b2fd489 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -1020,6 +1020,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
>          struct nlattr *tb[TCA_HTB_MAX + 1];
>          struct tc_htb_glob *gopt;
>          unsigned int ntx;
> +       bool offload;
>          int err;
>   
>          qdisc_watchdog_init(&q->watchdog, sch);
> @@ -1044,9 +1045,9 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
>          if (gopt->version != HTB_VER >> 16)
>                  return -EINVAL;
>   
> -       q->offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
> +       offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
>   
> -       if (q->offload) {
> +       if (offload) {
>                  if (sch->parent != TC_H_ROOT)
>                          return -EOPNOTSUPP;
>   
> @@ -1060,6 +1061,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
>                  if (!q->direct_qdiscs)
>                          return -ENOMEM;
>          }
> +       q->offload = offload;
>   
>          err = qdisc_class_hash_init(&q->clhash);
>          if (err < 0)
> 

