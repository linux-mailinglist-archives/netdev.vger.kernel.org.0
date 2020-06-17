Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FBC1FCBFB
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFQLOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:14:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:45564 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgFQLOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:14:15 -0400
Received: by mail-io1-f72.google.com with SMTP id r11so1525606ioa.12
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 04:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=74zgtILYzJ4Q87way40PouYE06q/enXdI9CPRRVKbMw=;
        b=kcZK3NTEGuKdr+tQH/SQ7o9SoxNa+GbFjDCQ2XWuYlFswF3sLqoOnMk59Upi1vTjaF
         gWcOIxAMG0DR9brbrWMkIrplkCqx3ohmykPwDNjwz9eaglc5UkokUJeu5DYqUB4AQwGd
         2SvWhDTF3bx1V6KGvpbri6LcyvFDTLAL8/TTYogXY+wMzu0W+AkFgp73yvgVyF8fD7pw
         Xw5CtbRKpF+mOdxukklUKu+mzzAG5Hze76VUXnnRzB4Jsrp9QplOW9EjUkCOdlEpboia
         9uup6ulZZkmfKRYvMRctwOXprLEHYmq4U27+Tyv3d+CL5HLaAPPnpwcXpLB4/0Eb+VkO
         RJyA==
X-Gm-Message-State: AOAM533Brm0K4by6W5zWaRLIIbndZ6mh9VvCggfwB4+DTAEcAjd42Dbs
        IRT/Db6S4e8Hl3IDqmsfGVW0UpSlALOFgzt08q3AoQzFSy0v
X-Google-Smtp-Source: ABdhPJwUn7Urbx/hoTKHd4Gm1w2sqP4k6F6w3WvA7z3RQJFoKSEECvvFxhUKtO2/WV5p22MlP6XbgwIJ7XBZoOMCa4UnI10osKWZ
MIME-Version: 1.0
X-Received: by 2002:a92:d3d0:: with SMTP id c16mr7623005ilh.181.1592392454048;
 Wed, 17 Jun 2020 04:14:14 -0700 (PDT)
Date:   Wed, 17 Jun 2020 04:14:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009111c005a845c2bc@google.com>
Subject: net-next test error: KASAN: use-after-free Write in afs_wake_up_async_call
From:   syzbot <syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    69119673 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=151b62f1100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8ad29058cb749bc
dashboard link: https://syzkaller.appspot.com/bug?extid=d3eccef36ddbd02713e9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d3eccef36ddbd02713e9@syzkaller.appspotmail.com

tipc: TX() has been purged, node left!
==================================================================
BUG: KASAN: use-after-free in afs_wake_up_async_call+0x6aa/0x770 fs/afs/rxrpc.c:707
Write of size 1 at addr ffff8880946c39e4 by task kworker/u4:1/21

CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x413 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 afs_wake_up_async_call+0x6aa/0x770 fs/afs/rxrpc.c:707
 rxrpc_notify_socket+0x1db/0x5d0 net/rxrpc/recvmsg.c:40
 __rxrpc_set_call_completion.part.0+0x172/0x410 net/rxrpc/recvmsg.c:76
 __rxrpc_call_completed net/rxrpc/recvmsg.c:112 [inline]
 rxrpc_call_completed+0xca/0xf0 net/rxrpc/recvmsg.c:111
 rxrpc_discard_prealloc+0x781/0xab0 net/rxrpc/call_accept.c:233
 rxrpc_listen+0x147/0x360 net/rxrpc/af_rxrpc.c:245
 afs_close_socket+0x95/0x320 fs/afs/rxrpc.c:110
 afs_net_exit+0x1bc/0x310 fs/afs/main.c:155
 ops_exit_list.isra.0+0xa8/0x150 net/core/net_namespace.c:186
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:603
 process_one_work+0x965/0x1690 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 6820:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc mm/kasan/common.c:494 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:467
 kmem_cache_alloc_trace+0x153/0x7d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 afs_alloc_call+0x55/0x630 fs/afs/rxrpc.c:141
 afs_charge_preallocation+0xe9/0x2d0 fs/afs/rxrpc.c:757
 afs_open_socket+0x292/0x360 fs/afs/rxrpc.c:92
 afs_net_init+0xa6c/0xe30 fs/afs/main.c:125
 ops_init+0xaf/0x420 net/core/net_namespace.c:151
 setup_net+0x2de/0x860 net/core/net_namespace.c:341
 copy_net_ns+0x293/0x590 net/core/net_namespace.c:482
 create_new_namespaces+0x3fb/0xb30 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xbd/0x1f0 kernel/nsproxy.c:231
 ksys_unshare+0x43d/0x8e0 kernel/fork.c:2983
 __do_sys_unshare kernel/fork.c:3051 [inline]
 __se_sys_unshare kernel/fork.c:3049 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3049
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 21:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 afs_put_call+0x585/0xa40 fs/afs/rxrpc.c:190
 rxrpc_discard_prealloc+0x764/0xab0 net/rxrpc/call_accept.c:230
 rxrpc_listen+0x147/0x360 net/rxrpc/af_rxrpc.c:245
 afs_close_socket+0x95/0x320 fs/afs/rxrpc.c:110
 afs_net_exit+0x1bc/0x310 fs/afs/main.c:155
 ops_exit_list.isra.0+0xa8/0x150 net/core/net_namespace.c:186
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:603
 process_one_work+0x965/0x1690 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff8880946c3800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 484 bytes inside of
 1024-byte region [ffff8880946c3800, ffff8880946c3c00)
The buggy address belongs to the page:
page:ffffea000251b0c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002546508 ffffea00024fa248 ffff8880aa000c40
raw: 0000000000000000 ffff8880946c3000 0000000100000002 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880946c3880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880946c3900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880946c3980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff8880946c3a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880946c3a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
