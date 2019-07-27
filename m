Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6434F777FB
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 11:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbfG0JpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 05:45:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42419 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387553AbfG0JpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 05:45:07 -0400
Received: by mail-io1-f71.google.com with SMTP id f22so61524214ioj.9
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 02:45:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=luBN04vpZCAYMYbcybEbmYPb1CaylNbTpfkzCWh390w=;
        b=MT7NO98ReYJaGXfCyeNwv5bowm7gU0SkQ7zmeADuCyt3O/bQQzLSNNmlUGCmsmfde8
         DhEJs6cCkFZB0GQ8GZn+skYDywNF5xiuxnWaQO3p9toEhAcpWMesMbLVe70nxflZA0CE
         P3KIrgd+zyzPGDwlWg9KikPYYPTUm8j9Gvte6BK3ANNj/Rx9xLPiB7F6kYwsF7ubmWEO
         WtBl4BD9mgqfqQKMixTOTWFaB0T4Z2g48yJJwG90HAk/dS9I8VtAnzn+Qvmo8g9HcGa+
         5G1N+Jnq2ukLZiSy654L0Jzm7s1YKiIGXKLcbDVCcXPqfvy9HE/lb9VBtRmR+t/iMT5N
         MOwQ==
X-Gm-Message-State: APjAAAUUbXcaKawwFXzIf3tHwt+oUQGNfhd0u2s8p4xCO1p+wtTqt2BP
        TnlMPuE+Zz07PILBCtfgVMjUGbt66/nMHmbXOJUhQVBv4FdR
X-Google-Smtp-Source: APXvYqz4ehsgc865aC+XQs2++Kg2WO0162sF+rtYamiLT5s6DQD8l9vqRIpXxzFpEM1eP5BL2WoBHhJZQS0/4oWEM4Fr72xoq9bx
MIME-Version: 1.0
X-Received: by 2002:a5d:9749:: with SMTP id c9mr27338140ioo.258.1564220706320;
 Sat, 27 Jul 2019 02:45:06 -0700 (PDT)
Date:   Sat, 27 Jul 2019 02:45:06 -0700
In-Reply-To: <0000000000007a5aad057e7748c9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008cfb9f058ea6834d@google.com>
Subject: Re: KASAN: use-after-free Read in lock_sock_nested
From:   syzbot <syzbot+500c69d1e21d970e461b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    3ea54d9b Merge tag 'docs-5.3-1' of git://git.lwn.net/linux
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16a66564600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=195ab3ca46c2e324
dashboard link: https://syzkaller.appspot.com/bug?extid=500c69d1e21d970e461b
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145318b4600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ac7b78600000

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11c610a7200000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13c610a7200000
console output: https://syzkaller.appspot.com/x/log.txt?x=15c610a7200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+500c69d1e21d970e461b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in debug_spin_lock_before  
kernel/locking/spinlock_debug.c:83 [inline]
BUG: KASAN: use-after-free in do_raw_spin_lock+0x295/0x3a0  
kernel/locking/spinlock_debug.c:112
Read of size 4 at addr ffff88809f0acf0c by task syz-executor847/10804

CPU: 0 PID: 10804 Comm: syz-executor847 Not tainted 5.3.0-rc1+ #51
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x75/0x5b0 mm/kasan/report.c:351
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:482
  kasan_report+0x26/0x50 mm/kasan/common.c:612
  __asan_report_load4_noabort+0x14/0x20 mm/kasan/generic_report.c:131
  debug_spin_lock_before kernel/locking/spinlock_debug.c:83 [inline]
  do_raw_spin_lock+0x295/0x3a0 kernel/locking/spinlock_debug.c:112
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:136 [inline]
  _raw_spin_lock_bh+0x40/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  lock_sock_nested+0x45/0x120 net/core/sock.c:2917
  lock_sock include/net/sock.h:1522 [inline]
  nr_getname+0x5b/0x220 net/netrom/af_netrom.c:838
  __sys_accept4+0x63a/0x9a0 net/socket.c:1759
  __do_sys_accept4 net/socket.c:1789 [inline]
  __se_sys_accept4 net/socket.c:1786 [inline]
  __x64_sys_accept4+0x9a/0xb0 net/socket.c:1786
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4480e9
Code: e8 ac e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 4b 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f43bf6ced88 EFLAGS: 00000246 ORIG_RAX: 0000000000000120
RAX: ffffffffffffffda RBX: 00000000006ddc38 RCX: 00000000004480e9
RDX: 0000000000000000 RSI: 0000000020000b00 RDI: 0000000000000004
RBP: 00000000006ddc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006ddc3c
R13: 00007ffd18de174f R14: 00007f43bf6cf9c0 R15: 00000000006ddc3c

Allocated by task 0:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:487
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:501
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x254/0x340 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  sk_prot_alloc+0xb0/0x290 net/core/sock.c:1603
  sk_alloc+0x38/0x950 net/core/sock.c:1657
  nr_make_new net/netrom/af_netrom.c:476 [inline]
  nr_rx_frame+0xabc/0x1e40 net/netrom/af_netrom.c:959
  nr_loopback_timer+0x6a/0x140 net/netrom/nr_loopback.c:59
  call_timer_fn+0xec/0x200 kernel/time/timer.c:1322
  expire_timers kernel/time/timer.c:1366 [inline]
  __run_timers+0x7cd/0x9c0 kernel/time/timer.c:1685
  run_timer_softirq+0x4a/0x90 kernel/time/timer.c:1698
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:778

Freed by task 10804:
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:449
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:457
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x115/0x200 mm/slab.c:3756
  sk_prot_free net/core/sock.c:1640 [inline]
  __sk_destruct+0x567/0x660 net/core/sock.c:1726
  sk_destruct net/core/sock.c:1734 [inline]
  __sk_free+0x317/0x3e0 net/core/sock.c:1745
  sk_free net/core/sock.c:1756 [inline]
  sock_put include/net/sock.h:1725 [inline]
  sock_efree+0x60/0x80 net/core/sock.c:2042
  skb_release_head_state+0x100/0x220 net/core/skbuff.c:652
  skb_release_all net/core/skbuff.c:663 [inline]
  __kfree_skb+0x25/0x170 net/core/skbuff.c:679
  kfree_skb+0x6f/0xb0 net/core/skbuff.c:697
  nr_accept+0x4ef/0x650 net/netrom/af_netrom.c:819
  __sys_accept4+0x5bc/0x9a0 net/socket.c:1754
  __do_sys_accept4 net/socket.c:1789 [inline]
  __se_sys_accept4 net/socket.c:1786 [inline]
  __x64_sys_accept4+0x9a/0xb0 net/socket.c:1786
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88809f0ace80
  which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 140 bytes inside of
  2048-byte region [ffff88809f0ace80, ffff88809f0ad680)
The buggy address belongs to the page:
page:ffffea00027c2b00 refcount:1 mapcount:0 mapping:ffff8880aa400e00  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0002704708 ffffea0002695508 ffff8880aa400e00
raw: 0000000000000000 ffff88809f0ac600 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809f0ace00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88809f0ace80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88809f0acf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88809f0acf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88809f0ad000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
------------[ cut here ]------------
ODEBUG: activate not available (active state 0) object type: timer_list  
hint: nr_t1timer_expiry+0x0/0x400 net/netrom/nr_timer.c:46
WARNING: CPU: 0 PID: 10804 at lib/debugobjects.c:484 debug_print_object  
lib/debugobjects.c:481 [inline]
WARNING: CPU: 0 PID: 10804 at lib/debugobjects.c:484  
debug_object_activate+0x33d/0x6f0 lib/debugobjects.c:680
Modules linked in:
CPU: 0 PID: 10804 Comm: syz-executor847 Tainted: G    B              
5.3.0-rc1+ #51
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:debug_print_object lib/debugobjects.c:481 [inline]
RIP: 0010:debug_object_activate+0x33d/0x6f0 lib/debugobjects.c:680
Code: f7 e8 f7 01 4a fe 4d 8b 06 48 c7 c7 ca 56 88 88 48 c7 c6 f0 2d a1 88  
48 c7 c2 e3 69 81 88 31 c9 49 89 d9 31 c0 e8 63 6d e0 fd <0f> 0b 48 ba 00  
00 00 00 00 fc ff df ff 05 65 92 95 05 49 83 c6 20
RSP: 0018:ffff88809633faa8 EFLAGS: 00010046
RAX: a65408733c6cb800 RBX: ffffffff86dc84e0 RCX: ffff8880a8b08440
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: ffff88809633faf0 R08: ffffffff816063f4 R09: ffffed1015d440c2
R10: ffffed1015d440c2 R11: 0000000000000000 R12: ffff8880a10bfd70
R13: 1ffff11014217fae R14: ffffffff88cd9fc0 R15: ffff88809f0ad358
FS:  00007f43bf6cf700(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000008c7b1000 CR4: 00000000001406f0
Call Trace:
  debug_timer_activate kernel/time/timer.c:710 [inline]
  __mod_timer+0x960/0x16e0 kernel/time/timer.c:1035
  mod_timer+0x1f/0x30 kernel/time/timer.c:1096
  sk_reset_timer+0x22/0x50 net/core/sock.c:2821
  nr_start_t1timer+0x78/0x90 net/netrom/nr_timer.c:52
  nr_release+0x238/0x390 net/netrom/af_netrom.c:537
  __sock_release net/socket.c:590 [inline]
  sock_close+0xe1/0x260 net/socket.c:1268
  __fput+0x2e4/0x740 fs/file_table.c:280
  ____fput+0x15/0x20 fs/file_table.c:313
  task_work_run+0x17e/0x1b0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop arch/x86/entry/common.c:163 [inline]
  prepare_exit_to_usermode+0x459/0x580 arch/x86/entry/common.c:194
  syscall_return_slowpath+0x113/0x4a0 arch/x86/entry/common.c:274
  do_syscall_64+0x126/0x140 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4480e9
Code: e8 ac e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 4b 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f43bf6ced88 EFLAGS: 00000246 ORIG_RAX: 0000000000000120
RAX: fffffffffffffff2 RBX: 00000000006ddc38 RCX: 00000000004480e9
RDX: 0000000000000000 RSI: 0000000020000b00 RDI: 0000000000000004
RBP: 00000000006ddc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006ddc3c
R13: 00007ffd18de174f R14: 00007f43bf6cf9c0 R15: 00000000006ddc3c
irq event stamp: 0
hardirqs last  enabled at (0): [<0000000000000000>] 0x0
hardirqs last disabled at (0): [<ffffffff81484c09>]  
copy_process+0x1589/0x5bc0 kernel/fork.c:1960
softirqs last  enabled at (0): [<ffffffff81484c7f>]  
copy_process+0x15ff/0x5bc0 kernel/fork.c:1963
softirqs last disabled at (0): [<0000000000000000>] 0x0
---[ end trace 41aab9a9be4009d5 ]---

