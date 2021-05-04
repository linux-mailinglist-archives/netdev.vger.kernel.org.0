Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B276372723
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 10:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhEDIZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 04:25:18 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42513 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhEDIZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 04:25:16 -0400
Received: by mail-io1-f71.google.com with SMTP id v3-20020a5d90430000b02903da4a3efc9dso5130929ioq.9
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 01:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=rZlQiT/EvKC5TRiLPOyAwlgSL8LRkj9ewxAB0Hzy/rk=;
        b=LzgwmlZh2bp6rZovZ29Ogv7Gau+X7SEhwXSMWYK579WwSvCnqdZsHTXg1lvioBASPQ
         3pgGS2rx7j6GyG5sV0X93bFf0hQS/HoqAAGNnAWjp7EPSUzOv/00gewCFsy+YnHs2L33
         3Q4Jx6KIJTShXMQq7Et1pZ2ynACugb9tPYl6SyP4ewIR7SUnuUs0MH5BZSmTPew1J7vg
         MOlJtycmi0GrLHQnAdPryZg9FljIDyUNzpxGLV1hcj29hJF3skA9VwZYcoZZpdtUNFor
         9d48eJsOjTgjlr+CytR929vxhU/+QcvxzL8X/vYvP4dXqtlQSvn2ni+8V7UEnlFaGSFu
         WR1Q==
X-Gm-Message-State: AOAM533sndYeepmGhjyiDoK+W5M/zZFfNSl2AqATuMStDLCIEESjFCpZ
        L1oyV8TH+i7LcFBqjxxQl8f/r6/QduN4I1pi1qrBYRjK58Ku
X-Google-Smtp-Source: ABdhPJyjyrSuUspM5PohO9rQtij0Hvr4obsC0k4FNLbKTGZrGlW32p95ixipMcEpMBKBmN4gHw+v+v89CHQcsRI76qkeu8/vMf1x
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c2:: with SMTP id 2mr20846657ilq.120.1620116660425;
 Tue, 04 May 2021 01:24:20 -0700 (PDT)
Date:   Tue, 04 May 2021 01:24:20 -0700
In-Reply-To: <0000000000001d488205c1702d78@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000a17bf05c17cceed@google.com>
Subject: Re: [syzbot] memory leak in nf_hook_entries_grow (2)
From:   syzbot <syzbot+050de9f900eb45b94ef9@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    5e321ded Merge tag 'for-5.13/parisc' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13f88f43d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=38b336f6420141fd
dashboard link: https://syzkaller.appspot.com/bug?extid=050de9f900eb45b94ef9
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113d2ca5d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167fa069d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+050de9f900eb45b94ef9@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88811bef9340 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 28.900s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 00 b2 ed 1b 81 88 ff ff  ..B.............
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811c525e80 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 28.900s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 50 b2 ed 1b 81 88 ff ff  ..B.....P.......
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811bef9340 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 28.980s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 00 b2 ed 1b 81 88 ff ff  ..B.............
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811c525e80 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 28.980s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 50 b2 ed 1b 81 88 ff ff  ..B.....P.......
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811bef9340 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.060s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 00 b2 ed 1b 81 88 ff ff  ..B.............
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811c525e80 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.060s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 50 b2 ed 1b 81 88 ff ff  ..B.....P.......
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811bef9340 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.130s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 00 b2 ed 1b 81 88 ff ff  ..B.............
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811c525e80 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.130s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 50 b2 ed 1b 81 88 ff ff  ..B.....P.......
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811bef9340 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.210s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 00 b2 ed 1b 81 88 ff ff  ..B.............
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811c525e80 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.210s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 50 b2 ed 1b 81 88 ff ff  ..B.....P.......
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811bef9340 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.290s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 00 b2 ed 1b 81 88 ff ff  ..B.............
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811c525e80 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.290s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 50 b2 ed 1b 81 88 ff ff  ..B.....P.......
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811bef9340 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.370s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 00 b2 ed 1b 81 88 ff ff  ..B.............
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

BUG: memory leak
unreferenced object 0xffff88811c525e80 (size 64):
  comm "syz-executor097", pid 8413, jiffies 4294971728 (age 29.370s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 20 a8 a5 83 ff ff ff ff  ........ .......
    80 ef 42 1c 81 88 ff ff 50 b2 ed 1b 81 88 ff ff  ..B.....P.......
  backtrace:
    [<ffffffff8146f731>] kmalloc_node include/linux/slab.h:579 [inline]
    [<ffffffff8146f731>] kvmalloc_node+0x61/0xf0 mm/util.c:587
    [<ffffffff8381dc4b>] kvmalloc include/linux/mm.h:797 [inline]
    [<ffffffff8381dc4b>] kvzalloc include/linux/mm.h:805 [inline]
    [<ffffffff8381dc4b>] allocate_hook_entries_size net/netfilter/core.c:61 [inline]
    [<ffffffff8381dc4b>] nf_hook_entries_grow+0x31b/0x370 net/netfilter/core.c:128
    [<ffffffff8381dfad>] __nf_register_net_hook+0x8d/0x290 net/netfilter/core.c:407
    [<ffffffff8381e26f>] nf_register_net_hook+0xbf/0x100 net/netfilter/core.c:541
    [<ffffffff8381e309>] nf_register_net_hooks+0x59/0xc0 net/netfilter/core.c:557
    [<ffffffff83a58262>] arpt_register_table+0x152/0x1e0 net/ipv4/netfilter/arp_tables.c:1548
    [<ffffffff83a5a88d>] arptable_filter_table_init+0x3d/0x60 net/ipv4/netfilter/arptable_filter.c:50
    [<ffffffff838ba3b9>] xt_find_table_lock+0x189/0x290 net/netfilter/x_tables.c:1244
    [<ffffffff838ba4e7>] xt_request_find_table_lock+0x27/0xb0 net/netfilter/x_tables.c:1275
    [<ffffffff83a593c2>] get_info+0xd2/0x430 net/ipv4/netfilter/arp_tables.c:807
    [<ffffffff83a59944>] do_arpt_get_ctl+0x224/0x520 net/ipv4/netfilter/arp_tables.c:1443
    [<ffffffff838201c7>] nf_getsockopt+0x57/0x80 net/netfilter/nf_sockopt.c:116
    [<ffffffff839889aa>] ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
    [<ffffffff839889aa>] ip_getsockopt+0xfa/0x140 net/ipv4/ip_sockglue.c:1756
    [<ffffffff8399ce7b>] tcp_getsockopt+0x4b/0x80 net/ipv4/tcp.c:4251
    [<ffffffff8366fa03>] __sys_getsockopt+0x133/0x2f0 net/socket.c:2161
    [<ffffffff8366fbe2>] __do_sys_getsockopt net/socket.c:2176 [inline]
    [<ffffffff8366fbe2>] __se_sys_getsockopt net/socket.c:2173 [inline]
    [<ffffffff8366fbe2>] __x64_sys_getsockopt+0x22/0x30 net/socket.c:2173

write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory

