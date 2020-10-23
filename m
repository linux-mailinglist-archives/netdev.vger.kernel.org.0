Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF9296B4F
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460693AbgJWIi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:38:26 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:36254 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S460686AbgJWIiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 04:38:25 -0400
Received: by mail-io1-f69.google.com with SMTP id q126so560602iof.3
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 01:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NNX9a32jL2dtLFiIs4/qG67XV7h29NKLxh8Kvgre9/g=;
        b=XLYAzcuEd4LjvSAEBtkvq/pEoidqWDu75rXzWJ/o1bC2NkSWt+hM2yDgE3kFi5nNYG
         +EnSLazUTWpmH6zzCrX0kocgGH8YizddFhD7n2FNTKk6tep1ErncqrQqj7meExB4KIaf
         jX6OSejn6EmwkeTnWO+W8IxaMysE+XTes0RsnyHMqYUvpVFGmUd7EZ2pTZIsUTz6FZCI
         yiOcfEVhnkd7S4M1rYVQtzyu1LJwi52EXAnt4mxZqCT6TICoL7heER0kEWokJFfW1luP
         njAY716AlZTDjS3YLKS4GP1NC13Z6RdY/1Cnyy+ZLK3tknhIKvoCSjw0bBb5ZlgxlAu5
         o27w==
X-Gm-Message-State: AOAM530Ciz7BLkWeLHCJ6GNlO2zOTJwGrbD14g6N8fnzeE4Vy44XfoND
        o6BXE5wpf2lu21qmQ9GfkENOe1rKQG7tdstfbJe862rynqI+
X-Google-Smtp-Source: ABdhPJxoGcFofBivvZnJY3vQBA0GfkYQSotaL+VPP0B72hlb14G2cfobpjyqapQ9VvxU2U6+WreAMQ/KEo/HliUrmKi8cw+FNajD
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13f4:: with SMTP id w20mr886083ilj.1.1603442303933;
 Fri, 23 Oct 2020 01:38:23 -0700 (PDT)
Date:   Fri, 23 Oct 2020 01:38:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1a42205b2528067@google.com>
Subject: KASAN: slab-out-of-bounds Write in xfrm_attr_cpy32
From:   syzbot <syzbot+c43831072e7df506a646@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c4d6fe73 Merge tag 'xarray-5.9' of git://git.infradead.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1117ff78500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e8379456358b93c
dashboard link: https://syzkaller.appspot.com/bug?extid=c43831072e7df506a646
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c43831072e7df506a646@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:384 [inline]
BUG: KASAN: slab-out-of-bounds in xfrm_attr_cpy32+0x15a/0x1d0 net/xfrm/xfrm_compat.c:393
Write of size 4 at addr ffff88801c57e6c0 by task syz-executor.0/9498

CPU: 1 PID: 9498 Comm: syz-executor.0 Not tainted 5.9.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 check_memory_region_inline mm/kasan/generic.c:186 [inline]
 check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
 memset+0x20/0x40 mm/kasan/common.c:84
 memset include/linux/string.h:384 [inline]
 xfrm_attr_cpy32+0x15a/0x1d0 net/xfrm/xfrm_compat.c:393
 xfrm_xlate32_attr net/xfrm/xfrm_compat.c:426 [inline]
 xfrm_xlate32 net/xfrm/xfrm_compat.c:525 [inline]
 xfrm_user_rcv_msg_compat+0x76b/0x1040 net/xfrm/xfrm_compat.c:570
 xfrm_user_rcv_msg+0x55b/0x8b0 net/xfrm/xfrm_user.c:2714
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2764
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f86549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f55800bc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000200001c0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 9498:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 kmalloc_node include/linux/slab.h:577 [inline]
 kvmalloc_node+0x61/0xf0 mm/util.c:575
 kvmalloc include/linux/mm.h:765 [inline]
 xfrm_user_rcv_msg_compat+0x3cd/0x1040 net/xfrm/xfrm_compat.c:566
 xfrm_user_rcv_msg+0x55b/0x8b0 net/xfrm/xfrm_user.c:2714
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2764
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Last call_rcu():
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_record_aux_stack+0x82/0xb0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2953 [inline]
 call_rcu+0xbb/0x700 kernel/rcu/tree.c:3027
 nf_hook_entries_free net/netfilter/core.c:88 [inline]
 nf_hook_entries_free net/netfilter/core.c:75 [inline]
 __nf_register_net_hook+0x2aa/0x610 net/netfilter/core.c:424
 nf_register_net_hook+0x114/0x170 net/netfilter/core.c:541
 nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
 ip6t_register_table+0x235/0x2f0 net/ipv6/netfilter/ip6_tables.c:1757
 ip6table_security_table_init net/ipv6/netfilter/ip6table_security.c:58 [inline]
 ip6table_security_table_init+0x82/0xc0 net/ipv6/netfilter/ip6table_security.c:47
 xt_find_table_lock+0x2d4/0x540 net/netfilter/x_tables.c:1223
 xt_request_find_table_lock+0x27/0xf0 net/netfilter/x_tables.c:1253
 get_info+0x16a/0x740 net/ipv6/netfilter/ip6_tables.c:980
 do_ip6t_get_ctl+0x152/0xa10 net/ipv6/netfilter/ip6_tables.c:1660
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ipv6_getsockopt+0x1be/0x270 net/ipv6/ipv6_sockglue.c:1486
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:3880
 __sys_getsockopt+0x219/0x4c0 net/socket.c:2173
 __do_compat_sys_socketcall+0x513/0x660 net/compat.c:495
 do_syscall_32_irqs_on arch/x86/entry/common.c:78 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:137
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:160
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

The buggy address belongs to the object at ffff88801c57e600
 which belongs to the cache kmalloc-192 of size 192
The buggy address is located 0 bytes to the right of
 192-byte region [ffff88801c57e600, ffff88801c57e6c0)
The buggy address belongs to the page:
page:00000000d5f129f9 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88801c57eb00 pfn:0x1c57e
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffff888010041140 ffffea00008066c8 ffff888010040000
raw: ffff88801c57eb00 ffff88801c57e000 000000010000000b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801c57e580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff88801c57e600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88801c57e680: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
                                           ^
 ffff88801c57e700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801c57e780: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
