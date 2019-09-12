Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0541B09D4
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 10:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729803AbfILICI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 04:02:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:47229 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfILICH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 04:02:07 -0400
Received: by mail-io1-f72.google.com with SMTP id q1so14048875ios.14
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 01:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LhGDYMGTgJzz70RMNjJrmzGfhkM7v2mcXEk+08QHGMo=;
        b=iB36bCDDsHmksWGdJ2miucaNov3YSO2y0ukR8IIM4VKg6AHVJE2I46Sd0G1dii92V2
         gzVA+zvj2c3Ves/dm+P7OcUZIbwOkav2gPihqhEhseHo1+FIYxEAHi/gMUuj/4uVaoq0
         BE53+1BuRj0jTfT6vo/9JtInBArlZlKzyHh52ZqIEXbnOOssmL282ykweXL/j9oGCIK6
         06hSiZbr40HpePwgzMac+/b3ytIVvSWoDCdLjpJpRujWquVVKz8bxtvuHpLOE6ZpHZkW
         AzYQ8uUNUil9Ii6T/eVLrSKpmwosHXsi8lcZffKtICEwD6kF8mF9P85bQmG0gf+gIcMW
         7FIg==
X-Gm-Message-State: APjAAAW+f64u+QhCe2qxbJfNXKrpEkds+zozcQyxgkp3JSd+Ux1BwNHs
        npIMpF3DilDLBsHqvpFb3fMyv5t9GRDPOJdn2IeiDTfaGOVu
X-Google-Smtp-Source: APXvYqzuEr3l68FH1gWQpMTp/iPPWLIbOFwBe4V+6deTc5oQwvl8wp+stNzIoMEEBv/R+2lYe355+OHEdOeYkSE6rbYMpUm2fGzk
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1b9:: with SMTP id b25mr3821970jaq.48.1568275326597;
 Thu, 12 Sep 2019 01:02:06 -0700 (PDT)
Date:   Thu, 12 Sep 2019 01:02:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c080bc0592568d65@google.com>
Subject: KASAN: use-after-free Read in __xfrm_decode_session
From:   syzbot <syzbot+55d9cf7c57894c1e4860@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6d028043 Add linux-next specific files for 20190830
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=150de9b9600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82a6bec43ab0cb69
dashboard link: https://syzkaller.appspot.com/bug?extid=55d9cf7c57894c1e4860
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+55d9cf7c57894c1e4860@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in decode_session6 net/xfrm/xfrm_policy.c:3390  
[inline]
BUG: KASAN: use-after-free in __xfrm_decode_session+0x1cfb/0x2e90  
net/xfrm/xfrm_policy.c:3482
Read of size 1 at addr ffff88805cdb288e by task syz-executor.0/24778

CPU: 0 PID: 24778 Comm: syz-executor.0 Not tainted 5.3.0-rc6-next-20190830  
#75
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:129
  decode_session6 net/xfrm/xfrm_policy.c:3390 [inline]
  __xfrm_decode_session+0x1cfb/0x2e90 net/xfrm/xfrm_policy.c:3482
  xfrm_decode_session_reverse include/net/xfrm.h:1144 [inline]
  icmpv6_route_lookup+0x31b/0x4d0 net/ipv6/icmp.c:369
  icmp6_send+0x129e/0x1e20 net/ipv6/icmp.c:557
  icmpv6_send+0xec/0x230 net/ipv6/ip6_icmp.c:43
  ip6_link_failure+0x2b/0x530 net/ipv6/route.c:2640
  dst_link_failure include/net/dst.h:419 [inline]
  ip6_tnl_xmit+0x45b/0x33f0 net/ipv6/ip6_tunnel.c:1222
  ip6ip6_tnl_xmit net/ipv6/ip6_tunnel.c:1376 [inline]
  ip6_tnl_start_xmit+0x847/0x1c90 net/ipv6/ip6_tunnel.c:1402
  __netdev_start_xmit include/linux/netdevice.h:4419 [inline]
  netdev_start_xmit include/linux/netdevice.h:4433 [inline]
  xmit_one net/core/dev.c:3280 [inline]
  dev_hard_start_xmit+0x1a3/0x9c0 net/core/dev.c:3296
  sch_direct_xmit+0x372/0xc30 net/sched/sch_generic.c:308
  qdisc_restart net/sched/sch_generic.c:371 [inline]
  __qdisc_run+0x586/0x19d0 net/sched/sch_generic.c:379
  __dev_xmit_skb net/core/dev.c:3533 [inline]
  __dev_queue_xmit+0x16f1/0x37c0 net/core/dev.c:3838
  dev_queue_xmit+0x18/0x20 net/core/dev.c:3902
  neigh_direct_output+0x16/0x20 net/core/neighbour.c:1530
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x1034/0x2550 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip6_output+0x235/0x7f0 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip6_xmit+0xe35/0x20b0 net/ipv6/ip6_output.c:279
  inet6_csk_xmit+0x2fb/0x5d0 net/ipv6/inet6_connection_sock.c:135
  __tcp_transmit_skb+0x1a2f/0x3820 net/ipv4/tcp_output.c:1158
  tcp_transmit_skb net/ipv4/tcp_output.c:1174 [inline]
  tcp_send_syn_data net/ipv4/tcp_output.c:3505 [inline]
  tcp_connect+0x1be7/0x4320 net/ipv4/tcp_output.c:3570
  tcp_sendmsg_fastopen net/ipv4/tcp.c:1155 [inline]
  tcp_sendmsg_locked+0x2898/0x3220 net/ipv4/tcp.c:1206
  tcp_sendmsg+0x30/0x50 net/ipv4/tcp.c:1434
  inet6_sendmsg+0x9e/0xe0 net/ipv6/af_inet6.c:576
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  __sys_sendto+0x262/0x380 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe1/0x1a0 net/socket.c:1960
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f83d1625c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00000000004598e9
RDX: 0000000000000001 RSI: 0000000020000340 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000200400cf R11: 0000000000000246 R12: 00007f83d16266d4
R13: 00000000004c7880 R14: 00000000004dd188 R15: 00000000ffffffff

Allocated by task 3891:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:561 [inline]
  tomoyo_realpath_from_path+0xcd/0x7b0 security/tomoyo/realpath.c:277
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_path_number_perm+0x1dd/0x520 security/tomoyo/file.c:723
  tomoyo_file_ioctl+0x23/0x30 security/tomoyo/tomoyo.c:335
  security_file_ioctl+0x77/0xc0 security/security.c:1409
  ksys_ioctl+0x57/0xd0 fs/ioctl.c:711
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 3891:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  kasan_set_free_info mm/kasan/common.c:332 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:471
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:480
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  tomoyo_realpath_from_path+0x1de/0x7b0 security/tomoyo/realpath.c:319
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_path_number_perm+0x1dd/0x520 security/tomoyo/file.c:723
  tomoyo_file_ioctl+0x23/0x30 security/tomoyo/tomoyo.c:335
  security_file_ioctl+0x77/0xc0 security/security.c:1409
  ksys_ioctl+0x57/0xd0 fs/ioctl.c:711
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff88805cdb2000
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 2190 bytes inside of
  4096-byte region [ffff88805cdb2000, ffff88805cdb3000)
The buggy address belongs to the page:
page:ffffea0001736c80 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0001941688 ffffea0002364008 ffff8880aa402000
raw: 0000000000000000 ffff88805cdb2000 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88805cdb2780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88805cdb2800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88805cdb2880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88805cdb2900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88805cdb2980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
