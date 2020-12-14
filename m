Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336F32D9661
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 11:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437077AbgLNKee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 05:34:34 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:42431 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436625AbgLNKdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 05:33:52 -0500
Received: by mail-il1-f199.google.com with SMTP id p10so1514590ilo.9
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 02:33:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xBOPoqrXHLeRKmnn2H4OYIta3b1Of/o2WJC8PPktQGg=;
        b=gejzEO9Di+VbiZ/2AT7qbT7CDydQVGSzOC3+6z0UzfslIMnpfB2PRvA2pgMYEtlP1k
         mXbx1+RY/4V0bnwBnjiYJVselXbbfLGEkYuo2CwZMs97s5pzdqvwCfoLJ9gHqwGdDYYw
         ZHyKztIeIZFtC2+/VCDmMUayIAO0vGJx+/dJiQyjiH0lt6QmAD0uyXYy8MasYQY71eVQ
         5Mkm6RWioFXlE6TUPfScn6MoLnrL0GipX+04JBOSP/rwsXAxwgAnzrQy/05QnWVJUyTR
         D8lNHmYV2yvYnyrRGSVRsmv0JdbZgatO88y7nN2MCOqAIohk1JiQ+OeA0qx2plbOnL7d
         XppQ==
X-Gm-Message-State: AOAM530rureM+e/Dtepn7PI30Cn1hMg5IW7DqCFpCYLm2VcwHbvAa4Gx
        ZkQU5TIXvHtBjQhLBos3Vpfe6XTTOJc2dNkjxwX4HYS/JrDY
X-Google-Smtp-Source: ABdhPJw4v3PL31sL6fEocTznjZ4TgrcB/+sm1loq2bUIkg/qJ+mY8o37FzED+RkXSt5I7N5MyUmy2aJD0daPkexRVtjKsAdvA9ek
MIME-Version: 1.0
X-Received: by 2002:a5d:83c8:: with SMTP id u8mr31506109ior.160.1607941991216;
 Mon, 14 Dec 2020 02:33:11 -0800 (PST)
Date:   Mon, 14 Dec 2020 02:33:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034b9aa05b66a2b25@google.com>
Subject: INFO: task hung in cfg80211_event_work
From:   syzbot <syzbot+84fea7179610ae50a9c7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a68a0262 mm/madvise: remove racy mm ownership check
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15bb9413500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=59df2a4dced5f928
dashboard link: https://syzkaller.appspot.com/bug?extid=84fea7179610ae50a9c7
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1169fa13500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1240f123500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+84fea7179610ae50a9c7@syzkaller.appspotmail.com

INFO: task kworker/u4:2:58 blocked for more than 161 seconds.
      Not tainted 5.10.0-rc7-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:2    state:D stack:23600 pid:   58 ppid:     2 flags:0x00004000
Workqueue: cfg80211 cfg80211_event_work
Call Trace:
 context_switch kernel/sched/core.c:3779 [inline]
 __schedule+0x893/0x2130 kernel/sched/core.c:4528
 schedule+0xcf/0x270 kernel/sched/core.c:4606
 schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:4665
 __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
 __mutex_lock+0x3e2/0x10e0 kernel/locking/mutex.c:1103
 cfg80211_event_work+0xe/0x20 net/wireless/core.c:321
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

Showing all locks held in the system:
2 locks held by kworker/0:0/5:
 #0: ffff888010066538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010066538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010066538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010066538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010066538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010066538 ((wq_completion)rcu_gp){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90000ca7da8 ((work_completion)(&rew.rew_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
3 locks held by kworker/1:0/17:
3 locks held by kworker/u4:2/58:
 #0: ffff888141147138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888141147138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888141147138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888141147138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888141147138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888141147138 ((wq_completion)cfg80211){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90000f2fda8 ((work_completion)(&rdev->event_work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffffffff8c927908 (rtnl_mutex){+.+.}-{3:3}, at: cfg80211_event_work+0xe/0x20 net/wireless/core.c:321
1 lock held by khungtaskd/1657:
 #0: ffffffff8b3378e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6254
1 lock held by khugepaged/1664:
 #0: ffffffff8b4062a8 (lock#5){+.+.}-{3:3}, at: lru_add_drain_all+0x5f/0x6f0 mm/swap.c:801
1 lock held by in:imklog/8161:
 #0: ffff88801c8459f0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:932
2 locks held by syz-executor702/8473:
 #0: ffffffff8c9aec50 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8c927908 (rtnl_mutex){+.+.}-{3:3}, at: nl80211_pre_doit+0x34f/0x630 net/wireless/nl80211.c:14579
2 locks held by syz-executor702/8474:
 #0: ffffffff8c9aec50 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8c9aed08 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8c9aed08 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3e0/0x580 net/netlink/genetlink.c:798
2 locks held by syz-executor702/8476:
 #0: ffffffff8c9aec50 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8c9aed08 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8c9aed08 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3e0/0x580 net/netlink/genetlink.c:798
3 locks held by syz-executor702/8477:
 #0: ffff888021e90460 (sb_writers#4){.+.+}-{0:0}, at: do_unlinkat+0x190/0x660 fs/namei.c:3879
 #1: ffff888031258488 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:809 [inline]
 #1: ffff888031258488 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: do_unlinkat+0x27d/0x660 fs/namei.c:3883
 #2: ffff88803125a288 (&sb->s_type->i_mutex_key#9){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:774 [inline]
 #2: ffff88803125a288 (&sb->s_type->i_mutex_key#9){+.+.}-{3:3}, at: vfs_unlink+0xcd/0x600 fs/namei.c:3824
3 locks held by syz-executor702/8478:
 #0: ffffffff8c9aec50 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40 net/netlink/genetlink.c:810
 #1: ffffffff8c9aed08 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8c9aed08 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3e0/0x580 net/netlink/genetlink.c:798
 #2: ffffffff8c927908 (rtnl_mutex){+.+.}-{3:3}, at: ieee80211_register_hw+0x1782/0x3b60 net/mac80211/main.c:1222
5 locks held by kworker/u4:0/8484:
 #0: ffff88801303f938 ((wq_completion)phy3){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801303f938 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801303f938 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801303f938 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801303f938 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801303f938 ((wq_completion)phy3){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900016ffda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff888013f78d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff888013f78d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffff888013921548 (&local->sta_mtx){+.+.}-{3:3}, at: ieee80211_ibss_sta_expire net/mac80211/ibss.c:1262 [inline]
 #3: ffff888013921548 (&local->sta_mtx){+.+.}-{3:3}, at: ieee80211_sta_merge_ibss net/mac80211/ibss.c:1305 [inline]
 #3: ffff888013921548 (&local->sta_mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x481/0xe80 net/mac80211/ibss.c:1711
 #4: ffffffff8b33ffa8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:290 [inline]
 #4: ffffffff8b33ffa8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x4f2/0x610 kernel/rcu/tree_exp.h:836
5 locks held by kworker/u4:1/8965:
 #0: ffff888027081138 ((wq_completion)phy5){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888027081138 ((wq_completion)phy5){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888027081138 ((wq_completion)phy5){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888027081138 ((wq_completion)phy5){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888027081138 ((wq_completion)phy5){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888027081138 ((wq_completion)phy5){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90002eefda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff888025bd8d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff888025bd8d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_rx_queued_mgmt+0xe9/0x1870 net/mac80211/ibss.c:1631
 #3: ffff888014bb9548 (&local->sta_mtx){+.+.}-{3:3}, at: sta_info_destroy_addr+0x48/0xe0 net/mac80211/sta_info.c:1127
 #4: ffffffff8b33ffa8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:322 [inline]
 #4: ffffffff8b33ffa8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x27e/0x610 kernel/rcu/tree_exp.h:836
3 locks held by syz-executor702/9802:
4 locks held by kworker/u4:4/9815:
 #0: ffff88802c99c938 ((wq_completion)phy4){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88802c99c938 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88802c99c938 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88802c99c938 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88802c99c938 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88802c99c938 ((wq_completion)phy4){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc9000a91fda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff88801459cd00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff88801459cd00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffff888013f71548 (&local->sta_mtx){+.+.}-{3:3}, at: ieee80211_ibss_sta_expire net/mac80211/ibss.c:1262 [inline]
 #3: ffff888013f71548 (&local->sta_mtx){+.+.}-{3:3}, at: ieee80211_sta_merge_ibss net/mac80211/ibss.c:1305 [inline]
 #3: ffff888013f71548 (&local->sta_mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x481/0xe80 net/mac80211/ibss.c:1711
4 locks held by kworker/u4:5/9825:
 #0: ffff888026e79138 ((wq_completion)phy7){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888026e79138 ((wq_completion)phy7){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888026e79138 ((wq_completion)phy7){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888026e79138 ((wq_completion)phy7){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888026e79138 ((wq_completion)phy7){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888026e79138 ((wq_completion)phy7){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc9000aa0fda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff8880275acd00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff8880275acd00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_rx_queued_mgmt+0xe9/0x1870 net/mac80211/ibss.c:1631
 #3: ffff888017fc9548 (&local->sta_mtx){+.+.}-{3:3}, at: sta_info_destroy_addr+0x48/0xe0 net/mac80211/sta_info.c:1127

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1657 Comm: khungtaskd Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:209 [inline]
 watchdog+0xd43/0xfa0 kernel/hung_task.c:294
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 9802 Comm: syz-executor702 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_kcov_mode kernel/kcov.c:163 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x19/0x60 kernel/kcov.c:197
Code: 8b 54 24 08 48 8b 34 24 e9 a1 fd ff ff 0f 1f 40 00 65 48 8b 14 25 00 f0 01 00 65 8b 05 40 eb 91 7e a9 00 01 ff 00 48 8b 34 24 <74> 0f f6 c4 01 74 35 8b 82 5c 14 00 00 85 c0 74 2b 8b 82 38 14 00
RSP: 0018:ffffc90000d90028 EFLAGS: 00000006
RAX: 0000000000010101 RBX: ffffc90000d90120 RCX: ffffffff818ed219
RDX: ffff8880328ccec0 RSI: ffffffff818ed227 RDI: 0000000000000007
RBP: ffffc90000d90280 R08: 0000000000000000 R09: ffffffff8ebaf667
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff888032b13000 R14: 0000000000000000 R15: ffffc90000d90120
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5ba2697710 CR3: 0000000012582000 CR4: 0000000000350ee0
Call Trace:
 <IRQ>
 perf_prepare_sample+0x817/0x1d40 kernel/events/core.c:7136
 __perf_event_output kernel/events/core.c:7191 [inline]
 perf_event_output_forward+0xf3/0x270 kernel/events/core.c:7211
 __perf_event_overflow+0x13c/0x370 kernel/events/core.c:8867
 perf_swevent_hrtimer+0x37c/0x3f0 kernel/events/core.c:10267
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x1ce/0xea0 kernel/time/hrtimer.c:1583
 hrtimer_interrupt+0x334/0x940 kernel/time/hrtimer.c:1645
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1080 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x540 arch/x86/kernel/apic/apic.c:1097
 run_sysvec_on_irqstack_cond arch/x86/include/asm/irq_stack.h:91 [inline]
 sysvec_apic_timer_interrupt+0x48/0x100 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:lock_release+0x3d5/0x710 kernel/locking/lockdep.c:5445
Code: 15 02 00 00 48 c7 c7 40 5f 4b 89 e8 c5 6b 8f 07 b8 ff ff ff ff 65 0f c1 05 58 d8 ab 7e 83 f8 01 0f 85 67 01 00 00 ff 34 24 9d <48> b8 00 00 00 00 00 fc ff df 48 01 c5 48 c7 45 00 00 00 00 00 c7
RSP: 0018:ffffc90000d906d0 EFLAGS: 00000246
RAX: 0000000000000001 RBX: 02e61d1879d3e8c2 RCX: ffffc90000d90720
RDX: 1ffff11006519af9 RSI: 0000000000000101 RDI: 0000000000000000
RBP: 1ffff920001b20dc R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000002 R14: ffff8880328cd7d0 R15: ffff8880328ccec0
 rcu_lock_release include/linux/rcupdate.h:253 [inline]
 rcu_read_unlock include/linux/rcupdate.h:695 [inline]
 is_bpf_text_address+0xcb/0x160 kernel/bpf/core.c:710
 kernel_text_address kernel/extable.c:151 [inline]
 kernel_text_address+0xbd/0xf0 kernel/extable.c:120
 __kernel_text_address+0x9/0x30 kernel/extable.c:105
 unwind_get_return_address arch/x86/kernel/unwind_orc.c:318 [inline]
 unwind_get_return_address+0x51/0x90 arch/x86/kernel/unwind_orc.c:313
 arch_stack_walk+0x93/0xe0 arch/x86/kernel/stacktrace.c:26
 stack_trace_save+0x8c/0xc0 kernel/stacktrace.c:121
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:535 [inline]
 slab_alloc_node mm/slub.c:2891 [inline]
 __kmalloc_node_track_caller+0x1e0/0x3e0 mm/slub.c:4495
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xae/0x550 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 ndisc_alloc_skb+0x134/0x320 net/ipv6/ndisc.c:420
 ndisc_send_rs+0x388/0x700 net/ipv6/ndisc.c:686
 addrconf_rs_timer+0x3f2/0x820 net/ipv6/addrconf.c:3873
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1410
 expire_timers kernel/time/timer.c:1455 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1747
 __run_timers kernel/time/timer.c:1728 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1760
 __do_softirq+0x2a0/0x9f6 kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x132/0x200 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:schedule_debug kernel/sched/core.c:4278 [inline]
RIP: 0010:__schedule+0x12c/0x2130 kernel/sched/core.c:4423
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 7d 1a 00 00 48 ba 00 00 00 00 00 fc ff df 49 8b 45 18 48 89 c1 48 c1 e9 03 80 3c 11 00 <0f> 85 43 1a 00 00 48 81 38 9d 6e ac 57 0f 85 c5 1f 00 00 49 8d 45
RSP: 0018:ffffc9000a94f8e0 EFLAGS: 00000246
RAX: ffffc9000a948000 RBX: 0000000000000001 RCX: 1ffff92001529000
RDX: dffffc0000000000 RSI: 0000000000000001 RDI: ffff8880328cced8
RBP: ffffc9000a94f9a8 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8880b9f34940
R13: ffff8880328ccec0 R14: ffff8880b9f34940 R15: 0000000000034940
 preempt_schedule_irq+0x4e/0x90 kernel/sched/core.c:4789
 irqentry_exit_cond_resched kernel/entry/common.c:357 [inline]
 irqentry_exit_cond_resched kernel/entry/common.c:349 [inline]
 irqentry_exit+0x7a/0xa0 kernel/entry/common.c:387
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:631
RIP: 0010:get_freepointer mm/slub.c:278 [inline]
RIP: 0010:slab_free_freelist_hook+0x8b/0x150 mm/slub.c:1562
Code: 8b 43 28 49 8b 55 00 48 89 54 05 00 48 8b 04 24 49 89 6d 00 48 83 38 00 0f 84 8d 00 00 00 4c 39 f5 0f 84 90 00 00 00 8b 43 28 <4c> 89 e5 4d 8b 24 04 0f 1f 44 00 00 9c 41 5f fa 41 f7 c7 00 02 00
RSP: 0018:ffffc9000a94fa80 EFLAGS: 00000246
RAX: 0000000000000038 RBX: ffff888010f21500 RCX: ffffffff8130c470
RDX: ffffc9000a94fac8 RSI: ffffc9000a94fac0 RDI: ffff888010f21500
RBP: ffff888010f21500 R08: 0000000000000001 R09: ffff888031f4f13f
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880211a8000
R13: ffffc9000a94fac0 R14: ffff8880211a8000 R15: ffffffff8b460f60
 slab_free mm/slub.c:3142 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3158
 free_mm_slot mm/khugepaged.c:414 [inline]
 __khugepaged_exit+0x2b8/0x3f0 mm/khugepaged.c:531
 khugepaged_exit include/linux/khugepaged.h:52 [inline]
 __mmput+0x389/0x470 kernel/fork.c:1078
 mmput+0x53/0x60 kernel/fork.c:1100
 exit_mm kernel/exit.c:486 [inline]
 do_exit+0xa72/0x29b0 kernel/exit.c:796
 do_group_exit+0x125/0x310 kernel/exit.c:906
 get_signal+0x42a/0x1f10 kernel/signal.c:2758
 arch_do_signal+0x82/0x2390 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:161 [inline]
 exit_to_user_mode_prepare+0x100/0x1a0 kernel/entry/common.c:191
 syscall_exit_to_user_mode+0x38/0x260 kernel/entry/common.c:266
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44a3e9
Code: Unable to access opcode bytes at RIP 0x44a3bf.
RSP: 002b:00007fa491ecadb8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00000000006e0c38 RCX: 000000000044a3e9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00000000006e0c38
RBP: 00000000006e0c30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e0c3c
R13: 00007fffc6dec0df R14: 00007fa491ecb9c0 R15: 0000000000000005
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.207 msecs


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
