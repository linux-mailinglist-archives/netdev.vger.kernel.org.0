Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E102DF628
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 17:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgLTQyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 11:54:54 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:34609 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbgLTQyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 11:54:53 -0500
Received: by mail-il1-f198.google.com with SMTP id c72so7343674ila.1
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 08:54:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4i7D1Vic0NGgVWV12qBnsGylwzdrUaeZ6Lvdbd3ZN5E=;
        b=HqLGzdZGEDjepC41Hn3zcz+3z8B7FlKXAJdv2hsweq3KfK6XBDy4e6ZFlg6pe59I3Y
         7VptyX9Ngo0Lmj71QvrR4kdYb+Q/zY+I+PyZ5svUSfCIjcp2SpApahRQAXgmkkt14e0U
         /P0Ig3E3ny5gyrUevwJ8zGUt6JOZnS8uRSGNS6gXn2cKjVBLAwI5Tr0FYM3GpFwygKC+
         oKDNHjg83Az1q+0FOU8v5aPjU+bn+8CNamoE8P+9qfDkoyraczYi6kAg22+1npEmUQQi
         HvB0YzG64njlPskX1seFcXdgGJszUhGNO+Upb6PmpnZi+u6CMWFFM9gZIczBW1n4NSHX
         g6Og==
X-Gm-Message-State: AOAM533Hw7vxlphAqVtF3yssSx+M4YlKKZQ4WBTbuKu35JnMG5nbCHyR
        hmRm8Il2FC1F9Q/t1dGqiydh0/tz9PBwhp5s9hwGA73URvwW
X-Google-Smtp-Source: ABdhPJygH3tPibPhqTDcxUwciWibFpW9j6ta4+9W/Tw/0iQDmjtRdhSdNdaFpA2ewuddccUk4x2AqG7t/KJwxF4+9E4rgeJAg6Ng
MIME-Version: 1.0
X-Received: by 2002:a05:6602:214b:: with SMTP id y11mr11637499ioy.78.1608483252286;
 Sun, 20 Dec 2020 08:54:12 -0800 (PST)
Date:   Sun, 20 Dec 2020 08:54:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e13e2905b6e830bb@google.com>
Subject: UBSAN: object-size-mismatch in wg_xmit
From:   syzbot <syzbot+8f90d005ab2d22342b6d@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5e60366d Merge tag 'fallthrough-fixes-clang-5.11-rc1' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b12c13500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=267a60b188ded8ed
dashboard link: https://syzkaller.appspot.com/bug?extid=8f90d005ab2d22342b6d
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f90d005ab2d22342b6d@syzkaller.appspotmail.com

================================================================================
UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2021:28
member access within address 0000000085889cc2 with insufficient space
for an object of type 'struct sk_buff'
CPU: 1 PID: 2998 Comm: kworker/1:2 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:148 [inline]
 handle_object_size_mismatch lib/ubsan.c:297 [inline]
 ubsan_type_mismatch_common+0x1e2/0x390 lib/ubsan.c:310
 __ubsan_handle_type_mismatch_v1+0x41/0x50 lib/ubsan.c:339
 __skb_queue_before include/linux/skbuff.h:2021 [inline]
 __skb_queue_tail include/linux/skbuff.h:2054 [inline]
 wg_xmit+0x45d/0xdf0 drivers/net/wireguard/device.c:182
 __netdev_start_xmit include/linux/netdevice.h:4775 [inline]
 netdev_start_xmit+0x7b/0x140 include/linux/netdevice.h:4789
 xmit_one net/core/dev.c:3556 [inline]
 dev_hard_start_xmit+0x182/0x2e0 net/core/dev.c:3572
 __dev_queue_xmit+0x1229/0x1e60 net/core/dev.c:4133
 neigh_output include/net/neighbour.h:510 [inline]
 ip6_finish_output2+0xe8d/0x11e0 net/ipv6/ip6_output.c:117
 dst_output include/net/dst.h:441 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ndisc_send_skb+0x85b/0xc70 net/ipv6/ndisc.c:508
 addrconf_dad_completed+0x5ef/0x990 net/ipv6/addrconf.c:4192
 addrconf_dad_work+0xb92/0x1480 net/ipv6/addrconf.c:3959
 process_one_work+0x471/0x830 kernel/workqueue.c:2275
 worker_thread+0x757/0xb10 kernel/workqueue.c:2421
 kthread+0x39a/0x3c0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
