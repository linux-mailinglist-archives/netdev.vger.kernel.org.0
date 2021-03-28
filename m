Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF66334BA90
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 05:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhC1Dij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 23:38:39 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:43235 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhC1DiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 23:38:15 -0400
Received: by mail-il1-f200.google.com with SMTP id d15so9498761ila.10
        for <netdev@vger.kernel.org>; Sat, 27 Mar 2021 20:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Tfy9Ntd9u/Eiw1HKIgP4x1baNiJMCjELlqywhOpILng=;
        b=HMHfDAVEcTdRaz5Zsf4MsUexeauewqe65wlyfGcb/0A0+2nUpH6wFQfmFrv5inc40P
         4H/n7f9nPry/YTtUtriD6Y/sLYizDmTJhEM4fYVUPmhKdnAXZsVgHnoy4sSRJ6lFYKlg
         fEJgnuniwwyHPRJ3ozCskvjq+JAqCCZ2zdoRUmA1Dp25kw2D6gBo1LvxVEcKMOgqMSII
         ryEQtgP7i4sMN3Dq51ZEQgjaTf/hKWple75pX+Qxbc0N9Yz9SIW3hal+xLrn2Y/woP5F
         AkfH/OcIk+XjrBbUdAdojtBAgq9uIM4IzbQBPHlbBNmCGbG7egLPo5tK2HkxqqnCS9bT
         7bMQ==
X-Gm-Message-State: AOAM5324UXq6H9HjjdBRLFKm3UxoFAF197teMBoXRwwTpfO9XTmmsx5r
        neWpGAj4NJMV/po8/NDrMw76crXuE7kbAq/hP0QzWRrigzcb
X-Google-Smtp-Source: ABdhPJxc1cZ5o58MMOE5ax4F3LCfKT0dP+NqMuxjarH6l2JnUap7nyMn7S6tMLLKS8DzXE/f6qFfbxk13GzuGHNqo1vpUPss2nHZ
MIME-Version: 1.0
X-Received: by 2002:a92:6810:: with SMTP id d16mr17101631ilc.88.1616902694801;
 Sat, 27 Mar 2021 20:38:14 -0700 (PDT)
Date:   Sat, 27 Mar 2021 20:38:14 -0700
In-Reply-To: <0000000000008f912605bd30d5d7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c2987605be907e41@google.com>
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in ___bpf_prog_run
From:   syzbot <syzbot+bed360704c521841c85d@syzkaller.appspotmail.com>
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    0f4498ce Merge tag 'for-5.12/dm-fixes-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d734aad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4e9addca54f3b44
dashboard link: https://syzkaller.appspot.com/bug?extid=bed360704c521841c85d
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1424cd9ed00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1085497cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in kernel/bpf/core.c:1421:2
shift exponent 248 is too large for 32-bit type 'unsigned int'
CPU: 1 PID: 8388 Comm: syz-executor895 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 ___bpf_prog_run.cold+0x20f/0x56c kernel/bpf/core.c:1421
 __bpf_prog_run480+0x99/0xe0 kernel/bpf/core.c:1739
 bpf_dispatcher_nop_func include/linux/bpf.h:659 [inline]
 __bpf_trace_run kernel/trace/bpf_trace.c:2091 [inline]
 bpf_trace_run2+0x12f/0x390 kernel/trace/bpf_trace.c:2128
 __bpf_trace_tlb_flush+0xbd/0x100 include/trace/events/tlb.h:38
 trace_tlb_flush+0xe0/0x1c0 include/trace/events/tlb.h:38
 switch_mm_irqs_off+0x48b/0x970 arch/x86/mm/tlb.c:563
 unuse_temporary_mm arch/x86/kernel/alternative.c:842 [inline]
 __text_poke+0x541/0x8c0 arch/x86/kernel/alternative.c:938
 text_poke_bp_batch+0x187/0x550 arch/x86/kernel/alternative.c:1190
 text_poke_flush arch/x86/kernel/alternative.c:1347 [inline]
 text_poke_flush arch/x86/kernel/alternative.c:1344 [inline]
 text_poke_finish+0x16/0x30 arch/x86/kernel/alternative.c:1354
 arch_jump_label_transform_apply+0x13/0x20 arch/x86/kernel/jump_label.c:126
 jump_label_update+0x1da/0x400 kernel/jump_label.c:825
 static_key_enable_cpuslocked+0x1b1/0x260 kernel/jump_label.c:177
 static_key_enable+0x16/0x20 kernel/jump_label.c:190
 tracepoint_add_func+0x707/0xa90 kernel/tracepoint.c:303
 tracepoint_probe_register_prio kernel/tracepoint.c:369 [inline]
 tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:389
 __bpf_probe_register kernel/trace/bpf_trace.c:2154 [inline]
 bpf_probe_register+0x15a/0x1c0 kernel/trace/bpf_trace.c:2159
 bpf_raw_tracepoint_open+0x34a/0x720 kernel/bpf/syscall.c:2878
 __do_sys_bpf+0x2586/0x4f40 kernel/bpf/syscall.c:4435
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43f009
Code: Unable to access opcode bytes at RIP 0x43efdf.
RSP: 002b:00007ffc64740b68 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f009
RDX: 0000000000000010 RSI: 0000000020000080 RDI: 0000000000000011
RBP: 0000000000402ff0 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403080
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
================================================================================

