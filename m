Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE8D40F291
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 08:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhIQGnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 02:43:39 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:35439 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbhIQGni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 02:43:38 -0400
Received: by mail-io1-f72.google.com with SMTP id g14-20020a6be60e000000b005b62a0c2a41so18673001ioh.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 23:42:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FaoZno129C8GFyBk4ix5P7D2itiXjSt/ZhFzhqspXr0=;
        b=hCXmFQ4A5GX9zWHekHeVoV3JrEW4uIAeFlc5A8IxKWEa+iXeI6ApIj5VGCkoa+dl4Q
         qLuDvDZvbTEDpHQZx2hnCvVM86rmb8PVvkzAwbgJYPNlPR1eukCGSKExLEZrftPBwsJh
         6pmejPNbdbPTgoGfRHfpFzKPmAsVCCA+TCBlR0qBZeShHvE5Cbl4sJ+MEksYWY+DXQ7f
         MM9NdFjZMDUHvb44+LFWMgy4TcRFjwTvm1dYtnbBdvId8Ma9IwO42SL/L25ilGuEIIUS
         YfLxrRuUXjDxyUtsTJ29SY3co91uWfWuiHXtV+SWaeiXoX1vT2tVYQWEFxbaOQhCXu6O
         r4Zw==
X-Gm-Message-State: AOAM5301rvbV0sVg02DbYdfQ4uf1pdxxJDXllvwDNjEfctMyfJq8ixfs
        sSY3iBVJ1khGz9i0Z47WEK5h+4dGjhDv9zHFoUIn3U9KMH+g
X-Google-Smtp-Source: ABdhPJxYipYPUKmwSZFF6pKrMTMgbtGQPFKjFsL3O0DEo81+zy8JktxXTubKF0jVhkROzIbD0jE4ktGOzqVGZJwzBg2rHEp+dSID
MIME-Version: 1.0
X-Received: by 2002:a92:2a10:: with SMTP id r16mr6775041ile.309.1631860936501;
 Thu, 16 Sep 2021 23:42:16 -0700 (PDT)
Date:   Thu, 16 Sep 2021 23:42:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007171a105cc2b3b92@google.com>
Subject: [syzbot] general protection fault in nf_tables_dump_rules
From:   syzbot <syzbot+bd637e7821f7afda67c4@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    78e709522d2c Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=170ed963300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2150ebd7e72fa695
dashboard link: https://syzkaller.appspot.com/bug?extid=bd637e7821f7afda67c4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bd637e7821f7afda67c4@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xfbd59c000000005a: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead0000000002d0-0xdead0000000002d7]
CPU: 1 PID: 6020 Comm: syz-executor.5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nf_tables_dump_rules+0x52f/0xbc0 net/netfilter/nf_tables_api.c:3015
Code: 4c 8b 28 4d 85 ed 0f 84 65 01 00 00 e8 3a 0e 07 fa 49 8d bc 24 d0 01 00 00 48 be 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 30 00 0f 85 d2 05 00 00 49 8b b4 24 d0 01 00 00 4c 89 ef e8
RSP: 0018:ffffc9000c897128 EFLAGS: 00010a06
RAX: 1bd5a0000000005a RBX: ffff88807913cc00 RCX: ffffc90018d44000
RDX: 0000000000040000 RSI: dffffc0000000000 RDI: dead0000000002d0
RBP: ffff88803ace5548 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff876efd52 R11: 0000000000000000 R12: dead000000000100
R13: ffff88806e74adc0 R14: ffff88801c078a00 R15: ffff88803ace55c8
FS:  00007f5c96649700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2fc22000 CR3: 000000007c8d6000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2278
 __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2383
 netlink_dump_start include/linux/netlink.h:258 [inline]
 nft_netlink_dump_start_rcu+0x83/0x1c0 net/netfilter/nf_tables_api.c:859
 nf_tables_getrule+0x76b/0x8d0 net/netfilter/nf_tables_api.c:3119
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5c96649188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 0000000020000480 RDI: 0000000000000005
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 0000000000a9fb1f R14: 00007f5c96649300 R15: 0000000000022000
Modules linked in:
---[ end trace 1944f3a07850fa30 ]---
RIP: 0010:nf_tables_dump_rules+0x52f/0xbc0 net/netfilter/nf_tables_api.c:3015
Code: 4c 8b 28 4d 85 ed 0f 84 65 01 00 00 e8 3a 0e 07 fa 49 8d bc 24 d0 01 00 00 48 be 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <80> 3c 30 00 0f 85 d2 05 00 00 49 8b b4 24 d0 01 00 00 4c 89 ef e8
RSP: 0018:ffffc9000c897128 EFLAGS: 00010a06
RAX: 1bd5a0000000005a RBX: ffff88807913cc00 RCX: ffffc90018d44000
RDX: 0000000000040000 RSI: dffffc0000000000 RDI: dead0000000002d0
RBP: ffff88803ace5548 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff876efd52 R11: 0000000000000000 R12: dead000000000100
R13: ffff88806e74adc0 R14: ffff88801c078a00 R15: ffff88803ace55c8
FS:  00007f5c96649700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005605fa2f23d8 CR3: 000000007c8d6000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	4c 8b 28             	mov    (%rax),%r13
   3:	4d 85 ed             	test   %r13,%r13
   6:	0f 84 65 01 00 00    	je     0x171
   c:	e8 3a 0e 07 fa       	callq  0xfa070e4b
  11:	49 8d bc 24 d0 01 00 	lea    0x1d0(%r12),%rdi
  18:	00
  19:	48 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%rsi
  20:	fc ff df
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1) <-- trapping instruction
  2e:	0f 85 d2 05 00 00    	jne    0x606
  34:	49 8b b4 24 d0 01 00 	mov    0x1d0(%r12),%rsi
  3b:	00
  3c:	4c 89 ef             	mov    %r13,%rdi
  3f:	e8                   	.byte 0xe8


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
