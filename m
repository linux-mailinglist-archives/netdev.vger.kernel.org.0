Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC43705C3
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 07:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbhEAFvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 01:51:12 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36448 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbhEAFvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 01:51:11 -0400
Received: by mail-io1-f72.google.com with SMTP id t9-20020a5edd090000b0290406cd22dc3aso69501iop.3
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 22:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cxWeREtVAU3i0zIzuSe74eJXM2sfcCnf5zyODCYIsJc=;
        b=BTzoRAkA2HDVvkGSqJFilafJ+Yu5bwxB0Da6zQjWDXC/adfL3Ty+jEbBxsOLPvxz31
         fIVm0L4xcEf8yvbQR17/KBTJcJJSZoaopWvo5Skqut3NVIbBfsYiFygYE4akzs6PH6lW
         qFM9ljAHS2hGu/GRPQ3C956RONgeETKjxyHb01NbxjvxroRdnTsj4mzeHDkGlHySEIIf
         UvPZdhbS2DTcVBtdbgrLLNzaFxEpy3x4KQGl8V/1JYS1PCmrGeYm9UQmW0t9YyHAvMgl
         DdI5nO9/O6WfvocyT0VQJu2IfYGZTQ8psddXCy0GuS+z+DZj0rVbCfRhU63mVTYYHeKt
         9QbQ==
X-Gm-Message-State: AOAM530uzYQOBNYNpOJhBbCf3ujKTqbPXei7xxFfde9JYSzaKeELUBhf
        mxqU8J/dAxInJ2ShjZVmNWy+6Axqnos89VY3DWq5wuh5KmCg
X-Google-Smtp-Source: ABdhPJx26dVYAsMVWukIp8RbFgSyH1efBObI79uQ7y/Jpsn8TOWSsifONXOaUU3MBCT2WKiBvdfpkujE4Aet0HdODglIYYRDCArE
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1546:: with SMTP id h6mr6558154iow.32.1619848220924;
 Fri, 30 Apr 2021 22:50:20 -0700 (PDT)
Date:   Fri, 30 Apr 2021 22:50:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cc615405c13e4dfe@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nfc_llcp_put_ssap
From:   syzbot <syzbot+e4689b43d2ed2ed63611@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    18a3c5f7 Merge tag 'for_linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=161628b9d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9404cfa686df2c05
dashboard link: https://syzkaller.appspot.com/bug?extid=e4689b43d2ed2ed63611

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4689b43d2ed2ed63611@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __mutex_lock_common kernel/locking/mutex.c:931 [inline]
BUG: KASAN: use-after-free in __mutex_lock+0x1034/0x1120 kernel/locking/mutex.c:1096
Read of size 8 at addr ffff88801a106080 by task syz-executor.0/31485

CPU: 1 PID: 31485 Comm: syz-executor.0 Not tainted 5.12.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 __mutex_lock_common kernel/locking/mutex.c:931 [inline]
 __mutex_lock+0x1034/0x1120 kernel/locking/mutex.c:1096
 nfc_llcp_put_ssap+0x49/0x2e0 net/nfc/llcp_core.c:492
 llcp_sock_release+0x1d2/0x580 net/nfc/llcp_sock.c:626
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xbfc/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2781
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: Unable to access opcode bytes at RIP 0x4665cf.
RSP: 002b:00007fc68dddd218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 000000000056bf68 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf68
RBP: 000000000056bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf6c
R13: 00007fff0986484f R14: 00007fc68dddd300 R15: 0000000000022000

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x99/0xc0 mm/kasan/common.c:515
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 nfc_llcp_register_device+0x45/0x9d0 net/nfc/llcp_core.c:1572
 nfc_register_device+0x6d/0x360 net/nfc/core.c:1124
 nfcsim_device_new+0x345/0x5c1 drivers/nfc/nfcsim.c:408
 nfcsim_init+0x71/0x14d drivers/nfc/nfcsim.c:455
 do_one_initcall+0x103/0x650 init/main.c:1226
 do_initcall_level init/main.c:1299 [inline]
 do_initcalls init/main.c:1315 [inline]
 do_basic_setup init/main.c:1335 [inline]
 kernel_init_freeable+0x63e/0x6c2 init/main.c:1537
 kernel_init+0xd/0x1b8 init/main.c:1424
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Freed by task 31485:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xf5/0x130 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x92/0x210 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xe5/0x7f0 mm/slub.c:4213
 local_release net/nfc/llcp_core.c:175 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
 nfc_llcp_local_put+0x194/0x200 net/nfc/llcp_core.c:178
 llcp_sock_destruct+0x81/0x150 net/nfc/llcp_sock.c:950
 __sk_destruct+0x4b/0x900 net/core/sock.c:1795
 sk_destruct+0xbd/0xe0 net/core/sock.c:1839
 __sk_free+0xef/0x3d0 net/core/sock.c:1850
 sk_free+0x78/0xa0 net/core/sock.c:1861
 sock_put include/net/sock.h:1807 [inline]
 llcp_sock_release+0x3c9/0x580 net/nfc/llcp_sock.c:644
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xbfc/0x2a60 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2150 kernel/signal.c:2781
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:789
 handle_signal_work kernel/entry/common.c:147 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x148/0x250 kernel/entry/common.c:208
 __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801a106000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 128 bytes inside of
 2048-byte region [ffff88801a106000, ffff88801a106800)
The buggy address belongs to the page:
page:ffffea0000684000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1a100
head:ffffea0000684000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff888010442000
raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801a105f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88801a106000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801a106080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801a106100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801a106180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
