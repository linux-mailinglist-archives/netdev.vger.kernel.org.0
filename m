Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E517230A404
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhBAJG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:06:57 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:39869 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbhBAJGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:06:53 -0500
Received: by mail-il1-f198.google.com with SMTP id e11so13070096ils.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 01:06:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ARZY/RI3r3wE1nvnxqQMeq1KYN//YLxDiX3i7NaZzII=;
        b=Fzlonvf6etdPEjojfh1uaHcTr+dADPnU7reWKvT0UOtJ0uj6VmHbsYPBFV3LacvA5K
         Z3JKNhV0w+RAGxFamGorrvPYJRdZ9BUfMLRcNYawUgo7yX06jbbdJMDkVSjFQReGw5AM
         Sek4aulNH6cARw+hW7WkjbJBrxv3hwckswSpqxqskcSG0VloHn+/uw5ILeHtlMcKA+JP
         wtEKr6qqVdS7l8H7TptMGCpyS70o6SOpH44k8Hflb0QZrw94NeOkxcE7USKZ7eaIImvx
         U66Lb66eJbi2UFtEjD+rG6QhFBqBTdmKtrrNFwsVkIk6kaJX4d9CwGjEiPejqjS20xcG
         laSQ==
X-Gm-Message-State: AOAM532m4Uh74eA/A3Rg9E83FDROC95xi8XmadIEtxHoUhQLtTnzHzBd
        KnGjg/TtRXrDCTvmHGNWOnYlgYtJFpURpcrd+pdkldnIj6qp
X-Google-Smtp-Source: ABdhPJxrNtRL2EI/pbRFMniWAss3Yb9otOW69Zv2eK8KbdTO6AZUgYS6k2aM5sq5fCgSCoej1v9RPnBQnBelXKaWQRyXRR2f5INw
MIME-Version: 1.0
X-Received: by 2002:a92:de4b:: with SMTP id e11mr9945281ilr.123.1612170372831;
 Mon, 01 Feb 2021 01:06:12 -0800 (PST)
Date:   Mon, 01 Feb 2021 01:06:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000063dcb705ba42aa1d@google.com>
Subject: WARNING in cfg80211_inform_single_bss_frame_data
From:   syzbot <syzbot+405843667e93b9790fc1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, sara.sharon@intel.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6642d600 Merge tag '5.11-rc5-smb3' of git://git.samba.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13f36b44d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96b123631a6700e9
dashboard link: https://syzkaller.appspot.com/bug?extid=405843667e93b9790fc1
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13fdeca0d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=173e9028d00000

The issue was bisected to:

commit 4abb52a46e7336c1e568a53761c8b7a81bbaaeaf
Author: Sara Sharon <sara.sharon@intel.com>
Date:   Wed Jan 16 10:14:41 2019 +0000

    mac80211: pass bssids to elements parsing function

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=153eaac4d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=173eaac4d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=133eaac4d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+405843667e93b9790fc1@syzkaller.appspotmail.com
Fixes: 4abb52a46e73 ("mac80211: pass bssids to elements parsing function")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 18 at net/wireless/scan.c:2337 cfg80211_inform_single_bss_frame_data+0xc7f/0xe90 net/wireless/scan.c:2337
Modules linked in:
CPU: 1 PID: 18 Comm: ksoftirqd/1 Not tainted 5.11.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cfg80211_inform_single_bss_frame_data+0xc7f/0xe90 net/wireless/scan.c:2337
Code: 0f 0b 45 31 e4 e9 37 fb ff ff e8 3c 4a 3c f9 0f 0b 45 31 e4 e9 28 fb ff ff e8 2d 4a 3c f9 0f 0b e9 58 f4 ff ff e8 21 4a 3c f9 <0f> 0b 45 31 e4 e9 0d fb ff ff e8 12 4a 3c f9 0f 0b e9 4f fd ff ff
RSP: 0018:ffffc90000d874c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90000d87a38 RCX: 0000000000000100
RDX: ffff888010db3780 RSI: ffffffff8836717f RDI: 0000000000000003
RBP: ffff888011512c00 R08: 0000000000000023 R09: 0000000000000080
R10: ffffffff883666e3 R11: 000000000000001c R12: 0000000000000023
R13: ffff8880183b0580 R14: 0000000000000080 R15: 0000000000000080
FS:  0000000000000000(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000200 CR3: 000000000b08e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cfg80211_inform_bss_frame_data+0xa7/0xb10 net/wireless/scan.c:2433
 ieee80211_bss_info_update+0x3ce/0xb20 net/mac80211/scan.c:190
 ieee80211_scan_rx+0x45f/0x7c0 net/mac80211/scan.c:299
 __ieee80211_rx_handle_packet net/mac80211/rx.c:4558 [inline]
 ieee80211_rx_list+0x1faf/0x2430 net/mac80211/rx.c:4746
 ieee80211_rx_napi+0xf7/0x3d0 net/mac80211/rx.c:4769
 ieee80211_rx include/net/mac80211.h:4508 [inline]
 ieee80211_tasklet_handler+0xd4/0x130 net/mac80211/main.c:235
 tasklet_action_common.constprop.0+0x1d7/0x2d0 kernel/softirq.c:555
 __do_softirq+0x2bc/0xa29 kernel/softirq.c:343
 run_ksoftirqd kernel/softirq.c:650 [inline]
 run_ksoftirqd+0x2d/0x50 kernel/softirq.c:642
 smpboot_thread_fn+0x655/0x9e0 kernel/smpboot.c:165
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
