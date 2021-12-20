Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33AD47A581
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 08:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237758AbhLTHv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 02:51:26 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:48733 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbhLTHvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 02:51:24 -0500
Received: by mail-il1-f199.google.com with SMTP id k9-20020a056e02156900b002a1acf9a52dso4687748ilu.15
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 23:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0Hg51J7CrXDopzkrOpRqyGDWbWxGVfKkuLGYK0SllQ8=;
        b=MiV56QFRyM4jWRvM0+gSndRLzDXkzRNJN25y/0iI2Q23Y079HMqVSqX+F6DlN4M3ub
         XWMLy7i4zC8e3LzdD/knVZ0x+UkLswR+CKopmFngknr13EG8vqU56sjWGfr97PVYmzKF
         UosLkjiZ7XCo0Kbs93X5uxwgmX3Vrlc2mnTIcf++v3/+VMtFDkB8lPQBuxcLm/sPMSkz
         n7hyNMeQywiSHgr+hHcWeFpXM5dOiLttBcJT1EHoHdexLkUU24JZrC+o6y+HL06kga7a
         RXfLlyKiAAMj+HvnKZcDZTvWJ/3fcjUZ+IC5ZvLzIwVNmu/dWzsdVx4Hwtnz8Yfm/93u
         iXCA==
X-Gm-Message-State: AOAM532FwjYBHpBMCKguI8p+D+kOkwBSjUqqCxXjz4fuXvHdMvy/u6w9
        Y+l+pjEg+F8dOQkWT2pjPjswQg8mFJZ6TiN/NDOSR7mwBdLg
X-Google-Smtp-Source: ABdhPJyGgiYqhO6mPeAv513nukQ0NAAls29fNy3sLlYMkouVr7wITkQ4n+tCpI1Qt8+DwYp61jD1pZLIsBi2e5XsuVuv9sMFZS1o
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2402:: with SMTP id z2mr510261jat.122.1639986684455;
 Sun, 19 Dec 2021 23:51:24 -0800 (PST)
Date:   Sun, 19 Dec 2021 23:51:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c375a805d38f27e7@google.com>
Subject: [syzbot] WARNING in ieee80211_vif_release_channel (2)
From:   syzbot <syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com>
To:     bp@alien8.de, davem@davemloft.net, dwmw@amazon.co.uk,
        hpa@zytor.com, jmattson@google.com, johannes@sipsolutions.net,
        joro@8bytes.org, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    60ec7fcfe768 qlcnic: potential dereference null pointer of..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1390880db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa556098924b78f0
dashboard link: https://syzkaller.appspot.com/bug?extid=11c342e5e30e9539cabd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10e0a349b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ef4733b00000

The issue was bisected to:

commit 0985dba842eaa391858972cfe2724c3c174a2827
Author: David Woodhouse <dwmw@amazon.co.uk>
Date:   Sat Oct 23 19:47:19 2021 +0000

    KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in kvm_vcpu_block()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f0cdd5b00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11f0cdd5b00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16f0cdd5b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Fixes: 0985dba842ea ("KVM: x86/xen: Fix kvm_xen_has_interrupt() sleeping in kvm_vcpu_block()")

RSP: 002b:00007fff775e50d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f668292e069
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000002 R09: 00007fff775e5110
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff775e5100
R13: 000000000000000e R14: 00000000ffffffff R15: 0000000000000000
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3601 at net/mac80211/chan.c:1862 ieee80211_vif_release_channel+0x1ad/0x220 net/mac80211/chan.c:1862 net/mac80211/chan.c:1862
Modules linked in:
CPU: 0 PID: 3601 Comm: syz-executor149 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_vif_release_channel+0x1ad/0x220 net/mac80211/chan.c:1862 net/mac80211/chan.c:1862
Code: c1 ea 03 80 3c 02 00 0f 85 82 00 00 00 48 8b ab 10 06 00 00 e9 60 ff ff ff e8 ff 10 d6 f8 0f 0b e9 e2 fe ff ff e8 f3 10 d6 f8 <0f> 0b 48 b8 00 00 00 00 00 fc ff df 4c 89 e2 48 c1 ea 03 80 3c 02
RSP: 0018:ffffc900029ff350 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88801cf50c80 RCX: 0000000000000000
RDX: ffff88801d00ba00 RSI: ffffffff88a1a0dd RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff88a1a09c R11: 0000000000000000 R12: ffff88801cf51290
R13: 0000000000000001 R14: 00000000fffffff4 R15: 0000000000000000
FS:  0000555556cb8300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643b512ad10 CR3: 000000001d4f5000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ieee80211_start_ap+0x1b16/0x2780 net/mac80211/cfg.c:1267 net/mac80211/cfg.c:1267
 rdev_start_ap net/wireless/rdev-ops.h:158 [inline]
 rdev_start_ap net/wireless/rdev-ops.h:158 [inline] net/wireless/nl80211.c:5718
 nl80211_start_ap+0x288d/0x3dd0 net/wireless/nl80211.c:5718 net/wireless/nl80211.c:5718
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline] net/netlink/genetlink.c:792
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496 net/netlink/af_netlink.c:2496
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline] net/netlink/af_netlink.c:1345
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x904/0xdf0 net/netlink/af_netlink.c:1921 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:724
 sock_sendmsg+0xcf/0x120 net/socket.c:724 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f668292e069
Code: 97 01 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff775e50d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f668292e069
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 0000000000000004 R08: 0000000000000002 R09: 00007fff775e5110
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff775e5100
R13: 000000000000000e R14: 00000000ffffffff R15: 0000000000000000
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
