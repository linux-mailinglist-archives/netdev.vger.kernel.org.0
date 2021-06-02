Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2C4739826C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhFBHEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:04:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:45739 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhFBHEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 03:04:01 -0400
Received: by mail-io1-f69.google.com with SMTP id w5-20020a6bf0050000b029043afd24a1b2so871354ioc.12
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 00:02:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3wQWAXuGRWxkImBMjPFQQPlnnvn12avsURmlKQ4Pu/E=;
        b=XNVtxGcy33TRL+yy01Jt0rHg88mtSC+qZUQVA8Gb+vRHeMGEvk0SpjxdmdG6IwTbFq
         816gz7sPh/zvLe81mDihtPuwBHlw1J6BVUMmG3iR9MafpQ3q7C4mxxWPJkbTgBHzWtVV
         r76xvS43EBehmPxWqtR54ppXA9sLV79n26bgErLK0MVFX99f8c5R7H90PcBtEkeR9FqD
         aD0wpdSadmkEd1bwO8VRwiT0obFVvk4AKSWDmftOhXqS13SnQShW3AFow2V6+p6iFbWH
         vlTDNmqHKWsnOEQUAkYc8OW5a5q+WoTAhDBAPzAfXMTGFK/Mh29yoZZ28MIQ8iQUYHQ2
         NjIQ==
X-Gm-Message-State: AOAM5327pWYICjpB6ETWYAVsyCgmA7jO75kmy9k7qAGDeJ8ul3gLvWyS
        8H34M0QfLsacDHz5VGRQIudoomSO3mHUQT8M+0diadJFjJeT
X-Google-Smtp-Source: ABdhPJyUtBpaAPNdOottevQyUSlbdmztszRLcxMPviPcaT93+BiKy2src7rsGzkSACHHopoHFNE7yzWu2Z9YFAiT5eRtbZd4Ton0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13c7:: with SMTP id v7mr11853277ilj.231.1622617338409;
 Wed, 02 Jun 2021 00:02:18 -0700 (PDT)
Date:   Wed, 02 Jun 2021 00:02:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000ff96b05c3c30a16@google.com>
Subject: [syzbot] general protection fault in mac80211_hwsim_tx_frame_nl
From:   syzbot <syzbot+3a2811a83af0f441ef5f@syzkaller.appspotmail.com>
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

HEAD commit:    05924717 bpf, tnums: Provably sound, faster, and more prec..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15a3b90bd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7b1a53f9a0b5a801
dashboard link: https://syzkaller.appspot.com/bug?extid=3a2811a83af0f441ef5f

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3a2811a83af0f441ef5f@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 31562 Comm: kworker/u4:6 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy89 hw_scan_work
RIP: 0010:mac80211_hwsim_tx_frame_nl+0x3fd/0xdb0 drivers/net/wireless/mac80211_hwsim.c:1315
Code: 48 c1 ea 03 80 3c 02 00 0f 85 50 08 00 00 4c 8b ab 90 3c 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8
RSP: 0018:ffffc900017efa90 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff888061fab1e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff852894df RDI: 0000000000000004
RBP: ffff888063455dc0 R08: 0000000000000000 R09: ffff88805de76093
R10: ffffffff852894d1 R11: 000000000000003f R12: ffffc900017efb18
R13: 0000000000000000 R14: ffff888063455140 R15: ffff888061fa8d00
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32431000 CR3: 000000004e282000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 mac80211_hwsim_tx_frame+0x10d/0x1e0 drivers/net/wireless/mac80211_hwsim.c:1773
 hw_scan_work+0x7be/0xc20 drivers/net/wireless/mac80211_hwsim.c:2331
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Modules linked in:
---[ end trace bd7d02fa1bf956f5 ]---
RIP: 0010:mac80211_hwsim_tx_frame_nl+0x3fd/0xdb0 drivers/net/wireless/mac80211_hwsim.c:1315
Code: 48 c1 ea 03 80 3c 02 00 0f 85 50 08 00 00 4c 8b ab 90 3c 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7d 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8
RSP: 0018:ffffc900017efa90 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: ffff888061fab1e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff852894df RDI: 0000000000000004
RBP: ffff888063455dc0 R08: 0000000000000000 R09: ffff88805de76093
R10: ffffffff852894d1 R11: 000000000000003f R12: ffffc900017efb18
R13: 0000000000000000 R14: ffff888063455140 R15: ffff888061fa8d00
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32431000 CR3: 000000004e282000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
