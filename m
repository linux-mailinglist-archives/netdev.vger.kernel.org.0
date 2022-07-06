Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110BC568A05
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 15:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiGFNue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 09:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiGFNuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 09:50:32 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CBD17E21
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 06:50:30 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id t11-20020a6bdb0b000000b00674fd106c0cso8201172ioc.16
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 06:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/ObOq9i9PCetyXNMRRQQc3PnpcFrRWKHOKNFDzXth8Y=;
        b=YncqFkCC6HW+wsIUEFH1pVWwBgBn0q8deflqFIoDC0w1v2PtF+gvJx1ZwoUFoyGtdl
         8A7LkzXFQoGP4B4Ju/YoEeqAioDZlXqPnPcPUOY7uwJVIlPuyQ5SNK7D5dJBv6adVwuv
         XUXMvnNkegte37+w6uNsj/15+NFRh2bGwySUUeU+CwVVeramUKYj6WX0MtLYQ+FVyeA0
         9Fqc70DEg4nUuYcti0UW88qCtyYuoI7L2JPVh4TvLvghp8sV0fi0KYqI9yDU2tWsTylU
         hq7rvYj8tASJ9ITld6pwea+km6lWAMcSLBqZFw70XgIwQKAwSh5B5fmqDJvgvaEhrwFv
         RuJQ==
X-Gm-Message-State: AJIora/IMgzqOkJjSvw7vEnFzmBZ7oWBzeqxoGAr/yNRDLIJ9yeEwgrk
        /6pd8/fsl/9f3fViZEZwvVqF9BnDY8mFuS8gu9WBx6YlOsHq
X-Google-Smtp-Source: AGRyM1t8ImqiOaezDVWfmn71B5bWPJmtE7RGKYf8NvS+4MvTHQWU7NFxK6JSI/aZP8jNglYcDkuuX7ysnkVPsDJTdt5a0d+pHI7U
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16cc:b0:2da:b7b7:a7ab with SMTP id
 12-20020a056e0216cc00b002dab7b7a7abmr24967520ilx.114.1657115429712; Wed, 06
 Jul 2022 06:50:29 -0700 (PDT)
Date:   Wed, 06 Jul 2022 06:50:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008a396105e32340b3@google.com>
Subject: [syzbot] WARNING in notifier_chain_register
From:   syzbot <syzbot+5214f8dac5863061e37c@syzkaller.appspotmail.com>
To:     bigeasy@linutronix.de, bp@suse.de, davem@davemloft.net,
        dmitry.osipenko@collabora.com, edumazet@google.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, mirq-linux@rere.qmqm.pl,
        netdev@vger.kernel.org, pabeni@redhat.com,
        rafael.j.wysocki@intel.com, stern@rowland.harvard.edu,
        syzkaller-bugs@googlegroups.com, vasyl.vavrychuk@opensynergy.com,
        vschneid@redhat.com
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

HEAD commit:    cb71b93c2dc3 Add linux-next specific files for 20220628
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=168bb25bf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
dashboard link: https://syzkaller.appspot.com/bug?extid=5214f8dac5863061e37c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13915d68080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13dee200080000

The issue was bisected to:

commit ff7f2926114d3a50f5ffe461a9bce8d761748da5
Author: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Date:   Tue Apr 26 08:18:23 2022 +0000

    Bluetooth: core: Fix missing power_on work cancel on HCI close

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15ea8982080000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17ea8982080000
console output: https://syzkaller.appspot.com/x/log.txt?x=13ea8982080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5214f8dac5863061e37c@syzkaller.appspotmail.com
Fixes: ff7f2926114d ("Bluetooth: core: Fix missing power_on work cancel on HCI close")

------------[ cut here ]------------
notifier callback hci_suspend_notifier already registered
WARNING: CPU: 1 PID: 3898 at kernel/notifier.c:28 notifier_chain_register kernel/notifier.c:28 [inline]
WARNING: CPU: 1 PID: 3898 at kernel/notifier.c:28 notifier_chain_register+0x156/0x210 kernel/notifier.c:22
Modules linked in:
CPU: 1 PID: 3898 Comm: syz-executor172 Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:notifier_chain_register kernel/notifier.c:28 [inline]
RIP: 0010:notifier_chain_register+0x156/0x210 kernel/notifier.c:22
Code: 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 a5 00 00 00 49 8b 75 00 48 c7 c7 c0 d0 cb 89 e8 14 f5 e3 07 <0f> 0b 41 bc ef ff ff ff e8 5d 6f 2a 00 44 89 e0 48 83 c4 18 5b 5d
RSP: 0018:ffffc9000367fca8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88807ae11180 RCX: 0000000000000000
RDX: ffff888076fa3a80 RSI: ffffffff81610608 RDI: fffff520006cff87
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff88807ae11180 R14: ffff88801bb79188 R15: dffffc0000000000
FS:  0000555556682300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe4d8d866e8 CR3: 0000000070960000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __blocking_notifier_chain_register kernel/notifier.c:266 [inline]
 blocking_notifier_chain_register+0x6f/0xc0 kernel/notifier.c:284
 hci_register_suspend_notifier net/bluetooth/hci_core.c:2752 [inline]
 hci_register_suspend_notifier+0x9d/0xc0 net/bluetooth/hci_core.c:2746
 hci_sock_bind+0x141a/0x1630 net/bluetooth/hci_sock.c:1234
 __sys_bind+0x1e9/0x250 net/socket.c:1776
 __do_sys_bind net/socket.c:1787 [inline]
 __se_sys_bind net/socket.c:1785 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1785
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe4d8d314a9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5c71ae28 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fe4d8d314a9
RDX: 0000000000000006 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 0000000000000003 R08: 0000000000000150 R09: 0000000000000150
R10: 0000000000000000 R11: 0000000000000246 R12: 00005555566822b8
R13: 0000000000000011 R14: 00007ffe5c71ae90 R15: 00007ffe5c71ae48
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
