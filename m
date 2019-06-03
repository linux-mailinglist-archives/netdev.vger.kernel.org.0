Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540D033890
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 20:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFCSvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 14:51:12 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:36917 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFCSvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 14:51:07 -0400
Received: by mail-it1-f200.google.com with SMTP id q20so3086417itq.2
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 11:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Hc/Ql5pBCcEqkkw7qSEADSbLYyZ9Yl7/t4LfmUF/Rso=;
        b=aBUe5UU/d3c0qDqwNuyzwMaNg9eE+NZQ7AiTVafyO3DElZNAqUQOE5S000sWV9nsbQ
         tmnA7ZutdnFxpYjqdfjDH9ACRkFvfRaoAtmkp7fCkH+huTSQrqe0xk6biI8rraOS6XOt
         A2X9+occVaYutvkSbSBUaJCkcLupC9AsCww78AlQ/NxR24AGYsTJfDWsj+z/H1+u3qSp
         qD8GeTS90Z8+Xpqdu4lGKCMGodWUPHtWUJ2t5XRbR0FyMg7Va/AfPs/X2bkUKx2Nugc+
         z0CF4VpvPxf2wX1KhkifYpoge/VN1bF10qOXSw9y+9ezWSeisGvSqihsfibxCwUfdoYg
         JNFg==
X-Gm-Message-State: APjAAAWNtSQgXolNH7jQzmELz7Kii3s+fP4u2HQiKQlSTswwkt24nyl/
        hgvp6tiopFSSVqUf3hJeio3uL+2GP3aigxYjwj/DKB02eTBj
X-Google-Smtp-Source: APXvYqyv0SnXMwc5y1PdJYmwJwPRSYd45Ii8i3pUCXQWuobZWIPev3JRvnZPyZdLwYw0Im3FKuWPa925cFr0Gdovko4iIv/+z6ee
MIME-Version: 1.0
X-Received: by 2002:a24:7585:: with SMTP id y127mr18509944itc.112.1559587865933;
 Mon, 03 Jun 2019 11:51:05 -0700 (PDT)
Date:   Mon, 03 Jun 2019 11:51:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bec591058a6fd889@google.com>
Subject: WARNING: suspicious RCU usage in in_dev_dump_addr
From:   syzbot <syzbot+bad6e32808a3a97b1515@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, anshuman.khandual@arm.com, axboe@kernel.dk,
        benedictwong@google.com, benve@cisco.com, coreteam@netfilter.org,
        davej@codemonkey.org.uk, davem@davemloft.net, dbanerje@akamai.com,
        devel@driverdev.osuosl.org, dledford@redhat.com, doshir@vmware.com,
        edumazet@google.com, faisal.latif@intel.com, fw@strlen.de,
        gbhat@marvell.com, gregkh@linuxfoundation.org,
        gustavo@embeddedor.com, huxinming820@gmail.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com, jgg@ziepe.ca,
        johannes@sipsolutions.net, kadlec@blackhole.kfki.hu,
        keescook@chromium.org, kuznet@ms2.inr.ac.ru, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, liuhangbin@gmail.com,
        lucien.xin@gmail.com, matwey@sai.msu.ru, mpe@ellerman.id.au,
        neescoba@cisco.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nishants@marvell.com,
        pablo@netfilter.org, paulmck@linux.ibm.com, petrm@mellanox.com,
        pkaustub@cisco.com, pv-drivers@vmware.com, romieu@fr.zoreil.com,
        shannon.nelson@oracle.com, shiraz.saleem@intel.com,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b33bc2b8 nexthop: Add entry to MAINTAINERS
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13f46f52a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1004db091673bbaf
dashboard link: https://syzkaller.appspot.com/bug?extid=bad6e32808a3a97b1515
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11dc685aa00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16229e36a00000

The bug was bisected to:

commit 2638eb8b50cfc16240e0bb080b9afbf541a9b39d
Author: Florian Westphal <fw@strlen.de>
Date:   Fri May 31 16:27:09 2019 +0000

     net: ipv4: provide __rcu annotation for ifa_list

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170e1a0ea00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=148e1a0ea00000
console output: https://syzkaller.appspot.com/x/log.txt?x=108e1a0ea00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bad6e32808a3a97b1515@syzkaller.appspotmail.com
Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")

=============================
WARNING: suspicious RCU usage
5.2.0-rc2+ #13 Not tainted
-----------------------------
net/ipv4/devinet.c:1766 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor924/9000:
  #0: 0000000087fe3874 (rtnl_mutex){+.+.}, at: netlink_dump+0xe7/0xfb0  
net/netlink/af_netlink.c:2208

stack backtrace:
CPU: 0 PID: 9000 Comm: syz-executor924 Not tainted 5.2.0-rc2+ #13
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  lockdep_rcu_suspicious+0x153/0x15d kernel/locking/lockdep.c:5250
  in_dev_dump_addr+0x36f/0x3d0 net/ipv4/devinet.c:1766
  inet_dump_ifaddr+0xa8f/0xca0 net/ipv4/devinet.c:1826
  rtnl_dump_all+0x295/0x490 net/core/rtnetlink.c:3444
  netlink_dump+0x558/0xfb0 net/netlink/af_netlink.c:2253
  __netlink_dump_start+0x5b1/0x7d0 net/netlink/af_netlink.c:2361
  netlink_dump_start include/linux/netlink.h:226 [inline]
  rtnetlink_rcv_msg+0x73d/0xb00 net/core/rtnetlink.c:5181
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2486
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5236
  netlink_unicast_kernel net/netlink/af_netlink.c:1311 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1337
  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1926
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:671
  ___sys_sendmsg+0x803/0x920 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4402a9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffe5f26f18 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402a9
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10:


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
