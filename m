Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC6A3A436
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 09:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbfFIHnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 03:43:06 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:35177 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbfFIHnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 03:43:06 -0400
Received: by mail-it1-f198.google.com with SMTP id j10so2204750itb.0
        for <netdev@vger.kernel.org>; Sun, 09 Jun 2019 00:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yAicNkdscf5kQvfc6bxK37dI5ehTFzMYc0sm+btwdgk=;
        b=VKFNSfBikKFGsVbRQ7VQwx2iaoBQuUWgis6702hm6lQVb3JvlxzH2ha8bfZ64iv9Xw
         aAgawuzxq2YUTsVTNLRaXIbpYZ2W+HhdfTOHJZBTI1N6ineC2OB4nAYEwEFNTaMsD1Uy
         bzGYadJ7qkd5hFM5OZoFrjaSTmEmZPHtt1FTNFjmOQx/IWmNFnAa8S7L/FC1+7pl8fZa
         2K75d/KI3dpjMWs0ftH7TIisV4sWrDFGJYOPmId4M1JYJM8NBUSNz67E+zSPO70LwaJM
         VkaRdznqx8OHtRwNErK4ezbKoxI8KgPAn35iKTYqyNE4V8HxIeStHeaOccW0izPNIIm+
         U+JA==
X-Gm-Message-State: APjAAAWEDU2DF07+/JCqTyIVlv2tfd6WA2mupuP0tSBGwJ77zTjWe8WF
        3G8Q0wNheftI/x23NN1laPJdSS2kiAx71GxPrvj3GxSS2O5O
X-Google-Smtp-Source: APXvYqwJqV/z7ETtI3lH4fclpJ6A82UOp6ufZE3FvO3cs5au1b6W15lxoeSFd2QKY+hlR00vt1KmKHcsWBn2gZwoVWs/OJdYJEU2
MIME-Version: 1.0
X-Received: by 2002:a05:660c:1cf:: with SMTP id s15mr9779331itk.78.1560066185465;
 Sun, 09 Jun 2019 00:43:05 -0700 (PDT)
Date:   Sun, 09 Jun 2019 00:43:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cf98fa058adf3615@google.com>
Subject: INFO: rcu detected stall in rose_loopback_timer (2)
From:   syzbot <syzbot+d37efb0ca1b82682326e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    720f1de4 pktgen: do not sleep with the thread lock held.
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=154dc971a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4f721a391cd46ea
dashboard link: https://syzkaller.appspot.com/bug?extid=d37efb0ca1b82682326e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d37efb0ca1b82682326e@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-...!: (1 GPs behind) idle=066/1/0x4000000000000004  
softirq=187193/187194 fqs=6
	(t=10501 jiffies g=300401 q=147)
rcu: rcu_preempt kthread starved for 10489 jiffies! g300401 f0x0  
RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=1
rcu: RCU grace-period kthread stack dump:
rcu_preempt     I29056    10      2 0x80004000
Call Trace:
  context_switch kernel/sched/core.c:2818 [inline]
  __schedule+0x7cb/0x1560 kernel/sched/core.c:3445
  schedule+0xa8/0x260 kernel/sched/core.c:3509
  schedule_timeout+0x486/0xc50 kernel/time/timer.c:1807
  rcu_gp_fqs_loop kernel/rcu/tree.c:1589 [inline]
  rcu_gp_kthread+0x9b2/0x18b0 kernel/rcu/tree.c:1746
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
NMI backtrace for cpu 0
CPU: 0 PID: 8284 Comm: syz-executor.4 Not tainted 5.2.0-rc2+ #44
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x63/0xa4 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1be/0x236 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree_stall.h:254
  print_cpu_stall kernel/rcu/tree_stall.h:455 [inline]
  check_cpu_stall kernel/rcu/tree_stall.h:529 [inline]
  rcu_pending kernel/rcu/tree.c:2625 [inline]
  rcu_sched_clock_irq.cold+0x4d1/0xbfd kernel/rcu/tree.c:2161
  update_process_times+0x32/0x80 kernel/time/timer.c:1639
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:167
  tick_sched_timer+0x47/0x130 kernel/time/tick-sched.c:1298
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x33b/0xdd0 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1041 [inline]
  smp_apic_timer_interrupt+0x111/0x550 arch/x86/kernel/apic/apic.c:1066
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
RIP: 0010:get_current arch/x86/include/asm/current.h:15 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x50 kernel/kcov.c:101
Code: f4 ff ff ff e8 3d 11 ea ff 48 c7 05 de 6a f5 08 00 00 00 00 e9 a4 e9  
ff ff 90 90 90 90 90 90 90 90 90 55 48 89 e5 48 8b 75 08 <65> 48 8b 04 25  
c0 fd 01 00 65 8b 15 00 59 91 7e 81 e2 00 01 1f 00
RSP: 0018:ffff8880ae809c70 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffff1100cce5825 RBX: dffffc0000000000 RCX: ffffffff864acc36
RDX: 0000000000000100 RSI: ffffffff864acbfd RDI: ffff88806672c128
RBP: ffff8880ae809c70 R08: ffff8880491a02c0 R09: ffffed1015d0137e
R10: ffffed1015d0137d R11: 0000000000000003 R12: ffff88806672c128
R13: 00000000fffff034 R14: ffff88809afb4000 R15: 0000000000000000
  rose_find_socket+0x7d/0x120 net/rose/af_rose.c:281
  rose_loopback_timer+0x336/0x480 net/rose/rose_loopback.c:94
  call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
  __do_softirq+0x25c/0x94c kernel/softirq.c:293
  invoke_softirq kernel/softirq.c:374 [inline]
  irq_exit+0x180/0x1d0 kernel/softirq.c:414
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x13b/0x550 arch/x86/kernel/apic/apic.c:1068
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
  </IRQ>
RIP: 0010:debug_lockdep_rcu_enabled+0x26/0xa0 kernel/rcu/update.c:236
Code: 00 00 00 00 48 c7 c0 64 88 80 89 55 48 ba 00 00 00 00 00 fc ff df 48  
89 c1 83 e0 07 48 89 e5 48 c1 e9 03 83 c0 03 0f b6 14 11 <38> d0 7c 04 84  
d2 75 49 8b 15 80 fc 22 08 85 d2 74 3b 48 c7 c0 74
RSP: 0018:ffff8880671c7668 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffffea0001b56940 RCX: 1ffffffff130110c
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000286
RBP: ffff8880671c7668 R08: 00000000d22d0c1d R09: ffff8880491a0b88
R10: ffff8880491a0b68 R11: ffff8880491a02c0 R12: ffffea0001b56940
R13: ffffea0001b56948 R14: 0000000000000000 R15: dead000000000100
  rcu_read_lock+0x2e/0x70 include/linux/rcupdate.h:596
  lock_page_memcg+0x19/0x1d0 mm/memcontrol.c:1984
  page_remove_file_rmap mm/rmap.c:1218 [inline]
  page_remove_rmap+0x53d/0x1090 mm/rmap.c:1303
  zap_pte_range mm/memory.c:1093 [inline]
  zap_pmd_range mm/memory.c:1195 [inline]
  zap_pud_range mm/memory.c:1224 [inline]
  zap_p4d_range mm/memory.c:1245 [inline]
  unmap_page_range+0xd3b/0x22f0 mm/memory.c:1266
  unmap_single_vma+0x19d/0x300 mm/memory.c:1311
  unmap_vmas+0x135/0x280 mm/memory.c:1343
  exit_mmap+0x2ad/0x510 mm/mmap.c:3145
  __mmput kernel/fork.c:1059 [inline]
  mmput+0x15f/0x4c0 kernel/fork.c:1080
  exit_mm kernel/exit.c:547 [inline]
  do_exit+0x816/0x2fa0 kernel/exit.c:864
  do_group_exit+0x135/0x370 kernel/exit.c:981
  get_signal+0x41e/0x2240 kernel/signal.c:2638
  do_signal+0x87/0x1900 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x244/0x2c0 arch/x86/entry/common.c:164
  prepare_exit_to_usermode arch/x86/entry/common.c:199 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
  do_syscall_64+0x58e/0x680 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f568e65ecf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: 0000000000000001 RBX: 000000000075bf28 RCX: 0000000000459279
RDX: 00000000004c7f9b RSI: 0000000000000081 RDI: 000000000075bf2c
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000211d49 R11: 0000000000000246 R12: 000000000075bf2c
R13: 00007ffd5e3d782f R14: 00007f568e65f9c0 R15: 000000000075bf2c


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
