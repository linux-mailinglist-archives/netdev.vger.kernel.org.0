Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0AB62C26E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiKPPZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiKPPZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:25:38 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A466E5C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 07:25:37 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id l4-20020a056e021aa400b00300ad9535c8so13379764ilv.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 07:25:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wJ4L9gWxz0iScjIBZMxOP+5QomVfwBjk3nKBWeXU/to=;
        b=iwkmLt4e3pqjKhVX3a8PbtCY536eUmfGwW9qzGylOK3du0Gg51tt+HY/fNBLb8hLRh
         8AUqVGvwTeUQSqNzknzhUp+n5uk2oL3DdACLJUDUGVkKGkzqkcuhHBRFpArul1kLJPJ6
         Xw9XVVNF5bTcsQoR5+bcAgweZ/0o6pw5BoE0LNVBpgr8cbVhZjJTlKXXAcXtgqOm81vl
         YmfuTmb5vgvmBV0InjayuNw1TBC4qxNxYroT/EKG8DYC6eNycrjBCOiIV+K81UNjiuYf
         b4yoxJg58bVgnNwtvpftAHTCilR0Mz85SwLsLbSqQmtxqaa0anlcEEjJwwRN4QRv1y9A
         jQMQ==
X-Gm-Message-State: ANoB5pmnD14ZUssfc8EXIc07hrIvvCYHOZoBJxLCOKL6e7pu4mWc/OvK
        RmVmPth+1pg8KtLS51H/C4AxoosvELv57N3k2njjwhWkhpyr
X-Google-Smtp-Source: AA0mqf4Pel4ZBKFv8lyzlCmOdx4V98qMO5K/R54P9kni/wuO+bqtaoG/7F63JsULd4tA0Sy9PXSnM26Oh95vvY3V80bVtNB20BtE
MIME-Version: 1.0
X-Received: by 2002:a5e:c908:0:b0:6aa:ad87:4e3f with SMTP id
 z8-20020a5ec908000000b006aaad874e3fmr9851526iol.14.1668612336997; Wed, 16 Nov
 2022 07:25:36 -0800 (PST)
Date:   Wed, 16 Nov 2022 07:25:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009d5daa05ed9815fa@google.com>
Subject: [syzbot] WARNING in call_timer_fn
From:   syzbot <syzbot+6fb78d577e89e69602f9@syzkaller.appspotmail.com>
To:     ben-linux@fluff.org, bp@alien8.de, daniel.sneddon@linux.intel.com,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7eba4505394e net: dcb: move getapptrust to separate function
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16626ce9880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=893a728fb1a6b263
dashboard link: https://syzkaller.appspot.com/bug?extid=6fb78d577e89e69602f9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16899f35880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/68b1a18c1aad/disk-7eba4505.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f03970850c94/vmlinux-7eba4505.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4775c120c4c6/bzImage-7eba4505.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6fb78d577e89e69602f9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5978 at kernel/workqueue.c:1438 __queue_work+0xf70/0x13b0 kernel/workqueue.c:1438
Modules linked in:
CPU: 0 PID: 5978 Comm: syz-executor.3 Not tainted 6.1.0-rc4-syzkaller-01070-g7eba4505394e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__queue_work+0xf70/0x13b0 kernel/workqueue.c:1438
Code: e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8 e8 64 7b 00 8b 5b 2c 31 ff 83 e3 20 89 de e8 09 5e 2e 00 85 db 75 42 e8 50 61 2e 00 <0f> 0b e9 7e f7 ff ff e8 44 61 2e 00 0f 0b e9 10 f7 ff ff e8 38 61
RSP: 0018:ffffc90000007c98 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000100 RCX: 0000000000000100
RDX: ffff888022ba9d40 RSI: ffffffff8151be20 RDI: 0000000000000005
RBP: ffffc90000007d60 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000001 R12: ffff88806ccf4b30
R13: ffff88806ccf4b78 R14: 0000000000000000 R15: ffff88807568f000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555558e1708 CR3: 0000000076b84000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1514 [inline]
 __run_timers.part.0+0x4a3/0xaf0 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb7/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:lock_acquire+0x227/0x630 kernel/locking/lockdep.c:5636
Code: 76 9f 7e 83 f8 01 0f 85 3a 03 00 00 9c 58 f6 c4 02 0f 85 25 03 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
RSP: 0018:ffffc90006f678d0 EFLAGS: 00000206
RAX: dffffc0000000000 RBX: 1ffff92000decf1d RCX: 0000000000000001
RDX: 1ffff110045754f1 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000001 R09: ffffffff912a75ef
R10: fffffbfff2254ebd R11: 1ffffffff212a1df R12: 0000000000000000
R13: 0000000000000000 R14: ffff88807568f138 R15: 0000000000000000
 __flush_workqueue+0x118/0x13a0 kernel/workqueue.c:2809
 drain_workqueue+0x1a9/0x3c0 kernel/workqueue.c:2974
 hci_dev_close_sync+0x2f3/0x1200 net/bluetooth/hci_sync.c:4809
 hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
 hci_unregister_dev+0x183/0x4e0 net/bluetooth/hci_core.c:2702
 vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xb3d/0x2a30 kernel/exit.c:820
 do_group_exit+0xd4/0x2a0 kernel/exit.c:950
 __do_sys_exit_group kernel/exit.c:961 [inline]
 __se_sys_exit_group kernel/exit.c:959 [inline]
 __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:959
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f3d8a68b639
Code: Unable to access opcode bytes at 0x7f3d8a68b60f.
RSP: 002b:00007ffd554b9878 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000029 RCX: 00007f3d8a68b639
RDX: 00007f3d8a68cc8a RSI: 0000000000000000 RDI: 0000000000000007
RBP: 0000000000000007 R08: ffffffffff000000 R09: 0000000000000029
R10: 00000000000003b8 R11: 0000000000000246 R12: 00007ffd554b9f00
R13: 0000000000000003 R14: 00007ffd554b9e9c R15: 00007f3d8a782b60
 </TASK>
----------------
Code disassembly (best guess):
   0:	76 9f                	jbe    0xffffffa1
   2:	7e 83                	jle    0xffffff87
   4:	f8                   	clc
   5:	01 0f                	add    %ecx,(%rdi)
   7:	85 3a                	test   %edi,(%rdx)
   9:	03 00                	add    (%rax),%eax
   b:	00 9c 58 f6 c4 02 0f 	add    %bl,0xf02c4f6(%rax,%rbx,2)
  12:	85 25 03 00 00 48    	test   %esp,0x48000003(%rip)        # 0x4800001b
  18:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
  1d:	74 01                	je     0x20
  1f:	fb                   	sti
  20:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  27:	fc ff df
* 2a:	48 01 c3             	add    %rax,%rbx <-- trapping instruction
  2d:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  34:	48 c7 43 08 00 00 00 	movq   $0x0,0x8(%rbx)
  3b:	00
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	84                   	.byte 0x84
  3f:	24                   	.byte 0x24


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
