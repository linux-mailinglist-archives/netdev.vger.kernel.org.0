Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28D08180B7D
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgCJWZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:25:14 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34219 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbgCJWZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:25:14 -0400
Received: by mail-io1-f69.google.com with SMTP id n26so112671iop.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YK4us6S3rHVM3ZCUln7pn5acEHLvNfpppJP3Tl5JLaI=;
        b=qpJws9rTX6ELcJxi4WTBkzXBuArm9HJhhuwQToV/ydPh/qO7nCW4HyKNqycBPWwkVn
         QfTcsJJoOF67U1JyoSYfVHx+E0vC0a9kQNaPbZv5WiypBejKE2CE578GyNUqa4S9EuNO
         onOjSpiMKBCc5hEHk5UWYepxf+iUB/3gslXTQbuvjY0d5qRxMUcaWc2kolV4GKzgqLLW
         95jhbY0P5pLAIhV68t2mZU4rBi1xS8X72x/XrBqnEtg/ExTrhMLRibX8AjTJuioXPmWg
         VykT2VIeuktbdjWBJMU1oZ7XQzQpFw6nW+xh8q0XnWpQ0uPoYI3GRRre17VlYvAP8a0I
         fD1g==
X-Gm-Message-State: ANhLgQ064NmjTS01wL+Bgz2Cv6d2Ak6A85we+YlyuUbED65k59yVS3r9
        BhqfZIPq0cpBh0H/yfyfQ7SAV7r7h0diRZxt9AO3cNRXb8DL
X-Google-Smtp-Source: ADFU+vsbHDvOK3ZhO4KPpwg47fVYouJdf9b35bnWqbIRwg4l8EHhytl8g4WWFJelLdpfU8RjMH6a8h2ivS4Tup4yYBniagkP1hIq
MIME-Version: 1.0
X-Received: by 2002:a6b:6a02:: with SMTP id x2mr257400iog.20.1583879113261;
 Tue, 10 Mar 2020 15:25:13 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:25:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e9ca5105a08797f2@google.com>
Subject: WARNING: refcount bug in sk_alloc (2)
From:   syzbot <syzbot+b1212b1215db82ff9211@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kafai@fb.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6132c1d9 net: core: devlink.c: Hold devlink->lock from the..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=101c7a81e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=b1212b1215db82ff9211
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10110d29e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b1212b1215db82ff9211@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 10120 at lib/refcount.c:25 refcount_warn_saturate+0x174/0x1f0 lib/refcount.c:25
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 10120 Comm: syz-executor.2 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x174/0x1f0 lib/refcount.c:25
Code: 06 31 ff 89 de e8 9c 00 d3 fd 84 db 0f 85 33 ff ff ff e8 4f ff d2 fd 48 c7 c7 20 98 91 88 c6 05 61 81 fe 06 01 e8 6b 50 a3 fd <0f> 0b e9 14 ff ff ff e8 30 ff d2 fd 0f b6 1d 46 81 fe 06 31 ff 89
RSP: 0018:ffffc9000648fd18 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815eae46 RDI: fffff52000c91f95
RBP: ffffc9000648fd28 R08: ffff88809e674240 R09: ffffed1015d06659
R10: ffffed1015d06658 R11: ffff8880ae8332c7 R12: 0000000000000002
R13: 0000000000000000 R14: ffff888094174084 R15: ffff8880a9adcc88
 refcount_add include/linux/refcount.h:191 [inline]
 refcount_inc include/linux/refcount.h:228 [inline]
 get_net include/net/net_namespace.h:241 [inline]
 sk_alloc+0xeb0/0xfd0 net/core/sock.c:1669
 inet_create net/ipv4/af_inet.c:321 [inline]
 inet_create+0x363/0xe10 net/ipv4/af_inet.c:247
 __sock_create+0x3ce/0x730 net/socket.c:1433
 sock_create net/socket.c:1484 [inline]
 __sys_socket+0x103/0x220 net/socket.c:1526
 __do_sys_socket net/socket.c:1535 [inline]
 __se_sys_socket net/socket.c:1533 [inline]
 __x64_sys_socket+0x73/0xb0 net/socket.c:1533
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45ef97
Code: 00 00 00 49 89 ca b8 36 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 4a 8b fb ff c3 66 0f 1f 84 00 00 00 00 00 b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 2d 8b fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeba043be8 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045ef97
RDX: 0000000000000006 RSI: 0000000000000001 RDI: 0000000000000002
RBP: 0000000000000041 R08: 0000000000000000 R09: 000000000000000a
R10: 0000000000000075 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffeba044300 R14: 000000000001c8c0 R15: 00007ffeba044310
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
