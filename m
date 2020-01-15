Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA6613B985
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgAOGZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 01:25:10 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:50028 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgAOGZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:25:10 -0500
Received: by mail-il1-f197.google.com with SMTP id j21so12580220ilf.16
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 22:25:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eW4Xg4UoPEB3a/2AZhweqhOWkYfz9yjercWeCE8lc/U=;
        b=olWtGIHMw1OtV5UjRU6CVc8cF8+ydUVAGeop9eyxUw3EMh9N+bNGMIBok4mQbCXV00
         L2/o7BJM2/ypNS5uZPlwsu9gbXFu+dI0zEJLuzKxoy3v9rt80iiXX3Dmx4qt91zIx8eN
         d8kS6q7yiptHKcay9o+obYrgsXewnTLp0rZkndkNiqcjiEl7zomuHWuIYLI73qhkqTAF
         QVMWW2t/3MXa6+V6wekz4Z+T6pbsgtsO+h+o/s/BZg/9BLIDu0QRz/gjDGJMY3plb0fw
         01XF40QPMRws2XZyR/J0Wh504W82YGL9uJMLE7ke+0oH1wkW/+xhMmMfW8CLQT7B/nsc
         mnug==
X-Gm-Message-State: APjAAAXRy7ok9NH73m5fEe6FY88+E88AMidI9EPQq1Jb0V9/55bTgrv6
        smH972H/2JuW0biSSlnoSBSu/QBASGVCeUhk/gxp4hrd8C7m
X-Google-Smtp-Source: APXvYqxML7d3L5Iw4ZulrZXdY2U62wtdVprZnJIEN29JJJ44LTFXEhQ5v2TG6VzttbZ8fg8QmdfCS48D2VQcTt90ZkkHQRKWwgmW
MIME-Version: 1.0
X-Received: by 2002:a5e:a614:: with SMTP id q20mr19404414ioi.36.1579069509574;
 Tue, 14 Jan 2020 22:25:09 -0800 (PST)
Date:   Tue, 14 Jan 2020 22:25:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000031a8d7059c27c540@google.com>
Subject: general protection fault in free_verifier_state (3)
From:   syzbot <syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6dd42aa1 Merge branch 'runqslower'
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14e61349e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a736c99e9fe5a676
dashboard link: https://syzkaller.appspot.com/bug?extid=b296579ba5015704d9fa
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b296579ba5015704d9fa@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3213 Comm: syz-executor.2 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:free_verifier_state+0x49/0x1d0 kernel/bpf/verifier.c:744
Code: db 48 83 ec 20 48 89 45 b8 48 c1 e8 03 4c 01 f8 89 75 c4 48 89 45 c8  
e8 65 ae f2 ff 4c 63 f3 4f 8d 2c f4 4c 89 e8 48 c1 e8 03 <42> 80 3c 38 00  
0f 85 2b 01 00 00 4f 8d 34 f4 49 8b 3e 48 85 ff 48
RSP: 0018:ffffc900017c7688 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000d65b000
RDX: 0000000000040000 RSI: ffffffff818251eb RDI: 0000000000000000
RBP: ffffc900017c76d0 R08: ffff88806f496640 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fdb4648e700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000010f6e80 CR3: 00000000690e9000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
  do_check_common+0x2ec7/0x9650 kernel/bpf/verifier.c:9597
  do_check_main kernel/bpf/verifier.c:9654 [inline]
  bpf_check+0x84ed/0xbb07 kernel/bpf/verifier.c:10009
  bpf_prog_load+0xeab/0x17f0 kernel/bpf/syscall.c:1859
  __do_sys_bpf+0x1269/0x37a0 kernel/bpf/syscall.c:3096
  __se_sys_bpf kernel/bpf/syscall.c:3055 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:3055
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45af49
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fdb4648dc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045af49
RDX: 0000000000000024 RSI: 0000000020000200 RDI: 0000000000000005
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fdb4648e6d4
R13: 00000000004c1697 R14: 00000000004d66a0 R15: 00000000ffffffff
Modules linked in:
---[ end trace d725571ef2f4cce3 ]---
RIP: 0010:free_verifier_state+0x49/0x1d0 kernel/bpf/verifier.c:744
Code: db 48 83 ec 20 48 89 45 b8 48 c1 e8 03 4c 01 f8 89 75 c4 48 89 45 c8  
e8 65 ae f2 ff 4c 63 f3 4f 8d 2c f4 4c 89 e8 48 c1 e8 03 <42> 80 3c 38 00  
0f 85 2b 01 00 00 4f 8d 34 f4 49 8b 3e 48 85 ff 48
RSP: 0018:ffffc900017c7688 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000d65b000
RDX: 0000000000040000 RSI: ffffffff818251eb RDI: 0000000000000000
RBP: ffffc900017c76d0 R08: ffff88806f496640 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007fdb4648e700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000075c000 CR3: 00000000690e9000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
