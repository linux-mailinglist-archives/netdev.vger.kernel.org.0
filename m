Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011C24DE6F2
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 09:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242465AbiCSIRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 04:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiCSIRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 04:17:46 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BEF231936
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 01:16:25 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id e11-20020a5d8e0b000000b006412cf3f627so6596725iod.17
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 01:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=WUWCxbYXpv8z4jcgvVVgbLnra2IcxUsgwjwIFM6opyw=;
        b=W/zNLnnujNi8mD1qvnJWRy6JXPybmBfAquVMMjeNiEC1px3NG+eAP8XPcV7RjKwlxu
         Nc0qVQKmCe5VfWPAdOdQDfAp8MoHUn5F3BYwdfo2rue2IukL818IQeaUKgnhy+HY7aWv
         ELLCnw5aBXJgLk3FsDK6p6BzECHS9qzBPha9PBI0r1OGuUSKWJxRmwfGLYSjYZAbxkH4
         re4Zj530KW4+OlzNptvd23dEMlZBXxvd+y/ul+RqT9M0P+q2PeMOrWWFbZub0sZLglpO
         uORL6QAZUxAB4nEL5zjG9AkSuwVu1XtmS4EclAXNibXrbw5rOSuZkpWS1eraJ+EUglmu
         kX+Q==
X-Gm-Message-State: AOAM5300JuiYy5R777BrcEM1w3bv+vwEI0vSN9k2tp5I4NSpFqc+DQHF
        J9dpkwFGfQ7OTi14eKY49hqkjN0vVyhEyTBFy1ujSvZZn7U9
X-Google-Smtp-Source: ABdhPJyPEwIAqyIUFL+CxixBlWaTZmYK6PeM/UNgXrwWC4dbze6a16I/59eg/9wLMvT9QQR9oi7rektbQwH1FARKkQaauaXpb5uG
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d56:b0:319:f6bb:25e1 with SMTP id
 d22-20020a0566380d5600b00319f6bb25e1mr6281612jak.242.1647677784786; Sat, 19
 Mar 2022 01:16:24 -0700 (PDT)
Date:   Sat, 19 Mar 2022 01:16:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000110dee05da8de18a@google.com>
Subject: [syzbot] linux-next test error: WARNING in __napi_schedule
From:   syzbot <syzbot+6f21ac9e27fca7e97623@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
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

HEAD commit:    6d72dda014a4 Add linux-next specific files for 20220318
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=124f5589700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5907d82c35688f04
dashboard link: https://syzkaller.appspot.com/bug?extid=6f21ac9e27fca7e97623
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f21ac9e27fca7e97623@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3612 at net/core/dev.c:4268 ____napi_schedule net/core/dev.c:4268 [inline]
WARNING: CPU: 0 PID: 3612 at net/core/dev.c:4268 __napi_schedule+0xe2/0x440 net/core/dev.c:5878
Modules linked in:
CPU: 0 PID: 3612 Comm: kworker/0:5 Not tainted 5.17.0-rc8-next-20220318-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg0 wg_packet_decrypt_worker
RIP: 0010:____napi_schedule net/core/dev.c:4268 [inline]
RIP: 0010:__napi_schedule+0xe2/0x440 net/core/dev.c:5878
Code: 74 4a e8 11 61 3c fa 31 ff 65 44 8b 25 d7 27 c6 78 41 81 e4 00 ff 0f 00 44 89 e6 e8 18 63 3c fa 45 85 e4 75 07 e8 ee 60 3c fa <0f> 0b e8 e7 60 3c fa 65 44 8b 25 f7 31 c6 78 31 ff 44 89 e6 e8 f5
RSP: 0018:ffffc9000408fc78 EFLAGS: 00010093
RAX: 0000000000000000 RBX: ffff88807fa90748 RCX: 0000000000000000
RDX: ffff888019800000 RSI: ffffffff873c4802 RDI: 0000000000000003
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff873c47f8 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b9c00000 R14: 000000000003b100 R15: ffff88801cf90ec0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f998512c300 CR3: 00000000707f2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 napi_schedule include/linux/netdevice.h:465 [inline]
 wg_queue_enqueue_per_peer_rx drivers/net/wireguard/queueing.h:204 [inline]
 wg_packet_decrypt_worker+0x408/0x5d0 drivers/net/wireguard/receive.c:510
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
