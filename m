Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5908452DE1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 10:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhKPJ0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 04:26:23 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56155 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhKPJ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 04:26:17 -0500
Received: by mail-io1-f69.google.com with SMTP id y74-20020a6bc84d000000b005e700290338so12307278iof.22
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 01:23:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uC7AWDcvfTfXFe8xNqJbFueuOQA6vkHzPFdtRiX4guA=;
        b=ts/bkSIH9FrwsBPiilxTwsMiTgsU8FdMdMX2EO6uLW7H6HrfvRD4GN+EzRuv1dgzI7
         E2SLNm9KFWa/bItTs+eb/5BSBTTGANlhgQ3D92DufjUXSyFMABsI7Ey07vleQcy1Y/f/
         FhcruxaaX28nJIKb7WMXMagb7ZocMTJ0RUjLtpg0oBxidC14HYRAj2dWpBlpQqpLe0hV
         FIwu2iQ9Q0sXL8PPAXaJyuQ1rIJcYWG0mhNSs9MumhicG1MZka+bORJ5HvLKKQu6t8TX
         nlxBVw/GIuy7MtZsH3aj7Y3mvhVBJuyhYsPOBcjO8nirYFsPHSreO+mxz6bUyUVQWFPm
         /pQg==
X-Gm-Message-State: AOAM532co+6CWgTI3pEnyJXjVZiGavF0SCjsOwwQVqm2oH0bWNMkmQmV
        vEesZ0JqMRL5OwK+lItXOZA3SeMPXu4f2Tgx37Jq8KAJMUSL
X-Google-Smtp-Source: ABdhPJzL++KdbZQd4ra287jGiy2IvztMUKRiLKkTrEGbLfm4F0BH1ly4zJomWzjKpnLpdAQtIJswunF7ZCTPndEwkXWLRIktZJ2z
MIME-Version: 1.0
X-Received: by 2002:a92:4b06:: with SMTP id m6mr3417501ilg.123.1637054599983;
 Tue, 16 Nov 2021 01:23:19 -0800 (PST)
Date:   Tue, 16 Nov 2021 01:23:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e8f8f505d0e479a5@google.com>
Subject: [syzbot] KASAN: use-after-free Read in remove_wait_queue (3)
From:   syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cc0356d6a02e Merge tag 'x86_core_for_v5.16_rc1' of git://g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=102e7ce6b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5d447cdc3ae81d9
dashboard link: https://syzkaller.appspot.com/bug?extid=cdb5dd11c97cc532efad
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x3d86/0x54a0 kernel/locking/lockdep.c:4885
Read of size 8 at addr ffff888032563540 by task syz-executor.2/8869

CPU: 1 PID: 8869 Comm: syz-executor.2 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __lock_acquire+0x3d86/0x54a0 kernel/locking/lockdep.c:4885
 lock_acquire kernel/locking/lockdep.c:5625 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x39/0x50 kernel/locking/spinlock.c:162
 remove_wait_queue+0x1d/0x180 kernel/sched/wait.c:55
 ep_remove_wait_queue+0x88/0x1a0 fs/eventpoll.c:545
 ep_unregister_pollwait fs/eventpoll.c:561 [inline]
 ep_free+0x18a/0x390 fs/eventpoll.c:756
 ep_eventpoll_release+0x41/0x60 fs/eventpoll.c:788
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbaa/0x2a20 kernel/exit.c:826
 do_group_exit+0x125/0x310 kernel/exit.c:923
 get_signal+0x47d/0x21d0 kernel/signal.c:2855
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8b46801ae9
Code: Unable to access opcode bytes at RIP 0x7f8b46801abf.
RSP: 002b:00007f8b43d77218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000000 RBX: 00007f8b46914f68 RCX: 00007f8b46801ae9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f8b46914f68
RBP: 00007f8b46914f60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8b46914f6c
R13: 00007fff0432647f R14: 00007f8b43d77300 R15: 0000000000022000
 </TASK>

Allocated by task 8869:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0xa4/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:591 [inline]
 psi_trigger_create.part.0+0x15e/0x7f0 kernel/sched/psi.c:1141
 cgroup_pressure_write+0x15d/0x6b0 kernel/cgroup/cgroup.c:3622
 cgroup_file_write+0x1ec/0x780 kernel/cgroup/cgroup.c:3829
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2161 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x12d/0x250 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 8869:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xff/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1726
 slab_free mm/slub.c:3492 [inline]
 kfree+0xf3/0x550 mm/slub.c:4552
 cgroup_pressure_write+0x18d/0x6b0 kernel/cgroup/cgroup.c:3628
 cgroup_file_write+0x1ec/0x780 kernel/cgroup/cgroup.c:3829
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2161 [inline]
 new_sync_write+0x429/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x12d/0x250 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1353
 __queue_work+0x5ca/0xee0 kernel/workqueue.c:1519
 queue_work_on+0xee/0x110 kernel/workqueue.c:1546
 queue_work include/linux/workqueue.h:501 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:435
 kobject_uevent_env+0xf8f/0x1650 lib/kobject_uevent.c:618
 rx_queue_add_kobject net/core/net-sysfs.c:1069 [inline]
 net_rx_queue_update_kobjects+0xf8/0x500 net/core/net-sysfs.c:1109
 register_queue_kobjects net/core/net-sysfs.c:1766 [inline]
 netdev_register_kobject+0x275/0x430 net/core/net-sysfs.c:2014
 register_netdevice+0xd31/0x1500 net/core/dev.c:10330
 __ip_tunnel_create+0x398/0x5c0 net/ipv4/ip_tunnel.c:267
 ip_tunnel_init_net+0x2e4/0x9d0 net/ipv4/ip_tunnel.c:1070
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x40f/0xa30 net/core/net_namespace.c:326
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3076
 __do_sys_unshare kernel/fork.c:3150 [inline]
 __se_sys_unshare kernel/fork.c:3148 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3148
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_record_aux_stack+0xe9/0x110 mm/kasan/generic.c:348
 insert_work+0x48/0x370 kernel/workqueue.c:1353
 __queue_work+0x5ca/0xee0 kernel/workqueue.c:1519
 queue_work_on+0xee/0x110 kernel/workqueue.c:1546
 queue_work include/linux/workqueue.h:501 [inline]
 call_usermodehelper_exec+0x1f0/0x4c0 kernel/umh.c:435
 kobject_uevent_env+0xf8f/0x1650 lib/kobject_uevent.c:618
 rx_queue_add_kobject net/core/net-sysfs.c:1069 [inline]
 net_rx_queue_update_kobjects+0xf8/0x500 net/core/net-sysfs.c:1109
 register_queue_kobjects net/core/net-sysfs.c:1766 [inline]
 netdev_register_kobject+0x275/0x430 net/core/net-sysfs.c:2014
 register_netdevice+0xd31/0x1500 net/core/dev.c:10330
 __ip_tunnel_create+0x398/0x5c0 net/ipv4/ip_tunnel.c:267
 ip_tunnel_init_net+0x2e4/0x9d0 net/ipv4/ip_tunnel.c:1070
 vti_init_net+0x2a/0x370 net/ipv4/ip_vti.c:504
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x40f/0xa30 net/core/net_namespace.c:326
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3076
 __do_sys_unshare kernel/fork.c:3150 [inline]
 __se_sys_unshare kernel/fork.c:3148 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3148
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888032563500
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 64 bytes inside of
 192-byte region [ffff888032563500, ffff8880325635c0)
The buggy address belongs to the page:
page:ffffea0000c958c0 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x32563
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0001ef2780 0000000600000002 ffff888010c41a00
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x112cc0(GFP_USER|__GFP_NOWARN|__GFP_NORETRY), pid 3310, ts 611411618313, free_ts 611397869806
 prep_new_page mm/page_alloc.c:2426 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4155
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5381
 alloc_pages+0x1a7/0x300 mm/mempolicy.c:2191
 alloc_slab_page mm/slub.c:1770 [inline]
 allocate_slab mm/slub.c:1907 [inline]
 new_slab+0x319/0x490 mm/slub.c:1970
 ___slab_alloc+0x921/0xfe0 mm/slub.c:3001
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3088
 slab_alloc_node mm/slub.c:3179 [inline]
 slab_alloc mm/slub.c:3221 [inline]
 __kmalloc_track_caller+0x2ef/0x310 mm/slub.c:4916
 __do_krealloc mm/slab_common.c:1208 [inline]
 krealloc+0x87/0xf0 mm/slab_common.c:1241
 push_jmp_history kernel/bpf/verifier.c:2278 [inline]
 is_state_visited kernel/bpf/verifier.c:10967 [inline]
 do_check kernel/bpf/verifier.c:11107 [inline]
 do_check_common+0x3521/0xcf50 kernel/bpf/verifier.c:13374
 do_check_main kernel/bpf/verifier.c:13437 [inline]
 bpf_check+0x87ca/0xbc90 kernel/bpf/verifier.c:14004
 bpf_prog_load+0xf4c/0x21e0 kernel/bpf/syscall.c:2329
 __sys_bpf+0x67e/0x5f00 kernel/bpf/syscall.c:4618
 __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1340 [inline]
 free_pcp_prepare+0x326/0x810 mm/page_alloc.c:1391
 free_unref_page_prepare mm/page_alloc.c:3317 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3396
 __vunmap+0x781/0xb70 mm/vmalloc.c:2621
 __vfree+0x3c/0xd0 mm/vmalloc.c:2669
 vfree+0x5a/0x90 mm/vmalloc.c:2700
 bpf_jit_free+0xbb/0x1c0
 bpf_prog_free_deferred+0x5c1/0x790 kernel/bpf/core.c:2292
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Memory state around the buggy address:
 ffff888032563400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888032563480: 04 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888032563500: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff888032563580: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888032563600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
