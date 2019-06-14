Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB3E45253
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 05:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfFNDEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 23:04:02 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:41231 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFNDEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 23:04:02 -0400
Received: by mail-io1-f72.google.com with SMTP id x17so1048292iog.8
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 20:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=PHxaNNA+u/QED5OOo6diZIR8nbgzxac97BJz2T2vBYM=;
        b=KGh6K5gCHUdBpfo629x9qMYZvXHo4sYYhXO6pH59J7OYcSo0jl9BTgkVEQyvVEUrk4
         ANDkkJdu7axmRD6J2cOjwnBSVY/QGnrh5wCeBPlR2hUZWzCeuEmbIjaYhgoI2ox8dgC7
         plDI34lqij2iRQ0OnO1UZawyEMHlYKozkdZsERT1VvHAv/4KhpNUpaJC/DSNj7OYnY3z
         2fJJJoQl4se97fwvtV7olq01iHi7PWpo0bbrWrS5UTq8OO0UjVh16FyTKC6XclTssPxP
         uVKZtPZPOGgFgfWRYGTIPv7cAy0ViLTmuwrkxqDxcV3L9tcrdLaoX9be29flFlVaJQHy
         jTiA==
X-Gm-Message-State: APjAAAVA6r3IjsVSJLi71QcaUNXBk0oBuLeNg+DktXjwEZxxmvqsw3T0
        70imNKgrZcNK1pgpOd72GcJDW5tc391O/NqjpS9qIzxKF5A8
X-Google-Smtp-Source: APXvYqx8b/cV+6qlNoRhaqUH0N8de515QwPf+Xv2nvU80JzlYAFYIaaW3fH3gbCXLbR9A4dtUXyuVwMGtTtkuP3r7VbjVUy8BlzK
MIME-Version: 1.0
X-Received: by 2002:a5d:9613:: with SMTP id w19mr35036580iol.140.1560481441104;
 Thu, 13 Jun 2019 20:04:01 -0700 (PDT)
Date:   Thu, 13 Jun 2019 20:04:01 -0700
In-Reply-To: <20190614024519.6224-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f9d056058b3fe507@google.com>
Subject: Re: memory leak in vhost_net_ioctl
From:   syzbot <syzbot+0789f0c7e45efd7bb643@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dvyukov@google.com, hawk@kernel.org,
        hdanton@sina.com, jakub.kicinski@netronome.com,
        jasowang@redhat.com, john.fastabend@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
memory leak in batadv_tvlv_handler_register

   484.626788][  T156] bond0 (unregistering): Releasing backup interface  
bond_slave_1
Warning: Permanently added '10.128.0.87' (ECDSA) to the list of known hosts.
BUG: memory leak
unreferenced object 0xffff88811d25c4c0 (size 64):
   comm "softirq", pid 0, jiffies 4294943668 (age 434.830s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 fc 5b 20 81 88 ff ff  ..........[ ....
     00 00 00 00 00 00 00 00 20 91 15 83 ff ff ff ff  ........ .......
   backtrace:
     [<000000000045bc9d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000045bc9d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000045bc9d>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000045bc9d>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000197d773e>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000197d773e>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000197d773e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000fa9f11af>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000008c50839d>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001c5a74a3>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000004e676cd1>] register_netdevice+0xbf/0x600 net/core/dev.c:8635
     [<000000005601497b>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3199
     [<00000000ad02cf5e>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3245
     [<00000000eceb53af>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5214
     [<00000000140451f6>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2482
     [<00000000237e38f7>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5232
     [<000000000d47c000>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1307 [inline]
     [<000000000d47c000>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1333
     [<0000000098503d79>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1922
     [<000000009263e868>] sock_sendmsg_nosec net/socket.c:646 [inline]
     [<000000009263e868>] sock_sendmsg+0x54/0x70 net/socket.c:665
     [<000000007791ad47>] __sys_sendto+0x148/0x1f0 net/socket.c:1958
     [<00000000d6f3807d>] __do_sys_sendto net/socket.c:1970 [inline]
     [<00000000d6f3807d>] __se_sys_sendto net/socket.c:1966 [inline]
     [<00000000d6f3807d>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1966

BUG: memory leak
unreferenced object 0xffff8881024a3340 (size 64):
   comm "softirq", pid 0, jiffies 4294943678 (age 434.730s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 e0 2c 66 04 81 88 ff ff  .........,f.....
     00 00 00 00 00 00 00 00 20 91 15 83 ff ff ff ff  ........ .......
   backtrace:
     [<000000000045bc9d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000045bc9d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000045bc9d>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000045bc9d>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000197d773e>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000197d773e>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000197d773e>] batadv_tvlv_handler_register+0xae/0x140  
net/batman-adv/tvlv.c:529
     [<00000000fa9f11af>] batadv_tt_init+0x78/0x180  
net/batman-adv/translation-table.c:4411
     [<000000008c50839d>] batadv_mesh_init+0x196/0x230  
net/batman-adv/main.c:208
     [<000000001c5a74a3>] batadv_softif_init_late+0x1ca/0x220  
net/batman-adv/soft-interface.c:861
     [<000000004e676cd1>] register_netdevice+0xbf/0x600 net/core/dev.c:8635
     [<000000005601497b>] __rtnl_newlink+0xaca/0xb30  
net/core/rtnetlink.c:3199
     [<00000000ad02cf5e>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3245
     [<00000000eceb53af>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5214
     [<00000000140451f6>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2482
     [<00000000237e38f7>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5232
     [<000000000d47c000>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1307 [inline]
     [<000000000d47c000>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1333
     [<0000000098503d79>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1922
     [<000000009263e868>] sock_sendmsg_nosec net/socket.c:646 [inline]
     [<000000009263e868>] sock_sendmsg+0x54/0x70 net/socket.c:665
     [<000000007791ad47>] __sys_sendto+0x148/0x1f0 net/socket.c:1958
     [<00000000d6f3807d>] __do_sys_sendto net/socket.c:1970 [inline]
     [<00000000d6f3807d>] __se_sys_sendto net/socket.c:1966 [inline]
     [<00000000d6f3807d>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1966

BUG: memory leak
unreferenced object 0xffff888108a71b80 (size 128):
   comm "syz-executor.3", pid 7367, jiffies 4294943696 (age 434.550s)
   hex dump (first 32 bytes):
     f0 f8 bf 02 81 88 ff ff f0 f8 bf 02 81 88 ff ff  ................
     1a dc 77 da 54 a0 be 41 64 20 e9 56 ff ff ff ff  ..w.T..Ad .V....
   backtrace:
     [<000000000045bc9d>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<000000000045bc9d>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000000045bc9d>] slab_alloc mm/slab.c:3326 [inline]
     [<000000000045bc9d>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000cc6863ae>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000cc6863ae>] hsr_create_self_node+0x42/0x150  
net/hsr/hsr_framereg.c:84
     [<000000000e2bb6b0>] hsr_dev_finalize+0xa4/0x233  
net/hsr/hsr_device.c:441
     [<000000003b100a4a>] hsr_newlink+0xf3/0x140 net/hsr/hsr_netlink.c:69
     [<00000000b5efb0eb>] __rtnl_newlink+0x892/0xb30  
net/core/rtnetlink.c:3187
     [<00000000ad02cf5e>] rtnl_newlink+0x4e/0x80 net/core/rtnetlink.c:3245
     [<00000000eceb53af>] rtnetlink_rcv_msg+0x178/0x4b0  
net/core/rtnetlink.c:5214
     [<00000000140451f6>] netlink_rcv_skb+0x61/0x170  
net/netlink/af_netlink.c:2482
     [<00000000237e38f7>] rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5232
     [<000000000d47c000>] netlink_unicast_kernel  
net/netlink/af_netlink.c:1307 [inline]
     [<000000000d47c000>] netlink_unicast+0x1ec/0x2d0  
net/netlink/af_netlink.c:1333
     [<0000000098503d79>] netlink_sendmsg+0x26a/0x480  
net/netlink/af_netlink.c:1922
     [<000000009263e868>] sock_sendmsg_nosec net/socket.c:646 [inline]
     [<000000009263e868>] sock_sendmsg+0x54/0x70 net/socket.c:665
     [<000000007791ad47>] __sys_sendto+0x148/0x1f0 net/socket.c:1958
     [<00000000d6f3807d>] __do_sys_sendto net/socket.c:1970 [inline]
     [<00000000d6f3807d>] __se_sys_sendto net/socket.c:1966 [inline]
     [<00000000d6f3807d>] __x64_sys_sendto+0x2a/0x30 net/socket.c:1966
     [<000000003ba31db7>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<0000000075c8daad>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



Tested on:

commit:         c11fb13a Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15c8f3b6a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb38d33cd06d8d48
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12477101a00000

