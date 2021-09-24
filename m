Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AB5416E58
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 10:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245026AbhIXJAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:00:00 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47056 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245007AbhIXI77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 04:59:59 -0400
Received: by mail-io1-f71.google.com with SMTP id b13-20020a05660214cd00b005d6279b61fdso8926958iow.13
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 01:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=8npiF/jDNr/jkDotYVsh3O09j4eaE43P0hOP/9Ipagw=;
        b=NV6pZSz85Q8BwtDatkC7cTOxWP4lnRPexU1nx1053q1Gw5uWUYV+mWpHl8jiHbio7y
         IBHjuLBXUa5wS+/uEnxKwajtIlYLGpRWBixhaWKtzlUFZrD3k/RpbUWrmyl0B7yTyQQz
         vS2RTD5LXU0vE3b8YPdPAqwNF7UnrN4kVXw86O+QIyuu6FFBhuKTFwOWOYT/QArm+6WO
         ESE3H4t9QuMX1DRF0MnL9ns+oj/lFynD8DGZI93pCx0dy2tNaRGyaY8GSBxnLjsomwrN
         Dpfsh+s8aZq7NHtEZXEbKs6doSkLclLSE6oswQMNyY0pHCVgu/jqbW2Hw2PGQ6ig6Wp4
         DdLA==
X-Gm-Message-State: AOAM532Y+61HpWc/jwAAN9Z+q2sKysyGWubdyaDlCwsglR7kRnt/WFYt
        6rQA/nRQFnAscas53Bn7JaDIDXmRqahoYMQjBQVXFJJ7KzEc
X-Google-Smtp-Source: ABdhPJzuAfXhZDMEaHvtLrVXHZVHFI359ZJSDK1BbS6qwQMvli/fg9gKolr6ohoKmJqo2bLB9YkLFZbP5xI7RoC8cl1cSmv/xn+K
MIME-Version: 1.0
X-Received: by 2002:a92:280f:: with SMTP id l15mr6929859ilf.74.1632473906530;
 Fri, 24 Sep 2021 01:58:26 -0700 (PDT)
Date:   Fri, 24 Sep 2021 01:58:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004dcddc05ccb9f3a2@google.com>
Subject: [syzbot] riscv/fixes test error: BUG: soft lockup in corrupted
From:   syzbot <syzbot+bc48e05449f37d40eccf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7d2a07b76933 Linux 5.14
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=1021b1f3300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8211b06020972e8
dashboard link: https://syzkaller.appspot.com/bug?extid=bc48e05449f37d40eccf
compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
userspace arch: riscv64

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bc48e05449f37d40eccf@syzkaller.appspotmail.com

watchdog: BUG: soft lockup - CPU#0 stuck for 430s! [kworker/0:3:3301]
Modules linked in:
irq event stamp: 128499
hardirqs last  enabled at (128498): [<ffffffff800051a0>] restore_all+0x12/0x6e
hardirqs last disabled at (128499): [<ffffffff80005094>] _save_context+0x80/0x90
softirqs last  enabled at (45742): [<ffffffff82ba5a08>] softirq_handle_end kernel/softirq.c:401 [inline]
softirqs last  enabled at (45742): [<ffffffff82ba5a08>] __do_softirq+0x628/0x90c kernel/softirq.c:587
softirqs last disabled at (45749): [<ffffffff800369a0>] do_softirq_own_stack include/asm-generic/softirq_stack.h:10 [inline]
softirqs last disabled at (45749): [<ffffffff800369a0>] invoke_softirq kernel/softirq.c:439 [inline]
softirqs last disabled at (45749): [<ffffffff800369a0>] __irq_exit_rcu kernel/softirq.c:636 [inline]
softirqs last disabled at (45749): [<ffffffff800369a0>] irq_exit+0x1a0/0x1b6 kernel/softirq.c:660
CPU: 0 PID: 3301 Comm: kworker/0:3 Not tainted 5.14.0-syzkaller #0
Hardware name: riscv-virtio,qemu (DT)
Workqueue: events nsim_dev_trap_report_work
epc : arch_static_branch arch/riscv/include/asm/jump_label.h:20 [inline]
epc : kfence_alloc include/linux/kfence.h:120 [inline]
epc : slab_alloc_node mm/slub.c:2884 [inline]
epc : __kmalloc_node_track_caller+0xaa/0x3d2 mm/slub.c:4653
 ra : slab_pre_alloc_hook mm/slab.h:494 [inline]
 ra : slab_alloc_node mm/slub.c:2880 [inline]
 ra : __kmalloc_node_track_caller+0x70/0x3d2 mm/slub.c:4653
epc : ffffffff803e2a1a ra : ffffffff803e29e0 sp : ffffffe00e97f4d0
 gp : ffffffff83f967d8 tp : ffffffe0081a2f80 t0 : ffffffe008c0e728
 t1 : ffffffc7f07f2d69 t2 : 000000000545de2b s0 : ffffffe00e97f570
 s1 : ffffffe005601c80 a0 : 0000000000000000 a1 : 0000000000000007
 a2 : 1ffffffff07aa51f a3 : ffffffff80a9711a a4 : 0000000004000000
 a5 : 0000000000000000 a6 : 0000000000f00000 a7 : 7126f9b37a026000
 s2 : ffffffff83f96adc s3 : 0000000000082a20 s4 : 0000000000000200
 s5 : ffffffffffffffff s6 : ffffffff827d9302 s7 : ffffffff83f9a0d0
 s8 : 0000000000000000 s9 : 0000000000082a20 s10: ffffffffffffffff
 s11: 0000000000000000 t3 : 7126f9b37a026000 t4 : ffffffc7f07f2d69
 t5 : ffffffc7f07f2d6a t6 : ffffffe009428026
status: 0000000000000120 badaddr: 0000000000000000 cause: 8000000000000005
[<ffffffff803e2a1a>] slab_alloc_node mm/slub.c:2881 [inline]
[<ffffffff803e2a1a>] __kmalloc_node_track_caller+0xaa/0x3d2 mm/slub.c:4653
[<ffffffff821a8952>] kmalloc_reserve net/core/skbuff.c:355 [inline]
[<ffffffff821a8952>] __alloc_skb+0xee/0x2e2 net/core/skbuff.c:426
[<ffffffff827d9302>] alloc_skb include/linux/skbuff.h:1112 [inline]
[<ffffffff827d9302>] ndisc_alloc_skb+0x9e/0x1a0 net/ipv6/ndisc.c:420
[<ffffffff827e09d8>] ndisc_send_rs+0x24c/0x378 net/ipv6/ndisc.c:686
[<ffffffff8279c322>] addrconf_rs_timer+0x2ac/0x4c4 net/ipv6/addrconf.c:3877
[<ffffffff80123b68>] call_timer_fn+0x10e/0x654 kernel/time/timer.c:1421
[<ffffffff8012448e>] expire_timers kernel/time/timer.c:1466 [inline]
[<ffffffff8012448e>] __run_timers.part.0+0x3e0/0x442 kernel/time/timer.c:1734
[<ffffffff80124566>] __run_timers kernel/time/timer.c:1715 [inline]
[<ffffffff80124566>] run_timer_softirq+0x76/0xe0 kernel/time/timer.c:1747
[<ffffffff82ba5650>] __do_softirq+0x270/0x90c kernel/softirq.c:558
[<ffffffff800369a0>] do_softirq_own_stack include/asm-generic/softirq_stack.h:10 [inline]
[<ffffffff800369a0>] invoke_softirq kernel/softirq.c:439 [inline]
[<ffffffff800369a0>] __irq_exit_rcu kernel/softirq.c:636 [inline]
[<ffffffff800369a0>] irq_exit+0x1a0/0x1b6 kernel/softirq.c:660
[<ffffffff800e88dc>] handle_domain_irq+0x106/0x178 kernel/irq/irqdesc.c:705
[<ffffffff80af3486>] riscv_intc_irq+0x80/0xca drivers/irqchip/irq-riscv-intc.c:40
[<ffffffff8000515e>] ret_from_exception+0x0/0x14
[<ffffffff803e29e0>] slab_pre_alloc_hook mm/slab.h:494 [inline]
[<ffffffff803e29e0>] slab_alloc_node mm/slub.c:2880 [inline]
[<ffffffff803e29e0>] __kmalloc_node_track_caller+0x70/0x3d2 mm/slub.c:4653


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
