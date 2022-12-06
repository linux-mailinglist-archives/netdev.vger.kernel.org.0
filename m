Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE6644C3A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiLFTJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLFTJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:09:45 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B69E2CDD9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 11:09:43 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id h9-20020a92c269000000b00303494c4f3eso9030306ild.15
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 11:09:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gPTDD3O7OCiIToPXqJ437FBhAuiqpMgLYsRmVm/3OK0=;
        b=kCsrwxoYeXTyG/7A5l2VyDRHO/GSKkXTzNyd/Z2l7qINSC2wzh++wrAC13UYORVJ5r
         EGsOZENRZ1jk5X7KC2pHdhZ18A9vF14SpbLr7C5kYbzRF1TtGGKHL2a9VSmEX1XVZsrH
         Bw9m5wCvFsTuEOgmOvCDRKtfYDYgBxcoSNQguxrAp9P9syZk7kmWYyJSDV+lCAPqRSe6
         NhpMlIbFBxQvHffPkaZpf4bNEvs/+Gw8bKm4+PHdhteSkZ9mRcOnmO0IJgq0N1mnmzHV
         1xUdPU+vJlhuEYjiTpffqcPiY/cyySlKGAbldAjoX1dSDSCHuZFYb4MJEH0sU4ADuFEd
         aGpA==
X-Gm-Message-State: ANoB5pmGHhIGr/AWIBoRDyeTJc7NwMH2QaWGVafkeW45u6K0Aw4WTF7d
        qli1A5xMlmfCE1UiFIPnC5DVlsV9waodL5sBtBlViFsijUxr
X-Google-Smtp-Source: AA0mqf5IRDZRSHz3a4UGFpM882TVTgU6Zf00KsHOjXmtkZEAcxRtta+3uzZeQrfhUcAiXAsevGERPqbSWKV0od3n2rWtfBZO/RjU
MIME-Version: 1.0
X-Received: by 2002:a6b:5a12:0:b0:6de:f46d:fc8b with SMTP id
 o18-20020a6b5a12000000b006def46dfc8bmr30708440iob.50.1670353782887; Tue, 06
 Dec 2022 11:09:42 -0800 (PST)
Date:   Tue, 06 Dec 2022 11:09:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e0df2d05ef2d8b91@google.com>
Subject: [syzbot] memory leak in tcindex_set_parms (3)
From:   syzbot <syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    355479c70a48 Merge tag 'efi-fixes-for-v6.1-4' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16aef6bd880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=979161df0e247659
dashboard link: https://syzkaller.appspot.com/bug?extid=2f9183cb6f89b0e16586
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d1ac47880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154f3bad880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/104ddf75422d/disk-355479c7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d32483369fdb/vmlinux-355479c7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f10fb444c08d/bzImage-355479c7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f9183cb6f89b0e16586@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff888107813900 (size 256):
  comm "syz-executor147", pid 3623, jiffies 4294944130 (age 12.710s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
    [<ffffffff83c0dda7>] kmalloc include/linux/slab.h:553 [inline]
    [<ffffffff83c0dda7>] kmalloc_array include/linux/slab.h:604 [inline]
    [<ffffffff83c0dda7>] kcalloc include/linux/slab.h:636 [inline]
    [<ffffffff83c0dda7>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
    [<ffffffff83c0dda7>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
    [<ffffffff83c0e9bf>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
    [<ffffffff83b91842>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
    [<ffffffff83ae1b6c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
    [<ffffffff83c2fae7>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
    [<ffffffff83c2ec07>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83c2ec07>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83c2f0c6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff83a812f6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83a812f6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff83a81668>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
    [<ffffffff83a86218>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff83a86565>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
    [<ffffffff83a867b4>] __do_sys_sendmmsg net/socket.c:2651 [inline]
    [<ffffffff83a867b4>] __se_sys_sendmmsg net/socket.c:2648 [inline]
    [<ffffffff83a867b4>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
    [<ffffffff8485b3b5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff8485b3b5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810ea1af00 (size 256):
  comm "syz-executor147", pid 3623, jiffies 4294944131 (age 12.700s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
    [<ffffffff83c0dda7>] kmalloc include/linux/slab.h:553 [inline]
    [<ffffffff83c0dda7>] kmalloc_array include/linux/slab.h:604 [inline]
    [<ffffffff83c0dda7>] kcalloc include/linux/slab.h:636 [inline]
    [<ffffffff83c0dda7>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
    [<ffffffff83c0dda7>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
    [<ffffffff83c0e9bf>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
    [<ffffffff83b91842>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
    [<ffffffff83ae1b6c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
    [<ffffffff83c2fae7>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
    [<ffffffff83c2ec07>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83c2ec07>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83c2f0c6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff83a812f6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83a812f6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff83a81668>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
    [<ffffffff83a86218>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff83a86565>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
    [<ffffffff83a867b4>] __do_sys_sendmmsg net/socket.c:2651 [inline]
    [<ffffffff83a867b4>] __se_sys_sendmmsg net/socket.c:2648 [inline]
    [<ffffffff83a867b4>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
    [<ffffffff8485b3b5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff8485b3b5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

BUG: memory leak
unreferenced object 0xffff88810a452680 (size 64):
  comm "kworker/0:1", pid 42, jiffies 4294944576 (age 8.250s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    ff ff ff ff 00 00 00 00 00 00 00 00 30 30 00 00  ............00..
  backtrace:
    [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
    [<ffffffff842bb5c2>] kmalloc include/linux/slab.h:553 [inline]
    [<ffffffff842bb5c2>] kzalloc include/linux/slab.h:689 [inline]
    [<ffffffff842bb5c2>] regulatory_hint_core+0x22/0x60 net/wireless/reg.c:3248
    [<ffffffff842c1720>] restore_regulatory_settings+0x690/0x910 net/wireless/reg.c:3582
    [<ffffffff842c1aad>] crda_timeout_work+0x1d/0x30 net/wireless/reg.c:540
    [<ffffffff8129197a>] process_one_work+0x2ba/0x5f0 kernel/workqueue.c:2289
    [<ffffffff81292299>] worker_thread+0x59/0x5b0 kernel/workqueue.c:2436
    [<ffffffff8129c315>] kthread+0x125/0x160 kernel/kthread.c:376
    [<ffffffff8100224f>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

BUG: memory leak
unreferenced object 0xffff88810e11c100 (size 256):
  comm "syz-executor147", pid 3629, jiffies 4294944659 (age 7.420s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814eda10>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
    [<ffffffff83c0dda7>] kmalloc include/linux/slab.h:553 [inline]
    [<ffffffff83c0dda7>] kmalloc_array include/linux/slab.h:604 [inline]
    [<ffffffff83c0dda7>] kcalloc include/linux/slab.h:636 [inline]
    [<ffffffff83c0dda7>] tcf_exts_init include/net/pkt_cls.h:250 [inline]
    [<ffffffff83c0dda7>] tcindex_set_parms+0xa7/0xbe0 net/sched/cls_tcindex.c:342
    [<ffffffff83c0e9bf>] tcindex_change+0xdf/0x120 net/sched/cls_tcindex.c:553
    [<ffffffff83b91842>] tc_new_tfilter+0x4f2/0x1100 net/sched/cls_api.c:2147
    [<ffffffff83ae1b6c>] rtnetlink_rcv_msg+0x4dc/0x5d0 net/core/rtnetlink.c:6082
    [<ffffffff83c2fae7>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2540
    [<ffffffff83c2ec07>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83c2ec07>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83c2f0c6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff83a812f6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83a812f6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff83a81668>] ____sys_sendmsg+0x178/0x410 net/socket.c:2482
    [<ffffffff83a86218>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff83a86565>] __sys_sendmmsg+0x105/0x330 net/socket.c:2622
    [<ffffffff83a867b4>] __do_sys_sendmmsg net/socket.c:2651 [inline]
    [<ffffffff83a867b4>] __se_sys_sendmmsg net/socket.c:2648 [inline]
    [<ffffffff83a867b4>] __x64_sys_sendmmsg+0x24/0x30 net/socket.c:2648
    [<ffffffff8485b3b5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff8485b3b5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
