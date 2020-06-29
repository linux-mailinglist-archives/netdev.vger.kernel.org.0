Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3648220E1E9
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388309AbgF2VAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731208AbgF2TM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:58 -0400
Received: from mail-il1-x148.google.com (mail-il1-x148.google.com [IPv6:2607:f8b0:4864:20::148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2566FC08C5FF
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:55:12 -0700 (PDT)
Received: by mail-il1-x148.google.com with SMTP id d8so8331699ilc.13
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 21:55:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=coULT2Cs0I87tcigCYfrNVk5i5S5iytBctTFCl4ZahM=;
        b=cYC5TMqogJ3QR9z6LZ1r92R1bBMMybIP3Lz72LQqIfRc3tjiGvqYzI4msExNwBnoUC
         cLcUiY1ogiLfsqVZMwaVGia2RAr0jX0UXE+WzKxwD7UVvTVXD54gEPkQwhl19TII3Bvq
         EgBmuWKOHSJhWkJamp8Zn7NjwsLPQr9S1kogeSzZ6ulbcNIAa/aSKYM7WXmSQD13CFDu
         Rd9P29wXi3AQqxGg5t+vtNWJI7AWMUaY1w5OYP0/vYgXrc3zU7kCteqS0rndaR1zEzaH
         YUEMbhKlJg9EPNtrHs6fBKCmcUnPcAl7rfzpJimdoJwn/lVvvxiTtFF3xAjnCchosc28
         R0IQ==
X-Gm-Message-State: AOAM5324SEZVxEIkvcxyMp3aaIG3ypx0EpufuPm/Gu18kTTW5yJcq3Zy
        LoE9DXSNCBUw0cK/K2uU/f9YGCl9EIeSh68WQXq3/J6QZhCh
X-Google-Smtp-Source: ABdhPJxfqyrYiupAU4Sv3epmYco9oZE6HZQzpJnitJwwU101DyMbRvGFr9CEcvMCkkHTDb4ui0CnKUjieFA6XOsHUDnZORUIcmYR
MIME-Version: 1.0
X-Received: by 2002:a92:cc06:: with SMTP id s6mr14862178ilp.86.1593406511062;
 Sun, 28 Jun 2020 21:55:11 -0700 (PDT)
Date:   Sun, 28 Jun 2020 21:55:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000013259505a931dd26@google.com>
Subject: KASAN: use-after-free Read in decode_session6
From:   syzbot <syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b08866f4 Merge branch 'net-atlantic-various-non-functional..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17096b55100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2172f4d0dbc37e27
dashboard link: https://syzkaller.appspot.com/bug?extid=5be8aebb1b7dfa90ef31
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5be8aebb1b7dfa90ef31@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in decode_session6+0xe7c/0x1580 net/xfrm/xfrm_policy.c:3389
Read of size 1 at addr ffff88808f61c0ad by task syz-executor.3/13170

CPU: 0 PID: 13170 Comm: syz-executor.3 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x436 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 decode_session6+0xe7c/0x1580 net/xfrm/xfrm_policy.c:3389
 __xfrm_decode_session+0x50/0xb0 net/xfrm/xfrm_policy.c:3481
 xfrm_decode_session include/net/xfrm.h:1135 [inline]
 vti6_tnl_xmit+0x40d/0x1c80 net/ipv6/ip6_vti.c:577
 __netdev_start_xmit include/linux/netdevice.h:4611 [inline]
 netdev_start_xmit include/linux/netdevice.h:4625 [inline]
 xmit_one net/core/dev.c:3562 [inline]
 dev_hard_start_xmit+0x193/0x950 net/core/dev.c:3578
 sch_direct_xmit+0x2ea/0xc00 net/sched/sch_generic.c:313
 qdisc_restart net/sched/sch_generic.c:376 [inline]
 __qdisc_run+0x4b9/0x1630 net/sched/sch_generic.c:384
 __dev_xmit_skb net/core/dev.c:3801 [inline]
 __dev_queue_xmit+0x1995/0x2d60 net/core/dev.c:4106
 neigh_output include/net/neighbour.h:509 [inline]
 ip6_finish_output2+0x8b6/0x17b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:143 [inline]
 __ip6_finish_output+0x447/0xab0 net/ipv6/ip6_output.c:128
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x1db/0x520 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:435 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 mld_sendpack+0x92a/0xdb0 net/ipv6/mcast.c:1679
 mld_send_cr net/ipv6/mcast.c:1975 [inline]
 mld_ifc_timer_expire+0x60a/0xf10 net/ipv6/mcast.c:2474
 call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers.part.0+0x54c/0xa20 kernel/time/timer.c:1773
 __run_timers kernel/time/timer.c:1745 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1786
 __do_softirq+0x34c/0xa60 kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x111/0x170 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x229/0x270 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x12d/0x220 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:596
RIP: 0010:ip_sk_use_pmtu include/net/ip.h:425 [inline]
RIP: 0010:ip_setup_cork+0x171/0x910 net/ipv4/ip_output.c:1265
Code: 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 fd 05 00 00 44 89 7b 04 <e8> 2a ce cc fa 49 8d bc 24 df 04 00 00 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc90004b47260 EFLAGS: 00000246
RAX: dffffc0000000000 RBX: ffffc90004b47568 RCX: ffffc9000ff09000
RDX: 1ffff92000968e9a RSI: ffffffff86a680fc RDI: ffffc90004b474d0
RBP: ffffc90004b474b8 R08: 0000000000000008 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88809458a000
R13: ffffc90004b47498 R14: ffff8880a1c86400 R15: 0000000000000000
 ip_make_skb+0x174/0x2a0 net/ipv4/ip_output.c:1628
 udp_sendmsg+0x1c2d/0x26c0 net/ipv4/udp.c:1176
 udpv6_sendmsg+0x14dd/0x2b90 net/ipv6/udp.c:1286
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:638
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x331/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb19
Code: Bad RIP value.
RSP: 002b:00007f459bcffc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004fd680 RCX: 000000000045cb19
RDX: 00000000000005c3 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000902 R14: 00000000004cbde8 R15: 00007f459bd006d4

Allocated by task 13105:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:494
 kmem_cache_alloc_trace+0x14f/0x2d0 mm/slab.c:3551
 kmalloc include/linux/slab.h:555 [inline]
 kzalloc include/linux/slab.h:669 [inline]
 kobject_uevent_env+0x227/0x12c0 lib/kobject_uevent.c:523
 netdev_queue_add_kobject net/core/net-sysfs.c:1554 [inline]
 netdev_queue_update_kobjects+0x2f9/0x3c0 net/core/net-sysfs.c:1588
 register_queue_kobjects net/core/net-sysfs.c:1649 [inline]
 netdev_register_kobject+0x2ee/0x3b0 net/core/net-sysfs.c:1892
 register_netdevice+0xd29/0x1540 net/core/dev.c:9522
 __tun_chr_ioctl.isra.0+0x2c09/0x4170 drivers/net/tun.c:2817
 vfs_ioctl fs/ioctl.c:48 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:753
 __do_sys_ioctl fs/ioctl.c:762 [inline]
 __se_sys_ioctl fs/ioctl.c:760 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 13110:
 save_stack+0x1b/0x40 mm/kasan/common.c:48
 set_track mm/kasan/common.c:56 [inline]
 kasan_set_free_info mm/kasan/common.c:316 [inline]
 __kasan_slab_free+0xf5/0x140 mm/kasan/common.c:455
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x103/0x2c0 mm/slab.c:3757
 call_usermodehelper_freeinfo kernel/umh.c:47 [inline]
 umh_complete+0x74/0x90 kernel/umh.c:62
 call_usermodehelper_exec_async+0x460/0x710 kernel/umh.c:122
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

The buggy address belongs to the object at ffff88808f61c000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 173 bytes inside of
 4096-byte region [ffff88808f61c000, ffff88808f61d000)
The buggy address belongs to the page:
page:ffffea00023d8700 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea00023d8700 order:1 compound_mapcount:0
flags: 0xfffe0000010200(slab|head)
raw: 00fffe0000010200 ffffea0001af9708 ffffea000140d688 ffff8880aa002000
raw: 0000000000000000 ffff88808f61c000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808f61bf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88808f61c000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88808f61c080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88808f61c100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808f61c180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
