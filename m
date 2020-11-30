Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3B22C8031
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 09:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgK3Ik7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 03:40:59 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:46126 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgK3Ik6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 03:40:58 -0500
Received: by mail-io1-f70.google.com with SMTP id a2so6634740iod.13
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 00:40:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Sc8rQuAJBKv+/HrAfD4yy+MSmV2CTQJerzZ7v9NKufU=;
        b=dGaJpns8cE5dHbLgREydQfrb6AL/wvn8yMfKjYQO96TIVKAKr8ly5yXGtCM55kB82P
         AYK7lLKHr8AhQcnLWQWNGJFrTtH5bP+b6KDTMhHJaoyZEmB+6Cz5ZrXKyOLvhgo9rYnS
         /d+2cR5+wxxEkoy4yKzVItta/4WTUPzkX7vYob+U9ocbqZlZbZ3ZRoGZyQuKEahI89/B
         o/T9Q93RXlDuuIl6jSQYkQBPMOiRKEJa4kRcw787T5EU/KOVLlEPZnwEdCzWOtHXDhcX
         1pD0kb1f2RZ4+ppQOiyS5nNf/o4KmisKlXKlnbZSQmWsXl7gEAi+6i0UhfPvz+Oq2zYY
         oFJg==
X-Gm-Message-State: AOAM532p1JP8gad2dKHqUX1Brhu6Pqpr93P+9xjLEs9Gf91dRYt9A2x/
        ah2P90+WKLzqCzWRDhKZ/0IH5JKQOS7cqMkcCkk3aCeR7rqg
X-Google-Smtp-Source: ABdhPJwdOCuecM3z6/S89fvdDzxK07clfj40jG1jkXhsrCjKBSJOKT5hvcEt/stw5mG6c6cZSKDuuKoVDnYlLp0lc9GOqXoWLtrc
MIME-Version: 1.0
X-Received: by 2002:a92:aa53:: with SMTP id j80mr17846552ili.88.1606725617876;
 Mon, 30 Nov 2020 00:40:17 -0800 (PST)
Date:   Mon, 30 Nov 2020 00:40:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4862805b54ef573@google.com>
Subject: WARNING in sk_stream_kill_queues (5)
From:   syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net, dvyukov@google.com,
        elver@google.com, glider@google.com, jannh@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6147c83f Add linux-next specific files for 20201126
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=117c9679500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9b91566da897c24f
dashboard link: https://syzkaller.appspot.com/bug?extid=7b99aafdcc2eedea6178
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=103bf743500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167c60c9500000

The issue was bisected to:

commit 145cd60fb481328faafba76842aa0fd242e2b163
Author: Alexander Potapenko <glider@google.com>
Date:   Tue Nov 24 05:38:44 2020 +0000

    mm, kfence: insert KFENCE hooks for SLUB

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13abe5b3500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=106be5b3500000
console output: https://syzkaller.appspot.com/x/log.txt?x=17abe5b3500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com
Fixes: 145cd60fb481 ("mm, kfence: insert KFENCE hooks for SLUB")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 11307 at net/core/stream.c:207 sk_stream_kill_queues+0x3c3/0x530 net/core/stream.c:207
Modules linked in:
CPU: 0 PID: 11307 Comm: syz-executor673 Not tainted 5.10.0-rc5-next-20201126-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sk_stream_kill_queues+0x3c3/0x530 net/core/stream.c:207
Code: 00 00 00 fc ff df 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 63 01 00 00 8b ab 20 02 00 00 e9 60 ff ff ff e8 ad 24 7b fa <0f> 0b eb 97 e8 a4 24 7b fa 0f 0b eb a0 e8 9b 24 7b fa 0f 0b e9 a5
RSP: 0018:ffffc9000979f978 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000fffffe80 RCX: ffffffff86f5877a
RDX: ffff88801ebb5040 RSI: ffffffff86f587e3 RDI: 0000000000000005
RBP: 0000000000000180 R08: 0000000000000001 R09: ffffffff8ebd9817
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8880182f3ce0
R13: ffffffff8fb178c0 R14: ffff8880182f3ae8 R15: ffff8880182f3c70
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c7cd8 CR3: 000000000b08e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 inet_csk_destroy_sock+0x1a5/0x490 net/ipv4/inet_connection_sock.c:885
 __tcp_close+0xd3e/0x1170 net/ipv4/tcp.c:2585
 tcp_close+0x29/0xc0 net/ipv4/tcp.c:2597
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1255
 __fput+0x283/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x190 kernel/task_work.c:140
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xb89/0x29e0 kernel/exit.c:823
 do_group_exit+0x125/0x310 kernel/exit.c:920
 get_signal+0x3ec/0x2010 kernel/signal.c:2770
 arch_do_signal_or_restart+0x2a8/0x1eb0 arch/x86/kernel/signal.c:811
 handle_signal_work kernel/entry/common.c:144 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x124/0x200 kernel/entry/common.c:198
 syscall_exit_to_user_mode+0x36/0x260 kernel/entry/common.c:275
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x44ea59
Code: Unable to access opcode bytes at RIP 0x44ea2f.
RSP: 002b:00007fd1200f3d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: 0000000000012255 RBX: 00000000006e6a18 RCX: 000000000044ea59
RDX: 00000001000001bd RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000006e6a10 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006e6a1c
R13: 3030303030303030 R14: 3030303030303d65 R15: 2b74d0dd4a6f722c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
