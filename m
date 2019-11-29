Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C110D256
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 09:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfK2ITK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 03:19:10 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:55924 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfK2ITJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 03:19:09 -0500
Received: by mail-il1-f199.google.com with SMTP id p21so16706879ilk.22
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 00:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=E5gKeVgtMrp7If0kAH9nlbsGZrXj2cLc/13fs8BlcyY=;
        b=IZGVs2tK8AVcl1TenW2joe0CZuvY3CppP4/Z4mRkrsVCIukW3h12vUMxE4LvbF4hbh
         yURcpZPgwCeaic+6g8JhJYjEPPkl2FdyyJwebno/zDqMXdnZ7yT/k17IXiwEJIV47N+r
         K7ggHlh70a3oPOY/UstSgJOjRUj+QzUQEI3hUTdLvmj24hVcM9sLC+uH4JuggphKB4Ok
         URJrrJHIXPE15BFV262ibKVIX+Q0A6E8JoYzRUF7GeHDKKOknw20SEszJEkl+rOidl5+
         K5H/SvNpaoC7CwEEWa9McDDnzFThwhQfUQbsrkwa6CeomiQhgQzMph5LKiUNKlN8Yg0k
         7O5g==
X-Gm-Message-State: APjAAAWqSK0r5AaJ6A0vaa/jsP//yhIvrjIVXr+ZkKKi26UAAb1aokc9
        Izff25ggd/KvtPX6Di4LHTUMcqr6tz8Jueldv4iGxXuxUSiI
X-Google-Smtp-Source: APXvYqy4pHLWLogIRjyJjyaAyud0GMGq8Kjm8MfuVskkdAlrCtsM4Wm0yFekqGAUXGYs71702OegRnLrg7/eFH8LiD1nncjWqKg0
MIME-Version: 1.0
X-Received: by 2002:a02:9503:: with SMTP id y3mr13025084jah.14.1575015548603;
 Fri, 29 Nov 2019 00:19:08 -0800 (PST)
Date:   Fri, 29 Nov 2019 00:19:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004a5415059877e248@google.com>
Subject: KASAN: slab-out-of-bounds Read in __xfrm_decode_session
From:   syzbot <syzbot+6883e878b7a8f2efeeb2@syzkaller.appspotmail.com>
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

HEAD commit:    cbafe18c Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f20ca3600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb5c74e7f328d20b
dashboard link: https://syzkaller.appspot.com/bug?extid=6883e878b7a8f2efeeb2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6883e878b7a8f2efeeb2@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in decode_session6  
net/xfrm/xfrm_policy.c:3390 [inline]
BUG: KASAN: slab-out-of-bounds in __xfrm_decode_session+0x1cfb/0x2e90  
net/xfrm/xfrm_policy.c:3482
Read of size 1 at addr ffff8880915d1b49 by task kworker/0:0/16350

CPU: 0 PID: 16350 Comm: kworker/0:0 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events rt6_probe_deferred
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
  __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
  kasan_report+0x12/0x20 mm/kasan/common.c:634
  __asan_report_load1_noabort+0x14/0x20 mm/kasan/generic_report.c:129
  decode_session6 net/xfrm/xfrm_policy.c:3390 [inline]
  __xfrm_decode_session+0x1cfb/0x2e90 net/xfrm/xfrm_policy.c:3482
  xfrm_decode_session include/net/xfrm.h:1137 [inline]
  vti_tunnel_xmit+0x277/0x17a0 net/ipv4/ip_vti.c:269
  __netdev_start_xmit include/linux/netdevice.h:4420 [inline]
  netdev_start_xmit include/linux/netdevice.h:4434 [inline]
  xmit_one net/core/dev.c:3280 [inline]
  dev_hard_start_xmit+0x1a3/0x9b0 net/core/dev.c:3296
  sch_direct_xmit+0x372/0xc30 net/sched/sch_generic.c:313
  qdisc_restart net/sched/sch_generic.c:376 [inline]
  __qdisc_run+0x577/0x1a00 net/sched/sch_generic.c:384
  __dev_xmit_skb net/core/dev.c:3537 [inline]
  __dev_queue_xmit+0x169d/0x3720 net/core/dev.c:3842
  dev_queue_xmit+0x18/0x20 net/core/dev.c:3906
  neigh_direct_output+0x16/0x20 net/core/neighbour.c:1530
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x1034/0x2550 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip6_output+0x235/0x7f0 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  ndisc_send_skb+0xf29/0x14a0 net/ipv6/ndisc.c:505
  ndisc_send_ns+0x3a9/0x850 net/ipv6/ndisc.c:647
  rt6_probe_deferred+0xe3/0x1a0 net/ipv6/route.c:615
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 3892:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:510 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:483
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc mm/slab.c:3655 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3664
  kmalloc include/linux/slab.h:557 [inline]
  tomoyo_realpath_from_path+0xcd/0x7b0 security/tomoyo/realpath.c:277
  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
  tomoyo_path_number_perm+0x1dd/0x520 security/tomoyo/file.c:723
  tomoyo_file_ioctl+0x23/0x30 security/tomoyo/tomoyo.c:335
  security_file_ioctl+0x77/0xc0 security/security.c:1375
  ksys_ioctl+0x57/0xd0 fs/ioctl.c:711
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 3892:
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
  security_file_ioctl+0x77/0xc0 security/security.c:1375
  ksys_ioctl+0x57/0xd0 fs/ioctl.c:711
  __do_sys_ioctl fs/ioctl.c:720 [inline]
  __se_sys_ioctl fs/ioctl.c:718 [inline]
  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880915d0680
  which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 1225 bytes to the right of
  4096-byte region [ffff8880915d0680, ffff8880915d1680)
The buggy address belongs to the page:
page:ffffea0002457400 refcount:1 mapcount:0 mapping:ffff8880aa402000  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea0000d97208 ffffea00025a7b88 ffff8880aa402000
raw: 0000000000000000 ffff8880915d0680 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880915d1a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880915d1a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ffff8880915d1b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                               ^
  ffff8880915d1b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880915d1c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
