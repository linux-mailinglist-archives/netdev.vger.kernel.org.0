Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD7431F054
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhBRTqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:46:24 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:56683 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhBRTZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 14:25:05 -0500
Received: by mail-io1-f70.google.com with SMTP id e12so2041823ioc.23
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 11:24:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MNizgv5mvQWhBT/s84w4wVfXhQTCYQ+gD1CNu9mQuu4=;
        b=Xbdegd+qe2bWEvCsZZmrz4aM4qeQMDBJPUggoNDcL8MsR4NM7EYKEUjgpluAzoR1YS
         aPP53QMucif8eVj1KrwOoW8jzl9raZ+xVRoKlaelYzIv8x4LPbqXYxSKmDER4a6L5iJm
         LusCN/ZqBxd5DJU1nwJ7vaWq/oEE4NRn3DrfUNnAXpdZYNBi22K3sO8IcZ78f/6b6+02
         BKy1Psa0S6hGy9yghHPPE2ubfVBNuHrFar8AJutHe/LWVgqryr8DaLzN6QOxNoPpa/zL
         mcslT2dqPZSEjQdky6Mc8hEgZRs5JKuXhx+hlvI4c1JwKb7tHJRno3oFlnDZ0pynZ6jj
         FL2A==
X-Gm-Message-State: AOAM531bwRmVH6NY12qcfapZPyzbFw+cy2++wLFUfNGrHiA0zc1q/7a0
        5IGq3T/ZUk2uOEI8+WPKnBYOKfzuH7EYjIbwwRpI9L7Nn/7n
X-Google-Smtp-Source: ABdhPJygfiVFf+6UJu1Xxuh6NPoc/nkSTCw7BvJc4CESWo6dfUttZyO9/aMhy4J5sNa+vDjZcwA9lbgm6JUU41SE0YRkBJjt5cKM
MIME-Version: 1.0
X-Received: by 2002:a92:cc41:: with SMTP id t1mr594092ilq.27.1613676262080;
 Thu, 18 Feb 2021 11:24:22 -0800 (PST)
Date:   Thu, 18 Feb 2021 11:24:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006246f105bba148f9@google.com>
Subject: BUG: unable to handle kernel paging request in nl802154_del_llsec_key
From:   syzbot <syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f40ddce8 Linux 5.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11261a4cd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=67894355b1dbeb07
dashboard link: https://syzkaller.appspot.com/bug?extid=ac5c11d2959a8b3c4806
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com

netlink: 164 bytes leftover after parsing attributes in process `syz-executor.1'.
Unable to handle kernel paging request at virtual address dfff800000000000
Mem abort info:
  ESR = 0x96000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
[dfff800000000000] address between user and kernel address ranges
Internal error: Oops: 96000004 [#1] PREEMPT SMP
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in:
CPU: 1 PID: 5366 Comm: syz-executor.1 Not tainted 5.11.0-syzkaller #0
Hardware name: linux,dummy-virt (DT)
pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
pc : nla_len include/net/netlink.h:1148 [inline]
pc : nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
pc : nl802154_del_llsec_key+0x138/0x2c0 net/ieee802154/nl802154.c:1595
lr : genl_family_rcv_msg_doit+0x1b8/0x2a0 net/netlink/genetlink.c:739
sp : ffff000019c57280
x29: ffff000019c57280 x28: ffff80001aa29cc0 
x27: ffff000019c576d0 x26: ffff000012280000 
x25: 1fffe0000338aeb2 x24: 1fffe0000338ae84 
x23: ffff800018380c80 x22: ffff000016174c10 
x21: ffff00000fca8000 x20: 0000000000000000 
x19: 1fffe0000338ae5a x18: 0000000000000001 
x17: 0000000000000000 x16: 0000000000000000 
x15: 0000000000000000 x14: 1fffe0000338adf4 
x13: 0000000000000000 x12: ffff60000338ae55 
x11: 1fffe0000338ae54 x10: ffff60000338ae54 
x9 : 000000000000f1f1 x8 : 000000000000f2f2 
x7 : 00000000f3000000 x6 : 1fffe0000338ae90 
x5 : 00000000f3f3f3f3 x4 : 0000000000000000 
x3 : dfff800000000000 x2 : 0000000000000004 
x1 : ffff000019c57450 x0 : 0000000000000001 
Call trace:
 nla_data include/net/netlink.h:1139 [inline]
 nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]
 nl802154_del_llsec_key+0x138/0x2c0 net/ieee802154/nl802154.c:1595
 genl_family_rcv_msg_doit+0x1b8/0x2a0 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x24c/0x430 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x198/0x34c net/netlink/af_netlink.c:2494
 genl_rcv+0x38/0x50 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x3e0/0x670 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x610/0xa20 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xc0/0xf4 net/socket.c:672
 ____sys_sendmsg+0x548/0x6d0 net/socket.c:2345
 ___sys_sendmsg+0xf4/0x170 net/socket.c:2399
 __sys_sendmsg+0xbc/0x14c net/socket.c:2432
 __do_sys_sendmsg net/socket.c:2441 [inline]
 __se_sys_sendmsg net/socket.c:2439 [inline]
 __arm64_sys_sendmsg+0x70/0xa0 net/socket.c:2439
 __invoke_syscall arch/arm64/kernel/syscall.c:37 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:49 [inline]
 el0_svc_common.constprop.0+0x110/0x3c0 arch/arm64/kernel/syscall.c:159
 do_el0_svc+0xa4/0xd0 arch/arm64/kernel/syscall.c:198
 el0_svc+0x20/0x30 arch/arm64/kernel/entry-common.c:365
 el0_sync_handler+0x1a4/0x1ac arch/arm64/kernel/entry-common.c:381
 el0_sync+0x174/0x180 arch/arm64/kernel/entry.S:699
Code: f2fbffe3 92400a80 11000400 91001282 (38e36883) 
---[ end trace dde92eef2b40d315 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
