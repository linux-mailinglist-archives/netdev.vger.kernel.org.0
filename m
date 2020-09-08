Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873F5260C13
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 09:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgIHHd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 03:33:29 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:33960 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729489AbgIHHdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 03:33:21 -0400
Received: by mail-il1-f208.google.com with SMTP id m1so11437811ilg.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 00:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BOREg4ynb+fPnN3e6LDGE1Wyh7kbbVZvm+CMgLSzhTY=;
        b=uGleFxsXZDSBax6PNHOyBIQb13/6RM54/pmmjV9fIL9bYyw1CdLwtKsyDKicf22Sy6
         YSVpXsI4/a3g7D4X3SYaP8JWFDGSI8oUy8fqMBdzUuU/OiOCAh6lDkgpOEi/VHsxpISc
         hazTxQ1kuNiH4VyBhWIMIq/VafilgxOGsYaUHXloO2sZWYE4K2TaXWxpEtFWXXLIzOtA
         5bKg0wfiFFZQ/IwicFWCAGaXP+1Zfk8pLjhMXDh7IrKvQy+uGTbd7DqWBVAxG0bPUx6Q
         pSd7JUbagOSFwOgmyqfSLewzhnVcizfFw4zNurU2V5In+2g2jrVTSSDihMsBl4WD4jOQ
         dLxw==
X-Gm-Message-State: AOAM532pjntJmoIJ6qIKKRCniVLgore+cpBsFoXVE8kQPjwz7bUoXSly
        kmBl88qcWWT5ahhS7M+N8BPxbGM72eM3s8Xl+703ee4VEjUK
X-Google-Smtp-Source: ABdhPJwaTImHa51NL/wpTIwANersbSYjuM915z1X5HNmgz9VWgEKlDBrYRSzvTFLD0PjXXNrskhwTGUMvkvCt9jKLsX2U7M894mG
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1381:: with SMTP id w1mr1167608jad.34.1599550399784;
 Tue, 08 Sep 2020 00:33:19 -0700 (PDT)
Date:   Tue, 08 Sep 2020 00:33:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000061311205aec85935@google.com>
Subject: WARNING: refcount bug in smc_release (3)
From:   syzbot <syzbot+8b963fe6ec74e5dac8d7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    15bc20c6 Merge tag 'tty-5.9-rc3' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=114602f2900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978db74cb30aa994
dashboard link: https://syzkaller.appspot.com/bug?extid=8b963fe6ec74e5dac8d7
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8b963fe6ec74e5dac8d7@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 28422 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 28422 Comm: syz-executor.3 Not tainted 5.9.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Code: 07 31 ff 89 de e8 97 d2 d8 fd 84 db 0f 85 36 ff ff ff e8 4a d6 d8 fd 48 c7 c7 a0 da 93 88 c6 05 43 e5 11 07 01 e8 39 e7 a9 fd <0f> 0b e9 17 ff ff ff e8 2b d6 d8 fd 0f b6 1d 28 e5 11 07 31 ff 89
RSP: 0018:ffffc90017fafdd8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff8880477d43c0 RSI: ffffffff815dafc7 RDI: fffff52002ff5fad
RBP: 0000000000000002 R08: 0000000000000001 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 0000000000000001 R12: ffff888084ef0540
R13: ffff88800011aa80 R14: ffff888084ef0558 R15: 0000000000000000
 refcount_add include/linux/refcount.h:204 [inline]
 refcount_inc include/linux/refcount.h:241 [inline]
 sock_hold include/net/sock.h:692 [inline]
 smc_release+0x41d/0x490 net/smc/af_smc.c:180
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:141
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:140 [inline]
 exit_to_user_mode_prepare+0x195/0x1c0 kernel/entry/common.c:167
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:242
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x416f01
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:000000000169fbe0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000416f01
RDX: 0000000000000000 RSI: 000000000000097b RDI: 0000000000000004
RBP: 0000000000000001 R08: 0000000000d9297a R09: 0000000000d9297e
R10: 000000000169fcd0 R11: 0000000000000293 R12: 000000000118d940
R13: 000000000118d940 R14: ffffffffffffffff R15: 000000000118cfec
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
