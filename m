Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5AD1F0818
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 20:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgFFSNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 14:13:18 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54265 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgFFSNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 14:13:17 -0400
Received: by mail-io1-f69.google.com with SMTP id g3so8035852ioc.20
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 11:13:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CjXuFVsN1v3XRE0SfwegOmV6httWcBVTr91Vy0R3PQU=;
        b=CMf8o/U/ULirXt9k3wcWX8IZIWmeHNbh/inqZudquHNYYY0MDx3uaaXKTGvZzu6E7s
         UMlmWBUBxZS6RbfDom3T4dyztdxmy9Mu1ksSpdnPnpIdajC+QnVOMW3zqw3umLqZPvCP
         MVhx2SMWqqKeqxxMRM3UFo5Ksh1ZugnwK6eAVXdjaR9znMfwkQFepmtjrzQmpF8O2ApI
         sR3F6THmTtxaOjICmA4xu3p8RZ4KzKfRlHkXiNcoR2ZFGqoMPqBB73lf9CS2t04oT36c
         9eDvx5H6QR1C4xGCtFahObY2rTJHCJJjHEYggNQJI1RwaPgHNILJkwzMimpGRT0POlZp
         cBhA==
X-Gm-Message-State: AOAM533WFS/grekVow1ndvMLW5ruVaFmlp58TpGzMNO3OlmFvznUVD9c
        VibvtTyfVYkJOhqn+lVvTjzvzEDqo/XLdBPGDp6rTHHughKH
X-Google-Smtp-Source: ABdhPJzoEPt/cYW7SK0R/7SyDub9h6KU3fJ2MfSo5JcWozzx1CWwc4avJz5TimBb5kbq+I2ieJYg3F+jG7iKKnnwBbFeGFRYO05K
MIME-Version: 1.0
X-Received: by 2002:a05:6638:dd3:: with SMTP id m19mr14680067jaj.106.1591467196413;
 Sat, 06 Jun 2020 11:13:16 -0700 (PDT)
Date:   Sat, 06 Jun 2020 11:13:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e9fc4a05a76e54f8@google.com>
Subject: WARNING in tipc_msg_append
From:   syzbot <syzbot+75139a7d2605236b0b7f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, tuong.t.lien@dektech.com.au,
        ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5e9eeccc tipc: fix NULL pointer dereference in streaming
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15ee307a100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a16ddbc78955e3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=75139a7d2605236b0b7f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118e2961100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10534c1e100000

The bug was bisected to:

commit 0a3e060f340dbe232ffa290c40f879b7f7db595b
Author: Tuong Lien <tuong.t.lien@dektech.com.au>
Date:   Tue May 26 09:38:38 2020 +0000

    tipc: add test for Nagle algorithm effectiveness

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1097e65a100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1297e65a100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1497e65a100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+75139a7d2605236b0b7f@syzkaller.appspotmail.com
Fixes: 0a3e060f340d ("tipc: add test for Nagle algorithm effectiveness")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 check_copy_size include/linux/thread_info.h:150 [inline]
WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 copy_from_iter include/linux/uio.h:144 [inline]
WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 tipc_msg_append+0x49a/0x5e0 net/tipc/msg.c:242
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6808 Comm: syz-executor028 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:105 [inline]
 fixup_bug arch/x86/kernel/traps.c:100 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:197
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:216
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:check_copy_size include/linux/thread_info.h:150 [inline]
RIP: 0010:copy_from_iter include/linux/uio.h:144 [inline]
RIP: 0010:tipc_msg_append+0x49a/0x5e0 net/tipc/msg.c:242
Code: 18 48 89 f8 48 c1 e8 03 42 80 3c 38 00 0f 85 2e 01 00 00 49 83 7e 18 00 0f 84 d4 fc ff ff e8 4d e7 da f9 0f 0b e8 46 e7 da f9 <0f> 0b 41 bc f2 ff ff ff e8 39 e7 da f9 44 89 e0 48 83 c4 50 5b 5d
RSP: 0018:ffffc90001627770 EFLAGS: 00010293
RAX: ffff88808efd0580 RBX: 0000000000000018 RCX: ffffffff8798a901
RDX: 0000000000000000 RSI: ffffffff8798aaaa RDI: 0000000000000007
RBP: ffffffffffffffe8 R08: ffff88808efd0580 R09: ffffed1012e78f1d
R10: ffff8880973c78e7 R11: ffffed1012e78f1c R12: ffff8880973c78e8
R13: ffff8880973c78d0 R14: ffff888095fbecc0 R15: dffffc0000000000
 __tipc_sendstream+0xac3/0x1200 net/tipc/socket.c:1578
 tipc_sendstream+0x4c/0x70 net/tipc/socket.c:1533
 tipc_send_packet+0x3c/0x60 net/tipc/socket.c:1638
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x32f/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmmsg+0x195/0x480 net/socket.c:2496
 __do_sys_sendmmsg net/socket.c:2525 [inline]
 __se_sys_sendmmsg net/socket.c:2522 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4401e9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff7b6a58b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401e9
RDX: 04924924924926c8 RSI: 0000000020236fc8 RDI: 0000000000000004
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a70
R13: 0000000000401b00 R14: 0000000000000000 R15: 0000000000000000
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
