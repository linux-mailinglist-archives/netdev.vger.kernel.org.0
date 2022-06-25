Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4B355A8CF
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 12:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiFYKZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 06:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiFYKZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 06:25:24 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF69220FC
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 03:25:23 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id w15-20020a056e021a6f00b002d8eef284f0so3156769ilv.6
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 03:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PpTw+0pR7d6KHpWzvUOwmUS7vIoJqaATGHEMY/gsX2A=;
        b=2FxvpQkXKEjzxn3CzIBAsqMTkxqOa/3eGAhLVVeoE5BCYNY8Nqov2qffbzlciCcRlA
         /OdC9cYXnsEF7gOEUpOgo+TGcBqYKxkjYXRmKloD+E945JXOyTF/aRmvwYLc0+bg2T+K
         /v594FYJgkaTLET3/s256sAEXPHa7Sm6a0sUyhHnmKCl5Z//Ep8R+2DnV8hUlj0mNCde
         D5CdGJwR9OaKDpBKvwjnen32N0FrIIFWPKnoNgMNgtrA3xyDeXQP3yPG3YHZ/6oG4+KF
         jH5yjn+s9Gmmw6rpjjZ95VFRFmL+G4DCSH7UMixazGcTEYOXzTQWtj1ZA3LYVVoS7jLI
         jA2w==
X-Gm-Message-State: AJIora/pkCcMPpat0a2N00ZjcnKTkPWPFqlFrsvpASXvxG+9wtthpc4d
        xuPLYtgtrqVpJ7ZeiguI9Kv9V/SIo2DpSMnjw1q8TX3PBzwE
X-Google-Smtp-Source: AGRyM1vyuTnNG1op68acyHfJlLSr34YHYTrvAEpZwGi6Cbef/aP1GrA3CCCBKweTEXTj6eEY5/aDNdEA2+u9dTrnUMthPogUPw/n
MIME-Version: 1.0
X-Received: by 2002:a6b:ed15:0:b0:674:f8eb:a373 with SMTP id
 n21-20020a6bed15000000b00674f8eba373mr1734128iog.37.1656152722465; Sat, 25
 Jun 2022 03:25:22 -0700 (PDT)
Date:   Sat, 25 Jun 2022 03:25:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b76c8005e2431a11@google.com>
Subject: [syzbot] WARNING in cfg80211_ch_switch_notify
From:   syzbot <syzbot+90d912872157e63589e4@syzkaller.appspotmail.com>
To:     SHA-cyfmac-dev-list@infineon.com, ajay.kathat@microchip.com,
        amitkarwar@gmail.com, aspriel@gmail.com,
        brcm80211-dev-list.pdl@broadcom.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, fabioaiuto83@gmail.com,
        franky.lin@broadcom.com, ganapathi017@gmail.com,
        geomatsi@gmail.com, gregkh@linuxfoundation.org,
        hante.meuleman@broadcom.com, hdegoede@redhat.com,
        huxinming820@gmail.com, imitsyanko@quantenna.com,
        jagathjog1996@gmail.com, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org, kvalo@kernel.org,
        libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
        loic.poulain@linaro.org, netdev@vger.kernel.org, pabeni@redhat.com,
        prestwoj@gmail.com, sharvari.harisangam@nxp.com, smoch@web.de,
        syzkaller-bugs@googlegroups.com, ye.guojin@zte.com.cn
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

HEAD commit:    34d1d36073ea Add linux-next specific files for 20220621
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=175aca1ff00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b24b62d1c051cfc8
dashboard link: https://syzkaller.appspot.com/bug?extid=90d912872157e63589e4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15a50e1ff00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=104b1cc4080000

The issue was bisected to:

commit 7b0a0e3c3a88260b6fcb017e49f198463aa62ed1
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Apr 14 14:50:57 2022 +0000

    wifi: cfg80211: do some rework towards MLO link APIs

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=177e008ff00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14fe008ff00000
console output: https://syzkaller.appspot.com/x/log.txt?x=10fe008ff00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+90d912872157e63589e4@syzkaller.appspotmail.com
Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 1021 at net/wireless/nl80211.c:18562 cfg80211_ch_switch_notify+0x3b7/0x8a0 net/wireless/nl80211.c:18562
Modules linked in:
CPU: 1 PID: 1021 Comm: kworker/u4:5 Not tainted 5.19.0-rc3-next-20220621-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_csa_finalize_work

RIP: 0010:cfg80211_ch_switch_notify+0x3b7/0x8a0 net/wireless/nl80211.c:18562
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 d2 04 00 00 49 8b 14 24 44 89 ee 48 89 ef e8 33 fa fb ff e9 44 ff ff ff e8 e9 78 cc f8 <0f> 0b e9 38 ff ff ff e8 dd 78 cc f8 48 8d bd f8 04 00 00 48 ba 00
RSP: 0018:ffffc90004dcfc60 EFLAGS: 00010293

RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801eea57c0 RSI: ffffffff88ae4467 RDI: 0000000000000005
RBP: ffff88801f004c90 R08: 0000000000000005 R09: 0000000000000009
R10: 0000000000000001 R11: 0000000000000010 R12: ffff88801f006458
R13: 0000000000000000 R14: ffff88801f004000 R15: ffff888021d90000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000021000000 CR3: 000000000ba8e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __ieee80211_csa_finalize+0x738/0xc90 net/mac80211/cfg.c:3432
 ieee80211_csa_finalize net/mac80211/cfg.c:3439 [inline]
 ieee80211_csa_finalize_work+0x131/0x170 net/mac80211/cfg.c:3464
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
