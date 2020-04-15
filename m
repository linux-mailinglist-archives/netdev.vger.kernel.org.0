Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9B1A93B7
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 08:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403829AbgDOGzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 02:55:21 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37221 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393646AbgDOGzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 02:55:15 -0400
Received: by mail-io1-f72.google.com with SMTP id c26so12653636ioa.4
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 23:55:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ffkbImYYrsgJDwBLGUxZeSax9u6Dimg6eHOtdawCFEA=;
        b=ooHiVLcWcKKYgvVlnB/32VbX8QuuINyFp376h73gVW8XLrvXBqu8tMiYeVkmP6ZhTy
         vV39uRX9Q9vgnxc+eNt3BpHPqepVTdTTxis3D2K6VLs6pvTHljaNE/4A0HEmjugmFljE
         iZerGZADrDJ/eJJvwpUagC7W8w0p1LSmEHQs/rmhlTRuJAjuxAvvkAx/aTRl5vjv3MhD
         ulhCMYDJYIXbHKLDDgnp0jJmjRHEQ1ohfUryiNywi2NE2JKITgH69GUeDNMz3beMdkjd
         rbFQAhFbUlJHRyGDg9+A9yi4TIS5wTpMQwVy3i6D6liS0mSQL6xRL/OnytTEbIjPulAz
         nNZw==
X-Gm-Message-State: AGi0PuZc4UJwDRYwy+RQ0nIB7kVCHgx7PYS3lIp5pflGt1HhGV0NbwRQ
        Ujq+7WqR1xCvtNjF+a732SzXfdcpgEvIrNiwiPtGxAh5uDA2
X-Google-Smtp-Source: APiQypL5O5Qrqc6gTDaxaEZXS7NaWGBqYkgJ/KH9Tnj9bcjR4061KB5xUQ54Rj9vQGod2JR4LK8zk4DcgF1jYYOI0XwkHbwWGA/n
MIME-Version: 1.0
X-Received: by 2002:a92:8b12:: with SMTP id i18mr3892649ild.182.1586933714126;
 Tue, 14 Apr 2020 23:55:14 -0700 (PDT)
Date:   Tue, 14 Apr 2020 23:55:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000500e6f05a34ecc01@google.com>
Subject: WARNING in bpf_cgroup_link_release
From:   syzbot <syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1a323ea5 x86: get rid of 'errret' argument to __get_user_x..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=148ccb57e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c1e98458335a7d1
dashboard link: https://syzkaller.appspot.com/bug?extid=8a5dadc5c0b1d7055945
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 25081 at kernel/bpf/cgroup.c:796 bpf_cgroup_link_release+0x260/0x3a0 kernel/bpf/cgroup.c:796
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 25081 Comm: syz-executor.1 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:bpf_cgroup_link_release+0x260/0x3a0 kernel/bpf/cgroup.c:796
Code: cf ff 5b 5d 41 5c e9 df 2a e9 ff e8 da 2a e9 ff 48 c7 c7 20 f4 9d 89 e8 de a0 3a 06 5b 5d 41 5c e9 c5 2a e9 ff e8 c0 2a e9 ff <0f> 0b e9 57 fe ff ff e8 a4 3d 26 00 e9 2a fe ff ff e8 9a 3d 26 00
RSP: 0018:ffffc900019a7dc0 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff88808c3eac00 RCX: ffffc9000415a000
RDX: 0000000000040000 RSI: ffffffff8189bea0 RDI: 0000000000000005
RBP: 00000000fffffff4 R08: ffff88809055e000 R09: ffffed1015cc70f4
R10: ffffed1015cc70f3 R11: ffff8880ae63879b R12: ffff88808c3eac60
R13: ffff88808c3eac10 R14: ffffc90000f32000 R15: ffffffff817f8e60
 bpf_link_free+0x80/0x140 kernel/bpf/syscall.c:2217
 bpf_link_put+0x15e/0x1b0 kernel/bpf/syscall.c:2243
 bpf_link_release+0x33/0x40 kernel/bpf/syscall.c:2251
 __fput+0x2e9/0x860 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fddaf43fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 00007fddaf4406d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000006
R13: 0000000000000078 R14: 00000000005043d2 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
