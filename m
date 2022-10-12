Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072DE5FC6ED
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJLODn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJLODl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:03:41 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010EDB7EF4
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:03:39 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id z4-20020a921a44000000b002f8da436b83so13351552ill.19
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:03:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ev3L4nDelDy3NY/Rh4HvmX0Boq8wljaMarKq/Tpj6ek=;
        b=kh6PFQxlATrmeujL3BiboB1Jw8hlFgzJq4kbIaR34X94r1FJqrjM+sWpKMpEBxj1tj
         LKMtfVEP/FK/4lgRcDHMkvhr3RbzUK2P4O0SA9cnL6g338SpOggI1FGm3Vhh6oOCggDF
         5uBlpQhy0GlQdb22VMBNsa6/uLgnzp44viFgL5YNI/EohdcC/a7+mASZCD0v4Zk7RFkd
         jmEkcCa/pIW/HMDxHX8Ha0UXhdIbb32Jtsl+KaWRZfV7fj5h+8uRciDSXs1PqIlqjUxD
         GYJyy/zWJtIdyEth2JPxDL7CxuIJs+O8LahYurOXhRubVFL/k3zMRB8Yeh9P7wL19ham
         wAGQ==
X-Gm-Message-State: ACrzQf2AEJHRNm59R0j4LZVuoIo/HHB/igkjffWL3RvYbm/UJnIUfFtp
        yAs3HSOHfTM/Fm01/0viCq7N9PiCIlPBaazCe2vdFKJLw990
X-Google-Smtp-Source: AMsMyM7r4SXGSUK8xJtD5EKkq1dAW66dladkwHTNKrNZ0s0WONptAvWSETidV182e3cP1jBNzuM2B70eNn5PionSZ8e4uhidF/iH
MIME-Version: 1.0
X-Received: by 2002:a05:6602:13c8:b0:68a:db5d:269d with SMTP id
 o8-20020a05660213c800b0068adb5d269dmr13715768iov.209.1665583419349; Wed, 12
 Oct 2022 07:03:39 -0700 (PDT)
Date:   Wed, 12 Oct 2022 07:03:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000de35905ead6dcc1@google.com>
Subject: [syzbot] general protection fault in skb_queue_tail (3)
From:   syzbot <syzbot+160a7250e255d25725eb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kvalo@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com, toke@toke.dk
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

HEAD commit:    aaa11ce2ffc8 Add linux-next specific files for 20220923
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16b08124880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=186d1ff305f10294
dashboard link: https://syzkaller.appspot.com/bug?extid=160a7250e255d25725eb
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17b4f3d4880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=160283c0880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/95c7bf83c07e/disk-aaa11ce2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b161cd56a7a3/vmlinux-aaa11ce2.xz

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=172283c0880000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14a283c0880000
console output: https://syzkaller.appspot.com/x/log.txt?x=10a283c0880000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+160a7250e255d25725eb@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 3616 Comm: syz-executor849 Not tainted 6.0.0-rc6-next-20220923-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:__skb_insert include/linux/skbuff.h:2158 [inline]
RIP: 0010:__skb_queue_before include/linux/skbuff.h:2264 [inline]
RIP: 0010:__skb_queue_tail include/linux/skbuff.h:2297 [inline]
RIP: 0010:skb_queue_tail+0x9e/0x140 net/core/skbuff.c:3402
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 80 00 00 00 4c 89 e2 4c 89 65 08 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 48 89 6b 08 <80> 3c 02 00 75 4f 48 8d 7b 10 49 89 2c 24 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc900000079c0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff888070c23890 RCX: ffffffff815ffdc0
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff888070c30a08
RBP: ffff888070c30a00 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000000f26 R11: 000000000008c07e R12: 0000000000000000
R13: ffff888070c238a8 R14: 00000000ffff9c2b R15: ffffffff85186a70
FS:  000055555691a300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5ac5d382e8 CR3: 00000000775ec000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 ath9k_htc_txep+0x287/0x400 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:712
 ath9k_htc_txcompletion_cb+0x1cd/0x2e0 drivers/net/wireless/ath/ath9k/htc_hst.c:353
 hif_usb_regout_cb+0x115/0x1c0 drivers/net/wireless/ath/ath9k/hif_usb.c:90
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1671
 usb_hcd_giveback_urb+0x380/0x430 drivers/usb/core/hcd.c:1754
 dummy_timer+0x11ff/0x32c0 drivers/usb/gadget/udc/dummy_hcd.c:1988
 call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1474
 expire_timers kernel/time/timer.c:1519 [inline]
 __run_timers.part.0+0x6a2/0xaf0 kernel/time/timer.c:1790
 __run_timers kernel/time/timer.c:1768 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
 __do_softirq+0x1f7/0xad8 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x16/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x25/0x40 kernel/locking/spinlock.c:202
Code: 0f 1f 44 00 00 55 48 8b 74 24 08 48 89 fd 48 83 c7 18 e8 ee c3 cf f7 48 89 ef e8 36 30 d0 f7 e8 81 46 f3 f7 fb bf 01 00 00 00 <e8> b6 bb c2 f7 65 8b 05 9f 9e 72 76 85 c0 74 02 5d c3 e8 ce a6 70
RSP: 0018:ffffc90003d0fdc0 EFLAGS: 00000246
RAX: 0000000000000007 RBX: ffff8880738f9d40 RCX: 1ffffffff1bc50b4
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000001
RBP: ffff88807aec5c80 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed100f5d8b90 R11: 0000000000000001 R12: 0000000000000004
R13: 0000000008000000 R14: 0000000000000000 R15: ffff8880738fa2a0
 spin_unlock_irq include/linux/spinlock.h:400 [inline]
 ptrace_stop.part.0+0x2f1/0x8c0 kernel/signal.c:2281
 ptrace_stop kernel/signal.c:2233 [inline]
 ptrace_do_notify+0x215/0x2b0 kernel/signal.c:2345
 ptrace_notify+0xc4/0x140 kernel/signal.c:2357
 ptrace_report_syscall include/linux/ptrace.h:420 [inline]
 ptrace_report_syscall_entry include/linux/ptrace.h:457 [inline]
 syscall_trace_enter.constprop.0+0xb0/0x250 kernel/entry/common.c:65
 do_syscall_64+0x16/0xb0 arch/x86/entry/common.c:76
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5ac5d6dc1b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 03 fd ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 41 fd ff ff 8b 44
RSP: 002b:00007ffeb5f65d90 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 000000000000001d RCX: 00007f5ac5d6dc1b
RDX: ffffffffffffffb8 RSI: 0000000000000000 RDI: 000000000000001c
RBP: 000000000000015e R08: 0000000000000000 R09: 00007ffeb5f65de0
R10: 0000000000000000 R11: 0000000000000293 R12: 00007f5ac5e3649c
R13: 000000000000b212 R14: 00007f5ac5e36480 R15: 0000000000000004
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__skb_insert include/linux/skbuff.h:2158 [inline]
RIP: 0010:__skb_queue_before include/linux/skbuff.h:2264 [inline]
RIP: 0010:__skb_queue_tail include/linux/skbuff.h:2297 [inline]
RIP: 0010:skb_queue_tail+0x9e/0x140 net/core/skbuff.c:3402
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 80 00 00 00 4c 89 e2 4c 89 65 08 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 48 89 6b 08 <80> 3c 02 00 75 4f 48 8d 7b 10 49 89 2c 24 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc900000079c0 EFLAGS: 00010046
RAX: dffffc0000000000 RBX: ffff888070c23890 RCX: ffffffff815ffdc0
RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff888070c30a08
RBP: ffff888070c30a00 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52000000f26 R11: 000000000008c07e R12: 0000000000000000
R13: ffff888070c238a8 R14: 00000000ffff9c2b R15: ffffffff85186a70
FS:  000055555691a300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5ac5d382e8 CR3: 00000000775ec000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	48 c1 ea 03          	shr    $0x3,%rdx
   7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   b:	0f 85 80 00 00 00    	jne    0x91
  11:	4c 89 e2             	mov    %r12,%rdx
  14:	4c 89 65 08          	mov    %r12,0x8(%rbp)
  18:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1f:	fc ff df
  22:	48 c1 ea 03          	shr    $0x3,%rdx
  26:	48 89 6b 08          	mov    %rbp,0x8(%rbx)
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	75 4f                	jne    0x7f
  30:	48 8d 7b 10          	lea    0x10(%rbx),%rdi
  34:	49 89 2c 24          	mov    %rbp,(%r12)
  38:	48                   	rex.W
  39:	b8 00 00 00 00       	mov    $0x0,%eax
  3e:	00 fc                	add    %bh,%ah


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
