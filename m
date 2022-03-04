Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537374CCD70
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbiCDGBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiCDGBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:01:10 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6500A18023D
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 22:00:22 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id 3-20020a056e020ca300b002c2cf74037cso4901829ilg.6
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 22:00:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=TFMJ4ukGQs86fCBCLXSygly6TsLRzd9XxdIZL+vlrCk=;
        b=4q/LbB8yC18IdVt3gPfEo0pppXOpRWFrOc+5ZzhM1jlT91PoJV/5+H71CmKNIKoYn6
         y5s+3PrR15zK/kAuOuwyfNTWT2HRfW3B6GOxRr98qKRs3z9Vn+NrQX+rq62Gnx6zuD46
         00Q5LdkPPNwyV8CrhVpafdBak9raqJ3emUAOnYnxsi2wm/cOxKoK7RwX+453h8QcVGuG
         n/4kFw2/AuyyZbs3JT+dAVepQq4sHI4GCC2zA4IMHG8UeKYQQ+R63lxljrVeCoObKqvg
         dC12+v5dEh8G8iZ0ffrF0uv6RnSQ9amxFruUkgA1Jxymp9zVOqvc7fbxhzJalQytFU9q
         KrRw==
X-Gm-Message-State: AOAM531QntRS9XL8UbdaDAirlqH4oCuzZ0+0cl1arJkyhb5uIfK6EpgQ
        Ed4odRS7yaZelNa0weicpSNt0bX5maLlhr7r42b+RzrS8fSX
X-Google-Smtp-Source: ABdhPJwvs1Gwblkb+0NmkA7Nm/FwFs9iyFV004XGZhv8GUUS9AEhXvdAnPYOPs2Ja36Z4dKoofYFWXQr6oO4lsZVAhDSm2GVn8tr
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1024:b0:314:9d7e:47f6 with SMTP id
 n4-20020a056638102400b003149d7e47f6mr32954073jan.8.1646373621601; Thu, 03 Mar
 2022 22:00:21 -0800 (PST)
Date:   Thu, 03 Mar 2022 22:00:21 -0800
In-Reply-To: <0000000000002da23a05d9299019@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2192405d95e3a37@google.com>
Subject: Re: [syzbot] WARNING in submit_bio_noacct
From:   syzbot <syzbot+7fdd158f9797accbebfc@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    91265a6da44d Add linux-next specific files for 20220303
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10c23e1a700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=617f79440a35673a
dashboard link: https://syzkaller.appspot.com/bug?extid=7fdd158f9797accbebfc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f7f36e700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105cbfb9700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7fdd158f9797accbebfc@syzkaller.appspotmail.com

------------[ cut here ]------------
Trying to write to read-only block-device sda1 (partno 1)
WARNING: CPU: 1 PID: 2927 at block/blk-core.c:581 bio_check_ro block/blk-core.c:581 [inline]
WARNING: CPU: 1 PID: 2927 at block/blk-core.c:581 submit_bio_noacct+0x16f3/0x1be0 block/blk-core.c:810
Modules linked in:
CPU: 1 PID: 2927 Comm: jbd2/sda1-8 Not tainted 5.17.0-rc6-next-20220303-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bio_check_ro block/blk-core.c:581 [inline]
RIP: 0010:submit_bio_noacct+0x16f3/0x1be0 block/blk-core.c:810
Code: 00 00 45 0f b6 a4 24 50 05 00 00 48 8d 74 24 60 48 89 ef e8 cf 1f fe ff 48 c7 c7 e0 93 24 8a 48 89 c6 44 89 e2 e8 c9 6e 41 05 <0f> 0b e9 91 f3 ff ff e8 41 96 a1 fd e8 6c bf 85 05 31 ff 89 c3 89
RSP: 0018:ffffc9000c25f900 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88801bdaa250 RCX: 0000000000000000
RDX: ffff88807f5a9d40 RSI: ffffffff81602878 RDI: fffff5200184bf12
RBP: ffff88801f184000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff815fd23e R11: 0000000000000000 R12: 0000000000000001
R13: ffff88801f184010 R14: ffff888018355080 R15: 1ffff9200184bf28
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200066d0 CR3: 000000002432e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 submit_bio block/blk-core.c:941 [inline]
 submit_bio+0x1a0/0x350 block/blk-core.c:905
 submit_bh_wbc+0x4e9/0x6b0 fs/buffer.c:3090
 jbd2_journal_commit_transaction+0x1fd9/0x6d80 fs/jbd2/commit.c:762
 kjournald2+0x1d0/0x930 fs/jbd2/journal.c:213
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

