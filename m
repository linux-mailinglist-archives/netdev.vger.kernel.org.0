Return-Path: <netdev+bounces-7027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4497071953A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 705A92815F5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AA27E546;
	Thu,  1 Jun 2023 08:17:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380DFD2E3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:17:52 +0000 (UTC)
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BDBFB
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:17:48 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7773a91a912so162347139f.1
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 01:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685607467; x=1688199467;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b3edtjvnj88PndoVpUzOMvroFERuTIEvu1uDTqw3VI4=;
        b=fE4rjr6/Zmi0l2OckMy4OdRcCeGEFsGrdTJfvbg0uHdcSyU3YNCKqo1/HExeYrGOgw
         9buy2clKDPIZzAEfDAdwMhlLnBp3kLQioGZUTyqtVvuwEvyDRAmOQmgMyHF9b6cA3pnD
         ZuWgJ61vqWlGY2mmcolovIO613LGKksL69zmqVPMJh97EOXp+zUlSo0hgh7VPzPgb7P0
         tSmaQbs28weISHXO8LkwoVDuJAjAVQK/AWUgTg5DVYsy19CHpjrmOYkAnfm7c76Mj8S2
         eY7flpuytAnSg03WH5bhlJ7VXy48bQHHQPOG+ZWuyz8UdsJ8vewZala9I9sKcL1dYUBN
         zYhw==
X-Gm-Message-State: AC+VfDy7RqvevatfxxJVvpLFRr2MxiKJZpgjG650c6zgwRi2RnDLsLr2
	j8gyvQ0fOodH5Xhtu9uGsW33K6leA9Sw2xHKcABFS9wApeFx
X-Google-Smtp-Source: ACHHUZ5jvU5W7NceH/iaowoBjYeMRtnXvxExH2I6rRvZ8cupRZ55oFVxQGVJXOnAIHX+Y64w9OZm44Rvy/Aq20MNg3T9H8zHudbA
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:2283:0:b0:40f:8f07:e28e with SMTP id
 o125-20020a022283000000b0040f8f07e28emr526717jao.1.1685607467279; Thu, 01 Jun
 2023 01:17:47 -0700 (PDT)
Date: Thu, 01 Jun 2023 01:17:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000516d5905fd0d12ec@google.com>
Subject: [syzbot] [net?] [bpf?] general protection fault in sk_psock_verdict_data_ready
From: syzbot <syzbot+8252ac3e16614ea0ea04@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	jakub@cloudflare.com, john.fastabend@gmail.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    4781e965e655 net: phy: broadcom: Register dummy IRQ handler
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=117277de280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5335204dcdecfda
dashboard link: https://syzkaller.appspot.com/bug?extid=8252ac3e16614ea0ea04
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7a839a1e1e20/disk-4781e965.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ceb0a7674b18/vmlinux-4781e965.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f3e82748f103/bzImage-4781e965.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8252ac3e16614ea0ea04@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000005c: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000002e0-0x00000000000002e7]
CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 6.4.0-rc3-syzkaller-00588-g4781e965e655 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/16/2023
RIP: 0010:sk_psock_verdict_data_ready+0x19f/0x3c0 net/core/skmsg.c:1213
Code: 4c 89 e6 e8 63 70 5e f9 4d 85 e4 75 75 e8 19 74 5e f9 48 8d bb e0 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 07 02 00 00 48 89 ef ff 93 e0 02 00 00 e8 29 fd
RSP: 0018:ffffc90000147688 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 000000000000005c RSI: ffffffff8825ceb7 RDI: 00000000000002e0
RBP: ffff888076518c40 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000008000 R15: ffff888076518c40
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f901375bab0 CR3: 000000004bf26000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcp_data_ready+0x10a/0x520 net/ipv4/tcp_input.c:5006
 tcp_data_queue+0x25d3/0x4c50 net/ipv4/tcp_input.c:5080
 tcp_rcv_established+0x829/0x1f90 net/ipv4/tcp_input.c:6019
 tcp_v4_do_rcv+0x65a/0x9c0 net/ipv4/tcp_ipv4.c:1726
 tcp_v4_rcv+0x2cbf/0x3340 net/ipv4/tcp_ipv4.c:2148
 ip_protocol_deliver_rcu+0x9f/0x480 net/ipv4/ip_input.c:205
 ip_local_deliver_finish+0x2ec/0x520 net/ipv4/ip_input.c:233
 NF_HOOK include/linux/netfilter.h:303 [inline]
 NF_HOOK include/linux/netfilter.h:297 [inline]
 ip_local_deliver+0x1ae/0x200 net/ipv4/ip_input.c:254
 dst_input include/net/dst.h:468 [inline]
 ip_rcv_finish+0x1cf/0x2f0 net/ipv4/ip_input.c:449
 NF_HOOK include/linux/netfilter.h:303 [inline]
 NF_HOOK include/linux/netfilter.h:297 [inline]
 ip_rcv+0xae/0xd0 net/ipv4/ip_input.c:569
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5491
 __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5605
 process_backlog+0x101/0x670 net/core/dev.c:5933
 __napi_poll+0xb7/0x6f0 net/core/dev.c:6499
 napi_poll net/core/dev.c:6566 [inline]
 net_rx_action+0x8a9/0xcb0 net/core/dev.c:6699
 __do_softirq+0x1d4/0x905 kernel/softirq.c:571
 run_ksoftirqd kernel/softirq.c:939 [inline]
 run_ksoftirqd+0x31/0x60 kernel/softirq.c:931
 smpboot_thread_fn+0x659/0x9e0 kernel/smpboot.c:164
 kthread+0x344/0x440 kernel/kthread.c:379
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sk_psock_verdict_data_ready+0x19f/0x3c0 net/core/skmsg.c:1213
Code: 4c 89 e6 e8 63 70 5e f9 4d 85 e4 75 75 e8 19 74 5e f9 48 8d bb e0 02 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 07 02 00 00 48 89 ef ff 93 e0 02 00 00 e8 29 fd
RSP: 0018:ffffc90000147688 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 000000000000005c RSI: ffffffff8825ceb7 RDI: 00000000000002e0
RBP: ffff888076518c40 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000008000 R15: ffff888076518c40
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f901375bab0 CR3: 000000004bf26000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	4c 89 e6             	mov    %r12,%rsi
   3:	e8 63 70 5e f9       	callq  0xf95e706b
   8:	4d 85 e4             	test   %r12,%r12
   b:	75 75                	jne    0x82
   d:	e8 19 74 5e f9       	callq  0xf95e742b
  12:	48 8d bb e0 02 00 00 	lea    0x2e0(%rbx),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 07 02 00 00    	jne    0x23b
  34:	48 89 ef             	mov    %rbp,%rdi
  37:	ff 93 e0 02 00 00    	callq  *0x2e0(%rbx)
  3d:	e8                   	.byte 0xe8
  3e:	29 fd                	sub    %edi,%ebp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

