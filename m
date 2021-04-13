Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BF235E149
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhDMOVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhDMOVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 10:21:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F982C061756
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:21:21 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id e14so26187104ejz.11
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XSb26jWChq8UeB+2eG8t5Jx3KUuQ9YtghNH+PRQLkiY=;
        b=k3pN5OC9G/4r78rKs51gKlPvO4wrZICaChTRKTnSRjLSywsKf07n6zNAkTF9Ne1o4d
         +jFK5LbkH7qequCu3zp6PMfMIm0ZOqF5tQlMU0FGle1bTjVZLJYlQJqn4U8NEhpucNnK
         upY+Bcj95F9aZorRKFwRu8uZpDWhTgjb1el7yjPiVJflv59Bpb45WnIk5jmJLP0/WSUJ
         BbJ41+ChRp+bHpKKF3AwHOPh6M4x+EpQpr9PBhRcCxneHRBxhfbLih/fLud/nBSq/lr7
         WMnE0Jd8qUIx5+9/WdOvi8uPusmIJAX0Vwg0Ct7EoqfpeCxI/6a+2yov8TTZQDnLK2L4
         yoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XSb26jWChq8UeB+2eG8t5Jx3KUuQ9YtghNH+PRQLkiY=;
        b=BfS3WCUmod4r6jbEvLTt1Gocbhzp8OZgEEP+IJ0xUxGWrPv4+0YBLsl0r85qSVW5LM
         1H8a463VMDAPeyAxRq/iw20pf7aoKro/YBIN/xSgaFspK4hpuhzxwrk9dw3wCY+7yiIo
         p8uH7fCRcnIKXXzo0IMu2PV4zoLxqIT8MIFvJgUd6ilpqXTSfz3tOHqrg+b2BGpwKQoU
         9XvErg3oU7pnOXvoPJh5Jou8mVLHwgx0/TWIUGM57/RlHv36M6nYfrC7MOeYtjOPvdi7
         C1BK/qUGMLwJG32yKHQheRNghRx7mTBaj/Dh1/SDZ4vF2JdIARzk6haIy41Q8jkg31OE
         EVHg==
X-Gm-Message-State: AOAM530BYk9nfQY12BfnRDAHFXo9RlQtZ2nJ0Cm51iNsbjxng0WpRaEY
        6SO7JmXnggieaTmIIThZvL2+cZnUkyLPqA==
X-Google-Smtp-Source: ABdhPJyf7ZWt+E0+TQi9Pzp0rEzza3rIyiqv6BWUfrqm+X5RBg7URda1wTlzKHgET4tRod/4wFg1HQ==
X-Received: by 2002:a17:906:37da:: with SMTP id o26mr13624741ejc.413.1618323679389;
        Tue, 13 Apr 2021 07:21:19 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id a9sm9722156eda.13.2021.04.13.07.21.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 07:21:18 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id x7so16637316wrw.10
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 07:21:17 -0700 (PDT)
X-Received: by 2002:a5d:510d:: with SMTP id s13mr37457079wrt.12.1618323677563;
 Tue, 13 Apr 2021 07:21:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210413054733.36363-1-mst@redhat.com> <20210413054733.36363-4-mst@redhat.com>
 <805053bf-960f-3c34-ce23-012d121ca937@redhat.com> <20210413100222-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210413100222-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 13 Apr 2021 10:20:39 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe=3cAkhwjSDDt1U8mSiVj5BKgJ7DJGxAAoF22kac3CMQ@mail.gmail.com>
Message-ID: <CA+FuTSe=3cAkhwjSDDt1U8mSiVj5BKgJ7DJGxAAoF22kac3CMQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/4] virtio_net: move tx vq operation under tx
 queue lock
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 10:03 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Apr 13, 2021 at 04:54:42PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/4/13 =E4=B8=8B=E5=8D=881:47, Michael S. Tsirkin =E5=86=
=99=E9=81=93:
> > > It's unsafe to operate a vq from multiple threads.
> > > Unfortunately this is exactly what we do when invoking
> > > clean tx poll from rx napi.

Actually, the issue goes back to the napi-tx even without the
opportunistic cleaning from the receive interrupt, I think? That races
with processing the vq in start_xmit.

> > > As a fix move everything that deals with the vq to under tx lock.
> > >

If the above is correct:

Fixes: b92f1e6751a6 ("virtio-net: transmit napi")

> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >   drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
> > >   1 file changed, 21 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 16d5abed582c..460ccdbb840e 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1505,6 +1505,8 @@ static int virtnet_poll_tx(struct napi_struct *=
napi, int budget)
> > >     struct virtnet_info *vi =3D sq->vq->vdev->priv;
> > >     unsigned int index =3D vq2txq(sq->vq);
> > >     struct netdev_queue *txq;
> > > +   int opaque;

nit: virtqueue_napi_complete also stores as int opaque, but
virtqueue_enable_cb_prepare actually returns, and virtqueue_poll
expects, an unsigned int. In the end, conversion works correctly. But
cleaner to use the real type.

> > > +   bool done;
> > >     if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
> > >             /* We don't need to enable cb for XDP */
> > > @@ -1514,10 +1516,28 @@ static int virtnet_poll_tx(struct napi_struct=
 *napi, int budget)
> > >     txq =3D netdev_get_tx_queue(vi->dev, index);
> > >     __netif_tx_lock(txq, raw_smp_processor_id());
> > > +   virtqueue_disable_cb(sq->vq);
> > >     free_old_xmit_skbs(sq, true);
> > > +
> > > +   opaque =3D virtqueue_enable_cb_prepare(sq->vq);
> > > +
> > > +   done =3D napi_complete_done(napi, 0);
> > > +
> > > +   if (!done)
> > > +           virtqueue_disable_cb(sq->vq);
> > > +
> > >     __netif_tx_unlock(txq);
> > > -   virtqueue_napi_complete(napi, sq->vq, 0);
> >
> >
> > So I wonder why not simply move __netif_tx_unlock() after
> > virtqueue_napi_complete()?
> >
> > Thanks
> >
>
>
> Because that calls tx poll which also takes tx lock internally ...

which tx poll?
