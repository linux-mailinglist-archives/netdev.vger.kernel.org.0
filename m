Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830462A8338
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731453AbgKEQOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:14:36 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:50846 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKEQOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 11:14:18 -0500
Received: by mail-il1-f197.google.com with SMTP id f66so1427628ilh.17
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 08:14:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tsd/JVbo3R0lY4M50qsZER+Cu6hHErV9thhnjy2cypU=;
        b=Vnz1v0rsUwqIA3R4rsE0lTmd7IM/0z/Bp/kMJt0w2KGLT5sQVUDTmLvc14AqDnSm8g
         CqCp/Oed0sxVF6ONG7DVifruZ4Ca0SFiNKO+vdX2tG+ntaXRMYSAZbZ7yrzhTghqXXrd
         9zBWynfo2VZGtLtSq84r0pPKjqy3ZwIELnWq3Oia9LtscBTuklbGYeIM5NWKCrmZVA8g
         BeDMjwq2mgabmPYeLoMQMKxZTyZvo4gmOdw9l7+2eoD725lB4HYKuYJUEO7izc06Ssof
         drRkfQw413InD1f07IllaO3FcVAHV4n/8KqHXq/uhWoH3SMTEY4+n9URdn9CKBDF+TPM
         KhBQ==
X-Gm-Message-State: AOAM531oUuSccI8/EWe/QEy1TNpPsB3AerDT+ts2jhj2gtPC8weZF3dv
        rNJ31PRW8ZbjwozQgelZRhNjNoOsRkjXpJDYfmlHX24cDonj
X-Google-Smtp-Source: ABdhPJxhBU7XP0YPUlFoo3F9BvxY+JfETUAVAXzwyqvRktu2JnDnleSvNEXC7V/oCl5n6+rOE+rM+QQRE03ffQEO3fKgBxqgmBoC
MIME-Version: 1.0
X-Received: by 2002:a92:9903:: with SMTP id p3mr2573302ili.138.1604592857317;
 Thu, 05 Nov 2020 08:14:17 -0800 (PST)
Date:   Thu, 05 Nov 2020 08:14:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045065c05b35e6365@google.com>
Subject: linux-next test error: BUG: sleeping function called from invalid
 context in sta_info_move_state
From:   syzbot <syzbot+abed06851c5ffe010921@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    cf7cd542 Add linux-next specific files for 20201104
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13b7bb82500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e8dc0c5ac73afb92
dashboard link: https://syzkaller.appspot.com/bug?extid=abed06851c5ffe010921
compiler:       gcc (GCC) 10.1.0-syz 20200507

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+abed06851c5ffe010921@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at net/mac80211/sta_info.c:1962
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 86, name: kworker/u4:3
4 locks held by kworker/u4:3/86:
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc9000108fda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff88801b714d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff88801b714d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b338160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b338160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
Preemption disabled at:
[<ffffffff88e8841f>] __mutex_lock_common kernel/locking/mutex.c:955 [inline]
[<ffffffff88e8841f>] __mutex_lock+0x10f/0x1110 kernel/locking/mutex.c:1103
CPU: 1 PID: 86 Comm: kworker/u4:3 Not tainted 5.10.0-rc2-next-20201104-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
 ieee80211_iface_work+0x91f/0xa90 net/mac80211/iface.c:1478
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

=============================
[ BUG: Invalid wait context ]
5.10.0-rc2-next-20201104-syzkaller #0 Tainted: G        W        
-----------------------------
kworker/u4:3/86 is trying to lock:
ffff888027f829d0 (&local->chanctx_mtx){+.+.}-{3:3}, at: ieee80211_recalc_min_chandef+0x49/0x140 net/mac80211/util.c:2740
other info that might help us debug this:
context-{4:4}
4 locks held by kworker/u4:3/86:
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff88801afe0138 ((wq_completion)phy3){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc9000108fda8 ((work_completion)(&sdata->work)){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247
 #2: ffff88801b714d00 (&wdev->mtx){+.+.}-{3:3}, at: sdata_lock net/mac80211/ieee80211_i.h:1021 [inline]
 #2: ffff88801b714d00 (&wdev->mtx){+.+.}-{3:3}, at: ieee80211_ibss_work+0x93/0xe80 net/mac80211/ibss.c:1683
 #3: ffffffff8b338160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_finish net/mac80211/sta_info.c:644 [inline]
 #3: ffffffff8b338160 (rcu_read_lock){....}-{1:2}, at: sta_info_insert_rcu+0x680/0x2ba0 net/mac80211/sta_info.c:732
stack backtrace:
CPU: 1 PID: 86 Comm: kworker/u4:3 Tainted: G        W         5.10.0-rc2-next-20201104-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
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
 __mutex_lock+0x134/0x1110 kernel/locking/mutex.c:1103
 ieee80211_recalc_min_chandef+0x49/0x140 net/mac80211/util.c:2740
 sta_info_move_state+0x3cf/0x8d0 net/mac80211/sta_info.c:2019
 sta_info_free+0x65/0x3b0 net/mac80211/sta_info.c:274
 sta_info_insert_rcu+0x303/0x2ba0 net/mac80211/sta_info.c:738
 ieee80211_ibss_finish_sta+0x212/0x390 net/mac80211/ibss.c:592
 ieee80211_ibss_work+0x2c7/0xe80 net/mac80211/ibss.c:1700
 ieee80211_iface_work+0x91f/0xa90 net/mac80211/iface.c:1478
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
