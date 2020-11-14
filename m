Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1592B2C29
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 09:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgKNImV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 03:42:21 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:44011 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgKNImV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 03:42:21 -0500
Received: by mail-io1-f72.google.com with SMTP id o3so8017254iou.10
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 00:42:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bj3W9TSRuNB5zN1zcILYUOo0CCiv9Ra69YabE1nBxXU=;
        b=J4Jbup0A5wJ03RRHseP9lT6j3FA0/YBokJBQUCpEBizucdedxJH5fu+8d1Gn2EWi5G
         k/eY4y2qr5XGBWQ22qSkgd0ha+WCZ2d08gNyQMMSh+Bu4YYq+jtFVwiDxrYwuc0zVRHM
         spBYwwJJODXkBSm+OXnunohwU9SQ/CUYbtM2lLSfTU8+f+CqlmyNcpJqa/WmxgHWW2ld
         8jwsqU9yqUXXVNaKtn5YLhsKyf5J7lce2BYCjHOgIDmL2DLaMWpYgxOQQB3HjKZGaF6X
         X4S5/C6jBXzX9zo0sJPHNKVvN0QW1qDZEw2XIzM9y1OoT9diXn0kydZZ7j1V2TQbwWl1
         0tVg==
X-Gm-Message-State: AOAM530PLAGACLIyZPLyyY3QxhYI39Gx/ZN7LqAOyqcYuE4Wj0y94va0
        wTGYuBsggUXnQNuH/aD5LLc95iVWX67YDFZhvUSHnEYpf8d5
X-Google-Smtp-Source: ABdhPJzTRAynS1CtdFCdNIZn8SSWU926HivVo0tWX0/Ntfi5M1joXKY5JOBDA9fz6S5mfMkCDqVWR0r3lBDH5ZbwLDFCIs0kGRAk
MIME-Version: 1.0
X-Received: by 2002:a02:cc84:: with SMTP id s4mr4891080jap.126.1605343339722;
 Sat, 14 Nov 2020 00:42:19 -0800 (PST)
Date:   Sat, 14 Nov 2020 00:42:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081bcd205b40d1f44@google.com>
Subject: bpf test error: BUG: sleeping function called from invalid context in sta_info_move_state
From:   syzbot <syzbot+5921b7c1b10a0ddd02bc@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    96021828 MAINTAINERS/bpf: Update Andrii's entry.
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=102717be500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61033507391c77ff
dashboard link: https://syzkaller.appspot.com/bug?extid=5921b7c1b10a0ddd02bc
compiler:       gcc (GCC) 10.1.0-syz 20200507

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5921b7c1b10a0ddd02bc@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at net/mac80211/sta_info.c:1962
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 124, name: kworker/u4:3
4 locks held by kworker/u4:3/124:
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc9000132fda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff88801ab98d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff88801ab98d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
Preemption disabled at:
[<ffffffff88e63ecf>] __mutex_lock_common kernel/locking/mutex.c:955 [inline]
[<ffffffff88e63ecf>] __mutex_lock+0x10f/0x10e0 kernel/locking/mutex.c:1103
CPU: 0 PID: 124 Comm: kworker/u4:3 Not tainted 5.10.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_iface_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 ___might_sleep.cold+0x1e8/0x22e kernel/sched/core.c:7298
 sta_info_move_state+0x32/0x8d0 net/mac80211/sta_info.c:1962
 sta_info_free+0x65/0x3b0 net/mac80211/sta_info.c:274
 sta_info_insert_rcu+0x303/0x2ba0 net/mac80211/sta_info.c:738
 ieee80211_ibss_finish_sta+0x212/0x390 net/mac80211/ibss.c:592
 ieee80211_ibss_work+0x2c7/0xe80 net/mac80211/ibss.c:1700
 ieee80211_iface_work+0x82e/0x970 net/mac80211/iface.c:1476
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

=============================
[ BUG: Invalid wait context ]
5.10.0-rc2-syzkaller #0 Tainted: G        W        
-----------------------------
kworker/u4:3/124 is trying to lock:
ffff888035f2a9d0 (&local->chanctx_mtx){+.+.}-{3:3}, at: ieee80211_recalc_min_chandef+0x49/0x140 net/mac80211/util.c:2740
other info that might help us debug this:
context-{4:4}
4 locks held by kworker/u4:3/124:
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888035f48938 ((wq_completion)phy4){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc9000132fda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff88801ab98d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff88801ab98d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b337160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
stack backtrace:
CPU: 0 PID: 124 Comm: kworker/u4:3 Tainted: G        W         5.10.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_iface_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4483 [inline]
 check_wait_context kernel/locking/lockdep.c:4544 [inline]
 __lock_acquire.cold+0x310/0x3a2 kernel/locking/lockdep.c:4781
 lock_acquire kernel/locking/lockdep.c:5436 [inline]
 lock_acquire+0x2a3/0x8c0 kernel/locking/lockdep.c:5401
 __mutex_lock_common kernel/locking/mutex.c:956 [inline]
 __mutex_lock+0x134/0x10e0 kernel/locking/mutex.c:1103
 ieee80211_recalc_min_chandef+0x49/0x140 net/mac80211/util.c:2740
 sta_info_move_state+0x3cf/0x8d0 net/mac80211/sta_info.c:2019
 sta_info_free+0x65/0x3b0 net/mac80211/sta_info.c:274
 sta_info_insert_rcu+0x303/0x2ba0 net/mac80211/sta_info.c:738
 ieee80211_ibss_finish_sta+0x212/0x390 net/mac80211/ibss.c:592
 ieee80211_ibss_work+0x2c7/0xe80 net/mac80211/ibss.c:1700
 ieee80211_iface_work+0x82e/0x970 net/mac80211/iface.c:1476
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
