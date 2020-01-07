Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B68132AA5
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgAGQDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:03:12 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:37877 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbgAGQDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:03:12 -0500
Received: by mail-il1-f198.google.com with SMTP id l13so2977585ilj.4
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 08:03:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=15T2xAHJS3nP4BPvPnRtaPb9pVH66zABJxVoX7e4sZg=;
        b=NQ2S8L/MZfNphtVdhEZvzRe6DD25LEJshFtKUAxK4V1iGe3l17W0UFk32+tAhQJB53
         Wn1t89jlC8jaIxfVPlVC3KT/XB2Gm25H2pILgl0o+iiKfdwN12P4sD1WogwHyvBIEkj/
         qYcXiP8a07jaJqkK59Rzv50DZAls7lX2tQGg70nFOf29yiL4E3BQENXqNrs/2mPbIzkB
         uFdK/hH2cQPjITtxNUgbVqCmlxFG00QVTnxzYCah4feqo2bSRanDb0lz5N7euxEoOEem
         2jAdNVRDA17zt8OsSzFhbL2J/pMf6qF8/eKFgKy8hNUX83tpSiDRZ+Ter8VOi6NPTWO3
         8r9g==
X-Gm-Message-State: APjAAAWjwLY7P7RGBsrS61zVYFQZ3VuiaRtYsBoEBDbK5cxtPNpxIG4y
        1+ZGtdAKQvaxrQZzY40LGkHZJ4BRpcyTV/9qM7nDAnYWtxNy
X-Google-Smtp-Source: APXvYqwk8EA4dJkOoo28QtwuwpvPdyTLlAq/LU/Z03WE+T/ZMz+rg0y/JeU5Hus5i8r2xZfOyydHgf46KTOJqBrsEtZhgsVR8U0f
MIME-Version: 1.0
X-Received: by 2002:a92:5855:: with SMTP id m82mr90292682ilb.302.1578412990996;
 Tue, 07 Jan 2020 08:03:10 -0800 (PST)
Date:   Tue, 07 Jan 2020 08:03:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a347ef059b8ee979@google.com>
Subject: general protection fault in hash_ipportnet4_uadt
From:   syzbot <syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com>
To:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, info@metux.net, jeremy@azazel.net,
        kadlec@netfilter.org, kstewart@linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1b935183 Merge branch 'Unique-mv88e6xxx-IRQ-names'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15352325e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=977dda960db4d1e7
dashboard link: https://syzkaller.appspot.com/bug?extid=34bd2369d38707f3f4a7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9396 Comm: syz-executor.3 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_ipportnet4_uadt+0x20b/0x13e0  
net/netfilter/ipset/ip_set_hash_ipportnet.c:173
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 71 0c 00 00 4c 89  
e2 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2c
RSP: 0018:ffffc9000793f150 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc9000793f320 RCX: ffffc9000f81d000
RDX: 0000000000000000 RSI: ffffffff86821788 RDI: ffff88809f886430
RBP: ffffc9000793f2b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 0000000000000000
R13: 00000000ff7f0000 R14: ffffc9000793f220 R15: ffff8880a355ea00
FS:  00007fa58b436700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000340 CR3: 000000009d628000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:643 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:663
  ____sys_sendmsg+0x753/0x880 net/socket.c:2342
  ___sys_sendmsg+0x100/0x170 net/socket.c:2396
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2429
  __do_sys_sendmsg net/socket.c:2438 [inline]
  __se_sys_sendmsg net/socket.c:2436 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2436
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa58b435c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fa58b4366d4
R13: 00000000004c9e62 R14: 00000000004e2e98 R15: 00000000ffffffff
Modules linked in:
---[ end trace 7a7fd1554086524f ]---
RIP: 0010:hash_ipportnet4_uadt+0x20b/0x13e0  
net/netfilter/ipset/ip_set_hash_ipportnet.c:173
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 71 0c 00 00 4c 89  
e2 45 8b 6d 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 4c  
89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2c
RSP: 0018:ffffc9000793f150 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffffc9000793f320 RCX: ffffc9000f81d000
RDX: 0000000000000000 RSI: ffffffff86821788 RDI: ffff88809f886430
RBP: ffffc9000793f2b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 0000000000000000
R13: 00000000ff7f0000 R14: ffffc9000793f220 R15: ffff8880a355ea00
FS:  00007fa58b436700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000340 CR3: 000000009d628000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
