Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98513948A9
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhE1W1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbhE1W13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 18:27:29 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E43C061574
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 15:25:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s6so6457376edu.10
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 15:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yrBjQ7Lx1mhxXojaT5BK59jpSBAfuzBAQF2fCcC/VrM=;
        b=h6xXfopGioGNYSxEvqJZc9IzxUg0PKrW0f6NrQBM5LMuFgYxxz4Jxs2hkpZTJvK2q5
         Ynt+/OYJSjOVrL2N4DQhWECVc0Xoj8LAQJLlc6pe5B1mJG2b2GL9fCq6c6ygw5XKMp1Y
         a8UR3mnNy7W81PZwBAVR8R+sJ+HAMFW6RNZmyUZ3mILH8440RvZBDM5ZDTjdEuVMQSNM
         M9epeJBfwuJIDQnwG5JQ15RGyb1fbg8PEuG/1LkmTctny74e/OObX0xSdWAylYSFOWOb
         puVHbeMRYyWz+hrlaNrjCP6cqXEvWX6gJmeRiy2LOED5wLI9RXd4LxMQs4vWGPDHM/lu
         MEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yrBjQ7Lx1mhxXojaT5BK59jpSBAfuzBAQF2fCcC/VrM=;
        b=XGXYrnT0fRW77WJ8f38uvOeX56Dy9ZHsaWzahqPSpKpdrtoetYt+nQSghh9aoTKZzx
         QA4NMCphiZrcM6brAclKlqu/g9zwyVDFIfHcwPMwCdUKdtd38GzpC5zH+fvUs7syVeAg
         4h83ZbeI/ZPSMFrGzB8mOpugBQvkfY2nnjPvRzGX19DhjnMq4K+opNGnXxZWmcDqUgrD
         z4ljvzKUOgfduum2jRwqc5mpNpopFAG+djnI84NmCkheMffNZMS5RLmlfW4vleMRHwe2
         DHoC/WO11ygAEjTTwNj6I50EIP7IgM4dqr+gCKURJMZVj32HYAxfbEuu7s96rjrPg4li
         ot0A==
X-Gm-Message-State: AOAM5325Q6XQGH6F74+NtYMiMdfZkDHpSae+HkaZdiFWnbRSqCnBEp/W
        180YPt37/rf65ARoCLXagBi/nlZ8bO4NuA==
X-Google-Smtp-Source: ABdhPJwjM7K2uyqsmkBfYCaxuwRaEuOB5329iyczTIiQeFDlPV5L7VPsmXQbmohw2URJ1kcnNYpaAg==
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr12386988edc.243.1622240752067;
        Fri, 28 May 2021 15:25:52 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id q16sm3302179edw.87.2021.05.28.15.25.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 15:25:49 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id m18so2892943wmq.0
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 15:25:49 -0700 (PDT)
X-Received: by 2002:a7b:c935:: with SMTP id h21mr2799976wml.183.1622240748511;
 Fri, 28 May 2021 15:25:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210526082423.47837-1-mst@redhat.com> <20210526082423.47837-2-mst@redhat.com>
 <476e9418-156d-dbc9-5105-11d2816b95f7@redhat.com>
In-Reply-To: <476e9418-156d-dbc9-5105-11d2816b95f7@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 May 2021 18:25:11 -0400
X-Gmail-Original-Message-ID: <CA+FuTSccMS4qEyexAuzjcuevS8KwaruJih5_0hgiOFz4BpDHzA@mail.gmail.com>
Message-ID: <CA+FuTSccMS4qEyexAuzjcuevS8KwaruJih5_0hgiOFz4BpDHzA@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] virtio_net: move tx vq operation under tx queue lock
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 11:41 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/26 =E4=B8=8B=E5=8D=884:24, Michael S. Tsirkin =E5=86=99=
=E9=81=93:
> > It's unsafe to operate a vq from multiple threads.
> > Unfortunately this is exactly what we do when invoking
> > clean tx poll from rx napi.
> > Same happens with napi-tx even without the
> > opportunistic cleaning from the receive interrupt: that races
> > with processing the vq in start_xmit.
> >
> > As a fix move everything that deals with the vq to under tx lock.

This patch also disables callbacks during free_old_xmit_skbs
processing on tx interrupt. Should that be a separate commit, with its
own explanation?
> >
> > Fixes: b92f1e6751a6 ("virtio-net: transmit napi")
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >   drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
> >   1 file changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index ac0c143f97b4..12512d1002ec 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1508,6 +1508,8 @@ static int virtnet_poll_tx(struct napi_struct *na=
pi, int budget)
> >       struct virtnet_info *vi =3D sq->vq->vdev->priv;
> >       unsigned int index =3D vq2txq(sq->vq);
> >       struct netdev_queue *txq;
> > +     int opaque;
> > +     bool done;
> >
> >       if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
> >               /* We don't need to enable cb for XDP */
> > @@ -1517,10 +1519,28 @@ static int virtnet_poll_tx(struct napi_struct *=
napi, int budget)
> >
> >       txq =3D netdev_get_tx_queue(vi->dev, index);
> >       __netif_tx_lock(txq, raw_smp_processor_id());
> > +     virtqueue_disable_cb(sq->vq);
> >       free_old_xmit_skbs(sq, true);
> > +
> > +     opaque =3D virtqueue_enable_cb_prepare(sq->vq);
> > +
> > +     done =3D napi_complete_done(napi, 0);
> > +
> > +     if (!done)
> > +             virtqueue_disable_cb(sq->vq);
> > +
> >       __netif_tx_unlock(txq);
> >
> > -     virtqueue_napi_complete(napi, sq->vq, 0);
> > +     if (done) {
> > +             if (unlikely(virtqueue_poll(sq->vq, opaque))) {

Should this also be inside the lock, as it operates on vq?

Is there anything that is not allowed to run with the lock held?

> > +                     if (napi_schedule_prep(napi)) {
> > +                             __netif_tx_lock(txq, raw_smp_processor_id=
());
> > +                             virtqueue_disable_cb(sq->vq);
> > +                             __netif_tx_unlock(txq);
> > +                             __napi_schedule(napi);
> > +                     }
> > +             }
> > +     }
>
>
> Interesting, this looks like somehwo a open-coded version of
> virtqueue_napi_complete(). I wonder if we can simply keep using
> virtqueue_napi_complete() by simply moving the __netif_tx_unlock() after
> that:
>
> netif_tx_lock(txq);
> free_old_xmit_skbs(sq, true);
> virtqueue_napi_complete(napi, sq->vq, 0);
> __netif_tx_unlock(txq);

Agreed. And subsequent block

       if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS)
               netif_tx_wake_queue(txq);

as well

>
> Thanks
>
>
> >
> >       if (sq->vq->num_free >=3D 2 + MAX_SKB_FRAGS)
> >               netif_tx_wake_queue(txq);
>
