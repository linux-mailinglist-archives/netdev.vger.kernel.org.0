Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456407BBAB
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfGaI3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:29:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33470 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaI3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:29:06 -0400
Received: by mail-io1-f71.google.com with SMTP id 132so74484635iou.0
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 01:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eNbeoCj6QOku4yDwlW9DCGJXvWWlE2k5qE8OUf3NKS4=;
        b=dwCrnsK1MUBYpFtWc8krZIc630Y/Scs8Z/j5yesdEZFEv3jvZ6eavglGOCTg2vUXWd
         GjMmjaE8VH0AEpJzZAgk5/N2tJdT4aNy2pyokGAW+Sa+p7UkiizXrMWvjrV7fvVQwl7w
         vaIi1Qnl2/58GuVJTz+xAzQ8BCVJOBxclaERxW6QKNlKUWhtwIF0jO0nFkGr1FKNacVC
         GVETpgdFFQYquCmfLBDBCiSE60AxaonRgWuw7P8VIvjytXrh0JIfUfZzrdFu1jeyOfCM
         fBf90XUDktNz42BDeoi3TpyfSCS0YP2lAOoKN0msyFrf0v7djZCBq9TUu+cO7I689u/h
         +EOw==
X-Gm-Message-State: APjAAAV69DZ3QnmRc3o0fhr5U3skQZC69/kln7E03MSwAVDIBkG3sPmE
        B+aupvHAZF/qjhfdHMgT0fco5Hwe4Ovcf0qem8PIVNQtZ0wS
X-Google-Smtp-Source: APXvYqzT43YkTR/n3sFhVK85q65sc1ppXLi1My8waUwut0HWS9xw/+8Fuz24+AAQVbehd0RkG12wBJzr3Wf9lOZH+QP4d6kDsWtp
MIME-Version: 1.0
X-Received: by 2002:a5d:8ccc:: with SMTP id k12mr28954439iot.141.1564561745439;
 Wed, 31 Jul 2019 01:29:05 -0700 (PDT)
Date:   Wed, 31 Jul 2019 01:29:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000010fb45058ef5eb52@google.com>
Subject: KASAN: invalid-free in tls_sk_proto_cleanup
From:   syzbot <syzbot+f5731e2256eb5130dbd6@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    fde50b96 Add linux-next specific files for 20190726
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15ea7f3fa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b58274564b354c1
dashboard link: https://syzkaller.appspot.com/bug?extid=f5731e2256eb5130dbd6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f5731e2256eb5130dbd6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: double-free or invalid-free in tls_sk_proto_cleanup+0x216/0x3e0  
net/tls/tls_main.c:300

CPU: 0 PID: 19107 Comm: syz-executor.4 Not tainted 5.3.0-rc1-next-20190726  
#53
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  kasan_report_invalid_free+0x65/0xa0 mm/kasan/report.c:444
  __kasan_slab_free+0x13a/0x150 mm/kasan/common.c:427
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:456
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  tls_sk_proto_cleanup+0x216/0x3e0 net/tls/tls_main.c:300
  tls_sk_proto_unhash+0x90/0x3f0 net/tls/tls_main.c:330
  tcp_set_state+0x5b9/0x7d0 net/ipv4/tcp.c:2235
  tcp_done+0xe2/0x320 net/ipv4/tcp.c:3824
  tcp_reset+0x132/0x500 net/ipv4/tcp_input.c:4080
  tcp_validate_incoming+0xa2d/0x1660 net/ipv4/tcp_input.c:5440
  tcp_rcv_established+0x6b5/0x1e70 net/ipv4/tcp_input.c:5648
  tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
  sk_backlog_rcv include/net/sock.h:945 [inline]
  __release_sock+0x129/0x390 net/core/sock.c:2418
  release_sock+0x59/0x1c0 net/core/sock.c:2934
  sk_stream_wait_memory+0x65a/0xfc0 net/core/stream.c:149
  tls_sw_sendmsg+0x673/0x17b0 net/tls/tls_sw.c:1054
  inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fcee5e02c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000459829
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fcee5e036d4
R13: 00000000004c77c1 R14: 00000000004dcf38 R15: 00000000ffffffff

Allocated by task 19107:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:486 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:459
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:500
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc_track_caller+0x15f/0x760 mm/slab.c:3670
  kmemdup+0x27/0x60 mm/util.c:120
  kmemdup include/linux/string.h:477 [inline]
  tls_set_sw_offload+0xb3a/0x1567 net/tls/tls_sw.c:2361
  do_tls_setsockopt_conf net/tls/tls_main.c:581 [inline]
  do_tls_setsockopt net/tls/tls_main.c:630 [inline]
  tls_setsockopt+0x4d5/0x8d0 net/tls/tls_main.c:649
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3130
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2084
  __do_sys_setsockopt net/socket.c:2100 [inline]
  __se_sys_setsockopt net/socket.c:2097 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2097
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 19107:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:448
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:456
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  tls_sk_proto_cleanup+0x216/0x3e0 net/tls/tls_main.c:300
  tls_sk_proto_unhash+0x90/0x3f0 net/tls/tls_main.c:330
  tcp_set_state+0x5b9/0x7d0 net/ipv4/tcp.c:2235
  tcp_done+0xe2/0x320 net/ipv4/tcp.c:3824
  tcp_reset+0x132/0x500 net/ipv4/tcp_input.c:4080
  tcp_validate_incoming+0xa2d/0x1660 net/ipv4/tcp_input.c:5440
  tcp_rcv_established+0x6b5/0x1e70 net/ipv4/tcp_input.c:5648
  tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
  sk_backlog_rcv include/net/sock.h:945 [inline]
  __release_sock+0x129/0x390 net/core/sock.c:2418
  release_sock+0x59/0x1c0 net/core/sock.c:2934
  wait_on_pending_writer+0x20f/0x420 net/tls/tls_main.c:91
  tls_sk_proto_cleanup+0x2c5/0x3e0 net/tls/tls_main.c:295
  tls_sk_proto_unhash+0x90/0x3f0 net/tls/tls_main.c:330
  tcp_set_state+0x5b9/0x7d0 net/ipv4/tcp.c:2235
  tcp_done+0xe2/0x320 net/ipv4/tcp.c:3824
  tcp_reset+0x132/0x500 net/ipv4/tcp_input.c:4080
  tcp_validate_incoming+0xa2d/0x1660 net/ipv4/tcp_input.c:5440
  tcp_rcv_established+0x6b5/0x1e70 net/ipv4/tcp_input.c:5648
  tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
  sk_backlog_rcv include/net/sock.h:945 [inline]
  __release_sock+0x129/0x390 net/core/sock.c:2418
  release_sock+0x59/0x1c0 net/core/sock.c:2934
  sk_stream_wait_memory+0x65a/0xfc0 net/core/stream.c:149
  tls_sw_sendmsg+0x673/0x17b0 net/tls/tls_sw.c:1054
  inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88808ff1c500
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
  32-byte region [ffff88808ff1c500, ffff88808ff1c520)
The buggy address belongs to the page:
page:ffffea00023fc700 refcount:1 mapcount:0 mapping:ffff8880aa4001c0  
index:0xffff88808ff1cfc1
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002a12308 ffffea0002912208 ffff8880aa4001c0
raw: ffff88808ff1cfc1 ffff88808ff1c000 0000000100000024 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88808ff1c400: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff88808ff1c480: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
> ffff88808ff1c500: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
                    ^
  ffff88808ff1c580: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff88808ff1c600: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
