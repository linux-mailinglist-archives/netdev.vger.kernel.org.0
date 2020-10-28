Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B208329D8D1
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388371AbgJ1WgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:36:20 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39476 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388434AbgJ1Wdt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:33:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B6360205A9;
        Wed, 28 Oct 2020 11:45:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id obkiekkmCsOh; Wed, 28 Oct 2020 11:45:10 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 90A3620512;
        Wed, 28 Oct 2020 11:45:10 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 28 Oct 2020 11:45:10 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 28 Oct
 2020 11:45:10 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id EA627318136E;
 Wed, 28 Oct 2020 11:45:09 +0100 (CET)
Date:   Wed, 28 Oct 2020 11:45:09 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     syzbot <syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com>,
        "Dmitry Safonov" <dima@arista.com>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING in xfrm_alloc_compat
Message-ID: <20201028104509.GB8805@gauss3.secunet.de>
References: <00000000000021315205b29353aa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <00000000000021315205b29353aa@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same here, Dmitry please look into it.

I guess we can just remove the WARN_ON() that
triggeres here.

On Mon, Oct 26, 2020 at 06:58:28AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f11901ed Merge tag 'xfs-5.10-merge-7' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17b35564500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fb79b5c2dc1e69e3
> dashboard link: https://syzkaller.appspot.com/bug?extid=a7e701c8385bd8543074
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com
> 
> netlink: 404 bytes leftover after parsing attributes in process `syz-executor.4'.
> ------------[ cut here ]------------
> unsupported nla_type 0
> WARNING: CPU: 0 PID: 9953 at net/xfrm/xfrm_compat.c:279 xfrm_xlate64_attr net/xfrm/xfrm_compat.c:279 [inline]
> WARNING: CPU: 0 PID: 9953 at net/xfrm/xfrm_compat.c:279 xfrm_xlate64 net/xfrm/xfrm_compat.c:300 [inline]
> WARNING: CPU: 0 PID: 9953 at net/xfrm/xfrm_compat.c:279 xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:327
> Modules linked in:
> CPU: 0 PID: 9953 Comm: syz-executor.4 Not tainted 5.9.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:xfrm_xlate64_attr net/xfrm/xfrm_compat.c:279 [inline]
> RIP: 0010:xfrm_xlate64 net/xfrm/xfrm_compat.c:300 [inline]
> RIP: 0010:xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:327
> Code: de e8 4b 68 d3 f9 84 db 0f 85 b0 f8 ff ff e8 2e 70 d3 f9 8b 74 24 08 48 c7 c7 40 b9 51 8a c6 05 f7 0d 3c 05 01 e8 b7 db 0e 01 <0f> 0b e9 8d f8 ff ff e8 0b 70 d3 f9 8b 14 24 48 c7 c7 00 b9 51 8a
> RSP: 0018:ffffc9000bb4f4b8 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000040000 RSI: ffffffff8158cf25 RDI: fffff52001769e89
> RBP: 00000000000001a0 R08: 0000000000000001 R09: ffff8880b9e2005b
> R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffa1
> R13: ffff88802ed1d8f8 R14: ffff888014403c80 R15: ffff88801514fc80
> FS:  00007f188bbe6700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000074b698 CR3: 000000001aabe000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  xfrm_alloc_userspi+0x66a/0xa30 net/xfrm/xfrm_user.c:1388
>  xfrm_user_rcv_msg+0x42f/0x8b0 net/xfrm/xfrm_user.c:2752
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2764
>  netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
>  sock_sendmsg_nosec net/socket.c:651 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:671
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45de59
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f188bbe5c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000002e640 RCX: 000000000045de59
> RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
> RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
> R13: 000000000169fb7f R14: 00007f188bbe69c0 R15: 000000000118bf2c
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
