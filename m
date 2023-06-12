Return-Path: <netdev+bounces-10065-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C0972BCEF
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D292810F7
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC81418AE4;
	Mon, 12 Jun 2023 09:43:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C241117AAF
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:43:48 +0000 (UTC)
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5740C268D
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:43:46 -0700 (PDT)
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-33d63df7cd7so47126485ab.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:43:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686563025; x=1689155025;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kv1AaU/ci6MYkK2VN02VJouKgVYSm322xxxRcex2miU=;
        b=TTDy/tZCd3mdNxy4Rqn2I0QXIB79cKUkmrlCtGM46Xt3JG1KYEwxNOFTi3/h/gmnNX
         5ESksf8p1TzHtE15V+jSsg30d5MwmLgZNTWC1b41yWNbe44LbwgYrktk7H+cZMW8KuG8
         gkUjVQOfBgAFsXZXUCl/F4TOV18u0hTbrnkcUmh8M19mmXg3gL3E6hOuce4JSqeSrgg0
         a5/Y8t+0IcQ0KId6GW1cmxkDx/FVUTW1Jexxzz9bCJ/PqB3Gb8npjGdb59ZsTm53xevp
         OTHZrubCaL7Y3Z1cSrH3R0DzhenZ5g04VW+6JT0QhkWbsoOgUWjgdnZ4FEdgDF/U+eWO
         eM4w==
X-Gm-Message-State: AC+VfDwHDygpGycuw4f6f2/vvbQAM/Gd09C0S6R1tvq08jx6xNVWbFn6
	5fuVEPzv/MV/PtB7LppwjBcNgg4nTefz2IPg83Pl0JmkXTyC
X-Google-Smtp-Source: ACHHUZ7pimirnfh/ulwoW5dJmwDgLbNgOM9WHCiA1NmbzzDUUvOzoGW6uhkraY2cY50ihPQbumpfRu7HR5zQhoe/LC4bOdVITeR2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c98f:0:b0:33b:1445:e9cc with SMTP id
 y15-20020a92c98f000000b0033b1445e9ccmr3890817iln.1.1686563025647; Mon, 12 Jun
 2023 02:43:45 -0700 (PDT)
Date: Mon, 12 Jun 2023 02:43:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000900e905fdeb8e39@google.com>
Subject: [syzbot] [fs?] general protection fault in splice_to_socket
From: syzbot <syzbot+f9e28a23426ac3b24f20@syzkaller.appspotmail.com>
To: brauner@kernel.org, dhowells@redhat.com, kuba@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    e7c5433c5aaa tools: ynl: Remove duplicated include in hand..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10d8188b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=526f919910d4a671
dashboard link: https://syzkaller.appspot.com/bug?extid=f9e28a23426ac3b24f20
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12715143280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a936f1280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/13c08af1fd21/disk-e7c5433c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/35820511752b/vmlinux-e7c5433c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6a8cbec0d40f/bzImage-e7c5433c.xz

The issue was bisected to:

commit 2dc334f1a63a8839b88483a3e73c0f27c9c1791c
Author: David Howells <dhowells@redhat.com>
Date:   Wed Jun 7 18:19:09 2023 +0000

    splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c225b3280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c225b3280000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c225b3280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f9e28a23426ac3b24f20@syzkaller.appspotmail.com
Fixes: 2dc334f1a63a ("splice, net: Use sendmsg(MSG_SPLICE_PAGES) rather than ->sendpage()")

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 5007 Comm: syz-executor330 Not tainted 6.4.0-rc5-syzkaller-00915-ge7c5433c5aaa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
RIP: 0010:pipe_buf_release include/linux/pipe_fs_i.h:203 [inline]
RIP: 0010:splice_to_socket+0xa91/0xe30 fs/splice.c:933
Code: 10 48 89 f8 48 c1 e8 03 42 80 3c 28 00 0f 85 19 03 00 00 49 8b 46 10 49 c7 46 10 00 00 00 00 48 8d 78 08 48 89 fa 48 c1 ea 03 <42> 80 3c 2a 00 0f 85 e3 02 00 00 4c 89 f6 4c 89 e7 ff 50 08 83 44
RSP: 0018:ffffc90003adfa28 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000008001 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff81f4e014 RDI: 0000000000000008
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff2186c9b R12: ffff88802819f000
R13: dffffc0000000000 R14: ffff888077c05028 R15: 0000000000008001
FS:  00007f82b229b700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f82b227a718 CR3: 0000000075e14000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_splice_from fs/splice.c:969 [inline]
 do_splice+0xb8c/0x1e50 fs/splice.c:1309
 __do_splice+0x14e/0x270 fs/splice.c:1387
 __do_sys_splice fs/splice.c:1598 [inline]
 __se_sys_splice fs/splice.c:1580 [inline]
 __x64_sys_splice+0x19c/0x250 fs/splice.c:1580
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f82b22e8fc9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 81 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f82b229b2f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00007f82b2371428 RCX: 00007f82b22e8fc9
RDX: 0000000000000008 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007f82b2371420 R08: 0000000002000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f82b237142c
R13: 00007f82b233f004 R14: 0100000000000000 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pipe_buf_release include/linux/pipe_fs_i.h:203 [inline]
RIP: 0010:splice_to_socket+0xa91/0xe30 fs/splice.c:933
Code: 10 48 89 f8 48 c1 e8 03 42 80 3c 28 00 0f 85 19 03 00 00 49 8b 46 10 49 c7 46 10 00 00 00 00 48 8d 78 08 48 89 fa 48 c1 ea 03 <42> 80 3c 2a 00 0f 85 e3 02 00 00 4c 89 f6 4c 89 e7 ff 50 08 83 44
RSP: 0018:ffffc90003adfa28 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 0000000000008001 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff81f4e014 RDI: 0000000000000008
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 1ffffffff2186c9b R12: ffff88802819f000
R13: dffffc0000000000 R14: ffff888077c05028 R15: 0000000000008001
FS:  00007f82b229b700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa5f3ff2304 CR3: 0000000075e14000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	10 48 89             	adc    %cl,-0x77(%rax)
   3:	f8                   	clc
   4:	48 c1 e8 03          	shr    $0x3,%rax
   8:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1)
   d:	0f 85 19 03 00 00    	jne    0x32c
  13:	49 8b 46 10          	mov    0x10(%r14),%rax
  17:	49 c7 46 10 00 00 00 	movq   $0x0,0x10(%r14)
  1e:	00
  1f:	48 8d 78 08          	lea    0x8(%rax),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	42 80 3c 2a 00       	cmpb   $0x0,(%rdx,%r13,1) <-- trapping instruction
  2f:	0f 85 e3 02 00 00    	jne    0x318
  35:	4c 89 f6             	mov    %r14,%rsi
  38:	4c 89 e7             	mov    %r12,%rdi
  3b:	ff 50 08             	callq  *0x8(%rax)
  3e:	83                   	.byte 0x83
  3f:	44                   	rex.R


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

