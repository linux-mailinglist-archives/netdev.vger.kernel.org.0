Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA06014D8C2
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 11:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgA3KON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 05:14:13 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:40463 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgA3KON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 05:14:13 -0500
Received: by mail-io1-f72.google.com with SMTP id m24so1621451iol.7
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 02:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=t4vo0u6KTxFmuW+mHcgJMo7mTce20UYxGm5eCY798RA=;
        b=DuWszW6vbt5gWwNCTCB5+P4ClxK/qHQLuZkp4xDSBvHSB/QORq7CWMPI8sqUtGACaQ
         7PZJol/P9DBBOK2zAco85LjZzRj+PPTPt1ksCtGUoiWgTdVufqCf0423QR95bQMOzIOf
         EVl030XSa1hR6+VfwLQo23fKSnw4PPR2W89DaQwvxGUnOxY5Gz+373BkCTqs+0tLA4uV
         cLBWdST2FHXhrFE+ND5/bzppEhZox58pJzCBkwftPAx3soHEPNawsOulVp4a3TAY6q9Q
         jr/Ko//onn1MSKFkvsFuNuuHKxfEkjKMc1rWM83TmTGoquhdEveof3KAdpppt6gTLiwh
         6Y2g==
X-Gm-Message-State: APjAAAUMgQWqnypJEbnlnZpP5LSNGkzE918fSAEWr9gewjt0OjAfCKyi
        Q0AgBzSkyAndsDxTndrSB++yCmGC9pGYINjNIbU25TDQyk6q
X-Google-Smtp-Source: APXvYqyONdgzswDRKfG1rhocXQ7TVEMtch8eeq/tqqhxi82eDLzCNnoaJ2Bd3fTC9XZdSe5R8UP1ZRpOsy1KxhBq992CW6Yxw+1L
MIME-Version: 1.0
X-Received: by 2002:a5e:8f41:: with SMTP id x1mr3578346iop.113.1580379252307;
 Thu, 30 Jan 2020 02:14:12 -0800 (PST)
Date:   Thu, 30 Jan 2020 02:14:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1bced059d58b712@google.com>
Subject: WARNING in default_device_exit_batch
From:   syzbot <syzbot+dfdfbdef099aa0f92df1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        gnault@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    08a45c59 Merge branch 'mptcp-part-two'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1799f721e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d2cca7133bc3ccc
dashboard link: https://syzkaller.appspot.com/bug?extid=dfdfbdef099aa0f92df1
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+dfdfbdef099aa0f92df1@syzkaller.appspotmail.com

bond2 (unregistering): Released all slaves
------------[ cut here ]------------
WARNING: CPU: 1 PID: 7 at net/core/dev.c:8782 rollback_registered_many+0xcca/0x1030 net/core/dev.c:8782
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7 Comm: kworker/u4:0 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:rollback_registered_many+0xcca/0x1030 net/core/dev.c:8782
Code: 6b 1a 00 00 48 c7 c6 40 b7 d6 88 48 c7 c7 20 b8 d6 88 c6 05 03 9f 52 04 01 e8 51 3b 20 fb 0f 0b e9 a1 fd ff ff e8 46 8b 4f fb <0f> 0b e9 76 fd ff ff e8 3a 8b 4f fb 0f 0b e9 af fa ff ff e8 2e 8b
RSP: 0018:ffffc90000cdf9c0 EFLAGS: 00010293
RAX: ffff8880a99a81c0 RBX: ffff888057e90000 RCX: ffffffff862571fe
RDX: 0000000000000000 RSI: ffffffff8625748a RDI: 0000000000000001
RBP: ffffc90000cdfae8 R08: ffff8880a99a81c0 R09: fffffbfff149c655
R10: fffffbfff149c654 R11: ffffffff8a4e32a7 R12: ffff8880946ee6c0
R13: dffffc0000000000 R14: 00000000a0105a01 R15: ffffc90000cdfac0
 unregister_netdevice_many.part.0+0x1b/0x1f0 net/core/dev.c:9912
 unregister_netdevice_many net/core/dev.c:9911 [inline]
 default_device_exit_batch+0x360/0x420 net/core/dev.c:10385
 ops_exit_list.isra.0+0x10c/0x160 net/core/net_namespace.c:175
 cleanup_net+0x549/0xb10 net/core/net_namespace.c:589
 process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
