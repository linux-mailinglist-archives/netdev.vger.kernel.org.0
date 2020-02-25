Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 207A816BB42
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbgBYHvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:51:53 -0500
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:22172
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729622AbgBYHvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 02:51:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTm91sMaC/bYGd9oqgqhzIQPLpNSqktXFUrrJabz2zuPZX4Hil8LACyGqq5Ded7rpTAqdLcxeUAUdJFa71g4thzdEsXnlpFK5N7T3t6gqaNi9EVrTcrUJTNGZU6+WUX7ErXD47/LqylkCKJqB6QONbow0+ibzDWOurkCA/X8dbjW3BkP8nSIbtB23jt8KkxQ5bDEZEj107EMdea1UeHYbBopO97zBVR56g58PlPThDTT/y2lIroZktX1Lfa8kG3Cf48qsePuEGSNb/l7khPQlbRKpWvpIm4cZX4nL1fNgjwr8s/Q8jhwiAAThmRNMOmYUy7lLiBU8w0ROmvApzZIkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3I/7T9rluMdfu/0nWQpe8F9CBoxcU4Bj4ksM+CCKumI=;
 b=D4Hz6fJD2EzSagAlSm04XT56e6mbIaUIQGKy3DpioL/8z72VfWlRhWY4iEL2AFJNMiUvnmsYClXxmjDFV/Gb7h1OPZkuGgwhznyNHWJQLXKF1jnxGhOgbUenDdEDtttZbPZG6Qkb+Yd1HP5z7U8xkY+BHtF2hAAama5mqyGF8g+6sFhlgkWdWVZ0eG4AIG3pzm1Y7nNDtzfTEGyVu4t5tMkbnv0LSA99zrAWecWSzZcK/0bPQgRdJGI+myclHMRVJ+vavucTWPIixhKPMDyj+b4pN6p76ejsY3mQu2ONg9t/14XNDgYbMkfpOb1Lv0KbSn0BPJ7MrUZtuWFYEWQNpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3I/7T9rluMdfu/0nWQpe8F9CBoxcU4Bj4ksM+CCKumI=;
 b=o9pOowxrqz64ykhmYmqWfGi+a5OYgAGhSv0ph+Cbsdmj3WwYGL7UhwOXg9kjQT64w546dT62aflkeg7TgEDC/BF8JvLSC9DuNkff9PAK8B8reEAvzpaXXBLXkxsDBtVFZI50UHD48hJ7TDikTL4B3dFIzp/nttfQtw/xUlbVKKc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=markz@mellanox.com; 
Received: from AM6PR05MB4472.eurprd05.prod.outlook.com (52.135.162.157) by
 AM6PR05MB5031.eurprd05.prod.outlook.com (20.177.35.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Tue, 25 Feb 2020 07:51:50 +0000
Received: from AM6PR05MB4472.eurprd05.prod.outlook.com
 ([fe80::11fc:7536:f265:7920]) by AM6PR05MB4472.eurprd05.prod.outlook.com
 ([fe80::11fc:7536:f265:7920%3]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 07:51:50 +0000
Subject: Re: general protection fault in nldev_stat_set_doit
To:     syzbot <syzbot+bd4af81bc51ee0283445@syzkaller.appspotmail.com>,
        dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com
References: <0000000000004aa34d059f5caedc@google.com>
From:   Mark Zhang <markz@mellanox.com>
Message-ID: <bff2faa7-cd95-99c2-f732-765f7b548dbd@mellanox.com>
Date:   Tue, 25 Feb 2020 15:51:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <0000000000004aa34d059f5caedc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::30)
 To AM6PR05MB4472.eurprd05.prod.outlook.com (2603:10a6:209:43::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.144] (115.198.50.108) by SGAP274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 07:51:47 +0000
X-Originating-IP: [115.198.50.108]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c9d4b41-6923-4f4c-8d2d-08d7b9c7923e
X-MS-TrafficTypeDiagnostic: AM6PR05MB5031:|AM6PR05MB5031:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5031EF25259FE2398AA3FB91CAED0@AM6PR05MB5031.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10001)(10009020)(4636009)(366004)(199004)(189003)(6666004)(498600001)(36756003)(81166006)(45080400002)(81156014)(8676002)(52116002)(16576012)(31686004)(966005)(8936002)(5660300002)(86362001)(31696002)(53546011)(956004)(186003)(16526019)(66946007)(26005)(2616005)(6486002)(66476007)(66556008)(2906002)(99710200001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5031;H:AM6PR05MB4472.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/okN71ZAnXRjfxwZk0EH9AjHcdTFU5qq1apUHkN/nzMDCygBTtM+yrar8adiGrnA0WXAWcH6Vc3RgZeLWZ249RVPGHqsbTlBcr9sWq1ty2UbnQHb6y5pxmmcWg/mf7y8xIj1ioqRqCNsErHADylPyxaDlDPJVkPZjMeLmatxn5ZTo1g6NSTvw8x9YhyHxuLD/kFT8m2O9OixkznR3rNCt7HAj162/F4+DWzxX9en35j8mZ1sB3VjaIOKLMXaAV03xhsqyhuvJyJI0frjfr2WgS++Se3+pS8EEKlzYtZPktJWNebzE7ovmfp4eWPByCvwZUAnHh4wTZDGNYS86ureQ9Ac/KGz9n1D4+KhX1ssfkHmXL9vh3scdNz3Kpjn0/vV76AFAaJGnhSt/LiaYwhO5rWABTtdeaDz+prNW3CjHiX7LewHGsdoHt8BsKgI9ZcdgZDtS0cyE1BM/gp2l/ZXyrI+hTL/3HyxO8N/1VmvH3gTGhhY/GDPHs5PkY3rNj9aJrWo5dPDDj5inGYGTc0Mlpfhi8H5hTfbtgAeHXjG/QfIlZJHLdZ9RnmVf8PjTHEKxz7w62uqz2OHTvO1mS1On7iXWjpa+S96Wjh8BKjpv1g54du/rhB6UsyPzyHvFsMyuCRDkzQZFNY54Yrkmtg5g==
X-MS-Exchange-AntiSpam-MessageData: ZwuUzHbUOhq74rFVX3E94JubSICvkWoaBHn25eJ8BbQ8NjiwXH56YiGkjcv5ZmUnt12k0tbrH8zQuC8uq29GtL5cMhnj6hxrgr7QyC+Rd9H8FPY/HYWgyp0mdrJBs4S/wxN4ujYb6j+UbnLhihGjNQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9d4b41-6923-4f4c-8d2d-08d7b9c7923e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 07:51:50.1146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDrC5r4/XyA/oemxNcD6E9GDuRTGOSI5Xkpa2bCbe9N3tq+kjyORboYUz/XuTWJb+cSzdaES2Hf4t9HB0bvWpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5031
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/2020 9:48 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    39f3b41a net: genetlink: return the error code when attrib..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=161be265e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
> dashboard link: https://syzkaller.appspot.com/bug?extid=bd4af81bc51ee0283445
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167103ede00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1710c265e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+bd4af81bc51ee0283445@syzkaller.appspotmail.com
> 
> iwpm_register_pid: Unable to send a nlmsg (client = 2)
> infiniband syz1: RDMA CMA: cma_listen_on_dev, error -98
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 9754 Comm: syz-executor069 Not tainted 5.6.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:nla_get_u32 include/net/netlink.h:1474 [inline]
> RIP: 0010:nldev_stat_set_doit+0x63c/0xb70 drivers/infiniband/core/nldev.c:1760
> Code: fc 01 0f 84 58 03 00 00 e8 41 83 bf fb 4c 8b a3 58 fd ff ff 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 6d
> RSP: 0018:ffffc900068bf350 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: ffffc900068bf728 RCX: ffffffff85b60470
> RDX: 0000000000000000 RSI: ffffffff85b6047f RDI: 0000000000000004
> RBP: ffffc900068bf750 R08: ffff88808c3ee140 R09: ffff8880a25e6010
> R10: ffffed10144bcddc R11: ffff8880a25e6ee3 R12: 0000000000000000
> R13: ffff88809acb0000 R14: ffff888092a42c80 R15: 000000009ef2e29a
> FS:  0000000001ff0880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4733e34000 CR3: 00000000a9b27000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
>   rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>   rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
>   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>   netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
>   netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
>   sock_sendmsg_nosec net/socket.c:652 [inline]
>   sock_sendmsg+0xd7/0x130 net/socket.c:672
>   ____sys_sendmsg+0x753/0x880 net/socket.c:2343
>   ___sys_sendmsg+0x100/0x170 net/socket.c:2397
>   __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
>   __do_sys_sendmsg net/socket.c:2439 [inline]
>   __se_sys_sendmsg net/socket.c:2437 [inline]
>   __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
>   do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4403d9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffc0efbc5c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004403d9
> RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000004
> RBP: 00000000006ca018 R08: 0000000000000008 R09: 00000000004002c8
> R10: 000000000000004a R11: 0000000000000246 R12: 0000000000401c60
> R13: 0000000000401cf0 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 548745c787596b79 ]---
> RIP: 0010:nla_get_u32 include/net/netlink.h:1474 [inline]
> RIP: 0010:nldev_stat_set_doit+0x63c/0xb70 drivers/infiniband/core/nldev.c:1760
> Code: fc 01 0f 84 58 03 00 00 e8 41 83 bf fb 4c 8b a3 58 fd ff ff 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 6d
> RSP: 0018:ffffc900068bf350 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: ffffc900068bf728 RCX: ffffffff85b60470
> RDX: 0000000000000000 RSI: ffffffff85b6047f RDI: 0000000000000004
> RBP: ffffc900068bf750 R08: ffff88808c3ee140 R09: ffff8880a25e6010
> R10: ffffed10144bcddc R11: ffff8880a25e6ee3 R12: 0000000000000000
> R13: ffff88809acb0000 R14: ffff888092a42c80 R15: 000000009ef2e29a
> FS:  0000000001ff0880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4733e34000 CR3: 00000000a9b27000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 

This issue happens when an "allocate a dynamic counter for a QP" netlink
command is received, while qpn (tb[RDMA_NLDEV_ATTR_RES_LQPN]) is not
available. Though the rdma command always set it, kernel should not
assume that input is correct.

Will fix it, thank you.

> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

