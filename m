Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1490C41C7E4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345061AbhI2PLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:11:35 -0400
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:40161
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344834AbhI2PLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 11:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IvIvX6Dqgv9XJy3Uuer6ERiFdLXbKGusKPWc3Mgj39ZaY7pr36gean7uXpQGvE3vE07ljqUZrAyC04E4Qxyy4S9mVDvMBLKNiD+4aAEWaMzzIJKxOwwCo5kpTSIjaFvOvticneGgPX7Q8PgVJqTZpLdkQOgY0vDU1EOe/EQ+bzsYv3VbJpBylYABEnmy84VaesIgTgBcYHovKHvbH7k8mDtQZdIS0fCYixEgTqtKgZbetTdlhgy3SRDTG3cR0ELax2VU0BCqmFIhaea7cfrtIA4Qo7sE/ySW75Pn6by7pruMi3dPxlB8XkgIKRDvXnaPXTT2iiPw9W+vNAos4WVzsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KgnFbUmfltS1m0MOzC6sInBWLdOb1v/kznBIIpM4qxY=;
 b=cf8tgXc5jWAyK6aOBVtTGPRVMtxgNl4ySF3Q7cc428bWRc3V9xLRf1cDZWcsXYtJ6SXeAhtJMhVFBSxB94jUmRTyf9FaHdMOy0wMWljPOwdUbfv9jRYqfsP2guxKO82v1s7BR8vaic8pcTDt/qMBmmjadsyCjSjVc8qTOtk7OBTlEY3P1n5hJuC80jHN/20qhmSwVvh8kqWrTUrtK1I2oqZivF6axU7nt0EQJiN1+Rz0FnSOUITYnOHUCH2FW+dkQmOllrQJ3IaWQY4Z9XUXDjs4Y+co1q1Ms1JzBGzXXoz46bSEE8ajcunpAOsWVOi8vkwqIULayMwbOpWPnka1wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KgnFbUmfltS1m0MOzC6sInBWLdOb1v/kznBIIpM4qxY=;
 b=Ox1Mgmi8L48f6hsvqxvkxtffHnwMlHepxxezSonN9ktGWc33j78Vx/HCQR4dZm4/fdkJNGAKdML0lVDNSgbpx0yVOxxcFxulRjsbLSI/cl/L/z/FQOnUqBynW8ZM9zLlakpvIJGoZmny5lGoGUePRyAus80z8LuPH8/+Cb/NgjFJnrGAqUIk/JUCs8t2vMZTFeXFmQ6WZXXKXbmllZYHo6BsbFQuKYUkx6K6cO1N1jKX0BssA73lAlESwilKl31Rg1vOy3IpbCaWYhlo9dMVY0GmlkJ//25BC7HkmC0n4eU/9Dxpbq5LRNPafC/RCOEgAz477At1rq2mCu6fytxxmA==
Received: from DM5PR21CA0005.namprd21.prod.outlook.com (2603:10b6:3:ac::15) by
 DM6PR12MB3819.namprd12.prod.outlook.com (2603:10b6:5:1c6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Wed, 29 Sep 2021 15:09:51 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::ee) by DM5PR21CA0005.outlook.office365.com
 (2603:10b6:3:ac::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.1 via Frontend
 Transport; Wed, 29 Sep 2021 15:09:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 15:09:51 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 15:09:49 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 29 Sep 2021 15:09:47 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net] net: sched: flower: protect fl_walk() with rcu
Date:   Wed, 29 Sep 2021 18:08:49 +0300
Message-ID: <20210929150849.1051782-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0084c879-afa3-4737-98a2-08d9835b2f73
X-MS-TrafficTypeDiagnostic: DM6PR12MB3819:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3819F8DB78A36FDF6DA16C7AA0A99@DM6PR12MB3819.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UXGg/eF72vMOsKjIpDsxhn2PKwt2UhD266Osy383sBui+440xQDrfh/E6lw6DlUWpk3B/k12rMLsmmZCLjhD6Yl2olBXC4G5f3z7A80h7tlpZpBKeZrWdeEOhjWxesElcOSwih/pAsXOYL7FfEnIlqNgDS5vBFOmJ4w4uaanOm5c0ny2Qv0fKG/NUd1y2qOqU+l5ZogoYxlXoC8qIf/w2EZZzf7U3C3nkArhkwBrvUBfdeWL2e2mIGS6O9cEARdjIHJtF0C5wjVBY2KhhpXuIbMt/x3Lp7AGTaAVmZMMkJEe2LoFpRnSxwu6bfj8Vc0o/bXoS4aIb2sJoxWdDBJJfaYRlo+g+p5N3NiKT4Gyx6Tbmokt28Htj/j6dl4O1YJMVL2CsoshLPgJs7BoRk6eNLFy3uKWyzekcAaKlX81Kpc+sEmCMnpmq/Hwnsu7bs3cmiyX3oJ6D+7JB017tgKYU2sHLXGv2aR6SZkAgQBvJOxcB+l9UVMHN0mahncPyDjm3nhI5szWI5vf9Zq+PQjevBpkXCKmvHdWlfnMmFPjMjR7gOrTBr53XwLhCNNLpX2dvR0lv6oE3IJ4bL3MXyLTp2i0qqMEpvRsFqJcADQK1919OBJ1TWMub3pFA2PR2dnGjvs8xY66dkJBQ7SaPccQjapfmSQ/3LmDzG5glum+l2Nz9EYkJC9x6xp5SCROsdriS416TIXd5ipmXb58hZ6rw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8676002)(2616005)(8936002)(426003)(336012)(36756003)(83380400001)(2906002)(70586007)(47076005)(70206006)(26005)(316002)(5660300002)(186003)(82310400003)(356005)(86362001)(7636003)(54906003)(110136005)(7696005)(107886003)(4326008)(508600001)(1076003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 15:09:51.0023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0084c879-afa3-4737-98a2-08d9835b2f73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3819
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch that refactored fl_walk() to use idr_for_each_entry_continue_ul()
also removed rcu protection of individual filters which causes following
use-after-free when filter is deleted concurrently. Fix fl_walk() to obtain
rcu read lock while iterating and taking the filter reference and temporary
release the lock while calling arg->fn() callback that can sleep.

KASAN trace:

[  352.773640] ==================================================================
[  352.775041] BUG: KASAN: use-after-free in fl_walk+0x159/0x240 [cls_flower]
[  352.776304] Read of size 4 at addr ffff8881c8251480 by task tc/2987

[  352.777862] CPU: 3 PID: 2987 Comm: tc Not tainted 5.15.0-rc2+ #2
[  352.778980] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  352.781022] Call Trace:
[  352.781573]  dump_stack_lvl+0x46/0x5a
[  352.782332]  print_address_description.constprop.0+0x1f/0x140
[  352.783400]  ? fl_walk+0x159/0x240 [cls_flower]
[  352.784292]  ? fl_walk+0x159/0x240 [cls_flower]
[  352.785138]  kasan_report.cold+0x83/0xdf
[  352.785851]  ? fl_walk+0x159/0x240 [cls_flower]
[  352.786587]  kasan_check_range+0x145/0x1a0
[  352.787337]  fl_walk+0x159/0x240 [cls_flower]
[  352.788163]  ? fl_put+0x10/0x10 [cls_flower]
[  352.789007]  ? __mutex_unlock_slowpath.constprop.0+0x220/0x220
[  352.790102]  tcf_chain_dump+0x231/0x450
[  352.790878]  ? tcf_chain_tp_delete_empty+0x170/0x170
[  352.791833]  ? __might_sleep+0x2e/0xc0
[  352.792594]  ? tfilter_notify+0x170/0x170
[  352.793400]  ? __mutex_unlock_slowpath.constprop.0+0x220/0x220
[  352.794477]  tc_dump_tfilter+0x385/0x4b0
[  352.795262]  ? tc_new_tfilter+0x1180/0x1180
[  352.796103]  ? __mod_node_page_state+0x1f/0xc0
[  352.796974]  ? __build_skb_around+0x10e/0x130
[  352.797826]  netlink_dump+0x2c0/0x560
[  352.798563]  ? netlink_getsockopt+0x430/0x430
[  352.799433]  ? __mutex_unlock_slowpath.constprop.0+0x220/0x220
[  352.800542]  __netlink_dump_start+0x356/0x440
[  352.801397]  rtnetlink_rcv_msg+0x3ff/0x550
[  352.802190]  ? tc_new_tfilter+0x1180/0x1180
[  352.802872]  ? rtnl_calcit.isra.0+0x1f0/0x1f0
[  352.803668]  ? tc_new_tfilter+0x1180/0x1180
[  352.804344]  ? _copy_from_iter_nocache+0x800/0x800
[  352.805202]  ? kasan_set_track+0x1c/0x30
[  352.805900]  netlink_rcv_skb+0xc6/0x1f0
[  352.806587]  ? rht_deferred_worker+0x6b0/0x6b0
[  352.807455]  ? rtnl_calcit.isra.0+0x1f0/0x1f0
[  352.808324]  ? netlink_ack+0x4d0/0x4d0
[  352.809086]  ? netlink_deliver_tap+0x62/0x3d0
[  352.809951]  netlink_unicast+0x353/0x480
[  352.810744]  ? netlink_attachskb+0x430/0x430
[  352.811586]  ? __alloc_skb+0xd7/0x200
[  352.812349]  netlink_sendmsg+0x396/0x680
[  352.813132]  ? netlink_unicast+0x480/0x480
[  352.813952]  ? __import_iovec+0x192/0x210
[  352.814759]  ? netlink_unicast+0x480/0x480
[  352.815580]  sock_sendmsg+0x6c/0x80
[  352.816299]  ____sys_sendmsg+0x3a5/0x3c0
[  352.817096]  ? kernel_sendmsg+0x30/0x30
[  352.817873]  ? __ia32_sys_recvmmsg+0x150/0x150
[  352.818753]  ___sys_sendmsg+0xd8/0x140
[  352.819518]  ? sendmsg_copy_msghdr+0x110/0x110
[  352.820402]  ? ___sys_recvmsg+0xf4/0x1a0
[  352.821110]  ? __copy_msghdr_from_user+0x260/0x260
[  352.821934]  ? _raw_spin_lock+0x81/0xd0
[  352.822680]  ? __handle_mm_fault+0xef3/0x1b20
[  352.823549]  ? rb_insert_color+0x2a/0x270
[  352.824373]  ? copy_page_range+0x16b0/0x16b0
[  352.825209]  ? perf_event_update_userpage+0x2d0/0x2d0
[  352.826190]  ? __fget_light+0xd9/0xf0
[  352.826941]  __sys_sendmsg+0xb3/0x130
[  352.827613]  ? __sys_sendmsg_sock+0x20/0x20
[  352.828377]  ? do_user_addr_fault+0x2c5/0x8a0
[  352.829184]  ? fpregs_assert_state_consistent+0x52/0x60
[  352.830001]  ? exit_to_user_mode_prepare+0x32/0x160
[  352.830845]  do_syscall_64+0x35/0x80
[  352.831445]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  352.832331] RIP: 0033:0x7f7bee973c17
[  352.833078] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[  352.836202] RSP: 002b:00007ffcbb368e28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  352.837524] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7bee973c17
[  352.838715] RDX: 0000000000000000 RSI: 00007ffcbb368e50 RDI: 0000000000000003
[  352.839838] RBP: 00007ffcbb36d090 R08: 00000000cea96d79 R09: 00007f7beea34a40
[  352.841021] R10: 00000000004059bb R11: 0000000000000246 R12: 000000000046563f
[  352.842208] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffcbb36d088

[  352.843784] Allocated by task 2960:
[  352.844451]  kasan_save_stack+0x1b/0x40
[  352.845173]  __kasan_kmalloc+0x7c/0x90
[  352.845873]  fl_change+0x282/0x22db [cls_flower]
[  352.846696]  tc_new_tfilter+0x6cf/0x1180
[  352.847493]  rtnetlink_rcv_msg+0x471/0x550
[  352.848323]  netlink_rcv_skb+0xc6/0x1f0
[  352.849097]  netlink_unicast+0x353/0x480
[  352.849886]  netlink_sendmsg+0x396/0x680
[  352.850678]  sock_sendmsg+0x6c/0x80
[  352.851398]  ____sys_sendmsg+0x3a5/0x3c0
[  352.852202]  ___sys_sendmsg+0xd8/0x140
[  352.852967]  __sys_sendmsg+0xb3/0x130
[  352.853718]  do_syscall_64+0x35/0x80
[  352.854457]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[  352.855830] Freed by task 7:
[  352.856421]  kasan_save_stack+0x1b/0x40
[  352.857139]  kasan_set_track+0x1c/0x30
[  352.857854]  kasan_set_free_info+0x20/0x30
[  352.858609]  __kasan_slab_free+0xed/0x130
[  352.859348]  kfree+0xa7/0x3c0
[  352.859951]  process_one_work+0x44d/0x780
[  352.860685]  worker_thread+0x2e2/0x7e0
[  352.861390]  kthread+0x1f4/0x220
[  352.862022]  ret_from_fork+0x1f/0x30

[  352.862955] Last potentially related work creation:
[  352.863758]  kasan_save_stack+0x1b/0x40
[  352.864378]  kasan_record_aux_stack+0xab/0xc0
[  352.865028]  insert_work+0x30/0x160
[  352.865617]  __queue_work+0x351/0x670
[  352.866261]  rcu_work_rcufn+0x30/0x40
[  352.866917]  rcu_core+0x3b2/0xdb0
[  352.867561]  __do_softirq+0xf6/0x386

[  352.868708] Second to last potentially related work creation:
[  352.869779]  kasan_save_stack+0x1b/0x40
[  352.870560]  kasan_record_aux_stack+0xab/0xc0
[  352.871426]  call_rcu+0x5f/0x5c0
[  352.872108]  queue_rcu_work+0x44/0x50
[  352.872855]  __fl_put+0x17c/0x240 [cls_flower]
[  352.873733]  fl_delete+0xc7/0x100 [cls_flower]
[  352.874607]  tc_del_tfilter+0x510/0xb30
[  352.886085]  rtnetlink_rcv_msg+0x471/0x550
[  352.886875]  netlink_rcv_skb+0xc6/0x1f0
[  352.887636]  netlink_unicast+0x353/0x480
[  352.888285]  netlink_sendmsg+0x396/0x680
[  352.888942]  sock_sendmsg+0x6c/0x80
[  352.889583]  ____sys_sendmsg+0x3a5/0x3c0
[  352.890311]  ___sys_sendmsg+0xd8/0x140
[  352.891019]  __sys_sendmsg+0xb3/0x130
[  352.891716]  do_syscall_64+0x35/0x80
[  352.892395]  entry_SYSCALL_64_after_hwframe+0x44/0xae

[  352.893666] The buggy address belongs to the object at ffff8881c8251000
                which belongs to the cache kmalloc-2k of size 2048
[  352.895696] The buggy address is located 1152 bytes inside of
                2048-byte region [ffff8881c8251000, ffff8881c8251800)
[  352.897640] The buggy address belongs to the page:
[  352.898492] page:00000000213bac35 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1c8250
[  352.900110] head:00000000213bac35 order:3 compound_mapcount:0 compound_pincount:0
[  352.901541] flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
[  352.902908] raw: 002ffff800010200 0000000000000000 dead000000000122 ffff888100042f00
[  352.904391] raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
[  352.905861] page dumped because: kasan: bad access detected

[  352.907323] Memory state around the buggy address:
[  352.908218]  ffff8881c8251380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  352.909471]  ffff8881c8251400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  352.910735] >ffff8881c8251480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  352.912012]                    ^
[  352.912642]  ffff8881c8251500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  352.913919]  ffff8881c8251580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  352.915185] ==================================================================

Fixes: d39d714969cd ("idr: introduce idr_for_each_entry_continue_ul()")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/cls_flower.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 23b21253b3c3..eb6345a027e1 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2188,18 +2188,24 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 
 	arg->count = arg->skip;
 
+	rcu_read_lock();
 	idr_for_each_entry_continue_ul(&head->handle_idr, f, tmp, id) {
 		/* don't return filters that are being deleted */
 		if (!refcount_inc_not_zero(&f->refcnt))
 			continue;
+		rcu_read_unlock();
+
 		if (arg->fn(tp, f, arg) < 0) {
 			__fl_put(f);
 			arg->stop = 1;
+			rcu_read_lock();
 			break;
 		}
 		__fl_put(f);
 		arg->count++;
+		rcu_read_lock();
 	}
+	rcu_read_unlock();
 	arg->cookie = id;
 }
 
-- 
2.31.1

