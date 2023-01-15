Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85FEB66B432
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 22:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbjAOVhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 16:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjAOVhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 16:37:50 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE75F1632E
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 13:37:49 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id g1-20020a92cda1000000b0030c45d93884so19961547ild.16
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 13:37:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PLEpgIlvPw7WxI7ytYdPSjPCe7tP60vgxJqkhS7/ozs=;
        b=XYRG8f3usigIuVRadlJjgxxfo1Dl5Pppp66wyfPv3DnDLzV3yzJcoeT+Bx6CQxiP7V
         yA6FkwKOf4UUGd+P1SEw/nv2gqaLOw9IJG0731s/G6YTwXZ5sR3IYjkPqlp7/RKCuf3H
         sAlSEevLFqn7YUJrdMXWrpUtKHoXGXANDjULIOq2EcE4vGpBfBvvSpG336CyqHNeHi6d
         u+GdRtdxuZxo9hzdJYUUo+263YDp/iP2fIkZTQwhmJN74Ki6hcRnqP1TU3vAr6hvUkmG
         CMcpxrIpXhxCkjOEmVAl2J5zF5NVCpbO4gwQVhKShKWT9rPq2l7VNssnenWwYoSjxvJr
         85sQ==
X-Gm-Message-State: AFqh2kpP3Pg3c1ayYJF+y2Ganu92zQw32jF+AzbPO13daYEg4Hq67/Th
        b/mdS7/xln+Kyxo6Xu+1ltJ7C9LRD9RzQis4x3WrJhc8aofG
X-Google-Smtp-Source: AMrXdXtcr5JjMID/aHecsKRargTD4KUWjxTkU8oGxtFZ3UM7BP0nEliyPWJeq3YS4DomfhzynA8aaEJCaRQqSWaUyokMs1SHQyjk
MIME-Version: 1.0
X-Received: by 2002:a05:6638:206:b0:3a3:f593:9509 with SMTP id
 e6-20020a056638020600b003a3f5939509mr318098jaq.142.1673818669102; Sun, 15 Jan
 2023 13:37:49 -0800 (PST)
Date:   Sun, 15 Jan 2023 13:37:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030c20305f2544773@google.com>
Subject: [syzbot] general protection fault in ethnl_set_plca_cfg
From:   syzbot <syzbot+8cf35743af243e5f417e@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        piergiorgio.beruto@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    60d86034b14e Merge tag 'mlx5-updates-2023-01-10' of git://..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12582c02480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de2f853811ba4e08
dashboard link: https://syzkaller.appspot.com/bug?extid=8cf35743af243e5f417e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1773adf2480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140bc05e480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b5b394a217aa/disk-60d86034.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f129c2da4b3a/vmlinux-60d86034.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6dbc96a4303d/bzImage-60d86034.xz

The issue was bisected to:

commit 8580e16c28f3f1a1bee87de115157161577334b4
Author: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Date:   Mon Jan 9 16:59:39 2023 +0000

    net/ethtool: add netlink interface for the PLCA RS

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10fde136480000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12fde136480000
console output: https://syzkaller.appspot.com/x/log.txt?x=14fde136480000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8cf35743af243e5f417e@syzkaller.appspotmail.com
Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")

general protection fault, probably for non-canonical address 0xdffffc0000000173: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000b98-0x0000000000000b9f]
CPU: 1 PID: 5067 Comm: syz-executor355 Not tainted 6.2.0-rc2-syzkaller-00378-g60d86034b14e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:ethnl_set_plca_cfg+0x1c5/0x810 net/ethtool/plca.c:162
Code: 28 7a f9 4c 8b 7c 24 58 e8 d8 17 c6 ff 49 8d 87 98 0b 00 00 48 89 c2 48 89 44 24 08 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 7d 05 00 00 49 83 bf 98 0b 00 00 00 0f 84 b8 04
RSP: 0018:ffffc90003cbf470 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffffc90003cbf5d8 RCX: 0000000000000000
RDX: 0000000000000173 RSI: 0000000000000002 RDI: 0000000000000001
RBP: 1ffff92000797e95 R08: 0000000000000000 R09: ffffffff8e72e917
R10: fffffbfff1ce5d22 R11: 0000000000000000 R12: 00000000ffffffea
R13: ffff88801cc43980 R14: ffffc90003cbf618 R15: 0000000000000000
FS:  00005555563b5300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001ac0 CR3: 000000007d808000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fb1764e4ae9
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd5160add8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb1764e4ae9
RDX: 0000000000000000 RSI: 0000000020001ac0 RDI: 0000000000000003
RBP: 00007fb1764a84b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb1764a8540
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ethnl_set_plca_cfg+0x1c5/0x810 net/ethtool/plca.c:162
Code: 28 7a f9 4c 8b 7c 24 58 e8 d8 17 c6 ff 49 8d 87 98 0b 00 00 48 89 c2 48 89 44 24 08 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 7d 05 00 00 49 83 bf 98 0b 00 00 00 0f 84 b8 04
RSP: 0018:ffffc90003cbf470 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffffc90003cbf5d8 RCX: 0000000000000000
RDX: 0000000000000173 RSI: 0000000000000002 RDI: 0000000000000001
RBP: 1ffff92000797e95 R08: 0000000000000000 R09: ffffffff8e72e917
R10: fffffbfff1ce5d22 R11: 0000000000000000 R12: 00000000ffffffea
R13: ffff88801cc43980 R14: ffffc90003cbf618 R15: 0000000000000000
FS:  00005555563b5300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001ac0 CR3: 000000007d808000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	28 7a f9             	sub    %bh,-0x7(%rdx)
   3:	4c 8b 7c 24 58       	mov    0x58(%rsp),%r15
   8:	e8 d8 17 c6 ff       	callq  0xffc617e5
   d:	49 8d 87 98 0b 00 00 	lea    0xb98(%r15),%rax
  14:	48 89 c2             	mov    %rax,%rdx
  17:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  23:	fc ff df
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 7d 05 00 00    	jne    0x5b1
  34:	49 83 bf 98 0b 00 00 	cmpq   $0x0,0xb98(%r15)
  3b:	00
  3c:	0f                   	.byte 0xf
  3d:	84                   	.byte 0x84
  3e:	b8                   	.byte 0xb8
  3f:	04                   	.byte 0x4


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
