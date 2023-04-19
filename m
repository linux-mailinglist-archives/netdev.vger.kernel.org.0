Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31A06E75DE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbjDSJAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 05:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbjDSJAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 05:00:03 -0400
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE407A93
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:59:58 -0700 (PDT)
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-32879a859d8so30914815ab.3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:59:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681894798; x=1684486798;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MMkdzP0b48/FfooAPyZtmjuW8LPUSS+nUb/pxSQhWlg=;
        b=D5YRDpevTfOEx0Uqe2qa9t8p/zgUnH/Zz9k+6BkBKfhdQC626Y2n72NYs3GpY7MsuB
         5RRoXdqP7gX5B65her4eXhmro2nVHE0rDJkn4u4HGTzi7RETSq2J/vyqlj++CK9aRPgn
         DMSZALR0BJYnqW4uoH2HPnfoBBQZdXpjnlBidppFV45ENTC1MFwbnCSe0FWPtRjvcUoM
         ffu4kUF4CJsybwI3yuDCr9JEjWkigAPWHRO0iUdPvotzL3hpmHTZJxkJXJD5ZTqL7ddv
         CWjWssZK5/XKMPa9zsaYgn/3HWbfM2zHX5FITPu0SfRsCeL+/7/X8itWCa63duLK/KLN
         NSDA==
X-Gm-Message-State: AAQBX9dwx94Bt1Hg05zs8kfRTonLmQF2+Px6omx8u9B+5yyrTc5Insqs
        wed53hWJnoV9fUeZx2ERy1pGr0PJ2Ub5Zy2yokqKo7BEXpOC
X-Google-Smtp-Source: AKy350YS7UotbFKDn4cXkfgdpzwLgB4VfRkMQdy69IH+g+usQkhflYv2ItYDgPF/EyaTfZTia01joq3s7l4rOq5j4NaAHLLgiYUH
MIME-Version: 1.0
X-Received: by 2002:a92:cc05:0:b0:326:d02c:c756 with SMTP id
 s5-20020a92cc05000000b00326d02cc756mr9976703ilp.4.1681894798045; Wed, 19 Apr
 2023 01:59:58 -0700 (PDT)
Date:   Wed, 19 Apr 2023 01:59:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fcbbf805f9aca52b@google.com>
Subject: [syzbot] [bluetooth?] WARNING: bad unlock balance in l2cap_disconnect_rsp
From:   syzbot <syzbot+180f35f8e76c7af067d2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    327bf9bb94cf Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=107f83b7c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64943844c9bf6c7e
dashboard link: https://syzkaller.appspot.com/bug?extid=180f35f8e76c7af067d2
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/66410afe54f5/disk-327bf9bb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2757ce5e2a55/vmlinux-327bf9bb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7d54ee97c182/Image-327bf9bb.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+180f35f8e76c7af067d2@syzkaller.appspotmail.com

=====================================
WARNING: bad unlock balance detected!
6.3.0-rc7-syzkaller-g327bf9bb94cf #0 Not tainted
-------------------------------------
kworker/u5:3/6019 is trying to release lock (&conn->chan_lock) at:
[<ffff80001157e164>] l2cap_disconnect_rsp+0x210/0x30c net/bluetooth/l2cap_core.c:4697
but there are no more locks to release!

other info that might help us debug this:
2 locks held by kworker/u5:3/6019:
 #0: ffff0000c0e30938 ((wq_completion)hci0#2){+.+.}-{0:0}, at: process_one_work+0x664/0x12d4 kernel/workqueue.c:2363
 #1: ffff80001ea87c20 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0}, at: process_one_work+0x6a8/0x12d4 kernel/workqueue.c:2365

stack backtrace:
CPU: 1 PID: 6019 Comm: kworker/u5:3 Not tainted 6.3.0-rc7-syzkaller-g327bf9bb94cf #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
Workqueue: hci0 hci_rx_work
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:233
 show_stack+0x2c/0x44 arch/arm64/kernel/stacktrace.c:240
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd0/0x124 lib/dump_stack.c:106
 dump_stack+0x1c/0x28 lib/dump_stack.c:113
 print_unlock_imbalance_bug+0x250/0x2a4 kernel/locking/lockdep.c:5109
 lock_release+0x4ac/0x9ac kernel/locking/lockdep.c:5689
 __mutex_unlock_slowpath+0xe0/0x6b4 kernel/locking/mutex.c:907
 mutex_unlock+0x18/0x24 kernel/locking/mutex.c:543
 l2cap_disconnect_rsp+0x210/0x30c net/bluetooth/l2cap_core.c:4697
 l2cap_le_sig_cmd net/bluetooth/l2cap_core.c:6426 [inline]
 l2cap_le_sig_channel net/bluetooth/l2cap_core.c:6464 [inline]
 l2cap_recv_frame+0x18b4/0x6a14 net/bluetooth/l2cap_core.c:7796
 l2cap_recv_acldata+0x4f4/0x163c net/bluetooth/l2cap_core.c:8504
 hci_acldata_packet net/bluetooth/hci_core.c:3828 [inline]
 hci_rx_work+0x2cc/0x8b8 net/bluetooth/hci_core.c:4063
 process_one_work+0x788/0x12d4 kernel/workqueue.c:2390
 worker_thread+0x8e0/0xfe8 kernel/workqueue.c:2537
 kthread+0x24c/0x2d4 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:870


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
