Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618D7432C26
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 05:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhJSDTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 23:19:43 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48759 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhJSDTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 23:19:42 -0400
Received: by mail-il1-f197.google.com with SMTP id s8-20020a056e02216800b002593ad87094so9236337ilv.15
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 20:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OaCb4m2Y41G8nZRW9KQLy/L6JXv6G8zOIqHDza5NSKY=;
        b=sQWAuPck8+JTgOKjgBriLc4UpIM0EziROn9D1KDRMTcEHYApid8MM4sdaOBNlDbebF
         asSHVuIXQaTZRjSXbrzoYVElH4zrjaMZc4OcuNptCC1iAWDcERhS26kY4n8JlmmswlYa
         3/pgJo91NbF2NL8DkRWPPb5TQocQW0DnHhXPSlg1z88bB+uhIdDBeBh+SHieiiUYmBj0
         JSUBZdlpXprArU+8/5rSJH9bWhJjCSO1C/0LF6iedIIBp/swPXDVFs1uy9wEpdDY8qSd
         ciCgcBXTqbN02ihh/JIwC+W0nQ9TsfNqBrbdmD8dayhnzJHmV0lVha8E/jtwhSHYgn06
         8vvw==
X-Gm-Message-State: AOAM533oFmHwBn3oX9UQR1z+V/Bsf9CjuwTrvxFsTxpmQ993DXBbkkD2
        qI72keAaztFpG3wmmv+JLsST6w5YlBSHqPamV/KPjPrQxZcn
X-Google-Smtp-Source: ABdhPJytT01GGfwmypDTPjJGvud3xJD/NRIzfMyKE/Wt5woHb/L6cvKtWWgzORzXXgPLYExfF4IloMbwxriKJhcmvYnYPvVeicuK
MIME-Version: 1.0
X-Received: by 2002:a05:6638:220c:: with SMTP id l12mr2445346jas.149.1634613449745;
 Mon, 18 Oct 2021 20:17:29 -0700 (PDT)
Date:   Mon, 18 Oct 2021 20:17:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000046acd05ceac1a72@google.com>
Subject: [syzbot] divide error in usbnet_start_xmit
From:   syzbot <syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c03fb16bafdf Merge 5.15-rc6 into usb-next
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=12d48f1f300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c27d285bdb7457e2
dashboard link: https://syzkaller.appspot.com/bug?extid=76bb1d34ffa0adc03baa
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fe6decb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c7bcaf300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com

divide error: 0000 [#1] SMP KASAN
CPU: 0 PID: 1315 Comm: kworker/0:6 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work
RIP: 0010:usbnet_start_xmit+0x3f1/0x1f70 drivers/net/usb/usbnet.c:1404
Code: 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 4b 18 00 00 8b 44 24 08 31 d2 31 ff <41> f7 b5 28 0d 00 00 41 89 d4 89 d6 e8 4e 12 b5 fd 45 85 e4 0f 84
RSP: 0018:ffffc9000104f660 EFLAGS: 00010246
RAX: 000000000000005a RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff838cbdc1 RDI: 0000000000000000
RBP: ffff8881155b1350 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff838cbdb4 R11: 0000000000000000 R12: 00000000c0011100
R13: ffff888119304000 R14: ffff8881155b1280 R15: ffff8881155b0d00
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f24d7edaa70 CR3: 000000010a45d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __netdev_start_xmit include/linux/netdevice.h:4988 [inline]
 netdev_start_xmit include/linux/netdevice.h:5002 [inline]
 xmit_one net/core/dev.c:3576 [inline]
 dev_hard_start_xmit+0x1df/0x890 net/core/dev.c:3592
 sch_direct_xmit+0x25b/0x790 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3803 [inline]
 __dev_queue_xmit+0xf25/0x2d40 net/core/dev.c:4170
 neigh_resolve_output net/core/neighbour.c:1492 [inline]
 neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1472
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0xdbe/0x1b20 net/ipv6/ip6_output.c:126
 __ip6_finish_output.part.0+0x387/0xbb0 net/ipv6/ip6_output.c:191
 __ip6_finish_output include/linux/skbuff.h:982 [inline]
 ip6_finish_output net/ipv6/ip6_output.c:201 [inline]
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x3d2/0x810 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 mld_sendpack+0x979/0xe10 net/ipv6/mcast.c:1826
 mld_send_cr net/ipv6/mcast.c:2127 [inline]
 mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2659
 process_one_work+0x9bf/0x1620 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3c2/0x4a0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace 3c734ee50b55655e ]---
RIP: 0010:usbnet_start_xmit+0x3f1/0x1f70 drivers/net/usb/usbnet.c:1404
Code: 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 4b 18 00 00 8b 44 24 08 31 d2 31 ff <41> f7 b5 28 0d 00 00 41 89 d4 89 d6 e8 4e 12 b5 fd 45 85 e4 0f 84
RSP: 0018:ffffc9000104f660 EFLAGS: 00010246
RAX: 000000000000005a RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff838cbdc1 RDI: 0000000000000000
RBP: ffff8881155b1350 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff838cbdb4 R11: 0000000000000000 R12: 00000000c0011100
R13: ffff888119304000 R14: ffff8881155b1280 R15: ffff8881155b0d00
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f24d7edaa70 CR3: 000000010a45d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
   7:	fc ff df
   a:	48 89 fa             	mov    %rdi,%rdx
   d:	48 c1 ea 03          	shr    $0x3,%rdx
  11:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
  15:	84 c0                	test   %al,%al
  17:	74 08                	je     0x21
  19:	3c 03                	cmp    $0x3,%al
  1b:	0f 8e 4b 18 00 00    	jle    0x186c
  21:	8b 44 24 08          	mov    0x8(%rsp),%eax
  25:	31 d2                	xor    %edx,%edx
  27:	31 ff                	xor    %edi,%edi
* 29:	41 f7 b5 28 0d 00 00 	divl   0xd28(%r13) <-- trapping instruction
  30:	41 89 d4             	mov    %edx,%r12d
  33:	89 d6                	mov    %edx,%esi
  35:	e8 4e 12 b5 fd       	callq  0xfdb51288
  3a:	45 85 e4             	test   %r12d,%r12d
  3d:	0f                   	.byte 0xf
  3e:	84                   	.byte 0x84


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
