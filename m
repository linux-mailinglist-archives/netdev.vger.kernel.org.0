Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B225D1603B9
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgBPKtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:49:20 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:35035 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgBPKtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:49:18 -0500
Received: by mail-il1-f200.google.com with SMTP id h18so11866804ilc.2
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 02:49:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2aqq2XF7vHvzjgpHSz+9+O0Q0trixBJldu6u6JkJB9U=;
        b=CG2BLwuC8SM+/IWD1iTasb3exD5FnQCBPHrqKt3ypncTtPtdPFDCsHjqScHUU9LK2I
         ws6h2WHhey/O7HO7Sd+gmIiRgtBxYjpmZQx/B3c35ndnbveWP+33b2JauS0zwgUqcDWX
         g8WsZH4PxY+7/d7InI21MnVPOs7qLlRHS49W+KAbIfbS1b6NAkmI/LrDWNHVIyAs0O+j
         oNpeTfe+U8qYXfXNahS1DreASbG0zqfuNVHft6sCg/OFQalwq7kf/70x14uxIUem8RJU
         UJGLqL3/HaUjBtd/UoemOix0vZG/V8knfK30GQJU3rsmZ6IND6f8rSbF+DxKKt573gBN
         iECA==
X-Gm-Message-State: APjAAAWrBVBM4parJE2WwvqGgfhPOhkI9CQNWr3XotaKW/jd63Q3b/MD
        eKe6G+pgAc27598DdQv1hVvV7/lQn/fKN4pzbx4NEh6j5FR5
X-Google-Smtp-Source: APXvYqwQ4/8IRNI8rEMC7zWuoZsEtYT7tQT0LiQd27UwhrJAfS7WmkDDfVns5x/fSmBpvfZPVeVCzs9/NgksJjTSCs6q6ro39roT
MIME-Version: 1.0
X-Received: by 2002:a02:9f06:: with SMTP id z6mr8467362jal.2.1581850156460;
 Sun, 16 Feb 2020 02:49:16 -0800 (PST)
Date:   Sun, 16 Feb 2020 02:49:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a9f57e059eaf30a6@google.com>
Subject: general protection fault in batadv_iv_ogm_schedule_buff
From:   syzbot <syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com>
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

HEAD commit:    2019fc96 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ebaae6e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=735296e4dd620b10
dashboard link: https://syzkaller.appspot.com/bug?extid=a98f2016f40b9cd3818a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 21 Comm: kworker/u4:1 Not tainted 5.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
RIP: 0010:batadv_iv_ogm_schedule_buff+0x3f4/0x12d0 net/batman-adv/bat_iv_ogm.c:814
Code: c1 ea 03 80 3c 02 00 0f 85 e5 0d 00 00 4d 8b a7 88 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 16 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 b8
RSP: 0018:ffffc90000dd7bb8 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffff1101537d9c1
RDX: 0000000000000002 RSI: ffffffff87cc2c28 RDI: 0000000000000016
RBP: ffffc90000dd7ca8 R08: 0000000000000004 R09: ffff8880a9bece10
R10: fffffbfff154b460 R11: ffffffff8aa5a307 R12: 0000000000000000
R13: 0000000000000001 R14: ffffc90000dd7c40 R15: ffff8880a9aa0800
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000008f5a3000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:865 [inline]
 batadv_iv_ogm_schedule net/batman-adv/bat_iv_ogm.c:858 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x5da/0x7c0 net/batman-adv/bat_iv_ogm.c:1718
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 101b07e3062bfd0c ]---
RIP: 0010:batadv_iv_ogm_schedule_buff+0x3f4/0x12d0 net/batman-adv/bat_iv_ogm.c:814
Code: c1 ea 03 80 3c 02 00 0f 85 e5 0d 00 00 4d 8b a7 88 00 00 00 48 b8 00 00 00 00 00 fc ff df 49 8d 7c 24 16 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 b8
RSP: 0018:ffffc90000dd7bb8 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffff1101537d9c1
RDX: 0000000000000002 RSI: ffffffff87cc2c28 RDI: 0000000000000016
RBP: ffffc90000dd7ca8 R08: 0000000000000004 R09: ffff8880a9bece10
R10: fffffbfff154b460 R11: ffffffff8aa5a307 R12: 0000000000000000
R13: 0000000000000001 R14: ffffc90000dd7c40 R15: ffff8880a9aa0800
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000009d9e7000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
