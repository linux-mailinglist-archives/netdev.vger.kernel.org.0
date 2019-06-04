Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C4133E2C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 07:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfFDFHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 01:07:07 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:59739 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfFDFHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 01:07:07 -0400
Received: by mail-it1-f199.google.com with SMTP id h133so17019589ith.9
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 22:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=DmZYgzg+YFnAT/6MNjKfyotNzvRXqZ1VgYxdvhjeudI=;
        b=B4b4FAaucdf4GTidgf8CRRf6EsdDvgcDIwNESUpG20FMMVlhJaubL3jlT0wpMbFaPy
         Ogsl+2ThZzalm9U0HmxYwdjLB62tuu5suh2dvoFeA8itreGdIOXABEEAglRzJVdH8reR
         PGKT8lTUW/VSGwVPxGidTErRliemLxIhwBeJCWX0gkEAyIPMjEroNak1yli24QmtB0f/
         b83j5hhP2wDt0y+E8ksSWHX8L1JuiLt3msRk7vQvjD25jyMDZ9G0gBWxYz1o6ay0m9/U
         eV9hjH72K2fWHntiMGAfxxxwFDUucDCMIV/cZe/JXLopK952bC7dDo0N4GkwEp5VW59t
         7yuw==
X-Gm-Message-State: APjAAAUiJzzbW1Wf2CWk5CajhDluSm/tIAmEoq8cirCAGAgHpzOcYtHH
        LOEu+WUbvnb6fW1CdshgXTCd+UZ4kOcUXgBO9MyZq5xdFMdd
X-Google-Smtp-Source: APXvYqxvTtKNdF/V6WsZP3ybK2IBJJMGL6lvSHMHcGN6gsJm9RUGAue4dWhWSJVyjaEtprMdSYfnsjjX/zzEUh6q7xs8gwiD6UVV
MIME-Version: 1.0
X-Received: by 2002:a5e:9241:: with SMTP id z1mr5508315iop.39.1559624825609;
 Mon, 03 Jun 2019 22:07:05 -0700 (PDT)
Date:   Mon, 03 Jun 2019 22:07:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6a7d2058a78736d@google.com>
Subject: KASAN: slab-out-of-bounds Read in fib6_purge_rt (2)
From:   syzbot <syzbot+f4812f31edd866494c9f@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b33bc2b8 nexthop: Add entry to MAINTAINERS
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1383c9baa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1004db091673bbaf
dashboard link: https://syzkaller.appspot.com/bug?extid=f4812f31edd866494c9f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f4812f31edd866494c9f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __read_once_size  
include/linux/compiler.h:194 [inline]
BUG: KASAN: slab-out-of-bounds in __fib6_drop_pcpu_from  
net/ipv6/ip6_fib.c:899 [inline]
BUG: KASAN: slab-out-of-bounds in fib6_drop_pcpu_from  
net/ipv6/ip6_fib.c:920 [inline]
BUG: KASAN: slab-out-of-bounds in fib6_purge_rt+0x5bf/0x630  
net/ipv6/ip6_fib.c:928
Read of size 8 at addr ffff88809906c2b6 by task kworker/u4:6/8858

CPU: 1 PID: 8858 Comm: kworker/u4:6 Not tainted 5.2.0-rc2+ #13
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
  __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
  kasan_report+0x12/0x20 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  __read_once_size include/linux/compiler.h:194 [inline]
  __fib6_drop_pcpu_from net/ipv6/ip6_fib.c:899 [inline]
  fib6_drop_pcpu_from net/ipv6/ip6_fib.c:920 [inline]
  fib6_purge_rt+0x5bf/0x630 net/ipv6/ip6_fib.c:928
  fib6_del_route net/ipv6/ip6_fib.c:1811 [inline]
  fib6_del+0x9bd/0xeb0 net/ipv6/ip6_fib.c:1842
  fib6_clean_node+0x3a5/0x590 net/ipv6/ip6_fib.c:2004
  fib6_walk_continue+0x4a9/0x8e0 net/ipv6/ip6_fib.c:1926
  fib6_walk+0x9d/0x100 net/ipv6/ip6_fib.c:1974
  fib6_clean_tree+0xe0/0x120 net/ipv6/ip6_fib.c:2053
  __fib6_clean_all+0x118/0x2a0 net/ipv6/ip6_fib.c:2069
  fib6_clean_all+0x2b/0x40 net/ipv6/ip6_fib.c:2080
  rt6_sync_down_dev+0x134/0x150 net/ipv6/route.c:4285
  rt6_disable_ip+0x27/0x5f0 net/ipv6/route.c:4290
  addrconf_ifdown+0xa2/0x1220 net/ipv6/addrconf.c:3707
  addrconf_notify+0x5db/0x2370 net/ipv6/addrconf.c:3632
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:95
  __raw_notifier_call_chain kernel/notifier.c:396 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:403
  call_netdevice_notifiers_info+0x3f/0x90 net/core/dev.c:1753
  call_netdevice_notifiers_extack net/core/dev.c:1765 [inline]
  call_netdevice_notifiers net/core/dev.c:1779 [inline]
  dev_close_many+0x33f/0x6f0 net/core/dev.c:1522
  rollback_registered_many+0x43b/0xfc0 net/core/dev.c:8159
  unregister_netdevice_many.part.0+0x1b/0x1f0 net/core/dev.c:9290
  unregister_netdevice_many+0x3b/0x50 net/core/dev.c:9289
  sit_exit_batch_net+0x560/0x750 net/ipv6/sit.c:1895
  ops_exit_list.isra.0+0xfc/0x150 net/core/net_namespace.c:157
  cleanup_net+0x3fb/0x960 net/core/net_namespace.c:553
  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 11059:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
  slab_post_alloc_hook mm/slab.h:437 [inline]
  slab_alloc mm/slab.c:3326 [inline]
  kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3488
  dst_alloc+0x10e/0x200 net/core/dst.c:93
  ip6_dst_alloc+0x34/0xa0 net/ipv6/route.c:356
  ip6_rt_pcpu_alloc net/ipv6/route.c:1257 [inline]
  rt6_make_pcpu_route net/ipv6/route.c:1287 [inline]
  ip6_pol_route+0x649/0x1010 net/ipv6/route.c:2031
  ip6_pol_route_output+0x54/0x70 net/ipv6/route.c:2204
  fib6_rule_lookup+0x133/0x5a0 net/ipv6/fib6_rules.c:116
  ip6_route_output_flags+0x2c4/0x350 net/ipv6/route.c:2233
  ip6_route_output include/net/ip6_route.h:89 [inline]
  ip6_dst_lookup_tail+0xd10/0x1b30 net/ipv6/ip6_output.c:1027
  ip6_dst_lookup_flow+0xa8/0x220 net/ipv6/ip6_output.c:1155
  sctp_v6_get_dst+0x785/0x1d80 net/sctp/ipv6.c:278
  sctp_transport_route+0x12d/0x360 net/sctp/transport.c:297
  sctp_assoc_add_peer+0x53e/0xfc0 net/sctp/associola.c:663
  sctp_process_param net/sctp/sm_make_chunk.c:2531 [inline]
  sctp_process_init+0x2491/0x2b10 net/sctp/sm_make_chunk.c:2344
  sctp_sf_do_5_1D_ce+0x458/0x1390 net/sctp/sm_statefuns.c:767
  sctp_do_sm+0x121/0x50e0 net/sctp/sm_sideeffect.c:1147
  sctp_endpoint_bh_rcv+0x451/0x950 net/sctp/endpointola.c:443
  sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
  sctp_rcv+0x2807/0x35c0 net/sctp/input.c:256
  sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
  ip6_protocol_deliver_rcu+0x2fe/0x16c0 net/ipv6/ip6_input.c:401
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:442
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:451
  dst_input include/net/dst.h:439 [inline]
  ip6_rcv_finish+0x1de/0x310 net/ipv6/ip6_input.c:80
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:276
  __netif_receive_skb_one_core+0x113/0x1a0 net/core/dev.c:4985
  __netif_receive_skb+0x2c/0x1d0 net/core/dev.c:5099
  process_backlog+0x206/0x750 net/core/dev.c:5910
  napi_poll net/core/dev.c:6333 [inline]
  net_rx_action+0x4f5/0x1070 net/core/dev.c:6399
  __do_softirq+0x25c/0x94c kernel/softirq.c:293

Freed by task 10228:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kmem_cache_free+0x86/0x260 mm/slab.c:3698
  dst_destroy+0x29e/0x3c0 net/core/dst.c:129
  dst_destroy_rcu+0x16/0x19 net/core/dst.c:142
  __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
  rcu_do_batch kernel/rcu/tree.c:2092 [inline]
  invoke_rcu_callbacks kernel/rcu/tree.c:2310 [inline]
  rcu_core+0xba5/0x1500 kernel/rcu/tree.c:2291
  __do_softirq+0x25c/0x94c kernel/softirq.c:293

The buggy address belongs to the object at ffff88809906c1c0
  which belongs to the cache ip6_dst_cache of size 224
The buggy address is located 22 bytes to the right of
  224-byte region [ffff88809906c1c0, ffff88809906c2a0)
The buggy address belongs to the page:
page:ffffea0002641b00 refcount:1 mapcount:0 mapping:ffff8882164c0680  
index:0xffff88809906cbc0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea00025c0748 ffffea0002595a08 ffff8882164c0680
raw: ffff88809906cbc0 ffff88809906c080 000000010000000b 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff88809906c180: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
  ffff88809906c200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ffff88809906c280: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
                                      ^
  ffff88809906c300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ffff88809906c380: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
