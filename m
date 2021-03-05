Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E02E32ECF2
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhCEOQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:16:50 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:38916 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhCEOQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 09:16:18 -0500
Received: by mail-il1-f200.google.com with SMTP id v20so1762672ile.6
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 06:16:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mfuOjp5Z/tGbKX0ZKWisF3TPUViTIoNQsTJvHl29QCM=;
        b=b2DGmLhHDU9j9hAY9agCXa2AQ2HfbOFCdcVrNfdX+GbGiDY1OXxyrbozUWYZ0GU0rm
         60sXCcUcipkDiScJOjx04JA56nO4syPjUQlJVlnTnlmaukY5T2y1U1OrHyfkTn8DFNIA
         LPEKuTFSSQfBWVy6DxxkaTB+zEG3wua6Sl2F7s+3x//SZ2rmh9lB9mfw0IbYurXUo6+M
         PJL5Y+iXuqn2gCnrdwxaLYWERol5ZOqxFyBW2I+XRT3fe8mtSCjO0CvXkc3Ft7ONNuK5
         Y/+4M55Axu6sPpLNzrCCOkZaHnGJK9qpwVzHIMj7MpfUNYT3shPh+JFQxD/5guMpFlGd
         LD4A==
X-Gm-Message-State: AOAM533bDhNbAb9jCCFJh5R1xqA2Md+wV+jDSY0Lm1oowIO5puSkQ3dQ
        0ayji6YNG9o6QtoRK084Tl5peadOn9Ua152RnT4Q7HpDqITq
X-Google-Smtp-Source: ABdhPJzhdCq+OH0uPbJie7DVKf0NBMi9zf6Wfy1m090wcIwuVEoGT7KE2S/Eu7tE0V4njvSY+0tij0PUmqywZ+ENf9/nEVi5HfOf
MIME-Version: 1.0
X-Received: by 2002:a02:7f8c:: with SMTP id r134mr10057299jac.95.1614953775992;
 Fri, 05 Mar 2021 06:16:15 -0800 (PST)
Date:   Fri, 05 Mar 2021 06:16:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002592aa05bccabae5@google.com>
Subject: [syzbot] WARNING in carl9170_usb_send_rx_irq_urb/usb_submit_urb
From:   syzbot <syzbot+0ae4804973be759fa420@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, chunkeey@googlemail.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fe07bfda Linux 5.12-rc1
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=12020056d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fd36f4f4a84d245c
dashboard link: https://syzkaller.appspot.com/bug?extid=0ae4804973be759fa420
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111b8c42d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131dcb7f500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0ae4804973be759fa420@syzkaller.appspotmail.com

usb 1-1: reset high-speed USB device number 2 using dummy_hcd
usb 1-1: device descriptor read/64, error -71
usb 1-1: Using ep0 maxpacket: 8
usb 1-1: driver   API: 1.9.9 2016-02-15 [1-1]
usb 1-1: firmware API: 1.9.6 2012-07-07
------------[ cut here ]------------
usb 1-1: BOGUS urb xfer, pipe 1 != type 3
WARNING: CPU: 1 PID: 32 at drivers/usb/core/urb.c:493 usb_submit_urb+0xd27/0x1540 drivers/usb/core/urb.c:493
Modules linked in:
CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.12.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
RIP: 0010:usb_submit_urb+0xd27/0x1540 drivers/usb/core/urb.c:493
Code: 84 d4 02 00 00 e8 69 99 b8 fd 4c 89 ef e8 d1 cd 1c ff 41 89 d8 44 89 e1 4c 89 f2 48 89 c6 48 c7 c7 00 02 62 86 e8 39 e9 fa 01 <0f> 0b e9 81 f8 ff ff e8 3d 99 b8 fd 48 81 c5 30 06 00 00 e9 ad f7
RSP: 0018:ffffc900001f7bb0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff8881008e0000 RSI: ffffffff812964e3 RDI: fffff5200003ef68
RBP: ffff888116f510a0 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff8149dffb R11: 0000000000000000 R12: 0000000000000001
R13: ffff888116f500a0 R14: ffff8881057a4000 R15: ffff88810256d300
FS:  0000000000000000(0000) GS:ffff8881f6b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb73282f000 CR3: 0000000105642000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 carl9170_usb_send_rx_irq_urb+0x273/0x340 drivers/net/wireless/ath/carl9170/usb.c:504
 carl9170_usb_init_device drivers/net/wireless/ath/carl9170/usb.c:939 [inline]
 carl9170_usb_firmware_finish drivers/net/wireless/ath/carl9170/usb.c:999 [inline]
 carl9170_usb_firmware_step2+0x1b9/0x290 drivers/net/wireless/ath/carl9170/usb.c:1028
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1079
 process_one_work+0x98d/0x1580 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x38c/0x460 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
