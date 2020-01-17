Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5441A140F92
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAQRCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:02:11 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:51044 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgAQRCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:02:10 -0500
Received: by mail-il1-f200.google.com with SMTP id z12so19153418ilh.17
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 09:02:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=v5pjtR02fy58Q0F+yGRHUalTapXO5wj8rc74RPMAdFo=;
        b=V/oHA7V0VkUh1eylKBBmz8dyJvUdRStXJnPjASw44DeYvZg5DR/rHjEeCA4nsAAFGa
         9cNKVAn5pFLE2yGiqMjH5/m01zjBLtBpHtubKN1q92ErlNzRC/jdXge7z2sKoPjQNEYf
         F5TDoOvf8ZMYttSsl5S+DqaFjrfzc5M3dytgjmKfnvjWCsioQbSmocpaJj2MwdpHKIW8
         SAVbGOH5toJ7AILHvf3mnhuJvZWKE0xgyFNVd8+SiPEwvUFCaU1PCb8DCrJZTM9wkwHZ
         +jwQSV44X52ODGlunxsAJn0g1QzSM4D9HqTObki1RkDxvYSDGGrWN6At/gs7aaZAKSJR
         67RA==
X-Gm-Message-State: APjAAAUTsON45HSyKh51Cq6RxRaWGrLjMUoSOIbjspYUbhee6bFzT67n
        G5gmQAcO6ZghV52L4FyVqg8IyhAFmI5/HWRaR2lOaJJYH3NK
X-Google-Smtp-Source: APXvYqx9fV6JY5/xPbPrPjDCBFFRB1kzTHVwoX/M/Y1KpDho67tX+WnzMrih5MbDiAUH+3DgROagb2aBsX27wXXhQ7WaysMBF691
MIME-Version: 1.0
X-Received: by 2002:a92:ba93:: with SMTP id t19mr2301537ill.0.1579280530118;
 Fri, 17 Jan 2020 09:02:10 -0800 (PST)
Date:   Fri, 17 Jan 2020 09:02:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ffc1f1059c58e648@google.com>
Subject: WARNING in sk_psock_drop
From:   syzbot <syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    93ad0f96 net: wan: lapbether.c: Use built-in RCU list chec..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=132caa76e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=d73682fcf7fee6982fe3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 11793 at include/net/sock.h:1578 sock_owned_by_me  
include/net/sock.h:1578 [inline]
WARNING: CPU: 1 PID: 11793 at include/net/sock.h:1578  
sk_psock_drop+0x5fa/0x7f0 net/core/skmsg.c:597
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 11793 Comm: syz-executor.3 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
RIP: 0010:sock_owned_by_me include/net/sock.h:1578 [inline]
RIP: 0010:sk_psock_drop+0x5fa/0x7f0 net/core/skmsg.c:597
Code: d0 7c 08 84 d2 0f 85 c7 01 00 00 44 8b 2d 22 89 4b 04 31 ff 44 89 ee  
e8 f4 01 45 fb 45 85 ed 0f 84 4e fa ff ff e8 66 00 45 fb <0f> 0b e9 42 fa  
ff ff e8 5a 00 45 fb 48 8d bb 70 02 00 00 48 b8 00
RSP: 0018:ffffc90001667a58 EFLAGS: 00010212
RAX: 0000000000040000 RBX: ffff888098091800 RCX: ffffc900102eb000
RDX: 00000000000001a2 RSI: ffffffff862ff52a RDI: 0000000000000005
RBP: ffffc90001667aa0 R08: ffff8880a7a824c0 R09: ffffed101301234c
R10: ffffed101301234b R11: ffff888098091a5b R12: ffff8880a4606e80
R13: 0000000000000001 R14: ffff888098091800 R15: ffff8880a4606e80
  sk_psock_put include/linux/skmsg.h:437 [inline]
  tcp_bpf_recvmsg+0xb69/0xc90 net/ipv4/tcp_bpf.c:157
  inet6_recvmsg+0x136/0x610 net/ipv6/af_inet6.c:592
  sock_recvmsg_nosec net/socket.c:873 [inline]
  sock_recvmsg net/socket.c:891 [inline]
  sock_recvmsg+0xce/0x110 net/socket.c:887
  __sys_recvfrom+0x1ff/0x350 net/socket.c:2042
  __do_sys_recvfrom net/socket.c:2060 [inline]
  __se_sys_recvfrom net/socket.c:2056 [inline]
  __x64_sys_recvfrom+0xe1/0x1a0 net/socket.c:2056
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45aff9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f83349d7c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 00007f83349d86d4 RCX: 000000000045aff9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000085c R14: 00000000004c9852 R15: 000000000075bf2c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
