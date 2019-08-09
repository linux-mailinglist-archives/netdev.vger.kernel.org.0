Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4FC87A8A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406835AbfHIMxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:53:10 -0400
Received: from mail-ot1-f70.google.com ([209.85.210.70]:55124 "EHLO
        mail-ot1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406703AbfHIMxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:53:09 -0400
Received: by mail-ot1-f70.google.com with SMTP id h26so68633137otr.21
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 05:53:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JNReoEcsph/0UXEg1aDjN5IpcRuZ2wM+GdC190mT1EU=;
        b=IPTTTNI4nrtG8S9vJIH/n7oTEATJ/ZEO++oDgaAYiqlie7miaPcAY97hapo+1OHjwX
         GWhGnc6dERNSpYPQCEI4397Kt+UmzdxrZZ+X7ITrLChD7Qcxx+cvP18+E9KoBhDSAK/0
         FwFTbv+B23ADd0U+4/vCzlIk5i6/UlnU0/5/EctM8SunqkKEFZdif3xKWBvFrkW9/cJx
         BLUQv8B7KalT+UMwdBi1WqeZrNh7MFMYRSwUicSNNJ7hXLr20E+kz6i38yUhZh7ktKvo
         eUkcZM7eyZ3E2g67Ze9ebbTZlfyKsKTV6UU8QiEin7GJsd4n1MjLU1z6uev5W4mjQn8P
         DrpA==
X-Gm-Message-State: APjAAAVr5uuocH3TigattfPiNBmwi+XrVco/QMyuzHZ315cnrr4ptBWB
        0b54MpZinQypWoUogF4UkD1TE5Qw95sBTH+JRwUyU3VcERHs
X-Google-Smtp-Source: APXvYqzt8ifCAhih9ylYZzHSFyuxgWWWpcH+pLJn/1auZOspN9F8btt++wijlN7zUa5Wd2Ua45Mz4ynMKyNzqD3CVxWoiqj/Ap/Y
MIME-Version: 1.0
X-Received: by 2002:a02:c95a:: with SMTP id u26mr7266966jao.15.1565355188538;
 Fri, 09 Aug 2019 05:53:08 -0700 (PDT)
Date:   Fri, 09 Aug 2019 05:53:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5d619058faea744@google.com>
Subject: general protection fault in tls_write_space
From:   syzbot <syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ecb095bf Merge tag 'hwmon-for-v5.3-rc4' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11cbde8c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=dcdc9deefaec44785f32
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 2347 Comm: syz-executor.1 Not tainted 5.3.0-rc3+ #102
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_write_space+0x51/0x170 net/tls/tls_main.c:239
Code: c1 ea 03 80 3c 02 00 0f 85 26 01 00 00 49 8b 9c 24 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 48 8d 7b 6a 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 df 00 00 00
RSP: 0018:ffff8880ae809710 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8609fdb2
RDX: 000000000000000d RSI: ffffffff862c5d11 RDI: 000000000000006a
RBP: ffff8880ae809728 R08: ffff8880918ba380 R09: fffffbfff167c089
R10: fffffbfff167c088 R11: ffffffff8b3e0447 R12: ffff888054ac86c0
R13: ffff888054ac8ab8 R14: 000000000000000a R15: 0000000000000000
FS:  00007ff8afb76700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f345c622000 CR3: 00000000a86a2000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  tcp_new_space net/ipv4/tcp_input.c:5151 [inline]
  tcp_check_space+0x191/0x760 net/ipv4/tcp_input.c:5162
  tcp_data_snd_check net/ipv4/tcp_input.c:5172 [inline]
  tcp_rcv_established+0x9c1/0x1e70 net/ipv4/tcp_input.c:5663
  tcp_v6_do_rcv+0x41e/0x12c0 net/ipv6/tcp_ipv6.c:1356
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
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:5004
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5118
  process_backlog+0x206/0x750 net/core/dev.c:5929
  napi_poll net/core/dev.c:6352 [inline]
  net_rx_action+0x4d6/0x1030 net/core/dev.c:6418
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
  </IRQ>
  do_softirq.part.0+0x11a/0x170 kernel/softirq.c:337
  do_softirq kernel/softirq.c:329 [inline]
  __local_bh_enable_ip+0x211/0x270 kernel/softirq.c:189
  __raw_spin_unlock_bh include/linux/spinlock_api_smp.h:176 [inline]
  _raw_spin_unlock_bh+0x31/0x40 kernel/locking/spinlock.c:207
  spin_unlock_bh include/linux/spinlock.h:383 [inline]
  release_sock+0x156/0x1c0 net/core/sock.c:2945
  tls_sk_proto_close+0x277/0x910 net/tls/tls_main.c:312
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x92f/0x2e50 kernel/exit.c:879
  do_group_exit+0x135/0x360 kernel/exit.c:983
  get_signal+0x47c/0x2500 kernel/signal.c:2729
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ff8afb75c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: 0000000000270000 RBX: 0000000000000006 RCX: 0000000000459829
RDX: ffffffffffffffc1 RSI: 00000000200005c0 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 1201000000003618
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ff8afb766d4
R13: 00000000004c77d9 R14: 00000000004dcfb0 R15: 00000000ffffffff
Modules linked in:
---[ end trace 1184b216e3fb01b5 ]---
RIP: 0010:tls_write_space+0x51/0x170 net/tls/tls_main.c:239
Code: c1 ea 03 80 3c 02 00 0f 85 26 01 00 00 49 8b 9c 24 b0 06 00 00 48 b8  
00 00 00 00 00 fc ff df 48 8d 7b 6a 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48  
89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 df 00 00 00
RSP: 0018:ffff8880ae809710 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8609fdb2
RDX: 000000000000000d RSI: ffffffff862c5d11 RDI: 000000000000006a
RBP: ffff8880ae809728 R08: ffff8880918ba380 R09: fffffbfff167c089
R10: fffffbfff167c088 R11: ffffffff8b3e0447 R12: ffff888054ac86c0
R13: ffff888054ac8ab8 R14: 000000000000000a R15: 0000000000000000
FS:  00007ff8afb76700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f345c622000 CR3: 00000000a86a2000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
