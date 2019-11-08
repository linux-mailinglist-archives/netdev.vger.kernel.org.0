Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB44AF3E97
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 04:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbfKHDyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 22:54:09 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:52986 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfKHDyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 22:54:09 -0500
Received: by mail-io1-f71.google.com with SMTP id o5so3876534iob.19
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 19:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=W83r1/lZ6zESLRM4Fopc0wEMOk3/4fzAB2DwiCCyggc=;
        b=WlU+OSOQg5iDCQL86cUXAC58ZuM2RJ4sQcmGJb3oS4Y1thPUdaD3LxvvR6RwQoEle0
         BnaVMnYAQobc91nalJh4gOmDnWuyZqas8iFWVleuVCtLKb4v5jMus/ZBROyBSn+2DEOD
         ez4uXa1tBoB0WEq1tFoQaKezZuoBgC0d9zgp1c6v/wBsFX5K2F/zQpg4xxS4F/B6P3ik
         pA7EigbvrKrgGCOxpw+h0E0nNvoUwGAMANpk7odZg7M6QxilJPTbECvBc6gwG2c2Z+zF
         vjPaqPy0SgESIHjc/2pix/cNfN+zRrl2n64s/fFPJr1308MaAS+KZ6aVuz74YTnhBxWs
         cVKA==
X-Gm-Message-State: APjAAAW45YPRoiw7x3KIMDxulU5RZFmqzu413qxbSCcJ/6Kij7/CaZ9X
        N3Pp8SGmwz7YebHYCTPV035X6ai0LAVTEVxtPad70Fi2OKI0
X-Google-Smtp-Source: APXvYqxTWgZVvHNue8/pTOr8dUdvs47O4ecJE22Cfy+F/KCKlFB7lkiFhD9g2lAAZfYTRWVa/tQX4NTO34z2yWCvodIxKyXlUpaz
MIME-Version: 1.0
X-Received: by 2002:a02:7829:: with SMTP id p41mr8608601jac.73.1573185248455;
 Thu, 07 Nov 2019 19:54:08 -0800 (PST)
Date:   Thu, 07 Nov 2019 19:54:08 -0800
In-Reply-To: <000000000000ec7273058b877e1f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e676b00596cdbbde@google.com>
Subject: Re: BUG: MAX_LOCKDEP_ENTRIES too low!
From:   syzbot <syzbot+cd0ec5211ac07c18c049@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dev@openvswitch.org, jack@suse.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    99a8efbb NFC: st21nfca: fix double free
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15ed70d8e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbbed3e8d4eb64bf
dashboard link: https://syzkaller.appspot.com/bug?extid=cd0ec5211ac07c18c049
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13cf5594e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1036c762e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cd0ec5211ac07c18c049@syzkaller.appspotmail.com

device 5580n entered promiscuous mode
BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
CPU: 0 PID: 14197 Comm: syz-executor527 Not tainted 5.4.0-rc5+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  alloc_list_entry.cold+0x11/0x18 kernel/locking/lockdep.c:1292
  add_lock_to_list kernel/locking/lockdep.c:1313 [inline]
  check_prev_add kernel/locking/lockdep.c:2528 [inline]
  check_prevs_add kernel/locking/lockdep.c:2581 [inline]
  validate_chain kernel/locking/lockdep.c:2971 [inline]
  __lock_acquire+0x2a15/0x4a00 kernel/locking/lockdep.c:3955
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  netif_addr_lock_bh include/linux/netdevice.h:4055 [inline]
  dev_set_rx_mode+0x20/0x40 net/core/dev.c:7808
  dev_set_promiscuity+0xbf/0xe0 net/core/dev.c:7716
  internal_dev_create+0x387/0x550 net/openvswitch/vport-internal_dev.c:196
  ovs_vport_add+0x150/0x500 net/openvswitch/vport.c:199
  new_vport+0x1b/0x1d0 net/openvswitch/datapath.c:194
  ovs_dp_cmd_new+0x5e5/0xe30 net/openvswitch/datapath.c:1644
  genl_family_rcv_msg+0x74b/0xf90 net/netlink/genetlink.c:629
  genl_rcv_msg+0xca/0x170 net/netlink/genetlink.c:654
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  genl_rcv+0x29/0x40 net/netlink/genetlink.c:665
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  ___sys_sendmsg+0x803/0x920 net/socket.c:2311
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2356
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2363
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441779
Code: e8 9c ad 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 1b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffea7e5fcc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441779
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000058f66 R08: 00007ffe00000025 R09: 00007ffe00000025
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000006cdbc0
R13: 0000000000000013 R14: 0000000000000000 R15: 0000000000000000

