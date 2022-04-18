Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0A4504D4D
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 09:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiDRHwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 03:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiDRHwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 03:52:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADE00FD
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 00:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650268184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnfv0wNYltyi7i75x7CfPVfEPHaNVts12r24quKUZeE=;
        b=WjB26+Mn/fnqBBggxM8fnoXs2Lt8FnEK07yw1GRtE31ArObCIkzGkPk7HLwtkLLDZE7jGT
        KiPTGtFfHK9Y7eX9e4RlLTssnlKdy2toTKaIgjWeA4u948jWLGT5ql6rT6IU4rl0XMsWCi
        de04L0/PLW2ylR6uwrv8NEEA62GKsaI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-AwxkpiNqOk2lUgR0wpLvyw-1; Mon, 18 Apr 2022 03:49:42 -0400
X-MC-Unique: AwxkpiNqOk2lUgR0wpLvyw-1
Received: by mail-lf1-f69.google.com with SMTP id h6-20020a056512054600b00470f22148aeso1211437lfl.10
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 00:49:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mnfv0wNYltyi7i75x7CfPVfEPHaNVts12r24quKUZeE=;
        b=5v28iazrDyDwCU80ZX25A7RzTTcLn9abTSzRXW0C7/gXUmsmxWVW13QCyjiEbRs+j1
         jBAjGvc3mCDrS5vJWiyp+Aq+sGMaoJSNVgAdGPY1OAogiHBESzd7NupnYH3aReinlXyT
         wOxfzbelpcaiuawTTQoE2iBeK4uAbKlJzkSs9I1fvIbULUE0jcMhulufR5Sndosb7kBe
         okE8cJmFvYvQMFj26WzjVeUzTUFbiJNAvfmR6AtVbq+CQVBiAQuvNQwUHAGdzt2vTV0D
         ycRPbaZyKYbPpNt6uAXH6MKp8B6gJO10mNC/NKnxCyG18hwFYgwMzE8zjEJh/uYmXIwa
         LetQ==
X-Gm-Message-State: AOAM531zx9SIYg5C7CA1zZeA1Syl9C9qterAelutPtJDZwE4ULwq2wl7
        9R7tBwoCGsI1nidKY0Y+asW1sEV45y2rhZ1LugW5fZcIUh0exKpMW+Lng0To8bh6fvQbWwX22vW
        Yxbkf9dlZD8JQh5pjC2huAz/8YOjl9ZU3
X-Received: by 2002:a05:6512:33c5:b0:46b:af94:55f4 with SMTP id d5-20020a05651233c500b0046baf9455f4mr7367176lfg.98.1650268181317;
        Mon, 18 Apr 2022 00:49:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLtmsnyubTWj2Yy6V283b2x4yR5RwYa5Rj8a/3qzc1lPd7gSTeVjA3xFAfIb7AgFuIOEEkBJncBR9AcK6VPes=
X-Received: by 2002:a05:6512:33c5:b0:46b:af94:55f4 with SMTP id
 d5-20020a05651233c500b0046baf9455f4mr7367160lfg.98.1650268181074; Mon, 18 Apr
 2022 00:49:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-32-xuanzhuo@linux.alibaba.com> <122008a6-1e79-14d3-1478-59f96464afc9@redhat.com>
 <1650252077.7934203-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1650252077.7934203-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 18 Apr 2022 15:49:29 +0800
Message-ID: <CACGkMEtZOJ2PCsJidDcFKL57Q6oLHk4TH7xtewrLCTFhrbXSAA@mail.gmail.com>
Subject: Re: [PATCH v9 31/32] virtio_net: support rx/tx queue resize
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 11:24 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wro=
te:
>
> On Wed, 13 Apr 2022 16:00:18 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> >
> > =E5=9C=A8 2022/4/6 =E4=B8=8A=E5=8D=8811:43, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > This patch implements the resize function of the rx, tx queues.
> > > Based on this function, it is possible to modify the ring num of the
> > > queue.
> > >
> > > There may be an exception during the resize process, the resize may
> > > fail, or the vq can no longer be used. Either way, we must execute
> > > napi_enable(). Because napi_disable is similar to a lock, napi_enable
> > > must be called after calling napi_disable.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >   drivers/net/virtio_net.c | 81 +++++++++++++++++++++++++++++++++++++=
+++
> > >   1 file changed, 81 insertions(+)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index b8bf00525177..ba6859f305f7 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -251,6 +251,9 @@ struct padded_vnet_hdr {
> > >     char padding[4];
> > >   };
> > >
> > > +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *b=
uf);
> > > +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *b=
uf);
> > > +
> > >   static bool is_xdp_frame(void *ptr)
> > >   {
> > >     return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > @@ -1369,6 +1372,15 @@ static void virtnet_napi_enable(struct virtque=
ue *vq, struct napi_struct *napi)
> > >   {
> > >     napi_enable(napi);
> > >
> > > +   /* Check if vq is in reset state. The normal reset/resize process=
 will
> > > +    * be protected by napi. However, the protection of napi is only =
enabled
> > > +    * during the operation, and the protection of napi will end afte=
r the
> > > +    * operation is completed. If re-enable fails during the process,=
 vq
> > > +    * will remain unavailable with reset state.
> > > +    */
> > > +   if (vq->reset)
> > > +           return;
> >
> >
> > I don't get when could we hit this condition.
> >
> >
> > > +
> > >     /* If all buffers were filled by other side before we napi_enable=
d, we
> > >      * won't get another interrupt, so process any outstanding packet=
s now.
> > >      * Call local_bh_enable after to trigger softIRQ processing.
> > > @@ -1413,6 +1425,15 @@ static void refill_work(struct work_struct *wo=
rk)
> > >             struct receive_queue *rq =3D &vi->rq[i];
> > >
> > >             napi_disable(&rq->napi);
> > > +
> > > +           /* Check if vq is in reset state. See more in
> > > +            * virtnet_napi_enable()
> > > +            */
> > > +           if (rq->vq->reset) {
> > > +                   virtnet_napi_enable(rq->vq, &rq->napi);
> > > +                   continue;
> > > +           }
> >
> >
> > Can we do something similar in virtnet_close() by canceling the work?
> >
> >
> > > +
> > >             still_empty =3D !try_fill_recv(vi, rq, GFP_KERNEL);
> > >             virtnet_napi_enable(rq->vq, &rq->napi);
> > >
> > > @@ -1523,6 +1544,10 @@ static void virtnet_poll_cleantx(struct receiv=
e_queue *rq)
> > >     if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
> > >             return;
> > >
> > > +   /* Check if vq is in reset state. See more in virtnet_napi_enable=
() */
> > > +   if (sq->vq->reset)
> > > +           return;
> >
> >
> > We've disabled TX napi, any chance we can still hit this?
>
>
> static int virtnet_poll(struct napi_struct *napi, int budget)
> {
>         struct receive_queue *rq =3D
>                 container_of(napi, struct receive_queue, napi);
>         struct virtnet_info *vi =3D rq->vq->vdev->priv;
>         struct send_queue *sq;
>         unsigned int received;
>         unsigned int xdp_xmit =3D 0;
>
>         virtnet_poll_cleantx(rq);
> ...
> }
>
> This is called by rx poll. Although it is the logic of tx, it is not driv=
en by
> tx napi, but is called in rx poll.

Ok, but we need guarantee the memory ordering in this case. Disable RX
napi could be a solution for this.

Thanks

>
> Thanks.
>
>
> >
> >
> > > +
> > >     if (__netif_tx_trylock(txq)) {
> > >             do {
> > >                     virtqueue_disable_cb(sq->vq);
> > > @@ -1769,6 +1794,62 @@ static netdev_tx_t start_xmit(struct sk_buff *=
skb, struct net_device *dev)
> > >     return NETDEV_TX_OK;
> > >   }
> > >
> > > +static int virtnet_rx_resize(struct virtnet_info *vi,
> > > +                        struct receive_queue *rq, u32 ring_num)
> > > +{
> > > +   int err;
> > > +
> > > +   napi_disable(&rq->napi);
> > > +
> > > +   err =3D virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused=
_buf);
> > > +   if (err)
> > > +           goto err;
> > > +
> > > +   if (!try_fill_recv(vi, rq, GFP_KERNEL))
> > > +           schedule_delayed_work(&vi->refill, 0);
> > > +
> > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > +   return 0;
> > > +
> > > +err:
> > > +   netdev_err(vi->dev,
> > > +              "reset rx reset vq fail: rx queue index: %td err: %d\n=
",
> > > +              rq - vi->rq, err);
> > > +   virtnet_napi_enable(rq->vq, &rq->napi);
> > > +   return err;
> > > +}
> > > +
> > > +static int virtnet_tx_resize(struct virtnet_info *vi,
> > > +                        struct send_queue *sq, u32 ring_num)
> > > +{
> > > +   struct netdev_queue *txq;
> > > +   int err, qindex;
> > > +
> > > +   qindex =3D sq - vi->sq;
> > > +
> > > +   virtnet_napi_tx_disable(&sq->napi);
> > > +
> > > +   txq =3D netdev_get_tx_queue(vi->dev, qindex);
> > > +   __netif_tx_lock_bh(txq);
> > > +   netif_stop_subqueue(vi->dev, qindex);
> > > +   __netif_tx_unlock_bh(txq);
> > > +
> > > +   err =3D virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused=
_buf);
> > > +   if (err)
> > > +           goto err;
> > > +
> > > +   netif_start_subqueue(vi->dev, qindex);
> > > +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > > +   return 0;
> > > +
> > > +err:
> >
> >
> > I guess we can still start the queue in this case? (Since we don't
> > change the queue if resize fails).
> >
> >
> > > +   netdev_err(vi->dev,
> > > +              "reset tx reset vq fail: tx queue index: %td err: %d\n=
",
> > > +              sq - vi->sq, err);
> > > +   virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> > > +   return err;
> > > +}
> > > +
> > >   /*
> > >    * Send command via the control virtqueue and check status.  Comman=
ds
> > >    * supported by the hypervisor, as indicated by feature bits, shoul=
d
> >
>

