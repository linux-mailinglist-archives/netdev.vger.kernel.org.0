Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C1357FBA2
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 10:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiGYIqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 04:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiGYIqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 04:46:10 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692F8DFBC
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:46:08 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31e623a4ff4so101877867b3.4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 01:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EFd32yIZ2fkMTi1CwMNr4HcSjPJOHf/uYcynPXFtcuY=;
        b=Ne88j2CXUZIBULU0OgsSYzAjQeQO8URp9PeGCqqR2rT+IkqkSPnK3EC75V0jPDiZI5
         ojTv5u2ROUqXV0KUzl7BNrF7ZNubogrF0PMfOh/I7dz3XVIO5dXDV2TFvCkd9z9fblUE
         xPsj4HRzkZHxM+9uXLKk44xgGMY+BTYM6Zm9jnZ7c9pDoGIFFSCYBFT7JQC78K7z4pHY
         UZgx4argLvMIPSJXKgl8cGe/UMwOd2xwiVsMk/JQdqVTk7RtCyO2ENeU68WaV119Z9nb
         wjl08gTRv4Z96prRrkp5BgtVuim7Yzt+PGuDjHXDHK/xfXjuv+qDnt1yN7IyA97NLLlw
         0XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EFd32yIZ2fkMTi1CwMNr4HcSjPJOHf/uYcynPXFtcuY=;
        b=eMJicvjlgxGDbmKxcjfyMD9SCDAB3mMNX6FBk0ygTZ3uVyaoLlsfqLZ+xHASzckWNO
         BJMYBJv+D/IkyHqDSNswG8NdAD+6Bud92gz41PrVCsJrLapAQSD/nOWlHaljQsyAxsDQ
         rGbLnh3I8+fvWE/MPlA9sNyCKNtenqHCuLwTxJZlVwA/GwkHGwwCauBHdMeg6QknlKMX
         SUeqbF12Z51+eHaLej+Z2jojhZ9btnDe967qIU3v2dfrNR/sJEkxHzcdU12iNkcYNSOE
         0BLzlzwlxkQ2QDuxVsFQIiJuI+tzt5thH1CimsZtehh1R1rBEbIyFftmWXGLJpu2BF/8
         xAog==
X-Gm-Message-State: AJIora/cRZpoNXKUaPsqxHvSqrmmyIP//jnQ+wFp6h8V4YWCQmdcYu2a
        dUu2qPDRTZseo3ew2Hv3ScD9v3HEw1ZLYT7uBYbSzw==
X-Google-Smtp-Source: AGRyM1szb7bl9YdvcVGJsi2Yic1YA5dkBKe/EdH1r8lhCXkk2ASwSeyXTfEOnjaMADHmc9xP+BTmcbaY6B/uXtCcqXQ=
X-Received: by 2002:a0d:d305:0:b0:31e:8451:f53a with SMTP id
 v5-20020a0dd305000000b0031e8451f53amr8909239ywd.489.1658738767333; Mon, 25
 Jul 2022 01:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220709222029.297471-1-xiyou.wangcong@gmail.com>
 <CANn89iJSQh-5DAhEL4Fh5ZDrtY47y0Mo9YJbG-rnj17pdXqoXA@mail.gmail.com>
 <YtQ/Np8DZBJVFO3l@pop-os.localdomain> <CANn89iLLANJLHG+_uUu5Z+V64BMCsYHRgCHVHENhZiMOrVUtMw@mail.gmail.com>
 <Yt2IgGuqVi9BHc/g@pop-os.localdomain>
In-Reply-To: <Yt2IgGuqVi9BHc/g@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Jul 2022 10:45:56 +0200
Message-ID: <CANn89iLHg-D3q8jPFq_87mLFPh5L7arbaF2aNeY42s4VUv_D-Q@mail.gmail.com>
Subject: Re: [Patch bpf-next] tcp: fix sock skb accounting in tcp_read_skb()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 7:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Jul 18, 2022 at 09:26:29AM +0200, Eric Dumazet wrote:
> > On Sun, Jul 17, 2022 at 6:56 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Tue, Jul 12, 2022 at 03:20:37PM +0200, Eric Dumazet wrote:
> > > > On Sun, Jul 10, 2022 at 12:20 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > > >
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > Before commit 965b57b469a5 ("net: Introduce a new proto_ops
> > > > > ->read_skb()"), skb was not dequeued from receive queue hence
> > > > > when we close TCP socket skb can be just flushed synchronously.
> > > > >
> > > > > After this commit, we have to uncharge skb immediately after being
> > > > > dequeued, otherwise it is still charged in the original sock. And we
> > > > > still need to retain skb->sk, as eBPF programs may extract sock
> > > > > information from skb->sk. Therefore, we have to call
> > > > > skb_set_owner_sk_safe() here.
> > > > >
> > > > > Fixes: 965b57b469a5 ("net: Introduce a new proto_ops ->read_skb()")
> > > > > Reported-and-tested-by: syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com
> > > > > Tested-by: Stanislav Fomichev <sdf@google.com>
> > > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > > ---
> > > > >  net/ipv4/tcp.c | 1 +
> > > > >  1 file changed, 1 insertion(+)
> > > > >
> > > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > > index 9d2fd3ced21b..c6b1effb2afd 100644
> > > > > --- a/net/ipv4/tcp.c
> > > > > +++ b/net/ipv4/tcp.c
> > > > > @@ -1749,6 +1749,7 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
> > > > >                 int used;
> > > > >
> > > > >                 __skb_unlink(skb, &sk->sk_receive_queue);
> > > > > +               WARN_ON(!skb_set_owner_sk_safe(skb, sk));
> > > > >                 used = recv_actor(sk, skb);
> > > > >                 if (used <= 0) {
> > > > >                         if (!copied)
> > > > > --
> > > > > 2.34.1
> > > > >
> > > >
> > > > I am reading tcp_read_skb(),it seems to have other bugs.
> > > > I wonder why syzbot has not caught up yet.
> > >
> > > As you mentioned this here I assume you suggest I should fix all bugs in
> > > one patch? (I am fine either way in this case, only slightly prefer to fix
> > > one bug in each patch for readability.)
> >
> > I only wonder that after fixing all bugs, we might end up with  tcp_read_sk()
> > being a clone of tcp_read_sock() :/
>
> I really wish so, but unfortunately the partial read looks impossible to
> merged with full skb read.
>
>
> >
> > syzbot has a relevant report:
> >
>
> Please provide a reproducer if you have, I don't see this report
> anywhere (except here of course).

No repro yet.

I usually hold syzbot report until they have enough signal (repro, and
eventually bisection) in them to be considered.

>
> > ------------[ cut here ]------------
> > cleanup rbuf bug: copied 301B4426 seq 301B4426 rcvnxt 302142E8
> > WARNING: CPU: 0 PID: 3744 at net/ipv4/tcp.c:1567
> > tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
> > Modules linked in:
> > CPU: 0 PID: 3744 Comm: kworker/0:7 Not tainted
> > 5.19.0-rc5-syzkaller-01095-gedb2c3476db9 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 06/29/2022
> > Workqueue: events nsim_dev_trap_report_work
> > RIP: 0010:tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
> > Code: ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e d7 03 00 00 8b 8d 38
> > 08 00 00 44 89 e2 44 89 f6 48 c7 c7 20 82 df 8a e8 94 d8 58 01 <0f> 0b
> > e8 cc 84 a0 f9 48 8d bd 88 07 00 00 48 b8 00 00 00 00 00 fc
> > RSP: 0018:ffffc90000007700 EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: 000000000004fef7 RCX: 0000000000000000
> > RDX: ffff8880201abb00 RSI: ffffffff8160d438 RDI: fffff52000000ed2
> > RBP: ffff888016819800 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000000000103 R11: 0000000000000001 R12: 00000000301b4426
> > R13: 0000000000000000 R14: 00000000301b4426 R15: 00000000301b4426
> > FS: 0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020c55000 CR3: 0000000075009000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> > <IRQ>
> > tcp_read_skb+0x29e/0x430 net/ipv4/tcp.c:1775
> > sk_psock_verdict_data_ready+0x9d/0xc0 net/core/skmsg.c:1209
> > tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4985
> > tcp_data_queue+0x1bb2/0x4c60 net/ipv4/tcp_input.c:5059
> > tcp_rcv_established+0x82f/0x20e0 net/ipv4/tcp_input.c:5984
> > tcp_v4_do_rcv+0x66c/0x9b0 net/ipv4/tcp_ipv4.c:1661
> > tcp_v4_rcv+0x343b/0x3940 net/ipv4/tcp_ipv4.c:2078
> > ip_protocol_deliver_rcu+0xa3/0x7c0 net/ipv4/ip_input.c:205
> > ip_local_deliver_finish+0x2e8/0x4c0 net/ipv4/ip_input.c:233
> > NF_HOOK include/linux/netfilter.h:307 [inline]
> > NF_HOOK include/linux/netfilter.h:301 [inline]
> > ip_local_deliver+0x1aa/0x200 net/ipv4/ip_input.c:254
> > dst_input include/net/dst.h:461 [inline]
> > ip_rcv_finish+0x1cb/0x2f0 net/ipv4/ip_input.c:437
> > NF_HOOK include/linux/netfilter.h:307 [inline]
> > NF_HOOK include/linux/netfilter.h:301 [inline]
> > ip_rcv+0xaa/0xd0 net/ipv4/ip_input.c:557
> > __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5480
> > __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5594
> > process_backlog+0x3a0/0x7c0 net/core/dev.c:5922
> > __napi_poll+0xb3/0x6e0 net/core/dev.c:6506
> > napi_poll net/core/dev.c:6573 [inline]
> > net_rx_action+0x9c1/0xd90 net/core/dev.c:6684
> > __do_softirq+0x29b/0x9c2 kernel/softirq.c:571
> > do_softirq.part.0+0xde/0x130 kernel/softirq.c:472
> > </IRQ>
> > <TASK>
> > do_softirq kernel/softirq.c:464 [inline]
> > __local_bh_enable_ip+0x102/0x120 kernel/softirq.c:396
> > spin_unlock_bh include/linux/spinlock.h:394 [inline]
> > nsim_dev_trap_report drivers/net/netdevsim/dev.c:814 [inline]
> > nsim_dev_trap_report_work+0x84d/0xba0 drivers/net/netdevsi
m/dev.c:840
> > process_one_work+0x996/0x1610 kernel/workqueue.c:2289
> > worker_thread+0x665/0x1080 kernel/workqueue.c:2436
> > kthread+0x2e9/0x3a0 kernel/kthread.c:376
> > ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
> > </TASK>------------[ cut here ]------------
> > cleanup rbuf bug: copied 301B4426 seq 301B4426 rcvnxt 302142E8
> > WARNING: CPU: 0 PID: 3744 at net/ipv4/tcp.c:1567
> > tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
> > Modules linked in:
> > CPU: 0 PID: 3744 Comm: kworker/0:7 Not tainted
> > 5.19.0-rc5-syzkaller-01095-gedb2c3476db9 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 06/29/2022
> > Workqueue: events nsim_dev_trap_report_work
> > RIP: 0010:tcp_cleanup_rbuf+0x11d/0x5b0 net/ipv4/tcp.c:1567
> > Code: ea 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e d7 03 00 00 8b 8d 38
> > 08 00 00 44 89 e2 44 89 f6 48 c7 c7 20 82 df 8a e8 94 d8 58 01 <0f> 0b
> > e8 cc 84 a0 f9 48 8d bd 88 07 00 00 48 b8 00 00 00 00 00 fc
> > RSP: 0018:ffffc90000007700 EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: 000000000004fef7 RCX: 0000000000000000
> > RDX: ffff8880201abb00 RSI: ffffffff8160d438 RDI: fffff52000000ed2
> > RBP: ffff888016819800 R08: 0000000000000005 R09: 0000000000000000
> > R10: 0000000000000103 R11: 0000000000000001 R12: 00000000301b4426
> > R13: 0000000000000000 R14: 00000000301b4426 R15: 00000000301b4426
> > FS: 0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> > CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020c55000 CR3: 0000000075009000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> > <IRQ>
> > tcp_read_skb+0x29e/0x430 net/ipv4/tcp.c:1775
> > sk_psock_verdict_data_ready+0x9d/0xc0 net/core/skmsg.c:1209
> > tcp_data_ready+0x106/0x520 net/ipv4/tcp_input.c:4985
> > tcp_data_queue+0x1bb2/0x4c60 net/ipv4/tcp_input.c:5059
> > tcp_rcv_established+0x82f/0x20e0 net/ipv4/tcp_input.c:5984
> > tcp_v4_do_rcv+0x66c/0x9b0 net/ipv4/tcp_ipv4.c:1661
> > tcp_v4_rcv+0x343b/0x3940 net/ipv4/tcp_ipv4.c:2078
> > ip_protocol_deliver_rcu+0xa3/0x7c0 net/ipv4/ip_input.c:205
> > ip_local_deliver_finish+0x2e8/0x4c0 net/ipv4/ip_input.c:233
> > NF_HOOK include/linux/netfilter.h:307 [inline]
> > NF_HOOK include/linux/netfilter.h:301 [inline]
> > ip_local_deliver+0x1aa/0x200 net/ipv4/ip_input.c:254
> > dst_input include/net/dst.h:461 [inline]
> > ip_rcv_finish+0x1cb/0x2f0 net/ipv4/ip_input.c:437
> > NF_HOOK include/linux/netfilter.h:307 [inline]
> > NF_HOOK include/linux/netfilter.h:301 [inline]
> > ip_rcv+0xaa/0xd0 net/ipv4/ip_input.c:557
> > __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5480
> > __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5594
> > process_backlog+0x3a0/0x7c0 net/core/dev.c:5922
> > __napi_poll+0xb3/0x6e0 net/core/dev.c:6506
> > napi_poll net/core/dev.c:6573 [inline]
> > net_rx_action+0x9c1/0xd90 net/core/dev.c:6684
> > __do_softirq+0x29b/0x9c2 kernel/softirq.c:571
> > do_softirq.part.0+0xde/0x130 kernel/softirq.c:472
> > </IRQ>
> > <TASK>
> > do_softirq kernel/softirq.c:464 [inline]
> > __local_bh_enable_ip+0x102/0x120 kernel/softirq.c:396
> > spin_unlock_bh include/linux/spinlock.h:394 [inline]
> > nsim_dev_trap_report drivers/net/netdevsim/dev.c:814 [inline]
> > nsim_dev_trap_report_work+0x84d/0xba0 drivers/net/netdevsim/dev.c:840
> > process_one_work+0x996/0x1610 kernel/workqueue.c:2289
> > worker_thread+0x665/0x1080 kernel/workqueue.c:2436
> > kthread+0x2e9/0x3a0 kernel/kthread.c:376
> > ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
> > </TASK>
> >
> > >
> > > >
> > > > It ignores the offset value from tcp_recv_skb(), this looks wrong to me.
> > > > The reason tcp_read_sock() passes a @len parameter is that is it not
> > > > skb->len, but (skb->len - offset)
> > >
> > > If I understand tcp_recv_skb() correctly it only returns an offset for a
> > > partial read of an skb. IOW, if we always read an entire skb at a time,
> > > offset makes no sense here, right?
> > >
> > > >
> > > > Also if recv_actor(sk, skb) returns 0, we probably still need to
> > > > advance tp->copied_seq,
> > > > for instance if skb had a pure FIN (and thus skb->len == 0), since you
> > > > removed the skb from sk_receive_queue ?
> > >
> > > Doesn't the following code handle this case?
> > >
> > >         if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> > >                 consume_skb(skb);
> > >                 ++seq;
> > >                 break;
> > >         }
> > >
> > > which is copied from tcp_read_sock()...
> >
> > I do not think this is enough, because you can break from the loop
> > before doing this  check about TCPHDR_FIN,
>
> The logic is same for tcp_read_sock(). :)
>
>
> > after skb has been unlinked from sk_receive_queue. TCP won't be able
> > to catch FIN.
>
> So TCP does not process FIN before ->sk_data_ready()? I wonder how FIN
> (at least a pure FIN as you mentioned above) ends up being queued in
> ->sk_receive_queue anyway?

That's how TCP stores packets, including the final FIN.

(Because this skb can also contain payload anyway)

>
> Thanks!
