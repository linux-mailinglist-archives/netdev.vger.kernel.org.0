Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4BD297236
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465764AbgJWP0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:26:22 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41326 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S465751AbgJWP0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:26:22 -0400
Received: by mail-io1-f72.google.com with SMTP id j21so1413783iog.8
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 08:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=fVF0gABiOKEQfoDST5uccDfvXF8ctJ4vneZIvOOcqcM=;
        b=S7ZKRGef+A+udtVmuJLozD7WtkBjuLD2S5txMBenv7bFilEvohSQAyh0/Ur/n/TuFH
         g+YLaRraTnQBgmyhqPk2b5trMnIicWYc6O6VQELrc+XiyHpQmsZcxzLNQqHMpZ+lJcDN
         +Rqp5qiv/BeJjG4PQw/4y/JB+1Xx6KNIZmTqs58/b23JgNWTxx859opbNQt5CLzu3hhS
         6Mif/qYvEds+D8vDwd38wchVa5D0EbCA7XrTC3yZVhuX2dyOYqiWX5jNHQjC/ExRfE2l
         W/YJUt6KSd0LZEl39tUzudzcsVqlruWRo0bHucrGicLYh1I17MX3fpkM4DCF2CEuBte4
         qH4Q==
X-Gm-Message-State: AOAM533xaEqeyA1I4QWmxA7VdfHxHV0lhwaX3eks6iInxaw6kcogzvAK
        jS1wzdDkj+2V4dDM8lWmOL98iK+UswHkG/Ls+oBP6fvYEq7p
X-Google-Smtp-Source: ABdhPJx1GJ3FEApap2mJFzhYOOp0cZktQgnYogiRNJ0zbC3dZOhzXU448rZupVa+jORc+uwTXnnhMWtbbsMZyRcKKsZ1Uj/yxR/8
MIME-Version: 1.0
X-Received: by 2002:a92:b503:: with SMTP id f3mr2130770ile.23.1603466781178;
 Fri, 23 Oct 2020 08:26:21 -0700 (PDT)
Date:   Fri, 23 Oct 2020 08:26:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e6c3d405b25833b7@google.com>
Subject: general protection fault in call_commit_handler
From:   syzbot <syzbot+444248c79e117bc99f46@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9ff9b0d3 Merge tag 'net-next-5.10' of git://git.kernel.org..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12377207900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=10a98dcaa4fa65a2
dashboard link: https://syzkaller.appspot.com/bug?extid=444248c79e117bc99f46
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105d15a4500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11973e78500000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10bd270c500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12bd270c500000
console output: https://syzkaller.appspot.com/x/log.txt?x=14bd270c500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+444248c79e117bc99f46@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8503 Comm: syz-executor669 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:call_commit_handler+0x8b/0x110 net/wireless/wext-core.c:900
Code: 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7d 48 8b 9d e0 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 75 73 48 b8 00 00 00 00 00 fc ff df 48 8b 1b 48 89 da
RSP: 0018:ffffc90001927ca8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8844a758
RDX: 0000000000000000 RSI: ffffffff8844a765 RDI: ffff88809b6f81e0
RBP: ffff88809b6f8000 R08: 0000000000000000 R09: ffff88809b6f8047
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88809b6f8040
R13: ffffc90001927db0 R14: ffff88809b6f8000 R15: 0000000000000004
FS:  0000000000725880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200000c0 CR3: 00000000aabca000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ioctl_standard_call+0x1b8/0x1f0 net/wireless/wext-core.c:1029
 wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:954
 wext_ioctl_dispatch net/wireless/wext-core.c:987 [inline]
 wext_ioctl_dispatch net/wireless/wext-core.c:975 [inline]
 wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1048
 sock_ioctl+0x439/0x730 net/socket.c:1119
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441549
Code: e8 ec 05 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 0d fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffec8be6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffec8be6050 RCX: 0000000000441549
RDX: 00000000200000c0 RSI: 0000000000008b04 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000002000000000 R09: 0000002000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000032
R13: 0000000000000000 R14: 000000000000000c R15: 0000000000000004
Modules linked in:
---[ end trace e41146864548f580 ]---
RIP: 0010:call_commit_handler+0x8b/0x110 net/wireless/wext-core.c:900
Code: 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7d 48 8b 9d e0 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <80> 3c 02 00 75 73 48 b8 00 00 00 00 00 fc ff df 48 8b 1b 48 89 da
RSP: 0018:ffffc90001927ca8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8844a758
RDX: 0000000000000000 RSI: ffffffff8844a765 RDI: ffff88809b6f81e0
RBP: ffff88809b6f8000 R08: 0000000000000000 R09: ffff88809b6f8047
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88809b6f8040
R13: ffffc90001927db0 R14: ffff88809b6f8000 R15: 0000000000000004
FS:  0000000000725880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f952003c058 CR3: 00000000aabca000 CR4: 00000000001506e0
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
