Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717D1E605C
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 04:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfJ0DbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 23:31:12 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47069 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfJ0DbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 23:31:12 -0400
Received: by mail-io1-f71.google.com with SMTP id y25so5463009ioc.13
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 20:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hu4TfQmN8Tb4gozti5q3Q0gEU0IJWkqG41T9vim5giU=;
        b=mEsH5jSkWFnKBBj663oetuazdypSTRYyugoHSbS11VJ2tQblGd4ZTUk5YaUG568RN3
         TeTtYIeIpSiRAalvMFv2HRjKfBBEVSyFmrLWC/LgT4fPafjw4dwcwrn4B/ZLEVwx2Np/
         6yf6I8T44XLThPDZY6j8xSQ9aKlm9djDILJgRCoqJeG2L7SjtHvo3HzxZtclO9x40vrJ
         5kY9fuBnPH0rXyUQPepZnoJXqU4KEo0PrgTmjLZdJbDh0cNqLUMlLIYAJTCETNPeZRq3
         ut/bTVs5tDWDzcWmi6dAlCv/JDJuCPIBIh15iah446oLgl0+/giMGFqPURDCTF0lZkS2
         2ZQQ==
X-Gm-Message-State: APjAAAVdNOKrJuSlNVCayjivo0+Wlz76UpmT1xo+qBeYj0AS6JTn/M63
        kWR9Iavx3YjQpOvYkLVt0dnuM3SUfm23BctiAMqx3MonrJj/
X-Google-Smtp-Source: APXvYqw1weHRFzzsTz/h9oygXB3gAoFde26Ac/TNxinHGktUcVjAVNPl8OhwLH2u6iHEnaoeWnbuFZijXkH4wLX7AFe9NO/YervD
MIME-Version: 1.0
X-Received: by 2002:a6b:e615:: with SMTP id g21mr11624512ioh.56.1572147069622;
 Sat, 26 Oct 2019 20:31:09 -0700 (PDT)
Date:   Sat, 26 Oct 2019 20:31:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009ea5720595dc03a3@google.com>
Subject: BUG: MAX_LOCKDEP_KEYS too low!
From:   syzbot <syzbot+692f39f040c1f415567b@syzkaller.appspotmail.com>
To:     allison@lohutok.net, ap420073@gmail.com, davem@davemloft.net,
        idosch@mellanox.com, ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        petrm@mellanox.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    65921376 Merge branch 'net-fix-nested-device-bugs'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1637fdc0e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0ac4d9b35046343
dashboard link: https://syzkaller.appspot.com/bug?extid=692f39f040c1f415567b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+692f39f040c1f415567b@syzkaller.appspotmail.com

BUG: MAX_LOCKDEP_KEYS too low!
turning off the locking correctness validator.
CPU: 0 PID: 15175 Comm: syz-executor.5 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  register_lock_class.cold+0x1b/0x27 kernel/locking/lockdep.c:1222
  __lock_acquire+0xf4/0x4a00 kernel/locking/lockdep.c:3837
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  netif_addr_lock_bh include/linux/netdevice.h:4055 [inline]
  __dev_mc_add+0x2e/0xd0 net/core/dev_addr_lists.c:765
  dev_mc_add+0x20/0x30 net/core/dev_addr_lists.c:783
  igmp6_group_added+0x3b5/0x460 net/ipv6/mcast.c:672
  __ipv6_dev_mc_inc+0x727/0xa60 net/ipv6/mcast.c:931
  ipv6_dev_mc_inc+0x20/0x30 net/ipv6/mcast.c:938
  ipv6_add_dev net/ipv6/addrconf.c:456 [inline]
  ipv6_add_dev+0xa3d/0x10b0 net/ipv6/addrconf.c:363
  addrconf_notify+0x97d/0x23b0 net/ipv6/addrconf.c:3491
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
  call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1668
  call_netdevice_notifiers_extack net/core/dev.c:1680 [inline]
  call_netdevice_notifiers net/core/dev.c:1694 [inline]
  register_netdevice+0x950/0xeb0 net/core/dev.c:9114
  ieee80211_if_add+0xf51/0x1730 net/mac80211/iface.c:1881
  ieee80211_register_hw+0x36e6/0x3ac0 net/mac80211/main.c:1256
  mac80211_hwsim_new_radio+0x20d9/0x4360  
drivers/net/wireless/mac80211_hwsim.c:3031
  hwsim_new_radio_nl+0x9e3/0x1070 drivers/net/wireless/mac80211_hwsim.c:3586
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
RIP: 0033:0x459f39
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fd0af43ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459f39
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd0af43b6d4
R13: 00000000004c82f8 R14: 00000000004de3f0 R15: 00000000ffffffff
kobject: 'batman_adv' (000000009392522f): kobject_add_internal:  
parent: 'wlan1810', set: '<NULL>'


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
