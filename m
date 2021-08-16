Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F1D3ED134
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 11:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbhHPJp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 05:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbhHPJp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 05:45:26 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F42C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 02:44:55 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id l24so13721184qtj.4
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 02:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c3jFYKt2ZEW9qwQtIdp/SYKRbSkw9qr8gK/+SqARdPE=;
        b=JjyOh+Ny5+y1Msg0xMtuqTz6jmfDcOYT3A8bb5LWMbv0lOckxDscHXKjmPuHbex0Io
         56OgA9E4VsKJ88m80rO2qKjRwh6lmVD2KkZMowMx0YMEgROmRqezNyRmb7hd+lhsGA7W
         oDTbo/1Zu81thv5siPtJ0otX/9Lvi51je/G74635oeO+UPMxV+aaqMxneLqqLNVhmLdv
         S9YIppPJaLZgVbjF9ftz8qyIpHbfQa9hLzbUdQqCeyI0MqDnuiu7Y+wlD5HMAHUX4boJ
         x0pGOXbOYAjpZQCBQVk3gfw+BQlsrAJxlLo4Fxj1D4/OdVFTt6EtzfKPQ5ZV6Nk/1dEa
         HJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c3jFYKt2ZEW9qwQtIdp/SYKRbSkw9qr8gK/+SqARdPE=;
        b=Tk8fYgmIcf077vT26WCp9gnExzOZWkKgrc+i5l3su+5cbtRkuMKtA8G5+ByOC+q0ld
         BIuz+YxYSGjy5nGfk7QmD3WPYllHPg0ZKbpHvKq2JVDI14k63fVOoLkJUJPmaB/alJ2e
         R0be6z0npCQzbnL1vAqA3US43QYIGrKmFaGoF4HSG9RoMz7zNSNZIkVIK0Yyy53MEJhg
         HYTEWU0zVyW34EuF738jsPTZmn+n71G7NeELbvwkcAdufWVqxozFVRGDECwkPFw4tq1e
         5ajsyG0fL+6XmoMepl6QmnUCdTN5KjyDAZX4rL3C8SWGb+BkrfPYdZdwTDtvvFR6n9mv
         WPKg==
X-Gm-Message-State: AOAM531IAoohG/kMEl/HPSO5Mt+J8apFGAPu5A0724XoOZ4B+XjYtZ/A
        V7/UHYFo06DsNVQmFDL5mN8Kaa5KZOh7JsKWqQUZKg==
X-Google-Smtp-Source: ABdhPJy05pZE0kMhsSc2cOxO8mX8agpdU1xELOHA9nDyYaypS+Y7SA3UcXvcOhtNFwrDKHrnZ9GSbUrPGQSoIA3JqFI=
X-Received: by 2002:ac8:1493:: with SMTP id l19mr12462170qtj.43.1629107094067;
 Mon, 16 Aug 2021 02:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000007faf7505c91bb19d@google.com> <CAD-N9QULPO0jNkKr6VxtXb78TSzzFTJ9n+a36h1vruO9q6nhSw@mail.gmail.com>
In-Reply-To: <CAD-N9QULPO0jNkKr6VxtXb78TSzzFTJ9n+a36h1vruO9q6nhSw@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 16 Aug 2021 11:44:42 +0200
Message-ID: <CACT4Y+a-+AdKxsCnqPtE-0VRCO7CJjWmVQ0gmjZQ04YCcAHLsA@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in hwsim_new_edge_nl
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     syzbot <syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Aug 2021 at 10:22, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Mon, Aug 9, 2021 at 3:54 PM syzbot
> <syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1226099a300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048
> > dashboard link: https://syzkaller.appspot.com/bug?extid=fafb46da3f65fdbacd16
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+fafb46da3f65fdbacd16@syzkaller.appspotmail.com
> >
> > general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>
> Hi all,
>
> I think the crash can be fixed by [PATCH] ieee802154: hwsim: fix GPF
> in hwsim_new_edge_nl [1]. For now, it is in the wpan tree.
>
> [1] https://lkml.org/lkml/2021/7/8/66

Let's tell syzbot about the fix:

#syz fx: ieee802154: hwsim: fix GPF in hwsim_new_edge_nl

> > CPU: 1 PID: 1403 Comm: syz-executor.2 Not tainted 5.14.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
> > RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
> > RIP: 0010:hwsim_new_edge_nl+0xf4/0x8c0 drivers/net/ieee802154/mac802154_hwsim.c:425
> > Code: 00 0f 85 76 07 00 00 4d 85 ed 48 8b 5b 10 0f 84 5e 05 00 00 e8 0d f2 40 fc 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 87
> > RSP: 0018:ffffc90009a47568 EFLAGS: 00010246
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000dd59000
> > RDX: 0000000000000000 RSI: ffffffff8534ab43 RDI: ffff88801c2b44d0
> > RBP: ffffc90009a47678 R08: 0000000000000001 R09: ffffc90009a476a8
> > R10: fffff52001348ed6 R11: 0000000000000000 R12: ffffc90009a47698
> > R13: ffff888025945c14 R14: ffff888071f0cdc0 R15: 0000000000000000
> > FS:  00007f8448923700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000032f4708 CR3: 0000000033eed000 CR4: 00000000001506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
> >  genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
> >  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
> >  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
> >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> >  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
> >  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
> >  sock_sendmsg_nosec net/socket.c:704 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:724
> >  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2403
> >  ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
> >  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2486
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x4665e9
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f8448923188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> > RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665e9
> > RDX: 0000000000000000 RSI: 0000000020001ac0 RDI: 0000000000000004
> > RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
> > R13: 00007ffd8ac8e60f R14: 00007f8448923300 R15: 0000000000022000
> > Modules linked in:
> > ---[ end trace d1679fe789931133 ]---
> > RIP: 0010:nla_len include/net/netlink.h:1148 [inline]
> > RIP: 0010:nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
> > RIP: 0010:hwsim_new_edge_nl+0xf4/0x8c0 drivers/net/ieee802154/mac802154_hwsim.c:425
> > Code: 00 0f 85 76 07 00 00 4d 85 ed 48 8b 5b 10 0f 84 5e 05 00 00 e8 0d f2 40 fc 48 89 da 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48 89 d8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 87
> > RSP: 0018:ffffc90009a47568 EFLAGS: 00010246
> > RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000dd59000
> > RDX: 0000000000000000 RSI: ffffffff8534ab43 RDI: ffff88801c2b44d0
> > RBP: ffffc90009a47678 R08: 0000000000000001 R09: ffffc90009a476a8
> > R10: fffff52001348ed6 R11: 0000000000000000 R12: ffffc90009a47698
> > R13: ffff888025945c14 R14: ffff888071f0cdc0 R15: 0000000000000000
> > FS:  00007f8448923700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000055bb2ea2f160 CR3: 0000000033eed000 CR4: 00000000001506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000007faf7505c91bb19d%40google.com.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAD-N9QULPO0jNkKr6VxtXb78TSzzFTJ9n%2Ba36h1vruO9q6nhSw%40mail.gmail.com.
