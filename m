Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE8A246FAE
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 19:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbgHQRvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 13:51:42 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:38866 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731387AbgHQRvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 13:51:23 -0400
Received: by mail-il1-f200.google.com with SMTP id t79so12519914ild.5
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 10:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jtcE9RlLgcXYjCTz74DN683CktsK5ycgf7I8jYj6CIA=;
        b=t6qQ7KyXvCYwQpjSNb0CbukKzl6Ewo0R76Mn8q7s0SQRYy4PwXhPPoXcab4XFydL7R
         Lcqj6k1JPFht+hO4aJwIxrXzOGEFyXTEwtZMDlYJteZlzClTPR/JjfMp1+/mTLByixJi
         pNJh/ohSFK29JGTFeah9DMWqsPTBA8WmCda/cgZhJp000kFmIQTORnZJiLMYbt67uucy
         AQioDo7J3t9ITmncS5GDwc9w7M/Evx3um2fxT8mG2M6Gcjx0PbCxIt/MfVvCHxJjtqco
         tC5+S5dog6P7bXaAj92Fw3ZlBItVbDevpANNRNBdMGpBNdjWID+Lbf3DuPDUSy/sKhAf
         tQLw==
X-Gm-Message-State: AOAM532NF5qKwJZiU5GSiWwX7qyC4i0fBZlBsy+Om2FThfIq0mPr2oit
        bMfpmFDj0edYm49sezrR9E9VCg2clGQ9ilKSAND9FIf5/smP
X-Google-Smtp-Source: ABdhPJwWXTJZH/tUbtofby2vODuwxMNHTDwDDML2YNXnT1gAkNHwpDyqDv03J3HxAw+N2jEzJgYm6mBzyvQ/fVbnYwNlSrB+VyEJ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:419:: with SMTP id q25mr15885995jap.85.1597686681864;
 Mon, 17 Aug 2020 10:51:21 -0700 (PDT)
Date:   Mon, 17 Aug 2020 10:51:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000022934305ad166be3@google.com>
Subject: KASAN: slab-out-of-bounds Write in xt_compat_target_from_user
From:   syzbot <syzbot+cfc0247ac173f597aaaa@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4b6c093e Merge tag 'block-5.9-2020-08-14' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14741412900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a98b778f5fca0653
dashboard link: https://syzkaller.appspot.com/bug?extid=cfc0247ac173f597aaaa
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1283a731900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10dd10ce900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfc0247ac173f597aaaa@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:391 [inline]
BUG: KASAN: slab-out-of-bounds in xt_compat_target_from_user+0x232/0x470 net/netfilter/x_tables.c:1129
Write of size 4 at addr ffff88809c971ba1 by task syz-executor166/6841

CPU: 1 PID: 6841 Comm: syz-executor166 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 memset+0x20/0x40 mm/kasan/common.c:84
 memset include/linux/string.h:391 [inline]
 xt_compat_target_from_user+0x232/0x470 net/netfilter/x_tables.c:1129
 compat_copy_entry_from_user net/ipv6/netfilter/ip6_tables.c:1392 [inline]
 translate_compat_table+0x1011/0x1720 net/ipv6/netfilter/ip6_tables.c:1455
 compat_do_replace.constprop.0+0x1f0/0x470 net/ipv6/netfilter/ip6_tables.c:1526
 do_ip6t_set_ctl+0x5b0/0xb73 net/ipv6/netfilter/ip6_tables.c:1633
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x122/0x180 net/ipv6/ipv6_sockglue.c:1008
 udpv6_setsockopt+0x76/0xc0 net/ipv6/udp.c:1626
 __sys_setsockopt+0x2db/0x610 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __ia32_sys_setsockopt+0xb9/0x150 net/socket.c:2140
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x57/0x80 arch/x86/entry/common.c:126
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fd3549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f7fad18c EFLAGS: 00000292 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000000000029
RDX: 0000000000000040 RSI: 0000000020000a00 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 6841:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmalloc_node include/linux/slab.h:577 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:574
 kvmalloc include/linux/mm.h:750 [inline]
 xt_alloc_table_info+0x3c/0xa0 net/netfilter/x_tables.c:1176
 translate_compat_table+0xc50/0x1720 net/ipv6/netfilter/ip6_tables.c:1442
 compat_do_replace.constprop.0+0x1f0/0x470 net/ipv6/netfilter/ip6_tables.c:1526
 do_ip6t_set_ctl+0x5b0/0xb73 net/ipv6/netfilter/ip6_tables.c:1633
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x122/0x180 net/ipv6/ipv6_sockglue.c:1008
 udpv6_setsockopt+0x76/0xc0 net/ipv6/udp.c:1626
 __sys_setsockopt+0x2db/0x610 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2143 [inline]
 __se_sys_setsockopt net/socket.c:2140 [inline]
 __ia32_sys_setsockopt+0xb9/0x150 net/socket.c:2140
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x57/0x80 arch/x86/entry/common.c:126
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

The buggy address belongs to the object at ffff88809c971800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 929 bytes inside of
 1024-byte region [ffff88809c971800, ffff88809c971c00)
The buggy address belongs to the page:
page:00000000d9974640 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88809c971000 pfn:0x9c971
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea000269a448 ffffea00027cc908 ffff8880aa040700
raw: ffff88809c971000 ffff88809c971000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809c971a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88809c971b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88809c971b80: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                               ^
 ffff88809c971c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809c971c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
