Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390A519066F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 08:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgCXHkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 03:40:14 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:43753 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgCXHkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 03:40:14 -0400
Received: by mail-io1-f71.google.com with SMTP id b21so14161294iot.10
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 00:40:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7B4kfMh39+8DdH4Qp0mkLrAt9ER1GH0d0UIRcScJtEs=;
        b=IGtfg34hVNAaKfp02m/cUOUG4MGyJZO8HQ5xvEKQ11HUVONmIXULBPehVBu6akTkg/
         SBtw19iO2HWLD1SYEUQZ1AS0MVyR9cJgVWFez0STJahH6PCw74JHAbY021mSX+Jlp13x
         9Ht7Vp/2q/0wOyTnRzp+c3PbIpa14E/zDd02zXWAuPkjw0ryZ5X4Cc3fgA4B6B4Q7/1Q
         mTYICK0oEADSDlfd+xOAnt42V6Bn7npQZSO0gitrw7rB7hrr47BN+wvbusEPPg3UMsny
         RBcPzxaVRMILJjcuMjoq94mi6BKMRbDKKxo6TfFZPCDtJ8gTAd5u2WEFJX5mWmtvsRVg
         jVOA==
X-Gm-Message-State: ANhLgQ1DcY9V0TXWQe3OLHQPSWt1U6pLGFYuPxePWHb2FEgiTrZDAp+b
        bMArRQtao/LnBUBc8RuNqfTmlVQz0YAVYxxlOi0r9yIkPJEG
X-Google-Smtp-Source: ADFU+vsHuYVF/h1qjUhCD4/SGZ5h85xy9+ItYSbssSQpH94LZyOHAEX5oyBMY+bwKhCOuyVdvNgDdzdB2chcrGnY6+BRnW2aQxxE
MIME-Version: 1.0
X-Received: by 2002:a6b:1451:: with SMTP id 78mr23368265iou.23.1585035612280;
 Tue, 24 Mar 2020 00:40:12 -0700 (PDT)
Date:   Tue, 24 Mar 2020 00:40:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a0627105a194dc93@google.com>
Subject: WARNING: refcount bug in route4_destroy
From:   syzbot <syzbot+36788b38ba78ab3c9c1f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd607737 Merge tag '5.6-rc6-smb3-fixes' of git://git.samba..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f4561de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9f894bd92023de02
dashboard link: https://syzkaller.appspot.com/bug?extid=36788b38ba78ab3c9c1f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+36788b38ba78ab3c9c1f@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 1 PID: 26742 at lib/refcount.c:19 refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 26742 Comm: kworker/u4:3 Not tainted 5.6.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:refcount_warn_saturate+0xf4/0x1e0 lib/refcount.c:19
Code: 1d 24 4d d2 06 31 ff 89 de e8 e8 47 e3 fd 84 db 75 ab e8 af 46 e3 fd 48 c7 c7 00 a9 51 88 c6 05 04 4d d2 06 01 e8 94 57 b5 fd <0f> 0b eb 8f e8 93 46 e3 fd 0f b6 1d ee 4c d2 06 31 ff 89 de e8 b3
RSP: 0018:ffffc90004667628 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c06c1 RDI: fffff520008cceb7
RBP: 0000000000000000 R08: ffff88808f87a100 R09: fffffbfff180e578
R10: fffffbfff180e577 R11: ffffffff8c072bbf R12: ffff88809fca7004
R13: 00000000ffff8801 R14: dffffc0000000000 R15: ffff88809fca7000
 refcount_add_not_zero include/linux/refcount.h:165 [inline]
 refcount_inc_not_zero include/linux/refcount.h:211 [inline]
 maybe_get_net include/net/net_namespace.h:252 [inline]
 tcf_exts_get_net include/net/pkt_cls.h:227 [inline]
 route4_destroy+0x534/0x800 net/sched/cls_route.c:298
 tcf_proto_destroy+0x6e/0x310 net/sched/cls_api.c:296
 tcf_proto_put+0x8c/0xc0 net/sched/cls_api.c:308
 tcf_chain_flush+0x266/0x390 net/sched/cls_api.c:600
 tcf_block_flush_all_chains net/sched/cls_api.c:1052 [inline]
 __tcf_block_put+0x1a4/0x540 net/sched/cls_api.c:1214
 tcf_block_put_ext net/sched/cls_api.c:1414 [inline]
 tcf_block_put+0xb3/0x100 net/sched/cls_api.c:1429
 hfsc_destroy_qdisc+0xe0/0x280 net/sched/sch_hfsc.c:1501
 qdisc_destroy+0x118/0x690 net/sched/sch_generic.c:958
 qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:985
 dev_shutdown+0x2b5/0x486 net/sched/sch_generic.c:1311
 rollback_registered_many+0x603/0xe70 net/core/dev.c:8803
 unregister_netdevice_many.part.0+0x16/0x1e0 net/core/dev.c:9966
 unregister_netdevice_many net/core/dev.c:9965 [inline]
 default_device_exit_batch+0x311/0x3d0 net/core/dev.c:10442
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:175
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:589
 process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
