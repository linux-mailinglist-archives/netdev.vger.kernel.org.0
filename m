Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D47813198A
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 21:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgAFUoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 15:44:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:40048 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbgAFUoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 15:44:09 -0500
Received: by mail-io1-f72.google.com with SMTP id e200so24151082iof.7
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 12:44:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nUQh4ZT3khBGylzmoNcHUNv5lP3x4Ibw/P8aybZACnA=;
        b=nfEC6zlzgSIlTEdEucqbws2KSvb+a8USGN8+fa8llbf6SZXD+dse+nvSEJh2eZdS6J
         HnLitYTFIW4p+b+O/8gjlWU2gsNNrkG6qFnPoYU8BWRUgw8h04jZiw3+ntP48xUquXCp
         wMagArmJmds5vHOhpYcwPA21RbgGQAiKkuMJEGSxrTNkaP2+sA3Iv0B4rvYvTpsHJu9h
         n3CN/FmzLtl1fv5eLzBn9393j5D9k0Cb/kj2v940X2Mham2OYldtRAab3zcdMT9TZTYl
         v3KNsLfQ/vBrtgP/dO9V7i+0rOdFubtd3HF4wWUi0sT9yD4kHmq6gjYCzIzgbKp5bO4V
         7MGQ==
X-Gm-Message-State: APjAAAV/Z9WwNxSzoKhFFeb0aa4dttR2aR+UEWTLuch/gR/miQGYp4H2
        ppbyvOqv9yw1u9611Ml6KF3pr6iJfwOq3CInCvDtiwPU3JVj
X-Google-Smtp-Source: APXvYqxVpO4G/iLgXyl1N6TUqGS8rrbpxq2N618JwYm16p7e+FIf6poohg1Gm26rgxXBvcLNeTA8zFJbyzY39HT2yFDCXwH/k3GA
MIME-Version: 1.0
X-Received: by 2002:a6b:5503:: with SMTP id j3mr68369856iob.142.1578343449021;
 Mon, 06 Jan 2020 12:44:09 -0800 (PST)
Date:   Mon, 06 Jan 2020 12:44:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009cd5e0059b7eb836@google.com>
Subject: general protection fault in dccp_timeout_nlattr_to_obj
From:   syzbot <syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d89091a4 macb: Don't unregister clks unconditionally
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11b98466e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=46a4ad33f345d1dd346e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ff2869e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16693751e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+46a4ad33f345d1dd346e@syzkaller.appspotmail.com

netlink: 24 bytes leftover after parsing attributes in process  
`syz-executor813'.
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9522 Comm: syz-executor813 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:dccp_timeout_nlattr_to_obj+0x60/0x230  
net/netfilter/nf_conntrack_proto_dccp.c:682
Code: 89 d8 48 c1 e8 03 42 0f b6 14 30 48 89 d8 83 e0 07 83 c0 03 38 d0 7c  
08 84 d2 0f 85 a1 01 00 00 4c 89 e0 44 8b 3b 48 c1 e8 03 <42> 0f b6 14 30  
4c 89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffffc90001fd73d8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff8a4cd6fc RCX: ffffffff866323e9
RDX: 0000000000000000 RSI: ffffffff866117d5 RDI: ffff888098c2cf00
RBP: ffffc90001fd7418 R08: ffff88809f51c280 R09: ffff888098c2cf00
R10: ffffed10131859e7 R11: ffff888098c2cf3f R12: 0000000000000000
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000005dc0
FS:  00000000022f4880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000200 CR3: 00000000a6a68000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ctnl_timeout_parse_policy+0x150/0x1d0  
net/netfilter/nfnetlink_cttimeout.c:67
  cttimeout_default_set+0x150/0x1c0 net/netfilter/nfnetlink_cttimeout.c:368
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
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
RIP: 0033:0x4401e9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe699346c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401e9
RDX: 0000000000000940 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a70
R13: 0000000000401b00 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 0b60d1e6ef381959 ]---
RIP: 0010:dccp_timeout_nlattr_to_obj+0x60/0x230  
net/netfilter/nf_conntrack_proto_dccp.c:682
Code: 89 d8 48 c1 e8 03 42 0f b6 14 30 48 89 d8 83 e0 07 83 c0 03 38 d0 7c  
08 84 d2 0f 85 a1 01 00 00 4c 89 e0 44 8b 3b 48 c1 e8 03 <42> 0f b6 14 30  
4c 89 e0 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffffc90001fd73d8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff8a4cd6fc RCX: ffffffff866323e9
RDX: 0000000000000000 RSI: ffffffff866117d5 RDI: ffff888098c2cf00
RBP: ffffc90001fd7418 R08: ffff88809f51c280 R09: ffff888098c2cf00
R10: ffffed10131859e7 R11: ffff888098c2cf3f R12: 0000000000000000
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000005dc0
FS:  00000000022f4880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 00000000a6a68000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
