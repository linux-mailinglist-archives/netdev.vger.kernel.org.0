Return-Path: <netdev+bounces-10063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EECEA72BCE8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CF471C20A35
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD1A18AE4;
	Mon, 12 Jun 2023 09:42:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA27182C6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:42:03 +0000 (UTC)
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EB01BC1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:42:00 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-777b8c9cc4aso410222139f.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686562919; x=1689154919;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dsn+rq0YgD/MhWZRG1lL1JZ3+JVvPpgWe+R2EIhk79k=;
        b=kU+vROK87JobUmqwBeZ8SFoUKp873l/3l2K4QxabpvtVyy34k7gULsZeDZ10ttF6TC
         QOecwBYnj2P+IW4ovl/tCyzXUoXF+FcbxdkeGZJFAYWvD2S5LZWrb82E3Sv4bQUx5cFX
         bU7YgWprXu1eM8L5IShfffe2xjgjpMcsbDXdjFttKkN2KjhDqUPZSaUTHz9cHqoZsQvA
         58stLq5/nVNqG6mOiPsgTPSEQ0J7iwUnPESdQPNIl1sE0XHFWoFYWE3skCFxawVi8mqG
         qegtLz/m8fC4DvMr9vQkzs+QcKUdasV+fMSQb6yV7u76sbT/qJsiOJC1CA225hkS1Q9X
         yJsw==
X-Gm-Message-State: AC+VfDxmvxie0Nkw60u2yTkY/AJEZBd2VBbMascJlDjFi7d0+ejHBksz
	tzQsVDUJP7BsWMN1Hd9aZJTP3leCdM+TLq62dNfAV8wLxGd1
X-Google-Smtp-Source: ACHHUZ4Yk6Kqc2WpfyyutzWjUTL4vIa/xgm6PD86LXR5pkFtyfysx/BsyGBQkhXmJq+6tF9WLhp5ZR2Pfkp9Eg4RYScGNfLcoEAi
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:62c7:0:b0:41a:c455:f4c8 with SMTP id
 d190-20020a0262c7000000b0041ac455f4c8mr1470461jac.3.1686562919752; Mon, 12
 Jun 2023 02:41:59 -0700 (PDT)
Date: Mon, 12 Jun 2023 02:41:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b928f705fdeb873a@google.com>
Subject: [syzbot] [crypto?] general protection fault in shash_async_final
From: syzbot <syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com>
To: davem@davemloft.net, dhowells@redhat.com, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    37ff78e977f1 mlxsw: spectrum_nve_vxlan: Fix unsupported fl..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13b26ef1280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=13a08c0bf4d212766c3c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165dc395280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f9172b280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/41e829152d3c/disk-37ff78e9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a594b97acb02/vmlinux-37ff78e9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b41140b53372/bzImage-37ff78e9.xz

The issue was bisected to:

commit c662b043cdca89bf0f03fc37251000ac69a3a548
Author: David Howells <dhowells@redhat.com>
Date:   Tue Jun 6 13:08:56 2023 +0000

    crypto: af_alg/hash: Support MSG_SPLICE_PAGES

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14a2def1280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16a2def1280000
console output: https://syzkaller.appspot.com/x/log.txt?x=12a2def1280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 5003 Comm: syz-executor289 Not tainted 6.4.0-rc5-syzkaller-00859-g37ff78e977f1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_final crypto/shash.c:171 [inline]
RIP: 0010:shash_async_final+0x6d/0x150 crypto/shash.c:319
Code: 4c 89 e2 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 50 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc900039af8f8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df3032 RDI: 0000000000000020
RBP: 0000000000000010 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000655 R12: ffff88801f6c0af8
R13: 0000000000000010 R14: ffff888015fd1000 R15: ffff88801f6c0a38
FS:  00005555561eb300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000107b3a8 CR3: 0000000078da9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 crypto_ahash_op crypto/ahash.c:303 [inline]
 crypto_ahash_op crypto/ahash.c:292 [inline]
 crypto_ahash_final+0xed/0x1e0 crypto/ahash.c:316
 hash_recvmsg+0x2c6/0xa80 crypto/algif_hash.c:248
 hash_recvmsg_nokey+0x69/0x90 crypto/algif_hash.c:404
 sock_recvmsg_nosec net/socket.c:1019 [inline]
 sock_recvmsg+0xe2/0x160 net/socket.c:1040
 ____sys_recvmsg+0x210/0x5a0 net/socket.c:2724
 ___sys_recvmsg+0xf2/0x180 net/socket.c:2766
 do_recvmmsg+0x25e/0x6f0 net/socket.c:2860
 __sys_recvmmsg net/socket.c:2939 [inline]
 __do_sys_recvmmsg net/socket.c:2962 [inline]
 __se_sys_recvmmsg net/socket.c:2955 [inline]
 __x64_sys_recvmmsg+0x20f/0x260 net/socket.c:2955
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f030b570c49
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd507d5968 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f030b570c49
RDX: 000000000000049f RSI: 0000000020006100 RDI: 0000000000000004
RBP: 00007f030b534df0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f030b534e80
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_final crypto/shash.c:171 [inline]
RIP: 0010:shash_async_final+0x6d/0x150 crypto/shash.c:319
Code: 4c 89 e2 48 c1 ea 03 80 3c 02 00 0f 85 d5 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 50 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b
RSP: 0018:ffffc900039af8f8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df3032 RDI: 0000000000000020
RBP: 0000000000000010 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000655 R12: ffff88801f6c0af8
R13: 0000000000000010 R14: ffff888015fd1000 R15: ffff88801f6c0a38
FS:  00005555561eb300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000107b3a8 CR3: 0000000078da9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	4c 89 e2             	mov    %r12,%rdx
   3:	48 c1 ea 03          	shr    $0x3,%rdx
   7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   b:	0f 85 d5 00 00 00    	jne    0xe6
  11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  18:	fc ff df
  1b:	48 8b 5b 50          	mov    0x50(%rbx),%rbx
  1f:	48 8d 7b 20          	lea    0x20(%rbx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 a8 00 00 00    	jne    0xdc
  34:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  3b:	fc ff df
  3e:	48                   	rex.W
  3f:	8b                   	.byte 0x8b


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

