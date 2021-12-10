Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF8A470E1F
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 23:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344658AbhLJWqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 17:46:01 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:49773 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238523AbhLJWp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 17:45:59 -0500
Received: by mail-io1-f72.google.com with SMTP id g16-20020a05660203d000b005f7b3b0642eso835063iov.16
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 14:42:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=+nLEIx/oSwuRrhbldXoQ8zxIyK/FT2+DYaTSxHxfl4w=;
        b=vQ+rhR+JCPN+QWGuo2Rc1q3V1PrV4bjkgUsLhbxRLJBEyidm9NiOGQnOS+zfoAAdU+
         w9e2le11pnEUNoYnLBHcUQtSJo4ykTV/lAfXo6FbBBNEqAgMLwg/9wbhyzfgbL5LmXtl
         CLjcC9BQX8GtjgXdDmWAsSxQUzafhUnMQg/yh7mSaIJQ9GsowHjtxJTpl3vdM370X/ln
         sLRCdFJHVoJ4vEUE5PlWvzYOvGGjR3lUcxNEt93AL5GsdlokWYCtqfbxswhiC4KK5AmR
         yZzvtuZ6GNdx2If/e/A18IeiUiS1I9w54e2NnN0eEV8MwglDddjXzh9Ezif1I+SeQSon
         dZfw==
X-Gm-Message-State: AOAM530DTmlg5DkDkJguSxu/dH7n3VzZC7Q1LvXfVXO93wktVA3CG2tg
        2mKT1HtQ8kZ98Y3tzLpiwx+U8KFpeGAdHxGSBg704u0nfFGY
X-Google-Smtp-Source: ABdhPJwIa9UDzWvKdGI/Va64F8ruFz6MU6mHLMTXuj4eFyAyFlmTOaDP4tyqV7JHk/sj6Q9N+D7BGv9wZqPB/PG0Ba/em1ZKibJn
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4113:: with SMTP id ay19mr21117300jab.149.1639176142756;
 Fri, 10 Dec 2021 14:42:22 -0800 (PST)
Date:   Fri, 10 Dec 2021 14:42:22 -0800
In-Reply-To: <000000000000e8f8f505d0e479a5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6a03505d2d26fcd@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in remove_wait_queue (3)
From:   syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e5d75fc20b92 sh_eth: Use dev_err_probe() helper
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1540cdceb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=24fd48984584829b
dashboard link: https://syzkaller.appspot.com/bug?extid=cdb5dd11c97cc532efad
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15de00bab00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ad646db00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3d86/0x54a0 kernel/locking/lockdep.c:4897
Read of size 8 at addr ffff888015be3740 by task syz-executor161/3598

CPU: 1 PID: 3598 Comm: syz-executor161 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x320 mm/kasan/report.c:247
 __kasan_report mm/kasan/report.c:433 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:450
 __lock_acquire+0x3d86/0x54a0 kernel/locking/lockdep.c:4897
 lock_acquire kernel/locking/lockdep.c:5637 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5602
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 remove_wait_queue+0x1d/0x180 kernel/sched/wait.c:55
 ep_remove_wait_queue+0x88/0x1a0 fs/eventpoll.c:545
 ep_unregister_pollwait fs/eventpoll.c:561 [inline]
 ep_remove+0x106/0x9c0 fs/eventpoll.c:690
 eventpoll_release_file+0xe1/0x130 fs/eventpoll.c:923
 eventpoll_release include/linux/eventpoll.h:53 [inline]
 __fput+0x87b/0x9f0 fs/file_table.c:271
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3167c0def3
Code: c7 c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb ba 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
RSP: 002b:00007ffddef2e488 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 00007f3167c0def3
RDX: 000000000000002f RSI: 0000000020001340 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000014 R09: 00007ffddef2e4b0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffddef2e4ac
R13: 00007ffddef2e4c0 R14: 00007ffddef2e500 R15: 0000000000000000
 </TASK>

Allocated by task 3598:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:590 [inline]
 psi_trigger_create.part.0+0x15e/0x7f0 kernel/sched/psi.c:1141
 cgroup_pressure_write+0x15d/0x6b0 kernel/cgroup/cgroup.c:3645
 cgroup_file_write+0x1ec/0x780 kernel/cgroup/cgroup.c:3852
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x12d/0x250 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3598:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1723 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1749
 slab_free mm/slub.c:3513 [inline]
 kfree+0xf6/0x560 mm/slub.c:4561
 cgroup_pressure_write+0x18d/0x6b0 kernel/cgroup/cgroup.c:3651
 cgroup_file_write+0x1ec/0x780 kernel/cgroup/cgroup.c:3852
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2162 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x12d/0x250 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888015be3700
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 64 bytes inside of
 192-byte region [ffff888015be3700, ffff888015be37c0)
The buggy address belongs to the page:
page:ffffea000056f8c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x15be3
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 0000000000000000 dead000000000001 ffff888010c41a00
raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 1, ts 1983850449, free_ts 0
 prep_new_page mm/page_alloc.c:2418 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4149
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5369
 alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2036
 alloc_pages+0x29f/0x300 mm/mempolicy.c:2186
 alloc_slab_page mm/slub.c:1793 [inline]
 allocate_slab mm/slub.c:1930 [inline]
 new_slab+0x32d/0x4a0 mm/slub.c:1993
 ___slab_alloc+0x918/0xfe0 mm/slub.c:3022
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3109
 slab_alloc_node mm/slub.c:3200 [inline]
 slab_alloc mm/slub.c:3242 [inline]
 kmem_cache_alloc_trace+0x289/0x2c0 mm/slub.c:3259
 kmalloc include/linux/slab.h:590 [inline]
 kzalloc include/linux/slab.h:724 [inline]
 call_usermodehelper_setup+0x97/0x340 kernel/umh.c:365
 kobject_uevent_env+0xf73/0x1650 lib/kobject_uevent.c:614
 version_sysfs_builtin kernel/params.c:878 [inline]
 param_sysfs_init+0x146/0x43b kernel/params.c:969
 do_one_initcall+0x103/0x650 init/main.c:1297
 do_initcall_level init/main.c:1370 [inline]
 do_initcalls init/main.c:1386 [inline]
 do_basic_setup init/main.c:1405 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1610
 kernel_init+0x1a/0x1d0 init/main.c:1499
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888015be3600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888015be3680: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>ffff888015be3700: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888015be3780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888015be3800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================

