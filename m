Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0F1315C30
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhBJB03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:26:29 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:37591 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbhBJBY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 20:24:59 -0500
Received: by mail-il1-f198.google.com with SMTP id g3so764665ild.4
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 17:24:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2vMkVRm2x4zbU65Zq94duQZfZU4RCzVVhgNBmR6/9hQ=;
        b=UM0ER58iQ+pRmGv800fGZyPt+SdeEFdWoBc+Vi/Sw6zL2EhUwQU1CZKRXHav+smqpe
         9uP69HcHTLaeaG9pd18M5UHFBW6Kmhr+TfTT9wctViLqTCEAsV2krdryObzD164swDhz
         dhopgyY5I3eVGBAerKwO2Tc3FnB4qjwGkQEuc5UOEX+UWP8AbLB7A8hyxT2qf4tfTJnV
         IYUY2iJ/qsQTlRKS5gngXVLPYRZWI6QKnR9yIN5SgHVYrcmwhbyk4m/EPpj3WfmCgPFD
         3aeBqDSX89MkPEEVN3fSsXXWYBde7Qm6V7pErHkC+mL6LIDGgZlqn7EbKzJ5pUEfgyo3
         1T8Q==
X-Gm-Message-State: AOAM5311Ece3pRCJPsrOp7VWcrzieRCd/MqYbyVcJGqnmwXB6C6ZsYIw
        scWyH4r5Uti/j1qXdFWDqVJbmhLPquuttg07ZtSPKYC9T+a1
X-Google-Smtp-Source: ABdhPJzqkqqDFx8Mjm98Xwt5yO10GQ6mjXcZkdI+PWhSxcUD19xgunM/mIya0VQyZ4vkI7kEhl9Lk6bDVUcPRbju0rvNeMd50Dn6
MIME-Version: 1.0
X-Received: by 2002:a92:dd0a:: with SMTP id n10mr619114ilm.191.1612920258517;
 Tue, 09 Feb 2021 17:24:18 -0800 (PST)
Date:   Tue, 09 Feb 2021 17:24:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000f622105baf14335@google.com>
Subject: UBSAN: shift-out-of-bounds in xprt_do_reserve
From:   syzbot <syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com>
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

HEAD commit:    dd86e7fa Merge tag 'pci-v5.11-fixes-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=105930c4d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=266a5362c89c8127
dashboard link: https://syzkaller.appspot.com/bug?extid=f3a0fa110fd630ab56c8
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ba3038d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cf0d64d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f3a0fa110fd630ab56c8@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in net/sunrpc/xprt.c:658:14
shift exponent 536870976 is too large for 64-bit type 'unsigned long'
CPU: 1 PID: 8411 Comm: syz-executor902 Not tainted 5.11.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_shift_out_of_bounds+0x432/0x4d0 lib/ubsan.c:395
 xprt_calc_majortimeo net/sunrpc/xprt.c:658 [inline]
 xprt_init_majortimeo net/sunrpc/xprt.c:686 [inline]
 xprt_request_init net/sunrpc/xprt.c:1805 [inline]
 xprt_do_reserve+0x751/0x770 net/sunrpc/xprt.c:1815
 __rpc_execute+0x1e1/0xb00 net/sunrpc/sched.c:891
 rpc_run_task+0x5a4/0x740 net/sunrpc/clnt.c:1140
 rpc_call_sync net/sunrpc/clnt.c:1169 [inline]
 rpc_ping net/sunrpc/clnt.c:2682 [inline]
 rpc_create_xprt+0x2f3/0x700 net/sunrpc/clnt.c:477
 rpc_create+0x5df/0x8a0 net/sunrpc/clnt.c:593
 nfs_create_rpc_client+0x5a0/0x740 fs/nfs/client.c:536
 nfs_init_client+0x53/0xf0 fs/nfs/client.c:653
 nfs_init_server fs/nfs/client.c:692 [inline]
 nfs_create_server+0x82d/0x2130 fs/nfs/client.c:996
 nfs_try_get_tree+0x385/0x1040 fs/nfs/super.c:939
 vfs_get_tree+0x86/0x270 fs/super.c:1496
 do_new_mount fs/namespace.c:2881 [inline]
 path_mount+0x17ad/0x2a00 fs/namespace.c:3211
 do_mount fs/namespace.c:3224 [inline]
 __do_sys_mount fs/namespace.c:3432 [inline]
 __se_sys_mount+0x28c/0x320 fs/namespace.c:3409
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x43ef89
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe0a856338 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 000000000043ef89
RDX: 0000000020fb5ffc RSI: 0000000020000080 RDI: 00000000200000c0
RBP: 0000000000402f70 R08: 000000002000a000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403000
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
