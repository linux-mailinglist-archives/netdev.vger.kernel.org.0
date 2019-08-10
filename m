Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D95889FF
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 10:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfHJIXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 04:23:07 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:53283 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfHJIXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 04:23:07 -0400
Received: by mail-ot1-f72.google.com with SMTP id e42so11861164ote.20
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 01:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rIXIyTJARyxtmRDZDoT39wtyBZEK6odHTxuOIuF1HZ0=;
        b=RF2a+M5KDagP+EjshNKEa23+/Nz2nYu7JEKYmrxAZQDIz8LKu7eCAL61w3xmAtAcgz
         b2F0WwJQYWfuv/ovsgRvNOFSAWmOY/oUnktiNwUe4T9WZQMYp+e2AXkRRxHbx34rbS9I
         VV9suQHjgptu9CpBm/Iudo22qVuGfFBWoisl4qiiiHK+Z3SXMX9AttbnBc3t5p9O2e0b
         yoWr+26p++49a2T7D8qU+YRm0nOeURQNLXhKYrhuNrS1depZVUu2cH6q8GzF1P7iShzm
         JeKaRu7guS9/p/TCI0+RBrZR18vGTZfpSfog/Ima++1tpry85/3sRapc9GDyOeOJTK9T
         SZjw==
X-Gm-Message-State: APjAAAXCoR+iyEPEkkRaRgyr35tzBdV88M0TGuVMRHrt+HhHVejtKJkb
        3GmmqTd7FSFrjwu0yMfQd3cd9MfwHt6ovqe/2nld5p1ibhj8
X-Google-Smtp-Source: APXvYqwLWB4ivAgYPxo7L1Xbewd13PN/ZxqH6UxrP8wBDVkHjlDYgro6e6wHnW1roJSSbc+8gMtnUgtnespzDgL6QlGqMXgAJgju
MIME-Version: 1.0
X-Received: by 2002:a5e:9319:: with SMTP id k25mr26750905iom.137.1565425386362;
 Sat, 10 Aug 2019 01:23:06 -0700 (PDT)
Date:   Sat, 10 Aug 2019 01:23:06 -0700
In-Reply-To: <000000000000f5d619058faea744@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000139ca6058fbf000d@google.com>
Subject: Re: general protection fault in tls_write_space
From:   syzbot <syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, syzkaller-bugs@googlegroups.com,
        willemb@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    ca497fb6 taprio: remove unused variable 'entry_list_policy'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=109f3802600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=dcdc9deefaec44785f32
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c78cd2600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.3.0-rc3+ #125
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_write_space+0x51/0x170 net/tls/tls_main.c:239
Code: c1 ea 03 80 3c 02 00 0f 85 26 01 00 00 49 8b 9c 24 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 48 8d 7b 6a 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 df 00 00 00
RSP: 0018:ffff8880a98b74c8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff860a27a2
RDX: 000000000000000d RSI: ffffffff862c86c1 RDI: 000000000000006a
RBP: ffff8880a98b74e0 R08: ffff8880a98a2240 R09: fffffbfff167c289
R10: fffffbfff167c288 R11: ffffffff8b3e1447 R12: ffff8880a4de41c0
R13: ffff8880a4de45b8 R14: 000000000000000a R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000008c9d1000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  tcp_new_space net/ipv4/tcp_input.c:5151 [inline]
  tcp_check_space+0x191/0x760 net/ipv4/tcp_input.c:5162
  tcp_data_snd_check net/ipv4/tcp_input.c:5172 [inline]
  tcp_rcv_state_process+0xe24/0x4e48 net/ipv4/tcp_input.c:6303
  tcp_v6_do_rcv+0x7d7/0x12c0 net/ipv6/tcp_ipv6.c:1381
  tcp_v6_rcv+0x31f1/0x3500 net/ipv6/tcp_ipv6.c:1588
  ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
  dst_input include/net/dst.h:442 [inline]
  ip6_rcv_finish+0x1de/0x2f0 net/ipv6/ip6_input.c:76
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:272
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5006
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5120
  process_backlog+0x206/0x750 net/core/dev.c:5951
  napi_poll net/core/dev.c:6388 [inline]
  net_rx_action+0x4d6/0x1080 net/core/dev.c:6456
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa40 kernel/smpboot.c:165
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace c21a83505707bb9d ]---
RIP: 0010:tls_write_space+0x51/0x170 net/tls/tls_main.c:239
Code: c1 ea 03 80 3c 02 00 0f 85 26 01 00 00 49 8b 9c 24 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 48 8d 7b 6a 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 df 00 00 00
RSP: 0018:ffff8880a98b74c8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff860a27a2
RDX: 000000000000000d RSI: ffffffff862c86c1 RDI: 000000000000006a
RBP: ffff8880a98b74e0 R08: ffff8880a98a2240 R09: fffffbfff167c289
R10: fffffbfff167c288 R11: ffffffff8b3e1447 R12: ffff8880a4de41c0
R13: ffff8880a4de45b8 R14: 000000000000000a R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000008c9d1000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

