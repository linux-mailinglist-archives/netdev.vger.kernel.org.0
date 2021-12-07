Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5646BD11
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhLGOCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:02:00 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:51736 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbhLGOB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:01:59 -0500
Received: by mail-il1-f199.google.com with SMTP id l2-20020a056e021aa200b002a281027bb8so11917298ilv.18
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 05:58:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=vyYT5lQSN9Sd07tZWpU3Ums+gflAZlF8eMmG8VRlrwU=;
        b=6b6V8JrJ/0s3VXXS3G0YBB8zd0fCjeunZp7juuiiAOhOHlP8IQiyhOtiV9ZjBWvDV9
         8jIAVppF07Ndm0cRbszJ3FPtKeksTAijuYVG3h0Eft+GpQSyj9kEX9SL/CaK4t8WqOdT
         P0ryHM4CJqfk8FhcjsT9xFFM+ZQ6SHd7e8GlNKGSwkGpsj/X/EXx3v89SCNNXNC7yp5b
         usfRZ8IXyRUTFFaSzdPV8q992IqYUQkw5RNPXfp5rol4fGB2Q8S9i9OhTQ8kT4bGrriD
         SvUxZ7NHXfTt35OvhttchpSBW+w+NEC5SZ8agAcOkz6DXOGbgiBbN/abR9f6awW/KbV7
         fnKA==
X-Gm-Message-State: AOAM5321p3djHMgPAEzu5X2UmRIBaQMhIxJETgCw6gUILJ5JhDMKJkDP
        xXjR/DrYUPdkrMe+uOeMcP/s1kqf2iKx2VTi2Mv0+HyY+zXu
X-Google-Smtp-Source: ABdhPJwq6tpUBzOzsC5a8oLyelPmZ6yFy3KVG3mvshYWc3YUKRwnnyTlzhpa2+wW3ND6VGNGDJPe8XwqgB4tgTAHpvLHTFdRoIES
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:484:: with SMTP id b4mr39006206ils.173.1638885509424;
 Tue, 07 Dec 2021 05:58:29 -0800 (PST)
Date:   Tue, 07 Dec 2021 05:58:29 -0800
In-Reply-To: <000000000000a636fc05cee1e95b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009dee1a05d28ec4a1@google.com>
Subject: Re: [syzbot] INFO: rcu detected stall in sys_bpf (5)
From:   syzbot <syzbot+7caa651776c38f7fed6c@syzkaller.appspotmail.com>
To:     fweisbec@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d5284dedccdb libbpf: Add doc comments in libbpf.h
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=157d0e55b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a262045c4c15a9e0
dashboard link: https://syzkaller.appspot.com/bug?extid=7caa651776c38f7fed6c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132f9da9b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e749a9b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7caa651776c38f7fed6c@syzkaller.appspotmail.com

hrtimer: interrupt took 34034 ns
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	0-....: (11003 ticks this GP) idle=21b/1/0x4000000000000000 softirq=8763/8765 fqs=5250 
	(t=10502 jiffies g=11285 q=14)
NMI backtrace for cpu 0
CPU: 0 PID: 6526 Comm: syz-executor734 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:105
 nmi_trigger_cpumask_backtrace+0x1ae/0x220 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:711 [inline]
 rcu_pending kernel/rcu/tree.c:3878 [inline]
 rcu_sched_clock_irq.cold+0x9d/0x746 kernel/rcu/tree.c:2597
 update_process_times+0x16d/0x200 kernel/time/timer.c:1785
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1421
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1c0/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:htab_unlock_bucket kernel/bpf/hashtab.c:192 [inline]
RIP: 0010:htab_lru_map_update_elem+0x463/0x8c0 kernel/bpf/hashtab.c:1178
Code: 04 00 00 49 89 6d 08 e8 6b 8b ea ff 48 8b 74 24 28 48 b8 22 01 00 00 00 00 ad de 48 8b 7c 24 10 49 89 44 24 08 e8 2d f3 b0 07 <48> c7 c7 20 d4 93 89 e8 e1 23 ae 07 48 8b 54 24 18 48 b8 00 00 00
RSP: 0018:ffffc90000cd7a88 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88807efdc800 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff8880218f2c00 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817e0a58 R11: 0000000000000000 R12: ffff8880218f2c40
R13: 000000000000000b R14: 0000000000000005 R15: 0000000000000001
 bpf_map_update_value.isra.0+0x2e8/0x910 kernel/bpf/syscall.c:207
 generic_map_update_batch+0x3f2/0x5b0 kernel/bpf/syscall.c:1396
 bpf_map_do_batch+0x3d5/0x510 kernel/bpf/syscall.c:4207
 __sys_bpf+0x2761/0x5f10 kernel/bpf/syscall.c:4682
 __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa79bb49f29
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdbbb21d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa79bb49f29
RDX: 0000000000000038 RSI: 0000000020000480 RDI: 000000000000001a
RBP: 0000000000000000 R08: 00007ffdbbb21f28 R09: 00007ffdbbb21f28
R10: 00007ffdbbb21f28 R11: 0000000000000246 R12: 00007fa79bb0d7b0
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	04 00                	add    $0x0,%al
   2:	00 49 89             	add    %cl,-0x77(%rcx)
   5:	6d                   	insl   (%dx),%es:(%rdi)
   6:	08 e8                	or     %ch,%al
   8:	6b 8b ea ff 48 8b 74 	imul   $0x74,-0x74b70016(%rbx),%ecx
   f:	24 28                	and    $0x28,%al
  11:	48 b8 22 01 00 00 00 	movabs $0xdead000000000122,%rax
  18:	00 ad de
  1b:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  20:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  25:	e8 2d f3 b0 07       	callq  0x7b0f357
* 2a:	48 c7 c7 20 d4 93 89 	mov    $0xffffffff8993d420,%rdi <-- trapping instruction
  31:	e8 e1 23 ae 07       	callq  0x7ae2417
  36:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  3b:	48                   	rex.W
  3c:	b8                   	.byte 0xb8
  3d:	00 00                	add    %al,(%rax)

