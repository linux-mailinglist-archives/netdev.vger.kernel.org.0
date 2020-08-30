Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D85256BE6
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 08:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgH3GIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 02:08:20 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44650 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgH3GIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 02:08:18 -0400
Received: by mail-il1-f197.google.com with SMTP id v4so205656ilj.11
        for <netdev@vger.kernel.org>; Sat, 29 Aug 2020 23:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=i7Bg2N1ZspYy2m3x9/4pKOcVqidjssoxIgVRKOgx2us=;
        b=d9Bg8x5OzfRnNrAk48q1gvjlyJryGc7GKvOtsMx/MbhIRzeLJ3Ni5/7G3g3ybl2l9o
         QgNeelJJ3YFptb+fKaKFmVi16Th6kVmVAH8jUh8lNaGXueND65sSYxio8l9KPVRqSHbT
         d6uQUdYGa5VuiyxmDMVRWvHP74+MrnMtQzirN0j3zbm97i3ra8b03yIWJg9ocnJ4zS80
         rYaOExwvlvnjP7cHwilzLpLUqunR+rN6IQ5s+CtTUnUH1XbzEjmr6x9+qelods5UG544
         g9ZkkkA9IpiSC8dqVAjDcb1RfAs52pvKKX13skCTFa/x9fr5HKg5zhxZkzBUrbSI9aKt
         Z73A==
X-Gm-Message-State: AOAM533b8SHHcLqayLkcT9x26IqIRCBE2celCPpTyI7PX0qtUHwVJjN5
        gTYKNtDwAEIz5xy1lB0qSWm/P8niS7K9EEdP8Gdj+E3LKly2
X-Google-Smtp-Source: ABdhPJwKd51xEWLx8FVATB5A+8qUhdFzXqWkKgcFO/VwF86osgxt2EXGo7Tuoj6ngxoC0gZK/vYoBaeYBj2H8XibYnaYWU9fTWLc
MIME-Version: 1.0
X-Received: by 2002:a5e:8d04:: with SMTP id m4mr4385438ioj.107.1598767696846;
 Sat, 29 Aug 2020 23:08:16 -0700 (PDT)
Date:   Sat, 29 Aug 2020 23:08:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a624ac05ae121c86@google.com>
Subject: KMSAN: uninit-value in translate_table
From:   syzbot <syzbot+1b3443758a99dc0f4ac6@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce8056d1 wip: changed copy_from_user where instrumented
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=140f36b6900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3afe005fb99591f
dashboard link: https://syzkaller.appspot.com/bug?extid=1b3443758a99dc0f4ac6
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1b3443758a99dc0f4ac6@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in check_entry_size_and_hooks net/ipv4/netfilter/ip_tables.c:599 [inline]
BUG: KMSAN: uninit-value in translate_table+0xde9/0x3c90 net/ipv4/netfilter/ip_tables.c:685
CPU: 1 PID: 16172 Comm: syz-executor.2 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 check_entry_size_and_hooks net/ipv4/netfilter/ip_tables.c:599 [inline]
 translate_table+0xde9/0x3c90 net/ipv4/netfilter/ip_tables.c:685
 translate_compat_table net/ipv4/netfilter/ip_tables.c:1465 [inline]
 compat_do_replace net/ipv4/netfilter/ip_tables.c:1519 [inline]
 compat_do_ipt_set_ctl+0x34fc/0x4310 net/ipv4/netfilter/ip_tables.c:1548
 compat_nf_sockopt+0x904/0x980 net/netfilter/nf_sockopt.c:146
 compat_nf_setsockopt+0x122/0x160 net/netfilter/nf_sockopt.c:156
 compat_ip_setsockopt+0x46f/0x1940 net/ipv4/ip_sockglue.c:1449
 inet_csk_compat_setsockopt+0x161/0x240 net/ipv4/inet_connection_sock.c:1087
 compat_tcp_setsockopt+0x187/0x1a0 net/ipv4/tcp.c:3345
 compat_sock_common_setsockopt+0x1a3/0x1c0 net/core/sock.c:3275
 __compat_sys_setsockopt+0x4be/0x9c0 net/compat.c:402
 __do_compat_sys_setsockopt net/compat.c:415 [inline]
 __se_compat_sys_setsockopt+0xdd/0x100 net/compat.c:412
 __ia32_compat_sys_setsockopt+0x62/0x80 net/compat.c:412
 do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
 __do_fast_syscall_32+0x2af/0x480 arch/x86/entry/common.c:477
 do_fast_syscall_32+0x6b/0xd0 arch/x86/entry/common.c:505
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:554
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f23549
Code: Bad RIP value.
RSP: 002b:00000000f551d0cc EFLAGS: 00000296 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000040 RSI: 0000000020000000 RDI: 00000000000002a4
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2839 [inline]
 __kmalloc_node+0xe70/0x1280 mm/slub.c:3959
 kmalloc_node include/linux/slab.h:578 [inline]
 kvmalloc_node+0x205/0x490 mm/util.c:574
 kvmalloc include/linux/mm.h:753 [inline]
 xt_alloc_table_info+0xda/0x1b0 net/netfilter/x_tables.c:1176
 translate_compat_table net/ipv4/netfilter/ip_tables.c:1429 [inline]
 compat_do_replace net/ipv4/netfilter/ip_tables.c:1519 [inline]
 compat_do_ipt_set_ctl+0x1a64/0x4310 net/ipv4/netfilter/ip_tables.c:1548
 compat_nf_sockopt+0x904/0x980 net/netfilter/nf_sockopt.c:146
 compat_nf_setsockopt+0x122/0x160 net/netfilter/nf_sockopt.c:156
 compat_ip_setsockopt+0x46f/0x1940 net/ipv4/ip_sockglue.c:1449
 inet_csk_compat_setsockopt+0x161/0x240 net/ipv4/inet_connection_sock.c:1087
 compat_tcp_setsockopt+0x187/0x1a0 net/ipv4/tcp.c:3345
 compat_sock_common_setsockopt+0x1a3/0x1c0 net/core/sock.c:3275
 __compat_sys_setsockopt+0x4be/0x9c0 net/compat.c:402
 __do_compat_sys_setsockopt net/compat.c:415 [inline]
 __se_compat_sys_setsockopt+0xdd/0x100 net/compat.c:412
 __ia32_compat_sys_setsockopt+0x62/0x80 net/compat.c:412
 do_syscall_32_irqs_on arch/x86/entry/common.c:430 [inline]
 __do_fast_syscall_32+0x2af/0x480 arch/x86/entry/common.c:477
 do_fast_syscall_32+0x6b/0xd0 arch/x86/entry/common.c:505
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:554
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
