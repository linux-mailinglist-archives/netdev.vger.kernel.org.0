Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAFF206C43
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 08:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389067AbgFXGRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:17:19 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:40342 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388810AbgFXGRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 02:17:18 -0400
Received: by mail-io1-f70.google.com with SMTP id f25so697914ioh.7
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 23:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=5CAUOdrn145t33RyDsvFuRNtproPZrRG5wbaIt1noKk=;
        b=i2TVeaKwfR1qTxlNMkoLxDcOUCTEZr2Cv9sElnmcQJcYxdhIi8acCg3QFt9H5pLzcU
         yJh40nd9FSROCNhgIu6V3l8F8IeJJ9wLa1mogn7s6e1T+RqRI9oMtKdV2NMOJMzD6Esx
         CXotNle9+Xn6z77f12d+eaX6M+01ClNpV+Rj8mnQP4wHmQO+8l+vFX9W8h3C6Dy1cf5L
         CVe9Zg6POTb7NHUk7U2ai7aezPfjJBD3J8xdzC938+h9h45zs95ldYqZO+ZKtDiPg5AZ
         RzGJkxXVP4pLNT0p93I39s5nDhRP+LK1V29pZGgAppVE51tqks/bOuJa5kFxRxWJ9UHQ
         LtMg==
X-Gm-Message-State: AOAM532P8kD886/7S2ZBzOHds9otuSZXy8ituO40qUQcNiy1Z6ZzScCc
        Liu1EwchewX5DxlEI04eaeq4fvP0Jacw1bU6LVyJ8AgMtxRh
X-Google-Smtp-Source: ABdhPJyELxw2qLKuuPok9m57oshaB2ZfSKHTA8VbOzvPFtYhWR3PH5aIWU1WALFsdrHxgeH3qH9ye4Gc1bt+Us2ddP1+eZIjKJN4
MIME-Version: 1.0
X-Received: by 2002:a02:cf3b:: with SMTP id s27mr16670340jar.72.1592979436970;
 Tue, 23 Jun 2020 23:17:16 -0700 (PDT)
Date:   Tue, 23 Jun 2020 23:17:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000079a77705a8ce6da7@google.com>
Subject: general protection fault in qrtr_endpoint_post
From:   syzbot <syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com>
To:     bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c27f79100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=03e343dbccf82a5242a2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1715f03d100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17dc0db6100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+03e343dbccf82a5242a2@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 PID: 6780 Comm: syz-executor827 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:qrtr_endpoint_post+0x92/0xfa0 net/qrtr/qrtr.c:440
Code: 44 89 e6 e8 80 27 4e fe 48 85 c0 48 89 c5 0f 84 57 0e 00 00 e8 4f 7a 9e f9 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 48 89 da 83 e2 07 38 d0 7f 08 84 c0 0f 85 f7 0c 00 00
RSP: 0018:ffffc900016a7c48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ffffffff86237e4b
RDX: 0000000000000002 RSI: ffffffff87d55471 RDI: ffff888090444150
RBP: ffff888090444140 R08: ffff8880954ca340 R09: ffffed1011e43c5d
R10: ffff88808f21e2e3 R11: ffffed1011e43c5c R12: 0000000000000000
R13: ffff88809a089100 R14: ffffc900016a7eb0 R15: 0000000000000000
FS:  0000000000a65880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 0000000099699000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 qrtr_tun_write_iter+0xf5/0x180 net/qrtr/tun.c:92
 call_write_iter include/linux/fs.h:1917 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:484
 __vfs_write+0xc9/0x100 fs/read_write.c:497
 vfs_write+0x268/0x5d0 fs/read_write.c:559
 ksys_write+0x12d/0x250 fs/read_write.c:612
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4401b9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff99653dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401b9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a40
R13: 0000000000401ad0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 5199d7949b247ba3 ]---
RIP: 0010:qrtr_endpoint_post+0x92/0xfa0 net/qrtr/qrtr.c:440
Code: 44 89 e6 e8 80 27 4e fe 48 85 c0 48 89 c5 0f 84 57 0e 00 00 e8 4f 7a 9e f9 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 04 02 48 89 da 83 e2 07 38 d0 7f 08 84 c0 0f 85 f7 0c 00 00
RSP: 0018:ffffc900016a7c48 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000010 RCX: ffffffff86237e4b
RDX: 0000000000000002 RSI: ffffffff87d55471 RDI: ffff888090444150
RBP: ffff888090444140 R08: ffff8880954ca340 R09: ffffed1011e43c5d
R10: ffff88808f21e2e3 R11: ffffed1011e43c5c R12: 0000000000000000
R13: ffff88809a089100 R14: ffffc900016a7eb0 R15: 0000000000000000
FS:  0000000000a65880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 0000000099699000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
