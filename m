Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B315632B3C2
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575707AbhCCEFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:05:55 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45882 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581830AbhCBT0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 14:26:40 -0500
Received: by mail-il1-f199.google.com with SMTP id h17so15519350ila.12
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 11:25:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WrlNkCVLGr0mzW3+32pC5PICqOkaPJmw5egB6iwHbuw=;
        b=aJkYPADkgLK5U4Qorn8BaDBFgmEiKV5eQbKlNnNyzNNo88Klgbbmd7t4rNWHt1KZIV
         S3Q/NzQ77nlwHQJN0U0Z5B7uUk4NB7dfbXAQseAXwaIZTaq/FI5a3icvA0hXAu/67AMZ
         ml+ayM0Ne1m7CP3ueh50NEQhM//AGUZSwsytpKFHjwihFe/vE+7HfRcU8bq9rHJ61o9K
         qgQSKZD09DlaT6JpC5mlwBln7HGeK6y466lH9lPR34FHgL9AgcWwxPJBtQKo9SQZhlvx
         4dkbDYiQkorttwg1xzwVEnoXMeP8U+J6u+b9o1D6UsTnVJsU00iffOpzvnA2sIC/VxUF
         ZU3Q==
X-Gm-Message-State: AOAM5335MYpm7xiNJnNFqsl1Lej60gsmbud/34UuEripQ1LQcStDpBHb
        Q/rt1PybVTZZd2ZrfWR9QGfAIx4LM6HT4VvWxFdwivmZ9Nye
X-Google-Smtp-Source: ABdhPJyyz3cdmnyJpZd5jWz2O6evU8FiTx9kKT9wI7Pkc1Af3C6846b8yN7SR3iSeM8A8pXe8Q5/eVYE1eEzaBntFDdLNckF0L/O
MIME-Version: 1.0
X-Received: by 2002:a02:a889:: with SMTP id l9mr18226678jam.1.1614713118093;
 Tue, 02 Mar 2021 11:25:18 -0800 (PST)
Date:   Tue, 02 Mar 2021 11:25:18 -0800
In-Reply-To: <0000000000006305c005bc8ba7f0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d1747205bc92b14c@google.com>
Subject: Re: KASAN: use-after-free Read in cipso_v4_genopt
From:   syzbot <syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, dvyukov@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    7a7fd0de Merge branch 'kmap-conversion-for-5.12' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13693866d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=779a2568b654c1c6
dashboard link: https://syzkaller.appspot.com/bug?extid=9ec037722d2603a9f52e
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1576737ad00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=107bdcead00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cipso_v4_genopt+0x1078/0x1700 net/ipv4/cipso_ipv4.c:1784
Read of size 1 at addr ffff8881437d5710 by task syz-executor557/8392

CPU: 1 PID: 8392 Comm: syz-executor557 Not tainted 5.12.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x125/0x19e lib/dump_stack.c:120
 print_address_description+0x5f/0x3a0 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report+0x15e/0x210 mm/kasan/report.c:416
 cipso_v4_genopt+0x1078/0x1700 net/ipv4/cipso_ipv4.c:1784
 cipso_v4_sock_setattr+0x7c/0x460 net/ipv4/cipso_ipv4.c:1866
 netlbl_sock_setattr+0x28e/0x2f0 net/netlabel/netlabel_kapi.c:995
 smack_netlbl_add security/smack/smack_lsm.c:2404 [inline]
 smack_socket_post_create+0x13b/0x280 security/smack/smack_lsm.c:2774
 security_socket_post_create+0x6f/0xd0 security/security.c:2122
 __sock_create+0x62f/0x8c0 net/socket.c:1424
 sock_create net/socket.c:1459 [inline]
 __sys_socket+0xde/0x2d0 net/socket.c:1501
 __do_sys_socket net/socket.c:1510 [inline]
 __se_sys_socket net/socket.c:1508 [inline]
 __x64_sys_socket+0x76/0x80 net/socket.c:1508
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x440999
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcfe002d48 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 000000000000b3fc RCX: 0000000000440999
RDX: 0000000000000002 RSI: 0000000000000003 RDI: 0000040000000002
RBP: 0000000000000000 R08: 00007ffcfe002ee8 R09: 00007ffcfe002ee8
R10: 0000000000000012 R11: 0000000000000246 R12: 00007ffcfe002d5c
R13: 431bde82d7b634db R14: 00000000004ae018 R15: 00000000004004a0

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc+0xc2/0xf0 mm/kasan/common.c:506
 kasan_kmalloc include/linux/kasan.h:233 [inline]
 kmem_cache_alloc_trace+0x21b/0x340 mm/slub.c:2934
 kmalloc include/linux/slab.h:554 [inline]
 smk_cipso_doi+0x1af/0x4e0 security/smack/smackfs.c:696
 init_smk_fs+0xe2/0x24e security/smack/smackfs.c:3010
 do_one_initcall+0x12b/0x310 init/main.c:1226
 do_initcall_level+0x14a/0x1f5 init/main.c:1299
 do_initcalls+0x4b/0x8c init/main.c:1315
 kernel_init_freeable+0x2e3/0x406 init/main.c:1537
 kernel_init+0xd/0x290 init/main.c:1424
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Freed by task 0:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:357
 ____kasan_slab_free+0x100/0x140 mm/kasan/common.c:360
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x13a/0x200 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xcf/0x2b0 mm/slub.c:4213
 rcu_do_batch kernel/rcu/tree.c:2559 [inline]
 rcu_core+0x7a0/0x1220 kernel/rcu/tree.c:2794
 __do_softirq+0x318/0x714 kernel/softirq.c:345

Last potentially related work creation:
 kasan_save_stack+0x27/0x50 mm/kasan/common.c:38
 kasan_record_aux_stack+0xee/0x120 mm/kasan/generic.c:345
 __call_rcu kernel/rcu/tree.c:3039 [inline]
 call_rcu+0x12f/0x8a0 kernel/rcu/tree.c:3114
 cipso_v4_doi_remove+0x2e2/0x310 net/ipv4/cipso_ipv4.c:531
 netlbl_cipsov4_remove+0x219/0x390 net/netlabel/netlabel_cipso_v4.c:715
 genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x9ae/0xd50 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2350
 ___sys_sendmsg net/socket.c:2404 [inline]
 __sys_sendmsg+0x2bf/0x370 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff8881437d5700
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 16 bytes inside of
 64-byte region [ffff8881437d5700, ffff8881437d5740)
The buggy address belongs to the page:
page:000000003e519aab refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8881437d5b00 pfn:0x1437d5
flags: 0x57ff00000000200(slab)
raw: 057ff00000000200 ffffea000511ff88 ffffea00051d0a48 ffff888010841640
raw: ffff8881437d5b00 0000000000200019 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881437d5600: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff8881437d5680: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>ffff8881437d5700: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                         ^
 ffff8881437d5780: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff8881437d5800: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
==================================================================

