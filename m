Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0545777BE
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 20:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiGQSVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 14:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiGQSVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 14:21:37 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BEC13F11
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 11:21:36 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id a15-20020a921a0f000000b002dce91bcd3bso879800ila.20
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 11:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9lxHvDLp1NNRIHjnSmqb8mKhlE83vGlSB7ASV9SnxPQ=;
        b=apZMWqHIMOXCfCIs0sokFQn6rqj4DiWdy+ytPQqrbxkukVCoqWgDp5tMYwTSbU499V
         fM0Hc2XMJ0k+599ycFYyssmULcaDCTWzV68XU/0WHyxzaofQjCgwCubRP5nzi7bn79qJ
         Ti8EIZcWJHMX5Nn9q0cUfdCx0es6XRWd2rGymXyQqpmzsot2vO85xxGFU8v9mNiTXc6P
         FEu6mJL56VvxH4BDuUjlhzla2GwUPrZq3m9aj+lk6TVqMYsxtESPjGFSaOo+0MQet7H7
         DzJCpEyfPwWyiOqfg83cQkU0WYwbRqq5NdX5GGOK8BaZdmQx4FmeHdO3ENOKjcyk36Dt
         vsgg==
X-Gm-Message-State: AJIora9hr7WSGR+RgVtck4TBDNfCgR27eEWSr/2KvIC+obWTxV5Czwrx
        LyBA3QPJvREWLIv9zHDzKefOp3vEDJm1l9ukpNk2xnW6xQqE
X-Google-Smtp-Source: AGRyM1vdVhYapUGsZAz1GVQJQ8c+96LBjKEne+s2jtf8dpKMcy6OY5t4/UHfUpIImFfbQJwM1Eo6ePRGRJtYlRjh31O4dRBJbGVY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1885:b0:2dc:5ede:8537 with SMTP id
 o5-20020a056e02188500b002dc5ede8537mr11832936ilu.275.1658082096077; Sun, 17
 Jul 2022 11:21:36 -0700 (PDT)
Date:   Sun, 17 Jul 2022 11:21:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000058626005e40452e6@google.com>
Subject: [syzbot] memory leak in ipv6_renew_options
From:   syzbot <syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b047602d579b Merge tag 'trace-v5.19-rc5' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1129c37c080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=689b5fe7168a1260
dashboard link: https://syzkaller.appspot.com/bug?extid=a8430774139ec3ab7176
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1349421c080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120fcc1c080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com

executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810b810f00 (size 96):
  comm "syz-executor113", pid 3606, jiffies 4294944081 (age 12.460s)
  hex dump (first 32 bytes):
    01 00 00 00 48 00 00 00 00 00 08 00 00 00 00 00  ....H...........
    00 00 00 00 00 00 00 00 40 0f 81 0b 81 88 ff ff  ........@.......
  backtrace:
    [<ffffffff83855781>] kmalloc include/linux/slab.h:605 [inline]
    [<ffffffff83855781>] sock_kmalloc net/core/sock.c:2563 [inline]
    [<ffffffff83855781>] sock_kmalloc+0x61/0x90 net/core/sock.c:2554
    [<ffffffff83d3fa60>] ipv6_renew_options+0x120/0x440 net/ipv6/exthdrs.c:1318
    [<ffffffff83d138ad>] ipv6_set_opt_hdr net/ipv6/ipv6_sockglue.c:354 [inline]
    [<ffffffff83d138ad>] do_ipv6_setsockopt.constprop.0+0x49d/0x24d0 net/ipv6/ipv6_sockglue.c:668
    [<ffffffff83d1599e>] ipv6_setsockopt+0xbe/0x120 net/ipv6/ipv6_sockglue.c:1021
    [<ffffffff838517d0>] __sys_setsockopt+0x1b0/0x390 net/socket.c:2254
    [<ffffffff838519d2>] __do_sys_setsockopt net/socket.c:2265 [inline]
    [<ffffffff838519d2>] __se_sys_setsockopt net/socket.c:2262 [inline]
    [<ffffffff838519d2>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2262
    [<ffffffff845ad915>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845ad915>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
