Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D76437F44
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhJVUW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:22:26 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:44743 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233417AbhJVUW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 16:22:26 -0400
Received: by mail-il1-f199.google.com with SMTP id k11-20020a92c24b000000b00259faad3693so2365430ilo.11
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 13:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6SshvQoAb1qCnuZwFL8aCZKQBiGLMPXUkOLXN32/nLs=;
        b=hEyFjLQnuTYIarP4VdCJ3dKRAKZJ/OPFlG68Imfzvq0Rd5Yh2Uf+Ed1tG5I9aGMwKO
         IZzhBHez022sdl0kbLN3Lgmf6hLO1MUZvcUZgS1IDt5+XsvDOonudG3bhLmrgx8397Vc
         23wzkejdXQZ0/G/M63VAtQT5u0jOxyj2K8345vj6CPSEMLouZ1EEyH1lo7KTdv1Bbg+/
         BtTxI93uIBj/RQNtyV1pJDPPPB+k1tpSBqsO2Jn1ezetcp8J+2qSsFPJm1hP+ePHJFZp
         QXIFV/Ua3DMrKjc0TEt0AAQefbllA3nR/+By+rb73K/rHFFtd8dadExmVN8h7O5o8OX/
         yetQ==
X-Gm-Message-State: AOAM530v2q3G8mYQcLs5ogIj8TrHpEeIcSahl4QbpjGs0Wa5bVmKMX+s
        bLwf+Mg0MXrk/xNQPv8jH9fWFpCtXBhxpc0n6PIxE/6gOoGa
X-Google-Smtp-Source: ABdhPJzXIEwLNIKuCGZS1MPOtRtv3TaniSIjoqCwG7uF1DKFgmGmgvhXCPQ1RvIMxaGC7zCWTkQFb8xqAiXDKWcJchonDNWj4YuB
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1689:: with SMTP id f9mr1330382ila.216.1634934008084;
 Fri, 22 Oct 2021 13:20:08 -0700 (PDT)
Date:   Fri, 22 Oct 2021 13:20:08 -0700
In-Reply-To: <b792adc1-ebf2-d0f7-4007-ed5c99ec3f79@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c87fbd05cef6bcb0@google.com>
Subject: Re: [syzbot] WARNING in batadv_nc_mesh_free
From:   syzbot <syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        paskripkin@gmail.com, sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
general protection fault in batadv_nc_purge_paths

RBP: 00007fe7b40631d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ffe7ffd3def R14: 00007fe7b4063300 R15: 0000000000022000
general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 9061 Comm: syz-executor.0 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:batadv_nc_purge_paths+0x38/0x3f0 net/batman-adv/network-coding.c:437
Code: 48 89 d3 49 89 f6 48 89 7c 24 58 49 bd 00 00 00 00 00 fc ff df e8 38 48 ab f7 4d 8d 7e 10 4c 89 f8 48 c1 e8 03 48 89 44 24 48 <42> 8a 04 28 84 c0 0f 85 88 03 00 00 41 8b 2f 31 ff 89 ee e8 20 4c
RSP: 0018:ffffc9000d04eac0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffff888078270000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88807ec2cc80
RBP: 00000000fffffff4 R08: ffffffff8154e5b4 R09: ffffed100fd85adc
R10: ffffed100fd85adc R11: 0000000000000000 R12: ffff88807ec2cc80
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000010
FS:  00007fe7b4063700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f359172e000 CR3: 000000005e749000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 batadv_nc_mesh_free+0x7a/0xf0 net/batman-adv/network-coding.c:1869
 batadv_mesh_free+0x6f/0x140 net/batman-adv/main.c:249
 batadv_mesh_init+0x5b1/0x620 net/batman-adv/main.c:230
 batadv_softif_init_late+0x8fe/0xd70 net/batman-adv/soft-interface.c:804
 register_netdevice+0x826/0x1c30 net/core/dev.c:10229
 __rtnl_newlink net/core/rtnetlink.c:3458 [inline]
 rtnl_newlink+0x14b3/0x1d10 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x934/0xe60 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x200/0x470 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x814/0x9f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xa29/0xe50 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x5b9/0x910 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x36f/0x450 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe7b48eda39
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe7b4063188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe7b49f0f60 RCX: 00007fe7b48eda39
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007fe7b40631d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ffe7ffd3def R14: 00007fe7b4063300 R15: 0000000000022000
Modules linked in:
---[ end trace 67ff054734964acf ]---
RIP: 0010:batadv_nc_purge_paths+0x38/0x3f0 net/batman-adv/network-coding.c:437
Code: 48 89 d3 49 89 f6 48 89 7c 24 58 49 bd 00 00 00 00 00 fc ff df e8 38 48 ab f7 4d 8d 7e 10 4c 89 f8 48 c1 e8 03 48 89 44 24 48 <42> 8a 04 28 84 c0 0f 85 88 03 00 00 41 8b 2f 31 ff 89 ee e8 20 4c
RSP: 0018:ffffc9000d04eac0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffff888078270000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88807ec2cc80
RBP: 00000000fffffff4 R08: ffffffff8154e5b4 R09: ffffed100fd85adc
R10: ffffed100fd85adc R11: 0000000000000000 R12: ffff88807ec2cc80
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000010
FS:  00007fe7b4063700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc230f87020 CR3: 000000005e749000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 89 d3             	mov    %rdx,%rbx
   3:	49 89 f6             	mov    %rsi,%r14
   6:	48 89 7c 24 58       	mov    %rdi,0x58(%rsp)
   b:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
  12:	fc ff df
  15:	e8 38 48 ab f7       	callq  0xf7ab4852
  1a:	4d 8d 7e 10          	lea    0x10(%r14),%r15
  1e:	4c 89 f8             	mov    %r15,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
  25:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
* 2a:	42 8a 04 28          	mov    (%rax,%r13,1),%al <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 88 03 00 00    	jne    0x3be
  36:	41 8b 2f             	mov    (%r15),%ebp
  39:	31 ff                	xor    %edi,%edi
  3b:	89 ee                	mov    %ebp,%esi
  3d:	e8                   	.byte 0xe8
  3e:	20                   	.byte 0x20
  3f:	4c                   	rex.WR


Tested on:

commit:         1d4590f5 Merge tag 'acpi-5.15-rc7' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=156e86c4b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d95853dad8472c91
dashboard link: https://syzkaller.appspot.com/bug?extid=28b0702ada0bf7381f58
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16cb3daf300000

