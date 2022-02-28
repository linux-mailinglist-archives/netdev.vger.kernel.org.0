Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF354C621B
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 05:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiB1EVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 23:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiB1EVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 23:21:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EE083D1C8
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 20:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646022021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VNpVJhSH3PjsLwykEHFtHi6/RamVVLKmSoaEjxn7Nvg=;
        b=S05lNUaQLy0/eBpqdlNlGUTS6SdP4x5f3SuXnFpdy0FAqjCUUJIEPYv2wGNriOy3MpIXbE
        QFgkCZflt1pL6umszo4VDMxwrUVq8Yd5/tJDWZrMrZiRUsUV3P2Cqez0/BA3acNa1qJEMA
        +GaltFZtx/uvnipPnYsRRkaS9ej5KN4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-nuKkzGUGMnuOaudKcZ7Uhg-1; Sun, 27 Feb 2022 23:20:20 -0500
X-MC-Unique: nuKkzGUGMnuOaudKcZ7Uhg-1
Received: by mail-lj1-f200.google.com with SMTP id b16-20020a05651c0b1000b0024647a956a2so5070642ljr.5
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 20:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VNpVJhSH3PjsLwykEHFtHi6/RamVVLKmSoaEjxn7Nvg=;
        b=usKCycX6hy5vUOyYjbZ1eTGUYyF9AST7bYi42ZaD3jkAKacEfoW1PUmf2dYEd3XIwq
         ufo+L2ahg4FMf9GMffQoikebCU7EHCDhCNSI9rkDt3nuniaIt2eK/yeeY/r7SC86zOpE
         T2m4esb6cgh72Nxh1/rVr9Hsp20Y/U5AN3qarRM9mppcSAXpL0EuNHaQbTN0IXKbFZYf
         GQaLsvTI2uCX5D7N7MXfev0/DAbqU7pG1KnmxAdzvgMKIH6heBhyGwsUBtAs6ETWwJXq
         VKL613JoiHmW9sxqrNbro4g6/iN2uAnO/lkmelWp+OSTxClKolYnzqj4n8oxdqfDWj3N
         Abhg==
X-Gm-Message-State: AOAM533oiI7uPB/cStr53a0GE1+meRv3BmsAEdtWAYOKU/kRt+2G4gpm
        gjZmNM+alBNLkMI2vYG/fP3RY5VmVqhXMwHN+xO5yUxM+aAmmHIisII7L94qP/4Kpq6jsdxg6md
        1XMHNG0W0e0p3RtQSkiRYG3KJBMBjQSnP
X-Received: by 2002:a05:6512:3d08:b0:43f:8f45:d670 with SMTP id d8-20020a0565123d0800b0043f8f45d670mr11963043lfv.587.1646022018000;
        Sun, 27 Feb 2022 20:20:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzR306Jlnxw/4V+tmWiwJcuzQuzHoO9VPYVxJCxYPi99rGFCNJ2e3+QioqaubZjz0F0phn0Zgr7d+6mA6rWEDk=
X-Received: by 2002:a05:6512:3d08:b0:43f:8f45:d670 with SMTP id
 d8-20020a0565123d0800b0043f8f45d670mr11963024lfv.587.1646022017698; Sun, 27
 Feb 2022 20:20:17 -0800 (PST)
MIME-Version: 1.0
References: <20220224103852.311369-1-baymaxhuang@gmail.com>
 <20220225090223.636877-1-baymaxhuang@gmail.com> <c687e1d8-e36a-8f23-342a-22b2a1efb372@gmail.com>
In-Reply-To: <c687e1d8-e36a-8f23-342a-22b2a1efb372@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 28 Feb 2022 12:20:06 +0800
Message-ID: <CACGkMEtTdvbc1rk6sk=KE7J2L0=R2M-FMxK+DfJDUYMTPbPJGA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] tun: support NAPI for packets received from
 batched XDP buffs
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Harold Huang <baymaxhuang@gmail.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 12:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 2/25/22 01:02, Harold Huang wrote:
> > In tun, NAPI is supported and we can also use NAPI in the path of
> > batched XDP buffs to accelerate packet processing. What is more, after
> > we use NAPI, GRO is also supported. The iperf shows that the throughput of
> > single stream could be improved from 4.5Gbps to 9.2Gbps. Additionally, 9.2
> > Gbps nearly reachs the line speed of the phy nic and there is still about
> > 15% idle cpu core remaining on the vhost thread.
> >
> > Test topology:
> >
> > [iperf server]<--->tap<--->dpdk testpmd<--->phy nic<--->[iperf client]
> >
> > Iperf stream:
> >
> > Before:
> > ...
> > [  5]   5.00-6.00   sec   558 MBytes  4.68 Gbits/sec    0   1.50 MBytes
> > [  5]   6.00-7.00   sec   556 MBytes  4.67 Gbits/sec    1   1.35 MBytes
> > [  5]   7.00-8.00   sec   556 MBytes  4.67 Gbits/sec    2   1.18 MBytes
> > [  5]   8.00-9.00   sec   559 MBytes  4.69 Gbits/sec    0   1.48 MBytes
> > [  5]   9.00-10.00  sec   556 MBytes  4.67 Gbits/sec    1   1.33 MBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  5.39 GBytes  4.63 Gbits/sec   72          sender
> > [  5]   0.00-10.04  sec  5.39 GBytes  4.61 Gbits/sec               receiver
> >
> > After:
> > ...
> > [  5]   5.00-6.00   sec  1.07 GBytes  9.19 Gbits/sec    0   1.55 MBytes
> > [  5]   6.00-7.00   sec  1.08 GBytes  9.30 Gbits/sec    0   1.63 MBytes
> > [  5]   7.00-8.00   sec  1.08 GBytes  9.25 Gbits/sec    0   1.72 MBytes
> > [  5]   8.00-9.00   sec  1.08 GBytes  9.25 Gbits/sec   77   1.31 MBytes
> > [  5]   9.00-10.00  sec  1.08 GBytes  9.24 Gbits/sec    0   1.48 MBytes
> > - - - - - - - - - - - - - - - - - - - - - - - - -
> > [ ID] Interval           Transfer     Bitrate         Retr
> > [  5]   0.00-10.00  sec  10.8 GBytes  9.28 Gbits/sec  166          sender
> > [  5]   0.00-10.04  sec  10.8 GBytes  9.24 Gbits/sec               receiver
> > ....
> >
> > Reported-at: https://lore.kernel.org/all/CACGkMEvTLG0Ayg+TtbN4q4pPW-ycgCCs3sC3-TF8cuRTf7Pp1A@mail.gmail.com
> > Signed-off-by: Harold Huang <baymaxhuang@gmail.com>
> > ---
> > v1 -> v2
> >   - fix commit messages
> >   - add queued flag to avoid void unnecessary napi suggested by Jason
> >
> >   drivers/net/tun.c | 20 ++++++++++++++++----
> >   1 file changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index fed85447701a..c7d8b7c821d8 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -2379,7 +2379,7 @@ static void tun_put_page(struct tun_page *tpage)
> >   }
> >
> >   static int tun_xdp_one(struct tun_struct *tun,
> > -                    struct tun_file *tfile,
> > +                    struct tun_file *tfile, int *queued,
> >                      struct xdp_buff *xdp, int *flush,
> >                      struct tun_page *tpage)
> >   {
> > @@ -2388,6 +2388,7 @@ static int tun_xdp_one(struct tun_struct *tun,
> >       struct virtio_net_hdr *gso = &hdr->gso;
> >       struct bpf_prog *xdp_prog;
> >       struct sk_buff *skb = NULL;
> > +     struct sk_buff_head *queue;
> >       u32 rxhash = 0, act;
> >       int buflen = hdr->buflen;
> >       int err = 0;
> > @@ -2464,7 +2465,15 @@ static int tun_xdp_one(struct tun_struct *tun,
> >           !tfile->detached)
> >               rxhash = __skb_get_hash_symmetric(skb);
> >
> > -     netif_receive_skb(skb);
> > +     if (tfile->napi_enabled) {
> > +             queue = &tfile->sk.sk_write_queue;
> > +             spin_lock(&queue->lock);
> > +             __skb_queue_tail(queue, skb);
> > +             spin_unlock(&queue->lock);
> > +             (*queued)++;
> > +     } else {
> > +             netif_receive_skb(skb);
> > +     }
> >
> >       /* No need to disable preemption here since this function is
> >        * always called with bh disabled
> > @@ -2492,7 +2501,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> >       if (ctl && (ctl->type == TUN_MSG_PTR)) {
> >               struct tun_page tpage;
> >               int n = ctl->num;
> > -             int flush = 0;
> > +             int flush = 0, queued = 0;
> >
> >               memset(&tpage, 0, sizeof(tpage));
> >
> > @@ -2501,12 +2510,15 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
> >
> >               for (i = 0; i < n; i++) {
> >                       xdp = &((struct xdp_buff *)ctl->ptr)[i];
> > -                     tun_xdp_one(tun, tfile, xdp, &flush, &tpage);
> > +                     tun_xdp_one(tun, tfile, &queued, xdp, &flush, &tpage);
>
>
> How big n can be ?
>
> BTW I could not find where m->msg_controllen was checked in tun_sendmsg().
>
> struct tun_msg_ctl *ctl = m->msg_control;
>
> if (ctl && (ctl->type == TUN_MSG_PTR)) {
>
>      int n = ctl->num;  // can be set to values in [0..65535]
>
>      for (i = 0; i < n; i++) {
>
>          xdp = &((struct xdp_buff *)ctl->ptr)[i];
>
>
> I really do not understand how we prevent malicious user space from
> crashing the kernel.

It looks to me the only user for this is vhost-net which limits it to
64, userspace can't use sendmsg() directly on tap.

Thanks

>
>
>
> >               }
> >
> >               if (flush)
> >                       xdp_do_flush();
> >
> > +             if (tfile->napi_enabled && queued > 0)
> > +                     napi_schedule(&tfile->napi);
> > +
> >               rcu_read_unlock();
> >               local_bh_enable();
> >
>

