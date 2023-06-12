Return-Path: <netdev+bounces-10066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E50C72BCF2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 653ED1C20B67
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067CF18B0E;
	Mon, 12 Jun 2023 09:43:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE4A18B08
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:43:49 +0000 (UTC)
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6747273D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:43:46 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-33d34e7c905so46957695ab.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:43:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686563026; x=1689155026;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fgWuun5672+ORe3ttQrL6TxxbK5Uws3qICHATbMGm/o=;
        b=DFehF12Xft7dpLR6a6hKc0J49/GA2gxpjGeI8E7WcOX8JVXgjkfc36BuUUV+sFSeaq
         sjm6MgxSBeXfj+yvUKGT2hEAcSbhDo74tKKbvdrJ2wyJe0D3yyMw4YsioprnpAn9KWZT
         EnmZGDcFR33wJh4vjS1dTKmYFa6u6ph+XOsv7N9IRv5D20ubtGGo4hnwuiu8cWtp1dzl
         qGswXR3GHGyEiFhMn6HLjWOuWjCvV9M1J6XhacTuFWNG4ju007VSMuuhMV6VF4TVWs7u
         vMmb8qLRYHoT/utvZCJpWS+TFHUkOlyMv4lhxqn47emRYbXF6Ne0pOsCrUp/iU7bMAwG
         Cp/w==
X-Gm-Message-State: AC+VfDxZNT8cX7BC23u2ojNyKHGNnQdGBaf0LC+sSg+ACiib64GKTTMR
	bQ1EgGrhigNOpk2VtmDSjVxoEN4ywZAhSVwGdPjI+pQCggCy
X-Google-Smtp-Source: ACHHUZ6CzjZUI1p1eZ09tKwTgjz0mJ/wA5KXMzNddXs78re7fSkOCOH6JtddvvRetOkKurNc2eVgLt0uqCuAH2lQsxLKVy9oCUJ7
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d0c3:0:b0:33b:a:3234 with SMTP id y3-20020a92d0c3000000b0033b000a3234mr3854150ila.5.1686563025889;
 Mon, 12 Jun 2023 02:43:45 -0700 (PDT)
Date: Mon, 12 Jun 2023 02:43:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000cb2c305fdeb8e30@google.com>
Subject: [syzbot] [crypto?] general protection fault in cryptd_hash_export
From: syzbot <syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com>
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

HEAD commit:    ded5c1a16ec6 Merge branch 'tools-ynl-gen-code-gen-improvem..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=104cdef1280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=e79818f5c12416aba9de
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c6193b280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16c7a795280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ffd66beb6784/disk-ded5c1a1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e7336ae5a7bf/vmlinux-ded5c1a1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/10ded02dc7e2/bzImage-ded5c1a1.xz

The issue was bisected to:

commit c662b043cdca89bf0f03fc37251000ac69a3a548
Author: David Howells <dhowells@redhat.com>
Date:   Tue Jun 6 13:08:56 2023 +0000

    crypto: af_alg/hash: Support MSG_SPLICE_PAGES

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11cfc8d9280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13cfc8d9280000
console output: https://syzkaller.appspot.com/x/log.txt?x=15cfc8d9280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e79818f5c12416aba9de@syzkaller.appspotmail.com
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 5003 Comm: syz-executor195 Not tainted 6.4.0-rc5-syzkaller-00929-gded5c1a16ec6 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_export include/crypto/hash.h:956 [inline]
RIP: 0010:cryptd_hash_export+0x47/0xa0 crypto/cryptd.c:636
Code: 00 fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 60 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 40 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 20 48 8d
RSP: 0018:ffffc90003acfd48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83e46723 RDI: 0000000000000020
RBP: ffff888015a96528 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffffffff81d71db5 R12: ffff88802945bb08
R13: 0000000000000001 R14: ffff88801aba6000 R15: ffff8880220c1648
FS:  0000555556eb3300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020004e80 CR3: 0000000076861000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 crypto_ahash_export include/crypto/hash.h:523 [inline]
 hash_accept+0x229/0x670 crypto/algif_hash.c:286
 do_accept+0x380/0x510 net/socket.c:1871
 __sys_accept4_file net/socket.c:1912 [inline]
 __sys_accept4+0x9a/0x120 net/socket.c:1942
 __do_sys_accept4 net/socket.c:1953 [inline]
 __se_sys_accept4 net/socket.c:1950 [inline]
 __x64_sys_accept4+0x97/0x100 net/socket.c:1950
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6a9d4eac09
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff241f3198 EFLAGS: 00000246 ORIG_RAX: 0000000000000120
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6a9d4eac09
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f6a9d4aedb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6a9d4aee40
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:crypto_shash_alg include/crypto/hash.h:827 [inline]
RIP: 0010:crypto_shash_export include/crypto/hash.h:956 [inline]
RIP: 0010:cryptd_hash_export+0x47/0xa0 crypto/cryptd.c:636
Code: 00 fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02 00 75 4e 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 60 48 8d 7b 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 40 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 20 48 8d
RSP: 0018:ffffc90003acfd48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff83e46723 RDI: 0000000000000020
RBP: ffff888015a96528 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: ffffffff81d71db5 R12: ffff88802945bb08
R13: 0000000000000001 R14: ffff88801aba6000 R15: ffff8880220c1648
FS:  0000555556eb3300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555a4edc6008 CR3: 0000000076861000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	df 4c 89 e2          	fisttps -0x1e(%rcx,%rcx,4)
   4:	48 c1 ea 03          	shr    $0x3,%rdx
   8:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   c:	75 4e                	jne    0x5c
   e:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  15:	fc ff df
  18:	48 8b 5b 60          	mov    0x60(%rbx),%rbx
  1c:	48 8d 7b 20          	lea    0x20(%rbx),%rdi
  20:	48 89 fa             	mov    %rdi,%rdx
  23:	48 c1 ea 03          	shr    $0x3,%rdx
* 27:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2b:	75 40                	jne    0x6d
  2d:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  34:	fc ff df
  37:	48 8b 5b 20          	mov    0x20(%rbx),%rbx
  3b:	48                   	rex.W
  3c:	8d                   	.byte 0x8d


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

