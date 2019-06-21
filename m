Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551714E85F
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 14:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFUM5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 08:57:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52650 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfFUM5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 08:57:09 -0400
Received: by mail-io1-f71.google.com with SMTP id p12so10568493iog.19
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 05:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rrJgEkmhWL/jAI/VVr1E6xB9thGk94zrBrmoibWlXfE=;
        b=KT/hDjwdxRKpf5hRZKjEAOzHlkEiXlj4K0byIf1k71HUAQ4E/5a70hn71DE7Fdun6I
         KP+7seeAGHuw+22CmMK58Jhdq1CrQVVVXJfE18QnEPQt138s8dV6wh//7kbwwz6Ofqaf
         Bq3oMxXy5oVNarUx5+b8CB3S7YUjRqp3HJ46x9hygGcQthxpj3A4Jus4s5CmUXXym+Bl
         KpaBWKzPZ4kWrFA2SNXdRdicQUD0UPV+mJWWl5LoB8Osmlp3aECa4RUotDCEGGvQGkyz
         iy/ZO9JIUcsQxPPyLIS7lCIn7HvWCboglZBy9wHi1oCpQOzCiOLWSU08yNoPbuLkqi4f
         sVow==
X-Gm-Message-State: APjAAAW20o5jK53U8hgyet8byVRzzeU67ga6Q4yIW5LEYkMtsilQayEE
        16PRQqU29bYPiAPImANazF+7IcCBJWEbpWnkq3ENG0eMCFlc
X-Google-Smtp-Source: APXvYqwPOGegcwnFEX0aJMbIj9Al8/IJwTfxUbnFQhM/VWS+5moqNPPcR3X3TvCWl7yjicCua4ZleN/YDWWbAReZZfGtuzKytRyO
MIME-Version: 1.0
X-Received: by 2002:a05:6602:22cc:: with SMTP id e12mr20577466ioe.192.1561121828208;
 Fri, 21 Jun 2019 05:57:08 -0700 (PDT)
Date:   Fri, 21 Jun 2019 05:57:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000058a0f058bd50068@google.com>
Subject: memory leak in llc_ui_create (2)
From:   syzbot <syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14cc10b1a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
dashboard link: https://syzkaller.appspot.com/bug?extid=6bf095f9becf5efef645
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1698d45ea00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6bf095f9becf5efef645@syzkaller.appspotmail.com

85.529503][ T7031] 8021q: adding VLAN 0 to HW filter on device batadv0
2019/06/20 19:36:46 executed programs: 1
2019/06/20 19:36:51 executed programs: 3
BUG: memory leak
unreferenced object 0xffff888118b8d800 (size 2048):
   comm "syz-executor.0", pid 7054, jiffies 4295036362 (age 12.560s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     1a 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
   backtrace:
     [<000000004a3a66c0>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000004a3a66c0>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000004a3a66c0>] slab_alloc mm/slab.c:3326 [inline]
     [<000000004a3a66c0>] __do_kmalloc mm/slab.c:3658 [inline]
     [<000000004a3a66c0>] __kmalloc+0x161/0x2c0 mm/slab.c:3669
     [<00000000cc5a7d28>] kmalloc include/linux/slab.h:552 [inline]
     [<00000000cc5a7d28>] sk_prot_alloc+0xd6/0x170 net/core/sock.c:1602
     [<000000000c449f88>] sk_alloc+0x35/0x2f0 net/core/sock.c:1656
     [<0000000008b99378>] llc_sk_alloc+0x35/0x170 net/llc/llc_conn.c:950
     [<00000000d4e72aed>] llc_ui_create+0x7b/0x140 net/llc/af_llc.c:173
     [<00000000d0bfef06>] __sock_create+0x164/0x250 net/socket.c:1424
     [<0000000058cf7a3c>] sock_create net/socket.c:1475 [inline]
     [<0000000058cf7a3c>] __sys_socket+0x69/0x110 net/socket.c:1517
     [<000000003ce548ba>] __do_sys_socket net/socket.c:1526 [inline]
     [<000000003ce548ba>] __se_sys_socket net/socket.c:1524 [inline]
     [<000000003ce548ba>] __x64_sys_socket+0x1e/0x30 net/socket.c:1524
     [<0000000029c8eba9>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000dba589d4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888120dd7a00 (size 224):
   comm "syz-executor.0", pid 7054, jiffies 4295036362 (age 12.560s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 10 0c 24 81 88 ff ff 00 d8 b8 18 81 88 ff ff  ...$............
   backtrace:
     [<00000000b6c096c6>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000b6c096c6>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000b6c096c6>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000b6c096c6>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
     [<00000000556a01d4>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:194
     [<0000000085622924>] alloc_skb include/linux/skbuff.h:1054 [inline]
     [<0000000085622924>] alloc_skb_with_frags+0x5f/0x250  
net/core/skbuff.c:5328
     [<00000000ca5b438b>] sock_alloc_send_pskb+0x269/0x2a0  
net/core/sock.c:2222
     [<0000000044a5b8c6>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2239
     [<00000000b19d8ca2>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
     [<00000000aaeaeaf3>] sock_sendmsg_nosec net/socket.c:646 [inline]
     [<00000000aaeaeaf3>] sock_sendmsg+0x54/0x70 net/socket.c:665
     [<000000009ae2ec20>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2286
     [<000000003ac4094d>] __sys_sendmsg+0x80/0xf0 net/socket.c:2324
     [<00000000d3b808ba>] __do_sys_sendmsg net/socket.c:2333 [inline]
     [<00000000d3b808ba>] __se_sys_sendmsg net/socket.c:2331 [inline]
     [<00000000d3b808ba>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2331
     [<0000000029c8eba9>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000dba589d4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881178e3800 (size 512):
   comm "syz-executor.0", pid 7054, jiffies 4295036362 (age 12.560s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 ad ad f3 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000baa5fe0c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000baa5fe0c>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000baa5fe0c>] slab_alloc_node mm/slab.c:3269 [inline]
     [<00000000baa5fe0c>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<00000000ef42ca2e>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<00000000ef42ca2e>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3634
     [<00000000792340d3>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:138
     [<000000003b989a40>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:206
     [<0000000085622924>] alloc_skb include/linux/skbuff.h:1054 [inline]
     [<0000000085622924>] alloc_skb_with_frags+0x5f/0x250  
net/core/skbuff.c:5328
     [<00000000ca5b438b>] sock_alloc_send_pskb+0x269/0x2a0  
net/core/sock.c:2222
     [<0000000044a5b8c6>] sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2239
     [<00000000b19d8ca2>] llc_ui_sendmsg+0x10a/0x540 net/llc/af_llc.c:933
     [<00000000aaeaeaf3>] sock_sendmsg_nosec net/socket.c:646 [inline]
     [<00000000aaeaeaf3>] sock_sendmsg+0x54/0x70 net/socket.c:665
     [<000000009ae2ec20>] ___sys_sendmsg+0x393/0x3c0 net/socket.c:2286
     [<000000003ac4094d>] __sys_sendmsg+0x80/0xf0 net/socket.c:2324
     [<00000000d3b808ba>] __do_sys_sendmsg net/socket.c:2333 [inline]
     [<00000000d3b808ba>] __se_sys_sendmsg net/socket.c:2331 [inline]
     [<00000000d3b808ba>] __x64_sys_sendmsg+0x23/0x30 net/socket.c:2331
     [<0000000029c8eba9>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000dba589d4>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
