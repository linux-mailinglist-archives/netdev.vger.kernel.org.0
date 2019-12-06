Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827C8114E2D
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 10:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfLFJbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 04:31:08 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:35668 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfLFJbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 04:31:08 -0500
Received: by mail-io1-f71.google.com with SMTP id x10so4421860iob.2
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 01:31:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pK4ZxCKpiJAZoUDvMUbG0xETDdTCbYaw+qcyxpMMxhE=;
        b=WbMdHppB6d4qVB0IUSeUheUpWb3mnP73nMh4hCYLKeFu5cwTLYN4eboGYU2ZmU/yeC
         7WVK7QsQjP0OS+ksYS7EICcY5phaow+I9obILn3pbKJnKD/Kxc4byR+X4VHlU1W4DApi
         BHf2/zYZF/z2AEwDqA8kHlz2ukrGtqZo0c/h3BrhFUhhkQ2HRypEEssaV9Kav2+hhHE0
         7w4wLwPpUOb8eKKuGHAkT/eO8N6UMXg7QM1BKcO14zNj4qzacJOQwQzD4FSVil191q5O
         cLnoKOoRSkkQA7O39i98l+PANcqeVQhAO9Q6DeGoC9i34aTGwhGxSBOwHTMBuGB4nMZE
         iV/g==
X-Gm-Message-State: APjAAAVkLsRdmesDqgvA7cn9I3Z5uK78uBSws6F57B9TfV4AH+jNGnOA
        ZO5Y3SKIrLROnIPPAKoHfwR3qu4NQLRKONBElk/a4xIraZKG
X-Google-Smtp-Source: APXvYqy95rnuJMV5lS2hLIZWCWb+DeCFrODLR9MKwd92TZONaIkoJH5Q0ZxjeW164xKajVXjxbYGi+TqJkLk+HGr5KmyvCa5JE+5
MIME-Version: 1.0
X-Received: by 2002:a02:aa0c:: with SMTP id r12mr6353295jam.75.1575624667549;
 Fri, 06 Dec 2019 01:31:07 -0800 (PST)
Date:   Fri, 06 Dec 2019 01:31:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009bd693059905b445@google.com>
Subject: KASAN: null-ptr-deref Write in x25_connect
From:   syzbot <syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andrew.hendry@gmail.com, arnd@arndb.de,
        davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, willemb@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9bd19c63 net: emulex: benet: indent a Kconfig depends cont..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=14b858eae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=333b76551307b2a0
dashboard link: https://syzkaller.appspot.com/bug?extid=429c200ffc8772bfe070
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+429c200ffc8772bfe070@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in atomic_fetch_sub  
include/asm-generic/atomic-instrumented.h:199 [inline]
BUG: KASAN: null-ptr-deref in refcount_sub_and_test  
include/linux/refcount.h:253 [inline]
BUG: KASAN: null-ptr-deref in refcount_dec_and_test  
include/linux/refcount.h:281 [inline]
BUG: KASAN: null-ptr-deref in x25_neigh_put include/net/x25.h:252 [inline]
BUG: KASAN: null-ptr-deref in x25_connect+0x974/0x1020 net/x25/af_x25.c:820
Write of size 4 at addr 00000000000000c8 by task syz-executor.5/32400

CPU: 1 PID: 32400 Comm: syz-executor.5 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  __kasan_report.cold+0x5/0x41 mm/kasan/report.c:510
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  __kasan_check_write+0x14/0x20 mm/kasan/common.c:98
  atomic_fetch_sub include/asm-generic/atomic-instrumented.h:199 [inline]
  refcount_sub_and_test include/linux/refcount.h:253 [inline]
  refcount_dec_and_test include/linux/refcount.h:281 [inline]
  x25_neigh_put include/net/x25.h:252 [inline]
  x25_connect+0x974/0x1020 net/x25/af_x25.c:820
  __sys_connect_file+0x25d/0x2e0 net/socket.c:1847
  __sys_connect+0x51/0x90 net/socket.c:1860
  __do_sys_connect net/socket.c:1871 [inline]
  __se_sys_connect net/socket.c:1868 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:1868
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa58a10ec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045a679
RDX: 0000000000000012 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa58a10f6d4
R13: 00000000004c0f1c R14: 00000000004d4088 R15: 00000000ffffffff
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
