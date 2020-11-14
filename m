Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E772B2CDD
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 12:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgKNLSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 06:18:22 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:52382 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgKNLSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 06:18:21 -0500
Received: by mail-il1-f198.google.com with SMTP id o18so7843332ilg.19
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 03:18:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XLFjuOzkpRz0MRI7aBUzdwd+f7wbRtuKznG+mWegf8M=;
        b=j9haeIs4SsRON8pGAzhNpVLhgEdc5KHjvHMNlmiXFOjVZ3jrHcoGbJoZqi6qNIxl+l
         TljLBVJcV0KnxUR5PpNN4oNxFF1pWNlAvsMQ82uJgDMfaoPjKyHRYIF3VETmh9ipbtdM
         Opy1WjYIWePhpEe8xBMC0+N/LtXxazSptOvSAaTPW0OWqjBX237g6xKi94bedCIOKRns
         B/PXL19vsE9EAzZ6VOhQ7Lm90Q8Tw1DV7PE0/6edcfS5mTful2FB7r53qExtd7HyxFNF
         quDftsRbW4mLevasa8lhEyalctLte6zE8wq7fNjpby4e29IJlTMXZEhYjWPtgdt0LOXg
         +ixw==
X-Gm-Message-State: AOAM530/PBamcT4ZwJJy5vf4mEN2V9z/ogMIQK+stY22wuh6hciuRkg7
        JEGeWHpBx6Tmgm/pylCdR/QK87H7EazzU9Qh2nkVBDML3iyk
X-Google-Smtp-Source: ABdhPJx3UjrCFkLhpXkA+sN3PvHLNJ7F1DYLJbAnJrQtnVsV/ju74Ea6OMILYfZfJGuPzsSFBwu99c7greuNtrmzeFmxrM3+X9Au
MIME-Version: 1.0
X-Received: by 2002:a92:ba8c:: with SMTP id t12mr2925557ill.243.1605352698729;
 Sat, 14 Nov 2020 03:18:18 -0800 (PST)
Date:   Sat, 14 Nov 2020 03:18:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000058dc4205b40f4dbf@google.com>
Subject: KASAN: use-after-free Read in blk_update_request
From:   syzbot <syzbot+a3f809f70c0f239cda46@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    407ab579 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1532ba76500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37bf5609aacce0b6
dashboard link: https://syzkaller.appspot.com/bug?extid=a3f809f70c0f239cda46
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a3f809f70c0f239cda46@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x98/0x6250 kernel/locking/lockdep.c:4701
Read of size 8 at addr ffff8880119c1068 by task ksoftirqd/1/16

CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:118
 print_address_description+0x6c/0x660 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report+0x136/0x1e0 mm/kasan/report.c:562
 __lock_acquire+0x98/0x6250 kernel/locking/lockdep.c:4701
 lock_acquire+0x114/0x5e0 kernel/locking/lockdep.c:5436
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x73/0xa0 kernel/locking/spinlock.c:159
 __wake_up_common_lock kernel/sched/wait.c:122 [inline]
 __wake_up+0xb8/0x140 kernel/sched/wait.c:142
 req_bio_endio block/blk-core.c:263 [inline]
 blk_update_request+0x7b7/0x1510 block/blk-core.c:1467
 blk_mq_end_request+0x39/0x70 block/blk-mq.c:562
 blk_done_softirq+0x2fd/0x380 block/blk-mq.c:586
 __do_softirq+0x307/0x6be kernel/softirq.c:298
 run_ksoftirqd+0x63/0xa0 kernel/softirq.c:653
 smpboot_thread_fn+0x572/0x970 kernel/smpboot.c:165
 kthread+0x36b/0x390 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Allocated by task 32733:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x111/0x140 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x14b/0x250 mm/slub.c:2918
 kmalloc include/linux/slab.h:552 [inline]
 lbmLogInit fs/jfs/jfs_logmgr.c:1829 [inline]
 lmLogInit+0x26f/0x1750 fs/jfs/jfs_logmgr.c:1278
 open_inline_log fs/jfs/jfs_logmgr.c:1183 [inline]
 lmLogOpen+0x4a9/0xe50 fs/jfs/jfs_logmgr.c:1077
 jfs_mount_rw+0x92/0x4a0 fs/jfs/jfs_mount.c:259
 jfs_fill_super+0x592/0x9a0 fs/jfs/super.c:571
 mount_bdev+0x24f/0x360 fs/super.c:1419
 legacy_get_tree+0xea/0x180 fs/fs_context.c:592
 vfs_get_tree+0x88/0x270 fs/super.c:1549
 do_new_mount fs/namespace.c:2875 [inline]
 path_mount+0x17b4/0x2a20 fs/namespace.c:3205
 do_mount fs/namespace.c:3218 [inline]
 __do_sys_mount fs/namespace.c:3426 [inline]
 __se_sys_mount+0x28c/0x320 fs/namespace.c:3403
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 32733:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0x108/0x140 mm/kasan/common.c:422
 slab_free_hook mm/slub.c:1544 [inline]
 slab_free_freelist_hook+0xd6/0x1a0 mm/slub.c:1577
 slab_free mm/slub.c:3142 [inline]
 kfree+0xd1/0x280 mm/slub.c:4124
 lbmLogShutdown fs/jfs/jfs_logmgr.c:1872 [inline]
 lmLogInit+0x1195/0x1750 fs/jfs/jfs_logmgr.c:1423
 open_inline_log fs/jfs/jfs_logmgr.c:1183 [inline]
 lmLogOpen+0x4a9/0xe50 fs/jfs/jfs_logmgr.c:1077
 jfs_mount_rw+0x92/0x4a0 fs/jfs/jfs_mount.c:259
 jfs_fill_super+0x592/0x9a0 fs/jfs/super.c:571
 mount_bdev+0x24f/0x360 fs/super.c:1419
 legacy_get_tree+0xea/0x180 fs/fs_context.c:592
 vfs_get_tree+0x88/0x270 fs/super.c:1549
 do_new_mount fs/namespace.c:2875 [inline]
 path_mount+0x17b4/0x2a20 fs/namespace.c:3205
 do_mount fs/namespace.c:3218 [inline]
 __do_sys_mount fs/namespace.c:3426 [inline]
 __se_sys_mount+0x28c/0x320 fs/namespace.c:3403
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Last call_rcu():
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:48
 kasan_record_aux_stack+0xc7/0x100 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2953 [inline]
 call_rcu+0x10f/0x820 kernel/rcu/tree.c:3027
 inetdev_destroy net/ipv4/devinet.c:325 [inline]
 inetdev_event+0x730/0x14a0 net/ipv4/devinet.c:1599
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2035 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2047 [inline]
 call_netdevice_notifiers net/core/dev.c:2061 [inline]
 rollback_registered_many+0xeb8/0x16c0 net/core/dev.c:9422
 rollback_registered net/core/dev.c:9467 [inline]
 unregister_netdevice_queue+0x2f3/0x4b0 net/core/dev.c:10607
 unregister_netdevice include/linux/netdevice.h:2824 [inline]
 __tun_detach+0x646/0x1d40 drivers/net/tun.c:673
 tun_detach drivers/net/tun.c:690 [inline]
 tun_chr_close+0xed/0x130 drivers/net/tun.c:3390
 __fput+0x34f/0x7b0 fs/file_table.c:281
 task_work_run+0x137/0x1c0 kernel/task_work.c:151
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:164 [inline]
 exit_to_user_mode_prepare+0xe4/0x170 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x4a/0x170 kernel/entry/common.c:266
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880119c1000
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 104 bytes inside of
 192-byte region [ffff8880119c1000, ffff8880119c10c0)
The buggy address belongs to the page:
page:00000000fe180338 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x119c1
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea000044d6c0 0000000600000006 ffff888010441500
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880119c0f00: fc fc fc fc 00 00 00 00 00 00 00 fc fc fc fc fb
 ffff8880119c0f80: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
>ffff8880119c1000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                          ^
 ffff8880119c1080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff8880119c1100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
