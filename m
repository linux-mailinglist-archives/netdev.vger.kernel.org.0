Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E1C1F4925
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgFIV6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:58:15 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:56584 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgFIV6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:58:13 -0400
Received: by mail-il1-f199.google.com with SMTP id k13so72152ilh.23
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 14:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1mhEZ1q7Z91Rb4K4pPl+Kl2FQ4G6nw8z/eiDSC/Zszk=;
        b=i5a0yJOTDDYz5OK1C5mT2G8KCjPwQkTP0see54miuwPUunemXqRyGC/0Lb30cJwVEC
         Hutu6k5uEvBV1A5+pPBLESSc5C4E4ajv6Dr4wsDt+D5cw1OQanuodgK+w7LBSzGQjrNQ
         4g5pz3UuYZKTMOMoGwP1rPFdd0Rgnb4bKXMRgbs8+0IK51HQWwUeC5jzHS9XyJC71Au+
         B9rmsCzJMKqHh0OtvlxUcwMRjXZPZvte8rOzl/o60rUIsXOKUsX8Vvb6FGI5FHNCgAsI
         9B0YDRvspDFuFmvCT8Iy8EIe/+jgJk2nBGrZg3InqZOb30ZFbJ5B2LyfN9Rg6obnbO4e
         Ri3g==
X-Gm-Message-State: AOAM530MSwOZJp1ZorzmDKYuQjXXmWJWV4IiPtB8VWGVI84zfyoTdJhB
        76tAq41wrxQ1SVEAUnJJFnuwBy6YEPTTpwzFIlAR/MyajcWK
X-Google-Smtp-Source: ABdhPJyVTV6l9HIonmvEbRWycVRVy99+9JoQavvsD0FwXdaQ5WzXVA2DaS4Y+g5qg1twFWhInnmvbiSkvNCuY/nPFYIb2hmmR2Ft
MIME-Version: 1.0
X-Received: by 2002:a02:2c6:: with SMTP id 189mr245195jau.115.1591739892143;
 Tue, 09 Jun 2020 14:58:12 -0700 (PDT)
Date:   Tue, 09 Jun 2020 14:58:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d8a0ea05a7add2fd@google.com>
Subject: memory leak in ctnetlink_del_conntrack
From:   syzbot <syzbot+38b8b548a851a01793c5@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10fcd90e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a1aa05456dfd557
dashboard link: https://syzkaller.appspot.com/bug?extid=38b8b548a851a01793c5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129c54c1100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c0355a100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+38b8b548a851a01793c5@syzkaller.appspotmail.com

executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811c505300 (size 128):
  comm "syz-executor470", pid 6431, jiffies 4294945909 (age 13.210s)
  hex dump (first 32 bytes):
    00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000da2809df>] kmalloc include/linux/slab.h:555 [inline]
    [<00000000da2809df>] kzalloc include/linux/slab.h:669 [inline]
    [<00000000da2809df>] ctnetlink_alloc_filter+0x3a/0x2a0 net/netfilter/nf_conntrack_netlink.c:924
    [<00000000745f0fc9>] ctnetlink_flush_conntrack net/netfilter/nf_conntrack_netlink.c:1516 [inline]
    [<00000000745f0fc9>] ctnetlink_del_conntrack+0x20a/0x326 net/netfilter/nf_conntrack_netlink.c:1554
    [<00000000385a38da>] nfnetlink_rcv_msg+0x32f/0x370 net/netfilter/nfnetlink.c:229
    [<00000000bb3b1fc1>] netlink_rcv_skb+0x5a/0x180 net/netlink/af_netlink.c:2469
    [<00000000b2799dbb>] nfnetlink_rcv+0x83/0x1b0 net/netfilter/nfnetlink.c:563
    [<000000006021f56a>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<000000006021f56a>] netlink_unicast+0x20a/0x2f0 net/netlink/af_netlink.c:1329
    [<000000003a4cd173>] netlink_sendmsg+0x2b5/0x560 net/netlink/af_netlink.c:1918
    [<00000000ff287393>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000ff287393>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<000000008c32b330>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<00000000a8f57b1b>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2406
    [<000000002c938bcf>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<00000000878f0bd0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000dcd0e014>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ac32a00 (size 128):
  comm "syz-executor470", pid 6432, jiffies 4294946459 (age 7.710s)
  hex dump (first 32 bytes):
    00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000da2809df>] kmalloc include/linux/slab.h:555 [inline]
    [<00000000da2809df>] kzalloc include/linux/slab.h:669 [inline]
    [<00000000da2809df>] ctnetlink_alloc_filter+0x3a/0x2a0 net/netfilter/nf_conntrack_netlink.c:924
    [<00000000745f0fc9>] ctnetlink_flush_conntrack net/netfilter/nf_conntrack_netlink.c:1516 [inline]
    [<00000000745f0fc9>] ctnetlink_del_conntrack+0x20a/0x326 net/netfilter/nf_conntrack_netlink.c:1554
    [<00000000385a38da>] nfnetlink_rcv_msg+0x32f/0x370 net/netfilter/nfnetlink.c:229
    [<00000000bb3b1fc1>] netlink_rcv_skb+0x5a/0x180 net/netlink/af_netlink.c:2469
    [<00000000b2799dbb>] nfnetlink_rcv+0x83/0x1b0 net/netfilter/nfnetlink.c:563
    [<000000006021f56a>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<000000006021f56a>] netlink_unicast+0x20a/0x2f0 net/netlink/af_netlink.c:1329
    [<000000003a4cd173>] netlink_sendmsg+0x2b5/0x560 net/netlink/af_netlink.c:1918
    [<00000000ff287393>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000ff287393>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<000000008c32b330>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<00000000a8f57b1b>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2406
    [<000000002c938bcf>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<00000000878f0bd0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000dcd0e014>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
