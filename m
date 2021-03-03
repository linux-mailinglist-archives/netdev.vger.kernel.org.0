Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4356632C46E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354953AbhCDANx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:53 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:47223 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhCCPyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 10:54:21 -0500
Received: by mail-il1-f199.google.com with SMTP id y12so17916477ilu.14
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 07:53:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KechlHkOlhWRy8Q4Ei8QQDGED6Oj1MoCxkdFSBmmls4=;
        b=qTFDFj7nJ1UVSIOgDFcgQSC4g6LYSRzhke+DMFzb7B0NzhLdA+UyAh9tiHcWkGwb6v
         cEqg09/iBLgUie/hLVFBtE8M3M+ZHmvIzJTOS6UF43zjYDTEpM6utbGPZCQcykLcn9UC
         XaSHdtChVRHKs2ILgrwVWJhcpqS1S9D7ZS1+QtLhueltDeOPEhCjv7r18jJc1wHl2opJ
         EbR7IGS35l4TvdRaIYvAYiyOFgPNOkOj9+S3fIlALoj4V/650RNTc82BU1mAU6dre14G
         ntRcLt/yqR7BEI8k44ZEZ5V5ZANQK932l2TzayiOBbUVwkicHC6CzDxWGgrlQVPoSRYx
         SPZw==
X-Gm-Message-State: AOAM532pvko6wvzrjnlIlVRMO2dfz2gN9aXgR+ESuNLlATaWSAXRYvJ7
        ajZKAahnJrBraIgWX8uhGa1XaRoLvp5FAcMlXgHQF3ThH1aZ
X-Google-Smtp-Source: ABdhPJyYRx7urpK9LKZNgRsQDVymQEEnjN/Qd3DKU6uu/gSbbIKls29SKoQGSkx4CyYVLhU7hz17cnYd6liczhYhrue7YESJgxoN
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1406:: with SMTP id t6mr23267984iov.154.1614786805636;
 Wed, 03 Mar 2021 07:53:25 -0800 (PST)
Date:   Wed, 03 Mar 2021 07:53:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f022ff05bca3d9a3@google.com>
Subject: KASAN: use-after-free Write in cipso_v4_doi_putdef
From:   syzbot <syzbot+521772a90166b3fca21f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7a7fd0de Merge branch 'kmap-conversion-for-5.12' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=164a74dad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=779a2568b654c1c6
dashboard link: https://syzkaller.appspot.com/bug?extid=521772a90166b3fca21f
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+521772a90166b3fca21f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
BUG: KASAN: use-after-free in __refcount_sub_and_test include/linux/refcount.h:272 [inline]
BUG: KASAN: use-after-free in __refcount_dec_and_test include/linux/refcount.h:315 [inline]
BUG: KASAN: use-after-free in refcount_dec_and_test include/linux/refcount.h:333 [inline]
BUG: KASAN: use-after-free in cipso_v4_doi_putdef+0x2d/0x190 net/ipv4/cipso_ipv4.c:586
Write of size 4 at addr ffff8880179ecb18 by task syz-executor.5/20110

CPU: 0 PID: 20110 Comm: syz-executor.5 Not tainted 5.12.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x125/0x19e lib/dump_stack.c:120
 print_address_description+0x5f/0x3a0 mm/kasan/report.c:232
 __kasan_report mm/kasan/report.c:399 [inline]
 kasan_report+0x15e/0x210 mm/kasan/report.c:416
 check_region_inline mm/kasan/generic.c:135 [inline]
 kasan_check_range+0x2b5/0x2f0 mm/kasan/generic.c:186
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_sub_release include/asm-generic/atomic-instrumented.h:220 [inline]
 __refcount_sub_and_test include/linux/refcount.h:272 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 cipso_v4_doi_putdef+0x2d/0x190 net/ipv4/cipso_ipv4.c:586
 netlbl_domhsh_remove_entry+0x344/0xaa0 net/netlabel/netlabel_domainhash.c:634
 netlbl_domhsh_remove+0xe9/0x230 net/netlabel/netlabel_domainhash.c:807
 smk_cipso_doi+0x163/0x4e0 security/smack/smackfs.c:691
 smk_write_doi+0x123/0x190 security/smack/smackfs.c:1613
 vfs_write+0x220/0xab0 fs/read_write.c:603
 ksys_write+0x11b/0x220 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fda2dfcc188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000000000014 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000004bcd1c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffd0c1095df R14: 00007fda2dfcc300 R15: 0000000000022000

Allocated by task 19918:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:427 [inline]
 ____kasan_kmalloc+0xc2/0xf0 mm/kasan/common.c:506
 kasan_kmalloc include/linux/kasan.h:233 [inline]
 __kmalloc+0xb4/0x370 mm/slub.c:4055
 kmalloc include/linux/slab.h:559 [inline]
 kzalloc include/linux/slab.h:684 [inline]
 tomoyo_encode2+0x25a/0x560 security/tomoyo/realpath.c:45
 tomoyo_encode security/tomoyo/realpath.c:80 [inline]
 tomoyo_realpath_from_path+0x5c3/0x610 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x191/0x570 security/tomoyo/file.c:822
 security_inode_getattr+0xc0/0x140 security/security.c:1288
 vfs_getattr fs/stat.c:131 [inline]
 vfs_fstat fs/stat.c:156 [inline]
 __do_sys_newfstat fs/stat.c:396 [inline]
 __se_sys_newfstat fs/stat.c:393 [inline]
 __x64_sys_newfstat+0x97/0x150 fs/stat.c:393
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 19918:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:357
 ____kasan_slab_free+0x100/0x140 mm/kasan/common.c:360
 kasan_slab_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:1562 [inline]
 slab_free_freelist_hook+0x13a/0x200 mm/slub.c:1600
 slab_free mm/slub.c:3161 [inline]
 kfree+0xcf/0x2b0 mm/slub.c:4213
 tomoyo_path_perm+0x447/0x570 security/tomoyo/file.c:842
 security_inode_getattr+0xc0/0x140 security/security.c:1288
 vfs_getattr fs/stat.c:131 [inline]
 vfs_fstat fs/stat.c:156 [inline]
 __do_sys_newfstat fs/stat.c:396 [inline]
 __se_sys_newfstat fs/stat.c:393 [inline]
 __x64_sys_newfstat+0x97/0x150 fs/stat.c:393
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

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

The buggy address belongs to the object at ffff8880179ecb00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 24 bytes inside of
 64-byte region [ffff8880179ecb00, ffff8880179ecb40)
The buggy address belongs to the page:
page:000000005a6eec83 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x179ec
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 ffffea0000513400 0000000800000008 ffff888010841640
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880179eca00: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff8880179eca80: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>ffff8880179ecb00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                            ^
 ffff8880179ecb80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff8880179ecc00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
