Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245F8203CB0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgFVQhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:37:16 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54674 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgFVQhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:37:13 -0400
Received: by mail-io1-f72.google.com with SMTP id t23so12890067iog.21
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:37:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=dXpRaOSCV03GZrVNf0as05OY3tFtQlSGCWqY2/ykkOA=;
        b=uRs3xPCv6Q3J3CIqL186Zv7GjgWB2TD+YCkie0MR1XCBdfk5Qygpi8BJxjxiH8rfM2
         N58oGYHQQA8gumfjJXFUlOQJevUS3+lYydXMVbJgzl9XtCBCj6fVIAUSEGh53J2sidqX
         MuzufS8TeQZA6BbU374IS4bR40cnBBv/hDQczelFYzd2ySCKQHzXP3Up4uPn/5Va9bEG
         G+zSigjWZ6p0tyKFZHwHm3kMJK0zjvTQehMui1S6UeRNKQ8zeEtu+JVXh+c24B6qE6ew
         n4mvgcMPS5qYhTaTCHQlTX+IHZealx7K1VesdiQat6kV3cAl98j4LHdWDyQh858gdsGf
         MXCw==
X-Gm-Message-State: AOAM533IZHDGI0+rziHXnQkilI6BlbA5HY4+Jh4o0j1aqpytwf6fAEc2
        EAZCfhmfUty/yh7ugg5J82iUpVSgeVIzV011ZVnkWF0f5ww+
X-Google-Smtp-Source: ABdhPJxIVmrzZ3ErJSIFqeO5UfeDz1PCz021Swz4WKdBXUv991BkVC5hlSjGxBXGpM1nDcgOmD5cEfcIcJIZRD+RueNZ6821Ppdc
MIME-Version: 1.0
X-Received: by 2002:a6b:91d4:: with SMTP id t203mr19859440iod.149.1592843831156;
 Mon, 22 Jun 2020 09:37:11 -0700 (PDT)
Date:   Mon, 22 Jun 2020 09:37:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd2c6905a8aedaa8@google.com>
Subject: WARNING: suspicious RCU usage in tipc_udp_send_msg
From:   syzbot <syzbot+7b0553cceace6d4a2b82@syzkaller.appspotmail.com>
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

HEAD commit:    67c20de3 net: Add MODULE_DESCRIPTION entries to network mo..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16de7aed100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45c80de7244166e1
dashboard link: https://syzkaller.appspot.com/bug?extid=7b0553cceace6d4a2b82
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7b0553cceace6d4a2b82@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.8.0-rc1-syzkaller #0 Not tainted
-----------------------------
net/tipc/udp_media.c:241 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/1:17/1829:
 #0: ffff8880a6986538 ((wq_completion)cryptd){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff8880a6986538 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff8880a6986538 ((wq_completion)cryptd){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff8880a6986538 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff8880a6986538 ((wq_completion)cryptd){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff8880a6986538 ((wq_completion)cryptd){+.+.}-{0:0}, at: process_one_work+0x844/0x1690 kernel/workqueue.c:2240
 #1: ffffc90008e57dc0 ((work_completion)(&cpu_queue->work)){+.+.}-{0:0}, at: process_one_work+0x878/0x1690 kernel/workqueue.c:2244

stack backtrace:
CPU: 1 PID: 1829 Comm: kworker/1:17 Not tainted 5.8.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: cryptd cryptd_queue_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 tipc_udp_send_msg+0x3b1/0x480 net/tipc/udp_media.c:241
 tipc_aead_encrypt_done+0x204/0x3a0 net/tipc/crypto.c:761
 cryptd_aead_crypt+0xe8/0x1d0 crypto/cryptd.c:739
 cryptd_queue_worker+0x118/0x1b0 crypto/cryptd.c:181
 process_one_work+0x965/0x1690 kernel/workqueue.c:2269
 worker_thread+0x96/0xe10 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:291
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
