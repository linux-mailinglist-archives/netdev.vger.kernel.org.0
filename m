Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56BCB400892
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 02:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350776AbhIDACh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 20:02:37 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:39712 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350616AbhIDAC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 20:02:29 -0400
Received: by mail-io1-f71.google.com with SMTP id a17-20020a5d89d1000000b005c2233d0074so491980iot.6
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 17:01:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qUjGhZoJ/aJXF8DVrM/Q4JDPPaGvWUbD1ODKWCbMoJ8=;
        b=KzxeQLOeDgcXZmBTntCAPgf8lILv7+X8VfLSCmkS0YhV25ilYo4whUO+tjqnwLL6Fj
         RXZVrJfFo4271NhL7fieALPLICrIZzWrY6fwCqE2HzFstvIwKSDO1SnFkqfO4oFFrgwT
         v/CfErzWlKVqrq53KMDvV8EsO8gFrJwHQHNe+wXq3WxfZh/S469/rK8/V35tK+iczqEB
         ztdVwd1aE7vQiq1UpR38sLQT5TSeDPkpPj2Gh1ih4QrPYEQoI/n4eSXbpHmylJZkYeqJ
         jOj8kaLvL97tjS7bK/PaHauDoqGF/7c6CEWPrzKxA/eAm0gWZL0Cd2aF9wyXj8MZ0Uom
         Km4A==
X-Gm-Message-State: AOAM531T75IPP5NWiCO99v5dS3+wJggvyRKDkbcLuZSYv3i4fHDFn++y
        u91URpSz1FqlflbStjvgZlRcJv2zb4Qk74kAB7PhgZze/3t/
X-Google-Smtp-Source: ABdhPJzYkP4dN3OLyMZAY61kIwAfcwjICyuRsP42kDh2bk7RlbdS+lKo3GDMxYP65N+LwfsR4pWl3ZcRJMWtX/Hp6g3AgJ8Ka8Fp
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2182:: with SMTP id s2mr1336891jaj.26.1630713689173;
 Fri, 03 Sep 2021 17:01:29 -0700 (PDT)
Date:   Fri, 03 Sep 2021 17:01:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c756105cb201ef1@google.com>
Subject: [syzbot] WARNING: kmalloc bug in bpf_check
From:   syzbot <syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=13fd5915300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c84ed2c3f57ace
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e749d4c662818ae439
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e4cdf5300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ef3b33300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8408 at mm/util.c:597 kvmalloc_node+0x108/0x110 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8408 Comm: syz-executor221 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x108/0x110 mm/util.c:597
Code: ff 48 89 df 44 89 fe 44 89 f2 e8 a3 6e 17 00 48 89 c5 eb 05 e8 19 28 ce ff 48 89 e8 5b 41 5c 41 5e 41 5f 5d c3 e8 08 28 ce ff <0f> 0b 31 ed eb e9 66 90 41 56 53 49 89 f6 48 89 fb e8 f2 27 ce ff
RSP: 0018:ffffc900017ff210 EFLAGS: 00010293
RAX: ffffffff81b2b708 RBX: 0000000200004d00 RCX: ffff888013ded580
RDX: 0000000000000000 RSI: 0000000200004d00 RDI: 000000007fffffff
RBP: 0000000000000000 R08: ffffffff81b2b6ac R09: 00000000ffffffff
R10: fffff520002ffe15 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 00000000ffffffff R15: 0000000000002dc0
FS:  0000000001386300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3e712d36c0 CR3: 00000000342e8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvmalloc_array include/linux/mm.h:824 [inline]
 kvcalloc include/linux/mm.h:829 [inline]
 check_btf_line kernel/bpf/verifier.c:9925 [inline]
 check_btf_info kernel/bpf/verifier.c:10049 [inline]
 bpf_check+0xd634/0x150d0 kernel/bpf/verifier.c:13759
 bpf_prog_load kernel/bpf/syscall.c:2301 [inline]
 __sys_bpf+0x11181/0x126e0 kernel/bpf/syscall.c:4587
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x78/0x90 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f0a9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe831a89a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f0a9
RDX: 0000000000000078 RSI: 0000000020000500 RDI: 0000000000000005
RBP: 0000000000403090 R08: 0000000000000000 R09: 0000000000400488
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
