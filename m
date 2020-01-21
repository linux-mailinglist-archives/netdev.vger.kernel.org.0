Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB09F1444C7
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729235AbgAUTFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:05:11 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:36862 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbgAUTFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:05:11 -0500
Received: by mail-io1-f70.google.com with SMTP id d4so41577iom.3
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:05:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hh2ESy2i/NiRcbPskm2nSqHQ3QN16smrsuvBjfTZgUM=;
        b=E9vsaSpKhr7Z0gQ6Qq0ZdIl8Ve9pTrLuvSOG5nLHBR2etI2PL9Gipur5Ox5DOYOY2W
         XTi4LR7UyPn0lJNShMHGqkemYd0eyh4ThTbgbkmzLG0qJeCPbpU8wBGs0biHqDV96R7G
         cYFa068EzM0mITwzuk9jK8ZR7Buhwxng0I4bcgB42BuG36+Or0flZ7h4snqsOfTddjSh
         SOujLvrXgnyZxk8lCzVITR+gTL5AybdeWfbufXwiR205wZK2DLv79Prg96V7wNN+9NdW
         ISzRYqOc5Ro8maRIrxCgp424xzcV3pXKMmquR4ubEEPPmBagC3Y9Yo2ZM1UG8dvmhEOp
         Dw5A==
X-Gm-Message-State: APjAAAXhe3vZJsLh++LO07DtTwXMWzbDyYWwqP93bcvOPp/Rrf+05Jgs
        wzAS2guZfAdrPLzppHwbvVr/hu0umYXbsuxgupUmEp/34NYC
X-Google-Smtp-Source: APXvYqyZ1QuvEk+mqTzqtnA/MZi4neaIzQRg7ExQ7pNjV6hYabWrj6Ictf/X0GhvKHIRjlto/mdRrhfEOUAUluhnhGm+/UvwnEzI
MIME-Version: 1.0
X-Received: by 2002:a5e:a614:: with SMTP id q20mr3966732ioi.36.1579633510714;
 Tue, 21 Jan 2020 11:05:10 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:05:10 -0800
In-Reply-To: <00000000000031a8d7059c27c540@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000048111c059cab1695@google.com>
Subject: Re: general protection fault in free_verifier_state (3)
From:   syzbot <syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    2e3a94aa bpf: Fix memory leaks in generic update/delete ba..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15aefc6ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a736c99e9fe5a676
dashboard link: https://syzkaller.appspot.com/bug?extid=b296579ba5015704d9fa
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a4280de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1411544ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441339
RDX: 0000000000000048 RSI: 00000000200017c0 RDI: 0000000000000005
RBP: 00000000006cc018 R08: 0000000000000002 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402280
R13: 0000000000402310 R14: 0000000000000000 R15: 0000000000000000
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9996 Comm: syz-executor310 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:free_verifier_state+0x49/0x1d0 kernel/bpf/verifier.c:744
Code: db 48 83 ec 20 48 89 45 b8 48 c1 e8 03 4c 01 f8 89 75 c4 48 89 45 c8 e8 05 9c f2 ff 4c 63 f3 4f 8d 2c f4 4c 89 e8 48 c1 e8 03 <42> 80 3c 38 00 0f 85 2b 01 00 00 4f 8d 34 f4 49 8b 3e 48 85 ff 48
RSP: 0018:ffffc90002007688 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff8184dd58
RDX: 0000000000000000 RSI: ffffffff8182644b RDI: 0000000000000000
RBP: ffffc900020076d0 R08: ffff888098656280 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  000000000236b880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000098345000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_check_common+0x2ec7/0x9650 kernel/bpf/verifier.c:9597
 do_check_main kernel/bpf/verifier.c:9654 [inline]
 bpf_check+0x84ed/0xbb07 kernel/bpf/verifier.c:10009
 bpf_prog_load+0xeab/0x17f0 kernel/bpf/syscall.c:2095
 __do_sys_bpf+0x1521/0x41e0 kernel/bpf/syscall.c:3387
 __se_sys_bpf kernel/bpf/syscall.c:3346 [inline]
 __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3346
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441339
Code: e8 5c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 bb 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe7971f348 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441339
RDX: 0000000000000048 RSI: 00000000200017c0 RDI: 0000000000000005
RBP: 00000000006cc018 R08: 0000000000000002 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402280
R13: 0000000000402310 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace af38d247c1b207c2 ]---
RIP: 0010:free_verifier_state+0x49/0x1d0 kernel/bpf/verifier.c:744
Code: db 48 83 ec 20 48 89 45 b8 48 c1 e8 03 4c 01 f8 89 75 c4 48 89 45 c8 e8 05 9c f2 ff 4c 63 f3 4f 8d 2c f4 4c 89 e8 48 c1 e8 03 <42> 80 3c 38 00 0f 85 2b 01 00 00 4f 8d 34 f4 49 8b 3e 48 85 ff 48
RSP: 0018:ffffc90002007688 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff8184dd58
RDX: 0000000000000000 RSI: ffffffff8182644b RDI: 0000000000000000
RBP: ffffc900020076d0 R08: ffff888098656280 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  000000000236b880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 0000000098345000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

