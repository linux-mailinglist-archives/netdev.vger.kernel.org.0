Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFDA64D47C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 01:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiLOAPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 19:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiLOAPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 19:15:10 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C285446E
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 16:12:50 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id z200-20020a6bc9d1000000b006e003aecf04so4825483iof.16
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 16:12:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CLIWZP5JFMmqmoY9pqT+72QXkqVSME/SxWi12vcxTSM=;
        b=w295bqNlAPuMRw/Ueei0+sxoaWNEEvtTmjHiE6dOuJHSSmYi6/dSu9wzCzsnM6fsS3
         1HHSU2+j5UnPN5DZBWyUDw8kiQGX6tPkN2AAwFxei1/JFRZJimB0jWMsBXXWmvw8Ad1w
         sbBEEUSmbc5nskAq2h/m5huTMjQsubqkzNegijrh6xBIKP7f2ZDlAckAkUL8fkvJEc9+
         Px+5BFCy4zxuoJuJoWtXFlfNHV7DmDDyWX3rATM+0Wpxnl9CWEg4oxg6XnWJQElghBjX
         EMRmDKtROs965gnKKg21QDs46+wVHSobuxiV8YBNxxHLBftng9e/UlLVSUBK5PSgUzMs
         WiKw==
X-Gm-Message-State: AFqh2kqb/am+G4xfLBtc1cntXD2/AWba/uvJQ+/8PwE2UBGueUL2+Umj
        JN1pGCodSlkIL7Tk6nSXgewOSvXJaksTBLQS1dNcYTx0qA7/
X-Google-Smtp-Source: AMrXdXvR+ru5XcUoG2aXMUEGYjnbwrrGOid6p58gRmsqDGu08TPS6qRPWjEc/UzzBhpOBTzHHvqZeofzl6hRtquau3jEcOLIyvKq
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1bee:b0:305:dca2:c238 with SMTP id
 y14-20020a056e021bee00b00305dca2c238mr493267ilv.130.1671063170352; Wed, 14
 Dec 2022 16:12:50 -0800 (PST)
Date:   Wed, 14 Dec 2022 16:12:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa918f05efd2b677@google.com>
Subject: [syzbot] general protection fault in em_cmp_match
From:   syzbot <syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
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

HEAD commit:    296a7b7eb792 Merge tag 'for-linus' of git://git.armlinux.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=173ee77d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4edf421741552bc3
dashboard link: https://syzkaller.appspot.com/bug?extid=4caeae4c7103813598ae
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128f80ed880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16096513880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/44efe7c1185f/disk-296a7b7e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/22c2c707e34d/vmlinux-296a7b7e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9a8c92b56666/bzImage-296a7b7e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 154 Comm: kworker/1:2 Not tainted 6.1.0-rc8-syzkaller-00154-g296a7b7eb792 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:em_cmp_match+0x55/0x670 net/sched/em_cmp.c:25
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b0 05 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 08 4c 8d 7d 0a 4c 89 fa 48 c1 ea 03 <0f> b6 14 02 4c 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 47
RSP: 0018:ffffc90002e4ec40 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88801f5817c0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff87f06d8d RDI: ffff88801f5817c8
RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8880719c9a00
R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000000a
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000000c28e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tcf_em_match net/sched/ematch.c:492 [inline]
 __tcf_em_tree_match+0x153/0x560 net/sched/ematch.c:518
 tcf_em_tree_match include/net/pkt_cls.h:502 [inline]
 basic_classify+0x206/0x330 net/sched/cls_basic.c:48
 __tcf_classify net/sched/cls_api.c:1567 [inline]
 tcf_classify+0x3ec/0xa40 net/sched/cls_api.c:1633
 prio_classify net/sched/sch_prio.c:42 [inline]
 prio_enqueue+0x3ab/0x790 net/sched/sch_prio.c:75
 dev_qdisc_enqueue+0x46/0x390 net/core/dev.c:3785
 __dev_xmit_skb net/core/dev.c:3874 [inline]
 __dev_queue_xmit+0x2279/0x3ba0 net/core/dev.c:4222
 dev_queue_xmit include/linux/netdevice.h:3008 [inline]
 neigh_hh_output include/net/neighbour.h:530 [inline]
 neigh_output include/net/neighbour.h:544 [inline]
 ip_finish_output2+0x14e3/0x2180 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:306 [inline]
 __ip_finish_output+0x396/0x650 net/ipv4/ip_output.c:288
 ip_finish_output+0x31/0x280 net/ipv4/ip_output.c:316
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip_output+0x1a3/0x320 net/ipv4/ip_output.c:430
 dst_output include/net/dst.h:445 [inline]
 ip_local_out+0xb3/0x1a0 net/ipv4/ip_output.c:126
 iptunnel_xmit+0x67e/0x9f0 net/ipv4/ip_tunnel_core.c:82
 geneve_xmit_skb drivers/net/geneve.c:996 [inline]
 geneve_xmit+0x1318/0x4910 drivers/net/geneve.c:1108
 __netdev_start_xmit include/linux/netdevice.h:4840 [inline]
 netdev_start_xmit include/linux/netdevice.h:4854 [inline]
 xmit_one net/core/dev.c:3590 [inline]
 dev_hard_start_xmit+0x1c2/0x990 net/core/dev.c:3606
 __dev_queue_xmit+0x2cdf/0x3ba0 net/core/dev.c:4256
 dev_queue_xmit include/linux/netdevice.h:3008 [inline]
 neigh_resolve_output net/core/neighbour.c:1571 [inline]
 neigh_resolve_output+0x51b/0x840 net/core/neighbour.c:1551
 neigh_output include/net/neighbour.h:546 [inline]
 ip6_finish_output2+0x56c/0x1530 net/ipv6/ip6_output.c:134
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:445 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ndisc_send_skb+0xa63/0x1740 net/ipv6/ndisc.c:508
 ndisc_send_ns+0xaa/0x130 net/ipv6/ndisc.c:666
 addrconf_dad_work+0xbf4/0x12d0 net/ipv6/addrconf.c:4171
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:em_cmp_match+0x55/0x670 net/sched/em_cmp.c:25
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b0 05 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 08 4c 8d 7d 0a 4c 89 fa 48 c1 ea 03 <0f> b6 14 02 4c 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 47
RSP: 0018:ffffc90002e4ec40 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff88801f5817c0 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff87f06d8d RDI: ffff88801f5817c8
RBP: 0000000000000000 R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8880719c9a00
R13: 0000000000000000 R14: 0000000000000000 R15: 000000000000000a
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 000000000c28e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	48 c1 ea 03          	shr    $0x3,%rdx
   7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   b:	0f 85 b0 05 00 00    	jne    0x5c1
  11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  18:	fc ff df
  1b:	48 8b 6b 08          	mov    0x8(%rbx),%rbp
  1f:	4c 8d 7d 0a          	lea    0xa(%rbp),%r15
  23:	4c 89 fa             	mov    %r15,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
  2e:	4c 89 f8             	mov    %r15,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 01             	add    $0x1,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	47                   	rex.RXB


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
