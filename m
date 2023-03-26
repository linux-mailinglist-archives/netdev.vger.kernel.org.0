Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206AB6C9318
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 10:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbjCZIVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 04:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCZIVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 04:21:40 -0400
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD46902C
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 01:21:39 -0700 (PDT)
Received: by mail-il1-f207.google.com with SMTP id a17-20020a921a11000000b00325f9878441so1041678ila.7
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 01:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679818898;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aqYh3CwtYwrM9HBHh1pu64sFY9zM9QBS5bc8KmXbNdI=;
        b=NmmOEEznndyNYh9+vVulSQ5vxx+PdIj6pNLZZsMRsjs6IIITuoLtuyg8HqWuVYamDN
         osdqe4gWsnuW4BJ1fNeOd2+uAmWFYixFbl/8O0B+VXeFpTiwq4b3zCOtXOKn9KRwPhLb
         TyvturByIRHsLPXzI+iCiJd2kcfW3LPkJJu1qVQFAFaCnEZjFMyJUnbfcvR3fYip/bg3
         haQEbBIaaAbfZoZTa7CYKqED2ITYolxM69uTQdniZjDOVKsd1IeDwuGUEUpTTuAD4PlL
         BM/dhcCZ5cn61O9K027mkEIJ19/mA+3kGrck5jSEIRYanEeKWFBEpfLgYZkAPX9KfHei
         U6NQ==
X-Gm-Message-State: AAQBX9e67l6KN7FIVpV0SoL/PWERHCcANc3ptb0Z/0ERpslpVHmXErVo
        vhhiFDg9GtB/XqT0aNHPhmOqERPiPyH8ePnsL3ZFl386SE54
X-Google-Smtp-Source: AKy350ZKbrsytcpE7qpewxYCVf5WuuIzdEe03RauLhYATSNSqsw/SC7InFbnh/NA0aSUyG9II8QUdj6ThjX1CvEbkEeqUP9BYjJi
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a26:b0:30f:6172:b11f with SMTP id
 g6-20020a056e021a2600b0030f6172b11fmr4383482ile.4.1679818898354; Sun, 26 Mar
 2023 01:21:38 -0700 (PDT)
Date:   Sun, 26 Mar 2023 01:21:38 -0700
In-Reply-To: <000000000000c2dccb05d0cee49a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b93a6205f7c95055@google.com>
Subject: Re: [syzbot] [wireless?] WARNING in ieee80211_free_ack_frame (2)
From:   syzbot <syzbot+ac648b0525be1feba506@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    33189f0a94b9 r8169: fix RTL8168H and RTL8107E rx crc error
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12857025c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea09b0836073ee4
dashboard link: https://syzkaller.appspot.com/bug?extid=ac648b0525be1feba506
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15346b1ec80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162e3b89c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/62cbf0a881e9/disk-33189f0a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/57e9b6d3facf/vmlinux-33189f0a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3bd33096e2d8/bzImage-33189f0a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac648b0525be1feba506@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 75 at net/mac80211/main.c:1509 ieee80211_free_ack_frame+0x51/0x60 net/mac80211/main.c:1509
Modules linked in:
CPU: 1 PID: 75 Comm: kworker/u4:4 Not tainted 6.3.0-rc3-syzkaller-00156-g33189f0a94b9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: netns cleanup_net
RIP: 0010:ieee80211_free_ack_frame+0x51/0x60 net/mac80211/main.c:1509
Code: 48 89 ef be 02 00 00 00 e8 cc 42 88 fe 31 c0 5b 5d c3 e8 12 27 0b f8 48 c7 c7 80 cb 7c 8b c6 05 eb 8a ea 04 01 e8 af a0 d3 f7 <0f> 0b eb cd 66 66 2e 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 41 57 41
RSP: 0018:ffffc900015879d8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888018999d40 RSI: ffffffff814b6037 RDI: 0000000000000001
RBP: ffff88807258c280 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8977bdb0 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056122f357fc8 CR3: 000000001de5f000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 idr_for_each+0x117/0x230 lib/idr.c:208
 ieee80211_free_hw+0xa1/0x2f0 net/mac80211/main.c:1527
 mac80211_hwsim_del_radio drivers/net/wireless/mac80211_hwsim.c:4687 [inline]
 hwsim_exit_net+0x463/0x840 drivers/net/wireless/mac80211_hwsim.c:5470
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

