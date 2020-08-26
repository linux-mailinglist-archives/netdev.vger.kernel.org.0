Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF350253186
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgHZOic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:38:32 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:55041 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgHZOiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:38:25 -0400
Received: by mail-io1-f71.google.com with SMTP id o18so1358474ioa.21
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 07:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hVKkFWcDp6C4jE79q6b4gVLV14SWjOcaiVviZRs5Qkw=;
        b=W6WRZW+ESqUdKJYfA+eWwRndB5wiCERvKePiurHZ7zhazwD9KsD2fI1zVAxjg8Qr/g
         c+qc0wSBu9AextIc72YOf9kYF2FYKSTHdcYWdDWZ0+FV4z61w6xMm1+Zpm+To7wWXW09
         STt8v0UpVBrmslk8lZT+RAAmKsR02udFTqGB/tLcm7xo48K6vIIvmmtgMv3zUmOiNGD/
         F53tpTilLYaPdaGa4jY19AeU47XbnXyx+uGtcQ0U2p1OY3CD7hRbgn4Cr4bbj2MY2oJU
         Ohy0dzI6DitMSgeEZydbwp4kso5bsM20Qte2/QqDjmp3zLsyhVyVbtxppiAjMruZN55o
         kxMg==
X-Gm-Message-State: AOAM530kJHjevD/Ps7fWJjFr1Ypx6XuTzp+JX0eB3Y3xdDMIjZlL24/x
        CcIstcyqK49Am+mMkdNR9rQlAkwYSrAW147aU4kSmug2lrX8
X-Google-Smtp-Source: ABdhPJyeU8DkqIF0GIAqJjpYJ/sw6qESdwRLjSdqwsNzGKttk3AY6IVJEtNZINrukqwCYj/JUGPL43QYum6K0s/mcPlCKe9BD1xz
MIME-Version: 1.0
X-Received: by 2002:a02:aa87:: with SMTP id u7mr15098111jai.13.1598452703395;
 Wed, 26 Aug 2020 07:38:23 -0700 (PDT)
Date:   Wed, 26 Aug 2020 07:38:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009383f505adc8c5a0@google.com>
Subject: general protection fault in nexthop_is_blackhole
From:   syzbot <syzbot+b2c08a2f5cfef635cc3a@syzkaller.appspotmail.com>
To:     a@unstable.cc, andriin@fb.com, ast@kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        hariprasad.kelam@gmail.com, herbert@gondor.apana.org.au,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, songliubraving@fb.com,
        steffen.klassert@secunet.com, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c3d8f220 Merge tag 'kbuild-fixes-v5.9' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11c48c96900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bb68b9e8a8cc842f
dashboard link: https://syzkaller.appspot.com/bug?extid=b2c08a2f5cfef635cc3a
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d75e39900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12aea519900000

The issue was bisected to:

commit de47c5d8e11dda678e4354eeb4235e58e92f7cd2
Author: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Date:   Sat Jun 8 09:00:50 2019 +0000

    af_key: make use of BUG_ON macro

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10450972900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12450972900000
console output: https://syzkaller.appspot.com/x/log.txt?x=14450972900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b2c08a2f5cfef635cc3a@syzkaller.appspotmail.com
Fixes: de47c5d8e11d ("af_key: make use of BUG_ON macro")

IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
IPv6: NLM_F_CREATE should be set when creating new route
IPv6: NLM_F_CREATE should be set when creating new route
general protection fault, probably for non-canonical address 0xdffffc0000000010: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
CPU: 0 PID: 7050 Comm: syz-executor320 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nexthop_is_blackhole+0x145/0x250 include/net/nexthop.h:240
Code: 4d fa 49 83 c6 10 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 39 f0 8c fa 49 8b 1e 48 83 eb 80 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 1c f0 8c fa 48 8b 1b e8 e4 4e 02
RSP: 0018:ffffc900061172b8 EFLAGS: 00010202
RAX: 0000000000000010 RBX: 0000000000000080 RCX: ffff888091444300
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffffff8727dfc7 R09: ffffed1012299e09
R10: ffffed1012299e09 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880919da280 R14: ffff8880a9576610 R15: dffffc0000000000
FS:  0000000001a89880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000300 CR3: 00000000a7555000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rt6_fill_node+0xfe9/0x1f90 net/ipv6/route.c:5584
 inet6_rt_notify+0x2ab/0x500 net/ipv6/route.c:6017
 fib6_add_rt2node net/ipv6/ip6_fib.c:1246 [inline]
 fib6_add+0x203b/0x3bd0 net/ipv6/ip6_fib.c:1473
 __ip6_ins_rt net/ipv6/route.c:1317 [inline]
 ip6_route_add+0x84/0x120 net/ipv6/route.c:3744
 inet6_rtm_newroute+0x22f/0x2150 net/ipv6/route.c:5360
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2353
 ___sys_sendmsg net/socket.c:2407 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2440
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443ef9
Code: e8 8c 07 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd64ccd428 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443ef9
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000003
RBP: 00007ffd64ccd430 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000b6f1
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace e62dc7d3de715e59 ]---
RIP: 0010:nexthop_is_blackhole+0x145/0x250 include/net/nexthop.h:240
Code: 4d fa 49 83 c6 10 4c 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 39 f0 8c fa 49 8b 1e 48 83 eb 80 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 1c f0 8c fa 48 8b 1b e8 e4 4e 02
RSP: 0018:ffffc900061172b8 EFLAGS: 00010202
RAX: 0000000000000010 RBX: 0000000000000080 RCX: ffff888091444300
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
RBP: 0000000000000001 R08: ffffffff8727dfc7 R09: ffffed1012299e09
R10: ffffed1012299e09 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880919da280 R14: ffff8880a9576610 R15: dffffc0000000000
FS:  0000000001a89880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000300 CR3: 00000000a7555000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
