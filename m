Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4AD180B48
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgCJWPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:15:22 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:34712 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgCJWPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:15:19 -0400
Received: by mail-il1-f199.google.com with SMTP id l13so524ils.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:15:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kPM91QY7Ml+jxCuO6ZR8UApkRRn2EWFumZ9mWiN6s9w=;
        b=TfM0i1fo5t3axBzIliweVA9z22bwpA2cPU17qcUAVoSjfuOLuMHJ+iVKVAGp12zBEh
         h9x2TGeKsTzUnIAWN5x9t7KzVvKGiYagC0CCqSvhz8wwdXSVCbIb9ir75irhdlEpF0NT
         RNQ23jXLad12gDeSJ3mMBDbpZyzuSoQ6ug2FqNiJg+2jTyT7UUFvjOiMRCu2Z9Dicoip
         o+qS0GgDjmzMJwfu9g2OMNZQrnGD8z3IJQtblklUYbmL6xEqN0LzVifNFLA5R/cWIBcB
         BcV3xmXMsnHpjwfZdoiPwnjrNljV+WQcvzgtgte24jFSTtTqSSZGf5mO5pmtZRcwh39k
         RcLw==
X-Gm-Message-State: ANhLgQ1nB5mBe25WvTVVqoiEG+C4PCN+spg6jErta3VpGIl3GUNwn144
        MmWeXNOumyx19FoLzJrZIh3XXBLQlHCXEIchfEU/aukksN2+
X-Google-Smtp-Source: ADFU+vsxJYEZJVjoKeIB4IF+GP5IxL8I7rEUnCKgf/6E3e8cHb3NNhVPY3HP9q19+l9Eo+ZMEsEnAhij8GzZ6r0xZA64s9X/Epuk
MIME-Version: 1.0
X-Received: by 2002:a5e:8c0d:: with SMTP id n13mr203569ioj.138.1583878517423;
 Tue, 10 Mar 2020 15:15:17 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:15:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006601b005a08774fd@google.com>
Subject: general protection fault in tcf_action_destroy (2)
From:   syzbot <syzbot+92a80fff3b3af6c4464e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    30bb5572 Merge tag 'ktest-v5.6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16849c39e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=92a80fff3b3af6c4464e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13faf439e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16956ddde00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+92a80fff3b3af6c4464e@syzkaller.appspotmail.com

batman_adv: batadv0: Interface activated: batadv_slave_1
general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 9664 Comm: syz-executor420 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:tcf_action_destroy+0x6a/0x150 net/sched/act_api.c:720
Code: 47 fb 83 c5 01 bf 20 00 00 00 48 83 c3 08 89 ee e8 8b 95 47 fb 83 fd 20 0f 84 ae 00 00 00 e8 0d 94 47 fb 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 ae 00 00 00 4c 8b 3b 4d 85 ff 0f 84 8b 00 00
RSP: 0018:ffffc90001d37018 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff862a7f63 RDI: 0000000000000004
RBP: 0000000000000000 R08: ffff8880a66c6080 R09: ffffed1015ce7074
R10: ffffed1015ce7073 R11: ffff8880ae73839b R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0063) knlGS:0000000008c74840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000280 CR3: 000000009a35b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 tcf_exts_destroy+0x42/0xc0 net/sched/cls_api.c:3001
 tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
 tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456
 tcindex_change+0x203/0x2e0 net/sched/cls_tcindex.c:518
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe8f arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
Modules linked in:
---[ end trace fac06a3fde273f0e ]---
RIP: 0010:tcf_action_destroy+0x6a/0x150 net/sched/act_api.c:720
Code: 47 fb 83 c5 01 bf 20 00 00 00 48 83 c3 08 89 ee e8 8b 95 47 fb 83 fd 20 0f 84 ae 00 00 00 e8 0d 94 47 fb 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 0f 85 ae 00 00 00 4c 8b 3b 4d 85 ff 0f 84 8b 00 00
RSP: 0018:ffffc90001d37018 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff862a7f63 RDI: 0000000000000004
RBP: 0000000000000000 R08: ffff8880a66c6080 R09: ffffed1015ce7074
R10: ffffed1015ce7073 R11: ffff8880ae73839b R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0063) knlGS:0000000008c74840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000280 CR3: 000000009a35b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
