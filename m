Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B450757C71
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 08:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfF0GuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 02:50:08 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:37484 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfF0GuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 02:50:07 -0400
Received: by mail-io1-f72.google.com with SMTP id j18so1517142ioj.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 23:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xEliJdK9M3/w6rIbLzit+wZM9b/EZDWvsE/5TUp3ZSw=;
        b=e85zRvd7HN45xLDHaBxb9K5RZPcP/S7Ye6hEFUUwrorbFOJZcQUA2/tCqiT90PZzjH
         rcCCHm/iQFNwfkTOhCwYQXU5aclbjaTE9xKZPbUJVpdLk19MdzKnPH4a0VUJxlPpHFYb
         /Lis8nnb8PWD/Ka3Q94Q6KsKCBevf82wJMHeEk94Eyh5AAV0ZgHj/GNhy5r2XOGcbzpq
         t36QvmSspL01bgCVmBJLWiXFZB/fLn8ryXufox+eduNKMO5tMLe6qP04grJru6/AD6ap
         wxE98wLgv37u/hw/0uTfS09hFXg1SZcHYhAc8pqP8uOeC1mpvakZ9d9tu92y7HFvN1Us
         Knaw==
X-Gm-Message-State: APjAAAV44Hb4hz1WxvZWWbI6O1THaFn7NmvPoaEiPZaWdQM/TrSlSZ+H
        r11J/x0koZK+9iV8Odl9Ke19F1iMJ0riTpvSWSe+COPrgvfM
X-Google-Smtp-Source: APXvYqxz8XXM3GckL+zjAINTnXDWdnY/BTxiabDh+wfVTjxIvNF+aaEw1qAj7GXamGAv60IJO+9OCmU8R5xhMLsnZKcwnwC6u2em
MIME-Version: 1.0
X-Received: by 2002:a6b:6b0d:: with SMTP id g13mr2810486ioc.55.1561618206772;
 Wed, 26 Jun 2019 23:50:06 -0700 (PDT)
Date:   Wed, 26 Jun 2019 23:50:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007d52ea058c489235@google.com>
Subject: KASAN: use-after-free Write in xfrm_policy_flush
From:   syzbot <syzbot+2daeb7ae5e8245095f65@syzkaller.appspotmail.com>
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

HEAD commit:    249155c2 Merge branch 'parisc-5.2-4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f1198da00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a31528e58cc12e2
dashboard link: https://syzkaller.appspot.com/bug?extid=2daeb7ae5e8245095f65
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2daeb7ae5e8245095f65@syzkaller.appspotmail.com

netlink: 168 bytes leftover after parsing attributes in process  
`syz-executor.2'.
==================================================================
BUG: KASAN: use-after-free in __write_once_size  
include/linux/compiler.h:221 [inline]
BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:748 [inline]
BUG: KASAN: use-after-free in hlist_del_rcu include/linux/rculist.h:455  
[inline]
BUG: KASAN: use-after-free in __xfrm_policy_unlink  
net/xfrm/xfrm_policy.c:2217 [inline]
BUG: KASAN: use-after-free in xfrm_policy_flush+0x3be/0x900  
net/xfrm/xfrm_policy.c:1794
Write of size 8 at addr ffff8880a5cfdd00 by task syz-executor.2/31717

CPU: 0 PID: 31717 Comm: syz-executor.2 Not tainted 5.2.0-rc6+ #7
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  print_address_description+0x6d/0x310 mm/kasan/report.c:188
  __kasan_report+0x14b/0x1c0 mm/kasan/report.c:317
  kasan_report+0x26/0x50 mm/kasan/common.c:614
  __asan_report_store8_noabort+0x17/0x20 mm/kasan/generic_report.c:137
  __write_once_size include/linux/compiler.h:221 [inline]
  __hlist_del include/linux/list.h:748 [inline]
  hlist_del_rcu include/linux/rculist.h:455 [inline]
  __xfrm_policy_unlink net/xfrm/xfrm_policy.c:2217 [inline]
  xfrm_policy_flush+0x3be/0x900 net/xfrm/xfrm_policy.c:1794
  xfrm_flush_policy+0x132/0x3c0 net/xfrm/xfrm_user.c:2123
  xfrm_user_rcv_msg+0x46b/0x720 net/xfrm/xfrm_user.c:2657
  netlink_rcv_skb+0x1f0/0x460 net/netlink/af_netlink.c:2482
  xfrm_netlink_rcv+0x74/0x90 net/xfrm/xfrm_user.c:2665
  netlink_unicast_kernel net/netlink/af_netlink.c:1307 [inline]
  netlink_unicast+0x962/0xaf0 net/netlink/af_netlink.c:1333
  netlink_sendmsg+0xa7a/0xd40 net/netlink/af_netlink.c:1922
  sock_sendmsg_nosec net/socket.c:646 [inline]
  sock_sendmsg net/socket.c:665 [inline]
  ___sys_sendmsg+0x66b/0x9a0 net/socket.c:2286
  __sys_sendmsg net/socket.c:2324 [inline]
  __do_sys_sendmsg net/socket.c:2333 [inline]
  __se_sys_sendmsg net/socket.c:2331 [inline]
  __x64_sys_sendmsg+0x1cf/0x290 net/socket.c:2331
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459519
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4e7b5f5c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459519
RDX: 0000000000000000 RSI: 000000002014f000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f4e7b5f66d4
R13: 00000000004c7264 R14: 00000000004dc6c8 R15: 00000000ffffffff

Allocated by task 8433:
  save_stack mm/kasan/common.c:71 [inline]
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:489
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3660 [inline]
  __kmalloc+0x23c/0x310 mm/slab.c:3669
  kmalloc include/linux/slab.h:552 [inline]
  kzalloc include/linux/slab.h:742 [inline]
  xfrm_hash_alloc+0x38/0xe0 net/xfrm/xfrm_hash.c:21
  xfrm_policy_init net/xfrm/xfrm_policy.c:4036 [inline]
  xfrm_net_init+0x269/0xd60 net/xfrm/xfrm_policy.c:4120
  ops_init+0x336/0x420 net/core/net_namespace.c:130
  setup_net+0x212/0x690 net/core/net_namespace.c:316
  copy_net_ns+0x224/0x380 net/core/net_namespace.c:439
  create_new_namespaces+0x4ec/0x700 kernel/nsproxy.c:103
  unshare_nsproxy_namespaces+0x12a/0x190 kernel/nsproxy.c:202
  ksys_unshare+0x540/0xac0 kernel/fork.c:2692
  __do_sys_unshare kernel/fork.c:2760 [inline]
  __se_sys_unshare kernel/fork.c:2758 [inline]
  __x64_sys_unshare+0x38/0x40 kernel/fork.c:2758
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 21222:
  save_stack mm/kasan/common.c:71 [inline]
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x12a/0x1e0 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3432 [inline]
  kfree+0xae/0x120 mm/slab.c:3755
  xfrm_hash_free+0x38/0xd0 net/xfrm/xfrm_hash.c:35
  xfrm_bydst_resize net/xfrm/xfrm_policy.c:602 [inline]
  xfrm_hash_resize+0x13f1/0x1840 net/xfrm/xfrm_policy.c:680
  process_one_work+0x814/0x1130 kernel/workqueue.c:2269
  worker_thread+0xc01/0x1640 kernel/workqueue.c:2415
  kthread+0x325/0x350 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff8880a5cfdd00
  which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
  64-byte region [ffff8880a5cfdd00, ffff8880a5cfdd40)
The buggy address belongs to the page:
page:ffffea0002973f40 refcount:1 mapcount:0 mapping:ffff8880aa400340  
index:0x0
flags: 0x1fffc0000000200(slab)
raw: 01fffc0000000200 ffffea000267ccc8 ffffea0002a49b08 ffff8880aa400340
raw: 0000000000000000 ffff8880a5cfd000 0000000100000020 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880a5cfdc00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
  ffff8880a5cfdc80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> ffff8880a5cfdd00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                    ^
  ffff8880a5cfdd80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
  ffff8880a5cfde00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
