Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5267941FBDA
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhJBMvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 08:51:13 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:36447 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbhJBMvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 08:51:10 -0400
Received: by mail-io1-f72.google.com with SMTP id o19-20020a0566022e1300b005d66225622dso11370147iow.3
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 05:49:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PinhwAzQsD4e60t/GSjriMndrk9KDHu5H3U6pRF8Iss=;
        b=2AbQ+aWA3IeCCRyFCxpeI90dBlM+lwnjJp7Q+Q7t1rWoWp4/9El3AsYY0wpd2QZ3/T
         F0ENU8bS9nF068b6n8R03Sq6g0Fi+wnJOPZrT6obWXImz/t7MT+PejPjNFnlD+FrBlnD
         om4SSjJOpKakjHDgMbmh7QDoSZUdo5GeOkG7+szUCTdyTryct7Okx8ag5HnkvnvlBOtD
         Wkm4A6qtmBdz/hLrKT5R4bPfPdNwvnqQM0ZAyMS4OIK8+tfmzF8uDxDtOkLbNZck7Ywt
         adjikuUW2XfTjVeHCyK+VZr01pnN8zfjFTcL8t2gFVQCn45nd9iEcF8FBjLlMimKCEqa
         vloA==
X-Gm-Message-State: AOAM532Eglw+ZRis4q/qlCJ+hKT0XCFXZSzlliUR+t9Y23g4BYYptyE6
        PPuHee9fDhtYimjqN8RqCZPiw7avXF4aIiIwSnMRGFgAeQsK
X-Google-Smtp-Source: ABdhPJxsLkIcP6zokJgqo4rvJvQitCmGYQlHm4xyRxeuwvg810JHWYzqFr7byag2cgDrLC18X1AQ0xXQC+Heu0tBqMzLNfKlK+Zh
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b46:: with SMTP id f6mr2706947ilu.100.1633178964154;
 Sat, 02 Oct 2021 05:49:24 -0700 (PDT)
Date:   Sat, 02 Oct 2021 05:49:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000035e6905cd5e1c91@google.com>
Subject: [syzbot] INFO: task hung in reg_check_chans_work (3)
From:   syzbot <syzbot+7b4a6fc3e452c67173e0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a4e6f95a891a Merge tag 'pinctrl-v5.15-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102b4c03300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c76f0f4ac6e9f8d2
dashboard link: https://syzkaller.appspot.com/bug?extid=7b4a6fc3e452c67173e0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b4a6fc3e452c67173e0@syzkaller.appspotmail.com

INFO: task kworker/0:10:10115 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:10    state:D stack:26216 pid:10115 ppid:     2 flags:0x00004000
Workqueue: events_power_efficient reg_check_chans_work
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 reg_check_chans_work+0x83/0xe10 net/wireless/reg.c:2423
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
INFO: task syz-executor.0:17047 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:27152 pid:17047 ppid: 13518 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f36146d1709
RSP: 002b:00007f3611c48188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f36147d5f60 RCX: 00007f36146d1709
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00007f361472bcb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff97d291cf R14: 00007f3611c48300 R15: 0000000000022000
INFO: task syz-executor.4:17052 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:27216 pid:17052 ppid:  6665 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fb590d66709
RSP: 002b:00007fb58e2dd188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fb590e6af60 RCX: 00007fb590d66709
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00007fb590dc0cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd316687cf R14: 00007fb58e2dd300 R15: 0000000000022000
INFO: task syz-executor.5:17058 blocked for more than 144 seconds.
      Not tainted 5.15.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.5  state:D stack:28072 pid:17058 ppid:     1 flags:0x00000004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6287
 schedule+0xd3/0x270 kernel/sched/core.c:6366
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:729
 rtnl_lock net/core/rtnetlink.c:72 [inline]
 rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 __sys_sendto+0x21c/0x320 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8ff50a869c
RSP: 002b:00007fffcb4bf570 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f8ff6132320 RCX: 00007f8ff50a869c
RDX: 0000000000000028 RSI: 00007f8ff6132370 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007fffcb4bf5c4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
R13: 00007f8ff6132370 R14: 0000000000000003 R15: 0000000000000000

Showing all locks held in the system:
1 lock held by khungtaskd/27:
 #0: ffffffff8b97d420 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by in:imklog/6230:
 #0: ffff88801b8e9630 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:990
3 locks held by kworker/0:10/10115:
 #0: ffff888010c73d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c73d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c73d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c73d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c73d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c73d38 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc9000484fdb0 ((reg_check_chans).work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: reg_check_chans_work+0x83/0xe10 net/wireless/reg.c:2423
6 locks held by kworker/u4:7/10365:
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888140275938 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc9000770fdb0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0cee50 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb00 net/core/net_namespace.c:553
 #3: ffffffff8d10de08 (devlink_mutex){+.+.}-{3:3}, at: devlink_pernet_pre_exit+0x84/0x3b0 net/core/devlink.c:11533
 #4: ffff88807c8f7658 (&nsim_bus_dev->nsim_bus_reload_lock){+.+.}-{3:3}, at: nsim_dev_reload_up+0xb3/0x7b0 drivers/net/netdevsim/dev.c:897
 #5: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: devlink_nl_port_fill+0x17a/0x16a0 net/core/devlink.c:995
3 locks held by kworker/1:13/13828:
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc90003fa7db0 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:251
3 locks held by kworker/1:15/13832:
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c67d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc90002c07db0 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
3 locks held by kworker/u4:9/14752:
 #0: ffff88801871b138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801871b138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88801871b138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff88801871b138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff88801871b138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff88801871b138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc9001062fdb0 ((work_completion)(&(&rdev->dfs_update_channels_wk)->work)){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: cfg80211_dfs_channels_update_work+0x91/0x5f0 net/wireless/mlme.c:842
2 locks held by kworker/0:21/15633:
3 locks held by kworker/0:23/15637:
 #0: ffff888027a5c538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888027a5c538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888027a5c538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888027a5c538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888027a5c538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888027a5c538 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x8a3/0x16b0 kernel/workqueue.c:2268
 #1: ffffc9000ad37db0 ((addr_chk_work).work){+.+.}-{0:0}, at: process_one_work+0x8d7/0x16b0 kernel/workqueue.c:2272
 #2: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_verify_work+0xa/0x20 net/ipv6/addrconf.c:4590
1 lock held by syz-executor.3/17036:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3397
1 lock held by syz-executor.1/17042:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3397
2 locks held by syz-executor.2/17046:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
 #1: ffffffff8b9867a8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #1: ffffffff8b9867a8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4fc/0x620 kernel/rcu/tree_exp.h:837
1 lock held by syz-executor.0/17047:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by syz-executor.4/17052:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by syz-executor.5/17058:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5569
1 lock held by systemd-udevd/17071:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: dev_ioctl+0x470/0xee0 net/core/dev_ioctl.c:521
1 lock held by systemd-udevd/17072:
 #0: ffffffff8d0e20a8 (rtnl_mutex){+.+.}-{3:3}, at: dev_ioctl+0x470/0xee0 net/core/dev_ioctl.c:521

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 27 Comm: khungtaskd Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xc1d/0xf50 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 17046 Comm: syz-executor.2 Not tainted 5.15.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:lockdep_enabled kernel/locking/lockdep.c:88 [inline]
RIP: 0010:lockdep_softirqs_on+0x53/0x340 kernel/locking/lockdep.c:4398
Code: 65 48 8b 1c 25 40 f0 01 00 38 d0 7c 08 84 d2 0f 85 2a 02 00 00 8b 3d 08 a4 13 0c 85 ff 0f 84 e7 01 00 00 65 8b 05 8d 4c a7 7e <85> c0 0f 85 d8 01 00 00 65 48 8b 2c 25 40 f0 01 00 48 8d bd f4 09
RSP: 0018:ffffc900068f6bc0 EFLAGS: 00000002
RAX: 0000000000000000 RBX: ffff888075086340 RCX: 1ffffffff1adca3d
RDX: 0000000000000000 RSI: ffffffff814586b3 RDI: 0000000000000001
RBP: ffffffff8761e7d3 R08: 0000000000000000 R09: ffffffff8b666843
R10: ffffffff817b579d R11: 0000000000000000 R12: ffffffff8761e7d3
R13: 0000000000006872 R14: 0000000000000000 R15: 0000000000000001
FS:  00007f799a824700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f78595f8000 CR3: 00000000782ab000 CR4: 00000000003506f0
Call Trace:
 __local_bh_enable_ip+0xcd/0x120 kernel/softirq.c:371
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 get_next_corpse net/netfilter/nf_conntrack_core.c:2252 [inline]
 nf_ct_iterate_cleanup+0x15a/0x450 net/netfilter/nf_conntrack_core.c:2275
 nf_ct_iterate_cleanup_net net/netfilter/nf_conntrack_core.c:2363 [inline]
 nf_ct_iterate_cleanup_net+0x236/0x400 net/netfilter/nf_conntrack_core.c:2347
 masq_device_event+0xae/0xe0 net/netfilter/nf_nat_masquerade.c:88
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1996
 call_netdevice_notifiers_extack net/core/dev.c:2008 [inline]
 call_netdevice_notifiers net/core/dev.c:2022 [inline]
 __dev_notify_flags+0x1da/0x2b0 net/core/dev.c:8801
 dev_change_flags+0x112/0x170 net/core/dev.c:8837
 do_setlink+0x96d/0x3970 net/core/rtnetlink.c:2719
 rtnl_group_changelink net/core/rtnetlink.c:3242 [inline]
 __rtnl_newlink+0xc06/0x1750 net/core/rtnetlink.c:3396
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f799d2ad709
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f799a824188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f799d3b1f60 RCX: 00007f799d2ad709
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 00007f799d307cb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff88eac50f R14: 00007f799a824300 R15: 0000000000022000
----------------
Code disassembly (best guess):
   0:	65 48 8b 1c 25 40 f0 	mov    %gs:0x1f040,%rbx
   7:	01 00
   9:	38 d0                	cmp    %dl,%al
   b:	7c 08                	jl     0x15
   d:	84 d2                	test   %dl,%dl
   f:	0f 85 2a 02 00 00    	jne    0x23f
  15:	8b 3d 08 a4 13 0c    	mov    0xc13a408(%rip),%edi        # 0xc13a423
  1b:	85 ff                	test   %edi,%edi
  1d:	0f 84 e7 01 00 00    	je     0x20a
  23:	65 8b 05 8d 4c a7 7e 	mov    %gs:0x7ea74c8d(%rip),%eax        # 0x7ea74cb7
* 2a:	85 c0                	test   %eax,%eax <-- trapping instruction
  2c:	0f 85 d8 01 00 00    	jne    0x20a
  32:	65 48 8b 2c 25 40 f0 	mov    %gs:0x1f040,%rbp
  39:	01 00
  3b:	48                   	rex.W
  3c:	8d                   	.byte 0x8d
  3d:	bd                   	.byte 0xbd
  3e:	f4                   	hlt
  3f:	09                   	.byte 0x9


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
