Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2CC20C05F
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgF0IuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 04:50:15 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43149 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgF0IuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 04:50:14 -0400
Received: by mail-il1-f197.google.com with SMTP id y13so8145701ila.10
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 01:50:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7wRV/GNx9fRFaea//hQ/IeTkGX118WBrKIiYqITZZYk=;
        b=G7SXo65OccFPhXo7bWtAmhjhwcGwJhvse829GbawSgXaEmFVAxpQswi4PPMTDObLQ/
         PbEHP8aOOpiOzeuSI0Mjubb5JuobA9NUE0v/yfEGyu28wzPdXQQuedbF6/z370Q0mmgG
         wrmWuSIwvjOWamxsN7uuPIxEtPE/HEKTxPe8xJApl/2OUK7sn3IM3PO8+IFL4gBKu5ss
         SQJYO1yE0MDUzz4x+pZBnS8OBM18IFmJ1WNx4ps3yfIVz6O2IjmVdMHForsEKaxU9Jgh
         fpKs/xHpDw+GAxkTOjE3JyYz+n54HePvWQucrc+ZAhs/80E+D+ozNGY8a/rU0xmTdQEy
         1MwA==
X-Gm-Message-State: AOAM530TKleb+LjHfsFfrnuVvWaHuGkmIJDdS8NQxpkDJbhpvH0Xzyna
        I6YXw0wOdEejCbQk91OwUNkF54GykdSX3/Mjp5RiuoVjtG1e
X-Google-Smtp-Source: ABdhPJw8vqU/XQzhRZz+PcMjQUl3b/xu4xW1QSTKQsv1uBiS0HT6LxH5b7PE8Y+1Hjgju4D7DYoE8b5V+k/rQgfTW0JrHZ24uS8t
MIME-Version: 1.0
X-Received: by 2002:a6b:14cc:: with SMTP id 195mr7406679iou.117.1593247813542;
 Sat, 27 Jun 2020 01:50:13 -0700 (PDT)
Date:   Sat, 27 Jun 2020 01:50:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f728fc05a90ce9c9@google.com>
Subject: KASAN: slab-out-of-bounds Read in qrtr_endpoint_post
From:   syzbot <syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1590a2e1 Merge tag 'acpi-5.8-rc3' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1142febb100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=b8fe393f999a291a9ea6
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b8fe393f999a291a9ea6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in qrtr_endpoint_post+0xf9b/0x1010 net/qrtr/qrtr.c:447
Read of size 4 at addr ffff88809df0ce44 by task syz-executor.2/29604

CPU: 1 PID: 29604 Comm: syz-executor.2 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 qrtr_endpoint_post+0xf9b/0x1010 net/qrtr/qrtr.c:447
 qrtr_tun_write_iter+0xf5/0x180 net/qrtr/tun.c:92
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:484
 __vfs_write+0xc9/0x100 fs/read_write.c:497
 vfs_write+0x268/0x5d0 fs/read_write.c:559
 ksys_write+0x12d/0x250 fs/read_write.c:612
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb19
Code: Bad RIP value.
RSP: 002b:00007ff63f2a7c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000050dd80 RCX: 000000000045cb19
RDX: 0000000000000004 RSI: 0000000020000140 RDI: 0000000000000005
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000d1e R14: 00000000004cf76d R15: 00007ff63f2a86d4

Allocated by task 29604:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x17a/0x340 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 qrtr_tun_write_iter+0x8a/0x180 net/qrtr/tun.c:83
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write+0x422/0x650 fs/read_write.c:484
 __vfs_write+0xc9/0x100 fs/read_write.c:497
 vfs_write+0x268/0x5d0 fs/read_write.c:559
 ksys_write+0x12d/0x250 fs/read_write.c:612
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 24714:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 kvm_destroy_vm_debugfs arch/x86/kvm/../../../virt/kvm/kvm_main.c:628 [inline]
 kvm_destroy_vm+0x158/0xbe0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:801
 kvm_put_kvm arch/x86/kvm/../../../virt/kvm/kvm_main.c:843 [inline]
 kvm_vcpu_release+0xc2/0x110 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2979
 __fput+0x33c/0x880 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:123
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:216 [inline]
 __prepare_exit_to_usermode+0x1e9/0x1f0 arch/x86/entry/common.c:246
 do_syscall_64+0x6c/0xe0 arch/x86/entry/common.c:368
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff88809df0ce40
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 4 bytes inside of
 32-byte region [ffff88809df0ce40, ffff88809df0ce60)
The buggy address belongs to the page:
page:ffffea000277c300 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88809df0cfc1
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027c0a88 ffffea00027b7c08 ffff8880aa0001c0
raw: ffff88809df0cfc1 ffff88809df0c000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809df0cd00: 00 01 fc fc fc fc fc fc 00 01 fc fc fc fc fc fc
 ffff88809df0cd80: 00 fc fc fc fc fc fc fc 06 fc fc fc fc fc fc fc
>ffff88809df0ce00: fb fb fb fb fc fc fc fc 04 fc fc fc fc fc fc fc
                                           ^
 ffff88809df0ce80: 00 01 fc fc fc fc fc fc fb fb fb fb fc fc fc fc
 ffff88809df0cf00: fb fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
