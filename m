Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E98145A33
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgAVQrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:47:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:46436 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgAVQrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 11:47:12 -0500
Received: by mail-il1-f197.google.com with SMTP id a2so157520ill.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 08:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=teBxDbGtJLSkRwAQpel7T4qzq+TrAgnWL1RicUMKLg8=;
        b=i8yPQFienm77wXb/KZ4SOKB6sxei+/alDyofYSV4UkeFwG/7yNd4gqF42vjeAfkkiC
         diuN5BFFP4aq01UUbWAyMZLQpGXLcTIRUSJDLZnX79rHzzkJEVrcV+w10NmG3xRhFaF2
         6ZlsWAzdgBEHDJNULbAfOj6mj4CvhuHy3nAeK6ZLjTyThaHsm9/ZW3X0GWRTvTGSvPEm
         TIZmD4v6JWvIfvy2/lHhUP3inv+6qm3AQMhf1ZBD5C8WXYfJMatRqwqIbWgiCth51KHc
         ls1QoJJuJsqx8bejaV7FlPyduqgMnPHvywaEHc1BrSCR2nsQbrpP81dfL6xUgt2YIVVc
         6OJA==
X-Gm-Message-State: APjAAAXs610E36dbx0G7bZLnfA+iil3Lr4qZSacVDVEILCQX6BnVyl0+
        UlSatGHEk/X7Gt4LwzF3VmTdi0XWB9KzmaYahzgniS48GYWI
X-Google-Smtp-Source: APXvYqyepTjvIEchX4OnEENJBtOJ+Wn+kE8d4zCxfakBrZgSmYIz45pPBOHOdoHc02imOru2L7cptC1hhM5osy5/ztCTAcM0H5Pc
MIME-Version: 1.0
X-Received: by 2002:a92:730d:: with SMTP id o13mr6578598ilc.174.1579711631042;
 Wed, 22 Jan 2020 08:47:11 -0800 (PST)
Date:   Wed, 22 Jan 2020 08:47:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009db040059cbd46a4@google.com>
Subject: KMSAN: uninit-value in eth_type_trans (2)
From:   syzbot <syzbot+0901d0cc75c3d716a3a3@syzkaller.appspotmail.com>
To:     daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        glider@google.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, maximmi@mellanox.com,
        netdev@vger.kernel.org, sdf@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    686a4f77 kmsan: don't compile memmove
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=104b74c9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e10654781bc1f11c
dashboard link: https://syzkaller.appspot.com/bug?extid=0901d0cc75c3d716a3a3
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c91cc9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=136a6faee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0901d0cc75c3d716a3a3@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in eth_type_trans+0x356/0xa90 net/ethernet/eth.c:167
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 eth_type_trans+0x356/0xa90 net/ethernet/eth.c:167
 __dev_forward_skb+0x3ec/0x990 net/core/dev.c:2074
 veth_forward_skb drivers/net/veth.c:231 [inline]
 veth_xmit+0x3fe/0xb70 drivers/net/veth.c:262
 __netdev_start_xmit include/linux/netdevice.h:4447 [inline]
 netdev_start_xmit include/linux/netdevice.h:4461 [inline]
 xmit_one net/core/dev.c:3420 [inline]
 dev_hard_start_xmit+0x531/0xab0 net/core/dev.c:3436
 __dev_queue_xmit+0x37de/0x4220 net/core/dev.c:4013
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4046
 hsr_xmit net/hsr/hsr_forward.c:228 [inline]
 hsr_forward_do net/hsr/hsr_forward.c:285 [inline]
 hsr_forward_skb+0x2614/0x30d0 net/hsr/hsr_forward.c:361
 hsr_handle_frame+0x385/0x4b0 net/hsr/hsr_slave.c:43
 __netif_receive_skb_core+0x21de/0x5840 net/core/dev.c:5051
 __netif_receive_skb_one_core net/core/dev.c:5148 [inline]
 __netif_receive_skb net/core/dev.c:5264 [inline]
 process_backlog+0x936/0x1410 net/core/dev.c:6095
 napi_poll net/core/dev.c:6532 [inline]
 net_rx_action+0x786/0x1ab0 net/core/dev.c:6600
 __do_softirq+0x311/0x83d kernel/softirq.c:293
 invoke_softirq kernel/softirq.c:375 [inline]
 irq_exit+0x230/0x280 kernel/softirq.c:416
 exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
 smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1140
 apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:834
 </IRQ>
RIP: 0010:default_idle+0x53/0x90 arch/x86/kernel/process.c:700
Code: 13 f9 d6 f2 44 8b 35 64 54 d8 01 48 c7 c7 38 b7 22 be e8 50 1d a2 f3 83 38 00 75 31 45 85 f6 7e 07 0f 00 2d 27 fe 56 00 fb f4 <65> 8b 35 46 c0 b6 43 c7 03 00 00 00 00 c7 43 08 00 00 00 00 bf ff
RSP: 0018:ffffffffbd603d88 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: ffff912c3d81e738 RBX: ffffffffbd62cb90 RCX: fffffa5d46130d70
RDX: ffff912c35c11738 RSI: 0000000000000000 RDI: ffffffffbe22b738
RBP: ffffffffbd603d98 R08: fffffa5d4000000f R09: ffff912b67bfb000
R10: 0000000000000004 R11: ffffffffbc4a62a0 R12: ffffffffbd62c1c0
R13: 0000000000000000 R14: 0000000000000000 R15: ffffffffbd62cb90
 arch_cpu_idle+0x25/0x30 arch/x86/kernel/process.c:690
 default_idle_call kernel/sched/idle.c:94 [inline]
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x26c/0x7b0 kernel/sched/idle.c:269
 cpu_startup_entry+0x45/0x50 kernel/sched/idle.c:361
 rest_init+0x1be/0x1f0 init/main.c:452
 arch_call_rest_init+0x13/0x15
 start_kernel+0x975/0xb3e init/main.c:787
 x86_64_start_reservations+0x18/0x28 arch/x86/kernel/head64.c:490
 x86_64_start_kernel+0x83/0x86 arch/x86/kernel/head64.c:471
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242

Uninit was stored to memory at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_chain_origin+0xad/0x130 mm/kmsan/kmsan.c:310
 kmsan_memcpy_memmove_metadata+0x272/0x2e0 mm/kmsan/kmsan.c:247
 kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:267
 __msan_memcpy+0x43/0x50 mm/kmsan/kmsan_instr.c:116
 pskb_expand_head+0x38b/0x1b00 net/core/skbuff.c:1637
 __skb_pad+0x47f/0x900 net/core/skbuff.c:1805
 __skb_put_padto include/linux/skbuff.h:3193 [inline]
 skb_put_padto include/linux/skbuff.h:3212 [inline]
 send_hsr_supervision_frame+0x122d/0x1500 net/hsr/hsr_device.c:310
 hsr_announce+0x1e2/0x370 net/hsr/hsr_device.c:341
 call_timer_fn+0x218/0x510 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers+0xcff/0x1210 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x311/0x83d kernel/softirq.c:293

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:307 [inline]
 kmsan_alloc_page+0x12a/0x310 mm/kmsan/kmsan_shadow.c:336
 __alloc_pages_nodemask+0x57f2/0x5f60 mm/page_alloc.c:4800
 __alloc_pages include/linux/gfp.h:498 [inline]
 __alloc_pages_node include/linux/gfp.h:511 [inline]
 alloc_pages_node include/linux/gfp.h:525 [inline]
 __page_frag_cache_refill mm/page_alloc.c:4875 [inline]
 page_frag_alloc+0x3ae/0x910 mm/page_alloc.c:4905
 __napi_alloc_skb+0x193/0xa60 net/core/skbuff.c:519
 napi_alloc_skb include/linux/skbuff.h:2825 [inline]
 page_to_skb+0x19f/0x1100 drivers/net/virtio_net.c:384
 receive_mergeable drivers/net/virtio_net.c:924 [inline]
 receive_buf+0xe57/0x8ac0 drivers/net/virtio_net.c:1033
 virtnet_receive drivers/net/virtio_net.c:1323 [inline]
 virtnet_poll+0x64b/0x19f0 drivers/net/virtio_net.c:1428
 napi_poll net/core/dev.c:6532 [inline]
 net_rx_action+0x786/0x1ab0 net/core/dev.c:6600
 __do_softirq+0x311/0x83d kernel/softirq.c:293
=====================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
