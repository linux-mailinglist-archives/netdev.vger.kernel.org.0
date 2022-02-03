Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962914A8B78
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353394AbiBCSVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:21:21 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39754 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiBCSVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:21:20 -0500
Received: by mail-il1-f200.google.com with SMTP id w14-20020a92db4e000000b002bc0fb4892cso2261689ilq.6
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 10:21:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=YJwkvjDZtoFvou/XeL//kDGHxyur+FvYXZqDkXgxerQ=;
        b=DneeHoL4YY+GIfYVEpxzSZb1+rnw7sf0qkv1OJyyboQui/J0L+T/Vf+KL+L/C5fzD1
         eu4xYnpPaLlQ2tAA3/c9TlPWameUSGjZFkSILjfyLAA3e3yplrYUW8QcpXbcr7ObDpcn
         +yM89GMZYCOLG+ubUJKDucT3S1s2bKEbJOP9auE228plXY3G4xJZ9K1r6AFJBgoPLTbV
         FG8yeuCuz2c17Ri2L0q6Qy08VEdHYUouoAWaotLt3RGdOcIej3anb6GgWl8lksVkkOzN
         +f36n1lfhJ5RVF3XDh3GRBDfPtciuB/J1bvFQYuucrOHcvSY+NyQ5CAuuDEp+PWOjqxg
         wf7g==
X-Gm-Message-State: AOAM531g4K0IBbCUCHdOZ98N3EfTQz/Xf1i8hr0XKM6H5cPqCszMpITu
        YaHKKgrOErxW52c0GkMUseujNtxPu5xeLIUe0sF0CZmyT02c
X-Google-Smtp-Source: ABdhPJyX2fKmFCd+QpNNJ3kd0vnZJd34rXvJtqwsbLa0MTjeKF92b4+SnnvvoY3CvoJUKH+z26sehsf+A1AwCasi5Sew25ZGEGeZ
MIME-Version: 1.0
X-Received: by 2002:a92:d387:: with SMTP id o7mr21518039ilo.26.1643912480285;
 Thu, 03 Feb 2022 10:21:20 -0800 (PST)
Date:   Thu, 03 Feb 2022 10:21:20 -0800
In-Reply-To: <0000000000008c32e305d6d8e802@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006de93f05d721334b@google.com>
Subject: Re: [syzbot] general protection fault in submit_bio_checks
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    2d3d8c7643a5 Add linux-next specific files for 20220203
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14c0c8dc700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27a9abf2c11167c7
dashboard link: https://syzkaller.appspot.com/bug?extid=2b3f18414c37b42dcc94
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14635480700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eb2d14700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b3f18414c37b42dcc94@syzkaller.appspotmail.com

BTRFS info (device loop0): disk space caching is enabled
BTRFS info (device loop0): has skinny extents
BTRFS info (device loop0): enabling ssd optimizations
general protection fault, probably for non-canonical address 0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
CPU: 0 PID: 3586 Comm: syz-executor095 Not tainted 5.17.0-rc2-next-20220203-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:blk_throtl_bio block/blk-throttle.h:175 [inline]
RIP: 0010:submit_bio_checks+0x7c0/0x1bf0 block/blk-core.c:765
Code: 08 3c 03 0f 8e 4a 11 00 00 48 b8 00 00 00 00 00 fc ff df 44 8b 6d 10 41 83 e5 01 4a 8d bc 2b 7c 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 09 11 00 00
RSP: 0018:ffffc9000293f278 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000002f RSI: ffffffff83d5d9de RDI: 000000000000017d
RBP: ffff888014fbd300 R08: ffffffff8a044f00 R09: 0000000000000000
R10: ffffffff83d5d9d0 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: 00000000fffffffe R15: ffff88801a2be93c
FS:  0000555555975300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9789f79668 CR3: 00000000145d1000 CR4: 00000000003506f0
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
 btrfs_fill_super fs/btrfs/super.c:1400 [inline]
 btrfs_mount_root.cold+0xb1/0x162 fs/btrfs/super.c:1744
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1497
 fc_mount fs/namespace.c:1016 [inline]
 vfs_kern_mount.part.0+0xd3/0x170 fs/namespace.c:1046
 vfs_kern_mount+0x3c/0x60 fs/namespace.c:1033
 btrfs_mount+0x234/0xa60 fs/btrfs/super.c:1804
 legacy_get_tree+0x105/0x220 fs/fs_context.c:610
 vfs_get_tree+0x89/0x2f0 fs/super.c:1497
 do_new_mount fs/namespace.c:3012 [inline]
 path_mount+0x1320/0x1fa0 fs/namespace.c:3342
 do_mount fs/namespace.c:3355 [inline]
 __do_sys_mount fs/namespace.c:3563 [inline]
 __se_sys_mount fs/namespace.c:3540 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3540
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff53f71fd8a
Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeaf8661f8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffeaf866250 RCX: 00007ff53f71fd8a
RDX: 0000000020000000 RSI: 0000000020000100 RDI: 00007ffeaf866210
RBP: 00007ffeaf866210 R08: 00007ffeaf866250 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000020000f50
R13: 0000000000000003 R14: 0000000000000004 R15: 000000000000008e
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:blk_throtl_bio block/blk-throttle.h:175 [inline]
RIP: 0010:submit_bio_checks+0x7c0/0x1bf0 block/blk-core.c:765
Code: 08 3c 03 0f 8e 4a 11 00 00 48 b8 00 00 00 00 00 fc ff df 44 8b 6d 10 41 83 e5 01 4a 8d bc 2b 7c 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 09 11 00 00
RSP: 0018:ffffc9000293f278 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000002f RSI: ffffffff83d5d9de RDI: 000000000000017d
RBP: ffff888014fbd300 R08: ffffffff8a044f00 R09: 0000000000000000
R10: ffffffff83d5d9d0 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: 00000000fffffffe R15: ffff88801a2be93c
FS:  0000555555975300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fab1d1bfe28 CR3: 00000000145d1000 CR4: 00000000003506e0
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

