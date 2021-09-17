Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D841008C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244903AbhIQVHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:07:51 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:54860 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244489AbhIQVHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 17:07:49 -0400
Received: by mail-io1-f71.google.com with SMTP id e2-20020a056602044200b005c23c701e26so22044720iov.21
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 14:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2WmomhkD51wIWOOU3RkzQPqwZsHbNfmPQ1ty9n1eE5c=;
        b=zOAHkZEc2BKne841DBMPnWyIDeWaQ2/mqIhi0fNP9AY99t2E+KxKEbAbe3EaGw9P0s
         VG6h9pT/CSkdRaI3EtUbZXbawlinPXO9rfebYjJPY37aeUPzjED/tvF45YJXg7+XR9Dr
         P9Kaitodr7AiaPtzCJy2bceQvbI/KRslheGfLTPFV3DkO44GB523OVeOcInehCXNjdhg
         E+kPytAl/95O8avmGCX0YrgLR7aT5r+KBRQdie16TSPiIKjAi5Mqu5Ju1asAcekBtWYd
         amUDleeb6D0Pxue/upbQ5RiReyBklo0WRbST5SJirTixN/6ID9+Deklqf9I9rgu5daH8
         kJAg==
X-Gm-Message-State: AOAM530Y5jej+cUHbsmno+GlFcN+0ph3TFCB8SjXfTQKl/damNSsaBvu
        boEP8zsnIglEtDh31bJStJ55ou49Jak+St9mexs+MnRucznm
X-Google-Smtp-Source: ABdhPJwcXY4hOe4rF5uMBVJqp8pZYf8i7SorzdJZH1w9phoM0nqDf8CL6+KmIFofF8111goxRfs/n3y5uL7i6sJ0Oe2dd7xtrwjG
MIME-Version: 1.0
X-Received: by 2002:a92:c7af:: with SMTP id f15mr9420398ilk.64.1631912786480;
 Fri, 17 Sep 2021 14:06:26 -0700 (PDT)
Date:   Fri, 17 Sep 2021 14:06:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f152a305cc374d7b@google.com>
Subject: [syzbot] general protection fault in bpf_skb_cgroup_id
From:   syzbot <syzbot+33f36d0754d4c5c0e102@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
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

HEAD commit:    2865ba82476a Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=15089853300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
dashboard link: https://syzkaller.appspot.com/bug?extid=33f36d0754d4c5c0e102
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14dbd7ed300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1586f83b300000

Bisection is inconclusive: the first bad commit could be any of:

0e6491b55970 bpf: Add oversize check before call kvcalloc()
2f1aaf3ea666 bpf, mm: Fix lockdep warning triggered by stack_map_get_build_id_offset()
8520e224f547 bpf, cgroups: Fix cgroup v2 fallback on v1/v2 mixed mode
3a029e1f3d6e selftests/bpf: Fix build of task_pt_regs test for arm64
d8079d8026f8 bpf, selftests: Add cgroup v1 net_cls classid helpers
43d2b88c29f2 bpf, selftests: Add test case for mixed cgroup v1/v2
49ca6153208f bpf: Relicense disassembler as GPL-2.0-only OR BSD-2-Clause
2865ba82476a Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16b5ccdd300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+33f36d0754d4c5c0e102@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000029: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000148-0x000000000000014f]
CPU: 1 PID: 8436 Comm: syz-executor679 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cgroup_id include/linux/cgroup.h:312 [inline]
RIP: 0010:__bpf_sk_cgroup_id net/core/filter.c:4468 [inline]
RIP: 0010:____bpf_skb_cgroup_id net/core/filter.c:4473 [inline]
RIP: 0010:bpf_skb_cgroup_id+0x138/0x210 net/core/filter.c:4471
Code: 03 80 3c 02 00 0f 85 cc 00 00 00 48 8b 9b 58 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 48 01 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ad 00 00 00 48 8b 9b 48 01 00 00 48 b8 00 00 00
RSP: 0018:ffffc9000184f9c0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000029 RSI: ffffffff8728f537 RDI: 0000000000000148
RBP: 0000000000000080 R08: 0000000000000000 R09: 0000000000000007
R10: ffffffff8728f52a R11: 000000000000001f R12: 0000000000000007
R13: ffffc90000e6a000 R14: ffffc9000184fc30 R15: ffffc90000e6a048
FS:  0000000000f5e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200004c0 CR3: 000000001d929000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bpf_prog_3a33f00dea259162+0x10/0xfa8
 bpf_dispatcher_nop_func include/linux/bpf.h:717 [inline]
 __bpf_prog_run include/linux/filter.h:624 [inline]
 bpf_prog_run include/linux/filter.h:631 [inline]
 bpf_test_run+0x381/0xa30 net/bpf/test_run.c:119
 bpf_prog_test_run_skb+0xac5/0x1d20 net/bpf/test_run.c:657
 bpf_prog_test_run kernel/bpf/syscall.c:3307 [inline]
 __sys_bpf+0x2137/0x5df0 kernel/bpf/syscall.c:4605
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f009
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcff384d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f009
RDX: 0000000000000028 RSI: 0000000020000440 RDI: 000000000000000a
RBP: 0000000000402ff0 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403080
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
Modules linked in:
---[ end trace d161abccc2184019 ]---
RIP: 0010:cgroup_id include/linux/cgroup.h:312 [inline]
RIP: 0010:__bpf_sk_cgroup_id net/core/filter.c:4468 [inline]
RIP: 0010:____bpf_skb_cgroup_id net/core/filter.c:4473 [inline]
RIP: 0010:bpf_skb_cgroup_id+0x138/0x210 net/core/filter.c:4471
Code: 03 80 3c 02 00 0f 85 cc 00 00 00 48 8b 9b 58 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 48 01 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ad 00 00 00 48 8b 9b 48 01 00 00 48 b8 00 00 00
RSP: 0018:ffffc9000184f9c0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000029 RSI: ffffffff8728f537 RDI: 0000000000000148
RBP: 0000000000000080 R08: 0000000000000000 R09: 0000000000000007
R10: ffffffff8728f52a R11: 000000000000001f R12: 0000000000000007
R13: ffffc90000e6a000 R14: ffffc9000184fc30 R15: ffffc90000e6a048
FS:  0000000000f5e300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200004c0 CR3: 000000001d929000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   4:	0f 85 cc 00 00 00    	jne    0xd6
   a:	48 8b 9b 58 04 00 00 	mov    0x458(%rbx),%rbx
  11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  18:	fc ff df
  1b:	48 8d bb 48 01 00 00 	lea    0x148(%rbx),%rdi
  22:	48 89 fa             	mov    %rdi,%rdx
  25:	48 c1 ea 03          	shr    $0x3,%rdx
* 29:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2d:	0f 85 ad 00 00 00    	jne    0xe0
  33:	48 8b 9b 48 01 00 00 	mov    0x148(%rbx),%rbx
  3a:	48                   	rex.W
  3b:	b8                   	.byte 0xb8
  3c:	00 00                	add    %al,(%rax)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
