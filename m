Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B218C158274
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 19:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBJSfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 13:35:16 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:47484 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgBJSfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 13:35:16 -0500
Received: by mail-io1-f70.google.com with SMTP id 13so5251970iof.14
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 10:35:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eEnSTgjnTuXOdYs4/BkAIiwofm4jSwmK0WfltaEQevE=;
        b=YszaCf+OTp02p9uFqn0UzHeUJj7THE+C4xHRh0aVY1gH27WZY8ORLKm3ez1qYzdaGA
         xPa+1tIWolpeeYvvCxABIjv3oUmbmXG/pVqG8HPJb0H3sfcyE6Xy7IDtrWLzpaCMRDH+
         a39Bx696mG2vyhEVOpfRI/L6RqVveosWSxuuLPxBOhG+1NVjMkaqGP4SXN2uV/X7Glgh
         de5cd/sgrc8s6tK4UIbML6oi2dQjzFSrMjOEXs8kBA1us1QqkX196phFiL9xpqmAuAyF
         0HaC5dl7PQRgky0Hj1u7LrUvOomtHAYpCUKnGGtzd86pCnIRdd+yxivvJJfWlUUkFY65
         LjOA==
X-Gm-Message-State: APjAAAUJGS2Kck5Un9G3JUqHtjW/elfb9grPM84nqjn5W9nXDC5U2WDY
        b5F4fd21zmUDQyA7U3R4LsEMC8+5aWRXJwmGe0MLCrI2GSGX
X-Google-Smtp-Source: APXvYqyn84LAl/C5LZFRnFMRIJi4qXvbWY/XrSgtDnMIVoe+7uPzAZATRX6iIXD0KGzKKZIk78TO0k4SXKxRc7PmRPW4Xvr0POyK
MIME-Version: 1.0
X-Received: by 2002:a92:24d7:: with SMTP id k206mr2478758ilk.12.1581359715448;
 Mon, 10 Feb 2020 10:35:15 -0800 (PST)
Date:   Mon, 10 Feb 2020 10:35:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019ff88059e3d0013@google.com>
Subject: WARNING: proc registration bug in hashlimit_mt_check_common
From:   syzbot <syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2981de74 Add linux-next specific files for 20200210
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=104b16b5e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53fc3c3fcb36274f
dashboard link: https://syzkaller.appspot.com/bug?extid=d195fd3b9a364ddd6731
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136321d9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=159f7431e00000

The bug was bisected to:

commit 8d0015a7ab76b8b1e89a3e5f5710a6e5103f2dd5
Author: Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon Feb 3 04:30:53 2020 +0000

    netfilter: xt_hashlimit: limit the max size of hashtable

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12a7f25ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11a7f25ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16a7f25ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com
Fixes: 8d0015a7ab76 ("netfilter: xt_hashlimit: limit the max size of hashtable")

xt_hashlimit: size too large, truncated to 1048576
xt_hashlimit: max too large, truncated to 1048576
------------[ cut here ]------------
proc_dir_entry 'ip6t_hashlimit/syzkaller1' already registered
WARNING: CPU: 1 PID: 9858 at fs/proc/generic.c:362 proc_register+0x41e/0x590 fs/proc/generic.c:362
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9858 Comm: syz-executor532 Not tainted 5.5.0-next-20200210-syzkaller #0
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
RIP: 0010:proc_register+0x41e/0x590 fs/proc/generic.c:362
Code: ff df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 5a 01 00 00 48 8b 45 d0 48 c7 c7 e0 1e 59 88 48 8b b0 d0 00 00 00 e8 11 af 5e ff <0f> 0b 48 c7 c7 e0 44 cb 89 e8 24 77 08 06 48 8b 4d a0 48 b8 00 00
RSP: 0018:ffffc90002117550 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff8880a88a0330 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ec996 RDI: fffff52000422e9c
RBP: ffffc900021175b8 R08: ffff8880a45343c0 R09: fffffbfff16a376e
R10: fffffbfff16a376d R11: ffffffff8b51bb6f R12: ffff88809ce38b80
R13: 0000000000000000 R14: ffff88809de6f9f8 R15: dffffc0000000000
 proc_create_seq_private+0x12b/0x190 fs/proc/generic.c:593
 htable_create net/netfilter/xt_hashlimit.c:341 [inline]
 hashlimit_mt_check_common.isra.0+0xb30/0x1680 net/netfilter/xt_hashlimit.c:902
 hashlimit_mt_check_v1+0x325/0x3ab net/netfilter/xt_hashlimit.c:928
 xt_check_match+0x280/0x690 net/netfilter/x_tables.c:501
 check_match net/ipv6/netfilter/ip6_tables.c:489 [inline]
 find_check_match net/ipv6/netfilter/ip6_tables.c:506 [inline]
 find_check_entry.isra.0+0x389/0x9d0 net/ipv6/netfilter/ip6_tables.c:557
 translate_table+0xd15/0x1860 net/ipv6/netfilter/ip6_tables.c:734
 do_replace net/ipv6/netfilter/ip6_tables.c:1153 [inline]
 do_ip6t_set_ctl+0x2fe/0x4c8 net/ipv6/netfilter/ip6_tables.c:1681
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
 ipv6_setsockopt net/ipv6/ipv6_sockglue.c:949 [inline]
 ipv6_setsockopt+0x147/0x180 net/ipv6/ipv6_sockglue.c:933
 rawv6_setsockopt+0x5e/0x150 net/ipv6/raw.c:1081
 sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
 __sys_setsockopt+0x261/0x4c0 net/socket.c:2130
 __do_sys_setsockopt net/socket.c:2146 [inline]
 __se_sys_setsockopt net/socket.c:2143 [inline]
 __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2143
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4482b9
Code: e8 ec 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5cbd09cda8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000006dec48 RCX: 00000000004482b9
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000004
RBP: 00000000006dec40 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00000000006dec4c
R13: 0000000020000000 R14: 00000000004b09c0 R15: 000000000000002d
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
