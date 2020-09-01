Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C972585D0
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 04:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgIAC6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 22:58:18 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:48032 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgIAC6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 22:58:16 -0400
Received: by mail-il1-f200.google.com with SMTP id z6so1523355iln.14
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 19:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=WexOQnXbthcYvRcB6BIN9debPbV2YkV5F6SBTRFrGAo=;
        b=DxqJt87NfGHB9X23Js2jTH0xGDaTmd3/1mXaBQfoHsroBvEdYa916cQMqHZU2KAP7c
         yjcmAnnHZgiJNF0B1e1eNedPFv3zVQSR7O/3SiOghLy9KKB4u8vKlCBw/N7wLZqn3ejg
         Pp0redC0ovaD7BK/m/OB0hI0D8Nbab6bVSZgh7rv9TGanlpPEc6FPIuEr6XZhjnjSOIO
         KJYYvc8XBGak6E720pWlkHw8nkSm0glSDfrwpLpN9qYo0BBeRRJCevqYeOXxfHYgIM5I
         VXAyRHG2NDlxrJQk2+Hc3pizrtnrRctdv66WG6n8wkJB9cP93vMm1Rp5KuVL/WPfLxG6
         RkBg==
X-Gm-Message-State: AOAM5312zOGJKAZrVNknIh09PFq9zWkvWLyDUQnTx/dcTAX4vgLxbO+1
        I5BS7uMAlcAezmzdd8g5eGaxobnMEKXMQVMpAdhHRJuBgGB6
X-Google-Smtp-Source: ABdhPJw3yQOMAzLshUBx3mglJ5xdVhoAQxwgjD3PIGjPgyXTMFAnfsS6746SXh0Ih6aaYeSsqHDbug1pulTtspuBEIGa0+LBf3bB
MIME-Version: 1.0
X-Received: by 2002:a92:6a09:: with SMTP id f9mr4024575ilc.273.1598929095740;
 Mon, 31 Aug 2020 19:58:15 -0700 (PDT)
Date:   Mon, 31 Aug 2020 19:58:15 -0700
In-Reply-To: <000000000000500e6f05a34ecc01@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c5d18605ae37b04c@google.com>
Subject: Re: WARNING in bpf_cgroup_link_release
From:   syzbot <syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com>
To:     andrii.nakryiko@gmail.com, andriin@fb.com, ast@kernel.org,
        bpf@vger.kernel.org, dan.carpenter@oracle.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    bb8872a1 tipc: fix using smp_processor_id() in preemptible
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10aa0271900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0437fdd630bee11
dashboard link: https://syzkaller.appspot.com/bug?extid=8a5dadc5c0b1d7055945
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1291cbde900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12896476900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8a5dadc5c0b1d7055945@syzkaller.appspotmail.com

RBP: ffffffffffffffff R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000009
R13: 00007ffeea853240 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6859 at kernel/bpf/cgroup.c:833 bpf_cgroup_link_release.part.0+0x28b/0x380 kernel/bpf/cgroup.c:833
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6859 Comm: syz-executor054 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:bpf_cgroup_link_release.part.0+0x28b/0x380 kernel/bpf/cgroup.c:833
Code: 01 e8 ce e0 cd ff e9 f1 fe ff ff e8 3f 60 e7 ff 48 c7 c7 00 d4 bf 89 e8 83 ad 68 06 5b 5d 41 5c e9 2a 60 e7 ff e8 25 60 e7 ff <0f> 0b e9 01 fe ff ff e8 19 60 e7 ff e8 e4 2a d4 ff 31 ff 89 c3 89
RSP: 0018:ffffc90005367d38 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888094525700 RCX: ffffffff818cdceb
RDX: ffff8880978ec240 RSI: ffffffff818cdeeb RDI: 0000000000000005
RBP: 00000000fffffff4 R08: 0000000000000001 R09: ffffffff89c97453
R10: 0000000000000000 R11: 0000000035383654 R12: ffff888094525768
R13: ffffffffffffffa1 R14: 0000000000000022 R15: 0000000000000008
 bpf_cgroup_link_release kernel/bpf/cgroup.c:822 [inline]
 bpf_cgroup_link_detach+0x38/0x50 kernel/bpf/cgroup.c:854
 link_detach kernel/bpf/syscall.c:4009 [inline]
 __do_sys_bpf+0x667/0x4c20 kernel/bpf/syscall.c:4267
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x442229
Code: e8 1c b4 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 6b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffeea8531e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442229
RDX: 0000000000000008 RSI: 0000000020000040 RDI: 0000000000000022
RBP: ffffffffffffffff R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000009
R13: 00007ffeea853240 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

