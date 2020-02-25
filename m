Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F353616BBB0
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 09:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgBYITR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 03:19:17 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40904 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729721AbgBYITQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 03:19:16 -0500
Received: by mail-il1-f199.google.com with SMTP id m18so23751317ill.7
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 00:19:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fknWivdZdylQd6n3hF9x0FMP6gbTR7dvL1d/+DVgu9o=;
        b=lAq+R5NUK7S9MWh2jm2/DkfUoCxJqDTsEW3QifG2nkXA9l057ObFrigRj36Gt93QFM
         S0IQ9zAldEcoPZ6OGvyKQ89Pw14TvzAYeI/oZOT+3QGEzAsroZecgabtzNEcV4BIuFVD
         4pIXCT/QAMDemWL8Z/9sCuCVZG5eBnAQn/Yi0gkGaSXksR0CMX2EWN52Z3RMy7bUMKJq
         csDwh0c21oj89stR0pjuXWEkDzMFanIxRS7HX5dxmG91GH+k//XadV70u0xZcrsf8sbp
         EDIL868UgJ19M8jYNvSM16rHENs5qvq2KAGRKJgY9Qu7/N5jhilKr3BOA0Wgxf/wslUP
         GxIA==
X-Gm-Message-State: APjAAAVXccqxKS33tDKK8f0Z7jSqwprZRSGFvLVNDIPSlLtvVRlqhLDa
        89zEkYOVoqZqIzX/Xbyj6LHlSdxqlIpAZPo2TU09oqAlltS6
X-Google-Smtp-Source: APXvYqw7phfHXyUr0ZQFG8MFqWynB5POAYL/oSJipgpWsjOEAqXwZMq4coUrso6NwbtisLFzRiYb3hOYI0PIikeLuYF0NjQ36gXW
MIME-Version: 1.0
X-Received: by 2002:a92:d18a:: with SMTP id z10mr67819892ilz.48.1582618754323;
 Tue, 25 Feb 2020 00:19:14 -0800 (PST)
Date:   Tue, 25 Feb 2020 00:19:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa9a23059f62246a@google.com>
Subject: WARNING in sk_stream_kill_queues (4)
From:   syzbot <syzbot+fbe81b56f7df4c0fb21b@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, edumazet@google.com,
        jbaron@akamai.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org, shuah@kernel.org,
        soheil@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0c0ddd6a Merge tag 'linux-watchdog-5.6-rc3' of git://www.l..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=17c0fde9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=fbe81b56f7df4c0fb21b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12025de9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16a4d245e00000

The bug was bisected to:

commit fb99bce7120014307dde57b3d7def6977a9a62a1
Author: Dave Watson <davejwatson@fb.com>
Date:   Wed Jan 30 21:58:05 2019 +0000

    net: tls: Support 256 bit keys

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14898931e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16898931e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=12898931e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fbe81b56f7df4c0fb21b@syzkaller.appspotmail.com
Fixes: fb99bce71200 ("net: tls: Support 256 bit keys")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9607 at net/core/stream.c:208 sk_stream_kill_queues+0x40d/0x590 net/core/stream.c:208
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9607 Comm: syz-executor386 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:sk_stream_kill_queues+0x40d/0x590 net/core/stream.c:208
Code: 48 c1 ea 03 0f b6 04 02 84 c0 74 04 3c 03 7e 41 44 8b a3 f8 01 00 00 e9 5f ff ff ff e8 0c 7f 40 fb 0f 0b eb 96 e8 03 7f 40 fb <0f> 0b eb a1 e8 fa 7e 40 fb 0f 0b e9 9f fe ff ff 4c 89 ef e8 7b 24
RSP: 0018:ffffc9000c6efb30 EFLAGS: 00010293
RAX: ffff8880a3102380 RBX: 0000000000000000 RCX: ffffffff8635085d
RDX: 0000000000000000 RSI: ffffffff863508bd RDI: 0000000000000005
RBP: ffffc9000c6efb70 R08: ffff8880a3102380 R09: ffffed1015d2707c
R10: ffffed1015d2707b R11: ffff8880ae9383db R12: 0000000000000fe3
R13: ffff88808f618238 R14: ffffffff8c406240 R15: ffff88808f618178
 inet_csk_destroy_sock+0x1b7/0x4c0 net/ipv4/inet_connection_sock.c:846
 tcp_close+0xe17/0x12b0 net/ipv4/tcp.c:2503
 inet_release+0xed/0x200 net/ipv4/af_inet.c:427
 __sock_release+0xce/0x280 net/socket.c:605
 sock_close+0x1e/0x30 net/socket.c:1283
 __fput+0x2ff/0x890 fs/file_table.c:280
 ____fput+0x16/0x20 fs/file_table.c:313
 task_work_run+0x145/0x1c0 kernel/task_work.c:113
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0xba9/0x2f50 kernel/exit.c:801
 do_group_exit+0x135/0x360 kernel/exit.c:899
 __do_sys_exit_group kernel/exit.c:910 [inline]
 __se_sys_exit_group kernel/exit.c:908 [inline]
 __x64_sys_exit_group+0x44/0x50 kernel/exit.c:908
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43eff8
Code: Bad RIP value.
RSP: 002b:00007ffca386cb68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043eff8
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004be808 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00000000200001c0 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d0180 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
