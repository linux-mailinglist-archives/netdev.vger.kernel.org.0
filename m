Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ECE3F68FC
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 20:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhHXSUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 14:20:07 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:47691 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbhHXSUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 14:20:06 -0400
Received: by mail-il1-f197.google.com with SMTP id j17-20020a926e11000000b0022487646515so8885529ilc.14
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 11:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xFg7LNFI3jZQyCqLc7N7YhQ4foPfvQrMQWd2IF54/do=;
        b=TX8clBV5TtNN1WXIdqsMv25lOBgNrTj5ju7f2Isxi9EWn/nyd++t5fqTXib26fPlVP
         tlHuj2sFKnO+sz7OoRybLGDsH5ai0okHYGhFK1nC/gmN9pwlNIiV+yIRvwi9d4nxZCB9
         g+tDcSyXI4+htM1LrweUh7gHUjMUork0hVBWJhMlpO7Zf6c5/GpNv9h0fQV6Af+bDx+0
         uPBK1nDu1efZP/RQ/eHGyzpW5DSsk6k4zd/Sw1LOyV2JF0sR5k1GYZuqDVe3GTTdW02l
         mtwiT2q8UIDGy6jvX2Kfe3y3Bh3Zw99Td3wH5gikXgtzNy5EPbd+UPnVHfRIo0kHpsl8
         9MMQ==
X-Gm-Message-State: AOAM532GexsBlvPbbK/NiyCI85xRcSQuZfxKPwarPVCoi4p9tTwF/m6D
        QRoOTPaIsb/QdeyZrVQDIttyLBjohmziSqmwCOJbVeu8XBni
X-Google-Smtp-Source: ABdhPJzZ0HX0/0IIyK28ijbUuf6x7IGP4mtBrq49u1w9HOyDxnfMDTqfJnm7ebHV290RdOMSCz1cSZkx3cd0xS60xQ86H4gGtTrq
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:547:: with SMTP id i7mr27531008ils.102.1629829161558;
 Tue, 24 Aug 2021 11:19:21 -0700 (PDT)
Date:   Tue, 24 Aug 2021 11:19:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003830e105ca522cba@google.com>
Subject: [syzbot] general protection fault in do_blk_trace_setup
From:   syzbot <syzbot+f74aa89114a236643919@syzkaller.appspotmail.com>
To:     Kai.Makisara@kolumbus.fi, axboe@kernel.dk, davem@davemloft.net,
        hch@lst.de, jejb@linux.ibm.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-block@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, martin.petersen@oracle.com, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    372b2891c15a Add linux-next specific files for 20210824
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15dc8389300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18ce42745c8b0dd6
dashboard link: https://syzkaller.appspot.com/bug?extid=f74aa89114a236643919
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10979275300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10fe84a9300000

The issue was bisected to:

commit 45938335d0a9773d65a82a7ca722bb76e4b997a8
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Aug 16 13:19:03 2021 +0000

    st: do not allocate a gendisk

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14682399300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16682399300000
console output: https://syzkaller.appspot.com/x/log.txt?x=12682399300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f74aa89114a236643919@syzkaller.appspotmail.com
Fixes: 45938335d0a9 ("st: do not allocate a gendisk")

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 6540 Comm: syz-executor323 Not tainted 5.14.0-rc7-next-20210824-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:strncpy+0x32/0xb0 lib/string.c:130
Code: 54 55 53 48 83 ec 08 48 85 d2 74 5c 4c 8d 2c 17 48 89 fb 49 bc 00 00 00 00 00 fc ff df 48 89 f0 48 89 f2 48 c1 e8 03 83 e2 07 <42> 0f b6 04 20 38 d0 7f 04 84 c0 75 41 48 89 d8 48 89 da 0f b6 2e
RSP: 0018:ffffc90002d2fb98 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90002d2fc70 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90002d2fc70
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffc90002d2fcb7
R10: ffffffff817c66f5 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffc90002d2fc90 R14: ffffc90002d2fc70 R15: ffffc90002d2fc94
FS:  0000000001ff3300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5c7fb696c0 CR3: 000000001ae25000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 strncpy include/linux/fortify-string.h:59 [inline]
 do_blk_trace_setup+0x113/0xcd0 kernel/trace/blktrace.c:485
 __blk_trace_setup+0xca/0x180 kernel/trace/blktrace.c:589
 blk_trace_setup+0x43/0x60 kernel/trace/blktrace.c:607
 sg_ioctl_common drivers/scsi/sg.c:1122 [inline]
 sg_ioctl+0x252/0x2760 drivers/scsi/sg.c:1164
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4434b9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd335501e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000004004a0 RCX: 00000000004434b9
RDX: 0000000020000100 RSI: 00000000c0481273 RDI: 0000000000000004
RBP: 0000000000403060 R08: 00000000004004a0 R09: 00000000004004a0
R10: 002367732f766564 R11: 0000000000000246 R12: 00000000004030f0
R13: 0000000000000000 R14: 00000000004b1018 R15: 00000000004004a0
Modules linked in:
---[ end trace c8de7dc978626109 ]---
RIP: 0010:strncpy+0x32/0xb0 lib/string.c:130
Code: 54 55 53 48 83 ec 08 48 85 d2 74 5c 4c 8d 2c 17 48 89 fb 49 bc 00 00 00 00 00 fc ff df 48 89 f0 48 89 f2 48 c1 e8 03 83 e2 07 <42> 0f b6 04 20 38 d0 7f 04 84 c0 75 41 48 89 d8 48 89 da 0f b6 2e
RSP: 0018:ffffc90002d2fb98 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90002d2fc70 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90002d2fc70
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffc90002d2fcb7
R10: ffffffff817c66f5 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffc90002d2fc90 R14: ffffc90002d2fc70 R15: ffffc90002d2fc94
FS:  0000000001ff3300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8125f40018 CR3: 000000001ae25000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	54                   	push   %rsp
   1:	55                   	push   %rbp
   2:	53                   	push   %rbx
   3:	48 83 ec 08          	sub    $0x8,%rsp
   7:	48 85 d2             	test   %rdx,%rdx
   a:	74 5c                	je     0x68
   c:	4c 8d 2c 17          	lea    (%rdi,%rdx,1),%r13
  10:	48 89 fb             	mov    %rdi,%rbx
  13:	49 bc 00 00 00 00 00 	movabs $0xdffffc0000000000,%r12
  1a:	fc ff df
  1d:	48 89 f0             	mov    %rsi,%rax
  20:	48 89 f2             	mov    %rsi,%rdx
  23:	48 c1 e8 03          	shr    $0x3,%rax
  27:	83 e2 07             	and    $0x7,%edx
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2f:	38 d0                	cmp    %dl,%al
  31:	7f 04                	jg     0x37
  33:	84 c0                	test   %al,%al
  35:	75 41                	jne    0x78
  37:	48 89 d8             	mov    %rbx,%rax
  3a:	48 89 da             	mov    %rbx,%rdx
  3d:	0f b6 2e             	movzbl (%rsi),%ebp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
