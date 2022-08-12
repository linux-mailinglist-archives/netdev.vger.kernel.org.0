Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0B6591498
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 19:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239335AbiHLRE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 13:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238439AbiHLRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 13:04:27 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A988BB14D6
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 10:04:26 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id w6-20020a6bf006000000b006845b59a08bso899234ioc.9
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 10:04:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=OucfZo6bVXb/CmNvLXiX7ZiXfaSuQBZNkZAXzjRTZBU=;
        b=pqUmbdfh1Mt9KiuxIxwx73pl724adrP1JEWylhBfVrzndfQf0rOFt2XxcRZ3SAt2RM
         rNAqYmJcxjnQmNjoMAZcoIC4NDlQpUuc5P2p6vaAsTLXHh4N7QxTnTqgZKIxYhZAPILO
         lkzjkzN5IfgF1O3GBCV3iP1XW3HggWJNiRlmWREkYcH/LjZJhTi0yxHfGFP3la68Dvpq
         Y0BmlofOCBSVFm/ssb7SCd7QO4aANiJfD/ibrag1H7EYKvWHpY4dPmr4XXvSXDwX7rHp
         JQvixba5TZN13zqGUYrEqVo/e/vjtsIAUb/8Pt0t93fRRpxbhsE3B0bOltjFUhJOnG3h
         rXbg==
X-Gm-Message-State: ACgBeo2ls/rAqUp2INpQAhkjblTjEfuqXzjRkQ9+05/K3cIBBxW3dfYg
        irernX8E3wdQ+2esbwb10BFBvSIAL5JVijAAOyPBgz78Cuc8
X-Google-Smtp-Source: AA6agR5HWmeytSdzRgCgeULhsaPpv91UfKL6B8MwYexprhotbMy5bkGj4e3ws5EVzW2GuZhBp7h8YINzcUmzrNzO0KTy32T3c1+V
MIME-Version: 1.0
X-Received: by 2002:a05:6638:595:b0:343:3759:b245 with SMTP id
 a21-20020a056638059500b003433759b245mr2448450jar.180.1660323866068; Fri, 12
 Aug 2022 10:04:26 -0700 (PDT)
Date:   Fri, 12 Aug 2022 10:04:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fcafc05e60e466e@google.com>
Subject: [syzbot] memory leak in netlink_policy_dump_add_policy
From:   syzbot <syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    4e23eeebb2e5 Merge tag 'bitmap-6.0-rc1' of https://github...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=165f4f6a080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a433c7a2539f51c
dashboard link: https://syzkaller.appspot.com/bug?extid=dc54d9ba8153b216cae0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1443be71080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11e5918e080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dc54d9ba8153b216cae0@syzkaller.appspotmail.com

executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff888113093f00 (size 192):
  comm "syz-executor228", pid 3636, jiffies 4294947950 (age 12.750s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 0a 00 00 00 00 00 00 00  ................
    40 53 fd 84 ff ff ff ff 40 01 00 00 00 00 00 00  @S......@.......
  backtrace:
    [<ffffffff83a0e378>] kmalloc include/linux/slab.h:600 [inline]
    [<ffffffff83a0e378>] kzalloc include/linux/slab.h:733 [inline]
    [<ffffffff83a0e378>] alloc_state net/netlink/policy.c:104 [inline]
    [<ffffffff83a0e378>] netlink_policy_dump_add_policy+0x198/0x1f0 net/netlink/policy.c:135
    [<ffffffff83a0d78d>] ctrl_dumppolicy_start+0x15d/0x290 net/netlink/genetlink.c:1173
    [<ffffffff83a0abf8>] genl_start+0x148/0x210 net/netlink/genetlink.c:596
    [<ffffffff83a0756a>] __netlink_dump_start+0x20a/0x440 net/netlink/af_netlink.c:2370
    [<ffffffff83a0a38e>] genl_family_rcv_msg_dumpit+0x15e/0x190 net/netlink/genetlink.c:678
    [<ffffffff83a0b1d5>] genl_family_rcv_msg net/netlink/genetlink.c:772 [inline]
    [<ffffffff83a0b1d5>] genl_rcv_msg+0x225/0x2c0 net/netlink/genetlink.c:792
    [<ffffffff83a09807>] netlink_rcv_skb+0x87/0x1d0 net/netlink/af_netlink.c:2501
    [<ffffffff83a0a214>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
    [<ffffffff83a08977>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83a08977>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83a08e36>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff8385aea6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff8385aea6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff8385b40c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2482
    [<ffffffff8385fd08>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff8385fe98>] __sys_sendmsg+0x88/0x100 net/socket.c:2565
    [<ffffffff845d8535>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845d8535>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
