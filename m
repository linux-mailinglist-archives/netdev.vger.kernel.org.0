Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B96B2B4124
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 11:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgKPKaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 05:30:23 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:50644 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727293AbgKPKaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 05:30:21 -0500
Received: by mail-il1-f200.google.com with SMTP id f66so11595562ilh.17
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 02:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PEXWi6MJqCB/SPlcWqgz64xY5Wl0D3GleDopT4k3ghY=;
        b=aJ1/a2sFa65238lc2sY5xa4ebFgA4Bk8iraPmAJehCLg2CG7jVweKv240nJ+9T6YOv
         NzuRA317sP+D504A7FPpLgUxqgvvFWmwPk0ctaMJxfk3vLdp87qFvaDQTFThG4WDD+4y
         WJXeCdQ0cseU1ZmOmFZoVrGBMQdMfC10Z5KprXbyF1RjEwDYdBeGAPF2r3yHkQwPTYJs
         VuiyyQ03hnlYCccHHGeohbtaFa9goP+UQHqsFDhn2pcB9MmwHFCXM1FSzJQUK7J9nQ3G
         a/nDt5vqrdIKnYlOghqUhPC4YvfJa45wpSYepKT7Kxy3QEVJVwkqnx26Q7M09PGuvK5S
         nLOg==
X-Gm-Message-State: AOAM531RUkybrVAmyxYzJwTHXAiYG80cD38T8XP/3ZRiXOSLtUZ6ridS
        ORx+xJQvpMRbepKYJnNKvr65BJFHSQ7k/Om+twK6xrEC7EGi
X-Google-Smtp-Source: ABdhPJyPDjAvb4aOPk6aQp8tEZ+6FV0hpMscyObv2ukARyw/55pY0hTpuLRUpgy1rSfiDWg/7B7jjWY559Hwrl9HRFfAV32m9cH9
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:108e:: with SMTP id r14mr7957900ilj.41.1605522619821;
 Mon, 16 Nov 2020 02:30:19 -0800 (PST)
Date:   Mon, 16 Nov 2020 02:30:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ef45b05b436ddb4@google.com>
Subject: KASAN: invalid-free in p9_client_create
From:   syzbot <syzbot+3a0f6c96e37e347c6ba9@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    92edc4ae Add linux-next specific files for 20201113
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=142f8816500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79ad4f8ad2d96176
dashboard link: https://syzkaller.appspot.com/bug?extid=3a0f6c96e37e347c6ba9
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3a0f6c96e37e347c6ba9@syzkaller.appspotmail.com

RBP: 00007fa358076ca0 R08: 0000000020000080 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000001f
R13: 00007fff7dcf224f R14: 00007fa3580779c0 R15: 000000000118bf2c
kobject_add_internal failed for 9p-fcall-cache (error: -12 parent: slab)
==================================================================
BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3157 [inline]
BUG: KASAN: double-free or invalid-free in kmem_cache_free+0x82/0x350 mm/slub.c:3173

CPU: 0 PID: 15981 Comm: syz-executor.5 Not tainted 5.10.0-rc3-next-20201113-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:230
 kasan_report_invalid_free+0x51/0x80 mm/kasan/report.c:355
 ____kasan_slab_free+0x100/0x110 mm/kasan/common.c:352
 kasan_slab_free include/linux/kasan.h:194 [inline]
 slab_free_hook mm/slub.c:1548 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1586
 slab_free mm/slub.c:3157 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3173
 create_cache mm/slab_common.c:274 [inline]
 kmem_cache_create_usercopy+0x2ab/0x300 mm/slab_common.c:357
 p9_client_create+0xc4d/0x10c0 net/9p/client.c:1063
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9b0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1549
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x12ae/0x1e70 fs/namespace.c:3227
 do_mount fs/namespace.c:3240 [inline]
 __do_sys_mount fs/namespace.c:3448 [inline]
 __se_sys_mount fs/namespace.c:3425 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45deb9
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa358076c78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000021800 RCX: 000000000045deb9
RDX: 0000000020000100 RSI: 0000000020000040 RDI: 0000000000000000
RBP: 00007fa358076ca0 R08: 0000000020000080 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000001f
R13: 00007fff7dcf224f R14: 00007fa3580779c0 R15: 000000000118bf2c

Allocated by task 15981:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:39
 kasan_set_track mm/kasan/common.c:47 [inline]
 set_alloc_info mm/kasan/common.c:403 [inline]
 ____kasan_kmalloc.constprop.0+0x82/0xa0 mm/kasan/common.c:434
 kasan_slab_alloc include/linux/kasan.h:211 [inline]
 slab_post_alloc_hook mm/slab.h:512 [inline]
 slab_alloc_node mm/slub.c:2903 [inline]
 slab_alloc mm/slub.c:2911 [inline]
 kmem_cache_alloc+0x12a/0x470 mm/slub.c:2916
 kmem_cache_zalloc include/linux/slab.h:672 [inline]
 create_cache mm/slab_common.c:251 [inline]
 kmem_cache_create_usercopy+0x1a6/0x300 mm/slab_common.c:357
 p9_client_create+0xc4d/0x10c0 net/9p/client.c:1063
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9b0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1549
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x12ae/0x1e70 fs/namespace.c:3227
 do_mount fs/namespace.c:3240 [inline]
 __do_sys_mount fs/namespace.c:3448 [inline]
 __se_sys_mount fs/namespace.c:3425 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 15981:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:39
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:47
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:359
 ____kasan_slab_free+0xe1/0x110 mm/kasan/common.c:373
 kasan_slab_free include/linux/kasan.h:194 [inline]
 slab_free_hook mm/slub.c:1548 [inline]
 slab_free_freelist_hook+0x5d/0x150 mm/slub.c:1586
 slab_free mm/slub.c:3157 [inline]
 kmem_cache_free+0x82/0x350 mm/slub.c:3173
 kobject_cleanup lib/kobject.c:705 [inline]
 kobject_release lib/kobject.c:736 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1c8/0x540 lib/kobject.c:753
 sysfs_slab_add+0x164/0x1d0 mm/slub.c:5656
 __kmem_cache_create+0x471/0x5a0 mm/slub.c:4476
 create_cache mm/slab_common.c:262 [inline]
 kmem_cache_create_usercopy+0x1ed/0x300 mm/slab_common.c:357
 p9_client_create+0xc4d/0x10c0 net/9p/client.c:1063
 v9fs_session_init+0x1dd/0x1770 fs/9p/v9fs.c:406
 v9fs_mount+0x79/0x9b0 fs/9p/vfs_super.c:126
 legacy_get_tree+0x105/0x220 fs/fs_context.c:592
 vfs_get_tree+0x89/0x2f0 fs/super.c:1549
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x12ae/0x1e70 fs/namespace.c:3227
 do_mount fs/namespace.c:3240 [inline]
 __do_sys_mount fs/namespace.c:3448 [inline]
 __se_sys_mount fs/namespace.c:3425 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The buggy address belongs to the object at ffff888013a45b40
 which belongs to the cache kmem_cache of size 224
The buggy address is located 0 bytes inside of
 224-byte region [ffff888013a45b40, ffff888013a45c20)
The buggy address belongs to the page:
page:00000000cfbbc7ff refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888013a45c80 pfn:0x13a45
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888010041000
raw: ffff888013a45c80 00000000800c0004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888013a45a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888013a45a80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff888013a45b00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
                                           ^
 ffff888013a45b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888013a45c00: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
