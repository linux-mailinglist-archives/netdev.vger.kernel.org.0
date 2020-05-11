Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AF31CE278
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgEKSVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:21:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:57161 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729673AbgEKSVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:21:21 -0400
Received: by mail-il1-f199.google.com with SMTP id v87so7243796ill.23
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:21:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cqO4hu+Y+GKqzJQLMGAZSu8zQRU1y+XGTEnwnmJrjIg=;
        b=b6NyUx0Y+H1Es+fb9Ba1C434tHdKt9M5ugT4rTepWaJp95tCHUdhW3lYZOrNK9qRJF
         kocRTFq9uTum3Bxlz6TNhKK7I6WWNrZQbgzcT79ESJm3sZSdRWciSC+B1ViS0gaKqfhw
         NaSN6UVsZEMpMZLsYdQuEYHtQ/o3Qyvi7ZszO1B7/jHpMQrESj7JQo8VT6qmUKnGyLBR
         hKYFWk0kzZHMtkO/FS1LT1/1GEHUB/iFZGObAMwvkzhfgapBmCyqud401tOmdgPNfVyz
         z+2PDvshOimCqDia/6OKZHofM2x3HAShNJqArezAKDByDMa/yYfmJkIh32wIOgO8CiEc
         /AUQ==
X-Gm-Message-State: AGi0PubgfmrIoKq0p2YxIELgtEcR2jP5gac/jb01DLWVXrwrB9bfuBqa
        DwvBXf9AEeT9ldG1y5CB4a4cG0QuS2GuzoK5qBUf9bJ1/wkx
X-Google-Smtp-Source: APiQypK4CuKR2a7GGFDnY93LCwCy3QserCQbrKxGJuk2kSEZBUjubfo5Yu6mO7v9DOlWlIX85UuovWpJyoMXMk0xxaX8u+zj1XuC
MIME-Version: 1.0
X-Received: by 2002:a02:5b89:: with SMTP id g131mr16814855jab.75.1589221280022;
 Mon, 11 May 2020 11:21:20 -0700 (PDT)
Date:   Mon, 11 May 2020 11:21:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dd891a05a56369b8@google.com>
Subject: KASAN: slab-out-of-bounds Read in fl6_update_dst
From:   syzbot <syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2ef96a5b Linux 5.7-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=155f1714100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=efdde85c3af536b5
dashboard link: https://syzkaller.appspot.com/bug?extid=e8c028b62439eac42073
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102bfda2100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f8510c100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in fl6_update_dst+0x2bb/0x2c0 net/ipv6/exthdrs.c:1356
Read of size 16 at addr ffff88809dc23258 by task syz-executor528/7035

CPU: 1 PID: 7035 Comm: syz-executor528 Not tainted 5.7.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 fl6_update_dst+0x2bb/0x2c0 net/ipv6/exthdrs.c:1356
 sctp_v6_get_dst+0x5e7/0x1c30 net/sctp/ipv6.c:276
 sctp_transport_route+0x125/0x350 net/sctp/transport.c:297
 sctp_assoc_add_peer+0x5a0/0x1030 net/sctp/associola.c:659
 sctp_connect_new_asoc+0x19b/0x580 net/sctp/socket.c:1092
 sctp_sendmsg_new_asoc net/sctp/socket.c:1694 [inline]
 sctp_sendmsg+0x1396/0x1f30 net/sctp/socket.c:2004
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:807
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x308/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmmsg+0x195/0x480 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x440309
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff01fee1f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440309
RDX: 0000000000000001 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401b90
R13: 0000000000401c20 R14: 0000000000000000 R15: 0000000000000000

Allocated by task 7035:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 __kasan_kmalloc mm/kasan/common.c:495 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:468
 __do_kmalloc mm/slab.c:3656 [inline]
 __kmalloc+0x161/0x7a0 mm/slab.c:3665
 kmalloc include/linux/slab.h:560 [inline]
 sock_kmalloc net/core/sock.c:2166 [inline]
 sock_kmalloc+0xb5/0x100 net/core/sock.c:2157
 ipv6_renew_options+0x274/0x940 net/ipv6/exthdrs.c:1275
 do_ipv6_setsockopt.isra.0+0x2eaf/0x42f0 net/ipv6/ipv6_sockglue.c:435
 ipv6_setsockopt+0xfb/0x180 net/ipv6/ipv6_sockglue.c:949
 sctp_setsockopt+0x13e/0x7090 net/sctp/socket.c:4685
 __sys_setsockopt+0x248/0x480 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2148 [inline]
 __se_sys_setsockopt net/socket.c:2145 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2145
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

Freed by task 5138:
 save_stack+0x1b/0x40 mm/kasan/common.c:49
 set_track mm/kasan/common.c:57 [inline]
 kasan_set_free_info mm/kasan/common.c:317 [inline]
 __kasan_slab_free+0xf7/0x140 mm/kasan/common.c:456
 __cache_free mm/slab.c:3426 [inline]
 kfree+0x109/0x2b0 mm/slab.c:3757
 tomoyo_path_perm+0x236/0x400 security/tomoyo/file.c:842
 security_inode_getattr+0xeb/0x150 security/security.c:1273
 vfs_getattr+0x22/0x60 fs/stat.c:117
 vfs_statx_fd+0x6a/0xb0 fs/stat.c:147
 vfs_fstat include/linux/fs.h:3295 [inline]
 __do_sys_newfstat+0x8b/0x100 fs/stat.c:388
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3

The buggy address belongs to the object at ffff88809dc23200
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 88 bytes inside of
 96-byte region [ffff88809dc23200, ffff88809dc23260)
The buggy address belongs to the page:
page:ffffea00027708c0 refcount:1 mapcount:0 mapping:0000000031b2e39e index:0xffff88809dc23080
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027c7888 ffffea00027fc588 ffff8880aa000540
raw: ffff88809dc23080 ffff88809dc23000 000000010000001e 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88809dc23100: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff88809dc23180: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>ffff88809dc23200: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
                                                    ^
 ffff88809dc23280: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
 ffff88809dc23300: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
