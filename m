Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6602F6567CD
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiL0HW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiL0HWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:22:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B634E219
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672125697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mEGiwEleRJj+ufJewl6x7iIcOZ+c/dqTegBY8jJTLFw=;
        b=L1kUG8gqR+YiLxdldeCobYEiq7KamA1OpgwIwEHanIrSbtdwbErGu7LfhYOA+UKGz/eQXg
        iOGVlaq8HquhrbLNAwCiVI7w6KwvWGUVsq7yOKG0kUroJOhYmmVvuRaV8GrqTTCP7769hi
        5tSylBgFKOrRyJrwxK1LVgzPCx7DZvg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-548-rMtdu_bWO2ufOapy-RP4TA-1; Tue, 27 Dec 2022 02:21:35 -0500
X-MC-Unique: rMtdu_bWO2ufOapy-RP4TA-1
Received: by mail-wm1-f71.google.com with SMTP id q19-20020a1cf313000000b003d96c95e2f9so2424496wmq.2
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:21:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEGiwEleRJj+ufJewl6x7iIcOZ+c/dqTegBY8jJTLFw=;
        b=gtOVZq+BQCIeysopKBwq3eZs4mHNdbYwj+9fS7T6wmhfVTUXUgnBmOS/NMSoqIAUTc
         P91k7ZyJ2d9Em7BApHF3eNtqtGBUiIDnBVaJYAHaNUTcn7tS6oiFDLiCcRIk7hf1puVy
         116BG5EMqtFhVg4lf+1N4T7yTyOZfb80EX40+rk4SYvAtVTrXPMyVeMWYWhr7ycHRX7T
         jvfSbiYgLRoNtJ0e2N1e4r24+3x7clgN8jnSknT3SKDnozOOTBWArGcf44DcfLA9OUzx
         3+RAXwrkIyLLewDbiniNN68p7h9UUriOl3wrFiEQd5yrdzvFKmK3LyJewWqfhUx15LHS
         6/vg==
X-Gm-Message-State: AFqh2ko3Fm8QAwZlyHupU6zWjoCKvL8iTA7arcmr6vZTSS3SHcHQwZUb
        Tzpl9m49XSItuMXJ9zekf1Qd7GvtlF/ET8iCAh/jfCWUALXa1+ovM0ujbXqBUnMXrMOQ7tsMGQ3
        wKoeugkyZdb+MYP+f
X-Received: by 2002:adf:f590:0:b0:242:5cf0:2039 with SMTP id f16-20020adff590000000b002425cf02039mr12492846wro.65.1672125694477;
        Mon, 26 Dec 2022 23:21:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuzh/P3fMBgyffaJ+4YZm0UK7XcBjHgCs292arRQNyOfui9FBsi2J7c84AHLr0LcmbmmOOkNQ==
X-Received: by 2002:adf:f590:0:b0:242:5cf0:2039 with SMTP id f16-20020adff590000000b002425cf02039mr12492831wro.65.1672125694253;
        Mon, 26 Dec 2022 23:21:34 -0800 (PST)
Received: from redhat.com ([2.52.151.85])
        by smtp.gmail.com with ESMTPSA id t15-20020a5d534f000000b002365254ea42sm12143624wrv.1.2022.12.26.23.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 23:21:33 -0800 (PST)
Date:   Tue, 27 Dec 2022 02:21:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 2/4] virtio_ring: switch to use BAD_RING()
Message-ID: <20221227022023-mutt-send-email-mst@kernel.org>
References: <20221226074908.8154-1-jasowang@redhat.com>
 <20221226074908.8154-3-jasowang@redhat.com>
 <20221226183604-mutt-send-email-mst@kernel.org>
 <CACGkMEuv9+o4anxnE8xewEaFj5Sc+bn4OFDrHYR6jyxb+3ApGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEuv9+o4anxnE8xewEaFj5Sc+bn4OFDrHYR6jyxb+3ApGw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 27, 2022 at 11:51:02AM +0800, Jason Wang wrote:
> On Tue, Dec 27, 2022 at 7:36 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 26, 2022 at 03:49:06PM +0800, Jason Wang wrote:
> > > Switch to reuse BAD_RING() to allow common logic to be implemented in
> > > BAD_RING().
> > >
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > > Changes since V1:
> > > - switch to use BAD_RING in virtio_break_device()
> > > ---
> > >  drivers/virtio/virtio_ring.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index 2e7689bb933b..5cfb2fa8abee 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -58,7 +58,8 @@
> > >       do {                                                    \
> > >               dev_err(&_vq->vq.vdev->dev,                     \
> > >                       "%s:"fmt, (_vq)->vq.name, ##args);      \
> > > -             (_vq)->broken = true;                           \
> > > +             /* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \
> >
> > I don't think WRITE_ONCE/READ_ONCE pair as such. Can you point
> > me at documentation of such pairing?
> 
> Introduced by:
> 
> commit 60f0779862e4ab943810187752c462e85f5fa371
> Author: Parav Pandit <parav@nvidia.com>
> Date:   Wed Jul 21 17:26:45 2021 +0300
> 
>     virtio: Improve vq->broken access to avoid any compiler optimization
> 
> I think it might still apply here since virtqueue_is_broken() is still
> put into a loop inside wait_event().
> 
> Thanks

Oh I see. Maybe it's a response to some discussion we had at the time,
at this point I can no longer say what it meant.
But you are doing right not changing it here of course.

> >
> > > +             WRITE_ONCE((_vq)->broken, true);                       \
> > >       } while (0)
> > >  #define START_USE(vq)
> > >  #define END_USE(vq)
> > > @@ -2237,7 +2238,7 @@ bool virtqueue_notify(struct virtqueue *_vq)
> > >
> > >       /* Prod other side to tell it about changes. */
> > >       if (!vq->notify(_vq)) {
> > > -             vq->broken = true;
> > > +             BAD_RING(vq, "vq %d is broken\n", vq->vq.index);
> > >               return false;
> > >       }
> > >       return true;
> > > @@ -2786,8 +2787,7 @@ void virtio_break_device(struct virtio_device *dev)
> > >       list_for_each_entry(_vq, &dev->vqs, list) {
> > >               struct vring_virtqueue *vq = to_vvq(_vq);
> > >
> > > -             /* Pairs with READ_ONCE() in virtqueue_is_broken(). */
> > > -             WRITE_ONCE(vq->broken, true);
> > > +             BAD_RING(vq, "Device break vq %d", _vq->index);
> > >       }
> > >       spin_unlock(&dev->vqs_list_lock);
> > >  }
> > > --
> > > 2.25.1
> >

