Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E54B24FF5C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 15:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHXN61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 09:58:27 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34892 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgHXN6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 09:58:24 -0400
Received: by mail-io1-f72.google.com with SMTP id k20so6183203iog.2
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 06:58:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+V0QzvgG14Z720o2lIX3LxzlzhonjMzU55Q/hPYeJzs=;
        b=X8W4Y3jNEBBOgW+5PGBSNBVDQtApMovki8uOYZ6fLmqN8SLBNnaIcjgOzjR0eRR9jz
         As2wAEgcVwTiWGRLlgMV7hY96wqxEdDzJoCNImq5DRpDA+GgvDD468jAf2TLCrq3+RZC
         gISZSAmjnJREF9LOKDOFRqCOhy2XWXUJGFZ1vIaTOYIbo4v9X1nnDulK/ahTteUFztI3
         HJE3GVut5c2apHaACnmN7XnyqhAm7qbMvgsmSgDVtRJQIyJ27+gwpKtw1HCKnzrwPJCF
         W1/pHz6jSgwnoCPd3o9GKGT2cALPH6CqxLb14SwrMGBsRRVULj5SSyp92CrDWvdWfToJ
         OHxw==
X-Gm-Message-State: AOAM5301teLh5JDokVUrvsnBOEW551uAR8Fp8SBul7PCRxpBUBdKIfnv
        UBlTg5oPJcUw0TMqNoIFyR3/UK8yvhnyt9a4Ztis/SLBmEby
X-Google-Smtp-Source: ABdhPJz9+MNTbmYaygbznNojo1zCWjjM1cvV8uf26efNvgfqFvYArf/xzRYpvkp3qupeC3r8pUBY7AdMzFgka09oRgeWFyO2p1i1
MIME-Version: 1.0
X-Received: by 2002:a5d:8b4f:: with SMTP id c15mr4900416iot.146.1598277503540;
 Mon, 24 Aug 2020 06:58:23 -0700 (PDT)
Date:   Mon, 24 Aug 2020 06:58:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9e4bb05ad9ffaef@google.com>
Subject: KMSAN: uninit-value in skb_trim
From:   syzbot <syzbot+e4534e8c1c382508312c@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        glider@google.com, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16e3c4b6900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=e4534e8c1c382508312c
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4534e8c1c382508312c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in skb_trim+0x1f2/0x280 net/core/skbuff.c:1916
CPU: 1 PID: 8770 Comm: syz-executor.1 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 skb_trim+0x1f2/0x280 net/core/skbuff.c:1916
 ath9k_htc_rx_msg+0x5f6/0x1f50 drivers/net/wireless/ath/ath9k/htc_hst.c:453
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:638 [inline]
 ath9k_hif_usb_rx_cb+0x1841/0x1d10 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x687/0x870 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1716
 dummy_timer+0xd98/0x71c0 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
 expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
 __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:23 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:50 [inline]
 do_softirq_own_stack+0x7c/0xa0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:390 [inline]
 __irq_exit_rcu+0x226/0x270 kernel/softirq.c:420
 irq_exit_rcu+0xe/0x10 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x107/0x130 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:593
RIP: 0010:kmsan_slab_free+0x8c/0xb0 mm/kmsan/kmsan_hooks.c:109
Code: 00 00 b9 03 00 00 00 e8 12 ea ff ff be ff ff ff ff 65 0f c1 35 75 57 cc 7d ff ce 75 1a e8 6c ff 14 ff 4c 89 7d e0 ff 75 e0 9d <48> 83 c4 10 5b 41 5e 41 5f 5d c3 0f 0b 48 c7 c7 b0 63 e1 91 31 c0
RSP: 0018:ffff888036ea36e8 EFLAGS: 00000246
RAX: c38ce7a59d21d100 RBX: ffff88812f403c00 RCX: 0000000000000003
RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff8881c7f65bb0
RBP: ffff888036ea3710 R08: ffffea000000000f R09: ffff88812fffa000
R10: 0000000000000010 R11: ffffffff912007f5 R12: 0000000000000000
R13: 0000000000000000 R14: ffff8881c7f65bb0 R15: 0000000000000246
 slab_free_freelist_hook mm/slub.c:1507 [inline]
 slab_free mm/slub.c:3088 [inline]
 kfree+0x4f3/0x3000 mm/slub.c:4069
 kvfree+0x91/0xa0 mm/util.c:603
 __vunmap+0xfec/0x1080 mm/vmalloc.c:2320
 __vfree mm/vmalloc.c:2364 [inline]
 vfree+0xcc/0x1c0 mm/vmalloc.c:2394
 copy_entries_to_user net/ipv4/netfilter/ip_tables.c:867 [inline]
 get_entries net/ipv4/netfilter/ip_tables.c:1024 [inline]
 do_ipt_get_ctl+0x115c/0x11e0 net/ipv4/netfilter/ip_tables.c:1700
 nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
 nf_getsockopt+0x588/0x5e0 net/netfilter/nf_sockopt.c:122
 ip_getsockopt+0x34e/0x520 net/ipv4/ip_sockglue.c:1749
 tcp_getsockopt+0x1de/0x210 net/ipv4/tcp.c:3893
 sock_common_getsockopt+0x13a/0x170 net/core/sock.c:3221
 __sys_getsockopt+0x6c7/0x820 net/socket.c:2172
 __do_sys_getsockopt net/socket.c:2187 [inline]
 __se_sys_getsockopt+0xe1/0x100 net/socket.c:2184
 __x64_sys_getsockopt+0x62/0x80 net/socket.c:2184
 do_syscall_64+0xad/0x160 arch/x86/entry/common.c:386
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x46008a
Code: Bad RIP value.
RSP: 002b:000000000169f6b8 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 000000000169f6e0 RCX: 000000000046008a
RDX: 0000000000000041 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000749e60 R08: 000000000169f6dc R09: 0000000000004000
R10: 000000000169f740 R11: 0000000000000212 R12: 000000000169f740
R13: 0000000000000003 R14: 0000000000748a20 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xc5/0x1a0 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0xdf0/0x1030 mm/page_alloc.c:4889
 __alloc_pages include/linux/gfp.h:509 [inline]
 __alloc_pages_node include/linux/gfp.h:522 [inline]
 alloc_pages_node include/linux/gfp.h:536 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4964 [inline]
 page_frag_alloc+0x35b/0x880 mm/page_alloc.c:4994
 __netdev_alloc_skb+0x2a8/0xc90 net/core/skbuff.c:451
 __dev_alloc_skb include/linux/skbuff.h:2813 [inline]
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:620 [inline]
 ath9k_hif_usb_rx_cb+0xe5a/0x1d10 drivers/net/wireless/ath/ath9k/hif_usb.c:671
 __usb_hcd_giveback_urb+0x687/0x870 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x1cb/0x730 drivers/usb/core/hcd.c:1716
 dummy_timer+0xd98/0x71c0 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x226/0x550 kernel/time/timer.c:1404
 expire_timers+0x4fc/0x780 kernel/time/timer.c:1449
 __run_timers+0xaf4/0xd30 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x2ea/0x7f5 kernel/softirq.c:293
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
