Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECC33E48FD
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 17:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhHIPiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 11:38:50 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46790 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbhHIPip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 11:38:45 -0400
Received: by mail-io1-f70.google.com with SMTP id r14-20020a6b440e0000b029057f73c98d95so12716777ioa.13
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 08:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BdJirXB7btrLeLyIBeAIMwIc5H2etwKlwiWTkvV0E4Q=;
        b=cnwF1W7oe6bVUF7km2TXAR5ErQNpjQhzQp/Q6eUj/j/LjOTfT7LIUG15mvaScaGq2y
         1T/OwVp3ezeu0du2dsTaqQqU0HehZ/zzR79oBW5qd64IxWq2mOXHccizCk9psltOrjiB
         pYgUZSsy7CnT9GpeVuvD7mlpfm1TRqdBATgaK7wU+QxoeZkfU1OpkZyx1Eqy4S220qxb
         +T0XUzuGLgABQr+Dn8B7UXSKGy4/l7W7teP9Cpue7S9hcxxZ/taNDKGvxcvDUWdPuLeh
         CbQ9gAyDkJv3mYq4xVTHsRK8yVl8Jivx7a+AVDiAVZkNnfapJRx9jxsoTL+gVXH4OAcH
         GPsw==
X-Gm-Message-State: AOAM531AKoUaV34tsJscYR54zW9AhS5k4XoQSPEWxckWAPvVRKRIkf/4
        njOuoRpaXgaZnbt8YnoD50KwNrwoCw6TbqnUiqeBJV2lFoN7
X-Google-Smtp-Source: ABdhPJwkt7lgnlUdFT2+vjKgvwrNCh5POzw2VmRc83UX9ruFzLnbYzVRrgdDDCMMyhHoppetrA/kWgq/re29S1T/T/JlwerjCvdy
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13b1:: with SMTP id h17mr97780ilo.292.1628523505139;
 Mon, 09 Aug 2021 08:38:25 -0700 (PDT)
Date:   Mon, 09 Aug 2021 08:38:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000845ce05c9222d57@google.com>
Subject: [syzbot] KASAN: use-after-free Read in nf_tables_dump_sets
From:   syzbot <syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f9be84db09d2 net: bonding: bond_alb: Remove the dependency..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1070243a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8075b2614f3db143
dashboard link: https://syzkaller.appspot.com/bug?extid=8cc940a9689599e10587
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fbb98e300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8cc940a9689599e10587@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in nf_tables_dump_sets+0xadf/0xaf0 net/netfilter/nf_tables_api.c:4001
Read of size 8 at addr ffff8880166ab580 by task syz-executor.0/26444

CPU: 0 PID: 26444 Comm: syz-executor.0 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 nf_tables_dump_sets+0xadf/0xaf0 net/netfilter/nf_tables_api.c:4001
 netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2278
 __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2383
 netlink_dump_start include/linux/netlink.h:258 [inline]
 nft_netlink_dump_start_rcu+0x83/0x1c0 net/netfilter/nf_tables_api.c:859
 nf_tables_getset+0x71d/0x860 net/netfilter/nf_tables_api.c:4083
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2c24718188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
RDX: 0000000000000000 RSI: 0000000020000d80 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fffb1c1ca2f R14: 00007f2c24718300 R15: 0000000000022000

Allocated by task 26444:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 nf_tables_newtable+0xe3e/0x1b40 net/netfilter/nf_tables_api.c:1112
 nfnetlink_rcv_batch+0x1710/0x25f0 net/netfilter/nfnetlink.c:513
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 26443:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1625 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
 slab_free mm/slub.c:3210 [inline]
 kfree+0xe4/0x530 mm/slub.c:4264
 nf_tables_table_destroy+0x13f/0x1b0 net/netfilter/nf_tables_api.c:1315
 __nft_release_table+0xabc/0xe30 net/netfilter/nf_tables_api.c:9603
 nft_rcv_nl_event+0x4af/0x590 net/netfilter/nf_tables_api.c:9645
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:83
 blocking_notifier_call_chain kernel/notifier.c:337 [inline]
 blocking_notifier_call_chain+0x67/0x90 kernel/notifier.c:325
 netlink_release+0xcb8/0x1dd0 net/netlink/af_netlink.c:785
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1311
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff8880166ab400
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 384 bytes inside of
 512-byte region [ffff8880166ab400, ffff8880166ab600)
The buggy address belongs to the page:
page:ffffea000059aa00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x166a8
head:ffffea000059aa00 order:2 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffffea00009eb300 0000000400000004 ffff888010841c80
raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd28c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 23643, ts 1730415746365, free_ts 1727523669671
 prep_new_page mm/page_alloc.c:2436 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4169
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5391
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1688 [inline]
 allocate_slab+0x32e/0x4b0 mm/slub.c:1828
 new_slab mm/slub.c:1891 [inline]
 new_slab_objects mm/slub.c:2637 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2800
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2840
 slab_alloc_node mm/slub.c:2922 [inline]
 __kmalloc_node_track_caller+0x2e3/0x360 mm/slub.c:4650
 kmalloc_reserve net/core/skbuff.c:355 [inline]
 pskb_expand_head+0x15e/0x1060 net/core/skbuff.c:1700
 netlink_trim+0x1ea/0x240 net/netlink/af_netlink.c:1296
 netlink_unicast+0xb9/0x7d0 net/netlink/af_netlink.c:1330
 nlmsg_unicast include/net/netlink.h:1050 [inline]
 nlmsg_notify+0x106/0x290 net/netlink/af_netlink.c:2555
 nf_tables_gen_notify net/netfilter/nf_tables_api.c:7882 [inline]
 nf_tables_commit+0x1c1e/0x47f0 net/netfilter/nf_tables_api.c:8714
 nfnetlink_rcv_batch+0xbac/0x25f0 net/netfilter/nfnetlink.c:562
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:652
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3411
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2956 [inline]
 slab_alloc mm/slub.c:2964 [inline]
 kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2969
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags include/linux/audit.h:319 [inline]
 getname fs/namei.c:209 [inline]
 __do_sys_unlink fs/namei.c:4149 [inline]
 __se_sys_unlink fs/namei.c:4147 [inline]
 __x64_sys_unlink+0xb1/0x100 fs/namei.c:4147
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff8880166ab480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880166ab500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880166ab580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff8880166ab600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880166ab680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
