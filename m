Return-Path: <netdev+bounces-12014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49637735AE4
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 807F2280F83
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5AA12B6B;
	Mon, 19 Jun 2023 15:13:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7D0D2F8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 15:13:10 +0000 (UTC)
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9416C2
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:13:05 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-77e4a12650cso18353039f.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687187585; x=1689779585;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NtllAkZ32Xdq4j14poacviPx+rBPNHY5U0EDj1En0pE=;
        b=WCWWw/4pjQ683wfOZ5bi6U6qg2n9/0spFkBuh0snwv6qiFqea4kkGHz5uZBtXdl9HF
         LV+0eLTj05Gb8PiZEycJvwwYqyPJij5DgOjWxjdMpqZ76RmIP9cWfrkFpG6IVoPSTn6O
         h3C8SMfK6X0M3O1YKfZza06xStVBbsiFJ1TriMXK5/UvFZhAO73ZIxLsTHvIlQhVOZgb
         93jnxkgugvxMWiD8sQXY2ogcRa13uTvIsV7xv0VPHvTJF91gEWgGEX3TfPkI6RnGPGu3
         yRFiOed5kCngnfa18awtX5puq/UTTaasHxuCasaLmzJDQes1KF+2wlw1IgFqJZccw8Xx
         UV8Q==
X-Gm-Message-State: AC+VfDwBu580wYmDRLU8wLuYLqxat/QYDir4zOJW0eXDzFW8dgAxG7s4
	XQZlpNusskKJ0cFYWt+oA+qWgBNU5Vs3/dFqxSijZvqQ5lIM
X-Google-Smtp-Source: ACHHUZ57xDk+5ZZTI4rmcAPElGHV2O9pT/1piT7PyBvsH5ta/JpVjSIP0kahXE48oGQmUnrClwFuZkEX6ivb7UZgZgp2xc85AFr7
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:95a2:0:b0:420:f404:40b6 with SMTP id
 b31-20020a0295a2000000b00420f40440b6mr2628829jai.1.1687187585081; Mon, 19 Jun
 2023 08:13:05 -0700 (PDT)
Date: Mon, 19 Jun 2023 08:13:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ada87505fe7cf809@google.com>
Subject: [syzbot] [crypto?] general protection fault in shash_ahash_update
From: syzbot <syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    9a94d764e9bc Merge tag 'mlx5-updates-2023-06-16' of git://..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14774987280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4a7d74e6a7c3211
dashboard link: https://syzkaller.appspot.com/bug?extid=88f4b1e6cf88da11f5cd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1152c4ff280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1307cbcf280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/79cfaaedcd27/disk-9a94d764.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a22e22124e0b/vmlinux-9a94d764.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fe2e1ce58898/bzImage-9a94d764.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+88f4b1e6cf88da11f5cd@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 5004 Comm: syz-executor202 Not tainted 6.4.0-rc6-syzkaller-01333-g9a94d764e9bc #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/27/2023
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_update crypto/shash.c:124 [inline]
RIP: 0010:shash_ahash_update+0x126/0x210 crypto/shash.c:306
Code: 8c 00 00 00 e8 bb f7 a4 fd 48 8b 04 24 48 8b 6c 24 40 80 38 00 0f 85 c3 00 00 00 4d 8b 75 00 49 8d 7e 20 48 89 fa 48 c1 ea 03 <80> 3c 1a 00 0f 85 c1 00 00 00 4d 8b 7e 20 49 8d 7f 2c 48 89 fa 48
RSP: 0018:ffffc900039df948 EFLAGS: 00010202
RAX: ffffed1003ce8b6b RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df4f25 RDI: 0000000000000020
RBP: ffff8880732a3100 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000f00 R11: 0000000000000009 R12: 0000000000000f00
R13: ffff88801e745b58 R14: 0000000000000000 R15: 1ffff9200073bf2b
FS:  00005555565db300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fccb3501440 CR3: 0000000021e60000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ghash_async_update+0x136/0x170 arch/x86/crypto/ghash-clmulni-intel_glue.c:206
 crypto_ahash_update include/crypto/hash.h:608 [inline]
 hash_sendmsg+0x434/0xde0 crypto/algif_hash.c:139
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x733/0x920 net/socket.c:2493
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2547
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2576
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f95e272ecb9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd82939a68 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f95e272ecb9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 00007f95e26f2e60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f95e26f2ef0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_update crypto/shash.c:124 [inline]
RIP: 0010:shash_ahash_update+0x126/0x210 crypto/shash.c:306
Code: 8c 00 00 00 e8 bb f7 a4 fd 48 8b 04 24 48 8b 6c 24 40 80 38 00 0f 85 c3 00 00 00 4d 8b 75 00 49 8d 7e 20 48 89 fa 48 c1 ea 03 <80> 3c 1a 00 0f 85 c1 00 00 00 4d 8b 7e 20 49 8d 7f 2c 48 89 fa 48
RSP: 0018:ffffc900039df948 EFLAGS: 00010202
RAX: ffffed1003ce8b6b RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83df4f25 RDI: 0000000000000020
RBP: ffff8880732a3100 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000f00 R11: 0000000000000009 R12: 0000000000000f00
R13: ffff88801e745b58 R14: 0000000000000000 R15: 1ffff9200073bf2b
FS:  00005555565db300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f29a2df2304 CR3: 0000000021e60000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	8c 00                	mov    %es,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	e8 bb f7 a4 fd       	callq  0xfda4f7c4
   9:	48 8b 04 24          	mov    (%rsp),%rax
   d:	48 8b 6c 24 40       	mov    0x40(%rsp),%rbp
  12:	80 38 00             	cmpb   $0x0,(%rax)
  15:	0f 85 c3 00 00 00    	jne    0xde
  1b:	4d 8b 75 00          	mov    0x0(%r13),%r14
  1f:	49 8d 7e 20          	lea    0x20(%r14),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 1a 00          	cmpb   $0x0,(%rdx,%rbx,1) <-- trapping instruction
  2e:	0f 85 c1 00 00 00    	jne    0xf5
  34:	4d 8b 7e 20          	mov    0x20(%r14),%r15
  38:	49 8d 7f 2c          	lea    0x2c(%r15),%rdi
  3c:	48 89 fa             	mov    %rdi,%rdx
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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

