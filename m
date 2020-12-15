Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919A72DAFAE
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgLOPEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:04:08 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:51179 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbgLOPD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 10:03:59 -0500
Received: by mail-il1-f197.google.com with SMTP id t8so16660552ils.17
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 07:03:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=K64y2CqQPgwbni6Mi9ojRmOoEZFFw3QJ3x9ANAUnctk=;
        b=n7eX0yWSITzLKoQrvi30l4afKkV/kDKkBLSAMs63QaF8Uu0RS5eN/vSEafwRl5IqaA
         bJKYhtgihXQ9szyLL2HDVVCNCLZ0YTMAeIfo/A4KrSNLms2qD4AABYV98uOnW9XSBlQO
         SszQzExMS+0xW7LotDWvfH4BlriPzoodi6irDJ9SPm2Ze+fmtAjIczMfI68M6YB2uxKJ
         YS5MRdCpGb3NnlFGUtwcsYEHBmZfXMbdlQz6qHf0j7q4Zpx2bnp4lZLrN7XTcM/xmZI0
         uqDv3GV04BwQqUQq2Goe88uvB7wVvbQMgsmiQqKlnEIfC5qEtMA87yRgtT5Tqb2YJvy/
         QFxA==
X-Gm-Message-State: AOAM530WccOykEUsY5WteFMqfN8rAwx/wqW5yU4POWokgoH0KSjrBitY
        5W20wz/G9j4QTMcC4K19Pd3Z0gFIFNKN32WYP/KZkjF8LVe/
X-Google-Smtp-Source: ABdhPJx0QLLOEDpvyqnnw63MJKEU6BpyO1KRdgi1yBWy4boc8sWV0fAW2I03bP9SPq0laheJ2iijH0ADbWkAd1fqs/rpRTtMuK3r
MIME-Version: 1.0
X-Received: by 2002:a02:c850:: with SMTP id r16mr39004056jao.18.1608044597854;
 Tue, 15 Dec 2020 07:03:17 -0800 (PST)
Date:   Tue, 15 Dec 2020 07:03:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000009ca4c05b6820f9a@google.com>
Subject: UBSAN: shift-out-of-bounds in xprt_calc_majortimeo
From:   syzbot <syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com>
To:     anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    14240d4c Add linux-next specific files for 20201210
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1321cf17500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6dbe20fdaa5aaebe
dashboard link: https://syzkaller.appspot.com/bug?extid=ba2e91df8f74809417fa
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=174ecb9b500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ff9413500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in net/sunrpc/xprt.c:658:14
shift exponent 536871232 is too large for 64-bit type 'long unsigned int'
CPU: 1 PID: 8494 Comm: syz-executor211 Not tainted 5.10.0-rc7-next-20201210-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 xprt_calc_majortimeo.isra.0.cold+0x17/0x46 net/sunrpc/xprt.c:658
 xprt_init_majortimeo net/sunrpc/xprt.c:686 [inline]
 xprt_request_init+0x486/0x9e0 net/sunrpc/xprt.c:1805
 xprt_do_reserve net/sunrpc/xprt.c:1815 [inline]
 xprt_reserve+0x18f/0x280 net/sunrpc/xprt.c:1836
 __rpc_execute+0x21d/0x1360 net/sunrpc/sched.c:891
 rpc_execute+0x230/0x350 net/sunrpc/sched.c:967
 rpc_run_task+0x5d0/0x8f0 net/sunrpc/clnt.c:1140
 rpc_call_sync+0xc6/0x1a0 net/sunrpc/clnt.c:1169
 rpc_ping net/sunrpc/clnt.c:2682 [inline]
 rpc_create_xprt+0x3f1/0x4a0 net/sunrpc/clnt.c:477
 rpc_create+0x354/0x670 net/sunrpc/clnt.c:593
 nfs_create_rpc_client+0x4eb/0x680 fs/nfs/client.c:536
 nfs_init_client fs/nfs/client.c:653 [inline]
 nfs_init_client+0x6d/0x100 fs/nfs/client.c:640
 nfs_get_client+0xcd7/0x1020 fs/nfs/client.c:430
 nfs_init_server.isra.0+0x2c0/0xed0 fs/nfs/client.c:692
 nfs_create_server+0x18f/0x650 fs/nfs/client.c:996
 nfs_try_get_tree+0x181/0x9f0 fs/nfs/super.c:939
 nfs_get_tree+0xaa1/0x1520 fs/nfs/fs_context.c:1350
 vfs_get_tree+0x89/0x2f0 fs/super.c:1496
 do_new_mount fs/namespace.c:2896 [inline]
 path_mount+0x12ae/0x1e70 fs/namespace.c:3227
 do_mount fs/namespace.c:3240 [inline]
 __do_sys_mount fs/namespace.c:3448 [inline]
 __se_sys_mount fs/namespace.c:3425 [inline]
 __x64_sys_mount+0x27f/0x300 fs/namespace.c:3425
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440419
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe282dde28 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 0000000000440419
RDX: 0000000020fb5ffc RSI: 0000000020343ff8 RDI: 0000000020000100
RBP: 00000000006ca018 R08: 000000002000a000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401c20
R13: 0000000000401cb0 R14: 0000000000000000 R15: 0000000000000000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
