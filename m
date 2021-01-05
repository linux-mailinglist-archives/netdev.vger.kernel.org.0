Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F52EAE32
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 16:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbhAEP0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 10:26:05 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:51260 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbhAEP0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 10:26:05 -0500
Received: by mail-il1-f200.google.com with SMTP id 1so93805ilg.18
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 07:25:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wrmsr5GggqH+TghkirLZ6pImT91cR6dCRqhWUi9enro=;
        b=QMiILGrZoDMb+6YvM65K3sIKcXGoiWTYdtyHPXP/rHeoyGds6yDlzr+yukxw2wWbb/
         tXwRmGcOZgZ9C+dE/EmQ00+yO7V4oVnMgMvPCyl3NZDxGs/JUeYdeGNVB7fUBKZZDJML
         EyKZMjbNtVBfb4NrIO8nfcWY1ufUtHN1VBVSmRORx+t1xAUOyqQqSwSIWKEKCM827wCy
         OTSQXkArUW3Fi3JiY5HBYgQs98++zZNP6SICWp1D8nPFh0Wmwmz8wEG/mpr2gDiRLpOm
         rXPKpBAyOy4niwRMhK5yv9xTbSHF5bEOYls2/+E0qePMcMr9ij1P43A5tSUqxBi3ck3F
         iahA==
X-Gm-Message-State: AOAM532w0Fg7fIvayzJB7ajJyKtJ+5wGbbrHDRFBywHjvJSkPOdvShTk
        IyKjPXXXcLYVu4GuElTHH8QhSk1V4xref6ZJS/u/wMCQBKcT
X-Google-Smtp-Source: ABdhPJycdNpl2toyalfRRsA2ioEtmD60eKrxNPmp14lkwxLLj19KViYyOvtMc4CIb25Hhc1CQgTPCYRl5DBRzpPE3bROyvg67Crl
MIME-Version: 1.0
X-Received: by 2002:a05:6638:250e:: with SMTP id v14mr201090jat.41.1609860324579;
 Tue, 05 Jan 2021 07:25:24 -0800 (PST)
Date:   Tue, 05 Jan 2021 07:25:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c8dd4a05b828d04c@google.com>
Subject: KASAN: vmalloc-out-of-bounds Read in bpf_trace_run7
From:   syzbot <syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    00a279e4 selftests/bpf: Add tests for user- and non-CO-RE ..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11b1fc1f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2eb8bc0ec06304ce
dashboard link: https://syzkaller.appspot.com/bug?extid=fad5d91c7158ce568634
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fad5d91c7158ce568634@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in __bpf_trace_run kernel/trace/bpf_trace.c:2088 [inline]
BUG: KASAN: vmalloc-out-of-bounds in bpf_trace_run7+0x48f/0x4a0 kernel/trace/bpf_trace.c:2130
Read of size 8 at addr ffffc90000ca0030 by task syz-executor.2/10711

CPU: 0 PID: 10711 Comm: syz-executor.2 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 print_address_description.constprop.0.cold+0x5/0x4c8 mm/kasan/report.c:385
 __kasan_report mm/kasan/report.c:545 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:562
 __bpf_trace_run kernel/trace/bpf_trace.c:2088 [inline]
 bpf_trace_run7+0x48f/0x4a0 kernel/trace/bpf_trace.c:2130
 __bpf_trace_percpu_alloc_percpu+0x1dc/0x220 include/trace/events/percpu.h:10
 trace_percpu_alloc_percpu include/trace/events/percpu.h:10 [inline]
 pcpu_alloc+0xbc4/0x17e0 mm/percpu.c:1844
 perf_trace_event_reg kernel/trace/trace_event_perf.c:107 [inline]
 perf_trace_event_init+0x35f/0xb20 kernel/trace/trace_event_perf.c:204
 perf_trace_init+0x176/0x240 kernel/trace/trace_event_perf.c:228
 perf_tp_event_init+0xa2/0x120 kernel/events/core.c:9563
 perf_try_init_event+0x12a/0x570 kernel/events/core.c:11031
 perf_init_event kernel/events/core.c:11083 [inline]
 perf_event_alloc.part.0+0xe5b/0x3a40 kernel/events/core.c:11361
 perf_event_alloc kernel/events/core.c:11740 [inline]
 __do_sys_perf_event_open+0x647/0x2f30 kernel/events/core.c:11838
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e299
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1784968c68 EFLAGS: 00000246
 ORIG_RAX: 000000000000012a
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 000000000045e299
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000180
RBP: 000000000119bfd0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffffffffff R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007ffe18fb31bf R14: 00007f17849699c0 R15: 000000000119bf8c


Memory state around the buggy address:
 ffffc90000c9ff00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000c9ff80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc90000ca0000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                                     ^
 ffffc90000ca0080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000ca0100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
