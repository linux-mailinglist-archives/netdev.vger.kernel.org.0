Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC3E21D050
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 09:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGMHTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 03:19:24 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:44532 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgGMHTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 03:19:23 -0400
Received: by mail-io1-f72.google.com with SMTP id h15so7514024ioj.11
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 00:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=DuS2m7AaNNqeN+BW2KHPwRy6Q7htpIhCPiO8CjPBJI4=;
        b=Va1ViqCXEeLiw56dwdb3AYWaq+E6JdgEy3HOnLSs6rAew4QTbaO8N8huHdT7OQJUIK
         HxOsjS/IHsMDRSSMnpE6pdFLodTkLXPLL/ZYzJ1qTEoWdvWecYxUaroM/eJWcgmaFLd0
         nZeX8v/jrImUCKFBt86kJG8oJgFuLHGv0hQptZzqY5Go6I0ZGVOW6aC8kvZ2zImu2Rzf
         omhmE30zeYcQisjoe3nxGJ/JLELOffpDiHdaOLs7bvwtZggrPL3oBAA+baYQ2ySkfFog
         qKnlfHcgDANdpYx+evjVCDuMOovSk3zW+SLLZdLIhEWy653ue52Rdch08mANKnkxrQ4L
         OX1A==
X-Gm-Message-State: AOAM530Juzp5SwTu2ZfHm77pJ6xcWTTQwiAE5fyW+Qemtik6xKprysSm
        IXxmTFCXQgLLyf/ixkDS/TA9Jbae+hgoUTv2ou8wWrqgMamm
X-Google-Smtp-Source: ABdhPJy1Clq0TTXREAVhPodq6tA7Lm+VrI5p0EFOIAJ4aL6belWUAkEtfRVWBLNeXNY791qLas1idj86XtfvSMn69MViZ7c004hf
MIME-Version: 1.0
X-Received: by 2002:a92:b684:: with SMTP id m4mr62449401ill.153.1594624762684;
 Mon, 13 Jul 2020 00:19:22 -0700 (PDT)
Date:   Mon, 13 Jul 2020 00:19:22 -0700
In-Reply-To: <000000000000cbef4a05a8ffc4ef@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000087abf205aa4d82f0@google.com>
Subject: Re: BUG: using smp_processor_id() in preemptible code in tipc_crypto_xmit
From:   syzbot <syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jmaloy@redhat.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    4437dd6e Merge tag 'io_uring-5.8-2020-07-12' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13a4773f100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66ad203c2bb6d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=263f8c0d007dc09b2dda
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132d41c0900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147f114f100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com

tipc: Started in network mode
tipc: Own node identity aaaaaaaaaa3a, cluster identity 4711
tipc: Enabled bearer <eth:macsec0>, priority 0
tipc: TX(aaaaaaaaaa3a): key initiating, rc 1!
BUG: using smp_processor_id() in preemptible [00000000] code: syz-executor201/6801
caller is tipc_aead_tfm_next net/tipc/crypto.c:402 [inline]
caller is tipc_aead_encrypt net/tipc/crypto.c:639 [inline]
caller is tipc_crypto_xmit+0x80a/0x2790 net/tipc/crypto.c:1605
CPU: 0 PID: 6801 Comm: syz-executor201 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 check_preemption_disabled+0x128/0x130 lib/smp_processor_id.c:48
 tipc_aead_tfm_next net/tipc/crypto.c:402 [inline]
 tipc_aead_encrypt net/tipc/crypto.c:639 [inline]
 tipc_crypto_xmit+0x80a/0x2790 net/tipc/crypto.c:1605
 tipc_bearer_xmit_skb+0x180/0x3f0 net/tipc/bearer.c:523
 tipc_enable_bearer+0xb1d/0xdc0 net/tipc/bearer.c:331
 __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
 __tipc_nl_compat_doit net/tipc/netlink_compat.c:361 [inline]
 tipc_nl_compat_doit+0x440/0x640 net/tipc/netlink_compat.c:383
 tipc_nl_compat_handle net/tipc/netlink_compat.c:1268 [inline]
 tipc_nl_compat_recv+0x4ef/0xb40 net/tipc/netlink_compat.c:1311
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4476a9
Code: Bad RIP value.
RSP: 002b:00007fff2b6d5168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000000

