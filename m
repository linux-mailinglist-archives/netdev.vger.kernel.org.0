Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D7365C780
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 20:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbjACT1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 14:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239102AbjACT0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 14:26:05 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D591583E
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 11:24:38 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id c11-20020a056e020bcb00b0030be9d07d63so17976537ilu.0
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 11:24:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v+2AjUcsc0OYCtIFl34Tn6lgJi8EhFx8zXDoCwBqQds=;
        b=0P1R7fjeWyQ2KlECGVl0oDekOrGkcKCdHwIF+eDLtskn81FPcQhN0eSEAexqQYtmKq
         QH/m+nEuFGPiTP8OBgR0Rs5kRZX8YdkCeflt5hSEnhyNrOR62n4O0dHzr/srIHObIJyx
         3b/5eWfHRNake9+yg3sfIvQhpI++ZUzUn6056vE1LFjZvkAxk97E2CC9T3e9+vjc2j6l
         TWeqr61U72y5M33KbB1Gpn6jxODObT7YeVWLpFTZQnSwrpQBgycdZRMwOJKLcUI7OX02
         KucwrI+smcj80V+ycZ+S4/uTg/UF28kasFvk6Sw/lCc6BP/WF/f6+vV7AtD8XV3N2UHf
         qbEQ==
X-Gm-Message-State: AFqh2koT6qFUTZV9KUHreXw6yqC57K4v8K7hc4t9BovRjhv93QRQK4UG
        pM+IORTNDQ0TYeybgxievcSI9v2Dn5eJuLWjCTAni80wv9fI
X-Google-Smtp-Source: AMrXdXu4Y0W1gdLk3oxa/oFwE94zA7vHb0goFskOit3ICPBBHxqWJuc5BSSwEzmqJEEGV4SgAb+QcH20SDfYkAx3ONhN0Ho5Lv1q
MIME-Version: 1.0
X-Received: by 2002:a5d:9f56:0:b0:6de:383e:4146 with SMTP id
 u22-20020a5d9f56000000b006de383e4146mr2372259iot.48.1672773877811; Tue, 03
 Jan 2023 11:24:37 -0800 (PST)
Date:   Tue, 03 Jan 2023 11:24:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c6d3dc05f16104a1@google.com>
Subject: [syzbot] kernel BUG in inet_sock_destruct
From:   syzbot <syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
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

HEAD commit:    d039535850ee net: phy: xgmiitorgmii: Fix refcount leak in ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=10985f5c480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8ca07260bb631fb4
dashboard link: https://syzkaller.appspot.com/bug?extid=bebc6f1acdf4cbb79b03
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=169b492a480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10eab934480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/083b3aeb8e8a/disk-d0395358.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eeb552a151bd/vmlinux-d0395358.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4ea1ac5916aa/bzImage-d0395358.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com

 kfree_skb include/linux/skbuff.h:1218 [inline]
 __skb_queue_purge include/linux/skbuff.h:3112 [inline]
 inet_sock_destruct+0x10f/0x890 net/ipv4/af_inet.c:136
 __sk_destruct+0x4d/0x750 net/core/sock.c:2133
 rcu_do_batch kernel/rcu/tree.c:2246 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2506
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571
------------[ cut here ]------------
kernel BUG at include/linux/mm.h:760!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5072 Comm: syz-executor406 Not tainted 6.1.0-syzkaller-04343-gd039535850ee #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:put_page_testzero include/linux/mm.h:760 [inline]
RIP: 0010:folio_put_testzero include/linux/mm.h:766 [inline]
RIP: 0010:folio_put include/linux/mm.h:1249 [inline]
RIP: 0010:put_page include/linux/mm.h:1319 [inline]
RIP: 0010:__skb_frag_unref include/linux/skbuff.h:3388 [inline]
RIP: 0010:skb_release_data+0x73c/0x870 net/core/skbuff.c:845
Code: fd ff ff e8 b6 42 bf f9 48 8b 6c 24 10 48 83 ed 01 e9 62 fd ff ff e8 a3 42 bf f9 48 c7 c6 20 e0 5a 8b 48 89 ef e8 54 ed f6 f9 <0f> 0b 4c 89 e7 e8 ea 43 0d fa e9 29 f9 ff ff 48 8b 7c 24 08 e8 3b
RSP: 0018:ffffc900001e0d30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88807d4adb40 RCX: 0000000000000100
RDX: ffff888021990000 RSI: ffffffff87c20f4c RDI: 0000000000000000
RBP: ffffea0000810600 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffffea0000810634
R13: ffff88807023b4f0 R14: 0000000000000000 R15: dffffc0000000000
FS:  00005555568ca300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feda96e73a0 CR3: 00000000205ab000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 skb_release_all net/core/skbuff.c:916 [inline]
 __kfree_skb net/core/skbuff.c:930 [inline]
 kfree_skb_reason+0x1ab/0x4f0 net/core/skbuff.c:956
 kfree_skb include/linux/skbuff.h:1218 [inline]
 __skb_queue_purge include/linux/skbuff.h:3112 [inline]
 inet_sock_destruct+0x10f/0x890 net/ipv4/af_inet.c:136
 __sk_destruct+0x4d/0x750 net/core/sock.c:2133
 rcu_do_batch kernel/rcu/tree.c:2246 [inline]
 rcu_core+0x81f/0x1980 kernel/rcu/tree.c:2506
 __do_softirq+0x1fb/0xadc kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
 sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x3c/0x70 kernel/locking/spinlock.c:194
Code: 74 24 10 e8 46 e6 5a f7 48 89 ef e8 ee 52 5b f7 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> 2f b6 4d f7 65 8b 05 e0 a2 fa 75 85 c0 74 0a 5b 5d c3 e8 ec ca
RSP: 0018:ffffc90003adfc78 EFLAGS: 00000206
RAX: 0000000000000006 RBX: 0000000000000200 RCX: 1ffffffff1ce5581
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff888020b921e0 R08: 0000000000000001 R09: 0000000000000001
R10: ffffed100417243c R11: 0000000000000000 R12: dffffc0000000000
R13: 00007ffea9da3db4 R14: 0000000000000004 R15: 0000000000000000
 do_wait+0x17f/0xd70 kernel/exit.c:1579
 kernel_wait4+0x150/0x260 kernel/exit.c:1766
 __do_sys_wait4+0x13f/0x150 kernel/exit.c:1794
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7feda969c0e6
Code: 0f 1f 40 00 31 c9 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 11 b8 3d 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5a c3 90 48 83 ec 28 89 54 24 14 48 89 74 24
RSP: 002b:00007ffea9da3da8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 00007ffea9da3dd0 RCX: 00007feda969c0e6
RDX: 0000000040000001 RSI: 00007ffea9da3db4 RDI: 00000000ffffffff
RBP: 000000000000032b R08: 0000000000000070 R09: 00007ffea9dee080
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffea9da3dc0
R13: 00000000000f4240 R14: 000000000001b5dc R15: 00007ffea9da3db4
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:put_page_testzero include/linux/mm.h:760 [inline]
RIP: 0010:folio_put_testzero include/linux/mm.h:766 [inline]
RIP: 0010:folio_put include/linux/mm.h:1249 [inline]
RIP: 0010:put_page include/linux/mm.h:1319 [inline]
RIP: 0010:__skb_frag_unref include/linux/skbuff.h:3388 [inline]
RIP: 0010:skb_release_data+0x73c/0x870 net/core/skbuff.c:845
Code: fd ff ff e8 b6 42 bf f9 48 8b 6c 24 10 48 83 ed 01 e9 62 fd ff ff e8 a3 42 bf f9 48 c7 c6 20 e0 5a 8b 48 89 ef e8 54 ed f6 f9 <0f> 0b 4c 89 e7 e8 ea 43 0d fa e9 29 f9 ff ff 48 8b 7c 24 08 e8 3b
RSP: 0018:ffffc900001e0d30 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88807d4adb40 RCX: 0000000000000100
RDX: ffff888021990000 RSI: ffffffff87c20f4c RDI: 0000000000000000
RBP: ffffea0000810600 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffffea0000810634
R13: ffff88807023b4f0 R14: 0000000000000000 R15: dffffc0000000000
FS:  00005555568ca300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feda96e73a0 CR3: 00000000205ab000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	74 24                	je     0x26
   2:	10 e8                	adc    %ch,%al
   4:	46 e6 5a             	rex.RX out %al,$0x5a
   7:	f7 48 89 ef e8 ee 52 	testl  $0x52eee8ef,-0x77(%rax)
   e:	5b                   	pop    %rbx
   f:	f7 81 e3 00 02 00 00 	testl  $0x9c257500,0x200e3(%rcx)
  16:	75 25 9c
  19:	58                   	pop    %rax
  1a:	f6 c4 02             	test   $0x2,%ah
  1d:	75 2d                	jne    0x4c
  1f:	48 85 db             	test   %rbx,%rbx
  22:	74 01                	je     0x25
  24:	fb                   	sti
  25:	bf 01 00 00 00       	mov    $0x1,%edi
* 2a:	e8 2f b6 4d f7       	callq  0xf74db65e <-- trapping instruction
  2f:	65 8b 05 e0 a2 fa 75 	mov    %gs:0x75faa2e0(%rip),%eax        # 0x75faa316
  36:	85 c0                	test   %eax,%eax
  38:	74 0a                	je     0x44
  3a:	5b                   	pop    %rbx
  3b:	5d                   	pop    %rbp
  3c:	c3                   	retq
  3d:	e8                   	.byte 0xe8
  3e:	ec                   	in     (%dx),%al
  3f:	ca                   	.byte 0xca


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
