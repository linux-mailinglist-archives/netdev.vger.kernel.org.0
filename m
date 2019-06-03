Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE0D33B20
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfFCWYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:24:04 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:54708 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFCWYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:24:04 -0400
Received: by mail-io1-f70.google.com with SMTP id n8so4269306ioo.21
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:24:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zy+G7CpgELhLwgzs/ScfOsi6z+cOCikk738HcwlNl2M=;
        b=fTk/05PqeIu9Q5oJ83+dUs4YOdqNLgisxylawsmpVRSuw+0bXUEIVUZVMXqaSOte7n
         KIDyeIW5sv3wuBulrnEocSBwsvZNmxvNgCHX1cEzGXVRw6+/nZ/NMjGmXGV/FB6192He
         eNKRj3j4Rsj5m9Rl3N25pWMu0IxQ4F+LWP3YK58+93B1AHzR5RwMhKZg0YY5/JZ4s8yD
         58NFTLRdvGV3TEcMkoFBI/KQOQkukSyBVoQLJwVtwwAn1lJ5ODmoVOG4z35GIp6dqsqz
         dSVp23gkWJ58rGlV4Y+WVaPRGfS3KWCr3hygfTS8jrO25KmN7YAmA+SvqreCyAgPMMPh
         5+Bg==
X-Gm-Message-State: APjAAAWlk5IKGXlwdaJ66e6niBp8/g8r/kIw5WCUGU7NECFQ9BTmTnU7
        pqeckNXA0lBV4nPJ8sKiW587PaCwZ/wT5i/NBvObKbF7dp2t
X-Google-Smtp-Source: APXvYqwmPGLNecgCGODGKgKJBDEzDLmk5wLcXzOhpW2pvyGFBZA3BINPBhUXmcKOpGkbD6FtVQKBDBIrb1Hwd/5PqbkyAfSsRKsZ
MIME-Version: 1.0
X-Received: by 2002:a6b:14c2:: with SMTP id 185mr3504074iou.69.1559594465472;
 Mon, 03 Jun 2019 13:41:05 -0700 (PDT)
Date:   Mon, 03 Jun 2019 13:41:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001bb6d7058a716205@google.com>
Subject: memory leak in raw_sendmsg
From:   syzbot <syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3ab4436f Merge tag 'nfsd-5.2-1' of git://linux-nfs.org/~bf..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=158090a6a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=50393f7bfe444ff6
dashboard link: https://syzkaller.appspot.com/bug?extid=a90604060cb40f5bdd16
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e42092a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1327b0a6a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a90604060cb40f5bdd16@syzkaller.appspotmail.com

DRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88812af50600 (size 512):
   comm "syz-executor081", pid 7046, jiffies 4294948162 (age 13.870s)
   hex dump (first 32 bytes):
     0d 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
     9d 92 de d5 ec ad bc 02 6f 66 69 6c 65 3d 30 20  ........ofile=0
   backtrace:
     [<00000000c4297f99>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<00000000c4297f99>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000c4297f99>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000c4297f99>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<0000000066d13723>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<0000000066d13723>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3634
     [<00000000ed0585ca>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:138
     [<000000009a9dc318>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:206
     [<00000000926a7d5b>] alloc_skb include/linux/skbuff.h:1054 [inline]
     [<00000000926a7d5b>] alloc_skb_with_frags+0x5f/0x250  
net/core/skbuff.c:5327
     [<00000000c4ab3faa>] sock_alloc_send_pskb+0x269/0x2a0  
net/core/sock.c:2219
     [<00000000723cdeb0>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2236
     [<000000009ba80e2d>] raw_sendmsg+0xce/0x300 net/can/raw.c:761
     [<0000000000a68d92>] sock_sendmsg_nosec net/socket.c:646 [inline]
     [<0000000000a68d92>] sock_sendmsg+0x54/0x70 net/socket.c:665
     [<000000004e3a95f6>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2286
     [<00000000ec078bc9>] __sys_sendmsg+0x80/0xf0 net/socket.c:2324
     [<0000000002d8ab21>] __do_sys_sendmsg net/socket.c:2333 [inline]
     [<0000000002d8ab21>] __se_sys_sendmsg net/socket.c:2331 [inline]
     [<0000000002d8ab21>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2331
     [<0000000007c3590d>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000003149a5e4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888118308200 (size 224):
   comm "syz-executor081", pid 7046, jiffies 4294948162 (age 13.870s)
   hex dump (first 32 bytes):
     b0 64 19 2a 81 88 ff ff b0 64 19 2a 81 88 ff ff  .d.*.....d.*....
     00 90 28 24 81 88 ff ff 00 64 19 2a 81 88 ff ff  ..($.....d.*....
   backtrace:
     [<0000000085e706a4>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000085e706a4>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000085e706a4>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000085e706a4>] kmem_cache_alloc+0x134/0x270 mm/slab.c:3488
     [<000000005a366403>] skb_clone+0x6e/0x140 net/core/skbuff.c:1321
     [<00000000854d44b1>] __skb_tstamp_tx+0x19f/0x220 net/core/skbuff.c:4434
     [<0000000091e53e01>] __dev_queue_xmit+0x920/0xd60 net/core/dev.c:3813
     [<0000000043e22300>] dev_queue_xmit+0x18/0x20 net/core/dev.c:3910
     [<0000000091bdc746>] can_send+0x138/0x2b0 net/can/af_can.c:290
     [<000000002dddbaef>] raw_sendmsg+0x1bb/0x300 net/can/raw.c:780
     [<0000000000a68d92>] sock_sendmsg_nosec net/socket.c:646 [inline]
     [<0000000000a68d92>] sock_sendmsg+0x54/0x70 net/socket.c:665
     [<000000004e3a95f6>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2286
     [<00000000ec078bc9>] __sys_sendmsg+0x80/0xf0 net/socket.c:2324
     [<0000000002d8ab21>] __do_sys_sendmsg net/socket.c:2333 [inline]
     [<0000000002d8ab21>] __se_sys_sendmsg net/socket.c:2331 [inline]
     [<0000000002d8ab21>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2331
     [<0000000007c3590d>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000003149a5e4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
