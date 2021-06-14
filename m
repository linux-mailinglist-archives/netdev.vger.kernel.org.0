Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AFC3A63B8
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhFNLQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:16:28 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:48774 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhFNLOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:14:23 -0400
Received: by mail-io1-f72.google.com with SMTP id u19-20020a6be3130000b02904a77f550cbcso23513270ioc.15
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 04:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NeLkXXASh21M69mAfwaOBicjaWen+btZJMPkBkicr9U=;
        b=aLeUmsDb2uE2yyV1Ea7vRGvYJU6l6XpFNuVO1Ma1vmdshfeMnoqtAT+rwkjeKNcuQ3
         WF5EBDihohNDbIXZSgHsMbB72qX0t9jNJm8XbUsAqP2Fa56xjYWcNQqurah//WkzyBPo
         uvYdow0k/pAskKypGkobh4FBZU7ADo1QYYWbSGeMCaxCYF+dcC3xIKw+lk6A8gJOQp8y
         6IBtkQzDfXEgeKNhRX46NNVRwMZL//v003n8k3USghOCAJkAXSO3EvtD9qbInw4NP1K3
         84DucPpzGVjZwKxs+DvGeKI36q4KVxGTMmHPyzrPJRjrUhhxTSps9P7BrnDkqhhuCwx4
         urUw==
X-Gm-Message-State: AOAM533+/GKNszUbmZjtXB14C3B9392Pe0I5+p2DnU5C1u7LKfd8Lntp
        eeDbZE4dBhMRbtX1Hbh2cqN5GybT2E2X3qY7A4jO9jqX5mv7
X-Google-Smtp-Source: ABdhPJxomWz0H427AcDUAWX1WQpbscXIHwlYAOFYZDEwUW8frxVyLHSC+3M7w4ggUvSf0/Aw7apxIxsZ6u/F8vbsTtF2C5kbaIZU
MIME-Version: 1.0
X-Received: by 2002:a05:6638:168d:: with SMTP id f13mr16430226jat.124.1623669140859;
 Mon, 14 Jun 2021 04:12:20 -0700 (PDT)
Date:   Mon, 14 Jun 2021 04:12:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fb5a005c4b7ee3f@google.com>
Subject: [syzbot] INFO: trying to register non-static key in ath9k_wmi_event_tasklet
From:   syzbot <syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com>
To:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e89bb428 usb: gadget: u_audio: add real feedback implement..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=124450f7d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=33d364f85e0000cd
dashboard link: https://syzkaller.appspot.com/bug?extid=31d54c60c5b254d6f75b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1205b4ebd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=148b2570300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+31d54c60c5b254d6f75b@syzkaller.appspotmail.com

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x143/0x1db lib/dump_stack.c:120
 assign_lock_key kernel/locking/lockdep.c:937 [inline]
 register_lock_class+0x1077/0x1180 kernel/locking/lockdep.c:1249
 __lock_acquire+0x102/0x5230 kernel/locking/lockdep.c:4781
 lock_acquire kernel/locking/lockdep.c:5512 [inline]
 lock_acquire+0x19d/0x700 kernel/locking/lockdep.c:5477
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
 _raw_spin_lock_bh+0x2f/0x40 kernel/locking/spinlock.c:175
 spin_lock_bh include/linux/spinlock.h:359 [inline]
 ath9k_wmi_event_tasklet+0x231/0x3f0 drivers/net/wireless/ath/ath9k/wmi.c:172
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
 __do_softirq+0x1b0/0x944 kernel/softirq.c:559
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x21/0x50 kernel/softirq.c:913
 smpboot_thread_fn+0x3ec/0x870 kernel/smpboot.c:165
 kthread+0x38c/0x460 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
------------[ cut here ]------------
WARNING: CPU: 0 PID: 10 at drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:656 ath9k_htc_txstatus+0x3bb/0x500 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:656
Modules linked in:
CPU: 0 PID: 10 Comm: ksoftirqd/0 Not tainted 5.13.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ath9k_htc_txstatus+0x3bb/0x500 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:656
Code: de e8 69 6c 3d fe 84 db 75 27 e8 c0 65 3d fe 48 89 ef 48 83 c4 38 5b 5d 41 5c 41 5d 41 5e 41 5f e9 7a be b3 02 e8 a5 65 3d fe <0f> 0b e9 36 fd ff ff e8 99 65 3d fe 49 8d 7c 24 08 41 83 e5 fe 48
RSP: 0018:ffffc900000afce0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: ffff888100289b40 RSI: ffffffff8303b1eb RDI: 0000000000000003
RBP: ffff888119fe480d R08: 0000000000000000 R09: 000000000000001c
R10: ffffffff8303af1e R11: 000000000000000c R12: ffff88811d52b1e0
R13: 000000000000001c R14: ffff888119fe480c R15: ffff888119fe480c
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001038 CR3: 0000000007825000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ath9k_wmi_event_tasklet+0x306/0x3f0 drivers/net/wireless/ath/ath9k/wmi.c:179
 tasklet_action_common.constprop.0+0x201/0x2e0 kernel/softirq.c:784
 __do_softirq+0x1b0/0x944 kernel/softirq.c:559
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x21/0x50 kernel/softirq.c:913
 smpboot_thread_fn+0x3ec/0x870 kernel/smpboot.c:165
 kthread+0x38c/0x460 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
