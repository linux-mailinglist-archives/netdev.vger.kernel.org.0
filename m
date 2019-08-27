Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7495B9DDF2
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 08:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbfH0GaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 02:30:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40792 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbfH0GaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 02:30:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so17514864wrd.7;
        Mon, 26 Aug 2019 23:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E6xxabj5xEdSytr77jvup7HlkLTQA2aVxEU3QHIt5F0=;
        b=Ifz7reordRLXUDS6VzeUs66gZ8fALjxnlWK55LOukTLO9Jd8FtQbny6sQkD8paRnzM
         pWQPXAc9wGBbjB2L51prgbQ6L8qxKyzx4NH3irntva1GBOQtO0lLVFayt5sROLkf/BTH
         cd4yBv6Fq9QehWLb40qGOPvO97V5zlcYd6wyk9d7XkEsvNEmAxlqiIEh29za+dcUpAQu
         vr8EXyGrBuV7T36J+7qGHfX6HpiPFmZmnDQEuoSECRF5YkilILev2FQJ1OzM3awsXSxQ
         MhqQVcr1izXe4glnDI4NIl/CKn2AHtecRowyBjoG9/3cOidOK+BOD1A9ogVWYvEVXH4A
         26Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E6xxabj5xEdSytr77jvup7HlkLTQA2aVxEU3QHIt5F0=;
        b=J1jtOoMzE+JLePrhUR3jex9qpGRH/wiPyrjVDigdOyy0f2tpzgUZaGIXhoIKo2mAsm
         pZxJnuEzbXJdfo/fjHEVw1wXiBXhuTlQA1uS+hbJUVLxc6x3719jNVX5aikmRsqK4x+1
         fCaQ+MlcD6p5QR6w6CVgvo2lDxz3ie57k2WyOd962pQbN+jQ8S263cRbXU/tjhPhuEyf
         M+SHzeXnBr4T+fw1/Sb9uMuOfKOch1MjK4CNPPE+7mMtg3kw/rT6vAfmHTSGitDwYCM7
         wMKBL+95lVNZu4rZOIjGnmiIQcuR36CqPrdVDMS29/GhzjAbzvBRdDxtxeSCZNBQcb+C
         Ij1A==
X-Gm-Message-State: APjAAAVjnY1J/WpQG1IXOWVPOQNaZtzVqfjcY5gC18KLDBOaZkR3nRjg
        MZYpUoLPcXGtJmtgi1mK7SIDjBKEwABkReKboZ4+PYcQVEQ=
X-Google-Smtp-Source: APXvYqypJvqHJkLejWweqP5ynpKxnyxOTaxZrfg3/eBgtWkEZfwSb2W3W6sgDlE6cjV5znv4+HJosilkaEPvPwhdiOE=
X-Received: by 2002:adf:9083:: with SMTP id i3mr959494wri.330.1566887408319;
 Mon, 26 Aug 2019 23:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000afc64d0591084876@google.com>
In-Reply-To: <000000000000afc64d0591084876@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 27 Aug 2019 14:29:57 +0800
Message-ID: <CADvbK_dQk3hhqf5O3dXhRs=TQsXtz+ptzj9DuREj8MwSyQzfnQ@mail.gmail.com>
Subject: Re: KASAN: slab-out-of-bounds Read in sctp_inq_pop
To:     syzbot <syzbot+3ca06c5cb35ee3fc1f89@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 1:15 AM syzbot
<syzbot+3ca06c5cb35ee3fc1f89@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    9733a7c6 Add linux-next specific files for 20190823
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=143ec11e600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=f6c78a1438582bd1
> dashboard link: https://syzkaller.appspot.com/bug?extid=3ca06c5cb35ee3fc1f89
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+3ca06c5cb35ee3fc1f89@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in sctp_inq_pop+0xafd/0xd80
> net/sctp/inqueue.c:201
> Read of size 2 at addr ffff8880a4e37222 by task syz-executor.3/32407
>
> CPU: 1 PID: 32407 Comm: syz-executor.3 Not tainted 5.3.0-rc5-next-20190823
> #72
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>   print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
>   __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
>   kasan_report+0x12/0x17 mm/kasan/common.c:610
>   __asan_report_load2_noabort+0x14/0x20 mm/kasan/generic_report.c:130
>   sctp_inq_pop+0xafd/0xd80 net/sctp/inqueue.c:201
>   sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:335
>   sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
>   sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
>   sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
>   ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
>   ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
>   NF_HOOK include/linux/netfilter.h:305 [inline]
>   NF_HOOK include/linux/netfilter.h:299 [inline]
>   ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
>   dst_input include/net/dst.h:442 [inline]
>   ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
>   ip6_list_rcv_finish net/ipv6/ip6_input.c:118 [inline]
>   ip6_sublist_rcv+0x80c/0xcf0 net/ipv6/ip6_input.c:282
>   ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:316
>   __netif_receive_skb_list_ptype net/core/dev.c:5049 [inline]
>   __netif_receive_skb_list_core+0x1a2/0x9d0 net/core/dev.c:5087
>   __netif_receive_skb_list net/core/dev.c:5149 [inline]
>   netif_receive_skb_list_internal+0x7eb/0xe60 net/core/dev.c:5244
>   gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5757
>   gro_normal_list net/core/dev.c:5755 [inline]
>   gro_normal_one net/core/dev.c:5769 [inline]
>   napi_frags_finish net/core/dev.c:5782 [inline]
>   napi_gro_frags+0xa6a/0xea0 net/core/dev.c:5855
>   tun_get_user+0x2e98/0x3fa0 drivers/net/tun.c:1974
>   tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020
>   call_write_iter include/linux/fs.h:1890 [inline]
>   do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
>   do_iter_write fs/read_write.c:976 [inline]
>   do_iter_write+0x17b/0x380 fs/read_write.c:957
>   vfs_writev+0x1b3/0x2f0 fs/read_write.c:1021
>   do_writev+0x15b/0x330 fs/read_write.c:1064
>   __do_sys_writev fs/read_write.c:1137 [inline]
>   __se_sys_writev fs/read_write.c:1134 [inline]
>   __x64_sys_writev+0x75/0xb0 fs/read_write.c:1134
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x459731
> Code: 75 14 b8 14 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 34 b9 fb ff c3 48
> 83 ec 08 e8 fa 2c 00 00 48 89 04 24 b8 14 00 00 00 0f 05 <48> 8b 3c 24 48
> 89 c2 e8 43 2d 00 00 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:00007fb4cd361ba0 EFLAGS: 00000293 ORIG_RAX: 0000000000000014
> RAX: ffffffffffffffda RBX: 000000000000002a RCX: 0000000000459731
> RDX: 0000000000000001 RSI: 00007fb4cd361c00 RDI: 00000000000000f0
> RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000293 R12: 00007fb4cd3626d4
> R13: 00000000004c87e3 R14: 00000000004df640 R15: 00000000ffffffff
>
> Allocated by task 32407:
>   save_stack+0x23/0x90 mm/kasan/common.c:69
>   set_track mm/kasan/common.c:77 [inline]
>   __kasan_kmalloc mm/kasan/common.c:486 [inline]
>   __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:459
>   kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:494
>   slab_post_alloc_hook mm/slab.h:584 [inline]
>   slab_alloc mm/slab.c:3319 [inline]
>   kmem_cache_alloc+0x121/0x710 mm/slab.c:3483
>   __build_skb+0x26/0x70 net/core/skbuff.c:310
>   __napi_alloc_skb+0x1d2/0x300 net/core/skbuff.c:523
>   napi_alloc_skb include/linux/skbuff.h:2801 [inline]
>   napi_get_frags net/core/dev.c:5742 [inline]
>   napi_get_frags+0x65/0x140 net/core/dev.c:5737
>   tun_napi_alloc_frags drivers/net/tun.c:1473 [inline]
>   tun_get_user+0x16bd/0x3fa0 drivers/net/tun.c:1834
>   tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020
>   call_write_iter include/linux/fs.h:1890 [inline]
>   do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
>   do_iter_write fs/read_write.c:976 [inline]
>   do_iter_write+0x17b/0x380 fs/read_write.c:957
>   vfs_writev+0x1b3/0x2f0 fs/read_write.c:1021
>   do_writev+0x15b/0x330 fs/read_write.c:1064
>   __do_sys_writev fs/read_write.c:1137 [inline]
>   __se_sys_writev fs/read_write.c:1134 [inline]
>   __x64_sys_writev+0x75/0xb0 fs/read_write.c:1134
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> Freed by task 3891:
>   save_stack+0x23/0x90 mm/kasan/common.c:69
>   set_track mm/kasan/common.c:77 [inline]
>   __kasan_slab_free+0x102/0x150 mm/kasan/common.c:448
>   kasan_slab_free+0xe/0x10 mm/kasan/common.c:456
>   __cache_free mm/slab.c:3425 [inline]
>   kmem_cache_free+0x86/0x320 mm/slab.c:3693
>   kfree_skbmem net/core/skbuff.c:623 [inline]
>   kfree_skbmem+0xc5/0x150 net/core/skbuff.c:617
>   __kfree_skb net/core/skbuff.c:680 [inline]
>   consume_skb net/core/skbuff.c:838 [inline]
>   consume_skb+0x103/0x3b0 net/core/skbuff.c:832
>   skb_free_datagram+0x1b/0x100 net/core/datagram.c:328
>   netlink_recvmsg+0x6c6/0xf50 net/netlink/af_netlink.c:1996
>   sock_recvmsg_nosec net/socket.c:871 [inline]
>   sock_recvmsg net/socket.c:889 [inline]
>   sock_recvmsg+0xce/0x110 net/socket.c:885
>   ___sys_recvmsg+0x271/0x5a0 net/socket.c:2480
>   __sys_recvmsg+0x102/0x1d0 net/socket.c:2537
>   __do_sys_recvmsg net/socket.c:2547 [inline]
>   __se_sys_recvmsg net/socket.c:2544 [inline]
>   __x64_sys_recvmsg+0x78/0xb0 net/socket.c:2544
>   do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> The buggy address belongs to the object at ffff8880a4e37140
>   which belongs to the cache skbuff_head_cache of size 224
> The buggy address is located 2 bytes to the right of
>   224-byte region [ffff8880a4e37140, ffff8880a4e37220)
> The buggy address belongs to the page:
> page:ffffea0002938dc0 refcount:1 mapcount:0 mapping:ffff88821b6a3a80
> index:0x0
> flags: 0x1fffc0000000200(slab)
> raw: 01fffc0000000200 ffffea000257fa88 ffffea00023a2008 ffff88821b6a3a80
> raw: 0000000000000000 ffff8880a4e37000 000000010000000c 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8880a4e37100: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
>   ffff8880a4e37180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > ffff8880a4e37200: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
>                                 ^
>   ffff8880a4e37280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8880a4e37300: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> ==================================================================
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
#syz fix: net: ipv6: fix listify ip6_rcv_finish in case of forwarding
