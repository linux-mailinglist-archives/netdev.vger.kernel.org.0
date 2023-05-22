Return-Path: <netdev+bounces-4140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3214870B4B0
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD8091C20997
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 05:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ADA1104;
	Mon, 22 May 2023 05:51:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822991102
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 05:51:06 +0000 (UTC)
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D37BCF
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 22:51:03 -0700 (PDT)
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-77466692597so116198739f.3
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 22:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684734662; x=1687326662;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jcItWuF4TzojUJ61RDIldf8/3Np1PuVWvxI7VRWSNfw=;
        b=JaMAM1F6fWB4O1nyKOVGKfxhUsBA90KqI2Fms4tsik85s5g7m3WW751kBWq7N3912e
         kp4ejCu0qiVwJTCHKpDyFLVau8IiYgn5Rog6CL82v3iOq5qzcyVOwW2r5aLEecMsR1Ek
         Smf6tgcp2ZFYvzl7pzBINvU+TL5qAQUELE6n3ft/tFtR6pjzEIwHiYgfPA4YAaxBqkF9
         ymTpRmjyrtKjnrQUtncppFzLMqo+QAib0Yb6qlQ3+MZ6ybPXRzk176F41kaPc8yqG8Hg
         4GJpM86W7p1tI51ba68oLbyQ2L6jlkzxxW84fFn8YajuBlfL2vBvhOqLjQrTzegHJJeO
         0T4w==
X-Gm-Message-State: AC+VfDzlSLrRgRhzR8XS7jTnOxzaCLaokfxXGB5xtZSJpbx87qF2gEqa
	NQ7C2BNZqTzLXYTZSDqY3pYKuM9MSCOdO9bwp0IhwKZ0LLDe
X-Google-Smtp-Source: ACHHUZ5J5/EC4XXQVWXvae2F7MpylTNwjG8kKtUj7JU0y3CoYqTEP0MBKs5bH1IIdAMpcWCcYOx1TzVJ9Sh4rV0iH2yUgsLC1KNJ
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:10c5:b0:416:7e77:bb5f with SMTP id
 q5-20020a05663810c500b004167e77bb5fmr4964715jad.0.1684734662419; Sun, 21 May
 2023 22:51:02 -0700 (PDT)
Date: Sun, 21 May 2023 22:51:02 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000182b5f05fc41db4a@google.com>
Subject: [syzbot] [net?] general protection fault in __sk_mem_raise_allocated
From: syzbot <syzbot+444ca0907e96f7c5e48b@syzkaller.appspotmail.com>
To: bpf@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com, 
	willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    f1fcbaa18b28 Linux 6.4-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1216efba280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ac0db1213414a978
dashboard link: https://syzkaller.appspot.com/bug?extid=444ca0907e96f7c5e48b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ea7e2a44b1f9/disk-f1fcbaa1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f4e3201419a9/vmlinux-f1fcbaa1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c2cd3eb9954b/bzImage-f1fcbaa1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+444ca0907e96f7c5e48b@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 6829 Comm: syz-executor.1 Not tainted 6.4.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
RIP: 0010:sk_get_rmem0 include/net/sock.h:2907 [inline]
RIP: 0010:__sk_mem_raise_allocated+0x806/0x17a0 net/core/sock.c:3006
Code: c1 ea 03 80 3c 02 00 0f 85 23 0f 00 00 48 8b 44 24 08 48 8b 98 38 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 03 38 d0 0f 8d 6f 0a 00 00 8b
RSP: 0018:ffffc90005d7f450 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90004d92000
RDX: 0000000000000000 RSI: ffffffff88066482 RDI: ffffffff8e2ccbb8
RBP: ffff8880173f7000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000030000
R13: 0000000000000001 R14: 0000000000000340 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9800000(0063) knlGS:00000000f7f1cb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000002e82f000 CR3: 0000000034ff0000 CR4: 00000000003506f0
Call Trace:
 <TASK>
 __sk_mem_schedule+0x6c/0xe0 net/core/sock.c:3077
 udp_rmem_schedule net/ipv4/udp.c:1539 [inline]
 __udp_enqueue_schedule_skb+0x776/0xb30 net/ipv4/udp.c:1581
 __udpv6_queue_rcv_skb net/ipv6/udp.c:666 [inline]
 udpv6_queue_rcv_one_skb+0xc39/0x16c0 net/ipv6/udp.c:775
 udpv6_queue_rcv_skb+0x194/0xa10 net/ipv6/udp.c:793
 __udp6_lib_mcast_deliver net/ipv6/udp.c:906 [inline]
 __udp6_lib_rcv+0x1bda/0x2bd0 net/ipv6/udp.c:1013
 ip6_protocol_deliver_rcu+0x2e7/0x1250 net/ipv6/ip6_input.c:437
 ip6_input_finish+0x150/0x2f0 net/ipv6/ip6_input.c:482
 NF_HOOK include/linux/netfilter.h:303 [inline]
 NF_HOOK include/linux/netfilter.h:297 [inline]
 ip6_input+0xa0/0xd0 net/ipv6/ip6_input.c:491
 ip6_mc_input+0x40b/0xf50 net/ipv6/ip6_input.c:585
 dst_input include/net/dst.h:468 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:79 [inline]
 NF_HOOK include/linux/netfilter.h:303 [inline]
 NF_HOOK include/linux/netfilter.h:297 [inline]
 ipv6_rcv+0x250/0x380 net/ipv6/ip6_input.c:309
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5491
 __netif_receive_skb+0x1f/0x1c0 net/core/dev.c:5605
 netif_receive_skb_internal net/core/dev.c:5691 [inline]
 netif_receive_skb+0x133/0x7a0 net/core/dev.c:5750
 tun_rx_batched+0x4b3/0x7a0 drivers/net/tun.c:1553
 tun_get_user+0x2452/0x39c0 drivers/net/tun.c:1989
 tun_chr_write_iter+0xdf/0x200 drivers/net/tun.c:2035
 call_write_iter include/linux/fs.h:1868 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x945/0xd50 fs/read_write.c:584
 ksys_write+0x12b/0x250 fs/read_write.c:637
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
 entry_SYSENTER_compat_after_hwframe+0x70/0x82
RIP: 0023:0xf7f21579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f7f1c590 EFLAGS: 00000282 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 00000000000000c8 RCX: 0000000020000040
RDX: 0000000000000083 RSI: 00000000f734e000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sk_get_rmem0 include/net/sock.h:2907 [inline]
RIP: 0010:__sk_mem_raise_allocated+0x806/0x17a0 net/core/sock.c:3006
Code: c1 ea 03 80 3c 02 00 0f 85 23 0f 00 00 48 8b 44 24 08 48 8b 98 38 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 03 38 d0 0f 8d 6f 0a 00 00 8b
RSP: 0018:ffffc90005d7f450 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90004d92000
RDX: 0000000000000000 RSI: ffffffff88066482 RDI: ffffffff8e2ccbb8
RBP: ffff8880173f7000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000030000
R13: 0000000000000001 R14: 0000000000000340 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9800000(0063) knlGS:00000000f7f1cb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000002e82f000 CR3: 0000000034ff0000 CR4: 00000000003506f0
----------------
Code disassembly (best guess):
   0:	c1 ea 03             	shr    $0x3,%edx
   3:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   7:	0f 85 23 0f 00 00    	jne    0xf30
   d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  12:	48 8b 98 38 01 00 00 	mov    0x138(%rax),%rbx
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 da             	mov    %rbx,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
  2e:	48 89 d8             	mov    %rbx,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 03             	add    $0x3,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	0f 8d 6f 0a 00 00    	jge    0xaae
  3f:	8b                   	.byte 0x8b


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

