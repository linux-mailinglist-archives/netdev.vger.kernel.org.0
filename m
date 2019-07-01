Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF1F5B44D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 07:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfGAFkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 01:40:02 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:42286 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfGAFkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 01:40:01 -0400
Received: by mail-io1-f69.google.com with SMTP id f22so14023977ioj.9
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 22:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ptsMXgNaVhslud9hqVayVuxLWUP4eJpRRHdiW1OrvIE=;
        b=uVGO0HhBw1nBTWdlvitRLvjmSf1BjIxHwzU4MJHIQyLNLcqU3coj3Ung9qrTt/nKh7
         AQxAulxwCEzB5XKcOashoA10u2QioIMOZ+xWhNL/zQTLewAvvnKCciPaAs1HE/2TP9/H
         WpzX/GC+InXqYgsRgK6O8CyKg/s7bV7W0Wbknc9de/y/zGb1HWLGiV15Wm7oZCKodtIf
         WzVShzk9AbNQZPxyCL+UjSq5VlYhPtzJ6pq1nNLivE/IHDHRa75efm730bba3+5rUfIi
         1jSOm/v2oqG0e2t4zqK4HTRN4e1UURmALd8LDdPVthKi1ekvS4uJywceSI7h11sl4hyc
         V+tw==
X-Gm-Message-State: APjAAAXOODTk/Y4rKL/GWS1mjwNW0S/A9U39JIP8BoeyOL/7YP/dHSjX
        jQZIZr8RNapRIDX3SUEONRtd5qqkT40Et+EF44c9yk4XwIrg
X-Google-Smtp-Source: APXvYqx4h2M+CVjiTqKY30se1fgbpSi69aMuAdEwcUB+0tkIGtLUtx/ZujFOHRNGIzM+gtR6Hsrz+GIyDcu5efl/FlABcSYjUPA2
MIME-Version: 1.0
X-Received: by 2002:a6b:f406:: with SMTP id i6mr23856819iog.110.1561959600575;
 Sun, 30 Jun 2019 22:40:00 -0700 (PDT)
Date:   Sun, 30 Jun 2019 22:40:00 -0700
In-Reply-To: <5d1999ff323f_18a42abda71925b4cf@john-XPS-13-9370.notmuch>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000255dbd058c980f22@google.com>
Subject: Re: memory leak in create_ctx
From:   syzbot <syzbot+06537213db7ba2745c4a@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
memory leak in create_ctx

2019/07/01 05:38:26 executed programs: 23
BUG: memory leak
unreferenced object 0xffff888102914e00 (size 512):
   comm "syz-executor.4", pid 7333, jiffies 4294944085 (age 13.950s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000002f2bb8be>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000002f2bb8be>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002f2bb8be>] slab_alloc mm/slab.c:3326 [inline]
     [<000000002f2bb8be>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000b76aef16>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000b76aef16>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000b76aef16>] create_ctx+0x25/0x70 net/tls/tls_main.c:648
     [<00000000dc9c9d2e>] tls_init net/tls/tls_main.c:837 [inline]
     [<00000000dc9c9d2e>] tls_init+0x97/0x1f0 net/tls/tls_main.c:819
     [<000000009d663c39>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
     [<000000009d663c39>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
     [<00000000551f7621>] do_tcp_setsockopt.isra.0+0x19a/0xd60  
net/ipv4/tcp.c:2789
     [<00000000d02c41d7>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3103
     [<0000000085d221c1>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3129
     [<00000000d294eeda>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
     [<00000000f1f1d607>] __do_sys_setsockopt net/socket.c:2083 [inline]
     [<00000000f1f1d607>] __se_sys_setsockopt net/socket.c:2080 [inline]
     [<00000000f1f1d607>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
     [<00000000fbd4f794>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007383b736>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff888103860c00 (size 512):
   comm "syz-executor.0", pid 7342, jiffies 4294944115 (age 13.650s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000002f2bb8be>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000002f2bb8be>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002f2bb8be>] slab_alloc mm/slab.c:3326 [inline]
     [<000000002f2bb8be>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000b76aef16>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000b76aef16>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000b76aef16>] create_ctx+0x25/0x70 net/tls/tls_main.c:648
     [<00000000dc9c9d2e>] tls_init net/tls/tls_main.c:837 [inline]
     [<00000000dc9c9d2e>] tls_init+0x97/0x1f0 net/tls/tls_main.c:819
     [<000000009d663c39>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
     [<000000009d663c39>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
     [<00000000551f7621>] do_tcp_setsockopt.isra.0+0x19a/0xd60  
net/ipv4/tcp.c:2789
     [<00000000d02c41d7>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3103
     [<0000000085d221c1>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3129
     [<00000000d294eeda>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
     [<00000000f1f1d607>] __do_sys_setsockopt net/socket.c:2083 [inline]
     [<00000000f1f1d607>] __se_sys_setsockopt net/socket.c:2080 [inline]
     [<00000000f1f1d607>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
     [<00000000fbd4f794>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007383b736>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810e3e1c00 (size 512):
   comm "syz-executor.5", pid 7384, jiffies 4294944151 (age 13.290s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000002f2bb8be>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000002f2bb8be>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002f2bb8be>] slab_alloc mm/slab.c:3326 [inline]
     [<000000002f2bb8be>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000b76aef16>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000b76aef16>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000b76aef16>] create_ctx+0x25/0x70 net/tls/tls_main.c:648
     [<00000000dc9c9d2e>] tls_init net/tls/tls_main.c:837 [inline]
     [<00000000dc9c9d2e>] tls_init+0x97/0x1f0 net/tls/tls_main.c:819
     [<000000009d663c39>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
     [<000000009d663c39>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
     [<00000000551f7621>] do_tcp_setsockopt.isra.0+0x19a/0xd60  
net/ipv4/tcp.c:2789
     [<00000000d02c41d7>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3103
     [<0000000085d221c1>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3129
     [<00000000d294eeda>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
     [<00000000f1f1d607>] __do_sys_setsockopt net/socket.c:2083 [inline]
     [<00000000f1f1d607>] __se_sys_setsockopt net/socket.c:2080 [inline]
     [<00000000f1f1d607>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
     [<00000000fbd4f794>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007383b736>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811a0a7200 (size 512):
   comm "syz-executor.0", pid 7423, jiffies 4294944702 (age 7.780s)
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<000000002f2bb8be>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<000000002f2bb8be>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<000000002f2bb8be>] slab_alloc mm/slab.c:3326 [inline]
     [<000000002f2bb8be>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<00000000b76aef16>] kmalloc include/linux/slab.h:547 [inline]
     [<00000000b76aef16>] kzalloc include/linux/slab.h:742 [inline]
     [<00000000b76aef16>] create_ctx+0x25/0x70 net/tls/tls_main.c:648
     [<00000000dc9c9d2e>] tls_init net/tls/tls_main.c:837 [inline]
     [<00000000dc9c9d2e>] tls_init+0x97/0x1f0 net/tls/tls_main.c:819
     [<000000009d663c39>] __tcp_set_ulp net/ipv4/tcp_ulp.c:126 [inline]
     [<000000009d663c39>] tcp_set_ulp+0xe2/0x190 net/ipv4/tcp_ulp.c:147
     [<00000000551f7621>] do_tcp_setsockopt.isra.0+0x19a/0xd60  
net/ipv4/tcp.c:2789
     [<00000000d02c41d7>] tcp_setsockopt+0x71/0x80 net/ipv4/tcp.c:3103
     [<0000000085d221c1>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3129
     [<00000000d294eeda>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
     [<00000000f1f1d607>] __do_sys_setsockopt net/socket.c:2083 [inline]
     [<00000000f1f1d607>] __se_sys_setsockopt net/socket.c:2080 [inline]
     [<00000000f1f1d607>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
     [<00000000fbd4f794>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<000000007383b736>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



Tested on:

commit:         0b58d013 bpf: tls, implement unhash to avoid transition ou..
git tree:       git://github.com/cilium/linux ktls-unhash
console output: https://syzkaller.appspot.com/x/log.txt?x=134f2e0ba00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3bd5897d1df43b97
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

