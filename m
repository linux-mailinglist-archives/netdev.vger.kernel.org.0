Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE582360636
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbhDOJvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:51:48 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:51821 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231791AbhDOJvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:51:46 -0400
Received: by mail-io1-f72.google.com with SMTP id e9-20020a6b73090000b02903df1a776a08so1287093ioh.18
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 02:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=EqN1UckagzqaK/lMFb2hZBOut15Lv2rEpOWueSBjV74=;
        b=WRag9gaigSAYYocUs/UutrdsJygbltyfCvHeWjdxXNxpvE31S/oK3en/oL040DDTue
         SIHP6PYWglSUAGVBLC4dkI8UeL8/tTQGGHgkRyBepYFSDmZ7MR14ltb8jffw0dIPshIu
         PNudfrm6+Qt/VRpOMlQLaBiUPjXjkxjjhIaOggt2FFCevAxtVo0veWagf6CquJaPfgr1
         zTnPqudrGiiW5kM8ixakIf3LJa14C/KuIGiY0sMEgsX1EM/hpctBhP0hCVpUt8CbHp5R
         /lVlkJKsO/nnuIW1N/AOcuoHPA0E0GTJOzbrwwxJqlDUhHD5Zl6r2vLL+Enc7G4SCxT8
         WHWQ==
X-Gm-Message-State: AOAM533+KAcyDLa3QUU1kWZHVtnH5vAoWcdgyF5UQpX3mq/yfqgJaJJb
        tOmObdkr0diF8c7d6RJ7dA94MW2kgJLtuCK23pI2fDdJ4W0L
X-Google-Smtp-Source: ABdhPJxJY1P/7Y6FgqkqCY2h7c8JAwgZOkwkWPl8yaeuUC7yW0iUd0km953GFODuWusTushRTW5GlKslCKCqHIv+GLNUgHjnojNp
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1152:: with SMTP id o18mr2120556ill.174.1618480283126;
 Thu, 15 Apr 2021 02:51:23 -0700 (PDT)
Date:   Thu, 15 Apr 2021 02:51:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a12d905bfffce52@google.com>
Subject: [syzbot] KASAN: use-after-free Write in nfc_llcp_local_put
From:   syzbot <syzbot+f1c3c57efec16353f881@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    50987bec Merge tag 'trace-v5.12-rc7' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15680319d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5591c832f889fd9
dashboard link: https://syzkaller.appspot.com/bug?extid=f1c3c57efec16353f881

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f1c3c57efec16353f881@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
BUG: KASAN: use-after-free in __refcount_sub_and_test include/linux/refcount.h:272 [inline]
BUG: KASAN: use-after-free in __refcount_dec_and_test include/linux/refcount.h:315 [inline]
BUG: KASAN: use-after-free in refcount_dec_and_test include/linux/refcount.h:333 [inline]
BUG: KASAN: use-after-free in kref_put include/linux/kref.h:64 [inline]
BUG: KASAN: use-after-free in nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
BUG: KASAN: use-after-free in nfc_llcp_local_put+0x30/0x200 net/nfc/llcp_core.c:178
Write of size 4 at addr ffff888015cc8018 by task syz-executor.2/9727

CPU: 1 PID: 9727 Comm: syz-executor.2 Not tainted 5.12.0-rc7-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2c6 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:416
 check_region_inline mm/kasan/generic.c:180 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
 __refcount_sub_and_test include/linux/refcount.h:272 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 kref_put include/linux/kref.h:64 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:183 [inline]
 nfc_llcp_local_put+0x30/0x200 net/nfc/llcp_core.c:178
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
RIP: 0033:0x466459
Code: Unable to access opcode bytes at RIP 0x46642f.
RSP: 002b:00007f6644f39218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 000000000056bf68 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000056bf68
RBP: 000000000056bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf6c
R13: 00007ffd102e94df R14: 00007f6644f39300 R15: 0000000000022000

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc mm/kasan/common.c:506 [inline]
 ____kasan_kmalloc mm/kasan/common.c:465 [inline]
 __kasan_kmalloc+0x96/0xc0 mm/kasan/common.c:515
 kasan_kmalloc include/linux/kasan.h:233 [inline]
 kmem_cache_alloc_trace+0x1f5/0x440 mm/slab.c:3570
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

Freed by task 9709:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
 ____kasan_slab_free mm/kasan/common.c:360 [inline]
 ____kasan_slab_free mm/kasan/common.c:325 [inline]
 __kasan_slab_free+0xc7/0x100 mm/kasan/common.c:367
 kasan_slab_free include/linux/kasan.h:199 [inline]
 __cache_free mm/slab.c:3440 [inline]
 kfree+0x104/0x2b0 mm/slab.c:3796
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

The buggy address belongs to the object at ffff888015cc8000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 24 bytes inside of
 2048-byte region [ffff888015cc8000, ffff888015cc8800)
The buggy address belongs to the page:
page:ffffea0000573200 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x15cc8
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea000057d4c8 ffffea0000559ec8 ffff888010840800
raw: 0000000000000000 ffff888015cc8000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888015cc7f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888015cc7f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888015cc8000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff888015cc8080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888015cc8100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
