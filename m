Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDEC436D1D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbhJUV5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 17:57:38 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:55225 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhJUV5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 17:57:37 -0400
Received: by mail-il1-f198.google.com with SMTP id 2-20020a920d02000000b002589c563709so1187008iln.21
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 14:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Hdk5nhIh5sLeDO5IdMEc5g0BesKce0ZswLkd6aApq38=;
        b=16O6kM0H1q1bZM7+jX/+ZSTvmp6XHxc5A0C53TeaYnriYIbwOSM4vy4lsOArpEVQ+d
         YQNrPRZw2DbSJzYXTr2t/3qC7XNEDwcdtYo10870esakymsskP+cApi207fTx0PAP2+j
         6A06kSzV9lOCy5SIZ4oGohZsQxQ/n4Vw+wvHWjIQm5W6w4LHHEM/1VqFJBsAzNKJmaqZ
         l1aNsKkWeNPadmJ1b/e6eINsirBTLK/YEARoqSLCVOSqi1j6Zau9WfkrMNSNQyp3v8Ct
         bgC3GXoKImRdMLwLUdlVzb+E5koxWvfT1tZyn6s0B3HVEXONgACwBnGsprg8LulfY3X0
         wqJA==
X-Gm-Message-State: AOAM53271IFeODRDI8no/yOYMb82e3BxDLhA/bAcS4H5N42guNCmaf3n
        /P1+jejUhsJpERmBQjPHHHuCIHgycMXElB5LICqEBYvlp6Fm
X-Google-Smtp-Source: ABdhPJx5XM7QufQ3wSVU0f5YXrNUk+MPsJdyBzoANfpzmm6FVUXdyZWMHEodjUzXfJMAe3QQHVg2VyDe+4ZpbTTZSMzJVUAycG6H
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3052:: with SMTP id u18mr5774324jak.148.1634853320905;
 Thu, 21 Oct 2021 14:55:20 -0700 (PDT)
Date:   Thu, 21 Oct 2021 14:55:20 -0700
In-Reply-To: <0000000000000cda0605c8bf219e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000073d78505cee3f389@google.com>
Subject: Re: [syzbot] WARNING: proc registration bug in clusterip_tg_check (3)
From:   syzbot <syzbot+08e6343a8cbd89b0c9d8@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, coreteam@netfilter.org, davem@davemloft.net,
        dsahern@kernel.org, fw@strlen.de, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    2f111a6fd5b5 Merge tag 'ceph-for-5.15-rc7' of git://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13e33db4b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1f7f46d98a0da80e
dashboard link: https://syzkaller.appspot.com/bug?extid=08e6343a8cbd89b0c9d8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f70630b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1033ffecb00000

The issue was bisected to:

commit 2a61d8b883bbad26b06d2e6cc3777a697e78830d
Author: Taehee Yoo <ap420073@gmail.com>
Date:   Mon Nov 5 09:23:13 2018 +0000

    netfilter: ipt_CLUSTERIP: fix sleep-in-atomic bug in clusterip_config_entry_put()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16ce2121300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15ce2121300000
console output: https://syzkaller.appspot.com/x/log.txt?x=11ce2121300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+08e6343a8cbd89b0c9d8@syzkaller.appspotmail.com
Fixes: 2a61d8b883bb ("netfilter: ipt_CLUSTERIP: fix sleep-in-atomic bug in clusterip_config_entry_put()")

------------[ cut here ]------------
proc_dir_entry 'ipt_CLUSTERIP/224.0.0.1' already registered
WARNING: CPU: 1 PID: 24819 at fs/proc/generic.c:376 proc_register+0x34c/0x700 fs/proc/generic.c:376
Modules linked in:
CPU: 1 PID: 24819 Comm: syz-executor269 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:proc_register+0x34c/0x700 fs/proc/generic.c:376
Code: df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 5d 03 00 00 48 8b 44 24 28 48 c7 c7 e0 b1 9c 89 48 8b b0 d8 00 00 00 e8 a0 2c 01 07 <0f> 0b 48 c7 c7 40 ac b4 8b e8 26 c0 46 07 48 8b 4c 24 38 48 b8 00
RSP: 0018:ffffc900041df268 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88806ca35580 RSI: ffffffff815e88a8 RDI: fffff5200083be3f
RBP: ffff88801af3c838 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815e264e R11: 0000000000000000 R12: ffff88801ee5b498
R13: ffff88801ee5bd40 R14: dffffc0000000000 R15: 0000000000000009
FS:  00007f976a6aa700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f976a6aa718 CR3: 00000000697b9000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 proc_create_data+0x130/0x190 fs/proc/generic.c:575
 clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:292 [inline]
 clusterip_tg_check+0x1b83/0x2300 net/ipv4/netfilter/ipt_CLUSTERIP.c:517
 xt_check_target+0x26c/0x9e0 net/netfilter/x_tables.c:1038
 check_target net/ipv4/netfilter/ip_tables.c:511 [inline]
 find_check_entry.constprop.0+0x7a9/0x9a0 net/ipv4/netfilter/ip_tables.c:553
 translate_table+0xc26/0x16a0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1135 [inline]
 do_ipt_set_ctl+0x56e/0xb80 net/ipv4/netfilter/ip_tables.c:1629
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0x3c3/0x3a60 net/ipv4/ip_sockglue.c:1435
 tcp_setsockopt+0x136/0x2530 net/ipv4/tcp.c:3658
 __sys_setsockopt+0x2db/0x610 net/socket.c:2176
 __do_sys_setsockopt net/socket.c:2187 [inline]
 __se_sys_setsockopt net/socket.c:2184 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2184
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f976af2bd19
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f976a6aa208 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f976afb4278 RCX: 00007f976af2bd19
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f976afb4270 R08: 0000000000000298 R09: 0000000000000000
R10: 00000000200002c0 R11: 0000000000000246 R12: 00007f976afb427c
R13: 00007fff7aa240bf R14: 00007f976a6aa300 R15: 0000000000022000

