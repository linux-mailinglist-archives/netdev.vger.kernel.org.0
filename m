Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292BC209A6B
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 09:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbgFYHTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 03:19:17 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54437 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgFYHTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 03:19:16 -0400
Received: by mail-io1-f69.google.com with SMTP id t23so3381783iog.21
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 00:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tBweWrlp9QBdM+tZJ8oYCBFdvpoaRXNosMtfX1KU8uk=;
        b=noSTC+MlePpjSTyc30+bIFAPSK06iae/LTx1CEdYOktct71Vmrk5vlR1wmezOse98G
         rbAdOxhSe7Do30JUqcDeq4ISz/ebEAbBajJkZxivSi/YW9xqIIQo2zeC7W1MmH1dRJQs
         FcbcBGdQ4eOgLAOEyCkYEfh/8a7c2i7qdjzc/wlWrZk663+cKP15Q3WmNC8yRS1shN/2
         1CVaIFNJQVpFPe0pHK2kZ2vVMVBi6OoMDgqwL+k9xo13DHe9uidrRlvCOoA2yyjtgPK9
         dh1H7C/ZLAtuI9aDcHOrbbPKR2jcTdtrdv/6bNabY3vueT2AqCxf2bc9eHs2WITmJjdo
         r3oA==
X-Gm-Message-State: AOAM531BX7Fz31VNlpdcvkPCvw8JvzvSOvRjAahAs8xX5/sqWeThGh1B
        1p1WZ/mmsuHGoBN+cKbno70ZfvECQrXnCOBZDP2PXn8JKdVN
X-Google-Smtp-Source: ABdhPJwzCFOYiSBWVs8Rm1FraN7MIhBCXwPciVJCXKG9L24PaYiDFoux9SeA1zjfdHygR4LG93HTBpk60+aM3SvzJ0wg1BeD7CmA
MIME-Version: 1.0
X-Received: by 2002:a6b:1496:: with SMTP id 144mr28476498iou.6.1593069554767;
 Thu, 25 Jun 2020 00:19:14 -0700 (PDT)
Date:   Thu, 25 Jun 2020 00:19:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea237605a8e368a9@google.com>
Subject: WARNING in idr_alloc
From:   syzbot <syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ddb429100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=f31428628ef672716ea8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15252c4b100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10159291100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f31428628ef672716ea8@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6830 at lib/idr.c:84 idr_alloc+0x11c/0x130 lib/idr.c:84
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6830 Comm: syz-executor583 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:105 [inline]
 fixup_bug arch/x86/kernel/traps.c:100 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:197
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:216
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:idr_alloc+0x11c/0x130 lib/idr.c:84
Code: 00 00 00 44 89 e0 48 8b 4c 24 58 65 48 33 0c 25 28 00 00 00 75 1e 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 b4 6d c4 fd <0f> 0b 41 bc ea ff ff ff eb b7 e8 f5 6c 95 fd 0f 1f 44 00 00 41 57
RSP: 0018:ffffc90001077c68 EFLAGS: 00010293
RAX: ffff88809f48a580 RBX: 00000000ffff0301 RCX: ffffffff83af606b
RDX: 0000000000000000 RSI: ffffffff83af610c RDI: 0000000000000005
RBP: 1ffff9200020ef8d R08: ffff88809f48a580 R09: fffffbfff1516d79
R10: ffffffff8a8b6bc7 R11: fffffbfff1516d78 R12: 00000000ffff0300
R13: ffffffff8a837ae0 R14: ffff8880a1f7d640 R15: 0000000000000a20
 qrtr_port_assign net/qrtr/qrtr.c:703 [inline]
 __qrtr_bind.isra.0+0x12e/0x5c0 net/qrtr/qrtr.c:756
 qrtr_bind+0x1c1/0x24a net/qrtr/qrtr.c:805
 __sys_bind+0x20e/0x250 net/socket.c:1657
 __do_sys_bind net/socket.c:1668 [inline]
 __se_sys_bind net/socket.c:1666 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1666
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4401a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffee5bbb0e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401a9
RDX: 000000000000000c RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a30
R13: 0000000000401ac0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
