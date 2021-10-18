Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590374326E8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbhJRS5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:57:38 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:53770 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbhJRS5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:57:37 -0400
Received: by mail-io1-f70.google.com with SMTP id g9-20020a056602150900b005d6376bdce7so11470468iow.20
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 11:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=d9FglVVwh25AoGE+76STUHBE//5+OPpn8rA7VxNxOTI=;
        b=JEYfpJC/imjU9TI2lCwjZgLX9egpcUjCA00qQf8JtE47jWkx9T+KpWPtDehlfHeKSB
         YoQonRzjNV4/OQSglHxrby1JEs+WprHyIAnvFSRtln2HJpYUxGM7K97qqZ5HpIS3Qz+r
         AxKDX72OT9IUshrvXfItDCf8mwr5tyzwmzyC/tIAv4LQ82F7LGIhVkAgA932fFeKVtFL
         mrVRZsbUv0HKJt5l/qWJALnU5GKeB04BUPwPbSqkSvQ7lEj6aHSANncetnEk0c8ehkJs
         C2V+L7CZuoI7024EfT2nsiqRJvydSrLgjQx57FMtfBPPmZPzWQn5tj+hZDjlf8ZPpdEX
         4+6A==
X-Gm-Message-State: AOAM531Z8jPhMv181kgbzzMvSyuUssHADooYUhQVpFW9vNrGA9FO7xPh
        YatEkWXigquFQ0sdq2R9KrniUk4WYriqvcFgGLiT7AL3yH7A
X-Google-Smtp-Source: ABdhPJwVl4Hluj+sHjdVEOw84B/s8707bcUBy90SmSxoxW/4Op1rbrmHAViUG0tIZjkhBcDE+PUubtQ5nVHtVpU9Zkiep7OB0MuU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4ca:: with SMTP id f10mr15538757ils.316.1634583326004;
 Mon, 18 Oct 2021 11:55:26 -0700 (PDT)
Date:   Mon, 18 Oct 2021 11:55:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000809ecc05cea5165d@google.com>
Subject: [syzbot] divide error in genelink_tx_fixup
From:   syzbot <syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    660a92a59b9e usb: xhci: Enable runtime-pm by default on AM..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1506ccf0b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5016916cdc0a4a84
dashboard link: https://syzkaller.appspot.com/bug?extid=a6ec4dd9d38cb9261a77
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11308734b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f56f68b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6ec4dd9d38cb9261a77@syzkaller.appspotmail.com

gl620a 2-1:0.0 usb1: register 'gl620a' at usb-dummy_hcd.1-1, Genesys GeneLink, 7a:f2:d1:89:41:da
divide error: 0000 [#1] SMP KASAN
CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work
RIP: 0010:genelink_tx_fixup+0x308/0x610 drivers/net/usb/gl620a.c:172
Code: 8b 44 24 70 48 ba 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 0f b6 14 11 84 d2 74 09 80 fa 03 0f 8e 50 02 00 00 31 d2 31 ff <f7> b3 28 01 00 00 41 89 d5 89 d6 e8 f8 50 b6 fd 45 85 ed 0f 84 b1
RSP: 0018:ffffc9000007f5e8 EFLAGS: 00010246
RAX: 0000000000000062 RBX: ffff8881197c0c00 RCX: 1ffff110232f81a5
RDX: 0000000000000000 RSI: ffffffff84bd1bb7 RDI: 0000000000000000
RBP: ffff88811b40b780 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff838b813c R11: 0000000000000000 R12: ffff88811b40b780
R13: 0000000000000654 R14: 000000000000005a R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f09f3e0aff8 CR3: 000000011c54f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 usbnet_start_xmit+0x152/0x1f70 drivers/net/usb/usbnet.c:1370
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
---[ end trace faca6a933050247e ]---
RIP: 0010:genelink_tx_fixup+0x308/0x610 drivers/net/usb/gl620a.c:172
Code: 8b 44 24 70 48 ba 00 00 00 00 00 fc ff df 48 89 f9 48 c1 e9 03 0f b6 14 11 84 d2 74 09 80 fa 03 0f 8e 50 02 00 00 31 d2 31 ff <f7> b3 28 01 00 00 41 89 d5 89 d6 e8 f8 50 b6 fd 45 85 ed 0f 84 b1
RSP: 0018:ffffc9000007f5e8 EFLAGS: 00010246
RAX: 0000000000000062 RBX: ffff8881197c0c00 RCX: 1ffff110232f81a5
RDX: 0000000000000000 RSI: ffffffff84bd1bb7 RDI: 0000000000000000
RBP: ffff88811b40b780 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff838b813c R11: 0000000000000000 R12: ffff88811b40b780
R13: 0000000000000654 R14: 000000000000005a R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f09f3e0aff8 CR3: 000000011c54f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	8b 44 24 70          	mov    0x70(%rsp),%eax
   4:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
   b:	fc ff df
   e:	48 89 f9             	mov    %rdi,%rcx
  11:	48 c1 e9 03          	shr    $0x3,%rcx
  15:	0f b6 14 11          	movzbl (%rcx,%rdx,1),%edx
  19:	84 d2                	test   %dl,%dl
  1b:	74 09                	je     0x26
  1d:	80 fa 03             	cmp    $0x3,%dl
  20:	0f 8e 50 02 00 00    	jle    0x276
  26:	31 d2                	xor    %edx,%edx
  28:	31 ff                	xor    %edi,%edi
* 2a:	f7 b3 28 01 00 00    	divl   0x128(%rbx) <-- trapping instruction
  30:	41 89 d5             	mov    %edx,%r13d
  33:	89 d6                	mov    %edx,%esi
  35:	e8 f8 50 b6 fd       	callq  0xfdb65132
  3a:	45 85 ed             	test   %r13d,%r13d
  3d:	0f                   	.byte 0xf
  3e:	84                   	.byte 0x84
  3f:	b1                   	.byte 0xb1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
