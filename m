Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E5B69B276
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 19:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBQSmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 13:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQSmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 13:42:44 -0500
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89693C2F
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 10:42:43 -0800 (PST)
Received: by mail-io1-f78.google.com with SMTP id b4-20020a05660214c400b007297c4996c7so1082881iow.13
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 10:42:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZE+gpMYJhPMgEpdX9RH7zRNo5DDM3YYvYQepiSP81UA=;
        b=NiZjiGvPNP/OyO9ZAd6y5AFz7yGPU22VYWEkU117H8Ss3hlvLrqAC5YpgOaaHlG+Or
         w+ocJ82erLNfiVo1DDeGylsTnlizK8ANcbirx5c7BBR5fAVZypToBqUy7inbxdzRJYlA
         IYdt8Mx0wBKipmpBXQyy3K2SSKfbhknm27LE8A/A/wshMbOchtXQ9+7vKw9gQDE/uNQe
         vu+KYqYwLOB4uT6EYX63cLRmEaIRs6RLGrwd2IkIdaSuUMEX3MiSgP+as0bSvM5HVzDh
         to13ePMJDZ8ZPP8C/QsvoWJQjgmgL7LzLyt7CGEWLkyepDhOps1TSr0mzWDIBxG6fz6m
         RAuw==
X-Gm-Message-State: AO0yUKVoTqB4i0lHHGWqll8GoTVkIpFvezAzZtgUEiJhi1s2YiG46iTK
        eLDMrEr7KMJiBeNVa7bffGBJq43I2tIKaP3b54UG4nrN7XcU
X-Google-Smtp-Source: AK7set/9yU6iGE5VXd4Hoo3temo43RPlBdpCQ6fYX7aXpdIW/kOY7DnL4zBF+unurE/PhlvegqQJy5nvOixBjUFS0uti3zqOWSGd
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d1e:b0:314:b2cd:b265 with SMTP id
 i30-20020a056e021d1e00b00314b2cdb265mr3198323ila.1.1676659362885; Fri, 17 Feb
 2023 10:42:42 -0800 (PST)
Date:   Fri, 17 Feb 2023 10:42:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bbf72c05f4e9ad5d@google.com>
Subject: [syzbot] [nfc?] memory leak in nfc_genl_se_io
From:   syzbot <syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    ceaa837f96ad Linux 6.2-rc8
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12998820c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=74b547d21d6e842b
dashboard link: https://syzkaller.appspot.com/bug?extid=df64c0a2e8d68e78a4fa
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1273b13f480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1223934f480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/611c72309dbd/disk-ceaa837f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/182986ae7897/vmlinux-ceaa837f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c198e9ad17fc/bzImage-ceaa837f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com

executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810e03ca60 (size 32):
  comm "syz-executor354", pid 5068, jiffies 4294945666 (age 13.810s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff815090d4>] kmalloc_trace+0x24/0x90 mm/slab_common.c:1062
    [<ffffffff846a8104>] kmalloc include/linux/slab.h:580 [inline]
    [<ffffffff846a8104>] kzalloc include/linux/slab.h:720 [inline]
    [<ffffffff846a8104>] nfc_genl_se_io+0xf4/0x260 net/nfc/netlink.c:1531
    [<ffffffff83d2cede>] genl_family_rcv_msg_doit.isra.0+0xee/0x150 net/netlink/genetlink.c:968
    [<ffffffff83d2d217>] genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
    [<ffffffff83d2d217>] genl_rcv_msg+0x2d7/0x430 net/netlink/genetlink.c:1065
    [<ffffffff83d2b5a1>] netlink_rcv_skb+0x91/0x1e0 net/netlink/af_netlink.c:2574
    [<ffffffff83d2c5a8>] genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
    [<ffffffff83d2a4fb>] netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
    [<ffffffff83d2a4fb>] netlink_unicast+0x39b/0x4d0 net/netlink/af_netlink.c:1365
    [<ffffffff83d2a9ca>] netlink_sendmsg+0x39a/0x710 net/netlink/af_netlink.c:1942
    [<ffffffff83b74b3a>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83b74b3a>] sock_sendmsg+0x5a/0x80 net/socket.c:734
    [<ffffffff83b750bd>] ____sys_sendmsg+0x38d/0x410 net/socket.c:2476
    [<ffffffff83b79c68>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2530
    [<ffffffff83b79e0c>] __sys_sendmsg+0x8c/0x100 net/socket.c:2559
    [<ffffffff8498d8a9>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff8498d8a9>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
