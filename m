Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F452A23C6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 05:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgKBEWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 23:22:16 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:33239 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgKBEWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 23:22:15 -0500
Received: by mail-io1-f69.google.com with SMTP id d202so4025099iof.0
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 20:22:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=K+fOsaaSKiVHTP9qikYZBZTjB/QP0yL49dxoJ7+stw4=;
        b=Jy6jBjAzo3DUk1aYDXxqIFez9NO3FFuXc3PrpZAucOfGgMyOnebZc+CMom+Qt/hAd7
         EcFpzMXaZNZOOq99C3PD4bWlHUj7XKE14RdhZVwPHqxN6R9Y7c+sA2yL22bzjgkdb8FH
         aNtDQZ5EIsMXL3IVoq8dRERrSbvRZ3QZA01paVM0PlLQeQNhGqirc9qq/F4rTTMuctWC
         zjB9aonbASGk9f/d4kz26Brvny1ulvS4cCXYzYy7Jv10UCFmHzp15eJVWSNwQp4VFS+i
         i4TRa7xxz8ExmBDQA+tjYhRJDX/Fng+ZeQJ83NmweYG66toXjy7nZE4JHZV+cPs1KRDe
         IVEg==
X-Gm-Message-State: AOAM532Krs/aNM5zE56LVF9MqpeRfcrHXKjY0pcglfjTnsiuiSNRRmLN
        jW2xIPuOOtyiY+QDlGskbNSphTZVc6QBMAZTW3Mn9Ds94Fuv
X-Google-Smtp-Source: ABdhPJyzQu86Lk648VLKFR6KxMD7+zwZ+KWGMnH3jh3uhTgzvEQRxs+IkS0BL7aGjGzfe7Z5DG1BIsGowEonWjiFHWC+Munox8NC
MIME-Version: 1.0
X-Received: by 2002:a02:c608:: with SMTP id i8mr10419110jan.42.1604290934494;
 Sun, 01 Nov 2020 20:22:14 -0800 (PST)
Date:   Sun, 01 Nov 2020 20:22:14 -0800
In-Reply-To: <000000000000f1a42205b2528067@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000445f0505b3181708@google.com>
Subject: Re: KASAN: slab-out-of-bounds Write in xfrm_attr_cpy32
From:   syzbot <syzbot+c43831072e7df506a646@syzkaller.appspotmail.com>
To:     0x7f454c46@gmail.com, davem@davemloft.net, dima@arista.com,
        hdanton@sina.com, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3cea11cd Linux 5.10-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16baaf46500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61033507391c77ff
dashboard link: https://syzkaller.appspot.com/bug?extid=c43831072e7df506a646
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1388676c500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158f642c500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c43831072e7df506a646@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in memset include/linux/string.h:384 [inline]
BUG: KASAN: slab-out-of-bounds in xfrm_attr_cpy32+0x15a/0x1d0 net/xfrm/xfrm_compat.c:393
Write of size 4 at addr ffff888147aba4fc by task syz-executor829/8497

CPU: 0 PID: 8497 Comm: syz-executor829 Not tainted 5.10.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x4c8 mm/kasan/report.c:385
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
RIP: 0023:0xf7fb2549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffdebbcc EFLAGS: 00000246 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000080
RDX: 0000000000000000 RSI: 00000000080ea078 RDI: 00000000ffdebc20
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 8497:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xc2/0xd0 mm/kasan/common.c:461
 kmalloc_node include/linux/slab.h:575 [inline]
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
 kasan_record_aux_stack+0xc0/0xf0 mm/kasan/generic.c:346
 __call_rcu kernel/rcu/tree.c:2953 [inline]
 call_rcu+0xbb/0x700 kernel/rcu/tree.c:3027
 rhashtable_rehash_table lib/rhashtable.c:345 [inline]
 rht_deferred_worker+0x10f4/0x1d40 lib/rhashtable.c:429
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3af/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

The buggy address belongs to the object at ffff888147aba400
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 252 bytes inside of
 256-byte region [ffff888147aba400, ffff888147aba500)
The buggy address belongs to the page:
page:00000000e11e2d62 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888147abbe00 pfn:0x147aba
head:00000000e11e2d62 order:1 compound_mapcount:0
flags: 0x57ff00000010200(slab|head)
raw: 057ff00000010200 ffffea000084e900 0000000700000007 ffff8880100413c0
raw: ffff888147abbe00 000000008010000f 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888147aba380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888147aba400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888147aba480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 04
                                                                ^
 ffff888147aba500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888147aba580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

