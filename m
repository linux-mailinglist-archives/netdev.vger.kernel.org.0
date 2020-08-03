Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA17423A94B
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgHCPXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 11:23:21 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54222 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCPXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 11:23:20 -0400
Received: by mail-io1-f70.google.com with SMTP id f22so18739688iof.20
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 08:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JP1YGuENzAUY/5Jsdx5Oue3ZQWquXQQ9HgkjsajeaVg=;
        b=WVAgK9FY4B8vLfc7OysZp/w7zZKXiQCTF2hYzBvSR7lYvUpuoiCLD6QqUHnOL9zxBY
         zjcFcBgVlPSJq9jN2kldbQMpMqkLN2ufO174eR1sfbfFeo+Win6TIm2YjOrrsMSEFLH7
         cfeR5sm7+TwOomSC6TIk3Xg097gDsvhozk20geiiPK97sxpSOicBOGiOrkNMjNzRUtgD
         47Vns2VvaHD9aRyDN4JdMvjhkqLcDnkUCe1tNa5sIqGGGh8bJeVok8onpjNRi06sDo4Q
         H3fWt0ub1xARnrAiIKUyooy0H7htGaur9kzCFhSCsXyskQ6R/6wHMwooYGQxi2wD8GFM
         lB3g==
X-Gm-Message-State: AOAM530YP1hfcS+lNmVCJ8C2G7TXb/tIRhLu9+NqMcAP4AIgGcvqmwIi
        ra1BNsd1ZxEuYeC+siZ8E9h3CWxwTpcDw4oWrApM83jVCxgp
X-Google-Smtp-Source: ABdhPJzgTiPAwDVjKfNb3vBVWd0nr8W0ENwq3LPAR5gOpvzrpdTelNlbqfnOipw5qp7R/GI7KhSxKCXiTJmZzC24ctm8YE442OIP
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8a8:: with SMTP id a8mr18192239ilt.52.1596468199809;
 Mon, 03 Aug 2020 08:23:19 -0700 (PDT)
Date:   Mon, 03 Aug 2020 08:23:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1e88005abfab762@google.com>
Subject: KASAN: use-after-free Read in tipc_bcast_get_mode
From:   syzbot <syzbot+6ea1f7a8df64596ef4d7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bd0b33b2 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13f236a4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91a13b78c7dc258d
dashboard link: https://syzkaller.appspot.com/bug?extid=6ea1f7a8df64596ef4d7
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6ea1f7a8df64596ef4d7@syzkaller.appspotmail.com

tipc: 32-bit node address hash set to fcff1eac
==================================================================
BUG: KASAN: use-after-free in tipc_bcast_get_mode+0x3ab/0x400 net/tipc/bcast.c:759
Read of size 1 at addr ffff88805e6b3571 by task kworker/0:6/3850

CPU: 0 PID: 3850 Comm: kworker/0:6 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events tipc_net_finalize_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 tipc_bcast_get_mode+0x3ab/0x400 net/tipc/bcast.c:759
 tipc_node_broadcast+0x9e/0xcc0 net/tipc/node.c:1744
 tipc_nametbl_publish+0x60b/0x970 net/tipc/name_table.c:752
 tipc_net_finalize net/tipc/net.c:141 [inline]
 tipc_net_finalize+0x1fa/0x310 net/tipc/net.c:131
 tipc_net_finalize_work+0x55/0x80 net/tipc/net.c:150
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 8062:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 tipc_bcast_init+0x21e/0x7b0 net/tipc/bcast.c:689
 tipc_init_net+0x4f6/0x5c0 net/tipc/core.c:85
 ops_init+0xaf/0x470 net/core/net_namespace.c:151
 setup_net+0x2d8/0x850 net/core/net_namespace.c:341
 copy_net_ns+0x2cf/0x5e0 net/core/net_namespace.c:482
 create_new_namespaces+0x3f6/0xb10 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:231
 ksys_unshare+0x36c/0x9a0 kernel/fork.c:2979
 __do_sys_unshare kernel/fork.c:3047 [inline]
 __se_sys_unshare kernel/fork.c:3045 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3045
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8843:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 tipc_bcast_stop+0x1b0/0x2f0 net/tipc/bcast.c:721
 tipc_exit_net+0x24/0x270 net/tipc/core.c:112
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:186
 cleanup_net+0x4ea/0xa00 net/core/net_namespace.c:603
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff88805e6b3500
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 113 bytes inside of
 128-byte region [ffff88805e6b3500, ffff88805e6b3580)
The buggy address belongs to the page:
page:ffffea000179acc0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002375c48 ffff8880aa001550 ffff8880aa000700
raw: 0000000000000000 ffff88805e6b3000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88805e6b3400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88805e6b3480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88805e6b3500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88805e6b3580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88805e6b3600: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
