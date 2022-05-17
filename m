Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1E352AA38
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351967AbiEQSMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351985AbiEQSMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:12:30 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43575133A
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:12:22 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id i66-20020a6bb845000000b00657bac76fb4so12897946iof.15
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 11:12:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Aw7uWPlnCQDdmui5m+mgLu0Iob0U3Ta9YLf8ADEdGks=;
        b=T3H8BLJ9KLGTKA8JWCjXOij3LiEC9zylTyVBJmd6ljsrVQRDcWaieWHYrRcWw+TWl7
         Uizh9DDBivM1u82F6qPtNdP4UDZZZc3SLe8etj5bKzwstbOm27wqvndKQcsls3crVscD
         +SlRyO2STkkTlBHEhGEfFH7SAIFKs/RqcRhCv2mb770nErfI6PwZ7nkdcB+9e/DRdevY
         +72mErsPhvyscW2HAVbygD9jtTNtvfGUD5BaomcTd38dhCxlR4gV3uiVrmY4po4Rv8zT
         /BBCmaeTiPKLxUNTg77A0gz4FcPdwtdFAkgc/Omsrox7MYIQKzfKsWkjDr+SM1zlD9Um
         aoZw==
X-Gm-Message-State: AOAM530+AlyaItF+oM4BCPCVDW8P8lDS/Sy7sJs2zRycXHDWfavlJRcc
        oGfta2N626lwLaTYevB3gXUAYFJ+hGqvx4AlQF4MU3ZNbsC5
X-Google-Smtp-Source: ABdhPJwCK5cHV8+sYepbR7Oy12L/Z261cSXDMON3P5HSx+Jeog9skRf1vYsCOtMs3VE/paQpDoTurjsh+fZRvYSM0UnByonVKa5J
MIME-Version: 1.0
X-Received: by 2002:a02:c898:0:b0:32e:120b:cdf9 with SMTP id
 m24-20020a02c898000000b0032e120bcdf9mr9000904jao.158.1652811141946; Tue, 17
 May 2022 11:12:21 -0700 (PDT)
Date:   Tue, 17 May 2022 11:12:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ff239c05df391402@google.com>
Subject: [syzbot] WARNING in nfnetlink_unbind
From:   syzbot <syzbot+afd2d80e495f96049571@syzkaller.appspotmail.com>
To:     ali.abdallah@suse.com, coreteam@netfilter.org, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        ozsh@nvidia.com, pabeni@redhat.com, pablo@netfilter.org,
        paulb@nvidia.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    f7b88d9ae91e Merge tag 'linux-can-next-for-5.19-20220516' ..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14f791aef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c05eee2efc702eed
dashboard link: https://syzkaller.appspot.com/bug?extid=afd2d80e495f96049571
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ba8ae9f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ef1295f00000

The issue was bisected to:

commit 2794cdb0b97bfe62d25c996c8afe4832207e78bc
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Apr 25 13:15:41 2022 +0000

    netfilter: nfnetlink: allow to detect if ctnetlink listeners exist

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13cb5bbef00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=102b5bbef00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17cb5bbef00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+afd2d80e495f96049571@syzkaller.appspotmail.com
Fixes: 2794cdb0b97b ("netfilter: nfnetlink: allow to detect if ctnetlink listeners exist")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3600 at net/netfilter/nfnetlink.c:703 nfnetlink_unbind net/netfilter/nfnetlink.c:703 [inline]
WARNING: CPU: 0 PID: 3600 at net/netfilter/nfnetlink.c:703 nfnetlink_unbind+0x357/0x3b0 net/netfilter/nfnetlink.c:694
Modules linked in:
CPU: 0 PID: 3600 Comm: syz-executor186 Not tainted 5.18.0-rc6-syzkaller-01545-gf7b88d9ae91e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nfnetlink_unbind net/netfilter/nfnetlink.c:703 [inline]
RIP: 0010:nfnetlink_unbind+0x357/0x3b0 net/netfilter/nfnetlink.c:694
Code: f9 48 c7 c2 00 0d d8 8a be b7 02 00 00 48 c7 c7 60 0d d8 8a c6 05 91 3d 14 06 01 e8 38 36 9b 01 e9 6e fd ff ff e8 09 66 e8 f9 <0f> 0b 41 c7 04 24 ff ff ff ff e9 9d fe ff ff e8 a5 7a 34 fa e9 dd
RSP: 0018:ffffc90002e8fcf8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801bd11d80 RSI: ffffffff8790d397 RDI: 0000000000000003
RBP: ffffffff90947640 R08: 0000000000000000 R09: ffffc90002e8fc37
R10: ffffffff8790d1e8 R11: 0000000000000001 R12: ffff8880230b4d20
R13: ffff88814c73b000 R14: ffff888016aab518 R15: ffff888016aab000
FS:  0000555557248300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001280 CR3: 000000001f866000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 netlink_setsockopt+0x932/0xda0 net/netlink/af_netlink.c:1661
 __sys_setsockopt+0x2db/0x6a0 net/socket.c:2227
 __do_sys_setsockopt net/socket.c:2238 [inline]
 __se_sys_setsockopt net/socket.c:2235 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2235
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f37f8e5faf9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef051fc88 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f37f8e5faf9
RDX: 0000000000000002 RSI: 000000000000010e RDI: 0000000000000003
RBP: 00007f37f8e23ca0 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000020001280 R11: 0000000000000246 R12: 00007f37f8e23d30
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
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
