Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D18020B698
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgFZRJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:09:30 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51434 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgFZRJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:09:17 -0400
Received: by mail-io1-f70.google.com with SMTP id x22so6704418ion.18
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:09:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PBbQ7cEucEY6CoFv1tPjVkpwYW+FAyD/Jgb/7La4UR0=;
        b=MWlSQk7i3mkm/MoAYPWE3TLVPzKwCxSwH4tX4/5e5xA5jpi7ld1WHhd8NjwpTiaOWN
         K5Fnmn2q7sbz1Ri0lX6RMSFXzgrf3aUJvehjNmMAnUX276/PHzHbOr5zUW41bXtQEs5u
         GEvqROaNQLGBAkBOAroB7hWvWeYvWeqW6h2fW4vBsuMvKIE/3HwOWMQSibB82ioqs6mo
         lFkUhADRemviNEvs5NZZO1Ox5MBq1o8iG4hdC2QkYcSzuIOEF5lz2vMZxLTfmsBqB3hR
         8PwfhYHmEh1IpkMWaWXzWACxTjcss9+nwLeBNonOsrm0tLrmelZzFd//oA7lbN7pInNl
         sFgg==
X-Gm-Message-State: AOAM532IriXFJFALp5l3bBBcNDlUcr7gQGrVlT3C6vlc7IjCeMWCfgyn
        +BTOSwldpbiOk8Z2pKCOH9mHC3Bes/89arNJZl6lkVORQXaZ
X-Google-Smtp-Source: ABdhPJwo34ysGkyv29CtoQpNVf4erXuROmB97DMaZVck/VNCBt76LB/yd69y+ehgAjxiWf1lFIoTWgGPqW8RUdwKsMMkoOKTe6Tt
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2f0f:: with SMTP id q15mr4553270iow.23.1593191355911;
 Fri, 26 Jun 2020 10:09:15 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:09:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d411cf05a8ffc4a6@google.com>
Subject: WARNING: suspicious RCU usage in tipc_l2_send_msg
From:   syzbot <syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b835a71e usbnet: smsc95xx: Fix use-after-free after removal
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1095a51d100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcc6334acae363d4
dashboard link: https://syzkaller.appspot.com/bug?extid=47bbc6b678d317cccbe0
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.8.0-rc1-syzkaller #0 Not tainted
-----------------------------
net/tipc/bearer.c:466 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/0:16/19143:
 #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a6901d38 ((wq_completion)cryptd){+.+.}-{0:0}, at: process_one_work+0x82b/0x1670 kernel/workqueue.c:2240
 #1: ffffc90006f9fda8 ((work_completion)(&cpu_queue->work)){+.+.}-{0:0}, at: process_one_work+0x85f/0x1670 kernel/workqueue.c:2244

stack backtrace:
CPU: 0 PID: 19143 Comm: kworker/0:16 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: cryptd cryptd_queue_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 tipc_l2_send_msg+0x354/0x420 net/tipc/bearer.c:466
 tipc_aead_encrypt_done+0x204/0x3a0 net/tipc/crypto.c:761
 cryptd_aead_crypt+0xe8/0x1d0 crypto/cryptd.c:739
 cryptd_queue_worker+0x118/0x1b0 crypto/cryptd.c:181
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
