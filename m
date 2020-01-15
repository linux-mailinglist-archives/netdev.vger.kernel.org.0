Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FD313B978
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgAOGVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 01:21:21 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:38524 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgAOGVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:21:14 -0500
Received: by mail-il1-f200.google.com with SMTP id i67so12541114ilf.5
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 22:21:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qrXYY2LE2Rdw3gtOF6VNzDJWkE2RPUWohxrM5XuTNOI=;
        b=sda+CfFAuSU11ZgU1fsR8LZ9NUEJG3DOkXFVWEv2ujyDJNi2yMg9VIuW3n/G8Ma3LE
         XWSxPP27G3reGCFLVtnCSsvD+ekup9Uz7yBQq8raR43624I5XnzV6mNNeGC7lzSLDgQ2
         Zj8lATOmb8FXBW4RKB9/YceeLVDQWB34913Tgnm382Qm4V/srkfNL1jmgoR7yxCbhCM/
         +MqeQ3mQUvBiFVOyG/un0wMAYXycPoj5KOyrMvytj+lIP0pUw4yhjSxRTxEtCBvkKf39
         hLgyMU4On4Ype6Xls6WIf+o+A8CIJ7Y0aHFnNsiFEm1UPhu4ZNmMZ4sG6BP1k+zBx2wi
         JPMQ==
X-Gm-Message-State: APjAAAWUVcfocZVik2Ql29CV5toWmQQSzNnKOkpGOWfgz+XxHKVfzdMN
        OvMUbyiUkW9B70z+rU311HZ1gEASSlCYVF+yPWutOgkoOHu3
X-Google-Smtp-Source: APXvYqyzSpBMuZCUa3F2tQNatNZUtWtUtZ+tPB62j/DgeMCkUt58DKMa8GL/FrNRKMWqBnHCrN3zhbUaq8CQPepr5r0rI6IVj1Tu
MIME-Version: 1.0
X-Received: by 2002:a5e:9507:: with SMTP id r7mr19749309ioj.152.1579069272630;
 Tue, 14 Jan 2020 22:21:12 -0800 (PST)
Date:   Tue, 14 Jan 2020 22:21:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012309d059c27b724@google.com>
Subject: KASAN: use-after-free Write in hci_sock_bind
From:   syzbot <syzbot+eba992608adf3d796bcc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6c09d7db Add linux-next specific files for 20200110
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=163269e1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7dc7ab9739654fbe
dashboard link: https://syzkaller.appspot.com/bug?extid=eba992608adf3d796bcc
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+eba992608adf3d796bcc@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __atomic_check_write  
include/asm-generic/atomic-instrumented.h:33 [inline]
BUG: KASAN: use-after-free in atomic_inc  
include/asm-generic/atomic-instrumented.h:253 [inline]
BUG: KASAN: use-after-free in hci_sock_bind+0x642/0x12d0  
net/bluetooth/hci_sock.c:1239
Write of size 4 at addr ffff888061255068 by task syz-executor.5/24646

CPU: 0 PID: 24646 Comm: syz-executor.5 Not tainted  
5.5.0-rc5-next-20200110-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:641
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_write+0x14/0x20 mm/kasan/common.c:101
  __atomic_check_write include/asm-generic/atomic-instrumented.h:33 [inline]
  atomic_inc include/asm-generic/atomic-instrumented.h:253 [inline]
  hci_sock_bind+0x642/0x12d0 net/bluetooth/hci_sock.c:1239
  __sys_bind+0x239/0x290 net/socket.c:1662
  __do_sys_bind net/socket.c:1673 [inline]
  __se_sys_bind net/socket.c:1671 [inline]
  __x64_sys_bind+0x73/0xb0 net/socket.c:1671
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff26c106c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007ff26c106c90 RCX: 000000000045af49
RDX: 0000000000000006 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff26c1076d4
R13: 00000000004c1323 R14: 00000000004d6000 R15: 0000000000000006

Allocated by task 24646:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  __kasan_kmalloc mm/kasan/common.c:515 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
  kmalloc include/linux/slab.h:555 [inline]
  kzalloc include/linux/slab.h:669 [inline]
  hci_alloc_dev+0x43/0x1dc0 net/bluetooth/hci_core.c:3182
  __vhci_create_device+0x101/0x5d0 drivers/bluetooth/hci_vhci.c:99
  vhci_create_device drivers/bluetooth/hci_vhci.c:148 [inline]
  vhci_get_user drivers/bluetooth/hci_vhci.c:204 [inline]
  vhci_write+0x2d0/0x470 drivers/bluetooth/hci_vhci.c:284
  call_write_iter include/linux/fs.h:1901 [inline]
  new_sync_write+0x4d3/0x770 fs/read_write.c:483
  __vfs_write+0xe1/0x110 fs/read_write.c:496
  vfs_write+0x268/0x5d0 fs/read_write.c:558
  ksys_write+0x14f/0x290 fs/read_write.c:611
  __do_sys_write fs/read_write.c:623 [inline]
  __se_sys_write fs/read_write.c:620 [inline]
  __x64_sys_write+0x73/0xb0 fs/read_write.c:620
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 24642:
  save_stack+0x23/0x90 mm/kasan/common.c:72
  set_track mm/kasan/common.c:80 [inline]
  kasan_set_free_info mm/kasan/common.c:337 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:476
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:485
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  bt_host_release+0x19/0x30 net/bluetooth/hci_sysfs.c:86
  device_release+0x7a/0x210 drivers/base/core.c:1358
  kobject_cleanup lib/kobject.c:693 [inline]
  kobject_release lib/kobject.c:722 [inline]
  kref_put include/linux/kref.h:65 [inline]
  kobject_put+0x1ff/0x2e0 lib/kobject.c:739
  put_device+0x20/0x30 drivers/base/core.c:2586
  hci_free_dev+0x19/0x20 net/bluetooth/hci_core.c:3277
  vhci_release+0x7e/0xf0 drivers/bluetooth/hci_vhci.c:340
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888061254000
  which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4200 bytes inside of
  8192-byte region [ffff888061254000, ffff888061256000)
The buggy address belongs to the page:
page:ffffea0001849500 refcount:1 mapcount:0 mapping:ffff8880aa4021c0  
index:0x0 compound_mapcount: 0
raw: 00fffe0000010200 ffffea0001346b08 ffffea000248f008 ffff8880aa4021c0
raw: 0000000000000000 ffff888061254000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888061254f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888061254f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff888061255000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                           ^
  ffff888061255080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888061255100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
