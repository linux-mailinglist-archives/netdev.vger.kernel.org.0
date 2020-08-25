Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A456E2511DC
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 08:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgHYGDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 02:03:25 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:55632 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgHYGDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 02:03:21 -0400
Received: by mail-il1-f200.google.com with SMTP id q17so8362510ile.22
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 23:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GAX+WxcApQwVoEYjf2jsuHhuf7Di/Qgb3L44fflSXGk=;
        b=LQ0adiVFSSVMUy+hCqSRlL7ULzDrpWQhF7cfdT2K3agmd660BkADXYSzWeZ/TJcy+X
         /FnrimI0Cg+jhb5H2Xj/QuJcq+JzLjQ+tXbME14naHOHFHq39kk9wE79emtWN6quYy6P
         oW8V8QwKaSkaA5yRDrkUErVbu5nNOycJ0YekbnXaXGQ/6erAQu39wh3nJYfTdppxWL3N
         DoKbtg+gSIzycWafp4tFn3adAU2WyE7ZV9MeofcQLKgVWuTnzRUChtXaoBjldBxG5Eqq
         gP400XzMJ6kJnBWPeNvv7wpXZGxJqKmMZm/d7LoWh7OxPl46FVeCWY78Fw3utErcvdy/
         hCzg==
X-Gm-Message-State: AOAM531GfDBZ53K1ATifeXOuQbqM/3G+rp0lifpf3EB676FcXTOB+5yo
        M38cuxWOnV8eyjt+uLCnmfCR0bxmOWCic8mwxOuyfwMqYbIp
X-Google-Smtp-Source: ABdhPJzFN34e3DSn3VN8wzM63LFWTJJ1GMkIAe4bvEKKfPpQ4QfvOPx9A1oBIe451yYPTNGhn1Akh9XuDttG/3qBmkcAg1cI22HY
MIME-Version: 1.0
X-Received: by 2002:a92:ad12:: with SMTP id w18mr7339682ilh.218.1598335399868;
 Mon, 24 Aug 2020 23:03:19 -0700 (PDT)
Date:   Mon, 24 Aug 2020 23:03:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bdc03705adad758d@google.com>
Subject: KASAN: use-after-free Read in cgroup_path_ns
From:   syzbot <syzbot+9b1ff7be974a403aa4cd@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, hannes@cmpxchg.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    da2968ff Merge tag 'pci-v5.9-fixes-1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=159763ce900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb68b9e8a8cc842f
dashboard link: https://syzkaller.appspot.com/bug?extid=9b1ff7be974a403aa4cd
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9b1ff7be974a403aa4cd@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cgroup_path_ns_locked kernel/cgroup/cgroup.c:2220 [inline]
BUG: KASAN: use-after-free in cgroup_path_ns+0x76/0x100 kernel/cgroup/cgroup.c:2233
Read of size 8 at addr ffff8880978fc2b8 by task syz-executor.1/9658

CPU: 1 PID: 9658 Comm: syz-executor.1 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 print_address_description+0x66/0x620 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report+0x132/0x1d0 mm/kasan/report.c:530
 cgroup_path_ns_locked kernel/cgroup/cgroup.c:2220 [inline]
 cgroup_path_ns+0x76/0x100 kernel/cgroup/cgroup.c:2233
 proc_cpuset_show+0x5d4/0x660 kernel/cgroup/cpuset.c:3599
 proc_single_show+0xf6/0x180 fs/proc/base.c:775
 seq_read+0x41a/0xce0 fs/seq_file.c:208
 do_loop_readv_writev fs/read_write.c:734 [inline]
 do_iter_read+0x438/0x620 fs/read_write.c:955
 vfs_readv fs/read_write.c:1073 [inline]
 do_preadv+0x17b/0x290 fs/read_write.c:1165
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d4d9
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8a3ac8fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 0000000000025780 RCX: 000000000045d4d9
RDX: 00000000000003da RSI: 00000000200017c0 RDI: 0000000000000004
RBP: 000000000118cf90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007fffc35f745f R14: 00007f8a3ac909c0 R15: 000000000118cf4c

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc+0x100/0x130 mm/kasan/common.c:461
 kmem_cache_alloc_trace+0x1f6/0x2f0 mm/slab.c:3550
 kmalloc include/linux/slab.h:554 [inline]
 kzalloc include/linux/slab.h:666 [inline]
 cgroup1_root_to_use kernel/cgroup/cgroup-v1.c:1183 [inline]
 cgroup1_get_tree+0x747/0xae0 kernel/cgroup/cgroup-v1.c:1207
 vfs_get_tree+0x88/0x270 fs/super.c:1547
 do_new_mount fs/namespace.c:2875 [inline]
 path_mount+0x179d/0x29e0 fs/namespace.c:3192
 do_mount fs/namespace.c:3205 [inline]
 __do_sys_mount fs/namespace.c:3413 [inline]
 __se_sys_mount+0x126/0x180 fs/namespace.c:3390
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 8157:
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:56
 kasan_set_free_info+0x17/0x30 mm/kasan/generic.c:355
 __kasan_slab_free+0xdd/0x110 mm/kasan/common.c:422
 __cache_free mm/slab.c:3418 [inline]
 kfree+0x10a/0x220 mm/slab.c:3756
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Last call_rcu():
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:48
 kasan_record_aux_stack+0x7b/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x139/0x840 kernel/rcu/tree.c:2968
 queue_rcu_work+0x74/0x90 kernel/workqueue.c:1747
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Second to last call_rcu():
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:48
 kasan_record_aux_stack+0x7b/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2894 [inline]
 call_rcu+0x139/0x840 kernel/rcu/tree.c:2968
 __percpu_ref_switch_to_atomic lib/percpu-refcount.c:192 [inline]
 __percpu_ref_switch_mode+0x2c1/0x4f0 lib/percpu-refcount.c:237
 percpu_ref_kill_and_confirm+0x8f/0x130 lib/percpu-refcount.c:350
 percpu_ref_kill include/linux/percpu-refcount.h:136 [inline]
 cgroup_kill_sb+0xea/0x160 kernel/cgroup/cgroup.c:2152
 deactivate_locked_super+0xa7/0xf0 fs/super.c:335
 cleanup_mnt+0x432/0x4e0 fs/namespace.c:1118
 task_work_run+0x137/0x1c0 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:139 [inline]
 exit_to_user_mode_prepare+0xfa/0x1b0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x5e/0x1a0 kernel/entry/common.c:241
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff8880978fc000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 696 bytes inside of
 8192-byte region [ffff8880978fc000, ffff8880978fe000)
The buggy address belongs to the page:
page:00000000ab04f694 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x978fc
head:00000000ab04f694 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea00025e3108 ffffea00025e4808 ffff8880aa440a00
raw: 0000000000000000 ffff8880978fc000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880978fc180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880978fc200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880978fc280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff8880978fc300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880978fc380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
