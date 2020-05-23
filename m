Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB7F1DF58D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 09:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387672AbgEWH3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 03:29:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55159 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgEWH3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 03:29:17 -0400
Received: by mail-io1-f72.google.com with SMTP id t23so8909381iog.21
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 00:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=URfabu0vKqV63BojTfHzXnf8eicb+TRu6nrD2d8nH2k=;
        b=p8o7ck9spMV7Grhk7WUexXPLaT0qZD7ke1otFap7mA8AIVSIdZqklUcummKGKpkvvk
         Kc5pFiC4vnXsO0IKK1/EtKuTBA4PApYgdVnTYe0npvxA1t1PzZ6/XXT3rd02g8AdbWra
         SCHqPzuAlpdSO4aFZUXQF3oe1306l7hlv7EklsWM06SiuYacJjViGI/f2LB7szd4j37u
         QXWa+duMDXp+mSyLQNvpBtZU+FlGbfsmRFo/499nMknkxGesuxe5LZpH3rMThJop3k+Y
         7cq1ykRYO+0Lb5BoI3v3uXto1DUbhfHs++RUwAJajtHkL1xSV13g/c9j46Viq3Ae8Mzr
         a44Q==
X-Gm-Message-State: AOAM531u98AmLtf6FYvTZIAhxjxBpDCd/JLs7i5nswFtbnqofcMb6cWu
        RoCZPdAGRhZHrNh2KRN9oheLk1xmTpbTgS3A38xtZoP8ef0v
X-Google-Smtp-Source: ABdhPJzT1xMSR3A/6kdLMBO8+9MhM93wKRvEnOM9aUfxdZt/EIFb5VDRurnOGG8bUyI0mrkFcQpEoDi4FOfr2clDJcuXvFXQr+lC
MIME-Version: 1.0
X-Received: by 2002:a02:8529:: with SMTP id g38mr66142jai.143.1590218956131;
 Sat, 23 May 2020 00:29:16 -0700 (PDT)
Date:   Sat, 23 May 2020 00:29:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fef2d505a64bb3d7@google.com>
Subject: WARNING: proc registration bug in clusterip_tg_check (2)
From:   syzbot <syzbot+35e9c587ab6de655a1b3@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    d2f8825a Merge tag 'for_linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10eed272100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c33c7f7c5471fd39
dashboard link: https://syzkaller.appspot.com/bug?extid=35e9c587ab6de655a1b3
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+35e9c587ab6de655a1b3@syzkaller.appspotmail.com

------------[ cut here ]------------
proc_dir_entry 'ipt_CLUSTERIP/127.0.0.1' already registered
WARNING: CPU: 1 PID: 21213 at fs/proc/generic.c:363 proc_register+0x2bc/0x4e0 fs/proc/generic.c:362
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 21213 Comm: syz-executor.2 Not tainted 5.7.0-rc6-syzkaller #0
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
RIP: 0010:proc_register+0x2bc/0x4e0 fs/proc/generic.c:362
Code: 08 4c 8b 74 24 28 48 8b 6c 24 20 74 08 48 89 ef e8 a9 35 d1 ff 48 8b 55 00 48 c7 c7 c4 82 e9 88 48 89 de 31 c0 e8 b4 50 65 ff <0f> 0b 48 c7 c7 c0 00 33 89 e8 c6 b6 2b 06 48 8b 44 24 30 42 8a 04
RSP: 0018:ffffc900196af938 EFLAGS: 00010246
RAX: 516b049ad9e30c00 RBX: ffff88805557e8e4 RCX: 0000000000040000
RDX: ffffc9000d311000 RSI: 000000000001758c RDI: 000000000001758d
RBP: ffff88805a697e98 R08: ffffffff815cd2b9 R09: ffffed1015d26660
R10: ffffed1015d26660 R11: 0000000000000000 R12: dffffc0000000000
R13: 0000000000000009 R14: ffff88805a697e54 R15: ffff88805a697dc0
 proc_create_data+0x1d0/0x240 fs/proc/generic.c:551
 clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:281 [inline]
 clusterip_tg_check+0xa5b/0x10e0 net/ipv4/netfilter/ipt_CLUSTERIP.c:502
 xt_check_target+0x6c6/0xb10 net/netfilter/x_tables.c:1019
 check_target net/ipv4/netfilter/ip_tables.c:511 [inline]
 find_check_entry net/ipv4/netfilter/ip_tables.c:553 [inline]
 translate_table+0x17b0/0x20e0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1136 [inline]
 do_ipt_set_ctl+0x28b/0x4c0 net/ipv4/netfilter/ip_tables.c:1672
 nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
 nf_setsockopt+0x2be/0x2e0 net/netfilter/nf_sockopt.c:115
 __sys_setsockopt+0x564/0x710 net/socket.c:2132
 __do_sys_setsockopt net/socket.c:2148 [inline]
 __se_sys_setsockopt net/socket.c:2145 [inline]
 __x64_sys_setsockopt+0xb1/0xc0 net/socket.c:2145
 do_syscall_64+0xf3/0x1b0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa4aaf69c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000501e00 RCX: 000000000045ca29
RDX: 0000000000000040 RSI: 0004000000000000 RDI: 0000000000000003
RBP: 000000000078bfa0 R08: 0000000000000260 R09: 0000000000000000
R10: 0000000020000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a3f R14: 00000000004cd086 R15: 00007fa4aaf6a6d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
