Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B3421E0A6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 21:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGMTYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 15:24:20 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56984 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgGMTYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 15:24:18 -0400
Received: by mail-io1-f72.google.com with SMTP id a10so8660746ioc.23
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 12:24:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=V7Mn4NNEM06LP8L1Vm2er27FmjQm0mFjhBQQAteUK84=;
        b=ndSs3GadECVXH0Lh9gwl8HEB+gKcxMNdPd1BlpEe/avJ3n/2saxvqkp/GjDpHeP1fP
         ldfjdqz2ZFW2ykVCBgbgNSKcMdkx9Hpg/FM3MyDVZPaKs+eV8K2esnWJiU/vXyQ66xp/
         fsApqCWdrYzFEkDCCPrDFvVotE0P2Q6oqubeaOL+YeTDkKcOJCFQ+BxKTvCgHL7yqgG1
         DJELeFkAAB3PkL+Axcz9fK9If+Zp/Bm96tAMmm3t/ddZ6StRqPXteLYrBD1KbrMkY33M
         yHwtXusxf04hge+vkaFeT1045RZSa9n8fDH4wK6nDyYT4MB0hfZME5P8FsJzXiKxKu75
         AIuw==
X-Gm-Message-State: AOAM530SjZGr93aJQ6N7yCVQeLG5pDwJxprWnD+AjzGM18zi/uY4B3HJ
        +PQ8OX/BMfW+dduMGNCjqTsQjM1QF0FJIr6KizepqUeS6YZ4
X-Google-Smtp-Source: ABdhPJzT+lWNu0VlZTNXdCmcr7/UEHNw/1fGt8Rft2zNTuf/VQoMNItCVH2ngRVbMDeKgr92CMYbVi+QiLb4ZNodGgTLo9o3VbTt
MIME-Version: 1.0
X-Received: by 2002:a6b:7107:: with SMTP id q7mr1318729iog.86.1594668257740;
 Mon, 13 Jul 2020 12:24:17 -0700 (PDT)
Date:   Mon, 13 Jul 2020 12:24:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000098e7505aa57a3d5@google.com>
Subject: KASAN: slab-out-of-bounds Read in hci_inquiry_result_with_rssi_evt
From:   syzbot <syzbot+3a430af182785b4c7360@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a581387e Merge tag 'io_uring-5.8-2020-07-10' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=173dd65d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=3a430af182785b4c7360
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12badf8f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1000d6db100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3a430af182785b4c7360@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in memcpy include/linux/string.h:406 [inline]
BUG: KASAN: slab-out-of-bounds in bacpy include/net/bluetooth/bluetooth.h:274 [inline]
BUG: KASAN: slab-out-of-bounds in hci_inquiry_result_with_rssi_evt+0x230/0x6b0 net/bluetooth/hci_event.c:4169
Read of size 6 at addr ffff88809dbc85fb by task kworker/u5:0/1521

CPU: 1 PID: 1521 Comm: kworker/u5:0 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 memcpy+0x20/0x60 mm/kasan/common.c:105
 memcpy include/linux/string.h:406 [inline]
 bacpy include/net/bluetooth/bluetooth.h:274 [inline]
 hci_inquiry_result_with_rssi_evt+0x230/0x6b0 net/bluetooth/hci_event.c:4169
 hci_event_packet+0x1e8c/0x86f5 net/bluetooth/hci_event.c:6103
 hci_rx_work+0x22e/0xb10 net/bluetooth/hci_core.c:4705
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Allocated by task 6905:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x550 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1083 [inline]
 bt_skb_alloc include/net/bluetooth/bluetooth.h:377 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:165 [inline]
 vhci_write+0xbd/0x450 drivers/bluetooth/hci_vhci.c:285
 call_write_iter include/linux/fs.h:1908 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:503
 vfs_write+0x59d/0x6b0 fs/read_write.c:578
 ksys_write+0x12d/0x250 fs/read_write.c:631
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 4921:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 ep_eventpoll_release+0x41/0x60 fs/eventpoll.c:864
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:239 [inline]
 __prepare_exit_to_usermode+0x1e9/0x1f0 arch/x86/entry/common.c:269
 do_syscall_64+0x6c/0xe0 arch/x86/entry/common.c:393
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88809dbc8400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 507 bytes inside of
 512-byte region [ffff88809dbc8400, ffff88809dbc8600)
The buggy address belongs to the page:
page:ffffea000276f200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000288bb48 ffffea0002877488 ffff8880aa000a80
raw: 0000000000000000 ffff88809dbc8000 0000000100000004 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809dbc8500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809dbc8580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88809dbc8600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88809dbc8680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809dbc8700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
