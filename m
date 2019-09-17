Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF8B47C4
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 08:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391404AbfIQG5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 02:57:09 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56368 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391378AbfIQG5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 02:57:08 -0400
Received: by mail-io1-f72.google.com with SMTP id n8so4224300ioh.23
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 23:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5nT82DfPsZYCr7GAfl4lqF2EFv7abMND98js3V6UJ7M=;
        b=rHVTABpyowF3FA9BVG2+yfyQsBEGxq3KxGE8RDEO62+SrknkCHrrK4cJk7FJ4THUtm
         mIkIhmT7oakdwpr+jnDMOKN8e8VTRC3AVayycC90mcRhW3k0cZlBrO3eJ2dhZBWwuYA1
         nwr6U1RBbUpP7/yX55WBE1CZEiOZWVN5jKXH0nv/uUdR08ntyV06wd7uTy/XRsz7pgBA
         UaYEYKRB1YFZnQ2RsAt7+aTf/lPXJsYtpIus1wzdq3EWqhsMH+xBTkO2pDixR6eYqFnY
         kAFb1lqpF3otn3/HTCC4cnCfB0iQxZc5/Vezd/sJtcvnu9sR1lpoF9bpN7d0opIvD29r
         vjSQ==
X-Gm-Message-State: APjAAAWHXMwK96AUF1KxzdiSywZl47NnrAGbauM931eEcsNa1Rp4TEvO
        MN7r1VTep5MfosMw/CBpBc3WXpGr7WQi+tSAuRa2+4HDhLWe
X-Google-Smtp-Source: APXvYqyFd7LPo7ynEu8fuEiPMzC/ZAMRSyg1OLEfyGdL2CPIQMY6kLEYxlf0zHxolCVNGGCIgyHcjF2WrTnj6pgS5/hBCNwDEUYz
MIME-Version: 1.0
X-Received: by 2002:a5d:9859:: with SMTP id p25mr2083176ios.142.1568703426656;
 Mon, 16 Sep 2019 23:57:06 -0700 (PDT)
Date:   Mon, 16 Sep 2019 23:57:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000810fdd0592ba3a42@google.com>
Subject: KASAN: slab-out-of-bounds Read in fib6_nh_get_excptn_bucket
From:   syzbot <syzbot+ce7be3d2a9d20f463b76@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    505a8ec7 Revert "drm/i915/userptr: Acquire the page lock a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176a0831600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=861a6f31647968de
dashboard link: https://syzkaller.appspot.com/bug?extid=ce7be3d2a9d20f463b76
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ce7be3d2a9d20f463b76@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in fib6_nh_get_excptn_bucket+0x198/0x1b0  
net/ipv6/route.c:1591
Read of size 8 at addr ffff8880a06dd6f8 by task syz-executor.2/11374

CPU: 1 PID: 11374 Comm: syz-executor.2 Not tainted 5.3.0-rc8+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:618
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  fib6_nh_get_excptn_bucket+0x198/0x1b0 net/ipv6/route.c:1591
  fib6_nh_flush_exceptions+0x37/0x2d0 net/ipv6/route.c:1719
  fib6_nh_release+0x84/0x3a0 net/ipv6/route.c:3503
  fib6_info_destroy_rcu+0x11e/0x150 net/ipv6/ip6_fib.c:174
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2114 [inline]
  rcu_core+0x67f/0x1580 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:537 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:768  
[inline]
RIP: 0010:lock_acquire+0x20b/0x410 kernel/locking/lockdep.c:4415
Code: 8c 08 00 00 00 00 00 00 48 c1 e8 03 80 3c 10 00 0f 85 d3 01 00 00 48  
83 3d a1 30 7a 07 00 0f 84 53 01 00 00 48 8b 7d c8 57 9d <0f> 1f 44 00 00  
48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 65 8b
RSP: 0018:ffff8880261ef638 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff11a5e8a RBX: ffff88800df3a500 RCX: 0000000000000002
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000286
RBP: ffff8880261ef680 R08: 0000000000000000 R09: 0000000000000000
R10: fffffbfff134afaf R11: ffff88800df3a500 R12: ffffffff88dac3c0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000002
  rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
  rcu_read_lock include/linux/rcupdate.h:592 [inline]
  lock_page_memcg+0x39/0x240 mm/memcontrol.c:2086
  page_remove_file_rmap mm/rmap.c:1218 [inline]
  page_remove_rmap+0x5d6/0x1190 mm/rmap.c:1303
  zap_pte_range mm/memory.c:1059 [inline]
  zap_pmd_range mm/memory.c:1161 [inline]
  zap_pud_range mm/memory.c:1190 [inline]
  zap_p4d_range mm/memory.c:1211 [inline]
  unmap_page_range+0xd45/0x2170 mm/memory.c:1232
  unmap_single_vma+0x19d/0x300 mm/memory.c:1277
  unmap_vmas+0x135/0x280 mm/memory.c:1309
  exit_mmap+0x2ba/0x530 mm/mmap.c:3145
  __mmput kernel/fork.c:1064 [inline]
  mmput+0x179/0x4d0 kernel/fork.c:1085
  exit_mm kernel/exit.c:547 [inline]
  do_exit+0x84e/0x2e50 kernel/exit.c:866
  do_group_exit+0x135/0x360 kernel/exit.c:983
  get_signal+0x47c/0x2500 kernel/signal.c:2734
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fbaefd09c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: 000000000000004c RBX: 0000000000000003 RCX: 00000000004598e9
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbaefd0a6d4
R13: 00000000004c711b R14: 00000000004dc828 R15: 00000000ffffffff

Allocated by task 11374:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:493 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:466
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:507
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:748 [inline]
  fib6_info_alloc+0xb6/0x1b0 net/ipv6/ip6_fib.c:154
  ip6_route_info_create+0x2fe/0x1530 net/ipv6/route.c:3605
  ip6_route_add+0x27/0xc0 net/ipv6/route.c:3697
  inet6_rtm_newroute+0x16c/0x180 net/ipv6/route.c:5261
  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5223
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 16:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:455
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:463
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  __rcu_reclaim kernel/rcu/rcu.h:215 [inline]
  rcu_do_batch kernel/rcu/tree.c:2114 [inline]
  rcu_core+0x7a3/0x1580 kernel/rcu/tree.c:2314
  rcu_core_si+0x9/0x10 kernel/rcu/tree.c:2323
  __do_softirq+0x262/0x98c kernel/softirq.c:292

The buggy address belongs to the object at ffff8880a06dd600
  which belongs to the cache kmalloc-192 of size 192
The buggy address is located 56 bytes to the right of
  192-byte region [ffff8880a06dd600, ffff8880a06dd6c0)
The buggy address belongs to the page:
page:ffffea000281b740 refcount:1 mapcount:0 mapping:ffff8880aa400000  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00024f84c8 ffffea0002622288 ffff8880aa400000
raw: 0000000000000000 ffff8880a06dd000 0000000100000010 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a06dd580: 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880a06dd600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff8880a06dd680: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
                                                                 ^
  ffff8880a06dd700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff8880a06dd780: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
