Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7047132AB3
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgAGQEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:04:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:34459 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbgAGQEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:04:09 -0500
Received: by mail-io1-f70.google.com with SMTP id n26so166234ioj.1
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 08:04:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=P6O1UIXF8qUEBwFc76ZyBktT9/yCfXejhmBZri+/nqk=;
        b=RaZN2i84bnMLyYBg5tzpE7XVbqBFN4lhAKnwkCvj7Luz97OEkPbUOYJ2fwqqW9998y
         +CxXMOT/oQCvdR1z7Ra4pXC40cfpkGq9OEbVlbyxJZSbbA7NDNk5Qf6eDaLLSbzrsKxU
         GEDQO8+O+9m68Mhfv3pwglyOvNLCNdmXdQ88iou/IqKGcWBPJdTT+HT0cMmmHTCpO5Lz
         6glGhu9BWTxjYdhLcPWpmCHb0XGlZZaQoupfHYvVdwkQr/HL2YUMQV4XeWIxg/IZqWop
         rmqewn8sWz8I/GsiA9xN87sNdmJaFLAvtmSuZ9Qa1Zq1pSDsm/jZeUn7c9cHREy2PmRL
         fF8A==
X-Gm-Message-State: APjAAAUwzDitxqAyR1JOWFic81m6DdyOGXApvOZZdY9mmabq00NKrXcR
        Raj00CtZTa6uoFhk8SnqiY3jgUzsLN3OimTxjIQZ4h+kvYMS
X-Google-Smtp-Source: APXvYqyoazeOxqmxmOwRPoQ7PM3knkXlMMHA32NjlhLysI2ZEekQKWCBxCSmXSX+SergGMDpzuwAKlsRzVlex4M+XqmI1MZyJbe2
MIME-Version: 1.0
X-Received: by 2002:a92:3991:: with SMTP id h17mr96920660ilf.131.1578413049023;
 Tue, 07 Jan 2020 08:04:09 -0800 (PST)
Date:   Tue, 07 Jan 2020 08:04:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000189684059b8eeda5@google.com>
Subject: INFO: task hung in ip_set_net_exit
From:   syzbot <syzbot+06b04e24a895e5e349f0@syzkaller.appspotmail.com>
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

HEAD commit:    ae608821 Merge tag 'trace-v5.5-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16a87c9ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42c82694f792b2f5
dashboard link: https://syzkaller.appspot.com/bug?extid=06b04e24a895e5e349f0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+06b04e24a895e5e349f0@syzkaller.appspotmail.com

INFO: task kworker/u4:3:178 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u4:3    D24840   178      2 0x80004000
Workqueue: netns cleanup_net
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  nfnl_lock+0x24/0x30 net/netfilter/nfnetlink.c:62
  ip_set_net_exit+0x19d/0x5c0 net/netfilter/ipset/ip_set_core.c:2385
  ops_exit_list.isra.0+0xb1/0x160 net/core/net_namespace.c:172
  cleanup_net+0x538/0xaf0 net/core/net_namespace.c:597
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Showing all locks held in the system:
4 locks held by kworker/u4:3/178:
  #0: ffff88821b78e528 ((wq_completion)netns){+.+.}, at: __write_once_size  
include/linux/compiler.h:226 [inline]
  #0: ffff88821b78e528 ((wq_completion)netns){+.+.}, at: arch_atomic64_set  
arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: ffff88821b78e528 ((wq_completion)netns){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:855 [inline]
  #0: ffff88821b78e528 ((wq_completion)netns){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:40 [inline]
  #0: ffff88821b78e528 ((wq_completion)netns){+.+.}, at: set_work_data  
kernel/workqueue.c:615 [inline]
  #0: ffff88821b78e528 ((wq_completion)netns){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
  #0: ffff88821b78e528 ((wq_completion)netns){+.+.}, at:  
process_one_work+0x88b/0x1740 kernel/workqueue.c:2235
  #1: ffffc900012c7dc0 (net_cleanup_work){+.+.}, at:  
process_one_work+0x8c1/0x1740 kernel/workqueue.c:2239
  #2: ffffffff8a4cc508 (pernet_ops_rwsem){++++}, at: cleanup_net+0xae/0xaf0  
net/core/net_namespace.c:559
  #3: ffffffff8c1ce950 (&table[i].mutex){+.+.}, at: nfnl_lock+0x24/0x30  
net/netfilter/nfnetlink.c:62
1 lock held by khungtaskd/1132:
  #0: ffffffff899a5600 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
1 lock held by rsyslogd/9616:
  #0: ffff8880a9039da0 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/9706:
  #0: ffff888099ced090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017fb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9707:
  #0: ffff8880a20a4090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000180b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9708:
  #0: ffff88809f1cc090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000182b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9709:
  #0: ffff88808e5ae090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000178b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9710:
  #0: ffff8880a667e090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017eb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9711:
  #0: ffff88809824a090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000181b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9712:
  #0: ffff888099150090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000176b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by syz-executor.1/23662:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 1132 Comm: khungtaskd Not tainted 5.5.0-rc5-syzkaller #0
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
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.054  
msecs
NMI backtrace for cpu 0
CPU: 0 PID: 23662 Comm: syz-executor.1 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:752  
[inline]
RIP: 0010:lock_acquire+0x20b/0x410 kernel/locking/lockdep.c:4488
Code: 94 08 00 00 00 00 00 00 48 c1 e8 03 80 3c 10 00 0f 85 d3 01 00 00 48  
83 3d d9 23 38 08 00 0f 84 53 01 00 00 48 8b 7d c8 57 9d <0f> 1f 44 00 00  
48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 65 8b
RSP: 0018:ffffc90001636fb0 EFLAGS: 00000282
RAX: 1ffffffff132669b RBX: ffff8880a25120c0 RCX: ffffffff815ab610
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: 0000000000000282
RBP: ffffc90001636ff8 R08: 1ffffffff165f1ac R09: fffffbfff165f1ad
R10: ffff8880a25129a8 R11: ffff8880a25120c0 R12: ffffffff899a5600
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
FS:  00007f76318f6700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000000940fe000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
  rcu_read_lock include/linux/rcupdate.h:617 [inline]
  cond_resched_rcu include/linux/sched.h:1800 [inline]
  hash_ipmark6_list+0x33c/0x1130 net/netfilter/ipset/ip_set_hash_gen.h:1133
  ip_set_dump_start+0x96c/0x1ca0 net/netfilter/ipset/ip_set_core.c:1632
  netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2244
  __netlink_dump_start+0x66a/0x930 net/netlink/af_netlink.c:2352
  netlink_dump_start include/linux/netlink.h:233 [inline]
  ip_set_dump+0x15a/0x1d0 net/netfilter/ipset/ip_set_core.c:1690
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg net/socket.c:2424 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f76318f5c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f76318f66d4
R13: 00000000004c9de9 R14: 00000000004e2e20 R15: 00000000ffffffff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
