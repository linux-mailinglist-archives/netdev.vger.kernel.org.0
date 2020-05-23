Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7711DF56F
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 09:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbgEWHOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 03:14:17 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:46481 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgEWHOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 03:14:17 -0400
Received: by mail-il1-f197.google.com with SMTP id g17so10654608iln.13
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 00:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nh21cRh3JyFVvlxZ9ajxFdtWOAPOeTeKCQi0L9H7zww=;
        b=ljEcTq7wdGA7G7ff0KRT0lz0NZUqVGmPnKjR58BcwN2O14hKwWpAAzFeWRB3oeqb59
         tR/+oKqSbAQVllPpH5v5UUyLUyvNW3xGsTTdX21RZup3xwOPti9F8DAwlSAmfus4hGII
         mtzsjW2YIMntIWohj1gsIJsSK6q+ciyNMzEUKLvDOuhCh91kw9pEX5KDM6AARVk4JWru
         uxr20dKvjBEKCdJHK1S0dBunwXMaDxOt1ZzJ8Yk2wEWKqQ97VvVrjijLrm2vCjXYABoz
         dn0VHcrpT1tEH7esZ0g4tBRfuC6FuBfOOrvMeafDXJ91jBAcmU/grKXXU859toHG5e1s
         +FAw==
X-Gm-Message-State: AOAM531ZKlKTyW86GAE77flDOdzZ4KR+mV5rwyXVX5rnwEzD7LWxWEwW
        md/dO8nqu8Cc0zjuM7dcCUAHFMkIeSVino0MisgOarlgdkpR
X-Google-Smtp-Source: ABdhPJywkMRnn2LOFXaOvwmJw7TS1p/hvLiIyCnYDhrNCIEmGRxR9u+zhFEo42xqT7hLLKfGrFyt0wCZ1JZgDHC9joMGn+fVOIiE
MIME-Version: 1.0
X-Received: by 2002:a92:bacb:: with SMTP id t72mr17168570ill.26.1590218055752;
 Sat, 23 May 2020 00:14:15 -0700 (PDT)
Date:   Sat, 23 May 2020 00:14:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054221d05a64b7ed8@google.com>
Subject: general protection fault in selinux_socket_recvmsg
From:   syzbot <syzbot+c6bfc3db991edc918432@syzkaller.appspotmail.com>
To:     andriin@fb.com, anton@enomsg.org, ast@kernel.org,
        bpf@vger.kernel.org, ccross@android.com, daniel@iogearbox.net,
        eparis@parisplace.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, selinux@vger.kernel.org,
        songliubraving@fb.com, stephen.smalley.work@gmail.com,
        syzkaller-bugs@googlegroups.com, tony.luck@intel.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    051143e1 Merge tag 'apparmor-pr-2020-05-21' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1313f016100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3368ce0cc5f5ace
dashboard link: https://syzkaller.appspot.com/bug?extid=c6bfc3db991edc918432
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13eeacba100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167163e6100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c6bfc3db991edc918432@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 PID: 7370 Comm: syz-executor283 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:selinux_socket_recvmsg+0x1e/0x40 security/selinux/hooks.c:4841
Code: e8 77 f9 1e fe 48 89 ef 5d eb b1 90 53 48 89 fb e8 67 f9 1e fe 48 8d 7b 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 0f 48 8b 7b 18 be 02 00 00 00 5b e9 7d fc ff ff e8
RSP: 0018:ffffc900019d7a58 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000040000000
RDX: 0000000000000003 RSI: ffffffff83543bb9 RDI: 0000000000000018
RBP: dffffc0000000000 R08: ffff88809f45a180 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffc900019d7d78 R14: 0000000000001000 R15: 0000000040000000
FS:  00007f5ffb311700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5ffb2efe78 CR3: 00000000a33c1000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 security_socket_recvmsg+0x78/0xc0 security/security.c:2070
 sock_recvmsg+0x47/0x110 net/socket.c:902
 mptcp_recvmsg+0xb3b/0xd90 net/mptcp/protocol.c:891
 inet_recvmsg+0x121/0x5d0 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec net/socket.c:886 [inline]
 sock_recvmsg net/socket.c:904 [inline]
 sock_recvmsg+0xca/0x110 net/socket.c:900
 __sys_recvfrom+0x1c5/0x2f0 net/socket.c:2057
 __do_sys_recvfrom net/socket.c:2075 [inline]
 __se_sys_recvfrom net/socket.c:2071 [inline]
 __x64_sys_recvfrom+0xdd/0x1b0 net/socket.c:2071
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x448ef9
Code: e8 cc 14 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 0c fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5ffb310da8 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 00000000006dec28 RCX: 0000000000448ef9
RDX: 0000000000001000 RSI: 00000000200004c0 RDI: 0000000000000003
RBP: 00000000006dec20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000040000000 R11: 0000000000000246 R12: 00000000006dec2c
R13: 00007ffc3a001ccf R14: 00007f5ffb3119c0 R15: 00000000006dec2c
Modules linked in:
---[ end trace 60e1f3eb5a5b83ce ]---
RIP: 0010:selinux_socket_recvmsg+0x1e/0x40 security/selinux/hooks.c:4841
Code: e8 77 f9 1e fe 48 89 ef 5d eb b1 90 53 48 89 fb e8 67 f9 1e fe 48 8d 7b 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 0f 48 8b 7b 18 be 02 00 00 00 5b e9 7d fc ff ff e8
RSP: 0018:ffffc900019d7a58 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000040000000
RDX: 0000000000000003 RSI: ffffffff83543bb9 RDI: 0000000000000018
RBP: dffffc0000000000 R08: ffff88809f45a180 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffc900019d7d78 R14: 0000000000001000 R15: 0000000040000000
FS:  00007f5ffb311700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5ffb2efe78 CR3: 00000000a33c1000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
