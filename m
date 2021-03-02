Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B9132B37E
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352662AbhCCEAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:16 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:45770 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238084AbhCBLCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:02:20 -0500
Received: by mail-il1-f199.google.com with SMTP id h17so14250322ila.12
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 03:01:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=V2DqxiLQON1LiMyoOAnO7MsrKjxDaHAIPc3wA57rVoo=;
        b=ObZqz1QcNe+Ars0LDijmWTgGKUR79QkHJOpF/jvoIUkluuEzi+PIqI4UQu1MGmTVU4
         oKQ6nFxX7/l9qy1gu0PYJne7KIR6n0P3dR2pNA0IzlIAQg0rusw/VJx/GNUCn2ceOP8t
         Su3P2bXmQzONwciKQ9K5WzLGX94+chdPeZJU9ORsmhujw+XTJz6JM2HRtmugQ0VjLe2d
         QHqiHFcCufV10UR1jxj8ZSXcs9nftOM0yIYb7tvrjZuhpyEz1kojwvX9j6Uk4fnn9+ke
         FwHbVoj+z1mpvhA/zsNy+ANnnCIEKetiyBMhxQRQ4afyTe5zDaGFtBL8O8Z8G0D53esf
         +tSw==
X-Gm-Message-State: AOAM532ZEgv0mhPaN+EhA1E1J8Up8EfGCUEdEXUgqnVnEOsr2HpX1GhS
        kPeashSKTNFVWFWb3/Mz1kgL5nyE0+J4cUxVL4nFY5Iuv1Re
X-Google-Smtp-Source: ABdhPJxmUl9D/sWThMgMBrG/3rqPOSd7spVw/yTtABLFlWDBU4zJ0FIHJf5FjF8rfaLLZUUxEXjyNgLfSdMHgegHNvz6+moB6vmj
MIME-Version: 1.0
X-Received: by 2002:a02:c6d0:: with SMTP id r16mr21029907jan.38.1614682878311;
 Tue, 02 Mar 2021 03:01:18 -0800 (PST)
Date:   Tue, 02 Mar 2021 03:01:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006305c005bc8ba7f0@google.com>
Subject: KASAN: use-after-free Read in cipso_v4_genopt
From:   syzbot <syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com>
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

HEAD commit:    5695e516 Merge tag 'io_uring-worker.v3-2021-02-25' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=168c27f2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e33ab2de74f48295
dashboard link: https://syzkaller.appspot.com/bug?extid=9ec037722d2603a9f52e
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cipso_v4_genopt+0x1078/0x1700 net/ipv4/cipso_ipv4.c:1784
Read of size 1 at addr ffff888017bba510 by task kworker/1:3/4821

CPU: 1 PID: 4821 Comm: kworker/1:3 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events p9_write_work
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
 udp_sock_create4+0x73/0x5f0 net/ipv4/udp_tunnel_core.c:20
 udp_sock_create include/net/udp_tunnel.h:59 [inline]
 rxrpc_open_socket net/rxrpc/local_object.c:129 [inline]
 rxrpc_lookup_local+0xd54/0x14d0 net/rxrpc/local_object.c:226
 rxrpc_sendmsg+0x481/0x8a0 net/rxrpc/af_rxrpc.c:541
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg net/socket.c:674 [inline]
 sock_write_iter+0x31a/0x470 net/socket.c:1001
 __kernel_write+0x52c/0x990 fs/read_write.c:550
 kernel_write+0x63/0x80 fs/read_write.c:579
 p9_fd_write net/9p/trans_fd.c:430 [inline]
 p9_write_work+0x5ed/0xd20 net/9p/trans_fd.c:481
 process_one_work+0x789/0xfd0 kernel/workqueue.c:2275
 worker_thread+0xac1/0x1300 kernel/workqueue.c:2421
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Allocated by task 4802:
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
 vfs_statx+0xe8/0x320 fs/stat.c:199
 vfs_fstatat fs/stat.c:217 [inline]
 vfs_lstat include/linux/fs.h:3240 [inline]
 __do_sys_newlstat fs/stat.c:372 [inline]
 __se_sys_newlstat fs/stat.c:366 [inline]
 __x64_sys_newlstat+0x81/0xd0 fs/stat.c:366
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 4802:
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
 vfs_statx+0xe8/0x320 fs/stat.c:199
 vfs_fstatat fs/stat.c:217 [inline]
 vfs_lstat include/linux/fs.h:3240 [inline]
 __do_sys_newlstat fs/stat.c:372 [inline]
 __se_sys_newlstat fs/stat.c:366 [inline]
 __x64_sys_newlstat+0x81/0xd0 fs/stat.c:366
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

The buggy address belongs to the object at ffff888017bba500
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 16 bytes inside of
 64-byte region [ffff888017bba500, ffff888017bba540)
The buggy address belongs to the page:
page:000000004f188e85 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x17bba
flags: 0xfff00000000200(slab)
raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888010841640
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888017bba400: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff888017bba480: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>ffff888017bba500: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                         ^
 ffff888017bba580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff888017bba600: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
