Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6EC6BAFC8
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjCOMDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjCOMDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:03:51 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C186273F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:03:48 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id b3-20020a056e02048300b003230de63373so4327959ils.10
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 05:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678881827;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hejewajGFjy6EBNb8zTRittD+AmYVJz2CBQOmsFa9is=;
        b=dU/TjVWSkSlhPpyTQ8RzLTcuBixiFdq/JulyrLkyVw6sCG2yEJbwARmBog18lJVbsa
         MG5ygRtRC+4pDfc4+cZXM7TfoV5vMGVw0Lb7xFjHgT3K31h/1i3PN5dtWKFGsrARVij2
         kKLT5maR0uIBIqk9j+G0VTxgj/zLdVMGuheg65wHe+LE/ieHtG5c9CyvhGUTsUFNNvvt
         qzWIVPtcbo3ucWL2YDqcG9BRmPrULeB/zVIdMrAkhhRbBeU65mM610b7KNTI7EqtISPE
         azR1qynGnWw1x6NWbedbHZjZ469kasBa72fsg/XrZYjfjoy7ugK7BQCkdZdQl8Stw+3H
         pJ/w==
X-Gm-Message-State: AO0yUKXqvSDR930iUkKVVCFUZa6SxaOoLQ1Ylh0e/ell0lsTvASXhmao
        gWMbumQTJoGjB6U5JqWtn6pT4v+zuftTxMW2xNDjG1ol99aM
X-Google-Smtp-Source: AK7set9ra0yby39E21P5T7E7yeYm5bUxITnHHBHQiX/V7IlAKNpWZ2DJK5AGqJsPYGGOvXLbqd9rtRf13EFVJTPB1oTEtxArUzhg
MIME-Version: 1.0
X-Received: by 2002:a02:634e:0:b0:3ec:dc1f:12dd with SMTP id
 j75-20020a02634e000000b003ecdc1f12ddmr20130386jac.6.1678881827426; Wed, 15
 Mar 2023 05:03:47 -0700 (PDT)
Date:   Wed, 15 Mar 2023 05:03:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1985705f6ef2243@google.com>
Subject: [syzbot] [bpf?] [net?] BUG: unable to handle kernel NULL pointer
 dereference in __build_skb_around
From:   syzbot <syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com>
To:     aleksander.lobakin@intel.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    3c2611bac08a selftests/bpf: Fix trace_virtqueue_add_sgs te..
git tree:       bpf-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1026d472c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
dashboard link: https://syzkaller.appspot.com/bug?extid=e1d1b65f7c32f2a86a9f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15826bc6c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15cd12e2c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/36a32f4d222a/disk-3c2611ba.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f5c0da04f143/vmlinux-3c2611ba.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ae2ca9bce51a/bzImage-3c2611ba.xz

The issue was bisected to:

commit 9c94bbf9a87b264294f42e6cc0f76d87854733ec
Author: Alexander Lobakin <aleksander.lobakin@intel.com>
Date:   Mon Mar 13 21:55:52 2023 +0000

    xdp: recycle Page Pool backed skbs built from XDP frames

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11deec2ac80000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13deec2ac80000
console output: https://syzkaller.appspot.com/x/log.txt?x=15deec2ac80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com
Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from XDP frames")

BUG: kernel NULL pointer dereference, address: 0000000000000d28
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 7b741067 P4D 7b741067 PUD 7c1ca067 PMD 0 
Oops: 0002 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5080 Comm: syz-executor371 Not tainted 6.2.0-syzkaller-13030-g3c2611bac08a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
Code: 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f 00 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f
RSP: 0018:ffffc90003baf730 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888028b94000 RCX: 0000000000000020
RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000d28
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000d28
R10: ffffed100517281c R11: 0000000000094001 R12: 0000000000000d48
R13: 0000000000000d28 R14: 0000000000000f68 R15: 0000000000000100
FS:  0000555555979300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000d28 CR3: 0000000028e2d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __finalize_skb_around net/core/skbuff.c:321 [inline]
 __build_skb_around+0x232/0x3a0 net/core/skbuff.c:379
 build_skb_around+0x32/0x290 net/core/skbuff.c:444
 __xdp_build_skb_from_frame+0x121/0x760 net/core/xdp.c:622
 xdp_recv_frames net/bpf/test_run.c:248 [inline]
 xdp_test_run_batch net/bpf/test_run.c:334 [inline]
 bpf_test_run_xdp_live+0x1289/0x1930 net/bpf/test_run.c:362
 bpf_prog_test_run_xdp+0xa05/0x14e0 net/bpf/test_run.c:1418
 bpf_prog_test_run kernel/bpf/syscall.c:3675 [inline]
 __sys_bpf+0x1598/0x5100 kernel/bpf/syscall.c:5028
 __do_sys_bpf kernel/bpf/syscall.c:5114 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5112 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5112
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f320b4efca9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd2c9924d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f320b4efca9
RDX: 0000000000000048 RSI: 0000000020000080 RDI: 000000000000000a
RBP: 00007f320b4b3e50 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f320b4b3ee0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
CR2: 0000000000000d28
---[ end trace 0000000000000000 ]---
RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
Code: 01 48 0f af c6 f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f 00 49 89 f9 40 88 f0 48 89 d1 <f3> aa 4c 89 c8 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f
RSP: 0018:ffffc90003baf730 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888028b94000 RCX: 0000000000000020
RDX: 0000000000000020 RSI: 0000000000000000 RDI: 0000000000000d28
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000d28
R10: ffffed100517281c R11: 0000000000094001 R12: 0000000000000d48
R13: 0000000000000d28 R14: 0000000000000f68 R15: 0000000000000100
FS:  0000555555979300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000d28 CR3: 0000000028e2d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	48 0f af c6          	imul   %rsi,%rax
   4:	f3 48 ab             	rep stos %rax,%es:(%rdi)
   7:	89 d1                	mov    %edx,%ecx
   9:	f3 aa                	rep stos %al,%es:(%rdi)
   b:	4c 89 c8             	mov    %r9,%rax
   e:	c3                   	retq
   f:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  16:	00 00 00 00
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 0f 1f 00          	nopw   (%rax)
  20:	49 89 f9             	mov    %rdi,%r9
  23:	40 88 f0             	mov    %sil,%al
  26:	48 89 d1             	mov    %rdx,%rcx
* 29:	f3 aa                	rep stos %al,%es:(%rdi) <-- trapping instruction
  2b:	4c 89 c8             	mov    %r9,%rax
  2e:	c3                   	retq
  2f:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  36:	00 00 00 00
  3a:	66 90                	xchg   %ax,%ax
  3c:	66                   	data16
  3d:	0f                   	.byte 0xf
  3e:	1f                   	(bad)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
