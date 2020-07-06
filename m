Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C264215A6E
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 17:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729517AbgGFPNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 11:13:13 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:34084 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729253AbgGFPMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 11:12:24 -0400
Received: by mail-il1-f197.google.com with SMTP id y3so16113984ily.1
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 08:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=U+a/7dG+Jm649g4Q7s1bTBlfdKiN+DjRc+s0w5ipG5w=;
        b=gZQTIY5Fyf1XjpBDR9e8M/zJ8WZjCSZl9oANjkKGBFUT7/3ZIBAs9cYyrlX2nu1+5T
         WzYpdBZIrRsCEN/PZyGnmyGZPvm5ooWVPKEeZnmFSNATfAtbFwwAspYGzOg9TGUxYi1w
         SHe0grq2LqSxQffxnFPGfUVSzdmej9IvNQiuzd0vxMDRKr8nwWF5pa6Un2qdYTNqs5bV
         b+MgbsRhrPJDD+bXxdBiBXa101aYSO5LuF/balA+d/hMq0Mxgn1m2ZNTDxNEUoB2qQyq
         PYalBwRqsZuGR4WhuOMBNsv8fvKxldZcS9fAGo2MuvnU8CQzkJuTKlLUmbgti+vCLVTU
         X0Kg==
X-Gm-Message-State: AOAM531H32ln+3gjiOKtI5hdJq1ZydKUmVj329cdhDXPIQ8lQeAOwZje
        qfa1vVd15F6xUfkr+HAStDpkHrVK09GAt9RY0oQY8ZixJK9B
X-Google-Smtp-Source: ABdhPJyjsxk8AZywl0NzsgSUN9e5JtN8xMaRid4jPezb+sCR8yOWHcNFyz89YMXJn7Iq4YnXiGjmgRti8+K0LiL5gh7ouQORXEi5
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:961:: with SMTP id q1mr28424101ilt.94.1594048342301;
 Mon, 06 Jul 2020 08:12:22 -0700 (PDT)
Date:   Mon, 06 Jul 2020 08:12:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032a1a405a9c74d19@google.com>
Subject: INFO: task hung in rtnl_lock
From:   syzbot <syzbot+634e86850449c71ddeb1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    24085f70 Merge tag 'trace-v5.7-rc4' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1436b178100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=efdde85c3af536b5
dashboard link: https://syzkaller.appspot.com/bug?extid=634e86850449c71ddeb1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+634e86850449c71ddeb1@syzkaller.appspotmail.com

INFO: task syz-executor.2:1813 blocked for more than 143 seconds.
      Not tainted 5.7.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D29600  1813   7229 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4217
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 __might_fault mm/memory.c:4814 [inline]
 __might_fault+0x11f/0x1d0 mm/memory.c:4799
 mutex_trylock+0x2c0/0x2c0 kernel/locking/mutex.c:126
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 __might_fault mm/memory.c:4814 [inline]
 __might_fault+0x190/0x1d0 mm/memory.c:4799
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 rtnl_lock+0x5/0x20 net/core/rtnetlink.c:72
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 compat_ifr_data_ioctl+0x160/0x160 net/socket.c:3295
 __sanitizer_cov_trace_switch+0x45/0x70 kernel/kcov.c:310
 ioctl_fioasync fs/ioctl.c:601 [inline]
 do_vfs_ioctl+0x50c/0x1360 fs/ioctl.c:704
 ioctl_file_clone+0x180/0x180 fs/ioctl.c:253
 sock_ioctl+0x3ec/0x790 net/socket.c:1204
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 ksys_dup3+0x3c0/0x3c0 include/linux/compiler.h:199
 __do_sys_futex kernel/futex.c:3869 [inline]
 __se_sys_futex kernel/futex.c:3837 [inline]
 __x64_sys_futex+0x380/0x4f0 kernel/futex.c:3837
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:771
 __do_sys_ioctl fs/ioctl.c:780 [inline]
 __se_sys_ioctl fs/ioctl.c:778 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:778
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
INFO: task syz-executor.2:1820 blocked for more than 144 seconds.
      Not tainted 5.7.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D28408  1820   7229 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4217
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5451
 mutex_trylock+0x2c0/0x2c0 kernel/locking/mutex.c:126
 find_held_lock+0x2d/0x110 kernel/locking/lockdep.c:4458
 rcu_read_unlock include/linux/rcupdate.h:651 [inline]
 rtnetlink_rcv_msg+0x3c3/0xad0 net/core/rtnetlink.c:5449
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5451
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5451
 rtnl_bridge_getlink+0x870/0x870 net/core/rtnetlink.c:4654
 netdev_core_pick_tx+0x2e0/0x2e0 net/core/dev.c:3939
 __copy_skb_header+0x270/0x5b0 net/core/skbuff.c:941
 skb_splice_bits+0x1a0/0x1a0 net/core/skbuff.c:2445
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 slab_alloc mm/slab.c:3313 [inline]
 kmem_cache_alloc+0x261/0x740 mm/slab.c:3484
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 rtnl_bridge_getlink+0x870/0x870 net/core/rtnetlink.c:4654
 netlink_ack+0xa10/0xa10 net/netlink/af_netlink.c:2426
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_attachskb+0x810/0x810 net/netlink/af_netlink.c:1235
 _copy_from_iter_full+0x25c/0x870 lib/iov_iter.c:800
 __phys_addr_symbol+0x2c/0x70 arch/x86/mm/physaddr.c:42
 overlaps mm/usercopy.c:110 [inline]
 check_kernel_text_object mm/usercopy.c:142 [inline]
 __check_object_size mm/usercopy.c:289 [inline]
 __check_object_size+0x171/0x437 mm/usercopy.c:256
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 aa_af_perm+0x260/0x260 security/apparmor/net.c:141
 netlink_unicast+0x740/0x740 net/netlink/af_netlink.c:82
 netlink_unicast+0x740/0x740 net/netlink/af_netlink.c:82
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 kernel_sendmsg+0x50/0x50 net/socket.c:692
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 sendmsg_copy_msghdr+0x70/0x70 net/socket.c:2391
 rcu_lock_release include/linux/rcupdate.h:213 [inline]
 rcu_read_unlock include/linux/rcupdate.h:655 [inline]
 __fget_files+0x32f/0x500 fs/file.c:734
 ksys_dup3+0x3c0/0x3c0 include/linux/compiler.h:199
 __fget_light fs/file.c:804 [inline]
 __fget_light+0x20e/0x270 fs/file.c:790
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 __sys_sendmsg_sock+0xb0/0xb0 net/socket.c:2429
 __do_sys_futex kernel/futex.c:3869 [inline]
 __se_sys_futex kernel/futex.c:3837 [inline]
 __x64_sys_futex+0x380/0x4f0 kernel/futex.c:3837
 trace_hardirqs_off_caller+0x55/0x230 kernel/trace/trace_preemptirq.c:73
 do_syscall_64+0x21/0x7d0 arch/x86/entry/common.c:288
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
INFO: task syz-executor.2:1821 blocked for more than 145 seconds.
      Not tainted 5.7.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D29600  1821   7229 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4217
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 __might_fault mm/memory.c:4814 [inline]
 __might_fault+0x11f/0x1d0 mm/memory.c:4799
 mutex_trylock+0x2c0/0x2c0 kernel/locking/mutex.c:126
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 __might_fault mm/memory.c:4814 [inline]
 __might_fault+0x190/0x1d0 mm/memory.c:4799
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 rtnl_lock+0x5/0x20 net/core/rtnetlink.c:72
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 compat_ifr_data_ioctl+0x160/0x160 net/socket.c:3295
 __sanitizer_cov_trace_switch+0x45/0x70 kernel/kcov.c:310
 ioctl_fioasync fs/ioctl.c:601 [inline]
 do_vfs_ioctl+0x50c/0x1360 fs/ioctl.c:704
 ioctl_file_clone+0x180/0x180 fs/ioctl.c:253
 sock_ioctl+0x3ec/0x790 net/socket.c:1204
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 ksys_dup3+0x3c0/0x3c0 include/linux/compiler.h:199
 __do_sys_futex kernel/futex.c:3869 [inline]
 __se_sys_futex kernel/futex.c:3837 [inline]
 __x64_sys_futex+0x380/0x4f0 kernel/futex.c:3837
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:771
 __do_sys_ioctl fs/ioctl.c:780 [inline]
 __se_sys_ioctl fs/ioctl.c:778 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:778
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
INFO: task syz-executor.3:1811 blocked for more than 145 seconds.
      Not tainted 5.7.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D29304  1811   7322 0x00004004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4217
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 mutex_trylock+0x2c0/0x2c0 kernel/locking/mutex.c:126
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 __might_fault mm/memory.c:4814 [inline]
 __might_fault+0x190/0x1d0 mm/memory.c:4799
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 rtnl_lock+0x5/0x20 net/core/rtnetlink.c:72
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 compat_ifr_data_ioctl+0x160/0x160 net/socket.c:3295
 __sanitizer_cov_trace_switch+0x45/0x70 kernel/kcov.c:310
 ioctl_fioasync fs/ioctl.c:601 [inline]
 do_vfs_ioctl+0x50c/0x1360 fs/ioctl.c:704
 ioctl_file_clone+0x180/0x180 fs/ioctl.c:253
 sock_ioctl+0x3ec/0x790 net/socket.c:1204
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 ksys_dup3+0x3c0/0x3c0 include/linux/compiler.h:199
 __do_sys_futex kernel/futex.c:3869 [inline]
 __se_sys_futex kernel/futex.c:3837 [inline]
 __x64_sys_futex+0x380/0x4f0 kernel/futex.c:3837
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:771
 __do_sys_ioctl fs/ioctl.c:780 [inline]
 __se_sys_ioctl fs/ioctl.c:778 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:778
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
INFO: task syz-executor.3:1819 blocked for more than 146 seconds.
      Not tainted 5.7.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D29600  1819   7322 0x00000004
Call Trace:
 context_switch kernel/sched/core.c:3367 [inline]
 __schedule+0x937/0x1ff0 kernel/sched/core.c:4083
 __sched_text_start+0x8/0x8
 schedule+0xd0/0x2a0 kernel/sched/core.c:4158
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4217
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 __might_fault mm/memory.c:4814 [inline]
 __might_fault+0x11f/0x1d0 mm/memory.c:4799
 mutex_trylock+0x2c0/0x2c0 kernel/locking/mutex.c:126
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 __might_fault mm/memory.c:4814 [inline]
 __might_fault+0x190/0x1d0 mm/memory.c:4799
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 rtnl_lock+0x5/0x20 net/core/rtnetlink.c:72
 sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
 compat_ifr_data_ioctl+0x160/0x160 net/socket.c:3295
 __sanitizer_cov_trace_switch+0x45/0x70 kernel/kcov.c:310
 ioctl_fioasync fs/ioctl.c:601 [inline]
 do_vfs_ioctl+0x50c/0x1360 fs/ioctl.c:704
 ioctl_file_clone+0x180/0x180 fs/ioctl.c:253
 sock_ioctl+0x3ec/0x790 net/socket.c:1204
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 ksys_dup3+0x3c0/0x3c0 include/linux/compiler.h:199
 dlci_ioctl_set+0x30/0x30 net/socket.c:1043
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:771
 __do_sys_ioctl fs/ioctl.c:780 [inline]
 __se_sys_ioctl fs/ioctl.c:778 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:778
 __trace_hardirqs_on_caller kernel/locking/lockdep.c:3657 [inline]
 lockdep_hardirqs_on+0x463/0x620 kernel/locking/lockdep.c:3702
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Showing all locks held in the system:
1 lock held by khungtaskd/1142:
 #0: ffffffff899bea80 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:5754
1 lock held by in:imklog/6733:
 #0: ffff8880a847c670 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:826
3 locks held by kworker/0:16/28541:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc90008ecfdc0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 #2: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:242
3 locks held by kworker/0:18/28543:
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff8880aa026d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc90008edfdc0 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 #2: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
2 locks held by syz-executor.2/1810:
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5451
 #1: ffffffff899c2ae0 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #1: ffffffff899c2ae0 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x501/0x620 kernel/rcu/tree_exp.h:856
1 lock held by syz-executor.2/1813:
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
1 lock held by syz-executor.2/1820:
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3f9/0xad0 net/core/rtnetlink.c:5451
1 lock held by syz-executor.2/1821:
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
1 lock held by syz-executor.3/1811:
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
1 lock held by syz-executor.3/1819:
 #0: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: sock_do_ioctl+0x24e/0x2f0 net/socket.c:1066
3 locks held by kworker/0:0/1861:
 #0: ffff8880a8c20d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:226 [inline]
 #0: ffff8880a8c20d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a8c20d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff8880a8c20d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff8880a8c20d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff8880a8c20d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff8880a8c20d38 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc90016dcfdc0 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 #2: ffffffff8a582e68 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4584
3 locks held by (d-rfkill)/1923:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1142 Comm: khungtaskd Not tainted 5.7.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
 lapic_can_unplug_cpu.cold+0x3b/0x3b
 nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
 watchdog+0xa8c/0x1010 kernel/hung_task.c:289
 reset_hung_task_detector+0x30/0x30 kernel/hung_task.c:243
 kthread+0x388/0x470 kernel/kthread.c:268
 kthread_mod_delayed_work+0x1a0/0x1a0 kernel/kthread.c:1090
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 161 Comm: kworker/u4:4 Not tainted 5.7.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_nc_worker
RIP: 0010:debug_lockdep_rcu_enabled.part.0+0x26/0x50 kernel/rcu/update.c:276
Code: 00 00 00 00 48 b8 00 00 00 00 00 fc ff df 53 65 48 8b 1c 25 00 1f 02 00 48 8d bb c4 08 00 00 48 89 fa 48 c1 ea 03 0f b6 14 02 <48> 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 0f 8b 93 c4 08 00
RSP: 0018:ffffc900015a7bf0 EFLAGS: 00000807
RAX: dffffc0000000000 RBX: ffff8880a88203c0 RCX: 1ffffffff1513102
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff8880a8820c84
RBP: 0000000000000000 R08: ffff8880a88203c0 R09: fffffbfff1512ac1
R10: ffffffff8a895607 R11: fffffbfff1512ac0 R12: ffffffff899bea80
R13: ffffffff87b5f976 R14: dffffc0000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000028e10ac0 CR3: 000000009fff9000 CR4: 00000000001406f0
DR0: 0000000020000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 trace_lock_release include/trace/events/lock.h:58 [inline]
 lock_release+0x59e/0x800 kernel/locking/lockdep.c:4951
 process_one_work+0x878/0x16a0 kernel/workqueue.c:2243
 lock_downgrade+0x840/0x840 kernel/locking/lockdep.c:4579
 rcu_lock_release include/linux/rcupdate.h:213 [inline]
 rcu_read_unlock include/linux/rcupdate.h:655 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:411 [inline]
 batadv_nc_worker+0x21c/0x760 net/batman-adv/network-coding.c:718
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268
 lock_release+0x800/0x800 kernel/locking/lockdep.c:4689
 pwq_dec_nr_in_flight+0x310/0x310 kernel/workqueue.c:1198
 rwlock_bug.part.0+0x90/0x90 include/linux/sched.h:1329
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 process_one_work+0x16a0/0x16a0 kernel/workqueue.c:2273
 kthread+0x388/0x470 kernel/kthread.c:268
 kthread_mod_delayed_work+0x1a0/0x1a0 kernel/kthread.c:1090
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
