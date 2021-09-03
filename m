Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D453FFC0F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348381AbhICIdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:33:37 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:40942 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348361AbhICId3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 04:33:29 -0400
Received: by mail-il1-f199.google.com with SMTP id f13-20020a056e02168d00b002244a6aa233so3063202ila.7
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 01:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/JH5aPNUVJvcpf6o/NsWRyN1IPA9uU7shy4Wx9UIhsI=;
        b=mDnjKy03bvpyWkviRTLPvZxOUZAp5r9r68qSPKyapnnx4sgJFoaJtAV6Q+lK0egRb+
         0bqu42v5JZrlXJjOfUhUtIy1Lpj8LCY7ar3goE4WSjl/ySLFv7bGSZ3LQp+t5ZMmdGWI
         U1ltZLaGuMq7FZHJorbPBidoRoXAzQJmC5wnKjRBcbTNoTYckwx4YCIRChx6hBVWkqvD
         I4Rgj/iDmd0C/ZeJ9O38Q6ovIker4auTgZxtK6s1iKFP8euzoFRdSyogNDzD7kFW1/+b
         a6TPJYBoUjJzHfZymuoLmHhAwiPjmykfUWnoZ4j209i7yKYTMAMN9Kc4gmutuyEZoEuW
         6EKQ==
X-Gm-Message-State: AOAM532AQCcR/yxOxvdnP8Ibdd9w5zRH2a4jEtps8g8xak/oSccGk8ja
        VySck/lR2H1E9GFiO7Uztj/1G64FZunrt5tqVEm0KW3UAo5O
X-Google-Smtp-Source: ABdhPJyYfSU3LUTSUqLhK7u1MA/ll2e+NK2eaqRHuEww0sudcUf3lW6udbWG/loi17nxZ0Tc7ho3Dc+55csZwm2V+0fJ0rWnsFTQ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:25c3:: with SMTP id u3mr1728903jat.52.1630657949405;
 Fri, 03 Sep 2021 01:32:29 -0700 (PDT)
Date:   Fri, 03 Sep 2021 01:32:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d3188c05cb1323a0@google.com>
Subject: [syzbot] INFO: task hung in __lru_add_drain_all
From:   syzbot <syzbot+a9b681dcbc06eb2bca04@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, bp@alien8.de, frederic@kernel.org,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mark.rutland@arm.com, masahiroy@kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, npiggin@gmail.com,
        pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        sedat.dilek@gmail.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vitor@massaru.org, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c7d102232649 Merge tag 'net-5.14-rc4' of git://git.kernel...
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=131efc8a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bfd78f4abd4edaa6
dashboard link: https://syzkaller.appspot.com/bug?extid=a9b681dcbc06eb2bca04
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e91804300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1508bb1e300000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=102f551a300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=122f551a300000
console output: https://syzkaller.appspot.com/x/log.txt?x=142f551a300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a9b681dcbc06eb2bca04@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

INFO: task khugepaged:1663 blocked for more than 143 seconds.
      Not tainted 5.14.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:khugepaged      state:D stack:28464 pid: 1663 ppid:     2 flags:0x00004000
Call Trace:
 context_switch kernel/sched/core.c:4683 [inline]
 __schedule+0x93a/0x26f0 kernel/sched/core.c:5940
 schedule+0xd3/0x270 kernel/sched/core.c:6019
 schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1855
 do_wait_for_common kernel/sched/completion.c:85 [inline]
 __wait_for_common kernel/sched/completion.c:106 [inline]
 wait_for_common kernel/sched/completion.c:117 [inline]
 wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
 __flush_work+0x50e/0xad0 kernel/workqueue.c:3053
 __lru_add_drain_all+0x3fd/0x760 mm/swap.c:842
 khugepaged_do_scan mm/khugepaged.c:2214 [inline]
 khugepaged+0x10f/0x5590 mm/khugepaged.c:2275
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Showing all locks held in the system:
1 lock held by khungtaskd/1647:
 #0: ffffffff8b97ba40 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x260 kernel/locking/lockdep.c:6446
1 lock held by khugepaged/1663:
 #0: ffffffff8ba5e948 (lock#6){+.+.}-{3:3}, at: __lru_add_drain_all+0x65/0x760 mm/swap.c:791
1 lock held by in:imklog/8274:
 #0: ffff88801b6b4ff0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xe9/0x100 fs/file.c:974
3 locks held by kworker/1:4/8673:
3 locks held by kworker/1:5/8674:
2 locks held by syz-executor764/31172:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 1647 Comm: khungtaskd Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 nmi_cpu_backtrace.cold+0x44/0xd7 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:210 [inline]
 watchdog+0xd0a/0xfc0 kernel/hung_task.c:295
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__find_rr_leaf+0x2d4/0xd20 net/ipv6/route.c:794
Code: 08 0f 84 58 01 00 00 e8 aa 3d a0 f9 48 83 3c 24 00 74 43 e8 9e 3d a0 f9 48 8d bb 80 00 00 00 48 89 f8 48 c1 e8 03 0f b6 04 28 <84> c0 74 08 3c 03 0f 8e 49 08 00 00 44 8b a3 80 00 00 00 44 8b 74
RSP: 0018:ffffc90000d97508 EFLAGS: 00000a06
RAX: 0000000000000000 RBX: ffff88804f143400 RCX: 0000000000000100
RDX: ffff888010a7d4c0 RSI: ffffffff87d55dc2 RDI: ffff88804f143480
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff87d55d8a R11: 0000000000000000 R12: 0000000000000001
R13: ffffc90000d977f0 R14: 0000000000000000 R15: ffff88804f142aa0
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200000c0 CR3: 000000001ff23000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 find_rr_leaf net/ipv6/route.c:846 [inline]
 rt6_select net/ipv6/route.c:890 [inline]
 fib6_table_lookup+0x649/0xa20 net/ipv6/route.c:2174
 ip6_pol_route+0x1c5/0x11d0 net/ipv6/route.c:2210
 pol_lookup_func include/net/ip6_fib.h:579 [inline]
 fib6_rule_lookup+0x111/0x6f0 net/ipv6/fib6_rules.c:115
 ip6_route_input_lookup net/ipv6/route.c:2280 [inline]
 ip6_route_input+0x63c/0xb30 net/ipv6/route.c:2576
 ip6_rcv_finish_core.constprop.0.isra.0+0x168/0x570 net/ipv6/ip6_input.c:63
 ip6_rcv_finish net/ipv6/ip6_input.c:74 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x229/0x3c0 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5498
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5612
 process_backlog+0x2a5/0x6c0 net/core/dev.c:6492
 __napi_poll+0xaf/0x440 net/core/dev.c:7047
 napi_poll net/core/dev.c:7114 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7201
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:920 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:912
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
