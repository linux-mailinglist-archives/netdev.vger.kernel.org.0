Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B441008F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343513AbhIQVH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:07:56 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38825 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244509AbhIQVHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 17:07:49 -0400
Received: by mail-io1-f71.google.com with SMTP id n8-20020a6b7708000000b005bd491bdb6aso22218444iom.5
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 14:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IRUxZF+30/m7CRt35/mILrxgjdobMDTrqZYv4sIXjd0=;
        b=vKdadqfSJLHHog784XY00nuLxbaNFZUdNSw+XWcJVhmnt4NBHLJUQkb7fxaujqNYut
         HZwgl/48+tAGUfSSw8+PL1kTpFfDLKeGIxExAY98Gk6SnyjSkaKLcYPxTASLV1jI3mn+
         rKYmPyia/xljLyxcLXokDkxiT1vX04tmUa7OfkppftQdfG+2wyJwDh1yhczyxXGUvybe
         j4KPhduOfiAZ7oR336SNUnB4a+/UTFPBp5ZK4tb3yigHJF6XHTaCX3cLT6DNWHDTSr4e
         HGpJNDoADS6fzgbZlSiMOO2uaMxMKbvIagKp6hjMHjN1pY72XIrLfrGBgfWrj2N8y+Uj
         nM1Q==
X-Gm-Message-State: AOAM533RuHMgiMZtKSO2by6aV1lwzujy34CwpGgAckDKE2hUp5UKGGHw
        Nww9qCgWC90iopRlEU1joAQULnqeb4gBERq7Dcx1QhWgrAOF
X-Google-Smtp-Source: ABdhPJzPsJaQKftJlrcXPNrknVhwc024yZnQuE8x7qN80OwVYrERfE3JbKhh5gDn7RkzCrSiNFo1WWpGjz61HC+tFI8TmE1GYLwF
MIME-Version: 1.0
X-Received: by 2002:a05:6638:408f:: with SMTP id m15mr10416038jam.94.1631912786232;
 Fri, 17 Sep 2021 14:06:26 -0700 (PDT)
Date:   Fri, 17 Sep 2021 14:06:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ed8c2e05cc374dd3@google.com>
Subject: [syzbot] general protection fault in bpf_skb_ancestor_cgroup_id
From:   syzbot <syzbot+664b58e9a40fbb2cec71@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=10732da5300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
dashboard link: https://syzkaller.appspot.com/bug?extid=664b58e9a40fbb2cec71
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11834d43300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=169a6273300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+664b58e9a40fbb2cec71@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000024: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000120-0x0000000000000127]
CPU: 0 PID: 8406 Comm: syz-executor074 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cgroup_ancestor include/linux/cgroup.h:593 [inline]
RIP: 0010:__bpf_sk_ancestor_cgroup_id net/core/filter.c:4494 [inline]
RIP: 0010:____bpf_skb_ancestor_cgroup_id net/core/filter.c:4504 [inline]
RIP: 0010:bpf_skb_ancestor_cgroup_id+0x152/0x300 net/core/filter.c:4501
Code: 03 80 3c 02 00 0f 85 9f 01 00 00 48 8b 9b 58 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 20 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 48 01 00 00 8b ab 20 01 00 00
RSP: 0018:ffffc9000101f828 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000024 RSI: ffffffff87291cee RDI: 0000000000000120
RBP: 0000000000000080 R08: 0000000000000000 R09: 0000000000000007
R10: ffffffff87291cd1 R11: 000000000000001f R12: fffffffffffffe00
R13: 00000000fffffe00 R14: ffffc9000101fc30 R15: ffffc90000e48048
FS:  0000000001234300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000200 CR3: 000000007193e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bpf_prog_dcdd7aeecda69f3f+0x54/0x690
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
RIP: 0033:0x43f059
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc82a88608 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f059
RDX: 0000000000000040 RSI: 0000000020000280 RDI: 000000000000000a
RBP: 0000000000403040 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004030d0
R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
Modules linked in:
---[ end trace 55d65f18b4ef47bb ]---
RIP: 0010:cgroup_ancestor include/linux/cgroup.h:593 [inline]
RIP: 0010:__bpf_sk_ancestor_cgroup_id net/core/filter.c:4494 [inline]
RIP: 0010:____bpf_skb_ancestor_cgroup_id net/core/filter.c:4504 [inline]
RIP: 0010:bpf_skb_ancestor_cgroup_id+0x152/0x300 net/core/filter.c:4501
Code: 03 80 3c 02 00 0f 85 9f 01 00 00 48 8b 9b 58 04 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bb 20 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 48 01 00 00 8b ab 20 01 00 00
RSP: 0018:ffffc9000101f828 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000024 RSI: ffffffff87291cee RDI: 0000000000000120
RBP: 0000000000000080 R08: 0000000000000000 R09: 0000000000000007
R10: ffffffff87291cd1 R11: 000000000000001f R12: fffffffffffffe00
R13: 00000000fffffe00 R14: ffffc9000101fc30 R15: ffffc90000e48048
FS:  0000000001234300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb37a158740 CR3: 000000007193e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	03 80 3c 02 00 0f    	add    0xf00023c(%rax),%eax
   6:	85 9f 01 00 00 48    	test   %ebx,0x48000001(%rdi)
   c:	8b 9b 58 04 00 00    	mov    0x458(%rbx),%ebx
  12:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  19:	fc ff df
  1c:	48 8d bb 20 01 00 00 	lea    0x120(%rbx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 48 01 00 00    	jle    0x182
  3a:	8b ab 20 01 00 00    	mov    0x120(%rbx),%ebp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
