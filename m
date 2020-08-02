Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD4E2357CE
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 16:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHBO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 10:58:19 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40300 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgHBO6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 10:58:16 -0400
Received: by mail-io1-f69.google.com with SMTP id t22so15532633iob.7
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 07:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rP8qFuAIj5PA4GqYTY6invSs7s5chTKGJL4gZOv9MdY=;
        b=SLRgQ2+B8uqQCUZ8HcYPtew1vU+XCBW4Abot2NOyV8hVUVL9g8D+vu5sxVlKfB7M5N
         jNo5OA6oqWrYdiXpAUj7TDIqeeBMoIZXd8z8tOsg7AUoMpLjg76RyzAeMkXeaQdXKC4r
         Sc0O5qATctIW75PLh0km6Le8bOljKoVfhQ4c4ZZX5DaHpBH/9JpYyAPLUHNk+hhrKw+S
         /mMRtvg655kQtzP7ZdWLmqCvcr/D0ujMovYuK1sgYrpnJSAKGJex5qWLtCLAdbC1XeGy
         skPFTnQR2zdGBcBguAmnZxgW9iK21l/pEZ6j1oGukpvBzMyP2NKXlWbd7TmSdVekBGNe
         Qa2w==
X-Gm-Message-State: AOAM532rY/0srEj5bfLu3h1mRQ4l30y2QX9QOtSuFYKjO8I2y5Z/bslA
        ov/zA8tRHoYQ9pkM8Ldj18iO455QbpfgCzk15QSRvvtvgdHV
X-Google-Smtp-Source: ABdhPJx9ALeHovUaCpJtg/QHit8tfWWHnVJ9RsvBsueoJYR9kZOfzHYl19tkkKfuQ3rlXOOSq2JcbkvVksIk0rI4isSp62iyhVn9
MIME-Version: 1.0
X-Received: by 2002:a92:9116:: with SMTP id t22mr4949412ild.305.1596380295789;
 Sun, 02 Aug 2020 07:58:15 -0700 (PDT)
Date:   Sun, 02 Aug 2020 07:58:15 -0700
In-Reply-To: <0000000000008b9e0705a38afe52@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000075030605abe640e5@google.com>
Subject: Re: WARNING: refcount bug in do_enable_set
From:   syzbot <syzbot+2e9900a1e1b3c9c96a77@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1194935c900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
dashboard link: https://syzkaller.appspot.com/bug?extid=2e9900a1e1b3c9c96a77
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10b7ddca900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=126dcf6c900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2e9900a1e1b3c9c96a77@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: CPU: 1 PID: 2540 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 2540 Comm: kworker/1:8 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events do_enable_set
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:540
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Code: c7 8a af 14 89 31 c0 e8 b3 f2 a8 fd 0f 0b eb 85 e8 2a 32 d7 fd c6 05 a4 d9 eb 05 01 48 c7 c7 b6 af 14 89 31 c0 e8 95 f2 a8 fd <0f> 0b e9 64 ff ff ff e8 09 32 d7 fd c6 05 84 d9 eb 05 01 48 c7 c7
RSP: 0018:ffffc90007d27c48 EFLAGS: 00010246
RAX: adb9104953f59b00 RBX: 0000000000000003 RCX: ffff8880a02d0540
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: ffffffff815dd389 R09: ffffed1015d262c0
R10: ffffed1015d262c0 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff8880a0259118 R14: dffffc0000000000 R15: ffff8880ae9350c0
 do_enable_set+0x66e/0x900 net/bluetooth/6lowpan.c:1083
 process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
 worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
 kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
Kernel Offset: disabled
Rebooting in 86400 seconds..

