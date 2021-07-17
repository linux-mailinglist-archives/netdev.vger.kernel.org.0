Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4903CC3A5
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 15:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhGQNpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 09:45:20 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:54236 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbhGQNpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 09:45:20 -0400
Received: by mail-io1-f72.google.com with SMTP id c18-20020a5d9a920000b0290515fa57d24aso8363227iom.20
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 06:42:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kin4STxzaKrlkAdSsJswDUHshiFw6dnM7GdPDkfdKJs=;
        b=Klp4DQmp3YTWtsayideDodNdz3Uj5bP7IUMHWSEIW1FyzvAp8wln68oOjOrxD1aWnw
         iLy7ACooNnlpvMQyHQ1BTFcf1DPsaduz3/2WxkvwX2RNSpOULV+WTgTXCxfOjbImcKAA
         TD1v7zNeBc5F1uKHmts+G834h7xNA0v0Iealb2L6z1CWDBrx0xyTpaPslAQtmZen1SD1
         dnbQ2OidR4mCV1arVKKW7f/g7b2Q0xne0nG8uINI9dMBa700If8MNzKb0uodtKfeOlig
         aJ1104oALfkinWqC9rGrWx9WEOcrqC8UUTojHk0oTKMBYE6eB2hl4QjTFdljXfJm5Qep
         Gc+A==
X-Gm-Message-State: AOAM533sRs581s1jcPK5q0WtYK7Ln0/B2su2Sd1ogAI2MXFNzKExO1QG
        exiewn6Tyn/SjfEYHirTl2PJwCwdiXuMjMhm8KMJRiowBD6v
X-Google-Smtp-Source: ABdhPJyZ8QGJxHA8riIBGNRlyPUIIZebA1EPkDRbl362vat3qell2V0YxsMTzEKilR5LbZYIsoYM56Y2y+koDi+6VM7gHL0I2HjO
MIME-Version: 1.0
X-Received: by 2002:a92:c883:: with SMTP id w3mr10159705ilo.76.1626529343574;
 Sat, 17 Jul 2021 06:42:23 -0700 (PDT)
Date:   Sat, 17 Jul 2021 06:42:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd971205c751df3d@google.com>
Subject: [syzbot] BUG: stack guard page was hit in rtnl_newlink
From:   syzbot <syzbot+399cbcbb7917bd2f96ee@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7fef2edf7cc7 sd: don't mess with SD_MINORS for CONFIG_DEBU..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=118eebc2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bcfdb4db27992419
dashboard link: https://syzkaller.appspot.com/bug?extid=399cbcbb7917bd2f96ee
compiler:       Debian clang version 11.0.1-2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+399cbcbb7917bd2f96ee@syzkaller.appspotmail.com

BUG: stack guard page was hit at ffffc900024fff18 (stack is ffffc90002500000..ffffc90002507fff)
kernel stack overflow (double-fault): 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 14026 Comm: syz-executor.5 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:lock_acquire+0x3c/0x4a0 kernel/locking/lockdep.c:5593
Code: 81 ec 20 01 00 00 45 89 c6 41 89 f7 48 89 fb 65 48 8b 04 25 28 00 00 00 48 89 84 24 00 01 00 00 49 bc 00 00 00 00 00 fc ff df <48> c7 44 24 40 b3 8a b5 41 48 c7 44 24 48 bc d5 f8 8b 48 c7 44 24
RSP: 0018:ffffc900024fff20 EFLAGS: 00010282
RAX: a66bc51f58bac500 RBX: ffffffff8c717740 RCX: 0000000000000002
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8c717740
RBP: ffffc90002500070 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1010ef9415 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff920004a001c R14: 0000000000000000 R15: 0000000000000000
FS:  00007f699499a700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900024fff18 CR3: 0000000038cf6000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 rcu_lock_acquire+0x2a/0x30 include/linux/rcupdate.h:267
 rcu_read_lock include/linux/rcupdate.h:687 [inline]
 dev_get_alias+0x25/0x1d0 net/core/dev.c:1477
 nla_put_ifalias+0x91/0x120 net/core/rtnetlink.c:1571
 rtnl_fill_ifinfo+0x108b/0x4a10 net/core/rtnetlink.c:1749
 rtmsg_ifinfo_build_skb+0xe2/0x180 net/core/rtnetlink.c:3815
 rtmsg_ifinfo_event net/core/rtnetlink.c:3847 [inline]
 rtnetlink_event+0xed/0x1b0 net/core/rtnetlink.c:5625
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_change_features+0x72/0x1b0 net/core/dev.c:10060
 team_compute_features drivers/net/team/team.c:1026 [inline]
 team_device_event+0x299/0x470 drivers/net/team/team.c:3007
 notifier_call_chain kernel/notifier.c:83 [inline]
 raw_notifier_call_chain+0xe7/0x170 kernel/notifier.c:410
 call_netdevice_notifiers_info net/core/dev.c:2122 [inline]
 call_netdevice_notifiers_extack net/core/dev.c:2134 [inline]
 call_netdevice_notifiers net/core/dev.c:2148 [inline]
 netdev_features_change net/core/dev.c:1494 [inline]
 netdev_sync_lower_features+0x3a3/0x600 net/core/dev.c:9841
 __netdev_update_features+0x4c6/0x1260 net/core/dev.c:9988
 netdev_update_features+0x6d/0x1c0 net/core/dev.c:10043
 dev_disable_lro+0x43/0x280 net/core/dev.c:1766
 br_add_if+0xcab/0x1a50 net/bridge/br_if.c:650
 do_set_master net/core/rtnetlink.c:2524 [inline]
 do_setlink+0xe51/0x3f70 net/core/rtnetlink.c:2728
 __rtnl_newlink net/core/rtnetlink.c:3393 [inline]
 rtnl_newlink+0x16e4/0x1cd0 net/core/rtnetlink.c:3508
 rtnetlink_rcv_msg+0x91c/0xe50 net/core/rtnetlink.c:5574
 netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x7de/0x9b0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x9e7/0xe00 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:702 [inline]
 sock_sendmsg net/socket.c:722 [inline]
 ____sys_sendmsg+0x5a2/0x900 net/socket.c:2385
 ___sys_sendmsg net/socket.c:2439 [inline]
 __sys_sendmsg+0x319/0x400 net/socket.c:2468
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f699499a188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000003
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007fffc1aaee5f R14: 00007f699499a300 R15: 0000000000022000
Modules linked in:
---[ end trace ac70e69260416dfc ]---
RIP: 0010:lock_acquire+0x3c/0x4a0 kernel/locking/lockdep.c:5593
Code: 81 ec 20 01 00 00 45 89 c6 41 89 f7 48 89 fb 65 48 8b 04 25 28 00 00 00 48 89 84 24 00 01 00 00 49 bc 00 00 00 00 00 fc ff df <48> c7 44 24 40 b3 8a b5 41 48 c7 44 24 48 bc d5 f8 8b 48 c7 44 24
RSP: 0018:ffffc900024fff20 EFLAGS: 00010282
RAX: a66bc51f58bac500 RBX: ffffffff8c717740 RCX: 0000000000000002
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8c717740
RBP: ffffc90002500070 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1010ef9415 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff920004a001c R14: 0000000000000000 R15: 0000000000000000
FS:  00007f699499a700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc900024fff18 CR3: 0000000038cf6000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
