Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18993EF0DB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhHQRY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:24:58 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:39597 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhHQRY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:24:57 -0400
Received: by mail-io1-f69.google.com with SMTP id u22-20020a5d9f560000b02905058dc6c376so11587952iot.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 10:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d6VsKnNMPNiA6kqj9t07OA0sYBx7NKuZu8GZpEYHBbw=;
        b=cnbwLaN6Cvtr7xJOXLLjEGMTwdJRd+XnAlUytXqasoDHp6GOOnnoAKEyBtaspGgegT
         /S5e330+C56aKQ7ArQocpOU0LBcIEkbIGpg6WxYEL+TeHHlxSWb2JgImdAJUx05LWD3a
         kR2kTHj1jkT04FOsK5BLitQ0wVHKpYaIDCSVorX5j/lrbwABoZn2slmODEMYSikEiGNw
         8hqoKhO6QUzfosU8ciZ8wh0r/7ANsZK5JWnIZfZgMkXmS6n2AHmgyykyMRN1q4EZh4Vm
         AdOaG4/e59BdIM22NOyOXvZaRj/HAKfcT/MY9gpPkxmRm/aOZ0/GzaRRnsR9zxeVXzyn
         CjpA==
X-Gm-Message-State: AOAM531EdYBVVzyFFScAXXwWeAHyKGBadgGRFLgx3DqNfS5fyDabxf+m
        Z4cKpopo0rtJ48kzI44aIiT9FfpLVbYUUs2z6z8CoO/URCqN
X-Google-Smtp-Source: ABdhPJz9WFV0oravoaPIEYkDVlJncQ8kUDaScxD+osuPNtovL5PBeQ/9lIZ1nz9pXmrWI8bQ7wq1QtglF78Tasbi6w2v//uS5THW
MIME-Version: 1.0
X-Received: by 2002:a02:90cb:: with SMTP id c11mr3966300jag.53.1629221064084;
 Tue, 17 Aug 2021 10:24:24 -0700 (PDT)
Date:   Tue, 17 Aug 2021 10:24:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c910c305c9c4962e@google.com>
Subject: [syzbot] KASAN: use-after-free Write in null_skcipher_crypt
From:   syzbot <syzbot+d2c5e6980bfc84513464@syzkaller.appspotmail.com>
To:     calvin.johnson@oss.nxp.com, davem@davemloft.net,
        grant.likely@arm.com, herbert@gondor.apana.org.au,
        ioana.ciornei@nxp.com, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9a507013a6f Merge tag 'ieee802154-for-davem-2021-08-12' o..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16647ca1300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=d2c5e6980bfc84513464
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14989fe9300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b1a779300000

The issue was bisected to:

commit 8d2cb3ad31181f050af4d46d6854cf332d1207a9
Author: Calvin Johnson <calvin.johnson@oss.nxp.com>
Date:   Fri Jun 11 10:53:55 2021 +0000

    of: mdio: Refactor of_mdiobus_register_phy()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106b97d6300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=126b97d6300000
console output: https://syzkaller.appspot.com/x/log.txt?x=146b97d6300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2c5e6980bfc84513464@syzkaller.appspotmail.com
Fixes: 8d2cb3ad3118 ("of: mdio: Refactor of_mdiobus_register_phy()")

==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/fortify-string.h:191 [inline]
BUG: KASAN: use-after-free in null_skcipher_crypt+0xa8/0x120 crypto/crypto_null.c:85
Write of size 4096 at addr ffff88801c040000 by task syz-executor554/8455

CPU: 0 PID: 8455 Comm: syz-executor554 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 memcpy+0x39/0x60 mm/kasan/shadow.c:66
 memcpy include/linux/fortify-string.h:191 [inline]
 null_skcipher_crypt+0xa8/0x120 crypto/crypto_null.c:85
 crypto_skcipher_encrypt+0xaa/0xf0 crypto/skcipher.c:630
 crypto_authenc_encrypt+0x3b4/0x510 crypto/authenc.c:222
 crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
 esp6_output_tail+0x777/0x1a90 net/ipv6/esp6.c:659
 esp6_output+0x4af/0x8a0 net/ipv6/esp6.c:735
 xfrm_output_one net/xfrm/xfrm_output.c:552 [inline]
 xfrm_output_resume+0x2997/0x5ae0 net/xfrm/xfrm_output.c:587
 xfrm_output2 net/xfrm/xfrm_output.c:614 [inline]
 xfrm_output+0x2e7/0xff0 net/xfrm/xfrm_output.c:744
 __xfrm6_output+0x4c3/0x1260 net/ipv6/xfrm6_output.c:87
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 xfrm6_output+0x117/0x550 net/ipv6/xfrm6_output.c:92
 dst_output include/net/dst.h:448 [inline]
 ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:161
 ip6_send_skb+0xb7/0x340 net/ipv6/ip6_output.c:1935
 ip6_push_pending_frames+0xdd/0x100 net/ipv6/ip6_output.c:1955
 rawv6_push_pending_frames net/ipv6/raw.c:613 [inline]
 rawv6_sendmsg+0x2a87/0x3990 net/ipv6/raw.c:956
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f4b9
Code: 1d 01 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc1e9cfff8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f4b9
RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000004
RBP: 0000000000000005 R08: 6c616b7a79732f2e R09: 6c616b7a79732f2e
R10: 00000000000000e8 R11: 0000000000000246 R12: 00000000004034b0
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488

Allocated by task 1:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:467
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2956 [inline]
 slab_alloc mm/slub.c:2964 [inline]
 kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2969
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags fs/namei.c:2747 [inline]
 user_path_at_empty+0xa1/0x100 fs/namei.c:2747
 user_path_at include/linux/namei.h:57 [inline]
 vfs_statx+0x142/0x390 fs/stat.c:203
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_lstat include/linux/fs.h:3386 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:380
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 1:
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
 kmem_cache_free+0x8a/0x5b0 mm/slub.c:3226
 putname+0xe1/0x120 fs/namei.c:259
 filename_lookup+0x3df/0x5b0 fs/namei.c:2477
 user_path_at include/linux/namei.h:57 [inline]
 vfs_statx+0x142/0x390 fs/stat.c:203
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_lstat include/linux/fs.h:3386 [inline]
 __do_sys_newlstat+0x91/0x110 fs/stat.c:380
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801c040000
 which belongs to the cache names_cache of size 4096
The buggy address is located 0 bytes inside of
 4096-byte region [ffff88801c040000, ffff88801c041000)
The buggy address belongs to the page:
page:ffffea0000701000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1c040
head:ffffea0000701000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 dead000000000100 dead000000000122 ffff8880109c43c0
raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4994, ts 28153491853, free_ts 28141276199
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
 slab_alloc mm/slub.c:2964 [inline]
 kmem_cache_alloc+0x3e1/0x4a0 mm/slub.c:2969
 getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
 getname_flags fs/namei.c:2747 [inline]
 user_path_at_empty+0xa1/0x100 fs/namei.c:2747
 user_path_at include/linux/namei.h:57 [inline]
 vfs_statx+0x142/0x390 fs/stat.c:203
 vfs_fstatat fs/stat.c:225 [inline]
 vfs_stat include/linux/fs.h:3382 [inline]
 __do_sys_newstat+0x91/0x110 fs/stat.c:367
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1346 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1397
 free_unref_page_prepare mm/page_alloc.c:3332 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3411
 unfreeze_partials+0x17c/0x1d0 mm/slub.c:2418
 put_cpu_partial+0x13d/0x230 mm/slub.c:2454
 qlink_free mm/kasan/quarantine.c:146 [inline]
 qlist_free_all+0x5a/0xc0 mm/kasan/quarantine.c:165
 kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:272
 __kasan_slab_alloc+0x8e/0xa0 mm/kasan/common.c:444
 kasan_slab_alloc include/linux/kasan.h:254 [inline]
 slab_post_alloc_hook mm/slab.h:519 [inline]
 slab_alloc_node mm/slub.c:2956 [inline]
 slab_alloc mm/slub.c:2964 [inline]
 kmem_cache_alloc_trace+0x26d/0x3c0 mm/slub.c:2981
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 call_usermodehelper_setup+0x97/0x340 kernel/umh.c:365
 kobject_uevent_env+0xf73/0x1650 lib/kobject_uevent.c:614
 kobject_synth_uevent+0x701/0x850 lib/kobject_uevent.c:208
 uevent_store+0x42/0x90 drivers/base/bus.c:581
 drv_attr_store+0x6d/0xa0 drivers/base/bus.c:77
 sysfs_kf_write+0x110/0x160 fs/sysfs/file.c:139
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2114 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518

Memory state around the buggy address:
 ffff88801c03ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88801c03ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88801c040000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88801c040080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801c040100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
----------------
Code disassembly (best guess):
   0:	1d 01 00 85 c0       	sbb    $0xc0850001,%eax
   5:	b8 00 00 00 00       	mov    $0x0,%eax
   a:	48 0f 44 c3          	cmove  %rbx,%rax
   e:	5b                   	pop    %rbx
   f:	c3                   	retq   
  10:	90                   	nop
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall 
  2a:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax <-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq   
  33:	48 c7 c1 c0 ff ff ff 	mov    $0xffffffffffffffc0,%rcx
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
