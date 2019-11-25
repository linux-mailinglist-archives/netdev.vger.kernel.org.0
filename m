Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170A7108A91
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 10:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfKYJMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 04:12:10 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:53919 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKYJMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 04:12:09 -0500
Received: by mail-io1-f70.google.com with SMTP id w19so10465085iod.20
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 01:12:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5koVtO32iHG1fi3OYlKDnhYVJZ61U3UuaUrqfINFZwA=;
        b=lBtSh+GteJIAm+S6H5AUEZ0f+9wMWfFgew7wy8fSgq8K8JeUjMUU4qwEquT45aQn96
         hRoOk+5Ptgg1OWif48MWGlwHG+4cDuL18pxVWnF1h0JrG09HPvO4yumICfm/F95adicD
         1rTIVLvj0FxdL6YIxNpBNesufABO+ir8ybqCxY9nfXlPDz/5YHTE9k4Aj8zI1vlD1PVh
         D67zEVPYVUGt6w8TGwkjcJvvzCPmH2dqyB9qItw93VOSOvaWA5KceXLQo0eSuGtP9HOC
         cwjXl9Z7FQ3Y0FyN1uxeD7k+wSxKJZET3ih0qy30RNNTqS/QGCbc2HHG3LHZyR3r+DgA
         A41Q==
X-Gm-Message-State: APjAAAWtgvwE4SwO3LvgFWiCB35vkQrPb2DpB4EkfpGOsfi3F5Jj4iAE
        MQlpJWwHNU2ZQisVWHlxcej5a1y5LlQ3GkPeRzodsTSPvmCj
X-Google-Smtp-Source: APXvYqwmkHC5eBpCt0AiTaSyRIR3pm0vqd6V6ERDWDrbvCla3M7sn1YfGyYriNrrCnFLOl1DbYzknRIEDzLT25Wa+EwW1d+T6uLM
MIME-Version: 1.0
X-Received: by 2002:a92:9a17:: with SMTP id t23mr31910133ili.40.1574673128923;
 Mon, 25 Nov 2019 01:12:08 -0800 (PST)
Date:   Mon, 25 Nov 2019 01:12:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007cace40598282858@google.com>
Subject: WARNING: refcount bug in smc_release (2)
From:   syzbot <syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c4f2cbd3 Merge branch '100GbE' of git://git.kernel.org/pub..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=172bf5cae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ac526dc3578c3d3
dashboard link: https://syzkaller.appspot.com/bug?extid=96d3f9ff6a86d37e44c8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 20712 at lib/refcount.c:190  
refcount_sub_and_test_checked lib/refcount.c:190 [inline]
WARNING: CPU: 0 PID: 20712 at lib/refcount.c:190  
refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 20712 Comm: syz-executor.0 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:refcount_sub_and_test_checked lib/refcount.c:190 [inline]
RIP: 0010:refcount_sub_and_test_checked+0x1d0/0x200 lib/refcount.c:180
Code: 1d fb 91 7d 06 31 ff 89 de e8 6c f1 2d fe 84 db 75 94 e8 23 f0 2d fe  
48 c7 c7 00 d9 e6 87 c6 05 db 91 7d 06 01 e8 b8 22 ff fd <0f> 0b e9 75 ff  
ff ff e8 04 f0 2d fe e9 6e ff ff ff 48 89 df e8 17
RSP: 0018:ffff88807446fa80 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000f9af RSI: ffffffff815d2076 RDI: ffffed100e88df42
RBP: ffff88807446fb18 R08: ffff888070648580 R09: ffffed1015d04101
R10: ffffed1015d04100 R11: ffff8880ae820807 R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff88807446faf0 R15: 0000000000000000
  refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
  sock_put include/net/sock.h:1728 [inline]
  smc_release+0x236/0x3e0 net/smc/af_smc.c:202
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  get_signal+0x2078/0x2500 kernel/signal.c:2528
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x65f/0x760 arch/x86/entry/common.c:300
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a639
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f1a52923c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffff8d RBX: 0000000000000003 RCX: 000000000045a639
RDX: 0000000000000010 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1a529246d4
R13: 00000000004c0dc8 R14: 00000000004d3a00 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
