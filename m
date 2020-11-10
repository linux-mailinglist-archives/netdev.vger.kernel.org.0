Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9882AE392
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 23:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgKJWpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 17:45:21 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:56471 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbgKJWpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 17:45:20 -0500
Received: by mail-io1-f69.google.com with SMTP id i9so48892iom.23
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 14:45:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mbcIJdSZt08Q33JkjthQGdgmAAE0tTHvd4eCRjpw37g=;
        b=aXXgRT9HBpV2sX9p9rPkBbxJrki8vzxomnZsMIii1B8O2CM+RWBlU4XlKwV1lZAuEv
         HTl99eSbQwXV8PBRkRWTn3n6W2BdDhYQHOleENMAO2Wp2/T69lYZurCke8RzVjjpLbR+
         SkehoL6He30M2XgoCG3M+xhNyEV54I8tusYokoThi51wQlz2yW9u8phkjxz2EWB5siMz
         crgVuze4u2Tpa4+BB4aP9KTTsqajMJg4RVyCzBEzX9oRIWrgGFkRHQgfX4/ew6vqyZrh
         0/maN8KbayUXxiAJM6EqCY/yfNnaStglthuh85tkqmJ0Hv5UDpUHfDvWIpllTOQpEFFD
         DKyg==
X-Gm-Message-State: AOAM531xyYsLaALCjEwUR9tNj4XgSazQVfVHDdvY5buzSxeBKE1L8AQR
        w48Cvch8C8XJGGrHOm07iPgXiSPOuob3cG1OeXl0pGVvnStX
X-Google-Smtp-Source: ABdhPJwvOUKEWMo23XOMRl093MoBcK5b6E7pz2AuGMblnZ+uRHSQEURw8DfYIanDIKEhuR+PWxcI8Lm+IZRg5CnQ1aKEViMuYLwY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:11a4:: with SMTP id 4mr12443717ilj.141.1605048319069;
 Tue, 10 Nov 2020 14:45:19 -0800 (PST)
Date:   Tue, 10 Nov 2020 14:45:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7d5a605b3c86e1e@google.com>
Subject: upstream test error: BUG: sleeping function called from invalid
 context in sta_info_move_state
From:   syzbot <syzbot+32c6c38c4812d22f2f0b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    eccc8767 Merge branch 'fixes' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1743eadc500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86ae89f992df998f
dashboard link: https://syzkaller.appspot.com/bug?extid=32c6c38c4812d22f2f0b
compiler:       gcc (GCC) 10.1.0-syz 20200507

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+32c6c38c4812d22f2f0b@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at net/mac80211/sta_info.c:1962
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 9705, name: kworker/u16:2
4 locks held by kworker/u16:2/9705:
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900017e7da8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff88802c020d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff88802c020d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b337060 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b337060 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
Preemption disabled at:
[<ffffffff88e7264f>] __mutex_lock_common kernel/locking/mutex.c:955 [inline]
[<ffffffff88e7264f>] __mutex_lock+0x10f/0x10e0 kernel/locking/mutex.c:1103
CPU: 3 PID: 9705 Comm: kworker/u16:2 Not tainted 5.10.0-rc3-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: phy3 ieee80211_iface_work
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
5.10.0-rc3-syzkaller #0 Tainted: G        W        
-----------------------------
kworker/u16:2/9705 is trying to lock:
ffff88802bfe29d0 (&local->chanctx_mtx){+.+.}-{3:3}, at: ieee80211_recalc_min_chandef+0x49/0x140 net/mac80211/util.c:2740
other info that might help us debug this:
context-{4:4}
4 locks held by kworker/u16:2/9705:
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801fc6c938 ((wq_completion)phy3){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc900017e7da8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff88802c020d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff88802c020d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b337060 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b337060 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
stack backtrace:
CPU: 0 PID: 9705 Comm: kworker/u16:2 Tainted: G        W         5.10.0-rc3-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: phy3 ieee80211_iface_work
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
BUG: sleeping function called from invalid context at net/mac80211/sta_info.c:1962
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 9705, name: kworker/u16:2
INFO: lockdep is turned off.
Preemption disabled at:
[<ffffffff8100457d>] preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:40
CPU: 0 PID: 9705 Comm: kworker/u16:2 Tainted: G        W         5.10.0-rc3-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Workqueue: phy3 ieee80211_iface_work
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


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
