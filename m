Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1296D257FE9
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 19:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgHaRsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 13:48:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:42143 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgHaRsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 13:48:16 -0400
Received: by mail-il1-f200.google.com with SMTP id f67so5705961ilf.9
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 10:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=S4zxagtdMiMS38gDJ8vKb9tchQO6uFhBxEUM3W1CRWw=;
        b=dnkFmDelhIWjbCRUkMvT+0Yi+s1t6Vor27YTSmPW+bl1Nd8PmgUhzLhdvucKR+Lih5
         rZlByT1qAqQGNJKORfvIYkpmAjk1ljp8HbafjWa8uNBh1IUbCin/KNJje+96+27vCikb
         ZrEmLmGE728I2DG72uiOXwNdMZkKvAGwS6Ers2UQH0v649Z9qSEqzi/CUFj/sYezeIq0
         rqUv7MrZfHJ6vczvsw+MqvIFGl/diWmZE+SuzHAqQoZkQQmeL5KtAypearmhwdxhRiRW
         /J+xnq4FObecHzB+9LtnKkJNZzRVr0ZCtBtRrRJhWJrO8WhZSsBhuuCvC5qyk49prSZ4
         BIPw==
X-Gm-Message-State: AOAM530Ap369X75c29WcYLPa0wV85DqrPMWfFVofYqfxmujPvjXHsG5U
        RyhMPs1zxdKwXG3j5fidvS3F2PurmHITRckRr7PWLla5pCiD
X-Google-Smtp-Source: ABdhPJwsEP2eLKtWK98JkeZmegMcYiQ+sapec74Z7A9VuQgqb2fFPcX8An2u5gM78u+kioBuh7fUqbSLoT8xIUDh91A/1g0DVNl8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:cd4:: with SMTP id c20mr2443555ilj.0.1598896095201;
 Mon, 31 Aug 2020 10:48:15 -0700 (PDT)
Date:   Mon, 31 Aug 2020 10:48:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c98d7205ae300144@google.com>
Subject: WARNING in idr_get_next
From:   syzbot <syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4d41ead6 Merge tag 'block-5.9-2020-08-28' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=140e7569900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=891ca5711a9f1650
dashboard link: https://syzkaller.appspot.com/bug?extid=f7204dcf3df4bb4ce42c
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a1352e900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11fdaf41900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6839 at lib/idr.c:269 idr_get_next+0x33a/0x3a0 lib/idr.c:269
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6839 Comm: syz-executor121 Not tainted 5.9.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:idr_get_next+0x33a/0x3a0 lib/idr.c:269
Code: 6b 89 2b 65 48 8b 04 25 28 00 00 00 48 3b 44 24 58 75 72 4c 89 f8 48 83 c4 60 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 86 5b b7 fd <0f> 0b 45 31 ff eb d2 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c f7 fc
RSP: 0018:ffffc9000291fd40 EFLAGS: 00010293
RAX: ffffffff83bd9c9a RBX: ffffc9000291fde4 RCX: ffff8880a899a100
RDX: 0000000000000000 RSI: 00000000fffffffc RDI: 000000007fffffff
RBP: 00000000fffffffc R08: ffffffff83bd9c56 R09: fffffbfff13114f8
R10: fffffbfff13114f8 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff92000523faf R14: ffff8880aa0175c8 R15: ffff8880a9622040
 qrtr_reset_ports net/qrtr/qrtr.c:734 [inline]
 __qrtr_bind+0x58a/0x7d0 net/qrtr/qrtr.c:777
 qrtr_bind+0x115/0x1a0 net/qrtr/qrtr.c:813
 __sys_bind+0x283/0x360 net/socket.c:1656
 __do_sys_bind net/socket.c:1667 [inline]
 __se_sys_bind net/socket.c:1665 [inline]
 __x64_sys_bind+0x76/0x80 net/socket.c:1665
 do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441239
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 1b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe6f268cc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441239
RDX: 000000000000000c RSI: 0000000020000140 RDI: 0000000000000003
RBP: 000000000000aca5 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000401fe0
R13: 0000000000402070 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
