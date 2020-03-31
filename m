Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB95B199C12
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 18:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgCaQuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 12:50:05 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48070 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731051AbgCaQuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 12:50:04 -0400
Received: by mail-il1-f200.google.com with SMTP id a15so15069620ild.14
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 09:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=FnPVIE4Y4YoAbVewZLcfDMvis4c3vgY/mVpUeoEtT+Y=;
        b=HJneWL/0EJmJdd0V/LWecBLtTZ6Q0faKKYbRZ/n8HPFSwlGNT53a54s0yEq/YZd4Jg
         jnmyooV6g7mo+qsh0MDRy0+oNezLYnmhTiYOHK7nFXAiMZgCpQWryx+v0B+pjS5O29VT
         jhJkZbQzs2vDFXD0Pv0PNV+tGUFaP8w7qvukOLFOHLvJteVel7m0QPyEBz+PVS1CkECH
         A5zSPwwbxr2UkUmkWW4VJXn3sCA2jKeYV6z5YAYGiriBQneAhGVCVlTpw0nPnmO9OWhR
         /D25vVWmVov9bLYwsMRDdkhTHZVfDx+Z4bQa49c8RVUTEslvopbheI2NofjTYdAmHxk1
         qHFA==
X-Gm-Message-State: ANhLgQ1QHxuruyviFVlYqIyIR2TCGftA5c4yvPVBNMYVh1O/N5eKXMQE
        wmXPTPMIIHXpnqLfi10aNC2QrfG5C2ocvugQIqMeVPlTVzkq
X-Google-Smtp-Source: ADFU+vv/iTauQfniYclFQg/kjihb1SPLPslGxg7z0kHqR/jnKPkNv1jM5/SfGgQjO4Jm58kCuRt6HLbibZICuV6sU4IKTlrrofCQ
MIME-Version: 1.0
X-Received: by 2002:a02:7a18:: with SMTP id a24mr16791632jac.54.1585673403754;
 Tue, 31 Mar 2020 09:50:03 -0700 (PDT)
Date:   Tue, 31 Mar 2020 09:50:03 -0700
In-Reply-To: <CADG63jCwP1D3dBRFTB6FXePD6ys5n1j+1=JrkJjZXC80eKLehQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5ede505a2295b59@google.com>
Subject: Re: KASAN: use-after-free Write in ath9k_htc_rx_msg
From:   syzbot <syzbot+b1c61e5f11be5782f192@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, anenbupt@gmail.com,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered crash:
KASAN: use-after-free Write in ath9k_htc_rx_msg

==================================================================
BUG: KASAN: use-after-free in htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
BUG: KASAN: use-after-free in ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:442
Write of size 2 at addr ffff8881d46881b0 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xef/0x16e lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x314 mm/kasan/report.c:374
 __kasan_report.cold+0x37/0x77 mm/kasan/report.c:506
 kasan_report+0xe/0x20 mm/kasan/common.c:641
 htc_process_conn_rsp drivers/net/wireless/ath/ath9k/htc_hst.c:131 [inline]
 ath9k_htc_rx_msg+0xa25/0xaf0 drivers/net/wireless/ath/ath9k/htc_hst.c:442
 ath9k_hif_usb_reg_in_cb+0x1ba/0x630 drivers/net/wireless/ath/ath9k/hif_usb.c:718
 __usb_hcd_giveback_urb+0x1f2/0x470 drivers/usb/core/hcd.c:1648
 usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1713
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
Code: cc cc 41 56 41 55 65 44 8b 2d 04 3b 72 7a 41 54 55 53 0f 1f 44 00 00 e8 b6 27 b5 fb e9 07 00 00 00 0f 00 2d aa d0 52 00 fb f4 <65> 44 8b 2d e0 3a 72 7a 0f 1f 44 00 00 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffffff87007d80 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000007 RBX: ffffffff8702cc40 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffffffff8702d48c
RBP: fffffbfff0e05988 R08: ffffffff8702cc40 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffffffff87e612c0 R15: 0000000000000000
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3e0/0x500 kernel/sched/idle.c:269
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:361
 start_kernel+0xe16/0xe5a init/main.c:998
 secondary_startup_64+0xb6/0xc0 arch/x86/kernel/head_64.S:242

Allocated by task 2593:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:515 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:488
 slab_post_alloc_hook mm/slab.h:584 [inline]
 slab_alloc_node mm/slub.c:2786 [inline]
 slab_alloc mm/slub.c:2794 [inline]
 kmem_cache_alloc+0xd8/0x300 mm/slub.c:2799
 getname_flags fs/namei.c:138 [inline]
 getname_flags+0xd2/0x5b0 fs/namei.c:128
 do_sys_openat2+0x3cf/0x740 fs/open.c:1140
 do_sys_open+0xc3/0x140 fs/open.c:1162
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2593:
 save_stack+0x1b/0x80 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:337 [inline]
 __kasan_slab_free+0x117/0x160 mm/kasan/common.c:476
 slab_free_hook mm/slub.c:1444 [inline]
 slab_free_freelist_hook mm/slub.c:1477 [inline]
 slab_free mm/slub.c:3034 [inline]
 kmem_cache_free+0x9b/0x360 mm/slub.c:3050
 putname+0xe1/0x120 fs/namei.c:259
 do_sys_openat2+0x43a/0x740 fs/open.c:1155
 do_sys_open+0xc3/0x140 fs/open.c:1162
 do_syscall_64+0xb6/0x5a0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8881d4688000
 which belongs to the cache names_cache of size 4096
The buggy address is located 432 bytes inside of
 4096-byte region [ffff8881d4688000, ffff8881d4689000)
The buggy address belongs to the page:
page:ffffea000751a200 refcount:1 mapcount:0 mapping:ffff8881da11c000 index:0x0 compound_mapcount: 0
flags: 0x200000000010200(slab|head)
raw: 0200000000010200 dead000000000100 dead000000000122 ffff8881da11c000
raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881d4688080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881d4688100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8881d4688180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff8881d4688200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881d4688280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         0fa84af8 Merge tag 'usb-serial-5.7-rc1' of https://git.ker..
git tree:       https://github.com/google/kasan.git usb-fuzzer
console output: https://syzkaller.appspot.com/x/log.txt?x=14d6096de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a782c087b1f425c6
dashboard link: https://syzkaller.appspot.com/bug?extid=b1c61e5f11be5782f192
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=1782b063e00000

