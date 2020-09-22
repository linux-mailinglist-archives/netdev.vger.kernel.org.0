Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DE22748DA
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 21:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgIVTLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 15:11:20 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39704 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgIVTLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 15:11:19 -0400
Received: by mail-io1-f72.google.com with SMTP id y16so13530112ioy.6
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 12:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=lAjFh73hmiU/WBQf5ax9GK7qWeGlhNJIYvF2cOOSRUQ=;
        b=gRFl0pnLb/tOnXlEuUUwpABFZoPa/GgPw7dgDeFJ0SOK5KBpcsWA3/SLznuO4hvYie
         zWK7KRM7Kbw1ViyLmWTyLW0yliDl6qWRSu5xjnRmW5oeasPImuDNSEc6zYgWJPtKkKV0
         /NV9HXi8QCXdp9TK+aoIEE1sfWATuKtSV1lWq++fzslt174yb5NfQCxuQj4FOOJ7Mc6v
         NdeMy5+NzaPSmJ/rRbyHVy2x0IL0u31JqqknjYvQom4AQM44Tw3cvFNdJZV31CnIY+zj
         HiGMWMG1UJRUF0Jq0LvK95eOVvQ+6QbRTErSroU38FI1yYec4+2v3oO6t1hVfuvU+SbO
         7/xg==
X-Gm-Message-State: AOAM531ua9cqNftiAO2KEwgnxCd2Ur/v0BM8jPdVKcu3+1b+hcaBp9vp
        wfdvMTUsTvjxOuvSgesTbX9XDTXxXgCscc7uaqI/uFAWGJDy
X-Google-Smtp-Source: ABdhPJy8yniI8MFudEaNa9KgbVwMWsCfxkZEpKwbgKb//f1MXSr5YF5rRi9LeZkJA0mjo9KaWhZAE7dguw2wjioqrH7T9AZEbBtW
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2003:: with SMTP id y3mr4532911iod.203.1600801877916;
 Tue, 22 Sep 2020 12:11:17 -0700 (PDT)
Date:   Tue, 22 Sep 2020 12:11:17 -0700
In-Reply-To: <000000000000680f2905afd0649c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004a0dd105afebbb10@google.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_trace_run2
From:   syzbot <syzbot+cc36fd07553c0512f5f7@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    12450081 libbpf: Fix native endian assumption when parsing..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=17fedf8b900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ac0d21536db480b
dashboard link: https://syzkaller.appspot.com/bug?extid=cc36fd07553c0512f5f7
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1365d2c3900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d5f08d900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cc36fd07553c0512f5f7@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffc90000ed0030
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD aa000067 P4D aa000067 PUD aa169067 PMD a9031067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 6868 Comm: syz-executor454 Not tainted 5.9.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:586 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:1887 [inline]
RIP: 0010:bpf_trace_run2+0x12e/0x3d0 kernel/trace/bpf_trace.c:1924
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 8e 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 fa 03 f7 ff e8 45 c8 a4 06 31 ff 89 c3 89 c6 e8 4a 00
RSP: 0018:ffffc900018e7e90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffc90000ed0000 RCX: ffffffff817f2b88
RDX: 0000000000000000 RSI: ffffc90000ed0038 RDI: ffffc900018e7eb8
RBP: 1ffff9200031cfd3 R08: 0000000000000000 R09: ffffffff8d0b69e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffffc900018e7f58 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000001079880(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000ed0030 CR3: 000000009f63f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 trace_sys_enter include/trace/events/syscalls.h:18 [inline]
 syscall_trace_enter kernel/entry/common.c:64 [inline]
 syscall_enter_from_user_mode+0x22c/0x290 kernel/entry/common.c:82
 do_syscall_64+0xf/0x70 arch/x86/entry/common.c:41
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4441da
Code: 25 18 00 00 00 00 74 01 f0 48 0f b1 3d cf f9 28 00 48 39 c2 75 da f3 c3 0f 1f 84 00 00 00 00 00 48 63 ff b8 e4 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 f3 c3 0f 1f 40 00 48 c7 c2 d0 ff ff ff f7
RSP: 002b:00007ffc59deef98 EFLAGS: 00000246 ORIG_RAX: 00000000000000e4
RAX: ffffffffffffffda RBX: 0000000000001ae1 RCX: 00000000004441da
RDX: 0000000000000000 RSI: 00007ffc59deefa0 RDI: 0000000000000001
RBP: 000000000000ee75 R08: 0000000000001ad4 R09: 0000000001079880
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004022f0
R13: 0000000000402380 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
CR2: ffffc90000ed0030
---[ end trace 7a32b71ba0e36806 ]---
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:586 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:1887 [inline]
RIP: 0010:bpf_trace_run2+0x12e/0x3d0 kernel/trace/bpf_trace.c:1924
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 8e 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 fa 03 f7 ff e8 45 c8 a4 06 31 ff 89 c3 89 c6 e8 4a 00
RSP: 0018:ffffc900018e7e90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffc90000ed0000 RCX: ffffffff817f2b88
RDX: 0000000000000000 RSI: ffffc90000ed0038 RDI: ffffc900018e7eb8
RBP: 1ffff9200031cfd3 R08: 0000000000000000 R09: ffffffff8d0b69e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffffc900018e7f58 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000001079880(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000ed0030 CR3: 000000009f63f000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

