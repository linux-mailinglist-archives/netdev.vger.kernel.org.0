Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5504614187A
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 17:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgARQhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 11:37:32 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:40947 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgARQhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 11:37:11 -0500
Received: by mail-il1-f198.google.com with SMTP id e4so21541074ilm.7
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 08:37:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=s8h9K+9NEm5IGtTOkJifvzudiWkvMCmFURnkQL48tkA=;
        b=o3LWKOHCE20Ih+be5d4XeH6PQgTZo11YkwjRh+MOWz34rKt3ylj/K5lPAJe3NKY2BF
         ScEdleOSQWdgDBjZVTi6xvxD7NBN6O3wuyJUBIvY9kgHUHkRUCdp3Fz4HaP6FhHVGSOv
         CbNWkll3FyOHAzOAJiO+4SF/irgJvroYlWN5T80adlFtfkTLt4LtfTkYWem4CQneTkl1
         Hd0ZPoJeAnrPCLhX8J8w9UxQLIL9EG1+Ix4ul54OvEoPLCfIOb3XJWJ4oxvy0inhXvi9
         KTjbcDjdzKMRShjGrs10SH+e8XfJI2X7ua6SfmoUMd3cOL+bgyZPPuYazT01yG7pXH76
         Qtdw==
X-Gm-Message-State: APjAAAWMksBv0f56qoHDVp0ZzSMkbpfNPd7uGoy1kXrgIcXtOSshnbJO
        bF3LB+NDsThYAdTOgifwrd8hjns1VnX8IVH8hTBQ+RB4EuQg
X-Google-Smtp-Source: APXvYqwj1i85Mo0h8AnZeeUT3CQGeq2217ZO41hSZJuyZztCVRihlIoQY7dwdNY9CgjUcrDaCcpp8Nh7rlma3RG3+8yyhTsn/Sbv
MIME-Version: 1.0
X-Received: by 2002:a5e:aa12:: with SMTP id s18mr33322723ioe.182.1579365430810;
 Sat, 18 Jan 2020 08:37:10 -0800 (PST)
Date:   Sat, 18 Jan 2020 08:37:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000795cb4059c6cab74@google.com>
Subject: KASAN: slab-out-of-bounds Read in bitmap_ip_test
From:   syzbot <syzbot+b08bd19bb37513357fd4@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        gregkh@linuxfoundation.org, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    56f200c7 netns: Constify exported functions
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13ca6faee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=b08bd19bb37513357fd4
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10574495e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b08bd19bb37513357fd4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_do_test net/netfilter/ipset/ip_set_bitmap_ip.c:70 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_test+0xde/0x170 net/netfilter/ipset/ip_set_bitmap_gen.h:122
Read of size 8 at addr ffff8880a52bbd80 by task syz-executor.0/9756

CPU: 1 PID: 9756 Comm: syz-executor.0 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 __kasan_check_read+0x11/0x20 mm/kasan/common.c:95
 test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
 bitmap_ip_do_test net/netfilter/ipset/ip_set_bitmap_ip.c:70 [inline]
 bitmap_ip_test+0xde/0x170 net/netfilter/ipset/ip_set_bitmap_gen.h:122
 bitmap_ip_uadt+0x87a/0xa10 net/netfilter/ipset/ip_set_bitmap_ip.c:159
 ip_set_utest+0x570/0x8d0 net/netfilter/ipset/ip_set_core.c:1868
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45aff9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe214965c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe2149666d4 RCX: 000000000045aff9
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000004
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000008d4 R14: 00000000004c9f2a R15: 000000000075bfd4

Allocated by task 9755:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 __kasan_kmalloc mm/kasan/common.c:513 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:486
 kasan_kmalloc+0x9/0x10 mm/kasan/common.c:527
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x163/0x770 mm/slab.c:3665
 kmalloc include/linux/slab.h:561 [inline]
 kzalloc include/linux/slab.h:670 [inline]
 ip_set_alloc+0x38/0x5e net/netfilter/ipset/ip_set_core.c:255
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x6ec/0xc20 net/netfilter/ipset/ip_set_bitmap_ip.c:327
 ip_set_create+0x6f1/0x1500 net/netfilter/ipset/ip_set_core.c:1111
 nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 4164:
 save_stack+0x23/0x90 mm/kasan/common.c:72
 set_track mm/kasan/common.c:80 [inline]
 kasan_set_free_info mm/kasan/common.c:335 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:474
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:483
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x10a/0x2c0 mm/slab.c:3757
 tomoyo_path_perm+0x24e/0x430 security/tomoyo/file.c:842
 tomoyo_inode_getattr+0x1d/0x30 security/tomoyo/tomoyo.c:129
 security_inode_getattr+0xf2/0x150 security/security.c:1222
 vfs_getattr+0x25/0x70 fs/stat.c:115
 vfs_statx+0x157/0x200 fs/stat.c:191
 vfs_stat include/linux/fs.h:3249 [inline]
 __do_sys_newstat+0xa4/0x130 fs/stat.c:341
 __se_sys_newstat fs/stat.c:337 [inline]
 __x64_sys_newstat+0x54/0x80 fs/stat.c:337
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880a52bbd80
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
 32-byte region [ffff8880a52bbd80, ffff8880a52bbda0)
The buggy address belongs to the page:
page:ffffea000294aec0 refcount:1 mapcount:0 mapping:ffff8880aa4001c0 index:0xffff8880a52bbfc1
raw: 00fffe0000000200 ffffea0002930588 ffffea00027f7c08 ffff8880aa4001c0
raw: ffff8880a52bbfc1 ffff8880a52bb000 000000010000003f 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880a52bbc80: 00 00 00 02 fc fc fc fc 00 00 00 00 fc fc fc fc
 ffff8880a52bbd00: 00 00 00 00 fc fc fc fc fb fb fb fb fc fc fc fc
>ffff8880a52bbd80: 04 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
                   ^
 ffff8880a52bbe00: 00 00 fc fc fc fc fc fc 00 00 fc fc fc fc fc fc
 ffff8880a52bbe80: 00 00 00 00 fc fc fc fc 00 00 fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
