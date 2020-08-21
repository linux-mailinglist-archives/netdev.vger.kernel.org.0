Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A9A24CDBD
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgHUGK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:10:27 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:49539 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHUGKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:10:22 -0400
Received: by mail-il1-f199.google.com with SMTP id b18so744205ilh.16
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 23:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3ZnB5a3tpgDyN7grQLfqbblxbPXfFx3TmuXw4BeWbXQ=;
        b=j2Nqh+ycsFemF2D8WWjMnqo/evoSGju2T1bvoXJUoKOkmSeQHcrOmvu28UfZnQ+baO
         pe9lkS5eMpj3CiPrwZDOEiaCTmLMHtXLURH29ujJeDspYkQ7QcZ5EaaR+yV1YnBLXk26
         1JYmVJSI17W9avAumBb9tylDfKKhpGzB7XXeimHbAvI+PR7N4ESrHqD0l8AmMPTZ9y3C
         73oztDXmEi+Gf+57whj7KACBu0zFUmsAHEOOx7kjBszT29mT1xc3Szq+IfyJY0jIA51H
         TzJDTMkcgaQv3igy2HGQk5QaErOXnPkks/Krld40/MKPy7yA/8AxHQMkD6vOgxwNECfX
         72RA==
X-Gm-Message-State: AOAM532JSp7B2/NCO4C63SUO/Qiem1fgOO6MtXdxPV6xeIu7U/EoJmEm
        p+LjJ5LGZH69QQA64S2wAQMH22+b8Xzd1wgxV4MyKbqaOkWN
X-Google-Smtp-Source: ABdhPJzRz7hA92yUn57X/V5u8/XcJSsy3iMwucDRcRnGMuFScqnCouoR3Crct2jWsldzr3twh0+nvDHrav/zsyXDyOH/6pN39m42
MIME-Version: 1.0
X-Received: by 2002:a5e:9601:: with SMTP id a1mr1169661ioq.179.1597990221831;
 Thu, 20 Aug 2020 23:10:21 -0700 (PDT)
Date:   Thu, 20 Aug 2020 23:10:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000086e96005ad5d17a7@google.com>
Subject: general protection fault in fib_check_nexthop
From:   syzbot <syzbot+55a3e617aaf04b962a3e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    18445bf4 Merge tag 'spi-fix-v5.9-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=162cbd7a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=55a3e617aaf04b962a3e
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+55a3e617aaf04b962a3e@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000010: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
CPU: 0 PID: 3746 Comm: syz-executor.2 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:fib_check_nexthop+0x198/0x660 net/ipv4/nexthop.c:733
Code: 48 c1 ea 03 80 3c 02 00 0f 85 7b 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 10 48 8d bb 80 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 4b 04 00 00 48 8b 9b 80 00 00 00 48 b8 00 00 00
RSP: 0018:ffffc90017a0f308 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000cc16000
RDX: 0000000000000010 RSI: ffffffff86cbe7bd RDI: 0000000000000080
RBP: 000000000000008b R08: 0000000000000001 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90017a0f8a8
R13: 0000000000000001 R14: ffff8880a2bb7500 R15: ffffffff88ff41e0
FS:  0000000000000000(0000) GS:ffff8880ae600000(0063) knlGS:00000000f5535b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00007f2094027659 CR3: 000000020cbe4000 CR4: 00000000001506f0
DR0: 0000000020000080 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 fib_create_info+0x1ae8/0x49e0 net/ipv4/fib_semantics.c:1490
 fib_table_insert+0x1c7/0x1af0 net/ipv4/fib_trie.c:1189
 inet_rtm_newroute+0x109/0x1e0 net/ipv4/fib_frontend.c:883
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5563
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x57/0x80 arch/x86/entry/common.c:126
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f3b549
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f55350cc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 1afa7bb3bbb54c93 ]---
RIP: 0010:fib_check_nexthop+0x198/0x660 net/ipv4/nexthop.c:733
Code: 48 c1 ea 03 80 3c 02 00 0f 85 7b 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 10 48 8d bb 80 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 4b 04 00 00 48 8b 9b 80 00 00 00 48 b8 00 00 00
RSP: 0018:ffffc90017a0f308 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000cc16000
RDX: 0000000000000010 RSI: ffffffff86cbe7bd RDI: 0000000000000080
RBP: 000000000000008b R08: 0000000000000001 R09: 0000000000000003
R10: 0000000000000000 R11: 0000000000000001 R12: ffffc90017a0f8a8
R13: 0000000000000001 R14: ffff8880a2bb7500 R15: ffffffff88ff41e0
FS:  0000000000000000(0000) GS:ffff8880ae600000(0063) knlGS:00000000f5535b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00007f5c1af16000 CR3: 000000020cbe4000 CR4: 00000000001506f0
DR0: 0000000020000080 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
