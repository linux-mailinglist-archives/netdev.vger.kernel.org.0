Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220E6412D65
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 05:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhIUD00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 23:26:26 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41713 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353000AbhIUC5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 22:57:44 -0400
Received: by mail-io1-f72.google.com with SMTP id 142-20020a6b1494000000b005d324a4f7c9so37470477iou.8
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 19:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MNpadMHNgZjbL+VRdgzRTRIiaLJg27YWyIUZKCU8PDs=;
        b=iXwwU/xe404ssbraHwEwetzvWQRbqz4ARxKZmeabIxw2dRykoAAOr/ut7ULu5NrjeO
         Bbrtr+HobM8otmiKRV0jhMyB5DpyNOorN932ocw1GK/hUp4yuPNUGd8dAyeBDgDqxL+3
         A2eUHvakjLqFKmpVJ5fGnnzpWnIjOWLvJMT6Q2lAIRZaTRvvgonVMd6q3hu8dE8KoW0B
         TIC5BtV3zQAyehbwjKHK5ym5JBv5jneJChWCYkyudiiSLPT58UTob+piLz+FuB/TcYzF
         +WbrYX4ChrSw8hF6OWRI9nNi3LnvEXkhscXIRNuVmOrdfhwawI49w7ZWSkwNKBI9JrVb
         /ipg==
X-Gm-Message-State: AOAM533MPyyJWrSjoZ6PVTneYTTPWfx8r37zdi78Vhi7wMbgXcufhcTK
        7Yhn9n9yzTWVCJyHHCIsMEt7XkNqQdIa6D7JP96UsdXkK2v+
X-Google-Smtp-Source: ABdhPJzFElshIctAq247vtysjG+pyJtpXZZ/wOxOpzGbONGpgTNUb5NF2MHpKQSxm3n1vcSiwDCoYNJorvbRQwcecfroXErtUPAo
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:134e:: with SMTP id k14mr19895623ilr.39.1632192977063;
 Mon, 20 Sep 2021 19:56:17 -0700 (PDT)
Date:   Mon, 20 Sep 2021 19:56:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a53cd05cc788a95@google.com>
Subject: [syzbot] general protection fault in sctp_rcv
From:   syzbot <syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    98dc68f8b0c2 selftests: nci: replace unsigned int with int
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11fd443d300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
dashboard link: https://syzkaller.appspot.com/bug?extid=581aff2ae6b860625116
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+581aff2ae6b860625116@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 11205 Comm: kworker/0:12 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
RIP: 0010:sctp_rcv+0x1d84/0x3220 net/sctp/input.c:196
Code: fb 03 0f 8e 51 01 00 00 e8 99 ac 17 f9 4c 01 ed e8 91 ac 17 f9 48 8d 7d 02 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <0f> b6 14 08 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 ea
RSP: 0018:ffffc900000079c8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: dffffc0000000000
RDX: ffff88803d790000 RSI: ffffffff885e62cf RDI: 0000000000000002
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff885e6448 R11: 0000000000000000 R12: 000000000000050c
R13: ffff88803f42a0e4 R14: 0000000000000510 R15: ffff888070e2c500
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0dce1763ad CR3: 0000000027250000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 sctp6_rcv+0x38/0x60 net/sctp/ipv6.c:1109
 ip6_protocol_deliver_rcu+0x2e9/0x1ca0 net/ipv6/ip6_input.c:422
 ip6_input_finish+0x62/0x170 net/ipv6/ip6_input.c:463
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0x9c/0xd0 net/ipv6/ip6_input.c:472
 dst_input include/net/dst.h:460 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:76 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0x28c/0x3c0 net/ipv6/ip6_input.c:297
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5436
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5550
 process_backlog+0x2a5/0x6c0 net/core/dev.c:6427
 __napi_poll+0xaf/0x440 net/core/dev.c:6982
 napi_poll net/core/dev.c:7049 [inline]
 net_rx_action+0x801/0xb40 net/core/dev.c:7136
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 do_softirq.part.0+0xde/0x130 kernel/softirq.c:459
 </IRQ>
 do_softirq kernel/softirq.c:451 [inline]
 __local_bh_enable_ip+0x102/0x120 kernel/softirq.c:383
 spin_unlock_bh include/linux/spinlock.h:408 [inline]
 addrconf_dad_work+0x474/0x1340 net/ipv6/addrconf.c:4077
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 80d76c5102c944b0 ]---
RIP: 0010:sctp_rcv_ootb net/sctp/input.c:705 [inline]
RIP: 0010:sctp_rcv+0x1d84/0x3220 net/sctp/input.c:196
Code: fb 03 0f 8e 51 01 00 00 e8 99 ac 17 f9 4c 01 ed e8 91 ac 17 f9 48 8d 7d 02 48 b9 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 <0f> b6 14 08 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 ea
RSP: 0018:ffffc900000079c8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: dffffc0000000000
RDX: ffff88803d790000 RSI: ffffffff885e62cf RDI: 0000000000000002
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff885e6448 R11: 0000000000000000 R12: 000000000000050c
R13: ffff88803f42a0e4 R14: 0000000000000510 R15: ffff888070e2c500
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0dce1763ad CR3: 0000000027250000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	fb                   	sti
   1:	03 0f                	add    (%rdi),%ecx
   3:	8e 51 01             	mov    0x1(%rcx),%ss
   6:	00 00                	add    %al,(%rax)
   8:	e8 99 ac 17 f9       	callq  0xf917aca6
   d:	4c 01 ed             	add    %r13,%rbp
  10:	e8 91 ac 17 f9       	callq  0xf917aca6
  15:	48 8d 7d 02          	lea    0x2(%rbp),%rdi
  19:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  20:	fc ff df
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 14 08          	movzbl (%rax,%rcx,1),%edx <-- trapping instruction
  2e:	48 89 f8             	mov    %rdi,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 01             	add    $0x1,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85 ea                	test   %ebp,%edx


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
