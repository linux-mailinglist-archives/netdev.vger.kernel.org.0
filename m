Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9DB5193DFC
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 12:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCZLem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 07:34:42 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:53559 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgCZLeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 07:34:17 -0400
Received: by mail-io1-f69.google.com with SMTP id f6so4896158ioc.20
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 04:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=K5OHxcR7nwCssDFon9Ku7jDNBJ2liH6ZbfsPuF6IbzA=;
        b=cYRSIX7mlQYnx7gY1BwDiD6qyisOPQo55OrXexuTaYhsfC1huzu2ScSucfT+5afZJh
         BvY9kfGfd5rLeT7BJxv9TZgEaXJyJevdbpkz3TSGWiEaiNrftFAVn5e3oZ85XbRtY17G
         BsEsP6nceTdq4cC+caXRq9Hz32+bTKSgL9WobTk17biP5bZtdwz/mT2eFHlZl/uIaIvI
         F8m0T+rNrsENvIcwC5NtlAbWfsIzU9ipaqREML7wB8jbJeQQUPVNfZq0+wwroRPLlqih
         uFU6DGl9drxmqux+tYYl9+FXmjqLhZS7Cbgc3jUOanNVoZ2NoKZMZ6XuxldeeW6XUZKL
         GNxQ==
X-Gm-Message-State: ANhLgQ1t4xJLNdhzMgtsjf6a6nCaURr6tguEueVB6La6I6wYoSUkDsbX
        3j+PCPJGQewfRW9yA9+YaEWSr4YEM9c8eb3HgYtDdXJtfhn0
X-Google-Smtp-Source: ADFU+vvGBmcpvSWF1O7ymEe6OpN8fadgcXY91XrVN0MoBwKWg525kJS5Ywt3HexSQo87ZuGXLwbquXCxkZ4lAraVjIaf2KtwQJvq
MIME-Version: 1.0
X-Received: by 2002:a6b:760f:: with SMTP id g15mr7166798iom.56.1585222456622;
 Thu, 26 Mar 2020 04:34:16 -0700 (PDT)
Date:   Thu, 26 Mar 2020 04:34:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ac55b05a1c05d72@google.com>
Subject: KASAN: use-after-free Write in ath9k_htc_rx_msg
From:   syzbot <syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com>
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

Hello,

syzbot found the following crash on:

HEAD commit:    e17994d1 usb: core: kcov: collect coverage from usb comple..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=13a40c13e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d64370c438bc60
dashboard link: https://syzkaller.appspot.com/bug?extid=b1c61e5f11be5782f192
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13790f73e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ebae75e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
BUG: KASAN: use-after-free in ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:443
Write of size 2 at addr ffff8881cea291f0 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
 ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:443
 ath9k_hif_usb_reg_in_cb+0x1ba/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:718
 __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
 dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
 call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
 __do_softirq+0x21e/0x950 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x178/0x1a0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:default_idle+0x28/0x300 arch/x86/kernel/process.c:696
Code: cc cc 41 56 41 55 65 44 8b 2d 44 77 72 7a 41 54 55 53 0f 1f 44 00 00 e8 b6 62 b5 fb e9 07 00 00 00 0f 00 2d ea 0c 53 00 fb f4 <65> 44 8b 2d 20 77 72 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffff8881da22fda8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffff8881da213100 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff8881da21394c
RBP: ffffed103b442620 R08: ffff8881da213100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: ffffffff87e607c0 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_secondary+0x2a4/0x390 arch/x86/kernel/smpboot.c:264
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

Allocated by task 371:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 kmalloc include/linux/slab.h:560 [inline]
 raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:556 [inline]
 raw_alloc_io_data+0x150/0x1c0 drivers/usb/gadget/legacy/raw_gadget.c:538
 raw_ioctl_ep0_read drivers/usb/gadget/legacy/raw_gadget.c:657 [inline]
 raw_ioctl+0x686/0x1a70 drivers/usb/gadget/legacy/raw_gadget.c:1035
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 371:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
 slab_free_hook mm/slub.c:1444 [inline]
 slab_free_freelist_hook mm/slub.c:1477 [inline]
 slab_free mm/slub.c:3024 [inline]
 kfree+0xd5/0x300 mm/slub.c:3976
 raw_ioctl_ep_read drivers/usb/gadget/legacy/raw_gadget.c:961 [inline]
 raw_ioctl+0x189/0x1a70 drivers/usb/gadget/legacy/raw_gadget.c:1047
 vfs_ioctl fs/ioctl.c:47 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:763
 __do_sys_ioctl fs/ioctl.c:772 [inline]
 __se_sys_ioctl fs/ioctl.c:770 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:770
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8881cea29000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 496 bytes inside of
 2048-byte region [ffff8881cea29000, ffff8881cea29800)
The buggy address belongs to the page:
page:ffffea00073a8a00 refcount:1 mapcount:0 mapping:ffff8881da00c000 index:0x0 compound_mapcount: 0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da00c000
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881cea29080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881cea29100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881cea29180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff8881cea29200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881cea29280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
