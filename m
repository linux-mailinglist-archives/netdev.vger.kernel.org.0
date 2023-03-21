Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41FD6C379F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjCURED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjCUREA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:04:00 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DA82069F
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:03:56 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id b3-20020a056e02048300b003230de63373so8085357ils.10
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679418235;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JYvhqV9O/knwdmN3F4rsQ5x14ox3G/btg2GPgntvNw0=;
        b=wNNr22uOxbBQ5S9odTNsroAD0yhA0f1HSLobR0ZHgVoeGGsxBDNTPE4vPll5KYLXF6
         cBsTB0MbXlTwPCO0Za2W6QHj2gbwS2HoYFEX/DeNrnq4rEEOXc9kT1hXA3DJxOzkNwea
         9DA8Q2RqvutwafPXOjZgMnqKlu5f0Ttffad5CB+MdPOFt6T+ZxiIe2UYfumgLyTVJwXG
         KgfQNS8YhAik3c/RZLpjC52o9AP70hX8vE1AfbvCrvZ2InggbF/7u9uLlTjp02K5BjZs
         Hqn7XubtAqSuqQ21OXUd2Y3ZpNcwA0g/HhTwCdq5Vr2Drbod0xS0gHha4C7RM1qBANA9
         bvvg==
X-Gm-Message-State: AO0yUKWRXQt8SiMqqppLGODmyVmO8RrzrEbw/jS4Jv7+VqCU/SttFfAA
        2AH59Ku6Rx7Nyulj0UoH8TLItPBPFX1fkkZ1XFEZDH+/pBLD
X-Google-Smtp-Source: AK7set91M/CtD5CQHh7Ui2XMJWVYWleaSVsU47FcFP7C7NQO0m8T1524jNkeANeIxPNaYwu4UO93Lu4JgZ+r7/K4ZyI2VAyg8PA4
MIME-Version: 1.0
X-Received: by 2002:a92:2612:0:b0:313:cc98:7eee with SMTP id
 n18-20020a922612000000b00313cc987eeemr1318039ile.1.1679418235443; Tue, 21 Mar
 2023 10:03:55 -0700 (PDT)
Date:   Tue, 21 Mar 2023 10:03:55 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a60a305f76c07dc@google.com>
Subject: [syzbot] [kernel?] general protection fault in vhost_task_start
From:   syzbot <syzbot+6b27b2d2aba1c80cc13b@syzkaller.appspotmail.com>
To:     brauner@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.christie@oracle.com,
        mst@redhat.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6f08c1de13a9 Add linux-next specific files for 20230317
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13d954f6c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8cdb12af294ab55
dashboard link: https://syzkaller.appspot.com/bug?extid=6b27b2d2aba1c80cc13b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137b6b11c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16358a16c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/300a30f8157b/disk-6f08c1de.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7cad5b8b07a2/vmlinux-6f08c1de.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eded56f08b63/bzImage-6f08c1de.xz

The issue was bisected to:

commit 5ab18f4b061ef24a71eea9ffafebd1a82ae2f514
Author: Mike Christie <michael.christie@oracle.com>
Date:   Fri Mar 10 22:03:32 2023 +0000

    vhost: use vhost_tasks for worker threads

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d88e9ac80000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13d88e9ac80000
console output: https://syzkaller.appspot.com/x/log.txt?x=15d88e9ac80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6b27b2d2aba1c80cc13b@syzkaller.appspotmail.com
Fixes: 5ab18f4b061e ("vhost: use vhost_tasks for worker threads")

RBP: 00007ffe3d8e6050 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
general protection fault, probably for non-canonical address 0xdffffc000000000c: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
CPU: 0 PID: 5103 Comm: syz-executor280 Not tainted 6.3.0-rc2-next-20230317-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:vhost_task_start+0x22/0x40 kernel/vhost_task.c:115
Code: 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 53 48 89 fb e8 c3 67 2c 00 48 8d 7b 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 0a 48 8b 7b 70 5b e9 fe bd 02 00 e8 79 ec 7e 00 eb
RSP: 0018:ffffc90003a9fc38 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
RDX: 000000000000000c RSI: ffffffff81564c8d RDI: 0000000000000064
RBP: ffff88802b21dd40 R08: 0000000000000100 R09: ffffffff8c917cf3
R10: 00000000fffffff4 R11: 0000000000000000 R12: fffffffffffffff4
R13: ffff888075d000b0 R14: ffff888075d00000 R15: ffff888075d00008
FS:  0000555556247300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe3d8e5ff8 CR3: 00000000215d4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vhost_worker_create drivers/vhost/vhost.c:580 [inline]
 vhost_dev_set_owner+0x338/0xa90 drivers/vhost/vhost.c:603
 vhost_dev_ioctl+0xb4b/0xe70 drivers/vhost/vhost.c:1764
 vhost_vsock_dev_ioctl+0x389/0xb30 drivers/vhost/vsock.c:862
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f82c4252049
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe3d8e6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f82c4252049
RDX: 0000000000000000 RSI: 000000000000af01 RDI: 0000000000000003
RBP: 00007ffe3d8e6050 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:vhost_task_start+0x22/0x40 kernel/vhost_task.c:115
Code: 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 53 48 89 fb e8 c3 67 2c 00 48 8d 7b 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 0a 48 8b 7b 70 5b e9 fe bd 02 00 e8 79 ec 7e 00 eb
RSP: 0018:ffffc90003a9fc38 EFLAGS: 00010207
RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
RDX: 000000000000000c RSI: ffffffff81564c8d RDI: 0000000000000064
RBP: ffff88802b21dd40 R08: 0000000000000100 R09: ffffffff8c917cf3
R10: 00000000fffffff4 R11: 0000000000000000 R12: fffffffffffffff4
R13: ffff888075d000b0 R14: ffff888075d00000 R15: ffff888075d00008
FS:  0000555556247300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe3d8e5ff8 CR3: 00000000215d4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	0f 1f 00             	nopl   (%rax)
   7:	f3 0f 1e fa          	endbr64
   b:	53                   	push   %rbx
   c:	48 89 fb             	mov    %rdi,%rbx
   f:	e8 c3 67 2c 00       	callq  0x2c67d7
  14:	48 8d 7b 70          	lea    0x70(%rbx),%rdi
  18:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1f:	fc ff df
  22:	48 89 fa             	mov    %rdi,%rdx
  25:	48 c1 ea 03          	shr    $0x3,%rdx
* 29:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2d:	75 0a                	jne    0x39
  2f:	48 8b 7b 70          	mov    0x70(%rbx),%rdi
  33:	5b                   	pop    %rbx
  34:	e9 fe bd 02 00       	jmpq   0x2be37
  39:	e8 79 ec 7e 00       	callq  0x7eecb7
  3e:	eb                   	.byte 0xeb


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
