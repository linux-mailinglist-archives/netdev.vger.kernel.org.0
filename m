Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB49257EFC
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgHaQrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:47:24 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:52113 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgHaQrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 12:47:21 -0400
Received: by mail-io1-f69.google.com with SMTP id q12so3284072iob.18
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 09:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ptposISBabJU+0UJWvS9jomfWUAW0h4nJ0MphyriG80=;
        b=rlTgsw1BLylJgt97VSSfpi8JDKR5V7AmjUMkO06qY4Fd+mhq0oroYf+vKotAzZVC67
         oF7t2ceo6uCjI5H/2Nm+Vgrvnw8+DNoKTK7zMersDzMIboFe3JuGcLFCctqkV+g6TY0Z
         gdhtZxM124RH/VNoAZF1PO6auJsi1EXAguW6SaBxsKw7utFa2ZN8hGXMMPmB89e2+cVk
         XLc7UFM249z+tl36AIbHYV0JweyIjSqQM/YJBG7IdVfZrTu7+RhM0aFWbxkiHVp3nQA7
         iX8WeJTBCfbw9TYWCmiY6rccaISD1RmcRlJPY1PBcBo/G1xiB+UGUJa6Geg/oSNbpEy/
         Eigw==
X-Gm-Message-State: AOAM531qVBWcTw0pcXpSRAL2rvrnTjsb11FE00AQKlIV5qa/VAvGXXvx
        kicqFH7nDw4LUKLVa2zKlkv++D94goWbf54JKk+z+3RQ/1ao
X-Google-Smtp-Source: ABdhPJwbrhYo/UOtEzaf2bomCwl2z82/Rj/d1ECpd3KbTEeUdDOu6FLxX6fptS+lhHNNe4iZJh7pmbBEx+nEuYRPRMUAaRxhSynT
MIME-Version: 1.0
X-Received: by 2002:a92:85ce:: with SMTP id f197mr1970896ilh.298.1598892440186;
 Mon, 31 Aug 2020 09:47:20 -0700 (PDT)
Date:   Mon, 31 Aug 2020 09:47:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee7d1a05ae2f2720@google.com>
Subject: WARNING in nla_get_range_unsigned
From:   syzbot <syzbot+353df1490da781637624@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes.berg@intel.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0f091e43 netlabel: remove unused param from audit_log_form..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14865df2900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61025c6fd3261bb1
dashboard link: https://syzkaller.appspot.com/bug?extid=353df1490da781637624
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d7b769900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e7aa56900000

The issue was bisected to:

commit 8aa26c575fb343ebde810b30dad0cba7d8121efb
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Aug 18 08:17:33 2020 +0000

    netlink: make NLA_BINARY validation more flexible

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=104486c1900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=124486c1900000
console output: https://syzkaller.appspot.com/x/log.txt?x=144486c1900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+353df1490da781637624@syzkaller.appspotmail.com
Fixes: 8aa26c575fb3 ("netlink: make NLA_BINARY validation more flexible")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6854 at lib/nlattr.c:117 nla_get_range_unsigned+0x157/0x530 lib/nlattr.c:117
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6854 Comm: syz-executor416 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:nla_get_range_unsigned+0x157/0x530 lib/nlattr.c:117
Code: 2a 03 00 00 44 0f b6 3b 48 c7 c6 40 9f 96 88 4c 89 ff e8 3c 34 c4 fd 41 80 ff 0b 77 11 42 ff 24 fd 60 99 96 88 e8 69 37 c4 fd <0f> 0b eb 8f e8 60 37 c4 fd 0f 0b 5b 41 5c 41 5d 41 5e 41 5f 5d e9
RSP: 0018:ffffc90000f17190 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffff89180640 RCX: ffffffff83b006e8
RDX: ffff8880a79a8300 RSI: ffffffff83b007a7 RDI: 0000000000000003
RBP: ffffc90000f171b8 R08: 0000000000000000 R09: ffff8880972a4370
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000f17278
R13: ffffffff89180641 R14: 0000000000008c60 R15: ffffffff89180640
 netlink_policy_dump_write+0x2ae/0xea0 net/netlink/policy.c:270
 ctrl_dumppolicy+0x4a8/0x900 net/netlink/genetlink.c:1099
 genl_lock_dumpit+0x7f/0xb0 net/netlink/genetlink.c:553
 netlink_dump+0x4cd/0xf60 net/netlink/af_netlink.c:2246
 __netlink_dump_start+0x643/0x900 net/netlink/af_netlink.c:2354
 genl_family_rcv_msg_dumpit+0x2ac/0x310 net/netlink/genetlink.c:616
 genl_family_rcv_msg net/netlink/genetlink.c:711 [inline]
 genl_rcv_msg+0x75f/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4402a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd2f689438 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402a9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ab0
R13: 0000000000401b40 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
