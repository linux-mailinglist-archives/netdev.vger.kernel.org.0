Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1EC284BE5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgJFMpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:45:19 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:55279 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgJFMpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:45:18 -0400
Received: by mail-il1-f206.google.com with SMTP id l9so4617097ilf.21
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 05:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xntnR31aaoxC+Kj+KTAnTadrx7RgB0OZ9rkVP++SkoE=;
        b=Lq5mhr4ktW+wdGWw6Zn3HiUqgdeATpsrY4H410kUJJr8mGJEZCeSiFhAJxTp0s4RRp
         D2OTLyL96/hh8ElHAoynNSPeNu7+hpmnfaa+Ayyk5F/0MvxvV8lS7WxYbJIKi9K8M0FF
         1Ip5nXt735aYwP8z+Wq9rlThUIGrsY7V8lPQDCWJ52T3lwUmRD3Gcz9NdtY0bLQeDM0P
         Y9vVfSBNHkS3S/DFjilG1Nkvp/i//rj43WtSEqbUXt4QYjFMANCP+v/ETDzZ9ch9QKXv
         AyFrk2+w86P8p88SuE09RhTPHSOIwCtzRHqnqcSOOGkUEhkqpjM7zIZF9YA1WpBVaAXH
         WXqQ==
X-Gm-Message-State: AOAM531IvRDPXTOm+9R1x1MRvyINsfe42UqDv2Pbet75UJ6lCrdJXLaO
        x4gq/39IH3xWF8iFVowPL+vEgs76Ut5tEXJ7xGZ9oMWIkg9c
X-Google-Smtp-Source: ABdhPJzEOzv3UBmkNbq7R5E1fzMhLyc4bvw+TdLfJFKpDGJWNljQmz8FfSkSM6PU91hfwjuCplt2FwEsqvI7N7WQqns2Mki40b5G
MIME-Version: 1.0
X-Received: by 2002:a05:6638:13c4:: with SMTP id i4mr1059721jaj.85.1601988316238;
 Tue, 06 Oct 2020 05:45:16 -0700 (PDT)
Date:   Tue, 06 Oct 2020 05:45:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000086205205b0fff8b2@google.com>
Subject: general protection fault in ieee80211_chanctx_num_assigned
From:   syzbot <syzbot+00ce7332120071df39b1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2172e358 Add linux-next specific files for 20201002
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=176b55c0500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70698f530a7e856f
dashboard link: https://syzkaller.appspot.com/bug?extid=00ce7332120071df39b1
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00ce7332120071df39b1@syzkaller.appspotmail.com

mac80211_hwsim: wmediumd released netlink socket, switching to perfect channel medium
general protection fault, probably for non-canonical address 0xfbd59c0000000020: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
CPU: 1 PID: 13099 Comm: syz-executor.2 Not tainted 5.9.0-rc7-next-20201002-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ieee80211_chanctx_num_assigned+0xb1/0x140 net/mac80211/chan.c:21
Code: a8 f6 ff ff 48 39 c5 74 3b 49 bd 00 00 00 00 00 fc ff df e8 e1 64 b0 f9 48 8d bb 58 09 00 00 41 83 c4 01 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 75 68 48 8b 83 58 09 00 00 48 8d 98 a8 f6 ff ff 48
RSP: 0018:ffffc900167873f8 EFLAGS: 00010a02
RAX: 1bd5a00000000020 RBX: deacfffffffff7a8 RCX: ffffc9000e597000
RDX: 0000000000040000 RSI: ffffffff87c4e20f RDI: dead000000000100
RBP: ffff8880a7738020 R08: 0000000000000000 R09: ffffffff8bb59e0f
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: dffffc0000000000 R14: ffff8880a7738000 R15: 0000000000000000
FS:  00007f95513db700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000050a070 CR3: 00000000a695e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 ieee80211_assign_vif_chanctx+0x7b8/0x1230 net/mac80211/chan.c:690
 __ieee80211_vif_release_channel+0x236/0x430 net/mac80211/chan.c:1557
 ieee80211_vif_release_channel+0x117/0x220 net/mac80211/chan.c:1771
 ieee80211_ibss_disconnect+0x44e/0x7b0 net/mac80211/ibss.c:735
 ieee80211_ibss_leave+0x12/0xe0 net/mac80211/ibss.c:1871
 rdev_leave_ibss net/wireless/rdev-ops.h:545 [inline]
 __cfg80211_leave_ibss+0x19a/0x4c0 net/wireless/ibss.c:212
 cfg80211_leave_ibss+0x57/0x80 net/wireless/ibss.c:230
 cfg80211_change_iface+0x855/0xef0 net/wireless/util.c:1012
 nl80211_set_interface+0x65c/0x8d0 net/wireless/nl80211.c:3775
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2489
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2449
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de89
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f95513dac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002be80 RCX: 000000000045de89
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000004
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007ffcbfde65cf R14: 00007f95513db9c0 R15: 000000000118bf2c
Modules linked in:
---[ end trace 05c4a6af3338fd59 ]---
RIP: 0010:ieee80211_chanctx_num_assigned+0xb1/0x140 net/mac80211/chan.c:21
Code: a8 f6 ff ff 48 39 c5 74 3b 49 bd 00 00 00 00 00 fc ff df e8 e1 64 b0 f9 48 8d bb 58 09 00 00 41 83 c4 01 48 89 f8 48 c1 e8 03 <42> 80 3c 28 00 75 68 48 8b 83 58 09 00 00 48 8d 98 a8 f6 ff ff 48
RSP: 0018:ffffc900167873f8 EFLAGS: 00010a02
RAX: 1bd5a00000000020 RBX: deacfffffffff7a8 RCX: ffffc9000e597000
RDX: 0000000000040000 RSI: ffffffff87c4e20f RDI: dead000000000100
RBP: ffff8880a7738020 R08: 0000000000000000 R09: ffffffff8bb59e0f
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
R13: dffffc0000000000 R14: ffff8880a7738000 R15: 0000000000000000
FS:  00007f95513db700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1f3130bf60 CR3: 00000000a695e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
