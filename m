Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A04235ADB
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgHBUpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:45:22 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:56064 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbgHBUpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:45:21 -0400
Received: by mail-io1-f69.google.com with SMTP id k10so25175545ioh.22
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:45:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VIjViLF9vTXg5y9QTImEwwOAxUFJ5T2PWR5V15NAn6c=;
        b=Ifhe+r8jA6RgvE0HUsDRMy7h/jE6QllApL06Ex71nQYBWUMR22834m1BUjMRJs1EDN
         iHahO7GB1XYTWRZmkiJhqB2cZ+21blOQbfBo+gm/sw3vCDzVbECXcHyD/r/HlblDJQ2J
         BJtnAp67LVvwfUHCAHiNlCeeoZDl1MqUTEcGT3gsd0hx5FTWwUyvYFJfAOAf2sPexCZ6
         nWmGtn4GaeB/r+1D/3C27dKvGG1PDoHn2jJSmsUOJYSyk41EpTNEJLef/zHFAOp349wL
         J71Hy/1JNNnpaXlEvphoQvKpiQBHzQqWUwoMZL4Llftp3lWa4RiJLmn+yW547QemE9fU
         cbsQ==
X-Gm-Message-State: AOAM531jboY3KN6VIZMNNo+aVMoWKzQBwCyZEUivnNYPPLGgys/UbmOJ
        eRQuv3x7feXElLOegcu5XgLuJ7VKJgQavpi6DxzRGCh2wkyF
X-Google-Smtp-Source: ABdhPJwKE34lm1+CsRz/PxsW8nnNxqCCOnFZMSoCVSsP/yrqpddTlWmL55FBsziS5ULFyTw/8c62UfSpZlMcwGsLbjip5GkNpPlo
MIME-Version: 1.0
X-Received: by 2002:a92:5f17:: with SMTP id t23mr12897147ilb.62.1596401120044;
 Sun, 02 Aug 2020 13:45:20 -0700 (PDT)
Date:   Sun, 02 Aug 2020 13:45:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000adea7f05abeb19cf@google.com>
Subject: KASAN: use-after-free Read in hci_chan_del
From:   syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b8d570900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7ceea900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e5de04900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
==================================================================
BUG: KASAN: use-after-free in hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
Read of size 8 at addr ffff8880a9591f18 by task syz-executor081/6793

CPU: 0 PID: 6793 Comm: syz-executor081 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x5a0 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
 l2cap_conn_del+0x4c2/0x650 net/bluetooth/l2cap_core.c:1900
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
 hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1536
 hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1761
 hci_unregister_dev+0x16d/0x1590 net/bluetooth/hci_core.c:3606
 vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x2f0/0x750 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0x601/0x1f80 kernel/exit.c:805
 do_group_exit+0x161/0x2d0 kernel/exit.c:903
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
 __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x444fe8
Code: Bad RIP value.
RSP: 002b:00007ffe96e46e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000444fe8
RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
RBP: 00000000004ccdd0 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00007f5ee25cd700 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006e0200 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6821:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 hci_chan_create+0x9a/0x270 net/bluetooth/hci_conn.c:1692
 l2cap_conn_add+0x66/0xb00 net/bluetooth/l2cap_core.c:7699
 l2cap_connect_cfm+0xdb/0x12b0 net/bluetooth/l2cap_core.c:8097
 hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
 hci_remote_features_evt net/bluetooth/hci_event.c:3210 [inline]
 hci_event_packet+0x1164c/0x18260 net/bluetooth/hci_event.c:6061
 hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Freed by task 1530:
 save_stack mm/kasan/common.c:48 [inline]
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x220 mm/slab.c:3757
 hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4999 [inline]
 hci_event_packet+0x304e/0x18260 net/bluetooth/hci_event.c:6188
 hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff8880a9591f00
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 24 bytes inside of
 128-byte region [ffff8880a9591f00, ffff8880a9591f80)
The buggy address belongs to the page:
page:ffffea0002a56440 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a9591800
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea0002a5a648 ffffea00028a4a08 ffff8880aa400700
raw: ffff8880a9591800 ffff8880a9591000 000000010000000a 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a9591e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880a9591e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880a9591f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff8880a9591f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880a9592000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
