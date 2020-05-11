Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F971CE186
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 19:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730934AbgEKRVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 13:21:16 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:50049 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728556AbgEKRVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 13:21:15 -0400
Received: by mail-il1-f199.google.com with SMTP id z18so9971674ilp.16
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 10:21:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=n/Jv74xGVecUMFGbk0cscRosnzR2e3OxqcMoNdQON/Y=;
        b=BsVNNVYMPopqiCUNz+s7zWY3ID/o8lmhhGvJsc9/sYvFv3zfIyQkEm/oA1eWJmlmFC
         Ptmf1qsQpgrbnQCEVjsSVAxzNgpI7Litxp9K8KdZWFs7me6i1LzmaR4kqhSVj9Zu0wK3
         7OCdns9NOHKeptVqGCc6tUWVs/+LC9rXgp7JtfSP9IahfYsJnSsH0GzEPlW+QsPbj7TO
         WlhfeV/fRdX4GClnXeYV0ghcrS0hp2vd0SFRFnTFix+Wf3YQxNWL4t+FKoQZmyBbiiPl
         7GEekQo98kNqc360Nlomo+YgL7c0he6d+WGwGCSfxNTOzRmCFiKABO6ONU3Gt3/1VoQP
         A/1Q==
X-Gm-Message-State: AGi0PuboK6k9wlZoYFvvp3tRUZ8xOGaRBlLkWnCT98q600ErnE/myh1u
        DBMcUBUnKQei9m0HK0hdDOewjlWPKG7Xhh6XdCHU4khdAxOi
X-Google-Smtp-Source: APiQypL7z32WqVtJf+HU76MSmqdvhpd5b/+cWTCe8doO6sm7iJCSjXzZWEJ2xO7z9PbqCNV4hMLSwQdu3OIPRYsm0YiBnlo2Q/Bm
MIME-Version: 1.0
X-Received: by 2002:a02:3b4b:: with SMTP id i11mr16625500jaf.16.1589217673581;
 Mon, 11 May 2020 10:21:13 -0700 (PDT)
Date:   Mon, 11 May 2020 10:21:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e79ab005a56292f5@google.com>
Subject: WARNING in cgroup_finalize_control
From:   syzbot <syzbot+9c08aaa363ca5784c9e9@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, christian@brauner.io,
        coreteam@netfilter.org, daniel@iogearbox.net, davem@davemloft.net,
        hannes@cmpxchg.org, john.fastabend@gmail.com, kaber@trash.net,
        kadlec@blackhole.kfki.hu, kafai@fb.com, kpsingh@chromium.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        lizefan@huawei.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nhorman@tuxdriver.com, pablo@netfilter.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, tj@kernel.org,
        vyasevich@gmail.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a811c1fa Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ad1d70100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=43badbd0e7e1137e
dashboard link: https://syzkaller.appspot.com/bug?extid=9c08aaa363ca5784c9e9
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d3c588100000

The bug was bisected to:

commit eab59075d3cd7f3535aa2dbbc19a198dfee58892
Author: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date:   Wed Dec 28 11:26:31 2016 +0000

    sctp: reduce indent level at sctp_sf_tabort_8_4_8

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=151b6c7c100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=171b6c7c100000
console output: https://syzkaller.appspot.com/x/log.txt?x=131b6c7c100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9c08aaa363ca5784c9e9@syzkaller.appspotmail.com
Fixes: eab59075d3cd ("sctp: reduce indent level at sctp_sf_tabort_8_4_8")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7373 at kernel/cgroup/cgroup.c:3111 cgroup_apply_control_disable kernel/cgroup/cgroup.c:3111 [inline]
WARNING: CPU: 0 PID: 7373 at kernel/cgroup/cgroup.c:3111 cgroup_finalize_control+0xb6c/0xd60 kernel/cgroup/cgroup.c:3178
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7373 Comm: syz-executor.0 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:cgroup_apply_control_disable kernel/cgroup/cgroup.c:3111 [inline]
RIP: 0010:cgroup_finalize_control+0xb6c/0xd60 kernel/cgroup/cgroup.c:3178
Code: 89 f7 ff d3 eb 08 e8 53 fe 07 00 0f 1f 00 49 ff c4 49 83 fc 0d 0f 84 63 01 00 00 e8 3e fe 07 00 e9 a9 f8 ff ff e8 34 fe 07 00 <0f> 0b e9 88 f9 ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c cd f8 ff
RSP: 0018:ffffc900035a7ba8 EFLAGS: 00010293
RAX: ffffffff816b637c RBX: 0000000000000002 RCX: ffff88809e876100
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffffff89307148 R08: ffffffff816b5cfc R09: ffffed1015d07074
R10: ffffed1015d07074 R11: 0000000000000000 R12: 0000000000000008
R13: ffff88809251c000 R14: ffff88808eef2400 R15: dffffc0000000000
 rebind_subsystems+0x737/0xe60 kernel/cgroup/cgroup.c:1750
 cgroup_setup_root+0x679/0xd50 kernel/cgroup/cgroup.c:1984
 cgroup1_root_to_use kernel/cgroup/cgroup-v1.c:1190 [inline]
 cgroup1_get_tree+0x7a2/0xae0 kernel/cgroup/cgroup-v1.c:1207
 vfs_get_tree+0x88/0x270 fs/super.c:1547
 do_new_mount fs/namespace.c:2816 [inline]
 do_mount+0x17ec/0x2900 fs/namespace.c:3141
 __do_sys_mount fs/namespace.c:3350 [inline]
 __se_sys_mount+0xd3/0x100 fs/namespace.c:3327
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45f27a
Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 ad 8c fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 8a 8c fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007fff4f78e3a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff4f78e400 RCX: 000000000045f27a
RDX: 00000000004cad91 RSI: 00000000004c1465 RDI: 00000000004c1428
RBP: 0000000000000000 R08: 00000000004cf7b8 R09: 000000000000001c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000418390
R13: 00007fff4f78e628 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
