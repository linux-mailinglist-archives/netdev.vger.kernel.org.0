Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9B5D5A66
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 06:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfJNEmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 00:42:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:41246 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfJNEmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 00:42:08 -0400
Received: by mail-io1-f71.google.com with SMTP id m25so7418326ioo.8
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 21:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=srEAw8jpZLU/Whuejy2I1DkjcEl7roY0PupVXJPKMKA=;
        b=I2gOOM7mxh8pwEOXLmhjh9C+hzLOYrYbvM6VZFHI1qdQV7d51XK+7wnpzOVvdBmDDa
         eyD25GWAbF62x2J4PQ7QdU9h8oX85yh20176qTYnJAtjxLg7tJz3qfScNAz255UNvJ/g
         LI8AezH6Yzm1Bp8JTqHfibI7sjsi6NuCWYG6NXePotZDrkLnAVqJWowFyynbPyf/0wGN
         xuySktyr86Lev0dwUAJ79iWRqAj9YS0bEVqGD7VM8RQACavPV2JNAIrQ64i7fIjOqdre
         hPlnNxX6YSBdMrlRF21L/LUaUHoxyRnms9ZQbKs856zsaFPPiAYb4vp5QfYlQaLN9Goc
         nGYQ==
X-Gm-Message-State: APjAAAVosoO++O5u07g3rxJHCMB+So41/MbqL+zuPDS++5d75Yedie6a
        IRqYumrcNFZVTfpVx4tNgxU3GrHVWsz2lpflqWQhuLPD71Qz
X-Google-Smtp-Source: APXvYqyGPQWv8AEP+BEbH4yPzRQPtuq9BrB7YS0IvdJMHUHc1gIBcld56elyacStYBz2Wc+Auq7xGePjcrZnFE3cl/wVfK2FpRha
MIME-Version: 1.0
X-Received: by 2002:a5d:9509:: with SMTP id d9mr9523163iom.59.1571028127572;
 Sun, 13 Oct 2019 21:42:07 -0700 (PDT)
Date:   Sun, 13 Oct 2019 21:42:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000079edde0594d77dd6@google.com>
Subject: INFO: task hung in addrconf_verify_work (2)
From:   syzbot <syzbot+cf0adbb9c28c8866c788@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@gmail.com, hawk@kernel.org,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, petrm@mellanox.com,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c208bdb9 tcp: improve recv_skip_hint for tcp_zerocopy_rece..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15b6133b600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9be300620399522
dashboard link: https://syzkaller.appspot.com/bug?extid=cf0adbb9c28c8866c788
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1548666f600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11957d3b600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cf0adbb9c28c8866c788@syzkaller.appspotmail.com

INFO: task kworker/0:2:2913 blocked for more than 143 seconds.
       Not tainted 5.4.0-rc1+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/0:2     D27000  2913      2 0x80004000
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
  context_switch kernel/sched/core.c:3384 [inline]
  __schedule+0x94f/0x1e70 kernel/sched/core.c:4069
  schedule+0xd9/0x260 kernel/sched/core.c:4136
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4195
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7b0/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  rtnl_lock+0x17/0x20 net/core/rtnetlink.c:72
  addrconf_verify_work+0xe/0x20 net/ipv6/addrconf.c:4520
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Showing all locks held in the system:
1 lock held by khungtaskd/1054:
  #0: ffffffff88faae40 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x27e kernel/locking/lockdep.c:5337
3 locks held by kworker/0:2/2913:
  #0: ffff888216019428 ((wq_completion)ipv6_addrconf){+.+.}, at:  
__write_once_size include/linux/compiler.h:226 [inline]
  #0: ffff888216019428 ((wq_completion)ipv6_addrconf){+.+.}, at:  
arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: ffff888216019428 ((wq_completion)ipv6_addrconf){+.+.}, at:  
atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
  #0: ffff888216019428 ((wq_completion)ipv6_addrconf){+.+.}, at:  
atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
  #0: ffff888216019428 ((wq_completion)ipv6_addrconf){+.+.}, at:  
set_work_data kernel/workqueue.c:620 [inline]
  #0: ffff888216019428 ((wq_completion)ipv6_addrconf){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:647 [inline]
  #0: ffff888216019428 ((wq_completion)ipv6_addrconf){+.+.}, at:  
process_one_work+0x88b/0x1740 kernel/workqueue.c:2240
  #1: ffff8880a05b7dc0 ((addr_chk_work).work){+.+.}, at:  
process_one_work+0x8c1/0x1740 kernel/workqueue.c:2244
  #2: ffffffff89993b20 (rtnl_mutex){+.+.}, at: rtnl_lock+0x17/0x20  
net/core/rtnetlink.c:72
1 lock held by rsyslogd/8744:
  #0: ffff8880899fa120 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/8833:
  #0: ffff888090baedd0 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f292e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8834:
  #0: ffff88808d0f6dd0 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f392e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8835:
  #0: ffff888090148e10 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f252e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8836:
  #0: ffff8880a7ab3750 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f412e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8837:
  #0: ffff8880a7accf10 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f3d2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8838:
  #0: ffff88808d0f7650 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f352e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
2 locks held by getty/8839:
  #0: ffff88808d162bd0 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc90005f112e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x232/0x1c10 drivers/tty/n_tty.c:2156
1 lock held by syz-executor910/8859:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1054 Comm: khungtaskd Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0x9d0/0xef0 kernel/hung_task.c:289
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 8859 Comm: syz-executor910 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:arch_local_save_flags arch/x86/include/asm/paravirt.h:751 [inline]
RIP: 0010:lockdep_hardirqs_off+0x1df/0x2e0 kernel/locking/lockdep.c:3453
Code: 5c 08 00 00 5b 41 5c 41 5d 5d c3 48 c7 c0 58 1d f3 88 48 ba 00 00 00  
00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 d3 00 00 00 <48> 83 3d 21 9e  
99 07 00 0f 84 b9 00 00 00 9c 58 0f 1f 44 00 00 f6
RSP: 0018:ffff8880a6f3f1b8 EFLAGS: 00000046
RAX: 1ffffffff11e63ab RBX: ffff88808c9c6080 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffff88808c9c6914
RBP: ffff8880a6f3f1d0 R08: ffff88808c9c6080 R09: fffffbfff16be5d1
R10: fffffbfff16be5d0 R11: 0000000000000003 R12: ffffffff8746591f
R13: ffff88808c9c6080 R14: ffffffff8746591f R15: 0000000000000003
FS:  00000000011e4880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000000a8920000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  trace_hardirqs_off+0x62/0x240 kernel/trace/trace_preemptirq.c:45
  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
  _raw_spin_lock_irqsave+0x6f/0xcd kernel/locking/spinlock.c:159
  __wake_up_common_lock+0xc8/0x150 kernel/sched/wait.c:122
  __wake_up+0xe/0x10 kernel/sched/wait.c:142
  netlink_unlock_table net/netlink/af_netlink.c:466 [inline]
  netlink_unlock_table net/netlink/af_netlink.c:463 [inline]
  netlink_broadcast_filtered+0x705/0xb80 net/netlink/af_netlink.c:1514
  netlink_broadcast+0x3a/0x50 net/netlink/af_netlink.c:1534
  rtnetlink_send+0xdd/0x110 net/core/rtnetlink.c:714
  tcf_add_notify net/sched/act_api.c:1343 [inline]
  tcf_action_add+0x243/0x370 net/sched/act_api.c:1362
  tc_ctl_action+0x3b5/0x4bc net/sched/act_api.c:1410
  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5386
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5404
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440939
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeea8a8d98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440939
RDX: 0000000020000010 RSI: 0000000020001480 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 0000000000000002 R09: 00000000004002c8
R10: 0000000000000008 R11: 0000000000000246 R12: 00000000004021c0
R13: 0000000000402250 R14: 0000000000000000 R15: 0000000000000000


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
