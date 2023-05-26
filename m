Return-Path: <netdev+bounces-5615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6415712446
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:11:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 713501C20F57
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA20156C9;
	Fri, 26 May 2023 10:11:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D173411C84
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:11:12 +0000 (UTC)
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129D6E6E
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:10:57 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-763da06540aso115506839f.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:10:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685095856; x=1687687856;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kuYO3aLfJvCK87vZ47xyX8acyHpnlVpjpc6nvwXT1kc=;
        b=A6m5wIQ1uF0JviWi91jlc0IBMjfF/yG+sAe/axbC26AfDJjq/etTlJbz7rMWoibkyn
         gjMzTklU8l6maAGAihJh2tdpyCo+TPvLmrAvOM09egiM/b1Rua1s4MqHM+Mwe3iPrgju
         200JAhdJRsol7J9cze7zh6QV7+YA4sxTIZSt2WntO7sfoLmX8p2E/nR8yHR/N4GnDUIM
         8s//DoadtDo0oNVCudiJmmnYk4ieldyFP3NeAFCnw8cDh5f07qlF69SD9Quvfqrqm3k/
         iJIIBPyDGwU2GiEMl6u3zjzCW83u1EOaG5/ftekoKOWvDpLMCPfbdo3lGGk7v5zYpXLI
         6AzA==
X-Gm-Message-State: AC+VfDxR5jHXmKW31IuZbwbgl5qzMmcNuqLiZCKFfYQ4POJRgJu3FhNi
	6McCXXf2gk43t6bpOnIeTSvQuOjOoxlyMuHFDuCvWtISm3ef
X-Google-Smtp-Source: ACHHUZ7DE4O4WK2S0swdnvx3USOzfATnarHx7chK7KiduOBTJ9n17lCRfZtlIXXbKlsD/eoQO4cbRZjYcfao7hqnucXIQItDb53z
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:638b:0:b0:418:8bcd:ad9d with SMTP id
 j133-20020a02638b000000b004188bcdad9dmr421299jac.4.1685095856115; Fri, 26 May
 2023 03:10:56 -0700 (PDT)
Date: Fri, 26 May 2023 03:10:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea970305fc95f3c6@google.com>
Subject: [syzbot] [bpf?] WARNING: bad unlock balance in bpf
From: syzbot <syzbot+8982e75c2878b9ffeac5@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com, hawk@kernel.org, 
	john.fastabend@gmail.com, jolsa@kernel.org, kpsingh@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, martin.lau@linux.dev, 
	netdev@vger.kernel.org, sdf@google.com, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    c4c84f6fb2c4 bpf: drop unnecessary bpf_capable() check in ..
git tree:       bpf-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=119576a9280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8bc832f563d8bf38
dashboard link: https://syzkaller.appspot.com/bug?extid=8982e75c2878b9ffeac5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10391dde280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=137da9c5280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3cb57feeb883/disk-c4c84f6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ccb6d78c42d/vmlinux-c4c84f6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fb02c9cdb21c/bzImage-c4c84f6f.xz

The issue was bisected to:

commit c4c84f6fb2c4dc4c0f5fd927b3c3d3fd28b7030e
Author: Andrii Nakryiko <andrii@kernel.org>
Date:   Wed May 24 22:54:19 2023 +0000

    bpf: drop unnecessary bpf_capable() check in BPF_MAP_FREEZE command

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b7214d280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1477214d280000
console output: https://syzkaller.appspot.com/x/log.txt?x=1077214d280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8982e75c2878b9ffeac5@syzkaller.appspotmail.com
Fixes: c4c84f6fb2c4 ("bpf: drop unnecessary bpf_capable() check in BPF_MAP_FREEZE command")

=====================================
WARNING: bad unlock balance detected!
6.4.0-rc1-syzkaller-00358-gc4c84f6fb2c4 #0 Not tainted
-------------------------------------
syz-executor518/5004 is trying to release lock (&map->freeze_mutex) at:
[<ffffffff8193e2c4>] map_freeze kernel/bpf/syscall.c:1951 [inline]
[<ffffffff8193e2c4>] __sys_bpf+0x3234/0x5520 kernel/bpf/syscall.c:5078
but there are no more locks to release!

other info that might help us debug this:
no locks held by syz-executor518/5004.

stack backtrace:
CPU: 0 PID: 5004 Comm: syz-executor518 Not tainted 6.4.0-rc1-syzkaller-00358-gc4c84f6fb2c4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/16/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 __lock_release kernel/locking/lockdep.c:5368 [inline]
 lock_release+0x4f1/0x670 kernel/locking/lockdep.c:5711
 __mutex_unlock_slowpath+0x99/0x5e0 kernel/locking/mutex.c:907
 map_freeze kernel/bpf/syscall.c:1951 [inline]
 __sys_bpf+0x3234/0x5520 kernel/bpf/syscall.c:5078
 __do_sys_bpf kernel/bpf/syscall.c:5185 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5183 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5183
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f7eb20e8bb9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffe49d4848 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7eb20e8bb9
RDX: 0000000000000004 RSI: 0000000020000180 RDI: 0000000000000016
RBP: 00007f7eb20acd60 R08: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

