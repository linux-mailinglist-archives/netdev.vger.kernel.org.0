Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251ED327D8C
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbhCALuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:50:06 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:44605 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbhCALty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:49:54 -0500
Received: by mail-io1-f69.google.com with SMTP id e11so4131058ioh.11
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 03:49:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DwARR0f16pytt1tCFzY3s3chbtjz6oz+ioNdZQ7XKbE=;
        b=k7anrfbdJx64r8HdkGILpey+GUeV52zxA2SYouKiod1pmqEWJ00dHSUwwtk/luoJR3
         //myzH2Ws7x3oQuvpqa5nTyYA6wRUDwzfAHH6bKqrPnKVrDX0U07afjZEXSBfrq98No7
         Nr/hKk87JhgxgxZlkQCZihwnDaXaTuRMbcgyk3O4BeFN0rijdoRJvoaYP1EBwgJ5Y7ug
         VEjzP+6yvbJ3+0zRodn+JPVWhXDvO4jzBY4GBb3q03hj1V3GbKCC8VPaFypBtzx1mdLR
         nmSS+mW5r1JubpkAjD3VFqqNoIo1dKS8hT4ElI/enwyzQg+1P5uohyxuJdaSt2Bh6D1L
         Cfew==
X-Gm-Message-State: AOAM531T/g4HbXovyc2UKbPghJDBcCKMRZzq3gECoPs+3EluhtZ8PnZH
        0EImFa2rIkLSOBKQVyN+e8SeMltiw4RGWEf8n9PQco9gslhu
X-Google-Smtp-Source: ABdhPJxhD0zPY5Uhs0jKXVz/djbISrGEHK64CWufRALhFr638FsvoBeCA3iDrAmzXrTKoANokDPVKYR/wFXDWPFV2Ltp5x5IG7JS
MIME-Version: 1.0
X-Received: by 2002:a92:6a0b:: with SMTP id f11mr12229147ilc.290.1614599353665;
 Mon, 01 Mar 2021 03:49:13 -0800 (PST)
Date:   Mon, 01 Mar 2021 03:49:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ee0e3005bc783400@google.com>
Subject: KMSAN: uninit-value in dgram_sendmsg
From:   syzbot <syzbot+a209a964d48b219587cc@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29ad81a1 arch/x86: add missing include to sparsemem.h
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13b86466d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c8e3b38ca92283e
dashboard link: https://syzkaller.appspot.com/bug?extid=a209a964d48b219587cc
compiler:       Debian clang version 11.0.1-2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a209a964d48b219587cc@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ieee802154_addr_from_sa include/net/ieee802154_netdev.h:174 [inline]
BUG: KMSAN: uninit-value in dgram_sendmsg+0x14cb/0x15c0 net/ieee802154/socket.c:660
CPU: 0 PID: 14314 Comm: syz-executor.3 Not tainted 5.11.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:120
 kmsan_report+0xfb/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 ieee802154_addr_from_sa include/net/ieee802154_netdev.h:174 [inline]
 dgram_sendmsg+0x14cb/0x15c0 net/ieee802154/socket.c:660
 ieee802154_sock_sendmsg+0xec/0x130 net/ieee802154/socket.c:97
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0xcfc/0x12f0 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x714/0x830 net/socket.c:2432
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg+0xa7/0xc0 net/compat.c:351
 __ia32_compat_sys_sendmsg+0x4a/0x70 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:79 [inline]
 __do_fast_syscall_32+0x102/0x160 arch/x86/entry/common.c:141
 do_fast_syscall_32+0x6a/0xc0 arch/x86/entry/common.c:166
 do_SYSENTER_32+0x73/0x90 arch/x86/entry/common.c:209
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7fcc549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f55c65fc EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020000380
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Local variable ----address.i@__sys_sendmsg created at:
 ___sys_sendmsg net/socket.c:2389 [inline]
 __sys_sendmsg+0x30e/0x830 net/socket.c:2432
 ___sys_sendmsg net/socket.c:2389 [inline]
 __sys_sendmsg+0x30e/0x830 net/socket.c:2432
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
