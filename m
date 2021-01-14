Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D417F2F6CB7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 21:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbhANU5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 15:57:03 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:41067 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbhANU5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 15:57:02 -0500
Received: by mail-io1-f70.google.com with SMTP id v21so10668094iol.8
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 12:56:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gocC/VzkSkkh7+cWU1l2LyVuZ/yknJ3LcOA3JogfWd0=;
        b=n4jOGMZJkWtxShJdh968AYeZ+D2ej0wDO8Sb7hWmHExiPUWBOzF+cyTdcJOVryKAtt
         +bvcKpu0YUGJYGFkAFH0MPci5ZOWnLGwWUmec99xFANGV2a9T5AXvsG8tIKuJODwY7NZ
         y6r/BUtZ2FWHMg3CMegX11y19cFjG6z/uBXwVyuTYQ9aRM4/BUtmm5T/1Bvaczwj/Cx5
         4pQUeCrHuSTveme/pIgpQU77IGouOKUS/8xHvhOf+x11LqcFYYQVSk9s1L6wUMBo0HhO
         PPrVjB+kf3bbbfMYFYLxd0br/6yAyvMfdDFpOzYaW0NHL+EGTGbbkVcXzI3OnIsqenn6
         ClMA==
X-Gm-Message-State: AOAM532YaxqYAoGe78VIFsiTYPL8lL5OKmieGl571GDazFWJgQ8vjfnj
        GlBBcz0YwU4rUNQmdm8bUIkHn6F+Vu1ZAGmcJ1lNcR0NCCZK
X-Google-Smtp-Source: ABdhPJyra8WB5oJQbElhi/bVLRAsPt99cVwM+t/ngccgVyBHad5ZFZ93DpgRoAQAI6etEx2xqMVqN9XLAaQUQ0HG2iYsk76gFeOi
MIME-Version: 1.0
X-Received: by 2002:a5d:8d94:: with SMTP id b20mr6476396ioj.200.1610657781676;
 Thu, 14 Jan 2021 12:56:21 -0800 (PST)
Date:   Thu, 14 Jan 2021 12:56:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee881505b8e27cf2@google.com>
Subject: general protection fault in xsk_recvmsg
From:   syzbot <syzbot+b974d32294d1dffbea36@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bjorn.topel@intel.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, johannes.berg@intel.com,
        johannes@sipsolutions.net, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    df542285 Merge branch 'xdp-preferred-busy-polling'
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11426809500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6774dc081604c527
dashboard link: https://syzkaller.appspot.com/bug?extid=b974d32294d1dffbea36
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1648b0e5500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=125af4ad500000

The issue was bisected to:

commit dcd479e10a0510522a5d88b29b8f79ea3467d501
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 9 12:17:11 2020 +0000

    mac80211: always wind down STA state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12356d1d500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11356d1d500000
console output: https://syzkaller.appspot.com/x/log.txt?x=16356d1d500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b974d32294d1dffbea36@syzkaller.appspotmail.com
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")

general protection fault, probably for non-canonical address 0xdffffc0000000045: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000228-0x000000000000022f]
CPU: 1 PID: 8481 Comm: syz-executor119 Not tainted 5.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:xsk_recvmsg+0x79/0x5e0 net/xdp/xsk.c:563
Code: 03 80 3c 02 00 0f 85 00 05 00 00 48 8b 9d c8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 28 02 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 9c 04 00 00 8b 9b 28 02 00 00
RSP: 0018:ffffc9000165fae0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000040000000
RDX: 0000000000000045 RSI: ffffffff88a6a995 RDI: 0000000000000228
RBP: ffff88801a140000 R08: 0000000040000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000040000000
R13: 0000000040000000 R14: ffffc9000165fe98 R15: 0000000000000000
FS:  00000000007fd880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020004880 CR3: 000000001f1bd000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sock_recvmsg_nosec net/socket.c:885 [inline]
 sock_recvmsg net/socket.c:903 [inline]
 sock_recvmsg net/socket.c:899 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2576
 ___sys_recvmsg+0x127/0x200 net/socket.c:2618
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2654
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440269
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffdbb92b6c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440269
RDX: 0000000040000000 RSI: 0000000020004880 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a70
R13: 0000000000401b00 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 184efc29c05fd9c5 ]---
RIP: 0010:xsk_recvmsg+0x79/0x5e0 net/xdp/xsk.c:563
Code: 03 80 3c 02 00 0f 85 00 05 00 00 48 8b 9d c8 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 28 02 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 9c 04 00 00 8b 9b 28 02 00 00
RSP: 0018:ffffc9000165fae0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000040000000
RDX: 0000000000000045 RSI: ffffffff88a6a995 RDI: 0000000000000228
RBP: ffff88801a140000 R08: 0000000040000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000040000000
R13: 0000000040000000 R14: ffffc9000165fe98 R15: 0000000000000000
FS:  00000000007fd880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f66a803d058 CR3: 000000001f1bd000 CR4: 00000000001506f0
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
