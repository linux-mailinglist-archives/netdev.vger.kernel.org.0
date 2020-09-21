Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974CD271A3D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 06:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgIUE4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 00:56:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55907 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgIUE4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 00:56:17 -0400
Received: by mail-il1-f199.google.com with SMTP id i12so3561963ill.22
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 21:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=w48ND6QxLlcNNCRQLDNljU9DcN5bOMpJULTX22AUa7k=;
        b=na89Q9zZXVdloRrsJTdPvr+LhRx2ZmZsrubLxrV68aA3xv4xxce5aFDclLRAMzHBTS
         AYp6y5akLE0nZe5FjLHsjzkxsvJihjYPSy9DbpPVkWj5ZD7fp4qyuZenAMncDs7YA4Ka
         OiGAzlSLHQlB8ZuQtT4k9Jf/XwHx8ppOU8lPO457CcfkzlJ+XVyuqH/m7nt4ABNXlr40
         WuKCxbiyMTOWX1AopaUfyZBvz2Ha7vcKBNoij8g7VQbY1CpPKnXlMyBRrxuyBeQucChQ
         MV/EP9fJeoHo0GLsB+8vwtUZdp96/YGXpVA92MEYtW9WTPEMfQSvyKEHEiBtnjOGtxZh
         saLA==
X-Gm-Message-State: AOAM533BMrgzIfd9NXEhvlKO4kMG3jitwJ8s6w1AYEsqGMDBMJ/1o6AI
        wqrV4sVjlTHwhHFgw/aLr+YjezQZ6q0Pg7Fv1F4m/P5x100H
X-Google-Smtp-Source: ABdhPJwjPK3Ia7dVxW507ow7140TEUNC+mwQEA2rx4IbXFDS7Ewwi7hZNWcstLRJQX0Z7Dmizwfy8BGgmKrkxmASs+ND/9fpZMPd
MIME-Version: 1.0
X-Received: by 2002:a05:6638:cdc:: with SMTP id e28mr38787100jak.100.1600664176316;
 Sun, 20 Sep 2020 21:56:16 -0700 (PDT)
Date:   Sun, 20 Sep 2020 21:56:16 -0700
In-Reply-To: <000000000000a6348d05a9234041@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a256d405afcbabc3@google.com>
Subject: Re: WARNING in tracepoint_add_func
From:   syzbot <syzbot+721aa903751db87aa244@syzkaller.appspotmail.com>
To:     corbet@lwn.net, davem@davemloft.net, dsahern@gmail.com,
        frederic@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, netdev@vger.kernel.org, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    325d0eab Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16992c81900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b12e84189082991c
dashboard link: https://syzkaller.appspot.com/bug?extid=721aa903751db87aa244
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c797b5900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10569c03900000

The issue was bisected to:

commit 58956317c8de52009d1a38a721474c24aef74fe7
Author: David Ahern <dsahern@gmail.com>
Date:   Fri Dec 7 20:24:57 2018 +0000

    neighbor: Improve garbage collection

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=146ba853900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=166ba853900000
console output: https://syzkaller.appspot.com/x/log.txt?x=126ba853900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+721aa903751db87aa244@syzkaller.appspotmail.com
Fixes: 58956317c8de ("neighbor: Improve garbage collection")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6872 at kernel/tracepoint.c:243 tracepoint_add_func+0x254/0x880 kernel/tracepoint.c:243
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6872 Comm: syz-executor482 Not tainted 5.9.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:tracepoint_add_func+0x254/0x880 kernel/tracepoint.c:243
Code: 44 24 20 48 8b 5b 08 80 38 00 0f 85 6b 05 00 00 48 8b 44 24 08 48 3b 58 08 0f 85 2d ff ff ff 41 bc ef ff ff ff e8 ec 62 fe ff <0f> 0b e8 e5 62 fe ff 44 89 e0 48 83 c4 38 5b 5d 41 5c 41 5d 41 5e
RSP: 0000:ffffc900060f7ac0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90000e76000 RCX: ffffffff8177dc72
RDX: ffff888096766000 RSI: ffffffff8177dcd4 RDI: ffff8880a6b2ec48
RBP: ffffffff8213fae0 R08: 0000000000000000 R09: ffffffff8a0c176b
R10: 000000000000000a R11: 0000000000000000 R12: 00000000ffffffef
R13: 0000000000000002 R14: dffffc0000000000 R15: ffff8880a6b2ec10
 tracepoint_probe_register_prio kernel/tracepoint.c:315 [inline]
 tracepoint_probe_register+0x9c/0xe0 kernel/tracepoint.c:335
 __bpf_probe_register kernel/trace/bpf_trace.c:1950 [inline]
 bpf_probe_register+0x16c/0x1d0 kernel/trace/bpf_trace.c:1955
 bpf_raw_tracepoint_open+0x34e/0xb20 kernel/bpf/syscall.c:2741
 __do_sys_bpf+0x1b2f/0x4c60 kernel/bpf/syscall.c:4220
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4415a9
Code: e8 ac e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc28dd5d08 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004415a9
RDX: 0000000000000010 RSI: 0000000020000040 RDI: 0000000000000011
RBP: 0000000000010308 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004023c0
R13: 0000000000402450 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

