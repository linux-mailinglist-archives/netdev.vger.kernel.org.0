Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208953B5852
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 06:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhF1Eam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 00:30:42 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:40800 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhF1Eal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 00:30:41 -0400
Received: by mail-il1-f197.google.com with SMTP id c15-20020a92b74f0000b02901ee2d62033eso9985020ilm.7
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 21:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=icxrGNLP9JeJyygKnYHu0Kd8QQahd5TDh1IJBmjQ4fU=;
        b=E0h3aqWe2c8TOyZ0pGxVCJi/cEMMKCr1HTdQn0mJKhrN7YNoOunK3QNgep9+cq/We2
         OEN0xRK+DWfCG5YLim9Bjsm7IQuO5vCHLUFpAHXkpyP26nn8xrHxLM8JdgQfoC0HGPtG
         fap2pKTZS6LbEMFJEoF+uVJgaIUg8XH5Uak09B1ZHj+oJw7Jz8IU1cRnk/bigaortA/X
         GLO+jQw+7MLhbPSe9gQMaDk7Pgl5nAi1lh/winu2dEDJq9IhaFzysV/7fxD0YilOHOwb
         Xv2n8+3a7Vm/No8fJnnLJfQv/Mo3bYk2BKj3vmqQwXNO03z59PzPWE2SBaOz7NVLNmDG
         8sZQ==
X-Gm-Message-State: AOAM530Dm42vv8c1yb6CJoYSlaLgHVyjpHCCvfzDT/A0M0w1Wag0NUwT
        i+UKyeTJkxQo1bVnWycfe+NI1F8sT8Xn3/lQf/zFsNZQHNkR
X-Google-Smtp-Source: ABdhPJz7x+mV90IRliuwgevDl/SQ8cw3MqpMFiOQ9959GwywBmL3g9wJR0IxB8UWyt3n+YMx9APc5G0ogAWyctYmtGl/Od5a/Frl
MIME-Version: 1.0
X-Received: by 2002:a5d:9c43:: with SMTP id 3mr3689294iof.123.1624854496443;
 Sun, 27 Jun 2021 21:28:16 -0700 (PDT)
Date:   Sun, 27 Jun 2021 21:28:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001285b905c5cbeb8f@google.com>
Subject: [syzbot] memory leak in j1939_sk_sendmsg
From:   syzbot <syzbot+085305c4b952053c9437@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7266f203 Merge tag 'pm-5.13-rc8' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16e22d34300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3aac8c6ef370586a
dashboard link: https://syzkaller.appspot.com/bug?extid=085305c4b952053c9437
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e0d6a4300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13528400300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+085305c4b952053c9437@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff888112d44400 (size 232):
  comm "syz-executor006", pid 8628, jiffies 4294942391 (age 8.470s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 80 d7 0f 81 88 ff ff 00 64 db 16 81 88 ff ff  .........d......
  backtrace:
    [<ffffffff836a0f8f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:413
    [<ffffffff836ac44a>] alloc_skb include/linux/skbuff.h:1107 [inline]
    [<ffffffff836ac44a>] alloc_skb_with_frags+0x6a/0x2c0 net/core/skbuff.c:5992
    [<ffffffff83699e63>] sock_alloc_send_pskb+0x353/0x3c0 net/core/sock.c:2364
    [<ffffffff83c54592>] j1939_sk_alloc_skb net/can/j1939/socket.c:858 [inline]
    [<ffffffff83c54592>] j1939_sk_send_loop net/can/j1939/socket.c:1040 [inline]
    [<ffffffff83c54592>] j1939_sk_sendmsg+0x2e2/0x7d0 net/can/j1939/socket.c:1175
    [<ffffffff83690ad6>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff83690ad6>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff83696e9f>] sock_no_sendpage+0x8f/0xc0 net/core/sock.c:2862
    [<ffffffff836903db>] kernel_sendpage.part.0+0xeb/0x150 net/socket.c:3618
    [<ffffffff836910bb>] kernel_sendpage net/socket.c:3615 [inline]
    [<ffffffff836910bb>] sock_sendpage+0x5b/0x90 net/socket.c:947
    [<ffffffff815b8862>] pipe_to_sendpage+0xa2/0x110 fs/splice.c:364
    [<ffffffff815ba702>] splice_from_pipe_feed fs/splice.c:418 [inline]
    [<ffffffff815ba702>] __splice_from_pipe+0x1e2/0x330 fs/splice.c:562
    [<ffffffff815baf2f>] splice_from_pipe fs/splice.c:597 [inline]
    [<ffffffff815baf2f>] generic_splice_sendpage+0x6f/0xa0 fs/splice.c:746
    [<ffffffff815b891b>] do_splice_from fs/splice.c:767 [inline]
    [<ffffffff815b891b>] direct_splice_actor+0x4b/0x70 fs/splice.c:936
    [<ffffffff815b9033>] splice_direct_to_actor+0x153/0x350 fs/splice.c:891
    [<ffffffff815b9318>] do_splice_direct+0xe8/0x150 fs/splice.c:979
    [<ffffffff8155a64f>] do_sendfile+0x51f/0x760 fs/read_write.c:1260
    [<ffffffff8155cf82>] __do_sys_sendfile64 fs/read_write.c:1325 [inline]
    [<ffffffff8155cf82>] __se_sys_sendfile64 fs/read_write.c:1311 [inline]
    [<ffffffff8155cf82>] __x64_sys_sendfile64+0xe2/0x100 fs/read_write.c:1311

BUG: memory leak
unreferenced object 0xffff888116d2d800 (size 1024):
  comm "syz-executor006", pid 8628, jiffies 4294942391 (age 8.470s)
  hex dump (first 32 bytes):
    0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff836a0e5f>] kmalloc_reserve net/core/skbuff.c:354 [inline]
    [<ffffffff836a0e5f>] __alloc_skb+0xdf/0x280 net/core/skbuff.c:425
    [<ffffffff836ac44a>] alloc_skb include/linux/skbuff.h:1107 [inline]
    [<ffffffff836ac44a>] alloc_skb_with_frags+0x6a/0x2c0 net/core/skbuff.c:5992
    [<ffffffff83699e63>] sock_alloc_send_pskb+0x353/0x3c0 net/core/sock.c:2364
    [<ffffffff83c54592>] j1939_sk_alloc_skb net/can/j1939/socket.c:858 [inline]
    [<ffffffff83c54592>] j1939_sk_send_loop net/can/j1939/socket.c:1040 [inline]
    [<ffffffff83c54592>] j1939_sk_sendmsg+0x2e2/0x7d0 net/can/j1939/socket.c:1175
    [<ffffffff83690ad6>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff83690ad6>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff83696e9f>] sock_no_sendpage+0x8f/0xc0 net/core/sock.c:2862
    [<ffffffff836903db>] kernel_sendpage.part.0+0xeb/0x150 net/socket.c:3618
    [<ffffffff836910bb>] kernel_sendpage net/socket.c:3615 [inline]
    [<ffffffff836910bb>] sock_sendpage+0x5b/0x90 net/socket.c:947
    [<ffffffff815b8862>] pipe_to_sendpage+0xa2/0x110 fs/splice.c:364
    [<ffffffff815ba702>] splice_from_pipe_feed fs/splice.c:418 [inline]
    [<ffffffff815ba702>] __splice_from_pipe+0x1e2/0x330 fs/splice.c:562
    [<ffffffff815baf2f>] splice_from_pipe fs/splice.c:597 [inline]
    [<ffffffff815baf2f>] generic_splice_sendpage+0x6f/0xa0 fs/splice.c:746
    [<ffffffff815b891b>] do_splice_from fs/splice.c:767 [inline]
    [<ffffffff815b891b>] direct_splice_actor+0x4b/0x70 fs/splice.c:936
    [<ffffffff815b9033>] splice_direct_to_actor+0x153/0x350 fs/splice.c:891
    [<ffffffff815b9318>] do_splice_direct+0xe8/0x150 fs/splice.c:979
    [<ffffffff8155a64f>] do_sendfile+0x51f/0x760 fs/read_write.c:1260
    [<ffffffff8155cf82>] __do_sys_sendfile64 fs/read_write.c:1325 [inline]
    [<ffffffff8155cf82>] __se_sys_sendfile64 fs/read_write.c:1311 [inline]
    [<ffffffff8155cf82>] __x64_sys_sendfile64+0xe2/0x100 fs/read_write.c:1311

BUG: memory leak
unreferenced object 0xffff888111010d00 (size 232):
  comm "syz-executor006", pid 8628, jiffies 4294942391 (age 8.470s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 80 d7 0f 81 88 ff ff 00 64 db 16 81 88 ff ff  .........d......
  backtrace:
    [<ffffffff836a0f8f>] __alloc_skb+0x20f/0x280 net/core/skbuff.c:413
    [<ffffffff836ac44a>] alloc_skb include/linux/skbuff.h:1107 [inline]
    [<ffffffff836ac44a>] alloc_skb_with_frags+0x6a/0x2c0 net/core/skbuff.c:5992
    [<ffffffff83699e63>] sock_alloc_send_pskb+0x353/0x3c0 net/core/sock.c:2364
    [<ffffffff83c54592>] j1939_sk_alloc_skb net/can/j1939/socket.c:858 [inline]
    [<ffffffff83c54592>] j1939_sk_send_loop net/can/j1939/socket.c:1040 [inline]
    [<ffffffff83c54592>] j1939_sk_sendmsg+0x2e2/0x7d0 net/can/j1939/socket.c:1175
    [<ffffffff83690ad6>] sock_sendmsg_nosec net/socket.c:654 [inline]
    [<ffffffff83690ad6>] sock_sendmsg+0x56/0x80 net/socket.c:674
    [<ffffffff83696e9f>] sock_no_sendpage+0x8f/0xc0 net/core/sock.c:2862
    [<ffffffff836903db>] kernel_sendpage.part.0+0xeb/0x150 net/socket.c:3618
    [<ffffffff836910bb>] kernel_sendpage net/socket.c:3615 [inline]
    [<ffffffff836910bb>] sock_sendpage+0x5b/0x90 net/socket.c:947
    [<ffffffff815b8862>] pipe_to_sendpage+0xa2/0x110 fs/splice.c:364
    [<ffffffff815ba702>] splice_from_pipe_feed fs/splice.c:418 [inline]
    [<ffffffff815ba702>] __splice_from_pipe+0x1e2/0x330 fs/splice.c:562
    [<ffffffff815baf2f>] splice_from_pipe fs/splice.c:597 [inline]
    [<ffffffff815baf2f>] generic_splice_sendpage+0x6f/0xa0 fs/splice.c:746
    [<ffffffff815b891b>] do_splice_from fs/splice.c:767 [inline]
    [<ffffffff815b891b>] direct_splice_actor+0x4b/0x70 fs/splice.c:936
    [<ffffffff815b9033>] splice_direct_to_actor+0x153/0x350 fs/splice.c:891
    [<ffffffff815b9318>] do_splice_direct+0xe8/0x150 fs/splice.c:979
    [<ffffffff8155a64f>] do_sendfile+0x51f/0x760 fs/read_write.c:1260
    [<ffffffff8155cf82>] __do_sys_sendfile64 fs/read_write.c:1325 [inline]
    [<ffffffff8155cf82>] __se_sys_sendfile64 fs/read_write.c:1311 [inline]
    [<ffffffff8155cf82>] __x64_sys_sendfile64+0xe2/0x100 fs/read_write.c:1311



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
