Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2765F2A048
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404235AbfEXVSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:18:06 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:50402 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404230AbfEXVSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:18:06 -0400
Received: by mail-it1-f199.google.com with SMTP id o128so9778284ita.0
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 14:18:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iwQ0M9CA7WD3CQrUHbNlAadS5e9SUIuyFRzHEIBPCXM=;
        b=YWcf1Ym7edcFUlgLYzfE2ON8OCYhXx2qpMmD4bzu4xcvO0stPlCQXarkrjUq2YFB4I
         YjJv9yg2lice+rjNM/oMh3g1IcXJvzCAXQM+/Fz5z9dpRuB+uM4L6OdRynlHs5mO7KhX
         36xWZXcZ42t6niYYpgr93VA5AScskTLFSHBWnWkyW2fNCRrVzDOeBnRq1O4aDoEnF0gQ
         HUmVRDC757eG4N4+EWWlTv9RIbcZve5YDi4GWaXn7UbRDNsFnXM9xi0rXYOAi6PN9jFu
         X5Sa2g3xaS5eLafputPJSOTaAv/3E+qzlHo4rrMbHYIOB0kjq1RTRM+/i6WGiSnmvPuQ
         m+rQ==
X-Gm-Message-State: APjAAAV6pEUcIsJ9OrBpitTtyHLCeUgRb0WZYd56qwirtpiBn0dT2+id
        QCkXjmwIDido7Py+vyZ4gWxOGyezpxMY7dNnhwIy/8dJhRGy
X-Google-Smtp-Source: APXvYqw2HB6J75GoxtRxYkMnf6F2vK1JXy8Y5ouepC1qjzt+mjoav9oNRh5I4tAnqwBGDCpiyiyP7tdKO2lNbWz7DpOji1jwbcQA
MIME-Version: 1.0
X-Received: by 2002:a5e:8805:: with SMTP id l5mr5254873ioj.90.1558732685179;
 Fri, 24 May 2019 14:18:05 -0700 (PDT)
Date:   Fri, 24 May 2019 14:18:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000000c060589a8bc66@google.com>
Subject: memory leak in tipc_buf_acquire
From:   syzbot <syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jon.maloy@ericsson.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4dde821e Merge tag 'xfs-5.2-fixes-1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107db73aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
dashboard link: https://syzkaller.appspot.com/bug?extid=78fbe679c8ca8d264a8d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162bd84ca00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=160c605ca00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com

type=1400 audit(1558701681.775:36): avc:  denied  { map } for  pid=7128  
comm="syz-executor987" path="/root/syz-executor987656147" dev="sda1"  
ino=15900 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023  
tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810df83c00 (size 512):
   comm "softirq", pid 0, jiffies 4294942354 (age 19.830s)
   hex dump (first 32 bytes):
     38 1a 0d 0f 81 88 ff ff 38 1a 0d 0f 81 88 ff ff  8.......8.......
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000009375ee42>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009375ee42>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009375ee42>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000009375ee42>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<000000004c563922>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<00000000ec87bfa1>] alloc_skb_fclone include/linux/skbuff.h:1107  
[inline]
     [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80 net/tipc/msg.c:66
     [<00000000d151ef84>] tipc_msg_create+0x37/0xe0 net/tipc/msg.c:98
     [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0  
net/tipc/group.c:679
     [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640  
net/tipc/group.c:781
     [<00000000b75ab039>] tipc_sk_proto_rcv net/tipc/socket.c:1996 [inline]
     [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20  
net/tipc/socket.c:2163
     [<000000000dab7a6c>] tipc_sk_enqueue net/tipc/socket.c:2255 [inline]
     [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0 net/tipc/socket.c:2306
     [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0 net/tipc/node.c:1442
     [<00000000337dd9eb>] tipc_node_xmit_skb net/tipc/node.c:1491 [inline]
     [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120  
net/tipc/node.c:1506
     [<00000000b6375182>] tipc_group_delete+0xe6/0x130 net/tipc/group.c:224
     [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0 net/tipc/socket.c:2925
     [<000000009df90505>] tipc_release+0x7b/0x5e0 net/tipc/socket.c:584
     [<000000009f3189da>] __sock_release+0x4b/0xe0 net/socket.c:607
     [<00000000d3568ee0>] sock_close+0x1b/0x30 net/socket.c:1279
     [<00000000266a6215>] __fput+0xed/0x300 fs/file_table.c:280

BUG: memory leak
unreferenced object 0xffff888111895400 (size 1024):
   comm "softirq", pid 0, jiffies 4294942354 (age 19.830s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000e2e2855e>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000e2e2855e>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000e2e2855e>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000e2e2855e>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000a5030ce7>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000a5030ce7>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3634
     [<0000000039212451>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:142
     [<00000000307cb4cf>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:210
     [<00000000ec87bfa1>] alloc_skb_fclone include/linux/skbuff.h:1107  
[inline]
     [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80 net/tipc/msg.c:66
     [<00000000d151ef84>] tipc_msg_create+0x37/0xe0 net/tipc/msg.c:98
     [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0  
net/tipc/group.c:679
     [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640  
net/tipc/group.c:781
     [<00000000b75ab039>] tipc_sk_proto_rcv net/tipc/socket.c:1996 [inline]
     [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20  
net/tipc/socket.c:2163
     [<000000000dab7a6c>] tipc_sk_enqueue net/tipc/socket.c:2255 [inline]
     [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0 net/tipc/socket.c:2306
     [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0 net/tipc/node.c:1442
     [<00000000337dd9eb>] tipc_node_xmit_skb net/tipc/node.c:1491 [inline]
     [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120  
net/tipc/node.c:1506
     [<00000000b6375182>] tipc_group_delete+0xe6/0x130 net/tipc/group.c:224
     [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0 net/tipc/socket.c:2925
     [<000000009df90505>] tipc_release+0x7b/0x5e0 net/tipc/socket.c:584
     [<000000009f3189da>] __sock_release+0x4b/0xe0 net/socket.c:607

BUG: memory leak
unreferenced object 0xffff88810e63de00 (size 512):
   comm "softirq", pid 0, jiffies 4294943548 (age 7.890s)
   hex dump (first 32 bytes):
     38 10 0d 0f 81 88 ff ff 38 10 0d 0f 81 88 ff ff  8.......8.......
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000009375ee42>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000009375ee42>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000009375ee42>] slab_alloc_node mm/slab.c:3269 [inline]
     [<000000009375ee42>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<000000004c563922>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
     [<00000000ec87bfa1>] alloc_skb_fclone include/linux/skbuff.h:1107  
[inline]
     [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80 net/tipc/msg.c:66
     [<00000000d151ef84>] tipc_msg_create+0x37/0xe0 net/tipc/msg.c:98
     [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0  
net/tipc/group.c:679
     [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640  
net/tipc/group.c:781
     [<00000000b75ab039>] tipc_sk_proto_rcv net/tipc/socket.c:1996 [inline]
     [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20  
net/tipc/socket.c:2163
     [<000000000dab7a6c>] tipc_sk_enqueue net/tipc/socket.c:2255 [inline]
     [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0 net/tipc/socket.c:2306
     [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0 net/tipc/node.c:1442
     [<00000000337dd9eb>] tipc_node_xmit_skb net/tipc/node.c:1491 [inline]
     [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120  
net/tipc/node.c:1506
     [<00000000b6375182>] tipc_group_delete+0xe6/0x130 net/tipc/group.c:224
     [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0 net/tipc/socket.c:2925
     [<000000009df90505>] tipc_release+0x7b/0x5e0 net/tipc/socket.c:584
     [<000000009f3189da>] __sock_release+0x4b/0xe0 net/socket.c:607
     [<00000000d3568ee0>] sock_close+0x1b/0x30 net/socket.c:1279
     [<00000000266a6215>] __fput+0xed/0x300 fs/file_table.c:280



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
