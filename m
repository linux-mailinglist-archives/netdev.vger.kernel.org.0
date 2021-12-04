Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC88468383
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 10:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384439AbhLDJV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:21:56 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:56061 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384433AbhLDJVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:21:53 -0500
Received: by mail-io1-f71.google.com with SMTP id y74-20020a6bc84d000000b005e700290338so4334527iof.22
        for <netdev@vger.kernel.org>; Sat, 04 Dec 2021 01:18:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CUg3SKRRr5AZRrrRAfBqwmKAe9l+DABQvp0lKUAZGW4=;
        b=22D4xlMduEt+pKrEpEeMYXua1eWreF5rLofUPYapVkJYfgiaGEO57KZDN46/+7bcql
         D/7wR4G5ai0X5UHEFsDANHamdkB/y/AJMxG7jw8LN2vrlEFk/62iJQ/O51XtFx7h61FH
         R23qxAGoPTwJg1ASFhM6M5R3Mfv/+Yg5oGMWY866cHVvQ6H4rg3x3r23EdYwP1BA6HW4
         NVP45pGPU2HrGHqNUFptrDaoZihwcgpvnEOO0USJ1ngpzTfgH+gPWhJC9SHjQogZ86oD
         ZJwXndPwHWV7lbh2mHSVoWk3uIkSOuCO+GALwGeHzSD1RHT2o/RM9waeeWes1g3utWcQ
         BIAg==
X-Gm-Message-State: AOAM5302mJU9Mcqeyz8Ha191dU09KYcJILPbVWPH9qxx7U/OhbPhvYdA
        aciLTHQedMj1FGjlgXI3VnINIDjs7zYrkE957QvSokQIY3kv
X-Google-Smtp-Source: ABdhPJzAficTU5yYxlsBfgJBI6iE30UopThIcBDgy4Jniw7LCPCs+V9xZYzu/6bHKQNczIo5WTUTgJ5bl1S+aT7AL2HCH+lLOjIV
MIME-Version: 1.0
X-Received: by 2002:a6b:7602:: with SMTP id g2mr24178579iom.37.1638609508327;
 Sat, 04 Dec 2021 01:18:28 -0800 (PST)
Date:   Sat, 04 Dec 2021 01:18:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab655805d24e814a@google.com>
Subject: [syzbot] general protection fault in kernel_accept (3)
From:   syzbot <syzbot+03655f787f231d1b7b6c@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d40ce48cb3a6 Merge branch 'af_unix-replace-unix_table_lock..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14b86465b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7cc851c2debde333
dashboard link: https://syzkaller.appspot.com/bug?extid=03655f787f231d1b7b6c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+03655f787f231d1b7b6c@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000072: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000390-0x0000000000000397]
CPU: 0 PID: 15597 Comm: kworker/u4:6 Not tainted 5.16.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: tipc_rcv tipc_topsrv_accept
RIP: 0010:kernel_accept+0x56/0x350 net/socket.c:3417
Code: c1 ea 03 80 3c 02 00 0f 85 90 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 65 18 49 8d bc 24 94 03 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 50
RSP: 0018:ffffc90002fdfc30 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffffc90002fdfca8 RCX: 0000000000000000
RDX: 0000000000000072 RSI: ffffffff87211fca RDI: 0000000000000394
RBP: ffff888035524800 R08: 0000000000000001 R09: ffffffff8ff7bb3f
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000800 R14: ffff88802668f770 R15: ffff88802668f2c0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f41e78fc1b8 CR3: 0000000021d55000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tipc_topsrv_accept+0x197/0x280 net/tipc/topsrv.c:460
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Modules linked in:
---[ end trace d8fc85c5be0bfa88 ]---
RIP: 0010:kernel_accept+0x56/0x350 net/socket.c:3417
Code: c1 ea 03 80 3c 02 00 0f 85 90 02 00 00 48 b8 00 00 00 00 00 fc ff df 4c 8b 65 18 49 8d bc 24 94 03 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 50
RSP: 0018:ffffc90002fdfc30 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: ffffc90002fdfca8 RCX: 0000000000000000
RDX: 0000000000000072 RSI: ffffffff87211fca RDI: 0000000000000394
RBP: ffff888035524800 R08: 0000000000000001 R09: ffffffff8ff7bb3f
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000800 R14: ffff88802668f770 R15: ffff88802668f2c0
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f93092d2000 CR3: 000000001bf56000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	c1 ea 03             	shr    $0x3,%edx
   3:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   7:	0f 85 90 02 00 00    	jne    0x29d
   d:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  14:	fc ff df
  17:	4c 8b 65 18          	mov    0x18(%rbp),%r12
  1b:	49 8d bc 24 94 03 00 	lea    0x394(%r12),%rdi
  22:	00
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
  2e:	48 89 f8             	mov    %rdi,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 01             	add    $0x1,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	50                   	push   %rax


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
