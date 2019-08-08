Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7231E8675F
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390249AbfHHQpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:45:06 -0400
Received: from mail-ot1-f70.google.com ([209.85.210.70]:48846 "EHLO
        mail-ot1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390241AbfHHQpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 12:45:06 -0400
Received: by mail-ot1-f70.google.com with SMTP id b4so62903939otf.15
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 09:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0qtawAiexWdaWveSs5Pr+gZcDSnKlOtAWGLp0JpxqWo=;
        b=Q5OkZ8P+3QDF8toy5lpdgY+Avd6vnK+ecNdfD3494fv7w6/UwcV3VVTNUe/cBlHuCl
         WNF3aYnOOQp3ncBjCQWCm6DpdtztEM5EobDKrACOoZrBK9YUS9eYPw2C92WYhRb2tept
         MG4t9xxv26hRwO6jGM+mHvaTtRz5EANm4s4QTH56s487atLCWnKzyvsOt0D6xuxUwX5g
         VB9E9Xy98Pg0kDSzHscJKIyHf5Hupw16WzCpvbUH4xgtb88R2slyU95cITg2GSmJbELU
         EWNDwv01Ohd3ey1R1aOqrRrgvhLVjazFx/zsUE5CH0k9BQcU4YvceQi3o2yJdlpOrp9X
         sDPQ==
X-Gm-Message-State: APjAAAUOMLlpdmdCjGhzzsFNHcWSqQ4w9DmZ0/ul5kvt8GUY28lo9NC5
        xre4PgEF92GmtfTav7nHoLAjLrnJtQUTVVvKFJ4hjSnJ1sMT
X-Google-Smtp-Source: APXvYqyCsvSXCP1Hl+kFEeU7K/+WUtwOPRjFNzJT33MulutCfFT9mSCEe2W4wWIOEbb0N6Ob+M98FRS9n2Ba8CjSsUYM4l7reNuD
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3d2:: with SMTP id r18mr17735207jaq.13.1565282705488;
 Thu, 08 Aug 2019 09:45:05 -0700 (PDT)
Date:   Thu, 08 Aug 2019 09:45:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a244b3058f9dc7d6@google.com>
Subject: KASAN: use-after-free Read in tomoyo_socket_sendmsg_permission
From:   syzbot <syzbot+b91501546ab4037f685f@syzkaller.appspotmail.com>
To:     jmorris@namei.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        serge@hallyn.com, syzkaller-bugs@googlegroups.com,
        takedakn@nttdata.co.jp
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    107e47cc vrf: make sure skb->data contains ip header to ma..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=139506d8600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4dba67bf8b8c9ad7
dashboard link: https://syzkaller.appspot.com/bug?extid=b91501546ab4037f685f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b91501546ab4037f685f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in tomoyo_sock_family  
security/tomoyo/network.c:632 [inline]
BUG: KASAN: use-after-free in tomoyo_socket_sendmsg_permission+0x37e/0x3cb  
security/tomoyo/network.c:762
Read of size 2 at addr ffff8880a066f410 by task syz-executor.3/2063

CPU: 1 PID: 2063 Comm: syz-executor.3 Not tainted 5.2.0+ #97
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:612
  __asan_report_load2_noabort+0x14/0x20 mm/kasan/generic_report.c:130
  tomoyo_sock_family security/tomoyo/network.c:632 [inline]
  tomoyo_socket_sendmsg_permission+0x37e/0x3cb security/tomoyo/network.c:762
  tomoyo_socket_sendmsg+0x26/0x30 security/tomoyo/tomoyo.c:486
  security_socket_sendmsg+0x77/0xc0 security/security.c:1973
  sock_sendmsg+0x45/0x130 net/socket.c:654
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8413a51c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
RDX: 00000000000000ed RSI: 0000000020000280 RDI: 0000000000000005
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8413a526d4
R13: 00000000004c77f1 R14: 00000000004dcfc0 R15: 00000000ffffffff

Allocated by task 0:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:487 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:460
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  sk_prot_alloc+0x23a/0x310 net/core/sock.c:1603
  sk_alloc+0x39/0xf70 net/core/sock.c:1657
  nr_make_new net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0x733/0x1e73 net/netrom/af_netrom.c:959
  nr_loopback_timer+0x7b/0x170 net/netrom/nr_loopback.c:59
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers kernel/time/timer.c:1685 [inline]
  __run_timers kernel/time/timer.c:1653 [inline]
  run_timer_softirq+0x697/0x17a0 kernel/time/timer.c:1698
  __do_softirq+0x262/0x98c kernel/softirq.c:292

Freed by task 2063:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x4f7/0x6e0 net/core/sock.c:1726
  sk_destruct+0x86/0xa0 net/core/sock.c:1734
  __sk_free+0xfb/0x360 net/core/sock.c:1745
  sk_free+0x42/0x50 net/core/sock.c:1756
  sock_put include/net/sock.h:1725 [inline]
  sock_efree+0x61/0x80 net/core/sock.c:2042
  skb_release_head_state+0xeb/0x250 net/core/skbuff.c:652
  skb_release_all+0x16/0x60 net/core/skbuff.c:663
  __kfree_skb net/core/skbuff.c:679 [inline]
  kfree_skb net/core/skbuff.c:697 [inline]
  kfree_skb+0x101/0x3c0 net/core/skbuff.c:691
  nr_accept+0x56e/0x700 net/netrom/af_netrom.c:819
  __sys_accept4+0x34e/0x6a0 net/socket.c:1754
  __do_sys_accept net/socket.c:1795 [inline]
  __se_sys_accept net/socket.c:1792 [inline]
  __x64_sys_accept+0x75/0xb0 net/socket.c:1792
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a066f400
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 16 bytes inside of
  2048-byte region [ffff8880a066f400, ffff8880a066fc00)
The buggy address belongs to the page:
page:ffffea0002819b80 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0001849388 ffffea000235a788 ffff8880aa400e00
raw: 0000000000000000 ffff8880a066e300 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a066f300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a066f380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880a066f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
  ffff8880a066f480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880a066f500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 2063 at lib/refcount.c:105 refcount_add_checked  
lib/refcount.c:105 [inline]
WARNING: CPU: 1 PID: 2063 at lib/refcount.c:105  
refcount_add_checked+0x6b/0x70 lib/refcount.c:103
Modules linked in:
CPU: 1 PID: 2063 Comm: syz-executor.3 Tainted: G    B             5.2.0+ #97
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:refcount_add_checked lib/refcount.c:105 [inline]
RIP: 0010:refcount_add_checked+0x6b/0x70 lib/refcount.c:103
Code: 1d e7 77 64 06 31 ff 89 de e8 71 dc 35 fe 84 db 75 db e8 28 db 35 fe  
48 c7 c7 20 08 c6 87 c6 05 c7 77 64 06 01 e8 1d 43 07 fe <0f> 0b eb bf 90  
48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 54 49
RSP: 0018:ffff88805d55f9f8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815c3a26 RDI: ffffed100baabf31
RBP: ffff88805d55fa10 R08: ffff888098124480 R09: fffffbfff1349ef0
R10: fffffbfff1349eef R11: ffffffff89a4f77f R12: 0000000000000500
R13: ffff8880a066f644 R14: ffff88808f271e60 R15: 00000000000000ed
FS:  00007f8413a52700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000075c000 CR3: 0000000097173000 CR4: 00000000001406e0
Call Trace:
  skb_set_owner_w+0x216/0x320 net/core/sock.c:1991
  sock_alloc_send_pskb+0x7c9/0x920 net/core/sock.c:2226
  sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2240
  nr_sendmsg+0x557/0xb00 net/netrom/af_netrom.c:1094
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8413a51c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
RDX: 00000000000000ed RSI: 0000000020000280 RDI: 0000000000000005
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8413a526d4
R13: 00000000004c77f1 R14: 00000000004dcfc0 R15: 00000000ffffffff
irq event stamp: 344
hardirqs last  enabled at (343): [<ffffffff8100a206>]  
do_syscall_64+0x26/0x6a0 arch/x86/entry/common.c:283
hardirqs last disabled at (344): [<ffffffff87391ddf>]  
__raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (344): [<ffffffff87391ddf>]  
_raw_spin_lock_irqsave+0x6f/0xcd kernel/locking/spinlock.c:159
softirqs last  enabled at (314): [<ffffffff858fb1b6>] spin_unlock_bh  
include/linux/spinlock.h:383 [inline]
softirqs last  enabled at (314): [<ffffffff858fb1b6>]  
release_sock+0x156/0x1c0 net/core/sock.c:2945
softirqs last disabled at (312): [<ffffffff858fb080>] spin_lock_bh  
include/linux/spinlock.h:343 [inline]
softirqs last disabled at (312): [<ffffffff858fb080>]  
release_sock+0x20/0x1c0 net/core/sock.c:2932
---[ end trace 2fe47c842e5d598a ]---


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
