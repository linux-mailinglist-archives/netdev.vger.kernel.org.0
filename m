Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9B44A7E5E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 04:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349201AbiBCDgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 22:36:22 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:37473 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbiBCDgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 22:36:21 -0500
Received: by mail-il1-f200.google.com with SMTP id 20-20020a056e020cb400b002b93016fbccso899797ilg.4
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 19:36:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7x6rKhaHmrAEYlIz/NCtXjuxWLWqRjW+skTvrls9++k=;
        b=pMJ34PaRKF0OYj6BbUrTH6dPgcEheieH4dNDUOpacGHYHzj/NEymW5l8RzxpGe3Qxf
         2OVAJmi7P6DMnExonXTZyt6rqtQNvIiyDR2kzgYmxDMdNX2f2BerzyGx4U4T6+gGaY9W
         cIwzcHFfKzhKfyr1/97San4vgFdH40O2BVDQliv055yAbJPuBFbBJmJynSzAk7SNs2cS
         uVOTizGZfcPQ+CXZk+cLc7pMgk6AvqmkfGv73J0HjKmtE4senHL6Ltr31RcSThZ/f63V
         xhb+FSTYa7uI2FDWolA8Sjc6KBPL/+TcPSIh7dPI6IKHmNY0ENaDoak/KKeiQCbRzAs3
         cLDA==
X-Gm-Message-State: AOAM5317ESjHbR3BViRtINPTTgMQUa5FIX99DC1iyIlLZFGdjh9SmH6H
        rYt9TTHgAN+8PPhPzN2RMRinY0FO3CgOpnfeof7yhSekAd9n
X-Google-Smtp-Source: ABdhPJzZj1jMw6FAE6SvyayY5zdvayzSv5dg6luJoFgPyYb9thhsd7mbyIirTGhOCU69O6NNT0jIFBW7XgAFoaYYGIIlhZ5vZDyD
MIME-Version: 1.0
X-Received: by 2002:a02:711e:: with SMTP id n30mr16461827jac.235.1643859381164;
 Wed, 02 Feb 2022 19:36:21 -0800 (PST)
Date:   Wed, 02 Feb 2022 19:36:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000079a24b05d714d69f@google.com>
Subject: [syzbot] general protection fault in btf_decl_tag_resolve
From:   syzbot <syzbot+53619be9444215e785ed@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b7892f7d5cb2 tools: Ignore errors from `which' when search..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=13181634700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5044676c290190f2
dashboard link: https://syzkaller.appspot.com/bug?extid=53619be9444215e785ed
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16454914700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ceb884700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53619be9444215e785ed@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 3592 Comm: syz-executor914 Not tainted 5.16.0-syzkaller-11424-gb7892f7d5cb2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:btf_type_vlen include/linux/btf.h:231 [inline]
RIP: 0010:btf_decl_tag_resolve+0x83e/0xaa0 kernel/bpf/btf.c:3910
Code: c1 ea 03 80 3c 02 00 0f 85 90 01 00 00 48 8b 1b e8 b7 c9 e6 ff 48 8d 7b 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2b
RSP: 0018:ffffc90001b1fa00 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81918c09 RDI: 0000000000000004
RBP: ffff888015c32000 R08: 0000000000000008 R09: 0000000000000008
R10: ffffffff81918bb1 R11: 0000000000000001 R12: 0000000000000004
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000005
FS:  00005555556fd300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f98c38b8220 CR3: 0000000019537000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btf_resolve+0x251/0x1020 kernel/bpf/btf.c:4198
 btf_check_all_types kernel/bpf/btf.c:4239 [inline]
 btf_parse_type_sec kernel/bpf/btf.c:4280 [inline]
 btf_parse kernel/bpf/btf.c:4513 [inline]
 btf_new_fd+0x19fe/0x2370 kernel/bpf/btf.c:6047
 bpf_btf_load kernel/bpf/syscall.c:4039 [inline]
 __sys_bpf+0x1cbb/0x5970 kernel/bpf/syscall.c:4679
 __do_sys_bpf kernel/bpf/syscall.c:4738 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4736 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4736
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd57f202099
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9e5eb898 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd57f202099
RDX: 0000000000000020 RSI: 0000000020000000 RDI: 0000000000000012
RBP: 00007fd57f1c6080 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fd57f1c6110
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btf_type_vlen include/linux/btf.h:231 [inline]
RIP: 0010:btf_decl_tag_resolve+0x83e/0xaa0 kernel/bpf/btf.c:3910
Code: c1 ea 03 80 3c 02 00 0f 85 90 01 00 00 48 8b 1b e8 b7 c9 e6 ff 48 8d 7b 04 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 2b
RSP: 0018:ffffc90001b1fa00 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81918c09 RDI: 0000000000000004
RBP: ffff888015c32000 R08: 0000000000000008 R09: 0000000000000008
R10: ffffffff81918bb1 R11: 0000000000000001 R12: 0000000000000004
R13: 0000000000000008 R14: 0000000000000000 R15: 0000000000000005
FS:  00005555556fd300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 0000000019537000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	c1 ea 03             	shr    $0x3,%edx
   3:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   7:	0f 85 90 01 00 00    	jne    0x19d
   d:	48 8b 1b             	mov    (%rbx),%rbx
  10:	e8 b7 c9 e6 ff       	callq  0xffe6c9cc
  15:	48 8d 7b 04          	lea    0x4(%rbx),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
  2e:	48 89 f8             	mov    %rdi,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 03             	add    $0x3,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85 2b                	test   %ebp,(%rbx)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
