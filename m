Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CC9431B11
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 15:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhJRNa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 09:30:28 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53001 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbhJRN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 09:29:37 -0400
Received: by mail-io1-f70.google.com with SMTP id y9-20020a5e8349000000b005ddb44e9eb8so10664028iom.19
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 06:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vHNmD/y+gjT5l0EQyfbWcEg0aHeoUgqB/l/IGlb3ctU=;
        b=f5fr+/qhKNst8uSlneYgB2HNm8Os4DEI9CD7xf+Gbs4Jan1RfekQJpk4PD9UIc6F8g
         y0SFEsEyyPb4FdvDTdfnSlzE5cccdlTzPima4Bl9dtG+ALJRPX1zHvmC6jcvpCS9dECW
         wwSJQ9Dkj34YEd2kOO94KHrXxF5Q9MJCiuYL9I4l7dVuA+IMruIW1XIR4QxwA29hivRG
         oAH83QaAqJidyc8QcLX0DmBKRrH980GGJsAgzbRakVuZTgGPWvFL35te24jzRLQJLh2v
         DYJDVA7BPf9ybgylmOHkXIzjBKOdTIQO1Llz3VSaSzUTyuO9y9jWs1diQKNQzFhacwVi
         BGMA==
X-Gm-Message-State: AOAM530W6QC9BXjW0CV08B/4PATXIU/G8zbNoFpkNVpp814i/xePFjky
        fY0+vCt4mGTJhcRCuFW+xTSjEJjJcb3SWbTEOOxGQC1I8YNP
X-Google-Smtp-Source: ABdhPJz5R5gb+JYBpKPMIPyEU/4PnU1eYPMQoDQl3MMTBgeX6nbHo9Nx/o/WqSQYC+rY5aZPIgjTSgIJfnRx2XPyjgtGsNOArYxj
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2a44:: with SMTP id k4mr14347641iov.56.1634563645825;
 Mon, 18 Oct 2021 06:27:25 -0700 (PDT)
Date:   Mon, 18 Oct 2021 06:27:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000078ed9505cea081d3@google.com>
Subject: [syzbot] INFO: task can't die in ip_tunnel_init_net
From:   syzbot <syzbot+57acebac784a6a86f44d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    83fa5857d812 Add linux-next specific files for 20210921
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1219b1f3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26e605eb9e346182
dashboard link: https://syzkaller.appspot.com/bug?extid=57acebac784a6a86f44d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+57acebac784a6a86f44d@syzkaller.appspotmail.com

INFO: task syz-executor.0:17359 can't die for more than 143 seconds.
task:syz-executor.0  state:D stack:26504 pid:17359 ppid: 15131 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4955 [inline]
 __schedule+0x940/0x26f0 kernel/sched/core.c:6236
 schedule+0xd3/0x270 kernel/sched/core.c:6315
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6374
 __mutex_lock_common kernel/locking/mutex.c:672 [inline]
 __mutex_lock+0xa34/0x12f0 kernel/locking/mutex.c:732
 ip_tunnel_init_net+0x2d5/0x9d0 net/ipv4/ip_tunnel.c:1069
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x40f/0xa30 net/core/net_namespace.c:326
 copy_net_ns+0x319/0x760 net/core/net_namespace.c:470
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2da7/0x7580 kernel/fork.c:2248
 kernel_clone+0xe7/0xac0 kernel/fork.c:2635
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2752
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4805e8a739
RSP: 002b:00007f4803401188 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f4805f8ef80 RCX: 00007f4805e8a739
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000046100380
RBP: 00007f4805ee4cc4 R08: 0000000020003a80 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4805f8ef80
R13: 00007ffdbf36d0af R14: 00007f4803401300 R15: 0000000000022000

Showing all locks held in the system:
4 locks held by kworker/u4:0/8:
 #0: ffff888012033138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888012033138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888012033138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888012033138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888012033138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888012033138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2268
 #1: ffffc90000cd7db0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2272
 #2: ffffffff8d0d1290 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb00 net/core/net_namespace.c:555
 #3: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: netdev_run_todo+0x6fa/0xa80 net/core/dev.c:10600
3 locks held by kworker/u4:1/10:
 #0: ffff888018113138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888018113138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888018113138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888018113138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888018113138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888018113138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2268
 #1: ffffc90000cf7db0 ((work_completion)(&(&rdev->dfs_update_channels_wk)->work)){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2272
 #2: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: cfg80211_dfs_channels_update_work+0x91/0x5f0 net/wireless/mlme.c:842
1 lock held by khungtaskd/27:
 #0: ffffffff8b980960 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
2 locks held by kworker/u4:4/319:
3 locks held by kworker/1:2/2928:
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff888010c64d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2268
 #1: ffffc9000c7b7db0 (deferred_process_work){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2272
 #2: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xa/0x20 net/switchdev/switchdev.c:74
1 lock held by in:imklog/6255:
2 locks held by kworker/1:8/8556:
3 locks held by kworker/0:7/8576:
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2268
 #1: ffffc90016df7db0 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2272
 #2: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x1340 net/ipv6/addrconf.c:4047
2 locks held by syz-executor.1/15129:
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3397
 #1: ffffffff8b989ce8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #1: ffffffff8b989ce8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4fc/0x620 kernel/rcu/tree_exp.h:836
1 lock held by syz-executor.5/15130:
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3397
1 lock held by syz-executor.4/15132:
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3397
1 lock held by kworker/u4:8/17189:
1 lock held by syz-executor.2/17352:
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3397
1 lock held by syz-executor.3/17355:
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:684 [inline]
 #0: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3a/0x180 drivers/net/tun.c:3397
2 locks held by syz-executor.0/17359:
 #0: ffffffff8d0d1290 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x2f5/0x760 net/core/net_namespace.c:466
 #1: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: ip_tunnel_init_net+0x2d5/0x9d0 net/ipv4/ip_tunnel.c:1069
3 locks held by kworker/1:4/17404:
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1198 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:634 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:661 [inline]
 #0: ffff88802532d938 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work+0x896/0x1690 kernel/workqueue.c:2268
 #1: ffffc900021efdb0 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work+0x8ca/0x1690 kernel/workqueue.c:2272
 #2: ffffffff8d0e4828 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xa3/0x1340 net/ipv6/addrconf.c:4047

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
