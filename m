Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C06326A05E
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgIOIEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:04:54 -0400
Received: from mail-io1-f80.google.com ([209.85.166.80]:49566 "EHLO
        mail-io1-f80.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgIOIEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:04:21 -0400
Received: by mail-io1-f80.google.com with SMTP id k133so1635119iof.16
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 01:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xNbe/yDuQhQzJ3d3+c2AFbxK3UB/SRkgVKKkH8tRHCw=;
        b=JuBIfUMKFY4uALuVG9Xh+Sj/IchBQO8E/KtUeXH4LYcmevRRdwp/d+0gMY5Kr4KrmB
         O4vi3sA70fiVaynGfrEwWNw4H+hvPAkoNXpEGfSj4udum4WnQWkl9wTQ5e3ZkjW3vdQ6
         +dzesxera0a2D9mEBSBZsiDtwg0yKdDfI2psYO39Va+uP6GPqFmzig+LhCQ8jAEKMFhA
         62mpCeSKYEU69YKXri48eDwrW1LXs+A2nfInw4okX6gFpqmSng+qg2ZaRgv4x3tD/tku
         7WX2iSaPXS79NHtFOGH4Ow//z0TLuFvKjQnOYCG8EfjRWh2fzRZKbUImbjqdwbmSKxHU
         1HtA==
X-Gm-Message-State: AOAM531W5RhQsZ49xXSaeFwJZEKl1ZaH7RrCeOs4ynRSWKhxjsrnDpDh
        tzowwAqzTCJs60mi9jiDO/0S84/4N/MbQCXoVqCxaSvqa0gy
X-Google-Smtp-Source: ABdhPJxCiiZsr/IymUa6U1cNW5Kt9Y9Trg/saWU+QvMcydFf6OJ6eCuKKuwuiBYWc3vN65CsWy4ZN3X0yKS0POSIpB/h670CZONZ
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:bea:: with SMTP id d10mr14985132ilu.143.1600157060379;
 Tue, 15 Sep 2020 01:04:20 -0700 (PDT)
Date:   Tue, 15 Sep 2020 01:04:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b3ac605af559958@google.com>
Subject: general protection fault in cache_clean
From:   syzbot <syzbot+1594adb1b44e354153d8@syzkaller.appspotmail.com>
To:     anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    581cb3a2 Merge tag 'f2fs-for-5.9-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f5c011900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9075b36a6ae26c9
dashboard link: https://syzkaller.appspot.com/bug?extid=1594adb1b44e354153d8
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1594adb1b44e354153d8@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0012e34a9a: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x00000000971a54d0-0x00000000971a54d7]
CPU: 1 PID: 19990 Comm: kworker/1:11 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient do_cache_clean
RIP: 0010:cache_clean+0x119/0x7f0 net/sunrpc/cache.c:444
Code: 81 fb 20 eb 94 8a 0f 84 b8 00 00 00 e8 80 df 33 fa 48 8d 83 40 ff ff ff 48 8d 7b 10 48 89 05 8e 8e 13 06 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 e0 05 00 00 48 8d 6c 24 38 4c 8b 63 10 48 89
RSP: 0018:ffffc90008e1fc48 EFLAGS: 00010206
RAX: 0000000012e34a9a RBX: 00000000971a54c0 RCX: ffffffff87406dbb
RDX: ffff88804358a000 RSI: ffffffff87406e00 RDI: 00000000971a54d0
RBP: 0000000000000100 R08: 0000000000000001 R09: 0000000000000003
R10: 0000000000000100 R11: 0000000000000000 R12: 0000000000000100
R13: dffffc0000000000 R14: ffff88803451b200 R15: ffff8880ae735600
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004ef310 CR3: 000000009ca1b000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_cache_clean+0xd/0xd0 net/sunrpc/cache.c:502
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace 4c54bbd0e20d734b ]---
RIP: 0010:cache_clean+0x119/0x7f0 net/sunrpc/cache.c:444
Code: 81 fb 20 eb 94 8a 0f 84 b8 00 00 00 e8 80 df 33 fa 48 8d 83 40 ff ff ff 48 8d 7b 10 48 89 05 8e 8e 13 06 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 e0 05 00 00 48 8d 6c 24 38 4c 8b 63 10 48 89
RSP: 0018:ffffc90008e1fc48 EFLAGS: 00010206
RAX: 0000000012e34a9a RBX: 00000000971a54c0 RCX: ffffffff87406dbb
RDX: ffff88804358a000 RSI: ffffffff87406e00 RDI: 00000000971a54d0
RBP: 0000000000000100 R08: 0000000000000001 R09: 0000000000000003
R10: 0000000000000100 R11: 0000000000000000 R12: 0000000000000100
R13: dffffc0000000000 R14: ffff88803451b200 R15: ffff8880ae735600
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004ef310 CR3: 000000009ca1b000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
