Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB307217238
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgGGPaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:30:21 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45413 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729725AbgGGPaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 11:30:15 -0400
Received: by mail-il1-f199.google.com with SMTP id c1so30449541ilk.12
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 08:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=l5UfEPh6FpvcqMK9z9YCj6DGXnLOftd9sD9CfnuWGio=;
        b=n6TH3EANIvi9t+/VY3NbV0foIzEm2QJ9v2gnwqeEO10+z3Fc65bsYzIsD4OyRvtemK
         yrKspNC3rxCnzie0eJtFxlhWBdo62bXS2wGPIhwTFgNRuWfo0Vj8Q4NLQjQqszmwzMk5
         wBKAbv7eykyjp7v/snjAvh8YTZ1gqKiTHI/OlMsPvpecBtRLOqhZ6OebAJpx8enRc+re
         odYOb/loH8MCZ4WxTMzYf9obLa0PuSMxlhy2tvLLxCZ4ZA8jdF0SztNyMv5+yBch8OPM
         mCEtvBgwHCyFxccD2gQLdcvfiW6d0LLFvGMthqsNlub2twuZPQYnBP5IPfdFDuwnqmgH
         jFmg==
X-Gm-Message-State: AOAM530hwrHGANul1IFnwb7xB01tgxAjVycNkMilu1n1w/ML33MvRIzB
        m53kMnmg1jIGiqyT3Hfl2Gp1lAMxKtRhmOG9+idJVYfZLQY5
X-Google-Smtp-Source: ABdhPJz38T51Ko5sHjG40+v5KRv3EC++gkZunO00fGv8OmSqfw3SsUSP6S8MGjq1G+jBQ8orWn+UoH3rpNWToypbts+u/bx/KU74
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c8b:: with SMTP id i11mr31473413iow.139.1594135814367;
 Tue, 07 Jul 2020 08:30:14 -0700 (PDT)
Date:   Tue, 07 Jul 2020 08:30:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f06edf05a9dbaa44@google.com>
Subject: general protection fault in batadv_iv_ogm_schedule_buff (2)
From:   syzbot <syzbot+2eeeb5ad0766b57394d8@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=130b828f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7be693511b29b338
dashboard link: https://syzkaller.appspot.com/bug?extid=2eeeb5ad0766b57394d8
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2eeeb5ad0766b57394d8@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 1 PID: 9126 Comm: kworker/u4:9 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:batadv_iv_ogm_schedule_buff+0xd1e/0x1410 net/batman-adv/bat_iv_ogm.c:843
Code: 80 3c 28 00 0f 85 ee 05 00 00 4d 8b 3f 49 81 ff e0 e9 4e 8d 0f 84 dd 02 00 00 e8 bd 80 ae f9 49 8d 7f 70 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 af 06 00 00 48 8b 44 24 08 49 8b 6f 70 80 38
RSP: 0018:ffffc90004e97b98 EFLAGS: 00010202
RAX: 000000000000000e RBX: ffff8880a7471800 RCX: ffffffff87c5394d
RDX: ffff88804cf02380 RSI: ffffffff87c536a3 RDI: 0000000000000070
RBP: 0000000000077000 R08: 0000000000000001 R09: ffff8880a875a02b
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000007
R13: dffffc0000000000 R14: ffff888051ad4c40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000400200 CR3: 0000000061cac000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:869 [inline]
 batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:862 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x5c8/0x800 net/batman-adv/bat_iv_ogm.c:1722
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Modules linked in:
---[ end trace f5c5eda032070cd1 ]---
RIP: 0010:batadv_iv_ogm_schedule_buff+0xd1e/0x1410 net/batman-adv/bat_iv_ogm.c:843
Code: 80 3c 28 00 0f 85 ee 05 00 00 4d 8b 3f 49 81 ff e0 e9 4e 8d 0f 84 dd 02 00 00 e8 bd 80 ae f9 49 8d 7f 70 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 af 06 00 00 48 8b 44 24 08 49 8b 6f 70 80 38
RSP: 0018:ffffc90004e97b98 EFLAGS: 00010202
RAX: 000000000000000e RBX: ffff8880a7471800 RCX: ffffffff87c5394d
RDX: ffff88804cf02380 RSI: ffffffff87c536a3 RDI: 0000000000000070
RBP: 0000000000077000 R08: 0000000000000001 R09: ffff8880a875a02b
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000007
R13: dffffc0000000000 R14: ffff888051ad4c40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000400200 CR3: 000000009480d000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
