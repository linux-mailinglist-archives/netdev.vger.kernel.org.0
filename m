Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC28338B9
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 21:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFCTCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 15:02:08 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:52515 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFCTCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 15:02:08 -0400
Received: by mail-it1-f199.google.com with SMTP id z128so15897142itb.2
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 12:02:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jks4Xs48TY3j+e47+M/xmv4Td5kNNz0imsZd+eRJeoU=;
        b=n166BdqUTmc5J6Au+zmeDwtn2JpF/Alfh8G2gDZU2K33URS0GeDc6m1kureg0lmTjo
         wvXllMSEVZA3sI2rBhE+8kbXNpj4ThW1hTLPyepL3einAZeQyoNxnO6J7fOI/VR9wq/R
         q1UDdGPLlUAn4DByuWHpvCthNBdkFj3wu4COrqGs208EAih0xFardOo+OKR3d+rzbEDF
         a4H6YBEBHMiPwN0o7R1H7crSt/Ft5RdyVQ+iYbzPtZGD76+rvzWybAMMjY47K94ProIf
         Z+f8EyknXzGuMcZzcYmhZ3eh/mPwxlwV6HNJwqKpWc8yBasQ3PEafuhhTDkpnbSBUS+3
         EbZw==
X-Gm-Message-State: APjAAAVyFIZk7qa26vjlMQKXhCa6E5QuRJcmErFHClxxBHGYrW3VIgm2
        Wp3/elwl1T++8nZk+pNaiAOOS07QBTuzOXTINattpF+Z/jRo
X-Google-Smtp-Source: APXvYqzugOARmAo+pBm4wxcPDbtloRoamlzeTBq5L379nbJ8Sd9WWZjg0puuAB7bv8neVuAD9CXi0RM7UiQwMvt0B6Bgtymt+4pf
MIME-Version: 1.0
X-Received: by 2002:a5d:88c6:: with SMTP id i6mr3451086iol.107.1559588527344;
 Mon, 03 Jun 2019 12:02:07 -0700 (PDT)
Date:   Mon, 03 Jun 2019 12:02:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002b2262058a70001d@google.com>
Subject: memory leak in nf_hook_entries_grow
From:   syzbot <syzbot+722da59ccb264bc19910@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    3ab4436f Merge tag 'nfsd-5.2-1' of git://linux-nfs.org/~bf..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15feaf82a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=50393f7bfe444ff6
dashboard link: https://syzkaller.appspot.com/bug?extid=722da59ccb264bc19910
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f02772a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1657b80ea00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+722da59ccb264bc19910@syzkaller.appspotmail.com

035][ T7273] IPVS: ftp: loaded support on port[0] = 21
BUG: memory leak
unreferenced object 0xffff88810acd8a80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 22.250s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
     00 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff8881065de500 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 22.250s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 e0 8a bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 90 76 bb 82 ff ff ff ff  .........v......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff888103533c80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950626 (age 21.590s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 70 77 bb 82 ff ff ff ff  ........pw......
     00 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000343067d2>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<0000000004051f14>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<00000000f74d14d1>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<00000000de019d2a>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000fbdf13a9>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7089
     [<00000000ff82a3bf>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<000000008a424b95>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff88810acd8a80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 23.590s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
     00 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff8881065de500 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 23.590s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 e0 8a bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 90 76 bb 82 ff ff ff ff  .........v......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff888103533c80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950626 (age 22.930s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 70 77 bb 82 ff ff ff ff  ........pw......
     00 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000343067d2>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<0000000004051f14>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<00000000f74d14d1>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<00000000de019d2a>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000fbdf13a9>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7089
     [<00000000ff82a3bf>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<000000008a424b95>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff88810acd8a80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 24.970s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
     00 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff8881065de500 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 24.970s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 e0 8a bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 90 76 bb 82 ff ff ff ff  .........v......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff888103533c80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950626 (age 24.310s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 70 77 bb 82 ff ff ff ff  ........pw......
     00 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000343067d2>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<0000000004051f14>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<00000000f74d14d1>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<00000000de019d2a>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000fbdf13a9>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7089
     [<00000000ff82a3bf>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<000000008a424b95>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff88810acd8a80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 26.290s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
     00 00 00 00 00 00 00 00 00 77 bb 82 ff ff ff ff  .........w......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff8881065de500 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950560 (age 26.290s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 e0 8a bb 82 ff ff ff ff  ................
     00 00 00 00 00 00 00 00 90 76 bb 82 ff ff ff ff  .........v......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000e8abe142>] nf_hook_entries_grow+0xae/0x270  
net/netfilter/core.c:128
     [<000000004b94797c>] __nf_register_net_hook+0x9a/0x170  
net/netfilter/core.c:337
     [<00000000d1545cbc>] nf_register_net_hook+0x34/0xc0  
net/netfilter/core.c:464
     [<00000000876c9b55>] nf_register_net_hooks+0x53/0xc0  
net/netfilter/core.c:480
     [<000000002ea868e0>] __ip_vs_init+0xe8/0x170  
net/netfilter/ipvs/ip_vs_core.c:2280
     [<000000002eb2d451>] ops_init+0x4c/0x140 net/core/net_namespace.c:130
     [<000000000284ec48>] setup_net+0xde/0x230 net/core/net_namespace.c:316
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

BUG: memory leak
unreferenced object 0xffff888103533c80 (size 96):
   comm "syz-executor073", pid 7254, jiffies 4294950626 (age 25.640s)
   hex dump (first 32 bytes):
     02 00 00 00 00 00 00 00 70 77 bb 82 ff ff ff ff  ........pw......
     00 00 00 00 00 00 00 00 50 8b bb 82 ff ff ff ff  ........P.......
   backtrace:
     [<0000000013db61f1>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000013db61f1>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000013db61f1>] slab_alloc_node mm/slab.c:3269 [inline]
     [<0000000013db61f1>] kmem_cache_alloc_node_trace+0x15b/0x2a0  
mm/slab.c:3597
     [<000000001a27307d>] __do_kmalloc_node mm/slab.c:3619 [inline]
     [<000000001a27307d>] __kmalloc_node+0x38/0x50 mm/slab.c:3627
     [<0000000025054add>] kmalloc_node include/linux/slab.h:590 [inline]
     [<0000000025054add>] kvmalloc_node+0x4a/0xd0 mm/util.c:431
     [<0000000050d1bc00>] kvmalloc include/linux/mm.h:637 [inline]
     [<0000000050d1bc00>] kvzalloc include/linux/mm.h:645 [inline]
     [<0000000050d1bc00>] allocate_hook_entries_size+0x3b/0x60  
net/netfilter/core.c:61
     [<00000000343067d2>] __nf_hook_entries_try_shrink+0xbd/0x190  
net/netfilter/core.c:248
     [<0000000004051f14>] __nf_unregister_net_hook+0x12f/0x1b0  
net/netfilter/core.c:416
     [<00000000f74d14d1>] nf_unregister_net_hook+0x32/0x70  
net/netfilter/core.c:431
     [<00000000de019d2a>] nf_unregister_net_hooks+0x3d/0x50  
net/netfilter/core.c:499
     [<00000000fbdf13a9>] selinux_nf_unregister+0x22/0x30  
security/selinux/hooks.c:7089
     [<00000000ff82a3bf>] ops_exit_list.isra.0+0x4c/0x80  
net/core/net_namespace.c:154
     [<000000008a424b95>] setup_net+0x14a/0x230 net/core/net_namespace.c:333
     [<00000000a70600fa>] copy_net_ns+0xf0/0x1e0 net/core/net_namespace.c:439
     [<00000000ff26c15e>] create_new_namespaces+0x141/0x2a0  
kernel/nsproxy.c:107
     [<00000000b103dc79>] copy_namespaces+0xa1/0xe0 kernel/nsproxy.c:165
     [<000000007cc008a2>] copy_process.part.0+0x11fd/0x2150  
kernel/fork.c:2035
     [<00000000c344af7c>] copy_process kernel/fork.c:1800 [inline]
     [<00000000c344af7c>] _do_fork+0x121/0x4f0 kernel/fork.c:2369

executing program
executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
