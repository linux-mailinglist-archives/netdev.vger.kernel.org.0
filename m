Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED646575FC
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 12:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbiL1LpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 06:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiL1Lo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 06:44:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468C81178
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 03:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672227850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FPjY7Cy1Mg6WKTpNIpPpKalJWxGn29fqfriJCOyIl3w=;
        b=gjN9UxGHIFaaH6l56b1ZP7HQRwowZ70NYbupud6Wr8HrKKdV6gOmRhf4s9CUvy2tj7Vhh1
        F2YBVxhf97Zptasr9+ZnCfxP7tfaRW+WVsyQwYvpS5/EghZUmejGvjFFSnKbFOfh8GMd5F
        YA60Hr1MVFlUynK1+0juhGJBh11AI+g=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-539-a8fSF1upMda4JlgZc_JnXA-1; Wed, 28 Dec 2022 06:44:08 -0500
X-MC-Unique: a8fSF1upMda4JlgZc_JnXA-1
Received: by mail-oi1-f197.google.com with SMTP id l21-20020a544115000000b0035e40187b9eso2556077oic.22
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 03:44:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FPjY7Cy1Mg6WKTpNIpPpKalJWxGn29fqfriJCOyIl3w=;
        b=pNtyRVudLou9AV9qdlFnl0ygZMqWBW/2XJkaTAEL1vccfhoE2dUzos2zz8skl+lX3p
         FYB3sUv8ksSqOKLIwtqGOhrEkG07v19FpKytBxegOFpPJ2vgtpN9R1DM8wTIL6DrZlAR
         fe+HTSI4QC1BzH0sGqaJlCD+wYAEFwCY9Nef7ZNBMNbYSE4LXTCjGIfgeUddYh5tGj9z
         4h+uMATRUKZZVivKTWALooAaVv1uh3cdq6qOQRHgZDoIIl9oWMkr8y2StcAlUUQdjBad
         dgnFa7kQjtuikkJ13UulhMJc+MOAT7n6sa7QS2EsE3nfyQN2UCNabzvdArTLSd0CrOPT
         5bYg==
X-Gm-Message-State: AFqh2kp7shkKfQnr7KJjX8TESyQmt78TM2uuzdl5DJVEueb1eHu2qjYe
        rJNZXuHdrpt4ndX11tuar3a+E7C+1z/ksocwfrF4+JfSotv0q0Xv+I96yLEYDtW+IFrzDu+Pt5D
        dD5ACuBp4jwHeEcc7XYHi6jq5KG+kYICx
X-Received: by 2002:aca:1111:0:b0:35e:7a42:7ab5 with SMTP id 17-20020aca1111000000b0035e7a427ab5mr1311565oir.280.1672227847861;
        Wed, 28 Dec 2022 03:44:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuZET8YtyOHtUA69u8b4mtI9mTXpOsgMPK2i7Rp8Qb9ZkpLhrS/iL2qb8kuQphVO3IvX1F6toQuOlLgFg8gWDI=
X-Received: by 2002:aca:1111:0:b0:35e:7a42:7ab5 with SMTP id
 17-20020aca1111000000b0035e7a427ab5mr1311558oir.280.1672227847622; Wed, 28
 Dec 2022 03:44:07 -0800 (PST)
MIME-Version: 1.0
References: <20221226074908.8154-1-jasowang@redhat.com> <20221226074908.8154-5-jasowang@redhat.com>
 <1672107557.0142956-1-xuanzhuo@linux.alibaba.com> <CACGkMEvzhAFj5HCmP--9DKfCAq_4wPNwsmmg4h0Sbv6ra0+DrQ@mail.gmail.com>
 <1672216748.7057884-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1672216748.7057884-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 28 Dec 2022 19:43:56 +0800
Message-ID: <CACGkMEtr7r25s6Tgsj=fcw3MD3ShLmuuVHvx0WVNiQHyV_G=zw@mail.gmail.com>
Subject: Re: [PATCH 4/4] virtio-net: sleep instead of busy waiting for cvq command
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, eperezma@redhat.com,
        edumazet@google.com, maxime.coquelin@redhat.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, mst@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 4:40 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Tue, 27 Dec 2022 12:33:53 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > On Tue, Dec 27, 2022 at 10:25 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > On Mon, 26 Dec 2022 15:49:08 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > > We used to busy waiting on the cvq command this tends to be
> > > > problematic since:
> > > >
> > > > 1) CPU could wait for ever on a buggy/malicous device
> > > > 2) There's no wait to terminate the process that triggers the cvq
> > > >    command
> > > >
> > > > So this patch switch to use virtqueue_wait_for_used() to sleep with a
> > > > timeout (1s) instead of busy polling for the cvq command forever. This
> > >
> > > I don't think that a fixed 1S is a good choice.
> >
> > Well, it could be tweaked to be a little bit longer.
> >
> > One way, as discussed, is to let the device advertise a timeout then
> > the driver can validate if it's valid and use that timeout. But it
> > needs extension to the spec.
> >
> > > Some of the DPUs are very
> > > lazy for cvq handle.
> >
> > Such design needs to be revisited, cvq (control path) should have a
> > better priority or QOS than datapath.
> >
> > > In particular, we will also directly break the device.
> >
> > It's kind of hardening for malicious devices.
>
> Just based on timeout, it is judged that it is a malicious device. I think it is
> too arbitrary.

Drivers have very little information to make the decision. So it's
really a balance.

We can start with a very long timeout like 10 minutes. Otherwise a
buggy/malicious device will block a lot of important things (reboot,
modprobe) even if the scheduler is still functional.

Thanks

>
> Thanks.
>
>
> >
> > >
> > > I think it is necessary to add a Virtio-Net parameter to allow users to define
> > > this timeout by themselves. Although I don't think this is a good way.
> >
> > Very hard and unfriendly to the end users.
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > >
> > > > gives the scheduler a breath and can let the process can respond to
> > > > asignal. If the device doesn't respond in the timeout, break the
> > > > device.
> > > >
> > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > > Changes since V1:
> > > > - break the device when timeout
> > > > - get buffer manually since the virtio core check more_used() instead
> > > > ---
> > > >  drivers/net/virtio_net.c | 24 ++++++++++++++++--------
> > > >  1 file changed, 16 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index efd9dd55828b..6a2ea64cfcb5 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -405,6 +405,7 @@ static void disable_rx_mode_work(struct virtnet_info *vi)
> > > >       vi->rx_mode_work_enabled = false;
> > > >       spin_unlock_bh(&vi->rx_mode_lock);
> > > >
> > > > +     virtqueue_wake_up(vi->cvq);
> > > >       flush_work(&vi->rx_mode_work);
> > > >  }
> > > >
> > > > @@ -1497,6 +1498,11 @@ static bool try_fill_recv(struct virtnet_info *vi, struct receive_queue *rq,
> > > >       return !oom;
> > > >  }
> > > >
> > > > +static void virtnet_cvq_done(struct virtqueue *cvq)
> > > > +{
> > > > +     virtqueue_wake_up(cvq);
> > > > +}
> > > > +
> > > >  static void skb_recv_done(struct virtqueue *rvq)
> > > >  {
> > > >       struct virtnet_info *vi = rvq->vdev->priv;
> > > > @@ -1984,6 +1990,8 @@ static int virtnet_tx_resize(struct virtnet_info *vi,
> > > >       return err;
> > > >  }
> > > >
> > > > +static int virtnet_close(struct net_device *dev);
> > > > +
> > > >  /*
> > > >   * Send command via the control virtqueue and check status.  Commands
> > > >   * supported by the hypervisor, as indicated by feature bits, should
> > > > @@ -2026,14 +2034,14 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
> > > >       if (unlikely(!virtqueue_kick(vi->cvq)))
> > > >               return vi->ctrl->status == VIRTIO_NET_OK;
> > > >
> > > > -     /* Spin for a response, the kick causes an ioport write, trapping
> > > > -      * into the hypervisor, so the request should be handled immediately.
> > > > -      */
> > > > -     while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> > > > -            !virtqueue_is_broken(vi->cvq))
> > > > -             cpu_relax();
> > > > +     if (virtqueue_wait_for_used(vi->cvq)) {
> > > > +             virtqueue_get_buf(vi->cvq, &tmp);
> > > > +             return vi->ctrl->status == VIRTIO_NET_OK;
> > > > +     }
> > > >
> > > > -     return vi->ctrl->status == VIRTIO_NET_OK;
> > > > +     netdev_err(vi->dev, "CVQ command timeout, break the virtio device.");
> > > > +     virtio_break_device(vi->vdev);
> > > > +     return VIRTIO_NET_ERR;
> > > >  }
> > > >
> > > >  static int virtnet_set_mac_address(struct net_device *dev, void *p)
> > > > @@ -3526,7 +3534,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > > >
> > > >       /* Parameters for control virtqueue, if any */
> > > >       if (vi->has_cvq) {
> > > > -             callbacks[total_vqs - 1] = NULL;
> > > > +             callbacks[total_vqs - 1] = virtnet_cvq_done;
> > > >               names[total_vqs - 1] = "control";
> > > >       }
> > > >
> > > > --
> > > > 2.25.1
> > > >
> > > > _______________________________________________
> > > > Virtualization mailing list
> > > > Virtualization@lists.linux-foundation.org
> > > > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> > >
> >
>

