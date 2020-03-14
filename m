Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F896185A17
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 05:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgCOEiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 00:38:55 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197]:49598 "EHLO
        mail-pf1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgCOEiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 00:38:55 -0400
Received: by mail-pf1-f197.google.com with SMTP id z8so7709513pfj.16
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 21:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=L3Qm1XVqvMB0vX00p+awtx3rexadT1xpluUKakT4GBU=;
        b=BbB4PqhDcpPFBXF2YrKSUutrP6OeirF4x5QSU2u3gd21LUjZufYOyvH7ywxhLam9Hc
         Mld/DVc+UwTQtGDWeNQ8ppbM1zhGVhCwhpx6hK4UNKcDZKTkxyX6fJ/0V50xhC3fprJ8
         MigZtarKscDZ/Nx61yHQgfjvKTyWQAZJMV2d+miZSSLFPMxC09CgMdOK7zhzWfVR5S36
         MZk3JflzoQ3RkPyxQcXB0IFmU0GJljljFi9QCimXWLdLDX/oTHShuhbYzBcpe3JP4SxJ
         TWcsOMntFJyj+oKhWq1rrd/mu+WABFGATOGKx/zeu515NAN5H8V6IK/73nEaBv9tgWAu
         HsIw==
X-Gm-Message-State: ANhLgQ1scKCsM5R0Xd3RPHAgzMiulvyk1wQqpZ4XosOdxZEqJ6XC++0P
        8TCFEE+YVwib2peI/0o9LYX3Zed3XfyBdp6I3EHA1ufB7Xc2
X-Google-Smtp-Source: ADFU+vuCfL/HBvBHvVqlF+T6BmKAq0Ho0VZkVxqEftLOpW/GgD7N2+EtgJJSqyvF5t2AVDihXBz6hj123t2zb8CVIMbJyICLi8j1
MIME-Version: 1.0
X-Received: by 2002:a6b:ac01:: with SMTP id v1mr16411922ioe.156.1584176582561;
 Sat, 14 Mar 2020 02:03:02 -0700 (PDT)
Date:   Sat, 14 Mar 2020 02:03:02 -0700
In-Reply-To: <CADG63jC=oy4PTRbw=6=OMdG3nabf3-AdjDKcH4FKJwNg4A-s5g@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007719b805a0ccdaa6@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered crash:
WARNING: refcount bug in sctp_wfree

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 8581 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8581 Comm: syz-executor.3 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1e9/0x30e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1ac/0x2d0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xca/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Code: c7 94 00 d1 88 31 c0 e8 33 1f b3 fd 0f 0b eb 85 e8 2a 4a e0 fd c6 05 4e 70 b1 05 01 48 c7 c7 c0 00 d1 88 31 c0 e8 15 1f b3 fd <0f> 0b e9 64 ff ff ff e8 09 4a e0 fd c6 05 2e 70 b1 05 01 48 c7 c7
RSP: 0018:ffffc90002c978c8 EFLAGS: 00010246
RAX: b1721d41aaac4d00 RBX: 0000000000000003 RCX: ffff88809eb123c0
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: ffffffff815e16d6 R09: ffffed1015d24592
R10: ffffed1015d24592 R11: 0000000000000000 R12: ffff8880a7b8c000
R13: dffffc0000000000 R14: ffff8880a81d4800 R15: ffff8880a81e0d00
 sctp_wfree+0x4be/0x840 net/sctp/socket.c:9113
 skb_release_head_state+0xfb/0x210 net/core/skbuff.c:651
 skb_release_all net/core/skbuff.c:662 [inline]
 __kfree_skb+0x22/0x1c0 net/core/skbuff.c:678
 sctp_chunk_destroy net/sctp/sm_make_chunk.c:1454 [inline]
 sctp_chunk_put+0x17b/0x200 net/sctp/sm_make_chunk.c:1481
 __sctp_outq_teardown+0x80a/0x9d0 net/sctp/outqueue.c:257
 sctp_association_free+0x21e/0x7c0 net/sctp/associola.c:339
 sctp_cmd_delete_tcb net/sctp/sm_sideeffect.c:930 [inline]
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1318 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1185 [inline]
 sctp_do_sm+0x3c01/0x5560 net/sctp/sm_sideeffect.c:1156
 sctp_primitive_ABORT+0x93/0xc0 net/sctp/primitive.c:104
 sctp_close+0x231/0x770 net/sctp/socket.c:1512
 inet_release+0x135/0x180 net/ipv4/af_inet.c:427
 __sock_release net/socket.c:605 [inline]
 sock_close+0xd8/0x260 net/socket.c:1283
 __fput+0x2d8/0x730 fs/file_table.c:280
 task_work_run+0x176/0x1b0 kernel/task_work.c:113
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop arch/x86/entry/common.c:164 [inline]
 prepare_exit_to_usermode+0x48e/0x600 arch/x86/entry/common.c:195
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x416041
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fffbe2f3cc0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000416041
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000001 R08: 00ffffffffffffff R09: 00ffffffffffffff
R10: 00007fffbe2f3da0 R11: 0000000000000293 R12: 000000000076bf20
R13: 0000000000770850 R14: 0000000000012bfc R15: 000000000076bf2c
Kernel Offset: disabled
Rebooting in 86400 seconds..


Tested on:

commit:         1739e95e fix compile err
git tree:       https://github.com/hqj/hqjagain_test.git sctp_wfree
console output: https://syzkaller.appspot.com/x/log.txt?x=1239a3dde00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

