Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA7931DE3A
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhBQRcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:32:20 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:53338 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhBQRcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:32:03 -0500
Received: by mail-il1-f200.google.com with SMTP id s12so10928188ilh.20
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:31:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Q8EJQL0MD6go7XFOfljUTqAoX/K/UQ5b4Yq+nX1XKbI=;
        b=Y8VJcOJbdiys/3Tai/r2sZWJ7yXfkkmSm4J0gTnm3q1haztVF1SwQmQEiWJDqFnBo4
         wIWP3U1RoLKo36lDfCmSsL3bUJA/H+68xdZNw0DcYnrYKt6Hx3w1zHjiiYzpfSo9KVew
         rzdTYnaCotTBogfnLzTPDfXgggQOiNbUVVbt6xAejWGOnRG59f73fIIavuCF2dKGtTod
         7UCQuBjyn6AeG4dtgIhXe+uN4fKf3Ow0fmHFG3052Wj64Fp2jMUeHO4473xk3sAUwclU
         Z6Jx+gDu+CjAEH6ft+G3ZjWcdmXjaW00VVVVU3DR4tgSpruifCH/fJI50Xgwm0BSOYqt
         uD2Q==
X-Gm-Message-State: AOAM5311dSOsqueeL5Eme6lF+IHDai4okHiu5P0Ry/1P8zOOewBf1cyZ
        XX4COljZ8zsZar4w3eOPQ51gffPhjcyzJfrh5o+IZ5valoBC
X-Google-Smtp-Source: ABdhPJx2uXDzKi02A3GCGw9T19gC6qcaq7rkdWOFEZ2JbDCjmm5Es5MK5EQ7OCidhg4WY+vV0rYa4XfMga8nw8Kxr1HotRz6KJtb
MIME-Version: 1.0
X-Received: by 2002:a02:8b:: with SMTP id 133mr483268jaa.92.1613583082564;
 Wed, 17 Feb 2021 09:31:22 -0800 (PST)
Date:   Wed, 17 Feb 2021 09:31:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073aedf05bb8b96cf@google.com>
Subject: WARNING in dst_release
From:   syzbot <syzbot+b53bbea2ad64f9cf80d8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        kuba@kernel.org, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9ec5eea5 lib/parman: Delete newline
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=107fb9d2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
dashboard link: https://syzkaller.appspot.com/bug?extid=b53bbea2ad64f9cf80d8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11fe1d3cd00000

The issue was bisected to:

commit 40947e13997a1cba4e875893ca6e5d5e61a0689d
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Feb 12 23:59:56 2021 +0000

    mptcp: schedule worker when subflow is closed

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11ee2f02d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13ee2f02d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=15ee2f02d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b53bbea2ad64f9cf80d8@syzkaller.appspotmail.com
Fixes: 40947e13997a ("mptcp: schedule worker when subflow is closed")

------------[ cut here ]------------
dst_release underflow
WARNING: CPU: 0 PID: 9649 at net/core/dst.c:175 dst_release net/core/dst.c:175 [inline]
WARNING: CPU: 0 PID: 9649 at net/core/dst.c:175 dst_release+0xd2/0xe0 net/core/dst.c:169
Modules linked in:
CPU: 0 PID: 9649 Comm: syz-executor.0 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:dst_release net/core/dst.c:175 [inline]
RIP: 0010:dst_release+0xd2/0xe0 net/core/dst.c:169
Code: 89 c3 89 c6 e8 cf b3 77 fa 85 db 74 a4 e9 e4 66 fd 01 e8 41 ac 77 fa 48 c7 c7 c0 72 44 8a c6 05 0a 9b 94 06 01 e8 01 52 c1 01 <0f> 0b eb c6 66 2e 0f 1f 84 00 00 00 00 00 41 56 41 55 41 54 55 48
RSP: 0018:ffffc90009cf7d20 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801895d340 RSI: ffffffff815b7595 RDI: fffff5200139ef96
RBP: ffff888017c95e00 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815b076e R11: 0000000000000000 R12: ffff88802bad7200
R13: 00000000ffffffff R14: ffff888017c95e04 R15: 0000000000000000
FS:  00007ff13b462700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e9f2997360 CR3: 0000000015dd0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sk_dst_set include/net/sock.h:1999 [inline]
 sk_dst_reset include/net/sock.h:2011 [inline]
 __inet_bind+0x71f/0xbc0 net/ipv4/af_inet.c:549
 inet_bind+0xf0/0x170 net/ipv4/af_inet.c:457
 mptcp_bind+0x112/0x210 net/mptcp/protocol.c:3147
 __sys_bind+0x1e9/0x250 net/socket.c:1635
 __do_sys_bind net/socket.c:1646 [inline]
 __se_sys_bind net/socket.c:1644 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1644
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x465d99
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff13b462188 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465d99
RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 00000000004bcf27 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffd21708c7f R14: 00007ff13b462300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
