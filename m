Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D830A400878
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350687AbhICXwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:52:41 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:57339 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350659AbhICXwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 19:52:30 -0400
Received: by mail-io1-f70.google.com with SMTP id c22-20020a5d9a960000b029059c9e04cd63so435284iom.23
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 16:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RZPnY1Txr2WZc9qQaiK6kuIvgJ77tDn0sABgbez76/w=;
        b=M4ctGs4OeYhPVqJcyCyUYgdRrbfps+SjkuEV0Xi34KSylXFpjbnSYmTmGbis59LAGi
         N06aQwjGOHinWd6eBSmdj7o8sFBBbXa5vNzTZH8Jf8o7IZxEp3RucrJ2T4/K7e4M9Nyj
         FZm4ipFns9NYBJREL3xxYIWprbXO8mdmXZMzDBYCpItbla1WNAOPsamZe23yDKJrZxyG
         8MFzq5G44Hi/7IWUvjAB2Fc0LfTpaY0zMvKtAuX1eMfadM4YyXnfCkHX/I0g2ZtE5jAr
         3iNxQWv/y4UtB89mWb90ZC0+ZQGYttm85HD6uCh+RoHFpFDXM3zZE7h5R+IOVPl3+2WK
         Iy6w==
X-Gm-Message-State: AOAM532mE5uObrhMlsNzzqKTjlrhk/5XEEM23D2x9ak+P18pyj6cKT6Z
        ehmGnjiQoNvSUbaiYLE5GybGL0SLqC2XBGs2TPV+qBhxdGFO
X-Google-Smtp-Source: ABdhPJxv6ZH9rpxWUPGF3fn60wdJPCKsCK/9YYOetZIoq2AQlz8tt1WSwmo7z4L9afQpc4MdAFylOzA6Qr4nsuMI7BobIDP+hDKn
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1354:: with SMTP id k20mr1016098ilr.133.1630713089541;
 Fri, 03 Sep 2021 16:51:29 -0700 (PDT)
Date:   Fri, 03 Sep 2021 16:51:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ecc0805cb1ffa2d@google.com>
Subject: [syzbot] WARNING: kmalloc bug in check_btf_line
From:   syzbot <syzbot+3361d05142f53b068ca1@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a9c9a6f741cd Merge tag 'scsi-misc' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=101320a5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7860a0536ececf0c
dashboard link: https://syzkaller.appspot.com/bug?extid=3361d05142f53b068ca1
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121ce115300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=110adea3300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3361d05142f53b068ca1@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8408 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8408 Comm: syz-executor725 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 8d 12 0d 00 49 89 c5 e9 69 ff ff ff e8 f0 21 d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 df 21 d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 c6
RSP: 0018:ffffc9000c6df720 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc9000c6dfe18 RCX: 0000000000000000
RDX: ffff88801ff68000 RSI: ffffffff81a4f621 RDI: 0000000000000003
RBP: 0000000000002dc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a4f5de R11: 0000000000000000 R12: 000000020008a100
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888014594000
FS:  0000000000ba0300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f63094ed6c0 CR3: 000000001ddbe000 CR4: 0000000000350ef0
Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvmalloc_array include/linux/mm.h:824 [inline]
 kvcalloc include/linux/mm.h:829 [inline]
 check_btf_line+0x1a9/0xad0 kernel/bpf/verifier.c:9925
 check_btf_info kernel/bpf/verifier.c:10049 [inline]
 bpf_check+0x1636/0xbd20 kernel/bpf/verifier.c:13759
 bpf_prog_load+0xe57/0x21f0 kernel/bpf/syscall.c:2301
 __sys_bpf+0x67e/0x5df0 kernel/bpf/syscall.c:4587
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f0a9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc34347988 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f0a9
RDX: 0000000000000078 RSI: 0000000020008a40 RDI: 0000000000000005
RBP: 0000000000403090 R08: 00000000004ac018 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403120
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
