Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4DE4103A0
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 06:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhIREap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 00:30:45 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:33489 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbhIREan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 00:30:43 -0400
Received: by mail-io1-f70.google.com with SMTP id g2-20020a6b7602000000b005be59530196so22964338iom.0
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 21:29:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=yutdCfNMQHf/3X7VZNRl5IQ4X1PHlwcm9NOWpGfzp8A=;
        b=kCACuvXwwgUY/9MGVsAOYmxEyqOWzwinGz2+SAgv2f4QcT2QU0VJ6js39qoQaCg245
         vpInc1vGZda0Kyk1ITPPDtt2Zid3iSO4GYCFsUCcZA2mB+uaySwf7WtVjcRjn7KRXDDM
         euFT6JI2ylO29JQlj8nUSuaVS6wUKwweARLeZ8jU7LNxgQbK2m5uboEIKSkTfmu3mpP3
         vWWC5EIz4S7IXpO1C2Vdf5Y3NRWaYMPf4C1jANaruVo0LrtOaVQ23jy8TJ7KT3bXbEsq
         rWsHyKLZMXP5Gty4tEjFkUB2KK7pYdzPFzidF7YeHbpCjtCtkxEUxQ1pyIK4xJG1JMIq
         xX6A==
X-Gm-Message-State: AOAM5302A+CmMH9dc5Po46WkzUrEc21jIVJKLonE+E4r+Uk25ugq/5hd
        boXu/EYYPsOd+yHo4YZVNiytEbvaw3ZngFL8a96UDy/wMNCH
X-Google-Smtp-Source: ABdhPJwOqsMVwI7iWiYt/Fqfqw4qfxy0jAiJi77RbEV3LvotmXslJo1NGYVSBP/yFK5Gj9Mbh+EJNgl7XHkCXWJXUuzczo6TFbrv
MIME-Version: 1.0
X-Received: by 2002:a5d:8d1a:: with SMTP id p26mr11273260ioj.141.1631939360638;
 Fri, 17 Sep 2021 21:29:20 -0700 (PDT)
Date:   Fri, 17 Sep 2021 21:29:20 -0700
In-Reply-To: <00000000000083c858059877d77c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2cdb905cc3d7d85@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in nr_release
From:   syzbot <syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    ddf21bd8ab98 Merge tag 'iov_iter.3-5.15-2021-09-17' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b5b7e7300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccfb8533b1cbe3b1
dashboard link: https://syzkaller.appspot.com/bug?extid=caa188bdfc1eeafeb418
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13cf5753300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a860f7300000

Bisection is inconclusive: the first bad commit could be any of:

9211bfbff80a netfilter: add missing IS_ENABLED(CONFIG_BRIDGE_NETFILTER) checks to header-file.
47e640af2e49 netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.
a1b2f04ea527 netfilter: add missing includes to a number of header-files.
0abc8bf4f284 netfilter: add missing IS_ENABLED(CONFIG_NF_CONNTRACK) checks to some header-files.
bd96b4c75675 netfilter: inline four headers files into another one.
43dd16efc7f2 netfilter: nf_tables: store data in offload context registers
78458e3e08cd netfilter: add missing IS_ENABLED(CONFIG_NETFILTER) checks to some header-files.
20a9379d9a03 netfilter: remove "#ifdef __KERNEL__" guards from some headers.
bd8699e9e292 netfilter: nft_bitwise: add offload support
2a475c409fe8 kbuild: remove all netfilter headers from header-test blacklist.
7e59b3fea2a2 netfilter: remove unnecessary spaces
1b90af292e71 ipvs: Improve robustness to the ipvs sysctl
5785cf15fd74 netfilter: nf_tables: add missing prototypes.
0a30ba509fde netfilter: nf_nat_proto: make tables static
e84fb4b3666d netfilter: conntrack: use shared sysctl constants
105333435b4f netfilter: connlabels: prefer static lock initialiser
8c0bb7873815 netfilter: synproxy: rename mss synproxy_options field
c162610c7db2 Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1476109ee00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+caa188bdfc1eeafeb418@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:111 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sock_hold include/net/sock.h:702 [inline]
BUG: KASAN: use-after-free in nr_release+0x5c/0x430 net/netrom/af_netrom.c:520
Write of size 4 at addr ffff88801b5d4080 by task syz-executor240/6857

CPU: 1 PID: 6857 Comm: syz-executor240 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 print_address_description+0x66/0x3e0 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:459
 kasan_check_range+0x2b5/0x2f0 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:111 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 nr_release+0x5c/0x430 net/netrom/af_netrom.c:520
 __sock_release net/socket.c:649 [inline]
 sock_close+0xd8/0x260 net/socket.c:1314
 __fput+0x3fe/0x870 fs/file_table.c:280
 task_work_run+0x146/0x1c0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0x6fc/0x2580 kernel/exit.c:825
 do_group_exit+0x168/0x2d0 kernel/exit.c:922
 get_signal+0x16e0/0x20c0 kernel/signal.c:2868
 arch_do_signal_or_restart+0x9c/0x730 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x191/0x220 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x2e/0x70 kernel/entry/common.c:302
 do_syscall_64+0x53/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f50e35fb3c9
Code: Unable to access opcode bytes at RIP 0x7f50e35fb39f.
RSP: 002b:00007ffde62917a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: fffffffffffffe00 RBX: 0000000000000003 RCX: 00007f50e35fb3c9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000004 R08: 00007ffde62917d0 R09: 00007ffde62917d0
R10: 00007ffde62917d0 R11: 0000000000000246 R12: 000055555635f2c0
R13: 000000000000000b R14: 00007ffde6291820 R15: 0000000000000000

Allocated by task 6857:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc+0xdc/0x110 mm/kasan/common.c:513
 kasan_kmalloc include/linux/kasan.h:264 [inline]
 __kmalloc+0x24d/0x370 mm/slub.c:4391
 kmalloc include/linux/slab.h:596 [inline]
 sk_prot_alloc+0xf4/0x230 net/core/sock.c:1822
 sk_alloc+0x35/0x300 net/core/sock.c:1875
 nr_create+0x9f/0x4e0 net/netrom/af_netrom.c:433
 __sock_create+0x580/0x8d0 net/socket.c:1464
 sock_create net/socket.c:1515 [inline]
 __sys_socket+0x133/0x380 net/socket.c:1557
 __do_sys_socket net/socket.c:1566 [inline]
 __se_sys_socket net/socket.c:1564 [inline]
 __x64_sys_socket+0x76/0x80 net/socket.c:1564
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 6857:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x80 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:360
 ____kasan_slab_free+0x10d/0x150 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x129/0x1a0 mm/slub.c:1725
 slab_free mm/slub.c:3483 [inline]
 kfree+0xcf/0x2f0 mm/slub.c:4543
 sk_prot_free net/core/sock.c:1858 [inline]
 __sk_destruct+0x575/0x820 net/core/sock.c:1943
 call_timer_fn+0xf6/0x210 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers+0x71a/0x910 kernel/time/timer.c:1734
 run_timer_softirq+0x63/0xf0 kernel/time/timer.c:1747
 __do_softirq+0x392/0x7a3 kernel/softirq.c:558

The buggy address belongs to the object at ffff88801b5d4000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff88801b5d4000, ffff88801b5d4800)
The buggy address belongs to the page:
page:ffffea00006d7400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1b5d0
head:ffffea00006d7400 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888011042000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd28c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 20, ts 281243236047, free_ts 281237310240
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0x779/0xa30 mm/page_alloc.c:4153
 __alloc_pages+0x255/0x580 mm/page_alloc.c:5375
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab+0xcc/0x4d0 mm/slub.c:1900
 new_slab mm/slub.c:1963 [inline]
 ___slab_alloc+0x41e/0xc40 mm/slub.c:2994
 __slab_alloc mm/slub.c:3081 [inline]
 slab_alloc_node mm/slub.c:3172 [inline]
 __kmalloc_node_track_caller+0x2d9/0x3e0 mm/slub.c:4936
 kmalloc_reserve net/core/skbuff.c:355 [inline]
 pskb_expand_head+0x118/0x10f0 net/core/skbuff.c:1700
 netlink_trim+0x17f/0x210 net/netlink/af_netlink.c:1296
 netlink_broadcast_filtered+0x6c/0x1110 net/netlink/af_netlink.c:1501
 netlink_broadcast net/netlink/af_netlink.c:1546 [inline]
 nlmsg_multicast include/net/netlink.h:1033 [inline]
 nlmsg_notify+0x100/0x1c0 net/netlink/af_netlink.c:2547
 netdev_state_change+0x1c5/0x270 net/core/dev.c:1389
 linkwatch_do_dev+0x10a/0x160 net/core/link_watch.c:167
 __linkwatch_run_queue+0x4f5/0x800 net/core/link_watch.c:213
 linkwatch_event+0x48/0x50 net/core/link_watch.c:252
 process_one_work+0x853/0x1140 kernel/workqueue.c:2297
 worker_thread+0xac1/0x1320 kernel/workqueue.c:2444
 kthread+0x453/0x480 kernel/kthread.c:319
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0xc29/0xd20 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x7d/0x580 mm/page_alloc.c:3394
 free_slab mm/slub.c:2003 [inline]
 discard_slab mm/slub.c:2009 [inline]
 __unfreeze_partials+0x1ab/0x200 mm/slub.c:2495
 put_cpu_partial+0x132/0x1a0 mm/slub.c:2575
 do_slab_free mm/slub.c:3471 [inline]
 ___cache_free+0xe6/0x120 mm/slub.c:3490
 qlist_free_all mm/kasan/quarantine.c:165 [inline]
 kasan_quarantine_reduce+0x151/0x1c0 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x2f/0xe0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:3206 [inline]
 slab_alloc mm/slub.c:3214 [inline]
 kmem_cache_alloc+0x1c3/0x300 mm/slub.c:3219
 getname_flags+0xba/0x650 fs/namei.c:138
 do_sys_openat2+0xd2/0x500 fs/open.c:1194
 do_sys_open fs/open.c:1216 [inline]
 __do_sys_open fs/open.c:1224 [inline]
 __se_sys_open fs/open.c:1220 [inline]
 __x64_sys_open+0x221/0x270 fs/open.c:1220
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88801b5d3f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801b5d4000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801b5d4080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801b5d4100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801b5d4180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

