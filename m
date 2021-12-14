Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99796473B55
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhLNDNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:13:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232540AbhLNDNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639451600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99hHa+R8DxpGc57uFm6oCLjvQUYhFLts8EwSb1a/bxk=;
        b=i98HusjQARCC5iXS0/CA/19lKvRRlbvvSg347gmDb2uCXUc/A0uhcpX+JdTnelivBLesyp
        hDg5Gt2bB82trC0SFMjL2RC1E37MD0Gotq0i9BBQ7oc7RO4FxkU/oIvAyFmjT4DT9K7zMb
        hwVA+Hfo9ahXCuiUkNi2aS3MD/eroZY=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-YeVrRxS1PYKqLAYUDJ7iAQ-1; Mon, 13 Dec 2021 22:13:19 -0500
X-MC-Unique: YeVrRxS1PYKqLAYUDJ7iAQ-1
Received: by mail-lf1-f71.google.com with SMTP id w21-20020a197b15000000b00422b0797fa3so1146733lfc.4
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 19:13:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=99hHa+R8DxpGc57uFm6oCLjvQUYhFLts8EwSb1a/bxk=;
        b=5FF3zzdb1d7qoKVR0BiuBhCvtWocJhKyPwk4Rhoif65peWnMiw4qNPPoHctxwDJicc
         Mt9zfqhRnksYjRhjdHbSPx3nNJ7KzuZLBY0Cp/NoSQTTC9exJs6ktFfn+kAotxELwOzz
         5wgwhZG8KgZIpthV7FsCekwCzEa4GrPRBAuT32jNCfIky6qI83a6DcCa+qoFXW7Rygfg
         jhG0/Y+/OqZzdwwBHbOThRkXGnakX8Qu5wbGoCMGSfHJtzY+cZ+zLE/YIPSTYI6Mm1Wl
         9pXuG1mj7m/CsK37qCiGCfJ0lzUUbupVu1NRHLNoOC0NlrwVEOZqHL6Y8RitcTupmBs0
         r9fw==
X-Gm-Message-State: AOAM533Xo0R4+MKLy2b2hEVU2GdvR4T+YdhsZ0C+2SL4u88WciRnZPGS
        lg2gSedChzfg5Cbduu0HOCk9sQzt48FPuCg3xAytILNTIrl8vVM2O/QusNYtgHAXV0mk424/HYj
        cS8v6JerA3yLr5NA6iPPBwuB3pWZbUDqg
X-Received: by 2002:ac2:518b:: with SMTP id u11mr2321122lfi.498.1639451597761;
        Mon, 13 Dec 2021 19:13:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwZ1HCIVLCKmLXdf3Yl2yAjouNx1OCPxPcR7jWZs3VxYTOSPUyURuqCGeB00yGBqOXmIWH1kqW4dvobsBNeN9Y=
X-Received: by 2002:ac2:518b:: with SMTP id u11mr2321107lfi.498.1639451597577;
 Mon, 13 Dec 2021 19:13:17 -0800 (PST)
MIME-Version: 1.0
References: <20211213045012.12757-1-mengensun@tencent.com> <CACGkMEtLso8QjvmjTQ=S_bbGxu11O_scRa8GT7z6MXfJbfzfRg@mail.gmail.com>
In-Reply-To: <CACGkMEtLso8QjvmjTQ=S_bbGxu11O_scRa8GT7z6MXfJbfzfRg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Dec 2021 11:13:06 +0800
Message-ID: <CACGkMEukGbDcxJe3nGFkeBNenniJdMkFMRnrN4OOfDsCb7ZPuA@mail.gmail.com>
Subject: Re: [PATCH] virtio-net: make copy len check in xdp_linearize_page
To:     mengensun8801@gmail.com
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        mengensun <mengensun@tencent.com>,
        MengLong Dong <imagedong@tencent.com>,
        ZhengXiong Jiang <mungerjiang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 5:14 PM =E5=AD=99=E8=92=99=E6=81=A9 <mengensun8801@=
gmail.com> wrote:
>
> Jason Wang <jasowang@redhat.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=80 15:49=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Dec 13, 2021 at 12:50 PM <mengensun8801@gmail.com> wrote:
> > >
> > > From: mengensun <mengensun@tencent.com>
> > >
> > > xdp_linearize_page asume ring elem size is smaller then page size
> > > when copy the first ring elem, but, there may be a elem size bigger
> > > then page size.
> > >
> > > add_recvbuf_mergeable may add a hole to ring elem, the hole size is
> > > not sure, according EWMA.
> >
> > The logic is to try to avoid dropping packets in this case, so I
> > wonder if it's better to "fix" the add_recvbuf_mergeable().
>

Adding lists back.

> turn to XDP generic is so difficulty for me, here can "fix" the
> add_recvbuf_mergeable link follow:
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 36a4b7c195d5..06ce8bb10b47 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1315,6 +1315,7 @@ static int add_recvbuf_mergeable(struct virtnet_inf=
o *vi,
>                 alloc_frag->offset +=3D hole;
>         }
> +       len =3D min(len, PAGE_SIZE - room);
>         sg_init_one(rq->sg, buf, len);
>         ctx =3D mergeable_len_to_ctx(len, headroom);

Then the truesize here is wrong.

>         err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp)=
;
>
> it seems a rule that, length of elem giving to vring is away smaller
> or equall then PAGE_SIZE

It aims to be consistent to what EWMA tries to do:

        len =3D hdr_len + clamp_t(unsigned int, ewma_pkt_len_read(avg_pkt_l=
en),
                        rq->min_buf_len, PAGE_SIZE - hdr_len);

Thanks

>
> >
> > Or another idea is to switch to use XDP generic here where we can use
> > skb_linearize() which should be more robust and we can drop the
> > xdp_linearize_page() logic completely.
> >
> > Thanks
> >
> > >
> > > so, fix it by check copy len,if checked failed, just dropped the
> > > whole frame, not make the memory dirty after the page.
> > >
> > > Signed-off-by: mengensun <mengensun@tencent.com>
> > > Reviewed-by: MengLong Dong <imagedong@tencent.com>
> > > Reviewed-by: ZhengXiong Jiang <mungerjiang@tencent.com>
> > > ---
> > >  drivers/net/virtio_net.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 36a4b7c195d5..844bdbd67ff7 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -662,8 +662,12 @@ static struct page *xdp_linearize_page(struct re=
ceive_queue *rq,
> > >                                        int page_off,
> > >                                        unsigned int *len)
> > >  {
> > > -       struct page *page =3D alloc_page(GFP_ATOMIC);
> > > +       struct page *page;
> > >
> > > +       if (*len > PAGE_SIZE - page_off)
> > > +               return NULL;
> > > +
> > > +       page =3D alloc_page(GFP_ATOMIC);
> > >         if (!page)
> > >                 return NULL;
> > >
> > > --
> > > 2.27.0
> > >
> >
>

