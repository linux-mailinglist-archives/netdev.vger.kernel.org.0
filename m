Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA4A410619
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 13:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhIRLvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 07:51:46 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:56022 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhIRLvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 07:51:45 -0400
Received: by mail-io1-f72.google.com with SMTP id o128-20020a6bbe86000000b005bd06eaeca6so23694487iof.22
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 04:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=utQtz5kLI9mtlnXSS1nlTSAnSAjyT70bJPJgD0jduRw=;
        b=5amYHv3vt7kA/FipXfYRBIbGDtN4ELw58t0LVwM1XTRnsxKI9/9rz5KtVg5cCvLjvX
         WeA50H2/PSUNUtvpbVKReuBV1TrutJzXgbC5+wX0UwsHh5Jko5lYpHny6lUbi5XnbdTU
         XaNzivr1hwIb+9cUZhq3RR682+ZKwk/B5Y419d8tV9a31N5/ytvfMYYMFUGY9AS8PaDo
         6QjQXPBwSluFG8ONAXmxoAoiU52BPZM1H9PulpRlpLJYB2nXudY+sPYqHXGZURtL1sIi
         MhtVUIp3/ktfxlbiqGsV/rp3iGiHQX2YmO1zy4kb2cX5gzsVOpRlpdBAiih0LST01uqm
         vtSw==
X-Gm-Message-State: AOAM5313dm1P9tvqLS7UNNeN/lNZ25ty1CATTE5BnTXffMdIJF4qaIc1
        8rDNhd446FyfmbvWy4YoRtSHbaFL2uv2t6XJ9jiyQiBQIv5I
X-Google-Smtp-Source: ABdhPJwbX2uOhxn5tDv94RyABYbNGvBG73YRbOiV75lWhWriYhJlJziaW/XH2aXqIGSaKS6IzWR+klEcg+FcdGCac0ugxibKQ8m5
MIME-Version: 1.0
X-Received: by 2002:a5e:da08:: with SMTP id x8mr12132404ioj.58.1631965821637;
 Sat, 18 Sep 2021 04:50:21 -0700 (PDT)
Date:   Sat, 18 Sep 2021 04:50:21 -0700
In-Reply-To: <000000000000bf031105cc00ced8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000015991c05cc43a736@google.com>
Subject: Re: [syzbot] WARNING in mptcp_sendmsg_frag
From:   syzbot <syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    02319bf15acf net: dsa: bcm_sf2: Fix array overrun in bcm_s..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=170f9e27300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d93fe4341f98704
dashboard link: https://syzkaller.appspot.com/bug?extid=263a248eec3e875baa7b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1507cd8d300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174c8017300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7032 at net/mptcp/protocol.c:1366 mptcp_sendmsg_frag+0x1362/0x1bc0 net/mptcp/protocol.c:1366
Modules linked in:
CPU: 1 PID: 7032 Comm: syz-executor845 Not tainted 5.15.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mptcp_sendmsg_frag+0x1362/0x1bc0 net/mptcp/protocol.c:1366
Code: ff 4c 8b 74 24 50 48 8b 5c 24 58 e9 0f fb ff ff e8 83 40 8b f8 4c 89 e7 45 31 ed e8 88 57 2e fe e9 81 f4 ff ff e8 6e 40 8b f8 <0f> 0b 41 bd ea ff ff ff e9 6f f4 ff ff 4c 89 e7 e8 b9 89 d2 f8 e9
RSP: 0018:ffffc90003acf830 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888072918000 RSI: ffffffff88eacb72 RDI: 0000000000000003
RBP: ffff88807a182580 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff88eac1a7 R11: 0000000000000000 R12: ffff88801a08a000
R13: 0000000000000000 R14: ffff888018cb9b80 R15: ffff88801b4f2340
FS:  000055555723b300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000380 CR3: 000000007bebe000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __mptcp_push_pending+0x1fb/0x6b0 net/mptcp/protocol.c:1547
 mptcp_sendmsg+0xc29/0x1bc0 net/mptcp/protocol.c:1748
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:643
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_write_iter+0x2a0/0x3e0 net/socket.c:1057
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x40b/0x640 fs/read_write.c:507
 vfs_write+0x7cf/0xae0 fs/read_write.c:594
 ksys_write+0x1ee/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f40ee3c4fb9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd96b7a0f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f40ee3c4fb9
RDX: 00000000000e7b78 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000f0b5ff R09: 0000000000f0b5ff
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000012096
R13: 00007ffd96b7a120 R14: 00007ffd96b7a110 R15: 00007ffd96b7a104

