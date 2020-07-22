Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1665A22992F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 15:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbgGVN1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 09:27:20 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:52469 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgGVN1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 09:27:19 -0400
Received: by mail-io1-f71.google.com with SMTP id k12so1799441iom.19
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 06:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Hem7p8hNe4Qugd6M1b99iDXjRu4+oidWXJdfZNavWOE=;
        b=mWGHp433XF56as/R4A7FUPZB3YWU0vDHUnBZ9N66mKVdvG0vs3wbUPk1Vnt85Fiq+K
         vsaV38HgYwwBbb5fniallCLAICkl950RyAgezlNr18ZbtpdJ5anwu48NUydknLNMtQme
         wSNQ30TjA1cKGNZIUPpyGjE9/NAIXSvvOP2rfZXAM2coYtLLDNCPMxjKBhEBEz9OV6t6
         E8yU6umihbt5i3HWwHhf86eQ2k05tsHtyXgCAIqAZr7FuIDmMBKjl9Hu5m0+NfA3/cXZ
         TJXTkD0S9MeNOAwqDGAtoo/lJda3aceOZ++cuKqCb+UBFgeF87iSesAevHl1sY5fmRef
         EbNg==
X-Gm-Message-State: AOAM531z06zVcwKQaXFYyAzYB3UMIfw3zonLGahE5qOBS6OhnFf94QmQ
        iKGsF4ZZ9xpCXEerfwDBNK+SUKtzZLId7x38JDbB/JocjT/J
X-Google-Smtp-Source: ABdhPJzaQ1IAy7nlO8mPL6HyYvAHN3Ozns9AEYm2QpmC92toebkFEIfSl2bdmNJnyfMNwsxCYJE+d46o5PIFYckoEzos5cGbnQf6
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f85:: with SMTP id v5mr32202839ilo.31.1595424437340;
 Wed, 22 Jul 2020 06:27:17 -0700 (PDT)
Date:   Wed, 22 Jul 2020 06:27:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000da8ee505ab07b2e0@google.com>
Subject: general protection fault in udp_tunnel_notify_del_rx_port
From:   syzbot <syzbot+a41f2e0a3a2dad7febb0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    88825726 Merge tag 'drm-fixes-2020-07-17-1' of git://anong..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=143518bb100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a160d1053fc89af5
dashboard link: https://syzkaller.appspot.com/bug?extid=a41f2e0a3a2dad7febb0
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a41f2e0a3a2dad7febb0@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000003b: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000001d8-0x00000000000001df]
CPU: 0 PID: 22020 Comm: syz-executor.2 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:udp_tunnel_notify_del_rx_port+0x1e8/0x3f0 net/ipv4/udp_tunnel.c:161
Code: 01 00 00 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 e0 01 00 00 4c 8b a3 e0 01 00 00 49 8d bc 24 d8 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 b6 01 00 00 4d 8b a4 24 d8 01 00 00 4d 85 e4 74
RSP: 0018:ffffc900165ef810 EFLAGS: 00010202
RAX: 000000000000003b RBX: ffff888000102000 RCX: ffffc9000d7a2000
RDX: 0000000000040000 RSI: ffffffff86c7005a RDI: 00000000000001d8
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8c599a27
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88805b9c0210 R14: ffffc900165ef838 R15: ffff88809dffa268
FS:  00007f890f5fa700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000004 CR3: 00000000614b3000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __geneve_sock_release.part.0+0x13d/0x1e0 drivers/net/geneve.c:610
 __geneve_sock_release drivers/net/geneve.c:631 [inline]
 geneve_sock_release+0x1bf/0x290 drivers/net/geneve.c:629
 geneve_stop+0x198/0x200 drivers/net/geneve.c:720
 __dev_close_many+0x1b3/0x2e0 net/core/dev.c:1599
 __dev_close net/core/dev.c:1611 [inline]
 __dev_change_flags+0x272/0x660 net/core/dev.c:8276
 dev_change_flags+0x8a/0x160 net/core/dev.c:8349
 devinet_ioctl+0x14fd/0x1ca0 net/ipv4/devinet.c:1143
 inet_ioctl+0x1ea/0x330 net/ipv4/af_inet.c:964
 sock_do_ioctl+0xcb/0x2d0 net/socket.c:1048
 sock_ioctl+0x3b8/0x730 net/socket.c:1199
 vfs_ioctl fs/ioctl.c:48 [inline]
 ksys_ioctl+0x11a/0x180 fs/ioctl.c:753
 __do_sys_ioctl fs/ioctl.c:762 [inline]
 __se_sys_ioctl fs/ioctl.c:760 [inline]
 __x64_sys_ioctl+0x6f/0xb0 fs/ioctl.c:760
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c1d9
Code: Bad RIP value.
RSP: 002b:00007f890f5f9c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000013e00 RCX: 000000000045c1d9
RDX: 0000000020000000 RSI: 0000000000008914 RDI: 0000000000000003
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
R13: 0000000000c9fb6f R14: 00007f890f5fa9c0 R15: 000000000078bf0c
Modules linked in:
---[ end trace 82520c6676e9d8d2 ]---
RIP: 0010:udp_tunnel_notify_del_rx_port+0x1e8/0x3f0 net/ipv4/udp_tunnel.c:161
Code: 01 00 00 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 e0 01 00 00 4c 8b a3 e0 01 00 00 49 8d bc 24 d8 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 b6 01 00 00 4d 8b a4 24 d8 01 00 00 4d 85 e4 74
RSP: 0018:ffffc900165ef810 EFLAGS: 00010202
RAX: 000000000000003b RBX: ffff888000102000 RCX: ffffc9000d7a2000
RDX: 0000000000040000 RSI: ffffffff86c7005a RDI: 00000000000001d8
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffffff8c599a27
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88805b9c0210 R14: ffffc900165ef838 R15: ffff88809dffa268
FS:  00007f890f5fa700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f890f575db8 CR3: 00000000614b3000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
