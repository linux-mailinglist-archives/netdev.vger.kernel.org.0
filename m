Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B208B47B8
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 08:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404366AbfIQGyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 02:54:08 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:55417 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404345AbfIQGyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 02:54:08 -0400
Received: by mail-io1-f69.google.com with SMTP id r13so4214769ioj.22
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 23:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VGlXazl6lAUsA74p+9UDJGuHwr/2WJzknMCYuhIFpJc=;
        b=klt5piHE3HF2ds1+rA97WwAfty2OKNxAV2eWuD1lYm8qyxLbflafL7JR4/iSDZSvPk
         Ex49zroGUSzvJzF2DBoUFUvzbNVLP+FQf0h4SQat1KNuT+4F/bWoH1G0d16q32+b2wOe
         SXobQ7y+BWSxeJ0dsAi1cw+0RUYf1mfe2GEsLFWtjnXE64tjEoEgIZ6Yg9Bt9XZQG9Cp
         4mvf5QxsLaJk/1w6UaNw/Nmy+V8f61wHdMGbwZDe01EC/E30vGNfinjVuwfyVhoXC2M+
         T8nwpmJ2ns+tmwc6gj2Vec8TWm+ng+mXVNdiG9g1Y0GGVwJz1/HMoo3N9/EYFaab18Mp
         HO9Q==
X-Gm-Message-State: APjAAAVhWSR5MMm+Qr/Cv7t0KlERkycEMRiZV+BFIF9ui7Lim+FEv/Hi
        +rVDHagABYvYzZVKTeBZV/A7htUbl3UNEZKWaaZ4CXLnASnY
X-Google-Smtp-Source: APXvYqz4qDU2fXVsRAeclAT1Y1glYY4qn1fPxGcWPi89FjZNEiEpZhFQR1XtEAv/yCLkU65ExCVsen8zAie/Fxs3t7AwHMSVZE7O
MIME-Version: 1.0
X-Received: by 2002:a5e:9616:: with SMTP id a22mr1578110ioq.46.1568703246978;
 Mon, 16 Sep 2019 23:54:06 -0700 (PDT)
Date:   Mon, 16 Sep 2019 23:54:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb58a00592ba2f6f@google.com>
Subject: INFO: task hung in ovs_dp_cmd_new
From:   syzbot <syzbot+a9d62dbe662772066f3c@syzkaller.appspotmail.com>
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

HEAD commit:    2339cd6c bpf: fix precision tracking of stack slots
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=14707b01600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
dashboard link: https://syzkaller.appspot.com/bug?extid=a9d62dbe662772066f3c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a9d62dbe662772066f3c@syzkaller.appspotmail.com

INFO: task syz-executor.0:3410 blocked for more than 143 seconds.
       Not tainted 5.3.0-rc7+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D26056  3410  18433 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3880
  schedule+0xd9/0x260 kernel/sched/core.c:3947
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4006
  __mutex_lock_common kernel/locking/mutex.c:1007 [inline]
  __mutex_lock+0x7b0/0x13c0 kernel/locking/mutex.c:1077
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1092
  ovs_lock net/openvswitch/datapath.c:105 [inline]
  ovs_dp_cmd_new+0x579/0xea0 net/openvswitch/datapath.c:1613
  genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
  genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
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
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: Bad RIP value.
RSP: 002b:00007fa2501cdc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004598e9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa2501ce6d4
R13: 00000000004c7777 R14: 00000000004dcfd8 R15: 00000000ffffffff
INFO: task syz-executor.0:3414 blocked for more than 143 seconds.
       Not tainted 5.3.0-rc7+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D26136  3414  18433 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3880
  schedule+0xd9/0x260 kernel/sched/core.c:3947
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4006
  __mutex_lock_common kernel/locking/mutex.c:1007 [inline]
  __mutex_lock+0x7b0/0x13c0 kernel/locking/mutex.c:1077
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1092
  ovs_lock net/openvswitch/datapath.c:105 [inline]
  ovs_dp_cmd_new+0x579/0xea0 net/openvswitch/datapath.c:1613
  genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
  genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
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
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: Bad RIP value.
RSP: 002b:00007fa2501acc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004598e9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000006
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa2501ad6d4
R13: 00000000004c7777 R14: 00000000004dcfd8 R15: 00000000ffffffff
INFO: task syz-executor.0:3416 blocked for more than 144 seconds.
       Not tainted 5.3.0-rc7+ #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor.0  D25968  3416  18433 0x00000004
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3880
  schedule+0xd9/0x260 kernel/sched/core.c:3947
  schedule_preempt_disabled+0x13/0x20 kernel/sched/core.c:4006
  __mutex_lock_common kernel/locking/mutex.c:1007 [inline]
  __mutex_lock+0x7b0/0x13c0 kernel/locking/mutex.c:1077
  mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1092
  ovs_lock net/openvswitch/datapath.c:105 [inline]
  ovs_dp_cmd_new+0x579/0xea0 net/openvswitch/datapath.c:1613
  genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
  genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
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
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: 24 18 0f b6 05 2f d1 3b 01 3c 01 76 0a 48 8b 6c 24 18 48 83 c4 20 c3  
75 07 e8 63 08 fd ff 0f 0b c6 05 11 d1 3b 01 01 48 b8 00 <00> 00 00 00 00  
f0 7f 48 89 04 24 e8 a7 dd fa ff f2 0f 10 44 24 08
RSP: 002b:00007fa25018bc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004598e9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000007
RBP: 000000000075c070 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa25018c6d4
R13: 00000000004c7777 R14: 00000000004dcfd8 R15: 00000000ffffffff
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 PID: 1057 Comm: khungtaskd Not tainted 5.3.0-rc7+ #0
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
