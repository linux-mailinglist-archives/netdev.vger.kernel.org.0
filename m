Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E9B1DF3B5
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 03:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbgEWBFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 21:05:17 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:52483 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731233AbgEWBFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 21:05:15 -0400
Received: by mail-il1-f197.google.com with SMTP id m7so10076013ill.19
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 18:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=52CrS5QEMcHd9zQJEQg9C171vsIWKoNN/8pI3PWDpvo=;
        b=k8kpi4MjyRubiKQ5iPOvPhNHUZFYVhX0ZgQEX5ckhPqEyPNKjmcFw2QFPOWPqV579i
         BVsllrBvqKMrpVec2KUAc+enht/My/5w/WQRti9zLGWff+c/p5lHkeShZzEQ+456cYPf
         SVrgBQIHCx5IM1p/zOp8XJwmoQDbpIfWUzknQdy0qjNhx00gwTYl5QeU0q1U+szdgnVa
         LJ+Czy/P+OKlPNEq+DgFWV6jSud5kHC75jW7YwCdYtq1u6EpJ1Ug/+yXahdS4zr3eQt8
         EanOfU6JWrbr85bEKH6ZcxsyYLcQeg0RAck/GGEV3q2RM9VQpfnXMrdFmM5pNb8OblaZ
         6CNQ==
X-Gm-Message-State: AOAM530CwYV0Z5A/F7bgLqK/W0+od4YVDW5/kzBO6puMBA/1XF12KCuf
        V91CT9QpRs+5XEGj4p13m6+kvtU4/494/9dvrJP1uQMEWLXT
X-Google-Smtp-Source: ABdhPJxCewz5rBn3eCMhT0IYTPtJVV7uLNVuSLZYxsIyzO8Qqd8ZUSP2om/LjHaEgvRoCK5ay1Zk6nDqUFdCqZtHYZ/yzEuaLCat
MIME-Version: 1.0
X-Received: by 2002:a5d:938a:: with SMTP id c10mr5340687iol.157.1590195913706;
 Fri, 22 May 2020 18:05:13 -0700 (PDT)
Date:   Fri, 22 May 2020 18:05:13 -0700
In-Reply-To: <0000000000007f8ce405a5d9c010@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f4fb905a6465633@google.com>
Subject: Re: KASAN: slab-out-of-bounds Read in ath9k_hif_usb_rx_cb
From:   syzbot <syzbot+c15a0a825788b6ba2bc4@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    806d8acc USB: dummy-hcd: use configurable endpoint naming ..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=113b269a100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d800e9bad158025f
dashboard link: https://syzkaller.appspot.com/bug?extid=c15a0a825788b6ba2bc4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1060eee2100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1022b6e2100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c15a0a825788b6ba2bc4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:580 [inline]
BUG: KASAN: slab-out-of-bounds in ath9k_hif_usb_rx_cb+0xad3/0xf90 drivers/net/wireless/ath/ath9k/hif_usb.c:666
Read of size 4 at addr ffff8881c2f5c0dc by task kworker/0:8/398

CPU: 0 PID: 398 Comm: kworker/0:8 Not tainted 5.7.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:382
 __kasan_report.cold+0x37/0x92 mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:580 [inline]
 ath9k_hif_usb_rx_cb+0xad3/0xf90 drivers/net/wireless/ath/ath9k/hif_usb.c:666
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
 dummy_timer+0x125e/0x32b4 drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x1ac/0x700 kernel/time/timer.c:1405
 expire_timers kernel/time/timer.c:1450 [inline]
 __run_timers kernel/time/timer.c:1774 [inline]
 __run_timers kernel/time/timer.c:1741 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1787
 __do_softirq+0x21e/0x9aa kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1140
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:_raw_spin_unlock_irq+0x27/0x30 kernel/locking/spinlock.c:200
Code: 44 00 00 55 48 8b 74 24 08 48 89 fd 48 8d 7f 18 e8 1e b4 90 fb 48 89 ef e8 b6 b0 91 fb e8 a1 54 af fb fb 65 ff 0d 51 ca 6b 7a <5d> c3 0f 1f 80 00 00 00 00 55 48 89 fd 48 83 c7 18 53 48 89 f3 48
RSP: 0018:ffff8881cd6175e8 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffff8881c1d04a40 RCX: 1ffffffff1270ab2
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881c1d052bc
RBP: ffff8881db234900 R08: 0000000000000001 R09: fffffbfff126c8c8
R10: ffffffff8936463f R11: fffffbfff126c8c7 R12: ffff8881db234900
R13: ffff8881ce3ee300 R14: 0000000000000000 R15: 0000000000000001
 finish_lock_switch kernel/sched/core.c:3106 [inline]
 finish_task_switch+0x11d/0x5d0 kernel/sched/core.c:3206
 context_switch kernel/sched/core.c:3370 [inline]
 __schedule+0x89a/0x1d80 kernel/sched/core.c:4083
 preempt_schedule_common+0x30/0x60 kernel/sched/core.c:4239
 _cond_resched+0x18/0x20 kernel/sched/core.c:5624
 start_flush_work kernel/workqueue.c:2980 [inline]
 __flush_work+0x117/0xa90 kernel/workqueue.c:3044
 __cancel_work_timer+0x32c/0x460 kernel/workqueue.c:3132
 rhashtable_free_and_destroy+0x29/0x8b0 lib/rhashtable.c:1130
 ieee80211_free_hw+0xab/0x270 net/mac80211/main.c:1407
 ath9k_htc_probe_device+0x1c2/0x1da0 drivers/net/wireless/ath/ath9k/htc_drv_init.c:972
 ath9k_htc_hw_init+0x31/0x60 drivers/net/wireless/ath/ath9k/htc_hst.c:501
 ath9k_hif_usb_firmware_cb+0x274/0x510 drivers/net/wireless/ath/ath9k/hif_usb.c:1187
 request_firmware_work_func+0x126/0x242 drivers/base/firmware_loader/main.c:1005
 process_one_work+0x965/0x1630 kernel/workqueue.c:2268
 worker_thread+0x96/0xe20 kernel/workqueue.c:2414
 kthread+0x326/0x430 kernel/kthread.c:268
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:351

Allocated by task 150:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 slab_post_alloc_hook mm/slab.h:586 [inline]
 slab_alloc_node mm/slub.c:2797 [inline]
 slab_alloc mm/slub.c:2805 [inline]
 kmem_cache_alloc+0xd8/0x300 mm/slub.c:2810
 getname_flags fs/namei.c:138 [inline]
 getname_flags+0xd2/0x5b0 fs/namei.c:128
 do_sys_openat2+0x3fc/0x7d0 fs/open.c:1142
 do_sys_open+0xc3/0x140 fs/open.c:1164
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 150:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:456
 slab_free_hook mm/slub.c:1455 [inline]
 slab_free_freelist_hook mm/slub.c:1488 [inline]
 slab_free mm/slub.c:3045 [inline]
 kmem_cache_free+0x9b/0x360 mm/slub.c:3061
 putname+0xe1/0x120 fs/namei.c:259
 do_sys_openat2+0x467/0x7d0 fs/open.c:1157
 do_sys_open+0xc3/0x140 fs/open.c:1164
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

The buggy address belongs to the object at ffff8881c2f5b300
 which belongs to the cache names_cache of size 4096
The buggy address is located 3548 bytes inside of
 4096-byte region [ffff8881c2f5b300, ffff8881c2f5c300)
The buggy address belongs to the page:
page:ffffea00070bd600 refcount:1 mapcount:0 mapping:00000000b9a8a87e index:0x0 head:ffffea00070bd600 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da11e000
raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881c2f5bf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881c2f5c000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881c2f5c080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff8881c2f5c100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881c2f5c180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

