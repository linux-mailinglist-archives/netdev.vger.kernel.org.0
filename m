Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026F8473D0A
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 07:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhLNGPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 01:15:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230362AbhLNGPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 01:15:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639462513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YwugZBIsB9O3b1tEKG2yDl1lfnlqxf61JgJVJ0aWmUQ=;
        b=Vk2++8tnyfBAP4YnUTj+Dm5WH1aP9yxSgCu5lPLv1iQisZFEJ2QU8AzLsldHM9XQfP9/9n
        XNGMvo2VNxTwqU5KzsEsfCqp2/+vFGpmTrQXyixte8IlX9VFVihFgMwc1AR/Gkb6chkcpz
        2RprZaKhno5bxeXV2GS95msHLpFksbE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-yuK4xPePPDKES718qY1CvA-1; Tue, 14 Dec 2021 01:15:11 -0500
X-MC-Unique: yuK4xPePPDKES718qY1CvA-1
Received: by mail-lf1-f71.google.com with SMTP id u20-20020a056512129400b0040373ffc60bso8494572lfs.15
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 22:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YwugZBIsB9O3b1tEKG2yDl1lfnlqxf61JgJVJ0aWmUQ=;
        b=ksTWvtFO0jlA85hHqjQP+v7fYpaxZCNLvZZQuKUC05+vRNyqe4JcGo18xzbLDWkvdR
         HnY4Zf6HBTd92Ai/TnqaOC5YQydyDvMAMmLeu1rNpkRYVVR+FXrOlqHRUCfgV1ZvbPXj
         En/bU2X758TSr6cm2pfNCM19tvh19fsEGXgiNwFQxZ3eUh3WbAEOr7PuKTMHeFax9Gis
         8DWPAtIGwMKK2PE/bBQpTOEAqT41gzzl/Uum1IoydQ3y/fixEL2UzqYmjvyNeh+YfUHW
         1Pdboh/CbneCLeeh3awfQVTFq62tLW7Me0utV7R+TZKBoQuw6pCJE/S8a4n7kdDTdy2C
         /6pw==
X-Gm-Message-State: AOAM532vdwbiWAp9lW+KD13i80bjfyjfhoYB3O4w4R5JLd10PPGcYt7x
        ABdupWVvTzeDKKFtmWeHwR0SBdbtnw9zQLX9P/ZfuWKWzk1xFxgxSe2QcuiB0vDjZ41GA1XClGK
        rDSQR74/OFmnuEKmG3wpyraWZstHCVLgn
X-Received: by 2002:a2e:3012:: with SMTP id w18mr2978395ljw.217.1639462510174;
        Mon, 13 Dec 2021 22:15:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwqenw88BrR2D6Qt+sGpTwBW3+xZwJrfzDxCVORbTErFH0MhwcnexNkpqOBvtu367RvJ0qUvX4Rn9Ui+iPKu5s=
X-Received: by 2002:a2e:3012:: with SMTP id w18mr2978375ljw.217.1639462509908;
 Mon, 13 Dec 2021 22:15:09 -0800 (PST)
MIME-Version: 1.0
References: <20211213045012.12757-1-mengensun@tencent.com> <CACGkMEtLso8QjvmjTQ=S_bbGxu11O_scRa8GT7z6MXfJbfzfRg@mail.gmail.com>
 <CACGkMEukGbDcxJe3nGFkeBNenniJdMkFMRnrN4OOfDsCb7ZPuA@mail.gmail.com> <CA+K-gpUBSB0_gX2r7Xi7b6SxrbQApNpneQu_bLAR+e1ALOUwYw@mail.gmail.com>
In-Reply-To: <CA+K-gpUBSB0_gX2r7Xi7b6SxrbQApNpneQu_bLAR+e1ALOUwYw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 14 Dec 2021 14:14:59 +0800
Message-ID: <CACGkMEtMcU6f+AD6+_cKuDpLTFgaBJura39j16PnKqGWB2fULA@mail.gmail.com>
Subject: Re: [PATCH] virtio-net: make copy len check in xdp_linearize_page
To:     =?UTF-8?B?5a2Z6JKZ5oGp?= <mengensun8801@gmail.com>
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

On Tue, Dec 14, 2021 at 11:48 AM =E5=AD=99=E8=92=99=E6=81=A9 <mengensun8801=
@gmail.com> wrote:
>
> Jason Wang <jasowang@redhat.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=8814=E6=
=97=A5=E5=91=A8=E4=BA=8C 11:13=E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Dec 13, 2021 at 5:14 PM =E5=AD=99=E8=92=99=E6=81=A9 <mengensun8=
801@gmail.com> wrote:
> > >
> > > Jason Wang <jasowang@redhat.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=8813=
=E6=97=A5=E5=91=A8=E4=B8=80 15:49=E5=86=99=E9=81=93=EF=BC=9A
> > > >
> > > > On Mon, Dec 13, 2021 at 12:50 PM <mengensun8801@gmail.com> wrote:
> > > > >
> > > > > From: mengensun <mengensun@tencent.com>
> > > > >
> > > > > xdp_linearize_page asume ring elem size is smaller then page size
> > > > > when copy the first ring elem, but, there may be a elem size bigg=
er
> > > > > then page size.
> > > > >
> > > > > add_recvbuf_mergeable may add a hole to ring elem, the hole size =
is
> > > > > not sure, according EWMA.
> > > >
> > > > The logic is to try to avoid dropping packets in this case, so I
> > > > wonder if it's better to "fix" the add_recvbuf_mergeable().
> > >
> >
> > Adding lists back.
> >
> > > turn to XDP generic is so difficulty for me, here can "fix" the
> > > add_recvbuf_mergeable link follow:
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 36a4b7c195d5..06ce8bb10b47 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1315,6 +1315,7 @@ static int add_recvbuf_mergeable(struct virtnet=
_info *vi,
> > >                 alloc_frag->offset +=3D hole;
> > >         }
> > > +       len =3D min(len, PAGE_SIZE - room);
> > >         sg_init_one(rq->sg, buf, len);
> > >         ctx =3D mergeable_len_to_ctx(len, headroom);
> >
> > Then the truesize here is wrong.
> many thanks!! i have  known i'm wrong immediately after click the
> "send" botton , now, this problem seem not only about the *hole* but
> the  EWMA, EWMA will give buff len bewteen min_buf_len and PAGE_SIZE,
> while swith from no-attach-xdp to attach xdp, there may be some buff
> already in ring and filled before xdp attach. xdp_linearize_page
> assume buf size is PAGE_SIZE - VIRTIO_XDP_HEADROOM, and coped "len"
> from the buff, while the buff may be **PAGE_SIZE**

So the issue I see is that though add_recvbuf_mergeable() tries to
make the buffer size is PAGE_SIZE, XDP might requires more on the
header which makes a single page is not sufficient.

>
> because we have no idear when the user attach xdp prog, so, i have no
> idear except make all the buff have a "header hole" len of
> VIRTIO_XDP_HEADROOM(128), but it seem so expensive for no-xdp-attach
> virtio eth to aways leave 128 byte not used at all.

That's an requirement for XDP header adjustment so far.

>
> this problem is found by review code, in really test, it seemed not so
> may big frame. so here we can just "fix" the  xdp_linearize_page, make
> it trying best to not drop frames for now?

I think you can reproduce the issue by keeping sending large frames to
guest and try to attach XDP in the middle.

>
> btw,  it seem no way to fix this thoroughly, except we drained all the
> buff in the ring, and flush it all to "xdp buff" when attaching xdp
> prog.
>
> is that some mistake i have makeed again? #^_^

I see two ways to solve this:

1) reverse more room (but not headerroom) to make sure PAGE_SIZE can
work in the case of linearizing
2) switch to use XDP genreic

2) looks much more easier, you may refer tun_xdp_one() to see how it
works, it's as simple as call do_xdp_generic()

Thanks

>
> >
> >
> > >         err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, =
gfp);
> > >
> > > it seems a rule that, length of elem giving to vring is away smaller
> > > or equall then PAGE_SIZE
> >
> > It aims to be consistent to what EWMA tries to do:
> >
> >         len =3D hdr_len + clamp_t(unsigned int, ewma_pkt_len_read(avg_p=
kt_len),
> >                         rq->min_buf_len, PAGE_SIZE - hdr_len);
> >
> > Thanks
> >
> > >
> > > >
> > > > Or another idea is to switch to use XDP generic here where we can u=
se
> > > > skb_linearize() which should be more robust and we can drop the
> > > > xdp_linearize_page() logic completely.
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > so, fix it by check copy len,if checked failed, just dropped the
> > > > > whole frame, not make the memory dirty after the page.
> > > > >
> > > > > Signed-off-by: mengensun <mengensun@tencent.com>
> > > > > Reviewed-by: MengLong Dong <imagedong@tencent.com>
> > > > > Reviewed-by: ZhengXiong Jiang <mungerjiang@tencent.com>
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 6 +++++-
> > > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 36a4b7c195d5..844bdbd67ff7 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -662,8 +662,12 @@ static struct page *xdp_linearize_page(struc=
t receive_queue *rq,
> > > > >                                        int page_off,
> > > > >                                        unsigned int *len)
> > > > >  {
> > > > > -       struct page *page =3D alloc_page(GFP_ATOMIC);
> > > > > +       struct page *page;
> > > > >
> > > > > +       if (*len > PAGE_SIZE - page_off)
> > > > > +               return NULL;
> > > > > +
> > > > > +       page =3D alloc_page(GFP_ATOMIC);
> > > > >         if (!page)
> > > > >                 return NULL;
> > > > >
> > > > > --
> > > > > 2.27.0
> > > > >
> > > >
> > >
> >
>

