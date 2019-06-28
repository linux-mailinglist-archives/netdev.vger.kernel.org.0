Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4801959188
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 04:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfF1CrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 22:47:07 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:57252 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfF1CrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 22:47:07 -0400
Received: by mail-io1-f71.google.com with SMTP id u25so4847823iol.23
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 19:47:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=S+RgQyNmWrZLMaDBL8aUOTR3qZTZHYaiPNOfI1qTD3M=;
        b=PcBNh8Sekre0jiYvP89gz6OP3cv5wzGYDyXKngHvtHbx3YD4H/QA7AH/u3hfrpJX/b
         YEmb90WCG1/mKsf111rB35S87cImqLIEUG8DKqVTW6Yx70asr6MRbLks0P+jDTjlM50W
         ZP2aXSmCeszxEqkabE53GGIqrjs8LCoxoMhuIelZHyBVRKwP/h/8dDdKbD8IwlaeukD2
         4JIMtN5m+bGc9o03vb4YM7TsXMlvj2RMps0xjFBmHd2vzVo8tc9gn5iv1ictMmaUP7IC
         YKQ2QY1UzIDdhDyc2UEbCg6dmfaheQeAAsx31WCU9S59DPbI2iVyN6JmU5euDDkDLCB2
         r5ZA==
X-Gm-Message-State: APjAAAUHPh2PiiXZu2kyEHSknPHqRpZG/3VK0Dled22fuLDyVPcsbdd6
        1icXaNurlmkLzqNCpmyj33P2VHPzsY6SsaSJ2I8KmYmRNw3m
X-Google-Smtp-Source: APXvYqyIbGRz8tsJuRDqF26dvZc3RnJeg3tG3iMrWpR/fS5xYq/3rI1hP29uV9YVs6LKutQ0BiynVljMsp44MXnPPT07lLlfHHR0
MIME-Version: 1.0
X-Received: by 2002:a5d:8497:: with SMTP id t23mr8025000iom.298.1561690026810;
 Thu, 27 Jun 2019 19:47:06 -0700 (PDT)
Date:   Thu, 27 Jun 2019 19:47:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004c2416058c594b30@google.com>
Subject: kernel BUG at net/rxrpc/local_object.c:LINE!
From:   syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    249155c2 Merge branch 'parisc-5.2-4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14fabe45a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7c31a94f66cc0aa
dashboard link: https://syzkaller.appspot.com/bug?extid=1e0edc4b8b7494c28450
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e2738da00000

The bug was bisected to:

commit 46894a13599a977ac35411b536fb3e0b2feefa95
Author: David Howells <dhowells@redhat.com>
Date:   Thu Oct 4 08:32:28 2018 +0000

     rxrpc: Use IPv4 addresses throught the IPv6

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152fabe3a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=172fabe3a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=132fabe3a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com
Fixes: 46894a13599a ("rxrpc: Use IPv4 addresses throught the IPv6")

rxrpc: Assertion failed
------------[ cut here ]------------
kernel BUG at net/rxrpc/local_object.c:468!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.2.0-rc6+ #60
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:rxrpc_local_rcu net/rxrpc/local_object.c:468 [inline]
RIP: 0010:rxrpc_local_rcu.cold+0x11/0x13 net/rxrpc/local_object.c:462
Code: 83 eb 20 e9 74 ff ff ff e8 58 aa 2d fb eb cc 4c 89 ef e8 6e aa 2d fb  
eb e2 e8 d7 fd f4 fa 48 c7 c7 20 8c 15 88 e8 6f 03 df fa <0f> 0b e8 c4 fd  
f4 fa 48 c7 c7 20 8c 15 88 e8 5c 03 df fa 0f 0b e8
RSP: 0018:ffff8880a9917c98 EFLAGS: 00010286
RAX: 0000000000000017 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ad926 RDI: ffffed1015322f85
RBP: ffff8880a9917ca8 R08: 0000000000000017 R09: ffffed1015d260a1
R10: ffffed1015d260a0 R11: ffff8880ae930507 R12: ffff888099033b40
R13: ffff888099033b40 R14: ffffffff867b8f10 R15: ffff8880a9917d28
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f380ebda000 CR3: 000000007ad50000 CR4: 00000000001406e0
Call Trace:
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2092 [inline]
  invoke_rcu_callbacks kernel/rcu/tree.c:2310 [inline]
  rcu_core+0xba5/0x1500 kernel/rcu/tree.c:2291
  __do_softirq+0x25c/0x94c kernel/softirq.c:292
  run_ksoftirqd kernel/softirq.c:603 [inline]
  run_ksoftirqd+0x8e/0x110 kernel/softirq.c:595
  smpboot_thread_fn+0x6a3/0xa30 kernel/smpboot.c:165
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 0e784d6285151217 ]---
RIP: 0010:rxrpc_local_rcu net/rxrpc/local_object.c:468 [inline]
RIP: 0010:rxrpc_local_rcu.cold+0x11/0x13 net/rxrpc/local_object.c:462
Code: 83 eb 20 e9 74 ff ff ff e8 58 aa 2d fb eb cc 4c 89 ef e8 6e aa 2d fb  
eb e2 e8 d7 fd f4 fa 48 c7 c7 20 8c 15 88 e8 6f 03 df fa <0f> 0b e8 c4 fd  
f4 fa 48 c7 c7 20 8c 15 88 e8 5c 03 df fa 0f 0b e8
RSP: 0018:ffff8880a9917c98 EFLAGS: 00010286
RAX: 0000000000000017 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ad926 RDI: ffffed1015322f85
RBP: ffff8880a9917ca8 R08: 0000000000000017 R09: ffffed1015d260a1
R10: ffffed1015d260a0 R11: ffff8880ae930507 R12: ffff888099033b40
R13: ffff888099033b40 R14: ffffffff867b8f10 R15: ffff8880a9917d28
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f380ebda000 CR3: 000000007ad50000 CR4: 00000000001406e0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
