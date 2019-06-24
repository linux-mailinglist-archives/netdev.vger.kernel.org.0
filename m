Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE96E50B89
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfFXNLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:11:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42523 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfFXNLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:11:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so13836005wrl.9;
        Mon, 24 Jun 2019 06:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=npt0LXugKTy+hAXtUpWeDiX4zCU8WFS28RZle6+ljmk=;
        b=AlUMdKFkaAbuuNWDpspDhpDXIsefNdvWQeU2ySenv/4woxswMeXIzkgKRpDG8qfeg1
         ZcVbi8IFJNDw6XZzeCHRn2VqWnVDN6YkwyQdkDC18yrZwLlgVoK0Go9YL2cAkPQBzV5e
         RDk5OyEI7gYbeWAbWcJjAVanEbOtcES0QpVjiZ0Vi7y4ibE+2V5qwZ9It6TtHUH9YEwA
         kYDJn3q35o4XWJ562xayC8Tsu0bJzqQn9/X1fvww6I743/Q2vtFF7bMRV9CuWQvxBtSS
         LSqYgzYRMa5KAA3SMsXudxswpJqAMNQ4n+GGXSTpU2nkBk+Dz8u1Zrt9DEy5KqpnpnrX
         HNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=npt0LXugKTy+hAXtUpWeDiX4zCU8WFS28RZle6+ljmk=;
        b=aFJRnLuF+S5tnCqKQ+u3HSofkEKpzlTUUnV259Ju3xP33s9KlKtTm7dNWAaH622Ku3
         T1TIAiM6DYlbbLNciTA5W8lqaRg4x8pbFs8kMwjzEjBsAZ/eB++UDPq++2TmMVejy/oE
         z0Fx/ZBrxq9xUwD6IXnEtiXfIeD5kYIgsQXbEOC0mmB19S5olrm/eSiddcD0MYdgW1S6
         Ro4yUGv5XtQzc3EDrxkMJI2EFekYls2wQKqTjFGrNPJ2SN3BLSSCK/WOg8ghYoWeJgPr
         6rn2Mn2b4gx404Meig5ePO/BPgMC8Hae+SRUO94Q47wRLL/az80FYKKqp2OiWIn2zmv2
         fcLA==
X-Gm-Message-State: APjAAAVpC2nRimOT+Onz8RQGe23w+bFTdZbDGR/y+xZiOyk+Z32ty3Ni
        qBEKL/haP7+HOqUp0uQ8Litn5Hhwq+ywLTrflfrS2no+
X-Google-Smtp-Source: APXvYqy1Y8YGwOQzqj7pKOAJDq1n7rwcOgvdN6WttWDlITIKxna9HmlE4pg5VUG3+w9B0qwfXyULF0PYyBQswmnngCA=
X-Received: by 2002:adf:fe86:: with SMTP id l6mr1332207wrr.330.1561381897960;
 Mon, 24 Jun 2019 06:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000064c849058c0cbdc9@google.com>
In-Reply-To: <00000000000064c849058c0cbdc9@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 24 Jun 2019 21:11:26 +0800
Message-ID: <CADvbK_egxQekOXY2aZy_EkyLcEkR9N7Cgd+yd44xFGcCvk9Nog@mail.gmail.com>
Subject: Re: memory leak in sctp_v4_create_accept_sk
To:     syzbot <syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 3:28 PM syzbot
<syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13470eb2a00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=56f1da14935c3cce
> dashboard link: https://syzkaller.appspot.com/bug?extid=afabda3890cc2f765041
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15100a91a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c46026a00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
>
> ffffffffda RBX: 00000000006fbc38 RCX: 0000000000446a79
> BUG: memory leak
> unreferenced object 0xffff888118137680 (size 1352):
>    comm "syz-executor360", pid 7164, jiffies 4294941839 (age 13.960s)
>    hex dump (first 32 bytes):
>      ac 14 ff aa 0a 80 01 1a 00 00 00 00 00 00 00 00  ................
>      02 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  ...@............
>    backtrace:
>      [<000000006c358063>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:43 [inline]
>      [<000000006c358063>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<000000006c358063>] slab_alloc mm/slab.c:3326 [inline]
>      [<000000006c358063>] kmem_cache_alloc+0x134/0x270 mm/slab.c:3488
>      [<00000000f2fb26e7>] sk_prot_alloc+0x41/0x170 net/core/sock.c:1596
>      [<000000003c036edc>] sk_alloc+0x35/0x2f0 net/core/sock.c:1656
>      [<00000000c25725a4>] sctp_v4_create_accept_sk+0x32/0xb0
> net/sctp/protocol.c:556
>      [<0000000049bd7e55>] sctp_accept+0x1df/0x290 net/sctp/socket.c:4913
>      [<00000000d287a63e>] inet_accept+0x4e/0x1d0 net/ipv4/af_inet.c:734
>      [<00000000acb0fc20>] __sys_accept4+0x12a/0x280 net/socket.c:1760
>      [<00000000bbdaf60b>] __do_sys_accept4 net/socket.c:1795 [inline]
>      [<00000000bbdaf60b>] __se_sys_accept4 net/socket.c:1792 [inline]
>      [<00000000bbdaf60b>] __x64_sys_accept4+0x22/0x30 net/socket.c:1792
>      [<000000006da547ee>] do_syscall_64+0x76/0x1a0
> arch/x86/entry/common.c:301
>      [<00000000025f5c93>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
The same issue as "memory leak in sctp_v6_create_accept_sk" one.
Fix:

diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index e358437..69cebb2 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -118,10 +118,6 @@ static struct sctp_endpoint
*sctp_endpoint_init(struct sctp_endpoint *ep,
        /* Initialize the bind addr area */
        sctp_bind_addr_init(&ep->base.bind_addr, 0);

-       /* Remember who we are attached to.  */
-       ep->base.sk = sk;
-       sock_hold(ep->base.sk);
-
        /* Create the lists of associations.  */
        INIT_LIST_HEAD(&ep->asocs);

@@ -154,6 +150,10 @@ static struct sctp_endpoint
*sctp_endpoint_init(struct sctp_endpoint *ep,
        ep->prsctp_enable = net->sctp.prsctp_enable;
        ep->reconf_enable = net->sctp.reconf_enable;

+       /* Remember who we are attached to.  */
+       ep->base.sk = sk;
+       sock_hold(ep->base.sk);
+
        return ep;

 nomem_shkey:

>
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
