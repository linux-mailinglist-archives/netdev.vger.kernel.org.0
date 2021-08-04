Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDC13E06BA
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 19:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239902AbhHDR2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 13:28:39 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36640 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239814AbhHDR2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 13:28:35 -0400
Received: by mail-io1-f70.google.com with SMTP id k20-20020a6b6f140000b029053817be16cdso1933329ioc.3
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 10:28:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Cld7LSU+rFnfR7Y1O3V+IsC69HwIxzTjlFhiOaLjv7o=;
        b=JWy1RSQbzhVceYaeSemijK6XQo+WW/RmDygF9mIbm1iXGZRGEA+PV/rUHq/J2XBVC3
         3kjPj+fywA82KIQxB95n8IhPJshAyTuqSHmcwX/mEE9UB6+pAPRP4zPPF1UQZFmenXji
         Ie3cF5O+IWiZRwUjms5JFd4rDqqDgyrEQkP04Vo8bjI8OPCsXQw+w6R9Z40WfE6LOldH
         WDAWMYcP+jnYUY8lRrkBwLPJ6bPzi33V8ty3kTL3Dfv4s3kZSrsitbNe+j1K6aa67zCZ
         T4XVkW5xtI7QOt+2BBG8sIjNhnFZzL6+6rmKQ9/yjHTuO68VeaJXdru3utVO6DwqcKYe
         pTPg==
X-Gm-Message-State: AOAM5337pKzXo8su9a8DWAN968+udNfgv6SkI0mP4J937m3J5yExJkXh
        pJzX5Ar7utzMu2UZpB3bQA3Re1AXoMNU6uo1bbasyERc/VAU
X-Google-Smtp-Source: ABdhPJxOFBBhVQF9U9kWBKzmuoDhek0WC71czQkBinHZTBQAOorwNva3GRkyVPL6HvT2K85Kxgt31eRYFjfapQzWxKG8/Z1L+ToQ
MIME-Version: 1.0
X-Received: by 2002:a05:6602:21d6:: with SMTP id c22mr106467ioc.69.1628098102350;
 Wed, 04 Aug 2021 10:28:22 -0700 (PDT)
Date:   Wed, 04 Aug 2021 10:28:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000cda0605c8bf219e@google.com>
Subject: [syzbot] WARNING: proc registration bug in clusterip_tg_check (3)
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

Hello,

syzbot found the following issue on:

HEAD commit:    4039146777a9 net: ipv6: fix returned variable type in ip6_..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=112e9a8e300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bfd78f4abd4edaa6
dashboard link: https://syzkaller.appspot.com/bug?extid=08e6343a8cbd89b0c9d8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1555b98e300000

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
proc_dir_entry 'ipt_CLUSTERIP/172.30.0.3' already registered
WARNING: CPU: 1 PID: 7506 at fs/proc/generic.c:376 proc_register+0x34c/0x700 fs/proc/generic.c:376
Modules linked in:
CPU: 1 PID: 7506 Comm: syz-executor.2 Not tainted 5.14.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:proc_register+0x34c/0x700 fs/proc/generic.c:376
Code: df 48 89 f9 48 c1 e9 03 80 3c 01 00 0f 85 5d 03 00 00 48 8b 44 24 28 48 c7 c7 20 64 9c 89 48 8b b0 d8 00 00 00 e8 85 b2 f7 06 <0f> 0b 48 c7 c7 20 2c b4 8b e8 36 a0 3c 07 48 8b 4c 24 38 48 b8 00
RSP: 0018:ffffc90002fdf3e8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801ac9b880 RSI: ffffffff815d7935 RDI: fffff520005fbe6f
RBP: ffff888020f320b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d176e R11: 0000000000000000 R12: ffff88804449b218
R13: ffff88804699b700 R14: dffffc0000000000 R15: 000000000000000a
FS:  00007f2fa9dcc700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2fa9dcc718 CR3: 0000000036ad1000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 proc_create_data+0x130/0x190 fs/proc/generic.c:575
 clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:281 [inline]
 clusterip_tg_check+0x1834/0x1e40 net/ipv4/netfilter/ipt_CLUSTERIP.c:502
 xt_check_target+0x26c/0x9e0 net/netfilter/x_tables.c:1024
 check_target net/ipv4/netfilter/ip_tables.c:511 [inline]
 find_check_entry.constprop.0+0x7a9/0x9a0 net/ipv4/netfilter/ip_tables.c:553
 translate_table+0xc26/0x16a0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1135 [inline]
 do_ipt_set_ctl+0x56e/0xb80 net/ipv4/netfilter/ip_tables.c:1629
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0x3c3/0x3a60 net/ipv4/ip_sockglue.c:1435
 udp_setsockopt+0x76/0xc0 net/ipv4/udp.c:2771
 __sys_setsockopt+0x2db/0x610 net/socket.c:2159
 __do_sys_setsockopt net/socket.c:2170 [inline]
 __se_sys_setsockopt net/socket.c:2167 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2167
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2fa9dcc188 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665e9
RDX: 0000000000000040 RSI: 8001000000000000 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 00000000000002a8 R09: 0000000000000000
R10: 00000000200004c0 R11: 0000000000000246 R12: 000000000056c038
R13: 00007fffa358c32f R14: 00007f2fa9dcc300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
