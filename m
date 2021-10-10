Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A29427F49
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 08:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhJJFuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 01:50:16 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:49940 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhJJFuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 01:50:15 -0400
Received: by mail-io1-f69.google.com with SMTP id l17-20020a05660227d100b005d6609eb90eso11041372ios.16
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 22:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vnylaAlek/RnETPU/gLVv7pkFuQefb+xmD8wuU/Fupw=;
        b=WGUYxLRtuYBJm9LWDX/zfYQhVomiQR+2epvG/JhwGUJZ7H5JyWnbo4hly6mEDA6pGd
         zddsLF4J3xbzU2WlBfYTkdy07jTowqCfndOzPt+sBhnu/Wbd/C4I5fU5qsCe/8MnczZU
         +KlbPWAV3blvgq+gRSkPUx1R4yJWHnv00IxEWQtotEdxUU/rnOnKuRuxOgANYGbTeyCC
         I4u0PCEaQ4c0Q8drJ+ALTN/I9lpUSJPUzF6eftB0+KjuJGh+M3ACDAck/Umba/yN2CgT
         /UuGQ7TpZbTM7sEFLIwSjtw2Nb3bPbUns4FH1hCDLre5WsJFj0PMS66r7g/fADg2ryVe
         RwpA==
X-Gm-Message-State: AOAM532ezzYRfJehiXbjeQwQHyLOCn+x2j0wY5/ACPoJSE4GBXwLC4Rj
        RSXcIoCRgTU3D7wJ0/31OKUc+FrnuBUd2nNXdmDcWpBQkSPD
X-Google-Smtp-Source: ABdhPJy4XStPum9lPNXCXOp5SF7t26m6SzT4V7I5Kn8xHmMymQHjMiHrtBW3zWexzRaXSupAeNZE50N3S03Spdz9S+3bIqGfSpLd
MIME-Version: 1.0
X-Received: by 2002:a92:1a10:: with SMTP id a16mr13485130ila.116.1633844897437;
 Sat, 09 Oct 2021 22:48:17 -0700 (PDT)
Date:   Sat, 09 Oct 2021 22:48:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000baddc805cdf928c3@google.com>
Subject: [syzbot] KMSAN: uninit-value in p9pdu_readf
From:   syzbot <syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        glider@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c7f84f4e1147 kmsan: core: do not touch interrupts when ent..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=118e86a8b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=978f1b2d7a5aad3e
dashboard link: https://syzkaller.appspot.com/bug?extid=06472778c97ed94af66d
compiler:       clang version 14.0.0 (git@github.com:llvm/llvm-project.git 0996585c8e3b3d409494eb5f1cad714b9e1f7fb5), GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+06472778c97ed94af66d@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in p9pdu_vreadf net/9p/protocol.c:147 [inline]
BUG: KMSAN: uninit-value in p9pdu_readf+0x46cf/0x4fc0 net/9p/protocol.c:526
 p9pdu_vreadf net/9p/protocol.c:147 [inline]
 p9pdu_readf+0x46cf/0x4fc0 net/9p/protocol.c:526
 p9pdu_vreadf net/9p/protocol.c:198 [inline]
 p9pdu_readf+0x2080/0x4fc0 net/9p/protocol.c:526
 p9_client_stat+0x2b3/0x710 net/9p/client.c:1724
 v9fs_mount+0xc14/0x12c0 fs/9p/vfs_super.c:170
 legacy_get_tree+0x163/0x2e0 fs/fs_context.c:610
 vfs_get_tree+0xd8/0x5d0 fs/super.c:1498
 do_new_mount+0x7bc/0x1680 fs/namespace.c:2988
 path_mount+0x106f/0x2960 fs/namespace.c:3318
 do_mount fs/namespace.c:3331 [inline]
 __do_sys_mount fs/namespace.c:3539 [inline]
 __se_sys_mount+0x8eb/0xa10 fs/namespace.c:3516
 __ia32_sys_mount+0x157/0x1b0 fs/namespace.c:3516
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Local variable ----ecode@p9_check_errors created at:
 p9_check_errors+0x68/0xb90 net/9p/client.c:506
 p9_client_rpc+0xd90/0x1410 net/9p/client.c:801
=====================================================
Kernel panic - not syncing: panic_on_kmsan set ...
CPU: 0 PID: 31201 Comm: syz-executor.3 Tainted: G    B   W         5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1ff/0x28e lib/dump_stack.c:106
 dump_stack+0x25/0x28 lib/dump_stack.c:113
 panic+0x44f/0xdeb kernel/panic.c:232
 kmsan_report+0x2ee/0x300 mm/kmsan/report.c:168
 __msan_warning+0xa9/0xf0 mm/kmsan/instrumentation.c:199
 p9pdu_vreadf net/9p/protocol.c:147 [inline]
 p9pdu_readf+0x46cf/0x4fc0 net/9p/protocol.c:526
 p9pdu_vreadf net/9p/protocol.c:198 [inline]
 p9pdu_readf+0x2080/0x4fc0 net/9p/protocol.c:526
 p9_client_stat+0x2b3/0x710 net/9p/client.c:1724
 v9fs_mount+0xc14/0x12c0 fs/9p/vfs_super.c:170
 legacy_get_tree+0x163/0x2e0 fs/fs_context.c:610
 vfs_get_tree+0xd8/0x5d0 fs/super.c:1498
 do_new_mount+0x7bc/0x1680 fs/namespace.c:2988
 path_mount+0x106f/0x2960 fs/namespace.c:3318
 do_mount fs/namespace.c:3331 [inline]
 __do_sys_mount fs/namespace.c:3539 [inline]
 __se_sys_mount+0x8eb/0xa10 fs/namespace.c:3516
 __ia32_sys_mount+0x157/0x1b0 fs/namespace.c:3516
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf6ef3549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
RSP: 002b:00000000f44ed5fc EFLAGS: 00000296 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000020000000
RDX: 0000000020000140 RSI: 0000000000000000 RDI: 0000000020000580
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..
----------------
Code disassembly (best guess):
   0:	03 74 c0 01          	add    0x1(%rax,%rax,8),%esi
   4:	10 05 03 74 b8 01    	adc    %al,0x1b87403(%rip)        # 0x1b8740d
   a:	10 06                	adc    %al,(%rsi)
   c:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
  10:	10 07                	adc    %al,(%rdi)
  12:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
  16:	10 08                	adc    %cl,(%rax)
  18:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1c:	00 00                	add    %al,(%rax)
  1e:	00 00                	add    %al,(%rax)
  20:	00 51 52             	add    %dl,0x52(%rcx)
  23:	55                   	push   %rbp
  24:	89 e5                	mov    %esp,%ebp
  26:	0f 34                	sysenter
  28:	cd 80                	int    $0x80
* 2a:	5d                   	pop    %rbp <-- trapping instruction
  2b:	5a                   	pop    %rdx
  2c:	59                   	pop    %rcx
  2d:	c3                   	retq
  2e:	90                   	nop
  2f:	90                   	nop
  30:	90                   	nop
  31:	90                   	nop
  32:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  39:	00 00 00
  3c:	0f                   	.byte 0xf
  3d:	1f                   	(bad)
  3e:	44                   	rex.R


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
