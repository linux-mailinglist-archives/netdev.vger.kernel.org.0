Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42632141683
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 09:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgARIZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 03:25:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:42308 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgARIZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 03:25:10 -0500
Received: by mail-io1-f72.google.com with SMTP id e7so16640638iog.9
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 00:25:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eHZwoNuhtEt+IN5H0E9oOVaNORve5ghyEKZxVnop2KE=;
        b=DbhiyyKPxX2KNcr1w3e+JVmKrkOUqWtPX+ifOSBVmtavZUGtyz9cscP737hOAM9tTx
         VTQMv5Y2JhlQt2scCGdbVhuGd0AkjsuEIOopBx+AVY9QKObsTmzNH9X0mvWQFX6p0AGE
         Ckyycgp1h0WwjgyyARshSIvg+w9zuN7B0zepFEZFR6yBRURh2FxQr5s6a7WGZACDv32x
         VcjAQ+AtnWx2+RbAk1AWc8gORKoj5U0H5tZHA4e4EB2X05oEL9bMI9G+RahSkOm9uvoF
         O4Y2NoshLKPW55eTk5Ys9c8devSiiKmakShVK8NF5TEUIXKGbZ/eR9nDk+dSGjZ2izod
         e+Zg==
X-Gm-Message-State: APjAAAVIEgq8gMmv3W6FRZXr6+69yKhHBRTIxDVEU0chLIS14o9c1kqr
        5l74bIzywTfFMpbzDohL9W3cTRoPHl88+e8fhs4KKbM3o/TG
X-Google-Smtp-Source: APXvYqzsrjGVoG5y5lJ5/4E2LUamp+avO9Dxkr4IB7HUhfB+Zs7cX275sKV7fFXUExj4F0XVF6nUTlVJZlkjJhlWiUqMDe/pJS6E
MIME-Version: 1.0
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr2201268ilq.282.1579335909063;
 Sat, 18 Jan 2020 00:25:09 -0800 (PST)
Date:   Sat, 18 Jan 2020 00:25:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d740e5059c65cbd0@google.com>
Subject: general protection fault in nft_parse_register
From:   syzbot <syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5a9ef194 net: systemport: Fixed queue mapping in internal ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=156724c9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=cf23983d697c26c34f60
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 30417 Comm: syz-executor.2 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_be32 include/net/netlink.h:1483 [inline]
RIP: 0010:nft_parse_register+0x24/0x90 net/netfilter/nf_tables_api.c:7576
Code: ff ff ff eb d8 90 55 48 89 e5 41 54 53 48 89 fb e8 91 50 10 fb 48 8d 7b 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 47 8b
RSP: 0018:ffffc900087bf380 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000ded3000
RDX: 0000000000000000 RSI: ffffffff8664a4ff RDI: 0000000000000004
RBP: ffffc900087bf390 R08: ffff88805b34a5c0 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a072da98
R13: ffffc900087bf498 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f4ff3b5a700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000075c000 CR3: 000000009d23d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nft_osf_init+0x1b7/0x280 net/netfilter/nft_osf.c:78
 nf_tables_newexpr net/netfilter/nf_tables_api.c:2478 [inline]
 nf_tables_newrule+0xd96/0x2400 net/netfilter/nf_tables_api.c:3086
 nfnetlink_rcv_batch+0xf42/0x17a0 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45aff9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4ff3b59c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4ff3b5a6d4 RCX: 000000000045aff9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000901 R14: 00000000004ca2fe R15: 000000000075bf2c
Modules linked in:
---[ end trace a22f7f52a398972c ]---
RIP: 0010:nla_get_be32 include/net/netlink.h:1483 [inline]
RIP: 0010:nft_parse_register+0x24/0x90 net/netfilter/nf_tables_api.c:7576
Code: ff ff ff eb d8 90 55 48 89 e5 41 54 53 48 89 fb e8 91 50 10 fb 48 8d 7b 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 47 8b
RSP: 0018:ffffc900087bf380 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000ded3000
RDX: 0000000000000000 RSI: ffffffff8664a4ff RDI: 0000000000000004
RBP: ffffc900087bf390 R08: ffff88805b34a5c0 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a072da98
R13: ffffc900087bf498 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f4ff3b5a700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6efdf3a518 CR3: 000000009d23d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
