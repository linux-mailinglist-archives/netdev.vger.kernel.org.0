Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A08276D6F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgIXJ2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:28:15 -0400
Received: from mail-il1-f205.google.com ([209.85.166.205]:40435 "EHLO
        mail-il1-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbgIXJ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:26:26 -0400
Received: by mail-il1-f205.google.com with SMTP id g188so2085105ilh.7
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KwtKvUDMcxdYzs6ADf81+0YwKHEm5MaqSDUuSHizkg8=;
        b=rQq4Fv/UBsxwvpXlemYLCvd/KUdKbKOO6L8n5jwto6O4NFJ7OuBVp+iSgPoZACGiK3
         Mkj++S1JAN1d9+RHOnBKjO/fgRRmk4D7NHSzGj7CxQV1lF/0V5z+jGXSuXSkjqnY2azU
         r3/HqIFRmbGU50jOFgE4/k7uoiiq+4Bf0Knj1TxocrtJ36D1RZi0cLXR4BXvRKeSxeoU
         cH5Wq00CDZfmonOjK4KClacqVJ7W0F2+fINdQtzs4+3TWsVaXIT5ZzV3MPTD9us++ruA
         ArKySnmGQ0Ac81e4xxDthvAIIQNJxNzeWewwdfx8pcd/UdURyy2Qcgl+D2LKohyv6uzh
         N1KQ==
X-Gm-Message-State: AOAM533xICeaTCoxpcRoompkkN6InEmk6cenR2xNlPq7FsaMaITIu/58
        qqypNMDVGqc+M85wunOMsiaWS+ztMlSVIj/V5+HE1fwlGYYr
X-Google-Smtp-Source: ABdhPJzTyRPx3cOgeXGYY4+EUXdletyipVJqYGdcV1OlOfs7BzF1u5fWaj52gYsBTpNencNxqd5zgCjjdih5ydOHOydhQAPHGd+n
MIME-Version: 1.0
X-Received: by 2002:a02:7fcf:: with SMTP id r198mr2783772jac.24.1600939585536;
 Thu, 24 Sep 2020 02:26:25 -0700 (PDT)
Date:   Thu, 24 Sep 2020 02:26:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004d87c705b00bcb0a@google.com>
Subject: WARNING in sta_info_insert_rcu
From:   syzbot <syzbot+ef4ca92d9d6f5ba2f880@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    eff48dde Merge tag 'trace-v5.9-rc5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b4e8e3900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5f4c828c9e3cef97
dashboard link: https://syzkaller.appspot.com/bug?extid=ef4ca92d9d6f5ba2f880
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167e5707900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1765b19b900000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10341dab900000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12341dab900000
console output: https://syzkaller.appspot.com/x/log.txt?x=14341dab900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ef4ca92d9d6f5ba2f880@syzkaller.appspotmail.com

wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
------------[ cut here ]------------
WARNING: CPU: 0 PID: 72 at net/mac80211/sta_info.c:529 sta_info_insert_check net/mac80211/sta_info.c:529 [inline]
WARNING: CPU: 0 PID: 72 at net/mac80211/sta_info.c:529 sta_info_insert_rcu+0x27a/0x2ba0 net/mac80211/sta_info.c:707
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 72 Comm: kworker/u4:3 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_iface_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:sta_info_insert_check net/mac80211/sta_info.c:529 [inline]
RIP: 0010:sta_info_insert_rcu+0x27a/0x2ba0 net/mac80211/sta_info.c:707
Code: 24 e8 3a 79 b8 f9 0f b6 85 50 ff ff ff 31 ff 83 e0 01 41 89 c7 89 c6 e8 44 75 b8 f9 45 84 ff 0f 84 c5 00 00 00 e8 16 79 b8 f9 <0f> 0b 41 bd ea ff ff ff e8 09 79 b8 f9 48 8b bd 30 ff ff ff e8 ed
RSP: 0018:ffffc90001017958 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888093338c00 RCX: ffffffff87bdc51c
RDX: ffff8880a9394040 RSI: ffffffff87bdc52a RDI: 0000000000000001
RBP: ffffc90001017aa0 R08: 0000000000000000 R09: ffff88809333925f
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000500177e9
R13: ffff8880a8916048 R14: ffff8880a8916000 R15: 0000000000000001
 ieee80211_ibss_finish_sta+0x212/0x390 net/mac80211/ibss.c:592
 ieee80211_ibss_work+0x2c7/0xe80 net/mac80211/ibss.c:1699
 ieee80211_iface_work+0x7d2/0x8f0 net/mac80211/iface.c:1438
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
