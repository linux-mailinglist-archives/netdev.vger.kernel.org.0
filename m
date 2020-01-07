Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F27D132AAE
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbgAGQDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:03:24 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:53028 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728355AbgAGQDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:03:11 -0500
Received: by mail-io1-f70.google.com with SMTP id d10so119381iod.19
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 08:03:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2eCr8CQa1i9aXAOljidcoyBofszBf4Q85pZOBuZrhhI=;
        b=FWRcFhEGt9FUM0J21qzGW6feI+ER40nGdNJk4mpFNK769B7J5kukMPEGckq/ISOjog
         +kDLpUDkSrmqqOLaA44ENSPc2ewZyyxgUUOS2sqjhK/N0EPz+byeGMEOXcvJ9t1VDHoG
         qF15lrsB/5ZyteGaxc0ONM3Gv1mjFWW15M36k4jePVvRuAYJ2MZAaoVlWAVDY4zk9Gog
         +TW/IoC1m7/GOt0R699N73NKUv7sYkLpykWa6icq9Zoi98bk00mPzrgkJhI7HnuCCWxz
         AO5d1bt2231Rc0sh+nnl3SMEImha4oPGAFa5hR88IJkRKOxKcZPsGkQg7SfwJbdNkMzQ
         kB2A==
X-Gm-Message-State: APjAAAUkfwIcUjL/EP+pO669ipfyXQx+GoffCl9GYfpWcvA1MbF2fowM
        M6JB3oAyWipL0q9TUhmzj9GNS/gUqvVXqNFSzllXx+q9iG9n
X-Google-Smtp-Source: APXvYqzsktqqroqYCK6ESEUPJhituXtCFZUltXceflvDlSymPMNkdzooX+fhsBiSSJxqn0kJSzcrmshB7513PMCofazD5G0z5FpO
MIME-Version: 1.0
X-Received: by 2002:a6b:6219:: with SMTP id f25mr60213611iog.248.1578412990683;
 Tue, 07 Jan 2020 08:03:10 -0800 (PST)
Date:   Tue, 07 Jan 2020 08:03:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009e62b6059b8ee95b@google.com>
Subject: INFO: task hung in nfnetlink_rcv_msg
From:   syzbot <syzbot+da20e617ce568adf13f3@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=111ad2aee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42c82694f792b2f5
dashboard link: https://syzkaller.appspot.com/bug?extid=da20e617ce568adf13f3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+da20e617ce568adf13f3@syzkaller.appspotmail.com

INFO: task syz-executor.3:5313 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc5-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.3  D28224  5313  10256 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  nfnl_lock net/netfilter/nfnetlink.c:62 [inline]
  nfnetlink_rcv_msg+0x9ee/0xfb0 net/netfilter/nfnetlink.c:224
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
Code: Bad RIP value.
RSP: 002b:00007fae3575cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 0000000020001080 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fae3575d6d4
R13: 00000000004c9d34 R14: 00000000004e2d78 R15: 00000000ffffffff

Showing all locks held in the system:
1 lock held by khungtaskd/1129:
  #0: ffffffff899a5600 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
1 lock held by rsyslogd/10082:
  #0: ffff8880a71ce920 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110  
fs/file.c:801
2 locks held by getty/10204:
  #0: ffff888095e24090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000196b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10205:
  #0: ffff88809f73f090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900019eb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10206:
  #0: ffff888096ee1090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900019bb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10207:
  #0: ffff88807b2db090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900019db2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10208:
  #0: ffff888094ea8090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900019ab2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10209:
  #0: ffff8880a3bcf090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900019cb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/10210:
  #0: ffff888098119090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000192b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by syz-executor.0/5300:
1 lock held by syz-executor.3/5313:
  #0: ffffffff8c1ce950 (&table[i].mutex){+.+.}, at: nfnl_lock  
net/netfilter/nfnetlink.c:62 [inline]
  #0: ffffffff8c1ce950 (&table[i].mutex){+.+.}, at:  
nfnetlink_rcv_msg+0x9ee/0xfb0 net/netfilter/nfnetlink.c:224
1 lock held by syz-executor.2/5332:
  #0: ffffffff8c1ce950 (&table[i].mutex){+.+.}, at: nfnl_lock  
net/netfilter/nfnetlink.c:62 [inline]
  #0: ffffffff8c1ce950 (&table[i].mutex){+.+.}, at:  
nfnetlink_rcv_msg+0x9ee/0xfb0 net/netfilter/nfnetlink.c:224

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1129 Comm: khungtaskd Not tainted 5.5.0-rc5-syzkaller #0
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
Sending NMI from CPU 0 to CPUs 1:
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.041  
msecs
NMI backtrace for cpu 1
CPU: 1 PID: 5300 Comm: syz-executor.0 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:rcu_is_watching+0xb/0x30 kernel/rcu/tree.c:922
Code: 4c 89 e7 e8 c7 37 50 00 eb df 48 89 45 e8 e8 dc 37 50 00 48 8b 45 e8  
eb 8e 66 0f 1f 44 00 00 55 48 89 e5 65 ff 05 ed 6f 9f 7e <e8> 40 ff ff ff  
83 f0 01 65 ff 0d de 6f 9f 7e 74 02 5d c3 e8 fe ba
RSP: 0000:ffffc900054e6fd8 EFLAGS: 00000282
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90001e19000
RDX: 0000000000040000 RSI: ffffffff8682d444 RDI: 0000000000000001
RBP: ffffc900054e6fd8 R08: ffff88802a2f60c0 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 0000000010000000
R13: 0000000000000001 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007fb27e141700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045af1f CR3: 00000000a4684000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  rcu_read_unlock include/linux/rcupdate.h:667 [inline]
  cond_resched_rcu include/linux/sched.h:1798 [inline]
  hash_netiface4_list+0xfe9/0x13b0 net/netfilter/ipset/ip_set_hash_gen.h:1133
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
RSP: 002b:00007fb27e140c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 00000000200008c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb27e1416d4
R13: 00000000004c9de9 R14: 00000000004e2e20 R15: 00000000ffffffff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
