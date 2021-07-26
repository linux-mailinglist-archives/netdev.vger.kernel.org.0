Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6183D5BD6
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbhGZN55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:57:57 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:40666 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhGZN54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:57:56 -0400
Received: by mail-io1-f70.google.com with SMTP id q137-20020a6b8e8f0000b02904bd1794d00eso8769358iod.7
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rh2WebIAL7rAkd4Y7+OUKTcKX8jr6+sYkZ+Orf4DiGA=;
        b=b4eL1wHnrBppyzHbPeF6c3nSn/dGkbFbdtAQFDCLkf3XridSCipbFS/l3Ga+IiJpSV
         md69xBT30oxauh6WI+wFKF8FKsc3Qp1uqvYqFkLxOuZ5In0W7Bv938j3sXq19BtLKhrI
         GG2x4W8uBF80eZ0EVVl7disx0XN9kSg8tgwlFZ1GEJcbdZfPgWaWhBE1wKMFoCVtHZMk
         qlIxKQUqrfewqRNP4kuKkuaDK+E34AncwZKXJf5DDlzjjZzZrCXXKMIlROQu4MFoSiSs
         o4jMqVlhgMx+J1k4byuBGsq6ZXUx/mcy6dL3wqbB+VjTHdk1j1SoU8PiowHJDnwuuhn6
         Jdmg==
X-Gm-Message-State: AOAM532BwG1z3gON2aAI8ZNQ+/sY3K5Tqlhb++0cKAdJSNEU/70/MHjp
        yrKX+dnPMtVlwR0MjRA1X0W2z+nWkr+sXA3UFWuOO+heLqcS
X-Google-Smtp-Source: ABdhPJwr8jbbv1L9zecIIjUiPDqhnjQ2FHQEXeJdrDY3mtA9+2iaBxbNRaQM6uiqjzF7YSgqqRoZSDXVR4wpf2fHKwUGZIp3tmbt
MIME-Version: 1.0
X-Received: by 2002:a92:d2c2:: with SMTP id w2mr13584853ilg.256.1627310305172;
 Mon, 26 Jul 2021 07:38:25 -0700 (PDT)
Date:   Mon, 26 Jul 2021 07:38:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ade97e05c807b40f@google.com>
Subject: [syzbot] general protection fault in hwsim_exit_net
From:   syzbot <syzbot+78dd535cdc52a06948f7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3d5895cd3517 Merge tag 's390-5.14-3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107699a6300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7273c75708b55890
dashboard link: https://syzkaller.appspot.com/bug?extid=78dd535cdc52a06948f7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78dd535cdc52a06948f7@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc00000000df: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000006f8-0x00000000000006ff]
CPU: 0 PID: 19531 Comm: kworker/u4:5 Not tainted 5.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:read_pnet include/net/net_namespace.h:325 [inline]
RIP: 0010:wiphy_net include/net/cfg80211.h:5107 [inline]
RIP: 0010:hwsim_exit_net+0x160/0xca0 drivers/net/wireless/mac80211_hwsim.c:4201
Code: 8b 73 18 49 8d 7e 40 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 2a 0a 00 00 4d 8b 76 40 49 8d be f8 06 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 04 0a 00 00 48 8b 44 24 08 49 3b 86 f8 06 00 00
RSP: 0018:ffffc9000ad5fb18 EFLAGS: 00010202
RAX: 00000000000000df RBX: ffff888000173260 RCX: 0000000000000000
RDX: ffff88806c08d4c0 RSI: ffffffff8532af70 RDI: 00000000000006f8
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520015abf55 R11: 0000000000086088 R12: ffff888151b83260
R13: ffff888000173260 R14: 0000000000000000 R15: fffffbfff18ef7dc
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000090d52c5 CR3: 000000006769c000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:175
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace a4f6519c3ad068a3 ]---
RIP: 0010:read_pnet include/net/net_namespace.h:325 [inline]
RIP: 0010:wiphy_net include/net/cfg80211.h:5107 [inline]
RIP: 0010:hwsim_exit_net+0x160/0xca0 drivers/net/wireless/mac80211_hwsim.c:4201
Code: 8b 73 18 49 8d 7e 40 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 2a 0a 00 00 4d 8b 76 40 49 8d be f8 06 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 04 0a 00 00 48 8b 44 24 08 49 3b 86 f8 06 00 00
RSP: 0018:ffffc9000ad5fb18 EFLAGS: 00010202
RAX: 00000000000000df RBX: ffff888000173260 RCX: 0000000000000000
RDX: ffff88806c08d4c0 RSI: ffffffff8532af70 RDI: 00000000000006f8
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000003
R10: fffff520015abf55 R11: 0000000000086088 R12: ffff888151b83260
R13: ffff888000173260 R14: 0000000000000000 R15: fffffbfff18ef7dc
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000090d52c5 CR3: 000000006769c000 CR4: 00000000001526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
