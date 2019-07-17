Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEBE6B7E3
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 10:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfGQIJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 04:09:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:43530 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQIJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 04:09:07 -0400
Received: by mail-io1-f69.google.com with SMTP id q26so26269109ioi.10
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 01:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JJiXNoZhtTopMEEhDJZXbiN4mXX/eaWyc6DMZzKws7I=;
        b=XWgoHGakNFbbYOr4Y6ja9uNB85BDB67JOGgKJ8OCAOv4DYaQW2F6gTCauhMluU4laz
         8IEV+P6ej9Wp6lgQHzcGMIKl+qr5jdtbX20Ax9AU5sthCEjClXz/hJKIVXqyaUofcQPF
         ZxRPoHmMGPo7LsgJI2uVQ6ktmE3NRkZF5TGsputcheBc8Dh/G/qkkGpxDNyMgFxzPSPj
         62mfmZNiLr0/XVD2TNnugRysF/BxbQLu8YfNHucYiCT9EkEz9I/z6VbJbjlCjlmPvkPk
         c1QxgL3MOM0ReddYwoWhmgPv9DDGbfCke9lqMU8IK3gXbH/QSTfD97tYoO5Lkwn84bVw
         o5cQ==
X-Gm-Message-State: APjAAAV/KyTpqTL5Ws6RYgjpYuhIL7RG/ArDWguIygtoZgx9WG1V5tH3
        WYytwZUfesE1V/KXzB4UqEX1uVoEpQ5UKEUXWIRw6XsDgAff
X-Google-Smtp-Source: APXvYqyAs7DDd1U8BwsmUfrU+TbveD9BI0KJBblY4U3i11f0jBgnCyh/Jk6UkPg2QnmQXx7qowMkM2mLQ1YDDdVd7M41Sk5NApkq
MIME-Version: 1.0
X-Received: by 2002:a02:ac09:: with SMTP id a9mr41989453jao.48.1563350946166;
 Wed, 17 Jul 2019 01:09:06 -0700 (PDT)
Date:   Wed, 17 Jul 2019 01:09:06 -0700
In-Reply-To: <000000000000058a0f058bd50068@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce3d58058ddc01a2@google.com>
Subject: Re: memory leak in llc_ui_create (2)
From:   syzbot <syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    3eb51486 Merge tag 'arc-5.3-rc1' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ca2548600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cd93db730dc81f01
dashboard link: https://syzkaller.appspot.com/bug?extid=6bf095f9becf5efef645
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174254d0600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13bb0d84600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811e6f1800 (size 2048):
   comm "syz-executor273", pid 7002, jiffies 4294943426 (age 13.700s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     1a 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<0000000014a2e1ad>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<0000000014a2e1ad>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<0000000014a2e1ad>] slab_alloc mm/slab.c:3319 [inline]
     [<0000000014a2e1ad>] __do_kmalloc mm/slab.c:3653 [inline]
     [<0000000014a2e1ad>] __kmalloc+0x169/0x300 mm/slab.c:3664
     [<00000000ba2cba1e>] kmalloc include/linux/slab.h:557 [inline]
     [<00000000ba2cba1e>] sk_prot_alloc+0x112/0x170 net/core/sock.c:1603
     [<00000000f1d9d4df>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000d33ee81e>] llc_sk_alloc+0x35/0x170 net/llc/llc_conn.c:950
     [<00000000f9f972a8>] llc_ui_create+0x7b/0x150 net/llc/af_llc.c:173
     [<00000000d9cdf850>] __sock_create+0x164/0x250 net/socket.c:1414
     [<00000000ca906883>] sock_create net/socket.c:1465 [inline]
     [<00000000ca906883>] __sys_socket+0x69/0x110 net/socket.c:1507
     [<00000000e00ea1b3>] __do_sys_socket net/socket.c:1516 [inline]
     [<00000000e00ea1b3>] __se_sys_socket net/socket.c:1514 [inline]
     [<00000000e00ea1b3>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
     [<00000000dfc2afaa>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<00000000702ee9bf>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810acb0a00 (size 32):
   comm "syz-executor273", pid 7002, jiffies 4294943426 (age 13.700s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     e1 00 00 00 03 00 00 00 0f 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000006d098b11>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006d098b11>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006d098b11>] slab_alloc mm/slab.c:3319 [inline]
     [<000000006d098b11>] kmem_cache_alloc_trace+0x145/0x2c0 mm/slab.c:3548
     [<00000000f45530b8>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000f45530b8>] kzalloc include/linux/slab.h:748 [inline]
     [<00000000f45530b8>] selinux_sk_alloc_security+0x48/0xb0  
security/selinux/hooks.c:5073
     [<000000003ff46bd8>] security_sk_alloc+0x49/0x70  
security/security.c:2029
     [<000000007c679d89>] sk_prot_alloc+0x12d/0x170 net/core/sock.c:1606
     [<00000000f1d9d4df>] sk_alloc+0x35/0x2f0 net/core/sock.c:1657
     [<00000000d33ee81e>] llc_sk_alloc+0x35/0x170 net/llc/llc_conn.c:950
     [<00000000f9f972a8>] llc_ui_create+0x7b/0x150 net/llc/af_llc.c:173
     [<00000000d9cdf850>] __sock_create+0x164/0x250 net/socket.c:1414
     [<00000000ca906883>] sock_create net/socket.c:1465 [inline]
     [<00000000ca906883>] __sys_socket+0x69/0x110 net/socket.c:1507
     [<00000000e00ea1b3>] __do_sys_socket net/socket.c:1516 [inline]
     [<00000000e00ea1b3>] __se_sys_socket net/socket.c:1514 [inline]
     [<00000000e00ea1b3>] __x64_sys_socket+0x1e/0x30 net/socket.c:1514
     [<00000000dfc2afaa>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<00000000702ee9bf>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88812ad27400 (size 224):
   comm "syz-executor273", pid 7002, jiffies 4294943426 (age 13.700s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 50 a3 2a 81 88 ff ff 00 18 6f 1e 81 88 ff ff  .P.*......o.....
   backtrace:
     [<000000003b74814c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000003b74814c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000003b74814c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000003b74814c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<000000005ec232c8>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000051d15bd>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000051d15bd>] alloc_skb_with_frags+0x5f/0x250  
net/core/skbuff.c:5628
     [<000000006b5faf6f>] sock_alloc_send_pskb+0x269/0x2a0  
net/core/sock.c:2223
     [<00000000c32ec5bd>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2240
     [<00000000068e05dd>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
     [<00000000776b0139>] sock_sendmsg_nosec net/socket.c:633 [inline]
     [<00000000776b0139>] sock_sendmsg+0x54/0x70 net/socket.c:653
     [<0000000028377a2b>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2307
     [<00000000f74197f6>] __sys_sendmsg+0x80/0xf0 net/socket.c:2352
     [<00000000084b8970>] __do_sys_sendmsg net/socket.c:2361 [inline]
     [<00000000084b8970>] __se_sys_sendmsg net/socket.c:2359 [inline]
     [<00000000084b8970>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2359
     [<00000000dfc2afaa>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<00000000702ee9bf>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881137ed400 (size 512):
   comm "syz-executor273", pid 7002, jiffies 4294943426 (age 13.700s)
   hex dump (first 32 bytes):
     7a 0f 00 00 00 00 00 00 2f 31 37 20 30 38 3a 30  z......./17 08:0
     35 3a 32 39 00 c6 bf 81 03 00 69 6c 65 3d 30 20  5:29......ile=0
   backtrace:
     [<00000000f10c8cea>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f10c8cea>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000f10c8cea>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000f10c8cea>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<0000000082c86374>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<0000000082c86374>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<000000009e316c15>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<00000000817024aa>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000051d15bd>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000051d15bd>] alloc_skb_with_frags+0x5f/0x250  
net/core/skbuff.c:5628
     [<000000006b5faf6f>] sock_alloc_send_pskb+0x269/0x2a0  
net/core/sock.c:2223
     [<00000000c32ec5bd>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2240
     [<00000000068e05dd>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
     [<00000000776b0139>] sock_sendmsg_nosec net/socket.c:633 [inline]
     [<00000000776b0139>] sock_sendmsg+0x54/0x70 net/socket.c:653
     [<0000000028377a2b>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2307
     [<00000000f74197f6>] __sys_sendmsg+0x80/0xf0 net/socket.c:2352
     [<00000000084b8970>] __do_sys_sendmsg net/socket.c:2361 [inline]
     [<00000000084b8970>] __se_sys_sendmsg net/socket.c:2359 [inline]
     [<00000000084b8970>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2359
     [<00000000dfc2afaa>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<00000000702ee9bf>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


