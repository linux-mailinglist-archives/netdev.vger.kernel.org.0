Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A783622901E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 07:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgGVFxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 01:53:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:53916 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgGVFxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 01:53:21 -0400
Received: by mail-il1-f199.google.com with SMTP id r4so289888ilq.20
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 22:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MG4gD8Y6EKPwaXxhfc/Tzx5ur3udi30LP4Rb4Skua+c=;
        b=E1aN56v+f7+3To9TBRomVL7V1VuUH3K+mJzKGxJ+7yv/wySGlRtxOPMdV8hyQinZ9D
         aWIYHSCykCcfsBoFO24VXyK3a3d1I0b1Z+m75SeOZ0GvYwLvohP1k6SoQFUvG8AZ1fOZ
         17eySv5ACrkKLcitZnk6F2GIgIbz13ONwYcSYvB9zZDIpmb7OwMWWyBPdlJGuB0lRTdp
         pkfaVQbjzrMMPAihJylhPvsraVjTD12CzgnAwsjrbY6tnB7jcHWQ2wJVvxaNn8cRKXwi
         DT2QdL3J1u3SDw3hajRbL0gkzyGRfGlkwZREAwCiPGtFCO/cREkLRQYxWzy8AHutPmz0
         dq6w==
X-Gm-Message-State: AOAM5333ruPB/lylX4biAQehzDPZrOP0t4LraobUY84HcnOWKLgjN2Ks
        tTUbimSD3v7Hf2YHyKwgdwU4GKPGb8U0MySkeyuiQme8BHev
X-Google-Smtp-Source: ABdhPJywRgyXy7XvGSdoG2J9/4L3+oXZtjXCDrmCUPqsfljw2ls2WWIjkpniLzemiFCW2plFQNQpjJiuIrTbbcxhWj6mQIqrBiyE
MIME-Version: 1.0
X-Received: by 2002:a02:6381:: with SMTP id j123mr34646359jac.103.1595397199881;
 Tue, 21 Jul 2020 22:53:19 -0700 (PDT)
Date:   Tue, 21 Jul 2020 22:53:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fecaf05ab015b7a@google.com>
Subject: KMSAN: uninit-value in geneve_xmit
From:   syzbot <syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    14525656 compiler.h: reinstate missing KMSAN_INIT
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13396087100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c534a9fad6323722
dashboard link: https://syzkaller.appspot.com/bug?extid=7ebc2e088af5e4c0c9fa
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11056017100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102dbc10900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7ebc2e088af5e4c0c9fa@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in geneve_xmit_skb drivers/net/geneve.c:909 [inline]
BUG: KMSAN: uninit-value in geneve_xmit+0x2a59/0x2bf0 drivers/net/geneve.c:1005
CPU: 1 PID: 2303 Comm: kworker/1:2 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events iterate_cleanup_work
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1df/0x240 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 geneve_xmit_skb drivers/net/geneve.c:909 [inline]
 geneve_xmit+0x2a59/0x2bf0 drivers/net/geneve.c:1005
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one net/core/dev.c:3556 [inline]
 dev_hard_start_xmit+0x50e/0xa70 net/core/dev.c:3572
 __dev_queue_xmit+0x2f8d/0x3b20 net/core/dev.c:4131
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4164
 neigh_hh_output include/net/neighbour.h:498 [inline]
 neigh_output include/net/neighbour.h:507 [inline]
 ip6_finish_output2+0x2057/0x2620 net/ipv6/ip6_output.c:117
 __ip6_finish_output+0x824/0x8e0 net/ipv6/ip6_output.c:143
 ip6_finish_output+0x166/0x410 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x60a/0x770 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:443 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 mld_sendpack+0xeba/0x13d0 net/ipv6/mcast.c:1679
 mld_send_cr net/ipv6/mcast.c:1975 [inline]
 mld_ifc_timer_expire+0x1158/0x1750 net/ipv6/mcast.c:2474
 call_timer_fn+0x218/0x510 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers+0xd20/0x11c0 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x311/0x83d kernel/softirq.c:293
 asm_call_on_stack+0x12/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:23 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 do_softirq_own_stack+0x7c/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:390 [inline]
 __irq_exit_rcu+0x226/0x270 kernel/softirq.c:420
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x107/0x130 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:593
RIP: 0010:rcu_all_qs+0x1/0x240 kernel/rcu/tree_plugin.h:808
Code: 00 4c 89 ff e8 20 d2 ff ff 5b 41 5e 41 5f 5d c3 41 8b be 88 0c 00 00 e8 4d 9e 8d 00 eb c9 90 66 2e 0f 1f 84 00 00 00 00 00 55 <48> 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 20 65 48 8b 04 25 28
RSP: 0018:ffffb5cc8513bac0 EFLAGS: 00000286
RAX: 0000000080000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000016d0c
RBP: ffffb5cc8513bae0 R08: fffff1870000000f R09: ffff9ba6afffb000
R10: 0000000000000004 R11: ffffffffacbc7b70 R12: ffffffffb0221158
R13: 0000000000000000 R14: ffff9ba6a7bc46d8 R15: 0000000000000e06
 get_next_corpse net/netfilter/nf_conntrack_core.c:2239 [inline]
 nf_ct_iterate_cleanup+0x5c6/0x710 net/netfilter/nf_conntrack_core.c:2261
 nf_ct_iterate_cleanup_net+0x182/0x230 net/netfilter/nf_conntrack_core.c:2346
 iterate_cleanup_work+0x97/0x1c0 net/netfilter/nf_nat_masquerade.c:216
 process_one_work+0x1540/0x1f30 kernel/workqueue.c:2269
 worker_thread+0xed2/0x23f0 kernel/workqueue.c:2415
 kthread+0x515/0x550 kernel/kthread.c:292
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:293

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 __msan_chain_origin+0x50/0x90 mm/kmsan/kmsan_instr.c:165
 geneve_changelink+0xcbb/0xee0 drivers/net/geneve.c:1652
 __rtnl_newlink net/core/rtnetlink.c:3255 [inline]
 rtnl_newlink+0x3032/0x3900 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x1184/0x15c0 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x451/0x650 net/netlink/af_netlink.c:2469
 rtnetlink_rcv+0x50/0x60 net/core/rtnetlink.c:5478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0xf9e/0x1100 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x1246/0x14d0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x1370/0x1400 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x623/0x750 net/socket.c:2439
 __do_sys_sendmsg net/socket.c:2448 [inline]
 __se_sys_sendmsg+0x97/0xb0 net/socket.c:2446
 __x64_sys_sendmsg+0x4a/0x70 net/socket.c:2446
 do_syscall_64+0xb0/0x150 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Local variable ----df@geneve_changelink created at:
 geneve_changelink+0xfb/0xee0 drivers/net/geneve.c:1622
 geneve_changelink+0xfb/0xee0 drivers/net/geneve.c:1622
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
