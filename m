Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D090A209A7A
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 09:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390298AbgFYH3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 03:29:16 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:36935 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390126AbgFYH3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 03:29:15 -0400
Received: by mail-il1-f199.google.com with SMTP id x23so588575ilk.4
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 00:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eSUsWxA/cZb+cZ8s0wASgZp18eK0usgT9h/9kGr+TFU=;
        b=VQY7lWEq7FmKgUaPybtGV3F6eFocz890+5ur8pQoJjqAk3vbbMNqW2Qe4egEn4TlxJ
         ZZe6a4GddfBpZFeV3Fga0tKH3WYf+4HPHuUoxZGhfpMG/qfmPSZIYRKDztfRdhgDRGF8
         ivauyfTGRaK2Yry3oBOrEtoPzWLArwbYBRy3zhtpNrLrgpS9f7xaVzSHXIr50l9tSs9X
         PHlyO13ti82PZXx0a+yHKYBuCMN4UrAv83tUYHV585NIoR4nGv5Xy6oSZP18gNPDnI+1
         6voxqhVWFxmaWm9DoXJWvO+s0dkUIMiRTrtZ58xEMJVwxqAE1I/njm/yAUZlQbu6ydTG
         VU6w==
X-Gm-Message-State: AOAM532ZXLaHZYtWsnRND7sB5oray/AKVaxRbRArYC3Nw4DddoQsLWTv
        OGMOShFDPNnQJpgoBVw3vBzZwkzo9QJXL86hjf8CiUDcZc89
X-Google-Smtp-Source: ABdhPJzi5iGfcoQoGxMWTgbEAgIXViv/KeBmTdqngU3rg5bsh1IJierQMl3IaLsK2V6j6+mKPaFliuur3jilA0FEpWjCFAJxBk/S
MIME-Version: 1.0
X-Received: by 2002:a92:5895:: with SMTP id z21mr6589340ilf.81.1593070154797;
 Thu, 25 Jun 2020 00:29:14 -0700 (PDT)
Date:   Thu, 25 Jun 2020 00:29:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000add83505a8e38c4c@google.com>
Subject: WARNING: suspicious RCU usage in ctrl_cmd_new_lookup
From:   syzbot <syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=14a3bcf9100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=3025b9294f8cb0ede850
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11802cf9100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144acc03100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.7.0-syzkaller #0 Not tainted
-----------------------------
include/linux/radix-tree.h:176 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by kworker/u4:0/7:
 #0: ffff88821b0bd138 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: __write_once_size include/linux/compiler.h:279 [inline]
 #0: ffff88821b0bd138 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88821b0bd138 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:855 [inline]
 #0: ffff88821b0bd138 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:40 [inline]
 #0: ffff88821b0bd138 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:615 [inline]
 #0: ffff88821b0bd138 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
 #0: ffff88821b0bd138 ((wq_completion)qrtr_ns_handler){+.+.}-{0:0}, at: process_one_work+0x844/0x16a0 kernel/workqueue.c:2239
 #1: ffffc90000cdfdc0 ((work_completion)(&qrtr_ns.work)){+.+.}-{0:0}, at: process_one_work+0x878/0x16a0 kernel/workqueue.c:2243

stack backtrace:
CPU: 1 PID: 7 Comm: kworker/u4:0 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: qrtr_ns_handler qrtr_ns_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 radix_tree_deref_slot include/linux/radix-tree.h:176 [inline]
 radix_tree_deref_slot include/linux/radix-tree.h:174 [inline]
 ctrl_cmd_new_lookup+0x6eb/0x7e0 net/qrtr/ns.c:558
 qrtr_ns_worker+0x5a1/0x153a net/qrtr/ns.c:674
 process_one_work+0x965/0x16a0 kernel/workqueue.c:2268


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
