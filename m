Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737182E0BF8
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgLVOpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:45:00 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:47533 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbgLVOo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:44:59 -0500
Received: by mail-io1-f69.google.com with SMTP id q21so7485051ios.14
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lSpvPfHKy5MMJb/4IlgookwUdWGXdnIGkTfYTOdiS6s=;
        b=rpL5aiVS+QV6iytitCc2OGw+tXNFepRMdH2HcVU5vJdPvw4FXVnGty0Cg7taYRj5Ro
         57lsXFE3vl68DyAF4NKUtB0R3QcnQRlvML/eFAeu7kvf/HvMtRESftnl5MzF84IgKASY
         3VlIM/nud/Nk5G4qDfSoHz09pt8NL+SysP3ddLot2yeVYRBjr5x1dEL2GlWOMlV0E107
         6hQlbWiE+m0DNoSy1NPoqQZSRFputd6lLVf617rVZKarrEVdWcKHpgCW9s7H5bXJgVf1
         SOAtadj9Yx1Ul0QLeOTtWAZ5AzQP6Z3TD4IUkCCloIK+mqoBnJf9120mSe3aztb+E3kM
         79tg==
X-Gm-Message-State: AOAM531IurJSsW4FO8S1lWsesCmmG9S/UBlsJL/v4wxCwE9ukfRXXIOB
        gr3r7mpSt6J4vtxvQ1mGPwsnoKMQnyICkEZENr3MrLJoOc2L
X-Google-Smtp-Source: ABdhPJzO+Xa22wZShSH2UAxVctto7w9362EjTW8gO3kxBl/A3SQo0GbXLRlvVRAcOiX2W+A5n6C9n0E1mU/IQRkfRt8PmSs25kUX
MIME-Version: 1.0
X-Received: by 2002:a92:1517:: with SMTP id v23mr21862018ilk.280.1608648258008;
 Tue, 22 Dec 2020 06:44:18 -0800 (PST)
Date:   Tue, 22 Dec 2020 06:44:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fcbe0705b70e9bd9@google.com>
Subject: kernel BUG at lib/string.c:LINE! (6)
From:   syzbot <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, jakub@redhat.com,
        jiangshanlai@gmail.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d64c6f96 Merge tag 'net-5.11-rc1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10bc5613500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aca0dc5c721fe9e5
dashboard link: https://syzkaller.appspot.com/bug?extid=e86f7c428c8c50db65b4
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=169378a7500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144692cb500000

The issue was bisected to:

commit 2f78788b55baa3410b1ec91a576286abe1ad4d6a
Author: Jakub Jelinek <jakub@redhat.com>
Date:   Wed Dec 16 04:43:37 2020 +0000

    ilog2: improve ilog2 for constant arguments

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1584f137500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1784f137500000
console output: https://syzkaller.appspot.com/x/log.txt?x=1384f137500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com
Fixes: 2f78788b55ba ("ilog2: improve ilog2 for constant arguments")

detected buffer overflow in strlen
------------[ cut here ]------------
kernel BUG at lib/string.c:1149!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8713 Comm: syz-executor731 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:fortify_panic+0xf/0x11 lib/string.c:1149
Code: b5 78 a3 04 48 c7 c7 c0 8f c2 89 58 5b 5d 41 5c 41 5d 41 5e 41 5f e9 30 ba ee ff 48 89 fe 48 c7 c7 80 90 c2 89 e8 21 ba ee ff <0f> 0b e8 90 f9 97 f8 0f b6 f3 48 c7 c7 20 f4 10 8c e8 41 e8 fc fa
RSP: 0018:ffffc900020af500 EFLAGS: 00010282
RAX: 0000000000000022 RBX: ffff888011c26768 RCX: 0000000000000000
RDX: ffff88801bad0000 RSI: ffffffff815a6925 RDI: fffff52000415e92
RBP: ffff88801be7c220 R08: 0000000000000022 R09: 0000000000000000
R10: ffffffff815a4d7b R11: 0000000000000000 R12: ffff88801180ec00
R13: ffff888011c26700 R14: 1ffff92000415ea2 R15: 0000000000000010
FS:  0000000000812880(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006dcf60 CR3: 00000000141ee000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 strlen include/linux/string.h:325 [inline]
 strlcpy include/linux/string.h:348 [inline]
 xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143
 xt_check_target+0x26c/0x9e0 net/netfilter/x_tables.c:1019
 check_target net/ipv6/netfilter/ip6_tables.c:529 [inline]
 find_check_entry.constprop.0+0x7f1/0x9e0 net/ipv6/netfilter/ip6_tables.c:572
 translate_table+0xc8b/0x1750 net/ipv6/netfilter/ip6_tables.c:734
 do_replace net/ipv6/netfilter/ip6_tables.c:1152 [inline]
 do_ip6t_set_ctl+0x553/0xb70 net/ipv6/netfilter/ip6_tables.c:1636
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x122/0x180 net/ipv6/ipv6_sockglue.c:1008
 tcp_setsockopt+0x136/0x2440 net/ipv4/tcp.c:3597
 __sys_setsockopt+0x2db/0x610 net/socket.c:2115
 __do_sys_setsockopt net/socket.c:2126 [inline]
 __se_sys_setsockopt net/socket.c:2123 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2123
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4493d9
Code: e8 0c ca 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b cb fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff679a3898 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000200002c0 RCX: 00000000004493d9
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000006
RBP: 00007fff679a38b0 R08: 0000000000000470 R09: 00000000000000c2
R10: 0000000020000080 R11: 0000000000000246 R12: 00000000000112d5
R13: 00000000006d7dc8 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace e17a915ca7e8b666 ]---
RIP: 0010:fortify_panic+0xf/0x11 lib/string.c:1149
Code: b5 78 a3 04 48 c7 c7 c0 8f c2 89 58 5b 5d 41 5c 41 5d 41 5e 41 5f e9 30 ba ee ff 48 89 fe 48 c7 c7 80 90 c2 89 e8 21 ba ee ff <0f> 0b e8 90 f9 97 f8 0f b6 f3 48 c7 c7 20 f4 10 8c e8 41 e8 fc fa
RSP: 0018:ffffc900020af500 EFLAGS: 00010282
RAX: 0000000000000022 RBX: ffff888011c26768 RCX: 0000000000000000
RDX: ffff88801bad0000 RSI: ffffffff815a6925 RDI: fffff52000415e92
RBP: ffff88801be7c220 R08: 0000000000000022 R09: 0000000000000000
R10: ffffffff815a4d7b R11: 0000000000000000 R12: ffff88801180ec00
R13: ffff888011c26700 R14: 1ffff92000415ea2 R15: 0000000000000010
FS:  0000000000812880(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006dcf60 CR3: 00000000141ee000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
