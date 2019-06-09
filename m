Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0CDA3AB32
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 20:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbfFISoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 14:44:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41602 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbfFISoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 14:44:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so6925262wrm.8;
        Sun, 09 Jun 2019 11:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Da88wBTs9LOEdvHpH2F2PYZaKc1cITGuLPz23cQj6Ag=;
        b=h0Y28na4yaGSKJOIZYvb5yRmSHL+BSW5/OYxulXPUMGZozJHavvZTrcnT1OPF4U8Xb
         umOrC40tx/FkQ6BIWEoIW6cFcCuHFt8S5Io+8JXpkpr6Qr1PyQIoEcGLovmDDvzNymE9
         CNJ9L362LGrwzUBET0Ik8cvX+ULEqYFLBQ7lSKemj7wP8tejb8ylyOJxHrS49xgzKeEV
         UmFV0yhmm8j12+2kw/9EfsjhK6BPxEHAuuzov9g3kRMZ5f1FdQizLBPv4NQaY6WioHOz
         IENoLihYeZqjY7CvsE8ixOZrEwptSvpxzXUlSP+Kv+xVMr8uqxOENokQaQKPuWFoclei
         WeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Da88wBTs9LOEdvHpH2F2PYZaKc1cITGuLPz23cQj6Ag=;
        b=qYO1FKsExnHoWcuJAAUEGodAehTnudQ1FAXqvBzjadYL45jyAw5KnFR2qVe/k5yYFo
         H8t5r7UZUokoPNuFKYGJPU9c8NWVe13j1NUp1wBnQk4ukSHIMH9VXOav8ZpXtpsYrdJ9
         FUQacixyGD+yYwL0JZXf0g4VV2VhsUqdDk/EaTgKmQtFm84yeZ1ZDmivnMApq0xSULWg
         T1e+1EDYXRmigqAlvY6JYl1J1DEYbRvNzkF7tcUfwz9Thg8p5EmaYy/ZJ09l7LBluY05
         DXSibKP1epNE4C+SAAgDqYcsJgeXezXBh/dIOcDTn6z4Od/yo2DYB8zRjN8AlIT7AzPJ
         AUaQ==
X-Gm-Message-State: APjAAAVNe7waNj9xO6PNOtM48Z6kzPJZuAxzDztu2N2K67mYCpqaimgS
        daIrrOO/Jx8hJbp/km0Ku2R+Za7Ub71Z9zsUXoXgFdDI
X-Google-Smtp-Source: APXvYqwp9fw8BNZ8G6/ahEMiAGVzOVt0NDgzKLcIgA+sQlsmmP6spzQBpRXteWAuZFWqs8Nl83+DjDIokSPKvT0A4h4=
X-Received: by 2002:adf:fb81:: with SMTP id a1mr2702407wrr.329.1560105881662;
 Sun, 09 Jun 2019 11:44:41 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000000c060589a8bc66@google.com>
In-Reply-To: <000000000000000c060589a8bc66@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 10 Jun 2019 02:44:30 +0800
Message-ID: <CADvbK_cMohjd3U=8H8ECT74rK85Tjy1FZYAXQQ_CsWgFq3c5gA@mail.gmail.com>
Subject: Re: memory leak in tipc_buf_acquire
To:     syzbot <syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com>
Cc:     davem <davem@davemloft.net>, Jon Maloy <jon.maloy@ericsson.com>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 5:18 AM syzbot
<syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    4dde821e Merge tag 'xfs-5.2-fixes-1' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=107db73aa00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=61dd9e15a761691d
> dashboard link: https://syzkaller.appspot.com/bug?extid=78fbe679c8ca8d264a8d
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162bd84ca00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=160c605ca00000
>
Looks we need to purge each member's deferredq list in tipc_group_delete():
diff --git a/net/tipc/group.c b/net/tipc/group.c
index 992be61..23823eb 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -218,6 +218,7 @@ void tipc_group_delete(struct net *net, struct
tipc_group *grp)

  rbtree_postorder_for_each_entry_safe(m, tmp, tree, tree_node) {
  tipc_group_proto_xmit(grp, m, GRP_LEAVE_MSG, &xmitq);
+ __skb_queue_purge(&m->deferredq);
  list_del(&m->list);
  kfree(m);
  }

> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com
>
> type=1400 audit(1558701681.775:36): avc:  denied  { map } for  pid=7128
> comm="syz-executor987" path="/root/syz-executor987656147" dev="sda1"
> ino=15900 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> executing program
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810df83c00 (size 512):
>    comm "softirq", pid 0, jiffies 4294942354 (age 19.830s)
>    hex dump (first 32 bytes):
>      38 1a 0d 0f 81 88 ff ff 38 1a 0d 0f 81 88 ff ff  8.......8.......
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<000000009375ee42>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>      [<000000009375ee42>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<000000009375ee42>] slab_alloc_node mm/slab.c:3269 [inline]
>      [<000000009375ee42>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
>      [<000000004c563922>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
>      [<00000000ec87bfa1>] alloc_skb_fclone include/linux/skbuff.h:1107
> [inline]
>      [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80 net/tipc/msg.c:66
>      [<00000000d151ef84>] tipc_msg_create+0x37/0xe0 net/tipc/msg.c:98
>      [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0
> net/tipc/group.c:679
>      [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640
> net/tipc/group.c:781
>      [<00000000b75ab039>] tipc_sk_proto_rcv net/tipc/socket.c:1996 [inline]
>      [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20
> net/tipc/socket.c:2163
>      [<000000000dab7a6c>] tipc_sk_enqueue net/tipc/socket.c:2255 [inline]
>      [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0 net/tipc/socket.c:2306
>      [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0 net/tipc/node.c:1442
>      [<00000000337dd9eb>] tipc_node_xmit_skb net/tipc/node.c:1491 [inline]
>      [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120
> net/tipc/node.c:1506
>      [<00000000b6375182>] tipc_group_delete+0xe6/0x130 net/tipc/group.c:224
>      [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0 net/tipc/socket.c:2925
>      [<000000009df90505>] tipc_release+0x7b/0x5e0 net/tipc/socket.c:584
>      [<000000009f3189da>] __sock_release+0x4b/0xe0 net/socket.c:607
>      [<00000000d3568ee0>] sock_close+0x1b/0x30 net/socket.c:1279
>      [<00000000266a6215>] __fput+0xed/0x300 fs/file_table.c:280
>
> BUG: memory leak
> unreferenced object 0xffff888111895400 (size 1024):
>    comm "softirq", pid 0, jiffies 4294942354 (age 19.830s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000e2e2855e>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>      [<00000000e2e2855e>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<00000000e2e2855e>] slab_alloc_node mm/slab.c:3269 [inline]
>      [<00000000e2e2855e>] kmem_cache_alloc_node_trace+0x15b/0x2a0
> mm/slab.c:3597
>      [<00000000a5030ce7>] __do_kmalloc_node mm/slab.c:3619 [inline]
>      [<00000000a5030ce7>] __kmalloc_node_track_caller+0x38/0x50
> mm/slab.c:3634
>      [<0000000039212451>] __kmalloc_reserve.isra.0+0x40/0xb0
> net/core/skbuff.c:142
>      [<00000000307cb4cf>] __alloc_skb+0xa0/0x210 net/core/skbuff.c:210
>      [<00000000ec87bfa1>] alloc_skb_fclone include/linux/skbuff.h:1107
> [inline]
>      [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80 net/tipc/msg.c:66
>      [<00000000d151ef84>] tipc_msg_create+0x37/0xe0 net/tipc/msg.c:98
>      [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0
> net/tipc/group.c:679
>      [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640
> net/tipc/group.c:781
>      [<00000000b75ab039>] tipc_sk_proto_rcv net/tipc/socket.c:1996 [inline]
>      [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20
> net/tipc/socket.c:2163
>      [<000000000dab7a6c>] tipc_sk_enqueue net/tipc/socket.c:2255 [inline]
>      [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0 net/tipc/socket.c:2306
>      [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0 net/tipc/node.c:1442
>      [<00000000337dd9eb>] tipc_node_xmit_skb net/tipc/node.c:1491 [inline]
>      [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120
> net/tipc/node.c:1506
>      [<00000000b6375182>] tipc_group_delete+0xe6/0x130 net/tipc/group.c:224
>      [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0 net/tipc/socket.c:2925
>      [<000000009df90505>] tipc_release+0x7b/0x5e0 net/tipc/socket.c:584
>      [<000000009f3189da>] __sock_release+0x4b/0xe0 net/socket.c:607
>
> BUG: memory leak
> unreferenced object 0xffff88810e63de00 (size 512):
>    comm "softirq", pid 0, jiffies 4294943548 (age 7.890s)
>    hex dump (first 32 bytes):
>      38 10 0d 0f 81 88 ff ff 38 10 0d 0f 81 88 ff ff  8.......8.......
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<000000009375ee42>] kmemleak_alloc_recursive
> include/linux/kmemleak.h:55 [inline]
>      [<000000009375ee42>] slab_post_alloc_hook mm/slab.h:439 [inline]
>      [<000000009375ee42>] slab_alloc_node mm/slab.c:3269 [inline]
>      [<000000009375ee42>] kmem_cache_alloc_node+0x153/0x2a0 mm/slab.c:3579
>      [<000000004c563922>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:198
>      [<00000000ec87bfa1>] alloc_skb_fclone include/linux/skbuff.h:1107
> [inline]
>      [<00000000ec87bfa1>] tipc_buf_acquire+0x2f/0x80 net/tipc/msg.c:66
>      [<00000000d151ef84>] tipc_msg_create+0x37/0xe0 net/tipc/msg.c:98
>      [<000000008bb437b0>] tipc_group_create_event+0xb3/0x1b0
> net/tipc/group.c:679
>      [<00000000947b1d0f>] tipc_group_proto_rcv+0x569/0x640
> net/tipc/group.c:781
>      [<00000000b75ab039>] tipc_sk_proto_rcv net/tipc/socket.c:1996 [inline]
>      [<00000000b75ab039>] tipc_sk_filter_rcv+0x9ac/0xf20
> net/tipc/socket.c:2163
>      [<000000000dab7a6c>] tipc_sk_enqueue net/tipc/socket.c:2255 [inline]
>      [<000000000dab7a6c>] tipc_sk_rcv+0x494/0x8a0 net/tipc/socket.c:2306
>      [<00000000023a7ddd>] tipc_node_xmit+0x196/0x1f0 net/tipc/node.c:1442
>      [<00000000337dd9eb>] tipc_node_xmit_skb net/tipc/node.c:1491 [inline]
>      [<00000000337dd9eb>] tipc_node_distr_xmit+0x7d/0x120
> net/tipc/node.c:1506
>      [<00000000b6375182>] tipc_group_delete+0xe6/0x130 net/tipc/group.c:224
>      [<000000000361ba2b>] tipc_sk_leave+0x57/0xb0 net/tipc/socket.c:2925
>      [<000000009df90505>] tipc_release+0x7b/0x5e0 net/tipc/socket.c:584
>      [<000000009f3189da>] __sock_release+0x4b/0xe0 net/socket.c:607
>      [<00000000d3568ee0>] sock_close+0x1b/0x30 net/socket.c:1279
>      [<00000000266a6215>] __fput+0xed/0x300 fs/file_table.c:280
>
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
