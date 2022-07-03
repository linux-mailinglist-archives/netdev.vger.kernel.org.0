Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DAB56458D
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiGCHX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbiGCHXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:23:24 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5177B5F4F
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 00:23:22 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id x2-20020a6bda02000000b0067590503c08so4016579iob.5
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 00:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=a2uI9KLquXajc5Uhxt1Ev4JBY9PbkZ6Xt4aQBhCyNVQ=;
        b=2Ruuy9H5TKiIF03KozTzkcYrTwaLmzFDcwcYK6VbtO+v/ixYBcgCwSb5s2EUNaTAoA
         z9w2QjAhe1InO4aozQAjAadlPNPBL/3x2TNooJveQK7+pxVCAxQfAgQpgUaqNZbmcMPR
         JRVpUNk0eboLmgSnGFrI0ow7Vj3odlQSdu+Dhex3Wqil3Krhc5q+Jx77xncUFfi1BEyh
         Zlrwdul+T+qLNbbwc/3gbCK5EznBJEVYwPw9LweMPD6Q+xfpBcdfBoPe6AhLtsAU36Nb
         PUpJXG0ddoZE/m+qeT5Bx1Mll8zXPHBOiupl8tbMzJYdiP2CK62s4LtIyQZQ2rTGuL+A
         yYrA==
X-Gm-Message-State: AJIora9o6qmJRRq3sdtZpSaWkRl/Z79QTIuOdJX8ipzLY6Ir1CAB4+OA
        v6trKrKQh5WQoAy6h4W2FGmnf+ctgsXSEl1eHFVvHLoy4b12
X-Google-Smtp-Source: AGRyM1uZ/fArPWzkvq94pqmfvmcruQtyXE9yowiCg+kaajqsbCPkFwuNisbGAC0spqN3tcH9JdTZkJUDJ8xIYjKLLz0q9L2ux5wm
MIME-Version: 1.0
X-Received: by 2002:a05:6638:358d:b0:339:f213:275 with SMTP id
 v13-20020a056638358d00b00339f2130275mr14402641jal.250.1656833001683; Sun, 03
 Jul 2022 00:23:21 -0700 (PDT)
Date:   Sun, 03 Jul 2022 00:23:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008481dc05e2e17e7d@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in bpf_prog_ADDR_F
From:   syzbot <syzbot+66d306fee539916084c2@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    179a93f74b29 fprobe, samples: Add module parameter descrip..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=17bc8604080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70e1a4d352a3c6ae
dashboard link: https://syzkaller.appspot.com/bug?extid=66d306fee539916084c2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+66d306fee539916084c2@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffffffa0000a18
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD ba8f067 P4D ba8f067 PUD ba90063 PMD 1451e6067 PTE 0
Oops: 0010 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10814 Comm: syz-executor.2 Not tainted 5.19.0-rc2-syzkaller-00122-g179a93f74b29 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_prog_9d4bccaf8ccaf0dc_F+0x0/0xd
Code: Unable to access opcode bytes at RIP 0xffffffffa00009ee.
RSP: 0018:ffffc90003517250 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffffc90003563000 RCX: 0000000000000000
RDX: 1ffff920006ac606 RSI: ffffc90003563048 RDI: 00000000ffff8880
RBP: ffffc90003517258 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: ffff88802403bb00 R14: ffff88802fa60000 R15: 0000000000000001
FS:  00007f63ca616700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa00009ee CR3: 000000002f068000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bpf_dispatcher_nop_func include/linux/bpf.h:869 [inline]
 __bpf_prog_run include/linux/filter.h:628 [inline]
 bpf_prog_run include/linux/filter.h:635 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:2046 [inline]
 bpf_trace_run4+0x124/0x360 kernel/trace/bpf_trace.c:2085
 __bpf_trace_sched_switch+0x115/0x160 include/trace/events/sched.h:222
 __traceiter_sched_switch+0x68/0xb0 include/trace/events/sched.h:222
 trace_sched_switch include/trace/events/sched.h:222 [inline]
 __schedule+0x145b/0x4b30 kernel/sched/core.c:6425
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6593
 preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
 __raw_spin_unlock include/linux/spinlock_api_smp.h:143 [inline]
 _raw_spin_unlock+0x36/0x40 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:389 [inline]
 __cond_resched_lock+0x93/0xe0 kernel/sched/core.c:8270
 __purge_vmap_area_lazy+0x976/0x1c50 mm/vmalloc.c:1728
 _vm_unmap_aliases.part.0+0x3f0/0x500 mm/vmalloc.c:2125
 _vm_unmap_aliases mm/vmalloc.c:2099 [inline]
 vm_remove_mappings mm/vmalloc.c:2624 [inline]
 __vunmap+0x6d5/0xd30 mm/vmalloc.c:2651
 __vfree+0x3c/0xd0 mm/vmalloc.c:2713
 vfree+0x5a/0x90 mm/vmalloc.c:2744
 bpf_jit_binary_free kernel/bpf/core.c:1080 [inline]
 bpf_jit_free+0x21a/0x2b0 kernel/bpf/core.c:1203
 jit_subprogs kernel/bpf/verifier.c:13683 [inline]
 fixup_call_args kernel/bpf/verifier.c:13712 [inline]
 bpf_check+0x71ab/0xbbc0 kernel/bpf/verifier.c:15063
 bpf_prog_load+0xfb2/0x2250 kernel/bpf/syscall.c:2575
 __sys_bpf+0x11a1/0x5700 kernel/bpf/syscall.c:4917
 __do_sys_bpf kernel/bpf/syscall.c:5021 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5019 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5019
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f63c9489109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f63ca616168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f63c959c030 RCX: 00007f63c9489109
RDX: 0000000000000070 RSI: 0000000020000440 RDI: 0000000000000005
RBP: 00007f63c94e305d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffde158863f R14: 00007f63ca616300 R15: 0000000000022000
 </TASK>
Modules linked in:
CR2: ffffffffa0000a18
---[ end trace 0000000000000000 ]---
RIP: 0010:bpf_prog_9d4bccaf8ccaf0dc_F+0x0/0xd
Code: Unable to access opcode bytes at RIP 0xffffffffa00009ee.
RSP: 0018:ffffc90003517250 EFLAGS: 00010046

RAX: dffffc0000000000 RBX: ffffc90003563000 RCX: 0000000000000000
RDX: 1ffff920006ac606 RSI: ffffc90003563048 RDI: 00000000ffff8880
RBP: ffffc90003517258 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000001
R13: ffff88802403bb00 R14: ffff88802fa60000 R15: 0000000000000001
FS:  00007f63ca616700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffa00009ee CR3: 000000002f068000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
