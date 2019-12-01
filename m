Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF1D10E058
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 05:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbfLAEhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 23:37:11 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:34655 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbfLAEhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 23:37:11 -0500
Received: by mail-il1-f197.google.com with SMTP id l13so12820976ils.1
        for <netdev@vger.kernel.org>; Sat, 30 Nov 2019 20:37:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=v0J+wZhdjttjLui7Jcw+Ref517WIdIELo1N/ZGyLXOw=;
        b=Suib5YiK2UWTqW0vsx7PT3biY51/Si66BVvVNhIEoLrV09Ng4038A/ZyeOIWzMi9tG
         rlQPvvTg3ecIJmLtGg3kU18ly5T8lR8QaB7hO6pNrF3SI/9BakJJDfbMf/ETFID4oQoA
         fIUfnDljVTW9mRcrke/LW5qv9EQH2TJ/q3dkkpb7XR5GMf11j9NGi7CTcYuKwY0PLrge
         z/LGN1cJkG/kAQQYvr8vu+DOVQK8hAR2Dl1AlQOIcQ0GIN6/Sko4yJmmskUVmdkKm4wR
         n6OMAPipkdCMZFJzfVrgNpG8/uWOk4D1VAXr7DWFbgKeO9plmDclhuAEJCbDuPmJ5g6B
         kA/w==
X-Gm-Message-State: APjAAAXQn2n2JW8+S8fCMBGgvwfK9juu6Unisyo88VWsKol9+uq3q0WJ
        DSVudkqpbsfSJColeFU3ptdawO1zmeyZvuxZuMk7q/VSxkvp
X-Google-Smtp-Source: APXvYqz0NKRcLrMe23S+IgpLnyHyGusKwopVSgltulCHh7AwK0zzMEf5PqkLdvDDVKefcs6DPg+9gp54mQSoam2BvSHaG7Ylmyz+
MIME-Version: 1.0
X-Received: by 2002:a5d:9dd9:: with SMTP id 25mr37351873ioo.287.1575175029112;
 Sat, 30 Nov 2019 20:37:09 -0800 (PST)
Date:   Sat, 30 Nov 2019 20:37:09 -0800
In-Reply-To: <0000000000007cace40598282858@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011c9b105989d0489@google.com>
Subject: Re: WARNING: refcount bug in smc_release (2)
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

syzbot has found a reproducer for the following crash on:

HEAD commit:    32ef9553 Merge tag 'fsnotify_for_v5.5-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f6d82ae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ff560c3de405258c
dashboard link: https://syzkaller.appspot.com/bug?extid=96d3f9ff6a86d37e44c8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b57336e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149e357ae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 9807 at lib/refcount.c:28  
refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9807 Comm: syz-executor293 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0x1dc/0x1f0 lib/refcount.c:28
Code: e9 d8 fe ff ff 48 89 df e8 c1 5a 24 fe e9 85 fe ff ff e8 e7 08 e7 fd  
48 c7 c7 a0 6f 4f 88 c6 05 60 b8 a4 06 01 e8 53 bd b7 fd <0f> 0b e9 ac fe  
ff ff 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 55 48
RSP: 0018:ffff888093c97998 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815e4316 RDI: ffffed1012792f25
RBP: ffff888093c979a8 R08: ffff8880a04d4380 R09: ffffed1015d26621
R10: ffffed1015d26620 R11: ffff8880ae933107 R12: 0000000000000003
R13: 0000000000000000 R14: ffff8880a118d380 R15: ffff88809427e558
  refcount_sub_and_test include/linux/refcount.h:261 [inline]
  refcount_dec_and_test include/linux/refcount.h:281 [inline]
  sock_put include/net/sock.h:1728 [inline]
  smc_release+0x445/0x520 net/smc/af_smc.c:202
  __sock_release+0xce/0x280 net/socket.c:591
  sock_close+0x1e/0x30 net/socket.c:1269
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x8e7/0x2ef0 kernel/exit.c:797
  do_group_exit+0x135/0x360 kernel/exit.c:895
  get_signal+0x47c/0x24f0 kernel/signal.c:2734
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:160
  prepare_exit_to_usermode arch/x86/entry/common.c:195 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:278 [inline]
  do_syscall_32_irqs_on arch/x86/entry/common.c:352 [inline]
  do_fast_syscall_32+0xbbd/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f69a39
Code: Bad RIP value.
RSP: 002b:00000000f7f441ec EFLAGS: 00000296 ORIG_RAX: 00000000000000f0
RAX: fffffffffffffe00 RBX: 00000000080fb018 RCX: 0000000000000080
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 0000000020000040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

