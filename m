Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CCC6C77A9
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 07:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCXGLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 02:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjCXGLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 02:11:48 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8089B28D0A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 23:11:46 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id d12-20020a056e020bec00b00325e125fbe5so110977ilu.12
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 23:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679638306;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5EazmNoR1OZ8o2+YMKLz7ea0FZT1O49LxZhIVVOGASU=;
        b=ixDwRuApS+G1IIKD8Xv4lsAeUjQYJJSfRB9/vaa7bT8HoZz4SlBpwgMCH6aa1ctjG2
         RbPct7SDJCIF6ikp/rGwWuQYwgVDWNaRglhNfEHFyaJvecJlmVmSaubw9cepF3WarlbS
         jWWhNKPbW+orDn92KdJpQ+PzMrmlhADCx+s6TIjWbZI+HRA/Z/XPk+ENis1JjM2fjRH1
         ORanaclYb8JiBcdvVxe4EhwHWVmS1nt0xe2NdVcWCxAk9me5F9l4XmwFaV9G7Hf3W91/
         51dNQ4/i28VDvOJerL2zK+qCvAUg2nIflS9I/XzKp3lKmpSrjwma/cVMd4eFrW+OwSmY
         OGVA==
X-Gm-Message-State: AO0yUKX1qffPL88od/iVgDP+dsWjj+vVybcpwBtRM1Zsr1v9pePm/mD9
        qWsgX8nKltb/St2N+fskE2Jq3DQ8Wst6AmztAcdVIbZW72KO
X-Google-Smtp-Source: AK7set+//66vpydVGOj72rdCt3BRmCaHG0x83OrdHCybr9gyo5Im+LelP6LCqnOTCELfnC83HNox1AjctyxVmZg345qUV5gKqQF/
MIME-Version: 1.0
X-Received: by 2002:a6b:500e:0:b0:751:96ce:ed7d with SMTP id
 e14-20020a6b500e000000b0075196ceed7dmr4707751iob.1.1679638305809; Thu, 23 Mar
 2023 23:11:45 -0700 (PDT)
Date:   Thu, 23 Mar 2023 23:11:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000091ae5305f79f447f@google.com>
Subject: [syzbot] [bpf?] [net?] general protection fault in bpf_struct_ops_link_create
From:   syzbot <syzbot+71ccc0fe37abb458406b@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, haoluo@google.com, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, kuifeng@meta.com,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, sdf@google.com,
        song@kernel.org, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    226bc6ae6405 Merge branch 'Transit between BPF TCP congest..
git tree:       bpf-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=139c727ac80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cab35c936731a347
dashboard link: https://syzkaller.appspot.com/bug?extid=71ccc0fe37abb458406b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ef67a1c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119c20fec80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ac055f681ed7/disk-226bc6ae.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3895cc8a51d2/vmlinux-226bc6ae.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1b18bb9fae05/bzImage-226bc6ae.xz

The issue was bisected to:

commit 68b04864ca425d1894c96b8141d4fba1181f11cb
Author: Kui-Feng Lee <kuifeng@meta.com>
Date:   Thu Mar 23 03:24:00 2023 +0000

    bpf: Create links for BPF struct_ops maps.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=116731b1c80000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=136731b1c80000
console output: https://syzkaller.appspot.com/x/log.txt?x=156731b1c80000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+71ccc0fe37abb458406b@syzkaller.appspotmail.com
Fixes: 68b04864ca42 ("bpf: Create links for BPF struct_ops maps.")

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 5081 Comm: syz-executor182 Not tainted 6.2.0-syzkaller-13084-g226bc6ae6405 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
RIP: 0010:bpf_struct_ops_valid_to_reg kernel/bpf/bpf_struct_ops.c:764 [inline]
RIP: 0010:bpf_struct_ops_link_create+0xb1/0x390 kernel/bpf/bpf_struct_ops.c:879
Code: 95 81 eb ff 48 85 c0 48 89 c5 0f 84 9e 02 00 00 e8 24 27 dd ff 48 8d 7d 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 60 02 00 00 44 8b 65 18 bf 1a
RSP: 0018:ffffc90003b8fc38 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 1ffff92000771f87 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff81a7dc8c RDI: 000000000000000f
RBP: fffffffffffffff7 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: 000000000000002c R14: ffffc90003b8fde8 R15: 0000000000000000
FS:  0000555556538300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000eaa388 CR3: 00000000206d2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 link_create kernel/bpf/syscall.c:4585 [inline]
 __sys_bpf+0x3b77/0x53b0 kernel/bpf/syscall.c:5129
 __do_sys_bpf kernel/bpf/syscall.c:5163 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5161 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5161
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc374490ae9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffe2184578 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc374490ae9
RDX: 0000000000000010 RSI: 0000000020001340 RDI: 000000000000001c
RBP: 00007fc374454c90 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fc374454d20
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bpf_struct_ops_valid_to_reg kernel/bpf/bpf_struct_ops.c:764 [inline]
RIP: 0010:bpf_struct_ops_link_create+0xb1/0x390 kernel/bpf/bpf_struct_ops.c:879
Code: 95 81 eb ff 48 85 c0 48 89 c5 0f 84 9e 02 00 00 e8 24 27 dd ff 48 8d 7d 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 60 02 00 00 44 8b 65 18 bf 1a
RSP: 0018:ffffc90003b8fc38 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 1ffff92000771f87 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff81a7dc8c RDI: 000000000000000f
RBP: fffffffffffffff7 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: 000000000000002c R14: ffffc90003b8fde8 R15: 0000000000000000
FS:  0000555556538300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000eaa388 CR3: 00000000206d2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	95                   	xchg   %eax,%ebp
   1:	81 eb ff 48 85 c0    	sub    $0xc08548ff,%ebx
   7:	48 89 c5             	mov    %rax,%rbp
   a:	0f 84 9e 02 00 00    	je     0x2ae
  10:	e8 24 27 dd ff       	callq  0xffdd2739
  15:	48 8d 7d 18          	lea    0x18(%rbp),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e 60 02 00 00    	jle    0x29a
  3a:	44 8b 65 18          	mov    0x18(%rbp),%r12d
  3e:	bf                   	.byte 0xbf
  3f:	1a                   	.byte 0x1a


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
