Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149BD7628D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfGZJ2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:28:06 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:47476 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfGZJ2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:28:06 -0400
Received: by mail-io1-f70.google.com with SMTP id r27so58067180iob.14
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 02:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=N6WhCKShM4LNQj7FFoXGbLqE7BK2p7Oc3KCbLQcERuo=;
        b=FQaChnaEC5+bdkKACieMXtP8vu8BnosBPQZulnUJNQ22YVCXUhnwYsnTzlXJvZKb8p
         p80WYAoTs0SM6Lo98CXinq+WAw0Y32JdOz7yx7ip5WPks2jJzkmKmpDhEndbG9ww7DyM
         KahenUk4e5v5D2uFrx/dUHLKSEQrs+P40Htki0px/3OQ3lPJZU/qLBR5L4qqDCLsxv+f
         EaFRGoP0BQr3diHIpCuRkgc67IUCA9TMbR3UDkIiGLZ3TrndiVYOKApJQtAdzj4YG8Tw
         JCDB14fs6C04PcKiEiMeBPVgOXqWPPBY3OMSHnceNqk/8OppTw5P1IIaDd+E8KzCB4Lh
         LVFg==
X-Gm-Message-State: APjAAAWcp8xWT/5Kcq7U1z/FiEo3S4umnTvABRRY5bsPLxF7nKwW7Y0m
        9sJNcZ744n4fX+z1k98lTAJARab+csOr/0LHaNDfNDWngwo9
X-Google-Smtp-Source: APXvYqyxxW+mlSyxlEitOMyN9HQFiD4Y3xK5ypEcIatqjfP5trCTyOhnKeYAq6SoHlRrRf0Zr4kK/rctAqNXHkQGviXQWfFMt/30
MIME-Version: 1.0
X-Received: by 2002:a5d:8404:: with SMTP id i4mr16679815ion.146.1564133285421;
 Fri, 26 Jul 2019 02:28:05 -0700 (PDT)
Date:   Fri, 26 Jul 2019 02:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dbe98e058e92286d@google.com>
Subject: general protection fault in tls_sk_proto_close
From:   syzbot <syzbot+fb2a31b9c0676ea410e3@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    9e6dfe80 Add linux-next specific files for 20190724
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11ff2594600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cbb8fc2cf2842d7
dashboard link: https://syzkaller.appspot.com/bug?extid=fb2a31b9c0676ea410e3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13eb6a7c600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fb2a31b9c0676ea410e3@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9180 Comm: syz-executor.0 Not tainted 5.3.0-rc1-next-20190724  
#50
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_sk_proto_close+0x90/0x4a0 net/tls/tls_main.c:348
Code: 3c 02 00 0f 85 dd 03 00 00 49 8b 84 24 c0 02 00 00 4d 8d 75 14 4c 89  
f2 48 c1 ea 03 48 89 45 b8 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c  
89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 67 03 00 00
RSP: 0018:ffff8880a6497c70 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 00000000fffffff0 RCX: ffffffff8629731c
RDX: 0000000000000002 RSI: ffffffff862970cd RDI: ffff88808b204f00
RBP: ffff8880a6497cb8 R08: ffff8880a76c4700 R09: fffffbfff14a8151
R10: fffffbfff14a8150 R11: ffffffff8a540a87 R12: ffff88808b204c40
R13: 0000000000000000 R14: 0000000000000014 R15: 0000000000000001
FS:  000055555741a940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000780000 CR3: 000000008ff7d000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  tls_sk_proto_close+0x2a9/0x4a0 net/tls/tls_main.c:369
  tcp_bpf_close+0x17c/0x390 net/ipv4/tcp_bpf.c:578
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4134f0
Code: 01 f0 ff ff 0f 83 30 1b 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d 9d 2d 66 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff
RSP: 002b:00007ffc6f204768 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 00000000004134f0
RDX: 0000001b30d20000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffffffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000075bf20
R13: 0000000000000003 R14: 0000000000761178 R15: ffffffffffffffff
Modules linked in:
---[ end trace 5143786da0160ad0 ]---
RIP: 0010:tls_sk_proto_close+0x90/0x4a0 net/tls/tls_main.c:348
Code: 3c 02 00 0f 85 dd 03 00 00 49 8b 84 24 c0 02 00 00 4d 8d 75 14 4c 89  
f2 48 c1 ea 03 48 89 45 b8 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c  
89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 67 03 00 00
RSP: 0018:ffff8880a6497c70 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 00000000fffffff0 RCX: ffffffff8629731c
RDX: 0000000000000002 RSI: ffffffff862970cd RDI: ffff88808b204f00
RBP: ffff8880a6497cb8 R08: ffff8880a76c4700 R09: fffffbfff14a8151
R10: fffffbfff14a8150 R11: ffffffff8a540a87 R12: ffff88808b204c40
R13: 0000000000000000 R14: 0000000000000014 R15: 0000000000000001
FS:  000055555741a940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000780000 CR3: 000000008ff7d000 CR4: 00000000001406e0
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
