Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD153304CF
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 22:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhCGVTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 16:19:34 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:48683 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbhCGVTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 16:19:16 -0500
Received: by mail-il1-f199.google.com with SMTP id n12so6092457ili.15
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 13:19:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=b/8/TV2Ggjpg+ciG7XgCGRcOg8HJPj1kV6+Ap5MX/CY=;
        b=tNVQbsZFEmtxUaVIXppOWvtBkmNm+T0QOSHzJ/TXrtqx/WtzNm6T7Y2oxIsnTzwNLv
         mLKnCnu0dGBDTv+YEPWxzlSfbmqICvuvxMi0UMCwdB+TT5oWYtXRWGxLcF1GLfVRbyEm
         v7Z8ezbhTSUd53Tr7wayXu7sIuKoMN49qMeBSgo628jm0WpvrD6rAyV58kWDGMkMY2Lg
         iwiULFne4K6yw6a+D3XV0FtFs/rgua162o+Du3KU2AcklR+aUaKsp1zHzcGA2xRyGwwK
         O+zSykXJdkuM2OzBzYJGjC3qbN5FqpM//8NQzShPE4YFLJXwa9SXWC2QkskxtfXUOV5o
         pk/w==
X-Gm-Message-State: AOAM530aVzpQ2OuFc1cq3iz0aRqB4moReQDYKqFxz5F3P6sThK9DPkGi
        siYetm5W8Q/bGZn02Do9NLpo3OU5oyC4+DqHO1RaTfFZXuWW
X-Google-Smtp-Source: ABdhPJzVhPF7jKxv/Gv5CpH0beyGmos+xXQz4bdA1lIez7e9mXZ+ZdPvXbH+SB7jIW9HhFKClnjp9qGTs18I8A5WpZu9DoHsR/AR
MIME-Version: 1.0
X-Received: by 2002:a5e:8610:: with SMTP id z16mr15515017ioj.57.1615151955861;
 Sun, 07 Mar 2021 13:19:15 -0800 (PST)
Date:   Sun, 07 Mar 2021 13:19:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000096659005bcf8de0c@google.com>
Subject: [syzbot] general protection fault in btf_type_id_size
From:   syzbot <syzbot+8bab8ed346746e7540e8@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6185266c selftests/bpf: Mask bpf_csum_diff() return value ..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=14fd4ff2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e2d5ba72abae4f14
dashboard link: https://syzkaller.appspot.com/bug?extid=8bab8ed346746e7540e8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=139778aed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158426dad00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bab8ed346746e7540e8@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 8380 Comm: syz-executor429 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:btf_resolved_type_id kernel/bpf/btf.c:1770 [inline]
RIP: 0010:btf_type_id_size+0x40e/0x960 kernel/bpf/btf.c:1811
Code: 48 c1 e9 03 80 3c 11 00 0f 85 17 05 00 00 49 8b 47 10 44 29 f3 48 8d 1c 98 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 ec
RSP: 0018:ffffc90000fffd18 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000014 RCX: 1ffff11003a70482
RDX: 0000000000000002 RSI: ffffffff818b12f3 RDI: ffff88801d382410
RBP: ffff88801d382400 R08: 0000000000000005 R09: ffffffff818b114a
R10: ffffffff818b128e R11: 000000000000000a R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88801d382400
FS:  0000000000ad5300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004ae0f0 CR3: 0000000024fca000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 map_check_btf kernel/bpf/syscall.c:757 [inline]
 map_create kernel/bpf/syscall.c:860 [inline]
 __do_sys_bpf+0x4000/0x4f00 kernel/bpf/syscall.c:4370
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ff09
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc5f435ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 000000000001053e RCX: 000000000043ff09
RDX: 0000000000000040 RSI: 0000000020000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 00007ffc5f436098 R09: 00007ffc5f436098
R10: 00007ffc5f436098 R11: 0000000000000246 R12: 00007ffc5f435f0c
R13: 431bde82d7b634db R14: 00000000004ae018 R15: 0000000000400488
Modules linked in:
---[ end trace a4216c6ef2fa85f5 ]---
RIP: 0010:btf_resolved_type_id kernel/bpf/btf.c:1770 [inline]
RIP: 0010:btf_type_id_size+0x40e/0x960 kernel/bpf/btf.c:1811
Code: 48 c1 e9 03 80 3c 11 00 0f 85 17 05 00 00 49 8b 47 10 44 29 f3 48 8d 1c 98 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 ec
RSP: 0018:ffffc90000fffd18 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000014 RCX: 1ffff11003a70482
RDX: 0000000000000002 RSI: ffffffff818b12f3 RDI: ffff88801d382410
RBP: ffff88801d382400 R08: 0000000000000005 R09: ffffffff818b114a
R10: ffffffff818b128e R11: 000000000000000a R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88801d382400
FS:  0000000000ad5300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004ae0f0 CR3: 0000000024fca000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
