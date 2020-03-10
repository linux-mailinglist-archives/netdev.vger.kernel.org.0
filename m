Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53B7217EE0B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgCJBfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:35:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38245 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJBfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:35:15 -0400
Received: by mail-io1-f71.google.com with SMTP id x2so7923424iog.5
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 18:35:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=YbdjrwDCgk53GF6B/fIGmBRFT7qdRjvQ1XyLJmA9zlM=;
        b=LGNlsmgoEU7agaJxsnI0g/k3CWA5QzpOjNpJwh3DxCoSEYIcCm4XcxOkUfk4SyiuLg
         p4GE/Urv8ckvMjRAqRpzeqPdmE4wRRLW5iNuMJxNjPMwcJdnF6LvNqA0/lJ/COcY61xI
         /vuGGgdEbf37iFh3OQirJRi5DB3A3RGHlUqYrNPy2AaSWC60ZD+y37Ecyd41qkDj/MVa
         nYldrU728jr7TxXI4M35pHa6cEylO3QFi6u18KvRI7+K8iwHxF43M/4lnbj/WFx9Yczo
         s7Ie7B62cvUVCgS/EaxaRaOV/SJHq/el4vvOoAGSTSdlAht9ME+8tcRk08zKv2V/8pll
         2AhQ==
X-Gm-Message-State: ANhLgQ3UXv8quTL3a9PeFO2oSasj5Tt8pbKt37Pw6IzDsj7DTaBC+H5x
        Vza2y7r7PLxTTNLgpTO4ouqgXnDrefzwat/6TkINEHqAXBQg
X-Google-Smtp-Source: ADFU+vs2NfPe8HgdoqLcPm7y21aSZKycW2Q8MnPSd9Dq7l/yXHwoA8ohZAMEQzlecYslSFgzlOrhJezIjuW3LmuZHx4bRdw/rvS6
MIME-Version: 1.0
X-Received: by 2002:a92:4e:: with SMTP id 75mr17624906ila.276.1583804112714;
 Mon, 09 Mar 2020 18:35:12 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:35:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088452f05a07621d2@google.com>
Subject: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2c523b34 Linux 5.6-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=155a5f29e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5295e161cd85b82
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164b5181e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166dd70de00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 8668 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8668 Comm: syz-executor779 Not tainted 5.6.0-rc5-syzkaller #0
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
Code: c7 e4 ff d0 88 31 c0 e8 23 20 b3 fd 0f 0b eb 85 e8 8a 4a e0 fd c6 05 ff 70 b1 05 01 48 c7 c7 10 00 d1 88 31 c0 e8 05 20 b3 fd <0f> 0b e9 64 ff ff ff e8 69 4a e0 fd c6 05 df 70 b1 05 01 48 c7 c7
RSP: 0018:ffffc90001f577d0 EFLAGS: 00010246
RAX: 8c9c9070bbb4e500 RBX: 0000000000000003 RCX: ffff8880938a63c0
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: ffffffff815e16e6 R09: fffffbfff15db92a
R10: fffffbfff15db92a R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88809de82000 R14: ffff8880a89237c0 R15: 1ffff11013be52b0
 sctp_wfree+0x3b1/0x710 net/sctp/socket.c:9111
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
 exit_task_work include/linux/task_work.h:22 [inline]
 do_exit+0x5ef/0x1f80 kernel/exit.c:801
 do_group_exit+0x15e/0x2c0 kernel/exit.c:899
 __do_sys_exit_group+0x13/0x20 kernel/exit.c:910
 __se_sys_exit_group+0x10/0x10 kernel/exit.c:908
 __x64_sys_exit_group+0x37/0x40 kernel/exit.c:908
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43ef98
Code: Bad RIP value.
RSP: 002b:00007ffcc7e7c398 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ef98
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004be7a8 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 000000002059aff8 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d01a0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
