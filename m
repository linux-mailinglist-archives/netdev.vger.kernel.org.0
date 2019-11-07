Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14FDF37A6
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfKGSzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:55:11 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:48367 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfKGSzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:55:10 -0500
Received: by mail-il1-f197.google.com with SMTP id j68so3593824ili.15
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 10:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ncLHvCMcrTLEL3uLU3CyiqGHvpiV5fStvg1s9KU5q9Y=;
        b=J+OPgaMUwlHAD7ULYYwDwSzEoIjQRuUBThX+KmCKVXSiBfWfyDAphRSvmIBE/d84f1
         88rZwnlFhSjzoEFIf9gWiPlcpYBUN8EmSDnI8R6DSsGtTK0JZOp3RKvC6koXBG536sOb
         G2MND49tqWffbbdQTo7TkoXlbTZg20kyJnsNri42ayYMLxoVaEfHqpBOHn4n3otXOlYz
         GSks3l8l5Z4Tr0nr17ePIXdDE0JCy0/CeNeikp4/EBEp2P1CKkKiCw6H/00LKc7mvzf3
         PPHmGD5Yq8MTJV8dcj+CLNAsG8B0d2BUyKLY7jpyiyaCER1dN9+VFpgtAnhkLkItdU8D
         fRSg==
X-Gm-Message-State: APjAAAVVRXVctZXlGvrGwK+jE15pSNDjdonF9S7I+fK3KyRXwV1JEjPB
        0XPbq/GprCluQJpsBFhU16HlPtUgpFIK/ldfQ8UWKtxOTHNm
X-Google-Smtp-Source: APXvYqwu+NO9F4IWA1pOKF2v1GmJWS4zEFUZ9BuEmpGqON5v+RXmNcCbkzeCr8UHY4pYUB0TzbbUvHQuLcZkO6FyaEkG9nM10/4S
MIME-Version: 1.0
X-Received: by 2002:a92:ce06:: with SMTP id b6mr6266104ilo.14.1573152909795;
 Thu, 07 Nov 2019 10:55:09 -0800 (PST)
Date:   Thu, 07 Nov 2019 10:55:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005daaaf0596c634bc@google.com>
Subject: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg
From:   syzbot <syzbot+6dedf50d68e5713a1f65@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, dsahern@gmail.com,
        elver@google.com, herbert@gondor.apana.org.au,
        jakub.kicinski@netronome.com, linux-kernel@vger.kernel.org,
        lirongqing@baidu.com, netdev@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, ptalbert@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    94c00660 x86, kcsan: Enable KCSAN for x86
git tree:       https://github.com/google/ktsan.git kcsan
console output: https://syzkaller.appspot.com/x/log.txt?x=14426768e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51a7c7d2972c87e5
dashboard link: https://syzkaller.appspot.com/bug?extid=6dedf50d68e5713a1f65
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6dedf50d68e5713a1f65@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg

write to 0xffff8880b588efb2 of 2 bytes by task 19788 on cpu 0:
  skb_reset_transport_header include/linux/skbuff.h:2463 [inline]
  netlink_recvmsg+0x196/0x910 net/netlink/af_netlink.c:1974
  sock_recvmsg_nosec+0x5c/0x70 net/socket.c:871
  ___sys_recvmsg+0x1a0/0x3e0 net/socket.c:2480
  do_recvmmsg+0x19a/0x5c0 net/socket.c:2601
  __sys_recvmmsg+0x1ef/0x200 net/socket.c:2680
  __do_sys_recvmmsg net/socket.c:2703 [inline]
  __se_sys_recvmmsg net/socket.c:2696 [inline]
  __x64_sys_recvmmsg+0x89/0xb0 net/socket.c:2696
  do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880b588efb2 of 2 bytes by task 19789 on cpu 1:
  skb_reset_transport_header include/linux/skbuff.h:2463 [inline]
  netlink_recvmsg+0x196/0x910 net/netlink/af_netlink.c:1974
  sock_recvmsg_nosec net/socket.c:871 [inline]
  sock_recvmsg net/socket.c:889 [inline]
  sock_recvmsg+0x92/0xb0 net/socket.c:885
  __sys_recvfrom+0x1ae/0x2d0 net/socket.c:2009
  __do_sys_recvfrom net/socket.c:2027 [inline]
  __se_sys_recvfrom net/socket.c:2023 [inline]
  __x64_sys_recvfrom+0x89/0xb0 net/socket.c:2023
  do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 19789 Comm: syz-executor.0 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 19789 Comm: syz-executor.0 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xf5/0x159 lib/dump_stack.c:113
  panic+0x210/0x640 kernel/panic.c:221
  kcsan_report.cold+0xc/0xe kernel/kcsan/report.c:302
  kcsan_setup_watchpoint+0x3fe/0x410 kernel/kcsan/core.c:357
  check_access kernel/kcsan/core.c:409 [inline]
  __tsan_unaligned_write2+0x143/0x1f0 kernel/kcsan/core.c:528
  skb_reset_transport_header include/linux/skbuff.h:2463 [inline]
  netlink_recvmsg+0x196/0x910 net/netlink/af_netlink.c:1974
  sock_recvmsg_nosec net/socket.c:871 [inline]
  sock_recvmsg net/socket.c:889 [inline]
  sock_recvmsg+0x92/0xb0 net/socket.c:885
  __sys_recvfrom+0x1ae/0x2d0 net/socket.c:2009
  __do_sys_recvfrom net/socket.c:2027 [inline]
  __se_sys_recvfrom net/socket.c:2023 [inline]
  __x64_sys_recvfrom+0x89/0xb0 net/socket.c:2023
  do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45a219
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f580a978c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 000000000045a219
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f580a9796d4
R13: 00000000004c7c59 R14: 00000000004ddd80 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
