Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3211927213E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgIUKeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:34:25 -0400
Received: from mail-il1-f208.google.com ([209.85.166.208]:56354 "EHLO
        mail-il1-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbgIUKeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:34:17 -0400
Received: by mail-il1-f208.google.com with SMTP id d16so10537006ila.23
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:34:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ujdV3lelgEnkMcIAD2F2K3sV2UTSXwNq4UDGGg9DBXI=;
        b=svn5difdQu+ZrELKLaLvQ1v6RVcr4G1DPI14fCNDGpcbYjshX4+EClJNicCIlL+f21
         WdY7jNEQ0s5+08FZM/gS6gwEiXJdeN/BjdNBBDbpfWpR1efwdZhkIdezPClPCwc6IOmX
         E2YB2geauHLfr/m6pSiIm/UJiC9OT4xNaVaTU1BKY3HyH4rsZQ/YNLb1DAf567h9ZGoM
         EIXWZG///WP/bkBo613RX7p2alRyeTVYpicRKYD2O4QeJU/lb/HQZaGEWV5pTfEXkA00
         970WhOHMqpgZvLDvgkAL+qyhXj8RRVoc0r2o8k1IR2g5YZw7PsUbVwI5289GoIoZImHb
         NSmQ==
X-Gm-Message-State: AOAM530ic4W9krftJGfbAYji7cZFt0CgCZE4V3FNmlSGdWzqpeNqIHet
        rDxZGmLqxjpEp7G934pSMZeEAf/SW8jApn2nWChnjLXhR7Ko
X-Google-Smtp-Source: ABdhPJwlT3RkwZe2iYfwPboSxC5hK7hDqspKmfWWEfHDh3ywv+gnA3mMM4x1Cfx+KHfOBgI4+ZbFeX0JejME5PLcp0RqPKjpo6yV
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d07:: with SMTP id g7mr32966340ilj.63.1600684456151;
 Mon, 21 Sep 2020 03:34:16 -0700 (PDT)
Date:   Mon, 21 Sep 2020 03:34:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000680f2905afd0649c@google.com>
Subject: BUG: unable to handle kernel paging request in bpf_trace_run2
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

Hello,

syzbot found the following issue on:

HEAD commit:    70b97111 bpf: Use hlist_add_head_rcu when linking to local..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1375823d900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e0ca96a9b6ee858
dashboard link: https://syzkaller.appspot.com/bug?extid=cc36fd07553c0512f5f7
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cc36fd07553c0512f5f7@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffc90001bca030
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD aa000067 P4D aa000067 PUD aa169067 PMD a930f067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3912 Comm: systemd-udevd Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:613 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:1937 [inline]
RIP: 0010:bpf_trace_run2+0x12e/0x3d0 kernel/trace/bpf_trace.c:1974
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 8e 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 ca 02 f7 ff e8 55 fb 86 06 31 ff 89 c3 89 c6 e8 1a ff
RSP: 0018:ffffc90005257e90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffc90001bca000 RCX: ffffffff817f7778
RDX: 0000000000000000 RSI: ffffc90001bca038 RDI: ffffc90005257eb8
RBP: 1ffff92000a4afd3 R08: 0000000000000000 R09: ffffffff8ce329e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffffc90005257f58 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f32dd08f8c0(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90001bca030 CR3: 00000000a2fb8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 trace_sys_enter include/trace/events/syscalls.h:18 [inline]
 syscall_trace_enter kernel/entry/common.c:64 [inline]
 syscall_enter_from_user_mode+0x22c/0x290 kernel/entry/common.c:82
 do_syscall_64+0xf/0x70 arch/x86/entry/common.c:41
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f32dbf022e2
Code: 48 8b 05 b9 db 2b 00 64 c7 00 16 00 00 00 b8 ff ff ff ff c3 0f 1f 40 00 83 ff 01 77 33 48 63 fe b8 05 00 00 00 48 89 d6 0f 05 <48> 3d 00 f0 ff ff 77 06 f3 c3 0f 1f 40 00 48 8b 15 81 db 2b 00 f7
RSP: 002b:00007fff10a5d048 EFLAGS: 00000246 ORIG_RAX: 0000000000000005
RAX: ffffffffffffffda RBX: 0000000000000010 RCX: 00007f32dbf022e2
RDX: 00007fff10a5d050 RSI: 00007fff10a5d050 RDI: 0000000000000010
RBP: 00007f32dd08f710 R08: 00005630652cd480 R09: 0000000000001010
R10: 00007f32dc1c0b58 R11: 0000000000000246 R12: 0000000000000000
R13: 00005630652c69c0 R14: 00000000000000fe R15: 00005630652c69c0
Modules linked in:
CR2: ffffc90001bca030
---[ end trace 105c336028757ea7 ]---
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:613 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:1937 [inline]
RIP: 0010:bpf_trace_run2+0x12e/0x3d0 kernel/trace/bpf_trace.c:1974
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 8e 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 ca 02 f7 ff e8 55 fb 86 06 31 ff 89 c3 89 c6 e8 1a ff
RSP: 0018:ffffc90005257e90 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffffc90001bca000 RCX: ffffffff817f7778
RDX: 0000000000000000 RSI: ffffc90001bca038 RDI: ffffc90005257eb8
RBP: 1ffff92000a4afd3 R08: 0000000000000000 R09: ffffffff8ce329e7
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffffc90005257f58 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f32dd08f8c0(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90001bca030 CR3: 00000000a2fb8000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
