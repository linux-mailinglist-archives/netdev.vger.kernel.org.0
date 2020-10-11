Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63E128A62E
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 09:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJKHm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 03:42:26 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:42964 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgJKHmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 03:42:25 -0400
Received: by mail-il1-f207.google.com with SMTP id 18so10267149ilt.9
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 00:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7PbN+9cIdIGVhAv/w+zEBq3PXtiMVM6PcDD03VAAMBg=;
        b=RGmyGnEGTLKQRNnDWkKR2qiT/u8q9rLDVVjQrW3IZlEK5PZzdZ40nU7/kvxCu/AIIv
         ErjWDQOso4KfiKSu7Sjk2ts0ARX2MDHq/o0AfY/EUVSu8t6MsOb2kUU/al7Zv76Dmw4P
         84H3VXjgBNsM7mCueWX4g7GPb+v1WUIlNq8nHH8X6JFMBMta+Eic9qprph3QPBlL0aH3
         E05np+nBS3Xi8pG5WVNdaP3qB8erJK/6mrdUctKw8SuRO0e/qG+0o1tj0v4jylw9sAOa
         4iI/+JdRYj5ROa64KRaryKliigCUaTSZzLPvYMNyjeeTEJmayo4To7WPf/MVm9wNMJVf
         QZxg==
X-Gm-Message-State: AOAM533sOQBleF+22EbNVGmXLcGSH67W+nO4IFA22skP1KdGLaYysQPo
        cuKR7jZzLyiLaC2liagTS9s4KW9YAIv6HhE8dKtfcEjO2UFr
X-Google-Smtp-Source: ABdhPJyfm97kuiDrvOvrC4MEWpb5dQ4Z3AEAoLbN5ZLjqzf9moIGtcQnvOdZaAHkHdu05MBr3uc0j9ba3ktrZfUJIOWxbuzyioC4
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d45:: with SMTP id h5mr6241432ilj.307.1602402144037;
 Sun, 11 Oct 2020 00:42:24 -0700 (PDT)
Date:   Sun, 11 Oct 2020 00:42:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009530b805b1605237@google.com>
Subject: KASAN: use-after-free Read in sco_chan_del
From:   syzbot <syzbot+1df6a63e69a359c8b517@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a804ab08 Add linux-next specific files for 20201006
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1073270b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26c1b4cc4a62ccb
dashboard link: https://syzkaller.appspot.com/bug?extid=1df6a63e69a359c8b517
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1df6a63e69a359c8b517@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in hci_conn_drop include/net/bluetooth/hci_core.h:1145 [inline]
BUG: KASAN: use-after-free in hci_conn_drop include/net/bluetooth/hci_core.h:1115 [inline]
BUG: KASAN: use-after-free in sco_chan_del+0x400/0x430 net/bluetooth/sco.c:149
Read of size 8 at addr ffff88804d29c918 by task syz-executor.2/27575

CPU: 0 PID: 27575 Comm: syz-executor.2 Not tainted 5.9.0-rc8-next-20201006-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fb lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 hci_conn_drop include/net/bluetooth/hci_core.h:1145 [inline]
 hci_conn_drop include/net/bluetooth/hci_core.h:1115 [inline]
 sco_chan_del+0x400/0x430 net/bluetooth/sco.c:149
 __sco_sock_close+0x16e/0x5b0 net/bluetooth/sco.c:434
 sco_sock_close net/bluetooth/sco.c:448 [inline]
 sco_sock_release+0x69/0x290 net/bluetooth/sco.c:1059
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 get_signal+0xd89/0x1f00 kernel/signal.c:2561
 arch_do_signal+0x82/0x2470 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x194/0x1f0 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de29
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fabeda51c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: fffffffffffffffc RBX: 0000000000002200 RCX: 000000000045de29
RDX: 0000000000000008 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 000000000118c158 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118c124
R13: 00007ffdb3c9529f R14: 00007fabeda529c0 R15: 000000000118c124

Allocated by task 27575:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x1a0/0x480 mm/slab.c:3552
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 hci_conn_add+0x53/0x1330 net/bluetooth/hci_conn.c:525
 hci_connect_sco+0x356/0x860 net/bluetooth/hci_conn.c:1283
 sco_connect net/bluetooth/sco.c:241 [inline]
 sco_sock_connect+0x308/0x980 net/bluetooth/sco.c:588
 __sys_connect_file+0x155/0x1a0 net/socket.c:1852
 __sys_connect+0x161/0x190 net/socket.c:1869
 __do_sys_connect net/socket.c:1879 [inline]
 __se_sys_connect net/socket.c:1876 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1876
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 26665:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
 kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
 __cache_free mm/slab.c:3420 [inline]
 kfree+0x10e/0x2a0 mm/slab.c:3758
 device_release+0x9f/0x240 drivers/base/core.c:1808
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x171/0x270 lib/kobject.c:753
 put_device+0x1b/0x30 drivers/base/core.c:3037
 hci_conn_del+0x27e/0x6a0 net/bluetooth/hci_conn.c:645
 hci_conn_hash_flush+0x189/0x220 net/bluetooth/hci_conn.c:1558
 hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1770
 hci_unregister_dev+0x214/0xe90 net/bluetooth/hci_core.c:3827
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb23/0x2930 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x428/0x1f00 kernel/signal.c:2757
 arch_do_signal+0x82/0x2470 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x194/0x1f0 kernel/entry/common.c:192
 syscall_exit_to_user_mode+0x7a/0x2c0 kernel/entry/common.c:267
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88804d29c000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2328 bytes inside of
 4096-byte region [ffff88804d29c000, ffff88804d29d000)
The buggy address belongs to the page:
page:0000000084eedba7 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4d29c
head:0000000084eedba7 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00012af708 ffffea0001001308 ffff8880aa040900
raw: 0000000000000000 ffff88804d29c000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88804d29c800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804d29c880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88804d29c900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88804d29c980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804d29ca00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
