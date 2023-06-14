Return-Path: <netdev+bounces-10936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 603A3730B73
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 01:19:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83AC41C20E39
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 23:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A400F156D9;
	Wed, 14 Jun 2023 23:17:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C2B154A0
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 23:17:59 +0000 (UTC)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B7E2706
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:17:38 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-77ac1af4c54so903321439f.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:17:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686784658; x=1689376658;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mMfBDNZbm5MgpXMVDc7rVIdsLtVOMKaxZmrB5FMABlg=;
        b=PUSZvIR5BlglaLUhLQhwPSmTm2EwND0lClDIhqxfjhKhtdKadpup2yH3+NdsYj6FW9
         J/vvPRDKBas7jOOCNr2f4/SxmnbSCh0DGlWU6FZ+yR3acGUR82UX22Na3YCgM0xRGjgo
         T+N4gtxS2Kl5T8fITuanvVF+4IwOK5xCmNIYmZFgBHMFQnzLOli1pitaKcW2QhIMO6jt
         jVw166g3JreYaQkb8DI383UsK2Dgh9czKkfXzNrUZxJutNXtAMoaA6ys83ERwBPZF/N7
         rv1FB4uHaKiT67GqSxw0wn+15eLvMWJV59bzY4esO2qnjFYhXU3G/NVefMkWHS461Y9K
         UAcA==
X-Gm-Message-State: AC+VfDxqvLfCqh/TJ03HTxnVuY0A1pWHpwRDZw9wbYp4tM11IlS8ux/9
	DY3jslYVS7muDWxMphgFlrihtgjrQntKr1KMqk5l0flHUNAg
X-Google-Smtp-Source: ACHHUZ43IM3uK+pOWFPKlYjU/O2fe2jpz3Eni8pX2LLCePm6JP+4TSduhox/H1X4/3zQmOYpQimGSh45bdvyNmDZX7lQ1HkO9HUZ
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a6b:4401:0:b0:777:b713:22b5 with SMTP id
 r1-20020a6b4401000000b00777b71322b5mr6759142ioa.4.1686784658158; Wed, 14 Jun
 2023 16:17:38 -0700 (PDT)
Date: Wed, 14 Jun 2023 16:17:38 -0700
In-Reply-To: <1657853.1686757902@warthog.procyon.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005cb8f605fe1f28ce@google.com>
Subject: Re: [syzbot] [crypto?] KASAN: slab-out-of-bounds Read in extract_iter_to_sg
From: syzbot <syzbot+6efc50cc1f8d718d6cb7@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	kuba@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: slab-out-of-bounds Read in extract_iter_to_sg

==================================================================
BUG: KASAN: slab-out-of-bounds in sg_assign_page include/linux/scatterlist.h:109 [inline]
BUG: KASAN: slab-out-of-bounds in sg_set_page include/linux/scatterlist.h:139 [inline]
BUG: KASAN: slab-out-of-bounds in extract_bvec_to_sg lib/scatterlist.c:1183 [inline]
BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg lib/scatterlist.c:1352 [inline]
BUG: KASAN: slab-out-of-bounds in extract_iter_to_sg+0x180b/0x1970 lib/scatterlist.c:1339
Read of size 8 at addr ffff8880282aaff8 by task syz-executor.0/5450

CPU: 0 PID: 5450 Comm: syz-executor.0 Not tainted 6.4.0-rc5-syzkaller-gfa0e21fa4443-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
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
 extract_iter_to_sg+0x180b/0x1970 lib/scatterlist.c:1339
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
RIP: 0033:0x7f10eb08c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f10ebe5e168 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f10eb1ac120 RCX: 00007f10eb08c169
RDX: 0000000020000180 RSI: 0000000000000003 RDI: 0000000000000005
RBP: 00007f10eb0e7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffea268bd7f R14: 00007f10ebe5e300 R15: 0000000000022000
 </TASK>

Allocated by task 5450:
 kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
 kasan_set_track+0x25/0x30 mm/kasan/common.c:52
 ____kasan_kmalloc mm/kasan/common.c:374 [inline]
 ____kasan_kmalloc mm/kasan/common.c:333 [inline]
 __kasan_kmalloc+0xa2/0xb0 mm/kasan/common.c:383
 kasan_kmalloc include/linux/kasan.h:196 [inline]
 __do_kmalloc_node mm/slab_common.c:966 [inline]
 __kmalloc+0x5e/0x190 mm/slab_common.c:979
 kmalloc include/linux/slab.h:563 [inline]
 sock_kmalloc+0xb2/0x100 net/core/sock.c:2674
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

The buggy address belongs to the object at ffff8880282aa000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 0 bytes to the right of
 allocated 4088-byte region [ffff8880282aa000, ffff8880282aaff8)

The buggy address belongs to the physical page:
page:ffffea0000a0aa00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x282a8
head:ffffea0000a0aa00 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000010200 ffff888012442140 0000000000000000 0000000000000001
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 5156, tgid 5156 (dhcpcd-run-hook), ts 68845362597, free_ts 68027991491
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
 tomoyo_check_open_permission+0x29a/0x3a0 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:332 [inline]
 tomoyo_file_open+0xa1/0xc0 security/tomoyo/tomoyo.c:327
 security_file_open+0x49/0xb0 security/security.c:2797
 do_dentry_open+0x575/0x13f0 fs/open.c:907
 do_open fs/namei.c:3636 [inline]
 path_openat+0x1baa/0x2750 fs/namei.c:3791
 do_filp_open+0x1ba/0x410 fs/namei.c:3818
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1302 [inline]
 free_unref_page_prepare+0x62e/0xcb0 mm/page_alloc.c:2564
 free_unref_page+0x33/0x370 mm/page_alloc.c:2659
 qlink_free mm/kasan/quarantine.c:166 [inline]
 qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:185
 kasan_quarantine_reduce+0x195/0x220 mm/kasan/quarantine.c:292
 __kasan_slab_alloc+0x63/0x90 mm/kasan/common.c:305
 kasan_slab_alloc include/linux/kasan.h:186 [inline]
 slab_post_alloc_hook mm/slab.h:711 [inline]
 slab_alloc_node mm/slub.c:3451 [inline]
 slab_alloc mm/slub.c:3459 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3466 [inline]
 kmem_cache_alloc+0x17c/0x3b0 mm/slub.c:3475
 vm_area_alloc+0x20/0x230 kernel/fork.c:489
 mmap_region+0x407/0x28d0 mm/mmap.c:2631
 do_mmap+0x831/0xf60 mm/mmap.c:1394
 vm_mmap_pgoff+0x1a2/0x3b0 mm/util.c:543
 ksys_mmap_pgoff+0x7d/0x5a0 mm/mmap.c:1440
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
 ffff8880282aae80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8880282aaf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880282aaf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
                                                                ^
 ffff8880282ab000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880282ab080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


Tested on:

commit:         fa0e21fa rtnetlink: extend RTEXT_FILTER_SKIP_STATS to ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main
console output: https://syzkaller.appspot.com/x/log.txt?x=13c29b07280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=6efc50cc1f8d718d6cb7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=127f213b280000


