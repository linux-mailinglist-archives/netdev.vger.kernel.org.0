Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D53235AD7
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHBUpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:45:21 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:56933 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgHBUpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:45:20 -0400
Received: by mail-il1-f197.google.com with SMTP id w81so25931872ilk.23
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RXzvXK6OwD5sKXbnrgicyuSzP9xmdWgB2LwI/qp4B8g=;
        b=oOd8tLHmRpBY5KX50f5MjweZUJYXzY7CDzhrQZmVIDYhpQcW9IeVmZQ6/h3OYBCYbD
         F5KJ4hZD3Lr38aLuX5Ym1VnUweCoxC7Cioy0HGWqGkcvD76mhjbaoty+B8j66ARtzkGI
         dUmk9wmP+GCU42nrBLamo3ZDTHrsTOkl4J+kcyAmpJisoKh1s3FTPucvpXFAlur2mC07
         GsT2VDUfpYSjYdubMf2iFZonSG8V9dnjkmXR7+AEwvsm+swhibQfmzQxWQPn3/UUrfIk
         x08Bn2czJTqoLrI0NXaexolBDxM3G/Jfe0Fs2yRDQtAiAAR+UKqzfDi9hpPsJv81BQQf
         gUBw==
X-Gm-Message-State: AOAM5324A6Ox9+ul0u879uvX8gBu3w/86MhrfhmZZ3A1suqafZg6Y97v
        SShP1j/z4f3kxwW+lN0YynoOkSa51GZIpQbrNY2yC4lPhPy8
X-Google-Smtp-Source: ABdhPJwS6z64gwXYyqJmUHpKD7bkhS2G9ZwGRgeCJ9WvFEQ6ciYipYww9Ipkk9UqjXGRdT07cN4NNkp+ci28BlKNfTpZcqHad183
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d12:: with SMTP id q18mr16853928jaj.5.1596401119651;
 Sun, 02 Aug 2020 13:45:19 -0700 (PDT)
Date:   Sun, 02 Aug 2020 13:45:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a7eb5e05abeb197d@google.com>
Subject: general protection fault in hci_event_packet
From:   syzbot <syzbot+0bef568258653cff272f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11af8670900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146f0832900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=101f8e04900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 PID: 6835 Comm: kworker/u5:1 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: hci0 hci_rx_work
RIP: 0010:hci_phy_link_complete_evt net/bluetooth/hci_event.c:4926 [inline]
RIP: 0010:hci_event_packet+0x8386/0x18260 net/bluetooth/hci_event.c:6180
Code: c1 e8 03 49 be 00 00 00 00 00 fc ff df 42 80 3c 30 00 74 08 48 89 df e8 58 9a 5e fa 48 8b 1b 48 83 c3 10 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 3b 9a 5e fa 48 8b 1b 48 89 d8 48
RSP: 0018:ffffc900015b7ac8 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
RDX: ffff8880920805c0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888092ef2000 R08: ffffffff875506b4 R09: fffffbfff131a9a6
R10: fffffbfff131a9a6 R11: 0000000000000000 R12: ffff8880a6e4c010
R13: ffff8880a6e4d110 R14: dffffc0000000000 R15: ffff8880a6e4c000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 00000000a85d0000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Modules linked in:
---[ end trace c208f496eb8e7691 ]---
RIP: 0010:hci_phy_link_complete_evt net/bluetooth/hci_event.c:4926 [inline]
RIP: 0010:hci_event_packet+0x8386/0x18260 net/bluetooth/hci_event.c:6180
Code: c1 e8 03 49 be 00 00 00 00 00 fc ff df 42 80 3c 30 00 74 08 48 89 df e8 58 9a 5e fa 48 8b 1b 48 83 c3 10 48 89 d8 48 c1 e8 03 <42> 80 3c 30 00 74 08 48 89 df e8 3b 9a 5e fa 48 8b 1b 48 89 d8 48
RSP: 0018:ffffc900015b7ac8 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: dffffc0000000000
RDX: ffff8880920805c0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888092ef2000 R08: ffffffff875506b4 R09: fffffbfff131a9a6
R10: fffffbfff131a9a6 R11: 0000000000000000 R12: ffff8880a6e4c010
R13: ffff8880a6e4d110 R14: dffffc0000000000 R15: ffff8880a6e4c000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f095f0866c0 CR3: 0000000009479000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
