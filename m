Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6A35EAF5D
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiIZSMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiIZSMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:12:35 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078107F26C
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:00:39 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id i13-20020a056e02152d00b002f58aea654fso5786423ilu.20
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:00:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=rPCZ4NlooWTWTLZLbZ5NOeFu5089KNOiy8KvDLb9sx8=;
        b=sJpHlx9pXzqnp09874UHRdudgHA73yLykmLNNBI6ZeBSIznbsGk1vyKNknfCDLw28i
         H7QIA0VZwV32g5PR7AhDi5kt8NDemmy4mfUb6AP4y3KfLt/PprGiXxY/AE5CTbbPWUnO
         KxOzLosIy5Hajr+9NS6DcdIKkoTax96pEG2mWO+cUu08qxjWGXo/jtyZbybpMBnqD5dl
         w7hdCvG8xO7bk6kZ3uHlLVAKqc5kgA89Or/0naBoRL+MEE5Sg5sssZImdvurPvHkng3P
         F61PYpD0ochZYaJ377R995N59pZHylQVzshubmVMOZ2OlbRUi+2Wj5ypEgwS2FoSdxDF
         EfVA==
X-Gm-Message-State: ACrzQf1Oi5cVQ3H5UpOznJestWc57uCEVK8DFKw0YhT/XBwYCA/LyGVE
        s594IDzRTmZb7XDZ0tGrQ5wUVMwt8ds0crlo40KeP+97x6f0
X-Google-Smtp-Source: AMsMyM64+n2XPr2uXtGb6fTwk7ADVVwn8cyLcrJlNWED24SIGSMaOj3J/dWEYxOkCG6aend028RUycfTW9T4z5COqlR8O8xp38AQ
MIME-Version: 1.0
X-Received: by 2002:a92:730c:0:b0:2f5:7dd7:45f7 with SMTP id
 o12-20020a92730c000000b002f57dd745f7mr10758240ilc.12.1664215238406; Mon, 26
 Sep 2022 11:00:38 -0700 (PDT)
Date:   Mon, 26 Sep 2022 11:00:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001d7a5505e9984eb0@google.com>
Subject: [syzbot] KASAN: use-after-free Read in ar5523_cmd_tx_cb
From:   syzbot <syzbot+95001b1fd6dfcc716c29@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, pontus.fuchs@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    80e19f34c288 Merge tag 'hte/for-5.19' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=134ba072080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a01cb298f103d7e3
dashboard link: https://syzkaller.appspot.com/bug?extid=95001b1fd6dfcc716c29
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120c5c74080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1511a9fc080000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=103b1cfc080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=123b1cfc080000
console output: https://syzkaller.appspot.com/x/log.txt?x=143b1cfc080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+95001b1fd6dfcc716c29@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in ar5523_cmd_tx_cb+0x220/0x240 drivers/net/wireless/ath/ar5523/ar5523.c:228
Read of size 8 at addr ffff88801f6533f0 by task syz-executor407/3622

CPU: 0 PID: 3622 Comm: syz-executor407 Not tainted 5.19.0-rc7-syzkaller-00002-g80e19f34c288 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 ar5523_cmd_tx_cb+0x220/0x240 drivers/net/wireless/ath/ar5523/ar5523.c:228
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1747
 dummy_timer+0x11f9/0x32b0 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x679/0xa80 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1106
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:do_raw_read_lock+0x2c/0x80 kernel/locking/spinlock_debug.c:160
Code: 00 00 00 00 00 fc ff df 55 48 89 fd 48 83 c7 08 48 89 fa 48 c1 ea 03 0f b6 04 02 84 c0 74 04 3c 03 7e 4c 81 7d 08 ed 1e af de <75> 20 be 04 00 00 00 48 89 ef e8 95 55 68 00 b8 00 02 00 00 f0 0f
RSP: 0018:ffffc9000301fdc8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88807497d880 RCX: ffffffff815e077e
RDX: 1ffffffff1741411 RSI: 0000000000000001 RDI: ffffffff8ba0a088
RBP: ffffffff8ba0a080 R08: 0000000000000000 R09: ffffffff90684917
R10: fffffbfff20d0922 R11: 0000000000000001 R12: 0000000000000004
R13: 0000000008000000 R14: 0000000000000000 R15: ffff88807497ddf0
 ptrace_stop.part.0+0x2fd/0xa80 kernel/signal.c:2281
 ptrace_stop kernel/signal.c:2232 [inline]
 ptrace_do_notify+0x215/0x2b0 kernel/signal.c:2344
 ptrace_notify+0xc4/0x140 kernel/signal.c:2356
 ptrace_report_syscall include/linux/ptrace.h:420 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:482 [inline]
 syscall_exit_work kernel/entry/common.c:249 [inline]
 syscall_exit_to_user_mode_prepare+0xdb/0x230 kernel/entry/common.c:276
 __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
 syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fcf032a8fe3
Code: c7 c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb ba 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
RSP: 002b:00007ffd45f11e48 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007fcf032a8fe3
RDX: 0000000000000004 RSI: 00007ffd45f11e70 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 00007ffd45f11dc0
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd45f11e70
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

The buggy address belongs to the physical page:
page:ffffea00007d94c0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1f653
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 0000000000000000 ffffea00007d94c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 2, migratetype Unmovable, gfp_mask 0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), pid 2989, tgid 2989 (kworker/0:3), ts 45677389093, free_ts 47726640493
 prep_new_page mm/page_alloc.c:2456 [inline]
 get_page_from_freelist+0x1290/0x3b70 mm/page_alloc.c:4198
 __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 kmalloc_order+0x34/0xf0 mm/slab_common.c:945
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:961
 kmalloc include/linux/slab.h:605 [inline]
 kzalloc include/linux/slab.h:733 [inline]
 wiphy_new_nm+0x6f0/0x2080 net/wireless/core.c:440
 ieee80211_alloc_hw_nm+0x373/0x2270 net/mac80211/main.c:585
 ieee80211_alloc_hw include/net/mac80211.h:4412 [inline]
 ar5523_probe+0x121/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:1595
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:555 [inline]
 really_probe+0x23e/0xb90 drivers/base/dd.c:634
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:764
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:794
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:917
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1e4/0x530 drivers/base/dd.c:989
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1371 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1421
 free_unref_page_prepare mm/page_alloc.c:3343 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3438
 device_release+0x9f/0x240 drivers/base/core.c:2241
 kobject_cleanup lib/kobject.c:673 [inline]
 kobject_release lib/kobject.c:704 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:721
 put_device+0x1b/0x30 drivers/base/core.c:3535
 ar5523_probe+0x1338/0x1da0 drivers/net/wireless/ath/ar5523/ar5523.c:1719
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:555 [inline]
 really_probe+0x23e/0xb90 drivers/base/dd.c:634
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:764
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:794
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:917
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x1e4/0x530 drivers/base/dd.c:989
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xbda/0x1ea0 drivers/base/core.c:3428
 usb_set_configuration+0x101e/0x1900 drivers/usb/core/message.c:2170

Memory state around the buggy address:
 ffff88801f653280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88801f653300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88801f653380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                             ^
 ffff88801f653400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88801f653480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
----------------
Code disassembly (best guess), 7 bytes skipped:
   0:	df 55 48             	fists  0x48(%rbp)
   3:	89 fd                	mov    %edi,%ebp
   5:	48 83 c7 08          	add    $0x8,%rdi
   9:	48 89 fa             	mov    %rdi,%rdx
   c:	48 c1 ea 03          	shr    $0x3,%rdx
  10:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  14:	84 c0                	test   %al,%al
  16:	74 04                	je     0x1c
  18:	3c 03                	cmp    $0x3,%al
  1a:	7e 4c                	jle    0x68
  1c:	81 7d 08 ed 1e af de 	cmpl   $0xdeaf1eed,0x8(%rbp)
* 23:	75 20                	jne    0x45 <-- trapping instruction
  25:	be 04 00 00 00       	mov    $0x4,%esi
  2a:	48 89 ef             	mov    %rbp,%rdi
  2d:	e8 95 55 68 00       	callq  0x6855c7
  32:	b8 00 02 00 00       	mov    $0x200,%eax
  37:	f0                   	lock
  38:	0f                   	.byte 0xf


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
