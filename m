Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F39175301
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 06:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCBFMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 00:12:15 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:41858 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgCBFMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 00:12:13 -0500
Received: by mail-io1-f72.google.com with SMTP id n15so3425215iog.8
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 21:12:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XqZKveBobBiwl0AcbXytSoKgoD9CmbhVMu+cMaGUVdU=;
        b=BJVxTIjCMgaIpgtkYNaA5lPaTgcM2cQugtQXDeDOxAvTRWpaXDhp/wQlxZftPtZ/lF
         ad5FelXWM2bq7BDeDc5d8jEBj+Vouj+RQFdkLbmJ8qY5I6k5tu3PH6tH0W5otIHMMUAd
         /emjIXkoPvnXRRkMCJJbRNDd/mPLymvvrjsrSMINUBA2M8Me7kf1XlfHFGeB1nTAx/vh
         RXxwWkfu8ouA12ZNqEyJv7EJbjaKvyWSx3AF90v2slIPJjf/3ZPpfWAFFBZGskYDDLQe
         2CqZ7BJkSSH7rTD+ylrFtHisO3h4cKtlJ1EBwhoIp9v5hHLVjd0fGQC+BC3j5epWVHU9
         RawQ==
X-Gm-Message-State: ANhLgQ0xikUWkyokEAqmppzf2oWAgnTTEFmwp4rnCT7IW/DlWZ7QfpEd
        dWLMFhQjxZPlWDhJs30bVlFJqXHGk+H6uqjz3u7xmqArBbMn
X-Google-Smtp-Source: ADFU+vsBjB7bEx1SrJcDf0XBJrejw80kl/9b5RP32LuqJY8JBLV1TJ79i14KHuuiSCkaGrmkxr7GQr7S34dYT3Z9LBA8wpDe9Ymz
MIME-Version: 1.0
X-Received: by 2002:a92:1ddb:: with SMTP id g88mr4531042ile.56.1583125931272;
 Sun, 01 Mar 2020 21:12:11 -0800 (PST)
Date:   Sun, 01 Mar 2020 21:12:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c4b371059fd83a92@google.com>
Subject: general protection fault in kobject_get
From:   syzbot <syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3b3e808c Merge tag 'mac80211-next-for-net-next-2020-02-24'..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15e20a2de00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ec9623400ee72
dashboard link: https://syzkaller.appspot.com/bug?extid=46fe08363dbba223dec5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+46fe08363dbba223dec5@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc00000000ba: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000005d0-0x00000000000005d7]
CPU: 0 PID: 20851 Comm: syz-executor.0 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kobject_get+0x35/0x150 lib/kobject.c:640
Code: 53 e8 3f b0 8b f9 4d 85 e4 0f 84 a2 00 00 00 e8 31 b0 8b f9 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 eb 00 00 00
RSP: 0018:ffffc9000946f1a0 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffffffff85bdbbb0 RCX: ffffc9000bf22000
RDX: 00000000000000ba RSI: ffffffff87e9d78f RDI: 00000000000005d4
RBP: ffffc9000946f1b8 R08: ffff8880581a6440 R09: ffff8880581a6cd0
R10: fffffbfff154b838 R11: ffffffff8aa5c1c7 R12: 0000000000000598
R13: 0000000000000000 R14: ffffc9000946f278 R15: ffff88805cb0c4d0
FS:  00007faa9e8af700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30121000 CR3: 000000004515d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 get_device+0x25/0x40 drivers/base/core.c:2574
 __ib_get_client_nl_info+0x205/0x2e0 drivers/infiniband/core/device.c:1861
 ib_get_client_nl_info+0x35/0x180 drivers/infiniband/core/device.c:1881
 nldev_get_chardev+0x575/0xac0 drivers/infiniband/core/nldev.c:1621
 rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x5d9/0x980 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45c479
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007faa9e8aec78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007faa9e8af6d4 RCX: 000000000045c479
RDX: 0000000000000000 RSI: 0000000020000200 RDI: 0000000000000003
RBP: 000000000076bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009a2 R14: 00000000004d56c0 R15: 000000000076bf2c
Modules linked in:
---[ end trace 48adc6d1ec9b227c ]---
RIP: 0010:kobject_get+0x35/0x150 lib/kobject.c:640
Code: 53 e8 3f b0 8b f9 4d 85 e4 0f 84 a2 00 00 00 e8 31 b0 8b f9 49 8d 7c 24 3c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 eb 00 00 00
RSP: 0018:ffffc9000946f1a0 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: ffffffff85bdbbb0 RCX: ffffc9000bf22000
RDX: 00000000000000ba RSI: ffffffff87e9d78f RDI: 00000000000005d4
RBP: ffffc9000946f1b8 R08: ffff8880581a6440 R09: ffff8880581a6cd0
R10: fffffbfff154b838 R11: ffffffff8aa5c1c7 R12: 0000000000000598
R13: 0000000000000000 R14: ffffc9000946f278 R15: ffff88805cb0c4d0
FS:  00007faa9e8af700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff582e8e000 CR3: 000000004515d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
