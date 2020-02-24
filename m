Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECD43169FBC
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 09:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBXIIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 03:08:16 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:36320 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgBXIIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 03:08:14 -0500
Received: by mail-io1-f70.google.com with SMTP id d13so14223673ioc.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 00:08:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Wna1rMldzsmbnjszH8n3rODL+05VVA6Ale5k8VVJ2i4=;
        b=Zd6ztrIg0kEiX1+EDcvwOkj6dzOEK/2uuVtkHcgds96iO6Lt6HIKV3xK4EtEFD4aXR
         jPHBIGvGb2nHyb1ssV6OShRbysyvuVDC7g9Kx4Y5nVW5r7w8gJmR3PzG3SO2GlWidkWn
         Y6FO7LRL5jhkJ+6k00sbppAzMSM4awLm6ON8G0joilicaswagZSFwg2/+ubLdqM0D1gX
         MQYjBbywRs3ObJJH3etdAsHi58iCDq96ahY7tLGQAhwf28+3DXzYyj4DIIDKP0pz1CLv
         dOps8Znvg7QTZj4yn/E/GEPArFmWIWvAwdj0ZdzFBc3BbZK//Vkm5nUbJWCSUhTEsSJ2
         ugGQ==
X-Gm-Message-State: APjAAAVcrJ+0HeHNEMU0ftFRsO7q0l9apyq45cAgVO6kKmOHNOtGqGst
        Rg8muHIvxc6qndIZZfRGjqc0kL3XYAquXWOGhMJM1fgRC0wC
X-Google-Smtp-Source: APXvYqyvSyynHQG4jiljx7UD/b0fRBe/Nar2IzCegIL4JyjWa1ESBPfuOi1gU9+drfh+dlzfeBgOhWR3+WmkaRWZM6CYPwgpv1IS
MIME-Version: 1.0
X-Received: by 2002:a92:3a9b:: with SMTP id i27mr60243880ilf.39.1582531692452;
 Mon, 24 Feb 2020 00:08:12 -0800 (PST)
Date:   Mon, 24 Feb 2020 00:08:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fe204059f4ddf27@google.com>
Subject: kernel panic: audit: rate limit exceeded
From:   syzbot <syzbot+72461ac44b36c98f58e5@syzkaller.appspotmail.com>
To:     eparis@redhat.com, kvalo@codeaurora.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, peter.senna@collabora.com,
        romain.perier@collabora.com, stas.yakovlev@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0c0ddd6a Merge tag 'linux-watchdog-5.6-rc3' of git://www.l..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12c8a3d9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3b8906eb6a7d6028
dashboard link: https://syzkaller.appspot.com/bug?extid=72461ac44b36c98f58e5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c803ede00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17237de9e00000

The bug was bisected to:

commit 28b75415ad19fef232d8daab4d5de17d753f0b36
Author: Romain Perier <romain.perier@collabora.com>
Date:   Wed Aug 23 07:16:51 2017 +0000

    wireless: ipw2200: Replace PCI pool old API

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12dbfe09e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11dbfe09e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16dbfe09e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+72461ac44b36c98f58e5@syzkaller.appspotmail.com
Fixes: 28b75415ad19 ("wireless: ipw2200: Replace PCI pool old API")

audit: audit_lost=1 audit_rate_limit=2 audit_backlog_limit=0
Kernel panic - not syncing: audit: rate limit exceeded
CPU: 1 PID: 10031 Comm: syz-executor626 Not tainted 5.6.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 audit_panic.cold+0x32/0x32 kernel/audit.c:307
 audit_log_lost kernel/audit.c:377 [inline]
 audit_log_lost+0x8b/0x180 kernel/audit.c:349
 audit_log_end+0x23c/0x2b0 kernel/audit.c:2322
 audit_log_config_change+0xcc/0xf0 kernel/audit.c:396
 audit_receive_msg+0x2246/0x28b0 kernel/audit.c:1277
 audit_receive+0x114/0x230 kernel/audit.c:1513
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
RIP: 0033:0x441239
Code: e8 fc ab 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd68c9df48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000441239
RDX: 0000000000000000 RSI: 00000000200006c0 RDI: 0000000000000003
RBP: 0000000000018b16 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000402060
R13: 00000000004020f0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
