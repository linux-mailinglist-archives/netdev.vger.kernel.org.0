Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6641008A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 23:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244589AbhIQVHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 17:07:50 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:57225 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbhIQVHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 17:07:48 -0400
Received: by mail-io1-f70.google.com with SMTP id z71-20020a6bc94a000000b005d09bfe2668so22155358iof.23
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 14:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9AAfy8vz7X48RakX5qmvtJuCqlgc04FLdAAg8dZbBmw=;
        b=3ld/CIkPOCtUsct0S7nDFRHs+Pk5isQNEDXO7n7GntvZQVGDnVXscJkVTxWq2hJ1Yl
         3WNXT+Jf9ZrR4qn0Hs62rEN13klqcV0qXnzxi4URZ9MFIoQvRhYdaXy1dARLych9Qxco
         Gne2VTFc5GDDwDJvDMMkllpE3IqMlbPM65Y7ccXhhtxp8Vsq5vq9Wo6Uc3mt1pZk1iqs
         3g4+Wz0jcEZUCHmA0i3uHF32ygZ0U8sKWFwNywP/c+/nMDL1Vwp0B29+l7vgQz2iccEj
         tofjSZUWafShG6jWsJlZpqnXMK/k7syMgHdkL7kUPSqAABl1GbjU25QmVrrdAc1KyWHE
         0gWw==
X-Gm-Message-State: AOAM531ituE0DnncgyUkImUz0w2+3brRvl6ZsbmyQc6eAjqJ2hNShCgQ
        Mq9gsHshyZd0Fv3EEiY7lDyHGUwN4zzK8W+RVOybQgmrcS/r
X-Google-Smtp-Source: ABdhPJwnFJXimuA11CmjR/rNYsxW5yhJaAHznH4tp4EsiIzIRSTp5/JxSbdQN5K1yC/AQRm6uXHmIZu1l1UChKWebgRMGb2AKWX7
MIME-Version: 1.0
X-Received: by 2002:a6b:5c17:: with SMTP id z23mr9946530ioh.3.1631912785943;
 Fri, 17 Sep 2021 14:06:25 -0700 (PDT)
Date:   Fri, 17 Sep 2021 14:06:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e9239405cc374d5c@google.com>
Subject: [syzbot] general protection fault in cgroup_sk_free
From:   syzbot <syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        daniel@iogearbox.net, hannes@cmpxchg.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        lizefan.x@bytedance.com, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7366c23ff492 ptp: dp83640: don't define PAGE0
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15af7951300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c31c0936547df9ea
dashboard link: https://syzkaller.appspot.com/bug?extid=df709157a4ecaf192b03
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f2b28d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1656e7c7300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df709157a4ecaf192b03@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000182: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000c10-0x0000000000000c17]
CPU: 0 PID: 10393 Comm: syz-executor023 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
RIP: 0010:percpu_ref_put_many include/linux/percpu-refcount.h:319 [inline]
RIP: 0010:percpu_ref_put include/linux/percpu-refcount.h:338 [inline]
RIP: 0010:cgroup_bpf_put include/linux/cgroup.h:926 [inline]
RIP: 0010:cgroup_sk_free+0x8d/0x570 kernel/cgroup/cgroup.c:6613
Code: 0e 06 00 40 84 ed 5a 0f 84 42 01 00 00 e8 0b 08 06 00 4c 8d ab 10 0c 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <80> 3c 02 00 0f 85 6f 04 00 00 48 8b ab 10 0c 00 00 31 ff 49 89 ec
RSP: 0018:ffffc9000cef79c0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000182 RSI: ffffffff81700755 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff81700746 R11: 0000000000000000 R12: ffff888017463000
R13: 0000000000000c10 R14: ffffffff8d0d318c R15: ffff888017463060
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000000b68e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 sk_prot_free net/core/sock.c:1852 [inline]
 __sk_destruct+0x579/0x900 net/core/sock.c:1943
 sk_destruct+0xbd/0xe0 net/core/sock.c:1958
 __sk_free+0xef/0x3d0 net/core/sock.c:1969
 sk_free+0x78/0xa0 net/core/sock.c:1980
 sock_put include/net/sock.h:1815 [inline]
 nr_release+0x392/0x450 net/netrom/af_netrom.c:554
 __sock_release+0xcd/0x280 net/socket.c:649
 sock_close+0x18/0x20 net/socket.c:1314
 __fput+0x288/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xbae/0x2a30 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:922
 get_signal+0x47f/0x2160 kernel/signal.c:2868
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:865
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x443559
Code: Unable to access opcode bytes at RIP 0x44352f.
RSP: 002b:00007fff3922f8c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002b
RAX: 0000000000000003 RBX: 0000000000000003 RCX: 0000000000443559
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000003 R08: 000000000000000d R09: 000000000000000d
R10: 000000000000000d R11: 0000000000000246 R12: 00000000009db2c0
R13: 0000000000000000 R14: 00000000004b8018 R15: 00000000004004b8
Modules linked in:
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	00 40 84             	add    %al,-0x7c(%rax)
   3:	ed                   	in     (%dx),%eax
   4:	5a                   	pop    %rdx
   5:	0f 84 42 01 00 00    	je     0x14d
   b:	e8 0b 08 06 00       	callq  0x6081b
  10:	4c 8d ab 10 0c 00 00 	lea    0xc10(%rbx),%r13
  17:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1e:	fc ff df
  21:	4c 89 ea             	mov    %r13,%rdx
  24:	48 c1 ea 03          	shr    $0x3,%rdx
* 28:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2c:	0f 85 6f 04 00 00    	jne    0x4a1
  32:	48 8b ab 10 0c 00 00 	mov    0xc10(%rbx),%rbp
  39:	31 ff                	xor    %edi,%edi
  3b:	49 89 ec             	mov    %rbp,%r12


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
