Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79EC4A3CD8
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 05:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357535AbiAaEGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 23:06:30 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:51150 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357521AbiAaEG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 23:06:26 -0500
Received: by mail-io1-f70.google.com with SMTP id m185-20020a6bbcc2000000b00605898d6b61so9012116iof.17
        for <netdev@vger.kernel.org>; Sun, 30 Jan 2022 20:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=g94eSPEms4siUdIAdsRyOE4Be2jkZcPOC6JzxK9ZLK8=;
        b=8G0+46JnEARh6UzdCev6zmUVfBsg1qwIj4Wjp+ia1atr/YN+Dc7vlxPICwp0nBOmCW
         HjBLxpi44GE1hEhuvQryybqTPxlTb7eRgiPMH6PXfeXZecDnEEUzOgioTxdTGDAI8NGx
         Hw0mWqEfvO1kB21ho4qTr4aW24Sdl0EPuZmW4S3B0bYpGgJwbC/FUweHcbBw8FXq7wWy
         xDWRoDCMDW1+TXYA961QdYXyb0Luc/9wVZAw805YUqXChW6BirTbyHLoK5pyx6uaEy3G
         DeyGoIfLQvD1QqLgJOeBMA2pd75i0cvg9hz02qAv1Wp68rc3BKAa/hm2W6wb3QDAufAy
         m/WA==
X-Gm-Message-State: AOAM530Z2YmYJnNxkyWmUNgoqyxInibdOLgeJMUD+KVQIY0yPj+yh693
        MKkXgGN85jeIo5OcbUKNJNtxL4jIA5PKHD3gNmK1iNqmDX3N
X-Google-Smtp-Source: ABdhPJxvB0QpL9iq7aqUHusv5YGj0nOjyxGkqWzz3tjPSN1ALfuPK1LnSE49Vc+mBj26HXvhNUNEQ6IhDqTSr/mTs9iS8sw/WAXx
MIME-Version: 1.0
X-Received: by 2002:a05:6638:24d0:: with SMTP id y16mr8925319jat.170.1643601986334;
 Sun, 30 Jan 2022 20:06:26 -0800 (PST)
Date:   Sun, 30 Jan 2022 20:06:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008c32e305d6d8e802@google.com>
Subject: [syzbot] general protection fault in submit_bio_checks
From:   syzbot <syzbot+2b3f18414c37b42dcc94@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b605fdc54c2b Add linux-next specific files for 20220128
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=150084b8700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da5090473475f3ca
dashboard link: https://syzkaller.appspot.com/bug?extid=2b3f18414c37b42dcc94
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b3f18414c37b42dcc94@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
CPU: 1 PID: 3642 Comm: syz-executor.5 Not tainted 5.17.0-rc1-next-20220128-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:blk_throtl_bio block/blk-throttle.h:175 [inline]
RIP: 0010:submit_bio_checks+0x7c0/0x1bf0 block/blk-core.c:765
Code: 08 3c 03 0f 8e 4a 11 00 00 48 b8 00 00 00 00 00 fc ff df 44 8b 6d 10 41 83 e5 01 4a 8d bc 2b 7c 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 09 11 00 00
RSP: 0018:ffffc900028cf680 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000002f RSI: ffffffff83d5f41e RDI: 000000000000017d
RBP: ffff88801e8be500 R08: ffffffff8a241580 R09: 0000000000000000
R10: ffffffff83d5f410 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: 00000000fffffffe R15: ffff88801ad9a4cc
FS:  0000555556299400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fed92bd5ec9 CR3: 000000003b65d000 CR4: 00000000003526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __submit_bio+0xaf/0x360 block/blk-core.c:802
 __submit_bio_noacct_mq block/blk-core.c:881 [inline]
 submit_bio_noacct block/blk-core.c:907 [inline]
 submit_bio_noacct+0x6c9/0x8a0 block/blk-core.c:896
 submit_bio block/blk-core.c:968 [inline]
 submit_bio+0x1ea/0x430 block/blk-core.c:926
 write_dev_flush fs/btrfs/disk-io.c:4243 [inline]
 barrier_all_devices fs/btrfs/disk-io.c:4293 [inline]
 write_all_supers+0x3038/0x4440 fs/btrfs/disk-io.c:4388
 btrfs_commit_transaction+0x1be3/0x3180 fs/btrfs/transaction.c:2362
 btrfs_commit_super+0xc1/0x100 fs/btrfs/disk-io.c:4562
 close_ctree+0x314/0xccc fs/btrfs/disk-io.c:4671
 generic_shutdown_super+0x14c/0x400 fs/super.c:462
 kill_anon_super+0x36/0x60 fs/super.c:1056
 btrfs_kill_super+0x38/0x50 fs/btrfs/super.c:2365
 deactivate_locked_super+0x94/0x160 fs/super.c:332
 deactivate_super+0xad/0xd0 fs/super.c:363
 cleanup_mnt+0x3a2/0x540 fs/namespace.c:1159
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe814b274c7
Code: ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe14eb15c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fe814b274c7
RDX: 00007ffe14eb169b RSI: 000000000000000a RDI: 00007ffe14eb1690
RBP: 00007ffe14eb1690 R08: 00000000ffffffff R09: 00007ffe14eb1460
R10: 000055555629a8b3 R11: 0000000000000246 R12: 00007fe814b7f1ea
R13: 00007ffe14eb2750 R14: 000055555629a810 R15: 00007ffe14eb2790
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:blk_throtl_bio block/blk-throttle.h:175 [inline]
RIP: 0010:submit_bio_checks+0x7c0/0x1bf0 block/blk-core.c:765
Code: 08 3c 03 0f 8e 4a 11 00 00 48 b8 00 00 00 00 00 fc ff df 44 8b 6d 10 41 83 e5 01 4a 8d bc 2b 7c 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 09 11 00 00
RSP: 0018:ffffc900028cf680 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000002f RSI: ffffffff83d5f41e RDI: 000000000000017d
RBP: ffff88801e8be500 R08: ffffffff8a241580 R09: 0000000000000000
R10: ffffffff83d5f410 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: 00000000fffffffe R15: ffff88801ad9a4cc
FS:  0000555556299400(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffeece8b278 CR3: 000000003b65d000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	08 3c 03             	or     %bh,(%rbx,%rax,1)
   3:	0f 8e 4a 11 00 00    	jle    0x1153
   9:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  10:	fc ff df
  13:	44 8b 6d 10          	mov    0x10(%rbp),%r13d
  17:	41 83 e5 01          	and    $0x1,%r13d
  1b:	4a 8d bc 2b 7c 01 00 	lea    0x17c(%rbx,%r13,1),%rdi
  22:	00
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	48 89 fa             	mov    %rdi,%rdx
  31:	83 e2 07             	and    $0x7,%edx
  34:	38 d0                	cmp    %dl,%al
  36:	7f 08                	jg     0x40
  38:	84 c0                	test   %al,%al
  3a:	0f 85 09 11 00 00    	jne    0x1149


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
