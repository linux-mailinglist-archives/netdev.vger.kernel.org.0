Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AEF175303
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 06:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgCBFOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 00:14:12 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:43316 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCBFOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 00:14:12 -0500
Received: by mail-io1-f69.google.com with SMTP id v15so7408117iol.10
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 21:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d5TDYiCB8FCnmpfMdQVEeihvaw8+/3NOIOW0zOPd9cU=;
        b=Xbsyyg2k4GUX0g1RlX8AUmbxVm8XjbBgbMuCrKfEAz8IBifCpOEvOH4rHygfR7iDc9
         m17xrQ22y4ge3bOXRBWoT2TaJVtXMSOAz/KKCenDdOJQ24AWp5Djov1blvCXeost8a4S
         b/yqHfT1gBuwcS1vxhWG+Fw6jTrHkq1Tf4v8FYTBsGJGRSpxY2k8NeiieIsea9YzpiYd
         E2avs+mT721g/U2MU/CC6gjkByEK8rVeaHu1E59Fy7M4dPtHsib7fasm+ouzPJakvSjg
         sT+o44kbG3c9IoujIayVmBLyZet458lmhZOZkkMIMgY8DCZcFX+di0F2CHdAtzyJDPlr
         LkVg==
X-Gm-Message-State: APjAAAWy0lhGnevGyuv9+3vKkHcd7EzSU+LcARcran6V3R8AhfMaFWGY
        EJnnTEHTdduvq+GsVNns9dfnFbti8ixBG+0CQdJnt1X94Zlt
X-Google-Smtp-Source: APXvYqxkvW+UUE04fne78UhhAYQRMY24tE3YewHFQ/mZ4hM3iN2h3W/Rm0T1M9+9yfXfjMvuwSGHYMZLjeRb/9kd5cEwpm3dOyuN
MIME-Version: 1.0
X-Received: by 2002:a05:6638:18c:: with SMTP id a12mr10545128jaq.84.1583126051151;
 Sun, 01 Mar 2020 21:14:11 -0800 (PST)
Date:   Sun, 01 Mar 2020 21:14:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e9e518059fd84189@google.com>
Subject: KASAN: use-after-free Write in hci_sock_bind (2)
From:   syzbot <syzbot+04e804c8c2224b6a9497@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    f8788d86 Linux 5.6-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120cfd29e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=04e804c8c2224b6a9497
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+04e804c8c2224b6a9497@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in atomic_inc include/asm-generic/atomic-instrumented.h:239 [inline]
BUG: KASAN: use-after-free in hci_sock_bind+0x642/0x12d0 net/bluetooth/hci_sock.c:1250
Write of size 4 at addr ffff888040ed9078 by task syz-executor.2/21693

CPU: 1 PID: 21693 Comm: syz-executor.2 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 __kasan_check_write+0x14/0x20 mm/kasan/common.c:101
 atomic_inc include/asm-generic/atomic-instrumented.h:239 [inline]
 hci_sock_bind+0x642/0x12d0 net/bluetooth/hci_sock.c:1250
 __sys_bind+0x239/0x290 net/socket.c:1662
 __do_sys_bind net/socket.c:1673 [inline]
 __se_sys_bind net/socket.c:1671 [inline]
 __x64_sys_bind+0x73/0xb0 net/socket.c:1671
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c449
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fef96e6bc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00007fef96e6c6d4 RCX: 000000000045c449
RDX: 0000000000000006 RSI: 00000000200007c0 RDI: 0000000000000006
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000002c R14: 00000000004c28c9 R15: 000000000076bf2c

Allocated by task 21692:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:488
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:529
 kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 hci_alloc_dev+0x43/0x1e20 net/bluetooth/hci_core.c:3249
 __vhci_create_device+0x101/0x5d0 drivers/bluetooth/hci_vhci.c:99
 vhci_create_device drivers/bluetooth/hci_vhci.c:148 [inline]
 vhci_get_user drivers/bluetooth/hci_vhci.c:205 [inline]
 vhci_write+0x2d0/0x470 drivers/bluetooth/hci_vhci.c:285
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

Freed by task 21688:
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
 hci_free_dev+0x19/0x20 net/bluetooth/hci_core.c:3345
 vhci_release+0x7e/0xf0 drivers/bluetooth/hci_vhci.c:341
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:164
 prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
 do_syscall_64+0x676/0x790 arch/x86/entry/common.c:304
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff888040ed8000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 4216 bytes inside of
 8192-byte region [ffff888040ed8000, ffff888040eda000)
The buggy address belongs to the page:
page:ffffea000103b600 refcount:1 mapcount:0 mapping:ffff8880aa4021c0 index:0x0 compound_mapcount: 0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0000fe6b08 ffffea0000fb5408 ffff8880aa4021c0
raw: 0000000000000000 ffff888040ed8000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888040ed8f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888040ed8f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888040ed9000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                                ^
 ffff888040ed9080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888040ed9100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
