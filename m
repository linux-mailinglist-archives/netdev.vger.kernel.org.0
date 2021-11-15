Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB10444FF4C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 08:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhKOHlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 02:41:32 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:38893 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhKOHlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 02:41:19 -0500
Received: by mail-il1-f198.google.com with SMTP id m14-20020a92870e000000b0027586f7fb06so10020321ild.5
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 23:38:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=wAcAJvwVLUQg9owDLLhZ6P7Y4ndIiH5QD0qB5tdkIn8=;
        b=F38AGgSUCMiRGoq8/+ycH3yQkpVFFeVU6xGAlx7pOxJipL3RlDMLX535lvwPZDcSKc
         MdAfBdA97qcaQQlPTKMEsn75xCUbSNzFDSRqAJMeirmatMTbdSshutlwiZEca19nRft1
         u7Vjwrzfenhc9c/1chMPwZVz+KSHT++mvxXUZDdIU0J/kfnR5jepCjsCRWYMlZkjjgTF
         YrRk+LiXmuXEvkx1+aB7p4La8GqrzM+Xf0Y+n9aoBMBmZolQc/PDKJ/BDEO9vBtfsPuE
         PSM62q8j6R73rC2fUPajCYRiNH+JAZ1+i3FBhLacVXkTa7PoK4+pbKyQPbtuBW7X1am6
         ef4Q==
X-Gm-Message-State: AOAM533cScsF7ddjz1J8Ma0UlROSTknFcfQIyyyW3kH5z+L+pLytLlJD
        S2TYtJ3Dt+1huIQqRe+Y0Gio+CTSbMlQhWWV1Domk4dZ9Ogq
X-Google-Smtp-Source: ABdhPJwUDoRWDhgTf8XrfrouKYXV1uId24KuTAbyeov6j2HHWcumh9j0lVSFqB9YAlAsPxsj0yhKc8QrUtXV3ONFYEosPH60L30m
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1529:: with SMTP id i9mr19982807ilu.23.1636961903367;
 Sun, 14 Nov 2021 23:38:23 -0800 (PST)
Date:   Sun, 14 Nov 2021 23:38:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c2dccb05d0cee49a@google.com>
Subject: [syzbot] WARNING in ieee80211_free_ack_frame (2)
From:   syzbot <syzbot+ac648b0525be1feba506@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    89d714ab6043 Merge tag 'linux-watchdog-5.16-rc1' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=108e7c3eb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dcce4e862d74e466
dashboard link: https://syzkaller.appspot.com/bug?extid=ac648b0525be1feba506
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac648b0525be1feba506@syzkaller.appspotmail.com

netdevsim netdevsim1 netdevsim2 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim1 netdevsim1 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
netdevsim netdevsim1 netdevsim0 (unregistering): unset [1, 0] type 2 family 0 port 6081 - 0
------------[ cut here ]------------
Have pending ack frames!
WARNING: CPU: 0 PID: 10 at net/mac80211/main.c:1419 ieee80211_free_ack_frame+0x48/0x50 net/mac80211/main.c:1419
Modules linked in:
CPU: 0 PID: 10 Comm: kworker/u4:1 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:ieee80211_free_ack_frame+0x48/0x50 net/mac80211/main.c:1419
Code: e8 0d dc f3 f8 48 89 ef e8 d5 c6 97 fe 31 c0 5b 5d c3 e8 fb db f3 f8 48 c7 c7 00 9b ab 8a c6 05 b3 00 d8 04 01 e8 89 e9 72 00 <0f> 0b eb d2 0f 1f 40 00 41 57 41 56 49 89 f6 41 55 41 54 49 89 d4
RSP: 0018:ffffc90000f0f9d8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888011c3c280 RSI: ffffffff815e6b88 RDI: fffff520001e1f2d
RBP: ffff8880781a6000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815e095e R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff888320f0 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c247c48cf0 CR3: 0000000021d96000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 idr_for_each+0x113/0x220 lib/idr.c:208
 ieee80211_free_hw+0x9b/0x2b0 net/mac80211/main.c:1435
 mac80211_hwsim_del_radio drivers/net/wireless/mac80211_hwsim.c:3586 [inline]
 hwsim_exit_net+0x55f/0xca0 drivers/net/wireless/mac80211_hwsim.c:4346
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:593
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
