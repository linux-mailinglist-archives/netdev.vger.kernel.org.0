Return-Path: <netdev+bounces-10060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1338172BCE0
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53D3E1C20A31
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A977F182C6;
	Mon, 12 Jun 2023 09:40:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E49C18B01
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:40:56 +0000 (UTC)
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCB61730
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:40:52 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-777ab76f328so360767339f.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686562852; x=1689154852;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kfYqGXcZCJG3QZnCnhuyj9cVlmftF9FOW17Z0xBS6XU=;
        b=LPonZhjA094dWE+yrlNJ961b0hfLrzzeRJL/WCKyTxAQBGGTbZTluY8mz9p8so/t/d
         tsLycuEEZGnPdKyWjLDNmQ+xc21Z3J6k1wo6OYbYNh7VQZDgruqfRFRBAuXPZJpsyEuY
         RB2fobwPOSxZCxssvypXQMiMEzUeLX5QDwdGDz0mThC5uM4luECgG1W5szqn50QWSIIw
         0L1xfNnVxnuN5H6dbZvaoIhq5jAxTmp15nQ70KJZMrfWFqUIyDwllbP3FzqaPIjdc+3f
         WV7juMu/w8VTEgfCUCI3xV9/BGbx0tgA/U2fEaq2ozWcwOcLKe4W55LCrhvOHW1xms1w
         Ir7A==
X-Gm-Message-State: AC+VfDyFPNweZjcJINqVXxWI93kFFWed5c5RUT15O8kgza9/yVciXbu1
	UpxBonHi/ekoaHkDWxJwZEi5FX0v7Att65hjEpF/Dcb/NRYy
X-Google-Smtp-Source: ACHHUZ4c0nOVnqZMoMWM/bLdD3IBiTtYor/ZM78/8EBD8eAUxbtBI8T0b1ttjP8fuarSqOaoO5u5Ld7pv0vkUUAIl8hmFGMiGb24
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2b15:b0:774:8680:b95b with SMTP id
 p21-20020a0566022b1500b007748680b95bmr6980256iov.1.1686562852195; Mon, 12 Jun
 2023 02:40:52 -0700 (PDT)
Date: Mon, 12 Jun 2023 02:40:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2585a05fdeb8379@google.com>
Subject: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
From: syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	kuba@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    e7c5433c5aaa tools: ynl: Remove duplicated include in hand..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=112cc875280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=6efc50cc1f8d718d6cb7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=104f3fa5280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176d012d280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/13c08af1fd21/disk-e7c5433c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/35820511752b/vmlinux-e7c5433c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6a8cbec0d40f/bzImage-e7c5433c.xz

The issue was bisected to:

commit 2dc334f1a63a8839b88483a3e73c0f27c9c1791c
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jun 7 18:19:09 2023 +0000

    splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c10c75280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c10c75280000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c10c75280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com
Fixes: 2dc334f1a63a ("splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()")

==================================================================
BUG: KASAN: slab-out-of-bounds in sg_assign_page include/linux/scatterlist.h:109 [inline]
BUG: KASAN: slab-out-of-bounds in sg_set_page include/linux/scatterlist.h:139 [inline]
BUG: KASAN: slab-out-of-bounds in extract_bvec_to_sg lib/scatterlist.c:1183 [inline]
BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg lib/scatterlist.c:1352 [inline]
BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg+0x17a6/0x1960 lib/scatterlist.c:1339
Read of size 8 at addr ffff88807e016ff8 by task syz-executor415/5028

CPU: 1 PID: 5028 Comm: syz-executor415 Not tainted 6.4.0-rc5-syzkaller-00915-ge7c5433c5aaa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_address_description.constprop.0+0x2c/0x3c0 mm/kasan/report.c:351
 print_report mm/kasan/report.c:462 [inline]
 kasan_report+0x11c/0x130 mm/kasan/report.c:572
 sg_assign_page include/linux/scatterlist.h:109 [inline]
 sg_set_page include/linux/scatterlist.h:139 [inline]
 extract_bvec_to_sg lib/scatterlist.c:1183 [inline]
 extract_iter_to_sg lib/scatterlist.c:1352 [inline]
 extract_iter_to_sg+0x17a6/0x1960 lib/scatterlist.c:1339
 af_alg_sendmsg+0x1917/0x2990 crypto/af_alg.c:1045
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 splice_to_socket+0x954/0xe30 fs/splice.c:917
 do_splice_from fs/splice.c:969 [inline]
 direct_splice_actor+0x114/0x180 fs/splice.c:1157
 splice_direct_to_actor+0x34a/0x9c0 fs/splice.c:1103
 do_splice_direct+0x1ad/0x280 fs/splice.c:1209
 do_sendfile+0xb19/0x12c0 fs/read_write.c:1254
 __do_sys_sendfile64 fs/read_write.c:1316 [inline]
 __se_sys_sendfile64 fs/read_write.c:1308 [inline]
 __x64_sys_sendfile64+0x14d/0x210 fs/read_write.c:1308
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f8d65191a89
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8d65101308 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f8d65219428 RCX: 00007f8d65191a89
RDX: 0000000020000180 RSI: 0000000000000003 RDI: 0000000000000005
RBP: 00007f8d65219420 R08: 00007f8d65101700 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f8d6521942c
R13: 00007f8d651e7064 R14: 7265687069636b73 R15: 0000000000022000
 </TASK>

Allocated by task 5028:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kasan_kmalloc include/linux/kasan.h:196 [inline]
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc+0x5e/0x190 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 sock_kmalloc+0xb2/0x100 net/core/sock.c:2630
 af_alg_alloc_tsgl crypto/af_alg.c:614 [inline]
 af_alg_sendmsg+0x17a4/0x2990 crypto/af_alg.c:1028
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 splice_to_socket+0x954/0xe30 fs/splice.c:917
 do_splice_from fs/splice.c:969 [inline]
 direct_splice_actor+0x114/0x180 fs/splice.c:1157
 splice_direct_to_actor+0x34a/0x9c0 fs/splice.c:1103
 do_splice_direct+0x1ad/0x280 fs/splice.c:1209
 do_sendfile+0xb19/0x12c0 fs/read_write.c:1254
 __do_sys_sendfile64 fs/read_write.c:1316 [inline]
 __se_sys_sendfile64 fs/read_write.c:1308 [inline]
 __x64_sys_sendfile64+0x14d/0x210 fs/read_write.c:1308
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff88807e016000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes to the right of
 allocated 4088-byte region [ffff88807e016000, ffff88807e016ff8)

The buggy address belongs to the physical page:
page:ffffea0001f80400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7e010
head:ffffea0001f80400 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5019, tgid 5019 (modprobe), ts 80491362379, free_ts 80455993447
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0x2db/0x350 mm/page_alloc.c:1731
 prep_new_page mm/page_alloc.c:1738 [inline]
 get_page_from_freelist+0xf41/0x2c00 mm/page_alloc.c:3502
 __alloc_pages+0x1cb/0x4a0 mm/page_alloc.c:4768
 alloc_pages+0x1aa/0x270 mm/mempolicy.c:2279
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab+0x25f/0x390 mm/slub.c:1998
 new_slab mm/slub.c:2051 [inline]
 ___slab_alloc+0xa91/0x1400 mm/slub.c:3192
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3291
 __slab_alloc_node mm/slub.c:3344 [inline]
 slab_alloc_node mm/slub.c:3441 [inline]
 __kmem_cache_alloc_node+0x136/0x320 mm/slub.c:3490
 __do_kmalloc_node mm/slab_common.c:965 [inline]
 __kmalloc+0x4e/0x190 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 tomoyo_realpath_from_path+0xc3/0x600 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x230/0x430 security/tomoyo/file.c:822
 security_inode_getattr+0xd3/0x140 security/security.c:2114
 vfs_getattr fs/stat.c:167 [inline]
 vfs_statx+0x16e/0x430 fs/stat.c:242
 vfs_fstatat+0x90/0xb0 fs/stat.c:276
 __do_sys_newfstatat+0x8a/0x110 fs/stat.c:446
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2564
 free_unref_page+0x33/0x370 mm/page_alloc.c:2659
 __folio_put_large mm/swap.c:119 [inline]
 __folio_put+0x109/0x140 mm/swap.c:127
 folio_put include/linux/mm.h:1430 [inline]
 put_page+0x21b/0x280 include/linux/mm.h:1499
 page_to_skb+0x810/0xa10 drivers/net/virtio_net.c:560
 receive_mergeable drivers/net/virtio_net.c:1469 [inline]
 receive_buf+0x1128/0x5020 drivers/net/virtio_net.c:1590
 virtnet_receive drivers/net/virtio_net.c:1888 [inline]
 virtnet_poll+0x742/0x14b0 drivers/net/virtio_net.c:1960
 __napi_poll+0xb7/0x6f0 net/core/dev.c:6501
 napi_poll net/core/dev.c:6568 [inline]
 net_rx_action+0x8a9/0xcb0 net/core/dev.c:6701
 __do_softirq+0x1d4/0x905 kernel/softirq.c:571

Memory state around the buggy address:
 ffff88807e016e80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88807e016f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88807e016f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
                                                                ^
 ffff88807e017000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807e017080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

