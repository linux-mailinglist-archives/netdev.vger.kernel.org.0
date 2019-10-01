Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA1CC2C3E
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 05:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732501AbfJADJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 23:09:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:44847 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbfJADJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 23:09:08 -0400
Received: by mail-io1-f71.google.com with SMTP id k13so27242892ioc.11
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 20:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JLXTCXDRkGgctb2xPnmJD2LK8JwJzPu9ZPbIig+sy3g=;
        b=nAyJPSt2xVuNwf3oe/rWctz0OXwy/q/69jd4RlWw3BGt4HQPjUwssl8SB5AzwNDkMe
         PbpuJ0QRAGoYk5JHK08pcVqQS9DmksiNWKfyxXqQ4R2p0HfPOf1CTs8iy/QLfA0be2NF
         6YZx6AfTUlangr6EPYo4i62kAVeMtQ57Se3wc/VVh+WLovW0iPPu+wGdwPUfcd3QyJib
         7hG6MiajMyRXBFfObeyEy8+6UK5QDj39+eClf0TaUU9z783luuUp3k9beYoXdsyU+wPl
         8puDr5vUQ8T8YFbQ+G/HUI8kkIr0FEW5WJTalouT1v8gCA4bAhB5hwgMinpjYcfh0U1v
         n+kA==
X-Gm-Message-State: APjAAAW6yoLKc50KebSyC4c1yepA/StXJ8OePvYd+O0pkzg8O3tuFmDc
        oMJrQYFf4+KpBStvKMukBupphow1wz+x33tmMlo3Ywehhrvt
X-Google-Smtp-Source: APXvYqy/wDCuSBR5dewA+ROX+rSiu1eGY5t9YhJeuT2SwMfJ20WRn+0DDAFhGaLDN2WUk9sD8ON2xqmx8WPFsZsfXjRnqYQ5Ymge
MIME-Version: 1.0
X-Received: by 2002:a92:844f:: with SMTP id l76mr22421313ild.218.1569899347902;
 Mon, 30 Sep 2019 20:09:07 -0700 (PDT)
Date:   Mon, 30 Sep 2019 20:09:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f70cb20593d0ace6@google.com>
Subject: KASAN: use-after-free Read in batadv_iv_ogm_queue_add
From:   syzbot <syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    faeacb6d net: tap: clean up an indentation issue
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1241cbd3600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c210ff0b9a35071
dashboard link: https://syzkaller.appspot.com/bug?extid=0cc629f19ccb8534935b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0cc629f19ccb8534935b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcpy include/linux/string.h:359 [inline]
BUG: KASAN: use-after-free in batadv_iv_ogm_aggregate_new  
net/batman-adv/bat_iv_ogm.c:544 [inline]
BUG: KASAN: use-after-free in batadv_iv_ogm_queue_add+0x31d/0x1120  
net/batman-adv/bat_iv_ogm.c:640
Read of size 24 at addr ffff888099112740 by task kworker/u4:2/2025

CPU: 1 PID: 2025 Comm: kworker/u4:2 Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:618
  check_memory_region_inline mm/kasan/generic.c:185 [inline]
  check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
  memcpy+0x24/0x50 mm/kasan/common.c:122
  memcpy include/linux/string.h:359 [inline]
  batadv_iv_ogm_aggregate_new net/batman-adv/bat_iv_ogm.c:544 [inline]
  batadv_iv_ogm_queue_add+0x31d/0x1120 net/batman-adv/bat_iv_ogm.c:640
  batadv_iv_ogm_schedule+0x783/0xe50 net/batman-adv/bat_iv_ogm.c:797
  batadv_iv_send_outstanding_bat_ogm_packet+0x580/0x730  
net/batman-adv/bat_iv_ogm.c:1675
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

Allocated by task 9774:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc mm/kasan/common.c:493 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:466
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:507
  kmem_cache_alloc_trace+0x158/0x790 mm/slab.c:3550
  kmalloc include/linux/slab.h:552 [inline]
  batadv_iv_ogm_iface_enable+0x123/0x320 net/batman-adv/bat_iv_ogm.c:201
  batadv_hardif_enable_interface+0x276/0x950  
net/batman-adv/hard-interface.c:761
  batadv_softif_slave_add+0x8f/0x100 net/batman-adv/soft-interface.c:892
  do_set_master net/core/rtnetlink.c:2369 [inline]
  do_set_master+0x1ca/0x230 net/core/rtnetlink.c:2343
  do_setlink+0xa85/0x3520 net/core/rtnetlink.c:2504
  rtnl_setlink+0x273/0x3d0 net/core/rtnetlink.c:2763
  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5223
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5241
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x8a5/0xd60 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:657
  sock_write_iter+0x27c/0x3e0 net/socket.c:989
  call_write_iter include/linux/fs.h:1880 [inline]
  do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
  do_iter_write fs/read_write.c:970 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:951
  vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
  do_writev+0x15b/0x330 fs/read_write.c:1058
  __do_sys_writev fs/read_write.c:1131 [inline]
  __se_sys_writev fs/read_write.c:1128 [inline]
  __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 7:
  save_stack+0x23/0x90 mm/kasan/common.c:69
  set_track mm/kasan/common.c:77 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:455
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:463
  __cache_free mm/slab.c:3425 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3756
  batadv_iv_ogm_iface_disable+0x39/0x80 net/batman-adv/bat_iv_ogm.c:220
  batadv_hardif_disable_interface.cold+0x4b4/0x87b  
net/batman-adv/hard-interface.c:875
  batadv_softif_destroy_netlink+0xa9/0x130  
net/batman-adv/soft-interface.c:1146
  default_device_exit_batch+0x25c/0x410 net/core/dev.c:9830
  ops_exit_list.isra.0+0xfc/0x150 net/core/net_namespace.c:175
  cleanup_net+0x4e2/0xa60 net/core/net_namespace.c:594
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff888099112740
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes inside of
  32-byte region [ffff888099112740, ffff888099112760)
The buggy address belongs to the page:
page:ffffea0002644480 refcount:1 mapcount:0 mapping:ffff8880aa4001c0  
index:0xffff888099112fc1
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea0002995848 ffffea00029e8bc8 ffff8880aa4001c0
raw: ffff888099112fc1 ffff888099112000 000000010000003a 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888099112600: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff888099112680: 00 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
> ffff888099112700: 00 00 00 fc fc fc fc fc fb fb fb fb fc fc fc fc
                                            ^
  ffff888099112780: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff888099112800: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
