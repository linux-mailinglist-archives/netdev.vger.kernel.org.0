Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6BE3FBCD1
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 21:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhH3TUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 15:20:24 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:54925 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhH3TUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 15:20:19 -0400
Received: by mail-io1-f69.google.com with SMTP id o5-20020a6bf8050000b02905b026202a6fso9089451ioh.21
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 12:19:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6RP0xIpJkpUpuQ8zTmp1h0IIspFRUFwWbe3VrI5AA/Y=;
        b=FW2yyaJFdhA1H1OC9Fif2YHQzeX1ho9IiUgU2ApTYyKzjaKzdrh/PTVFgwHD14fIU5
         HZnZ2zInnKKCWn6b6QfflEvpFM4YNENZ3JDhSdMtQ3DdafDpL5+IOMNcbktjI/JeWCcK
         n3Jfm2JAqO11FV8iYvUHQty6AL5PVUL1dia5DkvLnpn8+WqX+GFMVQlJXV9tIMvdQDLq
         5Tbs+b0QrGW6AVYRqW4hOmQVFnAe0td2lp3QYLa2QVzeIqgQJyvFkDAyCnxXxRAUm9ks
         yr5lpiZaW6z4FD876Dhx65EsY7dZZmb5WI1udB50WOFlf0gjXvhOLB2BjEv7m1GWH6s1
         I4LA==
X-Gm-Message-State: AOAM532aooaJiglb4Gga/agKk52tPQq4jfRmMFEASsodO/a8AQB15YzR
        uuK7csXKpCCyn/SrEcyPBNj+BWThe4wbZxBv6wssfp4WeU0H
X-Google-Smtp-Source: ABdhPJx9PNyCiIwofl/EjJEnTQxN70bccUaoPeDBna3+HVxh4tXJERAy00pVfGmF6Z3oOTCYzu5NCG57qd17hSEshDZPaf4ooI4H
MIME-Version: 1.0
X-Received: by 2002:a92:cb0f:: with SMTP id s15mr17264650ilo.59.1630351165304;
 Mon, 30 Aug 2021 12:19:25 -0700 (PDT)
Date:   Mon, 30 Aug 2021 12:19:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011360d05cacbb622@google.com>
Subject: [syzbot] general protection fault in sock_from_file
From:   syzbot <syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    93717cde744f Add linux-next specific files for 20210830
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15b851fe300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c643ef5289990dd1
dashboard link: https://syzkaller.appspot.com/bug?extid=f9704d1878e290eddf73
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 1 PID: 6072 Comm: syz-executor.0 Not tainted 5.14.0-next-20210830-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sock_from_file+0x20/0x90 net/socket.c:505
Code: f5 ff ff ff c3 0f 1f 44 00 00 41 54 53 48 89 fb e8 85 e9 62 fa 48 8d 7b 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 4f 45 31 e4 48 81 7b 28 80 f1 8a 8a 74 0c e8 58 e9
RSP: 0018:ffffc9000a2df8e8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002f91000
RDX: 0000000000000005 RSI: ffffffff8713203b RDI: 0000000000000028
RBP: ffff8880983c2c80 R08: ffffffff899aee40 R09: ffffffff81e21978
R10: 0000000000000027 R11: 0000000000000009 R12: dffffc0000000000
R13: 1ffff11013078599 R14: 0000000000000003 R15: ffff8880983c2c80
FS:  00007fe7b0454700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005591dffa5180 CR3: 00000000974cb000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_sendmsg+0x98/0x640 fs/io_uring.c:4681
 io_issue_sqe+0x14de/0x6ba0 fs/io_uring.c:6578
 __io_queue_sqe+0x90/0xb50 fs/io_uring.c:6864
 io_req_task_submit+0xbf/0x1b0 fs/io_uring.c:2218
 tctx_task_work+0x166/0x610 fs/io_uring.c:2143
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_signal include/linux/tracehook.h:212 [inline]
 handle_signal_work kernel/entry/common.c:146 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x256/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe7b0454188 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: 0000000000001000 RBX: 000000000056bf80 RCX: 00000000004665f9
RDX: 0000000000000000 RSI: 000000000000688c RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007fffeee6585f R14: 00007fe7b0454300 R15: 0000000000022000
Modules linked in:
---[ end trace 6f9e359dd487b8fa ]---
RIP: 0010:sock_from_file+0x20/0x90 net/socket.c:505
Code: f5 ff ff ff c3 0f 1f 44 00 00 41 54 53 48 89 fb e8 85 e9 62 fa 48 8d 7b 28 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 4f 45 31 e4 48 81 7b 28 80 f1 8a 8a 74 0c e8 58 e9
RSP: 0018:ffffc9000a2df8e8 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002f91000
RDX: 0000000000000005 RSI: ffffffff8713203b RDI: 0000000000000028
RBP: ffff8880983c2c80 R08: ffffffff899aee40 R09: ffffffff81e21978
R10: 0000000000000027 R11: 0000000000000009 R12: dffffc0000000000
R13: 1ffff11013078599 R14: 0000000000000003 R15: ffff8880983c2c80
FS:  00007fe7b0454700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb81002c710 CR3: 00000000974cb000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	ff c3                	inc    %ebx
   2:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   7:	41 54                	push   %r12
   9:	53                   	push   %rbx
   a:	48 89 fb             	mov    %rdi,%rbx
   d:	e8 85 e9 62 fa       	callq  0xfa62e997
  12:	48 8d 7b 28          	lea    0x28(%rbx),%rdi
  16:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1d:	fc ff df
  20:	48 89 fa             	mov    %rdi,%rdx
  23:	48 c1 ea 03          	shr    $0x3,%rdx
* 27:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2b:	75 4f                	jne    0x7c
  2d:	45 31 e4             	xor    %r12d,%r12d
  30:	48 81 7b 28 80 f1 8a 	cmpq   $0xffffffff8a8af180,0x28(%rbx)
  37:	8a
  38:	74 0c                	je     0x46
  3a:	e8                   	.byte 0xe8
  3b:	58                   	pop    %rax
  3c:	e9                   	.byte 0xe9


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
