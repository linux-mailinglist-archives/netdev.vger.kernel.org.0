Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE4544FF33
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 08:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhKOHbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 02:31:14 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:33664 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhKOHbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 02:31:12 -0500
Received: by mail-io1-f71.google.com with SMTP id f19-20020a6b6213000000b005ddc4ce4deeso10400340iog.0
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 23:28:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7XpsCj38ktcfnv4VVdcUtYPxcdovmZ/Fms2+vpqFRgU=;
        b=qB8dcOHpX6CKrMD6ewKEC0Fwx/tHcpRmjhNwBo8kz+v74fYeNNtzBE6W6dXmoqTRmV
         5Ox2syGCqiQtNffxtrCe494lnSvMSZ4oj6/5lFWrh88xOSGhcFQ2cwuS5NSFNpIKlhuf
         d5J8PbSLl57Cz2FXyAlhERJaA6TwVbSJr+1WFGGet2u8KSv9hx8TDyHGNV0tz76IaVJz
         g6cnpSBTrdugXAl6StsaQn5FpgVbMTcUN2NXjVXy2junz3dGqn/vVu9bOFNqWEssD141
         0+d3b4J5ioWIFmuBho81DTUxXpR8vbz/XRl8jK5qV6Zqxdp1JlcwVXTAtVqUsK1IkXYU
         mP8g==
X-Gm-Message-State: AOAM530HZx49t+LCXgaH3QHuOYLBXHCwlkfOZ1IPCq88d2m8D6h4tqGJ
        O8K8tiEAqKgby6iav4bUU78CLC652xlzAADStYzfF1GDAEXF
X-Google-Smtp-Source: ABdhPJyNhudIndiLt/UqOqGvlhxrQfyymFyOIOh2KqHNFnvarLVsa/ad5ydbDL/Y0jrQdrSfdLBw+mDdevk3gRZehUV1Ub5PxVdZ
MIME-Version: 1.0
X-Received: by 2002:a5d:928c:: with SMTP id s12mr24320290iom.163.1636961297459;
 Sun, 14 Nov 2021 23:28:17 -0800 (PST)
Date:   Sun, 14 Nov 2021 23:28:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a56e9105d0cec021@google.com>
Subject: [syzbot] WARNING in usbnet_start_xmit/usb_submit_urb
From:   syzbot <syzbot+63ee658b9a100ffadbe2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        oneukum@suse.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    048ff8629e11 Merge tag 'usb-5.16-rc1' of git://git.kernel...
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1480ade1b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d6b387bc5d3e50f3
dashboard link: https://syzkaller.appspot.com/bug?extid=63ee658b9a100ffadbe2
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1313cb7cb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16a2f676b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+63ee658b9a100ffadbe2@syzkaller.appspotmail.com

------------[ cut here ]------------
usb 5-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 0 PID: 1291 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Modules linked in:
CPU: 0 PID: 1291 Comm: kworker/0:3 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: mld mld_ifc_work
RIP: 0010:usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Code: 7c 24 18 e8 40 2b aa fd 48 8b 7c 24 18 e8 c6 23 1a ff 41 89 d8 44 89 e1 4c 89 ea 48 89 c6 48 c7 c7 40 c0 85 86 e8 e5 66 03 02 <0f> 0b e9 58 f8 ff ff e8 12 2b aa fd 48 81 c5 80 06 00 00 e9 84 f7
RSP: 0018:ffffc90000f0f580 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff888108599c00 RSI: ffffffff812bae18 RDI: fffff520001e1ea2
RBP: ffff88810b887b00 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff812b4bfe R11: 0000000000000000 R12: 0000000000000003
R13: ffff8881067d9dc0 R14: 0000000000000003 R15: ffff88810d2dd700
FS:  0000000000000000(0000) GS:ffff8881f6800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3815d25ff8 CR3: 000000010bdba000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 usbnet_start_xmit+0x5ed/0x1f70 drivers/net/usb/usbnet.c:1460
 __netdev_start_xmit include/linux/netdevice.h:4987 [inline]
 netdev_start_xmit include/linux/netdevice.h:5001 [inline]
 xmit_one net/core/dev.c:3590 [inline]
 dev_hard_start_xmit+0x1eb/0x920 net/core/dev.c:3606
 sch_direct_xmit+0x25b/0x790 net/sched/sch_generic.c:342
 __dev_xmit_skb net/core/dev.c:3817 [inline]
 __dev_queue_xmit+0x11bf/0x31d0 net/core/dev.c:4194
 neigh_resolve_output net/core/neighbour.c:1523 [inline]
 neigh_resolve_output+0x50e/0x820 net/core/neighbour.c:1503
 neigh_output include/net/neighbour.h:527 [inline]
 ip6_finish_output2+0xb49/0x1af0 net/ipv6/ip6_output.c:126
 __ip6_finish_output.part.0+0x387/0xbb0 net/ipv6/ip6_output.c:191
 __ip6_finish_output include/linux/skbuff.h:986 [inline]
 ip6_finish_output net/ipv6/ip6_output.c:201 [inline]
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x3d2/0x810 net/ipv6/ip6_output.c:224
 dst_output include/net/dst.h:450 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 mld_sendpack+0x96d/0xe00 net/ipv6/mcast.c:1826
 mld_send_cr net/ipv6/mcast.c:2127 [inline]
 mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2659
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x40b/0x500 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
