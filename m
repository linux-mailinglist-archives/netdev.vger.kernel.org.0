Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 260738F6AB
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732091AbfHOVxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 17:53:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:40038 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfHOVxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 17:53:06 -0400
Received: by mail-io1-f72.google.com with SMTP id v16so1070866ioh.7
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 14:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=gv4WmbpCPYcVZfny0Gcre9BQo416G2abzQHUktwoccE=;
        b=lqJowhjkqxOdYD1emUVUDY03aQWrmfhToqIgh2YEbCdfKAZGA1I2J4sIBzP6fl+hxE
         bpo+RNk8gbOqe+MzgKcJDyWKsPUUW2o8T2gpskKm8nkNrMyFTAdLw/c8NXg3nGGjY3hi
         mO1pHSQUDX39w8f72iR6GNuMwIEe+IvZVm/7LDoUx69mNcQS1Iq20s6BysaYg716IYY4
         HooOZoHs2vPbWlub+dltvq+VnxkJ5ZykLOjdud5XIA7+JZxeitXv77kGX6jp4+2gnPFn
         tJTFMeirlinbldSN3mQ9fHSkuF7koj9mzHmJRbQc0Wc29PlqR5Ge0qFcTs0P+MZSs2PJ
         0o6A==
X-Gm-Message-State: APjAAAUTdJv8GCD9fCqR0MSTpdvfPZd3nbvo5qwvfgqaSGu39FJOCXIn
        rGoFIyh7KrLKbYiB713498sQtRzS05eTTyDjQBUMQHzPyHBI
X-Google-Smtp-Source: APXvYqy9q88JB5/m0kuwZAZBWfWOy+o1HaMgJ8z3XVDjEsW++I6AeeSyIASXxhnQOTP9MDYC4RuFlem0tUpLXl7rDo9q5M5akOfg
MIME-Version: 1.0
X-Received: by 2002:a02:b609:: with SMTP id h9mr7220153jam.36.1565905984874;
 Thu, 15 Aug 2019 14:53:04 -0700 (PDT)
Date:   Thu, 15 Aug 2019 14:53:04 -0700
In-Reply-To: <000000000000a7f012058a0c7a65@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000faf6c205902ee533@google.com>
Subject: Re: memory leak in nr_loopback_queue
From:   syzbot <syzbot+470d1a4a7b7a7c225881@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-hams@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    41de5963 Merge tag 'Wimplicit-fallthrough-5.3-rc5' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12408f1c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c5e70dcab57c6af
dashboard link: https://syzkaller.appspot.com/bug?extid=470d1a4a7b7a7c225881
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164de5ee600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1114f222600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+470d1a4a7b7a7c225881@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 50.960s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 50.960s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.030s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.030s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.100s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.100s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.160s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.160s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.240s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.240s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.300s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.300s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.370s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.370s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888116c16b00 (size 224):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.430s)
   hex dump (first 32 bytes):
     d0 38 61 0c 81 88 ff ff d0 38 61 0c 81 88 ff ff  .8a......8a.....
     00 00 00 00 00 00 00 00 00 98 95 0b 81 88 ff ff  ................
   backtrace:
     [<00000000e2ee4d2c>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000e2ee4d2c>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000e2ee4d2c>] slab_alloc_node mm/slab.c:3262 [inline]
     [<00000000e2ee4d2c>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
     [<0000000082f0e53e>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810de28200 (size 512):
   comm "syz-executor241", pid 7513, jiffies 4295078074 (age 51.430s)
   hex dump (first 32 bytes):
     bb bb bb 00 00 00 60 bb bb bb 01 00 00 61 10 01  ......`......a..
     9c 00 00 01 04 bb bb bb 00 00 00 60 bb bb bb 00  ...........`....
   backtrace:
     [<000000006183266a>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000006183266a>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<000000006183266a>] slab_alloc_node mm/slab.c:3262 [inline]
     [<000000006183266a>] kmem_cache_alloc_node_trace+0x161/0x2f0  
mm/slab.c:3592
     [<00000000425795e2>] __do_kmalloc_node mm/slab.c:3614 [inline]
     [<00000000425795e2>] __kmalloc_node_track_caller+0x38/0x50  
mm/slab.c:3629
     [<00000000e438b171>] __kmalloc_reserve.isra.0+0x40/0xb0  
net/core/skbuff.c:141
     [<000000005727e112>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:209
     [<00000000b73f5aed>] alloc_skb include/linux/skbuff.h:1055 [inline]
     [<00000000b73f5aed>] nr_loopback_queue+0x26/0xc0  
net/netrom/nr_loopback.c:34
     [<00000000e8738211>] nr_route_frame+0x2d1/0x340  
net/netrom/nr_route.c:772
     [<00000000f3c3ea99>] nr_transmit_buffer+0x86/0xc0  
net/netrom/nr_out.c:209
     [<00000000aa3080e2>] nr_write_internal+0x133/0x2e0  
net/netrom/nr_subr.c:205
     [<00000000d4e53049>] nr_establish_data_link+0x2d/0x60  
net/netrom/nr_out.c:227
     [<000000008eb58c4a>] nr_connect+0x13b/0x490 net/netrom/af_netrom.c:713
     [<00000000d6b40196>] __sys_connect+0x11d/0x170 net/socket.c:1828
     [<0000000059057e91>] __do_sys_connect net/socket.c:1839 [inline]
     [<0000000059057e91>] __se_sys_connect net/socket.c:1836 [inline]
     [<0000000059057e91>] __x64_sys_connect+0x1e/0x30 net/socket.c:1836
     [<0000000068560e8c>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000009035e9ed>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


