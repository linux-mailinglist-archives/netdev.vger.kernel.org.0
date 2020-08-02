Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC129235810
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgHBPTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:19:22 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:34899 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgHBPTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:19:22 -0400
Received: by mail-il1-f197.google.com with SMTP id g6so10678705iln.2
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 08:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Doj0mz+51ihkaX67p3nnSBbI9p/ZjghvSf52SnU2SAw=;
        b=WEWrbHJB/VDcHQGVNn858RjVv/Dxa09sOhXq9QORPerS1LXgxeQsF8VDHbrp5w7bU9
         v5dq3WuiLQ/ptxuaV9PX61F+im8mEHM3Qr51VS11BE1BsHU+2MgbXgwwDWGNmwGZy23P
         1NYoJjWTTlz1kqvaTFImSveYX8SQfK3aHuOdjqf6rTxkcJJQC1vWZ8NFxOmPOiL7IL1J
         fG0pU9jRrnV8wXB/KgTpIz8tXO8ehJR4cUSSeGxgMD8qgLzYFQEUmPbqU5ovrJnO2D07
         SH0T7C4Dn4zX6z9niGWVuR0hSc/6S/0+nTIkxmukvh+FYTQIrqtSrahxOB9N/cYefQUe
         D8Kg==
X-Gm-Message-State: AOAM530lRfVGb8rTWiaY9/igYJE5T4DgGF72HIbaBM0+Uu2wU2PuvIMy
        +nwVlY3EU3WttaRP/NDKdaeFRGVB1NcMeI4KKLxqufvDYQdZ
X-Google-Smtp-Source: ABdhPJznBtamlaxrIT+5F9Ju/bbX/8NmLCAc5FuDcy6t6eLf9GG3KEPK5cUAQ0OtLi4HrVRM+qtYG8q40P2r1AEHpBMRIj+8EAe+
MIME-Version: 1.0
X-Received: by 2002:a02:3502:: with SMTP id k2mr5860691jaa.129.1596381561363;
 Sun, 02 Aug 2020 08:19:21 -0700 (PDT)
Date:   Sun, 02 Aug 2020 08:19:21 -0700
In-Reply-To: <0000000000000a730805aab5e470@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e4239105abe68bf1@google.com>
Subject: Re: memory leak in veth_dev_init
From:   syzbot <syzbot+59ef240dd8f0ed7598a8@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=156db214900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1b8ff4a33e73cad
dashboard link: https://syzkaller.appspot.com/bug?extid=59ef240dd8f0ed7598a8
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=100102a4900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=172fcacc900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+59ef240dd8f0ed7598a8@syzkaller.appspotmail.com

executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888128d25800 (size 1024):
  comm "syz-executor493", pid 6464, jiffies 4294944570 (age 14.450s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000ee9fd51f>] kmalloc_array include/linux/slab.h:597 [inline]
    [<00000000ee9fd51f>] kcalloc include/linux/slab.h:608 [inline]
    [<00000000ee9fd51f>] veth_alloc_queues drivers/net/veth.c:1018 [inline]
    [<00000000ee9fd51f>] veth_dev_init+0x7b/0x120 drivers/net/veth.c:1045
    [<00000000ea2b9ca8>] register_netdevice+0x143/0x760 net/core/dev.c:9444
    [<0000000054f736e0>] veth_newlink+0x282/0x460 drivers/net/veth.c:1393
    [<0000000048b625cf>] __rtnl_newlink+0x8f0/0xbc0 net/core/rtnetlink.c:3339
    [<00000000c7111fa7>] rtnl_newlink+0x49/0x70 net/core/rtnetlink.c:3398
    [<000000003c581d51>] rtnetlink_rcv_msg+0x17e/0x460 net/core/rtnetlink.c:5461
    [<0000000044c6a9c9>] netlink_rcv_skb+0x5b/0x180 net/netlink/af_netlink.c:2469
    [<00000000c5e8a749>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<00000000c5e8a749>] netlink_unicast+0x2b6/0x3c0 net/netlink/af_netlink.c:1329
    [<000000000417c80d>] netlink_sendmsg+0x2ba/0x570 net/netlink/af_netlink.c:1918
    [<000000000bc3c36b>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<000000000bc3c36b>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<0000000041ecdda4>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<0000000013875e8e>] ___sys_sendmsg+0x81/0xc0 net/socket.c:2406
    [<00000000ab05eaa1>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<00000000475b439b>] do_syscall_64+0x4c/0xe0 arch/x86/entry/common.c:384
    [<00000000dbda4b6d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888119669c00 (size 1024):
  comm "syz-executor493", pid 6496, jiffies 4294945171 (age 8.440s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000ee9fd51f>] kmalloc_array include/linux/slab.h:597 [inline]
    [<00000000ee9fd51f>] kcalloc include/linux/slab.h:608 [inline]
    [<00000000ee9fd51f>] veth_alloc_queues drivers/net/veth.c:1018 [inline]
    [<00000000ee9fd51f>] veth_dev_init+0x7b/0x120 drivers/net/veth.c:1045
    [<00000000ea2b9ca8>] register_netdevice+0x143/0x760 net/core/dev.c:9444
    [<0000000054f736e0>] veth_newlink+0x282/0x460 drivers/net/veth.c:1393
    [<0000000048b625cf>] __rtnl_newlink+0x8f0/0xbc0 net/core/rtnetlink.c:3339
    [<00000000c7111fa7>] rtnl_newlink+0x49/0x70 net/core/rtnetlink.c:3398
    [<000000003c581d51>] rtnetlink_rcv_msg+0x17e/0x460 net/core/rtnetlink.c:5461
    [<0000000044c6a9c9>] netlink_rcv_skb+0x5b/0x180 net/netlink/af_netlink.c:2469
    [<00000000c5e8a749>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<00000000c5e8a749>] netlink_unicast+0x2b6/0x3c0 net/netlink/af_netlink.c:1329
    [<000000000417c80d>] netlink_sendmsg+0x2ba/0x570 net/netlink/af_netlink.c:1918
    [<000000000bc3c36b>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<000000000bc3c36b>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<0000000041ecdda4>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<0000000013875e8e>] ___sys_sendmsg+0x81/0xc0 net/socket.c:2406
    [<00000000ab05eaa1>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<00000000475b439b>] do_syscall_64+0x4c/0xe0 arch/x86/entry/common.c:384
    [<00000000dbda4b6d>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


