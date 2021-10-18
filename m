Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE744326E7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhJRS5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:57:38 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:46835 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbhJRS5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:57:37 -0400
Received: by mail-il1-f198.google.com with SMTP id x18-20020a92cc92000000b00259b4330356so217414ilo.13
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 11:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LEuQNBXA2QSHyG2FFuW1GY85kj8UYs2cybPjHqEVaBA=;
        b=GrYj3O41snB74U6wtg/v/FRGkwWd+sT5gucHFRc9SwiNJScGTVPDrsUhFx5VBqu94j
         /OlATqv6PQftPlxWpmItJe4O4MLqNv94OAUg+mJqgiQHMqOKk4tBO0/fDxi6bMbt1ibh
         Z45zzbyfEvUO96MxrlHEs6cDpRZbiyKe8+YZz00N4Czetb84XdWJsfXlKg6auiiemTBq
         gXmd5PI5ORBea/hqdqWPe9W2eOq8c+bND12nNuWdPoiQuK+Dua/zXCj8zwC4FvuLQcir
         VxeenTIfq67HCCuCK3xpMmRRLbXF5BSJ39hWJ49Q7A0IjgjycpXvU2U0HWmkYsYElunO
         aZxA==
X-Gm-Message-State: AOAM531wNXAnaAtJphOoOgIMtx/jMk6+3stx0N/Y5ESTx0DOIZz6JY20
        vq33eMh57tYVhTy9VCbFyAp/hkOUhyIhQriZlEkkVMd/E4Ke
X-Google-Smtp-Source: ABdhPJzBQm9vnItv5AjMF+8O36wDdkxupDFx2kmIwodvJkYtz5hK2c6EVu6+2d37FrHKB+EerZ6UjcOhGAbt0pwfXkD4J+0s8yeD
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca9:: with SMTP id x9mr15554294ill.60.1634583325778;
 Mon, 18 Oct 2021 11:55:25 -0700 (PDT)
Date:   Mon, 18 Oct 2021 11:55:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007d2d6405cea5163b@google.com>
Subject: [syzbot] divide error in mwifiex_usb_dnld_fw
From:   syzbot <syzbot+4e7b6c94d22f4bfca9a0@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, davem@davemloft.net, ganapathi017@gmail.com,
        huxinming820@gmail.com, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sharvari.harisangam@nxp.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    660a92a59b9e usb: xhci: Enable runtime-pm by default on AM..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=13844eecb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5016916cdc0a4a84
dashboard link: https://syzkaller.appspot.com/bug?extid=4e7b6c94d22f4bfca9a0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122d9278b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143499ecb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4e7b6c94d22f4bfca9a0@syzkaller.appspotmail.com

divide error: 0000 [#1] SMP KASAN
CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events request_firmware_work_func
RIP: 0010:mwifiex_write_data_sync drivers/net/wireless/marvell/mwifiex/usb.c:696 [inline]
RIP: 0010:mwifiex_prog_fw_w_helper drivers/net/wireless/marvell/mwifiex/usb.c:1437 [inline]
RIP: 0010:mwifiex_usb_dnld_fw+0xabd/0x11a0 drivers/net/wireless/marvell/mwifiex/usb.c:1518
Code: 00 00 00 48 8d bb 70 01 00 00 48 89 f8 48 c1 e8 03 42 0f b6 04 28 84 c0 74 08 3c 03 0f 8e c2 04 00 00 8b 44 24 10 31 d2 31 ff <f7> b3 70 01 00 00 89 d6 89 54 24 20 e8 f2 e9 00 fe 8b 54 24 20 8b
RSP: 0018:ffffc9000012f9b0 EFLAGS: 00010246
RAX: 0000000000000014 RBX: ffff88810a724028 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8340e60c RDI: 0000000000000000
RBP: ffff88810a8af800 R08: 0000000000000000 R09: ffff88810a8af800
R10: ffffffff8340e5d2 R11: 0000000000000000 R12: 0000000000000003
R13: dffffc0000000000 R14: ffffc9000012fa58 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc8edc7c70 CR3: 000000010d046000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 _mwifiex_fw_dpc+0x181/0x10a0 drivers/net/wireless/marvell/mwifiex/main.c:542
 request_firmware_work_func+0x12c/0x230 drivers/base/firmware_loader/main.c:1081
 process_one_work+0x9bf/0x1620 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3c2/0x4a0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 461e13770bd5d6b4 ]---
RIP: 0010:mwifiex_write_data_sync drivers/net/wireless/marvell/mwifiex/usb.c:696 [inline]
RIP: 0010:mwifiex_prog_fw_w_helper drivers/net/wireless/marvell/mwifiex/usb.c:1437 [inline]
RIP: 0010:mwifiex_usb_dnld_fw+0xabd/0x11a0 drivers/net/wireless/marvell/mwifiex/usb.c:1518
Code: 00 00 00 48 8d bb 70 01 00 00 48 89 f8 48 c1 e8 03 42 0f b6 04 28 84 c0 74 08 3c 03 0f 8e c2 04 00 00 8b 44 24 10 31 d2 31 ff <f7> b3 70 01 00 00 89 d6 89 54 24 20 e8 f2 e9 00 fe 8b 54 24 20 8b
RSP: 0018:ffffc9000012f9b0 EFLAGS: 00010246
RAX: 0000000000000014 RBX: ffff88810a724028 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8340e60c RDI: 0000000000000000
RBP: ffff88810a8af800 R08: 0000000000000000 R09: ffff88810a8af800
R10: ffffffff8340e5d2 R11: 0000000000000000 R12: 0000000000000003
R13: dffffc0000000000 R14: ffffc9000012fa58 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc8edc7c70 CR3: 000000010d046000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	00 48 8d             	add    %cl,-0x73(%rax)
   5:	bb 70 01 00 00       	mov    $0x170,%ebx
   a:	48 89 f8             	mov    %rdi,%rax
   d:	48 c1 e8 03          	shr    $0x3,%rax
  11:	42 0f b6 04 28       	movzbl (%rax,%r13,1),%eax
  16:	84 c0                	test   %al,%al
  18:	74 08                	je     0x22
  1a:	3c 03                	cmp    $0x3,%al
  1c:	0f 8e c2 04 00 00    	jle    0x4e4
  22:	8b 44 24 10          	mov    0x10(%rsp),%eax
  26:	31 d2                	xor    %edx,%edx
  28:	31 ff                	xor    %edi,%edi
* 2a:	f7 b3 70 01 00 00    	divl   0x170(%rbx) <-- trapping instruction
  30:	89 d6                	mov    %edx,%esi
  32:	89 54 24 20          	mov    %edx,0x20(%rsp)
  36:	e8 f2 e9 00 fe       	callq  0xfe00ea2d
  3b:	8b 54 24 20          	mov    0x20(%rsp),%edx
  3f:	8b                   	.byte 0x8b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
