Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9AB3FFBB8
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 10:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348220AbhICIS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 04:18:28 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:41568 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348168AbhICIS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 04:18:27 -0400
Received: by mail-il1-f199.google.com with SMTP id l4-20020a92d8c40000b02902242b6ea4b3so3034591ilo.8
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 01:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6GjhL9Cm8vc8f/tANuKUYM4w6ZUCPAy6g6TMY88ThvQ=;
        b=YAhb5YhH13auRZcz874nsjbUVYNrHJp+f1Ur93milW+d3TFDMM1Q3hqtxsFyhW3jX/
         836ZPevNv3W+tDU9hcoI29+gGC96rJUt4PceIgiVk7Mbt2CMm8a0O5OdHmvCY166CioA
         x2ZK7nXUC5fZ5CQdHxn33fIaIRBfKyww/kaTXfFsytgIaoA0hRIY4bO4s/p3VKbKJhIg
         VJzKas3nuHpUyMmxs/ExIHap8gOEpqCRX3BpHJqWjwqwpVFuVfX8oxPu9Jt4S5gJ0+F3
         8jeHar+S4BcBLgl478Mpgo4M/g41oWze5xWyfFX3r3gnOPgLg7PYvV+LFbqUNO6HP1cf
         MDUQ==
X-Gm-Message-State: AOAM533G7gJWwLhfQcMOVOFJ+4H4YTbyF2BkyXjOwpvm2d9jtW0hYuq9
        o/A0bFKVYTRxpq5vrlcGnbbgYYktR2eNbYaTSTGW/bRKpQT8
X-Google-Smtp-Source: ABdhPJzIzPBJwE2rMNBB25hu4d/eYDdOsTVz0mr9WyCdpNVDqcD5/SshTJsPL0mA28HIO+QQUPJ0jyxkul1JvvFnczSAqYis3y+D
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:928:: with SMTP id o8mr1723893ilt.37.1630657047408;
 Fri, 03 Sep 2021 01:17:27 -0700 (PDT)
Date:   Fri, 03 Sep 2021 01:17:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000fb51f05cb12ee30@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in vm_area_dup
From:   syzbot <syzbot+e561875a461cd966cd9d@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        axboe@kernel.dk, bpf@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, ebiederm@xmission.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3f5ad13cb012 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f9ca49300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94074b5caf8665c7
dashboard link: https://syzkaller.appspot.com/bug?extid=e561875a461cd966cd9d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e561875a461cd966cd9d@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: 0000000000114588
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 157b8067 P4D 157b8067 PUD 34984067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9155 Comm: syz-executor.5 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:freelist_dereference mm/slub.c:287 [inline]
RIP: 0010:get_freepointer mm/slub.c:294 [inline]
RIP: 0010:get_freepointer_safe mm/slub.c:308 [inline]
RIP: 0010:slab_alloc_node mm/slub.c:2927 [inline]
RIP: 0010:slab_alloc mm/slub.c:2967 [inline]
RIP: 0010:kmem_cache_alloc+0x16d/0x4a0 mm/slub.c:2972
Code: 39 f2 75 e7 48 8b 01 48 83 79 10 00 48 89 04 24 0f 84 75 02 00 00 48 85 c0 0f 84 6c 02 00 00 48 8b 7d 00 8b 4d 28 40 f6 c7 0f <48> 8b 1c 08 0f 85 76 02 00 00 48 8d 4a 08 65 48 0f c7 0f 0f 94 c0
RSP: 0018:ffffc9000168f720 EFLAGS: 00010246
RAX: 0000000000114528 RBX: 00000000000000c8 RCX: 0000000000000060
RDX: 0000000000393661 RSI: 0000000000393661 RDI: 00000000000578d0
RBP: ffff888140006a00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff8143dbe8 R14: 0000000000000cc0 R15: 0000000000000cc0
FS:  0000000001575400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000114588 CR3: 000000001839c000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 vm_area_dup+0x88/0x2b0 kernel/fork.c:357
 dup_mmap kernel/fork.c:537 [inline]
 dup_mm+0x543/0x1380 kernel/fork.c:1379
 copy_mm kernel/fork.c:1431 [inline]
 copy_process+0x71ec/0x74d0 kernel/fork.c:2119
 kernel_clone+0xe7/0xac0 kernel/fork.c:2509
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2626
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x464beb
Code: ed 0f 85 60 01 00 00 64 4c 8b 0c 25 10 00 00 00 45 31 c0 4d 8d 91 d0 02 00 00 31 d2 31 f6 bf 11 00 20 01 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 89 00 00 00 41 89 c5 85 c0 0f 85 90 00 00
RSP: 002b:0000000000a9fd50 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000464beb
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000001575400
R10: 00000000015756d0 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000a9fe40
Modules linked in:
CR2: 0000000000114588
---[ end trace 0b04bb8235cb5b3a ]---
RIP: 0010:freelist_dereference mm/slub.c:287 [inline]
RIP: 0010:get_freepointer mm/slub.c:294 [inline]
RIP: 0010:get_freepointer_safe mm/slub.c:308 [inline]
RIP: 0010:slab_alloc_node mm/slub.c:2927 [inline]
RIP: 0010:slab_alloc mm/slub.c:2967 [inline]
RIP: 0010:kmem_cache_alloc+0x16d/0x4a0 mm/slub.c:2972
Code: 39 f2 75 e7 48 8b 01 48 83 79 10 00 48 89 04 24 0f 84 75 02 00 00 48 85 c0 0f 84 6c 02 00 00 48 8b 7d 00 8b 4d 28 40 f6 c7 0f <48> 8b 1c 08 0f 85 76 02 00 00 48 8d 4a 08 65 48 0f c7 0f 0f 94 c0
RSP: 0018:ffffc9000168f720 EFLAGS: 00010246
RAX: 0000000000114528 RBX: 00000000000000c8 RCX: 0000000000000060
RDX: 0000000000393661 RSI: 0000000000393661 RDI: 00000000000578d0
RBP: ffff888140006a00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff8143dbe8 R14: 0000000000000cc0 R15: 0000000000000cc0
FS:  0000000001575400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7c3000b0b8 CR3: 000000001839c000 CR4: 00000000001526e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	39 f2                	cmp    %esi,%edx
   2:	75 e7                	jne    0xffffffeb
   4:	48 8b 01             	mov    (%rcx),%rax
   7:	48 83 79 10 00       	cmpq   $0x0,0x10(%rcx)
   c:	48 89 04 24          	mov    %rax,(%rsp)
  10:	0f 84 75 02 00 00    	je     0x28b
  16:	48 85 c0             	test   %rax,%rax
  19:	0f 84 6c 02 00 00    	je     0x28b
  1f:	48 8b 7d 00          	mov    0x0(%rbp),%rdi
  23:	8b 4d 28             	mov    0x28(%rbp),%ecx
  26:	40 f6 c7 0f          	test   $0xf,%dil
* 2a:	48 8b 1c 08          	mov    (%rax,%rcx,1),%rbx <-- trapping instruction
  2e:	0f 85 76 02 00 00    	jne    0x2aa
  34:	48 8d 4a 08          	lea    0x8(%rdx),%rcx
  38:	65 48 0f c7 0f       	cmpxchg16b %gs:(%rdi)
  3d:	0f 94 c0             	sete   %al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
