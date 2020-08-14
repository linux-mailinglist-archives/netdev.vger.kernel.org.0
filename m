Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FB62444C0
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 08:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHNGBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 02:01:21 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:52316 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgHNGBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 02:01:20 -0400
Received: by mail-il1-f199.google.com with SMTP id q16so614972ils.19
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 23:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sCmDfjgeHQU2XqasYC2w9/9D2xVFH6ihBv/kfF+e3jw=;
        b=Tw0PFDLCwRuZicltmGVd1Nc7MQm/Ph4EOjc2zgEOqA6XDLuv1JzHTXGbJf1Jefvu5I
         k/oW7qxNPm7F/1vysY429T5d0djnqIQO+e2m5v/x5lgxgiHTsas32brTcBr7SBH2j/4+
         hTfeJCbIKwCkXcM2x7bwiZkhf1SjA19JG+2L0lSpSX/ns6GSXX/6PqbVhC8to7l7TyHI
         dSugsie75yu7Jk9tNlF45qiYaNC9JIzrucmG1ef+s4fnJ0N8D00OlmT39JrCSyQYUrZ2
         sfvfdA9vXypNPkfhkR/oA6GD9T3bYjMVHVu20MTw38Frruvkv/YNzSVlPGsfY6Nod5hg
         aVSg==
X-Gm-Message-State: AOAM531RnhMz6p7JIQhnoYg/7o0w8di8f3I/Z+f5LLBtdyEZbguhR4P7
        nWlrgAIumm9vM91eBhjZjdNSUMPRGz66ew4oof8Fq8gB+pRd
X-Google-Smtp-Source: ABdhPJxIBN6j/ZMeKyaWqmCi1FaCp4RvYhD+TKcut9djsRe8PAAgfRTsBpUH9s8I3/LT/c0SXsjPTloEZFBbUzf4VQep43bHcnFr
MIME-Version: 1.0
X-Received: by 2002:a6b:591a:: with SMTP id n26mr941583iob.122.1597384879879;
 Thu, 13 Aug 2020 23:01:19 -0700 (PDT)
Date:   Thu, 13 Aug 2020 23:01:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055c63705acd02676@google.com>
Subject: BUG: corrupted list in hci_chan_del
From:   syzbot <syzbot+21e61af4106356a893be@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    990f2273 Merge tag 's390-5.9-2' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16311491900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c89856ae5fc8b6
dashboard link: https://syzkaller.appspot.com/bug?extid=21e61af4106356a893be
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+21e61af4106356a893be@syzkaller.appspotmail.com

list_del corruption. prev->next should be ffff8880a2c52c00, but was 0000000000000000
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:51!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 11221 Comm: syz-executor.0 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_del_entry_valid.cold+0xf/0x55 lib/list_debug.c:51
Code: e8 0a af bf fd 0f 0b 48 89 f1 48 c7 c7 60 fe 93 88 4c 89 e6 e8 f6 ae bf fd 0f 0b 48 89 ee 48 c7 c7 00 00 94 88 e8 e5 ae bf fd <0f> 0b 4c 89 ea 48 89 ee 48 c7 c7 40 ff 93 88 e8 d1 ae bf fd 0f 0b
RSP: 0018:ffffc90008907828 EFLAGS: 00010282
RAX: 0000000000000054 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88805eb3a5c0 RSI: ffffffff815dbc57 RDI: fffff52001120ef7
RBP: ffff8880a2c52c00 R08: 0000000000000054 R09: ffff8880ae7318e7
R10: 0000000000000000 R11: 000000000004e618 R12: ffff88809421fe00
R13: ffffffff8920ff20 R14: fffffbfff1522378 R15: ffff888097af65d8
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00007f0f6a6c5000 CR3: 0000000009a8d000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __list_del_entry include/linux/list.h:132 [inline]
 list_del_rcu include/linux/rculist.h:158 [inline]
 hci_chan_del+0x3f/0x190 net/bluetooth/hci_conn.c:1733
 l2cap_conn_del+0x61b/0x9e0 net/bluetooth/l2cap_core.c:1900
 l2cap_disconn_cfm net/bluetooth/l2cap_core.c:8160 [inline]
 l2cap_disconn_cfm+0x85/0xa0 net/bluetooth/l2cap_core.c:8153
 hci_disconn_cfm include/net/bluetooth/hci_core.h:1438 [inline]
 hci_conn_hash_flush+0x114/0x220 net/bluetooth/hci_conn.c:1557
 hci_dev_do_close+0x5c6/0x1080 net/bluetooth/hci_core.c:1770
 hci_unregister_dev+0x1bd/0xe30 net/bluetooth/hci_core.c:3790
 vhci_release+0x70/0xe0 drivers/bluetooth/hci_vhci.c:340
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:135
 exit_task_work include/linux/task_work.h:25 [inline]
 do_exit+0xb7d/0x29f0 kernel/exit.c:806
 do_group_exit+0x125/0x310 kernel/exit.c:903
 get_signal+0x40b/0x1ee0 kernel/signal.c:2743
 arch_do_signal+0x82/0x2520 arch/x86/kernel/signal.c:811
 exit_to_user_mode_loop kernel/entry/common.c:135 [inline]
 exit_to_user_mode_prepare+0x15d/0x1c0 kernel/entry/common.c:166
 syscall_exit_to_user_mode+0x59/0x2b0 kernel/entry/common.c:241
 __do_fast_syscall_32+0x63/0x80 arch/x86/entry/common.c:127
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f33569
Code: Bad RIP value.
RSP: 002b:00000000f550c12c EFLAGS: 00000292 ORIG_RAX: 00000000000000f0
RAX: fffffffffffffe00 RBX: 0000000008b9c014 RCX: 0000000000000080
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000008b9c018
RBP: 00000000f550c228 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
