Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA64DE488
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 00:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbiCRXhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 19:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241527AbiCRXhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 19:37:39 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A4A30CA8A
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 16:36:20 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id k10-20020a5d91ca000000b006414a00b160so5945291ior.18
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 16:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+MKfS9KaJOgzX6Bj06yPYh/Zoj+anW5sorP57L7zyBc=;
        b=vqEyYzrb2hqnU6qLLKti7DWg/hn3GbHFSfcO6QhlyK2fu34yVJfJRwgEXXLJvODISN
         yBTX0JX+Zud0pQms+d05OBRngByJTFnGuM0qyPGpbptMol2LTD5A3Qi7fwLGGgSJZqZq
         YIvxNMA7LYlaUl2po4c8acwjJoQr8j9opU8QFMXH9UZHPbYppK9Iz5K+Gszy/S8WI9a1
         9k8QMFLRahXn3/FsRPMMbNt2J8E2GneM0E7h5QPEUiGSu5QEBzgGskSHjTuR5mf1l9Jy
         LU+ggKAY8cT+odP3CwTBObarsf3PFaV5Qz+0XHJa4Auh8tGFNqpRc7AD8N0F/TtuPobg
         tzfw==
X-Gm-Message-State: AOAM530+B9P9xz7j0Uhj+GCxcNQazM7DAPC28cEqYoIlM1laqGn61Ywq
        n5WEi50JC0JRSOqz4VgEBE8bQEEsEgtMFBeugI3B7aO9Zklp
X-Google-Smtp-Source: ABdhPJwIjc6onNrC4ts9Hddc3mAEKea9094pQn3yJ4PnLYSGmik1Ce91bqu9jDx6JIda8yf2a5naBYE2Xdy4XL0TfgmeDpJtZtA4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:264b:b0:31a:84d7:7281 with SMTP id
 n11-20020a056638264b00b0031a84d77281mr1983827jat.288.1647646579008; Fri, 18
 Mar 2022 16:36:19 -0700 (PDT)
Date:   Fri, 18 Mar 2022 16:36:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000eaff805da869d5b@google.com>
Subject: [syzbot] net-next test error: WARNING in __napi_schedule
From:   syzbot <syzbot+fb57d2a7c4678481a495@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        wireguard@lists.zx2c4.com
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

HEAD commit:    e89600ebeeb1 af_vsock: SOCK_SEQPACKET broken buffer test
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=134d43d5700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ef691629edb94d6a
dashboard link: https://syzkaller.appspot.com/bug?extid=fb57d2a7c4678481a495
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fb57d2a7c4678481a495@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1133 at net/core/dev.c:4268 ____napi_schedule net/core/dev.c:4268 [inline]
WARNING: CPU: 0 PID: 1133 at net/core/dev.c:4268 __napi_schedule+0xe2/0x440 net/core/dev.c:5878
Modules linked in:
CPU: 0 PID: 1133 Comm: kworker/0:3 Not tainted 5.17.0-rc8-syzkaller-02525-ge89600ebeeb1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: wg-crypt-wg0 wg_packet_decrypt_worker
RIP: 0010:____napi_schedule net/core/dev.c:4268 [inline]
RIP: 0010:__napi_schedule+0xe2/0x440 net/core/dev.c:5878
Code: 74 4a e8 31 16 47 fa 31 ff 65 44 8b 25 47 c5 d0 78 41 81 e4 00 ff 0f 00 44 89 e6 e8 98 19 47 fa 45 85 e4 75 07 e8 0e 16 47 fa <0f> 0b e8 07 16 47 fa 65 44 8b 25 5f cf d0 78 31 ff 44 89 e6 e8 75
RSP: 0018:ffffc900057d7c88 EFLAGS: 00010093
RAX: 0000000000000000 RBX: ffff88801e680748 RCX: 0000000000000000
RDX: ffff88801ccb0000 RSI: ffffffff8731aa92 RDI: 0000000000000003
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff8731aa88 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b9c00000 R14: 000000000003adc0 R15: ffff88801e118ec0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdaa5c65300 CR3: 0000000070af4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 napi_schedule include/linux/netdevice.h:465 [inline]
 wg_queue_enqueue_per_peer_rx drivers/net/wireguard/queueing.h:204 [inline]
 wg_packet_decrypt_worker+0x408/0x5d0 drivers/net/wireguard/receive.c:510
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
