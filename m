Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4452D735C
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 11:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405744AbgLKKEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 05:04:22 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:40301 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732317AbgLKKDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 05:03:51 -0500
Received: by mail-il1-f197.google.com with SMTP id g1so1030463ilq.7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 02:03:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uOC2+82+GbEMhFKOFJV1ZRw6jqNsv44LU405Nk29/vk=;
        b=HcWYmjCCsEhGMqLDv/ty/MZLSqVJiIYVzUq9bB+jPWBLrASTN2CFDUpEKbIwMYj+fc
         UI4yDG5653y45EEL/5rk8XU1fAfQZMWAqUigjz1nRX05EgQJm7xHOsBpyX4re/PcyKf2
         obeCkQEP6DrG97wOXigdDv2hL4V15IoHaC78lpujF51Ck5SlIWgS0qXVh8G24JLhSDj7
         lKiWVaE3qIukzrHxaYdq33DPniN2tKmcPKtp1fWhQaaxQJxZ8+onMVJxT/ZaqjNRx8zd
         SNDfEJ4M/6KM4AsipSNv8uxyMwGGKRoA3HT9sUDRklKKoobHBA/5TB63wxQldsCNjJbt
         Q8LA==
X-Gm-Message-State: AOAM531UvmRc72CMba6i2jG5cvGznZEeqEtoe7W7HFjYaCMoEsw8Z/95
        1GHhWp8b7mXarnKlApujk1I6gUphSPuFGvJa5Mzu1a4vX5o1
X-Google-Smtp-Source: ABdhPJyS9DPn9X/pqrU8UkmwJ2EG8zRVVPeG0gsGgP4jnW3RkTWJeILitrISDAiZc4KnI2auNRcRwBuwBGR7H1fBTu+lcx2uvthc
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:5ab:: with SMTP id k11mr8236476ils.189.1607680990586;
 Fri, 11 Dec 2020 02:03:10 -0800 (PST)
Date:   Fri, 11 Dec 2020 02:03:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005b303e05b62d6674@google.com>
Subject: INFO: task can't die in corrupted (2)
From:   syzbot <syzbot+61cb1d04bf13f0c631b1@syzkaller.appspotmail.com>
To:     ast@kernel.org, christian.brauner@ubuntu.com, daniel@iogearbox.net,
        davem@davemloft.net, gnault@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0eedceaf Add linux-next specific files for 20201201
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12db3b4b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=55aec7153b7827ea
dashboard link: https://syzkaller.appspot.com/bug?extid=61cb1d04bf13f0c631b1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17985545500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+61cb1d04bf13f0c631b1@syzkaller.appspotmail.com

INFO: task syz-executor.0:9776 can't die for more than 143 seconds.
task:syz-executor.0  state:R  running task     stack:25800 pid: 9776 ppid:  8572 flags:0x00004006
Call Trace:
 context_switch kernel/sched/core.c:4325 [inline]
 __schedule+0x8cd/0x2150 kernel/sched/core.c:5076

Showing all locks held in the system:
4 locks held by kworker/u4:4/359:
 #0: ffff8881407ab138 ((wq_completion)netns){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8881407ab138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8881407ab138 ((wq_completion)netns){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8881407ab138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8881407ab138 ((wq_completion)netns){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8881407ab138 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2243
 #1: ffffc900014efda8 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2247
 #2: ffffffff8c92ed90 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x9b/0xb10 net/core/net_namespace.c:566
 #3: ffffffff8c940f88 (rtnl_mutex){+.+.}-{3:3}, at: netdev_run_todo+0x90a/0xdd0 net/core/dev.c:10316
1 lock held by khungtaskd/1663:
 #0: ffffffff8b33a7a0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6254
1 lock held by in:imklog/8233:
 #0: ffff88801f67e370 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:923
3 locks held by kworker/0:2/8537:
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010062d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x871/0x15f0 kernel/workqueue.c:2243
 #1: ffffc9000c297da8 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work+0x8a5/0x15f0 kernel/workqueue.c:2247
 #2: ffffffff8c940f88 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xb/0x60 net/core/link_watch.c:250
2 locks held by kworker/u4:3/9739:
1 lock held by syz-executor.1/9765:
1 lock held by syz-executor.0/9776:
1 lock held by syz-executor.3/10296:
1 lock held by syz-executor.5/10299:
4 locks held by syz-executor.4/10323:
4 locks held by syz-executor.2/10542:

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
