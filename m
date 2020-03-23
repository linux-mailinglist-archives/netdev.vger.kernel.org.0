Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD318F280
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgCWKON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:14:13 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:38404 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbgCWKON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:14:13 -0400
Received: by mail-il1-f199.google.com with SMTP id b6so2652140iln.5
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 03:14:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=u+rB3SW6o4DvS+SPLlwabuVCXm5AqVecTMnBRK2Eb+I=;
        b=OnD6wiXrbfpNEnSEzlm7ujyj4HH+SNfZY9jlZg2RBILdAzjWJ+/orWYgx35N0ctgsN
         CejPpPTXaACyWdm3llEWgxHddUwYJsDAdfp8cOKiQ9uw6Xqq4Vzqi5GwKP/OGvpERaS6
         pS0wy/PwrbDg8teCupOW6oYq3HPliQBc6NZNiYiW48+sJtRAFEITJUK6t9zafAuS8IRd
         jWBXiZyaodLZFrg/GFVC2e/xTIbI/2JiMQJhGuxhpe/UM7hAyQs1/4HnKXS8Pm5T2S6Z
         NFvJqQNRuasLxVqxv1XIuUKJ7leDqahm5S/SI/p+m0Dtj9xFxeCf8XcOAiNkGn/Isou9
         At3w==
X-Gm-Message-State: ANhLgQ0+oZQBG0hoXg7H7pU0NRrUuJlH4YEOL2d/VJkzff7/VhFUu8+O
        NUftZLa/RbyPIYRFd9ARmtajiTmCXUtOIphTAKhFR5eKroFi
X-Google-Smtp-Source: ADFU+vun/1oVfmU096HrnsnY2BobDnoumvl101P8txHWxjSYeyZs70lTaJ1kc+TovMNzjkaCtA2STMujEFdc+u+BeomqKltKh/am
MIME-Version: 1.0
X-Received: by 2002:a02:3808:: with SMTP id b8mr19923887jaa.136.1584958452322;
 Mon, 23 Mar 2020 03:14:12 -0700 (PDT)
Date:   Mon, 23 Mar 2020 03:14:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088d4fd05a182e5c9@google.com>
Subject: general protection fault in hfsc_unbind_tcf
From:   syzbot <syzbot+05e596c4433eae36069b@syzkaller.appspotmail.com>
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

HEAD commit:    770fbb32 Add linux-next specific files for 20200228
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1433a7c3e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=576314276bce4ad5
dashboard link: https://syzkaller.appspot.com/bug?extid=05e596c4433eae36069b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+05e596c4433eae36069b@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xfbd5a5d5a000000b: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead4ead00000058-0xdead4ead0000005f]
CPU: 1 PID: 1558 Comm: kworker/u4:0 Not tainted 5.6.0-rc3-next-20200228-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:hfsc_unbind_tcf+0x1e/0x40 net/sched/sch_hfsc.c:1238
Code: fb eb af e8 d4 d4 79 fb eb de 66 90 53 48 89 f3 e8 27 b4 3c fb 48 8d 7b 58 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 04 3c 03 7e 06 83 6b 58 01 5b c3 e8 8b d4 79
RSP: 0018:ffffc90002427630 EFLAGS: 00010a02
RAX: dffffc0000000000 RBX: dead4ead00000000 RCX: ffffffff86419d1e
RDX: 1bd5a9d5a000000b RSI: ffffffff8635e159 RDI: dead4ead00000058
RBP: ffff8880907d9300 R08: ffff888093d3c3c0 R09: ffffed10120fb263
R10: ffffed10120fb262 R11: ffff8880907d9317 R12: dead4ead00000000
R13: ffff88809e0a9000 R14: dffffc0000000000 R15: ffffffff8a86bbe0
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000c2c0 CR3: 000000006894c000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __tcf_unbind_filter include/net/pkt_cls.h:176 [inline]
 tcf_unbind_filter include/net/pkt_cls.h:186 [inline]
 route4_destroy+0x36b/0x820 net/sched/cls_route.c:297
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
 dev_shutdown+0x2b5/0x492 net/sched/sch_generic.c:1311
 rollback_registered_many+0x603/0xe70 net/core/dev.c:8802
 unregister_netdevice_many.part.0+0x16/0x1e0 net/core/dev.c:9965
 unregister_netdevice_many net/core/dev.c:9964 [inline]
 default_device_exit_batch+0x311/0x3d0 net/core/dev.c:10448
 ops_exit_list.isra.0+0x103/0x150 net/core/net_namespace.c:175
 cleanup_net+0x511/0xa50 net/core/net_namespace.c:589
 process_one_work+0x94b/0x1690 kernel/workqueue.c:2266
 worker_thread+0x96/0xe20 kernel/workqueue.c:2412
 kthread+0x357/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 4e5544fa17900677 ]---
RIP: 0010:hfsc_unbind_tcf+0x1e/0x40 net/sched/sch_hfsc.c:1238
Code: fb eb af e8 d4 d4 79 fb eb de 66 90 53 48 89 f3 e8 27 b4 3c fb 48 8d 7b 58 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 04 3c 03 7e 06 83 6b 58 01 5b c3 e8 8b d4 79
RSP: 0018:ffffc90002427630 EFLAGS: 00010a02
RAX: dffffc0000000000 RBX: dead4ead00000000 RCX: ffffffff86419d1e
RDX: 1bd5a9d5a000000b RSI: ffffffff8635e159 RDI: dead4ead00000058
RBP: ffff8880907d9300 R08: ffff888093d3c3c0 R09: ffffed10120fb263
R10: ffffed10120fb262 R11: ffff8880907d9317 R12: dead4ead00000000
R13: ffff88809e0a9000 R14: dffffc0000000000 R15: ffffffff8a86bbe0
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000002736978 CR3: 0000000091659000 CR4: 00000000001426e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
