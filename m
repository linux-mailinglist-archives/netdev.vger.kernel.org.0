Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15957302E9B
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733121AbhAYWCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732996AbhAYWBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:01:55 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C64A2C061573
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:01:14 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id z22so29754700ioh.9
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pt4uK7+fglRi5mSqUM+0Zo64wDCR3qdBbt9k3yKslD8=;
        b=axfpFnb5vFhsKKRyt7UL2WEe+Dlta2QbR/1ZinUR8BsFqr4/jOkuHB0Wgc0c71WHhd
         MLn93dAhJA5BeLIo8Uj8DrJKcSXEfTdB8vhufNuTHrPtHimZ4EjJ+qYldHjXGdv6ye9R
         AUaY7LzLH40iRCf/65TXPhX/zhZzxCwJuqXZfVI0pB3VyfHLg5eFPzvRnBJnBrqxSm1A
         pWlOadjqDuTwEMwzT/0n4jiCvhIYhkAqmwLwIrrwa7oDdWhAwWJHjP4IH770SAqqZz9w
         sqiF2I9cJWr7nLrUJKZNvQAJNth5jxl7QE6onbn+5XQGaFfgRb8sqUQpWP13dHMy2+2o
         TUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pt4uK7+fglRi5mSqUM+0Zo64wDCR3qdBbt9k3yKslD8=;
        b=J9rB+bsx0lxz/x6xJsF0YY4uI2JzX4xyd3TpTSxhoz1tN8lYahXNRti1sjwOKPgU4c
         ambqQrNM3onBaULChi7y3TnO0JaMLfTUXHHQaILGi9Z5WZ0YZyN1xsof2Nz9Oj67+7Xw
         wu3XrSeIcLAc8gggRuzsh42OJCM3xUbvVhIxh4iSr1GQ+SLIsMeWZeDsYn3VCze9QKAp
         YLoJ8lZil2A7H209jHI5MmNwFN0ChLmGLZB9fTCumQu1GUpkVsHik0hwCq95QYYCb1OV
         5/r33xaSieG/Sw0EQ+zlRZ+sk0BZcHcfriab18sWKVy0Pxlnfu8m6WnkvH5370uOUXD/
         KQHw==
X-Gm-Message-State: AOAM531yX3+goIAPTOYLW08cPLQm0yIW+4exszNUkCVi4dDD9BgdViwc
        Q/jq84uSyN5oEnn+Tw2cIjsIw3551CCkrMxxXgs7lQ==
X-Google-Smtp-Source: ABdhPJxbv+KJl68OGuLDQGZ21cJh5kav4eRWVOWzT1xABymSjAkyc9/0/SfMYctXANPZG7uAUInsnbX+k+F8kqwxNK4=
X-Received: by 2002:a05:6e02:1d0e:: with SMTP id i14mr2058326ila.69.1611612073822;
 Mon, 25 Jan 2021 14:01:13 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005d4f3205b9ab95f4@google.com> <20210125131252.4e17d3f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125131252.4e17d3f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Jan 2021 23:01:02 +0100
Message-ID: <CANn89iK+ckTzYd70CzerWOiCXt6TJfKPok1mBHarDJYBCot-_A@mail.gmail.com>
Subject: Re: WARNING in pskb_expand_head
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+a1c17e56a8a62294c714@syzkaller.appspotmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, hawk@kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 10:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> CC Willem just in case


This is an old bug really, tun_napi_alloc_frags() does not make sure
its @len argument is not too big.

Since __skb_grow() does not use __GFP_NOWARN we end up with this well
known warning in mm layer.

I would use the following fix :


diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 62690baa19bc8c4bf52f8b18a092f570e2125fc8..a0740e40a145fa2e175edd2180d369859c5d786b
100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1367,13 +1367,16 @@ static struct sk_buff
*tun_napi_alloc_frags(struct tun_file *tfile,
        if (it->nr_segs > MAX_SKB_FRAGS + 1)
                return ERR_PTR(-EMSGSIZE);

+       linear = iov_iter_single_seg_count(it);
+       if (linear > SKB_MAX_ALLOC)
+               return ERR_PTR(-EMSGSIZE);
+
        local_bh_disable();
        skb = napi_get_frags(&tfile->napi);
        local_bh_enable();
        if (!skb)
                return ERR_PTR(-ENOMEM);

-       linear = iov_iter_single_seg_count(it);
        err = __skb_grow(skb, linear);
        if (err)
                goto free;


>
> On Sun, 24 Jan 2021 12:51:20 -0800 syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    7d68e382 bpf: Permit size-0 datasec
> > git tree:       bpf-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=132567e7500000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c7843b8af99dff
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a1c17e56a8a62294c714
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17ae23af500000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13856bc7500000
> >
> > The issue was bisected to:
> >
> > commit 3226b158e67cfaa677fd180152bfb28989cb2fac
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Wed Jan 13 16:18:19 2021 +0000
> >
> >     net: avoid 32 x truesize under-estimation for tiny skbs
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=151a3027500000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=171a3027500000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=131a3027500000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+a1c17e56a8a62294c714@syzkaller.appspotmail.com
> > Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
> >
> > RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
> > R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> > R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 8703 at mm/page_alloc.c:4976 __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5011
> > Modules linked in:
> > CPU: 1 PID: 8703 Comm: syz-executor857 Not tainted 5.11.0-rc3-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:__alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:4976
> > Code: 00 00 0c 00 0f 85 a7 00 00 00 8b 3c 24 4c 89 f2 44 89 e6 c6 44 24 70 00 48 89 6c 24 58 e8 d0 d7 ff ff 49 89 c5 e9 ea fc ff ff <0f> 0b e9 b5 fd ff ff 89 74 24 14 4c 89 4c 24 08 4c 89 74 24 18 e8
> > RSP: 0018:ffffc90001ecf910 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: 1ffff920003d9f26 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000060a20
> > RBP: 0000000000020a20 R08: 0000000000000000 R09: 0000000000000001
> > R10: ffffffff86f1be3c R11: 0000000000000000 R12: 0000000000000012
> > R13: 0000000020010300 R14: 0000000000060a20 R15: 0000000000000000
> > FS:  0000000001148880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000006d5090 CR3: 000000001d414000 CR4: 00000000001506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  __alloc_pages include/linux/gfp.h:511 [inline]
> >  __alloc_pages_node include/linux/gfp.h:524 [inline]
> >  alloc_pages_node include/linux/gfp.h:538 [inline]
> >  kmalloc_large_node+0x60/0x110 mm/slub.c:3984
> >  __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4481
> >  __kmalloc_reserve net/core/skbuff.c:150 [inline]
> >  pskb_expand_head+0xae9/0x1050 net/core/skbuff.c:1632
> >  __skb_grow include/linux/skbuff.h:2748 [inline]
> >  tun_napi_alloc_frags drivers/net/tun.c:1377 [inline]
> >  tun_get_user+0x1f52/0x3690 drivers/net/tun.c:1730
> >  tun_chr_write_iter+0xe1/0x1d0 drivers/net/tun.c:1926
> >  call_write_iter include/linux/fs.h:1901 [inline]
> >  new_sync_write+0x426/0x650 fs/read_write.c:518
> >  vfs_write+0x791/0xa30 fs/read_write.c:605
> >  ksys_write+0x12d/0x250 fs/read_write.c:658
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > RIP: 0033:0x4440a9
> > Code: e8 6c 05 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 9b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007fffdb5a8e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004440a9
> > RDX: 000000002001016f RSI: 0000000020000380 RDI: 0000000000000003
> > RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
> > R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
> > R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>
