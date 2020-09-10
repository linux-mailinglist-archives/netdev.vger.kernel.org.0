Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD96726429F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgIJJnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:43:50 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:49309 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgIJJnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 05:43:23 -0400
Received: by mail-il1-f208.google.com with SMTP id f132so4075311ilh.16
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 02:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nU1Cfh/JcUj6ODLNVhA3Cjd25BwCeH0u3p5IbvUT7E8=;
        b=eXXkvs4jDfW1HFYE8BCziJRfcxxBOnUm7QanGeW2Msas2TOrrFxO8GyVm+YUR/DJ6m
         Lpba1l/faVaADCDXJNmnwDfQFE37/RjjunSxB75U5c9u4x8cg+keri1gkrPNRVTiFv7T
         M8WVvORd8MjwqzwF4Ex//d6Xu8jm90+rg3+afdHXTPujHjiBrmouhit0i0CaC8BMAo7o
         LgaLmKcKlhxMq82OjUiQ1YcYjBbkkkUnWujI4VmlgZLg3Qs5alYXcIl36PmBBGO/tLqy
         CPN2HgBYI9587yT/lrvzlm4yxn9hNzXWzu3p3SnZJ1urfWZsnEUIGmjPjQl9rs1F5Igc
         jJbw==
X-Gm-Message-State: AOAM533QfFLwz6p+s51aGNIGadwVMrvUHcEdj0On4Ds99GNfO4gfXypn
        LEmVMghlo6+fXzJzuVbtqtRpmhjczv6dDb92IpInlRtna/Af
X-Google-Smtp-Source: ABdhPJy/5bVJwVvzHKZWSI6/ZA6wJi6L48BOhQU+od43M7GR+DbMyzE5X3qlC95205a9ffBLtV1AzU37sCGWDUklU5/5IwFC5HTy
MIME-Version: 1.0
X-Received: by 2002:a92:ce48:: with SMTP id a8mr7114720ilr.295.1599731002412;
 Thu, 10 Sep 2020 02:43:22 -0700 (PDT)
Date:   Thu, 10 Sep 2020 02:43:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000229d5a05aef26677@google.com>
Subject: general protection fault in batadv_iv_ogm_schedule (2)
From:   syzbot <syzbot+870c4745cc7a955e17e2@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    34d4ddd3 Merge tag 'linux-kselftest-5.9-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13db7cdd900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f5c353182ed6199
dashboard link: https://syzkaller.appspot.com/bug?extid=870c4745cc7a955e17e2
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+870c4745cc7a955e17e2@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 1 PID: 6396 Comm: kworker/u4:8 Not tainted 5.9.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:843 [inline]
RIP: 0010:batadv_iv_ogm_schedule+0x925/0xf40 net/batman-adv/bat_iv_ogm.c:869
Code: 00 48 c1 e8 03 48 89 44 24 28 48 c7 c5 48 e7 3a 8c 0f 1f 40 00 49 8d 5f 70 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 7d e0 a9 f9 48 8b 1b 48 b8 00 00 00
RSP: 0018:ffffc90019cd7b88 EFLAGS: 00010202
RAX: 000000000000000e RBX: 0000000000000070 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000007 RDI: 0000000000000000
RBP: ffffffff8c3ae748 R08: ffffffff880ae416 R09: ffffed10152b4c06
R10: ffffed10152b4c06 R11: 0000000000000000 R12: 0000000000000007
R13: ffff8880a95a6028 R14: ffff8880a7f17870 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000931c4000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 batadv_iv_send_outstanding_bat_ogm_packet+0x68c/0x7c0 net/batman-adv/bat_iv_ogm.c:1723
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace 3bb6c6ec8627e29b ]---
RIP: 0010:batadv_iv_ogm_schedule_buff net/batman-adv/bat_iv_ogm.c:843 [inline]
RIP: 0010:batadv_iv_ogm_schedule+0x925/0xf40 net/batman-adv/bat_iv_ogm.c:869
Code: 00 48 c1 e8 03 48 89 44 24 28 48 c7 c5 48 e7 3a 8c 0f 1f 40 00 49 8d 5f 70 48 89 d8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 df e8 7d e0 a9 f9 48 8b 1b 48 b8 00 00 00
RSP: 0018:ffffc90019cd7b88 EFLAGS: 00010202
RAX: 000000000000000e RBX: 0000000000000070 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000007 RDI: 0000000000000000
RBP: ffffffff8c3ae748 R08: ffffffff880ae416 R09: ffffed10152b4c06
R10: ffffed10152b4c06 R11: 0000000000000000 R12: 0000000000000007
R13: ffff8880a95a6028 R14: ffff8880a7f17870 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000931c4000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
