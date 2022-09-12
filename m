Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49F5B52AE
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 04:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiILCah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 22:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiILCag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 22:30:36 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105D8222B0
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 19:30:35 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id x14-20020a056e021cae00b002f1d5aca8c6so5446202ill.5
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 19:30:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=Di8X3M089ryXIqSi+X0Mg31Ntg6oMjT7LU5Szyi7A3w=;
        b=i0LvkPBRzfTxxnPL6Q6NwyVjgoyfe+oR9RR30faPVGDKjUQZxxYP6jA34lHgZKUpI8
         Tvyw/xft8BPo9Fwp3EV8xS/WZUz3cp56LXPddkQSk2xUlIHT4ttGQ0Ne5/a0XS6iTvmA
         mm14muB7u9M5HI5m0AJJTP3DhWM1Uth3Rwq837lWxhsoPnA47iFCYczOnURu/CDPXjBx
         hTCgbRDDx+1eZj8B21C55zTear5RddcYutVNAWwdvu870QDAzD132hsy/evgc9hGkKPO
         ayEml4xCPVdUxm0ZNlqbnbd4XE5HqtvurOqnQoRlUzbFFiz7kfpzT7Ks97Leiboa/z+9
         lZvQ==
X-Gm-Message-State: ACgBeo2WdCjJg1iI0OUwGEP4ZmQ1SpI8t1zfguArNkHABsVJJ5855THr
        9OyQ1AOl6AwDoXC6b4rJnbc3cFkbJIqE4YlOQermvb7ifGnW
X-Google-Smtp-Source: AA6agR6+f7p5acvwqLPa9Pb6cHQfFlwOBU+iwU5Wz24RKd2sKBrKMv9FwEDc2tStnV2uxSQO0FDRXC3Io45MlZF/8v3Eej5JHC5D
MIME-Version: 1.0
X-Received: by 2002:a02:a791:0:b0:35a:14c6:f1e3 with SMTP id
 e17-20020a02a791000000b0035a14c6f1e3mr4787884jaj.215.1662949834322; Sun, 11
 Sep 2022 19:30:34 -0700 (PDT)
Date:   Sun, 11 Sep 2022 19:30:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000027774b05e871ae18@google.com>
Subject: [syzbot] WARNING in j1939_tp_rxtimer (2)
From:   syzbot <syzbot+34dcf6bbda0e05f6b3ed@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kernel@pengutronix.de,
        kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rempel-privat.de,
        mkl@pengutronix.de, netdev@vger.kernel.org, pabeni@redhat.com,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0066f1b0e275 afs: Return -EAGAIN, not -EREMOTEIO, when a f..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=124a4c8f080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5971bb33b0db1ef1
dashboard link: https://syzkaller.appspot.com/bug?extid=34dcf6bbda0e05f6b3ed
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+34dcf6bbda0e05f6b3ed@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 15 at net/can/j1939/transport.c:1096 j1939_session_deactivate_activate_next net/can/j1939/transport.c:1106 [inline]
WARNING: CPU: 0 PID: 15 at net/can/j1939/transport.c:1096 j1939_tp_rxtimer+0x821/0xa20 net/can/j1939/transport.c:1234
Modules linked in:
CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 6.0.0-rc4-syzkaller-00062-g0066f1b0e275 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:j1939_session_deactivate net/can/j1939/transport.c:1096 [inline]
RIP: 0010:j1939_session_deactivate_activate_next net/can/j1939/transport.c:1106 [inline]
RIP: 0010:j1939_tp_rxtimer+0x821/0xa20 net/can/j1939/transport.c:1234
Code: e8 c4 62 44 f8 48 8b 3c 24 e9 0a f9 ff ff e8 b6 62 44 f8 4c 89 f7 be 03 00 00 00 e8 79 7f f0 fa e9 52 f9 ff ff e8 9f 62 44 f8 <0f> 0b e9 fa f9 ff ff e8 93 62 44 f8 0f 0b e9 21 fb ff ff e8 87 62
RSP: 0018:ffffc90000147a90 EFLAGS: 00010246
RAX: ffffffff89453641 RBX: 0000000000000001 RCX: ffff8880122e3b00
RDX: 0000000000000301 RSI: 0000000000000001 RDI: 0000000000000002
RBP: dffffc0000000000 R08: ffffffff89453034 R09: ffffed100f764506
R10: ffffed100f764506 R11: 1ffff1100f764505 R12: 1ffff1100f764500
R13: ffff88807bb22800 R14: 1ffff1100f76451b R15: ffff88807bb228d8
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001000 CR3: 000000001f158000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x50b/0xa60 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0x1a1/0x580 kernel/time/hrtimer.c:1766
 __do_softirq+0x382/0x793 kernel/softirq.c:571
 run_ksoftirqd+0xc1/0x120 kernel/softirq.c:934
 smpboot_thread_fn+0x533/0x9d0 kernel/smpboot.c:164
 kthread+0x266/0x300 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
