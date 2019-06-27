Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2717D57E0C
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfF0IRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:17:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44564 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfF0IRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:17:06 -0400
Received: by mail-io1-f72.google.com with SMTP id i133so1730857ioa.11
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VuXIC8tjNDuCVmmGPrtEeKuF98440ya/Wk/74x0ugyM=;
        b=dbMiIbXi9Czqw2hw6uibXUqXY6TvARfVQkJY5irKRJQ4S5+FUFQkaszjRLG75gnj6g
         Gmy9/NEqPUus0xk0l8jvC4w6LY9N92xbfQp+/vbhKr4+lnHHvEm3/jAXFmp/W+FSQfMj
         8iIVZTlh0dKE/S1/jRGobmecznwmgvq1yTXHtoOAGg+8VJAR7BSoy+2lziz64zpVjl3a
         GesURcbVSdxAu4bE45lqTUSaRvwq+Xjw6sjBqy7xCrUgtuMaRLJS/6l5fsM+WGy3MB8Z
         PnTa+/U5iRFwD4mPPs0Z1scZ3sULfBq2Ldb8d7pz1BvuXgQ/L+BSqUGt6VAEFWzs+YTT
         /N/w==
X-Gm-Message-State: APjAAAXmjN1sIesU+eE3QXWKrcDqpXU+cZ306xSytb9OgThHmLHJlBmm
        AcqUbuFoBP4GRnoN4vNZ3GeyMDKtzBVVaCXNi0G1rT+J5qqk
X-Google-Smtp-Source: APXvYqx1Pnmkl1otcLTMDrcx9gDvgdezl75gB6MoowgjWuCpY3TtRKtWiSHU4FhMMavN0tc5QkXsbxyzt6mtm/C9Vs1dphnc0qJR
MIME-Version: 1.0
X-Received: by 2002:a02:16c5:: with SMTP id a188mr3184472jaa.86.1561623425654;
 Thu, 27 Jun 2019 01:17:05 -0700 (PDT)
Date:   Thu, 27 Jun 2019 01:17:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f288c058c49c986@google.com>
Subject: memory leak in ip_mc_add_src (2)
From:   syzbot <syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    249155c2 Merge branch 'parisc-5.2-4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=122594ada00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1db8bd6825f9661c
dashboard link: https://syzkaller.appspot.com/bug?extid=6ca1abd0db68b5173a4f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15dc46eea00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ee5aada00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811450f140 (size 64):
   comm "softirq", pid 0, jiffies 4294942448 (age 32.070s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
     00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000c7bad083>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000c7bad083>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000c7bad083>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000c7bad083>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000009acc4151>] kmalloc include/linux/slab.h:547 [inline]
     [<000000009acc4151>] kzalloc include/linux/slab.h:742 [inline]
     [<000000009acc4151>] ip_mc_add1_src net/ipv4/igmp.c:1976 [inline]
     [<000000009acc4151>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2100
     [<000000004ac14566>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2484
     [<0000000052d8f995>] do_ip_setsockopt.isra.0+0x1795/0x1930  
net/ipv4/ip_sockglue.c:959
     [<000000004ee1e21f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1248
     [<0000000066cdfe74>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2618
     [<000000009383a786>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3126
     [<00000000d8ac0c94>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
     [<000000001b1e9666>] __do_sys_setsockopt net/socket.c:2083 [inline]
     [<000000001b1e9666>] __se_sys_setsockopt net/socket.c:2080 [inline]
     [<000000001b1e9666>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
     [<00000000420d395e>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007fd83a4b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810ec5ab40 (size 64):
   comm "softirq", pid 0, jiffies 4294943651 (age 20.040s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
     00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000c7bad083>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000c7bad083>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000c7bad083>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000c7bad083>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000009acc4151>] kmalloc include/linux/slab.h:547 [inline]
     [<000000009acc4151>] kzalloc include/linux/slab.h:742 [inline]
     [<000000009acc4151>] ip_mc_add1_src net/ipv4/igmp.c:1976 [inline]
     [<000000009acc4151>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2100
     [<000000004ac14566>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2484
     [<0000000052d8f995>] do_ip_setsockopt.isra.0+0x1795/0x1930  
net/ipv4/ip_sockglue.c:959
     [<000000004ee1e21f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1248
     [<0000000066cdfe74>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2618
     [<000000009383a786>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3126
     [<00000000d8ac0c94>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
     [<000000001b1e9666>] __do_sys_setsockopt net/socket.c:2083 [inline]
     [<000000001b1e9666>] __se_sys_setsockopt net/socket.c:2080 [inline]
     [<000000001b1e9666>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
     [<00000000420d395e>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007fd83a4b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888112a6e080 (size 64):
   comm "softirq", pid 0, jiffies 4294944252 (age 14.030s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
     00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
   backtrace:
     [<00000000c7bad083>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000c7bad083>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<00000000c7bad083>] slab_alloc mm/slab.c:3326 [inline]
     [<00000000c7bad083>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<000000009acc4151>] kmalloc include/linux/slab.h:547 [inline]
     [<000000009acc4151>] kzalloc include/linux/slab.h:742 [inline]
     [<000000009acc4151>] ip_mc_add1_src net/ipv4/igmp.c:1976 [inline]
     [<000000009acc4151>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2100
     [<000000004ac14566>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2484
     [<0000000052d8f995>] do_ip_setsockopt.isra.0+0x1795/0x1930  
net/ipv4/ip_sockglue.c:959
     [<000000004ee1e21f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1248
     [<0000000066cdfe74>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2618
     [<000000009383a786>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3126
     [<00000000d8ac0c94>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
     [<000000001b1e9666>] __do_sys_setsockopt net/socket.c:2083 [inline]
     [<000000001b1e9666>] __se_sys_setsockopt net/socket.c:2080 [inline]
     [<000000001b1e9666>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
     [<00000000420d395e>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007fd83a4b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
