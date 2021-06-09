Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6363A1FB9
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhFIWGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59713 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230164AbhFIWGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623276246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j1+XTsbXIi8UuChDa/DLFwX5AWXjYwtgSyXqS9K71x0=;
        b=JwW8mAm+dI9FoP2yORK73LfIscqBg4kiPaw4ji+QoCRg7nETTy061Y70X+5gHYMXjqQJzf
        tZESdh8OwTFQ67ufBaqcvzW1IAuhj29QEwovOeR6x9yhCbYeUMgbsUqLTm/BY31lH4PkqC
        eT4eniOGTimyWPmiIiMxEOLj+uODlAQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-rht2ax13PD2p4o7hfvlNdw-1; Wed, 09 Jun 2021 18:04:05 -0400
X-MC-Unique: rht2ax13PD2p4o7hfvlNdw-1
Received: by mail-wr1-f70.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so11093180wrb.3
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=j1+XTsbXIi8UuChDa/DLFwX5AWXjYwtgSyXqS9K71x0=;
        b=AB5z9Y5f587XO9gQajfyt1q305PMAeoNDRe2MoubhzxraslG3UkCsBj7iSbAbTuI8m
         h1PpUlnCez/QnWP3yNJnNu0Wo2faNe1ffrm06obK9DGebTSzo2kabFSAGrHL41w2haE1
         foobe7MmWC1h8jVIiOUZagJcc6jUS/MPoXZkohFCggusAG5gw1GY5AzMoMCjAKOePnxv
         tntJ+s6EtB1a0DMFS0EnxLyj7rZhSHSbHWCQ5AsvDLQFVy623eKQD7vbP9dKzyNGFrdK
         yIf6ok4PyNoF0aFNdhz6j2bmHsxbEGz/5eTLhaSKymJ3ttf3W+1O83+1WytsVmDemdlK
         TBmA==
X-Gm-Message-State: AOAM531fkHImgW/wNVQLhG77KClYvtbRpShBQxHPgIMKG5J2O5X5NCdY
        XqaY6583RdQwKsSnOCpc3sc3P6CT79eIe3FfkLYFbGgzDhv0j2ulvF1+MexgHuO4KtBkYkF6KrU
        nn7U0jfiLwXTUSKTX
X-Received: by 2002:a5d:4dc4:: with SMTP id f4mr1900436wru.181.1623276244155;
        Wed, 09 Jun 2021 15:04:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyK42aoT4mhmfnQnZDmX/DrUajp6FnM5dO8sLjvfv72GrDAnSKuoWe58PgmSU6TZ6TX/JJLgQ==
X-Received: by 2002:a5d:4dc4:: with SMTP id f4mr1900412wru.181.1623276243908;
        Wed, 09 Jun 2021 15:04:03 -0700 (PDT)
Received: from redhat.com ([77.124.100.105])
        by smtp.gmail.com with ESMTPSA id m23sm8920358wml.27.2021.06.09.15.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:04:03 -0700 (PDT)
Date:   Wed, 9 Jun 2021 18:03:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v3 1/4] virtio_net: move tx vq operation under tx queue
 lock
Message-ID: <20210609175825-mutt-send-email-mst@kernel.org>
References: <20210526082423.47837-1-mst@redhat.com>
 <20210526082423.47837-2-mst@redhat.com>
 <476e9418-156d-dbc9-5105-11d2816b95f7@redhat.com>
 <CA+FuTSccMS4qEyexAuzjcuevS8KwaruJih5_0hgiOFz4BpDHzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTSccMS4qEyexAuzjcuevS8KwaruJih5_0hgiOFz4BpDHzA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 06:25:11PM -0400, Willem de Bruijn wrote:
> On Wed, May 26, 2021 at 11:41 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > 在 2021/5/26 下午4:24, Michael S. Tsirkin 写道:
> > > It's unsafe to operate a vq from multiple threads.
> > > Unfortunately this is exactly what we do when invoking
> > > clean tx poll from rx napi.
> > > Same happens with napi-tx even without the
> > > opportunistic cleaning from the receive interrupt: that races
> > > with processing the vq in start_xmit.
> > >
> > > As a fix move everything that deals with the vq to under tx lock.
> 
> This patch also disables callbacks during free_old_xmit_skbs
> processing on tx interrupt. Should that be a separate commit, with its
> own explanation?
> > >
> > > Fixes: b92f1e6751a6 ("virtio-net: transmit napi")
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >   drivers/net/virtio_net.c | 22 +++++++++++++++++++++-
> > >   1 file changed, 21 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index ac0c143f97b4..12512d1002ec 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1508,6 +1508,8 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> > >       struct virtnet_info *vi = sq->vq->vdev->priv;
> > >       unsigned int index = vq2txq(sq->vq);
> > >       struct netdev_queue *txq;
> > > +     int opaque;
> > > +     bool done;
> > >
> > >       if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
> > >               /* We don't need to enable cb for XDP */
> > > @@ -1517,10 +1519,28 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> > >
> > >       txq = netdev_get_tx_queue(vi->dev, index);
> > >       __netif_tx_lock(txq, raw_smp_processor_id());
> > > +     virtqueue_disable_cb(sq->vq);
> > >       free_old_xmit_skbs(sq, true);
> > > +
> > > +     opaque = virtqueue_enable_cb_prepare(sq->vq);
> > > +
> > > +     done = napi_complete_done(napi, 0);
> > > +
> > > +     if (!done)
> > > +             virtqueue_disable_cb(sq->vq);
> > > +
> > >       __netif_tx_unlock(txq);
> > >
> > > -     virtqueue_napi_complete(napi, sq->vq, 0);
> > > +     if (done) {
> > > +             if (unlikely(virtqueue_poll(sq->vq, opaque))) {
> 
> Should this also be inside the lock, as it operates on vq?

No vq poll is ok outside of locks, it's atomic.

> Is there anything that is not allowed to run with the lock held?
> > > +                     if (napi_schedule_prep(napi)) {
> > > +                             __netif_tx_lock(txq, raw_smp_processor_id());
> > > +                             virtqueue_disable_cb(sq->vq);
> > > +                             __netif_tx_unlock(txq);
> > > +                             __napi_schedule(napi);
> > > +                     }
> > > +             }
> > > +     }
> >
> >
> > Interesting, this looks like somehwo a open-coded version of
> > virtqueue_napi_complete(). I wonder if we can simply keep using
> > virtqueue_napi_complete() by simply moving the __netif_tx_unlock() after
> > that:
> >
> > netif_tx_lock(txq);
> > free_old_xmit_skbs(sq, true);
> > virtqueue_napi_complete(napi, sq->vq, 0);
> > __netif_tx_unlock(txq);
> 
> Agreed. And subsequent block
> 
>        if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>                netif_tx_wake_queue(txq);
> 
> as well

Yes I thought I saw something here that can't be called with tx lock
held but I no longer see it. Will do.

> >
> > Thanks
> >
> >
> > >
> > >       if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
> > >               netif_tx_wake_queue(txq);
> >

