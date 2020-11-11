Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACE42AF446
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 15:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgKKO7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 09:59:20 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:50444 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbgKKO7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 09:59:19 -0500
Received: by mail-il1-f198.google.com with SMTP id f66so1515054ilh.17
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 06:59:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=W6HwsV977k5Y95mu3agDWsdgg0NHwiZ+N76/EE+Ulz4=;
        b=EpofV5vCbvuxOSksPCGRMTEzS62a7OeEYoblg9fJX110x+q6lJu29uzlV2JDsBEqVy
         uFvTzy3pWGyH/0g2EtZwAmWb0sKOXOBgB7ueRhw92R7Ur+hMZRlcvpjkv+JTrd9u3wIm
         RazuLahklXswILSldewjgj8+4qqKc/oEzjTFK3s7aFCkHj6NoaLQtUpTtMOPxH7MGYfF
         07ZsDUp7UJt2bjC3eHkDo10TVCdne+lg8kGGjI0M80+il7gGL68TEsNafTiZ8lEZIyk/
         /Bg1ljwDYhRvE8z7AeXvdN9LjwpA5WvmgFj8Qlkmahc/M/eJFm30Z4KikH6uhIAn0Nbm
         LwIA==
X-Gm-Message-State: AOAM530aFKXVqplr+e46XI0DHXSDgcakNHMKhNddvz2AC+VnlUI1rHIt
        FKutXJHSBC3khrN56YHlXU7cSPfypzt9aCzYoTtt7zvTeDdN
X-Google-Smtp-Source: ABdhPJwPaGTsRU/8i3pPyGnMI8Ns8iG/TZN6ny1+/swklMuMxPF9MWMmk+LV1RmWFYA2sfyjg6xPUAGGqK8jRy6rf7wctHU8gayL
MIME-Version: 1.0
X-Received: by 2002:a02:5101:: with SMTP id s1mr20640779jaa.74.1605106756453;
 Wed, 11 Nov 2020 06:59:16 -0800 (PST)
Date:   Wed, 11 Nov 2020 06:59:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b8bf805b3d60a08@google.com>
Subject: BUG: unable to handle kernel paging request in bpf_trace_run4
From:   syzbot <syzbot+a5bd8c75daa0e849b296@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c6bde958 bpf: Lift hashtab key_size limit
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=159f611a500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58a4ca757d776bfe
dashboard link: https://syzkaller.appspot.com/bug?extid=a5bd8c75daa0e849b296
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a5bd8c75daa0e849b296@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffff52000194406
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 23fff2067 P4D 23fff2067 PUD 101a4067 PMD 101a6067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8505 Comm: syz-executor.1 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
RIP: 0010:bpf_trace_run4+0x135/0x3f0 kernel/trace/bpf_trace.c:2084
Code: c7 c7 20 ed 50 89 e8 6a 5e d2 ff 0f 1f 44 00 00 e8 f0 27 f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 a0 02 00 00 48 8d 73 38 48 8d 7c 24 28 ff 53 30
RSP: 0018:ffffc900016af5e0 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffffc90000ca2000 RCX: ffffffff8178e0f2
RDX: 1ffff92000194406 RSI: ffffffff8178dec0 RDI: ffffc90000ca2030
RBP: 1ffff920002d5ebd R08: 0000000000000000 R09: ffffffff8ebac667
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: 00000000000026be R15: ffff8880563fdd38
FS:  0000000001c6d940(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff52000194406 CR3: 000000003df71000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 __bpf_trace_ext4_free_blocks+0x10a/0x150 include/trace/events/ext4.h:887
 trace_ext4_free_blocks include/trace/events/ext4.h:887 [inline]
 ext4_free_blocks+0x150d/0x1de0 fs/ext4/mballoc.c:5303
 ext4_remove_blocks fs/ext4/extents.c:2497 [inline]
 ext4_ext_rm_leaf fs/ext4/extents.c:2663 [inline]
 ext4_ext_remove_space+0x1fad/0x4270 fs/ext4/extents.c:2911
 ext4_ext_truncate+0x1dc/0x240 fs/ext4/extents.c:4373
 ext4_truncate+0xe86/0x1420 fs/ext4/inode.c:4251
 ext4_evict_inode+0x9d2/0x1180 fs/ext4/inode.c:280
 evict+0x2ed/0x750 fs/inode.c:578
 iput_final fs/inode.c:1654 [inline]
 iput.part.0+0x3fe/0x820 fs/inode.c:1680
 iput+0x58/0x70 fs/inode.c:1670
 dentry_unlink_inode+0x2b1/0x3d0 fs/dcache.c:374
 d_delete fs/dcache.c:2470 [inline]
 d_delete+0x16b/0x1c0 fs/dcache.c:2459
 vfs_rmdir.part.0+0x37b/0x430 fs/namei.c:3726
 vfs_rmdir fs/namei.c:3698 [inline]
 do_rmdir+0x3ae/0x440 fs/namei.c:3773
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45dc27
Code: 00 66 90 b8 57 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 54 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 6d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd7c232298 EFLAGS: 00000207 ORIG_RAX: 0000000000000054
RAX: ffffffffffffffda RBX: 0000000000000065 RCX: 000000000045dc27
RDX: 0000000000000000 RSI: 000000000074e678 RDI: 00007ffd7c2333d0
RBP: 0000000000003f22 R08: 0000000000000000 R09: 0000000000000001
R10: 000000000000000a R11: 0000000000000207 R12: 00007ffd7c2333d0
R13: 0000000001c6ea60 R14: 0000000000000000 R15: 00007ffd7c2333d0
Modules linked in:
CR2: fffff52000194406
---[ end trace 86ec96f38a2db7f5 ]---
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:2045 [inline]
RIP: 0010:bpf_trace_run4+0x135/0x3f0 kernel/trace/bpf_trace.c:2084
Code: c7 c7 20 ed 50 89 e8 6a 5e d2 ff 0f 1f 44 00 00 e8 f0 27 f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 a0 02 00 00 48 8d 73 38 48 8d 7c 24 28 ff 53 30
RSP: 0018:ffffc900016af5e0 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffffc90000ca2000 RCX: ffffffff8178e0f2
RDX: 1ffff92000194406 RSI: ffffffff8178dec0 RDI: ffffc90000ca2030
RBP: 1ffff920002d5ebd R08: 0000000000000000 R09: ffffffff8ebac667
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: 00000000000026be R15: ffff8880563fdd38
FS:  0000000001c6d940(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff52000194406 CR3: 000000003df71000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
