Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB24227E77
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgGULL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgGULLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 07:11:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEE1C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:11:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id q5so20786616wru.6
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 04:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VjDtzsU+b3387n6phjrIUfDrd8oinDl1wvNnY6/De3s=;
        b=hj+JdctktnbYyPUKenL1uf/EoqZtDfxE1Qy+0vCjbTDIYF0TfXpYfXQaqgjSJ7pLya
         zXEkQn4Hy+FGZk/VQtTHIeHT2UW+j2RKS16o4bqom0RXyZid+2Wuro0oi2+Cc22VkaVw
         UXakAtRhxXplxqPsa/Vni0xwXDVt3h7tOi0ViCv1pOPoODgNCGXXY5kMsToD6kjU0Ajj
         EYUR66/T4EqsjaXaHnhMJ1pCs7+2EDruN4IXBbzHMmsX2vbX0L3XmTycfUvJpGBFydmn
         rt5qv6WLwPXXiOdsThDliFChEC8UAfgOdmhtz7TKYK8MDkeJCUA/2mi9Boy83t5LMmQR
         sznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VjDtzsU+b3387n6phjrIUfDrd8oinDl1wvNnY6/De3s=;
        b=FumjTrM6wF0jPZAQlqcmFf0Tt0RRv45y05YW3avyBrek+IAtmCyiIZKSbw/uDxsrUQ
         4HJAe43JwsNw70JkLKWCkeYTPTj4ZFhjK2jqrgGylwj8JjCWAjTTFl3xmmQKwypjYekq
         RR13/va/EGQE7xpYsJr/CcYe4+aphqihq0MR7QO/7MxO4moMvKPvhs0P3SI/+U2KfejY
         j+wIEODQLbiy1wYERsidajVPPz4AEvagAlb5jYA0AEZnNNurgzv7Y+sJLehLF2tWDLta
         wXw0z4x1O2ffuiV3vB4e6eDX3iGVGYFWdDc+sGf5fhmhu2SN5pgpVZiRXCbtyIxde2Hu
         QD4w==
X-Gm-Message-State: AOAM530kj0IjoFHzIr9YlrCCK43s9fkpUT+3Yvfs12S2Ljiy0NF3pVv1
        2BghAzd+Dnr70y2hLaxN95E9S/vcTejlGah6kPA=
X-Google-Smtp-Source: ABdhPJyXYjw72mecD/DK7SF//ph7xuZaDp/NAt/qv5zi+jWVviJR2TeK+x3Nkhtcuhno2PgbNP1sFW8MoGcyls2IgWc=
X-Received: by 2002:a5d:4649:: with SMTP id j9mr24967504wrs.270.1595329913924;
 Tue, 21 Jul 2020 04:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200603050601.19570-1-tuong.t.lien@dektech.com.au>
In-Reply-To: <20200603050601.19570-1-tuong.t.lien@dektech.com.au>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 21 Jul 2020 19:22:36 +0800
Message-ID: <CADvbK_cE8boY0Y7CcNS_Vh5gZGf4+Pb2urG993V9wnuS=vQK3g@mail.gmail.com>
Subject: Re: [tipc-discussion] [net-next] tipc: fix NULL pointer dereference
 in streaming
To:     Tuong Lien <tuong.t.lien@dektech.com.au>
Cc:     davem <davem@davemloft.net>, jmaloy@redhat.com, maloy@donjonn.com,
        Ying Xue <ying.xue@windriver.com>,
        network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 1:06 PM Tuong Lien <tuong.t.lien@dektech.com.au> wrote:
>
> syzbot found the following crash:
>
> general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
> CPU: 1 PID: 7060 Comm: syz-executor394 Not tainted 5.7.0-rc6-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:__tipc_sendstream+0xbde/0x11f0 net/tipc/socket.c:1591
> Code: 00 00 00 00 48 39 5c 24 28 48 0f 44 d8 e8 fa 3e db f9 48 b8 00 00 00 00 00 fc ff df 48 8d bb c8 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e2 04 00 00 48 8b 9b c8 00 00 00 48 b8 00 00 00
> RSP: 0018:ffffc90003ef7818 EFLAGS: 00010202
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8797fd9d
> RDX: 0000000000000019 RSI: ffffffff8797fde6 RDI: 00000000000000c8
> RBP: ffff888099848040 R08: ffff88809a5f6440 R09: fffffbfff1860b4c
> R10: ffffffff8c305a5f R11: fffffbfff1860b4b R12: ffff88809984857e
> R13: 0000000000000000 R14: ffff888086aa4000 R15: 0000000000000000
> FS:  00000000009b4880(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000140 CR3: 00000000a7fdf000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  tipc_sendstream+0x4c/0x70 net/tipc/socket.c:1533
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x32f/0x810 net/socket.c:2352
>  ___sys_sendmsg+0x100/0x170 net/socket.c:2406
>  __sys_sendmmsg+0x195/0x480 net/socket.c:2496
>  __do_sys_sendmmsg net/socket.c:2525 [inline]
>  __se_sys_sendmmsg net/socket.c:2522 [inline]
>  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2522
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x440199
> ...
>
> This bug was bisected to commit 0a3e060f340d ("tipc: add test for Nagle
> algorithm effectiveness"). However, it is not the case, the trouble was
> from the base in the case of zero data length message sending, we would
> unexpectedly make an empty 'txq' queue after the 'tipc_msg_append()' in
> Nagle mode.
>
> A similar crash can be generated even without the bisected patch but at
> the link layer when it accesses the empty queue.
>
> We solve the issues by building at least one buffer to go with socket's
> header and an optional data section that may be empty like what we had
> with the 'tipc_msg_build()'.
>
> Note: the previous commit 4c21daae3dbc ("tipc: Fix NULL pointer
> dereference in __tipc_sendstream()") is obsoleted by this one since the
> 'txq' will be never empty and the check of 'skb != NULL' is unnecessary
> but it is safe anyway.
Hi, Tuong

If commit 4c21daae3dbc is obsoleted by this one, can you please
send a patch to revert it?

Thanks.

>
> Reported-by: syzbot+8eac6d030e7807c21d32@syzkaller.appspotmail.com
> Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
> ---
>  net/tipc/msg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index c0afcd627c5e..046e4cb3acea 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -221,7 +221,7 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
>         accounted = skb ? msg_blocks(buf_msg(skb)) : 0;
>         total = accounted;
>
> -       while (rem) {
> +       do {
>                 if (!skb || skb->len >= mss) {
>                         skb = tipc_buf_acquire(mss, GFP_KERNEL);
>                         if (unlikely(!skb))
> @@ -245,7 +245,7 @@ int tipc_msg_append(struct tipc_msg *_hdr, struct msghdr *m, int dlen,
>                 skb_put(skb, cpy);
>                 rem -= cpy;
>                 total += msg_blocks(hdr) - curr;
> -       }
> +       } while (rem);
>         return total - accounted;
>  }
>
> --
> 2.13.7
>
>
>
> _______________________________________________
> tipc-discussion mailing list
> tipc-discussion@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tipc-discussion
