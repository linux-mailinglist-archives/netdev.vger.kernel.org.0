Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192652730FA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIURmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:42:25 -0400
Received: from mail-il1-f206.google.com ([209.85.166.206]:43859 "EHLO
        mail-il1-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbgIURmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:42:25 -0400
Received: by mail-il1-f206.google.com with SMTP id t11so11814002ilj.10
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 10:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OOT5zNSorcLtf3oJqiHdjxxvNPttwz+YE7f126UcXTs=;
        b=fxVennEBQz9HX5XdxGntXsrKl3i9IkFHOfzt5Vn/uY+AYaQDZ62B53MHSBOHBjrGK/
         LTUBrD4u1tXsP63oyCEMtEdIDeiltBzvNmHOLsVWG75/iSMbQ/5tPgRwoKDFl4N7ezLb
         CdeYyXKpLauLEQOekUB5rnuLAy+zkN2/1cITdPFb4r70Y+PyDoI8JAJXECDITQkAAoFU
         +FzsRlN41PHaHDjSgpAQxHvqWHElsxdtS0kPdWcLkPVNMh9q36OQFVOzMB2TPIcG838i
         gyiHsyXSi0+lUF5ga8DTu7jIqsCaM5lZB//7de4oUB6qifRyFa6yWW8QLHstAvZmml76
         DmGA==
X-Gm-Message-State: AOAM531Wky76B49GVtQajW1pU70tCBjx9p8r644kyUWHwnGwX6ulEirm
        Dqc6qLCfwruc3ffKU8RkzJ1KkFqYRYRj8IQi2Kfx0STxabst
X-Google-Smtp-Source: ABdhPJw90nB1dc1hMBHlOPxBXvQkmNoyCxcGsOYlAAG9SDlUGQHE7sYCXiQODBQMBjEOnnBtx4AJJ8Gi2kImRuYVC7LEh0abM3fP
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:dd3:: with SMTP id l19mr918971ilj.3.1600710144204;
 Mon, 21 Sep 2020 10:42:24 -0700 (PDT)
Date:   Mon, 21 Sep 2020 10:42:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000088a51d05afd65f93@google.com>
Subject: KMSAN: uninit-value in gc_worker (3)
From:   syzbot <syzbot+b3dbc715a0b6201346f4@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6c24608b Update README.md
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1292fd55900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ee5f7a0b2e48ed66
dashboard link: https://syzkaller.appspot.com/bug?extid=b3dbc715a0b6201346f4
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3dbc715a0b6201346f4@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in gc_worker+0x953/0x1740 net/netfilter/nf_conntrack_core.c:1389
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.8.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient gc_worker
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 gc_worker+0x953/0x1740 net/netfilter/nf_conntrack_core.c:1389
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

Uninit was created at:
 kmsan_save_stack_with_flags+0x3c/0x90 mm/kmsan/kmsan.c:144
 kmsan_internal_alloc_meta_for_pages mm/kmsan/kmsan_shadow.c:269 [inline]
 kmsan_alloc_page+0xc5/0x1a0 mm/kmsan/kmsan_shadow.c:293
 __alloc_pages_nodemask+0xdf0/0x1030 mm/page_alloc.c:4889
 alloc_pages_current+0x685/0xb50 mm/mempolicy.c:2292
 alloc_pages include/linux/gfp.h:545 [inline]
 alloc_slab_page+0x11c/0x1240 mm/slub.c:1560
 allocate_slab mm/slub.c:1705 [inline]
 new_slab+0x2bf/0x10c0 mm/slub.c:1771
 new_slab_objects mm/slub.c:2528 [inline]
 ___slab_alloc+0xcd3/0x18a0 mm/slub.c:2689
 __slab_alloc mm/slub.c:2729 [inline]
 slab_alloc_node mm/slub.c:2803 [inline]
 slab_alloc mm/slub.c:2848 [inline]
 kmem_cache_alloc+0xb70/0xc50 mm/slub.c:2853
 __nf_conntrack_alloc+0x1a9/0x790 net/netfilter/nf_conntrack_core.c:1509
 init_conntrack+0x3c2/0x2180 net/netfilter/nf_conntrack_core.c:1588
 resolve_normal_ct net/netfilter/nf_conntrack_core.c:1686 [inline]
 nf_conntrack_in+0x158a/0x2b10 net/netfilter/nf_conntrack_core.c:1846
 ipv6_conntrack_local+0x68/0x80 net/netfilter/nf_conntrack_proto.c:398
 nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
 nf_hook_slow+0x17b/0x460 net/netfilter/core.c:512
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0x2301/0x2b40 net/ipv6/ip6_output.c:280
 inet6_csk_xmit+0x47f/0x5a0 net/ipv6/inet6_connection_sock.c:135
 __tcp_transmit_skb+0x4b9e/0x5d70 net/ipv4/tcp_output.c:1240
 tcp_transmit_skb net/ipv4/tcp_output.c:1256 [inline]
 tcp_connect+0x153f/0x3bb0 net/ipv4/tcp_output.c:3673
 tcp_v6_connect+0x2be8/0x2d40 net/ipv6/tcp_ipv6.c:334
 __inet_stream_connect+0x14fe/0x16f0 net/ipv4/af_inet.c:658
 inet_stream_connect+0x101/0x180 net/ipv4/af_inet.c:722
 rds_tcp_conn_path_connect+0x93d/0xcc0 net/rds/tcp_connect.c:172
 rds_connect_worker+0x36b/0x550 net/rds/threads.c:176
 process_one_work+0x1688/0x2140 kernel/workqueue.c:2269
 worker_thread+0x10bc/0x2730 kernel/workqueue.c:2415
 kthread+0x551/0x590 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
