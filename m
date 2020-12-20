Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DB52DF3E1
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 06:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgLTFew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 00:34:52 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:44151 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgLTFev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 00:34:51 -0500
Received: by mail-io1-f69.google.com with SMTP id a1so4185016ioa.11
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 21:34:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mLmvw2D4onMuVrha2AwCYupS5mB8c89IZkH+Ha+dCow=;
        b=dBePDBqADOwUnlyOvLxaQcOStoI5pj1gSpQLtrw3v5H9Jr7bN8xUc3AVnbfdpMMIlq
         alicwZ9FYSwhj3dzaxAPKMDfwviST1hRkPd08oWaL5ikoSdyZxi4U2l8KNjQt0AhGTdt
         EKI8cuIaLE3hlIaeWp6rENMQShmMaxh6la6pB78GDf6vkzIGWvIgmQh+k/+dFcxUAwGx
         EI9gwo34q+mGWzZ1N1VM5IR8YAaIzdQ60dAu31TRaW0Aa07kKvBb9eikyUKMmh0iYhwb
         ILrVLlb4HeFNvHfUcR62UvNmfvpAfHSp84Zz6kO4oWwjeyrisWSrQVLRP+uhLYw58Xt3
         3xaQ==
X-Gm-Message-State: AOAM530UAQ5p53bIBN5IoAA66XGLAf/t/xnu0sbnAJDxF5fOfbJBQDs/
        naCLu7dhNaZML1mXMr3JFLka+ELsPaK8fd5LrWcTTlWTdBmO
X-Google-Smtp-Source: ABdhPJz/waTa+UfOitMCD53w4kXFMdR69jRQ9L2dl2IGkS3lyWkWe2gkzjLlQCkdn3m7v5VndgPAuIsMS0zAmjctdtcAedBCh/6t
MIME-Version: 1.0
X-Received: by 2002:a92:5e9d:: with SMTP id f29mr12015151ilg.266.1608442450389;
 Sat, 19 Dec 2020 21:34:10 -0800 (PST)
Date:   Sat, 19 Dec 2020 21:34:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5b07c05b6deb081@google.com>
Subject: general protection fault in j1939_netdev_notify (2)
From:   syzbot <syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hkallweit1@gmail.com, kernel@pengutronix.de,
        kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        mkl@pengutronix.de, netdev@vger.kernel.org, robin@protonic.nl,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d635a69d Merge tag 'net-next-5.11' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1315f123500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c3556e4856b17a95
dashboard link: https://syzkaller.appspot.com/bug?extid=5138c4dd15a0401bec7b
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12955123500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10f2f30f500000

The issue was bisected to:

commit 497a5757ce4e8f37219a3989ac6a561eb9a8e6c7
Author: Heiner Kallweit <hkallweit1@gmail.com>
Date:   Sat Nov 7 20:50:56 2020 +0000

    tun: switch to net core provided statistics counters

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=143b845b500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=163b845b500000
console output: https://syzkaller.appspot.com/x/log.txt?x=123b845b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com
Fixes: 497a5757ce4e ("tun: switch to net core provided statistics counters")

general protection fault, probably for non-canonical address 0xe000080fe8c072f1: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x0000607f46039788-0x0000607f4603978f]
CPU: 1 PID: 8472 Comm: syz-executor635 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:j1939_ndev_to_priv net/can/j1939/main.c:219 [inline]
RIP: 0010:j1939_priv_get_by_ndev_locked net/can/j1939/main.c:231 [inline]
RIP: 0010:j1939_priv_get_by_ndev net/can/j1939/main.c:243 [inline]
RIP: 0010:j1939_netdev_notify+0x115/0x320 net/can/j1939/main.c:353
Code: 00 74 08 48 89 df e8 ba 1e 48 f9 48 8b 1b 48 85 db 0f 84 f0 00 00 00 4c 89 64 24 08 48 81 c3 28 60 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 8c 1e 48 f9 4c 8b 23 4d 85 e4 0f
RSP: 0018:ffffc90000e9fd68 EFLAGS: 00010202
RAX: 00000c0fe8c072f1 RBX: 0000607f46039788 RCX: ffff88801456d040
RDX: ffff88801456d040 RSI: 0000000000000118 RDI: 0000000000000118
RBP: 0000000000000118 R08: ffffffff8870585d R09: fffff520001d3fa5
R10: fffff520001d3fa5 R11: 0000000000000000 R12: 0000000000000010
R13: 1ffff1100293e848 R14: dffffc0000000000 R15: ffff8880149f4244
FS:  0000000001d13880(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000001402f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2022 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2034 [inline]
 call_netdevice_notifiers+0xeb/0x150 net/core/dev.c:2048
 __tun_chr_ioctl+0x2337/0x4860 drivers/net/tun.c:3093
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl+0xfb/0x170 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440359
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffd37b9c98 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440359
RDX: 0000000000000118 RSI: 00000000400454cd RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401b60
R13: 0000000000401bf0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 7688a2c3c10da2e1 ]---
RIP: 0010:j1939_ndev_to_priv net/can/j1939/main.c:219 [inline]
RIP: 0010:j1939_priv_get_by_ndev_locked net/can/j1939/main.c:231 [inline]
RIP: 0010:j1939_priv_get_by_ndev net/can/j1939/main.c:243 [inline]
RIP: 0010:j1939_netdev_notify+0x115/0x320 net/can/j1939/main.c:353
Code: 00 74 08 48 89 df e8 ba 1e 48 f9 48 8b 1b 48 85 db 0f 84 f0 00 00 00 4c 89 64 24 08 48 81 c3 28 60 00 00 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 8c 1e 48 f9 4c 8b 23 4d 85 e4 0f
RSP: 0018:ffffc90000e9fd68 EFLAGS: 00010202
RAX: 00000c0fe8c072f1 RBX: 0000607f46039788 RCX: ffff88801456d040
RDX: ffff88801456d040 RSI: 0000000000000118 RDI: 0000000000000118
RBP: 0000000000000118 R08: ffffffff8870585d R09: fffff520001d3fa5
R10: fffff520001d3fa5 R11: 0000000000000000 R12: 0000000000000010
R13: 1ffff1100293e848 R14: dffffc0000000000 R15: ffff8880149f4244
FS:  0000000001d13880(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000001402f000 CR4: 00000000001506e0
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
