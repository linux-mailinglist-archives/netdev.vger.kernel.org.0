Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F2230D53
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 13:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfEaL24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 07:28:56 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36041 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfEaL2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 07:28:55 -0400
Received: by mail-io1-f68.google.com with SMTP id h6so7870862ioh.3
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 04:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X18idEV00OtQ11TyxgLtNbF7xc5UhiD1wmkoD1b0+zA=;
        b=iXjazTRqN7rQhPxw10oSs2ME3exBkZj7IJa7C+QbUqPJPIq81HkkBHAV3n4bwE+WK5
         axqyJQrhDs1ptszhcFzXr5oMsCesB6dxFP9pqpMSCU2Byl6yrAcOXk6nh/z2g+yKl+Xr
         Ij3R7Vt4efoMKaJ2CdEy2IAc9kcAiotuRLzml1KVehLMQyElORQBGxrXzNI+HQYbt7As
         yNF2317NKa3I9j3/OVW0WOH5xeeH3+7xuwPhhlnnhc6xEfEwqbosD8HvM72myO5uRpK7
         owhTbOstG315CwhFDSHwJybNQJOIMjLmeU3HTXYH0uNh+RxWMYm7AmMvXn8J+nxX6EF4
         qaNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X18idEV00OtQ11TyxgLtNbF7xc5UhiD1wmkoD1b0+zA=;
        b=ZMEF+enSRjJeZicjG4iDKnjRuKJ3H3261/OBGQfiqDvfiwBqwZTswvVC8kNWNWlMKO
         P+QOhL0YjE+xxGY2ekQt0hNFInnghXQR/UMsl/06Ubn7Gqu/Kd8zq/jXQ3/LGpmcf5yD
         BjGJN4+yjQR75K4MMRT4ogoupY0zSM3BVcwse3Z0SQx2l2axHCYBi3/5rfBc3+hvD8X5
         hbLH+xJQ22UjINu9Ys1ZUR3MTu57yhvFJLesdYbb79LFHYlN5q+xPBHeqiOB6TLzbnh4
         eCdAqKQtx+TC5k083Jt06M4VMqxr3FeBBOjCZP7xELRGttXQNTyoZTEewsAM7TShssKH
         kU0Q==
X-Gm-Message-State: APjAAAXzvJ+MKXp5r/4aapNYBnP0BbYQTSrdudbrWY1UbdIxlWK6mcCu
        7vt3sngVDS2QVXhzm0OpelC9ktnewUCooCrUyL4R2g==
X-Google-Smtp-Source: APXvYqyqw+YkVTin30WDBxod3mXzjUQPl47jL2eVvnk8HF67+g62iS7jL9T4KUNzAOmGVOfiIaRVab4Ggvf3RKZtEEE=
X-Received: by 2002:a6b:e711:: with SMTP id b17mr6259098ioh.3.1559302134239;
 Fri, 31 May 2019 04:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000047d84e058089773f@google.com> <CACT4Y+aKFM2Gi4mGVCSMZNv_20SAP2KhjnSZYmNr18va_bXv_Q@mail.gmail.com>
In-Reply-To: <CACT4Y+aKFM2Gi4mGVCSMZNv_20SAP2KhjnSZYmNr18va_bXv_Q@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 31 May 2019 13:28:41 +0200
Message-ID: <CACT4Y+ZJqTVyGX7G_RqPfP7PitGAsQF7zgTN2w1EevW=HCqCKw@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in br_mdb_ip_get
To:     syzbot <syzbot+8dfe5ee27aa6d2e396c2@syzkaller.appspotmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     bridge@lists.linux-foundation.org,
        David Miller <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 21, 2019 at 11:56 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Mon, Jan 28, 2019 at 8:13 PM syzbot
> <syzbot+8dfe5ee27aa6d2e396c2@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    02f2d5aea531 kmsan: (presumably) fix dma_map_page_attrs()
> > git tree:       kmsan
> > console output: https://syzkaller.appspot.com/x/log.txt?x=173a7310c00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=52c9737ec5618f82
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8dfe5ee27aa6d2e396c2
> > compiler:       clang version 8.0.0 (trunk 350509)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+8dfe5ee27aa6d2e396c2@syzkaller.appspotmail.com
>
>
> There is also a use-after-free reported at around the same stack:
> https://groups.google.com/forum/#!topic/syzkaller-bugs/8V7VqxxTEzc
> The question is: can these reports be related? One is root cause of another?
>
>
> > ==================================================================
> > BUG: KMSAN: uninit-value in __rhashtable_lookup
> > include/linux/rhashtable.h:505 [inline]
> > BUG: KMSAN: uninit-value in rhashtable_lookup
> > include/linux/rhashtable.h:534 [inline]
> > BUG: KMSAN: uninit-value in br_mdb_ip_get+0x52b/0x740
> > net/bridge/br_multicast.c:97
> > CPU: 0 PID: 11379 Comm: udevd Not tainted 5.0.0-rc1+ #7
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >   <IRQ>
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x173/0x1d0 lib/dump_stack.c:113
> >   kmsan_report+0x12e/0x2a0 mm/kmsan/kmsan.c:600
> >   __msan_warning+0x82/0xf0 mm/kmsan/kmsan_instr.c:313
> >   __rhashtable_lookup include/linux/rhashtable.h:505 [inline]
> >   rhashtable_lookup include/linux/rhashtable.h:534 [inline]
> >   br_mdb_ip_get+0x52b/0x740 net/bridge/br_multicast.c:97
> >   br_multicast_new_group+0xa7/0x1640 net/bridge/br_multicast.c:467
> >   br_multicast_add_group+0x242/0xf00 net/bridge/br_multicast.c:552
> >   br_ip4_multicast_add_group net/bridge/br_multicast.c:606 [inline]
> >   br_ip4_multicast_igmp3_report net/bridge/br_multicast.c:972 [inline]
> >   br_multicast_ipv4_rcv net/bridge/br_multicast.c:1615 [inline]
> >   br_multicast_rcv+0x3a88/0x6560 net/bridge/br_multicast.c:1701
> >   br_dev_xmit+0xbc5/0x16a0 net/bridge/br_device.c:93
> >   __netdev_start_xmit include/linux/netdevice.h:4382 [inline]
> >   netdev_start_xmit include/linux/netdevice.h:4391 [inline]
> >   xmit_one net/core/dev.c:3278 [inline]
> >   dev_hard_start_xmit+0x604/0xc40 net/core/dev.c:3294
> >   __dev_queue_xmit+0x2e48/0x3b80 net/core/dev.c:3864
> >   dev_queue_xmit+0x4b/0x60 net/core/dev.c:3897
> >   neigh_hh_output include/net/neighbour.h:498 [inline]
> >   neigh_output include/net/neighbour.h:506 [inline]
> >   ip_finish_output2+0x156d/0x1820 net/ipv4/ip_output.c:229
> >   ip_finish_output+0xd2b/0xfd0 net/ipv4/ip_output.c:317
> >   NF_HOOK_COND include/linux/netfilter.h:278 [inline]
> >   ip_output+0x53f/0x610 net/ipv4/ip_output.c:405
> >   dst_output include/net/dst.h:444 [inline]
> >   ip_local_out+0x164/0x1d0 net/ipv4/ip_output.c:124
> >   igmpv3_sendpack net/ipv4/igmp.c:417 [inline]
> >   igmpv3_send_cr net/ipv4/igmp.c:705 [inline]
> >   igmp_ifc_timer_expire+0x12cb/0x1aa0 net/ipv4/igmp.c:793
> >   call_timer_fn+0x285/0x600 kernel/time/timer.c:1325
> >   expire_timers kernel/time/timer.c:1362 [inline]
> >   __run_timers+0xdb4/0x11d0 kernel/time/timer.c:1681
> >   run_timer_softirq+0x2e/0x50 kernel/time/timer.c:1694
> >   __do_softirq+0x53f/0x93a kernel/softirq.c:293
> >   invoke_softirq kernel/softirq.c:375 [inline]
> >   irq_exit+0x214/0x250 kernel/softirq.c:416
> >   exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
> >   smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1064
> >   apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:814
> >   </IRQ>
> > RIP: 0010:__msan_chain_origin+0x93/0xe0 mm/kmsan/kmsan_instr.c:201
> > Code: 89 f7 e8 f0 e0 ff ff 89 c3 65 ff 0c 25 04 90 03 00 65 8b 04 25 04 90
> > 03 00 85 c0 75 30 e8 f5 a2 3f ff 4c 89 7d d0 ff 75 d0 9d <65> 48 8b 04 25
> > 28 00 00 00 48 3b 45 e0 75 0d 89 d8 48 83 c4 18 5b
> > RSP: 0018:ffff8880a53cf6f0 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> > RAX: 0000000000000000 RBX: 00000000a06000af RCX: c7641d3373f0d000
> > RDX: 0000000000000003 RSI: 0000000000480020 RDI: 0000000085c0000c
> > RBP: ffff8880a53cf720 R08: 0000000000000003 R09: ffff8880a53cf4ac
> > R10: ffffffff8ae01788 R11: 0000000000000000 R12: ffff8880a53cfcd0
> > R13: ffff8880a53cfcc8 R14: 0000000085c0000c R15: 0000000000000246
> >   step_into+0x70c/0x1b90 fs/namei.c:1778
> >   walk_component+0x1d0/0xba0 fs/namei.c:1829
> >   link_path_walk+0xa9e/0x2160 fs/namei.c:2135
> >   path_openat+0x30e/0x6b90 fs/namei.c:3533
> >   do_filp_open+0x2b8/0x710 fs/namei.c:3564
> >   do_sys_open+0x642/0xa30 fs/open.c:1063
> >   __do_sys_open fs/open.c:1081 [inline]
> >   __se_sys_open+0xad/0xc0 fs/open.c:1076
> >   __x64_sys_open+0x4a/0x70 fs/open.c:1076
> >   do_syscall_64+0xbc/0xf0 arch/x86/entry/common.c:291
> >   entry_SYSCALL_64_after_hwframe+0x63/0xe7
> > RIP: 0033:0x7f4526cc5120
> > Code: 48 8b 15 1b 4d 2b 00 f7 d8 64 89 02 83 c8 ff c3 90 90 90 90 90 90 90
> > 90 90 90 83 3d d5 a4 2b 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff
> > ff 73 31 c3 48 83 ec 08 e8 5e 8c 01 00 48 89 04 24
> > RSP: 002b:00007ffdb010be48 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> > RAX: ffffffffffffffda RBX: 0000000000ee2fd0 RCX: 00007f4526cc5120
> > RDX: 00000000000001b6 RSI: 0000000000080000 RDI: 00007ffdb010bf20
> > RBP: 00007ffdb010bec0 R08: 0000000000000008 R09: 0000000000000001
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000008
> > R13: 000000000041f57a R14: 0000000000ed3250 R15: 000000000000000b
> >
> > Local variable description: ----br_group.i.i@br_multicast_rcv
> > Variable was created at:
> >   br_multicast_rcv+0x1e7/0x6560 net/bridge/br_multicast.c:1690
> >   br_dev_xmit+0xbc5/0x16a0 net/bridge/br_device.c:93
> > ==================================================================


Nikolay seems to fix this with the following commit:

commit 1515a63fc413f160d20574ab0894e7f1020c7be2
Author: Nikolay Aleksandrov
Date:   Wed Apr 3 23:27:24 2019 +0300
    net: bridge: always clear mcast matching struct on reports and leaves

Let's close the bug:

#syz fix:
net: bridge: always clear mcast matching struct on reports and leaves
