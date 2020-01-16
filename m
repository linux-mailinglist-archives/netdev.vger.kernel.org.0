Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD713D11B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 01:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAPAZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 19:25:29 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:52902 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbgAPAZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 19:25:13 -0500
Received: by mail-io1-f72.google.com with SMTP id d10so11588617iod.19
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 16:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=uDCxE99L3Kizm601ZuyoSXKPaaY+XRBi2dhlbBvZTI8=;
        b=Puz9TzWmRGdAXEOk0yiUB6fVxMT9XamiirrDWkmiDQjMEqhy0+fgH+lsAjie7R3aEQ
         42oj6owFbwWgXHv0SUtoi+FbS4WnpcWuqWs/GKRqFkypm7CipyHSYjIY3fhk27JYpKNj
         eHaBxScIpKggqiKTFUOyYjxAcXR7r3rKYn0exF52670C+RvRLpbRfMHSoEcvO+aUMOTb
         TmFkxL8zyDb2I64Iun9iu2GEIYri8jl/w2iu3nIi74lMYEQPbelbHhlPl4Dq68kfDjwA
         AmCbRgXsvBMt1XHq506prn8qf9wZg5/lcZ2RB1FpJ+8ihnHGaTvzmSFH9b3jjsTTR6C8
         SYNw==
X-Gm-Message-State: APjAAAXi+g/wdsNeF4jVhCIbt8RL4GcVT0a8SVnk3CHQhWBkyIvUdqIh
        n30te7tXnCbC9IUiYnqzTvfdNsjFlYSucS/jYsEnONRBkI3i
X-Google-Smtp-Source: APXvYqyRs+uDLZoCJFvdLkUo+lNWTa3pvZ3ERP/W5BX4qMyuSeYDj5BjWEtPFLIBSsNpRXufqbGVIIq1wpFry6OutBe3TDMByBGb
MIME-Version: 1.0
X-Received: by 2002:a5e:c014:: with SMTP id u20mr24376530iol.43.1579134311865;
 Wed, 15 Jan 2020 16:25:11 -0800 (PST)
Date:   Wed, 15 Jan 2020 16:25:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b62bda059c36db7c@google.com>
Subject: general protection fault in nft_tunnel_get_init
From:   syzbot <syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com>
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

HEAD commit:    51d69817 Merge tag 'platform-drivers-x86-v5.5-3' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1703533ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=76d0b80493ac881ff77b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166f4bfee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159c4371e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+76d0b80493ac881ff77b@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9557 Comm: syz-executor096 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:nla_get_be32 include/net/netlink.h:1483 [inline]
RIP: 0010:nft_tunnel_get_init+0x65/0x2b0 net/netfilter/nft_tunnel.c:83
Code: 02 00 00 4c 8b 6b 08 4d 85 ed 0f 84 ba 01 00 00 e8 a0 8d 08 fb 49 8d  
7d 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 df
RSP: 0018:ffffc90002127398 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff88808b620008 RCX: ffffffff866720af
RDX: 0000000000000000 RSI: ffffffff866c67e0 RDI: 0000000000000004
RBP: ffffc900021273c8 R08: ffff88809f4424c0 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff88809824ac18
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc90002127498
FS:  00000000011dc880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200009c6 CR3: 00000000a8486000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  nf_tables_newexpr net/netfilter/nf_tables_api.c:2466 [inline]
  nf_tables_newrule+0xd96/0x2400 net/netfilter/nf_tables_api.c:3074
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
RIP: 0033:0x4407b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe11777578 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004407b9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000001 R09: 00000000004002c8
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000402040
R13: 00000000004020d0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace e202d5958993ae18 ]---
RIP: 0010:nla_get_be32 include/net/netlink.h:1483 [inline]
RIP: 0010:nft_tunnel_get_init+0x65/0x2b0 net/netfilter/nft_tunnel.c:83
Code: 02 00 00 4c 8b 6b 08 4d 85 ed 0f 84 ba 01 00 00 e8 a0 8d 08 fb 49 8d  
7d 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 df
RSP: 0018:ffffc90002127398 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff88808b620008 RCX: ffffffff866720af
RDX: 0000000000000000 RSI: ffffffff866c67e0 RDI: 0000000000000004
RBP: ffffc900021273c8 R08: ffff88809f4424c0 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff88809824ac18
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc90002127498
FS:  00000000011dc880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200009c6 CR3: 00000000a8486000 CR4: 00000000001406e0
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
