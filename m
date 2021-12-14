Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13776473BB4
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhLNDsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhLNDsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:48:19 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B10BC061574;
        Mon, 13 Dec 2021 19:48:18 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id p8so26532873ljo.5;
        Mon, 13 Dec 2021 19:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cus1JSDA6lu5160W0ceTmY9ZQw4KMjEyG5+ikSOQLMY=;
        b=dafqXCXE1fKDSsjwgxDFdzMqV40Dmsz/7kZCrBA8QnieeZv8OcKxEAAFKYOUXFBDmj
         8V09uscqXvHoub0qmcOJOdtv/69hhhPjdGd0wxG3gR2IItCdWy+moBmq1lbiCnfNkcBe
         +nzsDtzhSektELYw3LH1Z86TazftveVqeeedEzB9LemL4P/mMKHWi8jZwUOzH11DB+0Y
         ngSpkWvVM1FmTPvy/WMHh26Noon5fRnN8kVtqhM7qfX3FwG3UjIJmXOR5aGU2Qt8+iOd
         rvBx+HRiwNvq2VegbeyWprXsXx8rbHikeEnroJCE/0IuPGEmX8JVDA2zkTP0rlHqHNjG
         lzCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cus1JSDA6lu5160W0ceTmY9ZQw4KMjEyG5+ikSOQLMY=;
        b=wCSD+RM137EDYZJj4erPQD4we2cybluLUKTizro35CxdPXDgU+RbvijYxyiN5Uk9eo
         fm6CN86ldHNMUTKLmfwAMFQ9ZW5cj7iFJTrqdBFOCg4j0ULFOxnkaf1xoxgslFeWIIqJ
         BprVf4ztIXH57x8eeJYOAYPkc0T/97zNq7tbnHZDBzqH+02X3bDCGbDu3Jp0MldamvPs
         GpupCEtomGBbuwv1giS9FEfkHJCgSZe9Pxbn1zPlhr8FRSJDJVNXG5SV7uRYHAo032vW
         UDCRw6/ATHQAUfAdXNJ3KRkvutn5F8QempRy4G/sPs0KPuRZIzuRvi4cmYhguQXEyA84
         7atA==
X-Gm-Message-State: AOAM532HYhszUVWHNmZ0NKm2YnnpGHEOohJeK6hsZ8hdhuKZK5i3Mdmh
        9mDfIY+aPbinvnElyGXHto4IciObwh8qLVwEhRP6TYHJ9ubTWFfo
X-Google-Smtp-Source: ABdhPJxnFzZGuFxB1MFyVUE0juXSNl2EYMm498nJxcvxtDdETF/71d4Cz4tpWujy7IFvbZO+RqbT+cEQHfTywLyZPHE=
X-Received: by 2002:a05:651c:205:: with SMTP id y5mr2448746ljn.386.1639453696865;
 Mon, 13 Dec 2021 19:48:16 -0800 (PST)
MIME-Version: 1.0
References: <20211213045012.12757-1-mengensun@tencent.com> <CACGkMEtLso8QjvmjTQ=S_bbGxu11O_scRa8GT7z6MXfJbfzfRg@mail.gmail.com>
 <CACGkMEukGbDcxJe3nGFkeBNenniJdMkFMRnrN4OOfDsCb7ZPuA@mail.gmail.com>
In-Reply-To: <CACGkMEukGbDcxJe3nGFkeBNenniJdMkFMRnrN4OOfDsCb7ZPuA@mail.gmail.com>
From:   =?UTF-8?B?5a2Z6JKZ5oGp?= <mengensun8801@gmail.com>
Date:   Tue, 14 Dec 2021 11:48:05 +0800
Message-ID: <CA+K-gpUBSB0_gX2r7Xi7b6SxrbQApNpneQu_bLAR+e1ALOUwYw@mail.gmail.com>
Subject: Re: [PATCH] virtio-net: make copy len check in xdp_linearize_page
To:     Jason Wang <jasowang@redhat.com>
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

Jason Wang <jasowang@redhat.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=8814=E6=97=
=A5=E5=91=A8=E4=BA=8C 11:13=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Dec 13, 2021 at 5:14 PM =E5=AD=99=E8=92=99=E6=81=A9 <mengensun880=
1@gmail.com> wrote:
> >
> > Jason Wang <jasowang@redhat.com> =E4=BA=8E2021=E5=B9=B412=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=80 15:49=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Mon, Dec 13, 2021 at 12:50 PM <mengensun8801@gmail.com> wrote:
> > > >
> > > > From: mengensun <mengensun@tencent.com>
> > > >
> > > > xdp_linearize_page asume ring elem size is smaller then page size
> > > > when copy the first ring elem, but, there may be a elem size bigger
> > > > then page size.
> > > >
> > > > add_recvbuf_mergeable may add a hole to ring elem, the hole size is
> > > > not sure, according EWMA.
> > >
> > > The logic is to try to avoid dropping packets in this case, so I
> > > wonder if it's better to "fix" the add_recvbuf_mergeable().
> >
>
> Adding lists back.
>
> > turn to XDP generic is so difficulty for me, here can "fix" the
> > add_recvbuf_mergeable link follow:
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 36a4b7c195d5..06ce8bb10b47 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1315,6 +1315,7 @@ static int add_recvbuf_mergeable(struct virtnet_i=
nfo *vi,
> >                 alloc_frag->offset +=3D hole;
> >         }
> > +       len =3D min(len, PAGE_SIZE - room);
> >         sg_init_one(rq->sg, buf, len);
> >         ctx =3D mergeable_len_to_ctx(len, headroom);
>
> Then the truesize here is wrong.
many thanks!! i have  known i'm wrong immediately after click the
"send" botton , now, this problem seem not only about the *hole* but
the  EWMA, EWMA will give buff len bewteen min_buf_len and PAGE_SIZE,
while swith from no-attach-xdp to attach xdp, there may be some buff
already in ring and filled before xdp attach. xdp_linearize_page
assume buf size is PAGE_SIZE - VIRTIO_XDP_HEADROOM, and coped "len"
from the buff, while the buff may be **PAGE_SIZE**

because we have no idear when the user attach xdp prog, so, i have no
idear except make all the buff have a "header hole" len of
VIRTIO_XDP_HEADROOM(128), but it seem so expensive for no-xdp-attach
virtio eth to aways leave 128 byte not used at all.

this problem is found by review code, in really test, it seemed not so
may big frame. so here we can just "fix" the  xdp_linearize_page, make
it trying best to not drop frames for now?

btw,  it seem no way to fix this thoroughly, except we drained all the
buff in the ring, and flush it all to "xdp buff" when attaching xdp
prog.

is that some mistake i have makeed again? #^_^

>
>
> >         err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gf=
p);
> >
> > it seems a rule that, length of elem giving to vring is away smaller
> > or equall then PAGE_SIZE
>
> It aims to be consistent to what EWMA tries to do:
>
>         len =3D hdr_len + clamp_t(unsigned int, ewma_pkt_len_read(avg_pkt=
_len),
>                         rq->min_buf_len, PAGE_SIZE - hdr_len);
>
> Thanks
>
> >
> > >
> > > Or another idea is to switch to use XDP generic here where we can use
> > > skb_linearize() which should be more robust and we can drop the
> > > xdp_linearize_page() logic completely.
> > >
> > > Thanks
> > >
> > > >
> > > > so, fix it by check copy len,if checked failed, just dropped the
> > > > whole frame, not make the memory dirty after the page.
> > > >
> > > > Signed-off-by: mengensun <mengensun@tencent.com>
> > > > Reviewed-by: MengLong Dong <imagedong@tencent.com>
> > > > Reviewed-by: ZhengXiong Jiang <mungerjiang@tencent.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 6 +++++-
> > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 36a4b7c195d5..844bdbd67ff7 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -662,8 +662,12 @@ static struct page *xdp_linearize_page(struct =
receive_queue *rq,
> > > >                                        int page_off,
> > > >                                        unsigned int *len)
> > > >  {
> > > > -       struct page *page =3D alloc_page(GFP_ATOMIC);
> > > > +       struct page *page;
> > > >
> > > > +       if (*len > PAGE_SIZE - page_off)
> > > > +               return NULL;
> > > > +
> > > > +       page =3D alloc_page(GFP_ATOMIC);
> > > >         if (!page)
> > > >                 return NULL;
> > > >
> > > > --
> > > > 2.27.0
> > > >
> > >
> >
>
