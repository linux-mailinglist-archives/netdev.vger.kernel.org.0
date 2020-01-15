Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BCD13CE4A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729592AbgAOUvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:51:14 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:42684 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgAOUvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:51:13 -0500
Received: by mail-io1-f69.google.com with SMTP id e7so11186845iog.9
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 12:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vEE2HyKhkVDNRXNOyE1vYA/8ZWUBKHgQTg5sSl3HwOA=;
        b=QFrMKAH3pVLEQIw9PPXJbyzf+KyL6a7JmX0s2jTe0+gxVy083MaBch9DT/MiCghCOV
         iK6zo55MMinM32RvnpdUlnsjT5xNjK6BGMdQRQdGDEGClGrk0agRggjTNrHZMvbFo/X8
         kUwN1PZPuiM2GqsFa/ZMN3jvzIDbL0POPMLB2tmdAJwv4iOt15joo/u4obOgUOHKRgNU
         TPR2jg3HsCceSc+Oa7gEYUbtwl5Pgj9G05ImWEnv4KdQUtpbdbIPh8hF6wPzSaBjUZ5V
         H9hQepsGoLw3kx1BwkT75HeFG4bkaE2aTR/EVfL8U/7LOjubh7eUqv2oqIkLxSs5otmQ
         u1tw==
X-Gm-Message-State: APjAAAWXd2AgOWcgJIrzz3VK6T6AyySeJydHKg9KDavokNV56R+27ikb
        3Z60OQStVPAm/HX19lPMtqRhKoZQijVKoC0lrf1TIku3E/Dv
X-Google-Smtp-Source: APXvYqyQ3dTy3XEsffyTige13zIps6556crkEDYAvQ7cUxRv5OyBAXcHY6np7Du0sw+l7RfoimBiQA2WVvhpVavVILq6U7z9PYdF
MIME-Version: 1.0
X-Received: by 2002:a6b:b297:: with SMTP id b145mr24413785iof.19.1579121472791;
 Wed, 15 Jan 2020 12:51:12 -0800 (PST)
Date:   Wed, 15 Jan 2020 12:51:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007178ef059c33de66@google.com>
Subject: INFO: task hung in ovs_vport_cmd_del
From:   syzbot <syzbot+d6f697f97a60a6430fa7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    555089fd bpftool: Fix printing incorrect pointer in btf_du..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=1790e421e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=609c965f105b4789
dashboard link: https://syzkaller.appspot.com/bug?extid=d6f697f97a60a6430fa7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d6f697f97a60a6430fa7@syzkaller.appspotmail.com

INFO: task syz-executor.0:1552 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D27912  1552   9613 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  ovs_lock net/openvswitch/datapath.c:105 [inline]
  ovs_vport_cmd_del+0x77/0x770 net/openvswitch/datapath.c:2227
  genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
  genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
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
Code: e8 3c 1f 00 00 eb aa cc cc cc cc cc cc cc cc cc cc 64 48 8b 0c 25 f8  
ff ff ff 48 3b 61 10 76 40 48 83 ec 28 48 89 6c 24 20 48 <8d> 6c 24 20 48  
8b 42 10 48 8b 4a 18 48 8b 52 08 48 89 14 24 48 89
RSP: 002b:00007fbec8448c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbec84496d4
R13: 00000000004ca99c R14: 00000000004e3e08 R15: 00000000ffffffff
INFO: task syz-executor.0:1554 blocked for more than 143 seconds.
       Not tainted 5.5.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D27912  1554   9613 0x00004004
Call Trace:
  context_switch kernel/sched/core.c:3385 [inline]
  __schedule+0x934/0x1f90 kernel/sched/core.c:4081
  schedule+0xdc/0x2b0 kernel/sched/core.c:4155
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4214
  __mutex_lock_common kernel/locking/mutex.c:1033 [inline]
  __mutex_lock+0x7ab/0x13c0 kernel/locking/mutex.c:1103
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
  ovs_lock net/openvswitch/datapath.c:105 [inline]
  ovs_vport_cmd_del+0x77/0x770 net/openvswitch/datapath.c:2227
  genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
  genl_family_rcv_msg net/netlink/genetlink.c:717 [inline]
  genl_rcv_msg+0x67d/0xea0 net/netlink/genetlink.c:734
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:745
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
Code: e8 3c 1f 00 00 eb aa cc cc cc cc cc cc cc cc cc cc 64 48 8b 0c 25 f8  
ff ff ff 48 3b 61 10 76 40 48 83 ec 28 48 89 6c 24 20 48 <8d> 6c 24 20 48  
8b 42 10 48 8b 4a 18 48 8b 52 08 48 89 14 24 48 89
RSP: 002b:00007fbec8427c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbec84286d4
R13: 00000000004ca99c R14: 00000000004e3e08 R15: 00000000ffffffff

Showing all locks held in the system:
4 locks held by kworker/u4:2/90:
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
  #1: ffffc900011a7dc0 (net_cleanup_work){+.+.}, at:  
process_one_work+0x8c1/0x1740 kernel/workqueue.c:2239
  #2: ffffffff8a4c5ec8 (pernet_ops_rwsem){++++}, at: cleanup_net+0xae/0xaf0  
net/core/net_namespace.c:559
  #3: ffffffff8a72d420 (ovs_mutex){+.+.}, at: ovs_lock  
net/openvswitch/datapath.c:105 [inline]
  #3: ffffffff8a72d420 (ovs_mutex){+.+.}, at: ovs_exit_net+0x201/0xc30  
net/openvswitch/datapath.c:2469
1 lock held by khungtaskd/1124:
  #0: ffffffff899a3f80 (rcu_read_lock){....}, at:  
debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5334
2 locks held by getty/9573:
  #0: ffff888093ade090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900017fb2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9574:
  #0: ffff8880a9abd090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000179b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9575:
  #0: ffff888096c78090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000182b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9576:
  #0: ffff8880938eb090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000183b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9577:
  #0: ffff88809871e090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000180b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9578:
  #0: ffff888096c77090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc9000181b2e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by getty/9579:
  #0: ffff8882156e7090 (&tty->ldisc_sem){++++}, at:  
ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
  #1: ffffc900011342e0 (&ldata->atomic_read_lock){+.+.}, at:  
n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
2 locks held by syz-executor.0/1552:
  #0: ffffffff8a524008 (cb_lock){++++}, at: genl_rcv+0x1a/0x40  
net/netlink/genetlink.c:744
  #1: ffffffff8a72d420 (ovs_mutex){+.+.}, at: ovs_lock  
net/openvswitch/datapath.c:105 [inline]
  #1: ffffffff8a72d420 (ovs_mutex){+.+.}, at: ovs_vport_cmd_del+0x77/0x770  
net/openvswitch/datapath.c:2227
2 locks held by syz-executor.0/1554:
  #0: ffffffff8a524008 (cb_lock){++++}, at: genl_rcv+0x1a/0x40  
net/netlink/genetlink.c:744
  #1: ffffffff8a72d420 (ovs_mutex){+.+.}, at: ovs_lock  
net/openvswitch/datapath.c:105 [inline]
  #1: ffffffff8a72d420 (ovs_mutex){+.+.}, at: ovs_vport_cmd_del+0x77/0x770  
net/openvswitch/datapath.c:2227

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1124 Comm: khungtaskd Not tainted 5.5.0-rc4-syzkaller #0
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
NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
