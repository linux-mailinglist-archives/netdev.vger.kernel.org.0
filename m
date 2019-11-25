Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1F2109431
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbfKYT1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:27:11 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:41181 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYT1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:27:10 -0500
Received: by mail-io1-f71.google.com with SMTP id p2so11542931ioh.8
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 11:27:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0pwB6xZFZUiIa7pPdngbunHncqRPRycOx2CuQXbxJfU=;
        b=jB/XsA9OfBYmrD4fljASpbKj6FJhR7ips2aq4qbIcNGtJ7N06CZCMg/24DEk591Mgm
         //5FKAFEgG00mRPQ1oPwLaFh9KlTWTXKnegiYGH01aJVGLRRurGHEoizzZVkLx/hzJ8P
         27TfbBVE+IP2+2GfvT3Qv9RBoDr+unIlUr4s1YS0YiFa/I1HT9gTSZ+fzipEWR6xvQVI
         PVMNq81oeDrjsLHueL4eq5iD4iqMaLYRP0CnOaddeUNDn5KMnvSkaiqunB89myy0LoMV
         T9iGvowri1E9vgCHmgdaPDJsvn5VluJQ9ccH+B8Qsulya72l1R7YrmAuuI1+Yj805ioW
         nj0w==
X-Gm-Message-State: APjAAAVIRpAzFe5oPTOM3PuV7gZMBrzDRcrRSZthTQVVwSOrEuzWhkSd
        SjA/FClIE3KPTG3cQeOHzaC9l3FZJb2yIdAdEJ4+2tJHRqds
X-Google-Smtp-Source: APXvYqxIKl7OyHl5dcVP52YczeBQ166rk8qib62Yec4pkw0SmBtiqopCUtZS32LmNaIrz4QUg5Kz1Mbn9aixVlm/W7eYduXGYAyQ
MIME-Version: 1.0
X-Received: by 2002:a92:5d88:: with SMTP id e8mr26254637ilg.95.1574710028322;
 Mon, 25 Nov 2019 11:27:08 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:27:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dcd191059830bf9e@google.com>
Subject: INFO: rcu detected stall in dev_ioctl
From:   syzbot <syzbot+1a41521b3198c9e15c2f@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6b8a7946 Merge tag 'for_linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175973cee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4737c15fc47048f2
dashboard link: https://syzkaller.appspot.com/bug?extid=1a41521b3198c9e15c2f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1a41521b3198c9e15c2f@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (1 GPs behind) idle=e6a/1/0x4000000000000002  
softirq=14144/14145 fqs=5200
	(t=10500 jiffies g=14865 q=1519)
NMI backtrace for cpu 1
CPU: 1 PID: 10088 Comm: syz-executor.4 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
  print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
  rcu_pending kernel/rcu/tree.c:2795 [inline]
  rcu_sched_clock_irq.cold+0x4fd/0xc12 kernel/rcu/tree.c:2244
  update_process_times+0x2d/0x70 kernel/time/timer.c:1726
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x53/0x140 kernel/time/tick-sched.c:1299
  __run_hrtimer kernel/time/hrtimer.c:1514 [inline]
  __hrtimer_run_queues+0x364/0xe40 kernel/time/hrtimer.c:1576
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1638
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1110 [inline]
  smp_apic_timer_interrupt+0x160/0x610 arch/x86/kernel/apic/apic.c:1135
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:756  
[inline]
RIP: 0010:console_unlock+0xbc7/0xf10 kernel/printk/printk.c:2481
Code: f3 88 48 c1 e8 03 42 80 3c 30 00 0f 85 e4 02 00 00 48 83 3d 4a 8f 96  
07 00 0f 84 91 01 00 00 e8 3f c2 16 00 48 8b 7d 98 57 9d <0f> 1f 44 00 00  
e9 6d ff ff ff e8 2a c2 16 00 48 8b 7d 08 c7 05 dc
RSP: 0018:ffff888057b17528 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000040000 RBX: 0000000000000200 RCX: ffffc9000e7a9000
RDX: 0000000000040000 RSI: ffffffff815c94e1 RDI: 0000000000000246
RBP: ffff888057b175b0 R08: 1ffffffff14f0134 R09: fffffbfff14f0135
R10: fffffbfff14f0134 R11: ffffffff8a7809a7 R12: 0000000000000000
R13: ffffffff843e6780 R14: dffffc0000000000 R15: ffffffff895db0f0
  vprintk_emit+0x2a0/0x700 kernel/printk/printk.c:1996
  vprintk_default+0x28/0x30 kernel/printk/printk.c:2023
  vprintk_func+0x7e/0x189 kernel/printk/printk_safe.c:386
  printk+0xba/0xed kernel/printk/printk.c:2056
  batadv_tt_local_resize_to_mtu.cold+0x18/0x1e  
net/batman-adv/translation-table.c:4202
  batadv_update_min_mtu net/batman-adv/hard-interface.c:626 [inline]
  batadv_hard_if_event+0x64f/0xfa0 net/batman-adv/hard-interface.c:1056
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
  call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1668
  call_netdevice_notifiers_mtu net/core/dev.c:1717 [inline]
  dev_set_mtu_ext+0x354/0x5a0 net/core/dev.c:8014
  dev_set_mtu+0xa5/0x130 net/core/dev.c:8035
  dev_ifsioc+0x357/0xa00 net/core/dev_ioctl.c:244
  dev_ioctl+0x1b8/0xc70 net/core/dev_ioctl.c:489
  sock_do_ioctl+0x1b7/0x2f0 net/socket.c:1061
  sock_ioctl+0x3ed/0x790 net/socket.c:1189
  vfs_ioctl fs/ioctl.c:46 [inline]
  file_ioctl fs/ioctl.c:509 [inline]
  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a639
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8b5149ac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a639
RDX: 0000000020000180 RSI: 0000000000008922 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8b5149b6d4
R13: 00000000004c6652 R14: 00000000004dbae8 R15: 00000000ffffffff


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
