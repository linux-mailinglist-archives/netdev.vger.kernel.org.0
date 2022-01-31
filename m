Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9684A4EFC
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 19:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358510AbiAaSxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 13:53:22 -0500
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:2688
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1358290AbiAaSxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 13:53:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GEFQEjZ2eJFUbVuBM0wt0DpKU5tXqhh3yRDUghhaenKwv13DOMJBKnrh/blTkdOBd1p7vSPzQxC7dFWUj1tuRMeRFvzNhh5OPZMWPz8Zz9JVSo3K6xb3VDrE9Hx1gYR5BvcaWCs2xCWpQZjbyIWfNDssDcZWCmWtBUF1e41UqHXprD5fmJGDsRnACZ4TBXJ7SvgFsq5n/Bsjb+v3Q105hy7EpA45uqIUEbPBLaZ0eVedqCLDMR6Y3Mfo1+ZmQJAbRLpTpdHUvlYrQo+CzQs5M3eUayZwiCUxEl83lH8PgkTXevS0jdNKwoGMkM+4t0FdHBEg220XwReeNbbMpuwTdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MV6bGgnN94hPnykglaroODaEJnv1z0fFJfQAql8NQUI=;
 b=Hm9O0BNorz679qlX1Lc639m/JpTH92T72ATNEDSGLB5s8Qcp13pCiXGWgLXM7qYGN/jyoPETvR5kddUq7ZQpoX5KeaoIGW5qC7JIW6tIz5i9+CZYk6zIXOHNBYRYJ20FjnbpdEEEDfJnLgch0kQYo7Nfevk7cefBhSzkpMy+ZmBT6wPYvW6xxMdIY5Kgl/LsOHURmhWWOAJgaD8sai7OMfAxj+bWZql4mhJFtxXzvP5B9eGg69DZhyoFWTXjG8cW6dCtwzmimblsrlDg3wU4Xf/XBBCHJtlQdCQKS10WS3vQo3GSecvcq9iZvxDy3lWndPMZwHbw7exrOiQenxVJbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MV6bGgnN94hPnykglaroODaEJnv1z0fFJfQAql8NQUI=;
 b=c2kp//eLTcBSSOYgY63nGK9Fy6MEZcr7IuxsuEXpvG/lrRxsw1PFCHWvjUc3+0pOfC2hH8I83u3gU+5YgZyyKVYxJ7xxffooNj93uiohKTTgMAYB6oLU6C3NplDhL7IBG4nNXOuFRlMo6qhiaErMmYGjg1u7+xm05qlc7VHFomWhBkfGNhovzFb+2CuCcHNN7Hx2s1QSt8P791mD5T+sW+N732FvrlJKcF3q548mLtt6FP4i1S5gzFRYUgQ8K+gWH1rUA2uv24AhRlpHN9YfsrKIu5o9Dq7P1YPaLeh7jbIak8xy2xf+eRC1ZWWivnkUsfwbksz6llOXB0ebN+47cg==
Received: from DM6PR02CA0133.namprd02.prod.outlook.com (2603:10b6:5:1b4::35)
 by MN2PR12MB4389.namprd12.prod.outlook.com (2603:10b6:208:262::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 18:53:16 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::df) by DM6PR02CA0133.outlook.office365.com
 (2603:10b6:5:1b4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Mon, 31 Jan 2022 18:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Mon, 31 Jan 2022 18:53:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 31 Jan
 2022 18:53:14 +0000
Received: from localhost.localdomain.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 31 Jan 2022 10:53:11 -0800
References: <20220131172018.3704490-1-eric.dumazet@gmail.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] net: sched: fix use-after-free in tc_new_tfilter()
In-Reply-To: <20220131172018.3704490-1-eric.dumazet@gmail.com>
Message-ID: <ygnh1r0npwiy.fsf@nvidia.com>
Date:   Mon, 31 Jan 2022 20:53:09 +0200
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6690b764-a282-42d1-c1fc-08d9e4eaf07f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4389:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4389593A14E1FB7E7D47FD7EA0259@MN2PR12MB4389.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1WB15oUOjVDKhidjHKAQctoMB1DteQxfNxx8QosaMlUj991yYMeAutvx52HOh0tdhE9GxZpA5hG6rP5avRo8ZOfRYoHDqykSLK7WwzJ8nBTzpkuTEvdr1TUVwPrmEYxeNqDUWvSIFGyQTcfmcDnTHmCFOt8cIc4MQt3hlozYdxpAvJ8xlGXIGwwqhqRMpKAVTiDrRF8leGRQNADlhlD5y++AzVkZYlN7sxcvJZHcA84KbK8vKJJqzsDQ5MoTBbZjTZEOov6cg5ulF3EmaNKf33CPsOlKuq7UfgiERyYVLv616H1W6ltF2HFWX9UMsUci3XKst7vo9CNz6FKQWoMnUdZ8wJVpwA7KJklXGqpMzeZ9tK3uG5SWKkP5AksBxdXQHLRNzVp375Id76HrmMj1MfyJc93iYSswB+hWisWXZPTNpYiFXr6or9GNbhRzt2ejejE9aMGy9g0s8dqkfCFIj54eG/RfRtVQtUpl2LG7N52TATLPkMT+WP7suCDkWvhG1Bbhw7pn0lnEOqOLaJsvftF3B260mwKkpAQkhUHlzgUqGW45ex46UyuwcPNrzAKde3poLhHsKiC0AibOJKjAvBolFW3Wqc3lwp1X23C6vW2HLqLqcQNrZpw8ujJ9YGphNN6mvu5Tk3U3zgBvr1Jhhs5jR5edAUDL9ms/Vyrecj3iFfWET/iawMj3iaY87urwyy0K0YV2QHeqzecDW8Myg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(508600001)(6916009)(2616005)(36860700001)(47076005)(7696005)(86362001)(186003)(26005)(16526019)(36756003)(316002)(426003)(336012)(81166007)(356005)(82310400004)(8936002)(8676002)(70586007)(4326008)(70206006)(40460700003)(30864003)(5660300002)(83380400001)(2906002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 18:53:15.6145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6690b764-a282-42d1-c1fc-08d9e4eaf07f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4389
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Mon 31 Jan 2022 at 19:20, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> Whenever tc_new_tfilter() jumps back to replay: label,
> we need to make sure @q and @chain local variables are cleared again,
> or risk use-after-free as in [1]
>
> For consistency, apply the same fix in tc_ctl_chain()
>
> BUG: KASAN: use-after-free in mini_qdisc_pair_swap+0x1b9/0x1f0 net/sched/sch_generic.c:1581
> Write of size 8 at addr ffff8880985c4b08 by task syz-executor.4/1945
>
> CPU: 0 PID: 1945 Comm: syz-executor.4 Not tainted 5.17.0-rc1-syzkaller-00495-gff58831fa02d #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>  mini_qdisc_pair_swap+0x1b9/0x1f0 net/sched/sch_generic.c:1581
>  tcf_chain_head_change_item net/sched/cls_api.c:372 [inline]
>  tcf_chain0_head_change.isra.0+0xb9/0x120 net/sched/cls_api.c:386
>  tcf_chain_tp_insert net/sched/cls_api.c:1657 [inline]
>  tcf_chain_tp_insert_unique net/sched/cls_api.c:1707 [inline]
>  tc_new_tfilter+0x1e67/0x2350 net/sched/cls_api.c:2086
>  rtnetlink_rcv_msg+0x80d/0xb80 net/core/rtnetlink.c:5583
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
>  netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x331/0x810 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmmsg+0x195/0x470 net/socket.c:2553
>  __do_sys_sendmmsg net/socket.c:2582 [inline]
>  __se_sys_sendmmsg net/socket.c:2579 [inline]
>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2579
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f2647172059
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2645aa5168 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007f2647285100 RCX: 00007f2647172059
> RDX: 040000000000009f RSI: 00000000200002c0 RDI: 0000000000000006
> RBP: 00007f26471cc08d R08: 0000000000000000 R09: 0000000000000000
> R10: 9e00000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fffb3f7f02f R14: 00007f2645aa5300 R15: 0000000000022000
>  </TASK>
>
> Allocated by task 1944:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:45 [inline]
>  set_alloc_info mm/kasan/common.c:436 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:515 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:474 [inline]
>  __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
>  kmalloc_node include/linux/slab.h:604 [inline]
>  kzalloc_node include/linux/slab.h:726 [inline]
>  qdisc_alloc+0xac/0xa10 net/sched/sch_generic.c:941
>  qdisc_create.constprop.0+0xce/0x10f0 net/sched/sch_api.c:1211
>  tc_modify_qdisc+0x4c5/0x1980 net/sched/sch_api.c:1660
>  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5592
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
>  netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x331/0x810 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmmsg+0x195/0x470 net/socket.c:2553
>  __do_sys_sendmmsg net/socket.c:2582 [inline]
>  __se_sys_sendmmsg net/socket.c:2579 [inline]
>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2579
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Freed by task 3609:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free+0x130/0x160 mm/kasan/common.c:328
>  kasan_slab_free include/linux/kasan.h:236 [inline]
>  slab_free_hook mm/slub.c:1728 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1754
>  slab_free mm/slub.c:3509 [inline]
>  kfree+0xcb/0x280 mm/slub.c:4562
>  rcu_do_batch kernel/rcu/tree.c:2527 [inline]
>  rcu_core+0x7b8/0x1540 kernel/rcu/tree.c:2778
>  __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
>
> Last potentially related work creation:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>  __call_rcu kernel/rcu/tree.c:3026 [inline]
>  call_rcu+0xb1/0x740 kernel/rcu/tree.c:3106
>  qdisc_put_unlocked+0x6f/0x90 net/sched/sch_generic.c:1109
>  tcf_block_release+0x86/0x90 net/sched/cls_api.c:1238
>  tc_new_tfilter+0xc0d/0x2350 net/sched/cls_api.c:2148
>  rtnetlink_rcv_msg+0x80d/0xb80 net/core/rtnetlink.c:5583
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
>  netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
>  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:705 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:725
>  ____sys_sendmsg+0x331/0x810 net/socket.c:2413
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>  __sys_sendmmsg+0x195/0x470 net/socket.c:2553
>  __do_sys_sendmmsg net/socket.c:2582 [inline]
>  __se_sys_sendmmsg net/socket.c:2579 [inline]
>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2579
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff8880985c4800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 776 bytes inside of
>  1024-byte region [ffff8880985c4800, ffff8880985c4c00)
> The buggy address belongs to the page:
> page:ffffea0002617000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x985c0
> head:ffffea0002617000 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c41dc0
> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 1941, ts 1038999441284, free_ts 1033444432829
>  prep_new_page mm/page_alloc.c:2434 [inline]
>  get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
>  __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
>  alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
>  alloc_slab_page mm/slub.c:1799 [inline]
>  allocate_slab mm/slub.c:1944 [inline]
>  new_slab+0x28a/0x3b0 mm/slub.c:2004
>  ___slab_alloc+0x87c/0xe90 mm/slub.c:3018
>  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
>  slab_alloc_node mm/slub.c:3196 [inline]
>  slab_alloc mm/slub.c:3238 [inline]
>  __kmalloc+0x2fb/0x340 mm/slub.c:4420
>  kmalloc include/linux/slab.h:586 [inline]
>  kzalloc include/linux/slab.h:715 [inline]
>  __register_sysctl_table+0x112/0x1090 fs/proc/proc_sysctl.c:1335
>  neigh_sysctl_register+0x2c8/0x5e0 net/core/neighbour.c:3787
>  devinet_sysctl_register+0xb1/0x230 net/ipv4/devinet.c:2618
>  inetdev_init+0x286/0x580 net/ipv4/devinet.c:278
>  inetdev_event+0xa8a/0x15d0 net/ipv4/devinet.c:1532
>  notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
>  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1919
>  call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
>  call_netdevice_notifiers net/core/dev.c:1945 [inline]
>  register_netdevice+0x1073/0x1500 net/core/dev.c:9698
>  veth_newlink+0x59c/0xa90 drivers/net/veth.c:1722
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1352 [inline]
>  free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
>  free_unref_page_prepare mm/page_alloc.c:3325 [inline]
>  free_unref_page+0x19/0x690 mm/page_alloc.c:3404
>  release_pages+0x748/0x1220 mm/swap.c:956
>  tlb_batch_pages_flush mm/mmu_gather.c:50 [inline]
>  tlb_flush_mmu_free mm/mmu_gather.c:243 [inline]
>  tlb_flush_mmu+0xe9/0x6b0 mm/mmu_gather.c:250
>  zap_pte_range mm/memory.c:1441 [inline]
>  zap_pmd_range mm/memory.c:1490 [inline]
>  zap_pud_range mm/memory.c:1519 [inline]
>  zap_p4d_range mm/memory.c:1540 [inline]
>  unmap_page_range+0x1d1d/0x2a30 mm/memory.c:1561
>  unmap_single_vma+0x198/0x310 mm/memory.c:1606
>  unmap_vmas+0x16b/0x2f0 mm/memory.c:1638
>  exit_mmap+0x201/0x670 mm/mmap.c:3178
>  __mmput+0x122/0x4b0 kernel/fork.c:1114
>  mmput+0x56/0x60 kernel/fork.c:1135
>  exit_mm kernel/exit.c:507 [inline]
>  do_exit+0xa3c/0x2a30 kernel/exit.c:793
>  do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>  __do_sys_exit_group kernel/exit.c:946 [inline]
>  __se_sys_exit_group kernel/exit.c:944 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:944
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Memory state around the buggy address:
>  ffff8880985c4a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880985c4a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>ffff8880985c4b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                       ^
>  ffff8880985c4b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880985c4c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>
> Fixes: 470502de5bdb ("net: sched: unlock rules update API")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Vlad Buslov <vladbu@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>  net/sched/cls_api.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d4e27c679123f0f62d033c3ad0eeda838e83cb49..5f0f346b576fc0f52a5b8de21758af5425285c2c 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -1945,9 +1945,9 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	bool prio_allocate;
>  	u32 parent;
>  	u32 chain_index;
> -	struct Qdisc *q = NULL;
> +	struct Qdisc *q;
>  	struct tcf_chain_info chain_info;
> -	struct tcf_chain *chain = NULL;
> +	struct tcf_chain *chain;
>  	struct tcf_block *block;
>  	struct tcf_proto *tp;
>  	unsigned long cl;
> @@ -1976,6 +1976,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  	tp = NULL;
>  	cl = 0;
>  	block = NULL;
> +	q = NULL;

First of all, thanks for fixing this!
Maybe it would be better to change __tcf_qdisc_find() to always set q to
NULL at the start instead of fixing all users. WDYT?

> +	chain = NULL;
>  	flags = 0;
>  
>  	if (prio == 0) {
> @@ -2798,8 +2800,8 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
>  	struct tcmsg *t;
>  	u32 parent;
>  	u32 chain_index;
> -	struct Qdisc *q = NULL;
> -	struct tcf_chain *chain = NULL;
> +	struct Qdisc *q;
> +	struct tcf_chain *chain;

What is the code path that can reuse old chain value on replay here or
in tcf_new_tfilter()? I read the code several times and didn't get it.

>  	struct tcf_block *block;
>  	unsigned long cl;
>  	int err;
> @@ -2809,6 +2811,7 @@ static int tc_ctl_chain(struct sk_buff *skb, struct nlmsghdr *n,
>  		return -EPERM;
>  
>  replay:
> +	q = NULL;
>  	err = nlmsg_parse_deprecated(n, sizeof(*t), tca, TCA_MAX,
>  				     rtm_tca_policy, extack);
>  	if (err < 0)

