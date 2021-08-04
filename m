Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072843DFB1E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 07:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbhHDFfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 01:35:33 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:56301 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhHDFfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 01:35:32 -0400
Received: by mail-io1-f70.google.com with SMTP id f10-20020a6b620a0000b02904e5ab8bdc6cso731190iog.22
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 22:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=dWP63N1iAJI/pUug+0yne7Sw6kGWIyZgoJ55JqnTIsg=;
        b=MrLU2U8BcVCUp4nJpPTnDAaH8QjDXUIG0OHReIOvoO1faeI0P+QMAaG3Wh2zMDzW4+
         EZGJ04cE7Oc1TzJEWkhuvLrq/86rGaDdbm3pfcMHrXa83CzlXKAObmTsk1oslDsbr7oC
         S7fAtw05gbcTfiqhbZvN67V1wTkW5fid/7qGRE5A7njCQQXZnYdN8fAzMqidJgnWrSn+
         ZCEAJcsKOzmkuiGcwtAK0cCmqeXDOWgeXaR9co14i9ZPy3BKiEMCGTBFfPWXpNq7IvD4
         z2sFExxyFnyLUYtWUut40StBsWYKrf0KUeGk+kxQaZCm4aW82OWewuMIQCPI9iAlU1Zz
         taHg==
X-Gm-Message-State: AOAM533yYjPmjLKNzuAJPSGLExH2i6hwW71i15lwhqsjUeMcsUCGRkPz
        CCxmmE6q9XbiLVqryMI2lGWURZZA9HjX2CHJ+LGdK3HcC8qJ
X-Google-Smtp-Source: ABdhPJy6+HITYvauDQkhzO7rfPSNDE5/FgtZblRf/Dh6oNReT4TaDg+YIy1CzVohEK0Gy4kHHwVcfa4QbeTUiRJ7T8pE2Xp9qGVz
MIME-Version: 1.0
X-Received: by 2002:a5d:9eda:: with SMTP id a26mr821004ioe.166.1628055320265;
 Tue, 03 Aug 2021 22:35:20 -0700 (PDT)
Date:   Tue, 03 Aug 2021 22:35:20 -0700
In-Reply-To: <00000000000092839d0581fd74ad@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a0c4005c8b52bf3@google.com>
Subject: Re: [syzbot] WARNING in __vunmap
From:   syzbot <syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com>
To:     ali.hamid@alimam.biz, davem@davemloft.net, hdanton@sina.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d5ad8ec3cfb5 Merge tag 'media/v5.14-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1669619a300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=343fd21f6f4da2d6
dashboard link: https://syzkaller.appspot.com/bug?extid=5ec9bb042ddfe9644773
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c3f142300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154e2121300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com

------------[ cut here ]------------
Trying to vfree() nonexistent vm area (ffffc90002bc9000)
WARNING: CPU: 0 PID: 8497 at mm/vmalloc.c:2567 __vunmap+0x150/0xb70 mm/vmalloc.c:2567
Modules linked in:
CPU: 1 PID: 8497 Comm: syz-executor174 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__vunmap+0x150/0xb70 mm/vmalloc.c:2567
Code: 85 78 ff ff ff e8 20 b0 c4 ff 48 c7 c7 c0 7c a9 8b e8 44 ed 7b 07 e8 0f b0 c4 ff 4c 89 e6 48 c7 c7 e0 bb 96 89 e8 c1 05 37 07 <0f> 0b 48 83 c4 38 5b 5d 41 5c 41 5d 41 5e 41 5f e9 eb af c4 ff e8
RSP: 0018:ffffc900023b72d8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888028c00000 RSI: ffffffff815d7935 RDI: fffff52000476e4d
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d176e R11: 0000000000000000 R12: ffffc90002bc9000
R13: ffff8880253d20c0 R14: ffffc90002bc9000 R15: ffffe8ffffc338a8
FS:  00007fcdcc063700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcdcc084718 CR3: 00000000159f1000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __vfree+0x3c/0xd0 mm/vmalloc.c:2635
 vfree+0x5a/0x90 mm/vmalloc.c:2666
 ipcomp_free_scratches+0xc4/0x160 net/xfrm/xfrm_ipcomp.c:203
 ipcomp_free_data net/xfrm/xfrm_ipcomp.c:312 [inline]
 ipcomp_init_state+0x77c/0xa40 net/xfrm/xfrm_ipcomp.c:364
 ipcomp6_init_state+0xc2/0x700 net/ipv6/ipcomp6.c:154
 __xfrm_init_state+0x995/0x15c0 net/xfrm/xfrm_state.c:2648
 xfrm_state_construct net/xfrm/xfrm_user.c:627 [inline]
 xfrm_add_sa+0x1ef1/0x35f0 net/xfrm/xfrm_user.c:684
 xfrm_user_rcv_msg+0x42c/0x8b0 net/xfrm/xfrm_user.c:2812
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x445b99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcdcc063318 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004ca428 RCX: 0000000000445b99
RDX: 0000000000000000 RSI: 0000000020000800 RDI: 0000000000000004
RBP: 00000000004ca420 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004ca42c
R13: 00007ffec83642cf R14: 00007fcdcc063400 R15: 0000000000022000

