Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADA8137200
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 17:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgAJQAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 11:00:09 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:45761 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgAJQAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 11:00:09 -0500
Received: by mail-io1-f70.google.com with SMTP id c23so1785734ioi.12
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 08:00:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lqZpbvzcev1+uBVfoorRSE6+g2PmScjp9443L3pHREM=;
        b=HmJq0lEWuP0o8Pgznggq6RazHgEF30u7+4BM2fuTRhrsJ9pxdmEaJgsm8w3WoWbaPz
         GzV/sq0c6dld2s/ivjj5nBvKD83eMtwT0Y8hpELye0lNZ4DyWeC9JFqu2MBE8xE6tYU9
         ZGhNG5puC8W1DYH0otwGvBprej0fHRp30PjoUEZxRkno21HXhv3ACida1mmXq5zL3yYb
         dLdeHTdOuw98brqpbdGdVYOxQYWP65aB/srQkcTXdHqPl7RJvDbedjEPuw4S5iQBthhS
         tFxnptHP/GiAlKsV3HhQGIWTVc6nAOMBkEZwVHSOR383C7m+u9cLpKNAox5Cpv6gnUe8
         Ixxg==
X-Gm-Message-State: APjAAAV+easQXGAsqkgAYAVf7zZ8NTJKJB8JmawnhqRZILdviEyVY+Rg
        JY8iXV9LQOd1sxGNz0xd41lsceDRCBcQTrdzwCmED4wD2GFG
X-Google-Smtp-Source: APXvYqykSkCDLPC2yP+CbWDHinRN0ez2PtkWaPuNorLEbmOT5CQeai50sklsWvR/lXxRtZt47x7EecHFpup21rmhX8Zc/i3s0/48
MIME-Version: 1.0
X-Received: by 2002:a5e:a809:: with SMTP id c9mr3215904ioa.105.1578672008355;
 Fri, 10 Jan 2020 08:00:08 -0800 (PST)
Date:   Fri, 10 Jan 2020 08:00:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000466b64059bcb3843@google.com>
Subject: INFO: task hung in hashlimit_mt_check_common
From:   syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e69ec487 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13814eaee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=adf6c6c2be1c3a718121
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com

INFO: task syz-executor.2:17096 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.2  D28672 17096   9594 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: Bad RIP value.
RSP: 002b:00007f2a38618c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045af49
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000310 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00007f2a386196d4
R13: 00000000004caca7 R14: 00000000004e43e8 R15: 00000000ffffffff
INFO: task syz-executor.0:17100 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D28672 17100   9588 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: Bad RIP value.
RSP: 002b:00007fa98cf1dc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045af49
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000310 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00007fa98cf1e6d4
R13: 00000000004caca7 R14: 00000000004e43e8 R15: 00000000ffffffff
INFO: task syz-executor.5:17104 blocked for more than 144 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.5  D28672 17104   9601 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: Bad RIP value.
RSP: 002b:00007fa7b32c1c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045af49
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000310 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00007fa7b32c26d4
R13: 00000000004caca7 R14: 00000000004e43e8 R15: 00000000ffffffff
INFO: task syz-executor.4:17108 blocked for more than 145 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.4  D28672 17108   9599 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: Bad RIP value.
RSP: 002b:00007f7766762c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045af49
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000310 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00007f77667636d4
R13: 00000000004caca7 R14: 00000000004e43e8 R15: 00000000ffffffff
INFO: task syz-executor.3:17612 blocked for more than 145 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D27792 17612   9596 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
  hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:932
  xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
  check_match net/ipv4/netfilter/ip_tables.c:472 [inline]
  find_check_match net/ipv4/netfilter/ip_tables.c:488 [inline]
  find_check_entry.isra.0+0x32f/0x920 net/ipv4/netfilter/ip_tables.c:538
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: Bad RIP value.
RSP: 002b:00007f71fdaefc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045af49
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000009
RBP: 000000000075bf20 R08: 0000000000000310 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00007f71fdaf06d4
R13: 00000000004caca7 R14: 00000000004e43e8 R15: 00000000ffffffff

Showing all locks held in the system:
1 lock held by khungtaskd/1127:
  #0: ffffffff899a5340 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
1 lock held by rsyslogd/9457:
  #0: ffff88809f080da0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/9547:
  #0: ffff88809f360090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000176b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9548:
  #0: ffff888094198090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017db2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9549:
  #0: ffff8880a10b2090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017fb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9550:
  #0: ffff888093ac3090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017bb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9551:
  #0: ffff888098cc3090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017eb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9552:
  #0: ffff88809f295090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017832e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9553:
  #0: ffff88808fc1a090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000174b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
3 locks held by kworker/u4:11/9831:
  #0: ffff8880ae837358 (&rq->lock){-.-.}, at: rq_lock  
kernel/sched/sched.h:1215 [inline]
  #0: ffff8880ae837358 (&rq->lock){-.-.}, at: __schedule+0x232/0x1f90  
kernel/sched/core.c:4029
  #1: ffffffff899a5340 (rcu_read_lock){....}, at: trace_sched_stat_runtime  
include/trace/events/sched.h:435 [inline]
  #1: ffffffff899a5340 (rcu_read_lock){....}, at: update_curr+0x2ea/0x8d0  
kernel/sched/fair.c:859
  #2: ffff8880ae827258 (&base->lock){-.-.}, at: lock_timer_base+0x56/0x1b0  
kernel/time/timer.c:936
1 lock held by syz-executor.1/17093:
1 lock held by syz-executor.2/17096:
  #0: ffffffff8a553700 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor.0/17100:
  #0: ffffffff8a553700 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor.5/17104:
  #0: ffffffff8a553700 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor.4/17108:
  #0: ffffffff8a553700 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903
1 lock held by syz-executor.3/17612:
  #0: ffffffff8a553700 (hashlimit_mutex){+.+.}, at:  
hashlimit_mt_check_common.isra.0+0x341/0x1500  
net/netfilter/xt_hashlimit.c:903

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1127 Comm: khungtaskd Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0xb11/0x10c0 kernel/hung_task.c:289
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 17093 Comm: syz-executor.1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:92 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:109 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:135 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:166 [inline]
RIP: 0010:check_memory_region_inline mm/kasan/generic.c:182 [inline]
RIP: 0010:check_memory_region+0x126/0x1a0 mm/kasan/generic.c:192
Code: 49 29 c1 e9 68 ff ff ff 5b b8 01 00 00 00 41 5c 41 5d 5d c3 4d 85 c9  
74 ef 4d 01 e1 eb 09 48 83 c0 01 4c 39 c8 74 e1 80 38 00 <74> f2 eb 8c 4d  
39 c2 74 4d e8 dc e2 ff ff 31 c0 5b 41 5c 41 5d 5d
RSP: 0018:ffffc900016776b0 EFLAGS: 00000202
RAX: fffff520002ceee2 RBX: fffff520002ceee3 RCX: ffffffff815bfa09
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90001677710
RBP: ffffc900016776c8 R08: 1ffff920002ceee2 R09: fffff520002ceee3
R10: fffff520002ceee2 R11: ffffc90001677713 R12: fffff520002ceee2
R13: ffffc90017a71050 R14: ffffc90017a71058 R15: ffffc90001677750
FS:  00007f3c9e5a3700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7084e61000 CR3: 000000008f918000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __kasan_check_write+0x14/0x20 mm/kasan/common.c:101
  atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:694 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:78 [inline]
  do_raw_spin_lock+0x139/0x2f0 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x3b/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  htable_selective_cleanup+0xa6/0x330 net/netfilter/xt_hashlimit.c:382
  htable_destroy net/netfilter/xt_hashlimit.c:422 [inline]
  htable_put+0x176/0x220 net/netfilter/xt_hashlimit.c:449
  hashlimit_mt_destroy_v1+0x50/0x70 net/netfilter/xt_hashlimit.c:978
  cleanup_match+0xde/0x170 net/ipv6/netfilter/ip6_tables.c:478
  find_check_entry.isra.0+0x454/0x920 net/ipv4/netfilter/ip_tables.c:564
  translate_table+0xcb4/0x17d0 net/ipv4/netfilter/ip_tables.c:717
  do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
  do_ipt_set_ctl+0x2fe/0x4c2 net/ipv4/netfilter/ip_tables.c:1672
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3c9e5a2c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045af49
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000310 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00007f3c9e5a36d4
R13: 00000000004caca7 R14: 00000000004e43e8 R15: 00000000ffffffff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
